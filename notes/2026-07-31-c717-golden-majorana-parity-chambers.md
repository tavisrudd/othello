# C717 — Golden Majorana parity chambers

**Date:** 2026-07-31

**Lane:** `golden`

**Status:** complete; research only, no manuscript edit

## Outcome

Fix the C707 orientation of the six Joubert cubics and choose the six
conference representatives so that, in one common oriented Majorana frame,

\[
 A_T(x)=[D_x,C_T],\qquad \operatorname {Pf}A_T(x)=4Z_T(x).
\]

The physical cube has exactly **860 connected gapped chambers** after the
translation-invariant direction is removed.  There are 50 possible parity
sign vectors: 15 with two positive Pfaffians, 20 balanced, and 15 with four
positive Pfaffians.  Each unbalanced sign vector occurs in 24 chambers.  Each
balanced sign vector occurs in seven chambers: one large chamber containing
its balanced Boolean optimum and six smaller pole chambers.  Thus

\[
 30\cdot24+20\cdot7=860.
\]

The generic adjacency graph is connected, has diameter ten, and has 2,160
edges.  Every unbalanced chamber has degree three.  For each balanced sign
vector, the large chamber has degree 36 and the six small chambers have
degree 12.  A generic edge crosses one and only one Pfaffian wall and flips
that one ground-state parity.

These numbers compress to one mechanism: the graph is the coset-incidence
geometry of a regular \(S_6\)-orbit with balanced stabilizers
\(S_3\times S_3,S_3\times S_2,S_3\times S_2\).  The two order-twelve
coset orbits are exchanged by \(x\mapsto-x\).

This compression is spectrally rigid.  The 140 balanced-chamber incidence
vectors in the regular 720-dimensional orbit have rank 138.  Their only
linear relations are the two differences among the three orbitwise sums;
equivalently, incidence on the unbalanced chambers determines every
centered balanced signal.

The simultaneous-closing rule is sharp: away from the common unstable base
locus, exactly one, two, or four of the six Hamiltonians can close, but not
exactly three or five.  All six close on the fifteen-line unstable locus.
Generic points there give two zero Majoranas in every Hamiltonian; its six
vertices are the C709 cross-golden dimers and give four zero Majoranas in
every Hamiltonian.

There is no protected parity pump or outer-action monodromy in this marked
zero-dimensional family.  A gapped loop keeps every Pfaffian sign fixed, and
each parity component of the full six-Majorana class-D Hamiltonian space is
\(SO(6)/U(3)\cong\mathbf {CP}^3\), hence simply connected.  The parity pumps
in the established literature use spatial momentum, boundaries, or defects;
none of that extra structure is present here.

## 1. Control domain and orientation

The commutators are unchanged by \(x\mapsto x+c\mathbf1\).  Put

\[
 V=\mathbf R^6/\langle\mathbf1\rangle.
\]

Positive radial rescaling does not change any parity sign.  Every nonzero
class in \(V\) has a representative on the boundary of the real cube, and
the allowed translations over a fixed class form an interval.  Therefore
the chamber count in the cube is the chamber count on the oriented radial
sphere \(S(V)=S^4\).  The projective compactification \(\mathbf P(V)=
\mathbf {RP}^4\) identifies \(x\) with \(-x\); because the cubics are odd,
that identification simultaneously reverses all six Pfaffian signs.  It is
useful for algebraic strata but is not the signed-parity control space.  Its
complement consequently has 430 projective chambers, paired by the 860
oriented chambers upstairs.

The six conference matrices are defined only up to vertex switching.  An
orientation-reversing switching preserves each triangle cubic but reverses
its Pfaffian.  The certificate fixes one representative per sister with
\(\operatorname {Pf}[D_x,C_T]=4Z_T(x)\) in the common ordered frame.  Changing
the global Majorana orientation complements all six parity bits and changes
no chamber or adjacency count.

Pfaffian zero and a spectral closing coincide here because
\(\det A_T=\operatorname {Pf}(A_T)^2\).  Ground-state parity is the Pfaffian
sign only after the preceding orientation convention.  A zero Pfaffian is a
level crossing, not by itself a localized Majorana bound state or a
topological qubit.

## 2. Individual walls and their ranks

For each sister,

\[
 H_T=\{[x]\in\mathbf P(V):Z_T(x)=0\}
\]

is an irreducible cubic threefold.  Its singular locus is the common set

\[
 p_a=[\mathbf1-6e_a],\qquad 0\le a<6.
\]

Indeed C709 proves that these are exactly the singular points and that
\(A_T(p_a)\) has rank two.  Reducibility would force the linear and quadratic
factors to meet in a positive-dimensional singular set, so the finite
six-point singular locus also proves irreducibility.

The complete rank stratification of an individual wall is

