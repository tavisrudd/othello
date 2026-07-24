import RelativeConicArcs.AMELU.Dictionary

/-!
# The admitted non-GRS six-arc pencil and its classification interface

This module defines the ordered six-point pencil

`(0,1,1-t), (0,1,t-1), (1,1-t,0), (1,t-1,0), (1,0,-t), (1,0,t)`

over a finite field, its admitted non-GRS locus, and the scalar
`z(t) = (B(t)/A(t))²`.  The elementary reduction through
`y(t) = (t-1)²/t` is proved algebraically.

The projective classification is represented by
`PencilClassificationInputs`.  Its fields state separately the geometric
facts that admitted parameters give six-arcs, equality of `z` supplies a
projectivity, and local-Clifford equivalence forces equality of `z`.  These
facts are hypotheses rather than hidden axioms.  From them and the proved
arc--code--state dictionary, the terminal theorem derives the projective,
monomial-code, and local-Clifford classification.

All declarations are kernel checked.  The module uses no generated data,
native evaluation, project-specific axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix

variable {𝔽 : Type*}

/-- The ordered representatives of the six-point pencil at parameter `t`. -/
def nonGRSPencil [Ring 𝔽] (t : 𝔽) : Party → PlaneCoordinate → 𝔽 :=
  ![![0, 1, 1 - t], ![0, 1, t - 1], ![1, 1 - t, 0],
    ![1, t - 1, 0], ![1, 0, -t], ![1, 0, t]]

/-- The quartic whose vanishing is the conic, hence GRS, boundary of the
six-point pencil. -/
def pencilGRSQuartic [Ring 𝔽] (t : 𝔽) : 𝔽 :=
  t ^ 4 - 4 * t ^ 3 + 7 * t ^ 2 - 4 * t + 1

/-- The first signed complementary-bracket product used in the quotient. -/
def pencilA [Ring 𝔽] (t : 𝔽) : 𝔽 :=
  -4 * t * (t - 1) ^ 2

/-- The second signed complementary-bracket product used in the quotient. -/
def pencilB [Ring 𝔽] (t : 𝔽) : 𝔽 :=
  (t ^ 2 - t + 1) * (t ^ 2 - 3 * t + 1)

/-- The projective quotient scalar `(B/A)²` of the pencil. -/
def pencilZ [Field 𝔽] (t : 𝔽) : 𝔽 :=
  (pencilB t / pencilA t) ^ 2

/-- The intermediate degree-two coordinate `(t-1)²/t`. -/
def pencilY [Field 𝔽] (t : 𝔽) : 𝔽 :=
  (t - 1) ^ 2 / t

/-- The quotient scalar expressed as a function of the intermediate
coordinate: `(y-y⁻¹)²/16`. -/
def pencilZFromY [Field 𝔽] (y : 𝔽) : 𝔽 :=
  (y - y⁻¹) ^ 2 / 16

/-- The exact admitted non-GRS condition.  The five factors exclude the
degenerate pencil coordinates and the conic boundary. -/
def IsAdmittedNonGRSParameter [Field 𝔽] (t : 𝔽) : Prop :=
  t * (t - 1) * (t ^ 2 - t + 1) * (t ^ 2 - 3 * t + 1) *
    pencilGRSQuartic t ≠ 0

/-- The odd-characteristic condition used by the pencil quotient. -/
def HasOddCharacteristic [Field 𝔽] : Prop :=
  (2 : 𝔽) ≠ 0

theorem admitted_parameter_ne_zero [Field 𝔽] {t : 𝔽}
    (ht : IsAdmittedNonGRSParameter t) :
    t ≠ 0 := by
  intro h
  apply ht
  simp [h]

theorem admitted_parameter_sub_one_ne_zero [Field 𝔽] {t : 𝔽}
    (ht : IsAdmittedNonGRSParameter t) :
    t - 1 ≠ 0 := by
  intro h
  apply ht
  simp [h]

theorem admitted_first_quadratic_ne_zero [Field 𝔽] {t : 𝔽}
    (ht : IsAdmittedNonGRSParameter t) :
    t ^ 2 - t + 1 ≠ 0 := by
  intro h
  apply ht
  simp [h]

theorem admitted_second_quadratic_ne_zero [Field 𝔽] {t : 𝔽}
    (ht : IsAdmittedNonGRSParameter t) :
    t ^ 2 - 3 * t + 1 ≠ 0 := by
  intro h
  apply ht
  simp [h]

theorem admitted_grsQuartic_ne_zero [Field 𝔽] {t : 𝔽}
    (ht : IsAdmittedNonGRSParameter t) :
    pencilGRSQuartic t ≠ 0 := by
  intro h
  apply ht
  simp [h]

