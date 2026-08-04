# Order-eleven interface split — source feasibility audit

**Date:** 2026-08-04
**Lane:** `build-sys`
**Purpose:** read-only audit of the proposed survivor sets in
`notes/2026-08-04-c864-q11-interface-split-lines.md` against the actual Lean sources. No file was
edited, no build was run. The question answered here is narrow: for each proposed survivor, does its
statement or its body mention a declaration that the cut would move out from under it?

Convention used throughout: a **statement dependency** is a name occurring in the declaration's type
(for a theorem) or in the defining body (for a definition — a definition's body *is* its content, so
there is no "pinnable proof" half). A **proof dependency** is a name occurring only in a theorem's
tactic block; those are safe to replace with a pinned external fact.

## Verdicts

| module | verdict |
|---|---|
| point-orbit entry (`Q11A5PointOrbits`) | not feasible as proposed |
| coding (`Q11Coding`) | feasible with one extra declaration |
| decoding synthesis (`Q11DecodingSynthesis`) | not feasible as proposed |
| Brianchon–Petersen (`Q11BrianchonPetersen`) | feasible with four extra declarations |
| residual (`Q11Residual`) | feasible with four extra declarations plus two instances |

## Blocking statement dependencies

Only statement/body dependencies on declarations the cut would move are listed. Everything else in
each survivor resolves to `Certificate`, `CodingBridge`, `Conic`, `ProjectiveBridge`,
`ProjectiveCap` or Mathlib, all of which stay.

| survivor | declared in | blocking names in statement/body | where those live |
|---|---|---|---|
| `point_orbit_partition` | `Q11A5PointOrbitsPartition` | `orbitPoints`, `orbitSize`, `PointIndex` | `Q11A5PointOrbitsData` |
| `unique_six_orbit` | `Q11A5PointOrbitsPartition` | `orbitPoints`, `witnessSet` | `Q11A5PointOrbitsData` |
| `unique_twelve_orbit` | `Q11A5PointOrbitsPartition` | `orbitPoints`, `standardConicIndices` | `Q11A5PointOrbitsData` |
| `brianchon_points_one_orbit` | `Q11A5PointOrbitsBrianchon` | `brianchonSet`, `orbitPoints` | `Q11A5PointOrbitsData` |
| `witness_mds_columns` | `Q11Coding` | `witnessVec` | `Q11SemanticBase` |
| `projective_distanceThreeDirections_eq_standardConic` | `Q11Coding` | *(none)* | — |
| `witness_code_coveringRadius_three` | `Q11Coding` | `witnessVec` | `Q11SemanticBase` |
| `totalSyndromeDistance_exact` | `Q11DecodingSynthesis` | `totalSyndromeDistance`, `witnessVec` | same module; `Q11SemanticBase` |
| `ambiguity_strata_sound` | `Q11DecodingSynthesis` | `ambiguityOneSyndromes`, `ambiguityTwoSyndromes`, `ambiguityThreeSyndromes`, `ambiguityTwentySyndromes`, `nearestLeaderCount` | same module |
| `ambiguity_strata_counts` | `Q11DecodingSynthesis` | the four `ambiguity*Syndromes` | same module |
| `brianchonDirectionIndices_eq_indexThree` | `Q11DecodingSynthesis` | `brianchonDirectionIndex`, `directionsOfIndex` | same module; `Q11SemanticSpectrum` |
| `brianchon_weightTwo_leaderSupports` | `Q11DecodingSynthesis` | `brianchonDirectionIndex`, `brianchonMatching`, `pairSupport`, `witnessVec`, `projectiveVec` | same module; `Q11BrianchonPetersen`; `Q11SemanticLeaders`; `Q11SemanticBase` |
| `chordEdge` | `Q11BrianchonPetersen` | `Edge` (hence `Vertex`) | same module |
| `rawChordLine` | `Q11BrianchonPetersen` | `Edge`, `Point`, `vertexVec` | same module |
| `cross` | `Q11BrianchonPetersen` | `Point` | same module |
| `dot` | `Q11BrianchonPetersen` | `Point` | same module |
| `conicRaw` | `Q11Residual` | `conicVec`, `conicVec_ne_zero` | same module |
| `conicPoint` | `Q11Residual` | *(none beyond `conicRaw`)* | — |
| `conicEmbedding` | `Q11Residual` | `conic_parameters_distinct` in its `inj'` field | same module |
| `conicPoint_mem_standardConic` | `Q11Residual` | *(none; proof only)* | — |
| `conicEmbedding_range` | `Q11Residual` | *(none; proof only)* | — |
| `Adj` | `Q11Residual` | `conicVec` | same module |
| `neighbors` | `Q11Residual` | `Adj` plus its anonymous `Decidable` instance | same module |

