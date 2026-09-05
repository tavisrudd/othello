# C1064: the TigerBlossom grid on a weighted circuit-level detector error model

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: `~/src/ergodis-private`
**Brief**: `2026-09-04-c1064-weighted-circuit-level-dem-brief.md`
**Status**: in progress

## What this task is

C1063 closed with three benchmark axes still uncorrected, and named the noise model as the largest.
Every TigerBlossom number to that point was measured on a phenomenological model: each mechanism
carries unit weight, and one shared rate drives data and measurement errors alike. A real decoder
consumes a circuit-level detector error model, in which each mechanism has its own probability and
each edge the weight `ln((1 - p) / p)`. This task puts the grid on that model and remeasures.

## The model, and where it comes from

`scripts/tiger_blossom_stim_dem.py` generates the reference model with stim 1.16.0:
`stim.Circuit.generated` for `surface_code:rotated_memory_z` and `repetition_code:memory`, with
`after_clifford_depolarization`, `before_measure_flip_probability`, `after_reset_flip_probability`
and `before_round_data_depolarization` all set to the physical rate, then
`detector_error_model(decompose_errors=True).flattened()`. The window follows the distance, as
C1063 established it must. The generated grid covers surface distances 3 to 11 and repetition
distances 3 to 25 at the three operating rates and the two stress rates; the file listing with each
model's SHA-256 is the certificate.

`src/detector_error_model.rs` reads such a model and produces two lists, and the distinction between
them is the substance of the reader:

- the **events** are the error instructions, one per line, each flipping the union of its
  components' detectors. This is the sampler. An instruction that decomposes into two graphlike
  components fires both together, and sampling the components independently would throw away
  exactly the correlation that makes circuit-level noise different from a phenomenological model.
- the **edges** are the graphlike components, merged so that each detector pair appears once, with
  parallel contributions combined as `p1 (1 - p2) + p2 (1 - p1)`. This is the decoding graph, and
  both this kernel and the external matcher are built from it.

The reader rejects rather than approximates: a `repeat` block, a `shift_detectors` instruction, or a
component flipping three detectors is an error, because each would make the compiled graph something
other than the model the comparison claims to stand on.

Integer weights are `round(scale * ln((1 - p) / p))` with a floor of one; the scale is 32, which
puts the operating-rate weights in the range 141 to 263.

## The phenomenological path is unchanged

The fixed-rate generator is untouched and the surface accuracy census reproduces C1063's post-repair
table exactly at `p = 0.001` with the window following the distance: logical error 0.00015, 0.00001,
0.00000, 0.00000 at distances 3, 5, 7 and 9.

## The weighted model decodes correctly

Accuracy census on the circuit-level models at `p = 0.001`, 200,000 shots per row, the routed arm:

| distance | detectors | edges | mean defects | logical error |
|----------|-----------|-------|--------------|---------------|
| 3        | 24        | 78    | 0.30         | 0.00077       |
| 5        | 120       | 502   | 1.77         | 0.00011       |
| 7        | 336       | 1,558 | 5.33         | 0.00003       |
| 9        | 720       | 3,534 | 11.94        | 0.00000       |
| 11       | 1,320     | 6,718 | 22.48        | 0.00000       |

Logical error falls with distance, which is what a code below threshold does and what the broken
`RotatedSurfaceCode::new` that C1063 repaired did not do.

Two structural differences from the phenomenological model are visible in the same table and both
matter later. The detector count is larger at every distance, because a stim memory experiment
carries detectors for both stabilizer types while the predecoder's surface graph carries only the
one the observable rides on. And the mean defect count per shot is six to twelve times larger at the
same nominal rate: 11.94 against 1.93 at distance 9. The kernel is therefore being asked a much
denser question than any earlier measurement asked it.

Every specialization level returns the same weight and the same observable parity on the weighted
models: zero disagreements over 20,000 shots at surface distances 3, 5 and 7 and repetition
distances 9 and 25 at `p = 0.002`.

