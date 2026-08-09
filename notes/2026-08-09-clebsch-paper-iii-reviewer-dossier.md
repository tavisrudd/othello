# Clebsch Paper III reviewer and critic dossier

**Lane:** `clebsch`

**Task:** `C897`

**Date:** 2026-08-09

**Scope:** likely human-proof and mathematical-exposition reviewers for
*Golden descent and operator realizations of the Clebsch cubic*.  Lean
correctness and artifact-trust review are deliberately out of scope.

> **REVIEW-SUB-AGENT MATERIAL ONLY.**  Do not list or load this dossier in a
> lane handoff, startup context, named-expert routing table, ordinary Paper III
> work, or any Lean task.  A parent may pass one selected packet directly to a
> Paper III cold-review sub-agent.  Any later conventions-only extract for
> manuscript work must be selected separately from the review results.

## Review surface and isolation rule

Each cold reader receives:

1. `~/src/math-papers/clebsch-passages/clebsch_passages.pdf`;
2. read-only access to the complete supplemental repository
   `~/src/math-papers/clebsch-passages/`; and
3. exactly one persona packet from this dossier.

Freeze the initial batch at standalone commit
`7208275e6b5f979fea487d2130943bbd979aed37`.  The PDF SHA-256 is
`6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`.
If the paper advances before a batch starts, record the replacement commit and
PDF hash and use it for every reader in that batch.

The reader should read the PDF before opening supplemental files.  The
supplement may then be used to inspect manuscript sources, `README.md`,
`ARTIFACT.md`, `literature-boundaries.md`, and the public verification surface.
The supplement is evidence about the stated boundary; it is not a substitute
for a human proof.  Do not give the reader monorepo notes, C-task cards, lane
handoffs, earlier reviews, or another persona's report.

Numerical review grades are chat-only.  Cold-read files and syntheses record
findings and categorical verdicts, never scores.

## Bottom line

The current preferred venue is *Advances in Mathematics*.  Its current public
board has no single editor whose listed work spans this paper's full mixture.
Tony Pantev is the most plausible board-level geometric route because his work
joins algebraic and differential geometry with mathematical physics; Max
Lieblich is the strongest alternate for the arithmetic-algebraic-geometry and
normalization argument.  If either handles the submission, that person is not
the anonymous referee.  This is a public-board forecast, not knowledge of the
journal's internal assignment.

The most plausible or highest-value referee personas are:

1. **Nigel Hitchin** — the arithmetic incidence cover, the Mukai--Umemura
   model, the Clebsch chart, the branch sextic, and the degree-three harmonic
   source.  The paper is a direct rational-descent extension of two of his
   papers.
2. **Gary Greaves or Sho Suda** — the symmetric-conference, principal-minor,
   design, and association-scheme half.  Their current paper supplies the
   determinant-`(-3)` design used in the manuscript.
3. **Andrew Snowden** — the outer `S_6`, mystic-pentagon, signed Joubert,
   Segre, and Igusa conventions.  He is a more plausible line-by-line reader
   than the still more senior Ravi Vakil; use one persona, not a blend.
4. **Hamza Si Kaddour** — the aligned-design theorem as a reconstruction-up-to-
   complementation statement, including the exact distinction among equality,
   isomorphy, and hypomorphy up to complement.
5. **Willem Haemers or Leila Parsaei Majd** — a focused read of balanced
   exchange spectra, complementary principal blocks, switching, and the
   conference-order boundary.

Useful focused critics, but less likely to receive the whole paper, are **Neil
Gillespie** for two-graph/equiangular-line conventions and **Victor-Emmanuel
Brunel or John Urschel** for principal-minor recovery and query-complexity
comparisons.

One person is unlikely to referee all interfaces competently.  A realistic
pair is one Hitchin-adjacent algebraic geometer and one algebraic
combinatorialist from the Greaves--Suda--Haemers neighborhood.  The first cold
batch should nevertheless run four independent reads: Hitchin, Greaves/Suda,
Snowden, and Si Kaddour.  Add Haemers as a focused fifth read if the exchange
theorem survives the first batch but remains hard to assess.

Availability, undisclosed conflicts, the handling editor's network, and a
venue change can alter the names.  The subject packets remain useful even when
the eventual referee is someone else.

## Why these people are plausible

### Editorial route

The 2026-07-30 venue decision places Paper III first at *Advances in
Mathematics*.  On 2026-08-09 the journal publicly lists Michael Hill, Tomasz
Mrowka, and Gang Tian as editors and Pantev, Lieblich, and Karen Smith among
the board.  The journal describes its remit as important pure-mathematics
developments communicated both to specialists and to adjacent scientists.
That makes two editorial tests likely before any detailed report:

- Is there one principal advance, rather than a collection of exact bridges?
- Can a reader from an adjacent field follow the causal chain without treating
  the supplement or the formalization as a replacement for exposition?

Current sources:

- <https://www.sciencedirect.com/journal/advances-in-mathematics/about/editorial-board>;
- <https://www.sciencedirect.com/journal/advances-in-mathematics>;
- <https://web.sas.upenn.edu/endowed-professors/pantev/>;
- <https://max.lieblich.us/>.

