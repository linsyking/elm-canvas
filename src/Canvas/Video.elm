module Canvas.Video exposing
    ( Source, loadFromVideoUrl
    , Video
    , sprite
    , dimensions
    )

{-| This module exposes the types and functions to load and work with textures.

You can load textures by using `toHtmlWith`, and use them to draw with
`Canvas.texture`.


# Loading Textures


## From an external source

@docs Source, loadFromVideoUrl


# Texture types

@docs Video

Once you have a texture, you can get a new texture with a viewport into an
existing one. This is very useful for when you have a sprite sheet with many
images in one, but want to have individual sprites to draw.

@docs sprite


# Texture information

You can get some information from the texture, like its dimensions:

@docs dimensions

-}

import Canvas.Internal.Video as T


{-| Origin of a texture to load. Passing a `List Source` to `Canvas.toHtmlWith`
will try to load the textures and send you events with the actual `Texture` when
it is loaded.
-}
type alias Source msg =
    T.Source msg


{-| The `Texture` type. You can use this type with `Canvas.texture` to get
a `Renderable` into the screen.
-}
type alias Video =
    T.Video


{-| Make a sprite from a texture. A sprite is like a window into a bigger
texture. By passing the inner coordinates and width and height of the window,
you will get a new texture back that is only that selected viewport into the
bigger texture.

Very useful for using sprite sheet textures.

-}
sprite : { x : Float, y : Float, width : Float, height : Float } -> Video -> Video
sprite data texture =
    case texture of
        T.VSource video ->
            T.VClip data video

        T.VClip _ image ->
            T.VClip data image


{-| Make a `Texture.Source` from an image URL. When passing this Source to
`toHtmlWith` the image will try to be loaded and stored as a `Texture` ready to be drawn.
-}
loadFromVideoUrl : String -> (Maybe Video -> msg) -> Source msg
loadFromVideoUrl url onLoad =
    T.TSVideoUrl url onLoad


{-| Get the width and height of a texture
-}
dimensions : Video -> { width : Float, height : Float }
dimensions texture =
    case texture of
        T.VSource video ->
            { width = video.width, height = video.height }

        T.VClip data _ ->
            { width = data.width, height = data.height }
