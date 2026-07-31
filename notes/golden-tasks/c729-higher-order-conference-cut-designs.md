# C729 — Higher-order extremal conference-cut designs

**Lane:** `golden`

**Status:** queued after C720; sequel direction

## Objective

Start from the exact Naimark--Gram lift from the order-six syndrome matrix to
the Petersen/Paley order-ten conference operator, and determine whether it is
the first step of a functorial conference tower.  Explain what replaces the
order-six all-cut maximum-determinant theorem at later stages by classifying
extremal balanced cross blocks, group orbits, and any canonical block design
or association scheme they carry.

## Gates

1. Reproduce the exact factorization
   \[
   R_{6\times10}R_{6\times10}^{\mathsf T}=12(I-J/6),
   \qquad
   R_{6\times10}^{\mathsf T}R_{6\times10}=6I+2S_{10},
   \]
   prove \(S_{10}^2=9I\), and identify \(S_{10}\) intrinsically as the
   Petersen/Paley conference operator with eigenspaces \(5\) and \(1+4\).
2. Explain why the lift preserves the conference identity but loses universal
   cut extremality: among the 126 balanced
   \(5\times5\) cross blocks, 90 are singular and 36 have determinant
   magnitude 48.
3. Determine whether the extremal 36 cuts form a canonical orbit, block
   design, code, or another incidence object inherited from the \(6\to10\)
   lift.
4. Compute exact cut-determinant distributions for the next feasible
   conference orders and split them by automorphism-group orbit, with compact
   reproducible certificates.
5. Derive representation-theoretic or Cauchy--Binet moment identities for
   the distribution; distinguish universal constraints from Paley-specific
   arithmetic.
6. Formulate and test stability/inverse statements: how many extremal or
   near-extremal cuts force proximity to a conference signing?
7. Run a focused conference-matrix, ETF/Naimark, Petersen-Seidel, and
   maximal-minor literature audit before
   claiming a new higher-order principle.

## Acceptance

- An intrinsic theorem explaining the \(6\to10\) lift and at least one
  higher-order cut distribution or design, not merely tables.
- A sharp statement of why order six is exceptional.
- Exact scripts, compact certificates, independent replay, and human proof.

## Boundary

This is a sequel direction.  It enters the Golden paper only if it produces a
short theorem that clarifies the order-six mechanism; otherwise the paper
records only the explicit order-ten counterexample.

## Dependencies

C720 supplies the order-six theorem and order-ten boundary test.  The task is
otherwise independent of C715--C719 and C728.
