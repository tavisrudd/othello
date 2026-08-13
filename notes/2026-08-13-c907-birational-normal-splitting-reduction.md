# C907 — birational normal-splitting reduction

Date: 2026-08-13

Status: exact geometric reduction.  The relative-cap point-purity gate below
has been superseded for the Gold rank-functional route by the oriented
ambient-pairing reduction in `2026-08-13-c907-gold-relative-cap-attack.md`.
It remains relevant to the stronger point-covector theorem.  In
the fivefold weak-factorization problem, an arbitrary codimension-two
threefold center can be modified until its rank-two normal bundle has a full
line filtration, without introducing any center carrying primitive-sixth
formal monodromy.  The remaining step is deformation/degeneration invariance
of the exceptional point-purity covector.

## 1. Birational splitting of the normal bundle

Let \(Z\subset Y\) be a smooth codimension-two center in a smooth projective
fivefold, and let \(N=N_{Z/Y}\).  Apply Lee--Lin--Qu--Wang, Lemma 1.8.1, to
the rank-two bundle \(N\to Z\).  Resolving the rational section of the flag
bundle \(\operatorname{Fl}(N)\to Z\) gives a sequence

\[
 Z'=Z_s\longrightarrow\cdots\longrightarrow Z_0=Z
 \tag{1}
\]

of blow-ups in smooth centers \(T_i\subset Z_i\), such that the pullback of
\(N\) has a filtration

\[
 0\longrightarrow L_1\longrightarrow\pi^*N
 \longrightarrow L_2\longrightarrow0.
 \tag{2}
\]

