# workspace guide

The repository contains the root Python `othello` package, the Rust port/Queens solver under
`rust/`, projective-cap/Nofil research, papers, and Lean developments. Queens/Othello performance
work is dormant unless explicitly resumed.

## Short commands

- **Intent-based mode:** `mi` enter it
  `yc` your call · `vb` vibe check, not Visual Basic
  `ej` extra juice: what more to squeeze, `ej<N>`: Nth order extra juice.
  `dof` what degrees of freedom are unexplained which we might be able to lock down
  `aa` alt-attacks: unstick a stuck proof, same I/O different method, or same objective diff I/O shapes
  `tt` terence-tao: what would Tao see or ask which we missed (*opportunities*, defects, other methods). This is more than just his expert profile mentioned later.
  `ev` what is your choice for the highest EV next move in this C task or in the lane if we're done this task
- **Lane routing:** `go <alias>` / bare alias select lane · `go` / `next?` next step, else ask
- **Startup context:** `go C<id>` select task + lane

## Startup context: load only what the task needs

This file is the always-loaded rules layer. Keep it short and stable. Follow it silently — do not
narrate or repeat these rules as you apply them; e.g., run the session-start C-task lane routing
without announcing the steps.

At the start of a session:

1. read this complete guide in a dedicated command with no other operation.
2. Select a lane from the user's explicit alias, named handoff, or named task — never infer it from
   git, a task ID's number, or the previous session. A bare `C<id>` or `go C<id>` selects that task
   **and its lane**: retrieve the single exact `C<id>` row from `notes/2026-07-07-codex-task-queue.md`
   with an anchored one-match query (`rg -n -m 1 '^- \*\*C<id> ' notes/2026-07-07-codex-task-queue.md`),
   treat its bracketed lane peg as authoritative, and read only that lane's entry handoff below. Do
   not search broadly for the ID or ask which lane it belongs to.
3. Read only that lane's entry handoff. It is the current-state map.
4. Otherwise, read `notes/2026-07-07-codex-task-queue.md` only for global task-ID allocation,
   explicit lane completion, or a user-requested cross-lane status. A selected lane's handoff owns
   its next step.

**Never read the queue in full.** It is tens of thousands of tokens of rows for lanes you are not
in, and no task needs more than its own row. Every access is a bounded query: an anchored exact-row
lookup for one ID, or a section-scoped query for one lane's rows. `Read` on that file with no
offset and limit, `cat`, and an unanchored search for a bare number are all command-shaping
failures. The same holds for the companion archive
`notes/2026-07-07-codex-task-queue-archive.md` and for
`notes/2026-09-05-queue-row-specifications.md`, which holds the verbatim pre-trim text of rows that
were once full task specifications: query them by exact ID when a row points you there, never as a
whole file.
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

When prior work pre-empts a proof/math crown you MUST run one bounded extraction pass per
`notes/novelty-extraction-conventions.md`, then close the failed task. Log only incidental gems
(with exact provenance) to the discovery track; no broad sweep, recursion, or cross-lane edits.

## Lane routing

A bare alias or `go <alias>` selects that lane; `hexagon` is a spoken synonym for `clebsch` (docs
and task pegs use `clebsch`). Bare `go` or `next?` means the next step in the selected lane, or —
with no lane selected — ask which lane. An explicit alias switches lanes.

| Alias | Entry handoff |
|---|---|
| `ame-lu` | `notes/handoffs/2026-07-24-ame-lu-paper.md` |
| `build-sys` | `notes/handoffs/2026-07-14-lean-build-system.md` |
| `cap` | `notes/handoffs/2026-07-06-projective-cap-game-handoff.md` |
| `clebsch` | `notes/handoffs/2026-07-13-clebsch-lane.md` |
| `complete-ports` | `notes/handoffs/2026-07-17-complete-ports-paper.md` |
| `continuation` | `notes/handoffs/2026-07-17-continuation-paper.md` |
| `crowns` | `notes/handoffs/2026-07-17-crowns.md` |
| `cubic` | `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md` |
| `cubic-threefolds` | `notes/handoffs/2026-08-15-cubic-threefolds.md` |
| `dihedral` | `notes/handoffs/2026-07-17-dihedral-paper.md` |
| `ergodis` | `notes/handoffs/2026-09-05-ergodis-lane.md` |
| `gem-mining` | `notes/handoffs/2026-07-14-gem-mining.md` |
| `golden` | `notes/handoffs/2026-07-31-golden-operator-paper.md` |
| `kayles` | `notes/handoffs/2026-07-04-node-kayles-games.md` (dormant) |
| `nofil` | `notes/handoffs/2026-07-17-nofil-paper.md` |
| `paper-frob-eq` | `notes/handoffs/2026-07-14-alternate-orbit-repair.md` |
| `quantum-codes` | `notes/handoffs/2026-08-25-quantum-codes.md` |
| `reed-solomon` | `notes/handoffs/2026-07-22-reed-solomon-deep-holes.md` |
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
- DO note foreign issues and raise them to the user.
- The queue records IDs and completion; it never overrides the selected lane's local order.

