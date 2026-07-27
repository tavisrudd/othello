# C682 Hitchin-facing structural exploration

**Date:** 2026-07-26  
**Lane:** `clebsch`  
**Status:** in progress — transvectant reconstruction and pointed Sarkisov graph proved; open-ended
**Stopping authority:** the user decides when C682 is done

## Purpose

Explore the structures surrounding Paper III for anything mathematically
interesting that a Hitchin-level reader would notice.  The target is
Gold/Platinum-level structure.  Preserve genuine Silver findings as interim
gains, but do not treat Silver as completion.

The starting objects are:

- the rational \(5J_0\) incidence torsor;
- the complete etale golden fibre over \([xyz]\);
- the two conjugate \(\mathbf Q(\sqrt5)\)-defined Clebsch charts and their
  descended union;
- the completed two-branch conductor model;
- the abstract Clebsch \(A_5\)-module and Petersen \((-2)\)-eigenspace;
- the degree-six Steinhardt/Gaunt realization and exact \(W_6\) restriction;
  and
- the exact boundary between the common abstract cubic and the two ambient
  harmonic embeddings.

## Exploration mandate

Look for structural consequences, hidden equivalences, moduli
interpretations, arithmetic refinements, invariant-theoretic explanations,
representation-theoretic mechanisms, geometric examples, and strong new
questions.  If the first proposed bridge is tautological, false, or merely a
restatement of the paper, continue into other directions.  A failed lead is
not a stopping condition.

Record proved deductions and conjectural leads separately.  Do not infer a
rational, integral, or ambient geometric identification from the common
\(A_5\)-module alone.  Such an identification may be explored, but it must be
constructed and checked before it is stated as a result.

There is no preset theorem target, negative-close test, acceptance gate, or
automatic completion condition.  The task remains open until the user says
otherwise.  It does not hold or reopen the pre-release-green Paper III bytes
unless the user later chooses to promote a finding.

## Initial questions, not gates

1. Is \(5J_0\) best understood as an arithmetic orientation or discriminant
   class of Hitchin's unordered pair of icosahedral configurations?
2. Does the completed conductor model at \([xyz]\) extend to a useful local
   or stack-theoretic description of the incidence cover?
3. Is the common Clebsch cubic characterized intrinsically by a universal
   property shared by the incidence and harmonic realizations?
4. Does the Petersen pair-sum model explain the factor \(5\), the factor
   \(13\), or their independence through a single representation-theoretic
   construction?
5. Are there arithmetic or geometric specializations beyond \(q=11\) that
   reveal a new invariant rather than another finite check?
6. What neighboring Hitchin construction, invariant variety, period map, or
   integrable-system viewpoint makes the present coincidence inevitable?

These questions seed the search only.  Replace them freely when a deeper
direction appears.

## Interim Gold result: the odd transvectant bridge

Fix an icosahedral subgroup \(A_5\subset SO_3\) and a nonzero invariant
degree-six harmonic \(I\in\mathcal H_6^{A_5}\).  Clebsch--Gordan gives a
unique nonzero \(SO_3\)-equivariant coupling
\[
 C:\mathcal H_3\otimes\mathcal H_6\longrightarrow\mathcal H_6.
\]
In the binary-form model this is the third transvectant.  The curried map
\[
 T_I:\mathcal H_3\longrightarrow\mathcal H_6,\qquad p\longmapsto C(p,I),
\]
is \(A_5\)-equivariant.

