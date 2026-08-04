# C834 — the association-transport leaves of the Paper IV package, rewritten for kernel reduction

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper IV)

**Validation status: the Lean sources in this round have not been elaborated.** The shared build
tree's build-owner lock is held by another lane's q16 certificate gate for the whole of this
session, so no elaboration, focused gate, or axiom audit could be run. Everything below describes
source that is written and mathematically confirmed by an independent exact computation, not source
that Lean has accepted. The first task of the next build window is to elaborate it.

## What changed

All eight native decisions of `papers/q13-passant-code/lean-certificates` under
`PassantCodeQ13/AssociationTransport/` are replaced by kernel reduction, and one of the nine native
decisions of `PassantCodeQ13/StructuralUpgrade.lean` — the hidden-field cubic — is replaced by a
derivation from those leaves. No source file under `PassantCodeQ13/AssociationTransport/` contains
`native_decide`. The paper package's remaining native decisions are the sixteen weight-ten profile
certificates, eleven in the minimum-word row-uniqueness transport, eight in the structural upgrade,
six in the automorphism anchors, three in the association algebra, and two in the fixed-point
exhaustion.

## Why the old leaves could not be kernel reduced

Each of the eight leaves compared a `booleanParityProduct` of two Boolean matrices on `Fin` index
types with a target matrix, entry by entry. That evaluation costs one operation per *triple* of
indices — 474,552 terms for a relation square, 553,644 for an orbit Gram matrix — and each term
re-evaluated its two entries from scratch: a relation entry re-derives the normalized polar
invariant, which scans the 78-element internal coordinate list twice, and an orbit entry scans a
91-element support list positionally. The product of the two costs is tens of millions of kernel
operations per leaf, far beyond the memory guard.

## The three levers, instantiated

**Tabulate.** `PassantCodeQ13.AssociationTransport.PackedRows` presents a Boolean matrix by the
list of its rows, each row the natural number whose set bits are the columns carrying `true`. In
that presentation one row of a parity product is the exclusive-or of the right-hand rows selected by
the set bits of the corresponding left-hand row, so a product costs one natural-number operation per
pair of a left row and a middle index — 6084 operations for a relation square instead of 474,552
term evaluations. The module proves `maskMatrix_maskProduct`, which identifies this evaluation with
the `booleanParityProduct` of the existing interface, and `maskMatrix_maskXor` for entrywise
addition; both compose with the pre-existing `booleanParityProduct_linearize` to give the ordinary
matrix identities over the binary field. Nothing in `PackedRows` runs a finite search.

**Display.** The row masks of the four elliptic relations of polar invariant 0, 9, 10 and 12, and
the column masks of the four minimum-word orbits, are emitted by the tracked generator
`generate_association_transport_data.py` into
`PassantCodeQ13/AssociationTransport/RelationData.lean`. They carry no trust: each relation's masks
are compared entrywise with the semantic `relationBooleanMatrix` over all 6084 ordered pairs of
internal points, and each orbit's column masks with the transpose of its displayed support matrix.
Those comparisons are the only places where the polar invariant is evaluated at all.

**Block.** Each relation's identification evaluates the polar invariant at every ordered pair of
internal points, so the four relations are separated into
`PassantCodeQ13/AssociationTransport/RelationMasks/{RhoZero,Nine,Ten,Twelve}.lean`, one module each,
and the four orbit-column identifications into
`PassantCodeQ13/AssociationTransport/OrbitMasks/{Symmetric,DihedralA,DihedralB,DihedralC}.lean`.
Once those hold, every remaining finite check in the packet is a list identity on masks costing
under ten thousand kernel steps, so the eight leaves themselves need no further splitting.

## The hidden-field cubic

`PassantCodeQ13.StructuralUpgrade.hiddenField_cubic_on_image` previously evaluated
`B⁴ + B³ + B = 0` for `B = A9` natively over `Matrix (Fin 78) (Fin 78) (ZMod 2)`, which the kernel
cannot reduce at all. `PassantCodeQ13.AssociationTransport.RelationCubic` now derives it: the only
new finite input is the mixed product `A10 A9 = A12 + A9`, one mask identity of 6084 steps, after
which `B² = A10`, `B³ = A10 A9` and `B⁴ = A10² = A12` come from the squaring identities and the
result closes by the vanishing of `M + M` over the binary field. The statement consumed by the gate
and the axiom audit is unchanged.

## Independent confirmation of the mathematics

