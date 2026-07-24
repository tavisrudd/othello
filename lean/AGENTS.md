# Lean workspace instructions

These instructions apply under `lean/`. `CLAUDE.md` is a symlink to this file, so Codex and Claude
receive identical guidance.

## Before acting

- For a nontrivial Lean proof, first load the named-expert umbrella and relevant dossier named by
  the parent guide. Discussion or document review alone does not trigger that context.
- Before any task that adds, edits, or reviews prose in a Lean source or generated Lean artifact,
  read `../papers/style-guide.md` completely. This is a routed read, not startup context.
- Treat every other lane's sources, generated files, build tree, and running process as owned state.
  Never edit, build, stop, clean, or regenerate a foreign closure.
- Never run two heavyweight Lake builds in the shared tree. CPU affinity does not isolate memory or
  artifacts, and Lake's configuration lock does not serialize builds.

## Supported entry points

Do not hand-compose `taskset`/`LEAN_NUM_THREADS`/`choom`/Nix/Lake commands.

Single-file elaboration:

```sh
lean/scripts/guarded-lean RelativeConicArcs/Module.lean
```

It defaults to cores `20-23`, one thread, `choom=1000`, and automatically runs through
`~/.claude/bin/run-quiet`. See `guarded-lean --help` for exceptional overrides.

If several elaborations need the same exceptional overrides, set them once for the current agent
session instead of repeating environment assignments on every call:

```sh
lean/scripts/guarded-lean --session-set \
  LEAN_GUARD_CPUSET=20-21 LEAN_GUARD_THREADS=2 LEAN_GUARD_PROFILE=q25-two-witness
lean/scripts/guarded-lean RelativeConicArcs/First.lean
lean/scripts/guarded-lean RelativeConicArcs/Second.lean
lean/scripts/guarded-lean --session-clear
```

The wrapper keys the disk-backed settings by `CODEX_THREAD_ID`/the available Claude session ID, so
concurrent agent sessions do not share overrides. An explicit environment variable on one invocation
wins over the saved value. Do not create a shared cross-session environment file.

Unattended builds:

```sh
lean/scripts/lean-build-queue.py plan --profile q25-two-witness --threads 2
lean/scripts/lean-build-queue.py run Target.One Target.Two \
  --profile q25-two-witness --threads 2 \
  --serial-first Heavy.Shared.Checker \
  --aggregate Final.Aggregator --cores 20-21
lean/scripts/lean-build-queue.py status ~/.cache/othello-lean-build/run-<id>
```

For a long gate, add `--detach`. The command returns the generated run directory immediately; the
detached queue process remains the watcher, and its atomic `status.json` records success, failure,
interruption, or abandonment without agent polling:

```sh
lean/scripts/lean-build-queue.py run Target.One Target.Two \
  --profile single --threads 1 --cores 20-23 --detach
```

C225 also provides an adjacent, explicitly selected systemd-managed path. It does not replace or
redirect the legacy command above during the parallel rollout. Supply the current harness session,
lane, and caller-attested C-task either with the documented `OTHELLO_*` parent-session environment
or explicit options. The command blocks in one event-driven wait and prints exactly one bounded
completion envelope:

```sh
lean/scripts/lean-build-systemd.py run Target.One Target.Two \
  --profile single --threads 1 --cores 20-23 \
  --harness codex --session-id "$CODEX_THREAD_ID" --lane build-sys --task-id C225
```

If the primary waiting client is lost, reattach to its immutable run directory without stopping or
resubmitting the service:

```sh
lean/scripts/lean-build-systemd.py await \
  ~/.cache/othello-lean-build-systemd/run-<uuid> --timeout 3600
```

Use the bounded managed queue view to distinguish concurrent harness/lane/task ownership. The
default table abbreviates session IDs only far enough to remain unambiguous within the displayed
rows; machine output retains the full session and effective-account attribution. An exact run query
is read-only and does not await, stop, reset, or resubmit its unit:

```sh
lean/scripts/lean-build-systemd.py list --limit 20
lean/scripts/lean-build-systemd.py list --run-id run-<uuid-without-dashes> --json
```

The listing reads only restrictive managed run records and exact bound systemd units. It skips
unsafe or malformed run entries with bounded stderr diagnostics and never searches the process
table.

Exit 124 is a non-mutating caller timeout, 125 means state or supervisor evidence is insufficient,
and 126 is externally observed abandonment. Consumers deduplicate recovery delivery by the stable
`event_id`. The managed path uses the same build-owner lock and measured worker controls as the
legacy path, but keeps separate managed run directories. Do not run a real Lean target through it
until the build-sys quiet-window gate is confirmed.

Interpret managed status narrowly: `queued/waiting-for-lock` means the worker exists but does not
own the tree; `running/quiet-preflight` means it owns the lock; `running/building` or
`running/aggregate-gate` means the named child was spawned; only a terminal completion envelope
after service exit establishes released resources and the recorded outcome.

A failed build names its target in the envelope's `failed_target` and `reason`; the Lean error itself
is in the run directory's `logs/`. A managed run does not inherit the agent shell's environment, so
pass anything it needs explicitly.

The runner automatically:

- acquires the shared build-owner lock before checking quiet state;
- validates the measured resource profile and thread cap;
- reads RAM, mount, and tmpfs usage silently—never print `ps`, `df`, or memory tables into context;
- refuses memory-backed run state and unsafe RAM/tmpfs budgets;
- builds `--serial-first` dependencies with one thread;
- sends every real Lake build through `run-quiet`, with logs under disk-backed run state;
- probes each target with `lake build --no-build`, skips trace-current targets, and fails fast;
- records atomic status, per-target GNU-time telemetry, source/toolchain state, and a final trace-only
  aggregate gate.

Resource measurements live in `lean/scripts/lean-build-profiles.json`. Unknown work uses the
strictly serial `single` profile. Add or raise a profile only from a representative GNU `time -v`
measurement and the reserve formula; never derive a cap from `nproc` or another target family.
`choom=1000` remains the default. Use `500` only when the user explicitly prioritizes this build and
has coordinated other jobs to remain sacrificial.

Artifact backup:

```sh
lean/scripts/lean-build-queue.py pack ~/lean-backups/<name>.tgz
```

`pack` takes the same ownership lock, refuses active foreign Lean work, refuses overwrite and
memory-backed destinations, and runs `lake pack` through `run-quiet`.

## Shared-library validation

- A lane that consumes `RelativeConicArcs` exits through its documented import-only module set under
  `RelativeConicArcs.Gates`, followed by an exact-target `--no-build` confirmation and the lane's
  documented axiom audit. The gate set must import every paper-facing terminal the lane claims;
  separate modules are allowed when independently compiled terminals cannot share one environment.
- If a change touches a module imported by another lane's gate, widen validation to every affected
  gate found by the reverse-import closure, or defer completion to the next quiescent aggregate
  check. Import-graph tooling and build orchestration remain owned by the `build-sys` lane.
- `RelativeConicArcs` itself is a repo-health check, not a lane exit gate. Run it only through the
  unattended build queue while that queue holds the shared build-owner lock and the Lean worktree is
  otherwise clean.
- Regenerate certificate sources only while holding that build window, against explicit generator
  roots. Commit the checker/schema change, every regenerated tracked leaf, and its green subtree
  gate atomically before releasing the window; never leave a regenerated tree between commits.
- Snapshot artifacts only through the guarded `pack` command above; do not copy partial build
  directories or rely on a local Lake cache until its restore semantics are separately verified.

## Staleness, restart, and recovery

- Content traces and exact-target `lake build --no-build` are authoritative. Mtimes and existing
  oleans are not.
- Never use `--old` for a validation gate. A single-file elaboration against a last-built foreign
  dependency is only a smoke test and must be labeled as such.
- Before restarting a large build, stop only its verified owning process, choose sentinels explicitly
  printed as `Built`, and use:

```sh
lean/scripts/lean-restart-guard.py checkpoint /home/<checkpoint> <sentinels...>
lean/scripts/lean-restart-guard.py audit-log /home/<checkpoint> <restart-log>
lean/scripts/lean-restart-guard.py verify /home/<checkpoint>
```

- The restart guard hashes `.olean`, `.olean.hash`, `.ilean.hash`, and `.trace`; it is not a backup.
  Pair uncertain work with the guarded `pack` command.
- Never use `/tmp` for build trees, caches, checkpoints, packs, or large logs. `/tmp` is tmpfs on
  this host and counts against RAM.

## Proof-engineering invariants

- Finite-certificate sharding must cross module boundaries. Splitting cases or tactics inside one
  module does not bound elaborator memory. Use a definitions-only base, bounded leaf modules, and a
  light aggregator; land leaves before probing the aggregator.
- If `decide`/`norm_num` is blocked by an opaque finite operation, introduce one reducible table
  evaluator and prove a symbolic bridge instead of unfolding the operation in every case.
- When a finite object is the image of a much smaller parameter space, run exhaustive predicates
  on the parameters and transport the result symbolically to image membership. Avoid repeatedly
  filtering, deduplicating, or taking products of the materialized image inside native terminals;
  this can turn a bounded coefficient-space check into a much larger object-space computation.
- Describe a native terminal's trust route from the pinned toolchain's actual `#print axioms`
  output. Do not infer or preserve an implementation axiom name from an older Lean version; native
  decision may expose declaration-local axioms rather than a historically familiar global name.
- Freeze narrow generated checker/schema cores for a certificate generation. Put transport,
  convenience, and paper-facing theorems downstream so prose/API growth does not invalidate leaves.
- In a focused target, a dependency finishes before its consumer; wide builds can still co-schedule
  unrelated siblings. Use the profile's serial-first boundary rather than assuming all workers have
  the same peak.

## Referee-facing prose and names

The referee-facing Lean artifact comprises every tracked `.lean` file, whether human-written or
generated, and every generator, schema, template, certificate, data file, banner, and diagnostic
needed to understand, reproduce, or check those files. Treat it as part of the permanent scholarly
record. A reader with that artifact and the cited public literature must be able to understand its
mathematical intent and verification boundary without task queues, handoffs, agent sessions, chat
transcripts, private planning documents, or machine-local state.

Operational guides and orchestration state are not scholarly evidence and the artifact must never
refer to them. If the distributed artifact is the entire `lean/` directory, either move such files
outside the distribution or define a declared, reproducible packaging allowlist that excludes them.
This standard applies to module headers, docstrings, ordinary comments, private and public names,
filenames, generated-source banners, paths, and user-facing diagnostic text. It does not authorize
cross-lane edits, certificate regeneration, or rebuilds outside the ownership rules above.

### Comments and docstrings

- Explain mathematics and verification: state the objects and conventions in use, the role of a
  non-obvious definition or lemma, the reason a proof step is valid, and the exact proposition a
  finite certificate checks. Prefer a precise invariant or proof idea over a narration of tactics.
- A declaration is scholarly-public when it is non-`private` and imported across a module boundary,
  exported by a terminal or gate, cited by a paper, or intended for reuse in another proof. Give
  every scholarly-public theorem and every non-obvious scholarly-public definition a self-contained
  docstring. The workflow-reference, status-prose, naming, and filename bans apply to the entire
  referee-facing artifact, including private helpers and generated leaves.
- A self-contained module header or docstring identifies the mathematical objects, ambient
  structures, quantifier domain, nonstandard notation, normalization and degeneracy conventions,
  and the exact hypotheses and conclusion in ordinary mathematical language to the extent needed
  to remove ambiguity. Do not rely on “as above,” “as in the paper,” a mutable section or equation
  number, “the usual convention,” or a declaration name as the only explanation. A module header
  must delimit its scope and, when relevant, identify its terminal results and trust boundary.
