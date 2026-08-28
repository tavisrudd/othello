# C986 CSS coordinatewise Clifford classification and Borel realizability

**Lane:** `ame-lu`

**Status:** queued

## Goal

Determine whether C982's torus/Borel/full-(\mathrm{SL}_2) projection theorem
supports a publishable standalone classification of coordinatewise Clifford
symmetries of CSS codes.  The task must develop the theorem beyond its short
algebraic proof, especially through realizability, global group structure,
algorithms, prime-power sectors, and operational logical consequences.

## Starting theorem

For a pure CSS stabilizer label space (C_X\oplus C_Z^\perp), standard
indecomposable decomposition reduces the coordinatewise field-linear
endomorphism algebra to factors of two kinds:

1. (M_2(\mathbf F_q));
2. a split diagonal algebra with square-zero off-diagonal radical.

Consequently every one-coordinate field-linear local-Clifford projection is,
up to conjugacy,
\[
 T,\qquad B_2(q),\qquad\mathrm{SL}_2(q).
\]
The proof and scope ledger are in
`notes/2026-08-27-c982-mds-conductor-endomorphism-algebra.md`.

## Research questions

1. **Realizability.**  Which conductor bimodules (B,D), square-zero support
   patterns, and resulting global semidirect products occur for actual CSS
   states?  Construct nontrivial infinite indecomposable families realizing
   the Borel branch, or prove structural restrictions that prevent them.
2. **Global classification.**  Classify the full coordinatewise field-linear
   Clifford stabilizer, not only its one-coordinate projections, including
   component products, radical dimensions, torus weights, and conjugacy.
3. **Recognition.**  Give a polynomial-time algorithm that computes the
   stabilizer decomposition, cross-conductors, radical pairing, local type, and
   global group description from classical generator matrices.
4. **Operational meaning.**  For parties with maximally mixed marginals,
   identify the induced one-qudit logical affine groups and state exactly what
   the Borel branch permits and forbids.  Separate stabilizer-state symmetry
   from encoder logical action elsewhere.
5. **Prime powers.**  Determine the trace-symplectic and Frobenius-semilinear
   sectors over (q=p^e).  Decide whether the three field-linear types refine
   or merge under the full local Clifford group.
6. **Positive-rate CSS codes.**  Analyze the generalized matrix algebra
   \[
   \begin{pmatrix}
   \operatorname{St}(X)&\operatorname{Cond}(Z,X)\\
   \operatorname{Cond}(X,Z)&\operatorname{St}(Z)
   \end{pmatrix}
   \]
   and its action on the logical quotient (L^\perp/L).  Identify hypotheses
   under which an exact finite group list is possible.
7. **Novelty.**  Audit graph-state local symmetries, CSS automorphism groups,
   Rains-style endomorphism algebras, diagonal transversal Clifford
   classifications, and finite classical-group realizability before making a
   priority claim.

## Deliverables

1. A theorem package containing the global pure-CSS algebra decomposition,
   the coordinate projection trichotomy, and exact scope.
2. A realizability theorem or infinite Borel family with direct proofs and
   reproducible examples.
3. A recognition algorithm with correctness proof and complexity bound.
4. A prime-power completion, or a precise obstruction showing why it must be a
   separate theorem.
5. A positive-rate extension theorem or a sharply bounded counterexample to a
   finite-list classification.
6. A current primary-literature audit and a skeptical-referee assessment of
   whether the package is a paper, a short note, or material for another work.
7. If publication-strength, a proposed title, theorem hierarchy, and section
   architecture.  Do not edit an existing manuscript or allocate another task
   without explicit instruction.

## Acceptance gate

- Do not treat the one-paragraph torus/Borel/full proof alone as a paper.
- At least one substantive layer beyond C982 must close: realizability,
  prime-power exactness, or positive-rate logical classification.
- Every claimed family has symbolic parameter conditions and direct proof;
  finite enumeration is validation, not the theorem.
- The distinction between uniform, site-dependent, coordinate-permuting, and
  semilinear transversality remains explicit.
- The final recommendation must include a stop condition: if the theorem is
  implicit in prior endomorphism-algebra work or no nontrivial realizability
  theory emerges, retain it as a corollary/outlook rather than forcing a paper.

## Dependencies and noninterference

- Primary mathematical input: C982.
- Publication/framing input: C981.
- C979 is user-held open and may be active independently.  C986 must not edit,
  export, close, or otherwise interfere with C979.