`generate_association_transport_data.py` recomputes the relation matrices from the normalized polar
invariant and the orbits from the projective action in exact integer arithmetic, and refuses to emit
anything unless all nine identities the Lean leaves state hold of the emitted masks: the three
squaring identities, the rho-zero square `A0² = I + A9 + A10 + A12`, the mixed product
`A10 A9 = A12 + A9`, and, for each of the four orbits, the Gram identity and the annihilation by
`A0`. It emitted successfully, so the residual risk in this round is Lean-mechanical rather than
mathematical.

Replay, from `papers/q13-passant-code/lean-certificates`:

```sh
python3 generate_association_transport_data.py --check
python3 check_association_transport_statements.py
```

The first fails if the tracked module differs from the generated text. The second reads the
committed literals of both generated modules and checks every statement of the packet as Lean will
read it, including the transpose direction and the factor order of each product; it exits nonzero on
any mismatch. Neither carries logical weight: both are independent cross-checks of Lean sources
whose own proofs are what establish the results.

| artifact | sha256 |
|---|---|
| `generate_association_transport_data.py`                       | `20c7f89170993c8a599165dfbee21642e4c0962a0349c7e44bc8f49297cfc5f9` |
| `PassantCodeQ13/AssociationTransport/RelationData.lean`        | `38c2dd3857645aa1e636dc9440aaf2414810c92eeda8ead96f474c5ba2cb83c5` |
| `check_association_transport_statements.py`                    | `0ca0a3c6905c0e92423bff74606b6a328a1b077bc968508d440b1d63a820c05f` |

## Statements

The theorem names and statements consumed by the package gate and its axiom audit are unchanged:
`rhoZero_square_parity_certificate` and its three siblings, `relation_matrix_identities`,
`orbitS4_Gram_and_kernel` and its three siblings, `every_minimum_orbit_spans_rhoZero_kernel`, and
`hiddenField_cubic_on_image`. The four `*_entry_certificate` names that the axiom audit prints are
kept, and now state the mask identities rather than the entrywise Boolean checks; the audit gains
the four relation identifications, the identity-mask identification, the four orbit-column
identifications, and the mixed product. `orbitS4_boolean_certificate` and its three siblings are
gone: the transport now goes through the mask bridges instead of an intermediate Boolean matrix
equality.

## What the next build window must do

1. Elaborate `PackedRows` first; it is the only module with substantial symbolic proof and everything
   else depends on it.
2. Elaborate the four relation-mask and four orbit-column modules and record their measured peaks.
   The orbit-column comparison visits 7098 index pairs with two positional list reads each, which is
   the largest single check in the packet and the one most likely to need a further split into
   index blocks.
3. Elaborate the eight leaves, `RelationCubic`, `StructuralUpgrade`, and the package gate, then
   regenerate the axiom audit and confirm that every terminal reports only `propext`,
   `Classical.choice` and `Quot.sound`.
4. Refresh `papers/q13-passant-code/verification/evidence_manifest.json`: the hashes of
   `StructuralUpgrade.lean` and `Gates/AxiomAudit.lean` are now stale, and the new generator, its
   generated data module, and its `--check` command have no manifest records. The manifest also
   still lacks records for `generate_minimum_word_orbits.py` and `OrbitData.lean`, which predates
   this round.
5. Refresh the referee-facing module inventory in
   `papers/q13-passant-code/verification/README.md`. Its "Lean release layout" lists the paper
   package's finite leaves, and it is missing every module added by this round and by the
   minimum-word round before it — the packed-row bridge, the generated mask data, the four relation
   and four orbit identifications, the cubic, the normalized index and indexed incidence tables, the
   orbit data, and the concurrence and row-uniqueness blocks. Rebuild the list from the package
   rather than appending to it, and do so after elaboration, since a check that has to be split
   adds modules.

## Findings from a self-review after the commit

`check_association_transport_statements.py`, an emulator of the Lean definitions run against the
committed literals, confirms all of the statements as Lean will read them: the four relation identifications, the four orbit-column
identifications with the transpose in the stated direction, and, for each orbit, that the mask
identity `maskProduct columns supports` is the parity product of the transposed support matrix with
the support matrix and that `maskProduct relationRowsRhoZero columns` is the product of `A0` with the
transposed support matrix — that is, the factor order and index arities are the intended ones. It
also confirms the squaring identities, the identity masks, the mixed product, and each step of the
cubic derivation, including that the fourth power reached as `B²·B²` agrees with the one reached as
`B³·B`.

Two defects surfaced. The axiom audit did not print the packed-row bridges, although every leaf now
depends on them for its transport, exactly as it depends on `booleanParityProduct_linearize`, which
it does print; `maskMatrix_maskProduct` and `maskMatrix_maskXor` are now printed too. And the
release-layout inventory above was stale before this round as well as after it.

## Independent review, and the repairs it forced

