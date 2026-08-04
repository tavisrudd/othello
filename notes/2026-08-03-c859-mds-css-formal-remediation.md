# C859 — Paper II formal and trust remediation

**Lane:** `ame-lu`

**Status:** complete; manuscript-ready, formal-companion-ready,
standalone-ready, and publicly materialized in the base Lean library. Only the
author's push decision remains.

## What now exists

Paper II (*Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS
Codes*, `papers/mds_css_transversal_groups`) has a paper-specific formal
contract for the first time.

Semantic roots:

- `lean/RelativeConicArcs/Gates/MDSCSSTransversalGeometry.lean` — import-only
  gate; its transitive closure is the paper's entire checked Lean surface;
- `lean/RelativeConicArcs/Gates/MDSCSSTransversalGeometryAxioms.lean` — imports
  only that gate and prints `#print axioms` for all 93 cited declarations.

The gate imports the shared conventions module, the dictionary and stabilizer
dictionary gates, `DiagonalIsoduality`, `EncoderTransversal`, `SyndromeGeometry`,
the pencil-classification gate and `LUPencilClassification`, and the
extension-field, marginal-moment, logical-phase/four-copy, transport, and
party-splitting gates. It excludes the companion paper's quantitative rounding,
partial-Weyl recognition, two-uniform discreteness and stability, robust atlas,
and arbitrary-additive supported-label and holonomy-centralizer developments,
which the C858 audit required to stay outside this closure. The seven modules
added on 2026-08-02 are all in that excluded quantitative chain and none is
reachable from either root.

## Measured results

Guarded builds through the managed queue, profile `single`, one thread, cores
20--23: both targets built and the trace-only aggregate gate passed
(`run-20260804-013339-54589231`, then `run-20260804-015620-cbb5c000` after the
docstring repairs). The second run's queued submission waited behind a live
foreign build rather than interrupting it.

Axiom audit, from the pinned toolchain `leanprover/lean4:v4.32.0-rc1`: 93
declarations printed. Eighty-eight depend on no more than `propext`,
`Classical.choice`, and `Quot.sound`. Five carry native-evaluation axioms —
`card_marginalTriples`, `card_marginalStars`, and `card_perfectMatchings`
directly, and `rankFourMultiplicity_eq_sixty_add_concurrency` and
`not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences` by inheriting
the star count's axiom. That inheritance was not visible before this task and
corrected the trust prose in four places.

Trust contract: `lean/trust/areas/relconic.toml` now declares both gates with
`coverage_rule = "closure"`, the 93-terminal list, and one `[[terminal]]` row
per declaration recording its measured axiom set. Extraction produced

- `lean/trust/facts/RelativeConicArcs.Gates.MDSCSSTransversalGeometry.json`,
  SHA-256 `30031527d43404688bbbc92e8ce567831e909b39b538e610263c5f7aea6ced61`
  (66 closure modules, 1708 project declarations, no project axioms);
- `lean/trust/facts/RelativeConicArcs.Gates.MDSCSSTransversalGeometryAxioms.json`,
  SHA-256 `07c2859faa8a99bbcf5e587916830cd3af0bb66f43832d088ee3d51907f4fd24`.

`lean-trust-spine.py audit` reports no finding naming either root. The
remaining area-wide errors are pre-existing and belong to other areas: missing
facts for units never extracted, `RepairPorts` terminals absent from their
gate's facts, three unanchored external inputs, and three undeclared project
axioms in `DihedralSchreier`, `RepairCodes`, and a `PRS` gate.

Paper registration: `lean/trust/papers.toml` now carries the paper's seven
adopted labels, its verification manifest `verification/claims.json` with
selector `claims[].label`, and 25 fully qualified cited Lean terminals. The
generated facts artifact is
`lean/trust/paper-facts/mds_css_transversal_groups.json`, SHA-256
`24ea63b3876f98770812aad642c29921b2bd16fc43d34a5f341e1110ff973372`. The new
public claim manifest is
`papers/mds_css_transversal_groups/verification/claims.json`, SHA-256
`1eb430dd045f5edeb81b6350ad1cd4ef749b0fbb82ad156cf102ae1c5a73e821`; it records
every one of the paper's twenty statement labels with its verification route,
Lean declarations, certificate bundles, and scope boundary.

