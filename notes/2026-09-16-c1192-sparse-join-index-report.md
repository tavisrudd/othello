# C1192 — a sparse join index in the demand evaluator, with an exact crossover policy

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: BUILT, GATED AND MEASURED; two measurements the card asked for were not taken. Written
incrementally from the start of the task, so a crash leaves a partial record rather than none.

## Handoff state

**Done and gated.** The demand evaluator has a sparse addressing kind beside the direct one for both
of its direct-addressed structures — the join index and the membership test — chosen once at
preparation by a measured policy, with the derivation loop monomorphized on the choice. The two
admission ceilings that refused programs (`MAX_UNIVERSE` 2^30, `MAX_INDEX_KEYS` 2^24) survive at
their old values as policy ceilings, so a program the evaluator accepted before makes the same
choices. The replacement refusals are the row capacity and `MAX_WORKSPACE_BYTES`, through
`Error::Budget`. The mirrors of both ceilings are gone from the private lowering close and the
stratified backend. C1188's tuple `memmove` is removed from the loop in its own commit. Core: 80 test
binaries, zero failures, clippy and fmt clean, `SHA256SUMS` current. Private: 42 test binaries, zero
failures, including the C1189 differential at zero disagreements.

**Measured, with receipts** (all under `~/src/ergodis-private/`):

| What | Receipt |
| --- | --- |
| the direct path, control against candidate, six cohorts | `analysis/datalog-comparison/ab-2026-09-16-c1192-direct.json` |
| C1188's tuple copy, eight cohorts | `analysis/datalog-comparison/ab-2026-09-16-c1188-memmove.json` |
| the crossover, membership, eleven density points | `analysis/datalog-comparison/ab-2026-09-16-c1192-crossover-membership{,-high}.json` |
| the crossover, join index, eleven density points | `analysis/datalog-comparison/ab-2026-09-16-c1192-crossover-index{,-high}.json` |
| the frontend and the stratified backend, nine cohorts | `analysis/rel-frontend/performance-v7-sparse{,-datalog,-stratified,-columns,-aggregate}-d2b1940.json` |
| the kernel-scoped profiles, three arms | `~/.cache/ergodis/perf-c1192/closure-dense-{e0e7331,d2b1940,b7921a0}.data` |

The reach and boundary tables were taken by single invocations of the committed tools and are
reproduced by the replay block at the end; they have no receipt file of their own.

**Nothing is half-built.** Every source change is committed in both repositories; `git status` is
clean in `ergodis`, `ergodis-private` and `othello`.

**Retained binaries**, all through `../ergodis-dev/scripts/retain-bin.sh` inside `nix develop` of the
core checkout, rustc 1.95.0 (59807616e 2026-04-14):

| Name | Role |
| --- | --- |
| `closure_ballpark-e0e7331` | control, retained before the first source change |
| `ergodis-tools-e0e7331` | control, frontend and stratified backend |
| `closure_ballpark-1dfc6ed` | superseded candidate; its A/B was re-run at `d2b1940` |
| `ergodis-tools-4bcbc10` | superseded candidate; likewise |
| `closure_ballpark-d2b1940` | the candidate every figure except C1188's was measured on |
| `ergodis-tools-d2b1940` | the frontend and backend candidate; **does not carry C1188** |
| `closure_ballpark-b7921a0` | after C1188 — **the control the next A/B should use** |
| `c1188probe-d2b1940` | a probe from a dirty tree, cited by nothing, byte-identical to `b7921a0` |

**The next three concrete steps.**

1. **Run the Soufflé row the card asked for and this task did not take.** One invocation:
   `nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake nixpkgs#time -c python3
   analysis/datalog-comparison/compare.py --bin ~/.cache/ergodis/bin/closure_ballpark-b7921a0
   --work $(mktemp -d -p ~/.cache/ergodis/c1192) --out
   analysis/datalog-comparison/results-2026-09-16-blocks.json --rounds 5 --cpu 5
   --sizes closure:blocks:4096,16384,65536`. `compare.py` takes an arbitrary density and `tc.dl` is
   the same program, so nothing needs writing; Soufflé 2.5 is in the store. That closes remaining
   gap 1, which is the only thing the card asked for that has no number.
2. **Retain an `ergodis-tools` after C1188 and re-run the four backend cohorts**, so the stratified
   backend's figures describe the shape the tree carries. The current backend receipts are at
   `d2b1940`, one commit before the tuple copy was removed, and the loop they measure is the one
   C1188 changed by 10.5 per cent.
3. **Decompose the sparse membership probe's flat 20 to 26 per cent instruction cost** — mystery
   ledger item 6 — into the hash, the chain walk and the tuple comparison, in the playbook's sizing
   shape. It is the one open question that could change the policy, because a sparse membership test
   that was not structurally 20 per cent behind would have a crossover where today it has none.


Task card: `2026-09-16-c1192-sparse-join-index.md`. Predecessors: `2026-09-13-c1182-demand-driven-datalog.md`
(the evaluator and the recorded "exact crossover unmeasured"), `2026-09-13-c1184-direct-checker.md`
and `2026-09-13-c1186-presence-bitmap.md` (the checkers' stores, which already carry a sorted
fallback), `2026-09-16-c1191-direct-constructor-report.md` (the boundary cohorts and remaining gap 1,
which names this change). Repositories: `~/src/ergodis` (core) and `~/src/ergodis-private`
(drivers and harnesses).

## Arms

Filled in as each is retained. Every hash is recorded **as measured**, never cited: the thing to run
is the retain recipe at the named revision.

| Arm | Repository | Revision | Dirty | Retained name | rustc | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, closure/same-generation harness | `ergodis-private` | `e0e7331` | no | `closure_ballpark-e0e7331` | 1.95.0 (59807616e 2026-04-14) | `c1c3aecce4a888c01a0fab20ec860e18d0c504b38132ad1ab852f8d87fdbe10f` |
| control, frontend and stratified backend | `ergodis-private` | `e0e7331` | no | `ergodis-tools-e0e7331` | 1.95.0 (59807616e 2026-04-14) | `e58752d20e1856353a9787ed50d31b158daf8b87aaef26ca4e0c55c28882dbbb` |

Retain recipes, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

Both re-execute themselves inside `nix develop` of the core checkout, so the toolchain is the
`rust-toolchain.toml` pin. Both control arms were retained from a clean tree at `ergodis-private`
`e0e7331` with core `ergodis` `2517852`, **before the first source change of this task**.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `0ef05ec` | this report's skeleton and the Fermi predictions, written before any code |
| `ergodis` | `84ed62c` | the sparse addressing kind, the policy, the monomorphized derivation loop, the saturating universe, the workspace byte ceiling, and the agreement and mutation tests |
| `ergodis-private` | `25cf4ed` | the two mirrored refusals removed from the lowering close and the stratified backend; `rel_stratified` on the bounded constructor; `closure_ballpark` gains `--max-rows`, `--index`, `--evaluate-only`, the `blocks` density and the `mutual` program |
| `ergodis-private` | `6bfe187` | `analysis/datalog-comparison/ab.py`, a committed interleaved A/B driver for the derivation loop |
| `ergodis` | `d0a0ef3` | `Policy::SparseIndexes` and `Policy::SparseMembership`, so a crossover measurement moves one structure at a time |
| `ergodis-private` | `f2804c4` | the `cycle` cohort and the two one-structure policies on the command line |
| `ergodis-private` | `1dfc6ed` | `ab.py` streams every raw sample and rebuilds a receipt from them |
| `ergodis-private` | `4bcbc10` | `ab.py` reads the enabled fraction from the right `perf stat` field |
| `ergodis` | `a1c6767` | each one-structure policy forces both kinds, so the four corners differ in one structure |
| `ergodis` | `6ab0dd5` | the policy set from the measurement: one crossover, two ceilings, no other density rule |
| `ergodis-private` | `d2b1940` | `ab.py --sweep`: one receipt per crossover rather than one per point |
| `ergodis` | `24e399e` | **C1188**: the tuple copy out of the derivation loop, as element loops over a bounded array |
| `ergodis-private` | `b7921a0` | re-pin the core at the C1188 removal, so the arm after it has a name |
| `ergodis-private` | `8881837` | the receipts at the kept revisions |
| `othello` | `0ef05ec`…`9a3ce47` | this report, written incrementally in twelve commits |

## Fermi predictions, written before any code

Written from the compiled shape of `crates/rules/src/demand.rs`, the bound constants, and the
C1182 and C1191 measurements.

### 1. Which bound binds on which family, and what the reach becomes

The card and the programme review both say `MAX_INDEX_KEYS` caps every binary relation at a domain
of 4,096. That is true of an index whose key mask names **two** columns, and it is the reason
`columns3` and `aggregate` stop where C1191 measured them. It is **not** what stops the closure and
same-generation families, and I predict the measurement will show that, because their join masks all
have population count one:

- `path(x,z) :- path(x,y), edge(y,z)` binds `y` from the delta atom, so the `edge` index keys on
  column 0 alone: `domain^1`. The mirrored step keys `path` on column 1 alone. Same for all three
  same-generation rules.

