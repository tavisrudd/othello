# C1213 — Datalog schema and contract/checker provenance: report

**Lane**: `ergodis`
**Card**: `notes/2026-09-22-c1213-datalog-schema-provenance.md`
**Authority**: `notes/2026-09-22-c1208-follow-up-triage.md` (decision 4)

Worktrees, branch `c1213`: core `~/.cache/ergodis/worktrees/c1213/ergodis` from core `main`
`61116a3`; private `~/.cache/ergodis/worktrees/c1213/ergodis-private` from private `main` `e50545e`.

Status: implemented and gated (core `378f146`, `4b57649`; private `39390e1`, `b7bcff2`, all on
`c1213`). Both branches fast-forward from their start points. Core `main` has not moved. Private `main`
has moved three commits (`d8b901a`), which is reported below and not merged.

## Design

### Starting point, verified in the worktree

- One wire schema string, `rule_contract::SCHEMA = "finite-min-plus-rules.v1"`, is demanded by
  both `rule_contract::ground` (grounded language: domain ≤ 32, arity ≤ 3, bodies of one or two
  atoms, either carrier, symmetries allowed) and `datalog::admit` (Datalog language: domain ≤
  65,536, arity ≤ 4, bodies up to four atoms, Boolean only, no symmetries). Both hash the wire
  identity with `rule_contract::identity_of`, which prefixes `SCHEMA` to the program's JSON. A
  `Program` value therefore does not say which language it is in (C1204 F6).
- The prepared route is already separate: `datalog::PREPARED_SCHEMA =
  "finite-boolean-prepared-rules.v1"`, identity `SHA-256(PREPARED_SCHEMA ‖ 0x00 ‖ encoding)`,
  `encode_prepared`/`decode_prepared`/`prepared_identity`, and `check_prepared` in both checkers
  (C1205 milestone a, core `a92050a`, `c73ed85`). The prepared bytes carry no tag of their own;
  the tag is in the identity.
- `DerivationCertificate` carries `schema`, `source_id`, `fact_count` and the trace;
  `RankedCertificate` carries `schema`, `source_id` and the ranked relations. Neither names a
  contract or a checker (C1204 F13, confirmed by C1208 item 7/13).
- The only verification record in core is `binary_composition::VerificationRecord` (record
  schema 2). It is minted by the checker only on success, inside the opaque capability
  `VerifiedRestriction`, names both `checker` and `contract` identities, and `replay` re-runs the
  check and compares the record field for field. The Datalog checkers mint nothing.
- Callers that feed a wire program to the Datalog door: `Demand::new`/`new_bounded` (core), the
  core tests `demand.rs`, `demand_nary.rs`, `demand_sparse.rs`, `demand_prepared.rs`,
  `workspace_commit.rs`, `allocation.rs`, `crates/verify/tests/prepared_source.rs`; private
  `examples/closure_ballpark.rs` (which hands the *same* program to the grounded `Prepared::new`
  and to `Demand::new_bounded`) and `src/rel_lowering.rs::project`. The private Rel driver
  (`rel_stratified.rs`) uses the prepared route only.
- The grounded ABI (`ergodis-rules` provider, native and WASM harnesses) reaches the grounded
  route only (C1208 item 12) and uses `closure.json` as its Boolean program.

### 1. Schemas and dispatch

Three source schemas, each admitted by exactly one door:

| Schema string | Language | Admitted by | Refused with `Error::Schema` by |
|---|---|---|---|
| `finite-min-plus-rules.v1` (`rule_contract::SCHEMA`, unchanged) | grounded, either carrier | `rule_contract::ground`, hence `grounded::verify`/`verify_support`, `Prepared::new`, the runtime, the C ABI | `datalog::admit`, hence `Demand::new`, `derivation::check`, `ranked::check` |
| `finite-boolean-datalog-rules.v1` (new `datalog::DATALOG_SCHEMA`) | Datalog, Boolean only | `datalog::admit`, hence `Demand::new`, `derivation::check`, `ranked::check` | `rule_contract::ground` and everything behind it |
| `finite-boolean-prepared-rules.v1` (`datalog::PREPARED_SCHEMA`, unchanged) | the Datalog language in prepared form | `admit_prepared`, `decode_prepared`, `check_prepared` | not a wire schema: a wire program carrying it is refused by both wire doors |

Rules:

- The wire format (`Program` and its JSON) is unchanged; only the value of `schema` selects the
  language. A Datalog program still declares `semiring: "boolean"` and `stability: 0`, and
  `symmetries` stays empty; those checks and their error values are unchanged.
- Dispatch is strict string equality. Anything else — the empty string, another version of
  either family (`…rules.v0`, `…rules.v2`), a missing version suffix, a case or whitespace
  variant, a trailing NUL, the prepared or a certificate schema used as a program schema — is
  `Error::Schema` at both doors. There is no version negotiation and no fallback from one
  language to the other. Structured refusals that tell "unknown version" from "other language"
  are C1206's.
- `datalog::admit`'s checks keep their order; the schema test just compares against
  `DATALOG_SCHEMA` instead of `SCHEMA`. `ground` is byte-for-byte unchanged in behaviour: the
  grounded language keeps its meaning, identity and certificates.
- The checker wire entries (`derivation::check`, `ranked::check`) admit through
  `datalog::admit`, so they dispatch the same way; as today, an admission refusal is
  `Rejection::Binding` at the checker boundary (C1205 audit I2, unchanged here).
- `rule_contract::parse_rules` is language-neutral (it builds rules, not programs) and is
  unchanged. The provider `DESCRIPTOR`'s `"schema"` field names the grounded schema, which is
  correct because the ABI is grounded-only; unchanged.

### 2. Identities: what each binds

