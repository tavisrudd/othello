import Mathlib.Data.Fintype.EquivFin
import Mathlib.Order.Lattice.Nat
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExponentialDivisorTags

/-!
# Lowest support of a completed Novikov series

This module gives a coefficient model for the support condition in a completed
Novikov ring.  A series indexed by effective classes has only finitely many
nonzero coefficients below every length cutoff.  Every nonzero such series
therefore has a nonempty finite lowest-length support.

For an injective integral divisor-pairing vector on the indexing monoid, Lean
then constructs the integral one-parameter direction and proves that any
assignment of nonzero leading coefficients to the lowest support gives a
nonzero finite exponential-character combination over an arbitrary
characteristic-zero field.  This is the lowest-support and Vandermonde
noncancellation step in divisor tagging.

The module does not construct the completed monoid-ring multiplication or an
associated graded ring.  In particular, it does not prove that the leading
coefficient of the image under a geometric Novikov specialization is the
displayed finite exponential combination; that compatibility remains a
separate filtered-ring statement.  All proofs here are symbolic and kernel
checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open scoped BigOperators

/-- A coefficient family satisfying the defining support condition for a
length-completed Novikov series: nonzero coefficients below every finite
length cutoff form a finite set. -/
structure CompletedNovikovSeries (Curve Coefficient : Type*) [Zero Coefficient]
    (length : Curve → ℕ) where
  coefficient : Curve → Coefficient
  finite_below : ∀ cutoff,
    Set.Finite {degree | coefficient degree ≠ 0 ∧ length degree ≤ cutoff}

namespace CompletedNovikovSeries

variable {Curve Coefficient : Type*} {length : Curve → ℕ}

section Basic

variable [Zero Coefficient]

/-- The zero completed coefficient family. -/
instance : Zero (CompletedNovikovSeries Curve Coefficient length) where
  zero :=
    { coefficient := 0
      finite_below := fun _ ↦ by simp }

/-- The coefficient function of the zero completed series is zero. -/
@[simp]
theorem coefficient_zero :
    (0 : CompletedNovikovSeries Curve Coefficient length).coefficient = 0 :=
  rfl

/-- A completed series is zero exactly when its coefficient function is zero;
this extensionality theorem does not use multiplication. -/
@[ext]
theorem ext {left right : CompletedNovikovSeries Curve Coefficient length}
    (equal_coefficients : left.coefficient = right.coefficient) : left = right := by
  cases left
  cases right
  cases equal_coefficients
  rfl

end Basic

section Additive

variable [AddCommGroup Coefficient]

/-- Pointwise addition of completed coefficient families.  The support of a
sum is contained in the union of the two supports. -/
instance : Add (CompletedNovikovSeries Curve Coefficient length) where
  add left right :=
    { coefficient := left.coefficient + right.coefficient
      finite_below := fun cutoff ↦
        ((left.finite_below cutoff).union (right.finite_below cutoff)).subset <| by
          intro degree membership
          rcases membership with ⟨sum_nonzero, length_le⟩
          by_cases left_zero : left.coefficient degree = 0
          · right
            exact ⟨by
              intro right_zero
              exact sum_nonzero (by simp [left_zero, right_zero]), length_le⟩
          · left
            exact ⟨left_zero, length_le⟩ }

/-- Pointwise negation of completed coefficient families. -/
instance : Neg (CompletedNovikovSeries Curve Coefficient length) where
  neg series :=
    { coefficient := -series.coefficient
      finite_below := fun cutoff ↦ (series.finite_below cutoff).subset <| by
        intro degree membership
        exact ⟨by simpa using membership.1, membership.2⟩ }

/-- Pointwise subtraction of completed coefficient families. -/
instance : Sub (CompletedNovikovSeries Curve Coefficient length) where
  sub left right :=
    { coefficient := left.coefficient - right.coefficient
      finite_below := fun cutoff ↦
        ((left.finite_below cutoff).union (right.finite_below cutoff)).subset <| by
          intro degree membership
          rcases membership with ⟨difference_nonzero, length_le⟩
          by_cases left_zero : left.coefficient degree = 0
          · right
            exact ⟨by
              intro right_zero
              exact difference_nonzero (by simp [left_zero, right_zero]), length_le⟩
          · left
            exact ⟨left_zero, length_le⟩ }

/-- Pointwise natural scalar multiplication. -/
instance : SMul ℕ (CompletedNovikovSeries Curve Coefficient length) where
  smul scalar series :=
    { coefficient := scalar • series.coefficient
      finite_below := fun cutoff ↦ (series.finite_below cutoff).subset <| by
        intro degree membership
        exact ⟨by
          intro coefficient_zero
          exact membership.1 (by simp [coefficient_zero]), membership.2⟩ }