So for those two families `MAX_INDEX_KEYS = 2^24` is reached only at a domain of 16,777,216, far
above `MAX_DOMAIN = 65,536`. **I predict the bound that actually stops closure and same generation
today is `MAX_UNIVERSE = 2^30`** — the derived relation's membership bitmap over `domain^arity` —
which at arity two is a domain of 32,768, and that the second bound behind it is `MAX_ROWS = 2^24`
on the derived rows. I predict the C1182 generated closure family (out-degree three, random targets)
cannot reach N = 16,384 under **any** index change, because its closure is essentially complete
(0.93 N² measured at N = 4,096, which is 15.68 M rows against a row capacity of 16.78 M): I predict
N = 8,192 is refused by `MAX_ROWS` with the output near 62 M. The same generation family is
0.115 N², so I predict it is refused by `MAX_ROWS` at N = 16,384 (about 31 M rows) and runs at
N = 8,192 (about 7.7 M).

Therefore I predict the reach the card asks for — closure and same generation at N = 16,384 and
65,536 — is **not reachable on the existing generated families at all**, for a reason that has
nothing to do with the index, and that the task must add a family whose domain is large and whose
closure is small to demonstrate the removed ceiling. I predict I add one deterministic edge
generator (disjoint blocks) and one program whose join mask has population count two, and that
these are the two cohorts that carry the reach claim.

### 2. What the sparse structure costs per probe

Direct probe: one load from `head[key]`, a random access over `4·K` bytes. Sparse probe: a
multiply-shift hash of the packed key (about four instructions), one load from `head[h]` over
`4·S` bytes where `S` is the presized power-of-two table, and then, per row the chain yields, a
comparison of the key columns against the probe's values — because a hash bucket may hold rows of
other keys, which direct addressing cannot. The tuple those columns live in is already loaded by
the join step, so the verification is two to four instructions and no extra load.

I predict the sparse kind costs **6 to 12 more instructions per probe** plus the wasted chain
steps, which at a load factor of one half I predict at about 0.3 rows per probe. Against a join
step I estimate at 30 to 60 instructions per candidate, that is **10 to 25 per cent more
instructions in the join step** and, since the derivation loop is roughly half of evaluation on the
closure family, **5 to 15 per cent more instructions on evaluation at equal work**.

**So I predict instructions alone say "always direct", and that the crossover is not an instruction
question.** What the sparse kind buys is memory and memory traffic: the direct dynamic index
allocates `4·K` bytes and, critically, `head.fill(NONE)` writes all of them at the start of every
evaluation, while the sparse one writes `4·S` with `S` sized from the relation's rows. I predict
the crossover in cycles and wall time sits where the reset traffic and the random-access footprint
outweigh the extra instructions, at **K between 4 and 32 times the row count**, and that the
measured value is closer to 8 than to 32. I predict I will have to say plainly that this is the
one figure in this lane a cycle ratio decides rather than an instruction ratio, and that above the
crossover the choice is not speed at all but feasibility, because the direct array does not exist.

### 3. What the direct path does when it is still selected

Nothing. The selection is made once at preparation; the derivation loop is dispatched once per step
at entry rather than per probe, which is a strict improvement on today's shape, where
`if index.offsets.is_empty()` is tested inside the per-delta-row loop on a value that is constant
for the whole step. I predict the direct path is **unchanged to within the A/A nulls** on every
existing cohort, and I predict a small win — **0 to 2 per cent** — from hoisting that run-constant
branch, most visible on same generation sparse, where the delta rows are many and the chains short.

### 4. Memory, and what replaces the removed bounds

Removing `MAX_UNIVERSE` and `MAX_INDEX_KEYS` as refusals does **not** raise the worst-case
workspace; I predict it lowers it. Today a relation's bitmap is `domain^arity / 8` bytes whatever
its row count, up to 128 MB, and a dynamic index is `4 · domain^popcount` bytes, up to 64 MB, again
whatever its row count. With a selection policy every structure is `O(rows)` except a direct array
the policy chose because it was small. I predict the worst case per relation falls from about
190 MB independent of rows to about `(8 + arity) · 4 · rows` bytes plus a bounded direct array, and
that the replacement refusal is `MAX_ROWS` plus a named workspace byte ceiling, both through
`Error::Budget`.

I predict peak resident set at equal N is **lower** on the sparse arm wherever the relation is
sparse and **slightly higher** where it is dense, and that the dense closure family at N = 1,024 is
the case where direct is the right choice by a wide margin: its universe is 2^20 and it derives
2^20 rows, a density of one.

### 5. Expected differential disagreements

Zero, and for the same weak reason C1191 recorded: the sparse kind answers the same query as the
direct kind, so a corpus that exercises the query only sees them agreeing. The load-bearing evidence
is therefore (a) running the whole existing test corpus a second time with the policy forced to
sparse, which is what C1186 did with the checkers' sorted fallback, and (b) deliberate mutations.
I predict at least one instructive negative in the chain-verification path: the case I expect to
get wrong first is a key column that is a **constant** rather than a bound variable, because the
direct index folds a constant into the key and a chain walk must compare it.

### 6. Where the risk is

Three places, in the order I expect them to bite. First, `MODE_FULL`'s `limit`: the CSR path breaks
out of a bucket when a row index reaches the limit because a counting sort leaves each bucket
ascending, while a chain is descending and must test every element; a sparse bucket mixes keys, so
neither the break nor the ordering argument transfers. Second, the `candidates` work counter, which
must stay exactly equal across kinds for the A/B to be a comparison at equal work — so a row the
chain yields that does not match the key must be rejected before it counts. Third, `u64::pow`
overflowing once `domain^arity` is no longer bounded: at domain 65,536 and arity four that is
exactly 2^64, so every universe computation has to saturate rather than wrap.

## Status

Built and gated; measurement in progress. The demand evaluator's two
direct-addressed structures — the join index over `domain^popcount(mask)` and the membership
bitmap over `domain^arity` — each have a second shape sized from the rows, chosen once at
preparation. The two admission ceilings that refused programs are now policy ceilings that choose a
representation, so a binary relation is no longer capped at a domain of 32,768 nor a ternary one at
1,024, and a relation of arity four over the largest admitted domain — `2^64` tuples — is a program
the evaluator accepts. Certificates are unchanged in meaning and, on every cohort measured,
unchanged byte for byte between the two kinds.

## Design, and the shapes not built

### One kind for each structure, chosen once

```text
                    direct                          sparse
join index,         CSR: offsets[domain^k + 1],     sorted distinct keys with the same
input relation      rows grouped by key             contiguous buckets, binary probe
join index,         head[domain^k], next[rows],     head[next_pow2(rows)], next[rows],
derived relation    chained by row                  multiply-shift hash, chained by row
membership          one bit per domain^arity        head[next_pow2(rows)], next[rows],
                                                    compare the tuple per row
```

Three properties make this a representation change and not a semantic one.

**A sparse bucket holds more than one key, and the join step compares them.** A direct bucket is
addressed by the key, so every row it yields matches by construction and the evaluator never
compares a key column. A hash bucket yields whatever collides with it, so the join step compares
each key column — a constant, or a variable the delta atom bound — against the row. A row rejected
there produces no candidate, exactly as an equality check on a repeated variable does, so the work
counts of the two kinds are equal and an A/B between them is a comparison at equal work.

**The rows of one key come out in the same order.** A counting-sorted bucket and a sorted bucket
are both ascending by row; a direct chain and a hash chain are both descending, because both prepend
and rows are appended in increasing order. Filtering a hash chain to one key leaves a subsequence of
the direct chain's order. So the derivation order is identical and **the certificate is identical
byte for byte**, which is a stronger statement than a set comparison and is what the tests assert.

**The kind is resolved once.** `Policy` decides at preparation and the derivation loop is
monomorphized on the result through a const generic, dispatched once per step at entry. The
pre-existing shape was worse than that: `if index.offsets.is_empty()` was tested inside the
per-delta-row loop on a value constant for the whole step.

### The row bound moved into the plan

The policy reads the rows a structure can hold, and for a derived relation that is
`min(domain^arity, row_bound)` — a number the caller supplies. It cannot therefore be a property of
the workspace, as `workspace_bounded(max_rows)` made it. `Demand::new_bounded` and
`from_prepared_bounded` take the bound and the policy; `workspace()` is the only workspace
constructor; and a workspace built for one plan is refused by another, because the bound is part of
the shape check. This is a recorded deviation: the card did not ask for it, and it is what makes the
selection a preparation-time decision rather than a per-evaluation one.

### What replaced the two refusals

`MAX_UNIVERSE` and `MAX_INDEX_KEYS` kept their values and became `MAX_DIRECT_UNIVERSE` and
`MAX_DIRECT_KEYS`, above which the policy chooses sparse rather than refusing. A program the
evaluator accepted before therefore makes exactly the same choices, which is the strongest available
form of "the direct path does not move".

The refusals that replace them are the row capacity, `MAX_ROWS = 2^24` per relation, and
`MAX_WORKSPACE_BYTES = 2^34`, both through `Error::Budget`, with `Demand::workspace_bytes()`
reporting the figure that is checked. Removing the two ceilings **lowers** the worst-case workspace
rather than raising it: a relation used to cost `domain^arity / 8` bytes of bitmap and an index
`4 · domain^popcount` bytes whatever their row counts, and every structure is now `O(rows)` except a
direct array the policy chose because it was small.

### Shapes considered and not built

1. **Open addressing with the key stored in the bucket**, a sixteen-byte record per slot. Rejected:
   the chain through a `next` column indexed by row costs four bytes per slot and four per row, which
   is the same shape the direct chain already has, so the two kinds share their workspace sizing and
   the sparse one is never more than about three times the rows in bytes. Storing the key would have
   removed the per-row comparison and added eight bytes per slot; the comparison reads a tuple the
   join step loads anyway.
