# C864 phase 5 — published papers: what landed, and the trust-boundary stop

**Lane:** `build-sys`

**Date:** 2026-08-06

Resumed the export-completion execution plan
(`2026-08-06-c864-export-completion-execution-plan.md`) at step 22, the first paper-side step.
Steps 22 through 25 are done and checkpoint 10 passes. Step 26 is done for every published paper
except MDS--CSS transversal groups, which has no runnable release gate at all. Clebsch rigidity
stopped mid-chain on a falsifier the plan declared; that decision has since been settled and the
chain ran to completion, both recorded below. Steps 27 through 30 and phase 6 have not run, so no
mirror has been synchronized and nothing has been pushed.

## Checkpoint 10 — passed

`paper-facts.py check` reports no error and no staleness naming any paper in this pass. It went from
twenty-three errors and sixteen warnings to six errors and ten warnings, and every remaining finding
names a deferred, out-of-scope, or unregistered item: complete repair ports and the order-13 passant
code, both deferred to the plan's second pass; equivariant robust completion, which is unpublished;
and `papers/clebsch-series-figures/series-figures.tex`, which the plan lists as a restated exclusion.

- **Step 22.** Three self-authored entries in `papers/beyond4_prs/refs.bib` quoted superseded titles
  for arcs complete outside a conic, Clebsch rigidity and Clebsch factorization. Both tracked
  bibliographies carried them into the compiled PDFs. Corrected the source entries and rebuilt both
  manuscripts through the paper's own `make check` and `make tit-check`, which pin
  `SOURCE_DATE_EPOCH`; the rendered bibliography was inspected in the extracted text. That cleared
  all seven of the paper's `stale-bbl` findings and all three of its `citation-title-drift` findings.
- **Step 23.** `papers/papers-index.md` and `notes/2026-07-31-results-summary-snapshot.md` named
  Clebsch rigidity, Clebsch factorization and beyond-four PRS by superseded titles;
  `notes/2026-07-31-work-summary.md` had a stale generated region. All corrected, the last by
  `paper-facts.py generate`. The order-13 passant code row is deliberately left drifting, because
  the second pass owns it.
- **Step 24 needs nothing.** Re-measured rather than trusting the recorded figure, as the plan
  directs. The four dependency locks the 2026-08-05 sweep counted were the order-eleven package,
  which pinned finitegeom `85dfde9e` and which phase 3 already advanced to `dca9ce75`, and the
  unregistered projective-cap order-11, projective-cap order-13 and order-25 candidate packages, all
  three pinning `9711f4a1`. That revision carries `Q16CertificateLevels`, `Q16Reduction` and
  `Q16StepKernel`, which the current finitegeom no longer has. Those three packages belong to
  externalizations this plan puts out of scope, and bumping a package's pin without rebuilding its
  gate would invalidate its evidence, so they stay. The order-16 package pins `a7665be6`, which does
  not carry the extracted order-16 sources.
- **Step 25.** Re-extracted eight facts artifacts: AME/LU, arcs complete outside a conic, Clebsch
  factorization, Clebsch passages, Clebsch rigidity, the Clebsch rigidity companion, and both
  beyond-four PRS identities. The order-13 passant code artifact is left stale for the second pass.

## The stop that fired, and how it was settled

The plan records this decision and its falsifier:

> **The package's declared `terminal` was left as it stands**, naming
> `RelativeConicArcs.ClebschDye.isClebschHexagon_of_uncovered_subset_conic`, which is now proved
> entirely in the shared library rather than by this package. […] *Falsifier:* if a paper cites this
> package's fact as evidence for that terminal, the citation overstates what the package contributes
> and the field must be settled before that paper's release chain runs.

It does. `papers/clebsch-rigidity/verification/trust_manifest.json` gives that exact declaration as a
Lean terminal of the `rigidity-headline` claim and of one other claim, with the evidence being the
certificate package's aggregate gate. The package no longer proves it; finitegeom does. Per the
plan's instruction not to reopen a decision unless its falsifier is observed, and to stop and say
which when one is, the Clebsch rigidity release chain did not run. Its computational companion shares
the same release runner and is blocked with it.

The settlement is recorded under "The trust boundary, settled" below: the fact's terminal now names
a declaration the package proves, and both `seal` and `check` refuse a terminal that the dependency
proves instead. The release chain then ran; what it needed is under "Paper I released".

### What the chain needed, as surveyed before it ran

Kept because each item is a defect class rather than a one-off, and because the pins below record
where the release surface stood before the chain. Every item is resolved; the resolutions and the
five further defects the chain exposed are under "Paper I released".

