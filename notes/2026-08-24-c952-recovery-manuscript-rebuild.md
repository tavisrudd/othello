# C952 recovery manuscript rebuild

**Date:** 2026-08-24

**Lane:** `complete-ports`
**Status:** in progress

## Scope

Rebuild the authoritative private manuscript around the C950 architecture and
the C951 formal boundary.  The paper uses established coding-theory terms,
contains complete human proofs for the body theorem chain, and treats the
paper-local Lean development as verification only of the associated-pair exact
sequence.  This task does not export, push, or update a public mirror.

## Theorem order

1. exact helper supports, recovery sets, normalized recovery equations, and
   bounded repair reliability;
2. the associated nested code pair and its exact sequence;
3. the identity between relative generalized Hamming weights and minimum
   helper-union costs;
4. fixed-subspace and dimension-by-dimension confinement under concatenation;
5. best-target generalized-weight, MDS, positive-density, and service-rate
   consequences;
6. separations beyond relative-weight data;
7. the projective-simplex application; and
8. the formal and computational trust boundary.

This ordering ranks results by logical dependence and use in the paper.  It
does not assign a quality score or venue prediction.

## Completed manuscript changes

- Replaced the title and abstract with the relative-weight and exact-transfer
  formulation.
- Rewrote the introduction to state the principal theorem before the detailed
  literature comparison and to distinguish the result from parameter-oriented
  concatenated LRC constructions.
- Replaced the first section with standard recovery-set and normalized-equation
  terminology and retained MDS reconstruction as a compact preliminary result.
- Added the associated nested pair, its exact sequence, the RGHW recovery-cost
  theorem, and the relative dimension/length profile interpretation.
- Added a direct block-functional proof of the fixed-subspace threshold and the
  uniform dimension-$t$ threshold, including the singleton off-by-one.
- Added the best-target generalized-weight identity, cooperative-locality
  bound, MDS thresholds and rigidity, positive-density realization, concatenated
  parameter bounds, and bounded service-rate-region transfer.
- Added `REVIEWER_GUIDE.md`, which routes a referee through the proof and
  records eight checks for hidden hypotheses, quantifier changes, convention
  shifts, computational dependence, and overstatement of formal coverage.
  The publication allowlist now includes this guide as a public review aid.
- Replaced the obsolete internal theorem map, proof ledger, and referee dossier
  with factual controls for the rebuilt manuscript. The new files contain no
  scores or venue assessments and separate human proofs from the one
  paper-local Lean-complete row.
- Adopted the nonprinting formal-annotation macros used by the
  cubic-stabilization-m1 paper. All 17 theorem-like environments now carry an
  explicit `coverage` record. The associated-pair exact sequence is the only
  `complete` row and names its four reviewer terminals; the remaining 16 rows
  are `absent`. Logical manuscript dependencies are recorded with `uses`
  annotations, and no statement carries computational `evidence`.

## Proof-integrity audit

The audit checks each displayed theorem against the following possible failure
modes: changing recovered-message rank into coefficient-space dimension;
replacing the standard RGHW minimum by a smaller complement-only minimum;
dropping the nonzero outer-functional branch at finite length; shifting the
singleton radius by one; importing the MDS formula instead of deriving it;
treating upward-closed cross-block supersets as new minimal recovery sets;
assuming reliability factors under an arbitrary direct sum; and promoting the
paper-local exact-sequence formalization to the central theorem.

Repairs made during the audit:

- stated `0 < dim I < |E|` before using `d(I^perp)`;
- made the `r+1` block-support bound explicit in the outer-dual-distance step;
- added the random-linear-code first-moment argument establishing simultaneous
  primal and dual distance for the positive-density application;
- expanded the generic-lift proof for the represented `[10,4,6]` seeds and the
  quotient-map realization of arbitrary nested pairs;
- proved explicitly that the projective dual presentation has associated pair
  `0 <= S_m`; and
- repaired source-level spacing commands that compiled as ordinary letters.
- corrected the Abdel-Ghaffar--Weber ISIT page range against the cached
  accepted manuscript's publication citation (`699--703`).

No confinement or separation theorem was strengthened as part of these
repairs. The standard random-code existence input was made explicit in the
positive-density corollary. The fixed-length outer functional term remains
outside the eventual threshold theorem, the rank parameter remains
recovered-message dimension, and central results remain classified as
human-only.

## Open manuscript work

- Hand the rebuilt source to the separately scheduled verifier refresh and
  independent referee review.

## Validation state

- A clean temporary XeLaTeX build produces a 16-page PDF.
- The annotation census finds 17 theorem-like environments, 17 coverage
  annotations, one Lean-complete statement, and no Lean terminal attached to
  an absent statement.
- The paper-local source-only formal-artifact checker now reads the TeX
  annotations, requires a one-to-one partition with the 17-row claim map,
  compares each coverage status and Lean-terminal list, and resolves every
  `uses` label. It passes with 17 claims, four reviewer terminals, 16 absent
  statements, and one complete statement. This check does not invoke Lean.
- The current TeX log has no undefined citation or reference and no overfull,
  underfull, LaTeX, or package warning.
- Extracted PDF text contains no leaked TeX spacing command, undefined marker,
  or visible use of `port` as terminology.
- The PDF title and author metadata match the manuscript.
- `.zenodo.json` parses successfully, and scoped `git diff --check` passes.
- The tracked release PDF was not updated and no mirror was touched.
- The existing release verifier still expects the former source commit,
  23-page PDF, and shared-Lean evidence boundary. Its failure is an expected
  stale-verifier signal; the separately scheduled verifier task owns that
  refresh.

## Trust boundary

The paper-local Lean companion proves the exactness of
`0 -> K_P -> D_P -> W_P -> 0`.  The RGHW identity, confinement theorem,
applications, and separations currently have human proofs only.  The
manuscript will state this boundary literally.

## EJ and TT closeout

The closeout pass retested the theorem chain from two directions: whether a
stronger conclusion was being inferred than the displayed hypotheses support,
and whether a standard object had been replaced by a narrower private variant.
It confirmed the following points.

- The complement step gives the standard RGHW, not a restricted
  complement-only weight.
- The outer-functional mechanism is removed only eventually and only by the
  stated dual-distance hypothesis.
- The singleton formula uses helper radius on one side and total dual weight on
  the other, with the target-coordinate shift displayed.
- The direct-sum reliability separation uses forced padding; no general
  reliability-factorization claim remains.
- The projective Möbius formula includes the full Bernoulli weight before
  inversion.
- The formal companion is not cited as evidence for an absent central theorem.

### Mystery ledger

No unresolved mathematical mystery remains inside the admitted theorem chain.
Two evidence/packaging gaps remain visible and have named downstream gates:

1. the release verifier and tracked PDF still describe the preceding
   manuscript and require the scheduled verifier refresh; and
2. the rebuilt paper has not yet received the scheduled independent aggregate
   referee read.

Formalization of the RGHW and confinement theorems is absent by explicit
choice, not silently assumed. A future formalization would require new claim
rows and reviewer terminals before the paper could change that statement.
