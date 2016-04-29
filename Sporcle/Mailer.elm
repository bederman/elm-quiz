module Sporcle.Mailer where

import Signal exposing (..)
import Sporcle.Decode exposing (JsonModel)
import Result exposing (andThen)
import Task exposing (Task, toResult)

{-
This file contains all mailboxes and any functions associated with them.
-}

-- gets input from the button on front page. Data is then piped through results port
quizNameMailer : Mailbox (String, String)
quizNameMailer = mailbox ("no quiz yet", "no quiz")

-- gets input from the viewMailer and the results port. Pulled from in the view
quizMailer : Mailbox (Result String (JsonModel))
quizMailer = mailbox (Err "Nothing")

-- gets input from the viewMailer. Displays on the page as well
textBoxMailer : Mailbox String
textBoxMailer = mailbox ""

-- data from the view. Has to be this way so that we can get the updated json
--  data and the string from the input box. Forwards to the respective mailboxes
viewMailer : Mailbox (Result String JsonModel, String)
viewMailer = mailbox (Err "Nothing", "")

---- this port and function forwards the text to the input mailbox
--port updater : Signal (Task x ())
--port updater = Signal.map forwarder viewMailer.signal

--forwarder : (Result String JsonModel, String) -> Task x ()
--forwarder (js, s) = send textBoxMailer.address s

---- this port and function forwards the (updated) quiz to the quiz mailbox 
--port u1 : Signal (Task x ())
--port u1 = Signal.map forwarder1 viewMailer.signal

--forwarder1 : (Result String JsonModel, String) -> Task x ()
--forwarder1 (js, s) = send quizMailer.address js
