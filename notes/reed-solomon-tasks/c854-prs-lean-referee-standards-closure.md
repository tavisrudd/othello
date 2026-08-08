# C854 — PRS Lean referee-standards closure

**Lane:** `reed-solomon`

**Status:** complete 2026-08-07 through C885 under the manuscript's current
withdrawn-quantum scope.  Report: `notes/2026-08-07-c885-full-review.md`.

## Objective

Bring every Lean source and enduring verification artifact used by
`papers/beyond4_prs` up to the current `lean/AGENTS.md` referee-facing,
validation, and trust-record standards.  The date-bounded audit found no PRS
Lean-source commit on August 1 or 2; the stronger full-surface audit covers the
17-file geometric aggregate, the separate three-file balanced-quantum bridge,
their transitive project-owned dependencies, and the paper-facing declaration
map.

## Initial gaps

- The two paper gates and their terminals are not registered in
  `lean/trust/areas/relconic.toml`, and there are no corresponding exported
  axiom-fact records under `lean/trust/facts/`.
- The paper ledger advertises a hand-composed `nix develop --command lake
  build` invocation instead of the supported guarded/queued Lean entry point.
- The ledger states an aggregate axiom result, but no current tracked fact
  snapshot demonstrates it under the trust spine.
- The Dür dependency is identified by title, year, and DOI but lacks the
  pinpoint required by the current external-reference standard; the local
  literature audit records only publisher metadata/abstract depth for Dür and
  a secondary full-text check in Kaipa.
- The claimed 17-file geometric closure and the separate balanced-quantum
  closure need fresh recursive-import reconciliation after all source and
  trust changes.

## Checklist

- [x] Coordinate an exclusive Lean build window and ownership with the shared
      `RelativeConicArcs`/trust-spine owners; preserve all foreign dirty state.
- [x] Audit every project-owned file in the recursive closure of
      `RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`, not merely
      the 17 files named by the paper.
- [x] Dispose of the former balanced-quantum closure after C882: confirm that
      the manuscript imports no theorem from it, retain its conditional status, and exclude it
      explicitly from the current paper trust boundary rather than auditing it as paper-facing.
- [x] Check every touched module in full for self-contained headers and public
      docstrings, stable mathematical names, accurate strength/scope, exact
      computational trust language, forbidden workflow identifiers/status
      prose, reverse references, and unresolved repository-local references.
- [x] Reconcile the R5--R7 transcribed-table source path and SHA-256 against the
      released `CLASSIFICATION-RECORDS.json`; state exactly what kernel
      reduction checks and what semantic/exhaustion facts remain hypotheses.
- [x] Resolve the Seroussi--Roth and Dür citation pinpoints from primary text;
      if primary-text access remains unavailable, cite the exact verified
      secondary statement and disclose that boundary rather than inventing a
      pinpoint.
- [x] Register the current PRS paper gates and their exact paper-adopted terminals in
      the current trust manifest, coordinating any schema/export work owned by
      C326 rather than editing that foreign closure opportunistically.
- [x] Run the source-owner-approved guarded import gates, exact-target
      `--no-build` confirmations, and declared axiom audits; never invoke Lean
      or Lake directly.
- [x] Export and review the corresponding trust facts; verify that every
      advertised terminal has the recorded axiom set and that no `sorry`,
      project-local axiom, native evaluator, generated Lean certificate, or
      opaque oracle enters either claimed closure.
- [x] Replace the unsupported reproduction command in
      `supplement/LEAN-STATEMENTS.md` with the supported public gate route, and
      synchronize its exact closure counts, terminal list, axiom statement,
      and computational boundary with the exported facts.
- [x] Run the paper-local statement/label verifier and both manuscript builds
      after the ledger changes.
- [x] Perform a final cold referee-facing prose audit over all changed Lean,
      gate, trust, and paper-ledger files; record any legacy violation outside
      the task's safe ownership instead of silently waiving it.
- [x] Commit the source, trust registration/facts, paper ledger, and green gate
      evidence in coherent validated tranches, then close the queue row through the normal
      archive-first lifecycle.

## Acceptance boundary

C854 is complete only when both paper-facing gates have current reproducible
validation and axiom evidence, the manuscript describes exactly those facts,
and the entire project-owned verification closures meet the current
referee-facing prose/name standard.  Static review alone is an audit result,
not completion.

The balanced-quantum module named in the original 2026-08-02 scope is no longer
paper-facing: C882 withdrew that consequence because its one-column extension hypothesis is false
at covering radius `r-1`.  C885 therefore registered and replayed the actual R5--R10 manuscript
closures and explicitly excluded the retained conditional balanced module.  This is a scope
correction, not a waiver of a current theorem dependency.