/-- Pointwise integral scalar multiplication. -/
instance : SMul ℤ (CompletedNovikovSeries Curve Coefficient length) where
  smul scalar series :=
    { coefficient := scalar • series.coefficient
      finite_below := fun cutoff ↦ (series.finite_below cutoff).subset <| by
        intro degree membership
        exact ⟨by
          intro coefficient_zero
          exact membership.1 (by simp [coefficient_zero]), membership.2⟩ }

/-- Coefficients of a sum are pointwise sums. -/
@[simp]
theorem coefficient_add
    (left right : CompletedNovikovSeries Curve Coefficient length) :
    (left + right).coefficient = left.coefficient + right.coefficient :=
  rfl

/-- Coefficients of a negative are pointwise negatives. -/
@[simp]
theorem coefficient_neg
    (series : CompletedNovikovSeries Curve Coefficient length) :
    (-series).coefficient = -series.coefficient :=
  rfl

/-- Coefficients of a difference are pointwise differences. -/
@[simp]
theorem coefficient_sub
    (left right : CompletedNovikovSeries Curve Coefficient length) :
    (left - right).coefficient = left.coefficient - right.coefficient :=
  rfl

/-- Natural scalar multiplication acts coefficientwise. -/
@[simp]
theorem coefficient_nsmul (scalar : ℕ)
    (series : CompletedNovikovSeries Curve Coefficient length) :
    (scalar • series).coefficient = scalar • series.coefficient :=
  rfl

/-- Integral scalar multiplication acts coefficientwise. -/
@[simp]
theorem coefficient_zsmul (scalar : ℤ)
    (series : CompletedNovikovSeries Curve Coefficient length) :
    (scalar • series).coefficient = scalar • series.coefficient :=
  rfl

/-- Completed coefficient families inherit their additive commutative group
structure pointwise. -/
instance : AddCommGroup (CompletedNovikovSeries Curve Coefficient length) :=
  Function.Injective.addCommGroup
    (fun series : CompletedNovikovSeries Curve Coefficient length ↦
      series.coefficient)
    (fun _ _ equality ↦ ext equality)
    rfl (fun _ _ ↦ rfl) (fun _ ↦ rfl) (fun _ _ ↦ rfl)
    (fun _ _ ↦ rfl) (fun _ _ ↦ rfl)

end Additive

variable [Zero Coefficient]

/-- A completed coefficient family is zero exactly when all coefficients are
zero. -/
theorem eq_zero_iff
    (series : CompletedNovikovSeries Curve Coefficient length) :
    series = 0 ↔ series.coefficient = 0 := by
  constructor
  · rintro rfl
    rfl
  · intro coefficients_zero
    exact ext coefficients_zero

/-- The set of lengths at which a series has a nonzero coefficient. -/
def supportLengths (series : CompletedNovikovSeries Curve Coefficient length) : Set ℕ :=
  {cutoff | ∃ degree, series.coefficient degree ≠ 0 ∧ length degree = cutoff}

/-- The least length carrying a nonzero coefficient.  For the zero series the
value is the conventional `sInf ∅ = 0`; all substantive theorems assume a
nonzero series. -/
noncomputable def lowestLength
    (series : CompletedNovikovSeries Curve Coefficient length) : ℕ :=
  sInf series.supportLengths

/-- The finite set of degrees with nonzero coefficient at the least occupied
length. -/
noncomputable def lowestSupport
    (series : CompletedNovikovSeries Curve Coefficient length) : Finset Curve := by
  classical
  exact (series.finite_below series.lowestLength).toFinset.filter fun degree ↦
    length degree = series.lowestLength

/-- A nonzero completed series has at least one occupied length. -/
theorem supportLengths_nonempty
    (series : CompletedNovikovSeries Curve Coefficient length)
    (series_nonzero : series.coefficient ≠ 0) : series.supportLengths.Nonempty := by
  obtain ⟨degree, coefficient_nonzero⟩ := Function.ne_iff.mp series_nonzero
  exact ⟨length degree, degree, coefficient_nonzero, rfl⟩

/-- Membership in the lowest support is exactly nonzero coefficient together
with equality to the least occupied length. -/
theorem mem_lowestSupport_iff
    (series : CompletedNovikovSeries Curve Coefficient length)
    (degree : Curve) :
    degree ∈ series.lowestSupport ↔
      series.coefficient degree ≠ 0 ∧ length degree = series.lowestLength := by
  classical
  simp only [lowestSupport, Finset.mem_filter, Set.Finite.mem_toFinset]
  constructor
  · rintro ⟨⟨coefficient_nonzero, _⟩, length_equal⟩
    exact ⟨coefficient_nonzero, length_equal⟩
  · rintro ⟨coefficient_nonzero, length_equal⟩
    exact ⟨⟨coefficient_nonzero, length_equal.le⟩, length_equal⟩

