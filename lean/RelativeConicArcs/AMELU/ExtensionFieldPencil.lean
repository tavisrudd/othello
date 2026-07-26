import RelativeConicArcs.AMELU.PencilClassification

/-!
# Frobenius sectors of the admitted six-arc pencil

Let `σ` be an automorphism of an odd field and let `t` be a parameter of the
ordered six-arc pencil.  Two scalar divisors control the `σ`-semilinear
fixed-party intertwiner sector:

* `(σ(t)-t)(1-σ(t)t)` controls diagonal coefficients;
* `((1-σ(t))(1-t))²+σ(t)t` controls off-diagonal coefficients, which exchange
  a code with its Gale dual.

The untwisted off-diagonal divisor is the conic, or GRS, quartic.  The module
proves both divisor identities and the explicit six-coordinate Gale
multiplier by ring algebra.  It also packages the extension-field orbit
argument: once a local-Clifford relation supplies one projective Frobenius
sector, and conversely a Galois match of the scalar invariant supplies a
local Clifford, the orbits are exactly the Galois orbits of `pencilZ`.

The divisor theorems and field-automorphism identities are unconditional and
kernel checked.  The final orbit theorem is conditional on the two named
sector-to-Clifford bridges; it does not postulate a hidden reconstruction of
a Desarguesian spread.
-/

namespace RelativeConicArcs.AMELU

open scoped BigOperators

variable {𝔽 : Type*}

/-- The divisor for a diagonal semilinear coefficient with field automorphism
`σ`.  Its two factors say that `σ(t)` equals either `t` or `t⁻¹`. -/
def twistedPencilDiagonalDivisor [CommRing 𝔽]
    (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) : 𝔽 :=
  (σ t - t) * (1 - σ t * t)

/-- The divisor for an off-diagonal semilinear coefficient, equivalently a
fixed-label diagonal association between the twisted code and the Gale dual. -/
def twistedPencilGaleDivisor [CommRing 𝔽]
    (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) : 𝔽 :=
  ((1 - σ t) * (1 - t)) ^ 2 + σ t * t

/-- The projective frame ratio of the last two labeled pencil points after the
first four points have been normalized. -/
def pencilFrameRatio [Field 𝔽] (t : 𝔽) : 𝔽 :=
  t / (1 - t) ^ 2

/-- The cross-multiplied difference of the two frame ratios factors into the
two diagonal-sector branches. -/
theorem pencilFrameRatio_crossDifference [CommRing 𝔽] (s t : 𝔽) :
    s * (1 - t) ^ 2 - t * (1 - s) ^ 2 =
      (s - t) * (1 - s * t) := by
  ring

/-- Away from the excluded parameter `1`, equality of labeled frame ratios is
equivalent to the diagonal-sector divisor. -/
theorem pencilFrameRatio_eq_iff [Field 𝔽] {s t : 𝔽}
    (hs : s - 1 ≠ 0) (ht : t - 1 ≠ 0) :
    pencilFrameRatio s = pencilFrameRatio t ↔
      (s - t) * (1 - s * t) = 0 := by
  have hs' : 1 - s ≠ 0 := sub_ne_zero.mpr (Ne.symm (sub_ne_zero.mp hs))
  have ht' : 1 - t ≠ 0 := sub_ne_zero.mpr (Ne.symm (sub_ne_zero.mp ht))
  rw [pencilFrameRatio, pencilFrameRatio]
  constructor
  · intro h
    have hcross : s * (1 - t) ^ 2 = t * (1 - s) ^ 2 := by
      field_simp [hs', ht'] at h
      simpa [mul_comm] using h
    rw [← pencilFrameRatio_crossDifference s t]
    exact sub_eq_zero.mpr hcross
  · intro h
    have hcross : s * (1 - t) ^ 2 = t * (1 - s) ^ 2 := by
      exact sub_eq_zero.mp
        (by simpa [pencilFrameRatio_crossDifference] using h)
    field_simp [hs', ht']
    simpa [mul_comm] using hcross

/-- The untwisted off-diagonal divisor is exactly the GRS quartic. -/
theorem twistedPencilGaleDivisor_refl [CommRing 𝔽] (t : 𝔽) :
    twistedPencilGaleDivisor (RingEquiv.refl 𝔽) t =
      pencilGRSQuartic t := by
  simp [twistedPencilGaleDivisor, pencilGRSQuartic]
  ring

/-- The explicit diagonal multiplier for the Gale association between
parameters `s` and `t`. -/
def twistedPencilGaleMultiplier [Ring 𝔽] (s t : 𝔽) : Party → 𝔽 :=
  ![-((1 - s) * (1 - t)), -((1 - s) * (1 - t)), 1, 1, -1, -1]

