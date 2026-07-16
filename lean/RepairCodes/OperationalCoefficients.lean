import RepairCodes.ProjectiveAxisTwistedCubicInvariants

/-!
# Coefficient-labelled repair equations and their operational boundary

The repair hypergraph deliberately remembers exact supports rather than a chosen dual word.  This
file records the scalar recovery equation supplied by every witness and gives closed coefficient
formulas for the three canonical radius-two/radius-three repair shapes of the completed
cubic--axis seed.  All displayed helper coefficients are nonzero under the hypotheses.

For a scalar code, the induced direct protocol reads one full field symbol from every helper.
These equations specify its local linear combination, but do not prove a lower bound on helper
access or download bandwidth; raw coefficient values also change under harmless column rescaling.
-/

namespace FiniteGeom

open Finset Matrix

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
  {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- Every support-level repair witness supplies an exact scalar recovery equation.  The sum is
over precisely the helper set: coefficients away from `insert x R` vanish by the support equality.
Thus a direct scalar repair reads one field symbol from each helper. -/
theorem repair_edge_has_scalar_recovery_equation
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ} {R : Finset ι}
    (hR : R ∈ repairHypergraph C x r) :
    ∃ y ∈ dualCode C, y x ≠ 0 ∧ wordSupport y = insert x R ∧
      ∀ c ∈ C, c x = -(y x)⁻¹ * ∑ j ∈ R, y j * c j := by
  classical
  obtain ⟨hsub, -, y, hy, hyx, hsupp⟩ := mem_repairHypergraph.mp hR
  refine ⟨y, hy, hyx, hsupp, ?_⟩
  intro c hc
  have hxR : x ∉ R := by
    intro hx
    exact (Finset.mem_erase.mp (hsub hx)).1 rfl
  have htotal : ∑ j ∈ insert x R, c j * y j = 0 := by
    calc
      (∑ j ∈ insert x R, c j * y j) = ∑ j, c j * y j := by
        apply Finset.sum_subset (Finset.subset_univ _)
        intro j _ hj
        have hj0 : y j = 0 := by
          have : j ∉ wordSupport y := by simpa only [hsupp] using hj
          simpa only [mem_wordSupport, not_not] using this
        simp [hj0]
      _ = c ⬝ᵥ y := rfl
      _ = 0 := hy c hc
  rw [Finset.sum_insert hxR] at htotal
  have hx : c x * y x = -(∑ j ∈ R, y j * c j) := by
    rw [show (∑ j ∈ R, y j * c j) = ∑ j ∈ R, c j * y j by
      apply Finset.sum_congr rfl
      intro j _
      exact mul_comm _ _]
    linear_combination htotal
  calc
    c x = (y x)⁻¹ * (c x * y x) := by field_simp
    _ = (y x)⁻¹ * (-(∑ j ∈ R, y j * c j)) := by rw [hx]
    _ = -(y x)⁻¹ * ∑ j ∈ R, y j * c j := by ring

end FiniteGeom

namespace RepairCodes

open FiniteGeom

variable {𝔽 : Type*} [Field 𝔽]

/-- Coefficient-labelled relation for repairing axis infinity from two distinct finite axis
points: `A(a) - A(b) + (b-a) A(∞) = 0`. -/
theorem projectiveAxisPair_coefficient_relation (a b : 𝔽) :
    projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inl a)) -
        projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inl b)) +
      (b - a) • projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) = 0 := by
  ext i
  fin_cases i <;>
    simp [projectiveAxisTwistedCubicPoints, axisTwistedCubicPoints]

/-- Every coefficient in the axis-pair relation is nonzero when the helpers are distinct. -/
theorem projectiveAxisPair_coefficients_ne_zero {a b : 𝔽} (hab : a ≠ b) :
    (1 : 𝔽) ≠ 0 ∧ (-1 : 𝔽) ≠ 0 ∧ b - a ≠ 0 := by
  exact ⟨one_ne_zero, neg_ne_zero.mpr one_ne_zero, sub_ne_zero.mpr hab.symm⟩

/-- Coefficient ratios are a coordinate gauge, not an operational invariant.  After rescaling the
helper column `A(a)` by `d⁻¹`, the same axis-pair support has any prescribed nonzero coefficient
`d` at that helper while the target coefficient `b-a` stays fixed.  The scale itself is nonzero,
so this is a monomially equivalent presentation. -/
theorem projectiveAxisPair_arbitrary_helperCoefficient {a b d : 𝔽}
    (hab : a ≠ b) (hd : d ≠ 0) :
    d⁻¹ ≠ 0 ∧ b - a ≠ 0 ∧
      d • (d⁻¹ • projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inl a))) -
          projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inl b)) +
        (b - a) • projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) = 0 := by
  refine ⟨inv_ne_zero hd, sub_ne_zero.mpr hab.symm, ?_⟩
  rw [smul_smul]
  have hscale : d * d⁻¹ = 1 := by field_simp
  rw [hscale]
  simp only [one_smul]
  exact projectiveAxisPair_coefficient_relation a b