### Referee tier A — very plausible or uniquely high-value

#### Nigel Hitchin

Hitchin supplies nearly the whole imported geometric source: the seven-space
of harmonic cubics, the invariant sextic, the two icosahedra, the Clebsch
four-space, the Mukai--Umemura isotropic three-planes, and the generic degree
two.  He is emeritus but remains research-active, with publications in 2024--
2026.  His Oxford profile lists both relevant icosahedron papers.

What he is positioned to scrutinize:

- whether results proved over the reals or complexes in his papers genuinely
  provide the rational Grassmannian incidence model asserted here;
- whether the top-Chern-number count gives the precise normal, integral,
  scheme-theoretic degree-two cover used by the Stein argument;
- whether one complete reduced fibre over `xyz` determines the global square
  class under all stated hypotheses;
- whether the factor `16` and the normalization of `J_0` agree with his
  polarization convention;
- whether the incidence sheet is being confused with the much richer marked
  bridge datum; and
- whether the degree-six harmonic return is a mathematical consequence of the
  source or an independently normalized comparison that happens to use the
  same four-dimensional `A_5` module.

Likely exposition convention: Hitchin introduces the geometric question and a
concrete icosahedral example first, fixes the harmonic pairing explicitly, and
then lets vector bundles and the Mukai--Umemura threefold enter only when the
counting problem requires them.  A Hitchin-style report will expect the new
rational-descent step to be isolated just as sharply from the imported complex
geometry.

#### Gary Greaves / Sho Suda

Greaves and Suda's current work produces the exact 3-design from symmetric
conference matrices that the paper uses.  Greaves is an active algebraic
combinatorialist at NTU and joined the *Electronic Journal of Combinatorics*
editorial team in 2026.  Suda is a professor at the National Defense Academy
of Japan working on algebraic combinatorics, Hadamard matrices, association
schemes, spherical codes, and designs.  Either is a natural current referee;
do not merge their personas.

What this reader is positioned to scrutinize:

- the conversion between determinant values `{-3,5}`, aligned four-sets, and
  the two possible coherence types of a two-graph;
- every design parameter, especially the translation from order `4m+2` to the
  paper's order `2d`;
- whether a forward 3-design theorem is ever made to carry an inverse
  reconstruction conclusion;
- the closed-four-walk expansion and the exact coefficient `32 c_Y`;
- the six-row signed table, the outer-family coherence, and the unexpanded
  phrase “two dihedral representatives and complementation”; and
- the distinction between a labelled signing, switching equivalence, global
  negation, and equivalence allowing vertex reordering.

Likely exposition convention: define the matrix and the block family before
stating the design, separate symmetric from skew-symmetric cases, and derive
parameters by an explicit theorem/table chain.  A Greaves or Suda reader will
not accept “classical design” as a substitute for matching the paper's exact
determinant fibre and normalization.

#### Andrew Snowden

Howard--Millson--Snowden--Vakil give the paper's exact outer-`S_6` and
six-point invariant-theory source.  Snowden is an active professor working at
the intersection of representation theory and commutative algebra.  He is a
plausible specialist for the signed five-dimensional representations and the
six-point quotient, and is more likely than Vakil to check the displayed
coordinate identification line by line.

What he is positioned to scrutinize:

- whether the six coloured-triangle cubics are the signed outer coordinates,
  rather than merely projectively equivalent coordinates;
- how an odd permutation swaps colours and twists by the sign representation;
- whether Table (5.1) uses the same labelling and global sign as the cited
  mystic-pentagon construction;
- whether the Segre and Igusa equations are used only projectively or with a
  stronger affine normalization;
- whether centered squaring is exactly the classical duality map after the
  paper's factors of `4`, `16`, and `1/6`; and
- whether the diagonal Clebsch section and the claimed Joubert terminology are
  attributed at the right strength.

Likely exposition convention: the cited paper deliberately gives a
reader-verifiable combinatorial model of the outer automorphism before using
it in invariant theory.  It also says explicitly when later algebraic details
are omitted as computer-checkable.  Paper III claims exact signs and scalars,
so those omitted details become Paper III's proof obligation rather than
something supplied by the citation.

#### Hamza Si Kaddour

Si Kaddour coauthored the two closest reconstruction-up-to-complement papers
and remains active in that subject.  His language is the closest established
framework for the paper's aligned-design theorem.  He is less likely to cover
the arithmetic half, but unusually likely to find a priority or quantifier
error in the four-local reconstruction discussion.

What he is positioned to scrutinize:

- whether the paper means equality, isomorphism, labelled equality up to
  complement, or local hypomorphy up to complement at each step;
- whether equality of aligned families really is the asserted four-local
  observable within the two-graph subclass;
- whether the seven-point proof controls complement conventions when
  seven-sets overlap in only six points;
- whether the six-point witness proves the exact sharpness claimed;
- whether the fixed and adaptive query families are actually proved to
  reconstruct the labelled object;
