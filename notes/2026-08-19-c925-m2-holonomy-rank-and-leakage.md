# Module 21C. Holonomy, rank, and leakage

**Packet part:** Module 21.17--21.22.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

## 21.17 Sparse reconstruction as a torsor-lift problem

The reconstruction results in the other papers have a common exact core:
either the chosen shadows are proved complete, or a residual marking is kept
which selects one lift through a nontrivial forgetful fibre.  The following
graph theorem isolates the path-tracking part without asserting that a
particular geometric fibre has this form.

Let \(Q\) be a connected graph, let \(\Pi(Q)\) be its path groupoid, and let
\(G\) be a group.  A **torsor local system** on \(Q\) consists of a nonempty
right \(G\)-torsor \(X_v\) at each vertex and a \(G\)-equivariant bijection

\[
\tau_e:X_v\longrightarrow X_w
\tag{21.36}
\]

for every oriented edge \(e:v\to w\), with
\(\tau_{e^{-1}}=\tau_e^{-1}\).  A compatible lift is a choice
\(x_v\in X_v\) satisfying \(\tau_e(x_v)=x_w\) for every edge.

### Theorem 21.8 -- torsor reconstruction is exactly trivial holonomy

Fix a base vertex \(b\) and \(x_b\in X_b\).  There is a compatible lift
extending \(x_b\) if and only if every based-loop transport fixes \(x_b\):

\[
\tau_\ell(x_b)=x_b
\qquad(\ell\in\operatorname{Aut}_{\Pi(Q)}(b)).
\tag{21.37}
\]

Because the action on a torsor is free and every transport is
\(G\)-equivariant, this is equivalent to trivial holonomy on all of \(X_b\).
When it exists, the extension of the fixed base point is unique.  In
particular:

1. if \(Q\) is a tree, every base lift extends uniquely and the set of all
   compatible lifts is itself a right \(G\)-torsor;
2. on an interval with both endpoint lifts prescribed, a compatible lift
   exists exactly when transport along the interval sends the first endpoint
   lift to the second;
3. a graph map, or more generally a functor of path groupoids
   \(F:\Pi(P)\to\Pi(Q)\), pulls the local system and its holonomy back.  It
   does not in general trivialize that holonomy.

### Proof

