# C209 — polarity and rank-stability follow-on

**Date:** 2026-07-16
**Lane:** `relconic`
**Status:** DORMANT, C201 gate not met

## Target

Use the equality and first-excess data from C201 to formulate a geometric
inverse theorem.  Candidate forms are:

- a polarity-dual description of the full-rank/forced-hit dichotomy;
- a classification of rank-deficient near-extremizers;
- or a theorem that bounded defect forces the uncovered quadratic kernel into
  a short list of incidence types.

The result must connect the defect identity to quadratic avoidance.  A list of
orbit invariants, a second finite census, or a restatement of the evaluation
dichotomy does not meet the gate.

## Entry gate

C201 must identify a stable geometric feature across more than one bounded
cell, or provide a minimal failure whose dual interpretation is demonstrably
simpler.  Without that evidence, leave C209 dormant.

## C201 disposition

C201 closed negatively at its bounded mechanism gate.  The tractable `q=64`
families fail at coverage/saturation before producing informative rank/defect
cells, so they supply neither a stable geometric feature nor a minimal
rank-failure with a simpler dual interpretation.  Do not start C209 from the
repeated split-`Z3` local optimum alone; it is heuristic coverage data, not the
required inverse-theorem evidence.

## Trust and disposition

Formalize every new symbolic implication in Lean.  If a concise inverse or
stability theorem results, integrate it into the current paper between the
defect/stability section and the finite examples.  Otherwise retain it as a
follow-on note.