- whether the closest benchmark is stated accurately: ordinary graphs already
  have a four-local reconstruction theorem in the admissible range, while
  arbitrary 3-uniform hypergraphs have eventual local threshold five; and
- whether the paper distinguishes those two independent comparisons instead of
  using the broader hypergraph result as the sole benchmark.

Likely exposition convention: state the ambient labelled vertex set, define
each local equivalence relation before using it, and make the admissible
`(v,k)` range part of the theorem.  Incidence-matrix rank, Ramsey reduction,
and complement ambiguity are separate proof stages.

### Referee tier B — plausible focused specialists

#### Willem Haemers / Leila Parsaei Majd

Their paper is the closest direct source for complementary principal-block
spectra of symmetric conference matrices.  Haemers is emeritus but remains
active, including publications in 2025--2026.  Their conventions call two
Seidel matrices equivalent when switching and/or simultaneous row-column
reordering relates them, and take `-1` as graph adjacency.

Expected critical questions:

- Is `H_Y` independent of the chosen isometry onto the positive eigenspace?
- Does the commutator calculation give precisely the squared singular values
  of the cut block with the stated multiplicities?
- Is the passage from cut-independent full spectrum to a constant fourth-trace
  sum reversible at the point where it is used?
- Does Jolliffe's inclusion-rank theorem apply in the exact `4`-to-`d` range
  and over the correct field?
- Are non-realized small orders separated from the formal `d<=3` conclusion?
- Is the order-six spectrum a labelled-cut statement, a switching invariant,
  or an equivalence-class statement?

#### Neil Gillespie

Gillespie's paper gives a clean dictionary among equiangular lines,
two-graphs, and switching classes and distinguishes coherent, incoherent, and
mixed four-sets.  He is the best focused critic for terminology at the
conference/two-graph/harmonic interface.

Expected critical questions:

- Does “aligned” mean the union of coherent and incoherent four-sets, and is
  that translated once into standard terminology?
- Is the two-graph independent of choices of unit representatives for the
  equiangular lines exactly because those choices induce switching?
- Which design result follows from regularity of the two-graph and which
  stronger 3-design result comes from the conference matrix?
- Does the paper keep a regular two-graph, its complement, and global negation
  of a Seidel representative distinct?

#### Victor-Emmanuel Brunel / John Urschel

Their work is a strong focused check on the paper's principal-minor and query
paragraphs.  It studies recovery from full principal-minor values for
magnitude-symmetric matrices and gives a polynomial-time quadratic-query
algorithm.  Paper III instead queries only a biased one-bit fourth-order
indicator.

Expected critical questions:

- Is every comparison explicit about full values versus one-bit indicators?
- Is the paper claiming no speedup over existing principal-minor assignment
  algorithms?
- Are fixed nonadaptive families separated from adaptive decision trees?
- Does the entropy bound use the entropy of the actual complement-pair output,
  and are dependencies among tests handled only through subadditivity?
- Is the claimed adaptive `binom(n,2)+O(n)` decoder fully specified rather
  than inferred from the seven-point existence theorem?

## Cross-persona criticals, ranked

These are the objections most likely to determine a report regardless of the
reviewer's specialty.

1. **The rational incidence model is the headline proof obligation.**
   Hitchin's cited constructions are over the real or complex numbers.  The
   manuscript must itself justify the rational Grassmannian zero locus, its
   geometric integrality and smoothness, normality of the incidence variety,
   the exact branch divisor, and the finite Stein normalization used to infer
   `Q(P(H))(sqrt(5J_0))`.  A top Chern number and a real classification do not
   automatically supply every scheme-theoretic assertion.
2. **One fibre determines the twist only after a complete local comparison.**
   The proof needs quasi-finiteness at `xyz`, a finite neighbourhood, an
   unramified complete reduced fibre with residue algebra `Q(sqrt(5))`, and a
   compatible local trivialization of `O(3)`.  If any step is merely read off
   from the two displayed configurations, the square-class conclusion is
   underproved.
3. **The marking cannot be smuggled out of the deck sheet.**  The normalized
   cover supplies a sign.  The ordered six axes, outer labels, plane triples,
   Petersen labels, determinant-line orientations, and normalized lift are
   extra data.  Every claimed sign comparison must remain relative to that
   full datum, including on the branch where the literal two-configuration
   interpretation fails.
4. **Exact outer coordinates require an exact proof.**  The HMSV source gives
   the classical coloured-triangle, Segre, and Igusa framework, with some
   algebra explicitly omitted as computer-checkable.  Paper III must verify
   its own coefficient words, sign twist, and scalar normalization.  The
   six-row table and the phrase “two dihedral representatives and
   complementation” are natural red-team targets.
5. **The aligned-design theorem has both a proof and a literature seam.**  The
   seven-point finite classifier, global overlap propagation, query count, and
   adaptive extension must each be justified.  The related-work paragraph must
   state both the ordinary-graph four-local theorem and the arbitrary
   3-uniform-hypergraph threshold-five theorem accurately; neither is simply a
   corollary of the other or of the two-graph result.
