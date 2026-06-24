# BuRR-backed iso-dense for n=18 — design (Phase 3b)

**Branch:** `queens-n18`  ·  **Status:** ⛔ **the central plan (C2 retrograde ply-windowed BFS) is
MEASURED-INFEASIBLE (2026-06-24, `a9de5dc`).** C1 (the store) landed and is sound; the *driver* that
would use it does not work. Read the banner below before building anything here.

> **✅ BUT a DIFFERENT path shipped (2026-06-24, `84a0fd8`+`0b91f2f`): DFS + the eviction-free BuRR
> store + disk-segment DDD.** It keeps DFS (so α-β pruning is intact — no retrograde enumeration), and
> instead of value-only ply-windowing it puts the membership-carrying ribbons **on disk** (the 1.4 TB
> ZFS pool) with only the per-segment Blooms resident, so the RAM cap bounds Blooms (~1 B/key) not
> ribbons (~6–8 B/key). Validated byte-identical to the in-RAM store + an eviction-relief win at n=14.
> **This is the live n=18 path** — see the umbrella's top Handoff Note. Everything below about C2/value-
> only ply-windowing is kept for the analysis, not as the plan.

Companion to `notes/proposal-2026-06-23-n18-feasibility.md` and `notes/n18-migration-changemap.md`.

## ⛔ C2 IS INFEASIBLE — the retrograde ply-windowed BFS stores the full reachable set (2026-06-24)

**The core premise of this doc is wrong.** It assumed "the working set IS the ~50 B distinct the
search visits, and the ply-windowed freeze stores that." But a **retrograde / ply-batched
breadth-first** driver has **no child values to prune with during forward expansion**, so it must
enumerate the **full reachable set**, not the α-β proof DAG. Measured (`count --reachable`, `a9de5dc`):

| n  | full reachable (forward BFS, canon-deduped) | α-β working set (proof DAG) | ratio |
|----|---------------------------------------------|-----------------------------|-------|
| 10 | 552,611                                     | 94,093                      | **5.87×** |
| 12 | 44,883,015                                  | 1,060,749                   | **42.31×** |

The ratio **explodes** with n (α-β pruning compounds). At n=18 the full reachable set is many orders
of magnitude beyond the ~50 B working set — so the value-only ribbon's ~64× density win is **swamped**
by a 42×→∞ enumeration blowup. Pruning is inherently DFS (you evaluate one child to cut its siblings);
ply-windowing/retrograde is inherently BFS (no values forward). **You cannot have both.** So:

- **Path A (membership-carrying, fp≈44–62 b/key):** ~275–400 GB for the 50 B working set — doesn't fit
  the 26 GB box. (Unchanged conclusion.)
- **Path B (value-only, ~1.1 b/key):** needs the 42×+ retrograde enumeration — **doesn't fit either.**

