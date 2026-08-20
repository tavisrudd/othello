# C925: two-hour (m=2) provider attack and hostile audits

Date: 2026-08-19  
Status: exploratory mathematics only; C925 remains open  
Scope: no manuscript edits and no Lean formalization

## Rules of engagement

The target is an unconditional transport theorem for the pointed
primitive-sixth cyclic/Gamma rank row along a fivefold weak factorization.
None of the following may be used as an implicit input:

- arbitrary-master gauged admissibility;
- a common marked threshold object;
- zero-mode preservation of the row-generated cyclic module;
- a global two-sided row-null ideal;
- a common coefficient spine for all formal blowup expansions; or
- Gamma-integral, Orlov, or rank-row compatibility not stated in a source.

Every possible shortcut is recorded as **proved**, **conditional**,
**conjectural**, or **false**.  A local statement is not promoted to a
pathwise statement without a composition proof.

## Source addition: Iritani's 2026 blowup note

The complete source of Hiroshi Iritani, *Notes on the decomposition theorem
for blowups*, arXiv:2604.10028, was read before using it here.  Its precise
new inputs are:

1. the formal blowup QDM decomposition and coordinate changes are
   cyclotomic (Proposition `prop:cyclotomic`);
2. the coordinate changes and decomposition map are equivariant for the
   universal Hodge group (Proposition `prop:Hodge-equivariance`);
3. hence they preserve complexified Hodge classes, and similarly algebraic
   classes (Corollary `cor:Hodge-fixed` and the following remark); and
4. the initial decomposition has explicit large-exceptional-parameter
   asymptotics (`item:asymp_Psi`).

The paper contains no theorem asserting Gamma-integral, K-theoretic, Orlov,
Euler-rank-row, or point-row compatibility.  All Tate classes are fixed by
the Hodge group, so Hodge equivariance alone cannot distinguish an ambient
point class from exceptional Tate classes.  Treating it as the missing
marked-threshold theorem would be hypothesis smuggling.

## Block 1: the weakest local point-marked statement

Let \(\varphi:\widetilde Y\to Y\) be the blowup of a smooth projective
variety along a positive-codimension smooth center \(i:Z\hookrightarrow Y\).
Write Iritani's decomposition as
\[
 \Psi=(\Psi_Y,\Psi_{Z,0},\ldots,\Psi_{Z,r-2}).
\]
At \(Q=\widetilde\tau=0\), its stated asymptotics give
\[
 \Psi_Y(\varphi^*\alpha)=\alpha+O(\mathfrak q^{-1}),
 \qquad
 q_{Z,j}^{-1}\Psi_{Z,j}(\varphi^*\alpha)
 =i^*\alpha+O(\mathfrak q^{-1/(r-1)}).
\tag{1.1}
\]
For \(\alpha=[p_Y]\in H^{2\dim Y}(Y)\), degree forces
\(i^*[p_Y]=0\).  Therefore
\[
 \Psi_Y(\varphi^*[p_Y])=[p_Y]+O(\mathfrak q^{-1}),
 \qquad
 \operatorname{in}\!\left(q_{Z,j}^{-1}
 \Psi_{Z,j}(\varphi^*[p_Y])\right)=0.
\tag{1.2}
\]

### Lemma 1.1 -- one-edge principal-symbol point marking

For the filtration and normalization appearing in Iritani's one-blowup
formal decomposition, the principal symbol of the canonical point class lies
entirely in the base summand.  Its base symbol is the canonical point class,
and all normalized center symbols vanish.

**Verdict: proved.**  This is exactly (1.1)--(1.2); it uses no Gamma or
analytic-threshold claim.

### Corollary 1.2 -- local positive-valuation telescope

In one fixed filtered coefficient category, maps congruent to the identity
modulo strictly positive valuation compose and induce the identity on the
associated graded.  Thus the principal-symbol point marker is unchanged by
any finite composite formed inside that one category.

