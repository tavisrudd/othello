# Module 44. Narrow QDM remembers the rank row after Euler annihilation

**Packet part:** Module 44.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the Euler-image/coimage theorem and its point-pairing rank
reconstruction are proved; Shoemaker's narrow QDM supplies the corresponding
paired quantum receiver under its hypotheses.  Identification with the
actual fixed-phase overlap remains open.

## 44.1 The point is killed as an input but survives in the image

Let \(X\) be a connected smooth projective complex variety of dimension
\(n\), let \(E\to X\) be a vector bundle of rank \(1\le r\le n\), and put

\[
                     Y=\operatorname{Tot}(E^\vee).
                                                                    \tag{44.1}
\]

Via the bundle projection, identify \(H^*(Y;\mathbf C)\) with
\(H^*(X;\mathbf C)\), and set

\[
 e=e(E^\vee)\in H^{2r}(X;\mathbf C),\qquad
 \mu_e(\beta)=e\cup\beta.                                      \tag{44.2}
\]

Assume \(e\ne0\).  Let

\[
 \rho_0:H^*(X;\mathbf C)\longrightarrow\mathbf C              \tag{44.3}
\]

be projection to degree zero.  Under the Chern character this is the rank
row.

The forward quantum-Serre convention often uses \(e(E)\) rather than
\(e(E^\vee)\).  Since

\[
                         e(E^\vee)=(-1)^r e(E),                 \tag{44.3a}
\]

the image and kernel are unchanged and the reconstructed row changes only
by the displayed nonzero scalar convention.

Shoemaker's Proposition 2.15 identifies the narrow state space with the
Euler image:

\[
                    H^*_{\mathrm{nar}}(Y)=\operatorname{im}\mu_e.
                                                                    \tag{44.4}
\]

### Proposition 44.1 -- Euler coimage retains rank

One has

\[
                       \ker\mu_e\subseteq\ker\rho_0.            \tag{44.5}
\]

Consequently there is a unique row

\[
 \rho_{\mathrm{nar}}:H^*_{\mathrm{nar}}(Y)\longrightarrow\mathbf C,
 \qquad
 \rho_{\mathrm{nar}}(\mu_e\beta)=\rho_0(\beta),                \tag{44.6}
\]

and multiplication by \(e\) induces an isomorphism of marked spaces

\[
 \left(H^*(X)/\ker\mu_e,\bar\rho_0\right)
     \xrightarrow{\ \sim\ }
 \left(H^*_{\mathrm{nar}}(Y),\rho_{\mathrm{nar}}\right).         \tag{44.7}
\]

#### Proof

If \(\mu_e\beta=0\), its component of degree \(2r\) is
\(\rho_0(\beta)e\).  Since \(e\ne0\), this forces
\(\rho_0(\beta)=0\), proving (44.5).  Formula (44.6) is therefore
well-defined.  The first isomorphism theorem gives (44.7), including the row
equation.  \(\square\)

Let \(p_X\in H^{2n}(X;\mathbf C)\) be the normalized base point class,
\(\int_Xp_X=1\).  Degree forces

\[
                              \mu_e(p_X)=0.                     \tag{44.8}
\]

Nevertheless \(p_X\) belongs to the image of \(\mu_e\).  Indeed, Poincare
duality and \(e\ne0\) give an \(\alpha\in H^{2n-2r}(X;\mathbf C)\) with

\[
                   \int_X\alpha e=1,\qquad \mu_e(\alpha)=p_X.  \tag{44.9}
\]

Under \(H^*(Y)\cong H^*(X)\), \(p_X\) is a narrow class of degree \(2n\).
It is not the ordinary cohomology class of a closed point of the
\((n+r)\)-dimensional noncompact space \(Y\), which would have degree
\(2(n+r)\) and vanishes in ordinary cohomology.  It is a **shifted point**:
the image of the compact Thom class \(i_{c*}\alpha\) supported on the zero
section.  The base point is forgotten as an input but not gone: it is zero
under the operation when placed at the top of \(H^*(X)\), yet is the
distinguished degree-\(2n\) class in the retained image.

## 44.2 The narrow point represents the reconstructed rank row

Shoemaker's narrow pairing is obtained by choosing a compactly supported
lift of the first input.  For the zero section \(i:X\hookrightarrow Y\), a
compact Thom pushforward of \(\alpha\) is a lift of
\(p_X=i_*\alpha\).

### Theorem 44.2 -- shifted point/rank duality

