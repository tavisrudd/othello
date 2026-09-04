# C1061 probe 28d: the sparse core's scheduling cost at the three losing p=0.05 cells

**Lane**: `complete-ports` · **Date**: 2026-09-04 · **Code**: ergodis-private `586ec26` (code),
`f6761f4` (evidence); retained binary `ergodis-tools-586ec26`, SHA-256
`2d80ec7a0bad3d330246ca6de1fc3565aac59db88605c3a90a1fa346c3b873c8`; control
`ergodis-tools-f8809e4` (probe 28c's last code commit) · **Continues**:
`2026-09-04-c1061-probe28c-blossom-expansion-and-tiger-behind-the-predecoder.md`.

## Headline

**Two scheduling fixes take about 5% off every high-error cell and leave the rest untouched, and
the traffic counters show why there is no larger scheduling win: most event-time evaluations are
the initial scheduling of the defects themselves, not re-arming.** The three losing cells move to
0.952x (d=9), 0.949x (d=15) and 0.949x (d=25) of the probe 28c binary; exactness holds against
PyMatching on all 360,000 frozen shots. Scaled onto probe 28c's derived standing, the losing cells
sit at about 1.08x, 1.36x and 1.48x of PyMatching, still losing.

The profile after the change is flat: no source line above 5%, the largest being the certificate's
pair loop reading the closure table. Getting the remaining third off is a redesign question, not a
hot-spot question, and the second half of this report is the design note Tavis asked for while the
probe ran: what makes the current sparse core brittle, and a simpler, safer shape for it.

## What changed

1. **Single-edge re-arm.** `rearm_incident(node)` re-armed each neighbour in a growing region by
   rescheduling that neighbour in full: every edge, its boundary entry and its phantom, when only the
   one edge shared with `node` had changed (the neighbour's other edges depend on the neighbour's
   own owner and radii, which did not move). It now evaluates that one edge from the neighbour's
   covered and growing side and pushes only when the time differs from the stamp. Because entries
   are keyed by edge, both sides agree on the time and the stamp check is unchanged.
2. **Shift instead of division.** Growth rates are `-1`, `0` or `1`, so every divisor in the
   event-time formulas is one growing side or two. `divide_up` now special-cases the two values
   (`ceil(n / 2) == (n + 1) >> 1` with an arithmetic shift, negatives included) with a debug
   assertion on the divisor; the general `idiv` was about a fifth of `edge_event_time`.
3. **Call-site traffic counters.** Two cold counters record how many nodes a whole-region
   reschedule (rate rise) and a whole-tree dissolve (rate stop) touch; `census` mode prints them.

Gates: the debug random suite with the `I1`/`I2`/boundary assertion after every event (four
distances, 20,000 instances each, all answered and certified), the release kernel tests including
the zero-allocation gate, library clippy `-D warnings`, the 18-cell A/B, and PyMatching exactness.

## Traffic per answered solve, p=0.05, `census` mode over 20,000 shots

Before is `f8809e4`, after is `586ec26`. Events are pops, including stale ones.

| d  | events | schedule_node before | after | edge-time evals before | after | pushes | subtree nodes | rearm nodes |
|----|--------|----------------------|-------|------------------------|-------|--------|---------------|-------------|
| 9  | 11.1   | 12.8                 | 10.4  | 43.6                   | 37.4  | 24.5   | 2.4           | 1.2         |
| 15 | 16.2   | 18.2                 | 14.7  | 63.6                   | 54.4  | 34.7   | 3.2           | 1.4         |
| 25 | 29.7   | 29.9                 | 23.9  | 105.4                  | 89.6  | 55.5   | 5.3           | 2.2         |

Reading the d=25 row: about fifteen defects per shot means fifteen `schedule_node` calls at solve
start, which is two thirds of the after-count, and with about four edges per detector node those
initial calls are two thirds of the edge-time evaluations. Whole-region reschedules touch five nodes
per solve and dissolves two; absorptions account for the remaining four or so. The single-edge
re-arm removed a fifth of the `schedule_node` calls and 15% of the evaluations, which is all the
re-arm waste there was. Pushes exceed pops by nearly two to one: the initial scheduling arms an
entry per edge and most solves finish before those fire.

## Instructions per decode, `586ec26` against `f8809e4`

Interleaved, eight rounds, two-size differencing, paired log-ratio 95% intervals. Log:
ergodis-private `benchmarks/tiger-blossom/2026-09-04-probe28d-586ec26-binaries-ab.log`.

| d  | p     | control  | candidate | ratio |
|----|-------|----------|-----------|-------|
| 3  | 0.001 | 67.0     | 67.0      | 1.000 |
| 3  | 0.01  | 98.7     | 98.4      | 0.997 |
| 3  | 0.05  | 665.0    | 657.5     | 0.989 |
| 5  | 0.001 | 68.2     | 68.2      | 1.000 |
| 5  | 0.01  | 197.0    | 193.7     | 0.983 |
| 5  | 0.05  | 2,520.2  | 2,427.4   | 0.963 |
| 7  | 0.001 | 69.8     | 69.8      | 1.000 |
| 7  | 0.01  | 274.2    | 270.7     | 0.987 |
| 7  | 0.05  | 5,060.8  | 4,839.3   | 0.956 |
| 9  | 0.001 | 72.0     | 72.0      | 1.000 |
| 9  | 0.01  | 418.8    | 413.1     | 0.986 |
| 9  | 0.05  | 8,159.4  | 7,771.0   | 0.952 |
| 15 | 0.001 | 81.6     | 81.5      | 0.999 |
| 15 | 0.01  | 1,110.2  | 1,089.9   | 0.982 |
| 15 | 0.05  | 17,835.5 | 16,923.0  | 0.949 |
| 25 | 0.001 | 107.1    | 106.9     | 0.998 |
| 25 | 0.01  | 2,969.8  | 2,911.8   | 0.980 |
| 25 | 0.05  | 33,330.2 | 31,637.2  | 0.949 |

The p=0.001 cells are closed forms and do not touch the sparse core; their ratios of 1.000 are the
control that the harness is measuring what it claims.

**Exactness**: `--mode emit --operations 20000` per cell, PyMatching 2.4.0 `verify`: zero
minimum-weight disagreements on all eighteen cells; prediction differences (273 at d=3 p=0.05 down
to 0) are the documented tie policy, identical to probe 28c. Evidence: ergodis-private
`benchmarks/tiger-blossom/2026-09-04-probe28d-586ec26-pymatching-exactness.txt`.

## Profile after, d=25 p=0.05

`perf record` over 163,840 decodes, self time by symbol, then by source line on a line-tables build.

| symbol            | self  |
|-------------------|-------|
| `solve` (inlined handlers, reset, pop) | 27.3% |
| `edge_event_time` | 18.6% |
| `schedule_node`   | 12.3% |
| `certify`         | 11.9% |
| `descend`         | 5.6%  |
| `dissolve`        | 3.8%  |
| `on_collision`    | 3.3%  |
| `rearm_incident`  | 3.1%  |
| reset `memset`    | 2.6%  |
| `push_event`      | 2.1%  |

By source line the hottest is the certificate's pair loop reading `closure_distance` (5.1%, one
cache line per pair on a nodes-squared table), then lines inside `edge_event_time` at 1% to 2.4%
each. `edge_event_time` still costs about 65 instructions per evaluation for a formula of ten loads
and one shift: each load is a separately bounds-checked index into one of ten parallel arrays.
That, not the arithmetic, is the per-evaluation cost, and it is a layout question (below).

