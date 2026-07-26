import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Algebra.MvPolynomial.Equiv
import Mathlib.Algebra.MvPolynomial.Nilpotent
import Mathlib.Algebra.MvPolynomial.NoZeroDivisors
import Mathlib.Algebra.CharP.Reduced
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.Homogenize
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.RingTheory.Coprime.Lemmas
import Mathlib.RingTheory.Polynomial.UniqueFactorization
import RelativeConicArcs.ChowRestrictionDescent

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
coordinate-free binary-factor theorem proves divisibility from vanishing at canonical projective
zeros, including points at infinity, and its characteristic-two form derives root-value agreement
from agreement of squares.  The distinct-affine-node theorem is retained as a normalized
specialization.  Identifying the concrete restricted factors, their projective zeros, and their
pairwise relative primality remains geometric.
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

/-- Dehomogenizing a homogeneous binary form in the affine chart `[X : 1]` does not increase its
degree beyond the homogeneous degree. -/
theorem natDegree_dehomogenize_le_of_isHomogeneous
    (F : MvPolynomial (Fin 2) K) (degree : ℕ)
    (hF : F.IsHomogeneous degree) :
    (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] F).natDegree ≤
      degree := by
  let coefficientEval : MvPolynomial (Fin 1) K →+* K :=
    MvPolynomial.eval₂Hom (RingHom.id K) (fun _ => 1)
  have hhom :
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)]).toRingHom =
        (Polynomial.mapRingHom coefficientEval).comp
          (MvPolynomial.finSuccEquiv K 1).toRingEquiv.toRingHom := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp [coefficientEval, MvPolynomial.finSuccEquiv_apply]
    · intro i
      have hi : i = 0 ∨ i = 1 := by
        fin_cases i <;> simp
      rcases hi with rfl | rfl
      · simp [coefficientEval, MvPolynomial.finSuccEquiv_apply]
      · have hfin :
            MvPolynomial.finSuccEquiv K 1 (MvPolynomial.X (1 : Fin 2)) =
              Polynomial.C (MvPolynomial.X (0 : Fin 1)) := by
          rw [show (1 : Fin 2) = (0 : Fin 1).succ by decide]
          exact MvPolynomial.finSuccEquiv_X_succ
        simp [coefficientEval, hfin]
  have heval :
      MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] F =
        Polynomial.map coefficientEval (MvPolynomial.finSuccEquiv K 1 F) :=
    RingHom.congr_fun hhom F
  rw [heval]
  calc
    (Polynomial.map coefficientEval (MvPolynomial.finSuccEquiv K 1 F)).natDegree
        ≤ (MvPolynomial.finSuccEquiv K 1 F).natDegree :=
      Polynomial.natDegree_map_le
    _ = F.degreeOf 0 := MvPolynomial.natDegree_finSuccEquiv F
    _ ≤ F.totalDegree := MvPolynomial.degreeOf_le_totalDegree F 0
    _ ≤ degree := hF.totalDegree_le

/-- The involution exchanging the two homogeneous coordinates of a binary form. -/
private def binaryCoordinateSwap : Fin 2 ≃ Fin 2 :=
  Equiv.swap 0 1

@[simp]
private theorem binaryCoordinateSwap_zero : binaryCoordinateSwap 0 = 1 := by
  decide

@[simp]
private theorem binaryCoordinateSwap_one : binaryCoordinateSwap 1 = 0 := by
  decide

