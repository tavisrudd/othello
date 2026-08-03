# C855 — certificate and trusted-execution scoping decision memo

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact standards remediation
**Scope of this record:** the certificate-scoping decision for every finite-certificate and
trusted-execution family named in the Paper I computational companion, per Part D of
`notes/2026-08-02-c855-paper-i-assertion-inventory.md`. Read-only: no Lean source,
manuscript, manifest, generated leaf, or verification artifact was edited, and no build,
generator, or gate was run.

## Author policy governing every recommendation below

Set by the author, 2026-08-03, and applied throughout:

1. **Human structural proof is preferred wherever possible.** Route (b) is the default
   recommendation for every family.
2. **Certificates are a last resort.** Route (a), a verified Lean checker over a finite
   domain, may be recommended only after arguing why no structural compression eliminates or
   drastically shrinks the domain.
3. **Where a certificate is unavoidable, structure must compress it as far as possible.** The
   deliverable is a proved reduction that shrinks the checked domain, leaving only an
   irreducible finite core to the checker. Each route (a) recommendation below must therefore
   name the compression and the size of the residual core, not just the raw domain.
4. **Route (c), shared infrastructure with Paper IV's C834 closure, composes with the above,
   and shared *structural* mechanisms are preferred over shared certificate data.**
5. **Bulky certificate cores stay out of the human-proof spine.** The export repositories
   exist to keep the structural spine easy to review and build churn low; see the placement
   section near the end.

## Standing technical constraints

- Sharding rule (`lean/AGENTS.md`, proof-engineering invariants): finite-certificate
  sharding must cross module boundaries — a definitions-only base, bounded leaf modules, a
  light aggregator, leaves landed before the aggregator is probed. Splitting cases inside one
  module does not bound elaborator memory.
- Parameter-space rule: when a finite object is the image of a much smaller parameter space,
  run the exhaustive predicate on the parameters and transport symbolically. This is the
  sharding rule's own statement of the compression policy above.
- Table rule: when `decide`/`norm_num` is blocked by an opaque finite operation, introduce one
  reducible table evaluator and prove a symbolic bridge.
- `native_decide` is not a release proof endpoint (Paper IV's declared standard in
  `notes/clebsch-tasks/c834-paper-iv-full-lean-release-closure.md`, which Paper I must at
  least match).
- Measured cost anchors from Paper IV: direct kernel reduction of one raw isolated weight-ten
  shard (9.3e5 states) already exceeds the measured memory gate; the 1.67e8-element cycle
  disjointness product became tractable only after the manuscript's geometric rejection search
  replaced it, sharded seven ways. Treat ~1e6 as the direct-kernel ceiling per leaf module and
  ~1e8 as the proved-checker ceiling per sharded family — but note that Paper IV's own
  successful route was compression, not a bigger checker.

## Package topology (why sharing is not automatic)

| package                            | root                                                            | depends on                                  |
|------------------------------------|-----------------------------------------------------------------|---------------------------------------------|
| shared base library `finitegeom`   | `lean/` in this repository, mirrored to `~/src/lean/finitegeom`  | Mathlib                                     |
| Paper I human-spine export         | `~/src/lean/finitegeom-paper-i-base`                             | filtered export of the base library         |
| Paper I q11 certificates           | `~/src/lean/finitegeom-clebsch-q11-certificates`                 | `finitegeom` git, pinned `570086982b26075a` |
| Paper IV q13 certificates          | `papers/q13-passant-code/lean-certificates`                      | monorepo `lean/` by relative path           |

The q13 **semantic and structural** layer already lives in the shared base library as
`RelativeConicArcs.PassantCodeQ13.{Geometry, WeightEight, WeightTen, Rank, AssociationAlgebra,
Reconstruction, LogicalSpine, StructuralUpgrade}`. Paper I can reach all of it by bumping its
`finitegeom` pin — no relocation needed, only an audit-boundary decision, since the pinned
commit is the audited base commit recorded in the trust manifest.

The heavy **certificate leaves** (`PassantCodeQ13.WeightTen.IsolatedReachability.*`,
`WeightTen.CycleExclusion.*`, `MinimumWords.RowUniqueness.*`, `AssociationTransport.*` — 180
tracked `.lean` files) live in Paper IV's paper-owned package, reachable only by relative path
inside the monorepo. Paper I's certificate package is a standalone git repository and cannot
require it as published today. That split is correct and should be preserved, not flattened;
what may move into the shared base library is the *proved reduction*, never the generated data.

