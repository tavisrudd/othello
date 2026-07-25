import RelativeConicArcs.AMELU.Definitions

/-!
# Length-generic MDS--CSS state conventions

This module factors the six-party state and local-action conventions through
an arbitrary even number `2 * m` of parties.  At `m = 3` the generic labels,
states, equal-phase state, party action, and LU/LC relations reduce
definitionally to the established six-party API.

All definitions are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped BigOperators ComplexConjugate

/-- The parties of a length-`2m` code. -/
abbrev GenericParty (m : ℕ) := Fin (2 * m)

/-- A computational-basis label on `2m` parties. -/
abbrev GenericBasisLabel (m : ℕ) (𝔽 : Type*) := GenericParty m → 𝔽

/-- A pure state on `2m` parties, represented by its amplitudes. -/
abbrev GenericState (m : ℕ) (𝔽 : Type*) := GenericBasisLabel m 𝔽 → ℂ

/-- The positive normalization `|𝔽|^{-m/2}` for a dimension-`m` code. -/
noncomputable def genericCodeStateNormalization
    (m : ℕ) (𝔽 : Type*) [Fintype 𝔽] : ℂ :=
  ((Real.sqrt ((Fintype.card 𝔽 : ℝ) ^ m))⁻¹ : ℝ)

/-- The normalized equal-phase state of a length-`2m`, dimension-`m`
linear code. -/
noncomputable def genericEqualPhaseState
    {m : ℕ} {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) :
    GenericState m 𝔽 :=
  by
    classical
    exact fun x =>
      if x ∈ C then genericCodeStateNormalization m 𝔽 else 0

/-- Left action of a permutation of the `2m` parties on basis labels. -/
def genericPermuteLabel {m : ℕ} {𝔽 : Type*}
    (π : Equiv.Perm (GenericParty m))
    (x : GenericBasisLabel m 𝔽) : GenericBasisLabel m 𝔽 :=
  fun i => x (π.symm i)

/-- The induced action of a party permutation on state amplitudes. -/
def genericPermuteState {m : ℕ} {𝔽 : Type*}
    (π : Equiv.Perm (GenericParty m)) (ψ : GenericState m 𝔽) :
    GenericState m 𝔽 :=
  fun x => ψ (genericPermuteLabel π.symm x)

/-- Tensor-product action of `2m` single-party matrices. -/
noncomputable def genericLocalAction
    {m : ℕ} {𝔽 : Type*} [Fintype 𝔽]
    (U : GenericParty m → LocalMatrix 𝔽) (ψ : GenericState m 𝔽) :
    GenericState m 𝔽 :=
  fun y => ∑ x, (∏ i, U i (y i) (x i)) * ψ x

/-- Length-generic local-unitary equivalence, with party permutations and a
global phase in the same orientation as the six-party definition. -/
def GenericLocallyUnitaryEquivalent
    {m : ℕ} {𝔽 : Type*} [Fintype 𝔽] [DecidableEq 𝔽]
    (ψ φ : GenericState m 𝔽) : Prop :=
  ∃ (π : Equiv.Perm (GenericParty m))
      (U : GenericParty m → LocalMatrix 𝔽) (phase : ℂ),
    (∀ i, IsUnitaryMatrix (U i)) ∧
      Complex.normSq phase = 1 ∧
      genericLocalAction U (genericPermuteState π ψ) = phase • φ

/-- Length-generic local-Clifford equivalence in the same action
orientation as `GenericLocallyUnitaryEquivalent`. -/
def GenericLocallyCliffordEquivalent
    {m : ℕ} {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) (ψ φ : GenericState m 𝔽) : Prop :=
  ∃ (π : Equiv.Perm (GenericParty m))
      (U : GenericParty m → LocalMatrix 𝔽) (phase : ℂ),
    (∀ i, IsCliffordMatrix w (U i)) ∧
      Complex.normSq phase = 1 ∧
      genericLocalAction U (genericPermuteState π ψ) = phase • φ

/-- At `m = 3`, the generic equal-phase state is the established
six-party equal-phase state. -/
theorem genericEqualPhaseState_three
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) :
    genericEqualPhaseState (m := 3) C = equalPhaseState C := by
  unfold genericEqualPhaseState equalPhaseState
  unfold genericCodeStateNormalization codeStateNormalization
  rfl

/-- At `m = 3`, the generic local action is the established six-party
local action. -/
theorem genericLocalAction_three
    {𝔽 : Type*} [Fintype 𝔽]
    (U : Party → LocalMatrix 𝔽) (ψ : State 𝔽) :
    genericLocalAction (m := 3) U ψ = localAction U ψ := by
  rfl

/-- At `m = 3`, generic LU equivalence is the established six-party
relation. -/
theorem genericLocallyUnitaryEquivalent_three
    {𝔽 : Type*} [Fintype 𝔽] [DecidableEq 𝔽] (ψ φ : State 𝔽) :
    GenericLocallyUnitaryEquivalent (m := 3) ψ φ ↔
      LocallyUnitaryEquivalent ψ φ := by
  rfl

/-- At `m = 3`, generic LC equivalence is the established six-party
relation. -/
theorem genericLocallyCliffordEquivalent_three
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (w : WeylConvention 𝔽) (ψ φ : State 𝔽) :
    GenericLocallyCliffordEquivalent (m := 3) w ψ φ ↔
      LocallyCliffordEquivalent w ψ φ := by
  rfl

end RelativeConicArcs.AMELU