/-- The bilinear parity-check pairing whose vanishing says that the
coordinatewise multiplier sends the `s`-pencil kernel to the Gale dual of the
`t`-pencil kernel. -/
def pencilGalePairing [CommRing 𝔽] (s t : 𝔽) (w : Party → 𝔽)
    (a b : PlaneCoordinate) : 𝔽 :=
  ∑ i, w i * nonGRSPencil s i a * nonGRSPencil t i b

/-- The explicit Gale multiplier kills eight parity-check entries
identically; its last entry is `-2` times the twisted Gale divisor. -/
theorem pencilGalePairing_multiplier [CommRing 𝔽] (s t : 𝔽)
    (a b : PlaneCoordinate) :
    pencilGalePairing s t (twistedPencilGaleMultiplier s t) a b =
      if a = 2 ∧ b = 2 then
        -2 * (((1 - s) * (1 - t)) ^ 2 + s * t)
      else 0 := by
  fin_cases a <;> fin_cases b <;>
    simp [pencilGalePairing, twistedPencilGaleMultiplier, nonGRSPencil,
      Fin.sum_univ_succ] <;>
    ring

/-- In odd characteristic, the explicit multiplier gives a Gale association
exactly on the twisted Gale divisor. -/
theorem pencilGalePairing_multiplier_zero_iff [Field 𝔽]
    (hodd : HasOddCharacteristic (𝔽 := 𝔽)) (s t : 𝔽) :
    (∀ a b, pencilGalePairing s t
        (twistedPencilGaleMultiplier s t) a b = 0) ↔
      ((1 - s) * (1 - t)) ^ 2 + s * t = 0 := by
  constructor
  · intro h
    have hlast := h (2 : PlaneCoordinate) (2 : PlaneCoordinate)
    rw [pencilGalePairing_multiplier] at hlast
    simp at hlast
    exact hlast.resolve_left hodd
  · intro h a b
    rw [pencilGalePairing_multiplier]
    split_ifs
    · simp [h]
    · rfl

/-- On the admitted non-GRS locus, one Frobenius exponent cannot support both
a diagonal coefficient and a Gale coefficient.  The two branches of the
diagonal divisor reduce the Gale divisor to the GRS quartic, directly or
after multiplication by `t²`. -/
theorem twistedPencil_sectors_disjoint [Field 𝔽]
    (σ : 𝔽 ≃+* 𝔽) {t : 𝔽} (ht : IsAdmittedNonGRSParameter t)
    (hdiag : twistedPencilDiagonalDivisor σ t = 0) :
    twistedPencilGaleDivisor σ t ≠ 0 := by
  have ht0 : t ≠ 0 := by
    intro hzero
    apply ht
    simp [hzero]
  have hgrs : pencilGRSQuartic t ≠ 0 := by
    intro hzero
    apply ht
    simp [hzero]
  rw [twistedPencilDiagonalDivisor, mul_eq_zero] at hdiag
  rcases hdiag with hsame | hinverse
  · have hsigma : σ t = t := sub_eq_zero.mp hsame
    have href :
        twistedPencilGaleDivisor (RingEquiv.refl 𝔽) t ≠ 0 := by
      rw [twistedPencilGaleDivisor_refl]
      exact hgrs
    simpa [twistedPencilGaleDivisor, hsigma] using href
  · have hproduct : σ t * t = 1 := (sub_eq_zero.mp hinverse).symm
    have hsigma : σ t = 1 / t := by
      rw [eq_div_iff ht0]
      exact hproduct
    intro hgale
    apply hgrs
    have hscaled :
        t ^ 2 * twistedPencilGaleDivisor σ t = pencilGRSQuartic t := by
      rw [twistedPencilGaleDivisor, pencilGRSQuartic, hsigma]
      field_simp [ht0]
      ring
    rw [← hscaled, hgale, mul_zero]

/-- A field automorphism commutes with the GRS quartic. -/
theorem map_pencilGRSQuartic [Field 𝔽] (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) :
    σ (pencilGRSQuartic t) = pencilGRSQuartic (σ t) := by
  simp only [pencilGRSQuartic, map_sub, map_add, map_mul, map_pow, map_one]
  rw [map_ofNat σ 4, map_ofNat σ 7]

/-- A field automorphism commutes with the first bracket product. -/
theorem map_pencilA [Field 𝔽] (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) :
    σ (pencilA t) = pencilA (σ t) := by
  simp only [pencilA, map_mul, map_neg, map_pow, map_sub, map_one]
  rw [map_ofNat σ 4]

/-- A field automorphism commutes with the second bracket product. -/
theorem map_pencilB [Field 𝔽] (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) :
    σ (pencilB t) = pencilB (σ t) := by
  simp only [pencilB, map_mul, map_sub, map_add, map_pow, map_one]
  rw [map_ofNat σ 3]

