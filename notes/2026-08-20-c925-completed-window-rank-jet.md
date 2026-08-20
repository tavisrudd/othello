# Module 43. The completed-window rank jet is universal

**Packet part:** Module 43.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the normalized first jet is proved to be the identity on the
rank coimage for every common-open completed window comparison; in
particular the coordinate-wall and determinant-two pilots give the same
unit.  Identifying this algebraic jet with the actual fixed-phase QDM
transition remains open.

## 43.1 The rank consumer removes the signature dependence

Let a split torus \(T\) act on the canonically completed representation

\[
                   W^{\mathrm{can}}=W\oplus\mathbf C_{-\kappa},
       \qquad \kappa=\sum_{w\in W}w.                            \tag{43.1}
\]

Choose two generic GIT chambers and write

\[
        \mathcal X_\pm=[(W^{\mathrm{can}})^{\mathrm{ss}}_\pm/T]. \tag{43.2}
\]

Assume that their comparison is obtained from one common grade-restriction
window.  Thus there is a category \(\mathcal G\) and restriction
equivalences

\[
 D^b(\mathcal X_-)
   \xleftarrow{\ \sim\ }\mathcal G
   \xrightarrow{\ \sim\ }D^b(\mathcal X_+)                    \tag{43.3}
\]

whose two restrictions agree on a common dense open quotient
\(\mathcal U\subset\mathcal X_-\cap\mathcal X_+\).  Let
\(\Phi:K_0(\mathcal X_-)\to K_0(\mathcal X_+)\) be the induced map and
let \(\rho_\pm\) be generic rank.

### Proposition 43.1 -- common-window comparisons preserve rank

Under (43.3),

\[
                         \rho_+\Phi=\rho_-.                     \tag{43.4}
\]

The same equation holds for the inverse comparison.  No total-unimodularity
hypothesis is required.

#### Proof

Generic rank is the Euler rank after restriction to the generic point.  The
generic point lies in \(\mathcal U\), and both legs of (43.3) are the same
restriction there.  Hence a representative and its image under \(\Phi\)
have identical restrictions to the generic point and identical Euler rank.
Applying the same argument to the opposite common window proves the inverse
statement.  \(\square\)

Equivalently, in the representation ring

\[
       R(T)=\mathbf Z[X^*(T)],\qquad
       \rho(e^\lambda)=1,                                     \tag{43.5}
\]

every character line has rank one and every positive-codimension Koszul
correction has rank zero.  Window mutations can change the supported class,
but not the quotient consumed by \(\rho\).

## 43.2 The invariant first jet

Let \(q\) be the primitive fibre-scaling character and let \(R\) be the
unramified local ring at \(q=1\), with

\[
                             s=1-q^{-1}.                        \tag{43.6}
\]

Extend rank \(R\)-linearly:

\[
 \rho_{\pm,R}:=\rho_\pm\otimes 1:
 K_0(\mathcal X_\pm)\otimes_{\mathbf Z}R\longrightarrow R.    \tag{43.6a}
\]

The equivariant canonical self-intersection operator on the plus side is

\[
                  \Theta_{q,+}=1-q^{-1}[E_+],                  \tag{43.7}
\]

where \(E_+=K_{\mathcal X_+}^{-1}\) has rank one.  Consider the completed
rank-shadow bridge

\[
       F=\Theta_{q,+}\circ\Phi:
       K_0(\mathcal X_-)\otimes R
          \longrightarrow K_0(\mathcal X_+)\otimes R.          \tag{43.8}
\]

### Theorem 43.2 -- universal completed-window jet

The bridge (43.8) satisfies

\[
                       \rho_{+,R}F=s\rho_{-,R}.                 \tag{43.9}
\]

Let

\[
 L_\pm=
 \bigl(K_0(\mathcal X_\pm)\otimes_{\mathbf Z}R\bigr)/
       \ker\rho_{\pm,R}.                                      \tag{43.10}
\]

Under the canonical rank identifications \(L_\pm\cong R\), the induced map
is multiplication by \(s\).  Consequently its raw valuation is exactly one,
its residual valuation is zero, and its first jet

\[
 \operatorname{jet}_1(F):L_-/sL_-
       \xrightarrow{\ \sim\ }sL_+/s^2L_+                     \tag{43.11}
\]

