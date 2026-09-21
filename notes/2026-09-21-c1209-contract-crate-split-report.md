# C1209 — contract crate split: report

**Lane**: `ergodis`
**Date**: 2026-09-21

## Design step: the cut

Read-only inventory over `~/src/ergodis/crates/verify/` (all of `src/`, `Cargo.toml`, `tests/`),
every core importer, `~/src/ergodis-private`, the core documents, guard scripts and the evidence
generator. Nothing was edited and nothing was built; the present implementation identity was
recomputed offline from the file bytes rather than by running a test.

### 1. Item-level cut

`ergodis-contract` mirrors the file names of the modules it takes, so every move is reviewable as a
move and each crate's hashed list is the listing of its own `src/`. Neither crate has a `src/`
subdirectory, so a completeness test over `src/*.rs` is exact.

#### `ergodis-contract`

| Item | Source file | Destination | Visibility change |
|-------------------------------------------------------|----------------------|--------------------------------|-------------------|
| `sealed::Sealed`, `Stability`, `WeightProperties`, `TransitionWeight`, `BoundedMinPlus`, `Boolean`, both impls, size assertions | `weight.rs` (whole file) | `contract::weight` | none |
| `semi_naive_product` | `weight.rs` | `contract::weight` | none (see knot 2) |
| `SCHEMA`, `CERTIFICATE_SCHEMA`, `BOOLEAN_CERTIFICATE_SCHEMA`, `MAX_BYTES`, `MAX_SCALARS`, `MAX_PRODUCTS`, `MAX_WORK` | `rule_contract.rs` | `contract::rule_contract` | none |
| `Relation`, `Term`, `Atom`, `Rule`, `Fact`, `Program`, `Certificate` | `rule_contract.rs` | `contract::rule_contract` | none |
| `Error` (all twelve variants, Display strings verbatim) | `rule_contract.rs` | `contract::rule_contract` | none |
| `Carrier` and its six methods | `rule_contract.rs` | `contract::rule_contract` | none |
| `WireValue` + `impl WireValue for BoundedMinPlus/Boolean`, `decode_values` | `rule_contract.rs` | `contract::rule_contract` | none |
| `check_invariance` | `rule_contract.rs` | `contract::rule_contract` | **private → `pub`** |
| `FactStream` (+ `Debug` impl, `FACTS_FIELD`) | `rule_contract.rs` | `contract::rule_contract` | none (stays private) |
| `Grounded` + all accessors + `rebind` | `rule_contract.rs` | `contract::rule_contract` | none |
| `round_bound`, `identifier`, `is_identifier`, `atom_index`, `ground` | `rule_contract.rs` | `contract::rule_contract` | none (`is_identifier` stays `pub(crate)`; its only caller, `datalog`, moves with it) |
| `decode_program`, `decode_certificate`, `decode_support_certificate` | `rule_contract.rs` | `contract::rule_contract` | none |
| `encode_source`, `identity_of` | `rule_contract.rs` | `contract::rule_contract` | none |
| `parse_rules` (and its inner `atom`) | `rule_contract.rs` | `contract::rule_contract` | none |
| Everything: `MAX_DOMAIN`/`MAX_ARITY`/`MAX_VARIABLES`/`MAX_RELATIONS`/`MAX_RULES`/`MAX_BODY`, `universe`, `Slot`, `AtomRef`, `AdmittedRule`, `AdmittedRelation`, `AdmittedFact`, `Admitted` (+`pack`, `tuple`), `admit`, `PREPARED_SCHEMA`, `PreparedRelation/Atom/Rule/Source`, `Streaming`, `admit_prepared`, the `#[cfg(test)]` module | `datalog.rs` (whole file) | `contract::datalog` | none |
| `ProductRule` (+ `new`, size assertion), `Limits`, `Error` (six variants, Display strings verbatim) | `composition_graph.rs` | `contract::composition_graph` | none |
| `SUPPORT_SCHEMA`, `BOOLEAN_SUPPORT_SCHEMA`, `SupportCertificate` | `support.rs` | `contract::support` | none |
| `derive`, `UNRANKED` | `support.rs` | `contract::support` | none (see knot 3) |
| `DERIVATION_SCHEMA`, `premise_stride`, `DerivationCertificate`, `Rejection`, `impl From<Rejection> for Error`, `decode_derivation_certificate` | `derivation.rs` | `contract::derivation` | none |
| `RANKED_SCHEMA`, `RankedRelation`, `RankedCertificate`, `Rejection`, `impl From<Rejection> for Error`, `decode_ranked_certificate` | `ranked.rs` | `contract::ranked` | none |
| new `implementation_identity()` over the contract's own `src/*.rs`, domain string `ergodis/finite-rule-contract/v1`, returning `[u8; 32]` | — | `contract::lib` | new item |

#### `ergodis-verify` after the split

| Item | Source file | Destination | Visibility change |
|---------------------------------------------|-------------------------|-----------------------------|-------------------|
| `VerifiedGraph`, `copy`, `verify`, `propagate` | `composition_graph.rs` | stays (`verify::composition_graph`) | none |
| `check`, `Rejection`, the two `#[cfg(test)]` support tests | `support.rs` | stays (`verify::support`) | none; tests import `contract::support::derive` |
| `Verified`, `replay`, `verify`, `support_check`, `verify_support` (lines 656–765 of `rule_contract.rs`) | `rule_contract.rs` | **new `verify::grounded`** | none; must read `Grounded` through the existing public accessors instead of its private fields |
| `unify`, `head_tuple`, `head_matches`, `head_key`, `fixed_mask`, `mark_bound`, `closed_world`, `declared`, `ABSENT`, `Relations`, `check`, `check_bounded`, `check_admitted`, `check_admitted_bounded` | `derivation.rs` | stays | none (`pub(crate)` helpers keep their consumers in-crate) |
| `Store`, `head_bound`, `visit_order`, `needed_indexes`, `justified`, the four `check*` entry points | `ranked.rs` | stays | none |
| Whole file (`RelationStore`, `Rows`, `JoinIndexes`, `atom_key`, `DIRECT_LIMIT`, `MASKS`) | `datalog_store.rs` | stays, still a private module | none |
| Whole files | `binary_composition.rs`, `min_plus_transition.rs`, `finite_lowering.rs` | stay | none |
| `ContentId`, `DIRECT_LIMIT` re-export, `implementation_identity()` rebuilt over the checker sources including `support.rs` and `grounded.rs` | `lib.rs` | stays | none |

**The exhaustive list of forced visibility widenings is one item: `rule_contract::check_invariance`
becomes `pub`.** Nothing else in the split crosses a private boundary. In particular `Grounded`'s
six private fields need no widening: `replay`, `support_check`, `verify` and `verify_support` read
them as fields today (`grounded.inputs`, `grounded.products`, `grounded.source_id`) and must be
rewritten to call `inputs()`, `products()`, `source_id()` and `round_bound()`, all of which are
already `pub`. That rewrite is mechanical and adds no API surface.

#### Where the planned cut fails, and the correction

1. **`Error::Derivation` and `Error::Ranked` carry payloads the planned cut left in the checker
   crate.** `rule_contract::Error` has `Derivation(crate::derivation::Rejection)` and
   `Ranked(crate::ranked::Rejection)`. `Error` is contract, so contract must name both enums, and
   they must move. Correction: `derivation::Rejection` and `ranked::Rejection` move to
   `contract::derivation` and `contract::ranked` beside their certificate structs, with their
   `impl From<Rejection> for Error` (both types are then contract-local, so the orphan rule is
   satisfied and the `{0:?}` Debug renderings are unchanged). Neither the ADR nor the planned cut
   named these. `support::Rejection` is *not* dragged along, because `Error::Support` is a unit
   variant, so it stays in the checker crate with `support::check`.
2. **`decode_derivation_certificate` and `decode_ranked_certificate` were unplaced.** They return
   `Result<_, contract::Error>` and are the decode half of the wire format, exactly like
   `decode_program`. They move to contract with their certificate structs.
3. **`premise_stride` and `Relations` split apart.** `premise_stride` defines the certificate's
   premise-block width and is read by the producer (`crates/rules/src/demand.rs:2699`), the two
   checkers and the private example; it is contract. `Relations` is the checkers' return type and
   stays in verify. `crates/rules/src/demand.rs` therefore imports `derivation` items from both
   crates; it must use explicit item imports rather than `use ...::derivation::{self, ...}`, since
   the two module names are identical.
4. **The planned cut's "`support::{derive?, check, Rejection}` stays in verify" is wrong for
   `derive`.** See knot 3 below: `derive` is a producer with no checker caller.
5. **`Limits` was left ambiguous.** Strictly, contract does not need it once `replay` moves to
   verify. Recommended anyway: move it, because it is a declared admission budget and the ADR puts
   budgets in the contract, and because moving all three plain types leaves verify's
   `composition_graph.rs` as nothing but the replay kernel. See knot 1.
6. **Everything else in the planned cut holds.** `weight.rs` moves whole and unmodified; all of
   `datalog.rs` moves including its test module (its tests use only contract items:
   `parse_rules`, `Fact`, `Relation`, `Rule`, `ground`); the scalar `Certificate`, `Carrier`,
   `WireValue`, `decode_values`, `FactStream`, `Grounded`, `ground`, `round_bound`, the identifier
   helpers, the decoders, `encode_source`, `identity_of` and `parse_rules` are contract as planned.

#### The ADR's three open questions, answered

- **Grounded admission and the scalar certificate against the replay checker.** `ground`,
  `Grounded` (with `rebind`, `FactStream` and `round_bound`), `Certificate` and `check_invariance`
  are contract. `Verified`, `replay`, `verify`, `support_check` and `verify_support` are the
  checker and move to a new `verify::grounded` module. The seam is exactly `check_invariance`
  (contract, now `pub`, called by both checker entry points) and the `Grounded` accessors. Nothing
  in the grounding needs a checker type once `ProductRule` moves.
- **Are the certificate structs contract?** Yes, all of them, with their schema constants and
  decoders: `Certificate` and its two schema strings, `support::SupportCertificate` with
  `SUPPORT_SCHEMA`/`BOOLEAN_SUPPORT_SCHEMA`, `DerivationCertificate` with `DERIVATION_SCHEMA` and
  `premise_stride`, `RankedCertificate` + `RankedRelation` with `RANKED_SCHEMA`. The contract's own
  error type independently forces `derivation::Rejection` and `ranked::Rejection` across with them,
  so the rejection vocabularies are contract too.
- **Is the sealed carrier trait contract?** Yes. `weight.rs` moves whole and unaltered, private
  `sealed` module included. Every implementation of `TransitionWeight` and of `WireValue` lives in
  the two files that move (`weight.rs`, `rule_contract.rs`), and the only other `Sealed` trait in
  either repository is an unrelated one in the root crate's `src/field.rs`. The seal is therefore
  unchanged, not weakened: `sealed::Sealed` stays private to the contract crate, so no downstream
  crate can add a carrier.

#### The three knots