For scale calibration, Paper I's q11 certificate package is currently 121 `.lean` files and
8,196 lines, of which 113 files are generated `Q11A5PointOrbits*` shards for a single order-60
group action on 133 points. That is what one uncompressed finite object costs, and the README
already records that the main paper's own proofs do not depend on those tables — they are a
redundant replay. It is a standing example of a certificate that structure made unnecessary.

## Family 1 — the exhaustive conic-distance audit over all 160,930 nonsingular conics

**Evidence artifacts.** `papers/clebsch-rigidity/check_global_conic_gap.py` (the enumerator;
asserts `nonsingular_count == 11**2 * (11**3 - 1) == 160930`);
`papers/clebsch-rigidity/verification/build_finite_census_certificates.py` (imports that
enumerator at its line 24); `papers/clebsch-rigidity/verification/finite_census_certificates.json`,
where each of the fifteen `q11_six_arc_census.records` rows carries a `conic_gap` block with
`intersection_histogram` (summing to exactly 160,930), `nearest_conics`, `delta`, and one
attaining `witness` conic. Trust row: `c725_finite_boundary_manifest.json` claim
`q11-six-arc-census-and-numerical-gap`, mode
`orbit-mass-and-concurrence-certificate-plus-exhaustive-conic-audit`, boundary text "the orbit
ledger is direct; absence of a nearer conic remains an exhaustive exact audit". Companion prose:
lines 294–298 and the trust table at line 771 of `clebsch_rigidity_computational_companion.tex`.

**Domain size.** 160,930 conics × 15 classes against uncovered loci of 12 to 22 points: roughly
4.6e7 form evaluations over the field of eleven elements plus a max-and-histogram fold. No XOR,
monoid, or state compression is available, because the fold ranges over the conic parameter
space itself.

**Recommended route: (b) structural reproof. The certificate disappears entirely.**

The companion already says the load-bearing part is not the audit: "Theorem~\ref{thm:rigidity}
supplies the final conic-containment assertion." A nonsingular conic in the plane of order
eleven has exactly twelve rational points, so any uncovered locus of size at least thirteen
cannot be contained in one. The census gives every non-Clebsch class an uncovered size of at
least sixteen. Containment therefore fails by cardinality in one line, against the existing
conic-cardinality layer in `RelativeConicArcs`, given the family 4 census bound.

The 160,930-conic enumeration establishes only the strictly stronger *metric* statement — how
near the nearest conic comes, recorded as `delta` and the histogram maximum (10 for class C01,
with `nearest_conics` = 1) — and no assertion in the paper or the companion consumes that
number. The action is: prove the cardinality lemma, cite it where the companion cites the
audit, and restate the histogram as an exhaustive exact computation reported for sharpness with
no theorem resting on it. This removes the companion's largest exhaustive domain from the
formal surface and deletes a trusted-execution row rather than converting it into an
unprovable one.

If the author wants the metric statement itself preserved as a claim, see the acceptance-bar
section; nothing else in the paper needs it.

## Family 2 — the q13/q17/q19 root-edge orbit DAGs and the maximum-six classifications

**Evidence artifacts.** Generator `verification/c725_terminal_orbit_dag.py`; data
`verification/c725_terminal_orbit_dag.json.gz` (1.1 MB compressed, schema
`clebsch-c725-terminal-passant-orbit-dag-v1`); hash `verification/c725_terminal_orbit_dag.sha256`;
independent labelled backtracking replay `verification/c725_terminal_orbit_dag_replay.py` and
`verification/c725_terminal_orbit_dag_replay.json`; per-order summaries
`verification/conic_filling_q13.json`, `conic_filling_q17.json`, `conic_filling_q19.json`;
independent summary `verification/conic_filling_independent.json`; runners
`verification/conic_filling_replay.py`, `verification/conic_filling_verify.py`, and the compiled
search `verification/conic_filling_search.cpp`. Paper-root checker `check_small_k_conic_filling.py`.
Trust rows: `q13-q17-q19-maximum-passant-arc-size-six` and
`q17-q19-terminal-six-arc-projective-classification`. Manuscript: `thm:small-k-conic-filling`
and the root-edge orbit DAG table.

**Domain size and the compression already present.** The labelled domain is what the
independent replay walks: `labelled_arcs_by_size` = [7098, 71526, 123123, 15288, 546] at order
thirteen, [20808, 390048, 1555296, 913104, 50184] at seventeen, and [32490, 782325, 4301220,
3962412, 395124] at nineteen — about 9.5e6 labelled arcs at order nineteen. The orbit DAG is
already the group-theoretic quotient of that: 604 nodes at thirteen (10 root edge orbits, 2
projective six-arc orbits), 4,442 at seventeen (13 roots, 22 orbits), 11,260 at nineteen (15
roots, 94 orbits). Off-conic point counts are 169/289/361 and passant edge counts
7,098/20,808/32,490. So a factor of roughly 840 of structural compression has already been
taken by quotienting by the conic-preserving group; the certificate as shipped is the
*compressed* object, not the raw one.

