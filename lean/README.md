# NodeKayles — Lean verification of the queens `getK` leaf evaluator

The 2-lite formal-verification effort scoped in
[`../notes/proposal-2026-06-26-getk-lean-verification.md`](../notes/proposal-2026-06-26-getk-lean-verification.md).
Goal: a machine-checked proof that the **scalar Node-Kayles recurrence** the dense
evaluator implements is the correct game value, plus the **W0..W8 base-table build**.
The pext/BMI2 `getK` then rides on the existing Rust differential tests
(`direct_wK_matches_scalar_recurrence`, `graph_wins8_matches_scalar`).

## Status

**Phase 1 — skeleton compiles** (Lean `v4.32.0-rc1` + mathlib, `lake build` green). The
`win` well-founded **termination proof is kernel-checked**; `win_iso` is the one remaining
`sorry`.

| Phase | Content                                                              | State                          |
|-------|---------------------------------------------------------------------|--------------------------------|
| 1     | `Graph`, `closedNbhd`, `win` (+ termination), `firstPlayerWins`      | ✔ compiles (termination proved) |
| 1     | `win_iso` (graph-iso invariance of the win value)                   | stated, `sorry` (in progress)  |
| 2     | `graphOfCode`, `graphWin`, `buildPred_correct`, `w8_table_correct`  | not started                    |
| 3     | trust-chain doc + Lean↔Rust `#eval` cross-check                      | not started                    |
| 4     | optional `PGame`/Sprague–Grundy bridge (→ items 1 & 3)              | not started                    |

## Correspondence to the Rust

`NodeKayles/Basic.lean` mirrors `../rust/src/queens/dense.rs`:

| Lean                | Rust (`dense.rs`)                         | meaning                          |
|---------------------|-------------------------------------------|----------------------------------|
| `win`               | `wins_rec` (`:584`)                        | `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])` |
| `closedNbhd G v`    | `full & !((1<<i) \| adj[i])`               | delete `{v} ∪ N(v)` (the move)   |
| `firstPlayerWins`   | `get(k, code)` over the full graph         | first player wins this position  |
| `graphOfCode` (P2)  | `adj_from_code` (`:501`)                   | decode upper-triangular `code`   |
| `buildPred` (P2)    | `graph_wins` (`:541`)                      | one ply of the W8 build          |

## Toolchain (nix flake + direnv)

elan downloads prebuilt, dynamically-linked Lean binaries. This box has **nix-ld**
enabled (`/lib64/ld-linux → nix-ld`), so `flake.nix`'s default dev shell just points
`NIX_LD`/`NIX_LD_LIBRARY_PATH` at a real glibc loader plus the libs Lean links (libstdc++,
gmp, zlib) — no FHS chroot, so it composes cleanly with direnv. `.envrc` enters it.

```sh
cd lean
direnv allow          # trust .envrc → builds the FHS dev shell, puts elan on PATH
                      # (or, without direnv: `nix develop`)

# first-time project setup, inside the shell:
lake update                                          # fetch mathlib (writes lake-manifest.json)
cp .lake/packages/mathlib/lean-toolchain ./lean-toolchain   # match mathlib's exact Lean
lake exe cache get                                   # download mathlib prebuilt oleans (the big step)
lake build                                           # build NodeKayles
```

Commit `lakefile.toml`, `lean-toolchain`, and `lake-manifest.json` (the version pin);
`.lake/` and `.direnv/` are gitignored. If `lake exe cache get` 404s on `master`, pin
`rev` in `lakefile.toml` to a recent mathlib tag and re-run `lake update`.

On a box *without* nix-ld, use the FHS fallback shell: `nix develop .#fhs` (it supplies
the loader via an FHS chroot, but composes with direnv less transparently).