For every \(\beta\in H^*(X;\mathbf C)\),

\[
              \left\langle p_X,\mu_e(\beta)\right\rangle_{\mathrm{nar}}
                   =\rho_0(\beta).                             \tag{44.10}
\]

Equivalently,

\[
               \rho_{\mathrm{nar}}
                   =\langle p_X,-\rangle_{\mathrm{nar}}.        \tag{44.11}
\]

#### Proof

Use the compact Thom lift \(i_{c*}\alpha\) of \(p_X\).  The definition of the
narrow pairing, the projection formula, and (44.9) give

\[
\begin{aligned}
 \left\langle p_X,\mu_e(\beta)\right\rangle_{\mathrm{nar}}
   &=\int_Y i_{c*}\alpha\cup i_*\beta\\
   &=\int_X\alpha\cup\beta\cup e\\
   &=\int_Xp_X\cup\beta
    =\rho_0(\beta).
\end{aligned}                                                   \tag{44.12}
\]

This also proves independence of the choice of \(\alpha\).  \(\square\)

The theorem explains the apparent contradiction with Module 42:
multiplication by \(e\) kills the **source** base point \(p_X\), but its
image contains the shifted point with a different preimage \(\alpha\).  The
narrow pairing remembers that preimage's degree-zero coefficient without
choosing \(\alpha\).

## 44.3 Quantum and integral lift

Under the hypotheses of Shoemaker's Corollary 4.8, the quantum connection
preserves \(H^*_{\mathrm{nar}}(Y)\), its narrow pairing is nondegenerate and
flat, and the result is a quantum D-module

\[
                         \operatorname{QDM}_{\mathrm{nar}}(Y). \tag{44.13}
\]

Under Shoemaker's additional Assumption 4.10, Definition 4.11 supplies the
compact-support/ordinary integral lattices.  This spanning assumption is not
automatic for an arbitrary smooth projective \(X\).  When \(E\) is convex
and the additional assumptions in Shoemaker's Section 6 hold, Theorem 6.14
identifies this narrow QDM, including its pairing and integral structure,
with the ambient QDM of the zero locus of a regular section of \(E\).

The state \(p_X\) gives a flat shifted-point section by applying the
fundamental solution.  Because the narrow pairing is flat, (44.11)
propagates from the large-radius state space to a flat covector.  Under the usual
\(\widehat\Gamma\)-framing, the degree-zero term of
\(\widehat\Gamma_X\operatorname{ch}(V)\) is \(\operatorname{rk}(V)\), so
the shifted-point covector recovers the rank of an Euler-image Gamma state,
up to the standard common \(z\)-normalization.  Identifying this covector
with the actual fixed-phase Gamma row is an additional provider, not a
consequence of the narrow construction.

### Corollary 44.2A -- paired narrow transport equivalence

Let \(\Psi:\operatorname{QDM}_{\mathrm{nar}}(Y_-)
\xrightarrow{\sim}\operatorname{QDM}_{\mathrm{nar}}(Y_+)\) preserve the
narrow pairings and suppose

\[
                     \Psi(p_{X,-})=c\,p_{X,+},\qquad c\ne0.    \tag{44.14}
\]

Then the reconstructed rank rows satisfy

\[
                         \rho_{\mathrm{nar},+}\Psi
                             =c^{-1}\rho_{\mathrm{nar},-}       \tag{44.15}
\]

with the scalar direction determined by the chosen pairing convention.

#### Proof

For \(v\) in the minus narrow space, pairing preservation gives

\[
\begin{aligned}
 \rho_{\mathrm{nar},-}(v)
   &=\langle p_{X,-},v\rangle_-\\
   &=\langle\Psi p_{X,-},\Psi v\rangle_+
    =c\langle p_{X,+},\Psi v\rangle_+
    =c\,\rho_{\mathrm{nar},+}(\Psi v).
\end{aligned}
\]

Rearranging gives (44.15).  \(\square\)

Conversely, if

\[
                   \rho_{\mathrm{nar},+}\Psi
                       =d\,\rho_{\mathrm{nar},-},\qquad d\ne0, \tag{44.15a}
\]

then perfection of the pairings implies

\[
                            \Psi(p_{X,-})=d^{-1}p_{X,+}.        \tag{44.15b}
\]

Indeed, for every \(v\),

