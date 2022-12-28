module Canvas.Settings.Advanced exposing
    ( shadow, Shadow
    , fillLinear, fillRadial, strokeLinear, strokeRadial, LinearGradient, RadialGradient
    , transform, Transform(..), translate, rotate, scale, applyMatrix
    , alpha, imageSmoothing, compositeOperationMode, GlobalCompositeOperationMode(..)
    )

{-|


# Advanced rendering settings

The following are settings that you can apply, to create very specific and
custom effects.


## Gradient

The gradient setting allows you to use linear or radial gradients for fill or stroke.

@docs LinearGradient, RadialGradient, fillLinear, fillRadial, strokeLinear, strokeRadial


## Shadows

The shadow setting allows you to create a shadow for a renderable, similar to
what the `box-shadow` CSS does to HTML elements.

A word of caution, shadows have a non-trivial performance cost, so use them
wisely.

@docs shadow, Shadow


## Transforms: scaling, rotating, translating, and matrix transformations

Transforms are very useful as they allow you to manipulate the rendering via
a transformation matrix, allowing you to translate, scale, rotate and skew the
rendering context easily. They can be a bit of an advanced topic, but they are
powerful and can be very useful.

When using transforms, keep in mind you are working on the global coordinate
system, since it very hard to know what the center of your shape is to give
sensible defaults.

@docs transform, Transform, translate, rotate, scale, applyMatrix


## Alpha, image smoothing and global composite mode

Finally, there are a couple of other settings that you can use to create
interesting visual effects:

@docs alpha, imageSmoothing, compositeOperationMode, GlobalCompositeOperationMode

-}

import Canvas.Internal.Canvas as C exposing (..)
import Canvas.Internal.CustomElementJsonApi as CE
import Color exposing (Color)



-- Advanced rendering settings
-- Global style settings


{-| Type of compositing operation, identifying which of the compositing or
blending mode operations to use. See the chapter
[Compositing](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial/Compositing)
from the Canvas Tutorial.

For more information and pictures of what each mode does, see the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/globalCompositeOperation).

-}
type GlobalCompositeOperationMode
    = SourceOver
    | SourceIn
    | SourceOut
    | SourceAtop
    | DestinationOver
    | DestinationIn
    | DestinationOut
    | DestinationAtop
    | Lighter
    | Copy
    | Xor
    | Multiply
    | Screen
    | Overlay
    | Darken
    | Lighten
    | ColorDodge
    | ColorBurn
    | HardLight
    | SoftLight
    | Difference
    | Exclusion
    | Hue
    | Saturation
    | Color
    | Luminosity


globalCompositeOperationModeToString : GlobalCompositeOperationMode -> String
globalCompositeOperationModeToString mode =
    case mode of
        SourceOver ->
            "source-over"

        SourceIn ->
            "source-in"

        SourceOut ->
            "source-out"

        SourceAtop ->
            "source-atop"

        DestinationOver ->
            "destination-over"

        DestinationIn ->
            "destination-in"

        DestinationOut ->
            "destination-out"

        DestinationAtop ->
            "destination-atop"

        Lighter ->
            "lighter"

        Copy ->
            "copy"

        Xor ->
            "xor"

        Multiply ->
            "multiply"

        Screen ->
            "screen"

        Overlay ->
            "overlay"

        Darken ->
            "darken"

        Lighten ->
            "lighten"

        ColorDodge ->
            "color-dodge"

        ColorBurn ->
            "color-burn"

        HardLight ->
            "hard-light"

        SoftLight ->
            "soft-light"

        Difference ->
            "difference"

        Exclusion ->
            "exclusion"

        Hue ->
            "hue"

        Saturation ->
            "saturation"

        Color ->
            "color"

        Luminosity ->
            "luminosity"


{-| Record with the settings for a shadow.

  - `blur`: Amount of blur for the shadow
  - `color`: `Color` of the shadow (from avh4/elm-color)
  - `offset`: `( xOffset, yOffset )`

-}
type alias Shadow =
    { blur : Float, color : Color, offset : ( Float, Float ) }


