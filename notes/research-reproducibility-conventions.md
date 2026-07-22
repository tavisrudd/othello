# Research records and computational reproducibility

CLAUDE.md routes here before any paper-facing computational claim and keeps the always-on rule (an
untracked `/tmp` file or a claimed run is never sole evidence). This file holds the mechanics.

## Evidence bundle

**Claude:** follow the evidence discipline in recent C-task reports. Treat every computational
research claim as an atomic, git-visible evidence bundle. For new work, or whenever an older
computation materially changes, commit the dated report, the exact script or generator, and its
compact machine-readable output/certificate together. Keep them adjacent under the owning lane's
allowed paths, with a common stem when practical, e.g. `<date>-c<id>-<slug>.md`, `.py`, `.json`, and
`.sha256`/`SHA256SUMS`. A prose report citing an untracked script, an ephemeral transcript, or an
uncommitted output is not a reproducibility claim.

## Each report backed by computation MUST record

- the exact command and working directory to regenerate or check the artifact;
- all load-bearing inputs, parameters, field/radius/size conventions, dependency versions when
  relevant, and random seeds (prefer deterministic canonical enumeration over randomness);
- what each output certifies, what it does not certify, and the trusted boundary of the checker;
- SHA-256 hashes and byte counts for the script/generator and every load-bearing output, either in
  the report or in a committed checksum manifest; and
- an independent replay, reference implementation, invariant check, or explicit explanation of why
  no independent cross-check is available.

## Canonical, stable outputs

Outputs must be canonical and stable: sort unordered objects, fix serialization, avoid timestamps
and host-specific paths, and make regeneration fail loudly on schema or convention drift. Prefer a
`--check` mode that regenerates in a temporary location, verifies hashes/content against the tracked
artifact, and leaves the worktree unchanged. Never hand-edit generated evidence. When a generator,
schema, or input changes, regenerate the complete affected output set, update its hashes and report,
validate it, and commit all parts atomically.

## Large artifacts

Do not put multi-gigabyte evidence in Git merely to satisfy this rule. If a necessary artifact is
too large, stop and define an approved certificate/sharding strategy first. Commit a compact
manifest containing the generator/input hashes, exact command, schema version, shard/root hashes,
byte counts, and durable storage location; commit any compact independently checkable certificate.
An untracked `/tmp` file, local cache entry, or claimed successful run is never the sole evidence
for a paper-facing result.

## Live docs and negative results

Keep live handoffs and queues free of raw logs and validation transcripts. Put durable conclusions
and bounded evidence summaries in the dated task report; keep noisy run logs on disk and cite only
their stable path/hash when they remain necessary. State negative computational results with the
exact searched domain and stop condition — never promote finite exhaustion into an unrestricted
nonexistence claim.

## Model reports to copy

- `notes/2026-07-17-c246-contextual-minimality.md` — report/script/JSON certificate bundle
- `notes/2026-07-17-c254-two-terminal-reliability-log-concavity.md` — exact sweep plus an
  independent direct-enumeration replay
- `notes/2026-07-17-c255-gauge-invariant-coefficient-cost.md` — exact optima with a stated
  literature boundary

Copy their pattern: state the theorem or bounded negative cleanly, name the artifact supporting it,
give the replay command, report exact checked counts and conventions, and delimit what the
computation does not prove. Do not replace that evidence with a narrative of what was tried or a
pasted terminal transcript.
