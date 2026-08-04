# C834 — Paper IV full Lean release closure

**Lane:** `clebsch`

**Status:** active; required dependency of C761 by author direction 2026-08-02

**Sequencing note (2026-08-03), informational — no action required of C834.** C860 stage 1 removes
the cap-game API (`CapGame.BuildGame`) from the Paper IV gate closure
`RelativeConicArcs.Gates.PassantCodeQ13`, and stages 2--4 relocate the remaining shared
projective-plane vocabulary into a documented `RelativeConicArcs` base. C834 must not audit,
document, or remediate any `ProjectiveCap` or `CapGame` module; a residual cap-game import in the
Paper IV closure after C860's stages is a defect to report to C860. See
`notes/2026-08-03-c860-execution-design.md`.

## Resume here (2026-08-04)

The shared library is closed. No source file under `lean/RelativeConicArcs/PassantCodeQ13/`
contains `native_decide`, both replacement proofs are elaborated and committed, and all 23
terminals of `RelativeConicArcs.Gates.PassantCodeQ13AxiomAudit` report axiom sets contained in
`[propext, Classical.choice, Quot.sound]`. Report:
`notes/2026-08-04-c834-shared-library-native-closure.md`.

The minimum-word orbit and concurrence layer of the paper's own package is also closed. Report:
`notes/2026-08-04-c834-minimum-word-kernel-closure.md`.

The association-transport packet and the hidden-field cubic are rewritten for kernel reduction but
**not yet elaborated**: the shared build tree's build-owner lock was held by another lane's q16
certificate gate for the whole of that session, so no elaboration, focused gate, or axiom audit
could be run. The mathematics is independently confirmed by the tracked generator, which refuses to
emit unless all nine identities the leaves state hold in exact integer arithmetic. Elaborating these
modules is the first task of the next build window; the exact order is in the report:
`notes/2026-08-04-c834-association-transport-kernel-closure.md`. An independent referee pass
reproduced every committed table and identity from the Lean definitions and found no soundness hole:
`notes/2026-08-04-c834-independent-review.md`. It also found that the round's first commit left the
paper's evidence verifier failing on two stale manifest records; that is repaired, the manifest now
records both generators, both generated data modules, and a statement-shape checker, and the
verifier passes.

The shared equivariance layer of stage 2 is written and committed, also unelaborated, together with
the transporter generator and its generated data, whose exhaustive self-checks pass. The open route
decision of stage 4 is resolved in favour of the symbolic route on stronger evidence than the plan
assumed. Report: `notes/2026-08-04-c834-equivariance-layer-and-ambient-plane-route.md`.

Three things the referee pass surfaced outrank the remaining leaf-by-leaf work. The four relation
identifications are the memory risk of the association-transport packet, not the orbit columns, and
should have the modular inversion removed from the checked predicate before anything is split. The
three native decisions of `PassantCodeQ13.AssociationAlgebra` prove the same identities the packet
has already reduced, in a parallel mask presentation, and need only a list identification and one
symbolic bridge. And the symmetric-square action is transitive on the internal points and on each of
the six relation classes, so an equivariance lemma plus two displayed transporters — a shared layer
the package has never built — deletes the largest automorphism enumeration outright and collapses
the structural upgrade's per-point and per-pair statements to a handful of representatives.

Assuming that elaboration succeeds, the paper package under
`papers/q13-passant-code/lean-certificates` has 44 native decisions across 31 modules — 16 in the
weight-ten profile certificates, 11 in the row-uniqueness transport, 8 in the structural upgrade, 4
in the automorphism anchors, 3 in the association algebra, and 2 in the fixed-point exhaustion.  The
two the anchors have lost are the matrix-quantified relation-preservation and bijectivity leaves,
rewritten by the stage 2 equivariance layer.

## Execution plan

Every remaining native decision, release surface, and pre-release accommodation is owned by exactly
one stage below. Stages 1 and 2 come first because their outcomes change the shape of later stages;
within a stage the order is free. The one open architectural decision is marked.

**Stage 1 — probes, before committing to any leaf work.** These are cheap and each one settles a
question that would otherwise be discovered after several failed builds.

