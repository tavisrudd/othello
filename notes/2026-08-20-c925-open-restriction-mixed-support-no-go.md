# Module 51. The completed kernel does not restrict to the intended opens

**Packet part:** Module 51.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the direct open-restriction repair left by Modules 49--50 also
fails at the level of the natural completed wall-crossing correspondence.
For every admissible pilot chamber and either adjacent coordinate-wall
chamber, the common completed stable locus contains a point which lies in
the intended raw open on exactly one side.  Hence the completed
correspondence has mixed boundary--open support, and its Fourier--Mukai
equivalence does not descend through the intended boundary localizations.
A weaker rank-row quotient can still forget this mixed support; that is now
the exact surviving version of the route.

## 51.1 When a correspondence restricts to opens

Let \(X_\pm\) and \(\widetilde X\) be qcqs perfect stacks, and work in
\(\operatorname{Perf}\).  Let

\[
             X_-\xleftarrow{\,f_-\,}\widetilde X
                  \xrightarrow{\,f_+\,}X_+                    \tag{51.1}
\]

be a proper correspondence, and let \(U_\pm\subset X_\pm\) be open with
closed complements \(Z_\pm\).  Put

\[
                \widetilde U_-=f_-^{-1}(U_-),\qquad
                \widetilde U_+=f_+^{-1}(U_+).                 \tag{51.2}
\]

### Proposition 51.1 -- support criterion

The structure-sheaf kernel of (51.1) has no mixed boundary--open support in
either direction exactly when

\[
                           \widetilde U_- = \widetilde U_+.    \tag{51.3}
\]

Under (51.3), the correspondence restricts to

\[
                  U_-\xleftarrow{}\widetilde U_-
                       \xrightarrow{}U_+.                     \tag{51.4}
\]

If the original Fourier--Mukai equivalence and its inverse carry the
boundary-supported thick subcategories into one another, they descend,
after idempotent completion, through Thomason localization to the perfect
categories of the two opens.  Conversely, a point
of

\[
 f_-^{-1}(U_-)\cap f_+^{-1}(Z_+)
 \quad\text{or}\quad
 f_-^{-1}(Z_-)\cap f_+^{-1}(U_+)                              \tag{51.5}
\]

is a support-level obstruction to restricting the natural kernel.

#### Proof

The first mixed locus is \(\widetilde U_-\setminus\widetilde U_+\), and the
second is \(\widetilde U_+\setminus\widetilde U_-\).  Their simultaneous
emptiness is (51.3), which gives (51.4).  Preservation of the two thick
boundary subcategories then invokes the universal property of Verdier
localization and the Thomason identification
\(\operatorname{Perf}(X)/\operatorname{Perf}_Z(X)\simeq
\operatorname{Perf}(U)\) after idempotent completion.  A point in (51.5) lies in
the support of the structure kernel over a boundary--open pair, so that
particular kernel cannot be the extension of a kernel on \(U_-\times U_+\).
\(\square\)

The proposition does not say that no unrelated equivalence of the opens can
exist.

## 51.2 Completed and intended semistability

Retain the five quasi-symmetric genuine signatures of Module 41.  The raw
representation contains

\[
 E=(1,0),\quad W_0=(-1,0),\quad N=(0,1),\quad S=(0,-1),        \tag{51.6}
\]

and the canonical completion adds

\[
                              c=(1,-1).                        \tag{51.7}
\]

For a generic character \(\theta\), let

\[
 X_\theta=[(W\oplus\mathbf C_c)^{\mathrm{ss}}_\theta/T],
 \qquad
 U_\theta=[(W^{\mathrm{ss}}_\theta\oplus\mathbf C_c)/T]
                 \subset X_\theta.                            \tag{51.8}
\]

The added ray \(c\), and in the northwest the raw discrepancy ray, may
subdivide a raw quadrant.  For each coordinate wall below, choose the
completed subchamber incident to that wall.  Semistability is constant in
that completed subchamber, so we may use a convenient generic
representative there.  In particular, use \((2,-1)\) on the southeast side
of the east ray, \((1,-2)\) on the southeast side of the south ray,
\((-1,2)\) on the northwest side of the north ray, and \((-2,1)\) on the
northwest side of the west ray.

Two adjacent completed chambers have a common stable open.  Over it, the
standard toric wall correspondence is the identity.  Consequently any
single support which is completed-semistable in both chambers but raw-stable
in exactly one produces a mixed point of the form (51.5).

