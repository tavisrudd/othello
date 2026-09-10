import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.GradedCompletedBulkCenterMap

/-!
# Ring closure of graded bulk coefficient families

Finite intervals of total cohomological grades and bounded unit exponents
are preserved by addition, negation and completed convolution. Multiplication
adds the grade intervals and unit bounds: a nonzero coefficient comes from
an actual pair of curve classes and a pair of polynomial bulk monomials.
The resulting subring is a ring model of the graded completed source. Each
coefficient polynomial is converted to its actual formal power series, and
the grading-derived polynomial construction gives the inverse equivalence.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Total cohomological grade of a curve class and bulk monomial. -/
def bulkTotalGrade {Curve : Type*} [AddCommMonoid Curve] {rank : ℕ}
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin rank → ℕ)
    (curve : Curve) (monomial : Option (Fin rank) →₀ ℕ) : ℤ :=
  curveGrade curve + (monomial none : ℤ) - weightedNegativeBulkDegree bulkDegree monomial

/-- The negative bulk degree is additive on monomials. -/
theorem weightedNegativeBulkDegree_add {rank : ℕ} (degree : Fin rank → ℕ)
    (left right : Option (Fin rank) →₀ ℕ) :
    weightedNegativeBulkDegree degree (left+right)=
      weightedNegativeBulkDegree degree left + weightedNegativeBulkDegree degree right := by
  simp [weightedNegativeBulkDegree, mul_add, Finset.sum_add_distrib]

/-- Total grading adds under the actual curve and monomial convolution. -/
theorem bulkTotalGrade_add {Curve : Type*} [AddCommMonoid Curve] {rank : ℕ}
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin rank → ℕ)
    (leftCurve rightCurve : Curve) (left right : Option (Fin rank) →₀ ℕ) :
    bulkTotalGrade curveGrade bulkDegree (leftCurve+rightCurve) (left+right)=
      bulkTotalGrade curveGrade bulkDegree leftCurve left +
        bulkTotalGrade curveGrade bulkDegree rightCurve right := by
  simp only [bulkTotalGrade, map_add, Finsupp.add_apply, Nat.cast_add,
    weightedNegativeBulkDegree_add]
  ring

/-- Bounded cohomological support and unit degree in a completed polynomial
coefficient family. Negative bulk exponents need no uniform bound. -/
def HasBoundedPolynomialBulkGrading
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    (grading : FiniteDegreeAddCommMonoid Curve)
    (curveGrade : Curve →+ ℤ) (bulkDegree : Fin rank → ℕ)
    (series : grading.CompletedNovikovRing (MvPolynomial (Option (Fin rank)) K)) : Prop :=
  ∃ lower upper : ℤ, ∃ unitBound : ℕ, ∀ curve monomial,
    MvPolynomial.coeff monomial (series.coefficient curve) ≠ 0 →
      lower ≤ bulkTotalGrade curveGrade bulkDegree curve monomial ∧
      bulkTotalGrade curveGrade bulkDegree curve monomial ≤ upper ∧ monomial none ≤ unitBound

/-- Addition preserves bounded bulk grading, taking the union of grade bounds. -/
theorem HasBoundedPolynomialBulkGrading.add
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    {grading : FiniteDegreeAddCommMonoid Curve} {curveGrade : Curve →+ ℤ}
    {bulkDegree : Fin rank → ℕ}
    {left right : grading.CompletedNovikovRing (MvPolynomial (Option (Fin rank)) K)}
    (hl : HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree left)
    (hr : HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree right) :
    HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree (left+right) := by
  obtain ⟨ll,ul,nl,hl⟩ := hl
  obtain ⟨lr,ur,nr,hr⟩ := hr
  refine ⟨min ll lr,max ul ur,max nl nr,?_⟩
  intro curve monomial h
  change MvPolynomial.coeff monomial (left.coefficient curve+right.coefficient curve) ≠ 0 at h
  rw [MvPolynomial.coeff_add] at h
  by_cases nonzero : MvPolynomial.coeff monomial (left.coefficient curve) ≠ 0
  · obtain ⟨lower,upper,unit⟩ := hl curve monomial nonzero
    exact ⟨le_trans (min_le_left _ _) lower, le_trans upper (le_max_left _ _),le_trans unit (le_max_left _ _)⟩
  · have other : MvPolynomial.coeff monomial (right.coefficient curve) ≠ 0 := by
      simpa [not_not.mp nonzero] using h
    obtain ⟨lower,upper,unit⟩ := hr curve monomial other
    exact ⟨le_trans (min_le_right _ _) lower, le_trans upper (le_max_right _ _),le_trans unit (le_max_right _ _)⟩