/-- If the first coefficient of a nonzero binary linear form is nonzero, vanishing of a
homogeneous binary form at its projective zero makes the linear form a divisor. -/
private theorem homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZero_of_coeff_zero_ne
    (a : Fin 2 → K) (F : MvPolynomial (Fin 2) K) (degree : ℕ)
    (ha0 : a 0 ≠ 0) (hF : F.IsHomogeneous degree)
    (hvanish : MvPolynomial.eval ![a 1, -a 0] F = 0) :
    homogeneousLinearPolynomial a ∣ F := by
  let affine : Polynomial K :=
    MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] F
  let node : K := a 1 / (-a 0)
  have ha0neg : -a 0 ≠ 0 := neg_ne_zero.mpr ha0
  have haffineDegree : affine.natDegree ≤ degree := by
    exact natDegree_dehomogenize_le_of_isHomogeneous F degree hF
  have hhomogenize :
      Polynomial.homogenize affine degree = F := by
    apply Polynomial.homogenize_eq_of_isHomogeneous hF
    simp [affine]
  have hnodeRoot : affine.eval node = 0 := by
    have heval :=
      Polynomial.eval_homogenize haffineDegree ![a 1, -a 0] ha0neg
    rw [hhomogenize] at heval
    rw [hvanish] at heval
    exact (mul_eq_zero.mp heval.symm).resolve_right (pow_ne_zero _ ha0neg)
  by_cases haffine : affine = 0
  · rw [← hhomogenize, haffine]
    simp
  have hdegreePos : 1 ≤ degree := by
    have hnatDegreeNe : affine.natDegree ≠ 0 := by
      intro hdegreeZero
      have haffineC := Polynomial.eq_C_of_natDegree_eq_zero hdegreeZero
      apply haffine
      rw [haffineC] at hnodeRoot ⊢
      simpa using hnodeRoot
    omega
  have hnodeInjective : Function.Injective (fun _ : Unit => node) := by
    intro i j _
    exact Subsingleton.elim i j
  have hdvd :
      Polynomial.homogenize (Polynomial.X - Polynomial.C node) 1 ∣ F := by
    rw [← hhomogenize]
    simpa using
      homogenize_fintypeProd_X_sub_C_dvd_homogenize_sub_of_injective_eval_eq
        (fun _ : Unit => node) hnodeInjective affine 0 degree hdegreePos
        (by simpa using haffineDegree)
        (fun _ => by simpa using hnodeRoot)
  obtain ⟨c, hc, hfactor⟩ :=
    exists_ne_zero_scale_homogeneousLinearPolynomial_eq_C_mul_homogenize_X_sub_C
      a node
      (by
        intro ha
        apply ha0
        simpa using congrFun ha 0)
      (by
        dsimp [node]
        field_simp [ha0]
        ring)
  rw [hfactor]
  exact (hc.isUnit.map MvPolynomial.C).mul_left_dvd.mpr hdvd

