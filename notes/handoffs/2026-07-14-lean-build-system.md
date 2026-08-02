# Lean build-system hardening

**Lane**: `build-sys`
**Date**: 2026-07-18
**Status**: ACTIVE — C225 reported; C326 exporter landed and self-validated; C287's current paper
boundaries are synchronized; C685 corrects the Passages formal-companion omission and C686--C687
own the complete field-certificate split; extraction waits for a commit-clean immutable input
checkpoint, while C162's remaining real-build checks also need a quiet window; C698--C702 now own
the Paper I v2 formalization and downstream q13 certificate release; C759's deterministic external
trust projections are complete, with its Nanoda pilot blocked at the Lean 4.32 final-version gate

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
  guarded one-shot Mathlib cache restoration, atomic live heartbeats, telemetry, trace-current
  skipping, and final aggregate gate.
- `lean-build-queue.py status`: bounded filesystem-backed progress plus an exact owner-descendant
  view of the active phase, Lean source, and `oom_score_adj`; no process-table search or PID
  guessing.
- `lean-build-queue.py pack`: locked, disk-backed, non-overwriting `lake pack` through `run-quiet`.
- `lean/scripts/lean-restart-guard.py`: trace-validated checkpoint/verify/audit-log, with a hermetic
  failure suite in `test_lean_restart_guard.py`. Unexercised against real Lake output.
- `lean/scripts/lean-trust-spine.py`: read-only `audit`/`check` of declared trust boundary against
  tree facts, plus `generate`/`graph`/`render`. Declarations in `lean/trust/`. Runs no Lake build.
- `lean/scripts/lean-trust-extract.py`: the only trust-spine component that runs Lean. `plan`,
  `wrapper`, and `canonicalize` run none; `selftest` exercises the whole path against core Lean with
  no project import; `run` extracts declared units through `guarded-lean` and refuses a tree
  carrying foreign work. Metaprogram: `lean/scripts/trust-spine-export.lean`.
- `lean/scripts/paper-facts.py`: the paper half of the spine. `extract` writes one facts artifact
  per registered manuscript from tracked TeX/BibTeX/bibliography/manifest bytes; `audit` and `check`
  compare declarations in `lean/trust/papers.toml` against them. Runs no Lake, LaTeX, or BibTeX, so
  it is independent of the extraction window.
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
7. **Paper-facts area:** step 1 landed. The extractor, checker, registry, and a hermetic fixture
   suite are in place, and the checker is red on the live tree with eight self-citation drifts and
   five generated-bibliography findings, all reported to the lanes owning the citing artifacts and
   none repaired here. Every registry row is registration only; adopted labels, verification
   manifests, superseded titles, and cited Lean terminals are the owning lane's to add, and each
   turns on a further check. Report:
   [`../2026-07-26-c681-paper-facts-area.md`](../2026-07-26-c681-paper-facts-area.md); programme
   intent and steps 2–5:
   [`../2026-07-26-c681-trust-spine-paper-facts.md`](../2026-07-26-c681-trust-spine-paper-facts.md).
   Step 2's gate — a drift defect caught that was not one of the four the checker was built
   against — was met by the two inline-`\bibitem` self-citations and the two README title claims no
   hand pass had found, and step 2 then landed: the work summary, the shared paper index, and the
   cross-paper results snapshot are under a read-only title-drift gate, and the work summary's §8
   carries a generated manuscript inventory whose judgement columns stay hand-written. Step 3's
   gate was met in passing — the statement-count extractor agrees exactly with an independent hand
   count on three papers — so its counts ship inside that inventory. Report:
   [`../2026-07-26-c683-summary-document-drift-gate.md`](../2026-07-26-c683-summary-document-drift-gate.md).
   Remaining: step 4 (generated regions in `papers/papers-index.md` and `papers-planning.md`, gated
   on the registry writer's agreement) and step 5 (adequacy-appendix rendering, gated on Lean
   extraction having run).