Proof-only dependencies, which are fine to discharge from a pinned package fact, are recorded per
module below.

## Point-orbit entry module

**Not feasible as proposed, for two independent reasons.**

First, a bookkeeping error: none of the four named survivors is declared in `Q11A5PointOrbits.lean`.
That file contains only the sixty-way row dispatchers (`matrices_nonsingular`,
`matrixVec_pointVec_ne_zero`, `supportPerm_permutation`, `supportPerm_injective`,
`support_family_closed`, `action_on_witness`, `orbitIndex_pointAction`, `orbitPoints_invariant`,
`order_five_fixed_union`, `triplePointSet_invariant`) and a block of `#print axioms` lines that
merely *mention* the four survivors. `point_orbit_partition`, `unique_six_orbit` and
`unique_twelve_orbit` are declared in `Q11A5PointOrbitsPartition.lean`;
`brianchon_points_one_orbit` is declared in `Q11A5PointOrbitsBrianchon.lean`. Under the proposal as
written the entry module keeps nothing of its own and is simply deleted, while the interface has to
be re-established in a new monorepo module carrying namespace `RelativeConicArcs.Examples.Q11A5PointOrbits`
(the rigidity gate audits the four names fully qualified in that namespace, so the namespace is
load-bearing).

Second, and more seriously, all four statements are quantified over generated enumerated data. See
the generated-data section below.

Proof dependencies (all pinnable in principle): `point_orbit_partition`, `unique_six_orbit` and
`unique_twelve_orbit` are pure `decide` over the tables; `brianchon_points_one_orbit` is
`by decide`.

## Coding module

**Feasible, with `witnessVec` added to the survivor set.**

`witnessVec` is `(q11Witness.get i).1` in `Q11SemanticBase.lean` — a one-line projection of the
witness list that already lives outside the order-eleven family, in `RelativeConicArcs/Examples.lean`.
It costs nothing to keep and it appears in the statement of two of the three survivors.

`projective_distanceThreeDirections_eq_standardConic` has a clean statement: `distanceThreeDirections`,
`pointSet`, `q11Witness` and `Conic.standardConic` all stay. Its proof reaches
`q11_check` (`RelativeConicArcs/ExampleChecks/Q11.lean`, fourteen lines), `conicEmbedding`,
`conicEmbedding_range` (both residual survivors) and `parametrizedHoleValid_iff` (a residual
non-survivor) — all proof-only, all pinnable.

`witness_mds_columns` proof-only reaches `witness_columns_span` (same module, moving) and
`witness_small_independent` (`Q11SemanticSynthesis`, moving). `witness_code_coveringRadius_three`
proof-only reaches `witness_small_independent`, `conicVec` and
`conicZero_syndromeDistanceAtLeast_three` (same module, moving). Both are safe to pin.

The proposal's remark that the surviving module should carry no raised limits holds: with the
exhaustive `decide` bodies gone, nothing left needs a heartbeat bump.

## Decoding synthesis module

**Not feasible as proposed.** This is the module the split note calls "the cleanest of the five"; it
is in fact the worst of the five, and the note's supporting claim is false.

Every one of the five survivors has a blocking statement dependency, and every one of those
dependencies is a definition in the same module that the proposal moves:

