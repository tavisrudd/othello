# Recompute-vs-store audit of the iso-window hot path

**Date**: 2026-06-18
**Lens**: "math is cheaper than memory." The search is memory-latency- + frontend-bound
(random TT probes, ~27% cycles idle on i-fetch, CPI ~1.1, L1d-miss ~1%). For every
load/store/memo on the hot path: is the value cheaper to **recompute** (a few ALU ops, of
which we have surplus) than to **fetch** (a load that may miss to L2/L3/DRAM)? Keep a table
only when its entries are genuinely expensive to recompute *and* reused enough to amortize
the probe.

**Scope**: production default is `iso-window` (`IsoFlat::new_window`, `iso_max_avail = 7`).
Per-node routing in `wins_inc` / `wins_tiny` (`iso_flat.rs`):
- `pc >= 9` → `wins_inc` D4 arm: `child_orient` (8 `and_not`), `lex_min8`, `hash128`, flat-TT probe.
- `pc == 8` → `w8_get`: build 28-bit edge code from 8 attack rows, one bit load into the 32 MiB W8 table.
- `pc <= 7` → `band_entry` → `enter_graph`: `tiny_table_index` (calls `tiny_edge_code`, the #1
  branch-miss site) → `tiny_get` probe of the ~2 MB `tiny_tt`; on miss build `TinyGraph` +
  `solve_local` (pure-L1 DP over `alive:u8`, 128-byte stack memo) + `tiny_put`.

**No code changed.** Each candidate below states the load/store, the recompute alternative,
the latency-vs-ALU trade, a Fermi upside bound, the correctness argument, and the cheapest
A/B to validate or kill it. Gate for every change: `solve 12 iso-flat --distinct` = exactly
**1,060,823**, `solver_lineage_agrees` (n≤9), n=14 re-exp ≈ 1.0×.

---

## Ranked summary

| # | Candidate | Direction | Est. leverage | Cost to test | Verdict |
|---|-----------|-----------|---------------|--------------|---------|
| 1 | `tiny_tt` band-entry table (~2 MB, 98% is the k=7 sub-table) — probe vs always-`solve_local` | **drop the load, recompute** | High if k=7 reuse-per-entry is low (likely): removes a ~2 MB scattered L2/L3 probe + the #1 branch-miss `tiny_edge_code` from the deepest region | 1 `const` toggle, A/B on n=14/n16 CPI | **Test first — headline** |
| 2 | `order_rank` table (n² bytes) in `enter_graph` — load vs derive | borderline | Low–med: replaces n² L1 byte loads with a tiny insertion sort already present | fold into #1's experiment | Bundle with #1 |
| 3 | `att[sq][t]` for `t in 1..8` (orientation table, 56 KB used per node) carried down `wins_inc` | **inverse trap — KEEP** | n/a | n/a | Do not recompute |
| 4 | `w8_get` 32 MiB W8 table (pc==8) vs recompute via `solve_local` on 8 verts | likely KEEP | Low/negative: W8 collapses whole pc==8 subtrees (no re-expansion); recompute reintroduces them | already have `tiny8_direct`/`iso_key8` paths to A/B | Keep; measure only |
| 5 | `tiny_canon` 16 MB canon table (`small_canon_table`) | already bypassed in production | n/a (COUNT-only now) | n/a | Already done — note only |
| 6 | `node_pc = avail.popcount()` recomputed several times per node | micro | ~0 (popcount is 4 ALU ops; already const-gated by MODE) | n/a | Already handled |
| 7 | `COMP_CACHE` / `K8_CANON_CACHE` low-hit caches | DEAD in production | n/a | n/a | Lesson noted, no action |

---

## Candidate 1 (HEADLINE) — the `tiny_tt` band-entry table: probe vs always recompute

### The store/load
`iso_flat.rs:195` declares the table:
```rust
tiny_tt: Box<[AtomicU8]>,   // TINY_TABLE_SLOTS = 2,131,020 slots = ~2.03 MiB, one byte/code
```
`enter_graph` (`iso_flat.rs:929-988`), production (`COUNT = false`) arm:
```rust
let tidx = q.tiny_table_index(child0, pc);   // -> tiny_edge_code, the #1 branch-miss site
...
} else if let Some(w) = self.tiny_get(tidx) {  // load AtomicU8 at a scattered idx
    return w;
}
... // miss: build TinyGraph, solve_local over a 128-byte stack memo, then:
self.tiny_put(tidx, won);
```
`tiny_get`/`tiny_put` (`iso_flat.rs:993-1006`) are a direct `get_unchecked(idx).load/store(Relaxed)`.

