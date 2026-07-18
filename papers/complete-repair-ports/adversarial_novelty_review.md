# Adversarial novelty review

**Audit date:** 2026-07-16

**Object:** *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure.*
**Rule:** a none-found search is evidence for cautious positioning, never a priority
certificate. Lean establishes correctness of formal statements, not novelty.

## Bottom line

The candidate novelty survives in four narrow places:

1. the exact coordinatewise matching/transversal calculations for the
   characteristic-three affine-twisted-cubic plus full-axis code, including
   strict `tau > nu` at every coordinate for `q >= 9`; and
2. equality of the complete bounded dual-support repair hypergraph under
   concatenation, now sharpened to the exact inner-coset-weight obstruction;
3. the prescribed represented-port consequence that isolates the persistent pointed obstruction
   while keeping the random-GV and AG/TVZ ingredients explicitly classical; and
4. the quartic--nucleus system's exact complete radius-four repair interpretation and its
   cubic-versus-harmonic application package, all positioned as none-found rather than priority.

The concatenated-dual decomposition and product-sum fiber enumerator do not survive as novelty
claims: Chen--Ling--Xing state the direct-sum dual decomposition explicitly. The surviving C214
candidate is the exact repair-confinement minimum and its strict Singer-cycle example.

The fixed-alphabet asymptotic family is a formal corollary joining those two
ingredients to a published self-dual TVZ family. Its ordinary rate/distance/locality
mechanism is not positioned as independently novel; its candidate contribution is
the exact blockwise repair-hypergraph data that survives at unbounded length.

The projectively completed seed and its second asymptotic point have the same narrow posture.
The full twisted cubic, characteristic-three axis, projective-system code parameters, rank-four
circuit cutoff, and ordinary rate/distance concatenation are classical or derived. The
none-found candidate contribution is limited to the exact completed-system repair rows and their
complete bounded radius-four transfer.

The C280 structural additions do not create new invariant claims. Reliability polynomials,
deletion--contraction, pivotality, Russo--Margulis, BEC EXIT, Chen--Stein approximation, harmonic
Steiner systems, normal-rational-curve nuclei, cocircuit blocker duality, and the Las Vergnas
set-pointed polynomial are classical. The manuscript uses them to expose exact consequences of
the bounded port and labels the pointed-Tutte identification as standard. The bounded-radius
filtration boundary and exact q9 coefficient/EXIT tables are the computed application, not a new
Tutte or EXIT theory.

One novelty claim failed review and was corrected: Pamies-Juarez--Hollmann--Oggier
explicitly define the minimum hitting set of all bounded dual repairs as *local repair
tolerance*. The manuscript no longer calls the transversal interpretation implicit or
suggests that the invariant itself is new. The transfer thresholds are now called best
possible only for a theorem uniform over all inner and outer codes, because explicit
counterexamples prove exactly that restricted statement.

## Claim ledger