## The shipped routing rule is wrong on this model, and wrong in the expensive direction

The `arms` mode times every specialization level on real drawn syndromes bucketed by defect count.
Run over ten weighted graphs at `p = 0.001`
(`benchmarks/tiger-blossom/2026-09-04-c1064-weighted-arm-profile.log`), it says two things the
unit-weight sweep could not.

**The sparse matcher's fixed cost per shot is an order of magnitude larger on a weighted graph.**
Under unit weights C1063 found one anomaly, at three defects, where handing the whole set to region
growth cost nine times the closed forms. Under circuit-level weights that anomaly is ten to thirty
times and it extends across every count from three to seven. On weighted surface `d = 9`, at three
defects the sparse matcher costs 1,338 ns against the cluster decomposition's 50, and at five
defects 1,521 against 159. The cost barely depends on the defect count, which is what a fixed entry
cost looks like: the matcher is paying to set up, not to search.

**The crossover therefore moves far to the right, and the two families separate.** The smallest
defect count from which the sparse matcher is the cheapest arm at that count and every larger one:

| graph                  | detectors | edges | mean degree | crossover, weighted | C1063, unit weights |
|------------------------|-----------|-------|-------------|---------------------|---------------------|
| repetition `d = 5`     | 24        | 65    | 5.42        | 8                   | 6                   |
| repetition `d = 9`     | 80        | 225   | 5.62        | 10                  | 6 or 7              |
| repetition `d = 15`    | 224       | 645   | 5.76        | 8                   | 8                   |
| repetition `d = 25`    | 624       | 1,825 | 5.85        | 10                  | 8                   |
| surface `d = 3`        | 24        | 78    | 6.50        | at least 16         | 7                   |
| surface `d = 7`        | 336       | 1,558 | 9.27        | 14                  | 8                   |
| surface `d = 9`        | 720       | 3,534 | 9.82        | 16                  | 8                   |
| surface `d = 11`       | 1,320     | 6,718 | 10.18       | 16                  | 8                   |

Surface `d = 3` is a lower bound: no count below sixteen ever became the matcher's, and sixteen is
the largest bucket that fills even at five per cent error. Surface `d = 5` and repetition `d = 3`
are omitted because no bucket above their means fills at any rate the models cover.

C1063's account of the crossover — that it tracks graph size and does not separate the two families
— does not survive the weighted model. Sorted by detector count the weighted crossovers are not
monotone and the families are cleanly apart: every repetition graph measures eight or ten and every
surface graph fourteen or more, while repetition `d = 25` has almost twice the detectors of surface
`d = 7` and half its crossover. What does separate them is the neighbourhood. A rotated surface
graph built from a decomposed circuit-level model carries more than six neighbours per detector and
a repetition graph fewer than six, and on the denser graph a given defect count occupies a smaller
region, so the cluster decomposition stays cheap for longer.

The refitted rule is therefore one step on the mean degree, with each branch the middle of its
measured pair: **fewer than six neighbours per detector gives nine, six or more gives fifteen.** In
the integers the compiler sees, that is `edges < 3 * nodes`. Every measured weighted crossover is
within one count of its branch, and surface `d = 3` sits at or above its lower bound.

The unit-weight rule is kept exactly as C1063 fitted it — seven below one hundred and twenty-eight
detectors, eight at or above — so no number measured on a phenomenological graph moves.
`routing_threshold` now takes the compiled edge count and the compiled largest edge weight alongside
the detector count, and the branch between the two regimes is `max_weight > 1`. All three are
properties of the compiled graph; the rule still never reads the error rate, which a deployed
decoder does not know. A unit test pins the rule against every crossover both sweeps measured.