**⇒ Both BuRR modes are ruled out for a single 26 GB box.** This is not a "floor" — it's that *this
specific lever* (single-box BuRR ply-windowing) is dead. The open levers (the user's call):
1. **Cluster (Phase D)** — distribute the membership-carrying working set across machines (TDS;
   ~300 GB / 20 boxes). The design's own scale-out; needs the hardware + the TDS build.
2. **Bigger-RAM box** — a 512 GB machine holds the ~300–400 GB membership store directly.
3. **Working-set reduction** — the iso key (~3.4× → ~15 B → ~110 GB, still doesn't fit 26 GB) or
   component-nimber decomposition (lit-triaged *weak*: the n=18 tail is too sparse/connected to
   decompose — twin pairs ~0% by pc 18). A genuinely better canon would be a research result.
4. **Accept re-expansion** — a bounded-TT single-box run thrashes (first run: 8 GB TT, 99.7% cold,
   261 B nodes for ~1 root); the full second-player sweep is ≈ weeks and OOM-risky. Not a clean win.

**C1 (the store) still stands** as correct, reusable infrastructure (and the `count --by-pc` /
`--reachable` sizing taps are kept) — but nothing below the "Architecture (Path B)" line is a live
plan until the working-set-vs-reachable wall is resolved by one of the levers above.

---
(Everything below predates the C2-infeasibility finding — kept for the analysis, not as a live plan.)

## Why

The first-ever n=18 iso-dense run (flat 8 GB TT) confirmed the proposal's memory-bind risk **live**:
node count blew past the estimate to 100 B+ (R(18) ≈ 334× and climbing, vs central 150×), throughput
stayed healthy (~8.5 M/s, no thrash), RSS flat at 8.1 GB. That signature = **re-expansion from an
undersized table**, not a slow per-node or a bigger-than-expected *true* tree alone. The 8 GB TT
(~1.07 B slots) holds ~1–2% of n=18's working set, so transpositions that should be TT hits get
re-expanded, inflating the node count without thrashing. The flat TT cannot hold n=18 on this box.

## The finding: only one BuRR mode fits n=18

n=18 needs to memoize **~40–60 B distinct keys** (n=16's ~250 M stored × ~150–250× distinct growth;
cross-checks against the ~100 B nodes ÷ ~2–3× re-exp). Two BuRR modes exist; only one fits:

| path | bits/key | n=18 footprint (~50 B keys) | fits 16 GB free? | verdict |
|------|----------|-----------------------------|------------------|---------|
| **A. drop-in `BurrStore`, membership-carrying** (`fp_bits=44`) | ~62 (archive + seg-bloom) | **~310–465 GB** | **no** | dead as a *fix* — with the 12 GB cap it freezes ~1.5 B keys (~3% of the set) then latches `frozen_full` → the same re-expansion wall, just append-only segments instead of a direct-mapped table |
| **B. value-only, ply-windowed** (`fp_bits=0`) | **~1.1** | **~6–8 GB** | **yes** ✓ | the only representation that holds the whole working set in RAM |

**Why A can't escape:** `Archive::build` (burr.rs:322–328) — `fp_bits` doubles as the cascade's
layer-routing signal, so any *multi-layer* (capacity-spilling) or *live-TT-tier* build needs
`fp_bits > 0`; out-of-set probes on a bare ribbon return a random bit (~50% FP). A live search makes
billions of out-of-set probes, so the cascade tier is stuck at the ~44-bit fingerprint floor → ~62
bits/key → ~300 GB. No knob fixes this.

**Why B works:** transpositions are **strictly intra-ply** (each move places exactly one queen, so two
paths can only collide at equal queen-count). Freeze each ply's solved set into a **single-layer,
value-only** ribbon (`fp_bits=0`, ~1.1 bit/key). Deeper plies only ever query a frozen ply with keys
they *generated themselves* → every probe is in-set → the missing fingerprint is never needed. Sound
by construction; ~7 GB for all of n=18.

**Conclusion: a BuRR-backed n=18 solver is NOT a store-swap. It is a search restructure** (DFS → ply-
batched) — the only thing that unlocks value-only's 56× density win over membership-carrying.

## Architecture (Path B)

Keep iso-dense's value: the **dense getK layer** (collapses pc≤17 to table lookups — the node-count
win, 14× over iso-burr) and the per-node kernel. Replace the **store + control flow**:

```
KEEP (unchanged):
  - DenseW8 + getK / wK_get / adj_row_pext        (pc≤17 leaf eval — no storage)
  - skip18 (pc==18 band)                           (no storage; band = dense_k+1, see changemap)
  - the bitset rep (WORDS=6), canon, hash128, geom (all n=18-ready, validated)

CHANGE  (DFS  →  ply-windowed breadth-first):
  for ply p from deepest stored ply down to 0:        # p = queens placed; pc≥19 region only
    expand frontier(p): all pc≥19 nodes at this ply
    children resolved via getK (pc≤17) or the already-frozen DEEPER plies' value-only archives
    DDD: dedup the ply's positions by canonical key   # explicit, offline (not lazy TT-hit)
    freeze(p): Archive::build(pairs_p, val_bits=1, fp_bits=0, load≈0.99)   # ~1.1 bit/key, single layer
    archives[p] = ShardedArchive  (read-only thereafter)
  answer = root value
```

Query cascade for a node at ply p (resolving a child at ply p+1, i.e. one queen deeper):
```
child_val(key, p+1):
  if pc(child) ≤ 17: return getK(child)               # dense leaf, no storage
  return archives[p+1].get(archive_key(key))           # value-only, guaranteed in-set
```
No live mutable TT on the hot query path — each ply queries only *frozen, deeper* plies. The only
mutable structure is the **current ply's frontier buffer** (expanded, dedup'd, then frozen and freed).

