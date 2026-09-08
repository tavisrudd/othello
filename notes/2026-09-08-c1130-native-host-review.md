# C1130 — Native non-GF(2) execution interface review

**Lane**: `ergodis`
**Date**: 2026-09-08
**Scope**: read-only current source/contract review, not a new runtime or benchmark
result. Performance contract and shared playbook loaded in full earlier this session.

## Central correction

The native product is not implemented by sending all problems through the bounded
portable CampaignSession. It has several execution/control surfaces. The existing
browser package exposes only some of them. A field selector on CampaignSpec would
not recover native feature parity, and the current RS(12,8) GF(256) visualization
is not itself an existing native recovery request contract.

## Native entry-to-result paths

Paths below are relative to `~/src/ergodis` unless marked private.

| Surface | Input, execution and returned meaning |
|---|---|
| `ergodis compose` | `src/bin/ergodis.rs:176,571,623`: JSON supplies legacy prime or tagged field, shaped inner labels/costs, separately shaped outer blocks and target. Cold dispatch selects `Prime<2/3/5/7/11/13>` or `Gf4` with modulus [1,1,1]. Matrix/CostTable validate field presentation. `CompositionTable::compose_field<F>` or parallel variant compiles; `answer_field<F>` reconstructs local labels and cost. Output includes feasibility, compiled-label count and transitions. |
| `transfer`, `transfer-subspace`, `transfer-tower` | Native CLI frontends currently specialize represented binary-inner recovery over GF(4), with base GF(2). Compile coefficient/target-normalized cost tables, compose/constrain outer blocks, and lift returned labels into coefficient witnesses. Tower replay expands the witness tree under an explicit node budget. Not just a GF(2) outer solve, and not arbitrary GF(256). |
| `schedule` | Capacities plus per-demand families of load vectors and optional positive grading compile a `WeightedRepairProblem`. Cold adaptive backend selection chooses sparse Pareto or dense lattice; sequential/parallel solve returns served count, concrete load assignments, unmatched demands, total loads and work counters. This is repair allocation, not FT10 job-shop makespan scheduling. |
| `application` / Ceph | Recursive XOR layers/patterns plus target/unavailable coordinates compile supports, or a compressed family with exact reliability counts. Resource mapping/capacities aggregate the family into scheduler options; returned assignments recover representative supports. Arithmetic of encoding and resource optimization are separate stages. |
| `application` / Azure LRC | Nine capacities and demand count dispatch to the existing counted-load-types LRC(12,2,2) kernel. Returns repaired count, mode counts, total loads and work. It optimizes a known repair model rather than receiving a generic field matrix or recovering user bytes. |
| `application` / GPU checkpoint MDS | Receives data-shard count, placements, failures, replacements and node/rack capacities. An eligible same-rack case uses the aggregate-capacity/cyclic-witness backend; otherwise enumerates helper options under budget and compiles a weighted scheduler. The specialized result exposes helper shard IDs; the generic route exposes load assignments. No encoding matrix or GF(256) byte decoder is called by this interface. |
| `application` / vector repair | Tagged field + generator matrix + coordinate-to-node mapping + target matrix. Dispatch covers the same six prime fields and GF(4). `minimum_node_span_repair<F>` minimizes distinct nodes whose combined symbol span contains the target; returns nodes/count and work, not reconstruction bytes or a standalone optimality certificate. |
| Other application/Hall entries | Repair DAG batches tasks under precedence/capacities; QC-LDPC searches stopping/trapping sets; Hall emits a matching or obstruction with an optional streamed certificate and separate verifier. These are additional native capabilities, not variants of the GF(2) campaign restriction schema. |

The CLI parses JSON/file/stdin and formats output around typed in-process calls.
`run_with_threads` creates a Rayon pool outside the operation when requested.
Unsupported fields/features fail explicitly; the caller does not choose field kind
per transition. Native composition has independent rectangular matrix dimensions;
the historical browser request's shared rows/cols schema is not interchangeable.

## Campaign/control and persistence are different surfaces

`src/control/mod.rs:175,432,552` exposes experimental-v0 length-prefixed Unix-socket
commands with run/nonce handshake, bounded responses, epochs and operation names.
It supports candidates, active scalar plans, grouped feature analysis, synthesis,
evolution, external proposer sessions, observation and notes. Its capability report
explicitly declares `proof_authority: false`; it has no general solve-field command.

