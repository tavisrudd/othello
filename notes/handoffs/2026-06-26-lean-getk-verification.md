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

Core recurrence and graph-bridge theorems live in `lean/NodeKayles/Basic.lean`; the certificate
kernel is in `lean/NodeKayles/Certificate.lean`; the self-contained Grundy and component-XOR layer is
in `lean/NodeKayles/Grundy.lean`. See `lean/TRUST.md` for the full Lean↔Rust map.

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
the Grundy layer **self-contained**.

**Blessed-semantics fork RESOLVED (2026-06-26): stay self-contained, document the upgrade path.**
The extraction target is `vihdzp/combinatorial-games`; as of 2026-06-09 (commit #419) it tracks
Lean **v4.31.0-rc2** + mathlib `acbd8f07`, *behind* our **v4.32.0-rc1** + `571b8a8e`. Since Lean
oleans are toolchain-specific, adopting it now would force a project **downgrade** (re-pin
toolchain + mathlib, re-fetch oleans, re-verify the proofs) — undoing the clean pinned state for a
slightly-older Lean. User chose to keep the self-contained layer and **document why + the upgrade
path in the proof code** (`lean/NodeKayles/Grundy.lean` header has the full `toPGame`/`Impartial`/
bridge plan; mirrored in TRUST.md Phase 4). Revisit when the library bumps to ≥ v4.32.

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
| Node-Kayles recurrence / graph bridge | `lean/NodeKayles/Basic.lean` |
| Certificate kernel | `lean/NodeKayles/Certificate.lean` |
| Grundy and component-XOR layer | `lean/NodeKayles/Grundy.lean` |
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
- [x] Phase 4b — `grundy_iso` (Grundy value iso-invariance) + Sprague–Grundy component-XOR sum `grundy_sum` (kernel-complete, axioms clean)
- [x] Adversarial review — 3 rounds (integrity / faithfulness / correspondence / math / repro): proofs SOUND; all findings were doc-accuracy + repro hygiene, fixed
- [ ] Phase 3 (`#eval`) — computable `Bool` twin + Lean↔Rust cross-check (needs Phase 2′)
- [ ] Phase 2′ — bit-exact u128 code decode (option B)
- [ ] Phase 4 (blessed-semantics `PGame` bridge) — DEFERRED (decision 2026-06-26): the target lib
  `vihdzp/combinatorial-games` tracks Lean v4.31.0-rc2 (behind our v4.32.0-rc1) ⇒ would force a
  project downgrade. Staying self-contained; upgrade path + bridge plan documented in
  `lean/NodeKayles/Grundy.lean` header + TRUST.md. Revisit when the lib bumps to ≥ v4.32.

## Handoff Notes

### Phase 4 (self-contained Grundy) + 3-round adversarial review (2026-06-26)

**Session**: 2026-06-26--1 (`a9c933b4-0ad9-4d95-b63d-26ab2a6d0132`)
**Commits** (on `main`): `017e2c2` (4a), `b60d26f` (4b sum), `f06439b` (R1 doc fixes),
`cef97dd` (R2 doc fixes), + this session's R3 fixes (grundy_iso, repro pin, proposal banner).
**Completed**:
- **Discovered mathlib v4.32 REMOVED `SetTheory/Game/`** (`PGame`/`Impartial`/`grundyValue`/
  `Nimber` → standalone `CombinatorialGames` pkg). So the proposal's Approach-B/Phase-4 PGame
  bridge is unavailable without that dep. Chose (intent-based, matches Approach-A rationale) to
  build the Grundy layer **self-contained**.
- **Phase 4 (`NodeKayles/Grundy.lean`), all `sorry`-free / `lake build` green / axioms =
  `[propext, Classical.choice, Quot.sound]`:** `mex` (least-excludant via `Nat.find` +
  `Infinite.exists_notMem_finset`); `grundy` (mex over children, WF on `S.card`);
  **`win_iff_grundy_ne_zero`** (P/N ↔ Grundy); the abstract **`mex_xor_union`** nim-mex core
  (on mathlib's `Nat.lt_xor_cases` — no hand-rolled bit arithmetic); **`grundy_sum`** (component
  XOR for no-edges-between parts, WF on `(S₁∪S₂).card`); **`grundy_iso`** (Grundy value
  iso-invariance, analogue of `win_iso`). `grundy_eq_mex_image` is the subtype-free `mex` form.
- **3 rounds of adversarial subagent review.** R1 (integrity/faithfulness/correspondence):
  proofs airtight (all 26 decls clean axioms, no `sorry`/`native_decide`/disabled-checks,
  termination genuine, defs non-vacuous). R2 (correspondence deep-dive + math adequacy): all 4
  correspondence attacks FAITHFUL; **`win`/`grundy` reproduce literature Node-Kayles values
  (isolated-vertex parity, P3 Grundy = 2 = Dawson's chess A002187, machine-checked)**. R3 (stale
  docs / repro / completeness). **No proof/correspondence defect found** — every finding was
  doc-accuracy or repro hygiene.
**Fixes applied from review:** (1) `closedNbhd` polarity in the correspondence tables — the docs
had mislabelled `closedNbhd G v` (the DELETED set `(1<<i)|adj[i]`) as `full & !(…)` (the
COMPLEMENT / surviving child); split into correct rows (Basic.lean, TRUST, README — README's was
missed in R1, caught in R3). (2) `grundy_sum`/`grundy_iso` scoped as the **gated/parked**
component-nimber lever (`QUEENS_NIMBER_ORACLE` default-OFF + parked branch), NOT the live
`getK`/n=18 path. (3) `buildPred_correct` "whole table build" softened to one-ply graph-level
(decode/arena deferred). (4) named `winsw_scalar` (`dense.rs:1413`) as the wide-layer reference
the n=18 get17/get18 leaves actually validate against (`wins_rec`:584 caps at k≤16). (5) "edge-
disjoint" → "no edges between the parts". (6) **proposal annotated SUPERSEDED** (it still sold a
`Bool` `win` / executable oracle + mathlib `PGame`). (7) **repro pin**: lakefile `rev` master →
`571b8a8e…` + manifest `inputRev` matched (no more "manifest out of date" warning); README setup
split into checkout (no `lake update`) vs bootstrap.
**Build/verify recipe**: `cd lean && nix develop . --command bash -c 'lake build'` (~3-8s,
mathlib cached). Axiom check: `lake env lean <file with #print axioms>`.
**Notes for next**: remaining open items are Phase 2′ (bit-exact decode) and Phase 3 (`#eval`
twin, needs 2′) — both partly re-open the deferred serialization layer; lower priority. The
mathlib-`PGame` bridge is a user fork (add `CombinatorialGames` dep vs stay self-contained — we
chose self-contained and it's now complete: win/grundy/iso/sum). Gotcha banked: a lambda's
`(v : Fin k)` ascription forces `v : Fin k` (use `v.val`/`↑v` to coerce a subtype).

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
