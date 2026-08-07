import PassantCodeQ13.MinimumWords.RowUniqueness.PassantJoinInvariant
import PassantCodeQ13.MinimumWords.RowUniqueness.QuadrupleGram

/-!
# Normalized traces of internal points, and the residue arithmetic that reads them

An internal point of the conic `Y^2 - XZ = 0` over `ZMod 13` is a projective point whose conic value
`pointDiscriminant` is a nonzero nonsquare.  Rescaling a coordinate triple multiplies that value by
the square of the factor, and any two nonsquares of `ZMod 13` differ by a square, so every internal
point has a coordinate representative whose conic value is the fixed nonsquare `11`, unique up to
sign.  Call such a representative a normalized lift.

Under the classical identification of a point off the conic with a trace-zero two-by-two matrix, the
conic value is the negated determinant, so normalized lifts are the matrices of determinant `2`, and
the trace of the product of two of them, divided by that common determinant, is

  `normalizedTrace u v = polarValue u v / 2`.

The sign of each lift is free, so a pair determines its normalized trace only up to sign and a
triple determines its three traces only up to the four sign patterns flipping an even number of
them.  Two quantities are insensitive to that: the square of a trace, which is the elliptic
parameter `polarInvariant` of the pair, and the product of the three traces of a triple, which is
the triple parameter `polarTripleInvariant`.

This module records the arithmetic that carries the coordinate statements of
`PassantCodeQ13.MinimumWords.RowUniqueness.PolarGram` into the residue arithmetic of
`PassantCodeQ13.MinimumWords.RowUniqueness.QuadrupleGram`, whose declarations quantify over natural
numbers below thirteen combined by explicit modular operations.  The dictionary is the cast
`ZMod 13`-ward: each modular operation on residues casts to the corresponding field operation, so
`QuadrupleGram.tripleGram` of the three trace residues of a triple is the residue of
`PolarGram.normalizedPolarGram`, and `QuadrupleGram.gramDet4` of the six trace residues of a
quadruple vanishes because the four-by-four matrix of polar values of four coordinate triples is
singular.  The discriminant law then reads in residues: the residue Gram determinant of a triple of
normalized lifts vanishes exactly on collinear triples, and is a nonsquare on all others.  Finally the passant-join criterion places each trace residue in
`QuadrupleGram.joinTraces`.

Every finite check here is an exhaustion over the elements of `ZMod 13` or a scalar identity among
residues, discharged by kernel reduction.  Nothing ranges over the points, lines, or minimum-weight
words of the plane.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.PlaneJoin
open PassantCodeQ13.SymmetricSquare

/-! ## Normalized lifts -/

/-- The conic value shared by all normalized lifts.  Any nonsquare would serve; this one makes the
corresponding trace-zero matrices those of determinant `2`. -/
def normalizedLiftDiscriminant : Field13 := 11

/-- Every nonzero nonsquare of `ZMod 13` becomes the chosen one after multiplication by a nonzero
square, because the nonsquares form a single coset of the squares. -/
private theorem exists_sq_mul_eq_normalizedLiftDiscriminant :
    ∀ value : Field13, value ≠ 0 → isNonzeroSquare value = false →
      ∃ factor : Field13, factor ≠ 0 ∧ factor ^ 2 * value = normalizedLiftDiscriminant := by
  decide +kernel

/-- Every internal point has a coordinate representative of the chosen conic value. -/
theorem exists_normalizedLift (point : InternalPoint) :
    ∃ factor : Field13, factor ≠ 0 ∧
      pointDiscriminant (scaleTriple factor point.1) = normalizedLiftDiscriminant := by
  have point_mem := (mem_internalCoordinates_iff point.1).mp point.2
  obtain ⟨factor, factor_nonzero, value⟩ :=
    exists_sq_mul_eq_normalizedLiftDiscriminant _ point_mem.2.1 point_mem.2.2
  exact ⟨factor, factor_nonzero, by rw [pointDiscriminant_scaleTriple, value]⟩

/-! ## Traces and the invariants of a triple -/

