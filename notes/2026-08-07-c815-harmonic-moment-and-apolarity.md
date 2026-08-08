# The Gaussian moment functional and the degree-six addition theorem in Lean

**Lane:** `clebsch`
**Date:** 2026-08-07

Two new Lean modules replace the analytic input of the harmonic realization
argument by polynomial algebra:

- `lean/RelativeConicArcs/SphericalMomentFunctional.lean`
- `lean/RelativeConicArcs/ZonalHarmonicDegreeSix.lean`

Both live in the `RelativeConicArcs` package. Neither is attached to a gate, and
no other Lean file was touched.

## Status

Both modules elaborate with no errors and no warnings. Every item of the design
spec is closed, including the orthogonal invariance that was flagged as possibly
expensive. There is no `sorry`, no `native_decide`, and no `decide`; the axiom
footprint is the Mathlib standard `propext`, `Classical.choice`, `Quot.sound`.

## Module one: `RelativeConicArcs.SphericalMomentFunctional`

Ambient ring `MvPolynomial (Fin 3) ℝ` throughout.

### Definitions and why they are shaped this way

`momentFactor : ℕ → ℝ` is the double factorial of the predecessor:
`momentFactor 0 = 1`, `momentFactor 1 = 0`,
`momentFactor (n + 2) = (n + 1) * momentFactor n`. Setting `momentFactor 1 = 0`
instead of the classical `0‼ = 1` is the device that removes every parity case
split downstream. The recursion propagates that zero through all odd arguments,
so `momentWeight` automatically annihilates a monomial with an odd exponent, and
the integration-by-parts step
`momentFactor_succ : momentFactor (n + 1) = n * momentFactor (n - 1)` holds
uniformly — at `n = 0` both sides are zero, which is exactly the case that would
otherwise need separate treatment. No lemma in either module distinguishes even
from odd exponents.

`momentWeight (a : Fin 3 →₀ ℕ) = ∏ i, momentFactor (a i)`.

`gaussianMoment : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ` is
`Finsupp.linearCombination ℝ momentWeight` composed with
`AddMonoidAlgebra.coeffLinearEquiv`. Building it that way rather than by hand
gives linearity for free. At the current Mathlib pin `MvPolynomial` is a type
synonym for `AddMonoidAlgebra` whose `coeff`/`ofCoeff` are identity functions,
but a hand-rolled `LinearMap` structure over `Finsupp.sum` fails to typecheck its
`map_smul'` field: the scalar action on `MvPolynomial` is not accepted where the
`Finsupp` one is expected, at `instances` transparency.

`normalizedMean d p = gaussianMoment p / momentFactor (d + 2)`, so the divisor is
`(d + 1)‼`. This is division in `ℝ`, so for odd `d` both `normalizedMean` and the
moment it normalizes vanish and the identity `normalizedMean_quadric_mul` still
holds with both sides zero.

`quadric = ∑ i, X i ^ 2`, `linearForm w = ∑ i, C (w i) * X i`,
`laplacian = ∑ i, pderiv i ∘ pderiv i` as an `ℝ`-linear endomorphism, and
`linearSubstitution M = aeval (fun j => linearForm (M j))` as an `ℝ`-algebra
endomorphism.

### Trust boundary

The module header states, and every docstring about `gaussianMoment` or
`normalizedMean` respects, that these are defined by the monomial formula alone.
The classical identification of `normalizedMean` with the normalized surface
integral over the unit two-sphere is not formalized here, is not used anywhere in
either module, and no theorem may be read as a statement about an integral.
Neither module imports measure theory.

### Theorems

All names below are in the namespace `RelativeConicArcs.SphericalMomentFunctional`.

