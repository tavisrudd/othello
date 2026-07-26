# Proof and claim ledger

**Paper:** *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure.*

**Ledger rule:** every mathematical assertion promoted to theorem/corollary status in the paper
must appear below with its exact formal boundary. Context and novelty claims are listed separately
so that they cannot be mistaken for kernel-checked mathematics.

## Status vocabulary

| Status | Meaning |
|---|---|
| `KERNEL` | Lean-checked; only `propext`, `Classical.choice`, and `Quot.sound` may appear in the axiom report. |
| `IMPORTED-1` | Lean-checked consequence of the one named Stichtenoth literature axiom, plus the standard logical axioms. |
| `MANUSCRIPT` | Proved in the paper or its named report; not presently kernel-formalized. |
| `CERTIFIED` | Checked by a committed deterministic script/JSON certificate with a report recording replay and hash boundaries. |
| `LITERATURE` | Context or provenance taken from a cited source; not part of the Lean proof chain. |
| `PRIOR-ART` | A checked source already contains the concept or result; no novelty is claimed. |
| `DERIVED` | A kernel-checked strengthening or consequence of listed inputs; not positioned as an independent novelty claim. |
| `NONE-FOUND` | A bounded adversarial search found no collision; this is not a priority certificate. |
| `REVIEW-GATE` | Work still required for submission confidence, not a mathematical or formalization blocker. |
| `OPEN-MATH` | Optional strengthening that requires a new mathematical argument; not a current paper claim or formalization gap. |

## Mathematical ledger

