# Codex C2 conic scaffold report (2026-07-07)

## Result

Added a new Lean module:

```text
lean/ProjectiveCap/ConicLocalization.lean
```

and imported it from:

```text
lean/ProjectiveCap.lean
```

The scaffold follows the statement decomposition in
`2026-07-07-kernel-conic-localization.md`: normalized conics through the two burned directions,
hyperbola normal form, the `q - 4` on-conic legal-extension count target, odd maximality target,
and the `psi_u` involution substrate.

Follow-up after WP-1/WP-2: the `psi_u` grid-symmetry part is no longer only a target.
`psi_gridSymmetry` proves that `psi_u` preserves residual `GridCap`, and
`psiInvolutionStatement` discharges the packaged `PsiInvolutionStatement`.  The
on-conic refinement is also connected to the existing odd-escape target by
`oddEscapeStatement_of_onConicEscapeStatement` and
`almostOddEscapeGameStatement_of_onConicEscapeStatement`.

The file contains no `sorry`, `admit`, or `axiom`. The high-level geometric facts are `Prop`
targets rather than asserted theorems. The coordinate facts for `psi_u` that are local algebra
are proved.

## Lean names

Namespace:

```text
ProjectiveCap.ConicLocalization
```

Core coordinate vocabulary:

```text
OnHyperbola
HyperbolaCells
NonzeroParams
mem_hyperbolaCells
mem_nonzeroParams
card_nonzeroParams
HyperbolaFits
BurnedDirectionConic
BurnedDirectionConic.OnAffine
BurnedDirectionConic.rho
BurnedDirectionConic.A
BurnedDirectionConic.B
BurnedDirectionConic.Nondegenerate
BurnedDirectionConic.onAffine_iff_onHyperbola
hyperbolaConic
```

High-level target statements:

```text
UniqueConicThroughFiveArcStatement
HyperbolaNormalFormStatement
OnConicLegalExtensions
mem_onConicLegalExtensions
OnConicLegalExtensionCountStatement
MaximalGridCap
OddHyperbolaMaximalStatement
PsiInvolutionStatement
OnConicEscapeStatement
```

`psi_u` substrate:

```text
hyperbolaParamPoint
hyperbolaParamPoint_injective
hyperbolaParamPoint_onHyperbola
onHyperbola_first_ne_rho
onHyperbola_second_ne_A
onHyperbola_eq_hyperbolaParamPoint
onHyperbola_iff_exists_param
hyperbolaCells_eq_image_nonzeroParams
card_hyperbolaCells
rowSparse_hyperbolaCells
colSparse_hyperbolaCells
partialPermutation_hyperbolaCells
not_collinear_hyperbolaParamPoint
affineCap_hyperbolaCells
gridCap_hyperbolaCells
gridCap_hyperbolaCells_and_card
onConicLegalExtensionCountStatement
hyperbola_center_secant_collinear
maximalGridCap_hyperbolaCells_of_two_ne_zero
oddHyperbolaMaximalStatement
psi
psi_involutive
psi_onHyperbola_iff
psi_hyperbolaParamPoint
GridSymmetry
psi_bijective
psi_first_eq_iff
psi_second_eq_iff
collinear_psi_iff
rowSparse_image_psi
colSparse_image_psi
affineCap_image_psi
gridCap_image_psi
gridCap_image_psi_iff
psi_gridSymmetry
psiInvolutionStatement
oddEscapeStatement_of_onConicEscapeStatement
almostOddEscapeGameStatement_of_onConicEscapeStatement
```

## What is proved now

The following are sorry-free Lean theorems:

- `mem_hyperbolaCells`: membership in `HyperbolaCells` is exactly `OnHyperbola`.
- `BurnedDirectionConic.onAffine_iff_onHyperbola`: the normalized burned-direction conic chart is
  equivalent to the hyperbola normal form with `rho = -zeta`, `A = -eps`, `B = zeta*eps - gamma`.
- `mem_onConicLegalExtensions`: membership in `OnConicLegalExtensions` is exactly on-hyperbola
  plus legal grid extension.
- `onHyperbola_iff_exists_param`: for `B != 0`, the hyperbola is exactly the image of the
  nonzero-parameter map `t |-> (rho + t, A + B/t)`.
- `card_hyperbolaCells`: for `B != 0`, `HyperbolaCells` has cardinality `Fintype.card K - 1`.
- `partialPermutation_hyperbolaCells`: for `B != 0`, the hyperbola cell set has at most one
  point in each row and column.
