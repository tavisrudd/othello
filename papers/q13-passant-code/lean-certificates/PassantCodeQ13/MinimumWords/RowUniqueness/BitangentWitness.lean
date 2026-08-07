import PassantCodeQ13.MinimumWords.RowUniqueness.BitangentSupport
import PassantCodeQ13.MinimumWords.RowUniqueness.NormalizedTrace

/-!
# The bitangent conic named by a trace pattern

Three internal points of the standard conic `Y^2 - XZ = 0` over `ZMod 13`, lifted to coordinate
representatives of the fixed conic value `normalizedLiftDiscriminant`, carry three normalized traces
`a = B(u₁,u₂)`, `b = B(u₁,u₃)` and `c = B(u₂,u₃)`, where `B` is `normalizedTrace`, the polar form of
the conic scaled so that a normalized lift has `B(u,u) = -2`.  In that scaling the Gram matrix of the
three lifts is

  `M = ![![2, -a, -b], ![-a, 2, -c], ![-b, -c, 2]]`,

whose determinant is `2 D` with `D = 4 - (a² + b² + c²) - a b c`, the quantity `tripleDiscriminant`,
and whose adjugate row sums are the coefficients `poleCoefficient₁`, `poleCoefficient₂` and
`poleCoefficient₃`, summing to `cofactorSum`.

When `D` is nonzero the three lifts are a basis, and the linear form taking the same value at all
three is the polar dual of the vector `bitangentPole` obtained from them with those coefficients: the
adjugate identity gives `B(w, uᵢ) = -2 D` for each `i`, and hence `B(w,w) = -2 D · cofactorSum`.
Under the identification `polarDual` of a vector with a linear form, `lineValue (polarDual w) p` is
`B(w,p)` and `lineDiscriminant (polarDual w) = pointDiscriminant w`, so the chord and its dual-conic
value are both expressed in the traces alone.

Scaling the fixed conic value by the inverse square of `-2 D` then gives a field element `nu` for
which all three lifts lie on `C - nu L²`.  The three conditions that make that bitangent conic carry
a minimum-weight support — that `L` is a secant, that `nu` is a nonzero nonsquare, and that
`nu · lineDiscriminant L - 1` is a nonzero nonsquare — become conditions on `D` and on the chord
invariant `chordInvariant = cofactorSum / 4`, and they are exactly the two nonsquare conditions of
`QuadrupleGram.bitangentWitness`.

The module ends with the two statements the row-uniqueness assembly consumes: a trace pattern
satisfying `bitangentWitness` exhibits a member of the decoded minimum-word family containing all
three points, and consequently three internal points with no common member of that family satisfy
`QuadrupleGram.tripleAdmissible` at the traces of any normalized lifts.  Flipping the sign of one
lift flips the two traces at that point, which is why the four sign patterns of `signVariants` are
all tested: each is the trace pattern of the same three points under another admissible choice of
lifts.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.SymmetricSquare

private theorem thirteen_eq_zero : (13 : Field13) = 0 := by decide

/-! ## The polar dual of a vector -/

/-- The linear form `B(w, -)` of a coordinate triple, carried as a dual coordinate triple. -/
def polarDual (pole : Triple) : Triple := ⟨6 * pole.z, pole.y, 6 * pole.x⟩

/-- Evaluating the polar dual of a vector at a point is the normalized trace of the pair. -/
theorem lineValue_polarDual (pole point : Triple) :
    lineValue (polarDual pole) point = normalizedTrace pole point := by
  simp only [lineValue, polarDual, normalizedTrace, polarValue]
  linear_combination (pole.z * point.x - pole.y * point.y + pole.x * point.z) * thirteen_eq_zero

/-- The dual-conic value of the polar dual of a vector is the conic value of the vector. -/
theorem lineDiscriminant_polarDual (pole : Triple) :
    lineDiscriminant (polarDual pole) = pointDiscriminant pole := by
  simp only [lineDiscriminant, polarDual, pointDiscriminant]
  linear_combination (-11 * pole.x * pole.z) * thirteen_eq_zero

/-- Rescaling a point rescales the value of a linear form at it. -/
theorem lineValue_scalePoint (line : Triple) (factor : Field13) (point : Triple) :
    lineValue line (scaleTriple factor point) = factor * lineValue line point := by
  simp only [lineValue, scaleTriple]
  ring

