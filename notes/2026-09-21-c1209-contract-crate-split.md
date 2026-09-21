# C1209 — contract crate split out of `ergodis-verify`

**Lane**: `ergodis`
**Date**: 2026-09-21
**Status**: QUEUED (allocated by Tavis, 2026-09-21, from C1204 finding N via the C1208 triage,
decision 5: split, and split first). **Runs before C1205 milestone a and before C1206's core
half**, so the prepared-source encoder and decoder and the refusal record land in the contract
crate from the start.

## Goal

The producer-facing contract (wire types, admitted types, admission, budgets, the error type) lives
in its own crate, and `ergodis-verify` holds the checkers, their stores and an implementation
identity over checker source. Today `ergodis-rules` and `ergodis-private` depend on the checker
crate for producer input types, and any edit to those types, a docstring included, moves
`implementation_identity()`, under which the binary-composition verification record is minted.

Sources: `notes/2026-09-18-c1204-review-half2-contract-evaluator-checkers.md` (F15, identity
inventory, dependency arrows), `notes/2026-09-21-c1208-step2-code-verification.md` (items 7 and
13: the exact hashed file list, that `support.rs` is a module of the crate and is not hashed, and
that the identity's one consumer is `binary_composition.rs`'s verification record),
`notes/2026-09-21-c1208-c1204-findings-triage-report.md` (decision 5).

## Decided (Tavis delegated the call, 2026-09-21; main agent's decisions)

- **Two identities** (item 2, option (a)). `ergodis-contract` exposes its own implementation
  identity over all of its sources, built the way the checker's is; `ergodis-verify`'s identity
  covers checker sources only. A verification record carries both, as separate named fields, so a
  reader can tell a contract edit from a checker edit, and the checker identity is stable under
  producer-facing changes. Reasons against the others: keeping admission in the checker crate
  leaves `ergodis-rules` depending on the checker crate for admission and keeps most of the
  coupling; one identity over both crates keeps all of it. Consequence for the C1208 decision on a
  checker identity field for Datalog certificates: wherever that field lands, it is the pair.
- **The checker identity covers every checker source file, `support.rs` included** (item 3), with
  a test that fails when a module of either crate is missing from its crate's list. The identity
  moves once in this task anyway, so the omission is repaired in the same move.
- **No transition re-exports** (item 4): every importer is updated in the same change.

Item 1 (the exact cut) stays a design-step reading, recorded in the report.

## Design step first

1. **The cut.** Proposed: a new `ergodis-contract` crate takes `rule_contract`'s wire types,
   schema constants, `Error`, encoding and identity functions, and `datalog`'s budgets,
   `Prepared*`/`Slot`/`AtomRef`/`Admitted*` types and both admission functions. `ergodis-verify`
   keeps `derivation`, `ranked`, `datalog_store`, `composition_graph`, `support`, `weight`, the
   other capability checkers and `lib.rs`'s identity. Settle by reading, and record in the report:
   where `ground`/`Grounded` and the scalar `Certificate` go (grounded admission is contract; the
   replay is checker), where the certificate structs go (a producer emits them, a checker reads
   them), and whether `weight` is contract (it is sealed and the grounded producer instantiates
   it). Dependency direction: `verify` → `contract`; `rules` → `contract` and `verify`.
2. **What the checker identity must still cover — decision for Tavis.** A checker's verdict
   depends on admission: `check` re-admits the source, and both checkers share that admission.
   Moving admission out of the hashed set removes trust-relevant code from the identity a
   verification record carries. Bring a recommendation among: (a) the record carries two
   identities, checker and contract, each over its own crate's sources; (b) the split puts
   admission on the checker side and only the types and budgets in the contract crate, so the
   identity keeps covering it; (c) one identity that hashes both crates' sources, which keeps the
   coupling the split is meant to remove. State what each does to C1208 decision 4's checker
   identity field on Datalog certificates.
3. **`support.rs`.** It is a checker module and is not hashed today. Decide whether the repaired
   identity covers every checker source file, with a test that fails when a module is added to the
   crate and not to the list.
4. **Re-exports.** Whether `ergodis-verify` re-exports the moved paths for one transition, or every
   importer is updated in the same change (recommended: update them; nothing is published).

## Scope

- Core: the new crate, the moves, `Cargo` wiring, importers in `crates/rules`, `crates/runtime`,
  the root crate and tests; the identity repaired per the design step; the export manifest,
  publication lint and `SHA256SUMS` absorb the new crate; `docs/rule-contract.md` and the crate
  docstrings describe the code as it stands.
- Private: importers under `src/rel_lowering.rs`, `src/rel_stratified.rs`, `examples/`, `tasks/`
  and tests follow the move. The bare-`rustc` parity harness is untouched (the frontend imports
  neither crate).
- Receipts: list every stored artifact that carries `implementation_identity()` and regenerate or
  mark each; say which evidence-repository files are affected. No evidence snapshot is cut.
- No behaviour change: this is a move. No type, budget, schema string, encoding or error variant
  changes here; C1205, C1206 and the schema-string decision own those.

## Acceptance

- Wire and prepared source identities, certificate bytes, plan fingerprints, the parity digest and
  the C1189 differential are unmoved; the full core and private test suites, the Lean audit gate's
  Rust-side inputs and the documented wasm32 build of `ergodis-rules` with its ABI test pass.
- `implementation_identity()` changes exactly once, the new value and the reason are recorded, and
  an edit to a contract-crate docstring is shown not to move it (or, under option (b) or (c), the
  report says precisely what still does).
- The derivation loop and the frontend/backend stages hold against the retained controls within
  the A/A null, with the compiled `evaluate_into` compared, since crate boundaries change inlining
  and ThinLTO has moved this kernel before for unrelated edits. Re-retain first, as the lane
  handoff says. Performance rules: `~/src/ergodis-dev/PERFORMANCE.md` and the playbook.
- The filtered export manifest and lint are clean with the new crate included.
- Source comments follow the professional-comment standard: no task IDs, notes paths or process
  narrative.
- Independent read-only audit by a fresh Opus sub before close.

## Out of scope

Any change to the contract itself; the product/instrument split of `ergodis-rules`; the `Prepared`
rename; the Rel subsystem's own crate boundary in `ergodis-private`; an ABI for the Datalog path.
Each is a separate proposal in the C1208 triage report.

## Deliverables

- Dated report `notes/<date>-c1209-contract-crate-split-report.md`, written incrementally: the cut
  as built, the identity decision, the receipt inventory, the A/B.
- Lifecycle close per `notes/task-lifecycle-conventions.md`.
