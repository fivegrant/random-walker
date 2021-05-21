module Main where

import System.Environment
--import Control.Monad.Loops
import System.Random
import System.IO

import App.Cipher
import App.Plausibility
import qualified App.Characters as Characters

main :: IO ()
main = do
  -- let pl = plausibility $ newCipher
  -- putStrLn $ show pl
  -- putStrLn $ show $ Characters.characterRange `zip` Characters.characterRange
  -- putStrLn "Random-Walker was called with the following arguments: "
  -- args <- getArgs
  -- mapM_ putStrLn args 
  let h = cipher badCipherMapping
  codedMessage <- readFile "data/encrypt-me.txt"
  writeFile "data/encrypted.txt" (h !> codedMessage)
  {-
  let iteration = 1000
  let trainingFile = "data/war-and-peace.txt"
  let encryptedFile = "data/encrypted.txt"

  transitionText <- readfile trainingFile
  codedMessage <- readfile encryptedFile

  xGenerator <- newStdGen
  let mutantX = take userInput (randomRs (0, length Characters.characterRange) xGenerator)
  yGenerator <- newStdGen
  let mutantY = take userInput (randomRs (0, length Characters.characterRange) xGenerator)
  let retrieve = (characterRange !!)
  let mutantPairs = (map retrieve mutantX) `zip` (map retrieve mutantY)
  flipGenerator <- newStdGen
  let coinFlips = take userInput (randomRs (False, True) flipGenerator)

  let transitions = stateTransitions transitionText

  let f = evolve mutantPairs transitions codedMessage mapping coinFlips
  message = f !> codedMessage
  putStr message
  -}
