# C907 — a Stokes anomaly requires a spectral braid

Date: 2026-08-13

Status: exact reduction on every convergent nonturning parameter domain.  It
does not compute the peak discriminant.

## 1. No coefficientwise birth of a Stokes multiplier

The quantum connection is jointly flat in `z`, Novikov, and bulk directions.
On an analytic parameter domain where the leading eigenvalues remain in a
fixed nonturning configuration, the `z`-connection is an isomonodromic
deformation.  Its Stokes filtration and Stokes matrices are locally constant
after the exponential labels and a nonsingular direction are fixed.

Therefore a relative Stokes coefficient which is zero on a one-wall face
cannot become nonzero merely because a mixed formal series

\[
 \sum_{n\ge0}a_n Q^{\beta_0+n\delta}                              \tag{1}
\]

is turned on.  A failure requires that the continuation between the two
receivers leave the original nonturning chamber.

> **Spectral-braid necessity lemma.**  Every failure of the rank-zero-target
> Stokes lemma determines a nontrivial braid of leading exponential factors
> around the peak discriminant, involving an ambient rank-visible branch.

This is a necessary shadow, not a claim that every such braid has nonzero
Stokes coefficient.

## 2. The finite algebraic shadow

Fix a one-dimensional analytic slice through the peak parameter torus and
write the leading characteristic polynomial as

\[
 P(\lambda;t)=\det(\lambda-c_1(Y)\star_t).                       \tag{2}
\]

Let

\[
 \Delta(t)=\operatorname{disc}_\lambda P(\lambda;t).             \tag{3}
\]

The two incident receiver cusps label subsets of roots as ambient and wall
branches.  A dangerous transition needs a path in `Delta!=0` whose root
braid moves a wall/relative branch past an ambient primitive-sixth branch in
the orientation which makes the ambient branch the shear target.

Thus the cheap regression is:

1. compute `P` or only the relevant resultant between the ambient and wall
   factors;
2. compute the winding/braid of those roots along a chamber-connecting path;
3. discard the model if the ambient cluster is unbraided or if every crossing
   is oriented toward a wall branch.

No Mellin--Barnes coefficient is needed unless this braid shadow survives.

## 3. Combination with pure-neutral invisibility

For a pure neutral variable, the divisor equation gives zero contribution to
`c1 star`; hence `P` and `Delta` are independent of that variable.  Its braid
shadow is trivial.  Only a carrier-dressed tower `beta_0+n delta` can alter
(2), because `c1.beta_0` is nonzero.

The surviving object is therefore forced to have both:

- a mixed carrier coefficient in the leading spectral polynomial; and
- nontrivial discriminant monodromy involving a rank-visible ambient root.

This is substantially rarer than a nonzero neutral hypergeometric series.

## 4. Exact boundary

The lemma applies after an analytic realization has been chosen on a
convergent parameter slice.  It does not create a map between incompatible
formal Novikov completions and does not identify the two cusp-normalized
frames.  Instead it says that any discrepancy between their continuations is
carried by a concrete braid in the common analytic discriminant complement.

At a confluence point the eigenvalue labels can collide and the statement
must be phrased using nearby cycles.  This is precisely where the braid is
born; confluence is not silently treated as an ordinary nonturning point.

## EJ / TT / AA

- **EJ:** a dangerous rubber coefficient must leave a visible braid in the
  leading spectrum.
- **TT:** flatness gives local constancy, not global path independence; the
  discriminant-complement braid is the remaining monodromy.
- **AA:** compute the peak resultant/braid before any Stokes multiplier.