6. **Balanced exchange rigidity must not overborrow from the cited spectral
   literature.**  Complementary-block spectra are classical, as are closed-
   walk organization and inclusion-rank tools.  The full cut-independent
   classification is the manuscript's argument.  Its moment constants,
   inclusion-matrix orientation, Ramsey endpoint, and realized-order wording
   must survive direct recomputation.
7. **The harmonic coefficient needs a human normalization trail.**  The
   addition theorem, Petersen eigenspace, one-dimensional invariant-cubic
   claim, exact spherical moment, Gaunt factor, and Condon--Shortley conversion
   use different conventions.  The supplement can reproduce the number; the
   prose must still explain why the number is the stated invariant and why its
   sign follows from the marked lift.
8. **The principal theorem and significance may be unclear at an Advances
   standard.**  The abstract presently carries arithmetic descent, a relative
   orientation bridge, four operator shadows, exchange rigidity, two-graph
   reconstruction, a decoder, and harmonic restriction.  A referee may regard
   this as several exact identities joined by a marking rather than one
   advance.  The introduction must make the causal dependency and the honest
   independent branches unmistakable.
9. **Formal and computational evidence cannot silently close a human gap.**
   `ARTIFACT.md` identifies the incidence degree/branch/local comparison,
   higher-order inclusion/Ramsey step, outer-family coherence, cross-golden
   determinants, classical quotient, and parts of the harmonic argument as
   human boundaries.  A human-proof review should score those arguments on the
   PDF even if a source or replay exists in the supplement.
10. **Attribution must match theorem strength.**  Hitchin owns the degree-two
    incidence and branch sextic; HMSV own the classical outer six-point
    quotient; Greaves--Suda own the determinant design; the reconstruction,
    exchange classification, exact marked synthesis, and exact harmonic scalar
    are the manuscript's stated contributions.  Wording that shifts any of
    those boundaries is a substantive exposition finding.

The first six can produce **MAJOR** findings.  Items 7--10 range from minor to
major depending on whether a reader can reconstruct the missing bridge from
the current text.

## Prerequisite extracts for review sub-agents

These extracts are source-grounded prompts, not substitutes for the assigned
pages.  The parent should pass only the extracts in the selected packet.

### Extract H1 — Hitchin's harmonic and field conventions

Source: Hitchin, *Spherical harmonics and the icosahedron*, Introduction,
Sections 2--3, 7--10, and Appendix.

Hitchin starts with the real irreducible `SO(3)` representation of degree-three
spherical harmonics and normalizes the polarization pairing by
`(p,(a,x)^3)=p(a)`.  He then complexifies when using plane cubics, blowups,
vector bundles, and the Mukai--Umemura geometry.  His main real theorem says
that the sign of a sextic invariant decides whether a real harmonic cubic's
nodal set contains two or zero icosahedra, with a classified branch case.

For a fixed icosahedron, the cubics vanishing on its six axes form a
four-dimensional harmonic space.  Two icosahedra with no common axis have a
one-dimensional common space of harmonic cubics.  Hitchin identifies the
exceptional locus inside the fixed four-space with the Clebsch cubic.  In the
appendix his invariant restricts to a square of the `A_5` cubic after his
chosen normalization.

Retain before reading Paper III:

- the source moves explicitly between real and complex geometry; it does not
  state Paper III's rational Stein algebra;
- the harmonic pairing and the scale of the sextic are conventions, not
  automatic geometric normalizations;
- the two-icosahedron statement is initially a geometric counting theorem,
  not a scheme-theoretic description of a finite cover over `Q`; and
- the unique-versus-two-versus-infinite boundary matters at the branch locus.

Paper-III comparison test: mark every sentence in Sections 1--2 that upgrades
Hitchin's real/complex result to a rational scheme statement.  For each, demand
either a proof in the manuscript or an exact cited statement at the same field
and scheme-theoretic strength.

### Extract H2 — what the Mukai--Umemura Chern count supplies

Source: Hitchin, *Vector bundles and the icosahedron*, Sections 2--5 and
Theorem 4.

Hitchin constructs the Mukai--Umemura threefold over the complex numbers as
the smooth zero locus in `Gr(3,V)` of the three universal skew forms.  A
harmonic cubic restricts to a section of the dual universal rank-three bundle.
The calculation `c_3(E^*)=2` says that a nondegenerate section has two zeros.
Those zeros correspond to isotropic three-planes orthogonal to the cubic.

Retain before reading Paper III:

- a degree-two zero count for a generic section is not by itself a proof that
  a displayed rational incidence space is normal, integral, finite over a
  neighbourhood, or branched scheme-theoretically only along `J_0=0`;
- the threefold's smoothness is part of the cited complex model and needs a
  descent argument if used over `Q`;
- Stein factorization packages connected fibres, but its anti-invariant line
  bundle and multiplication law still need the reflexive-sheaf and divisor
  arguments given in Paper III; and
- the point `xyz` is useful only if its two geometric configurations form the
  complete reduced fibre in the unramified finite locus.

