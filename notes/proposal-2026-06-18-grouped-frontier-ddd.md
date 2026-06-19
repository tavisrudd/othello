# Proposal: grouped-frontier k=9..12 — the path below 2m44s and the n=18 enabler

## Status

Draft — **Phase 0 measured (2026-06-18): A validated, gated-B dropped.** See "Phase 0 results" below.

## Problem

iso-window solves n=16 in ~2m44s (~35 M/s, ~5.4 B nodes). The theoretical **compute floor is
~45–60s** — we're ~3× over. This session established (via the set-associative-buckets
investigation) that **n=16/17 GB is *not* eviction/capacity-bound**: re-expansion is ~1.0–1.15×,
the flat TT tops out ~88–91% full, and capacity levers (assoc, smaller tables) buy ~nothing. The
wall is therefore **node count (~5.4 B) and per-node latency**, not table size.

The load-bearing axis is node count. The one structural lever that attacks it is **solving each
unique sub-problem once** instead of rediscovering it under many parents. W8 already proves this
works: the complete dense pc==8 table resolves every 8-vertex boundary subgame by one labelled-edge
lookup and **never re-expands its ≤7 subtree** — that single change took us from 3m33s to 2m44s
(closing the ~28% re-expansion gap at pc=8). The question is how to extend that "solve-once" win
*upward* past k=8, where a complete labelled table is infeasible (W9 = 2^36 rows = 8 GiB; k≥10
impossible).

## Context

**What already exists (and is load-bearing here):**

- **W8 dense layer** (`dense.rs`): complete win/loss for all labelled Node-Kayles graphs ≤ 8
  vertices, 32 MiB, eviction-free, one indexed bit lookup. Hooked at `wins_inc` via `w8_get` when a
  child crosses `pc == 8`. This is the existing "solve-once boundary" mechanism.
- **The ≤7 tiny table** (`tiny_tt` + `enter_graph`/`solve_local`): at `pc ≤ 7` a node builds a
  `TinyGraph` once and solves the whole subtree in a 128-byte L1 `solve_local` memo, keyed by the
  *labelled* dense index (`tiny_table_index`) — eviction-free, no DRAM.
- **The nimber oracle, "Lever B"** (`try_oracle_nimber`/`comp_nimber`/`position_nimber`,
  `QUEENS_NIMBER_ORACLE=1`): **decomposes the available graph into connected components, computes
  each component's Sprague-Grundy nimber, XORs them, and returns the value with *no recursion*** —
  but only when every component is `≤ nimber_k` (default `min(7)`). `comp_nimber` already memoizes
  per-component nimbers (keyed by the component's tiny iso key) — *in the evictable flat TT*.
- **`comps_report` / the G1 histogram** (`queens.rs`): deep in the tree the available graph
  **fragments into overwhelmingly tiny connected components**. The per-node *largest-component*
  histogram is exactly the "what fraction of nodes have all components ≤ k" curve — i.e. it sizes
  the oracle payoff directly. (Prior note: the all-≤7 region is ~42% of distinct nodes at n=14.)

**The reframe this gives us.** "Grouped-frontier k=9..12" should not dedup *whole* k-vertex boundary
positions — it should dedup **connected components**. Sprague-Grundy makes a position's value the
XOR of its components' nimbers, components are tiny and shared across vast numbers of parents, and
the machinery to do it (`position_nimber`) is already written. The lever is: **raise the
component-nimber table's cap to k=9..12 and make it dense + eviction-free** (W8's discipline, applied
to *components* not whole graphs). This is the "component cache was 10× the micro-opts" amortization,
and the documented "<20-min lever."

**Two properties that change the performance regime** (vs today's latency-bound random TT probe):
the component table is *small and dense* (component count ≪ position count, and reachable components
are a tiny fraction of labelled graphs), so it's **cache-resident, not DRAM-latency-bound**; and
component solves are **independent → embarrassingly parallel** (breaking the single-core
elder-brother bottleneck at n=16) and **checkpointable** (a clean dump/resume unit, unlike DFS
state).

**Prior art / constraints:** Codex's pump→group→dense-solve→merge sketch (folded into the iso-window
handoff): `WindowChunk { keys, closed, value, index }`, scalar+contiguous first, SIMD only after the
row space is dense, never SIMD in the recursive DFS. Validation gate (must hold): `solver_lineage_
agrees` (n≤9), `solve 12 iso-flat --distinct` = **1,060,823** exact, `solve 14 iso-flat --distinct`
second / re-exp ~1.0×; verdict cross-checks Jenrich (n=16 = second player).

