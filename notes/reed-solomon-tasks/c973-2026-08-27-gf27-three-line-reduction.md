# C973 checkpoint — GF(27) three-line carrier reduction

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** exact
one-parameter reduction, two residual boundary charts, and the last chart's
torus endpoint closed; abundance open

## 1. Split family

Let `K=GF(27)` and write a characteristic-three R11 carrier syndrome as

\[
                         z=(z_2,z_3,\ldots,z_8).
\]

For `p=-alpha^2` with `alpha!=0`, put

\[
 L_p(t)=t^3+pt,
 \qquad W_p=\operatorname {im}L_p.
\]

The kernel of `L_p` is the affine direction `alpha F3`, and `W_p` is a
two-dimensional `F3`-subspace of `K`.  Every affine `F3`-line in that
direction has a unique equation

\[
                         L_p(t)+q=0,qquad q\in W_p.
\]

Choose distinct `q1,q2 in W_p`, a second direction `r=-beta^2` with `r!=p`,
and `s in W_r`.  If the transverse line is disjoint from the first two, then

\[
 g(t)=(L_p(t)+q_1)(L_p(t)+q_2)(L_r(t)+s)                 \tag{1}
\]

is a monic split squarefree degree-nine locator with nine finite roots.  It
therefore automatically avoids the normalized forbidden point at infinity.

Put

\[
                         u=q_1+q_2,qquad v=q_1q_2.
\]

Direct multiplication gives

\[
\begin{aligned}
g_9&=1,&g_8&=0,&g_7&=r-p,&g_6&=u+s,\\
g_5&=p(p-r),&
g_4&=u(p+r)-ps,&
g_3&=p^2r+us+v,\\
g_2&=pru+p^2s,&
g_1&=pus+rv,&
g_0&=vs.                                                   \tag{2}
\end{aligned}
\]

## 2. Linear Hankel reduction

For a degree-nine locator, the two R11 equations are

\[
 \sum_{i=2}^8z_i g_{i-1}=0,
 \qquad
 \sum_{i=2}^8z_i g_i=0.                                  \tag{3}
\]

Substitution of (2) makes (3) linear in only `v` and `s`:

\[
                         Av+Bs+C=0,qquad Dv+Es+F=0,       \tag{4}
\]

where

\[
\begin{aligned}
A&=rz_2+z_4,\\
B&=u(pz_2+z_4)+p^2z_3-pz_5+z_7,\\
C&=u(prz_3+(p+r)z_5+z_7)
   +p^2rz_4+p(p-r)z_6+(r-p)z_8,\\
D&=z_3,\\
E&=uz_3+p^2z_2-pz_4+z_6,\\
F&=u(prz_2+(p+r)z_4+z_6)
   +p^2rz_3+p(p-r)z_5+(r-p)z_7.                           \tag{5}
\end{aligned}
\]

Let `Delta=AE-BD`.  If `Delta!=0`, the unique solution is

\[
                 v=\frac{BF-CE}{\Delta},
                 \qquad s=\frac{CD-AF}{\Delta}.           \tag{6}
\]

For fixed distinct directions `p,r`, `Delta` is affine in `u`; its
`u`-coefficient is

\[
                         z_2z_3(r-p).                     \tag{7}
\]

Thus on the dense stratum `z2 z3!=0`, at most one value of `u` makes the
linear solve degenerate.  The lower strata retain the same formulas and are
the exact separate boundary, rather than an unstructured carrier residue.

## 3. Exact arithmetic conditions

The first two line factors split with distinct roots exactly when there is a
`delta in W_p\setminus\{0\}` such that

\[
                         u\in W_p,qquad v=u^2-\delta^2.   \tag{8}
\]

Indeed, `X^2-uX+v` then has the two distinct roots
`q1=(u+delta)/2` and `q2=(u-delta)/2` in `W_p`, and the converse follows by
taking `delta=q1-q2`.  The transverse factor splits exactly when

\[
                              s\in W_r.                   \tag{9}
\]

