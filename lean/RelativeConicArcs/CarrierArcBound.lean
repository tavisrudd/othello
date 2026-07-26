import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Algebra.MvPolynomial.Equiv
import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.Homogenize
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.RingTheory.Coprime.Lemmas
import Mathlib.RingTheory.Polynomial.UniqueFactorization

/-!
# Detection and nonsquareness for square-root carrier bounds

This module formalizes two algebraic endpoints of the square-root carrier argument.  First, a
nonzero multivariable polynomial divisible by a pairwise relatively prime family of nonzero
degree-one forms has total degree at least the size of that family, with a constant-times-product
classification at equality.  Second, a nonunit squarefree element of a commutative monoid cannot
be a square.  Restriction to a coordinate line, transported through a polynomial automorphism,
has kernel equal to the principal ideal of the transformed equation.

The terminal theorems compose linewise square roots, extension to one ambient root, bounded-degree
detection, and ambient nonsquareness into a cardinality bound, and identify the exact-threshold
difference as a constant multiple of the carrier-line product.
The extension induction is also formalized: a correction that fixes one new restriction while
vanishing on all restrictions already treated produces a simultaneous extension over any finite
family.  Surjectivity of coordinate-hyperplane restriction constructs that correction whenever
the new residual is divisible by the restricted product of the previous line equations.  The
distinct-affine-node factor theorem and its homogenized binary-form version provide the polynomial
divisibility mechanism; identifying their node factors with the restricted equations remains a
geometric hypothesis.
-/

namespace RelativeConicArcs

open scoped BigOperators Function

section DistinctPolynomialRoots

variable {K ι : Type*} [Field K] [Fintype ι]

/-- A polynomial which vanishes at a finite injectively indexed family of field elements is
divisible by the product of the corresponding distinct monic linear factors. -/
theorem fintypeProd_X_sub_C_dvd_of_injective_roots
    (node : ι → K) (hnode : Function.Injective node)
    (F : Polynomial K) (hroot : ∀ i, F.IsRoot (node i)) :
    (∏ i, (Polynomial.X - Polynomial.C (node i))) ∣ F := by
  apply Fintype.prod_dvd_of_isRelPrime
  · intro i j hij
    exact (Polynomial.pairwise_coprime_X_sub_C hnode hij).isRelPrime
  · intro i
    exact Polynomial.dvd_iff_isRoot.mpr (hroot i)

/-- Agreement of two polynomials at distinct nodes makes their difference divisible by the product
of the corresponding node factors. -/
theorem fintypeProd_X_sub_C_dvd_sub_of_injective_eval_eq
    (node : ι → K) (hnode : Function.Injective node)
    (target current : Polynomial K)
    (hagree : ∀ i, target.eval (node i) = current.eval (node i)) :
    (∏ i, (Polynomial.X - Polynomial.C (node i))) ∣
      target - current := by
  apply fintypeProd_X_sub_C_dvd_of_injective_roots node hnode
  intro i
  rw [Polynomial.IsRoot, Polynomial.eval_sub, hagree i, sub_self]

/-- After choosing an affine chart, agreement at distinct nodes gives divisibility of the
degree-`degree` homogenized residual by the homogenized product of the node factors. -/
theorem homogenize_fintypeProd_X_sub_C_dvd_homogenize_sub_of_injective_eval_eq
    (node : ι → K) (hnode : Function.Injective node)
    (target current : Polynomial K) (degree : ℕ)
    (hcard : Fintype.card ι ≤ degree)
    (hdegree : (target - current).natDegree ≤ degree)
    (hagree : ∀ i, target.eval (node i) = current.eval (node i)) :
    Polynomial.homogenize
        (∏ i, (Polynomial.X - Polynomial.C (node i)))
        (Fintype.card ι) ∣
      Polynomial.homogenize (target - current) degree := by
  let nodeProduct : Polynomial K :=
    ∏ i, (Polynomial.X - Polynomial.C (node i))
  have hdiv : nodeProduct ∣ target - current :=
    fintypeProd_X_sub_C_dvd_sub_of_injective_eval_eq
      node hnode target current hagree
  by_cases hresidual : target - current = 0
  · simp [hresidual]
  obtain ⟨quotient, hquotient⟩ := hdiv
  have hproductDegree :
      nodeProduct.natDegree = Fintype.card ι := by
    simp [nodeProduct]
  have hproductNe : nodeProduct ≠ 0 := by
    dsimp [nodeProduct]
    exact Finset.prod_ne_zero_iff.mpr fun i _ =>
      Polynomial.X_sub_C_ne_zero (node i)
  have hquotientNe : quotient ≠ 0 := by
    intro hzero
    apply hresidual
    simpa [hzero] using hquotient
  have hquotientDegree :
      quotient.natDegree ≤ degree - Fintype.card ι := by
    have hmulDegree :
        (target - current).natDegree =
          nodeProduct.natDegree + quotient.natDegree := by
      rw [hquotient, Polynomial.natDegree_mul hproductNe hquotientNe]
    omega
  refine ⟨Polynomial.homogenize quotient (degree - Fintype.card ι), ?_⟩
  rw [← Polynomial.homogenize_mul nodeProduct quotient
    (by rw [hproductDegree]) hquotientDegree]
  rw [Nat.add_sub_of_le hcard, ← hquotient]

