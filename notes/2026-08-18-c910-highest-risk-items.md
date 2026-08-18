# C910 — the highest-risk items: separated-factor pairings, the symmetric exclusion, and thin rows

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-18.  **Authority commit:** `2bc736282`.
**Predecessors:** the gap audit `2026-08-18-c910-post-restructure-gap-audit.md`,
the hearts and product-corollary report
`2026-08-18-c910-hearts-and-product-corollaries.md`, and the framed-route and
rank-two rigidity report
`2026-08-18-c910-framed-route-and-rank-two-rigidity.md`.

This pass took the items ranked by risk rather than by cost: the two whose
feasibility was unknown, the one concrete hole inside a row that looked better
covered than it was, and the class of registered rows a hostile reader would
attack first.

## Risk ranking used

Three kinds of risk were separated.  A statement registered at a strength the
Lean type does not support is the worst, because it is a claim rather than a
gap.  A hole inside a row that reads as covered is next, because the row's
strength is overstated in aggregate even when every individual terminal is
sound.  An item disclosed as absent is the least risky, whatever its
difficulty, because nothing is claimed for it.  Ranked that way, the order was:
audit the thin rows, close the missing exclusion step, and attempt the two
formalizations whose feasibility was open.

## Block diagonality on separated spectral factors

`lem:orthogonal` was the remaining unformalized link in the pairing chain: the
hypotheses of `lem:A0preserve`, self-adjointness of the square-zero leading part
for an invertible pairing coefficient, are exactly what it supplies.  Its
algebraic content is now in `Quantum/SeparatedSpectralPairing.lean`.

The Sylvester step is proved without operator machinery.  Shifting both leading
operators by the second eigenvalue turns the equation into
`A * X = X * B` with `B` nilpotent and `A` a nonzero scalar plus a nilpotent, so
`A` is a unit.  Intertwining passes to powers by a one-line induction, and at
the nilpotency exponent of `B` the right side vanishes, so `A ^ k * X = 0` with
`A ^ k` a unit and `X = 0`.  The order-by-order induction is then strong
induction over the order, with the hypothesis that each right-hand side vanishes
once all strictly earlier coefficients do.  The nondegeneracy consequence is the
block determinant identity: a pairing with vanishing off-diagonal blocks is
invertible exactly when both diagonal restrictions are.

Not formalized: the `F`-bundle, the spectral splitting, the derivation of the
order-by-order equations from horizontality, and the even-part refinement, which
uses that the Poincare pairing pairs only equal parities.

## The exclusion that selects the exotic gluing

The gap audit found that the step actually selecting the exotic two-primary
kernel was absent from Lean: the comparison of `|S₆| = 720` against Hartlieb's
classification of faithful automorphism groups, five of order below `720` and
one of order `9720`.  Neither number occurred anywhere in the sources, while the
row `prop:principal-gluing-packet` read as a fragment with fifteen terminals.

`GraphLattices/SymmetricSixExclusion.lean` closes it.  Lean computes the order
of the symmetric group on six letters, proves through Lagrange that a group
receiving an injective homomorphism from it has order divisible by `720`, and
concludes that no group of smaller order and no group of order `9720` admits
one.  The classification enters as the hypothesis that the ambient order lies in
a supplied list each of whose entries is below `720` or equal to `9720`.

## Thin rows, stated as thin

A targeted audit asked, for each registered row, how much work the Lean
deduction does once its premises are granted.  Most rows survive that question:
the framed operation formulas consume real multiplicativity of root
multiplicities with nonvanishing side conditions, the divisor-tagging machinery
carries the exponential-character independence and support arguments, and the
atomic route does exact residue arithmetic.  Three rows do not, and the claim map
now says so in their own cautions.

- `lem:divisor-tagging`.  Granted the two final polynomial equalities, the
  vanishing endpoint is immediate, because the primitive-sixth multiplicity is
  defined from the characteristic polynomial.  That terminal carries nothing
  beyond its premises; the row's content is in its other terminals, and the
  caution now separates them.
- `cor:universal-ch0`.  The deduction is one step: an iff premise composed with
  a fibrewise algebraicity premise.
- `thm:separation-family`.  Three of its four clauses are compositions or the
  supplied predicate itself; only the irrationality clause consumes a nontrivial
  argument.

Saying this in the artifact is worth more than the coverage it costs.  A referee
who samples those rows would otherwise find the gap between the label
`conditional deduction` and a single rewrite, and would then distrust the rest of
the map.

## Coverage

`lem:orthogonal` went from absent to fragment, and `prop:principal-gluing-packet`
gained the exclusion terminal.  The snapshot is 50 claims and 46 machinery rows
over 186 terminals: 21 absent, 15 fragmentary, 13 conditional, 1 complete.

## Gates

All green at `2bc736282`.  Both new modules were elaborated singly, then built
through the guarded queue with `PaperInterface` and `Verification.AxiomAudit`
after them; `make check` and the axiom-log check pass over 104 sources.  Each new
terminal reports `propext, Classical.choice, Quot.sound`.  The manuscript was not
edited, so the tracked PDF is unchanged at 49 pages.

## Mystery ledger

- The Sylvester argument needed no separate treatment of the nilpotent parts:
  shifting by the *second* eigenvalue, rather than by either operator's own, puts
  all the nilpotency on one side and all the invertibility on the other.  That is
  why the proof needs no binomial expansion of a commuting difference of
  multiplication operators, which was the expected route.  Settled by this pass.
- The exclusion is insensitive to five of the six classified orders: only the
  divisibility test against `9720` does any work, since any order below `720`
  fails for the trivial reason.  Whether the five smaller orders are individually
  correct therefore does not matter to the argument, which is worth knowing if
  the classification is ever restated.
- Still open and owned by a successor: deriving the order-by-order pairing
  equations from horizontality, which is the last unformalized link between
  `lem:horiz` and `lem:A0preserve`; and the even-part refinement of
  `lem:orthogonal`.
- No other genuine mystery in the landed statements.

## Next

Still open from the audit: `lem:disc` and `lem:spectrum-transfer`, the missing
unconditional half of `cor:v14-one-step`, terminals for `prop:no-curve` and
`prop:no-surface` sliced out of the atom-route exclusion, and the disposition of
the four orphaned machinery themes.

## Export status

Not exported.  The paper repository under `~/src/math-papers/` is now nine
commits behind the authority.
