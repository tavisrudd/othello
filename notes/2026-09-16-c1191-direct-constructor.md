# C1191 — direct constructor from the relational IR into the demand evaluator's prepared form

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: IN PROGRESS. Successor of C1190 (`2026-09-15-c1190-rel-lowering.md`); the lever the
per-column and milestone (c) reports rank first.

## Goal

Every layer program the stratified driver (private `src/rel_stratified.rs`) builds today goes
through `ergodis_verify::rule_contract::Program`: one owned `Fact` per tuple with an owned relation
`String`, then `encode_source` (serde JSON) for the certificate's source identity and the
`MAX_BYTES` (1 MiB) refusal, then `Demand::new`, which re-resolves names and re-copies every
tuple. The per-column audit measured that about 96 per cent of a materialized complement fact is
its relation name and JSON punctuation, so the route's reach on every product-shaped construct
(negation complement, comparison filter) is set by an encoding, not by evaluation: about 22,000
facts per layer. ADR 0004 names the direct constructor into the demand evaluator's prepared form
as the planned removal of that boundary allocation.

Deliverable: a core entry point that builds a `Demand` from resolved relations, resolved rules and
flat tuple slices (no `Fact` per tuple, no name re-resolution, no JSON), with a source identity the
core computes over a compact canonical encoding of that prepared source; the private driver uses it
for every layer; the JSON path and its identity are unchanged. The encoding ceiling is gone and the
next binding bound is measured and named.

## Design constraints (from the handoff and reports)

1. **No contract change.** `rule_contract::Program`, `encode_source`, `identity_of`, `Demand::new`
   and every existing certificate keep their meaning and identity. The prepared path is a second
   constructor, not a replacement. A program built both ways evaluates to the same closure and both
   checkers accept both certificates; the two source identities are permitted to differ and the
   report says so (a prepared-source certificate binds to the prepared-source identity).
2. **Prepared source identity.** The core, not the caller, hashes: a domain-separated canonical
   binary encoding of domain, relations (name bytes, arity, input flag), rules (resolved slots) and
   facts (per relation, sorted deduplicated flat tuples), streamed into the hasher without an
   intermediate buffer. The caller supplies nothing hashed by trust.
3. **Bounds.** The existing core budgets (`MAX_DOMAIN`, `MAX_RELATIONS`, `MAX_RULES`, `MAX_ARITY`,
   `MAX_BODY`, `MAX_VARIABLES`, `MAX_UNIVERSE`, `MAX_ROWS`, `MAX_INDEX_KEYS`) still apply through
   the same `Error` values; `MAX_BYTES` does not, because nothing is serialized. The driver's
   `Budget::ProgramBytes` refusal is replaced by whichever bound now binds first, reported with the
   numbers, never silently.
4. **Performance contract.** `~/src/ergodis-dev/PERFORMANCE.md` binds: the constructor and the
   driver's fact assembly are allocation-counted (presized from the relational IR's known counts),
   call-free in their loops, with a kernel-scoped profile and an interleaved A/B against
   `ergodis-tools-b7c624d` (rustc 1.95.0) using the non-multiplexing event set. Scan, parse and
   admission must not move; the lowering stage is the candidate.
5. **Exactness.** The differential harness (C1189 reference evaluator, all committed fixtures, the
   35 Addendum A equations, the generated positive/negation/aggregation corpora) must show zero
   disagreements on the prepared path; complement, filter and aggregate records stay independently
   rebuildable and digest-checked; the parity corpus's canonical hash is either unchanged or its
   change is explained by the identity change alone.
6. **Deviations are recorded**, not hidden: if the constructor needs a change in `Demand`'s
   private layout, or the driver keeps the JSON path for readout/export, say so in the report.

## Acceptance

- Core: `Demand` prepared-source constructor, its identity, unit tests (same closure and accepted
  certificates as the JSON path on the datalog fixtures; identity stable across a re-ordering of
  supplied facts; every budget reachable and named), allocation regression on the constructor.
- Private: every layer built through the prepared path; `LayerReport.program_bytes` replaced or
  reinterpreted; the boundary experiment from the per-column and milestone (c) reports re-run
  (negated binary/ternary relation, comparison filter) with the new binding bound named and the
  dictionary sizes reached; the differential and parity gates re-run.
- Measurement: lowering-stage A/B on all cohorts plus the `stratified`, `aggregate` and boundary
  cohorts; kernel-scoped profile of the constructor; peak RSS; receipts under
  `analysis/rel-frontend/`; a retained control at the kept revision for the next A/B.
- Report `notes/2026-09-16-c1191-direct-constructor-report.md` in the playbook's reporting shape
  with a Mystery ledger, and an independent read-only audit
  `notes/2026-09-16-c1191-direct-constructor-audit.md`.
