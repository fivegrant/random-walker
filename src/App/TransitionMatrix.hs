module App.TransitionMatrix where

import qualified Data.Matrix as Matrix
import qualified Data.Vector as Vector
-- import NLP.Tokenize.String (tokenize)

import App.Characters (characterRange, position)

type StateTransitions = Matrix.Matrix Float

charAmount = length characterRange
emptyTransitionMatrix = Matrix.zero charAmount charAmount


moveKnownToBack :: String -> String
moveKnownToBack corpus = if (head corpus) `elem` characterRange 
                         then (tail corpus) ++ [head corpus]
		         else tail corpus

clean :: String -> String
clean corpus = iterate moveKnownToBack corpus !! (length corpus - 1)


infix 7 +>
(+>) :: (Char , Char) -> StateTransitions -> StateTransitions
(+>) characters transition 
                               | outOfScope = transition
                               | otherwise = Matrix.setElem (1 + (Matrix.getElem x y transition)) (x,y) transition  
			       where x = position (fst characters)
			             y = position (snd characters)
				     outOfScope = x == -1 || y == -1

infix 7 `occurrences`
occurrences :: String -> StateTransitions -> StateTransitions
occurrences corpus transition
                             | null corpus = transition 
                             | otherwise = (x, y) +> transition + reducedCorpus `occurrences` transition
                             where reducedCorpus = tail corpus
			           x = corpus !! 0
				   y = corpus !! 1 

probabilityInRow :: StateTransitions -> Int -> StateTransitions
probabilityInRow transition iteration 
                                     | iteration == Matrix.nrows transition = transition
				     | otherwise = Matrix.mapRow getProbability iteration $ probabilityInRow transition (iteration + 1)
				     where getProbability = (\_ x -> x / (Vector.sum (Matrix.getRow iteration transition)))

getTransition :: String -> StateTransitions
getTransition corpus = let counts = corpus `occurrences` emptyTransitionMatrix
                       in  probabilityInRow counts 0
