import Mathlib.LinearAlgebra.Projectivization.PSL.PSL2
import Mathlib.GroupTheory.SpecificGroups.Alternating.Simple
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointProjectiveLine

/-!
# The natural `PSL₂(F5)` action on the six-point packet

The standard projective action of `PSL₂(F5)` on `P¹(F5)` is transported to
the six labels.  Two determinant-one matrices induce exactly the displayed
translation and inversion of those labels.  The module identifies the
resulting projective special linear action with the concrete alternating-group
action already obtained from the invariant one-factorization.

This is a finite group-theoretic identification.  It does not identify the
six projective points with the manuscript's geometrically constructed elliptic
quotients or axes.

The two-transitivity certificate checks the existing sixty-word normal-form
list by kernel reduction with `decide`; no external computation or oracle is
used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

noncomputable section

open scoped LinearAlgebra.Projectivization MatrixGroups

/-- The projective line in function coordinates, labelled by the six-point
packet. -/
def f5ProjectivizationFinTwoEquivSixPoint :
    Projectivization F5 (Fin 2 → F5) ≃ Fin 6 :=
  (projectivizationLinearEquiv (LinearEquiv.finTwoArrow F5 F5)).trans
    sixPointEquivProjectiveLineF5.symm

/-- The faithful natural action of `PSL₂(F5)` on the six labelled
projective points. -/
def psl2F5SixPointAction : PSL(2, F5) →* Equiv.Perm (Fin 6) :=
  f5ProjectivizationFinTwoEquivSixPoint.permCongrHom.toMonoidHom.comp
    (Projectivization.PSLAction.toPermHom (K := F5) (ι := Fin 2))

/-- The transported action is conjugation by the chosen labelling
equivalence. -/
theorem psl2F5SixPointAction_apply (transformation : PSL(2, F5))
    (label : Fin 6) :
    psl2F5SixPointAction transformation label =
      f5ProjectivizationFinTwoEquivSixPoint
        ((Projectivization.PSLAction.toPermHom transformation)
          (f5ProjectivizationFinTwoEquivSixPoint.symm label)) :=
  rfl

/-- The transported natural projective action remains faithful. -/
theorem psl2F5SixPointAction_injective :
    Function.Injective psl2F5SixPointAction :=
  f5ProjectivizationFinTwoEquivSixPoint.permCongrHom.injective.comp
    (Matrix.ProjectiveSpecialLinearGroup.toPermHom_injective
      (K := F5) (ι := Fin 2))

/-- The determinant-one matrix inducing affine translation by one. -/
def f5TranslationSpecialLinear : SL(2, F5) :=
  ⟨!![1, 0; 1, 1], by decide⟩

/-- The determinant-one matrix inducing `[x:y] ↦ [y:-x]`. -/
def f5InversionSpecialLinear : SL(2, F5) :=
  ⟨!![0, 1; -1, 0], by decide⟩

/-- The translation matrix acts on pair coordinates by `(x,y) ↦
(x,x+y)`. -/
theorem f5TranslationSpecialLinear_finTwoArrow (vector : Fin 2 → F5) :
    LinearEquiv.finTwoArrow F5 F5
        (f5TranslationSpecialLinear.1.mulVec vector) =
      f5ProjectiveTranslationLinearEquiv
        (LinearEquiv.finTwoArrow F5 F5 vector) := by
  ext <;> simp [f5TranslationSpecialLinear,
    f5ProjectiveTranslationLinearEquiv, Matrix.vecHead, Matrix.vecTail]

/-- The inversion matrix acts on pair coordinates by `(x,y) ↦
(y,-x)`. -/
theorem f5InversionSpecialLinear_finTwoArrow (vector : Fin 2 → F5) :
    LinearEquiv.finTwoArrow F5 F5
        (f5InversionSpecialLinear.1.mulVec vector) =
      f5ProjectiveInversionLinearEquiv
        (LinearEquiv.finTwoArrow F5 F5 vector) := by
  ext <;> simp [f5InversionSpecialLinear,
    f5ProjectiveInversionLinearEquiv, Matrix.vecHead, Matrix.vecTail]

