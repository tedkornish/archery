module PhysicsTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Physics exposing (tick)


suite : Test
suite =
    describe "The Physics module"
        [ describe "Physics.tick"
            [ test "position stays the same for an object with no momentum" <|
                \_ ->
                    let
                        emptyVelocities =
                            { x = 0, y = 0 }

                        pos =
                            { x = 3, y = 4 }

                        startingObject =
                            { pos = pos, vel = emptyVelocities }
                    in
                        Expect.equal (tick startingObject) startingObject
            ]
        ]
