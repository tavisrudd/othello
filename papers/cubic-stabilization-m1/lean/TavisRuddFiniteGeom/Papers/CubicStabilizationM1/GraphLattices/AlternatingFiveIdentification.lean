import Mathlib.GroupTheory.SpecificGroups.Alternating
import Mathlib.LinearAlgebra.Projectivization.Cardinality
import Mathlib.LinearAlgebra.Projectivization.PSL.PSL2
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.ExoticStabilizerCore

/-!
# The exceptional isomorphism `SL₂(F4) ≃ A5`

This module constructs the abstract exceptional isomorphism used in the
principal-gluing stabilizer paragraph.  It uses the faithful action of the
projective special linear group on its five projective points.  Perfectness
forces the image permutations to be even, and the two groups have the same
order.  No geometric permutation stabilizer is identified here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

noncomputable section

open scoped LinearAlgebra.Projectivization MatrixGroups

/-- The ordinary alternating group on five letters has order `60`. -/
theorem alternatingGroup_fin_five_card :
    Nat.card (alternatingGroup (Fin 5)) = 60 := by
  rw [nat_card_alternatingGroup]
  norm_num

/-- The projective line of the natural two-dimensional `F4`-module has five
points. -/
theorem f4_projectivization_fin_two_card :
    Nat.card (Projectivization F4 (Fin 2 → F4)) = 5 := by
  rw [Projectivization.card'']
  have functionCard : Nat.card (Fin 2 → F4) = 16 := by
    rw [Nat.card_fun, natCard_F4, Nat.card_fin]
    norm_num
  rw [functionCard, natCard_F4]

/-- A linear equivalence induces an equivalence of projectivizations. -/
def projectivizationLinearEquiv
    {K V W : Type*} [Field K]
    [AddCommGroup V] [Module K V] [AddCommGroup W] [Module K W]
    (equivalence : V ≃ₗ[K] W) :
    Projectivization K V ≃ Projectivization K W where
  toFun := Projectivization.map equivalence.toLinearMap equivalence.injective
  invFun :=
    Projectivization.map equivalence.symm.toLinearMap equivalence.symm.injective
  left_inv point := by
    induction point using Projectivization.ind with
    | h vector nonzero =>
        simp only [Projectivization.map_mk]
        change Projectivization.mk K (equivalence.symm (equivalence vector)) _ = _
        apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).2
        exact ⟨1, by simp⟩
  right_inv point := by
    induction point using Projectivization.ind with
    | h vector nonzero =>
        simp only [Projectivization.map_mk]
        change Projectivization.mk K (equivalence (equivalence.symm vector)) _ = _
        apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).2
        exact ⟨1, by simp⟩

/-- The natural projective line, expressed in the manuscript's affine chart:
`none` is the vertical point and `some a` is the graph of `a`. -/
def f4ProjectivizationEquivOption :
    Projectivization F4 (Fin 2 → F4) ≃ Option F4 :=
  (projectivizationLinearEquiv (LinearEquiv.finTwoArrow F4 F4)).trans
    (optionEquivProjectiveLine F4).symm

/-- The affine-chart packet has five elements. -/
theorem f4_option_card : Nat.card (Option F4) = 5 := by
  rw [← Nat.card_congr f4ProjectivizationEquivOption]
  exact f4_projectivization_fin_two_card

/-- A fixed labelling of the manuscript's affine-chart packet by five
letters. -/
def f4OptionEquivFinFive : Option F4 ≃ Fin 5 :=
  (Finite.equivFin _).trans (finCongr f4_option_card)

/-- A fixed labelling of the five projective points.  The construction of the
exceptional isomorphism is independent of which labelling is chosen. -/
def f4ProjectivizationEquivFinFive :
    Projectivization F4 (Fin 2 → F4) ≃ Fin 5 :=
  f4ProjectivizationEquivOption.trans f4OptionEquivFinFive

/-- The faithful projective action, transported to five labelled points. -/
def psl2F4ProjectiveAction :
    PSL(2, F4) →* Equiv.Perm (Fin 5) :=
  f4ProjectivizationEquivFinFive.permCongrHom.toMonoidHom.comp
    (Projectivization.PSLAction.toPermHom (K := F4) (ι := Fin 2))

/-- The transported projective action remains faithful. -/
theorem psl2F4ProjectiveAction_injective :
    Function.Injective psl2F4ProjectiveAction :=
  (f4ProjectivizationEquivFinFive.permCongrHom.injective.comp
    (Matrix.ProjectiveSpecialLinearGroup.toPermHom_injective
      (K := F4) (ι := Fin 2) :
        Function.Injective
          (Projectivization.PSLAction.toPermHom (K := F4) (ι := Fin 2))))

/-- In characteristic two, the center of `SL₂(F4)` is trivial. -/
theorem f4_specialLinearGroup_center_eq_bot :
    Subgroup.center (SL(2, F4)) = ⊥ := by
  apply le_antisymm
  · intro matrix central
    change matrix = 1
    obtain ⟨scalar, scalarSquare, scalarMatrix⟩ :=
      Matrix.SpecialLinearGroup.mem_center_iff.mp central
    have scalarSquare' : scalar ^ 2 = 1 := by
      simpa using scalarSquare
    have negOne : (-1 : F4) = 1 := by
      have negOneBase : (-1 : ZMod 2) = 1 := by decide
      simpa only [map_neg, map_one] using
        congrArg (algebraMap (ZMod 2) F4) negOneBase
    have scalarOne : scalar = 1 := by
      rcases sq_eq_one_iff.mp scalarSquare' with scalarOne | scalarNegOne
      · exact scalarOne
      · simpa [negOne] using scalarNegOne
    apply Matrix.SpecialLinearGroup.ext
    intro row column
    rw [← scalarMatrix]
    simp [scalarOne]
  · exact bot_le

