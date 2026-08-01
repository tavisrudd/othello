# C743 — External mathematical review brief

**Date:** 2026-07-31

**Lane:** `golden`

## Scope

This brief isolates the mathematical claims developed in C743.  It does not
rate them or recommend a review verdict.  Full proofs, rejected alternatives,
literature depth, hashes, and replay commands are in
`notes/2026-07-31-c743-golden-a-plus-unity-compression.md`.

The manuscript was read only.  C743 proposes a later reorganization but does
not edit the paper or its verification surface.

## Central proposed form

Let \(A\) be the six-point affine source, let
\(\mathcal I_3\cong S^{(3,3)}\) be the five-dimensional matching-invariant
space, and let

\[
 \mathcal J_3:A\longrightarrow\mathcal I_3^*
\]

be the universal cubic matching covariant.  A fully marked Golden
presentation gives six matching vectors \(c_T\in\mathcal I_3\), hence a frame map

\[
 F_C:\mathcal I_3^*\longrightarrow U,
 \qquad y\longmapsto(\langle c_T,y\rangle)_T,
\]

to the signed outer augmentation module.  It also gives

\[
 \alpha_C(x)=([D_x,C_T])_T.
\]

The organizing claim is the normalized commuting square

\[
\begin{CD}
 A @>{\alpha_C}>> \displaystyle\bigoplus_T\bigwedge^2(k^X)^*\\
 @V{\mathcal J_3}VV @VV{(\operatorname{Pf}_T)_T}V\\
 \mathcal I_3^* @>{F_C}>> U .
\end{CD}
\]

The six \(c_T\) are claimed to be a regular-simplex frame, so \(F_C\) is an
isomorphism after the frozen normalization.  The marked multiplicity-one
calculation, together with C739's fixed integral axis/skew lattices and
coherent determinant-line orientation, is claimed to make \(\alpha_C\) the
unique primitive normalized lift.  C742 supplies the boundary: the corresponding source-free signed
product target has zero Hom-space, while the untwisted lift has rank two.

This form separates three levels of structure:

- \(\mathcal J_3\) and the six-point quotient are source-free;
- the synchronized skew lift retains coherent switching transport;
- a selected spectral block additionally requires a pole and Golden
  embedding.

## Two general inputs

### Pfaffian and exterior input

For an even labelled set \(X\), a skew matrix \(C\), and vectors
\(v_i\in k^2\), set

\[
 \alpha_C(v)_{ij}=C_{ij}[v_i,v_j].
\]

The claim is that one matching evaluation has the following presentations:

1. its top Pfaffian is evaluation of the universal matching covariant;
2. on the affine chart \(v_i=(1,x_i)\), it is the commutator
   \([D_x,C]\);
3. its matching coefficients are the diagonal coefficients of the middle
   exterior power;
4. if \(C^2=s^2I\) with balanced eigenspaces, then
   \(\operatorname{Pf}(\alpha_C)=\pm(2s)^m\det B\);
5. in a spectral basis, the graded pieces of
   \(\exp(\alpha_C)\) are the compound matrices
   \(\bigwedge^rB\).  In rank three these are
   \(1,B,\operatorname{adj}B,\det B\).

The bracket object is projectively natural.  The spectral splitting is not:
a non-affine change of pole does not preserve a selected eigenspace block.

### Quotient and singularity input

For the equal-weight quotient of \(2m\) points, the claim is that the same
multiplicity threshold controls three different loci:

\[
\begin{array}{c|c}
\text{maximum multiplicity }h&\text{quotient behavior}\\ \hline
h<m&\text{stable and smooth after removing orbit directions}\\
h=m&\text{strictly semistable and in the reduced critical support}\\
h>m&\text{unstable and in the matching base}
\end{array}
\]

At a closed \(m+m\) orbit, the transverse quotient slice is the rank-one
tensor map

\[
 \mu:U\oplus V\longrightarrow U\otimes V,
 \qquad(u,v)\longmapsto u\otimes v,
\]

with \(\dim U=r\), \(\dim V=s\).  If \(\mathfrak u,\mathfrak v\) are the two
coordinate ideals, the asserted maximal-minor formula is

\[
 I_{r+s-1}(d\mu)
 =\mathfrak u^s\mathfrak v^{r-1}
  +\mathfrak u^{s-1}\mathfrak v^r.
\]

The proposed human proof indexes nonzero maximal minors by spanning trees of
\(K_{r,s}\).  In the balanced case \(r=s=m-1\), this becomes

\[
 (\mathfrak u+\mathfrak v)
 \mathfrak u^{m-2}\mathfrak v^{m-2}.
\]