is the identity tensored with the conormal class \([s]\).

#### Proof

Proposition 43.1 and the rank-one identity

\[
                \rho_{+,R}(\Theta_{q,+}v)
                   =(1-q^{-1})\rho_{+,R}(v)
                   =s\rho_{+,R}(v)                            \tag{43.12}
\]

give (43.9).  The structure sheaf shows that each rank map is surjective, so
each extended rank map is a split surjection and the coimages in (43.10) are
free rank-one modules.  On those coimages
\(\bar\Phi=1\) and \(\bar F=s\).  Reducing the latter map modulo \(s^2\)
gives (43.11).  \(\square\)

Put \(k=R/(s)\).  The coordinate-free output is the nonzero element

\[
 \operatorname{jet}_1(F)\in
 \operatorname{Hom}_k(L_-/sL_-,L_+/sL_+)
       \otimes_k(sR/s^2R).                                    \tag{43.13}
\]

Replacing \(s\) by another primitive parameter \(t=us+O(s^2)\) multiplies
its scalar representative by a unit and its conormal generator by the
inverse unit.  Thus nonvanishing of (43.13) is intrinsic even though the
numerical normalization \(1\) uses the named generator \(s\).

## 43.3 The two requested pilot calculations

Write \(e_1=(1,0)\) and \(e_2=(0,1)\).  The simplest coordinate-wall model
from Module 41 has raw weights

\[
 \mathcal W_{\mathrm{coord}}=
 \{\pm e_1,\ \pm e_2,\ -e_1+e_2,\ 0,\ 0\},                   \tag{43.14}
\]

and the canonical completion adds \(e_1-e_2\).  The non-total-unimodular
flip--flip model has raw weights

\[
 \mathcal W_{\det 2}=
 \{\pm e_1,\ \pm e_2,\ \pm(e_1+e_2),\ -e_1+e_2\},           \tag{43.15}
\]

and again adds \(e_1-e_2\).  It contains

\[
                 \det(e_1+e_2,-e_1+e_2)=2.                    \tag{43.16}
\]

Both raw multisets have \(\kappa=-e_1+e_2\); both completions are
quasi-symmetric; and both contain the two coordinate-axis weights, so their
torus actions are faithful and have trivial generic stabilizer.  Applying
Theorem 43.2 gives the complete rank-shadow calculation

\[
\begin{array}{c|c|c|c}
\text{model}&\rho(\Theta_q)&\nu_s(F)&
      s^{-1}\bar F\bmod s\\ \hline
\mathcal W_{\mathrm{coord}}&1-q^{-1}&1&1\\
\mathcal W_{\det 2}&1-q^{-1}&1&1.
\end{array}                                                     \tag{43.17}
\]

The determinant-two pair changes stacky and supported directions but is
invisible to generic rank.  Therefore it creates no additional residual
valuation on the completed algebraic rank line.

### Corollary 43.2A -- all five signatures collapse on the rank jet

For every one of Module 41's five genuine-wall completed signatures, any
common-open window comparison satisfying (43.3) has the same first jet
(43.13).  The five-case Mellin--Barnes calculation is unnecessary for this
consumer.

#### Proof

The proof of Theorem 43.2 uses only common-open rank preservation and the
rank-one conormal factor.  Neither depends on the incidence signature.
\(\square\)

## 43.4 Normalized residual maps compose; raw orders add

Suppose completed window comparisons \(\Phi_i\) form a typed path and use
the same primitive normal line.  Write \(F_i=s\Phi_i\) on their rank
coimages.  After removing and recording the one conormal factor at each
occurrence, their normalized residual maps are identities.  Hence

\[
 \overline\Phi_n\cdots\overline\Phi_1=1,\qquad
 \overline{\Phi_i^{-1}}=\overline\Phi_i^{-1}=1.                \tag{43.18}
\]

The raw bridges themselves satisfy

\[
                    F_n\cdots F_1
        =s^n(\Phi_n\cdots\Phi_1).                              \tag{43.18a}
\]

