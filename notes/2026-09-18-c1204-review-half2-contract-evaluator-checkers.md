# C1204 architecture review, second half: rule contract, demand evaluator, certificates and checkers

**Lane**: `ergodis`
**Date**: 2026-09-18
**Scope**: core `~/src/ergodis` at HEAD `96aee9b` — `crates/rules` (grounded contract wrapper, demand
evaluator, `Pages`, C ABI provider) and `crates/verify` (`rule_contract`, `datalog`,
`datalog_store`, `derivation`, `ranked`, `support`, `weight`), plus the seam as seen from core: what
core exposes to and assumes of `ergodis-private`'s Rel lowering and stratified driver. Read-only;
no file under `ergodis*` was modified. The private frontend, lowering internals and stratified
driver internals belong to the sibling reviewer.

**Status**: complete. Everything below was read in the source at that commit and every `file:symbol`
citation was checked against it. Where a claim is inferred rather than read it is marked
**inferred**; F14's WebAssembly consequence is the only one so marked.

## 1. Architecture map

### 1.1 Modules and roles

`crates/verify` (`ergodis-verify`) — no dependency on any Ergodis optimization kernel:

| Module | Role |
|---|---|
| `rule_contract.rs`   | The wire format (`Program`, `Relation`, `Atom`, `Term`, `Rule`, `Fact`), the carrier enum, the error type used by everything in both crates, the grounded admission `ground` → `Grounded`, the scalar `Certificate`, `encode_source`/`identity_of`, `FactStream` (incremental re-hash for one changed fact). |
| `weight.rs`          | The carrier abstraction: sealed trait `TransitionWeight`, `WeightProperties`, `Stability`, instances `BoundedMinPlus` and `Boolean`. |
| `composition_graph.rs` | `ProductRule`, `Limits`, `VerifiedGraph`, the grounded replay checker. |
| `support.rs`         | Grounded support certificate (rank + product witness per scalar slot) and its checker. |
| `datalog.rs`         | Relational admission for the demand path: budgets, `Slot`/`AtomRef`/`AdmittedRule`/`AdmittedRelation`/`AdmittedFact`/`Admitted`, `admit` (wire) and `admit_prepared` (resolved), `PreparedSource` and its canonical streamed identity. Nothing here evaluates. |
| `datalog_store.rs`   | Checker-side storage: `Keys` (direct array + presence bitmap, or sorted key array), `RelationStore`, `JoinIndexes` (CSR by counting sort), `Rows`. `pub(crate)` except `DIRECT_LIMIT`. |
| `derivation.rs`      | `DerivationCertificate`, `premise_stride`, the trace-following checker, and the shared `closed_world` completeness pass plus `unify`/`head_matches`/`head_key`/`fixed_mask`/`mark_bound`. |
| `ranked.rs`          | `RankedCertificate`, the searching checker (`justified`), which reuses `derivation`'s helpers and its `closed_world`. |
| `binary_composition.rs`, `min_plus_transition.rs`, `finite_lowering.rs` | Other capabilities; touched here only because `implementation_identity()` spans them. |
| `lib.rs`             | `ContentId`, `implementation_identity()` (SHA-256 over eleven of this crate's source files), re-export of `DIRECT_LIMIT`. |

`crates/rules` (`ergodis-rules`):

| Module | Role |
|---|---|
| `lib.rs`      | `Prepared` — the **grounded** min-plus plan over `rule_contract::Grounded`: dense `Workspace`, synchronous frontier iteration, scalar `Certificate` and `SupportCertificate` emission, `with_fact`/`update_into` incremental path, `from_scalars`. This is the min-plus/runtime path, not the Datalog path. |
| `demand.rs`   | `Demand` — the demand-driven semi-naive Boolean Datalog evaluator: `Policy`, the plan records `Op`/`Step`/`Link`/`Index`/`RelationPlan`, `DemandWorkspace`, `Evaluation`, the monomorphized two-atom and n-ary kernels, `DerivationCertificate`/`RankedCertificate` emission, and thin `verify`/`verify_ranked` wrappers. |
| `pages.rs`    | `Pages<T>`: one anonymous `MAP_NORESERVE` mmap per workspace structure on Unix, `alloc_zeroed` elsewhere; the `reservations()` counter that the allocation-free regression reads. The only `unsafe` in the crate. |
| `frontier.rs` | `Users` — variable→product index for the grounded path only. |
| `provider.rs` | The native/WASM C ABI module. It exposes **`Prepared` only**: prepare, workspace, evaluate, verify, support, verify-support. `Demand` has no ABI. |

### 1.2 Dependency arrows

```
                       serde / serde_json / sha2 / thiserror
                                    |
                            ergodis-verify  <-------------------.
                             (checkers +                        |
                              shared contract types)            |  dev-dependency only
                                 ^      ^                       |  (closes the synthesizer
                                 |      |                       |   property test)
             ergodis-rules ------'      |                       |
              (Prepared,                |                    ergodis  (root crate)
               Demand, Pages)           |                       |
                 ^     ^                '-----------------------'
                 |     |                        depends on verify
                 |     '---- ergodis-modules  (C ABI vocabulary, used by provider.rs)
                 |
   ergodis-runtime  (uses Prepared, not Demand)
                 ^
                 |
        ergodis-private   (rel_lowering.rs -> rule_contract;
                           rel_stratified.rs -> demand::{Demand, Policy}
                                             + datalog::{PreparedSource, ...};
                           examples/closure_ballpark.rs -> almost everything)
```

Two things follow and they matter for the trust boundary. First, `ergodis-verify` does **not**
depend on `ergodis-rules`: the checkers cannot call the evaluator, and that half of the boundary is
real at the crate level. Second, `ergodis-rules` **does** depend on `ergodis-verify`, and not only
for the checkers — `datalog::{PreparedSource, Slot, AtomRef, Admitted, MAX_*}` are producer input
types that live in the checker crate (finding F15).

### 1.3 Traced data flow, route A: wire JSON

1. `rule_contract::decode_program(bytes)` — refuses above `MAX_BYTES` (1 MiB), then `serde_json`
   with `deny_unknown_fields` → `Program`.
2. `Demand::new(source)` → `Demand::new_bounded(source, MAX_ROWS, Policy::Auto)` →
   `datalog::admit(&source)`: carrier must be Boolean, `schema == SCHEMA`, `stability == 0`, domain
   in `1..=MAX_DOMAIN`, no declared symmetries, relation and rule counts, identifier spelling,
   arities, constants below the domain, variables numbered by first occurrence in body order, head
   variables must be body-bound, head relation must not be `input`, facts deduplicated by packed
   key with cost-zero facts dropped. `source_id = SHA256(SCHEMA ‖ canonical JSON)`;
   `fact_count = Program::facts.len()` including duplicates and absent facts.
3. `Demand::prepare(admitted, Some(source), row_bound, policy)`: one `RelationPlan` per relation
   (capacity = `min(universe, row_bound)` for a derived relation, fact count otherwise; membership
   bitmap or hash table; `premise_width` = longest body of any rule heading it); one `Step` per
   (rule, delta position) with the non-delta atoms ordered greedily (most bound key columns, then
   fewest new variables, then body order) and kept inline for one link or in the `Link` pool for
   two or three; then three passes — `estimate_probes`, `Demotion::apply` (drop key columns the
   policy will not address directly and verify them per row instead), re-slot the index shapes,
   `estimate_probes` again, `Demand::index` chooses `KIND_CSR`/`KIND_SORTED`/`KIND_CHAIN`/
   `KIND_HASHED` and materializes the two static shapes; the kinds are written back into the steps
   and links.
4. `Demand::workspace()` — `workspace_bytes()` against `MAX_WORKSPACE_BYTES`, then one `Pages`
   reservation per row store, membership structure, witness column and dynamic index.
5. `Demand::evaluate_into(&mut ws)` — `shape()` check (row bound, domain, per-relation shapes),
   `clear_indexes` (walk last evaluation's rows, or linear fill by `RESET_FILL_BYTES_PER_ROW`),
   refill facts and membership, build dynamic indexes, then rounds of steps until no relation has
   a nonempty delta. `emit` writes the row, the membership entry, `rule_of`, the interleaved
   `premises` block, `seq` and `round_of`.
6. `Demand::certificate(&ws)` → `DerivationCertificate { schema: DERIVATION_SCHEMA, source_id,
   fact_count, rules, premises, tuples }`; premise references are `1..=fact_count` for a program
   fact and `fact_count + 1 + i` for derivation `i`; the block width is
   `derivation::premise_stride(body.len())`, floored at two.
   `Demand::ranked_certificate(&ws)` → `RankedCertificate { schema, source_id, relations: [ {tuples,
   ranks} ] }` with the round as the rank.
7. `Demand::verify(&cert)` → `derivation::check(program, cert)`: **re-admits the program**, checks
   schema/identity/fact-count binding, then one pass per derivation (resolve each premise, `unify`
   against the body atom, require the listed tuple to be the derived head, insert into a fresh
   `RelationStore`, reject a repeat as `Duplicate`), then `closed_world`, then returns `Relations`.
   `Demand::verify_ranked(&cert)` → `ranked::check(program, cert)`: re-admits, inserts facts at
   rank zero and every listed tuple, builds the masks `needed_indexes` computes, then for each
   listed tuple searches every rule with that head for a body match whose premises all have lower
   rank, then the same `closed_world`, then `Relations`.

### 1.4 Traced data flow, route B: prepared / direct

Steps 3–6 are byte-for-byte the same body. What differs is the ends:

- The private lowering builds `PreparedSource { domain, relations: &[PreparedRelation], rules:
  &[PreparedRule], facts: &[&[u32]] }` — everything borrowed, no owned name or tuple per fact, no
  serialization, so no byte budget.
- `datalog::admit_prepared` enforces the same budgets through the same `Error` values, additionally
  requires the caller's variable numbering to be the canonical one, sorts and deduplicates each
  relation's tuples, and computes `source_id` by streaming a canonical binary encoding under the
  separate tag `PREPARED_SCHEMA` through a 512-byte window into SHA-256. `fact_count` is then the
  deduplicated present count, not a wire count. `MAX_BYTES` has no counterpart.
- `Demand::source()` is `None`, so `verify`/`verify_ranked` dispatch to
  `derivation::check_admitted` / `ranked::check_admitted`, which take `&Admitted` — **the
  producer's own admitted source object**. Nothing is re-admitted and nothing is re-serialized.

`ergodis-private/src/rel_stratified.rs:1744–1807` is the only product consumer, and it is route B:
one `Demand::from_prepared_bounded(.., max_rows, Policy::Auto)` per stratum, `workspace`,
`evaluate_into`, `certificate`, `verify`, `ranked_certificate`, `verify_ranked`, the two checkers'
`Relations` compared for equality (`Error::CheckersDisagree`), then `Demand::rows` compared
tuple-wise against the checker's relations before the next layer's complement is taken.

## 2. Per-seam contract table

| Seam | The contract | Where written | What enforces it |
|---|---|---|---|
| bytes → `Program` | at most `MAX_BYTES`; exact field set (`deny_unknown_fields`) | `rule_contract::decode_program` | types + serde |
| `Program` → grounded language | domain ≤ 32, relations ≤ 32, arity ≤ 3, body ≤ 2 atoms, ≤ 3 variables per rule, rules ≤ 128, `MAX_SCALARS`/`MAX_PRODUCTS`/`MAX_WORK`, symmetries checked against inputs and the product multiset | `rule_contract::ground` | the function; refusals are `Error::{Source,Budget,Symmetry,Encoding}` |
| `Program` → Datalog language | Boolean only, domain ≤ 65 536, relations ≤ 64, arity ≤ 4, body ≤ 4 atoms, ≤ 8 variables, rules ≤ 1024, no symmetries, head not `input`, head variables body-bound | `datalog::admit` | the function; one test pins that a three-atom body is admitted here and refused by `ground` |
| the two languages are different | stated in a docstring | `datalog.rs:70–79` (`MAX_BODY`) | one named test; **nothing in the types** — both stamp one `SCHEMA` and one identity function |
| `PreparedSource` → `Admitted` | same budgets as the wire path; **caller must supply the canonical variable numbering**; facts need not be sorted or distinct | `datalog::admit_prepared` docstrings | the function (`next != rule.variables` → `Error::Source`) |
| plan ↔ workspace | same row bound, same domain, same per-relation shapes; a workspace is bound to one `source_id` after a completed evaluation | `Demand::shape`, `Demand::workspace_bytes` | `Error::Source` / `Error::Binding` at every readout |
| evaluator → derivation certificate | one premise per body atom in **body** order, blocks of `premise_stride`, padding slots must be zero, references `1..=fact_count` / `fact_count+1+i` | `derivation.rs:38–56`, `DerivationCertificate` docs | the checker (`Rejection::{Premise,Rank,Coverage}`); producer-side it is `Step::position` / `Link::position` by convention |
| evaluator → ranked certificate | derived tuples only (never a fact), rank ≥ 1, ranks well-founded | `ranked.rs` docs | the checker (`Rejection::{Coverage,Duplicate,Unjustified}`) |
| certificate → answer | listed set is derivable (soundness) **and** locally fixed (completeness), hence the least model | `derivation.rs:20–24` module docstring | the two passes in code; **no Lean statement, no test target in `crates/verify/tests/`** |
| checker independence | "the source is admitted here independently of the producer" | `derivation::check` / `ranked::check` docstrings | true for the wire route only, and only against the plan — admission, the store, `closed_world` and the unification helpers are shared (F2) |
| workspace memory | reservation is address space, commit follows first touch | `pages.rs:1–23`, `Demand::workspace` docs | true on Unix only; `alloc_zeroed` elsewhere by the same docstring |
| core ← private | `ergodis-private` may depend on core; core names no private adapter | `ergodis/AGENTS.md` | the Cargo graph |
| per-layer glue (complement, aggregate, filter facts) | outside the core contract entirely | private `rel_stratified.rs` | a private SHA-256 digest recomputation, not a core checker (see §7) |

## 3. Identity inventory

| Identity | Computed by | Binds | Consumed by | Can it disagree silently? |
|---|---|---|---|---|
| wire source identity `SHA256(SCHEMA ‖ canonical JSON)` | `rule_contract::identity_of` via `encode_source`; produced by `ground` and by `datalog::admit` | the whole serialized `Program`: declaration order, constants, duplicate facts, rules, symmetry declarations | `Certificate`, `SupportCertificate`, `DerivationCertificate`, `RankedCertificate` | no — both paths call the same function on the same bytes |
| `FactStream` re-hash | `Grounded::rebind` (producer-side shortcut) | the same wire identity for a program differing in one fact | `Prepared::with_fact` | a divergence produces a certificate that fails verification rather than a wrong accept; the docstring says so and the code re-hashes in full if the field layout is unexpected |
| prepared source identity (streamed binary under `PREPARED_SCHEMA`) | `datalog::admit_prepared` only | domain, relation names/arities/`input`, every rule's variable count and resolved slots, and the **sorted deduplicated** fact set | `DerivationCertificate`, `RankedCertificate` on route B | it cannot collide with the wire identity (different tag). But it is computed **once, by the producer**, and there is no second implementation and no serialization to recompute it from (F1) |
| `implementation_identity()` | `verify/lib.rs` — SHA-256 over eleven source files including `datalog.rs`, `derivation.rs`, `ranked.rs`, `datalog_store.rs` | the checker package's source provenance only; explicitly not a toolchain attestation | `src/admission.rs::checker_identity`, `binary_composition` receipts | it binds **no Datalog certificate**; and it changes when a producer-facing input type in `datalog.rs` changes (F15) |
| plan fingerprint | — | — | — | **does not exist**: the row bound, the `Policy`, the chosen index kinds and the demotion decisions are invisible to every certificate. Correct for soundness, a gap for evidence bundles (F13) |
| per-layer tuple digests | private `rel_stratified.rs::digest_of` | a complement / filter / aggregate tuple set | the private `verify_records` re-check | private half; the re-check is the same code run twice (§7) |

## 4. Budget, limit and refusal inventory

| Budget | Value | Where | Refusal | Who learns what |
|---|---|---|---|---|
| `MAX_BYTES` | 1 MiB | `rule_contract` | `Error::Budget` | wire route only; no prepared counterpart |
| `MAX_SCALARS` / `MAX_PRODUCTS` / `MAX_WORK` | 4096 / 65 536 / 2^24 | `rule_contract` | `Error::Budget` | grounded path only |
| `ground` shape caps | domain 32, relations 32, arity 3, rules 128, body 2, variables 3, symmetries 8 | `rule_contract::ground` | `Error::{Budget,Source}` | grounded path only |
| `MAX_DOMAIN` / `MAX_RELATIONS` / `MAX_RULES` / `MAX_ARITY` / `MAX_BODY` / `MAX_VARIABLES` | 65 536 / 64 / 1024 / 4 / 4 / 8 | `datalog` | `Error::{Budget,Source}` | both admission doors, same values |
| `MAX_ROWS` | 2^24, also the **default** row bound of every plan | `demand` | `Error::Budget` if a caller asks for zero | per derived relation, whatever the program |
| row capacity exhausted mid-run | `min(universe, row_bound)` per relation | `Demand::emit` | `Error::Budget` | which relation and which round are **not** reported |
| `MAX_WORKSPACE_BYTES` | 2^34 (16 GiB) of reservation | `Demand::workspace` | `Error::Budget` | `workspace_bytes()` is the figure checked, and it is address space |
| policy ceilings `MAX_DIRECT_KEYS` / `MAX_DIRECT_UNIVERSE` | 2^24 keys / 2^30 tuples | `demand::Policy` | **not refusals** — a fallback to the sparse shape | documented as such |
| round guard | `total_capacity + 1` | `evaluate_counting` | `Error::Budget`, documented unreachable | — |
| `round_bound` `min(N, M+1)` | grounding shape | `rule_contract::Grounded` | `Error::Budget` in `Prepared::propagate`, documented unreachable | grounded path |
| `DIRECT_LIMIT` | 2^26 `u32` entries | `datalog_store` | **not a refusal** — sorted fallback | checker-side only; unrelated to the evaluator's ceilings |
| `direct_limit` parameter | caller-supplied, unbounded | `check_bounded`, `check_admitted_bounded` | none | a large value allocates `vec![0u32; universe]` and aborts (F5) |
| `MAX_LAYER_TUPLES`, layer capacity | private | `rel_stratified` | `Error::LayerCapacity { layer, max_rows }` | collapses two distinct core `Error::Budget` causes into one |

The error taxonomy is one enum, `rule_contract::Error`, with twelve variants, of which the demand
evaluator uses exactly three: `Budget`, `Source`, `Binding`. The two checkers have their own
`Rejection` enums, which are informative, and they are folded into `Error::{Derivation,Ranked}`
with `{0:?}` formatting when they cross back.

## 5. Findings, ranked

### F1 — A prepared-source certificate can only be checked by the process that produced it (S1)

`Demand::from_prepared`/`from_prepared_bounded` (`crates/rules/src/demand.rs:746,752`) hold
`source: None`, so `Demand::verify` and `Demand::verify_ranked`
(`crates/rules/src/demand.rs:2775,2765`) dispatch to `derivation::check_admitted`
(`crates/verify/src/derivation.rs:241`) and `ranked::check_admitted`
(`crates/verify/src/ranked.rs:239`), which take `&Admitted` — the producer's own admitted source.
`Demand` exposes no accessor for it, `PreparedSource` has no serialization, and
`datalog::admit_prepared` is the only implementation of the prepared identity.

Consequence: on route B the binding check `certificate.source_id == admitted.source_id` compares a
digest the producer computed against a digest the producer computed, of an object only the producer
holds. There is no artifact a third party could re-admit, and no API by which they could supply
one. `ergodis-private/src/rel_stratified.rs:1744–1785` — the entire Rel product path, every layer
of it — is route B. The certificate is therefore a within-process self-consistency check on that
path, not a transferable artifact, which is the opposite of what the programme's goal sentence
("recursive exact optimization … with a certificate, targetable by an external compiler") requires
of it. This is also why the wire path's advantages read as an aside in the docstrings rather than
as the reason the wire path exists.

Recommendation: `admit_prepared` already contains a canonical byte encoding of the prepared source
(`crates/verify/src/datalog.rs:576–622`) — it streams it into SHA-256 instead of materializing it.
Factor that into `encode_prepared(&PreparedSource) -> Vec<u8>` plus `decode_prepared(&[u8]) ->
Admitted`, so the prepared identity becomes recomputable from bytes and both checkers get a wire
entry point for route B. Then `check_admitted` becomes a documented in-process fast path rather
than the only door. Size: days.

### F2 — "Two independent checkers" overstates the independence; the completeness half is one implementation (S1)

`ranked.rs:347` calls `derivation::closed_world`. `ranked.rs` also imports and uses
`derivation::{unify, head_matches, fixed_mask, mark_bound}` (`crates/verify/src/ranked.rs:28,93,
123,130,150,158,193,204`). Both checkers build the same `RelationStore` and `JoinIndexes` from
`datalog_store.rs`, and both reach `Admitted` through the same `datalog::admit` or the same
`admit_prepared`.

Consequence: `rel_stratified.rs:1783` treats disagreement between the two as a failure
(`Error::CheckersDisagree`) and, implicitly, agreement as corroboration. The two differ only in the
soundness half — following a supplied trace against searching for a justification. Everything
else — admission, the store, the unification primitives, and the whole completeness argument — is
common mode. A defect in `closed_world`, in `unify`, in `Keys::insert`, or in either admission
function is accepted by both checkers together, and the differential test
`crates/rules/tests/demand_sparse.rs` cannot see it either, because it compares policies of one
evaluator.

Recommendation: two parts, and they should be separated. (a) State the shared core where the claim
is made — the module docstrings of `derivation.rs` and `ranked.rs`, and anywhere a report calls
them independent — so the corroboration is not read wider than it is; hours. (b) If the
corroboration is meant to carry weight, give one of the two an independently written completeness
pass, or route completeness through the Python differential oracle on the same corpus; days.

### F3 — The demand evaluator is not an instance of the carrier abstraction, and C1194 cannot extend it incrementally (S2)

`demand.rs` imports nothing from `weight.rs`; it is Boolean throughout. `datalog::admit`
(`crates/verify/src/datalog.rs:185`) refuses every carrier but Boolean with `Error::Schema`, and
`admit_prepared` has no carrier field at all. `TransitionWeight` is sealed
(`crates/verify/src/weight.rs:67`, `sealed::Sealed`), so the carrier abstraction is closed to
outside instances; it is used by `Prepared`, `composition_graph` and `support`, i.e. the grounded
path only.

Deeper than the carrier: the demand path has **set** semantics end to end. `Demand::emit`
(`crates/rules/src/demand.rs:1837–1871`) inserts a tuple once and returns early if it is already
present; the row store is append-only and no derived row is ever revisited. Both certificate
formats bake that in — `derivation::check_admitted_bounded` rejects a repeated tuple as
`Rejection::Duplicate` (`derivation.rs:335`), and `ranked` rejects a listed tuple that is also a
fact or listed twice (`ranked.rs:307,311`). A min-plus evaluation must *improve* a tuple's value
after its first derivation, which is exactly the event all three refuse.

Consequence: C1194 (min-plus and term arithmetic through the lowering) is a new evaluator and new
certificate formats, not a generalization of `Demand`. The programme table currently reads as
though the Rel path "reaches only the Boolean carrier" and min-plus is a matter of lifting the
refusal; it is not. Budget C1194 as a kernel plus two formats.

Recommendation: before any C1194 code, settle two design questions. (a) Does the min-plus
relational evaluator reuse `Demand`'s plan, index and `Pages` machinery with a value column and a
re-derivation rule, or is it a second kernel? (b) What does a min-plus relational certificate
carry — value-annotated derivations, or a rank that is the round together with the value, with
leastness discharged by the closed-world pass in the carrier's order? (b) is the gate; it also
decides whether the Lean `WeightedRules.Support` argument can be reused. Size: week+.

### F4 — One error for every refusal; a caller cannot tell what was refused (S2)

`rule_contract::Error` (`crates/verify/src/rule_contract.rs:104`) is the only error type in the
subsystem. `Demand` returns exactly three of its variants: `Budget` at
`demand.rs:772` (row bound of zero), `:1648` (reservation above `MAX_WORKSPACE_BYTES`), `:1844` and
`:1869` (a relation's row capacity exhausted mid-evaluation), `:2081` (the unreachable round
guard); `Source` at `:2017` (workspace shape mismatch); `Binding` at `:2648,2674,2729`.

Consequence: "the plan's reservation is above 16 GiB" and "relation 7 filled its 16 M rows in round
12" are the same value. `ergodis-private/src/rel_stratified.rs:1761–1774` demonstrates the cost
directly: it matches `CoreError::Budget` from `workspace()` and from `evaluate_into()` and maps
both to one `Error::LayerCapacity { layer, max_rows }`, so the only advice the driver can give is
"raise `max_rows`", which is wrong advice for the reservation case. For C1195, a benchmark suite
whose refusals are all the word "Budget" cannot report a reach limit against a competitor.

Recommendation: a `Refusal { kind, relation, index, limit, observed }` record, returned inside
`Error::Budget` or beside it, produced at each of the five sites. Everything downstream — the
driver's error enum, any CLI, the suite's tables — then has one place to read what bound. Size:
days.

### F5 — There is no single budget model; four ceilings in three unrelated units, and one the caller can use to abort the checker (S2)

The table in §4 is the finding. Specifically: the evaluator's reach is governed by `MAX_ROWS`
(rows per relation) and `MAX_WORKSPACE_BYTES` (reserved bytes); the representation choices by
`MAX_DIRECT_KEYS` (keys) and `MAX_DIRECT_UNIVERSE` (tuples); the checker's by `DIRECT_LIMIT`
(`u32` entries). The evaluator's and the checker's ceilings are numerically and conceptually
unrelated, which is correct — the checker must reach its verdict whatever the producer chose — but
nothing states that, and a reader meeting `MAX_DIRECT_KEYS = 2^24` and `DIRECT_LIMIT = 2^26` in
adjacent crates has no way to know they are not meant to agree.

Two concrete sub-problems. First, the default row bound is `MAX_ROWS` itself, so *every* plan
reserves 2^24 rows per derived relation regardless of the program, and the entire scheme leans on
`Pages`' lazy commit (see F14). Second, `check_bounded` and `check_admitted_bounded`
(`derivation.rs:223,248`; `ranked.rs:227,246`) take an unbounded `direct_limit: u64` from the
caller and pass it to `Keys::new` (`datalog_store.rs:56`), which does `vec![0u32; universe as
usize]` when the universe is under it — a caller passing a large limit aborts the checker on
allocation. There is no in-tree caller that does this (only tests, with `DIRECT_LIMIT` and `0`), so
it is a hardening item rather than a live bug, but a checker is the wrong place to accept an
unvalidated allocation size.

Recommendation: one short document — or one docstring block in `demand.rs` — naming the four
budgets, their units, which are refusals and which are fallbacks, and why the checker's is
independent; clamp `direct_limit` to `DIRECT_LIMIT` at the public entry points. Size: hours for the
clamp, half a day for the budget statement.

### F6 — Two admission languages over one wire format, one schema string and one identity function (S3)

`ground` (`rule_contract.rs:478`) admits: domain ≤ 32, relations ≤ 32, arity ≤ 3, bodies of one or
two atoms, ≤ 3 variables per rule, ≤ 128 rules, either carrier, symmetries allowed. `datalog::admit`
(`datalog.rs:184`) admits: domain ≤ 65 536, relations ≤ 64, arity ≤ 4, bodies of up to four atoms,
≤ 8 variables, ≤ 1024 rules, Boolean only, symmetries refused. Both require `schema == SCHEMA ==
"finite-min-plus-rules.v1"` and both derive `source_id` from `identity_of(encode_source(program))`.

Consequence: a `Program` value does not determine which language it is in; a producer discovers the
answer by being refused, and the two refusal reasons for a three-atom body are `Error::Source` from
one door and acceptance from the other. The identity records nothing about the admission regime, so
"this certificate binds to this source" holds only relative to a checker that already knows which
door was used. The schema string names min-plus while most of the traffic through it is Boolean
Datalog. The `MAX_BODY` docstring (`datalog.rs:70–79`) states the divergence plainly and pins it
with one test, which is the right instinct and is also the only enforcement.

Recommendation: give the Datalog admission its own schema string, with the identity tag following
it exactly as the prepared path already does with `PREPARED_SCHEMA`; or keep one schema and add a
declared profile field that admission checks. Either is a format change that ripples to fixtures,
the provider descriptor and any stored certificate, so it is Tavis's call and it should be made
before C1195 freezes a suite's artifacts. Size: days.

### F7 — The checkers are invoked through the object they check, and have no test target of their own (S3)

`Demand::verify`, `Demand::verify_ranked`, `Prepared::verify`, `Prepared::verify_support` are
methods on the producer (`demand.rs:2775,2765`; `lib.rs:237,268`). `crates/verify/tests/` contains
`composition_graph.rs`, `finite_lowering_properties.rs` and `weight_properties.rs` — nothing for
`datalog`, `derivation`, `ranked` or `datalog_store`. `derivation.rs` and `ranked.rs` carry no
`#[cfg(test)]` module at all; every `Rejection::` assertion in the tree lives in
`crates/rules/tests/{demand,demand_nary,demand_prepared}.rs`, i.e. in the producer crate.

Consequence: the adversarial suite for the checkers is written against certificates the producer
can emit, so the family that has never been tried is exactly the family the producer cannot
produce — which is the family a checker exists to reject. And a consumer who takes
`ergodis-verify` alone (the crate whose docstring advertises it has no dependency on the
optimization kernels) gets Datalog checkers with no tests in their own crate.

Recommendation: move the rejection suites into `crates/verify/tests/`, driven by hand-built
certificates plus a mutation harness over one fixture certificate (flip a premise reference, a
rank, a rule index, a tuple value, a fact count, the schema, the identity). Size: days.

### F8 — About half of `Demand`'s public surface is measurement instrumentation (S3)

Public and reachable by any consumer of `ergodis-rules`: `Policy::{Direct, Sparse, SparseIndexes,
SparseMembership, AutoUndemoted}` (`demand.rs:270–293`, five of six variants, each documented as a
corner for attributing a crossover), `Demand::evaluate_counted_into` (`:2005`),
`Demand::index_lookups` (`:1724`), `Evaluation::{probes, lookups, candidates}` (`:653–686`),
`Demand::{index_plans, membership_plans}` (`:1572,1589`) with their `IndexPlan`/`MembershipPlan`
records ("for a report or a CLI"), `Demand::{policy, row_bound, workspace_bytes}`,
`pages::reservations()`, and the six policy constants `MAX_ROWS`, `MAX_DIRECT_KEYS`,
`MAX_DIRECT_UNIVERSE`, `DIRECT_INDEX_DENSITY`, `DIRECT_STATIC_PROBES`, `DEMOTE_BUCKET_ROWS`,
`MAX_WORKSPACE_BYTES`.

Confirmed consumers: `ergodis-private/examples/closure_ballpark.rs` (policy strings at 975–980,
`evaluate_counted_into` 1171, `index_lookups` 1175, `index_plans` 652, `membership_plans` 664,
`workspace_bytes` 650/1063/1129, `policy()`/`row_bound()` 648–649) and in-crate tests. The product
path `rel_stratified.rs` uses none of them — it uses `from_prepared_bounded`, `workspace`,
`evaluate_into`, `certificate`, `ranked_certificate`, `verify`, `verify_ranked`, `rows`, and must
name `Policy::Auto` only because the constructor demands a policy.

Consequence: a first outside user of `ergodis-rules` meets five addressing-policy corners and six
crossover constants before reaching the eight methods that run a program, and cannot tell which are
load-bearing. It also means the measured-crossover machinery is API that has to be kept working
across every future change.

Recommendation: split the surface. A product module with `new`, `from_prepared`, `workspace`,
`evaluate_into`, `rows`, `certificate`, `ranked_certificate`, `verify`, `verify_ranked`; and an
`instrument` module behind a non-default feature holding the policy corners, the counted entry
point, the plan reports and `reservations()`. `Policy::Auto` then stops being a parameter of the
product constructors, and the differential test in `demand_sparse.rs` builds with the feature on.
Size: days.

### F9 — Constructor and entry-point accretion, with the next knob already named (S3)

`Demand` has four constructors (`new`, `new_bounded`, `from_prepared`, `from_prepared_bounded`),
which is two sources times one optional-parameter pair. Each checker has four public entry points
(`check`, `check_bounded`, `check_admitted`, `check_admitted_bounded`), so two checks cost eight
functions. `Prepared` (grounded) sits beside `Demand` over the same wire format, and the two-atom
inline kernel sits beside the n-ary link pool inside `Step` (`demand.rs:395–432`, fields `other`,
`other_ops`, `index`, `mode`, `kind`, `other_mask` meaningful only when `link_count == 1`).

The next parameter is already named in the tree: the `DIRECT_STATIC_PROBES` docstring
(`demand.rs:131–133`) says the rule "needs the number of evaluations a plan expects, which the plan
is not told", and the C1203 successor is exactly that. On the present shape it is a third optional
parameter and, by the existing pattern, four more constructors.

What should *not* collapse: `Prepared` is not residue — it is the min-plus path used by
`crates/runtime/src/recursive.rs` and it is the only thing the C ABI exposes (§6, API surface). The
two-atom inline kernel is a measured layout decision with a size assertion behind it, not
accretion.

Recommendation: one `Demand::builder()` taking the source (wire or prepared), the row bound, the
policy and — when C1203's successor lands — the expected evaluation count, replacing the four
constructors; and one `check(source: &Source, certificate)` over `enum Source { Wire(&Program),
Admitted(&Admitted) }` with the direct limit as a builder option, replacing the eight checker entry
points. Do this before C1203's successor adds the parameter, not after. Size: days.

### F10 — Invariants carried by convention in the plan records and by bare `u32` ids in the API (S3)

Inside the plan: `Step` uses `NONE = u32::MAX` sentinels and `link_count` as the real discriminant;
`Index` documents `slots` and `slot_mask` as "unused otherwise" per kind; `RelationPlan` carries
both `bitmap` and `slots` where one excludes the other; `Link::kind` is a run constant threaded as a
plain field because "a const generic cannot reach a per-level run constant". `DemandWorkspace`
carries `source_id: Option<[u8;32]>` plus a structural `shape()` check, and between evaluations it
is legitimately in a state with `source_id: None` and dirty tables.

In the public API: relation ids, rule ids, index ids, row ids, slots and variables are all bare
`u32`/`u8` with no newtypes — `Demand::rows(&self, ws, relation: u32)`, `Demand::relation(&str) ->
Option<u32>`, `IndexPlan::relation`, and `AdmittedFact { offset, relation, index }`, three `u32`s
from three different id spaces in one twelve-byte record.

Consequence: this is the cost-of-every-change class rather than a soundness risk — the kernel's
packing is deliberate and has compile-time size assertions behind it
(`demand.rs:366,433,469`). The problem is that the same untyped ids leak out through the public
surface, where nothing forces them to.

Recommendation: keep the packed records exactly as they are; newtype the ids at the API boundary
(`RelationId`, `IndexId`, `RuleId`) so the convention region stops at the kernel. Size: days.

### F11 — `Demand::source()`'s `Option` silently selects between two different trust boundaries, and `Prepared` names two unrelated things (S3)

`Demand::source() -> Option<&Program>` (`demand.rs:1543`) is `Some` exactly for a wire plan and
`None` exactly for a prepared plan, and `verify`/`verify_ranked` branch on it to choose between
`check` (re-admits from a program) and `check_admitted` (trusts the producer's `Admitted`). Those
are not two spellings of one operation; per F1 they are two different trust boundaries. An
`Option` getter is the wrong type for that distinction, and a caller reading the signature has no
way to learn it.

Separately, `ergodis_rules::Prepared` (`lib.rs:52`) is the grounded min-plus plan, while
`datalog::PreparedSource`, `admit_prepared` and `Demand::from_prepared` are the unserialized
Datalog source form. `closure_ballpark.rs` imports both meanings into one file.

Recommendation: replace the `Option<Program>` field with `enum Source { Wire(Program),
Prepared(Admitted) }`, name the variants after the verification regime in their docs, and rename one
of the two `Prepared`s — `rule_contract::Grounded` already supplies the right word for the grounded
plan. Size: hours to a day.

### F12 — The Datalog certificates have no Lean coverage; their soundness argument lives in one docstring (S3)

`lean/WeightedRules/Support.lean` proves least-fixedness for the **grounded scalar** form:
`Program W n`, `ProductRule`, `supported_least`, `checkSupportCertificate_sound`,
`SupportedSolution.least`. No file under `lean/WeightedRules/` names a derivation or ranked
certificate; the Boolean carrier appears via `BooleanRules.lean` and the convergence bounds via
`OrderedConvergence.lean`, both about the grounded path. The argument that the trace pass gives
soundness, the closed-world pass gives local fixedness, and the two together give equality with the
least model is stated in `crates/verify/src/derivation.rs:20–24` and nowhere else in the tree.

Consequence: the programme's strongest formal claim covers the evaluator the product does not use,
and the product's certificate rests on a paragraph. That is also why F2 matters more than it
otherwise would: with no formal statement, the two checkers' agreement is the whole of the
evidence, and they share the completeness half.

Recommendation: a Lean statement of the list-form support argument over relations — well-founded
premise ranks plus local fixedness implies the least model — reusing the shape of
`WeightedRules.Support`. It is the natural companion to F3's design decision, because whatever it
takes to state it for the Boolean case is what a min-plus relational certificate must carry. Size:
week+.

### F13 — No identity ties a certificate to the plan, and `implementation_identity()` binds none of these certificates (S3)

Per §3: the only identity a `DerivationCertificate` or `RankedCertificate` carries is the source
identity. `implementation_identity()` is computed in `crates/verify/src/lib.rs`, hashes eleven
source files including all four Datalog ones, and is consumed by `src/admission.rs:327` and
`binary_composition.rs:303` — the binary-composition receipt path. Nothing in `derivation.rs` or
`ranked.rs` reads it, so no Datalog certificate records which checker source accepted it.

Consequence: two. First, an evidence bundle that pairs "this certificate" with "this policy, this
row bound, this checker revision" has no cryptographic tie between them; the pairing is whatever
the report says it is. For C1195 and C1196, which are measured rows, that is the difference between
a replayable bundle and a narrated one. Second, hashing checker sources buys provenance for the
receipt path only, and it buys it at the cost described in F15.

Recommendation: decide what a Datalog certificate should bind beyond the source — at minimum the
checker identity, since the checkers are the trust boundary; the plan fingerprint should stay out,
because the verdict must not depend on the plan. Adding a `checker: ContentId` field is a format
change, so fold it into whatever F6 or C1196 changes rather than doing it alone. Size: hours once
a format change is open.

### F14 — The workspace budget model is a Unix property; on WebAssembly it inverts (S3)

`Pages` is one anonymous `MAP_NORESERVE` mapping per structure on Unix
(`crates/rules/src/pages.rs:202–245`) and `alloc_zeroed` on every other target (`:247–275`), which
by its own docstring "commits its whole reservation up front, as `vec![0u32; n]` does". Every
budget decision above it assumes the lazy shape: the default row bound of 2^24 per derived
relation, `MAX_WORKSPACE_BYTES = 2^34` (16 GiB, larger than the entire wasm32 address space), and
`RESET_FILL_BYTES_PER_ROW`'s rule that a fresh workspace's reset "touches nothing at all".

Consequence: at its own defaults `ergodis-rules` is not usable under wasm32 — a single derived
binary relation would commit its full reservation, and the reservation cap cannot even be
represented. Nobody has hit this because the private parity harness cannot depend on
`ergodis-verify` (the ADR 0004 deviation, sibling reviewer's half), so `ergodis-rules` is not built
for WASM today. **Inferred**: I did not attempt a wasm32 build.

Recommendation: if WASM is a target for the Datalog path, the row bound must become a
caller-supplied figure with a platform-aware default and `MAX_WORKSPACE_BYTES` must be
`usize`-relative; if it is not a target, say so in `pages.rs` and stop carrying the `alloc_zeroed`
branch as though it were a supported deployment. Size: hours to decide, days to implement.

### F15 — `ergodis-verify` is two crates in one, and `implementation_identity()` pays for it (S3)

`crates/verify/src/lib.rs` opens with "This package deliberately has no dependency on Ergodis's
optimization kernels. A verified capability is minted only by replaying its fixed, complete finite
checker." But `datalog.rs` holds `PreparedSource`, `PreparedRelation`, `PreparedAtom`,
`PreparedRule`, `Slot`, `AtomRef`, `Admitted` and both admission functions — producer input types
and producer input processing — and `rule_contract.rs` holds the whole wire format. `ergodis-rules`
imports them (`demand.rs:73–78`), as does `ergodis-private/src/rel_stratified.rs:73`.

Consequence: `implementation_identity()` hashes `datalog.rs` and `rule_contract.rs`, so adding a
field to `PreparedSource` for a producer's convenience changes the identity under which
`src/admission.rs::checker_identity` mints binary-composition receipts — a subsystem with no
relation to Datalog. The producer-facing contract and the checker implementation are pinned to one
digest. This is the one dependency arrow in my half that exists for an incidental reason: the
contract types are in the checker crate because the checker also needs them, not because they are
checker code.

Recommendation: split `ergodis-contract` holding `rule_contract`'s wire types, `datalog`'s admitted
types and both admission functions; leave `ergodis-verify` with the checkers, the stores and an
identity over checker source only. It is a mechanical move, but it changes
`implementation_identity()`, which invalidates existing receipts and is therefore a validation-gate
change and Tavis's call. Size: days.

### F16 — The Datalog subsystem has no ABI and no serialization of its own (S3)

`crates/rules/src/provider.rs` exposes `Prepared` only: `PREPARE` decodes a wire `Program` and
calls `Prepared::new`; selectors 1–4 are evaluate, verify, support, verify-support over the
grounded scalar certificates. The descriptor string advertises
`"schema":"finite-min-plus-rules.v1"` with the two semirings' scalar and support certificate
formats. `Demand`, `DerivationCertificate` and `RankedCertificate` appear nowhere in it, and the
only decoders they have are `decode_derivation_certificate` and `decode_ranked_certificate`, two
`serde_json::from_slice` calls with no byte bound.

Consequence: the Lean oracle, the C ABI and the WASM module — the three surfaces an external
compiler would actually target — reach the grounded min-plus path and not the Datalog path, while
the Datalog path is where the measured speed and the product work are. Combined with F1 (route B
has no serialization at all), the subsystem with the results has the least external surface.

Recommendation: this is a sequencing question rather than a code change. If an external compiler is
to target the Datalog path, F1's `encode_prepared`/`decode_prepared` is the prerequisite and a
provider selector pair (`evaluate-datalog`, `verify-derivation`) is the follow-on; if the near-term
consumer is only `ergodis-private`, record that the ABI is deliberately grounded-only so the gap is
not rediscovered. Size: days after F1.

### F17 — Unbounded certificate decoding (S4)

`decode_derivation_certificate` (`derivation.rs:471`) and `decode_ranked_certificate`
(`ranked.rs:357`) call `serde_json::from_slice` with no length check, unlike
`rule_contract::decode_program` and `decode_certificate`, which both refuse above `MAX_BYTES`
first. Consequence: the two newest formats are the two without an input bound, which is a small
inconsistency now and the wrong default if these ever read untrusted bytes. Recommendation: apply a
bound; it need not be `MAX_BYTES`, since a derivation trace is legitimately larger than a program.
Size: hours.

## 6. Answers to the card's questions, for this half

**Ownership.** The core/private split is principled for this half: contract, evaluator and checkers
are in core; policy, layering and measurement harnesses are private. Two arrows are incidental.
(a) `ergodis-rules` → `ergodis-verify` for `datalog`'s producer input types, which is F15 — the
arrow itself is unavoidable, its target crate is wrong. (b) `ergodis-rules` → `ergodis-modules`
exists only for `provider.rs`'s C ABI vocabulary (confirmed: the crate is imported at
`crates/rules/src/provider.rs:10` and `crates/rules/tests/provider_properties.rs:12`, nowhere
else), which serves the grounded path; a crate split along F8's product/instrument line would also
isolate it. Everything else points the right way, and notably `verify` does not depend on `rules`.

**Contracts.** §2 is the table. The ones written down only in prose: the two-language divergence
(one docstring plus one test), the premise-slot-is-body-position convention (docstrings on
`Step::position` and `Link::position`), the canonical variable numbering the prepared path requires
of its caller (enforced, but the *reason* is a docstring), the soundness-plus-completeness argument
(F12), and the claim of checker independence (F2). None of these is in a dated report only — the
docstrings are the primary record, which is the right place; the gap is that several have no
enforcement beyond a single test.

**Types.** Illegal states are representable in three ways: sentinel-and-discriminant in `Step`,
`Index` and `RelationPlan` (F10); `Option<Program>` as a mode flag that selects a trust boundary
(F11); and bare `u32` ids across the public API (F10). `Policy` doubles as a measurement hook and a
test hook (F8), and it is on the product call path because every bounded constructor takes it. The
`COUNT` const-generic instantiation is the one case where the instrumentation is done right — it is
compiled out, the production kernel carries neither counter nor register, and the docstring is
precise about it; the problem is the public entry point it needs, not the mechanism. The `Prepared`
name clash is real and is in F11.

**Trust boundary.** For an accepted certificate to mean the answer is right, one must trust: the
source the checker was handed is the program one meant (on route B, *and* that the producer's
in-memory `Admitted` is that program — F1); `datalog::admit` or `admit_prepared`, which producer
and checker share; `datalog_store`'s `Keys`/`RelationStore`/`JoinIndexes`; `derivation::unify`,
`head_matches`, `head_key` and `closed_world`; and the argument that soundness plus local fixedness
gives the least model, which is unformalized (F12). Not trusted, correctly: the plan, the index
kinds, the demotion decisions, the `Pages` workspace, the row and witness columns, the work order.
`check_admitted` weakens the boundary relative to the wire path by exactly one step — it removes
the re-admission, which is the only place the checker independently derives the source identity.
The closed-world pass establishes that the certified relations are closed under every rule, i.e. a
model; together with per-tuple derivability it gives equality with the least model, so completeness
and soundness are both covered — but by two passes of which the completeness one is shared between
the two checkers (F2). Aggregates, complements and filter relations are outside the core contract
entirely; see §7.

**Identity.** Five exist (§3): wire source identity, the `FactStream` re-hash of it, the prepared
source identity, `implementation_identity()`, and the private per-layer tuple digests. No plan
fingerprint exists. The pairs that could disagree are handled: the `FactStream` shortcut fails
closed, and the prepared tag cannot collide with the wire tag. The real gaps are that nothing binds
a checker identity to a Datalog certificate (F13) and that the prepared identity has exactly one
implementation and no serialization (F1). Hashing checker sources blocks a checker edit from being
invisible in a binary-composition receipt — and blocks nothing at all for Datalog, while making
every producer-facing type change in `datalog.rs` a receipt-invalidating event (F15).

**Limits and refusals.** No, there is not one model: §4 lists four ceilings in three units plus the
checker's independent one, and the error taxonomy collapses five distinct causes into
`Error::Budget` (F4, F5). There is no single place a caller learns what was refused; the private
driver's `LayerCapacity` is the evidence.

**Extension pressure.** C1194 needs a new kernel and new formats, not an extension (F3). C1196's
rank-run and round-block encodings meet two `serde` structs whose checkers index their `Vec<u32>`
fields directly, so a compact encoding needs either a decode-to-struct step (no in-memory saving)
or a checker rewrite; `premise_stride`'s floor of two is baked into the flat premise vector and
into the producer's `emit`. The C1203 successor (a plan told its expected evaluation count) adds a
fourth plan parameter to a four-constructor type (F9). A cost-based planner would need relation
cardinality estimates; `estimate_probes` and `fan_out` are private methods with no seam, which is
fine now and is the place to open one. Incremental evaluation exists on the grounded path
(`Prepared::update_into`, `with_fact`) and has **no** counterpart on the demand path — the
workspace reset is total — which is worth knowing before anyone assumes the Datalog path inherits
it. WASM is F14.

**Accretion.** F9 names what should collapse (four constructors, eight checker entry points) and
what should not (`Prepared`, the two-atom inline kernel). The binarization-versus-n-ary question is
now settled in core's favour — `MAX_BODY` is four and the n-ary kernel exists — so the residue is
on the lowering side, which is the sibling reviewer's.

**Boolean path versus generic carrier.** `Demand` is a **parallel implementation**, not an instance
(F3): it never mentions `TransitionWeight`, the trait is sealed, and the set semantics of its row
store and both its certificate formats are incompatible with a carrier that improves values. The
generic carrier work (C1172–C1177, `weight.rs`, `OrderedConvergence`) serves `Prepared` and
`composition_graph`. For C1194 that is the central fact.

**API surface.** What should not be public: the five non-`Auto` `Policy` variants, the counted
entry point, `index_lookups`, `IndexPlan`/`MembershipPlan`, `reservations()` and the six crossover
constants (F8). What a first outside user has to understand, in order: `Program` and which of the
two admission languages they are writing for (F6); that `Demand::new` takes a wire program and
`from_prepared` does not and that these differ in what verification means (F11, F1); that the
workspace is plan-bound and worker-owned; that `Error::Budget` covers five things (F4); and that
`verify` is a method on the producer (F7). That is a lot of doorway for eight useful methods.

## 7. For the private-half reviewer and the synthesis

1. **Route B is the only product route, and it has no wire form.** Every finding in F1 lands on
   `rel_stratified.rs`. The question for the private half: does anything serialize the per-layer
   prepared source, or is the layer certificate discarded after `demand.verify()` returns? If it is
   kept, what is it kept as?
2. **`Error::CheckersDisagree` is weaker corroboration than it reads.** Per F2 the two checkers
   share admission, the store, the unification primitives and the whole closed-world pass. Please
   check whether any private report or ADR describes them as independent, and flag it for the
   synthesis if so.
3. **Digest-checked records are a re-run, not an independent check.** `rel_stratified.rs` computes
   complement, filter and aggregate facts and re-checks them by recomputing `digest_of` over the
   rebuilt tuples (`:955, 1021, 1049, 1093, 1428, 1515, 1605`). That catches a corrupted record; it
   does not catch a wrong rule for building the record, because the same code builds and rebuilds.
   The core contract covers none of it. How much of a layer's output is outside the certificate is
   the private half's number to produce, and it belongs in the synthesis beside F2 and F12.
4. **Budget reporting.** `Error::LayerCapacity { layer, max_rows }` is downstream of F4; if the
   private half wants better refusals, F4 is the core change it depends on.
5. **`Policy::Auto` on the product path.** `rel_stratified.rs:1756` names it only because
   `from_prepared_bounded` demands a policy. If F8's split happens, that call site changes.
6. **ADR 0004's harness constraint.** The stated reason the lowering backend sits in
   `src/rel_lowering.rs` — that the parity harness cannot depend on `ergodis-verify` — is also why
   nobody has met F14 (`Pages` under WASM). Worth checking whether the constraint is still live.

## 8. Unexplained

1. **Why `DIRECT_LIMIT` (checker, 2^26 `u32` entries) and `MAX_DIRECT_KEYS` (evaluator, 2^24 keys)
   differ.** Both are "the largest direct array we will allocate", they differ by a factor of four,
   and neither docstring mentions the other. They may simply be independently chosen, which is
   defensible — but a reader cannot tell that from the source, and nothing in the tree says it.
2. **Why `MAX_WORKSPACE_BYTES` is 2^34.** The docstring explains what it bounds and that it is
   address space, not why 16 GiB. This is a constant's value, which the card puts out of scope, so I
   raise it only because it is the one budget with no derivation at all and it is the one a caller
   will hit first.
3. **What `fact_count` means to a consumer on route B.** On the wire path it is
   `Program::facts.len()` including duplicates and absent facts, which makes premise references
   stable against a producer that emits the same program twice. On the prepared path it is the
   deduplicated present count, so the same reference number denotes a different fact depending on
   which door the source came through. This is consistent within each route and the identity keeps
   them apart, so it is not a defect — but the `DerivationCertificate::fact_count` docstring says
   "`Program::facts.len()` of the bound source", which is wrong for route B.
