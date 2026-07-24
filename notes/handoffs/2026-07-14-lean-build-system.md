# Lean build-system hardening

**Lane**: `build-sys`
**Date**: 2026-07-18
**Status**: ACTIVE — C225 reported; C326 exporter landed and self-validated, project extraction
awaits a quiet Lean worktree; C162 blast radius and the restart-guard failure suite landed, and the
remaining C162 streams need a quiet window

> **LIVE MAP ONLY. DO NOT APPEND BUILD LOGS, INCIDENT NARRATIVES, MEASUREMENTS, OR
> SUPERSEDED DESIGNS HERE.** Put history in
> [`done/2026-07-14-lean-build-system-archive.md`](done/2026-07-14-lean-build-system-archive.md)
> and findings in the C162/C205 reports.

## Goal

Make large Lean builds resource-safe, quiet, restartable, attributable, and isolated enough that one
lane cannot corrupt another lane's artifact state.

This lane owns `lean/scripts/`, narrow build configuration, shared Lean build guidance, C162/C205
reports, and its queue rows. It does not own mathematical Lean modules, generated certificates, or
another lane's running build.

## Current toolchain

- `lean/scripts/guarded-lean`: one bounded single-file elaboration through `run-quiet`.
- `lean/scripts/lean-build-queue.py plan`: silent RAM/tmpfs/profile preflight; never runs Lake.
- `lean-build-queue.py run`: locked explicit target queue, serial-first phase, `run-quiet` builds,
  atomic status, telemetry, trace-current skipping, and final aggregate gate.
- `lean-build-queue.py status`: bounded filesystem-backed progress; no process-table polling.
- `lean-build-queue.py pack`: locked, disk-backed, non-overwriting `lake pack` through `run-quiet`.
- `lean/scripts/lean-restart-guard.py`: trace-validated checkpoint/verify/audit-log, with a hermetic
  failure suite in `test_lean_restart_guard.py`. Unexercised against real Lake output.
- `lean/scripts/lean-trust-spine.py`: read-only `audit`/`check` of declared trust boundary against
  tree facts, plus `generate`/`graph`/`render`. Declarations in `lean/trust/`. Runs no Lake build.
- `lean/scripts/lean-trust-extract.py`: the only trust-spine component that runs Lean. `plan`,
  `wrapper`, and `canonicalize` run none; `selftest` exercises the whole path against core Lean with
  no project import; `run` extracts declared units through `guarded-lean` and refuses a tree
  carrying foreign work. Metaprogram: `lean/scripts/trust-spine-export.lean`.
- `lean/scripts/lean-blast-radius.py`: read-only `hubs`/`radius`/`targets`/`cost-model` over the
  project-local import DAG. Blast radius is exact; cost columns are unvalidated size proxies.
- Resource profiles: `lean/scripts/lean-build-profiles.json`.

Detailed operator rules are in `lean/AGENTS.md` (`lean/CLAUDE.md` is its symlink).

## Open work, in order

0. **C326 trust spine:** Phase A landed (registry, checker, RelativeConicArcs pilot, adversarial
   tests). The exporter and extraction driver now also landed and are validated against core Lean;
   proof bodies are available, so the theorem graph is not partial. What remains is running
   extraction over the project, which needs a quiet Lean worktree — all five gates still report
   `facts-missing`, and every declared terminal-axiom set is unverified until then. The driver
   refuses to start while the tree carries foreign work, so no judgement call is needed to tell
   whether the window is open: `lean-trust-extract.py plan` reports it.
   Reports: [`../2026-07-18-c326-trust-spine-phase-a.md`](../2026-07-18-c326-trust-spine-phase-a.md),
   [`../2026-07-18-c326-lean-fact-exporter.md`](../2026-07-18-c326-lean-fact-exporter.md).
   Phase A's findings 1–4 are other lanes' to close; `build-sys` reports them and does not fix them.
1. **Real lightweight gate:** in a confirmed quiet window, run one disposable target through the
   queue and verify actual Nix/Lake/run-quiet/GNU-time behavior.
3. **Restart guard:** the hermetic failure suite landed and is green; writing it exposed and closed
   two paths that reported success without checking what they claimed (an emptied or narrowed
   artifact map verified vacuously, and `audit-log` crashed on a malformed checkpoint instead of
   refusing). What remains is the lightweight real checkpoint→restart→audit→verify cycle on
   disposable state in a quiet window. The suite stubs Lake entirely, so it establishes nothing
   about real Lake exit codes, trace semantics, or what an interrupted build leaves on disk.
   Report: [`../2026-07-18-c162-restart-guard-failure-tests.md`](../2026-07-18-c162-restart-guard-failure-tests.md).
5. **Stable checker boundaries:** freeze narrow schemas/checkers; keep transport and paper-facing
   theorems downstream of generated leaves.
