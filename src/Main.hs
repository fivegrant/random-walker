module Main where

import System.Environment
--import Control.Monad.Loops
import System.Random
import System.IO

import App.Cipher
import App.Plausibility
import App.TransitionMatrix
import qualified App.Characters as Characters

main :: IO ()
main = do
  -- let pl = plausibility $ newCipher
  -- putStrLn $ show pl
  -- putStrLn $ show $ Characters.characterRange `zip` Characters.characterRange
  -- putStrLn "Random-Walker was called with the following arguments: "
  -- args <- getArgs
  -- mapM_ putStrLn args 
  {-
  let h = cipher badCipherMapping
  codedMessage <- readFile "data/encrypt-me.txt"
  writeFile "data/encrypted.txt" (h !> codedMessage)
  -}
  let iteration = 1000
  --let trainingFile = "data/answer.txt"
  let trainingFile = "data/war-and-peace.txt"
  let encryptedFile = "data/encrypted.txt"

  transitionText <- readFile trainingFile
  codedMessage <- readFile encryptedFile

  xGenerator <- newStdGen
  let mutantX = take iteration (randomRs (0, (length Characters.characterRange) - 1) xGenerator)
  yGenerator <- newStdGen
  let mutantY = take iteration (randomRs (0, (length Characters.characterRange) - 1) yGenerator)
  let retrieve = (Characters.characterRange !!)
  let mutantPairs = (map retrieve mutantX) `zip` (map retrieve mutantY)
  flipGenerator <- newStdGen
  let coinFlips = take iteration (randomRs (False, True) flipGenerator)

  let transitions = stateTransitions (getTransition transitionText)

  let f = evolve mutantPairs transitions codedMessage newCipherMapping coinFlips
  -- let message = f !> codedMessage
  --putStrLn message
  writeFile "data/guess.txt" (f !> codedMessage)