**Table shape (computed from `SMALL_CANON_OFF`):** slots per k are
`{k1:1, k2:2, k3:8, k4:64, k5:1024, k6:32768, k7:2097152}`. **The k=7 sub-table is 2,097,152 of
the 2,131,020 slots — 98.4% of the table.** Two consequences:
1. The byte at index `tidx` for a k=7 entry is one element of a 2 MiB region addressed by a
   *labelled* edge code (`tiny_table_index` does **not** canonicalise). Labelled codes for
   k=7 are spread across the full 2²¹ space, so the access pattern into the k=7 region is
   effectively random ⇒ each first-touch of a code misses to L2/L3 (the 2 MiB table does not
   sit in the 32 KiB L1d, and on znver5 the L2 is ~1 MiB so even L2 can't hold the hot k=7
   working set). This is exactly a DRAM-adjacent scattered probe — the scarce resource.
2. Because it is *labelled* (not canonical), the **same graph is stored under up to 7! = 5040
   labellings**. The labelling is `q.order`-determined per board placement, so reuse is far
   lower than the iso-class count would suggest: two transpositions reaching the same 7-vertex
   *graph* by different square sets land on different `tidx`. So the per-slot reuse — the only
   thing that amortizes the probe latency — is structurally low for k=7.

### The recompute alternative
`solve_local` (`iso_flat.rs:1012-1031`) already *is* the recompute, and it is **pure L1**:
a recursive win/loss DP over an `alive: u8` bitmask with a thread-private `[i8; 128]` stack
memo, one `& !g.closed[i]` per move, cut on the first losing child. No board op, no key, no
TT, no atomic, no cross-CCX coherence. For a 7-vertex graph the memo has ≤128 entries and the
DP touches only the reachable `alive` masks (a few dozen), entirely in registers/L1.

The proposal: **on the production path, always run `solve_local` for the whole ≤7 subtree and
never touch `tiny_tt` at all** — skip `tiny_table_index` (and thus the #1 branch-miss
`tiny_edge_code`), skip the `tiny_get` load, skip the `tiny_put` store. `enter_graph` already
builds the `TinyGraph` and runs `solve_local` on a miss; the change is to make that the
*unconditional* path and delete the table probe around it.

### Latency-vs-ALU trade
- **Removed (memory):** one scattered `AtomicU8` load (~L2/L3, ~12–40 cyc when it misses L1)
  per band entry, one `AtomicU8` store on the miss, **and** the `tiny_edge_code` build whose
  inner loop is the measured #1 branch-miss site (each k=7 entry does 21 `edge_bit` + shift
  ops feeding a labelled index — that index then drives the scattered load, so the branch-miss
  and the cache-miss are *serialized* on the same critical path).
- **Added (ALU):** the full `solve_local` DP for the ≤7 subtree on *every* band entry instead
  of only on a `tiny_tt` miss. Cost = (number of distinct `alive` masks reachable in this
  7-vertex graph) × (a few ALU ops each), all L1/register. For a 7-vertex Node-Kayles graph
  this is at most ~2⁷ memo cells but in practice a few dozen (the DP cuts on the first losing
  child). Critically, `solve_local`'s recursion is **branch-predictable and L1-resident** —
  the opposite of the band-entry probe's profile.

The win condition: **(probe latency + branch-miss penalty) saved per band entry > extra
solve_local ALU on the entries that currently hit `tiny_tt`.** Given (a) the k=7 region is
2 MiB of effectively-random scattered access, (b) the labelled (non-canonical) key gives low
per-slot reuse, and (c) `solve_local` is already the fall-through, this is squarely the
"math cheaper than memory" pattern. The risk is the inverse: if `tiny_tt` *hit rate* is high
(a code recurs many times before eviction-free-storage pays off), the probe amortizes and
recompute loses. **That hit rate is the one unknown and the experiment measures it directly.**