Finally, a line `L_p(t)+q=0` meets `L_r(t)+s=0` exactly when

\[
 \Gamma_{p,r}(q,s)
 =(q-s)^3+p(r-p)^2(q-s)+q(r-p)^3=0.                       \tag{10}
\]

Hence squarefreeness of (1) adds only

\[
             \Gamma_{p,r}(q_1,s)\Gamma_{p,r}(q_2,s)\ne0. \tag{11}
\]

Equations (5)--(11) are the exact GF(27) closure gate.  They replace nine
unordered roots by two directions `p!=r` and one parameter `u`: solve (6),
test the two trace-plane conditions (8)--(9), the quadratic split condition
in (8), and the two explicit collision factors (11).

The trace-plane tests themselves are linearized cubic covers.  If
`p=-alpha^2`, then

\[
 W_p=\alpha^3\{x^3-x:x\in K\},
\]

and similarly for `r`.  Thus (8)--(9) form a low-degree tower of cyclic cubic
covers over the rational `u`-line, together with one quadratic split cover.
This is the characteristic-three descendant of the GF(64) cubic-resolvent
mechanism.  It is not yet proved to collapse to a single genus-one sign
cover, so no GF(27) closure is claimed here.

## 4. Upper-Borel compression

The applicable earlier result is the upper-Borel slice method in the Lucas
carrier supplement: outside its invariant block, projective transport first
normalizes a quotient coordinate and then retains only the upper-Borel
stabilizer.  The Borel statement in the MDS--CSS work instead classifies
one-coordinate conductor images as torus/Borel/full `SL2`; it is not an orbit
normal-form theorem.  Complete Repair Ports contains no separate Borel orbit
result.

For the present carrier, the unipotent element `t -> t+b` acts in the ordered
coordinates `(z2,...,z8)` by

\[
\begin{aligned}
z'_2&=z_2+bz_3-b^3z_5-b^4z_6+b^6z_8,\\
z'_3&=z_3-b^3z_6,\\
z'_4&=z_4-bz_5+b^2z_6+b^3z_7-b^4z_8,\\
z'_5&=z_5+bz_6+b^3z_8,\\
z'_6&=z_6,\\
z'_7&=z_7-bz_8,\\
z'_8&=z_8.                                                \tag{12}
\end{aligned}
\]

This is the degree-nine divided-power action reduced by Lucas modulo three.
The torus `t -> ct` has weights

\[
                         (7,6,5,4,3,2,1)                 \tag{13}
\]

on `(z2,...,z8)`, up to common projective scaling.

Equation (12) sharply reduces the boundary of the dense three-line chart.
If `z6!=0`, then `z3-b^3z6` vanishes for exactly one `b`, while `z2'` is a
nonzero polynomial of degree at most six because its `b^4` coefficient is
`-z6`.  At most seven of the 27 translations therefore fail to make both
`z2'` and `z3'` nonzero.  If `z6=0` but `z3!=0`, then `z3'=z3` and `z2'` is a
nonzero polynomial with linear coefficient `z3`, so at most six translations
fail.  Consequently every Borel orbit outside

\[
                              z_3=z_6=0                  \tag{14}
\]

has a representative in the dense stratum `z2z3!=0` of Section 2.  The true
Borel-stable boundary is the codimension-two five-space (14), not the union
of the two coordinate hyperplanes suggested by (7).

On (14), the residual unipotent action is

\[
\begin{aligned}
z'_2&=z_2-b^3z_5+b^6z_8,\\
z'_4&=z_4-bz_5+b^3z_7-b^4z_8,\\
z'_5&=z_5+b^3z_8,\\
z'_7&=z_7-bz_8,
\end{aligned}                                             \tag{15}
\]

with `z8` fixed.  This gives four exact normal-form strata:

1. If `z8!=0`, choose the unique `b=z7/z8` which makes `z7'=0`, then use
   projective scaling to set `z8=1`.  The residual torus has weights
   `(6,4,3)` on `(z2,z4,z5)`.
