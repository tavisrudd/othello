# C907 — Gamma-rank invariance for a simple VGIT wall

Date: 2026-08-13

Status: formal one-wall theorem with an exact counterexample to the proposed
Gamma point-row shortcut.  Gu--Yu--Yu retain the full opposite-chamber QDM,
but in the smallest toric discrepancy-one flip their ambient Fourier image
of a common point has a necessarily nonzero positive-wall-parameter tail.
The rank-Boolean theorem therefore remains conditional on a weaker
Stokes/rank-row statement; a full Gamma/Fourier comparison is still stronger
than needed.

## 1. Source theorem

Let

\[
 X_-\dashrightarrow X_+
\]

be a simple reductive VGIT wall crossing with smooth projective quotients and
smooth wall `S`, in the sense of Gu--Yu--Yu, and suppose `r_+<r_-`.  Put
`nu=r_--r_+`.  Their Theorem 1.2/Theorem 6.2 gives, after a formal coordinate
change, a pairing-preserving isomorphism of full quantum D-modules

\[
 \operatorname{QDM}(X_-)
 \cong
 \operatorname{QDM}(X_+)\oplus
 \bigoplus_{j=0}^{\nu-1}\operatorname{QDM}(S)_j
 \tag{1}
\]

over a common exceptional-Laurent, ambient-Novikov-completed ring.  Unlike an
extremal spectrum calculation, (1) retains the full ambient Novikov variables
of `X_+`; an internal cubic atom on that side is therefore not collapsed.

The construction comes from one smooth projective three-component master
space and equivariant Fourier transformations.  Lemmas 5.7--5.8 compute the
leading terms.  On the ambient summand the leading cohomological map is the
graph correspondence

\[
 \varphi:H^*(X_+)\hookrightarrow H^*(X_-),
 \tag{2}
\]

while every wall summand is represented by a class pushed forward from the
exceptional locus.  Consequently, for a point chosen in the common open
set, (2) sends its point class to the point class and all wall columns have
rank zero.

## 2. The common-point column and its forced tail

Choose a point `x` in the common open set, outside the two exceptional loci.
Gu--Yu--Yu Lemma 3.27 supplies a unique equivariant lift `a_x` such that

\[
 \kappa_{X_+}(a_x)=[x_+],\qquad
 \kappa_{X_-}(a_x)=[x_-],\qquad a_x|_{F_0}=0.
 \tag{3}
\]

Set the master Novikov variables and bulk variables to zero, retaining the
wall variable `S_{F_0}`.  Since the wall restriction is zero, the hypothesis
of Gu--Yu--Yu Lemma 5.10 is automatic and gives

\[
 \operatorname{FT}_{X_-}(a_x)=[x_-] \tag{4}
\]

exactly, not only to leading order.  Every continuous Fourier transform to a
wall copy is also exactly zero, by Proposition 4.11 and
`a_x|_{F_0}=0`.  Lemma 5.8 gives only

\[
 \operatorname{FT}_{X_+}(a_x)=[x_+]+O(S_{F_0}). \tag{5}
\]

The tempting claim that the tail in (5) vanishes is false.  The target point
class is horizontal for the pure wall ray because every positive wall-degree
stable map lies in the exceptional locus and misses it.  The master lift
`a_x`, however, is not a horizontal section.  Proposition 4.14(2) and
Proposition 4.21 give

\[
 \operatorname{FT}_{X_+}(\lambda a_x)
 =(zS\partial_S+D\star_S)\operatorname{FT}_{X_+}(a_x).
 \tag{6}
\]

Thus regular-singular uniqueness cannot be applied to the difference in
(5) unless `FT_{X_+}(lambda a_x)=0`, which need not hold.

It fails already in the smallest toric model.  Take

\[
 W=\mathbf P(\mathbf C_0\oplus\mathbf C_{+1}^2\oplus
 \mathbf C_{-1}^3),
 \tag{7}
\]

write `u=c_1^{C^*}(O(1))`, and choose a coordinate common-open orbit line.
Up to the harmless exchange of the two weight signs, its lift is

\[
 a_x=u(u+\lambda)(u-\lambda)^2,
 \quad
 H^*_{C^*}(W)=
 \mathbf C[u,\lambda]/(u(u+\lambda)^2(u-\lambda)^3).
 \tag{8}
\]

The restriction at the wall point `u=0` is zero, but
`lambda a_x` is nonzero: it has polynomial degree five, below the degree-six
relation.  Every continuous wall component of `lambda a_x` is zero.  Since
`FT_{X_+} direct-sum FT_{F_0,0}` is injective by Proposition 5.9,

