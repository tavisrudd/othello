# C1063: per-shot solver routing, and the real-usage grid it has to be fitted on

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: `~/src/ergodis-private`
**Brief**: `2026-09-04-c1063-tiger-blossom-solver-routing-brief.md`
**Status**: complete — routed arm shipped as the default, both PyMatching grids restated on it

## What this task is

Probe 28g's stack ladder showed that the shipped TigerBlossom arm, `LEVEL_SPARSE`, is not the
fastest configuration in 13 of 18 measured cells, so both the default and every PyMatching
comparison stand on something slower than the kernel can already do. C1063 routes each shot to its
best arm, makes that the default, and restates the comparisons on it.

Tavis's scope on the same day: win in the cells relevant to real usage. Since routing buys only
4.2 to 9.4 per cent at `p = 0.001` — where real superconducting hardware sits — and the eye-catching
2.334x is at `d = 3`, `p = 0.05`, a cell nobody operates in, the grid has to be fixed before the
routing threshold is fitted on it. The order taken here is therefore grid first, then routing.

## The rotated surface code was distance one at every distance

The first act of building the surface family exposed a defect in the code it was built from, which
predates this task.

`RotatedSurfaceCode::new` placed its weight-two boundary `Z` checks on the left and right columns.
That leaves exactly two data qubits — the top-right and bottom-left corners — in no check at all at
every distance. The bottom-left corner lies on the logical column, so a single error there is an
undetected logical failure: the built code had distance one, not `d`.

It is visible in the decoder's own accuracy census. Before the repair, at `p = 0.001` with the
window following the distance:

| distance | logical error before | logical error after |
|----------|----------------------|---------------------|
| 3        | 0.00287              | 0.00015             |
| 5        | 0.00483              | 0.00001             |
| 7        | 0.00695              | 0.00000             |
| 9        | 0.00897              | 0.00000             |

The "before" column is `rounds * p` to three digits at every distance, which is exactly the chance
of hitting that one unchecked corner qubit in some round. The error rose with distance instead of
falling, which is the signature of a code that is not a code.

The repair puts the pairs on the top and bottom edges, on the complementary colouring, as the
function's own comment already said. A breadth-first search over (syndrome, logical class) gives
distance exactly `d` for `d = 3, 5, 7`, and the compiled kernel's `logical_weight` — the cheapest
boundary-to-boundary chain that flips the class — equals `d` through `d = 9`.

Two existing tests had to change, and the reason is worth recording because it is why the defect
survived.

`the_code_has_the_right_shape_and_a_commuting_logical` asserted that the logical column has even
overlap with every check and that its own support has trivial syndrome. Both are false for the
corrected code, and neither was ever the property that mattered: `logical[q]` marks the logical `Z`
column, which is the *label* the decoder reports, while the undetected `X` chain is a row. They are
different operators of the same weight, so testing the label by asking whether its support has
trivial syndrome tests nothing. What must hold is that no zero-syndrome pattern lighter than `d`
flips the label, which is now asserted directly through the compiled logical weight, together with
the requirement that no data qubit lies outside every check.

`the_surface_certificate_produces_all_three_outcomes` needed a wider window. On the corrected code
a radius-one window is decisive: all 2,000 sampled windows prove safe, at rates from 0.05 to 0.45.
The ambiguous branch appears at radius two (223 of 2,000 at `p = 0.05`). Under the broken code the
missing checks manufactured ambiguity at radius one, which is what that test used to observe.

This invalidates surface-family numbers taken before 2026-09-04, including probe 28h's distance-9
surface rows, which were themselves a re-derivation after the 32-bit support mask was widened. The
repetition-code results, which include every TigerBlossom performance number and the whole
PyMatching comparison, are untouched: they never used this builder.

## The benchmark now has the surface code and a window that follows the distance

`tiger-blossom-bench --family surface` builds its graph through the predecoder's own
`surface_graph`, so the two probes share one definition of the rotated surface code instead of
growing a second. `--rounds 0` follows the distance, which is the window a streaming decoder sees,
rather than fixing four rounds at every distance. Every mode's output line now names the family and
the window actually built.

