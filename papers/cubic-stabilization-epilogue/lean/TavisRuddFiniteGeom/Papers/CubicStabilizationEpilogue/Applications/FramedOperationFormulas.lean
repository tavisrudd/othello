import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedMultiplicity

/-!
# Primitive-sixth multiplicity under projective bundles and blowups

This module isolates the exact deduction of the framed operation formulas
from characteristic-polynomial comparison data.  The geometric signature uses
relations, so it covers arbitrary vector bundles and arbitrary smooth blowup
centers rather than choosing one total space for each base.

For a rank-`r` projective bundle, the supplied comparison identifies the total
characteristic polynomial with the `r`-th power of the base polynomial.  For a
codimension-`c` blowup, a supplied family of `c - 1` center specializations and
comparison identity express the total polynomial as the product of the ambient
polynomial and the specialized center polynomials.  Lean derives the two
primitive-sixth multiplicity formulas from root-multiplicity additivity.

The projective-bundle comparison input is the consequence used in the
manuscript from Hiroshi Iritani and Yuki Koto, *Quantum cohomology of
projective bundles*, arXiv:2307.03696v4 (2026), Proposition 5.6 and Section
5.8, especially equation (5.11).  The blowup input is the consequence used
from Hiroshi Iritani, *Quantum cohomology of blowups*,
arXiv:2307.13555v3 (2025), Theorem 5.18 and Section 5.8.2.  The polynomial
identities below are the framed-monodromy consequences consumed by the
manuscript, not verbatim statements of those sources.

Lean does not construct varieties, vector bundles, blowups, quantum
connections, comparison coordinates, numerical Novikov specializations, or
the characteristic-polynomial comparison identities.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

/-- Geometric and framed-monodromy signature for the two operation formulas. -/
structure FramedOperationGeometry (Object : Type*) where
  /-- Relation asserting that `total` is the projectivization of a rank-`r`
  vector bundle over `base`. -/
  IsProjectiveBundle : ℕ → Object → Object → Prop
  /-- Relation asserting that `total` is the blowup of `ambient` along the
  smooth subobject `center` of the supplied codimension. -/
  IsBlowup : ℕ → Object → Object → Object → Prop
  /-- Numerical Novikov specializations attached to an object. -/
  Specialization : Object → Type*
  /-- Intrinsic framed-monodromy matrix. -/
  intrinsicMonodromy : Object → Quantum.FramedMonodromyMatrix
  /-- Framed-monodromy matrix after a supplied numerical Novikov
  specialization. -/
  specializedMonodromy :
    (object : Object) → Specialization object → Quantum.FramedMonodromyMatrix

/-- External comparison data at exactly the characteristic-polynomial level
needed for the framed operation formulas. -/
structure FramedOperationComparisonInput
    {Object : Type*} (geometry : FramedOperationGeometry Object) where
  /-- A rank-`r` projective bundle has the `r`-fold repeated base
  characteristic polynomial. -/
  projectiveBundleCharpoly : ∀ rank, 2 ≤ rank → ∀ base total,
    geometry.IsProjectiveBundle rank base total →
      (geometry.intrinsicMonodromy total).operator.charpoly =
        (geometry.intrinsicMonodromy base).operator.charpoly ^ rank
  /-- The `c - 1` numerical Novikov specializations of the center summands in
  a codimension-`c` blowup comparison. -/
  centerSpecialization : ∀ codim, 2 ≤ codim → ∀ center ambient total,
    geometry.IsBlowup codim center ambient total →
      Fin (codim - 1) → geometry.Specialization center
  /-- The blowup characteristic polynomial is the ambient polynomial times
  the finite product of the specialized center polynomials. -/
  blowupCharpoly : ∀ codim (codimAtLeastTwo : 2 ≤ codim)
      center ambient total (blowup : geometry.IsBlowup codim center ambient total),
    (geometry.intrinsicMonodromy total).operator.charpoly =
      (geometry.intrinsicMonodromy ambient).operator.charpoly *
        (List.ofFn fun index : Fin (codim - 1) ↦
          (geometry.specializedMonodromy center
            (centerSpecialization codim codimAtLeastTwo center ambient total
              blowup index)).operator.charpoly).prod

