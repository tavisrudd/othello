# Proposal: Lean verification of the getK leaf evaluator (2-lite)

## Status

Draft

## Problem

The n=18 verdict (first player wins) bottoms out, for ~21%+ of all search nodes, in
the **getK dense leaf evaluator** (`dense.rs`): every position with `pc ≤ dense_k`
(17 in the first run, 20 in the confirm) is resolved directly as a Node-Kayles
win/loss without subtree expansion. getK is also where the one real bug in this code
class lived — the `u8` square-index truncation (`cddfc64`) was a leaf-decode defect.

The current assurance for getK is **differential testing against a scalar reference**
(`direct_wK_matches_scalar_recurrence`, `graph_wins8_matches_scalar`) plus an Opus
int-sizing audit. That is strong but sampled. The goal of *2-lite* is to replace the
"is the leaf-evaluation algorithm the right computation?" question with a
machine-checked proof, while leaving the narrower "does the pext SIMD match the
scalar?" question to the existing test harness (where it is cheapest).

**2-lite explicitly does NOT attempt:** the pext/BMI2 intrinsics, the generic high-pc
α-β combination logic above the getK ceiling, the lockless TT, the concurrency, or the
board→code build. It verifies the *recurrence semantics* and the *base table*. See
[the getK-throughput proposal](proposal-2026-06-19-getk-throughput.md) and the
[n=18 umbrella](handoffs/2026-06-23-queens-n18-umbrella.md) for the surrounding context.

## Context

The codebase hands us the specification for free, written twice over:

- **`wins_rec(k, code, tables)`** (`dense.rs:584`) — the scalar recursion, pext-free,
  bottoming in the complete `W{≤8}` tables. It is `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])`
  verbatim — i.e. exactly the Node-Kayles normal-play P/N recurrence (a move on vertex
  `i` deletes the *closed* neighborhood `{i} ∪ N(i)`, coded as `full & !((1<<i)|adj[i])`).
- **`winsw_scalar`** (`dense.rs:1413`) — the same for the wide K=17–20 layers.
- **`adj_from_code`** (`:501`) / **`projected_code`** (`:516`) — scalar decode + child
  projection (the relabel-survivors-to-`0..k'` step that lets a child index a smaller table).
- **`graph_wins`** (`:541`) / **`build_tables`** (`:1166`) — the W0..W8 base-table build;
  `graph_wins` is literally one ply of the recurrence with children looked up in the
  lower tables.
- **The differential harness** (`dense.rs:1264`–1493) already pins getK ≡ `wins_rec`
  across density-spread codes for every layer, and `graph_wins8_matches_scalar`
  (`:1201`) pins the pext W8 build ≡ the scalar `graph_wins(8, ·)`.

So 2-lite is: **verify `wins_rec` (and the W8 build behind it), then lean on the
existing tests for the SIMD-equals-scalar step.** mathlib's `SetTheory/Game/`
(`PGame`, `Impartial`, Sprague–Grundy) is available to anchor the game-theoretic
meaning — but its `PGame` is `Type`-valued and noncomputable, which is the crux of the
A-vs-B decision below.

No Lean toolchain exists in the repo yet; either approach stands up a Lake project
under `lean/` (or a sibling repo). The W8 disk cache (`load_w8_cache`, checksum-guarded)
is out of scope — it is a memo of the build output, and a mismatch falls back to rebuild.

---

## Approach A: Self-contained inductive model

### Architecture

Define the game and its win predicate directly in Lean, mirroring `wins_rec`, with a
minimal mathlib footprint. The win predicate IS the game's definition; correctness of
the *build* is then a structural induction.

**Layer A — the win predicate (the spec backbone):**

