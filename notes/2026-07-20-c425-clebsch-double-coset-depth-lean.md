# C425 / F6 — Lean double-coset depth–Fourier–parent bridge

**Lane:** `clebsch`

**Status:** implementation complete; independent review required before closure

**Date:** 2026-07-22

**Implementation base commit:** `d60be94246db3220c8222354a7e417b9fe827b1d`

**Review-repair commit:** `3ecf6ae074fa7567c41f1a1a0e4d199eae4d9ab4`

**Final review-cleanup commit:** `76391460114d17c0cf2c7eccbe42767de27e427d`

## Result

The finite q=11 depth bridge is landed in six modules and exits through
`RelativeConicArcs.Gates.ClebschDoubleCosetDepth`.  The formalized theorem surface establishes:

1. the 133 frozen normalized coordinate representatives are partitioned by sixteen displayed
   relation labels, and the homogeneous lift of each relation is closed under nonzero scalar
   multiplication; exhaustive identification with `PG(2,11)` remains replay-level;
2. two displayed matching-row permutations produce exactly six disjoint generated orbits with
   sizes `1,4,6 / 1,4,6`; Lean proves both maps bijective, their orders divide two and three,
   closure of the computed sets, and equivalence between membership and reachability by arbitrary
   generator words;
3. the positive and negative leaves derive all sixteen zero counts for one representative of each
   orbit from the matching table, conic parameters, projective points, relation labels, and secant
   equations—no depth vector is frozen in the data module;
4. the resulting profiles are
   `v1=(-6,0,12,-12)`, `v2=(-3,3,0,3)`, `v3=(3,-2,-2,0)` and their negatives;
5. the displayed sheet involution transports every positive six-secants union, exchanges the four
   oriented relation pairs, and negates the depth profile; Lean also proves that its point
   permutation, and both generator point permutations, are induced projectively by their displayed
   matrices;
6. over `ZMod 11`, the six-label linear map has image dimension two and kernel dimension four, while
   its six individual profile values are pairwise distinct;
7. all profiles satisfy `2a+2b+c=0` and `9a+8b+d=0`; the positive integer profiles satisfy
   `v1+4v2+6v3=0` before reduction;
8. the signed first-coordinate pushforward has moments `0,0,6` in degrees `1,2,3`;
9. the two singleton generator orbits recover the unordered pair of singleton matching rows, and a
   chosen singleton matching table recovers its exact row through the gateway's proved injectivity.

The all-degree parity theorem and primitive-module/projective-cover identification were not added.
The `PGL_2(11)`, `PSL_2(11)`, `A5`, and `A4` group orders, their identification with the generated
permutation data, and the frozen certificate's C378/C379/C406 provenance are trusted external inputs
for the stable bundle; its current checker does not reconstruct them.  They are not promoted to Lean
group-isomorphism theorems.
Accordingly the formal claim is an exact concrete action-and-incidence theorem, not general modular
Hecke theory or a kernel-checked abstract group identification.

## Exact terminals and owned artifacts

The definitions-only input is
`RelativeConicArcs.ClebschDoubleCosetDepthData`.  It freezes 133 normalized coordinate representatives,
sixteen relation labels, the standard-coordinate projectivity, twelve conic parameters, two common
subgroup generators on points/endpoints/parents, the sheet involution, four oriented relation pairs,
and six representative row indices.  It contains no profile, zero-count, equivariance, rank, kernel,
plane, moment, or recovery assertion.

The gate audits these 34 terminals:

- `relationCells_partition`, `vectorInRelation_smul`,
  `subgroupGeneratorPoint_represents_matrix`, `sheetInvolutionPoint_represents_matrix`,
  `subgroupGeneratorParent_bijective`, `subgroupGeneratorParent_orders`,
  `generatedOrbit_seed`, `generatedOrbit_closed`, `mem_generatedOrbit_iff_reachable`,
  `generatedOrbit_card`, `generatedOrbits_cover`, `generatedOrbits_pairwise_disjoint`;
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
- `lean/verification/clebsch_double_coset_depth/{generate.py,schema.json,certificate.json,SHA256SUMS}`
- `notes/2026-07-20-c425-clebsch-double-coset-depth-lean.md`