**Recommended route: (b) first, with a concrete structural target; (a) only as fallback, and
then with two further compressions specified below.**

*The structural attack, which should be attempted before any checker is built.* The companion
already contains "the exterior-set reduction and the conceptual exclusion at the first terminal
order through the weight-eight impossibility" — a human proof that disposes of order thirteen
without enumeration. The question C855 must answer first is whether that argument is uniform in
the order. Its ingredients are available in already-formalized or already-drafted form: the
chord-defect identity `ClebschChordDefect.chordDefect_identity_of_moments`, the six-arc line
bound `OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five`, and the
weight-eight clique bound whose exact upper value five rests on the five-row unique-closure
proof recorded in the `boundary` field of `verification/c722_clique_structure.json`. If the
exterior-set reduction extends uniformly to orders seventeen and nineteen, this family is
deleted outright and the DAG becomes descriptive data, exactly as in family 1. This is the
highest-value structural attempt in the whole of C855 and should be time-boxed generously
rather than skipped in favour of engineering.

*If the uniform argument does not close, the fallback checker must be compressed twice more
before any data is imported.*

- **Compression A — terminate at level six, never enumerate level seven.** The mathematical
  claim is that no seven-point passant arc exists. The certificate currently ships the full
  level structure. But the chord-defect identity plus the Brianchon-count identity
  `ClebschDye.sixArc_uncovered_add_brianchon_card` derive a six-arc's extension count from its
  triple-concurrence count, which is a fold over twenty triples of six stored points. So the
  no-seven-point-node claim reduces to a per-six-arc-orbit arithmetic check with no level-seven
  search at all: 2, 22, and 94 orbits at the three orders. That is 118 arithmetic checks in
  place of the 546/50,184/395,124 labelled six-arc terminals.
- **Compression B — the residual irreducible core is orbit completeness at levels two through
  six.** What survives is the statement that the listed six-arc orbits are all of them, which
  is a coverage obligation on the DAG's `extension_orbits`: for each node, the listed orbits
  account for every valid one-point extension of that node's representative up to the node's
  stabilizer in the conic-preserving group (order q³−q, so 6,840 at order nineteen). This is
  roughly 11,260 nodes × 361 candidate points ≈ 4.1e6 incidence decisions at order nineteen —
  the irreducible finite core, and about 0.4 percent of the labelled domain.

Checker design for that core, if it is reached: keep arcs as index lists into the enumerated
off-conic point list (the existing `terminal_obstruction_legend` already encodes rejection
reasons as small integers), give the passant/collinearity relation one reducible table
evaluator over the off-conic index range, and prove the symbolic bridge to the field equation
once, so every per-node check reduces through the table rather than through modular arithmetic.
That is the same shape as `PassantCodeQ13.WeightTen.SyndromeBits`, which characterizes every bit
of a stored incidence syndrome by induction on the row bound and then proves the two bitwise
obstruction tests are exactly "no common passant" and "a passant through three points". Paper I
needs the identical dictionary at orders thirteen, seventeen, and nineteen, so this is a shared
structural mechanism (route (c)) rather than new work.

Sharding shape: definitions-only base with the point and line tables and the extension
predicate; one leaf per root edge orbit (10/13/15, so 38 leaves total) carrying that root's
node list and coverage checks; one aggregator per order for the rooted mass identity; one
cross-order aggregator for the maximum-six statement. The partition is by root edge orbit,
which is a mathematical partition and satisfies the shard-naming rule. The order-nineteen
leaves at roughly 750 nodes each are the binding constraint.

## Family 3 — the q13 weight-ten XOR-disjointness domains

**Evidence artifacts.** `verification/c723_q13_weight10_profiles.py` (generator),
`verification/c723_q13_weight10_profiles.json` (certificate), and
`verification/c723_q13_weight10_independent.py` (the dynamic-programming replay). Trust row:
`q13-weight-ten-profile-exclusions`. Manuscript: the weight-ten exclusion inside
`thm:q13-tangent-code`.