| spec item | fully qualified name | statement |
|---|---|---|
| — | `momentFactor_succ` | `momentFactor (n + 1) = n * momentFactor (n - 1)` |
| — | `gaussianMoment_monomial` | `gaussianMoment (monomial a c) = c * momentWeight a` |
| — | `gaussianMoment_C` | `gaussianMoment (C c) = c` |
| — | `gaussianMoment_C_mul` | `gaussianMoment (C c * p) = c * gaussianMoment p` |
| 1 | `gaussianMoment_one` | `gaussianMoment 1 = 1` |
| 2 | `gaussianMoment_X_mul` | `gaussianMoment (X i * p) = gaussianMoment (pderiv i p)` |
| 3 | `eq_gaussianMoment_of_recursion` | `L 1 = 1` and `∀ i p, L (X i * p) = L (pderiv i p)` imply `L = gaussianMoment` for `L : MvPolynomial (Fin 3) ℝ →ₗ[ℝ] ℝ` |
| 4 | `pderiv_linearSubstitution` | `pderiv i (linearSubstitution M p) = ∑ j, C (M j i) * linearSubstitution M (pderiv j p)` |
| 4 | `gaussianMoment_comp_linearSubstitution` | rows of `M` orthonormal implies `gaussianMoment.comp (linearSubstitution M).toLinearMap = gaussianMoment` |
| 4 | `gaussianMoment_linearSubstitution` | the same, pointwise: `gaussianMoment (linearSubstitution M p) = gaussianMoment p` |
| 5 | `sum_gaussianMoment_X_mul_pderiv` | `p.IsHomogeneous d` implies `∑ i, gaussianMoment (X i * pderiv i p) = d * gaussianMoment p` |
| 6 | `gaussianMoment_quadric_mul` | `p.IsHomogeneous d` implies `gaussianMoment (quadric * p) = (d + 3) * gaussianMoment p` |
| 6 | `normalizedMean_quadric_mul` | `p.IsHomogeneous d` implies `normalizedMean (d + 2) (quadric * p) = normalizedMean d p` |
| 7 | `gaussianMoment_mul_of_isHomogeneous` | `p.IsHomogeneous d` implies `d * gaussianMoment (p * q) = gaussianMoment (laplacian p * q) + ∑ i, gaussianMoment (pderiv i p * pderiv i q)` |
| 8 | `isHomogeneous_pderiv` | `p.IsHomogeneous (d + 1)` implies `(pderiv i p).IsHomogeneous d` |
| 9a | `gaussianMoment_mul_eq_zero_of_laplacian_eq_zero` | for `p.IsHomogeneous d` with `laplacian p = 0`, every `e < d` and every `q.IsHomogeneous e`: `gaussianMoment (p * q) = 0` |
| 9b | `gaussianMoment_mul_linearForm_pow` | for `p.IsHomogeneous d` with `laplacian p = 0` and every `w : Fin 3 → ℝ`: `gaussianMoment (p * linearForm w ^ d) = d ! * eval w p` |

Supporting public lemmas: `momentFactor_zero`, `momentFactor_one`,
`momentFactor_add_two`, `momentWeight_zero`, `laplacian_apply`,
`pderiv_linearForm`, `pderiv_quadric`, `isHomogeneous_linearForm`,
`isHomogeneous_quadric`, `laplacian_pderiv` (the Laplacian commutes with each
`pderiv`), `linearSubstitution_X`. Private helpers: `momentWeight_single_add`,
`sum_sub_single_le`, `sum_sub_single_succ`, `pderiv_comm`.

The apolar clauses 9a and 9b are two independent inductions on `d`, not one
simultaneous induction: clause 9a at degree `d + 1` calls only 9a at `d`, and
clause 9b at degree `d + 1` calls only 9b at `d`. The spec's simultaneous
formulation is therefore not needed, and the two theorems are separate.

The general apolarity identity `N (p q) = p(∂) q` is not stated and not proved,
in either module, exactly as the scope note requires.

## Module two: `RelativeConicArcs.ZonalHarmonicDegreeSix`

Imports module one and nothing else. All names below are in the namespace
`RelativeConicArcs.ZonalHarmonicDegreeSix`.

### Definitions

`legendreSix (s : ℝ) = (231 * s ^ 6 - 315 * s ^ 4 + 105 * s ^ 2 - 5) / 16`.