| ID | Paper claim | Status | Lean declaration(s) | Boundary / notes |
|---|---|---|---|---|
| D1/P1 | Complete radius-`r` repair hypergraph; matching `nu`; transversal `tau`; `nu<=tau`; minimal-clutter invariance | `KERNEL` | `FiniteGeom.repairHypergraph`, `minimalRepairHypergraph`; `matchingNumber`, `transversalNumber`, `nu_le_tau`, `matchingNumber_minimalHyperedges`, `transversalNumber_minimalHyperedges` | Definitions use actual dual-word supports, not selected recovery groups. Matching invariance assumes every edge is nonempty, exactly as stated in the paper. The draft's vacuous dual-distance edge-cardinality sentence was removed in C286. |
| D1a / C203 | Every repair witness gives its exact normalized scalar recovery vector; the three completed-seed locality shapes have explicit nonzero coefficients; coefficient ratios are not monomial invariants | `KERNEL` | `FiniteGeom.repair_edge_has_scalar_recovery_equation`, `projectiveAxisPair_coefficient_relation`, `projectiveAxisPair_arbitrary_helperCoefficient`, `projectiveCubicInfinity_coefficient_relation`, `projectiveAxisInfinityCubic_coefficient_relation` | The coefficient fiber contains ordinary target-normalized vectors, not projective classes. The direct protocol reads/downloads one full field symbol per helper. This is not a minimum-access or minimum-bandwidth theorem under subpacketization. Independent q9 replay checks 240 relations, 840 retargetings, and 576 helper-gauge rescalings with fixed target coefficient. |
| T1 | The axis--twisted-cubic code is `[2q+1,4,q-1]_q` in finite characteristic three | `KERNEL` | `FiniteGeom.axisTwistedCubic_code_parameters` | The paper's projective description uses the same displayed columns as Lean. |
| T2 | Small circuits are axis triples or a unique three-cubic/one-axis completion; axis locality is exactly two and cubic locality exactly three | `KERNEL` | `twistedCubicTriple_isFourCircuit`, `twoCubicTwoAxis_linearIndependent`; `RepairCodes.mem_cubicRepairHypergraph_iff`, `mem_axisRepairHypergraph_two_iff`, `cubicRepair_threeCubic_not_mem`, `cubicRepair_oneCubic_twoAxis_not_mem`, `cubicRepair_threeAxis_not_mem`, `cubicCoordinate_exact_locality_three`, `axisCoordinate_exact_locality_two` | The circuit-to-repair bridge is also checked in `FiniteGeom.Repair`; the cited positive and exclusion declarations cover every size-at-most-four type. |
| T3 | Uniform exact rows and `tau_i>nu_i` for every coordinate when `q>=9` | `KERNEL` | `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_matchingNumber`, `cubicRepair_transversalNumber`, `axisTwistedCubic_allSymbol_tau_gt_nu` | Cubic coordinates have exact row `((q-1)/2,q-2)`. Axis rows use semantic `Z_3(q)`, the maximum zero-sum-free/cap size; the strict gap needs no external cap-set estimate. |
| T3a / C104 | Shifted-inverse completion identity and a rainbow perfect matching on every cubic helper set | `KERNEL` | `twistedCubicTripleAxisIndex_eq_cubicRepairSumColor`, `cubicRepairSumColor_injective`, `FiniteGeom.units_addColor_matchingNumber_lower`, `cubicRepair_matchingNumber_ge_half`, `cubicRepair_matchingNumber` | The finite-field construction pairs consecutive powers of a multiplicative generator. The pairing pattern is classical-adjacent one-quotient-starter mathematics; novelty is not inferred from formalization. |
| T4 | At `q=9`, exact rows `(4,7)`, `(6,12)`, `(7,13)`, with minimal-repair counts `28`, `36+8`, `36+12` | `KERNEL` | `axisTwistedCubic_q9_row_invariants`, `cubicRepair_edge_count_q9`, `axisRepair_component_edge_counts_q9` | Coordinate multiplicities are `9`, `9`, and `1`. |
| T4a | At `q=9`, the small-circuit support inventory is `120` axis triples and `84` completed cubic quadruples | `KERNEL` | `q9_smallCircuit_support_counts` | Counts distinct supports, not coefficient-scaled dual words. |
| T4b | Every `q=9` coordinate satisfies `7*nu<=4*tau`, with equality at every cubic coordinate | `KERNEL` | `axisTwistedCubic_q9_ratio`, `axisTwistedCubic_q9_row_invariants` | The equality statement is the cubic row `(4,7)`. |
| T4c | The projective completion is `[2q+2,4,q]_q` with dual distance three and exact locality three on cubic coordinates and two on axis coordinates | `KERNEL` | `projectiveAxisTwistedCubic_code_parameters`, `projectiveAxisTwistedCubicCode_dualDist`, `projectiveAxisTwistedCubic_cubic_exact_locality_three`, `projectiveAxisTwistedCubic_axis_exact_locality_two` | The point system and characteristic-three common axis are classical; no novelty is inferred from these parameters or locality alone. The cubic-locality theorem assumes only `q>=3`, automatic in the paper's characteristic-three field range. |
| T4d | Radius four exhausts the completed seed's full minimal inner port, with cubic row `((q-1)/2,q-1)` and axis row `((5q-3)/6,2q-3)` | `KERNEL` | `minimalProjectiveAxisTwistedCubicRepair_full_eq_four`, `minimalProjectiveCubicRepair_full_invariants`, `minimalProjectiveAxisRepair_full_invariants` | “Full” is inner-only. The matching proof covers every minimal edge without assuming a five-circuit catalogue. |
| T5 | Exact complete repair-hypergraph transfer under `r+1 < 2d(I^perp)` and outer functional-dual distance at least `r+2`; every exact locality `s<=r` is preserved | `KERNEL` | `repairHypergraph_concatenatedCode_eq_embed`, `FiniteGeom.HasExactLocalityAt`, `hasExactLocalityAt_concatenatedCode_iff_of_le`; matching/transversal corollaries in `RepairCodes.SeedLift` | Stronger than locality preservation: equality holds for every bounded dual-support repair set. Exact mixed-locality transfer is a derived corollary of equality at all radii up to `s`. |
| T5w / C214 | Weighted functional-dual distance at least `r+2`, together with `r+1<2d(I^perp)`, implies exact complete repair-hypergraph transfer | `KERNEL` | `HasWeightedFunctionalDualDistanceAtLeast`, `concatenatedDualWord_transfer_weighted`, `repairHypergraph_concatenatedCode_eq_embed_weighted` | The predicate quantifies over every fiber realization, avoiding hidden minimum-attainment assumptions. Ordinary functional distance implies it. |
| T5x / C214/C221/C224 | The exact multiblock threshold splits into zero-fiber, singleton-functional, and multisupport-functional strata. With at least two outer blocks and nontrivial inner dual, the exact nonembedded-witness threshold is `min(2d(I^perp),d_lambda(O))`; under coordinate-surjective projections the singleton stratum vanishes and the two thresholds agree. The pointed threshold is the exact bounded-witness confinement profile and implies coordinatewise hypergraph equality. Falling below the global witness threshold implies complete repair-hypergraph equality; no converse from support-set equality is claimed. | `KERNEL` | Paper-facing terminals `RepairPorts.exactFunctionalStrata` and `RepairPorts.exactPointedConfinementAndTransfer`; component chain `blockFunctional_surjective`, `exists_minimal_blockFunctional_representative`, `exists_minimal_functional_realization`, `exists_dualWord_hammingNorm_eq_dualDist`, `hasZeroFunctionalMultiblockAtLeast_iff_le_two_dualDist`, `hasSingletonFunctionalMultiblockAtLeast_iff_term`, `hasMultisupportFunctionalMultiblockAtLeast_iff_term`, `hasMultiblockDualDistanceAtLeast_iff_three_exact_terms`, `hasNonembeddedDualDistanceAtLeast_iff_le_two_dualDist_and_weighted`, `concatenatedDualWord_transfer_nonembedded`, `repairHypergraph_concatenatedCode_eq_embed_nonembedded`, `hasPointedNonembeddedDualDistanceAtLeast_iff`, `repairHypergraph_concatenatedCode_eq_embed_pointed`, `hasNonembeddedDualDistanceAtLeast_iff_multiblock_of_isCoordinateSurjective`, `nonsurjective_multiblock_vacuous`, `nonsurjective_nonembedded_threshold_one`, `nonsurjective_multiblock_confinement_not_transfer` | Exactness is stated as equality of all natural lower-bound profiles, which correctly represents an empty functional-dual stratum as infinity. Fiber nonemptiness and coordinatewise/product minimum attainment are explicit Lean theorems. The numeric presentation requires `|J|>=2` and nontrivial inner dual, exactly as in the manuscript theorem. The manuscript's nonsurjective corrective example is kernel-checked, including literal radius-zero hypergraph inequality. |
| T5e / C214/C221/C224 | The completed q=9 seed with a Singer-shifted `[5,4,2]_{6561}` generalized SPC outer code has functional distance 5, weighted distance at least 6, exact multiblock/nonembedded threshold 6, and exact radius-four transfer | `KERNEL / CITED SINGER INPUT` | `exists_disjoint_translate_of_regular_action`, `exists_disjoint_translate_of_twenty_in_regular_820`, `hasUnitFunctionalCost_iff_coordinate_orbit`, `innerCoordinateFunctional_orbit_injective`, `exists_disjointUnitCostMultiplier_of_regular_projective_action`, `projectiveAxisTwistedCubic_twenty_unitCost_orbits`, `projectiveAxisTwistedCubic_exact_threshold_six_of_disjoint`, `mem_functionalDual_generalizedSPCFive_iff`, `generalizedSPCFive_functionalDual_full_support`, `generalizedSPCFive_functionalDistance_five`, `generalizedSPCFive_not_functionalDistance_six`, `generalizedSPCFive_isCoordinateSurjective`, `generalizedSPCFive_weightedDistance_six_of_disjoint`, `generalizedSPCFive_radiusFour_transfer_of_disjoint`, `projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action` | Singer regularity is supplied as the cited projective-action hypothesis. Lean derives the disjoint translate from regularity and `20^2<820`, identifies the seed's twenty distinct scalar unit-cost classes, transports the projective action through functional precomposition to construct the disjoint multiplier, and checks every subsequent code deduction. |
| T5f / C214 | Concatenated-dual fiber enumerator is the sum over functional-dual tuples of products of inner fiber enumerators, including a support-refined version | `CITED CLASSICAL` | Equation `eq:fiber-enumerator`; Chen--Ling--Xing 2001, Theorem 2.3, and 2005, Theorem 2.1 | Imported literature result rather than a new manuscript claim; it is outside the requested re-proof boundary. The manuscript's new transfer conclusions do not depend on this enumerator identity. |
| T5a / C105 | Neither numerical gate can be weakened uniformly while preserving complete repair-hypergraph equality | `KERNEL` | `boundaryInnerCode_ne_bot`, `boundaryOuterCode_ne_bot`, `boundaryFullOuterCode_ne_bot`, `boundaryInnerCode_dualDist`, `boundaryOuterCode_functionalDualDistance_three`, `boundaryOuterCode_not_functionalDualDistance_four`, `innerDualDistanceGate_boundary_counterexample`, `outerFunctionalDualDistanceGate_boundary_counterexample` | Nondegenerate `GF(3)` repetition/SPC examples prove literal hypergraph inequality at `r+1=2d(I^perp)` and at outer functional-dual distance `r+1`. This is not a necessity claim for any fixed concatenation. |
| T6 | Finite-separable trace bridge from ordinary extension-field dual distance to the functional-dual gate, with exact support | `KERNEL` | `traceCoefficient_mem_dualCode`, `functionalWeight_traceCoefficient`, `hasFunctionalDualDistanceAtLeast_restrictScalars` | No coding-theory decomposition is imported. |
| T7 | Degree-four lift has `[19N,4K,>=8D]_9`, a disjoint exhaustive coordinate partition with multiplicities `9N,9N,N`, exact locality three on cubic and two on axis coordinates, exact row transfer, and failure thresholds `6,11,12` when `d(O^perp)>=5` | `KERNEL` | `q9ExtensionLiftCode_parameters`, `q9Lift_coordinate_type_partition`, `q9Lift_coordinate_type_counts`, `q9ExtensionLiftCode_repairHypergraph_of_radius_le_three`, `q9ExtensionLiftCode_cubic_exact_locality_three`, `q9ExtensionLiftCode_axis_exact_locality_two`, `q9ExtensionLiftCode_row_invariants`, `q9ExtensionLiftCode_failure_thresholds` | Ordinary `GF(9^4)`-linear outer code; restriction of scalars is explicit. Exact locality is certified by transferring radii one, two, and three, not inferred from radius-three existence alone. |
| T7p | Completed lift has `[20N,4K,>=9D]_9`, exact `10N/10N` partition, exact locality three/two, and exact radius-four rows `(4,8)` and `(7,15)` when `d(O^perp)>=6` | `KERNEL` | `projectiveQ9ExtensionLiftCode_parameters`, `projectiveQ9Lift_coordinate_partition`, `projectiveQ9Lift_coordinate_counts`, `projectiveQ9ExtensionLiftCode_exact_locality`, `projectiveQ9ExtensionLiftCode_row_invariants` | Equality is through radius four only; no lifted unbounded full-port claim. |
| T8 | Unbounded `GF(9)` family with exact rate `2/19`; for every fixed `c<39/190`, eventual relative distance `>c`; bundled disjoint type distribution, exact mixed locality, rows, and thresholds | `IMPORTED-1` | `HasQ9LiftCoordinateDistribution`, `HasQ9LiftCoordinateProfile`, `HasQ9UniformRepairFamily`, `eventually_scaled_lift_distance_gt`, `stichtenoth_q9_uniform_repair_family`, `concrete_q9_uniform_repair_family` | Sole nonformalized input: `Imported.stichtenoth_selfDual_TVZ_6561`. The displayed `1/5` remains a clean explicit corollary. Quantifier order is `forall c<39/190, eventually`, so the eventual index may depend on `c`; equality at `39/190` is not claimed. |
| T8p | Completed unbounded q9 family has exact rate `1/10`, every fixed eventual bound `c<351/1600`, clean `>=1/5`, equal coordinate classes, and exact radius-four profiles | `IMPORTED-1` | `eventually_projective_scaled_lift_distance_gt`, `stichtenoth_projective_q9_uniform_repair_family`, `concrete_projective_q9_uniform_repair_family` | Same sole Stichtenoth import. Neither the endpoint nor the lifted unbounded full port is claimed. |
| T9 / C216 | Every fixed represented radius-`r` support and normalized coefficient port with `r+1 < z_x(I)` occurs with density `1/m` in an asymptotically good fixed-alphabet concatenated family; the inequality is necessary and sufficient for eventual low-weight pointed-witness confinement | `KERNEL + NAMED CLASSICAL INPUT` | `RepairPorts.eventually_pointedConfinement_iff_zeroCost`, `eventually_prescribedPorts`, `representedTargets_density`, `concatenatedRestrictedCode_parameters`; trace bridge `RepairCodes.hasFunctionalDualDistanceAtLeast_restrictScalars` | Lean consumes an explicit outer family with dual distance tending to infinity and proves every finite/eventual transfer and parameter deduction. Random-GV or AG/TVZ existence supplies that family externally. The theorem does not claim every abstract hypergraph is representable. |
| T9c / Clebsch application | For the Clebsch `[6,3,4]_11` code, the minimal radius-three port is the complete three-uniform clutter on five helpers with `(nu,tau)=(1,3)`; already the radius-three coefficient port reconstructs the code; `z_x=8`; and every bounded port through the full radius occurs with density `1/6` in an asymptotically good fixed-`F_11` family | `KERNEL / DERIVED + NAMED CLASSICAL INPUT` | `RepairPorts.eventually_mdsMinimumCoefficientFingerprints`; Corollary `cor:clebsch-port`; Paper I supplies the represented code; random-GV supplies the outer family | Dual MDS parameters give generic support and reconstruction; the exact `z_x=8` specialization permits every radius through the full five-helper port. Only the coefficient layer is Clebsch-specific; the support clutter and reliability polynomial are generic for `[6,3,4]` MDS codes. |
| T10 / C219 | Complete-port reliability satisfies deletion--contraction, pivotal influence, Russo--Margulis, and the minimum-blocker high-survival expansion; the harmonic nucleus has a Poisson repair window while curve targets have a nucleus series bottleneck | `MANUSCRIPT / CERTIFIED` | `notes/2026-07-16-c219-repair-reliability.{py,json}` | General probability tools are classical. Exact q9 coefficients and design overlap counts are certified; the all-field Poisson statements have manuscript proofs. |
| T11 / C226 | Radius-truncated extrinsic BEC failure has the erasure-sign deletion--contraction calculus; successive truncated curves give the cheapest available repair-radius distribution; blockers are target-specific one-shot failure certificates, not generic Tanner stopping sets | `MANUSCRIPT / CERTIFIED` | `notes/2026-07-16-c226-repair-port-exit-transforms.{py,json}` | Full radius is symbol-MAP. A finite radius is a bounded-query decoder and carries no EXIT-area capacity claim. |
| T12 / C227 | Full repair reliability is a specialization of the Las Vergnas polynomial of `M\\x -> M/x`; the deletion/contraction rank-polynomial derivative gives the successful-set enumerator; pointed duality exchanges repair and failure | `LITERATURE / MANUSCRIPT / CERTIFIED` | Las Vergnas 1999; `notes/2026-07-16-c227-pointed-tutte-repair-polynomial.{py,json}` | The polynomial identification is standard, not a new invariant. The q9 full-versus-radius-four coefficient differences certify that the standard polynomial forgets the radius filtration. |
| T13 / C218 | The quartic normal rational curve plus nucleus gives `[q+2,5,q-3]_q`, dual distance five, and exactly the harmonic `S(3,4,q+1)` radius-four circuits; q9 rows are nucleus `(2,5)` and curve `(1,1)` | `MANUSCRIPT / CERTIFIED / LITERATURE NUCLEUS` | `notes/2026-07-16-c218-quartic-nucleus-verifier.{py,json}`; Gmainer--Havlicek nucleus formula | Harmonic quadruples and Steiner systems are classical. The repair interpretation is cautiously positioned as none-found, not a priority claim. |
| T14 / C243 | Harmonic radius-four circuit closure has the exact nucleus gate law; at q9 a block-free rank-five curve set spans linearly but is bounded-circuit inert, while adjoining the nucleus completes the missing curve points in one round | `MANUSCRIPT / CERTIFIED` | `notes/2026-07-17-c243-nucleus-gated-separation-vet.{py,json}` | This is a deterministic finite separation only. No propagation-completeness, random-cascade, threshold-location, or sharpness theorem is claimed. |
| T15 / C244 | For the harmonic `[11,5,6]_9` code, radius-four EXIT deficits are `2/77` and `23/154`, the corrected total area is `502/77`, and the nucleus/derived-design Poisson errors are `O(n^-1/4)` and `O(n^-1/3)` | `MANUSCRIPT / CERTIFIED` | `notes/2026-07-17-c244-exact-consequence-pack.{py,json}` | The area identity is exact accounting under the extrinsic-failure convention, not a rate/locality inequality. Explicit rates use the classical Arratia--Goldstein--Gordon bound. |

