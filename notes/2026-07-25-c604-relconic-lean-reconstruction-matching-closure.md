# C604 relconic Lean reconstruction and matching-design closure

**Lane:** `relconic`

**Status:** COMPLETE — exact reconstruction, equivariant stabilizer recovery,
zero-defect matching rigidity, exact counts, and edge/vertex stability of the
bad-concurrence graph are imported by the Relconic gate; the trust and manuscript
records agree with the checked boundary.

## Goal

Close the paper-facing Lean gap for:

1. exact recovery of a projective arc from its ordinary uncovered locus above
   the strict incidence threshold, including the canonical secant/vertex
   reconstruction and semilinear-stabilizer equality; and
2. the zero-defect concurrence decomposition, maximum-matching design, exact
   centre counts, bad-edge stability theorem, and secant-deletion cleanup
   theorem.

Finish by importing the public declarations through
`RelativeConicArcs.Gates.Relconic`, auditing their axioms, and synchronizing
the trust manifest, proof audit, and manuscript verification table with the
actual checked boundary.

## Ordered execution

1. **Terence--Tao diagnostic first.** Before designing declarations or editing
   Lean, identify the invariant formulation Tao would seek, the smallest
   reusable incidence/Kneser interface, hidden finiteness or Desarguesian
   hypotheses, sharpness and converse questions, and whether one abstraction
   proves both reconstruction and matching rigidity without coupling unrelated
   paper notation. Record the resulting theorem-shape decisions here.
2. Read the nested Lean guide and inventory only the directly relevant
   existing definitions and theorem signatures.
3. Formalize exact uncovered-locus reconstruction and the canonical inverse /
   stabilizer corollary.
4. Formalize concurrence-clique decomposition, zero-defect
   `MATCH(k,floor(k/2),1)` rigidity, exact centre counts, and bad-edge
   stability.
5. Validate through the scoped Relconic gate, run the required axiom audit,
   and reconcile every paper/trust statement with the declarations actually
   imported.
6. Run the required `ej`+`tt` closeout, record the mystery ledger, and complete
   the normal relconic task lifecycle.

## Initial Terence--Tao diagnostic

The invariant object is not the prescribed conic and not a coordinate model.
It is a finite linear-space incidence structure together with a complete-graph
edge realization: vertices are arc points, edges are their secant lines, and
disjoint edge pairs acquire the unique intersection point of their realized
lines.  The two theorem families should share that edge/secant vocabulary but
should not be forced through one oversized paper-specific structure.

The smallest reusable split is:

1. a line-union recovery lemma saying that two finite families of `N` distinct
   lines with equal point unions are equal when every line has more than `N`
   points and two distinct lines meet in at most one point;
2. an arc-secants interface proving injectivity of the edge-to-line map,
   characterizing the arc vertices intrinsically among the secant lines, and
   making this reconstruction equivariant under incidence automorphisms; and
3. a finite matching interface on the two-subsets of the vertex type, where
   each intersection centre indexes the matching of secants through it and
   uniqueness of line intersection partitions all pairs of disjoint edges.

This yields the canonical inverse in two visibly separate steps.  Equality of
ordinary uncovered loci is equality of secant-line unions, so the first lemma
recovers the secant family under
`q + 1 > binom k 2`.  For `k >= 3`, the points incident with `k - 1` recovered
secants are exactly the arc vertices: an off-arc point sees a matching and
therefore at most `floor (k / 2)` secants.  Naturality of this intrinsic
description gives equality of setwise stabilizers for any incidence-preserving
action; semilinear projective maps are an application, not a hypothesis of the
core theorem.

The concurrence theorem is likewise incidence-combinatorial.  At a centre,
the incident realized edges form a matching because three arc points are not
collinear.  Every pair of disjoint edges belongs to exactly one such matching,
so the nontrivial centres give a clique decomposition of the Kneser graph.
Zero defect is used only after this decomposition, to force every clique to
have maximum size.  The resulting family is then a simple
`MATCH(k, floor(k/2), 1)` design; its total number of centres and the number
through a fixed secant are finite double counts.  The bad-edge statement
should be an abstract weighted-partition inequality fed by the already proved
defect identity, rather than a second geometric proof.

