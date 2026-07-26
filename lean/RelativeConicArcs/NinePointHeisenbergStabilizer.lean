import RelativeConicArcs.NinePointHeisenbergPair
import Mathlib.Data.List.Sublists

/-!
# Frame-normalized stabilizers of a nine-point Heisenberg pair

A projectivity of a projective plane is determined by the ordered image of a projective frame.
For each of the two explicit nine-arcs in `PG(2, 19)`, the first four listed points form such a
frame.  This module constructs the unique coordinate matrix carrying that source frame to each
ordered four-tuple of distinct target points.  It checks all `9·8·7·6 = 3024` target frames.

The terminal results count the frame-normalized projectivities stabilizing either orbit and the
ordered pair, and check that no frame-normalized projectivity interchanges the two orbits.  The
enumeration, matrix construction, ray tests, and deduplication are all evaluated by the Lean
kernel; no externally generated transporter list is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergStabilizer

open NinePointHeisenbergPair

set_option maxHeartbeats 800000000
set_option maxRecDepth 100000

private abbrev selectedPoints : List V := NinePointHeisenbergPair.selected
private abbrev uncoveredPoints : List V := NinePointHeisenbergPair.uncovered

private def finiteNine : List (Fin 9) := List.ofFn fun i : Fin 9 => i
private def fieldElements : List K := List.ofFn fun i : Fin 19 => (i.val : K)

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

private def orderedIndexFrames : List (List (Fin 9)) :=
  orbitLabels.flatMap orderedIndexFramesAt

private def framePoint (points : List V) (indices : List (Fin 9)) (i : Fin 4) : V :=
  points.getD (indices.getD i.val 0).val 0

private def coordinateMatrix (points : List V) (indices : List (Fin 9)) : M :=
  fun i j => framePoint points indices ⟨j.val, by omega⟩ i

private def inverseMatrix (matrix : M) : M :=
  let scale := (Matrix.det matrix)⁻¹
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
    Matrix.mulVec inverseBasis (framePoint points indices 3)
  diagonalMatrix (fun i => (fourthCoordinates i)⁻¹) * inverseBasis

/-- The canonical matrix carrying one ordered projective frame to another. -/
def frameProjectivity
    (source : List V) (sourceIndices : List (Fin 9))
    (target : List V) (targetIndices : List (Fin 9)) : M :=
  inverseMatrix (frameNormalizer target targetIndices) *
    frameNormalizer source sourceIndices

private def sourceFrame : List (Fin 9) := [0, 1, 2, 3]

/-- The frame-normalized candidate matrices from one nine-point set to another. -/
def frameCandidates (source target : List V) : List M :=
  orderedIndexFrames.map fun targetFrame =>
    frameProjectivity source sourceFrame target targetFrame

/-- Candidate matrices whose first source-frame point has a prescribed target orbit label. -/
def frameCandidatesAt (source target : List V) (label : OrbitLabel) : List M :=
  (orderedIndexFramesAt label).map fun targetFrame =>
    frameProjectivity source sourceFrame target targetFrame

/-- Canonical normalization of a nonzero coordinate ray. -/
def normalizeRay (point : V) : V :=
  if point 0 ≠ 0 then (point 0)⁻¹ • point else
  if point 1 ≠ 0 then (point 1)⁻¹ • point else
  if point 2 ≠ 0 then (point 2)⁻¹ • point else 0

/-- Whether a coordinate matrix maps every source ray into the target ray set. -/
def mapsRaysTo (matrix : M) (source target : List V) : Bool :=
  source.all fun p =>
    target.any fun q => normalizeRay (Matrix.mulVec matrix p) = normalizeRay q

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

attribute [reducible] finiteNine fieldElements orbitIndex orbitLabels orderedIndexFramesAt
  orderedIndexFrames framePoint coordinateMatrix
  inverseMatrix diagonalMatrix frameNormalizer frameProjectivity sourceFrame
  frameCandidates frameCandidatesAt normalizeRay mapsRaysTo selectedStabilizers
  uncoveredStabilizers pairStabilizers selectedToUncovered uncoveredToSelected
  selectedStabilizersAt uncoveredStabilizersAt pairStabilizersAt selectedToUncoveredAt
  uncoveredToSelectedAt

/-- The ordered target-frame domain has exactly 3024 elements. -/
theorem ordered_frame_count : orderedIndexFrames.length = 3024 := by decide

/-- Whether a matrix is scalar. -/
def isScalarMatrix (matrix : M) : Bool :=
  fieldElements.any fun scalar => decide (matrix = scalar • (1 : M))

/-- Whether the projective class of a matrix has order dividing three. -/
def projectiveOrderDividesThree (matrix : M) : Bool :=
  isScalarMatrix (matrix ^ 3)

/-- The nine displayed linear lifts of the projective `C₃ × C₃` subgroup. -/
def heisenbergLifts : List M :=
  [(1 : M), g, g ^ 2, h, g * h, g ^ 2 * h, h ^ 2, g * h ^ 2, g ^ 2 * h ^ 2]

/-- Whether two nonzero matrices represent the same projective transformation. -/
def projectivelyEquivalentMatrices (left right : M) : Bool :=
  fieldElements.any fun scalar => scalar ≠ 0 && decide (left = scalar • right)

/-- Whether two lists contain the same projective matrix classes. -/
def sameProjectiveMatrices (left right : List M) : Bool :=
  left.all (fun matrix =>
    right.any fun other => projectivelyEquivalentMatrices matrix other) &&
  right.all (fun matrix =>
    left.any fun other => projectivelyEquivalentMatrices matrix other)

/--
The complete transporter profile for one possible label of the first frame image: one
nonsingular stabilizer of each orbit and the ordered pair, no orbit interchange, projective
order dividing three, and membership in the displayed Heisenberg subgroup.
-/
def stabilizerLabelProfile (label : OrbitLabel) : Bool :=
  (selectedStabilizersAt label).length == 1 &&
  (uncoveredStabilizersAt label).length == 1 &&
  (pairStabilizersAt label).length == 1 &&
  selectedToUncoveredAt label == [] &&
  uncoveredToSelectedAt label == [] &&
  (selectedStabilizersAt label).all (fun matrix =>
    decide (Matrix.det matrix ≠ 0) &&
    projectiveOrderDividesThree matrix &&
    heisenbergLifts.any fun lift => projectivelyEquivalentMatrices matrix lift) &&
  (uncoveredStabilizersAt label).all (fun matrix =>
    decide (Matrix.det matrix ≠ 0) &&
    heisenbergLifts.any fun lift => projectivelyEquivalentMatrices matrix lift) &&
  (pairStabilizersAt label).all (fun matrix =>
    decide (Matrix.det matrix ≠ 0) &&
    heisenbergLifts.any fun lift => projectivelyEquivalentMatrices matrix lift)

end NinePointHeisenbergStabilizer
end RelativeConicArcs
