module Sporcle.JsonSignal where

import Http exposing (get)
import Sporcle.Decode exposing (JsonModel, completeDecoder)
import Task exposing (..)
import Http exposing (..)


{-
This file has functions related to opening a JSON file to extract the quiz
data. The only thing really missing from here is the port which is in the main
file so that we don't have to import the mailers here. That would defeat the
purpose of this file.
-}

getter : String -> Task.Task Http.Error JsonModel
getter s = get completeDecoder (jsonFile s)

jsonFile : String -> String
jsonFile s = "http://localhost:8000/json/" ++ s ++ ".json"

transformHTTP : Http.Error -> String
transformHTTP err = case err of
    Timeout -> "Timeout"
    NetworkError -> "NetworkError"
    UnexpectedPayload a -> "UnexpectedPayload " ++ a
    BadResponse i a     -> "BadResponse " ++ a

-- really this ftn is nothing but a glorified extractor
jsonData : Result String JsonModel -> JsonModel
jsonData fromMail =
    let json x = case x of
            Err _  -> Debug.crash "we errored out along the way"
            Ok a   -> a
    in
        json fromMail
