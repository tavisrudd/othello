import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ParameterizedRankTwoResidue

/-!
# Four-dimensional counting matrices

The six-parameter matrix with diagonal `(a,b,b,a)`, subdiagonal entries one,
and upper entries `(c,d,c)`, `(e,e)`, and `f` admits a cyclic basis beginning
at the first standard vector. Its determinant in this basis is one over any
commutative ring. The characteristic polynomial is computed symbolically over
an infinite field. The statements concern the displayed matrices and do not
identify their coefficients with enumerative invariants.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The six-parameter symmetric upper-Hessenberg counting matrix. -/
def fourDimensionalCountingMatrix {K : Type*} [CommRing K] (a b c d e f : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![a,c,e,f; 1,b,d,e; 0,1,b,c; 0,0,1,a]

/-- The matrix with columns `v,Uv,U²v,U³v` for the first standard vector `v`. -/
def countingMatrixCyclicBasis {K : Type*} [CommRing K] (a b c d e : K) :
    Matrix (Fin 4) (Fin 4) K :=
  !![1,a,a^2+c,a^3+2*a*c+b*c+e;
     0,1,a+b,a^2+a*b+b^2+c+d;
     0,0,1,a+2*b;
     0,0,0,1]

/-- The displayed basis is the actual sequence of four cyclic vectors. -/
theorem countingMatrixCyclicBasis_column {K : Type*} [CommRing K] (a b c d e f : K)
    (column : Fin 4) :
    (fun row => countingMatrixCyclicBasis a b c d e row column) =
      ((fourDimensionalCountingMatrix a b c d e f)^column.val).mulVec ![1,0,0,0] := by
  ext row
  fin_cases column <;> fin_cases row <;>
    simp [countingMatrixCyclicBasis, fourDimensionalCountingMatrix, pow_succ,
      Matrix.mulVec, Matrix.vecHead, Matrix.vecTail] <;> ring

/-- The cyclic basis has determinant one, including at degenerate spectra. -/
theorem countingMatrixCyclicBasis_det {K : Type*} [CommRing K] (a b c d e : K) :
    (countingMatrixCyclicBasis a b c d e).det = 1 := by
  simp [countingMatrixCyclicBasis, Matrix.det_succ_row_zero, Fin.sum_univ_succ,
    Fin.succAbove, Matrix.submatrix_apply]

/-- The exact characteristic polynomial of a six-parameter counting matrix.
This identity includes every repeated-root specialization. -/
theorem fourDimensionalCountingMatrix_charpoly {K : Type*} [Field K] [Infinite K]
    (a b c d e f : K) :
    (fourDimensionalCountingMatrix a b c d e f).charpoly =
      (Polynomial.X-Polynomial.C a)^2*(Polynomial.X-Polynomial.C b)^2 -
      Polynomial.C (2*c)*(Polynomial.X-Polynomial.C a)*(Polynomial.X-Polynomial.C b) -
      Polynomial.C d*(Polynomial.X-Polynomial.C a)^2 -
      Polynomial.C (2*e)*(Polynomial.X-Polynomial.C a) + Polynomial.C (c^2-f) := by
  apply Polynomial.funext
  intro t
  rw [Matrix.eval_charpoly]
  simp [fourDimensionalCountingMatrix, Matrix.det_succ_row_zero, Fin.sum_univ_succ,
    Fin.succAbove, Matrix.submatrix_apply, Matrix.scalar, Matrix.diagonal,
    Matrix.vecHead, Matrix.vecTail]
  ring

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
