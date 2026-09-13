# Ergodis and Lean automation: integration boundary

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: C1165–C1168 complete; external IR/workload gate remains.

The useful fit is a specialized certificate producer inside a Lean proof workflow.
C1164 supplies the concrete bridge; C1162 now demonstrates symbolic automation
around the lowering law. Keep that boundary when a real IR instance arrives.

## What the roadmap establishes

The [Lean FRO Year 4, Part 1 roadmap](https://lean-lang.org/fro/roadmap/y4-1/),
read 2026-09-13 UTC, covers September 2026–February 2027. It plans closer
`grind`/`bv_decide` integration, faster informative failure, and expanded
interactive `grind =>` / `sym =>` modes. It also describes continued `SymM`
work for verification tooling and planned independent kernel-checking commands.
These are roadmap commitments, not a versioned plugin API or evidence that
every item ships in Lean 4.35. This work does not change the pinned toolchain.

## Concrete division of work

| Obligation | Current or appropriate owner | Evidence boundary |
|---|---|---|
| Interpret the external IR and define its transition semantics | The IR frontend, with a supplied formal program and lowering map | An Ergodis certificate cannot establish that the frontend modeled its source correctly |
| Find a recursive min-plus solution | Ergodis's native/WASM producer | C1161 adds sparse propagation and checked mutable sessions |
| Prove the supplied program has the returned least fixed point | C1164 reflective Lean checker, invoked by `ergodis_solution` | The external provider supplies witness data; ordinary kernel-checked proof terms establish the theorem |
| Establish symbolic lowering and transport across event traces | C1162 `EventLowering` theorems and ordinary Lean automation | `grind` already closes fiber compatibility and uniqueness glue |
| Discharge an actual fixed-width implementation obligation | Candidate future `bv_decide` use | Requires a specified bit-vector statement and a proved connection to the mathematical contract |

The C1162 square is `G(F(x,e)) = H(G(x),e)`. Once supplied, the trace theorem
transports it to finite event sequences. The span instance is symbolic and
general. C1166 now imports the private finite privacy certificate into a private
Lean instance, checks both event squares and their physical-world semantics,
and proves the fifteen-state readout bound minimal. Rust and the independent
Python oracle remain separate checks. These results do not formally verify Rust.
The universal scalar N-round convergence theorem is now proved in
`lean/WeightedRules/Convergence.lean`,
`WeightedRules.boundedMinPlus_iterate_fixed` (C1165), with sharpness for every
positive scalar count and reflective certificate completeness. Private finite
semantics and exact trust coverage are recorded in
`2026-09-12-c1166-privacy-lowering-reflection.md`.

The current oracle also has a workflow limit: its synchronous local subprocess
has no timeout or isolation, and Lean enforces the output-size limit after
capture. A future interactive automation adapter needs an explicit resource
policy before claiming the roadmap's fast-failure behavior.

C1167 adds a checked incremental proof route: `ergodis_improvement` reuses an
old checked solution when rules are identical and facts improve, then checks
bounded synchronous replay and fixedness. The result converts to the existing
`CheckedSolution` by proof. Actual chained distance witnesses and paired proof
checking measurements are recorded in `2026-09-12-c1167-incremental-proof-checking.md`.
The producer still solves its supplied source independently; no runtime update
policy or source-interpretation authority changes.

C1168 proves a tighter uniform bound, `min N (M + 1)`, with M the number of
distinct rule outputs. It also applies to replay from a safe seed and supports
an optional conversion of existing checked solutions. Immutable input scalars
need not inflate M. This strengthens the backend's mathematical contract using
ordinary Lean proofs; it requires no automation-engine API change.

`bv_decide` could become useful for a packed representation, a mask operation,
or a bounded arithmetic encoding. No such proof obligation is needed for the
current symbolic square. Encoding min-plus arithmetic as machine words would
first require explicit infinity, overflow and representation semantics.

## Next gate

Obtain one concrete IR obligation or workload: its source semantics, proposed
lowering map, target theorem, expected sizes, and current execution/proof route.
Then instantiate the existing contract and measure producer time, certificate
size and Lean checking time separately. Add an automation adapter only where
that example identifies a repeated step and the pinned Lean API supports it.
The join engine and broader comparator suite remain unallocated; the deferred
speed/hygiene tasks remain deferred.

The trust-side roadmap is compatible with this direction: retained proof terms
can be checked independently when the guarded build tooling supports the new
commands. No new command was run or validation gate weakened in this session.

## Durable evidence and session disposition

The first continuation closed C1161, C1162 and C1158. C1158's experiment remains
on its isolated branch; its q18 action does not justify promotion into the live
paired census. The latter admits no ambient-orbit reduction in the measured domain.

The second continuation completes the proof sequence: universal
convergence (C1165), the private finite privacy instance and minimality (C1166),
checked incremental witnesses (C1167), and the output-sensitive bound (C1168).
Reports are the corresponding dated `2026-09-12-c1165-min-plus-convergence.md`,
`2026-09-12-c1166-privacy-lowering-reflection.md`,
`2026-09-12-c1167-incremental-proof-checking.md`, and
`2026-09-12-c1168-rule-output-bound.md`.
The C1167 proof-checking measurements remain pinned to monorepo `7798d342d`;
later proof changes do not carry a newly measured speed claim.

Closeout process note: a redundant full handoff display exceeded the 10,000-token
command-output cap after compaction. The truncated display was not used as new
evidence; subsequent review used bounded programme and source excerpts.