/-- The normalized trace is symmetric. -/
theorem normalizedTrace_comm (left right : Triple) :
    normalizedTrace left right = normalizedTrace right left := by
  simp only [normalizedTrace, polarValue]
  ring

/-- The normalized trace of a point with itself is its conic value. -/
theorem normalizedTrace_self (point : Triple) :
    normalizedTrace point point = pointDiscriminant point := by
  simp only [normalizedTrace, polarValue, pointDiscriminant]
  linear_combination (point.y * point.y - point.x * point.z) * thirteen_eq_zero

/-- Rescaling one argument rescales the normalized trace. -/
theorem normalizedTrace_scaleTriple (factor : Field13) (left right : Triple) :
    normalizedTrace (scaleTriple factor left) right = factor * normalizedTrace left right := by
  simp only [normalizedTrace, polarValue, scaleTriple]
  ring

/-! ## The pole of the chord -/

/-- Linear combination of three coordinate triples. -/
def combineTriple (first second third : Field13) (left middle right : Triple) : Triple :=
  ⟨first * left.x + second * middle.x + third * right.x,
   first * left.y + second * middle.y + third * right.y,
   first * left.z + second * middle.z + third * right.z⟩

/-- The normalized trace is linear in its first argument. -/
theorem normalizedTrace_combineTriple (first second third : Field13)
    (left middle right point : Triple) :
    normalizedTrace (combineTriple first second third left middle right) point
      = first * normalizedTrace left point + second * normalizedTrace middle point
        + third * normalizedTrace right point := by
  simp only [normalizedTrace, polarValue, combineTriple]
  ring

/-- The conic value of a linear combination, read through the normalized trace. -/
theorem pointDiscriminant_combineTriple (first second third : Field13)
    (left middle right : Triple) :
    pointDiscriminant (combineTriple first second third left middle right)
      = first * normalizedTrace left (combineTriple first second third left middle right)
        + second * normalizedTrace middle (combineTriple first second third left middle right)
        + third * normalizedTrace right (combineTriple first second third left middle right) := by
  rw [← normalizedTrace_self]
  exact normalizedTrace_combineTriple first second third left middle right _

/-- The normalized Gram determinant of a triple of normalized lifts, in their three traces. -/
def tripleDiscriminant (first second third : Field13) : Field13 :=
  4 - (first ^ 2 + second ^ 2 + third ^ 2) - first * second * third

/-- Sum of the adjugate entries of the trace Gram matrix, in the three traces. -/
def cofactorSum (first second third : Field13) : Field13 :=
  12 - (first ^ 2 + second ^ 2 + third ^ 2) + 4 * (first + second + third)
    + 2 * (first * second + first * third + second * third)

/-- The chord invariant of a trace pattern: a quarter of `cofactorSum`. -/
def chordInvariant (first second third : Field13) : Field13 :=
  3 - 10 * (first ^ 2 + second ^ 2 + third ^ 2) + (first + second + third)
    + 7 * (first * second + first * third + second * third)

/-- The chord invariant is a quarter of the adjugate sum. -/
theorem cofactorSum_eq_four_mul_chordInvariant (first second third : Field13) :
    cofactorSum first second third = 4 * chordInvariant first second third := by
  simp only [cofactorSum, chordInvariant]
  linear_combination
    (3 * (first ^ 2 + second ^ 2 + third ^ 2)
      - 2 * (first * second + first * third + second * third)) * thirteen_eq_zero

/-- First adjugate row sum of the trace Gram matrix. -/
def poleCoefficient₁ (first second third : Field13) : Field13 :=
  4 - third ^ 2 + 2 * first + second * third + 2 * second + first * third

/-- Second adjugate row sum of the trace Gram matrix. -/
def poleCoefficient₂ (first second third : Field13) : Field13 :=
  4 - second ^ 2 + 2 * first + second * third + 2 * third + first * second

/-- Third adjugate row sum of the trace Gram matrix. -/
def poleCoefficient₃ (first second third : Field13) : Field13 :=
  4 - first ^ 2 + 2 * second + first * third + 2 * third + first * second

/-- The pole of the chord of the bitangent conic through three normalized lifts with the given trace
pattern: the vector whose normalized trace against each of the three lifts is the same. -/
def bitangentPole (first second third : Field13) (left middle right : Triple) : Triple :=
  combineTriple (poleCoefficient₁ first second third) (poleCoefficient₂ first second third)
    (poleCoefficient₃ first second third) left middle right