For \(m=3\), the local critical ideal is
\(\mathfrak m(\mathfrak u)(\mathfrak v)\).  Its radical is the union of two
transverse planes, and the quotient of the radical by the critical ideal is
square-zero of length four.  The revised human global argument has two
parts.  On the semistable locus, a saturated Luna slice identifies the map
near each closed \(3+3\) orbit with the rank-one tensor quotient, whose defect
is supported only at its origin.  On the unstable locus, for a maximal equal
block \(Q\) of size four or five, put

\[
 E_Q=\bigcap_{\substack{R\subset Q\\|R|=3}}(x_i-x_j:i,j\in R),
 \qquad
 \Delta_Q=\prod_{i\in Q,\,j\notin Q}(x_i-x_j).
\]

The matching/cofactor expansion gives

\[
 \Delta_QE_Q\subset I_4(d\mathcal J_3)\subset E_Q.
\]

Because \(\Delta_Q\) is a unit on that collision stratum, the critical ideal
is the reduced ideal \(E_Q\) there.  The partitions \(4+1+1\), \(4+2\), and
\(5+1\) exhaust the unstable projective source.  Thus the defect is supported
only at the ten nodes, and the local models give the intrinsic identification

\[
 \sqrt{I_R}/I_R
 \cong\bigoplus_y\mathfrak m_y/\mathfrak m_y^2.
\]

Separately, the perfect-matching generators of shape \((m,m)\) are identified
with the intersection of the collision ideals for subsets of size \(m+1\).
The cited two-row Specht-ideal theorem gives radicality in every
characteristic and Cohen--Macaulayness in characteristic zero or
characteristic at least \(m\).

## Cofactor consequence

Write \(A_x=(dZ_x)^{\mathsf T}\) in source-by-target augmentation bases.  Its
left kernel is the residual special-conformal infinitesimal orbit \(q\), and
its right kernel is the Segre conormal \(W\).  The general corank-one lemma
then gives

\[
 \operatorname{adj}(A_x)=\lambda Wq^{\mathsf T}.
\]

One frozen witness fixes \(\lambda=6\).  The issue for review is whether the
primitive-kernel hypotheses, generic corank, and normalization suffice to
promote the generic factorization to the stated polynomial identity over the
claimed coefficient ring.

## Claimed proof-graph change

The proposed reorganization has two constructed central objects,
\(\mathcal J_3\) and its normalized marked lift \(\alpha_C\), where the current
propagation spine presents seven.  It combines the current propagation,
synchronized-spinor, and marked-rigidity statements into one theorem.  The
report estimates eleven scoped proof obligations becoming six and a later
reduction of three to four main-text pages.

These are accounting claims, not measured manuscript changes: C743 is
research-only, and the manuscript has not yet been rewritten or rebuilt.

## Points for adversarial review

1. Is \(F_C\) truly an isomorphism of the stated signed modules, with the
   normalization and the single frame relation stated correctly?
2. Does the one-dimensional Hom-space prove uniqueness in the precise marked
   category, including integral lattice, determinant-line sign, and bad-prime
   qualifications?
3. Does the commuting square explain the synchronized skew systems, or does
   it merely package six previously known Pfaffian identities?
4. Is the arbitrary-\(C\) matching law cleanly separated from the additional
   hypothesis \(C^2=s^2I\) used for spectral compounds?
5. Does the spanning-tree argument generate the full maximal-minor ideal,
   including coefficients and signs, in every stated pair of dimensions?
6. Does the saturated-slice argument cover the complete semistable fibres,
   and does the cross-edge Laplace expansion really prove
   \(\Delta_QE_Q\subset I_4(d\mathcal J_3)\) for both \(|Q|=4,5\)?
7. Is the matching-base/Specht-ideal citation used within its exact
   characteristic range, and does the Golden six-frame span the required
   ideal rather than only define the same support?
8. Does the cotangent-defect identification glue canonically and
   \(S_6\)-equivariantly, rather than only node by node after coordinates?
9. Does the primitive-kernel cofactor lemma control all special strata after
   polynomial continuation, without claiming larger kernels are principal?
10. Are the four support, switching, pole, and Golden choices still kept
    distinct everywhere the upper lift or spectral refinement is used?

## Evidence boundary

The C743 node audit verifies the frozen six-point local ideal in Singular.
Its dependency-free replay reconstructs the tensor Jacobian and checks the
spanning-tree formula in dimensions \((2,2),(2,3),(3,2),(3,3)\).  Existing
C704, C705, C728, C739, and C742 bundles check the Golden scalars,
representation multiplicities, incidence return, synchronized spinors, and
source-free obstruction.  The C739 Singular certificate independently checks
the global Jacobian-defect support; Proposition 4.6 now supplies the human
saturated-slice and cross-discriminant proof.  Other computations corroborate
normalizations and finite identities; the general statements above rely on
the human proofs in the full report.
