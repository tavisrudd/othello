import PassantCodeQ13.SymmetricSquareInvariance

/-!
# Joins and meets in the normalized projective plane over `ZMod 13`

Homogeneous coordinate triples are paired by the symmetric bilinear form
`⟨line, point⟩ = line.x * point.x + line.y * point.y + line.z * point.z`, and the join of two
triples is their cross product.  Because the form is symmetric, one development serves both the
join of two points and the meet of two lines.

The results here are symbolic.  Three polynomial identities over the coefficient ring do the work:
the join is orthogonal to each of its factors, the join of a triple with a join expands as
`⟨line, second⟩ • first - ⟨line, first⟩ • second`, and a vanishing join forces one triple to be a
scalar multiple of the other whenever that other is nonzero.  Together with the normalization
dictionary of `PassantCodeQ13.SymmetricSquare` — normalization rescales, and two normalized
representatives differing by a nonzero scalar coincide — they give existence and uniqueness of the
normalized triple incident to two distinct normalized triples.

Only two finite checks appear, both over the 183 normalized representatives and both discharged by
kernel reduction: that no representative is the zero triple, and, inside the normalization
dictionary this module reuses, that rescaling a representative does not change its normalization.
-/

namespace PassantCodeQ13.PlaneJoin

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.SymmetricSquare

/-- Coordinate triples agreeing in all three coordinates are equal. -/
private theorem triple_ext {first second : Triple} (equalX : first.x = second.x)
    (equalY : first.y = second.y) (equalZ : first.z = second.z) : first = second := by
  obtain ⟨firstX, firstY, firstZ⟩ := first
  obtain ⟨secondX, secondY, secondZ⟩ := second
  simp_all

/-- The symmetric bilinear pairing of two homogeneous coordinate triples. -/
def dotTriple (line point : Triple) : Field13 :=
  line.x * point.x + line.y * point.y + line.z * point.z

/-- The join of two homogeneous coordinate triples, their cross product. -/
def joinTriple (first second : Triple) : Triple :=
  ⟨first.y * second.z - first.z * second.y,
    first.z * second.x - first.x * second.z,
    first.x * second.y - first.y * second.x⟩

/-- The pairing is symmetric, so a statement about joins of points is the same statement about
meets of lines. -/
theorem dotTriple_comm (line point : Triple) : dotTriple line point = dotTriple point line := by
  simp only [dotTriple]
  ring

/-- The join of two triples is orthogonal to the first of them. -/
theorem dotTriple_joinTriple_left (first second : Triple) :
    dotTriple (joinTriple first second) first = 0 := by
  simp only [dotTriple, joinTriple]
  ring

/-- The join of two triples is orthogonal to the second of them. -/
theorem dotTriple_joinTriple_right (first second : Triple) :
    dotTriple (joinTriple first second) second = 0 := by
  simp only [dotTriple, joinTriple]
  ring

/-- A triple orthogonal to two others has vanishing join with their join. -/
theorem joinTriple_join_eq_zero {line first second : Triple}
    (onFirst : dotTriple line first = 0) (onSecond : dotTriple line second = 0) :
    joinTriple line (joinTriple first second) = ⟨0, 0, 0⟩ := by
  have expandX : (joinTriple line (joinTriple first second)).x
      = dotTriple line second * first.x - dotTriple line first * second.x := by
    simp only [dotTriple, joinTriple]
    ring
  have expandY : (joinTriple line (joinTriple first second)).y
      = dotTriple line second * first.y - dotTriple line first * second.y := by
    simp only [dotTriple, joinTriple]
    ring
  have expandZ : (joinTriple line (joinTriple first second)).z
      = dotTriple line second * first.z - dotTriple line first * second.z := by
    simp only [dotTriple, joinTriple]
    ring
  refine triple_ext ?_ ?_ ?_ <;>
    simp [expandX, expandY, expandZ, onFirst, onSecond]

