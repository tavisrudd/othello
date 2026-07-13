# Adversarial novelty review

**Audit date:** 2026-07-13

**Object:** *Complete repair hypergraphs under concatenation: a twisted-cubic--axis family*
**Rule:** a none-found search is evidence for cautious positioning, never a priority
certificate. Lean establishes correctness of formal statements, not novelty.

## Bottom line

The candidate novelty survives in two narrow places:

1. the exact coordinatewise matching/transversal calculations for the
   characteristic-three affine-twisted-cubic plus full-axis code, including
   strict `tau > nu` at every coordinate for `q >= 9`; and
2. equality of the complete bounded dual-support repair hypergraph under
   concatenation, under the stated inner and outer dual-distance gates.

The fixed-alphabet asymptotic family is a formal corollary joining those two
ingredients to a published self-dual TVZ family. Its ordinary rate/distance/locality
mechanism is not positioned as independently novel; its candidate contribution is
the exact blockwise repair-hypergraph data that survives at unbounded length.

One novelty claim failed review and was corrected: Pamies-Juarez--Hollmann--Oggier
explicitly define the minimum hitting set of all bounded dual repairs as *local repair
tolerance*. The manuscript no longer calls the transversal interpretation implicit or
suggests that the invariant itself is new. The unsupported adjective “sharp” was also
removed from the block-confinement hypothesis.

## Claim ledger

| ID | Claim under attack | Closest checked prior art | Lean evidence | Verdict / permitted wording |
|---|---|---|---|---|
| A1 | Repair robustness is the transversal number of all bounded repair supports | Pamies-Juarez--Hollmann--Oggier, arXiv:1302.5518, Definition 3, gives exactly the minimum hitting-set formula as local repair tolerance; Wang--Zhang, arXiv:1401.2607, gives a general regenerating-set/tolerance framework | `FiniteGeom.transversalNumber` and repair-hypergraph definitions formalize the invariant | **PRIOR ART.** Say that `tau-1` is the guaranteed failure threshold under the paper's convention, but do not claim the invariant or interpretation as new. |
| A2 | Treating all low-weight dual supports, rather than a selected repair group, is new | Gruica--Jany--Ravagnani, DOI 10.1007/s10623-026-01829-7, define refined weight distributions indexed by prescribed subsets of dual supports and use them to capture locality | `FiniteGeom.repairHypergraph` contains exact distinct coefficient supports, not dual-word multiplicities | **PRIOR/ADJACENT.** The exact support hypergraph is a useful formulation, but “all dual supports” alone is not a novelty claim. |
| A3 | Exact `(nu,tau)` rows and all-symbol `tau>nu` for the twisted-cubic--axis family are known | Checked twisted-cubic orbit/incidence/coset sources: arXiv:1909.00207, 2007.08798, 2103.12655, 2103.16904, 2104.12254, and their cited geometry context. These classify axes, orbits, incidences, covering data, or coset weights; no checked source states the repair matchings/transversals or the all-symbol separation | `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_transversalNumber`, matching bounds, and `axisTwistedCubic_allSymbol_tau_gt_nu`; the `q=9` rows are separately kernel-checked | **CANDIDATE NOVELTY; NONE FOUND.** Use “we did not locate,” never categorical “first.” Geometry and the characteristic-three axis remain explicitly prior art. |
| A4 | Locality-preserving concatenation and asymptotically good concatenated LRCs are new | Liu--Ma--Wu--Xing, arXiv:2208.04484, Theorem 3.1 and 3.3; Jin--Fu, arXiv:2605.04618, constructs binary LRCs from `GF(4)` outer codes and a `[3,2,2]` inner code | Parameter lift and distance are checked in `RepairCodes.SeedLift` and `Q9ExtensionLift` | **PRIOR ART.** Do not claim novelty for concatenation, locality preservation, or ordinary concatenated distance/rate. |
| A5 | Complete bounded repair-support equality under concatenation is already stated | Liu et al. prove existence of inherited inner repairs/locality. Jin--Fu analyze locality, parity checks, distance, and weight distributions. The checked sources do not classify every low-weight dual support, impose the functional outer-dual gate, or transfer matching/transversal data | `repairHypergraph_concatenatedCode_eq_embed` proves literal finite-hypergraph equality from exact dual supports; trace reduction is `hasFunctionalDualDistanceAtLeast_restrictScalars` | **CANDIDATE NOVELTY; NONE FOUND.** Describe it as a stronger conclusion under an additional gate. The elementary block-confinement idea may be independently rediscoverable, so claim the theorem/formulation cautiously, not the underlying algebra as categorically unprecedented. |
| A6 | The trace representation or restriction-of-scalars duality is new | Standard finite-separable trace-pairing mathematics | `traceCoefficient_mem_dualCode`, `functionalWeight_traceCoefficient`, and `hasFunctionalDualDistanceAtLeast_restrictScalars` | **PRIOR MATHEMATICS.** The bridge is a proved enabling lemma, not a standalone novelty claim. |
| A7 | The `GF(9)` asymptotic rate/distance constants are an independently new LRC bound | Liu et al. already use AG outer codes and concatenated inner LRCs to obtain asymptotically good families. Stichtenoth supplies the self-dual TVZ family | `stichtenoth_q9_uniform_repair_family` checks the reduction from one imported literature theorem | **DERIVED RESULT.** Candidate value lies in simultaneous exact repair rows plus fixed alphabet and positive rate/distance, not in the generic existence of asymptotically good LRCs. |
| A8 | Formal verification proves novelty | No literature source can be excluded by a Lean proof | All theorem boundaries and the sole imported axiom are explicit | **REJECTED INFERENCE.** Lean is evidence of correctness and trust-boundary discipline only. |
| A9 | The condition `r+1 < 2 d(I^perp)` is globally sharp | No necessity theorem or counterexample family is proved in the manuscript or Lean | Lean proves sufficiency | **NOT ESTABLISHED.** The word “sharp” is removed. |

## Search boundary

The review checked titles, abstracts, theorem text, and searchable full text where
available along four collision paths:

- **repair tolerance / hitting sets:** “repair tolerance,” “minimum hitting set,”
  “regenerating sets,” intersecting recovery sets, availability, and dual-support
  formulations;
- **concatenation:** locality-preserving concatenation, outer-code selection, dual
  distance, low-weight dual words, parity-check descriptions, and recovery-set
  preservation;
- **twisted cubic:** characteristic-three axis, affine/full-axis unions, point/line/plane
  incidence, covering codes, coset weight distributions, and LRC terminology;
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
| `liminf >= 39/80` does not give the stated eventual constant | Survived: `39/80 > 1/3` yields eventual `N <= 3D`; the finite lift then gives `d/(19N) >= 8/57`. |
| “Unconditional” hides a project axiom | Survived after explicit qualification: the ordinary mathematical theorem cites Stichtenoth; the Lean headline has exactly one quarantined literature axiom. |

## Residual gate

This is a defensible internal adversarial review, not an exhaustive priority search.
Before submission, a coding-theory specialist should follow citation chains from
Pamies-Juarez--Hollmann--Oggier, Wang--Zhang, Liu--Ma--Wu--Xing,
Gruica--Jany--Ravagnani, and Jin--Fu in MathSciNet/zbMATH/IEEE Xplore, with special
attention to duals of concatenated codes and robust/overall repair tolerance.

That residual gate affects priority confidence, not the mathematical validity or the
Lean trust boundary. Until it is complete, the manuscript's strongest allowed novelty
language is “candidate contribution” and “we did not locate.”
