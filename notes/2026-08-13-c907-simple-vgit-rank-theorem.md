# C907 — Gamma-rank invariance for a simple VGIT wall

Date: 2026-08-13

Status: unconditional Gamma-rank theorem for one smooth-projective simple
VGIT wall.  The distinguished ambient point coordinate is exact.  Gu--Yu--Yu Lemma 3.27
gives a common-point lift with zero wall restriction; Lemma 5.10 and
Proposition 5.9 kill both that lift's negative-chamber correction and its
wall-frequency derivative after extremal specialization; the positive
Fourier--Novikov equation and regular-singular uniqueness then kill the
entire positive-chamber tail.  Possible center coordinates are not claimed
to vanish; oriented Gamma/Euler orthogonality makes them invisible to the
rank row.  The smallest valid toric local model confirms the ambient result
term by term.  Gold still needs geometric coverage of the singular/toroidal
peaks outside these hypotheses.

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

## 2. The exact ambient common-point coordinate

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

exactly, not only to leading order.  Lemma 5.8 gives only

\[
 \operatorname{FT}_{X_+}(a_x)=[x_+]+O(S_{F_0}). \tag{5}
\]

The tail in (5) vanishes.  First apply Lemma 5.10 to `lambda a_x`.  Its wall
restriction is still zero, while

\[
 \kappa_{X_-}(\lambda a_x)
 =\kappa_{X_-}(\lambda)[x_-]=0
 \tag{6}
\]

by degree.  More precisely, Definition 5.1 and Proposition 5.2 place the
source in a finite-free completed module over
`C[z]((S_{F_0}^{-1/(2c_{F_0})}))[[Q_W,theta]]`.  Theorem 5.5/Proposition 5.9
is an isomorphism over this ring, so it remains an isomorphism after the
honest base change `Q_W=theta=0`.  Lemma 5.10 and (6) therefore force
`lambda a_x=0` in that specialized completed source module.  Its positive
and continuous Fourier images consequently vanish.

Propositions 4.14(2) and 4.21 identify the positive image with the wall
Novikov equation

\[
 \operatorname{FT}_{X_+}(\lambda a_x)
 =(zS\partial_S+D\star_S)\operatorname{FT}_{X_+}(a_x).
 \tag{7}
\]

The target point class is horizontal for the pure wall ray: every nonzero
multiple of the contracted fibre class is supported on the exceptional
locus and misses the chosen point.  Lemma 5.13 identifies `theta=0` with the
unshifted negative-chamber bulk point and shows that the pulled-back
positive-chamber mirror coordinate has no unit component.  Its
positive-degree terms also annihilate the point, classically by degree and
quantumly by the same exceptional-support argument.  Thus `[x_+]` satisfies
the same pulled-back equation (7).

Let the first possible term of the difference in (5) be `S^k v_k`, `k>0`.
The coefficient recursion begins with

\[
 (k\,\mathrm{id}+z^{-1}(D\cup-))v_k=0.
 \tag{8}
\]

Here `D\cup-` is nilpotent, so the displayed operator is invertible over
`C(z)`.  This contradiction, followed inductively, kills the entire tail:

\[
 \boxed{\operatorname{FT}_{X_+}(a_x)=[x_+].} \tag{9}
\]

Thus the ambient projection of the Gu--Yu--Yu comparison has the exact point
coordinate

\[
 \boxed{\operatorname{pr}_{X_+}\Phi([x_-])=[x_+].} \tag{10}
\]

No claim is made here that the center coordinates of `Phi([x_-])` vanish.
The condition `a_x|_{F_0}=0` kills their classical leading terms, but
Proposition 4.11 applies stationary phase to `M_W(theta)a_x`; positive
master-Novikov terms can survive as positive `S_{F_0}` powers.  What vanishes
exactly is every Fourier component of `lambda a_x`, by the completed-source
argument above.  This distinction is harmless for rank because the center
blocks are dealt with by oriented orthogonality in the next section.

The use of the specialized completed source is essential.  A raw equivariant
cohomology polynomial need not survive `Q_W=theta=0`; Proposition 5.9 and
Lemma 5.10 show precisely that `lambda a_x` does not.

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

At the extremal fibre the remaining oriented pairings are categorical:

\[
 \operatorname{rk}(\operatorname{FM}(E))=\operatorname{rk}(E),
 \qquad
 \operatorname{rk}(\Phi_j(F))=0.
 \tag{11}
\]

The first equality holds because the Fourier--Mukai correspondence is an
isomorphism on the common dense open set.  For the second, choose the point
off the exceptional locus.  Then `chi(O_x,Phi_j(F))=0`;
Shen--Shoemaker's common-sector asymptotics and the standard Gamma pairing
identify this Euler orthogonality with vanishing of the point functional on
every center Gamma block.  This uses exponential-block mismatch and the
`z -> e^{-pi i}z` pairing flip, not vanishing of the unmeasured center
coordinates in (10).