**Verdict: proved algebraically, conditional geometrically.**  The ideal of
strictly positive-valuation morphisms is two-sided in a fixed filtered
category.  Iritani's theorem supplies such a category for one blowup.  It
does not supply one category receiving every expansion in an arbitrary
weak-factorization path.

### Candidate pathwise strengthening

One would like a common Hahn/Rees coefficient spine \(R_\Gamma\) for a
finite factorization path such that:

1. every edge's large-exceptional-parameter expansion embeds faithfully in
   \(R_\Gamma\);
2. every edge error has positive value for one global filtration;
3. all coordinate changes agree on the intermediate QDMs; and
4. the primitive-sixth cyclic projector and the horizontal Gamma row are
   strict for this filtration, including at zero modes.

Then positive-valuation maps would give the global two-sided ideal required
by Module 19.3, and Lemma 1.1 would supply its point-marked associated
graded.

**Verdict: conjectural.**  Iterated Laurent series solve the purely formal
problem only when the monomial embeddings and completion orders are jointly
compatible.  A weak-factorization zigzag gives different effective monoids,
coordinate changes, and exceptional valuations on the same intermediate
QDM.  No common faithful embedding, no joint well-ordering of supports, and
no zero-mode strictness theorem has yet been proved.

## Initial truth table

| retained input | one-edge base point | one-edge center point | arbitrary path | verdict |
| --- | ---: | ---: | ---: | --- |
| Hodge equivariance only | not distinguished | not distinguished | no | insufficient |
| algebraic-class preservation only | preserved as some algebraic class | also algebraic | no | insufficient |
| explicit normalized principal symbol | \([p]\) | \(0\) | not supplied | proved locally |
| principal symbol + one global filtered spine | \([p]\) | \(0\) | yes, formally | conditional on provider |
| Gamma row + separately chosen edgewise spines | nonzero locally | intended zero | no composition law | insufficient |

The live question after Block 1 is therefore narrower than the original
marked-threshold package: can the one-edge principal-symbol filtration be
made global and compatible with the primitive-sixth Gamma cyclic row without
assuming the desired transport theorem?

### Finite countermodel 1.3 -- Hodge, pairing, and operator do not force the row

Take a four-dimensional rational vector space with ordered basis
\((u,p,e,f)\), symmetric pairing
\[
B=\begin{pmatrix}
0&1&0&0\\1&0&0&0\\0&0&0&1\\0&0&1&0
\end{pmatrix},
\]
and let the Hodge group act trivially.  Put
\[
S=\begin{pmatrix}
1&0&0&-1\\0&1&0&0\\0&1&1&0\\0&0&0&1
\end{pmatrix},
\qquad
T=\operatorname{diag}(1/2,2,2,1/2).
\tag{1.3}
\]
Exact rational calculation gives
\[
S^{\mathsf T}BS=B,
\qquad ST=TS,
\qquad S(p)=p+e.
\tag{1.4}
\]
The point row \(r=B(p,-)=(1,0,0,0)\) changes to
\[
rS=(1,0,0,-1)\ne r.
\tag{1.5}
\]
Thus Hodge equivariance, pairing preservation, and operator intertwining do
not logically imply point-row preservation.  This model does not claim to
realize a geometric QDM; it falsifies the proposed formal implication.

**Verdict: proved countermodel.**  It is replayed exactly by
`hodge_pairing_operator_do_not_force_point_row` in
`notes/cubic-threefolds-tasks/c925-categorical-law-check.py`.

## Hostile audit 1 -- local formal purity is not Gamma transport

This audit cross-checked the proposed shortcut against the complete C907
notes `2026-08-13-c907-coniveau-principal-symbol-repair.md` and
`2026-08-13-c907-formal-point-covector-frame-gap.md`.

### Step verdicts

1. **Top-class restriction.  PROVED.**  For every proper smooth center,
   \(i^*[p_Y]=0\).
2. **Exceptional-cusp point purity.  PROVED.**  Iritani's initial formal
   decomposition and its normalized principal symbol give (1.2).
