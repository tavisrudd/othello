import RelativeConicArcs.AMELU.PartyPermutation

/-!
# Local-unitary to local-Clifford rigidity

For every party, choose an ordered four-set with that party first.
Reduced-matrix covariance gives the shortening-coordinate marginal
intertwining, and diagonal-tensor rigidity makes the first local factor
Clifford.  Hence every local factor in an LU equivalence between
equal-phase states of exact `[6,3,4]` codes is Clifford.  The allowed
party permutation is absorbed into the source code.

This is the six-party specialization of the headline LU-to-LC theorem
of the accompanying paper.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Every party can be placed first in an ordering of a four-party
subset. -/
theorem exists_orderedFourSet_first (i : Party) :
    ∃ (S : Finset Party) (_ : S.card = 4) (e : Fin 4 ≃ S),
      (e 0).1 = i := by
  classical
  have herase : (Finset.univ.erase i).card = 5 := by
    simp
  have hthree : 3 ≤ (Finset.univ.erase i).card := by
    omega
  obtain ⟨T, hTsub, hTcard⟩ :=
    Finset.exists_subset_card_eq
      (s := Finset.univ.erase i) (n := 3) hthree
  have hiT : i ∉ T := by
    intro hi
    have := hTsub hi
    simp at this
  let S := insert i T
  have hS : S.card = 4 := by
    simp [S, hiT, hTcard]
  have hiS : i ∈ S := by simp [S]
  let e₀ : Fin 4 ≃ S :=
    Fintype.equivOfCardEq (by
      rw [Fintype.card_fin, Fintype.card_coe, hS])
  let j : Fin 4 := e₀.symm ⟨i, hiS⟩
  let e : Fin 4 ≃ S := (Equiv.swap 0 j).trans e₀
  refine ⟨S, hS, e, ?_⟩
  change (e₀ (Equiv.swap 0 j 0)).1 = i
  by_cases hj : j = 0
  · subst j
    simp
  · rw [Equiv.swap_apply_left]
    rw [show e₀ j = ⟨i, hiS⟩ by
      exact e₀.apply_symm_apply ⟨i, hiS⟩]

/-- In a phase-normalized product action between equal-phase MDS code
states, every local unitary is Clifford. -/
theorem all_isClifford_of_localAction_equalPhaseState
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      localAction U (equalPhaseState C) =
        phase • equalPhaseState D) :
    ∀ i, IsCliffordMatrix w (U i) := by
  intro i
  obtain ⟨S, hS, e, he⟩ := exists_orderedFourSet_first i
  have hintertwine :=
    fourMarginalIntertwining_of_localAction_eq
      w hC hD U hU phase hphase hstate hS e
  have hcliff :=
    firstParty_isClifford_of_fourMarginalIntertwining
      w hC hD hS e U hU hintertwine
  simpa [he] using hcliff

/-- Six-party rigidity theorem: local-unitary equivalence between
equal-phase states of exact `[6,3,4]` codes is already local-Clifford
equivalence, with the same party permutation, local matrices, and
global phase. -/
theorem locallyUnitaryEquivalent_equalPhaseState_implies_locallyCliffordEquivalent
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    (hLU :
      LocallyUnitaryEquivalent
        (equalPhaseState C) (equalPhaseState D)) :
    LocallyCliffordEquivalent w
      (equalPhaseState C) (equalPhaseState D) := by
  obtain ⟨π, U, phase, hU, hphase, hstate⟩ := hLU
  let Cπ := permutedCode π C
  have hCπ : IsMDSCode634 Cπ :=
    isMDSCode634_permutedCode π hC
  have hstate' :
      localAction U (equalPhaseState Cπ) =
        phase • equalPhaseState D := by
    rw [← permuteState_equalPhaseState π C]
    exact hstate
  have hcliff :
      ∀ i, IsCliffordMatrix w (U i) :=
    all_isClifford_of_localAction_equalPhaseState
      w hCπ hD U hU phase hphase hstate'
  exact ⟨π, U, phase, hcliff, hphase, hstate⟩

end RelativeConicArcs.AMELU
