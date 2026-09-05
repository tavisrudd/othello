# C1066: the sparse matcher's event-queue discipline

**Lane**: `complete-ports` · **Date**: 2026-09-05 · **Code**: `~/src/ergodis-private`
**Predecessor**: `2026-09-05-c1065-sparse-matcher-weighted-fixed-cost.md`
**Code commits**: ergodis-private `942c824` (heap, reverted at `b40d232`), `9388928` (rejected
undo-list variant, reverted), `10367e8` and `5a22cbe` (the dispatch); retained binaries
`ergodis-tools-3265238` (C1065 control, SHA-256 `67512487…3edb`), `ergodis-tools-04adbc8`
(pre-C1065 control, `2de68dad…df33`), `ergodis-tools-942c824` (heap, `a3e8feab…5858`),
`ergodis-tools-35be85f` (rejected variant, `aed27830…f8c4`), `ergodis-tools-5a22cbe` (the
dispatch, `3837deff…44ab`)
**Status**: complete — the heap is rejected on measurement and the queue discipline is now compiled from the graph's largest edge weight

## Headline

**The binary heap that C1065 proposed loses on both noise models, and the reason is that the
queue is push dominated about eight to one — 176 pushes against 22 pops per solved block — which
is a bucket queue's best case and a heap's worst.** The bucket queue therefore stays, and with it
the horizon refusal path, which exists only because the bucket window is finite and has never
been observed to fire. What C1065's other proposal asked for is done instead: the queue's
clearing and scanning discipline is now chosen once, when the graph is compiled, by whether any
edge weighs more than one, so a unit-weight graph carries none of the occupancy bitmap the
weighted graphs need.

## What was asked

C1065 closed with two proposals and predicted they might be decided together.

1. Replace the bucket queue with a small binary heap, which would also retire the horizon
   refusal path.
2. If the published phenomenological grid is worth protecting, compile two solve paths and
   dispatch on the compiled largest edge weight, so unit-weight graphs stop paying the 1 to 4
   per cent that C1065's machinery costs them.

They were decided together, but not the way the prediction ran: the heap lost, so the second
proposal is no longer a choice between two bitmaps but between having the bitmap and not.

## The heap, and why it loses

The heap is a min-heap over one fixed array of sixteen-byte entries ordered by a packed key: the
event time in the high thirty-two bits, the lane bit below it, and the push sequence
complemented in the low thirty-one. One unsigned comparison then reproduces the bucket lanes'
order exactly — by time, main lane before late lane, last in first out within a tick — which the
work counts confirm: on every one of the seventy-three cells the heap build answers with
identical events, pushes, stale pops and logical error rate, so the comparison is cost alone.
It removes the bucket array, the modulus, the occupancy bitmap, the summary words, the entry
free list, the per-shot bucket clear, and the clock window, and with the window gone the horizon
refusal and its counter go too. It is `942c824`, retained as `ergodis-tools-942c824`.

Measured against the retained C1065 control `ergodis-tools-3265238` at level four, three
interleaved rounds, two-size differencing, so every shot goes to the matcher. Above one is a
loss (`benchmarks/tiger-blossom/2026-09-05-c1066-942c824-weighted-level4-ab.log`, the surface
family of the weighted circuit-level grid; the run was stopped once the verdict was uniform and
is kept as the interrupted negative control it is):

| cell                       | instructions | cycles |
|----------------------------|--------------|--------|
| surface `d = 3`, `p=0.0005` | 0.994        | 1.230  |
| surface `d = 5`, `p=0.001`  | 1.032        | 1.208  |
| surface `d = 7`, `p=0.002`  | 1.114        | 1.399  |
| surface `d = 9`, `p=0.0005` | 1.082        | 1.369  |
| surface `d = 9`, `p=0.001`  | 1.116        | 1.455  |
| surface `d = 9`, `p=0.01`   | 1.259        | 1.747  |

And on the eighteen phenomenological cells
(`2026-09-05-c1066-942c824-phenomenological-level4-ab.log`), 1.014 to 1.015 in instructions at
`p = 0.001` on every distance, 1.010 to 1.064 at `p = 0.01`, and 1.001 to 1.136 at `p = 0.05`.

The cycle ratios are worse than the instruction ratios everywhere, and the branch counters say
why: at surface `d = 7` and `p = 0.01` the heap takes 2,327 branch misses per decode against the
control's 970, a factor of 2.4. A sift is a data-dependent loop whose length depends on the key
just pushed; a bucket push is a masked index and two stores.