2. **A hash chain for an input relation too.** Rejected: a counting-sorted CSR gives an input
   relation contiguous buckets, which is a measured property of the existing direct path (C1182), and
   the sorted-key array keeps that shape exactly — the join step's inner loop is the same slice walk
   and only the bucket lookup differs. A hash chain would have changed the inner loop for every
   static index.
3. **A membership structure separate from the row store.** Not built: the sparse membership test
   chains through a `next` column and compares against the row store, so it holds no tuples of its
   own. A separate open-addressed set of packed keys would be eight bytes per slot and would hold a
   second copy of every key.
4. **Refusing a program whose direct array would be large, as before, and simply raising the
   ceiling.** Rejected: it moves the reach by whatever factor the ceiling is raised and leaves the
   memory unbounded by the rows, which is what makes a relation of a hundred thousand values
   impossible whatever its size.
5. **A `Policy` with one forced kind and the other left to the rule.** Built and then corrected in
   the same task, which is recorded because the first shape was wrong in a way that would have
   produced an unattributable measurement: `SparseIndexes` originally left the membership test to the
   policy, and at exactly the densities where an index crossover matters the policy chooses a sparse
   membership too, so the comparison moved both structures. Each variant now forces both kinds, one
   sparse and one direct, so `Direct`, `Sparse` and the two of them are the four corners and every
   pair differs in one structure.
6. **Narrowing the addressing bound to a relation's per-column domains**, which C1191's closeout
   named as the obvious next lever. Not built and now largely moot: a bound computed from
   `∏ᵢ |Dᵢ|` rather than `domain^arity` would have made the direct array smaller, and the sparse
   kind makes it unnecessary for reach. It remains a candidate for choosing direct more often, which
   is a speed question rather than a reach one.

## Method

### The harness the A/B needed, and why it is committed

The closure and same-generation A/Bs of C1184 and C1186 were run by an ad-hoc loop whose output was
kept as a `.tsv`; the driver was never committed, so those receipts cannot be replayed from a
revision. This task's first private commit after the source change is
`analysis/datalog-comparison/ab.py`, a driver in the shape the playbook prescribes: two arms that
may differ by revision, by arguments or both; rounds that alternate arm order; an A/A null per
cohort; the non-multiplexing event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` with the enabled fraction
recorded per measurement rather than inferred; two-point differencing between `repeats` and
`2 · repeats` derivation-loop iterations, which removes process startup, admission and preparation
from every per-iteration figure; one pinned core; and the load average over the run. Every raw
sample is streamed to a `.jsonl` sidecar as it completes and `--resummarize` rebuilds the receipt
from it without measuring — added after a summary defect (a two-point fault-count difference of
zero, divided) cost a complete twelve-minute run.

Both arms print their derived, probe and candidate counts, and in the kernel-scoped mode a SHA-256
over the output relation's rows; a cohort whose arms disagree on any of them is reported as a
failure and is not summarized.

### Two harness modes, and which arm can use which

`closure_ballpark --evaluate-only` is the kernel-scoped mode this task adds: read the generator,
prepare once, then enter the derivation loop `repeats` times, with no certificate, no checker, no
serialization and no output file. It is what the kernel-scoped profile runs and what a
candidate-against-candidate comparison uses.

The retained control predates that mode, so the **control-against-candidate** A/B runs both arms in
the harness's full mode instead. Everything outside the derivation loop — admission, preparation,
certificate emission, both independent checkers, the representation sizing — runs exactly once there
whatever the repeat count, so the two-point difference is still the derivation loop's own cost and
nothing else. The fixed part is paid twice per arm per round and cancels.

### Which cohorts answer which question

| Cohort | What it is | What it measures |
| --- | --- | --- |
| `closure`, `samegen`, sparse and dense | the C1182 generators | the direct path, which must not move |
| `closure` at the `blocks` density | the complete digraph inside each block of sixteen nodes | a relation whose tuple universe is `domain²` and whose size is linear in the domain: the membership crossover, and the reach a bitmap cannot have |
| `mutual` at `blocks` | `sym(x,y) :- edge(x,y), edge(y,x).` | a **static** join index keyed on `domain²`, which the retired `MAX_INDEX_KEYS` refused above a domain of 4,096 |
| `cycle` at `blocks` | the closure, then `back(x,y) :- path(x,y), path(y,x).` | the same index over a relation that **grows**: the hashed chain rather than the sorted array |
| `stratified`, `columns`, `columns3`, `aggregate` | the C1191 boundary cohorts through `rel-lower` | the reach of the Rel route, and which bound decides it now |

The two densities a policy reads are the same number for an arity-two relation with a full-mask
index — the index's key space and the membership universe are both `domain²`, and both are divided
by the same row capacity — so the crossover sweep varies the caller's row bound at a fixed domain
and forces one structure's kind at a time.

## Results

### The direct path, where it is still selected

Control `closure_ballpark-e0e7331` against candidate `closure_ballpark-d2b1940`, five interleaved
rounds, CPU 5, repeat counts 3 and 6 with two-point differencing, the six-event set at **100.00 per
cent enabled on every event over 180 measurements**, load 2.84 to 4.84. Receipt
`analysis/datalog-comparison/ab-2026-09-16-c1192-direct.json` with its raw sidecar. On every one of
these cohorts the candidate's plan selects the **direct** kind for every join index and a
**bitmap** for every membership test, which the receipt records per cohort — so this is the direct
path compared with itself across the change, not a representation comparison.

| Cohort | derived | instruction ratio [lo, hi] | A/A null | cycle ratio [lo, hi] | cycle null | in-process evaluation, candidate / control | peak RSS, control / candidate KiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` sparse 256 | 62,979 | **0.95274** [0.95272, 0.95276] | 0.9999964 | 1.0247 [0.9983, 1.0517] | 1.0275 | 2.958 / 2.966 ms | 18,684 / 18,688 |
| `closure` sparse 1024 | 979,983 | **0.95251** [0.95251, 0.95251] | 1.0000007 | 1.0053 [0.9442, 1.0703] | 1.0132 | 46.12 / 46.13 ms | 239,920 / 237,904 |
| `closure` dense 256 | 65,536 | **0.90848** [0.90848, 0.90849] | 1.0000013 | 0.9375 [0.9261, 0.9490] | 0.9947 | 29.93 / 31.80 ms | 23,888 / 23,976 |
| `closure` dense 512 | 262,144 | **0.90665** [0.90665, 0.90665] | 1.0000002 | 0.9366 [0.9289, 0.9444] | 1.0031 | 229.9 / 245.7 ms | 89,284 / 88,124 |
| `samegen` sparse 1024 | 258,691 | **0.98201** [0.98200, 0.98201] | 0.9999973 | 0.9886 [0.9079, 1.0766] | 0.9869 | 6.54 / 6.40 ms | 123,696 / 123,788 |
| `samegen` dense 512 | 507,425 | **0.96163** [0.96162, 0.96163] | 1.0000017 | 0.9770 [0.9111, 1.0477] | 0.9846 | 19.44 / 19.27 ms | 112,216 / 111,352 |

Per-evaluation instruction counts behind those ratios, control against candidate: 45.25 M / 43.11 M,
703.1 M / 669.7 M, 636.8 M / 578.5 M, 5.013 G / 4.545 G, 109.8 M / 107.8 M, 284.5 M / 273.6 M.
Branches are up 1.7 to 4.0 per cent on every cohort while instructions are down; branch misses are
unchanged to within their own nulls (0.987 to 1.007 against nulls of 0.996 to 1.013), so the extra
branches are predicted ones.

**The direct path did not merely hold; it is between 1.8 and 9.3 per cent cheaper in instructions**,
on every cohort, with A/A nulls inside three parts per million and paired intervals narrower than a
hundredth of a per cent. Fermi prediction 3 said "unchanged to within the nulls, and perhaps 0 to
2 per cent from hoisting the run-constant branch"; the measurement is up to five times that, and the
mechanism is the same one, larger than priced: the old loop tested `index.offsets.is_empty()` once
per **delta row** and then, inside the bucket walk, carried both shapes' code, while the new loop is
monomorphized on the index kind and on the head relation's membership kind and dispatched once per
step. The saving is largest where the bucket walk is longest — dense closure, 33.6 M candidates
against 328 K probes, is 9.3 per cent — and smallest where a step yields about one row per probe —
same generation sparse, 261 K candidates against 261 K probes, is 1.8 per cent. That ordering is the
check on the mechanism.

**Cycles follow instructions where the effect is large and are a wash where it is small.** Dense
closure is 0.937 and 0.937 with intervals that exclude unity; the other four sit between 0.977 and
1.025 with cycle A/A nulls of 0.985 to 1.028, so they are not separated from unity and are read as a
wash. The in-process evaluation medians say the same: dense closure 229.9 ms against 245.7 ms and
29.93 against 31.80 ms, everything else within a few per cent either way. **An earlier run of this
same A/B, at the revision before the policy constants were set, reported the sparse-closure cycle
ratio as 1.019 and 1.027 with cycle nulls of 1.012 and 1.010**; the instruction ratios reproduced to
five decimal places and the cycle figures did not, which is the load on a shared box and is why this
lane reads instructions. Both runs are in the sidecar history of the receipt path.

### The frontend and the stratified backend

Control `ergodis-tools-e0e7331` against candidate `ergodis-tools-d2b1940`, five interleaved rounds,
CPU 5, the same event set at **100.00 per cent enabled over 1,625 measurements**, load 2.14 to 2.83.
Receipts `analysis/rel-frontend/performance-v7-sparse-d2b1940.json` and its four per-cohort
siblings; the same five runs at `4bcbc10`, the revision before the policy constants were set, are
committed beside them and agree to the printed digit on every instruction ratio.