/-- The chosen conic value of a normalized lift, as a numeral of the trace scaling. -/
private theorem normalizedLiftDiscriminant_eq_neg_two :
    normalizedLiftDiscriminant = (-2 : Field13) := by decide

/-- The pole has the same normalized trace against each of the three lifts, namely `-2 D`.  This is
the adjugate identity for the trace Gram matrix. -/
theorem normalizedTrace_bitangentPole {a b c : Field13} {left middle right : Triple}
    (left_value : pointDiscriminant left = normalizedLiftDiscriminant)
    (middle_value : pointDiscriminant middle = normalizedLiftDiscriminant)
    (right_value : pointDiscriminant right = normalizedLiftDiscriminant)
    (trace_left_middle : normalizedTrace left middle = a)
    (trace_left_right : normalizedTrace left right = b)
    (trace_middle_right : normalizedTrace middle right = c) :
    normalizedTrace (bitangentPole a b c left middle right) left = -2 * tripleDiscriminant a b c ∧
      normalizedTrace (bitangentPole a b c left middle right) middle
        = -2 * tripleDiscriminant a b c ∧
      normalizedTrace (bitangentPole a b c left middle right) right
        = -2 * tripleDiscriminant a b c := by
  have left_self : normalizedTrace left left = -2 := by
    rw [normalizedTrace_self, left_value, normalizedLiftDiscriminant_eq_neg_two]
  have middle_self : normalizedTrace middle middle = -2 := by
    rw [normalizedTrace_self, middle_value, normalizedLiftDiscriminant_eq_neg_two]
  have right_self : normalizedTrace right right = -2 := by
    rw [normalizedTrace_self, right_value, normalizedLiftDiscriminant_eq_neg_two]
  have middle_left : normalizedTrace middle left = a := by
    rw [normalizedTrace_comm]; exact trace_left_middle
  have right_left : normalizedTrace right left = b := by
    rw [normalizedTrace_comm]; exact trace_left_right
  have right_middle : normalizedTrace right middle = c := by
    rw [normalizedTrace_comm]; exact trace_middle_right
  refine ⟨?_, ?_, ?_⟩
  · rw [bitangentPole, normalizedTrace_combineTriple, left_self, middle_left, right_left,
      poleCoefficient₁, poleCoefficient₂, poleCoefficient₃, tripleDiscriminant]
    ring
  · rw [bitangentPole, normalizedTrace_combineTriple, trace_left_middle, middle_self, right_middle,
      poleCoefficient₁, poleCoefficient₂, poleCoefficient₃, tripleDiscriminant]
    ring
  · rw [bitangentPole, normalizedTrace_combineTriple, trace_left_right, trace_middle_right,
      right_self, poleCoefficient₁, poleCoefficient₂, poleCoefficient₃, tripleDiscriminant]
    ring

/-- The conic value of the pole is `-2 D` times the adjugate sum. -/
theorem pointDiscriminant_bitangentPole {a b c : Field13} {left middle right : Triple}
    (left_value : pointDiscriminant left = normalizedLiftDiscriminant)
    (middle_value : pointDiscriminant middle = normalizedLiftDiscriminant)
    (right_value : pointDiscriminant right = normalizedLiftDiscriminant)
    (trace_left_middle : normalizedTrace left middle = a)
    (trace_left_right : normalizedTrace left right = b)
    (trace_middle_right : normalizedTrace middle right = c) :
    pointDiscriminant (bitangentPole a b c left middle right)
      = -2 * tripleDiscriminant a b c * cofactorSum a b c := by
  obtain ⟨value_left, value_middle, value_right⟩ :=
    normalizedTrace_bitangentPole left_value middle_value right_value trace_left_middle
      trace_left_right trace_middle_right
  have expand : pointDiscriminant (bitangentPole a b c left middle right)
      = poleCoefficient₁ a b c * normalizedTrace left (bitangentPole a b c left middle right)
        + poleCoefficient₂ a b c * normalizedTrace middle (bitangentPole a b c left middle right)
        + poleCoefficient₃ a b c * normalizedTrace right (bitangentPole a b c left middle right) :=
    pointDiscriminant_combineTriple _ _ _ left middle right
  rw [expand, normalizedTrace_comm left, normalizedTrace_comm middle, normalizedTrace_comm right,
    value_left, value_middle, value_right, poleCoefficient₁, poleCoefficient₂, poleCoefficient₃,
    cofactorSum]
  ring

