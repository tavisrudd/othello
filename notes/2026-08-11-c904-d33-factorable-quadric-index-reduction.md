# C904: the generic \(D_{3,3}\) curve is a finite factorable-quadric packet

Date: 2026-08-11
Status: theorem-grade reduction; the final finite scheme has not been counted
Scope: the sole live two-primary cancellation locus in the charge-three
Abel--Jacobi fibre; no manuscript or Lean change

## Verdict

The curve left open in the earlier Brauer and \(D_{3,3}\) audits is not an
unstructured curve.  For a general globally generated charge-three bundle
\(E\) on a smooth cubic threefold, put

\[
             V=H^0(X,E),\qquad \dim V=4,
\]

and let

\[
 w_E:\bigwedge^2V\longrightarrow H^0(X,\det E)
                 =H^0(X,{\cal O}_X(2))
\]

be the wedge map.  A two-plane \(U\subset V\) determines the quadric
\(w_E(\bigwedge^2U)\), well defined up to scalar.  Let \(R_{3,3}(E)\) be
the finite scheme of two-planes for which this quadric factors as two
hyperplanes and the induced section pencil has generic zero curve of type
\((3,3)\).

On the generic open used by Voisin, the normalization of the fibre of

\[
                  D_{3,3}\dashrightarrow M_9
\]

is birational over \(R_{3,3}(E)\) to

\[
                  \mathbf P({\cal U}|_{R_{3,3}(E)}),
\]

where \({\cal U}\) is the tautological rank-two bundle on
\(G(2,V)\).  Consequently the two schemes have the same zero-cycle index:

\[
 \operatorname {ind}\bigl(D_{3,3,E}^{\rm norm}\bigr)
       =\operatorname {ind}\bigl(R_{3,3}(E)\bigr).
\]

This replaces the open ``genus/index of a mysterious generic curve'' by a
finite symmetric-determinantal computation.  It does **not** yet decide
whether that index is odd.  In particular, no claim that the packet has
length 21 is licensed.

## 1. The line packet

Let \([s]\in\mathbf P(V)\) be a regular section with zero curve \(C_s\).
The Serre sequence is

\[
 0\longrightarrow {\cal O}_X\xrightarrow{s}E
   \longrightarrow I_{C_s}(2)\longrightarrow0.
\]

Because \(H^1(X,{\cal O}_X)=0\) and \(h^0(E)=4\), wedge with \(s\) gives
an isomorphism

\[
       V/\langle s\rangle\xrightarrow{\sim}H^0(I_{C_s}(2)),
       \qquad \bar t\longmapsto w_E(s\wedge t).
\]

Suppose \(C_s=A\cup B\) is a general type-\((3,3)\) curve.  Its two
twisted-cubic components span unique hyperplanes \(H_A,H_B\).  If
\(h_A,h_B\) are their equations, then

\[
                         h_Ah_B\in H^0(I_{C_s}(2)).
\]

There is therefore a unique point \([t]\in\mathbf P(V/\langle s\rangle)\)
such that

\[
                         w_E(s\wedge t)=h_Ah_B.
\]

Put \(U=\langle s,t\rangle\).  For every \(0\ne r\in U\), the same quadric
lies in \(H^0(I_{C_r}(2))\), because \(\bigwedge^2U\) is one-dimensional.
Thus every zero curve in this pencil lies on

\[
          X\cap(H_A\cup H_B)=(X\cap H_A)\cup(X\cap H_B).
\]

On a dense open of the pencil the two component Hilbert polynomials remain
those of the original twisted cubics, so the entire projective line closes
inside the type-\((3,3)\) locus.

Conversely, a general type-\((3,3)\) section recovers its two spanning
hyperplanes, their product quadric, and hence the unique two-plane \(U\).
The two constructions are inverse on dense opens.  Voisin proves that the
generic fibre of \(D_{3,3}\dashrightarrow M_9\) has dimension one.  It
follows that the parameter scheme of these lines is finite over the generic
point of \(M_9\).

The statement deliberately uses the type-\((3,3)\) component of the
factorable-quadric scheme.  A special bundle can have other splitting types
or nonregular sections; those are removed before taking the generic packet.

## 2. Equality of indices

Let \(K=k(M_9)\) and let \(R=R_{3,3}(E_K)\).  The normalized generic
section curve is birational to \(\mathbf P({\cal U}|_R)\).  Proper smooth
models have the same index under birational equivalence in characteristic
zero.

