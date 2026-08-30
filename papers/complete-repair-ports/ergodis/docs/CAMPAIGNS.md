# Experimental theorem campaigns

The `control-plane` feature is an opt-in layer for long diagnostic searches.
It is not linked into ordinary Ergodis solves and cannot promote a sampled
pattern into a pruning or admission theorem. Its current schema is explicitly
`experimental-v0`.

Build the two separate binaries with:

```text
cargo build --features control-plane --bin ergodis-campaign --bin ergodisctl
```

## Data boundary

A campaign reads one frozen JSONL feature batch. The first line declares the
presentation, ordered integer fields, and exact row count; every later line is
one labelled row:

```json
{"schema":"ergodis-campaign-data-v0","presentation":"example-v0","problem":"example","fields":["rank","debt"],"rows":2}
{"id":0,"weight":3,"expected":true,"values":[0,4]}
{"id":1,"weight":1,"expected":false,"values":[2,0]}
```

Loading is streamed into presized column-order storage: flat `i64` values,
`u64` row IDs and weights, and a packed expected-label bitmap. The declared
row/cell limits are checked before allocation. Large raw search evidence should
remain in domain-owned files; campaign data should contain only the compact
features needed to compare attacks.

The included adapter builds C80 and C880 batches without retaining a second
in-memory copy:

```text
python3 scripts/build-campaign-data.py c80 ...
python3 scripts/build-campaign-data.py c880 ...
python3 scripts/build-campaign-data.py merge ...
```

`c80_projective_hall_scout.py --feature-output FILE` optionally streams all
sampled survivor and non-survivor reply rows while leaving its canonical
aggregate certificate unchanged.

## Start and control a run

Create a new private run directory and an isolated Unix socket:

```text
ergodis-campaign \
  --data reply-features.jsonl \
  --run-dir runs/q11-q13 \
  --socket "$XDG_RUNTIME_DIR/ergodis-q11-q13.sock"

ergodisctl --run-dir runs/q11-q13 status
ergodisctl --run-dir runs/q11-q13 agent-brief --since 0 --top 8
```

When `--socket` is omitted, a private endpoint is derived under
`$XDG_RUNTIME_DIR/ergodis/<uid>/`. There is no `/tmp` fallback. The durable
manifest is mode 0600 inside a mode-0700 run directory and binds the full run
ID, nonce, presentation hash, PID, and endpoint. Every mutation is
epoch-conditional; cross-run credentials and responses are rejected.

## Candidate language

The author surface is a typed, prefix expression tree modelled on SMT-LIB. It
keeps grouping explicit and is convenient for both agents and generators. For
example, the C80 diagnostic hypothesis
`omega_drop > 0 && next_defect_rank in {0, 6}` is represented by
`examples/data/campaign-c80-rank-zero-six-expr.json`. JSON is the v0 envelope;
a compact S-expression spelling can be added without changing the IR.

The controller lowers that tree once to a bounded postfix instruction stream,
then validates it in the style of eBPF before execution. Plans have at most 128
nodes/operations, expression depth at most 32, a fixed 64-value evaluator
stack, and either `predicate` or `score` output. Available operations are
integer fields/constants, checked `add/sub/mul/abs`, `min/max`, integer
comparisons, Boolean operations, and `select`. Arithmetic overflow, unknown
fields, stack underflow, extra results, and schema mismatches fail closed.

The older explicit `program` array is the stable lowered/debug form and remains
accepted. It is not the preferred author syntax. This source/IR split follows
the useful MLIR distinction between a readable dialect and a canonical lowered
form; durable ledgers record the lowered plan hash so two front ends cannot
silently disagree about execution. That execution hash covers the schema,
role, output sort, and canonical lowered operations, but deliberately excludes
the human display name.

Keeping the source fragment inside SMT-LIB's quantifier-free integer/Boolean
core also leaves a clean future route to emit a candidate as an SMT formula for
bounded counterexample search. Quantifiers, filesystem actions, loops, and
unbounded collections do not belong in the row evaluator; relational/grouped
queries should remain a separate offline Datalog/SQL-like layer.

The compiled evaluator uses one 16-byte operation record and allocates nothing
while evaluating a feature row. Diagnostic and ordering are the only admitted
roles in v0. There is deliberately no necessary/sufficient/pruning role.

Useful one-shot operations are:

```text
# Test one shape and report only its first labelled mismatch.
ergodisctl --run-dir RUN try plan.json --group-by q

# Atomically retain a diagnostic plan.
ergodisctl --run-dir RUN apply plan.json --expect-epoch 0

# Long solvers poll only at coarse safe points. An unchanged pulse is tiny.
ergodisctl --run-dir RUN pulse --since-epoch 0
ergodisctl --run-dir RUN --json plan-get PLAN --expect-epoch 1
ergodisctl --run-dir RUN deactivate PLAN --expect-epoch 1

# Fetch a compact decisive object or inspect only one local execution.
ergodisctl --run-dir RUN obstruction PLAN
ergodisctl --run-dir RUN trace PLAN --row 17 --max-records 32

# Rank rigid, rare, indebted, or otherwise exceptional rows by a score.
ergodisctl --run-dir RUN exceptional SCORE --top 8 --direction high

# Prove whether the frozen feature vocabulary itself loses labels.
ergodisctl --run-dir RUN ceiling
```

`ceiling` sorts only `u32` row indices and groups identical feature vectors. It
returns the exact best classification possible from the current features and
the first opposite-label collision. A nonzero unavoidable-error count says to
add information, not search more syntax.

## Unattended attack search

`batch` and `evolve` are designed to reduce agent/token overhead:

