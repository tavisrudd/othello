# C864 — execution plan to a complete, valid finitegeom export and consistent published papers

**Lane:** `build-sys`

**Date:** 2026-08-06

## How to use this document

This is an executable plan, written so a session holding none of its history can run it end to end.
Every decision it depends on has already been taken and is recorded in "Decisions taken" below with
the evidence and the observation that would overturn it.  Do not re-open those decisions unless
their stated falsifier is actually observed; if one is, stop and say which.

**The run does not stop for a human at all.**  The author handles every push after the local job is
complete, so no step waits on one.  The apparent obstacle — a certificate package resolving
finitegeom by public Git URL, so it cannot build against an unpublished revision — is solved by the
guarded lock refresh, which prefetches an exact unpublished revision from a local checkout:

```sh
python3 ~/src/othello/lean/scripts/lean-build-queue.py update-lock finitegeom \
  --lean-root ~/src/lean/finitegeom-clebsch-q11-certificates \
  --local-source ~/src/lean/finitegeom
```

Run everything to completion locally, then hand the author the full list of repositories to push:
finitegeom, the order-eleven certificate package, and every published paper mirror under
`~/src/math-papers/`.

A genuine validation failure is a stop: report the failing checkpoint and its output rather than
working around it.

### Read before acting

`lean/AGENTS.md` (`lean/CLAUDE.md` is its symlink) before any Lean edit, build, generator run,
extraction, or process intervention.  `notes/export-and-mirror-conventions.md` before any area
export, certificate re-pin, or paper-mirror synchronization — nothing else may write under
`~/src/lean/` or `~/src/math-papers/`.  `notes/research-reproducibility-conventions.md` before any
paper-facing computational claim.  `papers/style-guide.md` before touching manuscript prose.

### Progress: phases 1 through 4 are done

Executed on 2026-08-06 and committed in all three repositories; resume at step 22, the first
paper-side step of phase 5.  Findings and evidence:
`2026-08-06-c864-finitegeom-standalone-build-gate.md` for phases 1 and 2, and
`2026-08-06-c864-order-eleven-package-reseal.md` for phases 3 and 4, which records checkpoints 5,
6, 7 and 9 green and four further defects the phase exposed.

Phase 2's standalone build found finitegeom's `ProjectiveCap` library broken, and it was repaired
under a separate instruction before phase 3 began
(`2026-08-06-c864-projectivecap-standalone-repair.md`): `ProjectiveCap.ProjectiveCapGame` and
`ProjectiveCap.PlaneTransitivityGame` were carried across byte-identically and six consumers'
imports restored, taking the manifest to 319 modules.  All seven targets now build green, so the
revision step 13 pins is one whose every declared target builds.

That repair exposed a defect class no guard covers: an area export can byte-identically replace a
shared base module and delete declarations that consumers outside its closure depend on, leaving no
dangling import and satisfying every existing gate.  finitegeom's projective-cap consumers still
predate the monorepo's 2026-08-03 reorganization, so the affine-chart dictionary exists there twice
and five import differences from the authority remain.  Neither is in this plan's scope; both need
the projective-cap area to have an export configuration, which it does not.

- The two orphan gates are deleted, their `lakefile.toml` roots removed, and their entries plus the
  stale `RelativeConicArcs.PaperIOrientationSpine` root removed from `TARGET_MANIFEST.json`
  (`sources` 316 → 314).  finitegeom commits `0508f4e` and the two that follow it.
- **Checkpoint 1 passed.**  No manifest entry names an absent path, no root names an absent module,
  `module_count` matches `sources`, and `RelativeConicArcs.Gates.ArcsCompleteOutsideConic` builds
  green in finitegeom.
- **Checkpoint 2 passed**, after two fixes it surfaced.  The eleven-area idempotence run first
  refused every area with `base prose disagrees with the base manifest`: the hand edit in step 3
  changed the module count while finitegeom's `README.md` and `PROVENANCE.md` still said 316.  This
  is precisely the failure checkpoint 2 exists to catch — do not skip it after any hand edit to a
  generated manifest.  The support-cubic orientation area then showed a one-file delta, its trust
  statement still calling the artifact a companion, which the vocabulary rule forbids; it was
  adopted.