6. **Isolation/recovery:** demonstrate pack/restore on disposable state and compare shared-tree
   discipline with disk-backed per-lane build directories.

## Gates and non-goals

- Never start a real build while ownership of the shared tree is uncertain.
- Do not change package boundaries, default build directories, CI gates, or another lane's generated
  sources without a separately surfaced design decision.
- Do not turn a sandbox-local empty PID result into permission to build.
- No broad `ps`, `df`, or live-log output; wrappers perform silent checks and bounded reporting.

## Reports

- C162 current report: [`../2026-07-14-c162-lean-build-system.md`](../2026-07-14-c162-lean-build-system.md).
- C162 blast radius: [`../2026-07-18-c162-blast-radius.md`](../2026-07-18-c162-blast-radius.md).
- C162 restart-guard failure tests: [`../2026-07-18-c162-restart-guard-failure-tests.md`](../2026-07-18-c162-restart-guard-failure-tests.md).
- C205 base runner: [`../2026-07-15-c205-unattended-lean-build-queue.md`](../2026-07-15-c205-unattended-lean-build-queue.md).
- C225 managed queue (reported): [`done/2026-07-16-c225-lean-queue-completion-notification.md`](done/2026-07-16-c225-lean-queue-completion-notification.md).
- C326 Phase A: [`../2026-07-18-c326-trust-spine-phase-a.md`](../2026-07-18-c326-trust-spine-phase-a.md).
- C326 exporter: [`../2026-07-18-c326-lean-fact-exporter.md`](../2026-07-18-c326-lean-fact-exporter.md).
- C365 literature-audit conventions (reported): [`../literature-audit-conventions.md`](../literature-audit-conventions.md),
  reviewed in [`../2026-07-19-c365-literature-audit-conventions-fable-review.md`](../2026-07-19-c365-literature-audit-conventions-fable-review.md).
  Repo-wide recording standard for novelty/priority work, pointed to from `CLAUDE.md`. Its read-depth
  vocabulary and coverage outcomes are the source of truth for the C328 evidence-metadata schema and
  must change together with it.
- Full prior handoff state: archive linked above.

## Registered spin-off (no C task)

The `lean-proof-engineering-at-scale` methods-paper idea and its five upgrade gates are registered in
`papers/papers-index.md` and `done/2026-07-14-lean-build-system-archive.md`. C allocation is gated on
a manuscript outline and a measurable contribution beyond repository-specific operating instructions
per gate 5; none is allocated here until that gate is met.

## Public shared-Lean extraction

C287 owns the fresh-history shared Lean repositories' reviewed manifests, incremental source
exports, exact target builds, axiom audits, clean-checkout validation, and artifact pack/restore
portability. The approved main identity and local path are `github.com/tavisrudd/finitegeom` and
`~/src/lean/finitegeom`. Heavyweight generated closures stay outside it in one-way-dependent
certificate packages, beginning with `~/src/lean/finitegeom-q16-certificates` and
`~/src/lean/finitegeom-q25-certificates`, with ProjectiveCap Q11 and Q13 staged as separate
field-specific certificate packages. The first main tag is the exact human-scale `FiniteGeom` +
mirror closure; later tags add reviewed paper-facing closures without copying Lean into paper
repositories. Its first-tag size gate is at most 100 Lean files / 25,000 code lines, and the initial
planned human-scale union is at most 500 / 75,000; larger generated families are external by
default. C270 (`nofil`) owns metadata, DOI/OEIS and eventual user-authorized remote actions. C287
must not create remotes, publish, or push; C270 must not copy sources or run builds. All real
validation is serialized through the build-owner lock and unattended queue.
Every paper export directory carries its own tracked `flake.nix` and `flake.lock`, resolving exact
pins for `finitegeom`, required certificate packages, the Lean toolchain, and system dependencies.
Certificate packages are opt-in leaves: unused families are absent from that paper's inputs, lock
graph, fetches, build closure, and validation targets; no portfolio-wide certificate umbrella is
allowed.

**Current C287 state (2026-07-23):** five `main`-branch workspaces exist under `~/src/lean/`:
`finitegeom`, Q16 certificates, Q25 certificates, and separate ProjectiveCap Q11/Q13 certificate
packages. Each has no commit and no remote, with only `.gitignore`, `flake.nix`, `flake.lock`, and
the matching `lean-toolchain` staged. All pass `nix flake check --no-build`; none contains Lean
source or Lake targets. No Lean/Lake command or process intervention was performed. The exact
workspace list, nixpkgs pin, measured size gates, and payload blockers are recorded in the C287
plan.

**Next:** while existing Lean runs remain active, design manifests and classify dependencies
read-only. Do not export certificate payloads before C318/C319/C324 and the recorded Q16/Q11/Q13
trust gates; do not elaborate or build until a confirmed quiet build-owner window. The first commits
must include reviewed source manifests and public rewrites, not scaffold-only history.
