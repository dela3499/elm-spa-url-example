port module App exposing (..)

import Html exposing ( Html, text, div, span, input, textarea, img, table, tr, th, td, i, p, a )
import Html.Events exposing ( on, targetValue, onClick, onDoubleClick, onInput )
import Html.App as Html
import Result
import List
import String
import Debug
import UrlParser exposing (int, format, oneOf, s, parse, (</>))


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
  
  