import RelativeConicArcs.ClebschFirstFrobeniusSection
import RelativeConicArcs.ClebschOuterParityWeights

/-!
# The four-weight lift of an opposite-parity defect

An opposite-parity finite intertwiner has two weight components `φ₊` and `φ₋`.  Its
factored positive-root defect supplies a highest component `β`, and Weyl conjugation supplies
the lowest component `δ`.  These four vectors define a linear map from the first Frobenius
carrier with basis `A,C,B,D` by

`A ↦ -β`, `C ↦ φ₊`, `B ↦ -φ₋`, `D ↦ δ`.

The middle difference recovers the original finite intertwiner:
`Θ(C-B)=φ₊+φ₋`.  Consequently any construction of these four components is
injective once their sum is the original map.  This module proves the linear bridge; the root and
Weyl relations making `Θ` an algebraic-group intertwiner are supplied by the adjacent
four-weight action module and must be checked by a consuming representation module.
-/

namespace RelativeConicArcs.ClebschOuterParityInjection

open ClebschFirstFrobeniusSection

variable {k X O : Type*} [Field k] [AddCommGroup X] [Module k X]
  [AddCommGroup O] [Module k O]

/-- Linear map with prescribed images of the ordered first-Frobenius basis `A,C,B,D`. -/
def fourWeightLift (β φPlus φMinus δ : X) : Carrier k →ₗ[k] X where
  toFun := fun v ↦ v 0 • (-β) + v 1 • φPlus + v 2 • (-φMinus) + v 3 • δ
  map_add' x y := by
    simp only [Pi.add_apply, add_smul]
    abel
  map_smul' a x := by
    simp only [Pi.smul_apply, smul_add, smul_smul, RingHom.id_apply]
    module

@[simp] theorem fourWeightLift_A (β φPlus φMinus δ : X) :
    fourWeightLift β φPlus φMinus δ (A : Carrier k) = -β := by
  simp [fourWeightLift, A]

@[simp] theorem fourWeightLift_C (β φPlus φMinus δ : X) :
    fourWeightLift β φPlus φMinus δ (C : Carrier k) = φPlus := by
  simp [fourWeightLift, C]

@[simp] theorem fourWeightLift_B (β φPlus φMinus δ : X) :
    fourWeightLift β φPlus φMinus δ (B : Carrier k) = -φMinus := by
  simp [fourWeightLift, B]

@[simp] theorem fourWeightLift_D (β φPlus φMinus δ : X) :
    fourWeightLift β φPlus φMinus δ (D : Carrier k) = δ := by
  simp [fourWeightLift, D]

/-- Evaluation on `C-B` recovers the sum of the two opposite-parity weight components. -/
theorem fourWeightLift_middleDifference (β φPlus φMinus δ : X) :
    fourWeightLift β φPlus φMinus δ ((C : Carrier k) - B) = φPlus + φMinus := by
  rw [map_sub, fourWeightLift_C, fourWeightLift_B]
  simp

/-- A family of four-weight lifts is injective when evaluation on `C-B` recovers its input. -/
theorem fourWeightConstruction_injective
    (lift : O →ₗ[k] (Carrier k →ₗ[k] X)) (recover : O →ₗ[k] X)
    (hrecover : ∀ φ, lift φ ((C : Carrier k) - B) = recover φ)
    (hrecoverInjective : Function.Injective recover) :
    Function.Injective lift := by
  intro x y hxy
  apply hrecoverInjective
  rw [← hrecover, ← hrecover, hxy]

/-- In the common case where the recovered vector is the original opposite-parity map, the
four-weight construction is injective. -/
theorem fourWeightConstruction_injective_of_middleDifference
    (lift : X →ₗ[k] (Carrier k →ₗ[k] X))
    (hrecover : ∀ φ, lift φ ((C : Carrier k) - B) = φ) :
    Function.Injective lift :=
  fourWeightConstruction_injective lift LinearMap.id hrecover Function.injective_id

end RelativeConicArcs.ClebschOuterParityInjection