### C286 manuscript synchronization

- Theorem `thm:transfer` now assumes at least two outer blocks and states the exact pointed
  nonembedded cost as the minimum of the zero-functional branch `z_x(I)` and the nonzero
  functional-tuple cost. This matches T5x and removes the draft's ambiguous “embedded zero tuple
  removed” wording.
- The prescribed-realization paragraph now displays both AG bounds
  `delta(O_N)>=1-R-gamma` and `delta(O_N^perp)>=R-gamma`, matching T9's eventual-confinement
  hypothesis.
- The harmonic Steiner attribution now separates the Gmainer--Havlicek nucleus formula from the
  standard `PGL(2,q)` four-set design construction, cited through Tricot's review of that orbit
  construction. The manuscript's completion proof remains load-bearing for the exact blocks.

## Imported theorem ledger

| Import | Exact source | Consumed statement | Why it is not formalized here |
|---|---|---|---|
| `RepairCodes.Imported.stichtenoth_selfDual_TVZ_6561` | H. Stichtenoth, *Transitive and Self-dual Codes Attaining the Tsfasman--Vladut--Zink Bound*, arXiv:math/0506264, Theorem 1.6(ii) | Over `GF(6561)=GF(81^2)`, an unbounded self-dual family of rate `1/2` whose limiting relative distance is at least `39/80` | Its proof uses asymptotically optimal towers of algebraic function fields; importing one precise theorem is the chosen middle-route boundary. |

