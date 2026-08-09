# C756 \(q=47\) octic star carrier

**Date:** 2026-08-09

**Scope:** \(k=12\), arbitrary deleted-point type, nonsaturated branch

**Status:** the bounded quadratic-through-octic carrier is constructed; no
\(q=47\) classification is claimed

## Verdict

For a deleted point over \(\mathbf F_{47}\), the twelve or thirteen required
centers force the common binary-form identities

\[
 E_1=0,\qquad E_9=E_{10}=E_{11}=0.                       \tag{1}
\]

Here \(E_j(z)\) is the \(j\)-th elementary symmetric form of the 55 centered
star-node projections \(z(v)\).  The seven surviving forms

\[
 \boxed{E_2,E_3,\ldots,E_8}                              \tag{2}
\]

determine every moment tensor through degree 11.  Their binary coefficients
give \(3+4+\cdots+9=42\) scalar carrier coordinates.

Because \(11! \ne 0\) in characteristic 47, ordinary polarization loses no
mixed coefficient.  One multilinear partition function built from (2) then
has:

- value equal to the contraction of the degree-11 arrangement product;
- eleven first derivatives equal to the degree-10 star-generator
  contractions;
- 55 off-diagonal second derivatives equal to the degree-9 single-node
  separator values.

This constructs the carrier promised by the point-type ledger.  The next
gate is to combine its 42 tensors with the mixed secant/passant line
discriminants and internal-node character equations.

## 1. Newton closure

Let

\[
 P_d(z)=\sum_{v\in S_0}z(v)^d.
\]

Set \(P_1=0\), retain \(E_2,\ldots,E_8\), and set every \(E_i\) with
\(i\in\{1,9,10,11\}\) to zero.  Newton's identities give the recursion

\[
 \boxed{
 P_d=\sum_{i=2}^{d-1}(-1)^{i-1}E_iP_{d-i}
      +(-1)^{d-1}dE_d
 }\qquad(2\le d\le11),                                   \tag{3}
\]

where \(E_i=0\) outside \(2\le i\le8\).  Thus all \(P_d\) through degree 11
are universal polynomials in the octic carrier (2).

The first moments beyond the retained range are

\[
\begin{aligned}
P_9={}&-9E_4E_5-9E_3E_6-9E_2E_7+3E_3^3
+18E_2E_3E_4\\
&+9E_2^2E_5-9E_2^3E_3,                                  \tag{4}\\
P_{10}={}&5E_5^2+10E_4E_6+10E_3E_7+10E_2E_8
-10E_3^2E_4\\
&-10E_2E_4^2-20E_2E_3E_5-10E_2^2E_6
+15E_2^2E_3^2\\
&+10E_2^3E_4-2E_2^5,                                    \tag{5}\\
P_{11}={}&-11E_5E_6-11E_4E_7-11E_3E_8
+11E_3E_4^2+11E_3^2E_5\\
&+22E_2E_4E_5+22E_2E_3E_6+11E_2^2E_7
-11E_2E_3^3\\
&-33E_2^2E_3E_4-11E_2^3E_5+11E_2^4E_3.                 \tag{6}
\end{aligned}
\]

The formulas are integral identities before reduction modulo 47.  Every
monomial in \(P_d\) has weighted degree \(d\), with \(E_i\) assigned weight
\(i\).

## 2. Polarized moment functional

For \(0\le d\le11\), let \(\mathsf M_d\) be the symmetric \(d\)-linear
polarization of \(P_d\):

\[
 \mathsf M_d(z_1,\ldots,z_d)
 =\frac1{d!}\sum_{J\subseteq[d]}(-1)^{d-|J|}
 P_d\left(\sum_{j\in J}z_j\right).                       \tag{7}
\]

Take \(\mathsf M_0=55=8\) in \(\mathbf F_{47}\).  Since all factorials
through \(11!\) are units, (7) is exact and

\[
 \mathsf M_d(z_1,\ldots,z_d)
 =\sum_{v\in S_0}\prod_{j=1}^d z_j(v).                   \tag{8}
\]

Hence (2) determines the node-sum functional on every affine polynomial of
degree at most 11, not merely its diagonal evaluations.

