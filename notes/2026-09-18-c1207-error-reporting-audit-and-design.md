# C1207 — error reporting and error UI: audit and design session

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: QUEUED (allocated by Tavis, 2026-09-18). Audit and design; the session produces a
design and a task list, not code.

## Goal

One deliberate model for how Ergodis tells a person or a program that something was refused,
rejected or failed — across core, private, the tools, the C ABI and WASM boundary, and the browser
— replacing the shapes that accreted per feature. The C1204 review found the Datalog/Rel path
alone reports failure in at least six shapes (payload-free core `Error` variants; checker
`Rejection` enums flattened to debug strings on the way out; frontend `Failure`/`SemanticFailure`
with `REL` codes and spans; `LowerFailure` with a budget name and numbers; driver `Error` variants
with a layer and a knob; bare core errors passed through), and that a caller often cannot learn
what was refused. The binding user direction is that Datalog diagnostics be rich, with Rust and
`iidy-hs` as quality references (`notes/ergodis-architecture-context.md`).

## Part 1 — audit (read-only)

Inventory, per surface, as a table: every error type, where it is produced, what context it
carries (code, object, numbers, span, cause chain), what it loses when it crosses a boundary, and
what finally reaches a person.

- Core: `rule_contract::Error`, the checkers' `Rejection` enums, `composition_graph` and other
  `crates/verify` errors, `crates/rules`, `crates/runtime`, `crates/modules`; the C ABI and
  provider status codes; what WASM hosts receive.
- Private: `rel_frontend` codes and `diagnostic.rs` rendering, `LowerFailure`/`Budget`,
  `rel_stratified::Error`, `Readout::decode` (which renders an unknown dictionary id as `"?"`
  because it has no failure channel; C1208 triage), and a bounded sample of the non-Datalog providers and application
  modules, enough to tell whether they share the problem.
- Tools: what `ergodis-tools` subcommands print on failure, exit codes, what a receipt records for
  a refused or failed run.
- Browser: how the campaign console and application modules present a refusal, a rejection and an
  internal fault; whether a stored record that failed verification is distinguishable from one
  never checked.
- Classify every failure into a small taxonomy and test it against the inventory: malformed input;
  well-formed but outside the supported fragment; refused by a budget (caller-movable or fixed);
  certificate rejected; internal invariant broken; host or environment failure. Name the cases the
  taxonomy does not fit.
- Collect the worst real messages verbatim with the command that produces each.

## Part 2 — design session (with Tavis)

Bring a proposal with alternatives and a recommendation for each; decide in the session:

1. **The model**: one error vocabulary across crates or a per-layer type with a lossless
   conversion rule; how cause chains and layer context (layer, relation, rule, source span)
   accumulate as an error moves outward; stable codes (extend `REL` numbering or a product-wide
   scheme) and what stability promise they carry.
2. **Data versus rendering**: errors as plain data with rendering in one place; the machine form
   (JSON for tools, receipts, the ABI and WASM) and the human form (terminal, browser) generated
   from the same value.
3. **Refusals as first-class results**: a refusal names the bound, the limit, the observed figure
   and the knob that moves it, and says whether retrying with a different setting can succeed.
   C1206's record type is the concrete input here; confirm or revise it.
4. **Diagnostics quality bar**: what a good message contains, measured against the Rust compiler
   and `iidy-hs`; the error-only diagnostic reparse already in the architecture direction; spans
   through lowering into layer and rule refusals.
5. **Trust-relevant failures**: how a certificate rejection, a record mismatch or a checker
   disagreement is presented differently from a user error, and what evidence it carries
   (coordinate with C1205's layer records).
6. **Boundaries**: ABI and WASM status codes against structured payloads; performance rules for
   error paths (cold, no hot-loop cost, no allocation where the stage is allocation-free).
7. **UI**: how the browser and the tools present each taxonomy class; what is shown by default and
   what below the fold, per the existing UI direction (no collapse panels for important detail, no
   implementation vocabulary in normal workflows).

## Method

- Audit by one deep Opus sub writing its inventory to disk incrementally, within the context cap;
  the main agent probes the boundaries directly (what is lost at each crossing) rather than only
  summarizing.
- The design proposal is written before the session and leads with recommendations; open decisions
  are listed as questions with short pros and cons.
- Read-only in `ergodis`, `ergodis-private` and `ergodis-dev`.

## Deliverables

- `notes/<date>-c1207-error-reporting-audit.md`: the inventory, the taxonomy fit, the verbatim
  worst cases, the boundary-loss table.
- `notes/<date>-c1207-error-model-design.md`: the proposal, the session's decisions, and a private
  ADR draft if Tavis wants the decision recorded there.
- A ranked list of implementation candidates to queue, without identifiers.
- Lifecycle close per `notes/task-lifecycle-conventions.md`.

## Relation to other tasks

C1206 repairs refusals on the Datalog/Rel path now and is an input here, not a dependent. C1205
defines the evidence a trust-relevant failure can point at. C1195's reach tables consume
structured refusals.
