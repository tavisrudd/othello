# C1061 probe 28c: blossom expansion, the dense matcher retired, and TigerBlossom behind the predecoder

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `a00af4f`,
`3e55370`, `517d249`, `f8809e4`, `fea19d6`; retained binaries `ergodis-tools-3e55370` (matcher A/B) and
`ergodis-tools-f8809e4` (pipeline) · **Continues**:
`2026-09-04-c1061-probe28b-tiger-blossom-dual-drift.md` and the next-session plan in
`2026-09-03-c1061-exploration-log.md`.

## Headline

**Blossom expansion is implemented and the dense matcher is deleted: region growth over the
compiled detector graph is now the only general solver, every block on the random suite is
answered and certified, and all eighteen cells improved against the probe-28b control (0.889x to
0.999x instructions), the worst cell by 7.8%.** Exactness holds against PyMatching on all 360,000
frozen shots.

**TigerBlossom is wired behind the certified predecoder and used as its exact oracle, and the
oracle kills the predecoder as a cost lever at the radii built so far:** margins 1 and 2 are
unsound at every cell (the pipeline's weight exceeds the minimum on a fraction of shots at every
distance and both rates), margin 3 is sound on every cell over 65,536 shots, and at margin 3 the
predecoder commits only empty actions, so the residual it hands the kernel is the whole syndrome.
The sweep is pure overhead in front of the kernel.

A third finding is a defect in the surface-code graph: its check-support masks were thirty-two
bits wide and distance 9 has forty checks, so in release builds every distance-9 surface graph
built before today aliased checks 32 to 39 onto 0 to 7. Every surface distance-9 number in probes
27, 29, 30 and 31 was computed on that corrupted graph and has to be re-derived; the mask is now
sixty-four bits and the kernel rejects a non-matching graph outright, which is how the defect
surfaced.

## Part one: the matcher

### Expansion

An inner blossom shrinks like any region; when its dual reaches zero an expand event fires (its
own event kind, in the late lane with releases and phantom contacts, armed for the clock at which
the radius is zero). The handler releases the nodes the blossom absorbed itself, unfolds every
member (subtracts the member's frozen radius from the wrapped sum of every node and phantom
under it and returns those nodes to the member), then splits the odd cycle at the member holding
the parent's contact and the member holding the mate's contact. The way round with an even number
of edges becomes the alternating path that replaces the blossom in the tree, inner and outer by
turns; the members on the other way round pair off in consecutive couples and leave the tree. The
blossom itself is left dead: no children, no links, radius zero, still counted in the dual sum at
zero. Nothing numerical changes at the instant of expansion, because the radius is zero, so the
only rescheduling is for the rate changes: new outer members are rescheduled in full, new inner
members keep their queued entries (their local radii are the same linear functions of the clock as
before), and the paired members, which stopped shrinking, have their neighbours re-armed.

Two latent defects were fixed on the way, both exposed only once inner blossoms exist:

- `dissolve` re-armed only a shrinking region's own node list when it froze; a shrinking blossom's
  nodes live in its members' lists, so its neighbours never saw the rate rise. It now walks the
  subtree.
- A collision from a frozen or released side: see the edge-keyed entries below.

### One entry per edge

Both endpoints computed the same collision time, so the queue stamp is now keyed by the edge
(edges are numbered once at construction, both directions sharing one identifier) and the entry
carries the edge identifier rather than a node and slot. The first version kept the pop handler
one-sided and the invariant assertion caught the consequence within one test run: an entry armed
from a node that was later released popped on the uncovered side and was dropped, an overgrown
edge by one unit at clock 5. The handler now resolves the covered and growing side at pop time.
The same invariant argument removed the stamp clearing in `fold_subtree`: a stamp means exactly
that an entry for that time is queued, only the consuming pop clears it, and a rate change
re-arms from the changed side, pushing only when the new time differs. Clearing a stamp shared
with the far endpoint would orphan that endpoint's entry.

### The dense matcher is gone

`tiger_blossom_match.rs`, the pair-matrix reduction to a maximum-weight perfect matching on
`2 x size` vertices, and the dense arm of the cluster path are deleted. Every specialization level
now routes a general block to region growth; a block the matcher cannot answer, which is a
capacity exhaustion and never a structural decline, takes the bounded path and is flagged. The
pair matrix and cluster decomposition stay for the lower levels and for the two- and four-defect
closed forms.

