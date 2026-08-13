# C907 — surface ordinary-flop Gamma extension specification

Date: 2026-08-13

Status: publishable strengthening, no longer on the Gold critical path.  In dimension
five, the formerly unresolved crepant semi-free standard wall is an ordinary
`P^1`-bundle flop over a smooth projective surface.  LLW supply the full
genus-zero quantum-ring/ancestor continuation, but not the two-point
large-radius calibration measured by the C907 Gamma rank row.  Chen--Tseng
prove exactly that Gamma/Fourier--Mukai calibration for a single simple flop
and state that their method extends to split ordinary flops, without carrying
out the proof.  Completing this advertised extension gives the full
K-theoretic Gamma theorem.  The point/rank row is already closed by the
support-plus-divisor argument in
`2026-08-13-c907-ordinary-flop-point-row-theorem.md`.

## 1. Target theorem

Let `S` be a smooth projective surface and let `F,F'` be rank-two vector
bundles on `S`.  Let

\[
 Z=P_S(F)\subset Y,
 \qquad
 N_{Z/Y}\cong O_{P(F)}(-1)\otimes\pi^*F',          \tag{1}
\]

and assume the ordinary flop

\[
 Y\dashrightarrow Y'
\]

has smooth projective endpoints.  Let `W` be the common blowup and

\[
 \mathrm{FM}=R(p_{Y'})_*Lp_Y^*:K(Y)\to K(Y').     \tag{2}
\]

The desired statement is that, after LLW analytic continuation in the one
extremal variable, there is a degree-preserving symplectic quantum-D-module
gauge `U` such that

\[
 U\Psi^Y(E)=\Psi^{Y'}(\mathrm{FM}(E))              \tag{3}
\]

for every topological K-class `E`, where `Psi` is the Gamma framing.  The
gauge must intertwine the full formal nonextremal Novikov connection and be
independent of the quantum variables, exactly as in Chen--Tseng's simple
case.

For C907 it is enough to prove (3) for `E=O_y` with `y` in the common open,
together with preservation of the flat pairing and the `z=0` formal packet.
The full K-theoretic theorem is the cleaner publishable statement.

## 2. Why LLW alone is insufficient

LLW Theorem 0.1.1 identifies big quantum rings and generating functions of
primary and ancestor invariants after extremal continuation.  Their
Definition 1.3 requires at least three primary insertions, and the paper
explicitly says descendant invariance fails.  The Gamma point flat section is
calibrated by the two-point descendant `S`-operator.  Consequently quantum
ring and ancestor invariance do not identify the two large-radius
normalizations; the missing transition is precisely (3).

This is the same frame distinction as the false C907 Gold proof.  A constant
graph gauge identifies the small `z=0` connections and their formal packets,
but does not identify the large-`z` Gamma point column across the two Novikov
boundaries.

## 3. Proof architecture already present in the sources

Chen--Tseng prove (3) for a single simple `P^r` flop by:

1. deforming the global flop to its projective local model;
2. separating the identity block from the local exceptional block;
3. applying the toric local Gamma/Fourier--Mukai square of CIJ;
4. using independence of `U` from all quantum variables to restore the
   formal nonextremal directions.

For (1), the deformation-to-the-normal-cone special fibre has the same
identity component plus the projective local ordinary-flop model

\[
 P_{P(F)}\bigl(O\oplus O(-1)\otimes\pi^*F'\bigr)
 \dashrightarrow
 P_{P(F')}\bigl(O\oplus O(-1)\otimes\pi'^*F\bigr). \tag{4}
\]

Thus only the local block changes.  For split bundles
`F=L_1\oplus L_2`, `F'=M_1\oplus M_2`, Chao--Chen--Tseng's toric-stack-bundle
theorem supplies the Gamma/FM Mellin--Barnes square over `S`.  The Fourier
kernel is fibrewise, while base Novikov variables remain formal.  Equation
(3) follows for the split local block and hence for the split global flop.

## 4. Nonsplit reduction and exact remaining lemma

LLW's quantum splitting principle resolves rational flags of `F,F'`, lifts
the required blowups to the total geometry, deforms the pulled-back bundles
to sums of line bundles, and proves ordinary-flop GW invariance by
degeneration.  What it does not state is preservation of the Gamma/FM
calibration through that reduction.

The exact missing lemma is:

> **Gamma-calibrated splitting lemma.**  In LLW's flag-resolution and
> extension-scaling family, the Chen--Tseng/CCT local gauge and the
> Fourier--Mukai transform commute with smooth pullback, the inserted
> blowup correspondences, and specialization.  Therefore the split
> Gamma/FM square descends to the original rank-two bundles.

This lemma is substantially smaller than a general Gamma/Orlov blowup
theorem.  The family is smooth proper with fixed base; the K-class `O_y` can
be represented off every exceptional and degeneration locus; and the
relevant local transformation is independent of all quantum variables.  For
the C907 point-only version, every inserted exceptional term has zero rank,
so it suffices to control the common-open point column rather than the full
K-lattice.

## 5. Finite disconnected bases

If `S` is a finite disjoint union of smooth projective surfaces, all steps
above are orthogonal direct sums over its components.  They share one
extremal variable when the fibre classes are numerically equal; repeated
exponential factors are retained as one regular block.  Thus the theorem
should be stated for finite disconnected `S` from the start.  This includes
the six-curve Geiser middle flop after product with `P^2`, already proved
separately by the componentwise Chen--Tseng extension.

## 6. C907 consequence

For a point `y` in the common open,

\[
 \mathrm{FM}(O_y)=O_{y'}.
\]

Equation (3) transports the normalized Gamma point section exactly.  The
symplectic pairing identifies its restriction with the rank covector, and
the regular quantum-D-module gauge transports the total generalized
primitive-sixth packet.  Hence

\[
 \mathfrak r_Y|_{P_6(Y)}\ne0
 \Longleftrightarrow
 \mathfrak r_{Y'}|_{P_6(Y')}\ne0.                 \tag{5}
\]

Landing the target theorem upgrades the already closed `(2,2,2)` rank row to
a full Gamma/K-theoretic correspondence.  The only Gold-relevant standard
residue is the nonprimitive/weighted `(1,2)` curve flip.

## EJ / TT / AA

- **EJ:** the missing object is one two-point calibration, not the quantum
  product; that is exactly why LLW plus Chen--Tseng fit together.
- **TT:** ancestor invariance does not imply descendant `S`-operator
  invariance.  Treating it as such recreates the false frame transport.
- **AA:** prove the point-only Gamma-calibrated splitting lemma first.  If it
  fails, exhibit the first flag-resolution correction to `O_y`; if it lands,
  the full K-square is a natural extension rather than a prerequisite for
  Gold.

## Sources

- Lee--Lin--Qu--Wang, arXiv:1401.7097, Theorem 0.1.1 and Sections 1.2--1.3;
  cached SHA-256
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- Chen--Tseng, arXiv:2604.09962v1, Theorem 0.2, Section 3, and Remark 3.1;
  cached SHA-256
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Chao--Chen--Tseng, arXiv:2410.22670v2, Theorem 0.1, for split toric stack
  bundles.
- Coates--Iritani--Jiang, arXiv:1410.0024, Theorems 6.1 and 6.3, for the
  local toric Gamma/FM gauge.
