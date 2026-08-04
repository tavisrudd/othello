# Lean build-system hardening

**Lane**: `build-sys`
**Date**: 2026-08-04
**Status**: ACTIVE — order-16 package sealed and its external trust fact pinned; C864 owns the
remaining certificate externalization, the base-library repair, and the all-paper export replay

> **LIVE MAP ONLY. DO NOT APPEND BUILD LOGS, INCIDENT NARRATIVES, MEASUREMENTS, OR
> SUPERSEDED DESIGNS HERE.** Put history in
> [`done/2026-07-14-lean-build-system-archive.md`](done/2026-07-14-lean-build-system-archive.md)
> and findings in the dated reports linked below.

## Goal

Make large Lean builds resource-safe, quiet, restartable, attributable, and isolated enough that one
lane cannot corrupt another lane's artifact state.

This lane owns `lean/scripts/`, `lean/trust/`, narrow build configuration, shared Lean build
guidance, and its queue rows. It does not own mathematical Lean modules, generated certificates, or
another lane's running build. Detailed operator rules are in `lean/AGENTS.md` (`lean/CLAUDE.md` is
its symlink); read it before any Lean edit, generator run, build, or process intervention.

## Load before acting, and known footguns

Routed reads, in addition to `lean/AGENTS.md`: `notes/export-and-mirror-conventions.md` before any
paper-mirror synchronization, Lean companion export, or certificate re-pin — nothing else may write
under `~/src/math-papers/` or `~/src/lean/`; `notes/research-reproducibility-conventions.md` before
any paper-facing computational claim; `papers/style-guide.md` before touching manuscript prose.

- One heavyweight build owns the host at a time, across the monorepo, official packages, dependency
  checkouts, and restore rehearsals. Never run direct `lake`, `nix ... lake`, or a hand-composed
  `taskset`/`choom` command. `run-quiet` is output capture, not the guarded entry point.
- `lean-trust-spine.py generate` rewrites the global graph manifest and `trust/PORTFOLIO.md` from
  whatever the tree currently holds. Run it only on a quiet tree with no foreign uncommitted facts
  artifact, or it silently folds another lane's work into shared generated views.
- Import graphs are evidence about modules, not declarations. A module that declares into another
  module's namespace is reached through `open`, so searching for its own name finds no consumer.
  Establish declaration-level use before relocating anything; this is what made two of the five
  proposed order-eleven cuts unworkable.
- A content-addressed manifest sealed against `HEAD` is red the moment its own seal is committed.
  Verify against the commit the manifest names, and require the sealed sources to be unmoved.
- `--quiet-wait` blocks on `pgrep -x lean`, which matches a language server as readily as a build.
  Never raise it; a long quiet wait idles the single build slot behind an open editor.
- Exit 0 from the build queue carries two outcomes: check for a `resume:` line to tell a finished
  run from one still running. Exit 126 is an abandoned run, typically an OOM kill.
- `/tmp` is tmpfs on this host and counts against RAM. Never put build trees, caches, checkpoints,
  packs, or large logs there.
- To undo a bad regeneration, restore file content (`git show HEAD:<path> > <path>`) rather than
  reaching for a destructive checkout that would also discard foreign dirty work.

## Public shared-Lean contract

The approved main identity is `github.com/tavisrudd/finitegeom` at `~/src/lean/finitegeom`.
Heavyweight generated closures stay outside it in one-way-dependent certificate packages under
`~/src/lean/`. Human definitions, reusable schemas, field-independent soundness APIs, and small
examples stay in the monorepo and the base; generated leaves, enumerated tables, package-private
checkers, generators, and replay outputs belong only to their owning package. The monorepo never
imports an external certificate closure — it consumes a pinned trust fact. The first-tag size gate
is at most 100 Lean files / 25,000 code lines, and the planned human-scale union at most 500 /
75,000. Each paper export carries its own `flake.nix`/`flake.lock` resolving exact pins; certificate
packages are opt-in leaves, and no portfolio-wide certificate umbrella is allowed. Commit-scoped
trust, axiom, and clean-replay evidence is never reused by file hash.

## Toolchain

- `lean/scripts/guarded-lean`: one bounded single-file elaboration through `run-quiet`.
- `lean-build-queue.py`: `plan` (silent preflight, no Lake), `build`/`run` (locked queue, guarded
  cache restore, atomic heartbeats, trace-current skipping, final aggregate gate), `await`, `lock`,
  `status` (owner-descendant view, no process-table search), `pack` (guarded `lake pack`).
- `lean-build-systemd.py`: the adjacent managed path, explicitly selected, same lock and caps.
- `lean-restart-guard.py`: trace-validated checkpoint/verify/audit-log with a hermetic failure
  suite. Unexercised against real Lake output.
- `lean-trust-spine.py`: read-only `audit`/`check` of the declared trust boundary against tree
  facts, plus `generate`/`graph`/`render`. Declarations in `lean/trust/`. Runs no Lake.
