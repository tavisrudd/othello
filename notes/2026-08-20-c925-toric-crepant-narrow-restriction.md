# Module 45. Toric crepant continuation restricts to the narrow image

**Packet part:** Module 45.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** proper Fourier--Mukai correspondences are proved to preserve the
compact-to-ordinary K-theory image, and the Gamma-compatible toric crepant
transformation therefore restricts to a paired narrow-QDM comparison under
explicit spanning and realization hypotheses.  Preservation of the shifted
rank line remains open.

## 45.1 The compact-support image is functorial

For a smooth Deligne--Mumford stack \(\mathcal Y\), let

\[
 K_c^0(\mathcal Y)
   =K_0\{\text{perfect complexes exact off a proper substack}\} \tag{45.1}
\]

and let

\[
 j_{\mathcal Y}:K_c^0(\mathcal Y)\longrightarrow K^0(\mathcal Y) \tag{45.2}
\]

forget the proper-support condition.  Define the K-theoretic narrow image

\[
                    N_K(\mathcal Y)=\operatorname{im}j_{\mathcal Y}.
                                                                    \tag{45.3}
\]

Consider a correspondence

\[
\begin{CD}
 &\widetilde{\mathcal Y}&\\
 @V{f_-}VV @VV{f_+}V\\
 \mathcal Y_-&&\mathcal Y_+
\end{CD}                                                        \tag{45.4}
\]

with \(f_\pm\) proper and of finite Tor dimension, and suppose

\[
 \operatorname{FM}=Rf_{+*}Lf_-^*:
 D^b(\mathcal Y_-)\xrightarrow{\sim}D^b(\mathcal Y_+)          \tag{45.5}
\]

is an equivalence.

Equivalently, view (45.5) as a Fourier--Mukai transform whose kernel is
supported on the image of \(\widetilde{\mathcal Y}\) in
\(\mathcal Y_-\times\mathcal Y_+\), hence is proper over both factors.  Its
inverse is assumed to have a kernel proper over both factors as well; for an
equivalence between smooth stacks the standard dual inverse kernel has the
same proper support.

### Proposition 45.1 -- proper correspondences preserve the narrow image

The formula (45.5) restricts to an equivalence on proper-support
subcategories and gives a commutative square

\[
\begin{CD}
 K_c^0(\mathcal Y_-) @>{\operatorname{FM}_c}>>
       K_c^0(\mathcal Y_+)\\
 @V{j_-}VV @VV{j_+}V\\
 K^0(\mathcal Y_-) @>{\operatorname{FM}}>>
       K^0(\mathcal Y_+).
\end{CD}                                                        \tag{45.6}
\]

Consequently

\[
       \overline{\operatorname{FM}}:
       N_K(\mathcal Y_-)\xrightarrow{\sim}N_K(\mathcal Y_+).   \tag{45.7}
\]

#### Proof

If \(A\) has proper support \(S\subset\mathcal Y_-\), then
\(Lf_-^*A\) is supported on \(f_-^{-1}(S)\), which is proper because
\(f_-\) is proper.  Its pushforward under the proper map \(f_+\) again has
proper support.  Thus (45.5) restricts to proper-support objects.  Applying
the same argument to an inverse Fourier--Mukai correspondence gives an
equivalence there.

The same derived pull--push formula defines the upper and lower horizontal
maps, so forgetting support commutes with it.  Taking images in (45.6)
gives (45.7).  \(\square\)

There is a compact-to-ordinary Euler pairing

\[
 \chi_c:K_c^0(\mathcal Y)\times K^0(\mathcal Y)\longrightarrow\mathbf Z.
                                                                    \tag{45.8}
\]

Because (45.5) is an exact equivalence and the first input has proper
support,

\[
 \chi_{c,+}(\operatorname{FM}_c A,\operatorname{FM}B)
                         =\chi_{c,-}(A,B).                     \tag{45.9}
\]

Thus the induced narrow comparison is paired before passing to cohomology.

## 45.2 Gamma continuation respects the K-theoretic narrow lattice

Suppose quantum connections on \(\mathcal Y_\pm\) carry Gamma-integral maps

\[
 \mathfrak s_\pm:K^0(\mathcal Y_\pm)
       \longrightarrow\{\text{flat sections of }\nabla_\pm\}  \tag{45.10}
\]

and analytic continuation gives a gauge transformation \(\Theta\) with

