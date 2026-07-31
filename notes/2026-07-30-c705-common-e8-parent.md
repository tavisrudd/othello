# C705 — common affine-\(E_8\) parent of the Segre--Igusa sisters

**Date:** 2026-07-30  
**Status:** exact positive operator lift  
**Scope:** C682's paired binary-icosahedral McKay towers and their first
balanced degree-ten six-axis slice

## Verdict

The conjectural strengthening is positive, with one essential naming
boundary:

> The Segre and Igusa polar systems are **affine-\(E_8\) operator shadow
> sisters**.  They are the two null projections of one mixed differential
> obtained from C682's paired-McKay degree-ten return.

This theorem itself concerns the binary-icosahedral affine-McKay package
already fixed in C682.  A subsequent alternative-attack pass found a
separate, genuine Lie-\(E_8\) ambient route through the
\(\mathfrak{sl}_9\oplus\bigwedge^3 9\oplus\bigwedge^6 9\) Vinberg grading
and the Coble dual pair.  Its strict marked \(q,W,A\) comparison remains
open; see `notes/2026-07-30-c705-lie-e8-alt-attacks.md`.

## The parent tensor and differential

Let \(X\) be the six oriented axes in C682's degree-ten slice and
\(\mathcal T\) the six outer synthematic totals.  Write
\[
 A_X=\mathbf Z^X/\mathbf Z\mathbf1,\qquad
 A_{\mathcal T}=\mathbf Z^{\mathcal T}/\mathbf Z\mathbf1.
\]
C682's paired return
\[
 \widehat T_{10}=
 \widehat\Delta_{10}^{\dagger}\widehat\Delta_{10}
\]
reconstructs the integral conference operator \(C\), with \(C^2=5I\), on
the six-axis lattice.  Its six outer conjugates give
\[
 K_T=*\bigwedge\nolimits^3 C_T,\qquad
 Z_T(x)=\frac14\sum_{\lvert S\rvert=3}(K_T)_{SS}x_S.
\]
Thus the return supplies one cubic tensor
\[
 Z\in\operatorname{Sym}^3(A_X^\vee)\otimes A_{\mathcal T}
\]
with the required signed outer action.

Pairing this tensor with the dual outer carrier gives the universal
potential
\[
 \boxed{\quad
 \mathscr P(x,\eta)=\langle\eta,Z(x)\rangle.
 \quad}                                                \tag{1}
\]
In quotient bases \(x_5=-\sum_{i<5}x_i\) and
\(\eta_5=-\sum_{T<5}\eta_T\), this is
\[
 \mathscr P(x,\eta)=
 \sum_{T<5}\eta_T\bigl(Z_T(x)-Z_5(x)\bigr).
\]
Its mixed Hessian is exactly the C705 matrix:
\[
 \frac{\partial^2\mathscr P}
 {\partial x_i\,\partial\eta_T}
 =
 \frac{\partial}{\partial x_i}(Z_T-Z_5)
 =A_{iT}.                                             \tag{2}
\]

The two sisters are not appended to (1).  They are recovered as its two
generic null projections:
\[
 q(x)=\operatorname{center}_X(x^2),\qquad
 q(x)^{\mathsf T}A(x)=0,
\]
\[
 W(x)=\operatorname{center}_{\mathcal T}(Z(x)^2),\qquad
 A(x)W(x)=0.                                         \tag{3}
\]
Since \(A\) has generic rank four, these lines are the complete left and
right kernels.  Therefore the highest nonzero compound of the same mixed
differential is
\[
 \boxed{\quad
 \operatorname{adj}A(x)=6W(x)q(x)^{\mathsf T}.
 \quad}                                               \tag{4}
\]
Equations (1)--(4) are the requested common lift of \(q,W,A\).  Shared
\(S_6\) symmetry alone would not imply them.

## Simultaneous branching

Both five-dimensional carriers occur inside the one degree-ten package.

