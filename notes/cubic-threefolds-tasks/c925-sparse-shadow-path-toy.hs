{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}

-- A finite executable model of the C925 sparse-shadow architecture.
-- It checks types and laws only; it is not a QDM comparison theorem.

import Control.Monad (unless)
import Data.List (intercalate)
import qualified Data.Set as Set

data SourceStage = SourceRich | SourceCoarse
data TargetStage = TargetRich | TargetCoarse

type family FStage (s :: SourceStage) :: TargetStage where
  FStage 'SourceRich = 'TargetRich
  FStage 'SourceCoarse = 'TargetCoarse

data SourcePath (s :: SourceStage) (t :: SourceStage) where
  SId :: SourcePath s s
  SForget :: SourcePath 'SourceRich 'SourceCoarse
  SCompose :: SourcePath s t -> SourcePath t u -> SourcePath s u

data TargetPath (s :: TargetStage) (t :: TargetStage) where
  TId :: TargetPath s s
  TForget :: TargetPath 'TargetRich 'TargetCoarse
  TCompose :: TargetPath s t -> TargetPath t u -> TargetPath s u

-- The user's proposed function from one indexed path type to another.
mapPath :: SourcePath s t -> TargetPath (FStage s) (FStage t)
mapPath SId = TId
mapPath SForget = TForget
mapPath (SCompose p q) = TCompose (mapPath p) (mapPath q)

sourceWord :: SourcePath s t -> [String]
sourceWord SId = []
sourceWord SForget = ["forget"]
sourceWord (SCompose p q) = sourceWord p ++ sourceWord q

targetWord :: TargetPath s t -> [String]
targetWord TId = []
targetWord TForget = ["mapped-forget"]
targetWord (TCompose p q) = targetWord p ++ targetWord q

-- A numerical model of the naturality square.  The target realization scales
-- both payloads and path increments by two.
sourceCost :: SourcePath s t -> Int
sourceCost SId = 0
sourceCost SForget = 1
sourceCost (SCompose p q) = sourceCost p + sourceCost q

targetCost :: TargetPath s t -> Int
targetCost TId = 0
targetCost TForget = 2
targetCost (TCompose p q) = targetCost p + targetCost q

sourceTransport :: SourcePath s t -> Int -> Int
sourceTransport p value = value + sourceCost p

targetTransport :: TargetPath s t -> Int -> Int
targetTransport p value = value + targetCost p

mapShadow :: Int -> Int
mapShadow = (2 *)

data Orientation = Plus | Minus deriving (Eq, Show)
data Rich = Rich {carrier :: String, orientation :: Orientation}
  deriving (Eq, Show)
newtype Coarse = Coarse String deriving (Eq, Show)
newtype Residual = Residual Orientation deriving (Eq, Show)

getCarrier :: Rich -> Coarse
getCarrier = Coarse . carrier

putCarrier :: Rich -> Coarse -> Rich
putCarrier rich (Coarse newCarrier) = rich {carrier = newCarrier}

residualize :: Rich -> (Residual, Coarse)
residualize rich = (Residual (orientation rich), getCarrier rich)

reconstruct :: (Residual, Coarse) -> Rich
reconstruct (Residual sign, Coarse axes) = Rich axes sign

parallelProjection :: Rich -> String
parallelProjection rich =
  carrier rich ++ ":chordal:" ++ case orientation rich of
    Plus -> "+"
    Minus -> "-"

forgetPathFor :: Rich -> [String]
forgetPathFor _ = sourceWord SForget

data Ledger (s :: SourceStage) where
  RichLedger :: Rich -> Ledger 'SourceRich
  CoarseLedger :: Coarse -> Ledger 'SourceCoarse

deriving instance Show (Ledger s)

data Env = Env
  { globalIdeal :: String,
    coefficientSpine :: String
  }
  deriving (Eq, Show)

newtype Evidence = Evidence (Set.Set String) deriving (Eq, Show)

instance Semigroup Evidence where
  Evidence left <> Evidence right = Evidence (Set.union left right)

instance Monoid Evidence where
  mempty = Evidence Set.empty

singletonEvidence :: String -> Evidence
singletonEvidence = Evidence . Set.singleton

newtype ProofM (s :: SourceStage) (t :: SourceStage) a = ProofM
  { runProofM ::
      Env ->
      Ledger s ->
      (a, Ledger t, Evidence, SourcePath s t)
  }

ireturn :: a -> ProofM s s a
ireturn value = ProofM $ \_ ledger -> (value, ledger, mempty, SId)

ibind :: ProofM s t a -> (a -> ProofM t u b) -> ProofM s u b
ibind first continue = ProofM $ \env source ->
  let (value, middle, evidence1, path1) = runProofM first env source
      (result, target, evidence2, path2) =
        runProofM (continue value) env middle
   in (result, target, evidence1 <> evidence2, SCompose path1 path2)

forgetStep :: ProofM 'SourceRich 'SourceCoarse ()
forgetStep = ProofM $ \env (RichLedger rich) ->
  ( (),
    CoarseLedger (getCarrier rich),
    singletonEvidence ("forget@" ++ coefficientSpine env),
    SForget
  )

inspectStep :: String -> ProofM 'SourceCoarse 'SourceCoarse String
inspectStep label = ProofM $ \env ledger ->
  ( globalIdeal env,
    ledger,
    singletonEvidence ("inspect:" ++ label ++ "@" ++ globalIdeal env),
    SId
  )

