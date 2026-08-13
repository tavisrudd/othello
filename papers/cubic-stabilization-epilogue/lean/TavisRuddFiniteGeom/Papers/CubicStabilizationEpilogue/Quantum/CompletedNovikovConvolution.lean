import Mathlib.Algebra.MonoidAlgebra.MapDomain
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompletedNovikovSupport

/-!
# Convolution of completed Novikov coefficient families

An additive commutative monoid is equipped with an additive natural-number
degree whose bounded subsets are finite.  For two coefficient families having
finite nonzero support below every degree cutoff, this module defines their
convolution by summing over the finite set of additive decompositions of each
degree and proves that the convolution again has finite support below every
cutoff.

This supplies the completed monoid ring at coefficient level, including its
commutative-ring laws and exact coefficientwise agreement through each cutoff
with multiplication of the corresponding finite additive-monoid-algebra
truncations.  The module does not construct a topology, an
inverse limit, Gromov--Witten coefficients, quantum products, derivations, or
comparison isomorphisms.  Compatibility with numerical pushforward is not
asserted here.  All proofs are symbolic and kernel checked,
with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open scoped BigOperators

variable {Curve Coefficient : Type*}

/-- An effective additive monoid with an additive natural-number degree and
finite bounded-degree subsets. -/
structure FiniteDegreeAddCommMonoid (Curve : Type*) [AddCommMonoid Curve] where
  degree : Curve →+ ℕ
  finite_bounded : ∀ cutoff, Set.Finite {curve | degree curve ≤ cutoff}

namespace FiniteDegreeAddCommMonoid

variable [AddCommMonoid Curve]

/-- The finite set of ordered decompositions `left + right = total`.  The
degree cutoff in the construction is redundant in membership because the
degree is additive and nonnegative. -/
noncomputable def decompositions
    (grading : FiniteDegreeAddCommMonoid Curve) (total : Curve) :
    Finset (Curve × Curve) := by
  classical
  exact
    ((grading.finite_bounded (grading.degree total)).toFinset ×ˢ
      (grading.finite_bounded (grading.degree total)).toFinset).filter
        fun pair ↦ pair.1 + pair.2 = total

/-- Membership in the finite decomposition set is exactly additive
decomposition of the target. -/
theorem mem_decompositions_iff
    (grading : FiniteDegreeAddCommMonoid Curve)
    (pair : Curve × Curve) (total : Curve) :
    pair ∈ grading.decompositions total ↔ pair.1 + pair.2 = total := by
  classical
  simp only [decompositions, Finset.mem_filter, Finset.mem_product,
    Set.Finite.mem_toFinset, Set.mem_setOf_eq]
  constructor
  · exact fun membership ↦ membership.2
  · intro equality
    refine ⟨⟨?_, ?_⟩, equality⟩
    · rw [← equality, map_add]
      exact Nat.le_add_right _ _
    · rw [← equality, map_add]
      exact Nat.le_add_left _ _

/-- Convolution of two completed coefficient families, with the coefficient at
`total` equal to the finite sum over all ordered additive decompositions of
`total`. -/
noncomputable def convolution
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (left right : CompletedNovikovSeries Curve Coefficient grading.degree) :
    CompletedNovikovSeries Curve Coefficient grading.degree where
  coefficient total :=
    ∑ pair ∈ grading.decompositions total,
      left.coefficient pair.1 * right.coefficient pair.2
  finite_below cutoff := by
    classical
    let leftBounded := (left.finite_below cutoff).toFinset
    let rightBounded := (right.finite_below cutoff).toFinset
    refine ((leftBounded ×ˢ rightBounded).image
      fun pair ↦ pair.1 + pair.2).finite_toSet.subset ?_
    intro total membership
    rcases membership with ⟨coefficient_nonzero, total_below⟩
    by_contra total_not_image
    apply coefficient_nonzero
    apply Finset.sum_eq_zero
    intro pair pair_membership
    by_contra product_nonzero
    have decomposition : pair.1 + pair.2 = total :=
      (grading.mem_decompositions_iff pair total).mp pair_membership
    have left_nonzero : left.coefficient pair.1 ≠ 0 := by
      intro left_zero
      exact product_nonzero (by simp [left_zero])
    have right_nonzero : right.coefficient pair.2 ≠ 0 := by
      intro right_zero
      exact product_nonzero (by simp [right_zero])
    apply total_not_image
    apply Finset.mem_image.mpr
    refine ⟨pair, ?_, decomposition⟩
    apply Finset.mem_product.mpr
    constructor
    · change pair.1 ∈ (left.finite_below cutoff).toFinset
      simpa only [Set.Finite.mem_toFinset, Set.mem_setOf_eq] using ⟨left_nonzero, by
        rw [← decomposition, map_add] at total_below
        exact le_trans (Nat.le_add_right _ _) total_below⟩
    · change pair.2 ∈ (right.finite_below cutoff).toFinset
      simpa only [Set.Finite.mem_toFinset, Set.mem_setOf_eq] using ⟨right_nonzero, by
        rw [← decomposition, map_add] at total_below
        exact le_trans (Nat.le_add_left _ _) total_below⟩