**Domain size.** `profile_s0` is seven records, one per `special_fibre`, each with `raw_domain`
933,120 — total 6,531,840. `profile_s2` is a single record with `raw_domain` 166,561,920 and
`right_unique` 771,024. Both record `intersection_size` 0 with SHA-256 digests of the left and
right syndrome sets. Supporting fields: `base_point` [1,0,2], `conic` XZ−Y²=0,
`local_partition` (7 passant fibres, 6 points per fibre excluding the base, 35 secant
neighbours), `parity_derivation` giving the two admissible occupancy solutions (s=0 with
occupancies [3,1,1,1,1,1,1]; s=2 with all ones), `symmetry_boundary` recording that transitivity
of the projective group on internal points makes the fixed-base exclusion global, and
`certified_conclusion` "no weight-ten kernel word containing the fixed base point".

**Recommended route: (c) shared structural mechanism with C834 — and specifically, import the
*compressed* form, not the raw product.**

This family is the policy's own best illustration, because Paper IV already ran it. The raw
cycle-profile domain is 166,561,920, and C834 measured that the disjointness product stays at
1.67e8 regardless of how it is split and that projection does not shorten an exact-traversal
transition list. The closure came from replacing the product by the manuscript's *geometric
rejection search*: seven residue shards discharging all 595 secant pairs, with no generated
data, no generator, and no group action
(`notes/2026-08-02-c834-cycle-profile-kernel-exclusion.md`). That is a compression from 1.67e8
to 595 — the structural reduction the policy asks for, already achieved. Paper I must cite that
route and must not import or rebuild the 1.67e8 product.

The certificate's own `parity_derivation` shows the same discipline one level up: the reduction
from arbitrary weight-ten supports to exactly two occupancy solutions is a parity argument, not
a search, and `symmetry_boundary` is a transitivity argument that makes a fixed-base exclusion
global. Both are human structural proofs already written in the companion; only the two
residual profile exclusions were ever finite.

The isolated profile (7 × 933,120 = 6,531,840) is currently closed in Paper IV by seven
kernel-reduced generated-layer certificates covering the complete Cartesian choice domain
(`notes/2026-08-02-c834-isolated-weight-ten-reachability.md`). Since the cycle branch turned out
to admit a purely geometric rejection with no generated data at all, **C855 should ask the C834
owner whether the same geometric rejection compresses the isolated branch**, which would delete
the last generated weight-ten data from both papers. That question is cheap to ask and has the
largest payoff of any item in this family.

What Paper I imports, in preference order (structural mechanisms first, data last):

| Paper IV module                                          | what it supplies                                                                                          | kind        |
|----------------------------------------------------------|------------------------------------------------------------------------------------------------------------|-------------|
| `RelativeConicArcs.PassantCodeQ13.WeightTen` (base lib)  | `arbitrary_weightTen_word_has_pencil_profile`, the semantic dichotomy everything else attaches to           | structural  |
| `PassantCodeQ13.WeightTen.SyndromeBits`                  | `testBit_columnSyndrome`, `and_columnSyndrome_eq_zero_iff`, `and_columnSyndrome_ne_zero_iff`                | structural  |
| `PassantCodeQ13.WeightTen.PencilTransport`               | `internalPointAt_val`, `passantLineAt_val`, `incidentAt_iff`, `mem_linesThroughBase`, `mem_fibreOf`, `mem_fibres_flatten`, `mem_secantNeighbors` | structural  |
| `PassantCodeQ13.WeightTen.CycleExclusion.*`              | the seven residue shards of the geometric rejection search over 595 secant pairs                            | compressed  |
| `PassantCodeQ13.WeightTen.Reachability`                  | `selectBits`, `selectBits_xor`, `selectBits_foldl_xor`, `ChoicePath`, `choicePath_of_mem_choices`, coverage soundness — a paper-agnostic reduction, not data | reduction   |
| `PassantCodeQ13.WeightTen.IsolatedReachability.*`        | the seven isolated-profile leaves; import only if the geometric rejection does not extend                   | certificate |

`Reachability` is genuinely paper-agnostic: its docstring states the general principle that a
finite certificate may replace one large Cartesian elaboration by explicit reachable-state lists
whose exact traversal equality is kernel-checked, so external generation carries no logical
authority. It is a *proved reduction*, small and reviewable, and belongs in the shared base
library — for example as `RelativeConicArcs.FiniteCertificates.XorReachability`, with the state
type left as `Nat`, option lists as `List (List Nat)`, and the projection generalized from
`selectBits` to any XOR homomorphism, so a caller supplies only transition tables, a projection,
and a terminal list. The generated leaves that consume it stay in the certificate packages.

