# C210 synthesis response: corrections, gaps, and re-ranking

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** review response to
[`2026-07-18-c210-observations-and-synthesis-after-ansatz-failure.md`](2026-07-18-c210-observations-and-synthesis-after-ansatz-failure.md).
This note responds only where there is a disagreement or an addition; silence on a section means
agreement. It proves nothing new and allocates nothing; proposed tasks go through the normal
queue process.

## Corrections

### 1. The plain-language scope claim overstates the constant-height boundary

The plain-language section says "every parameter choice in the certified full two-coset template
is eventually bad." That is the theorem only for nonconstant height `(a,b) != (0,0)`. On the
`a=b=0` stratum the closure is the exact `GF(8)`-defined census, so a family that chooses fresh
constant-height coefficients anew in each tower field is outside the certified scope. The
synthesis concedes this twice (the constant-height boundary paragraph and missing layer 9), but
the executive summary and plain-language account do not carry the hedge, and that is the version
most likely to be copied into a paper abstract. The correct compressed statement is: every
nonconstant-height specialization for `q >= 32768`, every exceptional stratum for `q >= 512`, and
every `GF(8)`-defined constant-height family; per-field constant-height choices remain open.

### 2. The fiberwise `sqrt(2)` match is bookkeeping, not evidence

Both the global lower bound and the fiber computation are the same inequality: `k^2/2` selected
pairs against a carrier of about `q^2` points, with bounded hits per secant per carrier. Restrict
that counting to any carrier of the same order and the constant `sqrt(2)` reappears by necessity.
So "strongly suggests that the global defect identity has a carrierwise refinement rather than the
matching constant being a coincidence" is the wrong frame: the match is neither coincidence nor
evidence — it is forced. The carrierwise program (attack 2 / C302) can still be valuable, but its
entire justification is the possibility of an equality/stability theorem with new nonnegative
terms; the constant match contributes zero support and should be cut from any motivational text.

### 3. Missing layer 6's slogan is contradicted by known objects

"Low-degree algebraic layers have forced incidence energy, while near-optimal relative coverage
requires Sidon-like low energy" — Singer difference sets and planar-function relative difference
sets are low-degree algebraic constructions that are exactly perfect/Sidon-optimal. Algebraicity
per se does not force incidence energy. A theorem in this direction must isolate what
distinguishes a subfield-rational one-dimensional layer (an `F`-line in the section space) from a
Singer cycle or planar orbit; as currently phrased the "deeper structural possibility" would be
refuted before it was stated. The synthesis's own layer 9 already treats planar functions as a
positive mechanism, so layers 6 and 9 are in mild tension as written.

### 4. The Baer-contained obstruction is probably folklore

The proof is a half-page double count, and the classical constructions of complete arcs in
`PG(2,q^2)` meeting a Baer subplane add points outside the subplane precisely because the
inside-only set cannot be complete. Keep it as a proposition in Paper I, but state it as
presumably known pending a check of Hirschfeld and the computational complete-arc surveys, not as
a novelty claim.

## What the synthesis misses

### 1. The `q = 512` generic gap is finitely machine-closable — the biggest cheap win

Only two odd-tower fields sit below the Hasse--Weil threshold: `8` and `512`. The exceptional
strata are already proved at `512`; only the generic off-divisor complement is open there, and it
is a finite sweep. Per parameter point in the generic locus, run an early-exit search for a
genuine rational collision: iterate `u`, solve the resulting low-degree equation in the second
variable, and apply the committed `H, J` reconstruction plus a direct distinctness/collinearity
test on the reconstructed triple (the global `H != 0` identity guarantees reconstruction at every
rational point in the tower). In the `p = 1` chart this is roughly `512^4` parameter points with
an expected `O(1)` values of `u` before the first hit; with `GF(512)` log tables in Rust this is
hours on the box, not days. If the scaling gauge has not been verified lossless for
specializations, the unnormalized `512^5` sweep with Frobenius reduction is still feasible.

Both outcomes are headlines. Full confirmation makes the theorem clean — every odd-tower
`q >= 512` — and removes the awkward "limitation of the proof threshold" paragraph. A survivor is
a sporadic construction candidate, which would be more interesting than the theorem itself. The
recorded `q = 8` branch exceptions can be finished in the same run.

This is not the forbidden unrestricted coefficient census: it is the unique theorem-completing
check at the single open field, with a per-point stop condition and a committed evidence-bundle
target. It is not among C297--C304 and needs a new ID through the normal allocation process.

### 2. Missing layer 3 should import the exceptional-covers literature, not rebuild it