| ID | Claim under attack | Closest checked prior art | Lean evidence | Verdict / permitted wording |
|---|---|---|---|---|
| A1 | Repair robustness is the transversal number of all bounded repair supports | Pamies-Juarez--Hollmann--Oggier, arXiv:1302.5518, Definition 3, gives exactly the minimum hitting-set formula as local repair tolerance; Wang--Zhang, arXiv:1401.2607, gives a general regenerating-set/tolerance framework | `FiniteGeom.transversalNumber` and repair-hypergraph definitions formalize the invariant | **PRIOR ART.** Say that `tau-1` is the guaranteed failure threshold under the paper's convention, but do not claim the invariant or interpretation as new. |
| A2 | Treating all low-weight dual supports, rather than a selected repair group, is new | Gruica--Jany--Ravagnani, DOI 10.1007/s10623-026-01829-7, define refined weight distributions indexed by prescribed subsets of dual supports and use them to capture locality | `FiniteGeom.repairHypergraph` contains exact distinct coefficient supports, not dual-word multiplicities | **PRIOR/ADJACENT.** The exact support hypergraph is a useful formulation, but “all dual supports” alone is not a novelty claim. |
| A3 | Exact `(nu,tau)` rows and all-symbol `tau>nu` for the twisted-cubic--axis family are known | Checked twisted-cubic orbit/incidence/coset sources: arXiv:1909.00207, 2007.08798, 2103.12655, 2103.16904, 2104.12254, and their cited geometry context. These classify axes, orbits, incidences, covering data, or coset weights; no checked source states the repair matchings/transversals, the exact cubic row, or the all-symbol separation | `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_matchingNumber`, `cubicRepair_transversalNumber`, and `axisTwistedCubic_allSymbol_tau_gt_nu`; the `q=9` rows are separately kernel-checked | **CANDIDATE NOVELTY; NONE FOUND.** Use “we did not locate,” never categorical “first.” Geometry and the characteristic-three axis remain explicitly prior art. |
| A3a / C104 | The consecutive-power pairing itself is new | Dinitz, DOI 10.1017/S1446788700024678, studies finite-field half-set pairings with constant quotient as one-quotient starters; Alfaro--Rubio-Montiel--Vázquez-Ávila, arXiv:1609.05496, gives the modern strong-starter definitions and further quotient constructions. The exact C104 pairing needs only partition plus distinct sums and is not always a starter, but it is plainly in this classical design-theoretic neighborhood | `FiniteGeom.units_addColor_matchingNumber_lower` checks the required weaker rainbow-perfect-matching property; `twistedCubicTripleAxisIndex_eq_cubicRepairSumColor` and `cubicRepair_matchingNumber` supply the paper-specific bridge and invariant | **PAIRING PATTERN PRIOR/ADJACENT; APPLICATION NONE FOUND.** Do not market the multiplicative pairing as new. The candidate contribution is the shifted-inverse reduction and exact code-derived matching computation. |
| A4 | Locality-preserving concatenation and asymptotically good concatenated LRCs are new | Liu--Ma--Wu--Xing, arXiv:2208.04484, Theorem 3.1 and 3.3; Jin--Fu, arXiv:2605.04618, constructs binary LRCs from `GF(4)` outer codes and a `[3,2,2]` inner code | Parameter lift and distance are checked in `RepairCodes.SeedLift` and `Q9ExtensionLift` | **PRIOR ART.** Do not claim novelty for concatenation, locality preservation, or ordinary concatenated distance/rate. |
| A5 | Complete bounded repair-support equality under concatenation is already stated | Liu et al. prove existence of inherited inner repairs/locality. Jin--Fu analyze locality, parity checks, distance, and weight distributions. The checked sources do not classify every low-weight dual support, impose the functional outer-dual gate, or transfer matching/transversal data | `repairHypergraph_concatenatedCode_eq_embed` proves literal finite-hypergraph equality from exact dual supports; `hasExactLocalityAt_concatenatedCode_iff_of_le` derives preservation of every exact locality below the transfer radius | **CANDIDATE NOVELTY; NONE FOUND** for complete-support equality. Exact mixed-locality preservation is a derived corollary, not a second novelty claim. The elementary block-confinement idea may be independently rediscoverable, so claim the theorem/formulation cautiously. |
| A6 | The trace representation or restriction-of-scalars duality is new | Standard finite-separable trace-pairing mathematics | `traceCoefficient_mem_dualCode`, `functionalWeight_traceCoefficient`, and `hasFunctionalDualDistanceAtLeast_restrictScalars` | **PRIOR MATHEMATICS.** The bridge is a proved enabling lemma, not a standalone novelty claim. |
| A7 | The `GF(9)` asymptotic rate/distance constants are an independently new LRC bound | Liu et al. already use AG outer codes and concatenated inner LRCs to obtain asymptotically good families. Stichtenoth supplies the self-dual TVZ family | `eventually_scaled_lift_distance_gt` and `stichtenoth_q9_uniform_repair_family` check every fixed `c<39/190` from one imported literature theorem | **DERIVED RESULT.** The near-limit formulation is arithmetic, not a new construction or independent bound; the endpoint `39/190` is not claimed. Candidate value lies in simultaneous exact repair rows plus fixed alphabet and positive rate/distance. |
| A7a | Exact lifted locality, type multiplicities, and helper-failure thresholds are independent new phenomena | Complete repair-hypergraph transfer already forces all bounded-radius inner repair data to survive; `tau-1` as failure tolerance is prior art | `q9Lift_coordinate_type_partition`, `q9Lift_coordinate_type_counts`, the two exact-locality theorems, and `q9ExtensionLiftCode_failure_thresholds` | **DERIVED CONSEQUENCES.** Worth stating because they sharpen the theorem, but do not market them separately as novel. Their candidate value is inherited from the complete-hypergraph equality and the seed's exact row computation. |
| A8 | Formal verification proves novelty | No literature source can be excluded by a Lean proof | All theorem boundaries and the sole imported axiom are explicit | **REJECTED INFERENCE.** Lean is evidence of correctness and trust-boundary discipline only. |
| A9 / C105 | Both numerical transfer gates are best possible for a uniform complete-hypergraph theorem | Kurz--Yaakobi, DOI 10.1007/s10623-020-00828-6, Lemma 10(a), already records the elementary dual-distance obstruction between two distinct recovery sets. Standard concatenation and single-parity-check codes make the examples independently rediscoverable. No checked source was found stating both exact thresholds for equality of the complete bounded repair hypergraph | `innerDualDistanceGate_boundary_counterexample`, `outerFunctionalDualDistanceGate_boundary_counterexample` | **ELEMENTARY BOUNDARY THEOREM; COMPLETE-HYPERGRAPH FORMULATION NONE FOUND.** Say “cannot be weakened uniformly” or “best possible for the uniform theorem.” Never say either hypothesis is necessary for every fixed concatenation, and do not market the two-block mechanism itself as new. |
| A10 | The projectively completed cubic--axis system or its ordinary code parameters are new | Twisted-cubic orbit/incidence sources explicitly treat the characteristic-three common axis and full projective cubic; projective-system distance from plane sections is standard | `projectiveAxisTwistedCubic_code_parameters`, `projectiveAxisTwistedCubicCode_dualDist` | **CLASSICAL/DERIVED.** Do not claim novelty for the point set, `[2q+2,4,q]_q`, dual distance, or locality by themselves. |
| A11 | Exact full-minimal completed rows are already known | The targeted twisted-cubic axis/orbit/incidence/coset-code search found no matching/transversal or matroid-port computation for the union | `minimalProjectiveCubicRepair_full_invariants`, `minimalProjectiveAxisRepair_full_invariants` | **CANDIDATE NOVELTY; NONE FOUND.** Permit “we did not locate,” not a priority claim. Generic rank cutoff and local-primal duality are enabling lemmas, not separate novelty loci. |
| A12 | Rate `1/10` and distance constant `351/1600` are a new AG/LRC bound | Standard concatenation with the same Stichtenoth family gives the arithmetic point | `stichtenoth_projective_q9_uniform_repair_family` | **DERIVED RESULT.** Candidate value lies in the simultaneous exact radius-four profile, not the rate/distance point alone. No endpoint claim. |
| A13 / C214 | The concatenated-dual fiber decomposition or product-sum enumerator is new | Chen--Ling--Xing, IEEE TIT 47 (2001), Theorem 2.3, give the direct-sum dual decomposition; IEEE TIT 51 (2005), Theorem 2.1, recalls it. Coset weight enumerators are classical. | `blockFunctional_mem_functionalDual` proves the coordinate-free forward map; the manuscript identity is an immediate finite fiber partition | **PRIOR ART.** No novelty claim for the decomposition or enumerator identity. |
| A14 / C214 | The roadmap formula `min(2d(I^perp),d_lambda)` is exact without qualifications | A singleton-supported functional-dual word is confined and therefore is not itself a multiblock obstruction. | Weighted sufficiency is checked by `repairHypergraph_concatenatedCode_eq_embed_weighted`; the exact three-case converse is presently a manuscript proof | **CORRECTED.** Use the zero/singleton/multisupport formula generally; the two-term formula is exact when every outer coordinate projection is onto. |
| A15 / C214 | The strict weighted example is only a tailored boundary toy | The inner code is the flagship completed `[20,4,9]_9` seed and the outer code is an `[5,4,2]_{6561}` generalized SPC/MDS code. Singer averaging chooses one monomial coefficient. | Weighted transfer implication is kernel-checked; the orbit average and trace identification are manuscript-level | **SURVIVES, WITH BOUNDARY.** Call it a natural strict finite example, not an asymptotic improvement or a new MDS construction. |
| A16 / C216 | Positive-density realization is a new random-code or AG bound | Random GV, trace duality, AG evaluation/differential codes, and TVZ are standard; locality-preserving concatenation is prior art | Finite pointed cost and transfer are kernel-checked; asymptotic families are manuscript arguments | **DERIVED FRAMEWORK WITH A NONE-FOUND POINTED CONSEQUENCE.** Candidate value is the exact represented-port replication criterion `r+1<z_x(I)`, not the asymptotic coding region. |
| A17 / C219/C226 | Reliability, deletion--contraction, pivotal influence, or bounded EXIT are new invariants | Classical reliability/Boolean-function calculus; Ashikhmin--Kramer--ten Brink for EXIT; standard Tanner stopping-set literature | q9 transforms and coefficients have deterministic script/JSON certificates | **PRIOR MACHINERY; EXACT APPLICATION.** Promote the exact port transforms, cheapest-radius interpretation, and geometric contrast. Do not claim a new reliability polynomial, MAP theorem, capacity bound, or generic stopping-set identity. |
| A18 / C227 | The paper introduces a new pointed repair polynomial | Las Vergnas 1999 literally identifies the one-element set-pointed polynomial with the elementary perspective `M\\x -> M/x`; Mazumdar uses ordinary local-code rank polynomials | q9 full/truncated profiles are independently certified | **PRIOR ART.** Say the full port is a specialization of the standard perspective polynomial. Candidate value is the explicit radius-filtration boundary, not the polynomial. |
| A19 / C218 | The normal-rational-curve nucleus, harmonic quadruples, or Steiner system are new | Gmainer--Havlicek give the nucleus formula; harmonic quadruples and `S(3,4,q+1)` are classical | symbolic manuscript proof plus q9/q27 deterministic circuit replay | **CLASSICAL GEOMETRY; REPAIR INTERPRETATION NONE FOUND.** No priority language. The exact complete radius-four port and positive-density transfer are the candidate contribution. |
| A20 / C219/C244 | The harmonic Poisson window or error bounds are new probability theory | Dependency-graph Poisson approximation and the Arratia--Goldstein--Gordon bound are classical | exact SQS overlap counts and q9/q27 early layers are certified | **CLASSICAL TOOL, EXACT DESIGN APPLICATION.** State the explicit limits and rates; do not call the window sharp in the Friedgut--Kalai sense or infer a random-closure threshold. |
| A21 / C243 | The nucleus gate proves propagation completeness or an asymptotic cascade threshold | The gate compares bounded circuit closure with linear span; those are inequivalent semantics, and the finite q9 switch supplies no asymptotic threshold | exact gate law has a symbolic proof; q9 witness is certified | **FINITE DETERMINISTIC SEPARATION ONLY.** Keep one compact flagship proposition. Exclude SAT-equivalence, propagation-completeness, threshold-location, and sharpness claims. |