```text
ergodisctl --run-dir RUN batch seeds.jsonl \
  --output RUN/seed-results.jsonl --max-plans 100

ergodisctl --run-dir RUN evolve seeds.jsonl \
  --output RUN/evolve-results.jsonl \
  --generations 3 --beam 16 --max-candidates 1000
```

Both commands stream full exact results to a create-only file and print one
summary. `evolve` deterministically mutates constants, fields, comparisons, and
Boolean combinators. The server hashes each full output vector, so syntactically
different attacks with the same behaviour share one observational class.

The bounded tree synthesizer is a second proposer:

```text
ergodisctl --run-dir RUN synthesize \
  --output RUN/tree.json --max-nodes 31 --max-depth 8

# Train on q=11 but replay the emitted plan on every loaded row.
ergodisctl --run-dir RUN synthesize \
  --output RUN/tree-q11.json \
  --train-field q --train-value 11
```

It uses an iterative, node/depth-capped learner and emits ordinary VM bytecode.
The result is a diagnostic theorem shape. Cross-stratum replay and independent
mathematical proof remain mandatory before any sound solver use.

## Debt and exceptional-state ledgers

The durable attack ledger records which conjectures were tested, rejected,
activated, traced, or synthesized. Mathematical debt is separate: a domain
adapter exposes small exact accumulators such as unresolved obligations,
consumed/created-label balance, matching deficiency, survivor slack, forced
move count, or stabilizer size as feature columns.

Use a score plan to rank only the top-K exceptional rows, then arm a trace for
one row. Do not emit every debt transition. For a live solver adapter, update
the compact debt record in thread-local state, publish only bounded safe-point
summaries, and record ancestry deltas only for an armed localized trace. A debt
coordinate remains diagnostic unless a separate theorem validates its role;
C80's recursive Tutte “debt two” is a known example of a certificate artifact
that must not be treated as game debt.

## Bounded evidence

- Requests and responses are length-prefixed JSON capped at 64 KiB.
- Agent briefs are cursor-based deltas with at most 16 events.
- The high-level JSONL ledger has a launch-time byte cap.
- Local traces have both record and byte caps and live under `RUN/evidence/`.
- Batch/evolution results require explicit create-only output paths.
- The controller retains at most 64 active plans, 4096 outcome classes, and
  256 recent brief events.

The socket is never a raw-event stream. Disconnect leaves the last validated
epoch active. Seconds-scale solves should not launch this layer at all.

For live adapters, the inner search loop never touches the socket. Each solver
registers a private `RUN/watch-*.sock` Unix datagram endpoint. The campaign
pushes one eight-byte epoch only after a semantic activation or deactivation;
`status`, `noop`, notes, and unchanged queries do not notify search. An
auxiliary watcher blocks in `recv` with no idle timer or wakeup and raises a
cacheline-isolated atomic flag. The search tests that flag once per 4096 states
at a precomputed control deadline shared with its existing heartbeat deadline.
Thus the steady-state controlled loop retains one deadline comparison rather
than adding a mask or second branch.

After a datagram, the watcher—not the search thread—uses `pulse` to obtain
bounded plan identities and `plan-get` to fetch canonical lowered plans against
that exact epoch. It validates and compiles them into a recycled, preallocated
arena, then publishes the arena and raises the flag. The search safe point only
locks the rarely touched exchange, swaps two arenas, and returns the old arena
for watcher reuse. It performs no socket or file I/O, serialization,
compilation, allocation, or deallocation. An epoch change between pulse and
fetch fails closed. Repeated datagrams are drained while the watcher always
prepares the latest epoch, so plan removal remains as atomic as activation.

The experimental `alignment-controlled` binary is the first consumer. It
publishes a bounded C880 heartbeat into relaxed atomics at the caller-selected
state interval and permits only score-valued ordering plans. Every branch
remains in the exact DFS. The ordinary
`search_alignment_attachment` entry point instantiates the internal loop with
control statically disabled; `--baseline` exercises that unchanged path.

Long diagnostic runs may add `--progress-file FILE --pulse-interval 4096`.
Only then does the auxiliary watcher take a one-second receive timeout and
stream changed heartbeat snapshots as create-only, mode-0600 JSONL through a
line writer. The search thread performs no file I/O or allocation. With no
progress file the watcher returns to pure blocking `recv`, and short solves
should still omit the entire control layer.

```text
alignment-controlled --run-dir RUN --points 8 --budget 13 \
  --initial 0 --seen-capacity 16777216 --symmetry
ergodisctl --run-dir RUN status
ergodisctl --run-dir RUN apply \
  examples/data/campaign-c880-residual-packing-order.json --expect-epoch 0
```

The residual-packing plan is intentionally a diagnostic stressor, not a
recommended heuristic. The first live version recomputed every remaining
child score on every selection and made the budget-13 control about 3.9x
slower. Fixed, pre-sized per-depth order buffers now compute each child score
once per frame; default feature-off workspaces contain none of this state. That
repair reduced the same injection experiment from 168.85 to 78.07 seconds
(2.16x), preserving the exact UNSAT answer and essentially the same state
count. It is still 1.81x slower than the 43.10-second no-theorem diagnostic.
The next gate is therefore not more caching alone: cache the chosen child's
summary and/or replace exact child evaluation with a cheaper theorem-equivalent
accumulator, then demand an actual state reduction in multiround A/B.

## Current limitations

The C880 exact DFS now consumes the safe-point protocol experimentally; C80
does not yet have a live adapter. The controller does not
restore active plans after process restart, compact equivalent ledger entries
on disk, generate proof handles, or promote rules. The protocol, command names,
and proposer are expected to change after more real campaigns; the isolation,
boundedness, exact replay, and core-independence invariants are the intended
durable parts.
