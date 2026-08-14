# C907 — the safe `dP7` peak already has the dangerous spectral braid

Date: 2026-08-13

Status: exact negative result for the cheapest singular shadow.  Absence of
turning points, ambient--wall collisions, or spectral braids cannot prove the
Gold peak lemma: the smallest genuine carrier peak is rank-safe and nevertheless
has the minimal `A1` ambient--wall braid.

## 1. The safe peak and its mirror

Let

\[
 S=\operatorname{Bl}_{p_1,p_2}\mathbf P^2
\]

with the two blown-up torus fixed points exchanged by the coordinate
involution.  A fan is

\[
 (1,0),(0,1),(-1,0),(-1,-1),(0,-1).
\]

On the symmetric three-parameter slice, its toric Landau--Ginzburg potential
is

\[
 W(x,y)=x+y+\frac a x+\frac B{xy}+\frac a y .                  \tag{1}
\]

The coefficient `B` is the wall coordinate for the diagonal ray.  At `B=0`
the ray is deleted and (1) is the mirror of `P1 x P1`.  Thus one critical
point escapes at the wall while four finite critical points form the ambient
block.

The carrier-dressed fivefold `X x S` is already known to satisfy the desired
rank identity: the exact two-window matrix has

\[
 r_L T=r_R,
\]

and Iritani's weak-Fano toric Gamma/Orlov theorem identifies the analytic and
categorical decompositions.  See
`2026-08-13-c907-dp7-carrier-peak-rank-matrix.md`.

## 2. Exact critical-point calculation

The logarithmic critical equations are

\[
 x-\frac a x-\frac B{xy}=0,\qquad
 y-\frac a y-\frac B{xy}=0.                                  \tag{2}
\]

Subtracting them gives

\[
 (x-y)\left(1+\frac a{xy}\right)=0.                           \tag{3}
\]

There are therefore two branches.

On the diagonal `x=y`, equation (2) is

\[
 f(x)=x^3-ax-B=0,                                              \tag{4}
\]

and the corresponding critical value is

\[
 \lambda(x)=W(x,x)=3x+\frac a x.                              \tag{5}
\]

On the second branch `xy=-a`, the two critical points solve

\[
 x^2+\frac Ba x-a=0
\]

and both have critical value `-B/a`.

At `B=0`, the diagonal roots are `0,+sqrt(a),-sqrt(a)`.  The root at zero
leaves the algebraic torus and is the wall branch.  The other two diagonal
roots, together with the two `xy=-a` roots, are the four ambient critical
points of `P1 x P1`.

The diagonal discriminant is

\[
 \operatorname{disc}_x(f)=4a^3-27B^2.                         \tag{6}
\]

For `a>0`, at

\[
 B_+=\frac{2a^{3/2}}{3\sqrt3}
\]

the wall root continued from `x=0` collides with the ambient root continued
from `x=-sqrt(a)`, at

\[
 x=-\sqrt{a/3}.
\]

The collision is simple: `f=f'=0` and `f''=6x` is nonzero.  A small loop
around `B_+` exchanges the two roots.  Equation (5) sends them to two
critical values with the same square-root ramification, so this is exactly a
minimal `A1` turning point and an ambient--wall spectral transposition.

The other two critical points do not collide there: their common value is
`-B_+/a`, whereas the colliding diagonal value is `-2sqrt(3a)`.

## 3. Consequence for singular shadows

The rank-safe `dP7` peak therefore has every cheap singular feature which a
dangerous peak was expected to require:

1. a carrier-dressed mixed wall coefficient;
2. an ambient--wall collision;
3. a simple `A1` discriminant point;
4. a nontrivial transposition braid of leading exponential factors; and
5. a rank-one Picard--Lefschetz/Stokes direction.

Hence none of the following can be the desired structural obstruction:

- emptiness of the peak discriminant;
- triviality of the root braid;
- absence of ambient--wall collisions;
- the local Milnor number or ADE type;
- the rank/Jordan type of the local Picard--Lefschetz operator.

The safe and dangerous cases can differ only after the vanishing cycle is
**marked** in the output lattice.  In the safe model the aggregate correction
is the class of a boundary-supported window object (numerically a multiple of
the `(-1)`-curve class), so its common-open rank is zero.  The incomplete-Gamma
countermodel has the same rank-one unipotent shape but marks its target by an
ambient rank-visible vector.

Thus the next possible one-lemma shadow is already the required marked
statement:

> every ambient--wall vanishing cycle created at a carrier peak maps to zero
> in `K_0^num(S)/K_{0,D}^num(S)`.

This is not determined by the singularity germ.  It is a Gamma/window or
microlocal-output-support theorem.

## 4. EJ / TT / AA

- **EJ:** the minimal safe peak is also the minimal hostile regression for
  every proposed singular criterion.
- **TT:** discriminant topology detects where a Stokes anomaly can occur, but
  not which side of the Stokes root carries common-open rank.
- **AA:** compute the marked vanishing cycle, not another invariant of its
  unmarked `A1` germ.  The binary test is its image in the numerical
  common-open quotient.
