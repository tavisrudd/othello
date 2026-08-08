# C886: Layered exposition and accessibility for PRS Version 2

**Lane**: `reed-solomon`

**Status:** complete.  The end-to-end rendered read, layered-exposition pass, and
blind specialist/generalist/editor A/B reads are complete.  All three readers
preferred the revision.  Their substantive cautions have been repaired:
Section II defines `shallow` and uses `transverse` only as shorthand for the
noncontained branch; the R5 model and Example V.3 are qualified as models for
that branch; the R9 and R10 closing gates are explicit; and the Reading Map now
precedes the related-work survey.  No mathematical statement, hypothesis,
proof step, existing cross-reference label, or evidence boundary changed.
Both manuscript drivers,
the quick verifier, spelling scan, and rendered-layout inspection are green.
The TIT submission is 45 pages, three pages below the task's 48-page ceiling.
The fresh copy/layout reader preferred the current 45-page render over the
baseline at confidence 0.94.  Its terminology, punctuation, notation, table
numbering, and bad-break findings are repaired.  The equation counter now
advances in printed order, and every formerly manual display has a stable
label used by its prose references.  The D.10 selector sentence now exposes
the existing C620 product bound and its finite-field-grid inference.  A fresh
full paper-local replay completed in the synchronized standalone mirror with
exit status zero after 43 minutes.  The guarded export audit has zero findings,
the 114-file export
manifest verifies source commit `f55ac2c0`, and the mirror is committed at
`86794b6`; both mirror builds and its quick verifier are green.  The guarded Lean
area comparison found and adopted a deterministic five-file PRS boundary
delta onto the clean `finitegeom` checkout.  Both
`PRSBeyondRedundancyFour` and its axiom-audit gate pass there, and the local
Lean export is committed at `3ecb127`.  The paper's public Lean revision stays
unset until the author publishes that commit; no push was performed.  The
portfolio summary now states the exact R5--R10 radius boundaries, distinguishes
splitting density \(1/6\) from the Chebotarev main term \((q+1)/6\), and carries
the current abstract.  The public canonical PDF, authority PDF, and standalone
export are byte-identical with SHA-256
`d666f1fc7f3a42c89b3005207fb64a2f7dfb0794b2585b30ca2791f0b04620b0`.

## Goal

Preserve the paper's specialist precision and full proof/audit layer while giving a mathematically
mature reader outside PRS and deep-hole theory a complete conceptual route through the results.
The target is layered exposition, not uniform simplification: a first-pass reader should understand
the problem, mechanism, logical dependencies, exceptional-characteristic phenomena, and scope
without following every component calculation, divisor budget, or certificate replay.

## Cold-read diagnosis

The paper is substantially stronger for PRS and finite-geometry specialists than for general
mathematical researchers.  The sentence-level writing is not the main defect.  The architectural
problem is that the coding problem, geometric mechanism, and verification machinery initially
receive nearly equal visual weight, while the reader must acquire too many specialist languages
before seeing the single conceptual progression

```text
syndrome -> splitting system -> R5 fibre square -> marked contraction
         -> contained/transverse dichotomy -> Lucas carrier.
```

The paper already contains the needed ingredients.  In particular, Example V.3 and Figure 1 show
the recursive proof in miniature, but the manuscript does not yet tell a first-pass reader to use
them that way.

## Required edits

1. Add a compact conceptual overview before the Reading Map.  It must give the complete first-pass
   route from a syndrome `f` to `W_f`, the R5 cubic pencil/map/fibre square, contraction at a marker,
   lifting of lower split witnesses, and the contained-versus-transverse dichotomy.  Explain that
   carrier classification handles the contained branch and point counting handles the transverse
   branch.
2. Present R5 explicitly as the model for the whole paper.  After its exact fibre-square count and
   existence consequences, state that later levels repeat the same pattern after contraction:
   reduce to a lower-degree splitting problem, classify degeneration loci, and count rational
   points away from them.
3. Visually separate the two logical layers of the main recursive result in Theorem I.1 and at the
   opening of Section VI:
   - unconditional geometric theorem: the reduced recursively contained locus;
   - conditional finite-field consequence: containment of every split-free point when the lower
     packages and field-size threshold hold.
4. Add sparse first-pass navigation at the densest load-bearing arguments, especially the
   component decomposition around Proposition VI.1, without moving, abbreviating, or weakening
   the specialist proofs.  A reader who skips a marked calculation must still know its input,
   output, and role in the argument.
5. Add one results-and-mechanisms table for R5--R10.  Each row must expose the new obstruction, main
   geometric object, and structural source of the threshold; it must make clear which levels reuse
   the R5 terminal geometry and where genuinely new modular/Lucas phenomena enter.

## Density constraints

