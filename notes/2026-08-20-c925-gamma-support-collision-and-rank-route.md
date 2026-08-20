# Module 33. Gamma support collision and the rank-row replacement

**Packet part:** Module 33.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** support/Gamma incompatibility and rank algebra proved from the
audited C907 inputs; fixed-phase blowup transport remains conditional

## 33.1 Two different consumers need two different source interfaces

The question “is the QDM source sufficient?” has a route-dependent answer.

For the ExactTop route, yes.  The source interface

\[
(V_\chi,N),\qquad N^{m+1}=0,\qquad N^mV_\chi\ne0
\tag{33.1}
\]

is sufficient for the endpoint contradiction.  Modules 24--28 consume no
point row, Gamma lattice, or integral basis on the source.  Their missing
input is comparison-side: an occurrence-indexed operation realization and
ExactTop transport.

For the rank route, bare formal QDM is not sufficient.  A sufficient reduced source
interface is instead

\[
(V_\chi,\rho_\chi),
\qquad
0\ne\rho_\chi:V_\chi\longrightarrow K,
\tag{33.2}
\]

where \(V_\chi\) is a fixed-phase Gamma-integral lift of the
primitive-sixth sector and \(\rho_\chi\) is ambient rank.  The phase and row
are genuine augmentation data.  A point marking, full Gamma lattice, full
Stokes matrix, and full \(K_0\) object are not consumed by the final
telescope.

## 33.2 The point regression rules out naive center-null Gamma projection

The exact Barnes/central-connection computation in
notes/2026-08-13-c907-point-gamma-primary-nonvanishing.md proves that, for a
point \(p\) on a smooth cubic threefold \(X\),

\[
\operatorname{pr}_{\chi}s_X(\mathcal O_p)\ne0
\tag{33.3}
\]

on both primitive-sixth formal branches.  The independent numerical
Kuznetsov calculation gives the same obstruction categorically: the
projected point class is nonzero in the residual primitive-sixth sector.

### Proposition 33.1 -- support/Gamma incompatibility

There is no objectwise exact assignment \(\mathcal R_\chi\) which
simultaneously has all three properties:

1. it is zero on every category or object supported in dimension at most
   two;
2. its ambient realization is ordinary primitive-sixth Gamma projection;
3. its Gysin map sends the intrinsic point class to the ordinary ambient
   Gamma class of its pushforward.

#### Proof

Apply the three properties to \(i:p\hookrightarrow X\).  Property 1 sends
the intrinsic point class to zero.  Properties 2--3 send its Gysin image to
\(\operatorname{pr}_\chi s_X(\mathcal O_p)\), which is nonzero by (33.3).
\(\square\)

### Corollary 33.1A -- exact scope of Module 32

The whole-center-null receiver in Corollary 32.2A cannot be ordinary
ambient Gamma projection, nor ordinary residual-category projection.  It
would have to be a new relative framed localizing quantum motive with a
corrected Gysin transformation.  The correction defect on a point must
cancel the nonzero central-connection coefficient (33.3), with its sign
fixed by the convention for corrected-minus-ordinary Gysin.

Thus Module 32 proves the universal correction-side factorization, but does
not make the center-null specialization more likely than the C907 point
regression permits.

## 33.3 Rank is compatible with the point regression

The same point calculation that obstructs annihilation identifies the
cheaper surviving row.  If \(B_a=s(E_a)\) is either fixed-phase
primitive-sixth Gamma branch, Iritani's pairing gives

\[
[s(\mathcal O_p),B_a)
=\chi(\mathcal O_p,E_a)
=-\operatorname{rk}(E_a)\ne0.
\tag{33.4}
\]

Hence both source branches have nonzero rank.  Nonvanishing of the point
central charge is evidence *for* the rank consumer, not a defect of it.

### Proposition 33.2 -- Orlov rank row

For a blowup \(\pi:\widetilde Y\to Y\) of a smooth center, the Orlov
decomposition on \(K_0\) has

\[
\operatorname{rk}_{\widetilde Y}(L\pi^*x)
=\operatorname{rk}_Y(x),
\qquad
\operatorname{rk}_{\widetilde Y}
\left(i_*(p^*e\otimes\mathcal O_E(-j))\right)=0.
\tag{33.5}
\]

#### Proof

Pullback preserves generic rank.  Every exceptional Orlov image is
supported on the divisor \(E\), so its class has ambient generic rank zero.
\(\square\)

Consequently ambient rank is already an exact center-null **output row on
algebraic \(K_0\)**; it does not require the entire center packet or supported
category to vanish.  Promotion of that row through fixed-phase QDM
projection is the open analytic gate below.  This is precisely the
distinction between the valid output-kernel ideal of Module 21 and the
impossible naked support-annihilating projector.

## 33.4 Conditional uniform theorem

### Theorem 33.3 -- fixed-phase rank transport implies all stabilizations

Use the audited endpoint inputs: the cubic fixed-phase branches have
nonzero rank, the projective product law retains a nonzero source row on
\(X\times\mathbf P^m\), and projective space has empty primitive-sixth
sector.  Assume in addition one coherent fixed-phase Gamma/Orlov comparison
along every actual weak-factorization occurrence, natural under products,
with a decomposition and typed row law