**Residual caveat.** C834's report records that `RelativeConicArcs.PassantCodeQ13.WeightTen`
still discharges its pencil cardinality, joining-line uniqueness, and secant/passant
complementarity by native evaluation, and that the list-versus-finset assembly and the
projective transport of an arbitrary support point to the base point remain open. Paper I
inherits those and must not advertise this family as closed until C834 closes them. That is
schedule coupling, not mathematical risk.

## Family 4 — the fifteen-class q11 census, orbit ledger, low-degree rigidity, gap, and extension spectrum

**Evidence artifacts.** `verification/build_finite_census_certificates.py`;
`verification/finite_census_certificates.json` (`q11_six_arc_census` with
`normalized_domain_mass` 1548, `ordered_frames_per_arc` 360, and fifteen `records`, each with
`id`, `representative`, `stabilizer_order`, `normalized_orbit_mass`, `triple_concurrences`,
`uncovered_size_from_chord_defect`, `quadratic_rank_witness`, `cubic_rank_witness`, and the
`conic_gap` block treated under family 1); `verification/finite_census_certificates.sha256`;
paper-root checkers `check_low_degree_loci.py`, `check_perturbation_gap.py`,
`check_global_conic_gap.py`. Trust rows: `q11-six-arc-census-and-numerical-gap` and
`q11-low-degree-rigidity`. Manuscript: `tab:fifteen-classes`, `prop:low-degree-rigidity`,
`cor:monomial-characterization`, `rem:degree-threshold`, `thm:gap`, and the extension spectrum
with multiplicities (6,30,150,300,630,360,72) summing to 1548.

**How much of this is already structural.** More than the trust table admits, and separating
the pieces is the main work of this family.

- *Low-degree rigidity is already structural evidence, not a search.* `cubic_rank_witness`
  stores ten points and a nonzero determinant modulo eleven; `quadratic_rank_witness` stores six
  points and a nonzero determinant. The mathematical content is: an explicit nonsingular minor
  of the evaluation map on the ten-dimensional cubic (six-dimensional quadratic) form space
  proves full rank, hence trivial kernel, hence no form of that degree vanishes on the class's
  uncovered locus. That is a witness-based human proof whose only finite content is one
  determinant per class per degree — thirty determinants in total. Nothing is enumerated. Route
  (b) with a displayed witness; no checker is needed beyond ordinary kernel arithmetic.
- *The uncovered sizes are derived, not measured.* `uncovered_size_from_chord_defect` is exactly
  what its name says: the already-formalized chord-defect identity
  `ClebschChordDefect.chordDefect_identity_of_moments` derives the uncovered cardinality from the
  triple-concurrence count. The certificate stores concurrences and derives sizes.
- *Part of the numerical gap is free, and the residue is sharp and small.* The Brianchon-count
  identity `ClebschDye.sixArc_uncovered_add_brianchon_card` writes uncovered size as twenty-two
  minus the concurrence count, and Dye's bound of ten with equality only for the Clebsch class
  gives every non-Clebsch class at most nine concurrences, hence uncovered size at least
  thirteen — for free, structurally, with no census. The observed spectrum {12,16,18,19,20,21,22}
  corresponds to concurrence counts {10,6,4,3,2,1,0}, so the *entire* remaining content of
  `thm:gap` is the exclusion of concurrence counts seven, eight, and nine, i.e. uncovered sizes
  thirteen, fourteen, fifteen. That is a statement about configurations of fifteen chords of a
  six-arc admitting seven to nine triple concurrences, and it is a strong candidate for a
  direct combinatorial argument on the one-factorization structure that already underlies the
  six-arc line bound. **Attempting that exclusion structurally is the single highest-leverage
  item in family 4**, because success reduces `thm:gap` to a human proof and demotes the census
  to descriptive data.

**Recommended route: (b) for low-degree rigidity and for the free part of the gap; (b) attempted
for the concurrence exclusion; (a) only for the residual census completeness, and then over an
already-tiny compressed domain.**

The residual finite core, if the concurrence exclusion does not close structurally, is small by
construction. Frame normalization fixes four of the six points as the standard frame, so the
domain is the two-point extensions of that frame: at most C(129,2) ≈ 8.3e3 candidate pairs,
filtered by the arc condition to exactly 1548, with twenty collinearity determinants per
candidate — roughly 1.7e5 field operations, inside the direct-kernel ceiling. That is the
parameter-space rule applied correctly: run the predicate on the two free points, transport
symbolically to six-arc membership, and never materialize the 557,280 ordered-frame
presentations. Sharding: definitions-only base with the frame, the point table, and the
collinearity evaluator; one leaf for the 1548-domain enumeration and its multiplicity fold; one
light aggregator. The fifteen per-class rank witnesses do not need leaves at all.

