# Queens n=18 — umbrella

**Date**: 2026-06-23  ·  **Branch**: `queens-n18` (worktree `/home/tavis/src/othello-n18`, off main @ `18579e9`)

The single entry point for all n=18 work. n=16 is **SOLVED** (second player, ~23.4s, the iso-dense
default on main). n=18 is the next open even board — this umbrella tracks getting there.

**`go` / `@notes/handoffs/2026-06-23-queens-n18-umbrella.md go`** = read this, then resume from
*Next-session priorities*.

> **★ Branch state (2026-06-24, session --6) — backed up off the certified-run path.** The full
> verified/certified empty-board n=18 run needs more RAM than this 26 GB box has (the C2 retrograde
> driver is infeasible — see the C2-infeasibility banner below). So the C6 certify pipeline + `certify
> --after` work (commits `81e63ca`, `928a478`) is **parked, intact, on branch `queens-n18-certify`**,
> and **`queens-n18` (the active branch in worktree `/home/tavis/src/othello-n18`) is reset back to
> `a9de5dc`** = migration + the **u8 verdict-bug fix** (`cddfc64`) + the **wired BuRR ply_store**
> (`8d8bca6`/`c96dfd4`) + the **`count --by-pc/--reachable` sizing tools** (`a9de5dc`), still-DFS search.
> **Next direction = DFS + the BuRR store + the per-root TS telemetry** (the telemetry was always a TODO,
> never coded — spec lives in `notes/n18-migration-changemap.md`: live `(gets,hits)` hit-rate, `rif`
> roots-in-flight, `WIN_PROVED/SKIPPED/LOSS_PROVED` labels, live root display). Nothing was lost — the
> certify commits stay reachable via `queens-n18-certify`; the old HEAD was `928a478`.

## TL;DR state

- **Representation migration: DONE + validated on n≤16** (WORDS 4→6, MAX_N→18, u16 squares,
  d4_bits 6-word bijection, MAXV_POW2). Compiles znver5; 74 tests green; n=12 distinct = 1,060,823
  exact. **BUT the n=18-only code paths are not oracle-tested.**
