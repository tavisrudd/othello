import NodeKayles.Basic

/-!
# Phase 4a — the Grundy characterization of `win` (self-contained Sprague–Grundy)

mathlib `v4.32` no longer ships `SetTheory/Game/` — `PGame`, `Impartial`, `grundyValue`,
and `Nimber` were extracted to the standalone `CombinatorialGames` package, which this
project does not depend on. So instead of anchoring `win` to a now-absent mathlib `PGame`
(the proposal's Approach-B / Phase-4 plan), the Grundy layer is built **self-contained** —
consistent with the documented reason Approach A was chosen (minimal mathlib footprint,
no version churn).

`grundy G S` is the minimal excludant (`mex`) of its children's Grundy values — the
standard impartial-game Grundy function. `win_iff_grundy_ne_zero` proves the textbook
P/N ↔ Grundy characterization (`win ⇔ grundy ≠ 0`); it is the foundation for the
component-XOR decomposition (proposal item 3 — the solver's nimber lever), which builds
on the `Nat.xor` Sprague–Grundy sum theorem.
-/

namespace NodeKayles

variable {k : ℕ}

/-! ## Minimal excludant (`mex`) -/

/-- Minimal excludant of a finite set of naturals: the least `n` not in `T`.
    `Infinite.exists_notMem_finset` supplies the witness `Nat.find` needs — `ℕ` is
    infinite, `T` is finite, so some natural lies outside `T`. -/
def mex (T : Finset ℕ) : ℕ := Nat.find (Infinite.exists_notMem_finset T)

/-- `mex T` is not in `T` (the defining property — `Nat.find_spec`). -/
theorem mex_not_mem (T : Finset ℕ) : mex T ∉ T :=
  Nat.find_spec (Infinite.exists_notMem_finset T)

/-- Every natural below `mex T` *is* in `T` (`mex` is the *least* absentee). -/
theorem lt_mex_mem {T : Finset ℕ} {m : ℕ} (h : m < mex T) : m ∈ T := by
  have := Nat.find_min (Infinite.exists_notMem_finset T) h
  simpa using this

/-- `mex T = 0` iff `0` is absent — the only fact the win/Grundy bridge needs. -/
theorem mex_eq_zero_iff {T : Finset ℕ} : mex T = 0 ↔ (0 : ℕ) ∉ T := by
  constructor
  · intro h hmem
    rw [← h] at hmem
    exact mex_not_mem T hmem
  · intro h
    rcases Nat.eq_zero_or_pos (mex T) with h0 | hpos
    · exact h0
    · exact absurd (lt_mex_mem hpos) h

/-- `mex T ≠ 0` iff `0 ∈ T` — i.e. iff some child is a loss. -/
theorem mex_ne_zero_iff {T : Finset ℕ} : mex T ≠ 0 ↔ (0 : ℕ) ∈ T := by
  rw [ne_eq, mex_eq_zero_iff, not_not]

/-! ## The Grundy value and the win characterization -/

/-- Grundy value of a Node-Kayles position: the `mex` of its children's Grundy values.
    A move on `v ∈ S` deletes `closedNbhd G v`; the child position is `S \ N[v]`. Same
    well-founded recursion as `win` (`termination_by S.card`, via `sdiff_closedNbhd_ssubset`).
    Mirrors the solver's per-node nimber (`grundy`/`mex` over the available moves). -/
def grundy (G : Graph k) (S : Finset (Fin k)) : ℕ :=
  mex (S.attach.image (fun v => grundy G (S \ closedNbhd G v.val)))
termination_by S.card
decreasing_by exact Finset.card_lt_card (sdiff_closedNbhd_ssubset G v.2)

/-- **The Grundy characterization of `win`** (the textbook P/N ↔ Grundy fact): the player
    to move wins iff the position's Grundy value is nonzero. A position is a loss (`win`
    false) exactly when it is a P-position (`grundy = 0`), i.e. every move leads to a
    nonzero-Grundy (winning-for-the-opponent) child.

    Proof: unfold one ply of both sides. `win G S` is "∃ a move to a loss"; `grundy G S ≠ 0`
    is (`mex_ne_zero_iff`) "`0` is among the children's Grundy values", i.e. "∃ a move to a
    `grundy = 0` child". The recursive call on the strictly-smaller child (the IH) turns
    `¬ win (child)` into `grundy (child) = 0`, closing the equivalence move-by-move. -/
theorem win_iff_grundy_ne_zero (G : Graph k) (S : Finset (Fin k)) :
    win G S ↔ grundy G S ≠ 0 := by
  rw [win.eq_def, grundy.eq_def, mex_ne_zero_iff, Finset.mem_image]
  simp only [Finset.mem_attach, true_and]
  refine exists_congr (fun v => ?_)
  rw [win_iff_grundy_ne_zero G (S \ closedNbhd G v.val)]
  simp only [ne_eq, not_not]
termination_by S.card
decreasing_by exact Finset.card_lt_card (sdiff_closedNbhd_ssubset G v.2)

/-- Board-level corollary: the first player wins `G` iff its Grundy value is nonzero — the
    Grundy form of `firstPlayerWins` (what `get(k, code)` returns over the full graph). -/
theorem firstPlayerWins_iff_grundy_ne_zero (G : Graph k) :
    firstPlayerWins G ↔ grundy G Finset.univ ≠ 0 :=
  win_iff_grundy_ne_zero G Finset.univ

end NodeKayles