**The mechanism is the push-to-pop ratio.** On surface `d = 9` at `p = 0.001` the matcher
answers 15,359 blocks with 345,566 popped events and 2,709,759 pushes: 22.5 pops and 176.4
pushes per block. Most entries are never popped at all — the solve ends when the last defect is
matched and abandons whatever is still queued. A heap charges every push a sift; a bucket queue
charges it a store, and pays only on the pops. The bitmap C1065 added had already removed the
scan the heap was meant to replace, so the heap arrived with its cost and without its saving.

**The horizon refusal path therefore stays.** It is the bounded return the contract requires for
a finite window, it costs one compare per push that predicts perfectly, and `reason_horizon` is
zero on every one of the seventy-three cells measured here and on both controls. Retiring it was
a consequence of the heap, not a goal reachable without it.

## The two-path dispatch

`SparseMatcher` is now generic over `WEIGHTED`, which is the compiled graph's own answer to
whether any edge weighs more than one, and the kernel holds a `SparseArm` that constructs one
instantiation or the other when the graph is compiled. Neither carries the other's branch, and
only the selected arm is allocated.

The weighted arm is exactly C1065's matcher. The unit-weight arm drops the occupancy bitmap and
its summary words — no allocation, no push-side maintenance, no release-side clear — pops by
walking the clock forward one bucket at a time, which is the pop the phenomenological grid was
measured on before C1065 and is two loads when the next event is one or two ticks away, and
clears by filling the bucket heads, which are a couple of cache lines on such a graph. The undo
lists, the priced clear crossover, and every event rule are shared.

The build is `5a22cbe`, retained as `ergodis-tools-5a22cbe`. Every one of the seventy-three cells
answers with the same logical error rate, the same answered and declined counts by cause, and the
same event, push and stale-pop traffic as the C1065 control, so both arms are the same search and
the A/Bs below are cost alone.

**What it buys the phenomenological grid**, candidate over the C1065 control, three interleaved
rounds at level four, below one being a gain
(`benchmarks/tiger-blossom/2026-09-05-c1066-5a22cbe-phenomenological-level4-ab.log`, instructions):

| distance | `p = 0.001` | `p = 0.01` | `p = 0.05` |
|----------|-------------|------------|------------|
| 3        | 0.999       | 0.994      | 0.980      |
| 5        | 1.000       | 0.987      | 0.977      |
| 7        | 0.999       | 0.987      | 0.977      |
| 9        | 0.999       | 0.986      | 0.979      |
| 15       | 0.998       | 0.985      | 0.980      |
| 25       | 0.998       | 0.987      | 0.984      |

**How much of C1065's cost that recovers**, the same build against the pre-C1065 control
`ergodis-tools-04adbc8` — the binary the published C1061 and C1063 numbers were measured on
(`2026-09-05-c1066-5a22cbe-vs-pre-c1065-phenomenological-ab.log`, instructions):

| distance | `p = 0.001` | `p = 0.01` | `p = 0.05` |
|----------|-------------|------------|------------|
| 3        | 1.001       | 1.006      | 1.016      |
| 9        | 1.002       | 1.014      | 1.017      |
| 15       | 1.001       | 1.028      | 1.018      |
| 25       | 1.001       | 1.022      | 1.022      |

C1065 left that grid at 1.001 to 1.003 at `p = 0.001` and 1.037 to 1.044 at `p = 0.05`. The
operating rows were never far from the pre-C1065 build and still are not; the stress rows come
back about halfway, from four per cent to two. In cycles the same comparison is 0.96 to 1.03 at
the stress rates, so what remains is within the cycle measurement's spread.

**What it costs the weighted grid**, which is the model a deployed decoder consumes: 1.000 to
1.004 in instructions over all thirty-three operating cells, 1.001 on every surface cell and
rising to 1.004 on repetition `d = 25`
(`2026-09-05-c1066-5a22cbe-weighted-level4-ab.log`). That is not the split — the weighted arm's
code is C1065's, unchanged — but the enum resolution: the kernel holds a `SparseArm` and matches
it when it solves, certifies, and reads the events count for a block. Reading the pairing through
one slice accessor instead of one call per defect took the figure from 1.002 to 1.001 on the
surface family; removing the rest would mean threading the choice up through `decode_batch` to
the batch boundary, which doubles the const-generic surface of the kernel's public entry points
for another tenth of a per cent, and is recorded as available rather than done.

**The trade, stated plainly.** The deployed weighted model pays at most 0.4 per cent so that the
published phenomenological grid gets 1.6 to 2.3 per cent back at its stress rates and 0.1 to 0.2
at its operating rate. Both figures are small. The structural argument is the stronger one: a
unit-weight graph now carries neither the bitmap's maintenance nor its memory, and the choice is
compiled rather than branched, which is the shape the performance contract asks for. Whether that
is worth keeping is Tavis's call; the measurement is here either way.

