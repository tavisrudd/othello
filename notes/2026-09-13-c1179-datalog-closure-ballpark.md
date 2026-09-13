# C1179 — Datalog transitive-closure ballpark

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: ballpark, not a matched comparison

## Scope

One transitive-closure program, one edge set per `(N, density)` pair, fed to both the Ergodis
rules path and Soufflé. The purpose is an order-of-magnitude reading, not a benchmark.

## Versions and host

| Item          | Value                                                       |
|---------------|-------------------------------------------------------------|
| Ergodis core  | `/home/tavis/src/ergodis` at `2074025`                      |
| Rust          | `rustc 1.95.0 (59807616e 2026-04-14)`, nixpkgs, matches pin |
| Soufflé       | 2.5, 32-bit word, `ffi openmp ncurses sqlite zlib`          |
| Soufflé store | `/nix/store/7f17fq5wcg19x5s4f7kh3pvknl8zfa55-souffle-2.5`   |
| C++ toolchain | `nixpkgs#gcc`, `nixpkgs#gnumake` (for `souffle -o`)         |
| Timing, small | `nixpkgs#perf` `perf stat -r 5`, N ≤ 32                     |
| Timing, large | GNU `time -f "%e %M"`, best of 3, N ≥ 64                    |
| Host CPU      | AMD Ryzen AI 9 HX 370, 24 logical CPUs                      |
| Host load     | load average 0.56 to 2.61 during the runs                   |

## Commands

Harness: private `ergodis-private/examples/closure_ballpark.rs` (private `c02eae8`; it was
drafted under the core rules crate's examples and moved to the private repository unchanged,
with `ergodis-rules` added as a private dev-dependency). Core is untouched.

```
cd /home/tavis/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc -c cargo build --release -p ergodis-private \
  --example closure_ballpark
/home/tavis/.cache/ergodis/target/ergodis-private/release/examples/closure_ballpark \
  <N> <sparse|dense> 51 <outdir>
```

The harness writes `<outdir>/edge.facts` as tab-separated `x\ty` from a deterministic xorshift64
seeded by the domain size, then grounds and evaluates the same edge set. `sparse` is 3 out-edges
per node, `dense` is `N/4`, self-loops rejected, targets deduplicated. Reported `prepare` is
`Prepared::new` (grounding included); `eval` is the median of 51 warm `evaluate_into` calls into a
preallocated workspace, with no file or serialization work inside the timed region.

Soufflé program `tc.dl`:

```
.decl edge(x:number, y:number)
.input edge
.decl path(x:number, y:number)
.output path
path(x,y) :- edge(x,y).
path(x,y) :- edge(x,z), path(z,y).
```

```
nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake -c souffle -o <dir>/tc_bin <dir>/tc.dl
nix shell nixpkgs#souffle nixpkgs#time -c souffle  -F <in> -D <out> -j1 <dir>/tc.dl
nix shell nixpkgs#souffle nixpkgs#time -c <dir>/tc_bin -F <in> -D <out> -j1
```

Soufflé times are whole-process wall: process start, reading `edge.facts`, evaluation, and writing
`path.csv`. Ergodis `eval` excludes all of that; Ergodis `prepare` is the closest comparable to a
Soufflé process, and the last column of each table gives both ratios.

## Sparse: 3 out-edges per node