/-- A nonzero binary linear form divides a homogeneous binary form whenever the latter vanishes at
the canonical projective zero `[a₁ : -a₀]` of the linear form `a₀X + a₁Y`. -/
theorem homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZero
    (a : Fin 2 → K) (F : MvPolynomial (Fin 2) K) (degree : ℕ)
    (ha : a ≠ 0) (hF : F.IsHomogeneous degree)
    (hvanish : MvPolynomial.eval ![a 1, -a 0] F = 0) :
    homogeneousLinearPolynomial a ∣ F := by
  by_cases ha0 : a 0 = 0
  · have ha1 : a 1 ≠ 0 := by
      intro ha1
      apply ha
      funext i
      fin_cases i
      · exact ha0
      · exact ha1
    let swappedCoefficient : Fin 2 → K := ![-a 1, -a 0]
    let swappedForm : MvPolynomial (Fin 2) K :=
      MvPolynomial.rename binaryCoordinateSwap F
    have hswappedCoefficient0 : swappedCoefficient 0 ≠ 0 := by
      simpa [swappedCoefficient] using neg_ne_zero.mpr ha1
    have hswappedHomogeneous : swappedForm.IsHomogeneous degree := by
      exact hF.rename_isHomogeneous
    have hswappedVanish :
        MvPolynomial.eval
            ![swappedCoefficient 1, -swappedCoefficient 0] swappedForm = 0 := by
      rw [show swappedForm = MvPolynomial.rename binaryCoordinateSwap F by rfl]
      rw [MvPolynomial.eval_rename]
      have hpoint :
          (![swappedCoefficient 1, -swappedCoefficient 0] ∘
              binaryCoordinateSwap) =
            ![a 1, -a 0] := by
        funext i
        fin_cases i <;> simp [swappedCoefficient]
      rw [hpoint]
      exact hvanish
    have hswappedDvd :
        homogeneousLinearPolynomial swappedCoefficient ∣ swappedForm :=
      homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZero_of_coeff_zero_ne
        swappedCoefficient swappedForm degree hswappedCoefficient0
        hswappedHomogeneous hswappedVanish
    obtain ⟨Q, hQ⟩ := hswappedDvd
    refine ⟨-(MvPolynomial.rename binaryCoordinateSwap Q), ?_⟩
    have hrenamed := congrArg (MvPolynomial.rename binaryCoordinateSwap) hQ
    have hswap :
        binaryCoordinateSwap ∘ binaryCoordinateSwap = id := by
      funext i
      fin_cases i <;> simp
    have hleft :
        MvPolynomial.rename binaryCoordinateSwap swappedForm = F := by
      simp [swappedForm, MvPolynomial.rename_rename, hswap]
    have hfactor :
        MvPolynomial.rename binaryCoordinateSwap
            (homogeneousLinearPolynomial swappedCoefficient) =
          -homogeneousLinearPolynomial a := by
      simp [swappedCoefficient, homogeneousLinearPolynomial, add_comm]
    rw [hleft, map_mul, hfactor] at hrenamed
    simpa [neg_mul, mul_neg] using hrenamed
  · exact
      homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZero_of_coeff_zero_ne
        a F degree ha0 hF hvanish

/-- Vanishing of a homogeneous binary form at the canonical projective zeros of a pairwise
relatively prime family of nonzero linear forms makes their product a divisor. -/
theorem fintypeProd_homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZeros
    (a : ι → Fin 2 → K)
    (ha : ∀ i, a i ≠ 0)
    (hcoprime : Pairwise (IsRelPrime on fun i => homogeneousLinearPolynomial (a i)))
    (F : MvPolynomial (Fin 2) K) (degree : ℕ)
    (hF : F.IsHomogeneous degree)
    (hvanish :
      ∀ i, MvPolynomial.eval ![a i 1, -a i 0] F = 0) :
    (∏ i, homogeneousLinearPolynomial (a i)) ∣ F := by
  apply Fintype.prod_dvd_of_isRelPrime hcoprime
  intro i
  exact
    homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZero
      (a i) F degree (ha i) hF (hvanish i)

/-- Agreement of two homogeneous binary forms at the canonical projective zeros of a pairwise
relatively prime linear family makes the product of that family divide their difference. -/
theorem fintypeProd_homogeneousLinearPolynomial_dvd_sub_of_isHomogeneous_eval_projectiveZeros_eq
    (a : ι → Fin 2 → K)
    (ha : ∀ i, a i ≠ 0)
    (hcoprime : Pairwise (IsRelPrime on fun i => homogeneousLinearPolynomial (a i)))
    (target current : MvPolynomial (Fin 2) K) (degree : ℕ)
    (htarget : target.IsHomogeneous degree)
    (hcurrent : current.IsHomogeneous degree)
    (hagree :
      ∀ i,
        MvPolynomial.eval ![a i 1, -a i 0] target =
          MvPolynomial.eval ![a i 1, -a i 0] current) :
    (∏ i, homogeneousLinearPolynomial (a i)) ∣ target - current := by
  apply
    fintypeProd_homogeneousLinearPolynomial_dvd_of_isHomogeneous_eval_projectiveZeros
      a ha hcoprime (target - current) degree (htarget.sub hcurrent)
  intro i
  simp [hagree i]