Private `python/ergodis_notebook/solve.py` makes the split explicit: `run_json`
launches an ordinary JSON CLI workflow; `Solve.launch` starts a separate task/search
process attached with run-dir and optional progress-file. Private
`tasks/tools/src/campaign_rpc.rs` is a control client, not a mathematical solver.
Its notebook docstring claiming payload equivalence with the browser is stale:
current CLI and browser composition shapes/field coverage differ.

Concrete controlled-search trace: private
`tasks/tools/src/alignment_controlled.rs:52` compiles the problem and presizes its
workspace before choosing unchanged baseline or controlled search. Private
`src/alignment_control.rs` uses an auxiliary watcher and bounded safe points.
`src/control/client.rs` PlanArena refresh performs I/O and compilation, validates
hash/epoch, then swaps the active arena; failed/stale replacement preserves the
old one. Immutable compiled evaluators are consumed separately from transport.
This is an example of host integration, not an audit of every controlled solver.

The newer `crates/runtime/src/service.rs` creates/applies/restores the bounded
CampaignSpec implemented by `crates/runtime/src/campaign.rs`, which still calls
the GF(2) reduction compiler on native as well as WASM. Native non-GF(2) CLI
workflows bypass that pilot. `crates/repository-native/src/lib.rs` is a filesystem
host for portable repository publication/replay and export, not a general native
solve dispatcher. `src/bin/ergodis_rpc.rs` / `src/rpc.rs` are another separate
NDJSON math endpoint: currently discovery and `character_sum.census`, not universal
campaign execution. Do not mistake shared transport style for shared semantics.

Private `src/parametric_lrc_contract.rs` already supplies model → compiled plan →
admitted budget query with count, threshold and witness readouts. It borrows the
plan and checks capacity overflow; `parametric_lrc.rs` retains the compiled threshold
and answers budget top-ups cheaply, constructing the witness only when requested.
This is valuable functionality to bind, not rebuild as a browser-only example.

## Field support nuance

`src/field.rs` has distinct arithmetic APIs. Static `FiniteField` uses a u8 order
and the inspected CLI dispatch selects primes and Gf4. Runtime `SmallField` and
`BinarySmallField<H>` support fields up to 256 elements, with cold validation and
specialized binary arithmetic. Their existence does not make every static generic
solver or CLI operation accept GF(256). C1130 must audit the actual callers and
contracts instead of either claiming GF(256) absent from core or assuming a ready
GF(256) byte-recovery host operation. Full parity means porting existing operations;
new mathematical functionality must remain distinguishable.

## C1130 implementation consequences

1. Recover typed native workflow requests/results from CLI-local parsing/dispatch
   into reusable cold boundaries and expose them through the canonical WASM host.
   Preserve native wire compatibility and existing specialized entry points.
2. Extend portable orchestration with the real operation contracts; do not force
   repair scheduling, evolution or field-valued composition through the finite
   coordinate-restriction checker. Verification/admission is claim-specific.
3. Bind compiled plan/query/update handles, witnesses and evidence boundaries, not
   only one-shot Solve. Use current real recovery workloads in the console; map
   available capacities/failures and actual outputs rather than inventing an RS
   byte decoder or FT10 scheduler underneath a diagram.
4. Retain native dispatch, representations and profiles; serialization and JS
   crossings stay cold. Portability is not evidence of compliance with every perf
   rule: inherited compilation/storage and controlled safe-point implementations
   need scoped classification, not blanket claims of allocation/lock freedom.
   Any changed hot path still requires the full zero-allocation and retained
   single/parallel A/B counter gates. No hot-path refactor is authorized by this
   read-only review alone beyond the queued task's scope.

## Evidence and limits

Inspected actual native dispatch, selected library entries, private callers,
portable service/repository code and `tests/cli.rs`. Existing tests include GF(4)
separation/coefficient witnesses, transfer-tower sequential/parallel JSON parity,
legacy prime composition and application outputs. Tests were read, not rerun;
no build, solver execution, timing measurement or native source edit was made.
This is the execution-interface map for C1130, not an exhaustive capability matrix
of every private task or a completed WASM port. The task's first gate still requires
that complete inventory and actual cross-target conformance.
