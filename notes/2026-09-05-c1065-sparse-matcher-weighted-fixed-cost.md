# C1065: the sparse matcher's fixed per-shot cost on weighted graphs

**Lane**: `complete-ports` · **Date**: 2026-09-05 · **Code**: `~/src/ergodis-private`
**Brief**: `2026-09-04-c1065-sparse-matcher-fixed-cost-brief.md`
**Code commits**: ergodis-private `2065c6b`, `6e2ce12`, `f17e7a7`, `3265238`; retained binaries
`ergodis-tools-04adbc8` (control, SHA-256 `2de68dad…df33`), `ergodis-tools-f17e7a7`
(`b295e718…dc71`), `ergodis-tools-3265238` (`67512487…3edb`)
**Status**: complete — the fixed cost is attributed and removed, the routing threshold is refitted
on the cheaper matcher, and the weighted PyMatching standing is restated

## Headline

**The matcher's fixed per-shot cost was workspace clearing and a bucket walk, both proportional to
the graph and to the largest edge weight, and removing them makes the matcher 13 to 47 per cent
cheaper at every operating rate — at surface `d = 9` a three-defect decode falls from 1,338 ns to
379 ns.** The routing threshold refits left with it, from nine to seven on repetition graphs and
fifteen to fourteen on surface graphs, which is worth a further 5 to 17 per cent on the repetition
family. Against PyMatching the standing improves but does not reverse: in instructions the losing
cells go from seven to six of thirty-three, and in cycles from five to three, all of them the two
largest surface graphs at the higher rates. Exactness is unchanged: zero weight and zero prediction
disagreements on all thirty-three cells.

## Where the fixed cost lived

C1064 left the attribution open: on a weighted circuit-level model the sparse matcher costs about
the same at three defects as at six, and the mystery-ledger item asked for a profile of one
low-defect weighted decode attributing that to initialization, workspace clearing, or the pair
matrix.

It is workspace clearing and the bucket scan, and the pair matrix is not on the path at all —
`solve_all_by_region_growth` hands the whole defect set to the matcher and prices only the pairing
it returns, so neither the pair matrix nor the cluster adjacency is built.

`perf record` over 163,840 decodes of surface `d = 9` at `p = 0.0005` on the retained control
`ergodis-tools-04adbc8`, level four, self time by symbol:

| symbol                                        | self  |
|-----------------------------------------------|-------|
| `SparseMatcher::solve` (inlined reset and pop) | 40.4% |
| `ShotGenerator::draw_events` (not the decoder) | 19.7% |
| `SparseMatcher::touch_node`                    | 15.3% |
| `__memset_avx512_unaligned_erms`               | 9.2%  |
| `SparseMatcher::push_event`                    | 3.0%  |

Inside `solve`, instruction-level annotation splits the 40.4 per cent three ways: about a quarter of
it is the five `fill` calls that reset the remembered event times, about a quarter the scattered
per-region stores, and about a fifth the bucket walk in the pop loop. The 9.2 per cent of `memset`
is the rest of the reset — the node records and the bucket heads, which are large enough that the
compiler calls the library routine. Clearing and scanning together are therefore roughly half of the
decode at that cell, and both are proportional to the compiled graph rather than to the shot.

Two mechanisms produce that, and the weight range is what makes them visible:

1. **The reset refilled the whole workspace every shot**: one node record per detector, one
   remembered time per edge, one per detector for the boundary, and two lanes of bucket heads.
   `sparse_horizon` is `4 * max boundary distance + 4 * max_weight + 16`, so a scale-32 model with
   weights 141 to 263 has thousands of buckets where a unit-weight model has a few dozen. On surface
   `d = 9` that is about 93 KiB of clearing per shot, against about 4 KiB on the phenomenological
   graph of the same distance.
2. **The pop walked one bucket per clock unit.** The clock advances by about half an edge weight per
   event, so on a weighted graph a pop steps over a hundred or more empty buckets on two lanes;
   under unit weights the next event is one or two ticks away.

Both predict a cost that grows with the largest edge weight and not with the defect count, which is
what C1064 measured, and both explain its scale-8 control: a coarser quantization shrinks the
modulus and the tick gaps together.

