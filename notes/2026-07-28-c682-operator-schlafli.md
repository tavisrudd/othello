# C682 characteristic-zero operator realization and the complementary Schläfli six

## Outcome

The maximal-subgroup mate correspondence now has a direct
characteristic-zero transvectant realization, and its \(D_5\) component
canonically produces both rows of the Schläfli double-six.

Let
\[
T_F:\operatorname{Sym}^6\longrightarrow\operatorname{Sym}^{12},
\qquad p\longmapsto(p,F)_3
\]
be the third-transvectant operator attached to a binary dodecic in the
Mukai--Umemura orbit.  The previously proved transvectant inverse gives
\[
U_F=\ker T_F,\qquad V_F=U_F^\perp ,
\]
where \(U_F\) is the isotropic parent three-plane and \(V_F\) is its
Clebsch four-space.  Pulling \(F\mapsto T_F\) back along
\[
\Delta\sqcup G/A_4\sqcup G/D_5\sqcup G/S_3
\rightrightarrows G/A_5
\]
therefore realizes the complete characteristic-zero maximal-subgroup
mate correspondence by rank-four operators.  This is the ordinary
characteristic-zero operator, not the special-fibre ten-pair Bockstein
pencil.

For a \(D_5\) mate \(F_i\) of \(F\), the two kernel planes meet in one
line
\[
U_F\cap U_{F_i}=\langle q_i^3\rangle ,
\]
where \(q_i\in\operatorname{Sym}^2\) represents their common fivefold
axis.  Put
\[
\mathcal T_i=q_i^2\operatorname{Sym}^2
      =\widehat T_{q_i^3}\nu_3(\operatorname{Sym}^2),
\]
the three-dimensional affine tangent space to the cubic Veronese at
\([q_i^3]\).  Then the two lines
\[
\boxed{
E_i=V_F\cap\mathcal T_i=V_F\cap V_{F_i},
\qquad
E_i'=V_F\cap\mathcal T_i^\perp
}
\]
are respectively Hitchin's exceptional common-axis line and its
complementary Schläfli line.  Thus the second six is not inserted by an
external outer automorphism: it is the apolar-polar companion of the same
shared-kernel operator datum.

## Exact representative

Take Klein's dodecic and its nontrivial \(D_5\)-normalizer mate
\[
\begin{aligned}
F_+&=X^{11}Y+11X^6Y^6-XY^{11},\\
F_-&=X^{11}Y-11X^6Y^6-XY^{11}.
\end{aligned}
\]
If \(\zeta=\zeta_5\) and \(\xi=-\zeta^3\), then
\(\xi^5=-1\), and the projective dilation \(X\mapsto\xi X\)
normalizes the axis \(XY\) and sends \(F_+\) to \(F_-\) up to scalar.
Both transvectant operators have rank four, with
\[
\begin{aligned}
U_+&=\langle
X^3Y^3,\ X^6+3XY^5,\ 3X^5Y-Y^6\rangle,\\
U_-&=\langle
X^3Y^3,\ X^6-3XY^5,\ 3X^5Y+Y^6\rangle .
\end{aligned}
\]
Hence
\[
U_+\cap U_-=\langle (XY)^3\rangle .
\]
For \(q=XY\),
\[
\mathcal T=q^2\operatorname{Sym}^2
=\langle X^4Y^2,X^3Y^3,X^2Y^4\rangle ,
\]
and exact apolar linear algebra gives
\[
\begin{aligned}
E&=\langle X^4Y^2,X^2Y^4\rangle,\\
E'&=\langle X^6-2XY^5,\ 2X^5Y+Y^6\rangle .
\end{aligned}
\]
The first equality agrees with \(V_+\cap V_-\).  The second is the
singularity pencil at the common axis.

## Why the polar cut is the complementary line