1. Elaborate `AssociationTransport/RelationMasks/RhoZero.lean` and record its measured peak. It
   calibrates the cost of one kernel evaluation of the normalized polar invariant and therefore
   every remaining leaf that touches it, and it answers whether the kernel caches the reduction of
   `internalCoordinateList`.
2. Probe `WeightTen/Aggregate.lean`'s 595-element `List.mergeSort` for kernel reduction at
   acceptable cost. If it does not reduce, replace the sort by a sorted-insertion certificate or
   restate the partition as a multiset identity needing no sort. This is the second cliff candidate
   after the fixed-point exhaustion, and the probe is one small module.

**Stage 2 — the shared equivariance layer.** Three later stages consume it. Both items are written;
neither is elaborated.

3. Invariance of the normalized polar invariant under the symmetric-square action is proved
   symbolically in `PassantCodeQ13.SymmetricSquareInvariance`: the polar form and the discriminant
   acquire the same determinant factor and the invariant is bi-homogeneous of degree zero, so the
   two transformation laws are polynomial identities in the four matrix entries and six point
   coordinates. `Automorphisms.matrixAction_preservesRho`, the largest single native enumeration in
   the package, and `Automorphisms.matrixAction_bijective`, which the adjugate identity closes for
   free, are rewritten to consume it. What remains is elaboration and the axiom audit.
4. The displayed point transporter — one group element carrying the base internal point to each of
   the 78 — and the displayed pair transporter carrying each ordered distinct pair to one of six
   class representatives are generated and self-checked by
   `lean-certificates/generate_transporter_data.py`. What remains is the Lean theorem that each
   emitted index realizes its transport, kernel-checked once, and a measurement deciding whether the
   6006-entry pair table needs an index split. All six class representatives share the first point,
   so a pair statement reduces to one point statement and six second-point cases.

**Stage 3 — finish the association-transport round.**

5. Remove the modular inversion from the checked predicate of the four relation identifications
   before splitting anything, then elaborate the whole packet, `RelationCubic`, `StructuralUpgrade`
   and the package gate, and regenerate the axiom audit. A four-way row split of each relation
   module is the fallback if the inverse-free predicate is not enough.
6. Close the three association-algebra decisions: identify `relationMatrix v` with the displayed
   masks, prove one symbolic bridge from its `matrixProduct` to `maskProduct` and from `xorFour` to
   iterated `maskXor`, and take the ranks by kernel reduction on the displayed masks. Then narrow
   the disclosure in `AssociationTransport.lean`'s header, which currently records that this native
   evaluation exists in the import closure.

**Stage 4 — the structural upgrade's eight decisions.**

7. Reduce the per-point and per-pair statements through the stage 2 transporters:
   `unaryDegree_fiftySix` to one representative point, `pairColorEight_recovers_polarRows` and
   `fusedColorSix_splits` to six representative pairs. Pack pair concurrence as one mask per ordered
   pair, not as a scalar table; the mask form makes `fusedColorSix_splits` a single module of about
   fifty thousand kernel steps, the scalar form needs roughly six blocks.
8. Transport the toric cardinalities and parities and the determinant-conic cardinality from
   `Finset` filters over the subtype universes to filters over the displayed coordinate lists,
   reusing the packed incidence table the package already carries.
9. **The two ambient-plane axioms — symbolic route, confirmed.** Only one of the two is an
   obligation: plane incidence is a symmetric bilinear expression, so the dual statement is the
   first with its arguments exchanged. The step previously taken to be the real obligation, that a
   vanishing cross product forces collinearity, is in the pinned Mathlib as
   `crossProduct_ne_zero_iff_linearIndependent`; `dot_self_cross`, `dot_cross_self` and
   `cross_cross_eq_smul_sub_smul` from the same file give incidence of the join and the uniqueness
   expansion `L × (p × q) = (L · q) p − (L · p) q` without computation. The remaining normalization
   dictionary — nonzero representatives, normalization as a rescaling, and equality of proportional
   normalized representatives — is already proved in `PassantCodeQ13.SymmetricSquareInvariance` and
   is consumed rather than rebuilt. The tabulation fallback is not needed and is not to be built.
   Projective normalization remains unavailable: the package's group acts through the symmetric
   square and preserves the conic, so it is not transitive on ordered pairs of arbitrary plane
   points.