\[
 \begin{array}{c|c|c}
 \text{control stratum}&\operatorname {rank}A_T&\text{Majorana zero modes}\\
 \hline
 Z_T\ne0&6&0\\
 Z_T=0,\ [x]\notin\{p_a\}&4&2\\
 [x]=p_a&2&4.
 \end{array}
\]

At \(p_a\), the Hamiltonian is the C709 cross-golden dimer
\(-3i\sqrt5\,\gamma_a\widetilde\gamma_a\).

## 3. Simultaneous walls

Write \(z=(Z_0,\ldots,Z_5)\).  The two Segre identities are

\[
 \sum_i z_i=0,\qquad \sum_i z_i^3=0.
\]

They give the complete multiplicity rule away from \(z=0\).

- With two prescribed zero coordinates, let the other four be
  \(a,b,c,d\).  Since \(a+b+c+d=0\),
  \[
    a^3+b^3+c^3+d^3=-3(a+b)(a+c)(b+c).
  \]
  Hence every pairwise wall intersection has three components, indexed by
  the three ways to pair the four remaining amplitudes as opposites.  A
  generic point has exactly two rank-four Hamiltonians and four gapped ones.

- Three nonzero coordinates cannot have both first and third power sums
  zero: if \(a+b+c=0\), then \(a^3+b^3+c^3=3abc\).  Therefore exactly three
  zero amplitudes never occur.

- Exactly four zero amplitudes are possible and force the other two to be
  \((a,-a)\).  The fifteen projective amplitude points lift to the fifteen
  \(2+2+2\) control curves.  Four Hamiltonians have rank four and two are
  gapped.

- Exactly five zero amplitudes are impossible by the linear relation.

All six amplitudes vanish precisely on the unstable locus of six labelled
points with at least four coincident values.  In \(\mathbf P(V)\) it is

\[
 B=\bigcup_{0\le a<b<6}L_{ab},\qquad
 L_{ab}=\mathbf P\langle e_a,e_b\rangle\subset\mathbf P(V).
\]

The fifteen lines have the incidence graph \(K_6\): \(L_{ab}\) joins
\(p_a\) to \(p_b\), and disjoint-edge lines do not meet.  Away from the six
vertices, all six matrices have rank four.  At every \(p_a\), all six have
rank two.  The constant control at the cone vertex gives rank zero.

The three components of a pairwise intersection meet over the smooth Segre
points with amplitude pattern \((0,0,a,a,-a,-a)\).  These crossings are
algebraic coincidences of two walls, not new rank drops of the four nonzero
Pfaffian Hamiltonians.

## 4. Allowed parity syndromes

If one amplitude had one sign and the other five the opposite sign, write
the singleton magnitude as the sum of the other five.  Strict convexity gives

\[
 \left(\sum_{j=1}^5u_j\right)^3>\sum_{j=1}^5u_j^3,
\]

contradicting the cubic identity.  Thus every nonzero syndrome has two,
three, or four plus signs.  Conversely exact witnesses exist for all such
syndromes, and outer \(S_6\) covariance is transitive at each weight.  The
The 50 allowed vectors are therefore

\[
 \binom62+\binom63+\binom64=50.
\]

This sign restriction is not Golden-specific.  More generally, let
\(y_1,\ldots,y_n\) be nonzero real numbers with

\[
 \sum_i y_i=\sum_i y_i^3=0.
\]

Then each sign must occur at least twice, and every sign pattern with
\(p,q\ge2\) does occur.  The obstruction to a singleton sign is the same
strict-convexity argument above.  For the converse, normalize the positive
and negative magnitudes separately to have sum one.  On the open
\((k-1)\)-simplex the function \(f_k(u)=\sum u_i^3\) has image
\([1/k^2,1)\).  The two images for \(k=p,q\) overlap whenever
\(p,q\ge2\), and choosing the same value realizes the prescribed sign
pattern.  Thus the 50-syndrome theorem is the \(n=6\) case of a universal
first/third-moment cancellation lemma; the later chamber multiplicities are
where the Golden outer action enters.

The stronger chamber count uses the matching identity from C715.  For a
perfect matching \(M\),

\[
 X_M=[ij][kl][mn]=\pm\frac{z_a+z_b}{2}.
\]

Inside a strict order cone \(x_{\sigma(0)}<\cdots<x_{\sigma(5)}\), every
bracket sign is fixed.  Hence all fifteen signs of \(z_a+z_b\) are fixed.
For the standard order they are

\[
\begin{array}{c|rrrrrrrrrrrrrrr}
ab&01&02&03&04&05&12&13&14&15&23&24&25&34&35&45\\ \hline
\operatorname {sgn}(z_a+z_b)&+&+&+&+&+&-&-&-&-&-&-&-&+&+&+
\end{array}
\]

If \(z_a,z_b\) have the same sign, their sum must have that sign.  The table
therefore leaves exactly four possibilities:

