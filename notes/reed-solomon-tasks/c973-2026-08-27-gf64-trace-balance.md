# C973 checkpoint — exact GF(64) trace balance

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** coefficient-space
abundance proved; split-quintic realization remains

## 1. Balance theorem

Retain the pointed GF(64) final-pair notation.  Fix `B1,B2,B3` and vary
`u=B0`.  Put

\[
 D=B_2^2+B_1B_3,
\]

and assume `B3 D != 0`.  Then exactly 32 values of `u in GF(64)` make the
quadratic

\[
 N_u(x)=n_2x^2+n_1x+n_0
\]

rootless, where

\[
 n_0=B_1^2+uB_2,\qquad
 n_1=B_1B_2+uB_3,\qquad
 n_2=D.                                                     \tag{1}
\]

More generally, over every field `GF(2^m)`, exactly `q/2` values work.

This proves exact half-density in the coefficient direction needed by the
GF(64) trace gate.  It is not a heuristic character-sum estimate and uses no
certificate.

## 2. Proof

Set

\[
                         v=n_1=B_1B_2+uB_3.
\]

Because `B3 != 0`, varying `u` makes `v` run bijectively through the field.
For `v != 0`, solve

\[
 u=(v+B_1B_2)/B_3.
\]

Substitution in (1) gives

\[
 n_0=\frac{B_2}{B_3}v+\frac{B_1D}{B_3}.
\]

The rootlessness trace is therefore

\[
 T(v)=\frac{Dn_0}{v^2}
 =\frac{DB_2/B_3}{v}+\frac{B_1D^2/B_3}{v^2}.              \tag{2}
\]

Let `s` be the unique square root of `B1/B3`.  Since absolute trace is
invariant under squaring,

\[
 \operatorname {Tr}T(v)
 =\operatorname {Tr}\left(
   \frac{D(B_2/B_3+s)}{v}\right).                          \tag{3}
\]

The numerator in (3) is nonzero.  Indeed, if
`B2/B3+s=0`, squaring gives `B2^2=B1B3`, contrary to `D!=0`.
Thus, as `v` ranges over the nonzero field elements, the argument of the trace
ranges over all nonzero field elements.  Exactly `q/2` field elements have
absolute trace one, and none of them is zero.  Hence exactly `q/2` admissible
values have `Tr(T)=1`.  By the quadratic criterion in the preceding checkpoint,
those and only those values make `N_u` rootless.

## 3. Structural consequence

The GF(64) problem no longer asks whether the desired trace value is rare.
On every chart with `B3D != 0`, it occupies exactly half of a full affine
coefficient line.  The remaining proof obligation is geometric:

> realize enough of this `B0`-line by completely split squarefree quintics,
> while retaining the C620 nondegeneracy selector.

There is an exact realization criterion.  Let

\[
 P(t)=p_0+p_1t+p_2t^2+p_3t^3+t^4
\]

be a split squarefree quartic with four nonzero roots, and put
`h_a(t)=(t+a)P(t)`.  Define

\[
 U_j=\sum_{i=3}^7z_i p_{i+j-4},\qquad 0\le j\le4,          \tag{4}
\]

with coefficients outside `0,...,4` zero.  Direct convolution gives

\[
                         B_j(a)=B_j(0)+aU_j.               \tag{5}
\]

Hence, if

\[
                 U_1=U_2=U_3=0,\qquad U_0\ne0,            \tag{6}
\]

the parameter `a` fixes `B1,B2,B3` and runs `B0` bijectively through the
field.  The balance theorem supplies exactly 32 rootless values.

The complete C620 selector restricted to `h_a` has degree at most 22 in `a`;
this already includes collision of `a` with the four roots of `P`.  Requiring
`a!=0` costs one further value.  Therefore

\[
                             32>22+1.                      \tag{7}
\]

If the restricted selector is nonzero, some rootless `a` gives five distinct
nonzero fixed roots and the nondegenerate genus-one slice.  The preceding
49-versus-48 theorem then supplies the pointed locator.

Conditions (6) are three homogeneous linear equations on the
five-dimensional binary-quartic space.  Their kernel has vector dimension at
least two: it is a projective quartic pencil (or a larger system), not an
isolated support search.  The remaining generic GF(64) gate is therefore:

> prove that this slope pencil contains a split squarefree quartic avoiding
> zero with `U0!=0`, and that the C620 selector is nonzero on its added-root
> line.

This is the correct place to reuse a binary-quartic splitting package.  It is
strictly smaller than the former five-root trace-selector problem and retains
the exact 32-versus-23 margin.

The nearest structured realization writes the five fixed roots as an affine
two-plane plus one point.  If

\[
 L_U(t)=t^4+At^2+Bt
\]

is the subspace polynomial of a two-dimensional `F2`-space and `C=L_U(b)` is
the nonzero value defining a coset disjoint from zero, then

\[
 h(t)=(t+a)(t^4+At^2+Bt+C)                                \tag{8}
\]

is automatically split with five distinct nonzero roots when the extra root
avoids that coset.  Its coefficients are

\[
 (g_0,g_1,g_2,g_3,g_4,g_5)
 =(aC,aB+C,aA+B,A,a,1).                                   \tag{9}
\]

Equations (8)--(9) give a four-parameter split chart on which the slope-pencil
conditions can be imposed explicitly.  The next proof should either:

1. solve the slope-pencil gate (6) directly; or
2. impose (6) inside the structured subfamily (8)--(9), if its linearized
   geometry makes quartic splitting transparent.

The degenerate chart `B3D=0` must be treated separately.  It includes the
endpoint syndrome `e7`, for which `B3=0`, `D=1`, and

\[
 \operatorname {Tr}T
 =\operatorname {Tr}\left(1+g_3/g_4^2\right)              \tag{10}
\]

when `g4!=0`.  This is already an explicit lower-dimensional trace problem,
not evidence for a new modular family.

## 4. Boundary

This checkpoint proves coefficient-space trace abundance only.  An arbitrary
coefficient quintic need not split, so the theorem does not yet close GF(64).
Conversely, a future proof must not discard the exact half-density by paying a
generic high-degree character-sum constant.  The split chart (4) or an
equivalent rational family should preserve it directly.

No computation, manuscript edit, or software edit supports this theorem.

## 5. `ej` + `tt` and mystery ledger

The `ej` pass converts rootlessness from an opaque trace condition into an
exact balanced affine direction.  The `tt` pass asks where that affine line
lives inside the split-quintic cover; composition-factor or dimension
arguments do not answer that arithmetic question.

| mystery | status | exact next gate |
|---|---|---|
| Is trace one sparse on the generic coefficient chart? | no; exact density `1/2` | theorem above |
| Can the trace function collapse to zero? | not when `B3D!=0`; the coefficient in (3) is forced nonzero | proved by squaring |
| Why is GF(64) numerically plausible? | 32 coefficient values are rootless before selector exclusions | preserve this balance on a split chart |
| How is the balanced `B0`-line realized by split quintics? | conditionally solved by the slope pencil (6) | prove that pencil has a suitable split quartic and nonzero restricted selector |
| Does the affine-plane-plus-one chart help? | possibly, as a structured subfamily of the slope pencil | impose (6) in (8)--(9) |
| What owns `B3D=0`? | same C973 proof, by explicit lower-dimensional charts beginning with (6) | stratified trace calculation |

Vibe: the trace obstruction is abundant, not exceptional; the last binary
difficulty is now precisely the compatibility between that balanced line and
complete splitting.
