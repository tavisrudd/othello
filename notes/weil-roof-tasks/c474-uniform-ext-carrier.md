# C474 — uniform Ext theorem for the lower-Weil Lagrangian carrier

**Context:** queued after C471, with C472/C473 consumed when available. C465 certifies nonsplit
`3_epsilon.3_epsilon^*` and `5_epsilon.5_epsilon^*` augmentation modules in the two frozen cases,
while the common parameter `m=(q+1)/4` simultaneously splits the lower period polynomial and
degenerates the cross-design Grams.
The shared conditional consequence map is `notes/2026-07-22-c471-c474-downstream-implications.md`.

## Dependencies

- C465 exact Loewy, commutant, Gram, and period data
- C471 operator-level explanation
- C472/C473 for the signed and arithmetic refinements when they affect the theorem statement

## Task

1. Compute `Ext^1_{F_2 PSL_2(7)}(3_epsilon^*,3_epsilon)` and
   `Ext^1_{F_3 PSL_2(11)}(5_epsilon^*,5_epsilon)` exactly, including dimensions and explicit
   cocycle representatives; locate the frozen augmentation class.
2. Decide whether each carrier is the unique nonzero extension up to module isomorphism and scalar
   cocycle, or give the exact orbit of the frozen class under automorphisms of the endpoints.
3. Seek a uniform theorem driven by `m=(q+1)/4`: period split `x^2+x+m`, Gram degeneration, simple
   Lagrangian socle, dual head, and nonsplit self-dual carrier. State the precise hypotheses and do
   not generalize from two cases without proof.
4. If no honest uniform family survives, close with the strongest common two-case theorem and the
   exact obstruction to extension.

## Acceptance

Require exact cohomology/extension certificates, independently checkable cocycles and coboundary
ranks, a theorem or sharp negative with quantified domain, and an atomic reproducibility bundle.

## Boundaries

- Two examples do not establish a family.
- A one-dimensional commutant does not by itself prove a one-dimensional Ext group.
- Any literature-dependent novelty statement follows the repository literature-audit convention.