/-- Negation preserves the same bulk support bounds. -/
theorem HasBoundedPolynomialBulkGrading.neg
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    {grading : FiniteDegreeAddCommMonoid Curve} {curveGrade : Curve →+ ℤ}
    {bulkDegree : Fin rank → ℕ}
    {series : grading.CompletedNovikovRing (MvPolynomial (Option (Fin rank)) K)}
    (h : HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree series) :
    HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree (-series) := by
  obtain ⟨lower,upper,unit,bounded⟩ := h
  refine ⟨lower,upper,unit,?_⟩
  intro curve monomial nonzero
  apply bounded curve monomial
  change MvPolynomial.coeff monomial (-series.coefficient curve) ≠ 0 at nonzero
  simpa using nonzero

/-- The completed multiplicative unit has grade zero and unit exponent zero. -/
theorem hasBoundedPolynomialBulkGrading_one
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    (grading : FiniteDegreeAddCommMonoid Curve) (curveGrade : Curve →+ ℤ)
    (bulkDegree : Fin rank → ℕ) :
    HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree (1 : grading.CompletedNovikovRing (MvPolynomial (Option (Fin rank)) K)) := by
  classical
  refine ⟨0,0,0,?_⟩
  intro curve monomial h
  change MvPolynomial.coeff monomial (if curve=0 then 1 else 0) ≠ 0 at h
  by_cases zeroCurve : curve=0
  · subst curve
    rw [if_pos rfl] at h
    rw [MvPolynomial.coeff_one] at h
    have zeroMonomial : monomial=0 := by
      by_contra nonzero
      simp [Ne.symm nonzero] at h
    subst monomial
    simp [bulkTotalGrade, weightedNegativeBulkDegree]
  · simp [zeroCurve] at h

/-- Completed convolution adds the cohomological intervals and the unit
bounds. Its nonzero coefficients have actual curve and monomial witnesses. -/
theorem HasBoundedPolynomialBulkGrading.mul
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    {grading : FiniteDegreeAddCommMonoid Curve} {curveGrade : Curve →+ ℤ}
    {bulkDegree : Fin rank → ℕ}
    {left right : grading.CompletedNovikovRing (MvPolynomial (Option (Fin rank)) K)}
    (hl : HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree left)
    (hr : HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree right) :
    HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree (left*right) := by
  classical
  obtain ⟨ll,ul,nl,hl⟩ := hl
  obtain ⟨lr,ur,nr,hr⟩ := hr
  refine ⟨ll+lr,ul+ur,nl+nr,?_⟩
  intro curve monomial nonzero
  change MvPolynomial.coeff monomial
    (∑ pair ∈ grading.decompositions curve, left.coefficient pair.1 * right.coefficient pair.2) ≠ 0 at nonzero
  rw [MvPolynomial.coeff_sum] at nonzero
  obtain ⟨pair,member,term⟩ := Finset.exists_ne_zero_of_sum_ne_zero nonzero
  have support := MvPolynomial.support_mul (left.coefficient pair.1) (right.coefficient pair.2)
    (MvPolynomial.mem_support_iff.mpr term)
  obtain ⟨ml,hml,mr,hmr,sumEq⟩ := Finset.mem_add.mp support
  obtain ⟨lowerL,upperL,unitL⟩ := hl pair.1 ml (MvPolynomial.mem_support_iff.mp hml)
  obtain ⟨lowerR,upperR,unitR⟩ := hr pair.2 mr (MvPolynomial.mem_support_iff.mp hmr)
  have curveEq := (grading.mem_decompositions_iff pair curve).mp member
  rw [← curveEq, ← sumEq, bulkTotalGrade_add]
  exact ⟨add_le_add lowerL lowerR,add_le_add upperL upperR,add_le_add unitL unitR⟩

/-- The actual graded completed source as a subring of completed polynomial
coefficient families. Its multiplication is the inherited curve convolution. -/
noncomputable def gradedCompletedBulkSubring
    {Curve K : Type*} [AddCommMonoid Curve] [CommRing K] {rank : ℕ}
    (grading : FiniteDegreeAddCommMonoid Curve) (curveGrade : Curve →+ ℤ)
    (bulkDegree : Fin rank → ℕ) :
    Subring (grading.CompletedNovikovRing (MvPolynomial (Option (Fin rank)) K)) where
  carrier := {series | HasBoundedPolynomialBulkGrading grading curveGrade bulkDegree series}
  zero_mem' := by
    refine ⟨0,0,0,?_⟩
    intro curve monomial h
    exact False.elim (h (by simp))
  one_mem' := hasBoundedPolynomialBulkGrading_one grading curveGrade bulkDegree
  add_mem' := HasBoundedPolynomialBulkGrading.add
  neg_mem' := HasBoundedPolynomialBulkGrading.neg
  mul_mem' := HasBoundedPolynomialBulkGrading.mul

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