## Context and novelty ledger

| ID | Claim | Status | Evidence / restriction |
|---|---|---|---|
| C1 | The line `X_0=X_3=0` is the characteristic-three axis of the osculating-plane pencil of the twisted cubic | `LITERATURE` | Davydov--Marcugini--Pambianco, arXiv:2103.12655, Section 7; not needed for the coordinate proof. |
| C2 | Locality-preserving and asymptotically good concatenated LRC constructions are established prior art | `PRIOR-ART` | Liu--Ma--Wu--Xing, arXiv:2208.04484, Theorem 3.1 and AG applications; Jin--Fu, arXiv:2605.04618v1. |
| C3 | The minimum transversal is already the local repair-tolerance invariant | `PRIOR-ART` | Pamies-Juarez--Hollmann--Oggier, arXiv:1302.5518, Definition 3; Wang--Zhang, arXiv:1401.2607, gives the general regenerating-set framework. |
| C4 | Treating all bounded dual supports is adjacent established machinery | `PRIOR-ART` | Gruica--Jany--Ravagnani, DOI 10.1007/s10623-026-01829-7, refine weight distributions by prescribed dual supports. |
| C5 | Twisted-cubic axes, stabilizer orbits, incidence counts, and associated code/coset data are established prior art | `PRIOR-ART` | arXiv:1909.00207, 2007.08798, 2103.12655, 2103.16904, and 2104.12254. |
| C6 | Distinct recovery sets are separated by the dual distance through their symmetric difference | `PRIOR-ART` | Kurz--Yaakobi, arXiv:2001.03433 / DOI 10.1007/s10623-020-00828-6, Lemma 10(a). C105's inner-boundary mechanism is an instance; the exact complete-transfer boundary formulation was not found. |
| C7 / C214 | Direct-sum decomposition of a concatenated dual and its blockwise inner-dual cosets | `PRIOR-ART` | Chen--Ling--Xing, DOI 10.1109/18.930941, Theorem 2.3; recalled at DOI 10.1109/TIT.2005.851760, Theorem 2.1. |
| N1 | No checked source was found that proves complete bounded repair-hypergraph equality under an outer dual-distance gate | `NONE-FOUND` | Surviving bounded-search conclusion only; manuscript says “we did not locate,” never an unconditional “first.” |
| N2 | No checked twisted-cubic incidence/covering source was found to compute these coordinatewise `(nu,tau)` rows or prove all-symbol `tau>nu` | `NONE-FOUND` | Geometry and incidence counts are prior art; only the exact repair-invariant computation is positioned as a candidate contribution. |
| N3 | Formalization novelty is separate from mathematical novelty | `PRIOR-ART` | Lean certification strengthens trust and exposes boundaries; it is not used as evidence that a theorem is new. |
| N4 | The asymptotic theorem is a derived candidate result, not a claim that AG concatenation itself is new | `NONE-FOUND` | Candidate value is simultaneous fixed-alphabet positive rate/distance plus exact blockwise repair rows. |
| N5 | Improving the displayed distance constant from `8/57` to `1/5`, then to every strict `c<39/190`, and bundling multiplicities/localities/failure thresholds are arithmetic and transfer consequences rather than separate constructions | `DERIVED` | For fixed `c<39/190`, `19c/8<39/80`; the exact type data follow from complete-hypergraph transfer and the q=9 seed table. Neither equality at `39/190` nor a new asymptotic construction is claimed. |
| N6 | Generic preservation of exact locality `s<=r` is a reusable strengthening of the transfer API, not a separate novelty locus | `DERIVED` | It follows formally from complete-hypergraph equality at each radius up to `s` plus monotonicity of the same inner/outer gates. Candidate novelty remains attached to complete-support equality itself. |
| G1 | Specialist citation-chain review in MathSciNet/zbMATH/IEEE Xplore | `REVIEW-GATE` | Submission preflight only; it does not block the mathematical theorem chain or internal manuscript assembly. |

