# C729 opening theorem — simplex/conference factorization

**Date:** 2026-07-31
**Lane:** `golden`
**Status:** opening factorization, order-ten cut-orbit, and derived-association
gates proved; higher-order moment/literature gate next

## Result

The \(6\to10\) construction has three separate ingredients.

1. The golden six-sister theorem produces a coherently oriented sign matrix
   \(R\) with
   \[
   RR^{\mathsf T}=12\left(I_6-\frac16J_6\right).
   \]
2. Sign integrality rigidifies this simplex: its columns are, up to sign and
   order, all ten projective balanced \(3+3\) cuts of a six-set.
3. The column Gram matrix therefore has the form
   \[
   R^{\mathsf T}R=6I_{10}+2S,
   \qquad S^2=9I_{10},
   \]
   and defines a canonical order-ten conference switching class.

Conversely, every \(\{\pm1\}\)-valued \(6\times10\) factor of such a Gram
matrix is equivalent to this universal balanced-cut factor under row signed
permutation and column signed permutation.  Thus reverse sign factorization
is rigid at the abstract switching-class level.  Recovering the original
golden operator still requires the cut-coordinate semantics carried by the
relative dimer fingerprint; C727 proves that this marked fingerprint
recovers the unoriented order-six switching line.

## Simplex-to-conference theorem

### Theorem

Let \(R\in\{\pm1\}^{6\times10}\) satisfy

\[
RR^{\mathsf T}=12P,
\qquad
P=I_6-\frac16J_6.
\]

Then:

1. every column of \(R\) is balanced;
2. modulo column negation, the columns are the ten distinct \(3+3\) cuts of
   the row six-set;
3. the normalized columns \(R_{\bullet j}/\sqrt6\) form a real
   \(\operatorname{ETF}(5,10)\) in the augmentation space;
4. if
   \[
   S=\frac{R^{\mathsf T}R-6I_{10}}2,
   \]
   then \(S\) is a symmetric zero-diagonal sign matrix and \(S^2=9I_{10}\);
5. \(R^{\mathsf T}/\sqrt{12}\) is an isometry from the row augmentation
   space onto the \(+3\)-eigenspace of \(S\), and the orthogonal complement
   is its \(-3\)-eigenspace.

Consequently the switching class of \(S\) depends only on the projective
row words and the unlabelled cut coordinates.  Reversing rows fixes \(S\);
reorienting or permuting cuts switches or permutes \(S\).

### Proof

Since \(P\mathbf1=0\),

\[
0=\mathbf1^{\mathsf T}RR^{\mathsf T}\mathbf1
  =\lVert R^{\mathsf T}\mathbf1\rVert^2.
\]

Thus every column has three entries of each sign and represents a projective
\(3+3\) cut.

Let \(\mathcal C\) be the set of ten such projective cuts, let \(n_C\) be
the multiplicity of \(C\) among the columns, and let \(M\) be the
\(15\times10\) cut--edge incidence matrix: \(M_{eC}=1\) when the edge \(e\)
crosses the cut \(C\).  For distinct rows \(i,j\), the Gram identity says

\[
-2=(RR^{\mathsf T})_{ij}=10-2\sum_{C\ni ij}n_C.
\]

Hence every edge crosses six columns, or

\[
Mn=6\mathbf1.
\]

The uniform vector \(n=\mathbf1\) is a solution.  A cut crosses nine edges.
Two distinct projective \(3+3\) cuts cross five common edges: their four
intersection cells have sizes \(2,1,1,2\), and the common crossing edges
number \(2\cdot2+1\cdot1=5\).  Therefore

\[
M^{\mathsf T}M=4I_{10}+5J_{10},
\]

which is nonsingular.  The solution of \(Mn=6\mathbf1\) is unique, so every
projective cut occurs exactly once.

Distinct balanced projective cut vectors have inner product of absolute
value two.  It follows that \(G=R^{\mathsf T}R\) has diagonal six and
off-diagonal entries \(\pm2\), so \(S=(G-6I)/2\) is a symmetric
zero-diagonal sign matrix.  Moreover \(PR=R\), and hence

