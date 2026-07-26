import RelativeConicArcs.NinePointHeisenbergPair
import Mathlib.Data.List.Sublists

/-!
# Frame-normalized stabilizers of a nine-point Heisenberg pair

A projectivity of a projective plane is determined by the ordered image of a projective frame.
For each of the two explicit nine-arcs in `PG(2, 19)`, the first four listed points form such a
frame.  This module constructs the unique coordinate matrix carrying that source frame to each
ordered four-tuple of distinct target points.  It checks all `9·8·7·6 = 3024` target frames.

The terminal results are split by the first two target indices.  Together they check all 3024
frames, certify that every constructed coordinate matrix is nonsingular, count the projectivities
stabilizing either orbit and the ordered pair, and rule out projectivities interchanging the two
orbits.  The enumeration, matrix construction, determinant tests, and ray tests are all evaluated
by the Lean kernel; no externally generated transporter list is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergStabilizer

open NinePointHeisenbergPair

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

private def point (x y z : Nat) : V := ![x, y, z]

private def selectedPoints : List V := [
  point 0 0 1, point 0 1 0, point 1 0 0, point 1 1 1, point 1 2 3,
  point 1 3 11, point 1 4 9, point 1 13 7, point 1 14 15]

private def uncoveredPoints : List V := [
  point 1 6 10, point 1 6 18, point 1 10 4, point 1 11 16, point 1 15 2,
  point 1 15 18, point 1 16 6, point 1 16 10, point 1 18 4]

private def finiteNine : List (Fin 9) := List.ofFn fun i : Fin 9 => i
private def finiteThree : List (Fin 3) := List.ofFn fun i : Fin 3 => i
private def fieldElements : List K := List.ofFn fun i : Fin 19 => (i.val : K)

private def fieldPower : K → Nat → K
  | _, 0 => 1
  | value, exponent + 1 => fieldPower value exponent * value

private def fieldInverse (value : K) : K := fieldPower value 17

abbrev OrbitLabel := Fin 3 × Fin 3

/-- The list index corresponding to a `C₃ × C₃` orbit label. -/
def orbitIndex (label : OrbitLabel) : Fin 9 :=
  ⟨label.2.val * 3 + label.1.val, by omega⟩

/-- The nine orbit labels. -/
def orbitLabels : List OrbitLabel :=
  (List.ofFn fun i : Fin 3 => i).flatMap fun i =>
    (List.ofFn fun j : Fin 3 => j).map fun j => (i, j)

private def orderedIndexFramesAt (label : OrbitLabel) : List (List (Fin 9)) :=
  let i := orbitIndex label
  finiteNine.flatMap fun j =>
    finiteNine.flatMap fun k =>
      finiteNine.filterMap fun l =>
        if i ≠ j ∧ i ≠ k ∧ i ≠ l ∧ j ≠ k ∧ j ≠ l ∧ k ≠ l then
          some [i, j, k, l]
        else none

private def orderedIndexFramesAtPrefix (first second : Fin 9) : List (List (Fin 9)) :=
  finiteNine.flatMap fun third =>
    finiteNine.filterMap fun fourth =>
      if first ≠ second ∧ first ≠ third ∧ first ≠ fourth ∧
          second ≠ third ∧ second ≠ fourth ∧ third ≠ fourth then
        some [first, second, third, fourth]
      else none

private def orderedIndexFrames : List (List (Fin 9)) :=
  orbitLabels.flatMap orderedIndexFramesAt

private def framePoint (points : List V) (indices : List (Fin 9)) (i : Fin 4) : V :=
  points.getD (indices.getD i.val 0).val 0

private def coordinateMatrix (points : List V) (indices : List (Fin 9)) : M :=
  fun i j => framePoint points indices ⟨j.val, by omega⟩ i

/-- The Leibniz determinant formula specialized to a three-by-three matrix. -/
def determinantThree (matrix : M) : K :=
  matrix 0 0 * (matrix 1 1 * matrix 2 2 - matrix 1 2 * matrix 2 1) -
  matrix 0 1 * (matrix 1 0 * matrix 2 2 - matrix 1 2 * matrix 2 0) +
  matrix 0 2 * (matrix 1 0 * matrix 2 1 - matrix 1 1 * matrix 2 0)

