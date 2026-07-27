# C682 Hitchin-facing structural exploration

**Date:** 2026-07-26  
**Lane:** `clebsch`  
**Status:** queued, open-ended  
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

The involution comparison has a decisive negative answer.  Golden
conjugation \(t\mapsto1-t\), equivalently the marked Gale transform,
preserves \(\mathcal F\), whereas support complementation exchanges
\(\mathcal F\) and \(\mathcal F^c\).  These two \(C_2\)-operations are not
the same.  They are transverse commuting operations: complementation
switches the two decompositions over a fixed face-axis label, while Galois
conjugation changes the golden realization and preserves the
decomposition side.

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

### Highest-EV cross-paper actions

1. Recast the boxed identity as an intrinsic quotient theorem and test
   whether the four symmetric correction terms have a direct code,
   discriminant, or moment interpretation.
2. Contract the C651 tensor through the primitive mod-\(11\) transvectant
   and determine its scalar on \(V_4\).
3. Prove the pointed-port-to-unordered-Petersen-cubic corollary with exact
   equivalence conventions.
4. Derive a Kneser negative-eigenspace lower bound for prescribed-hole
   defect.
5. Test the two \(q=11\) PRS exceptional nets against the transvectant
   kernel orbit.
6. Build the \(A_5\)-quotient of the \(4180\) Clebsch pair-extension set
   before touching the full replacement graph.

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

The latest `ej` pass closes the degree-six mystery rather than merely
cataloguing two invariants.  Character theory gives dimensions
\(7\supset5\supset4\) for \(A_5\)-invariants, outer-\(S_5\)-even
invariants, and ordinary \(S_6\)-symmetric invariants.  The one-dimensional
outer-even/symmetric quotient forces the corrected relation in
Section 11 once the exact projective ratio \(4:125\) is known.

The Tao-style caution is equally sharp: equality in a one-dimensional
quotient is the intrinsic result.  It does not make the four symmetric
correction terms disappear, identify the arithmetic covers, or remove the
chosen synthematic total.  The next conceptual gain would be to interpret
that symmetric correction, not to rescale it away.

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
- **Settled on boundary representatives:** both lower-dimensional orbit
  types retain rank four and have exactly Hitchin's isotropic weight-space
  kernels; rank alone has one extra tangent direction at the closed orbit.
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
- **Settled negatively:** support complementation swaps face and non-face
  support orbits, while Galois/Gale conjugation preserves the face orbit.
  They are transverse commuting \(C_2\)-operations, not one involution.
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
- **Settled as a coordinate identity, not intrinsically:** with C651's
  selected intertwiner,
  \(c_{\mathrm{match}}^2=J_0|_V\) and
  \(w=\pm4c_{\mathrm{match}}\) over \(\mathbf F_{11}\).  The scalar and
  torsor comparison remain gates.
- **Settled:** the completed two-branch model is the universal
  residue-field pinch \(\mathbf Q+\mathfrak m\), with depth-one defect
  exactly \(\mathbf Q(\sqrt5)/\mathbf Q\).
- **Open:** decide whether rank four plus isotropic kernel cuts out the
  entire Mukai--Umemura compactification, and analyze every boundary rank
  stratum.
- **Open:** compare the binary and Euclidean normalizations and compute the
  scalar of \(T_{I_t}|_{V_t}\) in the paper's conventions.
- **Open:** verify that the two invariant harmonic lines are distinct and
  prove that the conjugate operator pair has discriminant class \([5]\).
- **Open:** determine whether the odd determinant character of the third
  transvectant is the same geometric orientation character as Hitchin's
  incidence involution, rather than merely an analogous sign.
- **Open:** contract the C651 finite matching tensor through the primitive
  mod-\(11\) map and fix the resulting cubic scalar.
- **Open:** identify the relevant Paper II orientation cover over the now
  fixed ten-point carrier; C651 fixes the \(A_5\)-module but not an outer
  sheet action or its normalization.
- **Open:** find an intrinsic code, discriminant, or moment interpretation
  of the four-term symmetric correction in the corrected sextic identity.
- **Open:** formalize the exact pointed-port-to-unordered-Petersen-cubic
  reconstruction corollary.
- **Open:** turn the shared \(KG(k,2)\) negative eigenspace into a numerical
  lower bound for prescribed-hole defect.
- **Open:** audit classical and modern literature before any novelty or
  manuscript-disposition claim.

C682 remains open.  The user retains stopping authority.
