# Untracked-path citation sweep (2026-09-13)

**Lane**: audit/documentation. Companion to `notes/2026-09-13-cache-citation-audit.md`, which
classified the infractions; this file records the repair of each one.

## Rule enforced

A research report must never cite an untracked local file as evidence, as a replay input, or as a
row in a hash-bearing bundle. Untracked means anything under `~/.cache`, under `/tmp` other than
the ZFS-backed `/tmp/persistent`, or a session scratchpad path. Naming such a path as a workspace
convention — where builds, worktrees, module caches or server PID/log files live — is not an
infraction and was left alone, as were lines the audit classified as `convention` or
`audit finding`.

## Repairs applied, by class

| Class                | Repair written into the report                                                                                              |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `run-quiet log`      | The gate command plus the commit it ran at. The `/tmp/claude-run-quiet/` directory is dropped, not described.                |
| `Lean build run`     | The committed Lean module(s) and the commit. The `~/.cache/othello-lean-build/run-*` path is dropped.                        |
| `retained binary`    | Repository, source commit (from the binary's `-<sha>` suffix, confirmed against `bin/MANIFEST.tsv`) and the build recipe.    |
| `build product`      | The commit plus the `cargo build`/`cargo run` invocation; the shared target directory stays a convention, not a citation.    |
| `cache data/report`  | The committed copy plus its SHA-256 where the output survived and was small and textual; otherwise a plain statement that the raw output was not retained, citing the tracked generator and the committed summary. |
| `session scratchpad` | The tracked generator and commit, or a `/tmp/persistent/tavis/lit-search/` cache key.                                        |
| `temp file`          | A tracked input/output path, or a statement that the comparison output was not retained.                                     |

A cache garbage collection ran on 2026-09-13 (`~/.cache/ergodis/gc.log`) and removed many
top-level measurement directories. Nothing was restored; where the raw output was gone, the report
now says so instead of citing it.

## Scope

- `~/src/othello`: the 86 `notes/` files the audit listed as needing edits, less the three already
  repaired before the audit (`notes/2026-09-13-c1183-ranked-certificate.md`,
  `notes/2026-09-13-c1184-direct-checker.md`, `notes/2026-09-13-c1186-presence-bitmap.md`).
- `~/src/ergodis-private`: the 41 `analysis/`, `evidence/` files the audit listed.
- `~/src/ergodis` (the public core) was **not** touched: another session owns it. The audit's one
  finding there — literal `~/.cache/ergodis/bin/rule-replay-*` paths in
  `evidence/2026-09-12-rule-frontier-ab.json` — remains open and belongs to that session.

## Commits

- `~/src/othello`: see the closing commit of this sweep (all 86 edited `notes/` files, the three
  committed evidence-copy directories it produced, and this report). Excludes
  `notes/2026-09-13-c1185-certificate-size-exploration.md`, which another session is writing.
- `~/src/ergodis-private`: one companion commit over the 41 edited `analysis/`/`evidence/` files
  plus the one new committed evidence copy. Excludes every non-Markdown file and
  `analysis/interface-review/adr-shared-memory-execution-and-telemetry.md`, all foreign to this
  sweep.

## Per-file progress

Rows are appended as each slice of the sweep completes.

| File | Infractions fixed | Skipped, with reason |
|------|-------------------|----------------------|
| notes/2026-07-07-codex-task-queue-archive.md | 1 | - |
| notes/2026-09-10-c1133-cold-referee-response.md | 2 | - |
| notes/2026-09-10-c1133-reconstruction-transcription-repair.md | 1 | - |
| notes/2026-09-08-cubic-post-upgrade-cold-read.md | 1 | - |
| notes/2026-09-07-c1118-rank-four-cox-descent.md | 2 | - |
| notes/2026-09-07-c1117-additive-spectrum-extension.md | 2 | - |
| notes/2026-09-07-c1116-cubic-foundations-audit.md | 2 | - |
| notes/2026-09-07-cubic-pair-cold-read.md | 2 | - |
| notes/2026-09-07-c1120-stabilization-corollaries.md | 4 | - |
| notes/2026-09-07-c1119-finite-index-torus-slices.md | 2 | - |
| notes/2026-09-07-cubic-pair-exposition-and-notation.md | 2 | - |
| notes/2026-09-10-c1137-ame-lu-draft-ab.md | 1 | - |
| notes/2026-09-10-c1138-ame-lu-second-referee.md | 2 | - |
| notes/2026-09-11-c1142-sharpness-exposition.md | 1 | - |
| notes/2026-09-11-c1140-integration.md | 2 | - |
| notes/2026-09-11-c1141-literature-audit.md | 1 | - |
| notes/2026-09-07-c1100-domain-bound-transitions.md | 1 | - |
| notes/2026-09-07-c1101-portable-run-records.md | 1 | - |
| notes/2026-09-07-c1103-offline-run-bundles.md | 1 | - |
| notes/2026-09-07-c1105-offline-browser-inspection.md | 1 | - |
| notes/2026-09-07-c1106-offline-verification-forks.md | 1 | - |
| notes/2026-09-07-c1107-repository-contract.md | 1 | - |
| notes/2026-09-07-c1084-portable-control-architecture.md | 1 | - |
| notes/2026-09-07-c1088-browser-campaign-control.md | 3 | - |
| notes/2026-09-07-c1123-repository-analysis.md | 2 | - |
| notes/2026-09-07-c1125-portable-console.md | 2 | - |
| notes/2026-09-07-c1126-campaign-information-architecture.md | 2 | - |
| notes/2026-09-07-c1121-demo-usability.md | 1 | - |
| notes/2026-09-07-c1122-first-visit-demo.md | 1 | - |
| notes/2026-09-07-c1124-real-campaign-console.md | 1 | - |
| notes/2026-09-07-c1033-saved-run-notebook.md | 1 | - |
| notes/2026-09-08-c1131-selective-manuscript-upgrades.md | 1 | - |
| notes/2026-09-07-c1094-core-composition-admission.md | 1 | - (the leftover explicitly flagged at handoff) |
| notes/2026-09-10-c1130-stop-responsiveness.md | 1 | - |
| notes/2026-09-13-c1179-datalog-closure-ballpark.md | 1 | - |
| notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md | 1 | - |
| notes/2026-09-08-c1130-capacity-design.md | 1 | - |
| notes/2026-09-08-c1130-module-loading-results.md | 2 | - |
| notes/2026-09-08-c1130-scheduling-and-direct-inputs.md | 2 | - |
| notes/2026-09-10-c1130-solve-clock-axis.md | 3 | - |
| notes/2026-09-12-c1160-verifier-stability.md | 1 | - |
| notes/2026-09-13-c1182-demand-driven-datalog.md | 3 | - |
| notes/ergodis-discovery-track.md | 1 | - |

The remaining 55 audited files were already modified by the stopped agent. Each was re-verified
by rereading the infraction's surrounding text and confirming against
`notes/2026-09-13-cache-citation-audit.md`'s verdict for that line; none needed further edits here.

| File | Infractions (verified already fixed) | Skipped, with reason |
|------|----------------------------------------|----------------------|
| notes/2026-09-12-c1153-group-quotient-spike.md | 17 | - |
| notes/2026-09-07-c1111-reconstruction-contract-corpus.md | 3 | - |
| notes/2026-09-08-c1130-evolve-progress-view.md | 2 | - |
| notes/2026-09-08-c1130-application-wasm-workspace.md | 1 | - |
| notes/2026-09-08-c1130-wasm-evolve-reductions.md | 2 | - |
| notes/2026-09-08-c1129-runnable-domain-lab.md | 3 | - |
| notes/2026-09-07-c1099-cubic-phase-strengthening/REPORT.md | 1 | - |
| notes/2026-09-07-c1112-extension-fields-and-incidence-dispatch.md | 1 | - |
| notes/2026-09-12-c1152-certificate-spike.md | 1 | - |
| notes/2026-09-07-c1090-resource-classification/REPORT.md | 2 | - |
| notes/2026-09-08-c1130-larger-workloads-live-surfaces.md | 2 | - |
| notes/2026-09-07-c1084-portable-control-architecture.md (second infraction row) | 1 | - |
| notes/2026-09-11-c1149-ergodis-public-release-review.md | 5 | - |
| notes/2026-07-07-codex-task-queue-archive.md (second infraction row) | 1 | - |
| notes/2026-09-06-c1089-literature-ame-marginals-slocc.md, c1080-admission-pilot.md, c1081-language-semantics.md, c1082-scalar-semantics.md, c1083-campaign-transitions.md, c1085-portable-scalar-language.md, c1086-independent-verification.md, c1087-portable-campaign-runtime.md, c1092-query-specialization-corpus.md, c1093-dynamic-query-admission.md, c1095-observable-admission.md, c1096-leaf-update-admission.md, c1097-independent-summary-transitions.md, c1098-certificate-authority-migration.md, c1110-continuation-cold-referee.md, c1110-continuation-layering-review.md, complete-ports-layered-exposition.md, complete-ports-referee-repair.md, cubic-threefold-lean-stabilization.md, c1130-private-module-legal-notice.md, c1133-lean-parameterized-progress.md, c1133-lean-rank-three-progress.md, c1133-lean-super-progress.md, c1133-lean-transport-progress.md, c1133-lean-selector-comparison.md, c1133-lean-trust-review.md, c1161-recursive-runtime.md, c1163-rule-contract.md, c1164-lean-oracle.md, paper-i-release-continuation.md, c1172-lean-audit-gate.md (31 files, all dated 2026-09 in `notes/`) | all | already fully repaired before this session started; confirmed via the final aggregate `rg` sweep (zero infraction-pattern matches outside convention/audit-finding lines) |

## Facts that could not be determined

- `notes/2026-09-07-c1126-campaign-information-architecture.md` names no implementation commit in
  any repository, so the browser gates are pinned to `6bb927b`, the othello commit that introduced
  the report.
- `notes/2026-09-07-c1084-portable-control-architecture.md` gives no tracked path for
  `cache-gc.sh`, so the repaired line names the command and the report's own commit `6269cd1`.
- The screenshot, mockup and run directories cited by the C1033, C1088, C1121, C1122, C1123,
  C1124, C1125 and C1126 reports were either deleted by the 2026-09-13 cache garbage collection or
  are binary PNG sets too large to commit. Those reports now state that the raw output was not
  retained and cite the committed browser test or generator instead.
- `ergodis-private/analysis/interface-review/2026-09-11-hadamard-larger-orders.md`'s retained
  executable `williamson-even-catalog-20260911` still exists on disk (SHA-256
  `4fe5c1a75bc94fe558ce171c953be9e79198070e2b565ac2066383d77c3a5278`, confirmed) but carries no
  `MANIFEST.tsv` entry and no commit is named anywhere in the report; the repaired line states the
  verified SHA-256 and says plainly that the source commit could not be confirmed.
- Two retained harnesses named `nix-<sha>` in `ergodis-private/analysis/datalog-comparison/` were
  built from a **dirty** working tree at commits `a774bda` and `77aa137` per `bin/MANIFEST.tsv`
  (`dirty` column); the repaired citations say "dirty tree" rather than implying a clean,
  reproducible commit.

## Per-file progress: `~/src/ergodis-private`

None of the 41 audited files had a progress-table row before this session; the stopped agent had
not yet started this repository. All 41 were opened individually this session.

| File | Infractions fixed | Skipped, with reason |
|------|-------------------|----------------------|
| analysis/interface-review/2026-09-10-race-chart-visual-review.md | 1 | - |
| analysis/interface-review/2026-09-09-js-race-review.md | 1 | - |
| analysis/interface-review/2026-09-09-residual-charge-discovery.md | 1 | - |
| analysis/interface-review/2026-09-10-css-packed-dispatch.md | 1 | - |
| analysis/interface-review/2026-09-10-css-root-scaling.md | 1 | - |
| analysis/interface-review/2026-09-11-hadamard-larger-orders.md | 1 | - |
| analysis/interface-review/2026-09-10-specialized-transfer-review.md | 1 | - |
| analysis/interface-review/2026-09-10-harder-profile-workloads.md | 3 | - |
| analysis/campaign-console/data/README.md | 1 | - |
| analysis/repository-projection.md | 1 | - |
| analysis/rel-frontend/README.md | 1 | - |
| analysis/interface-review/2026-09-10-family-substitution-integration.md | 2 | - |
| analysis/interface-review/2026-09-10-specialized-race-measurement.md | 2 | - |
| analysis/property-tests/2026-09-10-module-schedule-validation.md | 2 | - |
| analysis/interface-review/2026-09-10-offline-worker-loading.md | 2 | - |
| evidence/2026-09-12-incremental-lean-profile.md | 1 | - |
| analysis/interface-review/parameterization-provider.md | 1 | - |
| analysis/module-loading/race-performance.md | 2 | - |
| analysis/interface-review/2026-09-10-count-axis-and-readout.md | 4 | - |
| analysis/interface-review/2026-09-10-css-wasm-thread-spike.md | 3 | - |
| analysis/module-loading/overnight-demo-review.md | 1 | - |
| analysis/external-benchmarks/2026-09-11-scip-exact-proof-comparison.md | 4 | - |
| analysis/interface-review/2026-09-09-composition-codec-convergence.md | 2 | - (lines 91, 96 left as `--out` destination convention, matching the audit's own treatment of identical-shaped lines 88/94/97) |
| analysis/datalog-comparison/results-2026-09-13.md | 2 | - |
| analysis/external-benchmarks/2026-09-12-completion-screen.md | 5 | - |
| analysis/external-benchmarks/2026-09-11-sparse-pilot.md | 5 | - |
| analysis/campaign-console/mockups/README.md | 2 | - |
| analysis/interface-review/2026-09-10-adaptive-representation-performance.md | 2 | already mostly repaired by the stopped agent; 2 literal cache paths remained |
| analysis/datalog-comparison/results-2026-09-13-run2.md | 2 | - |
| analysis/interface-review/2026-09-10-independent-fit-recognition.md | 1 | already mostly repaired; 1 literal cache path remained |
| analysis/interface-review/application-records.md | 2 | - |
| analysis/interface-review/2026-09-09-css-residual-evaluation.md | 5 | - |
| analysis/external-benchmarks/2026-09-11-exclusion-certification.md | 3 | - |
| analysis/external-benchmarks/2026-09-11-coordinate-retraction.md | 0 | verified already fully repaired by the stopped agent |
| analysis/interface-review/2026-09-10-adaptive-representation-plan.md | 0 | verified already fully repaired |
| analysis/interface-review/2026-09-10-direct-xor-and-capacity-surface.md | 0 | verified already fully repaired |
| analysis/interface-review/2026-09-10-hadamard-bridge-comparison.md | 0 | verified already fully repaired |
| analysis/interface-review/2026-09-10-hadamard-prefix-scheduling.md | 0 | verified already fully repaired |
| analysis/interface-review/2026-09-10-race-failure-contracts.md | 0 | verified already fully repaired |
| analysis/interface-review/2026-09-11-general-140.md | 0 | verified already fully repaired |
| analysis/interface-review/2026-09-11-general-additive-join.md | 0 | verified already fully repaired |

`analysis/external-benchmarks/2026-09-12-completion-screen.md`'s `--record` input
(`~/.cache/ergodis/c1143/c1159-profile/custom-5-1-0-candidate.json`, 876 bytes, textual) was still
present on disk; it is committed alongside the report as
`analysis/external-benchmarks/c1159-profile-custom-5-1-0-candidate.json`, SHA-256
`5e3f66b10343cbd54d18a23db4ef23528cb87a46af76751667c7ca60397ffb90`.

`analysis/interface-review/adr-shared-memory-execution-and-telemetry.md` is modified in the working
tree but is not in the audit's file list and was not touched: it belongs to a concurrent,
unrelated task (the same one that modified the non-Markdown `.mjs`/`.py`/`.rs` files seen in
`git status`), which this sweep leaves entirely alone.

## Adjacent infractions observed but out of this sweep's scope

- `notes/2026-07-08-codex-intrusion-census.md:169` cites `/tmp/codex-feat13-c15.out` and
  `/tmp/codex-feat17.out` as replay inputs. The file predates the audit's seven-day window, so it
  was never classified, so it was left alone. The repair is mechanical and already available:
  committed copies of all three outputs exist as `notes/data/codex-feat11-c15.out`,
  `notes/data/codex-feat13-c15.out` and `notes/data/codex-feat17.out`.
- `~/src/ergodis` `evidence/2026-09-12-rule-frontier-ab.json` carries literal
  `~/.cache/ergodis/bin/rule-replay-*` values in a hash-bearing bundle row. That repository was
  deliberately not touched here.