\[
G^2
=R^{\mathsf T}(RR^{\mathsf T})R
=12R^{\mathsf T}PR
=12G.
\]

Thus

\[
S^2=\frac{G^2-12G+36I}{4}=9I.
\]

The frame operator of the normalized columns is
\(RR^{\mathsf T}/6=2P\), proving tightness on the five-dimensional
augmentation space; their common coherence is \(2/6=1/3\).  Finally,
\(R^{\mathsf T}/\sqrt{12}\) is isometric on that space, and
\(G=6I+2S\) identifies its image with the \(+3\)-eigenspace.  The rank is
five, so the orthogonal complement is the \(-3\)-eigenspace.  The covariance
claims follow directly from left row signs and right signed permutations.
\(\square\)

## Reverse sign-factorization corollary

Let \(S\) be a symmetric order-ten conference matrix, put
\(G=6I+2S\), and suppose

\[
G=R^{\mathsf T}R
\qquad\text{for some }R\in\{\pm1\}^{6\times10}.
\]

The nonzero eigenvalues of \(G\), and hence of \(RR^{\mathsf T}\), are five
copies of \(12\).  Since the diagonal of \(RR^{\mathsf T}\) is ten, its
one-dimensional kernel is spanned by a vector whose six coordinates have
equal absolute value.  Reversing rows makes that vector \(\mathbf1\), after
which

\[
RR^{\mathsf T}=12\left(I_6-\frac16J_6\right).
\]

The theorem now shows that the columns are all ten balanced projective cuts.
Consequently every sign factor is equivalent to the universal cut matrix by
row reversal and permutation and by column reversal and permutation.  In
particular, an order-ten switching class admits such a factor if and only if
it is the switching class produced by the universal ten-cut Gram
construction.

This is the exact inverse statement available without attaching external
meaning to the six rows or ten columns.  The stronger recovery of a specific
golden order-six switching line uses the matching/cut labels and belongs to
the C727 dimer reconstruction interface.

## Why this is the central \(6\to10\) mechanism

The conference identity \(S^2=9I\) is not an extra finite coincidence and
does not require a coordinate census.  It follows from the row-simplex
identity once integrality proves that the columns exhaust the ten balanced
cuts.  Conversely, a sign Gram factor of the order-ten operator recreates
that cut simplex uniquely up to the unavoidable gauge actions.  What remains
for a genuine tower is therefore not the first Gram step but a new canonical
rule producing the next integral simplex factor.

## The 36-cut orbit and its design

The next gate also has an intrinsic answer.  Let \(\Omega\) be the ten
projective \(3+3\) cuts of the six-set.  For a Sylow \(5\)-subgroup
\(H<S_6\), its action on \(\Omega\) has two orbits of length five.  Their
unordered pair is a balanced cut \(b_H\) of the ten nodes.

There are \(36\) Sylow \(5\)-subgroups.  The stabilizer of \(b_H\) is

\[
N_{S_6}(H)=F_{20}=C_5\rtimes C_4.
\]

Indeed, for the representative
\(H=\langle(0\,1\,4\,5\,2)\rangle\), fixing axis \(3\), one half is

\[
\{012,013,014,023,025\}.
\]

The numbers of these five cuts separating an axis pair are three on the
five edges incident with axis \(3\), and two or four on the two complementary
five-cycles on the remaining axes.  The unordered node cut therefore
recovers the fixed axis and the complementary cycle pair.  Its stabilizer is
the Frobenius normalizer \(F_{20}\), and its unique normal \(C_5\) recovers
\(H\).  Thus \(H\mapsto b_H\) is an \(S_6\)-equivariant bijection from the
Sylow \(5\)-subgroups to one orbit of \(36\) balanced node cuts.

For the displayed representative, the cross block of the universal
conference operator is

