import PassantCodeQ13.Equivariance.SupportInvariance
import PassantCodeQ13.MinimumWords.NormalizedIndexTable
import PassantCodeQ13.MinimumWords.RowUniqueness.PassantJoinInvariant

/-!
# Conics bitangent to the standard conic, and their off-chord points

Let `C` be the standard conic `Y^2 - XZ = 0` over `ZMod 13`, with conic value `pointDiscriminant`
and dual-conic value `lineDiscriminant`, and let `L` be a linear form, carried as a dual coordinate
triple evaluated by `lineValue`.  For a field element `nu` the conic

  `Gamma = C - nu L^2`,   the zero set of `pointDiscriminant p - nu * lineValue L p ^ 2`,

meets `C` exactly on the chord `lineValue L p = 0`, since `pointDiscriminant p = nu * lineValue L p ^ 2`
and `pointDiscriminant p = 0` force `lineValue L p = 0` whenever `nu` is nonzero.  When `L` is a
secant of `C` those common points are the two endpoints of the chord, and when `nu` is a nonsquare
every point of `Gamma` off the chord has conic value a nonsquare and is therefore internal.  This
module calls that off-chord set the *bitangent point set* of the pair `(L, nu)`.

The condition on `(L, nu)` recorded in `bitangentAdmissible` is that `L` is a secant, that `nu` is a
nonzero nonsquare, and that `nu * lineDiscriminant L - 1` is a nonzero nonsquare.  The last value is
the determinant of `Gamma` up to a nonzero square, so it says that no tangent line of `Gamma` is a
passant of `C`; since a line meets `Gamma` in at most two points and a passant of `C` misses the two
chord endpoints, an admissible pair therefore has its bitangent point set meeting every passant of
`C` in an even number of points.

What is proved here is the conclusion that use of the bitangent construction needs: the bitangent
point set of an admissible pair is one of the displayed minimum-weight supports of the passant code,
so it is a member of `semanticMinimumSupports`.  This is an exhaustive check over the `183`
normalized dual triples and the `13` field elements, discharged by kernel reduction; the guard
`bitangentAdmissible` selects the `273` pairs — the `91` secants against three of the six nonsquares
each — on which the encoded support is computed and looked up.

The construction is stated for an arbitrary, not necessarily normalized, dual triple `L`.  Rescaling
`L` by a nonzero factor and `nu` by the inverse square of that factor leaves the point set
unchanged, which is how the general statement reduces to the finite check over normalized
representatives.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

open RelativeConicArcs.PassantCodeQ13
open PassantCodeQ13.MinimumWords
open PassantCodeQ13.SymmetricSquare

/-! ## The point set of a bitangent conic -/

/-- The normalized representatives lying on `C - nu L^2` and off the chord `L`. -/
def bitangentPoints (line : Triple) (nu : Field13) : List Triple :=
  projectiveTripleList.filter fun point =>
    (pointDiscriminant point == nu * lineValue line point ^ 2) && (lineValue line point != 0)

/-- Membership in the bitangent point set, unfolded. -/
theorem mem_bitangentPoints_iff (line : Triple) (nu : Field13) (point : Triple) :
    point ∈ bitangentPoints line nu ↔
      point ∈ projectiveTripleList ∧
        pointDiscriminant point = nu * lineValue line point ^ 2 ∧ lineValue line point ≠ 0 := by
  rw [bitangentPoints, List.mem_filter]
  constructor
  · rintro ⟨mem, condition⟩
    have both := Bool.and_eq_true .. ▸ condition
    exact ⟨mem, by simpa using both.1, by simpa using both.2⟩
  · rintro ⟨mem, on_conic, off_chord⟩
    exact ⟨mem, by simp [on_conic, off_chord]⟩