## Optional strengthening ledger

| ID | Direction | Status | Exact present boundary |
|---|---|---|---|
| F2 | Replace semantic `Z_3(q)` in the axis rows by further exact values or sharper explicit estimates | `OPEN-MATH` | The formulas in terms of `Z_3(q)` are exact and `Z_3(9)=4` is checked; further evaluation needs cap-set mathematics or a precisely quarantined source theorem. |
| F3 / C105 | Uniform non-weakenability of the concatenation transfer gates | `CLOSED` | Both numerical boundaries now have explicit kernel-checked complete-hypergraph counterexamples. Fixed-code necessity remains deliberately unclaimed. |

## Consistency and release checklist

Last full pass: 2026-07-17 (C280). A checked box records a direct source, Lean, or build comparison, not
an impressionistic reread.

### Mathematical statements

- [x] Definitions of complete repair hypergraph, matching, transversal, and minimal clutter agree
  with `FiniteGeom.Repair` and `FiniteGeom.Hypergraph`.
- [x] Seed parameters, coordinate multiplicities, exact localities, circuit types, repair counts,
  and all three `q=9` rows agree with the corresponding Lean declarations.
- [x] Uniform axis formulas, the exact cubic row `((q-1)/2,q-2)`, the `q>=9` range, and the
  semantic `Z_3(q)` boundary agree with `AxisTwistedCubicInvariants.lean`.