/-- The normalized trace of two coordinate triples: their polar value divided by the determinant `2`
common to normalized lifts. -/
def normalizedTrace (left right : Triple) : Field13 := polarValue left right * 7

/-- The elliptic parameter of two normalized lifts is the square of their normalized trace. -/
theorem polarInvariant_eq_normalizedTrace_sq {left right : Triple}
    (left_value : pointDiscriminant left = normalizedLiftDiscriminant)
    (right_value : pointDiscriminant right = normalizedLiftDiscriminant) :
    polarInvariant left right = normalizedTrace left right ^ 2 := by
  rw [polarInvariant, normalizedTrace, left_value, right_value, normalizedLiftDiscriminant,
    show ((11 : Field13) * 11)⁻¹ = 7 * 7 by decide +kernel]
  ring

/-- The normalized polar Gram of three normalized lifts, written in their three traces: it is `4`
minus the sum of the three squares minus the product. -/
theorem normalizedPolarGram_eq_trace_expression {first second third : Triple}
    (first_value : pointDiscriminant first = normalizedLiftDiscriminant)
    (second_value : pointDiscriminant second = normalizedLiftDiscriminant)
    (third_value : pointDiscriminant third = normalizedLiftDiscriminant) :
    normalizedPolarGram first second third
      = 4 - (normalizedTrace first second ^ 2 + normalizedTrace first third ^ 2
          + normalizedTrace second third ^ 2)
        - normalizedTrace first second * normalizedTrace first third
          * normalizedTrace second third := by
  have nondegenerate : normalizedLiftDiscriminant ≠ 0 := by decide
  rw [normalizedPolarGram_eq_four_sub_invariants (by rw [first_value]; exact nondegenerate)
      (by rw [second_value]; exact nondegenerate) (by rw [third_value]; exact nondegenerate),
    polarInvariant_eq_normalizedTrace_sq first_value second_value,
    polarInvariant_eq_normalizedTrace_sq first_value third_value,
    polarInvariant_eq_normalizedTrace_sq second_value third_value, polarTripleInvariant,
    first_value, second_value, third_value, normalizedTrace, normalizedTrace, normalizedTrace,
    normalizedLiftDiscriminant,
    show ((11 : Field13) * 11 * 11)⁻¹ = -(7 * 7 * 7) by decide +kernel]
  ring

/-! ## The residue dictionary

`QuadrupleGram` carries residues as natural numbers below thirteen and combines them by explicit
modular operations.  Each of those operations casts to the corresponding field operation. -/

theorem cast_add13 (first second : Nat) :
    ((add13 first second : Nat) : Field13) = (first : Field13) + (second : Field13) := by
  rw [add13, ZMod.natCast_mod, Nat.cast_add]

theorem cast_mul13 (first second : Nat) :
    ((mul13 first second : Nat) : Field13) = (first : Field13) * (second : Field13) := by
  rw [mul13, ZMod.natCast_mod, Nat.cast_mul]

theorem cast_sub13 (first second : Nat) :
    ((sub13 first second : Nat) : Field13) = (first : Field13) - (second : Field13) := by
  have bounded : second % 13 ≤ first + 13 := le_trans (le_of_lt (Nat.mod_lt _ (by norm_num)))
    (Nat.le_add_left 13 first)
  rw [sub13, ZMod.natCast_mod, Nat.cast_sub bounded, Nat.cast_add, ZMod.natCast_mod,
    ZMod.natCast_self, add_zero]

theorem cast_neg13 (value : Nat) : ((neg13 value : Nat) : Field13) = -(value : Field13) := by
  have bounded : value % 13 ≤ 13 := le_of_lt (Nat.mod_lt _ (by norm_num))
  rw [neg13, ZMod.natCast_mod, Nat.cast_sub bounded, ZMod.natCast_mod, ZMod.natCast_self,
    zero_sub]

