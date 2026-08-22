import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovConvolution

/-!
# Divisor characters on completed Novikov rings

A multiplicative character of effective curve classes acts coefficientwise on
the completed Novikov ring: the coefficient of `Q^d` is multiplied by the
character value at `d`.  Lean proves that this coefficientwise formula is a
unital ring endomorphism for completed convolution.  This is the algebraic
content of the divisor substitution
`Q^d ↦ exp(⟨a₂,d⟩) Q^d` once the exponential character is supplied.

No geometric divisor pairing, exponential map, quantum divisor equation, or
identification with the manuscript's Novikov coefficient ring is constructed
here.  All proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open scoped BigOperators

variable {Curve Coefficient : Type*} [AddCommMonoid Curve]

/-- Coefficientwise multiplication by a multiplicative character of additive
curve classes. -/
noncomputable def completedDivisorSubstitution
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (weight : Multiplicative Curve →* Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient) :
    FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient where
  coefficient curve := weight (.ofAdd curve) * series.coefficient curve
  finite_below cutoff := (series.finite_below cutoff).subset <| by
    intro curve membership
    exact ⟨by
      intro coefficient_zero
      exact membership.1 (by simp [coefficient_zero]), membership.2⟩

/-- The divisor substitution has the advertised coefficientwise formula. -/
theorem completedDivisorSubstitution_coefficient
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (weight : Multiplicative Curve →* Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient) (curve : Curve) :
    (completedDivisorSubstitution grading weight series).coefficient curve =
      weight (.ofAdd curve) * series.coefficient curve :=
  rfl

/-- A multiplicative curve-class character acts by a unital ring
endomorphism of the completed Novikov ring. -/
noncomputable def completedDivisorSubstitutionRingHom
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (weight : Multiplicative Curve →* Coefficient) :
    FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient →+*
      FiniteDegreeAddCommMonoid.CompletedNovikovRing grading Coefficient where
  toFun := completedDivisorSubstitution grading weight
  map_zero' := by
    apply CompletedNovikovSeries.ext
    funext curve
    simp [completedDivisorSubstitution_coefficient]
  map_one' := by
    apply CompletedNovikovSeries.ext
    funext curve
    by_cases curve_zero : curve = 0
    · subst curve
      simp [completedDivisorSubstitution_coefficient,
        FiniteDegreeAddCommMonoid.CompletedNovikovRing.one_def,
        FiniteDegreeAddCommMonoid.convolutionUnit]
    · simp [completedDivisorSubstitution_coefficient,
        FiniteDegreeAddCommMonoid.CompletedNovikovRing.one_def,
        FiniteDegreeAddCommMonoid.convolutionUnit, curve_zero]
  map_add' left right := by
    apply CompletedNovikovSeries.ext
    funext curve
    simp [completedDivisorSubstitution_coefficient, mul_add]
  map_mul' left right := by
    apply CompletedNovikovSeries.ext
    funext total
    rw [completedDivisorSubstitution_coefficient,
      FiniteDegreeAddCommMonoid.CompletedNovikovRing.mul_def,
      FiniteDegreeAddCommMonoid.convolution_coefficient,
      Finset.mul_sum,
      FiniteDegreeAddCommMonoid.CompletedNovikovRing.mul_def,
      FiniteDegreeAddCommMonoid.convolution_coefficient]
    apply Finset.sum_congr rfl
    intro pair pair_mem
    have decomposition := (grading.mem_decompositions_iff pair total).mp pair_mem
    simp only [completedDivisorSubstitution_coefficient]
    rw [← decomposition]
    change
      weight (.ofAdd pair.1 * .ofAdd pair.2) *
          (left.coefficient pair.1 * right.coefficient pair.2) =
        (weight (.ofAdd pair.1) * left.coefficient pair.1) *
          (weight (.ofAdd pair.2) * right.coefficient pair.2)
    rw [map_mul]
    ring

/-- Evaluating the bundled divisor-substitution endomorphism is the same
coefficientwise character action. -/
theorem completedDivisorSubstitutionRingHom_apply
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (weight : Multiplicative Curve →* Coefficient)
    (series : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      grading Coefficient) :
    completedDivisorSubstitutionRingHom grading weight series =
      completedDivisorSubstitution grading weight series :=
  rfl

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
