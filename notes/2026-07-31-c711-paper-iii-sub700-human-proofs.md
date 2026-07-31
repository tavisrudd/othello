# C711 — Paper III sub-700 golden-return human proofs

**Lane:** `clebsch`

**Status:** complete human proof package; normalization frozen for C680 and
C712.

## Result and conventions

Put
\[
 E=\mathbf Q(t)=\mathbf Q(\sqrt5),\qquad t^2=t+1,
 \qquad s=\sqrt5=2t-1.
\]
Let \(V=\mathbf Z^6\) have ordered orthonormal basis
\(e_0,\ldots,e_5\) and the orientation
\(e_0\wedge\cdots\wedge e_5\).  The six oriented golden axes are
\[
 a_0=(0,t,1),\ a_1=(0,t,-1),\ a_2=(1,0,t),
\]
\[
 a_3=(-1,0,t),\ a_4=(t,-1,0),\ a_5=(-t,-1,0).
\]
Their signed Gram matrix defines
\[
 G=(a_i\mathbin\cdot a_j)=(t+2)I+tC,
\]
where
\[
C=\begin{pmatrix}
0&1&1&1&-1&-1\\
1&0&-1&-1&-1&-1\\
1&-1&0&1&1&-1\\
1&-1&1&0&-1&1\\
-1&-1&1&-1&0&-1\\
-1&-1&-1&1&-1&0
\end{pmatrix}.
\]
For a triple \(S=\{i,j,k\}\), always written with \(i<j<k\), set
\[
 c_S=C_{ij}C_{jk}C_{ki},\qquad
 Z_C(x)=\sum_{|S|=3}c_Sx_S,
 \qquad x_S=\prod_{i\in S}x_i.
\]
This fixes the oriented generator of the cubic line.  Replacing \(C\) by
\(-C\) reverses that orientation.  Switching axis representatives must also
transport the orientation of \(V\); keeping the old Hodge star after an odd
switch changes the middle-exterior sign and is a different convention.

On \(\Lambda^3V\), order the basis by increasing triples and define the Hodge
operator by
\[
 *e_S=\epsilon(S,S^c)e_{S^c},
\]
where \(\epsilon(S,S^c)\) is the sign of the concatenated ordered lists
\((S,S^c)\).  Thus \(*^2=-I\).  The middle-exterior return is
\[
 K=*\,\Lambda^3C.
\]

The proofs below use no classification search, interpolation grid, stored
matrix equality, or certificate.  The exact programs cited at the end audit
the displayed arithmetic independently.

## 1. The golden conference operator

**Lemma 1 (signed Gram construction).**  The matrix \(C\) is symmetric, has
zero diagonal and off-diagonal entries in \(\{\pm1\}\), and satisfies
\[
 C^2=5I.
\]
Replacing the axis representatives by \(d_ia_i\), with \(d_i=\pm1\), sends
\(C\) to \(DCD\), where \(D=\operatorname{diag}(d_i)\).

**Proof.**  The six displayed dot products have diagonal value \(t+2\) and
off-diagonal value \(t\) or \(-t\), giving the displayed symmetric matrix.
Let \(A\) be the matrix whose rows are the \(a_i\).  Pairing the opposite
signs in the list of axes gives
\[
 A^{\mathsf T}A=2(t+2)I_3.
\]
Indeed, each diagonal sum is \(2+2t^2=2(t+2)\), and every mixed sum cancels.
Consequently
\[
 G^2=A(A^{\mathsf T}A)A^{\mathsf T}=2(t+2)G.
\]
Substitute \(G=(t+2)I+tC\).  The terms linear in \(C\) cancel and leave
\[
 t^2C^2=(t+2)^2I.
\]
Since \(t+2=st\), this is \(C^2=s^2I=5I\).  Finally, changing the sign of
row \(i\) of \(A\) changes the sign of row and column \(i\) of \(G\), hence
sends \(C\) to \(DCD\).  \(\square\)

**Tao-style check after Lemma 1.**  The tight-frame identity is the real
reason for \(C^2=5I\); a row-by-row square would hide it.  It also exposes the
only divisions: \(t\) is a unit in \(\mathbf Z[t]/(t^2-t-1)\), so the identity
is integral.  Symmetry and switching covariance are therefore properties of
the Gram construction, not of the displayed labeling.

## 2. The triangle tensor and augmentation descent

**Lemma 2 (orientation cubic).**  The signs \(c_S\) are invariant under
switching \(C\mapsto DCD\).  They are negated by \(C\mapsto-C\).  They obey
the four-point identity
\[
 c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1
\]
and the pair-balance identities
\[
 \sum_{k\ne i,j}c_{ijk}=0\qquad(i\ne j).
\]
Moreover
\[
 Z_C(x+u\mathbf1)=Z_C(x)
\]
as an identity over \(\mathbf Z[x_0,\ldots,x_5,u]\).  Thus \(Z_C\) descends
to the augmentation quotient \(V/\mathbf Z\mathbf1\).  Over a ring in which
6 is invertible this quotient is the usual sum-zero five-space.

