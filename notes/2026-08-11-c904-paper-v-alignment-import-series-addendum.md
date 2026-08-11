# C904 Paper V alignment-import series addendum

**Verdict: MINOR**

## Frozen object

- Reviewed commit:
  `72904865c0ba27c22b8ef776c0ebf73b5968a402`
  (`papers: tighten Paper V alignment recognition import`).
- Verified PDF SHA-256:
  `f96e05078ffb49f8ca72e6089098c7d4f5f8bfa18aa039157346ed47ed48f7a4`.
- Frozen PDF: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`.
- No old report, script, or certificate was read.

## Gate-by-gate rereview

### 1. Abstract marked/unmarked boundary: PASS

The abstract now states both levels:

- the empty-alignment criterion leaves twelve labeled conference switching
  classes; and
- the recovered (A_5)-marking selects the invariant opposite pair.

This closes the previous ambiguity.  The paragraph no longer suggests that
alignment data alone recover the marked or oriented companion.

### 2. Direct Paper-III seam: PASS in intent, one precision repair required

The prose now explicitly names Paper III's theorem *Aligned-design
faithfulness*, cites Paper III, and states its seven-sharp boundary.  This is
the direct series integration previously missing.

The next sentence is too broad:

> The lemma identifies its sharp six-point failure locus: it is precisely the
> unmarked conference locus.

Lemma 3.4 identifies the **empty-alignment fibre**, not the entire failure
locus of six-point aligned-design faithfulness.  Six-point nonfaithfulness
also occurs for nonempty alignment data.  A small explicit witness on the
root-normalized vertex set ({0,1,2,3,4,5}) is given by the two graph
representatives

\[
 E_1=\{13,15,23,24\},\qquad
 E_2=\{13,14,23,25\}.
\]

They define distinct, noncomplementary two-graphs, but both have aligned
family

\[
 \bigl\{\{0,3,4,5\},\{1,2,4,5\}\bigr\}.
\]

Thus the full six-point failure locus is not precisely the conference locus.
Replace the sentence by:

> The lemma identifies the empty-alignment fibre at the sharp six-point
> boundary: it is precisely the unmarked conference locus.

This one substitution states exactly what the proved identity supplies and
retains the intended Paper-III integration.

### 3. Iranmanesh--Askari Farsangi metadata: PASS

The entry now has the corrected authors, article title, journal, volume,
year, pages, and DOI.  These data identify the source and Theorem 2.4
unambiguously.  Adding issue `5--6` would be bibliographically complete in the
strictest sense, but its omission is not an acceptance defect because the
volume pagination and DOI are sufficient.

## Non-dilution check: PASS

The revised import preserves the proof hierarchy.

- The abstract calls the pair-defect identity an additional intrinsic
  recognition criterion, after the selected-line equivalence and residual
  double cover have already been stated.
- Lemma 3.4 remains outside the proof of strict rigidity.  It recognizes the
  unmarked conference locus; the recovered (A_5)-action selects the opposite
  pair, and the selected chordal line plus outer difference returns the
  orientation.
- The conclusion gives exactly this causal order: singular orbit (	o)
  six-set, empty alignment (	o) conference locus, outer difference (	o)
  orientation.
- The p. 10 transition into *Outer difference and the oriented companion* is
  visually clean.  The added series paragraph does not compete with the main
  theorem or create a second inverse construction.

The alignment import therefore strengthens series unity without duplicating
or diluting the round trip.

## Acceptance gate

After changing “its sharp six-point failure locus” to “the empty-alignment
fibre at the sharp six-point boundary,” the addendum verdict becomes **GO**.
No proof, theorem statement, citation, abstract, conclusion, or structural
reorganization otherwise needs revision.

## EJ + Tao closeout and mystery ledger

The useful closeout distinction is now exact: seven is the universal
faithfulness threshold, while at six the empty fibre has the special
conference characterization proved by Lemma 3.4.  Other nonfaithful
six-point fibres explain why the lemma must not be promoted to a complete
order-six faithfulness classification.

No mathematical mystery remains.  The sole open gate is the one-sentence
scope correction above.