| N    | edges  | path tuples | Ergodis prepare s | Ergodis eval median s | Ergodis peak RSS | Soufflé interp s | Soufflé compiled s | Soufflé peak RSS (interp / compiled) | eval / compiled | (prepare + eval) / compiled |
|------|--------|-------------|-------------------|-----------------------|------------------|------------------|--------------------|--------------------------------------|-----------------|-----------------------------|
| 4    | 12     | 16          | 0.000034          | 0.00000041            | 2.48 MB          | 0.01003          | 0.001651           | 8.84 MB / 4.75 MB                    | 0.00025         | 0.021                       |
| 8    | 24     | 64          | 0.000222          | 0.0000041             | 2.45 MB          | 0.00968          | 0.002168           | 8.78 MB / 4.69 MB                    | 0.0019          | 0.104                       |
| 12   | 36     | 132         | 0.000314          | 0.0000058             | 2.58 MB          | 0.00948          | 0.002082           | 8.79 MB / 4.62 MB                    | 0.0028          | 0.153                       |
| 16   | 48     | 240         | 0.000845          | 0.0000136             | 2.65 MB          | 0.00954          | 0.002380           | 8.69 MB / 4.76 MB                    | 0.0057          | 0.361                       |
| 20   | 60     | 380         | 0.001632          | 0.0000245             | 2.79 MB          | 0.00928          | 0.002260           | 8.79 MB / 4.75 MB                    | 0.0108          | 0.733                       |
| 24   | 72     | 508         | 0.002591          | 0.0000374             | 3.10 MB          | 0.01016          | 0.002216           | 8.92 MB / 4.62 MB                    | 0.0169          | 1.186                       |
| 25   | 75     | 600         | rejected          | rejected              | rejected         | 0.00             | 0.00               | 8.78 MB / 4.76 MB                    | —               | —                           |
| 32   | 96     | 960         | rejected          | rejected              | rejected         | 0.01024          | 0.002654           | 8.78 MB / 4.61 MB                    | —               | —                           |
| 64   | 192    | 3 905       | rejected          | rejected              | rejected         | 0.01             | 0.00               | 8.74 MB / 4.61 MB                    | —               | —                           |
| 128  | 384    | 14 852      | rejected          | rejected              | rejected         | 0.01             | 0.00               | 8.77 MB / 4.82 MB                    | —               | —                           |
| 256  | 768    | 62 979      | rejected          | rejected              | rejected         | 0.03             | 0.01               | 9.62 MB / 5.50 MB                    | —               | —                           |
| 512  | 1 536  | 246 280     | rejected          | rejected              | rejected         | 0.08             | 0.05               | 12.65 MB / 8.38 MB                   | —               | —                           |
| 1024 | 3 072  | 979 983     | rejected          | rejected              | rejected         | 0.31             | 0.23               | 25.33 MB / 21.43 MB                  | —               | —                           |

## Dense: N/4 out-edges per node

| N    | edges   | path tuples | Ergodis prepare s | Ergodis eval median s | Ergodis peak RSS | Soufflé interp s | Soufflé compiled s | Soufflé peak RSS (interp / compiled) | eval / compiled | (prepare + eval) / compiled |
|------|---------|-------------|-------------------|-----------------------|------------------|------------------|--------------------|--------------------------------------|-----------------|-----------------------------|
| 4    | 4       | 8           | 0.000093          | 0.00000014            | 2.48 MB          | 0.00856          | 0.001908           | 8.72 MB / 4.75 MB                    | 0.000073        | 0.049                       |
| 8    | 16      | 56          | 0.000208          | 0.0000017             | 2.44 MB          | 0.00995          | 0.001950           | 8.72 MB / 4.62 MB                    | 0.00089         | 0.108                       |
| 12   | 36      | 132         | 0.000318          | 0.0000058             | 2.50 MB          | 0.00971          | 0.001927           | 8.82 MB / 4.59 MB                    | 0.0030          | 0.168                       |
| 16   | 64      | 256         | 0.001021          | 0.0000147             | 2.58 MB          | 0.00996          | 0.002141           | 8.86 MB / 4.75 MB                    | 0.0069          | 0.484                       |
| 20   | 100     | 400         | 0.001390          | 0.0000271             | 2.78 MB          | 0.01035          | 0.002066           | 8.80 MB / 4.69 MB                    | 0.0131          | 0.686                       |
| 24   | 144     | 576         | 0.002372          | 0.0000450             | 2.96 MB          | 0.00943          | 0.001999           | 8.94 MB / 4.69 MB                    | 0.0225          | 1.209                       |
| 25   | 150     | 600         | rejected          | rejected              | rejected         | 0.01             | 0.00               | 8.74 MB / 4.54 MB                    | —               | —                           |
| 32   | 256     | 1 024       | rejected          | rejected              | rejected         | 0.01002          | 0.002546           | 8.85 MB / 4.75 MB                    | —               | —                           |
| 64   | 1 024   | 4 096       | rejected          | rejected              | rejected         | 0.01             | 0.00               | 8.72 MB / 4.69 MB                    | —               | —                           |
| 128  | 4 096   | 16 384      | rejected          | rejected              | rejected         | 0.02             | 0.02               | 8.81 MB / 4.99 MB                    | —               | —                           |
| 256  | 16 384  | 65 536      | rejected          | rejected              | rejected         | 0.14             | 0.08               | 9.91 MB / 5.77 MB                    | —               | —                           |
| 512  | 65 536  | 262 144     | rejected          | rejected              | rejected         | 1.01             | 0.62               | 15.18 MB / 10.97 MB                  | —               | —                           |
| 1024 | 262 144 | 1 048 576   | rejected          | rejected              | rejected         | 8.22             | 5.07               | 35.78 MB / 31.68 MB                  | —               | —                           |