What the old constant was costing on this model is direct: it sent a shot to the sparse matcher from
seven or eight defects, and on weighted surface `d = 7` at eight defects that costs 1,283 ns against
the cluster decomposition's 429 — three times the work — with the penalty persisting through
thirteen defects. Under circuit-level noise that is not a rare corner: the mean defect count at
surface `d = 7` is 5.33 and at `d = 9` is 11.94, so the shipped rule was mis-routing the middle of
the distribution.

## What routing is worth on the weighted grid

Three interleaved rounds, two-size differencing, instructions per decode, the window following the
distance (`benchmarks/tiger-blossom/2026-09-04-c1064-weighted-routed-ladder-ab.log`). Ratios are the
routed arm over the level-four arm C1063 replaced, so below one is a gain.

| family     | d  | `p = 0.0005` | `p = 0.001` | `p = 0.002` |
|------------|----|--------------|-------------|-------------|
| surface    | 3  | 0.484        | 0.354       | 0.252       |
| surface    | 5  | 0.216        | 0.210       | 0.279       |
| surface    | 7  | 0.254        | 0.365       | 0.652       |
| surface    | 9  | 0.385        | 0.691       | 0.975       |
| surface    | 11 | 0.634        | 0.956       | 1.000       |
| repetition | 3  | 0.986        | 0.987       | 0.881       |
| repetition | 5  | 0.906        | 0.857       | 0.676       |
| repetition | 7  | 0.753        | 0.615       | 0.511       |
| repetition | 9  | 0.863        | 0.565       | 0.561       |
| repetition | 15 | 0.546        | 0.596       | 0.705       |
| repetition | 25 | 0.534        | 0.704       | 0.908       |

The routed arm is never worse in any of the thirty-three operating cells, and at its best it is
4.76x faster — surface `d = 5` at `p = 0.001`. On the phenomenological grid the same comparison
topped out at 1.97x. Routing is worth roughly twice as much on the model real decoders consume,
because the arm it routes away from is much worse there.

The gain shrinks as the rate rises on the largest surface graphs, for the reason C1063 gave: more
shots land above the threshold, where the routed arm and the level-four arm are the same code.
Surface `d = 11` at `p = 0.002` has a mean of 44.2 defects and the routed arm is the matcher on
essentially every shot, which is exactly the ratio of 1.000.

## The PyMatching standing does not survive intact, and this is the finding

Same protocol as C1063 — three interleaved rounds, two-size differencing, instructions per decode,
PyMatching 2.4.0 built from the same shot files and the same quantized integer weights — over the
thirty-three operating cells of the weighted grid
(`benchmarks/tiger-blossom/2026-09-04-c1064-weighted-vs-pymatching-operating.log`). Ratios are Tiger
over PyMatching, so below one means Tiger is ahead.

| family     | d  | `p = 0.0005` | `p = 0.001` | `p = 0.002` |
|------------|----|--------------|-------------|-------------|
| surface    | 3  | 0.189        | 0.092       | 0.166       |
| surface    | 5  | 0.139        | 0.211       | 0.396       |
| surface    | 7  | 0.250        | 0.562       | **1.115**   |
| surface    | 9  | 0.584        | **1.226**   | **1.736**   |
| surface    | 11 | **1.102**    | **1.690**   | **1.997**   |
| repetition | 3  | 0.703        | 0.269       | 0.244       |
| repetition | 5  | 0.170        | 0.192       | 0.106       |
| repetition | 7  | 0.113        | 0.115       | 0.137       |
| repetition | 9  | 0.098        | 0.110       | 0.219       |
| repetition | 15 | 0.097        | 0.279       | 0.718       |
| repetition | 25 | 0.288        | 0.887       | **1.533**   |

Tiger is ahead in twenty-six of the thirty-three cells and behind in seven, marked in bold. On the
phenomenological grid C1063 measured Tiger ahead in all thirty-three. The standing therefore holds
where it was strongest and reverses where the syndrome is densest: the losses are the two largest
surface graphs from `p = 0.001` upward, surface `d = 7` at `p = 0.002`, and repetition `d = 25` at
`p = 0.002`.