\[
 +---++,\qquad +--+-+,\qquad +--++-,\qquad +--+++.
\]

They are realized, respectively, by the exact standard-order controls

\[
\begin{array}{c|c}
(-6,-4,-3,-2,4,5)&(324,-320,-192,-4,180,12)\\
(-6,-5,-2,-1,0,4)&(184,-176,-124,104,-4,16)\\
(-6,-5,-4,-3,-2,-1)&(33,-31,-23,15,15,-9)\\
(-6,-5,-3,-2,-1,3)&(118,-110,-82,62,10,2).
\end{array}
\]

The right column is \(z\).  Permuting the controls and applying the outer
action proves the statement in every one of the 720 strict order cones.
Thus each order cone contains one unbalanced chamber joined across three
single-coordinate walls to three balanced chambers.

For completeness, connectedness inside each displayed order/sign region is
not inferred from sampling.  Normalize the positive and negative magnitudes
separately to have sum one.  The fixed pair-sum signs fix every comparison
between a positive and a negative magnitude.  On each resulting comparison
simplex, the equation equating the two sums of cubes is a single strictly
monotone graph: eliminating a compared pair \(u>v\) gives derivative
\(3(u^2-v^2)>0\).  Its nonempty domain is convex after the remaining ordered
partial sums are used as coordinates.  The four rational witnesses establish
nonemptiness.  Hence the four regions are connected open balls.

## 5. Collision gluing and the 860-chamber theorem

A source collision \(x_i=x_j\) forces three pair sums to vanish.  Equivalently,
the source duad \(ij\) is sent by the outer automorphism to a syntheme
\((ab)(cd)(ef)\), and

\[
 z_a=-z_b,\qquad z_c=-z_d,\qquad z_e=-z_f.
\]

Consequently a pair collision can lie in a gapped sign region only for a
balanced syndrome.  No two strict order cones carrying an unbalanced
syndrome glue without crossing a Pfaffian wall.  Exact outer-incidence
counting gives 24 order cones for each unbalanced sign vector, hence 720
unbalanced chambers.

For the representative balanced syndrome \(++ +---\), the six allowed
source collisions are

\[
 02,04,24\quad\text{and}\quad13,15,35,
\]

the two disjoint triangles on \(\{0,2,4\}\) and \(\{1,3,5\}\).  The 108
strict order cones carrying this syndrome form seven components under
adjacent allowed transpositions: one component of size 36 and six of size
12.  This is a finite Coxeter-graph calculation, replayed independently in
the evidence bundle.  The size-36 component is the neighborhood of the
two-triple collision; its \(3!\,3!=36\) order cones meet at the balanced
Boolean optimum.  The other six are exactly the six finite pole intervals
of the marked real \(\operatorname {PGL}_2\) fibre.  Outer covariance gives
the same \(36+6\cdot12=108\) decomposition for every balanced syndrome.

This proves the chamber total

\[
 15\cdot24+15\cdot24+20(1+6)=860.
\]

The local four-region star in every strict order cone also proves the global
adjacency counts.  An unbalanced chamber meets its three balanced leaves and
has degree three.  A balanced chamber receives one edge from every strict
order cone it contains, so the large and small balanced degrees are 36 and
12.  Therefore

\[
 720\cdot3=20\bigl(36+6\cdot12\bigr)=2160
\]

generic adjacency edges.

The exact graph replay also shows that this bipartite graph is connected and
has diameter ten.  Thus every chamber can be reached from every other by a
sequence of at most ten generic single-Pfaffian crossings; this is a
connectivity statement about controlled gap closings, not a gapped
homotopy.

## 6. Coset compression

The full census and all three degrees admit a shorter group-theoretic
description.  Let \(G=S_6\) act on source labels and through the signed outer
action on parity chambers.  The 720 unbalanced chambers form a free
transitive \(G\)-orbit, so choose one of them as the identity chamber.
Its three balanced neighbors lie in three \(G\)-orbits:

\[
 \begin{array}{c|c|c|c}
 \text{orbit}&\text{stabilizer type}&\text{orbit size}&\text{degree}\\ \hline
 B_0&S_3\times S_3&20&36\\
 B_+&S_3\times S_2&60&12\\
 B_-&S_3\times S_2&60&12.
 \end{array}
\]

The first Young subgroup preserves the two source triples of the balanced
Boolean optimum.  Each order-twelve Young subgroup preserves a
\(3+2+1\) source partition.  The two order-twelve coset spaces are distinct
\(S_6\)-orbits, and the antipodal control involution \(x\mapsto-x\) exchanges
them.

If these three stabilizers are denoted \(H,K_+,K_-\), the chamber graph is
exactly the coset-incidence graph