The `latency` mode ignored `--level` and always timed the production arm; it now dispatches to a
monomorphized arm like the decode mode, so per-shot latency can be compared across the ladder.

The surface family reaches `d = 11`: the check support is a 64-bit mask and `d = 13` needs 84
checks. Widening that is a separate change and is not needed for any operating point of interest.

## Where the arms actually cross over

The new `arms` mode answers the question the routing rule needs: it draws shots at a given rate,
buckets them by defect count, and times every specialization level on each bucket. Buckets hold
real drawn syndromes, not uniform random detector sets, which are far more generic than real ones.

Nanoseconds per decode, surface `d = 9`, window 9, `p = 0.002`, 4,096 shots per bucket:

| defects | level 0 | level 1 | level 2 | level 3 | level 4 |
|---------|---------|---------|---------|---------|---------|
| 0       | 3.76    | 2.09    | 3.21    | 2.82    | 2.82    |
| 1       | 16.49   | 22.56   | 5.09    | 4.33    | 4.53    |
| 2       | 22.26   | 38.28   | 5.82    | 4.68    | 4.96    |
| 3       | 50.81   | 61.35   | 61.36   | 50.35   | 443.00  |
| 4       | 100.88  | 98.94   | 42.55   | 42.65   | 42.70   |
| 5       | 238.10  | 147.40  | 149.13  | 230.57  | 583.94  |
| 6       | 492.08  | 302.29  | 298.96  | 475.28  | 591.11  |
| 7       | 1198.38 | 523.24  | 508.91  | 1193.97 | 784.40  |
| 8       | 2703.47 | 1306.92 | 1285.34 | 2674.86 | 727.62  |
| 9       | 1084.54 | 1158.64 | 1156.13 | 1098.14 | 902.00  |
| 10      | 1093.09 | 1579.14 | 1474.14 | 1083.57 | 901.53  |
| 12      | 1314.96 | 1760.08 | 1750.86 | 1358.29 | 1020.09 |
| 14      | 1594.16 | 2108.92 | 2105.16 | 1702.90 | 1208.67 |

Three facts come out of this that the eighteen-cell ladder could not show.

**A shot with three defects must never reach the sparse matcher.** At three defects level 4 costs
443 ns against level 3's 50 ns, nine times worse, and the same anomaly is on the repetition code
(185 ns against 43 ns at `d = 9`, 228 against 45 at `d = 25`). Three is the smallest odd count with
no closed form: counts 0, 1, 2 and 4 are served by fast paths shared by every level above one, so
three is the first count where level 4's decision to hand the whole set to region growth is
actually taken, and it is the worst place to take it.

**Cluster decomposition is what wins in the middle.** From five to seven defects level 2 is the
cheapest arm and level 3 — the same closed forms without the decomposition — costs up to 2.3x more.
This is the opposite of the repetition ladder in probe 28g, where level 3 won eleven of eighteen
cells. Those cells are dominated by shots of nought to two defects, where the two levels differ by
a few per cent and level 3 is slightly ahead; the middle of the defect distribution, where they
differ by more than a factor of two, is invisible to a per-cell average.

**The crossover moves with the graph.** The defect count from which level 4 is the cheapest arm at
that count and every larger one, with the window following the distance:

| graph                  | detectors | crossover |
|------------------------|-----------|-----------|
| repetition `d = 5`     | 20        | 6         |
| surface `d = 5`        | 60        | 7         |
| repetition `d = 9`     | 72        | 7         |
| surface `d = 7`        | 168       | 8         |
| repetition `d = 15`    | 210       | 8         |
| surface `d = 9`        | 360       | 8         |

Sorted by detector count the sequence is monotone and it does not separate the two families, so the
quantity that moves the crossover is the size of the compiled graph rather than its geometry: on a
larger graph the same defects are further apart, the metric-closure reads that build the pair
matrix cost more, and the shot has to be denser before handing everything to the matcher pays.
A single global constant will therefore not do, which is what the brief suspected.

