import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NefSurfacePrimarySeed
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ClassicalCurveExactResidue

/-!
# Noncircular nullity for low-dimensional primary expressions

Curve expressions retain their whole primary blocks: two simple even factors,
a scalar-leading rank-two factor, or an eligible classical curve connection.
Surface expressions start with a nef-canonical linear seed, the projective
plane's three simple even factors, or two occurrences of a curve expression;
point blowups append a rank-one even factor. Their exact-primary weights are
proved zero from the actual seed data, preserving occurrence multiplicities.
Geometric classification and identification of QDM block lists with these
expressions are separate inputs. No ambient birational invariant is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The even rank-one, odd rank-zero point factor. -/
def pointPrimaryBlock {K : Type*} [Field K] : ExactPrimaryBlock K := .other 1 0 (by decide)

/-- Whole-primary models for the three curve spectral cases. -/
inductive CurvePrimarySeed (K : Type*) [Field K] [CharZero K]
  | simple
  | scalar (loop : PowerSeries (Matrix (Fin 2) (Fin 2) K))
      (centered : PowerSeries.coeff 0 loop=0) (oddRank : ℕ)
  | classical (connection : AdaptedRankTwoConnection K) (euler : K)
      (loopFormula : connection.loop=classicalCurveAdaptedLoop euler)

/-- The actual block multiset of a curve seed, including both simple factors. -/
def CurvePrimarySeed.blocks {K : Type*} [Field K] [CharZero K] :
    CurvePrimarySeed K → Multiset (ExactPrimaryBlock K)
  | .simple => {pointPrimaryBlock,pointPrimaryBlock}
  | .scalar loop centered oddRank => {.scalarRankTwo loop centered oddRank}
  | .classical connection _ _ => {.rankTwo connection}

/-- Sum exact-primary weights over a finite multiset, retaining repetitions. -/
noncomputable def primaryBlockMultisetWeight {K : Type*} [Field K]
    (blocks : Multiset (ExactPrimaryBlock K)) : (K →₀ ℕ) × ℕ :=
  (blocks.map ExactPrimaryBlock.weight).sum

/-- All three curve seed cases have zero total exact-primary weight. -/
theorem CurvePrimarySeed.weight_zero {K : Type*} [Field K] [CharZero K]
    (seed : CurvePrimarySeed K) : primaryBlockMultisetWeight seed.blocks=0 := by
  cases seed with
  | simple => simp [primaryBlockMultisetWeight, blocks, pointPrimaryBlock, ExactPrimaryBlock.weight]
  | scalar loop centered oddRank => simp [primaryBlockMultisetWeight, blocks, ExactPrimaryBlock.weight]
  | classical connection euler formula =>
    simp [primaryBlockMultisetWeight, blocks, ExactPrimaryBlock.weight, formula,
      (classicalCurveAdaptedLoop_exactSpectrum_zero euler).2]

/-- Surface block expressions with explicit minimal seeds and point blowups. -/
inductive SurfacePrimaryExpression (K : Type*) [Field K] [CharZero K]
  | nef (seed : NefSurfacePrimarySeed K)
  | plane
  | ruled (curve : CurvePrimarySeed K)
  | pointBlowup (base : SurfacePrimaryExpression K)

/-- Point blowups append a point block, and a ruled surface retains two
separately counted copies of its curve block list. -/
def SurfacePrimaryExpression.blocks {K : Type*} [Field K] [CharZero K] :
    SurfacePrimaryExpression K → Multiset (ExactPrimaryBlock K)
  | .nef seed => {seed.block}
  | .plane => {pointPrimaryBlock,pointPrimaryBlock,pointPrimaryBlock}
  | .ruled curve => curve.blocks+curve.blocks
  | .pointBlowup base => base.blocks+{pointPrimaryBlock}

/-- The surface expression has zero weight by seed computations and induction
on point blowups. No seed-zero or birational-invariance hypothesis is supplied. -/
theorem SurfacePrimaryExpression.weight_zero {K : Type*} [Field K] [CharZero K]
    (expression : SurfacePrimaryExpression K) : primaryBlockMultisetWeight expression.blocks=0 := by
  induction expression with
  | nef seed => simp [blocks, primaryBlockMultisetWeight, seed.weight_zero]
  | plane => simp [blocks, primaryBlockMultisetWeight, pointPrimaryBlock, ExactPrimaryBlock.weight]
  | ruled curve =>
    simp only [blocks, primaryBlockMultisetWeight, Multiset.map_add, Multiset.sum_add]
    exact add_eq_zero.mpr ⟨curve.weight_zero,curve.weight_zero⟩
  | pointBlowup base ih =>
    simpa [blocks, primaryBlockMultisetWeight, pointPrimaryBlock, ExactPrimaryBlock.weight] using ih

/-- Matching finite block lists by actual regular/full-fiber comparisons
preserves their summed weights; equality of the weights is derived. -/
theorem primaryBlockList_comparison_sum
    {K ι : Type*} [Field K] [CharZero K] [Fintype ι]
    (source target : ι → ExactPrimaryBlock K)
    (comparisons : ∀ i, Nonempty (ExactPrimaryBlockComparison (source i) (target i))) :
    ∑ i, (source i).weight = ∑ i, (target i).weight := by
  apply Finset.sum_congr rfl
  intro i _
  obtain ⟨comparison⟩ := comparisons i
  exact comparison.weight_eq

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
