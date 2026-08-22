import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.Data.Matrix.Block
import Mathlib.Tactic.LinearCombination

/-!
# The rank condition behind the Eckardt criterion

Let a cubic form on a five-dimensional vector space be written, in coordinates
adapted to a point of the hypersurface it defines, as `x₀²L + x₀Q + C` with `L`
linear, `Q` quadratic and `C` cubic in the remaining coordinates.  The Hessian
of the form at that point is the symmetric matrix of the quadric `4x₀L + 2Q`.
Its shape is a bordered one: the entry in the distinguished coordinate is zero,
the border is the coefficient vector of `L`, and the remaining block is the
matrix of `Q`.  The criterion the manuscript uses is that this matrix has rank
at most two exactly when `Q` is a multiple of `L`.

This module proves that equivalence as a statement about matrices.  For a
nonzero border vector `v` and a symmetric block `S` over a field in which two
is invertible, the bordered matrix has rank at most two if and only if `S` is
the symmetrized outer product of `v` with some vector, which is the matrix form
of divisibility of the quadratic form by the linear one.

Nothing projective is constructed: there is no cubic form, no hypersurface, no
tangent hyperplane section, no cone, and no Eckardt point here, and the passage
from a point of a smooth cubic threefold to this normal form is not carried
out.  All proofs are symbolic and kernel checked, with no external computation
or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

open scoped Matrix

variable {K Index : Type*} [Field K] [Fintype Index] [DecidableEq Index]

/-- The bordered symmetric matrix attached to a border vector `v` and a
symmetric block `S`: the distinguished diagonal entry is zero, the
distinguished row and column carry `v`, and the remaining block is `S`. -/
def borderedMatrix (v : Index → K) (block : Matrix Index Index K) :
    Matrix (Unit ⊕ Index) (Unit ⊕ Index) K :=
  Matrix.fromBlocks 0 (Matrix.of fun (_ : Unit) (column : Index) => v column)
    (Matrix.of fun (row : Index) (_ : Unit) => v row) block

/-- The symmetrized outer product of two vectors, the matrix form of the
quadratic form `2 · (v ⬝ x)(w ⬝ x)`. -/
def symmetrizedOuterProduct (v w : Index → K) : Matrix Index Index K :=
  Matrix.vecMulVec v w + Matrix.vecMulVec w v

omit [Fintype Index] [DecidableEq Index] in
/-- The entries of a symmetrized outer product. -/
@[simp]
theorem symmetrizedOuterProduct_apply (v w : Index → K) (row column : Index) :
    symmetrizedOuterProduct v w row column = v row * w column + w row * v column := rfl

omit [DecidableEq Index] in
/-- Multiplying a vector by the bordered matrix: the distinguished coordinate of
the result is the pairing of the border with the block part of the argument, and
its block part is the distinguished coordinate of the argument times the border
plus the block acting on the block part. -/
theorem borderedMatrix_mulVec (v : Index → K) (block : Matrix Index Index K)
    (scalarPart : Unit → K) (blockPart : Index → K) :
    (borderedMatrix v block).mulVec (Sum.elim scalarPart blockPart) =
      Sum.elim (fun _ => v ⬝ᵥ blockPart)
        (fun row => scalarPart () * v row + block.mulVec blockPart row) := by
  classical
  rw [borderedMatrix, Matrix.fromBlocks_mulVec]
  funext index
  cases index with
  | inl _ => simp [Matrix.mulVec, dotProduct]
  | inr row => simp [Matrix.mulVec, dotProduct, mul_comm]

