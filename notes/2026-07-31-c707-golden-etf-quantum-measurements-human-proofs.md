# C707 human proofs — golden qutrit measurements and transition volume

**Lane:** clebsch

**Date:** 2026-07-31

## Theorem

Let \(C=C^{\mathsf T}\) be the golden conference matrix, \(C^2=5I_6\), and
let
\[
 P_\pm=\frac12\left(I\pm\frac{C}{\sqrt5}\right).
\]
Then the two rank-three spaces \(V_\pm=\operatorname{im}P_\pm\) carry
Naimark-complementary six-vector real equiangular tight frames.  After
normalization, each frame gives a six-outcome POVM which is minimally
informationally complete for real qutrit states, but not informationally
complete for complex qutrit states.

For every outer total \(T\), choose isometries
\(Q_{T,\pm}:\mathbf R^3\to V_{T,\pm}\).  If
\(D_x=\operatorname{diag}(x_0,\ldots,x_5)\) and
\(\max_i|x_i|\le1\), then
\[
 K_T(x)=Q_{T,-}^{\mathsf T}D_xQ_{T,+}
\]
is a valid postselected real-qutrit transfer operator and
\[
 \det K_T(x)=\pm\frac{Z_T(x)}{10\sqrt5},
 \qquad
 \det(K_T(x)^{\mathsf T}K_T(x))=\frac{Z_T(x)^2}{500}.
\]
Consequently \(Z_T\) is an oriented three-copy transition amplitude,
the centered squares \(W_T\) are centered success-probability contrasts,
and \(A=dZ\) is their amplitude response.  The inverse Segre--Igusa
polarity recovers the projective signed amplitude vector from those
probability contrasts away from its known exceptional divisor.

## 1. The two normalized frames

Choose an isometry \(Q_\pm:\mathbf R^3\to\mathbf R^6\) with image
\(V_\pm\), so
\[
 Q_\pm^{\mathsf T}Q_\pm=I_3,
 \qquad Q_\pm Q_\pm^{\mathsf T}=P_\pm.
\]
Define six unit vectors by
\[
 u_i^\pm=\sqrt2\,Q_\pm^{\mathsf T}e_i.
\]
Their Gram matrices are
\[
 G_\pm=(\langle u_i^\pm,u_j^\pm\rangle)_{ij}
       =2P_\pm=I\pm\frac C{\sqrt5}.
\]
The diagonal entries are one and every off-diagonal entry has absolute
value \(1/\sqrt5\).  Moreover
\[
 \sum_i u_i^\pm(u_i^\pm)^{\mathsf T}
 =2Q_\pm^{\mathsf T}Q_\pm=2I_3.
\]
Thus both systems are unit-norm \((6,3)\) real ETFs with frame bound two.
Since \(G_++G_-=2I_6\), they are Naimark complements with the same marked
outcomes.

Put \(\Pi_i^\pm=u_i^\pm(u_i^\pm)^{\mathsf T}\).  Then
\[
 E_i^\pm=\frac12\Pi_i^\pm,
 \qquad \sum_iE_i^\pm=I_3,
\]
so each frame is a genuine six-outcome rank-one POVM.

The signed permutations preserving \(C\) act on each frame; those
negating \(C\) exchange the two frames.  The orientation-preserving half
has order \(60\) and gives the icosahedral \(A_5\) symmetry of either
measurement.  Adding the exchanging half gives the order-\(120\) outer
\(S_5\) symmetry of the marked pair.

## 2. Exactly what is informationally complete

The Hilbert--Schmidt Gram matrix of the six projectors is
\[
 H_{ij}=\operatorname{tr}(\Pi_i\Pi_j)
 =\begin{cases}1&i=j,\\1/5&i\ne j.\end{cases}
\]
It has eigenvalue \(2\) on the constant line and eigenvalue \(4/5\) on
its five-dimensional complement.  Hence the six projectors are linearly
independent.  Since \(\dim\operatorname{Sym}_3(\mathbf R)=6\), they form a
basis of the real symmetric operators.

