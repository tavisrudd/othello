import RelativeConicArcs.NinePointHeisenbergIncidence
import Mathlib.Data.List.Sublists

/-!
# Five-subset conics of a nine-point Heisenberg orbit

This module defines the conic through each of the 126 five-subsets of the explicit uncovered
nine-arc in `PG(2, 19)`.  For five evaluation rows, the six signed `5 × 5` minors give a nonzero
quadratic coefficient vector; the vector is normalized by its first nonzero coefficient.  The
module then defines duplicate removal, nonsingularity, orbit intersections, internal/external
point types, the nine six-point conics, and their tangent incidences.  The finite propositions are
split among the count, profile, orbit, and three secant-interpretation modules so each kernel
reduction has a bounded elaboration environment.

For efficient profile evaluation, an off-conic point is classified by the standard discriminant
square test.  `NinePointHeisenbergConicTypeLow`, `NinePointHeisenbergConicTypeMiddle`, and
`NinePointHeisenbergConicTypeHigh` check on all 81 conics and all selected points that this test
agrees with the projective incidence convention: ten conic secants for an internal point and nine
for an external point.  No externally generated list of conics or profile table is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicCensus

open NinePointHeisenbergPair NinePointHeisenbergIncidence

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

abbrev QuadraticCoefficients := Fin 6 → K

private abbrev selectedPoints : List V := NinePointHeisenbergPair.selected
private abbrev uncoveredPoints : List V := NinePointHeisenbergPair.uncovered

/-- Evaluation of `X²,Y²,Z²,XY,XZ,YZ` at a coordinate vector. -/
def quadraticMonomial (p : V) : QuadraticCoefficients :=
  ![p 0 ^ 2, p 1 ^ 2, p 2 ^ 2, p 0 * p 1, p 0 * p 2, p 1 * p 2]

/-- Evaluation of a ternary quadratic form. -/
def quadraticValue (coefficients : QuadraticCoefficients) (p : V) : K :=
  dotProduct coefficients (quadraticMonomial p)

/-- The 126 increasing five-subsets of the nine orbit labels. -/
def fiveSubsetIndexLists : List (List (Fin 9)) :=
  List.sublistsLen 5 (List.ofFn fun i : Fin 9 => i)

private def pointFromIndexList (indices : List (Fin 9)) (i : Fin 5) : V :=
  uncoveredPoints.get (indices.getD i.val 0)

private def columnExcept (omitted : Fin 6) (j : Fin 5) : Fin 6 :=
  if j.val < omitted.val then
    ⟨j.val, by omega⟩
  else
    ⟨j.val + 1, by omega⟩

/-- A reducible coordinate formula for the determinant of a `3 × 3` matrix over `ZMod 19`. -/
def determinantThree (matrix : Matrix (Fin 3) (Fin 3) K) : K :=
  matrix 0 0 * matrix 1 1 * matrix 2 2 -
  matrix 0 0 * matrix 1 2 * matrix 2 1 -
  matrix 0 1 * matrix 1 0 * matrix 2 2 +
  matrix 0 1 * matrix 1 2 * matrix 2 0 +
  matrix 0 2 * matrix 1 0 * matrix 2 1 -
  matrix 0 2 * matrix 1 1 * matrix 2 0

private def determinantFour (matrix : Matrix (Fin 4) (Fin 4) K) : K :=
  matrix 0 0 * determinantThree (matrix.submatrix Fin.succ (0 : Fin 4).succAbove) -
  matrix 0 (Fin.succ 0) *
      determinantThree (matrix.submatrix Fin.succ (Fin.succ 0).succAbove) +
  matrix 0 (Fin.succ 0).succ *
      determinantThree (matrix.submatrix Fin.succ (Fin.succ 0).succ.succAbove) -
  matrix 0 (Fin.succ 0).succ.succ *
      determinantThree (matrix.submatrix Fin.succ (Fin.succ 0).succ.succ.succAbove)

/-- A reducible Laplace-expansion evaluator for a `5 × 5` determinant over `ZMod 19`. -/
def determinantFive (matrix : Matrix (Fin 5) (Fin 5) K) : K :=
  matrix 0 0 * determinantFour (matrix.submatrix Fin.succ (0 : Fin 5).succAbove) -
  matrix 0 (Fin.succ 0) *
      determinantFour (matrix.submatrix Fin.succ (Fin.succ 0).succAbove) +
  matrix 0 (Fin.succ 0).succ *
      determinantFour (matrix.submatrix Fin.succ (Fin.succ 0).succ.succAbove) -
  matrix 0 (Fin.succ 0).succ.succ *
      determinantFour (matrix.submatrix Fin.succ (Fin.succ 0).succ.succ.succAbove) +
  matrix 0 (Fin.succ 0).succ.succ.succ *
      determinantFour (matrix.submatrix Fin.succ (Fin.succ 0).succ.succ.succ.succAbove)