**Shared structural mechanism neither paper has yet.** Both need an *orbit ledger* abstraction —
Paper I here and in families 2 and 5, Paper IV in packet 3 (stabilizers of the four intrinsic
minimum-word families) and packet 5. This is a reduction, not data, so it belongs in the shared
base library and should be built once. Proposed API:

- input: a decidable domain predicate on a parameter type, an enumeration of that parameter type
  proved complete, a canonical-key function, and a list of representative records each carrying
  a key, a stabilizer order, and an orbit mass;
- checked side conditions: every enumerated domain member's key occurs exactly once among the
  representatives; each representative satisfies the domain predicate; the masses sum to the
  domain mass;
- exported theorems: the keys partition the domain, the representative list is exhaustive up to
  the key relation, and the orbit–stabilizer identity holds row by row.

Its shape should be agreed with the C834 owner before either paper hard-codes its own.

## Family 5 — the q11/q13 seven-arc leaves and the 1548-presentation conic-inscribed subcensus

**Evidence artifacts.** `verification/finite_census_certificates.json`, key
`seven_arc_exclusions`: the order-eleven entry with `normalized_domain_mass` 140,
`ordered_frames_per_arc` 840, and a single record `q11-O01` (orbit mass 140, stabilizer order 6,
nine triple concurrences, uncovered size 12, six-point `quadratic_rank_witness`); the
order-thirteen entry with `normalized_domain_mass` 1680 and two records `q13-O01`, `q13-O02`
(orbit mass 840 each, trivial stabilizer, fifteen triple concurrences, uncovered size 14). Trust
row: `q11-q13-seven-arc-exclusions`. The conic-inscribed subcensus lives in
`check_global_conic_gap.py` (asserting the 1548 domain at its lines 210 and 303) and in the
companion's statement of all 1548 frame-normalized presentations, the 252 with vertices on a
nonsingular conic, and their uncovered-size histogram. Existing Lean:
`SmallKGeometricBridge.sevenArc_primePower_conic_card_spectra`, `...fourArc_uncovered_card`,
`...fourArc_conic_card_order`, `...fiveArc_not_conic_card`.

**Recommended route: (b), and this family should not need a checker at all.**

The seven-arc data is three records. One orbit at order eleven and two at order thirteen, each
with a displayed representative, a stabilizer order, a concurrence count, and a quadratic minor
witness. Every conclusion drawn from them — the uncovered sizes 12 and 14, the exclusion of
conic filling — follows from the chord-defect identity applied to the stored concurrence count
plus one determinant witness, exactly as in family 4's low-degree rigidity. These are witnessed
human proofs with displayed data, and they should be written as such rather than as certificate
rows. The only genuinely finite obligation is orbit completeness (that there are no other
orbits), which is the same obligation as family 4's and is discharged by the same ledger
mechanism over a 140-element and a 1680-element domain — small enough that it is a single leaf,
not a sharded family.

The conic-inscribed subcensus is one extra decidable filter and one histogram fold over family
4's already-enumerated 1548 domain, so it costs nothing beyond family 4 and adds no new core.

## Family 6 — the q13 minimum-word classification, concurrence profiles, and association-scheme reconstruction

**Evidence artifacts.** `verification/c722_clique_structure.py` and
`verification/c722_clique_structure.json` (keyed `q9` and `q13`, carrying adjacency and
complement characteristic polynomials and inertia, character blocks, orbit sizes, difference
sets, six-colouring class sizes, Rayleigh/interlacing/colouring-dual clique bounds, the
five-clique witness, and an explicit `boundary` field recording that the exact Fourier and
inertia analysis does *not* improve the six-colour dual bound, so the exact upper bound five
still rests on the five-row unique-closure proof); paper-root checker `check_q13_tangent_code.py`.
Trust rows: `q13-weight-eight-exclusion` and the companion's trusted-execution rows for the
minimum-layer classification. Manuscript: `thm:q13-tangent-code` in full — parameters, 364
minimum words in four orbits with named stabilizers, spanning, the association scheme, the
incidence matrix, and the automorphism group; plus the concurrence profiles and the
identification of the seventy-eight zero-triple seven-cliques with the incidence rows.

**Recommended route: (c), in the strong form — Paper I cites Paper IV's structural terminals and
formalizes nothing here itself.**