Named-expert context is not a lane. Before developing or formalizing a nontrivial proof, consult
only the applicable routing entry in
`notes/2026-07-07-named-expert-personas-context.md`, then read only the dossier(s) named by that
entry. Do not preload unrelated persona material, and do not load any of it for status, routing,
literature comparison, or ordinary read-only review.

## Paper prose: load on demand

Before any task that works directly on a manuscript under `papers/`, read
`papers/style-guide.md` completely. This is a routed read, not startup context.

## Standalone paper mirrors

### Related repositories

These rules follow the work, not the current directory or Git root. They apply
to every repository, worktree, extracted package, dependency checkout, release
tree, or cache used for an Othello paper or formal artifact, including the
mirrors below, `finitegeom*`, `.lake/packages/`, and review/release checkouts.
Changing roots relaxes nothing. Local READMEs and replay commands never override
this guide; if its guarded entry point cannot target a root, stop. Unless the
handoff says otherwise, extracted and synchronized copies are downstream:
edit and validate the monorepo authority first, then forward-commit the copy.

The authoritative manuscript sources remain under this repository's
`papers/`. Released papers also have standalone local Git mirrors
under `~/src/math-papers/<paper-alias>`.

Synchronization is one-way from this repository to those mirrors. Make manuscript edits here
first, then propagate and validate every intended public change in the matching standalone
repository. Do not treat edits made only in `~/src/math-papers/` as authoritative or merge them
back without an explicit user instruction. Preserve each standalone repository's existing history:
apply synchronized changes there as ordinary forward commits. Do not replace, reinitialize, or
re-export over an existing standalone repository unless the user explicitly requests that
destructive history replacement.

Before any paper-mirror synchronization, Lean companion export, certificate-package re-pin, or
other operation that writes under `~/src/math-papers/` or `~/src/lean/`, read
`notes/export-and-mirror-conventions.md` completely. This is a routed read, not startup
context.

## Literature cache: load on demand

Before re-fetching a paper for a literature task, read `/tmp/persistent/tavis/lit-search/README.md`
and query the shared disk-backed cache with
`python3 /tmp/persistent/tavis/lit-search/bin/litcache.py get <doi-or-arxiv-key>`; use `list` to
discover keys and `verify` to recheck the manifest hashes. `/tmp/persistent` is a ZFS mount, not the
RAM-backed `/tmp` tmpfs. The cache records fetched bytes, not that a paper was read. For user-supplied
scan sets such as `dye-1991/` and `bsw-1992/`, use the OCR reconstruction only for search and verify
every cited text or formula against the adjacent authoritative page images and `SHA256SUMS`.

When a deliverable depends on the absence of prior work — a novelty or priority verdict,
forward-citation closure, a manuscript-bound "to our knowledge" sentence, or a pre-emption check —
follow `notes/literature-audit-conventions.md` for how the
search and every consulted source must be recorded.

## Research records and computational reproducibility

A paper's statements are linked to their Lean coverage, imported literature, and
computational evidence by the gated annotation layer in
`notes/formal-annotation-conventions.md`; read it completely before adding or changing an
annotation, a claim-map row, a registry entry, or the checker that gates them, and before
adopting the layer in another paper. This is a routed read, not startup context.

Before any paper-facing computational claim you MUST follow
`notes/research-reproducibility-conventions.md`: commit the report, the exact script/generator, and
a compact certificate as one atomic, git-visible bundle, with the exact replay command,
the inputs needed for the claim, and SHA-256 hashes, plus an independent replay or a stated reason
none exists.
An untracked `/tmp` file, local cache entry, or a claimed run is never sole evidence for a
paper-facing result; state negatives with the exact searched domain and stop condition. That file
also lists the model reports (C246/C254/C255) to copy.

## Lean: load the detailed rules on demand

Before any Lean edit, generator run, build, staleness probe, or process intervention, read the
nested Lean guide completely: Codex uses `lean/AGENTS.md`, and Claude uses the
sibling `lean/CLAUDE.md` symlink to the same file. Discussion and document review alone do not
trigger it. Any future nested shared guide must likewise provide both names as one file plus a
symlink; agent-specific guidance must say so explicitly instead.

The trigger and nested rules apply to Lean work in every related root. Read this
checkout's canonical `lean/AGENTS.md` before operating on standalone packages,
dependencies, mirrors, or review/release trees. Never run direct `lake`,
`nix ... lake`, or equivalents. `run-quiet` supplies output capture and default
OOM preference, not the guarded entry point, build lock, quiet check, measured
profile, or worker cap. Build ownership and the one-heavy-build rule are
host-wide. Regeneration requires the owning build window and atomic validation.
If a guard cannot target the root, stop; never hand-compose a replacement.

## Intent-based mode and short commands

Default mode is intent-based (as in "Turn the ship around"'s
delegation style). `mi` enables intent-based mode for the rest of the
current session; a handoff may persist it with `Mode: intent-based`
under its date.