Paper gates: `make check` passes warning-free at 23 pages, and
`python3 supplement/verify.py --replay` verifies all 17 artifacts and replays
all eight bundles. Two disposable exports materialized from commit `cc8a0ced`
are byte-identical at 47 tracked files, pass export-manifest verification, and
pass a clean build and the full replay in the extracted tree.

Prose review: a bounded scan of all 65 project-owned modules in the closure
(the two `ProjectiveCap` shared modules excluded per the C860 boundary) found
no task ID, lane, agent or session reference, private path, status or forecast
vocabulary, `sorry`, project axiom declaration, or novelty claim. The exporter
audit reports zero findings, and the blast radius of the new gate is its own
axiom audit alone, so no other lane's gate needed revalidation.

## Public surfaces

The README, `sections/08-verification-boundary.tex`, and
`supplement/EVIDENCE.md` now state the present verification boundary: the two
roots, what is checked by kernel reduction, which terminals are
hypothesis-explicit interfaces over inputs the text or supplement establishes,
and where native evaluation enters. The introduction names the formal companion
once. No surface retains deferred, scheduled, or future-work language.

A cold proofread of the changed TeX and a page-by-page render sweep produced
ten corrections, all applied: the interface list had omitted the fixed-party
logical-phase kernel and the transport determinant bridges; the description of
the content-addressed record claimed source hashes it does not contain; the
supplement crosswalk was described as per-statement when it is per-group; and
the pencil-quotient figure carried a stale `(7.1)` reference to what is now the
admissibility equation `(4.1)` and a label colliding with the quotient arrow.

## Ownership and ledgers

`theorem-map.md` now records four imported companion results, including the
minimum-support atlas that C858 found missing, drops the label
`cor:six-arc-fixed-party-group` that no source defines, and adds
`lem:conic-matchings`. `formalization-ledger.md` carries a per-label crosswalk
to exact Lean declarations, distinguishing unconditional, interface,
certificate-backed, manuscript-only, and imported rows.

Bibliography policy: the export tooling classifies a `.bbl` as build output and
ignores it, so tracking one makes the exported tree disagree with its own
manifest. The bibliography therefore stays untracked and the supplement records
that `make check` regenerates it with `bibtex` from the tracked `refs.bib` in
the same command that rebuilds the tracked PDF.

## Standalone

`~/src/math-papers/mds-css-transversal-groups` is synchronized from authority
commit `cc8a0ced` as ordinary forward commit `f90b330` on its existing history.
The mirror verifies against its export manifest at 47 tracked files, builds
warning-free, replays all eight evidence bundles, leaves a clean worktree, and
its tracked PDF is byte-identical to the authority's
(`4acbdf789f3ed346e4dc537782e89bab6e304da4f7f54936f17b1fc996022414`). Nothing
was pushed; the mirror's `origin/main` still points at the previous commit.

## Readiness

- Manuscript-ready: yes.
- Formal-companion-ready: yes, at the boundary stated above.
- Standalone-ready: yes, locally.
- Public-release-ready: yes on content. Every drift error is cleared and the
  formal boundary is exported; the standalone and base-library commits are
  unpushed, which is the author's decision.

## Cross-lane repairs and public materialization

All four items opened during remediation were closed on the user's instruction.

The portfolio index, the work summary, and the results snapshot now name both
papers by their current titles: the index carries a separate entry for each,
the work summary's generated manuscripts region was refreshed and its
hand-written table row split in two, and the snapshot's Paper I heading and
list entry were corrected. The companion self-citation in
`papers/beyond4_prs/refs.bib` now gives Paper I's current title; the
Reed--Solomon lane must rebuild that manuscript for its compiled bibliography
to follow, which is the pre-existing condition its other three self-citations
were already in. Both AME facts artifacts were regenerated; other lanes' facts
were left at their committed state. The paper-facts check now reports zero
errors for Paper II and no title drift for either AME paper.