{-| Specify a shadow to be rendered. See the `Shadow` type alias to know what
parameters to pass.
-}
shadow : Shadow -> Setting
shadow { blur, color, offset } =
    let
        ( x, y ) =
            offset
    in
    SettingCommands
        [ CE.shadowBlur blur
        , CE.shadowColor color
        , CE.shadowOffsetX x
        , CE.shadowOffsetY y
        ]


{-| Linear gradient definition.

  - `x0`, `y0`: top left corner of the gradient
  - `x1`, `y1`: bottom right corner of the gradient

-}
type alias LinearGradient =
    { x0 : Float, y0 : Float, x1 : Float, y1 : Float }


{-| Radial gradient definition.

  - `x0`, `y0`: top left corner of the gradient
  - `x1`, `y1`: bottom right corner of the gradient
  - `rad0`: inner radius of the gradient
  - `rad1`: outer radius of the gradient

-}
type alias RadialGradient =
    { x0 : Float, y0 : Float, rad0 : Float, x1 : Float, y1 : Float, rad1 : Float }


{-| Fill with linear gradient.

  - `x0`, `y0`: top left corner of the gradient
  - `x1`, `y1`: bottom right corner of the gradient
  - `stops`: `( offset, color )`
    - offset is a float number from 0 to 1, so the horizontal position of the stop
    - where color is the `Color` of given stop (from avh4/elm-color)

-}
fillLinear : LinearGradient -> List (Float, Color) -> Setting
fillLinear spec stops =
    SettingDrawOp
        <| C.Fill
        <| CE.LinearGradient spec
        <| stops


{-| Fill with radial gradient.

  - `x0`, `y0`: top left corner of the gradient
  - `x1`, `y1`: bottom right corner of the gradient
  - `rad0`: inner radius of the gradient
  - `rad1`: outer radius of the gradient
  - `stops`: `( offset, color )`
    - offset is a float number from 0 to 1, so the horizontal position of the stop
    - where color is the `Color` of given stop (from avh4/elm-color)

-}
fillRadial : RadialGradient -> List (Float, Color) -> Setting
fillRadial spec stops =
    SettingDrawOp
        <| C.Fill
        <| CE.RadialGradient spec
        <| stops


{-| Stroke with linear gradient.

  - `x0`, `y0`: top left corner of the gradient
  - `x1`, `y1`: bottom right corner of the gradient
  - `stops`: `( offset, color )`
    - offset is a float number from 0 to 1, so the horizontal position of the stop
    - where color is the `Color` of given stop (from avh4/elm-color)

-}
strokeLinear : LinearGradient -> List (Float, Color) -> Setting
strokeLinear spec stops =
    SettingDrawOp
        <| C.Stroke
        <| CE.LinearGradient spec
        <| stops


{-| Stroke with radial gradient.

  - `x0`, `y0`: top left corner of the gradient
  - `x1`, `y1`: bottom right corner of the gradient
  - `rad0`: inner radius of the gradient
  - `rad1`: outer radius of the gradient
  - `stops`: `( offset, color )`
    - offset is a float number from 0 to 1, so the horizontal position of the stop
    - where color is the `Color` of given stop (from avh4/elm-color)

-}
strokeRadial : RadialGradient -> List (Float, Color) -> Setting
strokeRadial spec stops =
    SettingDrawOp
        <| C.Stroke
        <| CE.RadialGradient spec
        <| stops


{-| Specifies the alpha value that is applied before renderables are drawn onto
the canvas. The value is in the range from 0.0 (fully transparent) to 1.0 (fully
opaque). The default value is 1.0. Values outside the range, including
`Infinity` and `NaN` will not be set and alpha will remain default.
-}
alpha : Float -> Setting
alpha a =
    CE.globalAlpha a |> SettingCommand


{-| Specify the type of compositing operation to apply when drawing new
entities, where type is a `GlobalCompositeOperationMode` identifying which of
the compositing or blending mode operations to use.

See `GlobalCompositeOperationMode` below for more information.

    compositeOperationMode Screen

-}
compositeOperationMode : GlobalCompositeOperationMode -> Setting
compositeOperationMode mode =
    mode |> globalCompositeOperationModeToString |> CE.globalCompositeOperation |> SettingCommand