/-- The reducible `3 × 3` evaluator is the ordinary matrix determinant. -/
theorem determinantThree_eq_det (matrix : Matrix (Fin 3) (Fin 3) K) :
    determinantThree matrix = Matrix.det matrix := by
  rw [Matrix.det_fin_three]
  rfl

private theorem determinantFour_eq_det (matrix : Matrix (Fin 4) (Fin 4) K) :
    determinantFour matrix = Matrix.det matrix := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_succ, Fin.val_zero, pow_zero, one_mul, Fin.val_succ,
    pow_succ, neg_one_mul, Fin.isValue]
  simp only [determinantFour, determinantThree_eq_det]
  norm_num
  ring

/-- The reducible `5 × 5` Laplace evaluator is the ordinary matrix determinant. -/
theorem determinantFive_eq_det (matrix : Matrix (Fin 5) (Fin 5) K) :
    determinantFive matrix = Matrix.det matrix := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_succ, Fin.val_zero, pow_zero, one_mul, Fin.val_succ,
    pow_succ, neg_one_mul, Fin.isValue]
  simp only [determinantFive, determinantFour_eq_det]
  norm_num
  ring

/-- The `5 × 5` evaluation minor obtained by omitting one quadratic monomial. -/
def fivePointEvaluationMinor (indices : List (Fin 9)) (omitted : Fin 6) :
    Matrix (Fin 5) (Fin 5) K :=
  fun i j => quadraticMonomial (pointFromIndexList indices i) (columnExcept omitted j)

private def signedMinor (indices : List (Fin 9)) (omitted : Fin 6) : K :=
  if omitted.val % 2 = 0 then
    determinantFive (fivePointEvaluationMinor indices omitted)
  else
    -determinantFive (fivePointEvaluationMinor indices omitted)

/-- The signed-minor coefficient vector of the conic through a five-subset. -/
def rawFivePointConic (indices : List (Fin 9)) : QuadraticCoefficients :=
  fun omitted => signedMinor indices omitted

private def firstNonzeroInverse (coefficients : QuadraticCoefficients) : K :=
  if coefficients 0 ≠ 0 then (coefficients 0)⁻¹ else
  if coefficients 1 ≠ 0 then (coefficients 1)⁻¹ else
  if coefficients 2 ≠ 0 then (coefficients 2)⁻¹ else
  if coefficients 3 ≠ 0 then (coefficients 3)⁻¹ else
  if coefficients 4 ≠ 0 then (coefficients 4)⁻¹ else
  if coefficients 5 ≠ 0 then (coefficients 5)⁻¹ else 0

/-- Projective normalization by the first nonzero quadratic coefficient. -/
def normalizeQuadratic (coefficients : QuadraticCoefficients) : QuadraticCoefficients :=
  fun index => firstNonzeroInverse coefficients * coefficients index

/-- The normalized conic attached to each of the 126 five-subsets. -/
def fiveSubsetConics : List QuadraticCoefficients :=
  fiveSubsetIndexLists.map fun indices => normalizeQuadratic (rawFivePointConic indices)

/-- Reducible coordinate equality for normalized quadratic coefficient vectors. -/
def sameQuadraticCoefficients
    (left right : QuadraticCoefficients) : Bool :=
  decide (left 0 = right 0) &&
  decide (left 1 = right 1) &&
  decide (left 2 = right 2) &&
  decide (left 3 = right 3) &&
  decide (left 4 = right 4) &&
  decide (left 5 = right 5)

private def containsQuadratic
    (coefficients : QuadraticCoefficients) : List QuadraticCoefficients → Bool
  | [] => false
  | known :: remaining =>
      sameQuadraticCoefficients coefficients known ||
        containsQuadratic coefficients remaining

private def deduplicateQuadratics :
    List QuadraticCoefficients → List QuadraticCoefficients → List QuadraticCoefficients
  | known, [] => known
  | known, coefficients :: remaining =>
      if containsQuadratic coefficients known then
        deduplicateQuadratics known remaining
      else
        deduplicateQuadratics (known ++ [coefficients]) remaining

