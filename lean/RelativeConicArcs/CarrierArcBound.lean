import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.RingTheory.Coprime.Lemmas
import Mathlib.RingTheory.Polynomial.UniqueFactorization

/-!
# Detection and nonsquareness for square-root carrier bounds

This module formalizes two algebraic endpoints of the square-root carrier argument.  First, a
nonzero multivariable polynomial divisible by a pairwise relatively prime family of nonzero
degree-one forms has total degree at least the size of that family.  Second, a nonunit squarefree
element of a commutative monoid cannot be a square.

The final theorem composes linewise square roots, extension to one ambient root, bounded-degree
joint detection, and ambient nonsquareness into a cardinality bound for a finite carrier family.
The extension induction is also formalized: a correction that fixes one new restriction while
vanishing on all restrictions already treated produces a simultaneous extension over any finite
family.  The module is independent of the geometric construction of such corrections.
-/

namespace RelativeConicArcs

open scoped BigOperators Function

section FiniteRestrictionExtension

variable {A B P : Type*} [AddCommMonoid A] [AddCommMonoid B] [DecidableEq P]

/-- If one can correct any partial extension at one new index without changing the indices already
treated, then every finite family of prescribed restrictions has a simultaneous extension. -/
theorem exists_finset_extension_of_single_correction
    (restriction : P → A →+ B) (root : P → B)
    (hcorrect :
      ∀ (s : Finset P) (x : P) (G : A), x ∉ s →
        (∀ y ∈ s, restriction y G = root y) →
        ∃ D : A,
          (∀ y ∈ s, restriction y D = 0) ∧
          restriction x (G + D) = root x) :
    ∀ s : Finset P, ∃ G : A, ∀ x ∈ s, restriction x G = root x := by
  intro s
  induction s using Finset.induction_on with
  | empty =>
      exact ⟨0, by simp⟩
  | @insert x s hx ih =>
      obtain ⟨G, hG⟩ := ih
      obtain ⟨D, hD, hxD⟩ := hcorrect s x G hx hG
      refine ⟨G + D, ?_⟩
      intro y hy
      rw [Finset.mem_insert] at hy
      rcases hy with rfl | hy
      · exact hxD
      · rw [map_add, hD y hy, add_zero]
        exact hG y hy

end FiniteRestrictionExtension

section FintypeProductDegree

variable {K σ ι : Type*} [Field K] [Fintype ι]

/-- The total degree of a finite product of nonzero multivariable polynomials over a field is the
sum of their total degrees. -/
theorem totalDegree_fintypeProd_of_ne_zero
    (factor : ι → MvPolynomial σ K) (hne : ∀ i, factor i ≠ 0) :
    (∏ i, factor i).totalDegree = ∑ i, (factor i).totalDegree := by
  classical
  have hfinset :
      ∀ s : Finset ι,
        (∏ i ∈ s, factor i).totalDegree =
          ∑ i ∈ s, (factor i).totalDegree := by
    intro s
    induction s using Finset.induction_on with
    | empty => simp
    | @insert a s ha ih =>
        rw [Finset.prod_insert ha, Finset.sum_insert ha,
          MvPolynomial.totalDegree_mul_of_isDomain (hne a)]
        · exact congrArg ((factor a).totalDegree + ·) ih
        · exact Finset.prod_ne_zero_iff.mpr fun i _ => hne i
  simpa using hfinset Finset.univ

/-- If each member of a finite nonzero polynomial family has total degree one, their product has
total degree equal to the cardinality of the family. -/
theorem totalDegree_fintypeProd_eq_card_of_degree_one
    (factor : ι → MvPolynomial σ K) (hne : ∀ i, factor i ≠ 0)
    (hdegree : ∀ i, (factor i).totalDegree = 1) :
    (∏ i, factor i).totalDegree = Fintype.card ι := by
  rw [totalDegree_fintypeProd_of_ne_zero factor hne]
  simp only [hdegree, Finset.sum_const, Finset.card_univ, smul_eq_mul, mul_one]