### Proposition 51.2 -- mixed supports around every pilot chamber

For each admissible intermediate chamber in Corollary 41.4A and each of its
two coordinate-wall neighbours, such a mixed support exists:

\[
\begin{array}{c|c|c}
\text{intermediate/adjacent chambers}
  & \text{raw support} & \text{added support}\\ \hline
\mathrm{NE}/\mathrm{NW} & \{W_0,N\} & \{c\}\\
\mathrm{NE}/\mathrm{SE} & \{E,N\}   & \{c\}\\
\mathrm{SE}/\mathrm{NE} & \{E,N\}   & \{c\}\\
\mathrm{SE}/\mathrm{SW} & \{W_0,S\} & \{c\}\\
\mathrm{SW}/\mathrm{SE} & \{W_0,S\} & \{c\}\\
\mathrm{SW}/\mathrm{NW} & \{W_0,N\} & \{c\}.
\end{array}                                                   \tag{51.9}
\]

In every row, the raw support spans one chamber but not the other, while its
union with \(\{c\}\) spans interior characters of both.

#### Proof

The raw cones in the middle column are respectively NW, NE, NE, SW, SW,
and NW.  It remains only to exhibit an interior character of the other
chamber after adding \(c\).

For \(\{W_0,N,c\}\),

\[
                    (1,1)=2c+3N+1W_0,\qquad
                  (-1,-1)=1c+0N+2W_0.                        \tag{51.10}
\]

Thus the same completed support reaches NE and SW in addition to its raw NW
cone.  For \(\{E,N,c\}\),

\[
                         (1,1)=1E+1N,qquad
                       (2,-1)=1E+1c,                          \tag{51.11}
\]

so it reaches both NE and SE.  Finally, for \(\{W_0,S,c\}\),

\[
                       (-1,-1)=1W_0+1S,qquad
                         (1,-2)=1c+1S,                        \tag{51.12}
\]

so it reaches both SW and SE.  The southeast representatives in
(51.11)--(51.12) lie in the two completed subchambers incident to the east
and south coordinate walls, respectively.  The raw NW support spans both
incident northwest subchambers, including the representatives named above.
Thus the witnesses apply on the relevant side of every coordinate wall,
which proves every row of (51.9).  \(\square\)

### Theorem 51.3 -- no naive kernel restriction

Assume an actual five-signature pilot is realized by smooth qcqs perfect
toric DM quotient stacks in the ordinary affine GIT chambers above.  Assume
that the completed CIJ wall transform is represented by a perfect kernel
\(\mathcal P\) whose restriction over the common completed stable open
\(V\) is the diagonal identity kernel \(\mathcal O_{\Delta_V}\), as for the
standard proper toric wall correspondence.  For each coordinate wall
adjacent to the selected raw intermediate chamber, use the completed
subchamber incident to that wall.  Then

\[
                   f_-^{-1}(U_-)\ne f_+^{-1}(U_+).            \tag{51.13}
\]

Therefore the natural completed correspondence does not restrict
geometrically between the intended total-space opens, and its
Fourier--Mukai equivalence does not descend through their boundary
localizations.

#### Proof

Use the corresponding row of (51.9).  A point with all listed support
coordinates nonzero is completed-semistable in both chambers and therefore
belongs to their common stable open in the wall correspondence.  Its raw
support is semistable in exactly one chamber, so its two images have opposite
membership in the opens (51.8).  Swap \(+\) and \(-\), and use the inverse
kernel if necessary, so that this is a boundary-source/open-target point
\(x\).  Smoothness makes \(\mathcal O_x\) perfect.  Put
\(V_+=V\cap U_+\), with inclusion \(i:V_+\hookrightarrow U_+\).  Perfect
base change and
\(\mathcal P|_{V\times V}\cong\mathcal O_{\Delta_V}\) give
\[
        i^*j_+^*\Phi_{\mathcal P}(\mathcal O_x)
                    \cong \mathcal O_x\ne0.                   \tag{51.13a}
\]
Thus already \(j_+^*\Phi_{\mathcal P}(\mathcal O_x)\ne0\), while the source
copy of \(x\) is boundary-supported.  The boundary-supported perfect
subcategory is not preserved.  Proposition 51.1 gives (51.13), and Verdier
descent of this equivalence fails.  \(\square\)