\[
 \Gamma=G\ \sqcup\ G/H\ \sqcup\ G/K_+\ \sqcup\ G/K_-,
\]

where \(g\in G\) is adjacent to the three left cosets
\(gH,gK_+,gK_-\).  Indeed a neighbor's stabilizer carries the identity
chamber through its entire neighborhood, and its order equals that
neighbor's degree, so there are no further neighbors.  This gives

\[
 |V(\Gamma)|=720+\frac{720}{36}+2\frac{720}{12}=860,
 \qquad |E(\Gamma)|=3\cdot720=2160,
\]

and the degree distribution \(3^{720},12^{120},36^{20}\) without a chamber
enumeration.  The three Young subgroups generate \(S_6\), so the coset graph
is connected.  Their exact subgroup-factor width is five: relative to the
frozen identity chamber, the 720 permutations occur at factor lengths

\[
 1,50,180,334,148,7
\]

for lengths zero through five.  Alternating group and coset vertices doubles
that width and explains diameter ten.  Thus the formerly unexplained
numbers \(860,2160,20,60+60,36,12,3\), and ten all come from one
\(S_6\)-coset mechanism.

The earlier per-syndrome multiplicities are now immediate as well.  The
regular orbit lies over 30 unbalanced syndromes, giving \(720/30=24\)
chambers each.  The orbit \(B_0\) lies once over every balanced syndrome,
while \(B_+\sqcup B_-\) lies six times over each, giving the sevenfold split
\(1+6\) without referring back to pole-by-pole enumeration.

The mechanism generalizes verbatim.  For any finite group \(G\) and
subgroups \(H_1,\ldots,H_r\), the graph with vertices
\(G\sqcup\bigsqcup_iG/H_i\) and edges \(g\sim gH_i\) has group-side degree
\(r\), coset-side degrees \(|H_i|\), and is connected exactly when the
\(H_i\) generate \(G\).  What is Golden-specific is the appearance of the
three Young subgroups above from the outer duad--syntheme collision rule.

## 7. Incidence operator and Specht spectrum

Let \(B\) be the \(720\times140\) bipartite incidence matrix from the
regular orbit \(G\) to

\[
 \mathcal B=G/H\sqcup G/K_+\sqcup G/K_-.
\]

The balanced permutation module has the Young-module description

\[
 \mathbf Q[\mathcal B]
 \cong M^{(3,3)}\oplus2M^{(3,2,1)}.
\]

Young's rule therefore gives the Specht multiplicities

\[
 3S^{(6)}\oplus5S^{(5,1)}\oplus5S^{(4,2)}
 \oplus2S^{(4,1,1)}\oplus3S^{(3,3)}
 \oplus2S^{(3,2,1)}.
\]

Exact integer computation factors the characteristic polynomial of the
Gram operator \(Q=B^{\mathsf T}B\) as

\[
\begin{aligned}
 \chi_Q(X)={}&X^2(X-60)(X-40)^5(X-16)^{10}(X-14)^{16}
 (X-12)^5\\
 &\cdot(X-10)^{16}(X-8)^{15}(X-4)^5
 (X^2-60X+432)^5\\
 &\cdot(X^2-20X+48)^5(X^2-20X+80)^9\\
 &\cdot(X^3-64X^2+960X-4160)^9.
\end{aligned}
\]

The exponents reflect the Specht dimensions: a \(G\)-equivariant operator
acts only on the small multiplicity space inside each isotypic component.
An exact central-character projection removes the only ambiguity left by
those dimensions and assigns the multiplicity-space polynomials as follows:

\[
\begin{array}{c|c}
 \lambda&\chi_{Q,\lambda}(X)\\ \hline
 (6)&X^2(X-60)\\
 (5,1)&(X-4)(X^2-60X+432)(X^2-20X+48)\\
 (4,2)&(X^2-20X+80)(X^3-64X^2+960X-4160)\\
 (4,1,1)&(X-16)(X-8)\\
 (3,3)&(X-40)(X-12)(X-8)\\
 (3,2,1)&(X-14)(X-10).
\end{array}
\]

Thus \(\chi_Q=\prod_\lambda\chi_{Q,\lambda}^{\dim S^\lambda}\).
The assignment is not recoverable from eigenvalue size: unexpectedly the
standard block \(S^{(5,1)}\) contains the eigenvalue four and both quadratic
Galois packets, whereas the three-dimensional multiplicity block for
\(S^{(3,3)}\) contains the three integral eigenvalues \(40,12,8\).

The quadratic field has a direct coset-intersection explanation.  Fix one
source label.  On each \(3+2+1\) orbit let \(e_{j,s}\) be the centered
membership function \(6{\bf1}_{\{0\in B_s\}}-s\) for its block of size
\(s=1,2\), extended by zero to the other orbits; let \(e_H\) be the analogous
function for one distinguished block of the \(3+3\) orbit.  In the basis

