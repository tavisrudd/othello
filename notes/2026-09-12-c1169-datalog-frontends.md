# C1169 — Datalog frontend study

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE — source study and implementation requirements; no parser implemented.

Study source parsing, syntax trees, diagnostics and frontend separability in
Nemo, Ascent and Crepe. Datafrog and Differential Dataflow supply backend
machinery, outside this study. Ergodis retains semantic admission/lowering,
rules handling, joins and execution under its performance discipline.

User preference: own the parser if the admitted grammar is straightforward,
for performance/control and a simpler dependency surface.
Evaluate foreign frontends primarily for useful grammar/diagnostic patterns;
do not assume an external parser dependency is the desired result.
Parsing itself must follow the performance contract. The required language
target is at least the richness of Rel's documented syntax; a small positive
fragment is an implementation stage only. Assess this richer target explicitly.

Acceptance: source-linked assessment of extraction costs and supported syntax,
a recommendation with an explicit language boundary, and a scoped future
implementation gate. This study does not install dependencies, implement a
language, select a foreign evaluator or claim measured parser performance.

## Decision

Prefer an Ergodis-owned parser, designed for Rel-level syntax from the outset.
The most useful reference is now RelationalAI's official editor grammar and
its test corpus. Study the other implementations for spans, diagnostics and
grammar organization. Do not introduce their evaluator, macro compiler or
physical data model as a dependency of our rules backend.

The richer syntax is tractable enough to justify an owned-parser feasibility
slice, but it is not the earlier tiny positive-Datalog grammar. The previous
informal 1–2 day / 1–3 week estimates do not estimate this larger requirement.
There is no measured parser comparison yet. Ownership is the user's
architectural preference; a speed claim still needs measurement.

## Source inspection

Inspected 2026-09-13 UTC. Revisions below pin the source assessment, not a
dependency selection. No upstream code was built, installed or vendored.