**Proof.**  In a triangle product every switching sign occurs twice, whereas
negating \(C\) contributes three minus signs.  In the product over the four
faces of a four-set, each of its six edges occurs twice, proving the
four-point identity.

For \(i\ne j\), symmetry, the zero diagonal, and \(C^2=5I\) give
\[
 0=C_{ij}(C^2)_{ij}
  =C_{ij}\sum_k C_{ik}C_{kj}
  =\sum_{k\ne i,j}C_{ij}C_{jk}C_{ki}.
\]
This is pair balance.  Expand \(Z_C(x+u\mathbf1)\).  The coefficient of
\(ux_ix_j\) is the pair-balance sum.  Summing pair balance over all \(j\ne i\)
shows that twice the coefficient of \(u^2x_i\) is zero as an integer, so that
coefficient is zero.  Summing once more shows that three times the coefficient
of \(u^3\) is zero as an integer, so it too vanishes.  Hence the polynomial is
translation invariant integrally.  \(\square\)

The support-orientation torsor is the choice between \(Z_C\) and \(-Z_C\).
The frozen C690/C691 coordinate order is obtained from the natural axis order
by
\[
 \pi=(0,1,4,5,3,2),\qquad
 D=\operatorname{diag}(1,1,-1,1,1,1).
\]
The equivariant six-set comparison is unique because the point stabilizer
\(D_5\) is self-normalizing in \(A_5\); the displayed \(\pi\) sends the
stabilizer-fixed first axis to the frozen first coordinate, and hence fixes
the whole comparison.  Switching by \(D\) does not change triangle products.
In the transported order their positive supports are
\[
 012,\ 013,\ 024,\ 035,\ 045,\ 125,\ 134,\ 145,\ 234,\ 235.
\]
Their complements are the ten negative supports.  This is exactly C690's
selected leader-support orbit and its complementary orbit, with coefficient
\(+1\) on \(012\).  It fixes the normalized C691 cubic rather than only its
unoriented line.  Every sign in the displayed list follows by multiplying
three entries of the displayed \(C\); equivariance reduces the comparison of
the two ten-sets to the representative \(012\).

**Tao-style check after Lemma 2.**  Pair balance is stronger than a verified
twenty-term cancellation: it is exactly the off-diagonal part of \(C^2=5I\).
It forces every lower signed moment to vanish and explains why degree three is
the first oriented layer.  The exact Paper I normalization requires only the
one equivariant support comparison and one oriented coefficient.  The quotient
formulation is safer than identifying with a sum-zero hyperplane at primes
\(2\) or \(3\).

## 3. Converse reconstruction without switching enumeration

**Lemma 3 (two-graph converse).**  Suppose signs \(c_{ijk}\in\{\pm1\}\)
satisfy the four-point identities.  They determine a signed complete graph
with zero diagonal uniquely up to switching.  If in addition all pair-balance
sums vanish, the reconstructed matrix satisfies \(C^2=5I\).  Up to relabeling
there is one such balanced switching class.

**Proof.**  Choose a temporary vertex \(0\), impose the gauge \(C_{0i}=1\),
and put
\[
 C_{ij}=c_{0ij}\qquad(0<i<j).
\]
For \(0<i<j<k\), the four-point identity on \(\{0,i,j,k\}\) gives
\[
 C_{ij}C_{jk}C_{ki}=c_{0ij}c_{0jk}c_{0ik}=c_{ijk}.
\]
Any other signed graph with the same triangle signs switches to this gauge by
taking \(d_0=1\) and \(d_i=C_{0i}\), so uniqueness is exactly uniqueness up to
switching.

The diagonal entries of \(C^2\) are five.  For \(i\ne j\), the calculation in
Lemma 2 reverses:
\[
 (C^2)_{ij}=C_{ij}\sum_{k\ne i,j}c_{ijk}.
\]
Thus pair balance is equivalent to \(C^2=5I\).

It remains to identify the class without enumerating switching classes.  In
the gauge \(C_{0i}=1\), the five equations \((C^2)_{0i}=0\) say that every
vertex among \(1,\ldots,5\) has two positive and two negative incident edges.
The positive graph is therefore a 2-regular simple graph on five vertices,
hence a pentagon.  Conversely, for two vertices of the pentagon, their four
sign coordinates against vertex \(0\) and the other three vertices have dot
product zero, whether the two are adjacent or not; all remaining
off-diagonal equations follow.  All pentagons
are relabelings of one another.  \(\square\)

**Tao-style check after Lemma 3.**  The four-point law alone reconstructs a
switching class but does not make it golden.  Pair balance is the missing
metric condition.  Once the gauge is fixed, the conference classification
collapses to the elementary statement that a 2-regular graph on five vertices
is a 5-cycle; no switching-class census remains in the proof.

## 4. The middle-exterior return and its diagonal

**Lemma 4 (middle exterior).**  With the orientation fixed above,
\[
 K^2=125I_{20},\qquad K_{SS}=4c_S.
\]
The eigenvalues of \(K\) over \(E\) are \(+5s\) and \(-5s\), each ten times.