\[
\begin{pmatrix}
 1& 1&-1&-1&-1\\
 1&-1& 1& 1&-1\\
 1& 1& 1&-1& 1\\
-1& 1& 1& 1&-1\\
 1& 1&-1& 1& 1
\end{pmatrix},
\qquad \det=-48.
\]

Conference switching and the \(S_6\)-action preserve the absolute cross
determinant, so all \(36\) cuts in this orbit are extremal.  The frozen C720
certificate proves that exactly \(36\) of the \(126\) balanced cuts have
absolute determinant \(48\), the other \(90\) being singular.  Hence:

> The extremal balanced cuts of the order-ten Naimark--Gram shadow are
> exactly the Sylow-\(5\) orbit \(S_6/F_{20}\).

This is also the homogeneous space carried by the \(36\) involutory
polarities in C708.  The identification is canonical: the stabilizer of an
extremal cut and the stabilizer of a polarity are both Frobenius groups with
a unique normal Sylow \(5\)-subgroup, so both objects map equivariantly to
that subgroup.  The numerical coincidence \(36=36\) is therefore an equality
of \(S_6\)-sets.

Taking both halves of the \(36\) complementary block pairs gives a
\(2\text{-}(10,5,16)\) design.  There are \(72\) blocks; every point lies in
\(36\), and two-transitivity on \(\Omega\) gives

\[
\lambda=\frac{36(5-1)}{10-1}=16.
\]

Choose either sign vector for each of the \(36\) projective blocks.  These
lines form a tight frame in the nine-dimensional augmentation module.
Indeed, the degree-ten action is two-transitive, so its augmentation module
is irreducible; the orbit sum of the rank-one projectors is scalar, and its
trace gives

\[
\sum_{H}x_Hx_H^{\mathsf T}
=40\left(I_{10}-\frac1{10}J_{10}\right).
\]

Two distinct block pairs meet, after choosing halves, in one or two points
up to complementation.  Their normalized inner products therefore have
absolute values \(3/5\) and \(1/5\).  Tightness shows that each line has five
neighbors of angle \(3/5\) and thirty of angle \(1/5\).  Thus the extremal
cuts form a biangular tight frame of \(36\) lines in dimension nine, not an
equiangular frame.  This gives the precise first obstruction to iterating the
conference construction: no affine rescaling of this two-angle Gram matrix
is a conference sign matrix.

## `ej`: the Sylvester eigenspace and weighted conference replacement

Join two of the \(36\) projective extremal cuts when their normalized line
inner product has absolute value \(3/5\), equivalently when suitable halves
meet in one point.  Direct intersection counting in the
\(S_6/F_{20}\) model gives

\[
\begin{array}{c|c|c}
d&|\Gamma_d(v)|&(c_d,a_d,b_d)\\ \hline
0&1 &(0,0,5)\\
1&5 &(1,0,4)\\
2&20&(1,2,2)\\
3&10&(4,1,0).
\end{array}
\]

Thus the large-angle graph is the Sylvester distance-regular graph, with
intersection array

\[
\{5,4,2;1,1,4\}
\]

and spectrum

\[
5^{(1)},\qquad 2^{(16)},\qquad (-1)^{(10)},\qquad (-3)^{(9)}.
\]

The multiplicities follow from the four intersection-matrix eigenvalues,
the vertex count, \(\operatorname{tr}A=0\), and
\(\operatorname{tr}A^2=36\cdot5\).

The dimension-nine coincidence is structural.  The primitive idempotent for
the \(-3\)-eigenspace is

\[
E_{-3}
=-\frac1{80}(A-5I)(A-2I)(A+I).
\]

Consequently \(40E_{-3}\) has diagonal entries \(10\), entry \(-6\) at
distance one, \(+2\) at distance two, and \(-2\) at distance three.  Orient
the extremal-cut sign lines relative to one base cut: choose intersection
sizes \(1,3,2\) in distance layers \(1,2,3\), respectively.  The cut
intersection table above shows that this is coherent and gives

\[
X^{\mathsf T}X=40E_{-3},
\qquad
XX^{\mathsf T}=40\left(I_{10}-\frac1{10}J_{10}\right),
\]