end FintypeProductDegree

section LineProductDetection

variable {K σ ι : Type*} [Field K] [Fintype ι]

/-- A polynomial of total degree smaller than a pairwise relatively prime family of degree-one
divisors must vanish.  This is the algebraic line-product detection principle. -/
theorem eq_zero_of_pairwise_isRelPrime_dvd_of_totalDegree_lt_card
    (lineEquation : ι → MvPolynomial σ K)
    (hcoprime : Pairwise (IsRelPrime on lineEquation))
    (hne : ∀ i, lineEquation i ≠ 0)
    (hdegree : ∀ i, (lineEquation i).totalDegree = 1)
    (F : MvPolynomial σ K)
    (hdiv : ∀ i, lineEquation i ∣ F)
    (hcard : F.totalDegree < Fintype.card ι) :
    F = 0 := by
  by_contra hF
  have hproddiv : (∏ i, lineEquation i) ∣ F :=
    Fintype.prod_dvd_of_isRelPrime hcoprime hdiv
  have hdegree_le :=
    MvPolynomial.totalDegree_le_of_dvd_of_isDomain hproddiv hF
  rw [totalDegree_fintypeProd_eq_card_of_degree_one
    lineEquation hne hdegree] at hdegree_le
  omega

end LineProductDetection

section SquarefreeNonsquare

variable {R : Type*} [CommMonoid R]

/-- A squarefree nonunit cannot be a square. -/
theorem not_exists_eq_sq_of_squarefree_of_not_isUnit
    {F : R} (hfree : Squarefree F) (hunit : ¬IsUnit F) :
    ¬∃ G : R, F = G ^ 2 := by
  rintro ⟨G, rfl⟩
  have hGunit : ¬IsUnit G := by
    intro h
    exact hunit (h.pow 2)
  rcases hfree.eq_zero_or_one_of_pow_of_not_isUnit hGunit with h | h <;> omega

end SquarefreeNonsquare

section SquarefreeProductNonsquare

variable {R ι : Type*} [CommMonoidWithZero R] [IsCancelMulZero R]
  [DecompositionMonoid R] [Fintype ι]

/-- A nonunit product of pairwise relatively prime squarefree factors cannot be a square. -/
theorem not_exists_fintypeProd_eq_sq_of_pairwise_isRelPrime_of_squarefree
    (factor : ι → R)
    (hcoprime : Pairwise (IsRelPrime on factor))
    (hfactor : ∀ i, Squarefree (factor i))
    (hunit : ¬IsUnit (∏ i, factor i)) :
    ¬∃ G : R, ∏ i, factor i = G ^ 2 := by
  apply not_exists_eq_sq_of_squarefree_of_not_isUnit
  · simpa using
      (Finset.squarefree_prod_of_pairwise_isCoprime
        (s := Finset.univ) (f := factor)
        (by
          intro i _ j _ hij
          exact hcoprime hij)
        (fun i _ => hfactor i))
  · exact hunit

end SquarefreeProductNonsquare

section CarrierCardinality

variable {A B P : Type*} [CommSemiring A] [CommSemiring B]