| Cohort | `scan` | `parse` | `admit` | `lower` | `stratify` − `lower`, instructions | cycles | peak RSS, candidate / control KiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `ascii` | 1.000004 | 0.999999 | 1.000000 | 1.000000 | 0 against −3 | — | 6,432 / 6,412 |
| `unicode` | 1.000000 | 1.000000 | 1.000000 | 1.000000 | 0 against 0 | — | 6,432 / 6,412 |
| `comment-string` | 0.999973 | 0.999987 | 0.999985 | 0.999999 | 0 against −1 | — | 6,060 / 6,044 |
| `malformed-early` | 0.999996 | 1.000002 | 1.000001 | 1.000003 | 0 against 2 | — | 5,944 / 5,944 |
| `malformed-late` | 0.999994 | 0.999999 | 0.999999 | 0.999999 | 1 against −1 | — | 6,268 / 6,268 |
| `datalog` (512 definitions) | 0.999976 | 0.999994 | 1.000000 | 0.998875 | **0.99516** | 1.0138 | 127,192 / 127,240 |
| `stratified` (128) | 0.999998 | 0.999984 | 1.000003 | 0.999459 | **0.99433** | 0.9935 | 11,408 / 11,420 |
| `columns` (128) | 1.000007 | 0.999987 | 1.000002 | 0.999547 | **0.99432** | 1.0039 | 16,756 / 16,652 |
| `aggregate` (128) | 1.000007 | 0.999983 | 1.000012 | 0.999545 | **0.99499** | 0.9953 | 21,024 / 21,052 |

**Scan, parse, admission and lowering are unity to within twenty-seven parts per million on every
cohort**, so the front end did not move; the five cohorts that never reach the backend measure ±3
instructions on a stage that runs nothing, which is what a real stage should measure there. The
backend stage is 0.4 to 0.6 per cent cheaper on the four that do reach it, from the same
monomorphization the closure family shows at a larger scale, and the plans on these cohorts still
select the direct kind throughout.

**The closure SHA-256 is identical across arms on every one of the four backend cohorts**, over
every relation's certified rows: `dffdcd35…`, `3f5c4cdd…`, `ec562d2c…` and `5c455ad4…`, the same
four digests C1191 recorded. Both independent checkers verified on both arms.

### Reach: the closure and same-generation families

Every row is the candidate `closure_ballpark-1dfc6ed` in `--evaluate-only` mode under
`choom -n 1000`, one process, default row bound unless stated. Peak resident set is the process
high-water mark the harness reads from `/proc/self/status`.

| Program | density | N | facts | derived | membership | peak RSS | outcome |
| --- | --- | ---: | ---: | ---: | --- | ---: | --- |
| `closure` | sparse | 4,096 | 12,288 | 15,679,566 | bitmap, universe 2^24 | 532 MB | runs |
| `closure` | sparse | 8,192 | 24,576 | — | bitmap, universe 2^26 | — | **`Budget`: the row capacity, 2^24** |
| `closure` | dense | 2,048 | 1,048,576 | 4,194,304 | bitmap, universe 2^22 | 303 MB | runs |
| `samegen` | sparse | 8,192 | 8,191 | 15,787,097 | bitmap, universe 2^26 | 1.07 GB | runs |
| `samegen` | sparse | 16,384 | 16,383 | — | bitmap, universe 2^28 | — | **`Budget`: the row capacity, 2^24** |
| `closure` | blocks | 4,096 | 61,440 | 65,536 | bitmap, universe 2^24 | 539 MB | runs |
| `closure` | blocks | 16,384 | 245,760 | 262,144 | bitmap, universe 2^28 | 586 MB | runs |
| `closure` | blocks | 65,536 | 983,040 | 1,048,576 | **sparse**, universe 2^32 | 798 MB | runs; the control refuses this program at **admission** |
| `closure` | blocks | 65,536, row bound 1.1 M | 983,040 | 1,048,576 | sparse | **239 MB** | runs |
| `mutual` | blocks | 4,096 | 61,440 | 61,440 | index sparse, key space 2^24 | 464 MB | runs |
| `mutual` | blocks | 8,192 | 122,880 | 122,880 | index sparse, key space 2^26 | 482 MB | runs; **above the retired `MAX_INDEX_KEYS`** |
| `mutual` | blocks | 65,536, row bound 1.1 M | 983,040 | 983,040 | index sparse, key space 2^32 | 239 MB | runs |
| `cycle` | blocks | 4,096, row bound 100 K | 61,440 | 131,072 | index sparse, key space 2^24, table 131,072 slots | **21 MB** | runs |
| `cycle` | blocks | 65,536, row bound 1.1 M | 983,040 | 2,097,152 | index sparse, key space 2^32, table 2^21 slots | 257 MB | runs |

**The old ceiling, measured on the control.** `closure_ballpark-e0e7331` on `closure` sparse at
N = 65,536 returns `Budget` **from admission**, before any evaluation: 65,536² = 2^32 against
`MAX_UNIVERSE`'s 2^30. That is the refusal the card exists to remove, and it does not depend on the
program's size in any way — the same domain with sixteen edges was refused identically.

**What binds now on the old families, and it is not addressing.** Both generated families are
stopped by `MAX_ROWS = 2^24`, the row capacity of one derived relation. `closure` sparse derives
0.93 N² tuples, so it reaches N = 4,096 (15.68 M rows) and is refused at 8,192; `samegen` sparse
derives 0.115 N² and reaches N = 8,192 (15.79 M rows, of which 8.08 M are the output relation) and is
refused at 16,384. Fermi prediction 1 said exactly this, including that the card's request for
closure and same generation at N = 16,384 and 65,536 is **unreachable on those generators for a
reason that has nothing to do with the index** — their closures do not fit in any workspace this
evaluator will reserve. The prediction was right about the mechanism and right about `MAX_ROWS`.

**The reach the change actually buys is a large domain with a small relation**, which is what the
`blocks` cohorts measure: at N = 65,536 the tuple universe is 2^32 and the relation holds a million
tuples. The control cannot admit that program; the candidate evaluates it in 221 ms with a resident
set of 239 MB when the caller sizes the row bound, and both independent checkers verify the
certificates in the full harness mode.

**A caller's row bound is now a performance decision as well as a limit.** `cycle` at N = 4,096
takes 21 MB with a row bound of 100,000 and the same program reserves 539 MB with the default bound
of 2^24, because every sparse table is sized from the capacity rather than from the rows derived and
every witness column is reserved eagerly. That is the same eager-reservation effect C1191 recorded
as its remaining gap 4, seen from the other side: it is now the dominant term in peak memory on a
cohort whose relation is small.

### Reach: the C1191 boundary cohorts

Bisection over the committed `rel-lower` tool on committed cohorts, with the flags C1191's own
boundary table used (`--max-rows 16777216 --values 262144`), so the two tables are comparable line
for line. Each row is the largest `--definitions` that completes the whole chain — both independent
checkers included — and the first that is refused, with the bound that refuses it and its numbers.
`--definitions` is the dictionary on `stratified`, half of it on `columns`, a third on `columns3`,
and the key set on `aggregate`.

| Cohort | C1191: largest dictionary, and the bound | C1192: largest dictionary | Factor | Materialized there | Peak RSS | First refused, and the bound |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| `stratified` | 2,047 — `MAX_LAYER_TUPLES` | 2,047 | ×1 | 4,187,141 complement | 1.39 GB | 2,048: `MAX_LAYER_TUPLES`, 4,197,376 against 4,194,304 |
| `columns` | 4,092 — `MAX_LAYER_TUPLES` | 4,092 | ×1 | 4,183,050 complement | 2.72 GB | 4,094: `MAX_LAYER_TUPLES`, 4,195,326 against 4,194,304 |
| `columns3` | 255 — **`MAX_INDEX_KEYS`** | **483** | **×1.89** | 4,173,200 complement | 3.14 GB | 486: `MAX_COMPLEMENT`, 4,251,528 against 4,194,304 |
| `aggregate` | 4,096, key set 1,412 — **`MAX_INDEX_KEYS`** | **5,934, key set 2,046** | **×1.45** | 2,092,035 filter | 2.31 GB | key set 2,047: `MAX_LAYER_TUPLES`, 4,196,350 against 4,194,304 |

**Nothing on this route is stopped by an addressing bound any more.** Before this task, two of the
four cohorts were: `columns3` and `aggregate` stopped at `domain^arity` against 2^24, which is a
property of arity and dictionary size and not of what the program computes. All four are now stopped
by a budget the route declares for itself — how many tuples one layer may materialize, or how many
complement facts one negated literal may have — and both numbers are about materialization. That is
the shape C1191's closeout asked for and could not reach.

**The `stratified` and `columns` boundaries are unchanged to the definition**, which is the control
this table needs: the two cohorts that were already stopped by `MAX_LAYER_TUPLES` did not move, and
their peak resident sets reproduce C1191's 1.39 GB and 2.73 GB.

