# C705 human proofs — the Segre--Igusa operator sisters

**Lane:** clebsch

**Date:** 2026-07-31

**Companions covered:** the C705 adjugate, \(E_6\) first-jet, Coble,
affine-\(E_8\), Lie-\(E_8\), marking-torsor, and Pauli-doily reports.

## Proof architecture

Almost every C705 conclusion comes from one mechanism.  The six Joubert
cubics form a map between two five-dimensional augmentation spaces.  Its
differential has one source null direction coming from residual
\(\mathrm{PGL}_2\) motion and one target null direction coming from the
Segre equation.  We use the elementary rank-\(n-1\) fact that
\[
 u^{\mathsf T}A=0,\quad Av=0,\quad \operatorname{rank}A=n-1
 \quad\Longrightarrow\quad
 \operatorname{adj}A=c\,vu^{\mathsf T}.
\]
Thus two intrinsic syzygies and one nonzero maximal minor force the
adjugate; one coefficient fixes \(c\).  The exceptional parents explain
the source of this matrix, while the boundary, arithmetic, Coble, and
doily calculations describe its restrictions.

## 1. Why raw block adjugates cannot work

For each total \(T\), the cross-golden block \(B_T(x)\) is \(3\times3\)
and linear in \(x\).  Its \(2\times2\) minors, equivalently the entries of
\(\operatorname{adj}B_T\), span the irreducible \(S_6\)-module \([4,2]\)
of dimension nine.  This can be seen without guessing a target map:
differentiate
\[
 Z_T=\kappa_T\det B_T .
\]
Every coefficient of \(dZ_T\) is a linear combination of those minors,
and one rank-nine coefficient table shows equality of the two spans.

But
\[
 \operatorname{Sym}^2[5,1]=[6]\oplus[5,1]\oplus[4,2],
\]
whereas the two outer five-spaces are \([2,2,2]\) and its sign twist
\([3,3]\).  Schur's lemma gives zero Hom-space from \([4,2]\) to either.
Taking a trace-free part or exterior square does not change this carrier.
Thus the negative raw-minor gate is representation-theoretic, not a
failed choice of coefficients.

## 2. The two kernel lines

Let \(G_x\) have columns \(dZ_T|_x\).  The relation
\(\sum_TZ_T=0\) lets it descend to a \(5\times5\) matrix \(A(x)\) in
augmentation bases.

First consider
\[
 q(x)=\operatorname{center}(x_0^2,\dots,x_5^2).
\]
Writing \(\omega_x=[D_x,C]\) gives
\[
 [D_{x^2},C]=D_x\omega_x+\omega_xD_x.
\]
The right side is the derivative at zero of
\[
 (I+tD_x)\omega_x(I+tD_x).
\]
Pfaffians transform under congruence by the determinant.  On the centered
slice \(\operatorname{tr}D_x=0\), so their first derivatives vanish.
Since \(\operatorname{Pf}\omega_x=4Z_T(x)\), this proves
\[
 q(x)^{\mathsf T}A(x)=0.
\]
Geometrically, \(q/6\) is the special-conformal vector field completing
translation and scaling to the residual \(\mathfrak{sl}_2\)-action on six
ordered points.

Next put
\[
 W_T=6Z_T^2-\sum_UZ_U^2.
\]
Differentiating the Segre equation gives
\[
 \sum_TW_T\,dZ_T
 =6\sum_TZ_T^2dZ_T
 =2\,d\!\left(\sum_TZ_T^3\right)=0.
\]
Thus \(A(x)W(x)=0\).  A single nonzero fourth minor proves that the
generic rank is at least four, while either relation gives the opposite
bound.  Hence the generic rank is exactly four, with right kernel \(W\)
and left kernel \(q^{\mathsf T}\).

## 3. The adjugate and the minimal compound

