# Lean verification of the `getK` leaf evaluator (2-lite) — implementation handoff

**Date**: 2026-06-26
**Session**: 2026-06-25--1 (`f7e8161c-a405-4437-9122-7f2a12618209`)
**References**:
- Design: [`notes/proposal-2026-06-26-getk-lean-verification.md`](../proposal-2026-06-26-getk-lean-verification.md) (Approach A recommended)
- Trust chain: [`rust/../lean/TRUST.md`](../../lean/TRUST.md) · status: [`lean/README.md`](../../lean/README.md)
- Target Rust: `rust/src/queens/dense.rs` (`wins_rec`, `graph_wins`, `projected_code`, getK)
- Origin discussion: this thread answered "how hard would a Lean proof of the n=18 solver be" → scope = the getK leaf evaluator, 2-lite tier.

## Context

The n=18 verdict bottoms out, for ~21%+ of search nodes, in the **`getK` dense leaf
evaluator** (`dense.rs`): every position with `pc ≤ dense_k` is resolved directly as a
Node-Kayles win/loss. It's where the one historical defect of this class lived (the `u8`
truncation, `cddfc64`). **2-lite** = machine-check the *recurrence/algorithm semantics* of
getK while leaving the `pext`/bit-serialization to the existing Rust differential tests.

A standalone Lean 4 + mathlib project lives in **`lean/`** (a Lake project, reproducible via
nix flake + direnv). Phases 1 & 2 are **complete, committed, and `sorry`-free**.

## Key architecture decisions

- **Approach A (self-contained inductive), not the mathlib `PGame` bridge.** `win` is a
  computable-in-spirit `Prop` recurrence we own; `PGame`/Sprague–Grundy anchoring is the
  optional Phase 4. Rationale: smallest dependency surface, delivers the full assurance, and
  is a strict prefix of the `PGame` route. (Proposal §Recommendation.)
- **Phase 2 = option A (graph-level build correctness), bit-decode deferred.** `buildPred_correct`
  is proved over `Graph`s (children = induced subgraphs via `Finset.orderEmbOfFin`); the u128
  code bit-layout (`adj_from_code`/`projected_code`) rides on the differential tests, consistent
  with 2-lite leaving `pext` to tests. (User chose A over the bit-exact option B.)
