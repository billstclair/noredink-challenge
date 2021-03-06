----------------------------------------------------------------------
--
-- Process.elm
-- Data processing for NoRedInk's two-hour programming challenge.
-- Copyright (c) 2017 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE.txt
--
----------------------------------------------------------------------

module Process exposing ( Sequence, SequenceMaker
                        , equalStrands, equalStandards, equalQuestions
                        )

import Data exposing ( Question, questions )
import Dict exposing ( Dict )
import Maybe exposing ( withDefault )

type alias Sequence =
    List Question

type alias SequenceMaker =
    Int -> Sequence

segregate : (Question -> comparable) -> Dict comparable (List Question)
segregate typer =
    segregateLoop typer questions Dict.empty

segregateLoop : (Question -> comparable) -> List Question -> Dict comparable (List Question) -> Dict comparable (List Question)
segregateLoop typer questions res =
    case questions of
        [] ->
            res
        q :: tail ->
            let typ = typer q
                qs = q :: (withDefault [] <| Dict.get typ res)
            in
                segregateLoop typer tail <| Dict.insert typ qs res

-- It would be good to randomize here.
-- The way Elm works, we'd have to pre-generate a suitably
-- long list of random numbers, and pass them in.
chooser : Int -> (Question -> comparable) -> List Question
chooser count typer =
    let dict = segregate typer
        lists = Dict.toList dict
    in
        chooserLoop count [] lists dict

chooserLoop : Int -> Dict comparable (List Question)-> List Question -> List (comparable, List Question) -> List Question
chooserLoop count dict res lists =
    if count <= 0 then
        res
    else
        case lists of
            [] -> res           -- won't happen unless data is empty
            (typ, qs) :: rest ->
                case qs of
                    Nothing -> res --can't happen
                    q :: rqs ->
                        case rqs of
                            [] ->
                                case Dict.get typ dict of
                                    Nothing ->
                                        res --can't happen
                                    Just rqs2 ->
                                        chooserLoop (count-1) dict
                                            (q :: res)
                                            <| List.append rest [rqs2]
                            _ ->
                                chooserLoop (count-1) dict
                                    (q :: res)
                                    <| List.append rest [rqs]
                            

haveEqualStrands : Question -> Question -> Bool
haveEqualStrands q1 q2
    q1.strandId == q2.strandId

chooseEqualStrands : SequenceMaker
chooseEqualStrands count =
    chooser count haveEqualStrands

haveEqualStandards : Question -> Question -> Bool
haveEqualStandards q1 q2 =
    (haveEqualStrands q1 q2)
    && (q1.standardId == q2.standardId)

chooseEqualStandards : SequenceMaker
chooseEqualStandards count =
    chooser count haveEqualStandards

-- The way I did it, this one isn't any different
chooseEqualQuestions : SequenceMaker
chooseEqualQuestions count =
    chooseEqualStandards count

