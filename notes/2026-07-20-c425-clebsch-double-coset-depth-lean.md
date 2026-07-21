# C425 / F6 — Lean double-coset depth–Fourier–parent bridge

**Lane:** `clebsch`

**Status:** implementation complete; independent review required before closure

**Date:** 2026-07-21

**Implementation commit:** pinned by the immediate follow-up report commit after the atomic artifact
commit described below.

## Result

The finite q=11 depth bridge is landed in six modules and exits through
`RelativeConicArcs.Gates.ClebschDoubleCosetDepth`.  The formalized theorem surface establishes:

1. the 133 normalized projective points are partitioned by sixteen common relation labels, and the
   homogeneous lift of each relation is closed under nonzero scalar multiplication;
2. two displayed common-subgroup generators produce exactly six disjoint matching-row orbits with
   sizes `1,4,6 / 1,4,6`;
3. the positive and negative leaves derive all sixteen zero counts for one representative of each
   orbit from the matching table, conic parameters, projective points, relation labels, and secant
   equations—no depth vector is frozen in the data module;
4. the resulting profiles are
   `v1=(-6,0,12,-12)`, `v2=(-3,3,0,3)`, `v3=(3,-2,-2,0)` and their negatives;
5. the sheet involution transports every positive six-secants union, exchanges the four oriented
   relation pairs, and negates the depth profile;
6. over `ZMod 11`, the six-label linear map has image dimension two and kernel dimension four, while
   its six individual profile values are pairwise distinct;
7. all profiles satisfy `2a+2b+c=0` and `9a+8b+d=0`; the positive integer profiles satisfy
   `v1+4v2+6v3=0` before reduction;
8. the signed first-coordinate pushforward has moments `0,0,6` in degrees `1,2,3`;
9. the two singleton generator orbits recover the unordered pair of singleton matching rows, and a
   chosen singleton matching table recovers its exact row through the gateway's proved injectivity.

The all-degree parity theorem and primitive-module/projective-cover identification were not added.
The `PGL_2(11)`, `PSL_2(11)`, `A5`, and `A4` group orders and their identification with the generated
permutation data are reconstructed by the replay, not promoted to Lean group-isomorphism theorems.
Accordingly the formal claim is an exact concrete action-and-incidence theorem, not general modular
Hecke theory or a kernel-checked abstract group identification.

## Exact terminals and owned artifacts

The definitions-only input is
`RelativeConicArcs.ClebschDoubleCosetDepthData`.  It freezes 133 normalized projective representatives,
sixteen relation labels, the standard-coordinate projectivity, twelve conic parameters, two common
subgroup generators on points/endpoints/parents, the sheet involution, four oriented relation pairs,
and six representative row indices.  It contains no profile, zero-count, equivariance, rank, kernel,
plane, moment, or recovery assertion.

The gate audits these 27 terminals:

- `relationCells_partition`, `vectorInRelation_smul`, `generatedOrbit_card`,
  `generatedOrbits_cover`, `generatedOrbits_pairwise_disjoint`;
- `positiveSingleton_zeroCounts`, `positiveOrbitFour_zeroCounts`,
  `positiveOrbitSix_zeroCounts`, `negativeSingleton_zeroCounts`,
  `negativeOrbitFour_zeroCounts`, `negativeOrbitSix_zeroCounts`;
- `positive_depth_constant_on_generated_orbits`,
  `negative_depth_constant_on_generated_orbits`,
  `sheetInvolution_secant_equivariant_positive`, `depthProfile_sheetInvolution_positive`;
- `representativeProfile_values`, `profileLinearMap_range_finrank`,
  `profileLinearMap_ker_finrank`, `representativeProfile_injective`,
  `representativeProfiles_planeEquations`, `positiveProfiles_weightedBarycentre`,
  `cubicFirst_pushforward`;