`zonalHarmonic u = C (1 / 16) * (231 * linearForm u ^ 6
  - 315 * (linearForm u ^ 4 * quadric)
  + 105 * (linearForm u ^ 2 * quadric ^ 2) - 5 * quadric ^ 3)`.

The single rational constant is pulled out in front as `C (1 / 16)` and the four
integer coefficients are left as ring numerals inside. That shape is what makes
the harmonicity computation work: `ring` treats `C (231 / 16)` as an opaque atom
and cannot then verify the coefficient cancellations `231 * 30 = 315 * 22`,
`315 * 12 = 105 * 36`, `105 * 2 = 5 * 42`, whereas with plain numerals it does.
The `1 / 16` in front is removed once, by linearity of the Laplacian.

### Theorems

| spec item | fully qualified name | statement |
|---|---|---|
| 1 | `isHomogeneous_zonalHarmonic` | `(zonalHarmonic u).IsHomogeneous 6` |
| 2 | `eval_zonalHarmonic` | `∑ i, v i ^ 2 = 1` implies `eval v (zonalHarmonic u) = legendreSix (∑ i, u i * v i)` |
| 3 | `laplacian_zonalHarmonic` | `∑ i, u i ^ 2 = 1` implies `laplacian (zonalHarmonic u) = 0` |
| 4 | `gaussianMoment_zonalHarmonic_mul` | `∑ i, u i ^ 2 = 1` and `∑ i, v i ^ 2 = 1` imply `gaussianMoment (zonalHarmonic u * zonalHarmonic v) = 10395 * legendreSix (∑ i, u i * v i)` |
| 4 | `normalizedMean_zonalHarmonic_mul` | the same hypotheses imply `normalizedMean 12 (zonalHarmonic u * zonalHarmonic v) = legendreSix (∑ i, u i * v i) / 13` |

Private helpers: `pderiv_ofNat` (a derivation kills a numeral),
`pderiv_pderiv_zonal`, `laplacian_zonal_unscaled`, `mul_zonalHarmonic_expand`,
`gaussianMoment_ofNat_mul`, `gaussianMoment_quadric_mul_eq_zero`.

Harmonicity is organized differently from the spec's four separate Laplacian
computations. `pderiv_pderiv_zonal` computes the single second derivative along
one variable of the sixteenfold form and groups it by how each term depends on
the index: a factor `C (u i) ^ 2`, a factor `C (u i) * X i`, a factor `X i ^ 2`,
or no dependence. Summing over the three variables then replaces those four
groups by `1` (this is where `∑ i, u i ^ 2 = 1` enters, and only here),
`linearForm u`, `quadric` and the factor three, after which the coefficient
cancellation is a single `ring` call. This route needs one product-rule pass
rather than four and avoids a general Laplacian product rule altogether.

The addition theorem is proved by expanding the second factor and evaluating four
Gaussian moments. `gaussianMoment (quadric * p) = 0` whenever `p` is homogeneous
and its moment vanishes, so the three terms of the second factor carrying the
quadric die once `gaussianMoment (zonalHarmonic u * linearForm v ^ e) = 0` for
`e = 0, 2, 4`, each of which is lower-degree vanishing against a form of degree
below six. Stating the sphere relation in that vanishing form removes the need to
track the numeric factors `9`, `11`, `13` at all. The surviving term is
`231 / 16` times `gaussianMoment (zonalHarmonic u * linearForm v ^ 6)`, which is
`6 ! * eval v (zonalHarmonic u) = 720 * legendreSix (∑ i, u i * v i)` by apolar
evaluation, and `231 * 720 / 16 = 10395`. The normalized form divides by
`momentFactor 14 = 13‼ = 135135 = 13 * 10395`.

## Deviations from the design spec