- Reference direction is mandatory and one way. An internal queue, handoff, report, or note that
  states or relies on a formal result must cite its exact Lean module and fully qualified
  declaration. No Lean source or enduring verification artifact may mention, link to, derive
  authority from, or require an internal record. This ban includes `C<id>` task IDs and spelling
  variants, lane and work-item labels, agents or models, session identifiers, private URLs, issue or
  review identifiers, commits, attempt chronology, and local filesystem paths. Trackedness does not
  create an exception. Replace such references with the mathematical object, formal dependency, or
  precise limitation they were being used to denote.
- A repository-local artifact may be cited only when it is part of the enduring verification
  apparatus: it has a stable repository-relative path outside internal-note and workflow
  directories; contains no private workflow identifiers; states its mathematical semantics and
  trust role independently; and is either consumed by the formal check or is the tracked
  reproducibility source for data consumed by it. Name the exact artifact and explain what it
  establishes and what remains trusted. A merely tracked report, log, transcript, or ad hoc output
  never qualifies.
- Do not leave status prose such as “remaining seam,” “current approach,” “prototype for the next
  task,” “will be proved later,” `TODO`, `FIXME`, “future work,” “pending,” “next,” “temporary,”
  “fallback,” “for now,” or “known issue” in the artifact. A limitation is admissible only when it
  is a precise restriction on hypotheses, conclusion, coverage, or trusted base, with no plan or
  forecast. Put work history and plans in the owning handoff or report.
- Generated sources must identify themselves as generated and name the semantic data they encode.
  Whenever generated content is needed for a claim, name its tracked generator and schema. Generation
  metadata must not substitute for a mathematical description or contain private workflow
  identifiers. Never hand-edit generated output to repair its prose; fix the generator and
  regenerate it only in the owning, validated build window.
- For every computationally discharged claim, state whether checking occurs by kernel reduction, a
  proved checker, native evaluation, an imported certificate, or an axiom; identify the finite
  domain and the theorem connecting the computation to the mathematical statement; distinguish
  exhaustive checking from sampled or search evidence; and state what remains trusted. Do not call
  externally generated data “proved by Lean” unless Lean checks both its semantics and coverage.
  Disclose any `sorry`, axiom, opaque oracle, or non-kernel execution in the dependency closure in
  the module header and cover it in the axiom audit.
- Cite an external result with its authors, title, year, stable identifier and version when
  available, and a pinpoint theorem, lemma, or page; state exactly what is used. A bare bibliography
  key, author-year, URL, or paper-section reference is insufficient. Do not cite an internal report
  as mathematical authority or imply that uncited literature does not exist.
- Comments must agree with the elaborated statement. Update or remove them in the same change when
  hypotheses, conventions, scope, or trust assumptions change. Do not use comments to imply a
  stronger theorem than Lean checks.

### Names

- Choose stable mathematical names that describe the object or proposition: the subject, relevant
  hypotheses or construction, and conclusion when distinction is needed. Names should remain
  sensible after task completion and outside the paper's current section numbering.
- Never encode a task ID, lane, agent, date, attempt number, or planning status in a module,
  namespace, declaration, or `.lean` filename. Avoid workflow labels such as `Prototype`,
  `Draft`, `Temporary`, `Final`, or `MainTheorem`; say what the object is. A legacy identifier may
  survive only during an explicit compatibility migration; it must not be imported, re-exported, or
  cited by a new scholarly API, and it must be removed before the referee-facing artifact is cut.
  Schedule generated or certificate cleanup under its owner rather than editing it incidentally.
- A strength-bearing name such as `complete`, `classification`, `unique`, `optimal`, `minimal`,
  `maximal`, `sharp`, `canonical`, or `universal` is permitted only when the declaration's type
  proves that property on an explicit domain relative to an explicit comparison relation, or its
  docstring points to an exact Lean theorem that does so. A definition that merely chooses a
  representative does not establish canonicity. Use `chosen`, `normalized`, or another qualified
  descriptive term unless choice-independence, invariance, or a precisely named standard convention
  is formally established. State the domain, comparator, and witness or converse supplying the
  advertised strength.
