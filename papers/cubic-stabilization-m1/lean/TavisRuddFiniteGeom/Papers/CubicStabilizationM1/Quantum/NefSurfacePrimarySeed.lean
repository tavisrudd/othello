import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryLedger
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.StrictDegreeNilpotence
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PositiveLineIsotropicVanishing

/-!
# Linear data for a nef-canonical surface primary factor

The seed consists of a centered Euler operator raising a finite cohomological
filtration, positive second Betti number, a real intersection form positive on
a specified class, and the geometric isotropic-class construction from
nonzero odd cohomology. Nilpotence and vanishing of the exact-primary weight
are derived from these data. No seed-weight-vanishing or birational-invariance
premise is included. The virtual-dimension and differential-form constructions,
and identification of the nilpotent whole fiber with one primary factor,
remain geometric inputs beyond this linear model.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Linear cohomological data used for a minimal nef-canonical surface.
The isotropic-class premise records the nonzero one-form construction and
Hodge identities, rather than an assertion that the odd dimension is zero. -/
structure NefSurfacePrimarySeed (K : Type*) [Field K] where
  secondBetti : ℕ
  positiveBetti : 1 ≤ secondBetti
  oddRank : ℕ
  intersection : (Fin secondBetti → ℝ) →ₗ[ℝ] (Fin secondBetti → ℝ) →ₗ[ℝ] ℝ
  positiveClass : Fin secondBetti → ℝ
  positiveSquare : 0 < intersection positiveClass positiveClass
  isotropicOfOddPositive : 0 < oddRank →
    ∃ x : Fin secondBetti → ℝ, x ≠ 0 ∧ intersection x x=0
  centeredEuler : Module.End K (Fin (secondBetti+2) → K)
  filtration : ℕ → Submodule K (Fin (secondBetti+2) → K)
  full : filtration 0=⊤
  raises : ∀ n x, x ∈ filtration n → centeredEuler x ∈ filtration (n+1)
  bound : ℕ
  zeroStep : filtration bound=⊥

/-- The full centered Euler operator is nilpotent by strict degree increase. -/
theorem NefSurfacePrimarySeed.nilpotent
    {K : Type*} [Field K] (seed : NefSurfacePrimarySeed K) :
    seed.centeredEuler^seed.bound=0 :=
  strictlyRaising_nilpotent seed.filtration seed.full seed.centeredEuler seed.raises seed.bound seed.zeroStep

/-- Full even rank three forces the odd rank to vanish by the positive-line
isotropic contradiction. -/
theorem NefSurfacePrimarySeed.oddRank_zero_of_evenRank_three
    {K : Type*} [Field K] (seed : NefSurfacePrimarySeed K)
    (rankThree : seed.secondBetti+2=3) : seed.oddRank=0 := by
  have second : seed.secondBetti=1 := by omega
  by_contra nonzero
  obtain ⟨x,hx,isotropic⟩ := seed.isotropicOfOddPositive (Nat.pos_of_ne_zero nonzero)
  apply hx
  apply positiveLine_isotropic_eq_zero seed.intersection seed.positiveClass
    (by simp [second]) seed.positiveSquare x isotropic

/-- The whole even fiber has rank at least three and is therefore not an
eligible rank-two block. -/
def NefSurfacePrimarySeed.block
    {K : Type*} [Field K] (seed : NefSurfacePrimarySeed K) : ExactPrimaryBlock K :=
  .other (seed.secondBetti+2) seed.oddRank (by have := seed.positiveBetti; omega)

/-- Both exact-primary selectors vanish on the nef-surface linear seed. -/
theorem NefSurfacePrimarySeed.weight_zero
    {K : Type*} [Field K] (seed : NefSurfacePrimarySeed K) : seed.block.weight=0 := by
  by_cases rankThree : seed.secondBetti+2=3
  · simp [block, ExactPrimaryBlock.weight, rankThree, seed.oddRank_zero_of_evenRank_three rankThree]
  · simp [block, ExactPrimaryBlock.weight, rankThree]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