/-- For homogeneous binary forms, affine-node agreement yields divisibility of their difference
by the homogenized product of the corresponding node factors. -/
theorem homogenize_fintypeProd_X_sub_C_dvd_sub_of_isHomogeneous_eval_eq
    (node : ι → K) (hnode : Function.Injective node)
    (target current : MvPolynomial (Fin 2) K) (degree : ℕ)
    (htarget : target.IsHomogeneous degree)
    (hcurrent : current.IsHomogeneous degree)
    (hcard : Fintype.card ι ≤ degree)
    (haffineDegree :
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target -
        MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current).natDegree ≤ degree)
    (hagree :
      ∀ i,
        (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target).eval (node i) =
          (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current).eval (node i)) :
    Polynomial.homogenize
        (∏ i, (Polynomial.X - Polynomial.C (node i)))
        (Fintype.card ι) ∣
      target - current := by
  have hdvd :=
    homogenize_fintypeProd_X_sub_C_dvd_homogenize_sub_of_injective_eval_eq
      node hnode
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target)
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current)
      degree hcard haffineDegree hagree
  have hhomogeneous : (target - current).IsHomogeneous degree :=
    htarget.sub hcurrent
  have hhomogenize :
      Polynomial.homogenize
          (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target -
            MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current)
          degree =
        target - current := by
    apply Polynomial.homogenize_eq_of_isHomogeneous hhomogeneous
    simp
  rw [hhomogenize] at hdvd
  exact hdvd

end DistinctPolynomialRoots

section CoordinateHyperplaneRestriction

variable {K : Type*} [CommRing K]

/-- Restriction from the projective plane to the coordinate line `X₀ = 0`, expressed as evaluation
at zero after viewing a three-variable polynomial as a polynomial in `X₀` over the other two
variables. -/
noncomputable def firstCoordinateHyperplaneRestriction :
    MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 2) K :=
  (Polynomial.evalRingHom 0).comp
    (MvPolynomial.finSuccEquiv K 2).toRingEquiv.toRingHom

/-- A polynomial restricts to zero on the coordinate line `X₀ = 0` exactly when its equation
`X₀` divides the polynomial. -/
theorem firstCoordinateHyperplaneRestriction_eq_zero_iff_dvd
    (F : MvPolynomial (Fin 3) K) :
    firstCoordinateHyperplaneRestriction F = 0 ↔ MvPolynomial.X 0 ∣ F := by
  constructor
  · intro h
    have hx :
        Polynomial.X ∣ MvPolynomial.finSuccEquiv K 2 F := by
      rw [Polynomial.X_dvd_iff]
      rw [Polynomial.coeff_zero_eq_eval_zero]
      simpa [firstCoordinateHyperplaneRestriction] using h
    obtain ⟨Q, hQ⟩ := hx
    refine ⟨(MvPolynomial.finSuccEquiv K 2).symm Q, ?_⟩
    apply (MvPolynomial.finSuccEquiv K 2).injective
    simpa [MvPolynomial.finSuccEquiv_X_zero] using hQ
  · rintro ⟨Q, rfl⟩
    simp [firstCoordinateHyperplaneRestriction,
      MvPolynomial.finSuccEquiv_X_zero]

/-- Every polynomial on the coordinate line `X₀ = 0` is the restriction of a plane polynomial. -/
theorem firstCoordinateHyperplaneRestriction_surjective :
    Function.Surjective
      (firstCoordinateHyperplaneRestriction :
        MvPolynomial (Fin 3) K → MvPolynomial (Fin 2) K) := by
  intro Q
  refine ⟨(MvPolynomial.finSuccEquiv K 2).symm (Polynomial.C Q), ?_⟩
  simp [firstCoordinateHyperplaneRestriction]

