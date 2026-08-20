# Module 48. The narrow completion route is signature-free

**Packet part:** Module 48.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** adjoining the negative total character makes every wall
crepant, not merely the five quasi-symmetric unit-wall pilots.  The
Coates--Iritani--Jiang narrow/divided-rank route therefore consumes no
quasi-symmetry, total-unimodularity, unit-weight, or finite-signature
hypothesis.  What remains is the geometric total-space phase and the
occurrence-level QDM identification.

## 48.1 Canonical completion is crepant for every wall

Let a split torus \(T\) act linearly on

\[
                         W=\bigoplus_{i=1}^N\mathbf C_{\beta_i}
                                                                    \tag{48.1}
\]

and put

\[
                         \kappa=\sum_{i=1}^N\beta_i.             \tag{48.2}
\]

Define the canonical-character completion

\[
                         W^{\mathrm{can}}
                           =W\oplus\mathbf C_{-\kappa}.          \tag{48.3}
\]

### Proposition 48.1 -- universal wall crepancy

For every cocharacter \(\lambda\in X_*(T)\),

\[
 \left\langle\lambda,
        \sum_{\gamma\text{ a weight of }W^{\mathrm{can}}}\gamma
 \right\rangle=0.                                              \tag{48.4}
\]

Hence every adjacent GIT wall for \(W^{\mathrm{can}}\) satisfies the toric
crepant condition used by Coates--Iritani--Jiang.

#### Proof

The sum of the weights in (48.3) is

\[
                         \kappa-\kappa=0.
\]

Pairing with any \(\lambda\) gives (48.4).  In the divisor presentation of
a toric GIT wall, this says that the anticanonical character lies on the
wall; indeed it is zero and lies on every wall.  \(\square\)

This proposition says nothing about semistability, smoothness, the
Deligne--Mumford condition, or semi-projectivity.  It isolates crepancy only.

## 48.2 Four hypotheses which are not being used

Proposition 48.1 does not require:

1. quasi-symmetry of the original or completed weight representation;
2. total unimodularity of the weight matrix;
3. unit coefficients in a chosen rank-two wall basis; or
4. membership in Module 41's five-signature list.

Those conditions entered the earlier nonresonant
Špenko--Van den Bergh calibration route.  They are not assumptions of the
toric crepant transformation theorem used in Module 45.

The determinant-two flip--flip pilot remains a useful stacky regression,
but it is no longer an extremal case that the narrow route must classify
before proceeding.

## 48.3 Crepancy is not the total-space phase

Let \(\theta\) be a chamber character for the action on \(W\).  The quotient
of (48.3) is the desired canonical-line total space over
\([W^{\mathrm{ss}}_\theta/T]\) only if the geometric-phase equality

\[
 (W\oplus\mathbf C_{-\kappa})^{\mathrm{ss}}_\theta
                =W^{\mathrm{ss}}_\theta\oplus\mathbf C_{-\kappa}
                                                                    \tag{48.5}
\]

holds, with the expected stack quotient

\[
 [(W^{\mathrm{can}})^{\mathrm{ss}}_\theta/T]
       \cong\operatorname{Tot}
          \bigl(K_{[W^{\mathrm{ss}}_\theta/T]}\bigr).           \tag{48.6}
\]

Equation (48.4) does not imply (48.5).  Adding a weight may create new
semistable points with unstable \(W\)-coordinate and nonzero completion
coordinate.  Therefore (48.5), including its stacky stabilizers, is a
load-bearing occurrence certificate.

Likewise, (48.4) does not imply that the two completed chamber quotients are
smooth semi-projective Deligne--Mumford stacks.  Those are separate
Coates--Iritani--Jiang inputs.

## 48.4 Conditional signature-free overlap theorem

Consider one toric overlap occurrence with two adjacent chamber characters
\(\theta_-\) and \(\theta_+\).  Assume:

1. a common torus representation \(W\) and its completion (48.3) model the
   occurrence on both sides;
2. the geometric-phase identities (48.5)--(48.6) hold on both sides;
3. the completed quotients are smooth semi-projective Deligne--Mumford
   stacks in the scope of Coates--Iritani--Jiang;
4. the Shoemaker narrow realization, equivariant Thom presentation,
   Gamma framing, spanning, pairing, and exact image/coimage base change of
   Modules 45--46 all hold for the same Fourier--Mukai comparison;
5. the same comparison is identified with the common-window rank map of
   Module 43; and
6. the actual primitive cubic packet is identified with a common based loop
   or typed deck sector as in Module 47, including incoming nonvanishing and
   adjacent character reindexing.

### Theorem 48.2 -- signature-free completed-overlap adapter

