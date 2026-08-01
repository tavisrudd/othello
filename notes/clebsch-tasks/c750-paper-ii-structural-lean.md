# C750 — Paper II structural Lean closure

**Lane:** `clebsch`

**Status:** queued after C749; Lean begins only after four human rounds

## Objective

Formalize the frozen C746--C749 human proof surface for the Paper II all-`q`
classification, closing the exact Lean gaps identified by the 2026-07-31
audit without changing the mathematical architecture.

## Scope

- the abstract projective--trade reduction;
- the finite-group Hom-space Lucas-socle criterion;
- the canonical first-wall connecting-map obstruction and exceptional seam;
- the structural q=9 endpoint; and
- the exact paper-facing composition theorem yielding balanced-orbit
  completeness.

## Acceptance gate

Every new paper-facing theorem names its fully qualified Lean declaration.
The Paper II gate imports the complete formal closure, the axiom audit has an
explicit allowlist, comments and docstrings are referee-facing, and the
paper-local aggregate and standalone metadata gates pass.  The formal proof
must follow the frozen human decomposition rather than introduce a second
proof architecture or replace structural lemmas by opaque computation.

## Boundaries

C750 starts only after C749 records the fourth-round human-proof `GO` and
freezes the proof surface.  Certificate generation, native evaluation, and
coordinate enumeration are not substitutes for the structural theorem.