Cycles agree rather than rescuing the losses, which is a second difference from C1063. There, the
two losing cells were instruction-count losses that became cycle wins; here surface `d = 9` at
`p = 0.001` is 1.029 in cycles, `d = 11` is 1.281 and 1.259 at the two higher rates, and repetition
`d = 25` at `p = 0.002` is 1.659. Only surface `d = 7` at `p = 0.002` flips, to 0.927. PyMatching's
round-to-round spread is one to eighty per cent on the small cells against about 0.01 per cent for
the kernel, so its ratios below about `d = 7` are worth one significant figure; the losing cells are
all large, where its spread is under two per cent and the ratios are firm.

The shape is legible and it is about density. The weighted surface graphs carry a mean of 5.3, 11.9
and 22.5 defects at distances 7, 9 and 11 at `p = 0.001`, and 10.5, 23.5 and 44.2 at `p = 0.002`, so
nearly every shot in the losing cells is above
the routing threshold and the kernel is running its sparse region-growth matcher on a genuinely
weighted graph — which is the regime PyMatching 2's sparse blossom implementation was built for.
Where the syndrome is sparse enough that the cluster decomposition and the closed forms answer the
shot, the kernel is still three to eleven times ahead.

Two consequences follow, and neither is a footnote. The published claim of a uniform advantage over
PyMatching was a property of the phenomenological model as much as of the kernel, and any future
statement of the standing has to name the noise model it was measured on. And the kernel's own
frontier moves: the thing to attack is the sparse matcher's cost on weighted graphs, not the closed
forms, because that is now the arm that runs on every dense shot and it is where the losses are.

## Exactness is stronger on the weighted model, not weaker

PyMatching 2.4.0 verified against the routed arm on all thirty-three cells at twenty thousand shots
each (`benchmarks/tiger-blossom/2026-09-04-c1064-weighted-pymatching-exactness.txt`): zero weight
disagreements and, in every cell, zero prediction disagreements as well.

That second half is new. On the phenomenological grid C1063 found the two decoders predicting
different logical classes on up to 831 shots in 20,000, because minimum-weight witnesses tie
constantly under unit weights and the tie policy lets either decoder settle whichever it reaches
first. Real weights break those ties: with edge weights spread from 141 to 263 the minimum-weight
witness is essentially always unique, so agreeing on the cost forces agreeing on the class. The
kernel's tie policy is unchanged; the model stopped exercising it.

## How much of the old picture was tie degeneracy

The `FastPathCensus` on the same cell under both models, 200,000 shots
(`benchmarks/tiger-blossom/2026-09-04-c1064-fast-path-census-both-models.txt`). The four whole-shot
closed forms — empty, single defect, the two-defect closure lookup, and the four-defect form —
answer a shot without any search at all:

| cell                        | closed forms answer | sparse matcher answers | interior nodes | sparse events per answer |
|-----------------------------|---------------------|------------------------|----------------|--------------------------|
| surface `d = 9`, phenom.    | 86.4%               | 1.3%                   | 63             | 8.70                     |
| surface `d = 9`, circuit    | 6.5%                | 32.1%                  | 0              | 23.63                    |
| repetition `d = 25`, phenom.| 86.3%               | 2.8%                   | 506            | 5.23                     |
| repetition `d = 25`, circuit| 50.4%               | 12.1%                  | 0              | 8.28                     |

On the phenomenological surface model six shots in seven are answered by a closed form and never
reach a search. On the circuit-level model at the same distance and nominal rate, one in fifteen is.
The compiled interior neighbour-offset specialization — which relaxes through fixed integer offsets
instead of the adjacency arrays — does not fire at all on either weighted graph, because it requires
every interior edge to carry one shared weight with no observable flip, and a circuit-level model
gives no two edges the same weight by accident.

