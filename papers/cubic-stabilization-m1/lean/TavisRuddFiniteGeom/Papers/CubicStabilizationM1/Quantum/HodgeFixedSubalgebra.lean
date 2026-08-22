import Mathlib.Tactic
import Mathlib.RingTheory.AdjoinRoot

/-!
# The fixed subalgebra of an equivariant multiplication, and the truncated
algebra of a hyperplane class

The manuscript restricts the quantum product to the locus fixed by the Hodge
action, and needs three things there: that the fixed locus is closed under the
multiplication and contains the unit, that multiplication by a fixed element
preserves it so that the Euler endomorphism of the restriction is the
restriction of the ambient one, and that for a smooth cubic threefold the
resulting algebra is four-dimensional, spanned by the powers of the hyperplane
class.

This module proves the algebra of those three steps.  Given a family of algebra
automorphisms of a commutative algebra, its simultaneous fixed points form a
subalgebra; multiplication by a fixed element maps it to itself, and the
restricted multiplication is the multiplication of the subalgebra, so an
eigenvector of the restriction is an eigenvector of the ambient multiplication
with the same eigenvalue.  The powers of a fixed element are fixed, so their span
lies in the fixed subalgebra, and a linearly independent family of the first four
powers spans a four-dimensional subspace.  The truncated polynomial algebra in
one variable of exponent four, the algebra the manuscript obtains for a cubic
threefold from the Lefschetz theorem, is exhibited as an instance: its
distinguished element has vanishing fourth power and it is four-dimensional over
the base field.

Lean constructs no cohomology, no `F`-bundle, and no quantum product, and does
not prove that the Hodge-fixed locus of the maximal `A`-model `F`-bundle is
smooth, that its tangent space is the span of the rational classes of Hodge type
`(i, i)`, or that for a cubic threefold that span is the even cohomology.  Those
are the geometric inputs of the manuscript's lemma; here they appear as the
hypotheses that the action is by algebra automorphisms and that the four powers
of the distinguished element are linearly independent.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

section FixedSubalgebra

variable {G K A : Type*} [CommRing K] [CommRing A] [Algebra K A]

/-- The simultaneous fixed points of a family of algebra automorphisms, as a
subalgebra.  It contains the unit and the image of the base ring, and is closed
under addition and multiplication, because each member of the family is an
algebra homomorphism. -/
def fixedSubalgebra (action : G → (A ≃ₐ[K] A)) : Subalgebra K A where
  carrier := {a : A | ∀ g : G, action g a = a}
  mul_mem' := fun ha hb g => by rw [map_mul, ha g, hb g]
  one_mem' := fun g => map_one (action g)
  add_mem' := fun ha hb g => by rw [map_add, ha g, hb g]
  zero_mem' := fun g => map_zero (action g)
  algebraMap_mem' := fun r g => AlgEquiv.commutes (action g) r

/-- Membership in the fixed subalgebra is fixedness under every member of the
family. -/
theorem mem_fixedSubalgebra {action : G → (A ≃ₐ[K] A)} {a : A} :
    a ∈ fixedSubalgebra action ↔ ∀ g : G, action g a = a :=
  Iff.rfl

/-- Multiplication by a fixed element maps the fixed subalgebra to itself, so it
restricts to an endomorphism of the fixed subalgebra. -/
theorem mul_mem_fixedSubalgebra {action : G → (A ≃ₐ[K] A)} {E a : A}
    (hE : E ∈ fixedSubalgebra action) (ha : a ∈ fixedSubalgebra action) :
    E * a ∈ fixedSubalgebra action :=
  Subalgebra.mul_mem _ hE ha

/-- The restricted multiplication is the multiplication of the fixed subalgebra:
the product computed inside the subalgebra is the ambient product of the
representatives. -/
theorem coe_mul_fixedSubalgebra {action : G → (A ≃ₐ[K] A)} {E : A}
    (hE : E ∈ fixedSubalgebra action) (a : fixedSubalgebra action) :
    (((⟨E, hE⟩ : fixedSubalgebra action) * a : fixedSubalgebra action) : A) = E * (a : A) :=
  rfl

/-- An eigenvector of multiplication by a fixed element inside the fixed
subalgebra is an eigenvector of the ambient multiplication with the same
eigenvalue.  This is the sense in which the Euler endomorphism of the restricted
multiplication is the restriction of the ambient Euler endomorphism. -/
theorem eigenvector_of_fixedSubalgebra {action : G → (A ≃ₐ[K] A)} {E : A}
    (hE : E ∈ fixedSubalgebra action) {lam : K} {a : fixedSubalgebra action} (ha : a ≠ 0)
    (eigen : (⟨E, hE⟩ : fixedSubalgebra action) * a = lam • a) :
    (a : A) ≠ 0 ∧ E * (a : A) = lam • (a : A) := by
  refine ⟨fun contradiction => ha (Subtype.ext contradiction), ?_⟩
  have transported := congrArg (Subtype.val : fixedSubalgebra action → A) eigen
  simpa using transported

/-- The powers of a fixed element are fixed, so the subspace they span lies in
the fixed subalgebra. -/
theorem span_powers_le_fixedSubalgebra {action : G → (A ≃ₐ[K] A)} {P : A}
    (hP : P ∈ fixedSubalgebra action) :
    Submodule.span K (Set.range fun i : Fin 4 => P ^ (i : ℕ)) ≤
      Subalgebra.toSubmodule (fixedSubalgebra action) := by
  rw [Submodule.span_le]
  rintro _ ⟨i, rfl⟩
  exact pow_mem hP (i : ℕ)

end FixedSubalgebra

section HyperplanePowers

variable {K A : Type*} [Field K] [Ring A] [Algebra K A]

/-- Four linearly independent powers of an element span a four-dimensional
subspace.  For a smooth cubic threefold the manuscript obtains the Hodge-fixed
tangent space as the span of the first four powers of the hyperplane class, and
this is the resulting dimension count. -/
theorem finrank_span_powers_eq_four {P : A}
    (independent : LinearIndependent K fun i : Fin 4 => P ^ (i : ℕ)) :
    Module.finrank K (Submodule.span K (Set.range fun i : Fin 4 => P ^ (i : ℕ))) = 4 := by
  rw [finrank_span_eq_card independent, Fintype.card_fin]

end HyperplanePowers

section TruncatedAlgebra

open Polynomial

variable (K : Type*) [Field K]

/-- The fourth power of the distinguished element of the truncated polynomial
algebra of exponent four vanishes. -/
theorem adjoinRoot_root_pow_four_eq_zero :
    (AdjoinRoot.root (X ^ 4 : K[X])) ^ 4 = 0 := by
  rw [← AdjoinRoot.mk_X, ← map_pow, AdjoinRoot.mk_self]

/-- The truncated polynomial algebra of exponent four is four-dimensional over
the base field.  It is the algebra structure the manuscript reads on the even
cohomology of a smooth cubic threefold, where the distinguished element is the
hyperplane class; that identification is a geometric input and is not proved
here. -/
theorem finrank_adjoinRoot_pow_four :
    Module.finrank K (AdjoinRoot (X ^ 4 : K[X])) = 4 := by
  have nonzero : (X ^ 4 : K[X]) ≠ 0 := pow_ne_zero 4 (X_ne_zero (R := K))
  have dimension := (AdjoinRoot.powerBasis nonzero).finrank
  rw [AdjoinRoot.powerBasis_dim, natDegree_X_pow] at dimension
  exact dimension

end TruncatedAlgebra

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
