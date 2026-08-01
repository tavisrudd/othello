# C760 — Ten Proofs reusable-method spike

**Lane:** `gem-mining`

**Status:** QUEUED — provisional until the lane's user-launched independent vet

## Goal

Run a bounded transplant test of two methods exposed by *Ten Advances in Mathematics and
Theoretical Computer Science* against named portfolio frontiers:

1. the scalar two-point moving-projection/Gram certificate from proof #2; and
2. the bounded polynomial-moment reconstruction lemma from proof #7.

## Spike boundary

- Reconstruct the exact hypotheses and proof objects needed for each method; do not import the
  114,000-line `MetricCodes.lean` development.
- For moving projections, test one finite `PGL(2,q)`/point-stabilizer model against the conic
  passant-arc bound, beginning with the certified controls `q=13,17,19`. Compare it with the known
  zonal/root-edge LP and identify the precise missing projection or transition identity if it fails.
- For moment reconstruction, test whether the lemma's whole-fibre power-sum hypotheses occur in
  either the Reed--Solomon deep-hole atlases or the matching-quotient moment data. Reject the route
  cleanly if our data provide only low moments without the required polynomial-family coherence.
- Screen the other eight proofs only for a named, hypothesis-level transplant into a current
  frontier. Similar vocabulary or thematic proximity is not a lead.
- Make no cross-lane source or manuscript edits. Any successful transplant is promoted through a
  separately allocated task in the owning lane after the required independent vet.

## Acceptance

Produce a compact provisional report containing, for each tested method: source theorem and read
depth, exact source-to-target dictionary, smallest finite control, pass/fail result, obstruction or
quantitative gain, and a ranked promote/hold/kill verdict. Any computation used in the verdict must
have a tracked replay script and compact certificate under the repository reproducibility rules.
