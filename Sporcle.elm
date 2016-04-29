module Sporcle where

import List
import Graphics.Input as GI
import Signal
import Html exposing (..)
-- import Html.Shorthand exposing (..)
-- import Bootstrap.Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task, andThen)
import Result
import Graphics.Element exposing (..)

import Sporcle.Decode exposing (..)
import Sporcle.JsonSignal exposing (..)
import Sporcle.Mailer exposing (..)
import Sporcle.Views exposing (..)

-- the current quizzes we have available for selection
-- String.lowercase first!
quizzes : List (String, String)
quizzes = [("Dunder Mifflin", "dunder"), ("Pixar", "pixar"), ("United States Presidents", "presidents"),
            ("Superhero Identities", "superheroes")]

--------------------------------------------------------------------------------
--                                   MAIN                                     --
--------------------------------------------------------------------------------
main : Signal Html
main = Signal.map3 view (quizNameMailer.signal) (textBoxMailer.signal) (quizMailer.signal)

--------------------------------------------------------------------------------
--                                   VIEW                                     --
--------------------------------------------------------------------------------
view : (String, String) -> String -> Result String (JsonModel) -> Html
view choose textbox quiz =
    case quiz of
        Err err ->
            div [] [
            h2 [myStyle] [text "Quizcle Quizzes"] ,
            div [style [("width", "30%"), ("margin", "auto")]] [fromElement (flow right (genFrontList quizzes))]
            ]
        Ok _ ->
            let q = jsonData quiz
                updated = { q | fields = showField textbox q.fields}
                i = input
                        [ placeholder "Type your answers here"
                        , value textbox
                        , Html.Events.on "input" Html.Events.targetValue
                            (\s -> Signal.message viewMailer.address (Ok updated,
                                if q /= updated then "" else s))
                        , myStyle
                        ]
                        []
                quizData = quizToDiv updated
            in
            div []
                [ i
                , div
                  [ style [("margin", "auto"), ("float", "left")] ]
                  [(GI.button (Signal.message quizMailer.address (Err "")) "Select another quiz" |> fromElement)]
                , quizData
                ]



--------------------------------------------------------------------------------
--                                    PORT                                    --
--------------------------------------------------------------------------------
port results : Signal (Task x ())
port results = Signal.map getQuiz quizNameMailer.signal
    |> Signal.map (\task -> Task.toResult task `andThen` Signal.send quizMailer.address)

getQuiz : (String, String) -> Task String JsonModel
getQuiz s =
    if List.member s quizzes
        then Task.mapError transformHTTP (getter (snd s))
        else Task.fail ("error")

-- this port and function forwards the text to the input mailbox
port updater : Signal (Task x ())
port updater = Signal.map forwarder viewMailer.signal

forwarder : (Result String JsonModel, String) -> Task x ()
forwarder (js, s) = Signal.send textBoxMailer.address s

-- this port and function forwards the (updated) quiz to the quiz mailbox
port u1 : Signal (Task x ())
port u1 = Signal.map forwarder1 viewMailer.signal

forwarder1 : (Result String JsonModel, String) -> Task x ()
forwarder1 (js, s) = Signal.send quizMailer.address js


--------------------------------------------------------------------------------
--                                EXTRA FTNS                                  --
--------------------------------------------------------------------------------
genFrontList : List (String, String) -> List Element
genFrontList ts = case ts of
    [] -> []
    x::xs ->
        (GI.button (Signal.message quizNameMailer.address x) (fst x)
            ) :: (genFrontList xs)