The companion already routes this development to Paper IV in its own prose, and Paper IV's
closure packets are themselves organized structurally, which is what the policy wants: C832's
theta packet is an integral quadratic-form positivity argument bounding every clique by five
rather than a clique enumeration; its moment packet is a double-counting identity; its
pair-reconstruction packet replaces triple-concurrence row selection by concurrence-eight
neighbourhoods. C834's packets 2 through 6 cover every clause of `thm:q13-tangent-code`. The
Lean surfaces exist as `PassantCodeQ13.MinimumWords.{Base, Exhaustion, Reconstruction, OrbitS4,
OrbitDihedral, OrbitDihedralA, OrbitDihedralB, OrbitDihedralC}`, the `MinimumWords.RowUniqueness.*`
residue shards, `PassantCodeQ13.AssociationAlgebra`, `PassantCodeQ13.AssociationTransport.*` with
its `RelationSquares` shards, and `PassantCodeQ13.Automorphisms.{Base, Signatures, FourthAnchor,
TripleOrbit, Transport}`.

Two items Paper I must track rather than duplicate. First, the weight-eight layer: its semantic
home is `RelativeConicArcs.PassantCodeQ13.WeightEight` in the *shared base library*, and that
module's own header states its terminal checks use native evaluation on 42 vertices and
therefore carry the declaration-local native-decision axiom. Under a theorem-complete bar that
blocks Paper I as much as Paper IV, and it is C834 packet 2's job. Second, the
`c722_clique_structure.json` boundary field is a recorded *negative* result — spectral methods do
not improve the bound — which is exactly the kind of finding that should stay in the companion
as prose and never become a certificate row.

Required API shape for Paper I's consumption is a small stable citation surface, not deep reuse:
Paper IV's aggregate should export, from `PassantCodeQ13.Gates.Main`, named theorem-shaped
terminals for minimum distance twelve, the 364-word exhaustion with its four families, and the
association-scheme reconstruction, each with a docstring stating its quantifier domain and trust
boundary, so Paper I's companion cites exact declaration names instead of restating finite data.

## Where surviving certificate cores must live

The export repositories exist to keep the human proof spine reviewable and build churn low, and
the recommendations above must respect that split:

- `~/src/lean/finitegeom` and its filtered export `~/src/lean/finitegeom-paper-i-base` carry the
  structural spine: the conic-cardinality lemma of family 1, the chord-defect and Brianchon-count
  identities, the low-degree rank witnesses, the seven-arc witnessed proofs, the orbit-ledger
  *abstraction*, and the relocated `XorReachability` *reduction*. All of these are small,
  reviewable, and stable.
- `~/src/lean/finitegeom-clebsch-q11-certificates` carries any surviving generated data for the
  q11 census, mirroring the split that already exists for the `Q11A5PointOrbits*` shards.
- Family 2's fallback checker, if it is reached, is 38 generated leaves at three field orders and
  must **not** enter the base library or the human-spine export. It needs its own terminal-orders
  certificate package alongside the q11 one, with the same shape: a git-published package
  requiring `finitegeom` at a pinned commit, so the spine's build is unaffected by regeneration.
- Nothing generated by Paper IV should be copied into a Paper I package. Route (c) is a
  dependency, not a fork.

The rule of thumb this yields: a *proved reduction* may enter the shared base library; *generated
leaves* may not.

## Risk ranking and what must be prototyped first

| rank | family                                              | route                              | why it is here                                                                                                                     |
|------|------------------------------------------------------|------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| 1    | 2 — root-edge orbit DAGs, maximum-six                | (b) attempted, (a) compressed fallback | the only family with a residual core (4.1e6 decisions, 38 leaves) that no existing mechanism covers; and the structural attempt is unproven |
| 2    | 1 — exhaustive conic-distance audit                  | (b)                                | structurally trivial to eliminate, but eliminating it is an acceptance-bar decision the author owns                                    |
| 3    | 6 — minimum words, concurrence, association scheme   | (c)                                | mathematically the largest, wholly owned by C834; Paper I's exposure is schedule coupling plus the native-evaluation weight-eight leaf |
| 4    | 4 — census, orbit ledger, low-degree rigidity, gap   | (b) mostly, (a) for residual completeness | the concurrence-exclusion attempt may delete the census entirely; if it fails the core is only 1.7e5 field operations                  |
| 5    | 3 — weight-ten XOR-disjointness                      | (c)                                | already compressed 1.67e8 → 595 by C834; residual risk is the unfinished semantic bridge and three native leaves                        |
| 6    | 5 — seven-arc leaves and conic-inscribed subcensus   | (b)                                | three records and one filter; witnessed human proofs plus a rider on family 4                                                          |