\[
 \operatorname{FT}_{X_+}(\lambda a_x)\ne0. \tag{9}
\]

If (5) had no tail, the right side of (6) would vanish by the target-point
support argument, contradicting (9).  Therefore

\[
 \boxed{\operatorname{FT}_{X_+}(a_x)-[x_+]\ne0.} \tag{10}
\]

This is a counterexample to the direct point-column shortcut, not to the
desired rank Boolean.  Homogeneity forces the `S^k` coefficient of the tail
to carry compensating positive `z`-degree in this discrepancy-one model.
Whether that tail is invisible on the primitive-sixth Stokes packet is the
new sharply localized question.

The sharp grading statement is explicit.  Here `deg S=-2`, `deg z=2`, the
point lift has degree eight, and `X_+` is a fourfold.  If

\[
 \operatorname{FT}_{X_+}(a_x)-[x_+]
 =\sum_{k\ge1}S^k f_k,
 \tag{11}
\]

then homogeneity and `H^d(X_+)=0` outside `0<=d<=8` give

\[
 f_k\in z^k\bigl(H^8\oplus zH^6\oplus z^2H^4
                 \oplus z^3H^2\oplus z^4H^0\bigr).
 \tag{12}
\]

Thus the tail vanishes in the naive `z=0` associated graded.  This is not
enough for the actual Boolean.  Over the Laurent field, `z` is a unit.  For
example, the regular-singular connection with fundamental matrix

\[
 \begin{pmatrix}1&0\\ z&1\end{pmatrix}
 \operatorname{diag}(z^{1/6},1)
 \tag{13}
\]

has primitive-sixth line generated by `e_1+ze_2`; the covectors `e_2^*` and
`e_2^*-ze_1^*` differ by a `z`-divisible tail but restrict respectively
nontrivially and trivially.  A valuation gap, or direct annihilation of the
tail on `P_6`, is required.

## 3. Sectorial identification

A simple VGIT wall crossing is a standard flip.  Shen--Shoemaker's Theorem
1.4 and Corollary 1.5 identify the Gamma classes of the Fourier--Mukai image
of `D^b(X_+)` with the tame block and the Gamma classes of the wall functors
with the nonzero exponential blocks.  The `nu=1` omission in their printed
proof is repaired by the exact order calculation in
`2026-08-13-c907-shen-shoemaker-codim2-repair.md`; the repair actually covers
all `r=s+1`, `s>=1` standard flips.

Fix a nonzero exceptional parameter and retain all other Novikov variables
formally.  The Artin-quotient sectorial receiver of
`2026-08-13-c907-formal-novikov-sectorial-receiver.md` applies to (1): the
comparison gauge is positive in `z`, the closed-fibre exponential blocks are
the Shen--Shoemaker blocks, and a common sector has width greater than `pi`.
Uniqueness identifies the Gu--Yu--Yu formal **submodules** with those
sectorial Gamma spans.  Joint flatness and pairing compatibility make every
value of the point covector on a horizontal block section constant in the
ambient Novikov variables.

At the extremal fibre the remaining pairings are categorical:

\[
 \operatorname{rk}(\operatorname{FM}(E))=\operatorname{rk}(E),
 \qquad
 \operatorname{rk}(\Phi_j(F))=0.
 \tag{14}
\]

The first equality holds because the Fourier--Mukai correspondence is an
isomorphism on the common dense open set.  The second holds because every
wall image is supported on the exceptional locus.  Equivalently, the Gamma
point pairing restricts to the `X_+` rank pairing and kills all `S` blocks.

No full formula
`Psi_GYY(s(E))=s(FM(E))` for arbitrary `E` is asserted.  Pairing preservation
would turn its point-pairing row into the desired rank covector, but the
forced tail (10) shows that this row does not follow from the common-point
cohomology lift.  Pairing the tail with the primitive-sixth packet is exactly
the datum still missing.

## 4. Conditional rank-Boolean corollary

Let `P_6` denote the whole generalized primitive-sixth formal-monodromy
packet in the chosen receiver, and let

\[
 \mathfrak r_T(v)=(-1)^{\dim T}[s(\mathcal O_t),v)
\]

be the Gamma rank covector.  Restricting the whole-block identities after
they have been established gives

