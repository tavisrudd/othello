import RelativeConicArcs.MarkedClebschBridge
import Mathlib.GroupTheory.SpecificGroups.Alternating
import Mathlib.GroupTheory.SpecificGroups.Dihedral
import Mathlib.GroupTheory.Coset.Card
import Mathlib.GroupTheory.DoubleCoset

/-!
# The antipodal A5 cover and its five-valent orbitals

We use the affine five-letter model of `A₅`.  Its translations form `C₅`,
and translations together with affine reflections form `D₅`.  The finite
twelve-point model below is an explicit transversal for `A₅/C₅`; forgetting
the Boolean orientation is the corresponding `A₅/C₅ → A₅/D₅` cover.
The two orbitals are defined by the two inverse-stable `C₅` double cosets.
-/

namespace RelativeConicArcs.SupportOrientationCover

open Equiv Equiv.Perm

abbrev Letter := ZMod 5
abbrev A5 := ↑(alternatingGroup Letter)

private instance : Fact (Nat.Prime 5) := ⟨by decide⟩

def rotation (i : Letter) : Equiv.Perm Letter where
  toFun x := x - i
  invFun x := x + i
  left_inv x := by simp
  right_inv x := by simp

def reflection (i : Letter) : Equiv.Perm Letter where
  toFun x := i - x
  invFun x := i - x
  left_inv x := by simp
  right_inv x := by simp

theorem rotation_mem_alternating (i : Letter) :
    rotation i ∈ alternatingGroup Letter := by
  rw [mem_alternatingGroup]
  fin_cases i <;> decide

theorem reflection_mem_alternating (i : Letter) :
    reflection i ∈ alternatingGroup Letter := by
  rw [mem_alternatingGroup]
  fin_cases i <;> decide

def rotationA5 (i : Letter) : A5 := ⟨rotation i, rotation_mem_alternating i⟩
def reflectionA5 (i : Letter) : A5 := ⟨reflection i, reflection_mem_alternating i⟩

@[simp] theorem rotationA5_mul (i j : Letter) :
    rotationA5 i * rotationA5 j = rotationA5 (i + j) := by
  apply Subtype.ext
  ext x
  simp [rotationA5, rotation]
  ring

@[simp] theorem rotationA5_inv (i : Letter) :
    (rotationA5 i)⁻¹ = rotationA5 (-i) := by
  apply Subtype.ext
  ext x
  simp [rotationA5, rotation]

/-- The five rotations, as an actual subgroup of `A₅`. -/
def C5 : Subgroup A5 where
  carrier := Set.range rotationA5
  one_mem' := ⟨0, by apply Subtype.ext; ext x; simp [rotationA5, rotation]⟩
  mul_mem' := by
    rintro _ _ ⟨i, rfl⟩ ⟨j, rfl⟩
    exact ⟨i + j, (rotationA5_mul i j).symm⟩
  inv_mem' := by
    rintro _ ⟨i, rfl⟩
    exact ⟨-i, (rotationA5_inv i).symm⟩

/-- The ten affine rotations/reflections. -/
def affineElement : Letter ⊕ Letter → A5
  | .inl i => rotationA5 i
  | .inr i => reflectionA5 i

/-- The ten affine rotations/reflections, as an actual subgroup of `A₅`. -/
def D5 : Subgroup A5 where
  carrier := Set.range affineElement
  one_mem' := ⟨Sum.inl 0, by apply Subtype.ext; ext x; simp [affineElement, rotationA5, rotation]⟩
  mul_mem' := by
    rintro _ _ ⟨i, rfl⟩ ⟨j, rfl⟩
    cases i with
    | inl i => cases j with
      | inl j => exact ⟨Sum.inl (i + j), (rotationA5_mul i j).symm⟩
      | inr j => exact ⟨Sum.inr (j - i), by
        apply Subtype.ext; ext x
        simp [affineElement, rotationA5, reflectionA5, rotation, reflection]
        ring⟩
    | inr i => cases j with
      | inl j => exact ⟨Sum.inr (i + j), by
        apply Subtype.ext; ext x
        simp [affineElement, rotationA5, reflectionA5, rotation, reflection]
        ring⟩
      | inr j => exact ⟨Sum.inl (j - i), by
        apply Subtype.ext; ext x
        simp [affineElement, rotationA5, reflectionA5, rotation, reflection]
        ring⟩
  inv_mem' := by
    rintro _ ⟨i, rfl⟩
    cases i with
    | inl i => exact ⟨Sum.inl (-i), (rotationA5_inv i).symm⟩
    | inr i => exact ⟨Sum.inr i, by
        apply Subtype.ext; ext x; simp [affineElement, reflectionA5, reflection]⟩

