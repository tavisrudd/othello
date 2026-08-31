# C1015 — global obstruction beyond the six-local matching test

**Lane:** `relconic`

**Status:** Queued. No manuscript, summary, mirror, formal, release, or
Ergodis source edits are authorized.

## Starting point

C1003 classified the four simple `MATCH(9,4,1)` designs over arbitrary
fields. Exactly one odd-characteristic representative passes the C1002/C1008
test on every six-set, yet seven concurrence equations eliminate to

\[
x_8^2(x_8-1)^2,
\]

contradicting the frame arc inequalities. The exact replay is
`notes/c1003_match9_rank_three.py`; the publication and literature context is
`notes/2026-08-30-c1003-matching-design-publication-routing.md`.

## Objective

Explain the seven-equation contradiction without treating it as an isolated
Gröbner accident, and determine the strongest reusable theorem it supports.
The preferred outcome is a global compatibility invariant that is forced by
rank-three chord concurrency and that strictly refines all six-local tests.

## Work programme

1. Expand and factor the seven normalized determinant equations; search for a
   short substitution chain, cross-ratio identity, bracket syzygy, Menelaus/
   Ceva configuration, or projective monodromy contradiction.
2. Determine the actual carrier of the obstruction: seven displayed blocks,
   their vertex/block incidence shadow, or a smaller invariant subdiagram.
3. Test relabellings and deletions to decide whether the certificate is a
   nine-point phenomenon or the first instance of a uniform seven-/eight-/
   nine-local compatibility law.
4. Formulate a characteristic-sensitive invariant whose odd-characteristic
   specialization forces the contradiction and whose characteristic-two
   degeneration explains the `F_8` survivor.
5. Audit primary literature on representations/embeddings of abstract ovals,
   abstract hyperovals, hyperfactorizations, and `pg(5,7,3)` for such global
   compatibility laws, following `notes/literature-audit-conventions.md`.
6. Use Ergodis only through its control interface, if useful, to rank or
   compress candidate identities. Record control/provenance improvements but
   do not edit Ergodis source.

## Success gates

- **Base:** a human derivation of `x_8^2(x_8-1)^2` from the seven displayed
  concurrences, with every division and characteristic exception explicit.
- **Strong:** an invariant statement independent of the chosen projective
  frame, plus a replayable bounded-shadow recognizer.
- **Priority-judo:** a general global compatibility theorem for rank-three
  matching-design realizations from which the nine-point exclusion and a
  classical abstract-oval fact both follow, or which answers a representation
  question absent from the subsequent literature.

## Publication decision after proof

Prefer the arcs equality appendix if the result remains a nine-point boundary
lemma. Reassess a standalone representation note only if the invariant is
uniform in size, excludes an infinite family, or yields a structural
classification beyond the four order-eight pointed classes.