/-- On an odd field, the admitted condition makes the first bracket
coordinate nonzero. -/
theorem pencilA_ne_zero [Field 𝔽] {t : 𝔽}
    (hodd : HasOddCharacteristic (𝔽 := 𝔽))
    (ht : IsAdmittedNonGRSParameter t) :
    pencilA t ≠ 0 := by
  have hfour : (4 : 𝔽) ≠ 0 := by
    simpa [show (4 : 𝔽) = 2 * 2 by norm_num] using
      mul_ne_zero hodd hodd
  simp [pencilA, hfour, admitted_parameter_ne_zero ht,
    admitted_parameter_sub_one_ne_zero ht]

/-- The admitted condition makes the second bracket coordinate nonzero. -/
theorem pencilB_ne_zero [Field 𝔽] {t : 𝔽}
    (ht : IsAdmittedNonGRSParameter t) :
    pencilB t ≠ 0 := by
  exact mul_ne_zero (admitted_first_quadratic_ne_zero ht)
    (admitted_second_quadratic_ne_zero ht)

/-- The intermediate coordinate rewrites the first bracket product. -/
theorem pencilA_eq_neg_four_mul_sq_mul_y [Field 𝔽] {t : 𝔽}
    (ht : t ≠ 0) :
    pencilA t = -4 * t ^ 2 * pencilY t := by
  rw [pencilA, pencilY]
  field_simp [ht]

/-- The intermediate coordinate rewrites the second bracket product. -/
theorem pencilB_eq_sq_mul_y_sq_sub_one [Field 𝔽] {t : 𝔽}
    (ht : t ≠ 0) :
    pencilB t = t ^ 2 * (pencilY t ^ 2 - 1) := by
  rw [pencilB, pencilY]
  field_simp [ht]
  ring

/-- On the admitted odd locus, the bracket quotient agrees with
`(y-y⁻¹)²/16`. -/
theorem pencilZ_eq_pencilZFromY [Field 𝔽] {t : 𝔽}
    (hodd : HasOddCharacteristic (𝔽 := 𝔽))
    (ht : IsAdmittedNonGRSParameter t) :
    pencilZ t = pencilZFromY (pencilY t) := by
  have ht0 := admitted_parameter_ne_zero ht
  have ht1 := admitted_parameter_sub_one_ne_zero ht
  have hy0 : pencilY t ≠ 0 := by
    exact div_ne_zero (pow_ne_zero 2 ht1) ht0
  have hfour : (4 : 𝔽) ≠ 0 := by
    simpa [show (4 : 𝔽) = 2 * 2 by norm_num] using
      mul_ne_zero hodd hodd
  have hsixteen : (16 : 𝔽) ≠ 0 := by
    simpa [show (16 : 𝔽) = 4 * 4 by norm_num] using
      mul_ne_zero hfour hfour
  rw [pencilZ, pencilZFromY,
    pencilA_eq_neg_four_mul_sq_mul_y ht0,
    pencilB_eq_sq_mul_y_sq_sub_one ht0]
  field_simp [ht0, hy0, hfour, hsixteen]
  ring

/-- The four-element orbit relation on the intermediate coordinate. -/
def SamePencilYOrbit [Field 𝔽] (y v : 𝔽) : Prop :=
  v = y ∨ v = -y ∨ v = y⁻¹ ∨ v = -y⁻¹

/-- The scalar `(y-y⁻¹)²/16` is constant on the four displayed
intermediate-coordinate branches. -/
theorem pencilZFromY_eq_of_sameOrbit [Field 𝔽] {y v : 𝔽}
    (h : SamePencilYOrbit y v) :
    pencilZFromY v = pencilZFromY y := by
  rcases h with rfl | rfl | rfl | rfl
  · rfl
  · simp [pencilZFromY]
    ring
  · simp [pencilZFromY]
    ring
  · simp [pencilZFromY]
    ring

