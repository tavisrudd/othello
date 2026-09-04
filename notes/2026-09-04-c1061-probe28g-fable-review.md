# C1061 probe 28g: review of the cached owner rate in the sparse core

Date: 2026-09-04. Reviewer: Fable sub-agent, read-only. Scope: `ergodis-private`
`src/tiger_blossom_sparse.rs`, stage A (commit `ced13b7`, `depth = distance - wrapped`,
`degree` out of the record) and stage B (uncommitted, `term`/`growth` cached on the node
record). Line numbers are the working-tree file after stage B. No build or test was run.

Model used throughout: `radius(r, t) = offset_r + growth_r * t`; a covered node has
`local(v, t) = radius(owner, t) - depth = growth_owner * t - term`, with
`term = depth - offset_owner`. Every event time is a root of a sum of such linear forms.

## 1. Is the writer list complete?

**Yes.** A mechanical listing of every write to `node.owner`, `node.depth`, `rate[].offset`,
`rate[].growth`, `node.term`, `node.growth` gives exactly the sites below, and each is
followed by a refresh that reaches every node whose cached value it changed.

| Write | Lines | Refresh | Reaches all affected nodes because |
|---|---|---|---|
| `solve` defect init: owner, depth, rate | 1110-1119 | `refresh_node` 1120 | the fresh singleton covers only its home node |
| `reset`: owner=NONE, depth, term, growth | 1498-1504 | inline 1501-1502 | every node is NONE afterwards; the rate loop 1505-1520 then only touches regions no node references |
| `on_phantom` re-cover: owner, depth | 1632-1633 | `refresh_node` 1635 | single node |
| `absorb`: owner, depth | 1669-1670 | `refresh_node` 1672 | single node; `from.owner == region` and `rate[region]` is live |
| `on_release`: owner=NONE | 1704 | `refresh_node` 1705 | single node |
| `fold_subtree`: depth, owner=blossom | 1992-1993 | `refresh_node` 1994 | per node, against `rate[blossom]`, which 1898-1900 set before the fold loop 1904-1911 |
| `expand` release of own nodes: owner=NONE | 2155 | `refresh_node` 2156 | single node |
| `unfold_subtree`: depth, owner=member | 2323-2324 | `refresh_node` 2325 | per node, against `rate[member]`, still the frozen `(0, radius)` at that point |
| `set_growth`: rate | 613-614 | `refresh_subtree` 615 | see question 2 |
| `contract`: `rate[blossom]` direct | 1899-1900 | none needed | no node has `owner == blossom` yet (`blossom = allocated`, fresh this solve, monotone); the fold refreshes every node it hands over |

Ordering checks asked for:

- `contract` (1898-1911): `rate[blossom]` is set before the member loop; for each member,
  `set_growth(member, 0)` refreshes the member's subtree against the now-frozen
  `rate[member]` (correct: the member is still outermost, so its subtree's nodes have
  `owner == member`), then `radius(member)` is the frozen offset, then `fold_subtree`
  overwrites depth, owner and cache against `rate[blossom]`. `parent_blossom[member]` is
  written between the two and is not read by either walk. Correct, but the first refresh is
  dead work (question 7).
- `expand` (2152-2302): own nodes released and refreshed to `(0,0)` before their
  `touch_node`; `unfold_subtree` refreshes every member node against the member's frozen
  rate; path members then get `set_growth(member, ±1)` at 2275, whose `refresh_subtree`
  re-refreshes them against the new rate. The paired-off members (2229-2253) get no
  `set_growth`, and need none: their `rate[member]` is not written after the unfold, so
  the cache written by `unfold_subtree` is against the rate they keep. `set_growth(blossom, 0)`
  at 2289 runs after `child_count[blossom] = 0` (2280) with `region_length[blossom] == 0`
  (2158), so its walk visits nothing, and nothing has `owner == blossom` by then. The final
  `touch_region` loop is scheduling only and reads a consistent cache.
- `dissolve` (2428-2455): `set_growth(index, 0)` refreshes each tree member's subtree; tree
  members are outermost regions. `set_growth`'s early return when growth is unchanged is
  sound because the offset is then unchanged too.
- `reset` (1486-1533): node loop zeroes `term`/`growth` with `owner = NONE`, the rate loop
  follows; order is immaterial because no node is covered afterwards.
- `augment`, `flip`, `set_mate`, `reroute_boundary`, `augment_to_boundary`: write no
  owner, depth, or rate.
- `walk_stack` reuse: `refresh_subtree` shares `walk_stack` with `fold_subtree`,
  `unfold_subtree`, `touch_region`, and `contract`'s chain walk (1831-1841). Every use is
  sequential and the chain is copied into `cycle_region` before the first `set_growth`,
  so there is no clobber. Observation, no defect.

No defect found.

## 2. Does `refresh_subtree(region)` reach exactly the right nodes?

