module Main where

import System.Environment
import Cipher
import Plausibility
import qualified Characters

main :: IO ()
main = do
  let pl = plausibility $ newCipher
  putStrLn $ show pl
  putStrLn $ show $ Characters.characterRange `zip` Characters.characterRange
  putStrLn "Random-Walker was called with the following arguments: "
  args <- getArgs
  mapM_ putStrLn args 
