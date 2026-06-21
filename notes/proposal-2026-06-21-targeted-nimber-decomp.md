# Proposal: targeted nimber decomposition inside getK (tail-root only, dense-Grundy-≤k)

**Date**: 2026-06-21
**Status**: Design only — NO code written. Decomposability measurement (§1) is the gate; build nothing until it passes.
**Author session**: design pass over `dense.rs` getK + `iso_flat.rs` descent + the parked `queens-component-nimber` (abf38ee) + the grouped-frontier-DDD / node-kayles-lit handoffs.

## TL;DR

The hottest compute bucket is the `getK` dense evaluators (`DenseW8::get9..get16`, ~35% of cycles),
which resolve a pc==k node by the boolean recurrence `W_K(G) = ∃v · ¬W_{K-1}(G∖N[v])`, recursing one
ply per layer. Sprague-Grundy decomposition (`g(G) = ⊕ g(Cᵢ)`, `G` is a LOSS iff the nim-sum is 0)
could collapse a *decomposable* pc≤16 graph into a few small-component table lookups + an XOR instead
of the deep boolean recursion — **and it is move-order-preserving** (it changes only the value of a
leaf evaluator, never which children expand).

The prior nimber attempt (abf38ee) was **−74% nodes but 6.6× wall** because it used a **cutoff-free
nimber recursion** (you must compute the full mex; you cannot α-β-cut a nimber). This design removes the
recursion for components ≤k with a **dense Grundy table** (a W8-shaped table storing the small-int
nimber, not a bit), builds it on the **idle cores during the parallel root phase**, and applies the
decomposition **only inside the ~2 deep serial roots' getK tail** (where single-threaded per-node
savings pay and the overhead doesn't tax the parallel phase).

**The verdict is conditional and the gate is loud:** the project has already banked two findings that
attack this lever's *premise* — (a) the boolean `iso_strip` pair-strip was a measured WASH because
"getK peels isolated vertices one ply at a time, so a level seldom has ≥2 isolated verts at once," and
(b) `module_profile` found the tail queen subgraphs "too sparse/irregular to carry modules" (twin pairs
~3.8% at pc 13 → ~0% by pc 18). **Both point the same way: the pc 13–16 tail graphs may be
overwhelmingly CONNECTED, in which case decomposition almost never fires and the lever is dead.** So
the deliverable that matters most is the §1 measurement, and it must be run *first*, on the **actual
getK-graph distribution inside the giant root**, not on the whole-position working set (which the
existing `comps_dense_nimber_coverage` already taps and which is a different, looser population).

---

## 0. Where we stand (the regime this lever lands in)

- n=16 is SOLVED (second player). Current production e2e is **~27–28s** (the `--16` correction at the
  top of `2026-06-19-explicit-stack-frontier.md`; the old "30s/33.9s" were search-only or slow-tap
  numbers). The 30s process-wall goal is **already met**; this lever is a **sub-25s stretch**, competing
  with the parked sidecar/DRAM-cut work — it must clear a high bar to be worth a multi-session build.
- The wall is **~94% one giant root** running single-threaded as a tail after the other ~35 roots
  finish on the 24-core box (`print_root_timing`: "SOLO for last X s ... longest = Y% of wall"). The
  hot buckets in that tail: `wins_inc` 27% (TT-probe DRAM stall), **getK evaluators (get9..16) ~35%**,
  wK_get builders ~17%, sort ~8%.
- The getK leaves dominate getK: get9/get10 are the bottom of the nested sweep, NOT the high layers
  (`2026-06-19` --14 note). The sparse pc 14–16 tail "is full of isolated vertices," and the nested
  recursion peels them one ply at a time — this is precisely the work decomposition would collapse, IF
  the graphs decompose.