**Proof.**  Set \(Q=C/s\).  Lemma 1 and symmetry show that \(Q\) is
orthogonal.  The eigenvalues of \(C\) are \(+s\) and \(-s\), each with
multiplicity three because \(\operatorname{tr}C=0\); hence
\(\det Q=-1\).  For an orthogonal map on an oriented six-space,
\[
 *\Lambda^3Q=(\det Q)\Lambda^3Q*= -\Lambda^3Q*.
\]
Together with \(*^2=-I\) and \((\Lambda^3Q)^2=I\), this gives
\(( *\Lambda^3Q)^2=I\).  Since \(\Lambda^3C=s^3\Lambda^3Q\), we obtain
\[
 K^2=s^6I=125I.
\]

The square uses only normalized orthogonality.  The diagonal uses a different
object: the oriented volume of a three-seed Krylov lattice.  For a
triple \(S\), let
\[
 P_S=(e_i,e_j,e_k,Ce_i,Ce_j,Ce_k).
\]
If rows are reordered as \((S,S^c)\), block elimination gives
\[
 \det P_S=\epsilon(S,S^c)\det C_{S^c,S},
\]
whereas the definition of the Hodge star gives
\[
 K_{SS}=\epsilon(S^c,S)\det C_{S^c,S}=-\det P_S. \tag{4.1}
\]

Switching axes \(4,5\) puts the displayed matrix in the gauge of Lemma 3;
this even switch preserves the chosen orientation and all the determinants
below.  In that gauge the positive graph on \(1,\ldots,5\) is a pentagon.
Its orientation-preserving signed dihedral action is transitive on the
pentagon edges and on its diagonals.  Thus triples containing \(0\) have two
orbits, distinguished by \(c_S=+1\) or \(-1\); complementation supplies the
other two orbits.  For the displayed marking, representatives give
\[
\begin{array}{c|c|c|c}
S&c_S&C_{S^c,S}&\det C_{S^c,S}\\ \hline
\{0,1,4\}&+1&
\begin{pmatrix}1&-1&1\\1&-1&-1\\-1&-1&-1\end{pmatrix}&-4\\[2mm]
\{0,1,2\}&-1&
\begin{pmatrix}1&-1&1\\-1&-1&1\\-1&-1&-1\end{pmatrix}&4.
\end{array}
\]
Both concatenation signs \(\epsilon(S,S^c)\) are \(+1\), so (4.1) gives
\(K_{SS}=4c_S\) on these two orbits.  Finally,
\(*K=-\Lambda^3C\) and \(K*=\Lambda^3C\), so \(K\) anticommutes with
\(*\).  Jacobi's principal complementary-minor identity, using
\(C^{-1}=C/5\) and \(\det C=-125\), gives
\(\det C_{S^c}=-\det C_S\).  Since \(\det C_S=2c_S\), this is
\(c_{S^c}=-c_S\).  Hodge complementation
therefore transports the identity to the other two triple orbits.  This
proves the diagonal formula for all \(S\).

The square already restricts the eigenvalues to \(\pm5s\).  The diagonal
formula and the ten-plus/ten-minus triangle balance give \(\operatorname{tr}K=0\),
so both multiplicities are ten.  \(\square\)

**Tao-style check after Lemma 4.**  Two sign traps are now visible.  First,
\(*^2=-I\) in middle degree six; the second minus sign comes from the
orientation reversal \(\det(C/s)=-1\), so the square is positive.  Second,
the diagonal formula depends on transporting the orientation when the axis
basis is switched.  The proof reduces twenty minors to two dihedral
representatives plus Hodge complementation; its scalar \(4\) is a determinant,
not a fitted coefficient.

## 5. Recovery of the distinguished support lattice

**Lemma 5 (parity reconstruction).**  On the distinguished lattice
\(\Lambda^3V\),
\[
 K_{ST}\equiv1\pmod2\quad\Longleftrightarrow\quad |S\cap T|=1.
\]
The reduction \(K\bmod2\) reconstructs equality, intersection one,
intersection two, and complementation on the twenty triples.  It therefore
recovers the six-axis carrier up to permutation and complement duality.
After choosing one of the two dual atom reconstructions and an orientation,
the full integral operator \(K\) recovers \(C\), with orientation reversal
corresponding to \(C\mapsto-C\).

**Proof.**  Modulo \(2\), the conference matrix has zero diagonal and every
off-diagonal entry equal to one.  From the compound-matrix definition and the
Hodge permutation,
\[
 K_{ST}\equiv\det C_{S^c,T}\pmod2.
\]
Put \(m=|S^c\cap T|=3-|S\cap T|\).  Up to independent row and column
permutations, \(C_{S^c,T}\) is a \(3\times3\) all-ones matrix with \(m\)
matched positions changed to zero.  Its determinant over \(\mathbf F_2\) is
\[
\begin{array}{c|cccc}
m&0&1&2&3\\ \hline
\det&0&0&1&0.
\end{array}
\]
This proves the parity criterion.