/-- A vanishing join makes the second triple a scalar multiple of the first, provided the first is
nonzero. -/
theorem exists_scaleTriple_of_joinTriple_eq_zero {first second : Triple}
    (nonzero : first ≠ ⟨0, 0, 0⟩)
    (degenerate : joinTriple first second = ⟨0, 0, 0⟩) :
    ∃ factor : Field13, second = scaleTriple factor first := by
  have relationX : first.y * second.z - first.z * second.y = 0 :=
    congrArg Triple.x degenerate
  have relationY : first.z * second.x - first.x * second.z = 0 :=
    congrArg Triple.y degenerate
  have relationZ : first.x * second.y - first.y * second.x = 0 :=
    congrArg Triple.z degenerate
  by_cases firstX : first.x = 0
  · by_cases firstY : first.y = 0
    · have firstZ : first.z ≠ 0 := by
        intro zero
        exact nonzero (triple_ext firstX firstY zero)
      refine ⟨second.z * first.z⁻¹, triple_ext ?_ ?_ ?_⟩
      · have : first.z * second.x = 0 := by
          have := relationY
          rw [firstX] at this
          linear_combination this
        have vanishes : second.x = 0 := by
          by_contra nonvanishing
          exact mul_ne_zero_field first.z second.x firstZ nonvanishing this
        simp [scaleTriple, firstX, vanishes]
      · have : first.z * second.y = 0 := by
          have := relationX
          rw [firstY] at this
          linear_combination -this
        have vanishes : second.y = 0 := by
          by_contra nonvanishing
          exact mul_ne_zero_field first.z second.y firstZ nonvanishing this
        simp [scaleTriple, firstY, vanishes]
      · show second.z = second.z * first.z⁻¹ * first.z
        rw [mul_assoc, mul_comm first.z⁻¹ first.z, mul_inv_cancel_field first.z firstZ, mul_one]
    · refine ⟨second.y * first.y⁻¹, triple_ext ?_ ?_ ?_⟩
      · have : first.y * second.x = 0 := by
          have := relationZ
          rw [firstX] at this
          linear_combination -this
        have vanishes : second.x = 0 := by
          by_contra nonvanishing
          exact mul_ne_zero_field first.y second.x firstY nonvanishing this
        simp [scaleTriple, firstX, vanishes]
      · show second.y = second.y * first.y⁻¹ * first.y
        rw [mul_assoc, mul_comm first.y⁻¹ first.y, mul_inv_cancel_field first.y firstY, mul_one]
      · show second.z = second.y * first.y⁻¹ * first.z
        have : first.y * second.z = first.z * second.y := by linear_combination relationX
        calc second.z = first.y⁻¹ * (first.y * second.z) := by
              rw [← mul_assoc, mul_comm first.y⁻¹ first.y,
                mul_inv_cancel_field first.y firstY, one_mul]
          _ = first.y⁻¹ * (first.z * second.y) := by rw [this]
          _ = second.y * first.y⁻¹ * first.z := by ring
  · refine ⟨second.x * first.x⁻¹, triple_ext ?_ ?_ ?_⟩
    · show second.x = second.x * first.x⁻¹ * first.x
      rw [mul_assoc, mul_comm first.x⁻¹ first.x, mul_inv_cancel_field first.x firstX, mul_one]
    · show second.y = second.x * first.x⁻¹ * first.y
      have : first.x * second.y = first.y * second.x := by linear_combination relationZ
      calc second.y = first.x⁻¹ * (first.x * second.y) := by
            rw [← mul_assoc, mul_comm first.x⁻¹ first.x,
              mul_inv_cancel_field first.x firstX, one_mul]
        _ = first.x⁻¹ * (first.y * second.x) := by rw [this]
        _ = second.x * first.x⁻¹ * first.y := by ring
    · show second.z = second.x * first.x⁻¹ * first.z
      have : first.x * second.z = first.z * second.x := by linear_combination -relationY
      calc second.z = first.x⁻¹ * (first.x * second.z) := by
            rw [← mul_assoc, mul_comm first.x⁻¹ first.x,
              mul_inv_cancel_field first.x firstX, one_mul]
        _ = first.x⁻¹ * (first.z * second.x) := by rw [this]
        _ = second.x * first.x⁻¹ * first.z := by ring

/-- No normalized representative is the zero triple. -/
theorem ne_zero_of_mem_projectiveTripleList {point : Triple}
    (mem : point ∈ projectiveTripleList) : point ≠ ⟨0, 0, 0⟩ := by
  have checked : projectiveTripleList.all (fun entry => entry != ⟨0, 0, 0⟩) = true := by
    decide +kernel
  exact ne_of_apply_ne id (by simpa using List.all_eq_true.mp checked point mem)