- **What's already proven negative / weak (read these before believing this lever):**
  - **`iso_strip` (boolean isolated-vertex pair-strip, `dense.rs` `const ISO_STRIP=false`)**: WASH
    (−0.3% wall / −1.0% total cyc, n=16 A/B). Two isolated verts rarely coexist at a getK level; the
    common *1-isolated* case needs the nimber (`g(core ⊔ {v}) = g(core) ⊕ 1`), which boolean can't do.
    **This is the strongest in-repo signal that getK graphs are not richly decomposable.**
  - **Component-nimber recursion (abf38ee)**: −74% nodes / **6.6× wall** at n=14, even cap-7 net-negative.
  - **`module_profile` (probe #1, node-kayles handoff)**: size-≥3 modules essentially absent in pc 13–20;
    twin pairs fade to ~0% by pc 18. Different reduction (modular, not component split) but the same
    "the tail is too sparse to carry structure" message.
- **What's NEW and not yet refuted:** the dense **Grundy table** removes the recursion the 6.6× came
  from, and **tail-only gating** removes the parallel-phase tax. Neither was present in abf38ee or the
  pair-strip. The lever therefore isn't "closed" — but its *coverage premise* (decomposability) is in
  doubt, so we measure that premise before building anything.

### Why a position's nimber is the XOR of its components (soundness)

Node Kayles on the queen graph is an impartial normal-play game. A move (placing a queen on square `v`)
deletes `N[v]` (v and every square it attacks) **within `v`'s connected component only** — it cannot
touch another component (no attacking edge crosses). So the components are independent games played in
disjunction, and Sprague-Grundy gives `g(G) = g(C₁) ⊕ … ⊕ g(Cₘ)`, with `G` a P-position (LOSS for the
mover) iff the nim-sum is 0. `get*` only needs the **boolean** verdict, so it needs only "nim-sum == 0?".
This matches `try_oracle_nimber` in `iso_flat.rs` (already in the tree, currently capped ≤7 via recursion).

---

## 1. ★ DECOMPOSABILITY MEASUREMENT PLAN (the gate — run this FIRST, build nothing until it passes)

### What we must learn

For the pc 13–16 graphs actually passed to `w13_get/w14_get/w15_get/w16_get` **inside the giant root's
tail**, per pc band:

1. **Connected fraction** — what % are a single connected component (the kill condition: if this is
   ~95%+, the lever is dead — say so loudly and stop).
2. **Multi-component-with-a-non-trivial-split fraction** — of the decomposable ones, how many have ≥2
   components *each of size ≥2* (the genuinely useful case), vs the "one big core + k isolated vertices"
   case (which `iso_strip` already showed is rare and, for odd k, needs the nimber).
3. **Largest-component-≤k fraction**, for `k ∈ {6,7,8}` — what % have *every* component ≤ k (fully
   table-resolvable, no recursion at all) — this is the no-recursion hit rate, the direct payoff bound.
4. **Isolated-vertex count distribution** (0,1,2,…) per band — quantifies the "1-isolated needs nimber"
   case the boolean strip can't capture, which is decomposition's marginal value over `iso_strip`.

### Why NOT just reuse `comps_dense_nimber_coverage`

That existing report (`bin/queens.rs:2786`) already taps `component_profile` over the **whole-position
D4-distinct working set** captured by the *sequential exact* solver. It is the wrong population for two
reasons:

- It's the **whole `avail` graph at every node**, not the **child0 graph that getK is called on** at
  pc 13–16 in the parallel-DFS tail. The distributions differ (getK is fed child graphs at exact pc
  bands; the working set is all pcs and is D4-distinct, not the giant root's actual stream).
- It's the **sequential** solver's set; the lever fires in the **parallel** giant root, whose graph
  stream is what pays. (Phase-0 of the grouped-DDD proposal already measured whole-position
  largest-component coverage — n=14 maxc≤8 = 54.9%, ≤12 = 82.3% — but those are whole positions, and
  most of that coverage is *single connected components ≤ k*, which the W8/tiny tables ALREADY resolve.
  The incremental value here is only the **pc>k, all-components-≤k** slice, exactly what abf38ee's note
  flagged as "must be measured first.")

### The exact tap design (the established monomorphised cold-tap pattern)

Follow `QUEENS_SIZE`/`M_SIZE` and `M_PROF` exactly: a `MODE`-gated, thread-local, per-worker
accumulator, resolved **once per subtree handoff** (the `mode` switch at `iso_flat.rs:3374`), DCE'd to
nothing in production. Add a new measurement mode `M_DECPROBE` (decomposition probe).

- **Where it taps:** inside the getK dispatch arms in `wins_inc`'s fused descent
  (`iso_flat.rs:2340–2355`, the `DK>=16 && pc==16 => !self.w16_get(att, child0)` cascade) **and** the
  iterative/STEAL twin (`iso_flat.rs:2650–2665`). For `pc ∈ 13..=16`, before calling `wXX_get(att,
  child0)`, when `MODE == M_DECPROBE`, run a cheap decomposition of `child0` (the union-find of §3) and
  bump a thread-local histogram, then proceed to the normal `wXX_get` (the verdict is unchanged — this
  is read-only instrumentation). Because it's `const MODE`, it const-folds out of every production arm.
- **What it records** (a small `[u64]` per `(pc band, bucket)`):
  - `ncomp` histogram (1, 2, 3, …) per pc band;
  - `n_isolated` histogram per pc band;
  - `maxc≤k` flags for k ∈ {6,7,8} per pc band;
  - `has_split_ge2` (≥2 components each size ≥2) per pc band.
- **Tail-only restriction (the population that matters):** gate the bump on "this handoff is a tail
  subtree." Cheapest correct proxy: only tap when the producing root is the dominant one. Simplest
  build: reuse `QUEENS_ROOT_TIMING`'s per-root identity — thread a `tail: bool` into the handoff (§5)
  and only bump when `tail`. For the *measurement* pass we can be looser: tap **all** roots but
  **also** bin by `node_pc`-at-handoff and by a wall-time bucket (the late tail is the last few seconds
  of the stream from the single busy worker, exactly what `M_SIZE`'s "contiguous probe-stream prefix"
  comment relies on). Cross-check the late-tail bins against the all-root bins — if they agree, the
  whole-stream number is a fair proxy and we don't need precise tail gating for the Fermi.
- **Driver:** a new `count`-style report `decomp_report` wired beside `comps_dense_nimber_coverage`,
  OR — better, since we need the *parallel giant-root* distribution, not the sequential working set —
  run the **production iso-dense solver at n=16 with `QUEENS_DECPROBE=1`** for a bounded slice (e.g.
  first ~2 minutes of a single run, or n=14 to completion as a cheaper proxy first), flushing the
  per-worker accumulators at the end (same flush pattern as `ORACLE_ACC`/`SIZE_ACC`). n=14 first (cheap,
  deterministic), then a partial n=16 to confirm the trend holds / strengthens with board size.

### Kill criterion (state it before measuring)

Channel Fermi up front (so the result can't be rationalised after the fact):

- **If the pc 13–16 graphs are >~90% single-connected → DEAD. Stop, bank the negative.** This is the
  likely outcome given `iso_strip` (WASH) and `module_profile` (modules absent). Decomposition fires on
  ~nothing.
- **If multi-component-with-split (case 2) is <~10% AND maxc≤8 (case 3) is <~15% → too small.** The
  per-node decompose tax (paid on *every* pc 13–16 getK call to find the split) plus the build cost will
  not be repaid by collapsing the recursion on <15% of calls. Park.
- **Proceed only if** a meaningful fraction (say maxc≤8 ≳ 20–25%, the "no recursion at all" slice, OR
  multi-component-split ≳ 20%) of pc 13–16 getK graphs decompose, AND the 1-isolated/odd-isolated case
  (which `iso_strip` couldn't capture but the nimber can) is common enough to add to it.

---

## 2. The dense Grundy table design (the cost-killer: removes the recursion)

### What it is

A W8-discipline table — like `dense.rs build_tables()` / `DenseW8` — but storing the **Sprague-Grundy
nimber** (a small int) per labelled-edge code instead of a single win/loss bit, for all labelled Node
Kayles graphs on ≤ k vertices.

### Cell size (max nimber for ≤k-vertex Node Kayles)

Nimbers of Node-Kayles components can exceed 1 (unlike clique-1 cases), so the cell is a small int, not
a bit. We must bound `g_max(k)` = max nimber over connected (and disconnected, for the XOR) ≤k-vertex
graphs to size the cell:

- A graph on `k` vertices is a game tree of depth ≤ k, so `g < k+1` trivially — but the real bound is
  much smaller. The literature on Node Kayles / OEIS A344227 and the Grundy values of small graphs put
  small-graph nimbers in the low single digits.
- **Design decision: store a `u8` (one byte/code) and assert `g < 16` at build time** (a
  `debug_assert!(mex < 16)` in the build, plus a once-checked `const`/runtime max). A `u8` is generous;
  if measurement of the build confirms `g_max(8) ≤ 7` we could pack to a nibble (2 codes/byte) to halve
  the footprint, but **start with `u8`** — the byte table is simpler and the footprint (below) is
  already idle-core-feasible. **Do not guess the bound — the build computes the actual max and the
  assert is the gate.** (The empirical max for ≤8-vertex graphs is what the build prints; size the final
  cell to that.)
- The nim-sum at decomposition time is over the *stored* component nimbers, each < 16, and an XOR of
  values < 16 is < 16 — so the position's boolean verdict ("nim-sum == 0?") is exact regardless.

### Build algorithm (reuse the existing pext machinery)

Mirror `build_tables` / `build_table` / `graph_wins8` exactly, but compute `mex` over children's
nimbers instead of OR over children's win/loss:

```
// grundy_build_table(k, gtables): for each labelled k-code (parallel over words, like build_table)
//   adj = extract_adj::<k>(code, &WK_MASKS.0)        // existing pext adjacency recovery
//   let mut seen = 0u32                              // bitset of child nimbers (< 16 < 32)
//   for i in 0..k:
//       child = full & !((1<<i) | adj[i])            // remove N[v]  (SAME child set as graph_wins)
//       child_code = pext(code, WK_MASKS.1[child])   // existing induced-mask projection
//       seen |= 1 << gtables[child.count_ones()][child_code]   // child's nimber (table lookup)
//   gtable[code] = trailing_zeros(!seen)             // mex
```

Key points:
- **Identical child enumeration and projection** to `graph_wins8` / `get9` — we reuse `extract_adj`,
  `W*_MASKS`, `pext128`/`pext128_wide`. The ONLY change is `seen |= 1 << g_child` + `mex` instead of
  `if !child_win { return true }`. So the per-code build cost is ~the same shape as the boolean build,
  plus a small constant (the mex is `trailing_zeros(!seen)`, one instruction).
- **Bottom-up by size**, k = 1..=K (each size built from the complete tables below it), exactly like
  `build_tables`. A connected component's children are subgraphs of strictly fewer vertices, all in the
  table below — no recursion at build time, no recursion at lookup time.
- **Disconnected codes:** the table is over *labelled* graphs and stores the true Grundy value of the
  whole labelled graph, so it already handles a disconnected ≤k-vertex graph correctly (its build
  enumerates all child moves, which respect components automatically). So at lookup time we do NOT need
  to decompose a ≤k graph — one table lookup gives its nimber directly. (Decomposition is only needed to
  *split a pc>k graph into ≤k pieces*; see §3.)

### Memory footprint per k (the idle-core-feasibility driver)

The table is `slots(k) = 2^(k(k-1)/2)` codes (same as the boolean W tables), one byte each (u8 cell):

| k | edges = k(k−1)/2 | codes = 2^edges | bytes (u8/code) | feasible to idle-build? |
|---|------------------|-----------------|------------------|--------------------------|
| 6 | 15               | 32,768          | 32 KiB           | trivially (microseconds) |
| 7 | 21               | 2,097,152       | 2 MiB            | trivially                |
| 8 | 28               | 268,435,456     | **256 MiB**      | **the open question**    |
| 9 | 36               | 6.9e10          | 64 GiB           | infeasible (as boolean)  |

So **k=8 is the ceiling** (k≥9 is infeasible, same wall the boolean W tables hit). The k=8 Grundy table
is **256 MiB** (one byte/code over 2^28 codes) vs the boolean W8's 32 MiB (one bit/code). That 256 MiB
is fine for RAM, but the **build cost** is the question:

- The boolean W8 build is 2^28 codes and, even after the `--15` pext win (`graph_wins8`), was the
  dominant startup-prep cost (it took prep from 3.3s → 1.3s *just for W8*; the W8 boolean build is
  ~1s-ish on all cores via `into_par_iter`).
- The Grundy k=8 build is the **same 2^28 codes, same pext child-projection, ~same per-code work**
  (mex instead of OR is ~free). So expect the Grundy-k=8 build to cost **~1s on all 24 cores** — but we
  do NOT have all 24 cores; we have the **idle cores after the early roots finish** (§4). The question
  is whether ~23 idle cores for the ~few seconds before the tail dominates can finish a ~1-core-second
  ×24 = ~24 core-second job. **24 core-seconds / 23 idle cores ≈ 1.05s of wall** — feasible **if** the
  idle window opens early enough and lasts ≳1.5s. The §1 root-timing already shows the early roots
  finish well before the tail, so the window exists; the build just races the tail's start.
- **Fallback caps:** if k=8 doesn't finish in the idle window (measure the idle-window length from
  `print_root_timing`), cap at **k=7 (2 MiB, sub-millisecond build)** or **k=6 (32 KiB, trivial)** and
  measure the decomposability payoff at that cap. The §1 measurement reports maxc≤6/≤7/≤8 separately
  precisely so we can pick the cap by where the coverage actually is. Given `iso_strip`'s WASH, k=6/k=7
  may capture nearly all the (small) real payoff anyway.

### The dense Grundy table is the reason this isn't the 6.6× redux

abf38ee was 6.6× because `comp_nimber` **recursed** (cutoff-free mex over every move, exploding past
cap-7). Here, a ≤k component's nimber is **one indexed table load** — no recursion, no mex at search
time. The mex is paid **once per labelled code at build time**, amortised over every reuse, exactly as
W8's boolean build amortises the win/loss. This is the "W8 discipline applied to nimbers" that both the
grouped-DDD proposal and the umbrella handoff name as the live revival.

---

## 3. Component detection inside getK (cheap split from the adjacency rows)

When a pc>k graph `child0` reaches a getK arm and the tail flag is on, we must split it into connected
components cheaply, look up each ≤k component's nimber, recurse (boolean getK) only on components >k,
XOR, and compare to 0.

### Two places the adjacency already exists

- In `wins_inc`/getK, `child0` is a `Bits` ([u64;4]) mask; `q.component(start, child0)` (graph.rs:1526)
  already flood-fills a connected component over attack edges in O(component · words). But it reads
  `self.attack[v]` (board geometry) — fine in `iso_flat` (the solver has `q`), available at the getK
  call site.
- Inside `DenseW8::getK`, `extract_adj` already recovers the `adj: [u16; K]` rows (the per-vertex
  neighbour bitmasks within the k relabelled vertices). For a split *inside* getK at the dense layer,
  union-find over those ≤16 `u16` rows is the natural form.

### The cheap split: union-find / BFS over ≤16 bitmask rows

Since K ≤ 16, the graph is ≤16 vertices with `u16` adjacency rows. A bitmask BFS flood-fill is the
cheapest:

```
// components_of(adj: &[u16; K], k) -> small list of u16 component masks
let mut unseen = full;                       // (1<<k)-1
while unseen != 0 {
    let start = unseen.trailing_zeros();
    let mut comp = 1u16 << start;
    loop {
        // expand: union of adj rows of vertices in comp, restricted to unseen, minus comp
        let mut nbr = 0u16;
        let mut r = comp;
        while r != 0 { let v = r.trailing_zeros(); r &= r-1; nbr |= adj[v as usize]; }
        let next = nbr & !comp & unseen;
        if next == 0 { break; }
        comp |= next;
    }
    unseen &= !comp;
    // emit comp (popcount, and its relabelled code via pext(code, induced[comp]))
}
```

Cost: O(k · words-in-comp) ≈ a few dozen ops for k≤16 — cheap relative to the deep getK recursion it
replaces *when it fires*, but **paid on every pc>k getK call whether or not it splits** (that's the tax
the kill-criterion weighs). A union-find with path compression is an alternative but the bitmask BFS is
simpler and k is tiny.

### After the split

For each component mask `c` (a `u16` over the relabelled vertices):
- popcount ≤ k → project its code via the **existing** `pext(code, induced[c])` machinery (the same
  `W*_MASKS.1[c]` induced masks getK already uses) and look up `grundy_table[popcount][ccode]` → nimber.
- popcount > k → recurse into the boolean `getK` for that component (project its code, call the
  appropriate `getKonly` evaluator). But note: a single component > k means we did NOT decompose the
  whole graph into ≤k pieces — so for the **boolean verdict** we don't actually need the *nimber* of the
  >k component, we need its win/loss. **This is the subtle correctness point:** to XOR we need each
  component's **nimber**, and a >k component's nimber would need the cutoff-free recursion again (the
  6.6× trap). **So the decomposition only pays when EVERY component is ≤k.** If any component is >k,
  fall straight through to the normal boolean getK on the whole graph (no XOR, no nimber-of-big-comp).
  This is exactly `try_oracle_nimber`'s structure (return `None` if any component > cap) and it's what
  keeps us out of the recursion trap.

So the in-getK fast path is:

```
if tail:
    let comps = components_of(adj, k);
    if comps.iter().all(|c| popcount(c) <= GK) {     // GK = Grundy table cap (8/7/6)
        let mut x = 0u8;
        for c in comps { x ^= grundy[popcount(c)][project(code, induced[c])]; }
        return x != 0;                                // win iff nim-sum != 0; NO recursion
    }
    // else: some component > GK → fall through to the existing boolean getK (unchanged)
boolean_getK(code)
```

The "all components ≤ GK" gate is the same coverage §1 measures as case 3 (maxc≤k). **If §1 says that's
rare in pc 13–16, this path almost never fires and the decompose tax dominates → the kill criterion.**

---

## 4. The idle-core prep mechanism

### When the idle window opens

`print_root_timing` already shows the schedule: the early roots finish, then ~23 cores go idle while
the giant root grinds (the "SOLO for last X s" tail). The Grundy build must overlap that window and be
ready before the tail's getK calls need it.

### How to kick it off (two options)

- **Option P1 (simplest, recommended): build at startup, overlapped with the existing W8 boolean build
  + TT alloc.** `new_dense` already spawns a warm thread (`iso_flat.rs:834`) and the W8 boolean build
  runs on all cores via `into_par_iter`. The Grundy k≤8 build is the **same pext machinery** and can be
  built **in the same `build_tables` startup pass**, on all cores, before the root fan even starts. Cost
  ~1s added to prep (256 MiB k=8) — which **eats into the e2e budget** (prep is currently ~1.4s). At a
  ~27s e2e this is +1s prep for a search win that must exceed it. **This is the clean design**; it
  doesn't need idle-core scheduling at all, and it sidesteps the "what if the tail starts first"
  race entirely. Use this unless the +1s prep is the thing blocking sub-25s.
- **Option P2 (the user's "idle-core prep" framing, if prep budget is tight): defer the Grundy build to
  a detached rayon task kicked off at root-fan start, racing the tail.** The early roots occupy all
  cores briefly, then free them; a `rayon::spawn` of the parallel `into_par_iter` Grundy build picks up
  the freed cores. A `OnceLock<GrundyTables>` / `AtomicBool ready` flag guards readiness.
  - **If the tail's getK calls arrive before `ready`:** the tail-gated decomposition path checks
    `ready.load(Relaxed)` once per handoff (resolved into the `const`/field at the handoff seam, NOT per
    node) — if not ready, the tail subtree runs the **plain boolean getK** (the current production path),
    byte-identical. As soon as `ready` flips, subsequent tail handoffs pick up the decomposition mode.
    No correctness risk (boolean getK is always a valid fallback), only a missed-optimisation window.

P1 vs P2 is a prep-budget tradeoff measured against the §6 Fermi: if the search win is ≫ 1s, P1's
simplicity wins; if it's marginal, P2 hides the build cost behind the parallel phase. **Recommend P1 for
the first build** (simplest, no race, no idle-core scheduler), switch to P2 only if prep is the binding
constraint.

---

## 5. The tail-only gating (concrete mechanism)

The decomposition must run **only inside the ~2 deep serial roots' getK tail**, never in the parallel
phase. The seam already exists: **MODE is resolved once per subtree handoff** at `iso_flat.rs:3374`
(the `if WINDOW && !ORACLE && !COUNT { … pick M_WAVE/M_ORD_W/… }` switch), and threaded as a `const
MODE` into the fully-monomorphised `wins_inc` recursion. The getK arms already branch on nothing
per-node that we'd disturb.

### Mechanism: a `tail: bool` threaded to the handoff, selecting a decomposition mode

1. **Detect "this handoff belongs to a tail root."** Cheapest correct signal: the parallel driver knows
   which roots are still running. Reuse the root-timing / root-completion machinery: when the number of
   still-running roots drops to ≤ T (e.g. ≤2, "the deep serial roots"), set an `AtomicBool tail_phase`.
   Every `par_wins_inc` handoff reads `tail_phase` **once** at the handoff seam (the same place it reads
   `self.size`/`self.wave`, not per node) and picks `M_ORD_W` (production) vs a new `M_ORD_W_DECOMP`
   monomorphisation. Because it's a `const MODE`, the decomposition code DCEs entirely out of the
   non-tail (parallel-phase) instantiation — **the parallel phase pays zero**, satisfying the user's
   constraint exactly.
   - Even simpler first cut for measurement: gate on `node_pc`/depth (the tail subtrees handed off late
     are deep) or on a wall-clock `Instant` past a threshold — but the "still-running-roots ≤ T" signal
     is the precise one and is cheap (one atomic flip when a root completes, one relaxed load per
     handoff).
2. **The new mode.** `M_ORD_W_DECOMP` is `M_ORD_W` (the production dynamic-ordering + ETC body) with the
   getK arms (pc 13–16) routed through the §3 decompose-then-XOR fast path (with boolean getK fallback).
   Add it to the `mode` switch (3374) and the dispatch (3412) and the `par_root` match — mechanical, the
   pattern is already there for `M_WAVE`/`M_ORD_W`/`M_L0`/etc. Both the fused-descent getK cascade
   (2340) and the iterative/STEAL twin (2650) need the decomposition arm (or restrict the lever to one
   descent form first).
3. **Const-generic alternative.** If a new `MODE` value is too coarse (MODE already carries a lot), thread
   a `const TAIL: bool` generic alongside `DK`. Either works; the `MODE` route reuses the existing seam
   with least new plumbing.

**Why tail-only matters quantitatively:** the decompose tax (§3) is paid on every pc 13–16 getK call in
whatever phase it runs. The parallel phase has 35 roots' worth of getK calls across 24 cores — taxing
all of them to help only the tail would be a large net loss (most parallel-phase nodes never benefit and
the cores are already busy). Restricting to the tail means the tax is paid only where the single-threaded
critical path is the wall, so any per-node win there is a direct wall win.

---

## 6. Fermi estimate (channel the napkin) + kill criterion

Let:
- `f` = fraction of pc 13–16 getK calls (in the tail) whose graph has **every component ≤ GK** (the
  no-recursion fast-path hit rate — §1 case 3). **Unknown until §1; the whole estimate hinges on it.**
- getK evaluators are ~35% of tail cycles. The pc 13–16 layers are a portion of that; the get9/get10
  *leaves* dominate, but those leaves are reached *through* the pc 13–16 recursion, so collapsing a pc
  13–16 graph via decomposition removes the whole nested sweep beneath it. Call the share of getK cycles
  attributable to pc≥13 entry sweeps `s` (likely the larger, deeper sweeps — order ~½ of getK, so
  ~17% of total).
- Decompose tax `t` ≈ a few % of a getK call (union-find over ≤16 u16 rows + the all-≤GK check), paid on
  **all** pc 13–16 tail getK calls.

Rough wall delta on the tail (which is ~94% of e2e):
```
Δcyc ≈ −(f · s · [fraction of the sweep below the decomposition point])   +   (t · all pc13-16 calls)
```
- **Optimistic (f ≈ 0.3, decomposition removes ~⅔ of the collapsed sweep, t ≈ 0.05·call):**
  win ≈ 0.3 · 0.17 · 0.6 ≈ **−3% of tail cycles** minus a ~1% tax ≈ **~−2% tail wall ≈ −0.5s e2e** —
  *plus* the §4 prep cost (P1: +1s prep). **Net could be NEGATIVE on e2e even if the search shrinks**,
  unless `f` is well above 0.3 or P2 hides the build. This is a **modest, prep-cost-sensitive** lever
  even in the optimistic case.
- **Pessimistic (f ≈ 0.05, the `iso_strip`/`module_profile` world):** win ≈ 0.05 · 0.17 · 0.6 ≈ −0.5%
  minus the tax ≈ **net WASH-to-negative**, plus the build cost = **clear loss**. This is the *expected*
  outcome from the two banked negatives.

**Kill criterion (decide before measuring):**
- **Abandon if §1 shows the pc 13–16 tail getK graphs are <~20% "all components ≤ GK" (case 3) AND
  <~20% multi-component-split (case 2).** Below that, the fast path fires too rarely to repay the
  per-call decompose tax + the build cost. Given `iso_strip` (WASH) and `module_profile` (modules
  absent), **this is the likely outcome and we should expect to bank a negative.**
- **Even if §1 passes, gate the build on the Fermi:** the search win must exceed the prep cost (P1) or
  the lever must use P2 to hide the build, AND the interleaved n=16 A/B (total cycles, the only
  trustworthy metric — single runs are ±18% noisy) must show a real wall cut, not a node cut alone
  (abf38ee cut nodes −74% and lost 6.6× — node count is NOT the metric here).

---

## 7. Risks / why it might still wash (and precisely why this avoids the 6.6×)

1. **The premise risk (the big one): the tail graphs are connected.** Two in-repo measurements already
   point here — `iso_strip` (WASH: ≥2 isolated verts rarely coexist) and `module_profile` (size-≥3
   modules absent, twins → 0% by pc 18). If pc 13–16 getK graphs are overwhelmingly single connected
   components, decomposition fires on almost nothing and the §3 split is pure tax. **§1 is the gate
   precisely because this risk is real and likely.** Do not build past §1 without the data.
2. **Why this is NOT the abf38ee 6.6×:** abf38ee's killer was the **cutoff-free nimber recursion** —
   `comp_nimber` computing a full mex over every move and recursing, which exploded past cap-7. This
   design has **no search-time recursion for ≤k components**: a component's nimber is one dense table
   lookup, the mex paid once at build time and amortised (the W8 discipline). The only search-time
   recursion left is the boolean getK on the **fallback** path (some component > GK), which is exactly
   today's production path — so the worst case degrades to current behaviour plus the decompose tax, not
   to 6.6×.
3. **The decompose tax on non-firing calls.** Even with the table, every pc 13–16 tail getK call pays
   the union-find + all-≤GK check. If `f` is low, this tax is unrepaid. Mitigation: a cheap pre-filter
   — count isolated vertices (`extract_adj` already computes the `iso` mask "for free") and only run the
   full split when `iso != 0` or a quick "is this connected?" bitmask check fails. (The `iso` mask is
   already fused into `extract_adj` for the parked pair-strip — reuse it as the pre-filter so connected
   graphs skip the split entirely.)
4. **Build cost vs e2e budget.** At ~27s e2e with ~1.4s prep, a +1s k=8 Grundy build (P1) is a real
   fraction of the budget. If the search win is small (the Fermi's optimistic −0.5s), P1 is net-negative
   on e2e. P2 (idle-core overlap) hides it but adds the readiness-race complexity. **The k=8 table is
   only worth its build cost if §1's coverage is high; otherwise cap at k=6/7 (near-free build) and
   accept the smaller coverage.**
5. **Two descent forms.** The fused descent (`wins_inc`) and the iterative/STEAL twin both have getK
   cascades; the lever must cover the one the tail actually uses (the tail is single-threaded — confirm
   whether it runs the fused `wins_inc` handoff or the iterative loop, and instrument/gate only that
   one first).
6. **Validation gate (must hold, unchanged):** `solver_lineage_agrees` (n≤9 vs naive); n=12 iso-flat
   `--distinct` = 1,060,823 exact; n=14 iso-dense byte-identical node count (3,955,635) with the lever
   **off**, and a *verdict-preserving* node-count change with it **on** (the decomposition changes which
   getK calls recurse, not the verdict — like ETC, it's value-preserving). The Grundy table itself gets
   a `direct_grundy_matches_scalar`-style test: a scalar mex reference vs the pext build, like
   `graph_wins8_matches_scalar` / `direct_w*_matches_scalar_recurrence` already do for the boolean
   tables. n=16 cross-checks Jenrich (second player).

---

## Recommendation

**Do §1 and nothing else until it passes.** Build `M_DECPROBE` (the cold, monomorphised,
const-folded-out decomposition tap in the getK arms), run it at n=14 to completion then a partial n=16,
and report — per pc band 13–16, restricted to the tail / late-stream — the connected fraction, the
multi-component-split fraction, the maxc≤{6,7,8} fraction, and the isolated-vertex distribution.

**The single most important measurement:** *of the pc 13–16 getK graphs in the giant root's tail, what
fraction have every connected component ≤ 8 (table-resolvable with no recursion)?* If that fraction is
small (the likely outcome, given the banked `iso_strip` WASH and `module_profile` "modules absent"
results), **the lever is dead — bank it as a negative** and point the next session at the parked
sidecar/DRAM work instead. If it's surprisingly high (≳20–25%), the dense-Grundy-≤8 table + tail-gated
decompose is worth a Phase-1 build, sized by the Fermi against the +1s prep cost.

This design's contribution over the two prior negatives is exactly two moves — **(a) the dense Grundy
table removes the search-time recursion that made abf38ee 6.6×, and (b) tail-only gating removes the
parallel-phase tax** — but neither move helps if the graphs don't decompose, and the evidence we already
have says they may well not. Measure first.
