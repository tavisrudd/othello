# C925 -- power-image shadows and the exact extension leakage

**Lane:** cubic-threefolds

**Status:** formal categorical theorem proved and finitely replayed; geometric
QDM provider open

## Outcome

The strict operation-framed biproduct in Module 24 is stronger than the
Jordan endpoint contradiction needs.  For the threshold-\(m\) consumer, the
whole extension class can be replaced by one canonical snake-lemma boundary.

For a short exact sequence of \(K[N]\)-modules

\[
0\to A\to B\to E\to0,
\qquad N^mE=0,
\]

define

\[
\operatorname{Top}_m(V)=N^mV
\]

and

\[
\tau_m:E\to A/N^mA,
\qquad
\tau_m(e)=N^m\widetilde e\bmod N^mA.
\]

Then

\[
0\to\operatorname{Top}_m(A)
\to\operatorname{Top}_m(B)
\to\operatorname{im}\tau_m\to0.
\]

Consequently,

\[
\tau_m=0
\iff
\operatorname{Top}_m(A)\xrightarrow{\sim}\operatorname{Top}_m(B).
\]

This is the exact weakening:

- a full split comparison is unnecessary;
- harmless nonsplit extensions may survive;
- every extension component which can create a block longer than \(m\) is
  retained by \(\tau_m\).

No unconditional \(m=2\) or all-\(m\) theorem follows.  The geometric task is
now to construct the actual short exact QDM sequence, prove its actual
exceptional quotient is killed by \(N^m\), and kill this one boundary.

The result is promoted as Module 25 of
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md.

## The categorical theorem

Let \(\mathcal A\) be an abelian category and let

\[
\eta:\operatorname{Id}_{\mathcal A}\Rightarrow
\operatorname{Id}_{\mathcal A}
\]

be a natural endomorphism.  Its image defines an additive functor

\[
\operatorname{Top}_\eta(A)=\operatorname{im}\eta_A.
\]

For a short exact sequence

\[
0\to A\to B\to E\to0
\]

with \(\eta_E=0\), the snake lemma supplies

\[
\partial_\eta:E\to\operatorname{coker}\eta_A.
\]

The image of this boundary is exactly the quotient

\[
\operatorname{Top}_\eta(B)/\operatorname{Top}_\eta(A).
\]

This proves both the transport criterion and its naturality.

There is a symmetric form for the opposite orientation

\[
0\to E\to B\to A\to0,
\qquad \eta_E=0.
\]

Its boundary is

\[
\partial_\eta^{\mathrm{op}}:\ker\eta_A\to E,
\]

and zero opposite boundary is equivalent to
\(\operatorname{Top}_\eta(B)\xrightarrow{\sim}
\operatorname{Top}_\eta(A)\).  The orientation matters: a triangle or a
Grothendieck-group identity alone does not choose either exact interface.

For fixed \(A,E\), the assignment from an extension to its boundary is an
additive obstruction map

\[
\beta_{\eta;A,E}:
\operatorname{Ext}^1(E,A)
\to
\operatorname{Hom}(E,\operatorname{coker}\eta_A).
\]

The full extension is therefore replaced by a Hom-valued sparse shadow.
Its kernel is exactly the extension information which the endpoint proof may
forget.

## Explicit \(K[t]\) calculation

Let \(J_a=K[t]/(t^a)\).  Write

\[
0\to J_b\to B_x\to J_a\to0
\]

for the extension represented by

\[
x\in\operatorname{Ext}^1(J_a,J_b)
\cong K[t]/(t^{\min(a,b)}).
\]

With a cyclic lift satisfying \(t^av=x\),

\[
\tau_m(\bar1)=t^{m-a}x\bmod t^mJ_b
\qquad(m\ge a).
\]

If \(m\ge\max(a,b)\), then

\[
\tau_m=0
\iff
v_t(x)\ge a+b-m,
\]

and

\[
\operatorname{rank}\tau_m
=\max(0,a+b-m-v_t(x)).
\]

This classifies exactly which nonsplit cyclic extensions are dangerous.

### The \(m=2\) table

| quotient \(J_a\) | submodule \(J_b\) | nonzero extension | \(\tau_2\) |
|---|---:|---|---|
| \(J_1\) | \(J_1\) | \(J_2\) | zero; harmless |
| \(J_2\) | \(J_1\) | \(J_3\) | nonzero |
| \(J_1\) | \(J_2\) | \(J_3\) | nonzero |
| \(J_2\) | \(J_2\) | \(J_4\) or \(J_3\oplus J_1\) | nonzero |

