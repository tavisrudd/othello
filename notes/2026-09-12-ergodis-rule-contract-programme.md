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

Two asks to him gate the benchmark and adapter choices:

1. One concrete program he runs today, with data size and the tool it runs on.
2. Whether his Lean model has a semantics layer (a category of programs with a cost or semiring
   functor) that an Ergodis contract stated in Lean could be instantiated against.

Literature basis: `2026-09-12-c1150-category-theory-for-ergodis.md`,
`2026-09-12-c1151-category-theory-capability-pass.md`,
`2026-09-12-relationalai-datalog-reading.md` (0-stability of bounded min-plus, confirmed against
the verifier code in `2026-09-12-c1152-certificate-spike.md`). Discovery-track entry:
`ergodis-discovery-track.md`, 2026-09-12 Macready lead.

## Sequence

| Step | Task | What it delivers | Location |
|---|---|---|---|
| 1 | C1160 | stability class and ⊖ on the verifier weight type; leaf-delta as an explicit semi-naive step over DAGs and cycles | core `crates/verify` |
| 2 | C1163 | the rule/fixpoint/certificate contract, IR-agnostic, stated in Lean under this monorepo's `lean/`; serialization through the existing C ABI; MLIR dialect as optional adapter; one recursive program lowered end to end | core; Lean authority here |
| 3 | C1161 | recursive plan queries as least fixpoints with the N-step bound and semi-naive incremental recomputation | core runtime |
| 4 | unallocated | join engine: worst-case-optimal joins (Generic Join / Free Join) as the rule-body operator | core |
| 5 | unallocated | benchmark suite: transitive closure, shortest paths, bill-of-materials over lifted reals, an einsum program, one exact-cover problem; comparators Soufflé, egglog, einsum, CP-SAT; protocol as in `2026-09-11-ergodis-external-benchmark-programme.md`; reshaped by Macready's named workload | harness private, results in `ergodis-evidence` |
| 6 | C1162 | FGH-square discharge of leaf lowering by counterexample-guided synthesis on the C1091 fixtures; mechanism core, each discharged family private | core + private |
| 7 | C1158 | acting-subgroup measurement on the two-transfer census; if it pays, a generic group-action / canonical-form trait in core so the contract can carry a symmetry declaration | private task crate, then core |

Steps 4 and 5 are allocated after C1163's first program shows where join cost lands and after
Macready names a workload. Step 7 can run at any time; it is cheap and independent.

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
