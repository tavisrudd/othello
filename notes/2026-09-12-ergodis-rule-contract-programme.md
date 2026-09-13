# Ergodis rule-contract programme

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: ACTIVE programme map; tasks allocated as listed, two still unallocated.

## Goal

Broaden Ergodis from acyclic exact optimization over supplied structure to recursive exact
optimization with a declarative rule input, a termination guarantee, and a certificate, so that
an external compiler can target it as a backend and it is measurably faster than the tools that
compiler's author would otherwise use. Speed and hygiene work on the current engine is deferred
behind this.

## Motivation and external context

William Macready (Tavis's contact, correspondence 2026-09-12) is building a categorical IR that
marries Abbott–Zardini-style compilation of fused operations to tensor logic (einsum-syntax
Datalog) as an external syntax, with a foundation that represents symmetries, generalized
tensors, predicate logic and tensor networks. His stack is private and post-RelationalAI: the
published RelationalAI line (`datalog°`, Free Join, Rel) is a floor for what he uses, not his
stack. He is modelling the IR in Lean; parts may use MLIR; whether the IR is his own is unclear.

Three asks to him gate the benchmark and adapter choices:

1. One concrete program he runs today, with data size and the tool it runs on.
2. Which questions about his IR he currently axiomatizes or proves by hand (canonical forms,
   rewrite existence, minimality of a lowering, counterexamples to a law) and would rather
   have decided by an oracle with a checked certificate.
3. Whether his Lean model has a semantics layer (a category of programs with a cost or semiring
   functor) that an Ergodis contract stated in Lean could be instantiated against.

Alvaro line (CALM/Bloom^L versus datalog° stability; Molly's provenance as PosBool GKT semiring): `2026-09-12-alvaro-datalog-reading.md`. Literature basis: `2026-09-12-c1150-category-theory-for-ergodis.md`,
`2026-09-12-c1151-category-theory-capability-pass.md`,
`2026-09-12-relationalai-datalog-reading.md` (0-stability of bounded min-plus, confirmed against
the verifier code in `2026-09-12-c1152-certificate-spike.md`). Discovery-track entry:
`ergodis-discovery-track.md`, 2026-09-12 Macready lead.

## Sequence

| Step | Task | What it delivers | Location |
|---|---|---|---|
| 1 (complete) | C1160 | scalar stability and ⊖; semi-naive DAG/cycle checking with full replay for retractions; native/Python/WASM compilation gates pass | core `crates/verify`; `2026-09-12-c1160-verifier-stability.md` |
| 2 (complete) | C1163 | the rule/fixpoint/certificate contract, IR-agnostic, stated in Lean under this monorepo's `lean/`; serialization through the existing C ABI; MLIR dialect as optional adapter; one recursive program lowered end to end | core; Lean authority here |
| 2b (complete) | C1164 | Ergodis as a Lean oracle: tactic/IO call, reflective Lean checker for the min-plus certificate, proof terms of optimality and least fixpoint; the first artifact to show Macready, since a Lean-modelled IR consumes it directly and it needs no benchmark | core C ABI + Lean under `lean/` |
| 3 (complete) | C1161 | recursive plan queries as least fixpoints with the N-step bound and semi-naive incremental recomputation | core runtime |
| 4 | unallocated | join engine: worst-case-optimal joins (Generic Join / Free Join) as the rule-body operator | core |
| 5 | unallocated | benchmark suite per `2026-09-12-datalog-benchmark-suites.md`: TC and SG (Boolean), SSSP and CC (min-plus), MLM over recursive trees (lifted reals, no cross-engine baseline exists), TC over the counting semiring, exact cover vs CP-SAT, and lineage-driven minimum-fault search over Molly's `ack-deliv` protocol (minimum hitting set of the proof-tree hypergraph with an exclusion certificate; capability row, no published speed baseline; `2026-09-12-alvaro-datalog-reading.md`); local comparators Soufflé and egglog; RecStep, BigDatalog, DDlog, Umbra, VLog, RDFox, Rel citation-only (VFLog table is the only fully versioned one; FlowLog is broadest but unversioned; Rel has no published numbers); protocol as in `2026-09-11-ergodis-external-benchmark-programme.md`; reshaped by Macready's named workload | harness private, results in `ergodis-evidence` |
| 6 | C1162 | FGH-square discharge of leaf lowering by counterexample-guided synthesis on the C1091 fixtures; mechanism core, each discharged family private | core + private |
| 7 | C1158 | acting-subgroup measurement on the two-transfer census; if it pays, a generic group-action / canonical-form trait in core so the contract can carry a symmetry declaration | private task crate, then core |

Steps 4 and 5 are allocated after C1163's first program shows where join cost lands and after
Macready names a workload. Step 7 can run at any time; it is cheap and independent.

C1161 is complete (`2026-09-12-c1161-recursive-runtime.md`). C1162 is the next
allocated independent task while join/benchmark allocation awaits the concrete workload. C1163 completed the finite relational contract and portable provider
(`2026-09-12-c1163-rule-contract.md`); C1164 adds a live Lean oracle, proved checker
and kernel-checked least-fixpoint proof (`2026-09-12-c1164-lean-oracle.md`). C1161 now supplies recursive and incremental runtime with a real campaign readout. Scalar 0-stability counts all tuple coordinates,
and retractions retain a separate sound policy. General automation integration
(grind/bv_decide/SymM) should follow a concrete IR obligation; the checked proof route
is reusable and the discussion does not reorder the programme.

## Placement rule

The dependency direction is one way: `ergodis-private` depends on the core. Anything the contract
exposes or any operator a contract program needs lives in the core. Family-specific instances,
providers, Evolve policy and task crates stay private. Benchmark results and replay bundles go to
the evidence repository. The public export (C1149) grows by the contract, the verifier
generalisation and the join engine; the export lint must absorb them.

## Deferred

C1154 (FeatureDag interval and acyclicity), C1155 (sentinel, weight pushing, partition
refinement), C1156 (Evolve ordering), C1157 (equality saturation), C1159 (one-probe screen) are
speed and hygiene on the current engine. Pull C1155's sentinel fix forward only if C1163 needs
canonical summaries. C1148 (certificate interoperability) is unchanged.

## Invariants

- Gradient, small-model and GPU components may order, bound or propose; they never certify.
- No evidence claim, certificate authority or default path changes without its own gate.
- Prior art informs, never gates.
- The saturating `u32::MAX` sentinel is a declared precondition on total cost for fixpoints; it
  blocks weight pushing only.