**Stage 5 — the remaining enumerations, where tabulation is the right tool.**

10. Row uniqueness: tabulate over the existing seven-way residue shard. The structural route loses
    here — a triple-indexed transporter costs as much as the enumeration it replaces, and the index
    ordering guard is not equivariant, so the statement would first have to be restated over sets.
11. Automorphism anchors: the anchor triple is fixed, so no orbit reduction applies; tabulate the
    signature statements. Stage 2 has already removed the expensive one.
12. Weight-ten profiles: the seven isolated fibres and seven cycle residues are shard-sized by
    construction and run on the established reachability kernel. Base-point normalization is already
    their structural reduction; no further one exists.
13. Fixed-point exhaustion: `fixedPoint_slices_are_stabilizer_orbits` reduces to a packed
    action-index table over the order-28 stabilizer and is small. `fixedPoint_weightTwelveExhaustion`
    needs a proved checker in the style of the weight-ten reachability kernel; its cheap half is
    exhibiting the solutions and its expensive half is excluding every other candidate, which no
    table removes. Both leaves also use `eraseDups` and `toFinset`, which are quadratic in decidable
    equality and need attention independently of the search.

**Stage 6 — the release surfaces.** The task card requires seven; only the axiom transcript and part
of generated-artifact provenance have had any work, and the rest had no owner before this plan.

14. Statement identity: a tracked map from each manuscript clause to its Lean statement, with the
    same schema discipline as the other numbered papers.
15. Claim-by-claim trust manifest, distinguishing kernel, certificate, classical and human proof
    modes exactly, with no clause advertised as kernel-checked that is not.
16. Theorem-to-source formal map.
17. Public release allowlist, and a release verifier that actively rejects a native-evaluation or
    trusted-execution placeholder rather than merely reporting one.
18. Refresh the referee-facing module inventory in `verification/README.md`. Its "Lean release
    layout" is missing every module added by the association-transport round and by the minimum-word
    round before it. Rebuild the list from the package rather than appending, and do it after the
    leaf work, since a check that has to be split adds modules.
19. Exercise a clean-checkout build of the full aggregate under the pinned toolchain with the
    companion present. This has never been run, because the companion is currently excluded from the
    export.

**Stage 7 — reverse the pre-release accommodations.** All five are listed in the section below and
none was scheduled before this plan: the `papers/repositories.toml` exclusion and its `Makefile`
rewrite, the companion-absent skip in `verify_evidence.py`, the two README sentences, the
repository-relative `lean-certificates/` paths in the manuscript and `verification/README.md`, and
the `git rm` in the standalone mirror. They are reversed only once the companion is exported,
published and pinned, and the forward version carries the pinned locators. Only then may C761
request publication authority.

The technique that carried every closure so far: state the finite content on the displayed
coordinate lists, reduce one table in the kernel, and transport to the subtype model afterwards.
Deciding directly over `InternalPoint` or `PassantLine` re-derives the subtype universe once per
element and exhausts the memory guard; deciding over a `Finset` powerset does the same.

Three further levers were established by the minimum-word closure and apply to the remaining
packets. Any operation that locates an object by scanning a coordinate list — `internalIndex`,
`incidentAt`, `rhoAt` — must be replaced by a packed natural-number table whose agreement with the
scan is kernel-checked once over the finite index domain; the scan itself is what exhausts the
guard, not the field arithmetic, which reduces cheaply. Any object recomputed inside a larger check
must first be identified with a displayed list, emitted by a tracked generator and checked by Lean,
so that downstream checks reduce on literals. What still exceeds the guard after both is split into
index blocks, one module each, and reassembled by list concatenation. The measured ceiling on the
`single` profile is roughly one million kernel operations on this data per module.