/-- If linewise square roots extend to one ambient element, and more than `degreeBound` carrier
restrictions jointly detect ambient elements, then ambient nonsquareness bounds the carrier
family by `degreeBound`. -/
theorem card_le_of_linewiseSquareRoots_extend_and_jointlyDetect
    (restriction : P → A →+* B) (F : A) (Y : Finset P)
    (root : P → B) (degreeBound : ℕ)
    (hsquare : ∀ x ∈ Y, restriction x F = (root x) ^ 2)
    (hextend : ∃ G : A, ∀ x ∈ Y, restriction x G = root x)
    (hdetect :
      degreeBound < Y.card →
        ∀ a b : A,
          (∀ x : {x // x ∈ Y}, restriction x.1 a = restriction x.1 b) →
            a = b)
    (hnonsquare : ¬∃ G : A, F = G ^ 2) :
    Y.card ≤ degreeBound := by
  by_contra hcard
  have hlarge : degreeBound < Y.card := by omega
  let restrictedRoot : {x // x ∈ Y} → B := fun x => root x.1
  have hsquare' :
      ∀ x : {x // x ∈ Y},
        restriction x.1 F = (restrictedRoot x) ^ 2 := by
    intro x
    exact hsquare x.1 x.2
  have hextend' :
      ∃ G : A, ∀ x : {x // x ∈ Y},
        restriction x.1 G = restrictedRoot x := by
    obtain ⟨G, hG⟩ := hextend
    exact ⟨G, fun x => hG x.1 x.2⟩
  obtain ⟨G, hG⟩ := hextend'
  apply hnonsquare
  refine ⟨G, (hdetect hlarge) F (G ^ 2) ?_⟩
  intro x
  rw [map_pow, hG x, hsquare' x]

end CarrierCardinality

section PolynomialCarrierCardinality

variable {K σ B P : Type*} [Field K] [CommSemiring B]

/-- Let `F` be a multivariable polynomial whose restrictions to a finite family are squares.
Suppose the chosen roots extend to one polynomial `G`.  If equality of the restrictions of `F`
and `G²` makes the corresponding pairwise relatively prime degree-one equations divide `F - G²`,
and every such difference has total degree at most `degreeBound`, then nonsquareness of `F` bounds
the family by `degreeBound`. -/
theorem card_le_of_linewiseSquareRoots_extend_of_lineProductDetection
    (restriction : P → MvPolynomial σ K →+* B)
    (lineEquation : P → MvPolynomial σ K)
    (F : MvPolynomial σ K) (Y : Finset P)
    (root : P → B) (degreeBound : ℕ)
    (hsquare : ∀ x ∈ Y, restriction x F = (root x) ^ 2)
    (hextend : ∃ G : MvPolynomial σ K, ∀ x ∈ Y, restriction x G = root x)
    (hcoprime :
      Pairwise
        (IsRelPrime on
          fun x : {x // x ∈ Y} => lineEquation x.1))
    (hne : ∀ x ∈ Y, lineEquation x ≠ 0)
    (hdegree : ∀ x ∈ Y, (lineEquation x).totalDegree = 1)
    (hvanishingDivides :
      ∀ (G : MvPolynomial σ K) (x : P), x ∈ Y →
        restriction x F = restriction x (G ^ 2) →
          lineEquation x ∣ F - G ^ 2)
    (hdifferenceDegree :
      ∀ G : MvPolynomial σ K, (F - G ^ 2).totalDegree ≤ degreeBound)
    (hnonsquare : ¬∃ G : MvPolynomial σ K, F = G ^ 2) :
    Y.card ≤ degreeBound := by
  by_contra hcard
  have hlarge : degreeBound < Y.card := by omega
  obtain ⟨G, hG⟩ := hextend
  have hdiv :
      ∀ x : {x // x ∈ Y}, lineEquation x.1 ∣ F - G ^ 2 := by
    intro x
    apply hvanishingDivides G x.1 x.2
    rw [map_pow, hG x.1 x.2, hsquare x.1 x.2]
  have hzero : F - G ^ 2 = 0 := by
    apply eq_zero_of_pairwise_isRelPrime_dvd_of_totalDegree_lt_card
      (fun x : {x // x ∈ Y} => lineEquation x.1) hcoprime
      (fun x => hne x.1 x.2) (fun x => hdegree x.1 x.2)
      (F - G ^ 2) hdiv
    simpa using lt_of_le_of_lt (hdifferenceDegree G) hlarge
  apply hnonsquare
  exact ⟨G, sub_eq_zero.mp hzero⟩

end PolynomialCarrierCardinality

end RelativeConicArcs
