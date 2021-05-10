module Main where

import System.Environment
import App.Cipher
import App.Plausibility
import qualified App.Characters as Characters

main :: IO ()
main = do
  let pl = plausibility $ newCipher
  putStrLn $ show pl
  putStrLn $ show $ Characters.characterRange `zip` Characters.characterRange
  putStrLn "Random-Walker was called with the following arguments: "
  args <- getArgs
  mapM_ putStrLn args 