/-- In exponent characteristic two, agreement of the squares of two homogeneous binary forms at
the projective zeros of a relatively prime linear family already makes the linear-factor product
divide their difference. -/
theorem fintypeProd_homogeneousLinearPolynomial_dvd_sub_of_isHomogeneous_eval_projectiveZeros_sq_eq
    [ExpChar K 2]
    (a : ι → Fin 2 → K)
    (ha : ∀ i, a i ≠ 0)
    (hcoprime : Pairwise (IsRelPrime on fun i => homogeneousLinearPolynomial (a i)))
    (target current : MvPolynomial (Fin 2) K) (degree : ℕ)
    (htarget : target.IsHomogeneous degree)
    (hcurrent : current.IsHomogeneous degree)
    (hsquareAgree :
      ∀ i,
        MvPolynomial.eval ![a i 1, -a i 0] (target ^ 2) =
          MvPolynomial.eval ![a i 1, -a i 0] (current ^ 2)) :
    (∏ i, homogeneousLinearPolynomial (a i)) ∣ target - current := by
  apply
    fintypeProd_homogeneousLinearPolynomial_dvd_sub_of_isHomogeneous_eval_projectiveZeros_eq
      a ha hcoprime target current degree htarget hcurrent
  intro i
  apply frobenius_inj K 2
  change
    MvPolynomial.eval ![a i 1, -a i 0] target ^ 2 =
      MvPolynomial.eval ![a i 1, -a i 0] current ^ 2
  simpa only [map_pow] using hsquareAgree i

/-- For homogeneous binary forms, affine-node agreement yields divisibility of their difference
by the homogenized product of the corresponding node factors. -/
theorem homogenize_fintypeProd_X_sub_C_dvd_sub_of_isHomogeneous_eval_eq
    (node : ι → K) (hnode : Function.Injective node)
    (target current : MvPolynomial (Fin 2) K) (degree : ℕ)
    (htarget : target.IsHomogeneous degree)
    (hcurrent : current.IsHomogeneous degree)
    (hcard : Fintype.card ι ≤ degree)
    (hagree :
      ∀ i,
        (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target).eval (node i) =
          (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current).eval (node i)) :
    Polynomial.homogenize
        (∏ i, (Polynomial.X - Polynomial.C (node i)))
        (Fintype.card ι) ∣
      target - current := by
  have hhomogeneous : (target - current).IsHomogeneous degree :=
    htarget.sub hcurrent
  have haffineDegree :
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target -
        MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current).natDegree ≤ degree := by
    simpa using
      natDegree_dehomogenize_le_of_isHomogeneous
        (target - current) degree hhomogeneous
  have hdvd :=
    homogenize_fintypeProd_X_sub_C_dvd_homogenize_sub_of_injective_eval_eq
      node hnode
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target)
      (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current)
      degree hcard haffineDegree hagree
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

/-- Homogenizing the product of affine node factors in its natural degree equals the product of
their degree-one homogenizations. -/
theorem homogenize_fintypeProd_X_sub_C_eq_prod_homogenize
    (node : ι → K) :
    Polynomial.homogenize
        (∏ i, (Polynomial.X - Polynomial.C (node i)))
        (Fintype.card ι) =
      ∏ i, Polynomial.homogenize
        (Polynomial.X - Polynomial.C (node i)) 1 := by
  have h :=
    Polynomial.homogenize_finsetProd
      (s := Finset.univ)
      (p := fun i : ι => Polynomial.X - Polynomial.C (node i))
      (n := fun _ => 1)
      (by
        intro i _
        simp)
  have hsum :
      (∑ _i ∈ (Finset.univ : Finset ι), (1 : ℕ)) =
        Fintype.card ι := by
    simp
  rw [hsum] at h
  exact h

