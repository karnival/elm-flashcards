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
    }


model : Model
model =
    { entries = []
    , displayed = "Click an entry to see its associated answer/pronunciation/solution."
    }


init : ( Model, Cmd Msg )
init =
    ( model, getDeckData )



-- UPDATE


type Msg
    = Show String
    | NewDeck (Result Http.Error CardDeck)
    | ChangeDeck


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
                | displayed = model.displayed
                , entries = deckData
              }
            , Cmd.none
            )

        NewDeck (Err err) ->
            ( { model
                | displayed = toString err
              }
            , Cmd.none
            )

        ChangeDeck ->
            ( model, getDeckData )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.node "link" [ Html.Attributes.rel "stylesheet", Html.Attributes.href "style.css" ] []
        , ul [ id "entries" ] (List.map viewEntry model.entries)
        , div [ id "displayed" ] [ text model.displayed ]
        ]


viewEntry : Card -> Html Msg
viewEntry entry =
    li [ onClick (Show (Tuple.second entry)) ]
        [ text (Tuple.first entry) ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getDeckData : Cmd Msg
getDeckData =
    let
        url =
            "./polish-pronunciation.json"
    in
        Http.send NewDeck (Http.get url decodeDeckData)


decodeDeckData : Decode.Decoder (List ( String, String ))
decodeDeckData =
    --Decode.decodeString (list (Decode.index 0 Decode.int)) Decode.string
    Decode.list (arrayAsTuple2 Decode.string Decode.string)


arrayAsTuple2 : Decode.Decoder a -> Decode.Decoder b -> Decode.Decoder ( a, b )
arrayAsTuple2 a b =
    Decode.index 0 a
        |> Decode.andThen
            (\aVal ->
                Decode.index 1 b
                    |> Decode.andThen (\bVal -> Decode.succeed ( aVal, bVal ))
            )
