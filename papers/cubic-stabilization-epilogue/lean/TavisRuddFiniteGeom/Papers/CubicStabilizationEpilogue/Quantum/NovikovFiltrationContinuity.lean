import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.NumericalNovikovCompletion

/-!
# Cutoff continuity for completed Novikov coefficients

Two completed coefficient families agree through a cutoff when their
coefficients agree on every class of degree at most that cutoff.  A map is
cutoff-continuous when each requested output cutoff is controlled by some
input cutoff.  This module proves the stronger identity-modulus statements:
pointwise addition and completed convolution preserve agreement through the
same cutoff, and numerical pushforward does likewise.

These are the exact filtration-continuity estimates used in the manuscript's
inverse-limit argument.  The module defines no topology or uniform space and
does not claim continuity in Mathlib's topological `Continuous` predicate.
All proofs are symbolic and kernel checked, with no external computation or
oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

variable {Curve Coefficient : Type*} [AddCommMonoid Curve]

namespace FiniteDegreeAddCommMonoid

/-- Agreement of two completed coefficient families through one degree
cutoff. -/
def AgreeThrough
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (cutoff : ℕ)
    (left right : CompletedNovikovRing grading Coefficient) : Prop :=
  ∀ curve, grading.degree curve ≤ cutoff →
    left.coefficient curve = right.coefficient curve

/-- A unary map of completed coefficient families is continuous for the degree
cutoff filtration if every output cutoff is controlled by an input cutoff. -/
def CutoffContinuous
    (source : FiniteDegreeAddCommMonoid Curve)
    {Target : Type*} [AddCommMonoid Target]
    (target : FiniteDegreeAddCommMonoid Target)
    [CommRing Coefficient]
    (map : CompletedNovikovRing source Coefficient →
      CompletedNovikovRing target Coefficient) : Prop :=
  ∀ outputCutoff, ∃ inputCutoff, ∀ left right,
    source.AgreeThrough inputCutoff left right →
      target.AgreeThrough outputCutoff (map left) (map right)

/-- Addition preserves cutoff agreement with identity modulus. -/
theorem agreeThrough_add
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    {cutoff : ℕ}
    {left₁ left₂ right₁ right₂ : CompletedNovikovRing grading Coefficient}
    (left_agree : grading.AgreeThrough cutoff left₁ left₂)
    (right_agree : grading.AgreeThrough cutoff right₁ right₂) :
    grading.AgreeThrough cutoff (left₁ + right₁) (left₂ + right₂) := by
  intro curve curve_below
  change left₁.coefficient curve + right₁.coefficient curve =
    left₂.coefficient curve + right₂.coefficient curve
  rw [left_agree curve curve_below, right_agree curve curve_below]

/-- Completed convolution preserves cutoff agreement in both inputs with
identity modulus. -/
theorem agreeThrough_convolution
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    {cutoff : ℕ}
    {left₁ left₂ right₁ right₂ : CompletedNovikovRing grading Coefficient}
    (left_agree : grading.AgreeThrough cutoff left₁ left₂)
    (right_agree : grading.AgreeThrough cutoff right₁ right₂) :
    grading.AgreeThrough cutoff
      (grading.convolution left₁ right₁)
      (grading.convolution left₂ right₂) := by
  intro total total_below
  rw [grading.convolution_coefficient, grading.convolution_coefficient]
  apply Finset.sum_congr rfl
  intro pair pair_mem
  have decomposition := (grading.mem_decompositions_iff pair total).mp pair_mem
  have left_below : grading.degree pair.1 ≤ cutoff := by
    calc
      grading.degree pair.1 ≤ grading.degree pair.1 + grading.degree pair.2 :=
        Nat.le_add_right _ _
      _ = grading.degree total := by rw [← map_add, decomposition]
      _ ≤ cutoff := total_below
  have right_below : grading.degree pair.2 ≤ cutoff := by
    calc
      grading.degree pair.2 ≤ grading.degree pair.1 + grading.degree pair.2 :=
        Nat.le_add_left _ _
      _ = grading.degree total := by rw [← map_add, decomposition]
      _ ≤ cutoff := total_below
  rw [left_agree pair.1 left_below, right_agree pair.2 right_below]

end FiniteDegreeAddCommMonoid

namespace CompletedNumericalQuotient

variable {Homology Numerical : Type*}
  [AddCommMonoid Homology] [AddCommMonoid Numerical]

/-- Completed numerical pushforward is cutoff-continuous with identity
modulus: source agreement through `c` implies target agreement through `c`. -/
theorem completedPushforward_agreeThrough
    (data : CompletedNumericalQuotient Homology Numerical)
    [CommRing Coefficient] {cutoff : ℕ}
    {left right : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading Coefficient}
    (agree : data.homologicalGrading.AgreeThrough cutoff left right) :
    data.numericalGrading.AgreeThrough cutoff
      (data.completedPushforward left) (data.completedPushforward right) :=
  data.coefficientData.completedCoefficientPushforward_eq_below_of_eq_below
    left right cutoff agree

/-- Completed numerical pushforward satisfies the cutoff-continuity predicate
with the same input and output cutoff. -/
theorem completedPushforward_cutoffContinuous
    (data : CompletedNumericalQuotient Homology Numerical)
    [CommRing Coefficient] :
    FiniteDegreeAddCommMonoid.CutoffContinuous
      data.homologicalGrading data.numericalGrading
        (data.completedPushforward (R := Coefficient)) := by
  intro cutoff
  exact ⟨cutoff, fun
    (left right : FiniteDegreeAddCommMonoid.CompletedNovikovRing
      data.homologicalGrading Coefficient) agree ↦
      data.completedPushforward_agreeThrough agree⟩

end CompletedNumericalQuotient

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
