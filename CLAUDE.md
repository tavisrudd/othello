# Othello workspace guide

The repository contains the root Python `othello` package, the Rust port/Queens solver under
`rust/`, projective-cap/Nofil research, papers, and Lean developments. Queens/Othello performance
work is dormant unless explicitly resumed.

## Short commands

- **Intent-based mode:** `mi` enter it · `yc` your call · `vb` vibe check, not Visual Basic ·
  `ej` extra juice: what more to squeeze · `aa` alt-attacks: unstick a stuck proof
- **Lane routing:** `go <alias>` / bare alias select lane · `go` / `next?` next step, else ask
- **Startup context:** `go C<id>` select task + lane

## Startup context: load only what the task needs

This file is the always-loaded rules layer. Keep it short and stable. Follow it silently — do not
narrate or repeat these rules as you apply them; e.g., run the session-start C-task lane routing
without announcing the steps.

At the start of a session:

1. Before any other repository operation, read this complete guide in a dedicated command with no
   search, status check, build, or other operation.
2. Select a lane from the user's explicit alias, named handoff, or named task — never infer it from
   git, a task ID's number, or the previous session. A bare `C<id>` or `go C<id>` selects that task
   **and its lane**: look up the exact `C<id>` row in `notes/2026-07-07-codex-task-queue.md`, treat
   its bracketed lane peg as authoritative, and read only that lane's entry handoff below. Do not
   search broadly for the ID or ask which lane it belongs to.
3. Read only that lane's entry handoff. It is the current-state map.
4. Otherwise, read `notes/2026-07-07-codex-task-queue.md` only for global task-ID allocation,
   explicit lane completion, or a user-requested cross-lane status. A selected lane's handoff owns
   its next step.
5. Do not preload archives, discovery logs, expert dossiers, paper sources, build manuals, or
   performance playbooks. Load them when the task or handoff points to them.

Every proof/math lane keeps one append-only discovery-track companion for incidental observations
and musings found during planned work. Discriminator — “was I looking for this?”: if yes, it is a
deliverable for the task report/ledger/handoff, not the discovery track. Logging a lead does not
allocate work, expand scope, or make it a handoff frontier; promotion uses the normal C-ID and
lane-routing process. Do not preload the log; open it to record an incidental observation and
review it at handoff. Follow `notes/discovery-track-conventions.md` when creating, appending,
promoting, or handing off a log.

### Novelty failures and adjacent-crown extraction

When prior work pre-empts a proof/math crown, run one bounded extraction pass: record the exact
pre-emption and surviving result; inspect the source's future work and primary/forward citations for
at most three adjacent gaps; formulate at most six distinct candidates; cheap-test the top two; and
allocate at most two that pass, after rechecking the global C-ID maximum. Then close the failed task
normally.

The analysis and rejected candidates belong in the task report or an owned portfolio. Log only
incidental “gem spotted while reading” observations outside the named audit questions, with exact
source provenance and no extra investigation. This rule permits no broad sweep, recursive expansion,
or cross-lane edits.

## Lane routing

A bare alias or `go <alias>` selects that lane; `hexagon` is a spoken synonym for `clebsch` (docs
and task pegs use `clebsch`). Bare `go` or `next?` means the next step in the selected lane, or —
with no lane selected — ask which lane. An explicit alias switches lanes.

| Alias | Entry handoff |
|---|---|
| `alt-orbit-repair` | `notes/handoffs/2026-07-14-alternate-orbit-repair.md` |
| `baer` | `notes/handoffs/2026-07-14-baer-equivariant-robust-completion.md` |
| `build-sys` | `notes/handoffs/2026-07-14-lean-build-system.md` |
| `cap` | `notes/handoffs/2026-07-06-projective-cap-game-handoff.md` |
| `clebsch` | `notes/handoffs/2026-07-13-clebsch-paper.md` |
| `complete-ports` | `notes/handoffs/2026-07-17-complete-ports-paper.md` |
| `continuation` | `notes/handoffs/2026-07-17-continuation-paper.md` |
| `crowns` | `notes/handoffs/2026-07-17-crowns.md` |
| `cubic` | `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md` |
| `dihedral` | `notes/handoffs/2026-07-17-dihedral-paper.md` |
| `gem-mining` | `notes/handoffs/2026-07-14-gem-mining.md` |
| `kayles` | `notes/handoffs/2026-07-04-node-kayles-games.md` (dormant) |
| `nofil` | `notes/handoffs/2026-07-17-nofil-paper.md` |
| `relconic` | `notes/handoffs/2026-07-17-c210.md` |