/-- A family of nonzero scalar multiples of the homogenized node factors has product equal to the
aggregate scalar times the homogenized node-factor product. -/
theorem prod_eq_C_prod_mul_homogenize_fintypeProd_X_sub_C
    (node scale : ι → K)
    (factor : ι → MvPolynomial (Fin 2) K)
    (hfactor :
      ∀ i,
        factor i =
          MvPolynomial.C (scale i) *
            Polynomial.homogenize
              (Polynomial.X - Polynomial.C (node i)) 1) :
    (∏ i, factor i) =
      MvPolynomial.C (∏ i, scale i) *
        Polynomial.homogenize
          (∏ i, (Polynomial.X - Polynomial.C (node i)))
          (Fintype.card ι) := by
  simp_rw [hfactor]
  rw [Finset.prod_mul_distrib]
  simp only [map_prod]
  rw [homogenize_fintypeProd_X_sub_C_eq_prod_homogenize]

/-- Divisibility by the homogenized node-factor product is equivalent to divisibility by any
factorwise nonzero scalar rescaling of that product. -/
theorem prod_dvd_of_homogenize_fintypeProd_X_sub_C_dvd_of_proportional
    (node scale : ι → K)
    (factor : ι → MvPolynomial (Fin 2) K)
    (hscale : ∀ i, scale i ≠ 0)
    (hfactor :
      ∀ i,
        factor i =
          MvPolynomial.C (scale i) *
            Polynomial.homogenize
              (Polynomial.X - Polynomial.C (node i)) 1)
    (residual : MvPolynomial (Fin 2) K)
    (hdiv :
      Polynomial.homogenize
          (∏ i, (Polynomial.X - Polynomial.C (node i)))
          (Fintype.card ι) ∣
        residual) :
    (∏ i, factor i) ∣ residual := by
  rw [prod_eq_C_prod_mul_homogenize_fintypeProd_X_sub_C
    node scale factor hfactor]
  have hscaleProduct : ∏ i, scale i ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr fun i _ => hscale i
  exact ((hscaleProduct.isUnit.map MvPolynomial.C).mul_left_dvd).mpr hdiv

/-- If the restricted line equations are nonzero scalar multiples of the homogenized factors at
distinct affine nodes, agreement of homogeneous binary sections at those nodes makes their
difference divisible by the product of the actual restricted equations. -/
theorem prod_dvd_sub_of_proportional_homogenizedNodeFactors_of_isHomogeneous_eval_eq
    (node scale : ι → K) (hnode : Function.Injective node)
    (factor : ι → MvPolynomial (Fin 2) K)
    (hscale : ∀ i, scale i ≠ 0)
    (hfactor :
      ∀ i,
        factor i =
          MvPolynomial.C (scale i) *
            Polynomial.homogenize
              (Polynomial.X - Polynomial.C (node i)) 1)
    (target current : MvPolynomial (Fin 2) K) (degree : ℕ)
    (htarget : target.IsHomogeneous degree)
    (hcurrent : current.IsHomogeneous degree)
    (hcard : Fintype.card ι ≤ degree)
    (hagree :
      ∀ i,
        (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] target).eval (node i) =
          (MvPolynomial.aeval ![Polynomial.X, (1 : Polynomial K)] current).eval (node i)) :
    (∏ i, factor i) ∣ target - current := by
  apply prod_dvd_of_homogenize_fintypeProd_X_sub_C_dvd_of_proportional
    node scale factor hscale hfactor
  exact
    homogenize_fintypeProd_X_sub_C_dvd_sub_of_isHomogeneous_eval_eq
      node hnode target current degree htarget hcurrent hcard hagree

end DistinctPolynomialRoots

section BinaryLinearRelativePrimality

variable {K σ : Type*} [Field K]

