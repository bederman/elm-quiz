# elm-quiz
Sporcle-like quiz app written in Elm.

## Description
As of now, building the app will get you two pages -- a homepage where you may select a quiz
from the ones (written in a standard JSON format) located in the 'json' directory, as well as
a quiz rendering page. Quizzes are currently only based off the standard Sporcle quiz design,
consisting of a two-column table with hints in one column and answers (initially left blank)
in the other. There is a text box for answer input, which automatically detects correct answers
and acts on them without the user needing to press Enter or a submit button. As of now, the project
is in a barebones, functional state, and the next steps are writing up a proper UI/UX before adding
more features.

## Features
* Quiz selection/reselection (quiz page has a 'back' button to return to the selection page)
* Live table updating as answers are submitted
* Automatic answer submission (as soon as the answer is typed out, it's registered). The next keypress after a correct answer
cleares the text box
* Easily extensible, with quizzes rendered/detected in an easy-to-replicate JSON format.
* Logic fully written in functional Elm code.

## Roadmap
* Transition more UI elements to pure Elm code.
* Add hooks for UI/UX customization (ideally with full CSS support) to allow themeing/designing.
* Timer/time limits.
* Points
* Other forms of questions/quizzes.

All code (as of first commit) written by Evan Bederman and Richard Hanson.
