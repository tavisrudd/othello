# Private experimental theorem campaigns

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

The included adapters build projective-grid and alignment-attachment batches
without retaining a second in-memory copy:

```text
python3 scripts/build-campaign-data.py c80 ...
python3 scripts/build-campaign-data.py c880 ...
python3 scripts/build-campaign-data.py merge ...
```

`projective_hall_scout.py --feature-output FILE` optionally streams all
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

The private alignment adapter can also turn its already-published coarse root
heartbeat into an operational evolution profile:

```text
alignment-controlled --run-dir RUN --points 8 --budget 6 \
  --evolution-profile --pulse-interval 65536 \
  --profile-structural-branches 8 --profile-structural-packing 3
```

This optional path runs entirely in the auxiliary watcher. Once per second—or
after a genuine controller notification—it samples the existing heartbeat,
groups roots by `(root_orbit, root_initial_packing, root_sized)`, and publishes
absolute root count plus observed maximum root-state cost. Broad/high-packing
targets request structural-first mutation ordering; the rest request
numeric-first ordering; both thresholds are runtime options, so campaign
steering requires no recompilation. Only changed absolute observations are
sent. The watcher then requests a coalesced generation-boundary refresh if
evolution is active. Live tuples absent from the frozen batch are counted as
rejections and
cannot poison the profile. The search thread gains no new check, allocation,
lock, I/O, or publication: it still performs only the existing coarse
heartbeat stores and steering-safe-point protocol. Final JSON reports profile
updates, rejected live-only tuples, and queued refreshes.

### Root-cost routing audit

`alignment_root_corpus` builds an application-derived evolution corpus by
forcing each alignment root and recording its exact exhaustive search cost.
The diagnostic control copies only the first initialized root point into
preallocated state; it performs no serialization in the search path. Every
controlled solve must then match an ordinary uncontrolled solve in answer and
all search counters. The report also computes the exact observational ceiling
obtained by quotienting rows with identical exposed feature vectors.
`--capture-sized` instead waits for the first active root whose sizing pass has
completed, producing target tuples and structural root features comparable to
the once-per-second operational publisher without adding search-path
serialization.

`target_strategy_audit` runs matched balanced, numeric, and structural
evolution jobs and reports both time-to-first-perfect and time-to-final-best,
including cumulative semantic-op rows. The committed development and held-out
alignment controls, hashes, replay commands, and bounded interpretation are in
`evidence/alignment-root-cost-routing-README.md`.

`routing_policy_audit` is the first cold archive-trained routing layer. It
verifies every input and evidence hash, groups only exact target tuples, and
learns a non-balanced route only after the configured number of matched audits
show at least one win and no semantic-op-row regression. Otherwise it emits an
explicit balanced/abstain decision. It does not run in the campaign daemon or
solver.

An accepted cold policy can be supplied explicitly to the private alignment
adapter:

```text
alignment-controlled --run-dir RUN --points 8 --budget 8 \
  --evolution-profile \
  --routing-policy evidence/alignment-root-cost-routing-policy-3corpus.json
```

Only decisions marked learned with a numeric or structural route are loaded.
Fields compile against the alignment publisher's three exact target fields;
unknown, repeated, malformed, or duplicate selectors fail before search.
Selectors match exact tuple coordinates and never generalize to an unseen
target. Matching changed observations override the threshold fallback in the
watcher, and final control JSON reports `profile_policy_matches`. This remains
an initial cold policy: it does not learn or change routes during the job.

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

Plans may also carry an observational scope, for example
`"scope":{"field":"root_orbit","mask":2048}`. Values 0 through 63 select
bits in the mask. Scope is part of the executable hash. The compiled adapter
tests it before the VM and before computing optional theorem features, so a
root-specific idea pays neither cost on excluded roots.

The current predicate-only `evolve` command treats scope as a separate part of
the genome. It asks the controller
for bounded profiles of `root_orbit` and `root_candidate`, proposes observed
singletons and the union of positive-majority frozen strata, and mutates an
existing mask one observed bit at a time. Profiles combine the frozen batch
with strata seen in instrumented live pulses, so runtime-only roots remain
eligible. Offline labels rank theorem shapes; live ordering policies still
require a future paired operational proposer/race plus the throughput probation
below rather than being selected by classification accuracy.

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
line writer. It also publishes the same snapshot to the local controller so
candidate generation can learn which root strata actually occurred. The
search thread performs no socket/file I/O, serialization, or allocation. With
no progress file the watcher returns to pure blocking `recv`, and short solves
should still omit the entire control layer.

Snapshots include total and current-root states, duplicate/infeasible counts,
root ordinal and size proxies, canonical root orbit, and active/completed root
masks. The current adapter has one active root; a parallel adapter should use
one cacheline-isolated slot per worker and let the watcher OR the slots into the
published mask.

```text
alignment-controlled --run-dir RUN --points 8 --budget 13 \
  --initial 0 --seen-capacity 16777216 --symmetry
ergodisctl --run-dir RUN status
ergodisctl --run-dir RUN apply \
  examples/data/campaign-c880-residual-packing-order.json --expect-epoch 0

# Compare an active ordering plan with a temporarily inactive same-root window.
ergodisctl --run-dir RUN probation prefer-strong-residual-packing-bound \
  --progress RUN/progress.jsonl --expect-epoch 1 --samples 5
```

Probation compares state rates only when both windows retain the same root
candidate and initial structural sizing tuple. Otherwise it uses completed-root
throughput when both windows span roots; an incomparable pair is restored as
inconclusive. A slowdown beyond the requested threshold leaves the plan rolled
back.

The residual-packing plan is intentionally a diagnostic stressor, not a
recommended heuristic. The first live version recomputed every remaining
child score on every selection and made the budget-13 control about 3.9x
slower. Fixed, pre-sized per-depth order buffers now compute each child score
once per frame; default feature-off workspaces contain none of this state. That
repair reduced the same injection experiment from 168.85 to 78.07 seconds
(2.16x), preserving the exact UNSAT answer and essentially the same state
count. It is still 1.81x slower than the 43.10-second no-theorem diagnostic.
Root scoping is the first theorem-driven cost repair. On the budget-12 fixture,
an unscoped residual score executed 220.9 billion instructions in 18.76 seconds;
an excluded scope executed 91.7 billion in 8.00 seconds, indistinguishable from
the no-plan instruction count. A genuinely visited orbit-11 scope finished in
10.40 seconds versus 18.69 seconds unscoped while preserving the exact answer.
The next gate is an online root-to-plan dispatcher that promotes only
same-stratum probation wins, followed by a cheaper theorem-equivalent child
summary and an actual state reduction in multiround A/B.

## Current limitations

The C880 exact DFS now consumes the safe-point protocol experimentally; C80
does not yet have a live adapter. The controller does not
restore active plans after process restart, compact equivalent ledger entries
on disk, generate proof handles, or promote rules into a multi-policy
root-to-plan dispatch table. The protocol, command names, and proposer are
expected to change after more real campaigns; the isolation, boundedness,
exact replay, and core-independence invariants are the intended durable parts.
