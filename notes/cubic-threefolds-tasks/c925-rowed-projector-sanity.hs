{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- Computational sanity checks for the final C925 source/consumer pipeline.
--
-- This executable mirrors the algebraic interface proved in
-- RowedProjectorDecomposition.lean.  It does not prove any Gu--Yu--Yu,
-- Iritani, or KKPYY source theorem.  Instead, it checks a finite model of the
-- interface exhaustively and refuses to expose the consumer until every
-- external source obligation has been named and every algebraic square has
-- passed.

module Main (main) where

import Control.Monad (unless)
import Data.List (intercalate, transpose)
import Data.Maybe (isNothing)
import qualified Test.QuickCheck as QC
import Test.QuickCheck.Random (mkQCGen)

newtype F3 = F3 Int
  deriving (Eq, Ord)

normalize :: Int -> Int
normalize value = value `mod` 3

instance Show F3 where
  show (F3 value) = show (normalize value)

instance Num F3 where
  F3 left + F3 right = F3 (normalize (left + right))
  F3 left * F3 right = F3 (normalize (left * right))
  negate (F3 value) = F3 (normalize (negate value))
  abs = id
  signum (F3 value) = if normalize value == 0 then 0 else 1
  fromInteger value = F3 (normalize (fromInteger value))

type Vector = [F3]
type Matrix = [[F3]]

f3Values :: [F3]
f3Values = [0, 1, 2]

allVectors :: Int -> [Vector]
allVectors 0 = [[]]
allVectors dimension =
  [ entry : rest
  | entry <- f3Values
  , rest <- allVectors (dimension - 1)
  ]

identity :: Int -> Matrix
identity size =
  [ [if row == column then 1 else 0 | column <- [0 .. size - 1]]
  | row <- [0 .. size - 1]
  ]

zeroMatrix :: Int -> Int -> Matrix
zeroMatrix rows columns = replicate rows (replicate columns 0)

matrixVector :: Matrix -> Vector -> Vector
matrixVector matrix vector =
  [sum (zipWith (*) row vector) | row <- matrix]

matrixMultiply :: Matrix -> Matrix -> Matrix
matrixMultiply left right =
  [ [sum (zipWith (*) row column) | column <- transpose right]
  | row <- left
  ]

matrixPowerTwo :: Matrix -> Matrix
matrixPowerTwo matrix = matrixMultiply matrix matrix

determinantTwo :: Matrix -> F3
determinantTwo [[a, b], [c, d]] = a * d - b * c
determinantTwo _ = error "determinantTwo: expected a 2-by-2 matrix"

inverseScalar :: F3 -> F3
inverseScalar 1 = 1
inverseScalar 2 = 2
inverseScalar _ = error "inverseScalar: zero is not invertible"

inverseTwo :: Matrix -> Matrix
inverseTwo matrix@[[a, b], [c, d]] =
  let inverseDeterminant = inverseScalar (determinantTwo matrix)
   in [ [inverseDeterminant * d, inverseDeterminant * negate b]
      , [inverseDeterminant * negate c, inverseDeterminant * a]
      ]
inverseTwo _ = error "inverseTwo: expected a 2-by-2 matrix"

allInvertibleTwo :: [(Matrix, Matrix)]
allInvertibleTwo =
  [ (matrix, inverseTwo matrix)
  | a <- f3Values
  , b <- f3Values
  , c <- f3Values
  , d <- f3Values
  , let matrix = [[a, b], [c, d]]
  , determinantTwo matrix /= 0
  ]

blockProjector :: F3 -> F3 -> Matrix
blockProjector ambient correction = [[ambient, 0], [0, correction]]

liftAmbientRow :: Matrix -> Matrix
liftAmbientRow = map (++ [0])

standardBasis :: Int -> [Vector]
standardBasis size =
  [ [if row == column then 1 else 0 | row <- [0 .. size - 1]]
  | column <- [0 .. size - 1]
  ]

nonzeroVector :: Vector -> Bool
nonzeroVector = any (/= 0)

firstCoordinate :: Vector -> F3
firstCoordinate (entry : _) = entry
firstCoordinate [] = error "firstCoordinate: expected a nonempty vector"

scalarEntry :: Matrix -> F3
scalarEntry [[entry]] = entry
scalarEntry _ = error "scalarEntry: expected a 1-by-1 matrix"

data RawBundle = RawBundle
  { sourceProjector :: Matrix
  , ambientProjector :: Matrix
  , correctionProjector :: Matrix
  , comparison :: Matrix
  , comparisonInverse :: Matrix
  , sourceRow :: Matrix
  , ambientRow :: Matrix
  }

legalBundle :: Matrix -> Matrix -> F3 -> F3 -> Matrix -> RawBundle
legalBundle comparisonMatrix inverseMatrix ambientMark correctionMark row =
  let block = blockProjector ambientMark correctionMark
      sourceMark = matrixMultiply inverseMatrix (matrixMultiply block comparisonMatrix)
      liftedRow = liftAmbientRow row
   in RawBundle
        { sourceProjector = sourceMark
        , ambientProjector = [[ambientMark]]
        , correctionProjector = [[correctionMark]]
        , comparison = comparisonMatrix
        , comparisonInverse = inverseMatrix
        , sourceRow = matrixMultiply liftedRow comparisonMatrix
        , ambientRow = row
        }

projectorIsIdempotent :: Matrix -> Bool
projectorIsIdempotent projector = matrixPowerTwo projector == projector

comparisonIsInvertible :: RawBundle -> Bool
comparisonIsInvertible bundle =
  matrixMultiply (comparison bundle) (comparisonInverse bundle) == identity 2
    && matrixMultiply (comparisonInverse bundle) (comparison bundle) == identity 2

rowSquareAt :: RawBundle -> Vector -> Bool
rowSquareAt bundle vector =
  matrixVector (sourceRow bundle) vector
    == matrixVector
      (ambientRow bundle)
      [firstCoordinate (matrixVector (comparison bundle) vector)]

projectorSquareAt :: RawBundle -> Vector -> Bool
projectorSquareAt bundle vector =
  matrixVector
    (comparison bundle)
    (matrixVector (sourceProjector bundle) vector)
    == matrixVector
      (blockProjector
        (scalarEntry (ambientProjector bundle))
        (scalarEntry (correctionProjector bundle)))
      (matrixVector (comparison bundle) vector)

basisSquaresHold :: RawBundle -> Bool
basisSquaresHold bundle =
  all (rowSquareAt bundle) (standardBasis 2)
    && all (projectorSquareAt bundle) (standardBasis 2)

fullSquaresHold :: RawBundle -> Bool
fullSquaresHold bundle =
  all (rowSquareAt bundle) (allVectors 2)
    && all (projectorSquareAt bundle) (allVectors 2)

validateRawBundle :: RawBundle -> Bool
validateRawBundle bundle =
  comparisonIsInvertible bundle
    && projectorIsIdempotent (sourceProjector bundle)
    && projectorIsIdempotent (ambientProjector bundle)
    && projectorIsIdempotent (correctionProjector bundle)
    && basisSquaresHold bundle

detects :: Int -> Matrix -> Matrix -> Bool
detects dimension projector row =
  any
    (\vector ->
      matrixVector projector vector == vector
        && nonzeroVector (matrixVector row vector))
    (allVectors dimension)

sourceDetects :: RawBundle -> Bool
sourceDetects bundle = detects 2 (sourceProjector bundle) (sourceRow bundle)

ambientDetects :: RawBundle -> Bool
ambientDetects bundle = detects 1 (ambientProjector bundle) (ambientRow bundle)

data SourceFact
  = OrdinaryEquivariantBasis
  | ShiftPreservesOrdinarySource
  | FundamentalSolutionAdjointSquare
  | CompletedComparisonIsomorphism
  | ConnectionNaturality
  | CanonicalMarkedSpectralUnion
  deriving (Eq, Enum, Bounded, Show)

allSourceFacts :: [SourceFact]
allSourceFacts = [minBound .. maxBound]

newtype CertifiedBundle = CertifiedBundle RawBundle

certify :: [SourceFact] -> RawBundle -> Maybe CertifiedBundle
certify supplied bundle
  | all (`elem` supplied) allSourceFacts && validateRawBundle bundle =
      Just (CertifiedBundle bundle)
  | otherwise = Nothing

consumerDetectsIff :: CertifiedBundle -> Bool
consumerDetectsIff (CertifiedBundle bundle) =
  sourceDetects bundle == ambientDetects bundle

sourceFactName :: SourceFact -> String
sourceFactName OrdinaryEquivariantBasis = "gyy_prop_5_2_basis"
sourceFactName ShiftPreservesOrdinarySource = "gyy_props_2_4_2_8_shift_legality"
sourceFactName FundamentalSolutionAdjointSquare = "gyy_prop_4_21_row_square"
sourceFactName CompletedComparisonIsomorphism = "gyy_thm_5_5_comparison"
sourceFactName ConnectionNaturality = "comparison_connection_naturality"
sourceFactName CanonicalMarkedSpectralUnion = "kkpyy_canonical_marked_union"

allLegalBundles :: [RawBundle]
allLegalBundles =
  [ legalBundle matrix inverseMatrix ambientMark correctionMark [[rowValue]]
  | (matrix, inverseMatrix) <- allInvertibleTwo
  , ambientMark <- [0, 1]
  , correctionMark <- [0, 1]
  , rowValue <- f3Values
  ]

certifiedLegalBundles :: [CertifiedBundle]
certifiedLegalBundles =
  [ certified
  | bundle <- allLegalBundles
  , Just certified <- [certify allSourceFacts bundle]
  ]

identityBundle :: F3 -> F3 -> F3 -> RawBundle
identityBundle ambientMark correctionMark rowValue =
  legalBundle (identity 2) (identity 2) ambientMark correctionMark [[rowValue]]

badRowBundle :: RawBundle
badRowBundle =
  (identityBundle 0 1 0) {sourceRow = [[0, 1]]}

badProjectorBundle :: RawBundle
badProjectorBundle =
  (identityBundle 1 0 1) {sourceProjector = zeroMatrix 2 2}

nonIdempotentBundle :: RawBundle
nonIdempotentBundle =
  (identityBundle 1 0 1)
    { sourceProjector = [[2, 0], [0, 0]]
    , ambientProjector = [[2]]
    }

singularComparisonBundle :: RawBundle
singularComparisonBundle =
  (identityBundle 1 1 1)
    { sourceProjector = zeroMatrix 2 2
    , comparison = zeroMatrix 2 2
    , comparisonInverse = identity 2
    , sourceRow = [[0, 0]]
    }

data AtomBlock = AtomBlock
  { blockRank :: Int
  , nilpotentPartNonzero :: Bool
  , deltaSharpNumerator :: Int
  }

isMarked :: AtomBlock -> Bool
isMarked block =
  blockRank block == 2
    && nilpotentPartNonzero block
    && deltaSharpNumerator block /= 0

cubicBlock :: AtomBlock
cubicBlock = AtomBlock 2 True 4

projectiveBlock :: AtomBlock
projectiveBlock = AtomBlock 1 False 0

projectiveProductBranchCount :: Int -> Integer
projectiveProductBranchCount m = toInteger m + 1

cubicProductVisible :: Int -> Bool
cubicProductVisible m =
  m >= 0 && projectiveProductBranchCount m > 0 && isMarked cubicBlock

projectiveSpaceMarkedEmpty :: Int -> Bool
projectiveSpaceMarkedEmpty m = m >= 0 && not (isMarked projectiveBlock)

pathPreservesDetection :: Int -> CertifiedBundle -> Bool
pathPreservesDetection edgeCount certified =
  edgeCount >= 0 && all id (replicate edgeCount (consumerDetectsIff certified))

data LegalCase = LegalCase Matrix Matrix F3 F3 F3
  deriving (Show)

instance QC.Arbitrary LegalCase where
  arbitrary = do
    (matrix, inverseMatrix) <- QC.elements allInvertibleTwo
    ambientMark <- QC.elements [0, 1]
    correctionMark <- QC.elements [0, 1]
    rowValue <- QC.elements f3Values
    pure (LegalCase matrix inverseMatrix ambientMark correctionMark rowValue)
  shrink _ = []

bundleOfCase :: LegalCase -> RawBundle
bundleOfCase (LegalCase matrix inverseMatrix ambientMark correctionMark rowValue) =
  legalBundle matrix inverseMatrix ambientMark correctionMark [[rowValue]]

quickCheckArguments :: QC.Args
quickCheckArguments =
  QC.stdArgs
    { QC.replay = Just (mkQCGen 925, 0)
    , QC.maxSuccess = 1000
    , QC.chatty = False
    }

runQuickCheck :: QC.Testable property => String -> property -> IO (String, Bool)
runQuickCheck name property = do
  result <- QC.quickCheckWithResult quickCheckArguments property
  pure (name, QC.isSuccess result)

quickChecks :: IO [(String, Bool)]
quickChecks =
  sequence
    [ runQuickCheck
        "quickcheck_lawful_bundle_certifies"
        (\legalCase ->
          case certify allSourceFacts (bundleOfCase legalCase) of
            Just _ -> True
            Nothing -> False)
    , runQuickCheck
        "quickcheck_basis_checks_extend_globally"
        (\legalCase -> fullSquaresHold (bundleOfCase legalCase))
    , runQuickCheck
        "quickcheck_detection_iff"
        (\legalCase ->
          case certify allSourceFacts (bundleOfCase legalCase) of
            Just certified -> consumerDetectsIff certified
            Nothing -> False)
    , runQuickCheck
        "quickcheck_correction_marker_does_not_change_detection"
        (\(LegalCase matrix inverseMatrix ambientMark _ rowValue) ->
          let withoutCorrection =
                legalBundle matrix inverseMatrix ambientMark 0 [[rowValue]]
              withCorrection =
                legalBundle matrix inverseMatrix ambientMark 1 [[rowValue]]
           in sourceDetects withoutCorrection == sourceDetects withCorrection)
    , runQuickCheck
        "quickcheck_endpoints_for_arbitrary_nonnegative_m"
        (\(QC.NonNegative m) ->
          cubicProductVisible m && projectiveSpaceMarkedEmpty m)
    , runQuickCheck
        "quickcheck_arbitrary_finite_path_length"
        (\legalCase (QC.NonNegative edgeCount) ->
          case certify allSourceFacts (bundleOfCase legalCase) of
            Just certified -> pathPreservesDetection (edgeCount `mod` 257) certified
            Nothing -> False)
    ]

checks :: [(String, Bool)]
checks =
  [ ("gl2_f3_has_48_comparisons", length allInvertibleTwo == 48)
  , ("enumerates_576_lawful_raw_bundles", length allLegalBundles == 576)
  , ("all_lawful_bundles_certify", length certifiedLegalBundles == 576)
  , ("basis_squares_extend_to_every_f3_vector", all fullSquaresHold allLegalBundles)
  , ("consumer_detection_iff_holds_exhaustively", all consumerDetectsIff certifiedLegalBundles)
  , ("nonzero_correction_projectors_are_allowed",
      length
        [ ()
        | bundle <- allLegalBundles
        , correctionProjector bundle == [[1]]
        , validateRawBundle bundle
        ]
        == 288)
  , ("source_and_ambient_detect_in_the_same_192_cases",
      length (filter sourceDetects allLegalBundles) == 192
        && length (filter ambientDetects allLegalBundles) == 192)
  , ("larger_row_codomain_is_supported",
      case certify allSourceFacts (legalBundle (identity 2) (identity 2) 1 1 [[1], [2]]) of
        Just certified -> consumerDetectsIff certified
        Nothing -> False)
  , ("bad_row_square_is_rejected",
      isNothing (certify allSourceFacts badRowBundle))
  , ("bad_row_square_can_flip_detection",
      sourceDetects badRowBundle && not (ambientDetects badRowBundle))
  , ("bad_projector_square_is_rejected",
      isNothing (certify allSourceFacts badProjectorBundle))
  , ("bad_projector_square_can_flip_detection",
      not (sourceDetects badProjectorBundle) && ambientDetects badProjectorBundle)
  , ("non_idempotent_marker_is_rejected",
      isNothing (certify allSourceFacts nonIdempotentBundle))
  , ("non_idempotent_failure_is_isolated",
      comparisonIsInvertible nonIdempotentBundle
        && basisSquaresHold nonIdempotentBundle
        && projectorIsIdempotent (correctionProjector nonIdempotentBundle)
        && not (projectorIsIdempotent (sourceProjector nonIdempotentBundle))
        && not (projectorIsIdempotent (ambientProjector nonIdempotentBundle)))
  , ("singular_comparison_is_rejected",
      isNothing (certify allSourceFacts singularComparisonBundle))
  , ("singular_comparison_failure_is_isolated",
      basisSquaresHold singularComparisonBundle
        && projectorIsIdempotent (sourceProjector singularComparisonBundle)
        && projectorIsIdempotent (ambientProjector singularComparisonBundle)
        && projectorIsIdempotent (correctionProjector singularComparisonBundle)
        && not (comparisonIsInvertible singularComparisonBundle))
  , ("cubic_atom_is_marked", isMarked cubicBlock)
  , ("rank_one_projective_atom_is_unmarked", not (isMarked projectiveBlock))
  , ("zero_nilpotent_part_is_unmarked", not (isMarked (AtomBlock 2 False 4)))
  , ("zero_delta_sharp_is_unmarked", not (isMarked (AtomBlock 2 True 0)))
  , ("bounded_all_m_endpoint_regression_0_through_64",
      all (\m -> cubicProductVisible m && projectiveSpaceMarkedEmpty m) [0 .. 64])
  , ("m_1_has_2_source_branches_and_empty_projective_target",
      projectiveProductBranchCount 1 == 2
        && cubicProductVisible 1 && projectiveSpaceMarkedEmpty 1)
  , ("m_3_has_4_source_branches_and_empty_projective_target",
      projectiveProductBranchCount 3 == 4
        && cubicProductVisible 3 && projectiveSpaceMarkedEmpty 3)
  , ("m_4_has_5_source_branches_and_empty_projective_target",
      projectiveProductBranchCount 4 == 5
        && cubicProductVisible 4 && projectiveSpaceMarkedEmpty 4)
  , ("m_13_has_14_source_branches_and_empty_projective_target",
      projectiveProductBranchCount 13 == 14
        && cubicProductVisible 13 && projectiveSpaceMarkedEmpty 13)
  , ("sixteen_edge_boolean_telescope",
      case certifiedLegalBundles of
        certified : _ -> pathPreservesDetection 16 certified
        [] -> False)
  ]
    ++
    [ ("missing_source_fact_rejected_" ++ sourceFactName missing,
        isNothing
          (certify (filter (/= missing) allSourceFacts) (identityBundle 1 1 1)))
    | missing <- allSourceFacts
    ]

renderCheck :: (String, Bool) -> String
renderCheck (name, result) = name ++ ": " ++ if result then "pass" else "FAIL"

main :: IO ()
main = do
  sampledChecks <- quickChecks
  let allChecks = checks ++ sampledChecks
      failures = [name | (name, result) <- allChecks, not result]
  unless (null failures) $ error ("failed checks: " ++ intercalate ", " failures)
  mapM_ (putStrLn . renderCheck) allChecks
  putStrLn
    ("summary: " ++ show (length allChecks)
      ++ " checks; 576 exhaustive lawful bundles; 6000 fixed-seed QuickCheck cases")
