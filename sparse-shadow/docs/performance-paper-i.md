# Paper-I performance record

Measurement date: 2026-08-25. Fixture:
`fixtures/paper-i-icosahedral-orbitals.json`. Toolchain: Rust 1.85.0,
`--release`, criterion 0.7.0 with default features disabled. Hardware: AMD
Ryzen AI 9 HX 370, 24 logical CPUs, 12 MiB aggregate L2, two L3 instances / 24
MiB aggregate. Recorded command:

```sh
taskset -c 0 cargo bench --bench paper_i -- --noplot
```

## Exact workload counters

| counter | result | status |
|---|---:|---|
| search nodes | 193 | measured exact counter |
| canonical leaves | 120 | measured exact counter |
| refinement rounds | 385 | measured exact counter |
| maximum branch depth | 3 | measured exact counter |
| automorphism-buffer cold grows | 0 | measured exact counter |
| automorphism group order | 120 | independently replayed exact result |
| emitted generators | 3 | closure checked against the 120 returned actions |
| representative point stabilizer order | 10 | recomputed from the certified full group |
| compact canonical certificate | 5,237 bytes | deterministic compact JSON, excludes surrounding artifact |

The allocation test wraps the system allocator and brackets only the search
loop after its 256-entry automorphism buffer is allocated. Across the full
fixture search it reports zero allocations, reallocations, and deallocations.
The preallocated equality buffer is 3,072 bytes. Any exhausted buffer takes an
explicit `#[cold]` growth path and increments `arena_grows`; the representative
fixture records zero.

Hot record layouts are compile-time guarded:

| record | size | alignment |
|---|---:|---:|
| partition | 32 B | 1 B |
| refinement signature | 64 B | 64 B |
| canonical leaf key | 32 B | 8 B |
| dense Paper-I relations | 128 B | 64 B |

## Wall-time measurements and boundary

Two consecutive CPU-0-pinned criterion runs gave:

| workload | run 1 95% interval | run 2 95% interval |
|---|---:|---:|
| producing canonicalizer, end to end | 310.42--312.31 us | 425.87--426.92 us |
| independent exhaustive replay, end to end | 5.0531--5.2631 ms | 7.0666--7.1286 ms |

The 37% drift despite CPU pinning is a measurement confound, not an algorithmic
comparison. Criterion's sequential “improved/regressed” messages are ignored.
No speedup, regression, floor, or performance bound is claimed, and no
optimization was accepted from these wall times. The hot representation was
accepted on the contractually required layout/allocation evidence plus unchanged
exact search outputs. A future optimization decision must use an interleaved A/B
harness and cycles/instructions per search node.

After point stabilizers, full-wrapper replay, strict calibration, and the golden
contract landed, a CPU-0-pinned smoke run at commit `7d0344136` measured
`canonicalize_end_to_end` at 256.83--257.90 us and
`independent_replay_end_to_end` at 3.9228--3.9395 ms. This single run confirms
the current benchmark target executes and preserves the frozen counters; it is
not an A/B experiment. Criterion's comparison against its local historical
baseline is again ignored, and no speedup claim is made.

The independent reference implementation is a correctness baseline, not a
performance baseline. No established tool was timed: nauty/bliss require a
colored incidence encoding whose version/options change the canonical form, and
Vole/Sage need a separately frozen action adapter. The prior-art audit names
these future baselines; the current format does not permit a like-for-like run
without changing the measured object.
