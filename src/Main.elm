module Main exposing (..)

import Json.Decode as Decode exposing (Decoder, map2, field)
import Html exposing (..)
import Physics exposing (Object, tick)
import Time exposing (Time, second)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Mouse exposing (Position)


--import Html.Attributes exposing (..)
--import Html.Events exposing (onClick)


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
    { objects : List Object }


newObjectAt : Position -> Object
newObjectAt pos =
    { pos = { x = toFloat pos.x, y = toFloat pos.y }
    , vel = { x = 12, y = -1 }
    , accel = { x = 0, y = 0.6 }
    , dims = { width = 50, height = 50 }
    }


initialModel : Model
initialModel =
    { objects =
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


clickDecoder : Decoder Msg
clickDecoder =
    Decode.map
        (\pos -> Click pos)
        (map2 Position
            (field "layerX" Decode.int)
            (field "layerY" Decode.int)
        )


type Msg
    = Tick Time
    | Click Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model | objects = List.map tick model.objects }, Cmd.none )

        Click pos ->
            ( { model | objects = (newObjectAt pos) :: model.objects }, Cmd.none )



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


view : Model -> Html Msg
view model =
    svg
        [ width "100%"
        , height "100%"
        , viewBox "0 0 1000 1000"
        , on "click" clickDecoder
        ]
        (List.map viewObjects model.objects)
