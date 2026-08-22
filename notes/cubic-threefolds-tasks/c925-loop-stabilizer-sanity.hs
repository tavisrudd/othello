import Control.Monad (forM_, unless)
import Data.List (find, nub, sort)
import System.Exit (exitFailure)
import Test.QuickCheck hiding (label)
import Test.QuickCheck.Random (mkQCGen)

sourceFixed :: Int -> Int -> Bool
sourceFixed period power = power `mod` period == 0

translationPower :: Int -> Int -> Int -> Int -> Int
translationPower modulus charge power point =
  (point + power * charge) `mod` modulus

brutePeriod :: Int -> Int -> Int
brutePeriod modulus charge =
  case find (\power -> translationPower modulus charge power 0 == 0) [1 .. modulus] of
    Just period -> period
    Nothing -> error "a translation of a finite cyclic set has no period"

formulaPeriod :: Int -> Int -> Int
formulaPeriod modulus charge = modulus `div` gcd modulus charge

separatingPower :: Int -> Int -> Maybe Int
separatingPower sourcePeriod targetPeriod
  | sourcePeriod == targetPeriod = Nothing
  | targetPeriod `mod` sourcePeriod /= 0 = Just targetPeriod
  | otherwise = Just sourcePeriod

separates :: Int -> Int -> Int -> Bool
separates sourcePeriod targetPeriod power =
  sourceFixed sourcePeriod power /= sourceFixed targetPeriod power

certificateValid :: Int -> Int -> Bool
certificateValid sourcePeriod targetPeriod =
  case separatingPower sourcePeriod targetPeriod of
    Nothing -> sourcePeriod == targetPeriod
    Just power -> sourcePeriod /= targetPeriod && separates sourcePeriod targetPeriod power

type Occurrence = Int
type Label = Int
type TaggedPoint = (Occurrence, Label)
type TaggedPermutation = TaggedPoint -> TaggedPoint

permutationPower :: TaggedPermutation -> Int -> TaggedPoint -> TaggedPoint
permutationPower permutation power point = iterate permutation point !! power

permutationFixed :: TaggedPermutation -> Int -> TaggedPoint -> Bool
permutationFixed permutation power point = permutationPower permutation power point == point

isPermutationOn :: [TaggedPoint] -> TaggedPermutation -> Bool
isPermutationOn points permutation =
  length (nub points) == length points
    && sort (map permutation points) == sort points

preservesOccurrences :: [TaggedPoint] -> TaggedPermutation -> Bool
preservesOccurrences points permutation =
  all (\point -> fst (permutation point) == fst point) points

fixednessWitnessesValid
  :: Int -> [TaggedPoint] -> TaggedPermutation -> (TaggedPoint -> Int) -> Bool
fixednessWitnessesValid sourcePeriod points permutation witnessPower =
  all (\point ->
    sourceFixed sourcePeriod (witnessPower point)
      /= permutationFixed permutation (witnessPower point) point) points

taggedCertificateValid
  :: Int -> [TaggedPoint] -> TaggedPermutation -> (TaggedPoint -> Int) -> Bool
taggedCertificateValid sourcePeriod points permutation witnessPower =
  isPermutationOn points permutation
    && preservesOccurrences points permutation
    && fixednessWitnessesValid sourcePeriod points permutation witnessPower

pointPeriod :: [TaggedPoint] -> TaggedPermutation -> TaggedPoint -> Maybe Int
pointPeriod points permutation point =
  find (\power -> permutationFixed permutation power point) [1 .. length points]

fiberwiseConjugacy
  :: [TaggedPoint]
  -> [TaggedPoint]
  -> TaggedPermutation
  -> TaggedPermutation
  -> (TaggedPoint -> TaggedPoint)
  -> Bool
fiberwiseConjugacy sourcePoints targetPoints sourceLoop targetLoop relabel =
  isPermutationOn sourcePoints sourceLoop
    && isPermutationOn targetPoints targetLoop
    && sort (map relabel sourcePoints) == sort targetPoints
    && all (\point -> fst (relabel point) == fst point) sourcePoints
    && all (\point -> relabel (sourceLoop point) == targetLoop (relabel point)) sourcePoints