where \(X\in\{\pm1\}^{10\times36}\) is the oriented extremal-cut matrix.
Thus the 36-line configuration is exactly the integral spherical embedding
of the Sylvester graph in its \(-3\)-eigenspace, not merely a frame with the
same parameters.

There is a precise replacement for the failed next conference operator.  Put

\[
K=\frac{X^{\mathsf T}X-10I_{36}}2.
\]

Then \(K\) is integral, has zero diagonal and off-diagonal entries
\(\pm1,\pm3\), and the tight-frame identity gives

\[
\boxed{K^2=10K+75I_{36}}.
\]

Its eigenvalues are \(15\) with multiplicity nine and \(-5\) with
multiplicity twenty-seven.  The ordinary conference law fails exactly
because the two off-diagonal magnitudes survive, but the quadratic spectral
law does not.  This weighted operator is the cheapest viable notion of a
second-stage shadow; any proposed tower should propagate multi-angle
integral Gram operators rather than insist on sign conference matrices.

The invariant normalization is even simpler.  Center the two eigenvalues:

\[
H=K-5I_{36}.
\]

Then

\[
\boxed{H^2=100I_{36}},
\qquad
\frac{H}{10}=2E_{-3}-I_{36}.
\]

Thus \(H/10\) is the canonical Naimark reflection across the Sylvester
\(-3\)-eigenspace; \(K\) is its integral zero-diagonal coordinate form.  In
general, if \(N\) equal-norm tight-frame lines span dimension \(d\), the
reflection \(2P-I_N\) has constant diagonal \(2d/N-1\).  The first Golden
lift has \((d,N)=(5,10)\), so this diagonal vanishes and the reflection is a
conference operator after scaling.  The extremal-cut lift has
\((d,N)=(9,36)\), so its diagonal is \(-1/2\).  The failure of an ordinary
conference matrix is therefore forced by the change in redundancy from two
to four, while the reflection law survives unchanged.

This suggests the correct provisional hierarchy:

\[
\text{integral tight frame}
\longmapsto
\text{constant-diagonal Naimark reflection}.
\]

Conference matrices are its redundancy-two case.  Calling this a tower
still requires a canonical rule producing the next integral frame; the two
examples prove only the common reflection mechanism.

## `ej`: closure of the C708 outer-action bridge

The classical Sylvester model has a sharper consequence for the Golden
architecture.  Its \(36\) vertices are the outer involutions in
\(\operatorname{Aut}(S_6)\cong\operatorname{P\Gamma L}(2,9)\), with two
vertices adjacent exactly when the involutions commute.  The visible
\(S_6\) is the inner subgroup of index two.

C708's \(36\) involutory polarities are the same outer-involution class.
The identification through the unique normal \(C_5\) in each
\(F_{20}\)-stabilizer is \(S_6\)-equivariant.  Moreover the point stabilizer
has subdegrees

\[
1,5,20,10,
\]

so there is a unique invariant relation of valency five.  It follows that

\[
\boxed{\text{large cut angle }3/5
\quad\Longleftrightarrow\quad
\text{the corresponding C708 outer involutions commute}.}
\]

Thus the order-ten extremal cuts do not merely share a 36-element set with
the polarity package: their two-angle geometry recovers its Sylvester
commuting relation.  The full graph automorphism group supplies the unique
outer coset of the visible \(S_6\), but it selects no preferred outer
involution.  This matches C708's exact boundary: all 36 involutory
normalizations exist, while the unnormalized operator chooses none.

The reflection \(2E_{-3}-I\) is polynomial in the adjacency matrix and is
therefore invariant under the full outer action.  The integral cut factor
\(X\) is also preserved at the sharp projective level.  In C708's frozen
ten-node convention the unnormalized outer exchange is

\[
f=(7,6,5,8,4,0,2,3,1,9).
\]

It permutes the \(36\) extremal block pairs.  If \(P_f\) is its permutation
matrix on the ten node coordinates and \(\Pi_f\) its induced permutation on
the \(36\) coherently oriented frame lines, then

