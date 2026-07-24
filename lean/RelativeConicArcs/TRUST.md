# Trust manifest — arcs complete outside a conic

This directory is the standalone Lean formalization of
`papers/arcs_complete_outside_conic/`.  It is one-way coupled to the existing `ProjectiveCap`
library: it may import general projective infrastructure, but no existing project imports this
spinoff.

## Machine-checked theorem map

| Layer | Main declarations | Status |
|---|---|---|
| incidence and relative completeness | `Arc`, `CompleteOutside`, `rho`, `ProjectiveBridge.arc_iff_projectiveCap` | defined/proved in Lean |
| cap-game localization | persistent containment/move theorems; `legalExtensions_sdiff_holes_eq_uncovered`; `win_parametrizedHoles_iff`, `isP_parametrizedHoles_iff` | proved in Lean; domain legality is separated from the exact parametrized game-value bridge |
| moments and defect | `pointIndex_le_half_card`, `first_secant_moment`, `second_secant_moment`, defect/coverage/stability theorems in `Defect.lean` | proved in Lean |
| arbitrary holes and conic bounds | `completeOutside_bound_general`, `NonsingularConic.finite_lower_bound`, `L1_le_L2`, `L2_le_rho` | proved in Lean; the general bound depends only on hole cardinality and incidence |
| complete affine arcs | `CompleteAffine`, `completeAffine_iff_completeOutside`, `holeIncidence_pointsOnLine`, `completeAffine_bound`, `completeAffine_bound_eq_iff` | proved in `Affine.lean`; deleting a line is definitionally the line-hole case, every secant contributes one ideal incidence, and the corrected bound and equality pattern are the exact specialization of the general defect |
| asymptotics | `parityFreeNecessary`, `rhoC_explicit_additive_lower_bound`, `eventually_lt_centered`, and the Big-O/liminf wrappers in `Asymptotic.lean` | proved in Lean; the paper's isolated polynomial estimate is the `hExpansion`/`hB2`/`hB1`/`hB0`/`hR` block of `explicit_additive_lower_bound`, with the same error `8 / sqrt(2q)`. `eventually_lt_centered` is unconditional along unbounded orders; the literal real-valued liminf wrapper adds coboundedness because `ℝ` cannot encode `+∞` |
| averaging | `exists_completeOutside_of_completeArc`, `rhoC_le_t2`, `rhoC_le_of_kimVuBound` | proved in Lean for arbitrary holes under `|A||H| < |PG(2,K)|`; Kim--Vu remains an explicit theorem parameter |
| characteristic two | hyperoval/nucleus/tangent classification, `complete_holeIncidence_pos`, and nucleus-in/out inequalities in `Nucleus.lean` | proved in Lean under `(2 : K) = 0` |
| certificate bridge | relative and ordinary canonical-coverage soundness; `rawArc_iff_projectiveCap`; `check_sound`, `check_sound_empty` | proved in Lean for every finite field |
| evaluation obstruction | `evaluationMap`; injective-evaluation and selected-functional span obstructions in `EvaluationObstruction.lean` | proved over every commutative semiring; no finite-dimensionality assumption |
| finite-field evaluation dichotomy | common-zero and distinct-hyperplane counts; `exists_ne_zero_forall_apply_ne_zero`; sharp `q+1` plane cover and equality model; `evaluation_avoidance_iff`; `evaluation_ker_le_ker_iff_mem_span`; `feature_evaluation_avoidance_iff` | proved in `EvaluationDichotomy.lean`; the uniform threshold is `|A|≤q`, the rank-sensitive count is `(q-1)q^(r-2)(q+1-m)`, and the feature theorem specializes to every Veronese degree |
| projective syndrome geometry | distance-one/two/three trichotomy; exact weight-two support count; `completeOutside_iff_distanceThreeDirections_subset`; one-column and simultaneous extension theorems; maximal extension/graph-independence bridge; leader moment and defect restatements | proved in `SyndromeGeometry.lean`; the general simultaneous object includes pair and triple conflicts, while an arc-confined extension locus reduces exactly to the pair graph |
| transparent coding bridge | `parityCheckCode`; `[n,n-3,4]` MDS parameter package; affine syndrome distance; actual-leader/support cardinality bijection through weight three; exact `choose(n,3)` weight-three leader count; covering-radius-three predicate; indexed projective arc/triple-independence equivalence | proved in `CodingBridge.lean` without an external coding API; codewords, supports, distance, and leaders are explicit finite functions; `card_syndromeLeadersOfWeight_eq_supports` makes the incidence count literally an affine coefficient-word count |
| finite examples | `Examples.rhoC_ZMod5`, `rho_points_ZMod5`, `rhoC_GF8`, `rhoC_GF9`, `rhoC_ZMod11`, `rhoC_GF16` | kernel-checked; all five values exact; the q=5 leaf is the projective four-frame transported to the standard conic, then `NonsingularConic.rho_points_eq_rhoC` transports the value to every nonsingular model |
| q=16 projective classification | `StepBook.coverage`; `StepBooksValid`; `classifiedAt_level8_of_frame`; `arbitrary_eight_arc_classification_chain`; `arbitrary_eight_arc_projectiveQuadraticAvoidance`; `rejection_profile`; `exceptional_leaf_records`; `exceptionalKernelOne/Two/Three`; `no_completeOutside_GF16_card_eight` | every legal move is represented by a certified transition into the next list, and the books cover the current parent list exactly, so the lists of lengths 4/61/454/2633 form a kernel-checked exhaustive cover. Lean checks the exact 2630+3 split, identifies the three exceptional records and their one-dimensional kernels, and proves the full singular-or-nonsingular quadratic-avoidance theorem for every abstract eight-arc, including projective transport of ordinary uncoveredness and zero sets |
| q=9 terminal game | `Q9Terminal.complete`, `legalExtensions_eq_empty`, `isP` | certified witness is an ordinary complete arc and actual terminal projective P-position |
| q=11 residual game | residual graph theorems, `continuation_rawArc_iff`, `seed_isP` | every seeded continuation is exactly an icosahedral independent set; the actual projective seed is P by localization and antipodal mirror |
| q=11 code and extension spectrum | `witness_mds_columns`, `witness_code_minimum_distance_four`, `projective_distanceThreeDirections_eq_standardConic`, `affine_distanceThree_iff_mem_standardConic`, `witness_code_coveringRadius_three`, `mem_affineSyndromesOfDistance_iff`, `affine_coset_distance_distribution`, `syndromeLeaderSupports_two_eq_raw`, `distance_two_leader_distribution`, `no_nonzero_quadratic_vanishing`, `witness_not_hasGRSQuadratic`, `witness_not_projectivelyGRS_of_implies_quadratic`, `extension_independence_spectrum`, `maximal_extension_spectrum`, `maximal_independent_extension_complete`, `completed_witness_matchings_oneFactorization` | Lean proves the `[6,3,4]₁₁` code/radius/deep-hole claims and closes the implication from the classical NRC/GRS quadratic consequence to non-GRS. The NRC/GRS dictionary itself remains the cited classical input. The affine distribution and `(900,150,100)` split range over actual syndromes and actual finite coefficient words, with a proved ray bijection and support equality. Every counted maximal extension is ordinarily complete, and the six distinct antipodal additions give a checked one-factorization. |
| quadratic global count, invisible-center bound, inverse collision balance, and q=25 pair extension | `QuadraticGlobalCount.card_globalLegalPairs_eq_legalCount`, `QuadraticInvisible.s_add_three_sub_f_sub_e_le_card_empty_through_crossPair_center`, `QuadraticInvisible.aggregate_firstOrder_equality_iff_centers_avoid_carriers_and_collisionFree`, `QuadraticInvisible.aggregate_firstOrder_excess_eq_iff_centerIncidence_add_redundancy_eq`, `Q25PairResult.f2_pair_extension`, `Q25ProfileFour.profile_four_pair_extension`, `Q25ProfileZero.profile_zero_pair_extension`, `Q25AllProfiles.pair_extension` | the semantic global finset of fresh legal Frobenius pairs is exactly the disjoint carrierwise union counted by `legalCount`; equality in the aggregate first-order count is exactly universal center/carrier avoidance plus injective local charging, and excess `k` is exactly center-incidence mass plus collision redundancy; every cross-pair orbit in an `(f,e)` profile is invisible on at least the natural-number value `s+3-f-e` empty carriers; every Frobenius-invariant eight-arc over q=25 has a fresh conjugate-pair extension, with both new points explicitly outside the old arc; `f=2` uses checked normalization and all 46,056 finite rows, while `f=0,4` are certificate-free moment/center-incidence proofs and `f=6,8` use the strict count |