omit [DecidableEq Index] in
/-- The action of a symmetrized outer product on a vector. -/
theorem symmetrizedOuterProduct_mulVec (v w argument : Index → K) :
    (symmetrizedOuterProduct v w).mulVec argument =
      (w ⬝ᵥ argument) • v + (v ⬝ᵥ argument) • w := by
  funext row
  simp only [symmetrizedOuterProduct, Matrix.mulVec, Matrix.add_apply, Matrix.vecMulVec_apply,
    dotProduct, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  have expand : ∀ column : Index, (v row * w column + w row * v column) * argument column =
      v row * (w column * argument column) + w row * (v column * argument column) :=
    fun column => by ring
  rw [Finset.sum_congr rfl fun column _ => expand column, Finset.sum_add_distrib,
    ← Finset.mul_sum, ← Finset.mul_sum]
  ring

omit [DecidableEq Index] in
/-- Sufficiency in the rank criterion: if the block is a symmetrized outer
product with the border, the bordered matrix has rank at most two, because every
value of the associated map lies in the span of two fixed vectors. -/
theorem borderedMatrix_rank_le_two (v w : Index → K) :
    (borderedMatrix v (symmetrizedOuterProduct v w)).rank ≤ 2 := by
  classical
  set unitVector : Unit ⊕ Index → K := Sum.elim (fun _ => (1 : K)) w with unitVector_def
  set borderVector : Unit ⊕ Index → K := Sum.elim (fun _ => (0 : K)) v with borderVector_def
  have range_le :
      LinearMap.range (borderedMatrix v (symmetrizedOuterProduct v w)).mulVecLin ≤
        Submodule.span K ({unitVector, borderVector} : Set (Unit ⊕ Index → K)) := by
    rintro target ⟨argument, rfl⟩
    have decomposition : argument = Sum.elim (fun place => argument (Sum.inl place))
        (fun index => argument (Sum.inr index)) := by
      funext index; cases index <;> rfl
    rw [Matrix.mulVecLin_apply, decomposition, borderedMatrix_mulVec,
      symmetrizedOuterProduct_mulVec]
    refine Submodule.mem_span_pair.2
      ⟨v ⬝ᵥ fun index => argument (Sum.inr index),
        argument (Sum.inl ()) + w ⬝ᵥ fun index => argument (Sum.inr index), ?_⟩
    funext index
    cases index with
    | inl _ => simp [unitVector_def, borderVector_def]
    | inr row =>
        simp only [unitVector_def, borderVector_def, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
          Sum.elim_inr]
        ring
  calc (borderedMatrix v (symmetrizedOuterProduct v w)).rank
      ≤ Module.finrank K
        (Submodule.span K ({unitVector, borderVector} : Set (Unit ⊕ Index → K))) :=
        Submodule.finrank_mono range_le
    _ ≤ 2 := by
        classical
        refine (finrank_span_le_card
          ({unitVector, borderVector} : Set (Unit ⊕ Index → K))).trans ?_
        simp only [Set.toFinset_insert, Set.toFinset_singleton]
        exact (Finset.card_insert_le _ _).trans (by simp)

/-- A vector paired to one by a nonzero covector: the coordinate direction in
which the covector does not vanish, rescaled. -/
theorem exists_dotProduct_eq_one {v : Index → K} (nonzero : v ≠ 0) :
    ∃ complement : Index → K, v ⬝ᵥ complement = 1 := by
  classical
  obtain ⟨index, entry_ne⟩ := Function.ne_iff.1 nonzero
  refine ⟨Pi.single index (v index)⁻¹, ?_⟩
  rw [dotProduct_single]
  exact mul_inv_cancel₀ (by simpa using entry_ne)

/-- Under the rank bound, the block carries the hyperplane annihilated by the
border into the line spanned by the border.  Otherwise the images of three
explicit vectors — the one paired to one with the border, the distinguished
coordinate direction, and the given annihilated vector — would be independent,
forcing rank at least three. -/
theorem block_mulVec_mem_span_of_rank_le_two
    {v : Index → K} {block : Matrix Index Index K} (nonzeroBorder : v ≠ 0)
    (rankBound : (borderedMatrix v block).rank ≤ 2)
    {annihilated : Index → K} (annihilates : v ⬝ᵥ annihilated = 0) :
    block.mulVec annihilated ∈ Submodule.span K {v} := by
  classical
  by_contra outside
  obtain ⟨complement, pairing⟩ := exists_dotProduct_eq_one nonzeroBorder
  set matrix := borderedMatrix v block with matrix_def
  set imageComplement : Unit ⊕ Index → K :=
    Sum.elim (fun _ => (1 : K)) (block.mulVec complement) with imageComplement_def
  set imageDistinguished : Unit ⊕ Index → K := Sum.elim (fun _ => (0 : K)) v with
    imageDistinguished_def
  set imageAnnihilated : Unit ⊕ Index → K :=
    Sum.elim (fun _ => (0 : K)) (block.mulVec annihilated) with imageAnnihilated_def
  have memComplement : imageComplement ∈ LinearMap.range matrix.mulVecLin := by
    refine ⟨Sum.elim (fun _ => (0 : K)) complement, ?_⟩
    rw [Matrix.mulVecLin_apply, matrix_def, borderedMatrix_mulVec, imageComplement_def, pairing]
    funext index
    cases index <;> simp
  have memDistinguished : imageDistinguished ∈ LinearMap.range matrix.mulVecLin := by
    refine ⟨Sum.elim (fun _ => (1 : K)) 0, ?_⟩
    rw [Matrix.mulVecLin_apply, matrix_def, borderedMatrix_mulVec, imageDistinguished_def]
    funext index
    cases index <;> simp
  have memAnnihilated : imageAnnihilated ∈ LinearMap.range matrix.mulVecLin := by
    refine ⟨Sum.elim (fun _ => (0 : K)) annihilated, ?_⟩
    rw [Matrix.mulVecLin_apply, matrix_def, borderedMatrix_mulVec, imageAnnihilated_def,
      annihilates]
    funext index
    cases index <;> simp
  have ambientIndependent :
      LinearIndependent K ![imageComplement, imageDistinguished, imageAnnihilated] := by
    rw [Fintype.linearIndependent_iff]
    intro coefficient vanishing
    have distinguishedCoordinate : coefficient 0 = 0 := by
      have := congrFun vanishing (Sum.inl ())
      simpa [Fin.sum_univ_three, imageComplement_def, imageDistinguished_def,
        imageAnnihilated_def] using this
    have blockCoordinate : coefficient 1 • v + coefficient 2 • block.mulVec annihilated = 0 := by
      funext row
      have := congrFun vanishing (Sum.inr row)
      simpa [Fin.sum_univ_three, imageComplement_def, imageDistinguished_def,
        imageAnnihilated_def, distinguishedCoordinate] using this
    have annihilatedCoefficient : coefficient 2 = 0 := by
      by_contra nonzeroCoefficient
      refine outside ?_
      have scaled : coefficient 2 • block.mulVec annihilated = (-(coefficient 1)) • v := by
        funext row
        have entry := congrFun blockCoordinate row
        simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul, Pi.zero_apply] at entry
        simp only [Pi.smul_apply, smul_eq_mul, neg_mul]
        linear_combination entry
      have final : block.mulVec annihilated = ((coefficient 2)⁻¹ * -(coefficient 1)) • v := by
        rw [mul_smul, ← scaled, inv_smul_smul₀ nonzeroCoefficient]
      rw [final]
      exact Submodule.smul_mem _ _ (Submodule.mem_span_singleton_self v)
    have borderCoefficient : coefficient 1 = 0 := by
      have : coefficient 1 • v = 0 := by
        simpa [annihilatedCoefficient] using blockCoordinate
      rcases smul_eq_zero.1 this with scalarZero | vectorZero
      · exact scalarZero
      · exact absurd vectorZero nonzeroBorder
    intro position
    fin_cases position
    · exact distinguishedCoordinate
    · exact borderCoefficient
    · exact annihilatedCoefficient
  have rangeIndependent :
      LinearIndependent K
        (![⟨imageComplement, memComplement⟩, ⟨imageDistinguished, memDistinguished⟩,
          ⟨imageAnnihilated, memAnnihilated⟩] :
          Fin 3 → LinearMap.range matrix.mulVecLin) := by
    refine LinearIndependent.of_comp (Submodule.subtype _) ?_
    convert ambientIndependent using 1
    funext position
    fin_cases position <;> rfl
  have threeLe : 3 ≤ matrix.rank := by
    simpa [Matrix.rank] using rangeIndependent.fintype_card_le_finrank
  omega