\[
 (e_{0,2},e_{0,1},e_{1,1},e_{1,2},e_H)
\]

the standard multiplicity operator is the exact integer matrix

\[
 Q_{(5,1)}=
 \begin{pmatrix}
 12&0&6&-4&8\\
 0&12&0&8&-4\\
 8&0&12&0&4\\
 -4&6&0&12&-8\\
 24&-12&12&-24&36
 \end{pmatrix}.
\]

The antipode exchanges \(e_{0,2}\leftrightarrow e_{1,2}\) and
\(e_{0,1}\leftrightarrow e_{1,1}\), while sending \(e_H\mapsto-e_H\).
Since it commutes with \(Q\), the standard multiplicity space splits
canonically into even and odd parts.  In the corresponding bases the two
blocks are

\[
 Q^+=\begin{pmatrix}8&6\\8&12\end{pmatrix},\qquad
 Q^-=\begin{pmatrix}16&-6&8\\-8&12&-4\\48&-24&36\end{pmatrix}.
\]

Now

\[
 \chi_{Q^+}(X)=X^2-20X+48,
 \qquad \operatorname {disc}\chi_{Q^+}=16\cdot13.
\]

The odd block has the rational eigenline
\(5(e_{0,2}-e_{1,2})+2(e_{0,1}-e_{1,1})-6e_H\), with eigenvalue four, and

\[
 \chi_{Q^-}(X)=(X-4)(X^2-60X+432).
\]

After quotienting by that dark line, the odd spectrum is exactly three
times the even spectrum:

\[
 30\pm6\sqrt {13}=3(10\pm2\sqrt {13}).
\]

Thus \(\sqrt {13}\) is not a second coefficient field of the Golden
Hamiltonians.  It is the splitting field of the antipode-even
double-coset intersection operator.  The factor three is also the
stabilizer-order ratio \(|H|/|K_\pm|=36/12\).  The field and its repeated
packet are therefore consequences of the marked subgroup triple together
with antipodal symmetry, rather than unexplained numerical coincidences.

The threefold spectral copy lifts to an operator identity.  In the even and
odd bases above, put

\[
 T=\begin{pmatrix}1&1\\0&-1\\4&4\end{pmatrix}.
\]

Then

\[
 Q^-T=3TQ^+.
\]

Solving this intertwining equation over \(\mathbf Q\) gives every solution
as

\[
 T(a,b)=
 \begin{pmatrix}
 a&b\\4a-4b&-3a+2b\\4a&4b
 \end{pmatrix}.
\]

Consequently an integral intertwiner has \(a,b\in\mathbf Z\).  If
\(d=(5,2,-6)^{\mathsf T}\) is the dark vector, then

\[
 \det[\,T(a,b)\mid d\,]
 =26(3a^2+2ab-4b^2).
\]

The primitive binary quadratic form on the right has discriminant 52 and
satisfies

\[
 3(3a^2+2ab-4b^2)
 =N_{\mathbf Q(\sqrt {13})/\mathbf Q}
   \bigl(3a+(1+\sqrt {13})b\bigr).
\]

Thus the rational even--odd correspondence cannot be made unimodular on
the natural centered-membership lattices: every nonzero integral
intertwiner, together with the dark line, has index at least 26, attained
at \(a=b=1\).  Modulo 13 the primitive columns obey

\[
 6T_1+2T_2+d=0.
\]

So 13 is also the exact modular obstruction to gluing the antipode-even
packet and the odd dark line into the full standard lattice.  This is a
coset-incidence bad prime, not a bad prime of the original Majorana family.

There is an even shorter arithmetic formulation.  Set

\[
 R=\frac{Q^+-10I}{2}
   =\begin{pmatrix}-1&3\\4&1\end{pmatrix}.
\]

Then \(R^2=13I\).  Let \(\mathcal O=\mathbf Z[\sqrt {13}]\), the quadratic
order of discriminant 52, and consider its ideal

\[
 I=(4,1+\sqrt {13}).
\]

In the displayed basis of \(I\), multiplication by \(\sqrt {13}\) is
exactly \(R\):

\[
 \sqrt {13}\cdot4=-4+4(1+\sqrt {13}),\qquad
 \sqrt {13}(1+\sqrt {13})=3\cdot4+(1+\sqrt {13}).
\]

Thus \(Q^+=10I+2[\sqrt {13}]_I\).  Likewise the parameter lattice for the
intertwiners is the ideal

\[
 J=(3,1+\sqrt {13}),
\]

because its normalized ideal norm is

\[
 \frac{N(3a+(1+\sqrt {13})b)}{N(J)}
 =3a^2+2ab-4b^2.
\]