- **Step 4 done.**  The residue sweep deleted 264 files and 28.4 MB — a build output whose Lean
  source no longer exists in its root, and nothing else — across all three roots, with the build
  owner free.  The portfolio audit now reports no built module without a source anywhere.
- **Checkpoint 3 passed.**  Golden quantum statistics exported to a twelve-file delta, its gate
  built green in finitegeom, the delta was adopted, and its re-export is empty.  All twelve
  configured areas report an empty forward delta, so every configuration has an adopted counterpart.
- **Step 7 done.**  None of the seven order-eleven modules carries a generated banner — the
  decision's falsifier did not fire — so the `pending_family` entry naming them is removed and
  `lean-certificate-boundary.py` is green.
- **Checkpoint 4 passed.**  The module-collision rule and the standalone-resolution gate both go red
  on constructed violations and are green on the real tree; all three suites pass.  The collision
  rule also fires on the real order-eleven package, for the eight modules phase 3 removes.
- **Step 9 changed shape.**  finitegeom had never built standalone: four libraries declared no roots
  and so named absent top-level module files, because `insert_lakefile_roots` searched past the end
  of the named library's section and donated their modules to an unrelated library.  Both the
  exporter and finitegeom's `lakefile.toml` are fixed, and six of seven targets build green.

### Current state

- Monorepo `~/src/othello` is clean and its work is committed.
- finitegeom `~/src/lean/finitegeom` is clean, and its local `main` is **ahead of `origin/main`**.
  All twelve of its areas are registered under `lean/trust/export/`, re-exported from tracked
  configurations, gate-green, and idempotent.
- The order-eleven package `~/src/lean/finitegeom-clebsch-q11-certificates` is clean and committed
  at `a289097b`, pinning finitegeom at `dca9ce75`, with its gate green, its manifest sealing 115
  sources plus the two support files, and its trust fact published and pinned in the monorepo.
- The sandbox cannot reach GitHub over SSH.  Verify a push with
  `git ls-remote https://github.com/tavisrudd/<repo> main`, never a local `origin/main` ref, which
  goes stale and reads as "already pushed".

## Scope

In scope for this first pass: the finitegeom tree and its twelve areas, the order-eleven certificate
package, and the published papers — Clebsch rigidity as Paper I with its computational companion,
factorization as Paper II, passages as Paper III, arcs complete outside a conic, beyond-four
projective Reed--Solomon, AME/LU, MDS--CSS transversal groups, and golden quantum statistics — plus
the portfolio summary.

Deferred to a second pass, described at the end: the order-13 passant code (Paper IV) and complete
repair ports.  Both are paper-side only when resumed; neither needs an export or a build window.

Out of scope: the projective-cap order-eleven and order-13 externalizations, the order-25
externalization, and the unpublished papers — continuation graph rigidity, dihedral Schreier node
Kayles, equivariant robust completion, and the golden operator programme.

Because three of the four `pending_family` entries are out of scope, that table will not be empty and
**C864 cannot close on this plan**.  This delivers a valid, complete, replayable export and
consistent published papers, not C864's acceptance item 9.

## Decisions taken

**The seven order-eleven modules stay in finitegeom, and the `pending_family` entry naming them is
removed.**  `ClebschGatewayQ11Extension`, `Q11BrianchonPetersen`, `Q11CodeRigidityBridge`,
`Q11DecodingSynthesis`, `Q11DyeConsequences`, `Q11RigiditySpine` and
`SixArcDegenerateConicExclusion` are human-scale theory, not enumerated tables; all seven were
measured byte-identical to the monorepo authority; the rigidity gate's extracted fact shows no
project axiom and no generated content in them; and the split-line determination in
`notes/2026-08-05-c864-order-eleven-remaining-split-lines.md` concluded the remaining cut is "the
order-16 kind", where statements and definitions stay and only exhaustive proofs move.  The package
carried copies only because finitegeom lacked them.  *Falsifier:* if any of the seven is found to
carry a generated banner or an enumerated table, it belongs in the package instead — reverse that
one module and keep the entry for it.