## What changed

Three commits, each behind the same certificate and ratchet:

1. **An occupancy bitmap over the bucket queue** (`2065c6b`): one bit per bucket, set while either
   lane holds an entry, with one summary bit per sixty-four of those words. A pop takes the next
   occupied bucket from the bitmap instead of walking the gap, and a reset clears only the buckets
   an entry reached. **Undo lists** in the same commit bound the node-record and remembered-time
   restoration to what the solve wrote.
2. **A priced crossover between the two clears** (`6e2ce12`): the list-only build lost at the stress
   rates, because a dense shot on a small graph names most of the detectors and most of the edges
   and restoring those one dependent store at a time is slower than the streaming fill. Each clear
   now takes whichever is cheaper for the shot that just ran — the list while it names under a
   quarter of the detectors or under a sixteenth of the remembered-time cells, the fill otherwise.
3. **Bitmap writes on a lane's first entry only, and no recording for a shot the fill will clear**
   (`f17e7a7`): the unconditional two read-modify-writes per push were most of what the change cost
   at the stress rates, and a lane that already holds an entry has its bit set. Recording is
   likewise skipped when the keys per defect measured on the last recorded solve, times the count
   the next one starts from, says the reset will be the fill anyway. The clear never trusts that
   prediction — only the counts the solve actually produced.

## What the matcher costs now

