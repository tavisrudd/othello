# C320 — Clebsch referee-facing trust ledger

**Lane:** `clebsch`

**Status:** queued release-blocking capstone

This file is both the cold-read task specification and the required durable result report. Complete
it in place. C320 is not an editorial summary: it is the authoritative claim-by-claim ledger that
determines which Clebsch paper statements may be labelled Lean-formalized, certificate/replay-backed,
conceptual/citation-backed, or mixed.

## Required outcome

Create the Clebsch per-paper trust manifest and one documented verify-all entry point after every
paper-adopted formalization/evidence task has delivered its reviewed ledger delta. The manifest has
one row per published claim and separately stated subclaim. Each row records:

- the exact paper statement and its statement-adequacy correspondence;
- exactly one final trust route: full-trust Lean, exact replay/certificate, conceptual proof with
  named classical inputs, or an explicitly decomposed combination;
- fully qualified Lean terminals, import-only gates, pinned commit, exact validation, and terminal
  `#print axioms` results;
- checker/soundness theorem, generator, schema, data, hashes, finite domain/coverage, independent
  replay, and residual trusted boundary for every computational clause;
- cited/axiomatized inputs, including the two Dye assumptions, and what remains unconditional
  without each;
- conditional, optional, stopped, omitted, or external clauses that must not inherit a stronger
  label; and
- the exact verify-all command/entry point and durable output establishing the row's route.

The ledger must reconcile the actual final gates rather than trust task verdicts or module names.
It must explicitly preserve known mixed boundaries, including C222 compactness stops, C421's bounded
`Fin 4` connectivity, C424's possible H3 fallback, C426's external-by-default intersection/Krein and
fusion clauses, C427's external rank-16/automorphism clauses, and any later review disposition.

## Referee-facing standards and guarded failure modes

- A paper claim is Lean-formalized only if its adequate terminal statement is in the pinned gate,
  current validation is green, and its axiom closure satisfies the full trust policy.
- A conditional theorem does not prove its premise. A checker-backed theorem does not establish
  coverage unless its soundness/coverage bridge does. An aggregate import does not upgrade an
  imported external clause.
- Read theorem types and load-bearing definitions to detect vacuity, weakened quantifiers, hidden
  hypotheses, empty domains, conclusions frozen into data/definitions, and strength words exceeding
  the formal type.
- Hashes establish identity, not correctness or current regeneration. A second CAS run on the same
  specification is not independent validation of that specification.
- The referee-facing manifest and verification artifacts use semantic mathematical names and contain
  no task IDs, agents, sessions, private notes, mutable local paths, workflow chronology, or novelty
  claims. This internal report may cite task records but must point forward to exact public artifacts.
- Include a deterministic extraction of the headline theorem statements and load-bearing definitions
  for the paper's verbatim adequacy appendix.

## Required judgment-call record

Record every reconciliation choice: competing task claims, adequacy mismatch, route downgrade or
upgrade, conditional decomposition, omitted claim, accepted classical input, verify-all scope, and
packaging exclusion. For each give alternatives, evidence, effect on paper wording/trust, rejected
routes, and reopening condition. Never resolve conflict by choosing the strongest label or by
leaving “if feasible” in the final ledger.

## Required closing review and archival checklist

Keep C320 live. After the ledger, manifest, adequacy extraction, and verify-all entry point are
complete, explicitly request an independent referee-style review that samples the paper-to-ledger,
ledger-to-terminal, gate-to-import, certificate-to-checker, and command-to-artifact links. Any finding
or `NO-GO` blocks completion and archival. Fix every issue, rerun affected checks, update this report,
and request post-fix review. Only a recorded final `GO` permits C320 to be archived.

- [ ] Inventory every published Clebsch claim and separately stated subclaim; account for each once.
- [ ] Assign one exact final route per row and prohibit trust inheritance across combined claims.
- [ ] Verify adequacy against actual theorem types/definitions, not names, reports, or intended prose.
- [ ] Verify every Lean terminal is imported by the pinned gate and record current exact-target and
  axiom-audit evidence.
- [ ] Verify every computational row's checker semantics, exhaustive coverage, artifacts, hashes,
  independent replay, and residual trust; distinguish search evidence from proof.
- [ ] State every named classical/axiomatic input and the unconditional remainder without it.
- [ ] Reconcile all task judgment logs, review findings, fallbacks, exclusions, and post-fix changes.
- [ ] Provide one clean-source verify-all entry point that fails loudly on missing/stale/mismatched
  components and leaves the worktree unchanged.
- [ ] Produce the verbatim adequacy-appendix extraction and compare it to final manuscript claims.
- [ ] Audit the referee-facing manifest/artifacts for self-containment, stable citations, one-way
  references, semantic naming, and absence of internal workflow or unsupported novelty language.
- [ ] Record independent review, every finding/fix, post-fix review, and final `GO`.
- [ ] Only after final `GO`, archive C320 with this completed report and the manifest/entry point.
