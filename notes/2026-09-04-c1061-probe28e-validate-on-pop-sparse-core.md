# C1061 probe 28e: the validate-on-pop sparse core, taken and measured

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `60181a4`,
`f0aec54`, `604d791`, `22d8e98` (code), `c2ebd30`, `1333529` (evidence); retained binaries
`ergodis-tools-f0aec54` (SHA-256 `3006d945…ad50`), `ergodis-tools-604d791`
(`c552e6f3…a0e5`), `ergodis-tools-22d8e98` (`ad91af4f…6189`); control `ergodis-tools-586ec26`
(probe 28d) · **Continues**: `2026-09-04-c1061-probe28d-sparse-core-scheduling-cost.md`.

## Decision

Tavis delegated the decision on probe 28d's design note. The redesign was taken, in stages
behind the same certificate, ratchet, and 18-cell A/B: first the scheduling layer (validate on
pop, touch on change, no stamps, one debug oracle), then the layout (packed records). The
grounds: every silent defect in probes 28 to 28c was a scheduling-contract defect found only by
the certificate or PyMatching, and the layout lever the note named cannot be taken without
packing the state the scheduling layer reads.

## Headline

**The sparse core no longer has a scheduling contract to get wrong, the invariant it does have is
asserted after every handler in debug builds, and the packed layout takes the three losing
p=0.05 cells to 0.926x of probe 28d and every mid cell along with them.** Exactness holds
against PyMatching on all 360,000 frozen shots at each stage. Scaled onto probe 28d's derived
standing, the losing cells are at about 1.00x (d=9), 1.26x (d=15) and 1.37x (d=25) of
PyMatching: d=9 at parity, the other two still losing.

## What changed

### Stage one: validate on pop (`60181a4`, `f0aec54`)