Public materialization: the new export configuration
`lean/trust/export/mds_css_transversal_groups.toml` declares the semantic gate,
the destination trust statement `trust/MDS_CSS_TRANSVERSAL_GROUPS.md`, and the
axiom audit `trust/MDSCSSTransversalGroupsAxiomAudit.lean`. The guarded
companion export ran twice with byte-identical repeats against base commit
`85dfde9` and produced a 23-file forward delta (nine added, fourteen updated,
51 planned files already byte-identical in the base), carrying the 66-module
closure and all 93 terminals. The delta was adopted into
`~/src/lean/finitegeom` as ordinary forward commit `e41b50b`. There the gate
builds through the guarded queue and is trace-current, and the exported audit
elaborates to the same 93 results with the same five native-evaluation
carriers. Nothing was pushed. The base's `PROVENANCE.md` carries pre-existing
prose drift (it declares 251 modules against a recorded 273), which the
exporter reported and left untouched.

## Open items

1. The base library's older `trust/AME_LU.md` boundary still describes a single
   accompanying manuscript and was exported from the pre-split aggregate gate at
   source commit `10d1941a`. Refreshing it belongs to Paper I's own export.
2. Other lanes' paper-facts artifacts and the Reed--Solomon compiled
   bibliography remain stale against their sources.
3. Nothing is published: the standalone mirror commit `f90b330` and the base
   library commit `e41b50b` are both unpushed.

## Discovery discriminator

Nothing incidental arose outside the requested remediation. Two defects found
while inspecting rendered pages — the stale figure equation reference and the
figure label collision — are deliverables of this task's validation step and
are recorded above rather than on the discovery track.

## Post-closure follow-up (2026-08-03, after publication)

Both paper mirrors were pushed by the author: the transversal-groups paper at
`f90b330` with DOI `10.5281/zenodo.21766797`, and the rigidity paper at
`8468914` with DOI `10.5281/zenodo.21681856`. That closed the companion-locator
gate both manuscripts were waiting on, and each now cites the other by
deposited identifier and public repository instead of by a frozen source-tree
hash.

Two mathematical and editorial repairs followed.

The transversal-groups paper states the arc--AME dictionary in both directions.
Lean proves `IsAME (equalPhaseState C) ↔ IsMDSCode634 C`, while Proposition 2.1
had asserted only that a six-arc kernel gives an AME state; the converse is now
stated and proved in three lines from the support criterion, so the manuscript
matches the kernel-checked equivalence. This was the one case found where the
formal development was strictly stronger than a paper claim.

`extensionField_pencil_classified_by_galoisZ` is renamed
`extensionEquivalent_iff_pencilZGaloisRelated_of_orbitBridges`. Its two
structure fields are exactly the representation-theoretic bridges the
manuscript declines to claim, so a name asserting classification overstated
what the type proves. The module header and docstring now say it is a
criterion relative to those hypotheses. All five affected gates rebuilt and the
trace-only aggregate gate passed.

A page-by-page render sweep of the rigidity paper found defects that its
warning-free build does not catch: three macros in appendix B had lost their
backslashes and printed `mathrmHS` and `leq` in the text; the operator-pushing
figure's holonomy label collided with the axis and the arrow; the
defect-landscape annotation collided with a marker; and the stability-radius
legend was crossed by a plot line. All are repaired, and its verification
section no longer forecasts a formal contract that does not exist. A private
work-item reference in its preamble was also removed, which the export audit
had been flagging.

### The rigidity paper's mirror and release gate

Both were repaired on the author's approval. The mirror had kept every file the
split moved out: the complete evidence supplement, the six-party sections, two
figures, and a formal-companion pin, 31 tracked paths in all. The new tool
`papers/scripts/reconcile_mirror_deletions.py` derives that set by materializing
a fresh export from an immutable authority commit and subtracting it from the
mirror's tracked files, classifies each candidate by whether its exact bytes
survive in a sibling mirror, refuses on a dirty tree or an oversized deletion
set, and commits the removal as its own reviewable forward commit. Comparing by
content rather than by path matters here: three of the candidates share a name
with a different paper's file.

