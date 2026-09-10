import Mathlib.Tactic
import Mathlib.RingTheory.MvPowerSeries.Basic

/-!
# Polynomial coefficient layers in the graded bulk completion

There are finitely many negative-degree bulk variables and one positive-degree
unit variable. A lower bound on total grading, together with a uniform bound
on the unit exponent, bounds every negative-degree exponent at each fixed
curve class. Consequently each formal coefficient layer is an actual
polynomial. The proof constructs a finite box of exponent vectors; no finite
polynomial support is assumed. An upper grading bound is unnecessary for this
coefficient-finiteness conclusion.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The positive magnitude of the negative bulk contribution to total grading. -/
def weightedNegativeBulkDegree {rank : ℕ} (degree : Fin rank → ℕ)
    (monomial : Option (Fin rank) →₀ ℕ) : ℕ :=
  ∑ i, (degree i+1)*monomial (some i)

/-- A fixed lower total-grade bound and bounded unit exponent allow only
finitely many monomials in a coefficient layer of specified curve grade. -/
theorem finite_bulkMonomials_of_lowerGrade_and_unitBound
    {rank : ℕ} (degree : Fin rank → ℕ) (curveGrade lower : ℤ) (unitBound : ℕ) :
    Set.Finite {monomial : Option (Fin rank) →₀ ℕ |
      monomial none ≤ unitBound ∧
        lower ≤ curveGrade + (monomial none : ℤ) - weightedNegativeBulkDegree degree monomial} := by
  classical
  let bound := unitBound + Int.natAbs (curveGrade-lower)
  let box : Finset (Option (Fin rank) →₀ ℕ) :=
    Finset.univ.image (fun f : Option (Fin rank) → Fin (bound+1) =>
      Finsupp.equivFunOnFinite.symm (fun i => (f i).val))
  apply box.finite_toSet.subset
  intro monomial h
  rcases h with ⟨unitBelow,gradeBelow⟩
  have bounded : ∀ i, monomial i ≤ bound := by
    intro i
    cases i with
    | none => dsimp [bound]; omega
    | some j =>
      have term : (degree j+1)*monomial (some j) ≤ weightedNegativeBulkDegree degree monomial :=
        Finset.single_le_sum (f := fun i => (degree i+1)*monomial (some i))
          (fun i _ => Nat.zero_le _) (Finset.mem_univ j)
      have positive : monomial (some j) ≤ (degree j+1)*monomial (some j) := by nlinarith
      have magnitude : curveGrade-lower ≤ (Int.natAbs (curveGrade-lower) : ℤ) := Int.le_natAbs
      dsimp [bound]
      have castBound : (monomial (some j) : ℤ) ≤ weightedNegativeBulkDegree degree monomial :=
        Int.ofNat_le.mpr (positive.trans term)
      omega
  apply Finset.mem_image.mpr
  refine ⟨fun i => ⟨monomial i,Nat.lt_succ_of_le (bounded i)⟩,Finset.mem_univ _,?_⟩
  ext i
  rfl

/-- A formal power series satisfying those bounds has finite coefficient
support, so it can be represented by a polynomial coefficient layer. -/
theorem gradedBulkPowerSeries_finite_support
    {K : Type*} [CommSemiring K] {rank : ℕ}
    (degree : Fin rank → ℕ) (curveGrade lower : ℤ) (unitBound : ℕ)
    (series : MvPowerSeries (Option (Fin rank)) K)
    (bounded : ∀ monomial, MvPowerSeries.coeff monomial series ≠ 0 →
      monomial none ≤ unitBound ∧
        lower ≤ curveGrade + (monomial none : ℤ) - weightedNegativeBulkDegree degree monomial) :
    Set.Finite {monomial | MvPowerSeries.coeff monomial series ≠ 0} :=
  (finite_bulkMonomials_of_lowerGrade_and_unitBound degree curveGrade lower unitBound).subset
    (fun monomial h => bounded monomial h)

/-- The polynomial with exactly the bounded formal layer's coefficients. -/
noncomputable def gradedBulkCoefficientPolynomial
    {K : Type*} [CommSemiring K] {rank : ℕ}
    (degree : Fin rank → ℕ) (curveGrade lower : ℤ) (unitBound : ℕ)
    (series : MvPowerSeries (Option (Fin rank)) K)
    (bounded : ∀ monomial, MvPowerSeries.coeff monomial series ≠ 0 →
      monomial none ≤ unitBound ∧
        lower ≤ curveGrade + (monomial none : ℤ) - weightedNegativeBulkDegree degree monomial) :
    MvPolynomial (Option (Fin rank)) K :=
  Finsupp.ofSupportFinite (fun monomial => MvPowerSeries.coeff monomial series)
    (gradedBulkPowerSeries_finite_support degree curveGrade lower unitBound series bounded)

/-- The constructed polynomial preserves every formal coefficient exactly. -/
theorem gradedBulkCoefficientPolynomial_coeff
    {K : Type*} [CommSemiring K] {rank : ℕ}
    (degree : Fin rank → ℕ) (curveGrade lower : ℤ) (unitBound : ℕ)
    (series : MvPowerSeries (Option (Fin rank)) K)
    (bounded : ∀ monomial, MvPowerSeries.coeff monomial series ≠ 0 →
      monomial none ≤ unitBound ∧
        lower ≤ curveGrade + (monomial none : ℤ) - weightedNegativeBulkDegree degree monomial)
    (monomial : Option (Fin rank) →₀ ℕ) :
    MvPolynomial.coeff monomial
      (gradedBulkCoefficientPolynomial degree curveGrade lower unitBound series bounded) =
      MvPowerSeries.coeff monomial series := rfl

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
