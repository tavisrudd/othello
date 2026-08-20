{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}

-- A concrete GADT model of the Module 55 source contract.
-- It checks type separation and eliminator wiring only; it proves no QDM fact.

module Main (main) where

import Control.Monad (unless)

data Overlap = Coordinate11
data Side = LeftSide | RightSide
data BasedLoop = MainLoop | OtherLoop
data PhaseCharacter = PrimitiveSixth | TrivialCharacter
data Resonance = Nonresonant | Integral
data Normalization = Raw | Residual
data Nat = Z | S Nat
data Direction = LeftToRight | RightToLeft

data Packet
  (o :: Overlap)
  (s :: Side)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  where
  Packet :: String -> Packet o s loop chi

packetName :: Packet o s loop chi -> String
packetName (Packet name) = name

data RowFidelity
  (o :: Overlap)
  (s :: Side)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  where
  RowFidelity :: RowFidelity o s loop chi

data LawfulReindexing
  (o :: Overlap)
  (loop :: BasedLoop)
  (chi :: PhaseCharacter)
  where
  LawfulReindexing :: LawfulReindexing o loop chi

data Endpoints o loop chi where
  Endpoints ::
    Packet o 'LeftSide loop chi ->
    Packet o 'RightSide loop chi ->
    RowFidelity o 'LeftSide loop chi ->
    RowFidelity o 'RightSide loop chi ->
    LawfulReindexing o loop chi ->
    Endpoints o loop chi

data LambdaReceiver o loop chi where
  LambdaReceiver :: LambdaReceiver o loop chi

data LambdaPacketRowRealization o side loop chi where
  LambdaPacketRowRealization ::
    LambdaPacketRowRealization o side loop chi

data SDirection (d :: Direction) where
  SLeftToRight :: SDirection 'LeftToRight
  SRightToLeft :: SDirection 'RightToLeft

directionName :: SDirection d -> String
directionName SLeftToRight = "left-to-right"
directionName SRightToLeft = "right-to-left"

data ProjectedVariationZero o loop chi (d :: Direction) where
  ProjectedVariationZero :: ProjectedVariationZero o loop chi d

data ProjectedSource o loop chi where
  ProjectedSource ::
    LambdaReceiver o loop chi ->
    LambdaPacketRowRealization o 'LeftSide loop chi ->
    LambdaPacketRowRealization o 'RightSide loop chi ->
    SDirection d ->
    ProjectedVariationZero o loop chi d ->
    ProjectedSource o loop chi

-- This is intentionally a different type from LambdaReceiver.  A theorem
-- about the pre-Laplace lambda-line cannot fill a resonance-trait field.
data TraitMiddleExtension o loop chi (r :: Resonance) where
  IntegralTraitMiddleExtension ::
    TraitMiddleExtension o loop chi 'Integral

-- The currently cited GKZ source has only the nonresonant index.  There is
-- deliberately no coercion from this type to IntegralTraitMiddleExtension.
data GkzSource (r :: Resonance) where
  NonresonantGkzSource :: GkzSource 'Nonresonant

gkzName :: GkzSource r -> String
gkzName NonresonantGkzSource = "nonresonant-only"

data CoimageComparison
  o
  loop
  chi
  (n :: Normalization)
  (order :: Nat)
  where
  RawCoimageComparison ::
    Int -> CoimageComparison o loop chi 'Raw order
  ResidualCoimageComparison ::
    Int -> CoimageComparison o loop chi 'Residual order

data ConormalFactor o loop chi (order :: Nat) where
  ConormalFactor :: ConormalFactor o loop chi order

normalizeCoimage ::
  ConormalFactor o loop chi order ->
  CoimageComparison o loop chi 'Raw order ->
  CoimageComparison o loop chi 'Residual order
normalizeCoimage ConormalFactor (RawCoimageComparison unit) =
  ResidualCoimageComparison unit

residualUnit :: CoimageComparison o loop chi 'Residual order -> Int
residualUnit (ResidualCoimageComparison unit) = unit

