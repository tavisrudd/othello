# C990 — AME-LU conservative appendix compression

**Lane:** `ame-lu`
**Status:** complete
**Scope:** Paper I only; no Lean, mirror, export, push, deposit, or submission changes

## Objective

Compress Appendix B of *Robust Local-Unitary Rigidity of Stabilizer AME
States* while preserving every substantive theorem and keeping the proofs
easy to referee.  Prefer the Lean-backed two-uniform core, remove duplicated
group bookkeeping and extended commentary, and compress the manuscript-only
`k`-uniform chain structurally rather than deleting its conclusions.

## Acceptance gates

1. No surviving hypothesis, constant, quantifier, or conclusion changes.
2. Appendix B retains the local-generator identity, discreteness, local
   stability, `k`-uniform stability/radius/ceiling, and exact-branch
   decomposition results.
3. `make check` is warning-free and affected pages render cleanly.
4. Resumed cold mathematical and exposition readers identify no essential
   omission or hidden proof gap; accepted findings are repaired.
5. Paper-local theorem, verification, formalization, README, and ownership
   surfaces remain synchronized.

## Working baseline

- authority commit: `db68f6eb9`
- PDF: 39 A4 pages
- SHA-256: `b7fa88d3efd4eb78a7bd9126987031c8c17fca1aba052e23d09f6b8e9b85b7b7`

## Compression pass

Appendix B is reduced from roughly nine rendered pages to seven while
retaining all twelve named lemmas, theorems, propositions, and corollaries.
The pass:

- shortens the product-Lie and local-generator proofs without changing their
  statements;
- condenses the literature, non-Clifford counterexample, Fisher-metric, and
  exact-sequence discussions;
- preserves the full `k`-uniform moment theorem, radius corollary, linear
  ceiling, Reed--Muller obstruction, and both explanatory figures; and
- compresses the compactness argument for exact branch selection.

The warning-free build is 37 A4 pages.

## Cold reads and repairs

The exposition reader returned `MINOR`, finding no essential explanatory,
literature, sequencing, or accessibility loss. Both figures still carry
distinct explanatory work. The reader caught a latent compactness gap in the
exact-branch proof: the generator neighborhood had been defined by a closed
ball. It is now the open principal-logarithm neighborhood, whose complement in
the compact projective product group is compact.

The mathematical reader confirmed that all twelve theorem-like statements,
hypotheses, constants, and conclusions survive. It found two compressed proof
sentences to repair: the party-permutation quotient map must retain the
permutation and forget the local factors, and the empty-complement branch in
the compactness proof needed an explicit choice of threshold. It also asked
that Figure 3 attribute the explicit threshold specifically to Section 6's
cleaning theorem. All three repairs are adopted. Both readers rechecked them
and returned `GO`.

## Final validation

- final length: 37 A4 pages, two pages below the C990 baseline and four below
  the pre-C989 baseline;
- final PDF SHA-256:
  `6be97fa496cf0236b2cf7516a3bddcfbd47e1d29a31e1e4a7cead473dd661247`;
- `make check`: warning-free;
- rendered inspection: every Appendix B page and the Appendix B--C transition;
- no Lean, mirror, export, push, deposit, or submission action.

## `ej` + `tt` closeout

**Extra juice.** Compression exposed two proof obligations that the longer
text had obscured: the topology of the branch neighborhood and the direction
of the party-permutation quotient. Repairing them makes the shorter proof more
precise than the baseline rather than merely shorter.

**Tao pass.** Appendix B has one invariant calculation, (B.1), and two uses:
it kills infinitesimal symmetries and supplies quadratic growth. Higher
uniformity changes only the Taylor remainder. The revised hierarchy now makes
that economy visible while retaining the exact constants and obstruction.

## Mystery ledger

- **Settled:** whether the longer literature, Fisher, exact-sequence, and
  numerical discussions carried an essential proof bridge. Both cold readers
  found that they did not.
- **Settled:** whether the compactness branch was fully justified. The open
  principal-logarithm neighborhood and explicit empty-complement case close
  the latent gap.
- **Settled:** whether either figure had become dispensable. The cold
  accessibility reader found that Figure 3 separates three commonly confused
  scales and Figure 4 makes the uniformity-order comparison legible.
- **No task-owned mystery remains.** Optimality of the cleaning radius and
  occurrence of the prime-field endomorphism types are existing research
  questions owned outside C990.