**Knot 1 — `Error::Replay(#[from] composition_graph::Error)` and `Grounded.products:
Arc<[ProductRule]>`.** `ProductRule` must move: it is a field of `Grounded`, the return type of the
public `Grounded::products()`, constructed by `ground`, and named by the producer
`crates/rules/src/frontier.rs`. The graph `Error` must move: it is the payload of a contract error
variant. Smallest possible move is `{ProductRule, Error}`; recommended move is
`{ProductRule, Limits, Error}` into a contract module named `composition_graph`, so that an
importer of those three changes only the crate name in its path. Verify's `composition_graph` then
holds `VerifiedGraph`, `verify`, `propagate` and `copy` and imports the three types by name — not
by `pub use`, which would be the re-export the ADR ruled out. Both enums keep their variants,
`#[derive]` list and `#[error("…")]` strings byte for byte, so `Display` output and the
`Replay(…)` rendering are unchanged. `ProductRule`'s private `reserved` field and public
`const fn new` are unchanged, and nothing anywhere constructs it by struct literal.

**Knot 2 — `weight::semi_naive_product`.** Its only non-test caller in either repository is
`composition_graph::propagate`; the other two callers are verify's own tests,
`tests/weight_properties.rs` and `tests/composition_graph.rs`, which use it to state the semi-naive
identity as a *law of the carrier*. `crates/rules`, `crates/runtime`, the root crate and
`ergodis-private` never name it. Recommendation: **leave it in `weight.rs` and let it move to
contract with the file.** It is generic, so it is monomorphized in whichever crate calls it and its
inlining is unaffected either way; leaving it makes `weight.rs` a byte-for-byte file move, which is
the cheapest and most auditable form the "pure move" gate can take; and the law tests stay where
the law is stated. If the layering bothers you later, moving it to `verify::composition_graph` is a
zero-risk follow-up that touches three files.

**Knot 3 — `support::derive`.** Callers: `crates/rules/src/lib.rs:245` (the certificate producer,
through `derive_support`) and the two tests inside `support.rs`. No checker calls it.
Recommendation: **move `derive` and its private `UNRANKED` constant to `contract::support`.** The
split is clean — `check` does not use `UNRANKED`, and `derive` needs only `ProductRule` and
`TransitionWeight`, both contract. The reason is the point of the task: ADR decision 3 puts every
checker source under the checker identity, so leaving a producer in `support.rs` means a
producer-side edit still moves the checker identity. The two existing tests exercise `derive` and
`check` together and stay in verify's `support.rs`, importing `contract::support::derive` (verify
has contract as a normal dependency, so no dev-dependency is added).

**Knot 4 — the other checker modules.** `derivation.rs`, `ranked.rs`, `datalog_store.rs`,
`binary_composition.rs`, `min_plus_transition.rs` and `finite_lowering.rs` were checked for items
that contract needs or that need non-public contract items. Results: `min_plus_transition` imports
only `weight::{BoundedMinPlus, TransitionWeight}` (public, contract); `finite_lowering` imports
nothing from the crate; `binary_composition` imports only `crate::{implementation_identity,
ContentId}` (both stay in verify); `datalog_store` imports `datalog::{Admitted, AtomRef, Slot,
MAX_ARITY}` (all public, contract) and stays a private module whose `pub(crate)` items keep all
their consumers in verify; `derivation`'s seven `pub(crate)` helpers are consumed only by
`derivation` and `ranked`, both of which stay. Nothing in contract needs an item from any of these
six files except the two `Rejection` enums already handled.

**Knot 5 — `ContentId`.** The alias is used by `binary_composition.rs` and by the root crate's
`src/admission.rs`; no contract source names it, since the contract spells its identities
`[u8; 32]` literally everywhere. Recommendation: **leave `ContentId` in `verify::lib`** and have
`contract::implementation_identity()` return `[u8; 32]`. Moving the alias to contract would put a
contract dependency on the root crate for a transparent alias and buy nothing; duplicating it in
both crates would give two names for one type.

### 2. Dependency graph and Cargo wiring

Intra-workspace edges after the split (normal dependencies; `→` is "depends on"):

```
ergodis-contract        → (no workspace member)
ergodis-verify          → ergodis-contract
ergodis-modules         → (no workspace member)
ergodis-rules           → ergodis-contract, ergodis-verify, ergodis-modules
ergodis (root)          → ergodis-verify
ergodis-runtime         → ergodis, ergodis-verify, ergodis-rules, ergodis-contract
ergodis-repository-native → ergodis-runtime
ergodis-wasm (excluded) → ergodis-runtime
ergodis-private         → ergodis, ergodis-verify, ergodis-rules, ergodis-contract
tasks/*                 → ergodis, ergodis-private, (tools also ergodis-rules, ergodis-verify)
```

