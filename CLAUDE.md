# Othello workspace — project guide for Claude Code

Two crates share the repo: the Python `othello` package (root) and the Rust port +
Queens solver (`rust/`). Active work currently centers on the projective cap/Nofil
program and Lean proof work; the old Queens/Othello performance queues are archived
unless the user explicitly resumes them.

## Current WIP
**This section is not a progress log.** It is a routing table for current work docs only.

Rules:
- Keep each entry to the document to read first and, if needed, the active task IDs.
- Do not add timelines, session history, result summaries, solver leaderboards, validation
  output, or long queues here.
- Put completed, stale, or dormant work in the relevant handoff or under `notes/handoffs/done/`.
- If an entry needs more context, add that context to the linked handoff, not here.

### Codex WIP

- **ProjectiveCap / Lean proof program:** start with
  [projective cap game](notes/handoffs/2026-07-06-projective-cap-game-handoff.md), then
  [codex task queue](notes/2026-07-07-codex-task-queue.md) — see its CURRENT TOP OF QUEUE
  for the active task IDs.
- **Named-expert / proof context:** load
  [named-expert personas](notes/2026-07-07-named-expert-personas-context.md) before
  nontrivial Lean work.

### Claude WIP

- **ProjectiveCap shared current lane:** use the same
  [projective cap game](notes/handoffs/2026-07-06-projective-cap-game-handoff.md)
  handoff unless the user names a different handoff.
- **Node-Kayles / sum-free thread:** dormant unless resumed; entry point is
  [node-kayles-games handoff](notes/handoffs/2026-07-04-node-kayles-games.md).
- **Queens/Othello performance queues:** archived/dormant; see
  [2026-07-08 CLAUDE Queens/Othello WIP](notes/handoffs/done/2026-07-08-claude-archive-queens-othello.md).

**`go`** (or `@notes/handoffs/<name>.md go`) at session start = read that handoff and resume from its Progress / next steps.

## Lean

Top-level Lean proof work lives under [`lean/`](lean/). Before doing nontrivial proof work, load the
named-expert umbrella [`notes/2026-07-07-named-expert-personas-context.md`](notes/2026-07-07-named-expert-personas-context.md)
and the relevant dossier under [`notes/expert-personas/`](notes/expert-personas/). The umbrella gives
the loading order for Sumfree, ProjectiveCap, and Queens/NodeKayles proof sessions.

**Lean build/OOM hygiene:** generated certificate builds can fan out many heavyweight `lean`
workers. Do not run a raw full aggregate like `nix develop --command lake build
ProjectiveCap.CertData.Q13Assembly` on the 26 GB box: on 2026-07-08 that shape triggered
global OOM and killed unrelated session processes. Interactive bash has OOM-sacrifice wrappers
in `~/src/tavis-nix/dot_config/bash/interactive/85-oom.bash` for `lake`/`lean`/`leanc` and
`nix develop --command lake|lean|leanc`; if bypassing the shell, prefix with
`choom -n 1000 --`. For generated split certs, build leaves/classes first and the aggregate
last with `nix_lake_build_each ...`; this Lake has no `-j`/`--jobs`, and a lone aggregate
target can still fan out its missing import closure.

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

**Git permission:** ordinary forward commits are allowed without asking, as are local
fast-forward-only branch updates/merges into `main`. **Still ask, even with the flag on:**
architecture / design choices that lock in future work; any revert, history rewrite,
destructive git operation, non-fast-forward branch change, or `git push`; new scope or a
pivot off the handoff's lever sequence; a real n=16 run (hours-to-days — size with HLL first);
anything that would change a
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
    win, exact distinct **1,060,823**) + `solve 14 iso-flat --distinct` (second,
    iso-flat distinct **≈29.2M**, re-exp ≈ 1.0×). (The ≈49.3M elsewhere is the *D4*
    distinct; iso-flat's selective-iso key merges isomorphic graphs below it — its own
    distinct is ≈29.2M, the figure this gate checks.) **Name `iso-flat` explicitly** — the default solver is now `iso-window`,
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
- **In tmux panes, run bare on the real TTY + read back with `capture-pane` — never
  `>`/`>>`, and prefer this over `tee`.** Every queens run/bench goes in the `queens` tmux
  session (one window per run, keep window 1 live). `tmux send-keys` the **bare** command
  (no pipe, no redirect) so stdout is the pane's TTY and the **live progress bar / per-core
  telemetry renders** for the user to follow. Read results with `tmux capture-pane -t
  queens:<win> -p` (the final summary stays on screen). A pipe (`| tee`) makes stdout a
  non-TTY and **suppresses the live bar** — only fall back to `tee` if you need the raw
  scrollback and don't care about the bar; never silently redirect (`> log 2>&1`), which
  hides the run entirely.