For a \(5\times5\) rank-four matrix, the adjugate has rank one; every
column lies in the right kernel and every row in the left kernel.
Therefore
\[
 \operatorname{adj}A=c\,Wq^{\mathsf T}
\]
for a constant \(c\): both sides are equivariant and have the same
bidegree.  Comparing one cofactor with the corresponding product at one
integral witness gives \(c=6\).  Since both sides are polynomial, dense
equality proves
\[
 \boxed{\operatorname{adj}A=6Wq^{\mathsf T}}.
\]

This matrix is also the normalized linear response of the six C709
parity walls.  For the six conference representatives \(C_T\), put
\(\Phi_T(x)=\operatorname{Pf}[D_x,C_T]\).  The Pfaffian identity
\(\Phi_T=4Z_T\) implies, after passing to the source and target
augmentation quotients,
\[
 A=\frac14\,d\Phi.
\]
Consequently the adjugate formula says that the top nonzero response
compound factors into the special-conformal source direction \(q\) and
the Segre--Igusa conormal direction \(W\).  This explains both kernel
lines without introducing a second operator.

Degree also explains why this repair is minimal.  The first matrix is
quadratic, the second compound has degree four, the polar vector has
degree six, and the third compound is the first one capable of containing
it.  The \(100\) third-compound entries span dimension \(70\).  Character
decomposition gives
\[
 \dim\operatorname{Hom}_{S_6}
 \bigl(\bigwedge^3A_X\otimes\bigwedge^3O_X,O_X\bigr)=1,
\]
so its outer five-space is necessarily the polar carrier.  The fourth
compound is the adjugate and exposes both kernel factors.

## 4. Boundary and inverse polarity

The Joubert span equals the span of the fifteen matching brackets
\[
 (x_b-x_a)(x_d-x_c)(x_f-x_e).
\]
All brackets vanish exactly when some four marked points coincide.
For each choice of four labels this is a line; symmetry gives fifteen.
The bracket ideal is generically reduced on each line, and its total
degree is fifteen, so there are no embedded or residual components.

For a triple \(Q=\{0,1,2\}\), set \(x_0=x_1=x_2=a\).  Direct substitution
gives
\[
 (Z_T)_T=(a-x_3)(a-x_4)(a-x_5)
 (-1,1,1,-1,-1,1).
\]
The centered squares therefore vanish.  Outer symmetry supplies all
twenty triple-collision planes.  Conversely, elimination on one affine
chart reduces the polar base equations to the triple-collision ideals;
their degrees sum to \(20\), the degree of the saturated base scheme.
Thus the union is reduced and complete.  Complementary triples give the
same projective sign vector, so the twenty planes pair over the ten Segre
nodes.  Rank follows from the two kernel relations: it is four
generically, three on a general collision plane, and one at the \(3+3\)
intersection.

On a Segre plane, coordinates occur in opposite pairs.  Squaring therefore
makes each pair equal, which is exactly one of the fifteen singular lines
of the Igusa quartic.  This proves the plane-to-line contraction directly.

For the inverse map, set
\[
 w_i=z_i^2-\frac16\sum_jz_j^2,\qquad
 y_i=\operatorname{center}_i\left(w_i\sum_jw_j^2-4w_i^3\right).
\]
On the Segre cubic, Newton's identities with \(e_1=e_3=0\) reduce every
power \(z_i^6\) using
\[
 z_i^6+e_2z_i^4+e_4z_i^2-e_5z_i+e_6=0.
\]
After centering, the even terms cancel and leave
\[
 y_i=-4e_5(z)z_i.
\]
Thus inverse polarity recovers \(z\) off \(e_5=0\).  Pairing the six
coordinates into three opposite pairs follows from the same identities.

Newton's identities turn \(e_1=e_3=e_5=0\) into vanishing of the first
three odd power sums, so
\[
 \prod_i(t-z_i)=t^6+e_2t^4+e_4t^2+e_6
\]
is even.  Its roots therefore pair as opposites, giving one of the fifteen
Segre planes.  The degrees are both fifteen, proving the reduced scheme
statement.

