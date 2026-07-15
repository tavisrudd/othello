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

### Lane routing

**Several lanes are open concurrently.** There is no single global "active lane" — which lane is
live is a property of the conversation, not of this file. Never infer it from the newest commit, the
highest-ranked queue task, or the lane worked last session.

**Selecting a lane.** Each lane below has a **bold alias**. Saying the alias — bare (`clebsch`) or
as `go <alias>` (`go clebsch`) — selects that lane and resumes it from its entry doc.
`@notes/handoffs/<name>.md go` likewise selects that handoff's lane. Listed synonyms work too
(`hexagon` = `clebsch`), but docs and pegs use the canonical alias only.

**Every handoff declares its lane** in a `**Lane**:` line directly under its H1 — so a handoff opened
cold, without this table, still says which lane it belongs to:

```
# Handoff title

**Lane**: `cap` — see CLAUDE.md § Lane routing.
```

One lane per handoff, from the alias list below; add it when the handoff is created. A handoff whose
work spans lanes is pegged to the lane that owns its deliverable, same rule as C items.

**Bare `go` / `next?` at the start of a session, with no lane named: ASK which lane.** Do not guess
and do not default to the most recent anything. Listing the open lanes with a one-line status each
is a good way to ask.

**Within a session, `go` / `next?` mean the next step in the lane already selected** — not the newest
global commit, not a higher-ranked task elsewhere. The lane stays selected until the user switches it
or it finishes. An explicit lane name always switches, no questions asked.

**When the selected lane finishes** (its entry doc declares it done, or its work is complete): stop
and say so. Do not roll onto another lane, and do not invent new scope inside the finished one. Then
ask, as three separate questions: (a) archive the handoff to `notes/handoffs/done/`? (b) update this
routing table? (c) which lane next? Wait for the answers.

**Cross-lane hygiene** (applies while any lane is selected):
- Treat commits and working-tree changes owned by other lanes as foreign: note them when relevant,
  but do not review, edit, stage, or route into them without an explicit lane switch.
- Before editing, check the selected lane's allowed paths. If a needed target is outside them,
  stop and request a lane switch or scope expansion.
- Consult the global queue for task-ID allocation and explicit lane completion, not to override the
  selected lane's local next step.

### Codex WIP

- **`alt-orbit-repair`** — Alternate-orbit repair for invariant ten-arcs (C142–C143): start with
  [alternate-orbit repair](notes/handoffs/2026-07-14-alternate-orbit-repair.md). First do C142, the
  certificate-free `s ≥ 7` repair theorem; C143 owns the gated Q25 two-witness certificate.
- **`baer`** — Baer-equivariant robust completion (C99, C133, C134): start with
  [Baer-equivariant robust-completion](notes/handoffs/2026-07-14-baer-equivariant-robust-completion.md).
  First task is the C99.6 hostile review and disposition.
- **`cap`** — ProjectiveCap / odd-plane / Lean proof program (C13, C30, C50, C56, C74–C88; the
  largest lane): start with
  [projective cap game](notes/handoffs/2026-07-06-projective-cap-game-handoff.md), then
  [codex task queue](notes/2026-07-07-codex-task-queue.md) — see its CURRENT TOP OF QUEUE
  for the active task IDs.
- **`relconic`** — Relative-conic arcs paper + evaluation/coding strengthening (C89–C96, C100, C101,
  C106–C110): start with
  [relative-conic arcs strengthening](notes/handoffs/2026-07-13-relative-conic-arcs-strengthening.md).
- **`repaircodes`** — RepairCodes / coding-repair-hypergraphs paper (C97, C98, C102–C105,
  C111–C114): start with
  [projective-completion repaircodes](notes/handoffs/2026-07-13-projective-completion-repaircodes.md).
- **`cubic`** — Twisted-cubic cross-lane / transversal spectrum (C115–C120): start with
  [twisted-cubic transversal-spectrum](notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md).
  Next session do **C115 (opt-b) first** — the projection→plane-cubic reduction.
- **Named-expert context** (not a lane): load
  [named-expert personas](notes/2026-07-07-named-expert-personas-context.md) when
  developing or formalizing a nontrivial proof, or when requested. Do not load them for
  status, routing, document review, relevance checks, literature comparison, or other
  read-only discussion.

### Claude WIP

- **`clebsch`** (synonym: `hexagon`; shared with Codex; formerly also called the *icosahedral MDS /
  deep-holes* lane — all one lane, one peg) — the Clebsch hexagon paper: the `[6,3,4]₁₁` MDS code
  whose deep holes are a conic (C121–C132). Same alias as the paper directory in
  `papers-index.md`, deliberately: lane, paper, and peg are one word. Start with
  [clebsch-paper handoff](notes/handoffs/2026-07-13-clebsch-paper.md) — the lane's **single live
  doc**: status, Lean gallery, open lit, remaining work. Manuscript + checkers:
  [`papers/clebsch-hexagon-code/`](papers/clebsch-hexagon-code/) (the `.tex` is authoritative for all
  prose and citations); indexed in [papers-index.md](papers/papers-index.md) under the same
  `clebsch` alias.