/-- The coefficient of completed convolution is the displayed finite
decomposition sum. -/
theorem convolution_coefficient
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (left right : CompletedNovikovSeries Curve Coefficient grading.degree)
    (total : Curve) :
    (grading.convolution left right).coefficient total =
      ∑ pair ∈ grading.decompositions total,
        left.coefficient pair.1 * right.coefficient pair.2 :=
  rfl

/-- Finite truncation of a completed coefficient family through one degree
cutoff, regarded as an element of the ordinary additive monoid algebra. -/
noncomputable def truncation
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree)
    (cutoff : ℕ) : AddMonoidAlgebra Coefficient Curve := by
  classical
  exact Finsupp.onFinset (series.finite_below cutoff).toFinset
    (fun curve ↦ if grading.degree curve ≤ cutoff then
      series.coefficient curve else 0) fun curve value_nonzero ↦ by
      have degree_le : grading.degree curve ≤ cutoff := by
        by_contra degree_not_le
        simp [degree_not_le] at value_nonzero
      have coefficient_nonzero : series.coefficient curve ≠ 0 := by
        simpa [degree_le] using value_nonzero
      simpa only [Set.Finite.mem_toFinset, Set.mem_setOf_eq] using
        ⟨coefficient_nonzero, degree_le⟩

/-- A truncation agrees with the original coefficient family at every class
through its cutoff. -/
theorem truncation_apply_of_degree_le
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree)
    (cutoff : ℕ) (curve : Curve) (degree_le : grading.degree curve ≤ cutoff) :
    grading.truncation series cutoff curve = series.coefficient curve := by
  classical
  simp [truncation, degree_le]

/-- A truncation vanishes at every class strictly beyond its cutoff. -/
theorem truncation_apply_of_degree_not_le
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree)
    (cutoff : ℕ) (curve : Curve) (degree_not_le : ¬ grading.degree curve ≤ cutoff) :
    grading.truncation series cutoff curve = 0 := by
  classical
  simp [truncation, degree_not_le]

/-- Below a cutoff, completed convolution agrees coefficientwise with
multiplication of the corresponding finite additive-monoid-algebra
truncations. -/
theorem truncation_convolution_apply_of_degree_le
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (left right : CompletedNovikovSeries Curve Coefficient grading.degree)
    (cutoff : ℕ) (total : Curve) (degree_le : grading.degree total ≤ cutoff) :
    grading.truncation (grading.convolution left right) cutoff total =
      (grading.truncation left cutoff * grading.truncation right cutoff) total := by
  rw [grading.truncation_apply_of_degree_le _ _ _ degree_le,
    convolution_coefficient]
  rw [AddMonoidAlgebra.mul_apply_antidiagonal _ _ total
    (grading.decompositions total)
    (fun {pair} ↦ grading.mem_decompositions_iff pair total)]
  apply Finset.sum_congr rfl
  intro pair pair_mem
  have decomposition := (grading.mem_decompositions_iff pair total).mp pair_mem
  have first_le : grading.degree pair.1 ≤ cutoff := by
    rw [← decomposition, map_add] at degree_le
    exact le_trans (Nat.le_add_right _ _) degree_le
  have second_le : grading.degree pair.2 ≤ cutoff := by
    rw [← decomposition, map_add] at degree_le
    exact le_trans (Nat.le_add_left _ _) degree_le
  rw [grading.truncation_apply_of_degree_le _ _ _ first_le,
    grading.truncation_apply_of_degree_le _ _ _ second_le]

/-- The zero completed coefficient family is absorbing on the left for
convolution. -/
theorem convolution_zero_left
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree) :
    grading.convolution 0 series = 0 := by
  apply CompletedNovikovSeries.ext
  funext total
  simp [convolution_coefficient]

/-- The zero completed coefficient family is absorbing on the right for
convolution. -/
theorem convolution_zero_right
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree) :
    grading.convolution series 0 = 0 := by
  apply CompletedNovikovSeries.ext
  funext total
  simp [convolution_coefficient]

/-- Convolution distributes over pointwise addition in its left argument. -/
theorem convolution_add_left
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (first second third : CompletedNovikovSeries
      Curve Coefficient grading.degree) :
    grading.convolution (first + second) third =
      grading.convolution first third + grading.convolution second third := by
  apply CompletedNovikovSeries.ext
  funext total
  simp [convolution_coefficient, Finset.sum_add_distrib, add_mul]