## 5. Arithmetic mechanism

The adjugate identity is integral, so reduction is legitimate.  Its scalar
already predicts a new boundary at \(2,3\).  Exact row reduction at one
generic integral point gives
\[
\begin{array}{c|cccc}
p&2&3&5&7\\ \hline
\operatorname{rank}G&1&3&4&4\\
\operatorname{rank}A&0&3&4&4.
\end{array}
\]
The kernel identities give the corresponding upper bounds, so these
witnesses prove generic equality.  At \(5\) the golden projectors cease to
split, but the descended integral matrix remains rank four.  Hence the
three bad primes have different causes: sign collapse at \(2\), the
scalar/compound boundary at \(3\), and golden ramification at \(5\).

## 6. The \(E_6\) first-normal jet

On Yoshida's conic boundary, write the ten ambient coordinates as five
surviving coordinates \(s\) and five coordinates \(Qf\).  Substitution of
the displayed chart into the unique cubic relation gives the Segre cubic
\(S(s)=0\).  Differentiate that explicit cubic.  Term-by-term comparison
with the five coefficients \(f\) yields
\[
 M\nabla S(s)=-2f,\qquad \det M=32.
\]
Thus no representation-theoretic proportionality is being assumed: one
constant invertible target change identifies the first normal jet with
the polar vector.

Globally, Schock's divisor classes give
\[
 L_{\rm Seg}|_D-N_{D/Y}=L_{\rm Igu}|_D+B_3.
\]
At a generic \(3+3\) collision, substituting
\(z_1=a+tu,z_2=a+tv,z_3=a+tw\) shows that every component of \(f\) has
valuation exactly one.  The ten \(B_3\) components form one \(S_6\)-orbit,
so their canonical section is a common factor.  The class formula says
there can be no further fixed divisor.  Division leaves
\(L_{\rm Igu}\), and equality on the dense chart extends globally.

## 7. The affine-\(E_8\) operator parent

C682's degree-ten paired-McKay return reconstructs \(C\), hence the cubic
tensor
\[
 Z\in\operatorname{Sym}^3(A_X^\vee)\otimes A_{\mathcal T}.
\]
There is no extra construction to invent: pair it with the dual outer
carrier,
\[
 \mathscr P(x,\eta)=\langle\eta,Z(x)\rangle.
\]
In augmentation coordinates its mixed Hessian is exactly \(A=dZ\).
Sections 2--3 recover \(q\) and \(W\) as its two null projections and the
adjugate as their outer product.  This is the precise common-parent
mechanism.  The support lattice simultaneously explains the ten
complementary triple pairs, fifteen matchings, and six axes.  C691's
converse reconstructs the conference switching class from \(Z\), so the
parent potential recovers the degree-ten conference algebra, though not
the whole all-degree operator.

## 8. Coble: parent, not third sister

Let \(F\) be the Coble cubic, \(H\) its dual sextic, and
\(y=\nabla F(x)\).  Projective duality gives
\[
 \nabla H(\nabla F(x))=\lambda(x)x
\]
on \(F=0\).  Differentiating along an affine tangent vector \(v\) gives
\[
 \operatorname{Hess}(H)_y\operatorname{Hess}(F)_xv
 =\lambda v+d\lambda(v)x.
\]
On the projective tangent quotient this is scalar multiplication by
\(\lambda\), not a corank-one operator.  One rational cubic point has
nonzero source Hessian determinant, and one exact finite-field conormal
has both Hessians nonsingular.  Nonvanishing at a witness proves the
generic ambient rank is nine.  Therefore the C705 rank-four mechanism
arises only after restriction and six-point quotienting.

For the \(\tau^+\) inclusion \(\gamma_+\), the chain rule gives exactly
\[
 \gamma_+^{\mathsf T}\operatorname{Hess}(F)(\gamma_+y)\gamma_+
 =\operatorname{Hess}(F\circ\gamma_+)(y).
\]
Nguyen identifies \(F\circ\gamma_+\) with Segre and the restricted polar
with Igusa, including the double fixed hyperplane on the sextic side.
This is the elder-parent restriction.

