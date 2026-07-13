# Proof and claim ledger

**Paper:** *Complete repair hypergraphs under concatenation: a twisted-cubic--axis family*

**Ledger rule:** every mathematical assertion promoted to theorem/corollary status in the paper
must appear below with its exact formal boundary. Context and novelty claims are listed separately
so that they cannot be mistaken for kernel-checked mathematics.

## Status vocabulary

| Status | Meaning |
|---|---|
| `KERNEL` | Lean-checked; only `propext`, `Classical.choice`, and `Quot.sound` may appear in the axiom report. |
| `IMPORTED-1` | Lean-checked consequence of the one named Stichtenoth literature axiom, plus the standard logical axioms. |
| `LITERATURE` | Context or provenance taken from a cited source; not part of the Lean proof chain. |
| `PRIOR-ART` | A checked source already contains the concept or result; no novelty is claimed. |
| `NONE-FOUND` | A bounded adversarial search found no collision; this is not a priority certificate. |
| `REVIEW-GATE` | Work still required for submission confidence, not a mathematical or formalization blocker. |

## Mathematical ledger

| ID | Paper claim | Status | Lean declaration(s) | Boundary / notes |
|---|---|---|---|---|
| D1/P1 | Complete radius-`r` repair hypergraph; matching `nu`; transversal `tau`; `nu<=tau`; minimal-clutter invariance; exact edge size below dual distance | `KERNEL` | `FiniteGeom.repairHypergraph`, `minimalRepairHypergraph`; `matchingNumber`, `transversalNumber`, `nu_le_tau`, `matchingNumber_minimalHyperedges`, `transversalNumber_minimalHyperedges`, `repair_edge_card_eq_of_dualDist` | Definitions use actual dual-word supports, not selected recovery groups. Matching invariance assumes every edge is nonempty, exactly as stated in the paper. |
| T1 | The axis--twisted-cubic code is `[2q+1,4,q-1]_q` in finite characteristic three | `KERNEL` | `FiniteGeom.axisTwistedCubic_code_parameters` | The paper's projective description uses the same displayed columns as Lean. |
| T2 | Small circuits are axis triples or a unique three-cubic/one-axis completion; axis locality is exactly two and cubic locality exactly three | `KERNEL` | `twistedCubicTriple_isFourCircuit`, `twoCubicTwoAxis_linearIndependent`; `RepairCodes.mem_cubicRepairHypergraph_iff`, `mem_axisRepairHypergraph_two_iff`, `cubicRepair_threeCubic_not_mem`, `cubicRepair_oneCubic_twoAxis_not_mem`, `cubicRepair_threeAxis_not_mem`, `cubicCoordinate_exact_locality_three`, `axisCoordinate_exact_locality_two` | The circuit-to-repair bridge is also checked in `FiniteGeom.Repair`; the cited positive and exclusion declarations cover every size-at-most-four type. |
| T3 | Uniform formulas/bounds and `tau_i>nu_i` for every coordinate when `q>=9` | `KERNEL` | `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_matchingNumber_lower`, `cubicRepair_matchingNumber_le`, `cubicRepair_transversalNumber`, `axisTwistedCubic_allSymbol_tau_gt_nu` | `Z_3(q)` is defined semantically as the maximum zero-sum-free/cap size; the strict gap itself needs no external cap-set estimate. |
| T4 | At `q=9`, exact rows `(4,7)`, `(6,12)`, `(7,13)`, with minimal-repair counts `28`, `36+8`, `36+12` | `KERNEL` | `axisTwistedCubic_q9_row_invariants`, `cubicRepair_edge_count_q9`, `axisRepair_component_edge_counts_q9` | Coordinate multiplicities are `9`, `9`, and `1`. |
| T4a | At `q=9`, the small-circuit support inventory is `120` axis triples and `84` completed cubic quadruples | `KERNEL` | `q9_smallCircuit_support_counts` | Counts distinct supports, not coefficient-scaled dual words. |
| T4b | Every `q=9` coordinate satisfies `7*nu<=4*tau`, with equality at every cubic coordinate | `KERNEL` | `axisTwistedCubic_q9_ratio`, `axisTwistedCubic_q9_row_invariants` | The equality statement is the cubic row `(4,7)`. |
| T5 | Exact complete repair-hypergraph transfer under `r+1 < 2d(I^perp)` and outer functional-dual distance at least `r+2` | `KERNEL` | `repairHypergraph_concatenatedCode_eq_embed`; matching/transversal corollaries in `RepairCodes.SeedLift` | Stronger than locality preservation: equality holds for every bounded dual-support repair set. |
| T6 | Finite-separable trace bridge from ordinary extension-field dual distance to the functional-dual gate, with exact support | `KERNEL` | `traceCoefficient_mem_dualCode`, `functionalWeight_traceCoefficient`, `hasFunctionalDualDistanceAtLeast_restrictScalars` | No coding-theory decomposition is imported. |
| T7 | Degree-four lift has `[19N,4K,>=8D]_9`, all-symbol locality at most three, and exact row transfer when `d(O^perp)>=5` | `KERNEL` | `q9ExtensionLiftCode_parameters`, `q9ExtensionLiftCode_repairHypergraph`, `q9ExtensionLiftCode_allSymbol_locality_three`, `q9ExtensionLiftCode_row_invariants` | Ordinary `GF(9^4)`-linear outer code; restriction of scalars is explicit. |
| T8 | Unbounded `GF(9)` family with exact rate `2/19`, eventual relative distance `>=8/57`, and exact rows | `IMPORTED-1` | `HasQ9UniformRepairFamily`, `stichtenoth_q9_uniform_repair_family`, `concrete_q9_uniform_repair_family` | Sole nonformalized input: `Imported.stichtenoth_selfDual_TVZ_6561`. The analytic extraction and concrete field embedding are kernel-checked. |

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
| N1 | No checked source was found that proves complete bounded repair-hypergraph equality under an outer dual-distance gate | `NONE-FOUND` | Surviving bounded-search conclusion only; manuscript says “we did not locate,” never an unconditional “first.” |
| N2 | No checked twisted-cubic incidence/covering source was found to compute these coordinatewise `(nu,tau)` rows or prove all-symbol `tau>nu` | `NONE-FOUND` | Geometry and incidence counts are prior art; only the exact repair-invariant computation is positioned as a candidate contribution. |
| N3 | Formalization novelty is separate from mathematical novelty | `PRIOR-ART` | Lean certification strengthens trust and exposes boundaries; it is not used as evidence that a theorem is new. |
| N4 | The asymptotic theorem is a derived candidate result, not a claim that AG concatenation itself is new | `NONE-FOUND` | Candidate value is simultaneous fixed-alphabet positive rate/distance plus exact blockwise repair rows. |
| G1 | Specialist citation-chain review in MathSciNet/zbMATH/IEEE Xplore | `REVIEW-GATE` | Submission preflight only; it does not block the mathematical theorem chain or internal manuscript assembly. |

