module LinkParser exposing (..)

import UrlParser exposing (..)



pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format Publications (s "publication")
    , format Publication (s "publication" </> int)
    ]


parseLocation location = 
  parse (,) pageParser location.pathname

type DesiredPage = Blog Int | Search String

desiredPage : Parser (DesiredPage -> a) a
desiredPage =
  oneOf
    [ format Blog (s "blog" </> int)
    , format Search (s "search" </> string)
    ]

blog : Parser (Int -> String -> a) a
blog =
  s "blog" </> int </> string

--parseLocation : Result String (Int, String)
--parseLocation location = 
--    let x = Debug.log "pathname" location.pathname
--        y = Debug.log "result" (parse (,) blog location.pathname)
--    in 
--        parse (,) blog location.pathname
--        --"/blog/42/cat-herding-techniques"

f x = 
    case x of 
        "a" -> "a"
        "b" -> "b"
        _ -> "c"

parseLocation location = 
    Ok "bob"
        --"/blog/42/cat-herding-techniques"        