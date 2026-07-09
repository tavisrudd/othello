# Representation-shrink audit — queens hot data structures

**Date**: 2026-06-18
**Scope**: PROPOSE only (no edits). Lens: is each field sized to its value range, and is each
hot struct packed to its minimum cache footprint? Default solver = `iso-window`
(`iso_flat.rs`, `iso_max_avail = 7`, `WINDOW = true`). All sizes below were measured with a
standalone `rustc -O` size probe and grepped against the live code.

## TL;DR ranking

| # | Candidate                                                   | Region (per-node?)            | Footprint / bandwidth win                          | Impl cost | Verdict |
|---|-------------------------------------------------------------|-------------------------------|----------------------------------------------------|-----------|---------|
| 1 | `expand_graph` `kids: [(u8,Bits,u64,u64); 8]` = **448 B**   | iso band, hottest tail        | 448 B → ~144 B stack/frame; kills a 32 B dead `Bits`| low       | **strong** |
| 2 | `hash128` folds all 4 key words incl. constant tag words    | every node (key hash)         | 2 of 4 mul-xor rounds are on constants → ~half      | low-med   | **strong** |
| 3 | Iso-band keys carry full 32 B `Bits` where 8 B hash suffices | iso band per node             | shrinks key plumbing; enables #1/#2                 | med       | medium  |
| 4 | `PnSlot` 48 B (4-word key + `u32`+`u32`+`u8`)                | `pn` only (cold, tiny boards) | 48→40 B, or full-fp slot → 16 B                     | low       | low (cold) |
| 5 | `att: [Bits;8]` table — orientations 1..8 dead in iso tail  | iso tail loads                | table 64 KiB→8 KiB if iso-only; but D4 path needs 8 | med       | park    |
| 6 | `TinyGraph` already 16 B, `[i8;128]` memo already minimal    | —                             | nothing to shrink                                   | —         | (clean) |
| 7 | `Slot` u64 packing: 55-bit fp / 8-bit val already tight      | TT probe                      | val only needs ~4 bits but no slot shrink possible  | —         | (clean) |

The load-bearing wins are **#1 and #2** — both in the per-node iso-band path that the default
solver spends almost all its time in, both pure mechanical shrinks with no merge/gate impact.

---

## 1. `expand_graph` kids array: 448 B with a dead 32-byte `Bits` per child  — STRONG

**Current** (`iso_flat.rs:1073`):
```rust
let mut kids: [(u8, Bits, u64, u64); MAXV_TINY] = [(0, Bits::ZERO, 0, 0); MAXV_TINY];
```
Measured element size `(u8, Bits, u64, u64)` = **56 B** (the `Bits` forces 8-byte align and 7
bytes of tail pad after the `u8`); the array is **448 B**, materialised on the stack of every
`expand_graph` call. `expand_graph` is the unified in-band expansion — the deepest, highest-node-
count region of the whole search (the `pc ≤ 7` band, ~42% of distinct nodes at n=14 per the
handoff). The tuple stores, per child: `child: u8` (alive bitmask, ≤ 8 bits), `ckey: Bits`
(the 256-bit tagged key), and `(cr, cf): (u64, u64)` (its precomputed hash halves).

**The `Bits` field is dead weight.** `ckey` is consumed only at `wins_graph(g, child, ckey, cr,
cf, …)` → `tt_get_h`/`tt_put_h`, which in the production (`COUNT = false`) instantiation ignore
`key` entirely and probe by `(route, fp)` (`tt.rs:640`/`645`). So in production the 32-byte
`ckey` is gathered, stored into the array, and carried for **eight children** without ever being
read. (`graph_key` at `iso_flat.rs:881` returns `(key, route, fp)`; only `route`/`fp` are live.)

**Shrunk representation:** `[(u8, u64, u64); 8]` — element 24 B (u64 align, 7 pad after the u8
+ the two u64s; actually packs to 24 B), array **192 B**; or reorder to `(u64, u64, u8)` /
split into parallel arrays `child:[u8;8]`, `cr:[u64;8]`, `cf:[u64;8]` to drop the pad → **136 B**
(`8 + 64 + 64`). Even the lazy `[(u8,u64,u64);8]` form is **448 → 192 B (−57%)**.

