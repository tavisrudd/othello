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

Cold-read minor fixes landed at `9d934f974`: the Mumford numerical-criterion
locator is pinned to Chapter 2, Section 2.1; `2`-commutative is now used
everywhere; Proposition A.12(d) says why Artin-level compatibility is automatic
for the identifications as opposed to the paired numbers; and the
Gamma/window implication paragraph is labelled a sketch.  `make check` passes
at 39 pages.  The Zenodo concept DOI `10.5281/zenodo.21937490` resolves to
version record 21941287 (v0.4.0), whose archive carries `check_cubic_endpoint.py`,
`cubic_endpoint_certificate.json`, `SHA256SUMS`, and the verification README;
the archived checker and certificate are byte-identical to the authority copies
and pass standalone.  That deposit is the pre-Package-D manuscript (mirror
commit `2e49e2c`, no appendix); deposits follow the GitHub release
automatically, so this is a note on what the current DOI resolves to, not an
open task.

Referee-driven revision of 2026-08-14, all committed and synced: the paper is
retitled *Gamma Point Rows under Quantum Wall Crossing and a Criterion for
Stable Irrationality*; the abstract opens with the transport mechanism and
names the Gamma/window conjecture as the route to removing the hypotheses; the
introduction says why counting packets stops working from `m = 2`; and
`lem:cubic-central-charge` derives the cubic central charge from the small
`I`-function instead of asserting its normalization.  Three cold reads ran
(reports: `notes/2026-08-14-c913-cold-read-cubic-endpoint.md`,
`notes/2026-08-14-c913-cold-read-counting-failure.md`,
`notes/2026-08-14-c913-consistency-check.md`).  They found one off-by-one (a
cubic threefold is an admissible centre only from `m >= 2`), three
overstatements, a false Barnes hypothesis (`p = q-1`, not `p <= q`), a ledger
row claiming an integral power where the lemma proves `z^{k-3/2}`, and an
abstract gate that passed a wording denying its own assumptions; all are
repaired.  Both release gates now collapse whitespace, scan every occurrence of
the conclusion, and require the sentence stating it to carry a condition.
`make check` passes at 42 pages; the standalone repository is synced and
verified against the export manifest at authority commit `a5fd508c2`, with PDF
and certificate hashes byte-identical, and the portfolio summary mirror is
refreshed.

Source check of the Cai dependency (cached `arXiv:2608.01577`, sha256
`06bfccf9...`, re-fetched 2026-08-14 and byte-identical): the matrices `K` and
`G`, the basis, and Proposition 6 are quoted correctly by
Section~9.1.  One slip in the source, not in ours: Cai's prose gives the
eigenvalues of `K` as `+-3 sqrt3 q^{1/2}`, which is the spectrum of `K/2` --
the bracketed matrix has characteristic polynomial `l^4 - 27q l^2`, so the
displayed `K = 2(...)` has `+-6 sqrt3 q^{1/2}`, as our Section~9.1 states.
Nothing downstream moves; raised with the author by email.

Both author sign-offs are closed (2026-08-14, with third-party review).  The
`F^0_{≤0}` subscript is correct: tangent weights are opposite to
coordinate-function weights, so the invariant sections over a chart retain
`aw <= 0`, and it was the module identity in the Čech lemma that carried the
wrong inequality.  That is fixed, the subscript now states which weights it
means, and an `A^1` check is included.  Definition 8.1(i) is split: freeness of
the extreme quotients is close to what Włodarczyk's construction supplies,
while stable equals semistable is a separate chamber-position assumption which
does not subsume it, since GIT stability gives only finite stabilizers.  Clause
(iii) no longer claims to be "closest to automatic"; the separation must reach
the affine cocharacter degree and pointedness is a positivity hypothesis.
Clause (ii) stands as written.