| Source | Finding | Disposition |
|---|---|---|
| [Official Rel editor grammar](https://github.com/RelationalAI/codemirror-lang-rel/tree/f1b3c851d35c54bbd70b1f4eabf744d896206035) | Lezer grammar, a separate raw-string tokenizer, and declaration/expression/literal test files; package integrates CodeMirror | Primary grammar/test reference, not the runtime parser |
| [Nemo](https://github.com/knowsys/nemo/tree/e578c283c996bb1b029e5642ce96f814d1b0bfae) | Public text parser and borrowed-source AST; parser shares error/report and rule-model interfaces with the main engine crate | Learn from source spans and recovery; direct crate reuse has too broad a dependency surface for this requirement |
| [Ascent](https://github.com/s-arash/ascent/tree/e52c84b4419c56976413de1cbf15d56c8c136a5c) | Syntax module is private inside a procedural-macro crate; syntax includes Rust expressions, patterns and types; macro entry proceeds through desugaring, HIR, MIR and code generation | Study only; extraction would require maintaining a forked frontend boundary |
| [Crepe](https://github.com/ekzhang/crepe/tree/b26a58005b6e13261cb6466336bc5578d620f825) | Small private parsing module delegates expressions/types/patterns to `syn`; exposed product is a procedural macro | Useful small grammar organization, but not a standalone Rel frontend |

Nemo's [parser entry](https://github.com/knowsys/nemo/blob/e578c283c996bb1b029e5642ce96f814d1b0bfae/nemo/src/parser.rs)
returns an AST with an error report on failure, which is a useful separation.
Its [manifest](https://github.com/knowsys/nemo/blob/e578c283c996bb1b029e5642ce96f814d1b0bfae/nemo/Cargo.toml)
directly depends on `nemo-physical` and includes HTTP, compression and data-format
libraries. The crate exposes no parser-only feature in that manifest. Merely
calling only the parser is not the same as depending on a standalone parser
crate. This is a dependency assessment, not measured linked-binary size.

Ascent's [macro entry](https://github.com/s-arash/ascent/blob/e52c84b4419c56976413de1cbf15d56c8c136a5c/ascent_macro/src/lib.rs)
and [manifest](https://github.com/s-arash/ascent/blob/e52c84b4419c56976413de1cbf15d56c8c136a5c/ascent_macro/Cargo.toml)
make the compile-time coupling explicit. Crepe's
[parser](https://github.com/ekzhang/crepe/blob/b26a58005b6e13261cb6466336bc5578d620f825/src/parse.rs)
is compact because Rust parsing is delegated; its size is not evidence that
Rel's complete frontend has the same implementation cost.

The Rel package's [grammar](https://github.com/RelationalAI/codemirror-lang-rel/blob/f1b3c851d35c54bbd70b1f4eabf744d896206035/src/syntax.grammar)
includes declaration families, expression precedence and explicit ambiguity
markers. It also contains workarounds and a TODO for nested declarations in
`with/use`. Its README's `test/cases.txt` path is stale at the pinned revision;
the actual [test directory](https://github.com/RelationalAI/codemirror-lang-rel/tree/f1b3c851d35c54bbd70b1f4eabf744d896206035/test)
has `Declarations.test.txt`, `Expressions.test.txt`, `Identifiers.test.txt`,
`Literals.test.txt`, `Misc.test.txt`, `Prelude.test.txt` and `test.js`.
Use those fixtures as syntax references, not as proof of backend semantics or
complete language coverage. No upstream test suite was run in this study.

Datafrog and Differential Dataflow have no role in the selected frontend
ownership plan. The earlier suggestion to reuse their join/runtime machinery
is superseded by the user's explicit backend ownership requirement.

## Rel richness baseline

The baseline is the [Rel language reference](https://rel.relational.ai/rel/ref),
not the newer PyRel host API. This is a required feature inventory for the
language contract; every row still needs our grammar fixtures, admission laws
and execution coverage. It is not a claim that our current backend supports
these constructs.

| Family | Required language coverage | Ergodis obligation beyond parsing |
|---|---|---|
| Lexical forms | Case-sensitive names, Unicode identifiers/operators, symbols and qualified names, comments | Explicit Unicode policy, normalized identity and checked ranges |
| Literals | Numeric, Boolean, character, string/raw/multiline/interpolated, relation/tuple and typed literals | Exact value representation; no accidental min-plus interpretation of ordinary arithmetic |
| Declarations | Definitions, bounds, value/entity types, annotations, constraints | Name resolution, arity/type and annotation admission |
| Relational expressions | Application/partial application, composition, products, union, restriction and override | Own operators, preserved relation arity and meaning |
| Abstractions and scope | Binders, comprehensions, underscores, local scopes, varargs | Capture avoidance, binding and arity checks |
| Logic | Conjunction/disjunction, negation, implication/equivalence, quantifiers, conditionals | Domain and negation/stratification policies, separate from min-plus convergence |
| Aggregation | Higher-order application, grouped and nested aggregations | Group/key preservation, duplicate semantics and admitted aggregation operators |
| Higher order | Relation parameters and specialization | Own elaboration/specialization, bounded compiled representations |
| Modules | Namespaces, nested/parameterized modules, imports/aliases | Deterministic resolution and own module lowering |
| Recursion | Recursive definitions, including interactions with the other families | Per-fragment termination/fixpoint contract and checked execution |

[Lexical syntax](https://rel.relational.ai/rel/ref/lexical) and
[precedence](https://rel.relational.ai/rel/ref/expressions/precedence) are
particularly important: qualified names, composition and application interact;
operator associativity cannot be guessed from punctuation. The lexical page
also qualifies its broad Unicode description with restricted supported ranges.
Our contract must resolve that explicitly rather than inherit an ambiguity.

[Aggregation](https://rel.relational.ai/rel/ref/expressions/aggregation) has no
dedicated grammar form in Rel: it is expressed through higher-order operations.
The documented duplicate-elimination pitfalls make keyed aggregation a semantic
test requirement. [Higher-order definitions](https://rel.relational.ai/rel/ref/higherorder)
include relation arguments and varargs; a parser for first-order Horn clauses
would miss this required expressive surface.

[Modules](https://rel.relational.ai/rel/concepts/modules) include parameterization
and nested relations. [Recursion](https://rel.relational.ai/rel/concepts/recursion)
extends beyond the finite bounded min-plus contract now proved in Lean.
The existing N/output-count termination theorems must not be generalized to
arbitrary Rel-like programs by accepting their syntax.

Richness is the minimum language target. Exact source compatibility, library
coverage and service/transaction compatibility need explicit contracts; a
different spelling alone does not satisfy missing expressiveness. Smaller
implementation stages must report their missing rows instead of redefining
the target downward.

## Parser performance requirements

The contributor `PERFORMANCE.md` and complete playbook were read for this
assessment. They apply to parsing as instructed, not just to the solver.

1. Own the source buffer once; retain byte spans and compact IDs instead of
   copying each token into a string. Keep syntax records in contiguous pools;
   intern semantic names once at an explicit boundary. Reuse existing owned
   scanner/interning infrastructure where it fits before adding another stack.
2. Reserve bounded workspace before scanning. Use a presized explicit stack
   for nested forms and precedence handling; do not rely on the process stack
   or allocate one boxed object per syntax node. Capacity exhaustion returns
   a bounded structured error, with no hidden growth fallback.
3. Count setup and output allocations as well as assert zero allocations in
   repeated scanning after reservation. A counting/reservation pass is only a
   candidate: include its source scan in total work and measure it against a
   safe alternative. Parser setup is not free because it precedes execution.
4. Keep diagnostic code/byte spans separate from formatted messages. Require
   full-input consumption, progress during recovery and precise malformed-UTF8,
   overflow, unterminated-string/comment and nesting-limit behavior. The shared
   native/WASM parser must agree on accepted forms and structured errors.
5. Retain identical accepted-program outputs for A/B controls. Measure lexing,
   parsing, admission/lowering and total source-to-admitted-program cost
   separately; include symbol materialization and buffer ownership in the
   matched boundary. Also report actual end-to-end execution where relevant.
6. Freeze representative Rel-rich and generated stress inputs: Unicode,
   qualified/application/composition precedence, nested binders/modules,
   interpolation/raw quotes, long identifiers, repeated/unique symbols, huge
   literal relations and malformed inputs at early/late positions. Report
   bytes, tokens/nodes, allocations, memory and sample distributions. Use
   release retained binaries, interleaved pairs and instruction/cycle/branch/
   cache counters to explain changes to the scanning loops.
7. Prefer no new runtime parsing dependency if the owned design passes those
   gates. A library or a particular scanning technique earns inclusion through
   measured benefit and a simpler maintained surface, not reputation. No
   unsafe/SIMD or parallel-parser requirement is inferred before profiling.

An indexed, table-driven precedence parser with explicit stacks is a candidate
design, not a completed implementation or speed result. Rel's richer syntax
does not require adopting another system's execution strategy.

## Rich diagnostics without burdening successful parsing

User requirement: diagnostic quality comparable to Rust and the sibling
`iidy-hs` project. An error-only diagnostic reparse is an explicitly supported
design candidate. Tree-sitter and an executable semantics reference such as
PLT Redex are deferred; neither is an implementation prerequisite.

The inspected `iidy-hs` checkout is at HEAD
`bdeac376afdd8cc6ddb8cbe8beebcc964a285ed7`. Relevant source paths include
`src/Iidy/Yaml/Errors/Enhanced.hs`, `Display.hs`, `Conversion.hs`,
`Conversion/Guidance.hs` and `test/Test/ErrorContentTest.hs`. The enhanced
error model separates IDs, locations, expected/found values, available names,
suggestions, guidance, fix hints and examples. Display is a separate layer;
content tests assert diagnostic meaning independently of exact formatting.
These are quality and architecture references, not code to import into Rust.

Proposed implementation boundary:

- Successful parsing emits the compact production representation, byte spans
  and only the provenance needed by admission/lowering. It does not build a
  second rich tree, collect recovery alternatives, format messages or compute
  spelling suggestions for valid input.
- On failure, retain the original source and compact failure category/span.
  A separately specialized diagnostic pass may reparse it with richer syntax
  context, comments, recovery markers and expected-token sets. Keep diagnostic
  mode selection outside scanning loops; do not add an unconditional mode
  check per token just to enable the slow path.
- Render stable error IDs, primary and secondary labels, relevant source
  excerpts, expected/found information, declaration/use context, actionable
  fixes, examples and related notes. Render from structured data for terminal
  and browser consumers; a UI-specific formatter is not the parser.
- Name, type, arity, scope and rule-admission errors need semantic provenance
  from the owned compiler too. Reparsing supplies syntax context; it cannot
  reconstruct every semantic explanation by itself. Suggestions must use the
  actual visible scope and distinguish syntax from semantic errors.
- Diagnostic replay uses identical source bytes and grammar version. Recovery
  must make progress and stay within declared memory/nesting/error-count
  limits. It never changes rejection into acceptance, applies a suggested fix
  automatically, executes source imports or invokes the solver.

Acceptance requires both fast-path allocation/counter evidence and useful
diagnostics. Retain negative fixtures for malformed syntax, ambiguous operator
grouping, misspelled names, wrong arity/types, shadowing, binding mistakes and
unadmitted recursion/aggregation. Assert IDs, primary/secondary spans, context
and suggestions, with rendering snapshots separately. Count error-path
latency/memory and recovery progress too. The error pass can spend more work
than successful parsing, but its cost and output size remain bounded.

## Next implementation gate

C1170 (`2026-09-12-c1170-owned-rel-frontend.md`) owns the next bounded slice.

Before implementation, pin a Rel feature/grammar contract and original
positive/negative fixtures for all inventory rows; resolve the documented
Unicode and editor-grammar edge cases. Separate syntax acceptance, semantic
admission, executable coverage and proof coverage in the feature manifest.
Then implement and measure the owned parser against that contract, followed by
admission/lowering into Ergodis-owned rules. No foreign backend is an allowed
shortcut for an unimplemented feature.

The join engine and larger external comparator suite keep their existing
workload gates. The user has supplied the language-richness target; obtaining
an external workload is not a prerequisite for specifying that frontend.

## Review and remaining questions

Source visibility and dependency coupling were checked directly, including the
actual Rel test filenames. This is a source study: no performance, portability,
grammar completeness or runtime conformance test is claimed. The remaining
gate is a versioned syntax/admission contract and owned parser measurement; the
official editor grammar supplies a useful reference, not automatic acceptance.
All observations here were sought by the task, so no incidental discovery-track
entry is added.