**Win:** the 448 B array straddles 7 cache lines; the 136 B parallel-array form is ~3 lines, and
the per-child store loop writes 24 B (or 8+8+8 across three arrays) instead of 56 B — over the
eight-child gather that is roughly 448 B → 136 B of L1 store traffic per expanded in-band node.
This is the single fattest per-node stack object in the hot path.

**Unpack cost:** none — it removes a field. The `COUNT = true` (`--distinct`) build *does* read
`ckey` (it keeps the band in the flat TT so the HLL sees every position, `enter_graph`/`band_entry`
`COUNT` arm). So `ckey` must stay reachable on the counting path. Cleanest: thread `ckey` only
under `if COUNT` (it's already a `const` generic, so the field can be `()` when `COUNT = false`
via a small assoc-type/`PhantomData`, or — simpler — just recompute `graph_bits(...)` for the
HLL fold in the COUNT arm, since COUNT is not the perf path).

**Correctness/gate:** production verdict is unchanged (the field was never read). `--distinct`
must still fold the canonical key into the HLL → keep `ckey` live only there. Gate: `solve 12
iso-flat --distinct` exact count is computed by the `COUNT` path, which keeps `ckey`; the
production W8/tiny path the gate's re-exp number rides on is unaffected.

**Cheapest experiment:** change the array element to `(u8, u64, u64)` and gate the `ckey` use
behind `COUNT`; interleaved A/B at n=14 (`solve 14 iso-flat`). Napkin: a few % at most (latency-
bound), but it's free and strictly reduces frame size.

---

## 2. `hash128` folds 4 words when graph/nimber keys have 2 constant words  — STRONG

**Current** (`tt.rs:622`): `hash128` loops over all four `key.0` words, doing two multiply-xor
avalanche steps (one for `route`, one for `fp`) **per word** — 8 mul + 8 shift-xor per call.
It is called on essentially every node (`wins_inc`/`wins_tiny`/`expand_graph`/`graph_key` each
hash the child key at creation, `iso_flat.rs:736,744,783,789,844,866,883,901`).

But the iso-band and nimber keys are **constant in their upper words**:
- `graph_bits(h)` (`mod.rs:139`) = `[h, mix64(h^c), 0x150_600D_600D_600D, 0]` — words 2,3 are
  **literal constants** (the namespace tag and a zero), identical for every iso-band key.
- `comp_nimber_bits(h)` (`iso_flat.rs:166`) = `[h, mix64(h^c), 0x4E49…, 0x4E49…]` — words 2,3
  constant.
- `d4_bits` (`mod.rs:148`) does use a real `w[2]`/`w[3]` mix, so its key is genuinely 4-word —
  but in the default `iso_max_avail = 7` regime the deep nodes are graph keys, and D4 is only
  the shallow `pc > 7` minority.

So for the dominant key family, words 2 and 3 fold the **same two constants on every single node**
— ~half the hash's mul-xor work is recomputing a fixed value.

**Shrunk representation:** the iso path already knows the key is `graph_bits(h)` from a single
`u64 h`. Hash `h` (and the one derived word) **directly** — e.g. a `hash_graph_key(h) -> (route,
fp)` that mixes the two live words plus a fold of the two compile-time constants (precomputable to
a single constant addend), skipping the two dead rounds. The TT only needs a well-distributed
`(route, fp)`; nothing requires routing through a 256-bit `Bits` first.

**Win:** roughly halves the per-node key-hash arithmetic on the hot iso path (8→~4 mul, 8→~4
shift-xor). The search is latency-bound, but this is *frontend / ALU* work on the always-run path
between TT probes — exactly the kind the project's discipline says to keep out of the hot loop,
and it overlaps the DRAM stall imperfectly. Channel-Fermi: at ~30 M/s and ~4 saved mul/node this
is ~120 M mul/s of ALU freed — small but real, and it composes with #1/#3 (which remove the `Bits`
the hash currently consumes).