The arm profile, 200,000 shots per graph at `p = 0.001`, nanoseconds per decode on the sparse arm,
control against candidate on surface `d = 9`
(`benchmarks/tiger-blossom/2026-09-05-c1065-f17e7a7-weighted-arm-profile.log` against C1064's):

| defects | control | candidate | ratio |
|---------|---------|-----------|-------|
| 3       | 1,338   | 379       | 0.28  |
| 5       | 1,521   | 638       | 0.42  |
| 6       | 1,530   | 739       | 0.48  |
| 8       | 1,724   | 996       | 0.58  |
| 16      | 2,625   | 2,231     | 0.85  |

The flatness that identified the cost as fixed is gone: the matcher's cost now rises with the defect
count from 379 ns rather than starting at 1,338 ns and barely moving. What remains at the low counts
is the search itself.

## The matcher on the whole weighted grid

Interleaved, three rounds, two-size differencing, level four, so every shot goes to the matcher and
the comparison is the matcher alone. Candidate `f17e7a7` over the control `04adbc8`, so below one is
a gain (`benchmarks/tiger-blossom/2026-09-04-c1065-f17e7a7-weighted-level4-ab.log`).

| family     | d  | `p = 0.0005` | `p = 0.001` | `p = 0.002` | `p = 0.01` | `p = 0.05` |
|------------|----|--------------|-------------|-------------|------------|------------|
| surface    | 3  | 0.709        | 0.685       | 0.663       | 0.784      | 0.972      |
| surface    | 5  | 0.645        | 0.693       | 0.760       | 0.980      | 1.042      |
| surface    | 7  | 0.677        | 0.768       | 0.898       | 1.026      | 1.026      |
| surface    | 9  | 0.656        | 0.804       | 0.987       | 1.028      | 1.016      |
| surface    | 11 | 0.672        | 0.866       | 1.021       | 1.022      | 1.011      |
| repetition | 3  | 1.000        | 1.001       | 0.950       | 0.791      | 0.846      |
| repetition | 5  | 0.952        | 0.925       | 0.836       | 0.774      | 0.925      |
| repetition | 7  | 0.876        | 0.796       | 0.743       | 0.779      | 0.980      |
| repetition | 9  | 0.919        | 0.756       | 0.739       | 0.819      | 1.007      |
| repetition | 15 | 0.707        | 0.679       | 0.701       | 0.931      | 1.022      |
| repetition | 25 | 0.535        | 0.561       | 0.667       | 1.023      | 1.017      |

Read the shape rather than the individual cells: the gain is largest exactly where the fixed cost
dominated — a sparse shot on a large graph — and shrinks to nothing where the shot is dense enough
that the search dwarfs the entry. The three cells at or just above one at the operating rates are
surface `d = 11` at `p = 0.002`, where the mean is 44 defects, and the two repetition `d = 3` cells,
whose 24-detector graph the change barely touches. In cycles the operating rows are 0.34 to 1.02
with the same shape; the tiny repetition `d = 3` and `d = 5` cells read above one in cycles while
their instruction ratios are 1.000, which is the timer on a sub-hundred-instruction decode, not a
change in the code those shots run.

At the stress rates the change costs 2 to 4 per cent on the surface family. That is the residual of
the bookkeeping the bitmap and the undo lists add per event, on shots whose reset is the fill
anyway; the profile after the change matches the control's shape symbol for symbol, so there is no
single line left to remove.

## The routing threshold, refitted

The crossovers move left, which they must when the arm the rule gates gets cheaper. Same protocol as
C1064 — the smallest defect count from which the sparse arm is the cheapest at that count and every
larger one, over 200,000 shots per graph:

| graph               | detectors | edges | mean degree | C1064 | C1065 |
|---------------------|-----------|-------|-------------|-------|-------|
| repetition `d = 5`  | 24        | 65    | 5.42        | 8     | 8     |
| repetition `d = 9`  | 80        | 225   | 5.62        | 10    | 6     |
| repetition `d = 15` | 224       | 645   | 5.76        | 8     | 8     |
| repetition `d = 25` | 624       | 1,825 | 5.85        | 10    | 8     |
| surface `d = 7`     | 336       | 1,558 | 9.27        | 14    | 14    |
| surface `d = 9`     | 720       | 3,534 | 9.82        | 16    | 14    |
| surface `d = 11`    | 1,320     | 6,718 | 10.18       | 16    | 14    |

The mean-degree step survives — the two families are still cleanly apart, every repetition graph
under six neighbours per detector and every surface graph over — so only the two constants move,
each again the middle of its measured range: **fewer than six neighbours per detector gives seven,
six or more gives fourteen**, still `edges < 3 * nodes` in the integers the compiler sees. The
unit-weight branch is untouched.

Two graphs sit outside the fit and are recorded rather than fitted on. The 24-detector surface model
still has no crossover the sweep can see: no count up to ten, the largest bucket that fills at one
per cent error, ever becomes the matcher's. And surface `d = 5` measures seventeen at one per cent
error, three above its branch; routing it at fourteen costs 15 per cent at exactly fourteen defects
on that graph, which is a stress-rate count on a 120-detector graph whose operating mean is 1.8.

What the refit is worth, measured directly as the routed arm with the new constants against the
routed arm with the old ones, same kernel, three interleaved rounds
(`benchmarks/tiger-blossom/2026-09-05-c1065-threshold-refit-routed-ab.log`):

| family     | d  | `p = 0.0005` | `p = 0.001` | `p = 0.002` |
|------------|----|--------------|-------------|-------------|
| surface    | 7  | 1.000        | 1.009       | 1.014       |
| surface    | 9  | 1.007        | 1.017       | 1.003       |
| surface    | 11 | 1.004        | 1.002       | 1.000       |
| repetition | 7  | 1.000        | 0.954       | 0.950       |
| repetition | 9  | 1.010        | 1.000       | 0.882       |
| repetition | 15 | 0.980        | 0.856       | 0.845       |
| repetition | 25 | 0.862        | 0.829       | 0.928       |

The repetition family gains 5 to 17 per cent; the surface family pays at most 1.7 per cent in
instructions and nothing in cycles (surface `d = 9` at `p = 0.001` is 1.004 in cycles with the
interval spanning one, and surface `d = 7` at `p = 0.002` is 1.000). The cells not listed are the
small graphs where no shot reaches either threshold and every ratio is 1.000.

## The PyMatching standing, restated

Same protocol as C1064 — three interleaved rounds, two-size differencing, PyMatching 2.4.0 built
from the same shot files and the same quantized integer weights, the routed arm — over the
thirty-three operating cells
(`benchmarks/tiger-blossom/2026-09-05-c1065-weighted-vs-pymatching-operating.log`). Ratios are Tiger
over PyMatching, so below one means Tiger is ahead; C1064's figure follows each in parentheses.

| family     | d  | `p = 0.0005`      | `p = 0.001`       | `p = 0.002`       |
|------------|----|-------------------|-------------------|-------------------|
| surface    | 3  | 0.201 (0.189)     | 0.152 (0.092)     | 0.170 (0.166)     |
| surface    | 5  | 0.131 (0.139)     | 0.217 (0.211)     | 0.389 (0.396)     |
| surface    | 7  | 0.250 (0.250)     | 0.558 (0.562)     | **1.100** (1.115) |
| surface    | 9  | 0.571 (0.584)     | **1.168** (1.226) | **1.718** (1.736) |
| surface    | 11 | 0.962 (**1.102**) | **1.511** (1.690) | **2.039** (1.997) |
| repetition | 3  | 0.328 (0.703)     | 0.278 (0.269)     | 0.243 (0.244)     |
| repetition | 5  | 0.161 (0.170)     | 0.146 (0.192)     | 0.122 (0.106)     |
| repetition | 7  | 0.126 (0.113)     | 0.113 (0.115)     | 0.128 (0.137)     |
| repetition | 9  | 0.104 (0.098)     | 0.118 (0.110)     | 0.200 (0.219)     |
| repetition | 15 | 0.096 (0.097)     | 0.228 (0.279)     | 0.575 (0.718)     |
| repetition | 25 | 0.239 (0.288)     | 0.635 (0.887)     | **1.096** (1.533) |

Tiger is now ahead in twenty-seven of the thirty-three cells and behind in six, marked in bold;
C1064 had twenty-six and seven. The cell that flips is surface `d = 11` at `p = 0.0005`, from 1.102
to 0.962. The rest of the movement is in the margin rather than the verdict: repetition `d = 25` at
`p = 0.002` goes from 1.533 to 1.096 and at `p = 0.001` from 0.887 to 0.635, and the surface losses
narrow by a few per cent each. Surface `d = 11` at `p = 0.002` is the one cell that moves the wrong
way, 1.997 to 2.039, which is the refitted threshold sending a few more shots to the matcher on the
graph where the matcher is furthest behind.

In cycles the standing is better than in instructions, as it was in C1064: surface `d = 7` at
`p = 0.002` is 0.841, surface `d = 9` at `p = 0.001` is 0.982, and repetition `d = 25` at
`p = 0.002` is 0.904, so only three cells lose in cycles — surface `d = 9` at `p = 0.002` (1.121)
and surface `d = 11` at `p = 0.001` and `p = 0.002` (1.134 and 1.284) — against five in C1064.

The account of why those cells lose is unchanged and this task does not overturn it: at 22 to 44
mean defects nearly every shot is above the routing threshold, the kernel is running sparse region
growth on a genuinely weighted graph, and that is the regime PyMatching 2's sparse blossom
implementation was built for. What C1065 removes is the entry cost, which those shots amortize.

## Exactness, latency, and memory

**Exactness.** PyMatching 2.4.0 verified against the routed arm on all thirty-three operating cells
at 20,000 freshly emitted shots each
(`benchmarks/tiger-blossom/2026-09-05-c1065-weighted-pymatching-exactness.txt`): zero weight
disagreements and zero prediction disagreements in every cell, as in C1064.

**Latency**, 200,000 shots, routed arm, `p = 0.001`, control against candidate
(`benchmarks/tiger-blossom/2026-09-05-c1065-weighted-latency-operating.txt`), nanoseconds:

| graph               | control p50/p90/p99  | candidate p50/p90/p99 | budget |
|---------------------|----------------------|-----------------------|--------|
| surface `d = 7`     | 180 / 972 / 3,356    | 180 / 982 / 3,266     | 7 µs   |
| surface `d = 9`     | 1,202 / 3,727 / 6,152| 1,282 / 3,386 / 6,142 | 9 µs   |
| surface `d = 11`    | 4,769 / 7,243 / 12,323 | 3,838 / 6,422 / 11,501 | 11 µs |
| repetition `d = 15` | 30 / 71 / 791        | 30 / 80 / 692         | 15 µs  |
| repetition `d = 25` | 120 / 2,004 / 2,805  | 170 / 822 / 1,343     | 25 µs  |

Surface `d = 11` gains a fifth at the median and 7 per cent at the ninety-ninth percentile, which
brings it just inside its window at this rate rather than over it. Repetition `d = 25` loses 42 per
cent at the median and gains 59 and 52 per cent at the upper quantiles: the refitted threshold sends
mid-sized shots to the matcher, which costs a little on the modal shot and much less on the tail.
Each row is one run, not an interleaved A/B, so read the quantiles as indicative and the maxima —
single outliers, unstable between runs — as nothing at all.

**Memory.** Peak resident set over the same runs: 12,384 to 12,464 KiB at surface `d = 7` and 21,824
to 21,900 at `d = 9`, so the bitmap and the two undo lists cost under one per cent of the process.
The lists are sized to the compiled graph and never grow.

## What it costs on the phenomenological grid

The unit-weight graphs pay for this and get nothing back, because on them the fixed cost was already
small: the modulus is a few dozen buckets rather than thousands, and the next event is one or two
ticks away. Same protocol, the eighteen published phenomenological cells at level four
(`benchmarks/tiger-blossom/2026-09-05-c1065-phenomenological-level4-ab.log`): 1.001 to 1.003 at
`p = 0.001`, 1.012 to 1.044 at `p = 0.01`, and 1.037 to 1.041 at `p = 0.05`. So the C1063 and C1061
numbers measured on that model move against the kernel by at most 4.4 per cent, on the stress rows,
and no verdict on that grid changes — Tiger was ahead there by 3.3 to 11.4 times.

That is the trade this task makes, and it is deliberate: the model a deployed decoder consumes is
the circuit-level one, where the same machinery is worth 13 to 47 per cent. Avoiding the trade
altogether would mean compiling two solve paths and dispatching on the graph's largest edge weight
once per shot, which is the sanctioned shape for a run-constant choice but touches every function
that pushes an event; it is recorded as a successor rather than done here.

## Closeout: the quantization scale is no longer free money

C1064 left "drop the quantization scale from 32 to 8" as a proposal worth 7 to 8 per cent, and
explained it by the largest edge weight setting the bucket-queue modulus. That explanation was
right, and it is exactly what this task removed, so the saving is gone with it
(`benchmarks/tiger-blossom/2026-09-05-c1065-weight-scale-retest.txt`, whole-process instructions
over 81,920 routed decodes, one run each):

| cell                              | control, scale 8 / 32 | candidate, scale 8 / 32 |
|-----------------------------------|-----------------------|-------------------------|
| surface `d = 9`, `p = 0.001`      | 0.958                 | 0.996                   |
| repetition `d = 25`, `p = 0.001`  | 0.946                 | 0.996                   |

A coarser scale now buys about 0.4 per cent instead of 4 to 5, so the grid does not have to be
restated on a different scale, and the shipped scale of 32 — the one that spreads the weights far
enough that minimum-weight witnesses are unique and the two decoders never disagree on a prediction
— stays without costing anything. C1064's open successor is closed by this measurement rather than
by a decision.

## Rejected along the way

**The undo list as the only clear.** Measured as `2065c6b` against the control on the weighted grid
at level four (`benchmarks/tiger-blossom/2026-09-04-c1065-2065c6b-list-only-partial-ab.log`, an
interrupted run kept as the negative): 0.65 to 0.73 at the operating rates on the surface family,
but 1.07 at surface `d = 3` and `p = 0.05`, 1.10 and 1.15 at surface `d = 5` and `p = 0.01` and
`p = 0.05`, and 1.13 at surface `d = 7` and `p = 0.01`. A clear whose cost is proportional to what
the shot touched is not automatically the cheaper clear.

## Gates

The debug random suite with the no-late-entry oracle and the `I1`/`I2` feasibility assertion after
every event, now including a weighted graph; the release kernel tests including the zero-allocation
`decode_batch` gate; library clippy `-D warnings` and `rustfmt`; PyMatching 2.4.0 weight and
prediction agreement; and interleaved A/Bs against retained controls.

Provenance: every retained binary was built from a working tree carrying another task's uncommitted
changes under `src/causal_*`, which the manifest records as dirty. Those modules are not on any
decode path and the `tiger_blossom*` sources were at the named commits in each build, so the
comparison is between the commits it names.

**The weighted suite is new** and is part of the deliverable rather than a convenience: every
mechanism this task touches is weight-sensitive, and the existing suite compiles unit weights, where
the next event is one or two ticks away and the modulus is a few dozen. The new case draws edge
weights from the operating band of a scale-32 model (141 to 263) over repetition graphs at distances
5, 9 and 15, and asserts that every instance is answered, certified, and equal to brute force.

Two debug-only assertions were added with the change and both are part of the ratchet: after every
reset, that no bucket head, node record, or remembered time survived without an undo entry; and at
every pop, that an occupied bucket has an entry. The queue oracle now walks the queue through the
bitmap, which is what the pop path sees, so an entry the bitmap has lost surfaces as the missing
entry it is.

## Mystery ledger

**Settled: where the matcher's fixed cost lived.** C1064's open item asked whether it was
initialization, workspace clearing, or the pair matrix. It was workspace clearing and the bucket
walk in the pop path, both proportional to the compiled graph and to the largest edge weight; the
pair matrix is not on the sparse arm at all. The instruction-level profile of the control at surface
`d = 9` and `p = 0.0005` attributes about half the decode to the two together, and removing them
takes a three-defect decode on that graph from 1,338 ns to 379 ns.

**Settled: whether the quantization scale was worth changing.** No longer. The 7 to 8 per cent
C1064 measured was the bucket modulus, and with the modulus no longer swept or scanned per shot the
same change buys about 0.4 per cent. The grid stays on scale 32.

**Open: why the change costs 2 to 4 per cent on dense shots and on every unit-weight graph.** The
residual is the per-event bookkeeping — a bitmap write on a lane's first entry, a bit clear when a
lane empties, an undo entry per key first reached — on shots that amortize the entry cost anyway.
The profile after the change matches the control's symbol for symbol, so there is no single line to
remove; the named remedy is compiling two solve paths and dispatching on the compiled largest edge
weight, which is the sanctioned shape for a run-constant choice and touches every function that
pushes an event. Owner: a successor, if the phenomenological grid is judged worth protecting.

**Open, and now the more interesting question: whether the bucket queue should exist at all.** Its
modulus is set by `4 * max boundary distance + 4 * max_weight + 16`, which on a weighted graph is
thousands of buckets to hold the seven to thirty entries a solve actually queues, and that mismatch
is what produced both costs this task removed. A small binary heap over the same entries would be
about five comparisons per operation with no bucket array, no modulus, no occupancy bitmap, and no
`reason_horizon` failure mode at all — the refusal path that exists only because the window is
finite. The evidence gap is a measured A/B of the two queue disciplines on the same kernel; the
prediction is that the heap wins on weighted graphs and loses on unit-weight ones, which is the
same trade as above and might be decided once instead of twice.

**Open, unchanged from C1064: whether the mean-degree account of the crossover is causal.** This
task refits both branches on the same two families and the step still separates them cleanly, which
is consistent with the account but is not a third point. The gate remains a third code family with
an intermediate degree, stated in advance and then measured.

**Open, unchanged from C1064: the six remaining PyMatching losses.** They are the two largest
surface graphs from `p = 0.001` up, surface `d = 7` at `p = 0.002`, and repetition `d = 25` at
`p = 0.002`, and in cycles only three of those survive. Every one is a cell where nearly every shot
is above the routing threshold, so the lever is now the search itself — the touch loop and the
certificate's closure reads — and not the entry.

## Vibe check

Good, and the shape of the win is the useful part: the thing C1064 called the highest-value question
in the kernel turned out to be two mechanisms that had nothing to do with matching and everything to
do with clearing and scanning arrays sized for the weight range. One PyMatching cell flips, the
margins narrow everywhere, and one of C1064's two open proposals is closed by measurement rather
than by a decision. The cost is real and stated: dense shots and unit-weight graphs pay a few per
cent for machinery they do not need.

## Next

1. Decide whether the phenomenological grid is worth protecting; if so, the two-path dispatch on the
   compiled largest edge weight removes the 1 to 4 per cent it now pays.
2. The queue discipline itself: a small heap against the bucket queue on the same kernel, which
   would also retire the horizon refusal path.
3. The third code family for the mean-degree crossover rule, unchanged from C1064.
