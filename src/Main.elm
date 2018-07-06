module Main exposing (..)

import Html exposing (..)
import Physics exposing (Object, tick)
import Time exposing (Time, second)
import Svg exposing (..)
import Svg.Attributes exposing (..)


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


initialModel : Model
initialModel =
    { objects =
        [ { pos = { x = 0, y = -300 }
          , vel = { x = 12, y = -1 }
          , accel = { x = 0, y = 0.6 }
          , dims = { width = 50, height = 50 }
          }
        , { pos = { x = 0, y = -300 }
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model | objects = List.map tick model.objects }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 20 Tick



-- VIEW


viewObjects : Object -> Svg Msg
viewObjects obj =
    rect
        [ x (toString (obj.pos.x + 500)) -- +500 moves towards center
        , y (toString (obj.pos.y + 500))
        , width (toString obj.dims.width)
        , height (toString obj.dims.height)
        ]
        []


view : Model -> Html Msg
view model =
    svg
        [ width "100%", height "100%", viewBox "0 0 1000 1000" ]
        (List.map viewObjects model.objects)
