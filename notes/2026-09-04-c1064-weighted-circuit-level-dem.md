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
Surface `d = 11` at `p = 0.002` has a mean of about forty-five defects and the routed arm is the
matcher on essentially every shot, which is exactly the ratio of 1.000.

## (in progress: PyMatching standing, latency, fast-path census)