Thus Module 25 permits the first row and rejects exactly the rows which can
manufacture the source \(J_3\).

More generally,

\[
0\to J_1\to J_{m+1}\to J_m\to0
\]

has nonzero \(\tau_m\), while any extension with \(a+b\le m\) is invisible to
\(\operatorname{Top}_m\).  Against an already-retained \(J_{m+1}\), the
obstruction map

\[
\operatorname{Ext}^1(J_\ell,J_{m+1})
\to
\operatorname{Hom}(J_\ell,J_{m+1}/t^mJ_{m+1})
\]

is injective for \(1\le\ell\le m\).  The construction therefore does not
hide a load-bearing source-center extension.

## The ExactTop provider

For one occurrence-indexed weak-factorization path, an ExactTop provider
consists at each forward blowup of:

1. an actual short exact sequence in one common operation-framed exact
   category, in one of the two oriented forms
   \[
   0\to V_Y\to V_{\widetilde Y}\to E_\pi\to0
   \quad\text{or}\quad
   0\to E_\pi\to V_{\widetilde Y}\to V_Y\to0;
   \]
2. the actual quotient exponent certificate
   \[
   N^mE_\pi=0;
   \]
3. the corresponding zero-boundary certificate
   \[
   \tau_{\pi,m}=0
   \quad\text{or}\quad
   \tau^{\mathrm{op}}_{\pi,m}=0;
   \]
4. compatibility with the selected primitive character and every
   occurrence specialization.

The top-image isomorphism is canonical at every forward blowup.  Its inverse
handles the corresponding blowdown, and composition transports the shadow
along the chosen zigzag.  One contradiction path does not require global
path independence.  A functor on all paths still requires
pseudonaturality and Beck--Chevalley coherence.

An associated-graded center list is not enough.  The module \(J_{m+1}\) has a
filtration with \(J_m\) and \(J_1\) subquotients, both killed by \(N^m\), but
the actual module is not killed.  The exponent certificate must concern the
actual exceptional quotient.

## Effect on \(m=2\)

The operation-framed \(m=2\) route is reduced to

\[
\operatorname{Top}_2(J_3)\cong K
\]

at the source, zero at the projective endpoint, and at every fivefold
blowup, one of the two oriented ExactTop interfaces.  For example:

\[
0\to V_Y\to V_{\widetilde Y}\to E_\pi\to0,
\qquad
N^2E_\pi=0,
\qquad
\tau_{\pi,2}=0.
\]

For the opposite orientation, interchange the subobject and quotient and
use \(\tau^{\mathrm{op}}_{\pi,2}=0\).  With only a vector-space splitting of
the displayed orientation,

\[
N_{\widetilde Y}
=
\begin{pmatrix}N_Y&\delta\\0&N_E\end{pmatrix},
\qquad
\tau_{\pi,2}\sim N_Y\delta+\delta N_E
\pmod{N_Y^2V_Y}.
\]

This is intrinsic despite the chosen splitting.  It is a cross-extension
second composite, not an \(\operatorname{Ext}^2\)-class.

The threefold carrier theorem remains: the actual exceptional quotient must
be square-zero.  The strict-splitting theorem is replaced by the single
second-composite boundary.

This is a genuine but limited improvement.  At \(m=2\), the obstruction map
is injective on every dangerous cyclic pair.  The missing geometry has not
vanished; it has been projected onto its exact load-bearing component.

## Highest-value geometric specialization

The best candidate is an oriented Orlov or recollement heart, using the
opposite exact orientation.

Suppose the operation-framed analytic comparison lands in an exact
\(K[N]\)-linear heart \(\mathcal A_{\mathrm{op-fr}}\) where:

- \(E_\pi\) lies in the exceptional or boundary-supported component;
- \(\ker N^m_{V_Y}\) lies in the ambient component; and
- the comparison supplies
  \(0\to E_\pi\to V_{\widetilde Y}\to V_Y\to0\).

Then

\[
\operatorname{Hom}_{\mathcal A_{\mathrm{op-fr}}}
  (\ker N^m_{V_Y},E_\pi)=0,
\]

so \(\tau^{\mathrm{op}}_{\pi,m}=0\) without splitting the packet.

