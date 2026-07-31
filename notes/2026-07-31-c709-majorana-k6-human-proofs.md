# C709 human proofs — the six-Majorana lift

**Lane:** clebsch

**Date:** 2026-07-31

**Companion to:** notes/2026-07-30-c709-majorana-k6-lift.md

## Strategy

There are two different constructions.  A static signing of \(K_6\)
reduces, by a spanning tree, to cycle flux; it carries no intrinsic
intersection pairing.  The dynamic commutator \([D_x,C]\) is canonical:
exterior algebra identifies its Pfaffian with the Joubert cubic, and its
rank stratification identifies the six nodes with minimally coupled
Hamiltonians.  Keeping these constructions separate explains the split
verdict.

## 1. Pauli phases are forced

Let \(M_{ij}=i\gamma_i\gamma_j\), with \(M_{ji}=-M_{ij}\).  Under the
odd-theta dictionary, the duad \(\{i,j\}\) corresponds to
\(v_{ij}\in\mathbf F_2^4\), and
\[
 \langle v_{ij},v_{kl}\rangle
 =|\{i,j\}\cap\{k,l\}|\pmod2.
\]
This is exactly the commutator pairing of Majorana bilinears, so the
unphased identification is forced.

Fix the phases on the five \(M_{0i}\).  From
\[
 M_{0i}M_{0j}=-iM_{ij}
\]
and \(P(u)P(v)=i^{c(u,v)}P(u+v)\), one obtains
\[
 M_{ij}\longmapsto
 i^{c(v_{0i},v_{0j})+1}P(v_{ij}).
\]
The exponent is even.  Associativity then gives every triangle relation
\(M_{ab}M_{bc}=iM_{ac}\); one perfect matching fixes the central character
\(\Pi=i\gamma_0\cdots\gamma_5=+1\), and all other matching products follow.
Thus the finite phase table checks bookkeeping after a forced construction.

## 2. What diagonal Majorana gauge preserves

An edge signing \(e_{ij}\) comes from Majorana sign changes precisely when
\[
 e_{ij}=s_is_j.
\]
The simultaneous change \(s_i\mapsto-s_i\) is invisible, so the gauge
group has dimension five.  Gauge along the star at vertex \(0\) to make
all \(e_{0i}\) positive.  The remaining ten signs are
\[
 e'_{ij}=e_{0i}e_{ij}e_{j0},
\]
the triangle holonomies through \(0\).  These are the fundamental cycles
for the star spanning tree, so they are independent and determine every
cycle flux.  Hence the quotient has dimension \(15-5=10\) and \(2^{10}\)
classes.

For the conference signing, ten triangle fluxes are positive and ten
negative, with complementation exchanging the two sets.  On four vertices,
the product of the four face signs is one because every edge occurs twice.
Thus the surviving object is precisely a two-graph flux class.

## 3. The middle-exterior operator

Put \(L=\bigwedge^3C\) and \(K=*L\).  Since \(C^2=5I\), its eigenvalues
are \(\pm\sqrt5\), each three times, and
\(\det C=-125,\ C^{-1}=C/5\).  The complementary-minor identity gives
\[
 *\bigwedge^3C
 =\det(C)\bigwedge^3(C^{-1})*
 =-\bigwedge^3C*.
\]
Because \(*^2=-1\) on three-forms in dimension six,
\[
 K^2=125I.
\]

The diagonal entry indexed by a triple \(S\) is its signed complementary
minor.  The golden \(A_5\) has two orbits on triples, distinguished by
conference flux.  Expanding one representative in each orbit gives
\(-4\) and \(+4\), hence
\[
 K_{SS}=4C_{ij}C_{jk}C_{ki}
\qquad(S=\{i,j,k\}).
\]
The Hodge transformation law supplies the determinant character under an
orientation-reversing frame change.

## 4. Why there is no quadratic refinement or intrinsic spin structure

In the fixed Pauli coordinates take \(u=0001\) and \(v=0010\).  Their
symplectic pairing is zero, while the conference sign function satisfies
\[
 c(u)=c(v)=0,\qquad c(u+v)=1.
\]
Therefore \(c(u+v)+c(u)+c(v)\ne\langle u,v\rangle\), so \(c\) is none of
the sixteen quadratic refinements.  Direct substitution in
\[
 q_a(x,z)=x\cdot z+\langle a,(x,z)\rangle
\]
gives Hamming distance five for six \(a\)'s and distance nine for the
other ten.  The six nearest refinements are
\[
 a\in\{1,3,5,6,10,11\}.
\]

More fundamentally, a Kasteleyn spin structure refines the intersection
pairing supplied by an oriented surface embedding.  An abstract \(K_6\)
has a cycle space but no intrinsic surface, cyclic orders, or intersection
form.  Its two-graph flux therefore cannot canonically determine a spin
structure even if a nearby quadratic refinement were chosen.

## 5. Why constant antisymmetrization is noncanonical

