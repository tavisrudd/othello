# C704 human proofs — functorial operator shadows

**Lane:** clebsch

**Date:** 2026-07-31

**Companion to:** notes/2026-07-30-c704-functorial-operator-shadows.md

## Strategy and classical inputs

The outer \(S_6\) model of the Joubert coordinates, the Segre and Igusa
equations, their projective duality, and the standard geometry of a
\(3\times3\) determinantal cubic are classical inputs.  The proof has
three steps.  Exterior algebra extracts the triangle cubic and its
Pfaffian from the conference matrix.  The classical Joubert line supplies
the Segre relation after one normalization.  The golden eigenspace
decomposition turns the same skew form into a determinant and matrix
factorization; the small resolutions, MCM descent, and double-six then
follow from that single presentation.  Finite certificates enter only for
the six-axis MDS lemma, the bounded later-slice table, and the two Platonic
transvectant ranks.

## 1. The conference return is the Joubert cubic

Fix the six-axis set \(X\), an oriented synthematic total \(T\), and its
skew conference matrix \(C=C_T\).  Thus \(C^2=5I\).  Put
\[
 K=*\circ\bigwedge^3 C .
\]
For a triple \(S=\{i,j,k\}\), expand the diagonal matrix coefficient of
\(\bigwedge^3C\) as its \(3\times3\) minor and then apply complementary
Hodge star.  Skew-symmetry cancels the terms with a repeated edge and
leaves
\[
 K_{SS}=4C_{ij}C_{jk}C_{ki}.
\]
Consequently \(K_{SS}\) is divisible by \(4\), and
\[
 Z_T(x)=\frac14\sum_{|S|=3}K_{SS}x_S
\]
is the signed triangle polynomial of the conference orientation.

Conjugating \(C_T\) by a permutation \(g\) permutes triples.  Reordering a
three-fold wedge and its complementary three-fold wedge contributes
\(\operatorname{sgn}(g)\).  Hence
\[
 gZ_T=\operatorname{sgn}(g)Z_{gT}.
\]
The six \(Z_T\)'s therefore span the signed outer permutation module.
Its invariant line is killed: equivalently, summing the six signed
triangle tables gives zero coefficient on every squarefree monomial.
Thus \(\sum_TZ_T=0\).

At this point the cleanest classical interface is to identify, rather
than rederive, Joubert's covariant.  The signed outer-standard module has
a one-dimensional cubic-covariant line in this degree.  The triangle
formula is nonzero and has the required sign covariance, so it is the
Joubert covariant up to one scalar; comparison of one squarefree
coefficient fixes exactly the normalization above.  The classical
Joubert--Segre relation then gives
\[
 \sum_TZ_T^3=0,
\]
and \(Z=(Z_T)\) lands on the Segre cubic.  This proves the operator lift
while using the classical relation exactly where it is clearer than a
degree-nine coefficient expansion.

Modulo \(2\), the odd entries of \(K\) record exactly when two triples
meet in one point.  That graph recovers the Johnson scheme on
\(\binom X3\), and complementation is its distinguished antipodal
involution.  Hence the support lattice used above is recovered from
\(K\); it is not extra coordinate data.

## 2. Centered squaring is the Igusa polar

On the hyperplane \(\sum_Tz_T=0\), differentiating
\(\sum_Tz_T^3\) gives the six squares \(3z_T^2\), modulo their common
scalar direction.  The projective gradient is therefore represented by
\[
 W_T=Z_T^2-\frac16\sum_UZ_U^2.
\]
This proves both that the sign twist disappears and that \(W\) is the
Segre polar map.  Summing gives \(\sum_TW_T=0\).  Newton reduction of the
power sums under \(p_1(Z)=p_3(Z)=0\), after substituting
\(W_T=Z_T^2-p_2(Z)/6\), gives
\[
 \left(\sum_TW_T^2\right)^2=4\sum_TW_T^4,
\]
the Igusa quartic equation.

For one total, let \(q_1,\dots,q_5\) be its matching quadratics.  Both
\(\operatorname{center}(Z^2)\) and
\(\operatorname{center}(\sigma_3(q))\) lie in the same irreducible outer
five-space, so an equivariant comparison is scalar.  Compare one
monomial coefficient in the explicit matching definitions; it gives
\(125/4\).  Thus
\[
 125\,\operatorname{center}_T(Z_T^2)
 =4\,\operatorname{center}_T(\sigma_3(q_T)).
\]
This coefficient comparison is also an elementary proof of the last face
of the commuting diagram.  Reversing the conference orientation sends
every \(Z_T\) to \(-Z_T\), while \(W\) is unchanged.

