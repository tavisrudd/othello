import Mathlib.Algebra.Module.Torsion.Free
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.FieldTheory.Finite.Basic
import Mathlib.Tactic

/-!
# The first finite-field root defect

Let `K` be a finite field of cardinality `q`.  A polynomial that vanishes at every element of
`K` is divisible by `X ^ q - X`.  If its degree is below `2 * q`, the quotient has degree below
`q`.  The coordinatewise form gives the same conclusion for a polynomial with values in a
finite-dimensional vector space after a basis has been chosen.

The final two lemmas isolate the cancellation used by a root-action cocycle.  Once a defect and
its quotient are related by a nonzero common factor, any linear translation identity for the
defect descends to the quotient.  The same argument proves equivariance of the constant quotient
vector.  These statements require only torsion-freeness; representation-specific root actions are
not assumed here.
-/

namespace RelativeConicArcs.ClebschRootDefect

open Polynomial

noncomputable section

variable (K : Type*) [Field K] [Fintype K]

/-- The monic polynomial whose roots are all elements of the finite field `K`. -/
def finiteFieldVanishingPolynomial : K[X] :=
  X ^ Fintype.card K - X

/-- The finite-field vanishing polynomial has degree `#K`. -/
@[simp] theorem finiteFieldVanishingPolynomial_natDegree :
    (finiteFieldVanishingPolynomial K).natDegree = Fintype.card K := by
  simpa [finiteFieldVanishingPolynomial] using
    (FiniteField.X_pow_card_sub_X_natDegree_eq K
      (Fintype.one_lt_card : 1 < Fintype.card K))

/-- The finite-field vanishing polynomial is monic. -/
theorem finiteFieldVanishingPolynomial_monic :
    (finiteFieldVanishingPolynomial K).Monic := by
  apply monic_X_pow_sub
  rw [degree_X]
  exact_mod_cast (Fintype.one_lt_card : 1 < Fintype.card K)

/-- Every element of `K` is a root of `X ^ (#K) - X`. -/
@[simp] theorem eval_finiteFieldVanishingPolynomial (a : K) :
    (finiteFieldVanishingPolynomial K).eval a = 0 := by
  simp [finiteFieldVanishingPolynomial, FiniteField.pow_card]

/-- A scalar polynomial vanishing on the whole finite field is divisible by
`X ^ (#K) - X`. -/
theorem finiteFieldVanishingPolynomial_dvd_of_eval_eq_zero
    (D : K[X]) (hD : ∀ a : K, D.eval a = 0) :
    finiteFieldVanishingPolynomial K ∣ D := by
  let f := finiteFieldVanishingPolynomial K
  have hfmonic : f.Monic := finiteFieldVanishingPolynomial_monic K
  rw [← modByMonic_eq_zero_iff_dvd hfmonic]
  let r := D %ₘ f
  have hreval : ∀ a : K, r.eval a = 0 := by
    intro a
    have hdecomp := congrArg (fun P : K[X] ↦ P.eval a) (modByMonic_add_div D f)
    simpa [r, f, hD a] using hdecomp
  apply Polynomial.eq_zero_of_natDegree_lt_card_of_eval_eq_zero
    r Function.injective_id hreval
  have hf_ne_one : f ≠ 1 := by
    intro h
    have hdegree := congrArg Polynomial.natDegree h
    rw [show f.natDegree = Fintype.card K by simp [f], natDegree_one] at hdegree
    exact (Nat.ne_of_gt (Fintype.card_pos : 0 < Fintype.card K)) hdegree
  have hrdegree := natDegree_modByMonic_lt D hfmonic hf_ne_one
  simpa [r, f] using hrdegree

/-- Below degree `2 * #K`, finite-field vanishing has a quotient of degree below `#K`.
The displayed quotient is the monic-division quotient, so the factorization is canonical. -/
theorem finiteFieldVanishing_factorization_of_natDegree_lt_two_mul
    (D : K[X]) (hD : ∀ a : K, D.eval a = 0)
    (hdegree : D.natDegree < 2 * Fintype.card K) :
    ∃ B : K[X],
      D = finiteFieldVanishingPolynomial K * B ∧
        B.natDegree < Fintype.card K := by
  let f := finiteFieldVanishingPolynomial K
  let B := D /ₘ f
  have hfmonic : f.Monic := finiteFieldVanishingPolynomial_monic K
  have hdiv : f ∣ D :=
    finiteFieldVanishingPolynomial_dvd_of_eval_eq_zero K D hD
  have hmod : D %ₘ f = 0 :=
    (modByMonic_eq_zero_iff_dvd hfmonic).2 hdiv
  refine ⟨B, ?_, ?_⟩
  · have hdecomp := modByMonic_add_div D f
    rw [hmod, zero_add] at hdecomp
    exact hdecomp.symm
  · have hquotient := natDegree_divByMonic D hfmonic
    change (D /ₘ f).natDegree < Fintype.card K
    rw [hquotient, finiteFieldVanishingPolynomial_natDegree]
    omega

/-- Coordinatewise finite-field factorization.  Choosing a basis of a finite-dimensional vector
space identifies a vector-valued polynomial with such a finite family of scalar polynomials; this
theorem then supplies one quotient polynomial in every coordinate, with the uniform degree bound
needed to reconstruct the vector-valued quotient. -/
theorem finiteCoordinate_vanishing_factorization
    {I : Type*} [Fintype I] (D : I → K[X])
    (hD : ∀ i a, (D i).eval a = 0)
    (hdegree : ∀ i, (D i).natDegree < 2 * Fintype.card K) :
    ∃ B : I → K[X], ∀ i,
      D i = finiteFieldVanishingPolynomial K * B i ∧
        (B i).natDegree < Fintype.card K := by
  choose B hB using fun i ↦
    finiteFieldVanishing_factorization_of_natDegree_lt_two_mul
      K (D i) (hD i) (hdegree i)
  exact ⟨B, hB⟩

section RootActionCancellation

variable {R M : Type*} [CommRing R] [IsDomain R]
  [AddCommGroup M] [Module R M] [Module.IsTorsionFree R M]

/-- Cancel a nonzero scalar common to two vectors in a torsion-free module. -/
theorem cancel_common_factor {f : R} (hf : f ≠ 0) {x y : M}
    (h : f • x = f • y) : x = y :=
  smul_right_injective M hf h

/-- A translated root defect determines the translation law of its quotient.  The maps model
translation in the root parameter and the right source action.  Linearity moves the common
vanishing factor through both maps, and torsion-freeness cancels it. -/
theorem quotient_translation_of_factored_cocycle
    (translate rightAction : M →ₗ[R] M) {f : R} (hf : f ≠ 0) {D B : M}
    (hfactor : D = f • B)
    (hcocycle : translate D = rightAction D) :
    translate B = rightAction B := by
  apply cancel_common_factor hf
  rw [← translate.map_smul, ← rightAction.map_smul, ← hfactor]
  exact hcocycle

/-- A factored root-cocycle identity forces equivariance of its constant quotient vector.  This is
the cancellation step after the positive-root defect has been written as the finite-field
vanishing polynomial times a constant vector followed by the source root action. -/
theorem beta_equivariant_of_factored_root_cocycle
    (leftAction rightAction : M →ₗ[R] M) {f : R} (hf : f ≠ 0) {D beta : M}
    (hfactor : D = f • beta)
    (hcocycle : leftAction D = rightAction D) :
    leftAction beta = rightAction beta :=
  quotient_translation_of_factored_cocycle
    leftAction rightAction hf hfactor hcocycle

end RootActionCancellation

end

end RelativeConicArcs.ClebschRootDefect
