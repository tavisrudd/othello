# C907 residual `B=C=1` finite-Rees audit

**Lane:** `clebsch`

**Status:** exact local theorem for the finite residual Rees chart; the joint
`y`/Rees-infinity fan remains open.

## Setup

In the bounded `Z,U` chart put

\[
 y_i=\delta^{-p_i}x_i,\quad p=\sum_ip_i,\quad q=Q/X,
\]

\[
 B=1-\delta Z+\delta^{p+2}q,\qquad
 C=1-\delta U+\delta^{p+2}q.
\]

All statements are in the localized Laurent chart
`K[delta,x_i^(+-1),B^(+-1),C^(+-1),Z,U,L]`, equivalently after saturation
by `XBC`.

The finite `B=C=1` face has `p>-2`.  With

\[
 m=\max\{0,p_1,p_2,p_3,-p\},
\]

the exact saturated graph is

\[
\begin{aligned}
G=BC\big(&\delta^mL-\sum_i\delta^{m-p_i}x_i-\delta^mZU
+\delta^{m+p+1}q(Z+U)\\
&-\delta^{m+2p+2}q^2\big)-\delta^{m+p}q.
\end{aligned}
\tag{1}
\]

It has no `delta` factor, so its `delta`-saturation is itself.

## Noncompact `y` faces

For noncompact `y`, `m>0`, and the reduced central graph is

\[
 H=\sum_{p_i=m}x_i+\mathbf1_{-p=m}q=0.
\tag{2}
\]

All four terms cannot occur: that would imply `p_i=m` for all `i` and
`-p=m`, hence `4m=0`.  The actual supports are the 14 nonempty proper subsets
of `{x_1,x_2,x_3,q}`.  Four singletons are empty.  Every other support is
smooth/free: if `q` occurs, some `x_j` is absent and
`D_(x_j)H=-q` is a unit; if `q` is absent, an occurring `x_i` has unit
derivative.  The coordinates `L,Z,U` remain free and the recomputed
reduced-stratum Fitting ideal is `(1)`.

Thus the only possible four-term `y` circuit is excluded from every
noncompact finite-Rees face.

## Compact face

The equality `m=0` forces `p_1=p_2=p_3=0`.  Its exact graph is

\[
 E_0=L-\sum_ix_i-q-ZU.
\]

After torus saturation, the relative critical ideal is

\[
 (Z,U,x_i-q,q^4-Q,L-4q),
\tag{3}
\]

the four reduced residual Morse points.  The `ZU` block and the `f_Q` block
give the known double-suspension Hessian.  Hence the four-term circuit occurs
only as the marked compact residual core.

## Exact boundary

For `p<=-2`, bounded `Z,U` cannot absorb the `delta A` cancellation, so the
arc leaves this chart.  The imbalanced chart

\[
 F=S+A/(BC)+v-hA-r^2hAv+r^2h^2A^2
\]

has `F=f_Q+v` and `partial_vF=1` at `r=h=0`, but this does not classify
arbitrary joint `y`/Rees-infinity valuations.  A common translated-infinity
fan is still required.

## Compression

The finite `1/1` chart has no new discriminant circuit: noncompact faces are
simplex-free and the unique compact four-term circuit is exactly
`f_Q+ZU`.  The remaining algebraic frontier is therefore Rees infinity, not
the finite residual intersection.

## Mystery ledger

- **Settled:** all finite-Rees `B=C=1` faces for arbitrary `y` valuations.
- **Open:** joint `y`/Rees-infinity valuations, common normalization, and
  product collars.