{-| Specify if scaled images are smoothed (default) or not.

This property is useful for games and other apps that use pixel art. When
enlarging images, the default resizing algorithm will blur the pixels. Set this
property to false to retain the pixels' sharpness.

-}
imageSmoothing : Bool -> Setting
imageSmoothing enabled =
    SettingCommand (CE.globalImageSmoothingEnabled enabled)



-- Transforms


{-| Type of transform to apply to the matrix, to be used in `transform`. See the
functions below to learn how to create transforms.
-}
type Transform
    = Rotate Float
    | Scale Float Float
    | Translate Float Float
    | ApplyMatrix
        { m11 : Float
        , m12 : Float
        , m21 : Float
        , m22 : Float
        , dx : Float
        , dy : Float
        }


{-| Specify the transform matrix to apply when drawing. You do so by applying
transforms in order, like `translate`, `rotate`, or `scale`, but you can also
use `applyMatrix` and set the matrix yourself manually if you know what you are
doing.

    shapes
        [ transform [ rotate (degrees 50) ] ]
        [ rect ( 40, 40 ) 20 20 ]

-}
transform : List Transform -> Setting
transform transforms =
    SettingCommands <|
        List.map
            (\t ->
                case t of
                    Rotate angle ->
                        CE.rotate angle

                    Scale x y ->
                        CE.scale x y

                    Translate x y ->
                        CE.translate x y

                    ApplyMatrix { m11, m12, m21, m22, dx, dy } ->
                        CE.transform m11 m12 m21 m22 dx dy
            )
            transforms


{-| Adds a rotation to the transformation matrix. The `angle` argument
represents a clockwise rotation angle and is expressed in radians. Use the core
function `degrees` to make it easier to represent the rotation.

    rotate (degrees 90)

The rotation center point is always the canvas origin. To change the center
point, we will need to move the canvas by using the `translate` transform before
rotating. For example, a very common use case to rotate from a specific point in
the canvas, maybe the center of your renderable, would be done by translating to
that point, rotating, and then translating back, if you want to apply more
transformations. Like this:

    transform
        [ translate x y
        , rotate rotation
        , translate -x -y

        {- Other transforms -}
        ]

See the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/rotate)
for more information and examples.

-}
rotate : Float -> Transform
rotate =
    Rotate


{-| Adds a scaling transformation to the canvas units by `x` horizontally and by
`y` vertically.

By default, one unit on the canvas is exactly one pixel. If we apply, for
instance, a scaling factor of 0.5, the resulting unit would become 0.5 pixels
and so shapes would be drawn at half size. In a similar way setting the scaling
factor to 2.0 would increase the unit size and one unit now becomes two pixels.
This results in shapes being drawn twice as large.

    scale x y

  - `x`
      - Scaling factor in the horizontal direction.
  - `y`
      - Scaling factor in the vertical direction.

**Note**: You can use `scale -1 1` to flip the context horizontally and `scale 1
-1` to flip it vertically.

More information and examples in the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/scale)

-}
scale : Float -> Float -> Transform
scale =
    Scale


{-| Adds a translation transformation by moving the canvas and its origin `x`
units horizontally and `y` units vertically on the grid.

More information and examples on the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/translate)

    translate x y

-}
translate : Float -> Float -> Transform
translate =
    Translate


{-| Multiplies the current transformation with the matrix described by the
arguments of this method. You are able to scale, rotate, move and skew the
context.

  - `m11`
      - Horizontal scaling.
  - `m12`
      - Horizontal skewing.
  - `m21`
      - Vertical skewing.
  - `m22`
      - Vertical scaling.
  - `dx`
      - Horizontal moving.
  - `dy`
      - Vertical moving.

-}
applyMatrix :
    { m11 : Float
    , m12 : Float
    , m21 : Float
    , m22 : Float
    , dx : Float
    , dy : Float
    }
    -> Transform
applyMatrix =
    ApplyMatrix
