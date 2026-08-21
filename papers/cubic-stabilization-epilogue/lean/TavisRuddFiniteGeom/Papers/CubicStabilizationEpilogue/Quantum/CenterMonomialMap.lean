import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.MonomialSpecializationSeparation
import Mathlib.Algebra.MonoidAlgebra.Basic
import Mathlib.LinearAlgebra.Finsupp.VectorSpace

/-!
# Coefficient-one monomial model for a center exponent map

A center Novikov specialization arising from a blowup comparison is expected to
send a center curve class to the monomial indexed by its ambient numerical class
and exceptional exponent.  This module formalizes the algebra after that
additive exponent map has been supplied: every class maps to the canonical
monomial with coefficient one, the map respects addition, and those target
monomials are linearly independent.

No blowup, numerical curve lattice, filtration, completion, associated-graded
identification, or Iritani comparison is constructed here.  In particular, the
geometric assertion that a given center specialization induces the supplied
exponent map is not a conclusion of this module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

variable {CenterDegree TargetExponent : Type*}
variable [AddCommMonoid CenterDegree] [AddCommMonoid TargetExponent]

/-- The coefficient-one monomial attached to the target exponent of a center
curve class. -/
noncomputable def centerMonomialImage
    (exponent : CenterDegree →+ TargetExponent) (degree : CenterDegree) :
    AddMonoidAlgebra ℂ TargetExponent :=
  AddMonoidAlgebra.single (exponent degree) 1

/-- The zero curve class maps to the unit monomial. -/
@[simp]
theorem centerMonomialImage_zero
    (exponent : CenterDegree →+ TargetExponent) :
    centerMonomialImage exponent 0 = 1 := by
  simp [centerMonomialImage, AddMonoidAlgebra.one_def]

/-- Addition of curve classes becomes multiplication of their coefficient-one
target monomials. -/
@[simp]
theorem centerMonomialImage_add
    (exponent : CenterDegree →+ TargetExponent)
    (left right : CenterDegree) :
    centerMonomialImage exponent (left + right) =
      centerMonomialImage exponent left * centerMonomialImage exponent right := by
  simp [centerMonomialImage]

omit [AddCommMonoid TargetExponent] in
/-- The coefficient-one monomials of an additive-monoid algebra are linearly
independent over the coefficient field. -/
lemma centerTargetMonomials_linearIndependent :
    LinearIndependent ℂ
      (fun target : TargetExponent =>
        AddMonoidAlgebra.single target (1 : ℂ)) :=
  Finsupp.linearIndependent_single_one (ι := TargetExponent) (R := ℂ)

/-- Algebraic graded-monomial certificate for a supplied center exponent map.
The leading-term map is the identity on the modeled associated graded target,
and every effective class lands in the canonical coefficient-one monomial
family. -/
noncomputable def centerMonomialMap_monomialSpecializationData
    (exponent : CenterDegree →+ TargetExponent) :
    MonomialSpecializationData
      (leadingTerm := id)
      (monomialImage := centerMonomialImage exponent)
      (monomial :=
        fun target : TargetExponent =>
          AddMonoidAlgebra.single target (1 : ℂ)) where
  index := exponent
  independent := centerTargetMonomials_linearIndependent
  leadingTerm_zero := rfl
  leadingTerm_monomialImage := fun _ => rfl

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
