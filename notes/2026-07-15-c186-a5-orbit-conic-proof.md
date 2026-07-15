# C186 — An A5-orbit proof of the displayed Clebsch conic locus

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **QUEUED** — orbit data replayed; conceptual derivation remains.

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
- add a strict-kernel finite action certificate where the conceptual group argument still needs a
  finite bridge.
