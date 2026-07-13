# Handoff: mirror-boundary formalization

**Date:** 2026-07-12
**Status:** IN PROGRESS
**Tasks:** C85–C86 [REPORTED 2026-07-12]; C87 [ACTIVE, AXIOM-BACKED]; C88 [OPEN]

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

No Lean theorem or computed game outcome was removed or weakened. The review narrowed two prose
headlines to the proved scope:

- The parabolic row excludes all linear involutions and the coordinate-Frobenius Baer case, not
  yet every semilinear board stabilizer. The Hermitian row now excludes every modeled
  square-scalar Baer-semilinear representative as well as every linear representative.
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
| every square-scalar relative-Frobenius semilinear representative is projectively conjugate to coordinate Frobenius | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87 partial) |
| every Hermitian board in vector dimension at least three meets every modeled Baer-semilinear projective involution | `ProjectiveCap/BaerSemilinear.lean` | Lean-proved (C87 partial) |
| scalar Hilbert-90 normalization and fixed-value quadratic-form descent | `ProjectiveCap/BaerQuadraticDescent.lean` | Lean-proved (C87 partial) |
| coordinate-Frobenius quadratic semisimilitude fixes a quadric point in dimension at least three | `ProjectiveCap/BaerQuadraticDescent.lean` | Lean-proved (C87 partial) |
| odd-characteristic nondegenerate quadric zero-locus stabilizer gives a semisimilitude | `ProjectiveCap/BaerQuadraticStabilizerAssumption.lean` | Imported literature axiom; not strict Lean-proved |
| coordinate-Frobenius zero-locus preservation rules out fixed-point-freeness | `ProjectiveCap/BaerQuadraticStabilizer.lean` | Conditional on the quarantined axiom |

Current source audit: no `sorry` or `native_decide`. The strict local lemmas retain axiom profile
`[propext, Classical.choice, Quot.sound]`; the two new conditional parabolic theorems additionally
depend on `exists_semisimilitudeMultiplier_of_preserves_zeroLocus`.

## Open work packages

| Task | Required theorem package | Depends on | Completion effect |
|---|---|---|---|
| **C87** | Discharge the quarantined parabolic stabilizer axiom. General square-scalar Baer conjugacy, scalar semisimilitude normalization, fixed-value quadratic descent, and the full Hermitian Baer representative branch are formal; the final zero-locus route is now packaged conditionally. | The coordinate obstruction and axiom-backed consequence are landed. A strict proof still needs zero-locus rigidity, most cheaply in a standard Witt model, plus transport from an arbitrary parabolic form. | Removes the imported axiom and promotes the parabolic semilinear branch to strict Lean-proved; the Hermitian representative branches are already complete. |
| **C88** | Classify elliptic-quadric-preserving involutions through the required Witt/Scharlau transfer, including split and nonsplit possibilities in all `m≥3`. | C85 quadratic infrastructure; C87 if semilinear elements are included in the final theorem. | Either proves the advertised `Q⁻` exclusion or records the exact countercase. Until then the claim is conjectural. |

## Dependency and attack order

C85–C86 are closed; their quadratic and Hermitian infrastructure is available to later tasks.
Proceed with **C87** by discharging the quarantined parabolic zero-locus-stabilizer axiom. The general
semilinear normal form, fixed-subgeometry conjugacy, Hermitian intersection, scalar normalization,
and coordinate quadratic-form descent are landed. Attempt C88 only after this bridge is complete.

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

1. **Parabolic stabilizer bridge (C87).** The literature theorem is quarantined as an axiom and its
   conditional consequence is formal. The cheap local route is coefficient rigidity for the
   standard Witt form `d z² + Σ xᵢyᵢ`: totally singular coordinate subspaces kill pure terms,
   mixed isotropic test vectors kill off-diagonal and `z`-linear terms, and two-pair cancellations
   equate the remaining diagonal coefficients. The expensive residue is transport: Mathlib has
   weighted-squares diagonalization but no located parabolic Witt-normal-form theorem. Either prove
   that normalization, or replace the coefficient route with a general polarity/tangent-hyperplane
   argument. Do not promote the row while the imported axiom remains in its printed profile.
2. **Elliptic `Q⁻` transfer (C88).** Do not build the Lean proof around the desired negative verdict
   before checking the classification. Put a nonsplit representative in the standard
   `2×2` block form for multiplication by `√c`, solve the symmetric-matrix similitude equation for
   both possible multipliers, and compute the determinant square class of every nondegenerate
   solution. Verify the resulting parity/type formula for small odd fields and several `m`, then
   formalize it. A direct block-matrix/discriminant proof is preferred; use the equivalent
   Hermitian/Scharlau-transfer formulation only if it materially shortens the determinant
   calculation. The result may be an exclusion or an exact countercase, and C88 must report either.

Keep the full parabolic negative row unpromoted until item 1 closes, and keep `Q⁻` conjectural until
item 2 determines the complete classification. The constructive conjugacy route and the full
Hermitian Baer representative branch are closed paths; their proof details belong in the archive.