/-- The residue Gram determinant of a triple casts to the field expression in the three traces. -/
theorem cast_tripleGram (first second third : Nat) :
    ((tripleGram first second third : Nat) : Field13)
      = 4 - ((first : Field13) ^ 2 + (second : Field13) ^ 2 + (third : Field13) ^ 2)
        - (first : Field13) * (second : Field13) * (third : Field13) := by
  have bounded : (first * first + second * second + third * third + first * second * third) % 13
      ≤ 30 := le_of_lt (lt_of_lt_of_le (Nat.mod_lt _ (by norm_num)) (by norm_num))
  rw [tripleGram, ZMod.natCast_mod, Nat.cast_sub bounded, ZMod.natCast_mod]
  push_cast
  rw [show (30 : Field13) = 4 by decide]
  ring

/-- The residue Gram determinant of a triple of normalized lifts is the residue of their normalized
polar Gram. -/
theorem tripleGram_eq_val_normalizedPolarGram {first second third : Triple}
    (first_value : pointDiscriminant first = normalizedLiftDiscriminant)
    (second_value : pointDiscriminant second = normalizedLiftDiscriminant)
    (third_value : pointDiscriminant third = normalizedLiftDiscriminant) :
    tripleGram (normalizedTrace first second).val (normalizedTrace first third).val
        (normalizedTrace second third).val
      = (normalizedPolarGram first second third).val := by
  have cast_equal : ((tripleGram (normalizedTrace first second).val
      (normalizedTrace first third).val (normalizedTrace second third).val : Nat) : Field13)
      = normalizedPolarGram first second third := by
    rw [cast_tripleGram, ZMod.natCast_val, ZMod.natCast_val, ZMod.natCast_val,
      ZMod.cast_id, ZMod.cast_id, ZMod.cast_id,
      normalizedPolarGram_eq_trace_expression first_value second_value third_value]
  have bounded : tripleGram (normalizedTrace first second).val (normalizedTrace first third).val
      (normalizedTrace second third).val < 13 := Nat.mod_lt _ (by norm_num)
  rw [← cast_equal, ZMod.val_cast_of_lt bounded]

/-- The residue Gram determinant of a quadruple casts to the symmetric determinant of the matrix
with diagonal two and the negated residues off the diagonal. -/
theorem cast_gramDet4 (firstSecond firstThird firstFourth secondThird secondFourth
    thirdFourth : Nat) :
    ((gramDet4 firstSecond firstThird firstFourth secondThird secondFourth thirdFourth
        : Nat) : Field13)
      = symmetricGramDeterminantFour 2 2 2 2 (-(firstSecond : Field13)) (-(firstThird : Field13))
          (-(firstFourth : Field13)) (-(secondThird : Field13)) (-(secondFourth : Field13))
          (-(thirdFourth : Field13)) := by
  simp only [gramDet4, minorDet, cast_add13, cast_mul13, cast_sub13, cast_neg13,
    symmetricGramDeterminantFour, minorDeterminant]
  push_cast
  ring

/-- A residue casts back to the field element it came from. -/
private theorem cast_val (value : Field13) : ((value.val : Nat) : Field13) = value := by
  simp