/-- Off the chord, a point of `C - nu L^2` has the conic value of `nu` up to a nonzero square, so a
nonsquare `nu` makes every such point internal. -/
theorem mem_internalCoordinateList_of_mem_bitangentPoints {line : Triple} {nu : Field13}
    (nu_nonzero : nu ≠ 0) (nu_nonsquare : isNonzeroSquare nu = false)
    {point : Triple} (mem : point ∈ bitangentPoints line nu) :
    point ∈ internalCoordinateList := by
  obtain ⟨point_mem, on_conic, off_chord⟩ := (mem_bitangentPoints_iff line nu point).mp mem
  refine (mem_internalCoordinateList_iff point).mpr ⟨point_mem, ?_, ?_⟩
  · rw [on_conic]
    exact mul_ne_zero_field _ _ nu_nonzero (sq_ne_zero_field _ off_chord)
  · rw [on_conic, mul_comm, isNonzeroSquare_sq_mul _ _ off_chord]
    exact nu_nonsquare

/-- The bitangent point set of a pair, encoded as a 78-bit support through the packed index
table. -/
def bitangentSupportCode (line : Triple) (nu : Field13) : Nat :=
  tabulatedEncodeSupport (bitangentPoints line nu)

/-- The pairs `(L, nu)` whose bitangent conic carries a minimum-weight support: `L` is a secant of
the standard conic, `nu` is a nonzero nonsquare, and `nu * lineDiscriminant L - 1` — the determinant
of the bitangent conic up to a nonzero square — is a nonzero nonsquare, which says that no tangent
of the bitangent conic is a passant. -/
def bitangentAdmissible (line : Triple) (nu : Field13) : Bool :=
  isNonzeroSquare (lineDiscriminant line) && (nu != 0) && !isNonzeroSquare nu &&
    (nu * lineDiscriminant line - 1 != 0) && !isNonzeroSquare (nu * lineDiscriminant line - 1)

/-! ## Rescaling the pair -/

/-- The inverse of a square is the square of the inverse. -/
private theorem inv_sq_field : ∀ value : Field13, (value ^ 2)⁻¹ = value⁻¹ ^ 2 := by
  decide +kernel

/-- Rescaling a dual triple rescales its evaluation at a point. -/
theorem lineValue_scaleTriple (factor : Field13) (line point : Triple) :
    lineValue (scaleTriple factor line) point = factor * lineValue line point := by
  simp only [lineValue, scaleTriple]
  ring

/-- The bitangent point set depends only on the pair `(L, nu)` up to the rescaling
`(L, nu) ↦ (s L, s⁻² nu)`, under which the defining equation is unchanged. -/
theorem bitangentPoints_scaleTriple {factor : Field13} (nonzero : factor ≠ 0)
    (line : Triple) (nu : Field13) :
    bitangentPoints (scaleTriple factor line) ((factor ^ 2)⁻¹ * nu) = bitangentPoints line nu := by
  have cancel : ∀ point : Triple, (factor ^ 2)⁻¹ * nu * (factor * lineValue line point) ^ 2
      = nu * lineValue line point ^ 2 := by
    intro point
    rw [show (factor ^ 2)⁻¹ * nu * (factor * lineValue line point) ^ 2
        = (factor ^ 2)⁻¹ * factor ^ 2 * (nu * lineValue line point ^ 2) by ring,
      mul_comm ((factor ^ 2)⁻¹) (factor ^ 2),
      mul_inv_cancel_field _ (sq_ne_zero_field _ nonzero), one_mul]
  have chord : ∀ point : Triple,
      (factor * lineValue line point != 0) = (lineValue line point != 0) := by
    intro point
    by_cases vanishing : lineValue line point = 0
    · rw [vanishing, mul_zero]
    · rw [show (factor * lineValue line point != 0) = true from by
        simpa using mul_ne_zero_field _ _ nonzero vanishing,
        show (lineValue line point != 0) = true from by simpa using vanishing]
  have predicate :
      (fun point : Triple => (pointDiscriminant point ==
            (factor ^ 2)⁻¹ * nu * lineValue (scaleTriple factor line) point ^ 2)
          && (lineValue (scaleTriple factor line) point != 0))
        = fun point : Triple => (pointDiscriminant point == nu * lineValue line point ^ 2)
          && (lineValue line point != 0) := by
    funext point
    rw [lineValue_scaleTriple, cancel point, chord point]
  rw [bitangentPoints, bitangentPoints, predicate]