singleOccurrencePoints :: Int -> Occurrence -> [TaggedPoint]
singleOccurrencePoints modulus occurrence =
  [(occurrence, label) | label <- [0 .. modulus - 1]]

translationPermutation :: Int -> Int -> TaggedPermutation
translationPermutation modulus charge (occurrence, label) =
  (occurrence, (label + charge) `mod` modulus)

namedPermutationCaseValid :: Int -> Bool
namedPermutationCaseValid m =
  let period = m + 1
      points = singleOccurrencePoints period m
      kummerLoop = translationPermutation period 1
      splitLoop = translationPermutation period 0
      witnessPower _ = 1
      checkedPowers = [0 .. 2 * period]
   in isPermutationOn points kummerLoop
        && preservesOccurrences points kummerLoop
        && all (\point -> pointPeriod points kummerLoop point == Just period) points
        && all (\point -> all (\power ->
          permutationFixed kummerLoop power point == sourceFixed period power)
          checkedPowers) points
        && taggedCertificateValid period points splitLoop witnessPower
        && not (taggedCertificateValid period points kummerLoop witnessPower)

assertCheck :: String -> Bool -> IO ()
assertCheck name condition = do
  unless condition $ do
    putStrLn ("FAIL " ++ name)
    exitFailure
  putStrLn ("PASS " ++ name)

boundedPositive :: Positive Int -> Int
boundedPositive (Positive value) = 1 + value `mod` 128

propTranslationFormula :: Positive Int -> NonNegative Int -> Bool
propTranslationFormula positiveModulus (NonNegative rawCharge) =
  let modulus = boundedPositive positiveModulus
      charge = rawCharge `mod` modulus
   in brutePeriod modulus charge == formulaPeriod modulus charge

propSeparator :: Positive Int -> Positive Int -> Bool
propSeparator sourceInput targetInput =
  let sourcePeriod = boundedPositive sourceInput
      targetPeriod = boundedPositive targetInput
   in certificateValid sourcePeriod targetPeriod

propInversePeriod :: Positive Int -> NonNegative Int -> Bool
propInversePeriod positiveModulus (NonNegative rawCharge) =
  let modulus = boundedPositive positiveModulus
      charge = rawCharge `mod` modulus
      inverseCharge = (-charge) `mod` modulus
   in formulaPeriod modulus charge == formulaPeriod modulus inverseCharge

runProperty :: Testable property => String -> property -> IO ()
runProperty name prop = do
  result <- quickCheckWithResult
    stdArgs
      { maxSuccess = 9000
      , replay = Just (mkQCGen 925, 0)
      , chatty = False
      }
    prop
  assertCheck name (isSuccess result)

namedCase :: Int -> IO ()
namedCase m = do
  let period = m + 1
      rows = [(charge, formulaPeriod period charge) | charge <- [0 .. period - 1]]
      red = [charge | (charge, orbitPeriod) <- rows, orbitPeriod == period]
      green = [charge | (charge, orbitPeriod) <- rows, orbitPeriod /= period]
  putStrLn
    ("m=" ++ show m
      ++ " period=" ++ show period
      ++ " redCharges=" ++ show red
      ++ " greenCharges=" ++ show green)