\[
\begin{aligned}
 \langle\Psi p_{X,-},\Psi v\rangle_+
   &=\rho_{\mathrm{nar},-}(v)\\
   &=d^{-1}\rho_{\mathrm{nar},+}(\Psi v)
    =\langle d^{-1}p_{X,+},\Psi v\rangle_+.
\end{aligned}
\]

Surjectivity of \(\Psi\) and nondegeneracy give (44.15b).  Thus row
transport and shifted-point transport are equivalent once the narrow
pairing is fixed.

### Corollary 44.2B -- Euler-intertwining descent

Let

\[
 \Phi:H^*(X_-)\xrightarrow{\sim}H^*(X_+),\qquad
 \Psi:H^*_{\mathrm{nar}}(Y_-)\xrightarrow{\sim}
       H^*_{\mathrm{nar}}(Y_+)                                \tag{44.15c}
\]

satisfy

\[
 \Phi\mu_{e_-}=\mu_{e_+}\Phi,\qquad
 \rho_{0,+}\Phi=\rho_{0,-},\qquad
 \Psi(\mu_{e_-}\beta)=\mu_{e_+}\Phi(\beta).                   \tag{44.15d}
\]

Then

\[
                   \rho_{\mathrm{nar},+}\Psi
                       =\rho_{\mathrm{nar},-}.                 \tag{44.15e}
\]

If \(\Psi\) also preserves the narrow pairing, then
\(\Psi(p_{X,-})=p_{X,+}\).

#### Proof

For \(v=\mu_{e_-}\beta\), equations (44.6) and (44.15d) give

\[
 \rho_{\mathrm{nar},+}(\Psi v)
  =\rho_{0,+}(\Phi\beta)
  =\rho_{0,-}(\beta)
  =\rho_{\mathrm{nar},-}(v).
\]

The shifted-point statement follows from Corollary 44.2A.  \(\square\)

## 44.4 Relation to the first-normal-jet route

Modules 42--43 retain the first nonzero normal coefficient of the family
\(\Theta_q\) before specializing \(q=1\).  The narrow route instead applies
the image optic after non-equivariant specialization:

\[
\begin{CD}
 H^*(X) @>{\mu_e}>> H^*(Y)\\
 @VVV                    @AAA\\
 H^*(X)/\ker\mu_e
      @>{\sim}>>
 H^*_{\mathrm{nar}}(Y)=\operatorname{im}\mu_e.
\end{CD}                                                        \tag{44.16}
\]

They are two different augmentations:

1. **normal jet:** retain the fibre character and first conormal direction;
2. **narrow coimage:** forget the Euler kernel but retain the image, its
   compact-support pairing, and the shifted-point line.

Neither is formally stronger.  The jet sees an infinitesimal deformation
which the narrow coimage forgets.  The narrow coimage has an intrinsic
nondegenerate pairing which the rank jet alone does not retain.

For the final Boolean/rank consumer, the narrow route can bypass division by
\(1-q^{-1}\) if the actual occurrence comparison already lives in one
narrow QDM receiver and preserves its shifted-point line.

## 44.5 Common windows and the remaining vertical gate

The shifted point \(p_X\) is represented by a compact Thom lift along the
zero section, not by a skyscraper sheaf at a point of the common stable open.
Therefore the common-open identity used in Module 43 does **not** protect
this line.  Preservation of an ordinary open point object is not
preservation of (44.9).

A window equivalence of derived categories does not automatically supply:

- a narrow-QDM realization in the selected fixed primitive phase;
- the Euler-intertwining descent (44.15d);
- commutation with the primitive projector and the fundamental solution;
- transport of the compact Thom/shifted-point line and its identification
  with the actual Gamma row; or
- adjacent occurrence reindexing and exact base change.

Thus the candidate square is

\[
\begin{CD}
 \text{actual fixed-phase packet/rank row}
      @>{\text{overlap}}>>
 \text{actual fixed-phase packet/rank row}\\
 @VV{\text{narrow realization}}V
      @VV{\text{narrow realization}}V\\
 \bigl(\operatorname{QDM}_{\mathrm{nar}}(Y_-),p_{X,-}\bigr)
      @>{\Psi}>>
 \bigl(\operatorname{QDM}_{\mathrm{nar}}(Y_+),p_{X,+}\bigr).
\end{CD}                                                        \tag{44.17}
\]

