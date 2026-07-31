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

The sharp optimum is simultaneous across all six outer protocols.  Its
twenty balanced phase controls are the oriented lifts of the ten Segre
nodes: complementation reverses the six amplitude signs, whereas squaring
forgets this orientation.  In particular every optimal probability vector
is constant, so \(W=0\), and every optimum lies on the exceptional divisor
\(e_5(Z)=0\).

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

There is more information in the same signed-moment calculation.  For a
balanced support \(S\), there is exactly one surviving triple, so for each
outer protocol
\[
 Z_T(x_S)=-8c_T(S)\in\{\pm8\}.
\]
Thus a single balanced control maximizes **all six** protocols
simultaneously.  The Segre relation \(\sum_T Z_T=0\) says that the normalized
amplitude vector
\[
 s(S)=\frac18(Z_T(x_S))_T
\]
has three plus and three minus entries.  Conversely these are exactly the
twenty signed representatives of the ten projective Segre nodes.  Since
\(x_{S^c}=-x_S\) and the cubics are odd,
\(s(S^c)=-s(S)\): complementation is precisely the two-to-one orientation
cover of the node set.

Squaring erases that cover completely.  Every optimal probability vector
is
\[
 (p_T^{(3)})_T=(16/125,\ldots,16/125),
\]
so every centered contrast vanishes: \(W=0\).  Moreover a balanced signed
six-vector has \(e_5(Z)=0\), since
\(e_5(Z)=(\prod_T Z_T)\sum_T Z_T^{-1}\).  Hence the entire maximum-success
locus lies on the inverse-polarity exceptional divisor.  This is not an
accident or a defect of the proof: probabilities are genuinely blind at
the optimum to both the chosen Segre node and its oriented lift.  The
relative determinant signs remain in the coherent amplitudes and can, in
principle, be read by interference against a fixed marked reference branch;
the six success probabilities alone cannot recover them.

For a fixed \(T\), the twenty controls split into ten with \(Z_T=8\) and
ten with \(Z_T=-8\).  These are the two \(A_5\)-orbits exchanged by the
outer \(S_5\), giving the same orientation boundary group-theoretically.
As a small normalization check, a uniformly random binary phase control
hits the balanced layer with probability \(20/64\); its mean three-copy
success probability is therefore
\((20/64)(16/125)=1/25\).

### The middle layer realizes the exceptional outer transform

Write
\[
 x(S)_i=1-2\,1_{i\in S},\qquad
 h(S)_T=Z_T(x(S))/8,
 \qquad |S|=3.
\]
Both vectors have three plus and three minus entries.  Let \(F(S)\) be the
negative support of \(h(S)\).  The preceding node identification says that
\(F\) is a bijection on the twenty triples, and oddness gives
\[
 F(S^c)=F(S)^c.
\]
The source six-set is the path set, while the target six-set is the set of
outer protocols.  Equivariance of the six Joubert cubics therefore makes
\(F\) the exceptional outer identification on their middle layers.

Here is a structural way to see what ``outer'' means.  Form the two
\(6\times20\) sign matrices
\[
 X_{iS}=x(S)_i,qquad H_{TS}=h(S)_T.
\]
Counting triples, and using the same vanishing signed moments for the mixed
term, gives
\[
 XX^{\mathsf T}=HH^{\mathsf T}=24I-4J,
 \qquad XH^{\mathsf T}=0.
\]
Thus the two matrices are orthogonal regular-simplex realizations of the two
five-dimensional constituents in the middle-layer permutation module.

