# C819 — beyond-four PRS Version 2 cheap strengthening

**Lane:** `reed-solomon` · **Status:** complete

## Result

The draft now states the strongest theorem already implicit in the accepted
R5--R7 proofs.  The former one-step escape theorem is replaced by a
finite-depth coherent-polar escape theorem: uniform stagewise unavailable-
marker degrees and a terminal splitting-cover bound produce a split squarefree
member after any finite number of contractions.  Its proof is the successive
rational-marker choice followed by repeated squarefree lifting.

The theorem does not classify a carrier.  The manuscript says explicitly that
R6 and R7 verify its carrier and lower-package hypotheses only at depths one
and two.  Their proofs are now identified as those two specializations in the
abstract, introduction, reading map, theorem map, R7 synthesis proof, claim
ledger, formalization ledger, verification map, README, and Lean statement
map.  The Version 2 driver is dated August 2026.

This changes the mathematical hierarchy from three adjacent classifications
to one terminal R5 classification, one finite-depth escape theorem, and two
evaluated contained-carrier levels.  Zhang--Wan--Kaipa's lower persistent
families are described as base data for the terminal analysis rather than as a
competing endpoint.  No higher-Lucas or all-level novelty claim was introduced.

## Exact boundary

C656's three objections remain binding and are now the complete C820 target:

1. exact saturated primary decomposition of the bottom carrier, including
   multiplicities, exceptional fibres, and embedded-component exclusion;
2. the true pullback degree of the reduced union of relevant modular nuclei,
   or a proved nesting/intersection law justifying a sharper charge; and
3. generic-point recursive transport through special fibres, noninjective
   boundaries, nilpotent structure, and every coherent lift.

C620 separately owns split-squarefree incidence on the first fresh higher
Lucas carrier.  C821 owns final Version 2 synthesis after those results and
C646's formal interfaces are available.

## Validation

- `make -C papers/beyond4_prs check tit-check`: pass; canonical PDF 30 pages,
  IEEE single-column draft 22 pages.
- `python3 supplement/verify.py --write-local-manifest`: pass; all 37 adopted
  labels and exact Lean target sets reconcile, 45 evidence artifacts verify,
  classification records and R6 table pass, and local release-manifest hashes
  are current.
- `git diff --check` on the owned paths: pass.

## Extra-juice and Tao closeout

The cheap extra value was to make the prior lower-redundancy work an explicit
input to a recursive mechanism and to replace the ambiguous phrase “uniform
iteration” by two separate objects: a proved finite-depth escape theorem and
an unproved all-level carrier classification.  A Tao-style hypothesis audit
confirmed that the theorem should quantify stagewise bad schemes and terminal
curves directly; any stronger conclusion would hide the precise geometry that
C656 found missing.

No further cheap mathematical strengthening remains.  Changing the universal
threshold, identifying all contained components, or classifying a fresh Lucas
carrier requires new research and is queued rather than suggested in prose.

## Mystery ledger

- **Settled:** finite-depth squarefree lifting is not the ceiling; it is a
  general theorem once stagewise marker and terminal-cover data are supplied.
- **Settled:** R6 and R7 are exactly depth-one and depth-two evaluations of
  that theorem.
- **Open — C820:** whether the recursively contained carrier has only the
  persistent and declared modular components, scheme-theoretically and in all
  characteristics.
- **Open — C620:** whether split-freeness on higher Lucas carriers has a
  uniform subspace-polynomial or digit-pattern criterion.
- **Open — C660:** whether R7 finite completeness can be reconstructed without
  the primary quotient enumerator.

The discovery-track review found no incidental lead: every observation above
was sought for C819 and is recorded here or in its queued successors.
