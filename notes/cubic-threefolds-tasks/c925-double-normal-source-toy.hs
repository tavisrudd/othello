{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}

-- A concrete GADT model of the Module 56 producer boundary.
-- The constructors model typed evidence; the mathematical equations are
-- proved in Theorem 56.1, not by this program.

module Main (main) where

import Control.Monad (unless)

data Occurrence = Coordinate11 | OtherOccurrence
data Trait = IntegralTrait | OtherTrait
data Receiver = CommonReceiver | OtherReceiver
data RawRow = RankRow | OtherRow
data BasedLoop = MainLoop | OtherLoop
data PhaseCharacter = PrimitiveSixth | TrivialCharacter
data Wall = LeftWall | RightWall
data Direction = LeftToRight | RightToLeft
data FactorId = LeftFactorId | RightFactorId | OtherFactorId
data CanMap = LeftCan | RightCan | OtherCan
data VarMap = LeftVar | RightVar | OtherVar
data Operation = LeftMonodromy | RightMonodromy | OtherOperation
data Nat = Z | S Nat

-- There is deliberately no constructor at order Z.
data PositiveOrder (order :: Nat) where
  PositiveOrder :: PositiveOrder ('S n)

data CommonRawRow
  (o :: Occurrence)
  (trait :: Trait)
  (receiver :: Receiver)
  (row :: RawRow)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  where
  CommonRawRow ::
    CommonRawRow o trait receiver row loop chi

-- Its private constructor stands for both equations
--   rawRow . var = normal * dividedRow
--   dividedRow . can = unit * rawRow.
data CanVarFactor
  (o :: Occurrence)
  (trait :: Trait)
  (receiver :: Receiver)
  (row :: RawRow)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  (wall :: Wall)
  (factorId :: FactorId)
  (canMap :: CanMap)
  (varMap :: VarMap)
  (operation :: Operation)
  (order :: Nat)
  where
  CanVarFactor ::
    String ->
    Int ->
    PositiveOrder order ->
    CanVarFactor
      o trait receiver row loop chi wall factorId canMap varMap operation order

factorUnit ::
  CanVarFactor
    o trait receiver row loop chi wall factorId canMap varMap operation order ->
  Int
factorUnit (CanVarFactor _ unit _) = unit

data ExactClosedCanVarReader
  (o :: Occurrence)
  (trait :: Trait)
  (receiver :: Receiver)
  (row :: RawRow)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  (direction :: Direction)
  (sourceFactor :: FactorId)
  (sourceCan :: CanMap)
  (sourceVar :: VarMap)
  (sourceOperation :: Operation)
  (landingFactor :: FactorId)
  (landingCan :: CanMap)
  (landingVar :: VarMap)
  (landingOperation :: Operation)
  where
  ExactClosedCanVarReader ::
    ExactClosedCanVarReader
      o trait receiver row loop chi direction
      sourceFactor sourceCan sourceVar sourceOperation
      landingFactor landingCan landingVar landingOperation

data ProjectedVariationZero
  (o :: Occurrence)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  (direction :: Direction)
  where
  ProjectedVariationZero ::
    Int -> ProjectedVariationZero o loop chi direction

doubleNormalLeftToRight ::
  CommonRawRow o trait receiver row loop chi ->
  CanVarFactor
    o trait receiver row loop chi 'LeftWall
    'LeftFactorId 'LeftCan 'LeftVar 'LeftMonodromy ('S sourceOrder) ->
  CanVarFactor
    o trait receiver row loop chi 'RightWall
    'RightFactorId 'RightCan 'RightVar 'RightMonodromy ('S landingOrder) ->
  ExactClosedCanVarReader
    o trait receiver row loop chi 'LeftToRight
    'LeftFactorId 'LeftCan 'LeftVar 'LeftMonodromy
    'RightFactorId 'RightCan 'RightVar 'RightMonodromy ->
  ProjectedVariationZero o loop chi 'LeftToRight
doubleNormalLeftToRight _ source landing _ =
  ProjectedVariationZero (factorUnit source * factorUnit landing)

doubleNormalRightToLeft ::
  CommonRawRow o trait receiver row loop chi ->
  CanVarFactor
    o trait receiver row loop chi 'RightWall
    'RightFactorId 'RightCan 'RightVar 'RightMonodromy ('S sourceOrder) ->
  CanVarFactor
    o trait receiver row loop chi 'LeftWall
    'LeftFactorId 'LeftCan 'LeftVar 'LeftMonodromy ('S landingOrder) ->
  ExactClosedCanVarReader
    o trait receiver row loop chi 'RightToLeft
    'RightFactorId 'RightCan 'RightVar 'RightMonodromy
    'LeftFactorId 'LeftCan 'LeftVar 'LeftMonodromy ->
  ProjectedVariationZero o loop chi 'RightToLeft
doubleNormalRightToLeft _ source landing _ =
  ProjectedVariationZero (factorUnit source * factorUnit landing)

proofLabel :: ProjectedVariationZero o loop chi direction -> String
proofLabel (ProjectedVariationZero units) =
  "closed-zero:residual-units=" ++ show units

commonRow ::
  CommonRawRow
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
commonRow = CommonRawRow

leftFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
leftFactor = CanVarFactor "left" (-1) PositiveOrder

rightFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'RightWall
    'RightFactorId
    'RightCan
    'RightVar
    'RightMonodromy
    ('S ('S 'Z))
rightFactor = CanVarFactor "right" 1 PositiveOrder

leftToRightReader ::
  ExactClosedCanVarReader
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'LeftToRight
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    'RightFactorId
    'RightCan
    'RightVar
    'RightMonodromy
leftToRightReader = ExactClosedCanVarReader

rightToLeftReader ::
  ExactClosedCanVarReader
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'RightToLeft
    'RightFactorId
    'RightCan
    'RightVar
    'RightMonodromy
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
rightToLeftReader = ExactClosedCanVarReader

-- These mismatched witnesses exist, but cannot be passed to either smart
-- constructor with commonRow and the lawful factors/readers above.
wrongReceiverFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'OtherReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
wrongReceiverFactor = CanVarFactor "wrong-receiver" 1 PositiveOrder

wrongRowFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'OtherRow
    'MainLoop
    'PrimitiveSixth
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
wrongRowFactor = CanVarFactor "wrong-row" 1 PositiveOrder

wrongOccurrenceFactor ::
  CanVarFactor
    'OtherOccurrence
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
wrongOccurrenceFactor = CanVarFactor "wrong-occurrence" 1 PositiveOrder

wrongLoopFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'OtherLoop
    'PrimitiveSixth
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
wrongLoopFactor = CanVarFactor "wrong-loop" 1 PositiveOrder

wrongCharacterFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'TrivialCharacter
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
wrongCharacterFactor = CanVarFactor "wrong-character" 1 PositiveOrder

wrongTraitFactor ::
  CanVarFactor
    'Coordinate11
    'OtherTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'LeftWall
    'LeftFactorId
    'LeftCan
    'LeftVar
    'LeftMonodromy
    ('S 'Z)
wrongTraitFactor = CanVarFactor "wrong-trait" 1 PositiveOrder

wrongMapsFactor ::
  CanVarFactor
    'Coordinate11
    'IntegralTrait
    'CommonReceiver
    'RankRow
    'MainLoop
    'PrimitiveSixth
    'LeftWall
    'OtherFactorId
    'OtherCan
    'OtherVar
    'OtherOperation
    ('S 'Z)
wrongMapsFactor = CanVarFactor "wrong-maps" 1 PositiveOrder

-- The following illegal terms have no type-correct spelling:
--
-- * doubleNormalLeftToRight commonRow wrongReceiverFactor rightFactor ...
-- * doubleNormalLeftToRight commonRow wrongRowFactor rightFactor ...
-- * doubleNormalLeftToRight commonRow rightFactor leftFactor ...
-- * doubleNormalRightToLeft commonRow leftFactor rightFactor ...
-- * CanVarFactor ... (PositiveOrder :: PositiveOrder 'Z)
-- * using a reader indexed by OtherLoop, TrivialCharacter, or factor/map IDs
--   other than those carried by the two actual factor witnesses.

check :: String -> Bool -> IO ()
check name condition = do
  unless condition (error (name ++ " failed"))
  putStrLn (name ++ ": pass")

main :: IO ()
main = do
  let forward =
        doubleNormalLeftToRight
          commonRow
          leftFactor
          rightFactor
          leftToRightReader
      backward =
        doubleNormalRightToLeft
          commonRow
          rightFactor
          leftFactor
          rightToLeftReader
  check
    "two_positive_one_wall_factors_construct_forward_zero"
    (proofLabel forward == "closed-zero:residual-units=-1")
  check
    "direction_reversal_swaps_source_and_landing_factors"
    (proofLabel backward == "closed-zero:residual-units=-1")
  check
    "zero_order_has_no_positive_order_constructor"
    (factorUnit leftFactor == -1 && factorUnit rightFactor == 1)
  check
    "mismatched_receiver_and_row_exist_but_cannot_reach_smart_constructor"
    ( factorUnit wrongReceiverFactor == 1
        && factorUnit wrongRowFactor == 1
        && factorUnit wrongOccurrenceFactor == 1
        && factorUnit wrongLoopFactor == 1
        && factorUnit wrongCharacterFactor == 1
        && factorUnit wrongTraitFactor == 1
        && factorUnit wrongMapsFactor == 1
    )
