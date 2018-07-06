module PhysicsTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Physics exposing (tick, stillObject)


suite : Test
suite =
    describe "The Physics module"
        [ describe "Physics.tick"
            [ test "position stays the same for an object with no velocity or acceleration" <|
                \_ ->
                    let
                        pos =
                            { x = 3, y = 4 }

                        startingObject =
                            stillObject pos { width = 5, height = 5 }
                    in
                        Expect.equal (tick startingObject) startingObject
            , test "y momentum falls for an object under gravity" <|
                \_ ->
                    let
                        startingObject =
                            { dims = { width = 5, height = 5 }, pos = { x = 3, y = 4 }, vel = { x = 0, y = 0 }, accel = { x = 0, y = -1 } }
                    in
                        Expect.equal (tick startingObject) ({ startingObject | vel = { x = 0, y = -1 } })
            ]
        ]
