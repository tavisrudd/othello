{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- Computational sanity checks for the final C925 source/consumer pipeline.
--
-- This executable mirrors the algebraic interface proved in
-- RowedProjectorDecomposition.lean.  It does not prove any Gu--Yu--Yu,
-- Iritani, or KKPYY source theorem.  Instead, it checks a finite model of the
-- interface exhaustively.  The direct edge route, native-occurrence descent,
-- and four optional adapters
-- have separate fact gates, so alternatives are not accumulated into one
-- artificially strong source interface.

module Main (main) where

import Control.Monad (unless)
import Data.List (intercalate, transpose)
import Data.Maybe (isJust, isNothing)
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

data F9 = F9 F3 F3
  deriving (Eq)

instance Show F9 where
  show (F9 scalar alpha) = "(" ++ show scalar ++ "+" ++ show alpha ++ "a)"

instance Num F9 where
  F9 a b + F9 c d = F9 (a + c) (b + d)
  F9 a b * F9 c d = F9 (a * c + 2 * b * d) (a * d + b * c)
  negate (F9 a b) = F9 (negate a) (negate b)
  abs = id
  signum value = if value == 0 then 0 else 1
  fromInteger value = F9 (fromInteger value) 0

embedF3 :: F3 -> F9
embedF3 value = F9 value 0

allF9Values :: [F9]
allF9Values = [F9 scalar alpha | scalar <- f3Values, alpha <- f3Values]

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

matrixAdd :: Matrix -> Matrix -> Matrix
matrixAdd = zipWith (zipWith (+))

matrixScale :: F3 -> Matrix -> Matrix
matrixScale scalar = map (map (scalar *))

matrixPower :: Matrix -> Int -> Matrix
matrixPower matrix powerIndex =
  foldr (\_ accumulator -> matrixMultiply matrix accumulator)
    (identity (length matrix)) [1 .. powerIndex]

kronecker :: Matrix -> Matrix -> Matrix
kronecker left right =
  concatMap
    (\leftRow ->
      [concatMap (\entry -> map (entry *) rightRow) leftRow | rightRow <- right])
    left

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

allF9Vectors :: Int -> [[F9]]
allF9Vectors 0 = [[]]
allF9Vectors dimension =
  [entry : rest | entry <- allF9Values, rest <- allF9Vectors (dimension - 1)]

matrixVectorF9 :: [[F9]] -> [F9] -> [F9]
matrixVectorF9 matrix vector =
  [sum (zipWith (*) row vector) | row <- matrix]

liftMatrixF9 :: Matrix -> [[F9]]
liftMatrixF9 = map (map embedF3)

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

scaledRowSquareAt :: F3 -> RawBundle -> Vector -> Bool
scaledRowSquareAt scale bundle vector =
  matrixVector (sourceRow bundle) vector
    == map (scale *)
      (matrixVector
        (ambientRow bundle)
        [firstCoordinate (matrixVector (comparison bundle) vector)])

validateUnitScaledBundle :: F3 -> RawBundle -> Bool
validateUnitScaledBundle scale bundle =
  scale /= 0
    && comparisonIsInvertible bundle
    && projectorIsIdempotent (sourceProjector bundle)
    && projectorIsIdempotent (ambientProjector bundle)
    && projectorIsIdempotent (correctionProjector bundle)
    && all (scaledRowSquareAt scale bundle) (standardBasis 2)
    && all (projectorSquareAt bundle) (standardBasis 2)

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

detectsF9 :: Int -> Matrix -> Matrix -> Bool
detectsF9 dimension projector row =
  any
    (\vector ->
      matrixVectorF9 (liftMatrixF9 projector) vector == vector
        && any (/= 0) (matrixVectorF9 (liftMatrixF9 row) vector))
    (allF9Vectors dimension)

sourceDetectsF9 :: RawBundle -> Bool
sourceDetectsF9 bundle =
  detectsF9 2 (sourceProjector bundle) (sourceRow bundle)

ambientDetectsF9 :: RawBundle -> Bool
ambientDetectsF9 bundle =
  detectsF9 1 (ambientProjector bundle) (ambientRow bundle)

data SourceFact
  = OrdinaryEquivariantBasis
  | ShiftPreservesOrdinarySource
  | FundamentalSolutionAdjointSquare
  | CompletedComparisonIsomorphism
  | ConnectionNaturality
  | CanonicalMarkedSpectralUnion
  | UniformSmoothCenterCoverage
  | NativeOccurrenceDescent
  | NativeFaithfulScalarPresentation
  | CubicProductEndpointIdentification
  | ProjectiveSpaceEndpointIdentification
  | FaithfulCommonBase
  | PolynomialMarkerPresentation
  | UnitRowNormalization
  | TensorEndpointUnit
  deriving (Eq, Enum, Bounded, Show)

allSourceFacts :: [SourceFact]
allSourceFacts = [minBound .. maxBound]

edgeSourceFacts :: [SourceFact]
edgeSourceFacts =
  [ OrdinaryEquivariantBasis
  , ShiftPreservesOrdinarySource
  , FundamentalSolutionAdjointSquare
  , CompletedComparisonIsomorphism
  , ConnectionNaturality
  , CanonicalMarkedSpectralUnion
  , UniformSmoothCenterCoverage
  ]

directEdgeFacts :: [SourceFact]
directEdgeFacts =
  edgeSourceFacts ++
  [ NativeOccurrenceDescent
  ]

intrinsicEdgeFacts :: [SourceFact]
intrinsicEdgeFacts =
  edgeSourceFacts ++
  [ NativeFaithfulScalarPresentation
  ]

allMEndpointFacts :: [SourceFact]
allMEndpointFacts =
  [ CubicProductEndpointIdentification
  , ProjectiveSpaceEndpointIdentification
  ]

newtype CertifiedBundle = CertifiedBundle RawBundle

certifyDirectEdge :: [SourceFact] -> RawBundle -> Maybe CertifiedBundle
certifyDirectEdge supplied bundle
  | all (`elem` supplied) directEdgeFacts && validateRawBundle bundle =
      Just (CertifiedBundle bundle)
  | otherwise = Nothing

certifyIntrinsicEdge :: [SourceFact] -> RawBundle -> Maybe CertifiedBundle
certifyIntrinsicEdge supplied bundle
  | all (`elem` supplied) intrinsicEdgeFacts && validateRawBundle bundle =
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
sourceFactName UniformSmoothCenterCoverage = "uniform_smooth_center_coverage"
sourceFactName NativeOccurrenceDescent = "native_vertex_occurrence_descent"
sourceFactName NativeFaithfulScalarPresentation = "native_faithful_scalar_presentation"
sourceFactName CubicProductEndpointIdentification = "cubic_product_endpoint_identification"
sourceFactName ProjectiveSpaceEndpointIdentification = "projective_space_endpoint_identification"
sourceFactName FaithfulCommonBase = "faithful_common_scalar_base"
sourceFactName PolynomialMarkerPresentation = "polynomial_marker_presentation"
sourceFactName UnitRowNormalization = "unit_row_normalization"
sourceFactName TensorEndpointUnit = "tensor_endpoint_unit"

allLegalBundles :: [RawBundle]
allLegalBundles =
  [ legalBundle matrix inverseMatrix ambientMark correctionMark [[rowValue]]
  | (matrix, inverseMatrix) <- allInvertibleTwo
  , ambientMark <- [0, 1]
  , correctionMark <- [0, 1]
  , rowValue <- f3Values
  ]

allUnitScaledBundles :: [(F3, RawBundle)]
allUnitScaledBundles =
  [ (scale, bundle {sourceRow = matrixScale scale (sourceRow bundle)})
  | bundle <- allLegalBundles
  , scale <- [1, 2]
  ]

allMatricesTwo :: [Matrix]
allMatricesTwo =
  [ [[a, b], [c, d]]
  | a <- f3Values
  , b <- f3Values
  , c <- f3Values
  , d <- f3Values
  ]

allQuadraticCoefficientLists :: [[F3]]
allQuadraticCoefficientLists =
  [[a, b, c] | a <- f3Values, b <- f3Values, c <- f3Values]

evaluatePolynomial :: [F3] -> Matrix -> Matrix
evaluatePolynomial coefficients operator =
  foldr matrixAdd (zeroMatrix 2 2)
    [matrixScale coefficient (matrixPower operator powerIndex)
    | (powerIndex, coefficient) <- zip [0 ..] coefficients]

polynomialTransportHolds :: Matrix -> Matrix -> Matrix -> [F3] -> Bool
polynomialTransportHolds matrix inverseMatrix sourceOperator coefficients =
  let targetOperator =
        matrixMultiply matrix (matrixMultiply sourceOperator inverseMatrix)
   in matrixMultiply matrix (evaluatePolynomial coefficients sourceOperator)
        == matrixMultiply (evaluatePolynomial coefficients targetOperator) matrix

allPolynomialTransportCases :: [Bool]
allPolynomialTransportCases =
  [ polynomialTransportHolds matrix inverseMatrix operator coefficients
  | (matrix, inverseMatrix) <- allInvertibleTwo
  , operator <- allMatricesTwo
  , coefficients <- allQuadraticCoefficientLists
  ]

commonSourceCertificateHolds
  :: Matrix -> Matrix -> Matrix -> Matrix
  -> F3 -> F3 -> Matrix -> F3 -> Bool
commonSourceCertificateHolds
    sourcePresentation sourcePresentationInverse
    targetPresentation targetPresentationInverse
    ambientMark correctionMark row scale =
  let block = blockProjector ambientMark correctionMark
      commonProjector =
        matrixMultiply targetPresentationInverse
          (matrixMultiply block targetPresentation)
      endpointProjector =
        matrixMultiply sourcePresentation
          (matrixMultiply commonProjector sourcePresentationInverse)
      endpointComparison =
        matrixMultiply targetPresentation sourcePresentationInverse
      endpointComparisonInverse =
        matrixMultiply sourcePresentation targetPresentationInverse
      liftedRow = liftAmbientRow row
      endpointRow =
        matrixScale scale (matrixMultiply liftedRow endpointComparison)
      bundle = RawBundle
        { sourceProjector = endpointProjector
        , ambientProjector = [[ambientMark]]
        , correctionProjector = [[correctionMark]]
        , comparison = endpointComparison
        , comparisonInverse = endpointComparisonInverse
        , sourceRow = endpointRow
        , ambientRow = row
        }
   in projectorIsIdempotent commonProjector
        && matrixMultiply sourcePresentation commonProjector
          == matrixMultiply endpointProjector sourcePresentation
        && matrixMultiply targetPresentation commonProjector
          == matrixMultiply block targetPresentation
        && matrixMultiply endpointRow sourcePresentation
          == matrixScale scale (matrixMultiply liftedRow targetPresentation)
        && validateUnitScaledBundle scale bundle
        && sourceDetects bundle == ambientDetects bundle

allCommonSourceCertificateCases :: [Bool]
allCommonSourceCertificateCases =
  [ commonSourceCertificateHolds
      sourcePresentation sourcePresentationInverse
      targetPresentation targetPresentationInverse
      ambientMark correctionMark [[rowValue]] scale
  | (sourcePresentation, sourcePresentationInverse) <- allInvertibleTwo
  , (targetPresentation, targetPresentationInverse) <- allInvertibleTwo
  , ambientMark <- [0, 1]
  , correctionMark <- [0, 1]
  , rowValue <- f3Values
  , scale <- [1, 2]
  ]

tensorEndpointDetectionAgrees :: RawBundle -> Bool
tensorEndpointDetectionAgrees bundle =
  let auxiliaryRow = [[1, 2]]
      tensorProjector = kronecker (sourceProjector bundle) (identity 2)
      tensorProductRow = kronecker (sourceRow bundle) auxiliaryRow
   in sourceDetects bundle == detects 4 tensorProjector tensorProductRow

polynomialRouteChecks :: [SourceFact] -> Bool
polynomialRouteChecks supplied =
  PolynomialMarkerPresentation `elem` supplied
    && and allPolynomialTransportCases

faithfulBaseRouteChecks :: [SourceFact] -> Bool
faithfulBaseRouteChecks supplied =
  FaithfulCommonBase `elem` supplied
    && all (\bundle -> sourceDetectsF9 bundle == sourceDetects bundle)
      allLegalBundles

unitScaledRouteChecks :: [SourceFact] -> Bool
unitScaledRouteChecks supplied =
  UnitRowNormalization `elem` supplied
    && all
      (\(scale, bundle) ->
        validateUnitScaledBundle scale bundle
          && sourceDetects bundle == ambientDetects bundle)
      allUnitScaledBundles

tensorEndpointRouteChecks :: [SourceFact] -> Bool
tensorEndpointRouteChecks supplied =
  TensorEndpointUnit `elem` supplied
    && all tensorEndpointDetectionAgrees allLegalBundles

certifiedLegalBundles :: [CertifiedBundle]
certifiedLegalBundles =
  [ certified
  | bundle <- allLegalBundles
  , Just certified <- [certifyDirectEdge directEdgeFacts bundle]
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

nonunitScaledBundle :: RawBundle
nonunitScaledBundle =
  (identityBundle 1 0 1) {sourceRow = [[0, 0]]}

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

allMEndpointsCertified :: [SourceFact] -> Int -> Bool
allMEndpointsCertified supplied m =
  all (`elem` supplied) allMEndpointFacts
    && cubicProductVisible m
    && projectiveSpaceMarkedEmpty m

data VertexDatum = VertexDatum
  { vertexName :: Int
  , vertexDetects :: Bool
  }
  deriving (Eq, Show)

data EdgeDirection = Forward | Reverse
  deriving (Eq, Show)

data TypedEdge = TypedEdge EdgeDirection VertexDatum VertexDatum CertifiedBundle

edgeMatchesVertices :: TypedEdge -> Bool
edgeMatchesVertices (TypedEdge direction source target certified@(CertifiedBundle bundle)) =
  let endpointsMatch =
        case direction of
          Forward ->
            sourceDetects bundle == vertexDetects source
              && ambientDetects bundle == vertexDetects target
          Reverse ->
            ambientDetects bundle == vertexDetects source
              && sourceDetects bundle == vertexDetects target
   in endpointsMatch && consumerDetectsIff certified

adjacentVerticesMatch :: TypedEdge -> TypedEdge -> Bool
adjacentVerticesMatch (TypedEdge _ _ target _) (TypedEdge _ source _ _) =
  target == source

nominalAdjacentVerticesMatch :: TypedEdge -> TypedEdge -> Bool
nominalAdjacentVerticesMatch (TypedEdge _ _ target _) (TypedEdge _ source _ _) =
  vertexName target == vertexName source

typedPathPreservesDetection :: [TypedEdge] -> Bool
typedPathPreservesDetection edges =
  all edgeMatchesVertices edges
    && and (zipWith adjacentVerticesMatch edges (drop 1 edges))
    && case edges of
      [] -> True
      TypedEdge _ source _ _ : _ ->
        let TypedEdge _ _ target _ = last edges
         in vertexDetects source == vertexDetects target

pathPreservesDetection :: Int -> CertifiedBundle -> Bool
pathPreservesDetection edgeCount certified@(CertifiedBundle bundle) =
  let detection = sourceDetects bundle
      vertices = [VertexDatum index detection | index <- [0 .. edgeCount]]
      edges =
        zipWith
          (\source target -> TypedEdge Forward source target certified)
          vertices (drop 1 vertices)
   in edgeCount >= 0 && typedPathPreservesDetection edges

forwardThenReversePreservesDetection :: CertifiedBundle -> Bool
forwardThenReversePreservesDetection certified@(CertifiedBundle bundle) =
  let detection = sourceDetects bundle
      source = VertexDatum 0 detection
      target = VertexDatum 1 detection
   in typedPathPreservesDetection
        [ TypedEdge Forward source target certified
        , TypedEdge Reverse target source certified
        ]

hostileNominalPath :: Maybe [TypedEdge]
hostileNominalPath = do
  detected <- certifyDirectEdge directEdgeFacts (identityBundle 1 0 1)
  undetected <- certifyDirectEdge directEdgeFacts (identityBundle 1 0 0)
  pure
    [ TypedEdge Forward (VertexDatum 0 True) (VertexDatum 1 True) detected
    , TypedEdge Forward (VertexDatum 1 False) (VertexDatum 2 False) undetected
    ]

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
          case certifyDirectEdge directEdgeFacts (bundleOfCase legalCase) of
            Just _ -> True
            Nothing -> False)
    , runQuickCheck
        "quickcheck_basis_checks_extend_globally"
        (\legalCase -> fullSquaresHold (bundleOfCase legalCase))
    , runQuickCheck
        "quickcheck_detection_iff"
        (\legalCase ->
          case certifyDirectEdge directEdgeFacts (bundleOfCase legalCase) of
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
        "quickcheck_unit_scaled_detection_iff"
        (\legalCase@(LegalCase _ _ _ correctionMark _) ->
          let bundle = bundleOfCase legalCase
              scale = if correctionMark == 0 then 1 else 2
              scaled = bundle {sourceRow = matrixScale scale (sourceRow bundle)}
           in validateUnitScaledBundle scale scaled
                && sourceDetects scaled == ambientDetects scaled)
    , runQuickCheck
        "quickcheck_polynomial_transport"
        (\legalCase@(LegalCase matrix inverseMatrix ambientMark correctionMark rowValue) ->
          polynomialTransportHolds matrix inverseMatrix
            (sourceProjector (bundleOfCase legalCase))
            [ambientMark, correctionMark, rowValue])
    , runQuickCheck
        "quickcheck_common_source_composition"
        (\(LegalCase sourcePresentation sourceInverse ambientMark correctionMark rowValue)
          (LegalCase targetPresentation targetInverse _ _ scaleSeed) ->
          let scale = if scaleSeed == 0 then 1 else scaleSeed
           in commonSourceCertificateHolds
                sourcePresentation sourceInverse targetPresentation targetInverse
                ambientMark correctionMark [[rowValue]] scale)
    , runQuickCheck
        "quickcheck_endpoints_for_arbitrary_nonnegative_m"
        (\(QC.NonNegative m) ->
          allMEndpointsCertified allSourceFacts m)
    , runQuickCheck
        "quickcheck_arbitrary_finite_path_length"
        (\legalCase (QC.NonNegative edgeCount) ->
          case certifyDirectEdge directEdgeFacts (bundleOfCase legalCase) of
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
      case certifyDirectEdge directEdgeFacts
        (legalBundle (identity 2) (identity 2) 1 1 [[1], [2]]) of
        Just certified -> consumerDetectsIff certified
        Nothing -> False)
  , ("enumerates_1152_unit_scaled_bundles",
      length allUnitScaledBundles == 1152)
  , ("unit_scaled_detection_iff_holds_exhaustively",
      all
        (\(scale, bundle) ->
          validateUnitScaledBundle scale bundle
            && sourceDetects bundle == ambientDetects bundle)
        allUnitScaledBundles)
  , ("nonunit_row_scale_is_rejected",
      not (validateUnitScaledBundle 0 nonunitScaledBundle))
  , ("nonunit_row_scale_can_flip_detection",
      not (sourceDetects nonunitScaledBundle)
        && ambientDetects nonunitScaledBundle)
  , ("faithful_f3_to_f9_extension_reflects_source_detection",
      all (\bundle -> sourceDetectsF9 bundle == sourceDetects bundle)
        allLegalBundles)
  , ("faithful_f3_to_f9_extension_reflects_ambient_detection",
      all (\bundle -> ambientDetectsF9 bundle == ambientDetects bundle)
        allLegalBundles)
  , ("polynomial_transport_holds_in_104976_cases",
      length allPolynomialTransportCases == 104976
        && and allPolynomialTransportCases)
  , ("common_source_certificate_holds_in_55296_cases",
      length allCommonSourceCertificateCases == 55296
        && and allCommonSourceCertificateCases)
  , ("tensor_endpoint_detection_agrees_in_all_576_cases",
      all tensorEndpointDetectionAgrees allLegalBundles)
  , ("bad_row_square_is_rejected",
      isNothing (certifyDirectEdge directEdgeFacts badRowBundle))
  , ("bad_row_square_can_flip_detection",
      sourceDetects badRowBundle && not (ambientDetects badRowBundle))
  , ("bad_projector_square_is_rejected",
      isNothing (certifyDirectEdge directEdgeFacts badProjectorBundle))
  , ("bad_projector_square_can_flip_detection",
      not (sourceDetects badProjectorBundle) && ambientDetects badProjectorBundle)
  , ("non_idempotent_marker_is_rejected",
      isNothing (certifyDirectEdge directEdgeFacts nonIdempotentBundle))
  , ("non_idempotent_failure_is_isolated",
      comparisonIsInvertible nonIdempotentBundle
        && basisSquaresHold nonIdempotentBundle
        && projectorIsIdempotent (correctionProjector nonIdempotentBundle)
        && not (projectorIsIdempotent (sourceProjector nonIdempotentBundle))
        && not (projectorIsIdempotent (ambientProjector nonIdempotentBundle)))
  , ("singular_comparison_is_rejected",
      isNothing (certifyDirectEdge directEdgeFacts singularComparisonBundle))
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
  , ("typed_path_accepts_forward_then_reverse_traversal",
      case certifiedLegalBundles of
        certified : _ -> forwardThenReversePreservesDetection certified
        [] -> False)
  , ("name_only_path_accepts_hostile_occurrence_mismatch",
      case hostileNominalPath of
        Just [left, right] ->
          edgeMatchesVertices left
            && edgeMatchesVertices right
            && nominalAdjacentVerticesMatch left right
        _ -> False)
  , ("typed_path_rejects_hostile_occurrence_mismatch",
      case hostileNominalPath of
        Just edges -> not (typedPathPreservesDetection edges)
        Nothing -> False)
  ]
    ++
    [ ("missing_direct_edge_fact_rejected_" ++ sourceFactName missing,
        isNothing
          (certifyDirectEdge (filter (/= missing) directEdgeFacts)
            (identityBundle 1 1 1)))
    | missing <- directEdgeFacts
    ]
    ++
    [ ("intrinsic_path_route_accepts_without_native_occurrence_equivalence",
        NativeOccurrenceDescent `notElem` intrinsicEdgeFacts
          && isJust
            (certifyIntrinsicEdge intrinsicEdgeFacts (identityBundle 1 1 1)))
    , ("typed_occurrence_route_does_not_require_faithful_scalar_presentation",
        NativeFaithfulScalarPresentation `notElem` directEdgeFacts
          && isJust
            (certifyDirectEdge directEdgeFacts (identityBundle 1 1 1)))
    , ("missing_native_faithful_scalar_presentation_rejected",
        isNothing
          (certifyIntrinsicEdge
            (filter (/= NativeFaithfulScalarPresentation) intrinsicEdgeFacts)
            (identityBundle 1 1 1)))
    ]
    ++
    [ ("missing_all_m_endpoint_fact_rejected_" ++ sourceFactName missing,
        not
          (allMEndpointsCertified
            (filter (/= missing) allSourceFacts) 2))
    | missing <- allMEndpointFacts
    ]
    ++
    [ ("polynomial_route_requires_polynomial_marker_presentation",
        not (polynomialRouteChecks
          (filter (/= PolynomialMarkerPresentation) allSourceFacts)))
    , ("faithful_base_route_requires_faithful_common_scalar_base",
        not (faithfulBaseRouteChecks
          (filter (/= FaithfulCommonBase) allSourceFacts)))
    , ("unit_scaled_route_requires_unit_row_normalization",
        not (unitScaledRouteChecks
          (filter (/= UnitRowNormalization) allSourceFacts)))
    , ("tensor_endpoint_route_requires_tensor_endpoint_unit",
        not (tensorEndpointRouteChecks
          (filter (/= TensorEndpointUnit) allSourceFacts)))
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
      ++ " checks; 576 exact bundles; 1152 unit-scaled bundles; "
      ++ "104976 polynomial cases; 55296 common-source cases; "
      ++ "9000 fixed-seed QuickCheck cases")