Under assumptions 1--6, the overlap comparison induces an isomorphism of
primitive divided-rank coimage lines and preserves their zero/nonzero
marker.  If the narrow pairing realization is used, it also transports the
dual inverse-character shifted Thom point line.

No quasi-symmetry, total-unimodularity, unit-wall, or five-signature
hypothesis is consumed.

#### Proof

Proposition 48.1 verifies the crepant-wall hypothesis.  Assumptions 2--4
instantiate Theorem 45.3 and Proposition 45.1, giving one paired horizontal
narrow comparison which carries the compact-to-ordinary image.  Assumption
5 and Theorem 46.2 give divided-rank transport.  Assumption 6 and Theorem
47.3 restrict that law to the actual generalized primitive sector.
Corollary 46.2B or Proposition 47.2 gives the paired point-line statement.
\(\square\)

## 48.5 Consequence for the five signatures

Module 41's five signatures remain useful for:

- explicit window and valuation pilots;
- checking the determinant-two stacky case;
- comparison with the nonresonant quasi-symmetric schober theorem; and
- finite regression of chamber-selection conventions.

They are not an exhaustion theorem required by Theorem 48.2.  An actual
overlap with a different integral weight signature is admissible for the
narrow route whenever assumptions 1--6 hold.

This changes the next search.  It is lower value to classify more weight
matrices before checking (48.5) and the occurrence-level QDM realization.
The correct target is a geometric-phase/globalization theorem for the
actual toroidal overlap charts.

## 48.6 Local toric charts are not global QDM occurrences

AKMW weak factorization and torification provide local toroidal models.
That does not by itself instantiate Theorem 48.2:

- a toroidal chart may be a family over a non-toric center rather than an
  absolute quotient of a vector space;
- the chamber presentation and completion weight may vary between charts;
- local analytic continuations need overlap and exact-base-change data;
- the primitive formal sector belongs to the actual global QDM, not merely
  to one fibrewise toric model; and
- adjacent chart reindexing must preserve the divided row and map the deck
  character explicitly.

Thus “locally toric” is not a substitute for assumption 1 or 4.  A relative
toric-bundle version of the CIJ/Shoemaker comparison, or a descent theorem
from such charts, is still needed for a general occurrence.

## 48.7 Source and scope audit

Coates--Iritani--Jiang's crepant-wall condition is that the total toric
divisor/anticanonical character lies on the wall.  Their hypotheses also
include the separately retained adjacent-chamber, semi-projective, and
Deligne--Mumford conditions.  Their theorem does not assume quasi-symmetry
or total unimodularity.  Proposition 48.1 is the elementary weight
calculation which supplies only the crepant clause.

Module 41's quasi-symmetric completion classification belongs to the
Špenko--Van den Bergh nonresonant calibration branch.  No source is read as
promoting an arbitrary AKMW toroidal chart to an absolute toric QDM
occurrence or as proving (48.5).

## 48.8 EJ/TT and mystery ledger

**EJ.** The completed narrow route is not limited to five combinatorial
models.  Its crepancy certificate is the identity
\(\kappa+(-\kappa)=0\), uniformly for every wall.

**TT.** Separate the three statements which “canonical completion” had
conflated: zero total character, a genuine total-space GIT phase, and a
global narrow-QDM occurrence.  Only the first is formal; the second and
third are the real geometry.

| question | status | exact evidence or gate |
|---|---|---|
| Is every canonical-character completed wall crepant? | **yes** | Proposition 48.1 |
| Does CIJ require quasi-symmetry or TU? | **no** | source scope in Section 48.7 |
| Is every completed quotient automatically \(\operatorname{Tot}(K_X)\)? | **no** | geometric-phase gate (48.5) |
| Is a local toroidal chart automatically a global QDM occurrence? | **no** | Section 48.6 |
| Are the five signatures still a narrow-route gate? | **no** | Theorem 48.2 |
| What is the next exact theorem? | **geometric-phase/globalized narrow realization for actual overlap charts** | assumptions 1--6 |

## Boundary

Module 48 removes the finite-signature classification from the completed
narrow route.  It does not prove that arbitrary weak-factorization overlaps
admit one global toric completion, that the added coordinate stays in the
geometric phase, or that the resulting relative charts carry the actual
primitive narrow QDM.  Those geometric realization questions are now the
entire signature-free overlap frontier.

**Successor.**  Modules 49--50 show that the geometric-phase clause fails
for every five-signature pilot and cannot be repaired by any finite ordinary
multi-coordinate completion with the same torus, linearization, and raw
semistable locus.  The signature-free crepancy theorem remains valid, but its
naive total-space realization does not.