/-- The projective scalar `pencilZ` is equivariant under every field
automorphism. -/
theorem map_pencilZ [Field 𝔽] (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) :
    σ (pencilZ t) = pencilZ (σ t) := by
  simp [pencilZ, map_pencilA, map_pencilB]

/-- The admitted non-GRS locus is invariant under field automorphisms. -/
theorem admitted_nonGRS_map_iff [Field 𝔽] (σ : 𝔽 ≃+* 𝔽) (t : 𝔽) :
    IsAdmittedNonGRSParameter (σ t) ↔ IsAdmittedNonGRSParameter t := by
  have hproduct :
      σ (t * (t - 1) * (t ^ 2 - t + 1) *
          (t ^ 2 - 3 * t + 1) * pencilGRSQuartic t) =
        σ t * (σ t - 1) * ((σ t) ^ 2 - σ t + 1) *
          ((σ t) ^ 2 - 3 * σ t + 1) *
          pencilGRSQuartic (σ t) := by
    simp only [map_mul, map_sub, map_add, map_pow, map_one,
      map_pencilGRSQuartic]
    rw [map_ofNat σ 3]
  change
    σ t * (σ t - 1) * ((σ t) ^ 2 - σ t + 1) *
        ((σ t) ^ 2 - 3 * σ t + 1) *
        pencilGRSQuartic (σ t) ≠ 0 ↔
      t * (t - 1) * (t ^ 2 - t + 1) *
        (t ^ 2 - 3 * t + 1) * pencilGRSQuartic t ≠ 0
  rw [← hproduct]
  exact map_ne_zero_iff σ σ.injective

/-- Two pencil parameters have Galois-related quotient scalars relative to
the displayed family of field automorphisms. -/
def PencilZGaloisRelated [Field 𝔽] {κ : Type*}
    (twist : κ → 𝔽 ≃+* 𝔽) (t u : 𝔽) : Prop :=
  ∃ k, pencilZ u = twist k (pencilZ t)

/-- The two mathematical bridges needed to turn Frobenius-sector reduction
into an extension-field orbit theorem.  `extensionEquivalent` may be
instantiated by the full additive local-Clifford relation. -/
structure ExtensionFieldPencilOrbitInputs
    (𝔽 : Type*) [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    {κ : Type*} (twist : κ → 𝔽 ≃+* 𝔽)
    (extensionEquivalent : 𝔽 → 𝔽 → Prop) : Prop where
  /-- A local equivalence has a nonzero Frobenius sector that produces a
  projective equivalence of pencil members. -/
  equivalent_implies_projective_sector :
    ∀ {t u}, IsAdmittedNonGRSParameter t →
      IsAdmittedNonGRSParameter u → extensionEquivalent t u →
      ∃ k, ProjectivelyEquivalent
        (nonGRSPencil (twist k t)) (nonGRSPencil u)
  /-- A Galois match of quotient scalars constructs a local equivalence. -/
  galois_z_implies_equivalent :
    ∀ {t u}, IsAdmittedNonGRSParameter t →
      IsAdmittedNonGRSParameter u →
      PencilZGaloisRelated twist t u → extensionEquivalent t u

/-- Once the sector-reduction and construction bridges hold, extension-field
orbits of the admitted non-GRS pencil are exactly Galois orbits of `pencilZ`. -/
theorem extensionField_pencil_classified_by_galoisZ
    [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    {κ : Type*} (twist : κ → 𝔽 ≃+* 𝔽)
    (w : WeylConvention 𝔽) (classification : PencilClassificationInputs 𝔽 w)
    (extensionEquivalent : 𝔽 → 𝔽 → Prop)
    (inputs : ExtensionFieldPencilOrbitInputs 𝔽 twist extensionEquivalent)
    {t u : 𝔽} (ht : IsAdmittedNonGRSParameter t)
    (hu : IsAdmittedNonGRSParameter u) :
    extensionEquivalent t u ↔ PencilZGaloisRelated twist t u := by
  constructor
  · intro h
    obtain ⟨k, hprojective⟩ :=
      inputs.equivalent_implies_projective_sector ht hu h
    have htwist : IsAdmittedNonGRSParameter (twist k t) :=
      (admitted_nonGRS_map_iff (twist k) t).2 ht
    have hz :
        pencilZ (twist k t) = pencilZ u :=
      classification.projectivelyEquivalent_implies_equal_z
        htwist hu hprojective
    refine ⟨k, ?_⟩
    calc
      pencilZ u = pencilZ (twist k t) := hz.symm
      _ = twist k (pencilZ t) := (map_pencilZ (twist k) t).symm
  · exact inputs.galois_z_implies_equivalent ht hu

end RelativeConicArcs.AMELU
