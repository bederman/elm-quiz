module Sporcle.Decode(JsonModel, completeDecoder, stringTuple) where

import Json.Decode exposing (..)

{-
This file contains all necessary decoding functions and a declaration of the
JsonModel (type model of the quiz structure). Very important file.
-}

extractString : Decoder String
extractString = tuple1 identity string

completeDecoder : Decoder JsonModel
completeDecoder =
    object5
        JsonModel
            ("name" := string)
            ("time" := float)
            ("entries" := int)
            ("cols" := (list string))
            ("fields" := (list <| tuple4 (,,,) string string string bool))


type alias JsonModel = {
    name : String,
    time : Float,
    entries : Int,
    cols : List String, -- the column titles
    fields : List (String, String, String, Bool) --hint, answer, key, hidden
}

stringTuple : Decoder (String, String)
stringTuple = tuple2 (,) string string
