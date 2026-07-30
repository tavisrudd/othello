# C696 Daniel Litt crossover audit

**Date:** 2026-07-29  
**Lane:** `clebsch`  
**Scope:** Paper III v2 and its C682/C695 research surface. Paper III v1 is
used only to mark the boundary of the recommendation.

## Outcome

One review angle is technically specific enough to use. Krämer--Litt--Maculan
place the \(27\)-dimensional minuscule representation of \(E_6\) in the
geometry of cubic threefolds and explicitly use its
\(A_1\times A_5\) branching
\[
27=(2\otimes6^\vee)\oplus\bigwedge\nolimits^2 6,
\qquad 27=12+15.
\]
C682 has independently constructed the twelve lines of a Schläfli double-six
from the third-transvectant operator, while C695 asks whether the same
operator data canonically produce the complementary fifteen lines. This is
the strongest crossover. It is a common representation-theoretic and
geometric object, not a theorem that can presently be imported.

Daniel Litt would be an unusually useful reviewer for two bounded questions:

1. Is the \(A_1\times A_5\) minuscule branching the correct intrinsic
   framework for the proposed operator-theoretic \(12+15\) construction?
2. If the construction closes, should the apolar--polar row swap be compared
   with the Weyl involution of the \(A_1\) factor, or is that comparison
   misleading?

The invitation should be made only after C695 has either constructed the
fifteen lines or reduced the issue to a precise obstruction. No Paper III v1
change follows from this audit.

The source audit screened 31 research items on Litt's categorized publication
page by title and displayed abstract. One source was read in full and one was
read in the sections relevant to reconstruction and monodromy. This report
makes no novelty, priority, pre-emption, or forward-citation claim.

## One-page technical briefing

### The object on our side