Projection sends every closed point upstairs to a zero-cycle of the same
total degree on \(R\), so

\[
                  \operatorname {ind}(R)\mid
                  \operatorname {ind}(\mathbf P({\cal U}|_R)).
\]

Conversely, over every residue field \(k(r)\) the fibre is the honest
projective line of the two-dimensional vector space \({\cal U}_r\), hence
has a \(k(r)\)-point.  Every closed point of \(R\) therefore lifts without
changing degree, giving the reverse divisibility.  This proves equality.

For C904, an odd-length packet is already enough for the positive exit: it
contains an odd-degree closed component and hence the generic
\(D_{3,3}\)-curve has an odd zero-cycle.  An even total length alone is not
a negative theorem; the gcd of the residue degrees must be computed.

## 3. Exact finite calculation now required

Choose a basis of \(V\), write the six wedge quadrics as symmetric
\(5\times5\) matrices \(A_{ij}\), and use Pluecker coordinates \(p_{ij}\)
on \(\mathbf P(\bigwedge^2V)\).  Then

\[
                     A_E(p)=\sum_{i<j}p_{ij}A_{ij}.
\]

The finite factorable packet is obtained from

\[
 p_{12}p_{34}-p_{13}p_{24}+p_{14}p_{23}=0,
 \qquad \text{all }3\times3\text{ minors of }A_E(p)=0,
\]

followed by saturation away from nonregular sections and the other splitting
strata.  This computes the actual Artin scheme, not merely an intersection
number.  The required outputs are:

1. its length;
2. its reduced/etale status at the generic point;
3. the residue-field degree gcd;
4. the deck action over the exotic marked base.

This is the highest-EV next exact computation.  It is substantially smaller
than computing \(CH_0\) of the full rationally connected fourfold.

## 4. Dead routes and one quarantined coincidence

- The normalized universal-sheaf \(c_3\) route is **dead**: the exact
  twist-invariant census and Wu formula force even theta degree.
- Ambient support on \(D_+=3\Theta\) is **dead**: its primitive
  minimal-class multiplier ideal is \(6\mathbf Z\).
- Fixed-line Hecke conics and type-\((5,1)\) liaison are **dead as odd
  carriers**: they retain the charge-two parity and do not dominate the
  generic charge-three fourfold.
- Further Neron--Severi or intersection-number saturation is **dead for the
  ordering question**: it cannot detect the Picard-valued two-torsion cover.
- The integer 21 occurs both as the degree of the Chow variety of reducible
  plane cubics (line times conic) and as the unique odd \(D_+\)-intersection
  in the sparse C904 cycle.  No map identifying either with
  \(R_{3,3}(E)\) has been proved.  Treat this only as a fishing clue, not a
  theorem or evidence for the packet length.

## 5. Source boundary

- Claire Voisin, *Abel--Jacobi map, integral Hodge classes and
  decomposition of the diagonal*, arXiv:1005.5621.  Read the construction of
  \(M_9\), the proof of Lemma 2.4, and the dimension-one generic fibre of
  \(D_{3,3}\dashrightarrow M_9\) (extracted-text SHA-256
  `305c9f19cad5167e3dbe1660bf6bcafda96984330f649d85e19bbb97aae47aa3`).
- Harris--Roth--Starr, *Abel--Jacobi maps associated to smooth cubic
  threefolds*.  Read Section 4 and Corollary 4.3 for the six-dimensional
  twisted-cubic space and its generic \(\mathbf P^2\)-bundle over a theta
  translate (extracted-text SHA-256
  `2f24c8ebbde2b9b6bb6fca3b35944411d87be2218ec9126385571a57522a741b`).

Neither source prints the factorable-wedge-quadric packet or its length.
The reduction above uses only the Serre sequence, the wedge map, uniqueness
of the hyperplane span of a twisted cubic, and Voisin's fibre-dimension
theorem.

## Mystery ledger

- **Closed:** the generic \(D_{3,3}\) curve is birationally ruled by
  projective lines over a finite factorable-quadric scheme.
- **Closed:** its zero-cycle index equals the index of that finite scheme.
- **Open:** the length and residue-degree gcd of the packet.
- **Open:** whether its exotic deck action forces an odd orbit.
- **Quarantined clue:** the repeated integer 21 has no proved geometric
  bridge to the packet.
