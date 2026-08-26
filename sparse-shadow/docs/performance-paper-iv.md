# Paper-IV performance record

Measurement date: 2026-08-25. Fixture:
`papers/q13-passant-code/verification/sparse_shadow_export.json`. Toolchain:
Rust 1.85.0, `--release`. Hardware: AMD Ryzen AI 9 HX 370, 24 logical CPUs,
12 MiB aggregate L2, two L3 instances / 24 MiB aggregate.

## Exact workload

| counter | result |
|---|---:|
| coordinates | 78 |
| weighted pairs | 3003 |
| search nodes | 3901 |
| canonical leaves / full automorphisms | 2184 |
| refinement rounds | 11701 |
| maximum depth | 4 |
| hot-loop allocations / reallocations / deallocations | 0 / 0 / 0 |
| automorphism-arena grows | 0 |

The independent checker repeats the exhaustive tree using a different dynamic
partition representation. The zero-allocation assertion applies to the native
producer after dense input preparation and before cold certificate conversion.

## CPU-pinned profile

Command:

```sh
taskset -c 0 perf stat -r 5 -e cycles,instructions,branches,branch-misses,cache-misses \
  target/release/sparse-shadow canonicalize \
  ../papers/q13-passant-code/verification/sparse_shadow_export.json >/dev/null
```

Five runs measured 0.256674 seconds mean elapsed time (0.39% relative spread),
1.26048 billion cycles, 2.96639 billion instructions, 714.71 million branches,
1.654 million branch misses, and 78,454 cache misses. These are measurements,
not proved bounds or a portability claim.

`perf record` attributed 58.94% of sampled cycles to weighted-scheme refinement,
29.09% to zero-initialization (`memset`), and 5.84% to moves. The fixed-layout
rewrite was accepted for the exact zero-allocation contract; no wall-time
speedup is claimed because the prior allocating implementation was not retained
as a controlled A/B binary. Avoiding initialization of unused signature tails
is the clearest remaining local performance lever.

## External baseline

Bundled nauty 2.9.3 canonicalized the 3,081-vertex, 6,006-edge colored-incidence
encoding with 12 reported search nodes. It independently returned group order
2,184 and identical raw/native-canonical BLAKE3 identity
`6b1b49c68cab6b85b34a536796895baec11863fb643eb9b25397bfa2c4780c15`.
The node counts are backend-specific and are not compared as equivalent units.