- [x] The transfer theorem is sufficient under `r+1 < 2*d(I^perp)` and functional-dual distance
  at least `r+2`; separate nondegenerate `GF(3)` examples prove both gates best possible only for
  a uniform theorem, with no fixed-code necessity claim.
- [x] Exact-locality transfer is stated for every `s<=r`, and both existence at `s` and
  nonexistence below `s` are represented by the complete repair hypergraphs.
- [x] The finite lift uses the full `[19,4,8]_9` seed, its actual dual distance three, outer ordinary
  dual distance at least five, and parameters `[19N,4K,>=8D]_9`.
- [x] The asymptotic arithmetic is synchronized: extension degree four, outer field size `6561`,
  source bound `39/80`, rate `2/19`, every fixed distance constant `c<39/190`, and the clean
  explicit corollary `>=1/5`; no endpoint claim at `39/190` appears.
- [x] Lifted locality is exact: locality three on the `9N` cubic coordinates and locality two on
  the `9N+N` axis coordinates; the proof transfers radii one, two, and three.
- [x] The lifted row multiplicities and their `tau-1` thresholds are synchronized as
  `9N:(4,7):6`, `9N:(6,12):11`, and `N:(7,13):12`.
- [x] `HasQ9UniformRepairFamily` itself bundles the partition, multiplicities, exact localities,
  rows, and thresholds rather than relying only on adjacent declarations.
