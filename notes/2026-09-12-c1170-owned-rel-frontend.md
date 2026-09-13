# C1170 — owned Rel-rich frontend prototype

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS. Two-hour continuation began 2026-09-13 05:24:50 UTC;
target stop 07:24:50 UTC.

Establish a versioned syntax/admission coverage contract with at least the
expressive richness of Rel, then implement a bounded owned lexer/parser and
diagnostic prototype to test the representation and performance approach.
Authority and source study: `2026-09-12-c1169-datalog-frontends.md` and the
binding user directions in `ergodis-architecture-context.md`.

## Scope

- Pin the Rel documentation and official editor grammar/test references;
  create original feature fixtures with explicit expected structure, precedence,
  binding, error categories and spans. Label prototype omissions; a small
  fragment is not the final language target.
- Reuse applicable owned scanner/interning machinery after inspecting the
  existing core. Prefer a small runtime dependency surface. All backend,
  semantic admission/lowering, rule handling and joins remain Ergodis-owned.
- Prototype compact span/ID pools and an explicit bounded parsing stack, with
  capacity planning before scanning and no hidden allocation/growth in the
  repeated scan. Include setup and materialization in measured totals.
- Implement the normal/diagnostic split: compact successful parse, structured
  failure, optional richer error-only reparse and separate rendering. Require
  Rust/iidy-hs-quality context, primary/secondary spans, IDs and useful fixes;
  preserve rejection and keep semantic provenance for non-syntax failures.
- Exercise representative complexity immediately: Rel operator precedence,
  Unicode, qualified/partial application, binders/varargs, nested modules and
  interpolation/raw strings. Expand coverage using an explicit manifest.

## Acceptance

Correctness precedes speed: positive/negative fixture agreement, full input
consumption, deterministic errors, capacity/nesting controls and native/WASM
parity. Parser prototype success does not establish production execution or
Lean proof coverage for the parsed forms.

Retain release baselines and input hashes; use interleaved equal-work A/B with
allocation counts, peak memory, time distributions and hardware counters for
scanning-loop changes. Separate parse, diagnostic reparse, admission/lowering
and end-to-end boundaries. Include malformed inputs and error rendering quality;
do not optimize the successful path by making diagnostics inadequate.

The deliverable is the coverage contract, a validated bounded prototype and
measured disposition of candidate representations. It is not a claim that all
Rel semantics are implemented. Allocate the remaining frontend/production
lowering work from the resulting coverage manifest.

Tree-sitter/editor integration and an executable semantics reference (PLT
Redex or similar) are deferred, not prerequisites. No foreign evaluator or
join runtime is an allowed shortcut. No new runtime dependency, performance
claim or backend policy change is made by this queue entry.