/-- Over an odd field, two nonzero intermediate coordinates have the
same quotient scalar exactly when they lie in the four-element orbit
`y, -y, y⁻¹, -y⁻¹`. -/
theorem samePencilYOrbit_iff_pencilZFromY_eq [Field 𝔽] {y v : 𝔽}
    (hodd : HasOddCharacteristic (𝔽 := 𝔽)) (hy : y ≠ 0) (hv : v ≠ 0) :
    SamePencilYOrbit y v ↔ pencilZFromY v = pencilZFromY y := by
  constructor
  · exact pencilZFromY_eq_of_sameOrbit
  intro hz
  have hfour : (4 : 𝔽) ≠ 0 := by
    simpa [show (4 : 𝔽) = 2 * 2 by norm_num] using
      mul_ne_zero hodd hodd
  have hsixteen : (16 : 𝔽) ≠ 0 := by
    simpa [show (16 : 𝔽) = 4 * 4 by norm_num] using
      mul_ne_zero hfour hfour
  have hsquare :
      (v - v⁻¹) ^ 2 = (y - y⁻¹) ^ 2 := by
    simpa [pencilZFromY, hsixteen] using hz
  have hproduct :
      ((v - v⁻¹) - (y - y⁻¹)) * ((v - v⁻¹) + (y - y⁻¹)) = 0 := by
    calc
      ((v - v⁻¹) - (y - y⁻¹)) * ((v - v⁻¹) + (y - y⁻¹)) =
          (v - v⁻¹) ^ 2 - (y - y⁻¹) ^ 2 := by ring
      _ = 0 := sub_eq_zero.mpr hsquare
  rcases mul_eq_zero.mp hproduct with hsame | hopposite
  · have hfactor : (v - y) * (v * y + 1) = 0 := by
      calc
        (v - y) * (v * y + 1) =
            ((v - v⁻¹) - (y - y⁻¹)) * (v * y) := by
              field_simp [hv, hy]
              ring
        _ = 0 := by rw [hsame, zero_mul]
    rcases mul_eq_zero.mp hfactor with hv_eq | hprod
    · exact Or.inl (sub_eq_zero.mp hv_eq)
    · right; right; right
      have hvy : v * y = -1 := by
        linear_combination hprod
      calc
        v = (v * y) * y⁻¹ := by field_simp [hy]
        _ = (-1) * y⁻¹ := by rw [hvy]
        _ = -y⁻¹ := by ring
  · have hfactor : (v + y) * (v * y - 1) = 0 := by
      calc
        (v + y) * (v * y - 1) =
            ((v - v⁻¹) + (y - y⁻¹)) * (v * y) := by
              field_simp [hv, hy]
              ring
        _ = 0 := by rw [hopposite, zero_mul]
    rcases mul_eq_zero.mp hfactor with hv_eq | hprod
    · right; left
      exact eq_neg_of_add_eq_zero_left hv_eq
    · right; right; left
      have hvy : v * y = 1 := sub_eq_zero.mp hprod
      calc
        v = (v * y) * y⁻¹ := by field_simp [hy]
        _ = 1 * y⁻¹ := by rw [hvy]
        _ = y⁻¹ := one_mul _

/-- The manuscript's exact algebraic quotient: on the admitted odd locus,
`z(t)=z(u)` precisely when `y(u)` is one of
`y(t), -y(t), y(t)⁻¹, -y(t)⁻¹`. -/
theorem pencilZ_eq_iff_samePencilYOrbit [Field 𝔽] {t u : 𝔽}
    (hodd : HasOddCharacteristic (𝔽 := 𝔽))
    (ht : IsAdmittedNonGRSParameter t)
    (hu : IsAdmittedNonGRSParameter u) :
    pencilZ t = pencilZ u ↔ SamePencilYOrbit (pencilY t) (pencilY u) := by
  have hyt : pencilY t ≠ 0 := by
    exact div_ne_zero
      (pow_ne_zero 2 (admitted_parameter_sub_one_ne_zero ht))
      (admitted_parameter_ne_zero ht)
  have hyu : pencilY u ≠ 0 := by
    exact div_ne_zero
      (pow_ne_zero 2 (admitted_parameter_sub_one_ne_zero hu))
      (admitted_parameter_ne_zero hu)
  rw [pencilZ_eq_pencilZFromY hodd ht,
    pencilZ_eq_pencilZFromY hodd hu]
  constructor
  · intro hz
    exact (samePencilYOrbit_iff_pencilZFromY_eq hodd hyt hyu).mpr hz.symm
  · intro horbit
    exact
      ((samePencilYOrbit_iff_pencilZFromY_eq hodd hyt hyu).mp horbit).symm