8. **C684 standalone paper repositories:** export adopted physical manuscript roots into
   deterministic release-mirror repositories under `~/src/math-papers/`, with a one-to-one
   `tavisrudd/<paper-reponame>` naming contract, tracked-file allowlists, explicit external-symlink
   dispositions, provenance manifests, and clean-room paper/checker validation. C684 consumes
   C287's released package identities but does not copy or build Lean, and it performs no GitHub
   action without explicit user authorization. Plan:
   [`../2026-07-26-c684-paper-repository-extraction.md`](../2026-07-26-c684-paper-repository-extraction.md).
   The immutable planner/audit/materializer and eighteen adversarial tests have landed. AME--LU,
   Beyond4 PRS, Clebsch Factorization, Clebsch Rigidity, and Arcs Complete Outside a Conic now have
   clean no-remote `main` histories under `~/src/math-papers/`; every export manifest verifies.
   Factorization's bundled release gate and the paper-local AME/Beyond/rigidity/arcs replays and PDF
   builds pass. Arcs uses an explicit 15-file public boundary and consumes, rather than copies, the
   separately supplied Q16 formal certificate levels. Rigidity's external formal release-output
   refresh remains in the Lean lane. Clebsch Passages now also has a clean fresh history at its
   canonical path; its superseded history remains in a recoverable backup. Exact source/local
   commits and manifest hashes are in the C684 and C685 reports. The five earlier exported paper
   repositories now cite `10.5281/zenodo.21650878` explicitly as the formal companion's concept
   DOI; the independently owned `finitegeom` repository was not modified by the paper-side update.
   Golden quantum statistics now also has a clean no-remote `main` history at
   `~/src/math-papers/golden-quantum-statistics`, commit `8929f2cf`, from
   Othello source `7eee6069`; its isolated paper gate passes.  A separate
   `finitegeom` candidate worktree at
   `~/src/lean/finitegeom-golden-quantum-statistics`, branch
   `candidate/golden-quantum-statistics`, commit `1b9caa9`, contains the exact
   one-module balanced-cut companion and complete trust/export metadata.
   Static manifest and trust audits pass; real Lean elaboration and clean
   replay wait for a quiet build window.  Report:
   [`../2026-08-02-golden-quantum-statistics-standalone-export.md`](../2026-08-02-golden-quantum-statistics-standalone-export.md).
9. **C685--C687 extraction corrections:** C685 is complete: it replaced the false “Passages has no
   Lean” intake inference with reviewed formal-companion roots while retaining the paper's honest
   no-formal-dependency boundary, and the standalone paper now pins the exact public commit. C686
   materializes the downstream q16 certificate repository and
   moves its final aggregate out of the human Arcs gate. C687 completes the same exact,
   content-addressed, one-way split for the remaining declared q11/q13/q25 generated families.
   Contracts: [`../2026-07-28-c685-c687-extraction-corrections.md`](../2026-07-28-c685-c687-extraction-corrections.md).
10. **C698--C702 Paper I v2 formalization:** the user explicitly placed the extracted
    `finitegeom` and downstream Paper I companion work in `build-sys` scope.  The audit found that
    the current human gate covers only the v1 chord-defect/q9/small-\(k\) surface, while the revised
    paper also needs the signed two-graph/cubic/golden core and the q13
    \([78,36,12]_2\) minimum-layer theorem.  Keep human-scale reusable results in `finitegeom`;
    update the existing q11 leaf; create a separate q13 leaf; preserve v1; and compose a new v2
    aggregate only after exact pins, manifests, axiom audits, regeneration, and clean replay agree.
    Audit and implementation plan:
    [`../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`](../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md).

11. **C759 external trust exports complete:** the v0.3-compatible manifest, portfolio headline
    table, and exact 95-terminal JSON projection are generated from C326/C681 authorities;
    deterministic regeneration and stale/manual-edit rejection are tested. Thirty-six terminal
    axiom sets are extracted and matched, while 59 remain explicitly unextracted. The disposable
    Nanoda pilot stopped at its precondition because the pinned toolchain is Lean 4.32.0-rc1 rather
    than a final 4.32 release. Report:
    [`../2026-08-01-c759-external-trust-exports.md`](../2026-08-01-c759-external-trust-exports.md).

### C685--C687 operator progression