theorem C5_le_D5 : C5 ≤ D5 := fun _ ⟨i, hi⟩ ↦ ⟨Sum.inl i, hi⟩

private theorem rotationA5_injective : Function.Injective rotationA5 := by
  decide

private theorem affineElement_injective : Function.Injective affineElement := by
  decide

noncomputable instance : Fintype C5 :=
  Fintype.ofEquiv Letter (Equiv.ofInjective rotationA5 rotationA5_injective)

noncomputable instance : Fintype D5 :=
  Fintype.ofEquiv (Letter ⊕ Letter)
    (Equiv.ofInjective affineElement affineElement_injective)

@[simp] theorem card_C5 : Fintype.card C5 = 5 := by
  let e : Letter ≃ C5 := Equiv.ofInjective rotationA5 rotationA5_injective
  calc
    Fintype.card C5 = Fintype.card Letter := (Fintype.card_congr e).symm
    _ = 5 := by decide

@[simp] theorem card_D5 : Fintype.card D5 = 10 := by
  let e : Letter ⊕ Letter ≃ D5 :=
    Equiv.ofInjective affineElement affineElement_injective
  calc
    Fintype.card D5 = Fintype.card (Letter ⊕ Letter) := (Fintype.card_congr e).symm
    _ = 10 := by decide

noncomputable local instance : DecidableRel (QuotientGroup.leftRel C5).r :=
  Classical.decRel _
noncomputable local instance : DecidableRel (QuotientGroup.leftRel D5).r :=
  Classical.decRel _
noncomputable local instance :
    DecidableRel (QuotientGroup.leftRel (C5.subgroupOf D5)).r :=
  Classical.decRel _

abbrev OrientedCoset := A5 ⧸ C5
abbrev AxisCoset := A5 ⧸ D5

noncomputable local instance : DecidableEq OrientedCoset := Classical.decEq _
noncomputable local instance : DecidableEq AxisCoset := Classical.decEq _

/-- The genuine homogeneous-space quotient map. -/
def antipodalCosetCover : OrientedCoset → AxisCoset :=
  Subgroup.quotientMapOfLE C5_le_D5

private theorem quotientEquivProd_fst (x : OrientedCoset) :
    (C5.quotientEquivProdOfLE C5_le_D5 x).1 = antipodalCosetCover x := by
  induction x using Quotient.inductionOn'
  rfl

private theorem card_dihedral_rotationQuotient :
    Fintype.card (D5 ⧸ C5.subgroupOf D5) = 2 := by
  classical
  have h := Subgroup.card_eq_card_quotient_mul_card_subgroup
    (C5.subgroupOf D5)
  have hsub : Fintype.card (C5.subgroupOf D5) = 5 := by
    rw [Fintype.card_congr (Subgroup.subgroupOfEquivOfLe C5_le_D5).toEquiv,
      card_C5]
  rw [Nat.card_eq_fintype_card, Nat.card_eq_fintype_card,
    Nat.card_eq_fintype_card, card_D5, hsub] at h
  omega