/-- Coefficient-labelled relation for the canonical cubic-infinity repair:
`-(s-t)^3 C(∞) + C(s) - C(t) + (t-s) A(s+t) = 0`. -/
theorem projectiveCubicInfinity_coefficient_relation [CharP 𝔽 3] (s t : 𝔽) :
    (-(s - t) ^ 3) • projectiveAxisTwistedCubicPoints 𝔽 (.inl (.inr Unit.unit)) +
        projectiveAxisTwistedCubicPoints 𝔽 (.inl (.inl s)) -
        projectiveAxisTwistedCubicPoints 𝔽 (.inl (.inl t)) +
      (t - s) • projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inl (s + t))) = 0 := by
  ext i
  fin_cases i <;>
    simp [projectiveAxisTwistedCubicPoints, projectiveTwistedCubicPoints,
      axisTwistedCubicPoints, momentCurve, sub_eq_add_neg,
      Matrix.vecHead, Matrix.vecTail, Matrix.cons_val_zero, Matrix.cons_val_one,
      add_pow_char] <;> ring

/-- Every coefficient in the cubic-infinity relation is nonzero for distinct parameters. -/
theorem projectiveCubicInfinity_coefficients_ne_zero {s t : 𝔽} (hst : s ≠ t) :
    -(s - t) ^ 3 ≠ 0 ∧ (1 : 𝔽) ≠ 0 ∧ (-1 : 𝔽) ≠ 0 ∧ t - s ≠ 0 := by
  exact ⟨neg_ne_zero.mpr (pow_ne_zero 3 (sub_ne_zero.mpr hst)), one_ne_zero,
    neg_ne_zero.mpr one_ne_zero, sub_ne_zero.mpr hst.symm⟩

/-- Coefficient-labelled zero-sum cubic repair of axis infinity.  With
`V=(s-t)(s-u)(t-u)`, the relation is
`(t-u)C(s) + (u-s)C(t) + (s-t)C(u) - V A(∞) = 0`. -/
theorem projectiveAxisInfinityCubic_coefficient_relation
    (s t u : 𝔽) (hsum : s + t + u = 0) :
    (t - u) • projectiveAxisTwistedCubicPoints 𝔽 (.inl (.inl s)) +
        (u - s) • projectiveAxisTwistedCubicPoints 𝔽 (.inl (.inl t)) +
        (s - t) • projectiveAxisTwistedCubicPoints 𝔽 (.inl (.inl u)) -
      ((s - t) * (s - u) * (t - u)) •
        projectiveAxisTwistedCubicPoints 𝔽 (.inr (.inr Unit.unit)) = 0 := by
  ext i
  fin_cases i <;>
    simp [projectiveAxisTwistedCubicPoints, projectiveTwistedCubicPoints,
      axisTwistedCubicPoints, momentCurve, Pi.smul_apply,
      Matrix.cons_val_zero, Matrix.cons_val_one]
  case «1» => ring
  case «2» => ring
  case «3» =>
    linear_combination ((s - t) * (s - u) * (t - u)) * hsum

/-- Every coefficient in the zero-sum cubic relation is nonzero for distinct parameters. -/
theorem projectiveAxisInfinityCubic_coefficients_ne_zero
    {s t u : 𝔽} (hst : s ≠ t) (hsu : s ≠ u) (htu : t ≠ u) :
    t - u ≠ 0 ∧ u - s ≠ 0 ∧ s - t ≠ 0 ∧
      -((s - t) * (s - u) * (t - u)) ≠ 0 := by
  refine ⟨sub_ne_zero.mpr htu, sub_ne_zero.mpr hsu.symm, sub_ne_zero.mpr hst, ?_⟩
  exact neg_ne_zero.mpr (mul_ne_zero (mul_ne_zero (sub_ne_zero.mpr hst)
    (sub_ne_zero.mpr hsu)) (sub_ne_zero.mpr htu))

end RepairCodes

#print axioms FiniteGeom.repair_edge_has_scalar_recovery_equation
#print axioms RepairCodes.projectiveAxisPair_arbitrary_helperCoefficient
#print axioms RepairCodes.projectiveCubicInfinity_coefficient_relation
#print axioms RepairCodes.projectiveAxisInfinityCubic_coefficient_relation