The binary cubic-Veronese model expresses evaluation of a harmonic cubic
\(p\) at the axis \(q\) by the apolar pairing
\[
p(q)=\langle p,q^3\rangle .
\]
Its first derivative in the quadratic direction \(r\) is, up to the
fixed nonzero scalar,
\[
dp_q(r)=\langle p,q^2r\rangle .
\]
Consequently
\[
p\perp q^2\operatorname{Sym}^2
\quad\Longleftrightarrow\quad
p\text{ is singular at }[q].
\]
Hitchin identifies the projective line of members of \(V_F\) singular at
the \(i\)-th axis with the proper transform of the conic through the other
five axes, namely \(E_i'\).  This proves the second boxed equality
intrinsically.  The first equality follows at the displayed representative
and hence on all six axes by \(A_5\)-equivariance.

The six axis quadratics can be written over
\(\mathbf Q(\zeta_5)\) as
\[
q_\infty=XY,\qquad
q_b=X^2+bXY-b^2Y^2\quad(b^5=1).
\]
Their cubes span \(U_+\).  Exact calculation gives
\[
\dim(E_i\cap E_j)=\dim(E_i'\cap E_j')=0\quad(i\ne j)
\]
and
\[
\dim(E_i\cap E_j')=
\begin{cases}
0,&i=j,\\
1,&i\ne j.
\end{cases}
\]
This is precisely the Schläfli double-six incidence matrix.  Galois acts
by permuting the \(q_b\), so each six-line union descends even though the
displayed simultaneous splitting field is \(\mathbf Q(\zeta_5)\).

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-operator-schlafli.py --check
python3 ../notes/2026-07-28-c682-operator-schlafli-replay.py
```

The primary checker implements exact arithmetic in
\(\mathbf Q(\zeta_5)\), constructs both rank-four transvectant operators,
recovers the shared kernel cube, constructs all twelve lines, and checks
the complete double-six incidence matrix.  The independent replay
reimplements the calculation over \(\mathbf F_{31}\) and
\(\mathbf F_{41}\), using independently selected primitive fifth roots.
It is a cross-check of the formulas; the characteristic-zero proof is the
exact cyclotomic calculation plus the equivariant argument above.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-operator-schlafli.py` | 13960 | `2455190d74d69e55653c43aea50f6a73facccbb34aeb407bb115a06cac75d239` |
| `2026-07-28-c682-operator-schlafli-replay.py` | 6062 | `82094f99067bed211cf03855850c34131de857d28126b9f43318bc9e6e228756` |
| `2026-07-28-c682-operator-schlafli.json` | 41204 | `8383f85e8d7a46c51bc23f167cdbb4dcc22fcaf19c7488b6feea2c51ea9fca1b` |

The computation does not prove the previously established global
transvectant inverse or the classification of the normalizer-mate
correspondence.  Those are human inputs from the earlier C682 reports.
Conversely, those inputs do not identify the complementary polar cut or
certify its exact double-six incidence; that is the new proof and
certificate here.

One initial attempt to inspect the oversized live C682 report emitted
41,484 tokens and was abandoned as a command-shaping failure.  All
subsequent source inspection used bounded sections or focused reports;
the excess output is not part of the evidence.

## Source and claim boundary

Hitchin, *Spherical harmonics and the icosahedron*,
arXiv:0706.0088, cached SHA-256
`33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`,
is the source for the blow-up model, the six exceptional lines \(E_i\),
and the description of \(E_i'\) as the pencil of cubics singular at the
\(i\)-th axis.  The earlier C682 transvectant-inverse and
maximal-subgroup-mate reports supply the global operator inverse and the
unique \(D_5\) mate.  No novelty or priority claim is made, and Paper III
remains closed.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the entire \(1+5+6+10\) characteristic-zero mate
  correspondence has a rank-four operator realization via
  \(F\mapsto T_F\).
- **Closed:** a \(D_5\) operator pair recovers its common axis internally
  as the unique shared-kernel cube \(\langle q_i^3\rangle\).
- **Closed by `ej`:** the tangent plane splits the fixed Clebsch
  four-space into the common-axis line \(E_i\), while its apolar orthogonal
  produces the complementary line \(E_i'\).
- **Closed by `ej`:** the exact \(6\)-by-\(6\) intersection matrix is the
  full Schläfli double-six, and both six-line unions descend from the
  cyclotomic splitting field.
- **Settled by `tt`:** the complementary six is natural, but it is not a
  second component of the maximal-subgroup mate correspondence.  It is a
  polar companion extracted functorially from the \(D_5\) component.
  Calling it another mate orbit would conflate lines on the Clebsch
  surface with points of the icosahedral moduli space.
- **Still open:** prove in characteristic zero, by the same operator
  model, that the \(D_5\)--\(S_3\) kernel-intersection equation realizes
  the \((6_5,10_3)\) incidence.  Its exact mod-\(11\) version is already
  certified.
- **Still open:** determine whether the row swap
  \(E_i\leftrightarrow E_i'\) extends to a distinguished global
  birational or categorical involution of the marked
  Mukai--Umemura/Clebsch correspondence.  The present theorem constructs
  the paired lines but does not assert such an ambient involution.
- **Still open:** spread the operator-polar construction over a minimal
  integral base and identify its actual bad primes.

C682 remains open; completion is the user's decision.
