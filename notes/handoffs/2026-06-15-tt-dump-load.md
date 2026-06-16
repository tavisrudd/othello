# Queens TT dump/load — QUEUED (pointer)

**Date**: 2026-06-15
**Created by**: 2026-06-15--10 (`7dd7be77-1994-4352-ad69-c8fa5053fcca`)

➡️ **Canonical design + decision live in `notes/proposal-2026-06-15-queens-tt-dump-reload.md`**
(another session's thorough proposal — Approach A raw image vs B2 sparse export, 5 phases,
distributed delta-gossip extension). The **Session-7 decision** section at the top of that
proposal records what to build next session:

- **MVP = Approach A (raw flat image) / Phase 1**: `QueensTt::dump`/`load` (validated header +
  raw slot bytes), `solve … --resume <path>`, **SIGUSR2 → dump-now**. Raw read/write, not mmap.
- **First-class payoff: reproducible n=16 benchmark fixture** — a SIGUSR2 mid-search dump =
  deep-regime A/B fixture (load + fixed-time run) to cleanly measure backlog #20 and future
  speedups. Resume is automatic via TT warmth.
- Validation: dump n=12 → load → instant re-solve (verdict second, ~0 new nodes); dump mid-n=14
  → load → resume completes to the correct verdict, total nodes = full cold solve.

See the proposal for the full design, header format, phases, and the B2 / distributed roadmap.
