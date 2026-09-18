# C1204 — architecture review of the Datalog/Rel functionality in ergodis and ergodis-private

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: QUEUED (Tavis, 2026-09-18: to be run in a fresh session). Read-only review; no code
change.

## Goal

A general architectural review of everything Datalog- and Rel-related that has landed in
`~/src/ergodis` (core) and `~/src/ergodis-private`, at the level of high-level design: the
contracts between layers, the types that carry them, modularity and crate ownership, and where the
design is bending under the features added since C1179. Not a performance review and not a
line-level code review. The output is a ranked set of findings with recommendations that Tavis can
turn into tasks, plus a current architecture map that does not exist yet as one document.

## Precondition

The source-comment clean-up should land first so the review reads clean source and does not spend
findings on comment hygiene: core clean-up report
`notes/2026-09-18-ergodis-core-comment-cleanup-report.md` (in progress at allocation), private
inventory `notes/2026-09-18-ergodis-private-dev-task-reference-sweep.md` (fix not yet run). If the
private fix has not run, proceed anyway and ignore comment hygiene as a finding class.

## Scope: the subsystems and their seams

Trace one program end to end (Rel source → certificate accepted by both checkers) and review each
layer and, above all, each seam:

1. **Rel frontend** (private): scan, parse, admit; the zero-allocation workspace; diagnostics
   (`REL01xx`–`REL04xx`); the native/WASM parity harness and what its bare-`rustc` constraint
   forces on the crate graph.
2. **Lowering and the relational IR** (private; ADR 0004): literal signs, typed dictionary,
   per-column domains, strata/layers, auxiliaries, `BodyPolicy::{Binarize, Nary}`; the recorded
   deviation that the backend lives in sibling `src/rel_lowering.rs` because the parity harness
   cannot depend on `ergodis-verify`.
3. **Stratified driver** (`src/rel_stratified.rs`): one contract `Program` and certificate per
   layer, complement facts, aggregates and comparison filter relations computed at layer
   boundaries, digest-checked records; `MAX_LAYER_TUPLES`.
4. **Rule contract** (core `crates/rules`): `rule_contract.rs`, the JSON identity against the
   streamed binary identity, the two `Demand` constructors (wire and direct/prepared),
   `Demand::source()` as an `Option`, the `Prepared` name clash, `MAX_BODY`.
5. **Demand evaluator** (core `crates/rules/src/demand.rs`): plan, ops (`OP_KEY`/`OP_CHECK`),
   index kinds and the `Policy` enum (including the public `Direct`/`Sparse*`/`AutoUndemoted`
   corners that exist for measurement), the policy constants and the cardinality estimate, the lazy
   workspace (`Pages`, reset rule), the instrumented `COUNT` instantiation, limits and refusals.
6. **Certificates and checkers** (core `crates/verify`): derivation trace and ranked-relation
   certificates, `premise_stride`, `check_admitted` against the wire path, `datalog_store.rs`,
   closed-world pass, `implementation_identity()` and what hashing checker sources blocks.
7. **Reference evaluator and differential harness** (private, test-only): its independence from
   the code it checks, corpus generation, what it cannot see.
8. **Measurement and tooling boundary**: `closure_ballpark`, `ergodis-tools` subcommands,
   `analysis/datalog-comparison/`; how much measurement surface has leaked into core public API.
9. **Generic carrier and the wider rule programme** (C1172–C1177): how the Boolean Datalog path
   relates to the ordered-inflationary carrier and min-plus, since C1194 will push term arithmetic
   through the lowering next.

## Questions the review must answer

- **Ownership**: is the core/private split principled for this subsystem (what is in core because
  it is contract, what is in private because it is product), and does each dependency arrow point
  the right way? Name every arrow that exists for an incidental reason.
- **Contracts**: for each seam, what is the contract, where is it written down, what enforces it
  (types, a checker, a test, nothing)? Which contracts are stated only in dated reports?
- **Types**: where do types make illegal states unrepresentable and where are invariants carried
  by convention (parallel arrays, sentinel values, `u32` ids without newtypes, `Option` used as a
  mode flag, policy enums doubling as test hooks)?
- **Trust boundary**: what exactly must be trusted for an accepted certificate to mean the answer
  is right? Is the checker's independence from evaluator, lowering and frontend real at the crate
  and code-sharing level? Aggregates, complements and filter relations are computed outside the
  core contract: what checks them, and is that check independent?
- **Identity**: how many identities exist (JSON, streamed binary, implementation, parity digest,
  plan fingerprint), what each one binds, and whether any two can disagree silently.
- **Limits and refusals**: is there one coherent model of budgets (`Limits`, `MAX_*` constants,
  row bound, workspace bytes, layer tuples), one error taxonomy, and one place a caller learns
  what was refused and why?
- **Extension pressure**: what breaks or needs redesign for the queued work — C1194 min-plus and
  term arithmetic, C1195 end-to-end suite, C1196 certificate encodings, the C1203 successor (a
  plan told its expected evaluation count), a cost-based planner, incremental evaluation, WASM?
- **Accretion**: which structures are the residue of the order features landed in (the
  binarization path kept beside n-ary bodies, two constructors, two checker entry points, sibling
  modules placed by harness constraints), and which of those should be collapsed?
- **API surface**: what is public in core that should not be, and what would a first outside
  user of `ergodis-rules` actually have to understand?

## Method

- Read `notes/ergodis-architecture-context.md` and the private ADRs (0004 in particular) first;
  then the code. Reports are for intent and history only; the review is of the code as it stands.
- Read-only. No edits in `ergodis`, `ergodis-private` or `ergodis-dev`.
- Build the map first (crates, modules, public types, dependency arrows, data flow for one traced
  program), then assess. A finding cites `file:symbol` and states the consequence, not only the
  smell.
- Severity by consequence: soundness or trust-boundary risk; blocks queued work; costs every
  future change; cosmetic. Each finding carries a recommendation and a rough size.
- Suggested execution: one deep Opus reviewer per half (frontend→lowering→driver; contract→
  evaluator→checkers), then a synthesis by the main agent; keep within two concurrent subs and
  the 500K context cap, reports written incrementally to disk by the subs themselves.
- Every sub prompt carries the source-comment standard (memory: professional comments only) even
  though the task is read-only, so recommendations do not propose process notes in source.

## Out of scope

Performance tuning, constants, benchmark method, comment hygiene, the non-Datalog engine
(solver, decoders, Hadamard, leakage, causal) except where they share a contract with this
subsystem.

## Deliverables

- `notes/2026-09-18-c1204-datalog-rel-architecture-review-report.md` (date it on the day it is
  written): architecture map with a dependency diagram; per-seam contract table; ranked findings
  with recommendations and sizes; a short "what I would do first" list; candidates to queue without
  identifiers; mystery ledger only if something is unexplained.
- Lifecycle close per `notes/task-lifecycle-conventions.md`.

## Inputs

- `notes/handoffs/2026-09-05-ergodis-lane.md` (the C1190 block indexes every report).
- `notes/2026-09-15-c1190-lowering-architecture.md`, `notes/2026-09-16-ergodis-datalog-programme-review.md`,
  `notes/2026-09-12-ergodis-rule-contract-programme.md`, `notes/ergodis-architecture-context.md`.
- Core `~/src/ergodis/crates/{rules,verify}`; private `~/src/ergodis-private/src/rel_*.rs`,
  `tasks/`, `examples/closure_ballpark.rs`, `analysis/datalog-comparison/`, `docs` ADRs.