/-! ## The nonsquare of the bitangent conic -/

/-- The scalar for which the three lifts lie on `C - nu L²`, in the Gram determinant of the
triple. -/
def bitangentScalar (gram : Field13) : Field13 := 11 * ((-2 * gram) ^ 2)⁻¹

/-- The lifts lie on the bitangent conic. -/
private theorem bitangentScalar_mul_sq :
    ∀ gram : Field13, gram ≠ 0 →
      normalizedLiftDiscriminant = bitangentScalar gram * (-2 * gram) ^ 2 := by
  decide +kernel

/-- The hypotheses of the witness conditions on the Gram determinant `D` of a triple and its chord
invariant `F`, collected as one executable test. -/
private def bitangentGuard (gram chord : Field13) : Bool :=
  (gram != 0) && (chord * gram != 0) && !isNonzeroSquare (chord * gram) &&
    ((4 * chord - gram) * gram != 0) && !isNonzeroSquare ((4 * chord - gram) * gram)

/-- The three conditions on the pair `(L, nu)` that `BitangentSupport` requires, read in the Gram
determinant `D` of the triple and its chord invariant `F`: the chord is a secant, the scalar is a
nonzero nonsquare, and no tangent of the bitangent conic is a passant. -/
private theorem bitangent_admissibility :
    ∀ gram chord : Field13, bitangentGuard gram chord = true →
      isNonzeroSquare (-2 * gram * (4 * chord)) = true ∧
        bitangentScalar gram ≠ 0 ∧ isNonzeroSquare (bitangentScalar gram) = false ∧
        bitangentScalar gram * (-2 * gram * (4 * chord)) - 1 ≠ 0 ∧
        isNonzeroSquare (bitangentScalar gram * (-2 * gram * (4 * chord)) - 1) = false := by
  decide +kernel

/-! ## From a trace pattern to a member of the minimum-word family -/

/-- Three normalized lifts whose trace pattern makes the chord a secant and leaves no tangent of the
bitangent conic a passant lie on a conic whose off-chord points are a member of the decoded
minimum-word family. -/
theorem exists_semanticMinimumSupport_of_traces {a b c : Field13} {left middle right : Triple}
    (left_value : pointDiscriminant left = normalizedLiftDiscriminant)
    (middle_value : pointDiscriminant middle = normalizedLiftDiscriminant)
    (right_value : pointDiscriminant right = normalizedLiftDiscriminant)
    (trace_left_middle : normalizedTrace left middle = a)
    (trace_left_right : normalizedTrace left right = b)
    (trace_middle_right : normalizedTrace middle right = c)
    (gram_nonzero : tripleDiscriminant a b c ≠ 0)
    (chord_nonzero : chordInvariant a b c * tripleDiscriminant a b c ≠ 0)
    (chord_nonsquare :
      isNonzeroSquare (chordInvariant a b c * tripleDiscriminant a b c) = false)
    (tangent_nonzero :
      (4 * chordInvariant a b c - tripleDiscriminant a b c) * tripleDiscriminant a b c ≠ 0)
    (tangent_nonsquare : isNonzeroSquare
      ((4 * chordInvariant a b c - tripleDiscriminant a b c) * tripleDiscriminant a b c) = false) :
    ∃ line : Triple, ∃ nu : Field13,
      isNonzeroSquare (lineDiscriminant line) = true ∧ nu ≠ 0 ∧
        isNonzeroSquare nu = false ∧ nu * lineDiscriminant line - 1 ≠ 0 ∧
        isNonzeroSquare (nu * lineDiscriminant line - 1) = false ∧
        pointDiscriminant left = nu * lineValue line left ^ 2 ∧
        pointDiscriminant middle = nu * lineValue line middle ^ 2 ∧
        pointDiscriminant right = nu * lineValue line right ^ 2 := by
  obtain ⟨value_left, value_middle, value_right⟩ :=
    normalizedTrace_bitangentPole left_value middle_value right_value trace_left_middle
      trace_left_right trace_middle_right
  have pole_value := pointDiscriminant_bitangentPole left_value middle_value right_value
    trace_left_middle trace_left_right trace_middle_right
  obtain ⟨secant, scalar_nonzero, scalar_nonsquare, tangent_value_nonzero, tangent_value⟩ :=
    bitangent_admissibility (tripleDiscriminant a b c) (chordInvariant a b c)
      (by
        rw [bitangentGuard, chord_nonsquare, tangent_nonsquare,
          show (tripleDiscriminant a b c != 0) = true from by simpa using gram_nonzero,
          show (chordInvariant a b c * tripleDiscriminant a b c != 0) = true from by
            simpa using chord_nonzero,
          show ((4 * chordInvariant a b c - tripleDiscriminant a b c)
              * tripleDiscriminant a b c != 0) = true from by simpa using tangent_nonzero]
        rfl)
  have discriminant : lineDiscriminant (polarDual (bitangentPole a b c left middle right))
      = -2 * tripleDiscriminant a b c * (4 * chordInvariant a b c) := by
    rw [lineDiscriminant_polarDual, pole_value, cofactorSum_eq_four_mul_chordInvariant]
  refine ⟨polarDual (bitangentPole a b c left middle right),
    bitangentScalar (tripleDiscriminant a b c), ?_, scalar_nonzero, scalar_nonsquare, ?_, ?_,
    ?_, ?_, ?_⟩
  · rw [discriminant]; exact secant
  · rw [discriminant]; exact tangent_value_nonzero
  · rw [discriminant]; exact tangent_value
  · rw [lineValue_polarDual, value_left, left_value]
    exact bitangentScalar_mul_sq _ gram_nonzero
  · rw [lineValue_polarDual, value_middle, middle_value]
    exact bitangentScalar_mul_sq _ gram_nonzero
  · rw [lineValue_polarDual, value_right, right_value]
    exact bitangentScalar_mul_sq _ gram_nonzero