So the answer to the question the brief asked is: a large part of the earlier picture was the model.
The closed forms were answering most shots because unit weights make the two-defect closure exact
and cheap, and the interior specialization existed because unit weights make every bulk edge
identical. Neither holds on a circuit-level model, and what is left carrying the load is the cluster
decomposition — which is why the routing threshold had to move so far and why the remaining
frontier is the sparse matcher.

## Latency, and the deadline it now has to be read against

Operating rate, 200,000 shots per row, the window following the distance
(`benchmarks/tiger-blossom/2026-09-04-c1064-weighted-latency-operating.txt`). A window of `d` rounds
gives the decoder a budget of about `d` microseconds against a one-microsecond per-round deadline.

| graph                | shipped level 4, p50/p90/p99 (ns) | routed, p50/p90/p99 (ns) | budget |
|----------------------|-----------------------------------|--------------------------|--------|
| surface `d = 7`      | 1442 / 2454 / 4548                | 281 / 1513 / 5120        | 7 µs   |
| surface `d = 9`      | 3657 / 5621 / 9438                | 2073 / 5841 / 9478       | 9 µs   |
| surface `d = 11`     | 7554 / 11802 / 19626              | 7794 / 12212 / 20659     | 11 µs  |
| repetition `d = 15`  | 40 / 120 / 1563                   | 40 / 120 / 1232          | 15 µs  |
| repetition `d = 25`  | 641 / 2575 / 3366                 | 300 / 2965 / 4519        | 25 µs  |

Routing halves the median at surface `d = 7` and `d = 9` and at repetition `d = 25`, and leaves the
upper quantiles roughly where they were, because the shots in the tail are the dense ones that both
arms send to the matcher.

Against the budget, the repetition family is comfortable and the surface family is not. Surface
`d = 7` and `d = 9` fit inside their windows with about a 30 per cent and 5 per cent margin at the
ninety-ninth percentile, and surface `d = 11` is nearly twice over it on both arms. On the
phenomenological model every graph except surface `d = 11` held its ninety-ninth percentile under a
single microsecond; on the circuit-level model none of the surface graphs does. A real-time decoder
for a distance-11 surface code, on this noise model, would need parallelism, a faster dense arm, or
a predecoder — this kernel single-threaded does not make the deadline. The maxima remain single
outliers in the tens of microseconds and are not stable between runs, so the tail beyond the
ninety-ninth percentile is still not something this harness characterizes.

## Closeout: the quantization scale is free money, and the component split is not the answer

**Quantization is not costing accuracy, and a coarser scale is 7 to 8 per cent cheaper.**
The brief asked for the knee in logical error against the integer weight scale and there is none
(`benchmarks/tiger-blossom/2026-09-04-c1064-weight-scale-knee.txt`): at surface `d = 7` and
repetition `d = 25`, `p = 0.001`, 400,000 shots, the logical error is flat from scale one — where
the whole weight range is five to eight — to scale 128. Cost is not flat
(`benchmarks/tiger-blossom/2026-09-04-c1064-weight-scale-cost-ab.log`): against the shipped scale of
32, scale 8 costs 0.927 at surface `d = 9` and 0.914 at repetition `d = 25`, and scale 1 costs 0.899
and 0.881, because the largest edge weight sets the bucket-queue modulus.

This is left as a proposal rather than taken, because it is the one closeout change that would move
every number in this report: the whole grid stands on scale 32 and would have to be restated on
whatever replaces it. The conclusions are robust to the choice — an 8 per cent reduction moves
surface `d = 9` at `p = 0.001` from 1.226 to about 1.14 and surface `d = 11` at `p = 0.0005` from
1.102 to about 1.02, narrowing the losses without flipping them — so the finding above does not
depend on it. Scale 1 is not the right answer even though it is cheapest: at weights of five to
eight the ties come back, and with them the prediction disagreements that scale 32 eliminated.