data ExactClosedPacketRowReader o loop chi where
  ExactClosedPacketRowReader :: ExactClosedPacketRowReader o loop chi

data SafeOverlap o loop chi where
  ByProjectedVariation ::
    Endpoints o loop chi ->
    ProjectedSource o loop chi ->
    SafeOverlap o loop chi
  ByTraitMiddleExtension ::
    Endpoints o loop chi ->
    TraitMiddleExtension o loop chi 'Integral ->
    CoimageComparison o loop chi 'Residual order ->
    ExactClosedPacketRowReader o loop chi ->
    SafeOverlap o loop chi

consumeSafeOverlap :: SafeOverlap o loop chi -> String
consumeSafeOverlap (ByProjectedVariation endpoints _) =
  endpointWord endpoints ++ ":projected"
consumeSafeOverlap (ByTraitMiddleExtension endpoints _ comparison _) =
  endpointWord endpoints
    ++ ":trait-unit="
    ++ show (residualUnit comparison)

endpointWord :: Endpoints o loop chi -> String
endpointWord (Endpoints left right _ _ _) =
  packetName left ++ "->" ++ packetName right

coordinateEndpoints ::
  Endpoints 'Coordinate11 'MainLoop 'PrimitiveSixth
coordinateEndpoints =
  Endpoints
    (Packet "left-11")
    (Packet "right-11")
    RowFidelity
    RowFidelity
    LawfulReindexing

projectedProvider ::
  SafeOverlap 'Coordinate11 'MainLoop 'PrimitiveSixth
projectedProvider =
  ByProjectedVariation
    coordinateEndpoints
    ( ProjectedSource
        LambdaReceiver
        LambdaPacketRowRealization
        LambdaPacketRowRealization
        SLeftToRight
        ProjectedVariationZero
    )

rawComparison ::
  CoimageComparison
    'Coordinate11
    'MainLoop
    'PrimitiveSixth
    'Raw
    ('S 'Z)
rawComparison = RawCoimageComparison (-1)

traitProvider ::
  SafeOverlap 'Coordinate11 'MainLoop 'PrimitiveSixth
traitProvider =
  ByTraitMiddleExtension
    coordinateEndpoints
    IntegralTraitMiddleExtension
    (normalizeCoimage ConormalFactor rawComparison)
    ExactClosedPacketRowReader

wrongLoopPacket ::
  Packet 'Coordinate11 'LeftSide 'OtherLoop 'PrimitiveSixth
wrongLoopPacket = Packet "wrong-loop"

wrongCharacterPacket ::
  Packet 'Coordinate11 'LeftSide 'MainLoop 'TrivialCharacter
wrongCharacterPacket = Packet "wrong-character"

-- The following illegal terms have no type-correct spelling:
--
-- * ByTraitMiddleExtension ... LambdaReceiver ...
-- * ByTraitMiddleExtension ... NonresonantGkzSource ...
-- * ByTraitMiddleExtension ... rawComparison ...
-- * normalizeCoimage (ConormalFactor :: ... ('S ('S 'Z))) rawComparison
-- * an endpoint pair whose packets use different loops or characters.

check :: String -> Bool -> IO ()
check name condition = do
  unless condition (error (name ++ " failed"))
  putStrLn (name ++ ": pass")

main :: IO ()
main = do
  check
    "projected_source_provider_is_fully_indexed"
    (consumeSafeOverlap projectedProvider == "left-11->right-11:projected")
  check
    "trait_source_requires_normalized_residual"
    (consumeSafeOverlap traitProvider == "left-11->right-11:trait-unit=-1")
  check
    "source_routes_share_only_the_safe_eliminator"
    ( take 18 (consumeSafeOverlap projectedProvider)
        == take 18 (consumeSafeOverlap traitProvider)
    )
  check
    "hostile_indices_exist_but_cannot_fill_the_safe_constructor"
    ( packetName wrongLoopPacket == "wrong-loop"
        && packetName wrongCharacterPacket == "wrong-character"
        && directionName SRightToLeft == "right-to-left"
        && gkzName NonresonantGkzSource == "nonresonant-only"
    )