### Storage layer (the scaffoldable, lower-risk piece)

A `PlyWindowStore` holding one value-only `ShardedArchive` per ply:
- `freeze_ply(p, pairs: &[(u64,u64)])` → `Archive::build(pairs, 1, 0, load)` per shard → `ShardedArchive`.
- `get(p, key) -> u8` → `archives[p].get(key) & 1` (value-only; the row IS the bit; no fp check).
- Append-only across plies; older shallow plies stay resident (small), deep plies are the bulk.
- Reuses **all** of `burr.rs` (`Archive`/`ShardedArchive`/`fastrange`/sharded build pool) unchanged.

### What's reuse vs greenfield

| piece | status |
|-------|--------|
| `Archive::build(fp=0)` value-only ribbon | **landed**, tested (burr.rs) — just feed it dedup'd ply pairs |
| `ShardedArchive` bounded-RAM sharded build | **landed** (burr.rs) |
| sharded build pool / freeze machinery | **landed** (store.rs `freeze_buffer`) — adapt to per-ply |
| dense getK layer + kernel + n=18 rep | **landed + validated** (this branch) |
| **ply-batched breadth-first driver + DDD** | **GREENFIELD** — the big lift; replaces the DFS in `wins_inc` |
| **frontier buffer / external-memory spill** for the widest ply | **GREENFIELD** — deep plies may exceed RAM; needs measure |

## Open questions (size with data before the big build)

1. **Re-expansion factor (running n=18's M_COLD).** When the flat-TT run finishes, the per-pc
   cold-fraction quantifies how much of the 100 B nodes is re-expansion vs true distinct. That sets
   the true working-set size and confirms B is worth the restructure (it is, unless re-exp ≈ 1.0×,
   which the run already disproves).
2. **Per-ply distinct distribution.** Value-only needs each ply's frontier to fit RAM *during*
   expansion (before freeze). The widest ply's size is unknown — needs a `count --by-ply` tap
   (or derive from M_COLD's per-pc node counts ≈ per-ply, since pc≈monotone in ply). If the widest
   ply > RAM, deep plies need external-memory DDD (sort-based, the classic frontier-search spill).
3. **Single-layer load factor.** Value-only needs a single ribbon layer (no bumping). `load` must be
   chosen so build never spills to a 2nd layer (which would need fp>0). Likely `load ≈ 0.95–0.99`
   with a fallback: if a ply doesn't fit one layer, split it (sub-shard) rather than add fp.
4. **Query cost.** iso-burr ran ~2.5 M/s (cascade walk). Value-only single-layer per-ply is *cheaper*
   (one ribbon probe, no fp check, no segment walk — exactly one archive per ply), so expect better
   than iso-burr. Net wall = (true ~50 B nodes) ÷ (per-node rate) with re-exp ≈ 1.0× — bounded, vs
   the flat TT's unbounded blow-up.

## C1 DONE (2026-06-24, `8d8bca6`/`c96dfd4`) — store wired + value-only soundness de-risked

Wiring `ply_store.rs` + unit-testing it **resolved open-question #3 and #2's load risk, and found
two soundness hazards the scaffold would have hit silently** (the value-corrupting class we just
fought in Phase A):

1. **`fp=0` multi-layer is UNSOUND.** `Archive::get` matches `fingerprint(k,0)==0` at layer 1
   unconditionally, so a key **bumped** to layer 2+ returns layer-1's row (some other key's value).
   The scaffold's `DEFAULT_LOAD=0.97` **spills to 3 layers**. Measured cliff (200 k keys/shard,
   single archive): load ≤0.92 → 1 layer (~1.09–1.11 bit/key), ≥0.94 → 2–3 layers (UNSOUND). Set
   **`DEFAULT_LOAD=0.90`** (~1.11 bit/key, matches the design's ~1.1) with margin below the cliff.
2. **Small ribbons can't single-layer at ANY load** (BuRR is *designed* to bump; even a ~1.5 k-key
   ribbon bumps at load 0.50). So a sharded store with small shards is unsound regardless of load.

