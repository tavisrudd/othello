# Handoff: mirror-boundary formalization

**Date:** 2026-07-12
**Status:** IN PROGRESS
**Tasks:** C85 [REPORTED 2026-07-12]; C86–C88 [OPEN]

## Goal

Close the strict-trust boundary classification for fixed-point-free projective involutions on
classical polar-space cap boards. Formalize the tractable parabolic and Hermitian negative cases;
keep the general elliptic `Q⁻(2m−1,q)`, `m≥3`, statement explicitly conjectural until its
Witt/Scharlau-transfer classification is proved.

The detailed mathematical statement and prose reductions live in
[`../2026-07-09-mirror-method-boundary.md`](../2026-07-09-mirror-method-boundary.md). This handoff is
the live execution map. Session history belongs in
[`done/2026-07-12-mirror-boundary-formalization-archive.md`](done/2026-07-12-mirror-boundary-formalization-archive.md).

## Strict trust gate

- A boundary row is Lean-proved only when its full classification chain is formalized and its
  printed axiom profile is limited to the accepted Mathlib foundations.
- Prose classifications, computations, and imported paper claims do not satisfy the gate.
- No `sorry`, `native_decide`, ad hoc axioms, or unproved bridge assumptions in the delivered Lean
  source.
- Method-negativity means only that no fixed-point-free mirror of the classified type exists; it
  does not determine the game's P/N outcome.

## Landed formal core

| Result | Lean location | Status |
|---|---|---|
| fpf collinearity-preserving involution gives a P sub-board | `ProjectiveCap/Mirror.lean` | Lean-proved |
| hyperbolic `Q⁺(2m−1,q)` mirror and P theorem | `ProjectiveCap/HyperbolicQuadricMirror.lean` | Lean-proved |
| scalar-square projective fixed-point criterion | `ProjectiveCap/Mirror.lean` | Lean-proved |
| eigenvector gives a projective/board fixed point | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved |
| finite quadratic forms in dimension at least three are isotropic | `ProjectiveCap/FiniteQuadraticIsotropy.lean` | Lean-proved (C85) |
| scalar-square involution in dimension at least five fixes a quadric point | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved (C85) |
| parabolic split linear route is not fixed-point-free | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved (C85) |
| odd-dimensional scalar-square matrix has square scalar | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved |
| parabolic nonsplit linear route is impossible | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved |

Current source audit: no `sorry` or `native_decide`; the relevant builds pass with axiom profile
`[propext, Classical.choice, Quot.sound]`.

## Open work packages

| Task | Required theorem package | Depends on | Completion effect |
|---|---|---|---|
| **C86** | Nondegenerate finite Hermitian spaces of dimension at least two are isotropic; formalize the adjoint/multiplier constraints for the nonsplit linear case. | Landed eigenvector reduction | Closes the linear Hermitian branches. |
| **C87** | Classify order-two Baer-semilinear collineations sufficiently to expose their fixed subgeometry; prove that subgeometry meets each relevant parabolic and Hermitian board. | Board/form models from C85/C86 may be reused, but the classification is logically separate. | Closes the semilinear branches and completes the parabolic/Hermitian method-negative rows. |
| **C88** | Classify elliptic-quadric-preserving involutions through the required Witt/Scharlau transfer, including split and nonsplit possibilities in all `m≥3`. | C85 quadratic infrastructure; C87 if semilinear elements are included in the final theorem. | Either proves the advertised `Q⁻` exclusion or records the exact countercase. Until then the claim is conjectural. |

## Dependency and attack order

C85 is closed and its quadratic isotropy infrastructure is available to C88. Proceed with **C86**.
Do C87 after the concrete Hermitian board model is stable. Attempt C88 only after the reusable
quadratic and semilinear infrastructure is in place; it is the item expected to require genuinely
new mathematical work.

Before editing a nontrivial Lean proof, load the named-expert umbrella and the relevant algebra,
finite-geometry, and Lean dossiers as required by `AGENTS.md`.

## Validation gate

For each closed task:

1. Build the smallest affected Lean targets first, then `ProjectiveCap` using the repository's OOM
   hygiene.
2. Print and record the axiom profile of every new load-bearing theorem.
3. Search the Lean source for `sorry`, `native_decide`, and new `axiom` declarations.
4. Update the strict-status wording in the detailed boundary note, this handoff, the main project
   handoff, and the task queue in the same commit.
5. Append commands, outputs, proof choices, and any closed-negative route to the companion archive;
   keep this live handoff limited to current state.

## Next step

Begin C86 by inventorying Mathlib's sesquilinear/Hermitian-form, conjugation, and finite-field
extension APIs. Separate the general Hermitian isotropy theorem from the nonsplit
adjoint/multiplier classification, and do not promote the Hermitian row until both linear branches
are formal.
