{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes #-}

module C925CrossedEdgeLensToy
  ( Origin (..)
  , Occurrence (..)
  , Arc (..)
  , Phase (..)
  , Common
  , Moving
  , EdgeOut
  , RelativeEdge
  , Poly
  , poly
  , coefficients
  , addPoly
  , negatePoly
  , subtractPoly
  , multiplyPoly
  , evaluateAtOne
  , derivative
  , orderAtOne
  , nativeCommon
  , nativeValue
  , testMovingOne
  , edgeCrossed
  , edgeMoving
  , runFromMoving
  , mapCommon
  , addProduced
  , compose
  , q
  , hostileEdge
  , firstEdge
  , secondEdge
  ) where

data Origin = Native | FromMoving
data Occurrence = LeftOccurrence | MiddleOccurrence | RightOccurrence
data Arc = DiagonalArc
data Phase = PrimitiveSix

data Common (origin :: Origin) a where
  NativeCommon :: a -> Common 'Native a
  ProducedCommon :: a -> Common 'FromMoving a

newtype Moving a = Moving a

data EdgeOut c m = EdgeOut (Common 'FromMoving c) m

data RelativeEdge
  (source :: Occurrence)
  (target :: Occurrence)
  (arc :: Arc)
  (phase :: Phase)
  c
  m0
  m1 = RelativeEdge
  { commonPart :: forall origin. Common origin c -> Common origin c
  , fromMoving :: m0 -> EdgeOut c m1
  }

newtype Poly = Poly [Integer]
  deriving (Eq)

trim :: [Integer] -> [Integer]
trim values =
  case reverse (dropWhile (== 0) (reverse values)) of
    [] -> [0]
    result -> result

poly :: [Integer] -> Poly
poly = Poly . trim

coefficients :: Poly -> [Integer]
coefficients (Poly values) = values

addPoly :: Poly -> Poly -> Poly
addPoly left right = poly (zipWith (+) (pad left) (pad right))
  where
    size = max (length (coefficients left)) (length (coefficients right))
    pad value = coefficients value ++ replicate (size - length (coefficients value)) 0

negatePoly :: Poly -> Poly
negatePoly value = poly (map negate (coefficients value))

subtractPoly :: Poly -> Poly -> Poly
subtractPoly left right = addPoly left (negatePoly right)

multiplyPoly :: Poly -> Poly -> Poly
multiplyPoly left right =
  poly
    [ sum
        [ a * b
        | (i, a) <- zip [0 ..] (coefficients left)
        , (j, b) <- zip [0 ..] (coefficients right)
        , i + j == degree
        ]
    | degree <- [0 .. length (coefficients left) + length (coefficients right) - 2]
    ]

evaluateAtOne :: Poly -> Integer
evaluateAtOne = sum . coefficients

derivative :: Poly -> Poly
derivative value =
  poly [degree * coefficient | (degree, coefficient) <- zip [1 :: Integer ..] (drop 1 (coefficients value))]

orderAtOne :: Poly -> Maybe Int
orderAtOne value
  | value == poly [0] = Nothing
  | evaluateAtOne value /= 0 = Just 0
  | otherwise = fmap (+ 1) (orderAtOne (derivative value))

nativeCommon :: a -> Common 'Native a
nativeCommon = NativeCommon

nativeValue :: Common 'Native a -> a
nativeValue (NativeCommon value) = value

edgeCrossed :: EdgeOut c m -> c
edgeCrossed (EdgeOut (ProducedCommon value) _) = value

edgeMoving :: EdgeOut c m -> m
edgeMoving (EdgeOut _ value) = value

runFromMoving :: RelativeEdge source target arc phase c m0 m1 -> Moving m0 -> EdgeOut c m1
runFromMoving edge (Moving input) = fromMoving edge input

mapCommon :: (a -> a) -> Common origin a -> Common origin a
mapCommon f (NativeCommon value) = NativeCommon (f value)
mapCommon f (ProducedCommon value) = ProducedCommon (f value)

addProduced :: Num a => Common 'FromMoving a -> Common 'FromMoving a -> Common 'FromMoving a
addProduced (ProducedCommon left) (ProducedCommon right) = ProducedCommon (left + right)

compose
  :: Num c
  => RelativeEdge source middle arc phase c m0 m1
  -> RelativeEdge middle target arc phase c m1 m2
  -> RelativeEdge source target arc phase c m0 m2
compose first second =
  RelativeEdge
    { commonPart = commonPart second . commonPart first
    , fromMoving = \input ->
        case fromMoving first input of
          EdgeOut firstCross middle ->
            case fromMoving second middle of
              EdgeOut secondCross output ->
                EdgeOut
                  (addProduced (commonPart second firstCross) secondCross)
                  output
    }

instance Num Poly where
  (+) = addPoly
  (-) = subtractPoly
  (*) = multiplyPoly
  negate = negatePoly
  abs = error "abs is not used"
  signum = error "signum is not used"
  fromInteger value = poly [value]

q :: Poly
q = poly [0, 1]

testMovingOne :: Moving Poly
testMovingOne = Moving 1

scalarEdge
  :: Poly
  -> Poly
  -> Poly
  -> RelativeEdge source target arc phase Poly Poly Poly
scalarEdge commonScalar crossScalar movingScalar =
  RelativeEdge
    { commonPart = mapCommon (multiplyPoly commonScalar)
    , fromMoving = \moving ->
        EdgeOut
          (ProducedCommon (multiplyPoly crossScalar moving))
          (multiplyPoly movingScalar moving)
    }

hostileEdge
  :: RelativeEdge 'LeftOccurrence 'MiddleOccurrence 'DiagonalArc 'PrimitiveSix Poly Poly Poly
hostileEdge = scalarEdge 1 q 0

firstEdge
  :: RelativeEdge 'LeftOccurrence 'MiddleOccurrence 'DiagonalArc 'PrimitiveSix Poly Poly Poly
firstEdge = scalarEdge 1 q q

secondEdge
  :: RelativeEdge 'MiddleOccurrence 'RightOccurrence 'DiagonalArc 'PrimitiveSix Poly Poly Poly
secondEdge = scalarEdge q 1 q
