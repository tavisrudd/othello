# C607 — fixed-parameter exact projective Reed--Solomon decoding

**Lane:** `reed-solomon`

**Status:** active; launched 2026-07-26 by explicit user direction.

**Version 1 boundary:** The user explicitly authorized theorem development
before C545 publishes Version 1.  This task must remain a separate companion
development and must not change the Version 1 manuscript or its reviewed
release artifact.

**Governing proposal:** `notes/2026-07-26-prs-fpt-split-locator-ej-report.md`.
That report supersedes the raw incidence-first plan below with a native
split-Hankel-locator formulation and records the exact theorem spine,
literature domains, arithmetic search barriers, companion-paper links, and
acceptance gates.

## Target

Prove, at a publication-ready algorithmic complexity boundary, that exact
syndrome distance for the length-\(q+1\) projective Reed--Solomon code of
redundancy \(r\) is deterministically decidable in
\[
F(r)\operatorname{poly}(\log q),
\]
and that an explicit nearest codeword and minimum-support error pattern are
recoverable unconditionally in
\[
F(r)q\operatorname{poly}(\log q).
\]
The theorem must use the exact equivalence among PRS support weight, finite-field
atomic moment rank, rational NRC/divided-power rank, and a split locator in the
syndrome Hankel system.

The paper must separately prove the arithmetic boundary for compressed support
recovery: the redundancy-four square-root reduction and, if correct, the
general reduction from factoring completely split squarefree polynomials.
It must state the strongest fully sourced randomized or conditional
support-recovery theorem available without conflating decision, locator,
factored-support, and explicit-codeword output.

## Entry questions

1. State the cost model precisely: field operations, representation of
   \(\mathbf F_q\), deterministic and randomized factorization costs, output
   representation, and verification.
2. Extract from Kayal a single uniform bound
   \(F(r)(\log q)^C\) with \(C\) independent of \(r\); do not infer FPT merely
   from a fixed-variable polynomial-time statement.
3. Prove the locator/Vieta encoding in both projective charts, including
   lower-weight padding, repeated roots, squarefreeness, small characteristic,
   and reconstruction of magnitudes.
4. Audit prior work across parameterized RS decoding, Prony and sparse
   interpolation, LFSR/error-locator synthesis, binary Waring decomposition,
   rational secant rank, and deterministic finite-field factorization.
5. Prove the square-root reduction before drafting an abstract, then prove or
   discard the proposed general split-factorization reduction.
6. Keep arbitrary puncturing outside the theorem unless its evaluation-set
   membership remains bounded-format with an absolute input-size exponent.

## Exit gate

- a complete locator dictionary and deterministic FPT distance theorem;
- an unconditional \(F(r)q\operatorname{poly}(\log q)\) explicit decoder;
- the exact square-root barrier and a resolved general factorization reduction;
- sourced randomized/conditional recovery results or their explicit omission;
- a claim-specific literature audit;
- independent algorithmic-complexity and algebraic-coding reviews;
- exact separation between the enormous generic parameter function \(F(r)\)
  and any claim of practical decoding;
- reconciliation with the PRS, AME--LU, and Clebsch companion claims; and
- a separate decoding note, with only a restrained Version 2 PRS discussion
  paragraph after the companion theorem and novelty audit are green.
