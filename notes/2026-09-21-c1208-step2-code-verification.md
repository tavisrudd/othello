# C1208 step 2 — code re-verification of the unowned C1204 findings

**Lane**: `ergodis`
**Date**: 2026-09-21

Read-only verification at `ergodis` HEAD `96aee9b` and `ergodis-private` HEAD `1500dc2`. One
section per triage item: verdict, `file:line` evidence, and any fact that changes the disposition.

## 1. C / core F2 — the two checkers share the completeness pass, helpers, stores and admission

**VERIFIED.** `crates/verify/src/ranked.rs:28` imports `head_matches`, `unify` and `Relations`
from `derivation`; qualified uses are `derivation::mark_bound` (ranked.rs:93, 131, 173),
`derivation::fixed_mask` (ranked.rs:123, 130, 157, 172) and `derivation::closed_world`
(ranked.rs:347). Both checkers import the same store module
(`ranked.rs:27`, `derivation.rs:32`: `datalog_store::{JoinIndexes, RelationStore, Rows,
DIRECT_LIMIT}`) and the same admission (`ranked.rs:26`, `derivation.rs:31`: `datalog::{self,
Admitted, AtomRef, …}`); `ranked::check_bounded` calls `datalog::admit` at `ranked.rs:232`, as
`derivation::check` does.

Independence-claim site list for a "restate the claim" repair:

| Site | Text |
|---|---|
| `crates/verify/src/derivation.rs:209-211` | "The source is admitted here independently of the producer" |
| `crates/verify/src/ranked.rs:216-218` | same sentence, verbatim |
| `crates/rules/src/demand.rs:2759` | "Check a ranked certificate with the independent searching checker." |
| `crates/rules/src/demand.rs:2772-2773` | "Check a derivation certificate against the admitted source with the independent checker … The two source forms …" |
| private `src/rel_stratified.rs:2-3` | "one derivation certificate and one independent check per layer" |
| private `src/rel_stratified.rs:16-18` | "replayed by the core's independent checker and cross-checked against the core's second, searching checker" |
| private `src/rel_stratified.rs:24` | "enough for an independent checker to rebuild the complement" |
| private `src/rel_stratified.rs:964` | "the independent re-check of the one step of" |