**Golden quantum statistics is adopted into finitegeom.**  It is a deposited paper with a DOI and a
standalone mirror, and it is the one registered export configuration with no counterpart on
finitegeom's `main`; leaving it out means a published paper's formal artifact has no home in the
shared library while every other published paper's does.  Adoption is an ordinary forward commit.
*Falsifier:* if its export refuses to plan, or its gate does not build green inside finitegeom, do
not force it — record the reason, skip it, and note in the paper's release surface that its Lean
development sits outside the shared library.

**The order-eleven package keeps the `RelativeConicArcs` namespace for now.**  Only its gate is
renamed.  Moving the package to its own top-level library is the structural fix for module-name
collisions, but it touches all 122 sealed sources and belongs in its own task; the collision rule in
step 8 is the interim guard.

## Phase 1 — finish the finitegeom tree

Deletions here are of build outputs and of two source files nothing imports.  Confirm no build is
running before the residue sweep: unlinking build outputs under a tree another lane is building is
the interference the lane rules forbid.

1. Remove the two orphan gates `RelativeConicArcs/Gates/ClebschRigidityHuman.lean` and
   `RelativeConicArcs/Gates/ArcsCompleteOutsideConicHuman.lean`.  They are residue of the untracked
   export apparatus, superseded by the gates now exported from tracked configurations, and
   `ArcsCompleteOutsideConicHuman` still imports `RelativeConicArcs.Q16Reduction`, which the monorepo
   dropped at order-16 externalization.  Nothing imports either and no trust file names them.
2. **Both are `roots` entries in finitegeom's `lakefile.toml` (around lines 213 and 220).  Remove
   those two lines in the same change** — deleting the files alone leaves the library declaring roots
   that do not exist, which fails the build.
3. Remove their entries, and the stale root `RelativeConicArcs.PaperIOrientationSpine`, from
   `TARGET_MANIFEST.json`.  Nothing in the toolchain models a deletion from finitegeom: the exporter
   carries the base manifest's `sources` forward, so a deleted file's entry persists until removed by
   hand.  This is the one hand edit to a generated file in this plan, and step 5 is what proves it
   consistent.
4. Sweep the stale build residue.  Re-measure rather than trusting a recorded figure — the current
   count is 33 modules across three roots, not the larger figures in the earlier sweep, because part
   was already cleared.  Identify a stale module as one whose `.olean` exists under `.lake/build`
   while its `.lean` does not, and delete only those.  Confirm no build is running first: unlinking
   build outputs under a tree another lane is building is the interference the lane rules forbid.
   Measured on 2026-08-06: monorepo 11 modules (88 files), finitegeom 13 (104 files, 11.8 MB), and
   the order-eleven package 9 (72 files, 5.5 MB), the last being modules it built locally and now
   takes from finitegeom.  Earlier figures, superseded, are in
   `notes/2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md`.

**Checkpoint 1.**  `TARGET_MANIFEST.json` has no `sources` entry naming an absent path and no root
naming an absent module — check both directions, not just roots.  Every finitegeom area gate builds
green through the guarded queue.  The monorepo's own gates remain green.

5. Re-run all eleven area exports against the current monorepo and finitegeom commits and require an
   empty forward delta from each.  This is the idempotence check and it is also what proves the hand
   edit in step 3 agrees with what the exporter would generate.

```sh
SRC=$(git -C ~/src/othello rev-parse HEAD)
FG=$(git -C ~/src/lean/finitegeom rev-parse HEAD)
for c in ~/src/othello/lean/trust/export/*.toml; do
  python3 ~/src/othello/lean/scripts/lean-area-export.py --config "$c" \
    --source-commit "$SRC" --finitegeom-commit "$FG" \
    run --workdir ~/.cache/othello-lean-build/area-export/idem-$(basename "$c" .toml)
done
```

