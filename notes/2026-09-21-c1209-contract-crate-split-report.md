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
