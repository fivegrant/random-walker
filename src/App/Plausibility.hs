module App.Plausibility where

import App.Cipher
import App.TransitionMatrix
import App.Characters (position)

plausibility :: Cipher -> StateTransitions -> String -> Float
plausibility f m s
                  | length s <= 1 = 1
                  | position (s !! 0) == -1 || position (s !! 1) == -1 = (plausibility f m (tail s))
                  | otherwise = (m (position (f (s !! 0))) (position (f (s !! 1)))) * (plausibility f m (tail s))

evolve :: [(Char, Char)] -> StateTransitions -> String -> CipherMapping -> [Bool] -> Cipher
evolve pairs m s mapping coinFlips
                        | length pairs <= 1 = cipher newMapping
                        | otherwise = evolve (tail pairs) m s newMapping (tail coinFlips)
                        where mutantMapping = mutate (head pairs) mapping
                              f = cipher mapping
                              pl = plausibility f m s 
                              f' = cipher mutantMapping
                              pl' = plausibility f' m s
                              randomChoice = if (head coinFlips)
                                             then mapping
                                             else mutantMapping
                              newMapping = if pl' > pl
                                           then mutantMapping
                                           else randomChoice

infix 8 !>
(!>) :: Cipher -> String -> String
(!>) = map