private def multiplyMatrices (left right : M) : M :=
  fun i j =>
    left i 0 * right 0 j + left i 1 * right 1 j + left i 2 * right 2 j

private def applyMatrix (matrix : M) (vector : V) : V :=
  fun i => matrix i 0 * vector 0 + matrix i 1 * vector 1 + matrix i 2 * vector 2

private def matrixPower : M → Nat → M
  | _, 0 => 1
  | matrix, exponent + 1 => multiplyMatrices (matrixPower matrix exponent) matrix

private def inverseMatrix (matrix : M) : M :=
  let scale := fieldInverse (determinantThree matrix)
  scale •
    ![![matrix 1 1 * matrix 2 2 - matrix 1 2 * matrix 2 1,
        matrix 0 2 * matrix 2 1 - matrix 0 1 * matrix 2 2,
        matrix 0 1 * matrix 1 2 - matrix 0 2 * matrix 1 1],
      ![matrix 1 2 * matrix 2 0 - matrix 1 0 * matrix 2 2,
        matrix 0 0 * matrix 2 2 - matrix 0 2 * matrix 2 0,
        matrix 0 2 * matrix 1 0 - matrix 0 0 * matrix 1 2],
      ![matrix 1 0 * matrix 2 1 - matrix 1 1 * matrix 2 0,
        matrix 0 1 * matrix 2 0 - matrix 0 0 * matrix 2 1,
        matrix 0 0 * matrix 1 1 - matrix 0 1 * matrix 1 0]]

private def diagonalMatrix (diagonal : V) : M :=
  fun i j => if i = j then diagonal i else 0

/--
The frame normalizer sends the first three frame points to the coordinate rays and the fourth
to the ray of `(1,1,1)`.
-/
def frameNormalizer (points : List V) (indices : List (Fin 9)) : M :=
  let basis := coordinateMatrix points indices
  let inverseBasis := inverseMatrix basis
  let fourthCoordinates :=
    applyMatrix inverseBasis (framePoint points indices 3)
  multiplyMatrices (diagonalMatrix (fun i => fieldInverse (fourthCoordinates i))) inverseBasis

/-- The canonical matrix carrying one ordered projective frame to another. -/
def frameProjectivity
    (source : List V) (sourceIndices : List (Fin 9))
    (target : List V) (targetIndices : List (Fin 9)) : M :=
  multiplyMatrices (inverseMatrix (frameNormalizer target targetIndices))
    (frameNormalizer source sourceIndices)

private def sourceFrame : List (Fin 9) := [0, 1, 2, 3]

/-- The frame-normalized candidate matrices from one nine-point set to another. -/
def frameCandidates (source target : List V) : List M :=
  orderedIndexFrames.map fun targetFrame =>
    frameProjectivity source sourceFrame target targetFrame

/-- Candidate matrices whose first source-frame point has a prescribed target orbit label. -/
def frameCandidatesAt (source target : List V) (label : OrbitLabel) : List M :=
  (orderedIndexFramesAt label).map fun targetFrame =>
    frameProjectivity source sourceFrame target targetFrame

private def frameCandidatesAtPrefix
    (source target : List V) (first second : Fin 9) : List M :=
  (orderedIndexFramesAtPrefix first second).map fun targetFrame =>
    frameProjectivity source sourceFrame target targetFrame

/-- Canonical normalization of a nonzero coordinate ray. -/
def normalizeRay (point : V) : V :=
  if point 0 ≠ 0 then fieldInverse (point 0) • point else
  if point 1 ≠ 0 then fieldInverse (point 1) • point else
  if point 2 ≠ 0 then fieldInverse (point 2) • point else 0

/-- Whether a coordinate matrix maps every source ray into the target ray set. -/
def mapsRaysTo (matrix : M) (source target : List V) : Bool :=
  source.all fun p =>
    target.any fun q => normalizeRay (applyMatrix matrix p) = normalizeRay q

/-- Whether two coordinate matrices differ by a nonzero scalar. -/
def matrixScalarEquivalent (left right : M) : Bool :=
  fieldElements.any fun scalar =>
    scalar ≠ 0 && decide (left = scalar • right)

/-- The nine coordinate matrices `g^i h^j`, for `0 ≤ i,j < 3`. -/
def displayedHeisenbergMatrices : List M :=
  finiteThree.flatMap fun i =>
    finiteThree.map fun j =>
      multiplyMatrices (matrixPower g i.val) (matrixPower h j.val)

