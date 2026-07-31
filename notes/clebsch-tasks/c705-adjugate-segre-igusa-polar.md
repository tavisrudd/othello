# C705 — Adjugate realization of the Segre--Igusa polar map

**Lane:** `clebsch`

**Opened:** 2026-07-30

**Status:** in progress

## Objective

Determine whether the six adjugates
\(\operatorname{adj}(B_T(x))\), for
\[
B_T=P_{T,-}D_xP_{T,+},
\]
assemble intrinsically into the Segre--Igusa polar map without first
passing through the six scalar squares \(Z_T^2\).

## Frozen input

Import C704's conference operator, golden eigenspaces, signed Joubert
coordinates, cross-block determinant, matrix factorization, and
Segre--Igusa diagram.  Do not recompute their discovery history.

## Main gates

1. Decompose the span of the quadratic \(2\times2\) minors of all six
   cross-golden blocks under the signed outer \(S_6\)-action.
2. Compute the equivariant Hom space from that span to the outer-standard
   Igusa carrier.
3. Test whether contraction with the six frozen coefficient tensors gives
   the polar coordinates \(W_T\) up to one exact scalar.
4. If the raw adjugates fail, test the trace-free, compound-matrix, and
   exterior-square variants.
5. Identify the base locus scheme-theoretically.

## Upgrades

- Recover the fifteen singular Igusa lines as rank conditions.
- Test direct kernel descriptions of the ten Segre nodes and fifteen
  planes.
- Express the inverse Igusa-to-Segre map in the same operator language.

## Required closeout

No first-gate closure is allowed.  Run distinct `ej1`, `tt1`, `ej2`, and
`tt2` passes, incorporating and retesting all in-scope leads between the
pairs.  A negative result must identify the minimal obstruction,
obstruction locus, nearest positive repair, converse content, propagation
law, and one adjacent crown.  The final report must contain a mystery
ledger and the complete reproducibility bundle required for any
paper-facing computational claim.

## Acceptance

A positive result is a coordinate-free trace/adjugate diagram for the
Segre gradient, with exact scalar and base locus.  A negative result is a
representation-theoretic obstruction after the full route family and
negative-yield protocol have been exhausted.

## Boundary

Do not sweep arbitrary quadratic functions of \(B_T\), enlarge to WP2's
marked double-six comparison, or make a novelty claim without the
proportional literature audit.