1. **Spec item 8 already exists in Mathlib.** The spec states that no lemma
   asserting the homogeneity of a partial derivative is available. At this pin
   `MvPolynomial.IsHomogeneous.pderiv` gives
   `(pderiv i φ).IsHomogeneous (n - 1)` in
   `Mathlib/RingTheory/MvPolynomial/EulerIdentity.lean`. The module's
   `isHomogeneous_pderiv` specializes it to degree `d + 1` in one line rather
   than reproving it from the support characterization.
2. **The master identity does not need `q` homogeneous.** The spec states item 7
   with `q` homogeneous of degree `e`; the proof uses only Euler's identity for
   `p`, so `gaussianMoment_mul_of_isHomogeneous` quantifies over an arbitrary
   `q`. This is a strengthening, and both apolar clauses use it in that form.
3. **Orthogonal invariance is stated twice**, as an equality of linear maps
   (`gaussianMoment_comp_linearSubstitution`, the form that
   `eq_gaussianMoment_of_recursion` produces) and pointwise
   (`gaussianMoment_linearSubstitution`). Consumers will want the second.
4. **The apolar clauses are separate inductions**, not the simultaneous induction
   the spec describes; see above.
5. **Harmonicity is one grouped second-derivative lemma**, not four Laplacian
   computations plus a Laplacian product rule; see above.
6. `gaussianMoment` is built by composing Mathlib linear maps rather than as a
   hand-rolled `LinearMap` structure, for the typechecking reason recorded above.

## Elaboration evidence

Run from `/home/tavis/src/othello`. Both commands exit `0` with an empty log,
that is with no errors and no warnings.

```sh
lean/scripts/guarded-lean RelativeConicArcs/SphericalMomentFunctional.lean
lean/scripts/guarded-lean RelativeConicArcs/ZonalHarmonicDegreeSix.lean
```

Single-file elaboration of the second module requires a compiled artifact for
the first. An initial attempt to produce it reported
`built RelativeConicArcs.SphericalMomentFunctional` and then returned `refused`
from its closing quiet check, because a Lean build owned by another lane was live
in the shared tree at the time.

Both modules were subsequently built through Lake, after that other build
finished, with

```sh
lean/scripts/lean-build-queue.py build RelativeConicArcs.ZonalHarmonicDegreeSix --cores 20-23
```

which reported `state: success`, `built RelativeConicArcs.ZonalHarmonicDegreeSix`
and `gate-passed <aggregate>` in run directory
`~/.cache/othello-lean-build/run-20260808-032547-4af15fc0`. Neither module has
been added to any gate, so no paper gate build was run.

One docstring was corrected after that build and the first module re-elaborated
clean: the divisor `(d + 1)‼` of `normalizedMean` had been described as the
Gaussian moment of the degree-`d` power of a unit linear form, which is
`(d - 1)‼`. The two properties that do fix the divisor — that the constant one
has normalized mean one, and that `normalizedMean_quadric_mul` holds — replace
that sentence in both the module header and the definition's docstring.

The axiom footprint was checked by temporarily appending `#print axioms` lines to
the second module and elaborating it. Every one of
`gaussianMoment_zonalHarmonic_mul`, `normalizedMean_zonalHarmonic_mul`,
`laplacian_zonalHarmonic`, `gaussianMoment_linearSubstitution`,
`eq_gaussianMoment_of_recursion` and `gaussianMoment_mul_linearForm_pow` depends
on exactly `propext`, `Classical.choice`, `Quot.sound`. The `#print axioms` lines
were removed and both modules re-elaborated clean afterwards.

## What these two modules do and do not close

They close the analytic input of the harmonic rows: the moment functional, its
characterization, its orthogonal invariance, the sphere relation, the two apolar
clauses the manuscript's proof consumes, and the degree-six addition theorem in
the form `gaussianMoment (Z_u * Z_v) = 10395 * P_6(u · v)` and its normalized
quotient by thirteen.

They do not identify `normalizedMean` with the surface integral; that remains the
declared trust boundary and belongs in a module of its own. They do not construct
the Gram matrix of the ten face-axis zonal forms, the eigenvalues, or the
injectivity, and they do not touch the alternating comparison line or the cubic
restriction.
