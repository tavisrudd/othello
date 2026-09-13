# Ergodis and Lean automation: integration boundary

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: programme closeout; no new implementation task allocated.

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
general; the private finite privacy instance is checked separately by Rust and
an independent Python oracle. Its JSON certificate is not yet imported into
Lean. Likewise, these results do not formally verify the Rust implementation.

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

Reports: `2026-09-12-c1161-recursive-runtime.md`,
`2026-09-12-c1162-leaf-lowering-square.md`,
`2026-09-12-c1158-acting-subgroup.md`, and the prior
`2026-09-12-c1164-lean-oracle.md`.

All three tasks in the timed continuation are closed and committed. C1158's
experiment remains on its isolated branch; its q18 action does not justify
promotion into the live paired census. The latter admits no ambient-orbit
reduction in the measured domain.

Closeout process note: a redundant full handoff display exceeded the 10,000-token
command-output cap after compaction. The truncated display was not used as new
evidence; subsequent review used bounded programme and source excerpts.