/-- Necessity in the rank criterion: a bordered matrix with nonzero border and
symmetric block whose rank is at most two has a block that is the symmetrized
outer product of the border with a single vector.  Two must be invertible: the
vector is corrected by half of the value of the block on the vector paired to
one with the border. -/
theorem exists_symmetrizedOuterProduct_of_rank_le_two
    {v : Index → K} {block : Matrix Index Index K} (nonzeroBorder : v ≠ 0)
    (symmetric : block.IsSymm) (twoNeZero : (2 : K) ≠ 0)
    (rankBound : (borderedMatrix v block).rank ≤ 2) :
    ∃ w, block = symmetrizedOuterProduct v w := by
  classical
  obtain ⟨complement, pairing⟩ := exists_dotProduct_eq_one nonzeroBorder
  set diagonalValue := complement ⬝ᵥ block.mulVec complement with diagonalValue_def
  refine ⟨block.mulVec complement - (diagonalValue / 2) • v, ?_⟩
  have transposeAction : ∀ vector : Index → K,
      complement ⬝ᵥ block.mulVec vector = (block.mulVec complement) ⬝ᵥ vector := by
    intro vector
    rw [Matrix.dotProduct_mulVec, ← Matrix.mulVec_transpose, symmetric.eq]
  have key : ∀ vector : Index → K, block.mulVec vector =
      ((block.mulVec complement - (diagonalValue / 2) • v) ⬝ᵥ vector) • v +
        (v ⬝ᵥ vector) • (block.mulVec complement - (diagonalValue / 2) • v) := by
    intro vector
    have annihilates : v ⬝ᵥ (vector - (v ⬝ᵥ vector) • complement) = 0 := by
      rw [dotProduct_sub, dotProduct_smul, pairing]
      simp
    obtain ⟨scalar, expansion⟩ :=
      Submodule.mem_span_singleton.1
        (block_mulVec_mem_span_of_rank_le_two nonzeroBorder rankBound annihilates)
    have decomposition : block.mulVec vector =
        scalar • v + (v ⬝ᵥ vector) • block.mulVec complement := by
      have := congrArg (fun image => image + (v ⬝ᵥ vector) • block.mulVec complement) expansion
      simpa [Matrix.mulVec_sub, Matrix.mulVec_smul, sub_add_cancel] using this.symm
    have scalarValue : scalar = (block.mulVec complement) ⬝ᵥ vector -
        (v ⬝ᵥ vector) * diagonalValue := by
      have paired := congrArg (fun image => complement ⬝ᵥ image) decomposition
      simp only [dotProduct_add, dotProduct_smul, smul_eq_mul] at paired
      rw [transposeAction vector, dotProduct_comm complement v, pairing] at paired
      rw [← diagonalValue_def] at paired
      linear_combination -paired
    rw [decomposition, scalarValue]
    funext row
    simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul, sub_dotProduct,
      smul_dotProduct]
    field_simp
    ring
  refine Matrix.ext_iff_mulVec.2 fun vector => ?_
  rw [key vector, symmetrizedOuterProduct_mulVec]

/-- The rank criterion.  For a nonzero border and a symmetric block over a field
in which two is invertible, the bordered matrix has rank at most two exactly
when the block is the symmetrized outer product of the border with some vector.
In the geometric reading: the Hessian of the cubic form at the point has rank at
most two exactly when the quadratic part is divisible by the linear part. -/
theorem borderedMatrix_rank_le_two_iff
    {v : Index → K} {block : Matrix Index Index K} (nonzeroBorder : v ≠ 0)
    (symmetric : block.IsSymm) (twoNeZero : (2 : K) ≠ 0) :
    (borderedMatrix v block).rank ≤ 2 ↔ ∃ w, block = symmetrizedOuterProduct v w := by
  refine ⟨exists_symmetrizedOuterProduct_of_rank_le_two nonzeroBorder symmetric twoNeZero, ?_⟩
  rintro ⟨w, rfl⟩
  exact borderedMatrix_rank_le_two v w

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
