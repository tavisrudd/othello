# C907 — pure neutral towers are spectrally invisible

Date: 2026-08-13

Status: exact structural vanishing.  A pure `c1`-neutral tower cannot modify
the irregular leading operator of the small quantum connection and therefore
cannot by itself create the dangerous Stokes shear.

## 1. Divisor-equation vanishing

The small quantum `z`-connection has irregular leading term

\[
 \nabla_{z\partial_z}
 =z\partial_z+\mu-\frac{c_1(Y)\star}{z}.                          \tag{1}
\]

For every nonzero effective curve class `gamma`, the divisor equation gives

\[
 \langle c_1(Y),a,b\rangle_{0,3,\gamma}
 =(c_1(Y)\cdot\gamma)\,
   \langle a,b\rangle_{0,2,\gamma}.                              \tag{2}
\]

Consequently, if `c1(Y).gamma=0`, the entire `gamma` coefficient of
`c1(Y) star` vanishes.  The same holds for every multiple `n gamma`.

> **Pure-neutral spectral-invisibility lemma.**  An effective tower
> `n delta`, `n>=1`, with `c1(Y).delta=0` contributes nothing to the
> irregular leading operator `c1(Y) star` of the small quantum connection.

It follows that a pure neutral tower cannot create a new `z`-exponential
factor, move an eigenvalue of the leading operator, or create a turning wall
on its own.  A nonconstant neutral GKZ or descendant calibration is not a
counterexample: it lives in regular/parameter-direction data, not in the
coefficient of (1).

On any analytic nonturning domain where the joint quantum connection gives
the usual isomonodromic parameter deformation, its Stokes matrices are
locally constant.  Since the pure-neutral variable leaves the complete
leading operator in (1) unchanged, it introduces no turning locus; the
relative Stokes multiplier therefore stays at its value on the zero-neutral
axis.  This last sentence uses the analytic/isomonodromic realization.  The
coefficientwise vanishing of `c1 star` itself is formal and unconditional.

## 2. Exact surviving loophole

The lemma does not kill the affine carrier tower

\[
 \beta_n=\beta_0+n\delta,
 \qquad c_1(Y)\cdot\delta=0,                                    \tag{3}
\]

because

\[
 c_1(Y)\cdot\beta_n=c_1(Y)\cdot\beta_0                          \tag{4}
\]

can be nonzero.  Equation (2) then supplies the same nonzero divisor factor
for every `n`, and the infinite neutral tail can dress a fixed off-boundary
carrier coefficient of `c1 star`.

Thus every dangerous object must contain an off-boundary carrier.  A pure
boundary neutral propagator, however complicated its regular-singular
hypergeometric series, is spectrally incapable of producing Gold's
ambient-to-ambient Stokes anomaly.

## 3. Relation to the rank-zero-target lemma

This proves one large case of
`2026-08-13-c907-rank-zero-target-stokes-lemma.md`: pure neutral corrections
have no new irregular target at all, while their categorical states remain
boundary-supported and rank zero.  The only unproved case is a carrier-dressed
neutral tower whose mixed invariants alter an already ambient irregular
block.  For that case one must still show that every *relative* Stokes jump
has boundary-supported target.

## EJ / TT / AA

- **EJ:** `c1`-neutral means spectrally invisible for the small `z`-connection,
  by the divisor equation—not merely degree-zero by heuristic grading.
- **TT:** this does not apply termwise to `beta_0+n delta` when
  `c1.beta_0` is nonzero.  Distinguish the unconditional divisor-equation
  vanishing from the standard nonturning-isomonodromy step used to phrase it
  as Stokes constancy.
- **AA:** discard every candidate consisting only of neutral boundary
  classes.  Search exclusively for mixed carrier coefficients of `c1 star`.
