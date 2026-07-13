# Mirror-boundary formalization — archive

Append-only companion to
[`../2026-07-12-mirror-boundary-formalization.md`](../2026-07-12-mirror-boundary-formalization.md).
The live handoff holds current state; dated session notes, validation output, superseded plans, and
closed-negative proof routes belong here.

## 2026-07-12 — dedicated lane created

- Allocated C85–C88 for quadratic split isotropy, Hermitian linear classification,
  Baer-semilinear fixed-subgeometry intersection, and elliptic Witt/Scharlau transfer.
- Seeded the lane from the strict-gate audit landed in commit `091bae0`: the hyperbolic positive
  theorem is formal, the parabolic nonsplit linear obstruction is formal, and the common
  eigenline/fixed-point reduction is formal.
- Preserved the general elliptic `Q⁻(2m−1,q)`, `m≥3`, exclusion as conjectural pending C88.
- Routed `AGENTS.md`, the main projective-cap handoff, the detailed boundary specification, and the
  global task queue to the dedicated live handoff.

## 2026-07-12 — C85 reported

- Added `ProjectiveCap/FiniteQuadraticIsotropy.lean`. The reusable theorem
  `exists_ne_zero_quadraticForm_eq_zero` diagonalizes a finite odd-characteristic quadratic form
  and applies Mathlib's Chevalley–Warning theorem to its weighted sum-of-squares polynomial.
- Added the `±1` eigenspace complement and dimension argument in `MirrorBoundary.lean`, then closed
  the adversarial normalization gap: `hasFixedPointOn_quadric_of_sq_square_finrank_five` handles
  the actual projective representative hypothesis `g² = r²I`, proves scalar rescaling leaves its
  projectivization unchanged, and produces an isotropic fixed point.
- The load-bearing parabolic conclusion is
  `parabolic_split_scalar_square_route_not_fixedPointFree`. Together with the already-landed
  determinant-parity theorem, both linear parabolic branches are formal. The Baer-semilinear
  branch remains C87, so the full parabolic row is not yet promoted to Lean-proved.
- Validation:
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.FiniteQuadraticIsotropy` — PASS.
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap.MirrorBoundary` — PASS, clean.
  - `choom -n 1000 -- nix develop --command lake build ProjectiveCap` — PASS (`8656` jobs).
  - Axiom audit of the weighted-squares, general isotropy, eigenspace, normalized and scalar-square
    fixed-point, and parabolic theorems: exactly `[propext, Classical.choice, Quot.sound]`.
  - Source search over both affected files: no `sorry`, `native_decide`, or `axiom` declaration.