This identifies the complete arithmetic mechanism.  The prime 13 is
ramified, and reduction of \(R^2=13I\) makes \(R\) a nonzero square-zero
operator modulo 13.  The factor two in discriminant 52 records that
\(\mathcal O\) has conductor two in the maximal order of
\(\mathbf Q(\sqrt {13})\).  Thus the two factors in the index
\(26=2\cdot13\) are already visible as the conductor and ramified-prime
features of the natural chamber-incidence order.
In particular \(Q\) has rank 138.  If
\({\bf1}_H,{\bf1}_{K_+},{\bf1}_{K_-}\) denote the three orbitwise constant
vectors, then

\[
 B{\bf1}_H=B{\bf1}_{K_+}=B{\bf1}_{K_-}={\bf1}_G.
\]

Their two differences already span a two-dimensional kernel, so the rank
calculation proves that these are all the relations.  Thus the centered
parts of the three coset signals embed directly into the regular orbit.
This is an incidence-tomography statement: aside from redistributing an
additive constant among the three orbits while preserving their total, a
balanced chamber weighting can be reconstructed from its footprint on the
720 unbalanced chambers.

This operator compression also generalizes.  For arbitrary finite
\(G\) and subgroups \(H_i\), the Gram matrix of the coset-incidence map is
the matrix of intersections of translated subgroups, and its spectral
problem reduces irrep by irrep to multiplicity spaces
\(\bigoplus_i V^{H_i}\).  The exceptional feature here is that the three
Golden Young subgroups make those spaces tiny enough to yield the displayed
factorization and leave no hidden incidence relation.

## 8. Boolean controls, optima, and dimers

The exact Boolean census has a direct GIT explanation.

- The 20 oriented \(3+3\) masks are gapped, have \(|Z_T|=8\) for every
  sister, and map in complementary pairs to the ten Segre nodes.  Each of
  the 20 sign vectors is balanced, and its mask lies in the unique large
  degree-36 chamber of that sign.
- The 30 oriented \(2+4\) masks give the fifteen interior points of the
  base lines \(L_{ab}\).  Every \(A_T\) has rank four.
- The 12 oriented \(1+5\) masks give the six vertices \(p_a\).  Every
  \(A_T\) has rank two and is a C709 cross-golden dimer.
- The two constant masks give the zero Hamiltonian at the affine cone
  vertex.

Thus the 44 null Boolean masks split as \(30+12+2\), with ranks four, two,
and zero respectively; they should not be conflated as one kind of gap
closing.

## 9. Monodromy and parity-pump obstruction

Along a gapped loop, each continuous nonzero function
\(\operatorname {Pf}A_T\) returns with the same sign.  The six parities are
therefore constant, not merely constrained in aggregate.  Pairwise,
fourfold, and sixfold simultaneous closings have codimension at least two
inside the union of walls and are destroyed or separated by a generic small
control perturbation.  The Segre relations make those coincidences exact;
they do not protect them topologically.

There is also a sharp ambient obstruction.  Spectral flattening retracts a
gapped real \(6\times6\) alternating matrix to an orthogonal complex
structure.  In either Pfaffian component the target is

\[
 SO(6)/U(3).
\]

Using \(\operatorname {Spin}(6)\cong SU(4)\), this homogeneous space is
\(SU(4)/S(U(3)U(1))\cong\mathbf {CP}^3\), so its fundamental group is zero.
The marked six-family lands in a product of six simply connected spaces.
Any loop effect that survives only inside the algebraically restricted
control family can be removed by an arbitrarily small general gapped
class-D perturbation; it is not a protected class-D pump.

Quotienting the labels by the outer \(S_6\) can create orbifold monodromy,
but that operation changes the physical question: it identifies distinct
marked Hamiltonians by hand.  Likewise, Berry phases of nondegenerate
ground-state lines may occur geometrically, but no quantized value follows
from the Pfaffian chamber data alone.

## 10. Literature boundary

No source in this C717 comparison was read cover-to-cover; four primary
sources were used at targeted full-text depth.  The purpose was background
and terminology, not a novelty or priority negative.

1. A. Kitaev, *Unpaired Majorana fermions in quantum wires* (2000/2001).
   **Depth:** targeted full text, quadratic Majorana Hamiltonian and
   Pfaffian parity invariant.  Cache key `arXiv:cond-mat/0010440`, SHA-256
   `a1db2291c4834d9f1d471cfccb36e5b48a9eb4807e11b222728d397c19986f40`.
2. A. Grabsch, Y. Cheipesh, and C. W. J. Beenakker, *Pfaffian formula for
   fermion parity fluctuations in a superconductor and application to
   Majorana fusion detection* (2019).  **Depth:** targeted full text, §2.2.
   Cache key `arXiv:1903.11498`, SHA-256
   `5a437fbe55049c7c65c8b528dbc9a75bd92da64320da0d543f35300029631a13`.