3. **Identification with the intrinsic Gamma point section.  NOT PROVED.**
   The formal theorem is normalized at \(\mathfrak q=\infty\), after passage
   to a Laurent completion in \(\mathfrak q^{-1/s}\).  The intrinsic Gamma
   section is normalized at the effective large-radius boundary
   \(\mathfrak q=0\).  The large-radius series need not belong to the Laurent
   completion at infinity.  The connection matrix between these frames can
   have a nonzero center row.
4. **Hodge-equivariance shortcut.  FALSE.**  Countermodel 1.3 proves that
   Hodge, pairing, and operator data do not force the point row.
5. **One global positive-valuation ideal.  NOT PROVED.**  Edgewise Laurent
   completions neither provide a common coefficient spine nor identify the
   large-radius Gamma frames.
6. **The proposed row-null quotient in Module 21.  FALSE AS STATED.**  For a
   fixed row \(r\),
   \(\{e:r e=0\}\) is generally only a right ideal.  With
   \(r=(1,0)\), \(e=E_{21}\), and \(a=E_{12}\), one has
   \(re=0\) but \(r(ae)=rE_{11}\ne0\).  Therefore it does not define the
   ambient two-sided quotient invoked there.

### EJ -- extra juice

- The row-null quotient is unnecessary for actual transitions.  Objects
  \(r_V:V\to\mathbf1\) and arrows \(f:V\to W\) satisfying
  \(r_Wf=r_V\) form the comma category \((\mathcal C\downarrow\mathbf1)\).
  Such arrows compose, and an invertible row-preserving arrow has a
  row-preserving inverse.  This removes the global **two-sided ideal** as an
  independent categorical gate.
- If scalar normalization is allowed, use the augmented operator category
  whose morphisms satisfy
  \[
  fT_A=T_Bf,
  \qquad r_Bf=c_f r_A.
  \tag{1.6}
  \]
  Inside this restricted category the maps with \(c_f=0\) do form a
  two-sided ideal: \(c_{gf}=c_gc_f\).  Normalized comparisons are the
  invertible \(c_f=1\) arrows.  Thus the ideal is a consequence of a lawful
  row-line-compatible provider, not additional geometry.
- If a genuine common-open realization functor
  \(R:\mathcal C\to\mathcal D\) can be constructed, its morphism kernel is
  automatically a two-sided ideal.  This is a legitimate alternative to the
  false raw row-kernel quotient.  Algebraic recollement supplies such a
  functor for `Perf`; no compatible QDM/Gamma open-restriction functor is
  currently known.
- For the naked row kernel in the full matrix category the defect is worse
  than failure of a proof: in \(M_2(K)\), the two-sided ideal generated by
  \(E_{21}\) contains \(E_{12}E_{21}=E_{11}\) and
  \(E_{21}E_{12}=E_{22}\), hence the identity.  Forcing two-sided closure
  trivializes the quotient.
- The formal point-purity observation was not forgotten after all: C907 had
  already isolated it, the two-completion obstruction, the exact
  cubic-center and split-complete-intersection pilots, and the reduction of a
  rank-two nonsplit normal bundle to one deformation/gluing lemma.

### TT -- Terence-Tao pass

- Label both asymptotic boundaries and both coefficient rings on every arrow.
  A vector pure in the exceptional-cusp frame is not thereby pure in the
  large-radius Gamma frame.
- Replace the broad ideal question by the minimal scalar question: for every
  primitive-sixth exceptional branch \(a\), is the large-radius-to-cusp
  center coefficient
  \([s_{\mathrm{pt}},s_{\mathrm{exc},a})\) zero?
- Attack the first nonvacuous hostile geometry, not a toric example with an
  empty primitive-sixth center.  The regression
  \(\operatorname{Bl}_X\mathbf P^5\) is the correct test and is already known
  to pass by the Kummer reciprocal-Gamma zero.  The next honest target is the
  deformation invariance of this one row for a nonsplit rank-two normal
  bundle.
