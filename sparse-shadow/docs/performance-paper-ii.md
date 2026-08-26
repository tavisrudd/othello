# Paper-II performance record

## Workload and contract

The frozen workload is
`papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json`:
22 perfect matchings on 12 endpoints, two signed 11-element sheets, and a
four-generator `PGL2(11)` action. Canonicalization exhausts the declared group
of order 1,320 and returns the cubic-oriented stabilizer of order 660.

The production orbit loop uses fixed `[u8; 12]` permutations and a 132-byte
fixed key containing 22 six-edge blocks. Group closure, schema conversion,
certificate serialization, and result vectors stay on the cold path. The
shared instrumented allocator test reports zero allocations, reallocations, or
deallocations during all 1,320 hot leaves. Compile-time assertions freeze the
hot key's size (132 bytes) and alignment (1 byte).

## Measurement

From `sparse-shadow/`, after `cargo build --release --locked --offline`:

```sh
perf stat -r 20 -x, -e task-clock,cycles,instructions,branches,branch-misses \
  taskset -c 0 target/release/sparse-shadow canonicalize \
  ../papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json >/dev/null
```

On the repository's Ryzen AI 9 HX 370 host, pinned to CPU 0, the 2026-08-25 run
measured a mean 4.95 ms task-clock (0.98% relative variation), 18.55 million
cycles, 48.38 million instructions, 8.97 million branches, and 0.299 million
branch misses. These are measurements of this fixture and machine, not proved
bounds or a performance-floor claim. `hyperfine` was unavailable, so the
committed record uses `perf stat -r 20`; no comparative speedup claim is made.

The exact search counters are 1,320 nodes, 1,320 leaves, zero refinement rounds,
depth zero, and zero arena growth. The checker independently rebuilds the
declared orbit and exact certificate. The colored-incidence nauty 2.9.3
cross-check uses 166 graph nodes and 396 edges; raw and native canonical
encodings share digest
`286566ef3ad75aae814d2b5d0d0ea9fee6902877f500d2b28548d531ef602fa0`
and both have automorphism order 660.