**Checkpoint 2.**  Eleven empty deltas.  Any non-empty delta means the tree and a configuration
disagree; resolve it before proceeding rather than adopting the delta blindly.

6. Export and adopt the golden quantum statistics area, per the decision above.  Plan, run, copy the
   printed delta with no hand edits, build its gate inside finitegeom, adopt as one forward commit,
   then re-run the export and require an empty delta.

**Checkpoint 3.**  Golden's gate is green in finitegeom and its second export is empty — or the
falsifier fired and the skip is recorded.

7. Remove the `pending_family` entry "order-eleven families awaiting their cut" from
   `lean/trust/certificate-packages.toml`, per the decision above, recording the reason in the commit
   message.

## Phase 2 — guards, before anything depends on them

8. Add a boundary-checker rule rejecting any package module whose name also exists at the pinned
   finitegeom revision.  Lean module names are global across a dependency graph, and two packages
   defining one name is a hard failure in every consumer.  This rule catches both failures seen on
   2026-08-06: seven duplicated modules and a colliding gate.
9. Add a standalone finitegeom build to the export tooling as a gate.  Nothing builds finitegeom on
   its own before a package pins it, which is why a broken export surfaced only three hours into a
   consumer's build.
10. Add adversarial fixtures for both, in the style of the existing boundary-checker fixtures: a
    module name colliding with the dependency, and an export whose result does not build standalone.

**Checkpoint 4.**  Both rules go red on a constructed violation and green on the real tree.  These
suites pass: `test_lean_certificate_boundary.py`, `test_lean_area_export.py`,
`test_lean_trust_spine.py`.

11. Commit phases 1 and 2 in the monorepo and finitegeom.

## Phase 3 — the order-eleven package

12. Refresh the package's finitegeom lock from the local checkout with `update-lock` as shown above,
    so it resolves the unpublished revision without waiting on a push.

**Checkpoint 5.**  The package's `.lake/packages/finitegeom` checkout is at the intended revision and
carries the modules the gate needs, including `RelativeConicArcs/ParametrizedHoles.lean`.

13. Re-point the package's already-edited `lakefile.toml`, `lake-manifest.json` (`rev` **and**
    `inputRev`) and README pin to the pushed revision.  The worktree currently names an earlier one.
14. Rewrite the gate's module header and the corresponding README passages.  Both describe the
    pre-cut content and state that the rigidity conclusion depends on the ten-point Brianchon bound
    and equality classification of R. H. Dye as literature input.  That is false: both are theorems of
    finitegeom as of 2026-08-06.  The README also calls the module "the aggregate Paper I gate",
    which is manuscript-bound naming the artifact rules forbid.  The gate audits 55 terminals — 15
    package certificates in `Examples.Q11A5PointOrbits` and `Examples.Q11Coding`, and 40 human-side
    results imported from finitegeom — so describe it as the rigidity development together with the
    order-eleven certificates.
15. Migrate the two unsealed payload files, `verification/clebsch_rigidity_trust/axiom-audit.txt` and
    `gate-run.log`, into a single `support_files` list in `MANIFEST.json`.
16. Correct `PROVENANCE.md` to the real extraction revision `0ddbca65`, and seal the monorepo
    revision in `MANIFEST.json` as a field distinct from the package's own `source_commit`.
17. Build the gate against the package root and refresh the tracked axiom audit from that
    elaboration's own output, corroborated against the package build's log.

```sh
python3 ~/src/othello/lean/scripts/lean-build-queue.py build \
  RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates \
  --lean-root ~/src/lean/finitegeom-clebsch-q11-certificates --cores 20-23
```

**Checkpoint 6.**  The gate builds green with no module ambiguity.  Its axiom audit records no Dye
statement as a trusted input and no terminal carries a native evaluation axiom.

18. Run the pre-deletion source audit that the card requires before any deletion becomes final, and
    require every difference to be named.

