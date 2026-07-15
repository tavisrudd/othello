# C186 — An A5-orbit proof of the displayed Clebsch conic locus

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **FINITE LEAN BRIDGE COMPLETE; CONCEPTUAL DERIVATION OPEN.** The strict-kernel
certificate is physically split into bounded modules: definitions and arithmetic, twelve matrix
leaves, twelve support leaves plus summary, sixty one-group action leaves plus twelve row
aggregators, seven representative-orbit cases, and seven fixed-point membership leaves. Ordinary
`decide` works through a proved eleven-entry evaluator for `ZMod` inversion and symbolic bridges
back to the original projective action. All 113 source modules, including the lightweight
`Q11A5PointOrbits` aggregator, pass the serial leaves-first build; `lake build --no-build` reports
the target up to date, the generator check passes, and the exported axiom audit contains only the
standard axioms. The remaining C186 work is the sourced representation/order-five argument and
its Brianchon/triple-point integration.

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