## Search boundary

The review checked titles, abstracts, theorem text, and searchable full text where
available along four collision paths:

- **repair tolerance / hitting sets:** “repair tolerance,” “minimum hitting set,”
  “regenerating sets,” intersecting recovery sets, availability, and dual-support
  formulations;
- **concatenation:** locality-preserving concatenation, outer-code selection, dual
  distance, low-weight dual words, parity-check descriptions, and recovery-set
  preservation, including recovery-set separation by dual distance;
- **twisted cubic:** characteristic-three axis, affine/full-axis unions, point/line/plane
  incidence, covering codes, coset weight distributions, and LRC terminology;
- **projective completion:** the full cubic plus common axis, plane sections, projective-system
  codes, matroid ports, radius-four circuits, and exact matching/transversal terminology;
- **rainbow pairing / starters:** properly colored complete graphs, finite-field pair partitions,
  strong starters, constant-quotient and one-quotient starters, and complete mappings;
- **formalization:** theorem statements were compared against the actual Lean declarations
  and the trust manifest; no novelty conclusion was inferred from mechanization.

Primary sources read closely:

- Pamies-Juarez, Hollmann, Oggier, arXiv:1302.5518.
- Wang, Zhang, arXiv:1401.2607.
- Liu, Ma, Wu, Xing, arXiv:2208.04484.
- Jin, Fu, arXiv:2605.04618v1.
- Gruica, Jany, Ravagnani, DOI 10.1007/s10623-026-01829-7.
- Bartoli, Davydov, Marcugini, Pambianco, arXiv:1909.00207.
- Davydov, Marcugini, Pambianco, arXiv:2103.12655 and arXiv:2104.12254.
- Blokhuis, Pellikaan, Szőnyi, arXiv:2103.16904.
- Dinitz, DOI 10.1017/S1446788700024678, especially the one-quotient starter construction.
- Alfaro, Rubio-Montiel, Vázquez-Ávila, arXiv:1609.05496.
- Karasev, Petrov, arXiv:1005.1177.
- Kurz, Yaakobi, arXiv:2001.03433 / DOI 10.1007/s10623-020-00828-6,
  especially Lemma 10(a).