For two triples put \(r=|S\cap R|\) and
\(q_r=\langle h(S),h(R)\rangle\).  Outer equivariance makes \(q_r\) depend
only on \(r\).  We have \(q_3=6\), \(q_0=-6\), and complementation gives
\(q_2=-q_1\).  Since \(HH^{\mathsf T}\) acts by \(24\) on the augmentation
space,
\[
 \sum_R\langle h(S),h(R)\rangle^2=24\langle h(S),h(S)\rangle=144.
\]
There are \(1,9,9,1\) triples meeting \(S\) in \(0,1,2,3\) points, so
\(72+18q_1^2=144\), whence \(|q_1|=2\).  One base triangle fixes the marked
orientation as \(q_1=2\), hence \(q_2=-2\).  Two balanced sign vectors whose
negative supports meet in \(k\) positions have inner product \(4k-6\).
Consequently
\[
 \boxed{
 |S\cap R|=0,1,2
 \quad\Longrightarrow\quad
 |F(S)\cap F(R)|=0,2,1.
 }
\]
Complements are preserved, while the two nontrivial Johnson relations are
exchanged.  This is the standard combinatorial signature of the exceptional
outer automorphism of \(S_6\), now realized by the coherent cubic-amplitude
map on the physically optimal phase layer.

The same calculation completes the whole middle-layer harmonic picture.
The classical harmonic decomposition of the Boolean slice (in the
Filmus--Mossel normalization) is
\[
 \mathbf R^{\binom63}=\mathbf1\oplus\mathbf5\oplus\mathbf9\oplus\mathbf5'.
\]
The rows of \(X\) and \(H\) are the two orthogonal five-spaces.  The
pointwise products \(X_{iS}H_{TS}\) are orthogonal to the constant and both
five-spaces by the signed-moment identities; their nonzero invariant span is
therefore the remaining nine-space.  Hence
\[
 \boxed{
 \mathbf R^{20}=\mathbf1\oplus V_{\mathrm{path}}
 \oplus V_{\mathrm{outer}}\oplus V_{\mathrm{path}\times\mathrm{outer}},
 \qquad \dim=(1,5,5,9).
 }
\]
So the optimal experiment does more than label the Segre nodes: its input
signs, oriented output amplitudes, and their correlations furnish all four
harmonic channels of the twenty-point middle layer.

### Cubic inversion and second-order invisibility

Choose a balanced control uniformly at random and regard the path signs
\(X_i\) and amplitude signs \(H_T=Z_T/8\) as random variables.  The mixed
moment identities sharpen \(XH^{\mathsf T}=0\) to
\[
 \mathbb E\left[H_T\prod_{i\in I}X_i\right]=0
 \quad(|I|\le2),
 \qquad
 \mathbb E[H_TX_iX_jX_k]=\pm\frac25.
\]
The sign in the last formula is the triangle flux of the marked outer
conference form.  Since the characters on any one or two input bits span
all functions of those bits, the first vanishing statement says more than
zero covariance: a single output amplitude sign is statistically independent
of any chosen pair of input phase signs.  By outer duality the converse also
holds.  The deterministic transform is therefore correlation-immune through
order two, and its first visible correlation is genuinely cubic.  This is
the statistical shadow of both the three-query lower bound and the
three-fermion determinant protocol.

The map also has an exact inverse of the same degree.  For a target triple
\(U\), let \(S=F^{-1}(U)\), and define six inverse coefficient systems by
\[
 \widetilde c_i(U)=-x(S)_i,
 \qquad
 \widetilde Z_i(y)=\sum_{|U|=3}\widetilde c_i(U)\prod_{T\in U}y_T.
\]
At a balanced target sign vector \(y=h(S)\), the same middle-layer detector
identity leaves only its negative support, giving
\[
 \boxed{\qquad \frac18\widetilde Z_i(h(S))=x(S)_i.\qquad}
\]
Thus the outer transform is not merely a finite bijection: both directions
are cubic phase transducers.  This inversion statement is restricted to the
balanced slice; it does not assert a polynomial inverse on all of
\(\mathbf R^6\).

### Two literal fermionic realizations

