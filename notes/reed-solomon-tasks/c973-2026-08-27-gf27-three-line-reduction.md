# C973 checkpoint — GF(27) three-line carrier reduction

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** exact
one-parameter reduction proved; rational-point closure open

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

## 4. Boundary and next gate

The load-bearing next step is to choose `p!=r` uniformly from the thirteen
directions and prove that some `u in W_p` survives (7)--(11).  The best first
split is the dense stratum `z2z3!=0`, where only one `u` is lost to the linear
determinant.  The strata `z2=0` or `z3=0` should be reduced by the affine
Borel action before introducing any finite enumeration.

No manuscript or software edit is made, and no census or point-count
certificate supports this reduction.

## 5. `ej` + `tt` ledger

| question | status | exact continuation |
|---|---|---|
| Is one affine `F3`-plane enough? | too rigid: it is the all-parallel specialization of (1) | retain one transverse line |
| Where do the two Hankel equations go? | one `2x2` linear solve in `(v,s)` | equations (4)--(6) |
| What replaces binary rootlessness? | `u^2-v=delta^2` with `u,delta in W_p` | quadratic split cover (8) |
| What replaces the Artin--Schreier trace bit? | membership in `W_p,W_r`, each a linearized cubic image | cyclic cubic covers above |
| What is the complete collision boundary? | two explicit cubic factors | equation (11) |
| Does the GF(64) sign-cover lemma directly close GF(27)? | not yet; the natural family gives a cubic-cover tower rather than one identified genus-one sign cover | analyze the dense `z2z3!=0` tower first |