Paper-III comparison test: reconstruct Theorem 1.1 as a chain of five named
implications: rational model, quadratic generic field, branch square class,
golden-fibre specialization, and global Stein algebra.  Stop at the first step
whose hypotheses are not proved.

### Extract X1 — signed outer-`S_6` conventions

Source: Howard--Millson--Snowden--Vakil, *A description of the outer
automorphism of S6, and the invariants of six points in projective space*,
Sections 1.1--1.6 and 2.1--2.2.

The source gives six mystic pentagons, equivalently six two-colourings of the
twenty triangles on six labels.  Disjoint triangles have opposite colours and
each tetrahedron has two triangles of each colour.  Odd permutations exchange
the colours.  Consequently the signed coordinate space carries the signed
outer five-dimensional representation, not the ordinary outer permutation
representation.

For six ordered points on `P^1`, the signed coordinates satisfy
`sum Z_x=0` and `sum Z_x^3=0`, defining the Segre cubic.  The projective-dual
Igusa coordinates are
`W_x=Z_x^2-(1/6)sum Z_y^2`, and satisfy the standard quartic equation.  The
source's purpose is a transparent combinatorial model of the outer
automorphism.  It says that some invariant-theory algebra is readily checked
by computer and omits those details.

Retain before reading Paper III:

- changing the global colour choice negates every signed coordinate;
- an odd relabelling contributes the sign twist as well as permuting the six
  outer labels;
- the Segre and Igusa equations live projectively, while Paper III claims an
  exact affine normalization of its cubics; and
- an omitted calculation in the source remains a Paper-III obligation when an
  exact coefficient word or scalar is claimed.

Paper-III comparison test: starting from the conference matrix displayed in
Section 3, independently compute the twenty triangle signs for `T_0`, transport
them by the six stated permutations with the sign twist, and compare all six
rows of Table (5.1) before crediting the Segre or Igusa conclusions.

### Extract G1 — conference determinant and design conventions

Source: Greaves--Suda, *Constructions of t-designs from weighing matrices and
walk-regular graphs*, Table 1 and Example 2.3.

A symmetric Seidel matrix has zero diagonal and nonzero off-diagonal entries
in `{+1,-1}`.  A conference matrix of order `v` satisfies
`S S^T=(v-1)I`.  For a symmetric Seidel matrix, the possible principal-minor
values are `{-2,2}` at order three and `{-3,5}` at order four.  For a symmetric
conference matrix of order `4m+2`, Example 2.3 proves that the order-four
subsets with determinant `5` form a `3-(4m+2,4,3m)` design and those with
determinant `-3` form a `3-(4m+2,4,m-1)` design.

In Paper III's notation `2d=4m+2`, so `m=(d-1)/2` and the determinant-`(-3)`
parameter is `(d-3)/2`.  This is a forward theorem: a conference identity
produces the design.  It does not say that the design reconstructs the
switching class.

Retain before reading Paper III:

- match the determinant sign before translating the block family;
- distinguish the two four-set fibres rather than calling either simply “the
  conference design”;
- the paper's `aligned` family is a nonstandard local name that needs a direct
  determinant/two-graph translation; and
- all inverse faithfulness and decoder claims are new proof obligations.

Paper-III comparison test: recompute `det C[Q]=3-2w(Q)` for the two possible
cycle sums, translate the Greaves--Suda parameters, and verify the mean and
variance formulas without using the manuscript's displayed result.

### Extract E1 — switching and complementary spectra

Source: Haemers--Parsaei Majd, *Spectral symmetry in conference matrices*,
Sections 2--3.

The source calls simultaneous multiplication of selected rows and columns by
`-1` switching.  It calls two Seidel matrices equivalent when switching and/or
simultaneous row-column reordering relates them.  It takes `-1` as adjacency in
the associated graph.  For a symmetric orthogonal matrix partitioned into two
principal blocks, the non-`+/-1` spectra of the blocks occur with opposite
signs; the conference corollary follows after scaling by `sqrt(n-1)`.

Retain before reading Paper III:

- Paper III keeps labels fixed and separates switching, global negation, and
  relabelling; “equivalent” from this source is broader;
- the cited theorem is about complementary principal-block spectra, not the
  paper's positive-eigenspace exchange operator;
- the block identity `RR^T=qI-A^2` is classical but does not classify when the
  squared spectrum is independent of every balanced cut; and
- symmetric conference matrices occur in the `2 mod 4` order class, so formal
  small-`d` algebra and realized orders must be worded separately.

Paper-III comparison test: derive `Spec(H_Y)` from the commutator without
choosing coordinates on the positive eigenspace, then audit the moment and
Ramsey argument as the manuscript's proof rather than part of the citation.

### Extract R1 — graph reconstruction up to complement

Source: Dammak--Lopez--Pouzet--Si Kaddour, *Hypomorphy of graphs up to
complementation*, Introduction and Theorem 1.1.

The source distinguishes:

- two labelled graphs being equal up to complementation;
- their induced `k`-vertex restrictions being isomorphic up to
  complementation; and
- a graph being reconstructible from those local isomorphism types.

