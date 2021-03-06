----------------------------------------------------------------------
--
-- Main.elm
-- A solution for NoRedInk's two-hour programming challenge.
-- Copyright (c) 2017 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE.txt
--
-- The challenge instructions and data are in the `instructions`
-- directory.
--
----------------------------------------------------------------------

module Main exposing (..)

import Stylesheet exposing ( stylesheet )
import Data exposing ( Question )
import Choose exposing ( chooseEqualStrands
                        , chooseEqualStandards
                        , chooseEqualQuestions
                        )

import Html exposing ( Html, Attribute
                     , div, span, p, text, a, h1, h2, h3
                     , table, tr, td
                     , input, button
                     )
import Html.Attributes exposing ( style, class, value, size, href
                                , type_, name, checked
                                )
import Html.Events exposing ( on, onClick, onInput )

log = Debug.log

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (\x -> Sub.none)
        }

type alias Model =
    { text : String
    }

initialModel : Model
initialModel =
    { text = "Hello, Elm!"
    }

init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )

type Msg
    = UpdateText String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateText string ->
            ( { model
                  | text = string
              }
            , Cmd.none
            )

style_ : List (Attribute msg) -> List (Html msg) -> Html msg
style_ = Html.node "style"

questionCount : Int
questionCount =
    20

renderOneRun : Int -> List (String, (Int -> List Question)) -> List (Html msg)
renderOneRun count namesAndFuns =
    List.map
        (\(name, fun) ->
            let qs = List.map .questionId <| fun count
            in
                p [ class "centered" ]
                    [ text <| name ++ " " ++ (toString count)
                          ++ " => " ++ (toString qs)
                    ]
        )
        namesAndFuns

view : Model -> Html Msg
view model =
    div []
        [ style_ [ type_ "text/css" ]
              [ text stylesheet ]
        , h1 [] [ text "NoRedInk Programming Challenge" ]
        , div []
            <| renderOneRun questionCount
                [ ("chooseEqualStrands", chooseEqualStrands)
                , ("chooseEqualStandards", chooseEqualStandards)
                ]
        ]

    