- Semantic schema or format versions are allowed only when documented as such. Dates, run numbers,
  shard build order, task numbers, and attempt numbers are not semantic versions; shard names must
  encode a mathematical partition, not generation chronology.
- Local names may be concise, but avoid unexplained project-specific abbreviations. Public names
  use stable standard mathematical terminology, expanded enough to be intelligible without the
  accompanying paper. Papers and internal records cite the exact Lean names. If a paper uses
  different notation or terminology, explain the correspondence in prose rather than encoding
  mutable manuscript labels or chronology in Lean names.

### Novelty and priority claims

Lean establishes that a formal statement follows from its declared assumptions; it does not
establish that the result is new, first, previously unknown, or absent from the literature. Do not
make novelty or priority claims in Lean names or prose. Put any such claim in the paper or its
literature-audit record, with the scope, date, search method, and sources required by the parent
guide. The ban includes direct and indirect claims such as `novel`, `new`, `first`, `previously
unknown`, `apparently`, `to our knowledge`, `we introduce`, `our improvement`, `stronger than
previously known`, `only known proof`, `first formalization`, and any claim that a literature search
is exhaustive. Lean may state a precise formal implication between internally formalized theorems,
but may not turn it into a historical or priority comparison. In Lean, state only the formal
mathematical result and cite known antecedents factually. Claims of sharpness, optimality,
completeness, or classification are mathematical rather than historical, but may be used only to
the exact extent witnessed by a theorem as required under Names above.

### Review gate

Before landing an added, renamed, or modified module, audit the entire module, not only changed
lines, plus every changed name, pathname, generated banner, template, generator, schema,
certificate, and user-facing diagnostic in its verification closure. No grandfathering applies to
comments or docstrings in a touched module. Confirm that every repository-local reference resolves
to a Lean module or declaration or to an enduring verification artifact satisfying the closed
definition above; external references must resolve to stable public literature. Confirm that every
scope and strength claim matches a formal statement, computational claims disclose their method and
trust boundary, and no private workflow vocabulary or reverse reference remains.

Check contents and pathnames for task-ID variants, including case changes, separators, bare work
item numbers in workflow context, and placeholders such as `C<id>`. Semantically inspect for lane
names, agents or models, sessions, internal paths or URLs, status language, and indirect reverse
references. Ordinary mathematical notation can resemble an ID, so automated searches are a
backstop rather than a substitute for referee review.

Before claiming that a module or gate backs a paper, apply the same review to every project-owned
file in its transitive verification closure, including generated modules and non-Lean artifacts
needed for the claim; reviewing only files changed by the current task is insufficient. Legacy
violations outside the current owner's safe edit scope must be recorded for an explicit cleanup
rather than silently waived or opportunistically edited. The artifact cannot be declared
referee-ready until they are resolved. This prose review is required in addition to elaboration,
gate builds, and axiom audits.

## Failure and ownership discipline

- Do not poll a healthy build. Read the runner's atomic `status` only when needed; it distinguishes
  running, success, failure, interruption, and abandoned/OOM state without trusting PIDs.
- Do not stream or re-request a large Lean failure. `guarded-lean` already logs through `run-quiet`;
  inspect only the first error and a small neighborhood. More than 10,000 reported original tokens
  means the diagnostic shape failed and must be narrowed before another elaboration.
- Never run broad `ps`, `pgrep`, or `df` commands manually. The wrappers perform silent narrow
  checks. If sandbox PID visibility leaves foreign ownership uncertain, stop and ask the owner/user;
  do not infer permission from an empty process result.
- Low available memory without a recorded failure is pressure, not authorization to intervene.
  Repeated exit 137 from your own queue means the profile is wrong: stop only the owned queue, lower
  the cap, and restart from trace-current targets. Never kill an individual worker.
- Never `lake clean` while any lane may use the shared tree. Never opportunistically rebuild a
  foreign dirty or stale dependency.
