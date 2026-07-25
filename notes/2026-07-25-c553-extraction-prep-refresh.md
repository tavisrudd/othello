# C553 extraction-preparation refresh

**Lane:** `cap`

**Status:** planning refresh complete; C553 Lean source rewrite remains queued

## Scope

This pass reviewed the paper-facing Lean boundaries added or revised since the previous C287
extraction plan. It updated only planning and handoff records. It did not edit Lean, run a
generator, elaborate a module, build a target, inspect or intervene in a Lean process, copy a
source into a fresh-history workspace, or perform a remote action.

The user set the execution boundary: prepare the plan now and perform the actual extraction only
after the AME--LU formal closure is ready.

## Reviewed upstream

### Arcs

C604 makes `RelativeConicArcs.Gates.Relconic` the paper-facing root. The gate imports the exact
uncovered-locus reconstruction and matching-design rigidity packages and audits thirteen
paper-facing declarations with axiom sets
`[propext, Classical.choice, Quot.sound]`. Quantitative two-parent reconstruction and the
Singular-backed ten-point classification remain outside the gate.

Verdict: locally ready for a C287 closure computation and whole-closure prose review.

### Beyond-four PRS

C545 supersedes C544's broad pre-scope-reset aggregate. The adopted R5--R7 boundary has six gate
modules, nine mathematical modules, 53 ordered axiom-audit targets, and 35 manuscript labels. It
excludes residual-quadratic, redundancy-eight, redundancy-nine, Hessian, general Lucas, and
degree-nine endpoint companion work.

Verdict: locally ready. External specialist, identifier, account, and publication gates do not
block preparation of its local source closure.

### Clebsch Paper I

The current `papers/clebsch-rigidity/verification/trust_manifest.json` has nineteen claim rows,
24 unique Lean terminals, one gate
`RelativeConicArcs.Gates.ClebschRigidityTrust`, and sixteen release checks. Its
`lean_repository.commit` is
`6d4766d1ea5e9a36f1a507e549c223416a6b506f`. This supersedes the older
`bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520` pin quoted in the previous C287 intake.

Verdict: Paper I is locally ready from the current manifest. Papers II and III remain separate
prospective intakes.

### AME--LU

C570's seven-package, 33-declaration aggregate was complete for the earlier six-party paper, but
C609 and C614 expanded the adopted manuscript to all prime powers and all `m >= 2`, with encoder
and transversal consequences. C601 has completed the generic foundation. The remaining mandatory
order is C612, C613, then C602. C602 must freeze the final aggregate root, exact terminal set,
transitive project-owned closure, native-axiom boundary, statement-adequacy map, and
referee-facing source audit.

Verdict: not ready. C581 is optional and does not gate extraction unless the manuscript adopts its
result before C602.

## Updated extraction shape

1. Keep C553's approved deletion-first `OddEscape` and `StableFacts` migration plus the
   seventeen-module semantic prose/docstring review as a required first-tag dependency.
2. Prepare content-addressed candidate manifests for Relconic, PRS R5--R7, and Clebsch Paper I
   without copying sources.
3. Wait for AME--LU C612, C613, and C602; do not freeze the superseded C570 closure.
4. C553 may land before C602. Once both are complete, execute one coordinated extraction wave:
   inventory regeneration, whole-closure public review, fresh-history copy, exact builds, axiom
   extraction, and clean replay.
5. Preserve separate incremental tag contracts and paper pins. Shared source may deduplicate by
   content, but no portfolio umbrella is an admissible paper root.

## Files refreshed

- `notes/2026-07-17-c287-shared-lean-extraction-plan.md`
- `notes/2026-07-23-c287-first-tag-theorem-ledger.md`
- `notes/2026-07-24-c287-new-paper-export-intake.md`
- `notes/2026-07-24-c287-first-tag-trust-spine.md`
- `notes/2026-07-24-c287-source-owner-rewrite-packet.md`
- `notes/2026-07-07-codex-task-queue.md`
- `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`
- `notes/handoffs/2026-07-14-lean-build-system.md`

## Open gates

- C553 still owes the approved Lean API migration and full semantic documentation pass.
- The first-tag trust spine still lacks its four authoritative extracted fact files.
- AME--LU C612, C613, and C602 are the remaining later-paper source-freeze gate.
- C287 must independently compute and review every ready source-owner closure; the counts above are
  intake assertions, not substituted manifests.
- Public remotes, identifiers, licenses, account actions, uploads, and publication remain outside
  this planning pass.