- **`gem-mining`** — the second-gem hunt and the census-sweep machinery behind it (C147): start with
  [gem mining](notes/handoffs/2026-07-14-gem-mining.md). Owns the generator methodology, the E_q
  healthy census, and the hexad/octad polarity program. Findings that land in the Clebsch manuscript
  are pegged `clebsch`, not here.
- **`cap`** (shared with Codex) — use the same
  [projective cap game](notes/handoffs/2026-07-06-projective-cap-game-handoff.md)
  handoff unless the user names a different lane.
- **`kayles`** — Node-Kayles / sum-free thread: dormant unless resumed; entry point is
  [node-kayles-games handoff](notes/handoffs/2026-07-04-node-kayles-games.md).
- **`queens`** — Queens/Othello performance queues: archived/dormant; see
  [2026-07-08 CLAUDE Queens/Othello WIP](notes/handoffs/done/2026-07-08-claude-archive-queens-othello.md).

## Lean

Top-level Lean work lives under [`lean/`](lean/). Before developing or editing a nontrivial Lean
proof, load the [named-expert umbrella](notes/2026-07-07-named-expert-personas-context.md) and relevant
dossier under [`notes/expert-personas/`](notes/expert-personas/). Discussion or review alone does not
trigger this.

**Lean build/OOM hygiene.** Generated certificate builds fan out heavyweight `lean` workers; that
fan-out, not the aggregate target itself, is what OOMs the 26 GiB box. A lone aggregate fans out its
missing import closure, and so does any consumer above generated leaves. Three dimensions are
independent — **job count, CPU placement, memory risk** — and conflating them is how builds die:

- **Job count — `LEAN_NUM_THREADS=N`, exported into the build shell.** Lake is itself a Lean
  program, so its job pool *is* Lean's task pool. There is no `-j`/`--jobs` flag at either level.
  Unset, Lake launches one job per host core.
- **CPU placement — `taskset -c ...`, only to keep a build on this lane's cores.** Affinity is
  inherited by workers but does **not** size the pool: without `LEAN_NUM_THREADS`, Lake still
  launches one job per *host* core and they contend on the pinned set (verified 2026-07-14 —
  pinning to six cores still produced one worker per host core).
- **Memory risk — `choom -n 1000 --`.** This selects the build as the OOM victim so the kernel
  sacrifices a worker instead of unrelated processes. It is a **containment guard, not permission
  to oversubscribe memory.**

**Choose N by measurement, never from `nproc` and never from another family's N.** Measure the
heaviest representative leaf's peak RSS with GNU `time -v` (`/usr/bin/time -v`; a bare `time` is a
bash keyword, not GNU time). Reserve 6–8 GiB for the OS, Lake itself, and **tmpfs** — `/tmp` pages
are unreclaimable with no swap, so check `free` (shared) and `df /tmp` and add current usage to the
reserve — then require `N × representative_peak_RSS + reserve < physical RAM`. Measured so far:
`RelativeConicArcs` Q16 generated leaves ≈1.3 GiB/worker → N=6 verified safe (2026-07-14); the C143
two-witness leaf peaks ≈6.3 GiB/worker → **N=2** (`2 × 6.34 + 8 ≈ 21 GiB`). N=3 is **not** licensed
there: `3 × 6.34 + 8 ≈ 27 GiB` fails the rule, and a quieter box changes the reserve, not the rule.
Use 1 while another memory-heavy build is running at all (see the concurrency hazard below). A cap
that is right for one target family is unsafe for another; lighter modules may run a higher cap.
(C143 figures reported by the alt-orbit-repair lane, not independently re-measured.)

**The closure is heterogeneous — size N against what can be co-scheduled, not the average leaf.**
`N × peak_RSS` assumes every concurrent worker costs the same; that holds for uniform generated
leaves and breaks when a shared checker sits in the closure. The C143 leaf standalone against
current dependencies peaks ≈6.3 GiB; the shared checker `Q25PairCertificate` peaks ≈9.3 GiB on its
own, and the *first* build after a checker change peaked ≈10.8 GiB overall — it rebuilt the checker
(≈180 s) before the leaf itself (≈105 s; 4:51.9 total). A **dependent never co-schedules with its
dependency** — Lake's DAG builds the checker to completion before any row that imports it, so in a
focused leaf build the checker runs alone by design. The exposure is **non-dependent siblings**:
in a wide build, modules outside the checker's cone (e.g. Q16 leaves during a Q25 checker rebuild)
fill the remaining N−1 slots. Budget `checker_peak + (N−1) × heaviest_sibling`, and build a
known-heavy shared dependency **serially first** (N=1), fanning the generated leaves out at the
measured N only once it completes. This is a targeted serial step for one heavy dependency, not the
full leaves-first ceremony. (Figures reported by the alt-orbit-repair lane, not independently
re-measured.)

