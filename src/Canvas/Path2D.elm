module Canvas.Path2D exposing (renderShape)

{-| This module exposes the types and functions to work with Path2Ds, which named as Shape in elm-Canvas.

@docs renderShape

-}

import Canvas.Internal.Canvas as C exposing (..)
import Canvas.Internal.CustomElementJsonApi as CE exposing (..)


type alias Shape =
    C.Shape


{-| draw a Path2D element
-}
renderShape : Shape -> Commands -> Commands
renderShape shape cmds =
    case shape of
        Rect ( x, y ) w h ->
            CE.rect x y w h :: CE.moveTo x y :: cmds

        RoundRect ( x, y ) w h r ->
            CE.roundRect x y w h r :: CE.moveTo x y :: cmds

        Circle ( x, y ) r ->
            CE.circle x y r :: CE.moveTo (x + r) y :: cmds

        Path ( x, y ) segments ->
            List.foldl renderLineSegment (CE.moveTo x y :: cmds) segments

        Arc ( x, y ) radius startAngle endAngle anticlockwise ->
            CE.moveTo (x + radius * cos endAngle) (y + radius * sin endAngle)
                :: CE.arc x y radius startAngle endAngle anticlockwise
                :: CE.moveTo (x + radius * cos startAngle) (y + radius * sin startAngle)
                :: cmds


renderLineSegment : PathSegment -> Commands -> Commands
renderLineSegment segment cmds =
    case segment of
        ArcTo ( x, y ) ( x2, y2 ) radius ->
            CE.arcTo x y x2 y2 radius :: cmds

        BezierCurveTo ( cp1x, cp1y ) ( cp2x, cp2y ) ( x, y ) ->
            CE.bezierCurveTo cp1x cp1y cp2x cp2y x y :: cmds

        LineTo ( x, y ) ->
            CE.lineTo x y :: cmds

        MoveTo ( x, y ) ->
            CE.moveTo x y :: cmds

        QuadraticCurveTo ( cpx, cpy ) ( x, y ) ->
            CE.quadraticCurveTo cpx cpy x y :: cmds