The wider sweep that fitted the shipped rule adds the ends of the range and one contrary point
(`benchmarks/tiger-blossom/2026-09-04-c1063-crossover-sweep.log`):

| graph                  | detectors | crossover |
|------------------------|-----------|-----------|
| repetition `d = 3`     | 6         | none      |
| surface `d = 3`        | 12        | 7         |
| repetition `d = 5`     | 20        | 6         |
| surface `d = 5`        | 60        | 7         |
| repetition `d = 9`     | 72        | 6 or 7    |
| surface `d = 7`        | 168       | 8         |
| repetition `d = 15`    | 210       | 8         |
| surface `d = 9`        | 360       | 8         |
| repetition `d = 25`    | 600       | 8         |
| surface `d = 11`       | 660       | 8         |

Two things change with the wider set. The crossover is not strictly monotone in detector count —
the smallest surface graph measures seven where a larger repetition graph measures six — and it
saturates: everything from one hundred and sixty-eight detectors up sits at eight, at every rate
where the buckets fill. What the number really tracks is therefore a coarse size threshold, not a
curve, and the shipped rule is one step: seven below one hundred and twenty-eight detectors, eight
at or above it. Small graphs are where the measurement is ambiguous, and seven is taken there
because that is what both small surface graphs measure; the asymmetry justifies rounding that way,
since being one count high sends a shot to the decomposition that the matcher would have served a
few per cent cheaper, while being one count low sends a sparse shot to the decomposition at more
than twice the cost. Repetition `d = 3` has no crossover to measure: with six detectors the matcher
never becomes the cheapest arm at any count that occurs.

## The rule, and where it is read

`KernelSpec` carries `route_threshold`, compiled once from the detector count by
`routing_threshold`, and the production level `LEVEL_ROUTED` takes one comparison per shot against
it: below the threshold the shot goes to the cluster decomposition and its closed forms, at or above
it to the sparse matcher. Nothing reads the error rate, which a deployed decoder does not know, and
both destinations are the existing const-generic monomorphizations, so the choice is a dispatch and
not a new solver. `Workspace::decode` — the entry point the predecoder pipeline and the accuracy
census both use — is now the routed arm.

Where the comparison sits turned out to matter as much as the rule. Taken immediately after defect
extraction it cost the cheapest cells 3.2 to 4.5 per cent in instructions, enough to make the routed
arm *lose* to the arm it replaces at surface `d = 3`: about three instructions for the load of the
threshold and the branch, against a 67-instruction decode. The closed forms — the empty shot, the
single defect, and the two-defect closure lookup — are common to both destinations, so they are now
answered before the decision is taken at all, and the modal shot at every operating rate never
reaches the comparison. That reordering is the whole repair; the same cell then measures 0.976 of
production rather than 1.032.

## Routing changes no answer, and the one thing it does change

Every level already returns the same weight on every shot, and the routed arm is gated on that shot
by shot against level four rather than in aggregate, on four repetition graphs, with the test also
asserting that both sides of the threshold are actually taken.

The observable mask is a different matter, and the gate says so. The kernel's standing tie policy is
that cost is unique but the witness need not be: where several minimum-weight witnesses carry
different logical parities, the reported parity is that of whichever witness the search settles
first, and that already differs between levels and between this kernel and PyMatching. Routing
therefore moves the reported parity on some degenerate shots — the gate found such shots
immediately at repetition `d = 5` — and what it must never do is move it on a shot whose minimum
weight is achieved in only one class. The test checks exactly that: on every disagreement it
resolves both logical classes exactly through the parity-resolved closure and requires them to be
equal. No shot failed.

## What routing is worth on the grid that matters

Three interleaved rounds, two-size differencing, instructions per decode, binary
`ergodis-tools-6b6999a`, log
`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-routed-ladder-ab.log`. Ratios are the routed arm
over the shipped level-four arm, so below one is a gain; the window follows the distance in every
row.

