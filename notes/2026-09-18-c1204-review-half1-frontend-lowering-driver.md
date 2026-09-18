# C1204 — architecture review, first half: Rel frontend, lowering, stratified driver, reference evaluator, private tooling

**Lane**: `ergodis`
**Date**: 2026-09-18
**Scope**: read-only architecture review of scope items 1, 2, 3, 7 and 8 of the C1204 card
(`notes/2026-09-18-c1204-datalog-rel-architecture-review.md`). The seam **into** core
(`ergodis-rules`, `ergodis-verify`) is reviewed from the private side only; core internals belong
to the sibling reviewer.
**Code reviewed**: `~/src/ergodis-private` at `1500dc2`; the public API of
`~/src/ergodis/crates/{rules,verify}` only as far as the seam requires.

## 1. Architecture map

### 1.1 Modules and their roles

The whole subsystem is three modules of the single `ergodis-private` library crate
(`src/lib.rs:171`–`173`); there is no crate boundary around it.

| Module | Role |
|---|---|
| `src/rel_frontend/mod.rs` | The frontend's whole public surface: `Workspace` (every pool), `Limits`, `Token`/`Node`/`Kind`/`NodeKind`, `Failure`/`SemanticFailure`, `ErrorCode` with `id()` (`REL0001`–`REL0505`), the stage entry points `parse`, `parse_recovering`, `admit`, `lower`, `lower_with`, `rir()`, and the measurement aids `touch`, `retained_bytes`, `fingerprint`, `scan_only_variant`, `parse_variant::<BYTE_SCAN>`. |
| `src/rel_frontend/lexer.rs` | Byte and scalar scanners behind one `const BYTE_SCAN` parameter; both must emit identical tokens. |
| `src/rel_frontend/parser.rs` | Pratt-style parser over the token pool into the flat `Node` pool; `Recovery` for the bounded multi-error mode. |
| `src/rel_frontend/admit.rs` | Semantic admission: name binding and arity only (`REL04xx`). Fills `Workspace::definitions` and `module_nodes`, which lowering later reads. |
| `src/rel_frontend/diagnostic.rs` | `enrich`, `enrich_lowering`, `Diagnostic`/`Excerpt`/`Label`: rendering only, after a failure. |
| `src/rel_frontend/corpus.rs` | Deterministic measurement cohorts (`Ascii`, `Datalog`, `Stratified`, `Columns`, `Columns3`, aggregation, …). A `pub mod` of the frontend. |
| `src/rel_frontend/lower.rs` | The relational IR (RIR): the pooled records, the sign/kind/type constants, `Rir` with its pools and accessors, `BodyPolicy`, `Budget`, `LowerFailure`, the `Lowering` summary, the canonical byte form (`Sink`, `Fnv`, `canonical`, `fingerprint`, `CANONICAL_SCHEMA`), the restated core bounds, and the route bounds `MAX_COMPLEMENT`/`MAX_FILTER`. Pass driver `run()`. |
| `src/rel_frontend/lower/build.rs` | Node pool → staged literals: module declaration and flattening, `forall` desugaring into witness relations, disjunction distribution, constant interning and column typing. |
| `src/rel_frontend/lower/passes.rs` | `project`, `range_restrict`, `bind`, `stratify` (Tarjan over signed edges), `plan_bodies`/`chain`/`order_body`, `close` (name mangling, budget checks, `order_dictionary`). |
| `src/rel_lowering.rs` | Backend v1: `readout_of` and the `Readout`/`RelationReadout`/`ValueReadout` decode map, and `project()` into `ergodis_verify::rule_contract::Program` (the serialized wire form), positive fragment only. |
| `src/rel_stratified.rs` | The driver: `evaluate()` layer by layer through the prepared (non-serialized) core path, `verify_records()`, the result type `Stratified` with `LayerReport`, and the three construction records `ComplementRecord`, `FilterRecord`, `AggregateRecord` with `ColumnDomain`/`DomainSource`. Owns `MAX_LAYER_TUPLES`, the backend-side `Dictionary`, `complement_over`, `filter_over`/`satisfies`, `aggregate_over`, `layers_of`, `column_domains`. |

Test and tool surface: `tests/rel_frontend.rs` (scan, parse, admit), `tests/rel_lowering.rs`
(lowering, driver, budgets, tamper tests, oracle agreement), `tests/rel_reference/mod.rs` (the
naive set-based reference evaluator) and `tests/rel_reference/generate.rs` (its seeded corpora),
`tests/rel_reference_eval.rs` (the differential harness), `tests/rel_frontend_portability.rs` (the
native/WASM parity cdylib) driven by `analysis/rel-frontend/portability.py` and `portability.mjs`,
`tasks/tools/src/rel_lower.rs` (the operator tool), `tasks/tools/src/rel_frontend_bench.rs` (the
A/B receipt harness), `examples/closure_ballpark.rs` (a core-facing harness that builds contract
programs by hand and never touches the Rel path).

### 1.2 Dependency arrows

```text
                       ergodis-private (one crate, ~200 modules)
  ┌───────────────────────────────────────────────────────────────────────────┐
  │  rel_frontend/  (std only — no crate dependency at all)                   │
  │    lexer ─▶ parser ─▶ admit ─▶ lower/{build,passes} ─▶ Rir                │
  │    corpus (measurement)          diagnostic (rendering)                   │
  └───────────────┬───────────────────────────────┬───────────────────────────┘
                  │ &Rir + source bytes           │ &Rir + source bytes
                  ▼                               ▼
        src/rel_lowering.rs                 src/rel_stratified.rs
        project() ─▶ rule_contract::Program evaluate() ─▶ PreparedSource per layer
        readout_of() ─▶ Readout ────────────▶ (driver reuses readout_of)
                  │                               │
                  │ ergodis-verify                │ ergodis-verify::datalog (Prepared*, Slot)
                  │ ::rule_contract               │ ergodis-rules::demand::{Demand, Policy}
                  ▼                               ▼
        ~/src/ergodis/crates/verify         ~/src/ergodis/crates/{verify,rules}

  Cargo: ergodis-private ─▶ {ergodis (control-plane, parallel), ergodis-verify, ergodis-rules}
  bare rustc (parity):    tests/rel_frontend_portability.rs ──#[path]──▶ src/rel_frontend/mod.rs
```

