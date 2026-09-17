# C1193 audit — bodies of more than two atoms, vetted

**Lane**: `ergodis`
**Date**: 2026-09-17
**Scope**: the C1193 report (`2026-09-17-c1193-nary-bodies-report.md`) and its commits: core
`ergodis` `e7116ba..09a5c2b`, private `ergodis-private` `193ebd1..26d2468`, monorepo
`4cd81ef..fb1f8bf`. Method: the code read and every judgment here are the main agent's (Fable);
the gate re-runs, receipt re-derivation, A/B reproduction and clean-worktree rebuild were an Opus
replay whose raw record is not committed (scratch). Repairs were applied to the report directly.

## Verdict

The task is complete and the code is exact. No code defect. Every number in the report's results
tables re-derives from the committed receipts and the headline ratios reproduce on the retained
binaries. Two records were wrong and are repaired in the report: the two candidate arms were
retained from a dirty tree, not a clean one, and the "peak RSS lower on every cohort" claim on the
two-atom path is page noise with either sign.

## Code read

| Area | Finding |
| --- | --- |
| Semi-naive decomposition (`demand.rs`, `run_nary`) | Exact. For delta position `p`, links before `p` join rows below the relation's `delta_lo`, links after join every indexed row; a limit of zero skips the step. The `row >= limit` test ends an ascending CSR or sorted bucket and skips within a descending chain or hashed bucket, which is right for both orders. A combination with at least one delta member is produced only at its first delta position. |
| Bindings and premises | `vars[level + 1]` copies a fixed 32-byte array; `premises[position]` is rewritten at every level before the only `emit`, so a stale deeper slot cannot be read. `emit::<BODY, _>` writes `BODY <= premise_width` slots into the head relation's column. |
| Join order vs semantics | The greedy `pending` selection is a join order only; `Link::old` and `Link::position` are read from the body position. Mutation D is the negative control for this and is the right one. |
| Sparse verification | `bind_link` compares key columns only for `KIND_HASHED`; chain, CSR and sorted buckets hold one key by construction. Mutation C now covers it through a one-slot table. |
| Frame stack | Bounded by `MAX_BODY - 1` at compile time; no exhaustion path is needed and none is missing. No allocation, no runtime-length copy, no recursion. |
| Derivation checker (`derivation.rs`) | Premise blocks of `premise_stride(body)` are walked, every body atom gets a premise, trailing slots must be zero, total length checked at the end. Rank and premise-range checks unchanged. |
| Closed-world pass | Masks per level computed under the variables the earlier atoms bind; frame stack keeps bindings-on-entry per level; backtracking restores them. An atom sharing no variable takes a mask-of-nothing index, as before. |
| Ranked checker (`ranked.rs`) | Scans the smallest candidate set under the head bindings, then body order; `needed_indexes` builds every mask a choice of first atom can need; the rank bound is checked on every premise. |
| Lowering (`passes.rs`, `plan_bodies`/`chain`) | Auxiliaries at positions `1..=count-keep`, the rule keeps the accumulator plus the last `keep - 1` atoms; with `keep = 2` this is the shipped binarization exactly. Suffix liveness is unchanged and independent of `keep`. |
| Wire and text forms | `parse_rules` admits up to `MAX_BODY`; `ground` still refuses more than two and a test binds that boundary. |
| Discovery track | One entry, incidental, exact provenance (the removed-worktree stale artifact). Correct use of the track. |

## Replay results

| Check | Result |
| --- | --- |
| Core gates at `09a5c2b` | tests exit 0, 82 ok blocks, zero failed; clippy `-D warnings` clean; fmt clean; allocation gate 5 passed including the n-ary one |
| Private gates at `26d2468` | tests exit 0, 42 ok blocks, zero failed; clippy and fmt clean |
| C1189 differential, both policies | 19 passed; body-length mix 732/1,516/1,329/1,134 exactly as reported, floors 200 per length hold; 1,200 accepted under both policies, zero divergences; near-miss 382 rejected + 18 `REL0503`; 120 templates accepted |
| Mutation C re-applied | `demand_nary` 10 → 9 passed, the collision test fails with `Unification(3)`; reversed by edit; trees clean |
| Receipts | every ratio, interval, tuple count, round count, peak RSS and per-unit figure in the results tables is in the committed receipt at the printed value; A/A nulls, enabled fraction 100.0 and load present in the three `perf` receipts |
| A/B reproduction, triangle body policy | 0.52270 and 0.61324 against the report's 0.52263 and 0.61324 |
| A/B reproduction, two-atom path | 1.02128 / 1.02143 / 1.01698 / 1.01696 / 1.02053 / 1.02064, nulls inside six ppm, output digests identical |
| Preparation cost, triangle 4,096 | `auto` 23.8–29.8 ms, 71.4–71.6 MB peak; `sparse-indexes` 3.35–3.56 ms, 5.9–6.0 MB; the 64 MiB is the plan's direct CSR (`slots: 16777216`), invisible to `workspace_bytes` |
| Hygiene | no attribution trailers; no `/tmp` path cited; every cited receipt, driver, `.dl` program and sidecar is tracked |