| family     | d  | routed / shipped at `p = 0.0005` | at `p = 0.001` | at `p = 0.002` |
|------------|----|----------------------------------|----------------|----------------|
| surface    | 3  | 0.987                            | 0.976          | 0.948          |
| surface    | 5  | 0.911                            | 0.765          | 0.620          |
| surface    | 7  | 0.732                            | 0.527          | 0.534          |
| surface    | 9  | 0.552                            | 0.515          | 0.638          |
| surface    | 11 | 0.507                            | 0.593          | 0.805          |
| repetition | 3  | 0.986                            | 0.986          | 0.975          |
| repetition | 5  | 0.987                            | 0.975          | 0.956          |
| repetition | 7  | 0.976                            | 0.956          | 0.861          |
| repetition | 9  | 0.958                            | 0.918          | 0.804          |
| repetition | 15 | 0.893                            | 0.754          | 0.700          |
| repetition | 25 | 0.709                            | 0.681          | 0.758          |

The routed arm is never worse in any of the thirty-three operating cells or in any of the
twenty-two stress cells, where the worst row is 1.000 and the best is 0.449 (surface `d = 3` at
`p = 0.05`, the cell the brief expected to gain most). It is up to 1.97x faster at the operating
rates: surface `d = 11` at `p = 0.0005` and surface `d = 9` at `p = 0.001` both roughly halve the
work.

This is much larger than the brief's estimate of four to nine per cent, and the reason is the grid
rather than the rule. The eighteen-cell ladder that produced that estimate fixed the window at four
rounds for every distance, which keeps almost every shot at nought to two defects, where all the
arms share their closed forms and differ by a few per cent. A window that follows the distance —
what a streaming decoder actually sees — moves a large share of shots into the three-to-seven
defect range, and that is precisely where the shipped arm is worst: it is the region where its
decision to hand the whole set to region growth costs up to nine times the closed forms at three
defects and up to 2.3x the cluster decomposition at five to seven. The gain also grows with
distance in both families, which is the direction real devices are moving.

Cycles agree wherever they are measurable and are useless where they are not: at the small cells a
decode is eight to twelve cycles and the production arm's own round-to-round spread reaches 20 to
46 per cent, so those confidence intervals span one in both directions. Instructions have a spread
of about 0.01 per cent on the same cells. The large-cell cycle ratios track the instruction ratios
closely, down to 0.395 at surface `d = 11`, `p = 0.0005`.

## The PyMatching standing, restated on the arm that now ships

The eighteen published cells — repetition code, four-round window — measured again with both arms
against the same PyMatching 2.4.0 runs, three interleaved rounds, instructions per decode
(`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-vs-pymatching-eighteen-cells.log`). Ratios are
Tiger over PyMatching, so below one means Tiger is ahead.

| d  | p     | shipped level 4 | routed | Tiger's advantage, routed |
|----|-------|-----------------|--------|---------------------------|
| 3  | 0.001 | 0.315           | 0.307  | 3.26x                     |
| 3  | 0.01  | 0.261           | 0.220  | 4.55x                     |
| 3  | 0.05  | 0.340           | 0.160  | 6.25x                     |
| 5  | 0.001 | 0.232           | 0.226  | 4.42x                     |
| 5  | 0.01  | 0.222           | 0.151  | 6.62x                     |
| 5  | 0.05  | 0.643           | 0.395  | 2.53x                     |
| 7  | 0.001 | 0.164           | 0.160  | 6.25x                     |
| 7  | 0.01  | 0.177           | 0.130  | 7.69x                     |
| 7  | 0.05  | 0.752           | 0.578  | 1.73x                     |
| 9  | 0.001 | 0.132           | 0.128  | 7.81x                     |
| 9  | 0.01  | 0.271           | 0.201  | 4.98x                     |
| 9  | 0.05  | 0.960           | 0.833  | 1.20x                     |
| 15 | 0.001 | 0.098           | 0.091  | 11.0x                     |
| 15 | 0.01  | 0.357           | 0.294  | 3.40x                     |
| 15 | 0.05  | 1.188           | 1.151  | behind by 1.151x          |
| 25 | 0.001 | 0.091           | 0.088  | 11.4x                     |
| 25 | 0.01  | 0.661           | 0.602  | 6.02x                     |
| 25 | 0.05  | 1.296           | 1.293  | behind by 1.293x          |