```sh
python3 ~/src/othello/lean/scripts/lean-package-source-audit.py \
  ~/src/lean/finitegeom-clebsch-q11-certificates \
  --authority 0ddbca65 --finitegeom ~/src/lean/finitegeom
```

19. Reseal `MANIFEST.json` in two commits so `source_commit` is self-consistent: first every source
    change, then the manifest alone.

**Checkpoint 7.**  `lean-package-source-audit.py` reports zero unexplained drift.
`lean-external-fact.py check` is green.

## Phase 4 — reconnect the monorepo to the package

20. Record the resealed package revision for the pin update below; publication happens at the end.

21. Update the monorepo's pinned copy of the trust fact under `lean/trust/external/`, and its hash
    pin and `commit` field in `lean/trust/certificate-packages.toml`.  Any commit in the package
    moves its `HEAD` off that pin, so bump it in the same change; `lean-external-fact.py pin`
    maintains only the trust-fact copy, never the `commit` field.

**Checkpoint 9.**  `lean-certificate-boundary.py --verify-official-libraries` is green, including the
new collision rule.

## Phase 5 — published papers

Six papers in this pass have a facts artifact differing from a fresh extraction: AME/LU, arcs
complete outside a conic, Clebsch factorization, Clebsch passages, Clebsch rigidity, and the Clebsch
rigidity companion.

22. Refresh the stale bibliography entries in beyond-four projective Reed--Solomon, which holds seven
    of the nine `stale-bbl` findings across `prs-beyond-redundancy-four.bbl` and
    `prs-beyond-redundancy-four-tit-submission.bbl`.  A `.bbl` is a build output, so this is a
    rebuild against the corrected `refs.bib`, not a hand edit.
23. Resolve the remaining title drifts in `papers/papers-index.md` for published rows, and the
    citation-title drifts in published papers' `refs.bib`.
24. Refresh the four dependency locks that still resolve a finitegeom revision carrying extracted
    order-16 sources.
25. Re-extract the six stale facts artifacts.

**Checkpoint 10.**  `paper-facts.py check` reports no error and no staleness naming any paper in this
pass.  Remaining findings name only deferred, out-of-scope, or unregistered items — currently
`papers/clebsch-series-figures/series-figures.tex`, which is out of scope here.

26. For each published paper in turn, run its release chain per its `verification/README.md`: update
    the pin block, regenerate the statement identity and trust manifest, refresh the tracked PDF
    through that paper's own manuscript checker in update mode, visually inspect changed pages,
    commit the clean release surface, run the aggregate release verifier with `--update-output`,
    rerun the trust-manifest builder to record the new certificate hash, commit, and finish with the
    clean-source release run.

Never build a PDF by hand.  Each checker pins `SOURCE_DATE_EPOCH` to make the build byte-reproducible
and then requires the tracked PDF to equal a fresh build exactly; a hand build without the pinned
epoch is rejected, and that equality is the only thing that detects a stale tracked PDF.

Clebsch rigidity must come after phase 4: its pin block records the package commit and gate digest.

**Checkpoint 11.**  Every in-scope paper's release gate is green in the monorepo.

27. Before syncing any mirror, run `export-paper-repos.py plan --source-ref HEAD` and confirm the
    paper's `reference_findings` is zero.  All nine published papers currently scan clean; a new
    finding means a task identifier or internal path entered the export and must be fixed in the
    authority, never masked with an exclusion.
28. Synchronize each published mirror and replay its release gate inside the mirror, requiring
    agreement with the authority's release identity — matching recorded hashes including the
    canonical release-surface hash, not merely a passing gate.

A rename in the authority reads downstream as a deletion and `sync` refuses it.  If that fires,
reconcile the mirror with an explicit `git rm` commit made *before* the sync, so the removal is
separately reviewable in the mirror's history.  Never add exclusions or rewrites to
`papers/repositories.toml` to make a refusal disappear.

29. Refresh the portfolio summary by copying `papers/summary/` over its mirror and committing there.
    It is not carried by `export-paper-repos.py`, because the registry requires every repository to
    claim a paper id and the summary is not a paper.  Nothing checks it, so any novelty or priority
    sentence must quote a ledger row rather than restate it.