Setting one Segre coordinate \(z_T\) to zero leaves five coordinates with
sum and sum of cubes zero.  This is the diagonal Clebsch cubic.  Hence the
claimed Clebsch section is literal.

## 3. Pfaffian and determinant formulas

Let \(D_x=\operatorname{diag}(x_1,\dots,x_6)\).  Entrywise,
\[
 [D_x,C]_{ij}=C_{ij}(x_i-x_j),
\]
so the commutator is precisely the skew form used in the report.  Its
Pfaffian is the coefficient of the volume form in the third wedge power
of the associated two-form.  Polarize this coefficient in the six
diagonal entries of \(D_x\).  The coefficient of
\(x_S=\prod_{i\in S}x_i\) is the signed complementary minor of \(C\),
hence the diagonal Hodge coefficient \(K_{SS}\).  Therefore
\[
 \operatorname{Pf}[D_x,C]
 =\sum_{|S|=3}K_{SS}x_S=4Z_T(x).
\]
The determinant of an even skew matrix is the square of its Pfaffian, so
\[
 \det[D_x,C]=16Z_T(x)^2.
\]
Centering these determinants gives \(W_T\), and multiplying the previous
syntheme identity by \(16\) gives the stated factor \(64\).  On the
marked chart \(Z_T=\sigma_3\), the normalization
\(J_0=16\sigma_3^2\) is therefore exactly the same determinant identity.

The Cartan cubic on
\((A\otimes U^\vee)\oplus\bigwedge^2U\) restricts at
\((0,0,\omega)\) to \(\operatorname{Pf}(\omega)\).  Taking
\(\omega=[D_x,C]\) proves that this is a literal linear Pfaffian section
of the Cartan cubic.

## 4. Golden block and the six nodes

Adjoin \(s=\sqrt5\) and use
\[
 P_\pm=\frac12(I\pm C/s),\qquad V_\pm=P_\pm V.
\]
Because \(C\) acts by \(+s\) and \(-s\) on the two summands, the diagonal
blocks of \([D_x,C]\) vanish.  If
\(B_x=P_-D_xP_+\), orthogonality identifies the opposite block with
\(-B_x^{\mathsf T}\), and
\[
 [D_x,C]=
 \begin{pmatrix}0&-2sB_x^{\mathsf T}\\2sB_x&0\end{pmatrix}.
\]
Taking determinants gives
\[
 \det[D_x,C]=(2s)^6\det(B_x)^2=8000\det(B_x)^2.
\]
Comparison with \(16Z_T^2\) yields
\[
 Z_T^2=500\det(B_x)^2.
\]
After orienting the two determinant lines,
\[
 Z_T=\pm10\sqrt5\,\det B_x.
\]

The singular locus of a \(3\times3\) determinant section is where the
matrix has rank at most one.  In this frozen five-dimensional linear
system those points are the six axis classes
\([\mathbf1-6e_a]\).  This follows directly by substituting an axis class:
the projected diagonal map has one-dimensional image; conversely the
vanishing of all \(2\times2\) minors gives the six axis solutions after
quotienting the constant line.  Hence the commutator has rank two there
and rank four at a smooth point of the cubic.

The constant in the squared identity is
\(500=2^2\cdot5^3\).  This explains why only the integral-lattice prime
\(2\) and golden ramification prime \(5\) enter this determinant
normalization; the cross-Gram primes \(11,23\) cannot enter it.

## 5. Matrix factorization and small resolutions

Choose the orientation in the preceding formula and set
\[
 Q_x=\pm10\sqrt5\,\operatorname{adj}(B_x).
\]
The elementary adjugate identity gives
\[
 B_xQ_x=Q_xB_x=Z_T(x)I_3.
\]
This is a linear--quadratic matrix factorization.  On the determinant
cubic, \(B_x\) has generic rank two, so its cokernel has rank one and is
maximal Cohen--Macaulay.

The right- and left-kernel incidences
\[
 \widetilde X_+=\{(x,[v]):B_xv=0\},\qquad
 \widetilde X_-=\{(x,[w]):B_x^{\mathsf T}w=0\}
\]
are isomorphisms over the rank-two locus.  At a rank-one point the kernel
has dimension two, so the exceptional fibre is \(\mathbf P^1\).
The local determinant equation transverse to the rank-one stratum is an
ordinary quadratic node.  Thus each incidence is small and resolves all
six nodes.  Golden conjugation exchanges \(V_+\) and \(V_-\), hence
transposes \(B_x\) and exchanges the two resolutions.

