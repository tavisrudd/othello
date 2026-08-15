# C913 — Cubic-stabilization referee revisions

**Lane:** `clebsch`

**Status:** active.  Milestone 1 (Packages A/B) is complete at authority
commit `28a4457aa`: the 29-page PDF is warning-free and byte-current, the GYY
input proposition has passed a primary-source reread, and the paper and
portfolio mirrors have been exported and rechecked.  Package C is complete in
the authority tree (review: `notes/2026-08-14-c913-package-c-review.md`):
the threshold hypothesis is split into wall and zero-mode halves
(`hyp:marked-threshold-wall`/`hyp:marked-threshold-zero`, referee Major 1
minimal fix), the implying Gamma/window statement is displayed as
`conj:gamma-window` and labeled a new manuscript conjecture, the
endpoint-only weakening is `rem:endpoint-only` plus abstract and intro
sentences (referee Major 2(i)), the expected-versus-open clause account
follows Definition `def:gauged-admissible` and is summarized in the intro
(Major 2(ii)), and the calibration paragraphs are consolidated under
`rem:verification-status` (Major 1(c)).  The ledger and release-surface
checker track the new identifiers; `make check` passes at 30 pages.  The
expected-versus-open labels for clauses (i)--(iii) await Tavis's sign-off.
The standalone mirror has adopted both packages as forward commits
(`2e49e2c` Package C, `b43ad7a` Package D) with its gate green and PDF
hashes byte-identical to the authority; the epilogue mirror was refreshed
the same day (`2877536`).  A fresh Fable referee report finds no endpoint
calculation error or hidden discharge of the global hypotheses.  It requests
a major presentation and proof expansion before broad circulation.  The first
pass is deliberately local: repair endpoint/frame exposition, source
robustness, definitions, notation, and cross-references without changing the
theorem.  The second pass expands the two unconditional geometric arguments
on which a referee is most likely to press.

## Objective

Prepare a referee-resistant revision of
`papers/cubic-stabilization-irrationality/` that makes its proved reduction
under the standing gauged setup, its two independent open inputs, and the exact scope of
the toric calibrations clear at first read.

## Frozen mathematical position

The headline remains conditional on two distinct inputs:

1. a gauged-admissible Wlodarczyk completion for the relevant birational map;
2. the locally finite marked threshold compatibility family for its neutral
   clutching tails.

Under its stated gauged setup, the paper proves the endpoint contrast, local
simple-wall and ordinary-flop identities, support collapse, tailwise derived
identification, and tail holonomicity.  A crepant toric wall gives a genuine ordinary non-zero-mode
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
- Standardize Poincaré spelling, `2`-commutative terminology, and
  packet notation.
- State the archive location and trust boundary of the endpoint checker in
  the verification prose: the checker and certificate ship in the paper
  release at Zenodo concept DOI `10.5281/zenodo.21937490`; it is a regression
  artifact, not a proof substitute.

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
  would imply threshold compatibility.  Label it explicitly as a new
  manuscript conjecture, not as a theorem sourced from the literature.
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
2. **Milestone 1 — local revision/export:** Packages A/B are complete; the
   authority paper has passed its scoped build and cold check; the standalone
   mirror and portfolio summary carry the same local corrections; and the
   frozen PDF is exported before Package C/D begins.
3. Package C displays both inputs and the endpoint-only corollary without
   making either look vacuous.
4. Package D supplies the requested expansions. If either proposed theorem
   cannot be sustained, stop and request author approval before changing its
   statement, moving any assertion into a hypothesis, or otherwise changing
   the theorem architecture; no compressed derived/POT bridge remains
   implicit.
5. The manuscript, README, `.zenodo.json`, claim ledger, portfolio summary,
   and standalone mirror agree; deterministic `make check` passes before and
   after sync.
6. Freeze the revised PDF and obtain two new independent cold reads: one
   derived/gauged-GW reader and one birational/quantum reader.

Package D is complete in the authority tree (report:
`notes/2026-08-14-c913-package-d-expansions.md`): Major 3 is discharged by
`lem:orbit-cylinder-disjoint` (Hilbert--Mumford interval argument run
directly on the resolved completion, making resolution persistence moot),
and Major 4 by the one-chart appendix `app:one-chart` (attractor
equivalence, 2-commutative square via naturality plus a Čech-level equality
of representatives, µ_k/rigidification descent, cutting and Artin
reduction), with the two imported derived comparisons cited
(`ToenVezzosiHAGII`, `SchurgToenVezzosi`).  `make check` passes at 39
pages.  Source extractions for Włodarczyk 2(B′) and Woodward QK II/III are
in the dated notes files of 2026-08-14.

## Immediate next step

Author sign-offs: the expected-versus-open labels for Definition
8.1(i)--(iii) (Package C) and the `F^0_{≤0}` subscript convention check
(Package D report, open point 1).  Then the acceptance-gate closeout:
ej+tt pass with Mystery ledger, fresh frozen PDF, and the two independent
cold reads (derived/gauged-GW and birational/quantum) before re-export.
