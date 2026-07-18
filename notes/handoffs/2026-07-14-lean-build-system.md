# Lean build-system hardening

**Lane**: `build-sys`
**Date**: 2026-07-15
**Status**: ACTIVE — C225 notification loop next; C162/C205 base runner remains open

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
- `lean/scripts/lean-restart-guard.py`: trace-validated checkpoint/verify/audit-log.
- Resource profiles: `lean/scripts/lean-build-profiles.json`.

Detailed operator rules are in `lean/AGENTS.md` (`lean/CLAUDE.md` is its symlink).

## Open work, in order

1. **C225 completion notification:** implement the accepted design and gates in
   [`2026-07-16-c225-lean-queue-completion-notification.md`](2026-07-16-c225-lean-queue-completion-notification.md).
2. **Real lightweight gate:** in a confirmed quiet window, run one disposable target through the
   queue and verify actual Nix/Lake/run-quiet/GNU-time behavior.
3. **Restart guard:** complete hermetic failure tests and a lightweight real
   checkpoint→restart→audit→verify cycle.
4. **Blast radius:** parse project-local imports, compute reverse reachability, and rank hubs by
   rebuild cost as well as dependent count.
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
- C205 base runner: [`../2026-07-15-c205-unattended-lean-build-queue.md`](../2026-07-15-c205-unattended-lean-build-queue.md).
- Full prior handoff state: archive linked above.

## Registered spin-off (no C task)

The `lean-proof-engineering-at-scale` methods-paper idea and its five upgrade gates are registered in
`papers/papers-index.md` and `done/2026-07-14-lean-build-system-archive.md`. C allocation is gated on
a manuscript outline and a measurable contribution beyond repository-specific operating instructions
per gate 5; none is allocated here until that gate is met.

## Public shared-Lean extraction

C287 owns the fresh-history shared Lean repository's reviewed manifests, incremental source
extraction, exact target builds, axiom audits, clean-checkout validation, and artifact
pack/restore portability. The first tag is the exact `FiniteGeom` + mirror closure; later tags add
reviewed paper-facing closures without copying Lean into paper repositories. C270 (`nofil`) owns
public identity, metadata, DOI/OEIS and eventual user-authorized remote actions. C287 must not
create remotes, publish, or push; C270 must not copy sources or run builds. All real validation is
serialized through the build-owner lock and unattended queue.
