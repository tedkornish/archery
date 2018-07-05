module Physics exposing (tick)


type alias Object =
    { pos : Position, vel : Velocities }


type alias Position =
    { x : Int, y : Int }


type alias Velocities =
    { x : Int, y : Int }


tick : Object -> Object
tick obj =
    { obj
        | pos = { x = obj.pos.x + obj.vel.x, y = obj.pos.y + obj.vel.y }
    }
