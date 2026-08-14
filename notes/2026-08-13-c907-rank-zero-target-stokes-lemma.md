# C907 — the rank-zero-target Stokes lemma

Date: 2026-08-13

Status: single-lemma Gold target; not proved.  This is the weakest clean
support statement which kills every dangerous neutral propagator at once.

## 1. Setup

Let `Y` be an intermediate smooth projective fivefold, let `D` be the union
of the exceptional/toroidal strata for two incident unit walls, and choose a
point `p` in the common open `U=Y\D`.  Let `T` be the sectorial transition
between the two incident wall receivers on a common analytic fibre.  The
Gamma point row is

\[
 r_p(x)=[x,s(\mathcal O_p))=\chi(x,\mathcal O_p)                 \tag{1}
\]

with the pairing orientation fixed as displayed.

The minimal assertion needed for Gold is not `T` equal to a window functor.
It is only

\[
 r_p(T-1)=0\quad\hbox{on the primitive-sixth packet}.             \tag{2}
\]

## 2. Rank-zero-target formulation

Suppose the relative transition can be factored into elementary Stokes
shears

\[
 T=\prod_{a=1}^m(1+v_a\otimes\lambda_a)                          \tag{3}
\]

such that every target vector `v_a` belongs to the sectorial Gamma span of
objects supported on `D`.  Then

\[
 r_p(v_a)=\chi(v_a,\mathcal O_p)=0                               \tag{4}
\]

by disjoint support.  Therefore `r_p(1+v_a tensor lambda_a)=r_p` for every
factor and hence

\[
 \boxed{r_pT=r_p.}                                                \tag{5}
\]

This proves the Gold Boolean without knowing any Stokes coefficient, source
covector, neutral curve class, or ordering inside the supported span.

> **Rank-zero-target Stokes lemma.**  Every elementary shear in the relative
> transition between two incident unit-wall receivers has target in the
> boundary-supported Gamma span.

This is the sharpest singular shadow: only the image of each rank-one jump
is constrained.  The source of the jump may be ambient and the coefficients
may be arbitrary.

### One-sided kernel-support shadow

If the relative transition admits a kernel description `K_T` on `Y times Y`
and a comparison with the diagonal kernel, write `K_rel` for the cone (or,
at the numerical level, the difference class).  The exact geometric
condition is one-sided:

\[
 \operatorname{Supp}(K_{\mathrm{rel}})
 \subset Y\times D,                                               \tag{6}
\]

where the second factor is the output convention.  Condition (6) allows the
source projection to dominate all of `Y`; it says only that every correction
lands on the boundary.  It therefore implies the rank-zero-target lemma but
does not forbid ambient inputs or mixed carrier invariants.

This is more precise than saying that the transition is "supported near the
wall."  Support in `D times Y` would constrain the source and would not by
itself preserve the rank row.  The **target projection** is load-bearing.
For an enhanced or microlocal Riemann--Hilbert construction, the corresponding
test is that every relative vanishing-cycle microsupport component projects
to `D` on its output side.

## 3. Equivalent stronger forms

Each of the following implies the lemma, but asks for more.

1. **Factorization:** `T-1` factors through a supported solution object
   `Sol_D(Y)`.
2. **Numerical quotient:** `T` is the identity on
   `K_0^num(Y)/K_{0,D}^num(Y)` under the Gamma comparison.
3. **Common-open restriction:** a localizing sectorial realization exists and
   satisfies `j^*T=id` for `j:U->Y`.
4. **Window comparison:** the relative Stokes transition and the algebraic
   grade-restriction-window transition have the same numerical rank row.
5. **One-sided kernel support:** the relative kernel satisfies (6).

The common-open formula is presently a slogan unless the restriction
functor on the analytic quantum/Stokes realization is actually constructed.
Ordinary quantum cohomology is not localizing for open complements.  The
safe theorem statement is therefore the rank-zero-target version (or the
explicit factorization through a supported sectorial span), not a bare
`j^*T=id` assertion.

## 4. Why existing one-wall results nearly have this shape

For one smooth simple VGIT wall, the Shen--Shoemaker sector ordering and
Gamma/Euler orthogonality identify the wall branches with supported
Fourier--Mukai classes and annihilate them under `r_p`.  Gu--Yu--Yu gives the
exact ambient point coordinate.  Thus every wall-local correction visible in
that oriented receiver has a rank-zero wall target.

The missing step is only **two-wall orientation/coherence**: when passing
between the two incident receivers, prove that the elementary rays crossed
can still be ordered so that their targets remain wall branches.  A reversal
which makes an ambient branch the target is precisely the dangerous shear.

This gives three bounded proof routes:

1. prove a common phase corridor in which all crossed relative rays point
   toward wall branches;
2. realize the relative Stokes group by unstable-stratum thimbles and show
   their Gamma classes lie in `K_D(Y)`;
3. compare only the image row of the two Mellin--Barnes orders, showing that
   their difference is spanned by wall columns.

The first route has an exact necessary shadow: by joint flatness, a failure
must carry a nontrivial braid of the leading spectral roots around the peak
discriminant.  See
`2026-08-13-c907-stokes-anomaly-requires-spectral-braid.md`.  A model whose
ambient cluster has trivial braid satisfies the target lemma without a
multiplier computation.

None requires a full equality of Stokes and window matrices.

## 5. Relation to the shadow sieve

The cone, incidence, primary-moment, and turning shadows are now fallback
ways to prove the rank-zero-target lemma model by model.  They are not
additional hypotheses once the lemma holds.  Conversely, a counterexample
must exhibit one elementary Stokes factor in (3) whose target has nonzero
rank.  That single target vector is the minimal falsifier.

The C908 theta lattice can constrain such a vector only after a comparison
places the same elementary Stokes factor on its integral lattice.  Without
that bridge, its saturation and mod-two shadows do not prove (4).

## EJ / TT / AA

- **EJ:** Gold needs only that relative Stokes shears point *into* supported
  branches; their coefficients and sources are irrelevant.
- **TT:** do not write `j^*T=id` as an established quantum-localization fact.
  Use the rank-zero-target statement until a localizing sectorial realization
  is constructed.
- **AA:** the next regression is the smallest adjacent unit-circuit model:
  list the elementary crossed rays and inspect only their target columns.
