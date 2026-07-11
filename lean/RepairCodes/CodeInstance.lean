import RepairCodes.Transfer
import FiniteGeom.Code

/-!
# Discharging the transfer interface's *algebraic* fields from the code layer (`RepairCodes` Phase 1)

Plan §5 decision 1 (abstract-first) is not finished until a concrete `𝔽_q` code discharges the
`ConcatDualWord` fields that are *finite/algebraic* — as opposed to the two genuinely-imported
structural inputs (trace-representation faithfulness and the Chen–Ling–Xing dual decomposition).
This file draws that line explicitly with the constructor `ofInnerCode`.

Given a concrete inner code `I : Submodule 𝔽 (Fin m → 𝔽)` and its coordinate blocks
`w : ι → (Fin m → 𝔽)`, `ofInnerCode` fills the interface's algebraic fields **from
`FiniteGeom.Code`** — with zero further assumptions:

* `innerDual b := b ∈ dualCode I`, and `innerDual_zero` from `(dualCode I).zero_mem`;
* `blockWt := hammingNorm`, and `blockWt_eq_zero` from `hammingNorm_eq_zero`;
* `dI := dualDist I`, and `hdist` from `dualDist_le_hammingNorm` (nonzero dual word ⇒ weight
  `≥ d(I⊥)`).

What remains a *hypothesis* of `ofInnerCode` is exactly the residual deep content: the outer
coefficient vector `beta`, its trace-representation faithfulness `hbeta`
(`beta j = 0 ↔ w j ∈ I⊥`), and its outer dual-distance bound `houter` (`β ∈ O⊥`). So the real
`q = 9` discharge (tracked in `RepairCodes.Q9Seed`) reduces precisely to supplying those three —
`Algebra.trace` nondegeneracy for `hbeta`, Chen–Ling–Xing for `houter` — and nothing else. That
is the reviewable boundary between "ours" and "imported" (plan §5 decision 3), now made concrete
at the type level rather than asserted in prose.
-/

namespace RepairCodes

open Finset FiniteGeom

variable {ι O : Type*} [Fintype ι] [Zero O] [DecidableEq O]
variable {m : ℕ} {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- Build a `ConcatDualWord` from a concrete inner code `I` over `𝔽_q`, taking only the outer
trace data (`beta`, `hbeta`, `houter`) and the weight budget (`s`, `htot`, `hsO`) as
hypotheses. The inner-dual membership, block weight, inner dual distance, and their defining
properties are supplied by the `FiniteGeom.Code` layer. -/
noncomputable def ofInnerCode
    (I : Submodule 𝔽 (Fin m → 𝔽))
    (w : ι → (Fin m → 𝔽)) (beta : ι → O) (dO s : ℕ)
    (hbeta : ∀ j, beta j = 0 ↔ w j ∈ dualCode I)
    (houter : (∀ j, beta j = 0) ∨ dO ≤ (univ.filter (fun j => beta j ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) :
    ConcatDualWord ι (Fin m → 𝔽) O where
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

/-- Instantiated against a real inner code, the transfer lemma still fires: under the two weight
bounds, every block is inner-dual and at most one is nonzero. Only the outer trace inputs remain
to be supplied for a specific code — this is the code-backed replacement for `Q9Seed`'s toy
witness. -/
theorem transfer_ofInnerCode
    (I : Submodule 𝔽 (Fin m → 𝔽))
    (w : ι → (Fin m → 𝔽)) (beta : ι → O) (dO s : ℕ)
    (hbeta : ∀ j, beta j = 0 ↔ w j ∈ dualCode I)
    (houter : (∀ j, beta j = 0) ∨ dO ≤ (univ.filter (fun j => beta j ≠ 0)).card)
    (htot : (∑ j, hammingNorm (w j)) ≤ s)
    (hsO : s < dO) (hsI : s < 2 * dualDist I) :
    (∀ j, w j ∈ dualCode I) ∧ (univ.filter (fun j => w j ≠ 0)).card ≤ 1 :=
  transfer_lemma (ofInnerCode I w beta dO s hbeta houter htot hsO) hsI

end RepairCodes