2. If `z8=0` and `z5!=0`, choose the unique cube root of `z2/z5`; it makes
   `z2'=0`.
3. If `z8=z5=0` and `z7!=0`, choose the unique cube root of `-z4/z7`; it
   makes `z4'=0`.
4. If `z8=z5=z7=0`, the unipotent radical fixes the remaining pair
   `(z2,z4)` pointwise, and only the torus weights `(7,5)` remain.

Thus the apparent two-hyperplane boundary has compressed to three affine
normal-form charts and one two-coordinate torus endpoint.

The torus endpoint closes explicitly.  Let `theta^3-theta-1=0` and put
`nu=2theta+1`, a primitive element of `K`.  On
`z3=z5=z6=z7=z8=0`, the projective ratio `[z2:z4]` has exactly four torus
orbits:

\[
                    [1:0],\quad[0:1],\quad[1:1],\quad[1:\nu]. \tag{16}
\]

Indeed, away from the coordinate points the ratio changes by a square under
(13), and `K^*/K^{*2}` has order two.  For a pair `(p,q)`, abbreviate
`F_{p,q}(t)=t^3+pt+q`.  Split locators for the four rows of (16) are the
products of the following three factors:

\[
\begin{array}{c|ccc}
[1:0]&
F_{2\theta^2+\theta+2,\,2\theta^2+\theta}&
F_{2\theta+2,\,\theta^2+\theta+2}&
F_{2\theta^2,\,2\theta^2+\theta+2}\\
[0:1]&
F_{2\theta+2,\,\theta^2+\theta+2}&
F_{2\theta^2+1,\,2\theta^2+\theta+2}&
F_{2,\,2\theta+2}\\
[1:1]&
F_{2\theta+2,\,\theta}&
F_{2\theta+2,\,2\theta}&
F_{2\theta^2+\theta+2,\,0}\\
[1:\nu]&
F_{2\theta+2,\,\theta}&
F_{2\theta+2,\,2\theta}&
F_{2\theta+1,\,0}.
\end{array}                                                \tag{17}
\]

For every factor in (17), `-p` is a nonzero square and `q` lies in `W_p`,
so it has three rational roots.  The three root lines in each row are
pairwise disjoint, as direct substitution in (10) shows.  Thus every product
has nine distinct roots.  Reducing modulo `theta^3-theta-1`, their first four
coefficients satisfy respectively

\[
 (g_1,g_2)=(0,0),\quad (g_3,g_4)=(0,0),\quad
 (g_1+g_3,g_2+g_4)=(0,0),\quad
 (g_1+\nu g_3,g_2+\nu g_4)=(0,0).                        \tag{18}
\]

These are exactly the two Hankel equations for the four endpoint syndromes.
Hence the two-coordinate torus endpoint contributes no pointed obstruction.

## 5. The `z7` boundary chart

The third residual chart in the list following (15) also closes without a
count.  There `z5=z8=0`, `z7!=0`, and translation has already made `z4=0`.
Thus only `(z2,z7)` remains.  After projectively setting `z7=1`, the torus
changes `z2/z7` by `c^5`.  Since

\[
                         \gcd(5,|K^*|)=\gcd(5,26)=1,
\]

every nonzero ratio is equivalent to one.  The whole chart therefore has
only the two orbits

\[
                              [z_2:z_7]=[0:1],\quad[1:1]. \tag{19}
\]

They admit the following split locators:

\[
\begin{array}{c|ccc}
[0:1]&
F_{2\theta^2+2\theta,\,0}&
F_{2\theta^2+2\theta,\,2\theta^2}&
F_{2\theta^2+2\theta,\,\theta^2}\\
[1:1]&
F_{2\theta^2+2\theta,\,0}&
F_{2\theta^2+2\theta,\,\theta^2+2\theta+1}&
F_{2\theta,\,\theta^2+1}.
\end{array}                                                \tag{20}
\]

This splitting and disjointness can be read directly from the root triples.
For the first row of (20), they are