**No cycle.** `ergodis-contract` has zero outgoing workspace edges: its dependencies are the four
external crates only. It is therefore a sink in the intra-workspace graph, and adding a vertex of
out-degree zero to an acyclic graph cannot create a cycle, because every cycle through a vertex
uses an outgoing edge from it. The rest of the graph is unchanged, and it is acyclic today. The one
back edge in the workspace, verify's `[dev-dependencies] ergodis = { path = "../.." }`, is
unchanged and remains dev-only, binding test targets and never the library. `ergodis-contract` must
acquire no dev-dependency on `ergodis` or `ergodis-verify`; its in-crate tests (the `datalog`
module's) use only contract items, so it needs none.

The root crate does **not** gain a contract dependency: its only verify usages are
`binary_composition`, `finite_lowering`, `ContentId` and `implementation_identity`, all of which
stay in verify.

**`crates/contract/Cargo.toml` dependencies**, all four required:

| Crate | Why |
|--------------|---------------------------------------------------------------|
| `serde` (derive) | every wire struct: `Program`, `Certificate`, `SupportCertificate`, `DerivationCertificate`, `RankedCertificate`, `RankedRelation` and their components |
| `serde_json` | `encode_source`, all five decoders, `FactStream::new`/`identity`, `Grounded::rebind` |
| `sha2` | `identity_of`, `FactStream`, `datalog::Streaming`, `implementation_identity` |
| `thiserror` | `rule_contract::Error`, `composition_graph::Error` |

**No verify dependency becomes unused.** `serde` is still needed by `binary_composition` and
`finite_lowering`; `serde_json` by `binary_composition::from_json` and its `VerificationError::Json`
variant; `sha2` by `lib.rs`, `binary_composition`, `min_plus_transition` and `finite_lowering`;
`thiserror` by `binary_composition::VerificationError`, `finite_lowering::Error` and
`min_plus_transition`'s error type. Verify gains exactly one dependency, `ergodis-contract`.

Workspace file changes: `members` and `default-members` in the root `Cargo.toml` gain
`crates/contract`; `crates/verify`, `crates/rules`, `crates/runtime` gain the dependency line;
`Cargo.lock` gains a package.

### 3. Importer inventory

#### Core — Rust, with the paths each file uses

`ergodis_verify::` occurrences per file, split by destination crate. "C" = moves to
`ergodis_contract`, "V" = stays `ergodis_verify`.

| File | C | V | Paths |
|-----------------------------------------------|---|---|--------------------------------------------------------------|
| `crates/rules/src/lib.rs` | 3 | 1 | C `rule_contract::{self, Atom, Carrier, Certificate, Error, Fact, Grounded, Program, Relation, Rule, Term, WireValue}`, `support::SupportCertificate`, `support::derive`, `weight::{Boolean, BoundedMinPlus, Stability, TransitionWeight}`; V `rule_contract::verify`, `rule_contract::verify_support` → `grounded::{verify, verify_support}` |
| `crates/rules/src/demand.rs` | 4 | 2 | C `datalog::{self, Admitted, AtomRef, PreparedSource, Slot, MAX_ARITY, MAX_BODY, MAX_VARIABLES}`, `derivation::{DerivationCertificate, premise_stride, DERIVATION_SCHEMA}`, `ranked::{RankedCertificate, RankedRelation, RANKED_SCHEMA}`, `rule_contract::{Error, Program}`; V `derivation::{check, check_admitted, Relations}`, `ranked::{check, check_admitted}` |
| `crates/rules/src/frontier.rs` | 1 | 0 | C `composition_graph::ProductRule` |
| `crates/rules/src/pages.rs` | 1 | 0 | C `rule_contract::Error` |
| `crates/rules/src/provider.rs` | 1 | 0 | C `rule_contract::{decode_certificate, decode_program, decode_support_certificate, MAX_BYTES}` |
| `crates/rules/tests/allocation.rs` | 11 | 0 | C `rule_contract` (10), `datalog` |
| `crates/rules/tests/demand_nary.rs` | 4 | 0 | C `datalog`, `derivation`, `ranked`, `rule_contract` |
| `crates/rules/tests/demand.rs` | 3 | 0 | C `derivation`, `ranked`, `rule_contract` |
| `crates/rules/tests/demand_prepared.rs` | 3 | 0 | C `datalog`, `derivation`, `rule_contract` |
| `crates/rules/tests/demand_sparse.rs` | 3 | 0 | C `datalog` (2), `rule_contract` |
| `crates/rules/tests/contract_properties.rs` | 3 | 0 | C `composition_graph`, `rule_contract`, `weight` |
| `crates/rules/tests/properties.rs` | 3 | 0 | C `composition_graph`, `rule_contract`, `weight` |
| `crates/rules/tests/support/density.rs` | 3 | 0 | C `composition_graph`, `rule_contract` (2) |
| `crates/rules/tests/support.rs` | 2 | 0 | C `rule_contract`, `support` |
| `crates/rules/tests/boolean.rs` | 2 | 0 | C `rule_contract`, `support` |
| `crates/rules/tests/contracts.rs` | 1 | 0 | C `rule_contract::{self, Carrier, Certificate, Program, Verified}` — note `Verified` is V (`grounded::Verified`) |
| `crates/rules/tests/density_control.rs` | 1 | 0 | C `rule_contract` |
| `crates/rules/tests/grammar_properties.rs` | 1 | 0 | C `rule_contract` |
| `crates/rules/tests/incremental.rs` | 1 | 0 | C `rule_contract` |
| `crates/rules/tests/provider_properties.rs` | 1 | 0 | C `rule_contract` |
| `crates/rules/tests/workspace_commit.rs` | 1 | 0 | C `rule_contract` |
| `crates/rules/examples/replay_profile.rs` | 1 | 0 | C `rule_contract` |
| `crates/rules/examples/lean_boundary_fixtures.rs` | 1 | 0 | C `rule_contract` |
| `crates/runtime/src/recursive.rs` | 3 | 0 | C `composition_graph`, `rule_contract`, `weight` |
| `crates/runtime/src/lineage.rs` | 1 | 0 | C `rule_contract` |
| `crates/runtime/src/bundle_workflow.rs` | 0 | 1 | V `min_plus_transition` |
| `crates/runtime/tests/update_cost.rs` | 2 | 0 | C `rule_contract`, `weight` |
| `crates/runtime/tests/update_properties.rs` | 1 | 0 | C `rule_contract` |
| `crates/verify/tests/composition_graph.rs` | 2 | 1 | C `weight::{semi_naive_product, Boolean, BoundedMinPlus, Stability, TransitionWeight}`, `composition_graph::{Error, Limits, ProductRule}`; V `composition_graph::{verify, VerifiedGraph}` |
| `crates/verify/tests/weight_properties.rs` | 1 | 0 | C `weight` |
| `crates/verify/tests/finite_lowering_properties.rs` | 0 | 1 | V `finite_lowering` |
| `src/admission.rs` | 0 | 3 | V `binary_composition`, `ContentId`, `implementation_identity` |
| `src/finite_lowering.rs` | 0 | 1 | V `finite_lowering` |
| `tests/verifier_boundary.rs` | 0 | 1 | V `binary_composition` |
| `tests/finite_lowering.rs` | 0 | 1 | V `finite_lowering` |

Core files that reference nothing in verify: `crates/modules/**`, `crates/repository-native/**`,
`benches/**`, `wasm/**`, all of `python/**`, and the rest of the root `src/`.

**Core `Cargo.toml` files needing the new dependency:** `crates/verify`, `crates/rules`,
`crates/runtime`. The root `Cargo.toml` needs the workspace `members`/`default-members` entries but
no dependency. `wasm/Cargo.toml` needs nothing.

#### `~/src/ergodis-private`

| File | C | V | Paths |
|-------------------------------------------------|---|---|-------------------------------------------------------------|
| `src/rel_lowering.rs` | 1 | 0 | C `rule_contract::{Atom, Fact, Program, Relation, Rule, Term, SCHEMA}` |
| `src/rel_stratified.rs` | 2 | 0 | C `datalog::{PreparedAtom, PreparedRelation, PreparedRule, PreparedSource, Slot}`, `rule_contract::Error` |
| `src/datalog_certificate_codecs.rs` | 2 | 0 | C `ranked::RankedRelation` (plus a docstring naming `ranked::RankedCertificate`) |
| `src/privacy_lowering.rs` | 0 | 1 | V `finite_lowering::Model` |
| `src/lrc_transition_verification.rs` | 0 | 1 | V `min_plus_transition::{…}` |
| `src/rel_frontend/lower.rs` | — | — | docstring only, names `ergodis_verify::rule_contract` |
| `examples/closure_ballpark.rs` | 4 | 0 | C `rule_contract::{self as contract, Fact, Program, Relation, SCHEMA}`, `derivation::DerivationCertificate`, `derivation::premise_stride`, `ranked::RankedCertificate` |
| `tests/rel_lowering.rs` | 6 | 0 | C `datalog::{MAX_ARITY, MAX_VARIABLES, MAX_RELATIONS, MAX_RULES, MAX_BODY, MAX_DOMAIN}` |
| `tests/datalog_certificate_codecs.rs` | 1 | 0 | C `ranked::RankedRelation` |
| `tests/independent_summary_transition.rs` | 0 | 1 | V `min_plus_transition::{verify_snapshot, TransitionVerifier}` |
| `tests/summary_transition_forgery.rs` | 0 | 2 | V `min_plus_transition::{verify_snapshot, TransitionVerifier}` |
| `tasks/tools/src/generic_certificate_bench.rs` | 0 | 1 | V `min_plus_transition::{…}` |

**Private `Cargo.toml` files needing the new dependency:** the `ergodis-private` root package only.
`tasks/tools` uses verify alone (`min_plus_transition`) and needs no change; `tasks/gem-hunt` and
`tasks/hadamard-2092` name neither crate. The bare-`rustc` Rel parity harness imports neither
crate, as the card states.

#### Non-Rust references

| Reference | What it needs |
|---------------------------------------------------------|---------------|
| `docs/rule-contract.md:5` — "the independent `ergodis-verify::rule_contract` checker" | rename to `ergodis-verify::grounded`; the crate-split sentence added |
| `docs/rule-contract.md:281,287-288` — `cargo test -p ergodis-rules -p ergodis-verify`, the wasm32 `ergodis-rules` build and `crates/rules/tests/wasm_abi.mjs` | add `-p ergodis-contract`; the wasm32 build and ABI test are otherwise unaffected (`ergodis-rules` gains one path dependency with no new external crate) |
| `docs/verification.md:109-113` — "the root workspace includes `ergodis`, `ergodis-verify` and `ergodis-runtime`", "the verifier's dependencies are serde/serde_json, SHA-256 and error support" | both sentences become wrong; rewrite for the new member and the contract edge. The list is already stale (it omits `ergodis-rules`, `ergodis-modules`, `ergodis-repository-native`) |
| `docs/verification.md:96-106` — the checker-identity migration paragraph | extend for the second identity |
| `DESIGN.md:38` — the crate table | one row for `ergodis-contract` |
| `docs/language-semantics.md:76`, `docs/dev/contributor-boundaries.md:12` | prose naming `ergodis-verify` as the home of the contract; adjust |
| `docs/finite-lowering.md`, `docs/summary-transitions.md`, `docs/run-bundles.md` | name only `finite_lowering` / `min_plus_transition`; **no change** |
| `.publicignore` | no crate paths; the new crate exports automatically. **No change**, but confirm no hold entry is wanted |
| `.public-lint-allow`, `.publication-profile` | no crate paths. **No change** |
| `scripts/export-public.sh`, `scripts/public-lint.sh`, `scripts/publication-profile.sh` | no crate lists. **No change** |
| `python/generate_evidence.py` | `HASHED_TREES` walks `crates` in full plus `Cargo.toml`/`Cargo.lock`, so the new crate is absorbed; `SHA256SUMS` must be regenerated with `python3 python/generate_evidence.py --write` in the same commit, because `tests/evidence_manifest.rs` runs inside `cargo test` |
| `scripts/check-verifier-dependencies.py` | **breaks.** It asserts verify's direct normal dependencies are exactly `{serde, serde_json, sha2, thiserror}` and that verify's workspace-member closure is exactly `{verify}`. Both become false. Extend it to check the pair: contract's direct set is the four, verify's is the four plus `ergodis-contract`, and the closure is `{verify, contract}`; keep the forbidden-package check over the union |
| `scripts/check-runtime-dependencies.py` | **already failing today**, before this task: it asserts runtime's workspace closure is `{runtime, core, verifier}`, and runtime has depended on `ergodis-rules` (hence also `ergodis-modules`) for some time. Running it now prints `runtime workspace dependencies changed`. It will need `ergodis-contract` too |
| Lean audit gate Rust-side inputs (`~/src/othello/lean/WeightedRules/README.md`) | consumes the `ergodis-rules` cdylib through `ergodis_module_v1` and the `lean_boundary_fixtures` example; neither the ABI nor the fixture schema changes. Rebuild the library and rerun the gate as a check, no edit expected |
| `~/src/ergodis-private/docs/adr/0004-rel-lowering-ir.md:10`, `analysis/property-tests/design.md:91` | prose naming `ergodis_verify::rule_contract` and `ergodis-verify::binary_composition`; the first needs the new path, the second is still correct |
| `~/src/ergodis-private/analysis/weighted-normalization/SHA256SUMS`, `evidence/2026-09-12-privacy-lowering.sha256` | pin `../ergodis/crates/verify/src/min_plus_transition.rs` and `.../finite_lowering.rs` by path and hash. Both files stay in verify unmodified, so **both pins remain valid**; they are the reason `min_plus_transition.rs` and `finite_lowering.rs` must not be renamed or relocated in this task |

### 4. Identity inventory

**Present value**, recomputed offline from the file bytes at core `687217f` (SHA-256 over
`RULE_ID` ‖ `RULE_VERSION` little-endian ‖ `ergodis/direct-binary-composition-check/v2` ‖ the
eleven source files in `lib.rs`'s order):

```
efcfa1af06d8ee380bc0578e8bd80a11996c600caf36e275176b1bd3c1f7f313
```

**The single consumer.** `binary_composition::verify` (line 303) writes
`checker: implementation_identity()` into `VerificationRecord`. That record has
`schema: u32` (minted as `1`, never validated anywhere except through whole-record equality) and
`rule_version: u32` (checked against `RULE_VERSION` by `replay`). `binary_composition::replay`
accepts only when the freshly computed record equals the supplied one, so the identity is compared
by full-record equality, not by a dedicated check.

The record's field propagates through three more structs, each of which must gain the second named
field:

| Struct | File | Role |
|-------------------------------|-------------------------------------|-------------------------------------|
| `VerificationRecord.checker` | `crates/verify/src/binary_composition.rs:197` | minted at 303, compared by equality at 321 |
| `AdmissionReceipt.checker` | `src/admission.rs:239` | copied out at 298, rebuilt into a record at 452, compared against `checker_identity()` at 527 |
| `WireReceipt.checker` | `crates/runtime/src/service.rs:138` | one-way wire projection at 603; `#[serde(deny_unknown_fields)]`, no reverse mapping, no JavaScript consumer |
| `ergodis::admission::checker_identity()` | `src/admission.rs:326` | the root crate's alias for the verify identity |

**Adding a second named field requires:** a `contract: ContentId` field on all three structs
(all three derive `Serialize`/`Deserialize` with `deny_unknown_fields`, so the JSON shape changes);
`binary_composition::verify` filling it from `ergodis_contract::implementation_identity()`;
a `contract_identity()` beside `checker_identity()` in `src/admission.rs` and the extra clause in
the comparison at line 527; the projection in `service.rs:599-612`; and a forgery test for the new
field mirroring `tests/verifier_boundary.rs:194` and `tests/admission_pipeline.rs:168`, which flip
`record.checker[0]`/`forged.checker[0]`. `tests/verifier_boundary.rs:108` asserts
`record.checker == receipt.checker` and gains the parallel assertion.

**Stored artifacts carrying an `implementation_identity()` value: none.** Searched core
`evidence/` (every `checker`-bearing file there carries `checker_sha256`, which is a hash of a
Python checking script written by `python/check_*.py`, unrelated), core `tests/` and fixtures,
`~/src/ergodis-private` (only ADR 0005 mentions the identity at all, in prose), and
`~/src/ergodis-evidence` (no match). The only pinned hex in either tree is
`tests/admission_pipeline.rs:55` `PRE_EXTRACTION_CHECKER_ID =
0e3afc66 7762301b cbe39577 fd25d10d e2327caa c8f72f86 38552bac f0957cb0`, and the test asserts
`assert_ne!` against it — a deliberate negative pin of a historical pre-extraction value. It stays
valid across this change and needs no update.

**So the receipt migration cost is nil.** What must be regenerated is `SHA256SUMS` (source bytes
change) and `Cargo.lock`. Record the old value above and the two new values in the task report when
the move lands. The contract identity's domain string is proposed as
`ergodis/finite-rule-contract/v1`; whether verify's tag bumps from `…/v2` to `…/v3` is an open
question below.

**Completeness test shape.** `include_bytes!` needs a literal path, so each crate's hashed list
becomes a `const HASHED: [(&str, &[u8]); N] = [("lib.rs", include_bytes!("lib.rs")), …]`, with
`implementation_identity()` folding over it in order and a test comparing the name set against
`std::fs::read_dir(concat!(env!("CARGO_MANIFEST_DIR"), "/src"))` filtered to `*.rs`. Both crates'
`src/` are flat, so this is exact. Verify's list gains `support.rs` (the repair the ADR names) and
`grounded.rs`, and loses the six files that move.

### 5. Performance exposure

**The workspace release profile** (root `Cargo.toml:128-141`) is `opt-level = 3`,
`lto = "thin"`, `codegen-units = 1`, `panic = "abort"`; `[profile.bench]` is the same without
`panic`; `[profile.profiling]` inherits release with debug info; `[profile.campaign]` inherits
release with overflow checks. ThinLTO with one codegen unit gives cross-crate inlining in release
and bench builds. Debug and test builds get no LTO, so a cross-crate non-generic call there is a
real call.

**What actually crosses the new boundary:**

1. **The evaluator's kernel does not.** `Demand::evaluate_into` →
   `evaluate_counting::<COUNT>` (`crates/rules/src/demand.rs:1989-2011`) runs entirely on
   `ergodis-rules`-local structures: `RelationPlan`, `Op`, `DemandWorkspace`, `key_of`, `power`.
   The contract types `Admitted`, `AtomRef`, `Slot` and `MAX_*` appear only in plan construction
   (lines 798-1100) and `Error` only as a return type. **No contract call sits inside the
   derivation loop.** This is the single most reassuring finding for the A/B; the card's worry
   about `evaluate_into` crossing the boundary does not materialize, and the remaining risk there
   is ThinLTO reshuffling, not a lost inline.
2. **The carrier methods do, and this is the real exposure.** `composition_graph::propagate`
   (verify) calls `W::plus`, `W::times`, `W::minus`, `W::zero` per rule per round, and
   `support::check` calls `plus`/`times` per coordinate and per product. `propagate` and `check`
   are generic and are instantiated in verify, but the impl methods
   `<BoundedMinPlus as TransitionWeight>::plus` and the eight others are **non-generic functions
   defined in the contract crate**. In release/bench, rustc's automatic cross-crate-inlining
   heuristic for tiny functions plus ThinLTO should cover them; in a debug or test build they
   become calls. `semi_naive_product` is generic and therefore unaffected wherever it lives.
3. **Two small non-generic accessors cross in the checkers' load passes.** `Admitted::pack` and
   `Admitted::tuple` are called per fact and per listed tuple in `derivation.rs:184,203,269` and
   `ranked.rs:268,271,289`. These are O(facts + listed tuples) setup passes, not the join kernels —
   the join kernels use `RelationStore::tuple` and `JoinIndexes::probe`, both of which stay inside
   verify. `datalog::universe` is called once per relation at admission and is not hot.
4. **`ProductRule` field reads** in `propagate`, `support::check` and `support::derive` are plain
   struct field loads of a `#[repr(C)]` type; a crate boundary does not affect them.

**Recommended `#[inline]` additions** — each non-generic, one expression or close to it, and on a
per-element path:

| Item | File | Why |
|-------------------------------------|-------------------|-----|
| the ten `TransitionWeight` methods of `BoundedMinPlus` and `Boolean` (`zero`, `one`, `plus`, `times`, `minus`) | `contract::weight` | called per rule per round in `propagate`, per coordinate and per product in `support::check`, and throughout `min_plus_transition` |
| `Admitted::pack` | `contract::datalog` | per fact and per listed tuple in both Datalog checkers |
| `Admitted::tuple` | `contract::datalog` | same |

`decode`/`encode` on the carriers, `universe`, and everything in `rule_contract` are not on a hot
loop and should not get the attribute. **Recommendation on timing:** land the move pure, with no
`#[inline]`, then measure; add the attributes in a separate commit only if the interleaved A/B
shows a regression, with its own numbers. That keeps the move auditable as a move and keeps each
attribute justified by measurement rather than by a guess, which is what `PERFORMANCE.md` asks for.
The A/B targets are the grounded replay over both carriers, `support::check`, the derivation and
ranked checkers, and `evaluate_into` as an A/A null, all against re-retained controls.

### 6. Proposed implementation plan

**Core commit A — the move and the two identities.** One commit, because the identity must change
exactly once: splitting the move from the identity rebuild would move it twice. Contents: new
`crates/contract` (`Cargo.toml` + the eight `src` files above) with its `implementation_identity()`
and completeness test; verify reduced to its ten files with the rebuilt list, the new `grounded`
module, and its own completeness test; `check_invariance` made `pub`; the four moved `Grounded`
field reads rewritten to accessors; workspace `members`/`default-members`; the three core
`Cargo.toml` dependency lines; every core importer from the table in §3; `docs/rule-contract.md`,
`docs/verification.md`, `DESIGN.md`, `docs/language-semantics.md`,
`docs/dev/contributor-boundaries.md`; `scripts/check-verifier-dependencies.py` extended to the
pair and `scripts/check-runtime-dependencies.py` repaired; `Cargo.lock`; `SHA256SUMS` regenerated.
*Gate:* `cargo fmt --check`; `cargo clippy --all-targets --all-features -- -D warnings`;
`cargo test --all-features` (which includes `tests/evidence_manifest.rs` and the public lint);
both dependency guard scripts printing pass; the Python differential on the bounded fixture corpus
including costs, witnesses and helper loads; `cargo build -p ergodis-rules --release` plus
`native_abi.py`, and the wasm32 build plus `wasm_abi.mjs`; the old and new identity hexes recorded;
and a demonstration that editing a contract docstring moves only the contract identity.

**Core commit B — the record carries both identities.** `VerificationRecord.contract`,
`AdmissionReceipt.contract`, `WireReceipt.contract`, `admission::contract_identity()`, the extended
comparison at `src/admission.rs:527`, the parallel forgery tests, `docs/verification.md`'s
migration paragraph, `SHA256SUMS`. *Gate:* the full suite again, plus a stated reading of what a
record with only one identity now does (it fails to deserialize under `deny_unknown_fields`, and
nothing stored has one).

**Core commit C — the performance evidence.** Re-retain the controls first, as the lane handoff
says. Interleaved multi-round A/B on the grounded replay over both carriers, `support::check`, the
derivation and ranked checkers, and `evaluate_into` as an A/A null; the compiled `evaluate_into`
and `propagate` compared; instructions, cycles, branches, branch misses, peak RSS. `#[inline]`
additions folded in here only if measured, each with its numbers. *Gate:*
`ergodis-dev/PERFORMANCE.md`'s required validation for a hot-loop change, and the evidence bundle
committed per `notes/research-reproducibility-conventions.md`.

**Private commit D — importers follow.** `ergodis-private/Cargo.toml` gains `ergodis-contract`; the
six private sources and tests from §3 rewired; `docs/adr/0004-rel-lowering-ir.md:10` and
`src/rel_frontend/lower.rs`'s docstring updated; ADR 0005 moved to Accepted, corrected to what was
built, with its three open questions filled from §1. *Gate:* private `cargo test`, the Rel lowering
differential, and confirmation that the two private `SHA256SUMS` pins on
`min_plus_transition.rs`/`finite_lowering.rs` still verify.

**Othello commit E — lifecycle.** This report completed with the cut as built, the identity values,
the receipt inventory and the A/B; the card closed and archived per
`notes/task-lifecycle-conventions.md`; handoff and queue updated.

### Open questions, each with a recommendation

1. **Contract module names.** Mirror verify's file names (`rule_contract`, `datalog`, `weight`,
   `support`, `composition_graph`, `derivation`, `ranked`)? *Recommend yes*: the diff reads as a
   move, each crate's hashed list is its own directory listing, and most importers change only the
   crate name. The cost is that `crates/rules/src/demand.rs` imports `derivation` and `ranked`
   items from two crates and must use explicit item imports instead of `self`. The alternative,
   one combined certificate module, would force renaming the two `Rejection` types, which is a type
   change the card forbids.
2. **`Limits`.** Move it to contract with `ProductRule` and the graph `Error`, or leave it in
   verify? *Recommend move*: it is a declared admission budget, the ADR puts budgets in the
   contract, and it leaves verify's `composition_graph.rs` as nothing but the replay kernel. The
   strictly minimal move is `{ProductRule, Error}` if you prefer minimality over the semantic line.
3. **`semi_naive_product`.** *Recommend leaving it in `weight.rs`* so that file is a byte-for-byte
   move; it is generic, so no inlining question arises either way.
4. **`support::derive`.** *Recommend moving it to contract*: it is a producer with no checker
   caller, and leaving it keeps a producer under the checker identity, which is the coupling this
   task exists to remove.
5. **`VerificationRecord.schema`.** The record gains a field. Bump `schema` from `1` to `2`?
   *Recommend yes*: only `binary_composition.rs:299` mints it, nothing validates it except
   whole-record equality, and nothing is stored, so the bump is free and makes the shape change
   self-describing.
6. **Verify's identity domain string.** Bump `ergodis/direct-binary-composition-check/v2` to `v3`,
   since the hashed list changes composition? *Recommend yes*, same reasoning as 5.
7. **The new checker module's name.** `verify::grounded`, as you proposed. *Recommend yes*;
   `rule_contract` would collide confusingly with the contract crate's module of that name.
8. **`#[inline]` timing.** *Recommend after the A/B*, in a separate commit, so each attribute is
   justified by a measurement rather than by the split.
9. **`scripts/check-runtime-dependencies.py` is already red** before this task, because runtime
   gained `ergodis-rules` and the script still asserts the closure is `{runtime, core, verifier}`.
   *Recommend repairing it inside core commit A*, since the split touches that same assertion; say
   so explicitly in the commit message so the repair is not mistaken for a consequence of the
   split.
10. **Contract crate directory name.** `crates/contract` with package name `ergodis-contract`,
    matching `crates/verify`/`ergodis-verify`. *Recommend yes.*

## The cut as built

Core commits: `db7fec6` (the runtime boundary check, repaired before the split) and `83eec12` (the
move, the two identities and the record). The cut is the design of the section above, with one
correction found while building and the collision handling the mirrored module names force.

### Packages after the move

`ergodis-contract` (`crates/contract`) holds `lib.rs`, `weight.rs`, `composition_graph.rs`,
`rule_contract.rs`, `support.rs`, `datalog.rs`, `derivation.rs`, `ranked.rs`.
`ergodis-verify` holds `lib.rs`, `binary_composition.rs`, `min_plus_transition.rs`,
`composition_graph.rs`, `finite_lowering.rs`, `grounded.rs`, `support.rs`, `datalog_store.rs`,
`derivation.rs`, `ranked.rs`.

### Move evidence, file by file

From `git diff -M --find-copies-harder` and `--numstat` over `83eec12`:

| File | Git verdict | Lines ± | What changed beyond the move |
|-----------------------------------------|---------------------------------------|---------|------------------------------|
| `crates/contract/src/weight.rs` | rename from `crates/verify/src/weight.rs`, **100% similarity** | 0 / 0 | nothing; byte-identical, `semi_naive_product` included |
| `crates/contract/src/datalog.rs` | rename from `crates/verify/src/datalog.rs`, **100% similarity** | 0 / 0 | nothing; byte-identical, test module included |
| `crates/contract/src/rule_contract.rs` | rename from `crates/verify/src/rule_contract.rs`, 85% similarity | 5 / 115 | the import line drops `Limits`/`VerifiedGraph`; `check_invariance` becomes `pub`; the module docstring names `ergodis_verify::grounded` as the checker; the 110-line checker block (`Verified`, `replay`, `verify`, `support_check`, `verify_support`) is removed to `crates/verify/src/grounded.rs` |
| `crates/contract/src/support.rs` | rename from `crates/verify/src/support.rs` at a relaxed threshold, 84 lines kept | 84 / 0 new file content | module docstring rewritten to describe the record and the producer and to name `ergodis_verify::support` as the check; `Stability` dropped from the import (only `check` used it); `check`, `Rejection` and the test module left behind in verify |
| `crates/contract/src/composition_graph.rs` | new file, three types lifted verbatim | 58 / 0 | new module docstring; `ProductRule`, `Limits` and `Error` are byte-for-byte the originals, so every variant and `#[error("…")]` string is unchanged |
| `crates/contract/src/derivation.rs` | new file, five items lifted verbatim | 93 / 0 | new module docstring; `DERIVATION_SCHEMA`, `premise_stride`, `DerivationCertificate`, `Rejection`, `From<Rejection> for Error` and `decode_derivation_certificate` unchanged |
| `crates/contract/src/ranked.rs` | new file, six items lifted verbatim | 60 / 0 | new module docstring; `RANKED_SCHEMA`, `RankedRelation`, `RankedCertificate`, `Rejection`, `From<Rejection> for Error` and `decode_ranked_certificate` unchanged |
| `crates/contract/src/lib.rs` | new file | 80 / 0 | module list, `IDENTITY_DOMAIN`, `HASHED_SOURCES`, `implementation_identity`, `sources_are_complete` |
| `crates/verify/src/grounded.rs` | new file, the checker block lifted | 126 / 0 | new module docstring; the five items are the originals with the private `Grounded` field reads replaced by the existing public accessors `inputs()`, `products()`, `source_id()` |
| `crates/verify/src/composition_graph.rs` | in place | 5 / 54 | the three moved types deleted; two import lines; docstring sentence pointing at the contract module |
| `crates/verify/src/support.rs` | in place | 8 / 73 | schemas, record and `derive` deleted; imports retargeted; docstring rewritten; the test module now imports `derive` from the contract |
| `crates/verify/src/derivation.rs` | in place | 15 / 97 | record, schema, stride, refusals, `From` and decoder deleted; imports retargeted; docstring shortened to the check |
| `crates/verify/src/ranked.rs` | in place | 13 / 64 | same shape as `derivation.rs` |
| `crates/verify/src/datalog_store.rs` | in place | 3 / 3 | three import lines retargeted to the contract; no body change |
| `crates/verify/src/min_plus_transition.rs` | in place | 1 / 1 | **one line**: `use crate::weight::{…}` becomes `use ergodis_contract::weight::{…}`. Not byte-identical, against the phase-1 expectation; see Invariants |
| `crates/verify/src/finite_lowering.rs` | untouched | 0 / 0 | **byte-identical**; absent from the commit's file list |
| `crates/verify/src/lib.rs` | in place | 64 / 17 | module list, `IDENTITY_DOMAIN` (tag `v2` to `v3`), `HASHED_SOURCES`, the identity rewritten as a fold, `sources_are_complete` |
| `crates/verify/src/binary_composition.rs` | in place | 11 / 1 | `RECORD_SCHEMA = 2`; `VerificationRecord.contract` with its docstring; `verify` fills it from `ergodis_contract::implementation_identity()`; the minted `schema` reads the constant |

### Non-move line changes outside the two packages, with reasons

- `src/admission.rs`: `AdmissionReceipt.contract` and `contract_identity()`; the field copied out
  of the record and back into it on replay; the binding comparison extended. One
  `#[allow(clippy::large_enum_variant)]` on `AdmissionOutcome` with a comment: the added identity
  pushed the admitted variant past the lint's threshold, and boxing it would change the public
  type and add an allocation to a path that runs once per check. This is a lint annotation, not a
  behaviour change.
- `crates/runtime/src/service.rs`: `WireReceipt.contract` and its projection.
- `crates/runtime/src/recursive.rs`: `composition_graph` now names the contract module (its only
  use there is the `Error` behind `#[from]`); `VerifiedGraph` from verify; `rule_contract::verify`
  becomes `grounded::verify`.
- `crates/rules/src/lib.rs`, `demand.rs`, `frontier.rs`, `pages.rs`, `provider.rs`: import lines;
  the two checker calls become `grounded::verify`/`grounded::verify_support`; `premise_stride` is
  called unqualified and its adjacent comment drops the module prefix.
- `tests/verifier_boundary.rs`: the record/receipt equality assertion gains the contract field, and
  the forgery table gains a case that flips `record.contract[0]`.
- Every other core file in the commit changes only `use` lines, plus four files where the mirrored
  module names collide in one scope and an alias resolves it:
  `crates/rules/tests/contract_properties.rs` and `properties.rs` bind the replay refusal as
  `ReplayError` (the contract's) so `composition_graph` can stay bound to verify's checker module;
  `contract_properties.rs`, `properties.rs`, `boolean.rs`, `contracts.rs`,
  `crates/runtime/tests/update_cost.rs` and `update_properties.rs` import the grounded checker as
  `verify_grounded` rather than shadowing a local named `grounded`.
- `scripts/check-verifier-dependencies.py`: checks both packages' direct dependency sets and the
  verifier's workspace closure being itself and the contract.
- `docs/rule-contract.md`, `docs/verification.md`, `docs/language-semantics.md`,
  `docs/dev/contributor-boundaries.md`, `DESIGN.md`: the new package, the dependency direction, the
  two identities, and `-p ergodis-contract` in the documented replay command.

## Identities

| Identity | Value |
|--------------------------------|------------------------------------------------------------------|
| checker, before the split | `efcfa1af06d8ee380bc0578e8bd80a11996c600caf36e275176b1bd3c1f7f313` |
| checker, after (`ergodis-verify`) | `0ea8d53f610945bdcb867341aa8fcdae6e6d3b7580518856179b48bf34cf6498` |
| contract (`ergodis-contract`) | `85346c30659b5f5d8ddd5f36a7659a2d9eae13e206b3a08292e3112afe0504b2` |

The checker identity moved once, for three stated reasons: six source files left its hashed list,
`support.rs` and the new `grounded.rs` joined it, and the domain separator went from
`ergodis/direct-binary-composition-check/v2` to `…/v3`. The contract identity's separator is
`ergodis/finite-rule-contract/v1`.

Both values were read from the compiled code, by a temporary probe test under
`crates/verify/tests/` (which is outside `src/` and so contributes to neither identity), and they
agree digit for digit with an independent offline recomputation from the file bytes. The probe was
removed before the commit.

**The docstring demonstration.** With the packages as committed, one docstring line was added above
`UNRANKED` in `crates/contract/src/support.rs` with the Edit tool and the probe re-run:

| | contract | checker |
|------------------|------------------------------------------------------------------|------------------------------------------------------------------|
| before the edit | `85346c30659b5f5d8ddd5f36a7659a2d9eae13e206b3a08292e3112afe0504b2` | `0ea8d53f610945bdcb867341aa8fcdae6e6d3b7580518856179b48bf34cf6498` |
| with the edit | `d4146e0a9230708e0bbc8cf026a885480767329d00acc9e80bd2610de3d86baf` | `0ea8d53f610945bdcb867341aa8fcdae6e6d3b7580518856179b48bf34cf6498` |
| after reverting | `85346c30659b5f5d8ddd5f36a7659a2d9eae13e206b3a08292e3112afe0504b2` | `0ea8d53f610945bdcb867341aa8fcdae6e6d3b7580518856179b48bf34cf6498` |

The checker identity is unmoved by a contract docstring edit, which is what the split was for. The
edit was reverted with the Edit tool; no git operation touched the working tree.

The contract identity above is the one `83eec12` mints. The measured `#[inline]` repair in
`f7b0d16` edits `crates/contract/src/datalog.rs` and therefore moves it once more, to
`2b68f01e3995ff310017539d6c1cbbc339ba3452eac65e959a52e131ae434100`, leaving the checker identity
where it is; see "Performance A/B".

## Receipt inventory

No stored artifact in any repository carries an `implementation_identity()` value, so nothing is
regenerated. Searched: core `evidence/` (its `checker_sha256` fields are hashes of the Python
checking scripts written by `python/check_*.py`, unrelated), core fixtures and tests,
`~/src/ergodis-private`, and `~/src/ergodis-evidence`. The one pinned checker hex in either tree is
`tests/admission_pipeline.rs`'s `PRE_EXTRACTION_CHECKER_ID`, asserted with `assert_ne!` against the
current value; it still holds and needed no edit.

What did regenerate: `SHA256SUMS` (source, script and document bytes changed, and the manifest
walks `crates/` in full) and `Cargo.lock` (one new package).

## Invariants

| Invariant | How it is pinned | Result |
|-------------------------------------|-----------------------------------------------------------------|--------|
| wire source identity | `crates/rules/tests/demand.rs`, `contracts.rs`, `demand_nary.rs`; `crates/verify/src/datalog_store.rs` tests; the `datalog.rs` test `admits_closure_and_numbers_variables_in_body_order`, which asserts `admit`'s identity equals `ground`'s | unmoved |
| prepared source identity | `crates/rules/tests/demand_prepared.rs`, over `admit_prepared`'s own domain tag | unmoved |
| certificate bytes | `crates/rules/tests/native_abi.py` ("native C ABI: 129 min-plus programs, one Boolean closure, independent oracle … passed") and `crates/rules/tests/wasm_abi.mjs`, which replays a **byte-identical native certificate** under the wasm32 build | unmoved |
| plan fingerprints and helper loads | `python3 python/generate_fixtures.py --check` | unmoved |
| parity digest, Python differential | `python/generate_fixtures.py --check`, plus `dynamic_updates_match_independent_python_oracle` (512 updates) and the oracle parity inside both ABI harnesses | unmoved |
| `finite_lowering.rs` byte-identical | absent from `83eec12`'s file list; `git diff` empty | **holds** |
| `min_plus_transition.rs` byte-identical | `git diff -M HEAD~1 HEAD` | **does not hold**: exactly one line, `use crate::weight::{BoundedMinPlus, TransitionWeight}` becoming `use ergodis_contract::weight::{…}`. The module imported the carrier trait from the package that moved, so the path had to follow. No item, signature or body changed. Consequence: the private pin on this file's hash in `analysis/weighted-normalization/SHA256SUMS` no longer matches and is handled in the private commit |

## Gates run

| Gate | Command | Result |
|-------------------------|--------------------------------------------------------------------|--------|
| baseline, before any edit | `cargo test --all-features` | green, 59s |
| format | `cargo fmt --check` | clean |
| lint | `cargo clippy --locked --all-targets --all-features -- -D warnings` | clean |
| tests | `cargo test --locked --all-features` | 1021 passed, 0 failed, across 84 result sections; includes both `sources_are_complete` completeness tests and `tests/evidence_manifest.rs` |
| fixtures and oracle | `python3 python/generate_fixtures.py --check` | clean |
| manifest | `python3 python/generate_evidence.py --check` | clean |
| verifier boundary | `python3 scripts/check-verifier-dependencies.py` | "the contract and four approved external direct dependencies; 25 packages in normal/build closure; no solver or host package" |
| runtime boundary | `python3 scripts/check-runtime-dependencies.py` | "runtime -> core, rules, verifier; no reverse or default host edge" |
| native ABI | `cargo build -p ergodis-rules --release` then `native_abi.py` | "129 min-plus programs, one Boolean closure, independent oracle, source/claim/handle/capacity lifecycle gates passed" |
| wasm32 ABI | `cargo build -p ergodis-rules --release --target wasm32-unknown-unknown` under `nix develop .#wasm`, then `wasm_abi.mjs` | "129 programs, native certificate and Python oracle parity, lifecycle gates passed" |
| publication guards | `bash tests/publication-guards.sh` | 105 passed, 0 failed |
| publication lint | the pre-commit hook, on the staged and export-filtered trees | "public-lint: clean" for both, on `db7fec6` and `83eec12` |

The performance A/B is deliberately not run here; it is a separate milestone.

## Private importers

Private commit `55dab0c`. `ergodis-private` gained an `ergodis-contract` path dependency; nothing
else in the private workspace needed one. `tasks/tools`, `tasks/gem-hunt` and
`tasks/hadamard-2092` are unchanged: the only core paths `tasks/tools` names are
`min_plus_transition`, which stayed in the checker package.

| File | Change |
|---------------------------------------|--------|
| `Cargo.toml`, `Cargo.lock` | the new path dependency |
| `src/rel_lowering.rs` | `rule_contract::{Atom, Fact, Program, Relation, Rule, Term, SCHEMA}` retargeted |
| `src/rel_stratified.rs` | `datalog::{PreparedAtom, PreparedRelation, PreparedRule, PreparedSource, Slot}` and `rule_contract::Error` retargeted |
| `src/datalog_certificate_codecs.rs` | `ranked::RankedRelation` retargeted; the docstring's `RankedCertificate` path follows |
| `src/rel_frontend/lower.rs` | one docstring path |
| `examples/closure_ballpark.rs` | `rule_contract`, `DerivationCertificate`, `RankedCertificate`, `premise_stride` retargeted |
| `tests/rel_lowering.rs` | the six `datalog::MAX_*` bounds the backend mirrors |
| `tests/datalog_certificate_codecs.rs` | `ranked::RankedRelation` retargeted |
| `docs/adr/0004-rel-lowering-ir.md` | the core rule-contract path |
| `docs/adr/0005-contract-crate-and-two-identities.md` | status Proposed to Accepted, corrected to what was built, with the three open cut questions answered and the unforeseen consequence recorded |

Every Rust change is a path retarget; no signature, type or body changed. What still names
`ergodis_verify` in private, correctly: `src/lrc_transition_verification.rs`,
`src/privacy_lowering.rs`, `tests/independent_summary_transition.rs`,
`tests/summary_transition_forgery.rs` and `tasks/tools/src/generic_certificate_bench.rs`, all of
which use `min_plus_transition` or `finite_lowering`.

### Private gates

| Gate | Result |
|---------------------|--------|
| `cargo fmt --check` | clean |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo test --all-features` | `exit=0`, 13m54s, 1171 passed, 0 failed across 40 result sections |
| parity digest and reference-evaluator differential | inside that run: `tests/rel_reference_eval.rs` (`the_committed_fixtures_agree_with_the_reference_evaluator`, `the_generated_corpus_agrees`, `the_negation_corpus_agrees`, `every_figure_three_and_four_equation_agrees_with_the_reference_evaluator`, `the_recorded_rejection_surface_agrees`) and `tests/rel_lowering.rs`, all green |

### The two private hash pins

- `evidence/2026-09-12-privacy-lowering.sha256` pins `../ergodis/crates/verify/src/finite_lowering.rs`
  at `68ee2202…`. That file is byte-identical after the split and the pin **still verifies**.
- `analysis/weighted-normalization/SHA256SUMS` pins
  `../ergodis/crates/verify/src/min_plus_transition.rs` at `61390899…`. That file now hashes to
  `7c55b24b…`, because its one import line had to follow the carrier trait into the contract
  package, so the pin **no longer verifies**.

Both files were left untouched, deliberately. They are point-in-time receipts of dated audits, not
live gates: nothing in the test suite checks them, the weighted-normalization README replays them
by hand and names the core revision it inspected (`2e1bab2`), and the `Cargo.lock` hashes both
receipts pin were **already stale before this task** (the private lock at the previous commit
hashed `b2f8e002…` against a pinned `ebeb7931…`; the core lock before the split hashed
`12fe7846…` against a pinned `b9fdafe1…`). Rewriting one line of a dated receipt would make it
claim an attestation it never made. Refreshing that bundle, if wanted, is a task for whoever owns
the weighted-normalization audit and means a re-run, not a hash edit.

### One private artifact left alone and flagged

`analysis/rel-frontend/coverage-v1.json` contains the prose "projects the IR layer by layer into
`ergodis_verify::rule_contract::Program`". It is a versioned coverage record rather than live
documentation, and the coordinator's scope named only the ADR 0004 line and the `lower.rs`
docstring, so it was not edited. The type it names is the same type, now spelled
`ergodis_contract::rule_contract::Program`.

## Deviations from the approved cut

1. **`min_plus_transition.rs` is not byte-identical.** One line: the carrier trait it imports moved
   to the contract package, so the `use` path followed. No item, signature or body changed.
   `finite_lowering.rs` is byte-identical as expected.
2. **One lint annotation was added that the cut did not anticipate.** The second identity pushed
   `AdmissionOutcome::Admitted` past clippy's `large_enum_variant` threshold. Boxing the variant,
   which is what clippy suggests, would change the public type and add an allocation to a
   once-per-check path, so the enum carries `#[allow(clippy::large_enum_variant)]` with a comment
   stating why. No behaviour or API change.
3. **The root `ergodis` package gained a contract dependency**, which the phase-1 inventory said it
   would not need. It needs one now because `admission::contract_identity()` calls
   `ergodis_contract::implementation_identity()` for the record's second field.
4. **Six test files import the grounded checker under an alias.** With the contract mirroring the
   checker's module names, `use ergodis_verify::grounded;` would sit beside a local binding named
   `grounded` in several of these tests, so they import `verify as verify_grounded`. Two of them
   also bind the replay refusal as `ReplayError`. These are readability aliases in tests, not API
   changes.

## Performance A/B

The split is a pure code move, so the whole question is whether the new crate boundary changed what
the compiler emits. The release profile is `lto = "thin"`, `codegen-units = 1`, so cross-crate
inlining is available; the risk is that a non-generic method that used to be inlined inside one
crate is now an out-of-line call, and the secondary risk is that ThinLTO reshuffles a kernel that
the move does not otherwise touch.

### Arms

Every hash below is recorded **as measured**, never cited: the thing to run is the retain recipe at
the named revision. Both controls were retained fresh for this task, from detached worktrees under
`~/.cache/ergodis/worktrees/c1209/` whose `git status --short` was empty. The handoff's named
controls `closure_ballpark-5217cdb` and `ergodis-tools-ab6be13` predate `96aee9b`, so they are not
used here.

| Arm | Role | Private | Core | Dirty | Retained name | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, derivation loop and checkers | the tree before the split | `74f974c` | `96aee9b` | no | `closure_ballpark-74f974c` | `e8e2b139b02d7545b331fdad69f96a47adf33dc1f3363ba1b769d93bc434e72f` |
| control, frontend and backend stages | the Rel route before the split | `74f974c` | `96aee9b` | no | `ergodis-tools-74f974c` | `6a9c0a8693edbfcaf89a4bea2e722bdccba140c250eb068fdb41ddd2040a8838` |
| candidate, derivation loop and checkers | the tree after the split | `55dab0c` | `83eec12` | no | `closure_ballpark-55dab0c` | `97bd6231da918e7e0f1ecfb05349a5cdde3b2830252c034f5e6cf3498d50f44b` |
| candidate, frontend and backend stages | the Rel route after the split | `55dab0c` | `83eec12` | no | `ergodis-tools-55dab0c` | `e579be0e129a0ccda26fcb35b4694b607d295f2dc0e0bcfb0c121209ad16a9b5` |

rustc 1.95.0 (59807616e 2026-04-14), release profile, no features, on every row, from the core
flake's devShell; `flake.nix`, `flake.lock` and `rust-toolchain.toml` are byte-identical between
`96aee9b` and `83eec12`, so the two arms differ only in the code under test. The core revision of
each arm is this session's record: `retain-bin.sh` still stores only the crate directory's
revision, which for both arms is the private one.

Retain recipes, the control from `~/.cache/ergodis/worktrees/c1209/ergodis-private` and the
candidate from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

### Method

`~/src/ergodis-dev/PERFORMANCE.md` and `~/src/ergodis-dev/performance-playbook.md`, both read in
full first. Event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`, which
fits this PMU without multiplexing; cache events would get their own run and are not needed here,
because no ratio leaves the null. Rounds alternate arm order and every cohort carries its own A/A
null. Every run is pinned to core 5. Two-point differencing between `repeats` and `2 × repeats`
removes process startup and preparation from each per-iteration figure. Instruction ratios decide;
cycle ratios are reported but this box was running at load average 5.4 throughout, so they are
noise-dominated and settle nothing. Bulk output under `~/.cache/ergodis/c1209/`.

### 1. The derivation loop: an A/A null, and the kernel is byte-identical

Eighteen cohorts through `ab.py --mode evaluate`, which prepares once and then enters
`Demand::evaluate_into` `repeats` times with no certificate, checker or output.

| Cohort | Instructions, split ÷ control | 95 % interval | A/A null | Cycles | Derived tuples |
|------------------------|--------|--------------------|-----------|---------|-------------------|
| `closure:sparse:256`   | 1.00000 | [0.99999, 1.00001] | 0.9999986 | 0.98506 | 62979 / 62979 |
| `closure:sparse:1024`  | 1.00000 | [1.00000, 1.00000] | 1.0000002 | 0.96586 | 979983 / 979983 |
| `closure:dense:256`    | 1.00000 | [0.99999, 1.00001] | 1.0000012 | 0.94497 | 65536 / 65536 |
| `closure:dense:512`    | 1.00000 | [1.00000, 1.00000] | 1.0000004 | 0.93330 | 262144 / 262144 |
| `samegen:sparse:1024`  | 1.00000 | [1.00000, 1.00001] | 1.0000024 | 1.00420 | 258691 / 258691 |
| `samegen:dense:512`    | 1.00000 | [1.00000, 1.00000] | 1.0000011 | 1.00525 | 507425 / 507425 |
| `closure:blocks:4096`  | 1.00000 | [0.99997, 1.00003] | 0.9999943 | 0.93777 | 65536 / 65536 |
| `closure:blocks:16384` | 0.99999 | [0.99997, 1.00002] | 0.9999866 | 0.95964 | 262144 / 262144 |
| `cycle:blocks:4096`    | 1.00000 | [0.99997, 1.00002] | 0.9999947 | 0.95881 | 131072 / 131072 |
| `triangle:sparse:16384`| 0.99998 | [0.99995, 1.00002] | 0.9999751 | 0.98300 | 15 / 15 |
| `path3:sparse:4096`    | 1.00002 | [0.99996, 1.00007] | 1.0000205 | 0.97150 | 110213 / 110213 |
| `path3:sparse:16384`   | 1.00000 | [0.99997, 1.00003] | 1.0000109 | 1.01358 | 441937 / 441937 |
| `path4:sparse:4096`    | 0.99999 | [0.99997, 1.00000] | 0.9999937 | 0.93444 | 327629 / 327629 |
| `path4:sparse:16384`   | 1.00000 | [1.00000, 1.00001] | 1.0000016 | 1.00060 | 1322538 / 1322538 |
| `mutual:blocks:4096`   | 1.00007 | [0.99995, 1.00019] | 1.0000242 | 0.98643 | 61440 / 61440 |
| `mutual:blocks:8192`   | 1.00006 | [0.99992, 1.00020] | 1.0000581 | 0.99047 | 122880 / 122880 |
| `triangle:sparse:4096` | 0.99994 | [0.99984, 1.00003] | 0.9999475 | 0.99173 | 48 / 48 |
| `triangle:blocks:4096` | 1.00000 | [0.99999, 1.00001] | 1.0000001 | 1.00181 | 61440 / 61440 |

The largest deviation from unity over the eighteen cohorts is 7 parts in 100,000, on
`mutual:blocks:4096`, whose own A/A null on the same run is 2.4 parts in 100,000 and whose interval
contains unity. Derived, probe and candidate counts and the output digest agree on every cohort.

**The symbol comparison settles it more firmly than the counters do.** `Demand::evaluate_into` is a
fourteen-byte thunk that tail-calls one `evaluate_counting` instantiation. In both binaries that
callee is the 0x87e6-byte, 7,659-instruction instantiation, and its normalized disassembly is
**identical instruction for instruction** across the two arms. The grounded producer's kernel,
`Prepared::evaluate_into` at 0x1f8 bytes and 118 instructions with `Prepared::propagate` inlined
into it, is likewise identical.

The only kernel-shaped difference anywhere near this path is in the *other* `evaluate_counting`
instantiation, the one the `COUNT` const generic selects and which only `--count-probes` reaches:
36,489 bytes and 7,898 instructions before, 36,452 bytes and 7,893 instructions after. The whole
difference in its call multiset is **one fewer `core::panicking::panic_bounds_check`** — 123 calls
becomes 122, one elided bounds check on a cold panic path — with the rest being register and
alignment scheduling around it. Nothing on the production path moved, and this instantiation is not
in any timed loop.

So the card's worry that a crate boundary would disturb this kernel does not materialize, and the
0.8–1.7 % excursions this kernel has shown under unrelated edits do not recur here.

### 2. Frontend and backend stages: all but one within the null

`bench.py` against the retained control, five rounds, both scanner variants, stages
`scan,parse,admit,lower,stratify`, over the five Rel cohorts and then the `datalog` cohort. The
counter set ran at 100 per cent enabled on every one of the 341 measurements in the `datalog` run
and likewise in the cohort run; load average over the rounds was 1.3–3.3.

Fifty-six candidate-over-control comparisons on the five Rel cohorts, and the largest deviation
from unity in instructions is **2 parts in 100,000** (`comment-string/scan/byte` and
`comment-string/parse/byte-null`, the latter being the run's own drift null). Nothing on the
scanner, parser, admission or lowering stages moves.

The `datalog` cohort is the only one that reaches the stratified backend, and it does move:

| Operation | Instructions, split ÷ control | 95 % interval |
|--------------------------|--------|--------------------|
| `datalog/stratify/byte`  | 1.00071 | [1.00071, 1.00071] |
| `datalog/stratify/scalar`| 1.00071 | [1.00071, 1.00071] |
| `prepare`                | 1.00005 | [0.99994, 1.00016] |
| `datalog/parse/byte`     | 1.00002 | [1.00000, 1.00004] |
| `datalog/parse/byte-null`| 1.00002 | [1.00001, 1.00003] |
| `datalog/scan/scalar`    | 0.99998 | [0.99998, 0.99999] |
| the remaining six        | 1.00000 | width ≤ 2e-5 |

The stratify interval is degenerate because the instruction count is deterministic: the stage
retires 1,684,818,752 instructions per iteration on the control and about 1.19 million more on the
candidate. Every other operation sits at the run's null of 2 parts in 100,000.

**This is not really an item-2 result.** The Rel cohorts' `stratify` figures are identical to their
`lower` figures to the instruction (`ascii/stratify/byte` 3,937,315 against `ascii/lower/byte`
3,937,314): a Rel dictionary never reaches the backend, so those rows measure lowering twice. The
`datalog` cohort's stratify stage is the only operation in the whole frontend set that runs the
stratified backend, and that stage is precisely item 3 — it admits one contract program per layer,
evaluates it, emits both certificates and runs both of the core's independent checkers. The 0.071
per cent therefore belongs to item 3 and is diagnosed there.

### 3. The real exposure: the carriers, `support::check`, and the two Datalog checkers

**What has a driver and what does not.** The derivation and ranked checkers have one: the
`datalog/stratify` stage above runs both of them per iteration, inside an interleaved, two-point
differenced, counter-based A/B with its own null. The grounded replay and `support::check` have
**no driver at all**, and the reason is stronger than "nobody wrote one": `composition_graph` and
`ergodis_verify::support` do not appear in the symbol table of `closure_ballpark`, `ergodis-tools`
or the core `ergodis` binary on either arm, so no existing executable in either repository reaches
them. `ab.py --mode full` cannot substitute, because its two-point differencing over the evaluation
repeat count cancels the certificate and checker passes, which run once per process. Rather than
write a new benchmark for a pure code move, both paths are read from the compiled code, in the one
release artifact that does instantiate them.

**The carriers are still inlined; `support::check` is still inlined.** Read from the release build
of `crates/rules`'s `contract_properties` test, retained as an arm on each side
(`rules-contract-properties-96aee9b`, measured sha256
`a63989ff8609634c27b967310a2665fb91475475ceda7063589af372131c9bee`, and
`rules-contract-properties-83eec12`, measured sha256
`23e4d63cfdba64d2cc54b9a8b6b0b3c482e5a407c96a39a5b7dcc2a89c84c157`; recipe
`../ergodis-dev/scripts/retain-bin.sh crates/rules contract_properties --test --label
rules-contract-properties`). Neither binary defines a single out-of-line symbol for any
`TransitionWeight` method of `BoundedMinPlus` or `Boolean`: all ten are inlined into their callers
on both arms, which is what rustc's cross-crate heuristic for tiny functions plus thin LTO is
supposed to do. Of the three `composition_graph::propagate` instantiations, two are identical
instruction for instruction across the arms (492 and 494 instructions); the third goes from 495 to
491 instructions with the **same set of nineteen call targets** — `finish_grow`, `free`, `memcpy`,
`memset`, `panic_bounds_check`, `len_mismatch_fail` and `_Unwind_Resume`, none of them a carrier
method — so the difference is register allocation and alignment, not a lost inline.
`grounded::support_check` is 0x2cf bytes for both carriers on both arms, with `support::check`
inlined into it, and the producer's `Prepared::support_certificate` is 0xe11 bytes on both. The
outer `verify_support` wrapper, which does schema and binding checks and is not a loop, shrinks
from 0x296 to 0x24f bytes.

**`Admitted::tuple` lost its inline; `Admitted::pack` did not.** In the control, neither method
exists as an out-of-line symbol anywhere: both are inlined at every call site. In the candidate,
both appear as out-of-line functions in `ergodis-tools` and in `closure_ballpark`, and
`Admitted::tuple` is **called through the GOT from exactly two places in each binary** —
`ergodis_verify::ranked::check_admitted_bounded` and
`ergodis_verify::derivation::check_admitted_bounded`, the two checkers' load passes, which call it
once per listed tuple. `Admitted::pack` is emitted but has no call site in either binary, so it is
still inlined where it is used. The two load passes shrink accordingly —
`derivation::check_admitted_bounded` from 0x14c9 to 0x12e8 bytes and
`ranked::check_admitted_bounded` from 0x2858 to 0x2616 — which is the body of `tuple` leaving the
loop and a call taking its place.

That is the cause of the 0.071 per cent on `datalog/stratify`, it is a loss outside the null on an
item-3 path, and it is exactly the shape the decision rule admits a repair for.

### 4. The repair: one attribute on `Admitted::tuple`

Core commit `f7b0d16` adds `#[inline]` to `Admitted::tuple` in `crates/contract/src/datalog.rs`,
with a comment naming the two load passes and the boundary, and nothing else. `Admitted::pack` does
**not** get the attribute, because the disassembly shows it inlined at every site it is actually
called from; giving it one would be a guess rather than a measurement. The ten `TransitionWeight`
methods do not get it either, for the same reason.

Retained as `closure_ballpark-inline-55dab0c`, measured sha256
`478f9e9c361e7677c6f8dade4c7802ee92f1604c26bd954407fd6e00bf98de85`, and
`ergodis-tools-inline-55dab0c`, measured sha256
`b6b666e761eea8380b49abbeb2c62d7f64f6f97dbf1f733def7ce6476b88bb21`, both at private `55dab0c` and
core `f7b0d16`, from a clean tree, by the same two recipes with `--label` added to keep them apart
from the pre-repair arms at the same private revision.

**The attribute did what the disassembly predicted.** `Admitted::tuple` has no out-of-line symbol
in either rebuilt binary, and neither `tuple` nor `pack` has a single call site left;
`derivation::check_admitted_bounded` grows from 0x12e8 to 0x13a8 bytes and
`ranked::check_admitted_bounded` from 0x2616 to 0x272b as the body returns to the loop. Both stay
below their pre-split sizes (0x14c9 and 0x2858), so the recovered code is scheduled differently
from the control's, not restored to it.

**Counters after the repair**, `ergodis-tools-inline-55dab0c` against the same pre-split control,
`datalog` cohort, five rounds, load average 1.9–3.3:

| Operation | Instructions, repaired ÷ control | 95 % interval | Before the repair |
|--------------------------|--------|--------------------|---------|
| `datalog/stratify/byte`  | 0.99953 | [0.99953, 0.99953] | 1.00071 |
| `datalog/stratify/scalar`| 0.99953 | [0.99953, 0.99953] | 1.00071 |
| `prepare`                | 1.00003 | [1.00000, 1.00007] | 1.00005 |
| `datalog/parse/byte`     | 1.00001 | [0.99999, 1.00004] | 1.00002 |
| `datalog/parse/byte-null`| 1.00001 | [0.99999, 1.00002] | 1.00002 |
| the remaining seven      | 1.00000 | width ≤ 2e-5 | 1.00000 |

The stratified backend stage goes from 1,683,620,476 instructions per iteration on the control to
1,682,835,524 on the repaired candidate: the 0.071 per cent loss becomes a **0.047 per cent win**,
785,000 instructions per iteration better than the tree before the split. Nothing else moves.

The five Rel cohorts were rerun with the repaired binary as well — 56 comparisons, counter set at
100 per cent enabled on all 1,622 measurements, load average 1.1–1.9 — and the largest deviation
from unity is 4 parts in 100,000 on `prepare`, against a run null of 3 parts in 100,000 on
`comment-string/parse/byte-null`. No scan, parse, admit or lower operation moves.

**The derivation loop is unaffected by the repair.** The eighteen-cohort `ab.py` run against the
same control gives a worst deviation of 5 parts in 100,000 (`triangle:sparse:4096`, null
1.4e-5, interval containing unity), derived and probe counts and output digests equal on every
cohort, and — the firmer statement — the production `evaluate_counting` instantiation and
`Prepared::propagate` are **still identical instruction for instruction** to the control's.

### The identity the repair moves

`#[inline]` is a source edit under `crates/contract/src`, so the contract identity moves one more
time, exactly as the card anticipates for any such edit:

| Identity | Value |
|--------------------------------|------------------------------------------------------------------|
| contract, at `83eec12` | `85346c30659b5f5d8ddd5f36a7659a2d9eae13e206b3a08292e3112afe0504b2` |
| contract, at `f7b0d16` | `2b68f01e3995ff310017539d6c1cbbc339ba3452eac65e959a52e131ae434100` |
| checker, unchanged by the repair | `0ea8d53f610945bdcb867341aa8fcdae6e6d3b7580518856179b48bf34cf6498` |

The new value is an offline recomputation of `implementation_identity()` — SHA-256 over
`ergodis/finite-rule-contract/v1` followed by the eight `HASHED_SOURCES` files in their listed
order — and the same recomputation applied to the file bytes at `83eec12` reproduces
`85346c30…04b2` digit for digit, which is what licenses the method. No tracked file in either
repository pins the old value, so nothing else needed regenerating beyond `SHA256SUMS`. The repair
commit carries the source edit, the regenerated `SHA256SUMS` and nothing else, and it passed
`cargo fmt --check`, `cargo clippy --all-targets --all-features -D warnings` and
`cargo test --all-features` (84 `test result: ok` blocks, zero `FAILED`) under the pinned
toolchain in the same commit.

### Verdict against the card's acceptance line

The card asks that "the derivation loop and the frontend/backend stages hold against the retained
controls within the A/A null, with the compiled `evaluate_into` compared". They do.

1. **Derivation loop:** within the null on all eighteen cohorts, and the compiled kernel
   `Demand::evaluate_into` tail-calls is byte-identical to the control's, before and after the
   repair. The grounded producer's `Prepared::evaluate_into` and `Prepared::propagate` are
   identical too.
2. **Frontend and backend stages:** within the null on every scan, parse, admit and lower
   operation across six cohorts and both scanner variants.
3. **The exposure paths:** the carrier methods and `support::check` are still inlined, and the
   three `composition_graph::propagate` instantiations carry the same call sets. The one lost
   inline the move produced, `Admitted::tuple` in both Datalog checkers' load passes, was found in
   the disassembly, cost 0.071 per cent of the stratified backend stage, and is repaired by one
   attribute; the repaired arm is 0.047 per cent *ahead* of the pre-split tree on that stage.

**Unexplained movement, stated plainly.** Three small things are observed and not explained. The
counted `evaluate_counting` instantiation lost one `panic_bounds_check` call and five instructions
across the move, on a path no timed run enters. The `verify_support` wrapper shrank from 0x296 to
0x24f bytes, and one of the three `propagate` instantiations moved by four instructions with an
unchanged call set — both are scheduling under a changed module summary, neither is on a measured
path, and no counter can see them because nothing links those symbols. After the repair the two
checker load passes sit between their split and pre-split sizes rather than returning to either,
which is why the repaired stage is faster than the control rather than equal to it; the direction
is favourable and the cause is ThinLTO's inlining order, not a semantic difference.

### Receipts and commits

| Repository | Commit | What |
| --- | --- | --- |
| `ergodis` | `f7b0d16` | `#[inline]` on `Admitted::tuple`, with the regenerated `SHA256SUMS` |
| `ergodis-private` | `a082a07` | the eight receipts, four from `ab.py` and four from `bench.py` |
| `othello` | this section | written incrementally as each arm was measured |

The receipts are `analysis/datalog-comparison/ab-2026-09-21-c1209-derivation-loop.json` and
`-inline.json` with their streamed `.jsonl` companions, and
`analysis/rel-frontend/performance-v11-c1209-split-55dab0c.json`,
`-split-datalog-55dab0c.json`, `-inline-55dab0c.json` and `-inline-datalog-55dab0c.json`. Each
carries its arms' binary hashes, the event set, the per-event enabled fraction, the load average
over the rounds, the per-operation ratios with intervals and the nulls.

### Replay commands

Every build, gate and measurement went through `nix develop ~/src/ergodis`, whose devShell asserts
its rustc equals the `rust-toolchain.toml` pin. Working files under `~/.cache/ergodis/c1209/`.

```sh
# The control worktrees. The private workspace resolves the core by the relative
# path ../ergodis, so the pair must sit side by side under one parent.
mkdir -p ~/.cache/ergodis/worktrees/c1209
git -C ~/src/ergodis worktree add --detach \
    ~/.cache/ergodis/worktrees/c1209/ergodis 96aee9b
git -C ~/src/ergodis-private worktree add --detach \
    ~/.cache/ergodis/worktrees/c1209/ergodis-private 55dab0c^

# The arms. Each retained with its tree at the named revision and `git status
# --short` empty, checked before the recipe ran.
cd ~/.cache/ergodis/worktrees/c1209/ergodis-private
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example      # private 74f974c, core 96aee9b
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools         # private 74f974c, core 96aee9b
cd ~/src/ergodis-private
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example      # private 55dab0c, core 83eec12
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools         # private 55dab0c, core 83eec12
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --label closure_ballpark-inline
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools --label ergodis-tools-inline
# the last two: private 55dab0c, core f7b0d16

# The release test binaries that instantiate the grounded replay and
# support::check, which no driver in either repository links.
cd ~/.cache/ergodis/worktrees/c1209/ergodis
../ergodis-dev/scripts/retain-bin.sh crates/rules contract_properties --test \
    --label rules-contract-properties                                   # core 96aee9b
cd ~/src/ergodis
../ergodis-dev/scripts/retain-bin.sh crates/rules contract_properties --test \
    --label rules-contract-properties                                   # core 83eec12

# Gates for the repair, core, at f7b0d16. Outcome: exit 0, 84 `test result: ok`
# blocks, zero FAILED; clippy and fmt clean.
cd ~/src/ergodis
nix develop . --command python3 python/generate_evidence.py --write
nix develop . --command cargo fmt --all -- --check
nix develop . --command cargo clippy --all-targets --all-features -j 12 -- -D warnings
nix develop . --command cargo test --all-features --no-fail-fast -j 12

cd ~/src/ergodis-private
A=analysis/datalog-comparison; B=analysis/rel-frontend
C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1209
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
ALL=closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512,closure:blocks:4096,closure:blocks:16384,cycle:blocks:4096,triangle:sparse:16384,path3:sparse:4096,path3:sparse:16384,path4:sparse:4096,path4:sparse:16384,mutual:blocks:4096,mutual:blocks:8192,triangle:sparse:4096,triangle:blocks:4096

# The derivation loop, before and after the repair. Outcome: 0.99994 to 1.00007,
# then 0.99999 to 1.00005.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-74f974c \
    --a-name control-74f974c --b $C/closure_ballpark-55dab0c --b-name split-55dab0c \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-evaluate --out $A/ab-2026-09-21-c1209-derivation-loop.json
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-74f974c \
    --a-name control-74f974c --b $C/closure_ballpark-inline-55dab0c --b-name inline-f7b0d16 \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-evaluate-inline --out $A/ab-2026-09-21-c1209-derivation-loop-inline.json

# The frontend and backend stages over the five Rel cohorts, before and after.
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-55dab0c \
    --control $C/ergodis-tools-74f974c --rounds 5 --cpu 5 \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-c1209-split-55dab0c.json
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-inline-55dab0c \
    --control $C/ergodis-tools-74f974c --rounds 5 --cpu 5 \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-c1209-inline-55dab0c.json

# The datalog cohort, whose stratify stage is the only operation that runs the
# stratified backend and both checkers. Outcome: 1.00071, then 0.99953.
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-55dab0c \
    --control $C/ergodis-tools-74f974c --rounds 5 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-c1209-split-datalog-55dab0c.json
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-inline-55dab0c \
    --control $C/ergodis-tools-74f974c --rounds 5 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-c1209-inline-datalog-55dab0c.json
```

The symbol comparisons are `nm -C --defined-only --print-size` over each pair of binaries for the
size and presence questions, and `objdump -d -C --no-show-raw-insn` restricted to one symbol's
address range, with branch targets rewritten relative to the function start and RIP displacements
elided, for the instruction-for-instruction questions.

Inputs are deterministic: `ab.py` drives the C1182 xorshift edge generator seeded by the domain for
the `sparse` and `dense` densities and a complete digraph inside each block for `blocks`, and
`bench.py` builds its cohorts from a fixed definition count with a recorded per-cohort source hash.

### What this measurement left under `~/.cache/ergodis/`

Eight retained binaries: `closure_ballpark-74f974c` and `ergodis-tools-74f974c` (the controls),
`closure_ballpark-55dab0c` and `ergodis-tools-55dab0c` (the split as built),
`closure_ballpark-inline-55dab0c` and `ergodis-tools-inline-55dab0c` (the repair, and **the
controls the next A/B in this lane should use**), and `rules-contract-properties-96aee9b` and
`-83eec12` (the release test binaries the carrier and `support::check` inlining was read from).
`ergodis-96aee9b` and `ergodis-83eec12` were also retained, to establish that the core binary does
not link the grounded replay; they carry no figure. `c1209/` holds the two `ab.py` work
directories. No `perf record` profile was taken: every measurement is a `perf stat` A/B through
`ab.py` or `bench.py`. Two git worktrees under `worktrees/c1209/` were removed with
`git worktree remove` at close.

`../ergodis-dev/scripts/cache-gc.sh` was run in its listing mode and **nothing was deleted; that is
Tavis's call.** It scanned 43 entries and reports 21 unreferenced and old enough to remove, none of
them this task's: `audit-c1198` (68K), `c1190-audit` (107K), `c1190-milestone-c-audit` (168K),
`c1191` (49K), `c1191-audit` (524K), `c1192-audit` (8.9M), `c1193` (18M), `c1193-audit` (72K),
`c1198` (16M), `c1199-audit` (3.8M), `c1200` (4.1M), `c1201` (16M), `c1201-audit` (248K),
`c1202-audit` (35M), `c1203` (26M), `perf-c1191` (423K), `perf-c1192` (572K), `perf-c1193` (185K),
`perf-c1193-replay` (8.3M), `perf-c1198` (317K) and `rel-frontend-parity` (134K), plus `wt` (9.0K)
which it names with the three reports that reference it. `worktrees` at 105 MB is kept only because
it is younger than two days, and other lanes' worktrees live there.