- `lean-trust-extract.py`: the only trust-spine component that runs Lean; `run` extracts declared
  units through `guarded-lean` and refuses a tree carrying foreign work. Metaprogram:
  `trust-spine-export.lean`.
- `lean-external-fact.py`: `seal`/`pin`/`check` for external certificate-package trust facts. Runs
  no Lean; `seal` derives a package's `TRUST_FACT.json` from one completed gate run plus its sealed
  manifest and preserved gate log, and refuses a dirty tree, a foreign root, moved Lean sources, an
  unfinished gate, or evidence differing from the run's own log.
- `lean-certificate-boundary.py`: rejects certificate-owned sources, imports, and replay artifacts
  in the monorepo; `--verify-official-libraries` also checks package pins and published facts.
- `paper-facts.py`: per-manuscript facts from tracked bytes, plus `audit`/`check`. Runs no Lake,
  LaTeX, or BibTeX.
- `lean-companion-export.py`: `plan`/`run` for companion export onto the canonical `finitegeom`
  base. Materializes twice, requires byte-identical repeats, never commits or pushes.
- `lean-blast-radius.py`: read-only import-DAG analysis. Blast radius exact; cost columns are
  unvalidated size proxies.
- Resource profiles: `lean-build-profiles.json`.

## Active frontier, in order

1. **C864 certificate closeout.** The integrated closeout for the remaining C686/C687 execution and
   the certificate boundary portion of C287/C324. Card, execution order, and acceptance:
   [`../build-sys-tasks/c864-external-certificate-closeout-and-audit.md`](../build-sys-tasks/c864-external-certificate-closeout-and-audit.md).
   Done: the order-16 package is sealed, packed, restore-rehearsed trace-current, and its external
   trust fact is published and pinned; the Kim--Vu and Al-Seraji--Al-Ogali anchors are exact.
   The base-library game-free/game split is landed and gate-green in the monorepo: the validity
   predicate now sits in `RelativeConicArcs/ParametrizedHoles.lean`, `Q11Residual` is game-free, and
   the terminals are in `Q11ResidualGame`.
   The point-orbit interface/payload split is landed and gate-green, and the point-orbit rows are
   decided to join `finitegeom-clebsch-q11-certificates`.
   Next: the order-eleven cut is blocked on the exported base surface — the package payload needs
   the displayed blocks, the base carries no point-orbit module, and no monorepo gate, fact or
   export config exists for the arcs/rigidity human areas; the base commit must then be published
   before the package can pin it. After that: the package refresh and reseal, the monorepo
   deletions, the q13/q25 packages, the portfolio audit, the Arcs/Clebsch-rigidity trust
   disposition, and the all-paper export replay.
2. **Real lightweight gate.** In a confirmed quiet window, run one disposable target through the
   queue and verify actual Nix/Lake/run-quiet/GNU-time behavior. The restart guard needs the same
   window for one real checkpoint→restart→audit→verify cycle on disposable state.
3. **C326 extraction over the project.** The exporter and driver are validated against core Lean;
   what remains is running extraction in a quiet Lean worktree. All five gates report
   `facts-missing`, so every declared terminal-axiom set is unverified until then.
   `lean-trust-extract.py plan` reports whether the window is open.
4. **Paper-facts steps 4 and 5.** Generated regions in `papers/papers-index.md` and
   `papers-planning.md`, gated on the registry writer's agreement; adequacy-appendix rendering,
   gated on Lean extraction having run.
5. **C287 first-tag export.** Obtain one commit-clean immutable private-source checkpoint, then
   construct the first fresh-history candidate with the C553 API/prose transformation applied only
   in the target. The private monorepo is not modified.
6. **C698--C702 Paper I v2.** Run in order: signed-two-graph core in `finitegeom`; q11 orientation
   bridge; q13 Segre foundation; q13 tangent-code certificates; then the v2 release, aligning
   q11/q13 on one upstream commit and preserving the v1 aggregate unchanged.

Standing blockers: q25 waits on C318/C319; every package waits on its applicable C324 regeneration
check; the C759 Nanoda pilot waits on a final Lean 4.32 release rather than the pinned 4.32.0-rc1;
the shared generated trust views await a quiet tree free of foreign uncommitted facts.

## Gates and non-goals

- Never start a real build while ownership of the shared tree is uncertain.
- Do not change package boundaries, default build directories, CI gates, or another lane's generated
  sources without a separately surfaced design decision.
- Do not turn a sandbox-local empty PID result into permission to build.
- No broad `ps`, `df`, or live-log output; wrappers perform silent checks and bounded reporting.
- C287 must not create remotes, publish, or push; C270 (`nofil`) owns metadata, DOI/OEIS, and
  user-authorized remote actions and must not copy sources or run builds.
- No push, tag, remote creation, history rewrite, or non-fast-forward operation is part of C864.

## Routing: load only what the task needs

