import RelativeConicArcs.AMELU.FourMarginalIntertwining
import Mathlib.Data.Fintype.EquivFin

/-!
# Party permutations of six-coordinate codes

The party permutation allowed in local equivalence transports a linear
code by the corresponding coordinate linear equivalence.  Dimension,
Hamming weight, and the equal-phase state are preserved.  Thus the
permutation can be absorbed into the source MDS code before applying the
four-party rigidity argument.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Coordinate permutation as a linear equivalence of six-party
labels. -/
def permuteLabelLinearEquiv (π : Equiv.Perm Party) :
    BasisLabel 𝔽 ≃ₗ[𝔽] BasisLabel 𝔽 where
  toFun := permuteLabel π
  invFun := permuteLabel π.symm
  left_inv x := by
    funext i
    simp [permuteLabel]
  right_inv x := by
    funext i
    simp [permuteLabel]
  map_add' x y := rfl
  map_smul' a x := rfl

/-- Image of a code under a party permutation. -/
def permutedCode (π : Equiv.Perm Party)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    Submodule 𝔽 (BasisLabel 𝔽) :=
  C.map (permuteLabelLinearEquiv π).toLinearMap

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Membership in a permuted code is membership of the inverse-permuted
label in the original code. -/
theorem mem_permutedCode_iff
    (π : Equiv.Perm Party) (C : Submodule 𝔽 (BasisLabel 𝔽))
    (x : BasisLabel 𝔽) :
    x ∈ permutedCode π C ↔ permuteLabel π.symm x ∈ C := by
  constructor
  · rintro ⟨y, hy, rfl⟩
    change permuteLabel π.symm (permuteLabel π y) ∈ C
    have heq : permuteLabel π.symm (permuteLabel π y) = y := by
      funext i
      simp [permuteLabel]
    rw [heq]
    exact hy
  · intro hx
    refine ⟨permuteLabel π.symm x, hx, ?_⟩
    funext i
    simp [permuteLabelLinearEquiv, permuteLabel]

omit [Fintype 𝔽] in
/-- Party permutations preserve Hamming weight. -/
theorem hammingNorm_permuteLabel
    (π : Equiv.Perm Party) (x : BasisLabel 𝔽) :
    hammingNorm (permuteLabel π x) = hammingNorm x := by
  classical
  change
    (Finset.univ.filter fun i => x (π.symm i) ≠ 0).card =
      (Finset.univ.filter fun i => x i ≠ 0).card
  let e :
      {i : Party // x (π.symm i) ≠ 0} ≃
        {i : Party // x i ≠ 0} :=
    { toFun := fun i => ⟨π.symm i.1, i.2⟩
      invFun := fun i => ⟨π i.1, by simpa using i.2⟩
      left_inv := fun i => by
        apply Subtype.ext
        simp
      right_inv := fun i => by
        apply Subtype.ext
        simp }
  calc
    (Finset.univ.filter fun i => x (π.symm i) ≠ 0).card =
        Fintype.card {i : Party // x (π.symm i) ≠ 0} := by
          symm
          exact Fintype.card_subtype fun i : Party =>
            x (π.symm i) ≠ 0
    _ = Fintype.card {i : Party // x i ≠ 0} :=
      Fintype.card_congr e
    _ = (Finset.univ.filter fun i => x i ≠ 0).card :=
      Fintype.card_subtype fun i : Party => x i ≠ 0

/-- A party permutation of an exact `[6,3,4]` code is again exact
`[6,3,4]`. -/
theorem isMDSCode634_permutedCode
    (π : Equiv.Perm Party)
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C) :
    IsMDSCode634 (permutedCode π C) := by
  constructor
  · rw [permutedCode]
    exact (LinearEquiv.finrank_map_eq
      (permuteLabelLinearEquiv π) C).trans hC.1
  · apply le_antisymm
    · have hsingleton := FiniteGeom.singleton_bound (permutedCode π C)
      rw [show Module.finrank 𝔽 (permutedCode π C) = 3 by
        rw [permutedCode]
        exact (LinearEquiv.finrank_map_eq
          (permuteLabelLinearEquiv π) C).trans hC.1] at hsingleton
      omega
    · apply FiniteGeom.le_minDist
      · intro hbot
        have hfin : Module.finrank 𝔽 (permutedCode π C) = 3 := by
          rw [permutedCode]
          exact (LinearEquiv.finrank_map_eq
            (permuteLabelLinearEquiv π) C).trans hC.1
        rw [hbot] at hfin
        simp at hfin
      · intro x hx hx0
        let y := permuteLabel π.symm x
        have hy : y ∈ C := (mem_permutedCode_iff π C x).1 hx
        have hy0 : y ≠ 0 := by
          intro hzero
          apply hx0
          funext i
          have hi := congrFun hzero (π.symm i)
          simpa [y, permuteLabel] using hi
        have hweight := FiniteGeom.minDist_le_hammingNorm hy hy0
        rw [hC.2] at hweight
        rw [show hammingNorm y = hammingNorm x by
          exact hammingNorm_permuteLabel π.symm x] at hweight
        exact hweight

/-- Permuting an equal-phase code state is the equal-phase state of the
permuted code. -/
theorem permuteState_equalPhaseState
    (π : Equiv.Perm Party)
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    permuteState π (equalPhaseState C) =
      equalPhaseState (permutedCode π C) := by
  funext x
  unfold permuteState
  by_cases hx : permuteLabel π.symm x ∈ C
  · rw [equalPhaseState_apply_of_mem hx,
      equalPhaseState_apply_of_mem
        ((mem_permutedCode_iff π C x).2 hx)]
  · rw [equalPhaseState_apply_of_not_mem hx,
      equalPhaseState_apply_of_not_mem
        (fun h => hx ((mem_permutedCode_iff π C x).1 h))]

end RelativeConicArcs.AMELU