- `totalSyndromeDistance_exact` is *about* `totalSyndromeDistance`. Move the definition and the
  theorem has no subject.
- `ambiguity_strata_sound` and `ambiguity_strata_counts` are about the four `ambiguity*Syndromes`
  definitions and (for soundness) `nearestLeaderCount`.
- `brianchonDirectionIndices_eq_indexThree` and `brianchon_weightTwo_leaderSupports` are about
  `brianchonDirectionIndex`.

Chasing those definitions one level further pulls in more: `totalSyndromeDistance` needs
`canonicalSyndromeDistance` and `affineRayOfVec` from `Q11SemanticBase`; the ambiguity strata need
`affineSyndromesOfDistance` (`Q11SemanticBase`) and `affineDistanceTwoSyndromesOfLeaderCount`
(`Q11SemanticLeaders`); `brianchonDirectionIndex` needs `brianchonPointCode`, a ten-row generated
table in `Q11BrianchonPetersen`; and `brianchon_weightTwo_leaderSupports` additionally names
`brianchonMatching` (another ten-row generated table there) and `pairSupport`
(`Q11SemanticLeaders`).

The note also asserts that "no declaration of this module is named by any consumer outside the
family." That is wrong. `RelativeConicArcs/ReflectionArrangementDecoding.lean` — which sits outside
the order-eleven family — uses `totalSyndromeDistance`, `nearestLeaderCount`, all four
`ambiguity*Syndromes` definitions, `ambiguity_strata_counts`, `distanceOne_leader_count_one` and
`distanceThree_leader_count_twenty`. It even proves `h3OneLeaderSyndromes = ambiguityOneSyndromes`,
a statement-level identity with a definition the proposal moves. So the outside-consumer surface of
this module is roughly twice the audited surface, not empty.

Proof dependencies that *are* safely pinnable here: `affineRay_syndromeDistance_exact`
(`Q11SemanticSynthesis`), `affine_coset_distance_distribution` (`Q11SemanticDistribution`),
`distance_two_leader_distribution`, `syndromeLeaderSupports_two_eq_raw` and
`brianchon_rawLeaderSupports`. Those are the genuine exhaustive payload and moving them is the whole
point; the problem is entirely on the statement side.

## Brianchon–Petersen module

**Feasible, with four extra declarations — but the proposal's justification for two of the four
named survivors is wrong.**

Add to the survivor set: `Vertex`, `Edge`, `Point` (three `abbrev`s at the top of the module) and
`vertexVec`. `rawChordLine` is `cross (vertexVec e.1) (vertexVec e.2)`; `vertexVec` is a six-row
transparent copy of the witness columns, so keeping it is cheap. `chordEdge`, `cross` and `dot` are
otherwise self-contained.

The correction: the split note says the reflection-arrangement module "uses four declarations: the
chord-edge constructor, the raw chord line, and the two vector helpers for cross and dot products."
`RelativeConicArcs/ReflectionArrangements.lean` defines its **own** generic `cross` and `dot` over an
arbitrary `CommRing` and uses those; the only names it takes from Brianchon–Petersen are `chordEdge`
(in `h3Pair`) and `rawChordLine` (in one `SameDirection` statement). The `dot` occurrences in
`ClebschWeightedAdjointB3.lean` and `ArrangementWeightedAdjoint.lean` likewise resolve to
`ReflectionArrangements.dot`, since those files open `Examples.ReflectionArrangements`. Keeping
`cross` is still required — `rawChordLine`'s body calls it — but `dot` has no consumer at all, and
the note's recommendation to promote both helpers into a shared geometry module should be weighed
against the fact that a shared generic version already exists in `ReflectionArrangements`.

If the decoding-synthesis survivors are kept in the monorepo (see the adjustments below), this
module must additionally retain `AffinePointCode`, `Matching`, `edge`, `matching`,
`brianchonPointCode` and `brianchonMatching`, because those appear in the decoding statements.

## Residual module

**Feasible, with four extra declarations plus two anonymous instances.**

