# Lean build-system hardening

**Lane**: `build-sys`
**Date**: 2026-08-04
**Status**: ACTIVE — C879 is separating paper/shared human layers from frozen Mathlib-only
certificate packages; Q11 and Q16 are sealed behind cheap downstream compatibility bridges

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
paper-mirror synchronization, Lean area export, certificate migration, or paper-bridge re-pin — nothing else may write
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
- Any commit in a certificate package — including a README typo fix — moves its `HEAD` off the
  `commit` pin in `lean/trust/certificate-packages.toml`, and the boundary check compares the two.
  Bump the pin in the same change; `lean-external-fact.py pin` maintains only the trust-fact copy,
  never that field.
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

The approved main identity is `github.com/tavisrudd/finitegeom` at `~/src/lean/finitegeom`.  Call
it the **finitegeom repo**, never "the base" or "the companion": both are role words that shift
meaning between a pinned revision, a module set, an export target and a candidate branch, and the
repository already has a name.  Say "the pinned finitegeom revision" for a commit, "the finitegeom
module set" for its contents, and "upstream library" only where a package's dependency relationship
is the point.  The unit the exporter moves is an **area** — one declared gate's module closure, named
by a configuration under `lean/trust/export/` — so `lean-area-export.py` runs an area export.
"Companion" belongs to a paper's computational companion and to a sibling companion paper, and is
never used for the finitegeom repo or for a Lean artifact.
Heavyweight generated closures stay outside it in Mathlib-only certificate packages under
`~/src/lean/`. Human definitions, reusable schemas, field-independent soundness APIs, and small
examples stay in the monorepo and finitegeom; generated leaves, enumerated tables, package-private
checkers, generators, and replay outputs belong only to their owning package. The monorepo never
imports an external certificate closure — it consumes a pinned trust fact. Cheap paper bridges,
not finitegeom, import both the human API and a certificate and prove theorem transport. Q11 and
Q16 retire every `RelativeConicArcs` path and declaration during their one-time migration; their
sealed APIs are `TavisRuddFiniteGeom.Certificates.Q11.*` and
`TavisRuddFiniteGeom.Certificates.Q16.*`. The first-tag size gate
is at most 100 Lean files / 25,000 code lines, and the planned human-scale union at most 500 /
75,000. Each paper export carries its own `flake.nix`/`flake.lock` resolving exact pins; certificate
packages are opt-in leaves, and no portfolio-wide certificate umbrella is allowed. Commit-scoped
trust, axiom, and clean-replay evidence is never reused by file hash.

## Toolchain