**A second bound was behind the addressing one on `columns3`, and it is not the one C1191 expected.**
That cohort's negated relation has arity three with each column a third of the dictionary, so its
complement is `(d/3)³`; the refusal at a dictionary of 486 is `MAX_COMPLEMENT` at 4,251,528 against
4,194,304, exactly `162³`. The backend's own check was also the conservative one of the two: it
compared `dictionary^arity` for every indexed relation, while the evaluator indexes on
`domain^popcount(mask)`, which for a join with a free column is smaller by a factor of the
dictionary. On `columns3` that is 258³ against 258², so **part of this cohort's ×1.89 is the removal
of a mirror that was stricter than the thing it mirrored**, and the report says so rather than
crediting it all to the sparse index.

### The crossover, measured

Both arms are the **same binary** with the kind of one structure forced, so the two do identical
work on identical input and the comparison is not confounded by a compiler difference. Five
interleaved rounds, CPU 5, repeat counts 3 and 6, the six-event set, `--evaluate-only` so the
counters are the derivation loop's. Each row's density is the structure's key space divided by the
row capacity the caller asked for, which is the number the policy reads. Receipts
`analysis/datalog-comparison/ab-2026-09-16-c1192-crossover-{membership,index}[-high].json`.

**The membership test: the bitmap wins everywhere it exists.**

