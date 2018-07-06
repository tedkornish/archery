module Events exposing (mouseEventDecoder)

import Json.Decode as Decode exposing (Decoder, map2, field)
import Mouse exposing (Position)


mouseEventDecoder : (Position -> a) -> Decoder a
mouseEventDecoder f =
    Decode.map
        f
        (map2 Position
            (field "layerX" Decode.int)
            (field "layerY" Decode.int)
        )