**Unpack cost:** a second hash entry point (or a `const N_LIVE_WORDS` generic on `hash128`). Must
prove the new `(route, fp)` distribution is at least as good — same routing entropy, same ~2^-55
fingerprint collision rate. Since words 2,3 were constants they contributed *zero* discrimination
between distinct iso keys anyway, so dropping them cannot worsen the fingerprint.

**Correctness/gate:** the hash must stay deterministic and well-mixed; bump `TT_HASH_ID` if the
on-disk fingerprint changes (it will). Gate-relevant only via the verdict + re-exp; an equally-
mixing hash keeps both. `solve 12 iso-flat --distinct` exact count is hash-independent (it counts
canonical keys, not slots), so it's a clean check that no merge moved.

**Cheapest experiment:** add `hash_graph(h: u64) -> (u64,u64)` mixing only the two live words,
call it from `graph_key`/`iso_node_key` sites; interleaved A/B at n=14. If the napkin (~half the
hash) doesn't show, the hash wasn't on the critical path — instructive negative either way.

---

## 3. Iso-band keys plumb a full 32 B `Bits` where an 8 B hash is the real key  — MEDIUM

**Current:** the in-band recursion threads `key: Bits` (32 B) plus `route, fp` (16 B) down every
frame (`wins_tiny`, `wins_graph`, `expand_graph`, `graph_key`). In production the `Bits` is only
ever turned back into `(route, fp)` by `hash128` and then discarded — see #1 (it's never read in
`tt_get_h`/`tt_put_h` when `COUNT = false`). The `Bits` exists so the `COUNT` path can fold the
canonical key into the HLL and so `d4_bits`/`graph_bits` share one `Bits` namespace.

**Shrunk representation:** carry the **8-byte `h: u64`** (the graph-iso key) + its `(route, fp)`
in the iso tail, and reconstruct `graph_bits(h)` only on the `COUNT` arm where the HLL needs it.
This removes 32 B of per-frame argument traffic from `wins_tiny`/`wins_graph`/`expand_graph` and
is the enabling refactor for both #1 (kids array) and #2 (direct hash).

**Win:** ~32 B less stack/arg traffic per in-band frame, across the deepest recursion. Composes
with #1/#2 rather than adding on top.

**Unpack cost:** moderate plumbing churn across the iso-tail functions; the `COUNT` arm must
rebuild the `Bits`. Bigger diff than #1/#2 alone, which is why it's medium not strong — but #1
and #2 each deliver most of their value standalone, so this is the "do it properly" version.

**Correctness/gate:** identical to #1 — production never read the `Bits`; `--distinct` rebuilds
it. Same gate checks.

---

## 4. `PnSlot` = 48 B with a full 4-word key  — LOW (cold path only)

**Current** (`tt.rs:984`):
```rust
struct PnSlot { key: [u64; WORDS], phi: u32, delta: u32, used: u8 }  // 48 B, align 8
```
`key: [u64;4]` = 32 B, `phi`+`delta` = 8 B, `used: u8` + 7 B pad = 8 B → **48 B** measured.
`PnTt` is the df-pn proof-number table, **explicitly a tiny-board experiment, not under memory
pressure** (`tt.rs:976` doc; CLAUDE.md lists df-pn as a documented negative). The slot keeps the
**full 256-bit key** (not a fingerprint), so collisions are exact — unlike `QueensTt`'s 8-byte
fingerprint slot.

