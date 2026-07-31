# C725 — terminal passant-arc orbit-DAG certificates

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** queued after C723 and C724; C714 phase 5/6.

## Objective

Replace opaque terminal backtracking for q=13,17,19 by compact,
proof-carrying orbit-DAG certificates while preserving the classification as
an honestly finite theorem boundary.

## Work

1. Freeze which q13 exclusions remain finite after C723 and which q11/q13
   census leaves remain after C724.
2. For each of q=13,17,19, certify the PGL(2,q) root-edge orbit partition,
   setwise stabilizer action, canonical extension rule, and coverage identity.
3. Emit a finite DAG of canonical partial passant arcs. Each nonterminal node
   lists all extension orbits; each terminal node carries an explicit
   obstruction to further extension.
4. Include an explicit six-point witness in every field and verify sharpness.
5. Maintain a separately specified ordered-backtracking replay that checks the
   DAG but is not used to define its canonical keys.

## Acceptance

A small verifier establishes the edge-orbit partition, every DAG transition,
terminality, completeness, and witnesses. The manuscript describes the finite
boundary through this certificate rather than through implementation details
of a search.

## Boundary and handoff

Do not infer an all-q exterior-set theorem, enlarge the field range, or revive
the failed first-order LP. Deliver the final claim-to-proof-mode ledger and
certificate manifest to C726.

