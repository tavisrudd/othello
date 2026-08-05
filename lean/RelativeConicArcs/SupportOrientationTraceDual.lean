import RelativeConicArcs.SupportOrientationDeterminant
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.LinearAlgebra.BilinearForm.Orthogonal
import Mathlib.Data.Matrix.Basis

/-!
# Cross-golden trace duality

For a golden root `t`, the displayed six-by-three matrices span the two
conjugate eigenspaces of the signed orbital operator.  Compressing a diagonal
operator between them gives the cross-golden block.  Orthogonality makes the
block translation invariant, and its three-by-three determinant is the
negative support cubic.

The trace pairing on three-by-three matrices is perfect, so the five-dimensional
cross-golden image has a four-dimensional trace annihilator; both dimensions are
recorded here.  The singular locus of the resulting determinantal cubic
threefold is not treated in this module: it is classified, from the determinant
identity proved below, in `RelativeConicArcs.SupportOrientationNodes`.

Every declaration in this module is proved from the definitions; nothing is
assumed.
-/

namespace RelativeConicArcs.SupportOrientationTraceDual

open Matrix
open scoped Matrix
open ClebschGoldenConference
open SupportOrientationPentagon
open SupportOrientationHolonomy

/-- The six-by-three golden eigenspace basis written out in the displayed axis order and
switching gauge fixed below. -/
def displayedGoldenEigenspaceBasis {R : Type*} [CommRing R] (t : R) :
    Matrix (Fin 6) (Fin 3) R :=
  !![t, t, -1;
     t, 1, -t;
     1, t, -t;
     1, 0, 0;
     0, 1, 0;
     0, 0, 1]

/-- The permutation carrying the displayed axis order to this development's conference-row
order. -/
def displayedAxisOrder : Fin 6 ≃ Fin 6 where
  toFun := ![0, 1, 4, 5, 3, 2]
  invFun := ![0, 1, 5, 4, 2, 3]
  left_inv := by decide
  right_inv := by decide

/-- The switching signs accompanying that row-order transport. -/
def displayedAxisSign : Fin 6 → ℤ := ![1, 1, -1, -1, 1, 1]

/-- The conference matrix in the displayed axis order and switching gauge, that is, the gauge in
which the golden eigenspace basis takes the form written out above. -/
def displayedConferenceMatrix : Matrix (Fin 6) (Fin 6) ℤ :=
  !![0, 1, 1, 1, 1, 1;
     1, 0, 1, 1, -1, -1;
     1, 1, 0, -1, 1, -1;
     1, 1, -1, 0, -1, 1;
     1, -1, 1, -1, 0, 1;
     1, -1, -1, 1, 1, 0]

/-- Exact permutation/switching bridge between the two conference gauges. -/
theorem displayedConferenceMatrix_eq_transport (i j : Fin 6) :
    displayedConferenceMatrix i j = displayedAxisSign i *
      conferenceMatrix (displayedAxisOrder i) (displayedAxisOrder j) * displayedAxisSign j := by
  fin_cases i <;> fin_cases j <;> decide

/-- The displayed basis transported to the row order and switching gauge of
`conferenceMatrix`. -/
def goldenEigenspaceBasis {R : Type*} [CommRing R] (t : R) :
    Matrix (Fin 6) (Fin 3) R :=
  !![t, t, -1;
     t, 1, -t;
     0, 0, 1;
     0, 1, 0;
     -1, -t, t;
     -1, 0, 0]

/-- Exact row-permutation and switching bridge from the displayed gauge to this development's
conference gauge. -/
theorem goldenEigenspaceBasis_eq_displayed_transport
    {R : Type*} [CommRing R] (t : R) (i : Fin 6) (j : Fin 3) :
    goldenEigenspaceBasis t (displayedAxisOrder i) j =
      (displayedAxisSign i : R) * displayedGoldenEigenspaceBasis t i j := by
  fin_cases i <;> fin_cases j <;>
    simp [goldenEigenspaceBasis, displayedGoldenEigenspaceBasis,
      displayedAxisOrder, displayedAxisSign]