/-- The residue Gram determinant of a quadruple of normalized lifts vanishes, because the
four-by-four matrix of polar values of four coordinate triples is singular and the trace matrix is a
rescaling of it. -/
theorem gramDet4_eq_zero {first second third fourth : Triple}
    (first_value : pointDiscriminant first = normalizedLiftDiscriminant)
    (second_value : pointDiscriminant second = normalizedLiftDiscriminant)
    (third_value : pointDiscriminant third = normalizedLiftDiscriminant)
    (fourth_value : pointDiscriminant fourth = normalizedLiftDiscriminant) :
    gramDet4 (normalizedTrace first second).val (normalizedTrace first third).val
        (normalizedTrace first fourth).val (normalizedTrace second third).val
        (normalizedTrace second fourth).val (normalizedTrace third fourth).val
      = 0 := by
  have diagonal : ∀ point : Triple, pointDiscriminant point = normalizedLiftDiscriminant →
      (-7 : Field13) * polarValue point point = 2 := by
    intro point value
    have expand : polarValue point point = 2 * pointDiscriminant point := by
      simp only [polarValue, pointDiscriminant]
      ring
    rw [expand, value, normalizedLiftDiscriminant]
    decide +kernel
  have offDiagonal : ∀ left right : Triple,
      (-7 : Field13) * polarValue left right = -normalizedTrace left right := by
    intro left right
    simp only [normalizedTrace]
    ring
  have cast_equal : ((gramDet4 (normalizedTrace first second).val
      (normalizedTrace first third).val (normalizedTrace first fourth).val
      (normalizedTrace second third).val (normalizedTrace second fourth).val
      (normalizedTrace third fourth).val : Nat) : Field13) = 0 := by
    rw [cast_gramDet4, cast_val, cast_val, cast_val, cast_val, cast_val, cast_val]
    have rewritten : symmetricGramDeterminantFour 2 2 2 2
          (-normalizedTrace first second) (-normalizedTrace first third)
          (-normalizedTrace first fourth) (-normalizedTrace second third)
          (-normalizedTrace second fourth) (-normalizedTrace third fourth)
        = symmetricGramDeterminantFour (-7 * polarValue first first)
            (-7 * polarValue second second) (-7 * polarValue third third)
            (-7 * polarValue fourth fourth) (-7 * polarValue first second)
            (-7 * polarValue first third) (-7 * polarValue first fourth)
            (-7 * polarValue second third) (-7 * polarValue second fourth)
            (-7 * polarValue third fourth) := by
      rw [diagonal first first_value, diagonal second second_value, diagonal third third_value,
        diagonal fourth fourth_value, offDiagonal first second, offDiagonal first third,
        offDiagonal first fourth, offDiagonal second third, offDiagonal second fourth,
        offDiagonal third fourth]
    rw [rewritten, symmetricGramDeterminantFour_smul,
      ← polarGramDeterminantFour_eq_symmetric, polarGramDeterminantFour_eq_zero, mul_zero]
  have bounded : gramDet4 (normalizedTrace first second).val (normalizedTrace first third).val
      (normalizedTrace first fourth).val (normalizedTrace second third).val
      (normalizedTrace second fourth).val (normalizedTrace third fourth).val < 13 :=
    Nat.mod_lt _ (by norm_num)
  have injected := congrArg ZMod.val (cast_equal.trans (Nat.cast_zero (R := Field13)).symm)
  rwa [ZMod.val_cast_of_lt bounded, ZMod.val_cast_of_lt (by norm_num)] at injected

/-! ## The discriminant law in residues -/

/-- The chosen conic value of normalized lifts is a nonzero nonsquare. -/
private theorem normalizedLiftDiscriminant_nonsquare :
    normalizedLiftDiscriminant ≠ 0 ∧ isNonzeroSquare normalizedLiftDiscriminant = false := by
  decide +kernel

/-- The residue nonsquare test agrees with the field square test on the residue of a field
element. -/
theorem isNonsquare_val_iff (value : Field13) :
    isNonsquare value.val = true ↔ value ≠ 0 ∧ isNonzeroSquare value = false := by
  revert value
  decide +kernel

/-- The residue Gram determinant of a triple of normalized lifts vanishes exactly when the three
lifts are dependent, that is, when the three points are collinear. -/
theorem tripleGram_eq_zero_iff {first second third : Triple}
    (first_value : pointDiscriminant first = normalizedLiftDiscriminant)
    (second_value : pointDiscriminant second = normalizedLiftDiscriminant)
    (third_value : pointDiscriminant third = normalizedLiftDiscriminant) :
    tripleGram (normalizedTrace first second).val (normalizedTrace first third).val
        (normalizedTrace second third).val = 0
      ↔ coordinateDeterminant first second third = 0 := by
  obtain ⟨nondegenerate, _⟩ := normalizedLiftDiscriminant_nonsquare
  rw [tripleGram_eq_val_normalizedPolarGram first_value second_value third_value,
    ZMod.val_eq_zero]
  exact normalizedPolarGram_eq_zero_iff (by rw [first_value]; exact nondegenerate)
    (by rw [second_value]; exact nondegenerate) (by rw [third_value]; exact nondegenerate)