/-- Conjugating the projective action of the translation matrix from function
coordinates to pair coordinates gives `f5ProjectiveTranslation`. -/
theorem f5TranslationSpecialLinear_projectivization (point :
    Projectivization F5 (F5 × F5)) :
    projectivizationLinearEquiv (LinearEquiv.finTwoArrow F5 F5)
        ((Projectivization.PSLAction.toPermHom
          (f5TranslationSpecialLinear : PSL(2, F5)))
          ((projectivizationLinearEquiv
            (LinearEquiv.finTwoArrow F5 F5)).symm point)) =
      f5ProjectiveTranslation point := by
  let equivalence :=
    projectivizationLinearEquiv (LinearEquiv.finTwoArrow F5 F5)
  change equivalence
      ((f5TranslationSpecialLinear : PSL(2, F5)) • equivalence.symm point) = _
  conv_rhs => rw [← equivalence.apply_symm_apply point]
  generalize equivalence.symm point = functionPoint
  induction functionPoint using Projectivization.ind with
  | h vector nonzero =>
      simp only [equivalence, projectivizationLinearEquiv,
        f5ProjectiveTranslation,
        Matrix.ProjectiveSpecialLinearGroup.smul_proj_mk]
      change Projectivization.mk F5
          (LinearEquiv.finTwoArrow F5 F5
            (f5TranslationSpecialLinear.1.mulVec vector)) _ =
        Projectivization.mk F5
          (f5ProjectiveTranslationLinearEquiv
            (LinearEquiv.finTwoArrow F5 F5 vector)) _
      apply (Projectivization.mk_eq_mk_iff' F5 _ _ _ _).2
      exact ⟨1, by
        simpa using (f5TranslationSpecialLinear_finTwoArrow vector).symm⟩

/-- Conjugating the projective action of the inversion matrix from function
coordinates to pair coordinates gives `f5ProjectiveInversion`. -/
theorem f5InversionSpecialLinear_projectivization (point :
    Projectivization F5 (F5 × F5)) :
    projectivizationLinearEquiv (LinearEquiv.finTwoArrow F5 F5)
        ((Projectivization.PSLAction.toPermHom
          (f5InversionSpecialLinear : PSL(2, F5)))
          ((projectivizationLinearEquiv
            (LinearEquiv.finTwoArrow F5 F5)).symm point)) =
      f5ProjectiveInversion point := by
  let equivalence :=
    projectivizationLinearEquiv (LinearEquiv.finTwoArrow F5 F5)
  change equivalence
      ((f5InversionSpecialLinear : PSL(2, F5)) • equivalence.symm point) = _
  conv_rhs => rw [← equivalence.apply_symm_apply point]
  generalize equivalence.symm point = functionPoint
  induction functionPoint using Projectivization.ind with
  | h vector nonzero =>
      simp only [equivalence, projectivizationLinearEquiv,
        f5ProjectiveInversion,
        Matrix.ProjectiveSpecialLinearGroup.smul_proj_mk]
      change Projectivization.mk F5
          (LinearEquiv.finTwoArrow F5 F5
            (f5InversionSpecialLinear.1.mulVec vector)) _ =
        Projectivization.mk F5
          (f5ProjectiveInversionLinearEquiv
            (LinearEquiv.finTwoArrow F5 F5 vector)) _
      apply (Projectivization.mk_eq_mk_iff' F5 _ _ _ _).2
      exact ⟨1, by
        simpa using (f5InversionSpecialLinear_finTwoArrow vector).symm⟩

/-- The standard unipotent element of `PSL₂(F5)` induces the displayed
six-point translation. -/
theorem psl2F5SixPointAction_translation :
    psl2F5SixPointAction
        (f5TranslationSpecialLinear : PSL(2, F5)) =
      sixPointTranslationPermutation := by
  apply Equiv.ext
  intro label
  rw [psl2F5SixPointAction_apply]
  simp only [f5ProjectivizationFinTwoEquivSixPoint, Equiv.trans_apply,
    Equiv.symm_trans_apply]
  rw [f5TranslationSpecialLinear_projectivization]
  apply sixPointEquivProjectiveLineF5.injective
  simp only [Equiv.apply_symm_apply]
  exact (sixPointEquivProjectiveLineF5_translation label).symm

/-- The standard order-two projective element of `PSL₂(F5)` induces the
displayed six-point inversion. -/
theorem psl2F5SixPointAction_inversion :
    psl2F5SixPointAction
        (f5InversionSpecialLinear : PSL(2, F5)) =
      sixPointInversionPermutation := by
  apply Equiv.ext
  intro label
  rw [psl2F5SixPointAction_apply]
  simp only [f5ProjectivizationFinTwoEquivSixPoint, Equiv.trans_apply,
    Equiv.symm_trans_apply]
  rw [f5InversionSpecialLinear_projectivization]
  apply sixPointEquivProjectiveLineF5.injective
  simp only [Equiv.apply_symm_apply]
  exact (sixPointEquivProjectiveLineF5_inversion label).symm

/-- Conjugation on the six Sylow-five subgroups, transported back to the six
labels. -/
def alternatingFiveSixPointAction :
    alternatingGroup (Fin 5) →* Equiv.Perm (Fin 6) :=
  sixPointFiveSylowEquiv.symm.permCongrHom.toMonoidHom.comp
    (MulAction.toPermHom (alternatingGroup (Fin 5))
      (Sylow 5 (alternatingGroup (Fin 5))))

/-- The transported alternating-group action is conjugation through the
explicit Sylow-five labelling. -/
theorem alternatingFiveSixPointAction_apply
    (transformation : alternatingGroup (Fin 5)) (label : Fin 6) :
    alternatingFiveSixPointAction transformation label =
      sixPointFiveSylowEquiv.symm
        (transformation • sixPointFiveSylowEquiv label) :=
  rfl

/-- Factor translation induces the same displayed permutation through the
alternating-group action. -/
theorem alternatingFiveSixPointAction_translation :
    alternatingFiveSixPointAction sixPointFactorTranslationA5 =
      sixPointTranslationPermutation := by
  apply Equiv.ext
  intro label
  apply sixPointFiveSylowEquiv.injective
  rw [alternatingFiveSixPointAction_apply, Equiv.apply_symm_apply]
  exact (sixPointFiveSylowEquiv_translation label).symm

/-- Factor inversion induces the same displayed permutation through the
alternating-group action. -/
theorem alternatingFiveSixPointAction_inversion :
    alternatingFiveSixPointAction sixPointFactorInversionA5 =
      sixPointInversionPermutation := by
  apply Equiv.ext
  intro label
  apply sixPointFiveSylowEquiv.injective
  rw [alternatingFiveSixPointAction_apply, Equiv.apply_symm_apply]
  exact (sixPointFiveSylowEquiv_inversion label).symm

/-- The conjugation action of `A5` on its six Sylow-five subgroups is
faithful. -/
theorem alternatingFiveSixPointAction_injective :
    Function.Injective alternatingFiveSixPointAction := by
  rw [← MonoidHom.ker_eq_bot_iff]
  rcases alternatingFiveSixPointAction.normal_ker.eq_bot_or_eq_top with
    kernelTrivial | kernelTotal
  · exact kernelTrivial
  · exfalso
    have translationInKernel :
        sixPointFactorTranslationA5 ∈
          alternatingFiveSixPointAction.ker := by
      rw [kernelTotal]
      exact Subgroup.mem_top _
    have translationActsTrivially :=
      MonoidHom.mem_ker.mp translationInKernel
    rw [alternatingFiveSixPointAction_translation] at translationActsTrivially
    have translationNontrivial :
        sixPointTranslationPermutation ≠ 1 := by decide
    exact translationNontrivial translationActsTrivially

/-- The general linear group `GL₂(F5)` has order `480`. -/
theorem f5_generalLinearGroup_two_card :
    Nat.card (GL (Fin 2) F5) = 480 := by
  letI : Fintype F5 := Fintype.ofFinite F5
  rw [Matrix.card_GL_field]
  have fieldCard : Fintype.card F5 = 5 := by
    simp
  simp [fieldCard, Fin.prod_univ_two]

/-- The determinant kernel in `GL₂(F5)` has order `120`. -/
theorem f5_generalLinearGroup_detKernel_card :
    Nat.card
      (Matrix.GeneralLinearGroup.det (n := Fin 2) (R := F5)).ker = 120 := by
  let determinant := Matrix.GeneralLinearGroup.det (n := Fin 2) (R := F5)
  have determinantSurjective : Function.Surjective determinant :=
    Matrix.GeneralLinearGroup.det_surjective
  have rangeTop : determinant.range = ⊤ :=
    determinant.range_eq_top_of_surjective determinantSurjective
  have unitsCard : Nat.card F5ˣ = 4 := by
    rw [Nat.card_units]
    norm_num
  have kernelTimesIndex := determinant.ker.card_mul_index
  rw [Subgroup.index_ker determinant, rangeTop] at kernelTimesIndex
  have topCard : Nat.card (⊤ : Subgroup F5ˣ) = 4 := by
    simpa using unitsCard
  rw [topCard, f5_generalLinearGroup_two_card] at kernelTimesIndex
  apply Nat.eq_of_mul_eq_mul_right (by norm_num : 0 < 4)
  calc
    Nat.card determinant.ker * 4 = 480 := kernelTimesIndex
    _ = 120 * 4 := by norm_num

/-- The special linear group `SL₂(F5)` has order `120`. -/
theorem f5_specialLinearGroup_two_card :
    Nat.card (SL(2, F5)) = 120 := by
  rw [Nat.card_congr (specialLinearEquivDetKernel (Fin 2) F5).toEquiv]
  exact f5_generalLinearGroup_detKernel_card

/-- The center of `SL₂(F5)` consists of the two scalar square roots of
one. -/
theorem f5_specialLinearGroup_center_card :
    Nat.card (Subgroup.center (SL(2, F5))) = 2 := by
  rw [Nat.card_congr
    (Matrix.SpecialLinearGroup.center_equiv_rootsOfUnity'
      (R := F5) (i := (0 : Fin 2))).toEquiv]
  change Nat.card (rootsOfUnity 2 F5) = 2
  rw [Nat.card_eq_fintype_card]
  exact (IsPrimitiveRoot.neg_one (R := F5) 5 (by norm_num)).card_rootsOfUnity

/-- The projective special linear group `PSL₂(F5)` has order `60`. -/
theorem f5_projectiveSpecialLinearGroup_two_card :
    Nat.card PSL(2, F5) = 60 := by
  have factorization :=
    (Subgroup.center (SL(2, F5))).card_eq_card_quotient_mul_card_subgroup
  change Nat.card (SL(2, F5)) =
    Nat.card PSL(2, F5) * Nat.card (Subgroup.center (SL(2, F5))) at factorization
  rw [f5_specialLinearGroup_two_card,
    f5_specialLinearGroup_center_card] at factorization
  omega

/-- A word in factor translation and inversion, regarded as an element of
the concrete alternating group. -/
def sixPointFactorWordA5 (word : List Bool) : alternatingGroup (Fin 5) :=
  ⟨sixPointFactorWord word, sixPointFactorWord_even word⟩

/-- The empty generator word is the identity in the alternating group. -/
@[simp]
theorem sixPointFactorWordA5_nil :
    sixPointFactorWordA5 [] = 1 := by
  apply Subtype.ext
  rfl

/-- Extending a generator word appends the corresponding alternating-group
generator. -/
@[simp]
theorem sixPointFactorWordA5_cons (generator : Bool) (word : List Bool) :
    sixPointFactorWordA5 (generator :: word) =
      sixPointFactorWordA5 word *
        (if generator then sixPointFactorInversionA5
          else sixPointFactorTranslationA5) := by
  apply Subtype.ext
  cases generator <;> rfl

/-- The alternating-group action evaluates every generator word as the
corresponding word in the displayed six-point permutations. -/
theorem alternatingFiveSixPointAction_word (word : List Bool) :
    alternatingFiveSixPointAction (sixPointFactorWordA5 word) =
      sixPointPermutationWord word := by
  induction word with
  | nil => simp [sixPointPermutationWord]
  | cons generator word induction =>
      simp only [sixPointFactorWordA5_cons, sixPointPermutationWord, map_mul]
      rw [induction]
      by_cases inversion : generator
      · simp [inversion, alternatingFiveSixPointAction_inversion]
      · simp [inversion, alternatingFiveSixPointAction_translation]

/-- The same generator word, now represented by the two explicit elements
of `PSL₂(F5)`. -/
def psl2F5Word : List Bool → PSL(2, F5)
  | [] => 1
  | generator :: word =>
      psl2F5Word word *
        (if generator then (f5InversionSpecialLinear : PSL(2, F5))
          else (f5TranslationSpecialLinear : PSL(2, F5)))

/-- The natural projective action evaluates the explicit projective-linear
word as the same displayed permutation word. -/
theorem psl2F5SixPointAction_word (word : List Bool) :
    psl2F5SixPointAction (psl2F5Word word) =
      sixPointPermutationWord word := by
  induction word with
  | nil => simp [psl2F5Word, sixPointPermutationWord]
  | cons generator word induction =>
      simp only [psl2F5Word, sixPointPermutationWord, map_mul]
      rw [induction]
      by_cases inversion : generator
      · simp [inversion, psl2F5SixPointAction_inversion]
      · simp [inversion, psl2F5SixPointAction_translation]

/-- The tracked sixty normal words contain a witness for every ordered pair
of distinct source labels and every ordered pair of distinct target labels. -/
theorem sixPointPermutationNormalWords_two_transitive :
    ∀ source otherSource target otherTarget : Fin 6,
      source ≠ otherSource → target ≠ otherTarget →
        ∃ word ∈ sixPointFactorNormalWords,
          sixPointPermutationWord word source = target ∧
            sixPointPermutationWord word otherSource = otherTarget := by
  decide

/-- The conjugation action of `A5` on its six Sylow-five subgroups is
two-transitive. -/
theorem alternatingFiveSixPointAction_two_transitive
    (source otherSource target otherTarget : Fin 6)
    (sourceDistinct : source ≠ otherSource)
    (targetDistinct : target ≠ otherTarget) :
    ∃ transformation : alternatingGroup (Fin 5),
      alternatingFiveSixPointAction transformation source = target ∧
        alternatingFiveSixPointAction transformation otherSource =
          otherTarget := by
  obtain ⟨word, _, firstImage, secondImage⟩ :=
    sixPointPermutationNormalWords_two_transitive source otherSource target
      otherTarget sourceDistinct targetDistinct
  exact ⟨sixPointFactorWordA5 word, by
    rw [alternatingFiveSixPointAction_word]
    exact firstImage, by
    rw [alternatingFiveSixPointAction_word]
    exact secondImage⟩

/-- The natural projective action of `PSL₂(F5)` on its six projective
points is two-transitive. -/
theorem psl2F5SixPointAction_two_transitive
    (source otherSource target otherTarget : Fin 6)
    (sourceDistinct : source ≠ otherSource)
    (targetDistinct : target ≠ otherTarget) :
    ∃ transformation : PSL(2, F5),
      psl2F5SixPointAction transformation source = target ∧
        psl2F5SixPointAction transformation otherSource = otherTarget := by
  obtain ⟨word, _, firstImage, secondImage⟩ :=
    sixPointPermutationNormalWords_two_transitive source otherSource target
      otherTarget sourceDistinct targetDistinct
  exact ⟨psl2F5Word word, by
    rw [psl2F5SixPointAction_word]
    exact firstImage, by
    rw [psl2F5SixPointAction_word]
    exact secondImage⟩

/-- Every permutation arising from the alternating-group conjugation action
also arises from the natural projective action. -/
theorem alternatingFiveSixPointAction_range_le_psl2F5SixPointAction_range :
    alternatingFiveSixPointAction.range ≤ psl2F5SixPointAction.range := by
  rintro permutation ⟨transformation, rfl⟩
  obtain ⟨word, wordEquality⟩ :=
    sixPointGeneratedAction_realizes_alternatingGroup.2.1
      transformation.1 transformation.2
  have factorWordEquality :
      sixPointFactorWordA5 word = transformation := by
    apply Subtype.ext
    exact wordEquality
  refine ⟨psl2F5Word word, ?_⟩
  rw [psl2F5SixPointAction_word,
    ← alternatingFiveSixPointAction_word, factorWordEquality]

/-- The faithful natural projective action has a sixty-element image. -/
theorem psl2F5SixPointAction_range_card :
    Nat.card psl2F5SixPointAction.range = 60 := by
  rw [← Nat.card_congr
    (MonoidHom.ofInjective psl2F5SixPointAction_injective).toEquiv]
  exact f5_projectiveSpecialLinearGroup_two_card

/-- The faithful alternating-group conjugation action has a sixty-element
image. -/
theorem alternatingFiveSixPointAction_range_card :
    Nat.card alternatingFiveSixPointAction.range = 60 := by
  rw [← Nat.card_congr
    (MonoidHom.ofInjective alternatingFiveSixPointAction_injective).toEquiv]
  exact alternatingGroup_fin_five_card

/-- The natural `PSL₂(F5)` action and the alternating-group conjugation
action have exactly the same image in the six-point permutation group. -/
theorem psl2F5SixPointAction_range_eq_alternatingFiveSixPointAction_range :
    psl2F5SixPointAction.range = alternatingFiveSixPointAction.range := by
  symm
  apply Subgroup.eq_of_le_of_card_ge
    alternatingFiveSixPointAction_range_le_psl2F5SixPointAction_range
  rw [psl2F5SixPointAction_range_card,
    alternatingFiveSixPointAction_range_card]

/-- The common permutation image, viewed with either source group. -/
def psl2F5ActionRangeEquivAlternatingFiveActionRange :
    psl2F5SixPointAction.range ≃* alternatingFiveSixPointAction.range where
  toFun permutation := ⟨permutation.1, by
    rw [← psl2F5SixPointAction_range_eq_alternatingFiveSixPointAction_range]
    exact permutation.2⟩
  invFun permutation := ⟨permutation.1, by
    rw [psl2F5SixPointAction_range_eq_alternatingFiveSixPointAction_range]
    exact permutation.2⟩
  left_inv permutation := Subtype.ext rfl
  right_inv permutation := Subtype.ext rfl
  map_mul' _ _ := Subtype.ext rfl

/-- The exceptional isomorphism `PSL₂(F5) ≃ A5`, selected so that the two
natural six-point actions agree. -/
def psl2F5EquivAlternatingFive :
    PSL(2, F5) ≃* alternatingGroup (Fin 5) :=
  (MonoidHom.ofInjective psl2F5SixPointAction_injective).trans
    (psl2F5ActionRangeEquivAlternatingFiveActionRange.trans
      (MonoidHom.ofInjective alternatingFiveSixPointAction_injective).symm)

/-- The exceptional isomorphism literally intertwines the natural projective
action with conjugation on the six Sylow-five subgroups. -/
theorem psl2F5EquivAlternatingFive_action (transformation : PSL(2, F5)) :
    alternatingFiveSixPointAction
        (psl2F5EquivAlternatingFive transformation) =
      psl2F5SixPointAction transformation := by
  let projectiveRangeElement :=
    (MonoidHom.ofInjective psl2F5SixPointAction_injective) transformation
  let commonRangeElement :=
    psl2F5ActionRangeEquivAlternatingFiveActionRange projectiveRangeElement
  have inverseEquality :
      alternatingFiveSixPointAction
          ((MonoidHom.ofInjective
            alternatingFiveSixPointAction_injective).symm
              commonRangeElement) = commonRangeElement.1 := congrArg Subtype.val
    ((MonoidHom.ofInjective alternatingFiveSixPointAction_injective).apply_symm_apply
      commonRangeElement)
  have commonEquality :
      commonRangeElement.1 = psl2F5SixPointAction transformation := rfl
  change alternatingFiveSixPointAction
      ((MonoidHom.ofInjective
        alternatingFiveSixPointAction_injective).symm
          commonRangeElement) = psl2F5SixPointAction transformation
  exact inverseEquality.trans commonEquality

/-- The stabilizer of one label under the natural `PSL₂(F5)` permutation
action. -/
def psl2F5SixPointStabilizer (label : Fin 6) : Subgroup PSL(2, F5) :=
  (MulAction.stabilizer (Equiv.Perm (Fin 6)) label).comap
    psl2F5SixPointAction

/-- Membership in the projective-linear point stabilizer is literal point
fixing. -/
theorem mem_psl2F5SixPointStabilizer_iff
    (transformation : PSL(2, F5)) (label : Fin 6) :
    transformation ∈ psl2F5SixPointStabilizer label ↔
      psl2F5SixPointAction transformation label = label :=
  Iff.rfl

/-- The stabilizer of one label under the transported alternating-group
action. -/
def alternatingFiveSixPointStabilizer (label : Fin 6) :
    Subgroup (alternatingGroup (Fin 5)) :=
  (MulAction.stabilizer (Equiv.Perm (Fin 6)) label).comap
    alternatingFiveSixPointAction

/-- Membership in the alternating-group point stabilizer is literal point
fixing. -/
theorem mem_alternatingFiveSixPointStabilizer_iff
    (transformation : alternatingGroup (Fin 5)) (label : Fin 6) :
    transformation ∈ alternatingFiveSixPointStabilizer label ↔
      alternatingFiveSixPointAction transformation label = label :=
  Iff.rfl

/-- Under the Sylow-five labelling, the alternating-group point stabilizer is
exactly the normalizer of the corresponding order-five subgroup. -/
theorem alternatingFiveSixPointStabilizer_eq_normalizer (label : Fin 6) :
    alternatingFiveSixPointStabilizer label =
      Subgroup.normalizer
        (sixPointFiveSubgroup label : Set (alternatingGroup (Fin 5))) := by
  rw [← sixPointFiveSylow_stabilizer_eq_normalizer]
  ext transformation
  rw [mem_alternatingFiveSixPointStabilizer_iff]
  change alternatingFiveSixPointAction transformation label = label ↔
    transformation • sixPointFiveSylowEquiv label =
      sixPointFiveSylowEquiv label
  rw [alternatingFiveSixPointAction_apply]
  constructor
  · intro equality
    have transported := congrArg sixPointFiveSylowEquiv equality
    simpa using transported
  · intro equality
    have transported := congrArg sixPointFiveSylowEquiv.symm equality
    simpa using transported

/-- The exceptional isomorphism restricts to an isomorphism of corresponding
six-point stabilizers. -/
def psl2F5SixPointStabilizerEquivAlternatingFiveSixPointStabilizer
    (label : Fin 6) :
    psl2F5SixPointStabilizer label ≃*
      alternatingFiveSixPointStabilizer label where
  toFun transformation := ⟨psl2F5EquivAlternatingFive transformation.1, by
    rw [mem_alternatingFiveSixPointStabilizer_iff,
      psl2F5EquivAlternatingFive_action]
    exact (mem_psl2F5SixPointStabilizer_iff _ _).mp transformation.2⟩
  invFun transformation := ⟨psl2F5EquivAlternatingFive.symm transformation.1, by
    rw [mem_psl2F5SixPointStabilizer_iff,
      ← psl2F5EquivAlternatingFive_action]
    simpa using
      (mem_alternatingFiveSixPointStabilizer_iff _ _).mp transformation.2⟩
  left_inv transformation := Subtype.ext (by simp)
  right_inv transformation := Subtype.ext (by simp)
  map_mul' _ _ := Subtype.ext (by simp)

/-- The natural projective-linear stabilizer is the same abstract dihedral
group as the corresponding Sylow-five normalizer. -/
noncomputable def psl2F5SixPointStabilizerEquivDihedral (label : Fin 6) :
    DihedralGroup 5 ≃* psl2F5SixPointStabilizer label :=
  sixPointFiveNormalizerMulEquivDihedral label |>.trans
    ((by
      rw [alternatingFiveSixPointStabilizer_eq_normalizer] :
      alternatingFiveSixPointStabilizer label ≃*
        Subgroup.normalizer
          (sixPointFiveSubgroup label : Set (alternatingGroup (Fin 5)))).symm) |>.trans
    (psl2F5SixPointStabilizerEquivAlternatingFiveSixPointStabilizer label).symm

/-- Every point stabilizer in the natural six-point `PSL₂(F5)` action has
order ten. -/
theorem psl2F5SixPointStabilizer_card (label : Fin 6) :
    Nat.card (psl2F5SixPointStabilizer label) = 10 := by
  rw [Nat.card_congr
    (psl2F5SixPointStabilizerEquivAlternatingFiveSixPointStabilizer
      label).toEquiv]
  rw [alternatingFiveSixPointStabilizer_eq_normalizer]
  exact sixPointFiveSubgroup_normalizer_card label

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