/-- A nonzero multivariable polynomial of total degree one over a field is irreducible. -/
theorem mvPolynomial_irreducible_of_totalDegree_eq_one
    (F : MvPolynomial σ K) (hdegree : F.totalDegree = 1) :
    Irreducible F := by
  have hF : F ≠ 0 := by
    intro hzero
    simp [hzero] at hdegree
  have isUnit_of_ne_zero_totalDegree_eq_zero :
      ∀ {G : MvPolynomial σ K}, G ≠ 0 → G.totalDegree = 0 → IsUnit G := by
    intro G hG hGdegree
    rw [MvPolynomial.isUnit_iff_totalDegree_of_isReduced]
    refine ⟨?_, hGdegree⟩
    rw [isUnit_iff_ne_zero]
    intro hconstant
    apply hG
    rw [MvPolynomial.totalDegree_eq_zero_iff_eq_C] at hGdegree
    rw [hGdegree, hconstant]
    simp
  refine ⟨?_, ?_⟩
  · intro hunit
    have hzero :=
      (MvPolynomial.isUnit_iff_totalDegree_of_isReduced.mp hunit).2
    omega
  · intro A B hfactor
    have hA : A ≠ 0 := by
      intro hzero
      apply hF
      simpa [hzero] using hfactor
    have hB : B ≠ 0 := by
      intro hzero
      apply hF
      simpa [hzero] using hfactor
    have hsum : A.totalDegree + B.totalDegree = 1 := by
      rw [← MvPolynomial.totalDegree_mul_of_isDomain hA hB, ← hfactor,
        hdegree]
    rcases Nat.eq_zero_or_pos A.totalDegree with hAdegree | hAdegree
    · exact Or.inl (isUnit_of_ne_zero_totalDegree_eq_zero hA hAdegree)
    · have hBdegree : B.totalDegree = 0 := by omega
      exact Or.inr (isUnit_of_ne_zero_totalDegree_eq_zero hB hBdegree)

/-- Two homogeneous binary linear forms whose coefficient determinant is nonzero have no common
nonunit divisor. -/
theorem homogeneousLinearPolynomial_isRelPrime_of_binaryCoefficientDeterminant_ne_zero
    {a b : Fin 2 → K}
    (hdet : binaryLinearCoefficientDeterminant a b ≠ 0) :
    IsRelPrime (homogeneousLinearPolynomial a) (homogeneousLinearPolynomial b) := by
  have ha : a ≠ 0 := by
    intro hzero
    subst a
    simp [binaryLinearCoefficientDeterminant] at hdet
  have hb : b ≠ 0 := by
    intro hzero
    subst b
    simp [binaryLinearCoefficientDeterminant] at hdet
  apply
    (mvPolynomial_irreducible_of_totalDegree_eq_one
      (homogeneousLinearPolynomial a)
      (homogeneousLinearPolynomial_totalDegree_eq_one ha)).isRelPrime_iff_not_dvd.mpr
  intro hdiv
  obtain ⟨Q, hfactor⟩ := hdiv
  have hlinearA :
      homogeneousLinearPolynomial a ≠ 0 :=
    homogeneousLinearPolynomial_ne_zero_of_binaryCoefficients_ne_zero ha
  have hlinearB :
      homogeneousLinearPolynomial b ≠ 0 :=
    homogeneousLinearPolynomial_ne_zero_of_binaryCoefficients_ne_zero hb
  have hQ : Q ≠ 0 := by
    intro hzero
    apply hlinearB
    simpa [hzero] using hfactor
  have hQdegree : Q.totalDegree = 0 := by
    have hdegree :
        (homogeneousLinearPolynomial b).totalDegree =
          (homogeneousLinearPolynomial a).totalDegree + Q.totalDegree := by
      rw [hfactor, MvPolynomial.totalDegree_mul_of_isDomain hlinearA hQ]
    rw [homogeneousLinearPolynomial_totalDegree_eq_one ha,
      homogeneousLinearPolynomial_totalDegree_eq_one hb] at hdegree
    omega
  rw [MvPolynomial.totalDegree_eq_zero_iff_eq_C] at hQdegree
  let c := Q.coeff 0
  have hproportional :
      homogeneousLinearPolynomial b =
        MvPolynomial.C c * homogeneousLinearPolynomial a := by
    rw [hfactor, hQdegree, mul_comm]
  have hcoefficient : b = fun i => c * a i := by
    funext i
    fin_cases i
    · have heval := congrArg (MvPolynomial.eval ![1, 0]) hproportional
      simpa [homogeneousLinearPolynomial] using heval
    · have heval := congrArg (MvPolynomial.eval ![0, 1]) hproportional
      simpa [homogeneousLinearPolynomial] using heval
  apply hdet
  rw [hcoefficient]
  simp [binaryLinearCoefficientDeterminant]
  ring