Every cell improves and none regresses. The two cells that were behind are still behind and are
essentially unmoved, which is what the brief predicted: `d = 15` and `d = 25` at five per cent error
are exactly where handing the whole defect set to the matcher is already the right choice, so there
is nothing for routing to win there. The gains are largest where the shipped arm was worst, and at
the operating rate the standing is now 3.3x to 11.4x, rising with distance.

Two provenance points. First, the level-four column is a control measured in the same interleaved
run rather than the figure carried over from probe 28g, because the PyMatching side moves a few per
cent between runs; probe 28g's own numbers for the two losing cells were 1.151x and 1.272x, against
1.188x and 1.296x here for the same arm. Second, those two losses are an instruction-count
statement. In cycles the same run puts the routed arm ahead in both — 0.890 and 0.947 — as probe
28g also found (0.870 and 0.948), so "behind" there means Tiger executes more instructions and
still finishes in fewer cycles.

The real-usage grid extends the comparison to the surface family and the window that follows the
distance (`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-vs-pymatching-real-usage.log`, the
same protocol, operating rates only). The routed arm is ahead in all thirty-three cells: the
weakest is surface `d = 11` at `p = 0.002` at 1.01x, where the syndrome is dense enough that both
decoders are doing the same work, and the strongest is repetition `d = 15` at `p = 0.0005` at
16.7x. At `p = 0.001` the surface family runs 2.3x to 10.0x ahead and the repetition family 2.0x to
16.1x. PyMatching's own spread on these cells is one to thirty per cent between rounds, against
about 0.01 per cent for the kernel, so its ratios are worth one significant figure and no more —
the repetition `d = 5` row at `p = 0.001` is the visible case, where PyMatching's measured cost
falls below its own neighbours at half the error rate and drags that cell's ratio to 2.0x while
every neighbour sits above 4x.

## Exactness

PyMatching 2.4.0 verified against the routed arm on every emitted cell of both grids — the
eighteen published cells and all thirty-three real-usage cells — at twenty thousand shots each
(`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-pymatching-exactness.txt`). Every cell has zero
weight disagreements. The shot files are emitted by the bench's own accuracy census, which now
decodes on `LEVEL_ROUTED`, so this checks the arm that ships rather than a neighbouring one.

Predictions diverge only where the tie policy allows: forty of the fifty-one cells agree shot for
shot, four differ on a single shot, and the three cells with more are all at five per cent error,
the largest being 831 of 20,000 at repetition `d = 3`. Those are degenerate shots, and the two
decoders' measured logical error rates on them stay together — 0.06905 against 0.06960 on that
worst cell, 0.00595 against 0.00625 at `d = 7` — which is what a coin flip on genuinely tied
witnesses looks like.

## Latency, measured for the first time

The bench has always had a `latency` mode and the brief recorded that it had never been run. It is
now run at the operating rate on both arms, 200,000 shots per row, window following the distance
(`benchmarks/tiger-blossom/2026-09-04-c1063-6b6999a-latency-operating.txt`).

| graph                | shipped p50/p90/p99 (ns) | routed p50/p90/p99 (ns) |
|----------------------|--------------------------|-------------------------|
| surface `d = 7`      | 20 / 40 / 491            | 20 / 40 / 220           |
| surface `d = 9`      | 30 / 510 / 862           | 30 / 110 / 822          |
| surface `d = 11`     | 80 / 962 / 1412          | 80 / 871 / 1452         |
| repetition `d = 15`  | 20 / 40 / 421            | 20 / 30 / 130           |
| repetition `d = 25`  | 30 / 681 / 921           | 30 / 230 / 982          |

