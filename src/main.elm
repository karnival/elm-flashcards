module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { entries : List (List String)
    , displayed : String
    }


model : Model
model =
    { entries =
        [ [ "a", "b" ]
        , [ "c", "d" ]
        ]
    , displayed = ""
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
        [ ul [] (List.map viewEntry model.entries)
        , text model.displayed
        ]


viewEntry : List String -> Html Msg
viewEntry entry =
    li [ onClick (Show (case List.head entry of
                            Nothing -> ""
                            Just val -> val)) ]
        [ text
            (case List.head entry of
                Nothing ->
                    "oh no"

                Just val ->
                    val
            )
        ]
