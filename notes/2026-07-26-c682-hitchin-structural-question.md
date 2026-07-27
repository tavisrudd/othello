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
Whether this rational kernel map extends without modification across the
boundary of the two compactifications remains open.

The determinantal recognition proposal passes its first local gate.
Linearizing the \(13\)-by-\(7\) rank-at-most-four condition at
\(\Phi_{12}\) gives \(27\) kernel-to-cokernel equations of rank nine.
The affine tangent space therefore has dimension four, and its
projectivization has dimension three.  Since the \(PSL_2/A_5\) orbit
already has dimension three, the rank locus is smooth of the expected
orbit dimension at the Klein point.  In particular, the
Mukai--Umemura orbit closure is the local irreducible component of the
rank locus through that point.  This does not rule out remote components
or prove the boundary extension.

The deterministic certificate
`notes/2026-07-26-c682-transvectant-bridge.json` is generated and checked
by `notes/2026-07-26-c682-transvectant-bridge.py`.  From the repository
root, replay with

```text
python3 notes/2026-07-26-c682-transvectant-bridge.py --check
python3 notes/2026-07-26-c682-transvectant-bridge-replay.py
```

The computation certifies the displayed transvectant matrix, rank, kernel,
all six fifth-transvectant isotropy identities, and the
nine-dimensional linearized constraint rank over \(\mathbf Q\).  It does
not identify the paper's Euclidean rational form, the normalization scalar,
global boundary components, boundary extension, or a global incidence
morphism.
The representation-theoretic proof is independent of the matrix
calculation.  A separate implementation replays the rank, isotropy, and
tangent calculation modulo \(101\); its nonzero minors independently
confirm the lower rank bounds used by the exact rational calculation.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-26-c682-transvectant-bridge.py` | 8983 | `a63a362769f871ace4b60b0b6ce0f9a85a00d906b12a5f3e8af2e1fe8b554972` |
| `2026-07-26-c682-transvectant-bridge-replay.py` | 4560 | `7c965c6ec530c641497c48ac476acc1cb8137200aaf22ed356364a477b9428ca` |
| `2026-07-26-c682-transvectant-bridge.json` | 3029 | `cdd2b97ec45afe731fdd667d86f1c3f302fe0c58760009524cedf29080ffbf9c` |

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
- **Open:** audit classical and modern literature before any novelty or
  manuscript-disposition claim.

C682 remains open.  The user retains stopping authority.
