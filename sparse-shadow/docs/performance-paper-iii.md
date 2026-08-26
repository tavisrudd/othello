# Paper-III performance record

## Workload and contract

The frozen workload is
`papers/clebsch-passages/verification/sparse_shadow_export.json`: six conference
labels, the empty aligned four-set family of the paper's conference example,
and the full 720-element relabelling group `S6`. The canonical certificate has
automorphism order 720 because every relabelling preserves the empty family.

The production orbit loop stores permutations as contiguous `[u8; 6]` records
and represents the 15 possible four-sets by a 2-byte bit key with compile-time
size and alignment assertions. Group closure, schema conversion, certificate
serialization, and result-vector conversion remain cold. The shared allocator
gate reports zero allocations, reallocations, or deallocations across all 720
hot leaves.

A leverage estimate puts at most `720 * 15` four-set mappings in the generic
loop, and zero for this frozen empty-family input. Consequently the end-to-end
cost is expected to be dominated by cold validation, construction of the full
720-element automorphism certificate, hashing, and JSON serialization rather
than the 2-byte key calculation. This is why no parallel path or more elaborate
refinement structure was added.

## Measurement

From `sparse-shadow/`, after `cargo build --release --locked --offline`:

```sh
perf stat -r 20 -x, -e task-clock,cycles,instructions,branches,branch-misses \
  taskset -c 0 target/release/sparse-shadow canonicalize \
  ../papers/clebsch-passages/verification/sparse_shadow_export.json >/dev/null
```

On the Ryzen AI 9 HX 370 host, pinned to CPU 0, the 2026-08-26 run measured a
mean 2.24 ms task-clock (2.44% relative variation), 7.85 million cycles, 22.20
million instructions, 4.43 million branches, and 0.114 million branch misses.
These are fixture- and machine-specific measurements, not proved bounds or a
performance-floor claim. There is no speedup claim: the earlier allocation-prone
prototype was corrected before an interleaved A/B baseline was frozen.

The exact native and independent-checker counters are 720 nodes and 720 leaves,
with zero refinement rounds, depth zero, and zero arena growth. The colored
incidence encoding has six nodes and no edges, hence automorphism order 720.
