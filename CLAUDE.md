# Othello + Non-Attacking Queens — project guide for Claude Code

Two crates share the repo: the Python `othello` package (root) and the Rust port +
Queens solver (`rust/`). Active work is in `rust/`; the live umbrella is the Queens
n=16 roadmap in `notes/handoffs/`.

## Current WIP
**DO NOT add details/history here. Pointers only** (details live in the handoff/proposal).

**Start here:** [Queens n=16 roadmap](notes/handoffs/2026-06-15-queens-memory-roadmap.md) — umbrella;
n=16 is **SOLVED** (second player). Progress + Lever backlog hold what's next.

**Active thread:** [iso-window](notes/handoffs/2026-06-18-iso-window.md) — the default solver, n=16
**SOLVED (second) in 2m44s** (under the 3-min goal). iso-flat's kernel + a complete dense **W8** table
(pc==8 tails resolved by one labelled-edge-code lookup, never re-expanded) over a **huge-page-collapsed**
flat TT (`MADV_COLLAPSE`, default-on ≥4 GB). The earlier "~36 M/s floor / 3m41s wall" was **wrong** —
measured on a memory-degraded box; clean box + W8 + huge pages broke it. (iso-flat handoff now
[closed/archived](notes/handoffs/done/2026-06-17-iso-flat-solver.md).)

**Current focus:** a **segmented TT variant** — `index(route, pc) = band_base[pc] + fastrange(route,
band_size[pc])`, keyed by popcount (pure function of the key ⇒ transposition-safe), to capture the
measured ~13% TLB-residency warm-M/s win *without* shrinking the table (smaller tables win it back on
eviction; capacity is not the binding constraint, per-probe latency is). **Keep the flat TT as the A/B
control.** Plan + Codex's windowed-dataflow design are in the iso-window handoff.