/-- **The discriminant law in residues.**  The residue Gram determinant of a triple of normalized
lifts in general position is a nonsquare. -/
theorem isNonsquare_tripleGram {first second third : Triple}
    (first_value : pointDiscriminant first = normalizedLiftDiscriminant)
    (second_value : pointDiscriminant second = normalizedLiftDiscriminant)
    (third_value : pointDiscriminant third = normalizedLiftDiscriminant)
    (independent : coordinateDeterminant first second third ≠ 0) :
    isNonsquare (tripleGram (normalizedTrace first second).val
      (normalizedTrace first third).val (normalizedTrace second third).val) = true := by
  obtain ⟨nondegenerate, nonsquare⟩ := normalizedLiftDiscriminant_nonsquare
  rw [tripleGram_eq_val_normalizedPolarGram first_value second_value third_value,
    isNonsquare_val_iff]
  refine ⟨fun vanishing => independent ?_, ?_⟩
  · exact (normalizedPolarGram_eq_zero_iff (by rw [first_value]; exact nondegenerate)
      (by rw [second_value]; exact nondegenerate)
      (by rw [third_value]; exact nondegenerate)).mp vanishing
  · exact isNonzeroSquare_normalizedPolarGram_eq_false
      (by rw [first_value]; exact nondegenerate) (by rw [first_value]; exact nonsquare)
      (by rw [second_value]; exact nondegenerate) (by rw [second_value]; exact nonsquare)
      (by rw [third_value]; exact nondegenerate) (by rw [third_value]; exact nonsquare)

/-! ## Placing a trace in the join list -/

/-- A field element whose square is one of the three passant elliptic parameters has residue in the
list of normalized traces available to a passant-joined pair. -/
private theorem val_mem_joinTraces_of_sq :
    ∀ value : Field13, value ^ 2 = 9 ∨ value ^ 2 = 10 ∨ value ^ 2 = 12 →
      value.val ∈ joinTraces := by
  decide +kernel

/-- The normalized trace of two distinct internal points joined by a passant has residue in
`joinTraces`. -/
theorem val_normalizedTrace_mem_joinTraces {first second : InternalPoint}
    {liftFirst liftSecond : Triple} {firstFactor secondFactor : Field13}
    (first_factor_nonzero : firstFactor ≠ 0) (second_factor_nonzero : secondFactor ≠ 0)
    (lift_first : liftFirst = scaleTriple firstFactor first.1)
    (lift_second : liftSecond = scaleTriple secondFactor second.1)
    (first_value : pointDiscriminant liftFirst = normalizedLiftDiscriminant)
    (second_value : pointDiscriminant liftSecond = normalizedLiftDiscriminant)
    (different : first ≠ second) (joined : HasPassantJoin first second) :
    (normalizedTrace liftFirst liftSecond).val ∈ joinTraces := by
  have parameter := polarInvariant_of_hasPassantJoin different joined
  have rescaled : polarInvariant liftFirst liftSecond = polarInvariant first.1 second.1 := by
    rw [lift_first, lift_second, polarInvariant, polarInvariant, polarValue_scaleTriple,
      pointDiscriminant_scaleTriple, pointDiscriminant_scaleTriple]
    rw [show (firstFactor * secondFactor * polarValue first.1 second.1) ^ 2
        = (firstFactor * secondFactor) ^ 2 * polarValue first.1 second.1 ^ 2 by ring,
      show firstFactor ^ 2 * pointDiscriminant first.1
          * (secondFactor ^ 2 * pointDiscriminant second.1)
        = (firstFactor * secondFactor) ^ 2
          * (pointDiscriminant first.1 * pointDiscriminant second.1) by ring]
    exact common_factor_cancel _ _ _
      (sq_ne_zero_field _ (mul_ne_zero_field _ _ first_factor_nonzero second_factor_nonzero))
  rw [← rescaled, polarInvariant_eq_normalizedTrace_sq first_value second_value] at parameter
  exact val_mem_joinTraces_of_sq _ parameter

end PassantCodeQ13.MinimumWords.RowUniqueness