A full independent referee pass is recorded in `notes/2026-08-04-c834-independent-review.md`. It
recomputed all four relation matrices, all four orbit column masks, and all nine identities from the
Lean definitions without using the tracked generator, and they reproduce exactly; it found no
soundness hole in the packed-row bridges, and in particular confirmed that the absent length
hypothesis on the left factor of a product is genuinely unnecessary while the present one on the
right factor is exactly the unsound case.

Its blocking finding was that the first commit of this round left the paper's own evidence verifier
failing: `verify_evidence.py` asserts on file size before digest, and the manifest still pinned the
pre-round sizes of `StructuralUpgrade.lean` and `Gates/AxiomAudit.lean`. That is repaired, together
with the manifest gaps: the manifest now carries records for both generators, both generated data
modules, and the statement checker, and runs all three replay commands. The verifier passes.

Five prose defects in this round's own sources are also repaired. The aggregator header claimed that
no module in its import closure uses native evaluation, which is false — `AssociationTransport/Base`
imports the association algebra, which still has three native leaves — so the claim is narrowed to
what is true. The packed-row header described its hypotheses as symmetric when only the right-hand
factor carries one, and now explains the asymmetry. The cubic module claimed an irreducible cubic on
an image when the elaborated statement is a quartic identity on the whole ambient space, and now says
so. The structural-upgrade header did not distinguish its native checks from the one kernel-reduced
result it inherits, and now names them. The three dihedral orbits were identified only by a letter,
and each is now identified by the polar invariant of its Gram matrix — nine, twelve and ten
respectively — which distinguishes them.

The review also names an adjacent win this round missed: `PassantCodeQ13.AssociationAlgebra` proves
the same three squaring and rank identities by native evaluation in a mask presentation that this
round has already reduced, so those three native decisions need a list identification, one symbolic
bridge from its `matrixProduct` to `maskProduct`, and nothing else. They should be taken in the same
build window rather than scheduled as a separate packet.

One estimate in this report was pessimistic. The orbit-column comparison is not the check most
likely to exceed the guard: `PassantCodeQ13.IndexedIncidenceTable` already discharges 6084
evaluations of indexed incidence by kernel reduction, and each of those performs two positional list
scans and field arithmetic, which is heavier per entry than an orbit-column comparison. The heaviest
new checks are instead the four relation identifications, each of which evaluates the normalized
polar invariant — including an inverse in the prime field — once per ordered pair of internal
points. Elaborate those first — and the review's independent estimate puts them over the guard, at
1.6 million kernel steps under favourable caching and 5 to 15 million under unfavourable, against a
measured ceiling near one million. Its recommended repair is to remove the modular inversion from
the checked predicate before splitting anything: `rho u v = value` is equivalent to
`polarValue u v ^ 2 = value * pointDiscriminant u * pointDiscriminant v` whenever both discriminants
are nonzero, which holds for every internal coordinate by construction, so a short symbolic lemma
turns 6084 inversions into 6084 multiplications. Packing the internal coordinate list into a
displayed table is the second lever, and a four-way row split of each relation module is the
fallback.

## The shared layer the round-by-round strategy has been skipping

The referee pass did the group computation rather than estimating it, and verified that the
symmetric-square action of the normalized projective group is transitive on the 78 internal points,
with point stabilizer of order 28 matching the package's own computed stabilizer, and transitive on
each of the six relation classes of ordered pairs. The package exploits none of that. Three
consequences:

An equivariance lemma — that the normalized polar invariant is unchanged by the action, because the
polar form and the discriminants acquire the same determinant factor and the invariant is
bi-homogeneous of degree zero — is a polynomial identity in ten variables with no enumeration at
all, and it deletes `Automorphisms.matrixAction_preservesRho`, currently a native evaluation over
2184 group elements checking 6084 pairs each, roughly thirteen million evaluations. That is the
single highest-value item left.

On top of it, a displayed point transporter reduces every per-point statement to one representative
point, and a displayed pair transporter reduces the pair statements of the structural upgrade from
6084 cases to six, one per relation class. The pair transporter costs about 160 kernel steps per
pair to check, so it does not pay for itself against any single consumer; it pays because it is
built once and serves both pair statements and the double count behind unary constancy.

Where the structural route does not win, and tabulation remains right: the row-uniqueness transport,
whose triple-indexed transporter would cost as much as the enumeration it replaces and whose index
ordering guard is not equivariant to begin with; the automorphism anchor signatures, whose fixed
anchor triple makes them non-equivariant; the weight-ten profiles, where base-point normalization is
already the structural reduction; and the hard half of the fixed-point exhaustion.