**Bigger levers (multi-session, decide with the user):** grouped-frontier `k=9..12` DDD (Codex's
pump→group→dense-solve→merge — the floor note's streaming-dedup lever, breaks DFS-residence); **BuRR
archive** (Chunk-4, eviction-free value-only ~1.1 bit/key — sound under windowing); **1 GB hugepages**
for the TT (zero TT TLB miss, needs boot-time reservation).

**Parked (negative):** branch `chunk3-depth-preferred-tt` — depth-preferred TT replacement, measured 3× worse; off main. Might be able to improve and fix.

**`go`** (or `@notes/handoffs/<name>.md go`) at session start = read that handoff and resume from its Progress / next steps.

## Intent-based mode (opt-in)

Default is collaborative: discuss approach, surface options, await approval. Activate
intent-based mode two ways:
- **Per-handoff (persists across sessions):** add `Mode: intent-based` under the
  `**Date**:` line of the handoff. Scopes to that work stream only.
- **Per-session (ad-hoc):** the single-word prompt `mi` — intent-based for the rest of
  the current session, without writing to any handoff.

When active, take low-stakes reversible calls without asking; state the action in one
line, then proceed unless interrupted (e.g. "Committing X. Reason: Y." / "Reading X to
confirm Y."). **Decide and proceed when ALL hold:** reversible; already permitted by an
existing CLAUDE.md rule or the handoff's plan; recommendation lopsided ≥80/20 with the
decision inputs visible in the conversation; no load-bearing downstream (the next step
doesn't change shape by which option is picked).

**Still ask, even with the flag on:** architecture / design choices that lock in future
work; **any revert, git-state change, or `git push`** (the global git rules stay
ask-first regardless of mode); new scope or a pivot off the handoff's lever sequence; a
real n=16 run (hours-to-days — size with HLL first); anything that would change a
CLAUDE.md rule or a validation gate.

## Short Commands
- `yc` = your call
- `mi` = intent-based mode for this session (see §Intent-based mode)

## Build / test / validate

- Build/test through the **Makefile in `rust/`**: `make release` / `make test` /
  `make clippy` / `make fmt` — never a bare `cargo build`. The Makefile injects
  `-C target-cpu=znver5 -C link-arg=-fuse-ld=mold`; a hand-rolled cargo build
  silently produces a non-znver5 binary and invalidates bench numbers. `cargo
  check`/`fmt`/`clippy`/`test` are fine for quick iteration. Wrap noisy builds in
  `~/.claude/bin/run-quiet "make …"`.
- **A change is not done until its validation gate passes:**
  - **Queens:** `solver_lineage_agrees` (every solver matches the memo-less `naive`
    verdict on n≤9) **and** a fresh `queens solve 12 iso-flat --distinct` (second-player
    win, exact distinct **1,060,823**) + `solve 14 iso-flat --distinct` (second, ≈49.3M,
    re-exp ≈ 1.0×). **Name `iso-flat` explicitly** — the default solver is now `iso-window`,
    which has no `--distinct` counter (its W8 table collapses pc==8 subtrees so its node
    count isn't comparable to the distinct set). A distinct-count change = lost
    transposition merges; a re-exp jump = under-sized table. TT/key changes must hold both.
    (n=12's re-exp is ~1.25× on the current branch — the deliberate labelled-≤7-key trade,
    not a regression; the invariant is the *exact* distinct count and n=14's ≈1.0×.)
  - **Othello:** the cross-engine value-equivalence tests (minimax / alphabeta /
    ordered / strong compute identical black-centred values) + the independent grid
    move/flip reference + the exact endgame solves (6 / −40 / 4). `strong+` /
    `strong++` deliberately change the value (strength match, not equivalence).
- A real **n=16 queens** run is the open problem and takes hours-to-days — don't fire
  one off to completion casually during a session; size it with HyperLogLog (`queens
  count`) and extrapolate first. (Completing it is the goal — just deliberately, with
  checkpoint/resume, not as a speculative command that burns the box for days.) Any
  verdict cross-checks against Jenrich (n=16 = second-player win).

## Performance discipline (the Rust hot paths)

The search is **TT / DRAM-latency-bound**, not compute- or parallelism-bound (queens
fact #5 in the roadmap; same conclusion for Othello in `rust/NOTES.md`). What has
held up across sessions:

- **NEVER claim we've reached "the floor" / a hard limit / that something is
  "unreachable" — that judgment is the user's alone.** Always keep pushing and
  reasoning from first principles; when you hit a wall, reason *through* it or find a
  way *around* it — don't declare it terminal. A "floor" conclusion is almost always an
  artifact of the measurement conditions or an untried lever, not a real bound. (Case in
  point: a prior session declared "~36 M/s floor, sub-50 unreachable, n=16 ~3m41s is the
  wall." All wrong — it was measured on a memory-degraded box, dismissed the W8 dense
  table on one confounded run, and never tried forcing huge pages. Cleaning the box +
  W8 + `MADV_COLLAPSE` took n=16 to **2m44s** the next session, and the *compute* floor
  is ~45–60s — so even that isn't close.) Present evidence and open levers; let the user
  decide what's a limit.
- **Per-node micro-opts wash out.** Slot-shrink, terminal fast paths, and the
  lockless atomic TT each measured ~0–5% at n=14 — real but small. The load-bearing
  levers are **memory / representation** (compact fingerprint slot, BuRR archive,
  ply-windowing) and **node-count** (move ordering, canonicalisation, decomposition).
  Spend effort there, not on shaving cycles off a latency-bound node.
- **Measure, don't assume; document negatives.** Bench **interleaved** A/B (alternate
  the two binaries round-by-round) — this box thermally throttles ~1s on a ~12s n=14
  solve, so all-A-then-all-B yields spurious deltas. Keep a change only if it pulls
  its weight; if it's a wash or negative, revert it or record it as an instructive
  negative (the handoffs already hold several: deeper parallelism, df-pn,
  naive-prefetch-windowing).
- **Box hygiene before any n=16 bench — a degraded box silently fakes a "wall."** The 17 GB TT needs
  ≥~20 GB free or it OOMs/spills (into zram = compressed RAM, NOT disk) and every number is garbage.
  Before benching: **swap/zram off**, **ZFS ARC capped low** (`zfs_arc_max`≈2 GB — default ~50% RAM
  eats the table), **drop caches + compact** (`echo 3 >.../drop_caches; echo 1 >.../compact_memory`),
  and **clear `/tmp`** (it's tmpfs = RAM here; stale `*.perf.data` ate 11 GB last session). The bogus
  "36 M/s floor / 3m41s wall" came entirely from benching a memory-starved box; clean, it's 2m44s.
  Also force full 2 MB pages on the TT (`QUEENS_TT_COLLAPSE`, default-on ≥4 GB) — plain THP only
  promotes ~73% of a randomly-faulted multi-GB table.
- **Channel Fermi.** Napkin the predicted leverage before implementing. If the bench
  disagrees with the napkin by an order of magnitude, the *model* is wrong — re-read
  the trace at a wider angle, don't keep shaving the thing you assumed was the cost.
- **Resolve env-vars once at startup; thread the value through; never `env::var` /
  `var_os` in a per-node / per-move / per-row loop.** The env-lock serialises all
  rayon workers — the exact contention a lockless TT removes. Canonical readers:
  `tt_bits` (reads `QUEENS_TT_BITS` once per command) and `Strong::new` /
  `env_threads` (reads `OTHELLO_THREADS` once in the constructor), both threaded.
- **Hot-path toggles are resolved once *outside* the loop, never tested per-iteration
  — and this is how we do it, every time.** The rule is bigger than env reads: any
  flag that is constant for a run (a measurement/instrumentation switch, a key-mode,
  a debug counter) must not become a per-node `if`. A per-iteration branch on a
  run-constant bloats the hot loop's I-cache and feeds the branch predictor / frontend
  — and the search is already frontend / L1i-bound where the graph key lives (session-6
  TMA), so the dead branch *worsens the actual bottleneck*. **Preferred form:
  monomorphise on a `const` generic resolved at the call site** (e.g.
  `iso_key_fast_in::<const HIST: bool>` — production instantiates `HIST = false` and the
  tally is never emitted; `count --comps` instantiates `HIST = true`). The single
  runtime decision happens once, at the top, selecting between the two monomorphised
  instantiations (`if collect { run::<true>() } else { run::<false>() }`). When a const
  generic can't reach the site (e.g. through a `dyn` trait object), thread the resolved
  value as a plain field/param instead — but still resolve it once, never in the loop.

## Tiger-style hot-struct discipline

Applies to any struct/loop reached per node — queens `Tt::wins_keyed`,
`QueensTt::get/put`, `pos_key`/`canon`; the Othello PVS search nodes. Cold structs
(CLI, geometry build, errors) are exempt.

1. **Plain data only** in hot structs — no `String`/`Vec`/`HashMap` *inside*; inline
   `[T;N]` / `Box<[T]>`, or pool-index by `(u32,u32)` ranges. (`Slot` is one `u64`;
   `Bits` is `[u64;4]`.)
2. **Contiguous storage** — `Box<[T]>` / `Vec<T>`, never `Vec<Box<T>>` /
   `Vec<Arc<T>>` / `Vec<Box<dyn …>>` / linked structures. (The TT is one flat
   `Box<[AtomicU64]>`.)
3. **No pointer-chasing in the loop body** — read indices, resolve once at scan entry.
4. **Explicit `#[repr(C)]` / `transparent`** on hot structs — never rely on default
   repr; a field-add can silently re-pad.
5. **One array-stride shape, asserted:** cache-line-per-record (`size_of ∈
   {64,128,192}`, `#[repr(C, align(64))]`) **or** several-per-line (`size_of ∈
   {8,16,32}`, no per-record align). Assert size AND align so a regression fails to
   compile.
6. **Field order largest-align-descending, hot fields first;** manual `_pad: [u8; N]`
   for natural gaps; cold/tuning fields in a sibling struct.
7. **Compile-time `const _: () = assert!(size_of::<T>() == … && align_of::<T>() == …)`**
   — a size regression fails the build. (Queens asserts `size_of::<Slot>() == 8` in a
   test; prefer a `const _` assert for new hot structs.)
8. **No internal serialize/deserialize** — operate on the in-memory rep across stages.

Plus:
- **No raw pointers in perf designs** — `&T` / `&[T]` / `&mut T` / `Vec<u32>` index
  pairs reach the same layout wins safely. The few sanctioned `unsafe` blocks (the
  `AtomicU64` zeroed-alloc reinterpret + `madvise` in `zeroed_huge_atomics`, and
  `_mm_prefetch`) each carry a `// SAFETY:` note stating the invariant relied on.
- **Size integer fields to the value range, not `usize`** — board side n≤16, square
  indices <256, nimbers <16, ply <256 fit `u8`/`u32`. Cast to `usize` only at the
  genuine indexing/`with_capacity` site; clamp at the input boundary, never via a
  silent mid-pipeline `as u8`.

## Deps & memory

- **Use ecosystem crates properly** (clap for CLIs, rayon, `libc` for `madvise`) — no
  "no-dep / faithful-port" rationalisation for avoiding a dependency.
- Canonical rules live here (git-tracked); the per-project auto-memory holds short
  triggers/pointers only, never the canonical rule.

## Handoffs

`notes/handoffs/YYYY-MM-DD-<slug>.md`, one file per work stream. End each session
with the handoff's Progress updated + a dated Handoff Note (session id, commits, what
landed, measurements, next steps). Ship doc updates in the same commit as (or
back-to-back with) the code they describe — don't leave docs uncommitted across a
session boundary.