## Design note: why this core is brittle, and a simpler and safer shape

Tavis's mid-probe instruction: note ways to design a simpler, faster and safer algorithm; the
current one seems brittle and easy to silently break. The evidence supports that. Probes 28, 28b
and 28c each fixed a defect that lost optimality silently (a dropped collision, a release one tick
late, a dissolve that re-armed only its own node list, a one-sided pop), and each was found only by
the LP certificate or the PyMatching oracle, never by the code's own structure.

**What is brittle.**

1. *Stamps as a second copy of the queue.* The stamp arrays (edge, boundary, phantom, release,
   expand) must mirror what is queued. Their contract is "a stamp means an entry for that time is
   queued; only the consuming pop clears it; a rate change re-arms from the changed side". Every
   handler has to know which side it is, whether it is a rate rise or fall, and whether the stamp it
   sees is shared. The 28c one-sided pop and the `fold_subtree` stamp clearing were both this
   contract being applied slightly wrong.
2. *Selective re-arming.* Each handler decides which entries need recomputing (`schedule_node`,
   `rearm_incident`, `schedule_region`, `schedule_subtree`, `rearm_subtree`, `arm_release`,
   `arm_expand`). A missed case is silent: the search just runs one tick past tight. The 28c
   `dissolve` defect was exactly a missed case.
3. *Dozens of parallel arrays sharing index spaces.* Nodes, regions, singletons and blossoms each
   have many `Box<[T]>` fields, with singletons being regions below `count`, `NONE` and `BOUNDARY` as
   `u16` sentinels, and blossom nesting expressed as a wrapped sum folded into every node under it.
   Correct code has to keep all of that consistent by hand, and the compiler checks none of it.
