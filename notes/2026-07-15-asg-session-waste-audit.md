# Past-day ASG session-waste audit

**Date**: 2026-07-15

**Scope**: Codex sessions in the current project returned by `asg +list --since yesterday`; 62
sessions, including main sessions, subagents, and Codex auto-review mirrors.

**Tool**: `rust/scripts/asg_session_waste_audit.py` using
`asg +show --json --expand-tool-calls`, with auto-review transcript deltas used to recover tool
result bodies and reported original-token counts.

## Executive verdict

The dominant avoidable cost was not mathematical reasoning. It was the permission-review loop,
followed by manual job watching and unbounded diagnostic commands.

- The auto-review sessions made **1,838 review decisions** and recorded **251,163,757 cumulative
  context tokens**. At least **1,815/1,838 (98.7%)** were plain `allow` decisions; the remaining 23
  responses were not machine-parseable by this audit, not established denials.
- Across all Codex sessions, ASG recorded **599,297,461 total model tokens** (cumulative context plus
  generated output). Permission-review sessions used **251,284,221**, or **41.93%** of the total.
  Thus roughly two tokens in five went to permission checking; almost all review outcomes were plain
  allows.
- Those review sessions stored 20,036,194 user-input characters. Because the reviewer conversation
  accumulated the transcript deltas, later approvals repeatedly carried a context near 200k–250k
  tokens even for routine local commands.
- After main/review mirror deduplication, the window contained 6,836 tool calls and 6,401 recovered
  tool-result bodies. Heuristics flagged 1,005 waits, 621 process/status polls, 510 build-related
  calls, and 202 broad-output-risk calls.
- Several commands produced five- or six-figure reported token counts. Output caps kept only a
  fragment in the stored review trace, but the commands still generated, transferred, parsed, and
  repeatedly summarized the large results.

Full local permissions, or a stateless/batched approval mechanism that does not carry an ever-growing
review transcript, removes the largest single source of waste.

Tool-result size totals are a lower bound: ASG's ordinary `+show` view exposes calls but not every
result body, so the analyzer recovers result sizes primarily from sessions with an auto-review
mirror. The approval-round and recorded context-token totals come directly from ASG message fields.

## Alt-orbit lane

The paired alt-orbit main/review sessions were the second-largest session family in the window:

| Measure | Alt-orbit | Whole window | Share |
|---|---:|---:|---:|
| Approval rounds | 480 | 1,838 | 26.1% |
| Recorded approval context tokens | 78,604,958 | 251,163,757 | 31.3% |
| Tool calls | 1,650 | 6,836 | 24.1% |
| Captured tool-result characters | 1,772,113 | 7,679,093 | 23.1% |
| Waits | 276 | 1,005 | 27.5% |
| Polls | 199 | 621 | 32.0% |
| Broad-output-risk calls | 69 | 202 | 34.2% |
| Build-related calls | 147 | 510 | 28.8% |

Its 480 approval decisions contained 472 plain allows. The lane repeatedly polled long Lean jobs,
requested large per-poll output budgets, and inspected broad source/process sets while heavyweight
work was running.

## Largest observed output producers

The counts below are the maximum `original_token_count` values reported inside the tool result.
Exact powers of two can reflect an upstream cap, so they should be read as “reached this reported
ceiling,” not necessarily as the complete output size.

