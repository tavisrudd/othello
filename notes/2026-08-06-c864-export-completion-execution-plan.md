# C864 — execution plan to a complete, valid finitegeom export and consistent published papers

**Lane:** `build-sys`

**Date:** 2026-08-06

## Purpose and scope

This is the ordered execution plan from the current state to a finitegeom repository that is
complete, replayable and buildable standalone, with every published paper consistent with it.

In scope for this first pass: the finitegeom tree and its eleven areas, the order-eleven certificate
package, and the published papers — rigidity as Paper I with its computational companion,
factorization as Paper II, passages as Paper III, arcs complete outside a conic, beyond-four
projective Reed--Solomon, AME/LU, MDS--CSS transversal groups, and golden quantum statistics — plus
the portfolio summary.

Two published papers are deferred to a second pass rather than dropped.  The order-13 passant code,
Paper IV of the Clebsch programme, is deferred by instruction; its certificates stay resident under
`papers/q13-passant-code/` because the projective-cap order-13 externalization is out of scope, so
nothing about its Lean state changes in the meantime.  Complete repair ports is deferred for the
reason below.  Both are paper-side work when resumed: neither needs an export or a build window.

Out of scope by instruction: the projective-cap order-eleven and order-13 externalizations, the
order-25 externalization, and the unpublished papers — the archived Clebsch hexagon code,
continuation graph rigidity, dihedral Schreier node Kayles, equivariant robust completion, and the
golden operator.

Complete repair ports is deferred rather than excluded on principle.  Its manuscript is close, but
its export carries 128 private-reference findings that hard-refuse a sync, and they are not a
scrubbing job: they sit in eleven internal working documents — `proof_ledger.md`,
`adversarial_novelty_review.md`, `theorem-map.md`, `formalization-ledger.md`,
`second-draft-fix-plan.md`, `formal-statement-adequacy.md`, `verification-map.md`,
`claim-proof-novelty-ledger.md`, both READMEs, and one file the scanner classifies as an internal
process file outright.  The question they raise is editorial, not mechanical: which of those
documents belong in a public paper repository at all.  That belongs to the paper's owner.  Its Lean
side is unaffected and already done — the `complete_ports` area is registered, re-exported and
adopted in finitegeom — so only the mirror sync waits.

Every remaining published paper scans clean, so no reference-cleaning work is on this path.

Consequence to state plainly: three of the four `pending_family` entries in
`lean/trust/certificate-packages.toml` are out of scope here, so that table will not be empty and
**C864 cannot close on this plan**.  What this plan delivers is a valid, complete export and
consistent published papers, not C864's own acceptance item 9.

## Blocking decision, needed before phase 3

The `pending_family` entry "order-eleven families awaiting their cut" declares seven modules as
leaving the monorepo for the order-eleven certificate package:
`ClebschGatewayQ11Extension`, `Q11BrianchonPetersen`, `Q11CodeRigidityBridge`,
`Q11DecodingSynthesis`, `Q11DyeConsequences`, `Q11RigiditySpine`, and
`SixArcDegenerateConicExclusion`.

The human Clebsch rigidity area export moved all seven the other way, into finitegeom, and the
package's byte-identical copies were then deleted so it consumes them from its dependency.  The
split-line determination in `notes/2026-08-05-c864-order-eleven-remaining-split-lines.md` supports
that direction — it found the remaining cut to be "the order-16 kind", where statements and
definitions stay and only exhaustive proofs move — and none of the seven carries generated content.

Either the `pending_family` entry is superseded and must be removed, or the export overreached and
the seven must be withdrawn from finitegeom and restored to the package.  Resolve this first: it
determines what the package seals and therefore what phase 3 can validate.  The evidence favours
removing the entry, but it is a declared scope statement and should not be deleted silently.

---

## Phase 1 — finish the finitegeom tree

1. Delete `RelativeConicArcs/Gates/ClebschRigidityHuman.lean` and
   `RelativeConicArcs/Gates/ArcsCompleteOutsideConicHuman.lean`.  Both are residue of the untracked
   export apparatus, superseded by the gates now exported from tracked configurations, and neither
   has an authority source.  `ArcsCompleteOutsideConicHuman` still imports `RelativeConicArcs.Q16Reduction`,
   which the monorepo dropped when the order-16 family was externalized.