The association-transport packet added a fourth lever, reusable by every remaining matrix leaf: a
Boolean matrix presented by the list of its row bitmasks has a parity product costing one
natural-number operation per pair of a left row and a middle index, instead of one operation per
triple of indices. `PassantCodeQ13.AssociationTransport.PackedRows` proves that this word-parallel
evaluation computes `booleanParityProduct`, which linearizes to matrix multiplication over the
binary field.

The fixed-point exhaustion is the one leaf that no table substitution reaches — it meets partial
supports through a hash map keyed by incidence syndrome, over domains far larger than anything
reduced so far — and needs a proved checker in the style of the weight-ten reachability kernel. The
two ambient-plane axioms of the structural upgrade are the other leaves no table reaches, for the
opposite reason: they should stop searching altogether and be proved from the cross-product formula
for the join of two distinct normalized points.

## Current state

The incidence/dimension packet is partially closed.  The normalized 183-point coordinate model,
the 78 internal and 78 passant coordinate enumerations and their indexing equivalences, the
independent bit-row rank calculation, and the recovery/expansion masks transporting rank 42 to the
semantic incidence map now use kernel reduction.  The four-anchor signature injectivity leaf is
also kernel checked.  Focused guarded elaboration and the semantic rank-transport target are green.

The reusable weight-ten reachability kernel is also in place.  It checks generated transition
layers, proves coverage for every member of the complete Cartesian choice domain, supports compact
selected-row projections through a proved XOR homomorphism, and derives target exclusion from a
checked terminal list.  This infrastructure is kernel checked, but no native weight-ten leaf has
yet been removed.

Direct kernel reduction is not an admissible replacement for the larger finite leaves: even one
semantic unary-degree point and one raw isolated weight-ten shard exceed the measured memory gate.

The seven isolated-profile generated layer certificates are now complete on that checker.  Each
option bridge, transition, and sharded terminal disjointness check is kernel reduced in its own
module, and the seven profile aggregates exclude syndrome equality for every choice in the complete
Cartesian domain rather than only for generator-emitted paths.  Report:
`notes/2026-08-02-c834-isolated-weight-ten-reachability.md`.

The cycle profile is now closed too, by kernel reduction of the manuscript's geometric rejection
search rather than by a projected-state cover of the syndrome product, which is not viable: the
disjointness product is fixed at 1.67e8 regardless of the split, and projection does not shorten an
exact-traversal transition list.  Seven residue shards discharge all 595 secant pairs with no
generated data, no generator, and no group action.  Report:
`notes/2026-08-02-c834-cycle-profile-kernel-exclusion.md`.

The first half of the semantic bridge is landed.  `PassantCodeQ13.WeightTen.PencilTransport`
identifies the indexed base pencil, its fibres, and its secant neighbours with the corresponding
semantic objects, and `PassantCodeQ13.WeightTen.SyndromeBits` characterizes every incidence-syndrome
bit by induction on the row bound and proves that the certificates' two bitwise obstruction tests
are exactly absence of a common passant and existence of a passant through three points.  Neither
module runs a finite search.  What remains of the bridge is the list-versus-finset assembly turning
the profile theorem's fibre sizes and secant-neighbour count into the selection shape the
certificates consume, and the projective transport of an arbitrary support point to the fixed base
point.  Report: `notes/2026-08-02-c834-weight-ten-semantic-bridge.md`.

The semantic weight-ten module's own three finite leaves are now kernel checked.  The passant
pencil of an internal point, uniqueness of the passant joining two distinct internal points, and
the passant/secant dichotomy for their join are decided on the displayed coordinate lists through a
single pencil table and transported to the subtype model, so both weight-ten terminals in the
Paper IV gate axiom audit depend only on the foundational axioms.  Report:
`notes/2026-08-03-c834-weight-ten-pencil-kernel-closure.md`.

