# C909 — intrinsic finite-etale gluing: building/local-model audit

Date: 2026-08-11
Lane: clebsch
Status: bounded primary-source and concept audit; no manuscript, PDF, mirror,
Lean, reviewer-dossier, or commit edit

## Opening coverage and verdict

Five named sources are used below: one was read at **full-text** depth and four
at **partial** depth. The search was bounded and primary-source-led, using
ranked title/abstract results plus cached arXiv texts; it was not an exhaustive
database or citation-graph search.

The strongest exact predecessors split into three layers:

1. finite symplectic module theory classifies transverse maximal isotropics as
   graphs of antisymplectic maps, often up to symplectic-group action;
2. Bruhat–Tits/local-model theory classifies self-dual lattice chains and their
   affine-Grassmannian/Schubert relative positions; and
3. ppav theory classifies symmetric idempotents, abelian-subvariety numerical
   classes, and corresponding moduli loci.

None of the audited sources connects those layers to the ordinary integral
divisor-product image of the Néron–Severi lattice. Yu supplies the tropical
positive-semidefinite shadow, but not the integral or cohomological statement.

The missing invariant is therefore not another finite-symplectic orbit label. It
is a **Veronese-decorated integral Rosati lattice**: the complete pulled-back
coefficient NS lattice together with its rank-one/square-zero cone and the
resulting divided-power product maps. In a marked elliptic-power presentation,
its first defect is

\[
 \Delta_{\mathrm{rk1}}(f)
 =
 \mathcal N_f/
 \langle\text{rank-one coefficient forms in }\mathcal N_f\rangle.
\]

For a matrix-of-ideals chart this has the exact elementary divisors

\[
 \Delta_{\mathrm{rk1}}(f)
 \cong
 \bigoplus_{i<j,\ e_{ij}<h_{ij}}
 O/\pi^{\,h_{ij}-e_{ij}}O,\qquad
 h_{ij}=\left\lceil\frac{a_i+a_j}{2}\right\rceil.
\tag{C909.I.1}
\]

Finite-etale block-respecting graphs force this defect to vanish, and then
all cohomological divided powers of the complete marked NS lattice lie in the
ordinary divisor-product image. This is a C909 theorem, not a theorem found
in the audited building, finite-module, or ppav sources.

## 1. The intrinsic local problem and its boundaries

Let \(E\) be a non-CM elliptic curve, let \(f:E^g\to(A,\Theta)\) be a
polarized isogeny, and work at \(p\). The source coefficient polarization has
a self-dual form \(B\) and a primary scale \(P\). A maximal isotropic graph
kernel is represented, in a transverse elliptic ruling, by a self-adjoint
slope \(T\) over \(R=\mathbb Z/p^a\). The finite-etale hypothesis is the
literal condition that \(R[T]\) is finite etale; squarefree reduction alone
does not suffice at \(a>1\).

The local divisor lattice pulled back from \(A\) is not just the finite
kernel \(K\). In graph coordinates it is the symmetric coefficient lattice
cut out by both graph cross-pairings and the commutator condition. After
finite unramified splitting it becomes a matrix-of-ideals lattice
\(\mathcal N(a,e)\). The C909 rank-one hull theorem gives

