import FiniteGeom.Weight

/-!
# Concatenation transfer lemma (`RepairCodes` §1.4)

This is the crux, self-contained novelty of the coding/MDS sweep
([`notes/2026-07-11-codex-coding-mds-cross-field-sweep.md`](../notes) §1.4) and
the single highest-value Lean target of the formalization plan
([`notes/handoffs/2026-07-11-lean-formalization-plan.md`](../notes) Phase 1,
step 1). It proves, with **no imported analytic input**, that a bounded-weight
dual word of an ordinary concatenation `C = O ∘ I` is confined block-for-block
to the inner dual code, and — under a slightly stronger weight bound — occupies
a single block. This is exactly what makes the *complete* bounded-size repair
hypergraph transfer under concatenation with no new cross-block supports.

## Design: abstract-first (plan §5, decision 1) + explicit hypotheses (decision 3)

We do **not** build the full trace-representation / outer-dual machinery here.
The genuinely novel, self-contained content is the *weight counting*:

* a block whose inner functional is nonzero (`β_j ≠ 0`) is a nonzero coordinate,
  so the count of such blocks is `≤` the total q-ary weight; bounded below
  `d(O⊥)` forces `β = 0`, i.e. **every block is inner-dual** (`transfer_blockwise`);
* each nonzero inner-dual block spends `≥ d(I⊥)` of the weight budget, so a
  budget `< 2·d(I⊥)` forces **at most one nonzero block** (`transfer_single_block`).

The deep structural inputs — that each block functional has a trace
representation `a ↦ Tr(β_j a)`, that orthogonality to `C` makes `β` an
outer-dual word, and that `β_j = 0` exactly when block `j` annihilates the inner
code — enter as **named fields** of `ConcatDualWord`, visible in the signature
with zero global axioms (plan §5, decision 3, preferred form). The concrete
`𝔽_q` NRC / twisted-cubic instance that discharges them (`q = 9` seed) is the
tracked Phase-1 follow-through in `RepairCodes.Q9Seed`.
-/

namespace RepairCodes

open Finset
open scoped BigOperators

variable {ι B O : Type*} [Fintype ι] [Zero B] [Zero O] [DecidableEq B] [DecidableEq O]

/-- Abstract model of a bounded-weight dual word of an ordinary concatenation
`C = O ∘ I`, carrying exactly the data the transfer argument cites.

* `w j` — the inner block `j` of the dual word (a coordinate block of `I`).
* `beta j` — its trace coefficient in the outer alphabet; the block functional
  is `a ↦ Tr((beta j) · a)`.
* `blockWt` — the q-ary Hamming weight of a block; `dI`/`dO` — the inner/outer
  dual distances; `s` — the weight budget.

The `Prop` fields are the imported/structural facts (§5, decision 3):
`hbeta` is the trace-representation faithfulness (`β_j = 0 ⇔ block annihilates
`I`), `houter` is `β ∈ O⊥` (a dual word is `0` or has weight `≥ d(O⊥)`),
`hdist` is the inner dual distance, and `hpos` records that a block not in `I⊥`
is nonzero. -/
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
  /-- a block not annihilating the inner code is nonzero (weight `≥ 1`). -/
  hpos : ∀ b, ¬ innerDual b → 1 ≤ blockWt b
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

/-- **Transfer, part A (blockwise).** Every block of a `< d(O⊥)`-weight dual
word of the concatenation lies in the inner dual code `I⊥`. -/
theorem transfer_blockwise (D : ConcatDualWord ι B O) :
    ∀ j, D.innerDual (D.w j) := by
  rcases D.houter with hz | hcard
  · -- outer coefficient is identically zero ⇒ each block annihilates `I`.
    exact fun j => (D.hbeta j).mp (hz j)
  · -- otherwise its weight is `≥ d(O⊥)`, but also `≤ s < d(O⊥)`: contradiction.
    exfalso
    have hle : (univ.filter (fun j => D.beta j ≠ 0)).card ≤ ∑ j, D.blockWt (D.w j) :=
      FiniteGeom.card_filter_le_sum (fun j => D.blockWt (D.w j)) _
        (fun j hj => D.hpos _ (fun hcontra => hj ((D.hbeta j).mpr hcontra)))
    have hdO : D.dO ≤ D.s := le_trans (le_trans hcard hle) D.htot
    exact absurd hdO (not_le.mpr D.hsO)

/-- **Transfer, part B (single block).** With the stronger budget `s < 2·d(I⊥)`,
a dual word occupies at most one block: at most one coordinate block is nonzero.
This is the "no new cross-block repair supports" content — the complete
bounded-size repair hypergraph is copied block-for-block. -/
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

/-- **Concatenation transfer lemma (§1.4), combined form.** Under the two weight
bounds `s < d(O⊥)` and `s < 2·d(I⊥)`, a dual word of the concatenation is
blockwise inner-dual and confined to a single block. -/
theorem transfer_lemma (D : ConcatDualWord ι B O) (hsI : D.s < 2 * D.dI) :
    (∀ j, D.innerDual (D.w j)) ∧ (univ.filter (fun j => D.w j ≠ 0)).card ≤ 1 :=
  ⟨transfer_blockwise D, transfer_single_block D hsI⟩

end RepairCodes