/-- The lowest support of a nonzero completed series is nonempty. -/
theorem lowestSupport_nonempty
    (series : CompletedNovikovSeries Curve Coefficient length)
    (series_nonzero : series.coefficient ≠ 0) : series.lowestSupport.Nonempty := by
  have lengths_nonempty := series.supportLengths_nonempty series_nonzero
  obtain ⟨degree, coefficient_nonzero, length_equal⟩ :=
    Nat.sInf_mem lengths_nonempty
  exact ⟨degree, series.mem_lowestSupport_iff degree |>.mpr
    ⟨coefficient_nonzero, length_equal⟩⟩

/-- The least occupied length is no larger than the length of any nonzero
coefficient. -/
theorem lowestLength_le
    (series : CompletedNovikovSeries Curve Coefficient length)
    {degree : Curve} (coefficient_nonzero : series.coefficient degree ≠ 0) :
    series.lowestLength ≤ length degree :=
  Nat.sInf_le ⟨degree, coefficient_nonzero, rfl⟩

/-- The completed-series support and finite-character steps of divisor
tagging.  For a nonzero series and an injective integral pairing vector, Lean
constructs an integral direction separating the finite lowest support.  Every
family of nonzero leading coefficients on that support then yields a nonzero
sum of the corresponding formal exponential characters over any
characteristic-zero field.

The supplied `leadingCoefficient` represents the nonzero associated-graded
coefficient of each lowest monomial after specialization.  This theorem does
not construct those coefficients or identify the initial form of a completed
specialized series with this sum. -/
theorem exists_integralDirection_lowestSupport_exponentialSum_ne_zero
    {K : Type*} [Field K] [CharZero K]
    (series : CompletedNovikovSeries Curve Coefficient length)
    (series_nonzero : series.coefficient ≠ 0)
    {rank : ℕ} (pairingVector : Curve → Fin rank → ℤ)
    (pairingVector_injective : Function.Injective pairingVector) :
    ∃ direction : Fin rank → ℤ,
      Function.Injective (fun degree : series.lowestSupport ↦
        ∑ coordinate, direction coordinate * pairingVector degree coordinate) ∧
      ∀ leadingCoefficient : series.lowestSupport → K,
        (∀ degree, leadingCoefficient degree ≠ 0) →
        ∑ degree, leadingCoefficient degree • formalExponentialCharacter
          ((∑ coordinate, direction coordinate *
            pairingVector degree coordinate : ℤ) : K) ≠ 0 := by
  classical
  let enumeration := (Fintype.equivFin series.lowestSupport).symm
  have enumerated_pairing_injective : Function.Injective
      (fun index ↦ pairingVector (enumeration index : Curve)) :=
    pairingVector_injective.comp (Subtype.val_injective.comp enumeration.injective)
  obtain ⟨direction, scalar_injective, character_independent⟩ :=
    exists_integralDirection_separating_formalExponentialCharacters
      (K := K) (fun index ↦ pairingVector (enumeration index : Curve))
      enumerated_pairing_injective
  have support_nonempty := series.lowestSupport_nonempty series_nonzero
  refine ⟨direction, ?_, ?_⟩
  · intro left right equality
    apply enumeration.symm.injective
    apply scalar_injective
    simpa [enumeration] using equality
  · intro leadingCoefficient leading_nonzero combination_zero
    let coefficient : Fin (Fintype.card series.lowestSupport) → K :=
      fun index ↦ leadingCoefficient (enumeration index)
    have relation : ∑ index, coefficient index • formalExponentialCharacter
        ((∑ coordinate, direction coordinate *
          pairingVector (enumeration index : Curve) coordinate : ℤ) : K) = 0 := by
      simpa [coefficient] using
        (Equiv.sum_comp enumeration (fun degree ↦
          leadingCoefficient degree • formalExponentialCharacter
            ((∑ coordinate, direction coordinate *
              pairingVector degree coordinate : ℤ) : K))).trans combination_zero
    have coefficient_zero := character_independent coefficient relation
    obtain ⟨degree, degree_mem⟩ := support_nonempty
    have := congrFun coefficient_zero ((Fintype.equivFin series.lowestSupport) ⟨degree, degree_mem⟩)
    exact leading_nonzero ⟨degree, degree_mem⟩ (by simpa [coefficient, enumeration] using this)

end CompletedNovikovSeries

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