```lean
import Mathlib.Data.Finset.Basic

variable {k : ℕ}

/-- A finite simple graph on `Fin k`: symmetric, irreflexive, decidable adjacency. -/
structure Graph (k : ℕ) where
  adj    : Fin k → Fin k → Bool
  symm   : ∀ i j, adj i j = adj j i
  irrefl : ∀ i, adj i i = false

/-- Closed neighborhood: `v` together with its neighbours. The set a move deletes. -/
def closedNbhd (G : Graph k) (v : Fin k) : Finset (Fin k) :=
  Finset.univ.filter (fun u => u = v ∨ G.adj v u)

/-- Node-Kayles win (normal play): the player to move wins iff some live vertex `v`,
    when played, leaves the opponent a loss. `S` = live vertices. Computable `Bool`.
    Well-founded on `S.card` — `v ∈ S ∩ closedNbhd G v`, so the child set is strictly
    smaller (mirrors `wins_rec`, which is the same recurrence on labelled codes). -/
def win (G : Graph k) (S : Finset (Fin k)) : Bool :=
  S.attach.any (fun v => ! win G (S \ closedNbhd G v))
termination_by S.card
decreasing_by
  -- v.1 ∈ S and v.1 ∈ closedNbhd G v.1 ⇒ v.1 ∉ S \ closedNbhd ⇒ card strictly drops
  exact Finset.card_lt_card (by
    refine Finset.ssubset_iff_of_subset (Finset.sdiff_subset) |>.mpr ⟨v.1, v.2, ?_⟩
    simp [closedNbhd])

/-- "First player wins the game on `G`" — all vertices live. -/
def firstPlayerWins (G : Graph k) : Bool := win G Finset.univ
```

**Layer A — relabeling (isomorphism) invariance** (the lemma A′ needs to justify
"project survivors to a canonical code, then look the value up"):

```lean
/-- `win` depends only on the isomorphism class: relabelling vertices by `e` and
    transporting the live set preserves the value. The mathematical content behind
    `projected_code` + the table lookup. -/
theorem win_iso (G : Graph k) (H : Graph k') (e : Fin k ≃ Fin k')
    (he : ∀ i j, G.adj i j = H.adj (e i) (e j)) (S : Finset (Fin k)) :
    win G S = win H (S.map e.toEmbedding) := by
  sorry  -- induction on S.card; closedNbhd commutes with e
```

**Layer A′ — the W8 base-table build:**

```lean
/-- Decode a `k·(k-1)/2`-bit upper-triangular `code` to adjacency (mirrors
    `adj_from_code`): bit `e(i,j)` (i<j) is edge `(i,j)`. -/
def graphOfCode (k : ℕ) (code : ℕ) : Graph k := sorry

/-- The true win value of the *complete* `k`-vertex graph encoded by `code`
    (what the W8 table claims to store, and what `wins_rec` computes). -/
def graphWin (k code : ℕ) : Bool := firstPlayerWins (graphOfCode k code)

/-- One ply of the recurrence with children resolved in the lower tables — the Lean
    model of `graph_wins` (`dense.rs:541`). `lower j _ c = graphWin j c` is the IH. -/
def buildPred (lower : ∀ j, j < k → ℕ → Bool) (k code : ℕ) : Bool := sorry

/-- A′ (the core lemma): given correct lower tables, the build predicate equals the
    true win value. No 2^28 enumeration — `graph_wins` IS the one-ply recurrence, so
    this is `win`'s own unfolding plus `win_iso` for the projected children. -/
theorem buildPred_correct
    (lower : ∀ j, j < k → ℕ → Bool)
    (hlower : ∀ j (hj : j < k) c, c < slots j → lower j hj c = graphWin j c)
    (code : ℕ) (h : code < slots k) :
    buildPred lower k code = graphWin k code := by
  sorry

/-- A′ top-level, by strong induction on k: the built `W0..W8` tables equal `graphWin`
    everywhere, and the flat-arena offset read (`get`, `dense.rs:734`) returns that bit. -/
theorem w8_table_correct :
    ∀ k ≤ 8, ∀ code, code < slots k → DenseGet k code = graphWin k code := by
  sorry
```