\[
                  \Theta\,\mathfrak s_-(B)
                     =\mathfrak s_+(\operatorname{FM}B).       \tag{45.11}
\]

### Proposition 45.2 -- Gamma restriction to the narrow image

Equation (45.11) carries

\[
 \mathfrak s_-\bigl(N_K(\mathcal Y_-)\bigr)
   \xrightarrow{\ \sim\ }
 \mathfrak s_+\bigl(N_K(\mathcal Y_+)\bigr).                   \tag{45.12}
\]

If, in addition, the connection preserves the narrow subbundle, the chosen
realization identifies the Gamma framing of (N_K) with the
compact-support/narrow framing after the stated non-equivariant base change,
and compact/ordinary Chern characters span the compact and ordinary state
spaces and identify (45.3) with

\[
 H^*_{\mathrm{nar}}(\mathcal Y)
     =\operatorname{im}\bigl(H_c^*(\mathcal Y)\to H^*(\mathcal Y)\bigr),
                                                                    \tag{45.13}
\]

then \(\Theta\) restricts to an isomorphism of narrow flat local systems.
Under the Gamma--Riemann--Roch identification, (45.9) says that this
restriction preserves the narrow pairing.

#### Proof

For \(x=j_-a\in N_K(\mathcal Y_-)\), equations (45.6) and (45.11) give

\[
 \Theta\mathfrak s_-(x)
  =\mathfrak s_+(\operatorname{FM}j_-a)
  =\mathfrak s_+(j_+\operatorname{FM}_c a),
\]

which lies in the plus narrow lattice.  The inverse correspondence proves
surjectivity.  The spanning hypothesis promotes this lattice statement to
the state spaces in (45.13), and (45.9) plus
Gamma--Riemann--Roch gives the pairing equation.  \(\square\)

The spanning hypothesis is load-bearing.  Without it, (45.12) controls only
the algebraic/Gamma lattice and need not exhaust transcendental narrow
cohomology.

## 45.3 Coates--Iritani--Jiang specialization

Coates--Iritani--Jiang consider adjacent toric GIT chambers
\(\mathcal Y_\pm\) satisfying their Deligne--Mumford condition and separated
by a crepant wall.  Their Theorem 6.1 constructs analytic continuation and
identifies it with the Fourier--Mukai map

\[
       \operatorname{FM}=Rf_{+*}Lf_-^*                         \tag{45.14}
\]

from a proper toric common blowup.  Their Theorem 6.3 gives the corresponding
homogeneous, pairing-preserving gauge transformation and the exact
Gamma-integral equation (45.11), with Novikov variables specialized as
stated there.

### Theorem 45.3 -- conditional toric narrow continuation

Assume:

1. \(\mathcal Y_\pm\) form a semi-projective toric
   Deligne--Mumford crepant wall crossing in the scope of
   Coates--Iritani--Jiang;
2. their non-equivariant quantum connections, narrow-preserving connection,
   compact-support state spaces, and Gamma framing of (N_K) are identified
   with Shoemaker's narrow-QDM setup after exact base change;
3. Shoemaker's Assumption 4.10 holds, so the compact and ordinary Chern
   characters span; and
4. analytic continuation and exact base change are taken in the common
   parameter domain specified by the toric theorem.

Then the Coates--Iritani--Jiang gauge transformation restricts to a
pairing-preserving analytic-continuation isomorphism

\[
 \Theta_{\mathrm{nar}}:
 \operatorname{QDM}_{\mathrm{nar}}(\mathcal Y_-)
     \xrightarrow{\sim}
 \operatorname{QDM}_{\mathrm{nar}}(\mathcal Y_+).              \tag{45.15}
\]

#### Proof

The toric theorem supplies (45.4), (45.5), and (45.11).  Proposition 45.1
gives the proper-support square, and Proposition 45.2 restricts the
Gamma-compatible continuation to the narrow state spaces and their
pairings.  \(\square\)

This theorem is conditional only at the interface between the two external
formulations: item 2 must identify their state spaces, parameters, and
non-equivariant limits.  It is not inferred merely because both papers use
the phrase “quantum D-module.”

## 45.4 Application to the five canonical completions

Every Module 41 completed signature has total character zero.  Hence for
every wall cocharacter \(\lambda\),

\[
                   \left\langle\lambda,
                       \sum_i\beta_i\right\rangle=0,           \tag{45.16}
\]