- [x] The projective completion is synchronized as `[2q+2,4,q]_q`, dual distance three, exact
  locality three/two, and full-minimal radius-four rows `((q-1)/2,q-1)` and
  `((5q-3)/6,2q-3)`; “full” is never applied to the lift.
- [x] The completed finite lift uses outer dual distance six and parameters
  `[20N,4K,>=9D]_9`, with exact `10N/10N` multiplicities and radius-four rows `(4,8)`, `(7,15)`.
- [x] Completed asymptotic arithmetic is synchronized: exact rate `1/10`, every fixed
  `c<351/1600`, clean `>=1/5`, and no endpoint assertion.
- [x] C216's prescribed-port theorem is stated with the exact persistent obstruction `z_x(I)`,
  target density `1/m`, and a representability boundary; random-GV and AG/TVZ regions are not
  promoted as new coding bounds.
- [x] C219/C226 reliability and EXIT conventions condition the target unavailable, distinguish
  extrinsic failure from residual erasure, and reserve symbol-MAP language for the full port.
- [x] C227 is labeled as the standard Las Vergnas perspective polynomial; the manuscript claims
  only the exact repair specialization and the bounded-radius filtration boundary.
- [x] C218's quartic parameters, harmonic circuit inventory, SQS repair counts, and q9 rows agree
  with the symbolic report and the independently regenerated certificate.
