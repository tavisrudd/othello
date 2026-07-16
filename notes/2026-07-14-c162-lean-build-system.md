# C162 — Lean build-system hardening

**Lane**: `build-sys`
**Date**: 2026-07-15
**Status**: ACTIVE — orchestration/manual consolidation landed; graph and isolation streams remain

## Objective

Make large Lean builds predictable, restartable, resource-safe, quiet in agent context, and
attributable to one owning lane. Operational checks should be executable policy, not command recipes
that every agent reconstructs by hand.

## Landed in this pass

- `lean/scripts/lean-build-queue.py` is the supported unattended build entry point.
- Every real Lake build launched by the runner goes through `~/.claude/bin/run-quiet`; full output is
  stored under disk-backed per-target run state, while the agent sees bounded milestones/tails.
- `plan` silently reads RAM, mount, and tmpfs state and validates a named measured resource profile.
  Unsafe thread counts, current-memory budgets, and RAM-backed state are refused before Lake starts.
- Versioned measurements live in `lean/scripts/lean-build-profiles.json`; unknown work is serial.
- `--serial-first MODULE` builds known-heavy shared dependencies with one thread before leaf fan-out.
- `pack` takes the build-owner lock, refuses active foreign work, overwrite, `/tmp`, and other
  RAM-backed destinations, then runs `lake pack` through `run-quiet`.
- `guarded-lean` now has real `--help` and routes single-file elaboration through `run-quiet`.
- The nested shared Lean guide was reduced from 211 lines/15.9 KB to 110 lines/5.6 KB; measurements
  and command assembly now live in scripts rather than startup context.

The preflight uses `/proc/meminfo`, `/proc/self/mountinfo`, and filesystem APIs silently. It never
prints `ps`, `df`, or a memory table. A short refusal explains only the failed invariant.

## Validation

- Python syntax parse: pass for runner and tests.
- `bash -n lean/scripts/guarded-lean`: pass.
- `uv run python lean/scripts/test_lean_build_queue.py`: **14 tests, OK**. All external tools are
  hermetic stubs; no Lean/Lake process or host process-table query is used by the suite.
- Real non-building preflight:
  `plan --profile q25-two-witness --threads 2`: pass. It detected and budgeted current tmpfs usage.
- Ruff: unavailable in the current uv environment (`ruff` executable absent); not a project gate.

The real-toolchain lightweight-build gate remains open: by policy it requires a known quiet window.

## Remaining C162 streams

1. Exercise one disposable lightweight target through the real queue in a quiet window.
2. Add the project-local import/reverse-dependency blast-radius analyzer.
3. Identify and version stable generated-checker/schema boundaries.
4. Demonstrate pack/restore and evaluate per-lane build-tree isolation on disposable state.
5. Convert the remaining restart-guard cases into hermetic tests, then run a real
   checkpoint/restart/audit cycle on lightweight sentinels.

## Trust boundary

The ownership lock closes races among participating runners. Silent exact-name process checks reduce
the chance of colliding with hand-run Lake, but sandbox PID namespaces can hide host processes.
Therefore an empty process result never grants authority over another lane; uncertainty is a stop
condition, not permission to build.