/-- Restriction to the coordinate hypersurface obtained from `X₀ = 0` by a coefficient-preserving
polynomial automorphism. -/
noncomputable def coordinateTransformedHyperplaneRestriction
    (coordinateChange :
      MvPolynomial (Fin 3) K ≃ₐ[K] MvPolynomial (Fin 3) K) :
    MvPolynomial (Fin 3) K →+* MvPolynomial (Fin 2) K :=
  firstCoordinateHyperplaneRestriction.comp coordinateChange.toRingHom

/-- Restriction to a transformed coordinate hypersurface vanishes exactly on the principal ideal
generated by the transformed equation.  When the automorphism comes from an invertible linear
coordinate change, this is the corresponding projective line equation. -/
theorem coordinateTransformedHyperplaneRestriction_eq_zero_iff_dvd
    (coordinateChange :
      MvPolynomial (Fin 3) K ≃ₐ[K] MvPolynomial (Fin 3) K)
    (F : MvPolynomial (Fin 3) K) :
    coordinateTransformedHyperplaneRestriction coordinateChange F = 0 ↔
      coordinateChange.symm (MvPolynomial.X 0) ∣ F := by
  change firstCoordinateHyperplaneRestriction (coordinateChange F) = 0 ↔ _
  rw [firstCoordinateHyperplaneRestriction_eq_zero_iff_dvd]
  simpa using
    (map_dvd_iff coordinateChange
      (a := coordinateChange.symm (MvPolynomial.X 0)) (b := F))

/-- Restriction to a transformed coordinate hypersurface is surjective. -/
theorem coordinateTransformedHyperplaneRestriction_surjective
    (coordinateChange :
      MvPolynomial (Fin 3) K ≃ₐ[K] MvPolynomial (Fin 3) K) :
    Function.Surjective
      (coordinateTransformedHyperplaneRestriction coordinateChange :
        MvPolynomial (Fin 3) K → MvPolynomial (Fin 2) K) := by
  intro Q
  obtain ⟨F, hF⟩ := firstCoordinateHyperplaneRestriction_surjective Q
  refine ⟨coordinateChange.symm F, ?_⟩
  change firstCoordinateHyperplaneRestriction
    (coordinateChange (coordinateChange.symm F)) = Q
  simpa using hF

end CoordinateHyperplaneRestriction

section QuotientLiftCorrection

variable {A B P : Type*} [CommRing A] [CommRing B]

/-- A divisible residual on one restriction can be corrected by lifting the quotient and
multiplying by an ambient element which vanishes on every restriction already treated. -/
theorem exists_single_correction_of_surjective_of_residual_dvd
    (restriction : P → A →+* B) (root : P → B)
    (s : Finset P) (x : P) (G product : A)
    (hsurjective : Function.Surjective (restriction x))
    (hzero : ∀ y ∈ s, restriction y product = 0)
    (hdiv : restriction x product ∣ root x - restriction x G) :
    ∃ D : A,
      (∀ y ∈ s, restriction y D = 0) ∧
      restriction x (G + D) = root x := by
  obtain ⟨quotient, hquotient⟩ := hdiv
  obtain ⟨lift, hlift⟩ := hsurjective quotient
  refine ⟨product * lift, ?_, ?_⟩
  · intro y hy
    rw [map_mul, hzero y hy, zero_mul]
  · rw [map_add, map_mul, hlift, ← hquotient]
    abel

/-- If every residual on a new restriction is divisible by the restriction of the product of the
previous equations, then the prescribed sections extend simultaneously over every finite family. -/
theorem exists_finset_extension_of_residual_dvd_restrictedEquationProduct
    [DecidableEq P]
    (restriction : P → A →+* B) (lineEquation : P → A) (root : P → B)
    (hsurjective : ∀ x, Function.Surjective (restriction x))
    (hselfZero : ∀ x, restriction x (lineEquation x) = 0)
    (hresidualDivides :
      ∀ (s : Finset P) (x : P) (G : A), x ∉ s →
        (∀ y ∈ s, restriction y G = root y) →
        restriction x (∏ y ∈ s, lineEquation y) ∣
          root x - restriction x G) :
    ∀ s : Finset P, ∃ G : A, ∀ x ∈ s, restriction x G = root x := by
  intro s
  induction s using Finset.induction_on with
  | empty =>
      exact ⟨0, by simp⟩
  | @insert x s hx ih =>
      obtain ⟨G, hG⟩ := ih
      obtain ⟨D, hD, hxD⟩ :=
        exists_single_correction_of_surjective_of_residual_dvd
          restriction root s x G (∏ y ∈ s, lineEquation y) (hsurjective x)
          (by
            intro y hy
            rw [map_prod]
            exact Finset.prod_eq_zero hy (hselfZero y))
          (hresidualDivides s x G hx hG)
      refine ⟨G + D, ?_⟩
      intro y hy
      rw [Finset.mem_insert] at hy
      rcases hy with rfl | hy
      · exact hxD
      · rw [map_add, hD y hy, add_zero]
        exact hG y hy