Archived lanes (handoffs under `notes/handoffs/done/`): `queens`, `repaircodes`, `repairports`,
`rp-next`.

Each handoff must declare exactly one `**Lane**: \`alias\`` directly under its H1. A cross-lane
deliverable is pegged to the lane that owns it, or split into separate tasks.

When a selected lane finishes, stop and ask separately whether to archive its handoff, update this
routing table, and which lane to select next.

Cross-lane hygiene:

- Treat other lanes' edits, commits, builds, and generated artifacts as foreign.
- Before editing, check the selected handoff's allowed paths. Explicit user scope can expand them.
- Do not review, stage, rebuild, kill, clean, or opportunistically fix foreign work.
- The queue records IDs and completion; it never overrides the selected lane's local order.

Named-expert context is not a lane. Before developing or formalizing a nontrivial proof, consult
only the applicable routing entry in
`notes/2026-07-07-named-expert-personas-context.md`, then read only the dossier(s) named by that
entry. Do not preload unrelated persona material, and do not load any of it for status, routing,
literature comparison, or ordinary read-only review.

## Literature cache: load on demand

Before re-fetching a paper for a literature task, read `/tmp/persistent/tavis/lit-search/README.md`
and query the shared disk-backed cache with
`python3 /tmp/persistent/tavis/lit-search/bin/litcache.py get <doi-or-arxiv-key>`; use `list` to
discover keys and `verify` to recheck the manifest hashes. `/tmp/persistent` is a ZFS mount, not the
RAM-backed `/tmp` tmpfs. The cache records fetched bytes, not that a paper was read. For user-supplied
scan sets such as `dye-1991/` and `bsw-1992/`, use the OCR reconstruction only for search and verify
load-bearing text or formulas against the adjacent authoritative page images and `SHA256SUMS`.

When a deliverable depends on the absence of prior work — a novelty or priority verdict,
forward-citation closure, a manuscript-bound "to our knowledge" sentence, or a pre-emption check —
follow `notes/literature-audit-conventions.md` for how the
search and every consulted source must be recorded.

## Research records and computational reproducibility

**Claude:** follow the evidence discipline in recent C-task reports. Models:
`notes/2026-07-17-c246-contextual-minimality.md` for a report/script/JSON certificate
bundle, `notes/2026-07-17-c254-two-terminal-reliability-log-concavity.md` for an exact sweep
plus an independent direct-enumeration replay,
`notes/2026-07-17-c255-gauge-invariant-coefficient-cost.md` for exact optima with a stated
literature boundary. Copy their pattern: state the theorem or bounded negative cleanly, name the
artifact supporting it, give the replay command, report exact checked counts and conventions, and
delimit what the computation does not prove. Do not replace that evidence with a narrative of what
was tried or a pasted terminal transcript.

Treat every computational research claim as an atomic, git-visible evidence bundle. For new work, or
whenever an older computation materially changes, commit the dated report, the exact script or
generator, and its compact machine-readable output/certificate together. Keep them adjacent under
the owning lane's allowed paths, with a common stem when practical, e.g. `<date>-c<id>-<slug>.md`,
`.py`, `.json`, and `.sha256`/`SHA256SUMS`. A prose report citing an untracked script, an ephemeral
transcript, or an uncommitted output is not a reproducibility claim.

Each report backed by computation must record:

- the exact command and working directory to regenerate or check the artifact;
- all load-bearing inputs, parameters, field/radius/size conventions, dependency versions when
  relevant, and random seeds (prefer deterministic canonical enumeration over randomness);
- what each output certifies, what it does not certify, and the trusted boundary of the checker;
- SHA-256 hashes and byte counts for the script/generator and every load-bearing output, either in
  the report or in a committed checksum manifest; and
- an independent replay, reference implementation, invariant check, or explicit explanation of why
  no independent cross-check is available.