The checksum manifest covers exactly the stable generator, schema, certificate, five C425 library
modules, and import-only gate.  It deliberately does not cover this report or the manifest itself.

## Reproducibility and trusted boundary

Run from `/home/tavis/src/othello`:

```bash
python3 lean/verification/clebsch_double_coset_depth/generate.py --check
sha256sum -c lean/verification/clebsch_double_coset_depth/SHA256SUMS
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschDoubleCosetDepth \
  RelativeConicArcs.Gates.ClebschDoubleCosetDepth \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.Gates.ClebschDoubleCosetDepth
```

Intentional regeneration is:

```bash
python3 lean/verification/clebsch_double_coset_depth/generate.py --write
```

The stable generator checks the closed certificate schema and the hash of its only direct external
input, the committed gateway matching table.  From the certificate arrays it then exhaustively
checks normalized-coordinate distinctness; matrix/point, endpoint/parent, and sheet compatibility;
generator permutation orders and full orbits; all 22 depth profiles; involution negation;
representative recounts; rank; the weighted relation; and degrees `1/2/3` scalar moments.  It
renders the Lean data module only after those checks pass.  Its closed top-level schema is
`lean/verification/clebsch_double_coset_depth/schema.json`.

The trusted computational boundary is deterministic Python integer/prime-field arithmetic; the
origin and projective/conic meaning of the frozen certificate; and the generator's parsing of the
committed gateway matching table.  The stable checker verifies the complete finite semantics used
by the Lean terminals, while Lean checks the emitted finite data by kernel reduction.  Neither
layer proves priority, identifies the generated permutation subgroup with an abstract named group,
or turns the integer odd-Fourier display into a general Fourier-transform theorem.

The final build queue
`/home/tavis/.cache/othello-lean-build/run-20260722-151332-a1f261a0` built the aggregator and gate,
then passed the exact trace-only aggregate gate.  Peak RSS was `6,787,232` KiB for the aggregator and
`1,784,672` KiB for the gate.  The gate's 34 selected
terminal audits report only `propext`, `Classical.choice`, and `Quot.sound`; no `sorryAx`,
`native_decide`, project axiom, or opaque external oracle occurs in the claimed terminal surface.

## Exclusions

The gate does not prove exhaustive coverage of projective points by the 133 frozen coordinate
indices, endpoint/conic-action compatibility, a general double-coset or Mackey theorem, abstract isomorphisms
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
| Six `1,4,6 / 1,4,6` cells | bijectivity/orders, `mem_generatedOrbit_iff_reachable`, cardinality, cover, disjointness | abstract `A4<PGL_2(11)>A5` identification replayed |
| Six secant-depth profiles | six `*_zeroCounts`, two representative-profile terminals | frozen certificate; C378/C379/C406 origin external |
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

The user-launched initial review on 2026-07-22 returned `NO-GO`.  Its eight findings are disposed in
the repair as follows: the malformed implementation pin is corrected; arbitrary-word reachability,
generator bijectivity/orders, and closure are now gated; point permutations are connected to their
matrices while endpoint/conic and abstract-group semantics are explicitly external; the generated
bundle has a stable mathematical path, schema, self-identifying header, and self-contained semantic
checker with a complete direct-input inventory; projective-space coverage is narrowed to the 133 frozen indices;
“primitive” was removed from the barycentre docstring; and manifest coverage is stated exactly.

The same user-launched reviewer returned a second `NO-GO` after confirming that every mathematical,
checker, hash, gate, and axiom-audit repair above was closed.  Its remaining referee-boundary cleanup
is now applied: all four source comments use only proved concrete orbit/label terminology; the report
states that named-group and C378/C379/C406 certificate provenance is external to the stable checker;
and the closed JSON schema requires every retained property after removal of three unused legacy fields.

A fresh user-launched independent review is required.  The live queue row remains open until that
review records final `GO` and confirms this last cleanup.
