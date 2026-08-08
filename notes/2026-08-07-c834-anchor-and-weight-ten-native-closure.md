# C834 — closing the automorphism-anchor and weight-ten-profile native decisions

**Lane:** `clebsch` · **Date:** 2026-08-07 · Stage 5 items 11 and 12 of the C834 execution plan.

## What is closed

Sixteen of the eighteen `native_decide` occurrences in the Paper IV package are gone. What remains
is the two in `PassantCodeQ13/MinimumWords/Exhaustion.lean`, which is stage 5 item 13, the
fixed-point exhaustion, and is gated on the arc property for an arbitrary weight-twelve codeword.

### Item 12 — the fourteen weight-ten profile shards

The seven `WeightTen/IsolatedProfile/Fibre*.lean` and seven `WeightTen/CycleProfile/Residue*.lean`
modules are deleted. Each asserted, by compiled evaluation, that an executable meet-in-the-middle
check returned `true` over the syndromes an enumeration happens to visit.

Kernel-checked replacements already existed in the package but were never wired into the gate:

- `PassantCodeQ13.WeightTen.IsolatedReachability.all_profiles_excluded` states, for each of the
  seven possible distinguished passant fibres, that no choice of one point from each of the three
  left-hand ordinary fibres has the same incidence syndrome as any choice of the base column, a
  three-point increment in the distinguished fibre, and one point from each remaining ordinary
  fibre. Its quantifier ranges over the complete Cartesian domain of choices, not over an
  enumerated image, so it is strictly stronger than the check it replaces.
- `PassantCodeQ13.WeightTen.CycleExclusion.obstructed_of_base_pair_and_fibres` states that every
  configuration of the base point, an unordered pair of its secant neighbours, and one point in
  each passant fibre through it carries three points on a common passant or contains a point of
  secant degree three. This is the manuscript's geometric rejection rather than a syndrome
  disjointness, so it replaces the cycle check rather than deriving it.

`WeightTen/Aggregate.lean` now imports those two aggregates and keeps only `local_partition`, which
reduces in the kernel. `Gates/Main.lean` exposes three terminals — `weightTenLocalPartition`,
`isolatedWeightTenProfilesExcluded`, `cycleWeightTenConfigurationsObstructed` — in place of the
single `weightTenCertificate` that asserted the executable checks.

The now-unused executable definitions in `WeightTen/Base.lean` (`productSyndromes`, `isolatedLeft`,
`isolatedRight`, `isolatedProfileCheck`, `cycleLeft`, `cyclePairs`, `cycleRight`,
`cycleProfileCheck`, `cycleFibreOptions`) and the insertion-sort apparatus of `Aggregate.lean` that
served only `cycle_pair_partition` were **not** removed. Editing `WeightTen/Base.lean` invalidates
the whole minimum-word subtree, which cannot currently be rebuilt (see the blocker below). Their
removal belongs to the first build window that rebuilds that subtree anyway.

### Item 11 — the two automorphism anchor decisions

`Automorphisms/FourthAnchor.lean`: `firstThreeSignature_eq_iff` now closes with
`decide +kernel +revert`. It is 78 coordinates times three polar invariants, well inside the guard.

`Automorphisms/TripleOrbit.lean`: `projectiveAnchorTriples_eq_patterned` — that the projective
images of the first three anchors are exactly the ordered triples of relation pattern `(10, 3, 9)`,
and that all 2184 images are distinct — is now proved from two kernel-reduced checks plus symbolic
transport. The finite content lives in two new modules.

`Automorphisms/RelationRows.lean` checks the displayed row masks of the elliptic relations of polar
invariants three, nine and ten against the normalized polar invariant, entry by entry over all 6084
ordered pairs of internal points, one `decide +kernel` per relation. The masks for polar invariant
three are new; `generate_association_transport_data.py` now emits them into `RelationData.lean`
alongside the four it already emitted. The comparison is stated directly on `rhoAt` rather than
through the `maskMatrix` presentation of `AssociationTransport`, which keeps the module's import
closure to the executable association algebra and the generated data.

`Automorphisms/AnchorOrbit.lean` records an ordered triple `(a, b, c)` of internal-point indices as
bit `b * 78 + c` of entry `a` of a list of 78 natural numbers, and compares two such tables:

- `anchorImageScan` accumulates one entry per normalized projective matrix in a single pass over
  the matrix list, and records in a Boolean flag whether every entry it set was previously clear.
  `anchorImages_are_distinct` is that flag.
- `patternedRows` holds, in entry `a`, the union over the points `b` in relation ten with `a` of
  the mask of points in relation three with `a` and relation nine with `b`, shifted into the block
  of `b`.
- `anchorImageScan_fst_eq_patternedRows` is the equality of the two tables.