1. **C685 complete.** The statement map is settled:
   `ClebschOrientationMechanisms` is the exact three-module current-paper companion;
   `ClebschPassageInterfaces`, `ClebschHarmonicQuotient`, and `Q11BrianchonPetersen` are excluded.
   `finitegeom` commit `d8ea8326f09da54ffd50b77a3bf54f91a7fbb5ed` and standalone-paper commit
   `db4fb67c78997d3c770677313e077b1341ee4654` passed their exact-commit clean-room gates. Current
   report:
   [`../2026-07-28-c685-clebsch-passages-formal-companion.md`](../2026-07-28-c685-clebsch-passages-formal-companion.md).
2. **Run C686 second, after the human Arcs core has an immutable `finitegeom` commit.** Use that
   commit as the sole upstream library pin; materialize and validate the q16 package and its
   downstream aggregate; then update the Arcs paper repository to pin both exact commits. Starting
   the real q16 cold build remains an explicit user gate.
3. **Run C687 third and reuse C686's validated repository/manifests/gate shape.** The Clebsch
   Rigidity q11 and ProjectiveCap q11/q13 packages may proceed once their own source/trust inputs
   are frozen. Only the q25 subpackage waits for C318 and C319; every package waits for its
   applicable C324 regeneration check. C687 closes only when all adopted field packages have an
   explicit validated or explicitly deferred disposition.

The handoff from each task is an immutable upstream identity, not copied files: C685 yields the
Passages `finitegeom` state; C686 yields the reusable certificate-package pattern plus q16 commit;
C687 applies that pattern to the remaining families. C684 consumes those identities to finalize
paper-local pins and never becomes an upstream dependency of a Lean repository.

### C698--C702 operator progression

1. **Run C698 first.** Land the reusable signed-two-graph API and the six-vertex human Paper I
   theorems in `finitegeom`.  Full projective automorphisms require the singular-locus/frame bridge;
   the integral order requires an actual integral centralizer theorem.
2. **Run C699 on the existing q11 package.** Replace its stale `finitegeom` pin and prove that the
   certified q11 syndrome/support data recover C698's switching class and golden operator.
3. **Run C700 for the reusable q13 foundation.** Formalize the Lemma of Tangents and finite-code
   reductions in `finitegeom`; keep all exhaustive q13 catalogues out.  C700 is logically
   independent of C698 and may move before C699 if useful, but the release must converge on one
   final `finitegeom` revision.
4. **Run C701 in a new q13 package.** Use sharded meet-in-the-middle certificates for distance and
   certify the entire minimum layer, reconstruction, and automorphism group.  Do not elaborate the
   raw multi-million profile spaces.
5. **Run C702 last.** Add a new v2 aggregate gate, align q11/q13 on one upstream commit, freeze the
   trust surface, and refresh the standalone paper pin.  Preserve the v1 aggregate unchanged.

The targeted literature audit found that the paper's cubic is exactly the
Cheltsov--Tschinkel--Zhang six-nodal \(S_5\)-symmetric model after a coordinate swap.  The
`clebsch` lane owns adding that attribution to the manuscript; `build-sys` owns recording it in
formal provenance and does not make a novelty claim.

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
- C287 current paper intake: [`../2026-07-26-c287-paper-intake-refresh.md`](../2026-07-26-c287-paper-intake-refresh.md).
- C684 paper-repository extraction: [`../2026-07-26-c684-paper-repository-extraction.md`](../2026-07-26-c684-paper-repository-extraction.md).
- Paper I v2 Lean/literature audit and C698--C702 plan:
  [`../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`](../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md).
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
field-specific certificate packages. The first main tag is the exact 26-file closure of the
human-scale terminals cited by the first manuscript; later tags add the hyperbolic-quadric result,
the `FiniteGeom` umbrella, and other reviewed paper-facing closures without copying Lean into paper
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

