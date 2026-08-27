# C975 paper upgrade — integration and referee repair

**Lane:** `reed-solomon`  
**Date:** 2026-08-26  
**Status:** complete

## Paper spine

The submission is now titled *High-weight cosets of generalized and extended
Reed--Solomon codes*.  Its first theorem classifies every projective syndrome
direction of weight at least (r-1) for
(S=\mathbf P^1(\mathbf F_q)\setminus A), arbitrary nonzero GRS multipliers,
(r\geq6), large characteristic, and the explicit simultaneous-contraction
field bound.  It gives the omitted-point (r)-shell, the tangent,
conjugate-secant, and deleted-point-incident split-secant (r-1)-shell, both
projective and literal-coset counts, every MDS/NMDS appended column, and the
three family-aggregate minimum-support identities and NMDS enumerators.

The general proof now precedes the complete R5 taxonomy.  R5 is the terminal
cubic engine; R5--R7 are explicitly secondary sharp small-field and modular
refinements, not induction steps in the general theorem.  R8--R10 remain
companion records and are not claims of the submission.  Software discussion
has moved out of the introduction and into the verification appendix.

## Literature boundary

The full claim-specific audit is
`c975-2026-08-26-full-literature-audit.md`: seven full-text, eight partial, and
one abstract/metadata-only sources, with complete forward-citation and
database records.  No predecessor was located for the exact arbitrary-(r),
prescribed-point-deleted top-two-shell conjunction.  The ledger owns the
qualified novelty sentence.  The syndrome/MDS-extension dictionary, the
full-support redundancy-four families and count, deleted-support model,
general MDS/NMDS construction frameworks, and NMDS recurrence are all stated
as prior art.

## First cold-referee decision and repair

The first PDF referee returned **major revision** while finding no
contradiction in the shell counts, MDS/NMDS equivalence, or family-wise
minimum-support formulas.  The release blockers and repairs were:

1. The compact stagewise appendix stated load-bearing R6--R10 interfaces
   without proofs.  The submitted appendix now prints proofs of every such
   interface; it no longer points to an unspecified canonical version.
2. The arbitrary-redundancy proof used an unstated degree-six terminal
   separator.  `lem:terminal-selector` now constructs (F=DG) over
   (\mathbf F_q), proves nonvanishing on the irreducible catalecticant row
   space, proves vanishing on both terminal components, and establishes the
   separate degree-six bound (degree four in characteristic two).
3. The PDF had stale title, conditional-package, and witness-count text.  Both
   builds were regenerated from the repaired source and reconcile with the
   current statements.
4. The introduction now states the exact computation/import boundary.  The
   terminal prime decomposition is Gröbner-certified; selection, shell
   transfer, and enumerative arguments are mathematical; Seroussi--Roth and
   Dür supply the imported gates.
5. The Seroussi--Roth range and its implication from the displayed threshold
   are printed.  Aggregate families are explicitly projective direction sets,
   and the aggregate minimum-weight coefficients are displayed before the
   standard recurrence.
6. The complete R5 and R6/R7 theorem statements moved behind the general
   theorem and proof.  The software/R11 paragraph left the introduction.

## Second and final cold-referee decisions

The second PDF-only referee still returned **major revision** because the
terminal bad scheme and its saturation were not independently reconstructible
from the paper, and because the long R8--R10 appendices made the general theorem
look secondary.  The revision defines the ordered-pair equation, the six
generator elimination ideal, the Hankel--Pluecker pullback, determinant
saturation, and reduced terminal scheme before stating the computer-assisted
decomposition.  It also records the exact certificate boundary and moves
R8--R10 wholly to companion source.

The third PDF-only referee returned **minor revision**, score **8.5/10**, with
no conceptual blocker.  It accepted the terminal scheme, recursive carrier,
selector, simultaneous contraction, shell transfer, coding consequences, and
the proportion of R5--R7 material.  Its two quantitative findings are repaired
in source and rebuilt PDF:

1. the general threshold now uniformly uses
   `floor(2 sqrt(6(r+s)-18))`, matching the strict inequality exactly;
2. the witness-abundance proof counts distinct marker tuples with the falling
   factorial `(q-s)_m`, so marker collisions are subtracted.

The final small repairs define the index range and out-of-range binomial
convention in the Lucas carrier, complete the Li--Lu--Ling--Lam preprint
reference, neutralize the wording of the Kaipa--Pradhan denominator comparison,
and state that the electronic supplement accompanies submission and receives a
version-specific DOI at acceptance.

## Current gates

- abstract lint: 199/200 words;
- formal annotations: 55/55 reconciled;
- TIT review build: 31 pages, target strictly below 50;
- canonical build: 42 pages;
- paper-local evidence: 74 artifacts;
- companion software manifest: 24 artifacts;
- release-manifest local hashes: current;
- companion software tests, formatting, and clippy: green;
- whitespace/source lint: green.

All builds in this repair pass ran serially under `choom -n 1000`.  Referee
agents receive only the existing PDF: no review checkout, copied source tree,
or tmpfs build is permitted.

## `ej` + `tt` closeout and mystery ledger

The closeout asked whether any remaining cheap change would make the theorem
more invariant, easier to audit, or harder to misread.  It settled four items:
the exact integer threshold is now used everywhere; collision-free abundance
uses a falling factorial; the Lucas index convention is explicit; and the sole
computer-assisted theorem starts from a fixed, printed scheme rather than an
informal locus.  No further cheap strengthening survives the acceptance gate.

Open mathematical questions are real successor problems, not defects in this
paper:

1. **Small-characteristic exact shells.**  The all-characteristic carrier
   containment is proved, but classifying the high-weight points inside the
   nonempty Lucas carrier requires new arithmetic.  Evidence gap: no uniform
   split-squarefree incidence theorem on that carrier.
2. **Threshold sharpness.**  The explicit linear threshold is sufficient, not
   claimed optimal.  Evidence gap: the terminal genus-one estimate and the
   deletion budget are worst-case bounds and no matching obstruction family is
   known.
3. **Individual versus aggregate NMDS enumerators.**  The family aggregate is
   determined exactly, while individual appended-column enumerators can vary.
   Evidence gap: orbit/refined-incidence data beyond the family double count.
4. **Independent archival trust.**  The submission ships the full electronic
   supplement and an existing concept DOI; the new version-specific DOI and
   archive hash can only be fixed at the external release step.  Gate: immutable
   Version 2 deposit.

No other genuine mystery remains inside C975's theorem and exposition scope.

## Artifact identity and export

The official title capitalization is uniform:
*High-Weight Cosets of Generalized and Extended Reed--Solomon Codes*.
The authority is `papers/high_weight_grs_cosets`; both TeX entry points and
PDFs use the basename `high-weight-grs-cosets`, with the TIT variant suffixed
`-tit`.  The standalone local repository is
`~/src/math-papers/high-weight-grs-cosets`, and its origin is configured for
`tavisrudd/high-weight-grs-cosets`; the user owns the upstream rename.

Authority commits `4008f090f` and `e9b31ee22` contain the mathematical rewrite,
referee repairs, artifact rename, and title normalization.  The clean
standalone history records the required explicit old-path deletion in
`ac38574` and the exporter sync in `abea56d`.  Export verification gives content
SHA-256 `31e1c48a6846094fe9cad1c03e7ca47a9387d0550cd6f0bc25e4f4964503cb76`
over 147 tracked files.  No push, tag, DOI deposit, or submission occurred.
