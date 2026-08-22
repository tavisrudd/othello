import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovConvolution

/-!
# Degree-truncation inverse limit for completed Novikov coefficients

For an effective additive monoid with an additive natural-number grading, a
completed Novikov coefficient family is equivalent to a compatible family of
finite additive-monoid-algebra truncations.  A truncation at level `c` is
supported in degrees at most `c`; compatibility says that the coefficient of
every class of degree at most `c` is unchanged at all higher levels.

The construction is coefficientwise.  It gives an explicit coefficientwise
inverse-limit model and mutually inverse maps, but it does not equip that model
with a topology, prove a topological universal property, or identify it with a
completion in a category of topological rings.  All proofs are symbolic and
kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

variable {Curve R : Type*} [AddCommMonoid Curve]

namespace FiniteDegreeAddCommMonoid

/-- A compatible family of finite degree truncations.  Each level is an
ordinary additive monoid algebra with support bounded by its index. -/
structure DegreeTruncationFamily
    (grading : FiniteDegreeAddCommMonoid Curve) (R : Type*) [CommRing R] where
  level : ℕ → AddMonoidAlgebra R Curve
  support_degree_le : ∀ cutoff curve,
    level cutoff curve ≠ 0 → grading.degree curve ≤ cutoff
  compatible : ∀ lower upper, lower ≤ upper → ∀ curve,
    grading.degree curve ≤ lower → level upper curve = level lower curve

namespace DegreeTruncationFamily

variable (grading : FiniteDegreeAddCommMonoid Curve)

/-- Two compatible truncation families are equal when all their finite levels
are equal. -/
@[ext]
theorem ext [CommRing R]
    {left right : DegreeTruncationFamily grading R}
    (levels : left.level = right.level) : left = right := by
  cases left
  cases right
  cases levels
  rfl

/-- A completed coefficient family gives its compatible system of finite
degree truncations. -/
noncomputable def ofCompleted [CommRing R]
    (series : CompletedNovikovRing grading R) :
    DegreeTruncationFamily grading R where
  level cutoff := grading.truncation series cutoff
  support_degree_le cutoff curve coefficient_nonzero := by
    by_contra degree_not_le
    exact coefficient_nonzero
      (grading.truncation_apply_of_degree_not_le series cutoff curve degree_not_le)
  compatible lower upper lower_le_upper curve curve_below := by
    rw [grading.truncation_apply_of_degree_le series upper curve
        (curve_below.trans lower_le_upper),
      grading.truncation_apply_of_degree_le series lower curve curve_below]

/-- A compatible truncation family determines one completed coefficient
family by reading the coefficient of a class at its own degree. -/
noncomputable def toCompleted [CommRing R]
    (family : DegreeTruncationFamily grading R) :
    CompletedNovikovRing grading R where
  coefficient curve := family.level (grading.degree curve) curve
  finite_below cutoff := by
    refine family.level cutoff |>.support.finite_toSet.subset ?_
    intro curve membership
    rcases membership with ⟨coefficient_nonzero, curve_below⟩
    apply Finsupp.mem_support_iff.mpr
    rw [family.compatible (grading.degree curve) cutoff curve_below curve le_rfl]
    exact coefficient_nonzero

/-- Reconstructing a completed family from its truncations returns the
original coefficient family. -/
theorem toCompleted_ofCompleted [CommRing R]
    (series : CompletedNovikovRing grading R) :
    (ofCompleted grading series).toCompleted = series := by
  apply CompletedNovikovSeries.ext
  funext curve
  exact grading.truncation_apply_of_degree_le series (grading.degree curve) curve le_rfl

/-- Truncating the reconstructed completed family returns every supplied
finite level exactly. -/
theorem ofCompleted_toCompleted [CommRing R]
    (family : DegreeTruncationFamily grading R) :
    ofCompleted grading family.toCompleted = family := by
  cases family with
  | mk level support_degree_le compatible =>
      apply DegreeTruncationFamily.ext
      funext cutoff
      ext curve
      by_cases curve_below : grading.degree curve ≤ cutoff
      · rw [ofCompleted,
          grading.truncation_apply_of_degree_le _ cutoff curve curve_below]
        exact compatible (grading.degree curve) cutoff curve_below curve le_rfl |>.symm
      · rw [ofCompleted,
          grading.truncation_apply_of_degree_not_le _ cutoff curve curve_below]
        symm
        by_contra coefficient_nonzero
        exact curve_below (support_degree_le cutoff curve coefficient_nonzero)

/-- Completed coefficient families are equivalent, as types, to compatible
finite degree-truncation families. -/
noncomputable def completedEquivTruncationFamily [CommRing R] :
    CompletedNovikovRing grading R ≃ DegreeTruncationFamily grading R where
  toFun := ofCompleted grading
  invFun := toCompleted grading
  left_inv := toCompleted_ofCompleted grading
  right_inv := ofCompleted_toCompleted grading

end DegreeTruncationFamily

end FiniteDegreeAddCommMonoid

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
