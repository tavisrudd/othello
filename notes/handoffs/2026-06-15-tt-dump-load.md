# Queens TT dump/load (raw flat file) — checkpoint/resume + n=16 benchmark fixture

**Date**: 2026-06-15
**Created by**: 2026-06-15--10 (`7dd7be77-1994-4352-ad69-c8fa5053fcca`)
**Purpose**: Persist the queens transposition table to a flat file and reload it, so a
long n=16 run survives a restart **and** any state becomes a reusable, reproducible
benchmark fixture for measuring future speedups.

---

## Context

The `queens` solver (Rust, `rust/`) solves the adversarial Non-Attacking Queens game.
n=16 is the open problem; after the session-7 parity-YBWC parallelism fix (commit
`2f51aa5`) it runs **multi-core** for the first time — the first live run did ~9.7
**billion** nodes at 1.4× re-expansion on the full 24-core box in ~tens of minutes
(vs Jenrich's 23 h). The transposition table (`QueensTt`) is the search's memo; it is
one flat `Box<[AtomicU64]>` of 8-byte fingerprint slots.

This task adds **`QueensTt::dump(path)` / `load(path)`** (raw flat file) plus the CLI to
drive them. Three payoffs from one build:

1. **Reproducible n=16 benchmark fixture (the main motivation).** All of session 7 we
   were forced to A/B on n=14 (the *wrong* board — too short; the parallel fan-out is a
   brief burst, so it doesn't represent the n=16 regime) or on cold partial-n=16 runs
   (slow, noisy, contention-prone). A **dumped mid-search n=16 state** is a deep,
   TT-oversubscribed fixture: load it, run a fixed time, compare nodes/s on the frontier
   under code A vs code B — identical start state, no 36-minute cold start. This is the
   clean way to measure backlog #20 (size-based parallel split) and all future per-node /
   memory levers.
2. **Checkpoint/resume** for the multi-hour n=16 attempt (the roadmap requires it; today
   an interrupt loses the whole table).
3. **Bridge to Chunk 4.** The dumped *solved-position* set is the input to the BuRR
   archive, and the TT's fill count is the **ground-truth distinct count** — it
   validates/corrects the 9.2B-distinct HLL extrapolation.

**Key insight — resume is automatic via TT warmth.** No explicit progress tracking is
needed. Load the table, re-run `first_player_wins`: already-solved root subtrees hit the
cached value instantly and fast-forward; unsolved ones continue. *The TT is the
progress.* A mid-search snapshot is always a valid partial memo (each slot is a single
atomic `u64`, never torn), so a dump taken while workers are writing still resumes
correctly.

## Scope

**In:**
- `QueensTt::dump(path)` and `QueensTt::load(path)` — raw flat file: a validated header
  + the raw slot bytes.
- CLI: `solve … --resume <path>` (load if the file exists, dump on exit) and a
  **SIGUSR2 → dump-now** handler (snapshot a *live* run without stopping it — this is
  what produces the mid-search benchmark fixture).
- Header validation: reject on any config/version mismatch.
- Tests (see Validation).

**Out (later enhancements, not this task):**
- mmap-the-dump-as-the-arena (instant load + auto-persist, but tangles with
  `MADV_HUGEPAGE` + page-cache writeback) — **decided: raw read/write is the MVP**.
- Compression (the BuRR archive is Chunk 4; the raw dump stays uncompressed).
- Periodic auto-checkpoint thread, distributed delta-gossip (the older `notes/` proposal,
  commit `4012220` — supersede it with this concrete MVP).

## Work Items

**A. `QueensTt::dump(path)` / `load(path)`** — `rust/src/queens.rs`.
- Header: `magic`, `version`, `n`, `canon` flag, `key_mode`, `slot_count`,
  `hash_version` (bump `hash_version` if `hash128`/`Slot` layout ever changes).
- Body: the raw slot bytes. Slots are POD `u64`; write the whole buffer in one
  sequential `write_all` (~17 GB ≈ 10–20 s on SSD); `load` reads into the
  `zeroed_huge_atomics(slot_count)` arena.
- **Done:** round-trips byte-for-byte; `load` of a mismatched header returns an error
  (never silently loads — a wrong-config table = silent fingerprint corruption).

**B. CLI plumbing** — `rust/src/bin/queens.rs`.
- `solve … --resume <path>`: if the file exists and its header matches the run's
  (n, key, slot_count), `load` into the table before searching; on normal exit, `dump`.
- **SIGUSR2 → dump-now**, alongside the existing SIGUSR1/SIGINT/SIGTERM handlers in
  `run_watched`/`watch`. Dumps the live table to the `--resume` path (or a default),
  without stopping the search.
- **Done:** `solve 16 parallel --resume /tmp/n16.tt` checkpoints; `kill -USR2 <pid>`
  snapshots a running solve.

**C. Validation tests** — `rust/src/queens.rs` `mod tests`.
- dump n=12 solved → load → re-solve is instant (all TT hits, verdict **second**, ~0
  new `bump`s).
- dump a *mid*-n=14 search → load → resume completes to the correct verdict, total nodes
  = a full cold solve (no lost or duplicated work).
- **Done:** both pass; `make test`/`clippy` green.

**D. First real use.** Snapshot the live n=16 (SIGUSR2) → a benchmark-fixture file; use it
to measure backlog #20 (size-based split) cleanly (load + fixed-time A/B on the frontier).

## Codebase Reference

| What | Where |
|------|-------|
| `QueensTt { slots: Box<[AtomicU64]>, len, nodes, counter }`, `zeroed_huge_atomics`, `hash128`, `Slot` layout | `rust/src/queens.rs` (`pub struct QueensTt`) |
| `canon` + `key_mode` (the config that must be tagged in the header) | `Tt` / `Parallel` structs; `key_mode()` (`rust/src/queens.rs`) |
| `n` (board side) | `Queens` (`rust/src/queens.rs`) |
| `solve()`, signal handlers (`run_watched`/`watch` — add SIGUSR2) | `rust/src/bin/queens.rs` |
| Older proposal to supersede | `notes/` (commit `4012220`) |

## Principles / Constraints

- **Header validation is non-negotiable** — reject on any mismatch (n / key_mode /
  slot_count / hash_version). A dump loaded into a different config silently corrupts.
- **Raw flat file, not mmap** (decided).
- Respects the Tiger "no internal serialize/deserialize" rule: this is raw in-memory
  bytes to disk at *cold checkpoint boundaries*, not in-pipeline transformation.
- Standard validation gate still applies for any incidental change to the search:
  `solver_lineage_agrees` (n≤9) + `solve 12/14 --distinct` (second; distinct 1,060,823 /
  ≈49.3M; re-exp ≈ 1.0×).

## Delegation

- **Can delegate to sub-agent?** Yes (self-contained).
- **Model**: Sonnet for the I/O + CLI + tests (mechanical, localized); escalate to Opus
  only if the SIGUSR2-during-concurrent-writes semantics need care.
- **Notes**: the resume-via-TT-warmth insight means no progress-tracking logic is
  needed — keep it simple. Build the raw MVP; leave mmap/compression/auto-checkpoint out.