**Build system and recovery** — C162 current report
[`../2026-07-14-c162-lean-build-system.md`](../2026-07-14-c162-lean-build-system.md); blast radius
[`../2026-07-18-c162-blast-radius.md`](../2026-07-18-c162-blast-radius.md); restart-guard failure
tests [`../2026-07-18-c162-restart-guard-failure-tests.md`](../2026-07-18-c162-restart-guard-failure-tests.md);
C205 base runner [`../2026-07-15-c205-unattended-lean-build-queue.md`](../2026-07-15-c205-unattended-lean-build-queue.md);
C225 managed queue [`done/2026-07-16-c225-lean-queue-completion-notification.md`](done/2026-07-16-c225-lean-queue-completion-notification.md).

**Trust spine** — C326 Phase A [`../2026-07-18-c326-trust-spine-phase-a.md`](../2026-07-18-c326-trust-spine-phase-a.md);
exporter [`../2026-07-18-c326-lean-fact-exporter.md`](../2026-07-18-c326-lean-fact-exporter.md);
C759 external trust exports [`../2026-08-01-c759-external-trust-exports.md`](../2026-08-01-c759-external-trust-exports.md);
external order-16 fact and anchors [`../2026-08-04-c864-external-order16-trust-fact.md`](../2026-08-04-c864-external-order16-trust-fact.md).

**Paper facts and drift gates** — area report
[`../2026-07-26-c681-paper-facts-area.md`](../2026-07-26-c681-paper-facts-area.md); programme and
steps [`../2026-07-26-c681-trust-spine-paper-facts.md`](../2026-07-26-c681-trust-spine-paper-facts.md);
summary-document drift gate [`../2026-07-26-c683-summary-document-drift-gate.md`](../2026-07-26-c683-summary-document-drift-gate.md).

**Paper intake and shared-Lean export** — C287 intake refresh
[`../2026-07-26-c287-paper-intake-refresh.md`](../2026-07-26-c287-paper-intake-refresh.md);
first-tag source contract [`../2026-07-23-c287-first-tag-source-contract.md`](../2026-07-23-c287-first-tag-source-contract.md);
referee review `../2026-07-24-c287-first-tag-referee-review.md`; source-owner rewrite packet
`../2026-07-24-c287-source-owner-rewrite-packet.md`; theorem ledger
[`../2026-07-23-c287-first-tag-theorem-ledger.md`](../2026-07-23-c287-first-tag-theorem-ledger.md);
trust-spine boundary [`../2026-07-24-c287-first-tag-trust-spine.md`](../2026-07-24-c287-first-tag-trust-spine.md);
execution order `../2026-07-25-c287-token-efficient-execution.md`.

**Standalone paper repositories** — C684 plan
[`../2026-07-26-c684-paper-repository-extraction.md`](../2026-07-26-c684-paper-repository-extraction.md);
golden quantum statistics export
[`../2026-08-02-golden-quantum-statistics-standalone-export.md`](../2026-08-02-golden-quantum-statistics-standalone-export.md).

**Certificate split** — C685--C687 contracts
[`../2026-07-28-c685-c687-extraction-corrections.md`](../2026-07-28-c685-c687-extraction-corrections.md);
Passages formal companion [`../2026-07-28-c685-clebsch-passages-formal-companion.md`](../2026-07-28-c685-clebsch-passages-formal-companion.md);
q11 payload inventory [`../2026-08-04-c864-q11-payload-inventory.md`](../2026-08-04-c864-q11-payload-inventory.md);
split lines [`../2026-08-04-c864-q11-interface-split-lines.md`](../2026-08-04-c864-q11-interface-split-lines.md);
split feasibility [`../2026-08-04-c864-q11-split-feasibility.md`](../2026-08-04-c864-q11-split-feasibility.md);
residual game-free/game split [`../2026-08-04-c864-q11-residual-game-split.md`](../2026-08-04-c864-q11-residual-game-split.md);
point-orbit data verdict [`../2026-08-04-c864-point-orbit-data-verdict.md`](../2026-08-04-c864-point-orbit-data-verdict.md);
order-eleven package cut status [`../2026-08-04-c864-q11-package-cut-status.md`](../2026-08-04-c864-q11-package-cut-status.md);
Dye audit and anchor review [`../2026-08-04-c864-dye-audit-and-anchor-review.md`](../2026-08-04-c864-dye-audit-and-anchor-review.md).

**Paper I v2** — audit and plan
[`../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`](../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md);
per-step cards under [`../build-sys-tasks/`](../build-sys-tasks/).

**Repo-wide standard owned here** — literature-audit conventions
[`../literature-audit-conventions.md`](../literature-audit-conventions.md), reviewed in
[`../2026-07-19-c365-literature-audit-conventions-fable-review.md`](../2026-07-19-c365-literature-audit-conventions-fable-review.md).
Its read-depth vocabulary and coverage outcomes are the source of truth for the C328
evidence-metadata schema and must change together with it.

## Registered spin-off (no C task)

The `lean-proof-engineering-at-scale` methods-paper idea and its five upgrade gates are registered in
`papers/papers-index.md` and the archive. C allocation is gated on a manuscript outline and a
measurable contribution beyond repository-specific operating instructions; none is allocated here
until that gate is met.