end QuotientLiftCorrection

section CoordinateTransformedInterpolation

variable {K P : Type*} [Field K] [DecidableEq P]

/-- For coordinate-transformed projective lines, divisibility of each new residual by the
restricted product of the previous line equations implies simultaneous interpolation on every
finite line family. -/
theorem exists_finset_coordinateTransformed_extension_of_residual_dvd
    (coordinateChange :
      P → MvPolynomial (Fin 3) K ≃ₐ[K] MvPolynomial (Fin 3) K)
    (root : P → MvPolynomial (Fin 2) K)
    (hresidualDivides :
      ∀ (s : Finset P) (x : P) (G : MvPolynomial (Fin 3) K), x ∉ s →
        (∀ y ∈ s,
          coordinateTransformedHyperplaneRestriction (coordinateChange y) G =
            root y) →
        coordinateTransformedHyperplaneRestriction (coordinateChange x)
            (∏ y ∈ s,
              (coordinateChange y).symm (MvPolynomial.X 0)) ∣
          root x -
            coordinateTransformedHyperplaneRestriction (coordinateChange x) G) :
    ∀ s : Finset P, ∃ G : MvPolynomial (Fin 3) K, ∀ x ∈ s,
      coordinateTransformedHyperplaneRestriction (coordinateChange x) G =
        root x := by
  apply exists_finset_extension_of_residual_dvd_restrictedEquationProduct
    (fun x => coordinateTransformedHyperplaneRestriction (coordinateChange x))
    (fun x => (coordinateChange x).symm (MvPolynomial.X 0))
    root
  · exact fun x =>
      coordinateTransformedHyperplaneRestriction_surjective
        (coordinateChange x)
  · intro x
    rw [coordinateTransformedHyperplaneRestriction_eq_zero_iff_dvd]
  · exact hresidualDivides

end CoordinateTransformedInterpolation

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

/-- At the exact degree threshold, a polynomial divisible by a pairwise relatively prime family
of nonzero degree-one forms is a constant multiple of their product. -/
theorem exists_eq_C_mul_fintypeProd_of_pairwise_isRelPrime_dvd_of_totalDegree_le_card
    (lineEquation : ι → MvPolynomial σ K)
    (hcoprime : Pairwise (IsRelPrime on lineEquation))
    (hne : ∀ i, lineEquation i ≠ 0)
    (hdegree : ∀ i, (lineEquation i).totalDegree = 1)
    (F : MvPolynomial σ K)
    (hdiv : ∀ i, lineEquation i ∣ F)
    (hcard : F.totalDegree ≤ Fintype.card ι) :
    ∃ c : K, F = MvPolynomial.C c * ∏ i, lineEquation i := by
  by_cases hF : F = 0
  · exact ⟨0, by simp [hF]⟩
  have hproddiv : (∏ i, lineEquation i) ∣ F :=
    Fintype.prod_dvd_of_isRelPrime hcoprime hdiv
  obtain ⟨Q, hQ⟩ := hproddiv
  have hprodne : (∏ i, lineEquation i) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr fun i _ => hne i
  have hQne : Q ≠ 0 := by
    intro h
    apply hF
    simpa [h] using hQ
  have hQdegree : Q.totalDegree = 0 := by
    have htotal :
        F.totalDegree = Fintype.card ι + Q.totalDegree := by
      rw [hQ, MvPolynomial.totalDegree_mul_of_isDomain hprodne hQne,
        totalDegree_fintypeProd_eq_card_of_degree_one lineEquation hne hdegree]
    omega
  rw [MvPolynomial.totalDegree_eq_zero_iff_eq_C] at hQdegree
  let c := Q.coeff 0
  refine ⟨c, ?_⟩
  calc
    F = (∏ i, lineEquation i) * Q := hQ
    _ = (∏ i, lineEquation i) * MvPolynomial.C c := by rw [hQdegree]
    _ = MvPolynomial.C c * ∏ i, lineEquation i := mul_comm _ _

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

