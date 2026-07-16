# C186 — An A5-orbit proof of the displayed Clebsch conic locus

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED.** The manuscript now prints the sourced representation-theoretic
fixed-point and subgroup ledger, derives the orbit profile `[6,10,12,15,30,30,30]`, and uses the
unique invariant twelve-orbit to identify the uncovered locus with the conic. The independent
strict-kernel certificate is split into 113 bounded modules and verifies the displayed concrete
sixty-element action; its aggregator passes `lake build --no-build`, the generator check, and the
standard-axioms-only audit. It does not replace the manuscript's abstract subgroup derivation.

## Target argument

Derive the `A5` point-orbit sizes `[6,10,12,15,30,30,30]` and the uniqueness of the off-arc
12-orbit from the projective representation and its order-five fixed points. Edge's ten classical
Brianchon points form the invariant 10-orbit inside the full triple-point set. Since a second
off-arc orbit would already exceed the universal bound `c<=15`, this forces `c=10`; the
chord-defect identity gives `|U|=12`, and uniqueness identifies `U` with the conic orbit.

The weaker statement `c>=10` alone does not force the conclusion and must not be used as if it
did. The existing 133-point enumeration remains an independent verification.

## Exit gate

- prove the representation/order-five fixed-point calculation with exact hypotheses;
- derive rather than assume the relevant orbit uniqueness;
- verify the Brianchon ten-set is invariant and contained in the triple-point set; and
- retain the completed strict-kernel action certificate as an independent finite bridge.

The completed build gate was serial leaves-first at `choom -n 500`, followed by the lightweight
aggregator, no-build freshness probe, generator replay, and exported axiom audit.

## Manuscript disposition

The paper now prints the missing representation-theoretic derivation. The fixed-point spectra for
elements of orders two, three, and five are combined with the proper-subgroup ledger for `A5` to
derive the complete orbit profile `[6,10,12,15,30,30,30]`. Dye identifies the first four orbits as
the vertices, Brianchon points, associated conic, and self-polar-triangle vertices. Consequently
the uncovered locus is forced conceptually: it is an invariant twelve-set disjoint from the unique
six-orbit, hence the unique twelve-orbit, the conic.

The manuscript explicitly separates proof roles. Dye supplies the abstract `A5` representation and
the classical orbit identifications; the subgroup/fixed-line calculation derives uniqueness; and
`Q11A5PointOrbits.lean` independently certifies the displayed concrete sixty-element action and all
seven finite orbits. The Lean certificate is not described as a formalization of the abstract
subgroup classification.
