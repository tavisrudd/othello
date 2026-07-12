import FiniteGeom.Weight

/-!
# Concatenation transfer: the bounded-weight repair-hypergraph corollary (`RepairCodes` §1.4)

Ordinary concatenation `C = O ∘ I` of an inner code `I` and an outer code `O`.
The *classical* facts about such a concatenation — that each block functional of
a dual word has a trace representation `a ↦ Tr(β_j a)`, and that orthogonality to
`C` makes the coefficient vector `β` a word of `O⊥` (Chen–Ling–Xing's dual
decomposition) — are **not** re-proved here. What *is* proved is the finite
counting corollary the sweep flags as the candidate-new content
([`notes/2026-07-11-codex-coding-mds-cross-field-sweep.md`](../notes) §1.4):

* under `wt_q(w) < d(O⊥)`, a dual word is **blockwise inner-dual** — every block
  lies in `I⊥` (`transfer_blockwise`);
* under the stronger `wt_q(w) < 2·d(I⊥)`, it occupies **at most one block**
  (`transfer_single_block`), so the complete bounded-size repair hypergraph is
  copied block-for-block with no new cross-block supports.

## Scope of this formalization (read before citing)

Stated over the abstract model `ConcatDualWord`, whose fields are the structural
inputs the counting argument consumes — trace-representation faithfulness
(`hbeta`) and the outer dual distance (`houter`) among them. Those inputs are
**hypotheses, not axioms** (plan §5 decision 3, preferred form). Consequently:

* the theorems are unconditional in the proof-theoretic sense — `#print axioms`
  shows only `propext` / `Classical.choice` / `Quot.sound`, no `sorryAx`;
* but they are *conditional on the model*: they say nothing about a concrete code
  until `ConcatDualWord` is instantiated for one. `RepairCodes.Q9Seed` now supplies
  the real `𝔽₉` inner code, encoder equivalence, and exact dual distance four; the
  outer-dual decomposition remains an explicit obligation there.

The analytic/asymptotic inputs (Sauermann, Ellenberg–Gijswijt) are *not* used by
this finite lemma and do not appear.
-/

namespace RepairCodes

open Finset
open scoped BigOperators

variable {ι B O : Type*} [Fintype ι] [Zero B] [Zero O] [DecidableEq B] [DecidableEq O]

/-- Abstract model of a bounded-weight dual word of an ordinary concatenation
`C = O ∘ I`. The fields carry exactly the data and structural facts the counting
argument consumes; a concrete code discharges them by supplying real Hamming
weights, its inner dual code, and the trace/dual-decomposition facts.

Faithfulness of each field to the intended object:
* `w j` — inner coordinate block `j` of the dual word; `blockWt` its q-ary
  Hamming weight, with `blockWt_eq_zero` = "weight is zero iff the block is the
  zero vector" (a defining property of Hamming weight).
* `innerDual` — membership in the inner dual code `I⊥`, with `innerDual_zero` =
  "`0 ∈ I⊥`".
* `beta j` — the outer trace coefficient of block `j`; `hbeta` says the block
  functional vanishes on `I` (i.e. the block is inner-dual) exactly when its
  coefficient is `0` — trace-representation faithfulness / nondegeneracy.
* `houter` — `β` is a word of `O⊥` whose dual distance is at least `dO`: it is
  `0`, or its Hamming weight is `≥ dO`.
* `hdist` — inner dual distance: a nonzero `I⊥`-block has weight `≥ dI`.
* `htot` / `hsO` — the q-ary weight budget, below the outer dual distance. -/
structure ConcatDualWord (ι B O : Type*)
    [Fintype ι] [Zero B] [Zero O] [DecidableEq B] [DecidableEq O] where
  /-- inner block `j` of the dual word. -/
  w : ι → B
  /-- outer trace coefficient of block `j`. -/
  beta : ι → O
  /-- q-ary Hamming weight of a block. -/
  blockWt : B → ℕ
  /-- membership of a block in the inner dual code `I⊥`. -/
  innerDual : B → Prop
  /-- inner dual distance `d(I⊥)`. -/
  dI : ℕ
  /-- outer dual distance `d(O⊥)`. -/
  dO : ℕ
  /-- the q-ary weight budget on the dual word. -/
  s : ℕ
  /-- the zero vector is inner-dual (`0 ∈ I⊥`). -/
  innerDual_zero : innerDual 0
  /-- Hamming weight is zero exactly on the zero block. -/
  blockWt_eq_zero : ∀ b, blockWt b = 0 ↔ b = 0
  /-- trace-representation faithfulness: the coefficient vanishes iff the block
  annihilates the inner code. -/
  hbeta : ∀ j, beta j = 0 ↔ innerDual (w j)
  /-- `β ∈ O⊥`: the outer coefficient word is zero or has weight `≥ d(O⊥)`. -/
  houter : (∀ j, beta j = 0) ∨ dO ≤ (univ.filter (fun j => beta j ≠ 0)).card
  /-- inner dual distance: a nonzero inner-dual block has weight `≥ d(I⊥)`. -/
  hdist : ∀ b, innerDual b → b ≠ 0 → dI ≤ blockWt b
  /-- the dual word respects the weight budget. -/
  htot : (∑ j, blockWt (w j)) ≤ s
  /-- the budget is below the outer dual distance. -/
  hsO : s < dO