Of the 31, eighteen have byte-identical copies in the published
transversal-groups mirror and ten more are the same material after later edits
there. `sections/03-lu-rigidity.tex` has no sibling copy because the same
commit that deleted it created `sections/03-exact-rigidity-atlas.tex` in its
place. `FORMAL_COMPANION.json` was held back by default and then removed with
an explicit flag: it pinned the pre-split mixed gate at a pre-split commit, so
publishing it would have contradicted the paper's own verification section,
which now states that no paper-specific formal contract exists. A refreshed pin
belongs in the authority whenever that paper gets its own export area, and the
exporter will carry it forward from there.

Two further defects surfaced in the same pass. The mirror's `make check` had
never been able to run, because the Makefile invoked the TeX spacing linter
from the development monorepo through a parent-relative path; the paper now
carries its own copy, as the companion already did. And the release verifier
crashed rather than ran, because it still expected the moved supplement; its
public surface is now the manuscript, figures, and build, which matches a paper
that carries no paper-facing computation, and its recorded title matches the
manuscript again. The regenerated manifest's public tree hash also identifies
what the old `2ada0216…` locator in the companion's bibliography had been
pointing at: the pre-split release surface.

The mirror is now at `1d658b8`, three forward commits ahead of its published
tip: manifest verified at 27 tracked files, warning-free build, clean worktree,
and a tracked PDF byte-identical to the authority's. No history was rewritten,
so the push is a fast-forward.

### Still open

1. The trust facts are refreshed. All four affected units — this paper's gate
   and axiom audit, the focused extension-field audit, and the two pre-split
   aggregate units — were re-extracted in a quiet window and now match the
   source: the renamed terminal appears under its new name, no cap-game module
   remains in any AME--LU closure after the dependency inversion, and no unit
   reports a project-local axiom. The focused extension-field audit had never
   had an artifact at all. The spine audit reports no finding against any
   AME--LU gate.

   The base library still carries the module under the old declaration name at
   its recorded export commit. It is self-consistent there and the audited
   terminal set does not include that declaration, so nothing in the published
   boundary is wrong; it is one revision behind. Refreshing it is blocked by
   the companion exporter itself: `insert_readme_bullet` refuses when the
   configured bullet is already in the base README, so an area can be adopted
   once but never re-exported. Treating a bullet that is already present as
   satisfied rather than as an error would make the tool idempotent and unblock
   every future refresh. That tool belongs to the build-system lane.
2. The rigidity paper's release manifest still carries the release identifier
   `ame-lu-rc1` dated 2026-07-26, which named the pre-split candidate. Choosing
   an identifier for the deposited version is an author decision.
3. That verifier now selects its formal surface by declared roots. It names the
   mixed aggregate, its axiom audit, and the two-uniform gate and audit, and
   reads each root's module closure from the extracted trust facts, so the
   release surface and the trust spine describe one graph. The surface drops ten
   standalone axiom-audit gates that no root imports and keeps every module the
   paper's claims reach: 82 formal artifacts against the glob's 92.

### Trust-facts coverage for the whole area

Eleven declared extraction units had no facts artifact and seven of their gates
had never been compiled in this tree, so the spine could not check what any of
those closures contains. All are built and extracted. The two-uniform gate and
its axiom audit had existed as sources without any area declaring them, which
left seven modules of the quantitative chain reachable by no unit at all; both
are now declared with all seventeen terminals, each depending on propositional
extensionality, choice, and quotient soundness alone. Across every AME--LU unit
no project-local axiom appears and no cap-game module remains. The spine audit
now reports no finding of any class against an AME--LU or MDS--CSS gate.

The transversal-groups mirror is synchronized at local commit `d2e54cb`:
manifest verified at 47 tracked files, clean warning-free build, clean
worktree, and a tracked PDF byte-identical to the authority's. It is unpushed,
as is the base-library boundary commit.
