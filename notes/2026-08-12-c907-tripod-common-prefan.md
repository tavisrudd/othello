# C907 pair-of-pants support cone complex

**Lane:** `clebsch`

**Status:** exact support-level construction of a finite rational polyhedral
complex for all ten coordinate-orbit types, with deterministic replay.  This
is not a toric fan in the original $(B,C)$ torus and does not identify
normalized graph or reduced-stratum Fitting ideals on overlaps.

## Why an ordinary toric fan cannot work

The translated divisors $B=1$ and $C=1$ lie inside the original
$(\mathbf G_m)^2$ torus.  A toric modification is an isomorphism on that
torus, so no cone of a fan in the original $(B,C)$ cocharacter lattice can
create the charts governed by $v(1-B)>0$ or $v(1-C)>0$.  In dimension one,
blowing up the Cartier divisor $B=1$ is itself trivial.  Thus the common
object required by C907 cannot literally be the ``one toric fan'' suggested
in earlier working notes.

The minimal repair is logarithmic.  Adjoin

\[
U=1-B,\qquad V=1-C
\tag{1}
\]

and retain the pair-of-pants equations

\[
B+U=1,\qquad C+V=1.
\tag{2}
\]

The residual ideal $(\delta,U,V)$ and its normalized Rees charts are marked
inside this augmented model from the outset.

## Product-of-tripods skeleton

The tropicalization of $B+U=1$ is the tripod $T_B$ with central generic
vertex $g$ and primitive rays

\[
\rho_0=(1,0),\qquad
\rho_1=(0,1),\qquad
\rho_\infty=(-1,-1)
\tag{3}
\]

in the valuation coordinates $(v(B),v(U))$.  The same construction gives
$T_C$.  Hence the finite boundary skeleton is

\[
T_B\times T_C.
\tag{4}
\]

It has the sixteen ordered strata in $\{g,0,1,\infty\}^2$; modulo
$B\leftrightarrow C$ these are exactly the ten types in
`2026-08-12-c907-local-boundary-orbit-atlas-closeout.md`.

## One universal support subdivision

Let $t=v(\delta)>0$, put

\[
r_B=v(B),\quad s_B=v(U),\quad
r_C=v(C),\quad s_C=v(V),
\]

and write $y_i=\delta^{-p_i/t}x_i$, $p=p_1+p_2+p_3$.  For the bounded graph

\[
F_\delta=\sum_i y_i+\frac Q{YBC}+\delta^{-2}(1-B)(1-C),
\tag{5}
\]

the six universal normalization weights are

\[
0,\quad p_1,\quad p_2,\quad p_3,\quad
-p+r_B+r_C,\quad 2t-s_B-s_C.
\tag{6}
\]

On each cone of $T_B\times T_C$, refine by every pairwise equality among
the forms (6), together with the corresponding weak inequalities.  Equivalently,
intersect the complete hyperplane fan of (6) with

\[
\{t\ge0\}\times T_B\times T_C
\tag{7}
\]

and then take the slice $t=1$.  This produces a finite rational polyhedral
cone complex $\Sigma_{\rm supp}$.

Restricting (6) to the tripod rays recovers every normalization index in the
ten local reports.  For example,

\[
\begin{array}{c|c}
(B,C)\text{ type}&m\\ \hline
(0,0)&\max\{2,p_i,\beta+\gamma-p\}\\
(1,0)&\max\{0,p_i,\gamma-p,2-\beta\}\\
(0,\infty)&\max\{\gamma+2,p_i,\beta-\gamma-p\}\\
(1,\infty)&\max\{0,p_i,-p-\gamma,2+\gamma-\beta\}\\
(1,1)&\max\{0,p_i,-p,2-\beta-\gamma\}\\
(\infty,\infty)&\max\{\beta+\gamma+2,p_i,-p-\beta-\gamma\}.
\end{array}
\tag{8}
\]

The other four types are the corresponding one-ray or central restrictions.
Thus the individual max formulas are restrictions of one universal
piecewise-linear function, rather than unrelated casework.

## Exact adjacency and support compatibility

Modulo $B,C$ exchange, the Hasse adjacency is

\[
\begin{array}{c|c}
(g,g)&(0,g),(1,g),(\infty,g)\\
(0,g)&(0,0),(0,1),(0,\infty)\\
(1,g)&(0,1),(1,1),(1,\infty)\\
(\infty,g)&(0,\infty),(1,\infty),(\infty,\infty).
\end{array}
\tag{9}
\]

Every face specialization is obtained by setting the relevant tripod ray
parameter to zero in (6).  Hence $\Sigma_{\rm supp}$ supplies a complete
finite support subdivision across all twelve adjacency edges.

This compatibility stops at the support level.  For example, on a generic
finite chart the coefficient $(1-b)(1-c)$ retains residue information that
is lost on the $0$ ray.  Equality of maximum sets therefore does not imply
equality of saturated graph closures.  The nonmonomial dense transitions

\[
\delta^a b_0+\delta^b b_1=1,qquad
b_\infty=\delta^{a+b}b_0,qquad
b_\infty=\delta^b-\delta^{2b}b_1
\tag{10}
\]

show exactly where a purely toric overlap argument fails.

## Remaining normalized-overlap certificate

The replay proves that every printed local maximum list is the restriction of
the same six weights.  It does not determine a control stratification.
Auxiliary log faces may discard unit normal directions and manufacture
restricted critical loci, while actual infinity-boundary strata must be
audited after reduction.  To turn this support complex into the common
algebraic model, one must still use (2), the marked residual Rees construction,
and separate algebraic-chart and control-stratum ledgers to verify:

1. equality of the reduced saturated graph closures on all twelve adjacency
   overlaps;
2. equality of their normalized reduced-stratum tangent-Fitting ideals;
3. the two incidence-to-imbalanced transitions while keeping their smooth
   residue coordinate $v$ interior;
4. compatibility with one fixed value neighborhood after auditing the genuine
   nonresidual critical values, not merely $L=0$; and
5. finite completeness after any extra exceptional overlap charts are added.

The correct next proof object is therefore a pair-of-pants/log modification,
not an original-coordinate toric fan.

## EJ/TT and mystery ledger

- **EJ:** six universal linear forms replace all ten normalization tables.
  Their hyperplane subdivision is finite and automatically support-complete.
- **TT:** the translated divisor is the decisive structural warning.  Any
  purported common toric fan in the original $(B,C)$ torus cannot contain the
  $B=1$ or $C=1$ charts and is false before any Gröbner calculation begins.
- **Settled:** the finite support cone complex, its ten orbit types, its twelve
  adjacency edges, and the exact deterministic replay.
- **Open evidence gap:** normalized graph and tangent-Fitting equality across
  the nonmonomial pair-of-pants transitions, including all deeper reduced
  strata.
- **Open topology:** proper collars and relative Mayer--Vietoris remain
  separate after the algebraic overlap gate.