The bottom row is sufficient by Corollary 44.2A.  If the vertical adapter
identifies the base map \(\Phi\) in (44.15d) with Module 43's
rank-preserving completed-window map, then Corollary 44.2B makes the
shifted-point equation automatic once that adapter is also
Euler-intertwining and pairing-preserving.  Those vertical arrows and
identifications are the open provider.

## 44.6 Exact \(m=2\) specialization

The narrow route closes a completed overlap occurrence if the following are
constructed:

1. local canonical models \(Y_\pm=\operatorname{Tot}(E_\pm^\vee)\) with
   \(e(E_\pm^\vee)\ne0\) and narrow QDMs satisfying the required properness
   or convexity hypotheses, plus Assumption 4.10 whenever the integral/Gamma
   lattice is consumed;
2. occurrence-local identifications of the actual primitive packets with
   faithful fixed-phase summands or quotients of those narrow QDMs;
3. either
   (a) a rank-preserving Euler-intertwining descent as in (44.15d), together
   with narrow-pairing preservation, which forces
   \(\Psi(p_{X,-})=p_{X,+}\); or
   (b) directly, a pairing-preserving \(\Psi\) carrying \(p_{X,-}\) to a
   nonzero scalar multiple of \(p_{X,+}\), which gives the row law up to the
   inverse scalar but does not construct a base map \(\Phi\);
4. endpoint calibration identifying (44.11) with the actual rank rows; and
5. adjacent reindexing, orientation, and exact-base-change coherence along
   the chosen weak-factorization path.

Then Corollary 44.2A supplies every local quotient-line isomorphism consumed
by Module 34.  This replaces the normal-jet identification gate; it does not
remove the occurrence realization or fixed-phase projector gates.

## 44.7 Source and scope audit

Shoemaker, *Narrow quantum D-modules and quantum Serre duality*,
arXiv:1811.01888, supplies:

- Definition 2.1: narrow cohomology as
  \(\operatorname{im}(H_c^*(Y)\to H^*(Y))\);
- Proposition 2.15: for \(Y=\operatorname{Tot}(E^\vee)\), this is the
  zero-section/Euler image;
- Definitions 2.8 and 2.10 and Proposition 2.11: the compact-support product
  and nondegenerate narrow pairing;
- Corollary 4.8: preservation by the quantum connection and flatness of the
  narrow pairing; and
- Assumption 4.10 and Definition 4.11: the additional spanning hypothesis
  and resulting compact-support/ordinary integral lattices; and
- Theorem 6.14, under the hypotheses of Section 6: the paired,
  integral-structure-compatible isomorphism with the ambient QDM of the
  regular zero locus.

Proposition 44.1 and Theorem 44.2 are direct consequences of these
definitions plus Poincare duality.  The cited results do not identify an
AKMW overlap with the narrow receiver in (44.17).

## 44.8 EJ/TT and mystery ledger

**EJ.** The row annihilated in Module 42 was not destroyed.  It moved from a
source base point to a shifted narrow point represented by a compact Thom
class, and the compact-support pairing reconstructs its preimage rank
exactly.

**TT.** Do not insist on inverting Euler multiplication on the full state
space.  Its coimage is already the exact sparse quotient needed by the
consumer.  The honest comparison is between the jet optic and the image
optic, not between an invertible and a noninvertible full map.

| question | status | exact evidence or gate |
|---|---|---|
| Does Euler multiplication kill the source base point? | **yes** | (44.8) |
| Is the base point absent from the retained image? | **no; it survives as a shifted narrow class** | (44.9) |
| Does the Euler coimage retain rank? | **yes** | Proposition 44.1 |
| What represents the descended row? | **narrow pairing with the shifted point** | Theorem 44.2 |
| When is shifted-point transport automatic? | **under rank-preserving Euler descent and narrow-pairing preservation** | Corollary 44.2B |
| Is this a lawful quantum receiver? | **yes under Shoemaker's hypotheses** | Corollary 4.8 |
| Does it avoid the equivariant first jet? | **conditionally** | common narrow receiver (44.17) |
| Does Shoemaker type the actual fixed-phase AKMW occurrence? | **no** | vertical gates in Section 44.6 |

## Boundary

The non-equivariant Euler map does not erase the rank information: after
passing to its coimage/narrow image, the normalized shifted-point class
represents the descended rank row through the intrinsic narrow pairing.
This gives a second, non-equivariant augmentation that can replace the
first-normal-jet consumer.  It is not yet an \(m=2\) proof, because the
actual occurrence packet and its primitive fixed phase have not been
identified with this narrow paired receiver.
