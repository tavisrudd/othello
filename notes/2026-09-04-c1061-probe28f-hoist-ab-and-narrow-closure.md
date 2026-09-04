# C1061 probe 28f: the hoist measured, and the certificate's narrow closure

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `22d8e98` (probe
28e's hoist, measured here), `ca31df6` (narrow closure), `324989c` (release-clippy hygiene);
evidence `348bd01`, `6121d37`; retained binaries `ergodis-tools-22d8e98` (SHA-256
`ad91af4f…6189`), `ergodis-tools-ca31df6` (`d7c8516d…19c2`); controls `ergodis-tools-604d791`
(probe 28e layout) and `ergodis-tools-586ec26` (probe 28d) · **Continues**:
`2026-09-04-c1061-probe28e-validate-on-pop-sparse-core.md`.

## Headline

**The hoist probe 28e left unmeasured is worth 5.5% to 7% of instructions at every p=0.05 cell,
and the certificate's narrow closure is a wash: instructions flat, cycles about 1% better at the
worst cell, L1 misses down a fifth there and up elsewhere.** Exactness holds against PyMatching
on all 360,000 frozen shots at both stages, cell for cell identical to probe 28e's counts.
Scaled onto probe 28d's derived standing, the three formerly losing cells are now at about
0.93x (d=9), 1.17x (d=15) and 1.28x (d=25) of PyMatching: d=9 now ahead, the other two still
behind.

## Stage one: the hoist (`22d8e98`), measured

Probe 28e's last commit reads a node's record and its owner's rate once in `touch_node` and
evaluates each incident edge against the far endpoint only. It was committed with every gate
passing and no A/B. Measured now, interleaved, eight rounds, two-size differencing, paired
log-ratio 95% intervals, against the layout build it follows and against probe 28d's control:

| d  | p     | `604d791` layout | `22d8e98` hoist | ratio     | cycles ratio | vs `586ec26` |
|----|-------|------------------|-----------------|-----------|--------------|--------------|
| 3  | 0.001 | 67.0             | 66.9            | 1.000     | 0.870        | 0.999        |
| 3  | 0.01  | 97.5             | 96.5            | 0.990     | 1.050        | 0.980        |
| 3  | 0.05  | 635.4            | 612.5           | 0.964     | 0.946        | 0.932        |
| 5  | 0.001 | 68.1             | 68.1            | 0.999     | 0.933        | 0.998        |
| 5  | 0.01  | 187.2            | 181.9           | 0.972     | 0.992        | 0.939        |
| 5  | 0.05  | 2,290.7          | 2,164.8         | 0.945     | 0.929        | 0.892        |
| 7  | 0.001 | 69.8             | 69.7            | 0.999     | 1.026        | 0.998        |
| 7  | 0.01  | 264.1            | 256.2           | 0.970     | 0.913        | 0.946        |
| 7  | 0.05  | 4,517.6          | 4,235.3         | 0.938     | 0.944        | 0.875        |
| 9  | 0.001 | 71.9             | 71.8            | 0.999     | 0.975        | 0.998        |
| 9  | 0.01  | 403.0            | 388.8           | 0.965     | 0.973        | 0.941        |
| 9  | 0.05  | 7,198.4          | 6,720.2         | **0.934** | 0.948        | **0.865**    |
| 15 | 0.001 | 81.6             | 81.2            | 0.996     | 0.946        | 0.997        |
| 15 | 0.01  | 1,065.2          | 1,015.9         | 0.954     | 0.950        | 0.932        |
| 15 | 0.05  | 15,648.7         | 14,564.7        | **0.931** | 0.945        | **0.861**    |
| 25 | 0.001 | 107.2            | 106.4           | 0.993     | 0.931        | 0.995        |
| 25 | 0.01  | 2,886.1          | 2,732.0         | 0.947     | 0.955        | 0.938        |
| 25 | 0.05  | 29,299.9         | 27,323.7        | **0.933** | 0.965        | **0.864**    |

Instructions per decode. Every instruction interval excludes 1.0 except the p=0.001 cells at
d=3 to 7, and every cycle interval at p=0.05 excludes 1.0 as well. The last column is the
instruction ratio against probe 28d's `586ec26`, the build the derived standing is scaled from.
Logs: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28f-22d8e98-{vs-604d791-binaries-ab.log,binaries-ab.log,pymatching-exactness.txt}`.

Reading it: `edge_time_from` was 22.9% of the d=25 p=0.05 profile and re-read the node's own
record and rate on every call; taking those two reads out of the incident loop is worth about
6.5% of the decode there, and the cycle ratios agree with the instruction ratios within their
intervals.

## Stage two: the certificate's narrow closure (`ca31df6`)

`KernelSpec` gains `closure_narrow`, a `u16` copy of `closure_distance`, filled at compile only
when every pair distance is finite and below `u16::MAX`, so it is entry for entry the wide table
or absent; nothing is clamped. The certificate's pair loop moves into a generic
`pairs_within<T: Into<i64>>` and `certify` dispatches once, outside the loop, to the narrow or
the wide instantiation. At d=25 the closure is 96 by 96 entries, so the narrow table is 18 KiB
against the wide table's 37 KiB, and the spec grows by exactly the narrow table. A new kernel
test asserts the mirror equals the wide table on every repetition graph the kernel is measured
on.

Measured the same way against the hoist build and against probe 28d's control:

| d  | p     | `22d8e98` hoist | `ca31df6` narrow | ratio | cycles ratio        | L1 misses ratio     | vs `586ec26` |
|----|-------|-----------------|------------------|-------|---------------------|---------------------|--------------|
| 9  | 0.01  | 388.8           | 387.3            | 0.996 | 1.037 [0.996,1.078] | 1.157 [0.991,1.350] | 0.937        |
| 9  | 0.05  | 6,720.2         | 6,702.0          | 0.997 | 0.991 [0.978,1.004] | 1.097 [0.979,1.230] | 0.862        |
| 15 | 0.01  | 1,015.9         | 1,010.1          | 0.994 | 0.990 [0.979,1.001] | 1.365 [1.290,1.444] | 0.927        |
| 15 | 0.05  | 14,564.7        | 14,543.8         | 0.999 | 0.994 [0.981,1.006] | 1.369 [1.250,1.499] | 0.859        |
| 25 | 0.01  | 2,732.0         | 2,710.4          | 0.992 | 0.977 [0.960,0.995] | 1.103 [1.057,1.151] | 0.931        |
| 25 | 0.05  | 27,323.7        | 27,469.1         | 1.005 | 0.989 [0.982,0.997] | 0.790 [0.749,0.832] | 0.868        |

The cells not shown move by less than 0.5% in instructions with cycle intervals covering 1.0.
Logs: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28f-ca31df6-{vs-22d8e98-binaries-ab.log,binaries-ab.log,pymatching-exactness.txt}`.

Reading it: the lever was sized on the certificate's 11% share of the decode and on the closure
reads being the misses inside it. The d=25 p=0.05 cell does lose a fifth of its L1 misses
(42.9 to 33.9 per decode), but that buys 1.1% of cycles, not the several per cent the share
suggested, and the extra zero-extend costs 0.5% of instructions there. The certificate's own
share in the new profile is 7.6% (below), so the closure reads were a minority of it. The
change is kept as committed because it is exact, gated, and never worse in cycles at a losing
cell, but it is marginal, and reverting it is a one-commit decision.

## Profile of `ca31df6`, d=25 p=0.05

`perf record` over 163,840 decodes, self time by symbol: `solve` 29.9%, `touch_node` 28.6%
(the edge evaluation is now inlined into it), `certify` 7.6%, `push_event` 7.4%, `descend`
6.4%, `on_collision` 3.8%, `dissolve` 3.6%, `common_chain_sum` 3.6%, `touch_region` 1.4%.
Compared with probe 28e's profile of `604d791`: `edge_time_from` plus `touch_node` were 30.9%
and are now 28.6% as one symbol; `certify` fell from 11.1% to 7.6% plus the 3.6% of
`common_chain_sum` that was previously inlined into it.

## Gates, at each committed stage

The debug kernel suite (the random suite at four distances, 20,000 instances each, with the
`I1`/`I2`/boundary assertion and the no-late-entry oracle after every event, plus the new
mirror-equality test): all pass. The release kernel suite including the zero-allocation
`decode_batch` gate: all pass. Library clippy `-D warnings` clean in debug, and now in release
too: `324989c` puts `#[cfg(debug_assertions)]` on the two helpers only the debug oracles call,
which release clippy had been flagging as dead since probe 28e without anyone running it in
release. `rustfmt` clean. PyMatching 2.4.0 `verify` on `--mode emit --operations 20000` per
cell: zero minimum-weight disagreements on all eighteen cells for both `22d8e98` and `ca31df6`,
and the prediction-mismatch counts (the documented tie policy) are identical cell for cell to
`604d791`'s. The A/B runs shared the box with the mirror's builds and test runs, which is why
the p=0.001 cycle intervals are wide; every headline figure is an instruction ratio.

## Mystery ledger

- **The three p=0.05 cells against PyMatching.** Settled today: the hoist was worth 6.5% and
  the closure reads were not where the certificate's time goes. Open: d=15 and d=25 at about
  1.17x and 1.28x derived. The profile now says the next levers are `touch_node` at 28.6% (one
  dependent load of the far owner's rate per incident edge, per probe 28e's instruction-level
  profile) and `solve` at 29.9% with its inlined handlers.
- **L1 misses rise at d=15 under the narrow closure** (2.7 to 3.7 per decode at p=0.05, 1.37x
  with a tight interval) while falling at d=25. Open and unexplained; the absolute counts are
  tiny against the cell's cycles and the instruction counts are flat, so it reads as an
  allocation-placement effect of the extra table rather than a read-pattern one. Not measured.
- **`descend` at 6.4% with no blossoms in most shots.** Still open, unchanged from probe 28e.
- **Newtype indices.** Still open as hygiene.

## Vibe check

Good on the hoist, flat on the mirror. One more cell crossed to the winning side, the profile
is cleaner, and the certificate is no longer the place to look.

## Next

1. `touch_node`: the far owner's rate is a dependent load per incident edge; test caching a
   region's rate on the node record or reading it through the incident slot.
2. Then the predecoder items from probe 28c, unchanged.