\[
\boxed{P_fX=-X\Pi_f}.
\]

The sign is common to all \(36\) columns.  Thus the exceptional exchange
preserves the integral \(\{\pm1\}\)-factor up to its unavoidable projective
orientation; it does not require independent column signs or a general real
change of frame.  Since the visible \(S_6\) together with \(f\) generates
the full outer action, the integral factor carries the complete
\(\operatorname{Aut}(S_6)\)-symmetry.  The order-eight value of \(f\) still
selects no involutory normalization, exactly as in C708.

### Literature checkpoint

The graph name, classical parameters, and outer-involution model were checked against
M. R. Alfuraidan and J. I. Hall, *Imprimitive distance-transitive graphs
with primitive core of diameter at least 3*, Michigan Math. J. 58 (2009),
31--77, doi:10.1307/mmj/1242071683, Section 5.8.2.  That section records the
Sylvester graph as a 36-vertex distance-transitive
\(\operatorname{P\Gamma L}(2,9)\)-graph on outer involutions, with commuting
adjacency and intersection array \(\{5,4,2;1,1,4\}\).  It does not supply
the extremal-cut realization,
the integral \(-3\)-eigenspace factor, or the weighted quadratic identity
above.  This is a terminology checkpoint, not the focused novelty audit
required before any priority claim.

## Next gate

Derive representation-theoretic or Cauchy--Binet moment constraints for
higher conference orders and run the focused ETF/Naimark, Sylvester-graph,
maximal-minor, and weighted-reflection literature audit.  The next
computational order should be attempted only after these identities specify
which distributional data can carry theorem-level content.

## `ej` + `tt` closeout and mystery ledger

- **Settled by `tt`:** the forward theorem separates into simplex linear
  algebra, golden integrality, and quotient descent; none of these layers is
  allowed to stand in for another.
- **Settled by `ej`:** the row-simplex equation plus sign integrality forces the
  complete ten-cut system; distinctness need not be imported from a finite
  certificate.
- **Settled by `ej`:** reverse \(\{\pm1\}\)-factorization is unique up to the natural
  row and column monomial actions.
- **Open:** identify the universal cut switching class as Petersen/Paley by
  an intrinsic incidence argument independent of the existing explicit
  switch certificate.
- **Settled by `ej` + `tt`:** the \(36\) extremal cuts form the single Sylow-\(5\) orbit
  \(S_6/F_{20}\), canonically the same \(S_6\)-set as the C708 involutory
  polarities; their oriented halves form a \(2\text{-}(10,5,16)\) design.
- **Settled by `tt`:** the extremal cut lines form a \(36\)-vector biangular tight
  frame in dimension nine with angle multiplicities \(5\) and \(30\), so
  the direct Gram-to-conference iteration stops at the next step.
- **Settled by `ej`:** the large-angle relation is the Sylvester graph, and
  its \(-3\)-eigenspace is exactly the coherently oriented integral cut
  frame.  The derived operator has weights \(1,3\) and satisfies
  \(K^2=10K+75I\); it is a weighted quadratic replacement, not another
  conference matrix.
- **Settled by `ej`:** recentering gives the canonical reflection
  \((K-5I)^2=100I\).  The diagonal formula \(2d/N-1\) explains exactly why
  redundancy two gives the order-ten conference matrix and redundancy four
  gives the weighted order-36 shadow.
- **Settled by `ej`:** the large-angle relation is the commuting graph on
  C708's 36 outer involutions.  The full Sylvester automorphism group closes
  the exceptional outer-action bridge at the projective reflection level.
- **Settled by `ej`:** C708's explicit order-eight exchange preserves the
  integral factor by row and column permutation with one common minus sign.
  Hence the full outer action lifts projectively to \(X\); no independent
  column-orientation torsor remains.
- **Open:** determine whether the weighted quadratic operator belongs to a
  known multi-angle or roux-type tower; no priority language is licensed
  before the focused literature gate.