The five exact arithmetic thresholds are also explicit theorems:
`L2_five = 4`, `L2_eight = 6`, `L2_nine = 6`, `L2_eleven = 6`, and
`L2_sixteen = 8`.

## Certificate contract

`Certificate.check` is a rules-only Boolean checker.  It checks:

1. every listed vector is off `XZ = Y²`;
2. every projectively distinct listed triple has nonzero determinant; and
3. every canonical projective representative `[1:y:z]`, `[0:1:z]`, or `[0:0:1]` is on the
   conic, represents a listed point, or lies on a secant of two projectively distinct listed
   points.

`check_sound` proves that acceptance implies `CompleteOutside` for the corresponding projective
point set.  The normalization proof is generic and shows that these `q²+q+1` representatives
cover every projective point.  The accepted list need not be normalized, duplicate-free, or use a
unique representative per projective point.

The checker and all concrete field laws use Lean's kernel-reduced `decide`.  No theorem uses
`native_decide` or an external evaluator.  The `q=16` proof is split into independent field-law,
arc, disjointness, and canonical-coverage leaves solely to bound build memory; the aggregate
theorem composes their checked propositions.

## Toolchain and exact replay

The checked toolchain is Lean `4.32.0-rc1` (Lake `5.0.0-src+b4812ae`), pinned by
`lean-toolchain`, with Mathlib revision
`571b8a8e54219b4d393f75f4b8653fac08197fcc` pinned by `lake-manifest.json`.
From the repository's `lean/` directory, fetch the pinned Mathlib cache and build the
paper-facing closure with:

```text
nix develop --command lake exe cache get
nix develop --command env LEAN_NUM_THREADS=1 \
  lake build RelativeConicArcs.Gates.Relconic
```

Success means exit status zero and a final Lake success report for
`RelativeConicArcs.Gates.Relconic`; the import-only gate has no runtime output.  A direct
single-thread elaboration of the gate against fetched dependencies took 26 seconds on the
development host.  For a fresh replay, allow 30 minutes, 8 GiB of RAM, and 10 GiB of free disk.
The largest generated q=16 leaves have a measured peak of approximately 1.3 GiB each; the
single-thread command above prevents concurrent leaf peaks.  These resource figures are an
execution envelope, not part of the mathematical claim.

## Frozen witness provenance

Source verifier:
`papers/arcs_complete_outside_conic/verify_relative_conic_arcs.py`

SHA-256:
`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

The q=5 four-frame is checked separately in `ExampleChecks/Q5.lean`; its displayed coordinates
are the image of the standard four-frame under an invertible matrix carrying its nonsingular
conic to the standard conic.  The remaining coordinate lists in `Examples.lean` are copied
verbatim from the general verifier:

- `q=8`: six points over `F₂[a]/(a³+a+1)`, binary polynomial-basis encoding;
- `q=9`: six points over `F₃[a]/(a²+1)`, encoding `a₀+3a₁`;
- `q=11`: six points over `ZMod 11`;
- `q=16`: nine points over `F₂[a]/(a⁴+a+1)`, binary polynomial-basis encoding.

The verifier's frozen report is:

```text
q=8  k=6 points=73  conic_points=9  secants=15 required_points=58  I_C=16 L2=6
q=9  k=6 points=91  conic_points=10 secants=15 required_points=75  I_C=13 L2=6
q=11 k=6 points=133 conic_points=12 secants=15 required_points=115 I_C=0  L2=6
q=16 k=9 points=273 conic_points=17 secants=36 required_points=247 I_C=32 L2=8
```

The Python verifier is provenance and an independent cross-check, not part of the Lean proof.

## Strengthening-check provenance

The finite-field evaluation threshold and q11 structure were independently replayed by:

```text
6ed309bd2461ce9998cbd3bcaa5396379e6973b7503ce2dcdfb32c9806386566  check_evaluation_dichotomy.py
0abe909c9aadce0db4c75f296c8de25e929dd1065c906996da8dec017e534d69  check_q11_structure.py
1753674172d48f1d056d350e30baa9eb67de0810c84a96da0440947768ae041c  check_q11_structure.cpp
```

The Python and separately written C++ q11 programs agree on projective directions, syndrome
distances, leader multiplicities, chord classes, and group-action data. Coordinate transformation
and relabelling preserve every invariant. A one-point witness perturbation changes the extension
count from 12 to 20 and the stabilizer size from 60 to 2; a mutated generator is rejected. Frozen
2026-07-13 output hashes are:

```text
88be03eb8a81bb906083457a4b4201cfd1ef6bcaa9de01928175840f61ac55ff  evaluation output
b096305a809b062c274129c157d51a57d65e9aec0e44662370ec53c8c773110f  q11 Python output
380cab47923cbfb3a9bfcc54ee89cf0eb79aa551d936d2e91cbb4949ae56477d  q11 C++ output
```

The exact replay protocol on the development host was:

```text
python3 check_evaluation_dichotomy.py > /var/tmp/arcs-evaluation.out
python3 check_q11_structure.py > /var/tmp/arcs-q11-python.out
g++ -std=c++20 -O2 check_q11_structure.cpp -o /var/tmp/check_q11_structure
/var/tmp/check_q11_structure > /var/tmp/arcs-q11-cpp.out
sha256sum /var/tmp/arcs-evaluation.out /var/tmp/arcs-q11-python.out /var/tmp/arcs-q11-cpp.out
```

The compiler was `g++ (GCC) 14.3.0`; `/var/tmp` is used because `/tmp` is tmpfs on this host.
These programs are adversarial provenance only. The mathematical q11 claims used in the
manuscript's proposition have corresponding Lean theorems, but the checkers' auxiliary
group-generation, orbit-label, coordinate-invariance, and mutation diagnostics are not all
separate Lean declarations and are not inputs to the proof.

## Exact q=16 classification provenance

Source generator:
`papers/arcs_complete_outside_conic/search_rhoc16.cpp`

SHA-256:
`589af8430e94b4c9c23ce895e6d32d2b3b5b9b387b1fb23ed6d3875cdee39031`

Frozen report:
`papers/arcs_complete_outside_conic/search_rhoc16_output.txt`

SHA-256:
`6989079b5cb64b0e57d5c42b872093fff99f861300b8fbb909daef450c15cc63`

The nine-line frozen report is a generation summary, not the transition or leaf certificate.
The generator enumerates all projective caps extending the standard four-frame and emits four
layers of locally checked transitions.  Each row contains an explicit invertible matrix and a
source/target/scalar equality for every selected point; lightweight `StepBook` modules reference
those semantic row theorems and separately check that their moves cover every legal extension.
The Lean soundness theorem therefore does not trust the generator's canonical labels or its
coverage assertions.  The kernel-checked exhaustive covering lists at sizes five through eight
have lengths `4, 61, 454, 2633`; the certificate does not require pairwise inequivalence or
deduplication.  The final ordinary eight-arc class count was already reported by
Al-Seraji--Al-Ogali (2018), and the matching list length is an external consistency check.  The bounded
source-by-source novelty comparison is recorded in
`notes/2026-07-13-rhoc16-novelty-check.md`.

For every eight-leaf, the generated rejection records ordinary-uncovered points.  In 2630 leaves,
six quadratic evaluation rows have an explicitly checked inverse.  In the remaining three leaves,
an explicitly checked linear combination forces any conic equation through the uncovered locus to
vanish at a selected point. `Q16Profile.lean` checks the exact 2630+3 split, while
`Q16ExceptionalArithmetic.lean` identifies the actual three forced-hit records and proves that
their evaluation kernels are precisely the three displayed coefficient lines, in addition to the
factorizations, hit counts `(2,7,2)`, and middle nonsingular model.
`Q16QuadraticTransport.lean` proves the end-to-end arbitrary-eight-arc quadratic-avoidance theorem,
including projective invariance of ordinary uncoveredness and quadratic zero sets. The C++ program and report are reproducible
provenance only; the theorem depends on the emitted data through kernel-checked local predicates.

## Ten-point matching-design realization provenance

The manuscript's rank-three classification of the two
`MATCH(10,5,1)` designs is supported by the paper-local bundle:

```text
papers/arcs_complete_outside_conic/check_match10_rank_three.py
papers/arcs_complete_outside_conic/check_match10_rank_three.json
papers/arcs_complete_outside_conic/check_match10_rank_three.sha256
```

The generator canonically reconstructs representatives of the two published
abstract classes through the Reichard--Woldar overlarge-`S(3,4,8)` model,
checks their matching-design axioms and automorphism orders, and forms the
189 normalized projective concurrency equations for each class.  Singular
4.4.1 computes two monomial-order certificates in characteristics 2 and 37
and exact rational module lifts whose only denominator prime is 2.  The JSON
also records the triangular characteristic-two basis for the regular-hyperoval
class and an independent direct `GF(8)` incidence construction with an exact
transporter.

Replay from the paper directory:

```text
nix shell nixpkgs#singular --command \
  python3 check_match10_rank_three.py --check
