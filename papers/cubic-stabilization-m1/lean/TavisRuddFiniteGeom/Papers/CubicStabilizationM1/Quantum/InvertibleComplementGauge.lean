import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.TwoByTwoBlockGauge

/-!
# A rank-two nilpotent block with an invertible complementary block

The leading blocks are `[[0,t],[1,h]]` and `[[0,1],[0,0]]`, with `t≠0` in
a field. An explicit rational Sylvester solver constructs a normalized formal
gauge without splitting the complementary eigenvalues. The trace parameter
`h` is arbitrary, allowing complementary blocks with nonzero trace.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A companion block of determinant `-t`, followed by a nilpotent block. -/
def invertibleComplementBlocks {K : Type*} [Field K] (h t : K) :
    Matrix (Fin 4) (Fin 4) K := !![0,t,0,0; 1,h,0,0; 0,0,0,1; 0,0,0,0]

/-- The rational off-diagonal solution of one normalized residual equation. -/
def invertibleComplementGaugeStep {K : Type*} [Field K] (h t : K)
    (r : Matrix (Fin 4) (Fin 4) K) : Matrix (Fin 4) (Fin 4) K :=
  let x02 := -r 1 2+h*r 0 2/t
  let x13 := -r 0 3/t-r 1 2/t+h*r 0 2/t^2
  let x30 := (r 3 1-h*r 3 0)/t
  let x21 := x30+r 2 0
  !![0,0,x02,-r 1 3-h*x13-r 0 2/t;
     0,0,-r 0 2/t,x13;
     (r 3 0-h*x21+r 2 1)/t,x21,0,0;
     x30,r 3 0,0,0]

/-- The rational solver has vanishing diagonal blocks. -/
theorem invertibleComplementGaugeStep_offDiagonal {K : Type*} [Field K]
    (h t : K) (r : Matrix (Fin 4) (Fin 4) K) :
    IsBlockOffDiagonal twoByTwoBlockLabel (invertibleComplementGaugeStep h t r) := by
  intro row column eq
  fin_cases row <;> fin_cases column <;>
    simp_all [twoByTwoBlockLabel, invertibleComplementGaugeStep]

set_option maxHeartbeats 1000000 in
/-- The solver satisfies every entry of the residual equation for nonzero `t`. -/
theorem invertibleComplementGaugeStep_equation {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0) (r : Matrix (Fin 4) (Fin 4) K) :
    blockDiagonalProjection twoByTwoBlockLabel r +
      (invertibleComplementGaugeStep h t r * invertibleComplementBlocks h t -
        invertibleComplementBlocks h t * invertibleComplementGaugeStep h t r) = r := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [invertibleComplementGaugeStep, twoByTwoBlockLabel, invertibleComplementBlocks] <;>
    (try field_simp [ht]) <;> ring

/-- An arbitrary formal system with these leading blocks admits a normalized
two-block gauge at every order. -/
theorem invertibleComplement_exists_normalizedGauge {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0) (system : ℕ → Matrix (Fin 4) (Fin 4) K)
    (leading : system 0 = invertibleComplementBlocks h t) :
    ∃ gauge reduced, IsNormalizedGauge twoByTwoBlockLabel system gauge reduced := by
  apply exists_normalizedGauge_of_step_solver twoByTwoBlockLabel system
    (solve := fun r => (invertibleComplementGaugeStep h t r,
      blockDiagonalProjection twoByTwoBlockLabel r))
  · rw [leading]
    intro row column eq
    fin_cases row <;> fin_cases column <;>
      simp_all [twoByTwoBlockLabel, invertibleComplementBlocks]
  · exact invertibleComplementGaugeStep_offDiagonal h t
  · exact isBlockDiagonal_blockDiagonalProjection _
  · intro r
    simpa only [leading] using invertibleComplementGaugeStep_equation h ht r

set_option maxHeartbeats 1000000 in
/-- The rational step solver recovers every off-diagonal unknown from its
residual, even when an arbitrary block-diagonal term is added. Consequently
the normalized off-diagonal coefficient at each order is unique. -/
theorem invertibleComplementGaugeStep_recovers {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0)
    (x d : Matrix (Fin 4) (Fin 4) K)
    (off : IsBlockOffDiagonal twoByTwoBlockLabel x)
    (diag : IsBlockDiagonal twoByTwoBlockLabel d) :
    invertibleComplementGaugeStep h t
      (d+(x*invertibleComplementBlocks h t-invertibleComplementBlocks h t*x)) = x := by
  have h00 : x 0 0 = 0 := off 0 0 (by decide)
  have h01 : x 0 1 = 0 := off 0 1 (by decide)
  have h02 : d 0 2 = 0 := diag 0 2 (by decide)
  have h03 : d 0 3 = 0 := diag 0 3 (by decide)
  have h10 : x 1 0 = 0 := off 1 0 (by decide)
  have h11 : x 1 1 = 0 := off 1 1 (by decide)
  have h12 : d 1 2 = 0 := diag 1 2 (by decide)
  have h13 : d 1 3 = 0 := diag 1 3 (by decide)
  have h20 : d 2 0 = 0 := diag 2 0 (by decide)
  have h21 : d 2 1 = 0 := diag 2 1 (by decide)
  have h22 : x 2 2 = 0 := off 2 2 (by decide)
  have h23 : x 2 3 = 0 := off 2 3 (by decide)
  have h30 : d 3 0 = 0 := diag 3 0 (by decide)
  have h31 : d 3 1 = 0 := diag 3 1 (by decide)
  have h32 : x 3 2 = 0 := off 3 2 (by decide)
  have h33 : x 3 3 = 0 := off 3 3 (by decide)
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [invertibleComplementGaugeStep, invertibleComplementBlocks, Matrix.mul_apply, Matrix.vecMul, dotProduct,
      Fin.sum_univ_succ, h00, h01, h02, h03, h10, h11, h12, h13, h20, h21, h22, h23, h30, h31, h32, h33] <;>
    (try field_simp [ht]) <;> ring


/-- Two normalized solutions of one residual equation agree in both their
off-diagonal gauge coefficient and their block-diagonal reduced coefficient. -/
theorem invertibleComplementGaugeStep_unique {K : Type*} [Field K]
    (h : K) {t : K} (ht : t ≠ 0)
    {x y d e r : Matrix (Fin 4) (Fin 4) K}
    (offX : IsBlockOffDiagonal twoByTwoBlockLabel x)
    (offY : IsBlockOffDiagonal twoByTwoBlockLabel y)
    (diagD : IsBlockDiagonal twoByTwoBlockLabel d)
    (diagE : IsBlockDiagonal twoByTwoBlockLabel e)
    (hx : d+(x*invertibleComplementBlocks h t-invertibleComplementBlocks h t*x) = r)
    (hy : e+(y*invertibleComplementBlocks h t-invertibleComplementBlocks h t*y) = r) :
    x=y ∧ d=e := by
  have h1 := invertibleComplementGaugeStep_recovers h ht x d offX diagD
  have h2 := invertibleComplementGaugeStep_recovers h ht y e offY diagE
  rw [hx] at h1
  rw [hy] at h2
  have hxy := h1.symm.trans h2
  refine ⟨hxy, ?_⟩
  rw [hxy] at hx
  linear_combination (norm := abel) hx-hy


end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
