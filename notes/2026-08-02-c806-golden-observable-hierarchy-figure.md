# C806: Golden observable-hierarchy opening figure

**Lane:** `golden`

**Date:** 2026-08-02

## Result

The Golden quantum-statistics paper now opens with one compact,
color-independent TikZ figure that makes the port-observable hierarchy visible
before the paper specializes to the conference transfer.  Its three boxes
separate:

- unframed ports modulo \(O(W)\times O(V)\), retaining the singular values and
  their scalar consequences;
- oriented ports modulo \(SO(W)\times SO(V)\), additionally retaining the
  determinant sign off the singular locus; and
- ordered orthonormal, phase-referenced frames, retaining the framed matrix and
  amplitudes such as the permanent.

The caption states the information gain and the singular-locus boundary.  The
source remains repo-native TikZ and uses gray tone only.
The frozen local artifact is
`golden-quantum-statistics-observable-hierarchy-figure`.

## Blind page test

An anonymous cold reader compared the pre-figure opening page (A) with the
figure page (B), without source or history access.  It graded A at C and B at
A-minus and selected B decisively: the three observational levels were
recoverable in seconds, the \(O\times O\) versus \(SO\times SO\) distinction
was accurate, and the figure remained legible at publication scale.  Its two
wording repairs were adopted: the oriented box now states how
\(|\det K|\) and its sign give the oriented determinant, and the calibrated box
names a fixed orthonormal basis under phase calibration.

## Validation

- `make check` passes, including the TeX linter, exact evidence verification,
  independent source replays, warning scan, and PDF build.
- The opening pages were rendered and inspected at publication scale.
- The evidence manifest was regenerated because it hashes the manuscript
  source; the mathematical evidence certificate did not change.

No incidental discovery arose from this editorial task.
