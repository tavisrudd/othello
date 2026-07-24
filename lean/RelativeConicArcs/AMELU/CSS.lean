import RelativeConicArcs.AMELU.Definitions

/-!
# CSS label spaces and supported stabilizers

For a linear code `C ≤ 𝔽⁶`, the equal-phase state uses the CSS Pauli-label
space

`L_C = (C ⊕ 0) + (0 ⊕ C⊥) = C × C⊥`.

A label is written `(c,h)`, where `c` is the translation (`X`) component
and `h` is the phase (`Z`) component.  Its support is the set of parties
where at least one component is nonzero.  The subspace
`cssSupportedLabelSpace C S` is the manuscript's `L_C(S)`.

These definitions use the standard bilinear dual `FiniteGeom.dualCode`.
They contain no computational discharge, generated data, axioms, or
admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Finset

/-- A six-party Pauli label, split into its `X` and `Z` components. -/
abbrev PauliLabel (𝔽 : Type*) := BasisLabel 𝔽 × BasisLabel 𝔽

/-- The CSS label space `C × C⊥` of the equal-phase state of `C`. -/
def cssLabelSpace [Field 𝔽] [Fintype 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) : Submodule 𝔽 (PauliLabel 𝔽) :=
  C.prod (FiniteGeom.dualCode C)

/-- The support of a Pauli label is the set of parties on which its `X`
or `Z` component is nonzero. -/
def pauliSupport [Zero 𝔽] [DecidableEq 𝔽] (v : PauliLabel 𝔽) : Finset Party :=
  Finset.univ.filter fun i => v.1 i ≠ 0 ∨ v.2 i ≠ 0

/-- A Pauli label is supported on `S` when both components vanish outside
`S`. -/
def PauliSupportedOn [Zero 𝔽] (S : Finset Party) (v : PauliLabel 𝔽) : Prop :=
  ∀ i, i ∉ S → v.1 i = 0 ∧ v.2 i = 0

/-- The supported CSS label space
`L_C(S) = {v ∈ C × Cᵖ : supp(v) ⊆ S}`. -/
def cssSupportedLabelSpace [Field 𝔽] [Fintype 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (S : Finset Party) :
    Submodule 𝔽 (PauliLabel 𝔽) where
  carrier := {v | v ∈ cssLabelSpace C ∧ PauliSupportedOn S v}
  zero_mem' := by
    constructor
    · exact (cssLabelSpace C).zero_mem
    · intro i hi
      exact ⟨rfl, rfl⟩
  add_mem' := by
    rintro a b ⟨ha, haS⟩ ⟨hb, hbS⟩
    constructor
    · exact (cssLabelSpace C).add_mem ha hb
    · intro i hi
      obtain ⟨haX, haZ⟩ := haS i hi
      obtain ⟨hbX, hbZ⟩ := hbS i hi
      simp [haX, haZ, hbX, hbZ]
  smul_mem' := by
    rintro a v ⟨hv, hvS⟩
    constructor
    · exact (cssLabelSpace C).smul_mem a hv
    · intro i hi
      obtain ⟨hvX, hvZ⟩ := hvS i hi
      simp [hvX, hvZ]

@[simp]
theorem mem_cssLabelSpace [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)} {v : PauliLabel 𝔽} :
    v ∈ cssLabelSpace C ↔ v.1 ∈ C ∧ v.2 ∈ FiniteGeom.dualCode C :=
  Iff.rfl

@[simp]
theorem mem_cssSupportedLabelSpace [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)} {S : Finset Party} {v : PauliLabel 𝔽} :
    v ∈ cssSupportedLabelSpace C S ↔
      v.1 ∈ C ∧ v.2 ∈ FiniteGeom.dualCode C ∧ PauliSupportedOn S v := by
  change (v ∈ cssLabelSpace C ∧ PauliSupportedOn S v) ↔ _
  rw [mem_cssLabelSpace]
  tauto

theorem pauliSupport_subset_iff [Zero 𝔽] [DecidableEq 𝔽] {S : Finset Party}
    {v : PauliLabel 𝔽} :
    pauliSupport v ⊆ S ↔ PauliSupportedOn S v := by
  constructor
  · intro h i hi
    have hv : ¬(v.1 i ≠ 0 ∨ v.2 i ≠ 0) := by
      intro hv
      exact hi (h (Finset.mem_filter.mpr ⟨Finset.mem_univ i, hv⟩))
    exact ⟨not_ne_iff.mp (not_or.mp hv).1, not_ne_iff.mp (not_or.mp hv).2⟩
  · intro h i hi
    by_contra hiS
    obtain ⟨hX, hZ⟩ := h i hiS
    have hv := (Finset.mem_filter.mp hi).2
    simp [hX, hZ] at hv

end RelativeConicArcs.AMELU