The rule \(A_{ij}=C_{ij}\) for \(i<j\) chooses a total order.  A signed
conference symmetry exchanges the endpoints of an edge, so no such edge
orientation is invariant under the full \(S_5\) stabilizer.

That stabilizer acts freely on the \(720\) total orders, leaving six orbits
of size \(120\).  Coset representatives reduce the spectral calculation
to six Pfaffians and fourth coefficients.  They form three classes:
\[
\begin{array}{c|c|c}
(Q_4,\operatorname{Pf}^2)&\text{order orbits}&\text{orders}\\ \hline
(63,81)&1&120\\
(63,49)&2&240\\
(47,1)&3&360.
\end{array}
\]
For a real \(6\times6\) alternating matrix the squared singular values are
the roots of
\[
 y^3-15y^2+Q_4y-\operatorname{Pf}(A)^2.
\]
This gives the three spectra in the report.  The finite calculation is
complete because the group action has first reduced all \(720\) orders to
six representatives.

## 6. The canonical commutator family

Let
\[
 A_C(x)=[D_x,C],\qquad D_x=\operatorname{diag}(x).
\]
It is alternating, unchanged by adding a constant to \(x\), and conjugates
correctly under diagonal Majorana gauge.  Moreover
\[
 CA_C(x)+A_C(x)C=0
\]
because \(C^2=5I\).  Thus it exchanges the two golden eigenspaces.

Expand the Pfaffian as the coefficient of the volume form in the third
wedge power of the associated two-form.  Choosing complementary triples
shows that the coefficient of \(x_ix_jx_k\) is
\((*\bigwedge^3C)_{SS}=K_{SS}\).  Section 3 therefore gives
\[
 \operatorname{Pf}[D_x,C]
 =4\sum_{i<j<k}C_{ij}C_{jk}C_{ki}x_ix_jx_k
 =4Z_C(x).
\]
Squaring yields
\[
 \det A_C(x)=16Z_C(x)^2.
\]
An edge-local alternating expression linear in \(x\) and \(C_{ij}\) has
coefficient \(C_{ij}(\alpha x_i+\beta x_j)\); alternation forces
\(\beta=-\alpha\).  Hence the commutator is unique up to scalar in the
declared ansatz.

The characteristic polynomial identity for a \(6\times6\) alternating
matrix,
\[
 \chi_A(\lambda)=\lambda^6+Q_2\lambda^4+Q_4\lambda^2+
 \operatorname{Pf}(A)^2,
\]
then gives the full formula reported for the family.

## 7. Symmetry and fermion parity

If \(P^{\mathsf T}CP=\epsilon DCD\), with \(D\) diagonal, then \(D\)
commutes with \(D_x\), so the commutator families are orthogonally
conjugate up to the global sign \(\epsilon\).  Singular spectra and
determinants are invariant; the orientation-preserving \(A_5\) fixes
\(Z_C\) and the other \(S_5\) coset negates it.

Put a nonsingular real alternating matrix in oriented \(2\times2\) block
form.  The ground-state parity of the three complex fermions is the
product of the block signs, namely
\(\operatorname{sgnPf}(A)\).  Since
\(\operatorname{Pf}A_C(x)=4Z_C(x)\), the Joubert cubic is exactly the
gap-closing and parity-changing wall.  Reversing the Majorana orientation
flips both Pfaffian and parity convention, so the statement is
gauge-consistent.

## 8. Complete rank stratification

On the augmentation quotient, \(x\mapsto A_C(x)\) is injective: all
off-diagonal entries of \(C\) are nonzero, so \([D_x,C]=0\) forces all
\(x_i\) equal.  Pfaffian zero means rank at most four.  Rank at most two
also kills every first derivative of the Pfaffian, so it lies in the
singular locus of the restricted cubic.  C691 identifies that locus as
\[
 p_a=[\mathbf1-6e_a],\qquad 0\le a<6.
\]

At \(p_a\),
\[
 A_C(p_a)=-6[E_{aa},C].
\]
Only row and column \(a\) are nonzero, and that row has squared norm
\(36\sum_jC_{aj}^2=180\).  Thus the rank is two.  These six points are
therefore exactly the rank-two locus; smooth cubic points have rank four
and off-cubic points rank six.

Define
\[
 \widetilde\gamma_a=\frac1{\sqrt5}\sum_jC_{aj}\gamma_j.
\]
The identity \(C^2=5I\) makes this another Majorana frame, and
\(C_{aa}=0\) makes \(\gamma_a\) anticommute with
\(\widetilde\gamma_a\).  Substitution gives
\[
 \widehat H_C(p_a)=-3i\sqrt5\,\gamma_a\widetilde\gamma_a,
\qquad
 \chi_{A_C(p_a)}(\lambda)=\lambda^4(\lambda^2+180).
\]
Hence each node is one cross-golden dimer with four Majorana zero modes.

Exact computation remains only for the small phase table, six order
representatives, and normalization checks after the structural reductions
above.
