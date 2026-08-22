import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.LowDimensionalVanishingCore

/-!
# Low-dimensional primitive-sixth vanishing from classified geometric inputs

This module formalizes the deductive assembly of the low-dimensional
vanishing argument.  A supplied geometric signature records points,
projective-bundle and point-blowup relations, intrinsic framed monodromy, and
strictly Novikov-admissible specializations.  A classification witness
expresses each object under consideration as a nef seed, the distinguished
point, a projective bundle over an earlier object, or a point blowup of an
earlier object.

Lean proves vanishing by induction from four explicit premises: the
characteristic roots of a nef seed square to one, the point has zero
primitive-sixth multiplicity, the projective-bundle formula multiplies the
base multiplicity by its rank, and a point blowup preserves the multiplicity.
An explicit divisor-tagging premise then transfers intrinsic vanishing to
every strictly Novikov-admissible specialization.

The root restriction abstracts the coefficientwise regular-singular argument
of Katzarkov, Kontsevich, Pantev, and Yu, *Birational invariants from Hodge
structures and quantum multiplication*, arXiv:2508.05105v2 (2026), Claim
6.15, together with the parity correction used in the manuscript.  The
supplied projective-bundle formula is the multiplicity consequence consumed
from Hiroshi Iritani and Yuki Koto, *Quantum cohomology of projective
bundles*, arXiv:2307.03696v4 (2026), Proposition 5.6 and Section 5.8,
especially equation (5.11).  The supplied blowup formula is the corresponding
consequence consumed from Hiroshi Iritani, *Quantum cohomology of blowups*,
arXiv:2307.13555v3 (2025), Theorem 5.18 and Section 5.8.2.  The multiplicity
equalities below are manuscript consequences of those comparison results,
not verbatim statements from the cited sources.  This
module does not construct varieties, quantum connections, minimal models,
projective bundles, blowups, Novikov rings, divisor tags, or the supplied
classification and operation formulas.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

/-- Geometric and monodromy data used by the low-dimensional vanishing
deduction.  The predicates and operations are supplied abstractly; in the
manuscript they represent points, smooth projective curves and surfaces,
their standard projective bundles and point blowups, and their intrinsic and
specialized framed quantum monodromies. -/
structure LowDimensionalVanishingGeometry (Object : Type*) where
  /-- Predicate selecting points, smooth projective curves, and smooth
  projective surfaces. -/
  isPointCurveOrSurface : Object → Prop
  /-- Predicate selecting the low-dimensional objects with nef canonical
  class to which the regular-singular argument applies. -/
  isNefSeed : Object → Prop
  /-- The distinguished point object. -/
  point : Object
  /-- Relation asserting that a total object is a projective bundle of the
  supplied positive rank over a base object. -/
  IsProjectiveBundle : ℕ → Object → Object → Prop
  /-- Relation asserting that a total object is the blowup of a surface base
  at a point. -/
  IsPointBlowup : Object → Object → Prop
  /-- Strictly Novikov-admissible specializations attached to an object. -/
  Specialization : Object → Type*
  /-- Predicate asserting strict Novikov admissibility of a specialization. -/
  isStrictlyNovikovAdmissible :
    (object : Object) → Specialization object → Prop
  /-- Intrinsic generic framed-monodromy matrix of an object. -/
  intrinsicMonodromy : Object → Quantum.FramedMonodromyMatrix
  /-- Framed-monodromy matrix after a supplied specialization. -/
  specializedMonodromy :
    (object : Object) → Specialization object → Quantum.FramedMonodromyMatrix

/-- Inductive form of the low-dimensional classification used by the
vanishing proof.  Projective bundles may have any supplied positive rank;
the manuscript uses ranks two and three. -/
inductive LowDimensionalConstruction
    {Object : Type*} (geometry : LowDimensionalVanishingGeometry Object) :
    Object → Prop
  | nefSeed {object : Object} :
      geometry.isNefSeed object → LowDimensionalConstruction geometry object
  | point : LowDimensionalConstruction geometry geometry.point
  | projectiveBundle (rank : ℕ) (positiveRank : 0 < rank)
      {base total : Object} :
      geometry.IsProjectiveBundle rank base total →
      LowDimensionalConstruction geometry base →
        LowDimensionalConstruction geometry total
  | blowupAtPoint {base total : Object} :
      geometry.IsPointBlowup base total →
      LowDimensionalConstruction geometry base →
        LowDimensionalConstruction geometry total