/-! ## The residue dictionary for the witness -/

/-- Modular multiplication of residues is the residue of the field product. -/
theorem mul13_val (left right : Field13) : mul13 left.val right.val = (left * right).val := by
  have cast_eq : ((mul13 left.val right.val : Nat) : Field13) = left * right := by
    rw [cast_mul13, ZMod.natCast_val, ZMod.natCast_val, ZMod.cast_id, ZMod.cast_id]
  have bound : mul13 left.val right.val < 13 := Nat.mod_lt _ (by norm_num)
  rw [← cast_eq, ZMod.val_cast_of_lt bound]

/-- Modular subtraction of residues is the residue of the field difference. -/
theorem sub13_val (left right : Field13) : sub13 left.val right.val = (left - right).val := by
  have cast_eq : ((sub13 left.val right.val : Nat) : Field13) = left - right := by
    rw [cast_sub13, ZMod.natCast_val, ZMod.natCast_val, ZMod.cast_id, ZMod.cast_id]
  have bound : sub13 left.val right.val < 13 := Nat.mod_lt _ (by norm_num)
  rw [← cast_eq, ZMod.val_cast_of_lt bound]

/-- Negating a residue is the residue of the field negation. -/
theorem neg13_val (value : Field13) : neg13 value.val = (-value).val := by
  have cast_eq : ((neg13 value.val : Nat) : Field13) = -value := by
    rw [cast_neg13, ZMod.natCast_val, ZMod.cast_id]
  have bound : neg13 value.val < 13 := Nat.mod_lt _ (by norm_num)
  rw [← cast_eq, ZMod.val_cast_of_lt bound]

/-- The residue Gram determinant of a trace pattern is the residue of `tripleDiscriminant`. -/
theorem tripleGram_val (first second third : Field13) :
    tripleGram first.val second.val third.val = (tripleDiscriminant first second third).val := by
  have cast_eq : ((tripleGram first.val second.val third.val : Nat) : Field13)
      = tripleDiscriminant first second third := by
    rw [cast_tripleGram, ZMod.natCast_val, ZMod.natCast_val, ZMod.natCast_val, ZMod.cast_id,
      ZMod.cast_id, ZMod.cast_id, tripleDiscriminant]
  have bound : tripleGram first.val second.val third.val < 13 := Nat.mod_lt _ (by norm_num)
  rw [← cast_eq, ZMod.val_cast_of_lt bound]

