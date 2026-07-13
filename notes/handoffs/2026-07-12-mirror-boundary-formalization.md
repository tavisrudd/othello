# Handoff: mirror-boundary formalization

**Date:** 2026-07-12
**Status:** IN PROGRESS
**Tasks:** C85–C86 [REPORTED 2026-07-12]; C87 [ACTIVE, PARTIAL]; C88 [OPEN]

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
| quadratic-extension norm surjectivity and square reflection | `ProjectiveCap/FiniteHermitian.lean` | Lean-proved (C86) |
| finite Hermitian forms in dimension at least two are isotropic | `ProjectiveCap/FiniteHermitian.lean` | Lean-proved (C86) |
| Hermitian split scalar-square route is not fixed-point-free | `ProjectiveCap/MirrorBoundary.lean` | Lean-proved (C86) |
| Hermitian nonsplit similitude scalar is impossible | `ProjectiveCap/FiniteHermitian.lean`, `ProjectiveCap/MirrorBoundary.lean` | Lean-proved (C86) |
| coordinate relative Frobenius induces a projective involution fixing every base-coordinate point | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87 partial) |
| descended parabolic quadratic form meets the coordinate-Frobenius fixed subgeometry | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87 partial; descent is an explicit hypothesis) |
| every Hermitian form in vector dimension at least three meets the coordinate-Frobenius fixed subgeometry | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87 partial; base quadratic restriction constructed internally) |
| board fixed points transfer through a supplied projective conjugacy | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87 partial) |

Current source audit: no `sorry` or `native_decide`; the relevant builds pass with axiom profile
`[propext, Classical.choice, Quot.sound]`.

## Open work packages

| Task | Required theorem package | Depends on | Completion effect |
|---|---|---|---|
| **C87** | Finish the general Baer-semilinear reduction. The coordinate-Frobenius involution, its fixed base-coordinate points, both tractable board intersections, and conjugacy transfer are formal. Remaining: prove nonabelian finite-field descent for `Aτ` with `(Aτ)²` projectively scalar, then descend a preserved parabolic zero locus to the fixed field. | Requires a `GL_n/PGL_n` Hilbert-90 theorem absent from pinned Mathlib; scalar Hilbert 90 alone is insufficient. The parabolic form descent/normalization is a second explicit theorem after conjugacy. | Closes the semilinear branches and completes the parabolic/Hermitian method-negative rows. |
| **C88** | Classify elliptic-quadric-preserving involutions through the required Witt/Scharlau transfer, including split and nonsplit possibilities in all `m≥3`. | C85 quadratic infrastructure; C87 if semilinear elements are included in the final theorem. | Either proves the advertised `Q⁻` exclusion or records the exact countercase. Until then the claim is conjectural. |

## Dependency and attack order

C85–C86 are closed; their quadratic and Hermitian infrastructure is available to later tasks.
Proceed with **C87** at the two remaining descent lemmas: first prove the nonabelian normal form for
an order-two projective semilinear map over a quadratic finite-field extension; then show that a
preserved parabolic quadric becomes a base-field quadratic zero locus in those coordinates. The
Hermitian coordinate intersection and the final conjugacy-transfer interface are already landed.
Attempt C88 only after this reusable semilinear infrastructure is complete.

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

Develop a matrix-level nonabelian Hilbert-90 lemma: from `A · τ(A) = cI`, first prove `τ(c)=c`,
normalize `c` using finite-field norm surjectivity, and then construct `B` with the normalized
cocycle `A' = B⁻¹τ(B)` (up to the chosen convention). Lift this to projective conjugacy and use the
existing transfer theorem. Keep both full negative rows unpromoted until the parabolic form-descent
lemma is also formal.