- **`win` is `Prop`, not `Bool`.** Lean's well-founded-recursion-through-a-`Bool`-combinator
  friction (`Finset.attach.any` doesn't exist) made `Prop` (`∃ v : S, ¬ win …`) the clean form;
  it's all `win_iso`/`win_emb` need. A computable `Bool` twin is deferred to Phase 3's `#eval`.
- **nix-ld dev shell, not FHS.** The box has nix-ld; a plain `mkShell` + `NIX_LD*` composes with
  direnv (the FHS chroot does not). Toolchain pinned to mathlib master's `lean-toolchain`
  (`v4.32.0-rc1`) via `flake.lock` + `lake-manifest.json`.

## Status — what is proved (no `sorry`)

All in `lean/NodeKayles/Basic.lean`; see `lean/TRUST.md` for the full Lean↔Rust map.

| Lean | establishes | Rust |
|------|-------------|------|
| `win` + termination     | the P/N recurrence is well-defined          | `wins_rec` (`:584`)      |
| `win_iso`               | invariance under same-size relabelling      | labelled-code freedom    |
| `win_emb`               | invariance under induced-subgraph relabel   | `projected_code` (`:516`) |
| `buildPred_correct`     | the build recurrence = true value           | `graph_wins` (`:541`)    |
| `not_win_empty`         | terminal = loss                             | `W0` base                |
| helpers                 | `closedNbhd_map`, `childmap_emb`, `sdiff_closedNbhd_ssubset`, `inducedGraph`, `firstPlayerWins_inducedGraph`, `univ_map_orderEmbOfFin` | — |

Commits on `main`: `6ab6dc4` (skeleton+termination+proposal), `27cfa12` (`win_iso`),
`eab53aa` (`win_emb`), `d7d61e7` (`buildPred_correct`), plus `TRUST.md` + this handoff.

## ⚠ mathlib changed: `PGame` is GONE from mathlib (2026-06-26 finding)

mathlib `v4.32.0-rc1` (our pin) **no longer contains `SetTheory/Game/`** — `PGame`,
`Impartial`, `grundyValue`, and `Nimber` were extracted to the standalone
**`CombinatorialGames`** package (which we do not depend on). The proposal's Approach-B /
Phase-4 plan ("anchor `win` to mathlib's blessed `PGame` semantics") is therefore **not
available without adding that external dep**. Decision taken (intent-based, ≥80/20, matches
the documented Approach-A rationale of "minimal mathlib footprint, no version churn"): build
the Grundy layer **self-contained**. If the user wants the *blessed-semantics* anchoring
specifically, the fork is: add `CombinatorialGames` as a Lake require, vs. stay self-contained.

## Remaining work (clearly scoped, independent)

- **Phase 4a — self-contained Grundy characterization — ✅ DONE** (`NodeKayles/Grundy.lean`).
  `mex` (least-excludant via `Nat.find` + `Infinite.exists_notMem_finset`), `grundy` (= `mex`
  over the children's Grundy values, same WF recursion as `win`), and `win_iff_grundy_ne_zero`
  (the textbook P/N ↔ Grundy fact: `win ⇔ grundy ≠ 0`). `sorry`-free, `lake build` green.
- **Phase 4b — Sprague–Grundy component-XOR sum — ✅ DONE** (`grundy_sum` in `NodeKayles/Grundy.lean`).
  `grundy G (S₁ ∪ S₂) = grundy G S₁ ^^^ grundy G S₂` for edge-disjoint parts (`Disjoint S₁ S₂` +
  no `G`-edge between them). Built on the abstract nim-mex `mex_xor_union` (`mex ({x^^^mexB | x∈A}
  ∪ {y^^^mexA | y∈B}) = mexA ^^^ mexB`), which used mathlib's `Nat.lt_xor_cases`/`xor_trichotomy`
  (no hand-rolled bit arithmetic needed). WF recursion on `(S₁∪S₂).card`; a move in one part leaves
  the other intact. **`#print axioms grundy_sum` = `[propext, Classical.choice, Quot.sound]`** —
  kernel-complete, no `sorryAx`/`native_decide`. This is the soundness of the solver's
  component-nimber decomposition.
- **Phase 3 — `#eval` cross-check** (optional). Define a computable `Bool` twin `winB` (same
  recurrence returning `Bool`) + prove `winB ↔ win`; `#eval` it against dumped Rust `wins_rec`
  outputs. **Needs the concrete decode (Phase 2′)** to turn a Rust `code` into a Lean `Graph`,
  so it partly re-opens option B. Lower priority; the trust-chain doc (Phase 3's main deliverable)
  is **done** (`lean/TRUST.md`).
- **Phase 2′ — bit-exact decode** (option B). Model `code : ℕ` with the upper-triangular bit
  layout; prove `adj_from_code`/`projected_code` implement the abstract ops. Heavy Nat-bit
  arithmetic; removes the serialization from the trusted base. Only if directness is wanted.

## Codebase reference

| What | Where |
|------|-------|
| All Lean theorems | `lean/NodeKayles/Basic.lean` |
| Trust-chain doc | `lean/TRUST.md` |
| Project status / build steps | `lean/README.md` |
| Scalar spec (mirror target) | `dense.rs:584` `wins_rec`, `:541` `graph_wins`, `:516` `projected_code`, `:501` `adj_from_code` |
| Differential tests (the deferred layer) | `dense.rs:1265`–1493 `direct_wK_matches_scalar_recurrence`, `:1201` `graph_wins8_matches_scalar` |

## Build / test

The Lean project is **separate from the Rust Makefile**. From `lean/`:
```sh
direnv allow            # first time: enters the nix-ld dev shell (elan on PATH)
lake build              # builds NodeKayles; mathlib is cached (~3s for Basic.lean)
```
Non-direnv equivalent: `nix develop /home/tavis/src/othello/lean --command bash -c 'lake build'`.
`.lake/` and `.direnv/` are gitignored; `lean-toolchain`/`flake.lock`/`lake-manifest.json` are
committed (the version pin). A green `lake build` with **no `sorry` warning** is the gate.

## Delegation strategy

- **Phase 2′ / Phase 4**: Opus (intricate proofs, design). Not delegable to Sonnet — each is a
  research-grade Lean proof with mathlib-API discovery and architectural shape.
- **Phase 3 `#eval`**: Opus for the `winB`/bridge proof; the dump+compare scaffolding is mechanical.
- **Build iterations**: fast (~3s); iterate inline rather than via a Bash sub-agent.

## Workflow

Read this file + `lean/TRUST.md` + the proposal first. The verification is value-add and
**not on the n=18 critical path** — n=18 is solved and claimed; this hardens the leaf evaluator's
trusted base. Pick up at "Remaining work"; each item is independent. Update Progress + add a
Handoff Note (with session ID) per session.

## Progress

- [x] Phase 1 — `win` + termination, `win_iso`
- [x] Phase 2 — `win_emb` (induced-subgraph invariance), `buildPred_correct`, `not_win_empty`
- [x] Phase 3 (doc) — trust-chain `lean/TRUST.md`
- [x] Phase 4a — self-contained Grundy: `mex`, `grundy`, `win_iff_grundy_ne_zero` (`NodeKayles/Grundy.lean`)
- [x] Phase 4b — Sprague–Grundy component-XOR sum `grundy_sum` (kernel-complete, axioms clean)
- [ ] Phase 3 (`#eval`) — computable `Bool` twin + Lean↔Rust cross-check (needs Phase 2′)
- [ ] Phase 2′ — bit-exact u128 code decode (option B)
- [ ] Phase 4 (mathlib `PGame` bridge) — UNAVAILABLE in mathlib v4.32 (extracted to `CombinatorialGames`); fork to user

## Handoff Notes

### Phases 1 & 2 + trust-chain doc (2026-06-26)

**Session**: 2026-06-25--1 (`f7e8161c-a405-4437-9122-7f2a12618209`)
**Completed**: Stood up the `lean/` Lake project from scratch on this NixOS box (nix flake +
direnv, nix-ld dev shell, Lean v4.32.0-rc1 + mathlib). Proved Phases 1 & 2 of the 2-lite getK
verification — five core theorems, `sorry`-free, `lake build` green. Wrote `lean/TRUST.md`.
**Files created**: `lean/{flake.nix,flake.lock,.envrc,lakefile.toml,lean-toolchain,.gitignore,
README.md,TRUST.md}`, `lean/NodeKayles.lean`, `lean/NodeKayles/Basic.lean`,
`notes/proposal-2026-06-26-getk-lean-verification.md`.
**Deviations**: `win` ended up `Prop` not `Bool` (WF-recursion friction); Phase 2 done at the
graph level (option A), bit-decode deferred — both deliberate, recorded above.
**Notes for next**: build iterations are ~3s once mathlib is cached. Lean-API gotchas hit this
session: the bounded `∃ v ∈ S` desugars to a conjunction so the membership isn't in the
termination context — bind over the subtype `∃ v : S` instead; unfold WF defs with `win.eq_def`
(not `rw [win]`); `Finset.not_mem_empty` is renamed (use `simp`). The Phase-3 `#eval` and Phase
2′ are coupled (both want the concrete decode) — do them together if pursued.
