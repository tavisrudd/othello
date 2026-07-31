# C709 — human proofs for the six-Majorana lift

**Date:** 2026-07-31

**Scope:** proof companion to
`notes/2026-07-30-c709-majorana-k6-lift.md`

Every mathematical conclusion in the C709 report follows from the arguments
below.  The certificate fixes signs, expands small Pfaffians, and replays the
formulas; no exhaustive search is load-bearing.  The only imported theorem is
C691's already proved description of the singular locus of the orientation
cubic as its six-node projective frame.

## 1. Pauli--Majorana phases

Let
\[
 M_{ij}=i\gamma_i\gamma_j,qquad M_{ji}=-M_{ij},
\]
and let (v_{ij}in\mathbf F_2^4) be the difference of the two odd theta
characteristics indexed by (i,j).  The theta-characteristic formula gives
\[
 \langle v_{ij},v_{kl}\rangle
 =|\{i,j\}\cap\{k,l\}|\pmod2
\]
for distinct duads.  This is exactly the commutator pairing of the Majorana
bilinears: two such bilinears anticommute precisely when their edges share
one endpoint.  Hence the unphased dictionary is forced.

Fix (M_{0i}\mapsto P(v_{0i})).  For (0<i<j), the Clifford relation
\[
 M_{0i}M_{0j}=-iM_{ij}
\]
and the Hermitian Pauli multiplication law
\(P(u)P(v)=i^{c(u,v)}P(u+v)\) uniquely give
\[
 M_{ij}\longmapsto
 i^{c(v_{0i},v_{0j})+1}P(v_{ij}).
\]
The exponent is even, so the coefficient is (\pm1), and substitution gives
the table in the report.  All relations
\(M_{ab}M_{bc}=iM_{ac}\) then follow associatively from the same Clifford
identity.  One perfect matching fixes the central character to
\(\Pi=i\gamma_0\cdots\gamma_5=+1\); the other matching products follow from
the triangle relations.  Thus the script's 120 triangle and fifteen matching
checks certify phase bookkeeping rather than prove existence.

## 2. Gauge quotient and two-graph flux

An edge rephasing (e_{ij}) comes from diagonal Majorana signs precisely when
\[
 e_{ij}=s_is_j.
\]
The simultaneous replacement (s_i\mapsto-s_i) is the kernel, so the
(2^6) vertex sign choices give (2^5) edge gauges.

Now gauge any edge signing so that the five edges (0i) are positive.  The
ten remaining edge signs become
\[
 e'_{ij}=e_{0i}e_{ij}e_{j0},
\]
which are exactly the ten triangle holonomies through vertex (0).  They are
independent, and every other cycle is a sum of these fundamental cycles.
Hence the gauge quotient has dimension
\[
 15-(6-1)=10
\]
and exactly (2^{10}) classes.  This spanning-tree argument proves that the
triangle two-graph is the complete gauge invariant.

For the displayed conference matrix, reading the twenty triples gives ten
positive and ten negative signs; complementation exchanges the classes.  On
any four vertices, the product of the four face signs is one because every
edge occurs twice.  This is the four-point two-graph identity.

## 3. The middle-exterior operator

Put (L=\Lambda^3C\) and (K=*L\).  From (C^2=5I\), the eigenvalues of (C)
are (\sqrt5) and (-\sqrt5), each three times.  Therefore
\[
 \det C=-125,qquad C^{-1}=C/5.
\]
The complementary-minor/Hodge identity gives
\[
 *\Lambda^3C
 =\det(C)\Lambda^3(C^{-1})*=-\Lambda^3C*.
\]
Since (*^2=-1\) on three-forms in dimension six,
\[
 K^2=*L*L=L^2=\Lambda^3(C^2)=125I.
\]

The diagonal entry indexed by a triple (S) is the signed complementary
minor (\det C_{S^c,S}\).  The oriented (A_5) is transitive on each of the
two ten-element triangle-sign classes.  It is therefore enough to expand one
minor in each: (S=012) gives (-4), and (S=014) gives (+4).  Thus
\[
 K_{SS}=4C_{ij}C_{jk}C_{ki}=4t_S
\]
for all (S=\{i,j,k\}).

