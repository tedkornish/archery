module Main exposing (..)

import Json.Decode exposing (Decoder)
import Html exposing (..)
import Physics exposing (Object, tick)
import Time exposing (Time, second)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Mouse exposing (Position)
import Events exposing (mouseEventDecoder)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { objects : List Object
    , mousePosition : Position
    , dragStart : Maybe Position
    }


newObjectAt : Position -> Object
newObjectAt pos =
    { pos = { x = toFloat pos.x, y = toFloat pos.y }
    , vel = { x = 0, y = 0 }
    , accel = { x = 0, y = 0.6 } -- gravity
    , dims = { width = 50, height = 50 }
    }


initialModel : Model
initialModel =
    { mousePosition = { x = 0, y = 0 }
    , dragStart = Nothing
    , objects =
        [ { pos = { x = 0, y = 0 }
          , vel = { x = 12, y = -1 }
          , accel = { x = 0, y = 0.6 }
          , dims = { width = 50, height = 50 }
          }
        , { pos = { x = 0, y = 0 }
          , vel = { x = 15, y = -1 }
          , accel = { x = 0, y = 0.6 }
          , dims = { width = 50, height = 50 }
          }
        ]
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | MouseDown Position
    | MouseUp Position
    | MouseMove Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model | objects = List.map tick model.objects }, Cmd.none )

        MouseDown pos ->
            ( { model | dragStart = Just pos }, Cmd.none )

        MouseUp pos ->
            let
                objects =
                    if (Just model.mousePosition) == model.dragStart then
                        (newObjectAt pos) :: model.objects
                    else
                        model.objects
            in
                ( { model | dragStart = Nothing, objects = objects }, Cmd.none )

        MouseMove pos ->
            ( { model | mousePosition = pos }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 20 Tick ]



-- VIEW


viewObjects : Object -> Svg Msg
viewObjects obj =
    rect
        [ x (toString obj.pos.x)
        , y (toString obj.pos.y)
        , width (toString obj.dims.width)
        , height (toString obj.dims.height)
        ]
        []


getMousePositionString : Position -> String
getMousePositionString { x, y } =
    "(" ++ toString x ++ "," ++ toString y ++ ")"


getDragLine : Position -> Maybe Position -> List (Svg.Svg msg)
getDragLine current maybeOrigin =
    case maybeOrigin of
        Just origin ->
            [ line
                [ x1 (toString origin.x)
                , y1 (toString origin.y)
                , x2 (toString current.x)
                , y2 (toString current.y)
                , strokeWidth "1"
                , stroke "black"
                ]
                []
            ]

        Nothing ->
            []


view : Model -> Html Msg
view model =
    svg
        [ width "100%"
        , height "100%"
        , on "mousedown" (mouseEventDecoder (\coords -> MouseDown coords))
        , on "mouseup" (mouseEventDecoder (\coords -> MouseUp coords))
        , on "mousemove" (mouseEventDecoder (\coords -> MouseMove coords))
        ]
        (List.concat
            [ (List.map viewObjects model.objects)
            , getDragLine model.mousePosition model.dragStart
            , [ Svg.text_
                    [ x "20", y "30" ]
                    [ getMousePositionString model.mousePosition |> Svg.text ]
              ]
            ]
        )