### The local certificate is not taken, with a reason

The plan's second simplification was to replace the LP pair loop with the two local invariants.
Working it through: `I1`, `I2`, the boundary bound, non-negative blossom duals and objective
equal to primal cost do imply optimality for edges between different outermost regions, but an
edge between two members of one blossom carries the blossom's radius on both sides and satisfies
only the frozen inequality, which is the LP pair form `g(a) + g(b) - 2 * shared(a, b) <= w` with
the shared chain sum subtracted; the phantom edge needs the same correction. So the local
certificate is the pair certificate restricted to edges, with a chain walk per intra-blossom
edge, not a simpler object. On instructions it does not obviously win either: at sixteen defects
the pair loop is 120 pairs of a few table reads, while a footprint walk is several hundred edges.
Left as is; the closure stays a pricing table and the certificate stays LP duality.

### Gates

- **Random suite** (four distances, 20,000 instances each, debug build with the `I1`/`I2`/boundary
  assertion after every event): 80,000 answered, 80,000 certified, zero declined, zero needing a
  blossom operation, zero exhausted. The ratchet now demands full coverage as well as full
  certification.
- **Kernel tests**: all pass, including the reference-matching agreement on random shots and the
  zero-allocation gate on `decode_batch`.
- **Exactness** (`tiger-blossom-bench --mode emit --operations 20000` per cell, PyMatching 2.4.0
  `verify`, binary `ergodis-tools-3e55370`): zero minimum-weight disagreements on all eighteen
  cells, 360,000 shots. Prediction differences (273 at d=3 p=0.05 down to 0 at low p) are the
  documented tie policy, unchanged. Evidence: ergodis-private
  `benchmarks/tiger-blossom/2026-09-04-probe28c-3e55370-pymatching-exactness.txt`.