Choose paths \(p_v:b\to v\) and define
\(x_v=\tau_{p_v}(x_b)\).  This is independent of the chosen path precisely
when every loop \(p_vp_v'^{-1}\) fixes \(x_b\), which is (21.37); edge
compatibility and uniqueness then follow.  A tree has a unique reduced path
from \(b\) to each vertex.  The interval statement is the same construction
with its terminal value prescribed.  Pullback replaces every transport
\(\tau_p\) by \(\tau_{F(p)}\), so it replaces each loop holonomy by its
image under \(F\).  ∎

After choosing one point in every fibre, the edge transports are encoded by
a nonabelian graph \(1\)-cocycle with values in \(G\); changing those choices
is vertexwise gauge.  Theorem 21.8 says exactly that a compatible lift exists
when this cocycle has neutral gauge class.  For a path theory with imposed
2-cells, the products around the corresponding boundary loops must also be
the identity.  This is the elementary cohomological form of the
Beck--Chevalley requirement.

This explains what the sparse-shadow precedents do and do not import.  A
marked bridge kills a residual \(C_2\)-torsor; a retained removed-root marker
chooses a polar-contraction lift; and a proved complete weighted shadow has
singleton fibres.  An affine frame residual that remains uncontrolled is the
opposite case.  These are structural precedents, not a theorem that the QDM
forgetful fibre is any particular torsor.

For the present packet, Proposition 19.3B identifies the candidate residual
group only **after** a common row-line carrier has been constructed.  A single
weak-factorization chain is a tree, so an arbitrarily chosen lift can always
be propagated along it.  That fact is useless for birational invariance unless
the propagated endpoint equals the canonical Gamma point row; by item 2 this
is exactly a boundary condition, not a formal consequence of having tracked
the path.  Parallel projections and overlap squares add loops, whose trivial
holonomy is exactly the missing marked Beck--Chevalley/provider theorem.

In effect notation, Reader contains the torsor local system and any path
functor, indexed State contains the chosen lift, and Writer contains the
holonomy and endpoint certificates.  A lens into a higher parallel
projection is lawful only when a bridge such as (21.33) makes that residual
cartesian.  Mapping paths without mapping this residual merely pulls the
obstruction back; it cannot recover information that was never marked.

## 21.18 A simple retained character forces the row line

There is one useful way for the higher projection to make the endpoint
condition automatic.  Let \(A\) be a unital \(K\)-algebra and let
\(\chi:A\to K\) be a character.  Write \(K_\chi\) for the resulting
one-dimensional left \(A\)-module.

### Theorem 21.9 -- simple-character row forcing

Let \(V_-\) and \(V_+\) be left \(A\)-modules and suppose

\[
\operatorname{Hom}_A(V_\pm,K_\chi)=K r_\pm
\tag{21.38}
\]

with \(r_\pm\ne0\).  Every \(A\)-linear isomorphism
\(\Phi:V_-\to V_+\) satisfies

\[
r_+\Phi=c_\Phi r_-
\qquad\text{for a unique }c_\Phi\in K^\times.
\tag{21.39}
\]

These scalars multiply under composition.  If the modules also carry
operators \(T_\pm\) and \(\Phi T_-=T_+\Phi\), then \(\Phi\) is an augmented
operator-row isomorphism.

### Proof

The composite \(r_+\Phi\) is a nonzero element of
\(\operatorname{Hom}_A(V_-,K_\chi)\), so (21.38) gives the unique nonzero
scalar in (21.39).  Substitution proves the composition law, and the final
claim is exactly the morphism law of \(\mathsf{AugOp}_K\).  ∎

### Corollary 21.9A -- semilinear character forcing

Let \(\alpha:A_-\xrightarrow\sim A_+\) be an algebra isomorphism, let
\(\chi_+\alpha=\chi_-\), and suppose
\(\Phi(av)=\alpha(a)\Phi(v)\).  If
\(\operatorname{Hom}_{A_\pm}(V_\pm,K_{\chi_\pm})=Kr_\pm\), then the same
conclusion \(r_+\Phi=c_\Phi r_-\) holds.  The scalars compose together with
the algebra maps.  This is the correctly typed form when a QDM comparison
includes a coordinate pullback; the proof is the same precomposition
argument after restriction of scalars along \(\alpha\).

Over a base ring, replace the two one-dimensional Hom spaces by invertible
rank-one modules.  Precomposition gives a canonical isomorphism of those line
modules, while a scalar \(c_\Phi\) appears only after choosing frames.  The
resulting line-bundle holonomy is precisely the residual tracked by Theorem
21.8; the line theorem does not trivialize it.

For a single retained endomorphism \(Q\), take \(A=K[t]\) and let \(t\) act
on \(K_\chi\) by \(\lambda\).  The hypothesis then says that the left
\(\lambda\)-eigenspace is the single row line.  Thus any intertwiner of
\(Q\) preserves that line.  More geometric candidates are an action
descending to a multiplicity-one generic-point quotient, or the coordinate
algebra of finite Fourier support with the character at exponent zero.  The
generic-point construction is canonically a quotient; it does not provide an
idempotent splitting on the QDM side.

This theorem pinpoints why the audited Hodge specialization is insufficient:
the trivial Hodge character occurs on every Tate direction, so (21.38) fails.
Formal monodromy already has three copies of each primitive-sixth character
on \(X\times\mathbf P^2\), before any exceptional packet is added.  A raw
cohomological grading separates the top cohomology line, but the Gamma point
row is a calibrated flat section rather than a bare \(\mu\)-eigenrow.  A
generic-point quotient separates rank on \(K\)-theory, but the fixed-phase
analytic blowup comparison has not been shown to descend to that quotient in
the Gamma frame.  Theorem 21.9 therefore gives another small provider
interface, not that missing linearity theorem.

## 21.19 Laurent grading alone has repeated characters

The grading candidate in Theorem 21.9 has an exact failure mode.  Let
\(e\ge1\), let \(V_i\) carry a diagonalizable endomorphism \(\mu_i\), and put

\[
M_i=K[z^{1/e},z^{-1/e}]\otimes_KV_i,
\qquad
\mathcal G_i=z\partial_z+\mu_i.
\tag{21.40}
\]

### Proposition 21.10 -- Laurent shifts collide grading characters

If \(a\) is an eigenvalue of \(\mu_i\), \(b\) is an eigenvalue of
\(\mu_j\), and \(a-b\in\tfrac1e\mathbf Z\), then the
\(\mathcal G\)-eigenvalue \(a\) occurs in both \(M_i\) and \(M_j\).
Consequently, on \(M_i\oplus M_j\), the corresponding left-character space
has dimension at least two and cannot satisfy (21.38).

### Proof

If \(\mu_i v=a v\) and \(\mu_j w=bw\), then

\[
\mathcal G_i(1\otimes v)=a(1\otimes v),
\qquad
\mathcal G_j(z^{a-b}\otimes w)=a(z^{a-b}\otimes w).
\tag{21.41}
\]

The two eigenvectors lie in distinct direct summands.  Their dual coordinate
rows give two independent left eigenrows.  ∎

Thus an intertwiner of the grading connection does not by itself preserve a
distinguished point row once the coefficient spine permits the Laurent or
ramified shifts used to align blowup branches.  The neutral toric calibration
in the source is consistent with this no-go: although its continuation gauge
intertwines the quantum and grading connections, point-row preservation is
deduced from the stronger Fourier--Mukai statement carrying
\(\mathcal O_p\) to \(\mathcal O_{p'}\).

A grading route can still work after retaining a bounded lattice or an
associated-graded extremal piece for which the shift in (21.41) is forbidden.
But preservation of that lattice/filtration is then the provider theorem;
forgetting it and retaining only \(\mathcal G\) reintroduces the collision.
Generic-point localization does not suffer this particular grading collision
because its quotient kills boundary-supported objects independently of
Laurent degree.  It supplies no canonical QDM idempotent; a bridge to that
quotient is still required.

## 21.20 Wall mutations fix a common-open point object

The support specialization has a standard categorical mechanism.  Let
\(\mathcal C\) be a triangulated category and let
\(i:\mathcal B\hookrightarrow\mathcal C\) be an admissible subcategory.  Its
left and right mutations are defined by the triangles

\[
ii^!x\longrightarrow x\longrightarrow L_{\mathcal B}x,
\qquad
R_{\mathcal B}x\longrightarrow x\longrightarrow ii^*x.
\tag{21.42}
\]

### Proposition 21.11 -- the orthogonal point is mutation-fixed

If

\[
p\in{}^\perp\mathcal B\cap\mathcal B^\perp,
\tag{21.43}
\]

then \(L_{\mathcal B}p\cong p\) and
\(R_{\mathcal B}p\cong p\).  Hence every composable word of left and right
mutations through wall-supported admissible subcategories fixes \(p\).

### Proof

The condition \(p\in\mathcal B^\perp\) gives \(i^!p=0\), so the first
triangle in (21.42) identifies \(L_{\mathcal B}p\) with \(p\).  The condition
\(p\in{}^\perp\mathcal B\) gives \(i^*p=0\), and the second triangle does the
same for \(R_{\mathcal B}p\).  Compose these isomorphisms.  ∎

For a point \(p\) in the common open complement of a wall, its skyscraper
object is orthogonal in both directions to perfect complexes supported on the
wall.  Suppose a pairing-preserving analytic continuation \(\Phi\) is known,
on the single Gamma-framed section \(s(\mathcal O_p)\), to realize such a
mutation word and hence

\[
\Phi s_-(\mathcal O_p)=s_+(\mathcal O_p).
\tag{21.44}
\]

Then its point rows satisfy

\[
r_{+,p}(\Phi v)
=\langle\Phi v,s_+(\mathcal O_p)\rangle
=\langle v,s_-(\mathcal O_p)\rangle
=r_{-,p}(v).
\tag{21.45}
\]

This recovers the neutral toric calibration and explains the window proposal
in the source.  It also compresses Theorem 21.2: compatibility is required on
one common-open point object, not on the entire Orlov decomposition.  It does
not prove (21.44).  Outside the calibrated toric cases, identifying the
fixed-phase continuation with a wall-mutation word on that Gamma section is
exactly the conjectural one-object/window provider.  Orthogonality alone
cannot identify an analytic continuation with a categorical mutation.

## 21.21 Generic rank is the universal support-null character

The high retained path itself has a canonical quotient, even though the QDM
bridge to it is missing.  Let \(Y\) be an integral regular noetherian scheme
with function field \(K(Y)\).  Let \(N_Y\subset K_0(Y)\) be the subgroup
generated by the images of \(K_0^Z(Y)\) as \(Z\) ranges over proper closed
subsets.

### Theorem 21.12 -- generic-point localization

Restriction to the generic point induces an isomorphism

\[
K_0(Y)/N_Y\xrightarrow{\ \sim\ }K_0(K(Y))\cong\mathbf Z,
\tag{21.46}
\]

and the map is generic rank.  Consequently, for every abelian group (or
\(\mathbf Z\)-module) \(A\), every group homomorphism
\(\epsilon:K_0(Y)\to A\) which kills every proper-supported perfect complex
has the unique form

\[
\epsilon(n)=a\,\operatorname{rk}(n)
\tag{21.47}
\]

for one element \(a\in A\), where multiplication by rank means the integer
action on \(A\).

### Proof

Localization shows that every class supported on a proper closed subset lies
in the kernel of generic restriction.  Conversely, represent a generic-rank
zero class by a difference of perfect complexes.  Over the field \(K(Y)\)
the corresponding \(K_0\)-classes agree, so after adding trivial summands
their generic fibres are isomorphic.  This isomorphism spreads out over some
dense open \(U\subset Y\).  The class therefore restricts to zero in
\(K_0(U)\), and the localization sequence for \(Y\setminus U\) places it in
\(N_Y\).  Finally \(K_0(K(Y))\cong\mathbf Z\) by dimension, proving (21.46),
and the universal property of the quotient proves (21.47).  ∎

### Corollary 21.12A -- a coniveau checklist for the rank row

Assume in addition that \(Y\) is smooth projective, and let
\(\epsilon:K_0(Y)\to K\) be additive.  If

\[
\epsilon([\mathcal O_Y])=1
\quad\text{and}\quad
\epsilon([\mathcal O_Z])=0
\tag{21.47a}
\]

for every proper integral closed subscheme \(Z\subsetneq Y\), then
\(\epsilon=\operatorname{rk}\).  Indeed, regularity identifies \(K_0(Y)\)
with coherent \(G_0(Y)\), and the support filtration plus devissage expresses
every proper-supported class as a sum of structure-sheaf classes of integral
closed subschemes.  Theorem 21.12 then applies.

Thus, **after** a Gamma/\(K_0\) realization has made a transported analytic
row into an additive \(K_0\)-functional, one normalization and
support-nullity on coniveau generators identify that functional with rank.
The corollary constructs neither the realization nor its naturality.  This is
weaker than constructing a full Gamma--Orlov square, but support-nullity of
the fixed-phase row is still an analytic assertion.  In the fivefold problem
one may restrict further to the exceptional primary generators which survive
the dimension bound only after a common primitive projector and its
intertwining have been supplied; the relative-cap computation is a proposed
way to test those generators.

For a birational map of smooth integral varieties, the function fields and
hence the quotients (21.46) are canonically identified.  In an Orlov blowup
decomposition every exceptional component is proper-supported and maps to
zero.  Thus the upper support path needed by the comma bridge is canonical
and one-dimensional; no choice of complement or support idempotent is
needed.

This theorem discharges the **high-path uniqueness** part of the proposed
rank bridge.  It does not construct a natural epimorphism from the Gamma/QDM
solution module to (21.46), nor prove that analytic continuation respects its
kernel.  Those are precisely \(\gamma\) and its naturality law in Theorem
21.6.  In particular, universal rank on \(K_0\) cannot be pulled through an
unproved Gamma realization merely because both sides have the same
dimension.

## 21.22 After realizing fixed rank quotients, the sole residual is leakage

Once the two full analytic row quotients have been supplied, their residual
comparison obstruction is a single covector.  Let

\[
0\longrightarrow N_\pm\longrightarrow V_\pm
\xrightarrow{r_\pm}K\longrightarrow0
\tag{21.48}
\]

be exact and let \(\Phi:V_-\xrightarrow\sim V_+\).  Define its **leakage** by

\[
\delta_\Phi=r_+\Phi|_{N_-}\in N_-^*.
\tag{21.49}
\]

### Proposition 21.13 -- zero leakage is exactly quotient naturality

The following are equivalent:

1. \(\delta_\Phi=0\);
2. \(\Phi(N_-)=N_+\) and \(\Phi\) induces an isomorphism on the
   one-dimensional quotients;
3. \(r_+\Phi=c_\Phi r_-\) for a unique \(c_\Phi\in K^\times\).

Zero-leakage maps are closed under composition and inverse.  After choosing
splittings \(V_\pm=Ks_\pm\oplus N_\pm\), a general comparison has blocks

\[
\Phi=
\begin{pmatrix}c&\beta\\u&A\end{pmatrix},
\qquad
\delta_\Phi=\beta,
\tag{21.50}
\]

and composition gives

\[
\begin{pmatrix}d&\gamma\\v&B\end{pmatrix}
\begin{pmatrix}c&\beta\\u&A\end{pmatrix}
=
\begin{pmatrix}dc+\gamma u&d\beta+\gamma A\\
vc+Bu&v\beta+BA\end{pmatrix}.
\tag{21.51}
\]

### Proof

Condition 1 says \(\Phi(N_-)\subseteq N_+\).  Since both kernels have
codimension one and \(\Phi\) is invertible, equality follows and the induced
quotient map is a nonzero scalar, proving 2 and 3.  Condition 3 immediately
implies 1.  Composition, inverse, and (21.51) are direct.  ∎

For the **full Gamma--rank bridge**, take
\(N=\ker(\operatorname{rk})\) on the high path and transport it objectwise to
the solution space.  Its missing arbitrary-blowup theorem is exactly
\(\delta_\Phi=0\), not an unidentified full-matrix condition.  This full row
statement is stronger than the minimal \(m=2\) primary Boolean.  After
applying the primitive-sixth projector, only the corresponding primary
leakage must vanish; when the projected row itself is zero, the zero-row case
of \(\mathsf{AugPrim}\), rather than the codimension-one quotient (21.48), is
the correct interface.

Proposition 21.11 kills full leakage when \(\Phi\) is realized by wall
mutations fixing the common-open point.  Theorem 21.9 kills it when a simple
retained character exists.  If a scalar relative-cap channel has first been
identified with this analytic leakage, Theorem 21.5 computes its exposed
associated-graded pieces; the coefficient \(-1/R\) is then a candidate
nonzero forbidden piece, and a proof must cancel it on its own face.  Theorem
21.5 is only a group-algebra initial-form law and does not make that analytic
identification.

Equivalently, the desired comparison is the assertion that the left arrow
exists and the following diagram commutes:

\[
\begin{CD}
N_- @>>> V_- @>{r_-}>> K\\
@V{\Phi|_{N_-}}VV @V{\Phi}VV @VV{c_\Phi}V\\
N_+ @>>> V_+ @>{r_+}>> K.
\end{CD}
\tag{21.52}
\]

The top and bottom rows are the full generic-rank quotients.  The middle arrow is
the analytic blowup comparison.  The left arrow and commutativity are not
additional provider fields: both exist exactly when the leakage covector
vanishes.

This identification is an exact synthesis, not a vanishing theorem.  The
audited sources prove zero leakage for ordinary flops and the stated toric
calibrations, but not for arbitrary codimension-two centers in fivefolds.

---