/-- External geometric and comparison premises used in the manuscript's
low-dimensional proof.  Each premise is stated only at the strength consumed
by the deductive assembly. -/
structure LowDimensionalVanishingInput
    {Object : Type*} (geometry : LowDimensionalVanishingGeometry Object) where
  /-- Every selected point, curve, or surface has a construction witness of
  the form used by the minimal-model classification argument. -/
  classification : ∀ object,
    geometry.isPointCurveOrSurface object →
      LowDimensionalConstruction geometry object
  /-- Every characteristic root of the intrinsic monodromy of a nef seed has
  square one. -/
  nefSeedCharacteristicRootsSqEqOne : ∀ object,
    geometry.isNefSeed object → ∀ value : ℂ,
      (geometry.intrinsicMonodromy object).operator.charpoly.IsRoot value →
        value ^ 2 = 1
  /-- The point object has zero intrinsic primitive-sixth multiplicity. -/
  pointMultiplicityZero :
    (geometry.intrinsicMonodromy geometry.point).sixthMultiplicity = 0
  /-- The intrinsic projective-bundle formula multiplies primitive-sixth
  multiplicity by the bundle rank. -/
  projectiveBundleFormula : ∀ rank, 0 < rank → ∀ base total,
    geometry.IsProjectiveBundle rank base total →
      (geometry.intrinsicMonodromy total).sixthMultiplicity =
      rank * (geometry.intrinsicMonodromy base).sixthMultiplicity
  /-- A point blowup preserves intrinsic primitive-sixth multiplicity; this is
  the point-center specialization of the blowup formula after point
  multiplicity vanishes. -/
  blowupAtPointFormula : ∀ base total,
    geometry.IsPointBlowup base total →
      (geometry.intrinsicMonodromy total).sixthMultiplicity =
      (geometry.intrinsicMonodromy base).sixthMultiplicity
  /-- Divisor tagging transfers intrinsic vanishing to every strictly
  Novikov-admissible specialization. -/
  specializationVanishing : ∀ object
      (specialization : geometry.Specialization object),
    geometry.isStrictlyNovikovAdmissible object specialization →
      (geometry.intrinsicMonodromy object).sixthMultiplicity = 0 →
        (geometry.specializedMonodromy object
          specialization).sixthMultiplicity = 0

/-- Intrinsic primitive-sixth multiplicity vanishes for every object carrying
the supplied low-dimensional construction witness. -/
theorem intrinsicLowDimensionalMultiplicity_eq_zero
    {Object : Type*} (geometry : LowDimensionalVanishingGeometry Object)
    (input : LowDimensionalVanishingInput geometry) {object : Object}
    (construction : LowDimensionalConstruction geometry object) :
    (geometry.intrinsicMonodromy object).sixthMultiplicity = 0 := by
  induction construction with
  | @nefSeed object nef =>
      exact (geometry.intrinsicMonodromy object).sixthMultiplicity_eq_zero_of_roots_sq_eq_one
        (input.nefSeedCharacteristicRootsSqEqOne object nef)
  | point => exact input.pointMultiplicityZero
  | projectiveBundle rank positiveRank bundle baseConstruction inductionHypothesis =>
      rw [input.projectiveBundleFormula rank positiveRank _ _ bundle]
      simp [inductionHypothesis]
  | blowupAtPoint blowup baseConstruction inductionHypothesis =>
      rw [input.blowupAtPointFormula _ _ blowup]
      exact inductionHypothesis

/-- Conditional form of low-dimensional vanishing: for every supplied point,
smooth projective curve, or smooth projective surface and every strictly
Novikov-admissible specialization, the specialized framed monodromy has zero
primitive-sixth multiplicity. -/
theorem lowDimensionalMultiplicity_eq_zero_of_classification_and_tagging
    {Object : Type*} (geometry : LowDimensionalVanishingGeometry Object)
    (input : LowDimensionalVanishingInput geometry) :
    ∀ object, geometry.isPointCurveOrSurface object →
      ∀ specialization : geometry.Specialization object,
        geometry.isStrictlyNovikovAdmissible object specialization →
          (geometry.specializedMonodromy object
            specialization).sixthMultiplicity = 0 := by
  intro object lowDimensional specialization admissible
  apply input.specializationVanishing object specialization admissible
  exact intrinsicLowDimensionalMultiplicity_eq_zero geometry input
    (input.classification object lowDimensional)

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
