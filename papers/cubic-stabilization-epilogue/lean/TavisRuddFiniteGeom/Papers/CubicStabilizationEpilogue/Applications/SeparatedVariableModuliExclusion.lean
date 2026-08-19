import Mathlib.Tactic

/-!
# The separated-variable locus of a family in coarse moduli

A cubic threefold is of separated-variable type when its defining form is a sum
of cubic forms in pairwise disjoint nonempty groups of at most three variables.
Such a cubic carries an Eckardt point, and carrying one is invariant under
projective equivalence, so a member of a family that is projectively equivalent
to a separated-variable cubic lies in the family's Eckardt locus.  When that
locus is known to consist of the members over a single moduli point, the moduli
points represented by separated-variable cubics are exactly that one point.

This module records that deduction with each of its three inputs — the Eckardt
point of a separated-variable cubic, projective invariance of carrying one, and
the Eckardt locus of the family — as an explicit typed premise, together with a
witness that the distinguished point is itself represented.  No cubic form,
Eckardt point, projective equivalence, family, or coarse moduli space is
constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

/-- A variety is represented by a cubic of separated-variable type when some
cubic of that type is projectively equivalent to it. -/
def RepresentedBySeparatedVariable {Variety : Type*}
    (separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop) (variety : Variety) : Prop :=
  ∃ model, separatedVariableType model ∧ projectivelyEquivalent model variety

/-- Inputs for the separated-variable exclusion along a family: a
separated-variable cubic carries an Eckardt point, carrying one is invariant
under projective equivalence, every member carrying one has the distinguished
moduli point, and that point is represented by a separated-variable cubic. -/
structure SeparatedVariableModuliInput
    {Base Variety Moduli : Type*}
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli) : Prop where
  /-- A cubic threefold of separated-variable type carries an Eckardt point. -/
  separatedVariable_hasEckardtPoint :
    ∀ variety, separatedVariableType variety → hasEckardtPoint variety
  /-- Carrying an Eckardt point is invariant under projective equivalence. -/
  eckardtPoint_projectivelyInvariant :
    ∀ source target, projectivelyEquivalent source target →
      hasEckardtPoint source → hasEckardtPoint target
  /-- The Eckardt locus of the family lies over the distinguished moduli
  point. -/
  eckardtLocus_eq_distinguishedPoint :
    ∀ parameter, hasEckardtPoint (fibre parameter) →
      moduliPoint parameter = distinguishedPoint
  /-- The distinguished moduli point is represented by a member that is
  projectively equivalent to a separated-variable cubic. -/
  distinguishedPoint_represented :
    ∃ parameter, moduliPoint parameter = distinguishedPoint ∧
      RepresentedBySeparatedVariable separatedVariableType projectivelyEquivalent
        (fibre parameter)

/-- The moduli points of the family represented by a cubic of separated-variable
type are exactly the distinguished one.  Both directions are stated: a member
represented by such a cubic has the distinguished moduli point, and that point
is attained. -/
theorem separatedVariableModuli_eq_distinguishedPoint
    {Base Variety Moduli : Type*}
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli)
    (input : SeparatedVariableModuliInput fibre moduliPoint hasEckardtPoint
      separatedVariableType projectivelyEquivalent distinguishedPoint) :
    (∀ parameter,
        RepresentedBySeparatedVariable separatedVariableType
            projectivelyEquivalent (fibre parameter) →
          moduliPoint parameter = distinguishedPoint) ∧
      ∃ parameter, moduliPoint parameter = distinguishedPoint ∧
        RepresentedBySeparatedVariable separatedVariableType
          projectivelyEquivalent (fibre parameter) := by
  refine ⟨fun parameter represented ↦ ?_, input.distinguishedPoint_represented⟩
  obtain ⟨model, separated, equivalence⟩ := represented
  exact input.eckardtLocus_eq_distinguishedPoint parameter
    (input.eckardtPoint_projectivelyInvariant model (fibre parameter) equivalence
      (input.separatedVariable_hasEckardtPoint model separated))

/-- Every moduli point of the family other than the distinguished one is
represented by no cubic of separated-variable type, which is the form in which
the separation statement uses the exclusion. -/
theorem not_representedBySeparatedVariable_of_ne_distinguishedPoint
    {Base Variety Moduli : Type*}
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli)
    (input : SeparatedVariableModuliInput fibre moduliPoint hasEckardtPoint
      separatedVariableType projectivelyEquivalent distinguishedPoint)
    (parameter : Base) (distinct : moduliPoint parameter ≠ distinguishedPoint) :
    ¬ RepresentedBySeparatedVariable separatedVariableType projectivelyEquivalent
      (fibre parameter) := by
  intro represented
  exact distinct ((separatedVariableModuli_eq_distinguishedPoint fibre moduliPoint
    hasEckardtPoint separatedVariableType projectivelyEquivalent
    distinguishedPoint input).1 parameter represented)

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
