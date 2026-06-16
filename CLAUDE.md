# Othello + Non-Attacking Queens — project guide for Claude Code

Two crates share the repo: the Python `othello` package (root) and the Rust port +
Queens solver (`rust/`). Active work is in `rust/`; the live umbrella is the Queens
n=16 roadmap in `notes/handoffs/`.

## Current WIP
**DO NOT add details/history here. Pointers only** (details live in the handoff/proposal).

**Start here:** [Queens n=16 roadmap](notes/handoffs/2026-06-15-queens-memory-roadmap.md) — umbrella;
n=16 is **SOLVED** (second player). Progress + Lever backlog hold what's next.

**Next, in order:**
1. [#21 PV no-grind](notes/handoffs/2026-06-15-queens-memory-roadmap.md) (backlog #21) — print the verdict before the PV + parity-aware `principal_variation`; kills the single-core post-solve PV grind.
2. [TT dump/load](notes/proposal-2026-06-15-queens-tt-dump-reload.md) — raw-image MVP; 5-min checkpoint + compress + final save; deltas later. Gives checkpoint/resume + a reproducible n=16 benchmark fixture. Queue pointer: [tt-dump-load](notes/handoffs/2026-06-15-tt-dump-load.md).

**Parked (negative):** branch `chunk3-depth-preferred-tt` — depth-preferred TT replacement, measured 3× worse; off main.

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
    verdict on n≤9) **and** a fresh `queens solve 12 --distinct` (second-player win,
    exact distinct **1,060,823**, re-exp ≈ 1.0×) + `solve 14 --distinct` (second,
    ≈49.3M, re-exp ≈ 1.0×). A distinct-count change = lost transposition merges; a
    re-exp jump = under-sized table. TT/key changes must hold both.
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