Let \(\Gamma\) be the resulting intersection-one graph.  If \(S,T\) are
complementary, no triple can meet both in one point; if \(S=T\), their common
neighbors are the nine neighbors of \(S\).  When \(|S\cap T|=1\), a common
neighbor must choose one of the two points in \(S\setminus T\), one of the two
points in \(T\setminus S\), and the unique point outside \(S\cup T\), giving
four choices.  Complementing \(T\) gives the same count when
\(|S\cap T|=2\).  Thus the common-neighbor counts for intersection sizes
\(0,1,2,3\) are \(0,4,4,9\).  The complement
of a triple is its unique distinct vertex with no common neighbor.  Equality
is already known, adjacency gives intersection one, and the remaining
distinct noncomplementary pairs give intersection two.

The atoms can now be reconstructed without naming them in advance.  In the
intersection-two graph the maximum four-cliques are exactly
\[
 \{S:A\subset S\}\quad(|A|=2),
 \qquad
 \{S:S\subset B\}\quad(|B|=4).
\]
The two families have fifteen members and complementation exchanges them.
Choose either family and join two of its four-cliques when they share a
triple.  This is the intersection graph of the two-subsets of a six-set; its
six maximum five-cliques recover the points.  Choosing the other family
applies complement duality.

Choose one recovered atom family and orient its six-dimensional permutation
lattice.  The complement involution and the orientation recover the Hodge
operator, including its signs.  The defining equation for \(K\) then gives
\[
 \Lambda^3C=-*K.
\]
The kernel of the exterior-cube representation
\(\Lambda^3:\operatorname{GL}_6\to\operatorname{GL}_{20}\) is the scalar
group \(\mu_3\).  Over \(\mathbf Q\), its only rational point is \(1\);
hence \(\Lambda^3C\) determines \(C\) uniquely.  Reversing the recovered
orientation negates \(*\), and therefore negates \(\Lambda^3C\); this is
exactly the replacement \(C\mapsto-C\).  The other atom family is the
expected complement duality.  \(\square\)

There is also no new family-preserving projective symmetry in dimension
twenty.  The oriented and unoriented conference normalizers are \(A_5\) and
\(S_5\).  Every element has two central signed lifts to the axis lattice.
The \(A_5\)-lifts have determinant one.  For the outer coset it is enough to
use the generator
\[
 \pi=(0,1,4,5,3,2),\qquad
 D=\operatorname{diag}(1,-1,1,1,1,1):
\]
both \(\pi\) and \(D\) have determinant \(-1\), so \(D\pi\) has determinant
one and conjugates \(C\) to \(-C\).  Therefore its exterior cube conjugates
\(K=*\Lambda^3C\) to \(-K\).  The family-preserving projective stabilizer of
\(K\) is exactly \(A_5\), while the stabilizer of its line is exactly \(S_5\).

The dual atom family supplies the missing second half.  Lemma 4 gives
\(*K=-K*\), so conjugation by the Hodge operator sends \(K\) to \(-K\).
Every signed \(S_5\)-lift above has determinant one, hence its exterior cube
commutes with \(*\).  Since axis lifts preserve an atom family and \(*\)
exchanges the two families, their projective groups meet trivially and
commute.  The full projective line normalizer is therefore
\[
 S_5\times C_2.
\]
If \(\chi:S_5\to\{\pm1\}\) is the conference orientation character and
\(\delta\in C_2\) records Hodge complementation, then
\((g,\delta)\) acts on \(K\) by \(\chi(g)(-1)^\delta\).  The exact projective
stabilizer of \(K\) is the kernel of this character, the graph of \(\chi\),
and is therefore another copy of \(S_5\).  Thus \(K\) couples outer
orientation reversal to complement duality instead of choosing either one
separately.

**Tao-style check after Lemma 5.**  The theorem is lattice-theoretic.  The
rational conjugacy class of \(K\) records only two ten-dimensional eigenspaces
and cannot distinguish twenty support vectors.  Modulo \(2\), however, signs
disappear while the zero pattern of compound minors becomes the Johnson
scheme.  Once that lattice data restores the Hodge operator, the full return
restores \(C\), not only its cubic diagonal.  Prime \(2\) is therefore both
the reconstruction device and the place where cubic orientation itself
collapses.  Over a field containing nontrivial cube roots of unity, exterior
faithfulness leaves the exact \(\mu_3\) scalar ambiguity; over \(\mathbf Q\)
that ambiguity disappears.

## 6. Human derivation of the degree-ten return

Let \(L=E(i)\), with \(i^2=-1\), and for \(a=(a,b,c)\) define
\[
 q_a(u,v)=a(u^2-v^2)+bi(u^2+v^2)+2cuv,
 \qquad z_a=q_a^5.
\]
Put
\[
 F_{\rm ax}=\prod_{r=0}^5q_{a_r},\qquad
 \Delta(f)=(f,F_{\rm ax})_3,
 \qquad T_{10}=\Delta^\dagger\Delta.
\]
Here
\[
 (f,g)_3=\sum_{r=0}^3(-1)^r\binom3r
 \partial_u^{3-r}\partial_v^rf\,
 \partial_u^r\partial_v^{3-r}g,
\]
and the Fischer form on \(\operatorname{Sym}^n\) is
\[
 \langle u^{n-j}v^j,u^{n-k}v^k\rangle
 =\delta_{jk}(n-j)!j!,
\]
with \(i\mapsto-i\) and \(t\) fixed in the first argument.

