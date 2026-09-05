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

## (in progress)