/-- Admissibility is likewise invariant under the rescaling of the pair. -/
theorem bitangentAdmissible_scaleTriple {factor : Field13} (nonzero : factor ≠ 0)
    (line : Triple) (nu : Field13) :
    bitangentAdmissible (scaleTriple factor line) ((factor ^ 2)⁻¹ * nu)
      = bitangentAdmissible line nu := by
  have inverse_nonzero : factor⁻¹ ≠ 0 := inv_ne_zero_field _ nonzero
  have square : (factor ^ 2)⁻¹ = factor⁻¹ ^ 2 := inv_sq_field factor
  have discriminant : lineDiscriminant (scaleTriple factor line)
      = factor ^ 2 * lineDiscriminant line := lineDiscriminant_scaleTriple factor line
  have product : (factor ^ 2)⁻¹ * nu * lineDiscriminant (scaleTriple factor line)
      = nu * lineDiscriminant line := by
    rw [discriminant,
      show (factor ^ 2)⁻¹ * nu * (factor ^ 2 * lineDiscriminant line)
        = (factor ^ 2)⁻¹ * factor ^ 2 * (nu * lineDiscriminant line) by ring,
      mul_comm ((factor ^ 2)⁻¹) (factor ^ 2),
      mul_inv_cancel_field _ (sq_ne_zero_field _ nonzero), one_mul]
  have scalar : ((factor ^ 2)⁻¹ * nu != 0) = (nu != 0) := by
    by_cases vanishing : nu = 0
    · rw [vanishing, mul_zero]
    · rw [show ((factor ^ 2)⁻¹ * nu != 0) = true from by
        simpa using mul_ne_zero_field _ _
          (inv_ne_zero_field _ (sq_ne_zero_field _ nonzero)) vanishing,
        show (nu != 0) = true from by simpa using vanishing]
  rw [bitangentAdmissible, bitangentAdmissible, product, scalar, discriminant,
    isNonzeroSquare_sq_mul _ _ nonzero, square, isNonzeroSquare_sq_mul _ _ inverse_nonzero]

/-! ## The finite check -/

/-- Every admissible pair of a normalized dual triple and a field element encodes one of the
displayed minimum-weight supports.  Exhaustive over the `183` normalized dual triples and the `13`
field elements, discharged by kernel reduction. -/
theorem bitangentSupportCode_check :
    projectiveTripleList.all (fun line =>
      fieldElements.all fun nu =>
        !bitangentAdmissible line nu ||
          minimumWordSupports.contains (bitangentSupportCode line nu)) = true := by
  decide +kernel

/-- The encoded bitangent support of an admissible pair of a normalized dual triple and a field
element is a displayed minimum-weight support. -/
theorem bitangentSupportCode_mem_minimumWordSupports {line : Triple} {nu : Field13}
    (line_mem : line ∈ projectiveTripleList) (admissible : bitangentAdmissible line nu = true) :
    bitangentSupportCode line nu ∈ minimumWordSupports := by
  have at_line := List.all_eq_true.mp bitangentSupportCode_check line line_mem
  have at_pair := List.all_eq_true.mp at_line nu (mem_fieldElements nu)
  rw [admissible] at at_pair
  simpa using at_pair

/-! ## The semantic statement -/

