{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes #-}

module Main (main) where

import C925CrossedEdgeLensToy

assert :: Bool -> String -> IO ()
assert condition message = if condition then pure () else error message

main :: IO ()
main = do
  let one = poly [1]
      nativeRank = nativeValue (nativeCommon one)
      hostileOutput = runFromMoving hostileEdge testMovingOne
      crossedOutput = edgeCrossed hostileOutput
      movingOutput = edgeMoving hostileOutput
      movingOnlyDefect = subtractPoly one movingOutput
      crossedDefect = subtractPoly one (addPoly crossedOutput movingOutput)
      compositeOutput = runFromMoving (compose firstEdge secondEdge) testMovingOne
      compositeCross = edgeCrossed compositeOutput
      compositeMoving = edgeMoving compositeOutput
      expectedCross = addPoly (multiplyPoly q q) q
      expectedMoving = multiplyPoly q q
  assert (evaluateAtOne nativeRank == 1) "native common rank must remain visible"
  assert (orderAtOne movingOnlyDefect == Just 0) "plain moving defect must have order zero"
  assert (crossedDefect == subtractPoly one q) "crossed defect must be 1-q"
  assert (orderAtOne crossedDefect == Just 1) "crossed defect must have order one"
  assert (compositeCross == expectedCross) "cross composition B21=A2 B1+B2 D1 failed"
  assert (compositeMoving == expectedMoving) "cross composition D21=D2 D1 failed"
  putStrLn "native_common_rank_at_q1=1"
  putStrLn "moving_only_defect_order_at_q1=0"
  putStrLn "crossed_defect=1-q"
  putStrLn "crossed_defect_order_at_q1=1"
  putStrLn "typed_composition=B21=A2B1+B2D1,D21=D2D1"
