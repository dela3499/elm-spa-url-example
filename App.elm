port module App exposing (..)

import Html exposing (Html, text)
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


port initialUrl : ( String -> msg ) -> Sub msg


subscriptions: Model -> Sub Msg
subscriptions model = 
  Sub.batch
    [ initialUrl ( \url -> UrlUpdate url )]    


type Page 
  = Home
  | About
  | Blog Int

type alias Model = 
  { page : Page}

initialModel = 
  { page = Home }

type Msg
  = NoMsg
  | UrlUpdate String

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoMsg -> 
      ( model, Cmd.none )
    UrlUpdate pathname -> 
      let debug = Debug.log "pathname" pathname
          pageParser =
            oneOf
              [ format About (s "about")
              , format Blog (s "blog" </> int)
              ]
          -- weird. Starting "/" in pathname isn't parsed correctly. (Docs show it working)
          pathname' = String.dropLeft 1 pathname
          result = parse identity pageParser pathname' 
          debug2 = Debug.log "result" result
      in case result of 
        Ok page -> 
          ({ model | page = page }, Cmd.none)
        Err error -> 
          (model, Cmd.none)      


view : Model -> Html Msg
view model =
  model |> toString |> text 
  