Under a diagonal orthogonal frame change, transporting the orientation
transports the Hodge star and conjugates (K) on (\Lambda^3\).  Holding the
star fixed under an orientation-reversing change introduces exactly the
determinant character by the standard Hodge transformation law.  This proves
the report's oriented/projective gauge statement.

## 4. No quadratic refinement and no intrinsic spin structure

There is a one-line obstruction to quadraticity.  In the fixed Pauli
coordinates take
\[
 u=0001,qquad v=0010.
\]
They have symplectic pairing zero.  The conference sign function satisfies
\[
 c(u)=c(v)=0,qquad c(u+v)=c(0011)=1.
\]
Consequently
\[
 c(u+v)+c(u)+c(v)\ne\langle u,v\rangle,
\]
so (c) is not a quadratic refinement.  This single contradiction proves
the negative theorem without enumerating the sixteen refinements.

For the stronger distance statement, direct substitution in
\[
 q_a(x,z)=x\mathbin\cdot z+\langle a,(x,z)\rangle
\]
gives distance five for
\[
 a\in\{1,3,5,6,10,11\}
\]
and distance nine for the other ten values of (a).  This is a displayed
six-versus-ten hand table; the certificate rechecks it.

The spin conclusion is a missing-datum theorem.  An abstract graph has a
cycle space but no intrinsic intersection pairing on it.  A Kasteleyn spin
structure is a quadratic refinement of the intersection form supplied by an
oriented surface embedding.  The abstract (K_6) duad model specifies no
surface, cyclic orders, or intersection form.  Its flux character therefore
cannot canonically determine a spin structure.

## 5. Constant skewing and its three spectra

The rule (A_{ij}=C_{ij}) for (i<j) chooses an orientation of every edge.
The signed (S_5) stabilizer contains the permutation
\[
 (0,1,2,3,4,5)\longmapsto(1,0,2,3,5,4),
\]
which exchanges the endpoints of edge (01).  Hence no edge orientation,
and thus no constant skewing of this kind, is invariant under the full
conference symmetry.

The exact spectrum census also has a short group proof.  The signed
stabilizer (G\cong S_5) has order 120 and acts freely on total orders, so
the 720 orders split into six (G)-orbits of size 120.  Using the C706
generators
\[
 (0,2,4,1,5,3),\quad
 (1,0,3,2,4,5),\quad
 (0,1,4,5,3,2),
\]
ordinary coset reduction gives
\[
\begin{array}{c|c|c}
012345&(Q_4,\operatorname{Pf}^2)=(63,81)&1\text{ orbit},\\
012354, 012435&(63,49)&2\text{ orbits},\\
012453, 012534, 012543&(47,1)&3\text{ orbits}.
\end{array}
\]
For each representative, the numbers follow from the fifteen-term
Pfaffian expansion and
\[
 Q_4=\sum_{|S|=4}\operatorname{Pf}(A_S)^2.
\]
Multiplying the orbit counts by 120 proves (120,240,360).  The squared
singular values are the roots of
\[
 y^3-15y^2+Q_4y-\operatorname{Pf}(A)^2.
\]
The first two polynomials factor as
\((y-3)^2(y-9)\) and \((y-1)(y-7)^2\); the third is
\(y^3-15y^2+47y-1\).

## 6. The commutator family and the Pfaffian cubic

The matrix
\[
 A_C(x)=[D_x,C]
\]
is alternating because (D_x) and (C) are symmetric.  It is invariant
under (x\mapsto x+c\mathbf1\), and diagonal Majorana gauge conjugates it
because the gauge matrix commutes with (D_x).

The golden anticommutation is immediate:
\[
\begin{aligned}
 CA_C(x)+A_C(x)C
 &=CD_xC-C^2D_x+D_xC^2-CD_xC\\
 &=0.
\end{aligned}
\]
Thus (A_C(x)) exchanges the (\pm\sqrt5) eigenspaces of (C).

Expand its Pfaffian.  Choosing one endpoint from each edge of a perfect
matching shows that only squarefree cubic monomials occur.  The coefficient
of (x_ix_jx_k) is the signed complementary minor
\[
 (*\Lambda^3C)_{S,S}=K_{SS},qquad S=\{i,j,k\}.
\]
Section 3 gives (K_{SS}=4t_S), so
\[
 \operatorname{Pf}[D_x,C]
 =4\sum_{i<j<k}t_{ijk}x_ix_jx_k=4Z_C(x).
\]
Squaring proves
\(\det A_C(x)=16Z_C(x)^2\).