C682 starts from a binary dodecic \(F\) in the Mukai--Umemura orbit and the
third-transvectant operator
\[
T_F:\operatorname{Sym}^6\longrightarrow\operatorname{Sym}^{12},
\qquad p\longmapsto(p,F)_3.
\]
Its kernel and apolar complement recover the isotropic parent three-plane and
Clebsch four-space. The two \(D_5\)-mate constructions give six lines
\(E_i\) and six lines \(E_i'\) with
\[
\dim(E_i\cap E_j)=\dim(E_i'\cap E_j')=0\quad(i\ne j),\qquad
\dim(E_i\cap E_j')=
\begin{cases}0&i=j,\\1&i\ne j.\end{cases}
\]
Thus the operator package already contains an exact Schläfli double-six.
C695 asks for the fifteen complementary lines \(L_{ij}\) and the full
dictionary
\[
\{E_i,E_i'\}\leftrightarrow2\otimes6^\vee,\qquad
\{L_{ij}\}\leftrightarrow\bigwedge\nolimits^2 6.
\]
Here the first \(A_5\) is a Dynkin type; the finite icosahedral \(A_5\) enters
only after restriction through its six-axis permutation module.

### The exact crossover

Krämer--Litt--Maculan, §1.1 and the main theorem, construct geometric local
systems of rank \(27\) with connected algebraic monodromy \(E_6\). Their
§1.3 explicitly relates this \(27\) to the monodromy \(W(E_6)\) of lines in
the universal cubic surface. In §4.3, Table 1, they list the maximal
semisimple subgroup \(A_1\times A_5\) and the restriction
\[
[\,\varpi_1\times\varpi_5\,]\oplus[\,0\times\varpi_2\,],
\qquad 12\oplus15.
\]
Their proof uses Hodge-theoretic reconstruction to exclude this subgroup for
generic cubic-threefold monodromy. Our proposed v2 construction instead asks
whether a special Clebsch/Mukai--Umemura operator package realizes precisely
that \(12+15\) carrier. The generic exclusion and the proposed special
realization are compatible; neither implies the other.

The common geometric object is the \(27\)-line/minuscule configuration. The
mismatch is essential: their family consists of Fano surfaces of lines on
cubic threefolds and their \(E_6\) is an algebraic monodromy/Tannaka group;
ours is currently a single operator-theoretic construction of lines in a
Clebsch four-space. We have not constructed a family, a period map, a
Gauss--Manin local system, or a specialization from their setting.

Krämer--Litt--Maculan's Lemma 4.4 supplies a useful discriminator for C695.
Their minuscule \(27\) is not self-dual; self-duality of the geometric local
system would force the underlying rank-one twist to have order two, contrary
to their \(n>2\) hypothesis. Thus a putative row-swap symmetry on our full
twenty-seven-line carrier should not automatically be modeled by an
\(E_6\)-equivariant self-pairing of one \(27\). The two live alternatives in
C695 are genuinely different: an \(A_1\) Weyl involution may act inside the
restricted \(12+15\) carrier, while the outer automorphism of \(E_6\) should
exchange \(27\) with \(27^\vee\). This gives a representation-theoretic test,
not just a naming preference.

### Transferable method, but not yet a v2 theorem

Landesman--Litt--Sawin, §1.19.2 and Theorem 6.2/§6.4, reconstruct a unitary
local system functorially from the derivative of a period map. Krämer--Litt--
Maculan generalize this to surfaces: Proposition 2.6 reconstructs a flat
bundle on a base divisor from the iterated Higgs field, Theorem 2.12 isolates
the unique simple subsystem containing the extreme Hodge pieces, and Theorem
4.1 recovers the rank-one local system on the Fano surface.

This is an informed method analogy for C682: both programs recover a hidden
object from a structured linear operator. It is not presently reusable
because the transvectant family has no identified variation of Hodge
structure or infinitesimal period map. A future question could ask whether
\(F\mapsto T_F\) admits such an interpretation, but that is outside C695 and
should not be inserted into Paper III v2 without a separate theorem.

### Arithmetic adjacency and two boundaries

- The invariant trace field in Krämer--Litt--Maculan is
  \(\mathbf Q(\zeta_n)\), generated by traces of a monodromy representation
  and recovered by Galois conjugacy in §4.4. Paper III's
  \(\mathbf Q(\sqrt5)\) is a field of definition/residue algebra for an
  incidence cover, and C682's conductor orders are scalar-image orders.
  These are not the same invariant. There is nevertheless one exact
  arithmetic adjacency worth retaining:
  \[
  \mathbf Q(\sqrt5)=\mathbf Q(\zeta_5+\zeta_5^{-1})
  \subset\mathbf Q(\zeta_5),
  \]
  and C682's displayed double-six splitting uses
  \(\mathbf Q(\zeta_5)\). If a future geometric local system of order five
  were constructed from the operator family, the distinction between its
  cyclotomic trace field and the real golden descent would become a concrete
  question. Krämer--Litt--Maculan do not give this realization, and their
  unspecified threshold \(n_0\) does not assert that \(n=5\) is in range.
- “Cubic” alone is not a connection. Their cubic threefold and Fano surface
  are different objects from our Clebsch cubic surface and orientation
  cubic. The usable bridge is the \(27\)-line/\(E_6\) representation, not the
  degree of the defining equations.

## Ranked upgrades and review questions

1. **C695 statement architecture — high value.** If the fifteen lines are
   constructed, state the \(A_1\times A_5\) branching explicitly and cite
   Krämer--Litt--Maculan §4.3, Table 1, for its role in cubic-threefold
   monodromy. Verify the branching itself against the representation-theory
   source before manuscript use.
2. **Generic-versus-special contrast — high value, conditional.** Add at most
   one v2 paragraph: Krämer--Litt--Maculan exclude the \(A_1\times A_5\)
   carrier for generic \(E_6\) monodromy, whereas the Clebsch construction
   realizes it on a special finite configuration. Do not claim a
   degeneration or specialization without constructing one.
3. **Involution question — high-value review ask.** Ask whether the row swap
   belongs to the \(A_1\) Weyl factor. Use Krämer--Litt--Maculan Lemma 4.4
   to keep an internal involution, an equivariant self-pairing, and the outer
   automorphism exchanging \(27\) and \(27^\vee\) as separate tests.
4. **Cyclotomic/golden descent question — medium value, conditional.** The
   tower
   \(\mathbf Q\subset\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5)\)
   matches Paper III's golden fibre and C682's displayed double-six splitting.
   It belongs in v2 only if C695 finds an intrinsic Galois action on all
   twenty-seven lines. It is not currently a trace-field statement.
5. **Reconstruction language — medium value.** “Functorial reconstruction”
   is appropriate only if C695 proves canonicity under the stated operator
   data. “Torelli” or “period reconstruction” is not justified on the
   present surface.
6. **Trace-field terminology — defensive value.** Continue to use “field of
   definition,” “residue algebra,” and “conductor order.” Do not import
   “trace field” unless an actual monodromy representation is constructed.
7. **AI-assisted review experience — outreach only.** Krämer--Litt--Maculan
   §1.4 records AI assistance on two proofs, and Litt's publication list
   includes a human-verified account of an AI-generated argument. This makes
   him a plausible reader of the trust boundary, but it is not the
   mathematical reason for the invitation.

## Draft review invitation — do not send

> Subject: A bounded \(E_6\)/Clebsch \(27\)-line question
>
> Dear Daniel,
>
> I have been developing an operator-theoretic construction attached to the
> Clebsch/Mukai--Umemura setting. An exact third-transvectant construction
> currently recovers the twelve lines of a Schläfli double-six. I am testing
> whether the same data canonically recover the remaining fifteen lines, with
> the proposed dictionary
> \[
> 27=(2\otimes6^\vee)\oplus\bigwedge^2 6.
> \]
> Your use of the \(A_1\times A_5\) \(12+15\) branching in
> *\(E_6\)-local systems from cubic threefolds* made me think you would be an
> especially valuable reader of one narrow point: is this the right intrinsic
> representation-theoretic framework, and should the double-six row swap be
> compared with the \(A_1\) Weyl involution?
>
> This is not a claim that the construction lies in your cubic-threefold
> family, and I am not asking for a broad paper review. If the fifteen-line
> construction closes, would you be willing to look at a two-page technical
> note focused on those two questions?
>
> Best,
> [name]

## Source record

### Screened set

**Set:** 31 research items on Daniel Litt's official categorized
“Publications and Preprints” page, accessed 2026-07-29.  
**Fields screened:** title, year/status, coauthors, and displayed abstract.  
**Discriminator:** promote a work only if the abstract contains at least one
of: cubic/Fano/\(E_6\); functorial reconstruction from period or Higgs data;
exceptional or minuscule monodromy; or an arithmetic field invariant that
could plausibly match the golden cover.  
**Stopping rule:** the end of the official categorized list. No bulk
download and no citation-graph expansion were performed.

### Promoted sources

- Thomas Krämer, Daniel Litt, Marco Maculan, *\(E_6\)-local systems from
  cubic threefolds*, arXiv:2604.20970v1 (2026). **Read depth: full text**,
  PDF and arXiv HTML; relied on §§1--4, especially the main theorem,
  Proposition 2.6, Theorem 2.12, Theorems 3.1--3.2, Theorems 4.1--4.2,
  and §4.3 Table 1. Cache key `arXiv:2604.20970`, SHA-256
  `5d21082987b22d38bc436a52edac0c105bc13c959980431f159a5964b94a868a`.
- Aaron Landesman, Daniel Litt, Will Sawin, *Big monodromy for higher Prym
  representations*, arXiv:2401.13906v2 / published 2025.
  **Read depth: partial**, arXiv HTML and cached PDF; §§1, 1.19.2--1.19.5,
  6.1--6.7, and the opening of §7. Cache key `arXiv:2401.13906`, SHA-256
  `293540451dd1e35ae6268d4d5305d17a2e9c40d58fc3c74f4e956e696b8bec71`.
- Yeuk Hay Joshua Lam and Daniel Litt, *\(p\)-Curvature and Non-Abelian
  Cohomology*, arXiv:2601.07933v1. **Read depth: abstract/metadata only**,
  arXiv abstract page. It concerns isomonodromy and non-abelian
  \(p\)-curvature, not the finite golden cover.
- Aaron Landesman and Daniel Litt, *Geometric local systems on very general
  curves and isomonodromy*, arXiv:2202.00039v3. **Read depth:
  abstract/metadata only**, arXiv abstract page. Its stability and
  isomonodromy setting is too remote from the current operator construction.
- Yeuk Hay Joshua Lam and Daniel Litt, *Geometric local systems on the
  projective line minus four points*, arXiv:2305.11314v1.
  **Read depth: abstract/metadata only**, arXiv abstract page. Katz middle
  convolution and rank-two local monodromy do not match the v2 object.
- Daniel Litt, *Motives, mapping class groups, and monodromy*,
  arXiv:2409.02234. **Read depth: abstract/metadata only**, official
  publication page and arXiv abstract. It is useful background, not a
  primary theorem for the crossover.
- Noga Alon et al., *Remarks on the disproof of the unit distance
  conjecture*, arXiv:2605.20695. **Read depth: abstract/metadata only**,
  official publication page and arXiv abstract. It informs only the
  outreach/trust-boundary observation.

The branching table in Krämer--Litt--Maculan cites McKay--Patera for the
classification. **Read depth for McKay--Patera: secondary only through the
full-text Krämer--Litt--Maculan paper.** It must be checked directly before
the branching is used as a manuscript citation.

## Mystery ledger after the \(ej+tt\) closeout

- **Settled:** the review angle is specific: the \(A_1\times A_5\)
  \(12+15\) carrier and the row-swap involution.
- **Settled:** the invariant trace field and the golden residue/definition
  field are different invariants, so current terminology should not merge
  them.
- **Open, owned by C695:** whether the twelve operator lines canonically
  determine the fifteen complementary lines.
- **Open, owned by C695:** whether the row swap is the \(A_1\) Weyl
  involution; KLM Lemma 4.4 sharpens the separate kill test against an
  equivariant self-pairing or the \(E_6\) outer automorphism.
- **Open only if C695 constructs all twenty-seven lines:** whether their
  Galois action organizes the exact tower
  \(\mathbf Q\subset\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5)\).
  The missing evidence is an intrinsic full-\(27\) Galois representation;
  no new task is warranted before that gate.
- **Not promoted:** whether the Clebsch locus occurs as a specialization of
  the Krämer--Litt--Maculan cubic-threefold family. No map of families,
  period data, or monodromy comparison is known, and it is unnecessary for
  the v2 theorem.