/-- The duplicate-free list of conics determined by five-subsets of the uncovered orbit. -/
def distinctConics : List QuadraticCoefficients :=
  deduplicateQuadratics [] fiveSubsetConics

/-- Reducible coordinate equality is equivalent to equality of quadratic coefficient vectors. -/
theorem sameQuadraticCoefficients_eq_true_iff
    (left right : QuadraticCoefficients) :
    sameQuadraticCoefficients left right = true ↔ left = right := by
  constructor
  · intro h
    simp only [sameQuadraticCoefficients, Bool.and_eq_true, decide_eq_true_eq] at h
    funext i
    fin_cases i <;> simp_all
  · rintro rfl
    simp [sameQuadraticCoefficients]

/-- Twice the symmetric matrix of a quadratic form; nonsingularity is unchanged in odd
characteristic. -/
def doubledSymmetricMatrix (coefficients : QuadraticCoefficients) : Matrix (Fin 3) (Fin 3) K :=
  ![![2 * coefficients 0, coefficients 3, coefficients 4],
    ![coefficients 3, 2 * coefficients 1, coefficients 5],
    ![coefficients 4, coefficients 5, 2 * coefficients 2]]

/-- Coordinate nonsingularity predicate for a ternary quadratic form. -/
def isNonsingular (coefficients : QuadraticCoefficients) : Bool :=
  decide (determinantThree (doubledSymmetricMatrix coefficients) ≠ 0)

/-- Number of points of a coordinate list on a conic. -/
def pointsOnConic (coefficients : QuadraticCoefficients) (points : List V) : Nat :=
  points.countP fun p => quadraticValue coefficients p = 0

/-- The rational projective points on a conic. -/
def rationalConicPoints (coefficients : QuadraticCoefficients) : List V :=
  canonicalPoints.filter fun p => quadraticValue coefficients p = 0

/-- Number of conic secants through a projective point. -/
def conicSecantMultiplicity (coefficients : QuadraticCoefficients) (p : V) : Nat :=
  secantMultiplicity (rationalConicPoints coefficients) p

/-- Whether a nonzero field element is a square. -/
def isNonzeroSquare (value : K) : Bool :=
  fieldElements.any fun root => root ≠ 0 && root * root = value

/-- Discriminant-square predicate for an internal off-conic point. -/
def isInternalPoint (coefficients : QuadraticCoefficients) (p : V) : Bool :=
  quadraticValue coefficients p ≠ 0 &&
    isNonzeroSquare
      (-Matrix.det (doubledSymmetricMatrix coefficients) * quadraticValue coefficients p)

/-- Discriminant-square predicate for an external off-conic point. -/
def isExternalPoint (coefficients : QuadraticCoefficients) (p : V) : Bool :=
  quadraticValue coefficients p ≠ 0 &&
    isNonzeroSquare
      (Matrix.det (doubledSymmetricMatrix coefficients) * quadraticValue coefficients p)

/-- Agreement, at every selected-orbit point, between the discriminant-square point type and the
number of rational conic secants through that point. -/
def conicTypeAgreement (coefficients : QuadraticCoefficients) : Bool :=
  NinePointHeisenbergPair.selected.all fun p =>
    decide (quadraticValue coefficients p = 0) ||
      ((isInternalPoint coefficients p == decide (conicSecantMultiplicity coefficients p = 10)) &&
       (isExternalPoint coefficients p == decide (conicSecantMultiplicity coefficients p = 9)))

/-- Number of selected points internal to a conic. -/
def selectedInternalCount (coefficients : QuadraticCoefficients) : Nat :=
  selectedPoints.countP fun p => isInternalPoint coefficients p

/-- Number of selected points external to a conic. -/
def selectedExternalCount (coefficients : QuadraticCoefficients) : Nat :=
  selectedPoints.countP fun p => isExternalPoint coefficients p

/-- The four numerical fields in the conic profile. -/
def conicProfile (coefficients : QuadraticCoefficients) : Nat × Nat × Nat × Nat :=
  (pointsOnConic coefficients uncoveredPoints,
    pointsOnConic coefficients selectedPoints,
    selectedInternalCount coefficients,
    selectedExternalCount coefficients)