**Correction to the core report:** private ADR 0004 (`docs/adr/0004-rel-lowering-ir.md`) makes no
independence claim — it contains no occurrence of "checker", "independent", "second" or
"cross-check". The adjacent claims in private docs are `docs/adr/0002-…:15` ("independent
checking", about the pipeline shape, not two checkers) and `docs/adr/0003-…:57` ("Native
independent checker", about external encodings). Neither asserts checker-to-checker independence,
so the repair's site list is source docstrings only, not the ADRs.

Disposition-relevant: `demand.rs:1134` ("assumes the levels are independent") is the cost model's
independence assumption, unrelated; do not include it. The repair is a wording change at eight
docstring sites and touches no code path.

## 2. E / core F7 — no Datalog checker tests in the checker crate

**VERIFIED, with one refinement.** `crates/verify/tests/` holds `composition_graph.rs`,
`composition_graph_oracle.py`, `finite_lowering_properties.rs` and `weight_properties.rs`; none
mentions `datalog`, `derivation` or `ranked` (`rg -c` over those files returns no match).
`derivation.rs` and `ranked.rs` contain no `#[cfg(test)]` module.

Refinement: the checker crate is not test-free on the Datalog side — `crates/verify/src/datalog.rs:635`
and `crates/verify/src/datalog_store.rs:270, 436` do carry inline `#[cfg(test)]` modules. The gap is
specifically the two *checkers* (`derivation`, `ranked`), not admission or the stores.

Every `Rejection::` assertion lives in the consumer crate's integration tests:
`crates/rules/tests/demand.rs` (23 occurrences), `crates/rules/tests/demand_prepared.rs` (1),
`crates/rules/tests/demand_nary.rs` (1). `ergodis-private` has none.

Disposition-relevant: a mutation harness for the checkers would have to be written in `rules`
(where the fixtures and `Rejection` assertions already are) or move fixtures into `verify`; the
`verify` crate has no Datalog fixture builder outside the two inline test modules.

## 3. H — `MAX_DOMAIN` 65,536 follows from packing a 4-tuple into `u64`

**VERIFIED.** `crates/verify/src/datalog.rs:47` `MAX_DOMAIN: u32 = 65_536`, `:49` `MAX_ARITY = 4`.
The key is mixed-radix base `domain`: `Admitted::pack` (`datalog.rs:166-171`) and the store's copy
(`datalog_store.rs:193-198`) both fold `key * domain + value`, and `tuple_key`
(`datalog_store.rs:409-417`) does the same over a column mask. At domain 65,536 and arity 4 the
largest key is `65_536^4 - 1 = u64::MAX`, so 65,536 is exactly the largest domain whose 4-tuples
are injective in a `u64`.

One nuance the report does not state: `universe` (`datalog.rs:95-99`) saturates on overflow
(`checked_pow(...).unwrap_or(u64::MAX)`), which the inline test pins —
`datalog.rs:789` asserts `universe(MAX_DOMAIN, 4) == u64::MAX`. So at the ceiling `universe`
already reports a value one below the true tuple count; any arity-dependent rule must not read
`universe` as an exact count at the top of the range.

Sites a per-program, arity-dependent ceiling would touch:

| Repository | Site | Role |
|---|---|---|
| core | `crates/verify/src/datalog.rs:47` | the constant |
| core | `crates/verify/src/datalog.rs:191` | wire-program admission door |
| core | `crates/verify/src/datalog.rs:430` | `admit_prepared` door |
| core | `crates/verify/src/datalog.rs:95` | `universe`, including its saturating overflow path |
| core | `crates/verify/src/datalog.rs:424-425` | the docstring listing the constants the identity covers |
| core | `crates/verify/src/datalog.rs:738, 789-791` | inline tests pinning the flat ceiling |
| private | `src/rel_frontend/lower.rs:1154` | the restated constant |
| private | `src/rel_frontend/lower/passes.rs:906-910` | `Budget::Domain` refusal |
| private | `src/rel_stratified.rs:1396-1400` | dictionary-size refusal, same `Budget::Domain` |
| private | `tests/rel_lowering.rs:1255` | the constants test, currently `assert_eq!` of the two constants |

`pack`, `tuple_key` and the checker stores need no change — the radix is already the program's
domain, not 16 bits. A search for `u16`/`65_535`/`1 << 16` over `datalog.rs`, `datalog_store.rs`,
`derivation.rs`, `ranked.rs` returns nothing, so no 16-bit width assumption exists downstream.

**Size: days, not hours,** and the reason is not the arithmetic. The refusal is a two-repository
mirrored constant with a `Budget::Domain` diagnostic that currently reports a fixed limit; making
the limit program-dependent changes the refusal's payload, and the constants test has to become an
agreement-of-rules test rather than an agreement-of-values test. The admission change itself is
small (replace `domain > MAX_DOMAIN` with a `checked_pow` over the program's largest arity in both
doors).

Foreign-hygiene note for Tavis: `tests/rel_lowering.rs:1256-1258` carries a "since C1192" comment —
a task ID in source, against the professional-comment standard. Not mine to fix; raising it.

## 4. I / private F7 — join order has two owners; `order_body` is skipped under the default policy

**VERIFIED.** `order_body` is defined at `src/rel_frontend/lower/passes.rs:476` and called exactly
once, at `passes.rs:613`, inside `chain`. `plan_bodies` (`passes.rs:538-587`) enters `chain` only
when `count > keep` (`passes.rs:544-546`), and its final loop fills `Rule.order` by pushing
`rule.first..rule.last` in pool order (`passes.rs:582-585`) — source order, not a chosen order. So
under `BodyPolicy::Nary` (`keep` 4) a body of at most four atoms never reaches `order_body` and the
core receives source order.

Core does order the links itself: `crates/rules/src/demand.rs:864-885` selects the non-delta atoms
"most key columns already bound first, then fewest free variables, then body order", and its own
comment names the shape as "the same greedy shape the Rel lowering's `order_positives` has".
`demand.rs:36-39` states the link order is a join order and not a semantics, `Link::old` and
`Link::position` carrying the semantics. So the correctness consequence is nil; the consequence is
that **body order is the core's final tiebreak**, which the C1193 report states in its own words at
`notes/2026-09-17-c1193-nary-bodies-report.md:378-380`.

### Mystery-ledger item 1 — did the C1193 measurements run through the Rel lowering?

**Verdict: not affected for the headline figures; the one lowering-borne cohort is affected only at
exact ties, and its arms do differ in body order.**

- `triangle`, `path3`, `path4`, `closure`, `samegen` (sparse and dense) are `closure_ballpark`
  cohorts. `examples/closure_ballpark.rs:42` imports `ergodis_verify::rule_contract::{… Program,
  Relation, SCHEMA}` and `fn program(…) -> Program` at `:356-357` hand-builds the contract program.
  The Rel lowering is not in that path, so the missing `order_body` cannot reach them. The three
  Soufflé programs are likewise hand-written source, not lowered.
- The `datalog` cohort runs through `rel-frontend-bench`, which does use the lowering under both
  policies: `tasks/tools/src/rel_frontend_bench.rs:58` imports `BodyPolicy`, carries it as a field
  (`:253`) and threads it into `w.lower_with(source, policy)` at `:306, :336, :645, :698`.
- For that cohort the arms *can* differ in body order. The source has a three-atom body every
  sixty-fourth definition (C1193 report, cohort table). Under `Binarize` (`keep` 2) such a body has
  `count > keep`, so `chain` runs and `order_body` chooses; the products are two-atom rules, which
  in core have a single inline link and nothing left to order. Under `Nary` (`keep` 4) the body is
  passed through in source order and core's greedy orders its two links, falling back to that
  source order only when both links tie on bound key columns and on free variables.

Remaining gap, stated exactly: nobody has measured whether any three-atom body in that source
actually hits the greedy's tie, so the residual effect is bounded by "at most a tiebreak in the
n-ary arm" rather than shown to be zero. That is a cheap check (instrument the tie branch in the
core's selection over the bench source), not a re-measurement.

## 5. J / core F9, private F8 — constructor and entry-point accretion

**VERIFIED.** Four `Demand` constructors: `new` (`crates/rules/src/demand.rs:716`), `new_bounded`
(`:728`), `from_prepared` (`:746`), `from_prepared_bounded` (`:752`); all funnel into one private
`prepare` (`:764`). Four entry points per checker: `derivation.rs:212, 223, 241, 248` and
`ranked.rs:219, 227, 239, 246` — `check`, `check_bounded`, `check_admitted`,
`check_admitted_bounded` in both.

The driver hard-wires the policy: the only `Demand::` construction in `ergodis-private` is
`src/rel_stratified.rs:1744` `Demand::from_prepared_bounded(…, max_rows, Policy::Auto)` with
`Policy::Auto` literal at `:1756`. `max_rows` is a bare `u32` parameter on the public driver
entry point, `src/rel_stratified.rs:1148-1153` `pub fn evaluate(rir, source, external, max_rows:
u32)`.

`demand.policy()` exists (`crates/rules/src/demand.rs:1551`, `pub const fn policy(&self) -> Policy`)
and a search for `.policy()` over `crates/` and the private `src/`, `tests/` and `tasks/tools/src`
finds no caller. So the accessor is dead at both heads — the report's claim holds.

Disposition-relevant: an options struct on the driver is cheap, because there is exactly one
construction site to change; the core-side constructor collapse is the larger half and has external
callers.

## 6. L / core F6 — two admission languages under one schema string and one identity function

**VERIFIED.** The single constant is `crates/verify/src/rule_contract.rs:27`
`pub const SCHEMA: &str = "finite-min-plus-rules.v1"`. Both doors demand it:
`rule_contract.rs:480` (`ground`: `program.schema != SCHEMA`) and `crates/verify/src/datalog.rs:186`
(`admit`, which additionally requires the Boolean carrier). The identity is also one function —
`rule_contract.rs:645-650` `identity_of` hashes `SCHEMA.as_bytes()` then the encoding, and its own
docstring says "`ground` and the demand-driven Datalog path bind certificates to the same identity";
`datalog.rs:180-182` repeats the claim from the other side. The per-`Program` hash prefix at
`rule_contract.rs:305` uses the same constant.

Sites carrying the string literal, core: `crates/verify/src/rule_contract.rs:27` (the constant),
`crates/rules/src/provider.rs:21` (the `DESCRIPTOR` JSON's `"schema"` field),
`crates/runtime/tests/nonlinear_queries.rs`, `docs/rule-contract.md`. Fixtures and recorded
artifacts that embed it: the JSON fixtures under `crates/rules/tests/`, two
`.proptest-regressions` files, and one evidence transcript under `evidence/` — ten files in all.
`ergodis-private` carries the literal in no Rust source and in one JSON file.

Disposition-relevant: a new schema string for the Datalog language is a wire-format change that
moves every `source_id`, because `identity_of` prefixes the schema name. That invalidates every
recorded certificate and the two proptest regression seeds, and it needs a rule for what
`PREPARED_SCHEMA` (`datalog.rs:320`, already a separate string) does. This is a Tavis decision, as
the card assumes.

## 7 and 13. N / core F15 and core F13 — what `implementation_identity()` hashes, and who reads it

**VERIFIED, with one addition.** `crates/verify/src/lib.rs:29-46` hashes a rule id, a rule version,
a literal tag, and then `include_bytes!` of, in order: `lib.rs`, `binary_composition.rs`,
`min_plus_transition.rs`, `composition_graph.rs`, `finite_lowering.rs`, `weight.rs`,
`rule_contract.rs`, `datalog.rs`, `datalog_store.rs`, `derivation.rs`, `ranked.rs`.

Addition the report does not make: `support.rs` is a module of the crate (`lib.rs:16`) and is **not**
hashed. So the identity already does not cover the whole crate, which weakens "the identity is the
crate" as an argument against splitting it.

Producer-facing members of that list: `rule_contract.rs` (`Program`, `Fact`, `Relation`, `SCHEMA` —
the wire contract a producer builds), `datalog.rs` (`PreparedSource` and every `MAX_*` budget a
producer must respect), `datalog_store.rs` (`DIRECT_LIMIT`, re-exported at `lib.rs:19`),
`derivation.rs` and `ranked.rs` (the certificate structs a producer emits). Editing any of these —
a doc comment included — moves the checker identity. That is exactly the coupling F15 names.

Consumer: one. `crates/verify/src/binary_composition.rs:303` sets `checker: implementation_identity()`
in `VerificationRecord`. `ergodis-private` never calls it.

Core F13 **VERIFIED**: neither `DerivationCertificate` nor `RankedCertificate` has a checker field —
a search for `checker` in `derivation.rs` and `ranked.rs` finds only prose. The checker identity is
recorded by the binary-composition record alone, so no Datalog certificate carries it.

## 8. O / core F8, private F14 — measurement instrumentation in the public API

**VERIFIED.** Core surface: `crates/rules/src/demand.rs:652-686` `pub struct Evaluation` with
public `rounds`, `derived`, `probes`, `lookups`, `candidates`; the instrumented entry point
`Demand::evaluate_counted_into` and the per-index split `Demand::index_lookups`
(`demand.rs:1724-1725`); the calibration constant `DIRECT_STATIC_PROBES` (`demand.rs:162`); and
`Demand::workspace_bytes` (`demand.rs:1606`). The `lookups` docstring
(`demand.rs:659-683`) says outright that it is "an instrument for the addressing policy's cost
model rather than a resident work counter" and is zero on the uninstrumented path.

Private surface: `src/rel_frontend/lower.rs:547-580` `pub struct Lowering`, whose own docstring
calls it "A witness for the measurement driver and a summary for callers; it carries no authority
to execute anything" — a measurement type in the public frontend API.

Consumers, from a bounded `rg -l` over core `crates/` and private `src/`, `examples/`, `tasks/`,
`tests/`: `crates/rules/tests/demand_sparse.rs` and `examples/closure_ballpark.rs`. Nothing else
calls `evaluate_counted_into` or `index_lookups`. Confirms the report.

Foreign-hygiene note: `src/rel_frontend/lower.rs:583` ("until C1193") and `:598` ("since
2026-09-17, by Tavis's decision on C1193's measurements") put a task ID, a date and an agent-facing
decision record in source, against the professional-comment standard.

## 9. P / private F4 — stage sequencing enforced by a doc comment

**VERIFIED, and slightly worse than the report states.** `lower` reads `w.definitions` and
`w.module_nodes` (`src/rel_frontend/lower.rs:1201-1202`, passed on to `build::build` at `:1220`,
which iterates them at `build.rs:496-499`). The only writer is admission:
`src/rel_frontend/admit.rs:335-336` clears both and `:400, :404` push into them. The rule is stated
only in prose — `src/rel_frontend/mod.rs:530-532`, "It must be given the same source bytes and an
admission that succeeded on them".

The addition: `scan_variant` (`mod.rs:603-607`) clears `tokens`, `nodes`, `frames` and `modules`
but leaves `definitions`, `module_nodes`, `symbols` and `owners` untouched. So a second `parse` of
a different source followed directly by `lower` does not merely skip a check — it hands `build`
node **ids from the previous source** indexing the new node pool. That is a silent wrong-answer
path, not just an unenforced precondition.

Smallest enforcing repair and its cost: a `u32` generation counter on `Workspace`, incremented in
`scan_variant`, recorded by `admit` on success, compared by `lower`, which refuses on mismatch with
a `REL05xx` code. Three constant-time field operations, one per stage call, none inside a token,
node or literal loop, and no allocation — so the scan/parse/admit/lower allocation-free and
instruction-count contracts are unaffected beyond a handful of instructions per call. The cheaper
alternative (clearing `definitions` and `module_nodes` in `scan_variant`) is also allocation-free
but turns the hazard into an empty lowering rather than a refusal, so it is worse for diagnostics
and the same work; prefer the counter.

## 10. Q / private F11, core F10 — `Literal.reserved` is double-booked and its docstring is wrong

**VERIFIED; the docstring is factually false at HEAD.** `src/rel_frontend/lower.rs:227-232`
documents `reserved: [u32; 2]` as "Scratch, and explicit padding … nothing reads it once
`distribute` has expanded the witness rule, and it is not part of the canonical form."

`canonical_literal` (`lower.rs:1364-1385`) reads it: at `:1374-1376`, for `SIGN_AGGREGATE`, it
writes `sink.word(l.reserved[0])` into the canonical bytes, with its own comment saying the backend
needs that argument position. The driver reads it too: `src/rel_stratified.rs:1341`
`let column = record.reserved[0] as u8;`. So `reserved[0]` is simultaneously the `forall` guard
range during staging (`lower/build.rs:1281, 1443`) and the aggregate's aggregated column
afterwards, and it *is* part of the canonical form.

**Would a named field move the canonical bytes?** No. `canonical_literal` writes the same `u32` at
the same position in the sink sequence whatever the field is called, so `CANONICAL_SCHEMA`
(`lower.rs:1279`, `b"ergodis.rel_frontend.rir.v1"`) and the parity digest are untouched, provided
the split preserves the emission order and the struct layout. The layout constraint is explicit:
`lower.rs:235` `const _: () = assert!(size_of::<Literal>() == 32 && align_of::<Literal>() == 4);`.
Two named `u32` fields in place of `[u32; 2]` keep that stride, so the repair is a rename plus a
corrected docstring with no format consequence. Its real content is separating the staging use from
the persistent use, which is the part that needs a second field rather than a second name.

## 11. R / core F14 — is `ergodis-rules` built for wasm32 today?

**REFUTED as the core report states it. `ergodis-rules` is built for `wasm32-unknown-unknown`, and
the `alloc_zeroed` branch is reachable on that build.**

Evidence, from target gates and documented commands only — no build was run:

- `crates/rules/Cargo.toml` declares `crate-type = ["rlib", "cdylib"]` and gates `libc` behind
  `[target.'cfg(unix)'.dependencies]`, with a comment stating that "WebAssembly and any non-Unix
  target build the `alloc_zeroed` shape instead".
- `crates/rules/src/pages.rs:202` is `#[cfg(all(unix, not(target_family = "wasm")))]` and
  `pages.rs:247` is its negation, which is the `alloc_zeroed` implementation (`:249, :258`). The
  header `pages.rs:20-23` says the WebAssembly build "is correct and simply does not have the
  lazy-commit property".
- `rust-toolchain.toml:13` installs `targets = ["wasm32-unknown-unknown"]`.
- `docs/rule-contract.md:287-288` is the replay procedure and builds it explicitly:
  `RUSTFLAGS='-C linker=wasm-ld' cargo build -p ergodis-rules --release --target
  wasm32-unknown-unknown`, followed by `node crates/rules/tests/wasm_abi.mjs
  "$rule_target/wasm32-unknown-unknown/release/ergodis_rules.wasm" …`.
- `crates/rules/tests/wasm_abi.mjs:10-11` loads that artifact through
  `wasm/www/module-host.js`'s `ModuleProvider` under a manifest naming
  `target:'wasm32-unknown-unknown', artifact:'ergodis_rules.wasm'`, and drives the C ABI by
  selector. It is checksummed in `SHA256SUMS`.

Resolving the tension the report noticed: the crate genuinely is a "native/WASM C ABI module", and
its own wasm ABI test exists. What is true is that the wasm32 build is **not automatic** — the
`wasm-build`/`wasm-test` commands in `flake.nix:53-59` build the separate `wasm/` crate (which
depends on `ergodis` and `ergodis-runtime`, not on `ergodis-rules`), and `.github/workflows/`
contains only `public-lint.yml`, which mentions neither wasm nor rules. So `ergodis-rules` for
wasm32 is a documented, manually replayed target rather than a gated one.

Disposition-relevant: F14's inferred consequence ("the workspace model assumes Unix lazy commit and
WASM would need a decision") is the wrong shape. The decision is already made and implemented; what
is missing is a gate that runs the documented wasm32 build and `wasm_abi.mjs`, so the
`alloc_zeroed` branch does not rot. Mark F14 PARTLY and re-aim it at coverage, not at architecture.

## 12. S / core F16 — the provider exposes `Prepared` only

**VERIFIED.** `crates/rules/src/provider.rs:9` imports `use crate::{Prepared, Workspace}` and
nothing else from the plan side; the plan slab is `plans: Vec<Option<Prepared>>` (`:34`) and the
only construction is `Prepared::new(source)` (`:71`). A search for `Demand` or `demand::` in
`provider.rs` returns nothing, so the C ABI (`ergodis_abi`, `ergodis_create`,
`ergodis_module_v1`, `ergodis_alloc` at `:177, :183, :274, :280`) reaches only the grounded route.
The Datalog path has no ABI, as F16 says.

## 18. core F11 second half — the `Prepared` name clash, sized

**VERIFIED.** Two unrelated types: `crates/rules/src/lib.rs:52` `pub struct Prepared` (the grounded
plan: `source`, `graph: Grounded`, `kernel`, `users`) and `crates/verify/src/datalog.rs:363`
`pub struct PreparedSource<'a>` with its family `PreparedRelation`, `PreparedAtom`, `PreparedRule`
(`:324, :333, :347`) — the Datalog prepared-source form. Neither is the other's prepared anything.

External uses of `ergodis_rules::Prepared`, to size a rename: fourteen files in core name it
(`crates/runtime/src/recursive.rs` and two runtime tests; `crates/rules/examples/` twice; the rest
`crates/rules/tests/`), plus `examples/closure_ballpark.rs` in `ergodis-private`. The private
`Prepared*` hits in `src/rel_stratified.rs`, `src/semantic_plan/` and `tasks/tools/` are the
`verify::datalog::Prepared*` family or unrelated local names, not `ergodis_rules::Prepared`.

So a rename is one public type plus fifteen naming sites, almost all in tests and examples — hours,
and mechanical. It is a public-API break for anything outside these two repositories.

## 14. private F13 — the reference evaluator's header understates what it implements

**VERIFIED on both halves.** The stated contract at `tests/rel_reference/mod.rs:47-48` says
"Comparison and aggregation are represented far enough to be range-restricted and stratified and
are then rejected, exactly as the backend rejects them." The module does more than that at HEAD: it
evaluates comparisons (`mod.rs:886-900`, mapping `Kind::Less` to `CMP_LT` and applying the operator)
and it computes aggregates (`mod.rs:1032` `aggregate_operator`, `:1049` `aggregate`, `:1842`
`aggregate_relation`, with the count accumulation at `:1877` and a refusal predicate at `:1907`).
The header is stale relative to the backend too: the backend no longer rejects comparison and
aggregation — `Lowering` counts them (`src/rel_frontend/lower.rs:573, 576, 578`) and the stratified
driver materializes the filter and aggregate relations.

The blind spot is stated only obliquely. `mod.rs:5-10` says the evaluator reads the parsed and
admitted node pool "and nothing else", and that "the only things it shares with the lowering are
the scanner, the parser and semantic admission, so an agreement between the two is evidence about
the lowering rather than about one implementation compared with itself." That is the sharing stated
as a strength. Nowhere in `tests/rel_reference/mod.rs`, `tests/rel_reference/generate.rs` or
`tests/rel_reference_eval.rs` does anything say the consequence: a defect in the shared scanner,
parser or admission is invisible to this oracle, because both sides inherit it. The repair is a
paragraph in the header, minutes, and it should also correct the comparison/aggregation sentence.

## 15. core unexplained 3 — `DerivationCertificate::fact_count` docstring is wrong for the prepared route

**VERIFIED.** `crates/verify/src/derivation.rs:62` documents the field as "`Program::facts.len()`
of the bound source". On the prepared route there is no `Program`: `datalog::admit_prepared` sets
`fact_count: facts.len()` (`datalog.rs:628`), the deduplicated present facts. The correct wording
already exists one file away — `Admitted::fact_count` (`datalog.rs:157-160`) states both cases:
"On the wire path that is `Program::facts.len()`, duplicates and absent facts included; on the
prepared path the source's facts are exactly the present deduplicated ones, so it is
`facts.len()`." The check that binds them is `derivation.rs:255`
(`certificate.fact_count != admitted.fact_count`).

Repair: replace the certificate field's one-line docstring with the `Admitted::fact_count` wording
or a cross-reference to it. Minutes. Note it moves `implementation_identity()` (item 7), so it
should ride with the other `derivation.rs` docstring repairs in one commit rather than alone.

## 16. private unexplained 5 — no result records which `BodyPolicy` produced it

**PARTLY REFUTED.** The in-memory results do omit it, but one of the two tools already records it.

Omitted: `Lowering` (`src/rel_frontend/lower.rs:547-580`) has no policy field; `Stratified`
(`src/rel_stratified.rs:351-372`: `readout`, `layers`, `complements`, `filters`, `aggregates`,
`dictionary`, `dictionary_base`, `reports`, `closure`, `filter_facts`, `aggregate_facts`) has none;
`LayerReport` (`:325-334`) has none.

Recorded: the operator tool does. `tasks/tools/src/rel_lower.rs:153-156` writes
`"max_rows":…,"body_policy":"…"` into its JSON, from the CLI flag at `:69, :131`.

Not recorded: the A/B receipt. `tasks/tools/src/rel_frontend_bench.rs:793-812` emits the
`ergodis.rel_frontend.bench.v1` header with cohort, variant, stage, definitions, symbol limit,
repeat, source bytes and hash, token and node counts, byte counts, fingerprint, page and fault
counts, time and peak RSS — and **no** `body_policy`, although the tool carries the flag
(`:122-128`). The lowering sub-object (`:646-650`) reports `distributed` and `binarized` counts,
from which the policy can usually be inferred but is not stated.

Disposition-relevant: the smallest repair is one field in the bench receipt header, matching the
`rel_lower` spelling — minutes, and it changes a receipt schema (`ergodis.rel_frontend.bench.v1`),
so it wants a version bump or an additive-field rule. That is the part to decide. Adding the
policy to `Lowering` is a separate, larger question because `Lowering` feeds the canonical
fingerprint's neighbourhood and is `Copy`-sized.

Foreign-hygiene note: `rel_frontend_bench.rs:124-126` records a date and a replay instruction in a
CLI doc comment — process narrative in source.

## 17. private F15 — the parity record omits three lowering counters

**VERIFIED.** `tests/rel_frontend_portability.rs:132-155` writes the lowering record as
`relations, inputs, derived, auxiliaries, rules, literals, terms, facts, values, strata, domain,
distributed, binarized, negated, complements, witnesses`, then the two halves of `fingerprint`, then
the full canonical bytes. `Lowering`'s `comparisons`, `aggregates` and `aggregated`
(`src/rel_frontend/lower.rs:573, 576, 578`) are not among them.

**Would adding them move the parity digest? Yes.** The digest is
`hashlib.sha256(native_bytes)` over the whole concatenated record
(`analysis/rel-frontend/portability.py:144-146`), so three more `word(out, …)` calls per lowered
case change `canonical_sha256` and `canonical_bytes`.

Is that acceptable under the record's own versioning? The report carries
`'schema':'ergodis.rel_frontend_portability.v1'` (`portability.py:143`), and the record format is
positional with no per-field tag, so any addition is a breaking format change under that schema
name. The clean move is to bump the schema to `.v2` in the same change, which makes the digest
shift expected rather than a regression. Minutes of code, one decision about the schema name.

## 24. private map arrow 2 — the whole-`ergodis` dependency, and the parity constraint's reach

**VERIFIED.** `Cargo.toml:23` is
`ergodis = { path = "../ergodis", features = ["control-plane", "parallel"] }`, alongside separate
entries for `ergodis-verify` (`:24`) and `ergodis-rules` (`:30`). Nothing under `src/rel_*` uses
the root crate: the only cross-crate imports are `src/rel_lowering.rs:18`
(`ergodis_verify::rule_contract`), `src/rel_stratified.rs:72` (`ergodis_rules::demand`) and
`:73-74` (`ergodis_verify::datalog`, `rule_contract::Error`). A search for `ergodis::` under
`src/rel_frontend`, `src/rel_lowering.rs` and `src/rel_stratified.rs` returns nothing.

**The parity-harness constraint's exact reach.** `analysis/rel-frontend/portability.py:113-118`
compiles exactly one file with bare `rustc` — `tests/rel_frontend_portability.rs` — twice, native
and `wasm32-unknown-unknown`, as `--crate-type=cdylib`, with no Cargo and no external crate. That
file `#[path]`-includes `src/rel_frontend/mod.rs` (`portability.rs:5-8`), which transitively pulls
in `lexer.rs`, `parser.rs`, `diagnostic.rs`, `admit.rs`, `lower.rs`, `lower/build.rs` and
`lower/passes.rs`. The longer name list at `portability.py:137-140` is the provenance hash set (it
also names `tests/rel_frontend.rs` and the two analysis scripts) and is not the compile set.

**Would a separate `ergodis-rel` crate satisfy it? Yes, and the split line already exists.**
Everything inside the parity boundary is `src/rel_frontend/**` and it is already std-only —
`mod.rs` re-exports only its own submodules (`:14-17`) and imports nothing external. Everything
that depends on core is `src/rel_lowering.rs` and `src/rel_stratified.rs`. So a two-crate split —
`ergodis-rel` holding `rel_frontend` including the lowering to the relational IR, and a second
crate holding the projection into the rule contract and the stratified driver — leaves the parity
harness compiling the first crate's source exactly as it does now. The harness would need its
`#[path]` retargeted and nothing more.

## 19. Mystery 2 and 3 — three route bounds at one value; two direct limits that differ

**VERIFIED on the values; PARTLY REFUTED on "unexplained".** All three private route bounds are
`1 << 22`, and two of the three docstrings do explain the sharing:

- `src/rel_frontend/lower.rs:1172` `pub const MAX_COMPLEMENT: u64 = 1 << 22` — "materializes the
  whole product for every negated literal whatever its closure … Raising it is a decision about how
  much the complement route may cost; the recorded alternative is the `Negative` atom kind in the
  core `Rule` that ADR 0004 names." No derivation of 2^22 itself.
- `src/rel_frontend/lower.rs:1182` `pub const MAX_FILTER: u64 = 1 << 22` — "The same declared route
  bound as [`MAX_COMPLEMENT`] and for the same reason". The sharing is deliberate and stated.
- `src/rel_stratified.rs:112` `pub const MAX_LAYER_TUPLES: u64 = 1 << 22` — its docstring
  (`:104-111`) explains why it equals the others: "A single negation over whole-dictionary columns
  therefore reaches it at essentially the same dictionary size `MAX_COMPLEMENT` does … the bound is
  on the layer, because the layer is what is held in memory at once."

So the mystery is narrower than recorded: not "why do three bounds share a value" — that is
answered — but "why 2^22", which none of the three derives.

The two direct limits **are** explained and are not the same quantity:

- `crates/rules/src/demand.rs:85-90` `MAX_DIRECT_KEYS: u64 = 1 << 24` — "Largest direct-addressed
  join **index** the policy will choose, in keys. One `u32` per key, so 2^24 keys is 64 MiB of
  bucket heads for one index… a **policy ceiling, not a refusal**."
- `crates/verify/src/datalog_store.rs:33-37` `DIRECT_LIMIT: u64 = 1 << 26` — "Largest
  direct-addressed **array a checker allocates**, in `u32` entries. At 2^26 entries a membership
  array or a CSR offset array is 256 MiB for one relation; above it the sorted fallback costs
  twelve bytes per stored tuple instead of four bytes per universe entry."

They differ by owner (evaluator policy vs checker allocation) and by the memory figure each
docstring quotes (64 MiB vs 256 MiB). Mark mystery 3 **settled by reading**: the two are not two
values for one quantity. The residue is that the project tolerates a checker allocating four times
what the evaluator's index policy will, which is a stated trade, not an unexplained one.

## 20. private unexplained 3 — the complement construction's memory bound is implicit

**VERIFIED.** `src/rel_stratified.rs:910` `fn complement_over(domains, closure) -> (Vec<u32>, u32)`
allocates `let mut present = vec![false; universe];` at `:924`, one byte per product entry, in
addition to the output tuple vector at `:913`. So `MAX_COMPLEMENT` at `1 << 22` is also a
four-mebibyte-per-complement allocation bound, which its docstring (`lower.rs:1160-1172`) never
says — it is written purely as a tuple count.

The second allocation is real: `complement_over` is called from the construction path
(`rel_stratified.rs:1498`) and again from `verify_records` (`:1016`), which rebuilds each
complement from the preceding layer's certified closure. Verification therefore re-pays the
membership vector per record.

Repair options, cheapest first: state the memory consequence in the `MAX_COMPLEMENT` docstring
(minutes); or give `complement_over` a caller-supplied scratch buffer so the two paths share one
allocation (hours, and it changes a signature used in two places).

## 21. private unexplained 4 — a layer declares relations no rule of the layer reads

**VERIFIED, and the stated reason is the right one.** `src/rel_stratified.rs:1236-1238`:
`let mut needed: Vec<bool> = derived.clone();` then
`for (id, _) in rir.relations().iter().enumerate() { needed[id] |= layer_of[id] == layer; }`.
The comment at `:1231-1235` gives the reason: "A relation whose own layer is this one is declared
here even when no rule of the layer reads it, so that layer zero of a fact-only source is the same
program milestone (a)'s single projection builds and a source with no rule at all still declares a
relation."

**The test that pins it** is `a_layer_reports_the_tuple_payload_it_hands_the_core`
(`tests/rel_lowering.rs:1198-1232`). Its source declares `dom` and `e` as fact sets and one rule
with a negation, so layer zero has no rule; the test asserts `result.reports[0].facts == 6` and
`result.reports[0].layer_values == 8`. Dropping the `|=` line makes layer zero's `needed` all
false, so layer zero declares nothing and both assertions fail. A source with no rule at all would
additionally produce a program with no relation, which `datalog::admit` refuses
(`crates/verify/src/datalog.rs:192`, `program.relations.is_empty()`).

Disposition-relevant for C1205's layer records: the declared-relation set is deliberately a
superset of the read set, so any layer record that claims "the relations this layer reads" would be
wrong. Name the field for what it is (declared inputs and derived relations of the layer).

## 22. core unexplained 2 — `MAX_WORKSPACE_BYTES` has no derivation

**VERIFIED.** `crates/rules/src/demand.rs:183` `pub const MAX_WORKSPACE_BYTES: u64 = 1 << 34`. The
docstring (`:178-182`) explains the *semantics* well — reserved address space is free until first
touch, and exceeding the bound is a refusal (`Demand::workspace` returns `Error::Budget`) rather
than a fallback — but gives no reason for sixteen gibibytes specifically, and quotes no machine or
working-set figure. Contrast the neighbouring constants, which do quote one:
`MAX_DIRECT_KEYS` says "2^24 keys is 64 MiB of bucket heads" (`:86`) and `MAX_DIRECT_UNIVERSE`
says "2^30 is 128 MiB for one relation" (`:93`). Repair is one sentence of the same kind; minutes,
once someone states what 2^34 was chosen against.

## 23. private unexplained 2 — two unrelated 64s

**VERIFIED.** `src/rel_frontend/mod.rs:399, 416`: `pub disjuncts: u32` defaulting to `64`, whose
overrun is `Budget::Disjuncts`. `src/rel_frontend/lower/passes.rs:595-599`: `chain`'s scratch order
buffer is `let mut order = [0u32; 64];`, whose overrun is `Budget::BodyAtoms`. The two are
unrelated quantities that coincide in value — a disjunct count and a body-atom stack width — and
neither docstring refers to the other. Nothing depends on their agreement, so this is a
readability observation: give the `chain` buffer a named constant so a future reader does not
infer a relationship. Minutes.

## 25. Seam-table items not raised as findings

**`Readout::decode` maps an unknown id to `"?"` — VERIFIED.**
`src/rel_lowering.rs:66-75`: `self.values.get(value as usize).map_or("?", |entry|
entry.text.as_str())`. A dictionary id outside the readout's value table decodes to a printable
placeholder rather than failing, so a decoded tuple can silently misreport. `decode` returns
`Vec<&str>` and has no failure channel, which is why. Repair shape: return
`Option<Vec<&str>>` or `Result`, or have it carry the id in the placeholder so a wrong readout is
visible. Hours, and it changes a public signature.

**`MAX_BODY` split (private section 5, question 4) — settled: the checkers do handle four-atom
bodies.** `crates/verify/src/datalog.rs:80` `MAX_BODY: usize = 4`, enforced at both admission doors
(`:222`, `:462`). `rule_contract::ground` refuses a body of more than two atoms
(`rule_contract.rs:530`, `rule.body.len() > 2`) "because a product rule is a binary product",
which the parser's own comment states (`rule_contract.rs:840-845`) while the textual parser admits
up to `datalog::MAX_BODY`. Both checkers go through `datalog::admit` (`derivation.rs:212`,
`ranked.rs:232`), never through `ground`, and `derivation::premise_stride` (`:46-52`) is written
for a body of any length. So a four-atom wire program admitted by `datalog::admit` and refused by
`ground` is checkable by `check` and `check_admitted`; the asymmetry is confined to the grounded
route.

**The per-column complement-domain exactness argument's only home — VERIFIED.** The argument is in
the `rel_stratified` module header, `src/rel_stratified.rs:28-53`: the definition of each column's
domain, the exactness proof ("a derivation binds `tᵢ`'s variable through some positive literal of
its own rule … no tuple outside `∏ᵢ Dᵢ` is ever asked about"), the empty-domain case and the
same-layer fallback to the whole dictionary. ADR 0004 mentions per-column domains once, as a route
name only (`docs/adr/0004-rel-lowering-ir.md:29`), with no argument. Two tests reference the
consequence (`tests/rel_lowering.rs:757, 983`) without restating the argument. So the correctness
argument for the complement construction exists in exactly one place, and that place is a source
comment on a private module — not in the ADR, not in a note, not in a paper.

**C1196-relevant: the certificate `Vec<u32>` fields are indexed directly, and `premise_stride`
floors at two — VERIFIED.** `DerivationCertificate` carries `rules: Vec<u32>` (`derivation.rs:65`),
`premises: Vec<u32>` (`:70`) and `tuples: Vec<u32>` (`:72`); `RankedCertificate` carries
`tuples: Vec<u32>` (`ranked.rs:41`) and `ranks: Vec<u32>` (`:43`). The checkers index these flat
vectors arithmetically — `derivation.rs:275, 299, 304` compute `fact_count`-relative references
directly. `premise_stride` (`derivation.rs:46-52`) returns `2` for a body shorter than two atoms
and the body length otherwise, so a one-atom body still costs two premise slots, the second being
the `0` sentinel documented at `:54-56`. Any C1196 change to the certificate's row layout has to
move the stride rule, the sentinel meaning and every direct index together.

## Corrections to the C1204 reports

1. **Core F2 (synthesis C): the ADR does not make the independence claim.** Private ADR 0004 has no
   occurrence of "checker", "independent", "second" or "cross-check". The restatement repair's site
   list is the eight source docstrings in item 1, not the ADRs. (PARTLY)
2. **Core F7 (synthesis E): the checker crate is not test-free on the Datalog side.**
   `crates/verify/src/datalog.rs:635` and `datalog_store.rs:270, 436` carry inline `#[cfg(test)]`
   modules. The gap is the two checkers specifically. (PARTLY)
3. **Core F15 (synthesis N): `implementation_identity()` does not cover the whole crate.**
   `support.rs` is a module of `ergodis-verify` and is not hashed, which weakens the
   "identity is the crate" argument against splitting the contract types out. (addition)
4. **Core F14 (synthesis R): `ergodis-rules` is built for wasm32 today.** `rust-toolchain.toml:13`
   installs the target, `docs/rule-contract.md:287-288` builds the crate for
   `wasm32-unknown-unknown` and drives its C ABI through `crates/rules/tests/wasm_abi.mjs`. The
   real gap is that the build is manual and ungated, not that WASM is an open architecture
   question. (REFUTED as framed)
5. **Private unexplained 5 (BodyPolicy unrecorded): the operator tool already records it.**
   `tasks/tools/src/rel_lower.rs:153-156` writes `"body_policy"`. The omission is in the A/B bench
   receipt (`tasks/tools/src/rel_frontend_bench.rs:793-812`) and in the three in-memory result
   types. (PARTLY)
6. **Mystery 2 (three bounds at one value): the sharing is explained; only the magnitude is not.**
   `MAX_FILTER`'s docstring says it is "the same declared route bound as `MAX_COMPLEMENT` and for
   the same reason", and `MAX_LAYER_TUPLES`'s docstring derives its equality with `MAX_COMPLEMENT`.
   Restate the mystery as "why 2^22". (PARTLY)
7. **Mystery 3 (two direct limits): settled, not a mystery.** `MAX_DIRECT_KEYS` (2^24) bounds an
   evaluator join index's key array at a stated 64 MiB; `DIRECT_LIMIT` (2^26) bounds a checker's
   direct array at a stated 256 MiB. Different owners, different quantities, both derived in their
   docstrings. (REFUTED as a mystery)
8. **Private F4 (synthesis P) is understated.** `scan_variant` does not clear `definitions` or
   `module_nodes`, so a re-`parse` without a re-`admit` lowers the new node pool against the old
   item list — a silent wrong answer, not merely an unenforced precondition. (worse than reported)
9. **Private F11 / core F10 (`Literal.reserved`): the docstring is false, not merely ambiguous.**
   It says the field "is not part of the canonical form"; `canonical_literal`
   (`src/rel_frontend/lower.rs:1374-1376`) writes `reserved[0]` into the canonical bytes for
   aggregate literals. (VERIFIED, sharper)

## Cheap questions settled

1. **The C1193 n-ary-versus-binarized measurements are sound.** Every headline cohort
   (`triangle`, `path3`, `path4`, `closure`, `samegen`) runs through `examples/closure_ballpark.rs`,
   which hand-builds contract programs and never touches the Rel lowering, so the missing
   `order_body` cannot reach them; the Soufflé programs are hand-written too. Only the `datalog`
   cohort goes through the lowering, and there the residual effect is bounded by a tiebreak in
   core's greedy link ordering. No re-measurement is needed.
2. **`ergodis-rules` is built for `wasm32-unknown-unknown`**, by the documented command, and the
   `alloc_zeroed` branch of `pages.rs` is reachable on that build. No build probe was run; the
   verdict rests on the target gates, the toolchain file and the documented replay.
3. **A separate `ergodis-rel` crate would satisfy the parity-harness constraint.** The harness
   compiles one file, `tests/rel_frontend_portability.rs`, with bare `rustc` for native and wasm32;
   that file `#[path]`-includes `src/rel_frontend/mod.rs` and its submodules, all std-only. The
   core-dependent code is already confined to `src/rel_lowering.rs` and `src/rel_stratified.rs`, so
   the split line the crate boundary would follow already exists.
4. **A four-atom body is checkable.** Both checkers admit through `datalog::admit` (`MAX_BODY` 4);
   only `rule_contract::ground` caps the body at two, and no checker path goes through it.
5. **A named field for `Literal.reserved` does not move the canonical bytes**, the
   `CANONICAL_SCHEMA` or the parity digest, as long as the emission order and the asserted 32-byte
   `Literal` stride are preserved.
6. **Adding the three lowering counters to the parity record does move its digest**, because the
   record is positional and the digest is a SHA-256 of the whole byte stream; the clean form is to
   bump `ergodis.rel_frontend_portability.v1` in the same change.

## Foreign-hygiene notes (not part of the triage)

Source comments carrying task IDs, dates or decision narrative, against the professional-comment
standard: `ergodis-private` `tests/rel_lowering.rs:1256-1258` ("since C1192"),
`src/rel_frontend/lower.rs:583` ("until C1193") and `:598` ("since 2026-09-17, by Tavis's decision
on C1193's measurements"), `tasks/tools/src/rel_frontend_bench.rs:124-126` (a date and a replay
instruction). Raising these rather than acting on them; this pass was read-only.
