module App.TransitionMatrix where

import qualified Data.Matrix as Matrix
import NLP.Tokenize

import App.Characters (characterRange)

type StateTransitions = Matrix.Matrix Float

charAmount = length characterRange
emptyTransitionMatrix = Matrix.zero charAmount charAmount


occurrences :: [String] -> StateTransitions -> StateTransitions
occurrences corpus transition
                             | null corpus = transition 
                             | otherwise = transition +  reducedCorpus `occurrences` transition
                             where reducedCorpus = tail corpus