Hidden hypotheses to expose in declarations are finiteness and decidable
equality for counts; simplicity of the projective incidence structure; uniform
line size only for the numerical recovery threshold; injectivity of the
secant realization from the arc condition; `k >= 3` for the intrinsic vertex
threshold; and `k >= 4` for the nontrivial matching-design interpretation and
divisions in its counts.  Neither
Desarguesian coordinates, a field, characteristic, a conic, nor parity belongs
in the core reconstruction or decomposition theorem.  Desarguesian and
characteristic hypotheses remain confined to later classification
corollaries, which C604 does not formalize.

Sharpness questions delimit the implementation.  The strict line threshold is
essential for this elementary recovery mechanism: at equality a line can be
covered pointwise by its intersections with the competing family.  The
matching-design conclusion has no converse to projective realizability; an
abstract `MATCH` design need not admit a rank-three secant realization.  The
quantitative C583 estimates are not free consequences of the exact inverse:
they require Bonferroni/pair-count inequalities and degree corrections, so
they remain outside C604.  Likewise, zero defect is sufficient for maximum
matchings, but the formal result must not imply that every maximum-matching
design comes from an arc or that every such arc is conic-compatible.

## Implemented theorem boundary

`RelativeConicArcs.UncoveredLocusReconstruction` now follows the manuscript
proof in its displayed order:

1. `linesAboveUncoveredThreshold_eq_secants` identifies the secants as exactly
   the lines containing more than `choose k 2` points outside the ordinary
   uncovered locus;
2. `verticesOfLineFamily_secants_eq` identifies the vertices as exactly the
   points incident with `k - 1` recovered secants for `k >= 3`;
3. `canonical_reconstruction` packages those two inverse stages;
4. `eq_of_ordinaryUncovered_eq` proves literal recovery of equal-sized arcs;
   and
5. `stabilizes_iff_stabilizes_ordinaryUncovered` proves the equivariant
   stabilizer equality used for projective semilinear transformations.

The implementation reuses the existing exact vertex-index theorem
`Nucleus.pointIndex_eq_card_sub_one_of_mem`.  This corrected the diagnostic's
initial conservative `k >= 4` boundary to the manuscript's sharp `k >= 3`
boundary; no manuscript hypothesis or proof step was strengthened silently.

`RelativeConicArcs.MatchingDesignRigidity` matches the equality subsection's
proof structure:

- `concurrence_matching` and
  `disjoint_arcPairs_existsUnique_concurrence` give the matching cliques and
  unique Kneser-edge decomposition;
- `concurrence_matching_injective` proves simplicity;
- `concurrenceCenter_pointIndex_eq_half` gives maximum matchings at zero
  defect;
- `concurrenceCenters_card_eq_quotient` and
  `concurrenceCentersOnPair_card_eq_quotient` give the exact total and
  per-secant counts for `k >= 4`, with their multiplicative double-count
  identities retained as denominator-free terminals; and
- `two_mul_badConcurrenceEdgeCount_le` proves the paper's bad-edge stability
  inequality in the integer-normalized defect convention; and
- `exists_secantDeletionSet_at_centers` constructs the cleanup centrewise,
  while `exists_secantDeletionSet` states the paper-facing consequence:
  deleting at most `scaledDefect = floor(k/2)·Δ` secants leaves every pair of
  disjoint surviving secants with a unique concurrence point of maximum
  index.

The quantitative two-parent inverse from the later reconstruction section is
not imported into this boundary; it remains logically separate, as the paper
itself separates its Bonferroni and lost-degree proof from the exact inverse.

## Validation

- `RelativeConicArcs.UncoveredLocusReconstruction` and
  `RelativeConicArcs.MatchingDesignRigidity` pass guarded single-file
  elaboration.