\[
 \mathfrak r_{X_-}|_{P_6(X_+)_\mathrm{amb}}=\mathfrak r_{X_+},
 \qquad
 \mathfrak r_{X_-}|_{P_6(S)_j}=0.
 \tag{15}
\]

If the nonzero tail (10) is rank-invisible on the primitive-sixth packet, or
if the weaker Gamma rank-row compatibility is supplied, a single
smooth-projective simple VGIT wall crossing satisfies

\[
 \boxed{
 \mathfrak r_{X_-}|_{P_6(X_-)}\ne0
 \iff
 \mathfrak r_{X_+}|_{P_6(X_+)}\ne0.}
 \tag{16}
\]

This would be the desired peak lemma for the smooth
simple-VGIT/standard-flip class.  The formal input is stronger than
Shen--Shoemaker alone, because (1) restores the full ambient QDM rather than
leaving the ambient atom confluent at the extremal fibre.  Equations
(7)--(10) show that the missing row is a genuine datum, not merely an absent
citation.

## 5. Why this is not yet Gold

Wlodarczyk's birational cobordism expresses birational geometry through
`C^*` wall crossings, but the quotients occurring in a general cobordism can
have finite-quotient or toroidal singularities.  Gu--Yu--Yu assume the two
simple VGIT quotients are smooth projective.  Resolving/destacking a singular
wall reintroduces blowup receivers, and no cited theorem says that the
Gamma-rank realization is coherent through the resulting chain.

Thus the formal decomposition, the forced-tail counterexample, and the
discrepancy-one repair form a paper-shaped stepping stone regardless of Gold.
Gold reduces further to one of:

1. prove the forced positive-`z` tail is rank-invisible on `P_6`;
2. compute its first nonzero row on a product carrying the cubic packet and
   test the Boolean directly;
3. prove the weaker Gamma rank-row compatibility by a master-space contour
   or K-theoretic Fourier argument.

## 6. Minimal toric regression

The smallest nontrivial test is the discrepancy-one flip from the master

\[
 W=\mathbf P(\mathbf C^2_{+1}\oplus\mathbf C_0\oplus
 \mathbf C^3_{-1}). \tag{12}
\]

Its wall is a point and its smooth quotient fourfolds are

\[
 X_+=\mathbf P_{\mathbf P^1}(\mathcal O\oplus\mathcal O(-1)^{\oplus3}),
 \qquad
 X_-=\mathbf P_{\mathbf P^2}(\mathcal O\oplus\mathcal O(-1)^{\oplus2}).
 \tag{13}
\]

For a common torus-fixed point, the orbit-line lift is (8).  In Gu--Yu--Yu's
Proposition 5.9 matrix both off-diagonal blocks are `O(S)` and the constant
matrix is `diag(Id,-Id)` (the sign depends on the Fourier square-root
choice).  Equation (9) proves that its `O(S)` ambient point correction is
genuinely nonzero.  This model is therefore the first exact point-row
falsifier.

## 7. AA / EJ / TT

- **AA:** compute the first nonzero `S` coefficient of (10), then tensor the
  flip with a cubic threefold so the same coefficient can be paired against
  an actual primitive-sixth packet.
- **EJ:** the counterexample is structural: injectivity forces nonzero
  leakage without computing any Fourier coefficient.  It turns the source's
  unspecified star into a theorem-level obstruction.
- **TT:** the point class on the quotient and its equivariant master lift are
  different differential objects.  Support makes the former horizontal; it
  says nothing of `lambda a_x`, which controls the latter through (6).

## Mystery ledger

- **Settled negatively:** the `O(S)` ambient leakage in the smallest toric
  point column is nonzero.
- **Settled:** zero wall restriction still kills every center Fourier row
  exactly and Lemma 5.10 gives the negative-chamber point exactly.
- **Open:** whether homogeneity's compensating positive `z`-degree makes the
  forced tail invisible on the primitive-sixth rank Boolean.  Divisibility
  alone does not; the owning next computation is the first `S` coefficient,
  preferably after product with a cubic packet.
- **Open:** full Gamma-integral compatibility remains stronger than required;
  only its rank row is on the C907 critical path.

## Sources and reading boundary

- Z. Gu, S. Yu, T. Y. Yu, *Quantum cohomology of variations of GIT quotients
  and flips*, arXiv:2508.15770, selectively read through the Introduction,
  Sections 3.5--3.6, 4.3--4.4, 5.2, and 6.1--6.2; cached SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
- Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
  flips*, arXiv:2502.08762v2, Theorem 1.4 and Corollary 1.5; cached SHA-256
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