## Rejected along the way

**Turning the undo lists off on unit-weight graphs** (`35be85f`, reverted). The lists exist
because a scale-32 model sizes the workspace by the largest edge weight, so the guess was that a
unit-weight graph, whose workspace is a few kilobytes, would rather fill than track. Measured
against the C1065 control on the eighteen phenomenological cells
(`2026-09-05-c1066-35be85f-phenomenological-level4-ab.log`): 1.013 to 1.015 in instructions at
`p = 0.001` on every distance, and about even at the stress rates. A sparse shot names a handful
of keys while the fill still writes the whole workspace, so the list is the cheaper clear on a
unit-weight graph too, and the priced crossover already decides that correctly. This is why the
dispatch above splits the bitmap and not the lists.

## Gates

The debug random suite with the no-late-entry oracle, the `I1`/`I2` feasibility assertion after
every event, and the weighted-graph case C1065 added; the release kernel tests including the
zero-allocation `decode_batch` gate; library clippy `-D warnings` and `rustfmt`; and, for every
build measured here, an exact census parity sweep against the retained C1065 control over all
seventy-three cells — eighteen phenomenological and fifty-five weighted — comparing the logical
error rate, the answered, declined and uncertified counts, the decline counters by cause, and the
event, push, subtree and stale-pop traffic. Every build in this task matched the control on every
cell, which is the strongest exactness statement available here: the candidates do not merely
agree on the answer, they run the same search.

The workspace-wide clippy run carries ten pre-existing findings in other tools modules
(`actual_cause_report`, `generic_certificate_bench`, `local_commit_bench`,
`profile_vocabulary_bench`), none of them in the matcher or its bench. They are foreign to this
lane and were left alone; one of them, a duplicated `#[test]`, turned out to matter and is
covered in the C1067 audit.

Provenance: the working tree carried another task's uncommitted changes under `src/causal_*`
throughout, which the retained-binary manifest records as dirty. Those modules are not on any
decode path and the `tiger_blossom*` sources were at the named commits in each build.

## Mystery ledger

**Settled: whether the bucket queue should exist at all.** C1065 left this as "the more
interesting question" and predicted the heap would win on weighted graphs. It does not, on either
model, and the reason is structural rather than incidental: the queue takes about eight pushes
per pop because a solve abandons what is still queued when its last defect is matched, and a heap
charges its logarithm on the push side. Any priority-queue discipline with a non-constant push is
excluded by that ratio, so this closes the queue-discipline question rather than just the heap.

**Settled: whether the horizon refusal path can be retired.** Only by removing the window, which
means the heap, which loses. The path stays. It has never fired: `reason_horizon` is zero on all
seventy-three cells for every build measured here.

**Open: the last two per cent of C1065's phenomenological cost.** The dispatch recovers about
half of the stress-rate cost. The rest is not the bitmap — that is gone from the unit-weight arm
— and not the undo lists, since removing those loses more than they cost. The candidates are the
per-key bookkeeping the lists need whether or not they are used and the code layout of a binary
that now holds two matcher monomorphizations. The evidence gap is an instruction-level profile of
one dense unit-weight decode against the pre-C1065 control; nobody has taken one.

**Open: whether the enum resolution is worth removing.** It is the whole of the weighted grid's
0.1 to 0.4 per cent. Threading `WEIGHTED` up to `decode_batch` would remove it and would double
the const-generic surface of the kernel's public entry points. Owner: a successor, if a tenth of
a per cent on the deployed model ever matters more than the API.

**Open, unchanged from C1065 and C1064: the six PyMatching losses and the third code family** for
the mean-degree crossover rule. Nothing here touches either; the PyMatching standing is unchanged
because the search is unchanged, and the routing thresholds are the C1065 constants.

## Vibe check

Good, and the useful part is that both of C1065's proposals turned out to be answerable by
measurement rather than by taste. The heap was the more attractive idea and it lost cleanly, for
a reason that is worth more than the change would have been: the queue is push dominated, which
tells you what kind of structure it wants. The dispatch is real but small, and the trade it makes
— a tenth of a per cent on the deployed model for two per cent on the published one — is close
enough to even that it deserves a decision rather than an assumption.

## Next

1. C1067's audit of the matcher against the performance contract, which found and priced a
   larger effect than anything in this task.
2. The third code family for the mean-degree crossover rule, unchanged from C1064 and C1065.
3. The six remaining PyMatching losses, where the lever is now the touch loop and the
   certificate's closure reads rather than the queue.