\[
 R_1(\mathcal N(a,e))
 =
 \mathcal N(a,e'),\qquad
 e'_{ij}=\max\{e_{ij},h_{ij}\}.
\tag{C909.I.2}
\]

For arbitrary marked graphs, (C909.I.1) is the exact coefficient-lattice
defect. For block-respecting finite-etale graph data at arbitrary depths,

\[
 e_{ij}=\max\{a_i,a_j,a_i+a_j-v_p(t_j-t_i)\}
       \geq\max\{a_i,a_j\}\geq h_{ij}.
\tag{C909.I.3}
\]

Thus the full marked graph NS lattice is rank-one generated, including
\(p=2\), and its rank-one classes pull back to decomposable alternating
two-forms. They are square-zero on the quotient. Consequently, for every
degree \(k\),

\[
 \operatorname{PD}\langle\operatorname{NS}(A)\rangle^k
 =
 \operatorname{im}\!\left(
 \operatorname{Sym}^k\operatorname{NS}(A)\to H^{2k}(A,\mathbb Z)
 \right)
\tag{C909.I.4}
\]

for the prescribed marked graph NS lattice. This is cohomological and
presentation-dependent. It is not a Chow statement, not the integral Hodge
conjecture, and not a theorem about a bare ppav after forgetting \(f\).

## 2. Exact prior art: finite symplectic modules and Lagrangian graphs

Borówka's finite-symplectic-module setup is the closest direct predecessor for
the finite kernel layer. For a polarization type \(D\), the kernel carries a
finite nondegenerate alternating pairing. For two factors of complementary
type, a maximal isotropic subgroup transverse to both factors is the graph of
an antisymplectic map. The source proves that such graphs are equivalent under
the actions of the two symplectic groups (Proposition 2.13), and uses this to
show irreducibility of the generalized Humbert locus
\(\operatorname{Is}^g_D\) (Proposition 3.17).

This is an important preemption boundary:

* the existence of a principal quotient by a maximal isotropic subgroup is
  standard;
* transverse finite symplectic graph orbits are standard;
* the resulting moduli locus is controlled by dimension and polarization type.

But this classification forgets the marked elliptic-power coefficient
lattice, the self-adjoint algebra \(R[T]\), the valuation depths \(e_{ij}\),
and the rank-one/square-zero generating cone. It therefore cannot by itself
imply (C909.I.1) or (C909.I.4).

In particular, “finite symplectic Lagrangian gluing is classified by a new
C909 invariant” is unsafe. The finite module layer is old; the missing
decoration is the integral coefficient/Veronese layer.

## 3. Exact prior art: buildings, affine Grassmannians, and local models

Pappas–Zhu give the relevant local-model framework. For classical groups, a
facet of the Bruhat–Tits building is represented by a lattice chain; for
symplectic/unitary situations the chains are self-dual. The associated
parahoric group scheme is the automorphism group of that chain. Their local
models are closures of minuscule homogeneous spaces in affine Grassmannian
objects, and the special fibers are unions of affine Schubert varieties
indexed by the admissible set (Theorem 0.1, §§4.a, 6.b.2, 8.a).

This supplies the right geometric container for the local position of a
self-dual graph lattice:

* primary exponents and self-dual lattice chains are affine/building data;
* unramified finite-etale splitting is naturally compatible with the
  unramified toral/Levi picture;
* Schubert orbits record relative positions and their degenerations.

However, the local model does not carry the C909 rank-one cone. A Schubert
position knows the lattice-chain orbit, not which elements of the associated
symmetric coefficient lattice are decomposable rank-one divisor forms, nor the
ordinary product image of their cohomology classes. Passing to a local model
therefore does not turn (C909.I.4) into a formal consequence.

The accurate relation is:

> C909's finite-etale graph point is a toral, self-dual lattice-chain
> situation inside the parahoric/affine-Grassmannian framework; its
> rank-one-hull defect is an additional representation-specific
> second-Veronese decoration of that point.

The word “decoration” is deliberate. The audited local-model sources do not
state an identification of the C909 defect with a Schubert multiplicity,
intersection number, normality defect, or a standard affine-Grassmannian
invariant. Such an identification is an open upgrade, not a literature fact.

## 4. Exact prior art: ppav decompositions and Hodge/moduli classes

Auffarth associates to every abelian subvariety of a ppav a canonical
numerical NS class via its norm endomorphism, characterizes that class by
intersection numbers, and describes coarse moduli spaces with a fixed
numerical class. Borówka likewise describes generalized Humbert loci by
restricted polarization type and proves irreducibility.

These results are the correct prior-art boundary for the indecomposable
families:

* a polarized decomposition is governed by symmetric rational idempotents;
* a nonsplit finite-etale field action with no nontrivial self-adjoint
  idempotent can force polarized indecomposability;
* moduli of abelian subvarieties and decompositions already have intrinsic
  numerical descriptions.

C909's added content is narrower and different: the explicit factorial-active
nonsplit trace-transfer families simultaneously satisfy a marked integral
rank-one/PD saturation theorem. They should not be presented as a new theory
of symmetric idempotents, ppav decompositions, or Humbert loci.

The moduli/Hodge consequence must also remain narrow. Finite-etale graph data
give discrete local level information and may define marked arithmetic
families, but a local trace algebra is not automatically a global Rosati-stable
PEL order or a Shimura subvariety. Full cohomological PD(NS) saturation of the
marked graph lattice does not imply:

* Fourier stability of the entire divisor-product algebra;
* equality with the full integral Hodge lattice;
* integral Hodge conjecture in all codimensions;
* a Chow identity, effective cycle, or Franchetta statement; or
* an unmarked moduli characterization of all ppavs with the property.

Beckmann–de Gaay Fortman provide the adjacent integral-Fourier/minimal-class
framework, but do not identify the smaller ordinary product lattice of a
finite-etale graph quotient. C909 should say “marked cohomological
divided-power saturation,” not “integral Hodge” or “Chow saturation.”

## 5. Tropical PSD is the associated-graded shadow, not the invariant

Yu proves that tropical PSD matrices satisfy

\[
 x_{ii}+x_{jj}\le 2x_{ij},
\]

that the corresponding \(2\Delta\) subdivision is trivial, and that the
tropical PSD cone is the tropical convex hull of symmetric tropical rank-one
matrices. This is the correct associated-graded shadow of the C909
midpoint inequality.

The C909 statement is stronger and of a different type: it is an
\(O\)-linear signed rank-one span with an exact finite DVR cokernel. Tropical
PSD data forget unit coefficients, signs, cancellation, and torsion. The
tropical cone therefore cannot be the intrinsic gluing invariant by itself.

A safe conceptual slogan is:

> affine/building relative position supplies the filtered lattice location;
> tropical PSD supplies the valuation cone; the C909 Veronese decoration
> measures integral rank-one generation and divided-power saturation.

This is an interpretation by the auditor, not a theorem asserted in Yu or
Pappas–Zhu.

## 6. The missing exact invariant

The minimal invariant that can support a chart-independent theorem should be
defined from a **marked polarized elliptic-power isogeny**, not from the bare
finite kernel:

\[
 \mathfrak G(f)=
 \bigl(
   \Lambda,\langle\ ,\ \rangle,\,
   M,B,P,\,
   K,\,
   \mathcal N_f,\,
   \mathcal R_{1,f}
 \bigr),
\]

where:

* \((\Lambda,\langle,\rangle)\) is the source symplectic homology lattice;
* \(M,B,P\) record the coefficient tensor/form and primary lattice scale;
* \(K\) is the maximal isotropic kernel;
* \(\mathcal N_f=f^*\operatorname{NS}(A)\) in the symmetric coefficient module;
* \(\mathcal R_{1,f}\) is the span of rank-one coefficient forms that lie in
  \(\mathcal N_f\).

The first defect is

\[
 \Delta_{1,f}=\mathcal N_f/\mathcal R_{1,f}.
\]

For degree \(k\), the cohomological PD defect is the quotient of the integral
divided-power subgroup generated by \(\mathcal N_f\) by the ordinary product
image. In the finite-etale graph theorem, \(\Delta_{1,f}=0\) and all these
PD defects vanish.

This object is invariant under coefficient isometries and under the allowed
transverse elliptic-ruling \(SL_2(R)\) changes, because those operations
transport the marked tensor structure and the rank-one cone. It is not known
to descend to a bare ppav, nor should it be claimed to be invariant under
arbitrary symplectic coordinate changes that mix the elliptic and coefficient
factors.

Equivalently, one can call \(\mathfrak G(f)\) a **Veronese-decorated
parahoric position**. A building/local-model realization would need to retain
the self-dual lattice-chain point together with the finite-etale algebra
action and the rank-one cone in the relevant symmetric-square representation.
The ordinary affine-Grassmannian/Schubert label alone is too coarse.

The exact open question is therefore not “classify all Lagrangians.” It is:

> Determine whether the decorated object \(\mathfrak G(f)\), or a canonical
> quotient of it, has a chart-independent moduli description; and determine
> whether its defect \(\Delta_{1,f}\) is a functorial invariant of the marked
> polarized isogeny under all presentation changes that preserve the
> elliptic-power tensor structure.

## 7. Strongest theorem currently justified

The strongest theorem that can be stated without importing unproved moduli
claims is:

> **Marked finite-etale PD-saturation theorem.**
> For a block-respecting maximal-isotropic graph quotient of a marked
> elliptic power over \(\mathbb Z/p^a\), assume the graph slope algebra
> \(R[T]\) is literally finite etale at every positive primary depth. Then
> after finite unramified splitting, the complete graph NS coefficient lattice
> is a symmetric matrix-of-ideals lattice whose cross depths satisfy
> \(e_{ij}\ge\lceil(a_i+a_j)/2\rceil\). It is generated by actual
> rank-one square-zero divisor classes. Faithfully flat descent gives
> \[
> \operatorname{PD}\langle\operatorname{NS}(A)\rangle^k
> =
> \operatorname{im}(\operatorname{Sym}^k\operatorname{NS}(A)
> \to H^{2k}(A,\mathbb Z))
> \]
> for every \(k\), for the prescribed marked graph NS lattice.

The theorem is intrinsic relative to the marked isogeny/tensor structure and
allowed ruling changes. It is not yet an intrinsic theorem of the unmarked
moduli point \(A\).

## 8. Search protocol and coverage gaps

Exact queries run included:

* “primary source Lagrangian submodules symplectic module Z/p^n
  classification elementary divisors”
* “primary source Siegel local models self-dual lattice chains affine
  Grassmannian symplectic”
* “primary source Bruhat Tits building symplectic lattices affine
  Grassmannian self dual”
* “primary source abelian varieties isogenies isotropic subgroups finite
  symplectic modules classification”
* “Non-simple principally polarised abelian varieties” arxiv
* “Pappas Zhu Local models of Shimura varieties affine Grassmannian self dual
  lattices”
* “divisor-product lattice abelian variety isogeny elliptic power”
* “ordinary divisor products minimal class abelian variety integral lattice”
* “divided powers Neron-Severi elliptic power isogeny”
* “finite etale graph isogeny principally polarized abelian variety”

Results were screened over title/abstract/snippet fields; no finite database
set was enumerated and no citation graph was run. The search found no exact
primary source for the C909 integral graph-NS rank-one/PD theorem. MathSciNet
is **NOT COVERED** (institutional authentication unavailable); zbMATH Open is
**NOT systematically covered**; Google Scholar is **NOT COVERED** (automated
access blocked); OpenAlex, Crossref, and Semantic Scholar citation graphs were
**NOT RUN**. No exhaustive search of all symplectic-module monographs or
Bruhat–Tits literature was attempted.

## Source records

### Josephine Yu, *Tropicalizing the positive semidefinite cone*

* Read depth: **full text** — cached arXiv PDF, version v1; relied on
  Theorems 1–2, Lemma 3, Theorem 4, and Corollary 6.
* Access/version: https://arxiv.org/abs/1309.6011.
* Cache key: arXiv:1309.6011.
* SHA-256:
  ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6.

### Paweł Borówka, *Non-simple principally polarised abelian varieties*

* Read depth: **partial** — cached arXiv PDF, version v2; read the
  Introduction, §§2.1–2.2, §3.3, and §4.1. Relied on Propositions 2.5,
  2.13, 3.17 and Theorem 4.2.
* Access/version: https://arxiv.org/abs/1307.6591.
* Cache key: arXiv:1307.6591.
* SHA-256:
  3dc2b23f244620df88bdbbb48282dddf8dbab93aeaf7adb965594dc32611fc01.

### G. Pappas and X. Zhu, *Local models of Shimura varieties and a
conjecture of Kottwitz*

* Read depth: **partial** — cached arXiv PDF, version v4; read the
  Introduction, §4.a, §6.b.2, §7.a, and §8.a. Relied on Theorem 0.1,
  Proposition 7.1, and the self-dual-chain/Schubert descriptions.
* Access/version: https://arxiv.org/abs/1110.5588.
* Cache key: arXiv:1110.5588.
* SHA-256:
  cbb879126ff50a5431e06046edd55d1da3ee4d260ddd4d80202a043e21b18b27.

### Robert Auffarth, *On a numerical characterization of non-simple
principally polarized abelian varieties*

* Read depth: **partial** — cached arXiv PDF, version v2; read the
  Introduction and §§2–3, relying on Theorems 2.6 and 3.1 and the moduli
  construction around Proposition 3.8.
* Access/version: https://arxiv.org/abs/1507.08618.
* Cache key: arXiv:1507.08618.
* SHA-256:
  0852d65b8250d47d0073c6c40e328e1d894c7a6c84e23f0fbb4d5b5b8c290e4d.

### Thorsten Beckmann and Olivier de Gaay Fortman, *Integral Fourier
transforms and the integral Hodge conjecture for one-cycles on abelian
varieties*

* Read depth: **partial** — cached arXiv preprint; read the
  Abstract/Introduction, Theorem 3.8, and the product/minimal-class discussion
  around Corollary 4.1.
* Access/version: https://arxiv.org/abs/2202.05230.
* Cache key: arXiv:2202.05230.
* SHA-256:
  ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc.

## Priority wording

The safe ledger sentence is:

> Finite symplectic graph gluings, self-dual lattice-chain positions, and
> ppav symmetric-idempotent/moduli descriptions are classical. For the
> marked elliptic-power graph presentation, C909 proves an additional
> integral Veronese/rank-one saturation theorem and its all-degree
> cohomological PD(NS) consequence. Under the bounded search recorded here,
> no exact predecessor for that graph-NS-to-ordinary-product bridge was
> located.

Do not claim that C909 classifies all Lagrangians, invents affine-Grassmannian
local models, or proves an unmarked Shimura/Hodge theorem.
