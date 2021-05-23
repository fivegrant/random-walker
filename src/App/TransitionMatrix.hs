module App.TransitionMatrix where

import Data.Char (toLower)
import qualified Data.Matrix as Matrix
import qualified Data.Vector as Vector
-- import NLP.Tokenize.String (tokenize)

import App.Characters (characterRange, position)

type TransitionMatrix = Matrix.Matrix Float
type StateTransitions = Int -> Int -> Float

charAmount = length characterRange
emptyTransitionMatrix = Matrix.zero charAmount charAmount


moveKnownToBack :: String -> String
moveKnownToBack corpus = if (toLower (head corpus)) `elem` characterRange 
                         then (tail corpus) ++ [head corpus]
                         else tail corpus

clean :: String -> String
clean corpus = iterate moveKnownToBack corpus !! (length corpus - 1)


infix 7 +>
(+>) :: (Char , Char) -> TransitionMatrix -> TransitionMatrix
(+>) characters transition 
                               | outOfScope = transition
                               | otherwise = transition + Matrix.setElem 1 (x,y) transition  
                               where x = position (fst characters) + 1
                                     y = position (snd characters) + 1
                                     outOfScope = (x == -1) || (y == -1)

{-
infix 7 `occurrences`
occurrences :: String -> TransitionMatrix -> TransitionMatrix
occurrences corpus transition
                             | length corpus <= 1 = transition 
                             | otherwise = ((corpus !! 0, corpus !! 1) +> transition) + reducedCorpus `occurrences` transition
                             where reducedCorpus = tail corpus

poo :: Int -> Int -> TransitionMatrix -> TransitionMatrix
poo x y transition = Matrix.setElem 1 (x, y) transition
-}

infix 7 `occurrences`
occurrences :: String -> TransitionMatrix -> TransitionMatrix
occurrences corpus transition
                             | length corpus <= 1 = transition 
                             | x <= 0 || y <= 0 = transition + (reducedCorpus `occurrences` transition)
                             | length corpus == 2 = pairMatrix
                             | otherwise = pairMatrix + (reducedCorpus `occurrences` transition)
                             where reducedCorpus = tail corpus
                                   x = position (corpus !! 0) + 1
                                   y = position (corpus !! 1) + 1
                                   pairMatrix = Matrix.setElem 1 (x, y) transition

probabilityInRow :: TransitionMatrix -> Int -> TransitionMatrix
probabilityInRow transition iteration 
                                     | iteration == Matrix.nrows transition = transition
                                     | otherwise = Matrix.mapRow getProbability iteration $ probabilityInRow transition (iteration + 1)
                                     where getProbability _ x = x / (Vector.sum (Matrix.getRow iteration transition))

getTransition :: String -> TransitionMatrix
getTransition corpus = let counts = corpus `occurrences` emptyTransitionMatrix
                       in  probabilityInRow counts 0

stateTransitions :: TransitionMatrix -> StateTransitions
stateTransitions transition = (\ from to -> Matrix.getElem (from+1) (to+1) transition)