3. A. Kitaev, *Periodic table for topological insulators and
   superconductors* (2009).  **Depth:** targeted full text, the
   zero-dimensional class-D construction and the \(R_2=O/U\) classifying
   space.  Cache key `arXiv:0901.2686`, SHA-256
   `003263d085801bbddfe2aed3a19d385c6e7abf128278ddaa33938e3327560b87`.
4. J. C. Y. Teo and C. L. Kane, *Topological defects and gapless modes in
   insulators and superconductors* (2010).  **Depth:** targeted full text,
   classification tables and §V.B on class-D/BDI fermion-parity pumps.
   Their pump uses a spatial Bloch/defect base and boundary spectral flow,
   which is absent from the finite Golden family.  Cache key
   `arXiv:1006.0690`, SHA-256
   `084a3b18146315ecbcc2da1f93999b98312e230ad828fbf59d84b681735d0d23`.

The literature therefore supports the terminology used here: Pfaffian sign
is the zero-dimensional class-D parity invariant, while a protected parity
pump requires additional spatial, boundary, or defect structure.  This
report makes no claim that parity chambers or Pfaffian crossings in generic
finite Majorana systems are new.

## 11. Reproducibility

From `/home/tavis/src/othello` run

```sh
python3 notes/golden-tasks/c717-golden-majorana-parity-chambers.py --check
python3 notes/golden-tasks/c717-golden-majorana-parity-chambers-replay.py
sha256sum -c notes/golden-tasks/c717-golden-majorana-parity-chambers.sha256
```

The generator constructs the six frozen outer cubics and oriented conference
representatives, verifies the two Segre polynomial identities and all six
Pfaffian identities, derives the 15 collision synthemes, transports four
exact witnesses through all 720 strict orders, computes the balanced
collision graph, identifies the three stabilizers and their coset orbits,
checks subgroup generation and factor width, certifies the exact
140-dimensional incidence Gram spectrum, checks all 64 Boolean controls and
exact matrix ranks, and writes the canonical JSON certificate.  The
replay reads only the frozen coefficient data in that certificate and uses a
separate evaluator, union-find and group-action implementations, rational
rank routine, an independent annihilator-and-moment spectral check, all 64
Boolean controls, and 3,125 further exact integer identity points.

The finite certificate proves the convention tables, order-incidence graph,
component sizes, coset compression, adjacency degrees, Boolean ranks, and
displayed witnesses.  For the Gram factorization it verifies the degree-18
squarefree annihilator exactly and determines the thirteen irreducible
factor multiplicities from thirteen full-rank trace moments.  A separate
central-idempotent computation using the standard character
\(\chi^{(5,1)}(g)=|\operatorname {Fix}(g)|-1\) verifies its five power
moments and thereby labels the last two equal-dimensional Specht blocks.
The generator then constructs the five centered block-membership functions,
checks the displayed integer multiplicity and antipode matrices entry by
entry, verifies the even/odd decomposition and the integral threefold
intertwiner, records its index-26 gluing obstruction, and checks the
\(\mathbf Z[\sqrt {13}]\)-ideal realization of the even block.  The replay
reconstructs the subgroup point orbits independently and repeats those
checks.
The irreducibility, intersection multiplicity rule, connectedness lemma, and
topological obstruction are human arguments above; they are not inferred
from finite sampling.

## `ej` + `tt` closeout

The cheap extra consequence is that the real chamber graph is far richer
than its 50 parity syndromes: an unbalanced syndrome has 24 disconnected
real realizations, while a balanced syndrome remembers the seven pole
chambers already visible in C715.  The balanced Boolean optimum selects the
unique large component, so it is not merely an amplitude-space node; it is a
canonical chamber selector in real control space.

The other useful strengthening is the coset compression.  The exact
adjacency theorem is the incidence graph of one regular \(S_6\)-orbit and
the three coset spaces for \(S_3\times S_3,S_3\times S_2,S_3\times S_2\).
The degrees \(3/12/36\), one connected component, and diameter ten follow
from subgroup orders, generation, and factor width.  This gives an
immediate experimental discriminator: local parity sweeps near an optimum
can access 36 generic one-wall exits, whereas the six outer pole chambers
have only 12 and every unbalanced chamber only three.  This is algebraic
connectivity, not topological protection.

The second-order strengthening is operator-theoretic.  The balanced side is
the small Young permutation module
\(M^{(3,3)}\oplus2M^{(3,2,1)}\), and its incidence Gram operator has the
exact factorization above.  Rank 138 closes the last possible combinatorial
loophole: beyond the two forced equalities among orbitwise totals, the 140
balanced chamber indicators have no relation.  This is the sharpest useful
compression of the mechanism, because all further spectral data live on
six small Specht multiplicity spaces rather than on an 860-vertex graph.
The third-order pass labels those spaces completely.  In particular, it
rules out the tempting but false assignment of the largest integral
eigenvalue to the standard representation; central characters, not spectral
size, provide the canonical labels.