### Fermi upside bound
The pc≤7 band is ~20% of cycles (stated), and within it the dominant sub-costs are the
labelled-index build (#1 branch-miss) + the scattered `tiny_tt` probe. If those together are
~half of the band's cycles and `solve_local`-always adds back ~⅓ of that in L1 ALU, the
napkin is **~5–8% wall at n=14**, larger at n=16 where the 2 MiB table competes harder with
the 13–17 GB flat TT for L2/L3 and TLB. Upper bound if the probe is mostly missing to L3:
the band's memory stalls vanish, ~10%+. Lower bound if `tiny_tt` mostly hits L1/L2 with high
reuse: a wash or small negative. **Order-of-magnitude check before building: instrument the
k=7 `tiny_get` hit rate (below) — if hits-per-distinct-code < ~3, recompute almost certainly
wins.**

### Correctness argument
`solve_local` computes the *exact* Node-Kayles win/loss of the ≤7 subgame — it is already the
authority that fills `tiny_tt` (the table is a memo of `solve_local`'s output). Removing the
table cannot change any verdict: every band entry returns precisely what `solve_local` returns
today on a miss. The searched node set is unchanged (same `q.order` relabelling via
`order_rank`, same move order). For `--distinct` (`COUNT = true`) the existing path is
**untouched** — that arm already bypasses `tiny_tt` and keeps the flat-TT key so the HLL still
counts every position (`enter_graph` `COUNT` branch, `iso_flat.rs:936-977`). So `solve 12
iso-flat --distinct` = 1,060,823 is structurally preserved, and `solver_lineage_agrees`
holds because n≤9 already exercises `solve_local` on its misses.

Note: `iso-flat` (non-window) and `iso-window` share `enter_graph`, so the toggle applies to
both; the gate uses `iso-flat` explicitly, which is correct.

### Cheapest experiment
1. **Measure the hit rate first (cheapest, decides the whole thing):** add a `const`
   instrumentation mono (or reuse the oracle counters) that tallies, on the production band
   entry, `tiny_get` hits vs misses, and distinct `tidx` seen, at n=14. If
   *hits / distinct-tidx* is low (≤ ~2–3), the table isn't amortizing — recompute wins. This
   is a read-only tally, no behavior change.
2. **Then the A/B:** add a `const ALWAYS_LOCAL: bool` to `enter_graph` (resolved once at the
   subtree handoff, like the existing `MODE`), `true` = skip `tiny_table_index`/`tiny_get`/
   `tiny_put` and call `solve_local` directly. Interleaved A/B (alternate binaries
   round-by-round per the thermal-throttle rule) on n=14, then a partial-n=16 throughput
   sample. Watch CPI, branch-misses (expect the #1 site to drop), and L2/L3 miss rate. Keep
   only if it pulls its weight; record as an instructive negative otherwise.

This is the single highest-leverage recompute-vs-store candidate in the codebase and the one
the prompt flags. It is also the cleanest experiment (one const toggle, the recompute path
already exists and is validated).

---

## Candidate 2 — `order_rank` table in `enter_graph` (bundle with #1)

### The load
`order_rank: OnceLock<Box<[u8]>>` (`iso_flat.rs:184`, built `iso_flat.rs:342-350`): `n²` bytes,
`order_rank[sq]` = sq's position in `q.order`. Used in `enter_graph` (`iso_flat.rs:944-957`) to
insertion-sort the ≤7 child vertices into `q.order` order via `rank[v]` lookups.

### The trade
This is a genuine table of n² bytes (256 at n=16) that is L1-resident and reused every band
entry — it is **not** a strong recompute candidate on its own. The only reason it appears here:
if Candidate 1 lands and the ≤7 subtree is solved purely in `solve_local`, the relabelling into
`q.order` still has to happen exactly once at band entry to keep the node set byte-identical, so
`order_rank` stays. There is no cheaper recompute (the alternative, rescanning `q.order` for
each vertex, is O(n²) per entry — strictly worse). **Verdict: keep; do not recompute.** Listed
only so the audit is complete and to flag it does *not* move with #1.

---

## Candidate 3 (INVERSE TRAP — KEEP) — the carried `att`/`orient` orientation state

### The carry
`wins_inc` carries `orient: &[Bits; 8]` (256 bytes) down the DFS and `child_orient`
(`incremental.rs:118-129`) recomputes all 8 child orientations each ply via 7 `and_not`s,
keyed by `lex_min8`. The `att[sq][t]` table (`incremental.rs:98-110`, 8×n² `Bits` ≈ 64 KB) holds
`perm_t(attack[sq])` so the per-orientation `and_not` is a single op instead of a permutation
scatter.

### Why keep
This *is* the recompute-not-store design already, and the table it relies on (`att`) replaces
the ~250×-cost permutation scatter (`Queens::canon` does `available.each(|s| img.set(perm[s]))`
per orientation — the "fat" the A3 kernel was built to kill, `incremental.rs:1-9`, measured
~574 cyc → ~62 cyc/canon). Recomputing `att[sq][t]` per node would reintroduce exactly the
scatter the kernel removed. The 64 KB `att` table is L1/L2-resident and reused on *every* move
of *every* node — maximal amortization. **Do not touch.** This is the canonical example the
prompt warns about (the att-orientation table is the keep-it case).

One sub-note that is *not* a trap but also not worth it: the `orient` array carries all 8
images even though only `orient[0]` (the available mask) and the eventual `lex_min8` are read
per node. You cannot drop the other 7 — they are the incremental state `child_orient` updates;
recomputing them from `orient[0]` at each ply is the scatter again. Keep all 8.

---

## Candidate 4 — `w8_get` 32 MiB W8 table (pc==8): likely KEEP, measure

### The load
`w8_get` (`iso_flat.rs:300-320`) builds a 28-bit labelled edge code from 8 attack rows then does
`dense8.get(8, code)` — one bit load (`dense.rs:107-112`) into the 32 MiB W8 bitset.

### The trade
The recompute alternative for pc==8 is to *not* have the table and instead solve the 8-vertex
subgame (e.g. `solve_local` extended to 8 verts, or recurse into the pc≤7 machinery). But the
W8 table's value is **not** primarily latency-saving — it is **node-count**: at pc==8 the table
collapses the *entire* 8-vertex subtree to one lookup, so those subtrees are **never
expanded** (`iso_flat.rs:198-202`, "never re-expanded"). Recomputing reintroduces the whole
pc==8 subtree expansion. That is a node-count regression, not an ALU-vs-load swap, so the
"math cheaper than memory" lens points the other way here: the table buys avoided *work*, not
just avoided latency. 32 MiB is large for L2 but the labelled-code access has structure
(8-vertex codes cluster), and the project already measured W8 as the lever that broke the
"3m41s wall" to 2m44s.

**Verdict: keep.** If anyone wants to challenge it, the `tiny8_direct` / `iso_key8_direct`
paths (`iso_flat.rs:471-496`, `graph.rs:1045-1066`) already exist to A/B a no-W8 pc==8 keying;
expect it to lose on node count. Listed for completeness, not as a recommended change.

---

## Candidate 5 — `tiny_canon` 16 MB canon table: already bypassed in production (note only)

`tiny_canon: &'static [u64]` (`small_canon_table`, `graph.rs:244-257`) is a 2.13 M × 8 B ≈
**17 MB** table mapping each labelled ≤7 edge code to its canonical key. The production
band-entry path **already does not probe it** — `tiny_table_index` keys `tiny_tt` by the *raw
labelled* index precisely to skip this 16 MB scattered probe (documented `iso_flat.rs:186-194`
and `graph.rs:1008-1015`: "skips the 16 MB canon table, whose scattered L3/DRAM probe is ~22%
of the n=16 search"). It survives only on the `COUNT`/`iso_node_key` path (and `comp_nimber`).
So the recompute-vs-store win here **was already taken** — this is the precedent that makes
Candidate 1 plausible (same logic, one level further: having dropped the 16 MB canon probe,
drop the 2 MB labelled-win/loss probe too and recompute via `solve_local`). No action; note it
as the prior art that argues *for* Candidate 1.

---

## Candidate 6 — repeated `avail.popcount()` per node (already handled)

`wins_inc` reads `node_pc = avail.popcount()` and re-derives child `pc = child0.popcount()`.
popcount is 4 `POPCNT`-fed ALU ops over `[u64;4]` — cheaper than any load, so deriving it is
already the right call (you would never *store* a per-node popcount). The code already gates
`node_pc` behind `MODE == M_NORMAL ? 0 : popcount` so production doesn't even compute the
node's own popcount when unused. Nothing to do — flagged only to confirm it's not a hidden
store.

---

## Candidate 7 — `COMP_CACHE` / `K8_CANON_CACHE`: dead in production (lesson only)

`COMP_CACHE` (64 MB/thread, `graph.rs:131-161`) and `K8_CANON_CACHE` (`graph.rs:169-200`) are
low-hit-rate caches over cheap-to-recompute canon values — the textbook "drop the cache,
recompute" target. But both are **already dead in the iso-window production path**: `COMP_CACHE`
only lives when `QUEENS_KEY_MAX > 7` (the WL key path), and `K8_CANON_CACHE` only via
`iso_key8_direct` under the opt-in `tiny8_direct`. So there is no production load to remove.
The *general lesson* — a low-hit cache whose entries are cheap math should be dropped — is
exactly what Candidate 1 applies to the one such structure that *is* live (`tiny_tt`). No
action on these two beyond noting the pattern.

---

## What I deliberately did NOT propose recomputing

- **`att[sq][t]`** (Candidate 3) — replaces the ~250× permutation scatter; the keep-it case.
- **`Queens::attack[sq]`** (`geom.rs:13`) — per-square attack masks, built once, read on every
  move via `place`/`child_orient`/`tiny_edge_code`. Recomputing a row is a double loop over n²
  (`geom.rs:46-64`) — vastly more than the L1/L2 load. Keep.
- **`q.order` / `q.sym`** — the forcing move order and symmetry permutations; pure functions of
  geometry but expensive to derive (sort by degree; 8 permutations over n²) and read on every
  node. Built once, threaded. Keep.
- **W8 table** (Candidate 4) — buys node-count (avoided subtree expansion), not just latency.

These are the inverse traps: cheap to *load*, expensive to *recompute*, and heavily reused.
The audit's one strong actionable is **Candidate 1**, with **Candidate 5** as its precedent
and **Candidate 7** as its general-lesson sibling.
