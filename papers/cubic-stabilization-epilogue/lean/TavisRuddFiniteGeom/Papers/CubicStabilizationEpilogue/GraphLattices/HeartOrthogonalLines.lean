import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.TraceDeterminantPairing

/-!
# Orthogonal lines and small stable subgroups of the two-primary heart

The two-primary coefficient heart is a two-dimensional vector space over the
four-element field, carrying the trace-determinant pairing to the two-element
field.  Two facts about that pairing decide the shape of an odd-degree isogeny
onto the intermediate Jacobian from a product of abelian varieties.

The first is that a line over the four-element field is totally isotropic, so
that two such lines orthogonal to one another coincide and cannot be
complementary: an orthogonal decomposition of the heart into subspaces over the
four-element field cannot have two one-dimensional summands, and one summand
must carry the whole heart.  Here it is proved through the determinant of the
two spanning vectors: orthogonality of the two lines forces that determinant to
vanish, because the trace form of the four-element field over the two-element
field is nondegenerate, and a vanishing determinant makes the second vector a
multiple of the first.

The second is that a subgroup of the heart stable under the four-element field
and small enough to be cyclic and killed by two must vanish, since a nonzero
stable subgroup contains the four multiples of any of its nonzero elements.

Nothing about abelian varieties, isogenies, polarizations, or the integral
homology of the intermediate Jacobian is constructed here: this module is about
the concrete two-dimensional model of the heart and its pairing.  All proofs are
symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

noncomputable section

/-- The trace-determinant pairing of two multiples of one vector, as the trace
of the product of the two scalars with the determinant of the vector against
itself. -/
theorem f4TraceDeterminantPairing_smul_smul (first second : F4) (left right : F4 × F4) :
    f4TraceDeterminantPairing (first • left) (second • right) =
      Algebra.trace (ZMod 2) F4 (first * second * (left.1 * right.2 - left.2 * right.1)) := by
  rw [f4TraceDeterminantPairing_apply]
  congr 1
  simp only [Prod.smul_fst, Prod.smul_snd, smul_eq_mul]
  ring

/-- A line over the four-element field is totally isotropic for the
trace-determinant pairing: the determinant of a vector against itself
vanishes. -/
theorem f4TraceDeterminantPairing_isotropic_on_line (first second : F4) (point : F4 × F4) :
    f4TraceDeterminantPairing (first • point) (second • point) = 0 := by
  rw [f4TraceDeterminantPairing_smul_smul]
  simp [mul_comm]

/-- Orthogonality of the two lines spanned by two vectors forces the
determinant of those vectors to vanish, because the trace form of the
four-element field over the two-element field is nondegenerate. -/
theorem determinant_eq_zero_of_orthogonal_lines {left right : F4 × F4}
    (orthogonal : ∀ first second : F4,
      f4TraceDeterminantPairing (first • left) (second • right) = 0) :
    left.1 * right.2 - left.2 * right.1 = 0 := by
  refine (traceForm_nondegenerate (ZMod 2) F4).1 _ ?_
  intro coefficient
  have vanishing := orthogonal coefficient 1
  rw [f4TraceDeterminantPairing_smul_smul] at vanishing
  rw [Algebra.traceForm_apply]
  rw [mul_comm (left.1 * right.2 - left.2 * right.1) coefficient]
  simpa using vanishing

/-- A vanishing determinant makes the second vector a multiple of the first,
once the first is nonzero. -/
theorem exists_smul_of_determinant_eq_zero {left right : F4 × F4} (nonzero : left ≠ 0)
    (determinant : left.1 * right.2 - left.2 * right.1 = 0) :
    ∃ scalar : F4, right = scalar • left := by
  rcases eq_or_ne left.1 0 with firstZero | firstNonzero
  · have secondNonzero : left.2 ≠ 0 := by
      intro secondZero
      exact nonzero (Prod.ext firstZero secondZero)
    have rightFirstZero : right.1 = 0 := by
      have : left.2 * right.1 = 0 := by
        have := determinant
        rw [firstZero, zero_mul, zero_sub, neg_eq_zero] at this
        exact this
      exact (mul_eq_zero.1 this).resolve_left secondNonzero
    refine ⟨right.2 * left.2⁻¹, Prod.ext ?_ ?_⟩
    · simp [Prod.smul_fst, smul_eq_mul, rightFirstZero, firstZero]
    · simp only [Prod.smul_snd, smul_eq_mul]
      field_simp
  · have key : left.1 * right.2 = left.2 * right.1 := by
      rw [← sub_eq_zero]; exact determinant
    refine ⟨right.1 * left.1⁻¹, Prod.ext ?_ ?_⟩
    · simp only [Prod.smul_fst, smul_eq_mul]
      field_simp
    · simp only [Prod.smul_snd, smul_eq_mul]
      field_simp
      linear_combination key

/-- Two lines over the four-element field that are orthogonal for the
trace-determinant pairing coincide: the second spanning vector is a multiple of
the first.  Two such lines are therefore never complementary, which is why an
orthogonal decomposition of the heart cannot have two one-dimensional
summands. -/
theorem orthogonal_lines_coincide {left right : F4 × F4} (nonzero : left ≠ 0)
    (orthogonal : ∀ first second : F4,
      f4TraceDeterminantPairing (first • left) (second • right) = 0) :
    ∃ scalar : F4, right = scalar • left :=
  exists_smul_of_determinant_eq_zero nonzero
    (determinant_eq_zero_of_orthogonal_lines orthogonal)

/-- A nonzero subspace of the heart over the four-element field has at least
four elements: the multiples of one of its nonzero elements are already four
distinct members. -/
theorem four_le_natCard_of_ne_bot {subspace : Submodule F4 (F4 × F4)}
    (nontrivial : subspace ≠ ⊥) : 4 ≤ Nat.card subspace := by
  classical
  obtain ⟨point, membership, nonzero⟩ := Submodule.exists_mem_ne_zero_of_ne_bot nontrivial
  have injective : Function.Injective fun scalar : F4 =>
      (⟨scalar • point, subspace.smul_mem scalar membership⟩ : subspace) := by
    intro first second equality
    have : first • point = second • point := congrArg Subtype.val equality
    have difference : (first - second) • point = 0 := by
      rw [sub_smul, this, sub_self]
    rcases smul_eq_zero.1 difference with scalarZero | pointZero
    · exact sub_eq_zero.1 scalarZero
    · exact absurd pointZero nonzero
  calc (4 : ℕ) = Nat.card F4 := natCard_F4.symm
    _ ≤ Nat.card subspace := Nat.card_le_card_of_injective _ injective

/-- A subspace of the heart over the four-element field that is small enough to
be cyclic and killed by two vanishes.  This is the parity step ruling out an
odd-degree isogeny from a product of five elliptic curves: each of the five
summands of the heart would be cyclic of exponent two, hence trivial, and the
heart would vanish. -/
theorem eq_bot_of_natCard_le_two {subspace : Submodule F4 (F4 × F4)}
    (small : Nat.card subspace ≤ 2) : subspace = ⊥ := by
  by_contra nontrivial
  have := four_le_natCard_of_ne_bot nontrivial
  omega

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