For a real density matrix \(\rho\), let
\(p_i=\operatorname{tr}(E_i\rho)\).  Then
\[
 \boxed{\quad
 \rho=\frac52\sum_i p_i\Pi_i-\frac12I_3.
 \quad}
\]
Indeed, taking the inner product with \(\Pi_j\), using
\(\sum_i p_i=1\), gives
\[
 \frac52\left(p_j+\frac15(1-p_j)\right)-\frac12=2p_j
 =\operatorname{tr}(\Pi_j\rho).
\]
The basis property proves the formula.  Equivalently, the centered
projectors \(\Pi_i-I/3\) are the vertices of a regular simplex in the
five-dimensional trace-zero real symmetric space, so the linear inversion
is isotropic.

This is minimal tomography only in real quantum theory: a trace-one real
qutrit state has five free parameters and the six probabilities have one
sum relation.  A complex Hermitian qutrit state has eight free parameters,
so six outcomes cannot be informationally complete.  These measurements
are not qutrit SICs, which have nine outcomes; their squared overlap is
\(1/5\), not \(1/4\).

## 3. The cross-golden block is a physical transfer branch

Use the same marked six-dimensional dilation for the two complementary
measurements.  Encode a real qutrit by \(Q_{T,+}\), apply the diagonal path
filter \(D_x\), and decode through \(Q_{T,-}^{\mathsf T}\).  If
\(\|x\|_\infty\le1\), every factor is a contraction, so
\[
 K_T(x)^{\mathsf T}K_T(x)\le I_3.
\]
Thus \(K_T(x)\) is a legitimate Kraus operator for a postselected branch.
Negative \(x_i\)'s are path phases, not negative probabilities.

The frame vectors give the equivalent formula
\[
 K_T(x)=\sum_i x_i
 (Q_{T,-}^{\mathsf T}e_i)(e_i^{\mathsf T}Q_{T,+})
 =\frac12\sum_i x_i\,u_{T,i}^-(u_{T,i}^+)^{\mathsf T}.
\]
Under the two isometries this is precisely the C704 cross-golden block
\[
 B_T(x)=P_{T,-}D_xP_{T,+}:V_{T,+}\longrightarrow V_{T,-}.
\]
The cross-golden determinant theorem therefore reads
\[
 Z_T(x)=\pm10\sqrt5\det K_T(x).
\]
Changing either orientation changes both determinant signs and leaves all
probabilities invariant.  Changing the isometries \(Q_{T,\pm}\) conjugates
the qutrit coordinates orthogonally, so the squared determinant below is
intrinsic to the marked dilation.

There is an exact experiment behind the determinant.  Prepare three
copies in the normalized generator \(\Omega_+\) of
\(\bigwedge^3\mathbf R^3\), apply the same postselected branch to all three,
and test the output antisymmetric line.  Exterior algebra gives
\[
 (\bigwedge^3K_T)\Omega_+=\det(K_T)\Omega_-,
\]
so the branch success probability is
\[
 p_T^{(3)}(x)=\|K_T^{\otimes3}\Omega_+\|^2
 =\det(K_T^{\mathsf T}K_T)
 =\frac{Z_T(x)^2}{500}.
\]
This is the promised operational transition-volume meaning.  It needs a
coherent dilation and three copies; \(Z_T\) is not a one-copy Born
probability.

The conference identities also give the sharp physical bound without
optimization.  Write \(c_{ijk}=C_{ij}C_{jk}C_{ki}\).  For every fixed pair
and every fixed vertex respectively,
\[
 \sum_k c_{ijk}=C_{ij}(C^2)_{ji}=0,
 \qquad
 \sum_{j<k}c_{ijk}=\frac12(C^3)_{ii}=0.
\]
The total signed sum vanishes as well.  At a cube vertex write
\(x_i=1-2y_i\), where \(S=\{i:y_i=1\}\).  Expanding the cubic, all terms
of degree below three vanish by the preceding moment identities, leaving
\[
 Z_T(1-2y)=-8\sum_{\{i,j,k\}\subset S}c_{ijk}.
\]
For \(|S|<3\) this is zero, while for \(|S|=3\) it is \(\pm8\).
Replacing \(S\) by its complement negates the input, so these cases cover
\(|S|>3\) as well.  Hence the \(64\) vertices give \(44\) zeros and twenty
values of absolute value eight.