| Identity | Definition | Binds | Changes in this task |
|---|---|---|---|
| grounded wire source identity | `SHA-256("finite-min-plus-rules.v1" ‖ JSON(program))` (`identity_of`, `FactStream`) | the whole `Program`: schema field, carrier, domain, relation order, constants, fact order and duplicates, rules, symmetries | no |
| Datalog wire source identity (new) | `SHA-256("finite-boolean-datalog-rules.v1" ‖ 0x00 ‖ JSON(program))`, a new `datalog::wire_identity(&[u8])` | the same fields of a Datalog-schema program | new; every Datalog wire identity moves (§5) |
| prepared source identity | `SHA-256("finite-boolean-prepared-rules.v1" ‖ 0x00 ‖ encoding)` | domain, relation names/arities/input flags and order, rules with canonical variable numbering, the sorted deduplicated fact set | no |
| certificate digest (new, record only) | `SHA-256(certificate_schema ‖ 0x00 ‖ canonical bytes)`; for the two JSON families the canonical bytes are `serde_json::to_vec` of the decoded struct | the whole certificate content, including its header | new |
| contract identity | `ergodis_contract::implementation_identity()`: `SHA-256("ergodis/finite-rule-contract/v1" ‖ the contract package's sources)` | the formats, schema constants, admission code of every door, identity definitions, encoder and decoder. This is admission's contract identity: the identity of the admission code a checker ran | moves (source edits); tag unchanged, the hashed list keeps its composition |
| checker identity | `ergodis_verify::implementation_identity()` over `RULE_ID`, `RULE_VERSION`, the domain tag and the checker package's sources | the checker code of every family, including the new record module | moves; the domain tag goes `…/v3` → `…/v4` because the hashed list gains a module, per the tag's own documented rule |
| plan fingerprint | none | — | stays out of every certificate and record: a verdict must not depend on the plan (F13) |

The Datalog wire identity takes the prepared route's construction (tag, a zero byte, then the
bytes) rather than the grounded one (tag, then the bytes). Both are unambiguous — JSON starts
with `{`, which no tag contains — but the separator makes the new identity prefix-free by
construction rather than by an argument about JSON, and matches the only other tag-plus-bytes
identity in the Datalog contract. The grounded construction is left exactly as it is.

A wire program and a prepared source can never share an identity (different tags), and neither
can the two wire languages (different tags and a different `schema` field in the hashed JSON).

### 3. Certificates versus verification records

