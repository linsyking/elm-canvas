module NewApiTest exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Advanced exposing (..)
import Canvas.Settings.Line exposing (..)
import Canvas.Settings.Text exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes as Attributes
import Random
import Time exposing (Posix)


main : Program () ( Float, Float ) Float
main =
    Browser.element
        { init = \_ -> ( ( 0, 0 ), Cmd.none )
        , update = \dt ( count, fps ) -> ( ( count + 1, 1000 / dt ), Cmd.none )
        , subscriptions = \_ -> onAnimationFrameDelta identity
        , view = view
        }


w =
    500


h =
    500


step =
    20


view ( count, fps ) =
    Canvas.toHtml
        ( w, h )
        [ Attributes.style "border" "2px solid red" ]
        [ clear ( 0, 0 ) w h
        , shapes [ fill Color.white ] [ rect ( 60, 60 ) 30 30 ]
        , shapes
            [ lineWidth 5
            , transform [ translate (w / 2) (h / 2), rotate (degrees (sin (count / 100) * 360)) ]
            , fill Color.red
            , stroke Color.green
            ]
            [ rect ( -100, -150 ) 40 50
            , circle ( 100, 100 ) 80
            ]
        , text
            [ align Right
            , font { style = "", size = 30, family = "sans-serif" }
            , lineWidth 1
            , stroke Color.blue
            , fill Color.green
            ]
            ( w - 50, 50 )
            ("fps: " ++ String.fromInt (floor fps))
        , shapes []
            [ path ( 20, 10 )
                [ lineTo ( 10, 30 )
                , lineTo ( 30, 30 )
                , lineTo ( 20, 10 )
                ]
            , circle ( 50, 50 ) 10
            ]
        , shapes
            [ fill Color.lightPurple
            , transform [ translate 10 400 ]
            ]
            (List.range 0 10
                |> List.concatMap
                    (\i ->
                        let
                            (( x, y ) as center) =
                                ( toFloat i * 40 + 40, 0 )

                            radius =
                                20

                            startAngle =
                                degrees -45

                            endAngle =
                                degrees 45
                        in
                        if (i |> modBy 4) < 2 then
                            [ arc
                                center
                                radius
                                { startAngle = startAngle
                                , endAngle = endAngle
                                , clockwise = modBy 2 i == 0
                                }
                            ]

                        else
                            [ path center
                                [ lineTo ( x + radius * cos startAngle, y + radius * sin startAngle )
                                , lineTo ( x + radius * cos endAngle, y + radius * sin endAngle )
                                , lineTo center
                                ]
                            , arc
                                center
                                radius
                                { startAngle = startAngle
                                , endAngle = endAngle
                                , clockwise = modBy 2 i == 0
                                }
                            ]
                    )
            )
        ]