- A log-Gromov--Witten theory is invariant under log modifications, but this
  does not yet help: no theorem identifies its endpoint connection with the
  absolute primitive-sixth Gamma row.  Calling log modification invariance
  the missing common-open functor would simply move the provider hypothesis.

### Audit-1 boundary

The unconditional gain is local formal point purity plus a simplification of
the categorical telescope.  There is still no unconditional passage from
that purity to the large-radius Gamma rank row, hence no unconditional
\(m=2\) theorem at this checkpoint.

## Block 2: replace the naked row quotient by an arrow category

The comma-category repair in Audit 1 can be made additive and can include a
zero projected row without choosing a scalar normalization.

### Definition 2.1 -- augmented operator-row category

Let \(K\) be a field.  Define \(\mathsf{AugOp}_K\) as follows.

- An object is \(A=(V_A,T_A,L_A,r_A)\), where \(V_A,L_A\) are
  finite-dimensional \(K\)-vector spaces, \(T_A\in\operatorname{End}(V_A)\),
  and \(r_A:V_A\to L_A\).
- A morphism \((f,\ell):A\to B\) consists of linear maps
  \(f:V_A\to V_B\) and \(\ell:L_A\to L_B\) satisfying
  \[
  fT_A=T_Bf,
  \qquad
  r_Bf=\ell r_A.
  \tag{2.1}
  \]
- Composition and addition are componentwise.

This is the operator-enriched arrow category of vector spaces.  In the
rank-row application \(L=K\), and \(\ell\) is the permitted scalar change of
row normalization.  The case \(r=0\), including an empty projected primary
sector, is an ordinary object rather than an exception.

### Theorem 2.2 -- lawful row-output telescope

The category \(\mathsf{AugOp}_K\) is preadditive.  The output functor
\[
\mathsf{Out}:\mathsf{AugOp}_K\longrightarrow\mathsf{Vect}_K,
\qquad
(V,T,L,r)\longmapsto L,
\quad(f,\ell)\longmapsto\ell
\tag{2.2}
\]
is additive, and
\[
\mathcal J(A,B)=\{(f,0):r_Bf=0,\ fT_A=T_Bf\}
=\ker\bigl(\mathsf{Out}_{A,B}\bigr)
\tag{2.3}
\]
is a two-sided ideal.  If \((f,\ell):A\to B\) is an isomorphism, then for
every polynomial \(p\in K[t]\),
\[
r_Ap(T_A)\ne0
\quad\Longleftrightarrow\quad
r_Bp(T_B)\ne0.
\tag{2.4}
\]

#### Proof

Equation (2.1) is preserved by sums and scalar multiples, so every Hom set is
a vector space.  It is preserved by composition because
\[
r_C(gf)=m(r_Bf)=m\ell r_A,
\qquad
(gf)T_A=T_C(gf).
\]
Thus composition is bilinear.  The functoriality and additivity of
\(\mathsf{Out}\) are immediate.  Kernels of additive functors on Hom groups
are two-sided ideals: if \(x\in\ker\mathsf{Out}\), then
\(\mathsf{Out}(axb)=\mathsf{Out}(a)0\mathsf{Out}(b)=0\).

Polynomial naturality gives \(p(T_B)f=fp(T_A)\).  Hence
\[
r_Bp(T_B)f=r_Bfp(T_A)=\ell r_Ap(T_A).
\tag{2.5}
\]
For an isomorphism both \(f\) and \(\ell\) are invertible, so either side of
(2.5) vanishes exactly when the corresponding projected row vanishes. ∎

### Consequence 2.3 -- the correct primitive-sixth consumer

Take \(p=e_{\zeta_6}\), the polynomial primary projector after a fixed
half-Tate normalization.  The Boolean
\[
b_{\zeta_6}(A)=[r_Ae_{\zeta_6}(T_A)\ne0]
\tag{2.6}
\]
is invariant under isomorphisms in \(\mathsf{AugOp}_K\).  Exact equality of
Gamma normalizations is unnecessary: an invertible scalar \(\ell\) is enough.
Equivalently, the provider must preserve the **row line**, not a chosen row
vector.

