module Canvas.Internal.Video exposing
    ( Clip
    , Source(..)
    , Video(..)
    , VideoSrc
    , decodeVideoImage
    , decodeVideoLoadEvent
    , drawVideo
    )

import Canvas.Internal.CustomElementJsonApi as C exposing (Commands)
import Json.Decode as D


type alias VideoSrc =
    { json : D.Value
    , width : Float
    , height : Float
    }


type Source msg
    = TSVideoUrl String (Maybe Video -> msg)


type Video
    = VSource VideoSrc
    | VClip Clip VideoSrc


type alias Clip =
    { x : Float, y : Float, width : Float, height : Float }


decodeVideoLoadEvent : D.Decoder (Maybe Video)
decodeVideoLoadEvent =
    D.field "target" decodeVideoImage


decodeVideoImage : D.Decoder (Maybe Video)
decodeVideoImage =
    -- TODO: Verify the Value is actually a DOM image
    D.value
        |> D.andThen
            (\video ->
                D.map3
                    (\tagName width height ->
                        if tagName == "VIDEO" then
                            Just
                                (VSource
                                    { json = video
                                    , width = width
                                    , height = height
                                    }
                                )

                        else
                            Nothing
                    )
                    (D.field "tagName" D.string)
                    (D.field "videoWidth" D.float)
                    (D.field "videoHeight" D.float)
            )


drawVideo : Float -> Float -> Video -> Commands -> Commands
drawVideo x y t cmds =
    (case t of
        VSource video ->
            C.drawImage 0 0 video.width video.height x y video.width video.height video.json

        VClip sprite video ->
            C.drawImage sprite.x sprite.y sprite.width sprite.height x y sprite.width sprite.height video.json
    )
        :: cmds
