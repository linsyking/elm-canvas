module Canvas.Internal.Canvas exposing
    ( DrawOp(..)
    , Drawable(..)
    , PathSegment(..)
    , Point
    , Renderable(..)
    , Setting(..)
    , Shape(..)
    , Text
    , TextBox
    )

import Canvas.Internal.CustomElementJsonApi as C exposing (Commands)
import Canvas.Texture exposing (Texture)


type alias Point =
    ( Float, Float )


type Setting
    = SettingCommand C.Command
    | SettingCommands C.Commands
    | SettingDrawOp DrawOp
    | SettingUpdateDrawable (Drawable -> Drawable)


type DrawOp
    = NotSpecified
    | Fill C.Style
    | Stroke C.Style
    | FillAndStroke C.Style C.Style


type Drawable
    = DrawableText Text
    | DrawableTextBox TextBox
    | DrawableShapes (List Shape)
    | DrawableTexture Point Texture
    | DrawableClear Point Float Float
    | DrawableGroup (List Renderable)
    | DrawableEmpty


type alias TextBox =
    { point : Point
    , size : ( Float, Float )
    , text : String
    , align : String
    , baseLine : String
    , fontSize : Float
    , font : String
    , fontStyle : String
    , fontVariant : String
    , fontWeight : String
    , lineHeight : Float
    , justify : Bool
    }


type Renderable
    = Renderable
        { commands : Commands
        , drawOp : DrawOp
        , drawable : Drawable
        }


type alias Text =
    { maxWidth : Maybe Float, point : Point, text : String }


type Shape
    = Rect Point Float Float
    | RoundRect Point Float Float (List Float)
    | Circle Point Float
    | Path Point (List PathSegment)
    | Arc Point Float Float Float Bool


type PathSegment
    = ArcTo Point Point Float
    | BezierCurveTo Point Point Point
    | LineTo Point
    | MoveTo Point
    | QuadraticCurveTo Point Point