snapshot :: Show a => (a, Ledger s, Evidence, SourcePath p q) -> String
snapshot (value, ledger, evidence, path) =
  intercalate "|" [show value, show ledger, show evidence, show (sourceWord path)]

kernelProfile :: [Int] -> [Int]
kernelProfile blocks =
  let dimension = sum blocks
   in [sum [min power block | block <- blocks] | power <- [1 .. dimension]]

partitionFromProfile :: [Int] -> [Int]
partitionFromProfile profile =
  let kernels = 0 : profile ++ [last profile]
      exact size =
        2 * (kernels !! size)
          - (kernels !! (size - 1))
          - (kernels !! (size + 1))
   in reverse (concat [replicate (exact size) size | size <- [1 .. length profile]])

topRank :: Int -> [Int] -> Int
topRank power blocks = sum [max 0 (block - power) | block <- blocks]

data Character = Zeta6 | Zeta6Bar | Trivial deriving (Eq, Show)
data MarkedBlock = MarkedBlock
  { blockCharacter :: Character,
    pointRowVisible :: Bool
  }
  deriving (Eq, Show)

isPrimitiveSixth :: Character -> Bool
isPrimitiveSixth Zeta6 = True
isPrimitiveSixth Zeta6Bar = True
isPrimitiveSixth Trivial = False

unmarkedPrimitiveCount :: [MarkedBlock] -> Int
unmarkedPrimitiveCount =
  length . filter (isPrimitiveSixth . blockCharacter)

pointedPrimaryBoolean :: [MarkedBlock] -> Bool
pointedPrimaryBoolean =
  any
    ( \block ->
        isPrimitiveSixth (blockCharacter block) && pointRowVisible block
    )

check :: String -> Bool -> IO ()
check name condition = do
  unless condition (error (name ++ " failed"))
  putStrLn (name ++ ": pass")

main :: IO ()
main = do
  let p = SForget
      q = SId
      composite = SCompose p q
  check "path_functor_identity" (targetWord (mapPath SId) == [])
  check
    "path_functor_composition"
    ( targetWord (mapPath composite)
        == targetWord (mapPath p) ++ targetWord (mapPath q)
    )
  check
    "path_payload_naturality"
    ( mapShadow (sourceTransport composite 7)
        == targetTransport (mapPath composite) (mapShadow 7)
    )

  let env = Env "rank-zero" "C[q][[Q,t]]"
      initial = RichLedger (Rich "six-axes" Plus)
      leftAssociated =
        (forgetStep `ibind` const (inspectStep "a"))
          `ibind` (\_ -> inspectStep "b")
      rightAssociated =
        forgetStep
          `ibind` (\_ -> inspectStep "a" `ibind` (\_ -> inspectStep "b"))
      leftUnit = ireturn () `ibind` const forgetStep
      rightUnit = forgetStep `ibind` ireturn
  check
    "reader_indexed_state_writer_associativity"
    ( snapshot (runProofM leftAssociated env initial)
        == snapshot (runProofM rightAssociated env initial)
    )
  check
    "reader_indexed_state_writer_units"
    ( snapshot (runProofM leftUnit env initial)
        == snapshot (runProofM forgetStep env initial)
        && snapshot (runProofM rightUnit env initial)
          == snapshot (runProofM forgetStep env initial)
    )

  let richPlus = Rich "six-axes" Plus
      richMinus = Rich "six-axes" Minus
      newFocus = Coarse "renamed-axes"
  check
    "lens_laws"
    ( getCarrier (putCarrier richPlus newFocus) == newFocus
        && putCarrier richPlus (getCarrier richPlus) == richPlus
        && putCarrier (putCarrier richPlus (Coarse "middle")) newFocus
          == putCarrier richPlus newFocus
    )
  check
    "path_label_alone_is_not_reconstructive"
    ( getCarrier richPlus == getCarrier richMinus
        && forgetPathFor richPlus == forgetPathFor richMinus
        && parallelProjection richPlus /= parallelProjection richMinus
    )
  check
    "optic_residual_recovers_parallel_projection"
    ( reconstruct (residualize richPlus) == richPlus
        && reconstruct (residualize richMinus) == richMinus
        && parallelProjection (reconstruct (residualize richPlus))
          == "six-axes:chordal:+"
    )

  let j3 = [3]
      j2j1 = [2, 1]
      split3 = [1, 1, 1]
  check
    "kernel_profile_reconstructs_jordan_partition"
    ( partitionFromProfile (kernelProfile j3) == j3
        && partitionFromProfile (kernelProfile j2j1) == j2j1
        && partitionFromProfile (kernelProfile split3) == split3
    )
  check
    "sparse_top_rank_detects_j3"
    (topRank 2 j3 == 1 && topRank 2 j2j1 == 0 && topRank 2 split3 == 0)

  let cubicP2 =
        replicate 3 (MarkedBlock Zeta6 True)
          ++ replicate 3 (MarkedBlock Zeta6Bar True)
      projective5 = replicate 6 (MarkedBlock Trivial True)
      projective5WithExceptionalPacket =
        MarkedBlock Zeta6 False : projective5
  check
    "m2_pointed_primary_specialization"
    ( unmarkedPrimitiveCount cubicP2 == 6
        && pointedPrimaryBoolean cubicP2
        && unmarkedPrimitiveCount projective5 == 0
        && not (pointedPrimaryBoolean projective5)
        && unmarkedPrimitiveCount projective5WithExceptionalPacket == 1
        && not (pointedPrimaryBoolean projective5WithExceptionalPacket)
    )