**Yes, and it is also self-correcting.** `owner` is always the outermost region: `absorb`
is only reached from `on_edge` with a growing region (contracted members have growth 0),
`fold_subtree` sets the whole subtree to the blossom, `unfold_subtree` sets it to the
member, and `on_phantom` re-cover uses `outer[singleton]`. A node with `owner == r`
therefore lies in the `region_nodes` list of `r` or of a descendant of `r` via
`child_region`, which is exactly the walk at 644-663 (same shape as `touch_region`).
The `on_phantom` re-cover case (node stored in the singleton's list, owned by `outer`) is
reached through the child chain. Nodes past `region_length` are excluded, as they must be.

Reachable nodes whose owner is not `r`: this happens only if `refresh_subtree` were called
on a non-outermost region, which no current caller does. It would be harmless anyway:
`refresh_node` (629-639) recomputes from `state.owner`, not from the region walked, so the
walk can only waste work, never write a wrong value. Observation.

## 3. Are the rewritten formulas equivalent to the originals?

**Yes**, each checked against the original `distance`/`wrapped` form via
`depth = distance - wrapped`, `term = depth - offset`:

- `edge_time_between` 799-821: one-sided `near.term + weight` equals
  `near.depth + weight - offset_near`; two-sided `weight + near.term + far.term` equals the
  old `weight + depth_n + depth_f - offset_n - offset_f`; `rate = near.growth + far.growth`
  equals the old table reads. Guards (`far.owner == NONE`, same owner, `rate <= 0`) and the
  `divide_up` rounding are unchanged.
- `boundary_time` 849-862: `state.term + 2*boundary` equals `depth + 2b - offset`; the
  growth guard now reads the cache.
- `release_time` 880-888: `-node.term = offset - depth` equals the old
  `offset + wrapped - distance`. Requires the tail node's owner to be `region`, which holds
  for a shrinking (hence outermost) region. The growth/length guard still reads the table,
  which is fine (it must read `region_length` anyway).
- `phantom_time` 916-940: tightness `phantom_wrapped + offset_o + g_o t + g_h t - home.term = 0`
  gives `needed = home.term - phantom_wrapped - offset_o`, matching the old
  `depth_h - pw - offset_o - offset_h`. Sign of `phantom_wrapped` unchanged (it is the
  negated depth of a distance-0 node: `on_phantom` sets `depth = -pw`, fold does
  `pw += radius` against `depth -= radius`, unfold the reverse).
- `local_radius` 602-606: `radius_at(owner) - depth` equals the old
  `wrapped + radius - distance`. Reads the table, not the cache, so the boundary oracle is
  independent of the cache. Correct and desirable.
- `absorb` 1668-1672: `depth = from.depth + 2w` equals the old
  `distance = from.distance + 2w, wrapped = from.wrapped`.
- `on_phantom` re-cover 1632-1635: `depth = -pw` equals the old `wrapped = pw, distance = 0`.
- `on_release` break 1701: `depth < radius` equals `distance - wrapped < radius`; local
  radius `radius - depth > 0` means the node stays, so the break is on the correct side.
- `fold_subtree` 1992 `depth -= radius` equals `wrapped += radius`; `unfold_subtree` 2323
  `depth += radius` equals `wrapped -= radius`.
- `phantom_local` 902-904 and `check_boundary_feasibility` unchanged.

No defect found.

## 4. `phantom_time`: is `home.owner != NONE` guaranteed where `home.growth`/`home.term` are read?

**Yes.** The `home.owner == NONE` branch returns at 925-930; lines 931-939 are reached only
with a covered home node, and `home.owner as usize == outer` returns before the arithmetic.
`home.term` is the right quantity: it carries the home node's owner offset, which is a
different region from `outer` on that path, while the phantom side's radius depends on
`rate[outer]` and `phantom_wrapped[singleton]`, neither of which any node record caches.
Both table reads remain necessary. Observation: `rate[outer]` is still a load dependent on
`outer[singleton]`; the phantom path is cold, so this is fine.

## 5. Is `term`/`growth` ever read for a node with `owner == NONE`?

**No.** Call sites of `edge_time_between`:

- `edge_time_from` 789-793: called from `on_edge` 1583 and the debug `edge_time` 845, both
  through `edge_sides` 826-837, which returns the covered endpoint first, so `near.owner != NONE`.
- `touch_node` 990: inside `if state.owner != NONE`.
- `touch_node` 1005: after `if near.owner == NONE { continue }` at 1002.

`far.term`/`far.growth` are read only after the `far.owner == NONE` early return at 802.
`boundary_time` returns at 851 before reading `growth`. `release_time` reads the tail node of
a shrinking region, which it owns. `phantom_time` is covered by question 4.
`check_node_cache` skips NONE nodes. Risk (low): the `(0, 0)` convention for NONE nodes is
not asserted anywhere and nothing depends on it; a stray read with `growth == 0` would return
`None` on the one-sided path but could compute a bogus two-sided time if the far side grows.
All present call sites guard, so this is a maintenance note only.

## 6. Layout

**Correct.** `#[repr(C)]`, offsets: `depth` 0, `term` 4, `owner` 8, `source` 10, `defect` 12,
`growth` 14, `_pad` 15; size 16, align 4; the assertion at 150 is unchanged and still holds;
padding is the explicit `_pad: [u8; 1]` (148). Largest alignment first holds.
Observation on "hottest first": on the event-time path the record's hot fields are `term`,
`owner`, `growth`; `depth` is read only by `on_release`, `absorb`, and the fold/unfold walks.
Field order inside a 16-byte record does not change the number of lines touched, and the
array is only 4-aligned so a record can straddle a line regardless of field order; if the
convention is meant literally, `term` would precede `depth`. No action needed.

## 7. Redundant refreshes

Correctness is unaffected by all of these; they are repeat or newly added walks.

1. **`contract` 1904-1911**: every node under each cycle member is refreshed twice —
   `set_growth(member, 0)` walks the member's subtree (615), then `fold_subtree`
   rewrites owner and depth and refreshes again (1994). The first walk's result is entirely
   overwritten. Fix: set `rate[member]` directly in `contract` (`growth = 0`,
   `offset = radius(member)`) without the refresh, since the fold refreshes; cycle members
   always have nonzero growth so the early return never saves this.
2. **`expand` 2166-2171 and 2270-2277**: `unfold_subtree` refreshes every member node;
   `set_growth(member, ±1)` at 2275 walks the `steps + 1` path members' subtrees again. Paired
   members are refreshed once. Fix: compute each member's final growth before unfolding, write
   `rate[member]` directly to the final `(growth, radius - growth*clock)` (radius is the
   frozen offset), then let `unfold_subtree` refresh once against the final rate. `touch_region`
   still walks a third time for scheduling.
3. **Rate decreases now walk**: `on_collision` 1774 `set_growth(other, -1)` and `dissolve`
   2437 for a growing member that freezes previously needed no per-node work (the module
   doc's "a rate decrease only makes existing entries early"). With the cache, every rate
   change walks the subtree. This is not a duplicate refresh but new work the old design
   avoided; it is the main hidden cost of stage B and should be visible in
   `stat`-level counters if one is added for refresh walks.
4. **`dissolve` was-shrinking members**: `refresh_subtree` then `touch_region` are two walks
   of the same subtree; a fused walk (refresh, then touch, per node) would halve the
   traversal. Same shape in `on_collision` for `partner` (1779 then 1789) and in `expand`
   for path members (2275 then 2298).
5. **`absorb` 1672**: `refresh_node(target)` loads `rate[region]`; since
   `from.owner == region`, `term = from.term + 2w` and `growth = from.growth` are available
   from the already-loaded `from` record with no table read.
6. **`fold_subtree` 1994 / `unfold_subtree` 2325**: `refresh_node` re-reads the node record
   just written and loads the loop-invariant `rate[blossom]`/`rate[member]` per node. The
   two `Box<[_]>` fields give LLVM no noalias guarantee, so the hoist is unlikely to happen
   automatically; computing `term = depth_new - offset` inline with a hoisted offset and
   growth is one store instead of a reload.
7. **`on_release` 1705, `expand` 2156**: `refresh_node` on a node just set to NONE takes the
   branch and re-reads the record to store `(0, 0)`; two direct stores are cheaper. Trivial.
8. **`solve` 1120**: with rate `(1, 0)` and depth 0 the result is `term = 0, growth = 1`;
   direct stores. Trivial.

## 8. The debug oracle `check_node_cache`

**It catches a stale entry**: after every handler (1169) and once after initialization
(1131) it compares `term` and `growth` of every covered node with the rate table, so any
covered node left behind by any writer fails immediately, attributed to the handler kind.
Ordering matters for attribution, not detection: `check_no_late_entry` recomputes true times
through `edge_time_from`, `boundary_time`, `release_time`, `phantom_time`, all of which now
read the cache, so with a stale cache it would compare stale against stale and could pass, or
fail with a message blaming scheduling; `check_boundary_feasibility` reads the table via
`local_radius` and would see only the downstream consequence. Running the cache check first
makes the failure name the real cause. Two gaps, both observations: it cannot see a value
that was stale during a handler and repaired before the handler returned (only a resulting
late push would surface, via `push_event`'s late-entry assert or the no-late-entry oracle),
and it does not check the `(0, 0)` convention on NONE nodes, which nothing reads.

## Verdict

No defect in stage A or stage B: the writer list is complete, every writer refreshes the
nodes it affects, the walks reach exactly the owned nodes, and every rewritten formula is
equivalent. The findings are performance-only: double refreshes in `contract` and `expand`
(items 1-2), and rate decreases that now walk subtrees where the original design did no
per-node work (item 3).
