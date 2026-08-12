import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.PacketInvariant
import Mathlib.Tactic

/-!
# Birational deductions from operation formulas

Weak factorization reduces a birational map to blow-ups and blow-downs.  If the
packet contribution of every allowed center vanishes, each step preserves the
packet multiplicity.  The theorem below formalizes the resulting telescope.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

variable {Variety : Type*}

/-- A composable chain of transformations that preserve the packet
multiplicity.  The indices encode adjacency, so no separate endpoint or
composability certificate is required. -/
inductive PreservingChain (packet : PacketData Variety) : Variety → Variety → Prop
  | refl (object : Variety) : PreservingChain packet object object
  | step {source middle target : Variety}
      (preserves : packet.multiplicity source = packet.multiplicity middle)
      (tail : PreservingChain packet middle target) :
      PreservingChain packet source target

/-- A chain of packet-preserving factorization steps has equal multiplicity at
its endpoints. -/
theorem PreservingChain.multiplicity_eq
    (packet : PacketData Variety) {source target : Variety}
    (chain : PreservingChain packet source target) :
    packet.multiplicity source = packet.multiplicity target := by
  induction chain with
  | refl => rfl
  | step preserves _ inductionHypothesis => exact preserves.trans inductionHypothesis

/-- The external geometric data needed to turn a packet multiplicity into a
birational invariant through dimension four.  The `factorization` field is an
explicit premise: it packages weak factorization, operation formulas, and
vanishing of every permitted center contribution. -/
structure DimensionFourBirationalInput (packet : PacketData Variety) where
  birational : Variety → Variety → Prop
  factorization : ∀ {source target}, packet.dimension source ≤ 4 →
    birational source target → PreservingChain packet source target

/-- Weak factorization through packet-preserving steps makes the packet
multiplicity birationally invariant in dimension at most four. -/
theorem DimensionFourBirationalInput.multiplicity_eq
    (packet : PacketData Variety)
    (input : DimensionFourBirationalInput packet)
    {source target : Variety} (sourceDimension : packet.dimension source ≤ 4)
    (birational : input.birational source target) :
    packet.multiplicity source = packet.multiplicity target :=
  (input.factorization sourceDimension birational).multiplicity_eq packet

/-- Equality after multiplying two natural numbers by two permits cancellation.
This is the arithmetic step in transporting a packet across two rank-two
projective-bundle presentations. -/
theorem eq_of_two_mul_eq_two_mul {left right : ℕ}
    (equality : 2 * left = 2 * right) : left = right := by
  omega

/-- If two rank-two projective bundles are birational and the packet obeys the
rank-two projective-bundle formula on both, then their bases have the same
packet multiplicity.  The geometric identification of the bundles is an
explicit premise. -/
theorem rankTwoProjectiveBundle_transport
    (packet : PacketData Variety)
    (input : DimensionFourBirationalInput packet)
    {leftBase rightBase leftBundle rightBundle : Variety}
    (leftFormula : packet.multiplicity leftBundle =
      2 * packet.multiplicity leftBase)
    (rightFormula : packet.multiplicity rightBundle =
      2 * packet.multiplicity rightBase)
    (bundleDimension : packet.dimension leftBundle ≤ 4)
    (bundlesBirational : input.birational leftBundle rightBundle) :
    packet.multiplicity leftBase = packet.multiplicity rightBase := by
  apply eq_of_two_mul_eq_two_mul
  calc
    2 * packet.multiplicity leftBase = packet.multiplicity leftBundle := leftFormula.symm
    _ = packet.multiplicity rightBundle :=
      input.multiplicity_eq packet bundleDimension bundlesBirational
    _ = 2 * packet.multiplicity rightBase := rightFormula

/-- A nonzero birational invariant obstructs a rationality predicate whenever
rationality supplies a birational map to a comparison object on which the
invariant vanishes. -/
theorem not_rational_of_nonzero_multiplicity
    (packet : PacketData Variety)
    (input : DimensionFourBirationalInput packet)
    (Rational : Variety → Prop)
    {object comparison : Variety}
    (objectDimension : packet.dimension object ≤ 4)
    (objectNonzero : packet.multiplicity object ≠ 0)
    (comparisonZero : packet.multiplicity comparison = 0)
    (rationalComparison : Rational object → input.birational object comparison) :
    ¬ Rational object := by
  intro rational
  apply objectNonzero
  calc
    packet.multiplicity object = packet.multiplicity comparison :=
      input.multiplicity_eq packet objectDimension (rationalComparison rational)
    _ = 0 := comparisonZero

/-- A rank-two projective stabilization of an object with nonzero packet
multiplicity is irrational when rationality would identify the stabilization
birationally with a zero-packet comparison object.  All geometric and quantum
comparison statements occur as hypotheses. -/
theorem rankTwoStabilization_not_rational
    (packet : PacketData Variety)
    (input : DimensionFourBirationalInput packet)
    (Rational : Variety → Prop)
    {base stabilized comparison : Variety}
    (stabilizationFormula : packet.multiplicity stabilized =
      2 * packet.multiplicity base)
    (stabilizedDimension : packet.dimension stabilized ≤ 4)
    (baseNonzero : packet.multiplicity base ≠ 0)
    (comparisonZero : packet.multiplicity comparison = 0)
    (rationalComparison : Rational stabilized → input.birational stabilized comparison) :
    ¬ Rational stabilized := by
  apply not_rational_of_nonzero_multiplicity packet input Rational stabilizedDimension
  · rw [stabilizationFormula]
    exact Nat.mul_ne_zero (by omega) baseNonzero
  · exact comparisonZero
  · exact rationalComparison

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