**Current C287 state (2026-07-25):** five `main`-branch workspaces exist under `~/src/lean/`:
`finitegeom`, Q16 certificates, Q25 certificates, and separate ProjectiveCap Q11/Q13 certificate
packages. Each has no commit and no remote, with only `.gitignore`, `flake.nix`, `flake.lock`, and
the matching `lean-toolchain` staged. All pass `nix flake check --no-build`; none contains Lean
source or Lake targets. No Lean/Lake command or process intervention was performed. The exact
workspace list, nixpkgs pin, measured size gates, and payload blockers are recorded in the C287
plan.

The first-tag contract now resolves four manuscript-cited terminal modules to a content-addressed
26-file / 8,954-code-line inventory. Its 18 external imports are all Mathlib, and it reaches none
of Q16, Q25, or `ProjectiveCap/CertData`. The first whole-closure referee pass found at least 17
modules with public-prose failures, two workflow-bearing public path/name families needing
source-owner decisions, and a separate module-wide docstring gate. Source owners must resolve them
before C287 exports the closure. Reports:
[`../2026-07-23-c287-first-tag-source-contract.md`](../2026-07-23-c287-first-tag-source-contract.md),
`../2026-07-24-c287-first-tag-referee-review.md`, and
`../2026-07-24-c287-source-owner-rewrite-packet.md`.

The theorem audit selects the 26-file manuscript claim closure for reviewers and defers both the
uncited hyperbolic module and the disjoint 24-file `FiniteGeom` component. `FiniteGeom.lean` has no
terminal declaration. The audit also exposes a missing final sum-free terminal and the external
Q11/Q13 terminals whose package provenance and authoritative axiom facts remain unresolved. Report:
[`../2026-07-23-c287-first-tag-theorem-ledger.md`](../2026-07-23-c287-first-tag-theorem-ledger.md).

The C287 boundary now reuses the C326 trust spine rather than introducing another manifest format.
Its area declaration owns exactly 26 modules and names four extraction units and seven terminals;
the scoped audit has only four intentional `facts-missing` findings. The extraction plan recognizes
all units but refuses the current seven-foreign-path worktree. The global graph manifest and shared
generated regions remain unchanged until a coherent quiet-tree regeneration. Report:
[`../2026-07-24-c287-first-tag-trust-spine.md`](../2026-07-24-c287-first-tag-trust-spine.md).

**Next:** obtain one commit-clean immutable private-source checkpoint, then construct the first
fresh-history candidate with the C553 API/prose transformation applied only in the target. The
private monorepo remains unchanged: no source module is deleted, renamed, or rewritten there.

The synchronized intake covers arcs, AME--LU, geometric beyond-four PRS, Clebsch Rigidity,
Clebsch Factorization, Clebsch Passages, and complete ports. C685 delivered the reviewed Passages
formal-companion state and immutable paper pin while preserving the paper's no-Lean-premise
boundary. Arcs' Q16
generated family and Clebsch Rigidity's Q11 generated family remain opt-in certificate packages
rather than entering the human-scale main repository, with C686--C687 owning their complete
materialization and the other declared field-specific packages.
Clebsch Factorization's fingerprint now maps all three advertised gates. Exact current roots,
counts, package splits, and blockers are in `../2026-07-26-c287-paper-intake-refresh.md`. Follow
`../2026-07-25-c287-token-efficient-execution.md`, which pins one immutable private-source
snapshot, deduplicates public-prose review across the full source union by path and hash, then
constructs and validates resumable incremental candidate commits.
The independent C684 paper-extraction lane has clean-room validated the AME--LU and Beyond4 paper
payloads at source checkpoint `e4cc0b0b6ea20840718edac62873806091fc703a`; their paper-only
verifiers deliberately tolerate an absent external Lean companion while preserving stronger
source-closure checks whenever that companion is present.
Commit-scoped trust, axiom, and clean-replay evidence is never reused by file hash; `main` and each
tag advance only after that exact candidate passes. A single quiet build-owner window is preferred
but is no longer an atomicity assumption.
Do not export any certificate payload before its recorded family-specific trust gate and applicable
C324 regeneration check. Q25 additionally waits for C318 and C319; those two tasks do not block
q16 or q11/q13. Do not elaborate or build until a confirmed quiet build-owner window. The first
commits must include reviewed source manifests and public rewrites, not scaffold-only history.