It proves, in particular, equality up to complement throughout the admissible
four-local range, with `4 <= k <= v-3` at the endpoint relevant to `v=7`,
subject to the stated congruence cases.  Incidence-matrix rank propagates local
information to smaller subsets; the remaining complement ambiguity is then a
separate graph argument.

Retain before reading Paper III:

- the ordinary-graph theorem already places `k=4` and ambient order seven in
  the immediate neighborhood;
- its observable is local graph isomorphism up to complement, not equality of
  Paper III's aligned-family bit;
- the hypotheses are incomparable without an explicit translation or
  counterexample; and
- “same threshold” does not mean “one theorem implies the other.”

Paper-III comparison test: write the two theorem hypotheses side by side on a
fixed labelled vertex set.  If the manuscript calls one the closest benchmark,
require a sentence explaining why its observable is closer than the other.

### Extract R2 — the arbitrary-hypergraph threshold

Source: Pouzet--Si Kaddour, *Isomorphy up to complementation*, Theorems 1--2.

For `h`-uniform hypergraphs, the least eventual local size is
`s(h)=h+2^floor(log_2 h)`.  Thus `s(3)=5`; because `3=2^1+1`, their stated
bound gives eventual ambient threshold at most `s(3)+3=8`.  Their proof uses
incidence-matrix rank, Ramsey theory, Lucas's theorem, and almost-constant
hypergraphs.

Retain before reading Paper III:

- this is an arbitrary 3-uniform-hypergraph theorem about local isomorphy up to
  complement;
- Paper III works in the much narrower two-graph parity class but observes an
  aligned-four-set family rather than the induced 3-hypergraph itself;
- lowering five to four is a valid broad comparison only after the observables
  are described accurately; and
- the ordinary-graph four-local result in Extract R1 remains independently
  relevant.

Paper-III comparison test: reject any sentence suggesting that the arbitrary-
hypergraph theorem is the only four-local reconstruction benchmark or that the
two-graph result formally improves it without qualification.

### Extract R3 — principal-minor identifiability and query models

Sources: Holtz--Sturmfels, Theorem 6; Brunel--Urschel, Introduction and main
algorithm statement.

Holtz--Sturmfels reconstruct a real symmetric matrix from a compatible full
principal-minor vector under a strict nondegeneracy condition.  Order-one and
order-two minors fix diagonal entries and off-diagonal magnitudes; diagonal
sign similarity fixes a gauge; order-three minors then determine the remaining
signs.  Thus the identifiability class is diagonal sign similarity.

Brunel--Urschel study full principal-minor values for magnitude-symmetric
matrices and give a polynomial-time recovery algorithm using quadratically
many queries.  Their query returns a value, not the single bit “is this
fourth-order minor `-3`?”.

Retain before reading Paper III:

- Paper III's information model is strictly weaker per query;
- its global-negation ambiguity is forced because fourth-order values are even
  under negation;
- its quadratic count is not a speedup claim over the cited algorithms; and
- fixed-family entropy and adaptive decision-tree counts are different lower-
  bound problems.

Paper-III comparison test: for every complexity sentence, name the oracle,
allowed adaptivity, returned alphabet, equivalence class, and whether the
claim is identifiability, query count, or runtime.

### Extract T1 — standard two-graph terminology

Source: Gillespie, *Equiangular lines, incoherent sets and quasi-symmetric
designs*, Section 2.2 and Proposition 4.1.

A two-graph is a triple set with even parity on every four-set.  It is
equivalent to a switching class of graphs.  Choosing different unit
representatives of equiangular lines changes the graph by switching and leaves
the two-graph invariant.  Gillespie calls a set coherent when all of its
triples lie in the two-graph and incoherent when none do.  On four points the
remaining type contains exactly two triples.  For a regular two-graph, the
coherent, mixed, and incoherent four-set families have explicit 2-design
parameters.

Retain before reading Paper III:

- Paper III's “aligned” condition means all four triple values agree and hence
  combines the coherent and incoherent four-set types;
- complement swaps coherent with incoherent and preserves their union;
- switching changes a graph representative but not its two-graph; global
  negation complements the triangle values; and
- the Greaves--Suda conference theorem supplies a stronger 3-design statement
  for the determinant fibre than regular-two-graph counting alone.

Paper-III comparison test: require a one-sentence translation at the first use
of “aligned” and keep all four equivalence operations distinct thereafter.

## Reading packets

### Packet H — Hitchin / algebraic-geometry and harmonic source

Read Extracts H1 and H2 first, then:

1. Nigel Hitchin, *Spherical harmonics and the icosahedron*, Introduction,
   Sections 2--3 and 7--10, Appendix.  Cached full text:
   `10.1090/crmp/047/14`, SHA-256
   `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
2. Nigel Hitchin, *Vector bundles and the icosahedron*, Sections 2--5 and
   Theorems 4--5.  Cached full text: `10.1090/conm/522/10292`, SHA-256
   `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.

