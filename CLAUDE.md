# Othello workspace guide

The repository contains the root Python `othello` package, the Rust port/Queens solver under
`rust/`, projective-cap/Nofil research, papers, and Lean developments. Queens/Othello performance
work is dormant unless explicitly resumed.

## Startup context: load only what the task needs

This file is the always-loaded rules layer. Keep it short and stable.

At the start of a session:

1. Select a lane from the user's explicit alias, named handoff, or named task. Do not infer one from
   git, the numeric value of a task ID, or the previous session.
   A literal `go C<id>` explicitly selects that task **and its lane**. Look up the exact `C<id>` row
   in `notes/2026-07-07-codex-task-queue.md`, take the row's bracketed lane peg as authoritative,
   and then read only that lane's entry handoff from the routing table below. Do not search broadly
   for the task ID or ask the user which lane it belongs to.
2. Read only that lane's entry handoff. It is the current-state map.
3. Otherwise, read `notes/2026-07-07-codex-task-queue.md` only for global task-ID allocation,
   explicit lane completion, or a user-requested cross-lane status. A selected lane's handoff owns
   its next step.
4. Do not preload archives, discovery logs, expert dossiers, paper sources, build manuals, or
   performance playbooks. Load them when the task or handoff points to them.

Live docs must not contain timelines, transcripts, validation output, or superseded plans. Put those
in companion archives or dated reports.

Every proof/math lane maintains one append-only discovery-track companion for incidental
observations and musings encountered while doing planned work. The discriminator is “was I looking
for this?”: if yes, it is a deliverable and belongs in the task report/ledger/handoff, not the
discovery track. Logging a lead does not allocate work, expand scope, or make it a handoff frontier;
promotion uses the normal C-ID and lane-routing process. Do not preload the log on ordinary entry;
open it when an incidental observation needs recording and review it during handoff. Follow
[`notes/discovery-track-conventions.md`](notes/discovery-track-conventions.md) when creating,
appending, promoting, or handing off a discovery log.

## Lane routing

Saying an alias bare or as `go <alias>` selects that lane. `hexagon` is a spoken synonym for
`clebsch`, but docs and task pegs use `clebsch`.

| Alias | Entry handoff |
|---|---|
| `alt-orbit-repair` | `notes/handoffs/2026-07-14-alternate-orbit-repair.md` |
| `baer` | `notes/handoffs/2026-07-14-baer-equivariant-robust-completion.md` |
| `build-sys` | `notes/handoffs/2026-07-14-lean-build-system.md` |
| `cap` | `notes/handoffs/2026-07-06-projective-cap-game-handoff.md` |
| `clebsch` | `notes/handoffs/2026-07-13-clebsch-paper.md` |
| `clebsch-next` | `notes/handoffs/2026-07-16-clebsch-next.md` |
| `cubic` | `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md` |
| `gem-mining` | `notes/handoffs/2026-07-14-gem-mining.md` |
| `kayles` | `notes/handoffs/2026-07-04-node-kayles-games.md` (dormant) |
| `queens` | `notes/handoffs/done/2026-07-08-claude-archive-queens-othello.md` (archived) |
| `relconic` | `notes/handoffs/2026-07-16-relconic-post-c201.md` |
| `repaircodes` | `notes/handoffs/2026-07-13-projective-completion-repaircodes.md` |
| `repairports` | `notes/handoffs/done/2026-07-16-repairports.md` (archived) |
| `rp-next` | `notes/handoffs/2026-07-16-rp-next.md` |

Each handoff must declare exactly one `**Lane**: \`alias\`` directly under its H1. A cross-lane
deliverable is pegged to the lane that owns it, or split into separate tasks.

Bare `go` or `next?` at the start of a session, with no selected lane, means ask which lane. Within a
session it means the next step in the selected lane. An explicit alias switches lanes.

When a selected lane finishes, stop and ask separately whether to archive its handoff, update this
routing table, and which lane to select next.

Cross-lane hygiene:

- Treat other lanes' edits, commits, builds, and generated artifacts as foreign.
- Before editing, check the selected handoff's allowed paths. Explicit user scope can expand them.
- Do not review, stage, rebuild, kill, clean, or opportunistically fix foreign work.
- The queue records IDs and completion; it never overrides the selected lane's local order.

Named-expert context is not a lane. Before developing or formalizing a nontrivial proof, read
`notes/2026-07-07-named-expert-personas-context.md` and the relevant dossier. Do not load these for
status, routing, literature comparison, or ordinary read-only review.

## Literature cache: load on demand

