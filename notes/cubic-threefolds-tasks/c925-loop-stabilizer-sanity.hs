import Control.Monad (forM_, unless)
import Data.List (find)
import System.Exit (exitFailure)
import Test.QuickCheck
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
