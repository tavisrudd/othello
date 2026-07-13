import RepairCodes.CodeInstance

/-!
# The outer dual of an ordinary concatenation, without trace coordinates

The bounded-repair transfer proof needs one structural fact: if a block vector `w` annihilates
the concatenated code, then its vector of block coefficients belongs to the outer dual.  Earlier
project notes attributed this to a "Chen–Ling–Xing dual decomposition," but the citation audit
could not locate such a source.  No imported theorem is needed.

Work coordinate-free over the base field `𝔽`.  For an outer symbol space `V`, a block coefficient
is canonically an element of `Module.Dual 𝔽 V`.  Accordingly, `functionalDual O` is the annihilator
of an outer code `O ≤ (ι → V)` under the evaluation pairing

`(β,u) ↦ ∑ j, β j (u j)`.

If `e : V ≃ₗ[𝔽] I` is the inner encoder, `IsOrthogonalToConcatenation O e w` says precisely that
`w` annihilates every concatenated word block-by-block.  The theorem
`blockFunctional_mem_functionalDual` then proves directly that
`j ↦ blockFunctional I e (w j)` belongs to `functionalDual O`.  Combining this with a declared
lower bound on nonzero functional-dual weights gives the exact `houter` alternative consumed by
`ConcatDualWord`.

All content is finite linear algebra; there are no imported axioms or trace-form assumptions.
-/

namespace RepairCodes

open Finset FiniteGeom
open scoped BigOperators

noncomputable section

variable {ι V : Type*} [Fintype ι]
variable {κ : Type*} [Fintype κ]
variable {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V]

/-- The coordinate-free outer dual: vectors of linear functionals annihilating every outer
codeword under the summed evaluation pairing. -/
def functionalDual (O : Submodule 𝔽 (ι → V)) :
    Submodule 𝔽 (ι → Module.Dual 𝔽 V) where
  carrier := {beta | ∀ u ∈ O, ∑ j, beta j (u j) = 0}
  zero_mem' := by simp
  add_mem' := by
    intro beta gamma hbeta hgamma u hu
    simp only [Pi.add_apply, LinearMap.add_apply, Finset.sum_add_distrib, hbeta u hu, hgamma u hu,
      add_zero]
  smul_mem' := by
    intro c beta hbeta u hu
    simp only [Pi.smul_apply, LinearMap.smul_apply]
    rw [← Finset.smul_sum, hbeta u hu, smul_zero]

omit [DecidableEq 𝔽] in
@[simp]
theorem mem_functionalDual {O : Submodule 𝔽 (ι → V)}
    {beta : ι → Module.Dual 𝔽 V} :
    beta ∈ functionalDual O ↔ ∀ u ∈ O, ∑ j, beta j (u j) = 0 := Iff.rfl

/-- Hamming weight in the functional alphabet. Kept as an explicit noncomputable definition so
generic statements do not require a global `DecidableEq (Module.Dual 𝔽 V)` instance. -/
noncomputable def functionalWeight (beta : ι → Module.Dual 𝔽 V) : ℕ := by
  classical
  exact (univ.filter fun j => beta j ≠ 0).card

/-- A lower bound on the Hamming weight of every nonzero word of the functional outer dual.
This is the coordinate-free form of `d(O⊥) ≥ d`; unlike `minDist`, it remains meaningful when
the coordinate alphabet is the linear-dual space rather than the base field itself. -/
def HasFunctionalDualDistanceAtLeast (O : Submodule 𝔽 (ι → V)) (d : ℕ) : Prop :=
  ∀ beta ∈ functionalDual O, beta ≠ 0 → d ≤ functionalWeight beta

omit [DecidableEq 𝔽] in
/-- A functional-dual distance lower bound remains valid at every smaller threshold. -/
theorem HasFunctionalDualDistanceAtLeast.mono {O : Submodule 𝔽 (ι → V)} {d e : ℕ}
    (h : HasFunctionalDualDistanceAtLeast O d) (hed : e ≤ d) :
    HasFunctionalDualDistanceAtLeast O e := by
  intro beta hbeta hbeta0
  exact hed.trans (h beta hbeta hbeta0)

/-- A block vector annihilates the ordinary concatenation of `O` through `e`: pairing each block
with the encoded outer symbol and summing over blocks gives zero for every outer codeword. -/
def IsOrthogonalToConcatenation (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (w : ι → (κ → 𝔽)) : Prop :=
  ∀ u ∈ O, ∑ j, (e (u j) : κ → 𝔽) ⬝ᵥ w j = 0

omit [DecidableEq 𝔽] in
/-- **Outer-dual membership, proved directly.** Orthogonality to the concatenated code says the
vector of canonical block functionals annihilates the outer code, which is definitionally
membership in `functionalDual O`. -/
theorem blockFunctional_mem_functionalDual
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (w : ι → (κ → 𝔽))
    (horth : IsOrthogonalToConcatenation I e O w) :
    (fun j => blockFunctional I e (w j)) ∈ functionalDual O := by
  intro u hu
  change ∑ j, (e (u j) : κ → 𝔽) ⬝ᵥ w j = 0
  exact horth u hu

omit [DecidableEq 𝔽] in
/-- A functional-dual distance lower bound yields exactly the zero-or-large-support alternative
`ConcatDualWord.houter` expects. -/
theorem blockFunctional_outerAlternative
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (w : ι → (κ → 𝔽)) (d : ℕ)
    (horth : IsOrthogonalToConcatenation I e O w)
    (hdist : HasFunctionalDualDistanceAtLeast O d) :
    (∀ j, blockFunctional I e (w j) = 0) ∨
      d ≤ functionalWeight (fun j => blockFunctional I e (w j)) := by
  classical
  let beta : ι → Module.Dual 𝔽 V := fun j => blockFunctional I e (w j)
  by_cases hb : beta = 0
  · left
    intro j
    exact congrFun hb j
  · right
    have hmem : beta ∈ functionalDual O := blockFunctional_mem_functionalDual I e O w horth
    have hw := hdist beta hmem hb
    simpa only [beta] using hw

omit [DecidableEq 𝔽] in
/-- The functional-dual distance gate is nonvacuous: the full outer space has zero functional
dual, so it satisfies every declared lower bound. -/
theorem hasFunctionalDualDistanceAtLeast_top (d : ℕ) :
    HasFunctionalDualDistanceAtLeast (⊤ : Submodule 𝔽 (ι → V)) d := by
  classical
  intro beta hbeta hbeta0
  exfalso
  apply hbeta0
  funext j
  apply LinearMap.ext
  intro v
  have h := hbeta (Pi.single j v) (Submodule.mem_top)
  calc
    beta j v = ∑ l, beta l ((Pi.single j v : ι → V) l) := by
      symm
      calc
        (∑ l, beta l ((Pi.single j v : ι → V) l)) =
            beta j ((Pi.single j v : ι → V) j) := by
          apply Finset.sum_eq_single j
          · intro l _ hlj
            simp [hlj]
          · simp
        _ = beta j v := by simp
    _ = 0 := h

end
end RepairCodes
