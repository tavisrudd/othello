# C1206 — structured refusals: every budget and capacity refusal says what was refused and why

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: QUEUED (allocated by Tavis, 2026-09-18, from the C1204 review).

## Goal

A caller of the Datalog/Rel path who is refused learns, from the returned value alone, which
bound refused, on which object, what the limit was, what was observed or projected, and which
knob (if any) moves it. Today core returns one payload-free `Error::Budget` for a zero row bound,
a workspace reservation above `MAX_WORKSPACE_BYTES`, a relation's row capacity exhausted
mid-evaluation and the round guard; `Error::Source` and `Error::Binding` are equally bare; the
stratified driver maps every core `Budget` to `LayerCapacity { layer, max_rows }`, which tells the
caller to raise `max_rows` when the refusal was address space; and the private side reports
refusals in three further shapes.

Source of the findings: `notes/2026-09-18-c1204-datalog-rel-architecture-review-report.md`
(finding G and mystery-ledger items 2 and 3), backed by
`notes/2026-09-18-c1204-review-half2-contract-evaluator-checkers.md` (F4, F5 and the budget
inventory in its section 4) and
`notes/2026-09-18-c1204-review-half1-frontend-lowering-driver.md` (F10, F12).

## Scope

### Core (`crates/verify`, `crates/rules`)

The core half runs after C1209 (contract crate split, Tavis 2026-09-21): the error type and the
refusal record are contract types and land in the contract crate. The private half does not wait.

- A refusal record carried by the error — kind of bound, the relation or index it concerns where
  one exists, the round where one exists, the limit, the observed or projected figure, and the
  unit — produced at every site in `demand.rs` that refuses, and at the admission sites in
  `datalog.rs` whose refusal is a bound rather than a malformed source. A malformed source says
  which rule, relation or fact and which requirement failed.
- The checkers' `Rejection` values keep their structure when they cross into `Error` (today they
  are formatted with `{0:?}`).
- Clamp the caller-supplied `direct_limit` at the public checker entry points.
- One statement of the budget model where a reader of `demand.rs` will meet it: each bound, its
  unit, whether it is a refusal or a fallback to another representation, and that the checker's
  direct limit is deliberately independent of the evaluator's ceilings (C1208 triage: the two
  docstrings already derive their own figures, 64 MiB of index heads against 256 MiB of checker
  array, so this needs a cross-reference, not a new argument). The statement also says what
  `MAX_WORKSPACE_BYTES` was chosen against; it is the one core budget with no derivation.
- The refusal path stays cold: no new work, state or register pressure in the derivation loop.
  The record is built at the refusal site from values already in hand.

### Private (`src/rel_stratified.rs`, `src/rel_frontend/lower.rs`, `tasks/tools`)

- The driver stops collapsing core refusals: a layer refusal names the layer, the relation, the
  core refusal record and the knob that moves it, with a source span where the lowering can supply
  one.
- Every route refusal (`MAX_COMPLEMENT`, `MAX_FILTER`, `MAX_LAYER_TUPLES`, row capacity) takes the
  `Budget`-with-numbers-and-span shape the lowering already uses, in the `REL05xx` family, and
  distinguishes "the workspace you asked for was too small" from "this route will not do that".
- Record-check errors name the record kind, its index and the failing field; `CheckersDisagree`
  names the relation and the first differing tuple. (If C1205 milestone b lands first it owns this
  item; whichever task runs second verifies it.)
- Move `MAX_COMPLEMENT`/`MAX_FILTER` beside `MAX_LAYER_TUPLES` where they are enforced; their
  docstrings already explain why the three share a value, so state the missing part, what 2^22
  was chosen against, and that `MAX_COMPLEMENT` also bounds a one-byte-per-entry membership
  vector that the construction and the record check each allocate (C1208 triage); anchor
  `MAX_NAME` to a named core constant or extend the constants test.
- `rel-lower` and the bench print the structured refusal; a refused cohort in a receipt records the
  refusal record, which is what C1195's reach tables need.

## Relation to C1207

C1207 audits error reporting across the whole product and designs the general model. C1206 is
the bounded repair of the one subsystem where the defect is already located, and it does not wait
for C1207. To keep the two compatible: keep the refusal record a plain data type with stable
field meanings and no rendering in it, keep rendering in the existing diagnostic layer, and list
in the report every choice C1207 might want to revisit. C1207 reviews this task's record type as
one of its inputs.

## Acceptance

- A test per refusal site asserts the record's fields; a table-driven test over the driver shows
  that a reservation refusal, a row-capacity refusal and each route bound produce distinct,
  correctly attributed errors.
- No `Error::Budget` without a record remains reachable from `Demand` or the driver.
- Digests, work counters, plan fingerprints, the parity digest and the C1189 differential are
  unmoved; the derivation loop holds against the retained control within the A/A null, with the
  compiled loop compared, since a recompile of `evaluate_into` has moved it before for unrelated
  edits. Performance rules: `~/src/ergodis-dev/PERFORMANCE.md` and the playbook.
- Source comments follow the professional-comment standard.
- Independent read-only audit by a fresh Opus sub before close.

## Out of scope

The grounded path's errors beyond what shares the enum; rich rendering and the general error
model (C1207); the domain ceiling itself (C1204 finding H); the C ABI's error codes beyond
keeping them working.

## Deliverables

- Dated report `notes/<date>-c1206-structured-refusals-report.md`, written incrementally.
- Lifecycle close per `notes/task-lifecycle-conventions.md`.
