# C907 — Gamma-rank invariance for a simple VGIT wall

Date: 2026-08-13

Status: formal one-wall theorem and a sharply localized Gamma gate, not yet a
Gamma-rank theorem.  Gu--Yu--Yu retain the full opposite-chamber QDM, which
removes the ambient deconfluence problem, but neither they nor
Shen--Shoemaker identify the Gu--Yu--Yu Fourier map with the Fourier--Mukai
map on the Gamma integral lattice.  Equation (5) below is conditional on that
one compatibility.

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

## 2. Sectorial identification and its exact limit

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

At the extremal fibre these constants are categorical:

\[
 \operatorname{rk}(\operatorname{FM}(E))=\operatorname{rk}(E),
 \qquad
 \operatorname{rk}(\Phi_j(F))=0.
 \tag{3}
\]

The first equality holds because the Fourier--Mukai correspondence is an
isomorphism on the common dense open set.  The second holds because every
wall image is supported on the exceptional locus.  Equivalently, the Gamma
point pairing restricts to the `X_+` rank pairing and kills all `S` blocks.

There is still a map-level gap.  Gu--Yu--Yu prove that their formal Fourier
map identifies the ambient QDM submodule; Shen--Shoemaker prove that
Fourier--Mukai Gamma classes span its extremal tame realization.  The sources
do **not** prove

\[
 \Psi_{\rm GYY}(s_{X_+}(E))=s_{X_-}(\operatorname{FM}(E)).
 \tag{3a}
\]

An automorphism of `QDM(X_+)` inside the ambient summand preserves the formal
block and all connections but can change the pullback of the rank covector on
its internal primitive-sixth packet.  The leading graph-correspondence term
of the Fourier map does not prove (3a): upgrading that cusp leading term to
the large-radius Gamma section would repeat the original two-frame error.
Thus horizontal constancy propagates (3) only after (3a), or the weaker
rank-covector version of (3a), is supplied.

## 3. Conditional rank-Boolean corollary

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
 \tag{4}
\]

If (3a), or just its point-pairing row, holds, a single simple VGIT wall
crossing satisfies

\[
 \boxed{
 \mathfrak r_{X_-}|_{P_6(X_-)}\ne0
 \iff
 \mathfrak r_{X_+}|_{P_6(X_+)}\ne0.}
 \tag{5}
\]

This would be the desired peak lemma for the smooth
simple-VGIT/standard-flip class.  The formal input is stronger than
Shen--Shoemaker alone, because (1) restores the full ambient QDM rather than
leaving the ambient atom confluent at the extremal fibre.  The remaining
analytic input is only one equivariant-Fourier Gamma row, not a
two-exceptional-cusp comparison.

## 4. Why this is not yet Gold

Wlodarczyk's birational cobordism expresses birational geometry through
`C^*` wall crossings, but the quotients occurring in a general cobordism can
have finite-quotient or toroidal singularities.  Gu--Yu--Yu assume the two
simple VGIT quotients are smooth projective.  Resolving/destacking a singular
wall reintroduces blowup receivers, and no cited theorem says that the
Gamma-rank realization is coherent through the resulting chain.

Even for several smooth simple walls, applying (5) through independently
constructed one-wall receivers requires either one common equivariant
master-space realization or the same banking theorem that failed for
independent blowup cusps.  Gu--Yu--Yu prove formal QDM and pairing
compatibility, not Gamma-integral, Stokes, or central-connection compatibility
for a multiwall master space.

Thus the GYY decomposition is a genuine positive formal peak class and a
publishable stepping stone, while (5) remains a focused conjectural
corollary.  Gold reduces further to one of:

1. Gamma-integral/rank-row compatibility (3a) for the equivariant Fourier
   transform, followed by a smooth-simple-VGIT factorization theorem adequate
   for the relative fivefold problem, with one coherent master receiver;
2. an orbifold/toroidal extension of (1), Shen--Shoemaker asymptotics, and the
   Gamma rank receiver;
3. a direct peak theorem for the non-VGIT exchanges left by resolution.

## 5. AA / EJ / TT

- **AA:** compute the point row of the equivariant Fourier transform on the
  smallest toric standard flip.  Failure there kills (5); success isolates
  singular/toroidal cobordism walls as the next target.
- **EJ:** Gu--Yu--Yu supply exactly what Shen--Shoemaker lacked: the full
  opposite-chamber QDM over the common exceptional Laurent base.  The
  extremal Gamma calculation then determines a horizontal whole-block
  covector rather than attempting to deconfluence an atom.
- **TT:** identifying a formal submodule with the span of Gamma asymptotic
  classes does not identify the two framings inside that submodule.  The
  source itself contains no Stokes or Gamma-integral comparison theorem.

## Sources and reading boundary

- Z. Gu, S. Yu, T. Y. Yu, *Quantum cohomology of variations of GIT quotients
  and flips*, arXiv:2508.15770, selectively read through the Introduction,
  Sections 3.2, 5.2, and 6.1--6.2; cached SHA-256
  `9c00f826cb13ad243bd2ad126e74733cacf650a385160a11adc785693c01a358`.
- Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
  flips*, arXiv:2502.08762v2, Theorem 1.4 and Corollary 1.5; cached SHA-256
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
