module Sporcle.Views where

import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (..)
import Sporcle.Decode exposing (JsonModel)


{-
This file contains styling functions and functions for creating the HTML elements
from raw JSON quiz data.
-}

myStyle : Attribute
myStyle =
  style
    [ ("width", "100%")
    , ("height", "30px")
    , ("padding", "10px 0")
    , ("font-size", "2em")
    , ("text-align", "center")
    ]

altStyle : Attribute
altStyle =
    style
    [ ("width", "70%")
    , ("margin", "auto")
    , ("height", "30px")
    , ("padding", "0 10px 0 10px")
    , ("font-size", "1.25em")
    , ("text-align", "center")
    ]

showField : String -> List (String, String, String, Bool) -> List (String, String, String, Bool)
showField s jm = case jm of
    (a, b, key, truth) :: jm' -> if (contains (toLower key) (toLower s)) && (s /= "")
                                    then (a, b, key, True) :: showField s jm'
                                    else (a, b, key, truth) :: showField s jm'
    []                        -> []

quizToDiv : JsonModel -> Html
quizToDiv jm =
    Html.div [altStyle] [
        table [style [("width", "100%"), ("border", "1px solid black")]]
            ([tr [] (List.map makeHeaders jm.cols)] ++ (List.map makeRow jm.fields))
    ]

makeRow : (String, String, String, Bool) -> Html
makeRow (hint, answer, key, hide) =
    let a = if hide then answer else " "
    in
        tr [] [
            td [style [("border", "1px solid black"), ("width", "75%")]] [text hint],
            td [style [("border", "1px solid black"), ("width", "25%"), ("text-align", "center")]] [text a]
        ]

makeHeaders : String -> Html
makeHeaders s = th [style [("border", "1px solid black")]] [text s]
