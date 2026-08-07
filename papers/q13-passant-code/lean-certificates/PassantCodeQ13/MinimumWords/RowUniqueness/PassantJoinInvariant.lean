import PassantCodeQ13.MinimumWords.RowUniqueness.PolarGram
import RelativeConicArcs.PassantCodeQ13.Reconstruction

/-!
# The join of two internal points, read in the elliptic parameter

A line of the plane meets the conic `Y^2 - XZ = 0` in the zeros of the binary form it carries, so
the line is a passant exactly when that form has nonsquare discriminant.  For the join of two points
`P` and `R` the restricted form is `s^2 Δ(P) + s t · polarValue P R + t^2 Δ(R)`, and its
discriminant is the dual-conic value of the join:

  `lineDiscriminant (joinTriple P R) = polarValue P R ^ 2 - 4 Δ(P) Δ(R)`.

Dividing by `Δ(P) Δ(R)` turns this into a statement about the elliptic parameter
`polarInvariant P R = polarValue P R ^ 2 / (Δ(P) Δ(R))`, the projective invariant of the pair: the
join is a passant exactly when `polarInvariant P R - 4` is a nonzero nonsquare.  For internal points
`Δ(P) Δ(R)` is a product of two nonsquares, hence a nonzero square, so the parameter is itself a
square, and the two conditions together leave it the three values `9`, `10` and `12`.  Those are the
three elliptic classes of the association scheme whose pairs are joined by a passant.

The value `4` is excluded for a joined pair, since it is not among the three.  It says exactly that
the restricted form has vanishing discriminant, that is, that the join is tangent to the conic.

The finite content is three exhaustions over the elements of `ZMod 13` and over ordered pairs of
them, all discharged by kernel reduction.  The rest is polynomial identity together with the
uniqueness of the join supplied by `PassantCodeQ13.PlaneJoin.existsUnique_incident`.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.PlaneJoin
open PassantCodeQ13.SymmetricSquare

/-- The dual-conic value of the join of two coordinate triples is the discriminant of the binary
form the join carries. -/
theorem lineDiscriminant_joinTriple (first second : Triple) :
    lineDiscriminant (joinTriple first second)
      = polarValue first second ^ 2
        - 4 * (pointDiscriminant first * pointDiscriminant second) := by
  simp only [lineDiscriminant, joinTriple, polarValue, pointDiscriminant]
  ring

/-- Rescaling a dual triple multiplies its dual-conic value by the square of the factor. -/
theorem lineDiscriminant_scaleTriple (factor : Field13) (line : Triple) :
    lineDiscriminant (scaleTriple factor line) = factor ^ 2 * lineDiscriminant line := by
  simp only [lineDiscriminant, scaleTriple]
  ring

/-- Membership in the normalized passant coordinates, unfolded. -/
theorem mem_passantCoordinates_iff (line : Triple) :
    line ∈ passantCoordinates ↔
      line ∈ projectiveTripleList ∧
        lineDiscriminant line ≠ 0 ∧ isNonzeroSquare (lineDiscriminant line) = false := by
  rw [passantCoordinates, Finset.mem_filter, projectiveTriples, List.mem_toFinset]

/-- An internal point is a normalized representative whose conic value is a nonzero nonsquare. -/
theorem mem_internalCoordinates_iff (point : Triple) :
    point ∈ internalCoordinates ↔
      point ∈ projectiveTripleList ∧
        pointDiscriminant point ≠ 0 ∧ isNonzeroSquare (pointDiscriminant point) = false := by
  rw [internalCoordinates, Finset.mem_filter, projectiveTriples, List.mem_toFinset]

/-- A nonzero field element has nonzero square. -/
private theorem sq_ne_zero_field : ∀ value : Field13, value ≠ 0 → value ^ 2 ≠ 0 := by
  decide +kernel

/-- A product of two nonsquares is a nonzero square. -/
private theorem mul_nonsquares_isNonzeroSquare :
    ∀ firstValue secondValue : Field13, firstValue ≠ 0 → isNonzeroSquare firstValue = false →
      secondValue ≠ 0 → isNonzeroSquare secondValue = false →
      firstValue * secondValue ≠ 0 ∧ isNonzeroSquare (firstValue * secondValue) = true := by
  decide +kernel