The weight-eight tangent-graph module and the reconstruction row cardinality are also kernel
checked.  The base point, the internality, distinctness, and
neighbour identification of the cyclic vertex triples, the base pencil and its join uniqueness, the
four-clique enumeration with unique extension, five-clique collapse and maximality, the
common-neighbour cardinality of each four-clique set, and the seven internal points on each passant
line are all decided by kernel reduction.  The ambient dual-line evaluation, secant coordinates,
and secant-line subtype moved into the geometry module so the pencil results are available
upstream.  The last two exceptions were closed on 2026-08-04:
`WeightEight.adjacent_iff_tangentCompatibleAtBase` now reduces one table over the ordered vertex
pairs through the precomputed pencils and bridges symbolically to the semantic relation, and
`WeightEight.fourCliqueSets_complete` is proved from a general sublist lemma rather than computed.
Reports: `notes/2026-08-03-c834-weight-eight-kernel-closure.md` and
`notes/2026-08-04-c834-shared-library-native-closure.md`.

The earlier cycle-profile report also settles the route for the rest of weight ten.  The already-formalized pencil-profile
dichotomy of `RelativeConicArcs.PassantCodeQ13.WeightTen.arbitrary_weightTen_word_has_pencil_profile`
closes the endpoint with the two existing certificates, so neither the global moment identity and
its `m=6`/`m=10` shape classification nor the thirty-seven stabilizer obstruction records need to be
formalized.  The next implementation packet is the semantic bridge carrying the fibre decomposition
and the secant-join relation between the coordinate-index model of the certificates and the
`InternalPoint` model of the profile theorem, followed by the projective transport of an arbitrary
support point to the fixed internal point, which is the sole remaining weight-ten gap.  No native
leaf may be removed until its replacement is connected to the complete domain.  Unary constancy will
use the manuscript's orbit-transitivity and double-count mechanism rather than semantic support
filtering.

## Standalone pre-release accommodations to reverse