At N = 12 the two densities coincide: `N/4 = 3` equals the sparse out-degree, so both rows describe
the same edge set. Their independently measured numbers agree to within run-to-run noise. Below
N = 12 the labels invert, since `N/4 < 3` gives the `dense` setting fewer edges than the `sparse`
one (4 against 12 at N = 4, 16 against 24 at N = 8).

## Where the cubic grounding stops fitting

Ergodis rejects every domain above N = 24 with `Error::Budget`. The binding constraint is not
memory. `ergodis_verify::rule_contract::ground` enforces

```
(scalar_count + 1) * products.len() <= MAX_WORK          // MAX_WORK = 16_777_216
```

For this program `scalar_count = 2N^2 + 1` (the `edge` and `path` blocks plus the unit slot) and
`products.len() = N^2 + N^3` (the base rule grounds N^2 products, the recursive rule N^3), so the
product is about `2N^5`. At N = 24 it is `1154 * 14400 = 16 617 600`, inside the cap; at N = 25 it
is `1252 * 16250 = 20 345 000`, outside it. Two further caps would bind later: `domain > 32` is
rejected outright, and `MAX_SCALARS = 4096` would bind at N = 45.

Measured peak resident set size at N = 24 is 3.10 MB (sparse) and 2.96 MB (dense), against a
Soufflé compiled-binary baseline of 4.6–4.8 MB at the same sizes. Preparation at N = 24 takes 2.4
to 2.6 ms. Neither an 8 GB memory ceiling nor a 60 s preparation ceiling is approached anywhere
below the budget rejection: the grounding stops at a declared contract constant, at 3.10 MB of peak
resident memory and 2.6 ms of preparation.

Soufflé, on the same generator, reaches N = 1024 dense (262 144 edges, 1 048 576 path tuples) in
5.07 s compiled at one thread and 31.68 MB peak RSS.

## Correctness

Every `(N, density)` pair on which both systems ran produced identical `path` tuple counts: sparse
N = 4, 8, 12, 16, 20, 24 giving 16, 64, 132, 240, 380, 508; dense N = 4, 8, 12, 16, 20, 24 giving
8, 56, 132, 256, 400, 576. No mismatch was observed, so there is nothing to report verbatim.

## Reading of the numbers

1. Warm Ergodis evaluation of an already-grounded program is 0.00007 to 0.023 times the cost of a
   whole Soufflé compiled process at the same input, and that gap narrows monotonically with N in
   both densities.
2. Counting Ergodis preparation, the two are level at N = 24: the ratio is 1.19 sparse and 1.21
   dense, having risen from 0.02 and 0.05 at N = 4. Ergodis preparation grows faster than Soufflé's
   whole-process cost over the range where both run.
3. Soufflé whole-process time at N ≤ 32 is flat at about 9.5 ms interpreted and 2.1 ms compiled,
   independent of N and density, so those figures are process overhead rather than solve work. The
   Soufflé interpreter's own profiler reports the `path` relation at 1.40–1.86 M tuples/s at N = 16
   and N = 24, implying 130–400 µs of evaluation inside those processes, against 13.6–45 µs of warm
   Ergodis evaluation.
4. Ergodis product checks are 14 496 (sparse) and 17 856 (dense) at N = 24, against 14 400 grounded
   products, so the work performed tracks the grounding rather than the edge count. Soufflé's
   compiled time at N = 1024 differs by a factor of 22 between the two densities (0.23 s against
   5.07 s) on an edge-count ratio of 85; Ergodis evaluation at N = 24 differs by a factor of 1.20
   (37.4 µs against 45.0 µs) on an edge-count ratio of 2.0.

## Caveats

Single box, one measurement session, other load present (load average 0.56 to 2.61). No interleaved
A/B and no repeated interleaving between the two systems: each system's runs are contiguous. The
two timed regions are not matched — Ergodis `eval` excludes I/O, grounding and process start, while
every Soufflé figure includes all of them. Ergodis ran one worker; Soufflé ran `-j1`; no
multi-threaded configuration was measured. Soufflé wall times for N ≥ 64 come from GNU `time` at
10 ms resolution and are quantized accordingly. Edge sets come from one generator at one seed per
domain size, with no repetition across seeds. Nemo was not attempted.