- **Verdict bug: FIXED (2026-06-24, `cddfc64`).** Root cause = `graph.rs`'s tiny/canon path stored
  board squares in `u8` (the migration's S1 widening missed graph.rs); at n≥17 squares >255 truncate
  → wrong attack rows → loss↔win flip. n≤16 couldn't catch it (max square 255 fits u8). Widened
  square indices `u8`→`u16`; found by a new n=18 subposition differential vs the `memo`/`naive` oracle
  (caught it at pc=3); added a runtime PV-parity guard. Gates green (n=12 exact 1,060,823, n=14 1.03×).
  **The kernel is now correct — but n=18's true verdict still needs the (memory-bound) Phase-C run.**
- **Memory-bind: CONFIRMED.** 261 B nodes / 8h15m / **TT 100% full / 99.7% cold** → heavy
  re-expansion. The flat TT cannot hold n=18 on this box ⇒ **BuRR is the path.**
- **BuRR Phase-3b: ⛔ the central plan (C2) is MEASURED-INFEASIBLE (2026-06-24).** The value-only
  ply-windowed *driver* must run **retrograde/breadth-first** (no values to prune with forward), so it
  enumerates the **full reachable set**, not the α-β proof DAG — measured **42×** bigger at n=12
  (44.9 M vs 1.06 M) and exploding with n (`count --reachable`). So value-only's density win is swamped;
  **both BuRR modes are now ruled out for a single 26 GB box** (Path A membership ~300 GB; Path B needs
  the 42×+ enumeration). The store layer (C1) is sound and kept; **n=18 now needs the cluster (Phase D),
  a bigger-RAM box, or a working-set-shrinking breakthrough** — a strategy decision (see the design doc
  banner). NOT a declared floor — the open levers are real.

## Document map

| doc | what |
|-----|------|
| `proposal-2026-06-23-n18-feasibility.md` (on main, `18579e9`) | the original go/no-go: runtime, limiting factors, flat-TT-vs-BuRR, the de-risk probe |
| `handoffs/2026-06-23-n18-migration-verdict-bug.md` | **the migration details + the verdict bug** (suspects, fix plan) + the run data/M_COLD |
| `n18-migration-changemap.md` | the code-level change map (every WORDS/u16/MAXV_POW2 site) + the TS-file telemetry TODOs |
| `2026-06-23-burr-backed-iso-dense-design.md` | the BuRR Phase-3b architecture (ply-windowed value-only) + the cluster/TDS + 2.5 GbE analysis |
| `2026-06-23-n18-work-plan.md` | **the sequenced forward plan**: bug fix → telemetry/tooling → BuRR build → cluster |

## The shape of the problem (what we learned)

- n=16 (second player) needed the **full 45-root sweep** (all roots proven losing). n=18, IF first
  player, needs **one winning root** (existential) — which is why the buggy run searched only I9 and
  stopped at 1/45. **If n=18 is really second player** (likely), the real proof is the all-roots-
  losing sweep — *far* bigger than the 261 B nodes the buggy run did.
- The wall is **one giant root** with deep internal parallelism (no broad root parallelism), and the
  bottleneck is **cold near-frontier DRAM** (pc 18–23 ≈ 79% of all probes, ~all cold). Same geometry
  as n=16, ~3 orders of magnitude larger.
- The growth came in **much** higher than estimated: R(18) ≈ 849× nodes (vs central 150×) — though a
  chunk of that 849× is re-expansion from the saturated TT, not true tree growth.

## Next-session priorities — end-to-end goal: a launched, instrumented, resumable n=18 run

Full detail + acceptance in `2026-06-23-n18-work-plan.md` (the user's explicit directive is its
"★ Next-session directive" block). In order:

1. ~~**Fix the verdict bug**~~ ✅ DONE (`cddfc64`): graph.rs square-index `u8`→`u16`; differential
   test + runtime PV-parity guard; gates green. (Was: a graph.rs truncation the migration missed.)
2. **Wire up BuRR _with snapshotting + certification_** — `ply_store.rs` + the ply-windowed driver;
   persist the value-only per-ply segments to disk (resumable — the flat-TT iso-dense couldn't),
   **dump the RAW PV-trace** (captured during search, not the final report), and **dump a CERTIFICATE**
   — enough data for a *separate, independent* checker (game rules only) to validate the verdict
   (the value-DAG/strategy subtree; the PV alone is NOT a proof — the bug proved that). Validate n≤16.
   - ✅ **C1 DONE** (`8d8bca6`): store wired + value-only soundness de-risked (single-layer cliff
     ≈0.92 → `DEFAULT_LOAD=0.90`; hybrid exact/ribbon since small ribbons can't single-layer;
     step-down guarantees single-layer). See the BuRR design doc's "C1 DONE" block.
   - **→ NEXT (C2, the big lift): the ply-windowed BFS driver** (DFS→ply-batched + explicit DDD),
     new solver `iso-dense-ply`, validated vs the exact gates (n=12 = 1,060,823, lineage, n=14).
     Then C4 snapshot/resume, C5 raw-PV-in-snapshot, C6 certificate + independent checker.
3. **Add ALL telemetry incl. live root display** — TS `(gets,hits)` hit-rate + `rif`; **live
   in-flight roots in the TTY bar**; root-timing reporting fix; `count --by-ply` (sizes the C2
   frontier buffer — per **queen-count/ply**, the sound window; pc is the cheap proxy).
4. **Launch the run in a tmux pane** capturing telemetry like the first run + snapshotting + certificate
   dump, then **run the independent checker** — *a verdict we can't certify, we don't claim* (Phase E).
   **User-gated big gate** (hours-to-days of compute; a second-player sweep is ≫ the buggy run's 8 h).
5. **(future) cluster** — TDS over 2.5 GbE for n≥20.

## Handoff Note — 2026-06-24 (BuRR-backed iso-dense build)

**Refuted the prior "single-box n=18 infeasible / needs a cluster" conclusion by building +
measuring the design those sessions wrote off without running it** — DFS + an eviction-free
BuRR store *under the fast iso-dense kernel*. Post-mortem on how that estimate ossified:
`notes/2026-06-24-reflections.md`. Landed on `queens-n18` @ `3d4d8f6`:

- **`iso-dense-burr`** — the fast iso-dense kernel (all M_ORD_W levers: getK/W_K collapse,
  dynamic ordering + counting-sort, ETC) with its flat `QueensTt` swapped for the eviction-free
  `BurrStore`. The store is a resolved-once runtime `Option` field on `IsoFlat`, orthogonal to
  MODE (like `assoc`/`segment`); every TT touch-point routed to it; `skip18`/`warm_restart` off;
  the flat-TT `iso-dense` stays the byte-identical control. **[measured]** gates green (lineage
  n≤9, n=12 distinct **1,060,823** exact, verdict **second** on n=10/12/14).
- **Huge-paged BuRR ribbon segments** (`huge_boxed_u64`, `MADV_COLLAPSE`, like the TT; the
  memtable was already a huge-paged `QueensTt`).
- **BuRR key telemetry in the TS dump** (`keys`/`segb`/`frz`/`full` per tick = the live
  re-expansion trajectory). **[verified]** backward-compatible (omitted for flat-TT solvers).

**Findings (provenance-tagged):**
- **[measured]** Profile: getK collapse works — store probes **31%→6.6%** vs old iso-burr;
  getK-evaluator-bound (the iso-dense profile shape), store no longer the bottleneck; IPC
  1.0→1.2. The win is *fewer re-explored nodes* (eviction-free), at slightly lower nodes/sec —
  not an M/s gain. Yesterday's 261 B-node flat-TT run was eviction-bound (99.7% cold = repeat
  visits), not distinct work.
- **[measured]** fp audit (`notes/`-worthy, in task #9 output): **`fp=44` is NOT collision-safe
  for a *certified* run** — E[silent wrong-value] ≈ 0.02–0.17 over the run ⇒ **raise
  `QUEENS_BURR_FP` to 54**. The certificate must key on the full 384-bit canonical key (the u64
  `archive_key` has a birthday floor fp can't fix; the independent `check_cert.py` is the safety
  net). Int-widths otherwise safe — the u8 square-index class is gone.
- **[measured → FIXED `f99d56d`]** Freeze pipeline stalled at n=18: the ~40M-key ribbon segment
  build took ~23 s and the `freezing` flag blocked further freezes ⇒ ~1 freeze / 35 s ⇒ the store
  degenerated into a single evicting 67M-slot memtable. Cause: the partition phase was
  single-threaded and did two random Bloom inserts/key (incl. into the multi-GB shared prefilter).
  **Fix:** hoist the Bloom inserts into the parallel per-shard build (`AtomicU64` words ⇒ `fetch_or`
  is race-safe; no false negatives ⇒ sound). **~4× throughput** — first freeze t≈28s→t≈11s, 4
  freezes/35 s vs 1; pipeline now ~keeps pace. (Ruled out core-starvation + the Task-1 `MADV_COLLAPSE`.)
  Residual headroom: the serial scan + smaller/more-frequent freezes if more margin is needed.
- **[measured]** The in-RAM store retains only ~2.2–2.5 B of ~10–18 B distinct at a 16–18 GB cap
  on this 26 GB box (live RSS climbed to the ~20.5 GB cap on root 0 alone) ⇒ **doesn't fit RAM ⇒
  the disk-DDD rung (Task 7) is the path**, not in-RAM.

**★ NEXT SESSION starts here — Task 7: disk-segment DDD + snapshot.** The in-RAM store can't hold
n=18 (caps at ~2.2–2.5 B of ~10–18 B distinct), so persist the frozen immutable segments to
`/tmp/persistent/tavis` (ZFS, 1.4 TB), keep the per-segment Blooms resident, read a segment from
disk only on a Bloom-admit. The store is already append-only segments + Blooms (the right shape),
and the freeze pipeline that *writes* them now keeps up (Task 11) — so this is unblocked. Same
persistence IS the snapshot/resume (segments + cursor + PV). Then: Task 5/6 PV + cert dumps (cert
keys on the full 384-bit canonical key, `QUEENS_BURR_FP=54`) → Task 10 three adversarial review
rounds → Task 8 launch. Parked certify pipeline on branch `queens-n18-certify`;
`scripts/check_cert.py` is the independent checker to reuse.

**Code state (`queens-n18` @ `f99d56d`):** iso-dense-burr built + validated (gates green), store
huge-paged, key telemetry wired + verified, freeze pipeline parallelized. **Banked this session:**
`3d4d8f6` (BuRR-backed iso-dense + huge-page store + key telemetry), `f99d56d` (freeze
parallelization); docs on `main` `00f5238` + this update. Launch knobs decided: `QUEENS_BURR_FP=54`
(audit), `QUEENS_BURR_CAP_GB`≈16–18. **Pending tuning (non-blocking):** the `keys` telemetry
overcounts in the evicting regime (`fill` = inserts, not occupancy) — report occupancy; the burr
footer prints the placeholder "TT 0.00 GB" (surface `store.summary()`); `pw[]` per-worker is zeros
for burr (reads the placeholder TT).

## Handoff Note — session 2026-06-24--5 (id f8bdada0-eac0-4a5f-a117-d9b8dc59584f)
**Phase A (verdict bug) DONE + Phase C1 (store) DONE — two clean commits on `queens-n18`.**
- **`cddfc64` — fixed the verdict bug.** Root cause: `graph.rs`'s tiny/canon path stored board-square
  indices in `u8` (the migration's S1 widening swept iso_flat.rs but **missed graph.rs**); at n≥17
  squares >255 truncate → wrong attack rows → **loss↔win flip**. n≤16 (max square 255) couldn't catch
  it. Widened square indices `u8`→`u16`. Found by a new **n=18 subposition differential** vs the
  `memo`/`naive` oracle (`n18_subposition_values_match_oracle`, caught it at pc=3); added a **runtime
  PV-parity guard** on the solve path. Gates green: full suite, n=12 exact 1,060,823, n=14 1.03×.
  **The kernel is now correct** — n=18's true verdict still needs the (memory-bound) Phase-C run.
- **`8d8bca6`/`c96dfd4` — Phase C1.** Wired + de-risked `ply_store.rs` (see the BuRR design doc's
  "C1 DONE" block): `fp=0` multi-layer is unsound, the single-layer cliff is ≈0.92 (→ `DEFAULT_LOAD
  =0.90`), small ribbons can't single-layer → **hybrid exact/ribbon store** with a step-down
  single-layer guarantee. Tests + clippy green.
- **`a9de5dc` — `count --by-pc` / `--reachable` sizing tools, which KILLED C2.** Built the design's
  "size before you build" taps. `--reachable` (forward BFS, `Queens::reachable_profile`) vs the α-β
  working set: **n=10 5.87×, n=12 42.31×** — the retrograde ply-windowed BFS stores the full reachable
  set, not the proof DAG, and the ratio explodes. **C2 is infeasible; both BuRR modes are dead for a
  single 26 GB box.** (Caught before the multi-session driver build — the discipline paid off.)
- **`81e63ca` — ★ C6: the independent verdict-certification pipeline, BUILT + PROVEN.** `queens
  certify <n> <out>` dumps the exact D4-canonical value table; **`scripts/check_cert.py`** re-derives
  the verdict using ONLY game rules + its own from-scratch D4 canon (zero solver code — so a
  search/canon bug can't fool it), checking the Node-Kayles recurrence + loser-node completeness at
  every position. **Demonstrated: n=8 first, n=10 second, n=12 second (1,060,749 positions, beyond
  naive) all CERTIFIED; fault injection (flipped verdict / corrupted value) both REJECTED.**
- **★★ COMPLETE + INDEPENDENTLY-VERIFIED n=18 RUNS (of real positions).** `certify <n> <out> --after
  <opening moves>` solves + certifies any n=18 *position* (a real game continuation), which fits and
  completes where the empty board cannot. The full pipeline — **execute a complete n=18 search →
  generate a certificate → independently verify with `check_cert.py`** — now runs end-to-end on
  genuine n=18 geometry (high squares / words 4–5, the bug's home). Verified n=18 results:
  - after `A1 C2 E3 G4 I5 K6 M7 O8 Q9` (41 avail) → **player-to-move WINS**, 3,996 positions, CERTIFIED;
    fault-injected verdict REJECTED.
  - after `A1 C2 E3 G4 I5 K6` (87 avail) → player-to-move WINS, 280,283 positions, CERTIFIED.
  - after `A1 C2 E3 G4 I5` (114 avail) → **player-to-move LOSES** (opponent wins), 9,303,023 positions
    (solver result; too large for the CPython checker in a sitting — a Rust checker port is the n≥14
    full-board scaling step).
  The **empty-board n=18 verdict** is the only piece still gated — it needs the working set in RAM
  (~80–145 GB; box has 26 GB), confirmed by a real 1.6 B-node run (0/45 roots). The solver and the
  verifier are proven correct on n=18; the full-board *search* awaits adequate RAM or a cluster.
- **Docs (this session, on main, uncommitted→commit at close):** verdict-bug RESOLVED block; changemap
  graph.rs correction; this note; BuRR design C1 block **+ the ⛔ C2-infeasibility banner**.
- **★ NEXT = a STRATEGY decision (user):** n=18's ~50 B working set doesn't fit this box at any
  correctness-preserving rep, and the value-only escape needs the 42×+ retrograde enumeration. Options:
  **(1) cluster (Phase D — TDS, needs the hardware + build); (2) a bigger-RAM box (~512 GB holds the
  ~300–400 GB membership store); (3) a working-set-shrinking idea** (iso-key merge / component-nimber —
  lit-triaged weak); **(4) accept multi-week single-box re-expansion thrash** (risky). The autonomous
  build levers (C2/driver) are exhausted — this is a hardware/research call, not more single-box code.

## Handoff Note — session 2026-06-23--4 (id a0d2a411-5ca9-4d70-b1d8-e3d3c7bd89a0)
Created the umbrella + the three threads (migration/verdict-bug, BuRR design, work-plan) + the
changemap + the `ply_store.rs` scaffold, all on `queens-n18`. Migration validated n≤16; first n=18
run completed but the verdict is a documented bug. Memory-bind confirmed ⇒ BuRR vindicated. Next:
fix the bug, then the gated BuRR build.
