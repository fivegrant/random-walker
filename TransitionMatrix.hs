module TransitionMatrix where

import qualified Data.Matrix as Matrix

import Characters (characterRange)

charAmount = length characterRange
emptyTransitionMatrix = Matrix.zero charAmount charAmount

occurrences :: [String] -> Matrix -> Matrix
occurrences corpus transition
                             | null corpus = transition 
			     | otherwise = + $ occurrences reducedCorpus transition
			     where reducedCorpus = tail corpus