**Verdict: proved algebraically.**  This repairs variance as well: \(r\) is a
covector and the comparison law is \(r_B\circ f=\ell\circ r_A\), never the
ill-typed expression \(f(r_A)=r_B\).

### What this does and does not remove

- **Removed:** the need to posit a naked global two-sided row-null ideal;
  the need to preserve an absolute nonzero scalar normalization; and the
  false assertion that every row-preserving map is a rank-one shear.
- **Still required:** one common provider in which every wall comparison,
  overlap 2-cell, and reduced zero-mode receiver supplies an isomorphism
  satisfying (2.1).  Constructing those squares is the marked-threshold
  theorem in weakened, row-line form.
- **Optional quotient:** once the provider lands in \(\mathsf{AugOp}_K\), the
  quotient by \(\mathcal J=\ker\mathsf{Out}\) is legitimate.  For a single
  ordered path it is unnecessary; composing isomorphisms in
  \(\mathsf{AugOp}_K\) already proves (2.6).

## Hostile audit 2 -- the categorical repair does not create the provider

### Step verdicts

1. **Coordinate-pseudonatural marker interface.  PROVED AS A REPAIR.**  A
   third law under invertible formal bulk-coordinate pullback is necessary.
   The uncentered Euler-eigenvalue function is the counterexample to the old
   two-law universal claim.  The concrete centered cubic marker already
   satisfies the added law, so the \(m=1\) proof is unaffected.
