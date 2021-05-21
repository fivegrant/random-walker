module App.Cipher where

import Data.Maybe (isNothing, fromJust)
import qualified Data.Map.Lazy as Map

-- import Control.Monad.Random

import App.Characters (characterRange, missingCharacter)

{-
 The Cipher is mapping from a character in the code space
 to the commonplace English usage of the character
-}

type CipherMapping = Map.Map Char Char
type Cipher = Char -> Char
newCipherMapping = Map.fromList $ characterRange `zip` characterRange
badCipherMapping = Map.fromList $ characterRange `zip` (reverse characterRange)

decode :: Char -> CipherMapping -> Char
decode character cipherMapping
                | isNothing result = missingCharacter 
                | otherwise = fromJust result
                where result = Map.lookup character cipherMapping

cipher :: CipherMapping -> Cipher
cipher cipherMapping = (`decode` cipherMapping)

mutate :: (Char, Char) -> CipherMapping -> CipherMapping
mutate pair cipherMapping 
			  | invalid = cipherMapping
                          | otherwise =  Map.update fix2 (snd pair) (Map.update fix1 (fst pair) cipherMapping)
			    where fix1 _ = Just (decode (fst pair) cipherMapping)
		                  fix2 _ = Just (decode (snd pair) cipherMapping)
				  invalid = (decode (fst pair) cipherMapping == missingCharacter) || 
				            (decode (snd pair) cipherMapping == missingCharacter)

{-
mutate :: (MonadRandom m) => CipherMapping -> m CipherMapping
mutate cipherMapping = do
                      index1 <- getRandomR (0, length characterRange - 1)
                      index2 <- getRandomR (0, length characterRange - 1)
		      let element1 = characterRange !! element1
		      let element2 = characterRange !! element2
		      let fix1 _ =  decode element2 cipherMapping
		      let fix2 _ = decode element1 cipherMapping
		      newMap = update fix2 index2 (update fix1 index1 cipherMapping)
		      return newMap

-}