| Cohort | universe | row bound | density | sparse over bitmap, instructions | cycles | A/A null |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` blocks 4,096 | 2^24 | 16,777,216 | 1 | 1.2128 | 2.0489 | 1.0000122 |
| `closure` blocks 4,096 | 2^24 | 4,194,304 | 4 | 1.2041 | 1.6609 | 1.0000105 |
| `closure` blocks 4,096 | 2^24 | 1,048,576 | 16 | 1.2019 | 1.3434 | 1.0000145 |
| `closure` blocks 4,096 | 2^24 | 262,144 | 64 | 1.2118 | 1.2666 | 0.9999859 |
| `closure` blocks 4,096 | 2^24 | 65,536 | 256 | 1.2323 | 1.3517 | 1.0000088 |
| `closure` blocks 16,384 | 2^28 | 16,777,216 | 16 | 1.2027 | 2.0960 | 1.0000011 |
| `closure` blocks 16,384 | 2^28 | 4,194,304 | 64 | 1.2005 | 1.6800 | 0.9999962 |
| `closure` blocks 16,384 | 2^28 | 1,048,576 | 256 | 1.2420 | 1.6006 | 1.0000041 |
| `closure` blocks 16,384 | 2^28 | 262,144 | 1,024 | 1.2556 | 1.3827 | 1.0000074 |
| `closure` blocks 32,768 | 2^30 | 2,097,152 | 512 | 1.1983 | 1.4822 | 1.0000005 |
| `closure` blocks 32,768 | 2^30 | 524,288 | 2,048 | 1.2295 | 1.3093 | 1.0000091 |

**There is no crossover for the membership test inside what the ceiling allows.** The last row is a
tuple universe of 2^30, which is `MAX_DIRECT_UNIVERSE` exactly and a 128 MiB bitmap, against a row
capacity of 524,288 — and the bitmap is still ahead by 1.23 in instructions and 1.31 in cycles. The
mechanism is the one C1186 recorded from the other side: a bitmap probe resolves the
"is this tuple new" branch from one bit, and the sparse probe puts a hash, a chained load and a tuple
comparison against the row store on that branch's dependency chain. **So the policy has no density
rule for membership: the bitmap is kept whenever it exists**, and the sparse membership test is what
makes a universe above the ceiling evaluable at all.

The sparse arm gets *worse* as the row bound rises — 1.35 at a bound of 65,536 against 2.05 at
16,777,216 on the same program — because the table is presized from the capacity the caller asked
for and `fill(NONE)` writes all of it before every evaluation, while the bitmap is sized from the
universe and does not move. That is the same eager-reservation effect the reach table shows in
memory, appearing here in time.

**The join index over an input relation: the counting-sorted bucket wins too.**

| Cohort | key space | capacity (facts) | density | sorted over CSR, instructions | cycles |
| --- | ---: | ---: | ---: | ---: | ---: |
| `mutual` blocks 4,096 | 2^24 | 61,440 | 273 | 1.3916 | 2.0745 |
| `mutual` blocks 4,096, bound 2^20 | 2^24 | 61,440 | 273 | 1.3919 | 2.4254 |
| `mutual` blocks 4,096, bound 2^22 | 2^24 | 61,440 | 273 | 1.3920 | 2.1495 |
| `mutual` blocks 4,096, bound 2^24 | 2^24 | 61,440 | 273 | 1.3920 | 2.1635 |

A static index is built once at preparation and never rebuilt, so the direct shape pays no
per-evaluation reset at all and its only cost is the offsets array, which `MAX_DIRECT_KEYS` bounds.
The sparse shape pays a binary search over 61,440 distinct keys — about sixteen dependent loads
against one — on every probe. The four rows are the same index under four row bounds, which is the
check that the caller's bound does not reach a static index: the ratio moves by four parts in ten
thousand across them. **So the policy has no density rule for an input relation's index either.**

**The join index over a relation that grows: this is the one crossover, and it is in cycles.**

| Cohort | key space | row bound | density | sparse over direct, instructions | cycles | A/A null |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `cycle` blocks 4,096 | 2^24 | 16,777,216 | 1 | 1.0650 | 1.5000 | 0.9999918 |
| `cycle` blocks 4,096 | 2^24 | 4,194,304 | 4 | 1.0504 | 1.2285 | 1.0000063 |
| `cycle` blocks 4,096 | 2^24 | 1,048,576 | 16 | 1.0467 | 1.0665 | 1.0000047 |
| `cycle` blocks 4,096 | 2^24 | 524,288 | 32 | 1.0461 | 1.0508 | 0.9999996 |
| `cycle` blocks 4,096 | 2^24 | 262,144 | 64 | 1.0516 | **0.9842** | 0.9999954 |
| `cycle` blocks 4,096 | 2^24 | 131,072 | 128 | 1.0528 | **0.9911** | 1.0000081 |
| `cycle` blocks 4,096 | 2^24 | 65,536 | 256 | 1.0620 | **0.9743** | 0.9999841 |

**The crossover in cycles is between a density of 32 and a density of 64**: the direct kind is ahead
by 5.1 per cent at 32 and behind by 1.6 per cent at 64. `DIRECT_INDEX_DENSITY` is set to **48**,
inside that bracket; anywhere in it costs at most about five per cent on one side. A dynamic index
*is* rebuilt every evaluation, and the direct shape writes one word per key of
`domain^popcount(mask)` to do it — 64 MiB here — while the sparse shape writes one word per presized
slot. That reset traffic is the whole of the effect, and it is why this structure has a crossover
and the other two do not.

**Instructions say "always direct" on every one of the three structures, and Fermi prediction 2 said
they would.** The sparse kind costs 4.6 to 6.5 per cent more instructions on the dynamic index, 20
to 26 per cent more on the membership test and 39 per cent more on the static index, at every
density measured. `PERFORMANCE.md` says instruction ratios decide; here they decide only the
direction of the constant factor, and what sets the policy is the memory traffic the two shapes move,
which is the playbook's own second rule of attack ranked above instructions. **This is stated as the
one place in this lane where a cycle ratio is load-bearing**, with the qualification that the cycle
A/A nulls in these runs are within 2 parts per 10,000 of unity — much tighter than the
control-against-candidate run's, because both arms are the same binary — so the 0.974 to 1.051 band
that brackets the crossover is separated from unity by more than the noise floor.

## Profile

Kernel-scoped: `perf record -e instructions:u -F 4000` pinned to CPU 5 on
`closure_ballpark --evaluator demand --program closure --certificates 512 dense 20`, a harness mode
that evaluates twenty times and generates the two certificates and nothing else — no checker, no
serialization, no output file — so the evaluator's symbols are better than 98 per cent of the
profile. Both arms have that mode, which is why it is the one profiled rather than the kernel-only
mode this task adds, which the control does not have. `perf.data` under
`~/.cache/ergodis/perf-c1192/`.

| Symbol | control `e0e7331` | candidate `d2b1940` |
| --- | ---: | ---: |
| `ergodis_rules::demand::Demand::evaluate_into` | 81.53 % | 76.55 % |
| `__memmove_avx512_unaligned_erms` | 17.29 % | 22.14 % |
| `ergodis_rules::demand::Demand::certificate` | 0.67 % | 0.73 % |
| `ergodis_rules::demand::Demand::index_rows` | 0.25 % | 0.30 % |

Nothing else clears a tenth of a per cent on either arm. `Demand::read`, `Demand::emit`,
`Demand::join` and `Demand::run` do not appear because they are all inlined into `evaluate_into`,
which is the whole monomorphized derivation loop.

**Out-of-line calls inside the loop, listed as the playbook requires: there is exactly one, and it
is the same one on both arms.** `__memmove_avx512_unaligned_erms` is the runtime-length
`copy_from_slice` that `Demand::read` uses to lift a tuple out of a row store and `Demand::emit`
uses to write one back — a copy of `arity` words, two of them here. No allocator symbol, no
formatting, no panic path, no trait-object dispatch and no hash-table symbol appears in either
profile.

Its **share** rises from 17.3 to 22.1 per cent, and that is the arithmetic of a smaller denominator
rather than a larger numerator: the measured stage is 4.545 G instructions on the candidate against
5.013 G on the control, so 22.14 per cent of the candidate is about 1.006 G and 17.29 per cent of the
control is about 0.867 G — which, as the playbook warns, is a pair of estimates from shares and not a
measurement. What the two profiles do establish is that the loop's only remaining out-of-line call is
the tuple copy, and that it is now the largest single thing left in it. **That is C1188's target, and
it is taken in the next section.**

### C1188 taken: the tuple copy, removed and measured

The card's scope note allowed the queued C1188 work to be taken if it fell out of the derivation
loop naturally. It did: the profile above shows one out-of-line call, the loop was already open, and
the change is two element loops. It is a separate commit, `ergodis` `24e399e`, and it is measured
separately against the revision before it.

Fermi, written from the profile before the change: the call is a `copy_from_slice` over two words,
so nearly all of its cost is the call itself — argument setup, the call and return, and libc's own
length dispatch — and the profile put it at 22.1 per cent of the loop. **I predicted 10 to 18 per
cent off the loop's instructions**, uniform across cohorts because the copy is per tuple read and
per tuple written and every cohort does both.

A/B between `closure_ballpark-d2b1940` and `closure_ballpark-b7921a0`, the same workspace with only
that commit between them, five interleaved rounds, CPU 5, `--evaluate-only`:

| Cohort | derived | instruction ratio [lo, hi] | A/A null | cycle ratio |
| --- | ---: | ---: | ---: | ---: |
| `closure` sparse 256 | 62,979 | **0.89459** [0.89459, 0.89460] | 1.0000078 | 0.7904 |
| `closure` sparse 1,024 | 979,983 | **0.89458** [0.89458, 0.89459] | 1.0000008 | 0.7715 |
| `closure` dense 256 | 65,536 | **0.89473** [0.89472, 0.89473] | 0.9999963 | 0.7100 |
| `closure` dense 512 | 262,144 | **0.89473** [0.89473, 0.89473] | 1.0000001 | 0.7065 |
| `samegen` sparse 1,024 | 258,691 | **0.89392** [0.89391, 0.89392] | 0.9999989 | 0.7653 |
| `samegen` dense 512 | 507,425 | **0.89431** [0.89431, 0.89431] | 1.0000013 | 0.7879 |
| `closure` blocks 16,384 | 262,144 | **0.89486** [0.89484, 0.89489] | 0.9999937 | 0.7190 |
| `mutual` blocks 4,096 | 61,440 | **0.89308** [0.89291, 0.89326] | 0.9999883 | 0.9220 |

**10.5 per cent fewer instructions on every cohort, and 8 to 29 per cent fewer cycles**, with the
instruction ratios agreeing to four decimal places across eight cohorts that differ by two orders of
magnitude in size and by which structures they use. That uniformity is the evidence that this is a
per-tuple cost and not a cohort effect, and it is what the Fermi predicted; the figure landed at the
low end of the 10 to 18 per cent band.

The cycle win is much larger than the instruction win — 0.71 on dense closure — which says the
removed call was also costing a pipeline stall, not only instructions. `mutual` is the exception at
0.92 cycles, and its shape explains it: one non-recursive rule whose join yields one row per probe,
so the loop is dominated by the index probe rather than by the tuple copies.

Profile after, same command and same scope as the table above: `evaluate_into` **98.36 per cent**,
`__memmove_avx512_unaligned_erms` **0.11 per cent**, `certificate` 0.90, `index_rows` 0.33. **The
derivation loop now has no out-of-line call at any threshold this profile resolves**; the memmove
residue is the workspace reset before the loop and the certificate's cold pass, neither of which is
inside it.

Compounding the two changes, the derivation loop on these cohorts is at 0.81 to 0.88 of the control's
instructions — `0.90665 × 0.89473 = 0.8113` on dense closure at 512 — with identical rows, identical
work counts and identical certificates.

## Exactness

| Gate | Outcome |
| --- | --- |
| Core `cargo test --all-features` at `24e399e` | 80 test binaries, zero failures, including the new `demand_sparse` suite and the constructor and derivation allocation regressions |
| Private `cargo test -p ergodis-private -p ergodis-tools` at `b7921a0` | 42 test binaries, zero failures; this drives `rel_lowering`, `rel_frontend`, `rel_frontend_portability` and `rel_reference_eval` (the C1189 differential), all of which pass |
| C1189 differential | **zero disagreements** over the committed fixtures, the recorded rejection surface, the Addendum A equations, the surface-construct table and the seeded corpora, at their unchanged seeds |
| Clippy, both repositories, `--all-targets --all-features -D warnings` | no diagnostics |
| `cargo fmt --check`, both repositories | clean |
| `SHA256SUMS` regenerated with every source change | `tests/evidence_manifest.rs` passes, public lint clean on every commit |
| Closure SHA-256 across A/B arms, four backend cohorts | identical: `dffdcd35…`, `3f5c4cddcd…`, `ec562d2c3f…`, `5c455ad47f…` — the same four C1191 recorded |
| Output SHA-256 across A/B arms, eight closure/same-generation/`blocks`/`mutual` cohorts | identical on every cohort of every A/B; `ab.py` fails a run rather than summarizing it when they differ, and none did |
| Derived, probe and candidate counts across arms | identical on every cohort of every A/B |
| Certificate agreement between the two addressing kinds | **byte-identical**, asserted on the fixtures, the generated closure family at two row bounds, and every program of the property corpus |
| Zero allocations in the derivation loop | 100 repeated evaluations of `same_generation.json` under the counting allocator, **under each of `Policy::Auto`, `Policy::Direct` and `Policy::Sparse`**: 0 |
| Deliberate mutations | deleting either key-column comparison in `Demand::join` derives tuples outside the least model and fails `demand_sparse`; recorded in that file's doc comments as load bearing |

**What the corpus does and does not establish, stated as weak evidence.** The two addressing kinds
answer the same query, so a corpus that exercises the query can only see them agreeing; the
byte-identical certificate is a stronger statement than a set comparison but it is still an
agreement. The load-bearing evidence that the gates discriminate is the two deliberate mutations,
and finding a case that exercised them took three attempts, which is recorded under deviations
because the first two attempts are the instructive part: the multiply-shift hash is close to
injective on the key ranges every other cohort uses, so their buckets hold one key and never reach
the comparison at all.

## Disposition

**Kept**, by the forward commits in the table above; nothing is reverted. Two changes, measured
separately:

1. **The sparse addressing kind and the monomorphized loop** (`ergodis` `84ed62c`, `d0a0ef3`,
   `6ab0dd5`): the direct path is 0.907 to 0.982 of the control's instructions where it is still
   selected, the reach moves from "a binary relation is capped at a domain of 32,768" to "the
   largest admitted domain, at any size the rows allow", and two of the four Rel-route cohorts move
   their boundary.
2. **The tuple copy** (`ergodis` `24e399e`, C1188): 0.893 to 0.895 of the instructions on every
   cohort, 0.71 to 0.92 of the cycles, and the loop's last out-of-line call is gone.

Compounded, the derivation loop is at 0.81 to 0.88 of the control on the existing cohorts.

## Recorded deviations

1. **The row bound moved into the plan**, which the card did not ask for. `Demand::new_bounded` and
   `from_prepared_bounded` take it, `workspace()` replaces `workspace_bounded`, and a workspace of
   one plan is refused by another. The policy reads the rows a structure can hold, so the bound
   cannot be a property of the workspace if the selection is to be a preparation-time decision.
2. **`workspace()` returns `Result`.** The card asks for the replacement bounds to be "reachable
   through the same `Error` values"; a reservation the machine cannot back is one of them, and an
   infallible constructor cannot report it. Every caller in both repositories is migrated.
3. **`MAX_UNIVERSE` was removed as well as `MAX_INDEX_KEYS`.** The card names only the index. On the
   closure and same-generation families the index bound was never what bound — their join masks have
   population count one — so removing it alone would have moved nothing there. `datalog::universe`
   saturates, because `domain^arity` at the largest admitted domain and arity is exactly `2^64`.
4. **The membership test grew a second kind too.** The card asks for "a second index kind". The
   presence bitmap is the other direct-addressed structure, it is what `MAX_UNIVERSE` bounded, and
   it is the one the reach cohorts need; it is built on the same table and selected by the same
   policy.
5. **The policy has one measured density, not two.** The first shape had a density rule for each
   structure. Measurement removed two of them: the bitmap and the input relation's counting-sorted
   index are faster at every density their ceilings allow, so for those the ceiling decides alone.
6. **`Policy` has five variants, and the first shape of two of them was wrong.** `SparseIndexes`
   originally left the other structure to the policy, which at exactly the densities that matter
   chooses sparse too; the comparison then moved both structures and could attribute nothing. Each
   now forces both kinds, one sparse and one direct.
7. **C1188 was taken**, in its own commit and with its own A/B, because the profile showed it as the
   loop's only remaining out-of-line call and the loop was open. Its queue row is not archived here.
8. **Two harness cohorts and one edge generator were added**, which the card did not ask for: the
   `blocks` density, the `mutual` program and the `cycle` program. Without them neither the reach
   claim nor the index crossover has a cohort — the generated closure and same-generation families
   cannot reach a large domain at all, for the reasons the reach table gives.
9. **`analysis/datalog-comparison/ab.py` is new.** C1184's and C1186's A/Bs on these families were
   run by an uncommitted loop, so those receipts cannot be replayed from a revision. The driver is
   committed before the source change it measures.
10. **The `--evaluate-only` harness mode is new**, and the control does not have it, so the
    control-against-candidate A/B runs both arms in the full mode instead. Everything outside the
    derivation loop runs once there whatever the repeat count, so the two-point difference is still
    the loop's cost; the kernel-only mode is what the candidate-against-candidate comparisons and the
    profile use.

## Remaining gaps

1. **No Soufflé comparison on the new sizes.** The card asks for one through the existing harness if
   it runs in reasonable time. `compare.py` takes an arbitrary density, so `closure:blocks:65536` is
   one invocation away and Soufflé 2.5 is in the store; it was not run. *Evidence gap*: the
   product-path claim on the large-domain cohorts has no external engine beside it, so the reach is
   established against this evaluator's own earlier refusal and not against Soufflé.
2. **The native/WASM parity replay was not re-run**, only the portability test inside the private
   suite, which passes. C1191's argument that the parity corpus compares the lowered relational IR
   and is structurally downstream of anything an evaluator does still holds, but the hash is not
   re-recorded here.
3. **Nothing is measured above a membership density of 2,048 or an index density of 256**, because
   the ceilings and the cohort shapes stop there. The membership conclusion — no crossover inside
   the ceiling — is therefore about the reachable range and not about the structure in general.
4. **The sparse table is sized from the caller's row bound, not from the rows.** A caller that
   over-declares pays for it twice: in reservation, and in the `fill(NONE)` before every evaluation,
   which is 64 MiB at a bound of `2^24`. The crossover tables show it as a 1.35 to 2.05 spread on one
   program. A table that grew once at the first round boundary would fix it and would break the
   allocation-free rule; a table sized from the previous evaluation's row count would not.
5. **Peak resident set at the new boundary is gigabytes**, unchanged from C1191's remaining gap 4 and
   now with a second cause: 3.14 GB on `columns3` at a dictionary of 483. The eager row reservation
   is most of it, and `cycle` at 21 MB against 539 MB on the same program with a sized bound is the
   measurement of that.
6. **`MAX_WORKSPACE_BYTES` is a number chosen, not measured**: `2^34`. It is a refusal that no cohort
   here reaches, and its only test constructs a program to exceed it.

## Mystery ledger

1. **Settled, and it corrects the card and the programme review: `MAX_INDEX_KEYS` was never what
   bound the closure and same-generation families.** Both documents say the direct-addressed join
   index caps every binary relation at a domain of 4,096. That is true of an index whose key mask
   names two columns, which is what `columns3` and `aggregate` have. Closure and same generation
   index on one column, so their key space is the domain and the bound they met was
   `MAX_UNIVERSE`'s membership bitmap at a domain of 32,768 — and behind that, `MAX_ROWS`. Fermi
   prediction 1 said this before any code and the measurement confirms it. *Nothing about this item
   is open.*

2. **Settled, and it is the more useful half: the reach the change buys is a large domain with a
   small relation, and the old families cannot show it.** The generated closure derives 0.93 N² and
   the generated same generation 0.115 N², so both hit the row capacity of `2^24` long before any
   addressing bound: closure at N = 8,192 and same generation at N = 16,384. The card's request for
   those two families at N = 16,384 and 65,536 is unreachable **under any index change**, and the
   task added the `blocks` cohorts to have a family whose tuple universe is quadratic and whose size
   is linear. At N = 65,536 that program has a universe of `2^32`, holds a million tuples, and is
   refused at admission by the control. *Nothing about this item is open.*

3. **Settled, and it is the one that changes the design rule: the two structures have different
   crossovers, and only one has a crossover at all.** A dynamic join index is rebuilt before every
   evaluation and its direct shape writes one word per key to do it, so above a density of about 48
   the reset traffic outweighs the extra instructions. A membership bitmap is written once per
   evaluation at one **bit** per key — eight times less traffic per key, and thirty-two times less
   than the index's four bytes — and an input relation's counting-sorted index is not rewritten at
   all. Neither of those has a crossover anywhere its ceiling allows. The design rule this replaces
   is "a compressed representation needs a crossover policy": it needs one **per structure**, and
   the answer can be "no crossover; the ceiling decides", which is a measurement and not an
   omission. *Nothing about this item is open.*

4. **Settled the hard way, and it is a warning about testing a hash: the multiply-shift hash is
   close to injective on the key ranges every natural cohort uses, so the key-column comparison the
   sparse bucket needs is almost never exercised.** Two designed collision tests passed with the
   comparison deleted — one with 8,128 rows in 8,192 slots and sixteen constant-keyed probes across
   128 values each. The reason is structural: for keys below `domain²` with a table of at least the
   row count, the product's high bits are very nearly a bijection, and in particular two tuples that
   share a column never collided in any configuration searched (four domains × four table sizes,
   exhaustively). The test that does discriminate forces the table to **one slot**, by preparing the
   plan with a row bound of one. *Nothing about this item is open, but the lesson is recorded: a
   collision test that hopes for a collision is not a test.*

5. **Settled: the direct path got faster, and by five times what the Fermi priced.** Prediction 3
   said 0 to 2 per cent from hoisting the run-constant branch out of the delta loop; the measurement
   is 1.8 to 9.3 per cent, ordered exactly as the mechanism predicts — largest where the bucket walk
   is longest (dense closure, 33.6 M candidates against 328 K probes, 9.3 per cent) and smallest
   where a step yields about one row per probe (same generation sparse, 1.8 per cent). The Fermi
   priced the removed *test* and not what monomorphizing the bucket walk does to the whole loop
   body. *Nothing about this item is open.*

6. **Open: the sparse membership test is 1.20 to 1.26 times the instructions at every density, and
   the instruction count should not depend on the density at all.** A probe is a hash, a load and a
   tuple comparison whatever the table's size, so the *instruction* ratio ought to be flat and it
   is — but it is flat at 1.20 to 1.26 while the *cycle* ratio swings from 1.31 to 2.10 over the same
   rows. The cycle swing is explained (the `fill(NONE)` scales with the table). What is not measured
   is the instruction-level decomposition of the flat 20 to 26 per cent: how much is the hash, how
   much the chain walk's extra loads, and how much the tuple comparison. *Evidence gap*: a
   class-decomposition in the playbook's sizing shape — per-unit instruction costs of a probe under
   each kind from single-class synthetic inputs, checked against a census of the cohort's probes.
   Nobody has done it, and it would say whether a sparse membership test could be made competitive
   or is structurally 20 per cent behind.

7. **Open, inherited and now with a second cause: nothing bounds a layer's memory, and the
   reservation is eager.** `columns3` at a dictionary of 483 is 3.14 GB. C1191 recorded the eager
   row reservation; this task adds that every sparse table is also sized from the caller's row bound
   and is *touched* before every evaluation, so an over-declared bound costs time as well as address
   space — measured at 1.35 against 2.05 on one program. *Evidence gap*: unchanged from C1191, a
   measured bytes-per-materialized-tuple figure and a decision about whether the layer bound should
   be expressed in bytes; and now also whether a workspace should size its tables from the previous
   evaluation's row count.

8. **Open and small: the C1188 cycle win is much larger than its instruction win** — 0.71 cycles
   against 0.89 instructions on dense closure — which says the removed call was costing a stall and
   not only instructions. The obvious candidate is the call/return pair sitting between a load of the
   row store and the dependent branch, but no cache-event run was taken. *Evidence gap*: the
   supplementary counter run (`cache-references,cache-misses,L1-dcache-loads,
   L1-dcache-load-misses`) with its own null, which this task did not run for any arm.

No discovery-track entry: everything found was inside what the task was looking for, with one
exception already folded into item 4 above rather than logged, because it is a property of this
evaluator's own hash and not an incidental observation about anything else.

## Replay commands

Run from `~/src/ergodis-private` unless stated. Every gate and every measurement was run under
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so the gates and the measurements describe one build.

```sh
# Gates, core.
cd ~/src/ergodis
nix develop . --command cargo test --all-features -j 8
nix develop . --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
nix develop . --command cargo fmt --all -- --check
cd ~/src/ergodis-private

