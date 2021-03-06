{-@ LIQUID "--higherorder" @-}
{-@ LIQUID "--exact-data-con" @-}
{-@ LIQUID "--automatic-instances=liquidinstances" @-}
module Replicate where

import Prelude hiding (replicate, (++), reverse, length)
import Language.Haskell.Liquid.ProofCombinators
import Data.List.Verified

{-@ reflect replicate @-}
{-@ replicate :: Nat -> a -> List a @-}
replicate :: Int -> a -> List a
replicate n x
  | n == 0 = Nil
  | otherwise = x:::(replicate (n - 1) x)

{-@ replicateLengthCorrect :: n:Nat -> x:a -> { length (replicate n x) = n } @-}
replicateLengthCorrect :: Int -> a -> Proof
replicateLengthCorrect n x = case n of
  0 -> trivial
  n -> replicateLengthCorrect (n - 1) x
