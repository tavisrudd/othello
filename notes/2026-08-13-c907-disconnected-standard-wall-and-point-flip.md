# C907 — disconnected standard walls and the isolated-point Gold flip

Date: 2026-08-13

Status: exact first negative-contact peak.  Blowing up a general point of
`X x P^2` creates six disjoint split `(1,3)` standard-flip curves.  The common
wall is six points, so it falls just outside Gu--Yu--Yu's printed
connected-wall convention.  Their formal proof and the C907 oriented rank
argument extend componentwise when the middle fixed locus is a finite
disjoint union with the same normal ranks and one common extremal variable.
Consequently this negative-budget peak preserves the primitive-sixth Gamma
rank Boolean.

This closes one explicit negative class, not all AKMW peaks.

## 1. Geometry after an isolated point blowup

Let `X` be a smooth cubic threefold, let `p in X` be general, let
`b in P^2`, and set

\[
 V=X\times P^2,\qquad y=(p,b),\qquad
 \pi:Y=Bl_yV\longrightarrow V.
\]

A general point of `X` lies on six distinct lines `L_1,...,L_6`.  They are
first-type lines, so

\[
 N_{L_i/X}\cong O_{P^1}^{\oplus2}.
\]

For `C_i=L_i x {b}` this gives

\[
 N_{C_i/V}\cong O_{P^1}^{\oplus4}.
\]

The six curves meet only at `y`.  Their strict transforms in `Y` are
disjoint and the normal-bundle elementary transform under the point blowup
gives

\[
 N_{\widetilde C_i/Y}\cong O_{P^1}(-1)^{\oplus4}.  \tag{1}
\]

The contact-budget calculation agrees:

\[
 c_1(Y)\widetilde C_i=2-(5-1)=-2.                 \tag{2}
\]

Thus this lies outside every strictly K-positive carrier face.

## 2. The contraction and flip are projective

Put

\[
 A=O_X(1)\boxtimes O_{P^2}(2),\qquad
 D=\pi^*A-E.
\]

The line bundle `A` is very ample and `D` is the basepoint-free system giving
projection of the `A`-embedding from `y`.  A curve is contracted exactly
when its image is a line through `y`.  The second Veronese factor contains no
lines, so the only such curves are `L_i x {b}`.  Hence `D` contracts exactly
the six curves in (1), all on one numerical extremal ray.

The local contraction of `P^1` with normal `O(-1)^4` has the split standard
flip

\[
 P^1,\ O(-1)^{\oplus4}
 \quad\dashrightarrow\quad
 P^3,\ O(-1)^{\oplus2}.                            \tag{3}
\]

Blowing up all six curves gives a common smooth model whose exceptional
divisors are six copies of `P^1 x P^3` with normal `O(-1,-1)`; contracting
the other rulings produces a smooth projective fivefold `Y^+`.  The wall
base is

\[
 S=\coprod_{i=1}^6 pt,
\]

with normal ranks `(r_+,r_-)=(2,4)` and discrepancy `c_S=-2`.

## 3. Finite-disconnected extension of the wall theorem

Gu--Yu--Yu assume the middle fixed locus `F_0` is connected so that the
master has three connected fixed components.  Let instead

\[
 F_0=\coprod_{a=1}^N F_a
\]

be a finite disjoint union of smooth projective components, all with the same
normal ranks `(r_+,r_-)`, the same discrepancy, and the same extremal
Novikov class.  Then their proof extends with

\[
 H^*(F_0)=\bigoplus_aH^*(F_a),\qquad
 QDM(F_0)=\bigoplus_aQDM(F_a).                     \tag{4}

The checks are literal:

1. Bialynicki--Birula cells, equivariant Thom--Gysin sequences, Kirwan maps,
   and Euler classes split over the components.
2. Each continuous Fourier transform is defined componentwise.  The common
   extremal variable gives the same critical scales; repeated exponential
   factors are kept as one regular block `QDM(F_0)`, not artificially
   separated.
3. In the leading comparison matrix of Proposition 5.9, every `F_0` block is
   replaced by its direct sum over `a`.  The Fourier matrix in the copy index
   is unchanged, so invertibility is unchanged.
4. The Poincare pairing is the orthogonal direct sum of the component
   pairings.  Flat extension therefore proves the same pairing theorem.
5. The reduced Novikov maps and connection intertwining are componentwise;
   positive master-space degrees may couple through the ambient block, but
   are already included in the same completed source and do not alter the
   invertible leading matrix.

Connectedness is therefore a convention in this equal-rank finite-disjoint
case, not a load-bearing hypothesis.  The formal conclusion is

\[
 QDM(X_-)
 \cong QDM(X_+)\oplus
 \bigoplus_{j=0}^{|c_S|-1}QDM(F_0)_j.              \tag{5}

Shen--Shoemaker's center asymptotics and common-sector condition likewise
apply componentwise.  All components have identical ranks and hence one
common admissible sector.  The fixed-sector Artin receiver used in the C907
simple-wall rank theorem therefore upgrades (5) to the same oriented rank
identity.

## 4. Rank consequence for the six-point wall

For (3), equation (5) has two copies of `QDM(pt)` for every one of the six
components, hence twelve point packets.  Choose the Gamma point class at a
point in the common open complement.  Its Fourier/Kirwan lift restricts to
zero on every middle component.  The ambient coordinate is the exact unit
column, while every exceptional component is supported and has rank zero.
Thus

\[
 \mathfrak r_Y|_{P_6(Y)}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_{Y^+}|_{P_6(Y^+)}\ne0.                \tag{6}

This is the first negative-contact-budget Gold peak closed without a
K-positive carrier face.

## 5. Boundary

The mechanism applies to any finite disjoint union of split standard-flip
centers with equal normal ranks and one extremal class.  It does not cover:

- components with different discrepancies sharing a wall parameter;
- nonsplit or merely toroidal weighted normal models;
- singular chamber quotients;
- an AKMW peak whose common refinement has more than one interacting
  exceptional class.

The next smallest target is therefore a negative-budget peak with a smooth
connected center and nonsplit standard-flip normal data, or a weighted
toroidal wall.  Gu--Yu--Yu's arbitrary global standard-flip statement is
conjectural, so this is a real boundary.

## EJ / TT / AA

- **EJ:** the value `-2` in (2) predicts a `(1,3)` flip, and the local normal
  bundle makes that prediction exact.
- **TT:** six components do not mean six analytic continuation variables;
  they form one repeated exponential block over the single extremal ray.
- **AA:** extend the point-row theorem next to nonsplit connected standard
  flips, not to arbitrary AKMW walls at once.

## Sources and derivations

- Blanc--Lamy, arXiv:1409.7778, Lemma 2.10 for the six lines through a
  general point; cached SHA-256
  `de33c70c6b0a1274fa1779b315304c4bccbe89bff094e58af46713e90e28c1cd`.
- Gu--Yu--Yu, arXiv:2508.15770v1, Assumption 3.15, Proposition 5.9, and
  Theorem 6.2; cached SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
- The normal elementary transform, projection contraction, and
  finite-disconnected extension in Sections 1--3 are the derivations of this
  note, not statements quoted verbatim from those sources.
