import RelativeConicArcs.AMELU.GenericMarginal

/-!
# Party permutations of length-generic code states

A permutation of the `2m` coordinates acts linearly on labels and carries a
linear code to its image.  It preserves dimension, Hamming weight, the exact
MDS parameters, and the normalized equal-phase state.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Coordinate permutation as a linear equivalence on length-`2m` labels. -/
def genericPermuteLabelLinearEquiv (π : Equiv.Perm (GenericParty m)) :
    GenericBasisLabel m 𝔽 ≃ₗ[𝔽] GenericBasisLabel m 𝔽 where
  toFun := genericPermuteLabel π
  invFun := genericPermuteLabel π.symm
  left_inv x := by
    funext i
    simp [genericPermuteLabel]
  right_inv x := by
    funext i
    simp [genericPermuteLabel]
  map_add' x y := rfl
  map_smul' a x := rfl

/-- Image of a length-`2m` code under a party permutation. -/
def genericPermutedCode (π : Equiv.Perm (GenericParty m))
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    Submodule 𝔽 (GenericBasisLabel m 𝔽) :=
  C.map (genericPermuteLabelLinearEquiv π).toLinearMap

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Membership in a permuted generic code is membership of the
inverse-permuted label in the original code. -/
theorem mem_genericPermutedCode_iff
    (π : Equiv.Perm (GenericParty m))
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (x : GenericBasisLabel m 𝔽) :
    x ∈ genericPermutedCode π C ↔ genericPermuteLabel π.symm x ∈ C := by
  constructor
  · rintro ⟨y, hy, rfl⟩
    change genericPermuteLabel π.symm (genericPermuteLabel π y) ∈ C
    have heq :
        genericPermuteLabel π.symm (genericPermuteLabel π y) = y := by
      funext i
      simp [genericPermuteLabel]
    rw [heq]
    exact hy
  · intro hx
    refine ⟨genericPermuteLabel π.symm x, hx, ?_⟩
    funext i
    simp [genericPermuteLabelLinearEquiv, genericPermuteLabel]

omit [Fintype 𝔽] in
/-- Party permutations preserve the Hamming weight of generic labels. -/
theorem hammingNorm_genericPermuteLabel
    (π : Equiv.Perm (GenericParty m)) (x : GenericBasisLabel m 𝔽) :
    hammingNorm (genericPermuteLabel π x) = hammingNorm x := by
  classical
  change
    (Finset.univ.filter fun i => x (π.symm i) ≠ 0).card =
      (Finset.univ.filter fun i => x i ≠ 0).card
  let e :
      {i : GenericParty m // x (π.symm i) ≠ 0} ≃
        {i : GenericParty m // x i ≠ 0} :=
    { toFun := fun i => ⟨π.symm i.1, i.2⟩
      invFun := fun i => ⟨π i.1, by simpa using i.2⟩
      left_inv := fun i => by
        apply Subtype.ext
        simp
      right_inv := fun i => by
        apply Subtype.ext
        simp }
  calc
    _ = Fintype.card {i : GenericParty m // x (π.symm i) ≠ 0} := by
      symm
      exact Fintype.card_subtype fun i : GenericParty m =>
        x (π.symm i) ≠ 0
    _ = Fintype.card {i : GenericParty m // x i ≠ 0} :=
      Fintype.card_congr e
    _ = _ := Fintype.card_subtype fun i : GenericParty m => x i ≠ 0

omit [Fintype 𝔽] in
/-- A party permutation preserves the exact `[2m,m,m+1]` MDS parameters. -/
theorem isMDSCode2m_genericPermutedCode
    (π : Equiv.Perm (GenericParty m))
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)} (hC : IsMDSCode2m C) :
    IsMDSCode2m (genericPermutedCode π C) := by
  constructor
  · rw [genericPermutedCode]
    exact (LinearEquiv.finrank_map_eq
      (genericPermuteLabelLinearEquiv π) C).trans hC.1
  · apply le_antisymm
    · have hsingleton := FiniteGeom.singleton_bound (genericPermutedCode π C)
      rw [show Module.finrank 𝔽 (genericPermutedCode π C) = m by
        rw [genericPermutedCode]
        exact (LinearEquiv.finrank_map_eq
          (genericPermuteLabelLinearEquiv π) C).trans hC.1] at hsingleton
      omega
    · apply FiniteGeom.le_minDist
      · have hCne : C ≠ ⊥ := by
          intro hbot
          have hdist := hC.2
          rw [hbot] at hdist
          simp [FiniteGeom.minDist] at hdist
        obtain ⟨c, hc, hc0⟩ := (Submodule.ne_bot_iff C).mp hCne
        apply (Submodule.ne_bot_iff (genericPermutedCode π C)).mpr
        refine
          ⟨genericPermuteLabelLinearEquiv π c,
            ⟨c, hc, rfl⟩, ?_⟩
        intro hzero
        apply hc0
        exact (genericPermuteLabelLinearEquiv π).injective
          (by simpa using hzero)
      · intro x hx hx0
        let y := genericPermuteLabel π.symm x
        have hy : y ∈ C := (mem_genericPermutedCode_iff π C x).1 hx
        have hy0 : y ≠ 0 := by
          intro hzero
          apply hx0
          funext i
          have hi := congrFun hzero (π.symm i)
          simpa [y, genericPermuteLabel] using hi
        have hweight := FiniteGeom.minDist_le_hammingNorm hy hy0
        rw [hC.2] at hweight
        rw [show hammingNorm y = hammingNorm x by
          exact hammingNorm_genericPermuteLabel π.symm x] at hweight
        exact hweight

/-- Permuting a generic equal-phase state is the equal-phase state of the
permuted code. -/
theorem genericPermuteState_equalPhaseState
    (π : Equiv.Perm (GenericParty m))
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    genericPermuteState π (genericEqualPhaseState C) =
      genericEqualPhaseState (genericPermutedCode π C) := by
  funext x
  unfold genericPermuteState
  by_cases hx : genericPermuteLabel π.symm x ∈ C
  · simp [genericEqualPhaseState, hx,
      (mem_genericPermutedCode_iff π C x).2 hx]
  · have hx' : x ∉ genericPermutedCode π C :=
      fun h => hx ((mem_genericPermutedCode_iff π C x).1 h)
    simp [genericEqualPhaseState, hx, hx']

end RelativeConicArcs.AMELU
