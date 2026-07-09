# Evaluate RocksDB (vs the custom BuRR store) for the n=18 disk-spill regime

**Date**: 2026-06-24
**Created by**: session 2026-06-24--9 (`c38cce51-4c5e-4273-9c35-2287a76c57c5`)
**Purpose**: Test whether a mature embedded LSM (RocksDB) beats the hand-rolled BuRR
disk-DDD store at n=18 by eliminating the **O(S) per-probe segment-Bloom walk** — the
suspected dominating cost — and bringing async I/O + a block cache for free.

---

## Context

The n=18 Non-Attacking-Queens solve doesn't fit RAM on the dev box (26 GB) — the working
set is ~36 GB now → ~135 GB at the full ~10–18 B distinct positions. The current solution
(`iso-dense-burr`) spills to disk via a **custom log-structured BuRR store** (`src/queens/store.rs`):
a small memtable freezes into immutable sharded-ribbon segments, each with a resident
membership Bloom; ribbons live on the ZFS pool, mmap'd/pread.

**The problem (user's hypothesis, this task's premise):** a probe walks **all S segments'
Blooms** (a key lives in ≤1 segment; the rest are false positives) — an **O(S) walk that
compounds**: the shared prefilter is under-sized (`bloom_bytes_env = 0.2 × cap` =
`store.rs:~530` → ~1.6 bits/key at the 16 GB cap → ~95% false-positive at the cap), so most
gets fall into the full S-segment walk, and **S grows to ~300–500** over a run. The Bloom
analysis (session --9) confirmed the walk is O(S) and the dominant on-CPU store cost (~30%
`Bloom::maybe_contains` in the profile before the pread fix).

**Why RocksDB might fix it:** a leveled/sorted LSM routes a point lookup to **exactly one
SSTable by key-range** (manifest fence-keys) → **no O(S) walk**, plus mature async I/O +
a block cache. This task tests whether that wins in the disk-spill regime.

**What's already been tried (session --9, don't repeat):** pread instead of mmap (killed the
108K/s major-fault storm, fixed ARC miss 88%→24%) — KEPT, it's the baseline. Single-box
io_uring (within-walk batch = wash; async frontier prefetch = ~20–40% **regression**) —
MEASURED-DEAD, gated off (`QUEENS_PF_URING`). The session conclusion was **"capacity is the
wall"**: a ~256–512 GB box fits the working set → a flat TT with no eviction, fast and
trustworthy (55-bit fingerprint = recompute-not-wrong).

## Scope

**The fork this task represents:** RocksDB is the *"make disk-spill fast on a small box"*
path — an **alternative to the capacity (big-RAM box) path**, not additive to it.
- **In scope:** does a mature LSM beat the custom BuRR **in the disk-spill regime** (the
  26 GB box, or n≥20 beyond even a big-RAM box) by eliminating the O(S) walk?