/-- Explicit inputs for the admitted-pencil classification.  Each field
is a mathematical hypothesis with its quantifiers and direction exposed:
arc nondegeneracy, construction of a projectivity from equal quotient
coordinates, and recovery of the quotient coordinate from an LC orbit. -/
structure PencilClassificationInputs
    (𝔽 : Type*) [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) : Prop where
  /-- The field has odd characteristic. -/
  oddCharacteristic : HasOddCharacteristic (𝔽 := 𝔽)
  /-- Every admitted parameter gives an ordered six-arc. -/
  admitted_isSixArc :
    ∀ t : 𝔽, IsAdmittedNonGRSParameter t → IsSixArc (nonGRSPencil t)
  /-- Equality of `z` on admitted parameters is realized projectively,
  allowing a permutation and independent column scalings. -/
  equal_z_implies_projectivelyEquivalent :
    ∀ {t u : 𝔽}, IsAdmittedNonGRSParameter t →
      IsAdmittedNonGRSParameter u → pencilZ t = pencilZ u →
      ProjectivelyEquivalent (nonGRSPencil t) (nonGRSPencil u)
  /-- Projective equivalence of admitted pencil members preserves `z`.
  This field isolates the complementary-bracket invariant input. -/
  projectivelyEquivalent_implies_equal_z :
    ∀ {t u : 𝔽}, IsAdmittedNonGRSParameter t →
      IsAdmittedNonGRSParameter u →
      ProjectivelyEquivalent (nonGRSPencil t) (nonGRSPencil u) →
      pencilZ t = pencilZ u
  /-- An LC equivalence of admitted pencil states forces equality of `z`.
  This field isolates the holonomy/classification input not proved here. -/
  locallyCliffordEquivalent_implies_equal_z :
    ∀ {t u : 𝔽}, IsAdmittedNonGRSParameter t →
      IsAdmittedNonGRSParameter u →
      LocallyCliffordEquivalent w
        (equalPhaseState (arcKernel (nonGRSPencil t)))
        (equalPhaseState (arcKernel (nonGRSPencil u))) →
      pencilZ t = pencilZ u

/-- The complete admitted-pencil interface: projective equivalence,
monomial equivalence of the parity-check kernels, and local-Clifford
equivalence of their equal-phase states are each equivalent to equality
of the scalar `z`. -/
theorem admitted_nonGRS_pencil_classified_by_z
    [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) (inputs : PencilClassificationInputs 𝔽 w)
    {t u : 𝔽} (ht : IsAdmittedNonGRSParameter t)
    (hu : IsAdmittedNonGRSParameter u) :
    (ProjectivelyEquivalent (nonGRSPencil t) (nonGRSPencil u) ↔
      pencilZ t = pencilZ u) ∧
    (MonomiallyEquivalent
        (arcKernel (nonGRSPencil t)) (arcKernel (nonGRSPencil u)) ↔
      pencilZ t = pencilZ u) ∧
    (LocallyCliffordEquivalent w
        (equalPhaseState (arcKernel (nonGRSPencil t)))
        (equalPhaseState (arcKernel (nonGRSPencil u))) ↔
      pencilZ t = pencilZ u) := by
  have hz_to_proj :
      pencilZ t = pencilZ u →
        ProjectivelyEquivalent (nonGRSPencil t) (nonGRSPencil u) :=
    inputs.equal_z_implies_projectivelyEquivalent ht hu
  have proj_to_z :
      ProjectivelyEquivalent (nonGRSPencil t) (nonGRSPencil u) →
        pencilZ t = pencilZ u :=
    inputs.projectivelyEquivalent_implies_equal_z ht hu
  have proj_to_mono :
      ProjectivelyEquivalent (nonGRSPencil t) (nonGRSPencil u) →
        MonomiallyEquivalent
          (arcKernel (nonGRSPencil t)) (arcKernel (nonGRSPencil u)) :=
    projectivelyEquivalent_arcKernel_monomiallyEquivalent
  have mono_to_lc :
      MonomiallyEquivalent
          (arcKernel (nonGRSPencil t)) (arcKernel (nonGRSPencil u)) →
        LocallyCliffordEquivalent w
          (equalPhaseState (arcKernel (nonGRSPencil t)))
          (equalPhaseState (arcKernel (nonGRSPencil u))) :=
    monomiallyEquivalent_equalPhaseState_locallyCliffordEquivalent w
  have lc_to_z :
      LocallyCliffordEquivalent w
          (equalPhaseState (arcKernel (nonGRSPencil t)))
          (equalPhaseState (arcKernel (nonGRSPencil u))) →
        pencilZ t = pencilZ u :=
    inputs.locallyCliffordEquivalent_implies_equal_z ht hu
  constructor
  · exact ⟨proj_to_z, hz_to_proj⟩
  constructor
  · exact ⟨fun h => lc_to_z (mono_to_lc h),
      fun h => proj_to_mono (hz_to_proj h)⟩
  · exact ⟨lc_to_z, fun h => mono_to_lc (proj_to_mono (hz_to_proj h))⟩

end RelativeConicArcs.AMELU
