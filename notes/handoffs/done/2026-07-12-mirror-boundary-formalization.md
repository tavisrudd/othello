# Handoff: mirror-boundary formalization

**Date:** 2026-07-12
**Status:** COMPLETE
**Tasks:** C85–C88 [REPORTED 2026-07-12]

## Goal

Close the strict-trust boundary classification for fixed-point-free projective involutions on
classical polar-space cap boards. The final classification is positive for both even-dimensional
quadratic types and negative for the modeled parabolic and Hermitian branches.

The detailed mathematical statement and prose reductions live in
[`../../2026-07-09-mirror-method-boundary.md`](../../2026-07-09-mirror-method-boundary.md). This
handoff is the final execution map. Session history belongs in
[`2026-07-12-mirror-boundary-formalization-archive.md`](2026-07-12-mirror-boundary-formalization-archive.md).

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
- The hyperbolic `Q⁺` P theorem is unchanged. The conjectured elliptic `Q⁻` exclusion was false:
  a uniform nonsplit block mirror preserves a standard elliptic form in every even vector
  dimension. This adds a genuine elliptic P family; it does not affect the odd-`q` projective-plane
  conjecture.

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
| Chevalley–Warning produces a nonsquare-discriminant anisotropic tail compatible with the nonsplit block map | `ProjectiveCap/EllipticQuadricMirror.lean` | Lean-proved (C88) |
| the standard elliptic quadric in every even vector dimension has an fpf mirror and P cap game | `ProjectiveCap/EllipticQuadricMirror.lean` | Lean-proved (C88; coordinate-exact) |
| P/N transport for projectively equivalent sub-boards | `ProjectiveCap/EllipticQuadricMirror.lean` | Lean-proved (C88; supplied equivalence) |

Current source audit: no `sorry`, `native_decide`, or project axiom in the C87–C88 modules. Every
new load-bearing theorem has axiom profile exactly `[propext, Classical.choice, Quot.sound]`.

## Closed work packages

- C87 is closed by a coordinate-free null-cone rigidity proof.
- C88 is closed by an explicit counterfamily: hyperbolic pairs plus one anisotropic binary tail,
  all scaled by the same nonsplit block map. The coordinate theorem is strict; transport to any
  other presentation is strict once its projective linear equivalence is supplied.

## Dependency and attack order

C85–C88 are closed. Proof details and the overturned conjectural route are in the companion archive.

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

## Final boundary

For odd fields, the mirror method is positive on both standard even-dimensional orthogonal types:
hyperbolic `Q⁺` and elliptic `Q⁻`. The modeled parabolic and Hermitian branches are method-negative.
These method statements determine P only in the positive rows; the negative rows do not determine
the underlying game outcome.