2. **Preadditivity and variance of \(\mathsf{AugOp}_K\).  PROVED.**  Rows are
   covectors \(r:V\to L\); (2.1), not a covariant expression \(f(r)=r'\), is
   the typed law.
3. **Two-sidedness of \(\ker\mathsf{Out}\).  PROVED.**  It is a functor
   kernel, unlike the raw row annihilator.  Exact replay also verifies that
   the two-sided closure of the raw \(M_2\) example contains the identity.
4. **Boolean invariance under actual augmented-row isomorphisms.  PROVED.**
   Equation (2.5) proves it for any fixed polynomial \(p\).
5. **Boolean invariance under quotient isomorphisms.  PROVED.**  If a class
   \([(f,\ell)]\) is invertible modulo \(\ker\mathsf{Out}\), the output maps
   of a quotient inverse imply that \(\ell\) is invertible.  The forward
   relation (2.5) and its quotient inverse give both nonvanishing directions.
   A singular rank-one carrier map representing a quotient isomorphism was
   replayed exactly.
6. **Exact Gamma normalization.  UNNECESSARY FOR THIS CONSUMER.**  A nonzero
   scalar output map \(\ell\) preserves the Boolean.  This weakens the desired
   wall theorem from row equality to row-line compatibility.
7. **Primitive-sixth projector naturality.  CONDITIONAL ON THE COMMON
   NORMALIZATION ALREADY LISTED.**  The same polynomial
   \(e_{\zeta_6}\) must be formed on one coefficient spine after the
   half-Tate/deck normalization, with the primitive-sixth primary factor
   coprime to its complement.  At a collision, all generalized
   primitive-sixth vectors belong to the same primary receiver; they may not
   be discarded by choosing a tailwise projector.
8. **Geometric landing in \(\mathsf{AugOp}_K\).  OPEN.**  The definition of a
   morphism already asks for the row-line compatibility that the analytic
   proof must establish.  The category removes an algebraic gate; it does not
   prove a wall comparison, an overlap 2-cell, or a zero-mode receiver.

### EJ -- extra juice

- The provider need preserve only the projective row line.  Constant
  normalization changes, Barnes scalars, and compatible branch rescalings
  are harmless.
- The Reader should retain a named augmented-row output/realization functor,
  deriving any error ideal as its kernel.  This prevents a wall from silently
  changing the meaning of “row-null” in indexed State.
- The same arrow-category construction works for nilpotent, Hodge,
  coniveau, or multi-shadow outputs: replace \(T\) and \(L\) by the retained
  operations and output object.  It is the categorical common denominator of
  the direct-QDM, Guéré-probe, and pointed-primary consumers.
- The universal \(m=1\) ledger becomes more honest, not less modular, after
  indexing coordinate-dependent observations and coarsening only at the
  consumer.

### TT -- Terence-Tao pass

- Ask first whether the comparison lands in the arrow category.  If it does,
  the ideal and telescope are automatic; if it does not, naming a quotient
  cannot repair it.
- At a zero mode, require an invertible output map on the row line.  Equality
  of dimensions, annihilators, formal monodromy, or separately computed
  moments cannot substitute for that square.
- Do not let “projective row line” hide path monodromy: the accumulated scalar
  around a loop may be nontrivial.  The Boolean is insensitive to it, but a
  stronger normalized invariant or comparison 2-cell is not.
- A rank-one shear is merely one sufficient local normal form.  General
  row-preserving automorphisms need not have rank-one error.

### Audit-2 boundary

The false ideal construction and row variance are repaired, and the provider
theorem is strictly weakened from normalized-row preservation to row-line
compatibility.  The reduced zero-mode row-survival statement remains wholly
unproved and is the next audit target.

## Block 3: zero-mode descent in the dual row module

The zero-mode hypothesis in the existing draft asks for strict isomorphisms
of row-generated cyclic modules after quotienting nearby cycles by the
variation-generated submodule.  At the finite-module level, the dual-row
variance makes the quotient step much simpler.

### Theorem 3.1 -- covector Krylov descent through a stable quotient

Let \(R\) be a commutative ring, let \(M\) be an \(R\)-module with
\(T\in\operatorname{End}_R(M)\), and let \(r:M\to L\) be an \(R\)-linear
row.  Suppose \(V\subset M\) is \(T\)-stable and \(r(V)=0\).  Put
\(\overline M=M/V\), with quotient \(q:M\to\overline M\) and induced operator
\(\overline T\).  Then:

1. there is a unique row \(\overline r:\overline M\to L\) with
   \(r=\overline r q\);
2. for every \(k\ge0\),
   \[
   (\overline r\,\overline T^k)q=rT^k;
   \tag{3.1}
   \]
3. pullback along \(q\) identifies the row-generated modules
   \[
   C_{\overline T}(\overline r)
   \xrightarrow[\ q^*\ ]{\ \sim\ }
   C_T(r);
   \tag{3.2}
   \]
4. for every polynomial \(p\in R[t]\),
   \[
   \overline r\,p(\overline T)\ne0
   \quad\Longleftrightarrow\quad
   r\,p(T)\ne0.
   \tag{3.3}
   \]

If a deck group \(G\) stabilizes \(V\), the same statements hold after
adjoining the full \(G\)-orbits of the rows.

#### Proof

The first assertion is the universal property of \(M/V\).  Since
\(qT=\overline Tq\), induction gives (3.1).  Pullback along the surjection
\(q\) is injective on Hom modules, and (3.1) says that its image on the
displayed cyclic module is exactly \(C_T(r)\), proving (3.2).  Polynomial
linearity gives (3.3).  Deck equivariance is identical because stability of
\(V\) makes every deck transform descend. ∎

### Consequence 3.2 -- a smaller zero-mode consumer gate

For the finite dual cyclic module and the final primitive-sixth Boolean, it is
enough that:

1. the variation-generated submodule \(V_t(\mathcal M)\) be stable under the
   normalized formal monodromy and deck action;
2. the common-open point row annihilate \(V_t(\mathcal M)\); and
3. the quotient be a legitimate finite locally free receiver carrying the
   two boundary row-line maps.

No complementary summand and no pairing-based proof of
\(V_t(\mathcal M)\cap K=0\) is needed to descend a **dual** cyclic row.  If
the Gamma/window description really identifies \(V_t(\mathcal M)\) with
wall-supported classes, Euler orthogonality of the common-open skyscraper
would give condition 2 directly.

**Verdict: proved for modules; conditional for strict Rees--Stokes objects.**
The theorem does not construct the meromorphic family, prove strictness of
the quotient, identify the intrinsic Gamma row with the common-open
skyscraper row, or supply the two boundary maps.  Those analytic statements
remain provider obligations.  What it removes is the additional
column-intersection/spanning argument after row annihilation has already been
proved.

## Hostile audit 3 -- duality simplifies the consumer, not the provider

This audit was taken at the sixty-minute boundary.

### Step verdicts

| step | status | hostile finding |
|---|---|---|
| Theorem 3.1 on underlying modules | **proved** | Surjectivity of the quotient makes pullback on rows injective; \(T\)-stability and \(r(V)=0\) identify every cyclic generator. |
| necessity of row-nullity | **proved/tested** | A row nonzero on the discarded stable line cannot factor through the quotient.  The exact finite negative test is green. |
| strict decorated enhancement | **formal conditional** | In a rigid exact category with exact duality, strict dual exactness comes for free *after* a strict finite-locally-free quotient exists.  Rigidity does not construct that quotient. |
| zero-mode application | **open** | The common meromorphic family, strict quotient, row-nullity of the variation submodule, and endpoint boundary maps are still provider data. |
| direct augmented-row blowup criterion | **proved implication, conditional premise** | Per-edge intrinsic augmented-row isomorphisms would compose without masters, thresholds, zero modes, or an ideal.  No audited source supplies those isomorphisms with the Gamma row. |
| Orlov/Gamma rank forcing | **proved implication, stronger premise** | An analytic comparison lifting Orlov's \(K_0\) decomposition forces the row because generic rank is ambient rank plus zero on every exceptional component.  The Gamma--Orlov square is not proved for arbitrary smooth blowups. |
| two-wall common-open row theorem | **open and smaller** | C907 already isolated \(r(T-1)=0\), or output support in the boundary, as the minimal aggregate theorem.  It is strictly weaker than a full Gamma--Orlov lift. |
| \(m=2\) | **not proved** | Neither the direct per-edge Gamma square nor the weaker two-wall numerical Fourier/window theorem has been supplied. |

One tempting apparent shortcut is explicitly rejected.  The earlier
`2026-08-14-c907-punctual-tail-shadow.md` records an optimistic fixed-POT
constancy claim, but the referee correction in
`2026-08-14-c907-holonomic-point-row-gluing.md` states that the clutching
description does not establish equality of the fixed stacks, universal
curves, evaluations, POTs, or virtual classes and that the manuscript keeps
this as a hypothesis.  It is therefore not a forgotten unconditional
theorem and is not imported here.

Likewise, the rank-zero-target Stokes lemma is exact **given** output support:
if each canonical complete residue block lands in the boundary-supported
Gamma span, the common-open row kills every target and hence their product.
The source-boundary audit says that this support theorem is known in crepant
toric and some weak-Fano toric settings, not for the general discrepant
two-wall transitions required by an arbitrary fivefold factorization.

### EJ -- extra juice

1. Once a genuine strict zero-mode quotient and row-nullity exist, exact
   duality removes the extra column-intersection, complement, and spanning
   arguments.  The remaining zero-mode gate is smaller than the manuscript's
   first presentation, but is not empty.
2. Orlov \(K_0\) is a useful parallel state projection.  The rank getter
   satisfies
   
   \[
   \operatorname{rk}_{\widetilde Y}\Theta_K
   =(\operatorname{rk}_Y,0,\ldots,0),
   \]
   so a Gamma-natural path map could read the forgotten row back from this
   higher path without reconstructing the full QDM transition.
3. The row-line stabilizer has explicit affine-parabolic coordinates
   \(H\rtimes\operatorname{GL}(H)\) (and a scalar for row-line rather than
   exact-row preservation).  These coordinates identify exactly which
   residual state the Boolean is allowed to forget.

### TT -- Terence-Tao pass

- Separate a theorem that *forces* the desired row from a theorem that
  *constructs* the analytic comparison.  The Orlov rank calculation is the
  former only.
- Work on the smallest quotient on which a contradiction lives.  The
  common-open rank row is enough; a full Gamma--Orlov equivalence is useful
  structure but strictly higher cost.
- Check variance and target orientation.  For a shear \(1+v\otimes\lambda\),
  it is the target \(v\), not the source covector \(\lambda\), that must be
  boundary-supported.
- Do not infer edgewise compatibility from a pathwise Boolean.  An upper
  shear and its inverse change the row on each edge while preserving it in
  aggregate; the exact \(2\times2\) regression is now in the law harness.

### Audit-3 boundary

**No unconditional \(m=2\) theorem has been obtained.**  The strongest new
unconditional results are consumer-side: dual cyclic rows descend through a
row-null stable quotient, exact duality discharges the subsequent strict
dualization, and the row stabilizer is classified.  The highest-EV analytic
target remains the one-row/common-open output-support theorem, with the
direct Orlov-compatible Gamma square retained as a cleaner but stronger
alternative provider.

## Block 4: dimension-five centers and the nonsplit-normal wall

Weak factorization of a smooth fivefold has centers of dimension at most
three.  Only codimension-two threefold centers can carry the primitive-sixth
packet; centers of dimension at most two have empty packet.  The latter fact
controls unmarked multiplicity, not the Gamma row.

The birational normal-splitting reduction is exact.  After blowing up smooth
subcenters \(T_i\subset Z_i\) of dimension at most two, the pulled-back
rank-two normal bundle has a line filtration and deforms to a split bundle.
The nested-blowup square inserts centers
\(\mathbf P(N|_{T_i})\), which are \(\mathbf P^1\)-bundles over the \(T_i\)
and therefore also have empty primitive-sixth multiplicity.  However, the
C907 source explicitly warns that a different formal exponential can still
produce an ambient Stokes shear.  Point purity on the inserted arrows is an
additional analytic statement.

The known split theorem is also narrower than arbitrary splitting.  For a
split **nef** codimension-two complete intersection, the Kummer slice becomes
an exponential times a polynomial and the algebraic exceptional coefficient
is killed by \(1/\Gamma(-a_\beta)=0\).  For the negative-degree pilot
\((a_\beta,b_\beta)=(-1,0)\), the raw series is

\[
\frac{e^R-1}{R},
\]

so ambient normalization leaves a genuine \(-e^{-R}/R\) branch.  Splitting
the normal bundle does not remove the analytic gate.  The exact missing
geometric statement is the relative-cap point-purity lemma: relative gluing
must reorganize negative line degrees into nonnegative contact-order
channels with the required cancellations.

### Theorem 4.1 -- formal multi-sector sparse reconstruction

Let \(W=\bigoplus_{\phi\in\Phi}W_\phi\), with \(0\in\Phi\), and for a real
linear functional \(\lambda\) put

\[
F_\lambda^{\le0}W
=\bigoplus_{\lambda(\phi)\le0}W_\phi.
\]

If a finite set \(\Lambda\) separates every \(\phi\ne0\) positively from
zero, then

\[
\bigcap_{\lambda\in\Lambda}F_\lambda^{\le0}W=W_0.
\]

This is immediate summand by summand and gives a genuine reconstruction from
parallel half-space shadows.  The exact lattice toy with four directions is
green.

It does not yet apply to the Stokes local system.  Parallel transport places
the sectorial fibers in one vector space but does not simultaneously split
their Stokes filtrations.  A shear can replace the formal zero line by the
graph \(K(e_0+e_1)\), which belongs to the transported shadows while retaining
an exceptional component.  Therefore a simultaneous-splitting/Beck--Chevalley
comparison, or a direct global moderation theorem, is required in addition
to the path functor.  The exact sheared-shadow countermodel is green.
