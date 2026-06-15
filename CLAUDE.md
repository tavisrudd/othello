# Othello + Non-Attacking Queens — project guide for Claude Code

Two crates share the repo: the Python `othello` package (root) and the Rust port +
Queens solver (`rust/`). Active work is in `rust/`; the live umbrella is the Queens
n=16 roadmap in `notes/handoffs/`.

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
