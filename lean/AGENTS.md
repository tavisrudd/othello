# Lean workspace instructions
These instructions apply to work under `lean/`. The parent `AGENTS.md` requires agents to read this file before any Lean edit, generator run, build, or process intervention.

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

`1000` is the default sacrificial setting. Lower it to `500` only when the user explicitly gives
one build priority and has coordinated the other jobs to remain sacrificial; that relative
protection is a session-level scheduling decision, not a new default. A priority adjustment does
not change the measured worker cap, permit concurrent heavyweight Lake builds, or relax any RAM
budget below.

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

**Finite-certificate sharding must cross module boundaries.** Splitting a proof into per-row lemmas,
`fin_cases` branches, or local tactic blocks inside one `.lean` file does not bound elaborator
memory: Lean can retain all of those proof terms until the module finishes. This was measured on
the Q11 A5 point-orbit certificate, where three single-source layouts — including row-sharded and
arithmetic-normalized variants — each reached roughly 17.5--17.75 GiB and exited 137. For a large
finite certificate, use a definitions-only base, separately compiled bounded leaf modules, and a
lightweight aggregator. Build the leaves serially to `.olean` before probing the aggregator; do not
start with the umbrella target and assume tactic-level sharding will provide the same memory bound.

When a finite certificate is executable but `decide` or `norm_num` gets stuck on an intentionally
opaque operation, do not unfold the opaque implementation separately in every case. Introduce a
small reducible evaluator backed by a proved finite table, prove one symbolic bridge to the original
definition, and reflect the whole finite equality through the evaluator. In the Q11 projective
action, replacing opaque `ZMod` inversion by a proved 11-entry inverse table reduced a nonidentity
133-point row from more than 12 minutes to about 8 seconds while keeping the proof kernel-checked.

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

**Do not spend tokens dumping the process table.** After a Lean command ends, do not immediately
recheck processes; wait at least 20 seconds of actual uncertainty before polling. Filter at the
source with a narrow query such as
`ps -C lean -C lake.orig -o pid,ppid,etime,rss,comm,args --no-headers` (or exact-name `pgrep`), and
only request the fields needed for the ownership decision. Never run `ps -eo ...` and then filter
its hundreds of unrelated rows in a pipe, tool wrapper, or agent code. Poll sparsely, and prefer a
scripted serial runner that waits and reports only target milestones over repeatedly watching a
healthy build.

**Be token-conservative with command output.** Before running any command whose output may be large
or unbounded, narrow it at the source: request explicit paths, exact patterns, needed fields, small
line ranges, or a deliberate output cap. Do not dump whole files, repository-wide listings, build
logs, process tables, or broad diffs when a targeted query answers the question. Use
`~/.claude/bin/run-quiet "command args"` for predictably noisy commands such as Nix builds,
`home-manager switch`, and similar long-running build or deployment commands; inspect its concise
terminal summary or a bounded diagnostic tail only if the command fails. Do not reprint output
already captured earlier in the session.

For a guarded single-file elaboration, use
`lean/scripts/guarded-lean RelativeConicArcs/Module.lean` instead of repeating the full affinity,
thread-cap, OOM-priority, Nix-shell, and `lake env lean` prefix. It defaults to cores `20-23`, one
Lean thread, and `oom_score_adj=1000`; exceptional overrides are
`LEAN_GUARD_CPUSET`, `LEAN_GUARD_THREADS`, and `LEAN_GUARD_OOM_SCORE_ADJ`.

For an unattended sequence of explicit Lake targets, use
`python3 lean/scripts/lean-build-queue.py run <targets...> --cores 20-23 --threads 1`; inspect its
durable run directory with the printed `status` command instead of polling the build. The queue
serializes participating runners, skips trace-current targets, writes one full-module-name log per
target, and finishes with a trace-only aggregate gate. Hand-run Lake commands do not take its lock,
so the foreign-process quiet check and cross-lane rules still apply.

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

**Restart progress needs trace-validated sentinels.** An existing olean may belong to an older
import closure, Lake schedules independent branches in non-monotone filename order, and fresh runs
may rediscover replay/build tasks with a different progress denominator. Therefore neither an
olean's existence, a low/high generated-row number, nor `done/total` proves that a module was landed
by the current build. Before changing `LEAN_NUM_THREADS` or otherwise restarting a large build:

1. stop the one owning Lake process gracefully and confirm its children exited;
2. choose several modules that the just-stopped run explicitly printed as `Built`;
3. run `lean/scripts/lean-restart-guard.py checkpoint /home/<checkpoint> <sentinels...>` — it uses
   `lake build --no-build` and hashes each sentinel's `.olean`, `.olean.hash`, `.ilean.hash`, and
   `.trace`; and
4. after the restart, retain the build output and use the script's `audit-log` command. If a
   trace-validated sentinel appears as `Built`, stop and diagnose before allowing a broad rebuild.

Use `verify` while Lake is stopped to replay the no-build probes and require byte-identical
sidecars. The script is a restart guard, not a recovery archive; pair it with `lake pack` for an
uncertain build. A controlled C143 restart verified that outputs produced with
`LEAN_NUM_THREADS=2` and `=3` are mutually reusable; the worker count itself did not invalidate
artifacts. The apparent rebuild was a pre-existing one-witness olean whose imported checker had
changed, exposed by Lake's non-monotone scheduling. Agent PID namespaces may hide host processes,
so the script's `pgrep` refusal supplements rather than replaces the required external
PID/ancestry check.

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
allowlist. Staging must be non-interactive: never use `git add -p` — it is interactive and fails in
the agent TUI. Stage explicit whole-file pathspecs, or prepare and apply an exact cached patch
non-interactively when only part of a file is owned by the current change. Never use `git add -A`.

**`/tmp` is tmpfs on this box.** Do not place Lean worktrees, `.lake` caches, generated
certificate trees, or other multi-gigabyte build artifacts there: their storage counts against
RAM and can cause global OOM. Use a disk-backed path under `/home` for heavyweight temporary
work; reserve `/tmp` for small transient files.
