# Lean build-system hardening

**Lane**: `build-sys` — see CLAUDE.md § Lane routing.

**Date:** 2026-07-14
**Status:** OPEN — C162 queued; C205 reported; do not disturb an active foreign build window
**Tasks:** C162, C205

## Lane boundary

This lane owns build orchestration, trace-aware restart/recovery tooling, dependency-graph analysis,
and artifact isolation for the large Lean source tree. It does not own the mathematical contents of
any Lean module or another lane's running build.

Until the user explicitly selects `build-sys`, the current `alt-orbit-repair` lane remains selected.
No build-system experiment may interrupt, clean, rebuild, or mutate the import closure of an active
foreign-lane build.

### Allowed paths once selected

- `lean/scripts/` and narrowly scoped build configuration under `lean/`;
- `CLAUDE.md` / `AGENTS.md` Lean build guidance;
- `notes/2026-07-14-c162-*`, this handoff, and its companion archive;
- this lane's rows in `notes/2026-07-07-codex-task-queue.md`.

Changing package boundaries, default build directories, CI gates, or another lane's generated
sources requires a separately surfaced design decision before implementation.

## Trigger finding

The C143 two-witness build exposed four facts with repository-wide consequences:

1. an existing olean may encode an older import closure and is not evidence that the current source
   has landed;
2. Lake schedules independent branches in non-monotone filename order, and fresh runs may display
   different replay/build denominators;
3. outputs produced under `LEAN_NUM_THREADS=2` and `=3` were mutually reusable, so worker count did
   not pollute artifacts; and
4. editing one high-fan-out checker can legitimately invalidate thousands of generated leaves in the
   shared tree.

The immediate guard is `lean/scripts/lean-restart-guard.py`, added with trace-validated sentinel
checkpoint, verification, and build-log audit commands. It is source-validated but its real
checkpoint/verify cycle is intentionally deferred until the active Lake process stops.

## C162 objective

Make large Lean builds predictable, restartable, and attributable: distinguish genuine transitive
staleness from artifact loss, quantify the reverse-dependency blast radius before editing shared
modules, and isolate lanes strongly enough that one lane cannot pollute another's artifact state.

## C205 status — reported 2026-07-15

`lean/scripts/lean-build-queue.py` (+ `test_lean_build_queue.py`, 11 hermetic tests, all six gates)
replaces the one-off `/tmp/c151-run-remaining.sh`. A build-owner `flock` is taken **before** the
quiet check and held for the run, closing the check-then-launch race between participating runners;
`status` reads run state from the lock rather than a PID, so it stays correct inside a sandboxed
PID namespace. Refusal is terminal, full module names make log paths collision-free, and unsafe
numeric controls are rejected at argument parsing.
Full design, operator commands, and limitations: `notes/2026-07-15-c205-unattended-lean-build-queue.md`.

Carry-over for the next `build-sys` session:

- **first live use must be one disposable lightweight target in a quiet window** — the runner is
  proven only against stubs, since a foreign build held this session's whole window.

## Work streams and gates

### 1. Restart guard

- Unit-test malformed checkpoints, missing sidecars, changed hashes, exact build-log matching, and
  refusal while a host-visible `lake.orig` is live.
- Exercise `checkpoint → restart → audit-log → stopped verify` on a lightweight target first.
- After C143 closes, exercise the protocol on several explicitly reported C143 sentinels without
  rebuilding them.
- Resolve agent PID-namespace visibility with an external ancestry check or a shared build-owner
  lock; do not treat sandbox-local `pgrep` as authoritative.

### 2. Import blast-radius map

- Parse project-local Lean imports and compute reverse reachability, separating handwritten cores,
  generated leaves, shard aggregators, and paper-facing results.
- Rank high-fan-out modules by rebuild cost, not dependent count alone; attach measured RSS/time
  classes where available.
- Produce a pre-edit query: “if this module changes, which current lane targets become stale?”

### 3. Stable generated-checker architecture

- Identify generated leaves importing broad or frequently edited modules.
- Propose small versioned checker/schema cores whose source is frozen for the life of a certificate
  generation.
- Keep new transport, convenience, and paper-facing theorems downstream so prose/API growth does not
  invalidate certificate leaves.
- Use shard aggregators as semantic build milestones and restart sentinels.

### 4. Artifact isolation and recovery

- Compare shared-build-tree discipline with disk-backed per-lane worktrees/build directories under
  `/home`; CPU affinity alone is not isolation.
- Validate `lake pack` and restore on a disposable lightweight build tree before declaring it a
  recovery gate.
- Specify what a reusable cache must preserve: project `.olean`/`.ilean`, `.trace`, `.hash`, and IR
  outputs under the root package build directory, keyed by toolchain and source state.
- Never use `/tmp`, `lake clean`, concurrent Lakes in one build tree, or `--old` as a validation
  shortcut.

### 5. Progress and CI protocol

- Replace cross-restart `done/total` reporting with stable semantic milestones: source/checker hash,
  shard target, trace-validated sentinel set, and final aggregate `--no-build` gate.
