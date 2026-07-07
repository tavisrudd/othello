# Queens n=18 / A344227 release boundary

Date: 2026-07-07

Purpose: define the smallest reproducibility capsule that should ship with the Queens Node-Kayles
paper, and keep the larger solver-stack/JOSS release from bloating the paper.

## Public claims to freeze for P2

1. Outcome result: the non-attacking queens game on the 18x18 board is a first-player win, with
   opening I9 and the 15-ply PV reported in `queens-n18-paper.md`.
2. Cross-validation: two independent getK/evaluator configurations agree on verdict, winning
   move, and PV, at different node counts.
3. A344227 extension: exact nimbers through n=17 are
   `G(14)=0, G(15)=1, G(16)=0, G(17)=2`.
4. Non-claim: the n=18 outcome is not an A344227 term; exact `G(18)` remains open.
5. Non-claim: the Lean development certifies the recurrence semantics and SG facts, not the full
   n=18 concurrent search, bit serialization, or transposition table.

## Paper capsule

This is the evidence set P2 should cite or archive with the submission:

- Frozen code identities for the n=18 outcome runs: branch, commit, worktree, build command, and
  any cherry-picks relative to main.
- Exact outcome-run configurations: `dense_k`, skip band, TT size/slot count, relevant env vars,
  hardware/RAM, and whether the run was cold.
- Primary and confirm logs: verdict, I9 opening, PV, wall time, nodes, distinct/root stats if
  printed, and TT fill/memory footer.
- Validation gates: lineage agreement, n=12 iso-flat distinct `1,060,823`, n=14 iso-flat distinct
  about `29.2M`, independent raw-mask oracle, integer-width audit, and Jenrich n<=16 reproduction.
- Nimber-run logs for n=14..17, especially the n=17 transcript:
  `k=0 WIN`, `k=1 WIN`, `k=2 LOSS`, about `584,796,995,565` cumulative nodes and about 59 h.
- The 2026-07-07 G(17) verification pointer: config, log path or pane transcript, and what changed
  relative to the 2026-07-04 initial run. This is the one evidence pointer still easy to lose even
  though the status is now recorded as verified.
- OEIS A344227 b-file source: `notes/b344227.txt` is the companion upload file for `a(0)..a(17)`
  and has been checked against the proposed DATA line in the OEIS package.

## Keep out of P2

- Full performance history and every negative optimization: cite the handoffs or JOSS artifact
  instead of turning the paper into a solver diary.
- Reply-book/certificate standard: include it only if item 12/C11 becomes real before submission;
  otherwise say certificate work is future/revision material.
- Exact `G(18)`: do not wait for it. The paper is complete with `G(18)` open.
- Disk-DDD/BuRR implementation details unless they are required to explain the reproducibility of
  the specific n=18 runs being cited.

## JOSS / artifact boundary

The JOSS release should own:

- Packaging the solver stack as a reusable artifact.
- Complete command recipes and hardware caveats for reproducing benchmarks.
- Engineering-history tables and performance levers.
- Optional certificate/checker infrastructure when ready.
- Stable archived logs and checksums for paper-cited runs.

P2 should only carry enough method detail to make the mathematical claims credible and reproducible.
The artifact can carry the engineering surface area.

## Immediate next edits

1. Update `notes/handoffs/2026-07-01-queens-nimber-a344227.md` once the 2026-07-07 G(17)
   verification log/config is located.
2. Add a short "artifact capsule" paragraph or appendix pointer to `queens-n18-paper.md` after the
   log paths are frozen.
3. DONE 2026-07-07: normalize the A344227 OEIS text and add `notes/b344227.txt`; the remaining
   OEIS step is user submission.