\[
J_\pi:V_\chi(Y)\oplus E_\pi
\overset\sim\longrightarrow V_\chi(\widetilde Y),
\qquad
\rho_{\widetilde Y}\circ J_\pi
=c_\pi(\rho_Y\oplus0),
\qquad c_\pi\in K^\times,
\tag{33.6}
\]

where \(E_\pi\) is generated by the actual exceptional Orlov images and
\(p_Y\) is projection to the ambient summand.  Then

\[
X\times\mathbf P^m\text{ is irrational for every }m\ge0
\tag{33.7}
\]

for every smooth cubic threefold \(X\).

#### Proof

Equation (33.4) gives a nonzero source rank row on the cubic sector, and the
audited product input retains it on \(X\times\mathbf P^m\).  Equation (33.6) preserves
its nonvanishing in both directions along every blowup and blowdown in weak
factorization.
Projective space has empty primitive-sixth sector, so its endpoint row is
zero, a contradiction.  \(\square\)

This is the conditional all-\(m\) theorem already isolated in C907, now
typed as the rank-row specialization of the modular packet.  It requires no
Jordan carrier bound, no whole-center nullity, and no corrected support
Gysin functor.

## 33.5 Exact remaining scalar

Formal QDM decomposition and pairing do not prove (33.6).  One necessary
exceptional-row-null scalar, branch by branch, is the vanishing

\[
[s_{\mathrm{pt}}^{\operatorname{Bl}_Z Y},
  s_{\mathrm{exc},a})=0,
\tag{33.8}
\]

with fixed phase and coherent product/composition normalization.  Equation
(33.8) says exactly that the named exceptional branch has ambient rank zero
after sectorial continuation.  To imply the full row law (33.6), it must be
combined with ambient point/rank calibration, pairing transport, a common
phase, product normalization, and composition/inverse coherence.  Even this
package is weaker than full Gamma-lattice, Stokes, or Orlov compatibility,
but stronger than Iritani's proved formal direct-sum comparison.

Module 34 observes that a single weak-factorization contradiction does not
need the full global coherence package: local row-line transport plus lawful
adjacent reindexing suffices along one chosen path.

The regression \(\operatorname{Bl}_X\mathbf P^5\) passes by the reciprocal-
Gamma zero already computed in C907.  The unresolved geometric scope is an
arbitrary normally nonsplit center occurrence and coherent composition.

## 33.6 Categorical diagram

The failed support/Gamma square is

\[
\begin{CD}
K_0(p) @>{i_*}>> K_0(X)\\
@V{0}VV @VV{\operatorname{pr}_\chi s_X}V\\
0 @>>> V_\chi(X).
\end{CD}
\tag{33.9}
\]

It cannot commute because of (33.3).  The unconditional algebraic rank law
is instead

\[
\begin{CD}
K_0(Y)\oplus E_\pi^K @>{J_\pi^K}>> K_0(\widetilde Y)\\
@V{\operatorname{rk}_Y\oplus0}VV @VV{\operatorname{rk}_{\widetilde Y}}V\\
K @= K,
\end{CD}
\tag{33.10}
\]

Here \(J_\pi^K\) is the algebraic Orlov isomorphism and \(E_\pi^K\) is the
sum of its exceptional components.  The QDM analogue is the separately
conditional square (33.6); Proposition 33.2 does not manufacture it.  In
software terms, the desired specialization is an augmented output row, not
a global support-null object functor.

## 33.7 EJ/TT and mystery ledger

**EJ.** The hostile point class chooses the better route: its nonzero Gamma
projection simultaneously kills naive support annihilation and proves the
source rank row is nonzero.

**TT.** Do not ask a functor to erase every supported object when the proof
consumes only one quotient row.  The first nontrivial geometric calculation
is the scalar (33.8), followed by its calibration and coherence laws, not
construction of a universal localizing quantum motive.

| question | status | exact evidence or gate |
|---|---|---|
| Is bare QDM source sufficient for ExactTop? | **yes** | Modules 24--28 consume only (33.1) |
| Is bare formal QDM sufficient for the rank route? | **no** | fixed phase and rank row (33.2) are genuine augmentation |
| Can ordinary Gamma projection be whole-center-null? | **no** | Proposition 33.1 and point coefficient (33.3) |
| Is the rank row nonzero on the cubic source? | **settled** | pairing identity (33.4) |
| Does rank kill actual exceptional Orlov images? | **settled algebraically** | Proposition 33.2 |
| Does each actual analytic comparison preserve that row? | **open** | scalar vanishing (33.8), calibration, and adjacent reindexing; Module 34 removes global path coherence |

## Boundary

The support collision, source rank nonvanishing, Orlov rank algebra, and
conditional telescope are proved from the audited inputs.  The fixed-phase
sectorial comparison law (33.6) remains open.  The scalar vanishing (33.8)
is its exceptional-row component and still needs the listed calibration and
coherence laws.  No unconditional \(m=2\) or all-\(m\)
theorem follows.