**Fix = a hybrid store + a single-layer guarantee:**
- **small ply** (< `MIN_RIBBON_KEYS = 131072`) → **exact** sorted `(key,value)` slice, binary-searched
  (sound, ≤ ~1 MB). The ribbon's ~64× density win only matters for the deep billions-of-keys plies.
- **large ply** → sharded value-only ribbon, shards sized **≥ 2× MIN_RIBBON_KEYS** to clear the
  finite-size cliff; `build_value_only_single_layer` **steps the load down** on any residual spill so
  a shard can never end up multi-layer (never raises load / adds a fingerprint).
- Tests: round-trip through **both** paths; the load sweep; the step-down helper's single-layer
  guarantee at the threshold. All green; `make clippy` clean.

**Implication for the C2 driver:** per ply, hand `freeze_ply` the **deduplicated** `(key,val)` pairs;
it picks exact vs ribbon automatically. The ~1.11 bit/key holds, so the ~7–12 GB n=18 estimate stands.
Still open before C2: **per-ply (queen-count) frontier sizing** (open-question #2 — `count --by-ply`/
`count --by-pc`; pc is the cheap proxy, ply/queen-count is the sound window) to confirm the widest
ply's *expansion buffer* fits RAM (in-RAM driver, Phase 2) or needs external-memory DDD (Phase 3).

## Phased plan

- **Phase 0 (now, no compile):** this design + scaffold `PlyWindowStore` (storage layer, reuses
  `Archive`/`ShardedArchive`). Specify the driver restructure precisely; do NOT blind-code the
  DFS→BFS rewrite (it needs compile-iteration + the gates). **[C1 landed — see above.]**
- **Phase 1 (box free):** add `count --by-ply` to measure the per-ply distinct distribution on n=14/16
  (and read the finished n=18 M_COLD). Confirms working-set size + widest-ply RAM fit.
- **Phase 2:** build the in-RAM ply-windowed driver for the case where every ply fits RAM (n≤16 first,
  validate against the exact distinct gates: n=12 = 1,060,823, lineage). New solver `iso-dense-ply`.
- **Phase 3:** external-memory DDD for the widest plies if Phase 1 shows they exceed RAM (sort-based
  spill); then the real n=18.

## Decisions (locked 2026-06-23)

This is a **search restructure, not a store-swap** — a genuine architecture pivot (multi-session).
Both decisions are settled:
- **(a) Path B — value-only ply-windowed — is the target.** No Path-A stepping stone (A doesn't fit
  n=18, so it would only be an integration warm-up, not a fix).
- **(b) The DFS→BFS build is GATED on the finished flat-TT n=18 run's stats.** Do not start the
  driver rewrite until that run lands and we read its **M_COLD per-pc cold-fraction** (→ true
  re-expansion factor → working-set size → per-ply RAM fit). Cheap to read, sizes everything.

**Next-session order (when the box is free):**
1. Harvest the finished n=18 run: final node count, wall, verdict, and the **M_COLD per-pc
   cold-fraction** dump (the re-expansion measure). Record in this doc + the changemap.
2. Add `count --by-ply` (per-ply distinct distribution) and run on n=14/16 — confirms the **widest
   ply fits RAM** during expansion (the value-only build needs a ply's frontier in RAM before freeze).
3. Wire `ply_store.rs` into `mod.rs`, compile, unit-test `PlyWindowStore` (build/get round-trip,
   value-only collision rate).
4. Build the in-RAM ply-windowed driver (new solver `iso-dense-ply`); validate against the exact
   gates (n=12 distinct = 1,060,823, lineage, n=14 ≈ distinct). Keep the dense getK layer.
5. External-memory DDD for the widest plies only if step 2 shows they exceed RAM; then real n=18.

**Scaffolding already in place (this session, no-compile):** `ply_store.rs` (the per-ply value-only
storage layer, draft, not yet `mod`-included) + this design.