\[
\begin{gathered}
\{0,\theta^2,2\theta^2\},\\
\{2\theta,\theta^2+2\theta,2\theta^2+2\theta\},\\
\{\theta,\theta^2+\theta,2\theta^2+\theta\};
\end{gathered}
\]

for the second row, they are

\[
\begin{gathered}
\{0,\theta^2,2\theta^2\},\\
\{2\theta+2,\theta^2+2\theta+2,2\theta^2+2\theta+2\},\\
\{\theta^2+2\theta,\theta+1,2\theta^2+2\}.
\end{gathered}
\]

Each displayed row consists of nine distinct elements of `K`.  If `g` is
the corresponding product in (20), its relevant coefficients are

\[
\begin{array}{c|cccc}
&g_1&g_2&g_6&g_7\\ \hline
[0:1]&2\theta^2+2&0&0&0\\
[1:1]&\theta^2+\theta+1&2\theta^2&2\theta^2+2\theta+2&\theta^2.
\end{array}                                                \tag{21}
\]

Thus the first row has `(g6,g7)=(0,0)`, while the second has
`(g1+g6,g2+g7)=(0,0)`.  These are precisely (3) for the two syndromes in
(19).  Hence this entire residual Borel chart contributes no obstruction.

## 6. The `z5` chart and its affine-plane slice

The second residual chart in the list following (15) has

\[
                 z_2=z_3=z_6=z_8=0,\qquad z_5\ne0.       \tag{22}
\]

Projectively set `z5=1` and write `x=z4/z5`, `y=z7/z5`.  Under the residual
torus,

\[
                              (x,y)\longmapsto(cx,c^{-2}y). \tag{23}
\]

The whole slice `x=0` closes uniformly.  Fix any direction `p=-alpha^2`,
choose `q in W_p` and `0!=h in W_p`, and put

\[
 g(t)=\prod_{\epsilon\in\mathbf F_3}
       \bigl(L_p(t)+q+\epsilon h\bigr).
\]

The three factors are distinct parallel affine lines, so their roots are
nine distinct elements of `K`.  In characteristic three,

\[
\begin{aligned}
g(t)&=(L_p(t)+q)^3-h^2(L_p(t)+q)\\
    &=t^9+(p^3-h^2)t^3-ph^2t+q^3-h^2q.                 \tag{24}
\end{aligned}
\]

In particular

\[
                              g_4=g_5=g_6=g_7=0.         \tag{25}
\]

For (22) with `x=0`, equations (3) are exactly
`g4+y g6=0` and `g5+y g7=0`; hence (25) closes every `y` at once.

If `x!=0`, choose `c=x^{-1}` in (23).  This leaves the single invariant

\[
                              \lambda=x^2y\in K          \tag{26}
\]

and gives the normal form `(x,y)=(1,lambda)`.  Thus the unclosed part of this
chart is one affine parameter line, not a three-coordinate residue.  The
all-parallel construction cannot close that line: (3) would force the three
offsets to sum to zero and their pair sum to `-p^3`; three distinct offsets
of sum zero form an affine `F3`-line with pair sum `-h^2`, whereas `p^3` is a
nonsquare because `p=-alpha^2` and `-1` is a nonsquare in `K`.  A transverse
line is genuinely necessary there.

That transverse construction closes every value of `lambda`.  Frobenius
acts by `lambda -> lambda^3` and preserves the normal form `(1,lambda)`.  The
following eleven elements represent all its orbits on `K`:

\[
\begin{gathered}
0,1,2,\quad \theta^2+\theta+1,\quad 2\theta^2+2\theta+2,
\quad\theta+1,\quad\theta^2+2,\\
2\theta^2+1,\quad2\theta+1,\quad\theta^2+1,
\quad2\theta^2+2\theta+1.                               \tag{27}
\end{gathered}
\]

For each representative, a locator is the product of the three displayed
factors:

\[
\begin{array}{c|ccc}
0&F_{2\theta^2+1,0}&F_{2\theta^2+1,\theta}&F_{2\theta,2\theta^2+2}\\
1&F_{2\theta^2,0}&F_{2\theta^2,\theta^2+2}&F_{2\theta+1,2\theta+2}\\
2&F_{2\theta^2,0}&F_{2\theta^2,2\theta^2+2\theta}&F_{2\theta,2\theta+1}\\
\theta^2+\theta+1&F_{2,2\theta+1}&F_{2,\theta}&F_{2\theta,0}\\
2\theta^2+2\theta+2&F_{2,\theta+2}&F_{2,1}&F_{\theta^2+1,0}\\
\theta+1&F_{2,2\theta}&F_{2,\theta+1}&F_{2\theta^2,0}\\
\theta^2+2&F_{2\theta,0}&F_{2\theta,\theta^2+\theta}&F_{2\theta^2+1,2\theta}\\
2\theta^2+1&F_{2\theta,0}&F_{2\theta,\theta+2}&F_{2\theta^2+\theta,\theta^2}\\
2\theta+1&F_{2\theta^2,0}&F_{2\theta^2,\theta+1}&F_{2,\theta}\\
\theta^2+1&F_{2,0}&F_{2,2\theta}&F_{2\theta^2,2\theta^2+2\theta}\\
2\theta^2+2\theta+1&F_{2,\theta}&F_{2,2}&F_{2\theta^2,\theta^2+\theta}.
\end{array}                                                \tag{28}
\]

In every row, the first two lines are parallel, the third is transverse,
each offset belongs to the appropriate `W_p`, and the two collision factors
(10) are nonzero.  Thus each product has nine distinct roots in `K`.  Direct
multiplication gives

\[
                 g_3+g_4+\lambda g_6=0,
                 \qquad g_4+g_5+\lambda g_7=0,           \tag{29}
\]

which are exactly (3) for `(x,y)=(1,lambda)`.  Applying Frobenius to a row
of (28) cubes both its roots and `lambda`, so (27)--(29) close all 27 values.
Together with (24), the entire `z5` chart is therefore closed.

## 7. The `z8` chart and its torus endpoint

It remains to sharpen the first residual chart in the list following (15).
After setting `z8=1` and `z7=0`, write

\[
                              (a,b,c)=(z_2,z_4,z_5).
\]

The residual torus acts with weights `(6,4,3)`.  Since cubing is bijective on
`K^*`, the stratum `c!=0` normalizes to `c=1`, leaving `(a,b)`.  If `c=0`
and `b!=0`, fourth powers are precisely the squares, so `b` normalizes to
one of `1,nu` and `a` remains.  The endpoint `b=c=0` has just three orbits:

\[
                              a=0,\qquad a=1,\qquad a=\nu. \tag{30}
\]

Indeed, the sixth powers in `K^*` are also precisely the squares.  The zero
orbit is closed by any product (24), for which `g7=g8=0`.  For the other two
orbits, use

\[
\begin{array}{c|ccc}
a=1&F_{\theta^2+1,\theta^2}&F_{\theta^2+1,2\theta^2}&F_{2\theta,0}\\
a=\nu&F_{2,1}&F_{2,2}&F_{2\theta^2+1,0}.
\end{array}                                                \tag{31}
\]

Every factor splits, and the three root lines in each row are disjoint, by
the same `W_p` and collision tests (9)--(10).  The relevant coefficients are

\[
\begin{array}{c|ccc}
&g_1&g_2&g_7\\ \hline
a=1&\theta^2+\theta+1&0&2\theta^2+2\theta+2\\
a=\nu&\theta^2+2&0&2\theta^2+2.
\end{array}                                                \tag{32}
\]

Thus `a g1+g7=0` and `a g2+g8=0` in both rows.  These are exactly (3) on
the endpoint, so all three orbits (30) are closed.

Consequently the open part of the `z8` chart consists exactly of the two
torus strata

\[
                 c=1\text{ with }(a,b)\in K^2,
                 \qquad
                 c=0,\ b\in\{1,\nu\},\ a\in K.          \tag{33}
\]

On these strata the three-line solve simplifies further.  Substituting
`z=(a,0,b,c,0,0,1)` into (5) gives