/-- Two distinct internal points are joined by a passant exactly when the dual-conic value of their
join is a nonzero nonsquare.  Both directions go through the unique normalized representative
incident to the two points. -/
theorem hasPassantJoin_iff_lineDiscriminant {first second : InternalPoint}
    (different : first ≠ second) :
    HasPassantJoin first second ↔
      lineDiscriminant (joinTriple first.1 second.1) ≠ 0 ∧
        isNonzeroSquare (lineDiscriminant (joinTriple first.1 second.1)) = false := by
  have first_mem := (mem_internalCoordinates_iff first.1).mp first.2
  have second_mem := (mem_internalCoordinates_iff second.1).mp second.2
  have coordinates_different : first.1 ≠ second.1 := fun equality => different (Subtype.ext equality)
  have join_nonzero := joinTriple_ne_zero first_mem.1 second_mem.1 coordinates_different
  obtain ⟨factor, factor_nonzero, rescaled⟩ := normalizeTriple_eq_scaleTriple join_nonzero
  have unique := existsUnique_incident first_mem.1 second_mem.1 coordinates_different
  have normalized_value :
      lineDiscriminant (MinimumWords.normalizeTriple (joinTriple first.1 second.1))
        = factor ^ 2 * lineDiscriminant (joinTriple first.1 second.1) := by
    rw [rescaled, lineDiscriminant_scaleTriple]
  have normalized_mem :
      MinimumWords.normalizeTriple (joinTriple first.1 second.1) ∈ projectiveTripleList :=
    normalizeTriple_mem_projectiveTripleList _
  constructor
  · rintro ⟨line, first_incident, second_incident⟩
    have line_mem := (mem_passantCoordinates_iff line.1).mp line.2
    have line_eq : line.1 = MinimumWords.normalizeTriple (joinTriple first.1 second.1) := by
      obtain ⟨witness, _, only⟩ := unique
      rw [only line.1 ⟨line_mem.1, first_incident, second_incident⟩,
        only (MinimumWords.normalizeTriple (joinTriple first.1 second.1)) ⟨normalized_mem, ?_, ?_⟩]
      · rw [rescaled]
        have expand : dotTriple (scaleTriple factor (joinTriple first.1 second.1)) first.1
            = factor * dotTriple (joinTriple first.1 second.1) first.1 := by
          simp only [dotTriple, scaleTriple]
          ring
        rw [expand, dotTriple_joinTriple_left, mul_zero]
      · rw [rescaled]
        have expand : dotTriple (scaleTriple factor (joinTriple first.1 second.1)) second.1
            = factor * dotTriple (joinTriple first.1 second.1) second.1 := by
          simp only [dotTriple, scaleTriple]
          ring
        rw [expand, dotTriple_joinTriple_right, mul_zero]
    rw [line_eq, normalized_value] at line_mem
    obtain ⟨_, line_nonzero, line_nonsquare⟩ := line_mem
    rw [isNonzeroSquare_sq_mul _ _ factor_nonzero] at line_nonsquare
    refine ⟨fun vanishing => line_nonzero ?_, line_nonsquare⟩
    rw [vanishing, mul_zero]
  · rintro ⟨nonzero, nonsquare⟩
    refine ⟨⟨MinimumWords.normalizeTriple (joinTriple first.1 second.1),
      (mem_passantCoordinates_iff _).mpr ⟨normalized_mem, ?_, ?_⟩⟩, ?_, ?_⟩
    · rw [normalized_value]
      exact mul_ne_zero_field _ _ (sq_ne_zero_field _ factor_nonzero) nonzero
    · rw [normalized_value, isNonzeroSquare_sq_mul _ _ factor_nonzero]
      exact nonsquare
    · show dotTriple (MinimumWords.normalizeTriple (joinTriple first.1 second.1)) first.1 = 0
      rw [rescaled]
      have expand : dotTriple (scaleTriple factor (joinTriple first.1 second.1)) first.1
          = factor * dotTriple (joinTriple first.1 second.1) first.1 := by
        simp only [dotTriple, scaleTriple]
        ring
      rw [expand, dotTriple_joinTriple_left, mul_zero]
    · show dotTriple (MinimumWords.normalizeTriple (joinTriple first.1 second.1)) second.1 = 0
      rw [rescaled]
      have expand : dotTriple (scaleTriple factor (joinTriple first.1 second.1)) second.1
          = factor * dotTriple (joinTriple first.1 second.1) second.1 := by
        simp only [dotTriple, scaleTriple]
        ring
      rw [expand, dotTriple_joinTriple_right, mul_zero]

/-- The elliptic parameter of a pair whose join carries a nonsquare binary form takes one of three
values.  The parameter is a square because a product of two nonsquares is a square, and shifting by
four sends it to a nonsquare, so `9`, `10` and `12` are the only possibilities. -/
private theorem polarInvariant_values_of_nonsquare_discriminant :
    ∀ product polar : Field13, product ≠ 0 → isNonzeroSquare product = true →
      polar ^ 2 - 4 * product ≠ 0 → isNonzeroSquare (polar ^ 2 - 4 * product) = false →
      polar ^ 2 * product⁻¹ = 9 ∨ polar ^ 2 * product⁻¹ = 10 ∨ polar ^ 2 * product⁻¹ = 12 := by
  decide +kernel

/-- Two distinct internal points joined by a passant have elliptic parameter `9`, `10` or `12`. -/
theorem polarInvariant_of_hasPassantJoin {first second : InternalPoint}
    (different : first ≠ second) (joined : HasPassantJoin first second) :
    polarInvariant first.1 second.1 = 9 ∨ polarInvariant first.1 second.1 = 10 ∨
      polarInvariant first.1 second.1 = 12 := by
  have first_mem := (mem_internalCoordinates_iff first.1).mp first.2
  have second_mem := (mem_internalCoordinates_iff second.1).mp second.2
  obtain ⟨nonzero, nonsquare⟩ := (hasPassantJoin_iff_lineDiscriminant different).mp joined
  rw [lineDiscriminant_joinTriple] at nonzero nonsquare
  obtain ⟨product_nonzero, product_square⟩ := mul_nonsquares_isNonzeroSquare _ _
    first_mem.2.1 first_mem.2.2 second_mem.2.1 second_mem.2.2
  exact polarInvariant_values_of_nonsquare_discriminant _ _ product_nonzero product_square
    nonzero nonsquare

end PassantCodeQ13.MinimumWords.RowUniqueness