This is the precise reason the same construction fails if copied naively to
\(\mathbf F_{49}\): \(7!\) vanishes there and diagonal seventh moments do
not determine the mixed tensor.

## 3. One partition function for the star ideal

Write the centered arrangement lines as

\[
 \ell_i=c_i+a_i,\qquad 1\le i\le11,
\]

where \(a_i\) is the homogeneous linear part.  Introduce monomer variables
\(C_1,\ldots,C_{11}\) and define

\[
 \boxed{
 \mathcal Z_E(C)=
 \sum_{S\subseteq[11]}
 \mathsf M_{|S|}(a_i:i\in S)\prod_{i\notin S}C_i.
 }                                                        \tag{9}
\]

By (8),

\[
 \mathcal Z_E(C)
 =\sum_{v\in S_0}\prod_{i=1}^{11}(C_i+a_i(v)).            \tag{10}
\]

At \(C=c\), put \(F=\prod_i\ell_i\),
\(G_i=\prod_{j\ne i}\ell_j\), and
\(h_{ij}=\prod_{k\notin\{i,j\}}\ell_k\).  The star incidence gives

\[
\begin{aligned}
\mathcal Z_E(c)&=\sum_vF(v)=0,\\
\partial_i\mathcal Z_E(c)&=\sum_vG_i(v)=0,\\
\partial_i\partial_j\mathcal Z_E(c)
 &=\sum_vh_{ij}(v)=h_{ij}(N_{ij})\ne0\quad(i\ne j).
\end{aligned}                                             \tag{11}
\]

Thus the star lies at a critical point of a multilinear partition function
with a zero-diagonal, nowhere-zero off-diagonal Hessian.  Unlike the
\(q=53\) rank-two partition function, its coefficients depend on all seven
forms (2); there is no justified covariance-only reduction.

## 4. Scope and next exact gate

The carrier is type-uniform because both deleted-point types force
\(E_9,E_{10},E_{11}=0\).  An internal deleted point additionally forces
\(E_{12}=0\), but that extra equation is not used in (3)--(11).

This result does not enumerate line arrangements and does not prove
nonexistence over \(\mathbf F_{47}\).  A faithful next system must retain:

1. eleven mixed secant/passant line equations;
2. all 55 pairwise nodes, with no triple concurrency;
3. internal quadratic character at every node;
4. the defining relation between the nodes and the binary forms
   \(E_2,\ldots,E_8\);
5. the critical and open-Hessian conditions (11).

The useful reduction is dimensional and degree-bounded: no coefficient above
degree eight and no polarization above degree eleven is needed.

## Exact replay

The bundle

- notes/2026-08-09-c756-q47-octic-carrier.py
- notes/2026-08-09-c756-q47-octic-carrier.json

generates (3)--(6) over the integers, verifies every Newton residual,
checks weighted homogeneity, reduces coefficients modulo 47, and records all
factorial inverses through degree 11.

Replay:

    PYTHONDONTWRITEBYTECODE=1 python3 \
      notes/2026-08-09-c756-q47-octic-carrier.py \
      --check notes/2026-08-09-c756-q47-octic-carrier.json

## EJ + TT closeout

**EJ.**  The degree ledger was checked at exact statement strength.  The
external-point window has 12 centers and forces through \(E_{11}\); the
internal-point window has 13 and forces through \(E_{12}\).  The common
degree-11 range is precisely enough for the value/gradient/Hessian package.
The symbolic checker independently verifies the Newton signs and all
denominators.

**TT.**  The compression is the partition function (9), not the raw list of
42 coefficients.  It exposes the same star-ideal interface as the \(q=53\)
carrier while showing exactly why covariance alone is insufficient.  No
generic elimination is warranted before conic character data are inserted.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Common point-type window through degree 11 | settled | \(E_9=E_{10}=E_{11}=0\) |
| Newton closure through the star degree | settled | formulas (3)--(6) |
| Recovery of mixed moments | settled at \(q=47\) | ordinary polarization (7) |
| Unified generator/separator carrier | settled | partition function (9)--(11) |
| Reduction to covariance alone | false expectation | seven binary forms, 42 coefficients, survive |
| \(q=47,k=12\) classification | open | impose mixed line types and all internal-node characters on (9) |
| Cross-deletion compatibility | open | relate the 12 carrier systems belonging to one primal arc |
