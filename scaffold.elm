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
import Navigation as Nav
import UrlParser as Url

main = 
  Nav.program
    (Nav.makeParser ( \location -> Url.parse identity Url.string location.hash ))
    { init = ( \string -> ( initialModel, initCmd ) )
    , view = view
    , update = update
    , subscriptions = subscriptions
    , urlUpdate = ( \string model -> ( model, Cmd.none ) )
    }

initCmd = triggerGetSize

triggerGetSize: Cmd Msg
triggerGetSize = Task.perform ( \_ -> EmptyMsg ) ( \size -> SetWindowSize ( size.width, size.height ) ) Window.size

subscriptions: Model -> Sub Msg
subscriptions model = 
  Sub.batch
    [ Window.resizes ( \size -> SetWindowSize ( size.width, size.height ) )
    ]    

type alias Model = 
  { windowSize: ( Int, Int )
  }

initialModel = 
  { windowSize = ( 0, 0 )
  }

type Msg
  = EmptyMsg
  | SetWindowSize ( Int, Int )

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    EmptyMsg  -> 
      ( model, Cmd.none )
    SetWindowSize windowSize -> 
      ( { model | windowSize = windowSize }, Nav.newUrl (toString windowSize) )

view : Model -> Html Msg
view model =
  div
    [ ]
    [ model.windowSize |> toString |> text ]