\[
\begin{aligned}
A&=ra+b,&D&=0,&E&=p(pa-b),\\
B&=u(pa+b)-pc,\\
C&=u(p+r)c+p^2rb+(r-p),\\
F&=u\{pra+(p+r)b\}+p(p-r)c.
\end{aligned}                                             \tag{34}
\]

Hence

\[
                              \Delta=p(ra+b)(pa-b).       \tag{35}
\]

For `a!=0`, at most one `p` and one `r` among the thirteen directions make
(35) vanish; if `a=0`, it is nonzero throughout the open stratum `b!=0`.
There is no exceptional `u`.  When (35) is nonzero,

\[
 s=-\kappa u-\eta,
 \quad
 \kappa=\frac{pra+(p+r)b}{p(pa-b)},
 \quad
 \eta=\frac{(p-r)c}{pa-b},
 \qquad
 v=-\frac{Bs+C}{ra+b}.                                  \tag{36}
\]

Thus the first image condition is the intersection

\[
                              \kappa W_p\cap(-\eta+W_r). \tag{37}
\]

The two spaces are affine planes in the three-dimensional `F3`-space `K`.
If their directions differ, (37) is automatically an affine line of three
points; if the directions agree, it has either zero or nine points according
as the translate misses or equals that plane.  Consequently the generic
`z8` residue has already fallen from a nine-value `u` search to exactly three
explicit candidates.  Only the quadratic split test and the two collision
factors remain on that affine line.

## 8. Boundary and next gate

The load-bearing next step is to choose `p!=r` uniformly from the thirteen
directions and prove that some `u in W_p` survives (7)--(11) on the dense
stratum.  Equation (12) transports every syndrome outside (14) into that
stratum.  The two-coordinate endpoint is closed by (16)--(18), the `z7`
chart by (19)--(21), and the entire `z5` chart by (24)--(29).  The only
separate open boundary is now the pair of torus strata (33) inside the
`z8!=0` chart, with their generic solve reduced to the three-point affine
intersection (37).

No manuscript or software edit is made, and no census or point-count
certificate supports this reduction.

## 9. `ej` + `tt` ledger

| question | status | exact continuation |
|---|---|---|
| Is one affine `F3`-plane enough? | too rigid: it is the all-parallel specialization of (1) | retain one transverse line |
| Where do the two Hankel equations go? | one `2x2` linear solve in `(v,s)` | equations (4)--(6) |
| What replaces binary rootlessness? | `u^2-v=delta^2` with `u,delta in W_p` | quadratic split cover (8) |
| What replaces the Artin--Schreier trace bit? | membership in `W_p,W_r`, each a linearized cubic image | cyclic cubic covers above |
| What is the complete collision boundary? | two explicit cubic factors | equation (11) |
| Does the GF(64) sign-cover lemma directly close GF(27)? | not yet; the natural family gives a cubic-cover tower rather than one identified genus-one sign cover | analyze the dense `z2z3!=0` tower first |
| Is `z2z3=0` the true Borel boundary? | no; (12) moves every orbit with `(z3,z6)!=(0,0)` into the dense chart | only the invariant five-space `z3=z6=0` remains |
| How many boundary charts remain after the Borel action? | three affine normal forms and one two-coordinate torus endpoint | the four strata following (15) |
| Does the torus endpoint survive? | no; its four square-class orbits have the explicit three-line products (17) | closed by the coefficient identities (18) |
| Does the residual `z7` chart survive? | no; relative torus weight five is invertible modulo 26, leaving two orbits | closed by the explicit root partitions (20)--(21) |
| What remains of the residual `z5` chart? | nothing: its `z4=0` slice closes uniformly by one affine-plane product, and Frobenius reduces the complementary `lambda`-line to the eleven direct products (28) | closed by (24)--(29) |
| What remains of the residual `z8` chart? | its three-orbit `z4=z5=0` endpoint is closed; two torus strata remain, and their first image condition generically leaves exactly three `u` values | close the quadratic split and collision tests on (37) |