/-- The residue chord discriminant of a trace pattern is the residue of `chordInvariant`. -/
theorem chordDiscriminant_val (first second third : Field13) :
    chordDiscriminant first.val second.val third.val
      = (chordInvariant first second third).val := by
  have cast_eq : ((chordDiscriminant first.val second.val third.val : Nat) : Field13)
      = chordInvariant first second third := by
    simp only [chordDiscriminant, cast_add13, cast_mul13, cast_sub13, ZMod.natCast_val,
      ZMod.cast_id]
    rw [chordInvariant, show ((3 : Nat) : Field13) = 3 by decide,
      show ((10 : Nat) : Field13) = 10 by decide, show ((7 : Nat) : Field13) = 7 by decide]
    ring
  have bound : chordDiscriminant first.val second.val third.val < 13 := by
    simp only [chordDiscriminant, add13]
    exact Nat.mod_lt _ (by norm_num)
  rw [← cast_eq, ZMod.val_cast_of_lt bound]

/-- The residue `4` multiplies as the field element `4`. -/
theorem mul13_four_val (value : Field13) : mul13 4 value.val = (4 * value).val := by
  have cast_eq : ((mul13 4 value.val : Nat) : Field13) = 4 * value := by
    rw [cast_mul13, ZMod.natCast_val, ZMod.cast_id, show ((4 : Nat) : Field13) = 4 by decide]
  have bound : mul13 4 value.val < 13 := Nat.mod_lt _ (by norm_num)
  rw [← cast_eq, ZMod.val_cast_of_lt bound]

/-! ## The witness fails on the traces of three points with no common support -/

/-- Cancelling a nonzero square factor. -/
private theorem sq_mul_left_cancel : ∀ factor left right : Field13, factor ≠ 0 →
    factor ^ 2 * left = factor ^ 2 * right → left = right := by
  decide +kernel

/-- Rescaling twice rescales by the product. -/
theorem scaleTriple_scaleTriple (outer inner : Field13) (point : Triple) :
    scaleTriple outer (scaleTriple inner point) = scaleTriple (outer * inner) point := by
  simp only [scaleTriple, mul_assoc]

/-- Rescaling the second argument rescales the normalized trace. -/
theorem normalizedTrace_scaleTriple_right (factor : Field13) (left right : Triple) :
    normalizedTrace left (scaleTriple factor right) = factor * normalizedTrace left right := by
  simp only [normalizedTrace, polarValue, scaleTriple]
  ring

/-- Negating a lift preserves its conic value. -/
theorem pointDiscriminant_neg_scaleTriple (point : Triple) :
    pointDiscriminant (scaleTriple (-1) point) = pointDiscriminant point := by
  rw [pointDiscriminant_scaleTriple]
  ring