- Do not add textbook explanations of finite fields, projective space, or standard monodromy.
- Do not duplicate theorem statements or proof summaries across the overview, Reading Map, and
  section openings.  Each layer gets one job: conceptual story, navigation/dependencies, or exact
  mathematics.
- Prefer replacing locally repetitive orientation prose over simply increasing page count.
- Keep notation out of the overview unless it persists through the paper or is essential to the
  conceptual route.  Define `Y_f`, `N_f`, `d_2`, and `d_3` where the R5 model makes them meaningful,
  not as an undifferentiated abstract-level list.
- Keep certificate paths, divisor budgets, elimination identities, and characteristic-by-
  characteristic calculations in the specialist layer.

## Acceptance gates

- A fresh general-mathematics cold reader can accurately state: the coding question; why binary
  forms and splitting appear; why R5 is the terminal model; what contraction and witness lifting
  do; what contained/transverse means; why Lucas carriers occur; which recursive statement is
  unconditional; and which finite-field consequences require packages and thresholds.
- A fresh PRS/finite-geometry specialist finds no lost hypothesis, softened scope boundary,
  misleading analogy, or newly obscured proof dependency.
- The conceptual overview, Reading Map, results table, and section signposts contain no material
  repetition under a paragraph-level density audit.
- Example V.3 and Figure 1 are explicitly identified as the recursive mechanism in miniature.
- The specialist manuscript, TIT build, label/evidence verifier, and existing release replay remain
  green after the prose changes.
- Record before/after specialist and generalist exposition assessments separately; success does not
  require equal scores for intrinsically different audiences.

## Non-goals

- No theorem, scope, certificate, Lean boundary, or release-gate change.
- No attempt to make the paper introductory or undergraduate-accessible.
- No deletion of technical material merely because it is expensive on a first pass.

## Blind A/B record

The frozen baseline and revised TIT PDFs were supplied without repository
history.  The generalist reader chose the revision 90/10 and scored generalist
accessibility 79 to 89 while leaving specialist confidence essentially stable
(92 to 94).  The PRS/finite-geometry reader also chose the revision and checked
the load-bearing R5 identity, fixed-level gates, carrier conditionality,
certificate boundaries, and Lean trust boundary without finding a mathematical
regression.  The journal-layout reader chose the revision, finding no clipping,
overflow, font-embedding, or grayscale-legibility defect.  The current
45-page render includes the resulting terminology, scope, table, and ordering
repairs.  A fresh page-by-page comparison preferred it over the baseline at
confidence 0.94.  Table IV now stays together; Appendix C's two longtables are
visibly numbered VIII and IX and no longer split after one row.  Removing the
forced bibliography break was tested and rejected because it left only two
references orphaned on page 45; the cleaner 45-page layout was retained.

## Red-team resolution

The external post-revision review identified one proof-audit question in the
redundancy-ten good-base paragraph: the printed inference from degree 22 to a
common rational good base requires 22 to bound one nonzero product selector,
not its factors separately.  C620 already proves exactly that stronger fact.
Writing $A_j=B_j+xB_{j+1}$, it proves that $Q'=B_0B_4+B_2^2$ and
$[x^2]Q=B_1B_4+B_2B_3$ are nonzero on the complement; geometric integrality
supplies a nonzero quadratic pseudo-remainder coefficient.  The product of
that coefficient, the two displayed factors, and the five-root Vandermonde is
nonzero and has individual root degree at most $14+2+2+4=22$.  The manuscript
now prints this product statement, so the finite-field grid bound gives the
claimed binary $q\geq32$ good base without changing the $q\geq64$ theorem.

The same review caught equation numbers that duplicated or ran backward in
printed order because manual tags survived an earlier section order.  The
dedicated repair replaced those constants by counter-advancing labelled tags
and replaced numeric prose callbacks by label references.  The rendered
sequence is now monotone from (1) through (37), with no formula changed.

## Closeout and mystery ledger

The final extra-value and red-team pass compared the revised conceptual layer
against the theorem hypotheses, field ranges, conditionality, evidence map,
page ceiling, standalone replay, public PDF, and portfolio summary.  It found
and closed the last surface drift: the summary had called \((q+1)/6\) a density
and retained the pre-revision abstract.  No further cheap manuscript change
survived the density test; additional general exposition would now add bulk or
duplicate one of the overview, reading-map, or mechanism-table roles.

No genuine mystery remains within C886.  The D.10 common-avoidance inference is
explicitly supported by one nonzero product selector of individual degree 22;
the proof spine and all field/radius gates survived specialist red-teaming; the
generalist, specialist, and layout readers all preferred the revision; and the
full replay closed the final computational gate.  Responses from the external
experts contacted after release are independent scholarly feedback, not an
unfinished C886 acceptance condition.