The derived/gauged-GW cold read
(`notes/2026-08-14-c913-cold-read-derived-gauged.md`) found one architecture-level
defect and two local ones; all three are repaired in the authority tree
(report: `notes/2026-08-15-c913-support-collapse-output-node-repair.md`).
`prop:support-collapse` conflated two González--Woodward statements: the
principal component lands in the semistable fixed locus, but an arbitrary
marking only in the full fixed locus.  Remark 3.19, now read in full from the
cached source, sharpens the distinction rather than closing it.  The repair
narrows `def:gauged-admissible`(iv) to fixed components semistable for an
interpolated polarization and inserts the distinguished class at the output
evaluation of the graph factor, which is computed from the principal
component; `rem:iv-semistable-restriction` proves by equivariant formality
that no choice of class could repair it instead.  The endpoint functional is
unchanged.  `eq:signed-moving-slope` carried an undefined symbol and is
replaced by the unsigned `eq:total-moving-slope`, with the two-ray Stirling
estimate written out.  The false chart-independence argument in
`prop:app-one-chart` is replaced by the invariance argument with a
counterexample to the old one, plus the family form.  `make check` passes at
44 pages.

## Follow-up to discuss before the next revision pass

Six independent referee cold reads ran on 2026-08-15 (reports
`notes/2026-08-15-c913-cold-read-post-repair.md`, `-round2`, `-round3`, `-round4`, `-round5`,
`-round6`). Required-repair counts fell ten, two, two, one, one, and the last was in a clause an
earlier round had itself introduced. Everything required is closed. The following were judged
optional by the referees who raised them, or lie outside what a repair round should decide, and are
held for a deliberate decision rather than another edit cycle.

1. **Notation pass across Section 8 and its appendix.** `k` is both the affine-degree index and the
   orbifold cover order, so "consecutive degrees inside a tail differ by the stabilizer order" reads
   as saying consecutive `k` differ by `k`; `a` is the clutching exponent, the virtual-line index,
   and the Poincaré dual of the orbit closure; `x` is a point of `W`, a test-scheme point, and the
   generating-series variable. Raised in four consecutive rounds and declined each time because
   renaming across a section and its appendix is exactly the sweeping edit that introduced six new
   defects in one round. Worth doing once, deliberately, with a build check per rename.
2. **Five citations never verified at source, across every round.** Behrend–Fantechi,
   Graber–Pandharipande, Toën–Vezzosi, Schürg–Toën–Vezzosi, and Mumford's GIT are not in the
   literature cache. These carry the virtual-class bridge in `prop:app-square`, the fixed-part
   principle, the mapping-stack cotangent formula, and the numerical criterion. The manuscript
   derives the numerical criterion itself, so GIT is mitigated; the others are not. Natural first
   task for a cross-check with fetch access.
3. **Tangent versus cotangent in `lem:app-truncation`'s proof.** The sentence "the pushforward along
   `π` of the pullback of the cotangent complex of the target, dualized" inverts the operations; the
   object used, and the one `E_a` is defined from, is the dual of the pushforward of the pulled-back
   tangent complex. Round six judged this optional because `E_a` is defined correctly where it is
   introduced.
4. **The main text still reads as citing Definition 7.13 for a morphism**, which
   `conv:app-obstruction-morphism` explicitly says that definition does not supply. Half a clause
   pointing at the convention would settle it.
5. **`prop:app-descent` does not state `a_± ≠ 0`**, which its proof needs through
   `prop:app-one-chart` and which its right-hand side presupposes.
6. **Two locator additions in `rem:verification-status`**: Iritani's global Landau–Ginzburg
   construction for the Brieskorn-module clause, and the kernel description behind the graph
   Fourier–Mukai transform's action on skyscrapers of the common open.
7. **The joint rotation-plus-polarization fixed-point analysis** is registered as an assumption
   rather than proved. Correctly registered, but it is the largest single thing the conditional
   theorem rests on inside this section, and a cross-check should look at it directly.

## Immediate next step

Land the remaining cold-read items: the Schürg--Toën--Vezzosi import replaced
by an internal comparison, the QK III/Graber--Pandharipande/Toën--Vezzosi
locators, and D-finite wording plus the boundary-value paragraph in
`prop:clutching-tail-holonomicity`.  Then the acceptance-gate closeout:
ej+tt pass with Mystery ledger, fresh frozen PDF, mirror and portfolio sync in
one forward commit, and the second independent cold read
(birational/quantum) on the revised text.
