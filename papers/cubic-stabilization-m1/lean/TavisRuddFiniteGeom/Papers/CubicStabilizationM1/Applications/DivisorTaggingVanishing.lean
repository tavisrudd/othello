import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FramedMultiplicity

/-!
# Primitive-sixth vanishing under divisor-tagged specialization

This module isolates the final deduction in the divisor-tagging lemma.  For
each geometric object and strictly Novikov-admissible specialization, a
divisor-tagged intermediate framed monodromy over `ℂ` is supplied.  The two
final common-field characteristic-polynomial equalities resulting from the
unformalized scalar-extension and formal-bulk-gauge comparisons are explicit
premises.  Lean proves equality of intrinsic and specialized primitive-sixth
multiplicities and hence transfers vanishing.

The two comparison hypotheses isolate the final common-field polynomial
equalities produced by the load-bearing analytic and geometric steps.  This
module does not construct the completed numerical Novikov ring,
the valued specialization, separating integral divisors, the injective
exponential-character tag on completed series, common algebraic closures,
scalar extension of quantum connections, the divisor-equation bulk pullback,
or the compatible integral-loop-power finite-quotient gauges.  No source
coefficient field, common comparison field, embedding, polynomial coefficient
map, or gauge witness occurs in the formal signature; those constructions are
collapsed into the two supplied equalities over `ℂ`.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

/-- Framed-monodromy signature for divisor-tagged Novikov specialization. -/
structure DivisorTaggingGeometry (Object : Type*) where
  /-- Strictly Novikov-admissible specializations attached to an object. -/
  Specialization : Object → Type*
  /-- Predicate asserting strict Novikov admissibility. -/
  isStrictlyNovikovAdmissible :
    (object : Object) → Specialization object → Prop
  /-- Intrinsic generic framed monodromy. -/
  intrinsicMonodromy : Object → Quantum.FramedMonodromyMatrix
  /-- Framed monodromy after the supplied specialization. -/
  specializedMonodromy :
    (object : Object) → Specialization object → Quantum.FramedMonodromyMatrix
  /-- Intermediate monodromy after adjoining formal divisor tags. -/
  taggedMonodromy :
    (object : Object) → Specialization object → Quantum.FramedMonodromyMatrix

/-- Final common-field polynomial comparisons used by divisor tagging.  The
first is the equality resulting from injective tagged scalar extension; the
second is the equality resulting from removal of the formal divisor bulk by
compatible integral-loop-power gauges.  Neither comparison construction is
represented in this structure. -/
structure DivisorTaggingComparisonInput
    {Object : Type*} (geometry : DivisorTaggingGeometry Object) where
  /-- Final polynomial equality over `ℂ` supplied after the unformalized
  coefficient extension and common-algebraic-closure identifications. -/
  taggedCharpoly_eq_intrinsic : ∀ object
      (specialization : geometry.Specialization object),
    geometry.isStrictlyNovikovAdmissible object specialization →
      (geometry.taggedMonodromy object specialization).operator.charpoly =
        (geometry.intrinsicMonodromy object).operator.charpoly
  /-- Final polynomial equality over `ℂ` supplied after the unformalized
  divisor-equation pullback and formal bulk gauge. -/
  specializedCharpoly_eq_tagged : ∀ object
      (specialization : geometry.Specialization object),
    geometry.isStrictlyNovikovAdmissible object specialization →
      (geometry.specializedMonodromy object specialization).operator.charpoly =
        (geometry.taggedMonodromy object specialization).operator.charpoly

/-- Divisor tagging preserves primitive-sixth multiplicity under every
supplied strictly Novikov-admissible specialization. -/
theorem divisorTagging_sixthMultiplicity_eq
    {Object : Type*} (geometry : DivisorTaggingGeometry Object)
    (input : DivisorTaggingComparisonInput geometry) (object : Object)
    (specialization : geometry.Specialization object)
    (admissible : geometry.isStrictlyNovikovAdmissible object specialization) :
    (geometry.specializedMonodromy object specialization).sixthMultiplicity =
      (geometry.intrinsicMonodromy object).sixthMultiplicity := by
  change Quantum.sixthMultiplicityPolynomial
      (geometry.specializedMonodromy object specialization).operator.charpoly =
    Quantum.sixthMultiplicityPolynomial
      (geometry.intrinsicMonodromy object).operator.charpoly
  rw [input.specializedCharpoly_eq_tagged object specialization admissible,
    input.taggedCharpoly_eq_intrinsic object specialization admissible]

/-- Conditional common-field endpoint of divisor tagging: intrinsic primitive-sixth vanishing
implies vanishing after every supplied strictly Novikov-admissible
specialization. -/
theorem divisorTagging_vanishing
    {Object : Type*} (geometry : DivisorTaggingGeometry Object)
    (input : DivisorTaggingComparisonInput geometry) :
    ∀ object, (geometry.intrinsicMonodromy object).sixthMultiplicity = 0 →
      ∀ specialization : geometry.Specialization object,
        geometry.isStrictlyNovikovAdmissible object specialization →
          (geometry.specializedMonodromy object
            specialization).sixthMultiplicity = 0 := by
  intro object intrinsicVanishing specialization admissible
  rw [divisorTagging_sixthMultiplicity_eq geometry input object specialization
    admissible]
  exact intrinsicVanishing

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
