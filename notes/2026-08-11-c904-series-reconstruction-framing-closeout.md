# C904 series reconstruction-framing closeout

## Result

Papers I--V and the Paper-I computational companion now present one programme:
reconstruction from sparse or lossy shadows.  Each introduction and abstract
leads with its inverse problem and quantified theorem rather than the exceptional
Clebsch realization.  Papers II--IV remain standalone; Paper V is the capstone
classification of the information loss between chordal and conference cubic
shadows.

The authority changes are commits `b1923387` and `20184be6`.  All six local
manuscript gates pass.  Independent paperwise cold reads and a cross-series read
then received the changed passages as a blinded or semi-blinded A--B comparison;
all six preferred the new framing and returned PASS after local repairs.

## Standalone exports

The exporter audited all five public repositories with zero findings and
synchronized them from authority commit `20184be6`.  Their local gates pass:

- Paper I and companion: 29 and 14 pages, warning-free;
- Paper II: 45 pages, warning-free;
- Paper III: 33 pages, warning-free;
- Paper IV: 16 pages, warning-free;
- Paper V: 22 pages, `make check` PASS.

The forward mirror commits are `ebc78f1`, `3067f53`, `ad3c104`, `ade4f42`,
and `a8ee939`, preceded in the renamed Paper-V mirror by the explicit filename
retirement `e5d7ab8`.  Every mirror is clean.  Paper V's README points to the
existing `chordal_conference_reconstruction.pdf`.  Nothing was pushed.

## EJ + TT closeout

The free structural gain was not another theorem.  It was to expose the
quantifiers already present: the all-field theorem in II, the independent
all-order conference and two-graph theorems in III, the exact arity threshold
in IV, and the general conference-saturation theorem in V.  This makes the
exceptional objects outputs of general inverse questions and lets V function as
a true capstone without creating proof dependencies among the predecessors.

The Tao-style pressure test asked whether the common slogan had falsely made
the papers uniform.  It has not: I remains the programme entry, II is an
all-field classification, III explicitly has three theorem packages, IV keeps
its fixed-\(q\) boundary, and V keeps its neutral-carrier and residual-torsor
scope.  The computational companion is presented as a finite boundary map,
not as a substitute for structural proof.

## Mystery ledger

### Settled

- The new framing is preferred by every cold/A--B reader.
- The abstracts expose the important general quantifiers without enlarging a
  theorem statement.
- Paper V is legible as a standalone reconstruction theorem rather than an
  erratum or reconciliation appendix.
- The predecessor forward references point toward V, and the Paper-V PDF link
  and renamed mirror are coherent.
- Human proof, finite certificate, trusted execution, and formal-proof language
  are separated consistently in the manuscripts and companion.

### Still open

- Public push/release metadata are deliberately not applied; local mirrors are
  ready for external review but no immutable public locator is claimed.
- The separate Lean/release tasks of Papers I--IV remain owned by their existing
  task cards and were not changed by this prose/export pass.

No manuscript-critical framing, naming, PDF, or mirror mystery remains.
