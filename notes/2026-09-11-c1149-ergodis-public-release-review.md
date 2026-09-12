# C1149 — Ergodis public-release readiness review

**Lane**: `ergodis`
**Date**: 2026-09-11
**Status**: IN PROGRESS (review running; sections land as they complete)

## Scope

Assess `~/src/ergodis` (private `main`, AGPL-3.0-only core with `verify`, `runtime`,
`repository-native`, `modules` crates and `wasm/`) for a public GitHub release as a library
and CLI with documentation and demos. Deliverable: gap assessment and a remediation plan.
Read-only review; no source edits. Builds and lint run against a filtered snapshot of
`main` at the review revision, never against the working tree.

## Baseline facts (main agent, verified)

| Item | State |
|---|---|
| Review revision | `~/src/ergodis` main `c59bf67` |
| License | `LICENSE` is AGPL-3.0; `Cargo.toml` `license = "AGPL-3.0-only"`, `publish = false` |
| Public branch | `public` at `9ed76b3`; 465 private commits since the last export |
| Export pipeline | `scripts/export-public.sh` → `public` → staging clone `~/src/ergodis-public` → GitHub; guards in `hooks/`, `scripts/public-lint.sh`, `tests/publication-guards.sh` |
| Filtered-tree lint | 2 findings (down from the 67 recorded in the lane handoff): `private-path` tokens in `scripts/check-verifier-dependencies.py:45` and `scripts/check-runtime-dependencies.py:42` (the strings `"ergodis-private"` inside forbidden-dependency lists) |
| Unfiltered lint on `main` | 83 findings, all in paths `.publicignore` drops (`evidence/`, process docs) |
| Bin targets | `ergodis`, `ergodis-rpc`, `ergodis-campaign`, `ergodisctl`, plus benchmark/probe bins (`css_distance_random`, `scheduler_locality`, `defect_augmentation`, `balanced_frontend`, `parallel_kernels`, `balanced_parallel`, …) |
| Working tree | Foreign uncommitted edits present in `~/src/ergodis` (allocation-surface parallel work from another session); untracked `python/__pycache__/` |
| Release checklist | `docs-private/RELEASE-CHECKLIST.md` exists; `.publicignore` work-in-progress hold section is empty |
| CI | `.github/workflows/public-lint.yml` only; no build/test CI on the public branch |

## Review sections

Sections below are sub-agent reports, included verbatim.

<!-- SECTIONS -->

## Gap assessment

(pending)

## Remediation plan

(pending)