**Certificate (producer's claim).** Unchanged in both families. Its header is its only
metadata and every header field is a claim the checker verifies, never provenance it trusts:

| Field | Derivation | Ranked | Checked as |
|---|---|---|---|
| `schema` | `finite-boolean-derivation-certificate.v1` | `finite-boolean-ranked-certificate.v1` | equality, else `Binding` |
| `source_id` | wire Datalog or prepared identity | same | equality with the identity the checker computes by re-admitting, else `Binding` |
| `fact_count` | declared facts | — | equality, else `Binding` |

No contract or checker identity is added to a certificate. A certificate is a claim about a
source; a producer's statement of which contract or checker it used is unverifiable, cannot
change the verdict, and would read as a claim that checking happened. Producer-side provenance
that is worth keeping (the producer's build revision, the `Policy`, the row bound, the body
policy) belongs to the evidence bundle that pairs a certificate with its run — C1205 milestone
b's layer record and the bench receipts — not to the certificate. `deny_unknown_fields` already
makes a certificate that carries an extra `checker` field undecodable, and a test pins that.

Consequence: prepared-route certificates stay byte-identical, and only wire-route certificates
change, solely because their `source_id` moves with the source identity. **Decision for Tavis
(D1)** below.

**Verification record (checker's output).** New, in a new checker-package module
`ergodis_verify::datalog_record`, modelled on `binary_composition::VerificationRecord`:

```rust
pub const RECORD_SCHEMA: &str = "finite-boolean-datalog-verification.v1";

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct VerificationRecord {
    pub schema: String,             // RECORD_SCHEMA
    pub source_schema: String,      // DATALOG_SCHEMA or PREPARED_SCHEMA: the door re-admitted through
    pub source_id: [u8; 32],        // the identity this checker computed by re-admitting
    pub certificate_schema: String, // DERIVATION_SCHEMA or RANKED_SCHEMA
    pub certificate: [u8; 32],      // certificate digest, §2
    pub contract: [u8; 32],         // ergodis_contract::implementation_identity() of the checking build
    pub checker: [u8; 32],          // ergodis_verify::implementation_identity() of the checking build
}

pub enum Source<'a> { Wire(&'a Program), Prepared(&'a [u8]) }

pub struct Verified { relations: Relations, record: VerificationRecord } // no public constructor, not Deserialize
```

- **Minted only after success, only by a re-admitting entry.** New entries
  `derivation::check_recorded(Source, &DerivationCertificate, direct_limit)` and
  `ranked::check_recorded(Source, &RankedCertificate, direct_limit)` re-admit the source through
  its door (`datalog::admit` or `datalog::decode_prepared`), run the unchanged
  `check_admitted_bounded`, and only on `Ok` build the record and return `Verified`. A rejection
  returns the rejection and no record. `check_admitted` gets **no** recording sibling: it checks
  against the caller's own admitted object, so a record from it would claim a re-admission that
  did not happen. The existing `check`, `check_bounded`, `check_prepared`,
  `check_prepared_bounded`, `check_admitted`, `check_admitted_bounded` keep their signatures and
  behaviour, so `Demand::verify`/`verify_ranked` and the timed Rel stratify stage are untouched.
- **A record is evidence, never a capability.** `Verified` has private fields and no
  `Deserialize`, pinned by `compile_fail` doctests as `VerifiedRestriction` is. A deserialized
  `VerificationRecord` is plain data: it proves nothing until `replay` reproduces it.
- **Replay.** `datalog_record::replay_derivation(Source, &cert, &record, direct_limit)` and
  `replay_ranked(…)` re-run `check_recorded` and compare the fresh record with the supplied one.
  They return `Verified` only on equality, and otherwise a `ReplayError` that names the first
  differing field in declaration order (`Schema`, `SourceSchema`, `SourceId`,
  `CertificateSchema`, `Certificate`, `Contract`, `Checker`), or `Rejected(Error)` when the check
  itself fails. A record minted by another build (a different `contract` or `checker`) does not
  replay against this build and must be rechecked, which mints a fresh record; this is the
  binary-composition receipts' existing policy.
- **Record decoding.** `decode_verification_record(&[u8])`, bounded by
  `rule_contract::MAX_BYTES` (`Error::Budget` above it; a record is a few hundred bytes), JSON
  errors and unknown fields `Error::Source`. An unknown or malformed `schema` value decodes but
  fails replay with `ReplayError::Record(Schema)`; the record schema is checked before any other
  field.
- **What the record leaves out, on purpose.** No digest of the established relations: the least
  model is a function of the source, `Verified::relations()` returns it, and C1205 milestone b
  owns relation and chain digests with their own domain separation (its card's "record digests
  get domain separation" bullet). No plan fingerprint (F13). No timestamp or host.
- **Both families of one source.** The derivation record and the ranked record of one source
  agree on `source_schema`, `source_id`, `contract` and `checker` and differ in
  `certificate_schema` and `certificate`; a test pins that.

### 4. The prepared route

- `PREPARED_SCHEMA`, the encoding grammar, `encode_prepared`, `decode_prepared`,
  `prepared_identity`, `MAX_PREPARED_BYTES` and every existing prepared source identity are
  unchanged. No separate justification for changing them exists: the prepared tag is already
  distinct from both wire schemas, and the prepared language already equals the Datalog
  language (the same budgets through the same `Error` values).
- `check_prepared`/`check_prepared_bounded` stay as they are; `check_recorded` with
  `Source::Prepared` is the recording door over the same decode.
- `SourceForm` keeps both variants; `SourceForm::Wire` now always holds a Datalog-schema program,
  because `Demand::new` admits nothing else. A new `SourceForm::schema() -> &'static str` returns
  `DATALOG_SCHEMA` or `PREPARED_SCHEMA`, the value a record's `source_schema` takes.
- `Demand::prepared_encoding`'s return type (C1205 audit L6) is milestone b's decision and is not
  touched.

### 5. Migration table

Old and new hexes are recorded under "Identity table" during implementation, printed by the
running code at `61116a3` and at the new commits.

| Item | Changes | Why | Handling |
|---|---|---|---|
| `rule_contract::SCHEMA` value | no | the grounded language keeps its string and meaning | `datalog::admit` stops accepting it |
| `datalog::DATALOG_SCHEMA` | new | F6: one string per language | — |
| grounded wire identities, grounded certificates, `distance.certificate.json`, the evidence transcript `evidence/2026-09-12-recursive-runtime-transcript.json`, `contract_properties.proptest-regressions` | no | grounded path untouched | native and WASM ABI harnesses rerun to show byte-identical certificates; the Lean audit gate's Rust-side fixtures regenerated and diffed |
| Datalog wire identities (every program through `Demand::new` or `check`) | yes | new tag, separator, and the `schema` value inside the hashed JSON | recomputed by the new code |
| wire-route derivation and ranked certificates | yes, via `source_id` only | the source identity they bind moved | the six wire digests and three wire source identities pinned in `crates/rules/tests/demand_prepared.rs` are replaced by values printed by the new code; the test also asserts the old wire values are no longer produced, so the move is deliberate and visible |
| prepared identities and prepared-route certificates | no | prepared route untouched, certificates unchanged (D1) | the three prepared identities and six prepared certificate digests in `demand_prepared.rs` and `prepared_source.rs` stay as literals and must pass unedited |
| `closure.json`, `same_generation.json` | no | they are also the grounded Boolean fixtures (`boolean.rs`, `docs/rule-contract.md`, `native_abi.py`) | Datalog tests derive the Datalog view in-test with a one-line helper that sets `schema = DATALOG_SCHEMA`, making "same rules in two languages" explicit |
| `mutual_recursion.json` | yes, `schema` field only | used only by Datalog and prepared tests | edited to `DATALOG_SCHEMA`; its prepared identity is unaffected (the prepared form never reads the wire schema) |
| `crates/rules/tests/demand.proptest-regressions` | no | the strategy keeps generating grounded-schema programs, because grounded admissibility is the oracle's precondition; the property test derives the Datalog view after generation, consuming no randomness | the seed regenerates the identical case, and its shrink comment stays literally accurate; no re-pin |
| contract identity | yes | contract sources edited | old and new printed; not pinned in any tracked file (C1209 and C1205 searched; searched again before commit) |
| checker identity | yes | new module, new entries, tag `v3` → `v4` | as above; `tests/admission_pipeline.rs`'s `assert_ne!` against the pre-extraction value still holds; binary-composition receipts written under the old identity stop replaying and are rechecked, which is the identity's purpose; none is stored |
| `SHA256SUMS` | yes | hashed trees change | `python3 python/generate_evidence.py --write` in each core commit |
| `docs/rule-contract.md` | yes | it documents only the grounded schema | a short section naming the Datalog schema, its identity, and the record; no task IDs |
| private `src/rel_lowering.rs::project` | yes | it emits Datalog-only programs (n-ary bodies) consumed by `Demand::new` | `schema: DATALOG_SCHEMA` |
| private `examples/closure_ballpark.rs` | yes | it hands one program to both doors | the grounded arm gets `SCHEMA`, the Datalog arm `DATALOG_SCHEMA`; the rows it reports (derived counts, `output_sha256`) do not depend on the schema |
| private `analysis/rel-frontend/coverage-v1.json` | no | a dated artifact whose prose names the old schema (C1209 open item 2) | left as a historical record; flagged, not re-pinned |
| historical receipts (C1205 and C1209 A/B JSONs, identity tables in their reports) | no | measurements of their own revisions | never re-pinned; new values appear only in this report, labelled with the commit that produced them |

### 6. Compatibility with C1196 and C1205 milestone b

- **C1196 (rank runs, round-block encoding).** A new certificate encoding is a new certificate
  schema string with its own canonical bytes and its own checker entry. The record keys a
  certificate by `(certificate_schema, digest of its canonical bytes)`, so a compact-form entry
  mints a record with its own schema and the digest of the compact bytes, and `RECORD_SCHEMA`
  does not change. Every encoding must carry the same binding header (schema, `source_id`, and
  `fact_count` for derivations); nothing else is required of it, so the compact form's
  bytes-per-tuple budget is unaffected by provenance. C1196 builds on the prepared door, which
  this task leaves unchanged, so its baseline is C1205 a's plus this task's wire identities. The
  C ABI's format tag (C1216) can be these schema strings.
- **C1205 milestone b (stratified chains on disk).** Each layer is a prepared source, so layer
  identities are unaffected. The chain stores per layer the encoding, both certificates and
  their digests; if it uses this task's certificate digest, its digests and a record's
  `certificate` field agree by construction. The offline verifier checks each layer with
  `check_recorded(Source::Prepared(bytes), …)` and can emit or `replay` records. A stored record
  is never trusted input: the verifier recomputes it. Chain-level records, relation digests,
  `Externals` and the L6 return type remain milestone b's decisions.

### 7. Performance

Fermi, before implementing: `datalog::admit` hashes 15 more bytes per admission (tag 24 → 31,
separator 1, the `schema` value in the JSON 24 → 31), so at most one extra SHA-256 compression and
7 more serialized bytes per admission, zero per tuple. It is reached by `Demand::new` and the
wire checker entries: in private `closure_ballpark`'s `cold` and `certificates` modes, not in
its `evaluate` mode's derivation loop, and not in the Rel stratify stage, which admits prepared
sources. `ground`, `admit_prepared`, `check_admitted_bounded` and the evaluator do not change.
Predicted: derivation loop and Rel stages 1.00000; `cold` mode within its null.

Gate, per the playbook (read in full before measuring): retain controls from the worktree base
(core `61116a3`, private `e50545e`) and candidates from the new commits; compare every
`ergodis_rules::demand::` symbol and the checker symbols the stratify stage reaches with
`symbol_disasm.py`. If they are identical, the derivation loop and stratify need no A/B, as for
C1205's repairs; any difference gets the interleaved A/B with counters. The `cold` mode gets a
short interleaved A/B on two cohorts to confirm the admission Fermi.

### 8. Test plan

Contract crate (`datalog.rs` unit tests):

1. The same rules and facts under each wire schema: `ground` admits the grounded one and refuses
   the Datalog one with `Error::Schema`; `admit` the reverse. The two identities differ; the
   Datalog identity equals `wire_identity(encode_source(program))` and the grounded one
   `identity_of(…)`. Replaces the current test that asserts the two are equal.
2. Unknown and malformed schema table at both doors, including through `decode_program`: the
   empty string, `…datalog-rules.v0`, `…v2`, no suffix, upper case, leading space, trailing NUL,
   `PREPARED_SCHEMA`, `DERIVATION_SCHEMA`: `Error::Schema` every time.
3. The three-atom boundary test restated: admitted under the Datalog schema; under the grounded
   schema refused by `ground` with `Error::Source` and by `admit` with `Error::Schema`.

Checker crate (`crates/verify/tests/`, extended and one new file):

4. Wire door: a certificate of the Datalog view is accepted; the same program under the grounded
   schema is refused (`Binding`); a legacy certificate whose `source_id` is the old identity,
   computed in the test by the old construction, is refused against both schemas.
5. Regimes: a prepared certificate against the wire door and a wire certificate against the
   prepared door are refused (existing tests moved to the Datalog view); a record from one door
   fails replay through the other (`SourceSchema`).
6. Records: minted by `check_recorded` for both families and both doors, with `source_schema`,
   `source_id`, certificate digest (recomputed in the test), `contract` and `checker` as
   specified; a rejected certificate yields no record; the two families' records of one source
   agree and differ exactly as §3 says.
7. Replay: each record accepted; every single-field mutation refused naming that field; a record
   whose `schema` is unknown or malformed refused as `Schema`; a record paired with a mutated
   certificate refused as `Certificate`; a record with a forged `checker` or `contract` refused
   naming it (the forged-field pattern of the binary-composition forgery test).
8. Decoding: a record with an unknown field, non-JSON bytes and bytes above the bound are
   refused; a certificate carrying an extra `checker` field is refused at decode.
9. `compile_fail` doctests: `Verified` can be neither constructed outside the package nor
   deserialized.

Rules crate:

10. `demand_prepared.rs` pins: prepared rows unchanged, wire rows the new values, old wire
    values asserted absent.
11. `Demand::new` refuses a grounded-schema program with `Error::Schema`.
12. The property test and every existing Demand test pass through the Datalog view; the grounded
    oracle still runs on the grounded view.

Harnesses: native and WASM ABI byte-identical certificates; private `cargo test` including
the Rel parity digest and the reference-evaluator differential.

### 9. Commit plan and gates

Core, on `c1213` (each commit carries its own regenerated `SHA256SUMS`):

1. "Give the Datalog admission its own wire schema": `DATALOG_SCHEMA`, `wire_identity`,
   `admit`'s dispatch, `SourceForm::schema`, docstrings that currently say the two paths share an
   identity, `mutual_recursion.json`, the Datalog views in core tests, the re-pinned wire rows,
   `docs/rule-contract.md`. This must be one commit: the tree fails its tests between the source
   change and the test changes.
2. "Mint verification records for Datalog certificates": `datalog_record.rs`, the two
   `check_recorded` entries, replay, record decoding, the tag `v4`, tests 4–9.

Private, on `c1213`, after core 1: `rel_lowering::project` and `closure_ballpark` schemas. Then
the A/B receipts, if any measurement is needed (§7).

Othello: this report, updated as each step lands.

Gates for each core commit: `cargo fmt --all -- --check`; `cargo clippy --all-targets
--all-features -- -D warnings`; `cargo test --all-features`; `python3 python/generate_evidence.py
--write`; `python3 python/generate_fixtures.py --check` (the Python parity differential; the Rust
side and `dynamic_updates_match_independent_python_oracle` run inside `cargo test`);
`python3 scripts/check-runtime-dependencies.py`. After core 1: the native ABI harness and the
WASM ABI harness, and the Lean audit gate's Rust-side fixtures diffed. After the private commit:
private `cargo fmt --check`, `cargo clippy --all-targets --all-features -- -D warnings`,
`cargo test --all-features` (includes `tests/rel_reference_eval.rs` and `tests/rel_lowering.rs`).
All builds under `run-quiet`, heavy runs under `choom -n 1000` with at most 12 jobs.

### Decisions for Tavis

Both taken as recommended (Tavis, 2026-09-22): provenance lives only in the verification
record and certificates are unchanged (D1); dispatch is strict, with no legacy door (D2).
Where records are stored — the on-disk chain, tool output, evidence bundles — is left to the
callers; C1205 milestone b is the first.

**D1 — where provenance lives.**
Recommendation: certificates carry no contract or checker identity; both live only in a record
minted after a successful re-admitting check. Prepared certificates stay byte-identical and C1196's
compact forms carry nothing extra.
Alternative: certificates gain an informational `producer_contract` field that the checker echoes
into the record. Every certificate and both certificate schemas then move to `v2`, prepared
certificates included, for a field no verdict may read.

**D2 — legacy wire Datalog programs under the grounded schema.**
Recommendation: strict dispatch. The Datalog door refuses the grounded schema, so certificates
bound to the old wire identity become uncheckable. None is stored outside test pins, and their
producers re-emit.
Alternative: the Datalog door also admits grounded-schema Boolean programs, restricted to the
grounded language and bound under the old identity. That keeps old certificates checkable, but
it leaves one `Program` value admissible by two doors, which is the ambiguity F6 is about.

Choices stated rather than asked, each reversible within this task: the new identity uses
the prepared construction with a zero separator (§2); the record omits a relations digest and
leaves chain digests to C1205 b (§3); the record module and entries are new functions, and no
existing checker signature changes (§3).

## Implementation

Written incrementally.

### Commits

| Repository, branch | Commit | What |
|---|---|---|
| core `c1213` | `378f146` | Datalog wire schema, `wire_identity`, strict dispatch, `SourceForm::schema`, test views, re-pinned wire rows, `mutual_recursion.json`, `docs/rule-contract.md`, `SHA256SUMS` |
| private `c1213` | `39390e1` | `rel_lowering::project` emits `DATALOG_SCHEMA`; `closure_ballpark` writes the Datalog schema and converts to the grounded one for its grounded arm (outside the timed region) |
| core `c1213` | `4b57649` | `datalog_record` module (record, `Source`, `Verified`, digests, decoding, replay), `derivation::check_recorded`, `ranked::check_recorded`, checker tag `v4`, record tests, `sha2` dev-dependency for `ergodis-rules`, the user-facing page `docs/datalog-certificates.md` linked from `docs/verification.md` and `docs/README.md`, `SHA256SUMS` |
| private `c1213` | `b7bcff2` | A/B receipts (see "Performance") |
| othello `main` | this report | design `79d2b18fd`, decisions `4d7bfe6d0`, then this implementation record |

The documentation page was folded into `4b57649` instead of being a third core commit. It
describes the record API that commit adds, and each commit must carry a `SHA256SUMS` that
describes its own tree.

### Identity table

Implementation identities recomputed offline from the committed sources by the documented
construction; the script reproduces C1205's recorded `a92050a` values digit for digit
(contract `2be5a1f2…7bb2a`, checker `2efe8b6c…c521a4`), which licenses the method.

| Identity | base `61116a3` | `378f146` | `4b57649` |
|---|---|---|---|
| contract | `dae904ed8764ec9a61d36a226677b2bcd33011f0503ed6fe894c88a12e6d7d49` | `d3658cced2af09ab02a88266907a90047b65c2ff305866bb2a186ac27c21cebf` | `d3658cced2af09ab02a88266907a90047b65c2ff305866bb2a186ac27c21cebf` |
| checker | `efa1074500b1bb7436245d04e921fda1ddb16f72b265336d2a154b76f905924a` (tag `v3`, 10 files) | `df8fe0c45c1a2643e73c8cd04ec99a15ff20b29f9e87c540b0e584902998a8b7` (`v3`, 10) | `12ac13d9450e060256cebb319dba42e35017af2ca36d9394075708778eb122e5` (`v4`, 11) |

The checker identity moves at `378f146` because `datalog_store.rs`'s test module now builds
its program under the Datalog schema. It moves again at `4b57649`: the new module, the two
entries, and the tag. No tracked file in either repository pins any of these values; the search
covered both worktrees, excluding `SHA256SUMS`.

Source identities and certificate digests (`identity_of` over the certificate JSON, as the
pinned test defines them). Old values are the pinned test's literals, which that test asserts at
`61116a3`; new ones were printed by the running code at `378f146`. The new wire
source identities were also recomputed independently in Python from the fixture JSON
(`SHA-256(tag ‖ 0x00 ‖ compact JSON)`), and the same script reproduces the three old values under
the old construction.

| Fixture, route | Source identity old → new | Derivation digest old → new | Ranked digest old → new |
|---|---|---|---|
| closure, wire | `f22e5918…1c3aa4` → `49e1436e…60c5912` | `76f25a38…18244c` → `de1edb06…4590f5` | `d297c98a…440fc0` → `01516b56…a20227` |
| same generation, wire | `691a3478…8a50f8` → `d22e4719…1979ce` | `6e488f46…c15fb5` → `2e62780e…f4a704` | `d3e7f321…35731d` → `f5c2e559…a4f687` |
| mutual recursion, wire | `15cd1558…fc7b66` → `58fe0d6d…cb42b60` | `e76d45ae…30b0a6` → `13b24590…995495` | `bf67e113…aab5c` → `eb240022…665a6c` |
| closure, prepared | `7f987bdd…bb6082` unchanged | `5360dca7…d541b6` unchanged | `e34e6082…4c1767` unchanged |
| same generation, prepared | `0e333c41…93d2f2` unchanged | `45356bc3…27903e` unchanged | `97d921fc…105660` unchanged |
| mutual recursion, prepared | `c49a237e…d1f9be` unchanged | `935469a0…4680f3` unchanged | `00258c12…f99512` unchanged |

Full hexes: `crates/rules/tests/demand_prepared.rs::the_identities_and_certificates_of_both_routes_are_pinned`,
which also asserts that the old wire identities are the grounded construction over the
grounded-schema programs and that no Datalog plan produces them.

### Gates

Core at `378f146`, under `nix develop` of the worktree:

| Gate | Result |
|---|---|
| `cargo fmt --all -- --check` | clean (after `cargo fmt` reformatted two test hunks) |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo test --all-features --no-fail-fast` | exit 0, 85 `test result: ok` blocks, zero FAILED |
| `python3 python/generate_evidence.py --write` | `SHA256SUMS` regenerated in the commit |
| `python3 python/generate_fixtures.py --check` | exit 0 (the Rust side of parity and the 512-update Python oracle run inside `cargo test`) |
| `python3 scripts/check-runtime-dependencies.py` | passed |
| native ABI harness | passed; `native.json` and `native-cert.json` byte-identical to the same harness run at base `61116a3` (detached base worktree) |
| WASM ABI harness | "129 programs, native certificate and Python oracle parity, lifecycle gates passed" |
| Lean audit gate, Rust-side inputs | `lean_boundary_fixtures` regenerated all seven files byte-identical to `lean/WeightedRules/fixtures/round-convention/` |

The detached base worktrees are `~/.cache/ergodis/worktrees/c1213-base/{ergodis,ergodis-private}`
at `61116a3`/`e50545e`, used for the ABI baseline and for retained controls.

Core at `4b57649`: `generate_evidence.py --write`, `cargo fmt --check`, `cargo clippy
--all-targets --all-features -D warnings` (clean after one `type_complexity` fix in the new test),
`cargo test --all-features` (exit 0, 85 `ok` blocks, zero FAILED), `generate_fixtures.py --check`,
`check-runtime-dependencies.py` and `check-verifier-dependencies.py` ("the contract and four
approved external direct dependencies … no solver or host package"): all passed in one run. The
native ABI harness passed again with output byte-identical to base, and the WASM ABI harness
passed. The first native release build hit a stale-rlib collision with the base worktree's
build in the shared target ("no `DATALOG_SCHEMA` in `datalog`"). Rebuilding the affected crate
(after `touch crates/contract/src/lib.rs`) fixed it.

Private at `39390e1` against core `378f146`: `cargo fmt --check` and `cargo clippy --all-targets
--all-features -D warnings` clean; `cargo test --all-features` exit 0, 40 `ok` blocks, 1,172
passed, 0 failed (17 min), including `tests/rel_reference_eval.rs` (the reference-evaluator
differential) and `tests/rel_lowering.rs` (the parity digest). Against the final core `4b57649`:
clippy clean on every target, and those two suites again passed, 53 and 19 tests. The full
private suite was not rerun against `4b57649`: that commit adds checker API and moves the checker
identity, and no private source calls either.

### Tests

| Test | Where | Establishes |
|---|---|---|
| `each_wire_schema_is_admitted_by_exactly_one_door` | `crates/contract/src/datalog.rs` | the same rules under each schema: each door admits its own and refuses the other's with `Error::Schema`; two identities; the grounded one is `identity_of`, the Datalog one `wire_identity` and not the grounded construction over the same bytes |
| `unknown_and_malformed_schemas_are_refused_at_both_doors` | same | twelve values (empty, `…v0`, `…v2`, no suffix, upper case, leading space, trailing NUL, grounded `v2` and unsuffixed, the prepared, derivation and ranked schemas) refused by both doors and after a JSON round trip; the grounded schema refused by `admit`; `SourceForm::schema` |
| `a_three_atom_body_is_admitted_here_and_refused_by_the_grounded_path` | same, restated | admitted under the Datalog schema; under the grounded one `ground` gives `Source` and `admit` `Schema` |
| `the_wire_door_binds_to_the_datalog_identity_only` | `crates/verify/tests/prepared_source.rs` | on all three fixtures: reference certificates accepted by both wire checkers; the same certificates rebound to the old shared identity refused under either schema; the grounded-schema program refused |
| `the_identities_and_certificates_of_both_routes_are_pinned` | `crates/rules/tests/demand_prepared.rs` | the identity table above; the old wire values are the grounded construction and no Datalog plan produces them; the grounded-schema program is refused by `Demand::new` |
| `a_successful_recorded_check_issues_the_record_it_attests` | same | both families × both doors × three fixtures: the recording entries return the unrecorded entries' relations; every record field is as specified, and the certificate digest is recomputed in the test independently of the module; the two families' records agree on source and build and differ in the certificate |
| `a_refused_check_issues_no_record` | same | forged identity and dropped relation give the rejection and no record; a certificate of one regime is refused through the other door |
| `a_stored_record_replays_only_as_issued` | same | serialize, decode, replay; each of the seven single-field changes refused naming that field; four unknown or malformed record schemas refused as `Schema` before a broken certificate is even checked; a broken certificate with a genuine record is `Rejected`; a different valid ranked certificate (ranks doubled) against the original's record is `Certificate`; a derivation record replayed as ranked is `CertificateSchema` |
| `records_and_certificates_decode_strictly` | same | a record with an extra field, non-JSON, and input above the bound are refused; a derivation certificate carrying a `checker` field is refused at decode |
| two `compile_fail` doctests | `crates/verify/src/datalog_record.rs` | `Verified` can be neither constructed outside the package nor deserialized |
| `generated_programs_agree_and_certify` and every other Demand test | `demand.rs`, `demand_nary.rs`, `demand_sparse.rs`, `workspace_commit.rs`, `allocation.rs` | unchanged assertions, now run under the Datalog schema; the grounded oracle runs under the grounded schema |

Regression seeds: `crates/rules/tests/demand.proptest-regressions` is untouched. The strategy
still generates grounded-schema programs and the property converts after generation, so the seed
replays the identical case and its shrink comment stays accurate. The grounded
`contract_properties.proptest-regressions` is untouched as well.

### Performance

Fermi, before implementing (§7): wire admission gains at most one SHA-256 compression and seven
serialized bytes per call. The derivation loop, `admit_prepared`, the checkers' loops and every
Rel stage are unchanged in source.

Arms, all retained with `~/src/ergodis-dev/scripts/retain-bin.sh` from clean trees, rustc 1.95.0
(59807616e 2026-04-14) read from each binary's `.comment`, release profile, default features:

| Arm | Core | Private | Recipe | Measured sha256 |
|---|---|---|---|---|
| control `closure_ballpark` | `61116a3` | `e50545e` | `retain-bin.sh . closure_ballpark --example --label closure_ballpark-c1213-base` in the base worktree | `84526ae6…575138f5` |
| control `ergodis-tools` | `61116a3` | `e50545e` | `retain-bin.sh tasks/tools ergodis-tools --label ergodis-tools-c1213-base` | `4551cc1d…8155b9c7` |
| candidate `closure_ballpark` | `4b57649` | `39390e1` | same recipe, label `closure_ballpark-c1213-4b57649` | `c216b46a…2f79f21a` |
| candidate `ergodis-tools` | `4b57649` | `39390e1` | same recipe, label `ergodis-tools-c1213-4b57649` | `30ecbb79…ff2181` |

Symbol comparison (`analysis/datalog-comparison/symbol_disasm.py`, every symbol under the named
prefixes, per name and rank): in `closure_ballpark`, 39 of 50 `ergodis_rules::demand::` symbols
are identical. `evaluate_counting` is the same size (`0x8e79`) and differs in one region: 64 diff
lines, a register swap in three `cmov`s and a reordering of four stack-slot zero stores. That is
a code-generation difference, not a source one. In `ergodis-tools`, 78 symbols across the
frontend, lowering and backend differ, with ThinLTO inlining moves (23 GOT entries present in one
arm only). Both differences put a timed stage's machine code in play, so both got the A/B.

| Measurement | Receipt (private) | Result, instructions candidate ÷ control |
|---|---|---|
| derivation loop, 18 cohorts, `ab.py --mode evaluate --rounds 5 --cpu 5 --repeats 3` | `analysis/datalog-comparison/ab-2026-09-22-datalog-schema-derivation-loop.json` | 0.99996 to 1.00001, every interval within ±0.00018 of unity except `triangle:sparse:4096` at 0.99996 [0.99994, 0.99999], a 48-tuple cohort (null 1.0000014); derived counts identical on every cohort; A/A nulls 0.99996 to 1.00006 |
| frontend and backend stages, five cohorts, `bench.py --rounds 5 --cpu 5 --stages scan,parse,admit,lower,stratify` | `analysis/rel-frontend/performance-v11-datalog-schema-4b57649.json` | every stage 1.00000 except `comment-string/scan/scalar` 0.99999 and `malformed-early/parse/byte` 0.99999; `prepare` 1.00001 [0.99993, 1.00009]; A/A nulls 1.00000; load 1.6 to 5.8 |
| the `datalog` cohort, whose stratify stage runs the stratified backend and both checkers | `analysis/rel-frontend/performance-v11-datalog-schema-datalog-4b57649.json` | stratify 1.00000 on both scanners; every other stage 0.99999 to 1.00000; A/A null 0.99999; load 4.6 to 6.7 |

Verdict: no timed stage moved. The derivation loop's code-generation difference costs nothing
measurable. Cycle ratios in the receipts range 0.95 to 1.06 under load 5 to 6 and settle
nothing. Wire admission itself, the one timed code whose source changed, is not isolated by any
committed stage: `ab.py` differences two repeat counts, which cancels per-process work, and the
Rel stages admit prepared sources. It stays an estimate (open item).

### Deviations

- **The record tests live in `crates/rules/tests/demand_prepared.rs`**, not in a new
  checker-crate test file as §8 put it. They need certificates from both regimes, and the
  evaluator plus that file's prepared-source helpers are the producer. The checker-crate
  schema test (`the_wire_door_binds_to_the_datalog_identity_only`) uses the checker crate's own
  reference producer. `ergodis-rules` gains `sha2` as a dev-dependency, so the test recomputes
  the certificate digest without calling the module under test.
- **The recording entries live in `derivation.rs` and `ranked.rs`** as §3 names them, and replay
  and the record types live in `datalog_record.rs`.
- **Documentation page added** at the coordinator's request: `docs/datalog-certificates.md`.
- **Detached base worktrees** were added under `~/.cache/ergodis/worktrees/c1213-base/` for the ABI
  baseline and the retained controls; they are registered in the core and private repositories.

### Divergence

Core `main` is still `61116a3`; core `c1213` (`4b57649`) fast-forwards onto it. Private `main`
has moved from `e50545e` to `d8b901a` (three commits: "Record Rel lowering metadata", "Record Rel
frontend metadata validation", "Clarify Rel metadata evidence"). Private `c1213` (`b7bcff2`)
fast-forwards onto `e50545e`, where `main` stood at the start, but not onto `d8b901a`. The moved
commits touch `analysis/rel-frontend/`, `tasks/tools/src/rel_frontend_bench.rs` and
`tests/rel_frontend_portability.rs`. None of those is a file this branch changes, so a merge
should not conflict. No rebase or merge was done.

### Mystery ledger

- **`evaluate_counting` changed in code generation although its source did not (settled as
  harmless, cause not isolated).** Same size; a three-`cmov` register swap and a store
  reordering in one region; the A/B reads 1.00000. `demand.rs` changed only in a doc comment
  and its test module. A register-allocation choice that moves with an unrelated edit to the
  module is consistent with what C1205 and C1209 saw under ThinLTO. It was not bisected, because
  the instruction count is unchanged.
- **`triangle:sparse:4096` at 0.99996 [0.99994, 0.99999] (settled as noise-level).** A 48-tuple
  cohort retiring few instructions per evaluation. The interval sits 4 parts in 100,000 below
  unity with its null at 1.0000014, and it is the only cohort whose interval excludes unity. It
  is consistent with the per-process heap-layout residual C1205's audit traced on
  `closure:sparse:256`.
- **The seven-byte `schema` value lengthens every Datalog certificate's wire source** but no
  certificate. The certificates carry only the 32-byte identity, so their size is unchanged.
  Settled; no mystery.

No other surprising feature remains.

### Open items

- **Wire admission cost is estimated, not measured.** No committed harness stage times
  `Demand::new` or `datalog::admit` alone. A per-call instruction count needs a driver, for
  example a `cold` stage that differences two admission counts. The estimate is at most one
  SHA-256 block and seven serialized bytes.
- **`Error::Schema` covers both "unknown version" and "other language"**, and every admission
  refusal is still `Rejection::Binding` at the checker boundary. Both are C1206's structured
  refusals.
- **Private `analysis/rel-frontend/coverage-v1.json`** still names the old schema in its prose. It
  is a dated artifact, so it was left as is and flagged.
- **Cache left under `~/.cache/ergodis/`:** the four retained binaries above, `c1213/`
  (the A/B working files) and the worktrees `worktrees/c1213-base/{ergodis,ergodis-private}`.
  `cache-gc.sh` was not run; deletion is Tavis's call.

### Replay commands

```sh
# Core, in ~/.cache/ergodis/worktrees/c1213/ergodis at 4b57649 (378f146 for the first gate set)
nix develop . --command bash -c 'python3 python/generate_evidence.py --write && cargo fmt --all -- --check \
  && cargo clippy -j 12 --all-targets --all-features -- -D warnings && cargo test -j 12 --all-features --no-fail-fast \
  && python3 python/generate_fixtures.py --check && python3 scripts/check-runtime-dependencies.py \
  && python3 scripts/check-verifier-dependencies.py'
nix develop . --command bash -c 'cargo build -j 12 -p ergodis-rules --release && python3 crates/rules/tests/native_abi.py \
  ~/.cache/ergodis/target/ergodis/release/libergodis_rules.so <scratch>/native.json <scratch>/native-cert.json'
# the same in the base worktree at 61116a3 into another scratch directory, then cmp both files
nix develop .#wasm --command bash -c 'cargo build -j 12 -p ergodis-rules --release --target wasm32-unknown-unknown \
  && node crates/rules/tests/wasm_abi.mjs ~/.cache/ergodis/target/ergodis/wasm32-unknown-unknown/release/ergodis_rules.wasm <scratch>/native.json'
L=~/src/othello/lean/WeightedRules/fixtures
nix develop . --command cargo run -j 12 --release -p ergodis-rules --example lean_boundary_fixtures -- <scratch> $L/distance.json $L/chain-distance.json
diff -rq <scratch> $L/round-convention

# Private, in ~/.cache/ergodis/worktrees/c1213/ergodis-private at 39390e1
nix develop ../ergodis --command bash -c 'cargo fmt --check && cargo clippy -j 12 --all-targets --all-features -- -D warnings \
  && cargo test -j 12 --all-features --no-fail-fast'

# A/B, arms as in the Performance table
A=analysis/datalog-comparison; B=analysis/rel-frontend; C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1213
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
nix develop ../ergodis --command python3 $A/ab.py --a $C/closure_ballpark-c1213-base-e50545e --a-name control-e50545e \
  --b $C/closure_ballpark-c1213-4b57649-39390e1 --b-name schema-4b57649 --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
  --cohorts <the eighteen cohorts of the C1205 replay> --work $W/ab-evaluate --out $A/ab-2026-09-22-datalog-schema-derivation-loop.json
nix develop ../ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-c1213-4b57649-39390e1 \
  --control $C/ergodis-tools-c1213-base-e50545e --rounds 5 --cpu 5 --stages scan,parse,admit,lower,stratify --events $E \
  --out $B/performance-v11-datalog-schema-4b57649.json
nix develop ../ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-c1213-4b57649-39390e1 \
  --control $C/ergodis-tools-c1213-base-e50545e --rounds 5 --cpu 5 --cohorts datalog --stages scan,parse,admit,lower,stratify \
  --events $E --out $B/performance-v11-datalog-schema-datalog-4b57649.json
# Identities: SHA-256 over the domain tag (the checker's preceded by RULE_ID and RULE_VERSION as
# four little-endian bytes) and each HASHED_SOURCES file in order, from the committed tree.
```
