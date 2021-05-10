module App.TransitionMatrix where

import qualified Data.Matrix as Matrix
import NLP.Tokenize

import App.Characters (characterRange)

charAmount = length characterRange
emptyTransitionMatrix = Matrix.zero charAmount charAmount

occurrences :: Num a => [String] -> Matrix.Matrix a -> Matrix.Matrix a
occurrences corpus transition
                             | null corpus = transition 
                             | otherwise = transition +  reducedCorpus `occurrences` transition
                             where reducedCorpus = tail corpus
