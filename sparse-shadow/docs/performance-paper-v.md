# Paper-V performance record

## Workload and contract

The frozen Paper-V workload has six conference axes, the signed complete graph,
an order-four lift of the residual outer `C2` coset, a selected chordal line,
six conference nodes, and twelve points on the chordal singular quartic. The
declared equivalence action is the full 720-element relabeling group `S6`.
The combined signed residue and outer lift have trivial marked automorphism
group, matching exact marked return after the selected-line calibration.

The production loop uses fixed `[u8; 6]` permutations and a 21-byte fixed key:
15 conference signs followed by the conjugated outer lift. Group construction,
schema conversion, and certificate serialization remain cold. The instrumented
allocator gate reports zero allocations, reallocations, or deallocations over
all 720 hot leaves; compile-time assertions freeze key size and alignment.

## Measurement

From `sparse-shadow/`, after `cargo build --release --locked --offline`:

```sh
perf stat -r 20 -x, -e task-clock,cycles,instructions,branches,branch-misses \
  taskset -c 0 target/release/sparse-shadow canonicalize \
  ../papers/chordal-conference-reconstruction/verification/evidence/sparse_shadow_export.json >/dev/null
```

On the Ryzen AI 9 HX 370 host, pinned to CPU 0, the 2026-08-25 run measured a
mean 1.76 ms task-clock (2.41% relative variation), 5.53 million cycles, 13.49
million instructions, 2.61 million branches, and 0.088 million branch misses.
These are fixture- and machine-specific measurements, not proved bounds or a
performance-floor claim.

The exact native and independent checker counters are 720 nodes and 720 leaves,
with zero refinement rounds, depth zero, and zero arena growth. The nauty 2.9.3
encoding has 39 nodes and 54 edges. Raw and native-canonical inputs share digest
`afd022821b810c620de384db96f2d1936ae0164ea8a6216c289c41647d7052d5`;
both have automorphism order one and six nauty search nodes.
