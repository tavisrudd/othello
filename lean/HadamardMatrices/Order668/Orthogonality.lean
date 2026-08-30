/-
# A Hadamard matrix of order 668

Let `H` be the bordered Goethals–Seidel array of
`HadamardMatrices.BorderedGoethalsSeidel` built over `ZMod 166` from the four
`±1` sequences `A`, `B`, `C`, `D` of `HadamardMatrices.Order668.Sequences`, with
inner shift `2`.  Its index set `Fin 4 ⊕ Fin 4 × ZMod 166` has 668 elements:
four border indices, then four slabs of 166 offsets.

This file assembles the terminal statement `matrixOrder668_mul_transpose`:

```
  H Hᵀ = 668 • 1,
```

together with `matrixOrder668_entry_sq`, which says every entry of `H` is `1` or
`-1`, and `card_arrayIndex_order668`, which says the index set has 668 elements.  The
three together say that `H` is a Hadamard matrix of order 668.  The final
statement `reindex_mul_transpose` transports the identity along any bijection of
the index set with `Fin 668`, so it holds for the matrix in any row and column
ordering.

The general orthogonality criterion is proved by ordinary algebra; the two
hypotheses it needs about the sequences — the `±1` values and the row sums in
`HadamardMatrices.Order668.Sequences`, and the autocorrelation identity in
`HadamardMatrices.Order668.Correlations` — are exhaustive finite checks over
`ZMod 166` discharged by kernel reduction.  There is no native evaluation, no
imported certificate and no axiom beyond Lean's own.
-/
import HadamardMatrices.Order668.Correlations

namespace HadamardMatrices
namespace Order668

open Matrix

/-- The bordered Goethals–Seidel array of order 668 over the four sequences of
length 166, with inner shift `2`. -/
def matrixOrder668 : Matrix (ArrayIndex 166) (ArrayIndex 166) ℤ :=
  borderedArray sequenceA sequenceB sequenceC sequenceD 2

/-- The index set of the array has 668 elements. -/
theorem card_arrayIndex_order668 : Fintype.card (ArrayIndex 166) = 668 := by
  have := card_arrayIndex (m := 166)
  omega

/-- Every entry of the array is `1` or `-1`. -/
theorem matrixOrder668_entry_sq (p q : ArrayIndex 166) :
    matrixOrder668 p q * matrixOrder668 p q = 1 :=
  borderedEntry_sq sequenceA sequenceB sequenceC sequenceD 2
    sequenceA_sq sequenceB_sq sequenceC_sq sequenceD_sq p q

/-- The array is orthogonal: `H Hᵀ = 668 • 1`.  With
`matrixOrder668_entry_sq` and `card_arrayIndex_order668` this says that
`matrixOrder668` is a Hadamard matrix of order 668. -/
theorem matrixOrder668_mul_transpose :
    matrixOrder668 * matrixOrder668ᵀ
      = (668 : ℤ) • (1 : Matrix (ArrayIndex 166) (ArrayIndex 166) ℤ) := by
  have h := borderedArray_mul_transpose (m := 166) sequenceA sequenceB sequenceC sequenceD 2
    sequenceA_sq sequenceB_sq sequenceC_sq sequenceD_sq
    sequenceA_sum sequenceB_sum sequenceC_sum sequenceD_sum pafSum_eq_neg_four
  rw [matrixOrder668, h]
  norm_num

/-- The same identity for the matrix written over `Fin 668`, in any ordering of
the index set. -/
theorem reindex_mul_transpose (σ : ArrayIndex 166 ≃ Fin 668) :
    Matrix.reindex σ σ matrixOrder668 * (Matrix.reindex σ σ matrixOrder668)ᵀ
      = (668 : ℤ) • (1 : Matrix (Fin 668) (Fin 668) ℤ) := by
  have hre : Matrix.reindex σ σ matrixOrder668
      = matrixOrder668.submatrix σ.symm σ.symm := rfl
  rw [hre, Matrix.transpose_submatrix, Matrix.submatrix_mul_equiv,
    matrixOrder668_mul_transpose]
  ext p q
  simp only [Matrix.submatrix_apply, Matrix.smul_apply, smul_eq_mul, Matrix.one_apply,
    mul_ite, mul_one, mul_zero, EmbeddingLike.apply_eq_iff_eq]

end Order668
end HadamardMatrices
