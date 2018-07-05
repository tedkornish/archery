module Physics
    exposing
        ( tick
        , stillObject
        , Object
        , Coordinates
        )


type alias Object =
    { pos : Coordinates, vel : Coordinates, accel : Coordinates }


type alias Coordinates =
    { x : Int, y : Int }


emptyCoords : Coordinates
emptyCoords =
    { x = 0, y = 0 }


stillObject : Coordinates -> Object
stillObject startingCoords =
    { pos = startingCoords, vel = emptyCoords, accel = emptyCoords }


tick : Object -> Object
tick obj =
    { obj
        | pos = { x = obj.pos.x + obj.vel.x, y = obj.pos.y + obj.vel.y }
        , vel = { x = obj.vel.x + obj.accel.x, y = obj.vel.y + obj.accel.y }
    }