/-- Convolution distributes over pointwise addition in its right argument. -/
theorem convolution_add_right
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (first second third : CompletedNovikovSeries
      Curve Coefficient grading.degree) :
    grading.convolution first (second + third) =
      grading.convolution first second + grading.convolution first third := by
  apply CompletedNovikovSeries.ext
  funext total
  simp [convolution_coefficient, Finset.sum_add_distrib, mul_add]

/-- Left-associated completed convolution agrees at each coefficient with the
left-associated product of finite truncations at that coefficient's degree. -/
theorem convolution_convolution_coefficient_eq_truncation_mul
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (first second third : CompletedNovikovSeries
      Curve Coefficient grading.degree) (total : Curve) :
    (grading.convolution (grading.convolution first second) third).coefficient total =
      ((grading.truncation first (grading.degree total) *
          grading.truncation second (grading.degree total)) *
        grading.truncation third (grading.degree total)) total := by
  rw [convolution_coefficient]
  rw [AddMonoidAlgebra.mul_apply_antidiagonal _ _ total
    (grading.decompositions total)
    (fun {pair} ↦ grading.mem_decompositions_iff pair total)]
  apply Finset.sum_congr rfl
  intro pair pair_mem
  have decomposition := (grading.mem_decompositions_iff pair total).mp pair_mem
  have first_le : grading.degree pair.1 ≤ grading.degree total := by
    rw [← decomposition, map_add]
    exact Nat.le_add_right _ _
  have second_le : grading.degree pair.2 ≤ grading.degree total := by
    rw [← decomposition, map_add]
    exact Nat.le_add_left _ _
  rw [← grading.truncation_apply_of_degree_le
      (grading.convolution first second) _ _ first_le,
    grading.truncation_convolution_apply_of_degree_le
      first second _ _ first_le,
    grading.truncation_apply_of_degree_le third _ _ second_le]

/-- Right-associated completed convolution agrees at each coefficient with the
right-associated product of finite truncations at that coefficient's degree. -/
theorem convolution_coefficient_eq_truncation_mul_convolution
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (first second third : CompletedNovikovSeries
      Curve Coefficient grading.degree) (total : Curve) :
    (grading.convolution first (grading.convolution second third)).coefficient total =
      (grading.truncation first (grading.degree total) *
        (grading.truncation second (grading.degree total) *
          grading.truncation third (grading.degree total))) total := by
  rw [convolution_coefficient]
  rw [AddMonoidAlgebra.mul_apply_antidiagonal _ _ total
    (grading.decompositions total)
    (fun {pair} ↦ grading.mem_decompositions_iff pair total)]
  apply Finset.sum_congr rfl
  intro pair pair_mem
  have decomposition := (grading.mem_decompositions_iff pair total).mp pair_mem
  have first_le : grading.degree pair.1 ≤ grading.degree total := by
    rw [← decomposition, map_add]
    exact Nat.le_add_right _ _
  have second_le : grading.degree pair.2 ≤ grading.degree total := by
    rw [← decomposition, map_add]
    exact Nat.le_add_left _ _
  rw [grading.truncation_apply_of_degree_le first _ _ first_le,
    ← grading.truncation_apply_of_degree_le
      (grading.convolution second third) _ _ second_le,
    grading.truncation_convolution_apply_of_degree_le
      second third _ _ second_le]

/-- Completed convolution is associative. -/
theorem convolution_assoc
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (first second third : CompletedNovikovSeries
      Curve Coefficient grading.degree) :
    grading.convolution (grading.convolution first second) third =
      grading.convolution first (grading.convolution second third) := by
  apply CompletedNovikovSeries.ext
  funext total
  rw [grading.convolution_convolution_coefficient_eq_truncation_mul,
    grading.convolution_coefficient_eq_truncation_mul_convolution, mul_assoc]

/-- The completed coefficient family supported at the zero class with
coefficient one. -/
noncomputable def convolutionUnit
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient] :
    CompletedNovikovSeries Curve Coefficient grading.degree := by
  classical
  exact
    { coefficient := fun curve ↦ if curve = 0 then 1 else 0
      finite_below := fun cutoff ↦ Set.finite_singleton 0 |>.subset <| by
        intro curve membership
        rcases membership with ⟨coefficient_nonzero, _⟩
        apply Set.mem_singleton_iff.mpr
        by_contra curve_ne_zero
        exact coefficient_nonzero (if_neg curve_ne_zero) }

/-- Every finite truncation of the convolution unit is the unit of the
ordinary additive monoid algebra. -/
theorem truncation_convolutionUnit
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (cutoff : ℕ) :
    grading.truncation (grading.convolutionUnit (Coefficient := Coefficient)) cutoff = 1 := by
  classical
  ext curve
  rw [AddMonoidAlgebra.one_def]
  by_cases curve_zero : curve = 0
  · subst curve
    simp [truncation, convolutionUnit]
  · simp [truncation, convolutionUnit, curve_zero]