/-- The displayed columns are eigenvectors of the signed orbital matrix. -/
theorem goldenEigenspaceBasis_eigen {R : Type*} [CommRing R]
    (t : R) (ht : t ^ 2 = t + 1) :
    conferenceMatrixOver R * goldenEigenspaceBasis t =
      (2 * t - 1) • goldenEigenspaceBasis t := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [conferenceMatrixOver, conferenceMatrix, goldenEigenspaceBasis,
      Matrix.mul_apply, Fin.sum_univ_succ] <;> ring_nf
  all_goals rw [ht]; ring

/-- The conjugate displayed golden eigenspaces are orthogonal. -/
theorem conjugateGoldenBases_orthogonal {R : Type*} [CommRing R]
    (t : R) (ht : t ^ 2 = t + 1) :
    (goldenEigenspaceBasis (1 - t)).transpose * goldenEigenspaceBasis t = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [goldenEigenspaceBasis, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring_nf
  all_goals rw [ht]; ring

/-- Compression of a diagonal operator from one golden eigenspace to its
conjugate. -/
def crossGoldenBlock {R : Type*} [CommRing R] (t : R) (x : Fin 6 → R) :
    Matrix (Fin 3) (Fin 3) R :=
  (goldenEigenspaceBasis (1 - t)).transpose * Matrix.diagonal x *
    goldenEigenspaceBasis t

/-- The cross-golden compression as a linear map in the diagonal variables. -/
def crossGoldenMap {R : Type*} [CommRing R] (t : R) :
    (Fin 6 → R) →ₗ[R] Matrix (Fin 3) (Fin 3) R where
  toFun := crossGoldenBlock t
  map_add' x y := by
    ext i j
    simp [crossGoldenBlock, Matrix.mul_apply, Matrix.diagonal_apply,
      Fin.sum_univ_succ]
    ring
  map_smul' a x := by
    ext i j
    simp [crossGoldenBlock, Matrix.mul_apply, Matrix.diagonal_apply,
      Fin.sum_univ_succ]
    ring

/-- Cross-golden compression kills the all-ones direction. -/
theorem crossGoldenBlock_translation_invariant
    {R : Type*} [CommRing R] (t : R) (ht : t ^ 2 = t + 1)
    (x : Fin 6 → R) (u : R) :
    crossGoldenBlock t (fun i => x i + u) = crossGoldenBlock t x := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
      Matrix.diagonal_apply, Fin.sum_univ_succ] <;> ring_nf
  all_goals rw [ht]; ring

