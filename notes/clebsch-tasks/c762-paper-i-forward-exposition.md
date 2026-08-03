# C762 — Paper I forward exposition and series-facing revision

**Lane:** `clebsch`

**Status:** complete.  The forward exposition, structural q11 proof boundary,
O1--O8 correspondence, PDFs, release manifests, and standalone replay are
green.  Released versions 1 and 2 remain immutable; this work is the sealed
forward-release candidate.

## Completion record (2026-08-03)

The main paper now makes the q11 proof hierarchy explicit.  Its seven
`A_5` point orbits are derived from cross-characteristic eigenspaces,
subgroup stabilizers, orbit--stabilizer, and cardinality exhaustion.  Its
complete syndrome oracle and ambiguity multiplicities are derived from the
arc--coset dictionary and three displayed chord-incidence equations.  The
formal q11 tables are described consistently in the main paper, companion,
README, and verification guide as independent corroboration and as evidence
for the companion's sharper finite census claims, not as premises of the
main-paper proofs.

The strengthened main PDF is warning-free at 22 pages and the companion at
12 pages.  Both authoritative release runs pass all 26 checks against q11
commit `09d8e174880e7370966da788da3c5d303df8af4f`; the final monorepo release
commit is `81163be6`.  The standalone repository is synchronized and green at
`58900f0`, with its formal-companion locator updated to the exact q11 and base
commits.

## Current state

The abstract and introduction now lead with rigidity and the normalized
golden two-graph/determinant identity, with the uniform conic-filling window
kept secondary.  The four-paper forgetting-and-recovery paragraph names
released Papers II--III and forthcoming Paper IV.  The computational companion
marks its q13 theorem as the historical computational source and points forward
to Paper IV's standalone proof and evidence surface.

The title-page audit preserves C703's reader-facing series banner and Paper-I
refrain while leaving the canonical Paper-I title visually dominant and
bibliographically unchanged.  The main abstract now has exactly three levels:
the inverse theorem, the golden identity and its triangle-holonomy mechanism,
then the secondary field window.  The companion abstract no longer restates
Paper IV's theorem package; one sentence preserves provenance and points
forward.  Paper IV retains its own standalone title, restrained Roman numeral,
and no repeated trilogy refrain, as frozen by C761.

The BBS interface now cites the exact conic-complement statement,
Proposition 1.6, rather than deriving it through Proposition 1.5.  The
Hassett--Tschinkel interface explicitly identifies the cross-golden four-space
and its trace orthogonal with their paired determinantal hypersurfaces; the
gradient-ideal exhaustion remains an independent check.  Both primary sources
were checked from full text in the persistent literature cache (BBS SHA-256
`c645a01905340e8100a5b9d46d806331bb0c21339e4c655aa6747d7e82c25fbe`;
Hassett--Tschinkel SHA-256
`89ca37f2a5908c3355fda20bda6e8e469d22ffcc5f93232de88a60a7f700f885`).

An independent PDF-first cold read returned `GO` after the tracked PDFs were
rebuilt and the companion bibliography identified Paper I as a released
version-2 manuscript.  It found no remaining hierarchy, series, ownership,
citation-interface, bibliography, or layout defect.

The released Paper II and Paper III bibliography entries now include their
confirmed version-independent Zenodo concept DOIs.  The corresponding public
GitHub releases were checked directly; forward versions remain separate from
these immutable predecessors.

The initial read-only Lean correspondence audit found no new declaration requirement.
The headline and three affected statement groups retain their exact SHA-256
identities; only their source lines moved (headline `96→91`, orientation
`966→983`, window `83→81`, q13 `385→386`).  The statement identity and
dependent trust manifest are regenerated from the current manuscripts, and
both generator check modes are green.  After C753's active extraction is
stable, update formal coverage only to the strength actually achieved by the
existing frozen packets and run the Lean-root-dependent trust verifier.

That reconciliation is now complete through O7.  The human frame-symmetry proof
uses the formal structural route: five distinguished perfect matchings give a
faithful five-letter normalizer action; explicit elements generate the even
`A₅`, an odd element reverses orientation, and six distinct cubic-line cosets
give the order-120 upper bound.  The trust gate imports the O7 aggregate and
audits its five public terminals.  Statement identity and the nineteen-row
trust manifest are regenerated; the guarded gate replay at
`~/.cache/othello-lean-build/run-20260802-211544-6ac6c934`, the
Lean-root-dependent trust verifier, and the 21+12-page warning-free manuscript
build are green.  The abstract is unchanged because O7 strengthens the proof
and formal boundary, not the headline theorem; the existing five-matchings
figure already carries the structural picture, so no additional diagram was
added.  O8 and the integral-commutant boundary remain explicitly unclaimed,
and the stale release-output certificate has not been presented as a passing
full aggregate.

## Objective

Prepare the next forward version of Paper I without merging it with the
computational companion.  Preserve the rigidity theorem as the headline,
promote the golden two-graph/determinant identity to the second pillar, and
make the four-paper forgetting-and-memory spine visible to a first-time
reader.

## Work package

1. Reorder the abstract and introduction as rigidity, golden orientation,
   then the uniform conic-filling window; state the window in prose rather
   than giving it the visual headline slot.
2. Display the triangle-holonomy and determinant-pencil identities compactly
   and keep every normalization tied to the existing theorem surface.
3. Add the short series paragraph: Paper II studies what the conic quotient
   remembers, Paper III (`passages`) supplies and propagates the golden
   characteristic-zero source, and Paper IV extracts the q13 passant-code
   reconstruction theorem.
4. Replace the companion's q13 ownership language by a forward pointer to
   Paper IV while retaining historical provenance and the conic-filling
   context.  Do not merge Paper I and its companion.
5. Verify and sharpen the BBS and Hassett--Tschinkel citation interfaces;
   present the internal exact exhaustion as an independent route wherever it
   genuinely proves the same conclusion.
6. Reconcile prose, bibliography, claim map, and Lean-facing statement
   identity with C753, then synchronize the authoritative and standalone
   roots as an ordinary forward release.

## Acceptance

The first page communicates one memorable inverse theorem and one memorable
golden identity; the general window is accurately secondary; every series
cross-reference points to a released or explicitly forthcoming paper; no
claim is duplicated from Paper IV as if still owned by Paper I; and the PDF,
evidence, Lean correspondence, and standalone replay gates are green.

## Boundary

C762 changes packaging and exposition, not the frozen rigidity theorem.  C753
owns the same-mechanism Lean closure.  Any mathematical strengthening beyond
their existing interfaces requires a separately scoped decision.
