# C762 — Paper I forward exposition and series-facing revision

**Lane:** `clebsch`

**Status:** active; the authoritative forward exposition pass and both PDF
builds are green.  Released versions 1 and 2 remain immutable.  Formal
correspondence, aggregate replay, and standalone synchronization wait for the
active C753 extraction to reach a stable recorded state.

## Current state

The abstract and introduction now lead with rigidity and the normalized
golden two-graph/determinant identity, with the uniform conic-filling window
kept secondary.  The four-paper forgetting-and-recovery paragraph names
released Papers II--III and forthcoming Paper IV.  The computational companion
marks its q13 theorem as the historical computational source and points forward
to Paper IV's standalone proof and evidence surface.

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

The read-only Lean correspondence audit found no new declaration requirement.
The three affected statement groups retain their exact SHA-256 identities;
only their source lines moved (orientation `966→984`, window `83→85`, q13
`385→390`).  After C753's active extraction is stable, regenerate
`verification/statement_identity.json` and the dependent trust manifest, then
update formal coverage only to the strength actually achieved by the existing
frozen C753 packets.  No Lean source, build artifact, or running extraction was
touched by C762.

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