**Lemma 6 (exact return scalar).**  The six decimics \(z_{a_r}\) are
independent, their span is the signed-axis module
\(W^-=\mathbf3\oplus\mathbf3'\), and in their ordered basis
\[
 \boxed{
 T_{10}=211625906798592000(11+18t)(sI-C).
 }
\]
Golden conjugation exchanges the kernel and nonzero summand.

**Proof.**  The Cartan quadratic map intertwines rotations of the axes with
the binary-form action.  Hence \(a_r\mapsto z_{a_r}\) extends to an
\(A_5\)-map from the signed-axis module \(\mathbf3\oplus\mathbf3'\) to
\(\operatorname{Sym}^{10}\).  If an icosahedral rotation has angle \(\theta\),
then
\[
 \chi_{\operatorname{Sym}^n}(\theta)
 =\frac{\sin((n+1)\theta/2)}{\sin(\theta/2)}.
\]
Evaluation at \(\theta=\pi,2\pi/3,2\pi/5,4\pi/5\) gives
\[
\begin{array}{c|ccccc|c}
 &1&2A&3A&5A&5B&\text{decomposition}\\ \hline
\operatorname{Sym}^{10}&11&-1&-1&1&1&\mathbf3+\mathbf3'+\mathbf5\\
\operatorname{Sym}^{16}&17&1&-1&-t&t-1&\mathbf3'+\mathbf4+2\mathbf5.
\end{array}
\]
The two conference eigenspaces are the two three-dimensional summands.  Fix
the \(5A\) label so that the \(+s\)-space has character value \(t\), as follows
from the oriented pentagon action, and call that summand \(\mathbf3\).  To
check that neither is lost under the decimic map, set
\[
 w_+=(sI+C)z_{a_0},\qquad w_-=(sI-C)z_{a_0}.
\]
The Fischer pairing is rotation invariant, and \(z_{-a}=-z_a\).  On these
six equal-norm axes its Gram matrix therefore has the form \(dI+hC\).
One diagonal binomial expansion and one positive off-diagonal expansion give
\[
 d=368640000(7+11t),\qquad
 h=162201600(3+5t).
\]
Since \((sI\pm C)e_0\) has squared coefficient norm \(10\) and lies in the
\(\pm s\)-eigenspace, respectively,
\[
 \langle w_+,w_+\rangle=5308416000(7+11t),
\]
\[
 \langle w_-,w_-\rangle=2064384000(7+11t).
\]
Both are nonzero, so the map is injective and its image is
\(\mathbf3\oplus\mathbf3'\).

The product of the six displayed quadratics is
\[
\begin{array}{c|rrrrrrr}
j&0&2&4&6&8&10&12\\ \hline
[u^{12-j}v^j]F_{\rm ax}
&-3-4t&22+44t&99+132t&-44-88t
&99+132t&22+44t&-3-4t.
\end{array} \tag{6.1}
\]
All other coefficients vanish.  The \(A_5\)-action permutes the six quadratic
lines; the product of the resulting signs is a linear character of \(A_5\),
hence is trivial.  Thus \(F_{\rm ax}\) is invariant,
\(\Delta\) and \(T_{10}\) are \(A_5\)-equivariant.  Equivalently, direct
substitution in the four-term transvectant gives \(\Delta w_+=0\); the
character table explains this cancellation because
\(\operatorname{Sym}^{16}\) contains no copy of the \(+s\) summand.  Schur's
lemma therefore gives
\[
 T_{10}=\gamma(sI-C)
\]
for one scalar \(\gamma\in E\).  It remains to derive that scalar.

The normalization is a one-vector calculation.  It is recorded explicitly
because the raw transvectant and Fischer conventions carry large factorial
scales.  Write \(\Delta w_-=\sum_{j=0}^{16}d_ju^{16-j}v^j\).
Substitution of (6.1) in the four-term transvectant formula gives
\[
\begin{array}{c|rrrrrrrrr}
j&0&1&2&3&4&5&6&7&8\\ \hline
d_j/844800
&-33-54t&-(58+98t)i&-150-240t&-(666+1098t)i
&-286-468t&(78+78t)i&4290+6864t&-(2002+3146t)i&0.
\end{array}
\]
The remaining entries are \(d_{16-j}=-d_j\).  Applying the Fischer weights
gives
\[
 \langle\Delta w_-,\Delta w_-\rangle
 =4368771359805045473280000000(123+199t).
\]
Together with the norm of \(w_-\), this yields the nonzero eigenvalue
\[
 \frac{\langle\Delta w_-,\Delta w_-\rangle}
 {\langle w_-,w_-\rangle}
 =211625906798592000(50+80t).
\]
But \(sI-C\) has eigenvalue \(2s\) on \(w_-\), and
\[
 50+80t=2s(11+18t).
\]
Therefore
\[
 \gamma=211625906798592000(11+18t),
\]
as claimed.  Notice also
\[
 11+18t=st^6,
\]
so its norm is \(-5\).

Under the nontrivial golden automorphism, \(t\mapsto1-t\) and \(s\mapsto-s\).
The conjugate return is a nonzero scalar multiple of \(sI+C\), so it kills the
old \(-s\)-space and is nonzero on the old \(+s\)-space.  Thus conjugation
exchanges the two kernels.  \(\square\)

**Tao-style check after Lemma 6.**  Equivariance and the missing target
summand determine the return up to one scalar.  The proof computes that scalar
from one Fischer norm on one eigenvector; it never proves a six-by-six matrix
identity by comparing thirty-six stored entries.  The large integer is forced
by the unnormalized third transvectant and factorial Fischer form, while its
golden factor \(st^6\) separates discriminant from unit normalization.

## 7. Rational paired-tower descent

**Lemma 7 (paired golden descent and integral comparison).**  Let \(N\) be
the natural-\(\mathbf2\) McKay tower over \(E\), and let \(\sigma N\) be its
golden-conjugate natural-\(\mathbf2'\) tower.  On their sum define
\[
 b(x,y)=(sx,-sy).
\]
The semilinear involution exchanging the two factors commutes with \(b\), so
\(b\) descends to a rational operator satisfying \(b^2=5\).  If
\(F_{\rm ax}=F_0+sF_1\), the descended transvectant is
\[
 \widehat\Delta=
 \begin{pmatrix}\Delta_0&5\Delta_1\\
 \Delta_1&\Delta_0\end{pmatrix},
 \qquad
 J=\begin{pmatrix}0&5I\\I&0\end{pmatrix},
\]
and \(J\widehat\Delta=\widehat\Delta J\) in every degree.  In degree ten,
the descended operator and \(C\) satisfy \(CP=PJ_3\) for
\[
P=\begin{pmatrix}
1&0&0&0&1&1\\
0&1&0&1&0&-1\\
0&0&1&1&-1&0\\
0&0&0&1&-1&1\\
0&0&0&-1&-1&1\\
0&0&0&-1&-1&-1
\end{pmatrix},
\qquad \det P=4.
\]
Thus the companion and signed-axis lattices agree over \(\mathbf Z[1/2]\),
but not over \(\mathbf Z\).

**Proof.**  If \(\tau(x,y)=(\sigma y,\sigma x)\), then
\[
 \tau b(x,y)=(-s\sigma y,s\sigma x)=b\tau(x,y).
\]
Hence \(b\) preserves the rational fixed space and \(b^2=5\).  In the basis
\(1,s\) of restriction of scalars, multiplication by \(s\) is \(J\), while
the coefficientwise action of \(\Delta_0+s\Delta_1\) is the displayed block
matrix.  Block multiplication proves the intertwining identity.  The trace
pairing \(\operatorname{diag}(1,5)\) makes \(J\) self-adjoint, so the Fischer
adjoint and every Gram return also commute with \(J\).

For degree ten, take the columns
\[
 P=(e_0,e_1,e_2,Ce_0,Ce_1,Ce_2).
\]
The equality \(CP=PJ_3\) is immediate from \(C^2=5I\); inserting the displayed
\(C\) gives the displayed \(P\).  Subtracting its first three pivot rows leaves
the lower-right block
\[
 \begin{pmatrix}1&-1&1\\-1&-1&1\\-1&-1&-1\end{pmatrix},
\]
whose determinant is \(4\).  Modulo \(2\), \(P\) has rank four, so its Smith
quotient is \((\mathbf Z/2)^2\).  Moreover
\[
 \operatorname{rank}_{\mathbf F_2}(C-I)=1,
 \qquad
 \operatorname{rank}_{\mathbf F_2}(J_3-I)=3,
\]
which forbids an integral conjugacy.  Modulo \(5\), \(P\) is invertible; the
comparison-lattice defect is at \(2\), whereas \(5\) is the ramification prime
of the golden algebra itself.  \(\square\)

The same-tower descent is impossible: the Kostant generator degrees begin
\[
 \{2,10,12,18,20,28\}\quad\hbox{for }\mathbf3,
\]
\[
 \{6,10,14,16,20,24\}\quad\hbox{for }\mathbf3'.
\]
Their degree-two dimensions differ.  Degree ten is the first balanced slice;
the rational all-degree object necessarily pairs the conjugate towers.

**Tao-style check after Lemma 7.**  The descent is restriction of scalars,
not a hidden automorphism of one affine-\(E_8\) diagram.  The degree lists give
an immediate obstruction to a same-tower graded operator.  The index-four
matrix \(P\) also separates two issues often conflated: \(2\) measures the
failure of the naive companion lattice to equal the signed-axis lattice, while
\(5\) is intrinsic golden ramification.

## Exported interface for C680

The manuscript may import the following theorem without computational
qualification.

> **Golden-return theorem.**  For the oriented golden axes and ordered
> six-axis lattice above, the signed Gram operator \(C\) satisfies \(C^2=5I\).
> Its switching-invariant triangle tensor defines the normalized orientation
> cubic \(Z_C\) on the augmentation five-space and reconstructs the switching
> class from the four-point and pair-balance identities.  With the transported
> lattice orientation,
> \[
> K=*\Lambda^3C,\qquad K^2=125I,
> \qquad K_{SS}=4C_{ij}C_{jk}C_{ki}.
> \]
> The parity of \(K\) reconstructs the Johnson support scheme and hence makes
> its diagonal intrinsic on the distinguished integral support lattice.
> Choosing one of the two dual atom reconstructions and an orientation then
> recovers \(C\) itself from \(\Lambda^3C=-*K\).  The
> degree-ten Klein return is
> \[
> 211625906798592000(11+18t)(\sqrt5I-C),
> \]
> and its golden conjugate exchanges the two kernels.  Across all degrees the
> golden operator descends rationally only after pairing the natural-
> \(\mathbf2\) and natural-\(\mathbf2'\) McKay towers; its degree-ten companion
> lattice embeds in the signed-axis lattice with index four.

For Paper III, set
\[
 Z_C(x)=\frac14\sum_{|S|=3}K_{SS}x_S.
\]
This equality fixes the sign relative to the displayed axis order and Hodge
orientation.  An odd switch or odd relabeling transports the orientation and
therefore transports both sides together.  A bare rational conjugate of \(K\)
does not carry this definition.

The integral conference, triangle, and middle-exterior identities are
polynomial identities over \(\mathbf Z\).  The clean representation-theoretic
and paired-tower interpretation is over \(\mathbf Z[1/30]\): prime \(2\)
collapses signs and is the lattice-comparison defect, prime \(3\) is excluded by
the order-three transvectant/icosahedral semisimplicity boundary, and prime \(5\)
ramifies the golden algebra.  No good-reduction claim for the full
Mukai--Umemura package is exported here.

## Formalization-ready interface for C712

Definitions, in dependency order:

1. `conferenceMatrix : Matrix \(Fin 6\) \(Fin 6\) ℤ`, the displayed matrix;
2. `triangleSign C S` for ordered three-subsets and
   `triangleCubic C` in six commuting variables;
3. diagonal switching and the induced transported orientation;
4. the augmentation quotient by the all-ones vector;
5. the ordered triple basis of \(\Lambda^3\mathbf Z^6\), complement sign, and
   Hodge matrix;
6. `middleExterior C = hodge * compound₃ C`;
7. the mod-two odd-entry graph and its four recovered relations;
8. the quadratic algebra \(\mathbf Q[s]/(s^2-5)\), projectors \(P_\pm\), and
   the restriction-of-scalars companion \(J\).

Theorem statements:

| C712 theorem | hypotheses | conclusion |
|---|---|---|
| `conference_sq` | explicit \(C\) over \(\mathbf Z\) | \(C^2=5I\) |
| `triangle_switch` | diagonal signs | triangle signs unchanged |
| `triangle_four_point` | distinct four indices | product of four faces is one |
| `triangle_pair_balance` | explicit \(C\) or \(C^2=5I\) | all pair sums vanish |
| `triangle_translate` | commuting coefficient ring | \(Z_C(x+u\mathbf1)=Z_C(x)\) |
| `twoGraph_reconstruct` | four-point identity | unique switching class |
| `balance_iff_conference` | reconstructed signed graph | pair balance iff \(C^2=5I\) |
| `middleExterior_sq` | \(C^2=5I\), symmetry, chosen orientation | \(K^2=125I\) |
| `middleExterior_diag` | explicit normalization | \(K_{SS}=4c_S\) |
| `middleExterior_parity` | distinguished triple lattice | odd iff intersection one |
| `support_reconstruct` | the parity relation | Johnson scheme up to complement |
| `middleExterior_recovers_conference` | recovered atoms and orientation over \(\mathbf Q\) | \(-*K=\Lambda^3C\) determines \(C\) |
| `companion_intertwines` | displayed \(P,J_3,C\) | \(CP=PJ_3\), \(\det P=4\) |

The large transvectant scalar should enter C712 as a proved interface constant
only if C712 formalizes binary forms and the Fischer adjoint.  Otherwise C712
should formalize the operator-shadow package from the explicit \(C\) and state
the degree-ten return theorem as paper-proved, outside its trust claim.
Likewise, `middleExterior_recovers_conference` is a cheap optional corollary:
C712 may prove the general \(\mu_3\)-kernel lemma, or retain only the explicit
identity \(-*K=\Lambda^3C\) and leave rational faithfulness paper-proved.

## Claim-to-lemma map

| C711 obligation | human proof | machine audit only |
|---|---|---|
| signed Gram construction, switching, \(C^2=5I\) | Lemma 1 | C682 descent replay |
| orientation cubic, reversal, augmentation descent | Lemma 2 | C691 replay |
| converse reconstruction and unique class | Lemma 3 | C691 replay |
| \(K^2=125I\), diagonal scalar \(4\), Hodge signs | Lemma 4 | C682 Weyl replay |
| distinguished support lattice from \(K\bmod2\) | Lemma 5 | C682 Weyl replay |
| degree-ten return and exact scalar | Lemma 6 | C682 primary and independent replay |
| golden conjugation and paired rational descent | Lemmas 6–7 | both C682 replays |
| C680/C712 rings, signs, and bad-prime boundary | exported interfaces | not computational |

## Exact audit and trust boundary

From `/home/tavis/src/othello`, run
\[
\begin{split}
&\texttt{python3 notes/2026-07-29-c691-cubic-golden-two-graph.py --check},\\
&\texttt{python3 notes/2026-07-29-c691-cubic-golden-two-graph-replay.py},\\
&\texttt{python3 notes/2026-07-30-c682-golden-e8-descent.py},\\
&\texttt{python3 notes/2026-07-30-c682-golden-e8-descent-replay.py},\\
&\texttt{python3 notes/2026-07-30-c682-golden-e8-weyl-descent.py},\\
&\texttt{python3 notes/2026-07-30-c682-golden-e8-weyl-descent-replay.py}.
\end{split}
\]
The exact SHA-256 hashes and byte counts are pinned in
`notes/2026-07-30-c682-golden-e8-descent.sha256` and
`notes/2026-07-30-c682-golden-e8-weyl-descent.sha256`.  The programs independently
check the displayed axes, return scalar, conference restriction, paired block
intertwiner, index-four comparison, middle-exterior diagonal, and parity graph.
They do not supply any logical step in Lemmas 1–7.

## Extra-juice and Tao closeout

The proof pass produces six cheap upgrades beyond certificate removal.
First, the tight-frame equation derives the conference square without a single
six-by-six multiplication.  Second, the middle-exterior diagonal reduces to
two dihedral minors and Hodge complementation; this isolates the orientation
sign that a formal proof must carry.  Third, equivariance plus one eigenvector
norm derives the degree-ten scalar, replacing a restricted-matrix comparison
by a one-dimensional calculation.  Fourth, parity reconstruction restores the
Hodge operator, so the full middle-exterior return recovers the conference
operator through the faithful rational exterior cube.  Fifth, the same
reconstruction collapses the family-preserving 20-dimensional normalizer to
the known conference normalizer: \(A_5\) for \(K\), \(S_5\) for its line.
Sixth, Hodge complementation closes the dual-family half: the full line
normalizer is \(S_5\times C_2\), and the exact stabilizer is the diagonal
\(S_5\) coupling the two orientation reversals.

The strongest invariant formulation is now clear.  The actual object is the
oriented integral pair \((\Lambda^3V,K)\), not the spectrum of \(K\).  Its
mod-two support scheme remembers the six-axis carrier, its diagonal remembers
the cubic orientation, and its golden eigenspaces remember the paired descent.

## Mystery ledger

- **Why \(C^2=5I\):** settled by the tight-frame operator
  \(A^{\mathsf T}A=2(t+2)I\).
- **Why the cubic begins in degree three:** settled by pair balance, which is
  exactly the off-diagonal conference equation and kills all lower moments.
- **Whether the cubic reconstructs the return:** settled up to switching by
  the four-point identity; pair balance recovers the golden square and the
  pentagon proves uniqueness.
- **The two Hodge signs:** settled.  Middle degree gives \(*^2=-1\), while
  \(C/\sqrt5\) reverses orientation; their minus signs cancel in \(K^2\).
- **Why the diagonal scalar is \(4\):** settled by two explicit Krylov minors,
  dihedral transitivity, and complementation.
- **Whether the diagonal is intrinsic:** settled precisely on the distinguished
  integral support lattice via \(K\bmod2\); a bare rational conjugacy class is
  insufficient.  With a dual atom choice and orientation, the full \(K\)
  recovers \(C\) itself through the faithful rational exterior cube.
- **Whether \(K\) acquires hidden symmetries in dimension twenty:** settled.
  Family-preserving stabilizer and line stabilizer are \(A_5\) and \(S_5\).
  Hodge complementation doubles the full line normalizer to
  \(S_5\times C_2\); the exact stabilizer is the diagonal \(S_5\) coupling the
  outer and complement characters.
- **Why the return scalar has its form:** settled by a single Fischer norm.
  The rational factor comes from the raw derivative normalization and the
  golden factor is \(st^6\).
- **Why two towers are necessary:** settled by semilinear descent and the
  unequal same-tower Kostant degrees.
- **Remaining mystery inside C711:** none.  A categorical identification of the
  local returns with a standard preprojective corner is outside C711 and remains
  C682's optional successor, not an evidence gap in this theorem package.

Vibe check: the proof surface is cleaner than the certificate-era statements.
Every normalization now comes from a short structural reduction, and the only
large arithmetic is confined to one reproducible Fischer norm.