- `positiveSingleton_profile_recovers_parent`, `negativeSingleton_profile_recovers_parent`,
  `singletonOrbits_recover_unordered_pair`,
  `chosenPositiveSingleton_recovers_decoratedParent`, and `oddFourier_relation_bridge`.

Owned files:

- `lean/RelativeConicArcs/ClebschDoubleCosetDepthData.lean`
- `lean/RelativeConicArcs/ClebschDoubleCosetDepthBase.lean`
- `lean/RelativeConicArcs/ClebschDoubleCosetDepthPositive.lean`
- `lean/RelativeConicArcs/ClebschDoubleCosetDepthNegative.lean`
- `lean/RelativeConicArcs/ClebschDoubleCosetDepth.lean`
- `lean/RelativeConicArcs/Gates/ClebschDoubleCosetDepth.lean`
- `notes/2026-07-20-c425-clebsch-double-coset-depth-lean.{md,py,json,sha256}`

The script/data/source byte counts are respectively `20,083`, `15,898`, `7,461`, `6,913`, `2,492`,
`3,012`, `10,454`, and `2,879`; the checksum manifest is `986` bytes.  The manifest is authoritative
for the final hashes and detects any post-report drift.

## Reproducibility and trusted boundary

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-20-c425-clebsch-double-coset-depth-lean.py --check
sha256sum -c notes/2026-07-20-c425-clebsch-double-coset-depth-lean.sha256
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschDoubleCosetDepth \
  RelativeConicArcs.Gates.ClebschDoubleCosetDepth \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.Gates.ClebschDoubleCosetDepth
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c425-clebsch-double-coset-depth-lean.py --write
```

The canonical generator independently reconstructs the two one-factorizations and derives their
endpoint relabeling `(0,1,3,11,9,10,8,2,5,4,6,7)` rather than assuming that C411 and the gateway use
the same labels.  It then rebuilds the 133 projective points, sixteen cells, generator actions,
six generated orbits, all 22 depth profiles, involution negation, representative recounts, rank,
weighted relation, and degrees `1/2/3` scalar moments.  These results are compared with the C411 and
gateway inputs before JSON or Lean data are emitted.

The trusted computational boundary is deterministic Python integer/prime-field arithmetic; the
frozen C378/C379/C406 inputs and their projective/matching conventions; and the generator's parsing
of the committed gateway matching table.  Lean checks the emitted finite data by kernel reduction.
The replay does not prove priority, identify generated permutation subgroups with abstract named
groups in Lean, or turn the integer odd-Fourier display into a general Fourier-transform theorem.

The final build queue
`/home/tavis/.cache/othello-lean-build/run-20260721-230014-9c27ca7e` built the aggregator and gate,
then passed the exact trace-only aggregate gate.  Peak RSS was `2,402,140` KiB for the aggregator and
`1,813,556` KiB for the gate.  The earlier sheet build used separate module boundaries as required;
its measured peaks were `4,405,300` KiB positive and `6,630,756` KiB negative.  The gate's 27 selected
terminal audits report only `propext`, `Classical.choice`, and `Quot.sound`; no `sorryAx`,
`native_decide`, project axiom, or opaque external oracle occurs in the claimed terminal surface.

## Exclusions

The gate does not prove a general double-coset or Mackey theorem, abstract isomorphisms
`G=PGL_2(11)`, `H=A5`, `K=A4`, all-degree parity, primitive integral dependence, the C412
`P(1)^A4/soc(P(1))` interpretation, a zonal spherical-function statement, or faithfulness of the
rank-two linear map.  The imported odd-Fourier theorem proves only the displayed integer square
identity and selected involution pairs; scheme-theoretic Fourier semantics remain at the gateway's
stated external boundary.  Decorated recovery recovers the committed matching-table row, not an
independently formalized geometric parent object.

## Judgment-call record

### Endpoint labeling

- **Question:** assume C411's endpoint order equals the gateway order, or derive a bridge?
- **Options:** reuse labels directly; freeze a hand-found permutation; reconstruct the unique
  factorization-pair isomorphism.
- **Choice:** reconstruct it by bounded backtracking over the two edge partitions, then conjugate
  every endpoint and parent action through the result.
- **Evidence/effect:** the direct identification falsified the first action theorem; the reconstructed
  permutation maps all 22 matchings and both sheets exactly.  It adds no trusted profile data.
- **Reopen if:** the gateway table or C379 convention changes; `--check` then fails loudly.

### Finite sharding

- **Question:** keep all representative/action checks in one base, or split by sheet?
- **Options:** monolithic base; tactic-level case splitting; separate positive/negative modules.
- **Choice:** definitions and orbit combinatorics in the base, with independent sheet modules for
  the heavy recounts and involution checks.
- **Evidence/effect:** the monolithic smoke test was killed at the guarded memory boundary; the
  module split built successfully and is the task brief's prescribed trust shape.
- **Reopen if:** a proved symbolic counting lemma replaces the finite reductions and materially
  lowers measured memory without weakening the terminal statements.

### Group-theoretic scope

- **Question:** construct named abstract group/subgroup isomorphisms in Lean, or formalize the exact
  concrete permutation-action seam and retain the names at replay level?
- **Options:** full `PGL/PSL/A5/A4` group structures and isomorphisms; concrete action generators with
  exact orbit/incidence theorems; generated certificate assertions.
- **Choice:** concrete action generators plus in-kernel orbit/incidence results; named group orders
  and identifications remain independently replayed.  Generated assertions were rejected.
- **Effect:** every paper-used profile/rank/moment/recovery fact is Lean checked, but the manuscript
  must not call the abstract named-group identification Lean-formalized.
- **Reopen if:** C320 requires the abstract identification as a paper-facing claim or review rejects
  the explicit mixed-verification boundary.

### Optional strengthenings

- **Question:** add all-degree parity, primitive dependence, or the projective-cover plane?
- **Choice:** omit them.  The mandatory finite bridge and cubic-first endpoint landed without those
  claims, and C412 already records the projective-cover boundary.
- **Effect:** no theorem, label, or trust claim is assigned to the omitted strengthenings.
- **Reopen if:** manuscript wording adopts one of those optional claims and allocates its proof.

## C320 ledger delta

| claim | exact Lean route | external boundary |
|---|---|---|
| Six `1,4,6 / 1,4,6` cells | `generatedOrbit_card`, cover, disjointness | abstract `A4<PGL_2(11)>A5` identification replayed |
| Six secant-depth profiles | six `*_zeroCounts`, two representative-profile terminals | frozen projective/cell/action data generated from C378/C379/C406 |
| Involution antipodality | `sheetInvolution_secant_equivariant_positive`, `depthProfile_sheetInvolution_positive` | golden involution's historical/geometric name |
| Rank two, kernel four, label separation | three aggregator terminals | mixed-bi-Hecke interpretation, not needed for linear algebra |
| Plane and `1:4:6` relation | plane-equation and weighted-barycentre terminals | primitive module interpretation omitted |
| Cubic-first scalar pushforward | `cubicFirst_pushforward` | no general tensor/Fourier theorem claimed |
| Singleton matching recovery | sheet recovery terminals, unordered-pair terminal, chosen decorated-parent terminal | matching row only; geometric parent identification external |
| Odd relation bridge | `oddFourier_relation_bridge` | scheme-theoretic Fourier semantics external |

Verify-all addition: `RelativeConicArcs.Gates.ClebschDoubleCosetDepth`.  C320 must retain the mixed
boundary above and must not promote the replayed group identifications or Fourier semantics to
full-trust Lean claims.

## Independent review

Not yet performed.  Under the campaign review rule, the implementing agent stops after committing
this artifact and asks the user to launch the independent reviewer.  The live queue row must remain
open until a user-launched reviewer records final `GO` and every finding is disposed.