The exterior-cube protocol is already standard many-fermion scattering in
second-quantized language.  Prepare the three-fermion Slater determinant
occupying the one-particle space \(V_{T,+}\), apply the one-particle operator
\(D_x\), and ask for the event that all three fermions occupy
\(V_{T,-}\).  Fermionic anticommutation gives the transition amplitude as
the determinant of the one-particle block:
\[
 \langle\Omega_{T,-}|\widehat D_x|\Omega_{T,+}\rangle
 =\det(Q_{T,-}^{\mathsf T}D_xQ_{T,+})
 =\pm\frac{Z_T(x)}{10\sqrt5}.
\]
For a balanced phase mask \(D_x\), all diagonal entries are \(\pm1\), so
this is a lossless six-mode interferometer, not a lossy Kraus filter.  A
concrete run consists of three occupied input modes, a fixed mode mixer into
\(V_{T,+}\), three programmable \(\pi\)-phase shifts among the six paths, a
fixed output mixer resolving \(V_{T,-}\), and number detection.  The event
that its three designated output modes are occupied has probability
\(16/125\).  Ordinary indistinguishable fermions supply the antisymmetry;
one does not have to synthesize three distinguishable qutrit copies.

The same balanced control also gives a zero-dimensional class-D Majorana
system.  Set
\[
 A_T(x)=[D_x,C_T],\qquad
 \widehat H_T(x)=\frac i4\sum_{a,b}A_{T,ab}(x)\gamma_a\gamma_b.
\]
When \(x\) has three plus and three minus signs,
\((A_T)_{ij}=(x_i-x_j)C_{T,ij}\) vanishes inside the two parts and has
magnitude two across them.  Hence it is a signed \(K_{3,3}\) Majorana
coupling network.  In the golden splitting,
\[
 Q_{T,-}^{\mathsf T}A_TQ_{T,+}=2\sqrt5\,K_T.
\]
The optimal squared singular spectrum of \(K_T\) therefore gives the exact
positive Majorana energies
\[
 \boxed{\qquad \{2,4,4\},\qquad
 \operatorname{Pf}A_T=4Z_T=\pm32.\qquad}
\]
After fixing the Majorana orientation, the Pfaffian sign is the ground-state
fermion parity.  Thus the six outer amplitude signs are literally a balanced
six-bit parity syndrome for six conjugate gapped Majorana networks.  The
success probabilities forget this syndrome, while a parity measurement or
phase-referenced Slater amplitude retains it.

These are implementable finite free-fermion models, but no claim is made
that the specific golden six-mode mixer or fully signed \(K_{3,3}\) coupling
network has already been built.  A programmable fermionic mode simulator is
the direct route.  Ordinary photons without an antisymmetric internal-state
encoding produce permanents rather than determinants and do not implement
this protocol unchanged.

The optimum has a rigid singular spectrum.  For a balanced sign filter
\(D\), put \(M=K_T(D)^{\mathsf T}K_T(D)\).  Cyclic trace expansion of the
two golden projectors reduces to
\[
 \operatorname{tr}(CDCD)=-6,\qquad
 \operatorname{tr}((CD)^4)=-42.
\]
The first identity is
\(\sum_{i\ne j}d_id_j=(\sum_i d_i)^2-6\).  For the second, classify a
four-step closed walk by whether its opposite vertices coincide.  The
walks with both pairs equal contribute \(30\).  Those with exactly one
opposite pair equal contribute
\[
 2\sum_i\left(\left(\sum_{j\ne i}d_j\right)^2-5\right)
 =2\sum_i(1-5)=-48.
\]
For each four-set the three unoriented cycle products sum to \(-1\), the
four-point two-graph identity forced by the off-diagonal equations in
\(C^2=5I\).  Each cycle has eight orientations, while
\(e_4(d)=3\) for three plus and three minus signs, so the four-distinct
walks contribute \(-8e_4(d)=-24\).  The total is \(30-48-24=-42\).
Substitution in \(P_\pm=(I\pm C/\sqrt5)/2\) gives
\[
 \operatorname{tr}M=\frac95,\qquad
 \operatorname{tr}(M^2)=\frac{33}{25},\qquad
 \det M=\frac{16}{125}.
\]
Newton's identity gives the middle coefficient \(24/25\), and hence
\[
 \chi_{M|V_+}(\lambda)
 =\lambda^3-\frac95\lambda^2+\frac{24}{25}\lambda-\frac{16}{125}
 =\left(\lambda-\frac15\right)
  \left(\lambda-\frac45\right)^2.
\]
Thus every optimal transfer has squared singular values
\[
 \boxed{\quad\{4/5,4/5,1/5\}.\quad}
\]
The full outer \(S_5\) is transitive on the twenty \(3+3\) phase patterns,
so the calculation is independent of the chosen optimum.