/-- The kernel of cross-golden compression is exactly the all-ones line. -/
theorem crossGoldenMap_mem_ker_iff_constant
    {K : Type*} [Field K] [CharZero K] (t : K) (ht : t ^ 2 = t + 1)
    (x : Fin 6 → K) :
    x ∈ LinearMap.ker (crossGoldenMap t) ↔
      ∃ u : K, x = fun _ => u := by
  have ht0 : t ≠ 0 := by
    intro h
    rw [h] at ht
    norm_num at ht
  have ht2 : 2 - t ≠ 0 := by
    intro h
    have hteq : t = 2 := (sub_eq_zero.mp h).symm
    rw [hteq] at ht
    norm_num at ht
  constructor
  · intro hx
    change crossGoldenBlock t x = 0 at hx
    let y : Fin 6 → K := fun i => x i - x 5
    have hy : crossGoldenBlock t y = 0 := by
      calc
        crossGoldenBlock t y =
            crossGoldenBlock t (fun i => x i + (-x 5)) := by
              congr 2
              funext i
              simp [y, sub_eq_add_neg]
        _ = crossGoldenBlock t x :=
          crossGoldenBlock_translation_invariant t ht x (-x 5)
        _ = 0 := hx
    have h00 := congrArg (fun M : Matrix (Fin 3) (Fin 3) K => M 0 0) hy
    have h01 := congrArg (fun M : Matrix (Fin 3) (Fin 3) K => M 0 1) hy
    have h02 := congrArg (fun M : Matrix (Fin 3) (Fin 3) K => M 0 2) hy
    have h11 := congrArg (fun M : Matrix (Fin 3) (Fin 3) K => M 1 1) hy
    have h22 := congrArg (fun M : Matrix (Fin 3) (Fin 3) K => M 2 2) hy
    simp only [Matrix.zero_apply] at h00 h01 h02 h11 h22
    have hy5 : y 5 = 0 := by simp [y]
    have e00 : -y 0 - y 1 + y 4 = 0 := by
      simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
        Matrix.diagonal_apply, Fin.sum_univ_succ] at h00
      linear_combination h00 + (y 0 + y 1) * ht - hy5
    have e01 : -y 0 + (1 - t) * y 1 + t * y 4 = 0 := by
      simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
        Matrix.diagonal_apply, Fin.sum_univ_succ] at h01
      linear_combination h01 + y 0 * ht
    have e02 : (t - 1) * y 0 + y 1 - t * y 4 = 0 := by
      simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
        Matrix.diagonal_apply, Fin.sum_univ_succ] at h02
      linear_combination h02 - y 1 * ht
    have e11 : -y 0 + y 1 + y 3 - y 4 = 0 := by
      simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
        Matrix.diagonal_apply, Fin.sum_univ_succ] at h11
      linear_combination h11 + (y 0 + y 4) * ht
    have e22 : y 0 - y 1 + y 2 - y 4 = 0 := by
      simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
        Matrix.diagonal_apply, Fin.sum_univ_succ] at h22
      linear_combination h22 + (y 1 + y 4) * ht
    have ey4prod : t * y 4 = 0 := by
      linear_combination e01 - e02 - t * e00
    have ey4 : y 4 = 0 := (mul_eq_zero.mp ey4prod).resolve_left ht0
    have ey1prod : (2 - t) * y 1 = 0 := by
      linear_combination e01 - e00 - (t - 1) * ey4
    have ey1 : y 1 = 0 := (mul_eq_zero.mp ey1prod).resolve_left ht2
    have ey0 : y 0 = 0 := by simpa [ey1, ey4] using e00
    have ey3 : y 3 = 0 := by simpa [ey0, ey1, ey4] using e11
    have ey2 : y 2 = 0 := by simpa [ey0, ey1, ey4] using e22
    refine ⟨x 5, ?_⟩
    funext i
    fin_cases i
    · exact sub_eq_zero.mp (by simpa [y] using ey0)
    · exact sub_eq_zero.mp (by simpa [y] using ey1)
    · exact sub_eq_zero.mp (by simpa [y] using ey2)
    · exact sub_eq_zero.mp (by simpa [y] using ey3)
    · exact sub_eq_zero.mp (by simpa [y] using ey4)
    · rfl
  · rintro ⟨u, rfl⟩
    change crossGoldenBlock t (fun _ => u) = 0
    simpa [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
      Matrix.diagonal_apply, Fin.sum_univ_succ] using
      (crossGoldenBlock_translation_invariant t ht (fun _ => 0) u)

/-- The cross-golden image is the five-dimensional augmentation summand. -/
theorem finrank_crossGoldenMap_range
    {K : Type*} [Field K] [CharZero K] (t : K) (ht : t ^ 2 = t + 1) :
    Module.finrank K (LinearMap.range (crossGoldenMap t)) = 5 := by
  let oneVector : Fin 6 → K := fun _ => 1
  have hone : oneVector ≠ 0 := by
    intro h
    have := congrFun h 0
    norm_num [oneVector] at this
  have hker : LinearMap.ker (crossGoldenMap t) = K ∙ oneVector := by
    ext x
    rw [crossGoldenMap_mem_ker_iff_constant t ht,
      Submodule.mem_span_singleton]
    constructor
    · rintro ⟨u, rfl⟩
      exact ⟨u, by funext i; simp [oneVector]⟩
    · rintro ⟨u, hu⟩
      refine ⟨u, ?_⟩
      rw [← hu]
      funext i
      simp [oneVector]
  have hrank := LinearMap.finrank_range_add_finrank_ker (crossGoldenMap t)
  rw [hker, finrank_span_singleton hone] at hrank
  have hdomain : Module.finrank K (Fin 6 → K) = 6 := by simp
  omega

/-- Invariant trace pairing between the two cross-golden Hom spaces. -/
def tracePairing {K : Type*} [Field K] :
    LinearMap.BilinForm K (Matrix (Fin 3) (Fin 3) K) :=
  LinearMap.mk₂ K (fun A B => Matrix.trace (A * B))
    (by intro A B C; simp [Matrix.add_mul, Matrix.trace_add])
    (by intro a A B; simp [Matrix.trace_smul])
    (by intro A B C; simp [Matrix.mul_add, Matrix.trace_add])
    (by intro a A B; simp [Matrix.trace_smul])