No full formula
`Psi_GYY(s(E))=s(FM(E))` for arbitrary `E` is asserted.  Equation (10) is the
strictly weaker ambient coordinate needed here.  Since the equal-dimensional
Gamma, grading, and Chern-class factors act identically on the top class,
pairing preservation gives ordinary rank on the ambient copy; the preceding
oriented orthogonality independently kills every wall copy.

## 4. Rank-Boolean theorem

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
 \tag{12}
\]

A single smooth-projective simple VGIT wall crossing satisfies

\[
 \boxed{
 \mathfrak r_{X_-}|_{P_6(X_-)}\ne0
 \iff
 \mathfrak r_{X_+}|_{P_6(X_+)}\ne0.}
 \tag{13}
\]

This is the desired peak lemma for the smooth
simple-VGIT/standard-flip class.  The formal input is stronger than
Shen--Shoemaker alone, because (1) restores the full ambient QDM rather than
leaving the ambient atom confluent at the extremal fibre.  The exact ambient
coordinate plus oriented center orthogonality supplies the only Gamma row
used.

## 5. Why this is not yet Gold

Wlodarczyk's birational cobordism expresses birational geometry through
`C^*` wall crossings, but the quotients occurring in a general cobordism can
have finite-quotient or toroidal singularities.  Gu--Yu--Yu assume the two
simple VGIT quotients are smooth projective.  Resolving/destacking a singular
wall reintroduces blowup receivers, and no cited theorem says that the
Gamma-rank realization is coherent through the resulting chain.

Thus the exact ambient-coordinate theorem and the discrepancy-one repair form a
paper-shaped stepping stone regardless of Gold.  The remaining Gold gate is
geometric coverage: prove that the fivefold factorization can use only
smooth-projective simple walls, extend the theorem to its finite-quotient or
toroidal walls, or prove the peak lemma directly for the exchanges left by
resolution.

## 6. Minimal toric regression

The smallest valid test is the discrepancy-one local flip from Gu--Yu--Yu
Section 6.4.  Let `G=(C^*)^2` act on

\[
 V_+\oplus V_-\oplus\mathbf C,
 \qquad \dim V_+=2,\quad\dim V_-=3,
 \tag{14}
\]

with weights `(1,0)`, `(0,-1)`, and `(1,-1)`.  Its smooth quotient fourfolds
are

\[
 X_+=\mathbf P_{\mathbf P^1}(\mathcal O\oplus\mathcal O(-1)^{\oplus3}),
 \qquad
 X_-=\mathbf P_{\mathbf P^2}(\mathcal O\oplus\mathcal O(-1)^{\oplus2}).
 \tag{15}
\]

Write `H,K` for the divisor classes of the two characters and `A=H+K`.
Then

\[
 H^*(X_+)=\mathbf C[H,K]/(H^2,AK^3),\qquad [pt]=AHK^2.
 \tag{16}
\]

The pure-wall toric `I`-series is

\[
 I_+=\sum_{d\ge0}S^d
 \frac{\prod_{m=0}^{d-1}(K-mz)^3}
      {\prod_{m=1}^d(H+mz)^2}.
 \tag{17}
\]

Shift covariance makes the degree-`d` point coefficient proportional to

\[
 A(H+dz)(K-dz)^2
 \frac{\prod_{m=0}^{d-1}(K-mz)^3}
      {\prod_{m=1}^d(H+mz)^2}.
 \tag{18}
\]

Every `d>=1` term contains `AK^3=0`; hence (9) holds term by term.  This is
the exact minimal regression.

## 7. AA / EJ / TT

- **AA:** avoid arbitrary Gamma classes; the common-point lift is singled out
  by zero wall restriction, its wall derivative dies after the exact
  extremal specialization, and the unmeasured center coordinates are removed
  by oriented orthogonality rather than asserted to vanish.
- **EJ:** the valid toric model proves more than leading-unit behavior: the
  relation `AK^3=0` kills every positive point coefficient uniformly in
  degree.
- **TT:** raw equivariant nonvanishing is irrelevant after completed-base
  specialization.  The inverse Fourier map, not the raw cohomology ring,
  decides which vectors survive the extremal receiver.

## Mystery ledger

- **Settled:** the ambient point tail vanishes exactly in every valid simple
  wall, and independently term by term in the smallest toric model.
- **Settled:** Lemma 5.10 gives the negative-chamber point exactly, while
  Shen--Shoemaker/Gamma orthogonality makes every center block rank-invisible.
- **Not claimed:** the center coordinates of the transported point section
  themselves may contain positive wall-parameter terms.
- **Settled:** full Gamma-integral compatibility is stronger than required;
  the distinguished rank row is proved directly.
- **Open:** smooth-projective simple-wall coverage of the peaks needed for
  Gold, or an orbifold/toroidal extension.  This is the sole remaining gate
  in this route.

## Sources and reading boundary

- Z. Gu, S. Yu, T. Y. Yu, *Quantum cohomology of variations of GIT quotients
  and flips*, arXiv:2508.15770, selectively read through the Introduction,
  Sections 3.5--3.6, 4.3--4.4, 5.2, and 6.1--6.2; cached SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
- Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
  flips*, arXiv:2502.08762v2, Theorem 1.4 and Corollary 1.5; cached SHA-256
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