Three uses of the controlled filter are also necessary, not just
sufficient.  In any coherent circuit whose other gates and ancillas are
independent of \(x\), an amplitude after \(r\) uses of \(D_x\) is a
polynomial of degree at most \(r\), and an acceptance probability has
degree at most \(2r\).  The target \(Z_T(x)^2/500\) is a nonzero homogeneous
polynomial of degree six.  Equality on the physical cube, which has
interior, is polynomial equality; therefore \(2r\ge6\).  The exterior-cube
protocol uses three parallel filters, so it is query-optimal in this
coherent black-box model, even with arbitrary \(x\)-independent ancillas.

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

## 6. Anomaly charges and the lossless/chiral boundary

The six outer cubics satisfy the two Segre identities
\[
 \sum_T Z_T(x)=0,
 \qquad
 \sum_T Z_T(x)^3=0.
\]
Read projectively over the rationals, these are exactly the mixed
gravitational--\(U(1)\) and \(U(1)^3\) local-anomaly cancellation equations
for the charges of six left-handed Weyl fermions.  Thus every rational
filter produces an anomaly-free projective charge vector whenever its
amplitude vector is nonzero.  This is an interpretation of the same cubic
identities, not a claim that the six interferometer modes literally acquire
gauge charge.

The real lossless boundary is exceptionally rigid.  Write a phase vertex as
\(x=1-2y\), with negative support \(S\).  Expanding a triangle cubic gives
\[
 Z_T(1-2y)=-8\sum_{\{i,j,k\}\subset S}c^T_{ijk},
\]
because the constant, linear, and quadratic signed moments vanish.  Hence
\(Z(x)=0\) when \(|S|<3\).  Odd homogeneity gives the same conclusion when
\(|S|>3\), by replacing \(x\) with \(-x\).  When \(|S|=3\), exactly one
term survives for each outer cubic and
\[
 Z(x)\in\{\text{permutations of }(-8,-8,-8,8,8,8)\}.
\]
Therefore the 64 real lossless phase masks split into 44 null controls and
20 oriented Segre nodes.  Every nonzero lossless output is vectorlike: its
charges pair as \(q,-q\).  No chiral anomaly assignment occurs on this
Boolean unitary boundary.

Chirality appears immediately for a contractive, postselected filter.  For
the admissible path amplitudes
\[
 x=\frac13(-3,-2,-1,0,1,3)
\]
direct substitution into the six cubics gives, up to a common nonzero scale
(including the cubic rescaling \(3^{-3}\)),
\[
 \boxed{\quad Z(x)\sim(11,-10,-8,5,4,-2).\quad}
\]
The entries sum to zero, their cubes sum to zero, none vanishes, and no two
are opposite.  This is therefore a primitive chiral six-Weyl anomaly-free
charge assignment.  Operationally, the same six integers are the oriented
three-fermion transition amplitudes of the golden filter, up to the fixed
normalization and common projective scale.  The mechanism is clear:
lossless real phases land on the singular vectorlike nodes, whereas unequal
attenuation moves the postselected amplitudes onto the smooth chiral part of
the Segre cubic.

## 7. Classical boundary and operator-specific content

The following facts are standard frame theory: a symmetric conference
matrix produces a \((6,3)\) ETF; \(2I-G\) is its Naimark complement; a tight
frame rescales to a rank-one POVM; and the six icosahedral axes realize the
same real ETF.

The operator-specific content begins only after the two complements are
kept together with their coherent signs and the marked diagonal controls:
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
operator and its outer marking.  In particular, the POVM effects alone
forget the signs of the frame vectors and do not determine \(K_T\); the
operational claim belongs to the coherently signed Naimark instrument.