/-- Every fibre of the genuine `A₅/C₅ → A₅/D₅` homogeneous quotient
map has two elements. -/
theorem antipodalCosetCover_fiber_card_two (axis : AxisCoset) :
    Fintype.card {x : OrientedCoset // antipodalCosetCover x = axis} = 2 := by
  classical
  let e := C5.quotientEquivProdOfLE C5_le_D5
  let fiberEquiv :
      {x : OrientedCoset // antipodalCosetCover x = axis} ≃
        D5 ⧸ C5.subgroupOf D5 :=
    { toFun := fun x ↦ (e x.1).2
      invFun := fun z ↦ ⟨e.symm (axis, z), by
        change (e (e.symm (axis, z))).1 = axis
        simp⟩
      left_inv := fun x ↦ by
        apply Subtype.ext
        apply e.injective
        simp only [Equiv.apply_symm_apply]
        apply Prod.ext
        · change axis = (C5.quotientEquivProdOfLE C5_le_D5 x.1).1
          rw [quotientEquivProd_fst]
          exact x.2.symm
        · rfl
      right_inv := fun z ↦ by simp }
  calc
    _ = Fintype.card (D5 ⧸ C5.subgroupOf D5) := Fintype.card_congr fiberEquiv
    _ = 2 := card_dihedral_rotationQuotient

/-- Concrete labels for the twelve cosets and six axes. -/
abbrev OrientedSupport := Fin 6 × Bool
abbrev SupportAxis := Fin 6

def forgetOrientation (x : OrientedSupport) : SupportAxis := x.1
def deck (x : OrientedSupport) : OrientedSupport := (x.1, !x.2)

@[simp] theorem antipodalQuotient_fiber_card_two (axis : SupportAxis) :
    (Finset.univ.filter fun x : OrientedSupport ↦ forgetOrientation x = axis).card = 2 := by
  decide +revert

def firstOrbitalRepresentative : A5 :=
  ⟨Equiv.swap (2 : Letter) 3 * Equiv.swap 3 4,
    mul_mem_alternatingGroup_of_isSwap (swap_isSwap_iff.mpr (by decide))
      (swap_isSwap_iff.mpr (by decide))⟩

def secondOrbitalRepresentative : A5 :=
  ⟨Equiv.swap (1 : Letter) 2 * Equiv.swap 3 4,
    mul_mem_alternatingGroup_of_isSwap (swap_isSwap_iff.mpr (by decide))
      (swap_isSwap_iff.mpr (by decide))⟩

def rotationDoubleCoset (g : A5) : Finset A5 :=
  Finset.univ.image fun ij : Letter × Letter ↦
    rotationA5 ij.1 * g * rotationA5 ij.2

inductive FiveOrbital
  | first
  | second
  deriving DecidableEq, Fintype

def FiveOrbital.representative : FiveOrbital → A5
  | .first => firstOrbitalRepresentative
  | .second => secondOrbitalRepresentative

def FiveOrbital.elements : FiveOrbital → Finset A5
  | .first => rotationDoubleCoset firstOrbitalRepresentative
  | .second => rotationDoubleCoset secondOrbitalRepresentative

@[simp] theorem fiveOrbitalElements_card (orbital : FiveOrbital) :
    orbital.elements.card = 25 := by
  decide +revert

/-- Both nontrivial `C₅` double cosets are inverse-stable. -/
theorem FiveOrbital.inverse_closed (orbital : FiveOrbital) {g : A5}
    (hg : g ∈ orbital.elements) : g⁻¹ ∈ orbital.elements := by
  decide +revert

/-- Representatives for the six unoriented axes. -/
def axisRepresentative : Fin 6 → A5 :=
  Fin.cases 1 fun i : Fin 5 ↦
    rotationA5 (i.val : Letter) * firstOrbitalRepresentative

/-- A fixed transversal of the twelve oriented cosets.  The six first-sheet
representatives are the base coset and the five regular `C₅` translates of
the first double-coset representative; reflection switches the sheet. -/
def supportRepresentative (x : OrientedSupport) : A5 :=
  if x.2 then axisRepresentative x.1 * reflectionA5 0
  else axisRepresentative x.1

/-- The homogeneous double-coset orbital relation on the explicit transversal. -/
def InFiveOrbital (orbital : FiveOrbital) (x y : OrientedSupport) : Prop :=
  (supportRepresentative x)⁻¹ * supportRepresentative y ∈ orbital.elements

instance (orbital : FiveOrbital) (x y : OrientedSupport) :
    Decidable (InFiveOrbital orbital x y) := by
  unfold InFiveOrbital
  infer_instance

def fiveOrbitalNeighbors (orbital : FiveOrbital)
    (x : OrientedSupport) : Finset OrientedSupport :=
  Finset.univ.filter (InFiveOrbital orbital x)

theorem fiveOrbitals_selfPaired (orbital : FiveOrbital) (x y : OrientedSupport) :
    InFiveOrbital orbital x y ↔ InFiveOrbital orbital y x := by
  constructor
  · intro h
    have hinv := orbital.inverse_closed h
    simpa [InFiveOrbital, mul_inv_rev] using hinv
  · intro h
    have hinv := orbital.inverse_closed h
    simpa [InFiveOrbital, mul_inv_rev] using hinv

@[simp] theorem fiveOrbitals_card_five (orbital : FiveOrbital) (x : OrientedSupport) :
    (fiveOrbitalNeighbors orbital x).card = 5 := by
  decide +revert

/-- Regularity of the `C₅` action: each orbital contains one lift over every
axis other than the base axis. -/
theorem fiveOrbital_one_mem_each_other_fiber (orbital : FiveOrbital)
    (x : OrientedSupport) (axis : SupportAxis)
    (haxis_ne : axis ≠ forgetOrientation x) :
    ((fiveOrbitalNeighbors orbital x).filter fun y ↦
      forgetOrientation y = axis).card = 1 := by
  decide +revert

#print axioms antipodalQuotient_fiber_card_two
#print axioms antipodalCosetCover_fiber_card_two
#print axioms fiveOrbitalElements_card
#print axioms FiveOrbital.inverse_closed
#print axioms fiveOrbitals_selfPaired
#print axioms fiveOrbitals_card_five
#print axioms fiveOrbital_one_mem_each_other_fiber

end RelativeConicArcs.SupportOrientationCover
