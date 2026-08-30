# C1003 — matching-design publication routing

**Lane**: `relconic`

**Status:** Queued; C1002 math packet and C1008 scalar reformulation frozen;
publication decision only.

## Goal

Evaluate the frozen C1002 theorem packet against the arcs paper and banked matching-design results, then choose between a forward-paper strengthening, a companion, and a standalone finite-geometry/design paper.  The packet includes manuscript-ready draft language, but no manuscript has been edited.

## Acceptance gate

- Complete a closest-literature and priority audit.
- Measure whether the result is a candidate exclusion, a family theorem, or a full representation classification.
- Specify the human proof, computational certificates, formal annotations, geometric-transfer statement, and release work required by the selected destination.
- Decide whether the six-local obstruction merits a private ergodis
  finite-field-construction prefilter.  It can reject a proposed
  maximum-matching design before coordinate search from one bad six-set, but
  it is not part of the public recovery optimizer unless a real construction
  workflow consumes it.
- Do not edit a manuscript or create a spinoff until the destination is accepted.

## Optional solver hook

The frozen obstruction has a compact solver contract: input a proposed
\(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) design, enumerate its induced
perfect matchings on each six-set, and reject odd-characteristic
realizability when the six-factorization graph is not a union of cliques with
an odd component.  A rejection certificate needs only the bad six-set and
the extending blocks.  The \(k=10\) certificate has three blocks.

This is useful as a private exact prefilter for coordinate/orbit searches.
It does not justify a new ergodis public command by itself.

C1008 supplies the preferred scalar certificate. For each six-set graph
\(G\), compute

\[
D(G)=\sum_v\deg(v)^2-2|E(G)|-6T(G).
\]

Reject when \(D(G)>0\), or when \(D(G)=0\) but every vertex has odd degree.
The identity \(D(G)=2\#\{\text{induced }P_3\}\) gives a one-line human proof
that this is exactly C1002's union-of-cliques-with-an-odd-component test.