- Stichtenoth, arXiv:math/0506264, Theorem 1.6(ii).

## Paper--Lean adequacy attacks

| Attack | Result |
|---|---|
| “Complete” silently means a hand-selected family | Survived: membership requires an actual dual word and records its exact coefficient support. Supersets with zero coefficients are intentionally not counted; the definition says this explicitly. |
| Matching/transversal numbers are computed on a minimal clutter while the paper claims the full bounded hypergraph | Survived: Lean separately proves invariance under passing to inclusion-minimal edges. |
| The full `q=9` seed has dual distance four | Rejected as a manuscript claim: the 19-coordinate seed has dual distance three because of axis triples. Transfer uses `4 < 2*3`. The separate legacy 10-coordinate `q9InnerCode` has dual distance four and is not substituted for the paper's seed. |
| Radius-three edge counts accidentally include nonminimal supersets | Survived: the displayed `q=9` counts are explicitly labeled inclusion-minimal repairs. |
| The outer gate only transfers one chosen local repair | Survived: Lean proves equality of finite sets of every bounded exact support, then derives matching and transversal corollaries. |
| Extension-field dual distance loses support under trace | Survived: the trace coefficient is unique and zero exactly when the functional is zero, so functional support is preserved coordinatewise. |
| `liminf >= 39/80` does not give the stated eventual constant | Survived: `39/80>19/40` yields eventual `19N<=40D`; the finite lift gives `19N<=40D<=5d`, hence `d/(19N)>=1/5`. |
| Radius-three transfer proves only locality at most three, not the manuscript's exact mixed locality | Survived after strengthening: the generalized theorem transfers radii one, two, and three. It proves existence at radius three/two and nonexistence at radius two/one for cubic/axis coordinates respectively. |
| The displayed `9N,9N,N` multiplicities or `6,11,12` thresholds are prose bookkeeping without formal witnesses | Survived: the coordinate finsets have a kernel-checked disjoint exhaustive partition and exact cardinalities, and a separate theorem computes `tau-1` from each transferred row. |
| Writing `39/190` silently claims the limiting endpoint or a uniform eventual index for all `c` | Rejected by the final statement: it quantifies `forall c<39/190, eventually d/n>c`; the index may depend on `c`, and equality at the endpoint is not asserted. |
| Exact mixed-locality preservation is being inflated into a new contribution independent of complete transfer | Rejected by the novelty ledger: the generic theorem is explicitly classified as a derived API corollary of complete-hypergraph equality at smaller radii. |
| The C104 multiplicative pairing is being presented as a new combinatorial design | Rejected: the manuscript cites the classical one-quotient-starter neighborhood and claims only the shifted-inverse repair application as candidate novelty. |
| “Best possible” silently means necessary for each fixed concatenation | Rejected: the proposition exhibits two codes at the two numerical boundaries and concludes only uniform non-weakenability. It makes no converse claim for a fixed inner/outer pair. |
| A cross-block dual word is asserted without disproving literal hypergraph equality | Survived: each Lean theorem supplies a named repair edge, proves its complete-hypergraph membership, and proves it is absent from the embedded inner hypergraph. |
| “Unconditional” hides a project axiom | Survived after explicit qualification: the ordinary mathematical theorem cites Stichtenoth; the Lean headline has exactly one quarantined literature axiom. |

## Residual gate

This is a defensible internal adversarial review, not an exhaustive priority search.
Before submission, a coding-theory specialist should follow citation chains from
Pamies-Juarez--Hollmann--Oggier, Wang--Zhang, Liu--Ma--Wu--Xing,
Gruica--Jany--Ravagnani, and Jin--Fu in MathSciNet/zbMATH/IEEE Xplore, with special
attention to duals of concatenated codes, robust/overall repair tolerance, and whether the
exact complete-hypergraph boundary proposition has appeared under different terminology.

That residual gate affects priority confidence, not the mathematical validity or the
Lean trust boundary. Until it is complete, the manuscript's strongest allowed novelty
language is “candidate contribution” and “we did not locate.”
