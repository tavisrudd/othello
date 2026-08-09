# C898 Paper I cold read, round 1 — editorial/significance

**Verdict:** `MAJOR`

**Frozen surface:** `papers/clebsch-rigidity/clebsch_rigidity.pdf`, SHA-256
`95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`.

**Persona packet:** Packet E — a JCTA finite-geometry and coding editor deciding
whether to send the paper out and what expertise is required.

## Initial report (PDF only; frozen before supplement)

### Editorial decision

The paper contains a plausible, crisp, and potentially publishable inverse theorem, but I
would not send this version out unchanged. The first structural pillar is a coherent JCTA
paper: a six-arc in `PG(2,11)` whose uncovered locus is contained in a conic is forced to
be the Clebsch hexagon, and its deep-hole locus therefore recognizes the associated
non-GRS code. The uniform conic-filling window and concurrence spectrum reinforce that
story. The orientation/cubic half is substantial mathematics, but it begins a second paper
in a different language and asks the reader to accept two important finite/algebraic
exhaustions through descriptions of checks not present in the PDF. The resulting manuscript
needs a major architectural and expository revision, not a change of mathematical premise.

If the orientation half is retained, the referee team needs (at minimum) one finite
geometer conversant with arcs, conics, and Dye's Clebsch theory; one coding theorist able
to audit the syndrome/coset-leader reconstruction; and one specialist in two-graphs,
icosahedral representations, and determinantal cubics. A single finite-geometry/coding
referee is not a credible audit of Section 8.

### Strongest theorem

The strongest theorem at the paper's declared center is Theorem 1.1: for a six-arc
`A` in `PG(2,11)`, mere containment of its uncovered (equivalently projective
deep-hole-syndrome) locus in an arbitrary conic already forces `A` into the unique
Clebsch orbit; the locus is then exactly a nonsingular conic and the code is recovered up
to monomial equivalence. Theorem 8.1 and Corollary 8.2 form a deeper but less integrated
second package: support ambiguity recovers a switching class `B` with `B^2=5I`, its
triangle-holonomy cubic, a six-node frame, and the order `Z[B]`.

### Causal proof reconstruction

For a six-arc, count incidences of its fifteen chords with off-arc points. Pair-counting
shows that the number of uncovered points is `22-c(A)` at order eleven, where `c(A)` is
the number of triple-chord concurrence points. A direct line bound says that a conic,
including a degenerate one supported on at most two rational lines, can contain at most
twelve uncovered points. Dye's bound `c(A)<=10` gives at least twelve uncovered points,
so conic containment forces equality, ten Brianchon points, and hence Dye's unique
Clebsch orbit. Dye's associated conic is missed by all fifteen chords; equality of the two
twelve-point sets then identifies it with the entire uncovered locus. The parity-check
arc/syndrome dictionary converts this to code reconstruction and supplies the exact
distance and leader multiplicities.

The decoder's secant-index-three directions recover the ten Brianchon matchings. Five
self-polar triangle matchings identify these with the ten complementary pairs of
three-coordinate supports, producing an unordered `10+10` support-orbit partition. On
the antipodal double cover of the twelve conic points, either five-valent orbital restricts
to a signed conference matrix `B`; a pentagon calculation gives `B^2=5I`, while triangle
products `B_ij B_jk B_ki` recover the support signs. Principal-minor expansion yields the
determinant pencil. A cross-eigenspace compression then identifies the cubic's six singular
axis classes, from which the claimed `S5/A5` symmetry and integral commutant are read.

### Earliest unsupported implication

The first implication I cannot independently justify from the PDF occurs in Proposition
6.3 (pp. 12–13): the asserted seven-orbit partition of all 133 projective points, including
the three 30-point blocks and uniqueness of the 12-point block, is certified by unnamed
normalized projectivities, 133-entry action rows, block labels, and breadth-first word
ledgers that are not displayed. The cited Dye results identify the geometrically named
small orbits, but the PDF does not supply the finite data needed to audit the full partition.
This is best classified as a missing in-paper finite certificate/explanation, not evidence
that the orbit statement is false. A later and more consequential instance occurs on p. 21,
where simultaneous vanishing of five gradient quadrics is asserted to leave exactly six
axis classes; again the human derivation is replaced by a statement that the result is
kernel-checked.

### Controlling findings

1. **Novelty/significance.** The symmetry-free inverse implication is the paper's clear
   editorial reason to exist: maximum-distance syndrome directions recover a non-GRS
   parity-check geometry without assuming its conic, polarity, or `A5` action. It is
   specific to a small exceptional configuration, but the proof mechanism (chord defect
   plus a containing-curve bound and an equality classification) and the uniform
   conic-filling window give it reach beyond a bare `q=11` census.