/-- Pairwise nonzero restricted coefficient determinants give a pairwise relatively prime family
of restricted homogeneous linear factors. -/
theorem pairwise_isRelPrime_planeLineRestrictedLinearFactors_of_determinant_ne_zero
    {ι : Type*}
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K)
    (hdet :
      Pairwise fun i j =>
        binaryLinearCoefficientDeterminant
          (planeLineRestrictedCoefficients lineCoordinates (covector i))
          (planeLineRestrictedCoefficients lineCoordinates (covector j)) ≠ 0) :
    Pairwise
      (IsRelPrime on fun i =>
        homogeneousLinearPolynomial
          (planeLineRestrictedCoefficients lineCoordinates (covector i))) := by
  intro i j hij
  exact
    homogeneousLinearPolynomial_isRelPrime_of_binaryCoefficientDeterminant_ne_zero
      (hdet hij)

end BinaryLinearRelativePrimality

section RestrictedProjectiveFactorProduct

variable {K ι : Type*} [Field K] [Fintype ι]

/-- For plane covectors restricted to one parametrized projective line, nonzero pairwise
coefficient determinants and square agreement at the canonical restricted zeros make the product
of the actual restricted factors divide the root difference. -/
theorem fintypeProd_planeLineRestrictedLinearFactors_dvd_sub_of_projectiveZero_sq_eq
    [ExpChar K 2]
    (lineCoordinates : Fin 3 → Fin 2 → K)
    (covector : ι → Fin 3 → K)
    (hne :
      ∀ i, planeLineRestrictedCoefficients lineCoordinates (covector i) ≠ 0)
    (hdet :
      Pairwise fun i j =>
        binaryLinearCoefficientDeterminant
          (planeLineRestrictedCoefficients lineCoordinates (covector i))
          (planeLineRestrictedCoefficients lineCoordinates (covector j)) ≠ 0)
    (target current : MvPolynomial (Fin 2) K) (degree : ℕ)
    (htarget : target.IsHomogeneous degree)
    (hcurrent : current.IsHomogeneous degree)
    (hsquareAgree :
      ∀ i,
        let restricted :=
          planeLineRestrictedCoefficients lineCoordinates (covector i)
        MvPolynomial.eval ![restricted 1, -restricted 0] (target ^ 2) =
          MvPolynomial.eval ![restricted 1, -restricted 0] (current ^ 2)) :
    (∏ i,
        planeLineRestriction lineCoordinates
          (homogeneousLinearPolynomial (covector i))) ∣
      target - current := by
  have hcoprime :
      Pairwise
        (IsRelPrime on fun i =>
          homogeneousLinearPolynomial
            (planeLineRestrictedCoefficients lineCoordinates (covector i))) :=
    pairwise_isRelPrime_planeLineRestrictedLinearFactors_of_determinant_ne_zero
      lineCoordinates covector hdet
  have hdiv :=
    fintypeProd_homogeneousLinearPolynomial_dvd_sub_of_isHomogeneous_eval_projectiveZeros_sq_eq
      (fun i => planeLineRestrictedCoefficients lineCoordinates (covector i))
      hne hcoprime target current degree htarget hcurrent hsquareAgree
  simpa only [planeLineRestriction_homogeneousLinearPolynomial] using hdiv

end RestrictedProjectiveFactorProduct

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
