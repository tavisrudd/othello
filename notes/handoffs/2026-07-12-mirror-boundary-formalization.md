# Handoff: mirror-boundary formalization

**Date:** 2026-07-12
**Status:** IN PROGRESS
**Tasks:** C85–C87 [REPORTED 2026-07-12]; C88 [OPEN]

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
- No `sorry` or `native_decide`. Imported literature theorems must be quarantined in an assumptions
  module and every dependent result must remain explicitly outside the strict Lean-proved tier.
- Method-negativity means only that no fixed-point-free mirror of the classified type exists; it
  does not determine the game's P/N outcome.

## Claim impact of the adversarial review

No Lean theorem or computed game outcome was removed or weakened. The review initially narrowed
two prose headlines to their then-proved scope; C87 has since restored the parabolic headline for
the modeled square-scalar Baer-semilinear branch:

- The parabolic and Hermitian rows exclude every modeled linear or square-scalar Baer-semilinear
  representative. The parabolic proof now accepts projective board preservation directly and has
  no imported classification axiom.
- The categorical prose claim about every Baer involution remains scoped to the formal model:
  relative-Frobenius semilinear representatives whose square is a nonzero scalar.
- The hyperbolic `Q⁺` P theorem is unchanged. The elliptic `Q⁻` claim was already conjectural and
  remains so. No P/N headline changes: these are mirror-method boundary statements only.

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
| quadratic-extension norm surjectivity and square reflection | `ProjectiveCap/FiniteHermitian.lean` | Lean-proved (C86) |
| finite Hermitian forms in dimension at least two are isotropic | `ProjectiveCap/FiniteHermitian.lean` | Lean-proved (C86) |
| Hermitian split scalar-square route is not fixed-point-free | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved (C86) |
| Hermitian nonsplit similitude scalar is impossible | `ProjectiveCap/FiniteHermitian.lean`, `ProjectiveCap/MirrorBoundary.lean` | Lean-proved (C86) |
| coordinate relative Frobenius, general square-scalar conjugacy, and Hermitian Baer intersection | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87) |
| scalar Hilbert-90 normalization and fixed-value quadratic-form descent | `ProjectiveCap/BaerQuadraticDescent.lean` | Lean-proved (C87) |
| semilinear conjugate pullback is an ordinary quadratic form | `ProjectiveCap/BaerQuadraticUntwist.lean` | Lean-proved (C87) |
| nondegenerate quadratic forms with the same null cone are proportional in vector dimension at least five | `ProjectiveCap/QuadraticNullCone.lean` | Lean-proved (C87) |
| every modeled Baer-semilinear parabolic board stabilizer is not fixed-point-free in vector dimension at least five | `ProjectiveCap/BaerQuadraticStabilizer.lean` | Lean-proved (C87) |

Current source audit: no `sorry`, `native_decide`, or project axiom in the C87 modules. Every new
load-bearing theorem has axiom profile exactly `[propext, Classical.choice, Quot.sound]`.

## Open work packages

| Task | Required theorem package | Depends on | Completion effect |
|---|---|---|---|
| **C88** | Classify elliptic-quadric-preserving involutions through the required Witt/Scharlau transfer, including split and nonsplit possibilities in all `m≥3`. | C85 quadratic infrastructure and, for semilinear elements, the closed C87 conjugacy/rigidity package. | Either proves the advertised `Q⁻` exclusion or records the exact countercase. Until then the claim is conjectural. |

C87 is closed by a coordinate-free null-cone rigidity proof; its internal C87a–d work-package
history is recorded in the companion archive.

## Dependency and attack order

C85–C87 are closed; their quadratic, Hermitian, semilinear-conjugacy, descent, and null-cone
rigidity infrastructure is available to C88.

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

Close **C88, elliptic `Q⁻` transfer**. Do not build the Lean proof around the desired negative verdict
before checking the classification. Put a nonsplit representative in the standard `2×2` block
form for multiplication by `√c`, solve the symmetric-matrix similitude equation for both possible
multipliers, and compute the determinant square class of every nondegenerate solution. Verify the
resulting parity/type formula for small odd fields and several `m`, then formalize it. A direct
block-matrix/discriminant proof is preferred; use the equivalent Hermitian/Scharlau-transfer
formulation only if it materially shortens the determinant calculation. The result may be an
exclusion or an exact countercase, and C88 must report either.

Keep `Q⁻` conjectural until C88 determines the complete classification. The parabolic and
Hermitian Baer representative branches are closed paths; their proof details belong in the archive.
