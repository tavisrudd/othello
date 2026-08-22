# C910 — the unconditional genus-eight half of the flop corollary

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `b1873b960`.
**Predecessor:** the pairing-horizontality report
`2026-08-18-c910-pairing-horizontality.md`.

`cor:v14-one-step` has two assertions.  The framed one, `nu_6(V) = 2` for every
smooth prime Fano threefold of genus eight, is conditional on Hypotheses 5.7R
and 5.7T and was already in Lean.  The unconditional one, irrationality of
`V x P^1`, had no terminal; it does now.

## The route

The argument uses no multiplicity, no weak factorization, and no quantum
comparison.  Kuznetsov's flop makes the projectivizations of the two rank-two
bundles birational; each projectivization is birational to the product of its
base with a projective line; so one projective-line stabilization of the Fano
threefold is birational to one projective-line stabilization of the associated
Pfaffian cubic.  Irrationality of the latter is the ordinary Hodge-atom
theorem already formalized for the cubic zero-packet atom, and rationality is a
birational invariant, so it transports back.

`Applications/GenusEightThreefold.lean` now carries that route beside the framed
one.  Three things are separated in the signature: the naming data (the two
predicates, the associated Pfaffian cubic, the two total spaces), the birational
apparatus at exactly the strength used (symmetry, transitivity, and transport of
rationality), and the geometric premises (each projectivization birational to a
product, the two projectivizations birational to each other).  The reviewer
terminal `genusEight_oneStep_irrational_of_atom_inputs` returns both the
birational comparison of the two stabilizations and the irrationality
conclusion, with the cubic's atom, ledger, and exclusion premises visible in its
type.

## Coverage

`cor:v14-one-step` keeps its conditional-deduction class and gains a terminal;
its caution no longer says the unconditional half is unformalized.  The snapshot
is 50 claims and 46 machinery rows over 190 terminals: 20 absent, 16
fragmentary, 13 conditional, 1 complete.

## Gates

All green at `b1873b960`.  The module was elaborated singly, then built through
the guarded queue with `PaperInterface` and `Verification.AxiomAudit` after it.
`make check` and the axiom-log check pass over 105 sources, and the new terminal
reports `propext, Classical.choice, Quot.sound`.  No manuscript source was
edited; the tracked PDF is unchanged at 49 pages.

## Scope

Lean constructs neither the Fano threefold, the Pfaffian cubic, the rank-two
bundles, their projectivizations, nor the flop, and does not prove that a
rank-two projectivization is birational to the product of its base with a
projective line.  Birational equivalence is a supplied relation, used only
through symmetry, transitivity, and invariance of rationality.

## Mystery ledger

- The unconditional route needs no dimension bound.  The framed route carries
  `dimension <= 4` because weak factorization supplies the multiplicity
  comparison only there; transporting irrationality needs nothing but a
  birational equivalence, so the same argument would run in any dimension.  The
  dimension-four restriction of the corollary belongs entirely to its framed
  half.  Settled by this pass.
- The Fano threefold's own atom never appears.  All atomic data is required of
  the associated Pfaffian cubic; the Fano carrier enters only through the flop.
  That is the precise sense in which the unconditional half is a corollary of
  the cubic theorem rather than an independent argument.  Settled by this pass.
- Open, and shared with every other application row: birationality of a
  rank-two projectivization with a product is a standard consequence of Zariski
  local triviality that this package cannot state, having no schemes.  Evidence
  gap: no geometric foundations in the companion.  Owner: the geometric
  realization item of the backlog.
- Nothing else about the landed statement is unexplained.

## Next

From the gap audit, still open: `lem:disc` and `lem:spectrum-transfer`,
terminals for `prop:no-curve` and `prop:no-surface` sliced out of the atom-route
exclusion, the even-part refinement of `lem:orthogonal`, and the disposition of
the orphaned machinery themes.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`a470f773b` at its commit `d58e5a4`, the export manifest verifies, and the
repository's own `make check`, pinned Lean build, and axiom-log replay agree
with the authority over 190 reviewer terminals.