For \(\tau^-\), the four displayed quadrics \(Q_i\) define a map of
\(\mathbf P^3\).  Its Jacobian determinant is the Weddle quartic.  At a
smooth ramification point the Jacobian has rank three, hence its adjugate
has rank one.  The right factor is the fold direction and the left factor
the Kummer conormal.  Since only one is a polar carrier, this is an
inherited ramification shadow, not another sister.

## 9. The characteristic-zero Coble scalar

Heisenberg invariance places the dual sextic in a 43-dimensional orbit-sum
space.  Forty-two independent exact conormal evaluations cut out one
line.  Since duality guarantees that the actual sextic lies on that line,
the reconstructed polynomial is the dual equation, not an arbitrary
interpolant; eighteen held-out conormals check the reconstruction.

The remaining claim is a polynomial identity, not sampling.  In
\(\mathbf Q[x_0,\dots,x_8]/(F)\), exact reduction of all nine components
gives
\[
 69984\,\nabla H(\nabla F)
 +\det\operatorname{Hess}(F)\,x=0.
\]
Thus the normalization-free dual equation
\(\widehat H=-69984H\) satisfies
\[
 \nabla\widehat H(\nabla F)
 =\det\operatorname{Hess}(F)\,x
\]
on the cubic.  The reduction of \(-1/69984\) modulo \(101\) is \(45\),
explaining the earlier modular scalar.  The varying off-cubic ratios show
why the theorem is correctly restricted to the conormal locus.

## 10. Lie-\(E_8\), the \(S_6\) torsor, and its repair

The frozen branch sextic is irreducible modulo \(17\), so its Galois group
is transitive and contains a six-cycle.  Its factor patterns modulo \(7\)
and \(1303\) add a five-cycle and a transposition.  A five-cycle rules out
blocks of size two or three; the group is primitive.  A primitive degree-
six group containing a transposition is \(S_6\).  Therefore one marked
root lives over degree six, while a full ordering lives on a degree-\(720\)
torsor; over the one-root field the residual group is \(S_5\).