A multilinear polynomial on a cube attains the maximum of its absolute
value at a vertex: fix five variables and maximize the remaining affine
function at an endpoint, then iterate.  Therefore
\[
 \boxed{\quad |Z_T(x)|\le8,\qquad
 p_T^{(3)}(x)\le\frac{16}{125}\quad(\|x\|_\infty\le1).\quad}
\]
Multilinear interpolation writes every interior value as a convex
combination of the vertex values.  Equality forces every vertex carrying
positive weight to have the same extremal value; but each extremal
\(3+3\) vertex is adjacent only to zero vertices.  Hence equality occurs
exactly at the twenty balanced \(3+3\) phase vertices.
Thus even the optimal coherent filter succeeds with probability only
\(16/125\); the generic contraction bound \(p\le1\) is far from sharp.

## 4. The operator tower as response and probability contrast

Let \(Z=(Z_T)_T\) run over the six outer protocols.  The C704 polar
normalization is
\[
 W_T^{\mathrm{cent}}
 =Z_T^2-\frac16\sum_UZ_U^2
 =500\left(p_T^{(3)}-\frac16\sum_Up_U^{(3)}\right).
\]
The C705 integral normalization is six times this vector:
\[
 W_T=6Z_T^2-\sum_UZ_U^2
 =3000\left(p_T^{(3)}-\frac16\sum_Up_U^{(3)}\right).
\]
Thus the Igusa polar coordinate is exactly the contrast of one protocol's
three-copy success probability against the six-protocol mean.

Since all normalization factors are constant, \(A=dZ\) is the first
response of the oriented transition amplitudes to changes of the six path
controls.  Translation of all controls is invisible because
\(Q_{T,-}^{\mathsf T}Q_{T,+}=0\).  On the centered slice the adjugate
identity
\[
 \operatorname{adj}A=6Wq^{\mathsf T},
 \qquad q=\operatorname{center}(x_i^2),
\]
says that the maximal nonzero response compound factors into the
special-conformal invisible control direction and the unique
probability-contrast conormal direction.

The inverse polarity is more striking.  Given
\[
 w_i=z_i^2-\frac16\sum_jz_j^2,
 \qquad
 y_i=\operatorname{center}_i\left(w_i\sum_jw_j^2-4w_i^3\right),
\]
the Segre relations imply
\[
 y_i=-4e_5(z)z_i.
\]
Hence, away from \(e_5(z)=0\), the six centered success probabilities
recover the projective signed amplitude vector \(z\), even though each
individual probability has forgotten its sign.  This recovery is forced
by the Segre constraint; it is not true for six arbitrary amplitudes.

## 5. Operational rank strata and boundaries

The determinantal stratification becomes a transfer-rank stratification:

- off the Joubert cubic, \(K_T(x)\) has rank three;
- at a smooth cubic point it has rank two, so one transfer singular value
  vanishes; and
- at one of the six nodes it has rank one, so two transfer directions
  vanish.

The right- and left-kernel incidences are the input and output dark-state
lines of the transfer branch.  Their jumps at the nodes are the two
small-resolution fibres described in C704 and the chiral zero modes of
C709.

The other exceptional loci must not be confused with tomography failure.
On the four-collision base lines every \(Z_T\), hence every three-copy
success amplitude, vanishes.  On the twenty triple-collision planes the
centered vector \(W\) vanishes, so all six three-copy success probabilities
are equal and their contrasts carry no protocol label.  The underlying
six-outcome POVMs remain real-informationally-complete throughout: these
are degeneracies of the controlled cross-measurement transfer family, not
of state reconstruction.

## 6. Classical boundary and operator-specific content

The following facts are standard frame theory: a symmetric conference
matrix produces a \((6,3)\) ETF; \(2I-G\) is its Naimark complement; a tight
frame rescales to a rank-one POVM; and the six icosahedral axes realize the
same real ETF.

The operator-specific content begins only after the two complements are
kept together with the marked diagonal controls:
\[
 \det(P_-D_xP_+)\longleftrightarrow Z_T,
 \qquad
 \det(K_T^{\mathsf T}K_T)\longleftrightarrow Z_T^2,
 \qquad
 \operatorname{center}(Z_T^2)\longleftrightarrow W_T.
\]
Neither ordinary ETF theory nor the definition of a POVM supplies the
Joubert cubic, the Segre relation among six outer protocols, the
Segre--Igusa inverse polarity, the sharp \(3+3\) phase optimum, or the
small-resolution rank strata.  Those come from the golden conference
operator and its outer marking.
