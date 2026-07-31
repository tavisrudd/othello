# C721 — q13 elliptic-scheme spine for Paper I

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** complete and reported 2026-07-31; C722 and C724 unblocked.

**Report:**
[`2026-07-31-c721-q13-elliptic-scheme-spine.md`](../2026-07-31-c721-q13-elliptic-scheme-spine.md)

## Objective

Turn the q13 minimum-layer span and automorphism computations into one
association-scheme/geometric proof spine, retaining the existing eliminations
and stabilizer chain only as independent checks.

## Work

1. Fix one notation bridge between the six elliptic relations, the companion's
   pair/triple concurrence data, and the exact checker arrays.
2. For each of the four 91-word minimum orbits, identify its binary Gram
   operator as the recorded relation operator of valency 9, 9, 12, or 10.
3. Compute the relevant ranks inside the mod-two Bose--Mesner algebra and prove
   that every orbit spans the 36-dimensional code. The proof may use an exact
   minimal polynomial, primary decomposition, or explicit scheme idempotent
   calculation, but not an unexplained row reduction.
4. Starting from the already reconstructed passant/internal incidence matrix,
   prove that every minimum-layer automorphism preserves the conic incidence
   geometry and hence belongs to PGL(2,13). Check the converse directly from
   the action.
5. Record precise published inputs or give a self-contained incidence-rigidity
   lemma. Do not cite a theorem whose hypotheses have not been matched.

## Acceptance

The manuscript can prove all four orbit-span statements and
`Aut = PGL(2,13)` without invoking exhaustive elimination or group enumeration.
The old rank and order-2184 checks reproduce the structural result exactly.

## Stop boundary and handoff

If the Gram operators are identified but their mod-two ranks do not follow
from the available scheme algebra, freeze those identities as compression and
leave rank elimination load-bearing. If conic-incidence rigidity does not
determine the full automorphism group, retain the stabilizer-chain proof and
state the residual ambiguity. In either case, pass the verified relation
dictionary to C722 and C724.
