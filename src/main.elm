module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
    Html.program { view = view, update = update, init = init, subscriptions = subscriptions }



-- MODEL


type alias Card =
    ( String, String )


type alias CardDeck =
    List Card


type alias Model =
    { entries : CardDeck
    , displayed : String
    , decks : List String
    }


model : Model
model =
    { entries = []
    , displayed = initDisplayed
    , decks = [ "polish-pronunciation", "polish-foods", "does-not-exist" ]
    }


initDisplayed =
    "Click an entry to see its associated answer/pronunciation/solution."


init : ( Model, Cmd Msg )
init =
    ( model, getDeckData "polish-pronunciation" )



-- UPDATE


type Msg
    = Show String
    | NewDeck (Result Http.Error CardDeck)
    | ChangeDeck String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Show entry ->
            ( { model
                | displayed = entry
              }
            , Cmd.none
            )

        NewDeck (Ok deckData) ->
            ( { model
                | displayed = initDisplayed
                , entries = deckData
              }
            , Cmd.none
            )

        NewDeck (Err err) ->
            ( { model
                | displayed = "Error loading new deck; staying on current deck."
              }
            , Cmd.none
            )

        ChangeDeck deckString ->
            ( model, getDeckData deckString )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
        , ul [ id "decks" ] (List.map viewDeck model.decks)
        , ul [ id "entries" ] (List.map viewEntry model.entries)
        , div [ id "displayed" ] [ text model.displayed ]
        ]


viewEntry : Card -> Html Msg
viewEntry entry =
    li [ onClick (Show (Tuple.second entry)) ]
        [ text (Tuple.first entry) ]


viewDeck : String -> Html Msg
viewDeck deckString =
    li [ onClick (ChangeDeck deckString) ]
        [ text deckString ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getDeckData : String -> Cmd Msg
getDeckData deckString =
    let
        url =
            "./" ++ deckString ++ ".json"
    in
        Http.send NewDeck (Http.get url decodeDeckData)


decodeDeckData : Decode.Decoder (List ( String, String ))
decodeDeckData =
    Decode.list (arrayAsTuple2 Decode.string Decode.string)


arrayAsTuple2 : Decode.Decoder a -> Decode.Decoder b -> Decode.Decoder ( a, b )
arrayAsTuple2 a b =
    Decode.index 0 a
        |> Decode.andThen
            (\aVal ->
                Decode.index 1 b
                    |> Decode.andThen (\bVal -> Decode.succeed ( aVal, bVal ))
            )