4. *A special mechanism for negative singleton duals* (phantoms, their own event kind, their own
   stamp and wrapped sum), needed because a singleton that shrinks past its home has no node left to
   collide through.

**What already makes it safe in the only way that matters.** The LP certificate proves every answer
optimal independently of the matcher, so none of these defects ever produced a wrong correction:
they produced a decline, and since 28c a decline goes to the bounded path and is flagged. The
ratchet (every random instance answered and certified) turns a silent coverage loss into a test
failure. Any redesign must keep both.

**The simpler shape: validate on pop, re-push on touch, one debug oracle.**

- *No stamps.* The queue holds `(time, event)` entries with no dedupe. On pop the handler recomputes
  the event's true time from current state with the same pure function that scheduled it; if the
  true time is later, push again at that time; if it is `None`, drop; if equal, act. Stale entries
  are then harmless by construction, and the stamp arrays and their contract disappear. Pushes
  cost 2% today; duplicates would raise that, not the asymptotics, and the pool already tolerates it.
- *One rule for re-arming.* An entry that is earlier than the true time is harmless (it re-validates
  and re-pushes); only an entry later than the true time, or a missing entry, is a bug. Rates only
  ever move by one unit, so a rate decrease makes existing entries early (safe) and a rate increase
  makes them late (must re-push). Handlers therefore do one thing after mutating state: call
  `touch(node)` or `touch(region)`, which pushes a fresh candidate for every event whose time
  function reads that state. No handler decides which entries to skip.
- *One debug oracle that covers the whole contract.* After every handler, in debug builds, for every
  edge, boundary, phantom, release and expand event whose true time is `Some(t)`, assert that some
  queued entry has time at most `t` ("no late entry"). This is a complete check of the scheduling
  invariant, which `I1`/`I2` are not: they check the duals after the fact, and would have caught
  none of the four defects at the event that caused them.
- *Struct-of-structs, not arrays-of-everything.* Pack the per-node state (owner, distance, wrapped,
  parity, source, arrival) into one struct and the per-region state (growth, offset, mate, parent,
  root, tree link) into another, indexed by newtypes for node, region and edge so that a node index
  cannot be used as a region index. One bounds check and one cache line per access instead of ten;
  this is also where the 65 instructions per `edge_event_time` go.
- *Keep the certificate and the ratchet exactly as they are.* They are the safety net that made the
  four fixes findable, and they cost 12%.

**What it would cost and win.** The event loop, the tree operations (augment, contract, expand,
dissolve) and the dual model are unchanged in substance; the change is to what surrounds them.
Expected: fewer lines, one invariant instead of a case analysis per handler, a debug oracle that
localizes a scheduling bug to the handler that caused it, and a per-evaluation cost cut by the
layout change. Not expected: a change to the number of events or evaluations, which the traffic
table shows is dominated by the initial scheduling and is inherent to region growth. Beating
PyMatching's 21,500 at d=25 p=0.05 would need the layout win plus the certificate's closure reads
made cache-friendly (a per-shot gather of the closure rows for the defects present, or a smaller
closure type), and neither is certain. This is a proposal for Tavis, not a scheduled change.

## Mystery ledger

- **The three p=0.05 cells still lose to PyMatching.** Settled today: re-arm waste is gone and was
  worth 5%; the remaining evaluations are the initial scheduling, which is inherent. Open: the per-
  evaluation instruction cost (layout) and the certificate's closure reads; owner, the redesign
  above if Tavis takes it.
- **Pushes are twice pops.** Settled: initial scheduling arms one entry per edge of every defect and
  most solves end before they fire. Not a defect; a validate-on-pop design would push slightly more.
- **`descend` at 5.6% with no blossoms in most shots.** Open and unexplained: with `child_count`
  zero it should return at once. Likely perf attributing the inlined `resolve_pairing` loop to it;
  not measured.

## Vibe check

Small clean win, and the more useful result is negative: scheduling was the named target and it is
now measured to have had 5% in it. The design note is the real deliverable of the hour.

## Next

1. Tavis decides on the validate-on-pop redesign (design note above); if taken, it is a rewrite of
   the scheduling layer behind the same certificate and ratchet, gated by the same 18-cell A/B.
2. Otherwise the remaining kernel levers are the layout change alone and the certificate's closure
   reads, each a separate measured probe.
3. Predecoder items from probe 28c stand: radius-3 or observation-conditioned margin under the
   kernel oracle; re-derive the surface d=9 rows.
