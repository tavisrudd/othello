# n=18 migration change-map — branch `queens-n18`

## STATUS (2026-06-23): representation migration COMPILES (cargo check + `make release` znver5, 0 errors)

Done & building: **Foundation** (WORDS 4→6, MAX_N 16→18, MAXPC/TT_MAXPC→MAXV+1, MAXV_POW2),
**correctness** (d4_bits 6-word bijection, graph_bits/comp_nimber_bits, adj_row_pext+cpre 6-word),
**S1** (every u8→u16 square/move index — compiler-cascaded to clean), **S2** (all `& (MAXV-1)` masks
→ `& (MAXV_POW2-1)` + arrays sized MAXV_POW2; **byte-identical at n≤16** since MAXV_POW2==MAXV==256),
**DISTINCT_POSITIONS** extended to n=18. **NOT YET RUN** (per "no run yet").

Remaining: **(1) validation gates** — must run `solver_lineage_agrees` + `solve 12/14 iso-flat
--distinct` to confirm the d4_bits rewrite + u16 widening preserved n≤16 (n=12 exact 1,060,823 is the
key check; reasoned-safe but unrun). **(2) Phase 2** — dense-K ceiling/code-width (perf, not
correctness: n=18 runs correct-but-slower without it). Everything below is the original map.

## Tooling TODO (next build — NOT the running solve)

- **Live TT hit-rate in `QUEENS_TS_FILE`.** Expose a running `(gets, hits)` pair from the solver
  (per-worker probe counters already exist under telem/M_COLD), have the watcher sample + emit
  `"gets":N,"hits":M` in each JSON tick. Then **hit-rate over time = Δhits/Δgets per tick** — no
  `--distinct`/HLL, ~zero overhead (the `--distinct` HLL path is too heavy to leave on for a real
  run). Optional: per-pc bands for the cold-fraction *curve* over time. Motivation: the first n=18
  run (2026-06-23) was lean, so hit-rate-over-time wasn't observable live — only the end-of-run
  M_COLD per-pc cold-fraction. A live curve would show the **DRAM-latency-bound deep-tail** entry
  directly (cores stop saturating as cold TT probes dominate — observed on this run by core util
  falling below 100% while throughput held ~8 M/s).