/-- If the trace pattern of three normalized lifts satisfies `bitangentWitness`, some member of the
decoded minimum-word family contains all three points. -/
theorem exists_semanticMinimumSupport_of_bitangentWitness
    {first second third : InternalPoint} {left middle right : Triple}
    {leftFactor middleFactor rightFactor : Field13}
    (left_factor_nonzero : leftFactor ≠ 0) (middle_factor_nonzero : middleFactor ≠ 0)
    (right_factor_nonzero : rightFactor ≠ 0)
    (lift_left : left = scaleTriple leftFactor first.1)
    (lift_middle : middle = scaleTriple middleFactor second.1)
    (lift_right : right = scaleTriple rightFactor third.1)
    (left_value : pointDiscriminant left = normalizedLiftDiscriminant)
    (middle_value : pointDiscriminant middle = normalizedLiftDiscriminant)
    (right_value : pointDiscriminant right = normalizedLiftDiscriminant)
    (witness : bitangentWitness (normalizedTrace left middle).val
      (normalizedTrace left right).val (normalizedTrace middle right).val = true) :
    ∃ support ∈ semanticMinimumSupports,
      first ∈ support ∧ second ∈ support ∧ third ∈ support := by
  set a := normalizedTrace left middle with trace_left_middle
  set b := normalizedTrace left right with trace_left_right
  set c := normalizedTrace middle right with trace_middle_right
  have expand : bitangentWitness a.val b.val c.val
      = (!((tripleDiscriminant a b c).val == 0)
        && isNonsquare (chordInvariant a b c * tripleDiscriminant a b c).val
        && isNonsquare ((4 * chordInvariant a b c - tripleDiscriminant a b c)
            * tripleDiscriminant a b c).val) := by
    simp only [bitangentWitness, tripleGram_val, chordDiscriminant_val, mul13_four_val, sub13_val,
      mul13_val]
  rw [expand, Bool.and_eq_true, Bool.and_eq_true] at witness
  obtain ⟨⟨gram_bit, chord_bit⟩, tangent_bit⟩ := witness
  have gram_nonzero : tripleDiscriminant a b c ≠ 0 := by
    intro vanishing
    rw [vanishing] at gram_bit
    exact absurd gram_bit (by decide)
  obtain ⟨chord_nonzero, chord_nonsquare⟩ := (isNonsquare_val_iff _).mp chord_bit
  obtain ⟨tangent_nonzero, tangent_nonsquare⟩ := (isNonsquare_val_iff _).mp tangent_bit
  obtain ⟨line, nu, secant, nu_nonzero, nu_nonsquare, tangent_line_nonzero, tangent_line_nonsquare,
    on_left, on_middle, on_right⟩ :=
    exists_semanticMinimumSupport_of_traces left_value middle_value right_value
      trace_left_middle.symm trace_left_right.symm trace_middle_right.symm gram_nonzero
      chord_nonzero chord_nonsquare tangent_nonzero tangent_nonsquare
  obtain ⟨support, support_mem, contains⟩ :=
    exists_semanticMinimumSupport_of_bitangent secant nu_nonzero nu_nonsquare tangent_line_nonzero
      tangent_line_nonsquare
  have descend : ∀ {point : InternalPoint} {factor : Field13} {lift : Triple}, factor ≠ 0 →
      lift = scaleTriple factor point.1 →
      pointDiscriminant lift = nu * lineValue line lift ^ 2 →
      pointDiscriminant point.1 = nu * lineValue line point.1 ^ 2 := by
    intro point factor lift nonzero lift_eq on_conic
    rw [lift_eq, pointDiscriminant_scaleTriple, lineValue_scalePoint] at on_conic
    refine sq_mul_left_cancel factor _ _ nonzero ?_
    rw [on_conic]
    ring
  exact ⟨support, support_mem,
    contains first (descend left_factor_nonzero lift_left on_left),
    contains second (descend middle_factor_nonzero lift_middle on_middle),
    contains third (descend right_factor_nonzero lift_right on_right)⟩