2. **Exposition/cohesion.** Sections 2–6 tell one finite-geometry/coding story; Sections
   7–8 change the central object, vocabulary, proof technology, and referee expertise.
   The support bridge is real, but it does not make the long two-graph/determinantal-cubic
   development feel necessary to the inverse theorem. Split that development, or reduce
   it to a sharply stated consequence with a short conceptual proof. As written, neither
   pillar receives the focused hierarchy it deserves.

3. **Proof/computation.** Proposition 6.3 and the singular-locus exhaustion are presented
   as prose summaries of undisplayed action tables or kernel checks. Section 9 clearly
   states the trust boundary, but a formal or computational cross-check cannot substitute
   for the human bridge at the exact point where completeness is claimed. State a
   compact auditable certificate or give the missing mathematical argument in the body.

4. **Exposition.** Section 8 is not yet readable at external-review speed. The proof moves
   from orbital graphs to switching classes, representation decompositions, trace-dual
   determinantal spaces, gradient exhaustion, node Hessians, frame normalizers, and an
   integral commutant with too little local orientation. In particular, the irreducibility,
   tensor-product, invariant-cubic, and gradient-classification steps are compressed at the
   same level as routine calculations, obscuring which implication carries the real risk.

5. **Theorem hierarchy/significance.** The abstract and introduction advertise inverse
   rigidity, exact decoder statistics, a field window, a concurrence spectrum, a support
   bipartition, a golden operator, a cubic threefold, an integral order, and a four-paper
   program. The first theorem is memorable; the accumulation makes it harder to identify.
   Lead with Theorem 1.1 and its reusable mechanism, demote exact census data, and remove
   series administration and companion-paper promotion from the mathematical opening.

### Novelty relative to Packet E

Relative to the packet's classical Clebsch, large-arc, and symmetry-assuming sources, the
one-sentence novelty claim is: **conic containment of the complete deep-hole syndrome
locus, with no Clebsch symmetry assumed, forces the order-eleven six-arc and then lets
decoder support ambiguity recover its unoriented golden two-graph and cubic.**

## Public-supplement postscript

I inspected only Packet E's allowed public sources after freezing the report above.

- Ball--Lavrauw, `arXiv:1908.10772`, SHA-256
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`:
  Theorem 17 confirms the standard arc/MDS correspondence. The large-arc
  classification and completion sections obtain rigidity or unique completion under
  hypotheses designed for arcs much larger than six points. They therefore clarify the
  background dictionary and reinforce Remark 4.3, but do not supply the manuscript's
  small-arc inverse theorem.

- Dye, journal pp. 275--281 (authoritative page scans): Theorems 1--4 and their
  corollaries begin with a Clebsch hexagon, defined by ten Brianchon points, and prove
  existence, projective transitivity, the unique self-polar polarity, the `A5` stabilizer,
  and transitivity relative to a fixed conic. The page-281 orbit theorem also supports the
  twelve conic points arising from polars of the six vertices at order eleven. This resolves
  the classical input and confirms that the manuscript's implication from an *unlabelled
  containing conic for `U(A)`* to the Clebsch orbit is not already one of Dye's theorem
  statements. It does not resolve the undisplayed full 133-point orbit certificate in
  Proposition 6.3.

- Storme--Van Maldeghem, DOI `10.1016/0097-3165(95)90051-9`, SHA-256
  `770f27f1e22b29e077ee17c9747c7f529f27ed4b26e5408f2a1dae5c56363d3b`:
  Propositions 11--12 construct and establish projective uniqueness of the six-arc and
  ten-arc *under an assumed `A5` action*; Proposition 13 classifies complete
  2-transitive arcs. These results confirm the classical object and its symmetry-assuming
  classification but do not pre-empt a symmetry-free recognition theorem from the
  uncovered locus.

- The [public JCTA scope](https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a)
  expressly includes finite geometries, codes, and algebraic geometry over finite fields,
  while setting a high significance threshold. The subject fit is therefore exact. The
  venue criterion makes it more important, not less, to present the six-point exceptional
  theorem as a reusable inverse method and to prevent the cubic half from obscuring that
  advance.

The supplement strengthens the novelty and venue-fit assessment and resolves the
load-bearing classical attribution for Theorem 1.1. It does not resolve the PDF's human
auditability gaps, theorem-hierarchy problem, or two-paper cohesion problem. The verdict
remains `MAJOR`.
