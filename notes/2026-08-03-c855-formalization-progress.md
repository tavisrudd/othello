# C855 — Paper I formalization progress (checklist section 2)

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact standards remediation
**Scope:** new self-contained modules in the human-spine base package
`~/src/lean/finitegeom` under `RelativeConicArcs/`, closing gaps recorded in Part D of
`2026-08-02-c855-paper-i-assertion-inventory.md`. No gate rewiring, manifest edit, rename,
or generated-leaf change; those are batched for a later window.

Every module is elaborated through the guarded single-file entry point with
`--root /home/tavis/src/lean/finitegeom`. Axiom audits are recorded from the module's own
`#print axioms` lines.

## Author policy in force

Human structural proof wherever possible: the mechanism a referee reads, not decidable
enumeration. Finite checking is a last resort and must first be compressed by a proved
structural reduction. Anything irreducibly certificate-shaped is scoped out to the
certificate package and recorded here rather than built.

## Modules landed

### `RelativeConicArcs/ConicFillingOrderElimination.lean`

Commit `e13eba2`. Closes the arithmetic half of the companion's cross-field uniqueness
theorem (`thm:why11`), inventory row "the arithmetic elimination of candidate orders needs
an explicit terminal".

Terminals: `order_le_eleven_of_window`, `not_isPrimePow_ten`, `candidate_orders`,
`not_six_pairwise_adjacent`, `order_eq_eleven`.

Mechanism. The conic-filling window gives `c = (q - 6) * (q - 9)` with `c ≤ 15`; both factors
grow, so `q ≥ 12` already forces `c ≥ 18` and the order is at most eleven. Ten is removed by a
two-line primality argument: two and five both divide it, and a prime power has one prime
divisor. The order-nine exclusion is isolated as a graph statement — six pairwise adjacent
vertices cannot exist in a graph whose cliques have at most five vertices — with the
identification of the passant-join relation with the Sylvester graph's distance-two relation,
and its clique value five, left as hypotheses. The final terminal combines the two.

Axiom audit: `candidate_orders`, `not_six_pairwise_adjacent`, and `order_eq_eleven` each
depend only on `propext`, `Classical.choice`, `Quot.sound`. No `sorry`, native execution, or
project axiom.

Remaining for this row: the Sylvester identification and the clique value five are external
transfers (Brouwer–Cohen–Neumaier / Jurišić–Vidali, Abiad–Jabal Ameli–Reijnders) and stay
open as hypotheses of `order_eq_eleven`.

### `RelativeConicArcs/GoldenOrderConductorTwo.lean` (audit lines added)

Commit `6b0aa57`. No mathematical change: the module's eleven public declarations now each
carry a `#print axioms` line, matching its sibling. All eleven depend only on some subset of
`propext`, `Classical.choice`, `Quot.sound`; three depend on `propext` alone.

### `RelativeConicArcs/ClebschFamilyRegimes.lean` (input discharge added)

Commit `f315ffc`. The module's counting layer was parameterized by four numerical
hypotheses. Two of them are now discharged structurally and the third is recorded in the form
the conic supplies it:

- `card_threeElementSupports` — a length-six code has exactly twenty three-element coordinate
  supports, so the leader count per coset is not an assumed number;
- `card_dimensionThree` — a dimension-three code over the field of `q` elements has `q ^ 3`
  words;
- `conicPoints_at_order_eleven` — the twelve maximum-distance directions are the rational
  points of the conic at order eleven;
- `witness_deepHole_counts_of_structure` — the same counts `120 / 2400 / 159720` from those
  structural inputs instead of the bare numerals.

Status wording for the inventory: the deep-hole count corollary (`cor:named-variety`) is
**counting layer closed, bridge open**. What remains is the geometric bridge — that the
uncovered locus is the conic and that minimum-weight leaders of a maximum-distance coset
biject with three-element supports — which lives in the arc-to-coset dictionary, still an
external transfer. The uncovered-formula hypothesis of the order-regime terminals is likewise
still supplied by `ClebschChordDefect` rather than discharged inside this module.

All terminals depend only on `propext`, `Classical.choice`, `Quot.sound`;
`conicPoints_at_order_eleven` depends on no axioms.

### `RelativeConicArcs/PartialLinearSpaceCodeWeight.lean`

Commit `eef498b`. Closes the companion's parity argument and elementary weight lower bound of
eight, inventory row "The parity argument and the elementary weight lower bound of eight".

Terminals: `natCast_mul_total_sum_eq_zero`, `even_card_support`, `card_support_ge_of_ne_zero`,
`even_and_eight_le_card_support`.

Mechanism, entirely structural and stated for an arbitrary partial linear space rather than for
one field order. Points and lines are abstract finite types, a line being given by its point set;
every point lies on exactly `r` lines and two distinct lines share at most one point. For a word
of the binary incidence kernel, summing the line equations counts each point `r` times, so odd `r`
forces the total sum to vanish and the weight to be even. If the word is nonzero at a point, each
of the `r` lines through that point must carry a second support point, and those second points are
pairwise distinct because their lines already meet at the chosen point; hence the weight is at
least `r + 1`. The final terminal is the specialization to degree seven, giving even weight at
least eight, which is the passant/internal-point incidence structure of a nonsingular conic in the
plane of order thirteen.

Axiom audit: all four terminals depend only on `propext`, `Classical.choice`, `Quot.sound`.

Remaining for this row: the value seven — that every internal point lies on exactly seven passants
at order thirteen — is a hypothesis, as is the partial-linear-space condition. The subsequent
weight-eight and weight-ten exclusions are untouched and remain certificate-shaped.

### `RelativeConicArcs/CodeArcDictionaryTransport.lean`