**Checkpoint 12.**  Every published mirror is clean, its release gate green, and its release identity
equal to the authority's.

30. Leave every mirror committed and unpushed.  Publication of all repositories happens once, at the
    end, and is the author's action.

## Phase 6 — closing evidence

31. Re-run `lean-package-source-audit.py` for the order-eleven package against its authority revision
    and require zero drift.
32. Run the global paper-export audit and check commands, including stale manifest, unexpected
    deletion, reverse-reference and unregistered-paper detection.
33. Record a bounded result table naming every in-scope paper and export, its source revision, the
    finitegeom and package revisions, the gate, and the pass or fail disposition.  No configured
    in-scope paper may be silently skipped.

**Checkpoint 13.**  The table covers the eight in-scope papers plus the companion and the summary,
every row passing.  Acceptance items 11 and 12 hold for the published set.

34. Update the C864 card and the build-sys handoff, and append the dated report.
35. Hand the author one list naming every repository to push and the exact revision each should
    reach: finitegeom, the order-eleven certificate package, and each published mirror under
    `~/src/math-papers/` including the portfolio summary.  Verify each afterwards with
    `git ls-remote https://github.com/tavisrudd/<repo> main`, never a local `origin/main` ref.

## Hazards this plan already accounts for

- Deleting a finitegeom module is not modelled by any tool; the manifest keeps stale entries and the
  lakefile keeps stale roots.  Steps 2 and 3 handle both; checkpoint 1 checks both directions.
- The build queue's exit 0 carries two outcomes: a `resume:` line means still running, not finished.
  Exit 126 is an abandoned run, typically an OOM kill.  Exit 124 is the caller's own wait timing out,
  leaving the build untouched — wait again on the same run directory rather than resubmitting.
- Killing a foreground queue client does not kill the build; find the run directory and `await` it.
- `lean-trust-extract.py` refuses a dirty tree, so commit source changes before extracting.
- An area may audit through a sibling `...AxiomAudit` gate that prints under opened namespaces.
  Resolve short names against the extracted `project_declarations` and require uniqueness; never
  declare a guessed fully-qualified name.
- One heavyweight build owns the host at a time.  Never run direct `lake`, `nix ... lake`, or a
  hand-composed `taskset`/`choom` command; `run-quiet` is output capture, not the guarded entry point.
- `/tmp` is tmpfs here.  Keep build trees, caches, packs and large logs on disk-backed paths.

## Second pass

Both deferred papers are paper-side only and need no export, build window, or lock.

For the order-13 passant code: refresh its facts artifact, resolve its `papers-index.md` title drift,
run its release chain, and sync its mirror.  Its certificates stay resident under
`papers/q13-passant-code/` because the projective-cap order-13 externalization is out of scope.

For complete repair ports: take the editorial decision on the eleven internal working documents that
carry its 128 export findings — `proof_ledger.md`, `adversarial_novelty_review.md`, `theorem-map.md`,
`formalization-ledger.md`, `second-draft-fix-plan.md`, `formal-statement-adequacy.md`,
`verification-map.md`, `claim-proof-novelty-ledger.md`, both READMEs, and one file the scanner
classifies as an internal process file.  The question is which belong in a public repository at all,
not how to scrub identifiers out of them.  Then resolve its one `stale-bbl` finding, run its release
chain, and sync.  Its Lean area is already registered and adopted, so no export work attaches.

Adding both extends checkpoints 10 through 12 to cover them and the phase 6 table by two rows.

## Restated exclusions

- The `pending_family` table keeps its order-25 data, order-25 generator, and order-13 projective-cap
  entries, so the boundary checker's externalization scope stays deliberately non-empty and C864's
  acceptance item 9 is unmet.
- `papers/clebsch-series-figures/series-figures.tex` is an unregistered manuscript.  It needs either
  registration or the retirement treatment the integrated mega-paper received on 2026-08-06, which
  moved it to `archive/papers/` outside the configured paper roots.  Not resolved here.
