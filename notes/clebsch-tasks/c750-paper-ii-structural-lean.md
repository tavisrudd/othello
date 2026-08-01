# C750 — Paper II structural Lean closure

**Lane:** `clebsch`

**Status:** active by explicit user direction on 2026-08-01; the repaired
C748 spine has two independent GO verdicts, and Lean/PDF validation now
precedes C749

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

## Lean-first execution plan

1. Map every paper-spine implication to an exact existing or proposed Lean
   declaration, with the outer-parity defect lemma and the detecting-module
   vanishings treated as load-bearing.
2. Put the new proof in bounded structural modules: finite-torus weight
   aliases, root-defect factorization, the four-weight first-Frobenius map,
   detecting-module exclusions, and the final subgroup/sheet composition.
3. Make the Paper II gate import that complete closure and extend the axiom
   audit to every new terminal.  Imported classical representation facts must
   be stated as such; no abstract hypothesis may be presented as a proof of a
   concrete module calculation.
4. Run only the guarded OOM-safe Lean entry points, then the authoritative
   paper aggregate and PDF warning gate.  C749 resumes only after this exact
   formal/paper spine is green.

### First bounded leaves

The initial OOM-safe leaves are kernel-checked individually:

- `RelativeConicArcs.ClebschOuterParityWeights` proves that the selected odd
  torus channel contains only weights \(q-1\) and \(1-q\);
- `RelativeConicArcs.ClebschRootDefect` proves coordinatewise divisibility by
  \(X^q-X\), the quotient degree bound, and the torsion-free cocycle
  cancellation steps;
- `RelativeConicArcs.ClebschFirstFrobeniusSection` proves the complete
  four-weight upper/lower root and Weyl action table, including the mixed
  \(t\sigma(t)\) coefficient and the defect of \(C-B\);
- `RelativeConicArcs.ClebschRegularMatching` and
  `RelativeConicArcs.ClebschDihedralReflectionParity` classify invariant
  regular matchings by nonidentity involutions and prove the residual
  reflection parity equation; and
- `RelativeConicArcs.ClebschOrbitOrderReduction` proves the exceptional
  order reduction to \(q=5,7,9,11\), removes \(q=9\), and forces subgroup
  orders \(12,24,60\).

These leaves do not yet prove the concrete Lucas Hom basis, the four
detecting-module vanishings, the affine-extension contraction, or the
Dickson-to-balanced-orbit composition.  Those are the remaining formal
spine; the release runner and trust manifest must not mark the all-\(q\)
claims as Lean-supported until they are imported by the final gate.

## Boundaries

The earlier sequencing boundary was explicitly overridden on 2026-08-01:
formal closure and the document build now precede C749.  Certificate
generation, native evaluation, and coordinate enumeration are not substitutes
for the structural theorem.
