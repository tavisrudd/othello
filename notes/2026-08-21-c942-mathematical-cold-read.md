# C942 mathematical cold read

**Frozen object:** commit `6412a6c92`, `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md`

**Perspective:** primary-audience mathematical referee

**Verdict:** **Accept after minor required correction.** The guide gives a faithful,
efficient six-step route to the unconditional \(m=1\) theorem. No mathematical
dependency is omitted or reversed.

**Confidence:** 0.96

## Required finding

1. **Restore mathematical delimiters in the six-step list.** As frozen, the guide
   prints `(D)-module`, `(z)`, `(mathbb Z)`, `(-1/6)`, `(-5/6)`, `(2/3)`,
   `(X\times\mathbb P^1)`, and `(mathbb P^4)` as prose or raw TeX rather than
   mathematics. This is the first visible friction and affects the central route,
   not a peripheral note. Use one Markdown-compatible convention consistently.

## Optional finding

1. In Step 3, say that `lem:A0preserve` supplies the missing lower-left
   vanishing **used to prove** regularity of the elementary modification. The
   lemma itself states only \(A_0L\subset L\); regularity is established in the
   paragraph immediately after it using `eq:Asharp`. The present wording is
   navigationally adequate but slightly over-attributes the conclusion.

## Strongest passage

Step 5, **Center nullity**, is the strongest part of the guide. It identifies the
actual bottleneck for fourfold weak factorization and names the complete surface
case split. The manuscript verifies exactly that split in
`prop:atomic-lowdim`: nef-canonical surfaces, \(\mathbb P^2\), ruled surfaces,
and point blowups, followed by faithful transport to each comparison occurrence.

## First point of friction

The first list item calls the object the “quantum `(D)`-module.” The missing
math delimiter is immediately conspicuous to the intended audience and previews
the same defect in later formulas. The mathematical exposition itself becomes
clear as soon as the reader opens `sections/02-qdm-marker.tex`.

## Semantic-label and dependency audit

Every semantic label named by the guide exists in the primary manuscript and
has the claimed role:

| Guide label | Verified statement and role | Result |
|---|---|---|
| `prop:generic-spectral-connection-splitting` | A unique regular Sylvester gauge splits separated leading spectra into formal connection blocks; base directions and pairing split too. | exact |
| `thm:marker-ledger` | Blowup additivity plus zero correction for every actual center occurrence implies birational invariance by weak factorization. | exact |
| `lem:faithful-center-base-change` | Divisor-character tags make the reduced center Novikov map injective and identify each center summand with a faithful scalar extension of its intrinsic QDM. | exact |
| `prop:qdm-operation-ledgers` | Iritani--Koto projective-bundle and Iritani blowup comparisons give the two marker formulas, with even-carrier restriction, regular \(z\)-gauges, fixed splitting fields, grading suspensions, and occurrence data handled explicitly. | exact |
| `lem:A0preserve` | Pairing horizontality gives \(A_0L\subset L\); the following calculation makes the elementary modification regular. | exact, with wording refinement above |
| `prop:rank2-rigidity` | Flatness makes the modified residue satisfy a Lax equation, hence fixes its discriminant and regular-isomorphism class. | exact |
| `prop:residue-discriminant-exponents` | The modified residue eigenvalues represent the original formal exponent classes modulo \(\mathbb Z\), and their squared difference is the residue discriminant. | exact |
| `prop:cubic-block-data` | Beauville's three products yield two rank-one blocks and one square-zero rank-two zero block; the displayed follow-up computation gives exponents \(-1/6,-5/6\), difference \(2/3\), and marker \(1\). | exact |
| `prop:atomic-lowdim` | The marker vanishes for every smooth point, curve, and surface and, via faithful center base change, for every actual occurrence. | exact |
| `thm:every-cubic` | \(I_{\rm at}(X)=1\), projective-bundle additivity gives \(I_{\rm at}(X\times\mathbb P^1)=2\), semisimplicity gives \(I_{\rm at}(\mathbb P^4)=0\), and the ledger plus low-dimensional nullity forbids rationality. | exact |

The dependency order is sound:

1. spectral splitting defines the block objects;
2. the comparison theorems plus faithful center base change supply ledger
   additivity;
3. rank-two regularity, rigidity, and exponent interpretation define a lawful
   fold;
4. the Beauville calculation detects the cubic;
5. low-dimensional nullity removes every center allowed in a fourfold
   factorization; and
6. the product and projective-space endpoint values contradict birational
   invariance.

The guide's evidence-boundary pointers all exist at the frozen commit. Its
classification is also honest: weak factorization, the two QDM comparison
theorems, Beauville, regular-singular classification, and minimal-surface
classification are cited inputs; the intervening bridges are written in the
manuscript; the headline proof invokes no computational evidence bundle. This
was a route/dependency cold read, not a new primary-source audit of those
imported theorems.

## Mystery ledger

The `ej` + `tt` closeout found no genuine mathematical mystery in the guide's
route. The apparent gap between intrinsic center nullity and occurrence-level
nullity is settled explicitly by `lem:faithful-center-base-change`; the apparent
gap between nonzero discriminant and a lawful marker is settled by passing to
exponent classes modulo \(\mathbb Z\). The only open item is the editorial
delimiter defect recorded as the required finding above; it has no successor
mathematics gate.
