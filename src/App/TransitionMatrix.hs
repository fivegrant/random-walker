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


{-
moveKnownToBack :: String -> String
moveKnownToBack corpus = if (toLower (head corpus)) `elem` characterRange 
                         then (tail corpus) ++ [head corpus]
                         else tail corpus

clean :: String -> String
clean corpus = iterate moveKnownToBack corpus !! (length corpus - 1)

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
-}

clean :: String -> String
clean corpus = map toLower corpus 

pair :: String -> [(Char, Char)]
pair corpus = map pairing [0..length corpus - 2]
              where pairing i = (corpus !! i, corpus !! (i+1))

pairMatrix :: (Char, Char) -> TransitionMatrix
pairMatrix letters = if x > 0 || y > 0 
                     then Matrix.setElem 1.0 (x, y) emptyTransitionMatrix 
                     else emptyTransitionMatrix 
                     where x = position (fst letters) + 1
                           y = position (snd letters) + 1

occurrences :: String -> TransitionMatrix
occurrences corpus = sum (map pairMatrix (pair corpus))

probabilityInRow :: TransitionMatrix -> Int -> TransitionMatrix
probabilityInRow transition iteration 
                                     | iteration == Matrix.nrows transition = transition
                                     | otherwise = probabilityInRow (Matrix.mapRow getProbability iteration transition) (iteration + 1)
                                     where getProbability _ x = x / (Vector.sum (Matrix.getRow iteration transition))

getTransition :: String -> TransitionMatrix
getTransition corpus = let counts = occurrences corpus
                       in  probabilityInRow counts 0

stateTransitions :: TransitionMatrix -> StateTransitions
stateTransitions transition = (\ from to -> Matrix.getElem (from+1) (to+1) transition)
