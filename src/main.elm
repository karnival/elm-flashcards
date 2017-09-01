module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { entries : List ( String, String )
    , displayed : String
    }


model : Model
model =
    { entries =
        [ ( "a", "large" )
        , ( "ą", "nasal o as own or French bon" )
        , ( "b", "bed" )
        , ( "c", "pits, Tsar, a bit like s-stuff with t before it" )
        , ( "ć", "cheap (alveolo-palatal), tongue towards front and roof, a bit like s-stuff with t before it" )
        , ( "ci", "same as ć" )
        , ( "cz", "cheap, tongue towards lower teeth and back, a bit like s-stuff with t before it" )
        , ( "ch", "hello" )
        , ( "d", "dog" )
        , ( "dz", "voiced 'c', like voids, like z series with d before it" )
        , ( "dź", "voiced 'ć', like jeep, like z series with d before it" )
        , ( "dzi", "same as dź" )
        , ( "dż", "voiced 'cz', like djinn, like z series with d before it" )
        , ( "e", "bed" )
        , ( "ę", "nasal e, French pain" )
        , ( "f", "fingers" )
        , ( "g", "go" )
        , ( "h", "hello, maybe a bit towards Scots loch" )
        , ( "i", "meet" )
        , ( "j", "yes" )
        , ( "k", "king" )
        , ( "l", "light" )
        , ( "ł", "will" )
        , ( "m", "men" )
        , ( "n", "not" )
        , ( "ń", "canyon (alveolo-palatal)" )
        , ( "o", "British English long" )
        , ( "ó", "boot" )
        , ( "p", "spot" )
        , ( "r", "trilled r" )
        , ( "rz", "same as ż" )
        , ( "s", "sea" )
        , ( "ś", "sheep (alveolo-palatal), tongue towards front and roof" )
        , ( "si", "same as ś" )
        , ( "sz", "sheep (alveolo-palatal), tongue towards lower teeth and back" )
        , ( "t", "start" )
        , ( "u", "boot" )
        , ( "w", "vox" )
        , ( "y", "short i as in bit" )
        , ( "z", "zoo" )
        , ( "ź", "vision (alveolo-palatal), tongue towards front and roof" )
        , ( "zi", "same as ź" )
        , ( "ż", "vision, tongue towards lower teeth and back" )
        ]
    , displayed = "Click an entry to see its associated answer/pronunciation/solution."
    }



-- UPDATE


type Msg
    = Show String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Show entry ->
            { model
                | displayed = entry

                --| displayed = model.entries
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
        , ul [ id "entries" ] (List.map viewEntry model.entries)
        , div [ id "displayed" ] [ text model.displayed ]
        ]


viewEntry : ( String, String ) -> Html Msg
viewEntry entry =
    li [ onClick (Show (Tuple.second entry)) ]
        [ text (Tuple.first entry) ]