The referee's judgement on the strategy is that the closed packets are genuine classifications whose
content is the enumeration, and no reorganization would have avoided them, but that this shared
equivariance-and-transporter layer is infrastructure each round has been individually rational to
skip and is collectively overdue. It is not rework; three remaining packets consume it.

## A second cliff candidate to probe early

`WeightTen/Aggregate.lean` kernel-reduces a `List.mergeSort` of 595 encoded pairs against a
`sublistsLen 2` expansion. Core's merge sort is well-founded, and whether it reduces at acceptable
cost is unknown. It is one small module, so probing it costs almost nothing and de-risks the whole
weight-ten packet; do it early in the build window. If it does not reduce, the repair is to replace
the sort by a sorted-insertion certificate or to state the partition as a multiset identity that
needs no sort.

`MinimumWords/Exhaustion.lean` also uses `eraseDups` and `toFinset`, which are quadratic in
decidable equality and will need attention independently of its search. Its second leaf,
`fixedPoint_slices_are_stabilizer_orbits`, is much cheaper than the task card implies — 28 stabilizer
matrices against 4 supports and 78 points, about 8700 action evaluations — and reduces to a packed
action-index table.

## Release surfaces with no work item

The task card requires seven release surfaces. The plan as it stands addresses the axiom transcript
and, partially, generated-artifact provenance. There is no work item for the theorem-to-source formal
map, the claim-by-claim trust manifest, the public release allowlist, or making the release gate
actively reject a native or trusted placeholder. Nor is any of the five standalone pre-release
accommodations scheduled. The clean-checkout build has never been exercised with the companion
present, because the companion is currently excluded from the export.

## The remaining structural-upgrade decisions

Eight native decisions remain in `PassantCodeQ13/StructuralUpgrade.lean`. They fall into three
groups, and only the first is a straightforward instance of the recipe used here.

*Reachable by tabulation and blocking.* `unaryDegree_fiftySix` counts, for each internal point, the
displayed minimum-word supports containing it; on the displayed 364 masks that is 28,392 bit reads.
`toricSupport_cards`, `toricSupport_even_passants` and `determinantConic_card` are all small once
their `Finset` filters over the subtype universes are transported to filters over the displayed
coordinate lists, the last two through the packed incidence table the package already carries.

*Reachable, but only after a pair-concurrence table.* `pairColorEight_recovers_polarRows` and
`fusedColorSix_splits` recompute pair concurrence inside a larger check; the second ranges over
ordered triples of internal points, so it needs the concurrence values packed into a table and then
a split over blocks of first points, exactly as the minimum-word concurrence layer was split.

*Not a table substitution.* `uniqueLine_through_two_points` and `uniquePoint_on_two_lines` quantify
over 183 × 183 pairs with 183 candidates each. The right route is to stop searching: the join of two
distinct normalized points is their cross product. The referee pass checked this route in detail and
it is harder than the sentence above suggests. Existence is cheap — non-proportionality of distinct
normalized representatives is a three-shape case split, renormalizing the cross product reuses an
existing lemma, and the two incidence identities are polynomial identities that close by `ring`.
Uniqueness is the real obligation, and it is not the rank of a coefficient matrix: what is needed is
that `l · p = l · q = 0` with `p × q ≠ 0` forces `l` proportional to `p × q`, which follows from
`(p × q) × l = (p · l) q − (q · l) p = 0` together with a collinearity lemma for a vanishing cross
product that Mathlib's cross-product file does not appear to supply. Estimate sixty to a hundred and
twenty lines, most of it reusable. The tabulation fallback is a full-plane incidence table plus
roughly twelve blocked modules. Take the symbolic route, keep the fallback, and do not call it a
proof with no finite domain until the collinearity lemma is written.

Note also that the projective normalization trick does not apply here: the package's group acts
through the symmetric square and preserves the conic, so it is not transitive on ordered pairs of
arbitrary plane points.

*Cheaper than expected.* `fusedColorSix_splits` does not need a block split at all if the pair
concurrence is packed as one 78-bit mask per ordered pair rather than as a scalar table: the two
inner filters become mask operations and the whole leaf costs on the order of fifty thousand kernel
steps in a single module. A scalar table instead needs about six blocks.

## Vibe check

Good. The word-parallel product is the right primitive and it collapses the whole packet: after it,
seven of the nine identities cost a few thousand kernel steps each and the only genuinely expensive
checks are the four places where the polar invariant is evaluated once per pair of points. The
mathematics is independently confirmed, so what is at risk is a session of Lean debugging, not the
result. The dissatisfying part is that none of it is elaborated, and the structural-upgrade plane
axioms are a real proof obligation rather than a performance problem.
