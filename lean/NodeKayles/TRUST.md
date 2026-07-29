# Trust chain — what the Lean proofs certify about `getK`

> **Scope: the NodeKayles/queens `getK` evaluator only.** This is not the trust document for the
> tree as a whole. For the portfolio trust model, the per-paper manifests, and the named classical
> inputs, see [`../TRUST.md`](../TRUST.md).

This is the legibility layer for the 2-lite verification (`proposal-2026-06-26-getk-lean-verification.md`).
It states precisely which Rust behaviour the Lean theorems (`NodeKayles/Basic.lean`) underwrite,
what is deliberately left to the existing differential tests, and what stays in the trusted base.

The target is the **`getK` leaf evaluator** in `rust/src/queens/dense.rs` — the dense W_K
machinery that resolves every position with `pc ≤ dense_k` directly as a Node-Kayles win/loss,
without subtree expansion. getK is the leaf the n=18 search bottoms out on (~21%+ of nodes) and is
where the one historical defect of this class lived (the `u8` square-index truncation, `cddfc64`).

## Machine-checked (Lean, no `sorry`)

The semantics of the leaf evaluator — the recurrence, its invariances, and the build — are proved.

| Lean (`NodeKayles/Basic.lean`)        | establishes                                                          | Rust underwritten                         |
|---------------------------------------|---------------------------------------------------------------------|-------------------------------------------|
| `Graph`, `closedNbhd`                 | the abstract Node-Kayles graph; a move deletes `{v} ∪ N(v)`         | the deleted set `(1<<i) \| adj[i]`; the surviving child `S ∖ closedNbhd` is its complement `full & !((1<<i) \| adj[i])` |
| `win` (+ kernel-checked termination)  | the P/N recurrence `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])` is well-defined | `wins_rec` (`dense.rs:584`, the `#[cfg(test)]` scalar reference; the production `getK` ties to it via the differential tests) |
| `win_iso`                             | the value is invariant under a same-size relabelling                | labelled-code freedom; D4 canon at a leaf |
| **`win_emb`**                         | the value is invariant under **induced-subgraph relabelling**       | **`projected_code` (`dense.rs:516`)** — the getK "relabel a child's survivors to `0..k'`, read the smaller `W{k'}`" step |
| `inducedGraph`, `firstPlayerWins_inducedGraph` | a child resolves as the value of a smaller induced subgraph | decoding a `projected_code` child to a smaller labelled graph |
| **`buildPred_correct`**               | the build recurrence equals the true value                          | **`graph_wins` (`dense.rs:541`)**         |
| `not_win_empty`                       | the terminal position is a loss for the mover                       | the `W0` base of the build                |
| `firstPlayerWins`                     | first player wins ⇔ `win` over the full vertex set                  | `get(k, code)` over a complete graph      |
| `grundy`, `win_iff_grundy_ne_zero` (Phase 4a) | the win predicate matches the Grundy characterization (`win ⇔ grundy ≠ 0`), `grundy = mex` over moves | the impartial-game / nimber semantics of a leaf |
| `grundy_iso` (Phase 4b)               | the Grundy *value* is iso-invariant (the analogue of `win_iso`)      | the oracle's iso-keyed per-component nimber memo (a cached nimber reused across isomorphic components) |
| `grundy_sum` (Phase 4b)               | no-edges-between-parts XOR: `grundy (S₁∪S₂) = grundy S₁ ^^^ grundy S₂` | the **gated/parked** component-nimber lever (`QUEENS_NIMBER_ORACLE`, default-OFF prototype in `iso_flat.rs`; parked `queens-component-nimber` branch) — **NOT** the default `getK` path or the n=18 verdict, which use only boolean win/loss |

(All theorems: `#print axioms` = `[propext, Classical.choice, Quot.sound]` only — no `sorryAx`, no `native_decide`.)

Reading: a Lean-verified `win` is the right recurrence (`win`); relabelling a child — which is
all `projected_code` does — cannot change the value (`win_iso`, `win_emb`); and the table build
that resolves each move's child by looking up a smaller relabelled graph computes exactly that
value (`buildPred_correct`), bottoming out at the empty graph (`not_win_empty`).

## Deferred to the differential tests (the serialization layer)

2-lite verifies the *recurrence/algorithm*, not the bit-twiddling — exactly as it leaves the
`pext`/BMI2 machinery to tests. The following are **not** modelled in Lean; they ride on the Rust
differential harness, which compares the optimised evaluator against the scalar reference Lean *did*
verify the semantics of:

- the u128 / 3-word **code bit-layout** and its decode (`adj_from_code` `:501`, `projected_code`
  `:516`, `extract_adj*`, the `pext` projections),
- the W8 build's pext fast path (`graph_wins8` `:561`).

Covered by: `direct_wK_matches_scalar_recurrence` (`dense.rs:1265`–1493, getK ≡ the scalar
reference across the layers) and `graph_wins8_matches_scalar` (`:1201`, the pext W8 build ≡
scalar `graph_wins`).

**Two scalar references, one recurrence.** `wins_rec` (`:584`) is the `u16`-coded reference,
so it caps at `k ≤ 16`. The **wide layers `get17`–`get20`** — which include the `get17`/`get18`
leaves the **n=18 verdict actually bottoms out on** — validate against `winsw_scalar`
(`dense.rs:1413`, tests `direct_w17..w20_matches_scalar_recurrence` `:1475`–1493). `winsw_scalar`
is the *same* recurrence shape (`child = alive & !((1<<i) | adj[i])`, "∃ a move to a loss"), just
on a wider code, so the general-`Fin k` Lean `win` underwrites **both** references — the Lean
result is not specific to the `k ≤ 16` path.

## Out of scope (not part of `getK`)

- the generic high-pc **α-β combination logic** above the dense ceiling (test-covered for n≤16),
- the lockless transposition table, concurrency, huge-page allocation,
- the **board→code build** (`att08`/`adj_row_pext`) — the queen-graph construction, an item-1/3
  boundary obligation (connecting getK to an actual board position).

## Residual trusted base after 2-lite

1. the code bit-serialization (item above) — trusted via the differential tests;
2. the generic high-pc α-β combination logic — trusted via the n≤16 lineage gate;
3. the **Lean ↔ Rust correspondence** — the Lean defs (`win`/`buildPred`-style) mirror
   `wins_rec`/`graph_wins` and are audited by eye. Auto-translation (Aeneas/Charon) is not viable
   here (pext intrinsics, const-generic monomorphisation, `get_unchecked`), so the transfer is a
   hand-checked correspondence, not a machine-checked end-to-end Rust proof.

## What would shrink the trusted base further (future)

- **Phase 3 `#eval` cross-check** — a computable `Bool` twin of `win` (the current `win` is `Prop`),
  `#eval`'d against dumped Rust `wins_rec` codes; needs the deferred concrete decode, so it also
  re-opens item 1 partially.
- **Phase 2′** — model the u128 bit-layout and prove `adj_from_code`/`projected_code` correct (the
  option-B path; removes item 1 from the trusted base at the cost of heavy bit-arithmetic).
- **Phase 4** — the Grundy/Sprague–Grundy layer. mathlib `v4.32` no longer ships `SetTheory/Game/`
  (`PGame`/`Impartial`/`grundyValue`/`Nimber` were extracted to the standalone `CombinatorialGames`
  package), so this is built **self-contained** rather than anchored to a now-absent mathlib `PGame`
  — consistent with Approach A's "minimal mathlib footprint" rationale. **Phase 4a (done):** `grundy`
  (= `mex` over moves) and `win_iff_grundy_ne_zero` (the P/N ↔ Grundy characterization). **Phase 4b
  (done):** `grundy_iso` (Grundy iso-invariance) and the component-XOR sum `grundy_sum`
  (`grundy (S₁∪S₂) = grundy S₁ ^^^ grundy S₂` when no edges run between the parts) — the
  Sprague–Grundy dividend (proposal item 3) that the gated/parked nimber lever uses (the binary
  `grundy_sum` + the obvious induction give the N-ary component XOR; `grundy_iso` covers the memo).
  **Blessed-semantics upgrade path (deferred, not declined — decision 2026-06-26):** anchoring
  `win`/`grundy` to a cited `Impartial`/`grundyValue` (so adequacy is a theorem, not self-asserted)
  needs `vihdzp/combinatorial-games` (the extraction target), which tracks Lean `v4.31.0-rc2` —
  behind our `v4.32.0-rc1`; adopting it would force a project downgrade (oleans are
  toolchain-specific). Deferred until that library bumps to ≥ `v4.32`; the concrete bridge plan
  (`toPGame` + `Impartial` instance + `win ↔ ¬(toPGame ≈ 0)`) is documented in `NodeKayles/Grundy.lean`'s
  header. Until then the adequacy of `win`/`grundy` rests on the standard-recurrence argument +
  literature values (P₃ = Grundy 2) + the Rust differential tests.