/-- Normalization lands in the displayed representatives, for every triple: a triple whose first
two coordinates vanish, the zero triple included, normalizes to the vertical representative. -/
theorem normalizeTriple_mem_projectiveTripleList (point : Triple) :
    MinimumWords.normalizeTriple point ∈ projectiveTripleList := by
  by_cases firstZero : point.x = 0
  · have condX : (point.x != 0) = false := by simp [firstZero]
    by_cases secondZero : point.y = 0
    · have condY : (point.y != 0) = false := by simp [secondZero]
      have shape : MinimumWords.normalizeTriple point = verticalTriple := by
        simp [MinimumWords.normalizeTriple, condX, condY]
      rw [shape]
      exact List.mem_append_right _ (by simp)
    · have condY : (point.y != 0) = true := by simp [secondZero]
      have shape : MinimumWords.normalizeTriple point
          = infiniteTriple (point.z * point.y⁻¹) := by
        simp [MinimumWords.normalizeTriple, condX, condY, infiniteTriple]
      rw [shape]
      exact List.mem_append_left _ (List.mem_append_right _
        (List.mem_map.mpr ⟨_, mem_fieldElements _, rfl⟩))
  · have condX : (point.x != 0) = true := by simp [firstZero]
    have shape : MinimumWords.normalizeTriple point
        = affineTriple (point.y * point.x⁻¹) (point.z * point.x⁻¹) := by
      simp [MinimumWords.normalizeTriple, condX, affineTriple]
    rw [shape]
    exact List.mem_append_left _ (List.mem_append_left _
      (List.mem_flatMap.mpr ⟨_, mem_fieldElements _,
        List.mem_map.mpr ⟨_, mem_fieldElements _, rfl⟩⟩))

/-- Two distinct normalized representatives have a nonzero join. -/
theorem joinTriple_ne_zero {first second : Triple}
    (firstMem : first ∈ projectiveTripleList) (secondMem : second ∈ projectiveTripleList)
    (different : first ≠ second) : joinTriple first second ≠ ⟨0, 0, 0⟩ := by
  intro degenerate
  obtain ⟨factor, rescaled⟩ :=
    exists_scaleTriple_of_joinTriple_eq_zero (ne_zero_of_mem_projectiveTripleList firstMem)
      degenerate
  have factorNonzero : factor ≠ 0 := by
    intro zero
    apply ne_zero_of_mem_projectiveTripleList secondMem
    rw [rescaled, zero]
    simp [scaleTriple]
  exact different (eq_of_scaleTriple_mem factorNonzero firstMem secondMem rescaled).symm

/-- Two distinct normalized representatives are incident to exactly one normalized representative.
Read with triples as points this is the unique join of two points; read with triples as lines, which
the symmetry of the pairing permits, it is the unique meet of two lines. -/
theorem existsUnique_incident {first second : Triple}
    (firstMem : first ∈ projectiveTripleList) (secondMem : second ∈ projectiveTripleList)
    (different : first ≠ second) :
    ∃! line : Triple, line ∈ projectiveTripleList ∧
      dotTriple line first = 0 ∧ dotTriple line second = 0 := by
  have joinNonzero := joinTriple_ne_zero firstMem secondMem different
  obtain ⟨factor, factorNonzero, rescaled⟩ := normalizeTriple_eq_scaleTriple joinNonzero
  refine ⟨MinimumWords.normalizeTriple (joinTriple first second),
    ⟨normalizeTriple_mem_projectiveTripleList _, ?_, ?_⟩, ?_⟩
  · rw [rescaled]
    have : dotTriple (scaleTriple factor (joinTriple first second)) first
        = factor * dotTriple (joinTriple first second) first := by
      simp only [dotTriple, scaleTriple]
      ring
    rw [this, dotTriple_joinTriple_left, mul_zero]
  · rw [rescaled]
    have : dotTriple (scaleTriple factor (joinTriple first second)) second
        = factor * dotTriple (joinTriple first second) second := by
      simp only [dotTriple, scaleTriple]
      ring
    rw [this, dotTriple_joinTriple_right, mul_zero]
  · rintro line ⟨lineMem, onFirst, onSecond⟩
    have degenerate := joinTriple_join_eq_zero onFirst onSecond
    obtain ⟨scale, proportional⟩ :=
      exists_scaleTriple_of_joinTriple_eq_zero (ne_zero_of_mem_projectiveTripleList lineMem)
        degenerate
    have scaleNonzero : scale ≠ 0 := by
      intro zero
      apply joinNonzero
      rw [proportional, zero]
      simp [scaleTriple]
    have normalized : MinimumWords.normalizeTriple (scaleTriple scale line) = line := by
      have step := List.all_eq_true.mp normalizeTriple_scaleTriple_on_projectiveTripleList line
        lineMem
      have instanceAt := List.all_eq_true.mp step scale (mem_fieldElements scale)
      rcases Bool.or_eq_true .. ▸ instanceAt with zeroCase | equalCase
      · exact absurd (by simpa using zeroCase) scaleNonzero
      · simpa using equalCase
    rw [proportional, normalized]

end PassantCodeQ13.PlaneJoin