/-- Number of distinct conics with a prescribed profile. -/
def conicProfileCount (uOn aOn aInternal aExternal : Nat) : Nat :=
  distinctConics.countP fun coefficients =>
    conicProfile coefficients = (uOn, aOn, aInternal, aExternal)

/-- Number of five-subsets producing a specified normalized conic. -/
def fiveSubsetMultiplicity (coefficients : QuadraticCoefficients) : Nat :=
  fiveSubsetConics.countP (sameQuadraticCoefficients coefficients)

/-- Number of distinct conics with a prescribed five-subset multiplicity. -/
def conicMultiplicityCount (multiplicity : Nat) : Nat :=
  distinctConics.countP fun coefficients => fiveSubsetMultiplicity coefficients = multiplicity

abbrev Label := NinePointHeisenbergIncidence.Label

private def addLabel (x y : Label) : Label := (x.1 + y.1, x.2 + y.2)

private def omittedRelativeLabels (selectedLabel : Label) : List Label :=
  [(addLabel selectedLabel (1, 0)),
    (addLabel selectedLabel (2, 0)),
    (addLabel selectedLabel (2, 2))]

/-- Whether a conic has the six-point omitted-label pattern relative to a selected orbit label. -/
def hasRelativeSixPointProfile
    (selectedLabel : Label) (coefficients : QuadraticCoefficients) : Bool :=
  quadraticValue coefficients (selectedAt selectedLabel) = 0 &&
  pointsOnConic coefficients selectedPoints = 1 &&
  pointsOnConic coefficients uncoveredPoints = 6 &&
  labels.all (fun uLabel =>
    decide (quadraticValue coefficients (uncoveredAt uLabel) = 0) ==
      !(omittedRelativeLabels selectedLabel).contains uLabel)

/-- The first six-point conic with the prescribed relative label profile, or the zero form if the
finite list has no such conic. -/
def chosenSixPointConic (selectedLabel : Label) : QuadraticCoefficients :=
  (distinctConics.find? (hasRelativeSixPointProfile selectedLabel)).getD 0

/-- Whether a matrix carries the rational point set of one conic onto that of another. -/
def mapsRationalConic
    (matrix : M) (source target : QuadraticCoefficients) : Bool :=
  canonicalPoints.all fun p =>
    decide (quadraticValue source p = 0) ==
      decide (quadraticValue target (Matrix.mulVec matrix p) = 0)

/-- The tangent line to a quadratic form at a coordinate point. -/
def tangentLine (coefficients : QuadraticCoefficients) (p : V) : V :=
  ![2 * coefficients 0 * p 0 + coefficients 3 * p 1 + coefficients 4 * p 2,
    2 * coefficients 1 * p 1 + coefficients 3 * p 0 + coefficients 5 * p 2,
    2 * coefficients 2 * p 2 + coefficients 4 * p 0 + coefficients 5 * p 1]

/-- Tangent incidence predicate for a conic containing six uncovered points. -/
def closestConicTangentProfile (coefficients : QuadraticCoefficients) : Bool :=
  if h : pointsOnConic coefficients uncoveredPoints = 6 then
    pointsOnConic coefficients selectedPoints = 1 &&
      match selectedPoints.find? (fun p => quadraticValue coefficients p = 0) with
      | some p =>
          NinePointHeisenbergIncidence.pointsOnLine
              (tangentLine coefficients p) selectedPoints = 1 &&
          NinePointHeisenbergIncidence.pointsOnLine
              (tangentLine coefficients p) uncoveredPoints = 0
      | none => false
  else true

attribute [reducible] quadraticMonomial quadraticValue fiveSubsetIndexLists
  pointFromIndexList columnExcept determinantThree determinantFour determinantFive
  fivePointEvaluationMinor signedMinor rawFivePointConic
  firstNonzeroInverse normalizeQuadratic fiveSubsetConics sameQuadraticCoefficients
  containsQuadratic deduplicateQuadratics distinctConics
  doubledSymmetricMatrix isNonsingular pointsOnConic rationalConicPoints
  conicSecantMultiplicity conicTypeAgreement isNonzeroSquare isInternalPoint isExternalPoint
  selectedInternalCount selectedExternalCount conicProfile conicProfileCount
  fiveSubsetMultiplicity conicMultiplicityCount addLabel omittedRelativeLabels
  hasRelativeSixPointProfile chosenSixPointConic mapsRationalConic tangentLine
  closestConicTangentProfile

end NinePointHeisenbergConicCensus
end RelativeConicArcs
