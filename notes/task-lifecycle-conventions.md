# Task lifecycle: completion and ID allocation

CLAUDE.md keeps the always-on invariants (the live queue carries no completed rows; archive-first;
allocate IDs only via the reserve script; re-pegging needs approval). This file holds the mechanics.

## Completing a task

The live task queue is an allocation/open-work index, not a completion ledger: it MUST contain no
`[REPORTED ...]` rows and no other completed-task rows. When a task completes, do all of the
following in the same coherent commit:

1. append its completed row to `notes/2026-07-07-codex-task-queue-archive.md`;
2. verify that its `C<id>` occurs there exactly once;
3. delete its row from `notes/2026-07-07-codex-task-queue.md`;
4. update the owning lane's handoff; and
5. before sending the user-facing completion report, review the work just closed against the
   discovery-track discriminator and append any genuinely incidental observations or musings to the
   lane's companion log. Do not manufacture an entry when there was none; retain the handoff's
   one-line companion link either way.

Archive first: if the completed row is not yet present in the companion archive, that is a blocker to
deleting it, not a reason to leave `[REPORTED]` history in the live queue. Never transition a live
queue row to `[REPORTED]`, even temporarily.

## Allocating IDs

Every task uses the global monotonic `CNN` sequence. Allocate one ID or a contiguous block only by
running `python3 notes/scripts/allocate_codex_task_ids.py reserve` from the repository root with
`--count N`, `--lane <alias>`, and `--purpose '<bounded purpose>'`. Use only the returned IDs and
immediately commit the updated allocation ledger before dispatching or using them in queue rows.
Never derive IDs from repository text, treat `peek` as an allocation, reuse or renumber an ID, or use
`notes/scripts/next_codex_task_id.py` for anything except auditing. Examples must use `C<id>`, never
a concrete unallocated number.

## Task rows

Every task row carries exactly one lane peg at allocation:

```markdown
- **C<id> `[clebsch]` [QUEUED]** — one-line description → report path
```

Section placement is presentation; the peg is authoritative. Re-pegging is a lane switch and needs
explicit approval.