/-- The trace pairing on three-by-three matrices is perfect. -/
theorem tracePairing_nondegenerate
    {K : Type*} [Field K] : (tracePairing (K := K)).Nondegenerate := by
  apply LinearMap.BilinForm.Nondegenerate.ofSeparatingLeft
  intro A hA
  ext i j
  have h := hA (Matrix.single j i (1 : K))
  simpa [tracePairing, Matrix.trace_mul_single] using h

/-- Four-dimensional trace annihilator complementary to the five-dimensional
cross-golden image. -/
def traceAnnihilator {K : Type*} [Field K] (t : K) :
    Submodule K (Matrix (Fin 3) (Fin 3) K) :=
  (tracePairing (K := K)).orthogonal (LinearMap.range (crossGoldenMap t))

/-- Perfectness of the trace pairing makes the annihilator of the
five-dimensional cross-golden image four-dimensional. -/
theorem finrank_traceAnnihilator
    {K : Type*} [Field K] [CharZero K] (t : K) (ht : t ^ 2 = t + 1) :
    Module.finrank K (traceAnnihilator t) = 4 := by
  rw [traceAnnihilator,
    LinearMap.BilinForm.finrank_orthogonal tracePairing_nondegenerate,
    finrank_crossGoldenMap_range t ht]
  rw [Module.finrank_matrix]
  norm_num

/-- The determinant of the cross-golden block is the negative support cubic. -/
theorem det_crossGoldenBlock_eq_neg_supportCubic
    {R : Type*} [CommRing R] (t : R) (ht : t ^ 2 = t + 1)
    (x : Fin 6 → R) :
    Matrix.det (crossGoldenBlock t x) =
      -triangleCubic (conferenceMatrixOver R) x := by
  have ht3 : t ^ 3 = 2 * t + 1 := by
    calc
      t ^ 3 = t * t ^ 2 := by ring
      _ = t * (t + 1) := by rw [ht]
      _ = t ^ 2 + t := by ring
      _ = 2 * t + 1 := by rw [ht]; ring
  have ht4 : t ^ 4 = 3 * t + 2 := by
    calc
      t ^ 4 = t * t ^ 3 := by ring
      _ = t * (2 * t + 1) := by rw [ht3]
      _ = 2 * t ^ 2 + t := by ring
      _ = 3 * t + 2 := by rw [ht]; ring
  have ht5 : t ^ 5 = 5 * t + 3 := by
    calc
      t ^ 5 = t * t ^ 4 := by ring
      _ = t * (3 * t + 2) := by rw [ht4]
      _ = 3 * t ^ 2 + 2 * t := by ring
      _ = 5 * t + 3 := by rw [ht]; ring
  have ht6 : t ^ 6 = 8 * t + 5 := by
    calc
      t ^ 6 = t * t ^ 5 := by ring
      _ = t * (5 * t + 3) := by rw [ht5]
      _ = 5 * t ^ 2 + 3 * t := by ring
      _ = 8 * t + 5 := by rw [ht]; ring
  simp [crossGoldenBlock, goldenEigenspaceBasis, Matrix.mul_apply,
    Matrix.diagonal_apply, Fin.sum_univ_succ, Matrix.det_fin_three,
    triangleCubic, cubicTerm, triangleSign, conferenceMatrixOver,
    conferenceMatrix]
  ring_nf
  rw [ht6, ht5, ht4, ht3, ht]
  ring

#print axioms goldenEigenspaceBasis_eigen
#print axioms goldenEigenspaceBasis_eq_displayed_transport
#print axioms displayedConferenceMatrix_eq_transport
#print axioms conjugateGoldenBases_orthogonal
#print axioms crossGoldenBlock_translation_invariant
#print axioms crossGoldenMap_mem_ker_iff_constant
#print axioms finrank_crossGoldenMap_range
#print axioms tracePairing_nondegenerate
#print axioms finrank_traceAnnihilator
#print axioms det_crossGoldenBlock_eq_neg_supportCubic

end RelativeConicArcs.SupportOrientationTraceDual