The trust chain then closes: `w8_table_correct` + `buildPred_correct` give the *scalar*
build; the production W8 arena uses the pext `graph_wins8` path, which
`graph_wins8_matches_scalar` pins to `graph_wins(8, ·)`; and `wins_rec` (= the runtime
getK's spec) is the unfolding of `win` on codes via `win_iso`. The remaining
SIMD-equals-scalar gap is carried by `direct_wK_matches_scalar_recurrence`.

### Trade-offs

**Strengths:**
- Smallest dependency surface; fastest path to a green, fully kernel-checked result.
- Everything is computable `Bool` — the Lean `win` runs, so it can be cross-checked
  against the Rust on the same codes (a second differential, Lean-side).
- The base table is proven *structurally* — no reflection over 2^28 entries, no native
  trust extension.
- `win`/`buildPred`/`graphOfCode` mirror `wins_rec`/`graph_wins`/`adj_from_code`
  line-for-line, so the Lean↔Rust correspondence is auditable by eye.

**Weaknesses:**
- "`win` is *the* game value" is definitional + a short adequacy argument, not backed
  by a named mathlib theorem. (It is the textbook normal-play recurrence, so the
  argument is ~10 lines, but it is on us.)
- Does not auto-deliver item 3 (component decomposition = Grundy XOR) or item 1's
  Grundy framing — those would be separate work.

---

## Approach B: mathlib `PGame` / Sprague–Grundy anchor

### Architecture

Model the position as a `SetTheory.PGame`, prove it `Impartial`, and define winning via
mathlib's blessed semantics: `firstPlayerWins ⟺ ¬ (G ≈ 0) ⟺ grundyValue G ≠ 0`. Because
`PGame` is noncomputable, you still build Approach A's computable `win` and add a
**bridge** proving it agrees with the classical value.

```lean
import Mathlib.SetTheory.Game.Impartial
import Mathlib.SetTheory.Game.Nim

/-- The position as an impartial combinatorial game. -/
noncomputable def toPGame (G : Graph k) (S : Finset (Fin k)) : SetTheory.PGame := sorry

instance (G : Graph k) (S) : (toPGame G S).Impartial := sorry

/-- The bridge: the computable `win` agrees with mathlib's classical first-player win. -/
theorem win_iff_pgame (G : Graph k) (S : Finset (Fin k)) :
    win G S = true ↔ ¬ (toPGame G S ≈ 0) := by
  sorry

/-- Item-3 dividend, ~free from `grundyValue_add`: disjoint components XOR. -/
theorem grundy_disjoint_union : sorry := sorry
```

### Trade-offs

**Strengths:**
- "Win" carries mathlib's blessed game-theoretic meaning; the adequacy argument is a
  cited theorem, not ours.
- Delivers item 1's Grundy framing and item 3 (component-XOR / Sprague–Grundy) largely
  for free — the same machinery the solver's component canonicalization relies on.
- Reusable foundation if the formalization is ever extended (other boards, n≥20).

**Weaknesses:**
- `PGame` is `Type`-valued and noncomputable ⇒ you build Approach A's computable `win`
  *anyway* and additionally prove the bridge `win_iff_pgame`. Strictly more work.
- mathlib `PGame`/`Impartial` API churns across versions; a `PGame` proof carries
  ongoing maintenance the self-contained model does not.
- The bridge is the kind of "classical ↔ computable" proof that is fiddly out of
  proportion to its assurance payoff for *this* goal (we only need a win value).

---

## Approach comparison

| Criterion                          | A: self-contained        | B: mathlib anchor             |
|------------------------------------|--------------------------|-------------------------------|
| Time to first green 2-lite result  | shorter                  | longer (A + the bridge)       |
| Computable spec (Lean-side diff)   | yes, native              | yes (the computable twin)     |
| "win = game value" justification   | self-asserted (~short)   | cited mathlib theorem         |
| W8 base table                      | proven structurally      | proven structurally (same)    |
| Delivers item 1 / item 3           | no (separate work)       | largely free                  |
| mathlib version-churn exposure     | minimal                  | ongoing                       |
| Total proof obligations            | fewer                    | superset of A                 |

The two are not exclusive: **A is a strict prefix of B.** B = A's computable `win` +
the W8 build + the `PGame` bridge. So the choice is really "stop at A" vs "continue
into B."

---

## Open questions

1. **Toolchain location.** A `lean/` Lake project inside this repo, or a sibling repo?
   (Leaning: in-repo `lean/`, so the Lean defs sit next to the Rust they mirror and CI
   can diff them.)
2. **Rust↔Lean transfer.** 2-lite verifies a *Lean model* of `wins_rec`/`graph_wins`.
   The model is hand-translated and audited against the Rust by eye (the functions are
   small and mirror-able). Auto-translation (Aeneas/Charon) is not viable here — the
   production getK is pext/const-generic/`get_unchecked`. Is hand-translation +
   eyeball-audit the accepted transfer story? (It is the only practical one.)
3. **Base-table trust model.** Recommended: *prove* `buildPred_correct` (structural, no
   enumeration). Alternative: treat the runtime 2^28 arena as input and `native_decide`
   that it satisfies the recurrence once at load — sidesteps proving the rayon build but
   extends trust to Lean's compiler and runs a 2^28 check. Prefer the proof.
4. **Differential-test sufficiency.** The SIMD-equals-scalar step stays test-only. The
   smaller layers (W9–W12) are exhaustively checkable if we want to upgrade those from
   sampled to total; worth it?
5. **Boundary obligation.** getK is correct *about the abstract graph encoded by `code`*.
   Connecting it to the board needs "the code build (`att08`/`adj_row_pext`) encodes the
   queen graph" — item 1/3 territory, flagged so the scope edge is explicit.

## Recommendation

**Approach A, with the option to graft B's bridge as a follow-on.**

Justification:
1. **A delivers the entire 2-lite assurance goal** — a machine-checked proof that the
   leaf-evaluator recurrence is the right computation and the base table is correct —
   at the smallest cost, and it is exactly the bug class that has bitten this code
   (leaf-decode / wrong-recurrence). B adds blessed semantics and items 1/3 but no extra
   assurance for the n=18 leaf evaluation per se.
2. **A is computable**, so the Lean `win` becomes a second, independent differential
   oracle against the Rust on shared codes — concrete corroboration before any `PGame`
   abstraction.
3. **A is a strict prefix of B**, so starting with A forecloses nothing. If item 1/3
   (Grundy framing, component decomposition) become priorities, the `PGame` bridge grafts
   onto the same computable `win` without rework.
4. The base table is provable structurally — A keeps the kernel-checked, no-native-trust
   property that makes the result worth having.

### Implementation phases

**Phase 1 (validate the approach — minimum viable proof).** Stand up the `lean/` Lake
project. Define `Graph`, `closedNbhd`, `win` (with the termination proof), `graphOfCode`,
`graphWin`. Prove `win_iso`. This is the spec backbone and its hardest small proof
(termination + iso-invariance); getting it green validates the whole approach.

**Phase 2 (the base table).** Define `buildPred` + the arena-offset read; prove
`buildPred_correct` and `w8_table_correct` by strong induction on k. No enumeration.

**Phase 3 (close the trust chain).** State the correspondence to the Rust explicitly:
`win` on codes = `wins_rec`; `buildPred` = `graph_wins`; and document that the pext getK
rides on `direct_wK_matches_scalar_recurrence` + `graph_wins8_matches_scalar`. Add a
Lean-side `#eval` cross-check of `win` against a dumped set of Rust `wins_rec` codes.

**Phase 4 (optional, → item 1/3).** Graft Approach B's `toPGame`, `Impartial` instance,
and `win_iff_pgame` bridge; derive the component-XOR result from `grundyValue_add`.

Phases 1–3 are the 2-lite deliverable (~1–2 person-months, Phase 1 carrying the risk).
Phase 4 is the on-ramp to items 1 and 3 and should be a separate go/no-go.