/-- The framed projective-bundle formula follows from the supplied repeated
characteristic-polynomial comparison. -/
theorem projectiveBundle_sixthMultiplicity
    {Object : Type*} (geometry : FramedOperationGeometry Object)
    (input : FramedOperationComparisonInput geometry)
    (rank : ℕ) (rankAtLeastTwo : 2 ≤ rank) (base total : Object)
    (bundle : geometry.IsProjectiveBundle rank base total) :
    (geometry.intrinsicMonodromy total).sixthMultiplicity =
      rank * (geometry.intrinsicMonodromy base).sixthMultiplicity := by
  change Quantum.sixthMultiplicityPolynomial
      (geometry.intrinsicMonodromy total).operator.charpoly = _
  rw [input.projectiveBundleCharpoly rank rankAtLeastTwo base total bundle]
  exact Quantum.sixthMultiplicityPolynomial_pow _
    (Matrix.charpoly_monic _).ne_zero rank

/-- The framed blowup formula follows from the supplied finite block-product
comparison and its `c - 1` specialized center summands. -/
theorem blowup_sixthMultiplicity
    {Object : Type*} (geometry : FramedOperationGeometry Object)
    (input : FramedOperationComparisonInput geometry)
    (codim : ℕ) (codimAtLeastTwo : 2 ≤ codim)
    (center ambient total : Object)
    (blowup : geometry.IsBlowup codim center ambient total) :
    (geometry.intrinsicMonodromy total).sixthMultiplicity =
      (geometry.intrinsicMonodromy ambient).sixthMultiplicity +
        ∑ index : Fin (codim - 1),
          (geometry.specializedMonodromy center
            (input.centerSpecialization codim codimAtLeastTwo center ambient
              total blowup index)).sixthMultiplicity := by
  let centerPolynomials : List (Polynomial ℂ) :=
    List.ofFn fun index : Fin (codim - 1) ↦
      (geometry.specializedMonodromy center
        (input.centerSpecialization codim codimAtLeastTwo center ambient total
          blowup index)).operator.charpoly
  have centerNonzero : ∀ polynomial ∈ centerPolynomials, polynomial ≠ 0 := by
    intro polynomial membership
    rw [show centerPolynomials = List.ofFn (fun index : Fin (codim - 1) ↦
      (geometry.specializedMonodromy center
        (input.centerSpecialization codim codimAtLeastTwo center ambient total
          blowup index)).operator.charpoly) from rfl] at membership
    obtain ⟨index, rfl⟩ := List.mem_ofFn.mp membership
    exact (Matrix.charpoly_monic _).ne_zero
  have centerProductNonzero : centerPolynomials.prod ≠ 0 := by
    apply List.prod_ne_zero
    intro zeroMembership
    exact (centerNonzero 0 zeroMembership) rfl
  change Quantum.sixthMultiplicityPolynomial
      (geometry.intrinsicMonodromy total).operator.charpoly = _
  rw [input.blowupCharpoly codim codimAtLeastTwo center ambient total blowup]
  change Quantum.sixthMultiplicityPolynomial
      ((geometry.intrinsicMonodromy ambient).operator.charpoly *
        centerPolynomials.prod) = _
  rw [Quantum.sixthMultiplicityPolynomial_mul
    (Matrix.charpoly_monic _).ne_zero centerProductNonzero]
  rw [Quantum.sixthMultiplicityPolynomial_list_prod centerPolynomials centerNonzero]
  simp [centerPolynomials, Quantum.FramedMonodromyMatrix.sixthMultiplicity,
    Quantum.sixthMultiplicityPolynomial, List.sum_ofFn]

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