For a root \(r\), let \(D=f'(r)\) and put
\[
 t=-D/(x-r),\qquad X=yt^3/D.
\]
Taylor expansion gives the five derivative formulas for
\(c_6,c_{12},c_{18},c_{24},c_{30}\) in the report and hence the marked
Rains--Sam normal form.  Its square-free branch divisor makes the
associated \(\gamma_r\in\bigwedge^3K^9\) stable.

Contracting \(\gamma_r\) with a variable covector gives an odd alternating
matrix \(\Phi_\gamma(x)\) satisfying \(\Phi_\gamma(x)x=0\).  The vector of
signed maximal Pfaffians of any odd alternating matrix lies in its kernel.
On the dense rank-eight locus that kernel is \(Kx\), so
\[
 (-1)^i\operatorname{Pf}\Phi_\gamma(x)_{\widehat i}=x_iF_\gamma(x)
\]
for one cubic \(F_\gamma\).  Rains--Sam's orbit theorem identifies stable
trivectors with the same marked curve and trivial covering class, placing
this cubic in the frozen Jacobian Coble orbit; their kernel-reconstruction
lemma makes the change of theta basis effective.

An ordering of the six roots is precisely the missing level-\(2\) marking.
C704's polynomial covariance shows that comparison on one sheet forces
all \(720\) sheets, with permutation acting through the signed outer
\(S_6\) representation.  Centered squaring removes the sign, so the
unordered Segre--Igusa diagram descends.  Full \(S_5\) residual monodromy
proves that no ordering descends to the one-root field.  The split
\(p=1447\) computation checks all coordinate and Pfaffian conventions; it
is not the proof of the sheetwise propagation.

## 11. Pauli-doily mechanism

Label the six odd theta characteristics by \((a_i,b_i)\).  The duad
\(\{i,j\}\) maps to
\[
 v_{ij}=(b_i+b_j,a_i+a_j)\in\mathbf F_2^4.
\]
The difference of the two quadratic refinements is
\(B(v_{ij},-)\), so disjoint duads are exactly symplectically orthogonal
vectors.  Hence synthemes are commuting Pauli contexts, \(3+3\)
partitions are Mermin grids, and the five duads through one label are an
ovoid.  This gives the \(15/10/6\) dictionary equivariantly.

Let \(I\) be the context--point incidence matrix and \(H\) the
grid--context matrix over \(\mathbf F_2\).  Each grid point lies on two
grid contexts, so \(HI=0\).  Row reduction gives
\(\operatorname{rank}I=10\) and \(\operatorname{rank}H=5\); dimensions
then show that the rows of \(H\) are the entire left kernel of \(I\).
Thus grid parities are complete invariants of context signs modulo point
rephasing.

The Clebsch sign is
\[
 \lambda_C(M)=\epsilon(M)\prod_{\{i,j\}\in M}C_{ij}.
\]
The conference product is literally the point rephasing
\(P(v_{ij})\mapsto C_{ij}P(v_{ij})\).  The Pauli and Pfaffian signs have
the same ten grid parities, all \(-1\), so completeness proves they are
gauge-equivalent.  This explains, rather than merely reports, why ordinary
contextuality forgets the golden conference choice.

The resulting \([10,5,4]\) parity code has fifteen weight-four words, the
plane--node incidence blocks.  Its dual has the complementary fifteen
blocks; together they form \(S(3,4,10)=W_{10}\).  The two codes meet in
\(\langle\mathbf1\rangle\) and span the even-weight code.  The
half-preserving group is the natural \(S_6\) of order \(720\); adjoining a
half-exchange doubles it and realizes \(\operatorname{Aut}(S_6)\).
Orbit--stabilizer gives \(36=720/20\) involutory polarities, and the
conference \(S_5\) splits them as \(6+30\), with the six indexed by axes.
This is the finite outer-automorphism seam inherited by C708; it is not an
\(E_8\) conclusion.

Row reduction of \(H\) gives the five-dimensional
grid-parity image.  Enumerating its \(32\) words gives
\[
 1+15y^4+15y^6+y^{10}.
\]
The fifteen weight-four supports are the \(2\)-\((10,4,2)\) plane--node
design.  Their incidence determines the ten nodes and fifteen planes, so
its coordinate automorphism group is exactly the outer \(S_6\).  Applying
the same calculation to the orthogonal code gives the same enumerator but
a different frozen subspace.  The \(720\) coordinate maps from one to the
other form a torsor under that automorphism group, proving isoduality but
not self-duality.

Stacking generator matrices proves
\[
 \mathcal C\cap\mathcal C^\perp=\langle\mathbf1\rangle,\qquad
 \mathcal C+\mathcal C^\perp=E_{10}.
\]
The two minimum layers are disjoint and contain \(30\) blocks.  Counting
incidences gives \(30\binom43=\binom{10}3\), and direct inspection shows
that no triple repeats, proving the Steiner property.  The explicit
coordinate permutation in the report carries \(\mathcal C\) to Seymour's
\(R_{10}\) kernel, which identifies the Construction-A seam as \(Q_{10}\).

Finally, transporting raw conference edge signs through any of the
\(36\) polarities never reproduces the context signs: the mismatch counts
are \(3^2\,5^{10}\,7^{16}\,9^8\).  This is a complete finite check on the
already classified polarity orbit.  Because the comparison changes under
point gauge, it proves only failure of the naive frozen-sign selector.
The invariant statement is the \(6+30\) conference orbit split proved
above.

Three tempting stronger statements are false: raw minors do not yield the
polar carrier, the ambient Coble mixed differential is not corank one, and
one marked Weierstrass point does not canonically order the other five.