which is the crepant wall condition.  Total unimodularity is unnecessary at
the stack level: the determinant-two pilot is allowed if the selected
semistable quotient satisfies the Deligne--Mumford condition.

Therefore, once an occurrence supplies:

- one of the five completed matrices;
- a selected semi-projective DM chamber pair;
- a genuine realization of both completed quotients in Shoemaker's
  total-space narrow-QDM setup, including the needed quantum
  properness/convexity, non-equivariant limit, and compact-support
  identification;
- the phase and common-parameter identifications in Theorem 45.3; and
- the compact/ordinary Chern-character spanning input,

the **existence of the paired bottom arrow** in Module 44's diagram (44.17)
is no longer open.  It is (45.15).

What remains is its marked-line law:

\[
             \boxed{\Theta_{\mathrm{nar}}(p_{X,-})
                       \in\mathbf C^\times p_{X,+}}.            \tag{45.17}
\]

Equivalently, by Corollary 44.2A, one must prove transport of the descended
narrow rank row.  The toric crepant transformation theorem preserves the
full pairing, but it does not state (45.17).  The shifted point is supported
through the zero-section Thom class and is not protected merely by identity
on the common dense torus.

An alternative is the Euler-intertwining square of Corollary 44.2B.  If the
Fourier--Mukai comparison is shown to intertwine the two Euler coimages and
to induce Module 43's rank-preserving base map, then (45.17) follows
formally.

## 45.5 Source and scope audit

Coates--Iritani--Jiang, *The Crepant Transformation Conjecture for Toric
Complete Intersections*, arXiv:1410.0024v2:

- Assumption 4.3 is the nonempty/Deligne--Mumford chamber condition;
- Section 5.1 assumes adjacent chambers, semi-projectivity, and
  \(\sum_iD_i\) on the wall, equivalently crepancy;
- Theorem 6.1 constructs the symplectic analytic continuation and identifies
  it, through the Gamma map, with the Fourier--Mukai transformation from a
  proper toric common blowup; and
- Theorem 6.3 constructs the homogeneous pairing-preserving gauge
  transformation and states the Gamma-integral continuation formula.

The paper explicitly allows noncompact toric DM stacks and does not require
total unimodularity or Gorenstein coarse moduli.  It does not explicitly
state the narrow restriction (45.15); Propositions 45.1--45.2 derive it from
proper support, the Gamma diagram, and the separately named spanning and
realization hypotheses.

Shoemaker, arXiv:1811.01888, supplies the narrow state space, pairing, QDM,
and Assumption 4.10 used on the other side of item 2.  No source is read as
proving the remaining marked-line equation (45.17).

## 45.6 EJ/TT and mystery ledger

**EJ.** The completed toric QDM comparison itself is not missing: the
crepant-transformation theorem already supplies it, Gamma-integrally and
pairing-preservingly.  Only its restriction to the sparse shifted rank line
requires new information.

**TT.** Separate existence of the rich comparison from preservation of the
one consumed vector.  The former is a theorem after the toric occurrence and
state-space identifications; the latter is the exact scalar/line gate
(45.17).

| question | status | exact evidence or gate |
|---|---|---|
| Does proper Fourier--Mukai transport compact support? | **yes** | Proposition 45.1 |
| Does it preserve the compact-to-ordinary image? | **yes** | (45.6)--(45.7) |
| Does Gamma analytic continuation restrict to the narrow lattice? | **yes** | Proposition 45.2 |
| Does this cover non-total-unimodular stacky models? | **yes if the DM chamber hypothesis holds** | CIJ Assumption 4.3 |
| Is the paired narrow bottom arrow available? | **conditionally yes** | Theorem 45.3 |
| Is the shifted rank line automatically preserved? | **not from the cited theorem** | (45.17) |

## Boundary

For a canonical completion realized as a toric crepant DM wall crossing and
satisfying every hypothesis of Theorem 45.3---in particular the Shoemaker
total-space/narrow-preserving and Gamma-framing identification, Assumption
4.10, and exact non-equivariant base change on a common parameter
domain---the rich analytic continuation and its paired narrow restriction
are available from the Coates--Iritani--Jiang Fourier--Mukai/Gamma theorem
plus the compact-support square.  The completed-model frontier then
contracts to one marked statement: transport the shifted Thom point line,
or equivalently prove the Euler-intertwining rank square.  Occurrence
realization and the fixed primitive phase remain separate external gates.