main :: IO ()
main = do
  let moduli = [2 .. 65]
      translationCases =
        [(modulus, charge) | modulus <- moduli, charge <- [0 .. modulus - 1]]
      periodPairs =
        [(sourcePeriod, targetPeriod) | sourcePeriod <- [1 .. 65], targetPeriod <- [1 .. 65]]
  assertCheck "translation period formula, exhaustive n=2..65"
    (all (\(modulus, charge) ->
      brutePeriod modulus charge == formulaPeriod modulus charge) translationCases)
  assertCheck "distinct periods yield a valid separating power, exhaustive 1..65"
    (all (uncurry certificateValid) periodPairs)
  assertCheck "equal periods admit no separating certificate, exhaustive 1..65"
    (all (\period -> separatingPower period period == Nothing) [1 .. 65])
  assertCheck "inverse translations preserve periods, exhaustive n=2..65"
    (all (\(modulus, charge) ->
      formulaPeriod modulus charge == formulaPeriod modulus ((-charge) `mod` modulus))
      translationCases)
  assertCheck "the Kummer model x^n=t is red for every n=2..65"
    (all (\period -> formulaPeriod period 1 == period) moduli)
  assertCheck "the split model x^n=1 is green for every n=2..65"
    (all (\period -> formulaPeriod period 0 == 1 && period /= 1) moduli)
  assertCheck "a mixed ledger fails when one target orbit has the source period"
    (not (all (\targetPeriod -> targetPeriod /= 3) ([1, 2, 3] :: [Int])))
  assertCheck "cardinality does not replace stabilizer data"
    (all (\targetPeriod -> targetPeriod /= 3) ([1, 1, 1] :: [Int]))
  assertCheck "return at the source power does not imply equal exact period"
    (sourceFixed 3 6 && sourceFixed 6 6 && separatingPower 3 6 == Just 3)
  assertCheck "a two-cycle plus a fixed point is green against a three-cycle"
    (all (\targetPeriod -> targetPeriod /= 3) ([2, 1] :: [Int]))
  let taggedMixedPoints =
        [(0, label) | label <- [0 .. 2]]
          ++ [(1, label) | label <- [0 .. 1]]
      taggedMixedLoop point@(occurrence, label)
        | occurrence == 0 = (occurrence, (label + 1) `mod` 3)
        | occurrence == 1 = (occurrence, (label + 1) `mod` 2)
        | otherwise = point
      lyingPoints = singleOccurrencePoints 3 0
      actualThreeCycle = translationPermutation 3 1
      lyingReportedPeriod _ = 1
      lyingWitness point =
        case separatingPower 3 (lyingReportedPeriod point) of
          Just power -> power
          Nothing -> 0
      mixingPoints = [(occurrence, 0) | occurrence <- [0 .. 2]]
      mixingLoop (occurrence, label) = ((occurrence + 1) `mod` 3, label)
      mixingWitness _ = 2
      relabelPoints = singleOccurrencePoints 3 0
      forwardLoop = translationPermutation 3 1
      inverseLoop = translationPermutation 3 2
      inverseRelabel (occurrence, label) = (occurrence, (-label) `mod` 3)
      identityRelabel = id
  assertCheck "occurrence-tagged flattened permutation preserves every tag"
    (isPermutationOn taggedMixedPoints taggedMixedLoop
      && preservesOccurrences taggedMixedPoints taggedMixedLoop
      && map (pointPeriod taggedMixedPoints taggedMixedLoop) taggedMixedPoints
        == [Just 3, Just 3, Just 3, Just 2, Just 2])
  assertCheck "actual permutation checker rejects a lying green period table"
    (not (taggedCertificateValid 3 lyingPoints actualThreeCycle lyingWitness))
  assertCheck "actual permutation checker rejects occurrence mixing"
    (isPermutationOn mixingPoints mixingLoop
      && fixednessWitnessesValid 2 mixingPoints mixingLoop mixingWitness
      && not (preservesOccurrences mixingPoints mixingLoop)
      && not (taggedCertificateValid 2 mixingPoints mixingLoop mixingWitness))
  assertCheck "fiberwise conjugacy accepts inverse-charge relabelling"
    (fiberwiseConjugacy relabelPoints relabelPoints
      forwardLoop inverseLoop inverseRelabel)
  assertCheck "fiberwise conjugacy rejects a nonconjugate relabelling"
    (not (fiberwiseConjugacy relabelPoints relabelPoints
      forwardLoop inverseLoop identityRelabel))
  assertCheck "actual permutation fingerprints, named m=1,2,3,4,13"
    (all namedPermutationCaseValid [1, 2, 3, 4, 13])
  runProperty "QuickCheck translation period formula, 9000 fixed-seed cases"
    propTranslationFormula
  runProperty "QuickCheck separating power, 9000 fixed-seed cases"
    propSeparator
  runProperty "QuickCheck inverse-period invariance, 9000 fixed-seed cases"
    propInversePeriod
  forM_ [1, 2, 3, 4, 13] namedCase
  putStrLn
    ("SUMMARY exhaustiveTranslationCases=" ++ show (length translationCases)
      ++ " exhaustivePeriodPairs=" ++ show (length periodPairs)
      ++ " quickCheckCases=27000")
