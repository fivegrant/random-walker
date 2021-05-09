module Main where

import System.Environment
import Decrypt

main :: IO ()
main = do
  let pl = plausibility $ newCipher
  putStrLn $ show pl
  putStrLn $ show $ characterRange `zip` characterRange
  putStrLn "Random-Walker was called with the following arguments: "
  args <- getArgs
  mapM_ putStrLn args 
