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

## Claim impact of the adversarial review

No Lean theorem or computed game outcome was removed or weakened. The review narrowed two prose
headlines to the proved scope:

- The parabolic and Hermitian rows exclude all linear involutions and the coordinate-Frobenius
  Baer case, not yet every semilinear involution.
- The categorical prose claim that every Baer involution fixes a board point was replaced by the
  formal coordinate theorem plus an explicit open conjugacy/descent obligation.
- The parabolic conclusion now says “no linear fixed-point-free involution” until C87 closes.
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

Close the remaining blockers in this order:

1. **General Baer-semilinear conjugacy (C87).** Normalize a representative `Aτ` with
   `A·τ(A)=cI` to a genuine semilinear involution using `τ(c)=c`, identification of the Frobenius
   fixed field, and finite-field norm surjectivity. Prefer a constructive descent proof over a
   cohomological import: for an involutive `τ`-semilinear map `S` and `β≠τ(β)`, both `v+S(v)` and
   `βv+S(βv)` are fixed, and the invertible two-by-two coefficient matrix shows that fixed vectors
   span the whole space over the extension field. Extract a basis of fixed vectors; its basis
   matrix conjugates `S` to coordinate Frobenius. Then apply the landed projective conjugacy
   transfer theorem. The main Lean API question is extracting a basis contained in a spanning set
   that is only a base-field subspace, not an extension-field submodule.
2. **Parabolic form descent (C87).** First formalize the semisimilitude version: after the preceding
   conjugacy, assume
   `Q(τv)=μ·τ(Q(v))`; applying it twice gives `Norm(μ)=1`, scalar Hilbert 90 normalizes `Q`, and
   its values on base-coordinate vectors descend to a base-field quadratic form. Feed that form to
   the landed descended-quadric intersection theorem. To recover the headline for the full
   projective board stabilizer, separately prove that a collineation preserving a nondegenerate
   parabolic zero locus is a semisimilitude. The recommended concrete proof is to put the form in a
   standard Witt basis and recover all coefficients from isotropic test vectors, avoiding a large
   algebraic-geometry dependency.
3. **Elliptic `Q⁻` transfer (C88).** Do not build the Lean proof around the desired negative verdict
   before checking the classification. Put a nonsplit representative in the standard
   `2×2` block form for multiplication by `√c`, solve the symmetric-matrix similitude equation for
   both possible multipliers, and compute the determinant square class of every nondegenerate
   solution. Verify the resulting parity/type formula for small odd fields and several `m`, then
   formalize it. A direct block-matrix/discriminant proof is preferred; use the equivalent
   Hermitian/Scharlau-transfer formulation only if it materially shortens the determinant
   calculation. The result may be an exclusion or an exact countercase, and C88 must report either.

Keep both full parabolic/Hermitian negative rows unpromoted until items 1–2 close, and keep `Q⁻`
conjectural until item 3 determines the complete classification.
