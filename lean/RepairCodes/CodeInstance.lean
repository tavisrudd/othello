import RepairCodes.Transfer
import FiniteGeom.Code
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Discharging the transfer interface's *algebraic* fields from the code layer (`RepairCodes` Phase 1)

Plan §5 decision 1 (abstract-first) is not finished until a concrete `𝔽_q` code discharges the
`ConcatDualWord` fields that are finite/algebraic. This file supplies the inner-code half with
the constructor `ofInnerCode`; `RepairCodes.OuterDual` proves the outer-code half directly.

Given a concrete inner code `I : Submodule 𝔽 (κ → 𝔽)` and its coordinate blocks
`w : ι → (κ → 𝔽)`, `ofInnerCode` fills the interface's algebraic fields **from
`FiniteGeom.Code`** — with zero further assumptions:

* `innerDual b := b ∈ dualCode I`, and `innerDual_zero` from `(dualCode I).zero_mem`;
* `blockWt := hammingNorm`, and `blockWt_eq_zero` from `hammingNorm_eq_zero`;
* `dI := dualDist I`, and `hdist` from `dualDist_le_hammingNorm` (nonzero dual word ⇒ weight
  `≥ d(I⊥)`).

The coefficient can be represented canonically as an element of the linear dual of the outer
symbol space.  Given an encoder equivalence `e : O ≃ₗ[𝔽] I`, `blockFunctional e w` is the
functional `a ↦ ⟪e a, w⟫`.  Its vanishing is equivalent to `w ∈ I⊥`; this is proved below from
surjectivity of `e`, with no trace theorem.  A field-trace coefficient is merely coordinates for
this dual functional after choosing a perfect trace pairing.

`ofInnerCodeFunctional` leaves `houter` as a named argument because this file does not yet carry
an outer code. `RepairCodes.OuterDual` supplies it from concatenation orthogonality plus a declared
functional-dual distance, with no trace-coordinate theorem or imported axiom.
-/

namespace RepairCodes

open Finset FiniteGeom

noncomputable section

variable {ι O : Type*} [Fintype ι] [Zero O] [DecidableEq O]
variable {κ : Type*} [Fintype κ]
variable {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-! ### Canonical block coefficients in the linear dual -/

variable {V : Type*} [AddCommGroup V] [Module 𝔽 V]

local instance : DecidableEq (Module.Dual 𝔽 V) := Classical.decEq _

/-- The functional induced on an outer symbol by pairing its encoded inner word with a block
vector `w`.  This is the coordinate-free object whose trace-coordinate representative is usually
called `β_j` in concatenation proofs. -/
def blockFunctional (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (w : κ → 𝔽) : Module.Dual 𝔽 V where
  toFun a := (e a : κ → 𝔽) ⬝ᵥ w
  map_add' a b := by simp [add_dotProduct]
  map_smul' c a := by simp [smul_dotProduct]

omit [DecidableEq 𝔽] in
/-- **Faithfulness of the canonical coefficient.** The block functional is zero exactly when
the block annihilates the inner code.  The reverse implication evaluates dual membership on
encoded words; the forward implication uses surjectivity of the encoder to reach every inner
codeword.  No trace-form theorem or imported result enters. -/
theorem blockFunctional_eq_zero_iff (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (w : κ → 𝔽) : blockFunctional I e w = 0 ↔ w ∈ dualCode I := by
  constructor
  · intro hzero
    rw [mem_dualCode]
    intro x hx
    obtain ⟨a, ha⟩ := e.surjective ⟨x, hx⟩
    have h := LinearMap.congr_fun hzero a
    simpa [blockFunctional, ha] using h
  · intro hw
    apply LinearMap.ext
    intro a
    exact hw (e a) (e a).property

/-- Build a `ConcatDualWord` from a concrete inner code `I` over `𝔽_q`, taking only the outer
trace data (`beta`, `hbeta`, `houter`) and the weight budget (`s`, `htot`, `hsO`) as
hypotheses. The inner-dual membership, block weight, inner dual distance, and their defining
properties are supplied by the `FiniteGeom.Code` layer. -/
noncomputable def ofInnerCode
    (I : Submodule 𝔽 (κ → 𝔽))
    (w : ι → (κ → 𝔽)) (beta : ι → O) (dO s : ℕ)
    (hbeta : ∀ j, beta j = 0 ↔ w j ∈ dualCode I)
    (houter : (∀ j, beta j = 0) ∨ dO ≤ (univ.filter (fun j => beta j ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) :
    ConcatDualWord ι (κ → 𝔽) O where
  w := w
  beta := beta
  blockWt := hammingNorm
  innerDual := fun b => b ∈ dualCode I
  dI := dualDist I
  dO := dO
  s := s
  innerDual_zero := (dualCode I).zero_mem
  blockWt_eq_zero := fun _ => hammingNorm_eq_zero
  hbeta := hbeta
  houter := houter
  hdist := fun _ hb hb0 => dualDist_le_hammingNorm hb hb0
  htot := htot
  hsO := hsO

/-- Build the transfer model using the **canonical dual-functional coefficients** associated to
an encoder equivalence `e : V ≃ₗ[𝔽] I`.  The coefficient-faithfulness field `hbeta` is discharged
by `blockFunctional_eq_zero_iff`; only the outer-dual distance alternative remains a hypothesis. -/
noncomputable def ofInnerCodeFunctional
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (w : ι → (κ → 𝔽)) (dO s : ℕ)
    (houter : (∀ j, blockFunctional I e (w j) = 0) ∨
      dO ≤ (univ.filter (fun j => blockFunctional I e (w j) ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) :
    ConcatDualWord ι (κ → 𝔽) (Module.Dual 𝔽 V) := by
  classical
  exact ofInnerCode I w (fun j => blockFunctional I e (w j)) dO s
    (fun j => blockFunctional_eq_zero_iff I e (w j)) houter htot hsO

/-- Instantiated against a real inner code, the transfer lemma still fires: under the two weight
bounds, every block is inner-dual and at most one is nonzero. Only the outer trace inputs remain
to be supplied for a specific code — this is the code-backed replacement for `Q9Seed`'s toy
witness. -/
theorem transfer_ofInnerCode
    (I : Submodule 𝔽 (κ → 𝔽))
    (w : ι → (κ → 𝔽)) (beta : ι → O) (dO s : ℕ)
    (hbeta : ∀ j, beta j = 0 ↔ w j ∈ dualCode I)
    (houter : (∀ j, beta j = 0) ∨ dO ≤ (univ.filter (fun j => beta j ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) (hsI : s < 2 * dualDist I) :
    (∀ j, w j ∈ dualCode I) ∧ (univ.filter (fun j => w j ≠ 0)).card ≤ 1 :=
  transfer_lemma (ofInnerCode I w beta dO s hbeta houter htot hsO) hsI

/-- Transfer with a concrete inner encoder and coordinate-free block coefficients. Coefficient
faithfulness is internal finite linear algebra; `RepairCodes.OuterDual` supplies `houter` once an
outer code and its functional-dual distance are present. -/
theorem transfer_ofInnerCodeFunctional
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (w : ι → (κ → 𝔽)) (dO s : ℕ)
    (houter : (∀ j, blockFunctional I e (w j) = 0) ∨
      dO ≤ (univ.filter (fun j => blockFunctional I e (w j) ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) (hsI : s < 2 * dualDist I) :
    (∀ j, w j ∈ dualCode I) ∧ (univ.filter (fun j => w j ≠ 0)).card ≤ 1 :=
  transfer_lemma (ofInnerCodeFunctional I e w dO s houter htot hsO) hsI

end
end RepairCodes
