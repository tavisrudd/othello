import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Signed rows as a Gale kernel

Let `A` be a matrix whose columns are homogeneous coordinates of a finite labelled
configuration.  A weight vector `ε` rescales every column, so row `i` becomes
`j ↦ A i j * ε j`.  If every rescaled row is annihilated by `A`, then their span lies in
the relation space `ker (Matrix.toLin' A)`.  Equality follows as soon as these two
subspaces have the same dimension.

This is the linear-algebra mechanism used in a self-association argument: the rescaled
rows give the labelled Gale transform.  The results below do not prove the geometric
input that supplies the weighted orthogonality or dimension equality.  They also make
no claim about reducedness, coordinate rings, Gorenstein duality, or inverse systems.
All proofs are kernel checked and use no finite certificate.
-/

namespace RelativeConicArcs
namespace SignedGaleDuality

open scoped Matrix

variable {K ι κ : Type*} [Field K] [Fintype κ] [DecidableEq κ]

/-- Row `i` after multiplying column `j` by the weight `ε j`. -/
def signedRow (A : Matrix ι κ K) (ε : κ → K) (i : ι) : κ → K :=
  fun j => A i j * ε j

/-- The matrix obtained by multiplying column `j` of `A` by `ε j`. -/
def signedMatrix (A : Matrix ι κ K) (ε : κ → K) : Matrix ι κ K :=
  fun i => signedRow A ε i

/-- The span of the signed rows of `A`. -/
def signedRowSpace (A : Matrix ι κ K) (ε : κ → K) : Submodule K (κ → K) :=
  Submodule.span K (Set.range (signedRow A ε))

/-- Weighted row orthogonality says that every signed row is a linear relation among
the columns of `A`. -/
def WeightedRowOrthogonal (A : Matrix ι κ K) (ε : κ → K) : Prop :=
  ∀ i r, ∑ j, A r j * (A i j * ε j) = 0

omit [DecidableEq κ] in
/-- Weighted row orthogonality is exactly the matrix identity
`A * (signedMatrix A ε)ᵀ = 0`, equivalently `A D Aᵀ = 0` when column
scaling is written with the diagonal matrix `D`. -/
theorem weightedRowOrthogonal_iff_mul_transpose_eq_zero
    {A : Matrix ι κ K} {ε : κ → K} :
    WeightedRowOrthogonal A ε ↔ A * (signedMatrix A ε)ᵀ = 0 := by
  constructor
  · intro h
    ext r i
    simpa [Matrix.mul_apply, signedMatrix, signedRow] using h i r
  · intro h i r
    have hri := congrArg (fun M : Matrix ι ι K => M r i) h
    simpa [Matrix.mul_apply, signedMatrix, signedRow] using hri

/-- Each signed row belongs to the kernel of the column-evaluation map. -/
theorem signedRow_mem_ker {A : Matrix ι κ K} {ε : κ → K}
    (horth : WeightedRowOrthogonal A ε) (i : ι) :
    signedRow A ε i ∈ LinearMap.ker (Matrix.toLin' A) := by
  rw [LinearMap.mem_ker, Matrix.toLin'_apply]
  ext r
  simpa [Matrix.mulVec, dotProduct, signedRow] using horth i r

/-- Weighted row orthogonality places the whole signed row space in the relation
space of the columns. -/
theorem signedRowSpace_le_ker {A : Matrix ι κ K} {ε : κ → K}
    (horth : WeightedRowOrthogonal A ε) :
    signedRowSpace A ε ≤ LinearMap.ker (Matrix.toLin' A) := by
  rw [signedRowSpace, Submodule.span_le]
  rintro _ ⟨i, rfl⟩
  exact signedRow_mem_ker horth i

/-- If the signed-row span and the relation space have equal dimension, weighted
orthogonality identifies them.  Thus the signed rows are a labelled Gale transform. -/
theorem signedRowSpace_eq_ker_of_finrank_eq {A : Matrix ι κ K} {ε : κ → K}
    (horth : WeightedRowOrthogonal A ε)
    (hdim :
      Module.finrank K (signedRowSpace A ε) =
        Module.finrank K (LinearMap.ker (Matrix.toLin' A))) :
    signedRowSpace A ε = LinearMap.ker (Matrix.toLin' A) :=
  Submodule.eq_of_le_of_finrank_eq (signedRowSpace_le_ker horth) hdim

/-- For `2q` columns and `q` independent signed rows, full row rank turns weighted
orthogonality into Gale self-duality.  The hypotheses separate the two rank inputs:
`hind` controls the signed-row span, while `hsurj` says that `A` has full row rank. -/
theorem signedRowSpace_eq_ker_of_card_eq_twice
    [Fintype ι] [DecidableEq ι] {A : Matrix ι κ K} {ε : κ → K}
    (horth : WeightedRowOrthogonal A ε)
    (hind : LinearIndependent K (signedRow A ε))
    (hsurj : Function.Surjective (Matrix.toLin' A))
    (hcard : Fintype.card κ = 2 * Fintype.card ι) :
    signedRowSpace A ε = LinearMap.ker (Matrix.toLin' A) := by
  apply signedRowSpace_eq_ker_of_finrank_eq horth
  rw [signedRowSpace, finrank_span_eq_card hind]
  have hrange :
      Module.finrank K (LinearMap.range (Matrix.toLin' A)) = Fintype.card ι := by
    rw [LinearMap.range_eq_top.mpr hsurj, Submodule.topEquiv.finrank_eq, Module.finrank_pi K]
  have hrankNullity := (Matrix.toLin' A).finrank_range_add_finrank_ker
  rw [hrange, Module.finrank_pi K, hcard] at hrankNullity
  omega

/-- Matrix form of signed Gale-kernel duality.  For a full-row-rank matrix
with twice as many columns as rows, the identity `A * (signedMatrix A ε)ᵀ = 0`
identifies the signed-row span with the complete relation space whenever the
signed rows are independent. -/
theorem signedRowSpace_eq_ker_of_mul_transpose_eq_zero
    [Fintype ι] [DecidableEq ι] {A : Matrix ι κ K} {ε : κ → K}
    (hzero : A * (signedMatrix A ε)ᵀ = 0)
    (hind : LinearIndependent K (signedRow A ε))
    (hsurj : Function.Surjective (Matrix.toLin' A))
    (hcard : Fintype.card κ = 2 * Fintype.card ι) :
    signedRowSpace A ε = LinearMap.ker (Matrix.toLin' A) :=
  signedRowSpace_eq_ker_of_card_eq_twice
    (weightedRowOrthogonal_iff_mul_transpose_eq_zero.mpr hzero) hind hsurj hcard

end SignedGaleDuality
end RelativeConicArcs