Then read the Paper III abstract, Introduction, Sections 2--4, the harmonic
section, and the marking appendix.  Open `ARTIFACT.md` only after freezing the
first proof report.  Require the report to name the earliest place where the
cited complex geometry fails to imply the stated rational scheme assertion.

### Packet G — Greaves or Suda / conference-design referee

Read Extracts G1, E1, and T1 first, then:

1. Greaves--Suda, *Constructions of t-designs from weighing matrices and
   walk-regular graphs*, Table 1, Theorem 2.2, Example 2.3.  Cached full text:
   `arXiv:2402.17528`, SHA-256
   `230c4cb862cd51f0d51f20af91c56f2e7453f2e2472114bda6c42b3a5af99e32`.
2. Haemers--Parsaei Majd, *Spectral symmetry in conference matrices*,
   Sections 2--4.  Cached full text: `10.1007/s10623-021-00858-8`, SHA-256
   `86a4d6e41f62ef224f5a410653120794bf756ad9a9e2dc2aaa4bdc2f4f4c799e`.
3. Gillespie, *Equiangular lines, incoherent sets and quasi-symmetric
   designs*, Section 2.2 and Proposition 4.1.  Cached full text:
   `arXiv:1809.05739`, SHA-256
   `3d8e2103efefaf7c24a75129584acb9c968248b53e307989f62c7cf4e6c1fa75`.
4. Jolliffe, *A short proof of the rank formula for inclusion matrices*,
   Theorem 1 and the characteristic-zero specialization.  Cached full text:
   `arXiv:2009.05202`, SHA-256
   `704ce59ca9808d05bd1405f71f651d05ae3b8b6692f3920d1336519190c05578`.

Then read Paper III's entire golden-operator section.  Recompute the design
parameters and the second exchange moment.  Treat the six-row outer table as a
separate audit, not as a consequence of the design theorem.

### Packet X — Snowden / outer invariant-theory referee

Read Extract X1 first, then:

1. Howard--Millson--Snowden--Vakil, *A description of the outer automorphism
   of S6, and the invariants of six points in projective space*, Sections
   1.1--1.6 and 2.1--2.2.  Cached full text:
   `10.1016/j.jcta.2008.01.004`, SHA-256
   `a875f0bccccc42db97703e9cadf52648a3f4e41b429abd0b05ef84bf6725043c`.
2. The same authors, *The equations for the moduli space of n points on the
   line*, Introduction and the six-point exception, DOI
   `10.1215/00127094-2008-063`.  This item was checked at metadata/full-text
   preview depth, not ingested into the cache for this dossier.

Then read the Paper III abstract, the marked-orientation section, and the
“Four cubic shadows” subsection.  Independently recompute Table (5.1), the
sign representation under an odd relabelling, the centered-square formula,
and the diagonal Clebsch section.  The report must distinguish projective
coordinate equivalence from exact equality of polynomials.

### Packet R — Si Kaddour / reconstruction referee

Read Extracts R1--R3 and T1 first, then:

1. Dammak--Lopez--Pouzet--Si Kaddour, *Hypomorphy of graphs up to
   complementation*, Introduction, Theorem 1.1, and the inclusion-rank
   reduction.  Cached full text: `arXiv:math/0601118`, SHA-256
   `95dacb0ed74c3c09f37857201dfbf9b6e72e4502c0f396baf3c705d38bde4f29`.
2. Pouzet--Si Kaddour, *Isomorphy up to complementation*, Theorems 1--2 and
   the `h=3` specialization.  Cached full text: `arXiv:1501.05181`, SHA-256
   `cf9d5463dc97bafa9fc7038c65bf73d271bf1198f27c301ad9b7c768b60a85a7`.
3. Holtz--Sturmfels, *Hyperdeterminantal relations among symmetric principal
   minors*, Theorem 6.  Cached full text: `arXiv:math/0604374`, SHA-256
   `5b427b01748a535ee68db137899862cda75a4d491b765b4cac45355abee6780a`.
4. Brunel--Urschel, *Recovering a magnitude-symmetric matrix from its
   principal minors*, Introduction and recovery theorem.  Cached full text:
   `arXiv:2404.06302`, SHA-256
   `29ca1ae69a3a9ea956093c1d37d2b9898c8a011322c9ba00f0efce766e6a6f1a`.

Then read the Paper III abstract and “Reconstructing the signing” subsection.
Ignore the arithmetic sections.  The report must state the Paper III theorem's
input and output in the vocabulary of the two cited reconstruction papers and
identify the earliest unproved propagation of a complement convention.

### Packet E — Haemers / focused exchange-spectrum read

Read Extracts E1 and G1 first, then:

1. Haemers--Parsaei Majd, cached source above.
2. Magsino--Mixon--Parshall, *Kesten--McKay law for random subensembles of
   Paley equiangular tight frames*, the closed-walk moment setup.  Cached full
   text: `arXiv:1905.04360`, SHA-256
   `781cf488f66ab8821e3a03cbda8ebbe782df11228fa95a78f5d3b293e979b415`.
3. Jolliffe, cached source above.