A manuscript-only pre-release of `papers/q13-passant-code` was authorized on 2026-08-03 before the
formal closure finished, so the standalone export omits the Lean companion.  The deposit is
published from the mirror `~/src/math-papers/q13-passant-code` and its archival locator is
[`10.5281/zenodo.21783971`](https://doi.org/10.5281/zenodo.21783971), recorded as the README badge.
That deposit is immutable: the formal closure lands as a forward version, never as an edit to it.
The manuscript itself carries no locator yet, since printing this DOI inside the PDF it identifies
would need a later version anyway; insert it with the pinned formal-package locators in the same
release pass.  The README states that the Lean development is deposited separately and expected
the day after the deposit.  The manuscript, its README, and the evidence
verifier were all changed to make a manuscript-only checkout coherent, and the deposit's verifier
passes standalone while reporting the seven digests and one command it cannot check.  Every accommodation below
exists only because the companion is not yet publishable, and each must be reversed once the shared
library is exported, published, and pinned:

- `papers/repositories.toml` excludes `lean-certificates/**` from the `q13-passant-code` export and
  rewrites the `Makefile` to drop the `lean` target; both the exclusion and that rewrite go away
  when the companion ships.
- `papers/q13-passant-code/verification/verify_evidence.py` skips the manifest records naming the
  companion package or the shared library when the companion directory is absent, reporting the
  count of skipped checks.  The skip stays only while a manuscript-only checkout is a supported
  distribution; if the companion always ships, delete it.
- `papers/q13-passant-code/README.md` states that the Lean development is deposited separately and
  that this version's formal artifact still contains native-evaluation leaves.  Both sentences must
  be replaced when the closure lands.
- The manuscript's public-command paragraph and `verification/README.md` still name
  `lean-certificates/` as a repository-relative path; the release chain must replace those with the
  pinned public locator.
- The standalone mirror `~/src/math-papers/q13-passant-code` has a `git rm` commit removing the
  companion.  Restoring it downstream is an ordinary forward commit through the exporter, not a
  history repair.

## Objective

Replace Paper IV's partial formal mirror by a theorem-complete public Lean
development before release.  The terminal theorem must cover the complete
published result: parameters \([78,36,12]_2\), all 364 minimum words and their
four intrinsic families, spanning by every family, exact weighted-pair
reconstruction, the full marked \(\operatorname{PG}(2,13)\), and the
automorphism group.

## Meaning of “full Lean”

For release purposes, the formal package is complete when every manuscript
clause has an exact entry in the series-standard statement, trust, and formal
coverage ledgers, and every claim described as Lean-proved names an elaborated
declaration with its actual axioms.  Release-facing Lean terminals have no
declaration-local native-evaluation axiom or trusted Python premise.  Ordinary
foundational axioms reported by Mathlib—such as choice, propositional
extensionality, and quotient soundness—are permitted and must be listed.

Short structural human proofs and exact classical inputs remain legitimate
proof modes under the series trust standard.  They must be complete in the
manuscript or pinned to precise literature, and the aggregate must not advertise
their clauses as kernel checked.  Python programs may remain independent
cross-checks but carry no logical weight.

Proof-producing reflection, kernel reduction, generated proof terms, and
proved reusable finite certificates are permitted.  `native_decide` is not a
release proof endpoint.

## Required closure packets

1. **Incidence and dimension:** kernel-check the normalized conic, polarity,
   incidence matrix, rank 42, and code dimension 36.
2. **Distance:** internalize the weight-eight tangent/theta argument, including
   PSD and the equality/kernel calculation, and the weight-ten moment plus all
   stabilizer exclusions; derive minimum distance 12 without a trusted search.
3. **Minimum layer:** prove the complete 364-word exhaustion, identify one
   octahedral and three toric families intrinsically, compute stabilizers and
   prove every family spans.
4. **Pair recovery:** prove the exact pair table, the fused-color splitter,
   color-eight recovery of every polar row, parity-image equality with the
   code, unary constancy, and exact arity two.
5. **Symmetry and plane:** formalize the compact anchor and coordinate-algebra
   mechanisms; retain sharp three-transitivity, the Sylow/involution
   construction, and the classical adjoint/polarity dictionary as exact
   human/classical trust rows when formalizing their general group theory would
   create a disproportionate dependency tree.
6. **Hidden field:** construct the operator field, prove its identification
   with \(\mathbf F_8\), the equivalence \(K\simeq\mathbf F_8^{12}\), the three
   scalar actions, and the Gram/spanning consequences.
7. **Release aggregate:** expose one theorem matching the manuscript's main
   theorem, run a complete `#print axioms` audit, generate a theorem-to-source
   map, and make the public release gate reject native/trusted placeholders.

## Engineering constraints

- Reuse the shared semantic geometry; do not create a second coordinate model.
- Match the other numbered papers' release machinery: tracked statement
  identity, claim-by-claim trust manifest, formal theorem map, frozen axiom
  transcript, generated-artifact provenance, public release allowlist,
  aggregate import gate, and a single release verifier.  Paper IV may strengthen
  those standards, but it may not use a weaker or bespoke ledger.
- Shard expensive proof-producing computations and keep generated artifacts
  deterministic, reviewable, and hash-addressed.
- Each packet must have a cheap focused build before entering the aggregate.
- Keep statement identities synchronized with the manuscript; if a statement
  cannot be formalized as written, repair the proof or report the precise
  mathematical blocker rather than weakening it silently.

## Acceptance

- A clean public checkout builds the full aggregate under the pinned toolchain.
- The statement-identity, trust-manifest, formal-map, axiom-transcript,
  provenance, allowlist, and release-verifier surfaces use the same schema
  discipline and cross-checks as the rest of the series.
- The release correspondence covers every clause of the manuscript main
  theorem and distinguishes kernel, certificate, classical, and human proof
  modes exactly.
- Its axiom closure contains no native-evaluation or project-local axiom and no
  trusted-execution premise.
- Every former native or Python theorem boundary is replaced by a Lean proof,
  a proof-producing Lean certificate, or an explicitly nonformal independent
  replay.  Human and classical boundaries are retained only where the
  architecture report justifies them and the trust ledger states them exactly.
- Independent Python replay, source hygiene, warning-free PDF, isolated build,
  and immutable-artifact checks pass.
- Only after C834 is complete may C761 request publication authority.

## Stop boundary

C834 does not add new mathematical claims, pursue all-\(q\) generalizations,
or publish externally.  Its sole purpose is proof-complete formalization of the
frozen Paper IV theorem.
