import Html exposing ( Html, text, div, span, input, textarea, img, table, tr, th, td, i, p, a )
import Html.Events exposing ( on, targetValue, onClick, onDoubleClick, onInput )
import Html.Attributes exposing ( .. )
import Html.App as Html
import Color exposing ( .. )

import Maybe exposing ( withDefault, andThen )

import CollectionsNg.Array as Array exposing ( Array )
--import Array exposing ( Array )
import Set exposing ( Set )
import Dict exposing ( Dict )
import Random
import Result
import List
import Regex
import String
import Time
import Window
import Mouse
import Task
import Debug

import UrlParser exposing (..)


--blog : Parser (Int -> String -> a) a
--blog =
--  s "blog" </> int </> string

--result : Result String (Int, String)
--result =
--  parse (,) blog "blog/42/cat-herding-techniques"

--main = text <| toString <| result

type DesiredPage = Blog Int | Search String

desiredPage : Parser (DesiredPage -> a) a
desiredPage =
  oneOf
    [ format Blog (s "blog" </> int)
    , format Search (s "search" </> string)
    ]

result = 
  parse (,) desiredPage "blog/42"

--y: Int
y = parse identity desiredPage "blog/42"
    --oneOf [format Blog (s "blog" </> int)]

--x = s "blog"
main = text <| toString <| y