Three arrows exist for incidental reasons rather than for a design reason.

1. **`src/rel_lowering.rs` and `src/rel_stratified.rs` are siblings of `rel_frontend` rather than
   submodules of it** because the parity replay compiles `src/rel_frontend/**` with bare `rustc`
   and no Cargo graph (`analysis/rel-frontend/portability.py:113`–`118` compiles
   `tests/rel_frontend_portability.rs`, which `#[path]`-includes `src/rel_frontend/mod.rs`), and
   those two modules need `ergodis-verify`/`ergodis-rules`. This is recorded in ADR 0004 and in
   `src/rel_lowering.rs:1`–`8`, so it is a known deviation, not a discovery. Its cost is that the
   subsystem has no boundary of its own: `Rir`'s accessors are `pub` to the whole private crate,
   and any of the other modules can reach them.
2. **`ergodis-private` depends on the whole `ergodis` crate with `control-plane` and `parallel`**
   (`Cargo.toml`), so every build of the Rel tool drags in the non-Datalog engine. Nothing under
   `src/rel_*` uses it; the dependency belongs to the rest of the crate.
3. **`rel_stratified` depends on `rel_lowering`** only for `readout_of`, `Readout`,
   `ValueReadout` and the one-line helper `outside()` (`src/rel_stratified.rs:86`). The driver
   never calls `rel_lowering::project`. The decode map and the wire backend are two unrelated
   concerns sharing one module.

### 1.3 One traced program

Source (the shape of `tests/rel_lowering.rs:779` and `:546`, combined), with a negation and an
aggregate:

```rel
def w = {(1, 10); (1, 5); (2, 30)}
def k = {1; 2}
def e = {(1, 2)}
def reach(x, y) = e(x, y)
def reach(x, y) = reach(x, z) and e(z, y)
def missed(x, y) = k(x) and k(y) and not reach(x, y)
def tot(a, s)   = k(a) and s = sum[v: w(a, v)]
```

| Step | Call | What crosses | Types named |
|---|---|---|---|
| 1 | `Workspace::parse(bytes)` → `lexer::scan::<true>` → `parser::parse` | source bytes → token and node pools | `Token`, `Kind`, `Node`, `NodeKind`, `Failure`, `ErrorCode` (`REL0001`–`REL0301`) |
| 2 | `Workspace::admit(bytes)` | node pool + source → symbol table, `definitions[]`, `module_nodes[]` | `Admission`, `Symbol`, `SemanticFailure` (`REL04xx`) |
| 3 | `Workspace::lower_with(bytes, BodyPolicy::Nary)` → `lower::run` | node pool + `definitions`/`module_nodes` + source → the `Rir` pools | `Rir`, `Relation`, `Rule`, `Literal`, `Term`, `Value`, `Fact`, `Lowering`, `LowerFailure`, `Budget` (`REL05xx`) |
| 3a | `build::build` | relations `w,k,e,reach,missed,tot` declared; facts interned into the value dictionary; `not reach(x,y)` staged as `SIGN_NEGATIVE`; `s = sum[v: w(a,v)]` staged as `SIGN_AGGREGATE` with `op = AGG_SUM` and the aggregated position in `Literal.reserved[0]` | `Form`, `Binding`, `Task`, `Module` |
| 3b | `passes::project`, `range_restrict`, `bind` | rule-local variable numbering; every head variable and every variable of a non-positive literal proved bound (`REL0501`); binding sites recorded per variable | `VarBinding`, `BindSite` |
| 3c | `passes::stratify` | signed dependency edges, Tarjan SCCs, `Relation.stratum`; a non-monotone edge inside a component is `REL0502` | `Edge`, `Component` |
| 3d | `passes::plan_bodies(policy)` | bodies longer than `policy.keep()` chained through auxiliaries; `Rule.order` filled for every rule | `RULE_SYNTHETIC`, `RULE_BINARIZED` |
| 3e | `passes::close` | names mangled to core identifiers, `RELATION_NEGATED`/`RELATION_AGGREGATED` set, relation/rule/domain/arity budgets checked, dictionary ordered by type (`type_ranges`), `Lowering.fingerprint` computed over the canonical form | `Lowering`, `Span`, `CANONICAL_SCHEMA` |
| 4 | `rel_stratified::evaluate(rir, source, externals, max_rows)` | `&Rir` + source + externals → `Stratified` | `Stratified`, `Error`, `Externals` |
| 4a | `rel_lowering::readout_of` | mangled name, flattened spelling, arity, kind, stratum, column types, decoded dictionary | `Readout`, `RelationReadout`, `ValueReadout` |
| 4b | `layers_of` | strata → layers: `w,k,e,reach` in layer 0; `missed` and `tot` in layer 1 | `Vec<u32>` indexed by relation id |
| 4c | layer 0 | declared relations = the layer's own plus everything its rules read; `reach` derived, `w,k,e` inputs seeded from `Rir::facts` and the externals | `TupleSource`, `PreparedRelation`, `PreparedAtom`, `PreparedRule`, `Slot`, `PreparedSource` |
| 4d | `Demand::from_prepared_bounded(.., max_rows, Policy::Auto)`, `workspace()`, `evaluate_into`, `certificate`, `verify`, `ranked_certificate`, `verify_ranked` | the layer's program and tuples → `Evaluation`, `DerivationCertificate`, `RankedCertificate`, `Relations` | core types; disagreement is `Error::CheckersDisagree(layer)` |
| 4e | closure hand-off | for each relation the layer derives, the **checker's** rows are deduplicated, compared tuple-wise against `demand.rows(..)`, and stored into `closure[id]` | `Vec<Vec<u32>>` |
| 4f | layer 1, before the program | aggregates first (`aggregate_over` on `closure[w]`, interning `sum` results into `Dictionary`, extending `readout.values`), then complements (`column_domains` → `complement_over` on `closure[reach]`), then filters | `AggregateRecord`, `ComplementRecord`, `FilterRecord`, `ColumnDomain`, `DomainSource` |
| 4g | layer 1 program | `not reach(x,y)` becomes a positive atom over the declared complement `nc0`; `s = sum[...]` becomes a positive atom over `ag0`; the mapping literal → declared relation lives only in the local `atom_over` vector | same prepared types |
| 5 | `rel_stratified::verify_records(&result)` | each record's column domains are recomputed from their provenance, and the construction is rebuilt and compared by SHA-256 | `Error::ComplementMismatch(index)` |
| 6 | caller | `Stratified::rows(relation)` + `Readout::decode(tuple)` → typed text tuples | `Readout` |