- **Pins.** Certificate package `c3669965` → `a289097b`; finitegeom `85dfde9e` → `dca9ce75`; the gate
  digest becomes `d0290697c9a2dbce5edfeeea1f2873dd91270a33581dec3da8369867244d8ce6`. The sites are
  `FORMAL_COMPANION.json`, the manuscript pin block at `clebsch_rigidity.tex:1830`,
  `verification/build_trust_manifest.py` (four constants), `verification/verify_trust_manifest.py`
  (three gate-name checks), `verification/verify_release.py`, and both READMEs.
- **The manuscript states two claims that are now false.** `clebsch_rigidity.tex:1815` says "Dye's
  bound and classification remain two explicit axioms," and line 1853 says the recorded axiom audit
  lists "exactly the two Dye axioms." The package's audit now records all fifty-five terminals over
  `propext`, `Classical.choice` and `Quot.sound` alone, with the seven `ClebschDye` results among
  them proved rather than assumed. `verification/README.md:44` repeats the false claim. This is a
  strengthening of the paper's formal boundary, so the prose change is substantive, not clerical.
- **The human artifact names a gate finitegeom deleted.** `FORMAL_COMPANION.json` pins role `human`
  to `RelativeConicArcs.Gates.ClebschRigidityHuman` at `9711f4a1`; phase 1 removed that gate as
  orphaned export residue. Its replacement is finitegeom's own
  `RelativeConicArcs.Gates.ClebschRigidityTrust` with the unchanged manifest
  `trust/manifests/clebsch_rigidity_human.json`, both present at `dca9ce75`.
- **Thirteen of the fourteen entries in `LEAN_SCHOLARLY_PATHS` are no longer in the package.**
  `verify_release.py` requires the Lean root's copies of those paths to equal the pinned commit. The
  cut moved all but the gate and the point-orbit family into finitegeom, and `git diff` over an
  absent path reports no difference, so those thirteen checks now pass vacuously rather than failing.
  Restoring the coverage means splitting the list by owning repository and checking the finitegeom
  half against a finitegeom checkout. That is a change to a published paper's release gate and needs
  a decision.
- **Vocabulary.** `FORMAL_COMPANION.json` uses role `base` with the coverage phrase "the base library
  revision the certificate package depends on"; `verify_release.py` calls its finitegeom option
  `--companion-root` and describes it as "checkout of the base library"; the manuscript says
  "base-library commit" and "the base library's version-independent archival locator." All are the
  role words the shared-Lean contract forbids for the finitegeom repo. Nothing reads the role strings
  programmatically outside the pin file itself.

## Papers that are green

- **Clebsch passages.** Its pin named finitegeom `f1d81641` while the area was last exported at
  `bb31411b`, so the currency check refused it. Advanced the pin; `bb31411b` carries neither the
  golden-return gate nor its sources, so the coverage sentence still holds. The full release gate,
  Lean gates included, reports `ALL CHECKS PASS`.
- **Clebsch factorization.** The frozen statement identity and the evidence fingerprint both trailed
  the manuscript and README bytes; no theorem-like statement changed, only the source hash. The
  documented command reports `CHECK OK` end to end, with the four Lean gates elaborated through
  `guarded-lean` and the manuscript built warning-free at forty-three pages.
- **AME/LU.** The release manifest disagreed with the formal companion at exactly one module,
  `RelativeConicArcs/AMELU/MarginalMoment.lean`, because the `ame-lu` lane reproved the three
  marginal counts by kernel reduction in place of native evaluation. Refreshed; seventeen public and
  eighty-two formal artifacts verify.
- **Beyond-four PRS.** After the step 22 rebuild the release manifest's local PDF hash and byte count
  were stale. Refreshed through the supplement verifier's own `--write-local-manifest`; the verifier
  is green.
- **Golden quantum statistics.** `verification/verify.py --check` is green with no change needed.
- **Arcs complete outside a conic.** The independent replay reproduces its frozen output exactly. Its
  pins are a separate question, below.

## Two further defects found

**MDS--CSS transversal groups has no runnable release gate.** Its `Makefile` `release-check` target
ends with `python3 release/verify_release.py --require-formal`, and `papers/mds_css_transversal_groups/release/`
contains no tracked file at all. Everything before that line passes: twelve certificate cases,
seventeen evidence artifacts, eight replayed bundles, the spacing lint and the manuscript build. The
sibling AME/LU paper, which was split from the same source, has the verifier this one is missing.
Writing it is a design decision about what constitutes this paper's public export and formal
companion, not a repair, so it is recorded rather than improvised.