Routing moves the ninetieth percentile, which is where the decision it makes actually lands: 4.6x
at surface `d = 9` and 3.0x at repetition `d = 25`. The median is a closed form on both arms and
does not move. Against the microsecond per-round deadline a real-time decoder faces, every graph
measured except surface `d = 11` holds the ninety-ninth percentile under a microsecond on both
arms, and `d = 11` is over it on both. The maxima are single outliers in the tens of microseconds
and are not stable between runs; the tail beyond the ninety-ninth percentile is not something this
harness measures well, and a decoder that must never miss a deadline would need that tail
characterized properly rather than sampled.

## Closeout: the second compiled constant is not worth fitting

`KernelSpec` gained a `dp_cutoff` alongside the routing threshold — the largest cluster the subset
dynamic program accepts before region growth takes it — and the obvious question at closeout was
whether it deserves the same treatment. It does not
(`benchmarks/tiger-blossom/2026-09-04-c1063-dp-cutoff-probe.txt`): at the operating rate, cutoffs
of six, seven and eight are indistinguishable on both the largest surface and the largest
repetition graph, and only five is worse, by 9.9 and 13.7 per cent. Clusters of seven or eight
defects essentially do not occur below the routing threshold, so the cutoff has nothing to decide.
It stays at eight, where it has always been, and the field is now explicit rather than implicit.

## Mystery ledger

**The crossover is not monotone in graph size at the small end, and the routing rule ignores it.**
The smallest surface graph (twelve detectors) measures a crossover of seven while a larger
repetition graph (twenty detectors) measures six. The `ej`/`tt` pass did not settle which is real:
both are single-round measurements on graphs where only three or four buckets ever fill, so the
evidence gap is a repeated sweep with enough shots per bucket to put an interval on each crossover.
The shipped rule takes seven for everything below one hundred and twenty-eight detectors, which is
the conservative side of that ambiguity, and the ladder shows no cell where it costs anything: the
smallest cells all improve.

**Routing helps least at the highest operating rate on the largest surface graphs, and the pattern
is not monotone in the rate.** Surface `d = 7` gains 0.732, 0.527, 0.534 across the three operating
rates and surface `d = 11` gains 0.507, 0.593, 0.805. This one the closeout does settle: as the
rate rises, more shots land above the threshold, where the routed arm and the shipped arm are the
same code, so the gain has to fall back toward one. The non-monotone middle at `d = 7` is the
crossing of two effects — more shots in the mid-defect range where routing wins most, then more
shots above the threshold where it wins nothing — and it is not a defect.

**Why the four-round window hid an effect this large is now understood, and it is a warning about
the remaining grid gaps.** The estimate the brief carried, four to nine per cent, came from a grid
whose window did not follow the distance; correcting one benchmark axis turned a few per cent into
up to 1.97x. Three axes from the brief's list remain uncorrected: the noise model is still
phenomenological with unit edge weights and one rate shared by data and measurement errors, the
comparison is still against one competitor, and the tail beyond the ninety-ninth percentile is
still unmeasured. The weighted circuit-level detector error model is the largest of these and is
the one place where the kernel's own fast paths — the two-defect closure lookup and the
`divide_up(needed, rate)` path with rate in `{1,2}` — are known to be flattered by the current
model. Nothing here says the standing would fall under weighted edges, and nothing here says it
would hold; it has not been measured, and it deserves its own task rather than a footnote.

**Still open for Tavis, unchanged from the brief.** Whether the routed default should also be free
to choose the unspecialized graph path, which probe 28g measured at 0.904x of production in exactly
one cell (`d = 3`, `p = 0.001`) and up to 18.8x worse elsewhere. Routing on a second axis for one
cell looks like a bad trade, but the decision is yours.

Surface distances stop at eleven because the check support is a 64-bit mask and `d = 13` needs
eighty-four checks. Widening it is a separate change and no operating point of interest needs it.