- Add a narrow CI or operator check only after the local protocol is demonstrated and cheap enough
  not to turn every edit into a full-tree build.

## Deliverables

- hardened `lean/scripts/lean-restart-guard.py` with tests;
- project-local import/reverse-dependency analyzer and blast-radius report;
- stable-checker and shard-sentinel design for generated certificate families;
- demonstrated pack/restore and per-lane artifact-isolation recommendation;
- final report: `notes/2026-07-14-c162-lean-build-system.md`;
- concise final-form Lean guidance in `CLAUDE.md` / `AGENTS.md`.

## Spin-off methods paper — idea registered

`papers/papers-index.md` now tracks the unnumbered candidate alias
`lean-proof-engineering-at-scale`: an evidence-based essay/how-to on engineering large Lean
repositories with generated proof certificates.  It is not yet a separate C item and does not alter
the mathematical papers' ship order.

### Thesis and evidence spine

The proposed paper should explain a reproducible engineering discipline for proof developments in
which small checker edits can invalidate thousands of generated leaves and failed parallel builds
can destroy useful artifacts.  The project supplies measured before/after case studies rather than
generic advice:

- control Lake fan-out with `LEAN_NUM_THREADS`; use CPU affinity only for scheduling separation;
- make heavyweight builds deliberately OOM-sacrificial with `choom`, and never hand-kill workers
  without ownership/ancestry evidence;
- treat content traces and `lake build --no-build` as the staleness authority, not mtimes or an
  existing `.olean`;
- freeze narrow checker/schema cores, place transport and exposition downstream, and shard generated
  certificates into resumable semantic milestones;
- measure import-closure blast radius before editing high-fan-out modules;
- checkpoint project artifacts to disk-backed storage and keep heavyweight work out of `/tmp`;
- isolate concurrent lanes at the artifact/build-tree boundary, not merely by core allocation; and
- prefer reusable finite interfaces—such as C151's canonical line-incidence masks—when they reduce
  both kernel replay time and peak memory relative to repeated end-to-end decisions.

### Upgrade gates

1. C162 must turn the current operator knowledge into scripts, tests, and reproducible measurements.
2. Collect a compact incident ledger: trigger, diagnosis, failed mitigation, final mechanism, and
   before/after time/RSS/rebuild radius for C143, C151, and at least one unrelated generated family.
3. Run a literature/practice audit covering Lean/Lake incremental builds, proof-artifact caching,
   large generated certificates, CI reproducibility, and parallel or multi-agent proof development.
4. Decide venue and form only after the audit: experience report, tools paper, or practitioner essay.
5. Allocate a new lane-pegged C item only when there is a manuscript outline and a measurable
   contribution beyond repository-specific operating instructions.

## First session

1. Confirm no foreign heavyweight build owns the test window.
2. Test the restart guard entirely on a lightweight target and fix its trust boundary.
3. Build the import graph and report the top reverse-dependency/cost hubs.
4. Select one generated family and draft the versioned checker/shard boundary before changing any
   production module layout.

## 2026-08-04 — order-16 certificate package sealed; order-eleven boundary mapped

Session on C864. The official order-16 cold fill failed after two hours fifty-six minutes at its
focused gate, on a base-library module the gate never needed: the package's result aggregator
imported the base umbrella, which reached `RelativeConicArcs.Q11Residual`, a module the base cannot
compile because the module defining its parametrized-hole predicate and previous-player-win
transport lemma was never exported. Dropping that one import cut the gate closure from 1,390
project modules to 1,358 and its base contribution from 59 to 27, and removed every order-eleven
semantic module. Package commit `d780520`.

The gate then passed, all 1,331 modules built, both terminals depending only on `propext`,
`Classical.choice` and `Quot.sound`. The package was packed to
`/home/tavis/lean-backups/q16-certificates-d780520-cache.tgz` (359 MB, sha256 `3dbbafc4c5077fd3…`),
its 593 MB build tree quarantined and erased, restored from the pack alone in nine seconds, and the
gate confirmed already-current with a trace-only aggregate over 9,973 targets and no leaf rebuilt.
The quarantine was removed.

Two defects stay open and are recorded in the task card: the base library still ships an
uncompilable module, whose repair is a game-free/game split rather than a moved declaration because
its terminal is a normal-play statement; and nothing builds the base standalone before a package
pins it, which is why the broken export surfaced only inside a consumer's three-hour build.

The order-eleven externalization was scoped but not executed. Inventory:
`notes/2026-08-04-c864-q11-payload-inventory.md`; split proposal:
`notes/2026-08-04-c864-q11-interface-split-lines.md`; independent feasibility audit:
`notes/2026-08-04-c864-q11-split-feasibility.md`, which found two of the five proposed cuts
unworkable and named the mechanism that hid the problem — a module declaring into another module's
namespace, so consumers reach its definitions through an `open` and never name it.

Deferred to the next session on C864: the pinned external order-16 trust fact, which is what the
Al-Seraji--Al-Ogali anchor needs; the base repair batched with the order-eleven externalization so
the base is re-exported and re-pinned once; and a gate covering the two new classification modules.
