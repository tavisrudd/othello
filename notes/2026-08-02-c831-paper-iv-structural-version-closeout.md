# C831 Paper IV structural version — closeout

**Date:** 2026-08-02

**Lane:** `clebsch`

**Verdict:** complete; strengthened manuscript and public evidence surface green;
external release remains with C761 and still requires explicit authority

## Result

Paper IV is now the eleven-page manuscript

> *Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a binary
> conic code*.

It remains naturally Paper IV: the theorem is the reconstruction capstone of
the series, while its proof is standalone.  The causal spine is

\[
 \text{distance}\longrightarrow\text{minimum geometry}
 \longrightarrow\text{weighted pairs}\longrightarrow
 \text{ambient conic plane}.
\]

The old weight-eight subset closure and weight-ten syndrome searches are no
longer theorem-facing.  They are replaced by the rank-28 positive form and the
global line moment with four \(D_{14}\) and thirty-three \(D_{28}\) finite
leaves.  The four minimum orbits are presented as one octahedral and three
toric punctured-conic families.  Weighted pairs recover the polar rows, code,
six elliptic relations, and—through the recovered group—the full marked plane.
The compact hidden-field proposition \(K\cong\mathbf F_8^{12}\) is retained
only where it explains orbit spanning.

## Evidence and trust surface

Six structural replays were added under `papers/q13-passant-code/verification/`:
theta, moment, pair reconstruction, minimum geometry, ambient plane, and hidden
field.  Their outputs, byte counts, SHA-256 identities, claim map, and aggregate
verifier agree.  The manuscript separates human reductions, classical inputs,
kernel-checked Lean implications, native evaluation, and trusted exact Python.
It cites Tranchida for the classical involution/off-conic-point/polar-axis
dictionary and makes no priority claim.

The bounded final search used four exact queries: minimum-word reconstruction
of a projective plane; weighted 2-section hypergraph reconstruction; Sylow and
involution recovery of a conic plane; and Lovász-theta passant-code distance.
It surfaced the known conic-action/code baselines and Tranchida's classical
dictionary, but no exact weighted-pair predecessor.  This is a bounded search,
not novelty closure, and the manuscript wording remains conservative.

## Gates

- `make check`: PASS; all old independent replays and six structural replays
  green, paper-owned Lean aggregate and axiom audit green, PDF warning-free.
- shared `RelativeConicArcs.PassantCodeQ13.StructuralUpgrade`: PASS under the
  pinned Lean environment.
- TeX spacing lint and `git diff --check`: PASS.
- source-hygiene screen: PASS; no task IDs or workflow state in the paper root.
- final PDF: 11 pages; whole-document contact sheet and pages 10--11 inspected;
  no collision, clipping, overflow, stranded disclosure, or unreadable table.
- adversarial proof read repaired the maximum-clique equality sentence and
  restored the explicit internal-point check for the toric supports.

## `ej` — strongest objection

The full-plane headline could overstate what is new because the
involution--polarity dictionary is classical, and it could make a code paper
feel like several papers joined together.  The final version answers both
points: its contribution is recovery *from weighted minimum-support pairs*, it
cites the dictionary explicitly, and every secondary structure is subordinated
to the four-arrow causal spine.

## `tt` — theorem architecture

The distance proofs identify the first layer; its toric--octahedral geometry
produces the weighted pair table; color eight gives the polar rows, parity gives
the code, and one pair-derived walk count separates the sole fused relations;
the resulting group then supplies the conic and all 183 polar point/line labels.
The \(\mathbf F_8\) operator field enters afterward as an explanation of why
each orbit spans, not as a competing narrative.

## `ej2` — second-order consequence

The exact arity-two statement is stronger and cleaner than the earlier
triple-concurrence reconstruction: unary data is constant, while weighted
pairs already determine the code and its entire ambient marked geometry.

## Mystery ledger

Settled: theorem hierarchy, series placement, structural distance proofs,
minimum-family geometry, exact arity two, full-plane recovery, compact module
explanation, citations, trust boundaries, public replay, formal gate, and
eleven-page presentation.

Open but outside C831: a deeper citation-graph novelty closure; a basis-free
theta form; a conceptual compression of the thirty-three stabilizer leaves;
and the deferred cuspidal, Schur-field, symplectic, and absolute-irreducibility
story.  C761 still owns isolated packaging, immutable locators, and any external
release.

**Vibe:** the paper now reads as a capstone rather than a certificate report.