Commit `689c25b`. Closes the inventory row "The coding restatement of the small-arc
classification".

Terminals: `monEquiv_of_arc_classification`, `property_codeLocus_of_arc`. Both depend on no
axioms at all.

Mechanism. The restatement is transport along the arc-to-code dictionary, so the module isolates
exactly that: arcs, codes, the two equivalence relations, and the two loci are abstract, the
dictionary and the locus identification are hypotheses, and the theorem is that a two-member arc
classification transports to a two-member code classification up to monomial equivalence, with a
converse producing the syndrome locus of each named code.

What this deliberately does not close: the dictionary itself — projective equivalence of unordered
parity-check column sets equals monomial equivalence of the codes — is still a hypothesis and
remains a separate open row of the inventory, as is the underlying geometric classification for
arc sizes four through eight.

### `RelativeConicArcs/ComplementaryTriangleSign.lean`

Commit `56e4edc`. Closes the sign relation on complementary triples and the three-index
principal-minor value, from the inventory row "The principal-minor values, Jacobi
complementary-minor step, and the sign relation on complementary triples".

Terminals: `det_fin_three_of_symm_diag_zero`, `det_five_sub_sq`, `mul_apply_split`,
`triangleProduct_complement`, `triangleProduct_eq_one_or_neg_one`. The predicate
`IsSignedOrbital` packages the four defining conditions on the six-index integer matrix `B`:
symmetric, vanishing diagonal, off-diagonal entries `±1`, and `B * B = 5 • 1`.

Mechanism, and the reason this is a human proof rather than a check. Split the six indices into a
triple and its complement, writing `B` in blocks `[[X, Y], [Yᵀ, Z]]`. The off-diagonal block of the
defining identity is `X * Y + Y * Z = 0` and the diagonal block is `X * X + Y * Yᵀ = 5 • 1`. For a
three-index symmetric matrix with vanishing diagonal and unit entries, the second identity forces
`det (Y * Yᵀ) = 16`, so `Y` has nonzero determinant; taking determinants in the first identity then
gives `det X = - det Z`. Since the determinant of a symmetric three-index matrix with vanishing
diagonal is exactly twice its triangle product, the two triangle products are opposite. The only
finite case analysis is the eight sign choices inside the single three-by-three determinant
evaluation; no sign pattern of `B` itself is enumerated.

This supersedes the manuscript's route through Jacobi's complementary-minor identity for the
sign relation, which matters because Mathlib has no complementary-minor identity: a bounded search
of `Mathlib/LinearAlgebra/Matrix/` finds none. It also yields the twenty-support bipartition in
substance — triangle products are never zero, and complementation reverses their sign, so the
twenty triples fall into two classes exchanged by complementation.

Axiom audit: all five terminals depend only on `propext`, `Classical.choice`, `Quot.sound`.

Remaining for these rows: the principal-minor values `5` in size four and `0` in size five still
need either Jacobi's complementary-minor identity or a separate argument; and the explicit
cardinality statement that each of the two triple classes has exactly ten members still needs the
passage from an arbitrary three-element `Finset (Fin 6)` to a splitting equivalence
`Fin 3 ⊕ Fin 3 ≃ Fin 6`, after which the count follows from `Nat.choose 6 3 = 20` and the
fixed-point-free sign-reversing involution proved here.

## Status per attempted target

- Deep-hole count corollary (`cor:named-variety`) — counting layer closed, bridge open. Landed in
  `ClebschFamilyRegimes`; the arc-to-coset dictionary remains an external transfer.
- Candidate-order elimination in the cross-field uniqueness theorem — closed, modulo the Sylvester
  graph identification and its clique value, which stay as named hypotheses.
- Parity weight lower bound of eight — closed structurally for any partial linear space of odd
  constant point degree.
- Coding restatement of the small-arc classification — closed as an explicit transport; the
  dictionary and the geometric classification remain hypotheses.
- Principal minors and the complementary sign relation — sign relation and the size-three minor
  closed structurally; size-four and size-five values open.
- Twenty-support bipartition — the sign-reversing complementation is closed; the explicit
  ten-and-ten cardinality terminal is open and needs only the `Finset`-to-equivalence passage.

## Targets not started

Work stopped here so the finitegeom build window can go to the shared-library dependency
inversion. The following remain open for the resumption, in the order they were queued:

1. The switching-class uniqueness and pentagon argument. The structural half is cheap and was
   scoped but not written: in the gauge where the first row of `B` is all ones, the vanishing of
   the corresponding entries of `B * B` says that among the four remaining signs in each row
   exactly two are positive, so the positive edges on the other five indices form a two-regular
   graph, hence a pentagon; and the same computation excludes a constant sign pattern outright.
   The residual — that the twelve labelled pentagons form a single class up to relabelling — is a
   finite classification and should go to the certificate package rather than the human spine.
2. Connectivity of the five-valent orbital graph and the exclusion of constant sign patterns. The
   arithmetic shadow falls out of item 1. The manuscript's own route is group-theoretic and needs
   two things the base library does not have: an orbital-graph connectivity criterion, namely that
   the orbital graph of a suborbit is connected exactly when the point stabilizer together with one
   suborbit representative generates the group, and the subgroup classification of the alternating
   group of degree five that identifies the dihedral group of order ten as the only proper subgroup
   strictly between the cyclic group of order five and the whole group. Scoped out pending that
   prerequisite.
3. The explicit ten-and-ten terminal for the twenty-support bipartition, as described above.
4. The size-four and size-five principal-minor values, blocked on Jacobi's complementary-minor
   identity, which Mathlib does not supply.

Nothing in this session touched the aggregate gate, any manifest, any generated leaf, or any
existing declaration name; the six new commits are additive modules plus two audit and discharge
additions to last night's pair.