`rel_lowering::project` — the serialized `rule_contract::Program` route of ADR 0004 — is **not**
on this path. Its only caller in the tree is `tests/rel_lowering.rs:1277`.

## 2. Per-seam contract table

| Seam | Contract | Where written | What enforces it |
|---|---|---|---|
| source bytes → `parse` | Under `Limits::source_bytes`, valid UTF-8; tokens and nodes fit the declared pools; no allocation after `Workspace::new` | `mod.rs:421`–`459`, `Limits` doc comments | Types (`Limits`), `ErrorCode::{SourceLimit, InvalidUtf8, TokenCapacity, NodeCapacity, DepthCapacity}`, the allocation test `the_lowering_stage_does_not_allocate` (`tests/rel_lowering.rs:1652`) |
| `parse` → `admit` | Same source bytes; admission reads the current node pool and nothing else | `Workspace::admit` doc (`mod.rs:515`–`523`) | **Nothing.** Convention only |
| `admit` → `lower` | Same source bytes **and** an admission that succeeded on this parse; `definitions`/`module_nodes` describe the current node pool | `Workspace::lower` doc (`mod.rs:527`–`536`) | **Nothing.** `admit` is the only writer of those pools (`admit.rs:335`), and `parse` does not invalidate them — see finding 4 |
| lowering passes, internal | Each pass is an in-place traversal inside reserved capacity; pool exhaustion is `REL0503` with `Budget` and the numbers | `lower.rs:33`–`35`, `Budget::name()` | Types plus explicit capacity tests before each push; the no-allocation test |
| RIR → canonical form | "Every field the backend reads is written"; scratch is not; a layout change changes `CANONICAL_SCHEMA` and every fingerprint | `Rir::canonical` doc (`lower.rs:1282`–`1287`) | Tests `the_canonical_bytes_and_the_fingerprint_agree` (`:1758`) and the parity corpus, which compares the canonical **bytes** native vs WASM. Not enforced by types: `canonical_literal` writes `Literal.reserved[0]` for an aggregate although that field's own doc calls it scratch outside the canonical form |
| restated core bounds | `MAX_ARITY`, `MAX_VARIABLES`, `MAX_RELATIONS`, `MAX_RULES`, `MAX_BODY`, `MAX_DOMAIN` equal the core's | `lower.rs:1137`–`1156` | Test `the_declared_backend_bounds_match_the_core_contract` (`tests/rel_lowering.rs:1236`). `MAX_NAME` is **not** in that test and the core's counterpart is a bare `64` inside `rule_contract::identifier` |
| route bounds | `MAX_COMPLEMENT`, `MAX_FILTER` (`lower.rs`), `MAX_LAYER_TUPLES` (`rel_stratified.rs:112`): declared bounds of this backend route, checked on the projected total before anything is enumerated | The three constants' doc comments; the C1190 note for the rationale | Checks in `evaluate` that return `LowerFailure::budget(..)` with the numbers and a span; `verify_records` re-checks `MAX_COMPLEMENT`/`MAX_FILTER` before reserving |
| `Rir` → `rel_lowering::project` | Positive fragment only, body length 1..=`MAX_BODY`; anything else is `REL0504` with a span | `rel_lowering.rs:10`–`16` | Types + the explicit sign check; one test |
| `Rir` → `rel_stratified::evaluate` | The RIR is normalized (closed, stratified, planned); the caller supplies externals keyed by flattened source spelling, as dictionary ids | `evaluate` doc (`rel_stratified.rs:1141`–`1147`), `Externals` (`:388`) | **Partly nothing**: an external whose key matches no relation is silently skipped (`:1181`–`1187`); tuple width against arity is unchecked here and only partly checked downstream (core rejects a total length that is not a multiple of the arity, and a value ≥ domain) |
| layer → core (prepared) | `PreparedSource`: relation indices resolved, slots resolved, variables numbered by first occurrence in body order then head order, facts as flat slices of stride arity, values < domain | `ergodis_verify::datalog::PreparedRule` doc; `slots_of` (`rel_stratified.rs:456`–`466`) | The core's `admit_prepared` re-derives the numbering and refuses a mismatch (`Error::Source`); names are validated by `rule_contract::is_identifier` and duplicates refused |
| layer N → layer N+1 | The next layer reads the **checker-established** closure, not the evaluator's rows | `rel_stratified.rs:1788`–`1807` | A tuple-wise comparison of `verify`'s relations against `demand.rows`; disagreement is `Error::CheckersDisagree(layer)`. Inside one run this is real and strong; nothing binds it in the returned value (finding 1) |
| constructions → evidence | Complements, filters and aggregates are rebuildable from the certified closure they name, plus their recorded provenance | The module header (`rel_stratified.rs:14`–`45`) and the three record types | `verify_records`, which is **not** called by `evaluate`; the callers each remember to call it. The rebuild shares the construction functions (finding 2) |
| `Stratified` → caller | `rows(relation)` are certified tuples as dictionary ids; `readout.decode` turns them into typed text | `Stratified` doc, `Readout::decode` | Types; `decode` maps an unknown id to `"?"` rather than failing |
| both sides of the differential | The oracle shares the scanner, parser and admission with the lowering and nothing else | `tests/rel_reference/mod.rs:1`–`10`, `tests/rel_reference_eval.rs:12`–`14` | The oracle's `use` list is the whole of what it imports (`Kind`, `Node`, `NodeKind`, `NONE`); it redefines the operator discriminants rather than importing them |
| native vs WASM | Identical tokens, nodes, diagnostics, admission counts, lowering summary, canonical RIR bytes | `tests/rel_frontend_portability.rs:1`–`8` | `portability.py` builds both with bare `rustc` and asserts byte equality of the whole record, and records source SHA-256s in `portability-v1.json` |