Before re-fetching a paper for a literature task, read `/tmp/persistent/tavis/lit-search/README.md`
and query the shared disk-backed cache with
`python3 /tmp/persistent/tavis/lit-search/bin/litcache.py get <doi-or-arxiv-key>`; use `list` to
discover keys and `verify` to recheck the manifest hashes. `/tmp/persistent` is a ZFS mount, not the
RAM-backed `/tmp` tmpfs. The cache records fetched bytes, not that a paper was read. For user-supplied
scan sets such as `dye-1991/` and `bsw-1992/`, use the OCR reconstruction only for search and verify
load-bearing text or formulas against the adjacent authoritative page images and `SHA256SUMS`.

## Lean: load the detailed rules on demand

Before any Lean edit, generator run, build, staleness probe, or process intervention, read the
nested Lean guide completely: Codex uses [`lean/AGENTS.md`](lean/AGENTS.md), and Claude uses the
sibling `lean/CLAUDE.md` symlink to the same file. Discussion and document review alone do not
trigger it. Any future nested shared guide must likewise provide both names as one file plus a
symlink; agent-specific guidance must say so explicitly instead.

Always-on Lean safety summary:

- Never run two heavyweight Lake builds concurrently or build across a foreign dirty/stale closure.
- Use explicit targets, measured `LEAN_NUM_THREADS`, `choom`, and the prescribed CPU set; affinity
  does not limit Lake's worker count.
- Use `lean/scripts/guarded-lean` for guarded single-file elaboration and the unattended queue runner
  for long explicit target sequences. Do not repeatedly poll `ps` or watch healthy builds.
- Use trace/no-build checks for staleness; mtimes and existing oleans are not proof of freshness.
- `/tmp` is tmpfs: keep build trees, caches, backups, and multi-GB artifacts on disk under `/home`.
- Never `lake clean` while another lane may be using the shared build tree.

Shared-library validation:

- A lane that consumes `RelativeConicArcs` exits through its documented import-only module set under
  `RelativeConicArcs.Gates`, followed by an exact-target `--no-build` confirmation and the lane's
  documented axiom audit. The gate set must import every paper-facing terminal the lane claims;
  separate modules are allowed when independently compiled terminals cannot share one environment.
- If a change touches a module imported by another lane's gate, widen validation to every affected
  gate found by the reverse-import closure, or defer completion to the next quiescent aggregate
  check. Import-graph tooling and build orchestration remain owned by the `build-sys` lane.
- `RelativeConicArcs` itself is a repo-health check, not a lane exit gate. Run it only through the
  unattended build queue while that queue holds the shared build-owner lock and the Lean worktree
  is otherwise clean.
- Regenerate certificate sources only while holding that build window, against explicit generator
  roots. Commit the checker/schema change, every regenerated tracked leaf, and its green subtree
  gate atomically before releasing the window; never leave a regenerated tree between commits.
- Use the `build-sys`-owned guarded `lake pack` wrapper for artifact snapshots. Do not copy partial
  build directories or rely on a local Lake cache until its restore semantics have been separately
  verified.

The nested guide contains the measured memory caps, restart-sentinel protocol, process ancestry
checks, finite-certificate sharding rules, and exact command forms.

## Intent-based mode and short commands

Default mode is collaborative. `mi` enables intent-based mode for the rest of the current session;
a handoff may persist it with `Mode: intent-based` under its date. `yc` means “your call.” `vb`
means “vibe check”: translate the technical evidence into an honest progress assessment, including
momentum, risks, and likely route viability rather than merely reciting implementation status.
When stopping after a substantial full or partial C-item chunk, include a one-line vibe check in
the user-facing work report even when `vb` was not requested. End the same report with a standalone,
copy-pasteable `go C<id>` line naming the next allocated C item. If the next item is still behind a
pre-allocation gate, say so and use `go <lane>` instead; never fabricate an unallocated concrete ID.
Do not add routine vibe checks or resume commands to intermediate commentary, minor status updates,
or administrative/edit-only reports.

In intent-based mode, state and take a decision only when it is reversible, already permitted,
strongly lopsided (at least 80/20 from visible evidence), and does not change downstream shape.
Ordinary forward commits and local fast-forward-only updates are allowed.

Still ask before architecture choices, validation-gate changes, scope pivots, destructive git,
history rewrites, non-fast-forward changes, `git push`, or a real n=16 run.

## Command-output and source hygiene

- Be token-conservative: filter at the source, use explicit paths/patterns/fields, cap output, and
  inspect small ranges. Never dump whole logs, process tables, broad diffs, or repository-wide file
  lists into context.
- Use `~/.claude/bin/run-quiet "command args"` for noisy commands such as builds and deployments.
  Read only its bounded summary or a targeted diagnostic tail.
