# Paper I Lean extraction audit

**Date:** 2026-07-30

## Repository split

- `finitegeom` owns the human-scale reusable mathematics.
- `finitegeom-clebsch-q11-certificates` owns the generated q11 tables,
  Dye seam, and the complete Paper I aggregate gate.
- The Paper I release scripts still assume the former monorepo layout:
  one commit, one root, and base-library files beside the q11 generated
  files.  They must be taught the two-root layout before the clean release
  gate can be called current.

## Added in the base library

`RelativeConicArcs/ClebschOrientationTwoGraph.lean` now checks, without a
blanket `import Mathlib`:

- switching invariance of triangle products;
- the explicit conference identity \(B^2=5I\);
- off-diagonal pair balance;
- the deleted-row kernel equation;
- \(M^2=5I-uu^{\mathsf T}\) for every principal block;
- translation invariance of the support cubic;
- equality of its coefficients with triangle products; and
- vanishing of the gradient at the six displayed nodes.

These terminals are in the base human gate and the downstream Paper I gate.

## Calculations demoted to discovery cross-checks

- The Hessian rank is now a textual consequence of
  \(Mu=0\) and \(M^2=5I-uu^{\mathsf T}\), with those identities checked in
  Lean.
- The \(S_5/A_5\) distinction is now derived from the pentagon model of the
  regular six-point two-graph and its orientation character.
- Conference, pair-balance, translation, triangle-coefficient, and node
  evaluations have textual proofs or explicit Lean terminals.

## Calculations still load-bearing

1. Singular-locus completeness: the five chartwise gradient-ideal
   reductions remain the one load-bearing finite-algebra step in the main
   paper.
2. The q13 weight-profile exclusions and minimum-layer reconstruction
   remain certificate/exhaustive claims in the companion.
3. The q13/q17/q19 terminal passant-arc exclusions remain exhaustive, but
   their tracked certificates regenerate byte-for-byte and pass an
   independent discriminant/backtracking replay.

The determinant-pencil identity already has a short mathematical proof by
principal minors and Jacobi complementation.  A direct six-by-six Lean
Laplace expansion was tested and rejected for this pass because it produced
a slow, brittle normalization term; it is not needed to remove a proof
dependency on the Python checker.

## Release migration

The old release validator hard-codes the pre-extraction aggregate commit and
expects base and generated files in one checkout.  The safe migration is:

1. pin `finitegeom-clebsch-q11-certificates` as the aggregate formal root;
2. record its pinned `finitegeom` dependency separately;
3. resolve scholarly paths across the package root and its pinned dependency;
4. regenerate the axiom audit, trust manifest, and deterministic release
   output; and
5. run the clean release verifier against both clean snapshots.

Until this migration lands, the manuscript can accurately cite the new
human-scale gate, but the old nineteen-row clean-release receipt should not
be represented as regenerated against the extracted layout.

## Referee estimate after this update

- Mathematical result: **A- / strong specialist**.
- Exposition and novelty boundary: **A-** after the literature, theorem
  hierarchy, rational-descent, and six-node provenance repairs.
- Verification architecture: **B+ now**, rising to **A** once the two-root
  release validator and singular-locus terminal are current.
- Overall submission strength: **A-**.

Best fit: *Algebraic Combinatorics*.  A first submission to *Journal of
Combinatorial Theory, Series A* is defensible if the inverse reconstruction
chain is kept as the headline and the extracted release receipt is finished.
*Designs, Codes and Cryptography* is the conservative coding-facing venue.