sha256sum -c check_match10_rank_three.sha256
```

The script is 21,258 bytes with SHA-256
`e19d9feee10aac64e881fedd31f6cedbb8523f6865e7210c6089ae5e84dc904a`;
the 77,767-byte JSON certificate has SHA-256
`84b9b4beb48fd309d7f7c14bdf40062ae3b0a2d78605468f08d48c602f53970d`.
Exact Python integer/finite-field arithmetic and Singular Gröbner bases and
module lifts remain trusted executions.  The second monomial order and direct
`GF(8)` incidence construction are independent checks.  Abstract completeness
is Mathon's published two-class theorem, cited through
Alspach--Heinrich's account because the primary proof was not available for
direct inspection.  No Lean theorem consumes this certificate.

## Axiom audit

`#print axioms` for the cap-game localization and parametrized-value bridges, the ordinary
coverage checker, `Certificate.check_sound`,
`rhoC_le_length_of_check`, the complete-affine specialization and equality criterion, all five
`L2` theorems, all five final finite-example theorems, the
q=16 eight-arc nonexistence, profile, exceptional-arithmetic, arbitrary-classification-chain, and
quadratic-pullback theorems, the q=9 terminal P theorem, q=11 residual and actual
seeded P theorems, the q11 MDS/radius/deep-hole/leader/extension/chord theorems, and the public
syndrome/coding bridges, together with the public finite-field evaluation-dichotomy, quantitative-count,
sharp-cover, equality-model, kernel/span, and feature-closure theorems
reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are the accepted Mathlib foundations used throughout the projective quotient development.
There is no `sorryAx`, custom axiom, `admit`, or `native_decide` dependency.

## Explicit external boundary

The only deep asymptotic estimate intentionally not reproved is the Kim--Vu complete-arc bound.
It is represented by the named hypothesis `KimVuBound`, appears in theorem signatures rather than
as a global axiom, and is not used by the five finite-example results. The q=11 projectively-GRS
interpretation separately uses the cited classical normal-rational-curve/GRS dictionary; Lean
checks the complete algebraic implication after that dictionary. The cited ordinary q=16 class
count is only an external consistency check and is not a proof input.