- Default tool output budgets to 1,000–2,000 tokens. More requires a specifically bounded artifact.
  If a command reports more than 10,000 original tokens, treat the inspection as incorrectly shaped:
  do not repeat it; replace it with a source-filtered query against the saved log.
- Search with `rg`/`rg --files`, but always scope repository-sized searches. Do not run an unbounded
  `git ls-files`, `find`, status dump, or diff when a narrow pathspec answers the question.
- Never use broad `ps -eo`, repeated `ps`/`free`/`df`, `list_agents`, `wait`, or `write_stdin` as a
  progress dashboard. Use an unattended runner with disk-backed status and inspect one bounded
  milestone only after genuine uncertainty or a user request.
- Do not rerun an unchanged build/elaboration after the same failure. First reduce the saved log to
  the first error, change the source or invocation, and only then retry.
- Never render a full ASG session into context. Analyze `asg +show --expand-tool-calls` through a
  bounded script, or use narrow role/date/session searches with capped hits and context.
- Batch related harmless local checks instead of triggering one permission review per command.
  Permission review must receive the minimal action context, never a growing full-session transcript.
- Run generators and formatters against explicit roots; afterward require changed paths to be a
  subset of the selected lane's allowlist.
- Stay current with Git after every coherent edit, especially after creating files: run a narrow
  `git status --short -- <owned-paths>`, account for every new/modified path, and do not leave
  untracked work to be rediscovered later. Untracked source, certificate, script, and documentation
  files are urgent because they are absent from every reproducibility claim until committed.
- As soon as a coherent task-owned change passes its scoped validation, stage explicit whole-file
  pathspecs and make a forward commit; no separate permission prompt is needed. Do not wait for the
  end of a long session or accumulate unrelated fixes into one commit. Before compaction, a lane
  switch, delegation handoff, or a long-running build, commit validated owned work or explicitly
  record why it remains uncommitted and exactly which paths comprise it.
- Fast commit cadence does not relax ownership or validation: never stage foreign-lane changes,
  generated debris, secrets, or a failing/incomplete change merely to make the tree look clean.
- Preserve dirty worktrees. Never use destructive reset/checkout operations unless explicitly
  requested.
- Stage non-interactively with explicit whole-file pathspecs or an exact cached patch. Never use
  `git add -p` or `git add -A`.

## Build, test, and dependencies

Build/test Rust through `rust/Makefile`: `make release`, `make test`, `make clippy`, `make fmt`.
Never substitute a bare `cargo build`; the Makefile injects the required znver5/mold flags. Quick
`cargo check`, `fmt`, `clippy`, and `test` are acceptable. Wrap noisy builds with `run-quiet`.

A change is not done until its validation gate passes. The Othello gate is cross-engine
value-equivalence (minimax/alphabeta/ordered/strong), the independent grid move/flip reference, and
exact endgames `6 / -40 / 4`. `strong+` and `strong++` deliberately change strength/value semantics.
Queens validation and n=16 sizing remain in `notes/queens-othello-perf-playbook.md`.

Use ecosystem crates properly (`clap`, `rayon`, `libc`, etc.); do not invent a no-dependency rule.

## Dormant performance work

Before any Queens/Othello hot-path implementation, benchmark, or n=16 work, read
`notes/queens-othello-perf-playbook.md`. It contains the validation gate, A/B harness, tmux protocol,
box hygiene, and layout rules.

Never declare a hard “floor,” “limit,” or “unreachable” result. Present the evidence and remaining
levers; the user decides what constitutes a limit.

## Handoffs, archives, and task IDs

All durable state lives in git-visible docs:

- A live handoff and the live queue are crisp state maps only: goal, current status, open frontiers,
  next steps, and one-line links to closed work.
- Companion `-archive.md` files are append-only history. Dated findings get their own `notes/` file.
- Write current conclusions cleanly; put correction trails and superseded reasoning in the archive.

Every task uses the global monotonic `CNN` sequence and is allocated in the live queue. Compute a new
ID as `max(CNN in queue + handoffs + notes/) + 1`; never reuse or renumber a reported ID. Examples
must use `C<id>`, never a concrete unallocated number.

Every task row carries exactly one lane peg at allocation:

```markdown
- **C<id> `[clebsch]` [QUEUED]** — one-line description → report path
```

Section placement is presentation; the peg is authoritative. Re-pegging is a lane switch and needs
explicit approval.

At session end: update the live map, move any accumulated history to the companion archive, append
the dated report, and commit docs with the code they describe. Move finished handoffs under
`notes/handoffs/done/` only after the user answers the lane-finish questions.