**Shrunk representation:** two options. (a) Fold `used` into `phi` (a sentinel `phi==u32::MAX`
already can't occur for a live proof number) → 40 B, no pad. (b) Adopt the `QueensTt` fingerprint
model — `(used:1, fp:55, phi, delta)` packed → a 16 B slot (3× more entries per byte). Option (b)
matches the project's own `Slot` discipline.

**Win:** 48→40 B (−17%) trivially, or 48→16 B (−67%) with the fingerprint rework — but only on a
**cold, parked experimental path**. No effect on the n=16 line.

**Correctness/gate:** `pn` is gate-checked at n≤6 (`solver_lineage_agrees`, `pn` arm). Option (a)
needs the `phi==MAX` sentinel to be unreachable for live entries; option (b) weakens exact-collision
to ~2^-55-wrong (acceptable, same as the main TT). Low priority because it's off the hot line.

---

## 5. `att: [Bits;8]` — 7 of 8 orientations are dead in the iso tail  — PARK

**Current** (`incremental.rs:98`, used by iso-flat): `att[sq] : [Bits;8]` = **256 B/square**,
table = 64 KiB at n=16 (L1/L2-resident, built once). `att[sq][t]` = the move's attack mask in
orientation `t`. The **D4 path** (`child_orient`, `wins_inc` `pc > iso_max_avail` arm) needs all
8. But the **iso tail** (`wins_tiny`/`enter_graph`/`w8_get`/`par` terminal test) only ever reads
`att08(att, sq)` = `att[sq][0]` — the identity orientation (`iso_flat.rs:123,313,838,860,965,1175`).

**Observation, not a clean shrink:** at the default `iso_max_avail = 7` the deep nodes are all in
the iso tail and touch only `[0]`, so 7/8 of each 256 B record (224 B) is loaded-around but never
used there. A *second* identity-only table `att0: Box<[Bits]>` (32 B/sq, 8 KiB at n=16) read by
the iso tail would make those loads 32 B-strided and fully L1-resident, leaving the 64 KiB
`[Bits;8]` table for the shallow D4 nodes only.

**Why park:** the 64 KiB table is already L1/L2-resident and the access pattern is sequential-ish;
the win is a denser line for the iso tail's `att[sq][0]` loads, not a capacity saving. Likely
sub-noise given the table already fits L2, and it adds a second table + a build. Measure only if a
TMA trace shows L1d pressure from `att` in the iso tail. Listed for completeness — it's the one
place a `[Bits;8]` carries dead words for the *target* regime.

---

## 6 & 7. Already minimal — documented so they aren't re-litigated

- **`TinyGraph { adj:[u8;8], closed:[u8;8] }`** = **16 B, align 1** (measured) — two-per-cache-
  line, value-tight (`u8` masks over ≤8 local vertices). Compliant with hot-struct item 5. Nothing
  to shrink. (`solve_local`'s `[i8;128]` memo = 128 B = exactly two lines, indexed by the 7-bit
  alive mask; minimal.)
- **`Slot`** = one `u64`, `{used:1, val:8, fp:55}` (`tt.rs:101`). The `val` byte only needs ~1 bit
  (win/loss) or ≤4 bits (nimber < 16), so 4–7 bits are "wasted" — **but they cannot be reclaimed
  for cache**: the slot is already the minimum addressable atomic (one `u64`), and widening the
  fingerprint to 58–59 bits buys negligible collision margin (already 2^-55). A `const _` size
  assert (`size_of::<Slot>()==8`) guards it. Clean. (The flat `Box<[AtomicU64]>` is 16 GB at n=16
  — that's a *count* problem, BuRR/windowing territory, not a per-record width problem.)
- **`Bits = [u64;4]`** — all 4 words live at n=16 (256-bit board); can't shrink for the target n.
  (`d4_bits` already exploits that the *key* needs <256 bits even though the board doesn't — but
  the board `Bits` itself is fully used.)

---

## Recommendation

Land **#1 and #2** — both are mechanical, gate-clean (verdict and `--distinct` unchanged), and sit
on the per-node iso path the default solver lives in. #1 removes the single fattest hot-path stack
object (a 448 B array carrying a dead 32 B `Bits` per child); #2 halves the key-hash ALU work on
the dominant key family. **#3** is the clean refactor that makes #1/#2 fall out naturally — do it
if touching the iso tail anyway. **#4** is a trivial cold-path tidy (no n=16 effect). **#5** is
park-and-measure (no capacity win, possible L1-density win only if a trace flags it). **#6/#7** are
already minimal — recorded so they aren't re-examined.

Per the perf discipline: napkin says #1/#2 are small (latency-bound node), so interleaved A/B at
n=14 decides; keep only if each pulls its weight, else record as an instructive negative. Neither
changes the validation gates (`solver_lineage_agrees`, `solve 12 iso-flat --distinct = 1,060,823`,
n=14 re-exp ≈ 1.0×) because the merge/key partition is untouched — only the *representation* of the
already-computed key narrows.