---

## Approach A: Dense eviction-free component-nimber table (generalize Lever B + W8 upward)

### Architecture

Keep the DFS exactly as is for large/connected positions. Add a **dense, canonical-keyed,
eviction-free table of connected-component Sprague-Grundy nimbers** for components up to size
`COMP_K` (target 9..12). At every node, before expanding:

1. Decompose `avail` into connected components (`q.component`, already used by `position_nimber`).
2. If **all** components are `≤ COMP_K`: for each, look up its nimber in the dense component table
   (solve-once-and-insert on a miss); XOR → position value; **return with no recursion** (the Lever-B
   fast path, just with a bigger, eviction-free table).
3. Else (some component `> COMP_K`): fall through to the normal `wins_inc` DFS, which shrinks the big
   component until it (and everything below) drops under the cap.

The table is **reachable-only and lazily built**: we never enumerate all labelled k-graphs (W9 is 8
GiB; k≥10 impossible). A component is canonicalized (WL / tiny-canon key extended past 7) and solved
once on first encounter; the dense store holds `key → nimber`. Because components fragment small and
repeat enormously, the reachable distinct-component set is bounded and **cache-resident** — solving
each once and reusing it is the amortization.

Two sub-variants for the store:
- **A1 — lazy in-search table:** a dedicated dense/compact map (open-addressed `key→u8 nimber`,
  separate from the win/loss flat TT so it's not evicted by it), filled during the DFS. Minimal
  change: it's `comp_nimber` with a bigger cap and its own eviction-free arena.
- **A2 — staged pre-pass (W-style):** before the main solve, enumerate the *reachable* component set
  bottom-up by size (size s built from size <s, the W8 build pattern but reachable-only and
  canonical), freeze into an immutable dense array, then the search does pure lookups (never solves a
  component inline). Cleaner hot path, but needs the reachable set known up front.

```
// hot path (replaces the oracle gate in wins_inc, fires far more often with COMP_K=9..12)
let comps = decompose(avail);                       // q.component loop, already in position_nimber
if comps.iter().all(|c| c.popcount() <= COMP_K) {
    let mut x = 0u8;
    for c in comps { x ^= comp_table.nimber(c); }   // dense lookup; solve-once on miss (A1)
    return x != 0;                                  // win iff nim-sum != 0; NO recursion
}
// else: normal DFS (the big component shrinks toward the cap)
```

### Trade-offs

**Strengths:**
- **Reuses existing, tested machinery** (`comp_nimber`/`position_nimber`/`q.component`) — lowest
  composability risk: it fires as an oracle *inside* the unchanged DFS, exactly like `w8_get`. DFS-
  residence is preserved.
- **Biggest amortization, smallest footprint:** components are the maximally-shared substructure;
  the table is dense and cache-resident (not DRAM-latency-bound).
- **Embarrassingly parallel + checkpointable** component solves.
- **Payoff is measurable up front** from the `comps_report` G1 histogram (fraction of nodes with
  all-components ≤ k, per k) — Channel Fermi before building.
- Gate-friendly: win/loss is `nim-sum ≠ 0`, exact; distinct-count path unaffected (component table is
  a *value cache*, like the tiny table).

**Weaknesses:**
- **Nimber is heavier than win/loss per solve** (no α-β cutoff — the full Grundy value is needed to
  XOR). The bet is that *distinct-component count × per-component nimber cost* ≪ the re-expansion it
  removes. If components past k=8 are too numerous or too expensive, the bet fails — must measure.
- Needs a **canonical component key past 7** (the tiny-canon tops out at 7; WL-canon above is ~100×
  costlier per the iso-key memo) — the keying cost could dominate for k=9..12. A1 pays it inline.
- A2's reachable-set pre-pass is itself a forward search (discovery cost).

---

## Approach B: Frontier-chunk DDD (Codex's pump → group → dense-solve → merge)

### Architecture

Keep the DFS for the top of the tree. At a chosen boundary popcount `k`, **pump** crossing positions
into chunk queues instead of recursing. Bucket each by a cheap local signature (edge-code / canonical
bucket). When a chunk fills, build a dense local row space over only its reachable states, **solve
with linear passes** over compact arrays (`value[row] = any child row is a loss`), and **publish only
the boundary values** back to the shared TT / parent. The DFS consumes published values; positions
whose boundary isn't yet resolved suspend and resume.

```
WindowChunk { keys: Box<[u64]>, closed: Box<[u16]>, value: Box<[u64]>, index }
// dependency-ordered linear pass; dedup within/across chunks by sort (bandwidth-bound)
```

### Trade-offs

**Strengths:**
- Dedups **whole boundary positions** (not just components) — captures transposition reuse the
  component decomposition might miss (e.g. shared *connected* boundary graphs).
- Streaming/sort-dedup is **bandwidth-bound, fully parallel, checkpointable** — the n=18 dataflow.
- Generalizes cleanly to multiple boundary windows.

**Weaknesses:**
- **Highest engineering complexity:** the DFS must suspend/resume at the boundary (yield positions,
  await values) — a real restructure of `wins_inc`, the main composability risk.
- A dense local DP solved *per parent entry* was Codex's measured **negative** ("recompute too
  high") — the chunk grouping must be coarse enough to avoid that, which is the hard tuning.
- Whole-position keying is less dense than component keying (more distinct rows).

---

## Approach C: Full-replace layered DDD (bottom-up by popcount)

### Architecture

Abandon the DFS. Forward-enumerate the reachable frontier layer by layer down to the boundary, then
solve **bottom-up by popcount** with dense per-layer arrays, dedup by sort between layers, propagate
win/loss (or nimber) upward to the root.

### Trade-offs

**Strengths:**
- Pure DDD: maximal parallelism, bandwidth-bound, the cleanest checkpoint/resume, the most
  scalable to n=18+.

**Weaknesses:**
- **Loses α-β cutoffs entirely** — a bottom-up solve evaluates *every* reachable node, where the DFS
  stops at the first losing child. At n=16 that could be **more** total nodes than today's pruned
  ~5.4 B, not fewer. This is the fatal risk: W8 works because pc=8 subgames are tiny; a full pc≥9
  layered solve forfeits the pruning that makes the search feasible.
- Throws away the entire DFS-resident kernel (orientations, TinyGraph, `solve_local`, move ordering).
- Largest, riskiest rewrite; hardest to validate incrementally against the gate.

---

## Approach comparison

| Criterion | A: component-nimber table | B: frontier-chunk DDD | C: full-replace layered |
|---------------------------|---------------------------|------------------------|--------------------------|
| Unit of dedup | connected component | whole boundary position | whole layer |
| Reuses existing code | **high** (oracle + tiny) | low (new dataflow) | ~none (rewrite) |
| DFS-residence | **preserved** (oracle) | partial (suspend/resume) | abandoned |
| α-β cutoffs kept | **yes** | yes (above boundary) | **no** (fatal risk) |
| Composability risk | **low** | medium-high | very high |
| Memory regime | dense, cache-resident | streaming, bandwidth | streaming, bandwidth |
| Parallel / checkpoint | yes / yes | yes / yes | yes / **best** |
| Payoff pre-measurable | **yes** (G1 histogram) | partial | hard |
| Per-solve cost | nimber (heavier) | win/loss | win/loss |
| Main risk | component count/key cost | suspend/resume rewrite | loses pruning |

## Open questions

1. **What does the G1 histogram say at n=14/n=16?** For each `k ∈ {8..12}`, what fraction of searched
   nodes have *all* components ≤ k? This is the upper bound on Approach A's hit rate — measure before
   building (`count --comps`, and extend the largest-component tally past 7).
2. **Distinct reachable component count at each size 8..12?** Determines table footprint and whether
   it stays cache-resident. (Enumerate reachable components in a `count` pass.)
3. **Per-component nimber cost vs the win/loss expansion it removes** — the core Fermi. Nimber has no
   cutoff; is the once-per-distinct-component cost < the re-expansion saved?
4. **Canonical component key past 7** — extend the tiny-canon, or pay WL-canon (~100×)? Keying cost
   may set the practical `COMP_K`.
5. **A1 (lazy) vs A2 (staged pre-pass)** — does the inline solve-on-miss pollute the hot path enough
   to justify a W-style pre-pass?

## Phase 0 results (measured 2026-06-18, `count --comps` / `--roots`)

**A — per-node largest-component (the no-recursion gate), cumulative coverage:**

| component cap K | n=12 ≤K | n=14 ≤K | 8→12 marginal |
|---|---|---|---|
| ≤7 (current oracle) | 54.6% | 42.3% | — |
| ≤8 (W8 today) | 65.4% | 54.9% | — |
| ≤9 | 74.6% | 64.5% | +9–10 pts |
| ≤10 | 80.8% | 71.6% | +6–7 |
| ≤12 | 87.0% | 82.3% | **+21.6 / +27.4 pts** |

Raising the cap 8→12 lets the oracle resolve **+22 pts (n=12) / +27 pts (n=14)** more nodes with **no
recursion**. The ≤8 coverage *falls* as the board grows (bigger connected components), so **the lever
grows with n** — more valuable at n=16/18, the right direction. `comps/node ≈ 1.18–1.20` (mostly
connected), so ~80% of the leverage is "solve connected positions ≤k once," ~20% from multi-component
decomposition. **A is GO.**

**B — gated cheap-targeting: FAILED.** Spearman of every cheap per-root proxy → cross-root
`shared_volume` (n=12): centrality +0.54, avail_pop −0.54, frag −0.54, ncomp 0.00 — all below the
|ρ| ≳ 0.7 usefulness bar ("ordering can't help"). The capped-replay (D) shows even an *idealized*
reuse oracle shaves only ~3% of total expansion at the n=16 cap. **We cannot cheaply target B to
where it wins** (the user's stated precondition), so gated-B is dropped — not on principle, on
measurement. (Revisit only if a non-per-root gate — e.g. per-boundary-popcount or a learned local
signature — is found; the obvious structural proxies are flat.)

## Recommendation

**Approach A (dense eviction-free component-nimber table), sub-variant A1 first.** Phase 0 confirms it:
+27 pts no-recursion coverage at n=14, scaling up with n. Gated-B dropped on the measured proxy
flatness above.

Justification:
1. **Lowest risk, highest reuse.** It fires as an oracle *inside the unchanged DFS* (like `w8_get`),
   so it preserves DFS-residence and the α-β cutoffs — the two things Approach C fatally discards and
   B partially endangers. The decomposition + XOR machinery (`position_nimber`/`comp_nimber`) is
   already written and tested; the lever is a bigger cap + an eviction-free arena.
2. **It targets the right unit.** This session proved n=16 isn't capacity-bound — the win must come
   from *less work*, and connected components are the maximally-shared substructure (tiny, repeated
   across billions of parents). Whole-position dedup (B) is sparser; layer solves (C) do *more* work.
3. **The payoff is measurable before a line of solver code changes** — the G1 largest-component
   histogram per `k` is the Fermi. We can kill or size the lever from a `count --comps` run.
4. **It's the documented "<20-min lever"** and the "component cache = 10× the micro-opts" amortization
   — consistent with the project's banked conclusion that node-count/amortization levers dominate
   per-node micro-opts.

Keep **B as the fallback** if per-component nimber proves too expensive past k=8 (B dedups whole
boundary positions with win/loss cutoffs, sidestepping the nimber cost). **Park C** — losing α-β
pruning is too likely to *increase* node count at n=16.

### Implementation phases

- **Phase 0 — Fermi (no solver change).** Extend the `comps_report` largest-component tally past 7;
  run `count --comps` at n=14 (and a partial n=16) to get, per `k ∈ {8..12}`: (a) fraction of nodes
  with all-components ≤ k, (b) distinct reachable component count and size distribution. **Decision
  gate:** if the all-≤k fraction doesn't rise steeply past k=8, stop — the lever is too small. Napkin
  the table footprint (must stay cache-resident).
- **Phase 1 — minimum viable A1.** Raise the nimber-oracle cap to `COMP_K` behind a flag, backed by a
  *separate eviction-free* component-nimber arena (not the win/loss flat TT). Validate exactly on the
  gate (n=12 distinct 1,060,823; n=14 second). A/B n=14 node count: oracle-on must search **fewer**
  nodes (the dedup) — the win/loss equivalent of the −% nodes test. Profile (CPI/instr-per-node,
  n=16) — confirm the table is cache-resident, not a new DRAM stall.
- **Phase 2 — canonical key + density.** If the key cost dominates, extend the tiny-canon past 7
  (cheap labelled key) rather than WL; make the arena dense/compact (1 byte/nimber). Re-A/B n=16
  (M/s, the only trustworthy metric — node-count noise ±18%).
- **Phase 3 — parallelism + checkpoint.** Component solves are independent: parallelize the table
  fill (no speculation, like the even-ply DDD), and make the arena a clean dump/resume unit. This is
  the n=18 / multi-day-run enabler.
- **Phase 4 (optional) — A2 staged pre-pass** if the inline solve-on-miss still pollutes the hot path.

Each phase holds the full gate and cross-checks the verdict against Jenrich. Stop at any phase where
the measured win stalls — banking the result either way (the project's "document negatives" rule).