/-- Three internal points lying in no common member of the decoded minimum-word family satisfy the
residue admissibility condition at the traces of any normalized lifts.  The four sign patterns
tested by `tripleAdmissible` are the trace patterns of the same three points under the four choices
of lift signs, so each is excluded by the same argument applied to negated lifts. -/
theorem tripleAdmissible_of_no_common_support
    {first second third : InternalPoint} {left middle right : Triple}
    {leftFactor middleFactor rightFactor : Field13}
    (left_factor_nonzero : leftFactor ≠ 0) (middle_factor_nonzero : middleFactor ≠ 0)
    (right_factor_nonzero : rightFactor ≠ 0)
    (lift_left : left = scaleTriple leftFactor first.1)
    (lift_middle : middle = scaleTriple middleFactor second.1)
    (lift_right : right = scaleTriple rightFactor third.1)
    (left_value : pointDiscriminant left = normalizedLiftDiscriminant)
    (middle_value : pointDiscriminant middle = normalizedLiftDiscriminant)
    (right_value : pointDiscriminant right = normalizedLiftDiscriminant)
    (no_common : ∀ support ∈ semanticMinimumSupports,
      ¬(first ∈ support ∧ second ∈ support ∧ third ∈ support)) :
    tripleAdmissible (normalizedTrace left middle).val (normalizedTrace left right).val
      (normalizedTrace middle right).val = true := by
  have negate_nonzero : ∀ factor : Field13, factor ≠ 0 → -1 * factor ≠ 0 := by
    intro factor nonzero vanishing
    exact nonzero (by linear_combination -vanishing)
  have fail : ∀ (leftLift middleLift rightLift : Triple)
      (leftScale middleScale rightScale : Field13), leftScale ≠ 0 → middleScale ≠ 0 →
      rightScale ≠ 0 → leftLift = scaleTriple leftScale first.1 →
      middleLift = scaleTriple middleScale second.1 →
      rightLift = scaleTriple rightScale third.1 →
      pointDiscriminant leftLift = normalizedLiftDiscriminant →
      pointDiscriminant middleLift = normalizedLiftDiscriminant →
      pointDiscriminant rightLift = normalizedLiftDiscriminant →
      bitangentWitness (normalizedTrace leftLift middleLift).val
        (normalizedTrace leftLift rightLift).val
        (normalizedTrace middleLift rightLift).val = false := by
    intro leftLift middleLift rightLift leftScale middleScale rightScale leftScale_nonzero
      middleScale_nonzero rightScale_nonzero liftLeft liftMiddle liftRight
      valueLeft valueMiddle valueRight
    by_contra holds
    obtain ⟨support, support_mem, contains⟩ :=
      exists_semanticMinimumSupport_of_bitangentWitness leftScale_nonzero middleScale_nonzero
        rightScale_nonzero liftLeft liftMiddle liftRight valueLeft valueMiddle valueRight
        (by simpa using holds)
    exact no_common support support_mem contains
  by_cases collinear : coordinateDeterminant left middle right = 0
  · have vanishing : (tripleGram (normalizedTrace left middle).val
        (normalizedTrace left right).val (normalizedTrace middle right).val == 0) = true := by
      simpa using (tripleGram_eq_zero_iff left_value middle_value right_value).mpr collinear
    rw [tripleAdmissible, vanishing]
    rfl
  have nonsquare := isNonsquare_tripleGram left_value middle_value right_value collinear
  have negate_left := fail (scaleTriple (-1) left) middle right (-1 * leftFactor) middleFactor
    rightFactor (negate_nonzero _ left_factor_nonzero) middle_factor_nonzero right_factor_nonzero
    (by rw [lift_left, scaleTriple_scaleTriple]) lift_middle lift_right
    (by rw [pointDiscriminant_neg_scaleTriple]; exact left_value) middle_value right_value
  have negate_middle := fail left (scaleTriple (-1) middle) right leftFactor (-1 * middleFactor)
    rightFactor left_factor_nonzero (negate_nonzero _ middle_factor_nonzero) right_factor_nonzero
    lift_left (by rw [lift_middle, scaleTriple_scaleTriple]) lift_right
    left_value (by rw [pointDiscriminant_neg_scaleTriple]; exact middle_value) right_value
  have negate_right := fail left middle (scaleTriple (-1) right) leftFactor middleFactor
    (-1 * rightFactor) left_factor_nonzero middle_factor_nonzero (negate_nonzero _
      right_factor_nonzero) lift_left lift_middle (by rw [lift_right, scaleTriple_scaleTriple])
    left_value middle_value (by rw [pointDiscriminant_neg_scaleTriple]; exact right_value)
  rw [normalizedTrace_scaleTriple, normalizedTrace_scaleTriple,
    show (-1 : Field13) * normalizedTrace left middle = -normalizedTrace left middle by ring,
    show (-1 : Field13) * normalizedTrace left right = -normalizedTrace left right by ring,
    ← neg13_val, ← neg13_val] at negate_left
  rw [normalizedTrace_scaleTriple_right, normalizedTrace_scaleTriple,
    show (-1 : Field13) * normalizedTrace left middle = -normalizedTrace left middle by ring,
    show (-1 : Field13) * normalizedTrace middle right = -normalizedTrace middle right by ring,
    ← neg13_val, ← neg13_val] at negate_middle
  rw [normalizedTrace_scaleTriple_right, normalizedTrace_scaleTriple_right,
    show (-1 : Field13) * normalizedTrace left right = -normalizedTrace left right by ring,
    show (-1 : Field13) * normalizedTrace middle right = -normalizedTrace middle right by ring,
    ← neg13_val, ← neg13_val] at negate_right
  have direct := fail left middle right leftFactor middleFactor rightFactor left_factor_nonzero
    middle_factor_nonzero right_factor_nonzero lift_left lift_middle lift_right
    left_value middle_value right_value
  have variants : ((signVariants (normalizedTrace left middle).val
        (normalizedTrace left right).val (normalizedTrace middle right).val).all
      fun pattern => !bitangentWitness pattern.1 pattern.2.1 pattern.2.2) = true := by
    rw [signVariants]
    simp only [List.all_cons, List.all_nil, Bool.and_true]
    rw [direct, negate_left, negate_middle, negate_right]
    rfl
  rw [tripleAdmissible, nonsquare, variants, Bool.and_self, Bool.or_true]

end PassantCodeQ13.MinimumWords.RowUniqueness