For any six-dimensional alternating matrix,
\[
\begin{aligned}
 \chi_A(\lambda)
 ={}&\lambda^6+
 \left(\sum_{i<j}A_{ij}^2\right)\lambda^4\\
 &+\left(\sum_{|S|=4}\operatorname{Pf}(A_S)^2\right)\lambda^2
 +\operatorname{Pf}(A)^2.
\end{aligned}
\]
Substitution gives the report's (Q_2,Q_4,16Z_C^2\) formula.

Finally, an edge-local alternating expression linear in (x) and (C_{ij})
has coefficient (C_{ij}(\alpha x_i+\beta x_j)\).  Alternation forces
\(\beta=-\alpha\), so the family is a scalar multiple of
\((x_i-x_j)C_{ij}\).  This proves uniqueness in the declared ansatz.

## 7. Symmetry and fermion parity

For a signed two-graph symmetry,
\[
 P^{\mathsf T}CP=\epsilon DCD
\]
with diagonal (D).  Since (D) commutes with (D_x), the corresponding
commutator matrices are orthogonally conjugate up to the global sign
\(\epsilon\).  Their singular spectra and determinants are invariant.  The
orientation-preserving (A_5) fixes (Z_C), and the other (S_5) coset
negates it, exactly as in C691's intrinsic sign-character theorem.

Put a nonsingular real alternating (A) into oriented orthogonal block form
with blocks
\[
 \begin{pmatrix}0&\sigma_r\\-\sigma_r&0\end{pmatrix}.
\]
The three complex-fermion occupation factors show that ground-state parity,
relative to the chosen Majorana orientation, is the product of the three
block signs.  That product is (\operatorname{sgnPf}(A)\).  Since
\(\operatorname{Pf}A_C(x)=4Z_C(x)\), the cubic is precisely the
parity-changing gap wall.  An orientation-reversing frame change flips both
the Pfaffian and the parity convention, so the physical statement is
gauge-consistent.

## 8. Complete rank stratification

On the augmentation quotient, (x\mapsto A_C(x)) is injective: because all
off-diagonal entries of (C) are nonzero,
\([D_x,C]=0\) forces all (x_i) equal.

For a (6\times6) alternating matrix, Pfaffian zero is equivalent to rank at
most four, and the differential of the ambient Pfaffian is the vector of
signed (4\times4) Pfaffians.  Hence rank at most two implies singularity of
the restricted Pfaffian cubic.  C691 proves that its projective singular
locus consists exactly of
\[
 p_a=[\mathbf1-6e_a],\qquad 0\le a<6.
\]

At (p_a),
\[
 A_C(p_a)=-6[E_{aa},C].
\]
Only row and column (a) are nonzero.  That row has squared norm
\(36\sum_jC_{aj}^2=180\), so the matrix has rank two.  Therefore these six
points, and only these, have rank two.  A smooth point of the cubic has rank
four; a point off the cubic has rank six.

Define the second Majorana frame
\[
 \widetilde\gamma_a=\frac1{\sqrt5}\sum_jC_{aj}\gamma_j.
\]
The identity (C^2=5I\) gives the Majorana anticommutation relations for the
tilde frame, and (C_{aa}=0\) gives
\(\{\gamma_a,\widetilde\gamma_a\}=0\).  Direct substitution yields
\[
 \widehat H_C(p_a)=-3i\sqrt5\gamma_a\widetilde\gamma_a.
\]
Thus a node is one cross-golden dimer with four zero Majoranas.  Its only
nonzero singular value is (6\sqrt5\), so
\[
 \chi_{A_C(p_a)}(\lambda)=\lambda^4(\lambda^2+180).
\]
This proves the nodal interpretation and recovers the six-axis carrier from
the six minimally coupled Hamiltonians.

## Proof boundary

The C709 conclusions are now human-proved.  Exact computation remains useful
for the fifteen phase signs, the six small orbit representatives, and
normalization (4), but each is a direct finite expansion inside a stated
proof.  No claim of a surface-dependent Kasteleyn classification is made.