/-- In characteristic two, projectivization does not quotient `SL₂(F4)` by
anything: `PSL₂(F4) ≃ SL₂(F4)`. -/
def psl2F4EquivSpecialLinearGroup :
    PSL(2, F4) ≃* SL(2, F4) :=
  (QuotientGroup.quotientMulEquivOfEq
      f4_specialLinearGroup_center_eq_bot).trans
    QuotientGroup.quotientBot

/-- The projective special linear group also has order `60`. -/
theorem f4_projectiveSpecialLinearGroup_two_card :
    Nat.card PSL(2, F4) = 60 := by
  rw [Nat.card_congr psl2F4EquivSpecialLinearGroup.toEquiv]
  exact f4_specialLinearGroup_two_card

/-- There is an element of `F4` whose square is neither zero nor one, the
field-size input needed for perfectness of `PSL₂(F4)`. -/
theorem f4_exists_nonzero_square_ne_one :
    ∃ scalar : F4, scalar ≠ 0 ∧ scalar ^ 2 ≠ 1 := by
  have fieldCard : ENat.card F4 = 4 := by
    rw [ENat.card_eq_coe_natCard, natCard_F4]
    norm_num
  obtain ⟨scalar, scalarNotZero, scalarNotOne⟩ :=
    ENat.exists_ne_ne_of_three_le (α := F4) (by rw [fieldCard]; norm_num) 0 1
  refine ⟨scalar, scalarNotZero, ?_⟩
  intro scalarSquare
  rcases sq_eq_one_iff.mp scalarSquare with scalarOne | scalarNegOne
  · exact scalarNotOne scalarOne
  · have negOne : (-1 : F4) = 1 := by
      have negOneBase : (-1 : ZMod 2) = 1 := by decide
      simpa only [map_neg, map_one] using
        congrArg (algebraMap (ZMod 2) F4) negOneBase
    exact scalarNotOne (scalarNegOne.trans negOne)

/-- `PSL₂(F4)` is perfect. -/
theorem f4_projectiveSpecialLinearGroup_two_perfect :
    commutator PSL(2, F4) = ⊤ :=
  SL2Simple.PSL_commutator_eq_top f4_exists_nonzero_square_ne_one

/-- Every permutation in the five-point projective image is even. -/
theorem psl2F4ProjectiveAction_range_le_alternating :
    psl2F4ProjectiveAction.range ≤ alternatingGroup (Fin 5) := by
  let signAction : PSL(2, F4) →* ℤˣ :=
    Equiv.Perm.sign.comp psl2F4ProjectiveAction
  letI : Group.IsPerfect PSL(2, F4) :=
    ⟨f4_projectiveSpecialLinearGroup_two_perfect⟩
  have rangePerfect : Group.IsPerfect signAction.range :=
    Group.IsPerfect.range signAction
  letI : Group.IsPerfect signAction.range := rangePerfect
  have rangeSubsingleton : Subsingleton signAction.range := inferInstance
  rintro permutation ⟨matrix, rfl⟩
  change Equiv.Perm.sign (psl2F4ProjectiveAction matrix) = 1
  have inRange : signAction matrix ∈ signAction.range :=
    ⟨matrix, rfl⟩
  have equalsOne :
      (⟨signAction matrix, inRange⟩ : signAction.range) = 1 :=
    @Subsingleton.elim _ rangeSubsingleton _ _
  simpa [signAction] using congrArg Subtype.val equalsOne

/-- The five-point projective image is exactly the alternating group. -/
theorem psl2F4ProjectiveAction_range_eq_alternating :
    psl2F4ProjectiveAction.range = alternatingGroup (Fin 5) := by
  apply Subgroup.eq_of_le_of_card_ge psl2F4ProjectiveAction_range_le_alternating
  rw [alternatingGroup_fin_five_card]
  have rangeCard : Nat.card psl2F4ProjectiveAction.range = 60 := by
    rw [← Nat.card_congr
      (MonoidHom.ofInjective psl2F4ProjectiveAction_injective).toEquiv]
    exact f4_projectiveSpecialLinearGroup_two_card
  omega

/-- The faithful projective action gives the exceptional isomorphism
`PSL₂(F4) ≃ A5`. -/
def psl2F4EquivAlternatingFive :
    PSL(2, F4) ≃* alternatingGroup (Fin 5) :=
  MulEquiv.ofBijective
    (psl2F4ProjectiveAction.codRestrict
      (alternatingGroup (Fin 5))
      (fun matrix ↦ psl2F4ProjectiveAction_range_le_alternating ⟨matrix, rfl⟩))
    ⟨fun _ _ equality ↦
        psl2F4ProjectiveAction_injective (congrArg Subtype.val equality),
      fun permutation ↦ by
        have membership : (permutation : Equiv.Perm (Fin 5)) ∈
            psl2F4ProjectiveAction.range := by
          rw [psl2F4ProjectiveAction_range_eq_alternating]
          exact permutation.property
        obtain ⟨matrix, equality⟩ := membership
        exact ⟨matrix, Subtype.ext equality⟩⟩

/-- The exceptional abstract group isomorphism `SL₂(F4) ≃ A5`. -/
def specialLinearGroupF4EquivAlternatingFive :
    SL(2, F4) ≃* alternatingGroup (Fin 5) :=
  psl2F4EquivSpecialLinearGroup.symm.trans psl2F4EquivAlternatingFive

end

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