- **No stamps.** The five stamp arrays and their contract ("a stamp means an entry for that time
  is queued, only the consuming pop clears it, a rate change re-arms from the changed side")
  are gone. Each event kind has one pure time function of the current state (`edge_time_from`,
  `boundary_time`, `release_time`, `phantom_time`, `expand_time`), unclamped: a value below the
  clock means the constraint is already violated. A popped entry is validated against it: equal
  acts, later re-pushes, `None` drops, earlier is a broken invariant (`reason_late`, refused into
  the bounded path; a debug assertion in debug builds). The push path refuses a candidate behind
  the clock the same way.
- **One rule for re-arming.** A handler that mutates state calls `touch_node` (all incident edges
  from whichever side is covered, the boundary, the phantom) or `touch_region` (every node and
  phantom under the region plus its release and expansion). `schedule_node`, `rearm_incident`,
  `schedule_region`, `schedule_subtree`, `rearm_subtree`, `arm_release`, `arm_expand`,
  `reschedule_edge` and `reschedule_phantom` are gone; `on_collision`, `contract`, `expand`,
  `dissolve`, `on_release`, `absorb` and the phantom re-cover each end with a touch.
- **One debug oracle.** After every handler, for every event whose true time is `Some(t)`, the
  key's remembered newest entry exists in the queue and is at most `t`, and every remembered
  time names a queued entry. This is the whole queue contract, checked where a handler could
  break it; the `I1`/`I2` feasibility check stays and sees only the consequence.
- **A one-directional cache, not a second copy of the queue.** The first build (`60181a4`)
  had no dedupe at all and pushed a quarter more entries than the control, because a stale early
  pop re-pushed a duplicate of an entry that was already queued. `f0aec54` remembers per key the
  time of its newest entry: a push equal to it is skipped, and a pop not equal to it is dropped
  unexamined because the newest entry is the one the last touch made and so is never later than
  the true time. Forgetting too much only costs a push; the oracle asserts the cache's invariant.
  With it the push and pop counts are identical to the control's at every cell.
- Incidental: `stat_odd_gap` counts two-sided collisions with an odd gap in debug builds; it is
  zero across the whole random suite, so the doubled-weight integrality argument holds
  empirically, not only by design.

### Stage two: layout (`604d791`)

Per-node hot state (`distance`, `wrapped`, `owner`, `source`, `defect`, `degree`) is one 16-byte
`#[repr(C)]` record; a region's rate (`offset`, `growth`) is one 8-byte record; edges are 16-byte
records; each node's incident slots are 8-byte records holding the edge, far endpoint and doubled
weight (the kernel's three parallel neighbour arrays are no longer read in the touch loop); queue
entries are 16-byte records. Sizes and alignments are compile-time asserted. The write-only
`parity` and `arrival` arrays are removed. Newtype indices were not done; the packed records
already make node and region accesses distinct, and the mechanical cost of the rename across the
file was judged not worth it inside this probe.

### Stage three, unmeasured (`22d8e98`)

`touch_node` reads a node's record and its owner's rate once and evaluates each incident edge
against the far endpoint's record only (`edge_time_between`); `edge_time_from` was reading the
node's record and rate on every call, and the profile below put it at 22.9% before the hoist. All
gates pass; the 18-cell A/B has not been run, so this commit's effect is unknown and is the first
thing to measure.

## Gates, at each committed stage

The debug random suite (four distances, 20,000 instances each, with the `I1`/`I2`/boundary
assertion and the no-late-entry oracle after every event): all answered, all certified, zero
declined, zero late entries. The kernel tests in debug and release, including the zero-allocation
`decode_batch` gate. Library clippy `-D warnings` and `rustfmt` clean. PyMatching 2.4.0 `verify`
on `--mode emit --operations 20000` per cell: zero minimum-weight disagreements on all eighteen
cells for `f0aec54` and `604d791`; the prediction differences are the documented tie policy,
identical to probe 28d. Evidence: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28e-{f0aec54,604d791}-pymatching-exactness.txt`.

## Traffic per answered solve, p=0.05, `census` mode over 20,000 shots

Pops and pushes for `f0aec54` and `604d791` equal the control's exactly (`586ec26`: 11.14,
16.20, 29.69 events per answer at d=9, 15, 25). Event-time evaluations are counted at every call
now, including the validation of each claimed pop, which the control's tightness test did
uncounted; the counted figures are 47.1, 68.2 and 114.6 per solve against the control's 37.4,
54.4 and 89.6. Stale pops, now counted, are 4.7, 7.5 and 15.8 per solve; the control dropped
the same entries at its stamp check without counting them.

## Instructions per decode

Interleaved, eight rounds, two-size differencing, paired log-ratio 95% intervals; every interval
excludes 1.0 except the p=0.001 cells at d=3 to 9. Logs: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28e-{f0aec54,604d791}-binaries-ab.log`.

| d  | p     | control `586ec26` | `f0aec54` scheduling | ratio | `604d791` layout | ratio     |
|----|-------|-------------------|----------------------|-------|------------------|-----------|
| 3  | 0.001 | 67.0              | 67.1                 | 1.001 | 67.0             | 0.999     |
| 3  | 0.01  | 98.4              | 99.8                 | 1.014 | 97.5             | 0.990     |
| 3  | 0.05  | 657.5             | 689.1                | 1.048 | 635.4            | 0.966     |
| 5  | 0.001 | 68.2              | 68.2                 | 1.001 | 68.1             | 0.999     |
| 5  | 0.01  | 193.7             | 196.8                | 1.016 | 187.2            | 0.967     |
| 5  | 0.05  | 2,427.4           | 2,513.2              | 1.035 | 2,290.7          | 0.944     |
| 7  | 0.001 | 69.8              | 69.9                 | 1.001 | 69.8             | 0.999     |
| 7  | 0.01  | 270.7             | 277.9                | 1.027 | 264.1            | 0.976     |
| 7  | 0.05  | 4,839.3           | 4,969.8              | 1.027 | 4,517.6          | 0.934     |
| 9  | 0.001 | 72.0              | 72.1                 | 1.002 | 71.9             | 0.999     |
| 9  | 0.01  | 413.1             | 426.0                | 1.031 | 403.0            | 0.976     |
| 9  | 0.05  | 7,771.1           | 7,914.9              | 1.019 | 7,198.4          | **0.926** |
| 15 | 0.001 | 81.5              | 82.0                 | 1.006 | 81.6             | 1.001     |
| 15 | 0.01  | 1,089.9           | 1,134.1              | 1.041 | 1,065.1          | 0.977     |
| 15 | 0.05  | 16,923.0          | 17,195.3             | 1.016 | 15,648.7         | **0.925** |
| 25 | 0.001 | 106.9             | 108.0                | 1.011 | 107.2            | 1.003     |
| 25 | 0.01  | 2,911.8           | 3,072.5              | 1.055 | 2,886.1          | 0.991     |
| 25 | 0.05  | 31,637.2          | 32,084.3             | 1.014 | 29,299.9         | **0.926** |

Reading it: the scheduling redesign alone costs 1.4% to 5.5%
at every cell that touches the sparse core, exactly as the design note predicted (no change in
events, slightly more evaluated per pop), and the layout recovers that and 7.4% more at the three
losing cells. Both ratios are against `586ec26`; the layout's own effect is their quotient,
about 0.91 at p=0.05.

## Profile of `604d791`, d=25 p=0.05

`perf record` over 163,840 decodes, self time by symbol: `solve` 26.5%, `edge_time_from` 22.9%,
`certify` 11.1%, `touch_node` 8.0%, `push_event` 6.0%, `descend` 4.9%, `dissolve` 4.4%,
`on_collision` 2.8%, `touch_region` 2.0%. Inside `edge_time_from` the hottest instruction is the
load of the far owner's rate (14.7%), a dependent load through the owner index; the function was
not inlined into the touch loop and re-read the node's own record and rate on every call, which
is what `22d8e98` removes.

## Mystery ledger

- **The three p=0.05 cells against PyMatching.** Settled today: scheduling has no win in it
  (measured, 28d) and the layout was worth 7.4% net at those cells. Open: d=9 is at derived
  parity and d=15/25 at about 1.26x and 1.37x; the next levers are the hoist (`22d8e98`,
  unmeasured), the certificate's closure reads (11% of the decode; a `u16` mirror of the closure
  would make the d=25 table L1-resident), and `solve` itself at 26.5% with its inlined handlers.
- **`descend` at 4.9% with no blossoms in most shots.** Still open and unexplained; not measured.
- **Odd two-sided gaps are zero on the suite.** Settled as an empirical confirmation of the
  doubling argument; no defect.
- **Newtype indices.** Not done; the design note asked for them. Open as a hygiene item, not a
  performance one.

## Vibe check

Good. The brittle part is gone and the debug oracle localizes the class of defect that cost three
probes; the layout paid what the note said it would, and one cell is at parity. Two cells still
lose and the last commit is unmeasured.

## Next

1. A/B `22d8e98` against `604d791` (and against `586ec26` for the standing), plus the
   PyMatching exactness run; the retained binaries exist.
2. The certificate's closure reads: a `u16` closure mirror in `KernelSpec` for certify, gated the
   same way.
3. Then the predecoder items from probe 28c, unchanged.