## 3. Ranked findings

### F1 — an accepted multi-layer result carries no evidence: no certificate, no layer program, no source identity (S1, ~1 day)

`rel_stratified::evaluate` builds a `DerivationCertificate` and a `RankedCertificate` per layer,
checks both, and then drops them: `Stratified` (`src/rel_stratified.rs:349`–`377`) holds the
readout, the layer count, the three record vectors, counters, and `closure`. It holds no
certificate, no certificate digest, no `demand.source_id()` (the core exposes one —
`crates/rules/src/demand.rs:1547`), and no list of the relations each layer declared. The
`declared` field of every record (`ComplementRecord.declared`, `FilterRecord.declared`,
`AggregateRecord.declared`) is an index into a per-layer `names` vector that is dropped at the end
of the loop iteration, so no reader can resolve it. The mapping from each non-positive literal to
the synthetic relation that replaced it lives only in the local `atom_over` vector
(`:1326`), and is never recorded.

Consequence: what "an accepted result" means is *the run happened and nothing returned an error*.
`verify_records(&result)` afterwards rebuilds the three constructions against `result.closure`,
which nothing attests — no certificate binds those tuples to any program. There is therefore no
offline or second-party check of a stratified answer, and no way to show after the fact that the
layer-1 atom standing for `not reach(x, y)` actually read the complement the record describes.
`tasks/tools/src/rel_lower.rs` prints counters, and `rel_frontend_bench` prints a SHA-256 it
computes itself over `s.closure` (`tasks/tools/src/rel_frontend_bench.rs:700`–`708`) — a fourth
identity, computed in the tool, binding nothing.

Recommendation: extend `LayerReport` with the layer's `source_id`, the declared relation names,
arities and input flags, the derivation-certificate digest, and the literal→declared-relation
mapping; and record the seeded input digest per input relation (see F3). That makes
`verify_records` a check on a record set that stands on its own instead of on a vector that has to
be trusted. Sizing assumes the records are added, not that an encoder is designed (C1196's
business).

### F2 — the "independent rebuild" of complements, filters and aggregates re-runs the code that built them (S1, days)

`verify_records` (`src/rel_stratified.rs:976`) calls `complement_over`, `filter_over` (and through
it `satisfies`), `aggregate_over`, `product_of`, `digest_of` and `Dictionary` — the same functions
`evaluate` used to build the records, in the same module. The only genuinely second implementation
is `rebuild_domain` (`:1103`), which recomputes a column domain by name lookup, push, sort and dedup
where the builder used `union_of_sites`'s bitset (`:556`).

Consequence: the check detects a tampered or inconsistent *record* — which is exactly what
`a_tampered_complement_record_does_not_rebuild` (`tests/rel_lowering.rs:735`) asserts, by mutating
seven record fields — and cannot detect a defect in the construction itself. A wrong
`complement_over`, a wrong ordering convention in `filter_over`, or a wrong group key in
`aggregate_over` reproduces identically on both sides and verifies. Since the module header
(`:14`–`26`) presents `verify_records` as the independent re-check of the one step the core's
checkers cannot see, the trust boundary is weaker than it reads: for negation, comparison and
aggregation the evidence is one implementation plus the differential oracle, and the oracle runs
only in the test suite, never in the operator tool.

Three fields are recorded but never checked, which compounds it: `ComplementRecord.source` (the
complements loop uses `record.relation` only), `FilterRecord.literal` and `FilterRecord.operator`
against the literal it came from — a record claiming the wrong operator for a rule's comparison
rebuilds consistently and passes.

Recommendation: decide explicitly which of two the project wants and write it down. Either (a)
give the rebuild its own module with a deliberately different implementation — a `BTreeSet` route
like the reference evaluator's, which already exists in the test tree and could be promoted — and
have it resolve records against the recorded layer program rather than against the builder's
vectors; or (b) keep the shared implementation, correct the header to say the check is
self-consistency of the records plus an independent domain rebuild, and make the differential
oracle's agreement part of the shipped evidence. Option (a) is days; option (b) is hours and
buys less.

### F3 — externally supplied facts are unvalidated and unrecorded input to a certified answer (S1, hours)