**The arcs paper's pins are superseded and advancing them is a re-verification, not a bump.** Its
README and manuscript pin finitegeom `0b3f37d2` and the order-16 certificate package `ecee482d`,
while the registry pins that package at `0b04429b`. Between the two package revisions are 3,599
inserted lines of Lean, including the sources extracted from finitegeom. The paper has no
`FORMAL_COMPANION.json`, so no tool enforces currency and nothing failed; the pins simply name older
artifacts than the ones the portfolio now publishes.

## An internal term reached four exported files

"Authority tree" is private-workflow vocabulary. It appeared in the Clebsch passages pin file and in
the manuscript-build checkers of Clebsch passages, Clebsch factorization and the order-13 passant
code — all of which export to public mirrors. Replaced: the checkers now say determinism lets this
repository and a standalone copy of it carry the same PDF, and the passages pin says its commit does
not carry the golden-return sources because those are not yet published. finitegeom, both published
certificate packages and the portfolio summary are clean of the phrase. The mirrors still carry the
old text and pick up the fix at their next synchronization.

The export scanner does not know this phrase; `export-paper-repos.py plan` reported
`reference_findings=0` for all nine published papers both before and after. The word "monorepo"
survives in ten places across published paper roots, several of them deliberate statements that the
development repository is not the publication repository. Whether that word is also unwanted
downstream is an open editorial question.

## State

The monorepo carries eight forward commits from this session and is otherwise clean of this lane's
work. finitegeom and the order-eleven certificate package were not touched and remain at `dca9ce75`
and `a289097b`. No mirror was synchronized and nothing was pushed.

A concurrent session is writing `notes/2026-08-06-c879-finitegeom-paper-extraction-plan.md` and
`notes/2026-08-06-c879-module-name-mapping.json` in this worktree. Those paths were left untouched
and every commit here used explicit whole-file pathspecs.

## The trust boundary, settled

Decision 1 below is closed. The fact's `terminal` field names
`RelativeConicArcs.Examples.Q11A5PointOrbits.point_orbit_partition`: the seven blocks of the
order-sixty action are distinct, cover all 133 points of `PG(2,11)`, and have sizes 6, 10, 12, 15,
30, 30, 30. That is the package's own exhaustive contribution.

The fact already separated `origin: package` from `origin: dependency` for all 175 declarations, and
only the single `terminal` string overstated. The sealer accepted it because appearing in the gate
log was the whole test, and a gate imports far more than its package proves. Both `seal` and `check`
now require the terminal to be defined in a module the package's own manifest seals, so a fact
sealed before the rule is reported rather than trusted. The package is resealed at `76c2e563` and
re-pinned in the monorepo; `lean-external-fact.py check` is green.

### What the two Dye statements actually are

Both are theorems of the shared library, over `propext`, `Classical.choice` and `Quot.sound` alone.
The ten-point Brianchon bound specializes
`RelativeConicArcs.SixArcConcurrence.card_triplePoints_le_ten`, which holds for every field in which
two is invertible — more general than the order-eleven statement the paper needs. The equality
classification specializes `Q11GoldenHexagonWitness.exists_mapEquiv_toWitness`, which combines the
golden normal form with the two explicit projectivities carrying its order-eleven instances onto the
displayed witness. Dye 1991 is cited as the antecedent for both.

The module holding them is `RelativeConicArcs/Q11BrianchonClassification.lean`. Its former name
declared them axioms, as did the prose in the rigidity spine, the concurrence spine, the defect
bridge, the consequences module, both area export configurations and the paper index; all now state
what the results are. The regenerated `trust/PORTFOLIO.md` corroborates independently: the tree's
project-local axiom table lists two axioms, both in other areas' modules, and neither Dye statement
appears.

Regenerating that view also exposed a scanner defect. `lean-trust-spine.py` matched line-initial
`axiom` inside module docstrings, so a header sentence beginning "axiom is imported" was published
as a project-local axiom named `is`. The scanner now blanks nested block comments and line comments.
Repository-wide spine findings went from 115 to 112.

finitegeom, the certificate package and the paper still carry the old module name and the axiom
prose. They clear through the export, adopt, re-pin and release chain, which has not run.

## Paper I released, and the portfolio put on one finitegeom revision