**Prototype and attempt order:**

1. **The uniform exterior-set/weight-eight exclusion at orders seventeen and nineteen** (family
   2, structural). Success deletes the largest surviving certificate family in C855. This is the
   first thing to attempt, before any checker engineering.
2. **The concurrence-count exclusion of seven, eight, and nine** (family 4, structural). Success
   reduces `thm:gap` to a human proof and demotes the fifteen-class census to descriptive data.
   Small, self-contained, and independent of item 1.
3. **The order-nineteen root-edge DAG leaf for a single root edge orbit** (family 2, fallback
   checker), with the reducible collinearity table and its symbolic bridge, elaborated under the
   measured profile. Build this only if item 1 fails; it is the go/no-go measurement for the
   fallback.
4. **The low-degree rigidity witnesses** (family 4). Thirty determinants; cheap, and it
   establishes the witnessed-proof presentation pattern, the docstring and naming conventions
   under the referee-facing rules, and the base-library-versus-certificate-package placement.
5. **The orbit-ledger abstraction**, negotiated with the C834 owner, then instantiated on the
   1548-presentation census and the two seven-arc domains.
6. **Ask the C834 owner whether the cycle branch's geometric rejection extends to the isolated
   weight-ten branch** (family 3). Cheap question, deletes the last generated weight-ten data
   from both papers if the answer is yes.

## Recommendation on the acceptance bar

**Under this policy, no family forces renegotiating the theorem-complete bar, provided family 1
is demoted.** That is the one decision the author must make, and it is a strengthening rather
than a weakening.

Family 1's 160,930-conic audit cannot become a kernel-checked theorem at any sharding. But
nothing depends on it: conic containment follows from the census bound of sixteen against the
twelve rational points of a nonsingular conic. Demoting the audit from a claim to an exhaustive
exact computation reported for sharpness removes a trusted-execution row from the companion's
trust table instead of preserving an unprovable one. The bar stays where it is and the artifact
gets stronger.

The bar would need renegotiation only in two contingencies, neither of which should be conceded
in advance:

- If the author wants the *metric* statement — how near the nearest conic comes — preserved as a
  claim rather than as reported computation. Then it keeps one declared trusted-execution mode,
  and the release ledger must state that exactly rather than implying kernel coverage.
- If the uniform exterior-set argument fails at orders seventeen and nineteen *and* the
  order-nineteen DAG leaf does not elaborate within the measured memory gate. Then
  `thm:small-k-conic-filling` at those two orders lands where family 1 is, and the same choice
  recurs. This is why the structural attempt is ranked first and the prototype third.

## Coordinated rename dependency

Eleven tracked files carry internal task identifiers in their filenames, all under
`papers/clebsch-rigidity/verification/`: `c722_clique_structure.json`, `c722_clique_structure.py`,
`c723_q13_weight10_independent.py`, `c723_q13_weight10_profiles.json`,
`c723_q13_weight10_profiles.py`, `c725_finite_boundary_manifest.json`,
`c725_terminal_orbit_dag.py`, `c725_terminal_orbit_dag.json.gz`, `c725_terminal_orbit_dag.sha256`,
`c725_terminal_orbit_dag_replay.py`, and `c725_terminal_orbit_dag_replay.json`. Every family
above except family 4's rank witnesses cites at least one of them. The rename is a coordinated
change across the two manifests, the release verifier, the README, and the manuscript prose, and
it must land *before* any Lean module cites these paths, because the referee-facing rules forbid
a Lean source from embedding a task identifier or deriving authority from an internal record.
Sequencing consequence: schedule the rename ahead of any family 2 data import. If the structural
attempts in items 1 and 2 above succeed, several of these files stop being formal evidence
altogether and become reproducibility appendices, which simplifies the rename considerably —
another reason to run the structural attempts before the rename rather than after.

## What this memo does not establish

No Lean was written, no build or generator was run, no elaboration cost was measured, and no
manuscript, manifest, or verification artifact was edited. Every elaboration estimate above is an
analogy from Paper IV's measured results, not a measurement of Paper I's data. The structural
attempts proposed in family 2 (uniform exterior-set exclusion) and family 4 (exclusion of
concurrence counts seven through nine) are proposals with plausible ingredients, not sketched
proofs; neither has been attempted. The family 1 demotion, the orbit-ledger API shape, the
relocation of the reachability reduction into the shared base library, and the creation of a
terminal-orders certificate package all require author or cross-lane agreement before
implementation.
