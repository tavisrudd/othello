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
| D1 | Complete radius-`r` repair hypergraph; matching `nu`; transversal `tau`; minimal-clutter invariance | `KERNEL` | `FiniteGeom.repairHypergraph`, `minimalRepairHypergraph`; `matchingNumber`, `transversalNumber`; `matchingNumber_minimalRepairHypergraph_of_dualDist`, `transversalNumber_minimalRepairHypergraph` | Definitions use actual dual-word supports, not selected recovery groups. |
| T1 | The axis--twisted-cubic code is `[2q+1,4,q-1]_q` in finite characteristic three | `KERNEL` | `FiniteGeom.axisTwistedCubic_code_parameters` | The paper's projective description uses the same displayed columns as Lean. |
| T2 | Small circuits are axis triples or a unique three-cubic/one-axis completion; axis locality is exactly two and cubic locality exactly three | `KERNEL` | `RepairCodes.mem_cubicRepairHypergraph_iff`, `mem_axisRepairHypergraph_two_iff`, `cubicCoordinate_exact_locality_three`, `axisCoordinate_exact_locality_two` | The circuit-to-repair bridge is also checked in `FiniteGeom.Repair`. |
| T3 | Uniform formulas/bounds and `tau_i>nu_i` for every coordinate when `q>=9` | `KERNEL` | `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_matchingNumber_lower`, `cubicRepair_matchingNumber_le`, `cubicRepair_transversalNumber`, `axisTwistedCubic_allSymbol_tau_gt_nu` | `Z_3(q)` is defined semantically as the maximum zero-sum-free/cap size; the strict gap itself needs no external cap-set estimate. |
| T4 | At `q=9`, exact rows `(4,7)`, `(6,12)`, `(7,13)`, with minimal-repair counts `28`, `36+8`, `36+12` | `KERNEL` | `axisTwistedCubic_q9_row_invariants`, `cubicRepair_edge_count_q9`, `axisRepair_component_edge_counts_q9` | Coordinate multiplicities are `9`, `9`, and `1`. |
| T5 | Exact complete repair-hypergraph transfer under `r+1 < 2d(I^perp)` and outer functional-dual distance at least `r+2` | `KERNEL` | `repairHypergraph_concatenatedCode_eq_embed`; matching/transversal corollaries in `RepairCodes.SeedLift` | Stronger than locality preservation: equality holds for every bounded dual-support repair set. |
| T6 | Finite-separable trace bridge from ordinary extension-field dual distance to the functional-dual gate, with exact support | `KERNEL` | `traceCoefficient_mem_dualCode`, `functionalWeight_traceCoefficient`, `hasFunctionalDualDistanceAtLeast_restrictScalars` | No coding-theory decomposition is imported. |
| T7 | Degree-four lift has `[19N,4K,>=8D]_9`, locality three, and exact row transfer when `d(O^perp)>=5` | `KERNEL` | `q9ExtensionLiftCode_parameters`, `q9ExtensionLiftCode_repairHypergraph`, `q9ExtensionLiftCode_allSymbol_locality_three`, `q9ExtensionLiftCode_row_invariants` | Ordinary `GF(9^4)`-linear outer code; restriction of scalars is explicit. |
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

## Release checks

- [x] Tectonic succeeds without citation/reference/box warnings and the PDF is regenerated.
- [x] `lake build RepairCodes` succeeds under the OOM-safe wrapper.
- [x] forbidden-token scan is empty outside `Imported.lean`'s single `axiom`.
- [x] manuscript theorem statements agree with the declarations above.
- [x] internal adversarial novelty review completed and all surviving novelty language synchronized.
- [x] papers index, planning registry, handoff, and C97 queue entry synchronized.
- [ ] external specialist citation-chain review completed (submission preflight; not a theorem gate).