## Findings

1. **Measurement record defect, repaired.** The Arms table said all six arms were retained clean;
   the manifest records `dirty` for `closure_ballpark-cb11550` and `ergodis-tools-cb11550`. The
   retain ran in the same second as the commit and the only later commit adds receipts, so the dirt
   was most likely the untracked receipt files, which are not build inputs; but it was not recorded
   and is unrecoverable. A clean-worktree rebuild at `cb11550` cannot settle it: the binary embeds
   its absolute source path, so the rebuild differs by that path and by 200 bytes, and a
   `--remap-path-prefix` rebuild differs by more. The report now says so in the Arms section and the
   resume state. Consequence: the body-policy, cache, Rel-route and Soufflé figures are one binary
   under two arguments and unaffected; the two-atom A/B and the variants table compare a clean
   control against a candidate not reproducible from its commit alone. Rule for the lane: check
   `git status --short` is empty immediately before every retain.
2. **Prose defect, repaired.** "Peak resident set is lower on every cohort, by 12 to 32 KiB" on the
   two-atom path: the replay of the same binaries had the candidate higher by 4 to 32 KiB on every
   cohort. One to eight pages either way is placement noise. The report now states it as not a
   result.
3. **Prose, repaired.** The Rel-route section claimed CPU 5; the `bench.py` receipt has no CPU
   field. The report now says the pin was on the command line and not recorded. Successor: have
   `bench.py` record it.
4. **Prose, repaired.** Commit range for the report and two forbidden-word uses.
5. **Not repaired, cosmetic.** The differential test named `the_audits_five_further_programs_agree`
   holds six programs; the report's count is right and the test name lags.
6. **No defect.** `sparse-indexes` peak RSS 5,904 KiB reported against 5,920–5,988 replayed, and
   triangle 0.52263 against 0.52270: run-to-run scatter inside the report's own intervals.

## Acceptance, per card bullet

| Bullet | Verdict |
| --- | --- |
| Same closure as the binarized lowering on every fixture and generated corpus, three- and four-atom bodies in the generators, both checkers accept | **Met.** Zero disagreements under both policies; floors gate the body-length mix; both checkers accept every certificate; seven mutations discriminate. |
| A/B same source binarized vs n-ary on `datalog` and triangle/path-of-three at sizes where the intermediate dominates; instruction ratio, peak RSS, derived-tuple counts; two-atom path unchanged where selected | **Met with caveat.** All measured and reproduced. The two-atom path is not unchanged: 1.017–1.021 instructions, stated as a loss with both first-landing mechanisms repaired and the residual attributed to the premise column plus the recompile lever three prior reports record. The candidate arm's dirty flag (finding 1) is the caveat on that one comparison. |
| Performance-contract validation per `PERFORMANCE.md`; report with Mystery ledger; audit | **Met.** Allocation gate, kernel-scoped call-free profile from the disassembly, layout assertions, peak RSS, variants record, Fermi before code, mystery ledger with evidence gaps; this audit. |

## Recommendations on the two open decisions

- **Default body policy: flip to `Nary`.** Every measured axis favours it and the three conditions
  the report lists (pin the milestone (a) helper to `Binarize`, regenerate the parity manifest,
  record the two moved digests) are one small commit. Tavis's call, as the report says.
- **The static index's eager 64 MiB CSR build** is the largest measured effect in the report and
  is real (replayed). Allocate it as its own task: a density or size rule for a static index, or a
  lazy `Pages` reservation for its offsets array, measured on triangle against Soufflé.

## What this audit left under `~/.cache/ergodis/`

Three retained binaries the rebuild check added with their manifest rows,
`closure_ballpark.audit-cb11550`, `closure_ballpark.remap-cb11550` and
`ergodis-tools.audit-cb11550`, cited only here; `perf-c1193-replay/` with the A/B work directories
and the two copied arms. The worktree `worktrees/c1193-audit` was removed and pruned. Its build
wrote into the shared private target directory, the configuration behind the C1193 discovery-track
entry; nothing was cleaned and no stale-artifact failure has surfaced. Deletion is Tavis's call.