private def e₀ : V := ![1, 0, 0]
private def e₁ : V := ![0, 1, 0]
private def e₂ : V := ![0, 0, 1]
private def e₀₁₂ : V := ![1, 1, 1]

/--
Two nonsingular coordinate matrices that induce the same images of the coordinate projective
frame differ by a scalar.  This is the matrix form of projective-frame uniqueness used by the
finite transporter enumeration.
-/
theorem matrix_eq_smul_of_coordinate_frame_rays
    (left right : M) (rightNonsingular : Matrix.det right ≠ 0)
    (h₀ : Certificate.RayEq (Matrix.mulVec left e₀) (Matrix.mulVec right e₀))
    (h₁ : Certificate.RayEq (Matrix.mulVec left e₁) (Matrix.mulVec right e₁))
    (h₂ : Certificate.RayEq (Matrix.mulVec left e₂) (Matrix.mulVec right e₂))
    (h₀₁₂ : Certificate.RayEq (Matrix.mulVec left e₀₁₂) (Matrix.mulVec right e₀₁₂)) :
    ∃ scalar : K, left = scalar • right := by
  rcases h₀ with ⟨a, ha⟩
  rcases h₁ with ⟨b, hb⟩
  rcases h₂ with ⟨c, hc⟩
  rcases h₀₁₂ with ⟨d, hd⟩
  have ha' : ∀ i, left i 0 = a * right i 0 := by
    intro i
    have := congrFun ha i
    simpa [e₀, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] using this.symm
  have hb' : ∀ i, left i 1 = b * right i 1 := by
    intro i
    have := congrFun hb i
    simpa [e₁, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] using this.symm
  have hc' : ∀ i, left i 2 = c * right i 2 := by
    intro i
    have := congrFun hc i
    simpa [e₂, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] using this.symm
  have hd' : ∀ i,
      left i 0 + left i 1 + left i 2 =
        d * (right i 0 + right i 1 + right i 2) := by
    intro i
    have := congrFun hd i
    simpa [e₀₁₂, Matrix.mulVec, dotProduct, Fin.sum_univ_succ, mul_add, add_assoc] using this.symm
  have hmul :
      Matrix.mulVec right ![a, b, c] = Matrix.mulVec right ![d, d, d] := by
    funext i
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
    calc
      right i 0 * a + (right i 1 * b + right i 2 * c) =
          left i 0 + (left i 1 + left i 2) := by
            rw [ha' i, hb' i, hc' i]
            ring
      _ = d * (right i 0 + (right i 1 + right i 2)) := by
        simpa [add_assoc] using hd' i
      _ = right i 0 * d + (right i 1 * d + right i 2 * d) := by ring
  have habc : (![a, b, c] : V) = ![d, d, d] :=
    Matrix.mulVec_injective_of_isUnit
      (right.isUnit_iff_isUnit_det.mpr ((isUnit_iff_ne_zero).2 rightNonsingular)) hmul
  have had : a = d := by simpa using congrFun habc 0
  have hbd : b = d := by simpa using congrFun habc 1
  have hcd : c = d := by simpa using congrFun habc 2
  refine ⟨d, ?_⟩
  ext i j
  fin_cases j
  · simp [ha' i, had]
  · simp [hb' i, hbd]
  · simp [hc' i, hcd]

/-- The reducible three-by-three determinant evaluator agrees with `Matrix.det`. -/
theorem determinantThree_eq_det (matrix : M) :
    determinantThree matrix = Matrix.det matrix := by
  rw [Matrix.det_fin_three]
  unfold determinantThree
  ring

/-- Frame-normalized projectivities stabilizing the selected orbit. -/
def selectedStabilizers : List M :=
  (frameCandidates selectedPoints selectedPoints).filter fun matrix =>
    mapsRaysTo matrix selectedPoints selectedPoints

/-- Frame-normalized projectivities stabilizing the uncovered orbit. -/
def uncoveredStabilizers : List M :=
  (frameCandidates uncoveredPoints uncoveredPoints).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints uncoveredPoints

/-- Frame-normalized projectivities stabilizing both members of the ordered pair. -/
def pairStabilizers : List M :=
  selectedStabilizers.filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints uncoveredPoints

/-- Frame-normalized projectivities carrying the selected orbit to the uncovered orbit. -/
def selectedToUncovered : List M :=
  (frameCandidates selectedPoints uncoveredPoints).filter fun matrix =>
    mapsRaysTo matrix selectedPoints uncoveredPoints

/-- Frame-normalized projectivities carrying the uncovered orbit to the selected orbit. -/
def uncoveredToSelected : List M :=
  (frameCandidates uncoveredPoints selectedPoints).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints selectedPoints

/-- Selected-orbit stabilizers with prescribed first frame-image label. -/
def selectedStabilizersAt (label : OrbitLabel) : List M :=
  (frameCandidatesAt selectedPoints selectedPoints label).filter fun matrix =>
    mapsRaysTo matrix selectedPoints selectedPoints

/-- Uncovered-orbit stabilizers with prescribed first frame-image label. -/
def uncoveredStabilizersAt (label : OrbitLabel) : List M :=
  (frameCandidatesAt uncoveredPoints uncoveredPoints label).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints uncoveredPoints

/-- Ordered-pair stabilizers with prescribed first selected-frame image label. -/
def pairStabilizersAt (label : OrbitLabel) : List M :=
  (selectedStabilizersAt label).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints uncoveredPoints

/-- Selected-to-uncovered transporters with prescribed first frame-image label. -/
def selectedToUncoveredAt (label : OrbitLabel) : List M :=
  (frameCandidatesAt selectedPoints uncoveredPoints label).filter fun matrix =>
    mapsRaysTo matrix selectedPoints uncoveredPoints

/-- Uncovered-to-selected transporters with prescribed first frame-image label. -/
def uncoveredToSelectedAt (label : OrbitLabel) : List M :=
  (frameCandidatesAt uncoveredPoints selectedPoints label).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints selectedPoints

private def selectedStabilizersAtPrefix (first second : Fin 9) : List M :=
  (frameCandidatesAtPrefix selectedPoints selectedPoints first second).filter fun matrix =>
    mapsRaysTo matrix selectedPoints selectedPoints

private def uncoveredStabilizersAtPrefix (first second : Fin 9) : List M :=
  (frameCandidatesAtPrefix uncoveredPoints uncoveredPoints first second).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints uncoveredPoints

private def pairStabilizersAtPrefix (first second : Fin 9) : List M :=
  (selectedStabilizersAtPrefix first second).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints uncoveredPoints

private def selectedToUncoveredAtPrefix (first second : Fin 9) : List M :=
  (frameCandidatesAtPrefix selectedPoints uncoveredPoints first second).filter fun matrix =>
    mapsRaysTo matrix selectedPoints uncoveredPoints

private def uncoveredToSelectedAtPrefix (first second : Fin 9) : List M :=
  (frameCandidatesAtPrefix uncoveredPoints selectedPoints first second).filter fun matrix =>
    mapsRaysTo matrix uncoveredPoints selectedPoints

/-- Number of selected-orbit stabilizers in one first-two-image frame block. -/
def selectedStabilizerPrefixCount (first second : Fin 9) : Nat :=
  (selectedStabilizersAtPrefix first second).length

/-- Number of uncovered-orbit stabilizers in one first-two-image frame block. -/
def uncoveredStabilizerPrefixCount (first second : Fin 9) : Nat :=
  (uncoveredStabilizersAtPrefix first second).length

/-- Number of ordered-pair stabilizers in one first-two-image frame block. -/
def pairStabilizerPrefixCount (first second : Fin 9) : Nat :=
  (pairStabilizersAtPrefix first second).length

/-- Number of selected-to-uncovered transporters in one first-two-image frame block. -/
def selectedToUncoveredPrefixCount (first second : Fin 9) : Nat :=
  (selectedToUncoveredAtPrefix first second).length

/-- Number of uncovered-to-selected transporters in one first-two-image frame block. -/
def uncoveredToSelectedPrefixCount (first second : Fin 9) : Nat :=
  (uncoveredToSelectedAtPrefix first second).length

private def prefixCandidatesNonsingular
    (source target : List V) (first second : Fin 9) : Bool :=
  (frameCandidatesAtPrefix source target first second).all fun matrix =>
    determinantThree matrix != 0

attribute [reducible] point selectedPoints uncoveredPoints finiteNine finiteThree fieldElements
  fieldPower fieldInverse
  orbitIndex orbitLabels orderedIndexFramesAt orderedIndexFramesAtPrefix
  orderedIndexFrames framePoint coordinateMatrix determinantThree multiplyMatrices applyMatrix
  matrixPower inverseMatrix diagonalMatrix frameNormalizer frameProjectivity sourceFrame
  frameCandidates frameCandidatesAt frameCandidatesAtPrefix normalizeRay mapsRaysTo selectedStabilizers
  matrixScalarEquivalent displayedHeisenbergMatrices
  uncoveredStabilizers pairStabilizers selectedToUncovered uncoveredToSelected
  selectedStabilizersAt uncoveredStabilizersAt pairStabilizersAt selectedToUncoveredAt
  uncoveredToSelectedAt selectedStabilizersAtPrefix uncoveredStabilizersAtPrefix
  pairStabilizersAtPrefix selectedToUncoveredAtPrefix uncoveredToSelectedAtPrefix
  selectedStabilizerPrefixCount uncoveredStabilizerPrefixCount pairStabilizerPrefixCount
  selectedToUncoveredPrefixCount uncoveredToSelectedPrefixCount
  prefixCandidatesNonsingular

/-- The ordered target-frame domain has exactly 3024 elements. -/
theorem ordered_frame_count : orderedIndexFrames.length = 3024 := by decide

/--
The displayed Heisenberg matrices give nine distinct projectivities preserving both members of
the ordered pair.
-/
theorem displayed_heisenberg_matrices_are_distinct_pair_stabilizers :
    displayedHeisenbergMatrices.length = 9 ∧
    displayedHeisenbergMatrices.all (fun matrix =>
      decide (Matrix.det matrix ≠ 0) &&
      mapsRaysTo matrix NinePointHeisenbergPair.selected NinePointHeisenbergPair.selected &&
      mapsRaysTo matrix NinePointHeisenbergPair.uncovered NinePointHeisenbergPair.uncovered) = true ∧
    (List.sublistsLen 2 displayedHeisenbergMatrices).all (fun pair =>
      match pair with
      | [left, right] => !matrixScalarEquivalent left right
      | _ => false) = true := by
  decide

private def selectedExpectedSecond : Fin 9 → Fin 9 :=
  ![1, 2, 0, 4, 5, 3, 8, 6, 7]

private def uncoveredExpectedSecond : Fin 9 → Fin 9 :=
  ![1, 7, 5, 8, 3, 6, 2, 0, 4]

private def expectedMultiplicity (actual expected : Fin 9) : Nat :=
  if actual = expected then 1 else 0

private def belongsToDisplayedHeisenbergSubgroup (matrix : M) : Bool :=
  displayedHeisenbergMatrices.any fun heisenbergMatrix =>
    matrixScalarEquivalent matrix heisenbergMatrix

private abbrev prefixCountFacts (first second : Fin 9) : Prop :=
  selectedStabilizerPrefixCount first second =
      expectedMultiplicity second (selectedExpectedSecond first) ∧
  uncoveredStabilizerPrefixCount first second =
      expectedMultiplicity second (uncoveredExpectedSecond first) ∧
  pairStabilizerPrefixCount first second =
      expectedMultiplicity second (selectedExpectedSecond first) ∧
  selectedToUncoveredPrefixCount first second = 0 ∧
  uncoveredToSelectedPrefixCount first second = 0

/--
The complete transporter count for one ordered prefix of the target frame.  Fixing the first two
images leaves 42 ordered target frames.  The two displayed expected-second tables specify the
unique accepted transporter in each orbit; all other prefixes contain none, and no prefix contains
an orbit interchange.  It also checks nonsingularity for every candidate matrix used in the four
source-target transporter enumerations.
-/
def stabilizerPrefixProfile (first second : Fin 9) : Bool :=
  decide (prefixCountFacts first second) &&
  prefixCandidatesNonsingular selectedPoints selectedPoints first second &&
  prefixCandidatesNonsingular uncoveredPoints uncoveredPoints first second &&
  prefixCandidatesNonsingular selectedPoints uncoveredPoints first second &&
  prefixCandidatesNonsingular uncoveredPoints selectedPoints first second &&
  (selectedStabilizersAtPrefix first second).all belongsToDisplayedHeisenbergSubgroup &&
  (uncoveredStabilizersAtPrefix first second).all belongsToDisplayedHeisenbergSubgroup &&
  (pairStabilizersAtPrefix first second).all belongsToDisplayedHeisenbergSubgroup

attribute [reducible] selectedExpectedSecond uncoveredExpectedSecond expectedMultiplicity
  belongsToDisplayedHeisenbergSubgroup stabilizerPrefixProfile

/-- Sum of the selected-orbit stabilizer counts over the 81 frame-prefix blocks. -/
def frameNormalizedSelectedStabilizerCount : Nat :=
  (finiteNine.map fun first =>
    (finiteNine.map fun second => selectedStabilizerPrefixCount first second).sum).sum

/-- Sum of the uncovered-orbit stabilizer counts over the 81 frame-prefix blocks. -/
def frameNormalizedUncoveredStabilizerCount : Nat :=
  (finiteNine.map fun first =>
    (finiteNine.map fun second => uncoveredStabilizerPrefixCount first second).sum).sum

/-- Sum of the ordered-pair stabilizer counts over the 81 frame-prefix blocks. -/
def frameNormalizedPairStabilizerCount : Nat :=
  (finiteNine.map fun first =>
    (finiteNine.map fun second => pairStabilizerPrefixCount first second).sum).sum

/-- Sum of the selected-to-uncovered transporter counts over the 81 frame-prefix blocks. -/
def frameNormalizedSelectedToUncoveredCount : Nat :=
  (finiteNine.map fun first =>
    (finiteNine.map fun second => selectedToUncoveredPrefixCount first second).sum).sum

/-- Sum of the uncovered-to-selected transporter counts over the 81 frame-prefix blocks. -/
def frameNormalizedUncoveredToSelectedCount : Nat :=
  (finiteNine.map fun first =>
    (finiteNine.map fun second => uncoveredToSelectedPrefixCount first second).sum).sum

private theorem prefix_counts_of_profile
    (first second : Fin 9) (profile : stabilizerPrefixProfile first second = true) :
    selectedStabilizerPrefixCount first second =
        expectedMultiplicity second (selectedExpectedSecond first) ∧
    uncoveredStabilizerPrefixCount first second =
        expectedMultiplicity second (uncoveredExpectedSecond first) ∧
    pairStabilizerPrefixCount first second =
        expectedMultiplicity second (selectedExpectedSecond first) ∧
    selectedToUncoveredPrefixCount first second = 0 ∧
    uncoveredToSelectedPrefixCount first second = 0 := by
  simp only [stabilizerPrefixProfile, Bool.and_eq_true] at profile
  exact of_decide_eq_true profile.1.1.1.1.1.1.1

/--
If all 81 frame-prefix profiles hold, the selected orbit, uncovered orbit, and ordered pair each
have exactly nine frame-normalized stabilizers, while neither orbit has a transporter to the
other.
-/
theorem exact_frame_normalized_stabilizer_counts_of_profiles
    (profiles : ∀ first second : Fin 9, stabilizerPrefixProfile first second = true) :
    frameNormalizedSelectedStabilizerCount = 9 ∧
    frameNormalizedUncoveredStabilizerCount = 9 ∧
    frameNormalizedPairStabilizerCount = 9 ∧
    frameNormalizedSelectedToUncoveredCount = 0 ∧
    frameNormalizedUncoveredToSelectedCount = 0 := by
  unfold frameNormalizedSelectedStabilizerCount frameNormalizedUncoveredStabilizerCount
    frameNormalizedPairStabilizerCount frameNormalizedSelectedToUncoveredCount
    frameNormalizedUncoveredToSelectedCount
  simp_rw [(prefix_counts_of_profile _ _ (profiles _ _)).1]
  simp_rw [(prefix_counts_of_profile _ _ (profiles _ _)).2.1]
  simp_rw [(prefix_counts_of_profile _ _ (profiles _ _)).2.2.1]
  simp_rw [(prefix_counts_of_profile _ _ (profiles _ _)).2.2.2.1]
  simp_rw [(prefix_counts_of_profile _ _ (profiles _ _)).2.2.2.2]
  decide

end NinePointHeisenbergStabilizer
end RelativeConicArcs