| Reported tokens | Root action | Why it expanded |
|---:|---|---|
| 492,544 | Direct Lean elaboration of `Q11A5PointOrbitsRows00.lean` | 27,639 lines of repeated unsolved goals were streamed instead of logged quietly and reduced to the first failure. |
| 428,418 | `ps -eo pid,ppid,comm,args` | Unfiltered process table included the full command lines of unrelated processes and agent sandboxes. |
| 311,802 | Direct Lean elaboration of `Q11BrianchonPetersen.lean` | 16,065 lines of repeated unsolved goals were streamed. |
| 262,144 | Broad `rg` for automorphism/witness terms over all `RelativeConicArcs/*.lean` | Generated and large Lean sources were searched without a result/file cap. |
| 262,144 | `rg -A30 -B8` over `RelativeConicArcs` | Broad match set multiplied by 38 lines of context per match. |
| 262,144 | Combined `sed` sweeps of multiple Lean/Python sources plus a broad `rg` | Several independently large inspections were bundled into one result. |
| 181,021 | Broad `rg` over most of `RelativeConicArcs` | Generated source trees remained in scope despite a few exclusions. |
| 178,176 | Combined Dye/OCR search and manuscript ranges | Large OCR/source lines and several inspections were returned together. |
| 107,601 | ASG search for `p. 275` across all projects/roles with 100 hits and context | Search breadth and per-hit context multiplied output. |
| 94,665 | Several wide `sed` ranges plus `rg` in C151 sources | Source inspection was not split into targeted questions. |

Other recurring patterns included an unrestricted cached diff after staging, large commit output,
and searches spanning the live queue, handoffs, archives, and discovery notes at once.

## Needless repetition

- `wait_agent` was repeated 266 times after mirror deduplication.
- Long-running command sessions were polled through many identical `write_stdin`/`wait` calls,
  commonly with 8k–12k output budgets.
- The exact broad Lean process query
  `ps -T -C lake.orig -C lean -o pid,ppid,psr,etime,stat,rss,comm,args` appeared 17 times;
  `free -h` appeared 10 times; another broad Lake process query appeared 9 times.
- The same direct elaboration of `RelativeConicArcs/QuadraticInvisible.lean` appeared eight times.
- `list_agents` was repeatedly used as a polling mechanism rather than waiting for mailbox events.

Not every repeated call was needless: source edits can justify rebuilding, and long commands may
require a final read. The counts nevertheless show that observation calls were routinely used where
an unattended milestone runner or one longer bounded wait would have sufficed.

## Prevention rules

1. Route every build, elaboration, renderer, and potentially noisy checker through
   `~/.claude/bin/run-quiet`; inspect only a targeted first-error neighborhood from its disk log.
2. Use `lean/scripts/guarded-lean` or the build queue, not direct Lean/Lake/Nix invocations and manual
   wait loops.
3. Ban broad `ps -eo`, repository-wide file lists, unrestricted diffs/status, wide multi-file
   `sed`, and searches across generated source trees. Filter at the producer and cap files, matches,
   context lines, and fields.
4. Default tool output budgets to 1k–2k tokens. A higher budget requires a known bounded artifact.
5. Treat any command reporting more than 10k original tokens as a failed inspection design; do not
   repeat it unchanged.
6. Do not use `wait`, `write_stdin`, `list_agents`, `free`, or process queries to watch healthy work.
   Use disk-backed status and check only a meaningful milestone.
7. For ASG, never render a full session into model context. Use the analyzer or narrow searches with
   bounded hits, roles, per-session results, and context.
8. Avoid per-command permission reviews for routine in-scope local work. If reviews are required,
   batch related read-only checks and make the reviewer stateless or periodically reset its context.
9. When repeated `guarded-lean` calls need exceptional CPU/thread/profile settings, persist them once
   with `guarded-lean --session-set ...` and clear them at the end. Do not repeat inline environment
   assignments; the wrapper isolates saved settings by agent-session ID.
10. Keep task-owned Git state short-lived: check exact owned paths after creating/editing files,
    validate and commit each coherent unit promptly, and never cross a compaction, lane switch, or
    long build with unexplained untracked files. This prevents source/checker changes from falling
    outside later manifests and avoids expensive full-tree archaeology.

## Reproduction

From `rust/`:

```bash
uv run python scripts/asg_session_waste_audit.py \
  --since yesterday --agent codex --max-sessions 100 --top 12
```

For a known main/review pair:

```bash
uv run python scripts/asg_session_waste_audit.py \
  --session codex:<main-id> --session codex:<review-id> --top 12
```

The analyzer emits capped human output by default and caps every variable-size section in `--json`
mode. It does not print complete messages, commands, results, or transcripts. Its repeat/broadness
classifications are heuristics intended to locate review candidates, not automatic findings of
misconduct or useless work.
