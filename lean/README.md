# NodeKayles — Lean verification of the queens `getK` leaf evaluator

The 2-lite formal-verification effort scoped in
[`../notes/proposal-2026-06-26-getk-lean-verification.md`](../notes/proposal-2026-06-26-getk-lean-verification.md).
Goal: a machine-checked proof that the **scalar Node-Kayles recurrence** the dense
evaluator implements is the correct game value, plus the **one-ply (graph-level) `W_K`
build recurrence**. The concrete table indexing / arena read / u128 `code` decode and the
pext/BMI2 `getK` ride on the existing Rust differential tests
(`direct_wK_matches_scalar_recurrence`, `graph_wins8_matches_scalar`). The Lean↔Rust
correspondence itself (the Lean defs mirror `wins_rec`/`graph_wins`) is hand-audited, not
machine-checked end-to-end — see `TRUST.md`.

## Status

**Phases 1 & 2 (graph-level) — COMPLETE** (Lean `v4.32.0-rc1` + mathlib, `lake build`
green, **no `sorry`**). The Node-Kayles win predicate, its termination, the isomorphism /
induced-subgraph invariances, and the one-ply `W_K` build recurrence are all machine-checked.
The u128 bit-packing of the code, the table indexing, and the arena read are the deferred
serialization layer (rides on the Rust differential tests `direct_wK_matches_scalar` /
`graph_wins8_matches_scalar`, per 2-lite).

| Phase | Content                                                              | State                          |
|-------|---------------------------------------------------------------------|--------------------------------|
| 1     | `Graph`, `closedNbhd`, `win` (+ termination), `firstPlayerWins`      | ✔ proved                       |
| 1     | `win_iso` (graph-iso invariance) + `closedNbhd_map`, `sdiff_…_ssubset` | ✔ proved                     |
| 2     | `win_emb` / `childmap_emb` (induced-subgraph invariance = `projected_code` soundness) | ✔ proved      |
| 2     | `inducedGraph`, `firstPlayerWins_inducedGraph`, `buildPred_correct`, `not_win_empty` (`W_K` build) | ✔ proved      |
| 2′    | concrete u128 code decode (`adj_from_code`/`projected_code` bit layout) | deferred → differential tests |
| 3     | trust-chain doc (`TRUST.md`) ✔; Lean↔Rust `#eval` cross-check       | doc done; `#eval` not started  |
| 4a    | self-contained Grundy: `mex`, `grundy`, `win_iff_grundy_ne_zero` (`NodeKayles/Grundy.lean`) | ✔ proved          |
| 4b    | `grundy_iso` (Grundy value iso-invariance, analogue of `win_iso`) + Sprague–Grundy component-XOR sum `grundy_sum` (`grundy (S₁∪S₂) = grundy S₁ ^^^ grundy S₂` when no edges run between the parts, → item 3) | ✔ proved (hardens the *gated/parked* nimber lever, not the default `getK`/n=18 path) |

All theorems depend only on `[propext, Classical.choice, Quot.sound]` (`#print axioms`) — no
`sorryAx`, no `native_decide`, no custom axioms; kernel-complete.

mathlib `v4.32` **no longer ships `SetTheory/Game/`** (`PGame`, `Impartial`, `grundyValue`,
`Nimber` were extracted to the standalone `CombinatorialGames` package). So Phase 4 is built
**self-contained** rather than anchored to a now-absent mathlib `PGame` — which is exactly the
"minimal mathlib footprint, no version churn" rationale Approach A was chosen for.

## Correspondence to the Rust

`NodeKayles/Basic.lean` mirrors `../rust/src/queens/dense.rs`:

| Lean                | Rust (`dense.rs`)                         | meaning                          |
|---------------------|-------------------------------------------|----------------------------------|
| `win`               | `wins_rec` (`:584`, `#[cfg(test)]` scalar ref) | `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])` |
| `closedNbhd G v`    | `(1<<i) \| adj[i]` (the *deleted* set)      | delete `{v} ∪ N(v)` (the move)   |
| `S \ closedNbhd G v`| `full & !((1<<i) \| adj[i])` (the child)    | the surviving live set after the move |
| `firstPlayerWins`   | `get(k, code)` over the full graph         | first player wins this position  |
| `graphOfCode` (P2)  | `adj_from_code` (`:501`)                   | decode upper-triangular `code`   |
| `buildPred` (P2)    | `graph_wins` (`:541`)                      | one ply of the W8 build          |
| `grundy` (P4a)      | per-node nimber / `mex` over moves         | Grundy value of a position       |

## Toolchain (nix flake + direnv)

elan downloads prebuilt, dynamically-linked Lean binaries. This box has **nix-ld**
enabled (`/lib64/ld-linux → nix-ld`), so `flake.nix`'s default dev shell just points
`NIX_LD`/`NIX_LD_LIBRARY_PATH` at a real glibc loader plus the libs Lean links (libstdc++,
gmp, zlib) — no FHS chroot, so it composes cleanly with direnv. `.envrc` enters it.

```sh
cd lean
direnv allow          # trust .envrc → builds the FHS dev shell, puts elan on PATH
                      # (or, without direnv: `nix develop`)

# Building an EXISTING checkout (the normal case — manifest is committed & pinned):
lake exe cache get    # download mathlib prebuilt oleans for the pinned rev
lake build            # build NodeKayles
# Do NOT run `lake update` on a checkout — it re-resolves mathlib to current master
# (which needs a newer toolchain than the pinned RC) and defeats the version pin.

# First-time BOOTSTRAP only (already done; recorded for provenance):
#   lake update                                       # resolve mathlib → writes lake-manifest.json
#   cp .lake/packages/mathlib/lean-toolchain ./lean-toolchain   # match mathlib's exact Lean
#   lake exe cache get && lake build
```

Commit `lakefile.toml`, `lean-toolchain`, and `lake-manifest.json` (the version pin);
`.lake/` and `.direnv/` are gitignored. If `lake exe cache get` 404s on `master`, pin
`rev` in `lakefile.toml` to a recent mathlib tag and re-run `lake update`.

On a box *without* nix-ld, use the FHS fallback shell: `nix develop .#fhs` (it supplies
the loader via an FHS chroot, but composes with direnv less transparently).
