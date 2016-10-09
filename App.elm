port module App exposing (..)

import Html exposing ( Html, text, div, span, input, textarea, img, table, tr, th, td, i, p, a )
import Html.Events exposing ( on, targetValue, onClick, onDoubleClick, onInput )
import Html.App as Html
import Result
import List
import String
import Debug
import UrlParser exposing (int, format, oneOf, s, parse, (</>))

{-
  
  The approach to handling urls is fairly laborious. 
  
  # Initial pageload
  1. I want to host on Github pages, so non-root urls return a 404
  2. So, a custom 404 is returned, with a redirect to the root page, 
      with the non-root portion of the url represented as a query string.
  3. The root/index file is served, and a script uses the query string to 
      change the displayed url. 
  4. The url is then sent to Elm to update its model

  # Changing pages from within Elm app
  1. A msg is produced which updates the model, and also sends a new url 
      through a port. JS updates the url (via pushState)

  # Changing pages with forward and back
  1. A popState event is fired, and the current url is sent to Elm through a port

  -}


main = 
  Html.program
    { init = ( initialModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


port urlUpdate : ( String -> msg ) -> Sub msg
port changeUrl : String -> Cmd msg 

subscriptions: Model -> Sub Msg
subscriptions model = 
  Sub.batch
    [ urlUpdate ( \url -> UrlUpdate url )]    


type Page 
  = Home
  | About
  | Blog Int

type alias Model = 
  { page : Page
  , count : Int
  }

initialModel = 
  { page = Home
  , count = 0 
  }

type Msg
  = NoMsg
  | UrlUpdate String
  | ChangePage Page
  | Increment

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoMsg -> 
      ( model, Cmd.none )
    UrlUpdate pathname -> 
      let pageParser =
            oneOf
              [ format About (s "about")
              , format Blog (s "blog" </> int)
              , format Home (s "home")
              , format Home (s "")
              ]
          -- weird. Starting "/" in pathname isn't parsed correctly. (Docs show it working)
          pathname' = String.dropLeft 1 pathname
          result = parse identity pageParser pathname' 
          x = Debug.log "result" result
      in case result of 
        Ok page -> 
          ({ model | page = page }, Cmd.none)
        Err error -> 
          (model, Cmd.none)
    ChangePage page -> 
      let url = 
            case page of
              Home -> "/home"
              About -> "/about"
              Blog int -> "/blog/" ++ (toString int)
      in 
        ({ model | page = page }, changeUrl url)  
    Increment -> 
      ( { model | count = model.count + 1 }, Cmd.none )


view : Model -> Html Msg
view model =
  div
    []
    [ div
        [ onClick (ChangePage Home) ]
        [ text "Home" ]
    , div
        [ onClick (ChangePage About) ]
        [ text "About" ]
    , div
        [ onClick (ChangePage (Blog 1)) ]
        [ text "Blog 1" ]
    , div
        [ onClick (ChangePage (Blog 2)) ]
        [ text "Blog 2" ]
    , div
        [ onClick (ChangePage (Blog 3)) ]
        [ text "Blog 3" ]   
    , div
        [ onClick (Increment) ]
        [ text "Increment" ]    
    , model |> toString |> text 
    ]
  
  