# Gates, private. This drives rel_lowering, rel_frontend, rel_frontend_portability
# and rel_reference_eval, which is the C1189 differential.
nix develop ~/src/ergodis --command cargo test -p ergodis-private -p ergodis-tools -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private -p ergodis-tools \
    --lib --bins --tests --examples -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check

# The arms. Each is retained from a checkout at its own revision; the script
# retains whatever the tree carries and names the binary for it.
git checkout e0e7331 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout e0e7331 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
git checkout d2b1940 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout d2b1940 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
git checkout b7921a0 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release

A=analysis/datalog-comparison
CTL=~/.cache/ergodis/bin/closure_ballpark-e0e7331
CAND=~/.cache/ergodis/bin/closure_ballpark-d2b1940
C1188=~/.cache/ergodis/bin/closure_ballpark-b7921a0
W=~/.cache/ergodis/c1192/ab-work

# The direct path, where the policy still selects the direct kind for every
# structure. Both arms in the full harness mode, which is the one the control has.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CTL --a-name control \
    --b $CAND --b-name candidate --mode full --rounds 5 --cpu 5 --repeats 3 \
    --cohorts closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512 \
    --work $W --out $A/ab-2026-09-16-c1192-direct.json

# C1188, the tuple copy, on its own.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CAND --a-name memmove \
    --b $C1188 --b-name elements --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512,closure:blocks:16384,mutual:blocks:4096 \
    --work $W --out $A/ab-2026-09-16-c1188-memmove.json