- **Out of scope:** beating a big-RAM box. On a box that fits the working set in RAM the
  whole disk-spill question is moot (use the flat TT, no store backend at all). **Decide with
  the user first** whether to spend this vs just provisioning a ~256–512 GB box (see the n18
  umbrella's session --9 conclusion + the EC2 sizing — `r7a.8xlarge`/`16xlarge`).
- **Prototype-and-measure only** — a partial/sizing n=18 run to compare against the BuRR
  baseline, **not** a run to completion.

## Work Items

**A. Wire a `RocksStore` behind the existing store abstraction.**
- Add a `RocksStore` (new module, e.g. `src/queens/rocks_store.rs`) implementing the same
  surface `BurrStore` exposes (`get`/`put`/`prefetch`/`bump`/`drain*`/`report`/`summary`).
- Hook it into `IsoFlat` the way `BurrStore` is: a resolved-once `Option<...>` field, set
  by a new `IsoFlat::new_dense_rocks` (mirror `new_dense_burr`, `iso_flat.rs:~1422`), routed
  through `mtt_get`/`mtt_put`/`par_tt_get`/`par_tt_put`/`mtt_prefetch` (`iso_flat.rs:~2025–2156`).
  Add a CLI variant `iso-dense-rocks` in `src/queens/mod.rs` (~169–174, where `iso-dense-burr`
  dispatches).
- Key = the u64 `archive_key` (what BuRR routes on; `QueensTt::archive_key_hashed`) **or** the
  full 384-bit canonical key (`Bits`); value = 1–2 bits (win/loss/unknown). Decide which key
  — the u64 archive_key keeps RocksDB keys small but inherits the ~2⁻⁵⁴ birthday floor (fine
  for a non-certified exploratory run; a *certified* run wants the full key, like BuRR's cert).
- **Done:** `iso-dense-rocks` solves n≤14 with the right verdict.

**B. Tune RocksDB for point lookups of tiny values.**
- `rust-rocksdb` crate. Options to set: bloom-filter-per-SSTable (whole-key, ~10 bits/key),
  a sized block cache, `optimize_for_point_lookup` / no block-cache-for-index churn,
  compaction style (try **leveled** first; **universal** trades read-amp for less write-amp),
  compression off or zstd-fast (values are 1–2 bits — barely compress; keys are random),
  large write buffer + enough background compaction threads. Pin the DB dir to the ZFS pool
  (`/tmp/persistent/tavis/...`, the same 1.4 TB pool the BuRR segments use).
- **Done:** options documented in code with the rationale; a knob to A/B compaction style.

**C. MEASURE at n=18 on the 26 GB box (partial run) vs the BuRR baseline.**
- Baseline (recorded session --9, BuRR + pread): **~0.26 M/s, 95% iowait, 33K/56K pool IOPS,
  ARC miss ~24%, O(S) walk ~30% on-CPU.** Reuse the watch tooling.
- Compare: (1) **does the O(S) walk disappear?** (perf profile — `maybe_contains` gone),
  (2) per-probe latency / throughput / iowait / pool IOPS, (3) **write amplification** —
  RocksDB compaction re-writes data; watch pool *write* IOPS/bandwidth (could thrash the NVMe
  vs BuRR's append-only freezes), (4) resident footprint (block cache + index/filter blocks
  vs BuRR's ~15 GB Blooms — must stay within ~20 GB anon budget), (5) ARC interaction (RocksDB
  does its own block caching; ZFS ARC may double-buffer — same pread/mmap tension to check).
- **Done:** a provenance-tagged comparison table in the n18 umbrella handoff; a clear
  verdict on whether O(S)-elimination translates to throughput, and at what write-amp cost.

**D. Box hygiene / sizing caveats (carry over from --9).**
- Still disk-bound (working set ≫ RAM) — O(1) routing removes the *walk*, not the NVMe
  latency on the cold tail. Frame the expected win as "kill the O(S) walk + better I/O
  concurrency," not "make cold data warm."
- ZFS ARC cap, drop_caches, etc. per the umbrella's box-hygiene rules; the run is on the
  pool, so ARC competes (cap it).

## Codebase Reference

| What | Where |
|------|-------|
| BuRR store (the thing to replace/compare) | `src/queens/store.rs` (`BurrStore`, the O(S) walk in `get_inner`) |
| Ribbon/Archive/segment internals | `src/burr.rs` (`MappedArchive`, `prefetch_window`, `batch_pread`, `PrefetchRing`) |
| Store hookup into the solver | `src/queens/solver/iso_flat.rs` — `new_dense_burr` (~1422), `mtt_get`/`mtt_put`/`par_tt_*`/`mtt_prefetch` (~2025–2156) |
| CLI solver dispatch | `src/queens/mod.rs` (~169–174, `iso-dense-burr`) |
| archive_key / 128-bit hash | `QueensTt::hash128` (`src/queens/tt.rs:1001`), `archive_key_hashed` (`tt.rs:~1029`) |
| Disk-DDD auto-defaults (dir/fp/cap) | `src/queens/store.rs` (`is_disk_ddd`, `DISK_DDD_MIN_N=18`, ~440–530) |
| io_uring substrate (baseline/fallback) | `src/burr.rs` (`batch_pread`, `PrefetchRing`); gated `QUEENS_PF_URING` |

## Validation Gates (must hold — RocksDB is a store-backend swap, must be byte-identical)

- `solver_lineage_agrees` (every solver matches the memo-less `naive` verdict on n≤9).
- `queens solve 12 iso-flat --distinct` = **1,060,823** exact (kernel correctness).
- `iso-dense-rocks` verdict **second** on n=12 and n=14.
- **`iso-dense-rocks` vs `iso-dense-burr` byte-identical node count at n=14** with forced
  freezes (mirror session --9's `n=14 disk-off==on==2,823,498` gate: small `QUEENS_BURR_MEM_BITS`
  to force segments, single-thread `RAYON_NUM_THREADS=1`). A store backend must not change the
  node set or verdict.

## Principles / Constraints

- **Measure interleaved A/B; n=16/n=18 single runs lie** (±18% common-mode noise on this box).
  Compare RocksDB vs BuRR on the same binary/run conditions.
- **Use ecosystem crates properly** (`rust-rocksdb`) — no no-dep rationalization.
- **The win is O(S)-walk elimination + I/O concurrency, NOT cold-data-warming** — the run stays
  disk-bound at the cold tail. Be honest in the verdict; if O(S) was *not* actually dominating
  (it's masked by NVMe latency), say so and the answer is the capacity path.
- Record everything in the **n18 umbrella handoff** (`notes/handoffs/2026-06-23-queens-n18-umbrella.md`),
  not the auto-memory. Keep BuRR + the io_uring substrate as the comparison baseline + fallback.
- Branch off **`queens-n18`** (HEAD `7b55b6e` at this writing). Build via the Makefile
  (`target-cpu=znver5`), never bare cargo.

## Delegation

- **Can delegate to sub-agent?** Partially. The RocksDB integration + tuning is core hot-path
  work — do it in the main session (correctness-critical, the gates are the safety net).
  Lit/API research on `rust-rocksdb` point-lookup tuning can be an Opus sub-agent.
- **Model**: Opus for the integration + the measurement interpretation.
- **Notes**: Decide the fork with the user FIRST (RocksDB-on-small-box vs capacity/big-RAM-box)
  before investing — if they're provisioning a big-RAM box, this is moot.