The permutation-polynomial analogy is exact and already has a developed theory: exceptional
covers and correspondences (Fried; Fried--Guralnick--Saxl; Guralnick--Mueller--Saxl). The
formalism "no Frobenius-fixed geometric component off the diagonal" and the strong classification
constraints on which monodromy groups can be exceptional are theorems, not a program to design.
C301's realistic shape is therefore: place the collision correspondence in that framework, read
off which exceptional monodromy classes are even possible at the given bounded bidegree, and check
whether any is realizable by a layer family. That converts the six-step moduli program of layer 3
into an application of an existing classification, and it is the strongest argument that C301 is
reachable at all.

### 3. Two-parabola priority: the closest literature is pencils/unions of conics

The seed arc is the union of the affine parts of two conics in a pencil (same `x^2`, shifted
constants). Arcs contained in the union of two conics, and in pencils of conics, have their own
classical literature, distinct from the hyperfocused/translation lineage the synthesis cites. The
pencil-of-conics comparison is the one that can sink the novelty claim outright, so it should run
first in the Paper II literature pass, with the hyperfocused comparison second.

### 4. The Kloosterman--elliptic identification is an afternoon, not a program

Kloosterman sums as Frobenius traces of explicit elliptic curves is classical
(Lachaud--Wolfmann; Katz), with the curve family written down. In C300, the substantive work is
the projective/code equivalence, stabilizers, and coverage residues; the elliptic identification
should be a bounded lookup. Do not allocate any isogeny/moduli follow-on unless the lookup
produces an actual coincidence, such as the three repair orbits landing in one isogeny class.

### 5. C298's go/no-go is nearly free, and the synthesis does not say so

The three projection-degree bounds in missing layer 2 are resultant-degree computations on
polynomials that are already written down and hashed. That first milestone is computer-algebra
work measured in days, and it decides immediately whether the `Omega(q)` disjoint-collision route
is open. The synthesis lists these as "missing checks" without observing that this makes C298 the
cheapest of the eight follow-ons to start — which bears directly on ordering.

## Ordering disagreement: run C298 before C297

The synthesis puts C297 (normal form/moduli) first. Three reasons to swap:

- C298 answers the live mathematical question — whether partial repair domains, the only
  surviving route inside this architecture, are viable — and its first milestone is nearly free
  (point 5 above).
- C297's output mainly scopes the breadth of the paper's claim. It changes exposition, not the
  next experiment, and of the eight follow-ons it carries the largest scope-creep risk:
  projective-equivalence and moduli computations expand.
- The information flows one way. If C298 proves the robust `Omega(q)` matching, the
  partial-domain route dies and the universality question loses urgency — the obstruction is then
  robust regardless of how canonical the chosen slice was. If C298 finds concentrated fibers,
  C297's moduli say where the escape lives. C297's outcome does not similarly redirect C298.

Reconciliation: C298 first as research; C297 remains the gate for *drafting* Paper II, since its
outcome fixes how the family is described. The `q = 512` closure sweep (gap 1 above) can run
unattended alongside either.

## Kill / scope-down list

| Item                                     | Action                                        | Reason                                                                                                                                                             |
|------------------------------------------|-----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Attack 3 dictionary items 1--3, 5        | Scope down to item 4 only (dead-set identity) | Off-conic point ↔ involution ↔ chord matching is classical projective geometry; theorem-packaging it adds no content until a consumer needs a specific lemma        |
| C299 as a standalone task                | Fold into Paper II drafting                   | The residue/valuation reproof is a presentation improvement; the synthesis itself demotes ideal certificates to verification. As a C301 gate it stalls the exceptional-covers route, which supersedes it |
| Missing layer 5 (compactified moduli)    | Do not allocate                               | Its concrete deliverables — invariant definition, gauge-versus-symmetry — are already C297 sub-questions; the bundle language is needed for none of them             |
| Missing layer 8 beyond the lookup        | Cap at the identification                     | Gap 4 above                                                                                                                                                          |
| Fiberwise-`sqrt(2)` motivational text    | Cut from any paper draft                      | Correction 2                                                                                                                                                         |
| Attack 7 (probabilistic deletion)        | Agree with the existing gating on C298        | —                                                                                                                                                                    |

The synthesis's own restraints — no more undirected coefficient mining, no library extraction
before a second consumer — are right and should hold.

## Where the synthesis is right and it matters

- The distinction "the theorem kills arc legality first and is silent on coverage" is exactly the
  right hedge and must survive every round of editing.
- The `q = 64` affine-complete `24`/`26` object is the freshest finite item in the portfolio, and
  the caution about a priority audit before any novelty claim is correct; C300 should begin with
  the pencil-of-conics and hyperfocused comparisons before computing anything new.
- The three-paper packaging is right. One addition: Paper II drafting is gated on C297
  specifically, not on the rest of C298--C304.