/-- **Transfer, part A (blockwise), in the model `ConcatDualWord`.** Every block
of a `< d(O⊥)`-weight dual word lies in the inner dual code `I⊥`. -/
theorem transfer_blockwise (D : ConcatDualWord ι B O) :
    ∀ j, D.innerDual (D.w j) := by
  rcases D.houter with hz | hcard
  · -- outer coefficient is identically zero ⇒ each block annihilates `I`.
    exact fun j => (D.hbeta j).mp (hz j)
  · -- otherwise its weight is `≥ d(O⊥)`, but also `≤ s < d(O⊥)`: contradiction.
    exfalso
    -- a block with nonzero coefficient is not inner-dual, hence nonzero, weight `≥ 1`.
    have hpos : ∀ j, D.beta j ≠ 0 → 1 ≤ D.blockWt (D.w j) := by
      intro j hj
      have hnid : ¬ D.innerDual (D.w j) := fun h => hj ((D.hbeta j).mpr h)
      have hwne : D.w j ≠ 0 := by
        intro h; exact hnid (by rw [h]; exact D.innerDual_zero)
      have hbwne : D.blockWt (D.w j) ≠ 0 :=
        fun h => hwne ((D.blockWt_eq_zero (D.w j)).mp h)
      omega
    have hle : (univ.filter (fun j => D.beta j ≠ 0)).card ≤ ∑ j, D.blockWt (D.w j) :=
      FiniteGeom.card_filter_le_sum (fun j => D.blockWt (D.w j)) _ hpos
    exact absurd (le_trans (le_trans hcard hle) D.htot) (not_le.mpr D.hsO)

/-- **Transfer, part B (single block), in the model `ConcatDualWord`.** With the
stronger budget `s < 2·d(I⊥)`, a dual word occupies at most one block: at most
one coordinate block is nonzero. This is the "no new cross-block repair supports"
content — the complete bounded-size repair hypergraph is copied block-for-block. -/
theorem transfer_single_block (D : ConcatDualWord ι B O) (hsI : D.s < 2 * D.dI) :
    (univ.filter (fun j => D.w j ≠ 0)).card ≤ 1 := by
  have hall := transfer_blockwise D
  have hmul : D.dI * (univ.filter (fun j => D.w j ≠ 0)).card ≤ ∑ j, D.blockWt (D.w j) :=
    FiniteGeom.mul_card_filter_le_sum (fun j => D.blockWt (D.w j)) _ D.dI
      (fun j hj => D.hdist _ (hall j) hj)
  have h2 : D.dI * (univ.filter (fun j => D.w j ≠ 0)).card < 2 * D.dI :=
    lt_of_le_of_lt (le_trans hmul D.htot) hsI
  rw [mul_comm 2 D.dI] at h2
  have h3 : (univ.filter (fun j => D.w j ≠ 0)).card < 2 := Nat.lt_of_mul_lt_mul_left h2
  omega

/-- **Concatenation transfer lemma (§1.4), combined form, in the model
`ConcatDualWord`.** Under the two weight bounds `s < d(O⊥)` and `s < 2·d(I⊥)`, a
dual word of the concatenation is blockwise inner-dual and confined to a single
block. -/
theorem transfer_lemma (D : ConcatDualWord ι B O) (hsI : D.s < 2 * D.dI) :
    (∀ j, D.innerDual (D.w j)) ∧ (univ.filter (fun j => D.w j ≠ 0)).card ≤ 1 :=
  ⟨transfer_blockwise D, transfer_single_block D hsI⟩

end RepairCodes