```
LEAN_NUM_THREADS=2 choom -n 1000 -- taskset -c 20-21 \
  nix develop --command bash \
  -lc 'export LEAN_NUM_THREADS=2; exec lake build <explicit-targets>'
```

N in that example is C143's measured cap, not a default — re-measure for your target family before
copying it.

With a measured cap set, leaves-first `nix_lake_build_each ...` is unnecessary for uniform leaves
and much slower — it pays a fresh Lake startup per target; keep it for a strictly serial run, such
as the heavy-shared-dependency step below.
The OOM wrappers in `~/src/tavis-nix/dot_config/bash/interactive/85-oom.bash` exist only in the
user's **interactive** shell, and their `nix` wrapper matches only `nix develop --command
lake|lean|leanc` — not the `nix develop --command bash -lc '... lake ...'` form above. Agent Bash
sessions never pass through any of them. **Always** prefix builds with `choom -n 1000 --` yourself;
treat the interactive wrappers as a convenience for the user, not as coverage.

**Never run two heavyweight builds at once in `lean/`.** Lake holds only an exclusive
*configuration* lock (`olean.lock`); it does **not** serialize builds. Two concurrent `lake build`s
in this workspace race artifact writes on any shared closure and double-book RAM — and the sizing
rule above is only valid for one build at a time. Coordinate explicitly before starting a
generated-certificate or aggregate build while another lane may be building.

**Pressure and thrash look alike — distinguish them.** Low `MemAvailable` with **no** kills is the
guard working: do not intervene, and a build that looks stuck is usually just slow. If **your own**
aggregate records repeated `code 137` module failures, the cap is wrong for this workload:
terminate that aggregate by its verified parent PID or task handle, lower N, and restart. Never
kill an individual worker, and never another lane's process. Do not ride it out — OOM-killed
modules lose their oleans, so a thrashing build runs *backwards* and can
leave the tree worse than it started (observed 2026-07-14: leaf oleans regressed under an uncapped
aggregate before a capped rerun recovered them). Before a large or uncertain rebuild, snapshot the
build tree with `lake pack <path>.tgz` — it archives the root package's whole `buildDir` and builds
nothing. Write it to a disk-backed path under `/home`, never `/tmp`. Prefer it to a hand-rolled
copy of `.lake/build/lib`: the `ir` tree beside it holds the C/object outputs, so a partial copy is
not known to restore consistently.

**Process inspection — check command and ancestry, not a name.** The installed toolchain's
`bin/lake` is a wrapper script that `exec`s the real binary **`lake.orig`** (to inject a custom
`LEAN_CC`), so `comm` is `lake.orig` on **every** invocation — with or without the OOM shim, which
renames nothing. `pgrep -x lake` therefore reports a live, healthy build as dead, always. Use
`pgrep -x lake.orig` or `pgrep -f 'lake build'` (argv[0] is preserved by `exec -a`), and confirm
ownership by PPID/ancestry before acting on any worker. Never `pkill -f` a string that also matches
your own command line — it kills the shell that issued it. Stopping **your own** build by task ID
or verified PID, on evidence, is correct; killing on memory pressure alone is not; killing another
lane's workers never is.

**Staleness comes from content traces, not mtimes.** An mtime-derived "what's stale" list will miss
modules Lake intends to rebuild. Probe exact targets with `lake build --no-build <targets>` — it
exits immediately if a target is not up to date and triggers no fan-out. If it reports a foreign
dirty or stale dependency, do not build the consumer: wait for that lane, or at most run `lake env
lean path/to/Leaf.lean` as a smoke test knowing it elaborates against the dependency's *last-built*
olean rather than the dirty source — never record that as a gate result. For a new leaf whose
dependencies are **known current**, that same command is a safe elaboration check: it reads
existing imports and does not rebuild their closure. Confirm the imports are current (`--no-build`)
before trusting it. **Never** use `--old` to satisfy a validation gate: it ignores transitive deps,
which is exactly what the gate exists to check.

**Cross-lane build hygiene.** Prefer the narrowest leaf targets. Do not run an umbrella aggregate
when its closure contains a foreign **dirty, stale, or concurrently owned** module — stable checked
dependencies from another lane are ordinary deps and are fine. (`RelativeConicArcs` spans
`relconic`, `baer`, and `alt-orbit-repair`, so probe with `--no-build` before building a consumer;
observed 2026-07-14 going stale within ~20 min of a green build while another lane regenerated its
certificates.) Different cores do not isolate memory or Lake artifacts — two builds on disjoint CPU
sets still share RAM, I/O, and `.lake/build` — so spare cores are not a reason to start a
generated-certificate build. Treat another lane's sources and build processes as owned state: do
not edit, rebuild opportunistically, kill, or clean them — and never `lake clean` while another
lane is using the shared build tree.

**Source and staging hygiene.** Run generators against explicit roots, never repository-wide. After
any generator or formatter, require `git diff --name-only` to be a subset of the selected lane's
allowlist. Stage explicit pathspecs only — never `git add -A`.

**`/tmp` is tmpfs on this box.** Do not place Lean worktrees, `.lake` caches, generated
certificate trees, or other multi-gigabyte build artifacts there: their storage counts against
RAM and can cause global OOM. Use a disk-backed path under `/home` for heavyweight temporary
work; reserve `/tmp` for small transient files.

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
- **A change is not done until its validation gate passes. Othello:** the cross-engine
  value-equivalence tests (minimax / alphabeta / ordered / strong compute identical
  black-centred values) + the independent grid move/flip reference + the exact endgame solves
  (6 / −40 / 4). `strong+` / `strong++` deliberately change the value (strength match, not
  equivalence). The **Queens** gate and n=16 sizing are dormant — see the
  [perf playbook](notes/queens-othello-perf-playbook.md).

## Performance work (dormant)

Queens/Othello hot-path tuning is dormant. **Load the
[Queens/Othello perf playbook](notes/queens-othello-perf-playbook.md) before** resuming Queens
work, running/reading an n=16 solve, or writing/optimizing/benchmarking any Rust hot path (search
loop, TT, per-node struct — including the projective grid-cap solver). It holds the Queens
validation gate, the interleaved A/B harness + tmux-pane protocol, n=16 box hygiene,
env-var/hot-toggle-in-loop rules, and Tiger-style hot-struct layout.

One rule stays always-on (it is behavioral, not just perf):

- **NEVER claim we've reached "the floor" / a hard limit / that something is "unreachable" — that
  judgment is the user's alone.** Keep pushing and reasoning from first principles; at a wall,
  reason *through* or *around* it, don't declare it terminal. A "floor" is almost always an
  artifact of the measurement conditions or an untried lever, not a real bound. Present evidence
  and open levers; let the user decide what's a limit.

## Deps

- **Use ecosystem crates properly** (clap for CLIs, rayon, `libc` for `madvise`) — no
  "no-dep / faithful-port" rationalisation for avoiding a dependency.

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

**Write clean, not amended.** State conclusions in final form, as if written right the first
time — no superseded claims, dead ends, or "what was wrong" trails. The correction trail lives
only in the append-only companion/archive logs, or inline **when overturning an
already-committed conclusion** (a deliberate note of what changed, to guard against slipping
back). Not-yet-committed work is always rewritten clean.

**Task IDs.** One global monotonic `CNN` sequence across Codex and Claude; the queue is the
registry, its `CURRENT TOP OF QUEUE` the live view. New ID = `max(CNN in queue + handoff +
notes/) + 1`, entered as a one-line queue row at allocation. Never reuse or renumber a
reported ID; on a collision, renumber the newer/less-referenced one (e.g. C74→C75, 2026-07-11).

**Every C item is lane-pegged.** Each row carries its lane alias immediately after the ID, using an
alias from the routing table above:

```
- **C<id> `[clebsch]` [QUEUED 2026-07-14]** — one-line description → report path
```

Never write a concrete unallocated ID in an example or template — always `C<id>`. New IDs are
`max(CNN) + 1` over the queue + handoffs + `notes/`, so an invented ID in prose silently burns that
number.

The peg is what makes a C item routable; an unpegged row is a bug, not a neutral default. Rules:
- **Exactly one lane per item.** Work touching two lanes is either two items or one item pegged to
  the lane that owns the deliverable — never a row pegged to both.
- **Peg at allocation**, in the same edit that allocates the ID. Do not allocate an ID and peg later.
- **Section membership is not a peg.** Lane sections in the queue are presentation; the tag is the
  fact. Keep them consistent, and when they disagree, the tag wins.
- **Re-pegging is a lane switch** and needs the same explicit approval: say the item is moving,
  which lane to, and why. Do not re-peg silently while working an unrelated lane.
- Selecting a lane selects its C items. When asked for the next step in a lane, read that lane's
  pegged items — do not pull a higher-ranked item pegged elsewhere.

**End of session.** (1) Update the live map (tables, frontiers, queue); prune any log that
crept in. (2) Append the dated session note to the companion, not the live doc. (3) Move
newly-settled sections to the companion under a dated status header. (4) Commit docs with the
code they describe. Move a finished handoff to `notes/handoffs/done/`.