The standard Orlov order is
\(\langle\text{exceptional},\text{ambient}\rangle\), so
semiorthogonality kills ambient-to-exceptional maps.  This is precisely the
variance of the opposite boundary, not the first boundary.  The Hom must be
taken in the enriched operation-framed heart: after forgetting to plain
finite nilpotent \(K[N]\)-modules, every two nonzero objects have a nonzero
map.  The missing step is to lift the analytic QDM/Rees/Stokes comparison
into that oriented exact heart while keeping the same nilpotent operation.
Algebraic semiorthogonality alone does not type the analytic boundary.

A nearby-cycle version uses a boundary-supported exceptional object and a
clean ambient intermediate extension.  The image of \(\tau_m\) would be a
boundary-supported subobject of the clean ambient quotient and hence zero.
The earlier punctual Fourier countermodel shows that support alone is
insufficient; cleanliness is load-bearing.

## Line-bundle and base-ideal interpretation

For the framed operator

\[
N_L=1-\tau_L,
\]

projection formula makes the rational \(K_0\) comparison block diagonal when
\(L\) descends.  If those component maps admit a compatible exact
cyclotomic realization, the boundary then vanishes before forgetting to the
nilpotent module.  The algebraic splitting by itself does not supply that
analytic exact lift.

The Rees/base-ideal problem can now be stated more economically:

1. construct the cyclotomic operation-framed short exact sequence;
2. prove \(N_L^2E_\pi=0\) for its actual exceptional quotient; and
3. kill \(\tau_{\pi,2}\).

The old demand that every nonsplit cyclotomic extension vanish was too
strong.  Only the Bockstein which changes \(N_L^2V\) matters.

Equivalently,

\[
\tau_m=0
\iff
N^m(B/N^mA)=0.
\]

Thus the extension pushed out along \(A\to A/N^mA\) must descend to a module
over \(K[t]/(t^m)\); it need not split there.

## Effect on all \(m\)

For the binary source,

\[
\operatorname{Top}_m(J_{m+1})\cong K.
\]

An ExactTop provider on any one cofinal fixed-factor family proves
irrationality on that unbounded family, and the upward-closure theorem then
gives every stabilization index.

The power image at a fixed threshold is only the final consumer.  It is not
by itself a monoidal source provider:

\[
D=N_V\otimes1+1\otimes N_W,
\qquad
D^m=\sum_{i=0}^m\binom mi
  N_V^i\otimes N_W^{m-i}.
\]

The complete \(N\)-image filtration with its induced \(N\)-maps and
diagonal-operation compatibility, or the corresponding structured Rees
object, is one sufficient source provider, but it is not necessary.  If
\(N_i^{a_i+1}=0\), \(A=\sum_i a_i\), and \(D=\sum_i N_i\) acts diagonally,
then

\[
D^A=\binom{A}{a_1,\ldots,a_r}\bigotimes_i N_i^{a_i},
\qquad D^{A+1}=0.
\]

Thus in characteristic zero the nilpotence ceilings, the extremal top
images, and diagonal-operation compatibility already compute the source
top line.  Separately, zero leakage at threshold \(m\) is stable after
tensoring by a factor killed at level \(k+1\), provided the threshold is
shifted to \(m+k\).  It is not stable under arbitrary tensoring at the same
threshold.

There is also a one-way threshold law: \(\tau_m=0\) and \(N^mE=0\) imply
zero leakage at every threshold \(r\ge m\); lower thresholds need not vanish.

## Relation to the rank-row route

The two surviving approaches are parallel sparse-shadow interfaces:

| route | retained object | defect |
|---|---|---|
| rank row | \(V/\ker r\) | \(\delta_\Phi=r_+\Phi|_{\ker r_-}\) |
| power image | \(N^mV\) | \(\tau_m:E\to A/N^mA\) |

Both replace a rich comparison by one natural Hom-valued obstruction.
Reader carries the occurrence environment; indexed State transports the
retained row or image; Writer records the leakage; a lens reads only its
vanishing; and a path functor maps the geometric zigzag to the retained
state.

The rank route remains higher EV overall because it avoids the universal
threefold carrier theorem and is naturally uniform in \(m\).  The power-image
route is now the optimal formulation of the independent Jordan programme.

## Other specializations

The construction applies to any natural polynomial \(\eta=p(T)\), including
a character projector followed by \(N^m\).