Add: `conicVec`, `conicVec_ne_zero`, `conic_parameters_distinct`, and the two anonymous
`instance : Decidable (Adj i j)` / `instance : Decidable (IndepValid Adj S)` declarations.
`conicRaw` is literally `⟨conicVec i, conicVec_ne_zero i⟩`, `Adj`'s body quantifies over `q11Witness`
and a determinant in `conicVec`, and `neighbors` is `Finset.univ.filter (Adj i)` which cannot
elaborate without the decidability instance. `conic_parameters_distinct` sits inside
`conicEmbedding`'s `inj'` proof field; it is a proof obligation rather than a subject, so it could
instead be supplied as a pinned package fact, but it is a single `decide` over twelve vectors and
keeping it is simpler than pinning it.

`conicVec` and `conicVec_ne_zero` are formulas, not tables, and `q11Witness` lives outside the
family, so nothing here forces generated data into the monorepo.

Proof-only, safely pinnable: `conicPoint_mem_standardConic`'s `decide` over the twelve conic
vectors, and `conicEmbedding_range`'s appeal to `Conic.standardConic_card`.

Note that the module's own consumer surface is exactly the proposed survivor set —
`ClebschGatewayQ11Conic.lean` uses `conicRaw`, `conicPoint`, `conicEmbedding`,
`conicEmbedding_range` and `conicPoint_mem_standardConic`, and `ClebschGatewayQ11Extension.lean`
uses `conicPoint` and `conicPoint_mem_standardConic`. `Adj` and `neighbors` are not used outside;
they are kept for the coding module's proofs and for the game half.

## Survivors whose statements mention generated data

This is the design problem, not a bookkeeping one. A statement quantified over an enumerated table
cannot become a pinned fact without the table itself being restated in the monorepo.

- **All four point-orbit survivors.** `orbitPoints` is a literal seven-entry array of explicit
  `Finset (Fin 133)` blocks listing all 133 canonical indices; `orbitSize` is a literal seven-entry
  array; `witnessSet` is `Finset.univ.image witnessIndex` over the literal six-entry table
  `![110, 100, 51, 93, 125, 18]`; `standardConicIndices` is a literal twelve-element `Finset`;
  `brianchonSet` is `Q11BrianchonPetersen.brianchonPointCodes.map codeEmbedding`, which drags a
  Brianchon generated table plus `codeIndex`/`codeEmbedding` along with it. All of these live in
  `Q11A5PointOrbitsData.lean`, the file the plan intends to move. Either that data module stays in
  the monorepo — in which case the "largest single elaboration saving" is only the row leaves, not
  the block tables — or the four interface statements have to be reformulated intrinsically (for
  example, in terms of orbits of the point action rather than of the displayed blocks), which is a
  redesign of the paper-facing surface and needs its own decision.
- **`brianchon_weightTwo_leaderSupports` and `brianchonDirectionIndices_eq_indexThree`.** Both name
  `brianchonDirectionIndex`, whose body is built from `brianchonPointCode`, a ten-row generated
  table; the former also names `brianchonMatching`, a ten-row generated table of explicit
  three-edge matchings. Keeping these statements means keeping both tables in the monorepo.

The coding, Brianchon–Petersen and residual survivors are otherwise clean: `witnessVec`,
`conicVec`, `vertexVec`, `chordEdge` and the `cross`/`dot` helpers are transparent formulas or
six-to-fifteen entry displayed tables that the paper prints anyway.

## Declarations reached through `open` rather than a qualified name

Every external consumer of these five modules reaches them through `open`, so no consumer reference
is visible to a grep for `Q11Coding.`, `Q11Residual.` or similar. The open sites are:

- `ClebschGatewayQ11Extension.lean`: `open Certificate Conic Examples Examples.Q11Coding Examples.Q11Residual Finset`
- `ClebschGatewayQ11Conic.lean`: `open Certificate Conic Examples.Q11Residual Finset`
- `ReflectionArrangements.lean`: `open RelativeConicArcs.Examples.Q11Coding` and
  `open RelativeConicArcs.Examples.Q11BrianchonPetersen`
- `ReflectionArrangementDecoding.lean`: `open RelativeConicArcs.Examples.Q11Coding`
- `ClebschWeightedAdjointB3.lean` and `ArrangementWeightedAdjoint.lean`:
  `open Examples.Q11Coding` (plus `Examples.ReflectionArrangements`)

Two consequences worth holding onto. First, `Q11DecodingSynthesis` declares into the
`RelativeConicArcs.Examples.Q11Coding` namespace, not a namespace of its own, so a consumer that
opens `Q11Coding` silently gets the decoding definitions too — that is exactly how
`ReflectionArrangementDecoding` reaches `totalSyndromeDistance` without naming the module. Second,
`ReflectionArrangements` opens `Q11BrianchonPetersen` and then shadows `cross` and `dot` with its
own generic definitions; a name-based scan reports those as Brianchon–Petersen uses when they are
not. Any future automated survivor computation must resolve names against the open context, not
against the text.

Names that are used unqualified by outside consumers and would move under the proposal, beyond the
survivor sets: `witnessVec`, `projectiveVec`, `projectiveVec_ne_zero`, `NonzeroScalar`, `AffineRay`,
`affineRayVec`, `affineRayVec_ne_zero`, `rawPointIndex`, `canonicalSyndromeDistance` (all
`Q11SemanticBase`), `affineRay_weightTwo_leader_count` (`Q11SemanticLeaders`), and the
decoding-synthesis definitions listed above. `Q11SemanticBase` is a transparent-definitions module
with no raised heartbeat limit and no enumerated table; it should be treated as part of the
monorepo interface layer rather than as payload.

## Concrete adjustments to the proposed survivor sets

1. **Point-orbit entry module.** Replace "four statements stay in `Q11A5PointOrbits`" with: create a
   monorepo interface module in namespace `RelativeConicArcs.Examples.Q11A5PointOrbits` holding the
   four statements, and decide separately whether `Q11A5PointOrbitsData` stays (cheap, keeps the
   statements verbatim) or the four statements are reformulated without the displayed blocks
   (expensive, changes the paper-facing surface). Do not start the move until that is settled.
2. **Coding module.** Add `witnessVec`. Keep `Q11SemanticBase` in the monorepo as the definitional
   base for the whole family interface.
3. **Decoding synthesis module.** Add `totalSyndromeDistance`, `nearestLeaderCount`,
   `ambiguityOneSyndromes`, `ambiguityTwoSyndromes`, `ambiguityThreeSyndromes`,
   `ambiguityTwentySyndromes`, `brianchonDirectionIndex`, and — because
   `ReflectionArrangementDecoding` names them — `distanceOne_leader_count_one` and
   `distanceThree_leader_count_twenty`. Also keep `directionsOfIndex` (`Q11SemanticSpectrum`) and
   `pairSupport` (`Q11SemanticLeaders`). What actually moves from this module is then only the
   exhaustive `decide`/`fin_cases` bodies plus `brianchon_rawLeaderSupports`,
   `distanceThree_leaderSupports_eq_allTriples`, `totalSyndromeDistance_nonzero_branches`,
   `totalSyndromeDistance_zero_iff` and the private uniqueness lemma. Correct the split note's
   claim that this module has no outside consumer.
4. **Brianchon–Petersen module.** Add `Vertex`, `Edge`, `Point` and `vertexVec`. If adjustment 3 is
   taken, also add `AffinePointCode`, `Matching`, `edge`, `matching`, `brianchonPointCode` and
   `brianchonMatching`. Drop the claim that `cross` and `dot` are consumer-named; `dot` has no
   consumer and `cross` is needed only as `rawChordLine`'s body.
5. **Residual module.** Add `conicVec`, `conicVec_ne_zero`, `conic_parameters_distinct` and the two
   anonymous `Decidable` instances for `Adj` and `IndepValid Adj`. Note generally that anonymous
   instances are invisible to a name-based survivor list and must be enumerated by hand for every
   module in the cut.
