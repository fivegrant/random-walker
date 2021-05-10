module App.Cipher where

import Data.Maybe (isNothing, fromJust)
import qualified Data.Map.Lazy as Map

import App.Characters (characterRange, missingCharacter)

-- The list of characters that can be decoded.
-- characterRange = ['a'..'z'] ++ ['A'..'Z'] ++ [' ', '?','.','!','-','/']
-- missingCharacter = '\9608' -- unicode 'Full Block'

{-
 The Cipher is mapping from a character in the code space
 to the commonplace English usage of the character
-}
type Cipher = Map.Map Char Char
-- newCipher = Map.fromList [(' ',' ')]
newCipher = Map.fromList $ characterRange `zip` characterRange
decode character cipher
                | isNothing result = missingCharacter 
                | otherwise = fromJust result
                where result = Map.lookup character cipher