2. Remove the stale manifest root `RelativeConicArcs.PaperIOrientationSpine` from
   `TARGET_MANIFEST.json`; it names a module the repository no longer carries.
3. Delete the three order-16 build-residue modules measured in
   `notes/2026-08-05-c864-non-lean-payload-and-build-artifact-sweep.md`.
4. Delete the 114 point-orbit build-residue modules that sweep measured in the monorepo.

**Checkpoint 1.**  Every area gate builds green in finitegeom through the guarded queue.  A second
run of all eleven area exports reports an empty forward delta for each, which is the idempotence
check.  `TARGET_MANIFEST.json` has no root naming an absent module.  The monorepo's own gates remain
green.

5. Push finitegeom.  Everything downstream pins the revision this produces, so push once, here.

**Checkpoint 2.**  `git ls-remote https://github.com/tavisrudd/finitegeom main` resolves to the
intended revision.  Verify against the remote, not a local tracking ref: this session's sandbox
cannot fetch over SSH, and a stale `origin/main` reads as "already pushed".

---

## Phase 2 — guards that would have caught this session's failures

6. Add a boundary-checker rule rejecting any package module whose name also exists at the pinned
   finitegeom revision.  Lean module names are global across a dependency graph; two packages
   defining one name is a hard build failure in any consumer.  This rule catches both failures seen
   this session — the seven duplicated modules and the colliding gate.
7. Add a standalone finitegeom build to the export tooling as a gate.  Nothing builds finitegeom on
   its own before a package pins it, which is why a broken export surfaced only three hours into a
   consumer's build.
8. Add adversarial fixtures for both, in the style of the existing boundary-checker fixtures.

**Checkpoint 3.**  Both new rules go red on a constructed violation and green on the real tree.  The
existing suites still pass: `test_lean_certificate_boundary.py`, `test_lean_area_export.py`,
`test_lean_trust_spine.py`.

---

## Phase 3 — reseal the order-eleven certificate package

Gated on the blocking decision above and on checkpoint 2.

9. Rename the gate to `RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates` and
   update `lakefile.toml`, `scripts/seal_manifest.py`, and the README.
10. Rewrite the gate's module header.  It describes the pre-cut content and states that the rigidity
    conclusion depends on the ten-point Brianchon bound and equality classification of R. H. Dye as
    literature input.  That is now false: both are theorems of finitegeom.  The package README
    repeats the same claim and the same correction applies.  The README also calls the module "the
    aggregate Paper I gate", which is manuscript-bound naming the artifact rules forbid.
11. Re-pin `lakefile.toml`, `lake-manifest.json` (`rev` and `inputRev`) and the README to the
    revision pushed at step 5.
12. Migrate the two unsealed payload files, `verification/clebsch_rigidity_trust/axiom-audit.txt`
    and `gate-run.log`, into a single `support_files` list in `MANIFEST.json`.
13. Correct `PROVENANCE.md` to the real extraction revision `0ddbca65`, and seal the monorepo
    revision in `MANIFEST.json` as a field distinct from the package's own `source_commit`.
14. Rebuild the gate against the package root and refresh the tracked axiom audit from that
    elaboration's own output.
15. Reseal `MANIFEST.json` in two commits so `source_commit` is self-consistent: first every source
    change, then the manifest alone.

**Checkpoint 4.**  The gate builds green against the pushed finitegeom revision with no module
ambiguity.  `lean-package-source-audit.py` reports zero unexplained drift against authority
`0ddbca65`, with every surviving difference named.  `lean-external-fact.py check` is green.  The
axiom fact records no Dye statement as a trusted input, and no terminal carries a native evaluation
axiom.

16. Publish the package revision, then update the monorepo's pinned copy of the trust fact at
    `lean/trust/external/` and its hash pin and `commit` field in
    `lean/trust/certificate-packages.toml`.

**Checkpoint 5.**  `lean-certificate-boundary.py --verify-official-libraries` is green, including
the new collision rule.

---

## Phase 4 — published papers

Six papers in this pass have a facts artifact differing from a fresh extraction: AME/LU, arcs
complete outside a conic, Clebsch factorization, Clebsch passages, Clebsch rigidity, and the Clebsch
rigidity companion.  The order-13 passant code has a seventh, refreshed in the second pass.

17. Refresh the stale bibliography entries in beyond-four projective Reed--Solomon, which holds
    seven of the nine `stale-bbl` findings across `prs-beyond-redundancy-four.bbl` and
    `prs-beyond-redundancy-four-tit-submission.bbl`.