- The guarded build queue compiled both modules and
  `RelativeConicArcs.Gates.Relconic`; the final exact-target trace-only
  aggregate gate passed.
- The gate prints axioms for fourteen paper-facing terminals.  Every one
  reports exactly `[propext, Classical.choice, Quot.sound]`; none reports
  `sorry`, `admit`, a custom axiom, or `native_decide`.
- `make -C papers arcs` passes.  The tracked 22-page PDF has no undefined
  references, undefined citations, or overfull boxes.
- Referee-facing review found no task identifiers, workflow references,
  status prose, or unresolved placeholders in either new module or the
  modified gate.

## `ej` + `tt` closeout

The cheap extra value was to expose the count results as quotients, not merely
as multiplicative double-count identities.  For `k >= 4`,
`concurrenceCenters_card_eq_quotient` proves
`|Z| = 3 * choose k 4 / choose (floor(k/2)) 2`, and
`concurrenceCentersOnPair_card_eq_quotient` proves the exact per-secant
quotient.  Their denominator-free forms remain available for arithmetic
specialization.

The final Tao-style check compared the formal dependency graph with the prose
proof rather than only comparing conclusions.  It settled the one mismatch
found by the initial diagnostic: vertex recovery is valid at `k >= 3`, not
merely `k >= 4`, because the existing exact vertex-index theorem supplies
`k - 1` incident secants while the external matching bound supplies
`floor(k/2)`.  The formal reconstruction now follows the paper's two displayed
maps in order.  Matching rigidity likewise follows the paper's decomposition,
maximum-index, second-moment, fixed-secant, and pointwise bad-edge steps.

The semilinear stabilizer statement is recorded at its exact formal boundary.
`stabilizes_iff_stabilizes_ordinaryUncovered` is an equivariant action theorem:
it assumes preservation of arc size, the arc condition, and ordinary
uncovered loci.  The manuscript proof verifies these hypotheses for
projective semilinear transformations.  The trust table does not claim that a
separate formal model of `PΓL(3,q)` is present.

## Mystery ledger

- **Recovery threshold and small `k`: settled.**  The strict line threshold is
  the only large-field hypothesis, and vertex recovery has the manuscript's
  exact `k >= 3` boundary.
- **Count division: settled.**  The kernel now checks both multiplicative
  double counts and their exact quotient forms for `k >= 4`.
- **Semilinear group packaging: boundary explicit.**  The kernel checks the
  general equivariant stabilizer theorem; the paper supplies the elementary
  specialization to `PΓL(3,q)`.  A dedicated Mathlib-level semilinear
  projective group model would be reusable infrastructure, but no paper claim
  depends on presenting that packaging as already formalized.
- **Quantitative two-parent inversion: deliberately separate.**  Its
  Bonferroni, point-pair, and lost-degree inequalities are not consequences of
  the exact inverse interface and were not pulled into this task.
- **Sharpness of secant deletion: open.**  The manuscript's slack identity
  separates local defect slack from overlap among the chosen deletion sets.
  Equality requires no intermediate-index hole, requires every bad off-hole
  centre to have index `m - 1`, and requires disjoint local deletion sets.
  No realizable equality example or universal overlap-sensitive improvement is
  presently established; pursuing either would require a separately allocated
  successor.
- **Incidental discoveries:** none.  All observations arose from the planned
  theorem/prose comparison, so the discovery companion requires no entry.

## Acceptance boundary

- No manuscript claim may say reconstruction or matching rigidity is
  kernel-checked unless a named theorem is imported by the Relconic gate.
- The axiom report must remain within the documented Mathlib foundations, with
  no `sorry`, `admit`, custom axiom, or `native_decide`.
- The quantitative C583 inverse-stability package is out of scope unless the
  initial diagnostic shows it is a free consequence of the exact
  reconstruction interface; otherwise retain it as a separately allocatable
  successor.
- The Singular-backed ten-point rank-three classification is out of scope; its
  explicit non-Lean trust boundary must remain visible.
