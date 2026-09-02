# Ergodis private crate and binary consolidation proposal

**Date**: 2026-09-02
**Scope**: `ergodis-private/` (C1016 Hadamard-2092 work, complete-ports lane) and the
C1018/C1020/C1025/C1028/C1029 gem-mining binaries that share it. Proposal only; no code moved.

## Problem

- `ergodis-private` is one flat crate: a large lib of task-named modules (`g41_*`, `g53_*`,
  `q29_*`, `semantic_*`, …) plus 119 auto-discovered `src/bin/*.rs` files and six named `[[bin]]`
  targets. Cargo features carry task IDs (`c1018-sparse-action`, `c1018-lane-action`).
- 75 of the 119 bins are referenced by no note; most are superseded intermediate stages
  (shards, caches, corpora, scouts) whose result was banked in a sealed proof or report.
- The C1018 bins duplicate GF(2) linear algebra, integer arithmetic, and CSS helper functions
  across files.
- The boundary between reusable private machinery and one-off task drivers is invisible, so every
  new task adds another bin instead of a subcommand.

## Target layout

Cargo workspace rooted at `ergodis-private/`:

| Tier | Crate                   | Contents                                                                                   | Rule                                                                                       |
|------|-------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| 0    | `ergodis`               | Public core, unchanged (`papers/complete-repair-ports/ergodis`).                            | General algorithms only; C1016 never edits it.                                             |
| 1    | `ergodis-private`       | Library only. Hall core, proof synthesis, evolve adapters, feature DAG, quotient/PAF proofs, campaign RPC, and the lifted C1018 helpers (`gf2_linalg`, `arith`, `css_codes`, `prs`). | No task IDs in module or feature names. Anything copied into a second task module moves here in the same commit. |
| 2    | `tasks/hadamard-2092`   | One bin `hadamard` with subcommands per sector: `g41`, `g53`, `g91`, `g133`, `q18`, `q29`, `order6`, `evolve`, `proof`, each with its retained stages. | Task IDs appear only as module names (`c1016/…`) and subcommand docs.                      |
| 2    | `tasks/gem-hunt`        | One bin `gem-hunt` with `prs {deephole,census}`, `css {transversal,levels}`, `plane12 {starter,orbit,multiplier,sidon,hyperoval}`, `exterior-sets`, `prs-stratum`, `chain-ring`, `parametric-cert`. | Same rule.                                                                                 |
| 2    | `tasks/tools`           | The six named `[[bin]]` utilities (`hall-certify`, `projective-grid-scout`, …) plus `certdist`, `certiis`, `campaign_rpc` if they are CLI-only. | Lane-neutral operator tools.                                                               |

New rule for all future work: no new `src/bin` file anywhere in the workspace. A new C-task adds a
subcommand to its lane's tier-2 bin, and its shared flags (`--out`, `--threads`, `--seed`,
`--workspace-cap`) come from one common clap struct in tier 1.

## Triage for the 119 bins

Three buckets, decided per bin against the C1016 report and the sealed proof registry:

1. **Live replay path.** Referenced by a committed reproducibility bundle or by the current
   frontier (g41 q18 shell, q29 lift, deficit-tablebase join; g53 sparse q4 proof; g91 and g133
   sealed proofs; the blind evolve controls). Becomes a subcommand.
2. **Banked and superseded.** Its output is inside a sealed proof, a committed cache, or a report
   table, and nothing replays it. Deleted, with its last commit recorded in the old→new table so the
   bundle stays replayable at that commit.
3. **Dead exploration.** Unreferenced and its idea was rejected in the handoff (scalar duals,
   two-coordinate projections, SMT proposer, flat mod-16 image). Deleted, listed in the same table.

Reproducibility rule: dated reports are not rewritten. The consolidation note carries the
old command → new command table and the last commit containing each deleted file.

## Acceptance gates

- Every bucket-1 subcommand reproduces the committed certificate digest of the bin it replaces.
- `cargo test --workspace` and the serial all-target private suite pass.
- The performance gates from `ergodis/PERFORMANCE.md` (zero-allocation hot loops, counter A/B)
  hold for the moved kernels; moving a kernel into tier 1 is a file move, not a rewrite.
- Changed paths stay inside `ergodis-private/` and `notes/`.

## Suggested task split

1. gem-hunt crate and the C1018 helper lift (small, six bins plus four siblings).
2. Workspace creation and tier-1 lib-only split, moving the six named tools.
3. Hadamard-2092 crate: triage table first as a reviewable artifact, then the move, sector by
   sector (g133, g91, g53 first since they are sealed; g41/q18/q29 last since they are the live
   frontier).

Each needs its own C-ID; steps 1 and 3 belong to gem-mining and complete-ports respectively.
