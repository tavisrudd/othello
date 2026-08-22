# C910 — the curve and surface exclusions from named premises

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `8ea3528fe`.
**Predecessor:** the genus-eight unconditional report
`2026-08-18-c910-genus-eight-unconditional.md`.

`prop:no-curve` and `prop:no-surface` had no terminals: their content sat inside
two bundled implications of the atom ledger's exclusion input, which asserted
the surface decomposition and the vanishing of a curve atom's residue
discriminant outright.  Both propositions are now proved in Lean from premises
that match the manuscript's citations one by one.

## The refined premises

`Quantum/LowDimensionalAtomRepresentatives.lean` carries two input structures.

The curve input supplies the parity ranks, the residue discriminant, the genus,
and one dichotomy: on a variety of dimension at most one, an occurring atom is
either a point atom of even rank one, or the single nef-canonical atom of a
curve, with parity ranks two and twice the genus and vanishing residue
discriminant.  That single field is where the projective-bundle formula for a
projective line, the point calculation, the nef-canonical lemma, and the curve
residue computation enter.

The surface input adds the passage to a minimal model and two fields: an atom of
even rank at least two survives the blow-down, which is the point-blowup
formula; and on a minimal model an occurring atom either has even rank at least
three, the nef case, or occurs already in dimension at most one, which is the
classification of minimal surfaces together with the projective-bundle formulas
for the plane and for a geometrically ruled surface.

From these, Lean proves both propositions for the cubic zero-packet atom:
a variety of dimension at most one carrying it would have genus five, no variety
of dimension at most one carries it, and no variety of dimension at most two
does either.  The reviewer terminals are `cubicAtom_not_represented_by_curve`
and `cubicAtom_not_represented_by_surface`.

## Coverage

Two rows moved from absent to conditional deductions.  The snapshot is 50 claims
and 46 machinery rows over 192 terminals: 18 absent, 16 fragmentary, 15
conditional, 1 complete.

## Gates

All green at `8ea3528fe`.  The new module was elaborated singly, then built
through the guarded queue with its consumer, `PaperInterface`, and
`Verification.AxiomAudit`.  `make check` and the axiom-log check pass over 106
sources, and both new terminals report `propext, Classical.choice, Quot.sound`.
No manuscript source was edited; the tracked PDF is unchanged at 49 pages.

## Scope

Lean constructs no variety, atom, atomic composition, blow-down, or minimal
model, and proves none of the imported formulas.  The headline row continues to
reach the same exclusion through the two bundled implications rather than
through these refined premises; both routes are registered, and the claim map
says which is which.

## Mystery ledger

- The rank comparison the surface argument needs is much weaker than the one the
  manuscript states.  The prose contrasts rank twelve with rank one; the formal
  proof needs only even rank at least two to survive the blow-down, and only
  even rank exactly two to contradict the nef case.  The odd rank is never used
  on the surface side; it enters only in identifying the genus.  Settled by this
  pass.
- The genus-five step is vacuous downstream.  The residue discriminant excludes
  every curve, whatever its genus, so the parity-rank computation that isolates
  genus five is an expository waypoint rather than a load-bearing step.  Lean
  records it as its own clause for exactly that reason.  Settled by this pass.
- Additivity for disjoint unions, which the manuscript invokes to pass from
  surfaces to all varieties of dimension at most two, is not needed here: the
  ledger's multiplicity is a function on varieties and the statements quantify
  over them directly, so no decomposition into connected components occurs.  The
  formal statement is therefore about all varieties of dimension at most two
  from the start.  Settled by this pass.
- Nothing else about the landed statements is unexplained.

## Next

From the gap audit, still open: `lem:disc`, `lem:spectrum-transfer`, the
even-part refinement of `lem:orthogonal`, and the disposition of the orphaned
machinery themes.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`a76d0cc08` at its commit `6c0e39d`, the export manifest verifies, and the
repository's own `make check`, pinned Lean build, and axiom-log replay agree
with the authority over 192 reviewer terminals.
