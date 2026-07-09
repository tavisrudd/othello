# Queens n=18 — migration, the first run, and a verdict bug to fix

**Date**: 2026-06-23
**Branch**: `queens-n18` (worktree `/home/tavis/src/othello-n18`, based on main @ `18579e9`)
**Status**: Migration validated on n≤16; first n=18 run completed but **produced an INCONSISTENT
verdict (a bug)**; BuRR-backed redesign scoped + gated. **Next session: fix the verdict bug first.**

Companions on this branch: `notes/proposal-2026-06-23-n18-feasibility.md` (committed on main),
`notes/n18-migration-changemap.md`, `notes/2026-06-23-burr-backed-iso-dense-design.md`.

---

## ✅ RESOLVED (2026-06-24, session --5) — the verdict bug is FIXED

**Root cause: `graph.rs`'s tiny-graph / component-canon path stored board-square indices in `u8`.**
The migration's S1 (u8→u16 square-index) sweep covered `iso_flat.rs` but **missed `graph.rs` entirely**
(the changemap's "Reminders" even asserted graph.rs needs no change). The truncating sites:
`tiny_edge_code`/`edge_bit` (the pc≤7 leaf **value** code-build), `iso_key_tiny_table_pc` /
`tiny_table_index` / `iso_key8_direct` (the pc≤7/8 **key**), and the cold comp-canon path
(`tiny_comp_key`, `canon5_key`, `canon6_key`, `cert_hash_in`, `twin_vertices`, `IsoScratch.verts`).
At n≤16 every square index is <256 (n=16 max = 255 ⇒ fits `u8` exactly), so **no gate could catch it**;
at n≥17 squares reach 323 and silently wrap (256→0, 257→1, …), reading the wrong attack rows → wrong
edge code → wrong W-table value → a **loss↔win flip**. Widened every square-index `u8`→`u16`.

**Found by a differential test** (`n18_subposition_values_match_oracle`, in `queens/mod.rs`): drives
thousands of arbitrary 18×18 *subpositions* whose available set spans the high words (4–5), checking
iso-dense/iso-flat against the `memo` oracle (raw-mask negamax+TT — uses none of the getK/dense/iso
paths) and the memo-less `naive` on tiny sets. It caught the flip at **pc=3** in milliseconds; now green.
Also added a **runtime PV-parity guard** on the solve path (refuses to let a verdict violating
"winner makes the last move" stand unflagged — the contract the n≤8 test couldn't reach at n=18).

**Validation:** full suite green (n≤16 byte-identical); n=12 distinct = **1,060,823 exact** (second,
even 8-move PV); n=14 ≈28.9M / re-exp 1.03× (second, even 10-move PV); guard silent on both.
Committed on `queens-n18` @ **`cddfc64`**. The original (now-historical) diagnosis is kept below.

**First CORRECT-geometry n=18 execution (measured, 2026-06-24, bounded sizing run).** 8 cores /
4 GB TT (`QUEENS_TT_BITS=29`) / 6-min cap, memory-safe (no OOM): **1.60 B nodes in 358 s ≈ 4.46 M/s**;
**`rt`=45 roots, `rd`=0 — not one root completed.** The 4 GB TT (≪ the working set) re-expands
catastrophically, so even the single elder-brother root 0 is hundreds of billions of nodes (the prior
buggy run did 261 B for ~1 root at 8 GB). A full 45-root second-player sweep on this box's max TT is
**weeks-to-months** — the memory wall is now confirmed by a real correct-geometry run, not extrapolation.
This is the data CLAUDE.md asks for ("size it with HLL/telemetry first"): the single-box n=18 run does
not complete in tractable time; it needs ~128 GB+ RAM (D4-verifiable) or a cluster.

> **NOTE on the likely verdict:** the kernel is now correct, so `first_player_wins(18)` will return
> the true value — but a full n=18 run is hours-to-days and memory-bound (needs Phase C). The "even-n
> streak" claim below is loose: per OEIS A344227 n=2,4,6,8 are **first**-player and only n=10,12 (then
> the project's n=14,16) are **second** — so n=18 second-player is a *reasonable bet, not certain*. The
> real verdict comes from the instrumented, certified Phase-C run, not from the streak.

## ⚠️ Historical — the original verdict-bug diagnosis (pre-fix)

The first-ever n=18 run printed **"first player wins"** with optimal line `I9 K8 G10 J11 H3 M7 N16
E4 P6 D12 O13 F2 L17 A5` (14 moves). **This was internally inconsistent and must not be trusted.**

- The codebase is **normal play, last-to-move-wins** (`mod.rs:5–7`), and asserts its own contract
  (`mod.rs:302–311`, `pv_is_consistent_with_the_winner`): **`first_wins ⟺ PV length is odd`** (the
  winner makes the last move). That test only runs n≤8, so it never fired at n=18.
- The n=18 PV was **verified valid + terminal** (14 mutually non-attacking queens, **zero** legal
  15th moves; free rows {1,14,15,18}, free cols {2,3,17,18}). 14 moves (even) ⟹ **player 2 made the
  last move** ⟹ under last-to-move-wins, that line is a **SECOND-player win**. A first-player win is
  impossible with an even-length terminal PV.
- The search is **existential** for a first-player win (correct insight, via ChatGPT): it searched
  **only I9 (sq 152)**, got "win", and stopped at `1/45` roots (the `0/45`-throughout mystery — the
  other 44 were *never searched*, not "finished in 0.0s"). So **I9 was mis-scored as a win when its
  own PV shows it's a loss** → the existential search short-circuited on a bad value → wrong verdict.

**Hypothesis:** a **loss→win value flip** in the **n=18-only code paths**, which no board ≤16
exercises (n=16 = 256 bits = words 0–3, squares <256, `MAXV_POW2 == MAXV`), so the green
n=12/n=14/lineage gates could not catch it. Suspects, in order:
1. `d4_bits` (solver/mod.rs) — the 6-word bijection; verify it never aliases two distinct 6-word
   keys (words 4–5 only ever set at n=18).
2. `u16` square widening — `verts_of`/`att08`/order tables for squares 256–323.
3. `MAXV_POW2` masks (iso_flat.rs counting sort) — the non-power-of-two fix; verify no-op for
   degrees up to 324.

**Likely truth:** n=18 is a **second-player win** (the even-n streak holds: n=4..16 all second; the
valid even-length terminal line points the same way). If so, we have **NOT** solved n=18 — the run
stopped early on a bug, and a real second-player proof is the *all-45-roots-losing* sweep, far
larger than the 261 B nodes this run did.

### ★ Refined diagnosis — the bug is probably NOT in the rep paths

Key insight: **the "even-board first-player-win via *search*" code path has NEVER run before n=18.**
Even boards ≤16 are all *second*-player (the search returns "no winning root"); odd boards are
first-player by the **O(1) mirror strategy** (`mod.rs:16`, no search). So the search's
*first-player-win* output for an even board — the existential stop, the verdict print, the PV trace —
is **first exercised at n=18**. That's a **shared-logic** path, untested for this case, and it
explains a *clean* verdict flip far better than a rep-path corruption (which would more likely have
broken the n=12 exact-distinct count). So weight the shared verdict/stop/PV logic at least as heavily
as the d4_bits/u16/MAXV_POW2 suspects.

ChatGPT's hypotheses (the likely failure surfaces), prioritized:
1. **Root-value polarity inverted in the final verdict print** — search correct, print flipped ⇒ real
   answer = **second player** (matches the even-n streak + the even-length terminal PV). *Most likely.*
2. **Early root-stop using the wrong polarity** — the existential stop fires on a loss as if a win ⇒
   stops at 1/45 and declares first-player. Also ⇒ real answer second.
3. **PV printer tracing a refutation line, not a winning line** — verdict right (first), PV wrong.
   Less likely given the PV is a clean valid terminal line consistent with a *second*-player win.
4. **"1/45 is a special run"** — *unlikely*; the env was a normal `solve 18 iso-dense` with no
   root-limiting. The `1/45` is the existential stop (one believed-winning root), not a config.

**ChatGPT's decisive check** ("what value is stored for the child after I9?") is the right idea but
**not post-hoc-doable** — the 8 GB TT is gone (iso-dense doesn't snapshot; *exactly why C4 snapshotting
matters*). The doable form: add the parity guard (below) + read `first_player_wins`
(`solver/mod.rs:65`) / the existential-stop / verdict-print / `principal_variation` polarity for the
even-board-first-player-win case; or a shallow depth-capped re-run with the guard armed.

### Fix plan (cheap — no 8 h rerun needed to find it)
1. **Runtime PV-parity guard** on the `solve` path (not just the n≤8 test): after the solve,
   `assert first_wins == (pv.len() % 2 == 1)` — panic/loud-warn on mismatch. Would have caught this
   at second 0 of the PV phase.
2. **Three targeted unit tests** (hit the suspects without a long run):
   - `d4_bits` is a strict bijection on random 6-word `Bits` (no two distinct inputs collide).
   - `verts_of`/`att08` round-trip for squares 256–323 (u16, no truncation).
   - `MAXV_POW2` mask is a no-op for all degrees 0..=324.
   One of these almost certainly fails → the bug.
3. Fix, re-run a **shallow / depth-capped** n=18 sanity probe (or `QUEENS_FAST=0`) before committing
   another 8 h. Then decide whether the real (likely second-player) n=18 is worth the full sweep.

---

## What landed this session (validated, on `queens-n18`, uncommitted until this commit)

**Representation migration — n≤16 verdict-/distinct-preserving, compiles (znver5), 74 tests green:**
- `WORDS 4→6` (256→384 bit), `MAX_N 16→18`, `MAXPC`/`TT_MAXPC → MAXV+1`, new `MAXV_POW2` const.
- `d4_bits` → strict 6-word **bijection** (was lossy fold; the high words n=18 needs). `graph_bits`/
  `comp_nimber_bits` → 6 words.
- `adj_row_pext` + all `cpre` builders → 6 words / `[u32;5]`.
- **S1** (silent): every `u8`→`u16` square/move index (att08/verts/order8/order_rank/moves/
  filter_moves/counting-sort/scheduler/skip18) — compiler-cascaded.
- **S2** (silent): all `& (MAXV-1)` masks → `& (MAXV_POW2-1)`, arrays sized `MAXV_POW2`
  (**byte-identical at n≤16**: `MAXV_POW2==MAXV==256` there).
- `DISTINCT_POSITIONS` extended to n=18.
- **Gates passed:** lineage (n≤9), n=12 distinct **= 1,060,823 exact**, n=14 ≈28.96 M / re-exp 1.03×,
  full suite 74 passed. **BUT none exercise the n=18-only paths** (the bug's hiding spot).

**First n=18 run (flat 8 GB TT) — data is good even though the verdict is buggy:**
- 261,138,982,627 nodes · **8h14m50s** search (8h15m11s e2e) · ~8.80 M/s · **TT 8.59 GB, 100% full**.
- R(18) ≈ **849×** (vs my central 150× / upper 250× estimate — way off; node count blew through).
- **Memory-bind CONFIRMED** (the M_COLD payoff, independent of the verdict bug): aggregate **99.7%
  cold**, deep-band tail 99.8% cold, TT 100% full → heavy re-expansion. **pc 18–23 ≈ 207 B probes ≈
  79% of all probes**, almost all cold → next perf target is the frontier boundary (a `get18`/W18 that
  cuts bookkeeping there). **BuRR (value-only ply-windowed) is vindicated.**
- Root-timing reporting fix (ChatGPT): distinguish `WIN_PROVED(I9)` / `SKIPPED×44` / `LOSS_PROVED:none`
  from "finished in 0.0s".

---

## BuRR-backed iso-dense (Phase 3b) — design DONE, build GATED

Decisions **locked** (see the design doc):
- **Path B = value-only, ply-windowed** (`fp_bits=0`, ~1.1 bit/key, ~7–12 GB for n=18's ~50–87 B
  distinct). The membership-carrying drop-in (`fp=44`, ~62 bit/key, ~300 GB) **does not fit** — dead
  as a fix. Value-only is sound only single-layer + membership-known-a-priori = ply-windowing
  (transpositions are strictly intra-ply).
- It's a **search restructure** (DFS → ply-batched breadth-first + explicit DDD + per-ply value-only
  freeze), **not** a store-swap. Keep the dense getK layer (the 14× node-collapse edge).
- **Gated on the n=18 run's M_COLD** — which we now HAVE (99.7% cold, memory-bind confirmed). So the
  gate is cleared; the next blocker is the verdict bug, then `count --by-ply` to confirm the widest
  ply fits RAM.
- Scaffold in place: **`src/queens/ply_store.rs`** (the per-ply value-only `PlyWindowStore`, reuses
  `burr::{Archive, ShardedArchive}`) — **DRAFT, not wired into `mod.rs`** (so the build is unaffected;
  wire + compile + unit-test next).

**Cluster scale-out (n≥20, future):** TDS (hash-partition positions, route-work-to-data) kills the
giant-root tail; gossip BuRR segments for k=2 fault-tolerance, not full replication. **2.5 GbE is
viable but dictates the design** — per-node msg rate ≈ (total msgs × bytes)/(single-box wall) ≈
~95–190 MB/s *if batched* (jumbo frames, hundreds of keys/packet), ~390 MB/s unbatched (blows it).
Demand is ~constant in N. Few fat nodes > many thin. Route, don't gossip-replicate. (In the design
doc's cluster section — add if not already; was discussed, may need folding in.)

---

## Next-session task order
1. **Fix the verdict bug** (parity guard + 3 unit tests → find the loss→win flip → fix → shallow
   n=18 re-check). Confirm whether n=18 is second-player (likely).
2. `count --by-ply` on n=14/16 → per-ply distinct distribution → confirm widest ply fits RAM.
3. Wire `ply_store.rs` into `mod.rs`, compile, unit-test `PlyWindowStore` (build/get round-trip,
   value-only collision rate).
4. Build the in-RAM ply-windowed driver (`iso-dense-ply`); validate vs exact gates; then n=18.

---

## Handoff Note — session 2026-06-23--4 (id a0d2a411-5ca9-4d70-b1d8-e3d3c7bd89a0)
- **Landed on main:** `18579e9` — n=18 feasibility proposal.
- **On `queens-n18` (this commit):** the rep migration (6 files), the changemap, the BuRR design, the
  `ply_store.rs` scaffold, and this handoff. Migration validated on n≤16 (74 tests green); the build
  is the validated one (`ply_store.rs` unwired).
- **Key finding:** the first n=18 run's "first player wins" is a **bug** (PV-parity inconsistency);
  the n=18-only code paths were never oracle-tested. Likely truth: second player (streak holds).
- **Measurements:** n=18 261 B nodes / 8h15m / TT 100% full / 99.7% cold ⇒ memory-bind confirmed ⇒
  BuRR vindicated. R(18) ≈ 849× (estimate was badly low). Bet (second player) — verdict bug makes it
  *probably right after all*, but the run can't confirm it.
- **Next:** fix the bug, then the gated BuRR ply-windowed build.