Outputs must be canonical and stable: sort unordered objects, fix serialization, avoid timestamps
and host-specific paths, and make regeneration fail loudly on schema or convention drift. Prefer a
`--check` mode that regenerates in a temporary location, verifies hashes/content against the tracked
artifact, and leaves the worktree unchanged. Never hand-edit generated evidence. When a generator,
schema, or input changes, regenerate the complete affected output set, update its hashes and report,
validate it, and commit all parts atomically.

Do not put multi-gigabyte evidence in Git merely to satisfy this rule. If a necessary artifact is
too large, stop and define an approved certificate/sharding strategy first. Commit a compact
manifest containing the generator/input hashes, exact command, schema version, shard/root hashes,
byte counts, and durable storage location; commit any compact independently checkable certificate.
An untracked `/tmp` file, local cache entry, or claimed successful run is never the sole evidence
for a paper-facing result.

Keep live handoffs and queues free of raw logs and validation transcripts. Put durable conclusions
and bounded evidence summaries in the dated task report; keep noisy run logs on disk and cite only
their stable path/hash when they remain necessary. State negative computational results with the
exact searched domain and stop condition—never promote finite exhaustion into an unrestricted
nonexistence claim.

## Lean: load the detailed rules on demand

Before any Lean edit, generator run, build, staleness probe, or process intervention, read the
nested Lean guide completely: Codex uses `lean/AGENTS.md`, and Claude uses the
sibling `lean/CLAUDE.md` symlink to the same file. Discussion and document review alone do not
trigger it. Any future nested shared guide must likewise provide both names as one file plus a
symlink; agent-specific guidance must say so explicitly instead.

The nested guide holds the always-on build-safety rules, the shared-library
(`RelativeConicArcs.Gates`) validation and exit protocol, measured memory caps, the restart-sentinel
protocol, process ancestry checks, finite-certificate sharding rules, and exact command forms.

## Intent-based mode and short commands

Default mode is collaborative. `mi` enables intent-based mode for the rest of the current session;
a handoff may persist it with `Mode: intent-based` under its date.

`yc` means “your call.” `vb` means “vibe check”: translate the technical evidence into a candid
progress assessment (good/bad, disappointing/great, etc.) — momentum, risks, and likely route
viability, not a recitation of implementation status.

`ej` means “extra juice”: from where we've landed, surface the extra value now in reach — free or
cheap upgrades, implications of incidental findings, and doors the result opens — not a restatement
of the plan.

`aa` means “alt-attacks”: when a proof is stuck, lay out distinct alternative attack routes instead
of pushing harder on the current one.

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

Token waste is a correctness failure. Tool output caps only truncate context; they do **not** make
broad commands safe. Every producer must read only needed sources and emit a small, predictable
result.

**Current-task handoff exception:** The line-count and display-token caps below do not apply to the
selected lane's live handoff or files it directs the agent to read. Read them in full, chunking only
to avoid tool truncation. This exception does not authorize other preloads or broad output.

**Before every `rg`, `grep`, `find`, or equivalent call, all of these must be visible in the
command:**

1. The narrowest known file/directory scope. Bare `.`, `..`, a workspace root, or unrestricted
   recursion is forbidden when a narrower path is known.
2. A selective pattern. Never search a repository for a bare/common number, single punctuation
   mark, or broad alternation such as `C210|210`. Resolve task IDs only by an anchored exact-row
   query in the live queue.
3. A global output bound: target 10 lines and never exceed 20 unless a known need is stated first
   and the command has an explicit larger bound. In multi-file searches, `-m/--max-count` limits
   each file, not the total; add a final `head`. Truncate fields/characters when lines may be huge.
4. Exclusions for bulk/generated domains unless explicitly targeted: large CSV/JSON data, generated
   certificates, build trees, Git internals/worktrees, archives, and frozen outputs.

If result size is uncertain, first run a bounded filename listing/count, then inspect content in a
narrower call. Do not search if any requirement is missing. `max_output_tokens`, terminal
truncation, and intent to inspect only the beginning are not source-side bounds.

```text
# Good: exact task lookup in one known file, with one match.
rg -n -m 1 '^- \*\*C210 ' notes/2026-07-07-codex-task-queue.md

# Good: bounded discovery under the one relevant source subtree.
rg -l -m 1 'collision curve' papers/arcs_complete_outside_conic -g '*.py' | head -n 20

# Forbidden: broad root plus common numeric alternative; an output budget does not rescue it.
rg -n 'C210|210' ..
```

