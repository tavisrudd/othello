# C913 — Cubic-stabilization referee revisions

**Lane:** `clebsch`

**Status:** active.  A fresh Fable referee report finds no endpoint
calculation error or hidden discharge of the global hypotheses.  It requests
a major presentation and proof expansion before broad circulation.  The first
pass is deliberately local: repair endpoint/frame exposition, source
robustness, definitions, notation, and cross-references without changing the
theorem.  The second pass expands the two unconditional geometric arguments
on which a referee is most likely to press.

## Objective

Prepare a referee-resistant revision of
`papers/cubic-stabilization-irrationality/` that makes its unconditional
reduction theorem, its two independent open inputs, and the exact scope of
the toric calibrations clear at first read.

## Frozen mathematical position

The headline remains conditional on two distinct inputs:

1. a gauged-admissible Wlodarczyk completion for the relevant birational map;
2. the locally finite marked threshold compatibility family for its neutral
   clutching tails.

The paper proves the endpoint contrast, local simple-wall and ordinary-flop
identities, support collapse, tailwise derived identification, and tail
holonomicity.  A crepant toric wall gives a genuine ordinary non-zero-mode
calibration of the intrinsic marked-continuation mechanism at the
QDM/`I`-function level.  It does not prove either the arbitrary-projective-
master inverse-system comparison or the zero-mode nearby-cycle clause.

## Required revision packages

### A. Local correctness and reader navigation

- Say explicitly that the endpoint Boolean is evaluated on the formal primary
  projection of the intrinsic Gamma row and that the common half-Tate
  normalization does not alter the endpoint contrast.
- Supply the entrywise discrete-Fourier argument that every projective-space
  grading diagonal is the trace average.
- Define “jointly flat” in the ordinary-flop proof; promote the simple-wall
  centre-coordinate limitation into the theorem statement; make the
  single-simple-pole residue disclaimer a numbered remark; cross-reference the
  rational two-tail counterexample from the threshold hypothesis.
- Standardize Poincare/Poincare accenting, `2`-commutative terminology, and
  packet notation.
- State the archive location and trust boundary of the endpoint checker in
  the verification prose, consistent with the current public release surface.

### B. Source robustness

- Replace the proof's scattered dependency on internal Gu--Yu--Yu numbering
  by one manuscript proposition quoting the exact v1 inputs used: the formal
  decomposition, common-point lift, leading Fourier terms, completed-source
  isomorphism, and Fourier covariance.  Preserve precise source locators and
  hypotheses.
- Verify every cited version and convention against the cached primary source;
  do not weaken the theorem merely to hide a source dependency.

### C. Hypothesis architecture

- Present gauged-admissibility and marked threshold compatibility as separate
  assumptions in the introduction, with a one-paragraph account of which
  clauses are standard gauged-theory conditions and which remain open.
- State the cleanest named marked Gamma/window continuation conjecture that
  would imply threshold compatibility.  Do not claim it is established.
- State the endpoint-only form sufficient for the cubic application: it is
  enough to have the two inputs for a birational map
  `X x P^m dashrightarrow P^(m+3)`.

### D. Unconditional proof expansion

- Expand the orbit-cylinder marking into a lemma that proves disjointness from
  every intermediate fixed component after the chosen completion, or move the
  marked-lift assertion explicitly into gauged-admissibility if this cannot be
  proved.
- Expand the rank-one derived clutching theorem: derived fixed-section
  functor, stable open, universal gauged bundle, evaluation/attractor
  equivalence, POT-to-cotangent comparison, inertia/rigidification, and
  Woodward cutting compatibility.  An appendix is permitted.

## Non-goals

- Do not represent the toric calibration as a verification of marked threshold
  compatibility for arbitrary projective masters.
- Do not claim a zero-mode comparison without a meromorphic family and strict
  reduced-nearby-cycle identification.
- Do not split the paper before the expanded unconditional core has received a
  fresh cold read.

## Acceptance gate

1. Every Package A/B edit passes source, notation, and endpoint-frame audit.
2. Package C displays both inputs and the endpoint-only corollary without
   making either look vacuous.
3. Package D either proves the requested expansions or records its exact
   remaining statement as a hypothesis; no compressed derived/POT bridge
   remains implicit.
4. The manuscript, README, `.zenodo.json`, claim ledger, portfolio summary,
   and standalone mirror agree; deterministic `make check` passes before and
   after sync.
5. Freeze the revised PDF and obtain two new independent cold reads: one
   derived/gauged-GW reader and one birational/quantum reader.

## Immediate next step

Land Package A, then run a narrow citation audit for Package B before any
structural rewrite.