- **Library clippy** `-D warnings`: clean. (The tools crate carries seven pre-existing findings in
  other probes' bench files, untouched.)

### Instructions per decode, `3e55370` against the retained probe-28b control `dfd4ee0`

Interleaved, eight rounds, two-size differencing, paired log-ratio 95% intervals; every interval
excludes 1.0. Log: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28c-3e55370-binaries-ab.log`.

| d  | p     | control  | candidate | ratio     |
|----|-------|----------|-----------|-----------|
| 3  | 0.001 | 67.1     | 67.0      | 0.999     |
| 3  | 0.01  | 100.1    | 98.7      | 0.986     |
| 3  | 0.05  | 698.4    | 665.0     | 0.952     |
| 5  | 0.001 | 68.3     | 68.2      | 0.999     |
| 5  | 0.01  | 210.5    | 197.0     | 0.936     |
| 5  | 0.05  | 2,833.3  | 2,520.2   | **0.889** |
| 7  | 0.001 | 69.9     | 69.8      | 0.999     |
| 7  | 0.01  | 284.2    | 274.2     | 0.965     |
| 7  | 0.05  | 5,360.4  | 5,060.8   | 0.944     |
| 9  | 0.001 | 72.1     | 72.0      | 0.998     |
| 9  | 0.01  | 437.8    | 418.8     | 0.957     |
| 9  | 0.05  | 8,635.5  | 8,159.4   | 0.945     |
| 15 | 0.001 | 82.0     | 81.6      | 0.995     |
| 15 | 0.01  | 1,150.0  | 1,110.2   | 0.965     |
| 15 | 0.05  | 18,260.2 | 17,835.5  | 0.977     |
| 25 | 0.001 | 108.1    | 107.1     | 0.990     |
| 25 | 0.01  | 3,103.7  | 2,969.8   | 0.957     |
| 25 | 0.05  | 36,134.1 | 33,330.2  | **0.922** |

The mid-cell cost probe 28b paid for handling the dropped collisions is recovered and more. Scaling
today's ratios onto probe 28b's standing against PyMatching puts the three losing p=0.05 cells at
about 1.13x (d=9), 1.43x (d=15) and 1.56x (d=25); none is closed, and that arithmetic is derived,
not a fresh external A/B. Where the remaining cost sits is in the profile below.

### Profile of the worst cell, d=25 p=0.05

`perf record` over 163,840 decodes of `ergodis-tools-f8809e4`, self time, symbols above 1.5%
(`benchmarks/tiger-blossom/2026-09-04-probe28c-profile-d25-p0.05.txt`):

| symbol                       | self   |
|------------------------------|--------|
| `solve` (event loop, inlined handlers) | 26.9% |
| `edge_event_time`            | 21.7%  |
| `certify`                    | 11.1%  |
| `schedule_node`              | 11.0%  |
| `dissolve`                   | 5.1%   |
| `rearm_incident`             | 3.7%   |
| `on_collision`               | 3.3%   |
| `descend`                    | 2.9%   |
| pricing from the closure     | 2.8%   |
| `push_event`                 | 2.6%   |

Scheduling is the cost: event-time evaluation plus node scheduling plus re-arming is about two
fifths of the decode, and the event loop itself another quarter. The certificate is 11%, which
bounds what the local certificate could have saved and confirms leaving it. The next lever is
fewer event-time evaluations per event, not a cheaper certificate: every `schedule_node` call
re-evaluates all of a node's edges, and `rearm_incident` calls it once per neighbour of a changed
node.

## Part two: TigerBlossom behind the predecoder

### The pipeline

`predecoder_pipeline.rs` compiles the predecoder's decoding graph into a kernel spec (unit
weights, the logical flag as observable bit zero) and runs one shot through the sparse margin
sweep and then the kernel on the residual, allocation-free after construction. The contract that
makes the sum exact is probe 29's: a safe committed action preserves a global minimum, so
committed weight plus residual minimum equals the minimum-weight matching of the original shot,
which is what the kernel alone computes. The bench asserts that equality shot by shot, which makes
the kernel the exact oracle for the certificate at every distance the kernel reaches; probe 31's
oracle stopped at surface distance 3.

### The audit

`margin-certificate-bench --mode pipeline`, one tier per cell, 65,536 shots per row, six rounds.
`heavier` counts shots where the pipeline's weight exceeds the kernel's; the pipeline was never
lighter, which is the kernel's certificate holding.

| family     | d  | radius | p    | delta 1 heavier | delta 2 heavier | delta 3 heavier |
|------------|----|--------|------|-----------------|-----------------|-----------------|
| repetition | 9  | 2      | 0.01 | 3               | 0               | 0               |
| repetition | 9  | 2      | 0.05 | 324             | 13              | 0               |
| repetition | 15 | 2      | 0.01 | 4               | 0               | 0               |
| repetition | 15 | 2      | 0.05 | 545             | 20              | 0               |
| surface    | 5  | 1      | 0.01 | 102             | 3               | 0               |
| surface    | 5  | 1      | 0.05 | 1,570           | 58              | 0               |
| surface    | 7  | 1      | 0.01 | 173             | 3               | 0               |
| surface    | 7  | 1      | 0.05 | 3,323           | 110             | 0               |
| surface    | 9  | 1      | 0.01 | 312             | 6               | 0               |
| surface    | 9  | 1      | 0.05 | 6,087           | 165             | 0               |

Probe 30 measured the smallest sound margin as 1 to 2 at radius 2 and 2 to 3 at radius 1 over
syndromes of weight at most 4, and extrapolated `Delta = 2` to surface distance 5. Both are wrong
past that audit domain: `Delta = 2` commits a non-optimal action on a fraction of shots at every
cell, at 1% error as well as 5%. The audited-sound radius-1 value of 3 is what holds, at every
distance and at radius 2 too.

### At margin 3 the predecoder commits nothing

The census at `Delta = 3`, per shot, 65,536 shots per row:

| family     | d  | p    | defects | evaluated | committed | deferred | committed weight | shot defer rate |
|------------|----|------|---------|-----------|-----------|----------|------------------|-----------------|
| repetition | 9  | 0.01 | 1.72    | 1.81      | 1.24      | 0.57     | 0                | 0.304           |
| repetition | 9  | 0.05 | 7.67    | 6.05      | 3.32      | 2.73     | 0                | 0.843           |
| repetition | 15 | 0.01 | 3.00    | 3.24      | 2.42      | 0.82     | 0                | 0.420           |
| repetition | 15 | 0.05 | 13.42   | 10.51     | 6.45      | 4.06     | 0                | 0.939           |
| surface    | 5  | 0.01 | 3.45    | 4.67      | 0.91      | 3.76     | 0                | 0.500           |
| surface    | 5  | 0.05 | 14.61   | 15.06     | 1.38      | 13.68    | 0                | 0.970           |
| surface    | 7  | 0.01 | 7.11    | 10.99     | 3.57      | 7.42     | 0                | 0.749           |
| surface    | 7  | 0.05 | 29.98   | 33.19     | 4.76      | 28.43    | 0                | 0.999           |
| surface    | 9  | 0.01 | 12.08   | 19.86     | 7.84      | 12.02    | 0                | 0.894           |
| surface    | 9  | 0.05 | 50.74   | 58.10     | 10.00     | 48.10    | 0                | 1.000           |

Every commit at margin 3 is the empty action: a position whose ball syndrome is consistent with
"nothing to do here" commits that, and every position that would commit a real correction defers.
The residual defect count equals the original at every cell. This is probe 30's own diagnosis
("a radius-1 ball expresses cost differences of only 0, 1, 2, so margin 3 exceeds its dynamic
range") now proved at radius 2 on the repetition code as well, and it means the certified
predecoder at the radii built so far does no work that the kernel would not do anyway. The
coverage figures reported at `Delta = 2` (97.4% of windows, shot-level defer 0.611 at d=9 and
0.212 at d=5) were coverage by unsound commits.

### What the sweep costs in front of the kernel

Interleaved, five rounds, two-size differencing, one binary (`ergodis-tools-f8809e4`), margin 3,
instructions per shot; every interval excludes 1.0. Log: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28c-pipeline-ab.log`.

| family     | d  | radius | p    | kernel alone | predecoder + kernel | ratio |
|------------|----|--------|------|--------------|---------------------|-------|
| repetition | 9  | 2      | 0.01 | 1,551.3      | 2,341.7             | 1.509 |
| repetition | 9  | 2      | 0.05 | 17,080.3     | 19,033.0            | 1.114 |
| repetition | 15 | 2      | 0.01 | 3,540.5      | 4,876.0             | 1.377 |
| repetition | 15 | 2      | 0.05 | 33,145.9     | 36,575.8            | 1.103 |
| surface    | 5  | 1      | 0.01 | 5,051.6      | 6,416.9             | 1.270 |
| surface    | 5  | 1      | 0.05 | 44,563.4     | 48,239.7            | 1.082 |
| surface    | 7  | 1      | 0.01 | 15,250.3     | 18,457.8            | 1.210 |
| surface    | 7  | 1      | 0.05 | 127,895.9    | 136,805.5           | 1.070 |
| surface    | 9  | 1      | 0.01 | 29,960.5     | 35,858.3            | 1.197 |
| surface    | 9  | 1      | 0.05 | 288,334.0    | 304,670.0           | 1.057 |

The sweep adds 6% to 51% and removes nothing, since it commits nothing. Two side facts from the
same table: the kernel on this bench costs more per shot than on the repetition bench of part one
(the `Vec<bool>` syndrome is packed per shot and the graph has six rounds), and the surface code
at d=9 p=0.05 is 288,000 instructions per shot, thirteen times the repetition d=25 cell, which is
the cost of fifty defects per shot on a graph with the boundary far from most of them.

### Per-shot latency

The unrun `latency` mode from probe 28, plus the pipeline bench's `--latency`, 65,536 shots each,
wall nanoseconds per shot on one core under `choom` (`benchmarks/tiger-blossom/2026-09-04-probe28c-latency.log`):

| arm                    | cell                       | p50    | p90    | p99    | p99.9  | max     |
|------------------------|----------------------------|--------|--------|--------|--------|---------|
| kernel, repetition bench | d=25 p=0.01              | 41     | 451    | 1,142  |        | 65,081  |
| kernel, repetition bench | d=9 p=0.05               | 340    | 1,162  | 3,176  |        | 103,513 |
| kernel, repetition bench | d=25 p=0.05              | 1,452  | 3,176  | 6,422  |        | 94,515  |
| kernel, pipeline bench | repetition d=15 p=0.05     | 1,363  | 3,076  | 6,522  | 10,830 | 18,905  |
| predecoder + kernel    | repetition d=15 p=0.05     | 1,713  | 3,497  | 7,013  | 11,581 | 25,217  |
| kernel, pipeline bench | surface d=9 p=0.01         | 1,352  | 2,545  | 5,149  | 8,807  | 20,618  |
| predecoder + kernel    | surface d=9 p=0.01         | 1,904  | 3,386  | 6,562  | 11,361 | 343,457 |
| kernel, pipeline bench | surface d=9 p=0.05         | 16,631 | 28,823 | 43,751 | 66,714 | 352,535 |
| predecoder + kernel    | surface d=9 p=0.05         | 18,314 | 30,597 | 45,214 | 65,201 | 377,822 |

Sparse events per shot at repetition d=25 p=0.05: p50 27, p99 82, max 167. The maxima in the
hundreds of microseconds on a 65,536-shot run are single outliers of the kind a preemption
produces and are not tail structure; the p99.9 column is the tail. At 1% error the kernel decodes
a surface d=9 round history in 1.4 microseconds median, 5 microseconds at p99.

### The distance-9 surface graph

`RotatedSurfaceCode::support` held one `u32` per data qubit with `1 << check`; the rotated code
has `(d^2 - 1) / 2` checks in one basis, forty at distance 9, and a shift by 32 or more wraps in
release builds. The kernel refused the resulting graph ("mechanism flips 4 detectors; this is not
a matching graph"), which is the only reason it was found. The mask is now `u64` with an assertion
at 64 checks (distance 11 is the last that fits; distance 13 needs a wider representation), and
the single-round metric closure, which indexes `2^checks` syndromes and is only ever used up to
distance 7, casts down with its own assertion. All predecoder test modules pass after the change.

Affected prior claims, all at surface distance 9 only: probe 27's boundary-alphabet and matrix-free
sweep figures at d=9, probe 29's ball-width saturation "10 bits at surface radius 1 for d = 5 to 9"
and its radius-1 surface policy at d=9, probe 30's "one 1,024-byte table identical at surface
d = 5, 7, 9" and its d=9 defer rates, and probe 31's d=9 wake-up estimate. The distance-5 and 7
figures are unaffected (24 checks at d=7). Today's d=9 rows above are on the repaired graph. The
"identical table" claim is plausible on the repaired graph, since the radius-1 ball is the same
local object, but it is unverified until re-run.

## Mystery ledger

- **The three p=0.05 cells still lose to PyMatching.** Settled today: it is no longer the dense
  fallback (gone) and no longer the mid-cell tree work (recovered). Open: the profile below names
  the next target; the local-certificate route is closed with a reason, so the remaining levers
  are the per-event cost of the sparse core and the certificate's closure reads.
- **Margin 3 at radius 1 or 2 has no dynamic range.** Settled: it commits nothing, at every cell.
  Open: whether a radius-3 ball (repetition, 2^(ball) small) or an observation-conditioned margin
  (probe 31's surviving idea) commits real corrections at margin 3; the kernel is now the oracle
  that can audit either at any distance it reaches.
- **The surface d=9 predecoder claims.** Settled: the graph was wrong, the mask is fixed. Open:
  re-running probes 29 and 30's d=9 rows; owner, whoever resumes the predecoder.
- **Instruction cost at d=25 p=0.05 vs PyMatching's 21,500.** Open; see the profile.

## Vibe check

Good on the matcher, decisive and sobering on the predecoder. Expansion went in on the first
attempt after the invariant assertion caught one dropped event, the dense matcher and its
quadratic pair matrix are gone, and every cell is faster. The predecoder side turned out to be a
test of the certificate rather than a bench of a pipeline: the kernel as oracle shows the margin
the earlier probes leaned on was unsound, the sound margin commits nothing, and the d=9 surface
numbers were on an aliased graph. Cheap to learn now rather than after an FPGA synthesis of a
table that commits only "do nothing".

## Next

1. Profile-led work on the sparse core's per-event cost at the three losing cells (the profile
   names the target).
2. Predecoder: only if a radius-3 or observation-conditioned margin commits real weight at
   `Delta = 3` under the kernel oracle; otherwise treat the certified predecoder as measured
   negative at these radii and leave it.
3. Re-derive the surface d=9 predecoder rows on the repaired graph before any of them is cited
   again.