- In a semisimple or split spectral category, every boundary vanishes.
- Character, grading, or weight separation can force the target Hom-space to
  vanish.
- Support-versus-generic orthogonality can do the same in a localization or
  recollement heart.
- Exact flat scalar extension preserves the boundary.
- Compatible exact duality pairs the two primitive-character checks.
- Baer additivity turns a collection of local residues into one linear
  Hom-space calculation.

Guéré and BFGMP fit the split spectral skeleton after their own comparison
providers separate the evaluated blocks.  Their operation is not the
line-bundle loop producing the cubic \(J_3\), so this does not solve \(m=2\).

The current KKPYY chemical formula is not itself an ExactTop
specialization: it retains split atom multiplicities but no exact sequences
or nilpotent operation.  An Ext-enriched KKPYY theory would map to this
framework, while forgetting to the chemical formula would erase precisely
the nonsplit \(J_3\) leakage.

## Finite validation

The shared categorical replay now has sixty-two checks.  Its
Module-25-specific exact checks:

1. enumerate cyclic extensions with \(1\le a,b\le m\le5\) and verify that
   the rank increase of \(N^mV\) equals
   \(\max(0,a+b-m-v_t(x))\);
2. distinguish the hostile \(J_3\) extension from the harmless nonsplit
   \(J_2\) extension at \(m=2\); and
3. verify that adding a harmless nonsplit \(J_2\) beside a retained \(J_3\)
   changes the full Jordan type but leaves \(\operatorname{Top}_2\)
   unchanged;
4. exhaust finite cyclic zero-leakage cases under tensor products at the
   shifted threshold; and
5. verify the extremal multinomial identity for heterogeneous Jordan
   factors.

This is finite algebraic evidence only.  It does not test the QDM exact
sequence, the carrier exponent certificate, or analytic boundary vanishing.

## EJ / TT closeout

### Extra juice

- The strictness gate is a Bockstein-zero theorem, not a splitting theorem.
- The obstruction is additive under Baer sum, so a residue calculation can
  target one Hom-space instead of a full Stokes matrix.
- Orlov semiorthogonality in the opposite exact orientation is the most
  promising imported categorical law.
- The pushed-out \(K[t]/(t^m)\)-module criterion gives an equivalent
  truncated formulation which may be easier to construct geometrically.
- The source computation can be compressed to nilpotence ceilings,
  extremal top images, and diagonal-product compatibility; full Rees data is
  sufficient but not necessary.

### TT warning

Do not call ordinary Stokes, Hodge, weight, or associated-graded strictness
the required strictness.  The required law is strictness for the
\(N\)-image filtration, equivalently \(\tau_m=0\).  None of the other
filtrations formally implies it.

## Mystery ledger

| mystery | status | exact gate |
|---|---|---|
| Is full splitting necessary? | **settled: no** | Theorem 25.2; only \(\tau_m\) is seen by the endpoint |
| Can harmless nonsplit extensions remain? | **settled: yes** | \(J_2\) at threshold \(m=2\) has zero leakage |
| Can a dangerous \(J_3\) extension evade the shadow? | **settled: no** | cyclic formula and finite replay |
| Is an associated-graded center bound sufficient? | **settled: no** | \(J_{m+1}\) filtered by \(J_m,J_1\) |
| Can Orlov semiorthogonality kill the boundary? | **conditionally yes, with opposite orientation** | realize the QDM comparison as \(0\to E\to B\to A\to0\) in the enriched operation-framed heart |
| Can boundary support alone kill it? | **settled: no** | punctual Fourier countermodel; cleanliness is needed |
| Does the ExactTop source need another augmentation? | **settled: no** | \(\chi\), \(N\), nilpotence ceilings, extremal top images, and diagonal-product compatibility suffice; the missing enrichment is provider-side typing |
| Does ExactTop remove the threefold carrier gate? | **settled: no** | actual \(N^2E_\pi=0\) remains required |
| Does it make the rank route obsolete? | **settled: no** | rank avoids the carrier theorem and remains higher EV |
| What is the next concrete calculation? | **open** | compute \(\tau_{\pi,2}\) for the base-ideal or normal-splitting Rees sequence |

## Boundary

The image-shadow, snake-boundary, cyclic-classification, and conditional
telescope theorems are proved.  The ExactTop QDM provider is not constructed.
No paper or Lean source was edited, and no unconditional \(m=2\) or stable
irrationality claim is made.