## Consistency and release checklist

Last full pass: 2026-07-13. A checked box records a direct source, Lean, or build comparison, not
an impressionistic reread.

### Mathematical statements

- [x] Definitions of complete repair hypergraph, matching, transversal, and minimal clutter agree
  with `FiniteGeom.Repair` and `FiniteGeom.Hypergraph`.
- [x] Seed parameters, coordinate multiplicities, exact localities, circuit types, repair counts,
  and all three `q=9` rows agree with the corresponding Lean declarations.
- [x] Uniform axis formulas, cubic bounds, the `q>=9` range, and the distinction between exact
  values and bounds agree with `AxisTwistedCubicInvariants.lean`.
- [x] The transfer theorem is stated only as a sufficient result under
  `r+1 < 2*d(I^perp)` and functional-dual distance at least `r+2`; no sharpness or necessity claim
  remains.
- [x] The finite lift uses the full `[19,4,8]_9` seed, its actual dual distance three, outer ordinary
  dual distance at least five, and parameters `[19N,4K,>=8D]_9`.
- [x] The asymptotic arithmetic is synchronized: extension degree four, outer field size `6561`,
  source bound `39/80`, eventual `N<=3D`, rate `2/19`, and relative distance `>=8/57`.
- [x] Lifted locality is phrased as “at most three,” matching the formal headline declaration;
  exact locality two/three is reserved for the finite inner seed where it is explicitly proved.

### Formal trust and source boundary

- [x] Every theorem/corollary promoted in the manuscript has a declaration and status row above.
- [x] `lake build RepairCodes` succeeds under the OOM-safe wrapper.
- [x] The forbidden-token scan is empty outside `Imported.lean`'s single `axiom`.
- [x] Finite/algebraic theorem axiom reports contain only the allowed standard logical axioms.
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
- [x] Surviving novelty language is limited to “candidate contribution” / “we did not locate”; no
  unconditional priority or “first” claim remains.
- [x] The legacy `[10,4,6]_9` seed is marked registry/library-only and is not substituted for the
  manuscript's `[19,4,8]_9` seed.
- [x] README, paper index, planning registry, handoff, C97, and C98 use the same trust and novelty
  posture.
- [x] Tectonic succeeds without citation, reference, or box warnings and the PDF is regenerated.
- [ ] External specialist citation-chain review completed (submission preflight; not a theorem or
  formalization gate).