Every nontrivial \(T_i\) has dimension at most two.  Lemma 1.8.2 deforms
(2), with base \(Z'\) fixed, to the split bundle \(L_1\oplus L_2\) by scaling
its extension class to zero.

## 2. Lifting the modification to the ambient arrow

Blow up \(Y_i\) in the same \(T_i\subset Z_i\subset Y_i\), and let
\(Z_{i+1}\subset Y_{i+1}=\operatorname{Bl}_{T_i}Y_i\) be the strict
transform.  For nested smooth centers, the two orders of blow-up have a
common smooth model:

\[
 \operatorname{Bl}_{Z_{i+1}}\operatorname{Bl}_{T_i}Y_i
 \cong
 \operatorname{Bl}_{\mathbf P(N_{Z_i/Y_i}|_{T_i})}
            \operatorname{Bl}_{Z_i}Y_i.
 \tag{3}
\]

On the right, the second center is the **dominant transform** of \(T_i\):
because \(T_i\subset Z_i\), it is the scheme-theoretic inverse image
\(\mathbf P(N_{Z_i/Y_i}|_{T_i})\), not the empty strict transform.  Formula
(3) is the two-element nested-building-set case of order independence for
wonderful blow-ups.

The normal bundle on the strict transform is the pullback normal bundle up
to the common exceptional line twist:

\[
 N_{Z_{i+1}/Y_{i+1}}
 \cong \pi^*N_{Z_i/Y_i}\otimes\mathcal O_{Z_{i+1}}(-E_i).
 \tag{4}
\]

Thus the filtration in (2) persists after the ambient modifications.

The new center on the right of (3) is a \(\mathbf P^1\)-bundle over
\(T_i\).  Since \(\dim T_i\le2\), C907's projective-bundle formula and the
low-dimensional theorem give

\[
 \nu_6\bigl(\mathbf P(N|_{T_i})\bigr)=2\nu_6(T_i)=0.
 \tag{5}
\]

The centers \(T_i\) themselves also have \(\nu_6=0\).  Therefore all arrows
inserted by (3) are invisible to the already landed framed formal-monodromy
**multiplicity** invariant, and no threefold carrier enters the formal packet
comparison.

This does not by itself transport the rank covector.  A Stokes-small center
solution with a different formal exponential can still alter the Gamma lift
of an ambient primitive-sixth branch without changing its formal-monodromy
multiplicity.  The point-purity lemma in Section 3 must therefore apply also
to the inserted \(T_i\)- and \(\mathbf P(N|_{T_i})\)-center arrows.  Their
low-dimensional/projective-bundle form makes them simpler regressions, not
automatic ones.

## 3. Analytic step for the stronger point-purity theorem

The filtration (2) is not the global **nef** complete-intersection hypothesis
of `2026-08-13-c907-ci-blowup-point-purity.md`; it deforms only to an arbitrary
split normal bundle.  This distinction is load-bearing.  Deformation to the
normal cone for \(Z'\subset Y'\) replaces
the embedding by its local model

\[
 \mathbf P_{Z'}(N_{Z'/Y'}\oplus\mathcal O).
 \tag{6}
\]

Lee--Lin--Qu--Wang use exactly birational splitting, deformation to the
normal cone, degeneration formulae, and relative ancestor invariants to
transport ordinary-flop GW invariance from split to nonsplit bundles.  Their
theorem does not state the needed C907 conclusion.  The missing lemma is:

> **Relative-cap point-purity lemma.** After deformation to the normal cone,
> every relative gluing channel of the large-radius Gamma point section
> reorganizes by its nonnegative contact orders into an exponential times a
> polynomial.  Hence its forbidden exceptional-center Stokes coefficient is
> zero, independently of the signs of the split normal-line degrees.

The contact-order formulation is stronger than merely preserving the landed
split-nef theorem.  A naive substitution of negative normal-line degrees into
the Kummer slice does not terminate: for
\((a_\beta,b_\beta)=(-1,0)\),

\[
 \sum_{k\ge0}\frac{k!}{k!(k+1)!}R^k
 =\frac{e^R-1}{R},
\]

so multiplication by \(e^{-R}\) leaves a nonzero \(-e^{-R}/R\) branch.  Thus
the degeneration formula must replace raw line degrees by relative contact
orders or exhibit cancellations among its channels; ordinary bundle splitting
alone does not reach the known Kummer zero.

If the relative-cap lemma holds for every arrow in the splitting diagram,
(1)--(6) reduce an arbitrary codimension-two center to universal terminating
fibre kernels.  Combined
with the rank-framed theorem and the fivefold center-dimension audit, this
proves \(X\times\mathbf P^2\) irrational for every smooth cubic threefold.
It does **not** prove all stabilizations: for \(m>2\), weak factorization can
introduce higher-dimensional centers, the subcenters used to split their
normal data need not have empty primitive-sixth packet, and higher-codimension
exceptional strings require additional control.

The lemma is smaller than Gamma/Orlov compatibility: it concerns one
distinguished covector and only the relative gluing terms generated by the
normal-splitting process.  It is not automatic from deformation invariance
of ordinary GW invariants.  A Stokes coefficient can vary under analytic
continuation unless the fixed phase and integral point section are tracked
through the degeneration.

## Sources

- Yuan-Pin Lee, Hui-Wen Lin, Feng Qu, and Chin-Lung Wang, *Invariance of
  quantum rings under ordinary flops: III*, arXiv:1401.7097, Lemmas 1.8.1
  and 1.8.2 and Sections 1.6--1.8, for birational bundle filtration,
  deformation to a split bundle, and the degeneration framework.  Cached
  PDF SHA-256:
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- Li Li, *Wonderful compactification of an arrangement of subvarieties*,
  arXiv:math/0611412, Definition 2.7 and Theorem 1.3, for dominant transforms
  and order independence of the nested blow-ups in (3).  Cached PDF
  SHA-256:
  `ee9716e639b40ae0a59cc7073cdcc5c816106f412280e76f5206d4d67b7698b9`.
- `2026-08-11-c907-v1-framed-fractional-support.md` for low-dimensional
  primitive-sixth vanishing and projective-bundle multiplicativity.
- `2026-08-13-c907-ci-blowup-point-purity.md` for the exact split Kummer
  endpoint.

## AA / EJ / TT and mystery ledger

- **AA:** do not split a normal bundle by passing to its flag bundle, which
  changes dimension.  Resolve the rational flag section by blow-ups of the
  center and lift those blow-ups to the ambient variety.
- **EJ:** nested-blowup commutation makes every correction center a
  \(\mathbf P^1\)-bundle over a surface, curve, or point.  C907 already knows
  all such formal packets are empty, so the birational splitting process adds
  no carrier.  Rank-covector purity on those arrows remains an analytic
  regression.
- **TT:** a filtration is not a split bundle and normal crossing is not split
  normal bundle.  The deformation-to-normal-cone gluing is the load-bearing
  step; deformation invariance of scalar GW invariants alone does not control
  a framed Stokes coefficient.
- **Settled:** arbitrary normal bundles acquire a line filtration after
  ambient modifications invisible to formal multiplicity; the filtered
  bundle deforms to split; exact nested-center dimension and packet audit.
- **Open:** the relative-cap point-purity lemma with fixed phase, ancestor-to-
  Gamma comparison, and relative gluing.  Its proof or first counterexample is
  the highest-EV C907 Gold move.  The arbitrary split endpoint is part of this
  gate; it is not supplied by the split-nef theorem.