/-- The convolution unit is a left identity. -/
theorem convolution_unit_left
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree) :
    grading.convolution (grading.convolutionUnit (Coefficient := Coefficient)) series =
      series := by
  apply CompletedNovikovSeries.ext
  funext total
  rw [← grading.truncation_apply_of_degree_le
      (grading.convolution grading.convolutionUnit series)
      (grading.degree total) total le_rfl,
    grading.truncation_convolution_apply_of_degree_le
      grading.convolutionUnit series (grading.degree total) total le_rfl,
    grading.truncation_convolutionUnit, one_mul,
    grading.truncation_apply_of_degree_le series
      (grading.degree total) total le_rfl]

/-- The convolution unit is a right identity. -/
theorem convolution_unit_right
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (series : CompletedNovikovSeries Curve Coefficient grading.degree) :
    grading.convolution series (grading.convolutionUnit (Coefficient := Coefficient)) =
      series := by
  apply CompletedNovikovSeries.ext
  funext total
  rw [← grading.truncation_apply_of_degree_le
      (grading.convolution series grading.convolutionUnit)
      (grading.degree total) total le_rfl,
    grading.truncation_convolution_apply_of_degree_le
      series grading.convolutionUnit (grading.degree total) total le_rfl,
    grading.truncation_convolutionUnit, mul_one,
    grading.truncation_apply_of_degree_le series
      (grading.degree total) total le_rfl]

/-- Completed convolution is commutative. -/
theorem convolution_comm
    (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]
    (left right : CompletedNovikovSeries Curve Coefficient grading.degree) :
    grading.convolution left right = grading.convolution right left := by
  apply CompletedNovikovSeries.ext
  funext total
  rw [← grading.truncation_apply_of_degree_le
      (grading.convolution left right) (grading.degree total) total le_rfl,
    grading.truncation_convolution_apply_of_degree_le
      left right (grading.degree total) total le_rfl,
    ← grading.truncation_apply_of_degree_le
      (grading.convolution right left) (grading.degree total) total le_rfl,
    grading.truncation_convolution_apply_of_degree_le
      right left (grading.degree total) total le_rfl,
    mul_comm]

/-- The completed Novikov ring attached to a finite-degree effective additive
monoid, represented by coefficient families with finite support below every
degree cutoff. -/
abbrev CompletedNovikovRing
    (grading : FiniteDegreeAddCommMonoid Curve) (Coefficient : Type*)
    [CommRing Coefficient] :=
  CompletedNovikovSeries Curve Coefficient grading.degree

namespace CompletedNovikovRing

variable (grading : FiniteDegreeAddCommMonoid Curve) [CommRing Coefficient]

/-- Completed convolution, its delta-function unit, and the pointwise additive
group give the completed coefficient families a commutative-ring structure. -/
noncomputable instance : CommRing (CompletedNovikovRing grading Coefficient) where
  add := fun left right ↦ left + right
  add_assoc := add_assoc
  zero := 0
  zero_add := zero_add
  add_zero := add_zero
  nsmul := fun scalar series ↦ scalar • series
  nsmul_zero := AddMonoid.nsmul_zero
  nsmul_succ := AddMonoid.nsmul_succ
  add_comm := add_comm
  mul := grading.convolution
  mul_assoc := grading.convolution_assoc
  one := grading.convolutionUnit
  one_mul := grading.convolution_unit_left
  mul_one := grading.convolution_unit_right
  zero_mul := grading.convolution_zero_left
  mul_zero := grading.convolution_zero_right
  left_distrib := grading.convolution_add_right
  right_distrib := grading.convolution_add_left
  neg := Neg.neg
  sub := Sub.sub
  zsmul := fun scalar series ↦ scalar • series
  sub_eq_add_neg := sub_eq_add_neg
  zsmul_zero' := SubNegMonoid.zsmul_zero'
  zsmul_succ' := SubNegMonoid.zsmul_succ'
  zsmul_neg' := SubNegMonoid.zsmul_neg'
  neg_add_cancel := neg_add_cancel
  mul_comm := grading.convolution_comm

/-- Multiplication in the completed Novikov ring is the finite-decomposition
convolution. -/
theorem mul_def
    (left right : CompletedNovikovRing grading Coefficient) :
    left * right = grading.convolution left right :=
  rfl

/-- The multiplicative unit of the completed Novikov ring is the coefficient
family supported at the zero class with coefficient one. -/
theorem one_def :
    (1 : CompletedNovikovRing grading Coefficient) =
      grading.convolutionUnit :=
  rfl

end CompletedNovikovRing

end FiniteDegreeAddCommMonoid

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