- [x] The harmonic q9 Bernstein profiles, EXIT deficits `2/77` and `23/154`, total area `502/77`,
  Poisson limits/rates, and C243 nucleus gate agree with exact C219/C227/C243/C244 replays.

### Formal trust and source boundary

- [x] Every new theorem/corollary promoted in the manuscript has a status row above.  The exact
  threshold, finite-attainment chain, and strict generalized-SPC transfer are kernel-checked.
  Singer regularity and the enumerator identity are explicitly cited classical inputs outside the
  re-proof boundary; the latter is not used by the new transfer conclusions.
- [x] `lake build RepairCodes` succeeds under the OOM-safe wrapper.
- [x] The forbidden-token scan is empty outside `Imported.lean`'s single `axiom`.
- [x] Finite/algebraic theorem axiom reports contain only the allowed standard logical axioms.
- [x] Both transfer-boundary headlines prove literal complete-hypergraph inequality and their
  axiom reports contain only the allowed standard logical axioms.
- [x] The asymptotic headline adds exactly
  `Imported.stichtenoth_selfDual_TVZ_6561`.
- [x] Stichtenoth Theorem 1.6(ii) was checked against the primary paper: it gives an unbounded
  self-dual family over every square field with limiting relative distance at least
  `1/2-1/(ell-1)`; `ell=81` gives `39/80`.

### Prose, novelty, and package synchronization

- [x] No missing citation keys, missing labels, duplicate citation keys, or duplicate labels.
- [x] Internal adversarial novelty review completed; repair tolerance, bounded dual-support
  machinery, locality-preserving concatenation, trace duality, and ordinary AG/LRC asymptotics are
  identified as prior or adjacent art.
- [x] The projective completion's classical geometry/code parameters and derived asymptotic
  constants are separated from the none-found candidate novelty of its exact repair rows.
- [x] Surviving novelty language is limited to “candidate contribution” / “we did not locate”; no
  unconditional priority or “first” claim remains.
- [x] The legacy `[10,4,6]_9` seed is marked registry/library-only and is not substituted for the
  manuscript's `[19,4,8]_9` seed.
- [x] README, paper index, planning registry, current handoff, proof ledger, and novelty review use
  the same six-part scope and trust posture.
- [x] Tectonic succeeds without citation, reference, or box warnings and the PDF is regenerated.
- [x] C218/C219/C226/C227/C243/C244 scripts regenerate their tracked JSON certificates byte for
  byte in one clean replay.
- [ ] External specialist citation-chain review completed (submission preflight; not a theorem or
  formalization gate).
