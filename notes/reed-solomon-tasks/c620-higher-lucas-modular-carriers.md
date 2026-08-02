# C620 — split-freeness on higher Lucas modular carriers

**Lane:** `reed-solomon`

**Dependency gate:** Cleared.  C545 published Version 1 on 2026-07-29 under
Zenodo DOI `10.5281/zenodo.21682216`.  This task remains separate from the
immutable Version 1 artifact.

## Target

Classify the split-free points on the first fresh higher Lucas carrier
\[
 \mathbb P\langle e_2,\ldots,e_7\rangle\subset\Gamma^9E
\]
and determine the strongest uniform criterion for split-freeness on arbitrary
consecutive-support Lucas carriers.

The result must distinguish three statements that the current paper keeps
separate:

1. membership in the modular contraction kernel;
2. absence of a completely split squarefree member in the associated Hankel
   system; and
3. promotion to code deepness through the applicable covering-radius theorem.

## Entry strategy

Use the modular \(\mathrm{SL}_2\)-module structure and base-\(p\) digit pattern
to identify the carrier functorially. Translate its Hankel kernels into sparse
linearized or subspace-polynomial systems. Test whether Moore determinants,
subfield containment, or extension-degree divisibility give the exact
split-freeness criterion. The odd/even extension-degree laws at redundancies
six and seven are calibration cases, not assumptions.

## Proof gates

1. Give an intrinsic carrier definition stable under
   \(\operatorname{PGL}_2\), Frobenius, and scalar equivalence.
2. Prove the exact equivalence between a valid split squarefree witness and
   the proposed linearized/subspace-polynomial condition, including infinity
   and collision exclusions.
3. Classify the first fresh carrier without an ambient syndrome-space census.
   Any finite computation must run on a theorem-derived orbit quotient and
   ship a compact certificate plus independent replay.
4. Determine stabilizers, projective and semilinear orbit laws, and the exact
   field-extension behavior of every split-free stratum.
5. Separate a first-carrier theorem from any conjectural all-digit-pattern
   generalization; do not infer uniformity from the first few levels.
6. Audit the modular representation, linearized-polynomial, subspace-code,
   and Reed--Solomon literature before a novelty claim.

## Exit gate

- exact first-fresh-carrier theorem over every admissible finite field;
- a proved uniform criterion, or a sharply stated obstruction to one;
- projective counts and semilinear orbit data for every surviving stratum;
- paper-quality proof, reproducible certificates if used, and an independent
  specialist review; and
- a placement decision between Version 2 of the beyond-four paper and a
  separate modular-carrier companion.