`evaluate`'s `external: Externals<'_>` is `&[(String, Vec<Vec<u32>>)]` keyed by the flattened source
spelling (`:388`). The seeding loop (`:1180`–`1191`) `continue`s when the key matches no relation,
and extends the relation's flat row vector with each tuple without checking the tuple's length
against the relation's arity. Downstream the core rejects a total length that is not a multiple of
the arity and a value at or above the domain (`crates/verify/src/datalog.rs`), so what survives is:
a mistyped or stale relation name silently yields an empty input relation, and a set of tuples of
the wrong width whose total still divides by the arity is silently re-cut into different tuples.
Either way the run certifies the fixed point of a program the caller did not mean, and `Stratified`
records nothing about what was injected.

The differential harness protects itself by asserting the free-name sets of the two sides match
before injecting (`tests/rel_reference_eval.rs:166`–`173`), which is the check the library should
be making.

Recommendation: return an error naming an unknown relation and a tuple whose length is not the
arity, and record the seeded relation names with a digest of their tuples in the result.

### F4 — `lower` trusts an admission it cannot see, so a mis-sequenced call lowers one source against another's item list (S2, hours)

`Workspace::lower` reads `w.definitions` and `w.module_nodes` (`src/rel_frontend/lower.rs:1196`–
`1205`), which only `admit` clears and fills (`src/rel_frontend/admit.rs:335`, `:400`). `parse` does
not invalidate them. The doc states the requirement ("an admission that succeeded on them") and
nothing enforces it, so `parse(a); admit(a); parse(b); lower(b)` walks `b`'s node pool through `a`'s
definition and module node ids. No in-tree caller does this; the workspace is public API of the
crate and both stages are separately public.

Consequence: out-of-bounds indexing at best; at worst a program that lowers, evaluates and
certifies while describing neither source.

Recommendation: make the sequencing a type or a counter — bump a generation in `scan_variant`,
record it in `admit`, and refuse in `lower` — rather than a sentence in a doc comment. A token
returned by `admit` and consumed by `lower` is the cleaner shape but costs more callers.

### F5 — two backend routes, one of them dead, and the documented architecture describes the dead one (S2, ~1 day)

`rel_lowering::project` builds a serialized `rule_contract::Program` from the RIR and is called
from exactly one place in the tree, `tests/rel_lowering.rs:1277`. Everything that runs — the
operator tool, the bench, the differential harness, every driver test — goes through
`rel_stratified::evaluate`, which assembles a `PreparedSource` per layer and never serializes
anything. ADR 0004 and `notes/2026-09-15-c1190-lowering-architecture.md` still describe
`backend::rule_contract` as "the one allocating boundary" and the direct constructor as future
work; the code has been the other way round since the prepared constructor landed.

Consequences beyond stale documentation. First, the positive-fragment semantics now exist twice —
`project`'s own sign check and body-length check (`src/rel_lowering.rs:228`–`238`) beside the
driver's (`src/rel_stratified.rs:1636`–`1639`) — and only one is exercised end to end. Second, the
wire form is where the core's JSON identity, `check_admitted` and the certificate encodings live,
so any work on those (C1196) starts from the route nothing produces. Third, `Program` carries
`semiring` and a per-fact `cost`, and `PreparedSource` carries neither; see F6.

Recommendation: collapse to one. Either delete `project` and add a wire *export* built from the
same per-layer assembly the driver already does (so the exported program is by construction the
one that ran), or keep `project` explicitly as a debug/export path and say so in the ADR. Either
way the fragment check belongs in one place.

### F6 — min-plus cannot reach the route the driver uses, so C1194 is a seam change and not a lowering change (S2, days, and a decision first)

The demand-driven path admits the Boolean carrier only: `ergodis_verify::datalog::admit` refuses
anything else (`crates/verify/src/datalog.rs:185`) and `PreparedSource`
(`crates/verify/src/datalog.rs:363`) has no semiring field and no per-fact cost at all. The
min-plus carrier lives on the grounded path, which refuses a body of more than two atoms
(`crates/verify/src/rule_contract.rs:841`–`845`). On the private side, `rel_lowering::CARRIER` is
the constant `"boolean"` and its doc says min-plus is selected "when a source declares it", which
no construct of the language does — nothing in the frontend parses a carrier declaration, and the
RIR has no term arithmetic: `Term` is variable, constant or wildcard, and `Literal.op` holds only a
comparison or aggregate operator.

Consequence: C1194 (min-plus and term arithmetic through the lowering) cannot be done inside the
lowering. It needs, at minimum, a term-arithmetic representation in the RIR, a carrier and fact
cost on the prepared seam in core (or a grounded route in the driver, which then forces
`BodyPolicy::Binarize` back to mandatory for that carrier and has no stratified driver behind it),
and a decision about whether the stratified layer machinery applies to a non-Boolean carrier at
all — complements over a cost carrier are not the same object.

Recommendation: take the decision before the task is scoped. The cheap half — `min`/`max`/`sum`
aggregates over integer payloads — already works on the Boolean carrier at layer boundaries, and
`lower.rs:96`–`108` says why the min-over-sums case is the one that wants the carrier. Size the
task around the seam, not around the lowering.

### F7 — join order has two uncoordinated owners, and under the default policy the lowering contributes none (S2/S3, hours to fix, a decision to settle)

`order_body` — the variable-sharing, left-deep heuristic — is called from exactly one place,
inside `chain` (`src/rel_frontend/lower/passes.rs:613`), which runs only for a body longer than
`BodyPolicy::keep()`. `plan_bodies`'s final loop then fills `Rule.order` with `rule.first..rule.last`
in pool order for every rule (`:569`–`586`). Under the default `Nary` policy, `keep` is 4, so a
three- or four-atom body is handed to the core in **source order**, with no ordering pass having
looked at it. Meanwhile the core's demand plan chooses its own link order per step — most bound key
columns first, then fewer free variables, then body order (`crates/rules/src/demand.rs:27`–`28`,
`:864`–`869`).

`Rule.order`'s doc ("the body literals in the left-deep order binarization recorded"),
`Rir::join_order`'s doc, and the C1190 note's "recorded per rule so a later cost-based order is a
policy swap, not a rewrite" all describe a property that holds only on the chained path.

Consequence: the C1193 measurement that made `Nary` the default compared an ordered chain against
an unordered n-ary body. Whether that changed the outcome is *inferred, not confirmed* — I did not
re-read the C1193 receipts, and the core plan reorders links itself, which may absorb it — but it
is worth one check before the comparison is cited again. More importantly for queued work, a
cost-based planner has no single owner:
half the decision is in the lowering (chain shape and order) and half in the core plan (link
order), and neither knows about the other.

Recommendation: run `order_body` for every rule in `plan_bodies`, not only inside `chain` — that is
a few lines — and then decide explicitly which side owns join order before any planner work. If
the core plan owns it, `Rule.order` should be documented as a hint and the heuristic kept only for
choosing the chain's shape.

### F8 — the driver hard-wires `Policy::Auto` and exposes one knob, so no Rel-side measurement or plan hint is possible (S2, hours)

`evaluate` calls `Demand::from_prepared_bounded(.., max_rows, Policy::Auto)`
(`src/rel_stratified.rs:1744`–`1757`). The core's other addressing policies are public and used
only by `examples/closure_ballpark.rs:975`–`980`, which builds contract programs by hand. The Rel
path cannot select one, cannot see which one `Auto` chose per layer (`demand.policy()` exists and
is not read), and has nowhere to put the expected-evaluation-count hint the C1203 successor is
about. `max_rows` is a bare `u32` parameter in the middle of a four-argument function.

Recommendation: replace `max_rows` with a small options struct carrying the row bound, the policy
and later the plan hint, and record the chosen policy and the plan's own numbers per layer in
`LayerReport`.

### F9 — `verify_records` is optional, advisory in the measurement path, and not representable in the type (S3, hours)

`evaluate` returns a `Stratified` whose records have not been re-checked; each caller remembers to
call `verify_records` (`tests/rel_lowering.rs:112`, `tests/rel_reference_eval.rs:203`,
`tasks/tools/src/rel_lower.rs:303`). `rel_frontend_bench` calls it and records the outcome as a
boolean field in the receipt (`tasks/tools/src/rel_frontend_bench.rs:709`, printed as
`records_verified`), so a receipt whose one non-core check failed is still a receipt.

Recommendation: either run the check inside `evaluate` — it is cheap beside the evaluation it
follows — or return an unchecked type that `verify_records` converts into the checked one, so the
state is in the type. If a receipt is allowed to record a failed check, it should not be allowed
to record anything else from that run.

### F10 — one error variant for three record kinds, and the index spaces collide (S3, hours)

`Error::ComplementMismatch(usize)` is returned for a complement, a filter and an aggregate alike
(`src/rel_stratified.rs:988`, `:1031`, `:1059`), with the index into whichever of the three vectors
failed, and no field name and no span. `Error::CheckersDisagree(u32)` names the layer and neither
the relation nor the tuple. `Error::LayerCapacity` names the layer and the knob but has no span;
the lowering failures inside the same enum all do have one.

Consequence: the one check covering everything the core cannot see reports "record 0 of something
did not rebuild". Diagnosing it means re-running under a debugger.

Recommendation: an error enum that names the record kind, its index, and which field failed (the
domain rebuild, the universe, the counts, the digest). While there: `CheckersDisagree` should
carry the relation and the first differing tuple.

### F11 — the RIR's invariants are carried by convention: bare `u32` ids, `NONE` sentinels, a double-booked scratch field, parallel pools (S3, ~1 day for the worst of it)

Relations, rules, literals, terms and dictionary values are all bare `u32` indexes into `Rir`
pools, with `NONE = u32::MAX` as the sentinel for "absent" and, in `Literal.relation`, as the
marker that distinguishes a comparison literal (which names no relation) from every other sign
(`src/rel_stratified.rs:608`, `:1651`). Several pools are parallel and keyed by position:
`vars`/`bindings`, `relations`/`output`, `terms`/`term_spans`, and `rule.vars + variable` into
`bindings`. Chained rules share their parent's `vars` base, which is documented at `VarBinding`
and assumed at `Rir::binding_sites`.

The worst instance is `Literal.reserved: [u32; 2]`. Its doc (`lower.rs:227`–`232`) says it carries
a `forall`'s staged guard range, that nothing reads it after distribution, and that it is **not
part of the canonical form**. In fact `canonical_literal` writes `reserved[0]` for an aggregate
literal (`lower.rs:1374`–`1376`) and the driver reads it as the aggregated argument position
(`rel_stratified.rs:1341`). So the field is two unrelated things at two times, one of them is
load-bearing for the identity the parity corpus compares, and the record that describes it denies
both.

Consequence: every future pass has to learn these conventions from prose, and the canonical form's
stability argument rests on a field documented as scratch. This is the finding that costs the most
per future change.

Recommendation: give the aggregate's column its own named field — the 32-byte stride has room —
and correct the record. Newtypes over the pool ids would be the larger, separately decidable
change; if they are not wanted, say so once in the module header rather than leaving it implicit.

### F12 — budgets and refusals are declared in four places with four shapes, and one restatement is unanchored (S3, ~1 day)

The route's bounds live in: `Limits` (caller-supplied frontend pool sizes, exhaustion is
`REL0503` with a `Budget`), the restated core constants in `lower.rs:1137`–`1156`, the route bounds
`MAX_COMPLEMENT`/`MAX_FILTER` in the same file although only `rel_stratified` enforces them,
`MAX_LAYER_TUPLES` in `rel_stratified.rs`, and the `max_rows` argument, whose exhaustion returns
`Error::LayerCapacity` rather than a `Budget`. A caller therefore learns what was refused from
three different shapes: a `LowerFailure` with a code, a budget name and numbers; a
`LayerCapacity` with a layer and a knob; or a bare `CoreError` with neither.

`MAX_NAME = 64` is restated privately and is the one restatement the constants test
(`tests/rel_lowering.rs:1236`) does not cover; the core's counterpart is a literal `64` inside
`rule_contract::identifier`, so there is nothing to anchor it to.

Recommendation: keep only the core restatements in the dependency-free module, move
`MAX_COMPLEMENT`/`MAX_FILTER` beside `MAX_LAYER_TUPLES` where they are enforced, give every route
refusal the `Budget`-shaped form with numbers and a span, and either export a named `MAX_NAME` from
core or extend the constants test.

### F13 — the reference evaluator's stated contract understates what it now covers (S3, hours)

`tests/rel_reference/mod.rs:46`–`48` states that comparison and aggregation "are represented far
enough to be range-restricted and stratified and are then rejected, exactly as the backend rejects
them", and `Reject`'s doc repeats the framing. The evaluator in fact stages `Sign::Comparison` and
`Sign::Aggregate`, evaluates aggregates over a completed level (`:1972`–`2002`), refuses a
non-integer aggregate column through `aggregate_refusal`, and has a second strategy,
`evaluate_by_enumeration`, that even extends the active domain with the values an aggregate can
invent.

This matters more than a stale sentence usually would: the harness's claim that agreement is
evidence about the lowering rests on what the oracle independently admits and computes, and that
statement is the only place it is written down.

Recommendation: restate the covered fragment where it is stated. Also worth stating there, because
it is the oracle's real blind spot: both sides share the scanner, the parser and admission, so no
defect in those three is visible to the differential at all.

### F14 — the frontend's public API is half measurement surface (S3/S4, hours)

`Workspace` exposes `touch()`, `retained_bytes()`, `fingerprint()`, `scan_only_variant`, the
`parse_variant::<BYTE_SCAN>` control variant, and `corpus` as a `pub mod` of the frontend; `Rir`
exposes every pool by accessor, plus `canonical`/`Sink`/`Fnv`. `BodyPolicy::Binarize` is
documented as "the measured control". The crate is private and unpublished, so nothing ships, and
the parity harness needs some of this. But a reader cannot tell the admission boundary from the
cost-attribution aids, and the measurement items are what the bare-`rustc` compile has to keep
compiling.

Recommendation: no code move is worth it now; when the subsystem gets its own crate boundary (the
right time is whenever F5 is settled), put the measurement aids behind a feature the parity build
turns on and leave the stage entry points as the default surface. Keeping `BodyPolicy::Binarize`
is right on its merits — the differential runs both policies against the oracle
(`tests/rel_reference_eval.rs:299`–`311`), which is a stronger check than comparing the two with
each other.

### F15 — the parity record omits three lowering counters (S4, minutes)

`tests/rel_frontend_portability.rs` writes `relations … witnesses` and the fingerprint into the
parity record but not `Lowering::{comparisons, aggregates, aggregated}`. The canonical bytes, which
are compared in full, do carry the signs, so nothing is unprotected; the omission is only an
inconsistency in what the record says it summarizes.

### F16 — the record digests have no domain separation (S3, minutes)

`digest_of` (`src/rel_stratified.rs:955`) is SHA-256 over the flattened tuple values and nothing
else: no schema tag, no relation name, no arity, no operator. Two constructions of different arity
over the same flat value sequence hash alike, and a filter digest and a complement digest are drawn
from the same space. Inside `verify_records` the surrounding fields are checked separately, so this
is not exploitable today; it becomes one the moment records are serialized and compared across runs,
which is exactly what C1196 and F1 point at.

Recommendation: prefix the hash with a schema tag, the record kind, the relation name and the
arity, as `Rir::canonical` already does with `CANONICAL_SCHEMA`. Doing it before records are
written anywhere durable costs nothing; afterwards it invalidates every stored digest.

## 4. Answers to the card's questions, for this half

**Ownership.** The core/private split itself is principled: core holds the contract, the evaluator
and the checkers; private holds the language, the lowering and the route that turns non-monotone
constructs into positive ones. The arrows that exist for incidental reasons are named in §1.2:
`rel_lowering.rs` and `rel_stratified.rs` sit beside `rel_frontend` because the parity harness
compiles the frontend with bare `rustc`; the crate-wide dependency on `ergodis` is nothing to do
with this subsystem; and `rel_stratified`'s dependency on `rel_lowering` is for the decode map
only, not for the backend that module is named after (F5). The subsystem has no crate boundary, so
"private" here means "one of two hundred modules in a private library", which is what makes F5 and
F14 easy to leave unresolved.

**Contracts.** §2 is the table. The ones that nothing enforces are the stage sequencing
(`parse` → `admit` → `lower`, F4) and the external-fact contract (F3). The ones stated only in
dated reports or ADR prose are: the backend projection being "the one allocating boundary" (no
longer true, F5); the join order being recorded per rule so a planner is a policy swap (true only
on the chained path, F7); and the exactness argument for per-column complement domains, which is
written in the `rel_stratified` module header and in the C1190 note and is not derivable from any
type — it is the argument the whole negation route rests on, and it lives in a doc comment.

**Types.** Where the types do work: `Limits` makes pool exhaustion a value rather than a panic;
`Budget` + `LowerFailure` make a refusal carry its numbers and spans; `BodyPolicy` is a real
two-value policy rather than a boolean; `TupleSource` names where a layer's tuples come from;
`DomainSource` makes a column domain's provenance a variant rather than a comment. Where
invariants are carried by convention: F11 (bare `u32` ids, `NONE` sentinels, parallel pools, the
double-booked `Literal.reserved`), plus `Option` used as a mode flag in the core's
`Demand::source()` (core's call, but the private side is the consumer that now always sees `None`).
Illegal states that are representable: a `Stratified` whose records have not been checked (F9); a
`ComplementRecord` whose `source` name contradicts its `relation` id (F2); a `Workspace` lowering a
parse no admission saw (F4).

**Trust boundary.** For an accepted stratified answer to mean the answer is right, all of this must
be trusted: the scanner, parser and admission (shared by the oracle, so the differential says
nothing about them); the lowering passes (the oracle does cover these); the core contract,
evaluator and both checkers (the other half's subject); and — with no independent check at all —
`complement_over`, `filter_over`/`satisfies`, `aggregate_over` and the `Dictionary`, because
`verify_records` re-runs them (F2). Within one run the layer-to-layer binding is real and better
than the ADR promises: the driver takes the **checker's** relations, deduplicates them, compares
them tuple-wise against the evaluator's rows, and fails on any difference
(`src/rel_stratified.rs:1793`–`1807`). Outside the run there is no binding at all: no certificate,
no layer program, no source identity, no record of which declared relation stood for which literal
(F1). One more gap is worth naming here: the only comparison against a foreign implementation,
`closure_ballpark --souffle-csv`, runs on programs the example builds by hand, so no external
Datalog engine has ever seen a Rel-lowered program. Every cross-check of the Rel path is in-tree.

**Identity.** Eight identities are in play on this side, and their relationships are not written
down anywhere as a set. (1) The tool's SHA-256 of the source text. (2) `Workspace::fingerprint()`,
FNV over tokens and nodes, for differential controls. (3) `Rir::fingerprint()` over the canonical
bytes under `CANONICAL_SCHEMA` = `ergodis.rel_frontend.rir.v1`, also FNV and explicitly "not a
certificate". (4) The parity record's SHA-256 over the whole native/WASM byte record, plus per-file
source hashes in `portability-v1.json`. (5) The three per-construction SHA-256 digests. (6) The
bench's own SHA-256 over `Stratified::closure`. (7) The core's prepared source identity,
`Demand::source_id()` — computed on every layer and read by nobody. (8) The core's wire identity of
a `rule_contract::Program`, reachable only through the route nothing runs (F5). Two can disagree
silently in the way that matters: nothing binds (3) to (5) or to (6), so a set of records and a
closure cannot be shown to belong to the program whose fingerprint was recorded. And (5) has no
domain separation (F16).

**Limits and refusals.** There is not one model; there are four shapes (F12). The positive part:
every construction checks its *projected* size against its bound before enumerating anything, so a
refusal carries numbers and nothing large is built first — that discipline is consistent across
complements, filters, aggregates and the layer total, and it is the best-designed part of the
driver. The negative part: `Limits` is caller-supplied and its exhaustion is reported in the same
`REL0503` family as fixed backend bounds, so "the workspace you asked for was too small" and "this
route will not do that" are the same code with different budget names; and the row capacity escapes
the family entirely.

**Extension pressure.** C1194 min-plus and term arithmetic: blocked at the seam, not at the
lowering (F6) — the demand path is Boolean-only and `PreparedSource` has no carrier or fact cost,
and the grounded path that does have min-plus caps bodies at two atoms. C1195 end-to-end suite:
well served, since the corpora and the differential already exist; what it will want is F9 (the
record check not being optional) and F1 (something to assert about, offline). C1196 certificate
encodings: starts from a route nothing produces (F5) and from digests with no domain separation
(F16). The C1203 successor and any cost-based planner: F7 (two uncoordinated join-order owners) and
F8 (no policy or hint seam). Incremental evaluation: nothing in the layer loop is incremental — a
layer rebuilds every complement, filter and aggregate from scratch, and `closure` is replaced
wholesale — but nothing forbids it either; the records already name exactly what each construction
is a function of, which is the right starting point. WASM: the frontend is clean (std-only, proven
by the parity build); the driver is not portable and was never meant to be, which is fine as long
as F5 does not accidentally make the wire route the WASM route.

**Accretion.** Three residues. The dead wire backend beside the live prepared one, with the
documentation describing the dead one (F5) — this is the one to collapse. The binarization path
beside n-ary bodies: worth keeping, because the differential runs both policies against the oracle,
but the naming and the doc comments still treat binarization as the route rather than as a policy,
and the ordering heuristic that came with it now runs only on that path (F7). The `Literal.reserved`
field, which is where the `forall` desugaring and the aggregate column both landed because there
was room (F11).

**API surface.** On this side: `Rir` exposes every pool, the frontend exposes its measurement aids,
and `corpus` is part of the frontend (F14). What a first outside user of this subsystem would have
to understand is `Workspace` + `Limits` + the three-stage sequence + `ErrorCode::id()` — which is a
good surface — and then, to do anything with the result, the whole of `Rir`, because there is no
narrower view of a lowered program than its pools.

## 5. For the core-half reviewer and the synthesis

1. **How independent are `verify` and `verify_ranked` from the evaluator, at the code level?** The
   driver treats their agreement as decisive and then uses `verify`'s relations as the closure the
   next layer reads and the records are rebuilt against. If both checkers share the plan, the row
   store or the index structures with `evaluate_into`, the driver's strongest guarantee is weaker
   than it reads.
2. **Does `Demand::source_id()` on a prepared source cover the relation names, arities, input flags,
   rules and the fact *sets*?** F1's fix is shaped by the answer: if it does, recording it per layer
   plus the declared names is enough to bind a layer program; if it does not, the layer program has
   to be recorded more fully.
3. **Can `evaluate_into` or `workspace()` return `CoreError::Budget` for anything other than row
   capacity?** The driver maps both to `Error::LayerCapacity { layer, max_rows }`
   (`src/rel_stratified.rs:1761`–`1774`), which would mislabel any other budget.
4. **Is the `MAX_BODY` split — four on the demand path, two on the grounded path — stable?** A wire
   program exported from this side under `BodyPolicy::Nary` is admitted by the demand path and
   refused by the grounded one, so "the certificate the grounded checker replays" is not available
   for the default policy. Whether `check_admitted` covers the four-atom wire form matters to F5.
5. **Are the `Policy` corners (`Direct`, `Sparse`, `SparseIndexes`, `SparseMembership`,
   `AutoUndemoted`) meant to be public API?** Their only consumer in the private tree is
   `examples/closure_ballpark.rs`; the Rel driver hard-wires `Auto` (F8).
6. **Each layer declares its own `domain`**, because an aggregate appends to the dictionary between
   layers (`src/rel_stratified.rs:1750`). Does anything in the core's identity or certificate model
   object to two layers of one run carrying different domains for relations of the same names?
7. **`Demand::source()` returning `Option`**: on the prepared path it is always `None`, so the
   private side never has a wire program to hand a checker. Flagging it because the card lists it as
   an `Option`-as-mode question and this half is the evidence for how it is used in practice.

## 6. Unexplained

1. **`MAX_COMPLEMENT`, `MAX_FILTER` and `MAX_LAYER_TUPLES` are all exactly `1 << 22`.** The
   `MAX_LAYER_TUPLES` doc argues the equality is deliberate ("a layer may materialize as many
   tuples as one negation may"), and the consequence is that on a layer with one construction the
   layer bound can essentially never bind before the construction's own bound does, so it is a live
   bound only for multi-construction layers. That may be exactly the intent; it is not stated as a
   choice among alternatives, and a single number serving three purposes is the kind of coincidence
   that later reads as an invariant.
2. **Two unrelated 64s.** `Limits::disjuncts` defaults to 64 (`Budget::Disjuncts`) and `chain`'s
   stack array is 64 wide (`Budget::BodyAtoms`). Nothing relates them; both are plausible
   independently.
3. **The complement construction's memory bound is implicit.** `complement_over` allocates a
   `vec![false; universe]` membership vector, so `MAX_COMPLEMENT` is simultaneously a tuple bound
   and a 4-mebibyte-per-complement allocation bound, and `verify_records` allocates it a second
   time. The bound is documented as a tuple count; that it is also the memory bound is not said.
4. **Why the layer program declares relations no rule of the layer reads.** `needed[id] |=
   layer_of[id] == layer` (`src/rel_stratified.rs:1237`–`1239`) is explained as keeping layer zero
   of a fact-only source identical to milestone (a)'s single projection. It works, but it means a
   layer's relation set is not "what the layer uses", which is a surprising property for anything
   later that reasons about layer programs — including F1's records.
5. **Nothing recorded anywhere says which `BodyPolicy` produced a given result.** The policy changes
   the program, so it changes the canonical bytes and the fingerprint, and is therefore implicitly
   captured; but neither `Lowering`, `Stratified` nor `LayerReport` names it, so a receipt's numbers
   are only interpretable beside the command line that produced them.