1. The six axis decimics \(z_a=q_a^5\) span
   \(\mathbf3\oplus\mathbf3'\).  Their integral support lattice gives
   \(A_X\), and the return reconstructs \(C\) on it.
2. The middle-exterior operator \(K=*\bigwedge^3C\) reconstructs its own
   twenty-triple Johnson support scheme modulo \(2\).
3. The six outer conjugates of that recovered operator are indexed by
   \(\mathcal T\); their augmentation is the outer five-space
   \(A_{\mathcal T}\).
4. Diagonal contraction of those six operators is the tensor \(Z\).
   Differentiation, rather than a new representation-theoretic
   identification, produces the mixed carrier \(A\).

Thus the standard and outer five-spaces are present simultaneously as the
source support and outer-conjugate augmentation of one operator orbit.
The degree-ten slice is essential.  C704's bounded later-slice census found
no canonical six-atom lattice on later balanced McKay multiplicity spaces,
so the construction does not propagate by abstract multiplicity alone.

## Strata and bad characteristics upstairs

The exceptional \(10|15|6\) geometry is recovered from the operator support,
not from an asserted Lie-\(E_8\) root-subsystem dictionary.

- The ten Segre nodes are indexed by complementary pairs of triples in the
  recovered \(J(6,3)\) support.  Their ten \(3+3\) source points are exactly
  the rank-one locus of the mixed Hessian.
- The fifteen Segre planes and dual Igusa singular lines are indexed by the
  fifteen matchings/synthemes of the recovered six-axis set.
- The six nodes of each Clebsch hyperplane section are the rank-one
  cross-golden-block points attached to the six axes themselves.
- In characteristic \(2\), the Johnson support still survives but all
  orientation signs coalesce.
- In characteristic \(3\), the scalar \(6\) kills the fourth-compound
  extraction and the generic mixed rank drops from four to three.
- In characteristic \(5\), the golden projectors ramify, but the descended
  potential and its adjugate identity retain generic rank four.

This is the exact support/discriminant lift requested by the task.  Calling
these strata \(E_8\) root strata would overstate the result.

## Converse and propagation

The parent is recoverable from either presentation.  The mixed potential
determines its six cubic coefficients \(Z_T\) up to the common augmentation
relation.  C691's converse theorem reconstructs the unique golden conference
switching class from the resulting orientation cubic.  Hence (1) recovers
the degree-ten conference algebra, though not the entire all-degree Weyl
operator \(\widehat\Delta\).

Conversely, C682's all-degree restriction-of-scalars operator commutes with
\(J^2=5\), and its degree-ten conference lattice produces (1) functorially.
Later degrees carry the same descended golden algebra but do not acquire
new shadow potentials without an additional support lattice.  The shadow
therefore propagates through the paired towers as an algebra, while its
Segre--Igusa geometry is localized at the first balanced six-axis slice.

## Reproduction

Primary exact checker:

```sh
cd /home/tavis/src/othello/rust
python3 ../notes/2026-07-30-c705-common-e8-parent.py --check
```

The checker imports the committed C704 and C705 exact engines.  It rebuilds
the conference middle-exterior orbit, the 90-term augmentation-quotient
potential, all 25 mixed-Hessian entries, the five source and five target
quadratic null identities, the generic rank-four witness, the
characteristic \(2,3,5,7\) ranks, and all 25 adjugate entries.  The
machine-readable certificate records the two carriers, parent potential,
support recovery, strata dictionary, and scope boundary.

Independent evidence is supplied by the already committed replay surfaces:

```sh
python3 ../notes/2026-07-30-c682-golden-e8-descent-replay.py
python3 ../notes/2026-07-30-c704-segre-igusa-operator-shadow-replay.py
python3 ../notes/2026-07-30-c705-adjugate-segre-igusa-polar-replay.py
```

They independently check the degree-ten conference spectral ratio, the
operator-derived Segre--Igusa formulas, and the complete polynomial
adjugate identity over finite fields.  The new checker composes those
interfaces; it does not claim to be an independent reimplementation of all
three.

The adjacent `.sha256` manifest records hashes and byte counts for this
report, checker, JSON certificate, and the Lie-\(E_8\) alternative-attack
note.  This is a paper-independent research result and makes no novelty or
publication-priority claim.

## Literature boundary

No new external theorem is imported.  The exact \(E_8\) input is C682's
task-owned golden descent and all-degree Weyl descent.  The classical
Segre--Igusa and outer-\(S_6\) facts remain sourced as in the proportional
audit in `notes/2026-07-30-c705-adjugate-segre-igusa-polar.md`.

The situational sweep found \(E_6\), \(A_2\)-ball, type-IV, Coble, and
homological parents, but no source giving this paired-McKay mixed potential.
That bounded observation remains a search lead, not an absence or priority
claim.

## Final `ej` and `tt` passes

- **ej:** the potential has converse content.  Its cubic coefficient tensor
  reconstructs the golden conference switching class, so the common parent
  is not merely a convenient packaging of already-named kernels.
- **ej:** the bad primes separate three layers cleanly: support orientation
  at \(2\), compound extraction at \(3\), and golden splitting at \(5\).
  This explains why the descended sister identity is still healthy at the
  golden ramification prime.
- **tt:** the correct exceptional label is “affine-\(E_8\) operator
  sisters.”  The strongest true statement uses the paired McKay return and
  its recovered six-axis lattice; replacing it by a generic
  \(E_6\subset E_8\) or Lie-\(E_8\) slogan would lose the proof.
- **tt:** (1) is the minimal parent.  Its first mixed differential is \(A\);
  its two null projections are \(q,W\); and its highest nonzero compound is
  (4).  No additional ambient variety is required.

## Mystery ledger

- **Settled:** both polar five-spaces occur simultaneously in the specific
  paired-\(E_8\) degree-ten package.
- **Settled:** one cubic tensor \(Z\), equivalently its universal potential
  \(\mathscr P\), produces \(A,q,W\) and the rank-one adjugate.
- **Settled:** the ten nodes and fifteen plane/line pairs are recovered
  support/discriminant strata.
- **Settled:** the prime \(3\) is an adjugate/compound defect, distinct from
  the support defect at \(2\) and golden splitting defect at \(5\).
- **Positive feasibility, separate route:** the Vinberg
  \(\bigwedge^3 9\) grading gives a genuine Lie-\(E_8\) ambient Coble
  parent, and the Coble fixed section gives Segre--Igusa.  Recovering the
  frozen marked Joubert tensor from the same trivector is the remaining
  strict operator gate.
- **Settled boundary:** later balanced McKay slices lack the canonical
  six-atom support needed to repeat the construction functorially.
- **Open only under the stronger Lie-\(E_8\) naming gate:** identify the
  stable trivector's ordered Weierstrass marking with C704's frozen
  Joubert tensor.  Formula-level publication priority, the marked comparison
  with C695's particular double-six, and optional preprojective/categorical
  upgrades belong to separately gated successors.