- **Ignore the `could not find repository … panicked at … git/libgit.rs` line in the pane
  scrollback** — that's the user's interactive shell *prompt* failing to render its git
  segment between commands, not a build/run error. It never affects a running solve/bench (no
  prompt renders mid-command). Don't try to "fix" it, don't treat it as a failed run, and
  don't `C-c` the pane over it; read past it to the actual command output.
- **Use the committed A/B harness — don't re-derive it in `/tmp` (we've done that dozens of
  times).** `rust/scripts/queens-ab.sh <n> <TOGGLE_ENV> <binary> [rounds] [tt_slots]` runs the
  canonical interleaved A/B (toggles one env flag 0/1 on a binary). Launch it **once** in the
  `queens` pane (`tmux send-keys -t queens:<win> "scripts/queens-ab.sh 16 QUEENS_ITER
  ./target/release/queens" Enter`) and poll completion with `tmux capture-pane … | grep -q
  QUEENS_AB_DONE`. The script's header documents every lesson baked in; the load-bearing ones:
  - **Never blind `tmux send-keys C-c`** into the pane to "reset" it — that SIGINTs a running
    solve (the recurring "what's doing SIGINT?" footgun). Ensure the pane is **idle** (at a
    prompt) before launching; don't drive runs by per-run `send-keys` into a busy pane (the keys
    interleave into the running process).
  - **Emit a clear `BEGIN <tag>` / `END <tag>` marker around every run** so the scrollback is
    attributable — otherwise interleaved runs are unreadable.
  - **Completion marker must only appear as run OUTPUT, never as a typed command** (`QUEENS_AB_DONE`
    is echoed *after* the loop) — else a `capture-pane | grep` poll false-matches the launch
    command line and "finishes" instantly.
  - **n=16 is memory-tight (17 GB TT, ~4 GB headroom): back-to-back 17 GB runs OOM-kill the 2nd**
    (huge-page reclaim lags process exit → `Killed`/SIGKILL). The harness defaults to a **~12 GB TT**
    (`QUEENS_TT_SLOTS=1500000000`) which is memory-safe and a valid comparison (a per-node toggle's
    cyc/node delta is TT-size-independent). Use the 17 GB default only with cache-drops between runs.
  - **Metric = cyc/node = perf cycles ÷ solver nodes** (node-count-independent); solver summary is
    on **stdout** (capture to a file), the live bar on **stderr** (leave on the pane).
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
- Canonical rules live here (git-tracked). **Record ALL project work in the git-tracked
  handoffs (`notes/handoffs/`), NEVER in the per-project auto-memory** — handoffs are
  visible to the user; auto-memory is not. The auto-memory is reserved for cross-project
  standing preferences only; do not stash session findings, data, interpretations,
  decisions, or queues there (they get hidden + duplicate the handoff).

## Handoffs & doc discipline

All work lives in git-visible docs, never auto-memory. Two kinds, strictly split:

- **Live docs** (loaded each session — keep crisp): the active handoff
  `notes/handoffs/YYYY-MM-DD-<slug>.md`, the task queue
  `notes/2026-07-07-codex-task-queue.md`, and `## Current WIP` above. Hold ONLY the
  current-state map: goal, status tables, work streams, open frontiers, the open queue, and
  **one-line pointers to closed paths** (verdict + link). No logs, dated play-by-play,
  narratives, amendment trails, or superseded plans.
- **Companion docs** (append-only history): each live doc pairs with an `-archive.md`
  (handoffs under `notes/handoffs/done/`). Dated session notes, superseded plans,
  closed-negative writeups, amendment trails go here; a single finding is its own
  `notes/YYYY-MM-DD-<slug>.md`. Live + companion = the source of truth: live is the map,
  companion is the log.

**Task IDs.** One global monotonic `CNN` sequence across Codex and Claude; the queue is the
registry, its `CURRENT TOP OF QUEUE` the live view. New ID = `max(CNN in queue + handoff +
notes/) + 1`, entered as a one-line queue row at allocation. Never reuse or renumber a
reported ID; on a collision, renumber the newer/less-referenced one (e.g. C74→C75, 2026-07-11).

**End of session.** (1) Update the live map (tables, frontiers, queue); prune any log that
crept in. (2) Append the dated session note to the companion, not the live doc. (3) Move
newly-settled sections to the companion under a dated status header. (4) Commit docs with the
code they describe. Move a finished handoff to `notes/handoffs/done/`.