- **In-flight root count in `QUEENS_TS_FILE`.** The TS line carries `rd`/`rt` (roots done/total) but
  not how many roots are *currently being explored*. Add an atomic incremented on root-enter /
  decremented on root-exit (`QUEENS_ROOT_TIMING` already stamps those start/end points), sample it in
  the watcher, emit `"rif":K` per tick. ~2 atomic ops × 45 roots = negligible. This exposes the
  parallelism **shape** over time directly: `rif≈1` with ~24 nested workers = the sequential
  giant-root tail (what the first n=18 run showed — *inferred* from active-worker dips to 1, because
  `rif` wasn't captured); `rif≈24` would be balanced parallel-over-roots. Pairs with the per-worker
  `pw` deltas to separate **root-level** parallelism from **nested** parallelism — the exact split
  the Phase-3 parallelism lever needs to target.

---


Companion to `notes/proposal-2026-06-23-n18-feasibility.md`. Phase 1 (representation)
work. Edits were made **without compiling** (a bench was running on `main`), so this
file separates what's **done** from what the **compiler/gates must finish**, and flags
every **silent** site (compiles fine, computes wrong — the dangerous ones).

Build/validate when the box is free (worktree has its own `target/`, no contention):
`make release` then the gate: `solver_lineage_agrees` (n≤9) + `queens solve 12 iso-flat
--distinct` (exact **1,060,823**) + `queens solve 14 iso-flat --distinct` (≈29.2M,
re-exp ≈1.0×). n≤16 verdicts must still match; **n=18 has no oracle except Jenrich**, so
the silent sites below must be reasoned-correct, not just gate-passed (no gate < n=16
even sets words 4–5 or square indices > 255).

## DONE (this session, safe / correctness-critical)

- `queens/mod.rs`: `WORDS 4→6` (256→384 bit), `MAX_N 16→18`. `MAXV` follows (=324).
- `queens/solver/mod.rs` `graph_bits`: 4→6-word literal (lossless u64 expansion).
- `queens/solver/mod.rs` `d4_bits`: **rewritten to a strict bijection over all 6 words.**
  The old form folded `w3` into `w2` (lossy — tolerable at n≤16). For n=18 the mask spans
  6 words; dropping/merging any word silently aliases distinct positions → wrong verdicts.
  New form is invertible per word, so the only collisions are the downstream 55-bit fp.
  *Note:* this also changes the n=16 key encoding (now bijective vs. the old fold), so n=16
  is no longer byte-identical to `main` — but more correct (fewer aliases). n≤14 keys are
  unchanged (w3=0 there ⇒ old form was already bijective) → the n=12/n=14 gates still hold.
- `queens/solver/iso_flat.rs` `comp_nimber_bits`: 4→6-word literal (lossless).
- `queens/solver/iso_flat.rs` `MAXPC`: `257 → MAXV+1` (pc reaches n²=324 at the root;
  the per-pc taps index by `avail.popcount()` and would go out of bounds at 257).
- `queens/tt.rs` `TT_MAXPC`: `257 → MAXV+1` (same reason; segmented TT is non-default).

## TODO — SILENT sites (compile clean, compute wrong — do FIRST, reason each)

### S1. `u8` square/move indices → `u16` (overflow at square ≥ 256; n=18 has 0..323)
All of these store a **board-square or move index** in a `u8`. At n≤16 squares are 0..255
(fit u8 exactly); at n=18 they reach 323 → silent wraparound. `iso_flat.rs`:
- `483` `moves: Vec<u8>` (the `Node`/frame move list)
- `516` `avail_has8(.., sq: u8)`, `533` `att_for8(.., sq: u8)`, `539` `att08(.., sq: u8)`
- `549/556` `verts_of(.., &mut [u8])` + the `(w*64 + tz) as u8` cast
- `602, 1522, 1544, 1566, 1596, 1624, 1661, 1695, 1729, 1763, 1800` `verts = [0u8; K]`
  (these hold square indices, not the small K — element type must widen, length stays)
- `695` `filter_moves(buf: &mut [MaybeUninit<u8>; MAXV], pmoves: &[u8], ..)`
- `799/803` `order8: Box<[u8]>`, `order_rank: Box<[u8]>`
- `1003` `skip18_squares: Vec<u8>` (+ `5303`-ish `moves[idx] as u8` compare → `as u16`)
- `1830–1848` `order8`/`order_rank` builders: `sq as u8`, and **`rank[..] = r as u8`** —
  the rank VALUE is a position 0..n²=324 > 255, also overflows → `as u16`
- the `(0u64, 0u8)` keyed-move arrays near `2961` if the `u8` lane is a move index (verify)

**Leave as `u8` (NOT square indices):** `456–470` pass-phase consts; `507/508`
`adj/closed: [u8; MAXV_TINY]` (tiny ≤7-vertex LOCAL adjacency bitmasks); `1897+`
`const MODE: u8` mode tags; `2086` `mex` nimber (<16); `381/422` L0 val byte; `2411`
serialization byte buffer.

Cheapest robust approach: a `type Sq = u16;` alias for square/move indices and sweep the
above to it (keeps the intent legible and the next widening trivial).

### S2. Non-power-of-2 `MAXV` masks (n=18 MAXV=324 is not 2^k → `x & 323` corrupts)
`& (MAXV-1)` is used as a no-op bounds hint that only works when MAXV is a power of two
(256→0xFF). At n=18 `4 & 323 == 0`. `iso_flat.rs`:
- `3021` `count[(d as usize) & (MAXV - 1)]`  (also: size the `count` array accordingly)
- `3035` `let d = (dk as usize) & (MAXV - 1)`
- `3347` `degs[i & (MAXV - 1)]`
- `3459` `degs[i & (MAXV - 1)]`
Fix: introduce `const MAXV_MASK: usize = MAXV.next_power_of_two() - 1;` (=511 at n=18) and
use it; ensure any array indexed by the mask is sized `MAXV.next_power_of_two()`, not MAXV.

### S3. `adj_row_pext` + every `cpre` build (4→6 words; silent if an offset is wrong)
- `576` `fn adj_row_pext(row: Bits, a: &[u64; 4], cpre: [u32; 3])` → `a: &[u64; 6]`,
  `cpre: [u32; 5]`, body gains two more `_pext_u64(r[4],a[4])<<cpre[3] | _pext(r[5],a[5])<<cpre[4]`.
  (Return stays `u64`: a row is K bits, K≤dense_k≤~23.)
- Every cpre builder must extend `[c0,c1,c2]` → `[c0,c1,c2,c3,c4]` (cumulative
  `count_ones` through word 4): `iso_flat.rs` `605–608` (decompose_node) and the
  `wK_get` family at `1573, 1601, 1632, 1666, 1700, 1734, …` (w9..w16 + `get_dyn_wide`).
  The `adj_row_pext` signature change makes these **compiler-flag** at the call (arity),
  but the cumulative-sum body edit is **silent** if an index is miscounted — verify each.

## TODO — COMPILER-CAUGHT sites (type errors; safe to let the build surface)

- Any remaining `[u64; 4]` / 4-element `Bits([..])` literals (grep after WORDS=6; should
  be none left in the queens module after the edits above).
- `bin/queens.rs` `DISTINCT_POSITIONS: [u64; 17]` → size 19; add `[17]=0` (odd) and a
  `[18]` estimate (~1.4e12 = 9.2e9 × ~150, the proposal's central R). `1869`
  `DISTINCT_POSITIONS[q.n]` and `89` `.get(n)` then resolve. `MAX_TT_BITS=30` (8 GiB) is
  likely fine per the cold-tail analysis; override with `QUEENS_TT_BITS` and watch re-exp.

## TODO — Phase 2 (dense ceiling; design + measure, NOT mechanical)

Separate from representation. To preserve the node-collapse at n=18 the dense-K sweet
spot rises (~21–23, vs 17 at n=16). The labelled code is `K·(K-1)/2` bits:
- K≤20 → 3 words (current `get_dyn_wide`/`warm_wide`); **K=23 → 253 bits = 4 words**,
  K≤25 → 5 words. Extend the wide-code packing (the `(words[0] as u128)|…` sites ~`1649`+
  and `get_dyn_wide`) and raise the `dense_k` clamp (`new_dense`, currently `9..=20`).
- Then sweep K on n=14 + partial n=16 for the n=18 wall minimum. Too-high K work-conserves.

## Reminders

- ⚠️ **CORRECTION (2026-06-24): `graph.rs` was NOT change-free — it was the verdict bug.** Its
  tiny-graph / component-canon path stored **board-square indices in `u8`** (`tiny_edge_code`,
  `edge_bit`, `iso_key_tiny_table_pc`, `tiny_table_index`, `iso_key8_direct`, `tiny_comp_key`,
  `canon5/6_key`, `cert_hash_in`, `twin_vertices`, `IsoScratch.verts`). n≤16 squares are <256 (fit
  u8), so every gate passed; n≥17 squares >255 truncated → loss↔win flip. Fixed in `cddfc64`
  (square indices `u8`→`u16`). **Lesson: the S1 sweep must cover graph.rs, not just iso_flat.rs.**
  (One residual, NOT on the default `iso<=7` path: the WL canon's LOCAL-index arrays — `IsoScratch.order`,
  `cert_hash_in`'s `order` — stay `u8`, so a *WL-keyed* run on a >255-vertex component would still
  truncate. The default run uses `iso_max_avail=7` (components ≤7), so it's unaffected; widen these
  only if a `QUEENS_KEY=canon/fast` n=18 run is ever attempted.)
- `geom.rs` is fully parametric in `n` (Vec sym tables, `(r,c)=(s/n,s%n)`) — **no change** (verified:
  the n=18 subposition differential exercises its geometry and passes).
- `hash128` (tt.rs) iterates `key.0` — already WORDS-generic, **no change**.
- Per-node cost grows ~1.5× from 6-word Bits ops (the representation tax in the estimate).
- Run the **Phase-0 de-risk probe** (re-exp vs TT size on n=16) before committing to flat-TT
  vs. BuRR — it doesn't need any of the above and decides the store architecture.