The ambient resolution
\[
 0\to\mathcal O(-1)^3\xrightarrow{B_x}\mathcal O^3
 \to i_*\mathcal F_+\to0
\]
shows
\(\chi(\mathcal F_+(m))=3\binom{m+3}{3}\), the Ulrich Hilbert
polynomial for a rank-one sheaf on a cubic threefold.  The adjugate gives
the periodic continuation, so \(\mathcal F_+\) is MCM.  Its conjugate is
\(\mathcal F_-\).  Galois descent of their direct sum gives a rational
rank-two MCM sheaf \(\mathcal E\); multiplication by \(s\) on one summand
and \(-s\) on the other descends to an endomorphism satisfying
\(J_{\mathcal E}^2=5I\).

## 6. Bundle model and the double-six

Over \(\mathbf P(V_+)\), evaluation gives
\[
 A_X\otimes\mathcal O\longrightarrow
 V_-\otimes\mathcal O(1).
\]
Every nonzero vector of the golden three-space has at least four nonzero
axis coordinates, while any three projected axis columns span \(V_-\).
Therefore the map is fibrewise surjective.  Its kernel \(\mathcal E_+\)
has rank two and
\[
 c(\mathcal E_+)=(1+H)^{-3},
\quad c_1=-3H,\quad c_2=6H^2.
\]
Choosing a kernel line is exactly the incidence condition, so
\(\widetilde X_+=\mathbf P(\mathcal E_+)\).

With \(\xi=c_1(\mathcal O_{\mathbf P(\mathcal E_+)}(1))\), the projective
bundle canonical-class formula and the displayed Chern classes give
\[
 -K_{\widetilde X_+}=2\xi,\qquad \xi^3=3.
\]
A smooth member \(S\in|\xi|\) is the zero locus of a section of
\(\mathcal E_+^\vee\).  Its zeros on \(\mathbf P^2\) have length
\(c_2(\mathcal E_+^\vee)=6\), and the incidence description identifies
\(S\) with the blow-up of those six points.  Transposition gives the
other blowdown.

In the first blow-up basis \(h,e_1,\dots,e_6\), its conjugate exceptional
classes are
\[
 e_i'=2h-\sum_{j\ne i}e_j.
\]
The intersection form
\(h^2=1,\ e_i^2=-1,\ h\cdot e_i=e_i\cdot e_j=0\) for \(i\ne j\)
immediately gives
\[
 e_i\cdot e_j'=0\ (i=j),\qquad
 e_i\cdot e_j'=1\ (i\ne j),
\]
and each row is pairwise disjoint.  This is the determinantal double-six.
It does not choose C695's particular marking, exactly as stated in the
report.

## 7. Bounded later slices and Platonic feasibility

The Kostant generating functions reduce the degree-\(10\) through
degree-\(50\) question to the finite multiplicity table printed in the
report.  Balance alone does not produce a shadow: the construction needs
a canonical six-atom integral lattice so that “diagonal” and its support
scheme are intrinsic.  The later summands have no such lattice, and from
multiplicity two onward a nontrivial \(\mathrm{GL}_m\) commutant changes
every chosen diagonal pencil.  This proves failure of the functorial-input
gate in that bounded range, not an all-degree nonexistence theorem.

For binary tetrahedral symmetry,
\(\operatorname{Sym}^3=\mathbf2'\oplus\mathbf2''\).  The two conjugate
quartics are exchanged by \(\sqrt{-3}\mapsto-\sqrt{-3}\); direct
differentiation of the second transvectant gives rank two and selects one
doublet.  No transvectant of lower order separates the pair, so this is
the first feasibility gate.

For binary octahedral symmetry,
\(\operatorname{Sym}^7=\mathbf2_+\oplus\mathbf2_-\oplus\mathbf4\).
Differentiating the invariant octavic gives transvectant ranks \(8,8,6\)
in orders one, two, three.  The third map lands in
\(\mathbf2_+\oplus2\mathbf4\), so its two-dimensional kernel is
\(\mathbf2_-\); conjugation reverses the roles.  These rank statements
prove only the separators claimed in the report.

## 8. Arithmetic fibres

All displayed identities were obtained integrally before division.  At
\(2\), signs merge and centering must use the denominator-free form, but
the mod-\(2\) support graph still survives.  At \(5\), \(C^2=5I\)
becomes square-zero and the factor \(125\) records coalescence of the five
centered coordinates; the Pfaffian identity itself still reduces
integrally.  At \(11\) and \(23\), none of these integral operator
identities degenerates.  Their known defects lie in a different
cross-Gram scalar map, so they do not create new Segre--Igusa fibres here.

The marked comparison with C695 and the classification of Platonic
sisters require additional data and are not asserted here.
