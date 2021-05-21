module App.Characters where

import Data.Maybe (isNothing, fromJust)
import Data.List (elemIndex)

-- The list of characters that can be decoded.
characterRange = ['a'..'z'] ++ ['A'..'Z'] ++ [' ', '?','.','!','-','/']
missingCharacter = '\9608' -- unicode 'Full Block'

position :: Char -> Int
position character = let letterIndex = elemIndex character characterRange
                     in if isNothing letterIndex then -1 else fromJust letterIndex