**A stim memory model is two graphs, and only one of them decides anything.** Union-find over the
weighted surface models shows two components with no shared detector: 192 and 144 at `d = 7`, 400
and 320 at `d = 9`, 720 and 600 at `d = 11`. Only the larger one carries the observable — X and Z
errors decouple, and a memory-Z experiment reports a class that only the Z-type component can flip.
Everything the decoder does on the other component is work whose result is discarded.

`scripts/tiger_blossom_dem_component.py` writes the restricted model so the size of that prize could
be measured before anyone builds the split into the compiler
(`benchmarks/tiger-blossom/2026-09-04-c1064-observable-component-split.log`). It is large in
absolute terms and it changes nothing relative:

| graph            | full | restricted | restricted / full | restricted / PyMatching on the same graph | full / PyMatching |
|------------------|------|------------|-------------------|-------------------------------------------|-------------------|
| surface `d = 7`  | 5,259 | 2,309     | 0.439             | 0.456                                     | 0.562             |
| surface `d = 9`  | 26,049 | 12,474   | 0.479             | 1.179                                     | 1.226             |
| surface `d = 11` | 67,831 | 33,760   | 0.498             | 1.672                                     | 1.690             |

The kernel does half the work on the restricted graph and the logical error is unchanged, so this is
a real halving of latency and of the compiled tables — the metric closure is quadratic in detectors,
so at `d = 11` it shrinks by about seventy per cent. But PyMatching halves too, and the standing
moves by less than five per cent in every cell. Component splitting is therefore worth doing for
absolute latency and memory, and it is not the lever that recovers the large-distance losses.

## Mystery ledger

**Why the sparse matcher's cost barely depends on the defect count between three and seven, and how
much of it is avoidable.** On weighted surface `d = 9` the matcher costs 1,338 ns at three defects,
1,521 at five and 1,530 at six, while doing 2.8 sparse events at three defects. A cost that flat
against the work done is a fixed entry cost proportional to the graph, not to the shot. The `ej`
pass did not settle where it lives, and it is now the highest-value question in the kernel: the
matcher is the arm that runs on every dense shot, it is where all seven PyMatching losses are, and
its per-shot floor is what a routing threshold of fifteen exists to avoid paying. The evidence gap
is a profile of one three-defect decode on a weighted graph, attributing the fixed cost to
initialization, workspace clearing, or the pair matrix.

**Whether the mean-degree account of the crossover is causal or a coincidence of two families.**
The refitted rule rests on the observation that every graph with more than six neighbours per
detector crosses over at fourteen or later and every graph with fewer crosses at eight or ten, on
two code families. Two families make two points, and a rule that separates them is not yet a rule
that predicts. The gate is a third family with an intermediate degree — a heavy-hexagon layout, or a
surface model with the diagonal decomposition edges thinned — where the rule can be stated in
advance and then measured.

**Why the twenty-four-detector surface model has no crossover below sixteen.** Every other graph
crosses somewhere the sweep can see. This one, with mean degree 6.5, never lets the matcher become
the cheapest arm at any count that fills a bucket, even at five per cent error. The likeliest
account is that at twenty-four detectors the matcher's fixed cost is a large fraction of any decode,
so the decomposition wins until the shot is most of the graph, but that is inference, not
measurement, and it is the one graph the fitted rule covers by a bound rather than by a value. It
does not matter operationally: a sixteen-defect shot on twenty-four detectors does not occur.

**Settled by the closeout, and recorded so it is not re-asked.** Whether the weighted comparison was
unfair because the kernel decodes both stabilizer components while a real decoder would split them:
it was not. Splitting halves the kernel's work and PyMatching's alike, and moves every ratio by less
than five per cent. And whether the integer quantization was costing accuracy or flattering the
comparison: neither. Logical error is flat across seven octaves of scale, and the shipped scale is
the most expensive of them by 8 per cent, which understates rather than overstates the kernel.