Then read only the introduction's exchange claims and the “Exchange spectra”
subsection.  Recompute the characteristic polynomial at order six, the fourth
trace, the coefficient of `c_Y`, and both contradiction branches.  Do not read
earlier internal reviews or the later aligned-faithfulness theorem.

## Cold-read protocol

Each persona answers the same neutral questions after following its packet:

1. State the strongest theorem, or coherent theorem package, that you believe
   the paper proves.
2. Reconstruct the causal proof without using the supplement as a proof
   premise.
3. Identify the earliest implication you cannot justify from the text and the
   assigned sources.
4. Check fields, base change, normality, labels, signs, equivalence relations,
   and exceptional orders at that implication.
5. Separate false statements, proof gaps, citation overreach, normalization
   ambiguity, and exposition friction.
6. Give `GO`, `MINOR`, or `MAJOR`, with at most five findings ranked by effect
   on the headline theorem.
7. State the paper's contribution relative to the packet in one sentence.  If
   the sentence is a list of unrelated results, say what common mechanism is
   missing from the exposition.
8. State whether the article meets an *Advances in Mathematics* significance
   and cross-field readability bar assuming every proof is repaired.

The first four reports are frozen independently before synthesis.  A reader
may inspect the read-only supplement after the PDF pass, but must record which
supplemental files affected a finding.  No reader sees another report until
all first-pass verdicts are frozen.

## Source ledger

### Full text actually read for dossier preparation

- Hitchin, *Spherical harmonics and the icosahedron* — cached key and SHA in
  Packet H; relevant introduction, pairing, fixed-icosahedron, counting,
  Clebsch, general-case, and invariant sections read.
- Hitchin, *Vector bundles and the icosahedron* — cached key and SHA in Packet
  H; relevant representation, bundle, isotropic-space, Mukai--Umemura, and
  Chern-count sections read.
- Howard--Millson--Snowden--Vakil, outer `S_6` paper — cached key and SHA in
  Packet X; full paper read.
- Greaves--Suda — cached key and SHA in Packet G; determinant preliminaries,
  Table 1, and conference Example 2.3 read.
- Haemers--Parsaei Majd — cached key and SHA in Packet G; switching,
  conference, and complementary-block spectral theorem read.
- Gillespie — cached key and SHA in Packet G; two-graph dictionary and
  four-set design proposition read.
- Dammak--Lopez--Pouzet--Si Kaddour — cached key and SHA in Packet R;
  definitions, main theorem, and incidence-rank setup read.
- Pouzet--Si Kaddour — cached key and SHA in Packet R; main threshold theorems
  and `h=3` specialization read.
- Holtz--Sturmfels — cached key and SHA in Packet R; principal-minor
  reconstruction theorem read.
- Brunel--Urschel — cached key and SHA in Packet R; abstract, problem
  distinction, and quadratic-query claim read.
- Jolliffe — cached key and SHA in Packet G; theorem statement and matrix
  orientation read.

### Metadata, abstract, or publisher-preview depth only

- Howard--Millson--Snowden--Vakil, *The equations for the moduli space of n
  points on the line*, DOI `10.1215/00127094-2008-063`.
- Boussaïri--Souktani--Zouagui, *Characterization of k-spectrally monomorphic
  two-graphs*, DOI `10.1016/j.laa.2024.04.026`; publisher theorem preview read,
  full text not cached.
- Attas--Boussaïri--Souktani, *Characterization of k-spectrally monomorphic
  Hermitian matrices*, cached as `arXiv:1907.05817`, SHA-256
  `a51abeb59f39129514f87c4f28ace738c256679bc866ad3aeb7335662993afe0`;
  abstract and theorem summary only.
- Current institutional/editorial pages for Hitchin, Greaves, Suda, Snowden,
  Haemers, Pantev, and Lieblich; used only for current activity and editorial
  plausibility, not for mathematical conventions.

### Supplemental material read

- standalone `README.md`;
- standalone `ARTIFACT.md`;
- standalone `literature-boundaries.md`;
- the current Paper III manuscript source corresponding to the frozen PDF.

The cache records fetched bytes, not reading; the depths above are the reading
record for this dossier.  No claim here that a result is absent from the
literature goes beyond the paper's own qualified public ledger.

## Recommendation

Run the first batch as four sealed reads:

1. Hitchin persona — arithmetic incidence, orientation boundary, and harmonic
   normalization;
2. Greaves or Suda persona — full operator section, designs, and finite sign
   tables;
3. Snowden persona — marked outer coordinates and classical cubic shadows;
4. Si Kaddour persona — aligned faithfulness, literature comparison, and query
   exposition.

The acceptance target is not unanimous `GO`.  It is:

- no unresolved field/scheme gap in the rational incidence theorem;
- exact agreement of every signed outer coordinate and scalar convention;
- an independently reproducible exchange and design proof;
- a seven-point reconstruction proof with no hidden complement-consistency
  step;
- a correct, generous related-work boundary; and
- agreement by at least one geometric and one combinatorial reader that the
  marked source--shadow--return mechanism is a coherent *Advances*-level paper
  rather than an anthology of identities.