Their first jet is zero when \(n>1\); their leading term has order \(n\) and
lives in the \(n\)-fold tensor power of the conormal line.  Similarly, a raw
bridge in the reverse direction carries its own conormal factor and is not
the inverse of the forward raw bridge.  Only the normalized residual window
map is inverted.

With arbitrary trivializations the normalized entries in (43.18) become
units and obey the usual multiplicative cocycle law.  Intrinsically they are
isomorphisms between the corresponding rank lines, while (43.18a) records
the additive valuation Writer.  Thus the **completed window layer** supplies
adjacent reindexing coherence after all universal conormal factors are
retained and removed occurrence by occurrence.  There is no additional unit
holonomy in the canonical common-window normalization.

This statement does not identify the completed-window line with the actual
QDM endpoint line.  That is a vertical comparison, not a failure of
horizontal window composition.

## 43.5 What remains after the calculation

The rank-shadow computation rules out three suspected difficulties:

1. the determinant-two signature does not create extra rank-line torsion;
2. no signature-by-signature Gamma integral is needed merely to compute the
   completed algebraic jet; and
3. adjacent completed-window maps are already coherent on the rank line.

Any positive residual valuation in the geometric problem must therefore
enter through at least one vertical adapter:

\[
\begin{CD}
 \text{actual fixed-phase QDM packet}
       @>{\text{overlap}}>>
 \text{actual fixed-phase QDM packet}\\
 @VV{\text{occurrence realization}}V
       @VV{\text{occurrence realization}}V\\
 \text{completed window/GKZ rank line}
       @>{\operatorname{jet}_1\cong 1}>>
 \text{completed window/GKZ rank line}.
\end{CD}                                                        \tag{43.19}
\]

The open theorem is that the vertical maps in (43.19) exist in a common
primitive phase, are nonzero on the marked line, commute with the first
normal jet, and satisfy exact base change.  Theorem 43.2 does not construct
them.

## 43.6 Source and scope audit

Halpern--Leistner, *The derived category of a GIT quotient*,
arXiv:1203.0276, develops common grade-restriction windows and balanced VGIT
equivalences; Halpern--Leistner--Sam, *Combinatorial constructions of derived
equivalences*, arXiv:1601.02030, constructs window equivalences for
quasi-symmetric representations.  Ballard--Favero--Katzarkov,
*Variation of geometric invariant theory quotients and derived categories*,
arXiv:1203.6643, includes toric Deligne--Mumford stack wall crossings, so
total unimodularity is not part of the abstract stack-level window input.

This module does not infer (43.3) solely from the weight lists.  It proves
the rank-jet conclusion from an occurrence-local common-window
identification and checks that the determinant-two incidence is not an
obstruction to the consumed rank law.  Nor does a derived window theorem
identify its K-theory line with Iritani's fixed-phase QDM/Gamma line; that is
the open vertical gate (43.19).

## 43.7 EJ/TT and mystery ledger

**EJ.** The proposed five-model analytic calculation collapses to one
formal rank identity.  All incidence-dependent information lives in the
supported kernel already forgotten by the consumer.

**TT.** The first jet should be retained as a morphism tensored with the
normal line, not prematurely divided by a coordinate.  This makes its
nonvanishing invariant and separates horizontal window coherence from the
vertical QDM realization.

| question | status | exact evidence or gate |
|---|---|---|
| Is the coordinate-wall normalized jet nonzero? | **yes; it is (1)** | (43.14), Theorem 43.2 |
| Does the determinant-two model change it? | **no** | (43.15)--(43.17) |
| Must the other three signatures be integrated separately on the rank line? | **no** | Corollary 43.2A |
| Is the jet independent of the chosen uniformizer? | **its nonvanishing is** | (43.13) |
| What composes along a completed-window path? | **the normalized residual maps; raw orders add** | (43.18)--(43.18a) |
| Does this identify the actual fixed-phase QDM overlap? | **no** | vertical gate (43.19) |

## Boundary

At the completed algebraic window level, the coordinate-wall and
determinant-two calculations both give exactly one simple conormal zero and
an invertible normalized jet.  The finite signature search is closed for
the rank consumer.  The remaining (m=2) problem is no longer a residual
calculation inside the completed models: it is the occurrence-level
fixed-phase QDM/Gamma identification of their universal jet with the actual
overlap transition.
