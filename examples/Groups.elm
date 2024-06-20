module Groups exposing (main)

import Browser
import Browser.Events exposing (onAnimationFrameDelta)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Canvas.Settings.Line exposing (..)
import Canvas.Settings.Text exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes
import Random
import Time exposing (Posix)


main : Program Float Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


subscriptions : Model -> Sub Msg
subscriptions _ =
    onAnimationFrameDelta AnimationFrame


h : number
h =
    500


w : number
w =
    500


padding : number
padding =
    20


type alias Model =
    Int


type Msg
    = AnimationFrame Float


init : Float -> ( Model, Cmd Msg )
init floatSeed =
    ( 0
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimationFrame _ ->
            ( model + 1
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Canvas.toHtml ( w, h )
        []
        [ group []
            [ shapes [ fill Color.white ] [ rect ( 0, 0 ) w h ]
            , textbox []
                { point = ( 100, 50 )
                , size = ( 200, 100 )
                , text = "Hi, this is a test. Looks like it can break a sentence into multiple lines automatically."
                , align = Nothing
                , baseLine = Nothing
                , fontSize = Nothing
                , font = Just "Courier New"
                , fontStyle = Nothing
                , fontVariant = Nothing
                , fontWeight = Nothing
                , lineHeight = Nothing
                , justify = Nothing
                }
            ]
        , group [ fill Color.red ]
            [ shapes [] [ rect ( w / 4 - 20, h / 3 - 20 ) 40 40 ]
            , text
                [ font { style = "", size = 48, family = "sans-serif" }
                , align Center
                ]
                ( w / 4, h / 3 * 2 - 24 )
                (String.fromInt model)
            ]
        , group [ stroke Color.darkYellow, lineWidth 2 ]
            [ group []
                [ shapes [] [ rect ( w / 4 * 2 - 20, h / 3 - 20 ) 40 40 ]
                , text
                    [ font { style = "", size = 48, family = "sans-serif" }
                    , align Center
                    ]
                    ( w / 4 * 2, h / 3 * 2 - 24 )
                    (String.fromInt model)
                ]
            , group [ fill Color.blue ]
                [ shapes [] [ rect ( w / 4 * 3 - 20, h / 3 - 20 ) 40 40 ]
                , text
                    [ font { style = "", size = 48, family = "sans-serif" }
                    , align Center
                    ]
                    ( w / 4 * 3, h / 3 * 2 - 24 )
                    (String.fromInt model)
                ]
            ]
        ]