- `lean/scripts/guarded-lean`: one bounded single-file elaboration through `run-quiet`.
- `lean-build-queue.py`: `plan` (silent preflight, no Lake), `build`/`run` (locked queue, guarded
  cache restore, explicit sequential targets, atomic heartbeats, trace-current skipping, final
  aggregate gate), `await`, `lock`,
  `status` (owner-descendant view, no process-table search), `pack` (guarded `lake pack`), and
  `regenerate` (the package's separate `.#regenerate` app under the same owner guard).
- `lean-build-systemd.py`: the adjacent managed path, explicitly selected, same lock and caps.
- `lean-restart-guard.py`: trace-validated checkpoint/verify/audit-log with a hermetic failure
  suite. Exercised against the Q13 restart: validated sentinels remained current and byte-identical,
  and the resumed log rebuilt neither.
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
  in the monorepo, any generated family belonging to no package and to no declared pending family,
  and any generator a generated banner names that no family declares — the rule that reaches
  `notes/`, which its scan roots do not; `--verify-official-libraries` also checks package pins and published facts and rejects a
  monorepo file byte-identical to one an official package owns.  The `pending_family` table in
  `lean/trust/certificate-packages.toml` declares each generated family still resident here and the
  package that will own it; it is empty only when the externalization is complete.  Its sibling
  `resident_family` table declares generated data a written determination keeps here permanently.
- `lean-package-source-audit.py`: read-only comparison of a package's sealed sources against the
  monorepo revision they came from, the current tree, and the pinned finitegeom revision.  Runs no Lean, takes no
  lock, so it is valid while another lane holds the tree.  `--declared-transformation` names an
  extraction-time comment normalization the package declares in its `PROVENANCE.md`; sources the
  rules reproduce are reported as transformed, and everything else stays a defect.  It also runs in
  reverse: authority files inside an owned family that the package does not seal, payload files the
  manifest does not seal, and an owned family with no sealed source at all.  Owned families come
  from `--family-prefix` or the declared `owned_module_prefixes`, anchored against a sealed source
  rather than an assumed layout.  `--strict` promotes the first two to defects; payload sealed and
  then edited is a defect either way.
- `lean-certificate-portfolio-audit.py`: read-only sweep of any set of working roots for generated
  Lean families, recognizing a generated source by its naming of its own generator.  `--payload`
  reports those generators and whether each is resident; `--build-artifacts` reports build outputs
  whose Lean source no longer exists, which is how an extraction's residue is found.
- `paper-facts.py`: per-manuscript facts from tracked bytes, plus `audit`/`check`. Runs no Lake,
  LaTeX, or BibTeX.
- `lean-area-export.py`: `plan`/`run` for area export onto the finitegeom
  repository. Materializes twice, requires byte-identical repeats, never commits or pushes. It also
  reports candidate sources citing an artifact path the candidate does not carry, warning by default
  and refusing under `--strict-citations`.
- `lean-blast-radius.py`: read-only import-DAG analysis. Blast radius exact; cost columns are
  unvalidated size proxies.
- Resource profiles: `lean-build-profiles.json`.

## Active frontier, in order

**C891 closed (2026-08-08): the complete paper-extraction map is current.**
The C879 map now checks all seventeen paper records, fifteen standalone
repositories, twelve tracked export areas, and every AME module; it records
secondary-entry-point aliases, absent export areas, the MDS--CSS dependency on
AME--LU, and the two unresolved Clebsch companion bindings.  Its read-only
replay fails on registry, closure, source, target, or Lean-authority drift.  No
Lean source, package, mirror, or remote changed.  Full report:
[`../2026-08-08-c891-full-paper-extraction-mapping-refresh.md`](../2026-08-08-c891-full-paper-extraction-mapping-refresh.md).

1. **C864 certificate closeout.** The integrated closeout for the remaining C686/C687 execution and
   the certificate boundary portion of C287/C324. Card, execution order, and acceptance:
   [`../build-sys-tasks/c864-external-certificate-closeout-and-audit.md`](../build-sys-tasks/c864-external-certificate-closeout-and-audit.md).
   **The active work runs from the ordered, checkpointed
   [export-completion execution plan](../2026-08-06-c864-export-completion-execution-plan.md)** —
   start there, not from the card's execution order. It carries the resume state, the decisions
   already taken, exact commands, and its own stop points; it excludes the projective-cap, order-13
   and order-25 externalizations and the unpublished papers, so finishing it does not close C864.
   Its phases 1 through 4 are done, and phase 5 ran through checkpoint 10 and most of step 26
   (`../2026-08-06-c864-phase-five-published-papers.md`): the beyond-four PRS bibliography, the
   restating documents and eight facts artifacts are current, and the Clebsch passages, Clebsch
   factorization, AME/LU, beyond-four PRS and golden quantum statistics release gates are green.
   The order-eleven package's external fact declares a terminal the package itself proves — the
   exhaustive point-orbit partition — and `lean-external-fact.py` refuses any other, so a fact can
   no longer claim credit for what its dependency proves. The two order-eleven Brianchon statements
   are theorems of finitegeom, and no artifact calls them axioms: the module is
   `Q11BrianchonClassification`, and the tree's project-local axiom table names neither. The
   `_human` suffix is gone from the Clebsch rigidity and arcs areas. Paper I's release chain is
   green at package `a80e7de6`, and Clebsch rigidity, Clebsch passages and the arcs paper all pin
   finitegeom `575cf3e9`; a pin may now run ahead of its area's export when it carries that export
   unchanged. Phases 5 and 6 are done through step 33
   ([`../2026-08-06-c864-mirror-sync-and-phase-six.md`](../2026-08-06-c864-mirror-sync-and-phase-six.md)):
   every published paper and the portfolio summary is synchronized to its standalone repository with
   its release gate replayed there and its export manifest verified, and the order-eleven package
   source audit reports zero unexplained drift. Open: the order-eleven certificate package is ahead
   of its public `main` and awaits the author's push.
   The second pass's complete repair ports half is decided but not executed
   ([`../2026-08-06-c864-complete-repair-ports-editorial-determination.md`](../2026-08-06-c864-complete-repair-ports-editorial-determination.md)):
   of its ten internal working documents, the four current ledgers and a rewritten README ship,
   while the adoption map, fix plan, section map, superseded proof ledger and adversarial novelty
   review stay private, moved out of the export root rather than excluded in the registry. Its
   bibliography and rebuilt PDF are repaired. Neither its release chain nor its mirror ran, and
   neither should yet: the paper has no `verification/` directory to run a chain from, and its lane
   handoff, the papers index and its own control documents all record publication as gated, with
   four of twelve adopted theorem slots unadmitted. Its registry disposition is `active`, the only
   reason materialization would be permitted; re-marking it `gated` is the one immediate item and
   awaits the author, as does its destination, unsettled between the `math-papers` repository name
   and the `complete-ports` name both its README and its lane handoff record.
   The earlier phases resumed at step 22, the first paper-side step
   (`../2026-08-06-c864-finitegeom-standalone-build-gate.md` and
   `../2026-08-06-c864-order-eleven-package-reseal.md`): all twelve areas are registered,
   adopted and idempotent with golden quantum statistics now among them, the stale build residue is
   swept, the order-eleven `pending_family` entry is gone, and two guards are in place — a package
   module colliding with the pinned finitegeom revision, and an export that would not resolve as a
   repository of its own. That second gate found that finitegeom had never built standalone: four
   libraries declared no roots because the exporter's root insertion donated their modules to an
   unrelated library. All seven targets now build green — the first time finitegeom has built every
   target it declares. The seventh, `ProjectiveCap`, was repaired separately
   (`../2026-08-06-c864-projectivecap-standalone-repair.md`) by carrying
   `ProjectiveCap.ProjectiveCapGame` and `ProjectiveCap.PlaneTransitivityGame` across
   byte-identically and restoring six consumers' imports.
   That repair exposed a defect class the toolchain has no guard for: an area export can
   byte-identically replace a shared base module and delete declarations that consumers outside its
   closure depend on, leaving no dangling import and passing every gate. The MDS--CSS
   transversal-group adoption did exactly that on 2026-08-03. finitegeom's projective-cap consumers
   still predate the monorepo's 2026-08-03 reorganization, so the affine-chart dictionary exists
   there twice and five import differences from the authority remain; bringing them current is a
   content refresh of an area that has no export configuration at all.
   Done: the order-16 package is sealed, packed, restore-rehearsed trace-current, and its external
   trust fact is published and pinned; the Kim--Vu and Al-Seraji--Al-Ogali anchors are exact.
   The finitegeom game-free/game split is landed and gate-green in the monorepo: the validity
   predicate now sits in `RelativeConicArcs/ParametrizedHoles.lean`, `Q11Residual` is game-free, and
   the terminals are in `Q11ResidualGame`.
   The order-eleven point-orbit family is externalized: `finitegeom-clebsch-q11-certificates` owns
   it at commit `a289097b`, sealing source commit `82bc5581` over 115 modules and two support files,
   pinning finitegeom at `dca9ce75`, gate-green with all fifty-five terminals over the three standard
   axioms and no Dye statement among them, with its trust fact published and pinned; the monorepo
   deletions landed and both the boundary and external-fact checks are green.
   The package/monorepo byte-identity audit is done and green through the new
   `lean-package-source-audit.py`; it also established that the finitegeom re-export and the package
   re-seal must happen in one window, because the monorepo's orientation rename has not reached the
   finitegeom, the package, or the paper's trust manifest
   (`../2026-08-05-c864-q11-package-source-audit.md`).
   The Paper I remediation currently holds the shared tree and the Clebsch-rigidity release chain, so
   C864 is taking only steps that need no build window and no quiet tree; the near-term plan is on
   the card.  Done there without a window: the adversarial boundary-checker fixtures, split-line
   planning for the remaining order-eleven families, the order-25 banner transformation now declared
   as `q25-banner-normalization-v1` and machine-checked
   (`../2026-08-05-c864-q25-banner-transformation-declaration.md`), the classification of the
   generated modules finitegeom carries — one real, two false positives of a banner rule that matched
   ordinary prose (`../2026-08-05-c864-base-generated-module-classification.md`), and the non-Lean
   payload and build-artifact sweep that closes portfolio-audit step 6
   (`../2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md`): the boundary checker now
   resolves the generator every generated banner names and rejects one no family declares, the
   order-25 generators, replay programs and replay data are declared payload, and the point-orbit and
   order-16 build residue is measured and queued for the finitegeom re-export window.  The non-Lean payload
   seal convention is settled as one `support_files` list read alongside both earlier spellings, and
   the source audit now runs in reverse
   (`../2026-08-05-c864-payload-seal-convention-and-reverse-audit.md`): both adopted packages hold
   every authority file in the families they own, and the order-eleven package's reseal window picks
   up its two unsealed gate-evidence files.  The exporter now reports sources citing artifact paths
   the candidate lacks; finitegeom's published `main` carries three
   (`../2026-08-05-c864-dangling-artifact-citations.md`); the decision that finitegeom ships the
   verification directories its generated tables cite is taken, and the exporter now carries whatever
   a planned module cites under the source `lean/` root.  Then, once the
   tree is coherent, the release-chain replay, the atomic finitegeom re-export and package re-seal, the
   q13/q25 packages, the portfolio audit, the Arcs/Clebsch-rigidity trust disposition, and the
   all-paper export replay.
2. **C879 paper-boundary extraction.** Execute the ownership/import manifest, final
   `TavisRuddFiniteGeom` namespaces, import firewalls, extraction order, and clean-replay gates in
   `../2026-08-06-c879-finitegeom-paper-extraction-plan.md`. Q11 and Q16 are branded,
   Mathlib-only, sealed, and cached; their bridges hash the frozen aggregate artifacts and never
   invoke a certificate build target. The live mapping covers seventeen paper records, fifteen
   standalone repositories, twelve export areas, and all AME--LU modules. Projective-cap Q11 now
   follows that boundary; Q13 and Q25 are the remaining certificate separations, each using a
   package-local statement model plus a cheap downstream adapter.
   Paper I is current on the separated three-repository boundary at monorepo commit `0b322c1d` and
   exporter-produced standalone commit `1e3cce4`; its final verifier is green, and
   `clebsch_rigidity.pdf` has SHA-256
   `85d6fa17475a6771027904c329bd5c10f04e5ed19553c7931d25810d27772a4f`.
   The standalone projective-cap Q11 certificate is sealed at package commit `54fb4f83`;
   guarded run `run-20260810-171214-7ce5ea23` built its final aggregate in 47m30s at
   5.43 GB peak, and its Lake pack has SHA-256
   `24860c9e950cca12ff17b4875257bbe8b56860c6ac2353c9ef8ee3eebfd7ff32`.
   Its exporter-created downstream bridge is at standalone commit `570f304f`; the static bridge
   audit is green against finitegeom `b871c10b` and certificate `54fb4f83`. Its cheap verifier and
   registry pin remain queued behind the active Q13 build; the legacy monorepo family stays pending
   until that bridge is green and its consumers move.
   Projective-cap Q13 is independently Mathlib-only with 113 authenticated frozen inputs and 114
   materialized outputs at Lean-source commit `0dc0510`. Classes 0--40 are complete; sequential
   run `run-20260810-233857-b4421bc3` owns Classes 30--109, Data, Assembly, and the root gate, with
   Class41 current. Each high-memory class is a separate queue target, preventing sibling overlap.
   After it finishes, cherry-pick metadata commits `156af07`, `d0a4213`, `ed50b4d`, `51ec6c2`,
   refresh only the cheap aggregate root, then seal and pack. Q25 is independently Mathlib-only at
   `72130996`; before its one aggregate build it still needs the guarded 7,547-source regeneration,
   the six-module preflight beginning at `Normalization`, and the final external registry entry.
3. **Real lightweight gate.** In a confirmed quiet window, run one disposable target through the
   queue and verify actual Nix/Lake/run-quiet/GNU-time behavior. The restart guard needs the same
   window for one real checkpoint→restart→audit→verify cycle on disposable state.
4. **C326 extraction over the project.** The exporter and driver are validated against core Lean;
   what remains is running extraction in a quiet Lean worktree. All five gates report
   `facts-missing`, so every declared terminal-axiom set is unverified until then.
   `lean-trust-extract.py plan` reports whether the window is open.
5. **Paper-facts steps 4 and 5.** Generated regions in `papers/papers-index.md` and
   `papers-planning.md`, gated on the registry writer's agreement; adequacy-appendix rendering,
   gated on Lean extraction having run.
6. **C287 first-tag export.** Obtain one commit-clean immutable private-source checkpoint, then
   construct the first fresh-history candidate with the C553 API/prose transformation applied only
   in the target. The private monorepo is not modified.
7. **C698--C702 Paper I v2.** Run in order: signed-two-graph core in `finitegeom`; q11 orientation
   bridge; q13 Segre foundation; q13 tangent-code certificates; then the v2 release, aligning
   q11/q13 on one upstream commit and preserving the v1 aggregate unchanged.

Every registered area is current on finitegeom and reports an empty forward delta, golden quantum
statistics included since its adoption on 2026-08-06.

The former certificate re-pin workflow is retired. Heavy packages import Mathlib only;
paper bridges pin finitegeom and the applicable frozen certificate independently.

The larger one: most of the published shared library has no tracked export configuration.  finitegeom
seals eleven areas, of which only four are registered under `lean/trust/export/`; the seven
unregistered ones seal 290 modules against 130 registered, and five of them name the same source
commit `10d1941a` of 2026-07-28.  They span the AME/LU aggregate, both arcs areas, Clebsch
factorization, Clebsch rigidity, complete ports, and the beyond-four PRS foundation, so registering
them crosses several lanes.  All eleven are now registered, re-exported from a tracked configuration,
and adopted with their gate green, and golden quantum statistics joined them as a twelfth.  The human Arcs area supplies the
`ParametrizedHoles.lean` leaf and the game-free `Q11Residual`/`Q11Coding` that finitegeom lacked, and
the human Clebsch rigidity area makes both Dye statements theorems there rather than axioms.
Declaring the previously unregistered gates and their terminals dropped the repository-wide spine
check from 161 findings to 115.

Native evaluation is now rejected in trust declarations.  Five AME/LU terminals were discharged by
`native_decide`, reaching the MDS--CSS area too, so the three underlying marginal counts were
reproved by kernel reduction and the spine now reports any terminal carrying an evaluation axiom,
recognized by the marker the toolchain builds into the name rather than by a fixed list.  An area
that audits through a sibling gate prints its declarations under opened namespaces, so the registry
records names resolved against the extracted declaration set rather than the short printed forms.

Registering the Arcs area exposed an exporter defect, now fixed with a regression test: cited Lean
modules were carried as verification apparatus, so an export could overwrite a module its area does
not own while leaving that module's seal describing the previous bytes.

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
Dye audit and anchor review [`../2026-08-04-c864-dye-audit-and-anchor-review.md`](../2026-08-04-c864-dye-audit-and-anchor-review.md);
portfolio audit [`../2026-08-05-c864-certificate-portfolio-audit.md`](../2026-08-05-c864-certificate-portfolio-audit.md);
order-25 banner transformation [`../2026-08-05-c864-q25-banner-transformation-declaration.md`](../2026-08-05-c864-q25-banner-transformation-declaration.md);
base generated-module classification [`../2026-08-05-c864-base-generated-module-classification.md`](../2026-08-05-c864-base-generated-module-classification.md);
non-Lean payload and build artifacts [`../2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md`](../2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md);
payload seal convention and reverse audit [`../2026-08-05-c864-payload-seal-convention-and-reverse-audit.md`](../2026-08-05-c864-payload-seal-convention-and-reverse-audit.md);
dangling artifact citations [`../2026-08-05-c864-dangling-artifact-citations.md`](../2026-08-05-c864-dangling-artifact-citations.md);
passages re-export and the unregistered arcs area [`../2026-08-05-c864-passages-re-export-and-unregistered-arcs-area.md`](../2026-08-05-c864-passages-re-export-and-unregistered-arcs-area.md);
export-completion execution plan [`../2026-08-06-c864-export-completion-execution-plan.md`](../2026-08-06-c864-export-completion-execution-plan.md);
standalone build gate [`../2026-08-06-c864-finitegeom-standalone-build-gate.md`](../2026-08-06-c864-finitegeom-standalone-build-gate.md);
projective-cap repair [`../2026-08-06-c864-projectivecap-standalone-repair.md`](../2026-08-06-c864-projectivecap-standalone-repair.md);
order-eleven package reseal [`../2026-08-06-c864-order-eleven-package-reseal.md`](../2026-08-06-c864-order-eleven-package-reseal.md);
phase 5 published papers [`../2026-08-06-c864-phase-five-published-papers.md`](../2026-08-06-c864-phase-five-published-papers.md);
mirror sync and phase 6 [`../2026-08-06-c864-mirror-sync-and-phase-six.md`](../2026-08-06-c864-mirror-sync-and-phase-six.md);
complete repair ports editorial determination [`../2026-08-06-c864-complete-repair-ports-editorial-determination.md`](../2026-08-06-c864-complete-repair-ports-editorial-determination.md).

**Paper I v2** — audit and plan
[`../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md`](../2026-07-29-c698-c702-paper-i-v2-lean-audit-plan.md);
per-step cards under [`../build-sys-tasks/`](../build-sys-tasks/).

**Repo-wide standard owned here** — literature-audit conventions
[`../literature-audit-conventions.md`](../literature-audit-conventions.md), reviewed in
[`../2026-07-19-c365-literature-audit-conventions-fable-review.md`](../2026-07-19-c365-literature-audit-conventions-fable-review.md).
Its read-depth vocabulary and coverage outcomes are the source of truth for the C328
evidence-metadata schema and must change together with it.

## Discovery track

Incidental observations: [`../2026-08-05-build-sys-discovery-track.md`](../2026-08-05-build-sys-discovery-track.md).

## Registered spin-off (no C task)

The `lean-proof-engineering-at-scale` methods-paper idea and its five upgrade gates are registered in
`papers/papers-index.md` and the archive. C allocation is gated on a manuscript outline and a
measurable contribution beyond repository-specific operating instructions; none is allocated here
until that gate is met.