The Clebsch rigidity release chain ran to completion. Its clean-source gate passes with the pin
block naming certificate package `a80e7de6` and finitegeom `575cf3e9`, the aggregate gate
`RelativeConicArcs.Gates.ClebschRigidityWithOrderElevenCertificates`, and both manuscripts rebuilt
warning-free at twenty-seven and thirteen pages.

Five things had to be repaired for it to pass, none of them anticipated by the plan.

- **The orientation rename had never reached the paper.** Twenty-four terminals in
  `build_trust_manifest.py` named `RelativeConicArcs.PaperIOrientation*` declarations that no longer
  exist; the gate audits `SupportOrientation*`, and one changed further,
  `oddModule_rationalCommutant_eq_adjoin_B` becoming `..._eq_adjoinGoldenOperator`.
- **The formal-companion pin named a deleted gate.** Its `human` artifact pointed at
  `RelativeConicArcs.Gates.ClebschRigidityHuman`, removed in phase 1 as export residue. The two
  entries for finitegeom collapse into one under the role `shared-library`, replacing a role word
  the shared-Lean contract forbids.
- **Thirteen of the fourteen scholarly-path checks were vacuous.** `verify_release.py` now checks
  the dependency-owned sources against a finitegeom checkout supplied as `--finitegeom-root`, and
  reports them unchecked by name when it is not given, instead of passing over paths the
  certificate package does not carry.
- **The tool tests pinned a stale page count.** They expected twenty-six pages while the manuscript
  has been twenty-seven since the acknowledgement revision, so the gate could not have passed.
- **The gate's longer name overflowed its line.** The digest sentence sets the path as a display,
  and the validator accepts a centred, sized label.

**One revision for the portfolio.** Requiring each pin to equal its own area's export commit forced
the papers onto as many finitegeom revisions as there are areas, because areas are exported at
different times and an idempotent re-export moves nothing. The currency check now admits a pin ahead
of the newest export exactly when it carries that export unchanged: the export must be an ancestor
of the pinned commit and the manifest must have the same bytes at both. A pin behind the newest
export, or one whose manifest content differs, still fails. Clebsch rigidity, Clebsch passages and
the arcs paper all name finitegeom `575cf3e9`; the arcs paper also cited the deleted
`ArcsCompleteOutsideConicHuman` gate.

All twelve areas re-export to an empty delta, `paper-facts.py check` names no in-scope paper, the
certificate boundary and external-fact checks are green, and `export-paper-repos.py plan` reports
no finding for any of the three papers.

## The `_human` suffix is gone

`clebsch_rigidity` and `arcs_complete_outside_conic` are the area names, with their trust statements,
axiom audits, manifests, source manifests and release prose renamed to match, in the monorepo and in
finitegeom. The exporter does not model a rename, so finitegeom's superseded files, its lakefile
root, its target-manifest entry, its portfolio rows and two duplicated README bullets were removed by
hand; the stated library size went to 319 modules, which checkpoint 2's base-prose rule caught.
finitegeom's README command list and provenance note had also named two gates the repository no
longer has.

## Open decisions, in the order they block work

1. ~~What the order-eleven package's external fact should assert.~~ Settled above.
2. Whether `verify_release.py` should check the finitegeom half of the Paper I scholarly pathset
   against a finitegeom checkout, restoring coverage that the cut made vacuous.
3. Whether MDS--CSS transversal groups gets its own release verifier, and what it should cover.
4. Whether the arcs paper advances to the order-16 package at `0b04429b` and a current finitegeom
   revision, which requires re-checking its cited gates and theorem names across that change.
5. Whether "monorepo" is also unwanted in exported paper prose.
6. Whether the `_human` suffix comes off the Clebsch rigidity and arcs areas before the re-export.
   Two of the twelve areas carry it: `clebsch_rigidity_human` and `arcs_complete_outside_conic_human`,
   the two whose enumerated material was externalized into a certificate package. It was meant to
   separate the human-scale half from the generated half, but under the shared-Lean contract
   finitegeom holds only human-scale material, so the suffix distinguishes the area from nothing —
   the other ten areas are equally human-scale and carry no suffix. It is also the vocabulary of the
   two orphan gates `ClebschRigidityHuman.lean` and `ArcsCompleteOutsideConicHuman.lean` that phase 1
   deleted as export residue. Dropping it renames the area configuration, its trust statement
   `trust/CLEBSCH_RIGIDITY_HUMAN.md`, its axiom audit `trust/ClebschRigidityHumanAxiomAudit.lean`,
   finitegeom's area, manifest and source-manifest files, and the manifest path the paper's pin
   names. Doing it before the re-export costs one cycle; doing it after costs two.