The restricted harmonic representations are
\[
 \mathcal H_3|_{A_5}\simeq V_{3'}\oplus V_4,\qquad
 \mathcal H_6|_{A_5}\simeq
 \mathbf1\oplus V_3\oplus V_4\oplus V_5.
\]
The currying \(I\mapsto T_I\) is a nonzero \(SO_3\)-map out of the
irreducible module \(\mathcal H_6\), hence is injective.  Thus \(T_I\ne0\).
The displayed restrictions then force
\[
 \ker T_I=V_{3'},\qquad
 \operatorname{im}T_I=V_4,\qquad
 \operatorname{rank}T_I=4.
\]
For Hitchin's parent \(I_t\), the kernel is the parent three-plane \(U_t\)
and its orthogonal complement is the Clebsch chart \(V_t\).  In degree six,
the unique \(V_4\) is exactly the Petersen \((-2)\)-eigenspace carried by
the face-axis zonal harmonics.  Consequently
\[
 T_{I_t}|_{V_t}:V_t\xrightarrow{\sim}V_4^{\mathrm{Petersen}}
\]
is the previously missing ambient construction, up to its single scalar.
Preserving \(\sigma_3\) fixes that scalar as in the existing abstract
comparison.

This changes the conceptual boundary.  There is no parent-independent
\(SO_3\)-linear map \(\mathcal H_3\to\mathcal H_6\), but after choosing the
icosahedral invariant \(I_t\), the unique Clebsch--Gordan coupling supplies
a canonical map.  The construction is orientation-sensitive: the third
transvectant is odd under the determinant character when extended from
\(SO_3\) to \(O_3\).  Thus the common cubic is not supported only by
Schur's lemma; it is transported by a classical covariant whose dependence
on the chosen parent is visible.

An exact binary-form witness uses Klein's dodecic
\[
 \Phi_{12}=XY(X^{10}+11X^5Y^5-Y^{10}).
\]
On the basis \(X^{6-k}Y^k\), the map
\(p\mapsto(p,\Phi_{12})_3\) has rank four and kernel
\[
 \left\langle
 X^3Y^3,\;
 X^6+3XY^5,\;
 3X^5Y-Y^6
 \right\rangle.
\]
These three sextics are pairwise isotropic for the fifth transvectant:
\[
 (u,v)_5=0\qquad(u,v\in\ker T_{\Phi_{12}}).
\]
That fifth-transvectant condition is the binary-form version of Hitchin's
three skew forms on \(\operatorname{Gr}(3,\mathcal H_3)\).  Hence the
kernel is a point of the Grassmannian Mukai--Umemura threefold.

More is true on the open orbit.  The assignment
\[
 [I]\longmapsto\ker\bigl(p\mapsto(p,I)_3\bigr)
\]
is \(PSL_2\)-equivariant wherever the rank is four.  At the Klein
dodecic it carries the standard \(PSL_2/A_5\) orbit in
\(\mathbf P(\operatorname{Sym}^{12})\) to the open
\(PSL_2/A_5\) orbit in Hitchin's Grassmannian model.  Thus it identifies
the two open orbits.  This is the sought representation-geometric diagram:
the degree-six invariant determines the degree-three parent plane by a
kernel construction, and its rank-four image is the Petersen channel.

The two boundary-orbit tests are also positive.  At the two-dimensional
boundary representative \(I=X^{11}Y\), the map still has rank four and
\[
 \ker T_I=\langle X^6,X^5Y,X^3Y^3\rangle,
\]
the weight-\(\{3,2,0\}\) plane in Hitchin's first boundary orbit.  At the
one-dimensional closed-orbit representative \(I=X^{12}\), it has rank four
and
\[
 \ker T_I=\langle X^6,X^5Y,X^4Y^2\rangle,
\]
the weight-\(\{3,2,1\}\) plane in Hitchin's second boundary orbit.  Both
kernels satisfy all fifth-transvectant isotropy equations.  Thus the
kernel formula reaches every orbit type in the compactification.  A
source-level identification of the precise binary orbit compactification
and a regularity argument remain before calling this a global isomorphism.

The determinantal recognition proposal passes its first local gate.
Linearizing the \(13\)-by-\(7\) rank-at-most-four condition at
\(\Phi_{12}\) gives \(27\) kernel-to-cokernel equations of rank nine.
The affine tangent space therefore has dimension four, and its
projectivization has dimension three.  Since the \(PSL_2/A_5\) orbit
already has dimension three, the rank locus is smooth of the expected
orbit dimension at the Klein point.  In particular, the
Mukai--Umemura orbit closure is the local irreducible component of the
rank locus through that point.  This does not rule out remote components
or by itself prove the boundary extension.  The divisor-orbit
representative again has projective rank-locus tangent dimension three.
At the closed orbit it rises to four, so rank alone acquires one extra
infinitesimal direction there; the isotropy equations are plausibly
essential for the global scheme structure.

The primitive integral matrix gives a second cross-characteristic dividend.
The conventional third transvectant has common content
\(2640=2^4\cdot3\cdot5\cdot11\).  After dividing by that content, its matrix
has rank four modulo \(2,3,7,11,13,17,19\) and rank two modulo \(5\).
In particular, the module map survives at \(11\) despite the pole in the
Gaunt normalization.  The existing denominator obstruction is therefore
an obstruction to reducing that spherical cubic scalar, not to reducing a
primitive degree-three-to-degree-six module bridge.

The deterministic certificate
`notes/2026-07-26-c682-transvectant-bridge.json` is generated and checked
by `notes/2026-07-26-c682-transvectant-bridge.py`.  From the repository
root, replay with

```text
python3 notes/2026-07-26-c682-transvectant-bridge.py --check
python3 notes/2026-07-26-c682-transvectant-bridge-replay.py
```

The computation certifies the displayed transvectant matrix, open and
boundary ranks and kernels, fifth-transvectant isotropy, all three
rank-locus tangent dimensions, primitive reduction ranks, and the exact
golden Gale--Galois identity.  It also certifies the marked
support-to-face-axis dictionary, both complementary signed-sum
decompositions, the support trade's first nonzero cubic moment, and the
two-witness failure of the naive quadratic--cubic square identity.  It
then checks the corrected sextic identity on the exact \(7^5\)
interpolation grid and records the Molien dimensions and non-symmetric
witness.  It does not
identify the paper's Euclidean rational form, the normalization scalar,
global boundary components, boundary regularity, or a global incidence
morphism.
The representation-theoretic proof is independent of the matrix
calculation.  A separate implementation replays the rank, isotropy, and
tangent calculation modulo \(101\), and the Gale identity modulo \(11\);
it separately replays the marked face-support bridge modulo \(101\) and
the corrected identity on a second exact \(7^5\) grid.
Its nonzero minors independently confirm the lower rank bounds used by
the exact rational calculation.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-26-c682-transvectant-bridge.py` | 29729 | `a8fcb633dceef68be207a376c26277e661094b026620fdba1f9e6d0ed95a8fc3` |
| `2026-07-26-c682-transvectant-bridge-replay.py` | 15276 | `85f64401ec0cfd5ad6339e7381d1da9a8a6ec361ead61d758bb1823cb757723e` |
| `2026-07-26-c682-transvectant-bridge.json` | 19322 | `78a6767dad35df8e4cf12d5c0e16f06b6506ed59e597bca8c108d803c3266639` |

No novelty claim is made.  A promotion to manuscript theorem would require
a targeted primary-source audit for this precise covariant, an explicit
comparison between the binary and Euclidean conventions, and a check of
the two conjugate maps over \(\mathbf Q(\sqrt5)\).

## Bridge and algorithm landscape

The paper's results organize several large spaces by low-dimensional
structures.  The following are mathematical routes, not claims of an
implemented production algorithm.

| entering space or problem | structure supplied by the paper | resulting reduction or algorithm |
|---|---|---|
| three-planes in \(\mathcal H_3\), a 12-dimensional Grassmannian | the Mukai--Umemura threefold of isotropic planes has dimension three | search on the icosahedral moduli threefold; a generic cubic then has exactly two parent points |
| degree-six harmonics, a projective 12-space | the Klein/transvectant rank-four locus contains the three-dimensional \(PSL_2/A_5\) orbit | form a \(13\times7\) transvectant matrix, recover the parent plane as its kernel, and use rank plus fifth-transvectant isotropy as an exact recognition certificate |
| a general sextic branch hypersurface in \(\mathbf P(\mathcal H_3)\) | on a Clebsch chart, \(J_0=16\sigma_3^2\) | replace a seven-variable sextic calculation by a four-variable cubic calculation, while retaining the two-sheet descent class |
| ten labelled face-axis weights | the Petersen adjacency algebra splits them as \(\mathbf1\oplus V_4\oplus V_5\) | project exactly to \(V_4\) by \((A-3I)(A-I)/15\), then recover \(y_i=\frac13\sum_{j\ne i}a_{ij}\) |
| thirteen degree-six spherical coefficients and a Wigner-\(3j\) cubic sum | on the Petersen channel the cubic is a fixed multiple of \(\sigma_3(y)\) | compute the order parameter from five numbers summing to zero; the quadratic moment is likewise a scalar quadratic form |
| rational or finite-field parent/exchanger cases | \([5]\) controls existence of the two parents and \([2]\) controls the special-projective class of their exchanger | replace subgroup enumeration by two square-class tests; over prime fields the cases are periodic modulo \(40\) |
| the six-generator descended two-branch singularity | its normalization is \(\mathbf Q(\sqrt5)[[x_1,x_2,x_3]]\) with one residue-field pinch | normalize computations to three variables over the quadratic field and impose one conductor gluing condition |
| continuation near the two-parent incidence problem | the cover has discriminant \(5J_0\) and known branch \(J_0=0\) | track the two solutions by numerical continuation and use \(J_0\) as the collision/conditioning monitor |

### Problems these bridges could attack

1. **Recognition of the Mukai--Umemura orbit.**  Determine whether
   \[
   \operatorname{rank}T_I\le4,\qquad
   (\ker T_I,\ker T_I)_5=0
   \]
   characterizes the icosahedral orbit closure in
   \(\mathbf P(\mathcal H_6)\).  A positive answer gives low-degree
   determinantal equations and a fast exact membership test for a
   threefold inside projective 12-space.  The tangent computation proves
   that this is already the correct local component and dimension at the
   Klein point.
2. **Constructive inversion of Hitchin's incidence cover.**  Given a
   harmonic cubic \(f\), solve for the two \(I\)'s whose transvectant
   kernels are orthogonal to \(f\).  This replaces a search through
   \(\operatorname{Gr}(3,7)\) by a structured problem on a
   three-dimensional orbit, with \(5J_0(f)\) as its discriminant.
3. **Noisy icosahedral pose and symmetry recovery.**  For spherical data,
   use the singular-value gap of \(T_I\) and the Petersen spectral projector
   as stable relaxations of the exact rank/isotropy test.  This could apply
   to molecular environments, quasicrystalline order, capsid geometry, or
   spherical imaging.  Robustness under noise is presently conjectural.
4. **Exact branch-aware continuation.**  Track the two parent solutions
   through parameter families without relabelling them from scratch.  The
   orientation cover supplies the monodromy bit, and the local pinch gives
   the correct model when conjugate charts meet.
5. **Finite-field configuration and subgroup search.**  The independent
   \([5]\) and \([2]\) characters partition fields before any explicit
   icosahedron, transporter, or \(PSL_2/PGL_2\) search is attempted.  This
   can prune finite-geometry and code-equivalence searches by ruling out
   impossible arithmetic regimes first.
6. **Fast decorated bond-order descriptors.**  Project a ten-axis signal
   to the four-dimensional Petersen channel and evaluate its exact
   quadratic/cubic invariants.  This gives a symmetry-aware feature with
   exact normalization; whether it improves classification beyond standard
   \(Q_6,W_6\), SOAP, or ACE features is an empirical question.
7. **Boundary geometry of the Fano compactification.**  Analyze rank jumps
   of \(T_I\) on degenerate Klein forms.  The kernel dimensions and
   isotropy failures may give an algorithmic stratification of the
   Mukai--Umemura boundary and explain which degenerate icosahedra occur in
   the branched incidence fibre.

The highest-EV mathematical question is the first one.  If the
rank-plus-isotropy conditions characterize the orbit closure, the same
matrix simultaneously becomes a moduli map, an exact recognizer, a
reconstruction algorithm, and a source of defining equations.

## Original Platinum candidate: the Clebsch \(2\)-\(3\)-\(6\) ladder

The later marked-incidence test below preserves the common carrier and
two-decomposition square but falsifies the proposed equality of the
support and Galois \(C_2\)-operations.  The naive quadratic--cubic square
factorization also fails.  This section records the surviving target and
its original gates; it is no longer a theorem candidate in this literal
form.

The three Clebsch papers suggest a single inverse problem with a stronger
conclusion than any paper states separately.  The displayed coordinate
identities below are exact; the red-team audit later in this section explains
why they do not yet constitute an intrinsic three-paper theorem.

Let \(A\subset\operatorname{PG}(2,11)\) be a six-arc satisfying any of
Paper I's equivalent coarse conditions: its uncovered locus lies on a
conic, has at most fifteen points, or is the full rational conic.  Then:

1. **Quadratic recognition (Paper I).**  The deepest syndrome locus
   reconstructs the Clebsch class, its conic, and its hidden \(A_5\).
2. **Quadratic sheet recovery and cubic orientation (Paper II).**  On the
   associated \(H_3\) conic-matching quotient, second moments recover the
   two factorization sheets up to interchange.  The first signed moment is
   the cubic
   \[
   c_{\mathrm{match}}=4\sigma_3\quad\text{over }\mathbf F_{11}.
   \]
3. **Sextic discriminant and harmonic realization (Paper III).**  On the
   Clebsch chart,
   \[
   J_0=16\sigma_3^2,
   \]
   while the degree-six Gaunt/Steinhardt cubic is a nonzero scalar multiple
   of the same \(\sigma_3\).  The primitive third transvectant now gives the
   geometric degree-three-to-degree-six module map.

With C651's selected intertwiner, the recorded coordinates fit exactly:
\[
 \boxed{c_{\mathrm{match}}^2=J_0|_V\quad\text{in }\mathbf F_{11}.}
\]
Moreover Paper III's abstract orientation algebra is
\[
 w^2=5J_0.
\]
Since \(4^2=5\) in \(\mathbf F_{11}\),
\[
 \boxed{w=\pm4c_{\mathrm{match}}.}
\]
Thus the selected coordinate representative of Paper II's signed cubic is a
square root of Hitchin's restricted sextic, and its scalar multiple solves
the reduced abstract orientation equation.  This statement is
basis-dependent until the primitive transvectant or another universal
construction fixes C651's \(V_4\) scalar.  The sign has the desired formal
shape of a deck involution, but equality of the Paper II sheet torsor with
the Paper III incidence torsor must still be constructed.

This motivates the conceptual degree ladder
\[
 \boxed{\text{degree \(2\): reconstruct the unordered object}
 \ \longrightarrow\
 \text{degree \(3\): orient it}
 \ \longrightarrow\
 \text{degree \(6\): forget orientation by squaring}.}
\]
The odd third transvectant explains why this is an orientation phenomenon:
it is \(SO_3\)-equivariant but acquires the determinant character when
extended to \(O_3\).  The sextic discriminant is therefore the even shadow
of the cubic orientation coordinate.

### End-to-end theorem shape

After freezing compatible markings, the combined theorem should say:

> Coarse deepest-syndrome data of a six-coordinate Clebsch MDS seed
> reconstruct an unordered arithmetic orientation torsor, its cubic sheet
> coordinate, its Mukai--Umemura parent plane, and its degree-six Petersen
> harmonic channel.  Choosing a sheet turns the cubic into a square root of
> Hitchin's branch invariant; forgetting the sheet squares it back to the
> sextic.

Equivalently, the three papers form one reconstruction pipeline:
\[
\begin{array}{c}
\text{deep-hole syndrome locus}\\
\downarrow\ \text{Paper I}\\
\text{Clebsch arc, conic, and \(A_5\)}\\
\downarrow\ \text{Paper II}\\
\text{unordered sheets plus }c_{\mathrm{match}}\\
\downarrow\ c_{\mathrm{match}}^2=J_0,\ w=\pm4c_{\mathrm{match}}\\
\text{Hitchin orientation torsor}\\
\downarrow\ \text{primitive transvectant / Paper III}\\
\text{Petersen harmonic channel and exact \(W_6\) cubic line}.
\end{array}
\]

This diagram is a theorem target, not a current theorem.  Its individual
arrows are proved in their owning papers, but the three interfaces are not
yet one functorial commutative diagram.  In particular it does not license
a global good-reduction theorem for the geometric incidence variety.

### Minimal closure gates

1. Freeze one \(A_5\) marking from Paper I's reconstructed hexagon through
   C651's pair module to Paper III's Clebsch coordinates.
2. Compare the primitive mod-\(11\) transvectant with C651's \(V_4\)
   intertwiner on one vector; multiplicity one then fixes the map.
3. State the result for the abstract reduced orientation algebra and the
   certified golden fibre, without claiming global geometric good
   reduction at \(11\).
4. Decide whether this belongs as a synthesis theorem in a fourth overview
   paper, or as coordinated corollaries in the three existing papers.

The first two gates are finite exact calculations.  If they pass and the
torsor comparison is constructed, the programme could have a
decoder-to-bond-order theorem: an object reconstructed from
coarse error-correction data canonically determines an arithmetic
orientation coordinate and a spherical harmonic order-parameter line.

### Red-team verdict

The candidate survives as a high-value direction, but the strongest wording
fails five present tests.

1. **Normalization is not intrinsic.**  C651 chose one invertible
   intertwiner from a three-dimensional Hom-space.  Rescaling its \(V_4\)
   component rescales the pulled-back cubic cubically.  Therefore
   \(c_{\mathrm{match}}^2=J_0\) is currently an exact coordinate identity,
   not a canonical equality.  The primitive transvectant must fix and match
   this scalar.
2. **The two cubics live on different constructions.**  A signed moment
   tensor on a finite matching quotient and a section defining an incidence
   double cover are not the same kind of object.  Equality after both are
   written as multiples of \(\sigma_3\) does not construct a morphism between
   their bases or torsors.
3. **Paper I reconstructs only up to projective and marking ambiguity.**
   Its deep-hole data recover the Clebsch class and \(A_5\), but not yet the
   specific five-point marking, factorization sheet, or characteristic-zero
   lift used by Papers II and III.
4. **The finite geometric cover has a strict trust boundary.**  Paper III's
   equation reduces abstractly modulo \(11\), and its displayed golden fibre
   is certified there, but no global good-reduction theorem identifies the
   entire reduced algebra with Hitchin's geometric incidence scheme.
5. **“Quadratic” currently names two related but distinct mechanisms.**
   Paper I uses a conic vanishing equation; Paper II uses second
   moments/Schur squares.  Calling both one degree-two stage requires a
   common reconstruction functor, not only a mnemonic.

Two additional cautions constrain the transvectant leg.  The binary
\(\operatorname{Sym}^6/\operatorname{Sym}^{12}\) lattices and Paper III's
positive-definite Euclidean harmonic lattices have not been explicitly
identified.  Also, checking the two boundary representatives does not yet
prove that the projected binary orbit closure is the same scheme as the
smooth Mukai--Umemura compactification; the extra tangent direction at the
closed orbit shows why rank alone cannot prove this.

The corrected crown target is therefore:

> Construct one marked \(A_5\)-equivariant diagram that carries Paper I's
> reconstructed Clebsch object to Paper II's signed cubic and Paper III's
> primitive transvectant/orientation algebra, proves equivariance of the
> two \(C_2\)-actions, and fixes the scalar by a universal normalization.

If that diagram exists, the \(2\)-\(3\)-\(6\) formulation becomes structural
rather than numerological.  Without it, the safe combined result is the
common cubic line plus a compelling compatible set of coordinate identities.

## `ej2`: portfolio-wide compositions

The programme-wide results snapshot exposes six substantive compositions.
They are ranked below by present evidential strength.

### 1. Integral Clebsch bridge to Paper II — Gold candidate

C651 proved that the signed \(H_3/\mathbf F_{11}\) matching tensor restricts
to \(4\sigma_3\) on the abstract Petersen four-space, but its chosen
ten-dimensional intertwiner was noncanonical and the rational Gaunt scalar
could not be reduced modulo \(11\).  The primitive third transvectant changes
that boundary:

- it is an integral covariant, not a selected solution of a finite Hom-space;
- its characteristic-zero image is the degree-six Petersen \(V_4\);
- its reduction modulo \(11\) still has rank four; and
- semisimplicity at \(11\) makes its image the unique \(A_5\) four-module.

Thus it supplies a canonical projective module bridge across
characteristics.  It does not yet identify the Paper II cubic's scalar with
the spherical Gaunt scalar.  The next exact test is to transport the C651
tensor through the primitive transvectant reduction and evaluate one
polarized entry.  The characteristic-five rank drop from four to two is a
second lead: it aligns with ramification of the golden torsor and the fused
\(q=5\) orientation phase, but that alignment is not yet a theorem.

### 2. Complete ports as local certificates of hidden geometry — proved chain

For the Clebsch \([6,3,4]_{11}\) code, one pointed radius-five coefficient
port spans \(C^\perp\), hence reconstructs the entire inner code.  Paper I
then reconstructs the Clebsch six-arc, uncovered conic, and \(A_5\) geometry
from that code.  The primitive transvectant supplies its finite Petersen
four-module and cubic line.  Therefore a single coefficient-valued repair
port determines
\[
 \text{port}\longrightarrow C^\perp\longrightarrow
 \text{Clebsch arc/conic}\longrightarrow
 \text{\(A_5\) Petersen module and cubic line}.
\]
The orientation sheet remains unordered; support-only repair data cannot do
this because its clutter is the generic complete three-uniform clutter on
five helpers.

The positive-density transfer theorem now has a stronger interpretation.
At density \(1/6\) in an asymptotically good fixed-\(\mathbf F_{11}\)
family, bounded local coefficient data carry a reconstructible icosahedral
inner geometry.  This suggests locally attestable geometric fingerprints,
block discovery, and code auditing in large concatenated codes.  No new
transfer theorem is needed; only this exact corollary and its equivalence
conventions must be written carefully.

### 3. AME--LU equivalence testing — exact reduction with a negative boundary

The Clebsch code gives a stabilizer \(\operatorname{AME}(6,11)\) state.
The AME rigidity theorem reduces its product-unitary equivalence problem
from the continuous group \(U(11)^6\) to finite local Clifford data.  The
Clebsch rigidity and Petersen/transvectant invariants can then serve as
finite prefilters or canonical forms for the underlying MDS code.

The combined algorithmic ladder is:

1. recover local Weyl axes from an \(m+1\)-party marginal;
2. restrict candidate intertwiners to local Cliffords;
3. recover or compare the underlying MDS configurations;
4. use the uncovered-conic and Petersen cubic-line fingerprints before any
   full Clifford search.

The known quantum passage erases the golden orientation: the two states are
equivalent after party permutation and admit fixed-party Fourier transport.
Accordingly, only sheet-even or unordered transvectant data can be quantum
invariants.  Searching for a cubic-sign LU invariant is ruled out by the
existing results.

### 4. Kneser spectral coordinates for arc defect — structural bridge

The Petersen space is the \(n=5\) case of the general negative eigenspace of
\(KG(n,2)\):
\[
 y\longmapsto(y_i+y_j)_{i<j},\qquad \sum_i y_i=0.
\]
The prescribed-hole arc paper independently encodes secant concurrence by
matching cliques in \(KG(k,2)\).  These are therefore two instances of the
same pair-sum spectral mechanism.  For an edge-load vector, projection to
the negative eigenspace is exactly its centered vertex-degree imbalance.
Perfect matchings have zero imbalance; incomplete or defective matching
packings create a visible component.

This suggests a spectral strengthening of the defect stability theorem:
bound \(\Delta\) below by the squared norm or support of the negative
Kneser projection.  It could prune zero/near-zero-defect searches and may
attack the remaining six-off-conic-hole stability problem.  The general
pair-sum eigenspace is already formalized in the Clebsch lane; what remains
is an inequality connecting its norm to the geometric defect ledger.

### 5. PRS catalecticants and the Mukai kernel map — shared method

The PRS classifications and C682 use the same algorithmic pattern:
\[
 \text{form or syndrome}
 \longmapsto
 \text{apolar/catalecticant operator}
 \longmapsto
 \text{kernel plane or flag}
 \longmapsto
 \text{orbit and branch data}.
\]
C682 contributes a compactification with only three orbit types and a
rank-plus-isotropy recognizer.  PRS contributes coherent polar flags,
contraction methods, splitting tests, and high-field exceptional-locus
bounds.  The most concrete cross-test is the pair of exceptional
redundancy-six nets at \(q=11\): reduce the primitive transvectant modulo
\(11\) and test whether either Hankel-kernel net lies on its
Mukai--Umemura kernel orbit.  A positive result could conceptually explain
an otherwise isolated small-field exception; a negative result would close
the tempting \(H_3\) interpretation cheaply.

Longer term, the PRS coherent-flag machinery is a plausible way to prove
that no remote rank-plus-isotropy components occur in the transvectant
locus.  Conversely, tangent-space and boundary-orbit tests from C682 may
replace some small-field PRS orbit enumeration by determinantal geometry.

### 6. Frobenius pair repair and continuation complexes — algorithmic quotient

After extending the Clebsch six-arc to \(\mathbf F_{121}\), there are exactly
\(4180\) legal conjugate-pair extensions and \(4179\) alternate repairs.
The recovered \(A_5\), Petersen module, and two square-class characters give
natural labels with which to quotient the corresponding replacement graph
before attempting connectivity or mixing computations.  Likewise, the
continuation-complex reconstruction theorem can certify when such an
abstract replacement structure still remembers its ambient plane and seed.

This is currently a search-compression proposal, not a theorem: compute the
\(A_5\)-orbit quotient, retain the \([5]\)/\([2]\) labels, and test whether
connectivity of the quotient plus stabilizer-generated fibre moves lifts to
connectivity of the full \(4180\)-vertex extension structure.

## `ej3`: other surprising combinations

### 7. Six-point Gale duality is Paper III golden conjugation — exact

Let \(A_t\) be the \(3\times6\) matrix whose columns are the ordered golden
axes
\[
 (0,t,1),(0,t,-1),(1,0,t),(-1,0,t),(t,-1,0),(-t,-1,0),
 \qquad t^2-t-1=0.
\]
An exact Gale kernel and an invertible comparison matrix are
\[
 K_t=\begin{pmatrix}
 -t&t&1&1&0&0\\
 t&-1&-t&0&1&0\\
 -1&t&t&0&0&1
 \end{pmatrix},\qquad
 H=\begin{pmatrix}t&1&-1\\0&t&t\\1&0&0\end{pmatrix}.
\]
Writing \(\bar t=1-t\), direct multiplication gives
\[
 A_tK_t^{\mathsf T}=0,\qquad HK_t=-tA_{\bar t}.
\]
Thus the Gale transform of the marked golden fibre is its Galois
conjugate with the same six-column marking and one common scalar.  In code
language,
\[
 \operatorname{row}(A_t)^\perp=\operatorname{row}(A_{\bar t}).
\]

This completes a kill test explicitly proposed but left unanswered in
C373: compute the Gale transform of the marked six-arc and decide whether
it canonically returns a golden fibre.  A bounded notes search found that
proposal and the general six-point Gale results, but no prior record of
this exact golden calculation.

Consequences:

- On this six-point locus Gale association is exactly Paper III's golden
  Galois sheet exchanger.  This is a concrete model for the
  Gale/self-association mechanism used elsewhere in the portfolio, not
  yet an identification with Paper II's global sheet involution.
- Code dualization swaps the two golden sheets: a generator matrix for
  one is a parity-check matrix for the other.
- In redundancy-three PRS reconstruction, the two-parent Gale ambiguity
  becomes literal arithmetic conjugation on the golden locus.  Unoriented
  search can use trace/norm data; choosing a parent chooses an embedding
  of \(\mathbf Q(\sqrt5)\).
- For AME/code applications this gives an exact semilinear isoduality
  test, but not by itself local-unitary or local-Clifford equivalence.

The primary certificate checks the identity over
\(\mathbf Q[t]/(t^2-t-1)\).  The independent replay checks its reduction
modulo \(11\): \(t=4\), \(\bar t=8\), and \(HK_4=7A_8\).

### 8. One \(20\to10\) orientation carrier for Papers I and III — Gold

Paper I's twenty weight-three repair supports split into two complementary
\(A_5\)-orbits of ten.  Quotienting by support complementation gives the
ten Petersen vertices.  Paper III's opposite-face axes are another
ten-point \(A_5\)-set labelled by those vertices, and its Clebsch
four-space is the Petersen \((-2)\)-eigenspace.

The exact marking test is stronger.  In the existing six-column golden
axis order, one Paper I chirality orbit is exactly the set of supports of
the twenty icosahedron faces, with opposite faces giving the same support:
\[
\begin{split}
\mathcal F=\{&014,015,023,025,034,123,124,135,245,345\}.
\end{split}
\]
The other Paper I orbit is \(\{S^c:S\in\mathcal F\}\).  If the five
synthemes \(T_0,\ldots,T_4\) are relabelled
\[
 (T_0,T_1,T_2,T_3,T_4)\longmapsto(1,5,2,4,3),
\]
the exact face-center calculation gives the Paper III labels
\[
\begin{array}{c|cccccccccc}
S&014&015&023&025&034&123&124&135&245&345\\
\hline
v(S)&v_{23}&v_{45}&v_{34}&v_{12}&v_{15}&v_{25}&v_{14}&v_{13}&v_{35}&v_{24}.
\end{array}
\]
Thus the common Petersen marking is literal icosahedral incidence, not
only an abstract \(A_5\)-set isomorphism.

There is a further exact surprise.  For each \(S\in\mathcal F\), suitable
signs on the three vertex axes in \(S\) sum to the face center \(v(S)\);
suitable signs on the three axes in \(S^c\) also sum projectively to that
same \(v(S)\).  Hence Paper I's
\[
20\ \text{supports}\longrightarrow10\ \text{complementary pairs}
\]
is exactly a two-decomposition cover of Paper III's ten face axes.

The corrected involution comparison is positive.  Golden conjugation
\(t\mapsto1-t\), equivalently the marked Gale transform, changes the
edge inner product from \(t\) to \(-\bar t=t-1\).  Its convex face-support
class is therefore \(\mathcal F^c\), not \(\mathcal F\).  Thus conjugation
sends the labeled icosahedron to its opposite and exchanges the two Paper
I support sheets under their established complement pairing.  Support
complementation, six-point Gale association, and golden Galois exchange
are the same \(C_2\)-operation on this marked support cover.

### 9. The outer-\(S_6\) \(6\to5\to10\to15\) skeleton can close the marking gap

The classical duad--syntheme--pentad geometry gives, once the degree-six
\(A_5\) action is fixed,
\[
 6\ \text{points}\longrightarrow
 5\ \text{synthemes in the \(A_5\)-fixed total}\longrightarrow
 10\ \text{pairs}\longrightarrow15\ \text{Petersen edges}.
\]
The five synthemes partition the fifteen duads of the original six labels.
This simultaneously organizes Paper I's five triangle classes and
support-pair graph, the five-label matching module used in the Paper II
interface, and Paper III's ten face axes and fifteen adjacencies.

The ingredients are classical and already occur separately in the notes,
but the new exact certificate verifies that the Paper I and Paper III
concrete labels equal this construction.  C651 already identifies Paper
II's ten-pair permutation module with the same abstract five-label module.
What remains noncanonical is its three-scalar module intertwiner and the
comparison of orientation covers, not the ten-point carrier.

### 10. Paper I is a small quadratic-recovery/cubic-orientation model

Give the face-support orbit sign \(+1\) and its complementary orbit sign
\(-1\).  For the \(0/1\) incidence vectors \(x_S\in\mathbf Q^6\), exact
enumeration gives
\[
 \sum_S\epsilon(S)x_S^{\otimes d}=0\quad(d=0,1,2),
 \qquad
 \sum_S\epsilon(S)x_S^{\otimes3}\ne0.
\]
The third tensor has entry \(\epsilon(\{i,j,k\})\) when its three indices
are distinct and zero otherwise.  Thus the two Paper I support sheets are
a strength-two trade whose first orientation detector is cubic—precisely
the quadratic-recovery/cubic-orientation pattern of Paper II, in a
twenty-block \(2\)-\((6,3,2)\) model.

This is an exact shared mechanism, not yet an equality of the two cubic
tensors: Paper I's tensor lives on the six-coordinate module, while
Paper II's signed matching tensor lives on its ten-dimensional quotient
and restricts to the Clebsch four-space.  In fact there is no nonzero
linear \(A_5\)-map from the six-point augmentation module \(V_5\) to
\(V_4\).

The obvious quadratic substitute also fails a sharp test.  Put
\[
 q_i(x)=\sum_{\{a,b\}\in T_i}x_ax_b,\qquad
 y_i=5q_i-\sum_jq_j.
\]
Then \(\sum_i y_i=0\), but on \(\sum_ax_a=0\) the tempting identity
\(\sigma_3(y)=\lambda C_{\rm support}(x)^2\) has ratios
\[
 \frac{436}{5}\quad\text{at }(-2,-2,-2,-1,-1,8),
 \qquad
 \frac{14620}{81}\quad\text{at }(-2,-2,-2,-1,0,7).
\]
So the simplest literal \(2\)-\(3\)-\(6\) factorization is false.  Any
surviving theorem must either use a different quadratic covariant or state
a relation in the larger degree-six invariant space.

### 11. Corrected \(2\)-\(3\)-\(6\) theorem modulo symmetric background

The invariant-space calculation produces a strong replacement.  On the
six-point augmentation module \(p_1=\sum_ax_a=0\), put
\[
 C(x)=\sum_{|S|=3}\epsilon(S)\prod_{a\in S}x_a,\qquad
 p_r(x)=\sum_{a=0}^5x_a^r,
\]
where \(\epsilon=+1\) on the face-support orbit and \(-1\) on its
complement.  For the synthematic-total quadratic coordinates
\[
 q_i(x)=\sum_{\{a,b\}\in T_i}x_ax_b,\qquad
 y_i=5q_i-\sum_jq_j,
\]
write \(\sigma_3(y)=\frac13\sum_i y_i^3\).  Exact interpolation gives
\[
\boxed{
375C(x)^2-12\sigma_3(y)
=6000p_6-4350p_4p_2-2125p_3^2+705p_2^3.
}
\]
Equivalently, by Newton identities,
\[
375C^2-12\sigma_3(y)
=-15\bigl(16e_2^3-80e_2e_4+75e_3^2+2400e_6\bigr),
\]
where \(e_r\) are the elementary symmetric functions of the six
coordinates.  This form isolates the remaining interpretation problem as
one explicit universal six-point invariant, rather than four unrelated
moment terms.

Both sides have degree six.  The right side is fully \(S_6\)-symmetric,
whereas each term on the left remembers the chosen outer-\(S_6\)
synthematic total.

Molien coefficients explain why this relation is forced but nontrivial:
\[
\dim\operatorname{Sym}^6(V_5)^{A_5}=7,\qquad
\dim\operatorname{Sym}^6(V_5)^{S_5}=5,
\]
and the ordinary \(S_6\)-symmetric sextics on \(p_1=0\) form the
four-space
\[
\langle p_6,\ p_4p_2,\ p_3^2,\ p_2^3\rangle.
\]
Thus the outer-even quotient by universal symmetric information is
one-dimensional, and its two nonzero classes have projective ratio
\[
[C^2]_{\rm exotic}:[\sigma_3(y)]_{\rm exotic}=4:125.
\]
The class is genuinely exotic: at
\((-2,-2,-1,-1,0,6)\), \(C^2=484\), while swapping coordinates \(0\)
and \(2\) gives \(C^2=36\).

This is the precise \(2\)-\(3\)-\(6\) composition that survived the
red-team:

1. the invariant synthematic total gives the quadratic map
   \(V_5\to V_4\);
2. the Clebsch cubic \(\sigma_3\), shared by the Paper II tensor line and
   Paper III harmonic restriction, turns it into a sextic; and
3. modulo the four universal symmetric sextics, that sextic is the square
   of Paper I's cubic support orientation.

The theorem is exact in the abstract marked characteristic-zero modules.
It does not identify the Paper II and Paper III covers, remove C651's
selected-coordinate normalization, or make the symmetric correction
vanish.  No novelty claim is made.

### 12. Outer-\(S_6\) upgrade: the unique sextic covariant

The fixed-total formula globalizes.  Let \(X\) be the natural six-set and
let \(\mathcal T\) be the six-set of synthematic totals.  The \(S_6\)
action on \(\mathcal T\) is the exceptional outer action.  Put
\[
 V=\mathbf Q^X/\mathbf Q\mathbf1,\qquad
 V^{\rm out}=\mathbf Q^{\mathcal T}/\mathbf Q\mathbf1.
\]
For each total \(T\), its stabilizer \(S_5\) has an alternating subgroup
\(A_5\), whose two orbits on three-subsets define a cubic \(C_T\) up to
sign; \(C_T^2\) is canonical.  The five synthemes in \(T\) also define
the quadratic coordinates \(q_T\) and hence the sextic
\(\Sigma_T=\sigma_3(q_T)\).

Centering the six values over \(\mathcal T\) gives two homogeneous
\(S_6\)-equivariant degree-six maps \(V\to V^{\rm out}\).  The corrected
identity is precisely
\[
\boxed{
125\,\operatorname{center}_{T\in\mathcal T}(C_T^2)
=4\,\operatorname{center}_{T\in\mathcal T}(\Sigma_T).
}
\]
Moreover, an exact character calculation gives
\[
\dim\operatorname{Hom}_{S_6}
\bigl(V^{\rm out},\operatorname{Sym}^6(V)^*\bigr)=1.
\]
Thus both constructions realize the unique outer-twisted sextic
covariant, up to scalar.  The proof averages the symmetric-sixth trace
against the outer-standard character over all \(720\) elements; the
inner product is one.  This removes the chosen \(A_5\) parent from the
statement and explains the identity representation-theoretically.

There is also an arithmetic resolvent corollary.  For six roots
\(x_0,\ldots,x_5\), the six values \(C_T(x)^2\), or equivalently the six
affinely related values \(\Sigma_T(x)\), define a degree-six resolvent
whose Galois action is the outer action on synthematic totals.  The two
apparently different constructions therefore give the same centered
outer resolvent.  Potential uses include:

- computing the outer twist of a sextic Galois action;
- testing subgroup containment through the factorization of the outer
  resolvent;
- replacing a sum over twenty oriented triples by five matching
  quadratics and one Clebsch cubic; and
- transporting arithmetic information between a sextic and its
  outer-associated resolvent.

Before literature audit this had a plausible strict Platinum shape: it is
an intrinsic \(S_6\) theorem, not a frozen icosahedral identity, and it has
an arithmetic application surface.  The audit changes that verdict
decisively.  Howard--Millson--Snowden--Vakil's six coordinates \(Z_T\)
are precisely the signed support cubics \(C_T\): they are the classical
Joubert/Segre coordinates.  Their dual coordinates are
\[
 W_T=Z_T^2-\frac16\sum_U Z_U^2,
\]
which is exactly \(\operatorname{center}(C_T^2)\), the classical
Segre-cubic--Igusa-quartic dual map.  Kraft also explains that the
outer-\(S_6\) degree-three Joubert covariant is of the lowest possible
degree and uses it for the classical sextic Tschirnhaus transformation.
Thus the unique-covariant crown and its generic resolvent interpretation
are preempted, not Platinum discoveries.

What survives is narrower but exact:
\[
125W_T=4\,\operatorname{center}_{T\in\mathcal T}
 \bigl(\sigma_3(q_T)\bigr).
\]
This expresses the classical Segre--Igusa dual coordinate by five
syntheme quadratics followed by the Clebsch cubic.  The bounded searches
below did not locate this compact formula verbatim.  That is not an
absence claim: Howard--Millson--Snowden--Vakil already give other explicit
syntheme formulas for the same \(W_T\), so conceptual novelty is limited
even if this presentation is new.

Under the user's rubric the current literature-adjusted assessment is:

- **not Platinum:** the outer-\(S_6\), Joubert-resolvent, and
  Segre--Igusa theorem is classical;
- **Gold candidate:** the compact five-syntheme/Clebsch formula, if a
  deeper formula-level audit confirms it is unpublished and if it yields
  a useful consequence; and
- **Silver-to-Gold as a bridge:** the exact identification of the three
  paper coordinate systems and the corrected marked \(C_2\).

The present identity cannot carry a strong general-journal paper by
itself.  Platinum now requires a theorem not implied by the classical
Segre--Igusa package: for example a genuinely new arithmetic algorithm
with a proved complexity or robustness advantage, a new moduli
consequence, or a nontrivial generalization beyond six points.

## Big-picture reframing: Clebsch as an exceptional junction

The right programme is not to accumulate further statements that the
Clebsch object is special.  It is to find a general functor, rank bound,
or variational problem for which Clebsch is an equality object, an
exceptional fibre, or a bridge between categories that are otherwise
unrelated.

Three standards distinguish such a theorem from a catalogue:

1. a variational principle explains why an extremum occurs;
2. extremality in two different categories is proved equivalent; or
3. a general bound is proved and Clebsch is classified as its equality
   case.

The portfolio suggests the following partial categorical square:
\[
\begin{array}{ccccc}
\text{coefficient repair port}
 &\longrightarrow& [2m,m]\text{ MDS code}
 &\dashrightarrow& \text{deep-hole/extension configuration}\\
 &&\downarrow\text{\scriptsize Gale/code duality}
 &&\downarrow\text{\scriptsize exceptional minimal-degree output}\\
 &&[2m,m]\text{ dual MDS code}
 &&\text{GRS or minimal-degree variety}\\
 &&\downarrow\text{\scriptsize equal-phase CSS}
 &&\\
 &&\text{stabilizer AME state.}&&
\end{array}
\]
Code duality is implemented on the equal-phase state by local Fourier
transform.  The complete coefficient port reconstructs an MDS code at
the critical radius, whereas its support projection remembers only the
uniform matroid.  Deep-hole directions of the dual classify legal
one-coordinate MDS extensions.  These individual arrows are standard or
already proved in the portfolio; the possible new result is a theorem
about the square's fibres, equality cases, or naturality.

### A. The deep-hole transform as an exceptional partial functor

For a projective arc \(A\), define its one-step extension port
\[
 \mathcal E(A)=\mathcal U(A).
\]
Its points are exactly the legal one-point extensions of \(A\).  Under
the code dictionary they are projective deep-hole syndrome directions,
and the standard dual formulation identifies them with MDS extensions.
Usually \(\mathcal E(A)\) is a relatively unstructured finite set.

The Clebsch row is simultaneously extremal in four different
coordinates of the complete \(q=11\) six-arc moduli set:
\[
\begin{array}{c|cc}
\text{invariant}&\text{Clebsch}&\text{every other class}\\ \hline
|\mathcal E(A)|&12&\ge16\\
|\operatorname{PStab}(A)|&60&\le12\\
\min\deg I(\mathcal E(A))&2&\ge4\\
\text{nearest-conic discrepancy}&0&\ge12.
\end{array}
\]
Moreover, the minimum extension port is not merely small: its twelve
points are the complete rational conic, hence a maximal
\([12,3,10]_{11}\) GRS configuration.  Thus Clebsch is a minimal
extension port with maximal internal MDS structure.

This motivates a general inverse problem:

> **Minimal-degree deep-hole transform problem.**  Classify MDS codes
> whose projective deep-hole/extension configuration is a rational
> normal curve, a variety of minimal degree, or another MDS
> configuration.

Paper I solves the full-conic problem through eight points in redundancy
three: only the \(q=5\) frame and \(q=11\) Clebsch hexagon occur.  The PRS
work describes higher-redundancy deep-hole strata by catalecticants,
apolarity, and splitting avoidance.  The arcs paper supplies the
prescribed-hole defect and equality machinery.  A classification beyond
the through-eight range would therefore connect three current paper
families through a single nonlinear transform rather than through the
name “Clebsch.”

The first scalable target is:

> **Conjecture E3.**  If an arc in \(\operatorname{PG}(2,q)\), for odd
> \(q\), has a complete rational conic as its one-step extension port,
> then it is the
> four-frame over \(\mathbf F_5\) or the Clebsch hexagon over
> \(\mathbf F_{11}\).

The existing theorem proves E3 only for \(4\le |A|\le8\).  A larger
example is a decisive falsifier.  A proof for all sizes is a strong
specialist/general crossover result; an arbitrary-redundancy
minimal-variety theorem would have Platinum shape.

### B. Extension--repair duality and the MDS-to-AME quotient

Let \(\mathcal M_m\) be the moduli groupoid of linear
\([2m,m,m+1]\) MDS codes with monomial equivalences, with
\(\mathcal M_{m,q}\) its \(\mathbf F_q\)-points.  Let
\(\mathcal A_m\) be the corresponding groupoid of equal-phase stabilizer
AME states with local-Clifford maps and party permutations.  There is a
functor
\[
 Q:\mathcal M_m\longrightarrow\mathcal A_m.
\]
Gale association is code duality
\[
 D:C\longmapsto C^\perp,
\]
and finite-field Fourier orthogonality gives a natural local-Clifford
identification
\[
 Q(C)\simeq Q(C^\perp).
\]
Thus \(Q\) factors through Gale orbits.  The general LU-rigidity theorem
shows that replacing local Clifford by local unitary does not create a
larger equivalence relation on stabilizer AME states.

The substantive target is not the Fourier identity but the converse:

> **Conjecture QG.**  On a dense open substack of
> \(\mathcal M_m\), the fibre of \(Q\) is exactly one monomial/Gale
> orbit.

For \(m=3\), the six-point pencil, its degree-eight invariant quotient,
the exact fixed-party local-Clifford classifications, and the residual
Gale cubic make QG testable.  The golden point has the especially sharp
identity
\[
\text{Gale duality}
=\text{golden Galois conjugation}
=\text{local Fourier equivalence}.
\]
It is therefore an arithmetic specialization of a possible general
moduli quotient, rather than merely a quantum coincidence.

The first attack on QG is to prove that, for a generic six-point MDS
code, every compatible tuple of local symplectic blocks is either
monomial or Fourier followed by monomial.  Equivalently, compare the
function field of the local-Clifford quotient with the Gale-invariant
subfield of the six-point moduli function field.  A generic
local-Clifford pair that is neither monomially nor Gale related kills the
conjecture.  QG for \(m=3\) would be Gold-to-Platinum depending on the
moduli and literature strength; a uniform theorem in \(m\) has clear
Platinum shape.

The repair-port side belongs in the same framework.  The coefficient
port functor at radius \(m\) is faithful because its affine span recovers
\(C^\perp\).  Its support-only projection factors through the uniform
matroid and loses all MDS moduli.  A useful categorical theorem should
therefore express extension and coefficient-repair data as dual links
in an MDS extension complex, not merely place two arrows in one diagram.

### C. The stable minimum-rank transvectant locus

For a nonzero binary dodecic \(I\), put
\[
 T_I:\operatorname{Sym}^6\longrightarrow\operatorname{Sym}^{12},
 \qquad p\longmapsto(p,I)_3.
\]
The rank-\(\le3\) locus is a closed \(PSL_2\)-stable projective subset.
If nonempty, the Borel fixed-point theorem forces it to contain the
highest-weight point \([X^{12}]\), but the certified boundary
calculation gives \(\operatorname{rank}T_{X^{12}}=4\).  Hence every
nonzero dodecic satisfies
\[
 \operatorname{rank}T_I\ge4.
\]
The Klein dodecic is therefore not just low-rank: it is a stable form
attaining the representation-theoretic absolute minimum.  Its entire
open \(PSL_2/A_5\) orbit, both compactification boundary types, and the
threefold tangent space at the Klein point lie in the rank-four locus.

The high-ceiling target is:

> **Conjecture TR.**  The stable rank-four locus is the icosahedral
> \(PSL_2/A_5\) orbit.  Scheme-theoretically, rank four together with
> fifth-transvectant isotropy of the kernel cuts out the
> Mukai--Umemura compactification.

TR says that the icosahedral object is the unique stable minimizer of a
natural covariant rank, while the Mukai--Umemura threefold is its
extremal compactification.  It would connect determinantal geometry,
binary invariant theory, Fano threefolds, and exact symmetry-recognition
algorithms.  The recognition algorithm is concrete: construct a
\(13\times7\) matrix, test minimum rank and kernel isotropy, and recover
the parent three-plane as its kernel.

The attack has four gates:

1. express kernel isotropy polynomially in maximal-minor/Plücker
   coordinates on the rank-four locus;
2. saturate the rank-plus-isotropy ideal and compute its dimension,
   degree, Hilbert polynomial, and irreducible components;
3. compare those invariants and boundary local rings with the known
   Mukai--Umemura compactification; and
4. perform a precise literature audit for this transvectant
   degeneracy-locus presentation.

Any stable rank-four form outside the icosahedral orbit, any remote
component surviving isotropy, or a Hilbert-polynomial mismatch kills the
strong statement.  The extra rank-only tangent direction at
\([X^{12}]\) already warns that minors alone are insufficient; it is
evidence for the role of isotropy, not evidence that TR is automatically
true.

### C resolved: transvectant reconstruction of Mukai--Umemura

The strong TR statement is true over an algebraically closed field of
characteristic zero.  Put
\[
 V=\operatorname{Sym}^6(k^2),\qquad W=\operatorname{Sym}^{12}(k^2),
\]
let \(Z\subset\operatorname{Gr}(3,V)\) be the Mukai--Umemura threefold of
three-planes isotropic for the fifth transvectant, and write
\[
 T_I:V\longrightarrow W,\qquad p\longmapsto(p,I)_3 .
\]
Then the two constructions
\[
 [I]\longmapsto\ker T_I,\qquad
 U\longmapsto
 \mathbf P\{I\in W:T_I(U)=0\}
\]
are mutually inverse isomorphisms between \(Z\) and
\[
 \mathcal R=
 \{[I]\in\mathbf P(W):
   \operatorname{rank}T_I=4,
   \ker T_I\text{ is fifth-transvectant isotropic}\}.
\]
In particular, the stable minimum-rank locus is exactly the open
icosahedral orbit, while rank four plus kernel isotropy cuts out its full
Mukai--Umemura compactification.  There are no remote components.

The proof avoids global elimination.  Over \(Z\), the universal
three-plane \(\mathcal E\) gives the bundle map
\[
 W\otimes\mathcal O_Z\longrightarrow
 \mathcal Hom(\mathcal E,W\otimes\mathcal O_Z),
 \qquad I\longmapsto T_I|_{\mathcal E}.
\]
Hitchin's orbit decomposition has exactly the open three-dimensional
orbit and boundary orbits of dimensions two and one.  On one
representative of each orbit the displayed map has rank \(12\), so its
kernel is globally a line bundle \(\mathcal L\).  Its projectivization
defines \(Z\to\mathbf P(W)\).  The Borel fixed-point lower bound already
proved above says that every nonzero \(I\) has
\(\operatorname{rank}T_I\ge4\).  Since \(T_I\) annihilates the
three-plane \(U\), it has rank at most four, hence exactly four and
\(\ker T_I=U\).  Conversely, any point of \(\mathcal R\) lies in the
one-dimensional annihilator of its kernel.  These constructions commute
with base change on the constant-rank loci, so they are inverse as
scheme-valued functors, not only on closed points.

This also identifies the map geometrically.  The standard anticanonical
orbit model is the closure of
\([1+\Phi_{12}]\) in
\(\mathbf P(\mathbf1\oplus\operatorname{Sym}^{12})\).  Projection away
from the invariant coordinate sends the open orbit to
\([\Phi_{12}]\), and the transvectant theorem supplies its regular inverse
on the boundary.  Thus the rank--isotropy model is the degree-\(22\)
non-linearly-normal projection of the anticanonical
Mukai--Umemura threefold into \(\mathbf P^{12}\).  Its Hilbert polynomial
with respect to \(-K_Z\) is
\[
 \chi(\mathcal O_Z(-nK_Z))
 =\frac{11}{3}n^3+\frac{11}{2}n^2+\frac{23}{6}n+1.
\]

The exact certificate checks all three orbit representatives.  In each
case \(T_I\) has rank four, its kernel is isotropic, and the common
annihilator of that kernel in \(W\) has dimension one.  The rank-only
affine tangent dimensions are \(4,4,5\); after adjoining the linearized
kernel-isotropy equations, all three incidence tangent dimensions are
\(4\), so the extra closed-orbit direction is removed exactly as
predicted.  A separately written replay checks the ranks and incidence
tangents modulo \(101\).

From the repository root, replay with

```text
python3 notes/2026-07-26-c682-transvectant-inverse.py --check
python3 notes/2026-07-26-c682-transvectant-inverse-replay.py
```

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-26-c682-transvectant-inverse.py` | 17413 | `32b6edb88408cbebf992d98eb740194a9cff38f2fda1eb425b087a9f50b544a8` |
| `2026-07-26-c682-transvectant-inverse-replay.py` | 9439 | `1ed5be9368b1a104c310dbffaf846cec68397e724b1c0d5b8589b3d92f3c5144` |
| `2026-07-26-c682-transvectant-inverse.json` | 8289 | `6a4dd00c551c3d50af812b6ee479ada4ee2a12b2b931f401a446a82ecd825928` |

The computation certifies the three exact fibre ranks and tangent
calculations.  The primary-source orbit decomposition, the Borel
fixed-point argument, the constant-rank bundle argument, and the
scheme-functor inverse are human proof inputs.  The result is not yet a
Paper III claim.

#### Targeted source audit

Two of the eight individually discussed sources below were read in full;
the other six were read at the stated partial depth.  This is a targeted
pre-emption check, not a priority or absence claim.

- Mukai, *Fano 3-folds*, in *Complex Projective Geometry* (1992),
  Sections 3, 6, and 7 read from the author-hosted primary PDF; cache
  SHA-256
  `92babf75e27914fab2caaebe89be6c5a56f5ae4cf5f88127bee7de9c1e48da91`.
  Theorems 3 and 11 give the net-of-skew-forms Grassmannian model and the
  polar-six-side/VSP model, while Theorem 14 identifies the double-conic
  specialization with the smooth equivariant compactification
  \(SO_3/A_5\).  This is a second classical inverse description, but it
  does not state the binary-dodecic third-transvectant kernel inverse.
- Mukai, *New developments in the theory of Fano threefolds: vector
  bundle method and moduli problem*, Sugaku 47 (1995), English
  translation in Sugaku Expositions 15 (2002), Section 5 and the
  relevant later cross-references read from the author-hosted primary
  PDF; cache SHA-256
  `66cab0cef6046a29538582355906fbe5ab8301b2bb8cf27a2d68d709c91753a1`.
  Theorem 5.4 gives the genus-\(12\) threefold \(G(3,V,N)\), and Remark
  5.6 identifies the \(\operatorname{SL}_2\)-orbit of the icosahedral
  three-space with the Mukai--Umemura compactification.  It explicitly
  triangulates the Grassmannian and homogeneous-space models, but does
  not introduce a dodecic or a transvectant reconstruction.
- Mukai, handwritten notes *Uniruledness of \(M_{11}\), and prime Fano
  3-folds \(V_{22}\) of genus 12* (February 2021), all eight pages read
  from the author-hosted primary PDF; cache SHA-256
  `0308167c39d61e6704128445018c79f9ffe4978c1847b6030492c3795023809b`.
  The notes concern last linear sections, poristic neighbours, and four
  one-nodal degeneration divisors; they do not discuss the
  Mukai--Umemura dodecic or the transvectant map.
- Mukai, *Moduli of abelian surfaces, and regular polyhedral groups*
  (2003), all five pages read from the author-hosted primary PDF; cache
  SHA-256
  `9619d4bfa81b3b936ddcb69b564656f5eca1e5f5ebf18e51d3ebd400eb5c9096`.
  It uses the icosahedral subgroup \(A_5\subset PGL_2\) and cites
  *Minimal rational threefolds*, but its compactification is a blow-up
  of \(\mathbf P^3\) for abelian-surface moduli, not the genus-\(12\)
  transvectant model.

- Hitchin, *Vector bundles and the icosahedron*, arXiv:0906.4208,
  Sections 4--6 read from the cached primary PDF, especially the
  Grassmannian definition and the three-orbit decomposition; cache
  SHA-256
  `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
  It supplies the isotropic-plane model but does not state the
  third-transvectant inverse.
- Cheltsov--Shramov, *Extremal metrics on del Pezzo threefolds*,
  arXiv:0810.1924v3, Section 5 read from the cached primary preprint;
  cache SHA-256
  `fb189cfd9236acb7e84f2a565e955e9d9ab64afad235c85852b12e9665112ad0`.
  It records the anticanonical
  \([1+\Phi_{12}]\) orbit model and the same three boundary types, but
  not the kernel map.
- Chung--Kim--Kim, *Rational quartic curves in the Mukai--Umemura
  variety*, arXiv:2412.17721, Sections 3.1 and 3.3 read from the cached
  primary preprint; cache SHA-256
  `15acc2562ecda2ab6f1b2f1070d42245205985fc1f88d6ac6649e2918411881d`.
  Its explicit \(\operatorname{SL}_2\)-equivariant Grassmannian model
  contains no dodecic transvectant reconstruction.
- Ito--Kanemitsu--Takamatsu--Tanaka, *Fano threefolds of genus 12 with
  large automorphism group in positive and mixed characteristic*,
  arXiv:2601.10106, Section 5.1 read from the cached primary preprint;
  cache SHA-256
  `0e2caea7c0eaf78f2105fc796a8d302443b1af337e9f7dbda24b4572f43af788`.
  Its existence/classification theorem in characteristics other than
  \(2,5\) is adjacent arithmetic context, not the characteristic-zero
  transvectant inverse.

The exact web queries were `"third transvectant" "Mukai-Umemura"`,
`"Klein dodecic" transvectant kernel`,
`"Mukai-Umemura" binary dodecic Grassmannian transvectant`,
`site:arxiv.org Mukai Umemura transvectant binary form Symmetric 12`,
`"(p,I)_3" binary forms`,
`"kernel" "third transvectant" binary sextic dodecic`,
`"rank four" transvectant dodecic`, and
`"rank 4" "transvectant" "icosahedral"`.  The first result page for
each and exact-text searches within the two recent primary preprints
located no occurrence of the inverse formula.  Mukai--Umemura's 1983
paper, DOI `10.1007/BFb0099976`, was not cached and its full text was not
reachable in this pass; MathSciNet, zbMATH, and Google Scholar were not
covered.  Therefore the audit licenses only “not located in this bounded
pass,” not a novelty claim.

### D. Orientation index and Gorenstein extremality

For a signed two-sheet configuration \((X,\epsilon)\), define its
orientation index
\[
 \operatorname{ori}(X,\epsilon)
 =\min\{d:\sum_{x\in X}\epsilon_x\,x^{\otimes d}\ne0\}.
\]
Papers I and II both have orientation index three: first and second
moments recover only the unordered sheets, while the cubic is the first
signed detector.  In Paper II, self-association, Cayley--Bacharach, and
the arithmetically Gorenstein Hilbert function explain why the cubic
must survive.

The general target is to identify the orientation index with a
canonical-module or socle-degree invariant and prove a sharp upper bound
in terms of the Hilbert function.  Equality cases would classify
configurations whose hidden bit survives the maximum number of low-order
moments.  This would connect the Clebsch examples to design trades,
higher-order correlation recovery, and bispectral algorithms.  It is a
Gold direction now; it becomes Platinum only with a sharp general bound
and a meaningful equality classification.

### E. A correspondence object rather than a shared representation

The six points, ten complementary triple pairs/face axes, and fifteen
synthemes form finite \(A_5\)-sets and correspondences.  On the ten-set,
the Petersen adjacency algebra has the canonical projector
\[
 e_4=\frac{(A-3I)(A-I)}{15}
\]
onto the Clebsch four-space \(V_4\).  Paper I, Paper II, and Paper III
give finite-code, matching-tensor, and harmonic/transvectant
realizations of this summand.

This becomes a genuine categorical bridge only after constructing:

1. a correspondence object over an explicit integral localization;
2. realization functors into the finite-code, matching, and harmonic
   categories;
3. a normalized natural transformation, plausibly the primitive
   transvectant, between two realizations; and
4. preservation of the cubic line.

Without those four items, “Clebsch motive” or “Morita bridge” would be
decorative language for a shared irreducible representation.  This track
should follow rather than precede TR or QG, because either successful
theorem would supply the required natural map and normalization.

### Literature-adjusted priority

1. **TR, stable minimum-rank transvectant classification:** proved over
   characteristic zero; this is the present mathematical crown, pending
   a deeper priority audit before manuscript promotion.
2. **QG, the MDS-to-AME generic Gale quotient:** broadest remaining categorical
   Platinum target.
3. **E3 and its higher-redundancy analogue:** strongest connection among
   Paper I, PRS, arcs, and code extensions.
4. **Orientation-index theorem:** reusable Gold mechanism with a possible
   higher ceiling.
5. **The \(q=11\) multi-extremal equivalence:** strong specialist theorem
   and finite laboratory for the preceding conjectures.
6. **Integral correspondence category:** synthesis only after a
   canonical natural transformation is earned.

The red-team boundary is strict.  Deep holes versus MDS extensions,
Fourier versus code duality, outer \(S_6\), and Segre--Igusa duality are
already classical or standard.  New content must be a fibre theorem, a
sharp extremal classification, a global degeneracy-locus theorem, or a
commuting categorical square with a universal property.

### Highest-EV cross-paper actions

1. **TR promotion gate:** deepen the priority audit, compare the
   transvectant projection with Mukai--Umemura's original construction,
   and decide the cleanest theorem owner.
2. **TR arithmetic gate:** determine whether the inverse extends over
   \(\mathbf Z[1/10]\), explaining the characteristic-\(5\) rank drop and
   the separate characteristic-\(2\) obstruction.
3. **QG \(m=3\) gate:** derive the generic local-symplectic compatibility
   equations and test whether their only components are monomial and
   Fourier--monomial.
4. **QG quotient gate:** compare the six-point local-Clifford quotient
   function field with the Gale-invariant moduli function field.
5. **E3 extension gate:** turn the existing conic-cover inequalities,
   passant-code constraints, and matching-design defect into an
   all-\(k\) sieve; search the remaining parameter window before claiming
   a proof route.
6. **Orientation gate:** state and prove the precise
   canonical-module/signed-moment lemma for a general self-associated
   arithmetically Gorenstein configuration.
7. **Finite multi-extremal theorem:** add legal-extension minimality and
   maximal party-permutation symmetry to the existing \(q=11\)
   equivalence, while keeping the computational gaps explicit.
8. **Supporting normalization:** contract the C651 tensor through the
   primitive mod-\(11\) transvectant only if TR or the correspondence
   track needs the scalar.
9. **Deferred formula work:** compare the compact
   five-syntheme/Clebsch formula with classical \(W_T\) expansions, but do
   not let this displace the general theorem tracks.

The attack order is deliberately falsifier-first: run Tasks 2 and 3
before expensive global ideal or quotient calculations, then promote at
most one of TR and QG to the main Platinum programme.  E3 and the
orientation-index theorem remain independent Gold routes if both
Platinum conjectures fail.

## Source-depth boundary

No novelty or absence claim is made.  The structural comparison used two
cached primary sources at partial full-text depth:

- Nigel Hitchin, *Spherical harmonics and the icosahedron*,
  arXiv:0706.0088, Sections 2--6 and the Mukai compactification discussion;
  cached PDF SHA-256
  `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
- Nigel Hitchin, *Vector bundles and the icosahedron*,
  arXiv:0906.4208, Sections 4--8 on the Grassmannian
  Mukai--Umemura model, its open \(SO_3/A_5\) orbit, and the Clebsch
  four-space; cached PDF SHA-256
  `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.

These sources justify the Grassmannian model and the parent-plane
interpretation.  A manuscript-promotion audit must still locate the
standard Klein-dodecic orbit model and search specifically for the
third-transvectant kernel map.

The degree-six priority audit additionally used:

- Benjamin Howard, John Millson, Andrew Snowden, and Ravi Vakil,
  *A description of the outer automorphism of \(S_6\), and the invariants
  of six points in projective space*, arXiv:0710.5916, all eight pages
  read from the cached primary PDF, especially Sections 1.2--1.5 and
  2.1--2.3; cached SHA-256
  `d2da0953c0b08206613719bca4f45a90aeb52c474339f18ac51f04408ae9387b`.
  This source identifies the six colorings/pentads, opposite
  icosahedra, the Joubert/Segre coordinates \(Z_T\), their cubic
  relation, and the centered-square dual coordinates \(W_T\).
- Hanspeter Kraft, *A Result of Hermite and Equations of Degree 5 and
  6*, arXiv:math/0403323, abstract, Sections 1--3, and all of Section 5
  read in the primary arXiv HTML rendering.  Theorem B, Remark 3, and
  the two proofs in Section 5 establish the classical outer-\(S_6\)
  covariant and its minimal degree.
- Howard--Millson--Snowden--Vakil, *The relations among invariants of
  points on the projective line*, primary author-hosted PDF, introduction
  and the Segre/Igusa/Gale discussion at partial full-text depth.  It
  records the Joubert--Coble provenance of the coordinates and the
  classical outer action.

The bounded formula search used the queries `"sigma_3" synthemes Igusa
quartic`, `"Clebsch cubic" "Igusa quartic"`, `"five synthemes" quadratic
map`, `"synthematic total" "Igusa quartic" covariant`, and
`"Z_T^2" "Igusa" syntheme`, stopping after the primary sources above and
the first result page for each exact query produced no direct occurrence
of the compact identity.  This supports only “not located in this
bounded audit,” not novelty or absence.

The big-picture extension/quantum scout additionally used title and
abstract depth only:

- Yansheng Wu, Cunsheng Ding, and Tingfang Chen, *Extended codes and deep
  holes of MDS codes*, arXiv:2312.05534.  Its main theorem explicitly
  relates deep holes of a dual MDS code to one-coordinate MDS extensions.
- Yang Li, Zhenliang Lu, San Ling, and Kwok-Yan Lam, *A framework for
  constructing non-GRS MDS-NMDS codes from deep holes and its
  application*, arXiv:2605.12133.  This confirms that construction of
  non-GRS MDS objects from deep holes is an active direction; it was not
  read deeply enough to compare the inverse/minimal-degree problem.
- David Joyner, Amy Ksir, and Will Traves, *Automorphism groups of
  generalized Reed--Solomon codes*, arXiv:0801.4007.  This supplies an
  initial source boundary for large automorphism groups on the GRS side,
  not a classification of the non-GRS Clebsch extremum.

Queries included `Gale duality stabilizer states Fourier transform MDS
code AME`, `deep hole syndrome locus MDS code rational normal curve
reconstruction`, `automorphism groups six arcs PG(2,q) MDS codes A5`,
and `moduli MDS codes Gale duality stabilizer AME states`.  The returned
results did not locate the proposed generic-fibre theorem QG or the
minimal-degree transform problem E3, but this was a first-page scout, not
an absence audit.  TR requires its own primary-source search before any
novelty assessment.

## Cheap structural corollary: the descended chart is a Ferrand pinch

The completed local ring already recorded for the descended union has the
intrinsic form
\[
 R=\mathbf Q+\mathfrak m
 \subset S=\mathbf Q(\sqrt5)[[x_1,x_2,x_3]],
 \qquad \mathfrak m=(x_1,x_2,x_3).
\]
Thus the descended union is locally the pinching of the
\(\mathbf Q(\sqrt5)\)-point of its normalization to a rational point.  The
normalization/conductor square recovers the quadratic algebra without a
choice of generators:
\[
 S/R\simeq\mathbf Q(\sqrt5)/\mathbf Q,\qquad
 \mathfrak c=\mathfrak m.
\]
It also gives immediate singularity invariants.  The maximal ideal of
\(R\) is \(\mathfrak m\), with
\(\mathfrak m_R^n=\mathfrak m_S^n\), so the embedding dimension is six,
the multiplicity is two, and
\[
 H_R(t)=1+2\sum_{n\ge1}\binom{n+2}{2}t^n
       =\frac{1+3t-3t^2+t^3}{(1-t)^3}.
\]
The normalization exact sequence has finite-length cokernel
\(\mathbf Q(\sqrt5)/\mathbf Q\), whence
\(H^1_{\mathfrak m}(R)\simeq\mathbf Q(\sqrt5)/\mathbf Q\) and
\(\operatorname{depth}R=1\).  The three-dimensional singularity is
therefore not Cohen--Macaulay.  This is a reusable intrinsic reformulation,
but it is Silver rather than the main C682 bridge.

## Current conjectural arithmetic refinement

Let \(I_t\) and \(I_{1-t}\) be invariant harmonics for the two golden
parents.  The rational Clebsch--Gordan tensor produces conjugate maps
\(T_{I_t}\) and \(T_{I_{1-t}}\).  Their unordered pair should descend over
\(\mathbf Q\), while either map separately should have field of definition
\(\mathbf Q(\sqrt5)\).  If the invariant lines are verified to be distinct
in the paper's exact Euclidean model, injectivity of \(I\mapsto T_I\)
shows that this operator pair carries the same quadratic descent class as
the parent torsor.  This would package the arithmetic and harmonic halves
in one covariant without asserting a parent-independent ambient map.

## `ej` + `tt` interim closeout

The free upgrade was to linearize the determinantal condition.  It converts
the rank-four observation from a pointwise coincidence into a local
geometric statement: the projective rank locus is smooth of dimension
three at the Klein point, and the Mukai--Umemura closure is its local
component there.

The Tao-style audit separates three assertions that could otherwise be
blurred:

1. the third-transvectant kernel identifies the two open
   \(PSL_2/A_5\) orbits;
2. the rank locus and the Mukai--Umemura closure agree locally at the
   Klein point; but
3. neither fact proves global equality, excludes remote determinantal
   components, or extends the kernel map across every boundary point.

The next decisive calculation should therefore analyze boundary orbit
representatives and the saturated ideal of the rank-plus-isotropy locus,
not collect more generic examples.  On the algorithmic side, exact rank
and isotropy are certificates; singular-value heuristics under noise are
only proposed experiments until a perturbation theorem supplies a gap.

The latest `ej` pass closes the algebraic degree-six mystery rather than
merely cataloguing two invariants.  Character theory gives dimensions
\(7\supset5\supset4\) for \(A_5\)-invariants, outer-\(S_5\)-even
invariants, and ordinary \(S_6\)-symmetric invariants.  The one-dimensional
outer-even/symmetric quotient forces the corrected relation in
Section 11 once the exact projective ratio \(4:125\) is known.

The literature audit supplies the missing interpretation: centering is
the passage from affine squared Joubert coordinates to the outer
augmentation representation, and the resulting coordinate is the
classical Segre--Igusa dual coordinate \(W_T\).  Thus the four symmetric
correction terms are the ordinary-coordinate expression of a universal
translation term, not evidence for a new cover.  The genuinely
paper-specific content is the alternate five-syntheme/Clebsch formula.

The post-TR `ej` + `tt` pass adds two cheap structural consequences and
fixes one tempting overreach.

First, the inverse theorem identifies the rank--isotropy construction with
the linear projection of the standard anticanonical
\([1+\Phi_{12}]\)-model from its invariant coordinate.  This gives the
degree \(22\) and Hilbert polynomial without an elimination or a separate
image calculation.  It also explains the earlier tangent data: the
closed-orbit rank locus has one spurious infinitesimal direction, and the
linearized isotropy equations remove exactly that direction.

Second, the arithmetic continuation is not a free reduction of the
characteristic-zero matrices.  After dividing the universal third-
transvectant tensor by its integral content \(240\), the three
characteristic-zero orbit representatives retain the uniform
\((4,12)\) transvectant/annihilator ranks only from characteristic \(13\)
on in the bounded prime test.  At \(5\) all three rows become \((2,10)\);
at \(7\) the boundary annihilators have rank \(11\); and at \(11\) the
displayed Klein form degenerates under ordinary derivatives.  The latter
does not contradict the existing primitive mod-\(11\) bridge, which
normalizes the individual Klein matrix rather than a universal bilinear
tensor.  It shows that a genuine arithmetic theorem needs divided-power
or Weyl-module transvectants and the correct modular orbit
representatives.  The recent existence theorem for Mukai--Umemura
varieties has bad characteristics exactly \(2,5\), but the present
ordinary-derivative lattice does not yet recover that sharp boundary.

The Tao-style conclusion is that the global characteristic-zero inverse,
not a large determinantal ideal, is the conceptual endpoint of TR.
Further elimination would merely rederive the image equations.  The
highest-value continuations are now a source-deep priority audit and a
divided-power arithmetic model; QG remains the independent Platinum track.

## Beyond the threefold: the transvectant-isotropic ladder

The global inverse is not merely a second equation for one exceptional
threefold.  It exposes a small representation-theoretic mechanism that both
recovers the quintic del Pezzo threefold and continues to higher-dimensional
Fano varieties.

Let \(U_m=\operatorname{Sym}^m(k^2)\), let \(r\leq m\) be odd, and let
\[
 \beta_{m,r}\colon\bigwedge^2U_m\longrightarrow U_{2m-2r},
 \qquad(p\wedge q)\longmapsto(p,q)_r
\]
be the odd transvectant projection.  Define
\[
 X_{m,r}=\{E\in\operatorname{Gr}(2,U_m):
                \beta_{m,r}(\bigwedge^2E)=0\}.
\]
This is the linear section of \(\operatorname{Gr}(2,m+1)\) by the
\(2m-2r+1\) Plücker hyperplanes belonging to
\(U_{2m-2r}^{\vee}\).  Whenever the section has the expected dimension,
\[
 \dim X_{m,r}=2r-3,\qquad
 -K_{X_{m,r}}=(2r-m)H.                 \tag{16.1}
\]
Thus \(r\leq m<2r\) is the positive-index range.

There are two uniform smooth rows.  If \(m=r\), the top transvectant is a
nondegenerate alternating scalar pairing and
\[
 X_{r,r}=\operatorname{IGr}(2,r+1),
\]
of dimension \(2r-3\) and index \(r\).  If \(m=r+1\), then
\(X_{r+1,r}\) is the codimension-three
\(\operatorname{SL}_2\)-invariant linear section of
\(\operatorname{Gr}(2,r+2)\), of the same dimension and index \(r-1\).
It is smooth: the unique Borel-fixed plane
\(\langle x^m,x^{m-1}y\rangle\) has the expected tangent dimension, and
any nonempty closed invariant singular locus would contain that point.
This gives an infinite higher-dimensional Fano series.  Its first two
members at \(r=3\) are
\[
 X_{3,3}=Q^3,\qquad X_{4,3}=V_5.
\]

The other positive-index members of the rank-two series fail already at
the Borel point.  Exact linearization gives
\[
 \dim T_{[\,\langle x^m,x^{m-1}y\rangle\,]}X_{m,r}
 =2r-3+\max(0,m-r-1).                 \tag{16.2}
\]
In particular, the tempting next member
\(X_{5,3}\), a five-hyperplane section of
\(\operatorname{Gr}(2,6)\) with the numerical invariants of a genus-eight
Fano threefold, has tangent dimension \(4\), not \(3\), at its Borel
point.  The ladder therefore predicts its own nontransverse near-miss
instead of manufacturing a spurious smooth \(V_{14}\).

More generally, for a \(k\)-plane annihilated by one alternating
transvectant with output dimension \(a=2m-2r+1\), the expected dimension
and index are
\[
 k(m+1-k)-\binom{k}{2}a,\qquad
 m+1-(k-1)a.                          \tag{16.3}
\]
Solving “expected dimension \(3\), positive index” in characteristic zero
leaves exactly
\[
 (m,k,r)=(3,2,3),(4,2,3),(5,2,3),(6,3,5).
\]
The first two are \(Q^3\) and \(V_5\), the third is the nontransverse
genus-eight near-miss above, and the fourth is the Mukai--Umemura
threefold.  Hence, within this single-transvectant ansatz, the smooth
threefold outputs are exactly
\[
 Q^3,\quad V_5,\quad U_{22}.
\]
This is the cleanest mathematical sense in which the Mukai--Umemura
construction belongs to a structure larger than their classification.

### The lower kernel inverse on \(V_5\)

The \(V_5\) row carries a literal lower-degree analogue of the dodecic
inverse.  Put
\[
 I_6=xy(x^4-y^4)\in U_6,\qquad
 T^{(2)}_I\colon U_4\longrightarrow U_6,\quad
 p\longmapsto(p,I)_2.
\]
At the octahedral sextic,
\[
 \operatorname{rank}T^{(2)}_{I_6}=3,\qquad
 \ker T^{(2)}_{I_6}
 =\langle x^2y^2,\ x^4+y^4\rangle,
\]
and the two kernel generators have zero third transvectant.  On the open,
surface, and closed-curve orbit representatives \(I_6\),
\(x^5y\), and \(x^6\), respectively, the operator rank is uniformly
\(3\), while the common-annihilator map from \(U_6\) has rank uniformly
\(6\).  Thus its annihilator is a line on every orbit.

The standard representation decomposition
\[
 \bigwedge^2U_4=U_6\oplus U_2
\]
identifies the third-isotropic Grassmannian section with
\[
 V_5=\operatorname{Gr}(2,U_4)\cap\mathbf P(U_6)
    =\overline{\operatorname{SL}_2\cdot[I_6]}
       \subset\mathbf P(U_6).
\]
Consequently the second-transvectant kernel and common-annihilator-line
constructions are inverse on \(V_5\), including its boundary.  This is
the \(V_5\) version of the \(U_{22}\) theorem, with the sequence
\[
 (\deg I,\dim\ker,r_{\rm operator},r_{\rm isotropy})
 =(6,2,2,3)\quad\leadsto\quad(12,3,3,5).
\]
The recent explicit comparison of the Plücker and sextic orbit
coordinates in Chung--Kim--Kim makes the ambient linear identification
primary-source visible; the compact transvectant formulation above is
an exact reformulation and should not yet be advertised as new.

The exact audit is
`notes/2026-07-26-c682-transvectant-ladder.py`.  It independently checks
the three \(V_5\) operator/annihilator rows, the four positive-index
threefold balances, and formulas (16.1)--(16.2) through order \(11\).
The artifact has 10138 bytes and SHA-256
`fdbd6a0016f49c9d88a77c696a6b39771a37763e4f895d169e15280032f425b4`.
Replay with

```text
python3 notes/2026-07-26-c682-transvectant-ladder.py
```

The strongest beyond-threefold research directions are now:

1. classify all transvectant-isotropic Grassmannians with a
   constant-rank annihilator-line inverse, rather than merely all their
   dimension balances;
2. study the smooth higher-dimensional series \(X_{r,r}\) and
   \(X_{r+1,r}\), especially their derived categories and rational-curve
   spaces;
3. express the Sarkisov link \(V_{22}\dashrightarrow V_5\) directly
   between the two kernel transforms.  This is timely because
   Chung--Kim's 2026 construction sends the Hilbert scheme of rational
   quartics on \(V_{22}\) generically two-to-one to
   \(\operatorname{Sym}^4\mathbf P^1\cong\mathbf P^4\), while the
   corresponding \(V_5\) Hilbert scheme is already a
   \(\operatorname{Gr}(3,5)\)-bundle over \(\mathbf P^2\).

The last item is the highest-EV route genuinely beyond the varieties
themselves: the kernel coordinates may make the double cover and its
branch divisor invariant-theoretic.

Source depth for this continuation is partial primary full text, not a
priority audit.  Chung--Kim--Kim, *Quartic curves in the quintic del Pezzo
threefold*, arXiv:2505.09130v2, Introduction and Section 2.1 were read
from the TeX source and cached PDF; PDF SHA-256
`1468a90a5ef4d39f7fa90ce5d216e761124b3d6561c637b9afe493a57cb8ee87`.
That section explicitly gives both
\(V_5=\operatorname{Gr}(2,U_4)\cap\mathbf P(U_6)\) and
\(\overline{SL_2\cdot[xy(x^4-y^4)]}\), together with their coordinate
change.  Chung--Kim, *A remark on rational quartic curves in prime Fano
threefolds of degree 22*, arXiv:2606.18102, Introduction, Theorem 1.1,
and Sections 2.1--2.2 were read from the primary HTML/PDF; PDF SHA-256
`b0741c142c4f6613350817fb81df12916f4ff1e79b54cdc4c52d6a562859472f`.
It supplies the \(V_{22}\dashrightarrow V_5\) Sarkisov/Hilbert-scheme
context, not a transvectant comparison.

The `tt` stress test is deliberately restrictive.  The dimension/index
ladder is a useful organizing theorem, but by itself is Gold exposition,
not a Platinum paper: the \(V_5\) coordinate correspondence is classical,
and the higher-dimensional rows are special linear sections whose basic
geometry may already be implicit in representation-theoretic
Grassmannian literature.  A genuinely new theorem must add either a
classification of constant-rank kernel inverses or a concrete consequence
for the \(V_{22}\)--\(V_5\) Sarkisov/Hilbert-scheme correspondence.  No
novelty claim is made for the ladder in the present bounded pass.

## 17. A pointed kernel formula for the \(V_{22}\dashrightarrow V_5\) link

The high target is now precise.  It is not merely another description of
the two Fano threefolds, and it is not the already known abstract
functoriality of double projection.  It is a base-change-compatible
formula for the *pointed* rational map
\[
 (X^{\rm MU},L_\lambda)\dashrightarrow
 (V_5,\Gamma_\lambda)
 \tag{17.1}
\]
directly in the dodecic and sextic kernel coordinates, followed by an
explicit lift to their tautological bundles and rational-curve spaces.

### What the primary sources already give

Kuznetsov--Prokhorov--Shramov, arXiv:1605.02010,
Theorem 5.2.2, Remark 5.2.4, Lemma 5.2.5, and Remark 5.2.6, prove that
double projection from a line \(L\subset V_{22}\) is a Sarkisov link to
\(V_5\), centered on a normal rational quintic \(\Gamma\), and that the
construction is functorial for isomorphisms of pairs.  In their
binary-sextic model they also identify the Mukai--Umemura center as
\[
 \Gamma_x=\{[\,x(sx+ty)^5\,]:(s:t)\in\mathbf P^1\}\subset V_5,
 \tag{17.2}
\]
with unique bisecant \(L_{x^2}=\mathbf P(x^5U)\).  Equivariance therefore
gives, for every \([\lambda]\in\mathbf P(U)\),
\[
 \Gamma_\lambda
 =\{[\lambda m^5]:[m]\in\mathbf P(U)\},\qquad
 \langle\Gamma_\lambda\rangle
 =\mathbf P(\lambda\operatorname{Sym}^5U),\qquad
 B_\lambda=\mathbf P(\lambda^5U).
 \tag{17.3}
\]
The apolar normal of the hyperplane in (17.3) is
\([\lambda^6]\in\mathbf P(\operatorname{Sym}^6U)^*\).

Chung--Kim, arXiv:2606.18102, Sections 2.2--3, then use this link to
construct the generically two-to-one rational map
\(\mathcal H_4(V_{22})\dashrightarrow\operatorname{Sym}^4\Gamma\).
Neither source, in the portions checked, writes the pointwise link as a
transvectant between the two kernel models.  Thus (17.2)--(17.3) and the
abstract word “functorial” are prior art; the candidate contribution is
the explicit natural transformation below and what it does to bundles
and the quartic double cover.

### The linear covariant

Use ordinary-derivative transvectants and normalize the sixth
transvectant by
\[
 \langle x^6y^6,x^6\rangle_6=x^6.
\]
Write the anticanonical Mukai--Umemura model as
\[
 X^{\rm MU}
 =\overline{\operatorname{SL}_2\cdot[\Phi_{12}:1]}
 \subset\mathbf P(U_{12}\oplus U_0),
 \qquad
 \Phi_{12}=xy(x^{10}+11x^5y^5-y^{10}).
\]
For a line parameter \([\lambda]\in\mathbf P(U)\), define
\[
 F_\lambda([I:z])
 =
 \big[
   \langle I,\lambda^6\rangle_6-11z\lambda^6
 \big]\in\mathbf P(U_6).
 \tag{17.4}
\]
Before the invariant coordinate was included, the sole covariant
\(\langle I,\lambda^6\rangle_6\) failed the \(V_5\) rank test.  The
coefficient \(-11\) is forced by cancellation of the middle term of the
Klein dodecic.  In the unnormalized derivative convention of the exact
audit, (17.4) is
\[
 (I,\lambda^6)_6-5\,702\,400\,z\lambda^6.
\]
Moreover, this is the entire lowest-bidegree pencil:
\(U_6\) occurs with multiplicity one in \(U_{12}\otimes U_6\), and the
identity is the unique map \(U_0\otimes U_6\to U_6\).  Thus every
\(\operatorname{SL}_2\)-covariant map linear in \((I,z)\) and sextic in
\(\lambda\) is a linear combination of the two terms in (17.4); the
Klein cancellation fixes their ratio.  The formula is therefore
canonical at its first possible bidegree, not the output of a broad
coefficient search.

The following statements are now exact:

1. \(F_\lambda(X^{\rm MU})\subset V_5\).  On the dense determinant-one
   chart
   \[
   g=\begin{pmatrix}a&b\\c&(1+bc)/a\end{pmatrix}
   \]
   a symbolic Laurent-polynomial calculation gives
   \[
   (F_x(g\Phi_{12},1),F_x(g\Phi_{12},1))_4=0.
   \tag{17.5}
   \]
   These are exactly the five \(U_4\)-valued quadratic equations of the
   sextic \(V_5\) model.

2. The image is three-dimensional.  At \(a=b=c=1\), the value of (17.4)
   together with its three parameter derivatives has rank four in
   \(U_6\).  Hence (17.4) is dominant onto \(V_5\).

3. The projection center contains the selected source line
   \[
   L_\lambda=\mathbf P(\lambda^{11}U)\subset X^{\rm MU}.
   \tag{17.6}
   \]
   At \(\lambda=x\), both \(x^{12}\) and \(x^{11}y\) are killed by
   contraction with \(x^6\).
   More precisely, its ambient projective center is the explicit
   six-plane
   \[
   \Pi_x=
   \mathbf P\!\left(
     \langle(x^{12-i}y^i,0):0\leq i\leq5\rangle
     \oplus\langle(11x^6y^6,1)\rangle
   \right).
   \tag{17.6a}
   \]

4. The vanishing has the correct transverse order two.  The
   one-parameter degeneration
   \[
   [I_u:z_u]
   =
   [x^{11}y+11u\,x^6y^6-u^2xy^{11}:u]
   \longrightarrow[x^{11}y:0]\in L_x
   \]
   satisfies
   \[
   F_x(I_u,z_u)=-462u^2xy^5
   \tag{17.7}
   \]
   in the normalized convention.  Varying the other boundary-normal
   parameter in \(y(x+vy)^{11}\) starts only in order \(v^5\).

5. On the lower-Borel orbit the map contracts the expected surface to
   the expected quintic:
   \[
   F_x(g[\Phi_{12}:1])
   \sim x(acx+y)^5\in\Gamma_x
   \qquad(b=0).
   \tag{17.8}
   \]

Together, (17.5)--(17.8) identify (17.4) very tightly with double
projection from \(L_\lambda\).  The following scheme-theoretic argument
closes the identification and also corrects the entering expectation for
the base ideal.

### The pointed kernel Sarkisov graph

Let \(H=\mathcal O_{X^{\rm MU}}(1)=-K_X\), and let
\(\mathfrak b_\lambda\subset\mathcal O_X\) be the base ideal generated by
the seven coordinates of \(F_\lambda\).

First, the ambient center \(\Pi_\lambda\) is the linear span of the first
infinitesimal neighborhood \(L_\lambda^{(1)}\subset X\).  It is enough by
equivariance to take \(\lambda=x\).  At
\([x^{11}y:0]\), the affine tangent cone is spanned by
\[
 (x^{11}y,0),\quad (x^{12},0),\quad (x^{10}y^2,0),
 \quad (11x^6y^6,1).
\]
The last vector is the derivative of the \(u\)-family in (17.7), and the
first three are the orbit directions.  All four lie in \(\Pi_x\).
The stabilizer of \(x\) carries these tangent spaces along the open orbit
of \(L_x\), and the condition persists at the closed endpoint because
\(T_X|_{L_x}\) is a vector bundle.  Conversely, the stabilizer translates
of \((11x^6y^6,1)\) span
\[
 \langle(x^{12-i}y^i,0):0\le i\le5\rangle
 \oplus\langle(11x^6y^6,1)\rangle.
\]
Thus their span is exactly the seven-dimensional affine cone over
\(\Pi_x\), not a proper subspace.

It follows scheme-theoretically that
\[
 F_\lambda^*(U_6^*)
 =H^0\!\left(X,\mathcal I_{L_\lambda}^2(H)\right).
 \tag{17.8a}
\]
Indeed, an ambient linear form vanishes on \(L^{(1)}\) exactly when its
restriction and first normal jet vanish along \(L\).  Therefore (17.4) is
the complete double-projection system \(|H-2L_\lambda|\), not merely a
dominant map with the same reduced exceptional image.

Kuznetsov--Prokhorov--Shramov, Theorem 5.2.2 and Proposition 5.4.3,
identify this complete linear system with the Sarkisov link
\[
 X\ \xleftarrow{\ \sigma_X\ }\ X'
 \dashrightarrow
 Y'\ \xrightarrow{\ \sigma_Y\ }\ V_5,
 \tag{17.8b}
\]
where \(\sigma_X\) blows up \(L_\lambda\), \(\sigma_Y\) blows up
\(\Gamma_\lambda\), and the middle map is the unique flop.  Their
Proposition 5.4.3 also proves that \(L_\lambda\) is \(1\)-special,
\[
 N_{L_\lambda/X}\cong\mathcal O(1)\oplus\mathcal O(-2),
 \qquad E_L\cong\mathbb F_3,
 \tag{17.8c}
\]
that no other line meets \(L_\lambda\), and that the flopping curve on
\(X'\) is the exceptional section of \(E_L\).  On the target side it is
the strict transform of the unique tangent bisecant
\(B_\lambda=\mathbf P(\lambda^5U)\).  Hence the closure of the graph of
(17.4) is the published Sarkisov graph as a closed subscheme of
\(X\times V_5\): both are closures of the graph of the same complete
linear system, with the same target embedding.

The Rees calculation explains the nontrivial middle of (17.8b).  On the
transverse surface obtained by applying \(x\mapsto x+vy\) to (17.7), the
seven coordinates, after their common scalar is removed, are
\[
\begin{aligned}
(&-v^5,\ -uv-7v^6,\ -10uv^2-20v^7,\
 -40uv^3-30v^8,\\
 &-75uv^4-25v^9,\ u^2-66uv^5-11v^{10},\
 2u^2v-22uv^6-2v^{11}).
\end{aligned}
\tag{17.8d}
\]
Consequently
\[
 \boxed{\ \mathfrak b_x=(u^2,uv,v^5)\ },
\tag{17.8e}
\]
on this transverse chart.  By \(B_x\)-equivariance, its completion along
the open orbit of \(L_x\) is
\(\mathbf Q[[\ell,u,v]](u^2,uv,v^5)\), with \(\ell\) the line parameter.
The first, second, and sixth coordinates recover the three displayed
monomials, while every other coordinate belongs to their ideal.  The
Newton inequalities
\[
 a+b\ge2,\qquad 4a+b\ge5
\]
show that (17.8e) is integrally closed.  In particular,
\[
 \overline{\mathfrak b_x}=\mathfrak b_x
 \subsetneq (u,v)^2=\mathcal I_{L_x}^2;
 \tag{17.8f}
\]
the earlier proposed equality
\(\overline{\mathfrak b_x}=\mathcal I_{L_x}^2\) was false.

After blowing up \(L_x\), the \(u\)-chart is base-point-free.  On the
\(v\)-chart, \(u=rv\) gives
\[
 \mathfrak b_x\mathcal O_{X'}
 =v^2(r^2,r,v^3)=v^2(r,v^3).
\tag{17.8g}
\]
Thus the residual Rees graph has equation
\[
 rB=v^3A
\tag{17.8h}
\]
in its two homogeneous Rees coordinates.  Its affine \(A\)-chart is the
\(A_2\) surface singularity \(rb=v^3\), times the line parameter.
Successive ordinary section blowups principalize the residual ideals
\[
 (r,v^3),\qquad(s,v^2),\qquad(t,v),
\tag{17.8i}
\]
which is the width-three Reid-pagoda resolution of the unique flop.
This gives an explicit smooth common resolution of the graph, not only
an equality of rational maps.

Finally, the divisor identities are now identities on the two small
models, not heuristic degree counts:
\[
 \sigma_Y^*H_{V_5}
 \longleftrightarrow
 \sigma_X^*H_X-2E_L,\qquad
 \sigma_X^*H_X
 \longleftrightarrow
 3\sigma_Y^*H_{V_5}-2E_{\Gamma_\lambda}.
\tag{17.8j}
\]
Thus (17.4) is the **pointed kernel Sarkisov formula**, and its
scheme-theoretic graph is resolved.

The primary-source boundary is explicit.  The cached final KPS paper
`arXiv:1605.02010` (61 pages,
SHA-256 `fa5eab5da7d0b57250879c0747fc0affd02f46d943e8b2ad2e47b7308799cfec`)
was read at Theorem 5.2.2, Remark 5.2.4, Lemma 5.2.5, and Proposition
5.4.3.  The cached Chung--Kim--Kim paper `arXiv:2412.17721` (23 pages,
SHA-256 `15acc2562ecda2ab6f1b2f1070d42245205985fc1f88d6ac6649e2918411881d`)
was read at Proposition 2.1 and its discussion of the planar double conic
of MU lines.  These sources supply the global Sarkisov diagram and
special-line geometry after (17.8a) identifies the linear system; they
do not supply the polar formula (17.4) or the Rees calculation
(17.8d)--(17.8i).  No priority claim is made here.

### Lift through the \(V_5\) kernel transform

The center itself has an unexpectedly clean universal-bundle lift.
Fix \(\lambda=x\), write \(m=sx+ty\), and let
\[
 J_{s,t}=x(sx+ty)^5.
\]
For the second-transvectant operator
\[
 T^{(2)}_{J_{s,t}}\colon U_4\longrightarrow U_6
\]
a saturated global kernel basis is
\[
 \begin{aligned}
 e_2(s,t)&=x^2(sx+ty)^2,\\
 e_3(s,t)&=
 2s^3x^3y+5s^2t\,x^2y^2+4st^2\,xy^3+t^3y^4.
 \end{aligned}
 \tag{17.9}
\]
Both vectors are killed by \(T^{(2)}_{J_{s,t}}\), their third
transvectant is zero, and two Plücker coordinates are
\[
 p_{01}=2s^5,\qquad p_{24}=t^5.
 \tag{17.10}
\]
Thus they are independent at every point of \(\mathbf P^1\), including
the closed-orbit limit \(m=x\).  Consequently
\[
 \boxed{\quad
 \mathcal U_{V_5}|_{\Gamma_\lambda}
 \cong\mathcal O_{\mathbf P^1}(-2)
       \oplus\mathcal O_{\mathbf P^1}(-3).
 \quad}
 \tag{17.11}
\]
Dualizing the universal sequence and computing the graded syzygies of
the two rows in (17.9) gives dimensions \(0,1,4,7\) in twists
\(0,1,2,3\).  Since the dual quotient bundle has rank three and degree
\(-5\), this forces
\[
 \mathcal Q_{V_5}|_{\Gamma_\lambda}
 \cong
 \mathcal O_{\mathbf P^1}(1)
 \oplus\mathcal O_{\mathbf P^1}(2)^{\oplus2}.
 \tag{17.12}
\]
Two complementary \(3\times3\) minors of \(T^{(2)}_{J_{s,t}}\) are
\[
 3\,888\,000\,s^{15},\qquad-648\,000\,t^{15},
 \]
so the operator has rank exactly three over the entire quintic.  Formula
(17.11), unlike the bare orbit formula (17.2), is already phrased at the
universal-bundle level and is the first concrete evidence for the
desired kernel-to-kernel functor.

The exact generator/audit, compact certificate, and independent
finite-field replay are

- `notes/2026-07-26-c682-sarkisov-kernel.py`, 21749 bytes, SHA-256
  `3758449cf715c5c582938024501a8fc3bcf2b3adc860a8b50f12539a34c1660c`;
- `notes/2026-07-26-c682-sarkisov-kernel.json`, 2726 bytes, SHA-256
  `7859b2df20be410a79364c132b6ba9b89728e390f311b37c5f89d861ee9eb48a`;
- `notes/2026-07-26-c682-sarkisov-kernel-replay.py`, 7697 bytes, SHA-256
  `12e2e0e8af7e8ee6bf91e4c06c2e1f4790e1ba241966c1cbed239a1833c88c45`.

Run

```text
python3 notes/2026-07-26-c682-sarkisov-kernel.py
python3 notes/2026-07-26-c682-sarkisov-kernel-replay.py
```

The replay uses a separately implemented transvectant over
\(\mathbf F_{101}\), checks 125 points of the determinant-one chart,
exhausts all 102 points of the center normalization
\(\mathbf P^1(\mathbf F_{101})\), and checks all 10,201 points of the
transverse \((u,v)\)-chart against (17.8d).  It is an independent
regression and normalization check; the characteristic-zero proof is the
symbolic Laurent and polynomial identity in the main audit.

### `ej`+`tt` closeout for the graph

The cheap extra value is the numerical mechanism behind the special-line
geometry.  Double projection removes the order-two factor along \(L\);
the remaining fifth-order contact becomes the exponent
\[
 5-2=3
\]
in \((r,v^3)\).  The same integer \(3\) is the Hirzebruch index of
\(E_L\cong\mathbb F_3\) and the width of the local pagoda.  Thus the
fifth-order boundary contact, the special normal bundle
\(\mathcal O(1)\oplus\mathcal O(-2)\), and the Reid-pagoda width are not
three unrelated calculations.

The stress test also fixes the exact claim boundary.  The global equality
of graph schemes comes from (17.8a) plus the KPS theorem; the explicit
monomial/Rees chart is computed along the open \(B_x\)-orbit of the
pointed line.  It is not being used to infer the endpoint geometry by
generic continuation.  Conversely, the KPS theorem by itself does not
produce (17.8d) or identify the width directly in the seventh-polar
coordinates.  No novelty claim is made for the abstract Sarkisov link.

No genuine mystery remains about which birational map (17.4) defines or
about the scheme structure needed to resolve its unique flop.  The
remaining mysteries are downstream: invert the pointed kernel formula on
the resolved graph and determine the quartic branch equation.

### Research plan and kill gates

The first gate is complete.  The remaining work has five ordered gates.

1. **Construct the inverse kernel formula.**  Starting from the
   two-plane \(\ker T^{(2)}_J\) and the marked hyperplane normal
   \(\lambda^6\), recover the three-plane
   \(\ker T^{(3)}_I\) and the invariant coordinate \(z\) away from the
   exceptional loci.
2. **Upgrade to families.**  For a rank-two bundle \(U/S\) and a line
   subbundle \(\Lambda\subset U\), formulate (17.3), (17.4), and (17.9)
   as bundle morphisms and prove arbitrary base-change compatibility on
   the resolved graph.
3. **Transport quartics.**  Express the residual map
   \(\rho:\operatorname{Sym}^4\Gamma_\lambda\dashrightarrow V_5\) in
   sextic/kernel coordinates and pull back the ramification divisor of
   the universal-line evaluation map.
4. **Compute the branch equation.**  Chung--Kim show only that the
   branch hypersurface is contained in \(\rho^{-1}(B)\), where
   \(B\in|\mathcal O_{V_5}(2)|\).  Equality, degree, and an invariant
   equation on \(\operatorname{Sym}^4\mathbf P^1\cong\mathbf P^4\) would
   be the first high-impact geometric consequence.
5. **Run a term-level priority audit.**  Search the classical invariant
   literature for (17.4), not merely for “double projection,” and audit
   universal-bundle restrictions and branch-divisor formulas
   separately.

The principal kill criterion is clear: if (17.4) or an equivalent
seventh-polar formula already appears in Mukai, Iskovskikh--Prokhorov,
or later explicit \(V_{22}\) literature, the formula becomes
expository.  Even then, a new scheme-valued inverse or explicit quartic
branch equation can still support a strong paper.  Without one of those
two upgrades, this remains an elegant note rather than the
Compositio/JAG-level mechanism being targeted.

## 18. Which other instances matter?

The first distinction is essential.  The *global* form is general, but the
local monomial ideal is not.  For every smooth prime Fano threefold
\(X\) of genus \(12\) and every line \(L\subset X\), double projection is
the complete system
\[
 |H_X-2L|
 \tag{18.1}
\]
and gives the Kuznetsov--Prokhorov--Shramov link to \(V_5\).  By contrast,
\[
 (u^2,uv,v^5),\qquad rB=v^3A
 \tag{18.2}
\]
was computed in the pointed Mukai--Umemura chart.  It records the
special normal bundle
\(\mathcal O(1)\oplus\mathcal O(-2)\), the exceptional
\(\mathbb F_3\), and the unique width-three pagoda.  It must not be
advertised as the generic local form of (18.1).

This leaves the following exact instance landscape.

| instance | theorem-level structure | what is special |
|---|---|---|
| an arbitrary \((V_{22},L)\) | the line-centered link (18.1) lands on \(V_5\) | control family; no Clebsch symmetry or forced chart (18.2) |
| \((X^{\rm MU},L)\) | every line is special; no two lines meet; the reduced line family is one \(PGL_2\)-orbit | the Hilbert scheme of lines is a double conic, and every pointed link is transported from the single formula (17.4) |
| the additive \(X^{\rm a}\) and multiplicative \(X^{\rm m}(u)\) cases | KPS give distinguished special-line links with the same unique-flop geometry | the center quintic carries respectively unipotent or toric symmetry, so these are the nearest non-\(PGL_2\) tests of the polar formula |
| \((V_{22},C)\) for a smooth conic | Kuznetsov--Prokhorov give a second link \(V_{22}\dashrightarrow Q^3\), with a rational sextic center on the quadric | for \(X^{\rm MU}\), all smooth conics are \(PGL_2\)-equivalent; for a non-MU \(G_m\)-threefold there is a unique invariant smooth conic |
| \(Q^3,V_5,U_{22}\) | these are exactly the three smooth positive-index threefolds in the single-transvectant isotropic balance | the known line and conic links make \(U_{22}\) the top vertex of a two-edge \(V_5\leftarrow U_{22}\to Q^3\) diagram |

Here the conic-centered link is given on the blown-up source by
\(|H-2E_C|\); its inverse on the quadric is
\(|5H_Q-2E_\Gamma|\), with \(\Gamma\subset Q^3\) a quadratically normal
rational sextic.  In the \(G_m\)-family the Mukai--Umemura member occurs
at the enhanced-symmetry parameter \(u=-1/4\).  These statements are
published geometry, not consequences inferred from (17.4): see
Kuznetsov--Prokhorov, arXiv:1711.08504, Theorem 2.2 and Sections 3--4,
and KPS, arXiv:1605.02010, Section 5.4.

### What the Clebsch point opens

The special value of the Clebsch/Mukai--Umemura instance is not merely
that its equations are pretty.  Four degeneracies coincide there:

1. the automorphism group jumps to \(PGL_2\);
2. the line scheme becomes a nonreduced double conic;
3. all reduced lines and all smooth conics become single homogeneous
   families; and
4. the pointed line link acquires the explicit width-three chart (18.2).

That coincidence makes five continuations concrete.

1. **A kernel/Sarkisov three-vertex correspondence.**  Write the
   conic-centered \(U_{22}\dashrightarrow Q^3\) link in binary-form
   covariants, alongside the proved
   \(U_{22}\dashrightarrow V_5\) seventh polar and the lower
   \(V_5\) kernel inverse.  The theorem target is a commuting diagram of
   tautological bundles on the three smooth nodes
   \(Q^3,V_5,U_{22}\), not an unsupported direct birational edge
   \(Q^3\dashrightarrow V_5\).
2. **Unfold the width-three pagoda.**  Follow the local Rees equation
   \(rB=v^3A\) through the \(G_m\)-pencil approaching
   \(u=-1/4\).  The natural conjecture is that the Clebsch pagoda is a
   collision of ordinary flop data.  The kill test is an explicit
   relative Rees algebra: if its nearby fibres do not recover the
   published ordinary-line link, the collision interpretation is false.
3. **Exploit the quartic branch symmetry.**  Chung--Kim's generically
   two-to-one map
   \(\mathcal H_4(V_{22})\dashrightarrow
   \operatorname{Sym}^4\Gamma\cong\mathbf P^4\) becomes a binary-quartic
   invariant problem at the Clebsch point.  The \(PGL_2\)-action sharply
   limits the possible branch equation; (18.2) supplies boundary
   multiplicities that the abstract link does not see.  This remains
   the highest-payoff concrete calculation.
4. **Differentiate the double line conic.**  Apply (17.4) not only to a
   reduced moving line but to the nilpotent normal direction in its
   Hilbert double structure.  A successful calculation should recover
   the first-order motion of the center quintic and explain
   representation-theoretically why the transverse \(v^2\) term is
   missing and contact is delayed to \(v^5\).
5. **Build the correct arithmetic form.**  The recent classification of
   large-automorphism genus-\(12\) Fanos shows that the \(PGL_2\) and
   \(G_a\) types exist precisely away from characteristics \(2,5\), while
   the present ordinary-derivative tensor has extra bad primes.  A
   divided-power/Weyl transvectant over \(\mathbf Z[1/10]\) should remove
   those normalization artifacts.  It cannot be phrased as one smooth
   \(PGL_2\)-symmetric model over all of \(\mathbf Z\): the same source
   proves that no such positive-dimensional-automorphism model exists.

The arithmetic boundary in item 5 is from
Ito--Kanemitsu--Takamatsu--Tanaka, arXiv:2601.10106.  Their finite-field
classification also supplies a testing population of \(PGL_2\), \(G_a\),
and \(G_m\) forms rather than a single characteristic-zero example.

### `ej`+`tt` closeout for the instance landscape

The cheapest decisive experiment is item 2, because the \(G_m\)-pencil
already supplies the parameter and (18.2) supplies the special fibre.
The most valuable theorem if successful is item 3, because it converts
the explicit pointed graph into a new equation on a moduli/Hilbert
space.  Item 1 is the cleanest conceptual synthesis: the transvectant
ladder has exactly the three smooth threefold nodes, and published
Sarkisov links already connect the top node to both lower nodes.

The strongest organizing conjecture is therefore that the
Mukai--Umemura point is a maximally symmetric collision at which the
three-node kernel ladder, the line and conic Sarkisov links, the
nonreduced line conic, and the width-three pagoda are different shadows
of one equivariant correspondence.  Only the individual nodes, the two
links, and the pointed line chart are currently proved.  The
``one correspondence'' assertion is a research target, not a theorem or
a novelty claim.

## 19. The opposite code objects

There is an exact code-theoretic shadow of the
\(V_5\leftarrow U_{22}\) edge.  It is stronger than the loose analogy
``kernel equals parity check.''

For \(0\le d\le10\), evaluate
\[
 U_d=H^0(\mathbf P^1,\mathcal O(d))
\]
on all twelve points of \(\mathbf P^1(\mathbf F_{11})\), using the usual
homogeneous normalization at infinity.  The resulting projective
Reed--Solomon code is
\[
 R_d=[12,d+1,12-d]_{11}.
 \tag{19.1}
\]
Root counting proves the distance, and the residue pairing on
\(\mathbf P^1\) gives, up to the standard coordinate multipliers,
\[
 R_d^\perp\simeq R_{10-d}.
 \tag{19.2}
\]
With compatible homogeneous coordinates the relevant three terms may be
normalized so that
\[
\begin{array}{ccl}
 U_4 &\rightsquigarrow& R_4=[12,5,8]_{11},\\
 U_5 &\rightsquigarrow& R_5=[12,6,7]_{11},\\
 U_6 &\rightsquigarrow& R_6=[12,7,6]_{11},
\end{array}
\qquad
 R_4^\perp=R_6,\quad R_5^\perp=R_5.
\tag{19.3}
\]

This is exactly the representation sequence visible in the line link:

- the lower kernel model \(V_5\subset\operatorname{Gr}(2,U_4)\) uses
  \(U_4\);
- its exceptional center is the normal rational quintic
  \(\Gamma_\lambda=\{[\lambda m^5]\}\), whose span
  \(\lambda U_5\) gives \(R_5\); and
- the upper kernel model
  \(U_{22}\subset\operatorname{Gr}(3,U_6)\) uses \(U_6\).

Thus, specifically at \(q=11\), the two ambient modules on opposite sides
of the pointed kernel link give dual MDS codes, while the center gives the
self-dual rate-half MDS code between them.  The equality is
field-specific: only \(q+1=12\) makes dimensions \(5\) and \(7\) dual and
dimension \(6\) fixed.  It is therefore a real explanation for the
arithmetic prominence of \(11\), not a general slogan about rational
normal curves.

The original Clebsch code fits one level lower.  Its legal-extension/deep-
hole port is the complete conic
\[
 R_2=[12,3,10]_{11},
 \tag{19.4}
\]
whereas the six-coordinate seed is
\([6,3,4]_{11}\).  Its two golden forms satisfy
\[
 C_t^\perp=C_{1-t}
 \tag{19.5}
\]
up to the fixed marked equivalence.  Hence duality exchanges the two
golden sheets on the seed, but becomes internal self-duality on the
quintic-center code \(R_5\).  In the AME dictionary these give,
respectively, a stabilizer \(\operatorname{AME}(6,11)\) state and the
extended-GRS \(\operatorname{AME}(12,11)\) state.  No canonical map
between those two states has yet been constructed.

This also clarifies which apparent code translations are false.  A point
of \(\operatorname{Gr}(2,U_4)\) or
\(\operatorname{Gr}(3,U_6)\) is not intrinsically an MDS code merely by
reading binary-form coefficients as coordinate positions.  MDS enters
through evaluation on the twelve rational points of \(\mathbf P^1\), or
through a separately specified arc.  The Fano isotropy equations and the
MDS minor conditions live on different spaces until that evaluation
functor is supplied.

### What the code lens predicts

1. **The center should be the fixed object of the duality.**  A
   base-change-compatible version of (17.4) ought to carry the
   \(U_4/U_6\) dual pairing to the self-dual \(U_5\) center.  Proving this
   with the residue pairing would turn (19.3) from an object-level
   coincidence into a natural transformation.
2. **Scheme structure should correspond to coefficient data, not
   support data.**  On the code side, the complete coefficient repair
   port spans \(C^\perp\), while its support-only projection is just the
   uniform matroid and forgets the Clebsch moduli.  On the geometric side,
   the reduced base line likewise misses the information retained by
   \((u^2,uv,v^5)\).  The parallel is exact at the two endpoints, but no
   functor identifying the coefficient port with the Rees algebra is yet
   proved.
3. **The conic link has a defect-two opposite object.**  The rational
   sextic center of \(U_{22}\dashrightarrow Q^3\) is defined by a
   five-dimensional subsystem of \(U_6\).  The exact \(q=11\) audit below
   gives a \([12,5,6]_{11}\) code whose dual is
   \([12,7,4]_{11}\).  Both Singleton defects are two.
4. **Gale/Fourier is the genuine opposite operation.**  On the Clebsch
   seed, code duality is simultaneously six-point Gale association,
   golden Galois conjugation, and local Fourier equivalence of the
   equal-phase AME states.  The open QG problem asks whether, generically,
   these are the only extra identifications made by the
   MDS-to-AME functor.

The resulting exact code diagram is
\[
\begin{array}{ccccc}
R_4=[12,5,8] &\xleftrightarrow{\ \perp\ }&
R_6=[12,7,6],\\[2mm]
&R_5=[12,6,7]=R_5^\perp&
\end{array}
\tag{19.6}
\]
with \(R_5\) supplied geometrically by the Sarkisov center.  The strongest
new theorem target is that the pointed kernel link *categorifies* this
three-code duality pattern.  At present (19.1)--(19.5) and the geometric
identification of the three modules are exact; the categorification claim
is conjectural.

### The conic-edge code is exactly defect two

Kuznetsov--Prokhorov's parametrization of the fixed sextic center is
\[
 (t_0:t_1)\longmapsto
 (t_0^6:t_0^5t_1:t_0^3t_1^3:t_0t_1^5:t_1^6).
 \tag{19.7}
\]
The primary input is arXiv:1711.08504, cached from the version-3 PDF with
SHA-256
`94bf426f34dc90ca68ab1d581d7a37a2dbebf1a8e3f184188825a025524c664a`.
Thus its twelve \(\mathbf F_{11}\)-points generate the sparse evaluation
code
\[
 C_\Gamma
 =\operatorname{ev}_{\mathbf P^1(\mathbf F_{11})}
   \langle1,t,t^3,t^5,t^6\rangle.
 \tag{19.8}
\]
Complete canonical enumeration gives
\[
 C_\Gamma=[12,5,6]_{11},\qquad
 C_\Gamma^\perp=[12,7,4]_{11}.
 \tag{19.9}
\]
Their weight enumerators are
\[
\begin{aligned}
 W_{C_\Gamma}(z)
 ={}&1+240z^6+100z^7+2500z^8+10600z^9\\
    &+36380z^{10}+59180z^{11}+52050z^{12},\\
 W_{C_\Gamma^\perp}(z)
 ={}&1+150z^4+340z^5+5300z^6+47700z^7\\
    &+317950z^8+1345700z^9+4116660z^{10}\\
    &+7442620z^{11}+6210750z^{12}.
\end{aligned}
\tag{19.10}
\]
The generalized Hamming-weight hierarchies are respectively
\[
 (6,7,10,11,12),\qquad(4,5,8,9,10,11,12).
 \tag{19.11}
\]

The defect has a direct geometric source.  Equation (19.7) is the degree-six
rational normal curve with exactly the \(t^2\) and \(t^4\) coordinates
deleted.  Therefore
\[
 0\longrightarrow C_\Gamma\longrightarrow R_6
 \longrightarrow\mathbf F_{11}^2\longrightarrow0,
 \qquad
 0\longrightarrow R_4\longrightarrow C_\Gamma^\perp
 \longrightarrow\mathbf F_{11}^2\longrightarrow0.
 \tag{19.12}
\]
The two missing weights, not an unexplained finite-field accident, account
for the two-dimensional departure from the MDS dual pair.

There are \(24\) projective minimum words of \(C_\Gamma\), equivalently
\(24\) rational six-secant hyperplanes.  The dual has exactly \(15\)
projective minimum words, supported on the \(15\) rational four-point
circuits, or four-secant planes.  With parameter points
\(\{0,1,\ldots,10,\infty\}\), the circuits split as
\[
\begin{array}{ll}
5 &: \{0,\infty,a,-a\},\\
5 &: \text{the four-subsets of the five nonzero squares},\\
5 &: \text{the four-subsets of the five nonsquares}.
\end{array}
\tag{19.13}
\]
The stabilizer inside \(PGL_2(\mathbf F_{11})\) has order \(20\) and is
exactly
\[
 t\longmapsto at,\qquad t\longmapsto a/t
 \quad(a\in\mathbf F_{11}^{\times}),
 \tag{19.14}
\]
the finite reduction of the published \(G_m\rtimes C_2\) symmetry.

This result corrects two possible overreads.  First, the conic edge does
not produce another MDS or NMDS object: both it and its dual have defect
two.  Second, \(\Gamma\) is fixed throughout the \(G_m\)-pencil of
quadrics, so this code does not by itself distinguish the
Mukai--Umemura parameter \(u=-1/4\).  Its \(15\) projective dual-minimum
words happen to equal the number for a \([6,3,4]\) MDS code, but their
twelve-coordinate support design is different; no Clebsch-code
identification follows from the count.

The exact generator and certificate are
`notes/2026-07-26-c682-conic-link-code.py` and
`notes/2026-07-26-c682-conic-link-code.json`.  Replay from the repository
root with

```text
python3 notes/2026-07-26-c682-conic-link-code.py --check
python3 notes/2026-07-26-c682-conic-link-code-replay.py
```

The main audit enumerates all \(11^5\) codewords, all subsets needed for
the generalized weights and four-circuits, and all \(1320\) elements of
\(PGL_2(\mathbf F_{11})\).  The independent replay enumerates projective
coefficient classes, uses direct determinants for the circuit matroid,
and checks the deleted-coordinate duality separately.  Its evidence
boundary is the explicit reduction of (19.7); it does not construct a
functor from the Sarkisov graph or identify the circuits with flopping
curves.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-26-c682-conic-link-code.py` | 9903 | `55bea06b24e0a7069f77ace87fb304e072655dc0e6b59ca8a1373c97c572692e` |
| `2026-07-26-c682-conic-link-code-replay.py` | 5479 | `1dd6f93ff27929dc7f50248325bf3338044b0035ce2564e3cb36d4edf612a94c` |
| `2026-07-26-c682-conic-link-code.json` | 6687 | `3cd5ed4bfb9fb2aa211ef085965c8f8f1e8cb8b08337e54df31e4fe56ae0e372` |

### `ej`+`tt` closeout for the conic code

The cheap extra conclusion is (19.12): the same two omitted weights explain
both Singleton defects and put the code and its dual on opposite sides of
the exact Reed--Solomon pair \(R_4^\perp=R_6\).  This is a more faithful
code shadow of the conic edge than forcing another MDS midpoint.

The Tao pass makes this field-independent.  For every odd prime power
\(q\ge7\), let \(C_\Gamma(q)\) be the evaluation of the same five-space
\[
 W=\langle1,t,t^3,t^5,t^6\rangle
 \subset H^0(\mathbf P^1,\mathcal O(6))
 \tag{19.15}
\]
on \(\mathbf P^1(\mathbf F_q)\).  Then
\[
 C_\Gamma(q)=[q+1,5,q-5]_q,\qquad
 C_\Gamma(q)^\perp=[q+1,q-4,4]_q.
 \tag{19.16}
\]
Indeed, a nonzero sextic has at most six projective roots, while
\[
 t(t^2-a^2)(t^2-b^2)
 \]
has the six distinct roots
\(\{0,\infty,\pm a,\pm b\}\) for \(a\ne\pm b\).  This proves the first
distance.  Any three columns of (19.7) are independent: for three finite
parameters the minors with exponent rows \(0,1,3\), then \(0,1,5\), and
finally \(0,1,6\) handle respectively nonzero sum, zero sum with nonzero
product, and the residual triple \(\{0,a,-a\}\); a triple containing
\(\infty\) is separated by rows \(0,1,6\).  On the other hand,
\(\{0,\infty,a,-a\}\) is a four-column circuit.  Hence the dual distance
is four.  Both Singleton defects are therefore identically two, not a
sporadic \(q=11\) count.

For general \(q\), after the standard residue-coordinate normalization,
duality gives
\[
 0\to C_\Gamma(q)\to R_6(q)\to\mathbf F_q^2\to0,
 \qquad
 0\to R_{q-7}(q)\to C_\Gamma(q)^\perp\to\mathbf F_q^2\to0.
 \tag{19.17}
\]
The Clebsch-field resonance is the unique balance
\[
 q-7=4\quad\Longleftrightarrow\quad q=11.
 \tag{19.18}
\]
Equivalently, the residue/Serre duality
\(R_d(q)^\perp\simeq R_{q-1-d}(q)\) sends degree \(4\) to degree \(6\)
and fixes degree \(5\) exactly at \(q=11\).  This is the invariant reason
that the \(U_4,U_5,U_6\) Sarkisov modules become a
dual-pair/self-dual-midpoint code diagram only in the Clebsch field.

The same pass resolves the geometric mystery.  In centered
\(SL_2\)-weights, \(W\) retains
\[
 6,4,0,-4,-6
\]
and deletes the pair \(2,-2\), exchanged by the Weyl involution.  With
the torus linearization, the quotient is precisely the sum of the second
jet lines at the two fixed points:
\[
 H^0(\mathcal O(6))/W
 \simeq \operatorname{gr}^2_0 J(\mathcal O(6))
 \oplus\operatorname{gr}^2_\infty J(\mathcal O(6)).
 \tag{19.19}
\]
The induced \(g^4_6\) has vanishing sequence
\[
 (0,1,3,5,6)
 \tag{19.20}
\]
at both fixed points.  Each has ramification weight \(5\); in
characteristic zero, or characteristic greater than \(6\), the two points
therefore exhaust the Plücker total
\((4+1)(6-4)=10\).

This jet gap is exactly the flop geometry.  Near \(0\),
\[
 \Gamma(t)=(1:t:t^3:t^5:t^6),
 \]
so the tangent line
\(\ell_{0,1}=\langle P_0,P_1\rangle\) has transverse ideal restricting
to \((t^3,t^5,t^6)=(t^3)\).  Near \(\infty\), the identical calculation
with \(s=1/t\) gives contact order three for
\(\ell_{6,5}=\langle P_6,P_5\rangle\).  Had the deleted second-jet
coordinates \(t^2,t^4\) been retained, both contacts would have order
two.  Kuznetsov--Prokhorov, Proposition 5.1 and Remark 5.3, identify the
strict transforms of precisely these two 3-tangent lines as the complete
flopping locus and show that the flop is Reid's pagoda.  Thus the two
code-defect directions, the two missing torus weights, the two second-jet
gaps, and the two pagoda components are the same pair of objects.

The \(15=5+5+5\) dual minimum supports at \(q=11\) are now equally
transparent.  Five are the universal circuits
\(\{0,\infty,a,-a\}\).  On the square pentad \(t^5=1\), the coordinate
relations \(y_5=y_0,\ y_6=y_1\) put all five points in a plane; on the
nonsquare pentad \(t^5=-1\), the relations become
\(y_5=-y_0,\ y_6=-y_1\).  The ten four-subsets of these two planes give
the other ten circuits.  No unidentified Clebsch-code coincidence remains
in the count.

What is still open is one categorical level higher.  The jet calculation
identifies the exceptional components but does not yet write the complete
local Rees algebra of \(|5H_Q-2E_\Gamma|\) as a functor of the two jet
lines.  Doing so would turn the present object-level identification into
a base-change-compatible Sarkisov/code transformation.

## 20. The Clebsch Schur--Sarkisov spine

The portfolio summary exposes a stronger organizing statement than the
three-code diagram (19.6).  Let
\[
 E=R_2=[12,3,10]_{11},
 \tag{20.1}
\]
the complete conic evaluation code that is the Clebsch deep-hole extension
port.  Multiplication of binary forms is surjective
\[
 H^0(\mathcal O(a))\otimes H^0(\mathcal O(b))
 \longrightarrow H^0(\mathcal O(a+b)),
\]
and evaluation is injective through degree \(10\).  Hence, for
\(a+b\le10\),
\[
 R_a\star R_b=R_{a+b}.
 \tag{20.2}
\]
In particular,
\[
 E^{\star2}=R_4,\qquad E^{\star3}=R_6.
 \tag{20.3}
\]
Thus the \(U_4/U_6\) modules on the two outer Fano nodes are not merely
Reed--Solomon codes on the same point set: they are the square and cube of
the original Clebsch extension port in the conic evaluation algebra.

At \(q=11\), (19.18) becomes the exact Frobenius pairing
\[
 (E^{\star2})^\perp=E^{\star3},
 \qquad
 R_5^\perp=R_5.
 \tag{20.4}
\]
The normal-quintic Sarkisov center is therefore the self-dual degree-five
piece between the Schur-square and Schur-cube endpoints.  Combining
(19.12), (19.19), and (20.3) gives the sharper conic-edge diagram
\[
\begin{array}{ccccccccc}
0&\to&C_\Gamma&\to&E^{\star3}=R_6
 &\to&J^{(2)}_{0,\infty}&\to&0,\\
&&&&\rotatebox{90}{\(\perp\)}&&\rotatebox{90}{\(\vee\)}\\[-1mm]
0&\to&E^{\star2}=R_4&\to&C_\Gamma^\perp
 &\to&(J^{(2)}_{0,\infty})^\vee&\to&0.
\end{array}
\tag{20.5}
\]
Here \(J^{(2)}_{0,\infty}\) is the sum of the two second-jet lines.
Consequently the conic Sarkisov center is a defect-two elementary
modification of the cubic Schur power of the Clebsch port.  The two pagoda
curves are the geometric exceptional locus of precisely that modification.

This yields the exact object-level spine
\[
\text{Clebsch port }R_2
\xrightarrow{\ \star2,\star3\ }
(R_4,R_6)
\xrightarrow{\ \text{jet modification}\ }
(C_\Gamma,C_\Gamma^\perp),
\tag{20.6}
\]
with \(R_5\) the self-dual midpoint.  It bridges the previously separate
deep-hole, Fano-kernel, conic-link, and MDS/AME objects without identifying
their moduli functors.

Three further consequences are targets rather than theorems.

1. Paper II's quadratic recovery and cubic orientation should be compared
   to the degree-\(4\) and degree-\(6\) pieces of the same conic evaluation
   algebra.  The common square/cube mechanism is exact in the ambient
   algebra, but no natural map from the matching quotient to (20.6) is yet
   constructed.
2. The complete coefficient repair port and the scheme-theoretic jet/Rees
   object both retain linear data erased by support reduction.  Turning this
   parallel into a graded repair-port/Rees functor would categorify (20.5).
3. The midpoint \(R_5\) gives the extended-GRS
   \(\operatorname{AME}(12,11)\) stabilizer state.  The LU-to-LC theorem
   makes any product-local realization of the Sarkisov/Serre symmetry a
   local-Clifford classification problem, but it does not supply such a
   realization.

The next-level theorem target is therefore a **Conic
Schur--Sarkisov correspondence**.  One should construct
\[
 \mathcal A=\bigoplus_d R_d
 \tag{20.7}
\]
with its multiplication, residue/Frobenius pairing, and filtered jet
quotients, then recover the \(Q^3,V_5,U_{22}\) nodes and their line- and
conic-centered links functorially.  The acceptance gate is not another
dimension match: it is a base-change-compatible Rees construction whose
special fibers reproduce the scheme-theoretic pointed graph and both
pagoda components.

## Mystery ledger

- **Settled:** a natural ambient bridge exists after choosing an
  icosahedral parent; it is the third transvectant and has exact rank four.
- **Settled:** its kernel and image are forced representation-theoretically,
  explaining why the bridge appears only on the Clebsch/Petersen
  four-space.
- **Settled on the open orbit:** the kernel is fifth-transvectant
  isotropic, so the construction identifies the binary-dodecic and
  Grassmannian \(PSL_2/A_5\) models.
- **Settled locally at the Klein point:** the projective tangent space of
  the rank-four determinantal locus has dimension three, so the
  Mukai--Umemura closure is its local component there.
- **Settled globally in characteristic zero:** the common annihilator of
  each isotropic three-plane is one-dimensional on all three
  Mukai--Umemura orbits.  The resulting line bundle gives an inverse to
  the transvectant-kernel map, so rank four plus isotropic kernel is
  exactly the full compactification, scheme-theoretically.
- **Settled geometrically:** this inverse is the regular projection of the
  anticanonical \([1+\Phi_{12}]\)-orbit model from its invariant
  coordinate; the image has degree \(22\).
- **Settled beyond \(U_{22}\):** \(V_5\) has the parallel
  second-transvectant rank-three/kernel-two inverse, and the
  single-transvectant positive-index threefold balance has only the four
  numerical rows \(Q^3,V_5\), the nontransverse genus-eight near-miss,
  and \(U_{22}\).
- **Settled exactly for the pointed link:** the unique lowest-bidegree
  covariant (17.4) maps the dense Mukai--Umemura orbit dominantly into
  \(V_5\), has the expected double base line, and contracts the
  stabilizer surface to \(\Gamma_\lambda\).  Along that quintic the
  universal bundles split as
  \(\mathcal U=\mathcal O(-2)\oplus\mathcal O(-3)\) and
  \(\mathcal Q=\mathcal O(1)\oplus\mathcal O(2)^{\oplus2}\).
- **Settled scheme-theoretically for the pointed link:** the ambient
  center is the span of the first infinitesimal neighborhood of
  \(L_\lambda\), so (17.4) is the complete system
  \(|H-2L_\lambda|\).  Its graph is therefore the published Sarkisov
  graph as a closed subscheme.  The transverse base ideal is the
  integrally closed ideal \((u^2,uv,v^5)\), not
  \(\mathcal I_L^2\); after blowing up \(L\), the residual Rees chart is
  \(rB=v^3A\), and the three residual section blowups give the
  width-three Reid pagoda.
- **Settled at the instance level:** \(|H-2L|\) is the general
  line-centered construction, whereas \((u^2,uv,v^5)\) is the special
  Mukai--Umemura local chart.  The additive and multiplicative
  automorphism strata are the nearest special-line comparisons, and the
  conic-centered link supplies a second exact edge
  \(U_{22}\dashrightarrow Q^3\).
- **Open, with a falsifiable next test:** determine the relative Rees
  algebra in the \(G_m\)-pencil and decide whether the width-three
  Mukai--Umemura pagoda is a collision of ordinary flop data.
- **Open at highest geometric value:** use the \(PGL_2\)-equivariant
  pointed graph to compute the branch equation of the rational-quartic
  Hilbert double cover.  The proposed single master correspondence among
  \(Q^3,V_5,U_{22}\) remains conjectural.
- **Settled over \(\mathbf F_{11}\) in the code lens:** evaluation of
  \(U_4,U_5,U_6\) on \(\mathbf P^1(\mathbf F_{11})\) gives
  \([12,5,8]\), \([12,6,7]\), and \([12,7,6]\) extended GRS codes.  The
  outer two are dual and the middle one is self-dual; the middle code is
  exactly the normal-quintic Sarkisov center.
- **Settled on the opposite conic edge over \(\mathbf F_{11}\):** the
  sextic-center code is \([12,5,6]\), its dual is \([12,7,4]\), and both
  Singleton defects are two.  Deleting the \(t^2,t^4\) coordinates gives
  the two exact sequences (19.12); the dual has fifteen projective
  minimum words and the parameter stabilizer is the expected dihedral
  group of order \(20\).
- **Settled uniformly in the code lens:** for every odd prime power
  \(q\ge7\), the sextic-center code and dual have parameters
  \([q+1,5,q-5]\) and \([q+1,q-4,4]\), so both defects are always two.
  Residue duality aligns \(U_4,U_5,U_6\) as dual/midpoint degrees uniquely
  at \(q=11\).
- **Settled geometrically on the conic edge:** the quotient by the missing
  weights \(2,-2\) is the pair of second-jet lines at \(0,\infty\).
  Their omission raises both tangent contacts to order three, and the
  resulting two 3-tangent lines are exactly the two components of the
  published Reid-pagoda flop.
- **Settled multiplicatively:** the Clebsch conic extension port
  \(E=R_2\) satisfies \(E^{\star2}=R_4\) and \(E^{\star3}=R_6\).
  At \(q=11\) these pieces are dual, \(R_5\) is the self-dual midpoint,
  and the conic-link code is the kernel of the two-second-jet quotient
  of \(E^{\star3}\).
- **Open across Paper II:** determine whether its quadratic recovery and
  cubic orientation arise functorially from the square/cube filtration of
  the complete conic evaluation algebra; the shared ambient multiplication
  alone is not an identification.
- **Open across repair ports and AME:** construct the graded
  coefficient-port/Rees bridge and test whether the \(R_5\) midpoint
  realizes the geometric duality by a product-local, hence necessarily
  local-Clifford, operation.
- **Open functorially on the conic edge:** express the complete local Rees
  algebra of the inverse link in terms of the two second-jet quotient
  lines and prove arbitrary base-change compatibility.
- **Open categorically:** construct, or falsify, a natural transformation
  identifying the pointed kernel link with the
  dual-pair/self-dual-midpoint code diagram.  Object-level dimensions and
  dualities alone do not prove such a functor.
- **Settled in higher dimension:** the rank-two isotropic loci
  \(X_{r,r}=\operatorname{IGr}(2,r+1)\) and \(X_{r+1,r}\) are smooth Fano
  varieties of dimension \(2r-3\), while all later positive-index rows
  already lose transversality at the Borel-fixed plane.
- **Settled on boundary representatives:** both lower-dimensional orbit
  types retain rank four and have exactly Hitchin's isotropic weight-space
  kernels; rank alone has one extra tangent direction at the closed orbit.
- **Settled conceptually:** every nonzero binary dodecic has third-
  transvectant rank at least four.  Otherwise the nonempty closed
  \(PSL_2\)-stable rank-\(\le3\) locus would contain the Borel-fixed
  highest-weight point \([X^{12}]\), whose certified rank is four.
- **Settled arithmetically:** the primitive integral transvectant retains
  rank four modulo \(11\) and drops to rank two modulo \(5\), separating
  the module bridge from the nonreducible Gaunt scalar.
- **Settled exactly:** the Gale transform of the marked golden six-axis
  matrix is its Galois conjugate with the same column order:
  \(HK_t=-tA_{1-t}\).  Golden-sheet exchange is code duality on this
  locus, completing C373's previously open kill test.
- **Settled exactly:** in the manuscripts' concrete six-column marking,
  one Paper I support orbit is the icosahedral face-support orbit, and
  complementary support pairs are the two signed-sum decompositions of
  the corresponding Paper III face axes.  The relabeling of synthemes is
  \((T_0,\ldots,T_4)\mapsto(1,5,2,4,3)\).
- **Settled exactly, after correcting the edge branch:** support
  complementation, six-point Gale association, and golden Galois
  conjugation all exchange the face and opposite-face support orbits.
  The common \(C_2\) survives the marked test.
- **Settled:** the Paper I support sheets have equal signed moments through
  degree two and first differ cubically, giving the same
  quadratic-recovery/cubic-orientation pattern as Paper II.
- **Settled negatively:** the canonical syntheme quadratic followed by
  \(\sigma_3\) is not a scalar multiple of the squared support cubic; two
  exact augmentation-space witnesses give distinct ratios.
- **Settled exactly:** the two sextics have exotic quotient ratio
  \(4:125\), and
  \[
  375C^2-12\sigma_3(q)
  =6000p_6-4350p_4p_2-2125p_3^2+705p_2^3
  \]
  on \(p_1=0\).  This is the corrected \(2\)-\(3\)-\(6\) theorem modulo
  universal symmetric information.
- **Settled by literature audit:** \(C_T\) is the classical
  Joubert/Segre coordinate and \(\operatorname{center}(C_T^2)=W_T\) is
  the classical Segre--Igusa dual map.  The outer-covariant and resolvent
  crown is therefore preempted; only the compact
  five-syntheme/Clebsch expression for \(W_T\) remains a formula-level
  Gold candidate.
- **Settled as a coordinate identity, not intrinsically:** with C651's
  selected intertwiner,
  \(c_{\mathrm{match}}^2=J_0|_V\) and
  \(w=\pm4c_{\mathrm{match}}\) over \(\mathbf F_{11}\).  The scalar and
  torsor comparison remain gates.
- **Settled:** the completed two-branch model is the universal
  residue-field pinch \(\mathbf Q+\mathfrak m\), with depth-one defect
  exactly \(\mathbf Q(\sqrt5)/\mathbf Q\).
- **Settled Platinum track TR, mathematically:** the stable rank-four
  locus is the icosahedral orbit and rank plus kernel isotropy cuts out
  its compactification.  A deeper priority audit still gates novelty and
  manuscript promotion.
- **Open arithmetic TR refinement:** construct the divided-power/Weyl
  integral transvectant model and determine whether the inverse extends
  over \(\mathbf Z[1/10]\).  Naive reduction of the ordinary-derivative
  tensor has extra degeneracies at \(3,7,11\) and is not the right model.
- **Open Platinum track QG:** determine whether the generic fibre of the
  rate-half MDS-to-stabilizer-AME functor is exactly a monomial/Gale
  orbit.
- **Open Gold-to-Platinum track E3:** extend the frame/Clebsch
  classification of full-conic extension ports beyond eight points, then
  formulate the higher-redundancy minimal-degree transform problem.
- **Open Gold track:** bound the orientation index of a self-associated
  arithmetically Gorenstein configuration by its Hilbert/canonical-module
  data and classify equality.
- **Open:** compare the binary and Euclidean normalizations and compute the
  scalar of \(T_{I_t}|_{V_t}\) in the paper's conventions.
- **Open:** verify that the two invariant harmonic lines are distinct and
  prove that the conjugate operator pair has discriminant class \([5]\).
- **Open:** determine whether the odd determinant character of the third
  transvectant is the same geometric orientation character as Hitchin's
  incidence involution, rather than merely an analogous sign.
- **Settled:** the pointed linear formula (17.4) is the complete
  double-projection system and its Rees graph is the Sarkisov graph
  scheme-theoretically.  The explicit width-three pagoda resolves its
  unique flop.
- **Open:** construct the inverse kernel formula on that resolved graph
  and compute the quartic branch equation.
- **Open:** contract the C651 finite matching tensor through the primitive
  mod-\(11\) map and fix the resulting cubic scalar.
- **Open:** identify the relevant Paper II orientation cover over the now
  fixed ten-point carrier; C651 fixes the \(A_5\)-module but not an outer
  sheet action or its normalization.
- **Open:** compare the compact five-syntheme/Clebsch expression directly
  with the classical explicit \(W_T\) formulas and find a consequence not
  already contained in Segre--Igusa duality.
- **Open:** formalize the exact pointed-port-to-unordered-Petersen-cubic
  reconstruction corollary.
- **Open:** turn the shared \(KG(k,2)\) negative eigenspace into a numerical
  lower bound for prescribed-hole defect.
- **Open:** audit the compact formula at term level before any novelty
  claim; the broad outer-\(S_6\) construction is already classical.

C682 remains open.  The user retains stopping authority.