Four structural lemmas about the scan carry these to the indexed model: a set bit of the
accumulated table names an item of the list, set bits survive later steps, a false freshness flag
propagates, and a true one makes the recorded pairs pairwise distinct. From them,
`exists_matrixAction_of_pattern` produces a matrix realizing any patterned triple, and
`anchorImageTriple_injective` gives the count. The reverse inclusion — that every anchor image is
patterned — needs no computation: it is invariance of the polar relation under the action together
with `anchorTriplePattern`.

## The measurement that made this work

A first attempt recorded the anchor images as bits of a single natural number of 474552 bits and
was killed by the memory guard within 36 seconds. Splitting the same information across 78 numbers
of 6084 bits removed the bignum cost but the module still died, at 70 seconds. The cause was
neither: it was `internalIndex`, which locates an acted point by scanning the 78-element coordinate
list, evaluated 6552 times. Substituting `tabulatedInternalIndex` of
`MinimumWords/NormalizedIndexTable.lean` — one shift and one mask on a packed table — brought the
whole module to 50 seconds of elaboration at a 5.7 GB peak. This is the third independent
confirmation of the plan's standing lever: the scan is what exhausts the guard, not the arithmetic.

## Acceptance evidence

`PassantCodeQ13.Automorphisms.RelationRows`, `PassantCodeQ13.Automorphisms.AnchorOrbit` and
`PassantCodeQ13.Automorphisms.TripleOrbit` are built through the guarded queue and elaborate with
no errors and no warnings. `PassantCodeQ13.WeightTen.IsolatedReachability.Aggregate` is built.
`PassantCodeQ13.WeightTen.Aggregate` and `PassantCodeQ13.Automorphisms.Transport` are elaborated as
single-file smoke tests against last-built dependencies, which is weaker than a gate build.

The axiom dependencies of the affected terminals, read from the pinned toolchain's `#print axioms`
output:

| terminal | axioms |
|---|---|
| `Automorphisms.relationRowsRhoThree_certificate` | `propext`, `Quot.sound` |
| `Automorphisms.relationRowsRhoNine_certificate` | `propext`, `Quot.sound` |
| `Automorphisms.relationRowsRhoTen_certificate` | `propext`, `Quot.sound` |
| `Automorphisms.rhoAt_self` | `propext`, `Quot.sound` |
| `Automorphisms.anchorImages_are_distinct` | `propext`, `Quot.sound` |
| `Automorphisms.anchorImageScan_fst_eq_patternedRows` | `propext`, `Quot.sound` |
| `Automorphisms.projectiveAnchorTriples_eq_patterned` | `propext`, `Classical.choice`, `Quot.sound` |
| `Automorphisms.firstThreeSignature_eq_iff` | `propext`, `Classical.choice`, `Quot.sound` |
| `Automorphisms.preservesRho_iff_projective` | `propext`, `Classical.choice`, `Quot.sound` |
| `WeightTen.local_partition` | `propext`, `Quot.sound` |
| `WeightTen.IsolatedReachability.all_profiles_excluded` | `propext`, `Quot.sound` |
| `WeightTen.CycleExclusion.obstructed_of_base_pair_and_fibres` | `propext`, `Classical.choice`, `Quot.sound` |

No declaration-local compiled-evaluation axiom appears at any of them. The evidence verifier
`papers/q13-passant-code/verification/verify_evidence.py` passes, including the regenerated
`RelationData.lean` and its generator's `--check` mode.

## Blocker: the package gates cannot be replayed

`PassantCodeQ13.Gates.Main` and `PassantCodeQ13.Gates.AxiomAudit` were **not** built. Four
pre-existing modules that this task did not touch —
`PassantCodeQ13.MinimumWords.{OrbitS4, OrbitDihedralA, OrbitDihedralB, OrbitDihedralC}` — have no
compiled artifact in the build tree and are killed by the memory guard on every attempt, at a peak
of about 6.6 GB against roughly 6 GB of host memory available. Five runs failed identically: the
default worker settings, the strictly serial profile with one thread, a single-core affinity mask,
and twice more at the gate. Lake continues to schedule those four jobs concurrently regardless of
the affinity mask or the profile, and the guarded runner exposes no cap on Lake's own job count.

So this is an environmental and tooling limit, not a defect in the work above: the whole gate
closure needs either more free host memory or a Lake job cap in the guarded runner. The job-count
knob belongs to the `build-sys` lane and should be raised there rather than worked around here.

Until the gates replay, the following remain unverified by a gate build, though each is elaborated
individually: the two restated `Gates/Main.lean` weight-ten terminals, the third one, and the
refreshed `Gates/AxiomAudit.lean` terminal list.

## What this leaves for stage 5

Item 13, the fixed-point exhaustion, is the only remaining native-evaluation leaf, and its route is
unchanged: prove first that an arbitrary weight-twelve codeword meets every passant in zero or two
points, using only minimum distance twelve.