18. Resolve the title drifts in `papers/papers-index.md` for the published rows, and the
    citation-title drifts in the published papers' `refs.bib`.
19. Refresh the four dependency locks that still resolve a finitegeom revision carrying extracted
    order-16 sources.
20. Re-extract the seven stale facts artifacts.
21. For each published paper in turn: update the pin block, regenerate the statement identity and
    trust manifest, refresh the tracked PDF through that paper's own manuscript checker in update
    mode, visually inspect changed pages, commit the release surface, run the aggregate release
    verifier with `--update-output`, rerun the trust-manifest builder, and finish with the
    clean-source release run.

Never build a PDF by hand.  Each checker pins `SOURCE_DATE_EPOCH` to make the build byte-reproducible
and then requires the tracked PDF to equal a fresh build exactly; a hand build without the pinned
epoch is rejected, and that equality is the only thing detecting a stale tracked PDF.

Clebsch rigidity must come after phase 3: its pin block records the package commit and gate digest.

**Checkpoint 6.**  `paper-facts.py check` reports no error and no staleness against any paper in this
pass, and its remaining findings name only the deferred and out-of-scope papers.  Every in-scope
paper's release gate is green in the monorepo.

22. Synchronize each published mirror with `export-paper-repos.py sync`, then replay that paper's
    release gate inside the mirror and require agreement with the authority's release identity —
    matching recorded hashes including the canonical release-surface hash, not merely a passing gate.
23. Refresh the portfolio summary by copying `papers/summary/` over its mirror.  It is not carried by
    `export-paper-repos.py`, and nothing checks it, so any novelty or priority sentence must quote a
    ledger row rather than restate it.

**Checkpoint 7.**  Every published mirror is clean, its release gate green, and its release identity
equal to the authority's.

---

## Phase 5 — closing evidence

24. Re-run `lean-package-source-audit.py` for the order-eleven package against its authority
    revision and require zero drift.
25. Run the global paper-export audit and check commands, including stale manifest, unexpected
    deletion, reverse-reference and unregistered-paper detection.
26. Record a bounded result table naming every published paper and export, its source revision, the
    finitegeom and package revisions, the gate, and the pass or fail disposition.  No configured
    published paper may be silently skipped.

**Checkpoint 8.**  The table is complete over the nine published papers and the summary, every row
passing.  Acceptance items 11 and 12 are then satisfied for the published set.

---

## Second decision, needed before phase 1 completes

Golden quantum statistics is a published paper, but its Lean area is the one registered
configuration with no corresponding area on finitegeom's `main`.  Exporting it would adopt a new
area rather than refresh an existing one, which is a publication decision rather than a maintenance
one.  Decide whether that paper's Lean development joins finitegeom in this run.  If it does, the
export and adoption belong in phase 1 before the push; if it does not, the paper ships with its Lean
development outside the shared library and that should be stated in its release surface rather than
left implicit.

## Known exclusions to restate at closeout

- `papers/clebsch-series-figures/series-figures.tex` is an unregistered paper.  It needs either
  registration or a written determination that it is not a paper; it is not resolved here.
- The `pending_family` table retains its order-25 data, order-25 generator, and order-13
  projective-cap entries, so the boundary checker's externalization scope is deliberately non-empty
  and C864's acceptance item 9 is unmet.
- Paper IV, the order-13 passant code, is deferred to the second pass.  Its certificates remain
  resident under `papers/q13-passant-code/` because the projective-cap order-13 externalization is
  out of scope, so it ships with its certificates in place whenever it is picked up.
- Complete repair ports is deferred at the mirror-sync step only, pending the editorial decision on
  its eleven internal working documents.  Its Lean area is already registered and adopted, so
  resuming it later is a paper-side task with no export work attached.

## Second pass

Both deferred papers are paper-side only and need no export, build window, or lock.  For the order-13
passant code: refresh its facts artifact, resolve its `papers-index.md` title drift, run its release
chain, and sync its mirror.  For complete repair ports: take the editorial decision on the eleven
internal working documents — exclude them from the export or rewrite them for a public audience —
then resolve the one remaining `stale-bbl` finding, run its release chain, and sync.  Adding the two
extends checkpoints 6 and 7 to cover them and extends the phase 5 result table by two rows.