/-- If linewise square roots extend and restriction equality supplies the corresponding linear
divisors, then at the exact degree threshold the difference from the ambient square is a constant
multiple of the product of all line equations. -/
theorem exists_extendedRoot_difference_eq_C_mul_lineProduct
    (restriction : P → MvPolynomial σ K →+* B)
    (lineEquation : P → MvPolynomial σ K)
    (F : MvPolynomial σ K) (Y : Finset P)
    (root : P → B)
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
      ∀ G : MvPolynomial σ K, (F - G ^ 2).totalDegree ≤ Y.card) :
    ∃ (G : MvPolynomial σ K) (c : K),
      (∀ x ∈ Y, restriction x G = root x) ∧
      F - G ^ 2 =
        MvPolynomial.C c *
          ∏ x : {x // x ∈ Y}, lineEquation x.1 := by
  obtain ⟨G, hG⟩ := hextend
  have hdiv :
      ∀ x : {x // x ∈ Y}, lineEquation x.1 ∣ F - G ^ 2 := by
    intro x
    apply hvanishingDivides G x.1 x.2
    rw [map_pow, hG x.1 x.2, hsquare x.1 x.2]
  obtain ⟨c, hc⟩ :=
    exists_eq_C_mul_fintypeProd_of_pairwise_isRelPrime_dvd_of_totalDegree_le_card
      (fun x : {x // x ∈ Y} => lineEquation x.1) hcoprime
      (fun x => hne x.1 x.2) (fun x => hdegree x.1 x.2)
      (F - G ^ 2) hdiv (by simpa using hdifferenceDegree G)
  exact ⟨G, c, hG, hc⟩

/-- For a family of projective lines presented by coordinate changes, the kernel-divisibility
theorem removes the divisibility hypothesis from the exact-threshold identity. -/
theorem exists_coordinateTransformed_extendedRoot_difference_eq_C_mul_lineProduct
    {K P : Type*} [Field K]
    (coordinateChange :
      P → MvPolynomial (Fin 3) K ≃ₐ[K] MvPolynomial (Fin 3) K)
    (F : MvPolynomial (Fin 3) K) (Y : Finset P)
    (root : P → MvPolynomial (Fin 2) K)
    (hsquare :
      ∀ x ∈ Y,
        coordinateTransformedHyperplaneRestriction (coordinateChange x) F =
          (root x) ^ 2)
    (hextend :
      ∃ G : MvPolynomial (Fin 3) K, ∀ x ∈ Y,
        coordinateTransformedHyperplaneRestriction (coordinateChange x) G = root x)
    (hcoprime :
      Pairwise
        (IsRelPrime on
          fun x : {x // x ∈ Y} =>
            (coordinateChange x.1).symm (MvPolynomial.X 0)))
    (hdegree :
      ∀ x ∈ Y,
        ((coordinateChange x).symm (MvPolynomial.X 0)).totalDegree = 1)
    (hdifferenceDegree :
      ∀ G : MvPolynomial (Fin 3) K,
        (F - G ^ 2).totalDegree ≤ Y.card) :
    ∃ (G : MvPolynomial (Fin 3) K) (c : K),
      (∀ x ∈ Y,
        coordinateTransformedHyperplaneRestriction (coordinateChange x) G = root x) ∧
      F - G ^ 2 =
        MvPolynomial.C c *
          ∏ x : {x // x ∈ Y},
            (coordinateChange x.1).symm (MvPolynomial.X 0) := by
  apply exists_extendedRoot_difference_eq_C_mul_lineProduct
    (fun x => coordinateTransformedHyperplaneRestriction (coordinateChange x))
    (fun x => (coordinateChange x).symm (MvPolynomial.X 0))
    F Y root hsquare hextend hcoprime
  · intro x _ hzero
    have hzero' := congrArg (coordinateChange x) hzero
    simp at hzero'
  · exact hdegree
  · intro G x _ hrestriction
    rw [← coordinateTransformedHyperplaneRestriction_eq_zero_iff_dvd]
    rw [map_sub, hrestriction, sub_self]
  · exact hdifferenceDegree

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
