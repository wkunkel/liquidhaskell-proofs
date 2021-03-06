{-@ LIQUID "--higherorder"    @-}
{-@ LIQUID "--exact-data-con" @-}
{-@ LIQUID "--automatic-instances=liquidinstances" @-}
module Proofs where

import Prelude hiding ((++), reverse, length)
import Language.Haskell.Liquid.ProofCombinators 
import Types
import Data.List.Verified

{-@ infixr 5 ::: @-}
{-@ infixr 5 ++ @-}

{-@ reverseSingletonIdentity :: x:a -> {reverse (x:::Nil) = x:::Nil}  @-}
reverseSingletonIdentity :: a -> Proof
reverseSingletonIdentity x = trivial

{-@ reflect add @-}
add :: N -> N -> N
add Zero m = m
add (Succ n) m = Succ (add n m)

{-@ addRightIdentityZero :: n:N -> {add n Zero = n} @-}
addRightIdentityZero :: N -> Proof
addRightIdentityZero m = case m of
  Zero -> trivial
  Succ m' -> addRightIdentityZero m'

{-@ addAssociative :: x:N -> y:N -> z:N -> {add x (add y z) = add (add x y) z} @-}
addAssociative :: N -> N -> N -> Proof
addAssociative x y z = case x of
  Zero -> trivial
  Succ x' -> addAssociative x' y z

{-@ reverseAppendFlip :: xs:List a -> ys:List a -> { reverse (xs ++ ys) = reverse ys ++ reverse xs } @-}
reverseAppendFlip :: List a -> List a -> Proof
reverseAppendFlip xs ys = case xs of
  Nil ->
    reverse (Nil ++ ys)
    ==. reverse ys
    ==. reverse ys ++ Nil ? appendRightId (reverse ys)
    ==. reverse ys ++ reverse Nil
    *** QED
  x:::xs' ->
    reverse ((x:::xs') ++ ys)
    ==. reverse (x:::(xs' ++ ys))
    ==. reverse (xs' ++ ys) ++ (x:::Nil)
    ==. (reverse ys ++ reverse xs') ++ (x:::Nil) ? reverseAppendFlip xs' ys
    ==. reverse ys ++ (reverse xs' ++ (x:::Nil)) ? appendAssoc (reverse ys) (reverse xs') (x:::Nil)
    ==. reverse ys ++ reverse (x:::xs')
    *** QED

{-@ reverseOwnInverse :: xs:List a -> { v:() | reverse (reverse xs) = xs } @-}
reverseOwnInverse :: List a -> Proof
reverseOwnInverse xs = case xs of
  Nil -> trivial
  x:::xs' ->
    reverse (reverse (x:::xs'))
    ==. reverse (reverse xs' ++ (x:::Nil))
    ==. reverse (x:::Nil) ++ reverse (reverse xs') ? reverseAppendFlip (reverse xs') (x:::Nil)
    ==. (x:::Nil) ++ xs' ? reverseOwnInverse xs'
    ==. x:::xs'
    *** QED