## 51.3 The rank-row quotient still survives

Failure of categorical restriction is stronger than failure of the final
consumer.  Assume \(X_\pm\) are integral, as in the toric pilots, and let
\(K_0^{Z_\pm}(X_\pm)\) be the subgroup generated by classes supported on the
strict closed boundary \(Z_\pm\).  Ordinary generic rank kills it:

\[
                   \operatorname{rk}_\pm
                      \bigl(K_0^{Z_\pm}(X_\pm)\bigr)=0.       \tag{51.14}
\]

### Proposition 51.4 -- row-level boundary forgetting

Let \(F:K_0(X_-)\to K_0(X_+)\) preserve generic rank up to a unit
\(u\), and suppose a source class \(x\) has two completed lifts differing by
a rank-zero boundary class.  Then their images under \(F\) have the same
target rank, and

\[
                         \operatorname{rk}_+(F x)
                            =u\operatorname{rk}_-(x).          \tag{51.15}
\]

The same statement holds for the divided rank row of Module 46 whenever all
named classes lie in its Thom image: an identically zero equivariant rank
remains zero after dividing by the fixed nonzerodivisor \(s^r\).

#### Proof

If \(x'-x=b\) with \(\operatorname{rk}_-(b)=0\), then
\(\operatorname{rk}_+(F b)=u\operatorname{rk}_-(b)=0\).  Hence
\(Fx\) and \(Fx'\) have the same row.  Equation (51.15) is the assumed rank
law.  In the divided setting, \(0/s^r=0\); no division of an object or class
is used.  \(\square\)

This proposition does **not** construct a functor between the open QDMs.
It says that the final rank-row consumer can ignore mixed boundary support if
the actual occurrence realization already identifies the completed rank map
with the endpoint QDM row.  That final vertical identification is precisely
the normal-jet/fixed-phase adapter left by Modules 43 and 47.

## 51.4 Consequence for strategy

The direct completion program now has two distinct levels:

1. **full narrow/open equivalence:** blocked for the natural completed kernel
   by Theorem 51.3;
2. **rank-row transport modulo boundary:** formally safe by Proposition 51.4,
   but still conditional on the actual fixed-phase QDM/Gamma occurrence
   adapter.

Thus open restriction is not an independent shortcut around the normal-jet
problem.  At the sparse consumer level it collapses back to the same vertical
rank-row identification.  A relative \(p\)-field or enlarged-group theory
could still construct a different comparison, but it would be new geometric
input rather than a restriction of the present CIJ kernel.

## 51.5 EJ/TT and mystery ledger

**EJ.** The same four axis weights that killed the phase also expose mixed
boundary--open points on both sides of every adjacent wall.  The failure is
therefore correspondence-level, not merely an objectwise mismatch of the
completed quotient.

**TT.** Separate categorical descent from consumer descent.  The former
fails by a visible support point; the latter forgets that point because
generic rank annihilates every proper boundary class.  The only useful
remaining question is whether the analytic occurrence map realizes this
rank quotient.

| question | status | exact evidence or gate |
|---|---|---|
| Does the natural completed FM equivalence descend to the intended open localizations? | **no for every pilot adjacency** | Theorem 51.3 |
| Can an unrelated open equivalence still exist? | **not ruled out** | outside Proposition 51.1 |
| Is mixed boundary support visible to generic/divided rank? | **no under the stated rank/Thom hypotheses** | Proposition 51.4 |
| Does this construct the fixed-phase QDM row map? | **no** | occurrence-level Gamma/QDM vertical adapter remains |
| Is open restriction still a separate high-EV route? | **no for the natural kernel** | it reduces to the same sparse row adapter |

## Boundary

Module 51 rules out geometric restriction and boundary-localization descent
of the natural completed CIJ equivalence to the intended total-space opens
for every five-signature pilot adjacency.  It does not rule out a
coincidentally equivalent restricted kernel or a different relative or
master-space comparison.  The rank-row quotient remains insensitive to the
mixed boundary, but identifying that quotient with the actual fixed-phase
cubic QDM packet is still the open local theorem.

**Successor.**  Module 52 shows that an LG potential can make the mixed
boundary critical-free, but no purely added nondegenerate quadratic fibre
can both cancel the nonzero discrepancy character and disappear without
changing the raw endpoint.  Thus a \(p\)-field bypass would require a new
critical target and its own QDM/Gamma realization.
