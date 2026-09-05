# C1064: put the TigerBlossom grid on a weighted circuit-level detector error model

**Lane**: `complete-ports` · **Allocated**: 2026-09-04 · **Code**: `~/src/ergodis-private`
(`src/tiger_blossom_graph.rs`, `tasks/tools/src/tiger_blossom_bench.rs`,
`scripts/tiger_blossom_pymatching_baseline.py`) ·
**Predecessor**: `2026-09-04-c1063-tiger-blossom-routing-and-real-usage-grid.md`

## Why

C1063 corrected one benchmark axis — the decoding window now follows the distance — and the
correction turned a predicted four-to-nine per cent routing gain into up to 1.97x. Its mystery
ledger names the noise model as the largest of the three axes still uncorrected, and the one where
the kernel's own fast paths are known to be flattered:

- Every mechanism carries `weight: 1`. The compiled metric closure is therefore a hop count, ties
  are everywhere, and the two-defect closure lookup answers a large share of shots exactly.
- `ShotGenerator` draws every mechanism at one rate shared by data and measurement errors. A real
  circuit-level model gives each mechanism its own probability, spanning more than an order of
  magnitude within one graph.
- Real decoders consume a circuit-level detector error model whose edge weights are
  `ln((1 - p) / p)`, so the matching problem is genuinely weighted and the minimum-weight witness is
  usually unique rather than one of a large tie class.

Nothing measured so far says the PyMatching standing falls under weighted edges, and nothing says it
holds. C1063 declined to settle it in a footnote and allocated it here.

## What to build

**1. A stim-generated circuit-level detector error model as the benchmark's noise source.**
Generate with `stim.Circuit.generated(...)` for `surface_code:rotated_memory_z` and
`repetition_code:memory` at each `(distance, rounds, p)` of the grid, with the four standard noise
knobs set to `p`, then `detector_error_model(decompose_errors=True).flattened()`. This is the
reference model the field compares on, and it makes the PyMatching comparison unimpeachable because
both decoders can be built from the same file. Feasibility is confirmed: `uv run --with stim`
resolves, and the `d = 5`, five-round rotated surface DEM has 120 detectors and 1,953 decomposed
error lines.

Commit the generator script and a compact certificate (per-file SHA-256, detector and error counts)
rather than the DEM files themselves, per the reproducibility conventions.

**2. A cold DEM reader in `ergodis-private` producing `(detectors, Vec<Mechanism>, observables)`.**
It must:

- accept a flattened, decomposed DEM and reject one that is not (a `repeat` block or an undecomposed
  three-detector component is an error, not a silent approximation);
- split each error at its `^` separators into graphlike components, each flipping one or two
  detectors;
- merge parallel components — same detector pair and same observable mask — by the standard
  combination `p1 (1 - p2) + p2 (1 - p1)`, so the compiled graph has one edge per pair;
- drop and count components that flip no detector (they flip only observables and no matcher can
  see them; PyMatching drops them too); and
- quantize `ln((1 - p) / p)` to the kernel's integer weight at a stated scale.

The quantization scale is the one free parameter and it must be chosen and stated, not defaulted.
It has to be large enough that the routing and accuracy conclusions are not quantization artifacts,
and small enough that `max_weight` keeps the bucket queue modulus cheap and the narrow `u16` metric
closure still exists at the largest graph. Measure the logical error rate against the scale and pick
the knee.

**3. Per-mechanism sampling, without disturbing the existing numbers.**
`Mechanism` gains a cold `probability` field and `ShotGenerator` gains a weighted constructor that
reads it. The fixed-rate constructor stays exactly as it is, so every phenomenological number
already published remains reproducible from the same code path.

**4. Re-measure the whole grid.** In order:

- the accuracy census, which is the first thing that will expose a mis-built model: logical error
  must fall with distance at the operating rates, as it now does on the corrected surface code;
- the `arms` mode crossover sweep, refitting `routing_threshold` on weighted graphs. The current
  rule — seven below one hundred and twenty-eight detectors, eight at or above — was fitted on unit
  weights and there is no reason it survives. If it moves, change it and say what it was fitted on;
- the routed-versus-shipped ladder over the operating rates and both families;
- the PyMatching standing, restated on weighted circuit-level DEMs at the operating rates; and
- the `latency` mode at the operating rate on both arms.

**5. Say what the weighted model costs the kernel.** The two fast paths the C1063 ledger names —
the two-defect closure lookup and the sparse core's `divide_up(needed, rate)` path — should be
measured through the existing `FastPathCensus` on both models at the same cell, so the report states
how much of the standing was tie-degeneracy rather than kernel speed.

## Gates

The usual TigerBlossom set: the debug kernel suite at four distances with the `I1`/`I2`, boundary
and no-late-entry oracles; the release suite including the zero-allocation `decode_batch` gate;
`cargo fmt --check` and `cargo clippy --all-targets --all-features -- -D warnings` in debug and
release. Additionally:

- **PyMatching exactness on the weighted model.** `verify` at twenty thousand shots per cell with
  zero weight disagreements, with PyMatching built from the same *quantized integer* weights the
  kernel compiled. Comparing quantized integers against PyMatching's floats would report
  quantization as disagreement and prove nothing.
- **The phenomenological path is untouched.** The existing repetition-family numbers must reproduce
  bit for bit on the fixed-rate generator after the change.
- **The model is the reference one.** State the stim version, the circuit generator arguments, and
  the DEM hashes in the report; a hand-rolled approximation of circuit-level noise is not admissible
  as the model this comparison stands on.
- **No run-constant branch.** Any new per-graph constant is compiled into `KernelSpec`, per
  `../ergodis-contrib/PERFORMANCE.md`.

## What would make this a negative result, and that is fine

If the weighted model removes the tie degeneracy that the closed forms exploit and the standing
against PyMatching narrows or reverses at some cells, that is the finding and it gets reported as
such. The purpose is to know, on the model real decoders consume, where the kernel actually stands.