`yc` means “your call.” `vb` means “vibe check”: translate the
technical state *short* minimal summary (good/bad, (un)blocked,
disappointing/great, etc.) not a recitation.

`ej` means “extra juice”: from where we've landed, surface the extra
unexpected value now in reach — free or cheap upgrades on current
task, surprise implications of incidental findings, and doors the
result opens — not a restatement of the plan. If it's cheap now, do
it. Propose what to queue or discovery-track log. Also, what is
surprising and unexplained such as constrained or overly loose values.

Before the final report for every substantial math-research or proof C-item, run at least one
explicit `ej`+`tt` closeout pass after the main acceptance gate has passed. Do the free or cheap
task-owned upgrades it exposes, then add or refresh a **Mystery ledger** in the dated task report:
list each surprising or unexplained feature, mark what the `ej`+`tt` pass settled, and state the exact
evidence gap, gate, or owning successor for everything still open. Say explicitly when no genuine
mystery remains; do not manufacture one. Apply the discovery-track discriminator as usual, and
revalidate and commit any closeout changes before sending the final task report.

`aa` means “alt-attacks”: when a proof is stuck, lay out distinct alternative attack routes instead
of pushing harder on the current one.

When stopping after a substantial full or partial C-item chunk:
- include a one-line vibe check in the user-facing work report even when
`vb` was not requested.

- Finally end the same report with a standalone, copy-pasteable `go
C<id> <lane> <short description>` line naming the next `ev` C item
that logically follows the completed, or the next allocated C item if
EV isn't clear. If the next item is still behind a pre-allocation
gate, say so and use `go <lane>` instead; never fabricate an
unallocated concrete ID.  If you think there is a higher EV next move
(queued or not) suggest it!!

Do not add routine vibe checks or resume commands to intermediate
commentary, minor status updates, or administrative/edit-only reports.

In intent-based mode, state and take a decision only when it is reversible, already permitted,
strongly lopsided (at least 80/20 from visible evidence), and does not change downstream shape.
Ordinary forward commits and local fast-forward-only updates are allowed.

Still ask before architecture choices, validation-gate changes, scope pivots, destructive git,
history rewrites, non-fast-forward changes, `git push`, or a real n=16 run.

## Command-output and source hygiene

Token waste is a correctness failure. Tool output caps only truncate
context; they do **not** make broad commands safe. Every producer must
read only needed sources and emit a small, predictable result. Don't
narrate what you don't need to. Do not use [name](file) style md links
for filenames just use the plain name.

**Current-task handoff exception:** The line-count and display-token caps below do not apply to the
selected lane's live handoff or files it directs the agent to read. Read them in full, chunking only
to avoid tool truncation. This exception does not authorize other preloads or broad output, and it
never covers `notes/2026-07-07-codex-task-queue.md`, its archive, or the queue-row specifications
note: those are always bounded exact-row or single-lane queries, even when a handoff mentions them.

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
- **Codex only; Claude must ignore this item:** Enforce a hard delegation-wait budget. Spawn agents
  only when useful independent local work can run concurrently, exhaust that work before waiting.
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
- We are on NixOS. Use `nix shell`/`nix develop` or `uv` for Python dependencies
  such as SymPy, and use the Nix-provided Sage environment. Never assume that
  `python3`, `sympy`, or `sage` is available directly on `PATH`.
- Makefiles good
- Use libs properly (`clap`, `rayon`, `libc`, etc.); do not invent a no-dependency rule.

## Handoffs, archives, and task IDs

All durable state lives in git-visible docs:

- A live handoff and the live queue are crisp state maps only: goal, current status, open frontiers,
  next steps, and one-line links to closed work — never timelines, transcripts, validation output,
  or superseded plans.
- Companion `-archive.md` files are append-only history. Dated findings get their own `notes/` file.
- Write current conclusions cleanly; put correction trails and superseded reasoning in the archive.

The live queue is an allocation/open-work index: it MUST contain no `[REPORTED ...]` rows or other
completed-task rows. On completion you MUST follow `notes/task-lifecycle-conventions.md` — archive
the row, delete it from the queue, update the handoff, and log incidental gems, in one coherent
commit; archive-first, and never leave a `[REPORTED]` row even temporarily. Allocate IDs only via
`python3 notes/scripts/allocate_codex_task_ids.py reserve`; you MUST NOT derive, reuse, or renumber
an ID, and re-pegging a task's lane needs explicit approval. Row format and full mechanics are in
that file.

At session end: update the live map, move any accumulated history to the companion archive, append
the dated report, and commit docs with the code they describe. Move finished handoffs under
`notes/handoffs/done/` only after the user answers the lane-finish questions.

## Chat session reports

Keep your chat session reports to the user brief, organized and to the
point. User is busy and does not want to parse a wall of text. Use
numbered lists user can read fast and refer to in replies. DO NOT give
a travelogue. Details are for the on-disk reports. Speak to the user
with the precision you would use for a sub-agent. Use short-hand
anywhere it doesn't hurt clarity to save tokens. 