/-- The off-chord points of an admissible bitangent conic form a member of the decoded minimum-word
family, and every internal point on that conic belongs to it. -/
theorem exists_semanticMinimumSupport_of_bitangent {line : Triple} {nu : Field13}
    (line_secant : isNonzeroSquare (lineDiscriminant line) = true)
    (nu_nonzero : nu ≠ 0) (nu_nonsquare : isNonzeroSquare nu = false)
    (tangent_nonzero : nu * lineDiscriminant line - 1 ≠ 0)
    (tangent_nonsquare : isNonzeroSquare (nu * lineDiscriminant line - 1) = false) :
    ∃ support ∈ semanticMinimumSupports, ∀ point : InternalPoint,
      pointDiscriminant point.1 = nu * lineValue line point.1 ^ 2 → point ∈ support := by
  have discriminant_nonzero : lineDiscriminant line ≠ 0 := by
    intro vanishing
    rw [vanishing] at line_secant
    exact absurd line_secant (by decide)
  have line_nonzero : line ≠ ⟨0, 0, 0⟩ := by
    intro degenerate
    apply discriminant_nonzero
    rw [degenerate]
    simp [lineDiscriminant]
  obtain ⟨factor, factor_nonzero, normalized⟩ := normalizeTriple_eq_scaleTriple line_nonzero
  have admissible : bitangentAdmissible line nu = true := by
    rw [bitangentAdmissible, line_secant, nu_nonsquare, tangent_nonsquare,
      show (nu != 0) = true from by simpa using nu_nonzero,
      show (nu * lineDiscriminant line - 1 != 0) = true from by simpa using tangent_nonzero]
    rfl
  have rescaled_admissible :
      bitangentAdmissible (normalizeTriple line) ((factor ^ 2)⁻¹ * nu) = true := by
    rw [normalized, bitangentAdmissible_scaleTriple factor_nonzero]
    exact admissible
  have rescaled_points :
      bitangentPoints (normalizeTriple line) ((factor ^ 2)⁻¹ * nu) = bitangentPoints line nu := by
    rw [normalized]
    exact bitangentPoints_scaleTriple factor_nonzero line nu
  have code_mem : bitangentSupportCode (normalizeTriple line) ((factor ^ 2)⁻¹ * nu)
      ∈ minimumWordSupports :=
    bitangentSupportCode_mem_minimumWordSupports
      (normalizeTriple_mem_projectiveTripleList line) rescaled_admissible
  have internal : ∀ point ∈ bitangentPoints line nu, point ∈ internalCoordinateList :=
    fun _ mem => mem_internalCoordinateList_of_mem_bitangentPoints nu_nonzero nu_nonsquare mem
  have code_eq : bitangentSupportCode (normalizeTriple line) ((factor ^ 2)⁻¹ * nu)
      = encodeSupport (bitangentPoints line nu) := by
    rw [bitangentSupportCode, rescaled_points]
    exact tabulatedEncodeSupport_eq_encodeSupport _
      (fun point mem => ((mem_internalCoordinateList_iff point).mp (internal point mem)).1)
  refine ⟨decodedSupport (encodeSupport (bitangentPoints line nu)), ?_, ?_⟩
  · refine Finset.mem_image.mpr ⟨encodeSupport (bitangentPoints line nu), ?_, rfl⟩
    rw [List.mem_toFinset, minimumSupportCodes_eq]
    exact code_eq ▸ code_mem
  · intro point on_conic
    refine (PassantCodeQ13.Equivariance.mem_decodedSupport_encodeSupport internal point).mpr ?_
    have point_internal : point.1 ∈ internalCoordinateList :=
      List.mem_toFinset.mp (by rw [internalCoordinateList_toFinset]; exact point.2)
    have unfolded := (mem_internalCoordinateList_iff point.1).mp point_internal
    have chord : lineValue line point.1 ≠ 0 := by
      intro vanishing
      have value : pointDiscriminant point.1 = 0 := by rw [on_conic, vanishing]; ring
      exact unfolded.2.1 value
    exact (mem_bitangentPoints_iff line nu point.1).mpr ⟨unfolded.1, on_conic, chord⟩

end PassantCodeQ13.MinimumWords.RowUniqueness