# The crossover: one binary, one structure's kind forced on each arm.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CAND --a-name bitmap --b $CAND --b-name sparse \
    --a-args "--index direct" --b-args "--index sparse-membership" --mode evaluate \
    --rounds 5 --repeats 3 --cpu 5 --cohorts closure:blocks:4096,closure:blocks:16384 \
    --sweep "--max-rows 65536;--max-rows 262144;--max-rows 1048576;--max-rows 4194304;--max-rows 16777216" \
    --work ~/.cache/ergodis/c1192/sweep-work --out $A/ab-2026-09-16-c1192-crossover-membership.json
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CAND --a-name bitmap --b $CAND --b-name sparse \
    --a-args "--index direct" --b-args "--index sparse-membership" --mode evaluate \
    --rounds 5 --repeats 3 --cpu 5 --cohorts closure:blocks:32768 \
    --sweep "--max-rows 524288;--max-rows 2097152" \
    --work ~/.cache/ergodis/c1192/sweep-work --out $A/ab-2026-09-16-c1192-crossover-membership-high.json
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CAND --a-name direct --b $CAND --b-name sparse \
    --a-args "--index direct" --b-args "--index sparse-indexes" --mode evaluate \
    --rounds 5 --repeats 3 --cpu 5 --cohorts cycle:blocks:4096,mutual:blocks:4096 \
    --sweep "--max-rows 262144;--max-rows 1048576;--max-rows 4194304;--max-rows 16777216" \
    --work ~/.cache/ergodis/c1192/sweep-work --out $A/ab-2026-09-16-c1192-crossover-index.json
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CAND --a-name direct --b $CAND --b-name sparse \
    --a-args "--index direct" --b-args "--index sparse-indexes" --mode evaluate \
    --rounds 5 --repeats 3 --cpu 5 --cohorts cycle:blocks:4096 \
    --sweep "--max-rows 65536;--max-rows 131072;--max-rows 524288" \
    --work ~/.cache/ergodis/c1192/sweep-work --out $A/ab-2026-09-16-c1192-crossover-index-high.json

# The frontend and the stratified backend.
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
B=analysis/rel-frontend
T=~/.cache/ergodis/bin/ergodis-tools-d2b1940
C=~/.cache/ergodis/bin/ergodis-tools-e0e7331
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T --control $C \
    --rounds 5 --cpu 5 --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v7-sparse-d2b1940.json
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T --control $C \
    --rounds 5 --cpu 5 --cohorts datalog --stages scan,parse,admit,lower,stratify \
    --events $E --out $B/performance-v7-sparse-datalog-d2b1940.json
for c in stratified columns aggregate; do
  nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T --control $C \
      --rounds 5 --cpu 5 --cohorts $c --definitions 128 \
      --stages scan,parse,admit,lower,stratify --events $E \
      --out $B/performance-v7-sparse-$c-d2b1940.json
done

# The reach table. One process each, no certificates, no checkers.
R=~/.cache/ergodis/c1192/work
for a in "--program closure 4096 sparse" "--program closure 8192 sparse" \
         "--program closure 2048 dense" "--program samegen 8192 sparse" \
         "--program samegen 16384 sparse" "--program closure 4096 blocks" \
         "--program closure 16384 blocks" "--program closure 65536 blocks" \
         "--program mutual 4096 blocks" "--program mutual 8192 blocks"; do
  choom -n 1000 -- $CAND --evaluator demand --evaluate-only $a 1 $R
done
for a in "--program closure 65536 blocks" "--program mutual 65536 blocks"; do
  choom -n 1000 -- $CAND --evaluator demand --evaluate-only $a 1 $R --max-rows 1100000
done
choom -n 1000 -- $CAND --evaluator demand --evaluate-only --program cycle 4096 blocks 1 $R --max-rows 100000
choom -n 1000 -- $CAND --evaluator demand --evaluate-only --program cycle 65536 blocks 1 $R --max-rows 1100000
# The old ceiling, on the control: Budget from admission, before any evaluation.
choom -n 1000 -- $CTL --evaluator demand --program closure 65536 sparse 1 $R

# The boundary table. Each pair is the largest --definitions that runs and the
# first that is refused; the tool prints the budget, the number and the limit.
TOOL=~/.cache/ergodis/bin/ergodis-tools-d2b1940
F="--max-rows 16777216 --values 262144"
for n in 2047 2048; do choom -n 1000 -- $TOOL rel-lower --cohort stratified --definitions $n --max-tuples 0 $F; done
for n in 2046 2047; do choom -n 1000 -- $TOOL rel-lower --cohort columns    --definitions $n --max-tuples 0 $F; done
for n in 161 162;   do choom -n 1000 -- $TOOL rel-lower --cohort columns3   --definitions $n --max-tuples 0 $F; done
for n in 2046 2047; do choom -n 1000 -- $TOOL rel-lower --cohort aggregate  --definitions $n --max-tuples 0 $F; done

# The kernel-scoped profile, both arms and after C1188.
for arm in e0e7331 d2b1940 b7921a0; do
  taskset -c 5 perf record -q -e instructions:u -F 4000 \
      -o ~/.cache/ergodis/perf-c1192/closure-dense-$arm.data -- \
      ~/.cache/ergodis/bin/closure_ballpark-$arm --evaluator demand --program closure \
      --certificates 512 dense 20 $R
  perf report -q -i ~/.cache/ergodis/perf-c1192/closure-dense-$arm.data \
      --no-children --percent-limit 0.1 --sort symbol
done
```

Inputs are deterministic: the C1182 xorshift64 generators seeded by the domain (closure
`0x9E3779B97F4A7C15 ^ N`, same generation `0x2545F4914F6CDD1D ^ N`) and the `blocks` density, which
uses no random stream at all.

## What this task left under `~/.cache/ergodis/`

`bin/closure_ballpark-e0e7331` and `bin/ergodis-tools-e0e7331` are the two controls, retained from a
clean tree before the first source change. `bin/closure_ballpark-d2b1940` and
`bin/ergodis-tools-d2b1940` are the candidate arms every figure above except C1188's was measured
on, and `bin/closure_ballpark-b7921a0` is the arm after C1188 — **the control the next A/B should
use**. `bin/closure_ballpark-1dfc6ed` is the superseded candidate whose A/B was re-run at `d2b1940`;
`bin/ergodis-tools-4bcbc10` likewise. `bin/c1188probe-d2b1940` is a probe built from a dirty tree
before C1188 was committed, and nothing cites it; it is byte-identical to
`closure_ballpark-b7921a0`, measured sha256 `08b488430c2ffd1f3443d22364756eb85b018282d961108b2d8010a3507063d3`.

Under `perf-c1192/` (572 KB): the three kernel-scoped profiles. Under `c1192/` (5.1 MB): the A/B
work directories, the fact files the reach probes emitted, and the `perf stat` outputs the receipts'
enabled fractions were read from.

`../ergodis-dev/scripts/cache-gc.sh` was run in its listing mode and nothing was deleted. It scanned
44 entries and showed eight as unreferenced and old enough to remove, none of them this task's: the
largest are `worktrees` at 105 MB, `split` at 31 MB and `representation-attribution` at 16 MB, all
from other lanes. This task's `perf-c1192` and `c1192` are held as younger than two days, and every
binary this report names shows as referenced. Deletion is the user's call.

## The control for the next A/B

`~/.cache/ergodis/bin/closure_ballpark-b7921a0`, measured sha256
`08b488430c2ffd1f3443d22364756eb85b018282d961108b2d8010a3507063d3`, retained from a clean tree at
`ergodis-private` `b7921a0` with core `ergodis` `24e399e` under rustc 1.95.0 (59807616e 2026-04-14).
For the frontend and the stratified backend, `~/.cache/ergodis/bin/ergodis-tools-d2b1940`, measured
sha256 `f6b5234dfe5b9e2286b101e85ca7020386be2ad4bc4531bbd5b8654f4dea7646` — **which does not carry
C1188**, because no `ergodis-tools` was retained after it. A backend A/B should retain one first.

## Vibe check

Good, and the reach moved further than the card's own framing expected — but not where the card
looked. The two admission ceilings are gone as refusals and survive as policy ceilings at their old
values, so a program that ran before makes the same choices and the direct path is measurably
**faster** rather than merely unmoved: 0.907 to 0.982 of the control's instructions, and 0.81 to
0.88 once C1188's tuple copy goes too. A binary relation is no longer capped at a domain of 32,768
whatever its size; `closure` over 65,536 values with a million tuples runs in 221 ms and 239 MB, and
the control refuses that program at admission before it looks at a single fact.

The correction worth carrying forward is that `MAX_INDEX_KEYS` was never what bound the closure and
same-generation families — their join masks name one column — so the card's and the programme
review's "every binary relation is capped at a domain of 4,096" is true only of a two-column mask.
What bound them was the membership bitmap, and behind it the row capacity, which is still what stops
them: both families derive a quadratic number of tuples, so neither can reach N = 16,384 under any
index change. The reach this buys is a large domain with a small relation, and the task had to add a
cohort to have one.

The crossover came out as three answers rather than one. Only the dynamic join index has a crossover
(density 48, in cycles, because it is the one structure rebuilt before every evaluation); the
membership bitmap and the input relation's counting-sorted index are faster at every density their
ceilings allow, by 1.2 to 2.4 times, so for those the ceiling decides alone and that is a measured
decision. Instructions favour the direct kind everywhere, which makes this the one place in this lane
a cycle ratio is load bearing, and the report says so rather than quietly reporting the metric that
agrees.

Two blemishes. There is no Soufflé row on the new sizes, which the card asked for and which is one
`compare.py` invocation away. And finding a test that discriminates the sparse bucket's key
comparison took three attempts: the hash is close to injective on every natural key range, so two
carefully designed collision cohorts passed with the comparison deleted, and what works is forcing
the table to a single slot.