- Apply the same 10-line target and 20-line ceiling to non-search commands. Source-filter with
  explicit fields/pathspecs and small ranges; never dump whole logs, process tables, broad diffs,
  or repository-wide file lists into context.
- Use `~/.claude/bin/run-quiet "command args"` for noisy commands such as builds and deployments.
  Read only its bounded summary or a targeted diagnostic tail.
- Default tool output budgets to 1,000–2,000 tokens. More requires a specifically bounded artifact.
  Over 10,000 original tokens is a command-shaping failure: stop, do not inspect or repeat it, record
  the failure, and replace it with a source-filtered query against the saved log.
- Prefer `rg`/`rg --files` over `grep`/`find`, subject to the same hard preflight. Do not run an
  unbounded `git ls-files`, status dump, or diff when a narrow pathspec answers the question.
- Never use broad `ps -eo`, repeated `ps`/`free`/`df`, `list_agents`, `wait`, or `write_stdin` as a
  progress dashboard. Use an unattended runner with disk-backed status and inspect one bounded
  milestone only after genuine uncertainty or a user request.
- **Codex only; Claude must ignore this item:** Enforce a hard polling budget for running tool
  cells. Call `functions.wait` only after the cell
  has explicitly yielded a running ID, set `yield_time_ms` to 60000, and call it at most twice for
  that cell. If two waits do not complete it, do not poll it again: continue independent work or
  leave the job with a durable unattended status path. Start work expected to exceed that budget
  through an unattended runner in the first place; never shorten the timeout to manufacture updates.
- **Codex only; Claude must ignore this item:** Enforce a hard delegation-wait budget. Spawn agents
  only when useful independent local work can
  run concurrently, exhaust that work before waiting, then call `wait_agent` at most once per
  delegation batch with `timeout_ms: 60000`. If agents remain active, rely on their completion
  notifications or continue other work; do not call `wait_agent` again and do not use `list_agents`
  to poll them. A targeted `list_agents` call is allowed only to diagnose genuinely inconsistent
  orchestration state, not to check progress.
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
  next steps, and one-line links to closed work — never timelines, transcripts, validation output,
  or superseded plans.
- Companion `-archive.md` files are append-only history. Dated findings get their own `notes/` file.
- Write current conclusions cleanly; put correction trails and superseded reasoning in the archive.

**Hard completion invariant:** the live task queue is an allocation/open-work index, not a
completion ledger. It must contain **no `[REPORTED ...]` rows and no other completed-task rows**.
When a task completes, perform all of the following in the same coherent commit:

1. append its completed row to `notes/2026-07-07-codex-task-queue-archive.md`;
2. verify that its `C<id>` occurs there exactly once;
3. delete its row from `notes/2026-07-07-codex-task-queue.md`; and
4. update the owning lane's handoff; and
5. before sending the user-facing completion report, review the work just closed against the
   discovery-track discriminator and append any genuinely incidental observations or musings to
   the lane's companion log. Do not manufacture an entry when there was none; retain the handoff's
   one-line companion link either way.

Archive first: if the completed row is not yet present in the companion archive, that is a blocker
to deleting it, not a reason to leave `[REPORTED]` history in the live queue. Never transition a
live queue row to `[REPORTED]`, even temporarily.

Every task uses the global monotonic `CNN` sequence. Allocate one ID or a contiguous block only by
running `python3 notes/scripts/allocate_codex_task_ids.py reserve` from the repository root with
`--count N`, `--lane <alias>`, and `--purpose '<bounded purpose>'`. Use only the returned IDs and
immediately commit the updated allocation ledger before dispatching or using them in queue rows.
Never derive IDs from repository text, treat `peek` as an allocation, reuse or renumber an ID, or
use `notes/scripts/next_codex_task_id.py` for anything except auditing. Examples must use `C<id>`,
never a concrete unallocated number.

Every task row carries exactly one lane peg at allocation:

```markdown
- **C<id> `[clebsch]` [QUEUED]** — one-line description → report path
```

Section placement is presentation; the peg is authoritative. Re-pegging is a lane switch and needs
explicit approval.

At session end: update the live map, move any accumulated history to the companion archive, append
the dated report, and commit docs with the code they describe. Move finished handoffs under
`notes/handoffs/done/` only after the user answers the lane-finish questions.