- `gridCap_hyperbolaCells_and_card`: for `B != 0`, the hyperbola cell set is a residual
  `GridCap` and has cardinality `Fintype.card K - 1`.
- `onConicLegalExtensionCountStatement`: every non-seed hyperbola cell is a legal extension of
  the fitted size-three seed, and there are exactly `Fintype.card K - 4` such cells.
- `oddHyperbolaMaximalStatement`: in odd characteristic, the hyperbola cell set is maximal and
  has cardinality `Fintype.card K - 1`.
- `psi_involutive`: if `B != 0` and `u != 0`, then `psi rho A B u` is involutive.
- `psi_onHyperbola_iff`: under the same nonzero hypotheses, `psi_u` preserves the hyperbola.
- `psi_hyperbolaParamPoint`: on parametrized conic points, `psi_u` acts as `t |-> u / t`.
- `psi_gridSymmetry`: under the same nonzero hypotheses, `psi_u` is a residual-grid symmetry:
  it is bijective and preserves `GridCap` under finite-set image.
- `psiInvolutionStatement`: the full packaged `PsiInvolutionStatement` is proved.
- `oddEscapeStatement_of_onConicEscapeStatement`: the on-conic witness refinement implies
  `GridGame.OddEscapeStatement`.
- `almostOddEscapeGameStatement_of_onConicEscapeStatement`: the same implication in the
  `Almost.OddEscapeGameStatement` spelling.

## What is only stated

The following are statement-level targets:

- `UniqueConicThroughFiveArcStatement`: unique nondegenerate conic through the size-three grid
  seed plus burned directions, encoded in the normalized burned-direction chart.
- `HyperbolaNormalFormStatement`: unique `(rho, A, B)` with `B != 0` fitting the size-three seed.
- `OnConicEscapeStatement`: the empirical ON target, tied to the formal residual grid-game
  `GridGame.IsP` predicate.

## Deferred vocabulary

This scaffold does not yet formalize projective conics as projective quadratic forms. Instead,
`BurnedDirectionConic` is the normalized chart for conics through the two burned directions:

```text
r*c + eps*r + zeta*c + gamma = 0
```

That is enough to name the conic-localization targets and the hyperbola normal form, but the
eventual proof of "unique conic through the 5-arc" still needs either:

- a real projective conic object and a theorem connecting it to this normalized chart; or
- a self-contained coordinate proof that every relevant conic through the burned directions is
  represented by this chart and that the excluded `delta = 0` case is degenerate/collinear.

The grid-symmetry part of `psi_u` is now proved. The proof shows that `psi_u` exchanges row and
column equalities and transports affine collinearity by the nonzero determinant factor `B*u`.

## Verification

Command:

```bash
LEAN_NUM_THREADS=1 nix develop --command lake build ProjectiveCap.ConicLocalization
```

Output:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2984/2986] Built ProjectiveCap.GridGame (4.9s)
✔ [2985/2986] Built ProjectiveCap.GridCounting (4.5s)
✔ [2986/2986] Built ProjectiveCap.ConicLocalization (3.1s)
Build completed successfully (2986 jobs).
```

Command:

```bash
LEAN_NUM_THREADS=1 nix develop --command lake build ProjectiveCap
```

Output:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [2992/2998] Built ProjectiveCap.PlaneTransitivity (21s)
✔ [2994/2998] Built ProjectiveCap.Almost.OddEscape (3.4s)
✔ [2996/3004] Built ProjectiveCap.ExtensionCount (6.9s)
✔ [2998/3004] Built ProjectiveCap.EscapeParity (2.9s)
✔ [3002/3004] Built CapGame.Affine (3.2s)
✔ [3003/3004] Built ProjectiveCap (2.7s)
Build completed successfully (3004 jobs).
```

Command:

```bash
rg -n "sorry|axiom|admit" lean/ProjectiveCap/ConicLocalization.lean || true
```

Output:

```text
```

Follow-up verification after proving `psi_gridSymmetry` / `psiInvolutionStatement`:

```bash
nix develop --command lake build ProjectiveCap
```

Output:

```text
warning: Git tree '/home/tavis/src/othello' is dirty
✔ [3004/3006] Built ProjectiveCap.ConicLocalization (3.0s)
✔ [3005/3006] Built ProjectiveCap (2.3s)
Build completed successfully (3006 jobs).
```