The deeper follow-up explains the shared \(\sqrt {13}\).  Antipodal parity
reduces the standard block to a two-dimensional even intersection operator
with discriminant \(16\cdot13\), plus a three-dimensional odd operator with
one rational dark line.  The residual odd packet is exactly three times the
even packet.  This separates the original Golden coefficient field
\(\mathbf Q(\sqrt5)\) from a new but fully explained spectral splitting
field \(\mathbf Q(\sqrt {13})\).

The final cheap upgrade lifts this spectral statement to the integral
intertwiner \(Q^-T=3TQ^+\).  The complete rational intertwiner family is a
binary quadratic lattice of discriminant 52; adjoining the dark line has
minimum index 26 and produces an exact mod-13 column relation.  Hence the
prime 13 governs integral parity-sector gluing as well as eigenvalue
splitting.

The second-order follow-up identifies the governing order itself:
\(R=(Q^+-10I)/2\) satisfies \(R^2=13I\) and is multiplication by
\(\sqrt {13}\) on the norm-four ideal \((4,1+\sqrt {13})\) of
\(\mathbf Z[\sqrt {13}]\).  The intertwiner norm form is the normalized norm
on \((3,1+\sqrt {13})\).  Ramification at 13 and conductor two now explain
the modular collapse and the two factors of 26 in a single arithmetic
model.

## Mystery ledger

- **Settled:** 860 connected real cube chambers, with 50 sign vectors and
  exact \(24\) versus \(7\) multiplicities.
- **Settled by the `ej`+`tt` pass:** the full generic adjacency graph has
  2,160 edges, one connected component, diameter ten, and degree distribution
  \(3^{720},12^{120},36^{20}\); each balanced optimum selects the unique
  degree-36 chamber for its sign.
- **Settled by the post-closeout `ej` pass:** the entire graph is the
  \(S_6\) coset-incidence geometry for stabilizers
  \(S_3\times S_3,S_3\times S_2,S_3\times S_2\).  The two small 60-chamber
  orbits are exchanged by the antipodal control involution, and diameter ten
  is twice the exact subgroup-factor width five.
- **Settled by the second-order `ej2` pass:** the balanced incidence module
  is \(M^{(3,3)}\oplus2M^{(3,2,1)}\); its exact Gram spectrum has rank 138,
  and the only two relations among all 140 indicators are the forced
  differences among the three orbitwise constants.  No hidden incidence
  degeneracy remains.
- **Settled by the third-order `ej3` pass:** every irreducible factor of the
  Gram spectrum is assigned to its exact Specht multiplicity block.  The
  only dimension-based ambiguity, between \(S^{(5,1)}\) and \(S^{(3,3)}\),
  is resolved by five exact standard-character moments.
- **Settled by the deeper arithmetic pass:** the two \(\sqrt {13}\) packets
  come from the antipode-even \(2\times2\) double-coset intersection block;
  after removing the odd eigenvalue-four dark line, the odd packet is its
  exact threefold spectral copy.  The shared discriminant is therefore
  structural, not accidental.
- **Settled by the final `ej` pass:** the threefold copy is realized by an
  explicit integral intertwiner.  Its full two-parameter lattice has norm
  form of discriminant 52, and its primitive gluing with the dark line has
  minimum index 26 and a mod-13 dependence.  This identifies the exact
  integral obstruction behind the spectral field.
- **Settled by the subsequent `ej2` pass:** the even operator is
  \(10I+2R\) with \(R^2=13I\), where \(R\) is multiplication by
  \(\sqrt {13}\) on the ideal \((4,1+\sqrt {13})\) of the discriminant-52
  order.  The intertwiner lattice is the norm-three ideal
  \((3,1+\sqrt {13})\).  The conductor-two and ramified-13 structure account
  for the index 26 and mod-13 degeneration.
- **Generalized:** the exclusion of singleton signs holds for every real
  system with vanishing first and third moments, and every sign pattern with
  at least two entries of each sign is realizable.  Only the finer coset
  multiplicities use the Golden \(S_6\) structure.
- **Settled:** simultaneous closing multiplicities are exactly
  \(1,2,4,6\), with no exactly-three or exactly-five stratum.
- **Settled:** the 44 null Boolean masks split by rank as
  \(30\) rank-four, \(12\) rank-two, and \(2\) rank-zero controls.
- **Settled negatively:** no protected class-D monodromy or parity pump is
  carried by this finite marked family.
- **Open only beyond C717's boundary:** adding spatial locality, a boundary,
  or a defect could create a genuine Teo--Kane parity-pump question, but it
  would be a new device-level task rather than unfinished chamber research.

No genuine C717 mystery remains within the declared zero-dimensional
control family.
