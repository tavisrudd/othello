# C1205 — transferable evidence for the Rel route: report

**Lane**: `ergodis`
**Card**: `notes/2026-09-18-c1205-rel-transferable-evidence.md`

## Milestone a

Status: done, audited and repaired (core `a92050a`, repairs `c73ed85`, private receipts
`bfd79c9`). The prepared source has a canonical byte form whose hash is the unchanged prepared
identity; both checkers admit it for themselves; `Demand` names its source form and hands the
bytes out. Every prepared and wire identity and certificate digest recorded before the change is
unchanged, and the derivation loop is identical instruction for instruction. The backend stage
that admits prepared sources reads 0.99998, within that cohort's own A/A drift.

Repositories: core `~/src/ergodis` (start `2b71f67`, clean), private `~/src/ergodis-private`
(start `8de4932`, clean).

### Fermi, written before implementing

The change adds an encoder, a decoder, two checker entry points, a source enum in `Demand` and
two input bounds. None of it is on the derivation loop.

- **Derivation loop (`Demand::evaluate_into`).** No instruction of the loop changes. `Demand`
  gains an enum field in place of `Option<Program>`; the loop never reads it. Events removed or
  added per derived tuple: zero. Predicted instruction ratio 1.00000, with the usual ThinLTO
  exposure (a reshuffled import decision has moved this kernel by up to 1.7 per cent under
  unrelated edits before); the symbol comparison is the check.
- **`admit_prepared`.** The hashed byte stream is unchanged; only its producer becomes a generic
  function monomorphized over the hashing sink. Per encoded byte the work is the same window store
  and bounds test (about four to six instructions a byte), and the one-time `Admitted`
  construction moves the identity write after the encode. Predicted change: zero per byte, a few
  instructions per call, below the stage's null. The prepare stage and the `datalog` cohort's
  stratify stage (which admits one prepared layer per stratum) should read within the null.
- **Checkers.** `check_admitted` is untouched and stays the path `Demand::verify` takes, so the
  stratify stage runs the same checker code. The byte entries are new code no timed stage calls.
- **Certificate decoders.** One length comparison per decode. Not in a timed stage.
- **Peak RSS.** Unchanged: nothing is retained. The encoding is produced on request only.

### Design decisions

#### The encoding, byte by byte

All integers little-endian. `word` is a `u32` (4 bytes), `byte` is a `u8`. The identity is
`SHA-256(PREPARED_SCHEMA ‖ 0x00 ‖ encoding)` with `PREPARED_SCHEMA =
"finite-boolean-prepared-rules.v1"`, exactly the stream `admit_prepared` has always hashed.

```text
encoding   := word domain
              word relation_count
              relation * relation_count
              word rule_count
              rule * rule_count
              facts * relation_count          -- in relation order
relation   := word name_len, name_len bytes (the name), byte arity, byte input (0 or 1)
rule       := byte variables, byte body_len, atom (the head), atom * body_len
atom       := word relation, byte slot_count, slot * slot_count
slot       := byte 0, word constant  |  byte 1, word variable
facts      := word count, word * (count * arity)   -- tuples sorted ascending, distinct
```

Canonical means: every field as `admit_prepared` would write it for the source the bytes
describe. In particular the tuples of each relation are strictly increasing in lexicographic
order (which is the order of their mixed-radix keys, the order admission sorts by), variables are
numbered by first occurrence in body order, the input byte is 0 or 1, the slot tag is 0 or 1, and
nothing follows the last relation's facts.

#### Encoder

One private generic function `write_encoding<S: Sink>(&Admitted, &mut S)` writes the stream;
`Sink` has two implementations, the existing SHA-256 staging window and a `Vec<u8>`, each
monomorphized. `admit_prepared` builds its `Admitted` and streams it into the hashing sink, so it
still never materializes the encoding. The encoding is a function of the admitted form, because
admission sorts and deduplicates the facts and fixes the numbering, so the public encoder takes
`&Admitted`:

- `datalog::encode_prepared(&Admitted) -> Result<Vec<u8>, Error>` checks the fact layout that
  a prepared admission produces (relation-major facts, contiguous offsets, `index` equal to the
  position, `fact_count` equal to the number of facts; `Error::Source` otherwise, and this is what
  keeps the fact walk from indexing out of range on a hand-built `Admitted`), encodes, refuses an
  encoding above the decoder's bound with `Error::Budget`, and refuses with `Error::Binding`
  unless the bytes hash to the admitted `source_id`. As first committed (`a92050a`) that was
  the last check, and the claim here that it made the function "total over any `Admitted` and
  never wrong about what it returns" was false: the audit built a self-consistent `Admitted` with
  two tuples swapped whose bytes `encode_prepared` returned and the decoder refused. Since
  `c73ed85` the encoder also decodes its own bytes and returns them only when they decode to the
  given `Admitted` field for field, so every returned encoding is one a checker accepts; the cost
  is one decode per encode, on no timed path.
- `datalog::prepared_identity(&[u8]) -> [u8; 32]` recomputes the identity from bytes.

#### Decoder

`datalog::decode_prepared(&[u8]) -> Result<Admitted, Error>`, with the bound
`datalog::MAX_PREPARED_BYTES = 1 << 30` checked first (`Error::Budget` above it).

Output: an `Admitted` directly, but produced through `admit_prepared` itself. The decoder parses
the bytes into owned buffers (names, one slot pool, one atom list, one flat tuple pool), builds a
`PreparedSource` borrowing them and calls `admit_prepared`; then it re-encodes the result and
requires the bytes to be the input. Justification: every budget and rejection of the prepared
admission is enforced by the one function that defines it, not by a second copy that could drift;
the identity is the one admission computes; and the final comparison is the whole canonicality
condition in one line, covering fact order, duplicates and every field, instead of a list of
checks that could miss one. The cost is a second pass over the bytes and a second buffer of the
input's size, bounded by the input bound, on a path no timed stage runs.

Errors: truncation, trailing bytes, a slot tag or input flag other than 0 or 1, and an admissible
source in non-canonical form are `Error::Encoding`. Everything admission refuses is refused with
admission's own value. Two byte-level cases map to admission's value for the condition they are
an instance of: a name that is not UTF-8 is not an identifier (`Error::Source`), and a variable
word above 255 is necessarily at or above the rule's variable count (`Error::Source`). Before
any allocation each count is checked against the bytes that remain, so allocation is bounded by
the input length, and a relation or rule count above its budget is refused with `Error::Budget`
before the list is read. Since `c73ed85` a fact list that is not strictly increasing is refused
while it is parsed, without admission's sort: the rest of the source is admitted with no facts
so that a source admission would refuse still gets admission's value, then an out-of-domain fact
value is `Error::Source` and anything else `Error::Encoding`.

Bound: `datalog::MAX_PREPARED_BYTES = 1 << 30` bytes. The prepared route has no byte budget of
its own and `admit_prepared` takes any fact count. The bound admits some 268 million tuple values.
What a decode holds was first stated here as "each about the input's size, within a few GiB",
which the audit measured to be wrong by about two: per tuple the input, the parsed rows and the
admitted tuples are one times the input each, the fact record 1.5× (binary) to 3× (unary), and
admission's sort keys 2× to 4×; measured peak RSS on a 128 MiB input was 6.4× for a binary
relation, and reserved memory about 10×. So a decode at the bound holds some 7 to 10 GiB before a
checker allocates anything. I kept the bound and stated this multiple in the docstring rather
than reducing it: the committed cohorts need tens of MB, a caller with a smaller memory budget
refuses a large input before decoding, and a caller-supplied bound is a milestone-b decision
(open item). The one reduction made is that the out-of-order case no longer sorts before
refusing, and the parsed rows are released before the re-encoding is built. The largest cohorts in the committed benchmark
harnesses derive on the order of a million tuples, and their prepared inputs are smaller than
that. An admitted source whose encoding would exceed the bound is admitted in process but not
encodable, and `encode_prepared` says so with `Error::Budget` rather than producing bytes the
decoder refuses. Parsing sizes each buffer once from a count it has already checked against the
remaining input, so allocation is bounded by the input length and nothing grows.

#### Checker entry points

`ergodis_verify::derivation::check_prepared(&[u8], &DerivationCertificate)` and
`check_prepared_bounded(.., direct_limit)`, and the same pair in `ergodis_verify::ranked`. Each
decodes the bytes through `decode_prepared` (a refusal is `Rejection::Binding`, as the wire
entries treat an admission refusal) and runs `check_admitted_bounded` on the result.
`check_admitted` stays, documented as the in-process fast path for a producer that already
holds its own admitted form.

#### Source enum

`ergodis_contract::datalog::SourceForm`:

```rust
pub enum SourceForm {
    /// Checked by re-admitting the wire program (`admit`); wire identity.
    Wire(Program),
    /// Checked by decoding the canonical encoding (`decode_prepared`); prepared identity.
    Prepared,
}
```

The prepared variant carries no payload: the encoding is a function of the admitted form the
plan already holds, so a plan encodes on request and never keeps a second copy of its facts.
`Demand` holds `source: SourceForm` beside `admitted`; `Demand::source()` returns
`&SourceForm`; `Demand::prepared_encoding() -> Result<Vec<u8>, Error>` hands out the encoded
source (`Error::Schema` for a wire plan, whose transferable form is its program).
`Demand::verify`/`verify_ranked` behave as before: wire plans re-admit the program, prepared
plans take `check_admitted`.

#### Certificate decoder bound

`derivation::MAX_CERTIFICATE_BYTES = 1 << 30`, applied by both `decode_derivation_certificate`
and `decode_ranked_certificate` with `Error::Budget` above it, as `decode_program` applies
`MAX_BYTES`. `MAX_BYTES` (1 MiB) is a program budget; a derivation certificate lists a rule
index, one premise per body atom and the head's values per derived tuple, about forty JSON bytes
a tuple for a binary rule, so the million-tuple closures in the committed benchmark cohorts need
certificates of tens of megabytes. The bound is the same as the prepared source's, so a checker
that accepts a prepared source can also accept a certificate of the same order.

### Commits

| Repository | Commit | What |
| --- | --- | --- |
| `ergodis` | `a92050a` | encoder, decoder, `prepared_identity`, `SourceForm`, both `check_prepared` pairs, `Demand::source`/`prepared_encoding`, the certificate decoder bound, the new checker-crate tests, the pinned identities and certificate digests, regenerated `SHA256SUMS` |
| `ergodis-private` | `bfd79c9` | the A/B receipts: derivation loop, path-length null, Rel cohorts, `datalog` cohort |
| `ergodis` | `c73ed85` | repairs after the audit (see "Repairs after audit") |
| `othello` | this report | written incrementally |

### Identities

Recorded at `2b71f67` (before any source change) by the test that now pins them, and again at
`a92050a`. Certificate digests are `rule_contract::identity_of` over the certificate's
`serde_json` bytes.

| Fixture, route | Source identity | Derivation certificate digest | Ranked certificate digest |
| --- | --- | --- | --- |
| `closure.json`, wire | `f22e5918…1c3aa4` | `76f25a38…18244c` | `d297c98a…440fc0` |
| `closure.json`, prepared | `7f987bdd…bb6082` | `5360dca7…d541b6` | `e34e6082…4c1767` |
| `same_generation.json`, wire | `691a3478…8a50f8` | `6e488f46…c15fb5` | `d3e7f321…35731d` |
| `same_generation.json`, prepared | `0e333c41…93d2f2` | `45356bc3…27903e` | `97d921fc…105660` |

Old equals new on every cell; the full hexes are in
`crates/rules/tests/demand_prepared.rs::the_identities_and_certificates_of_both_routes_are_pinned`,
and the two prepared identities again in `crates/verify/tests/prepared_source.rs`.

Implementation identities, which move because their packages' sources changed:

| Identity | `2b71f67` | `a92050a` |
| --- | --- | --- |
| `ergodis_contract::implementation_identity` | `8e6e93e76f0e30578e9c941451bf8ac1614831ce8cd82ea30f924d46a8b15b77` | `2be5a1f23e5b164a5fddaad2315933fd2d20aaffbc3337fa5208952d55e7bb2a` |
| `ergodis_verify::implementation_identity` | `9f7ca68a319cdc40e4c78157b5d9d55668ea65f33aa13a047adb824359616ecb` | `2efe8b6cfbb19247df8c086c0cad9f60f8cc45c9c56ae5117298a8e1d2c521a4` |

The old values were printed by the running code at `2b71f67`; the new ones are recomputed from
the committed sources by the documented construction (a scratch script that reproduces both old
values exactly). What binds to them: `ergodis::admission::contract_identity` and
`checker_identity`, which a leaf-check receipt names, and the `contract` and `checker` fields of
`binary_composition::VerificationRecord`. Neither value is pinned in any tracked file of the core
or private repository (searched), so no receipt or evidence file is invalidated beyond what a
receipt's replay already states: a receipt written under the old identities no longer replays
against this build and is rechecked, which is the identities' purpose.

### Gates

Core at `a92050a`, all under `nix develop ~/src/ergodis`:

| Gate | Result |
| --- | --- |
| `cargo fmt --all -- --check` | clean |
| `cargo clippy --all-targets --all-features -j 12 -- -D warnings` | clean |
| `cargo test --all-features --no-fail-fast -j 12` | exit 0, 85 `test result: ok` blocks, zero FAILED (84 before; the new block is `prepared_source`) |
| `python3 python/generate_fixtures.py --check` | exit 0, but vacuous for this change (audit): it regenerates the Python oracle's fixtures and compares them with the committed files, and this change touches neither; the Rust side of parity (plan fingerprints, helper loads, parity digest) runs inside `cargo test` |
| `python3 scripts/check-runtime-dependencies.py` | passed |
| native ABI: release `ergodis-rules`, then `crates/rules/tests/native_abi.py` | "129 min-plus programs, one Boolean closure, independent oracle, source/claim/handle/capacity lifecycle gates passed" |
| wasm32 ABI: `nix develop .#wasm`, release wasm32 `ergodis-rules`, then `wasm_abi.mjs` | "129 programs, native certificate and Python oracle parity, lifecycle gates passed" |

### Tests

`crates/verify/tests/prepared_source.rs`, new. As committed in `a92050a` (the table below), its
certificates came from a naive reference producer written in the test (rounds of full
re-evaluation, derivations listed rule by rule within a round, rank equal to round). The claim
first written here, that this producer "lists derivations in an order the evaluator never emits",
was false for `closure.json`: the audit found its certificates byte-identical to the evaluator's
on that fixture, so the "producer cannot emit" coverage rested on `same_generation.json` alone.
The repair (`c73ed85`, see "Repairs after audit") makes the difference structural and asserts
it on every fixture. The byte
grammar is restated by a writer in the test and pinned to the encoder's output on the fixtures,
so each hand-built encoding is an encoding of the documented format.

| Test | What it establishes |
| --- | --- |
| `the_encoding_round_trips_and_keeps_the_recorded_identities` | on `closure.json` and `same_generation.json`: the identity equals the value recorded before the change; `encode_prepared` equals the test's restatement of the grammar; `prepared_identity(bytes)` is the admitted identity; `decode` gives the admitted source field for field; `encode ∘ decode` is the identity on the bytes |
| `the_encoding_is_of_the_fact_set_and_only_its_canonical_form_decodes` | reversed and repeated fact input admit to the same bytes; the decoder refuses those unsorted and repeated forms with `Error::Encoding` |
| `every_truncation_and_every_extension_is_refused` | every proper prefix of both fixtures' encodings, and one trailing byte of three values |
| `every_single_byte_change_is_refused_or_names_another_source` | every byte position times three xor masks: refused, or the canonical encoding of a different source whose identity is recomputed from the changed bytes; never the original |
| `the_decoder_refuses_what_admission_refuses_with_admissions_values` | twenty-two invalid sources (every admission budget and refusal, plus a non-UTF-8 name and a variable word above 255) give exactly `admit_prepared`'s error through the bytes; an input flag or slot tag of 2 and an oversized fact count are `Error::Encoding`; its input-above-the-bound case was vacuous (the zeroed input's domain of 0 is refused with the same `Error::Budget`) and was replaced by a separate test in `c73ed85` |
| `only_a_prepared_admission_is_encoded` | a wire admission, an `Admitted` relabelled with another identity, one with an edited domain, and three with a broken fact layout are refused |
| `certificates_are_checked_from_the_bytes_alone` | both checkers accept the reference producer's certificates through `check_prepared`, with the relations `check_admitted` gives, under both direct and sorted representations; the wire door refuses them |
| `a_certificate_binds_to_its_own_source_bytes` | a certificate of the closure is refused (`Binding`) against the bytes of the closure plus one fact and of the same-generation program; refused bytes refuse the certificate |
| `mutated_derivation_certificates_are_refused_through_the_bytes` | schema, identity, fact count, a dropped and a repeated derivation, trailing entries, every rule index, every premise (plus one and zeroed) and every tuple value: each refused, with the same rejection as `check_admitted` |
| `mutated_ranked_certificates_are_refused_through_the_bytes` | schema, identity, a dropped relation, a tuple on an input relation, every rank zeroed or lowered, every tuple dropped or repeated, a missing rank: each refused, with the same rejection as `check_admitted` |

`crates/rules/tests/demand_prepared.rs`, extended:

| Test | What it establishes |
| --- | --- |
| `the_identities_and_certificates_of_both_routes_are_pinned` | source identity and `identity_of` digests of the derivation and ranked certificate JSON, wire and prepared plans of both fixtures, against values recorded at `2b71f67` before any source change |
| `a_prepared_plan_has_no_wire_program_and_says_so` | `source()` is `SourceForm::Prepared` or `SourceForm::Wire(program)`; a wire plan's `prepared_encoding()` is `Error::Schema` |
| `a_prepared_plan_is_checked_from_its_encoding_alone` | the evaluator's own certificates, accepted by both `check_prepared` entries from `prepared_encoding()`, with the relations `verify` gives |

### Performance A/B

Controls retained before the first source change, from clean trees at private `8de4932`, core
`2b71f67`, rustc 1.95.0 (59807616e 2026-04-14), release profile, no features, through the core
flake's devShell:

```sh
cd ~/src/ergodis-private
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # closure_ballpark-8de4932
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools      # ergodis-tools-8de4932
```

Measured sha256 (recorded as measured, not cited): `closure_ballpark-8de4932`
`420c7c8ff8b8e4e731ff7aa874205cf86599e18f2e25d4958f6926f9cb62e3f8`, `ergodis-tools-8de4932`
`d4fbb502700b1e005980dd82fba1b5ff0b839678c1dd7f2c1ae4506a2e4271e0`. Both equal the previous
task's `-pack-a082a07` retains, as expected: `8de4932` differs from `a082a07` in receipts and
documents only.

Candidates, retained from the private tree at `8de4932` (clean) against the core at `a92050a`
(clean), same rustc, profile and features:

```sh
cd ~/src/ergodis-private
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --label closure_ballpark-bytes
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools --label ergodis-tools-bytes
```

Measured sha256: `closure_ballpark-bytes-8de4932`
`2c7b799eaa607c28d827ac255e89b598e39bfbd99e823d7069acc54deabd1e7f`, `ergodis-tools-bytes-8de4932`
`8ab276b50801f14e505543e23ac41d9dac5724a63db05fe3781a4f0a9a4d5b03`. `retain-bin.sh` records only
the private revision; the core revision of each arm is this report's record.

| Arm | Private | Core | Dirty | Retained name |
| --- | --- | --- | --- | --- |
| control, derivation loop | `8de4932` | `2b71f67` | no | `closure_ballpark-8de4932` |
| control, frontend and backend stages | `8de4932` | `2b71f67` | no | `ergodis-tools-8de4932` |
| candidate, derivation loop | `8de4932` | `a92050a` | no | `closure_ballpark-bytes-8de4932` |
| candidate, frontend and backend stages | `8de4932` | `a92050a` | no | `ergodis-tools-bytes-8de4932` |

Method: the playbook's, as the previous task ran it. Event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` at 100 per cent enabled,
five rounds alternating arm order, an A/A null per cohort, pinned to core 5, two-point
differencing (`repeats` 3 and 6). Instructions decide; cycles are reported and settle nothing on
this shared box. Bulk output under `~/.cache/ergodis/c1205/`.

#### The derivation loop

`ab.py --mode evaluate` over the eighteen cohorts of the previous task. Load average 1.43–1.75.
Receipt: private `analysis/datalog-comparison/ab-2026-09-22-prepared-bytes-derivation-loop.json`.

| Cohort | Instructions, candidate ÷ control | 95 % interval | A/A null | Cycles | Derived (both arms) |
| --- | --- | --- | --- | --- | --- |
| `closure:sparse:256` | 1.00004 | [1.00003, 1.00004] | 1.0000010 | 1.00297 | 62979 |
| `closure:sparse:1024` | 1.00000 | [1.00000, 1.00000] | 0.9999995 | 0.99651 | 979983 |
| `closure:dense:256` | 1.00000 | [0.99999, 1.00000] | 1.0000008 | 0.98975 | 65536 |
| `closure:dense:512` | 1.00000 | [1.00000, 1.00000] | 1.0000010 | 0.99338 | 262144 |
| `samegen:sparse:1024` | 1.00000 | [1.00000, 1.00000] | 1.0000007 | 1.01415 | 258691 |
| `samegen:dense:512` | 1.00000 | [1.00000, 1.00000] | 0.9999995 | 0.99677 | 507425 |
| `closure:blocks:4096` | 1.00000 | [0.99994, 1.00006] | 0.9999896 | 1.01379 | 65536 |
| `closure:blocks:16384` | 1.00001 | [0.99998, 1.00003] | 1.0000041 | 1.00459 | 262144 |
| `cycle:blocks:4096` | 0.99999 | [0.99997, 1.00001] | 1.0000146 | 0.98187 | 131072 |
| `triangle:sparse:16384` | 0.99999 | [0.99998, 1.00001] | 0.9999790 | 1.00733 | 15 |
| `path3:sparse:4096` | 1.00001 | [0.99995, 1.00006] | 1.0000272 | 0.98402 | 110213 |
| `path3:sparse:16384` | 0.99998 | [0.99996, 1.00001] | 0.9999982 | 1.00222 | 441937 |
| `path4:sparse:4096` | 1.00000 | [0.99998, 1.00002] | 1.0000046 | 0.99329 | 327629 |
| `path4:sparse:16384` | 1.00000 | [0.99999, 1.00001] | 0.9999991 | 1.00040 | 1322538 |
| `mutual:blocks:4096` | 1.00012 | [0.99989, 1.00035] | 1.0000005 | 1.02051 | 61440 |
| `mutual:blocks:8192` | 1.00004 | [0.99996, 1.00013] | 0.9999864 | 1.00353 | 122880 |
| `triangle:sparse:4096` | 1.00000 | [0.99988, 1.00012] | 0.9999871 | 0.95612 | 48 |
| `triangle:blocks:4096` | 0.99999 | [0.99998, 1.00000] | 0.9999982 | 1.00718 | 61440 |

Derived, probe, candidate and round counts and the output digest agree on every cohort. Peak RSS
agrees to within 8 KiB on every cohort (for example 91,228 against 91,224 KiB on
`path4:sparse:16384`).

The kernel is unchanged, instruction for instruction. Under the previous task's normalizer
(`analysis/datalog-comparison/symbol_disasm.py`), both `Demand::evaluate_counting`
instantiations (0x8e64 and 0x87e6 bytes) compare empty between the arms, and so does every
`ergodis_rules::demand::` and `ergodis_rules::` symbol in the binary at every size rank; the one
difference is `<Policy as Debug>::fmt`. The driver's own symbols differ only in offsets into a
string table. Every callee of the loop (`run_nary`, `index_rows`, `shape`, `clear_membership`,
`clear_indexes`, libc `memset`) is among the identical symbols.

One cohort sits outside its null: `closure:sparse:256` at 1.00004 with an interval excluding
unity, about 1,500 instructions on 38.7 million per evaluation. With every symbol the loop
reaches identical, this is not a code change in the loop. A renamed copy of the control (a path
eight bytes longer) run against the control on the same cohort reads 0.999999, so the binary's
path length is not the cause. The previous task's final arm read 1.000038 against its control on
the same cohort. See the mystery ledger.

#### Frontend and backend stages

`bench.py` against the retained control, five rounds, both scanner variants, stages
`scan,parse,admit,lower,stratify`, over the five Rel cohorts and then the `datalog` cohort, the
only cohort whose stratify stage runs the stratified backend (one prepared admission per layer,
evaluation, both certificates and both checkers through `check_admitted`). Counters at 100 per
cent enabled on all 1,623 and 340 measurements. Load average 1.17–2.36 and 1.73–2.23, from each
receipt. Receipts: private `analysis/rel-frontend/performance-v11-prepared-bytes-a92050a.json`
and `performance-v11-prepared-bytes-datalog-a92050a.json`.

Rel cohorts: fifty-six candidate-over-control comparisons, and the largest deviation from unity in
instructions is 3 parts in 100,000, on `prepare` (0.99997, interval [0.99986, 1.00009]); every
other operation reads 1.00000 to five places.

| Operation (`datalog` cohort) | Instructions, candidate ÷ control | 95 % interval | Per iteration |
| --- | --- | --- | --- |
| `datalog/stratify/byte` | 0.99998 | [0.99998, 0.99999] | 1,683,070,216 against 1,683,095,806: 25,590 fewer |
| `datalog/stratify/scalar` | 0.99998 | [0.99998, 0.99999] | |
| `prepare` | 1.00006 | [1.00006, 1.00007] | 33,666 against 33,663: 3 more (the Rel-cohort run read 0.99997 for the same operation) |
| the remaining nine | 0.99999 to 1.00001 | each containing or within 1e-5 of unity | |

Page faults per stratify iteration 4,914.7 against 4,918.2.

`admit_prepared` itself changed shape as the Fermi allowed: `write_encoding::<Streaming>` is now
its own 0x1c33-byte symbol, called once per admission, and `admit_prepared` shrank from 0x19e4
to 0x11ad bytes. Both before and after, `Streaming::word` is an out-of-line call (eight sites
before, five after) and SHA-256's compression is reached through the same dispatch. Both
checkers' `check_admitted_bounded` compare empty between the arms.

#### Verdict against the Fermi

The derivation loop is unchanged instruction for instruction, as predicted. The backend stage
that runs the prepared admission reads −1.5 × 10⁻⁵ (25.6 thousand instructions per iteration
fewer), but that is not evidence of a code effect in either direction: the `datalog` cohort's
own A/A drift in the same run reads 1.000015 [0.999995, 1.000035], the same magnitude (audit).
Nor can it be said to be "inside the size the Fermi allowed", as first written here, because the
Fermi's "a few instructions per call" was never turned into a number (admissions and encoded
bytes per iteration were not counted). What stands is that no stage moves beyond its null except
the small-cohort residual in the derivation-loop harness, which the audit traced to heap
behaviour outside the loop (mystery ledger). Peak RSS is unchanged. Nothing is retained, so no
evidence enters the hot loop.

### Deviations

- **One core commit instead of five.** The card's suggested sequence (encoder and decoder,
  checker entries and tests, the `Demand` enum, the certificate bounds) became one commit,
  `a92050a`. The checker-crate tests exercise the encoder, decoder and entries together, the
  `Demand` tests exercise the entries, and every commit must carry a `SHA256SUMS` that describes
  its tree, so the intermediate states would have needed separate manifests and separate gate
  runs for no reviewable gain. The commit message lists the parts.
- **No private code change.** No private caller used `Demand::source()`; the private workspace
  builds, passes Clippy, and passes its tests unchanged against `a92050a`. The only private
  commit is the receipts.
- **The last full core test run** was on the tree before a doc-comment edit to
  `crates/verify/tests/prepared_source.rs`; after that edit `SHA256SUMS` was regenerated and the
  `ergodis`, `ergodis-contract` and `ergodis-verify` test targets (including the evidence
  manifest) were rerun, 48 result blocks green, before committing.

### Private gates

| Gate | Result |
| --- | --- |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo fmt --check` | clean |
| `cargo test --all-features` | exit 0, 14m39s, 1,171 passed, 0 failed across 40 result sections (the same count as the previous task) |
| parity digest and the reference-evaluator differential | inside that run: `tests/rel_reference_eval.rs` (`the_committed_fixtures_agree_with_the_reference_evaluator`, `the_generated_corpus_agrees`, `the_negation_corpus_agrees`, `every_figure_three_and_four_equation_agrees_with_the_reference_evaluator`, `the_recorded_rejection_surface_agrees`) and `tests/rel_lowering.rs`, all green |

### Mystery ledger

- **The `closure:sparse:256` residual (settled, by the independent audit
  `notes/2026-09-22-c1205-milestone-a-audit.md`).** 1.00004, interval [1.00003, 1.00004], about
  1,500 instructions an evaluation, with every symbol the timed loop reaches identical under the
  normalizer, and binary path length ruled out by a renamed-control A/A (0.999999). The audit
  reproduced it (1.000035, +1,336 per evaluation), showed it persists under 0–56 bytes of
  environment padding (so not stack placement), and ran Callgrind on both arms at `repeats` 3 and
  6: per-evaluation `evaluate_counting` and `index_rows` counts are identical between the arms
  (35,353,621 and 3,338,552), and the whole difference (+1,861 per evaluation) is glibc
  `malloc_consolidate` (+965), `unlink_chunk` (+347) and `HashMap::insert` (+532). These are
  per-process heap and hash-table costs that do not cancel in the two-point difference, because
  the control's 3-repeat run pays about 2,900 more `malloc_consolidate` instructions than its
  6-repeat run. Cause: a differencing artifact of heap layout; the loop's work is identical. My
  first hypotheses (the driver's `/proc/self` reads, `memset` path choice) were not the cause.
- **`prepare` reading 1.00006 in one run and 0.99997 in the other (settled as noise-level).** A
  33.7-thousand-instruction operation moving by 3 instructions in one run and by the opposite sign
  in the other; the change does not touch it.

### Open items

- The bound `MAX_PREPARED_BYTES = 1 << 30` (shared by the certificate decoders) is a choice, not a
  measured need; Tavis may prefer another value, or a caller-supplied bound.
- `Demand::prepared_encoding` returns `Error::Schema` on a wire plan, which overloads a variant
  that otherwise means an unsupported schema or algebra (audit finding L6). Left as it is by
  instruction: milestone b is the first consumer and decides. The audit's recommendation is one
  method that cannot be asked the wrong question,
  `Demand::transferable_source() -> Result<TransferableSource<'_>, Error>` with
  `TransferableSource::{Wire(&Program), Prepared(Vec<u8>)}`.
- A caller-supplied bound on the `check_prepared` entries (audit, under L4), for a checker with a
  smaller memory budget than a decode at `MAX_PREPARED_BYTES` needs; also milestone b's call.
- Every decode refusal, `Error::Budget` included, becomes `Rejection::Binding` at the checker
  entries, as on the wire entries (audit I2), so a checker caller cannot tell an oversized source
  from a malformed one. Unchanged; noted for the structured-refusals candidate.
- Milestone b needs, from this milestone, exactly `Demand::prepared_encoding`,
  `datalog::prepared_identity` and the two `check_prepared` entries; all four are in `a92050a`.
- The receipts name their arms by private revision only (`control-8de4932`, `bytes-a92050a`
  carries the core revision in its name but the control does not); the arm table in this report
  carries each arm's core revision, as `PERFORMANCE.md` rule 6 asks (audit L7). `retain-bin.sh`
  and the harnesses record the crate directory's revision only; recording the core revision in
  the manifest and receipts is a tooling change outside this card.
- Cache left by this milestone under `~/.cache/ergodis/`: the four retained binaries
  (`closure_ballpark-8de4932`, `ergodis-tools-8de4932`, `closure_ballpark-bytes-8de4932`,
  `ergodis-tools-bytes-8de4932`) and `c1205/` (A/B working files and the renamed control copy).
  No `cache-gc.sh` was run; deletion is Tavis's call.
- The independent audit of this milestone is `notes/2026-09-22-c1205-milestone-a-audit.md`; its
  repairs are in "Repairs after audit" below. The mutation worktree
  `~/.cache/ergodis/worktrees/c1205-mut` (at `c73ed85`, mutations reverted) and the audit's
  worktrees remain registered in the core repository; removing them is Tavis's call.

### Replay commands

```sh
cd ~/src/ergodis        # at a92050a
nix develop . --command python3 python/generate_evidence.py --write
nix develop . --command cargo fmt --all -- --check
nix develop . --command cargo clippy --all-targets --all-features -j 12 -- -D warnings
nix develop . --command cargo test --all-features --no-fail-fast -j 12
nix develop . --command python3 python/generate_fixtures.py --check
nix develop . --command python3 scripts/check-runtime-dependencies.py
nix develop . --command cargo build -j 12 -p ergodis-rules --release
nix develop . --command python3 crates/rules/tests/native_abi.py \
    ~/.cache/ergodis/target/ergodis/release/libergodis_rules.so <scratch>/native.json <scratch>/native-cert.json
nix develop .#wasm --command cargo build -j 12 -p ergodis-rules --release --target wasm32-unknown-unknown
nix develop .#wasm --command node crates/rules/tests/wasm_abi.mjs \
    ~/.cache/ergodis/target/ergodis/wasm32-unknown-unknown/release/ergodis_rules.wasm <scratch>/native.json

cd ~/src/ergodis-private   # at 8de4932 for the arms, bfd79c9 for the receipts
nix develop ../ergodis --command cargo clippy --all-targets --all-features -j 12 -- -D warnings
nix develop ../ergodis --command cargo test --all-features --no-fail-fast -j 12
A=analysis/datalog-comparison; B=analysis/rel-frontend
C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1205
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
ALL=closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512,closure:blocks:4096,closure:blocks:16384,cycle:blocks:4096,triangle:sparse:16384,path3:sparse:4096,path3:sparse:16384,path4:sparse:4096,path4:sparse:16384,mutual:blocks:4096,mutual:blocks:8192,triangle:sparse:4096,triangle:blocks:4096
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-8de4932 \
    --a-name control-8de4932 --b $C/closure_ballpark-bytes-8de4932 --b-name bytes-a92050a \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-evaluate --out $A/ab-2026-09-22-prepared-bytes-derivation-loop.json
cp $C/closure_ballpark-8de4932 $W/closure_ballpark-ctrlx-8de4932
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-8de4932 \
    --a-name control --b $W/closure_ballpark-ctrlx-8de4932 --b-name control-renamed \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts closure:sparse:256,mutual:blocks:4096 \
    --work $W/ab-path --out $W/ab-path-length.json
# The committed receipt is that output copied into the private tree:
cp $W/ab-path-length.json $A/ab-2026-09-22-prepared-bytes-path-length-null.json
cp $W/ab-path-length.json.jsonl $A/ab-2026-09-22-prepared-bytes-path-length-null.json.jsonl
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-bytes-8de4932 \
    --control $C/ergodis-tools-8de4932 --rounds 5 --cpu 5 \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-prepared-bytes-a92050a.json
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-bytes-8de4932 \
    --control $C/ergodis-tools-8de4932 --rounds 5 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-prepared-bytes-datalog-a92050a.json
# Symbol comparisons: analysis/datalog-comparison/symbol_disasm.py <binary> <symbol> [rank],
# each arm, then diff.
```

### Repairs after audit

Audit: `notes/2026-09-22-c1205-milestone-a-audit.md` (0 high, 1 medium, 7 low, 3 info). Repairs
in core `c73ed85`; report corrections in this file's commit.

| Finding | Disposition | Commit |
| --- | --- | --- |
| M1: on `closure.json` the reference certificates were the evaluator's, byte for byte | Repaired. The reference producer lists each round's derivations in reverse discovery order (valid: every premise is from an earlier round). A third fixture, `crates/rules/tests/mutual_recursion.json` (mutually recursive `odd`/`even` plus a nonlinear transitive closure, so several recursive rules fire per round), joins the two others in both test files. `certificates_are_checked_from_the_bytes_alone` asserts on every fixture that both reference certificates' digests differ from the evaluator's, which `demand_prepared.rs` pins against the evaluator itself (the third fixture's rows added there). New `hand_built_certificates_are_accepted_and_their_breakages_refused`, on all three fixtures including the closure: a derivation certificate reordered depth-first (the latest derivation whose premises are listed, asserted not to be the listed order) is accepted with the same least model; the same with a dependent derivation moved to the front is refused with `Rank(0)`; a ranked certificate with ranks `3·round + (i mod 3)` is accepted; the same with its highest-rank tuple set to rank 1 is refused with `Unjustified`. The mutation tests already ran on the closure. Test docs and this report corrected. Mutation check: with the reversal removed, the divergence assertion fails on the closure (`5360dca7…`). | `c73ed85` |
| L1: the input-bound test did not test the bound | Repaired. `the_input_bound_refuses_before_anything_is_read` pads a valid closure encoding with zeroes to `MAX_PREPARED_BYTES + 1` (`Error::Budget`), beside the same encoding plus one byte (`Error::Encoding`, the value without the bound). The vacuous case was removed. Mutation check (`if false &&` on the bound): this test fails. | `c73ed85` |
| L2: the certificate decoder bound had no test | Repaired. `the_certificate_decoders_refuse_input_above_their_bound`: `{` then zeroes, `MAX_CERTIFICATE_BYTES + 1` bytes is `Error::Budget` for both decoders, and the same at the bound is `Error::Source`. Mutation check, each decoder's bound removed separately: the test fails each time. | `c73ed85` |
| L3: the count guards were caught only by a process abort | Repaired in code and test. After each budget check the decoder now also requires the remaining input to hold that many minimal records (6 bytes a relation, 7 a rule) before sizing the list, so no count sizes an allocation the input cannot back, with or without the budget. `the_shape_counts_are_refused_before_anything_is_sized`: relation counts `65`, `0x8000_0002`, `u32::MAX` and rule counts `1025`, `0x8000_0000`, `u32::MAX` on short inputs are `Error::Budget`; counts at the budget on the same short inputs are `Error::Encoding`. Mutation check, each guard removed: the test fails by assertion, no abort. | `c73ed85` |
| L4: decode memory misstated; non-canonical fact lists sorted before refusal | Stated, and the sort removed. The `MAX_PREPARED_BYTES` docstring now gives the per-tuple arithmetic and the multiple (about 6.5× the input for binary relations, up to about 10× for unary; 7–10 GiB at the bound), consistent with the audit's measured 6.4× peak and about 10× reserved. The bound is kept (see the Decoder section and open items). A fact list that is not strictly increasing is refused during the parse without admission's sort, keeping admission's value for a source admission would refuse; the parsed rows are released before the re-encoding is built. | `c73ed85` |
| L5: `encode_prepared` returned bytes the decoder refuses | Repaired. The encoder decodes its own bytes and returns them only when they decode to the given `Admitted`; decoder refusals pass through with the decoder's value, a mismatch is `Error::Binding`. `only_a_prepared_admission_is_encoded` adds the audit's case (two tuples swapped, identity set to the swapped bytes' hash: `Error::Encoding`) and an edited derived field (`universe`: `Error::Binding`). Mutation check, decode check removed: the test fails. The report's "total over any `Admitted`" sentence corrected. | `c73ed85` |
| L6: `prepared_encoding()` overloads `Error::Schema` | Not changed, by instruction; recorded as an open item for milestone b with the audit's recommendation. | — |
| L7: report inaccuracies | Corrected here: the path-length null's replay now copies the output to the committed receipt path; the `generate_fixtures.py --check` row says it is vacuous for this change; the backend-stage verdict no longer claims a favourable effect or a Fermi size (the `datalog` A/A drift is 1.000015); the receipts' missing core revision is recorded as an open item (the arm table carries it); the abbreviated ranked digest reads `97d921fc…105660`. | this report |
| I1: independence is process independence | The `check_prepared` docs now say the bytes are admitted "from the bytes alone and without any object of the producer's", and that the admission code is the one the producer ran, as on the wire route. | `c73ed85` |
| I2: every decode refusal becomes `Rejection::Binding` | No change; matches the wire entries. Open item. | — |
| I3: relation and rule order are part of the identity | No change; pre-existing definition. "One source has one encoding" holds with source meaning the ordered relation and rule lists. | — |
| `closure:sparse:256` residual | Moved to the mystery ledger as settled, credited to the audit (heap consolidation and `HashMap::insert` per process; loop work identical). | this report |

Gates at `c73ed85`, all under `nix develop ~/src/ergodis`: `cargo fmt --all -- --check` clean;
`cargo clippy --all-targets --all-features -j 12 -- -D warnings` clean; `cargo test
--all-features --no-fail-fast -j 12` exit 0, 85 `test result: ok` blocks, zero FAILED
(`prepared_source` now 14 tests, `demand_prepared` covering three fixtures); `SHA256SUMS`
regenerated in the commit; native ABI harness passed. Private `cargo test --all-features` against
`c73ed85`: exit 0, 1,171 passed, 0 failed across 40 result sections.

Mutation checks ran in a detached scratch worktree, `~/.cache/ergodis/worktrees/c1205-mut` at
`c73ed85`, one mutation at a time, each reverted before the next (the worktree is clean):
input bound, relation-count guard, rule-count guard, derivation-certificate bound,
ranked-certificate bound, the encoder's decode check, and the reference producer's reversal.
Each made exactly one `prepared_source` test fail by assertion.

No A/B rerun: no function the derivation loop or a timed stage reaches changed.
`admit_prepared` and `write_encoding` are byte-identical in source; the changes are in
`decode_prepared` and `encode_prepared` (called by no timed stage), doc comments in the verify
crate, and tests. As a check against ThinLTO moving untouched code, `closure_ballpark` was
retained at private `bfd79c9` with core `c73ed85`
(`../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --label
closure_ballpark-repair`; measured sha256
`26be6851f425eab6ad689954c29322b5e1e8238752bb068cf848118ba0093765`), and all 33
`ergodis_rules::demand::` symbols, both `evaluate_counting` instantiations among them, compare
empty under `symbol_disasm.py` against `closure_ballpark-bytes-8de4932`.

## Milestone b

Status: design approved (Tavis, 2026-09-22) with all four recommendations: D1 (a), the
independent set-based rebuild in its own module; D2, the stratified program statement with its
own identity; D3, `Demand::transferable_source()` in one core commit; D4, no verification
records in the chain, fresh records as the verifier's output. Implemented; the independent
audit found one High (binding sites trusted), repaired with the other findings in "Repairs
after audit" (private `c1205b` at `8d11ce4`). The close is Tavis's call.

Worktrees, branch `c1205b`: core `~/.cache/ergodis/worktrees/c1205b/ergodis` from core `main`
`4b57649` (C1213's record API included); private `~/.cache/ergodis/worktrees/c1205b/ergodis-private`
from private `main` `482d6e9`, whose `../ergodis` path dependency is the core worktree.

### Design

#### Starting point, verified in the worktree

- `rel_stratified::evaluate` (`src/rel_stratified.rs`) builds one `PreparedSource` per layer,
  evaluates it with `Demand::from_prepared_bounded`, builds both certificates, checks them
  in-process (`Demand::verify`, `verify_ranked`, both through `check_admitted`), compares the
  checker's relations with the evaluator's rows, and drops the plan, both certificates, the
  per-layer `names`/`arities`/`inputs` vectors and the literal-to-relation table `atom_over`.
  `LayerReport` is a `Copy` struct of counters. `demand.source_id()` is computed and read by
  nobody.
- `verify_records` is public, optional, and calls the builder's own `complement_over`,
  `filter_over`/`satisfies`, `aggregate_over`, `digest_of` and `Dictionary`; only
  `rebuild_domain` is a second implementation. It returns `Error::ComplementMismatch(index)` for
  all three record kinds. Its callers: `tests/rel_lowering.rs`, `tests/rel_reference_eval.rs`,
  `tasks/tools/src/rel_lower.rs` (fails the run), `rel_frontend_bench.rs`'s untimed description
  (records `records_verified: false` in an otherwise normal receipt).
- Fields written and never checked: the card's three (`ComplementRecord.source`,
  `FilterRecord.literal`, `FilterRecord.operator`), and also every `ColumnDomain`'s
  `column_type`, `type_start` and `type_end`, every record's `layer` and `uses`, and the
  complement's and filter's `DomainSource` site lists (compared as recorded, never recomputed
  from the rule). A chain in which every single-field mutation is rejected must check all of
  them, so the design below covers the whole list, not the three.
- `Externals` (`&[(String, Vec<Vec<u32>>)]`): an unknown spelling is skipped; a tuple is
  appended without an arity check; a spelling that names a relation some rule derives is
  appended to that relation's seed and then silently dropped, because a derived relation's
  layer source takes `TupleSource::Empty`. That third case is not in the review; it is the
  same defect class.
- The timed `stratify` stage of `rel-frontend-bench` calls `evaluate` and nothing else. Only the
  `stratified`, `columns`, `columns3` and `aggregate` cohorts build constructions; the A/Bs of
  milestone a and C1213 measured `stratify` on the `datalog` cohort only, which has none.
- Core already provides everything the verifier needs: `datalog::decode_prepared` (an `Admitted`
  with public `relations`, `rules`, `tuples`), `datalog::prepared_identity`,
  `derivation::check_recorded`/`ranked::check_recorded` with `datalog_record::Source::Prepared`,
  `datalog_record::derivation_digest`/`ranked_digest`, and replay.
- Binding sites (`src/rel_frontend/lower/passes.rs`) are the rule's positive body literals that
  name a relation, in body order, each column holding the variable. Aggregate literals are not
  binding sites. A verifier can therefore recompute every site list from the rule alone.
- The RIR's canonical form (`Rir::canonical`, tag `ergodis.rel_frontend.rir.v1`) has no decoder,
  hashes to a 64-bit FNV fingerprint, and writes binding sites only for rules with a negation
  (comparisons read them too). It was built for parity, not as a checkable program statement,
  and changing it would move every plan fingerprint.

#### What an accepted chain establishes

Stated first, because every field below exists to serve it. A chain accepted by the offline
verifier establishes:

> The relations listed in the chain's result table are the stratified model of the stratified
> program `P` whose identity the chain names, over the seeded input relations whose digests the
> chain names.

where "stratified model" means: each layer's positive program is evaluated to its least model,
certified by the core's derivation certificate and cross-checked by its ranked certificate,
both checked through the prepared byte door by a process holding no `Demand`; each negated,
compared or aggregated literal of `P` is replaced by a relation whose tuples are rebuilt by the
verifier from relations earlier layers established; and every relation a layer reads is shown,
tuple for tuple, to be the one an earlier layer established or the seeded input.

What it does not establish: that `P` is the correct lowering of a Rel source (that is the
frontend's job; see the optional source check below), and anything about the producer's
performance counters.

#### The subject: a stratified program statement

**Decision for Tavis (D2) — what the chain is about.**
Recommendation: the chain carries `P`, a stratified program statement computed from the RIR
alone, with its own schema and identity; everything is checked against it. The identity is
computable from the source without evaluating anything, and the three unchecked fields become
checks against `P`, not against another producer-written field.
Alternative: no `P`; the layer sources plus the literal map are the program. Less code, but the
program's identity then depends on evaluation (complement sharing and synthetic numbering depend
on computed domains), and a literal map entry can only be compared with the record it points to.

`P` (`rel_chain::Program`, JSON, `deny_unknown_fields`), built by `Program::of(&Rir, &Readout)`,
a pure function of the lowered RIR:

| Part | Content | Why the verifier needs it |
| --- | --- | --- |
| `schema` | `"ergodis-private/rel-stratified-program.v1"` | dispatch; checked first |
| `relations` | per RIR relation, in RIR order: mangled `name`, source `spelling`, `arity`, `columns` (column types), `auxiliary` | names bind layer declarations; spellings key externals; column types give `type_start`/`type_end` |
| `values` | the lowering's dictionary, in id order: `kind`, `text` (an integer's text must be its canonical decimal) | the filter predicate and aggregate payloads; the base the aggregates extend |
| `type_ranges` | the per-kind dense id ranges, as the RIR holds them | recomputing `type_start`/`type_end`; checked consistent with `values` on decode |
| `facts` | per relation, the source facts, sorted and distinct | seeded relations must contain them |
| `literals` | the RIR literal pool in RIR id order: `sign`, `op`, `relation` (or none for a comparison), `aggregate_column` (aggregates only), `terms` (constant id or rule-local variable) | the literal map, the construction semantics, binding sites |
| `rules` | per RIR rule: `head` (literal id), `body` (literal id range), `order` (join order, a permutation of the body), `variables` | layer rules are these rules, atom for atom |

RIR ids are kept (rule `i` of `P` is RIR rule `i`, literal `l` is RIR literal `l`), so a record's
`literal` field is checkable directly. Identity: `SHA-256("ergodis-private/rel-stratified-program.v1"
‖ 0x00 ‖ serde_json::to_vec(decoded))`, the construction core uses for certificate digests, so
two spellings of one statement have one identity. Layer assignment and strata are not part of
`P`: the verifier checks that the chain's layering is *a* valid stratification (below), and every
valid stratification has the same model, so the producer's choice does not need to be trusted
or recorded as a claim.

Optional source check: the chain directory may hold the Rel source bytes and the lowering
parameters (`Limits`, `BodyPolicy`); `rel-verify --source-check` re-lowers them and requires
`Program::of` to reproduce `P` byte for byte. That extends the claim to "the model of this Rel
source as this frontend lowers it", with the frontend in the trusted base. Off by default,
because it is not what the chain proves and it pulls the whole frontend into the verifier.

#### The chain format

A chain is a directory. Every file but `producer.json` is verified; the verifier refuses a
missing file, an unexpected file, and any file above its size bound before reading it.

| File | Content | Size bound checked before reading |
| --- | --- | --- |
| `chain.json` | the manifest (below) | 64 MiB |
| `program.json` | `P` | 64 MiB |
| `layer-<k>.prepared` | `datalog::encode_prepared` bytes of layer `k` | `--max-layer-bytes`, default `datalog::MAX_PREPARED_BYTES` |
| `layer-<k>.derivation.json` | the derivation certificate, `serde_json::to_vec` | `--max-certificate-bytes`, default `derivation::MAX_CERTIFICATE_BYTES` |
| `layer-<k>.ranked.json` | the ranked certificate | same |
| `source.rel`, `lowering.json` | optional, for `--source-check` | 1 MiB and 4 KiB |
| `producer.json` | telemetry, not part of the chain: evaluator counters (rounds, probes, candidates), wall times, producer revision, `max_rows`, body policy. The verifier never reads it and says so | — |

The verifier's size flags are the caller-supplied bound milestone a left open (audit L4): a
checker with less memory refuses a large layer before `decode_prepared` sees it, with no core
change, and an oversized input is reported as the verifier's own error rather than as the core's
`Rejection::Binding` (audit I2).

Manifest (`rel_chain::Manifest`, JSON, `deny_unknown_fields`; digests are 64 lowercase hex
characters, anything else refused at decode):

```text
schema        "ergodis-private/rel-chain.v1"
program       identity of P
dictionary    the entries aggregates appended, in id order: { kind, text }
seeded        per P relation that no rule derives, in P order:
                { relation, name, tuples, external, digest }
layers        per layer k, in order:
                { layer, source_id, domain,
                  declared:  [ { name, arity, input, origin } ],
                  derivation, ranked,
                  literals:  [ { literal, declared } ] }
complements   ComplementRecord list (fields below)
filters       FilterRecord list
aggregates    AggregateRecord list
result        per P relation: { relation, tuples, digest }
```

- `origin` of a declared relation is `{"program": id}` or `{"complement": i}`, `{"filter": i}`,
  `{"aggregate": i}`. It is the literal-to-relation mapping read from the other side.
- `literals` is the card's mapping: every negated, compared or aggregated literal of every rule
  of this layer, by `P` literal id, to the index of the declared relation that replaced it.
- `derivation`, `ranked` are `datalog_record::derivation_digest`/`ranked_digest`, so they equal a
  verification record's `certificate` field by construction.
- `external` is the number of tuples the caller supplied beyond `P`'s own facts.
- No field of the chain is unverifiable: counters that only the evaluator knows live in
  `producer.json`, and counts the verifier can derive (`relations`, `inputs`, `rules`, `facts`,
  `layer_values`, `derived`, `derivations`) are left out rather than stored and rechecked.
- Chain identity: `SHA-256("ergodis-private/rel-chain.v1" ‖ 0x00 ‖ serde_json::to_vec(manifest))`.
  It names every other file through the identities and digests it contains.

Record digests with domain separation (card; C1204 F16). One function,
`rel_chain::tuple_digest(kind, scope, name, arity, tuples)`:

```text
SHA-256( "ergodis-private/rel-chain.v1" ‖ 0x00
         ‖ kind     (one of "complement", "filter", "aggregate", "seeded", "result"; then 0x00)
         ‖ scope    u32 LE: the layer for a construction, 0xFFFFFFFF for seeded and result
         ‖ name     u32 LE length, then the bytes: the declared name in its layer, or the P name
         ‖ arity    u8
         ‖ count    u64 LE, number of tuples
         ‖ tuples   every value u32 LE, tuples ascending lexicographic, distinct )
```

It replaces `digest_of` everywhere, in memory as well as on disk, so there is one definition.
No tracked file pins a record digest (the parity record covers the lowered program only;
searched `tests/`, `analysis/`), so nothing is invalidated; `rel-lower`'s printed digests change,
deliberately.

Chain schema string: `"ergodis-private/rel-chain.v1"`. The `ergodis-private/` prefix says these
are private-crate formats, not core contract schemas.

**Retention: streamed, never held.** The encoded layer sources and the certificates are handed,
layer by layer, to a caller-supplied sink the moment they exist, and dropped by the driver
(playbook: never retain a transcript). The library defines

```rust
pub trait Evidence {
    const RETAIN: bool;
    fn layer(&mut self, layer: u32, encoding: &[u8],
             derivation: &DerivationCertificate, ranked: &RankedCertificate) -> Result<(), Error>;
}
pub struct NoEvidence;            // RETAIN = false, `layer` unreachable
pub struct ChainWriter { .. }     // writes layer-<k>.* into a directory as they arrive
```

and `evaluate` is `evaluate_with(.., &mut NoEvidence)`. `RETAIN` is a const, so the default
instantiation contains no encoding, no certificate serialization and no digest code at all.
`rel-lower --chain <dir>` runs `evaluate_with(.., &mut ChainWriter)`, then writes `program.json`,
the manifest and `producer.json` from the checked result. The certificate digests and source
identity are the only per-layer evidence kept in memory (64 bytes).

**Verification records are not stored in the chain (D4).** The producer checks in-process
through `check_admitted`, which issues no record; a record it stored would have to come from a
second check through the bytes, and would still be untrusted on read. The verifier issues fresh
records (`check_recorded`) and writes them to its own output (`rel-verify --records <file>`),
where a third party can `replay` them against the same chain files.

**Decision for Tavis (D4) — verification records in the chain.**
Recommendation: none stored; the verifier emits fresh records as its own output. A record then
always names the build that actually checked.
Alternative: the producer re-checks each layer through `check_recorded` and stores the records;
the verifier replays them and treats a replay failure as a warning. One extra decode and two
checks per layer on the producer, for records no reader may trust.

#### Externals

`Externals` keeps its type. Before anything is seeded, each entry is resolved once:

| Condition | Error |
| --- | --- |
| no relation has this source spelling | `Error::External { spelling, problem: Unknown }` |
| the relation is derived by some rule | `External { .., problem: Derived }` (today silently dropped) |
| the same spelling appears twice | `External { .., problem: Repeated }` |
| tuple `t` has length other than the arity | `External { .., problem: Arity { tuple, found, arity } }` |
| a value is not a dictionary id | `External { .., problem: Value { tuple, value, dictionary } }` (today the core refuses it later with an unnamed `Error::Source`) |

The seeded names are recorded always, in `Evaluation::seeded: Vec<Seeded { relation, spelling,
external_tuples }>`, one entry per relation no rule derives. The per-relation digest is computed
only when evidence is retained (it is a pass over every seeded tuple, and the timed stage
does not need it). The differential harness's own free-name assertion stays; it becomes
redundant but harmless.

#### Checked and unchecked results are distinct types

The record check does not run inside `evaluate`: with either rebuild option it repeats every
construction (option (a) with set-based code several times slower than the builder), and
`evaluate` is the timed `stratify` stage. So the state goes into the type:

- `evaluate`/`evaluate_with` return `Evaluation`: today's `Stratified` fields plus the new
  per-layer records, all `pub`, so a test can tamper with them.
- `check(evaluation: Evaluation, rir: &Rir) -> Result<Stratified, Error>` builds `P` from the
  RIR and runs the same construction checker the offline verifier runs (below), against the
  in-process closures, which `Demand::verify` already certified.
- `Stratified` is the checked result: a private field, no public constructor, `Deref<Target =
  Evaluation>` for reading. `verify_records` is removed; its callers call `check`.
- `rel-lower` prints only from a `Stratified`. `rel-frontend-bench`'s untimed description runs
  `check` and, on failure, emits `{"stratified":false,"error":"record check: <what>"}` and
  nothing else from that run, so a receipt cannot record a failed run's closure.
  `records_verified` is dropped from the description (present means true). Whether `bench.py`
  compares that description between arms is checked before the A/B; if it does, the field stays
  as a constant `true` for this milestone's comparison and the drop is a follow-up.

#### Errors

`rel_stratified::Error` becomes:

```rust
pub enum Error {
    Lowering(LowerFailure),
    Core(CoreError),
    External { spelling: String, problem: ExternalProblem },
    /// Two parties that must agree on a layer's relation do not: the derivation and the ranked
    /// checker, or the checker and the evaluator.
    CheckersDisagree(Disagreement),
    Record(RecordMismatch),
    LayerCapacity { layer: u32, max_rows: u32 },
}
pub struct Disagreement { layer: u32, relation: String, tuple: Vec<u32>,
                          held_by: Party, missing_from: Party }   // Party: Derivation | Ranked | Evaluator
pub struct RecordMismatch { kind: RecordKind, index: usize, field: RecordField }
```

`RecordKind` is `Complement | Filter | Aggregate | Literal | Declared | Seeded`, `index` is the
index into that kind's own list (so the index spaces no longer collide), and `RecordField`
names the field, down to `ColumnDomains { column, part: Source | Values | ColumnType | TypeStart
| TypeEnd }`. `Display` renders the path, for example `complements[2].column_domains[1].values`.
The first differing tuple is found by a merge walk over two sorted relations, run only on the
failure path. The bench's error witness keeps its existing encoding for the existing variants
(`CheckersDisagree` still maps to `3 << 60 | layer`), so no cohort's witness moves.

#### Every record field checked, against `P`

The construction checker takes `P`, the per-layer records, the construction records and the
relations established so far, and checks each field against something the producer did not
write. For a literal `l` of rule `r` of layer `k` that the literal map sends to declared `d`:

| Field | Checked against |
| --- | --- |
| literal map entry | `l` is a non-positive literal of a rule whose head is derived in layer `k`; every such literal has exactly one entry; the prepared rule's body atom at `l`'s join-order position names `d` with `l`'s terms as slots |
| `ComplementRecord.relation`, `.source` | `P.literals[l].relation` and that relation's name, for every literal mapped to the record (`source` was unchecked) |
| `FilterRecord.operator` | `P.literals[l].op` (was unchecked) |
| `FilterRecord.literal` | the first literal, in `P` order, mapped to this filter (was unchecked) |
| `AggregateRecord.relation`, `.source`, `.operator`, `.column`, `.group_columns`, `.arity` | the aggregate literal's relation, op, aggregate column, and that relation's arity |
| `declared`, `layer`, `complement`/`filter`/`result` name | the layer's declared list: `declared[d]` has this name, this arity, `input = true`, and `origin` this record |
| `uses` | the number of literal-map entries pointing at the record |
| `ColumnDomain.column` | position |
| `ColumnDomain.column_type` | `P.relations[relation].columns[column]` (unknown for a comparison operand) |
| `ColumnDomain.type_start`, `type_end` | `P.type_ranges` for that type (was unchecked) |
| `ColumnDomain.source` | recomputed from rule `r` of `P`: constant term, or the binding sites (positive literals naming a relation, body order, each column holding the variable), `Bound` when every site's relation is seeded or derived in a layer before `k`, else `Dictionary` (the site list was compared as recorded, never recomputed) |
| `ColumnDomain.values` | rebuilt from that source over the relations established before layer `k` |
| `dictionary`, `dictionary_before` | the dictionary size when layer `k` was built (base plus the entries earlier aggregates appended) |
| `universe`, `closure_tuples`, `closure_inside`, `facts`, `interned`, `digest` | the rebuilt construction |
| sharing | two literals of one layer map to one record exactly when their recomputed signatures (relation or operator or aggregate spec, plus domains) are equal |

The checker is one function used twice: by `check` in-process (closures from `Evaluation`) and
by the offline verifier (closures from the checked certificates).

#### The offline verifier

Library: `rel_verify::verify_chain(dir: &Path, bounds: &Bounds) -> Result<VerifiedChain,
ChainError>`, with an in-memory form `verify_parts(&ChainParts, ..)` that the mutation suite
drives. `VerifiedChain` is sealed like `Stratified` and carries the chain identity, `P`'s
identity, the final relations, the readout and the fresh verification records. No `Demand`,
no `ergodis_rules` item and no `rel_stratified::evaluate` is reachable from it: `rel_verify`
and `rel_rebuild` import neither, and a test reads their source files and fails on any
`ergodis_rules` or `rel_stratified` path.

Subcommand: `ergodis-tools rel-verify <dir> [--source-check] [--records <file>]
[--max-layer-bytes N] [--max-certificate-bytes N]`, printing one JSON line: `accepted`, the
chain and program identities, per layer the source identity and both certificate digests, and
per result relation its count and digest; or `accepted: false` with the error path.

Steps, each failing with a `ChainError` that names the file, the layer and the field:

1. Directory listing: exactly the expected files for the manifest's layer count; sizes within
   bounds.
2. Decode the manifest; schema first. Decode `P`; schema first; internal consistency (relation,
   literal and rule references in range, join orders are permutations, facts in arity and
   dictionary, integer texts canonical, type ranges agree with kinds); identity equals
   `manifest.program`. With `--source-check`, re-lower and compare.
3. Layering: every relation some rule of `P` derives is declared as non-input in exactly one
   layer, and all its rules are that layer's; a positive body relation is seeded or derived at
   the same or an earlier layer; a negated or aggregated relation is seeded or derived at a
   strictly earlier layer. A layer with no rules is allowed (layer zero of a fact-only source).
4. Dictionary: `P.values` followed by `manifest.dictionary`; the extension is checked entry by
   entry when the aggregates are rebuilt.
5. Seeded relations: one `seeded` entry per relation no rule derives; its tuples are the facts
   of that relation in the first layer that declares it, identical in every other layer that
   declares it, a superset of `P`'s facts, `tuples` and `external` match, and the digest
   recomputes. A seeded relation no layer declares is empty and must say so.
6. For each layer `k`, in order:
   1. `prepared_identity(bytes) == source_id`; `decode_prepared(bytes)`; `domain` is the
      dictionary size at `k`.
   2. The declared list equals the decoded relations (name, arity, input), and each `origin`
      is consistent (a program relation's name and arity are `P`'s; a construction's is its
      record's).
   3. The decoded rules are exactly `P`'s rules of this layer, in `P` order: head and body
      atoms in join order, a positive literal as its program relation, a non-positive one as
      the relation the literal map names, variables renumbered by first occurrence in body
      order then head (the numbering admission fixes), constants as dictionary ids.
   4. Every program input relation's decoded tuples equal the relation established for it:
      seeded tuples, or the checked relation of the layer that derived it. A difference names
      the relation and the first differing tuple.
   5. Constructions: the checker above, rebuilding each from the relations established before
      `k`, and each construction's decoded tuples equal the rebuilt ones.
   6. Certificates: both digests recompute; `derivation::check_recorded(Source::Prepared(bytes),
      ..)` and `ranked::check_recorded(..)` accept; their relations agree (else
      `CheckersDisagree` with relation and tuple). The derived relations of `k` become
      established.
7. Result: every `P` relation's final tuples (seeded or derived) match `result` in count and
   digest, and every relation appears once.

What the verifier shares with the producer: the contract crate's admission (as every checker
does), the core checkers (which the producer also ran, in-process), serde, the digest
definitions, and, under option (b) below, the construction code. It does not share the driver,
the layer assembly, the evaluator or `Demand`.

#### `Demand::prepared_encoding`'s return type (D3)

**Decision for Tavis (D3).**
Recommendation: replace it with `Demand::transferable_source() -> Result<TransferableSource<'_>,
Error>`, `TransferableSource::{Wire(&Program), Prepared(Vec<u8>)}`, with `as_source() ->
datalog_record::Source<'_>` so a caller goes straight to `check_recorded`. No wrong question to
ask, and `Error::Schema` keeps its one meaning (audit L6).
Alternative: keep the name and return `Result<Option<Vec<u8>>, Error>`, `None` for a wire plan.
Smaller core diff, but every caller still handles a case it may not expect, and the wire plan's
transferable form stays undiscoverable from the method.

Under the recommendation, core `main` gains one commit on `c1205b`: the type in
`ergodis_rules::demand`, `prepared_encoding` removed (callers: core tests `demand_prepared.rs`,
`docs/datalog-certificates.md`; no private caller), `SHA256SUMS`. The private driver matches
`Prepared(bytes)` and treats `Wire` as `Error::Core(CoreError::Schema)`, which cannot occur on
the prepared route.

#### The construction rebuild (D1, the card's open decision)

The rest of the design is the same under either option: the rebuild is behind one interface,

```rust
pub trait Rebuild {
    fn domain(&self, program: &Program, sites: &[(u32, u8)], established: &Established) -> Vec<u32>;
    fn complement(&self, domains: &[Vec<u32>], closure: &[u32]) -> Complement;   // tuples, inside
    fn filter(&self, dictionary: &DictionaryView, operator: u8, domains: &[Vec<u32>]) -> Vec<u32>;
    fn aggregate(&self, dictionary: &DictionaryView, closure: &[u32], arity: u8, column: u8,
                 operator: u8) -> Result<Aggregate, AggregateRefusal>;   // tuples, appended entries
}
```

and the construction checker compares its output with the records and the decoded facts.

**(a) A separately written rebuild.** A new tier-1 module `rel_rebuild`, written from the stated
semantics and not from the builder, in the reference evaluator's style:

- values are decoded to typed values first (`Int(i64)`, `Text`, `Entity`, `Bool`, read from the
  dictionary's kind and text), and every predicate is decided on those; the builder decides
  equality on ids and orders on the stored integer payload;
- a domain is a `BTreeSet<u32>` filled by walking each site relation's tuples; the builder uses a
  bitset;
- a complement is the product enumerated by an odometer over the domains, keeping each tuple not
  in a `BTreeSet<Vec<u32>>` of the closure; the builder ranks tuples into a mixed-radix
  membership vector;
- a filter is the product filtered by a comparison over typed values, taken from the reference
  evaluator's comparison (promoted from `tests/rel_reference/mod.rs` into the library, with the
  test tree importing it back, so the oracle and the verifier share one statement of
  comparison semantics and neither shares the builder's);
- an aggregate groups into a `BTreeMap<Vec<u32>, Vec<i64>>` and folds after grouping (the builder
  folds while grouping), interning results by scanning the dictionary as it stood before the
  aggregate and appending in ascending group-key order.

The module header states what is independent (the four algorithms and the value semantics) and
what is not (the definitions they implement, the digest). Tests: a differential of `rel_rebuild`
against the builder over the committed Rel fixtures and the generated corpus (every construction
of every accepted program), and a construction-level mutation check in the scratch-worktree
style of milestone a: a deliberately wrong builder (off-by-one domain, swapped operator,
wrong group key) must be caught by `check` through `rel_rebuild`. Cost: about two days, most of
it tests. It gives the offline verifier a real second implementation of the one step the core
checkers cannot see.

**(b) Replay of the builder, stated as such.** The `Rebuild` implementation calls the builder's
`column_domains` successor, `complement_over`, `filter_over` and `aggregate_over`, moved to a
module both sides import. The module headers of `rel_stratified` and `rel_verify` say the
construction check is record consistency plus a replay of the producer's construction code,
which detects a tampered or inconsistent chain and cannot detect a defect in the construction.
Oracle agreement becomes shipped evidence: the reference evaluator moves from the test tree
into the library unchanged, the chain may carry `source.rel`, and `rel-verify --oracle`
evaluates the source with the reference evaluator and requires its model to equal the chain's
result (the reference evaluator is exponential in the worst case and refuses out-of-fragment
programs, so it is opt-in and reports "not applicable" rather than failing on a refusal); a
committed receipt of the differential corpus (`tests/rel_reference_eval.rs`'s populations and
the corpus digest) is regenerated by a test so it cannot go stale. Cost: about a day. A defect in
a construction is then caught only when the oracle is run on that program.

Recommendation: (a), as the review recommends. The offline verifier exists for a second party
who does not trust the producer's code; under (b) that party re-runs the producer's code. (a)
costs about a day more and adds no work to any timed stage, because the check runs outside
`evaluate`. (b)'s `--oracle` is worth adding under (a) as well, later, as a whole-model
cross-check; it is not part of this milestone under (a).

#### Mutation test plan

Fixture: a committed Rel source with a negation, an ordering comparison and an aggregate across
three layers, plus one external input relation, small enough that the chain has a few hundred
tuples. It must exercise a shared complement (`uses = 2`), a `Dictionary` domain source, a
dictionary extension by an aggregate, and a layer with no rules. The chain is produced once per
test run by `evaluate_with` into memory (`ChainParts`), and every mutation is verified through
`verify_parts`.

1. **Acceptance, two processes** (`tasks/tools/tests/rel_chain.rs`): run the built
   `ergodis-tools rel-lower --source-file <fixture> --chain <tmp>` as one child process and
   `ergodis-tools rel-verify <tmp> --records <tmp>/records.json` as another; the second prints
   `accepted: true` with the result digests the first printed. Then `replay_derivation`/
   `replay_ranked` of the emitted records against the chain files succeed. The temporary
   directory is under the test's own `CARGO_TARGET_TMPDIR`, not `/tmp`.
2. **Every manifest leaf.** The manifest is serialized to a `serde_json::Value`, every leaf is
   enumerated with its path, and each is mutated once (integer plus one and, separately, zero;
   string with one byte changed; boolean flipped; digest with one nibble changed; enum tag
   swapped to each other tag). Each mutated manifest is re-encoded and verified. Every mutation
   must be refused, and the error's field path must equal the mutated leaf's path. Where a
   mutation is necessarily caught by an earlier, different check, the test holds an explicit
   table of `(leaf pattern, expected path)`, reviewed in the report; the table may not contain
   a pattern that matches nothing. List-shape mutations: drop, duplicate and swap adjacent
   entries of every list; each refused with the list's path.
3. **The card's six categories, each with a named expectation:**

   | Mutation | Expected error |
   | --- | --- |
   | a layer identity (`source_id`) | `layers[k].source_id`: does not hash the layer bytes |
   | a certificate digest | `layers[k].derivation` (or `.ranked`): does not hash the certificate file |
   | a literal mapping (`literals[i].declared` to another construction of the layer) | `layers[k].literals[i]`: the prepared atom names another relation |
   | an input digest (`seeded[i].digest`) | `seeded[i].digest` |
   | a record field (each of the fields in the table above, including the three formerly unchecked) | `complements[i].source`, `filters[i].operator`, `filters[i].literal`, … |
   | a certificate entry (each rule index, premise and tuple value of the derivation certificate; each rank and tuple of the ranked one) with the manifest digest left as is | `layers[k].derivation`: digest mismatch |
   | the same entry with the digest recomputed to match | the core `Rejection` from `check_recorded`, carried with layer and family |

4. **Consistent forgeries**, which pass every digest: a layer source rebuilt with one fact of a
   complement removed and `source_id` recomputed (refused at step 6.5, naming the construction
   and the missing tuple); one input relation's facts changed in a later layer (step 6.4, naming
   the relation and tuple); a rule's negated literal pointed at a complement over another
   relation with the record changed to match (refused by the `P` check on `source`); a filter
   record and its facts rebuilt for another operator (refused on `operator`); `P` replaced by a
   program with one literal's sign changed and the manifest's `program` recomputed (refused by
   the layer rule check, 6.3).
5. **File-level:** each layer and certificate file truncated, extended by a byte, missing,
   and an extra file present; a file above its bound refused before it is read.
6. **In-process `check`:** the existing `a_tampered_complement_record_does_not_rebuild` becomes a
   table over every field of every record kind of the fixture's `Evaluation`, each refused with
   the matching `RecordMismatch`; a `CheckersDisagree` test drives the merge walk directly with
   two relations differing in one tuple and checks the named relation and tuple.
7. **Externals:** each of the five problems refused with its value; the seeded list recorded.

#### Performance

Fermi, before implementing. Nothing below is in the derivation loop: `Demand::evaluate_into` and
every core symbol it reaches are untouched unless D3's core commit perturbs ThinLTO, which the
symbol comparison checks.

- **Default instantiation (`NoEvidence`), the timed `stratify` stage.** Added per evaluation:
  per layer, moving three vectors into the report instead of dropping them (no copy), a 32-byte
  identity copy, and one literal-map vector (one allocation, one push per non-positive
  literal): of the order of 300 instructions a layer. Per construction, the domain-separated
  digest hashes a header of at most about 60 bytes more than today, at most two extra SHA-256
  compressions (the `sha2` crate dispatches to SHA-NI here, a few hundred instructions each):
  about 1,000 instructions a construction. Externals validation: zero, the bench passes none.
  Error enum growth: a larger `Result`, no per-tuple work. Predicted: `datalog` (one layer, no
  constructions) below 1e-6 of its 1.68e9 instructions per iteration; the four construction
  cohorts, with three to five constructions and two or three layers each, a few thousand
  instructions per iteration, which is below 1e-5 if their `stratify` iteration retires more
  than about 5e8 instructions and visible otherwise. Their magnitudes have not been recorded by
  an earlier A/B; the control run will give them, and the prediction is checked against the
  measured per-iteration difference, not only the ratio.
- **Evidence instantiation (`ChainWriter`), untimed.** Per layer: one `encode_prepared` (which
  also decodes and re-admits, milestone a's repair), two certificate serializations and digests,
  three file writes; plus one pass over seeded tuples. Expected of the order of the layer's own
  prepare and certificate cost, so a `rel-lower --chain` run may take up to about twice a plain
  one. Characterized once with `perf stat` on the four construction cohorts, reported, not a
  gate.
- **`check`**: outside every timed stage; under (a) several times the builder's construction
  cost. Characterized once, not a gate.
- **Peak RSS**: default path unchanged; evidence path adds at most one layer's encoding and
  certificates at a time.

A/B, per the playbook:

- Controls retained **before the first source change**, from the clean worktrees (private
  `482d6e9`, core `4b57649`): `retain-bin.sh . closure_ballpark --example --label
  closure_ballpark-c1205b-base` and `retain-bin.sh tasks/tools ergodis-tools --label
  ergodis-tools-c1205b-base`, run in the private worktree so the sibling core is the worktree's.
  rustc read from each binary's `.comment`.
- Candidates retained the same way from the final commits of both branches.
- Symbol comparison first (`analysis/datalog-comparison/symbol_disasm.py`): every
  `ergodis_rules::demand::` symbol in `closure_ballpark`, and the frontend, lowering and
  checker symbols in `ergodis-tools`.
- Derivation loop: `ab.py --mode evaluate --rounds 5 --cpu 5 --repeats 3` over the eighteen
  cohorts, whatever the symbol comparison shows (D3 changes a core crate).
- Stages: `bench.py --rounds 5 --cpu 5 --stages scan,parse,admit,lower,stratify
  --events instructions,cycles,branches,branch-misses,page-faults,minor-faults` over the five
  default cohorts, then over `datalog,stratified,columns,columns3,aggregate` (the four
  construction cohorts are new to this measurement), A/A null per cohort, load recorded.
  Instructions decide; the construction cohorts are read against the Fermi above.
- Receipts committed in private under `analysis/datalog-comparison/` and `analysis/rel-frontend/`,
  arms named with both revisions in this report.

#### Identities that must not move

- Prepared layer identities: the first private commit adds only `LayerReport::source_id` (one
  field, recorded from `demand.source_id()`, no change to layer assembly) and a test pinning the
  layer identities and both certificate digests of every layer of the fixture and of the four
  construction cohorts at small size. Every later commit must pass it unedited.
- Plan fingerprints and the parity digest: the existing `tests/rel_lowering.rs` and
  `tests/rel_frontend_portability.rs` assertions, unedited.
- The reference-evaluator differential: `tests/rel_reference_eval.rs`, its populations unedited
  (under (a) its comparison code moves to the library and is imported back; the populations
  and assertions do not change).
- Core, under D3: every pinned prepared and wire identity and certificate digest in
  `demand_prepared.rs` and `prepared_source.rs`, unedited.

#### Commit plan and gates

Core, branch `c1205b` (only under D3's recommendation):

1. "Hand out a plan's transferable source as one typed value": `TransferableSource`, removal of
   `prepared_encoding`, the core test and `docs/datalog-certificates.md` updates, `SHA256SUMS`.
   Gates: `cargo fmt --all -- --check`; `cargo clippy --all-targets --all-features -- -D
   warnings`; `cargo test --all-features`; `python3 python/generate_evidence.py --write`;
   `python3 python/generate_fixtures.py --check`; `python3 scripts/check-runtime-dependencies.py`;
   `python3 scripts/check-verifier-dependencies.py`.

Private, branch `c1205b`, each commit gated by `cargo fmt --check`, `cargo clippy --all-targets
--all-features -- -D warnings` and `cargo test --all-features` (which includes the parity and
reference-evaluator suites), all under `nix develop ../ergodis`, heavy runs under
`choom -n 1000` with at most 12 jobs:

1. Controls retained (no commit). Then "Record each layer's prepared source identity", with the
   identity pin test.
2. "Refuse unknown, derived, repeated and malformed external inputs, and record what was
   seeded".
3. "Name the failing record, field and tuple in stratified errors": `Error` as above, the merge
   walk, the domain-separated `tuple_digest` replacing `digest_of`.
4. "Separate checked from unchecked stratified results": `Evaluation`, `check`, sealed
   `Stratified`, the literal map and declared relations per layer, `P` (`rel_chain::Program`),
   the construction checker checking every field against `P`, `verify_records` removed, the
   callers in tests and tools updated, the bench description change.
5. "Rebuild constructions independently for the record check" (D1 (a)) or "Share the
   construction code between producer and checker, stated as a replay" (D1 (b)).
6. "Write stratified results as a verifiable chain": the `Evidence` sink, `ChainWriter`, the
   manifest, `rel-lower --chain`.
7. "Verify a stratified chain offline": `rel_verify`, `rel-verify`, the mutation suite, the
   two-process acceptance test.
8. "Record the chain A/B": receipts.

Othello: this report, updated at each step, committed with explicit pathspec.

Close: an independent read-only audit by a fresh Opus sub (card), then `cache-gc.sh` as a dry run
only, with the list reported.

#### Decisions for Tavis, in one place

- **D1, the construction rebuild.** Recommend (a), a separately written set-based rebuild;
  alternative (b), a stated replay plus shipped oracle agreement. Details above.
- **D2, the chain's subject.** Recommend a stratified program statement `P` with its own
  identity; alternative, the layer sources plus the literal map as the program.
- **D3, `prepared_encoding`.** Recommend `transferable_source()` returning
  `TransferableSource`; alternative, `Result<Option<Vec<u8>>, Error>`.
- **D4, verification records.** Recommend none in the chain, fresh records as the verifier's
  output; alternative, producer-stored records replayed as a warning.

Choices stated rather than asked, each reversible within this milestone: checked and unchecked
as distinct types rather than a check inside `evaluate` (timed-stage cost); evidence streamed
through a const-generic sink rather than retained; JSON for the manifest and `P`, binary only
for the core's prepared form; hex digests in the manifest; the verifier's size bounds as the
caller-supplied bound milestone a left open, with no core change; external inputs for a derived
relation refused (a defect beyond the review's two); the `--source-check` option off by
default; `producer.json` outside the chain.

### Implementation

Written incrementally. Steps 1 to 7 are done; only the close (step 8) remains, under
"Remaining steps".

#### Controls

Retained before any source change, from the clean worktrees (private `482d6e9`, core `4b57649`),
in the private worktree so the sibling core is the worktree's, release profile, default
features, through the core flake's devShell:

```sh
cd ~/.cache/ergodis/worktrees/c1205b/ergodis-private
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --label closure_ballpark-c1205b-base
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools --label ergodis-tools-c1205b-base
```

Measured sha256: `closure_ballpark-c1205b-base-482d6e9`
`7de079c9dc9995d05a732fe30f07ae7de796a550b1672536aa28de93551ba0c1`, `ergodis-tools-c1205b-base-482d6e9`
`2ee930b376f7aabde348559329178476456df7f191296f521537306ec16c75a0`. The rustc version is to be read
from each binary's `.comment` when the A/B is written up.

#### Commits

| Repository, branch | Commit | What |
| --- | --- | --- |
| core `c1205b` | `064cde2` | D3: `Demand::transferable_source()` returning `TransferableSource::{Wire(&Program), Prepared(Vec<u8>)}` with `as_source()`; `prepared_encoding` removed; `demand_prepared.rs` and `docs/datalog-certificates.md` updated; `SHA256SUMS` |
| private `c1205b` | `1f8200b` | `LayerReport::source_id` (recorded from `demand.source_id()`, no change to layer assembly); fixture `tests/rel_chain/demo.rel` (three layers: shared complement with `uses = 2`, a `Dictionary` domain, `=` and `>` filters, `count` and `sum` aggregates with a dictionary extension, the free name `ext`); `tests/rel_layer_identities.rs` pinning every layer identity of the fixture and of the `stratified`, `columns` (16), `columns3` (8) and `aggregate` (16) cohorts |
| private `c1205b` | `d77f3d2` | Externals: `Error::External { spelling, problem }` with `ExternalProblem::{Unknown, Derived, Repeated, Arity, Value}`, all checked before anything is seeded; `Stratified::seeded: Vec<Seeded { relation, spelling, external_tuples }>`; `tests/rel_externals.rs`; bench error witness `6 << 60` for the new variant |
| private `c1205b` | `3940964` | Remaining steps 2 and 3 as one commit (see "Steps 2 and 3" below): `evaluate` returns `Evaluation`; `check(Evaluation, &Rir) -> Result<Stratified, Error>` with a sealed `Stratified` (`Deref<Target = Evaluation>`, `into_evaluation`); per layer `declared: Vec<Declared { name, arity, input, origin }>` and `literals: Vec<LiteralMap { literal, declared }>`; new `src/rel_chain.rs` (the program statement `Program`, the record types moved out of `rel_stratified` and re-exported from it, `tuple_digest`, `check_constructions`, `derived_layers`, `rules_of`); new `src/rel_rebuild.rs` (the independent set-based rebuild, `Value`, `compare`); the reference evaluator imports `Value` and `compare` back; `verify_records` removed; callers, `rel-lower` and the bench description updated; `tests/rel_check.rs` |
| private `c1205b` | `48ccaaa` | `Error::CheckersDisagree(Disagreement { layer, relation, tuple, held_by, missing_from })` with `Party::{Derivation, Ranked, Evaluator}` and a merge walk (`first_difference`), for both the derivation/ranked and the checker/evaluator comparison; `Error::Record(RecordMismatch { kind, index, field })` replacing `ComplementMismatch`, with `RecordKind`, `RecordField`, `DomainPart` and a `Display` path such as `complements[0].column_domains[0].values`; `tuple_digest(DigestKind, scope, name, arity, tuples)` under tag `ergodis-private/rel-chain.v1` replacing `digest_of` in the builder and the record check; the tamper test now asserts the field of each of its seven tampers; unit tests for the disagreement and for digest separation; the bench witness keeps `3 << 60 | layer` and `4 << 60 | index` |
| private `c1205b` | `c7d6ffa` | Step 4: `rel_chain::Evidence` (`const RETAIN`), `NoEvidence`, `ChainWriter` (directory or memory, layer files written as they arrive, only the two certificate digests kept), `Manifest`/`ManifestLayer`/`SeededEntry`/`ResultEntry` with hex digests (`to_hex`, `parse_hex`, lowercase 64 digits only), serde on every record type, `LayerFile` names, `LoweringParameters` (the one definition of the operator tool's lowering limits); `rel_stratified::evaluate_with<E: Evidence>` (`evaluate` is its `NoEvidence` instantiation), `Error::Evidence { layer, message }` (bench witness `7 << 60 \| layer`), `LayerReport::domain`, `manifest(&Stratified, &Program, &[LayerDigests])`; `check_constructions_observed`, which hands each rebuilt construction to a callback; `rel-lower --chain <dir> --externals <json>` writing `source.rel`, `lowering.json` and `producer.json` beside the chain; `tests/rel_chain.rs` (file set, manifest round trip, identities, hex strictness) |
| private `c1205b` | `6c0d24a` | Step 5: `src/rel_verify.rs` (`verify_chain`, `verify_parts`, `Bounds`, sealed `VerifiedChain`, `ChainError { file, layer, path, problem }`, `LayerRecords`); `ergodis-tools rel-verify <dir> [--source-check] [--records <file>] [--max-layer-bytes N] [--max-certificate-bytes N]`, one JSON line, exit status 1 on refusal; `tests/rel_chain.rs` extended (acceptance and replay of the emitted records, a round trip of every accepted program of four generated corpora, the dependency-closure source scan, the card's named single-field mutations and three file-level cases) |
| private `c1205b` | `0d270c7` | Defect found by the list-shape mutations (step 6): a layer's literal-map entries in another order were accepted, so one chain had several spellings and identities. The driver now records the map ascending by literal and `check_constructions` refuses an entry out of order (`LiteralEntry { index }`); `tests/rel_check.rs::a_literal_map_out_of_order_is_refused` |
| private `c1205b` | `745b5b6` | Error attribution found by the leaf mutations (step 6): a construction declared in a layer its record does not name let that layer's tuples replace the construction's own in the verifier's `given` map (keyed by origin only), so the refusal named a difference at the record's layer instead of the bad declaration; each construction declaration is now checked against its record's layer and index first (`rel_verify::record_place`). A derived relation no layer derives is named at its first declaration's `input` rather than at the last layer's declarations; `tests/rel_check.rs::a_derived_relation_declared_as_input_is_refused_at_its_declaration` |
| private `c1205b` | `db37035` | Step 6: the tests (see "Step 6" below): `tasks/tools/tests/rel_chain.rs` (two processes), the leaf, list, certificate-entry, forgery and file suites in `tests/rel_chain.rs`, fixture `tests/rel_chain/fallback.rel`, `tests/rel_layer_identities.rs::the_certificate_digests_of_every_layer_are_pinned`; `ergodis-contract` as a dev-dependency of `ergodis-tools` |
| private `c1205b` | `4138f8b` | Step 7 receipts: `analysis/datalog-comparison/ab-2026-09-22-chain-derivation-loop.json` (+ `.jsonl`), `analysis/rel-frontend/performance-v11-chain-db37035.json`, `performance-v11-chain-constructions-db37035.json` |
| private `c1205b` | `222b4f8` | Step 7 remainder receipts, `analysis/rel-frontend/chain-stage-shift/`: callgrind attribution of the `lower` and `stratify` stages (`callgrind_attribution.py`, `callgrind-{lower,stratify}-<cohort>.json`), the glibc mmap-threshold A/B (`mmap_threshold.py`, `mmap-threshold-<cohort>.json`), peak RSS (`peak_rss.py`, `peak-rss.json`, `peak-rss-mmap-threshold.json`), massif peak trees of the `stratified` cohort, the executed-instruction mix of the lowering body and `dedup_rows` (`instr_mix.py`, `instr-mix.txt`), the normalized `dedup_rows` disassembly diff, the chain cost (`chain_cost.py`, `chain-cost-512.json`), and `call_counts.py` |
| private `c1205b` | `6575bba` | `evaluate_with` drops the ranked checker's relations (`searched`) right after the derivation/ranked comparison, before the checker/evaluator comparison where a layer's memory peaks |
| private `c1205b` | `71c25e7` | `rel-lower --chain` stages the chain in a sibling `<name>.partial-<pid>` directory and renames it into place only when complete (the staging directory is removed on every other exit); each refusal path returns an error with `--chain`, so the process exits 1; `tasks/tools/tests/rel_chain.rs::a_refused_run_exits_with_an_error_and_leaves_no_chain` |
| private `c1205b` | `267acdd` | Receipts for the two fixes: `analysis/rel-frontend/performance-v11-chain-drop-71c25e7.json`, `chain-stage-shift/peak-rss-drop-71c25e7.json`, `peak-rss-drop-71c25e7-mmap-threshold.json`; `peak_rss.py` takes a candidate binary and cohort list |

Core gate at `064cde2`: `generate_evidence.py --write`, `cargo fmt --all -- --check`, `cargo clippy
--all-targets --all-features -D warnings`, `cargo test --all-features` (85 `ok` blocks, zero
FAILED), `generate_fixtures.py --check`, `check-runtime-dependencies.py`,
`check-verifier-dependencies.py`: all passed in one run. Every pinned identity and certificate
digest in `demand_prepared.rs` and `prepared_source.rs` passed unedited. Native and WASM ABI
harnesses at `064cde2`, from the core worktree with the milestone a replay commands (release
`ergodis-rules`, then `native_abi.py`; wasm32 release build, then `wasm_abi.mjs` against the
native certificate output): both passed, "129 min-plus programs, one Boolean closure,
independent oracle, source/claim/handle/capacity lifecycle gates passed" and "129 programs,
native certificate and Python oracle parity, lifecycle gates passed". Measured sha256 of the
artifacts: `libergodis_rules.so` `e38d2dee2aea1fc3f511f71c139f6d1085bcc4f44f01027d357f07af47ee63cf`,
`ergodis_rules.wasm` `af0e76e91b05f28016ea89ec80e127078b1c573dc8e65796422f79dac6477c6e`.

Private gates per commit: `cargo fmt --check`, `cargo clippy --all-targets --all-features -D
warnings`, and the suites `rel_layer_identities`, `rel_externals`, `rel_lowering` (53, the
parity and fingerprint assertions unedited) and `rel_reference_eval` (19, the differential
unedited), all green at `1f8200b`, `d77f3d2` and `48ccaaa`. Full private `cargo test
--all-features --no-fail-fast` on the tree committed as `48ccaaa` (against core `064cde2`):
exit 0, 17 min, 42 `ok` blocks, 1,177 passed, 0 failed. This milestone adds five tests so far
(the identity pin, two externals tests, two `rel_stratified` unit tests); the base count at
`482d6e9` was not rerun, so the remaining difference from milestone a's 1,171 is unattributed.
Full private `cargo test --all-features --no-fail-fast -j 12` at `4138f8b` (against core
`064cde2`, under `nix develop ../ergodis`): exit 0, 14 min, 44 `ok` blocks, 1,196 passed, 0
failed, 17 ignored. Nothing to fix. The tree was clean at the start; the untracked receipt
directory of `222b4f8` was written during the run and is read by no test.

Gates at `71c25e7` (the two fixes; receipts `267acdd` add no code): `cargo fmt --all --check`
clean; clippy `--all-targets --all-features -D warnings` clean for the root and for `-p
ergodis-tools`; `rel_chain` (12), `rel_check` (3), `rel_layer_identities` (2, pins
unedited), `rel_externals` (2), `rel_frontend_portability` (2), `rel_lowering` (53, parity and
fingerprint assertions unedited), `rel_reference_eval` (19, the differential unedited), the
library's `rel_` unit tests (5) and `ergodis-tools` (41 + 3 + 2, the new refusal test
included): all green. Full private `cargo test --all-features --no-fail-fast -j 12` at
`267acdd`, clean tree: the 43 test binaries 1,194 passed, 0 failed, 17 ignored; the doctest
target failed to compile, and on rerun alone after the step below, passed (2). Cause, foreign:
another session built `~/src/ergodis-private` against `~/src/ergodis` into the shared target
at 18:30 and again at 18:48, overwriting the unhashed `debug/deps/libergodis_rules.rlib`
(the crate also builds a `cdylib`, so its rlib carries no metadata hash), and rustdoc then
linked `ergodis_rules` from `~/src/ergodis`, which lacks `TransferableSource`. `cargo clean -p
ergodis-rules --profile dev` (this crate's dev artifacts only) and an immediate rerun of the
doctests fixed it. Totals as at `4138f8b`: 44 blocks, 1,196 passed (the root package's `cargo
test` does not build `ergodis-tools`, whose tests ran separately above). The collision
recurs whenever both trees build into the shared target; it affects any `c1205b` gate run
while the main checkout is being built.

#### Steps 2 and 3: checked types, the program statement and the independent rebuild

Committed together as `3940964`: the construction checker of step 2 has to call a rebuild, and
writing it against the builder's functions only to replace them one commit later would have
been throwaway code. What was built, and where it departs from the design text:

- **`bench.py` and `records_verified`.** `bench.py` compares only `tokens`, `nodes`, `failure`,
  `admission` and `fingerprint` between arms (its `for field in (...)` loop); it never reads the
  `stratification` description. So the field was dropped outright, not kept as a constant. The
  description now runs `check` and, on failure, emits only
  `{"stratified":false,"error":"record check: ..."}`.
- **Binding sites are carried in `P`, not recomputed from the rule body.** The design's claim
  that "a verifier can recompute every site list from the rule alone" is false for binarized
  rules: the `bind` pass runs before binarization, and a synthetic rule shares its parent's
  variable pool and so its parent's binding sites, which can name relations the synthetic rule's
  own body does not read. `ProgramRule` therefore has `bindings: Vec<Vec<(relation, column)>>`
  per rule-local variable, read from `Rir::binding_sites`. It is still a pure function of the
  lowered IR, so D2 stands. (Superseded after the audit: the verifier took these sites on
  trust. `P` now also carries each chain rule's source body and the verifier recomputes every
  site; see "Repairs after audit".) Other `P` field shapes: `body: [first, last]`, `order`,
  `variables`; `ProgramLiteral { sign, op, relation: Option, aggregate_column: Option, terms }`
  with `ProgramTerm::{Constant(id), Variable(var)}`; `type_ranges: Vec<[u32; 2]>` per value kind.
- **The record types live in `rel_chain`**, re-exported from `rel_stratified` so every existing
  path compiles unchanged, because `rel_verify` must not import `rel_stratified`.
- **Sharing is decided on domain values.** The builder shares a complement or filter between
  literals whose domains hold the same values even when their provenance differs, and records
  the first literal's (in rule order, then literal id). The checker follows that; the design's
  sharing row said "signatures (relation or operator or aggregate spec, plus domains)", which is
  this reading. The fixture exercises it: the `lone` literal's variable falls back to the
  whole dictionary, whose values equal `node`'s bound domain, so it shares the `path`
  complement with `unreached` and `gap` (`uses = 3`), and no record in the fixture carries a
  `Dictionary` source. The report's earlier description of the fixture ("a `Dictionary` domain",
  "`uses = 2`") is corrected here.
- **Errors.** `RecordKind` gained `Layer` (index is the layer), `Seeded` and `Dictionary` (index
  is the value id); `RecordField` gained `Literal`, `Layer`, `Uses`, `Declared`, `Name`,
  `Dictionary`, `DictionaryBefore`, `Position`, `Declarations`, `DeclaredRelation { index,
  part }`, `Literals`, `LiteralEntry { index }` and `Value`; `DomainPart` gained `ColumnType`,
  `TypeStart`, `TypeEnd`. `Display` renders, for example, `layers[1].declared[4].origin` or
  `complements[0].column_domains[0].type_start`.
- **What the in-process `check` does not check:** that the prepared rules are `P`'s rules
  (design step 6.3). `check` has no decoded layer source; the offline verifier does it.
- **`rel-lower`** keeps its `complement_records_verified` output key, now meaning that `check`
  passed; it prints only from a `Stratified`.

Tests: `tests/rel_check.rs` (new) changes one field of the fixture's evaluation per case and
requires the error to name it: complement `source` (formerly unchecked), `relation`,
`dictionary`, `column_type`, `type_start`, `type_end`; filter `operator` and `literal` (both
formerly unchecked), `uses`; aggregate `column`, `source`, `dictionary_before`, `interned`;
seeded `spelling`; the shared complement's `uses`; a literal-map entry redirected and one
dropped; a declared name; a construction declared under another origin; a dictionary extension
entry. The tamper test in `tests/rel_lowering.rs` now runs `check` on an `Evaluation`; its
provenance tamper is refused as `column_domains[0].source`, since provenance is now recomputed
from `P` rather than resolved as recorded. The differential of `rel_rebuild` against the
builder is `check` itself on every accepted program of `tests/rel_lowering.rs` and every corpus
program of `tests/rel_reference_eval.rs` (the committed fixtures, the generated corpus and the
negation corpus): each construction the builder recorded is rebuilt independently and its
digest compared. `rel-lower` also passes `check` on the chain fixture and on the `stratified`,
`columns`, `columns3` and `aggregate` cohorts at 16 definitions.

Construction-level mutation checks, in the detached scratch worktree
`~/.cache/ergodis/worktrees/c1205b-mut/ergodis-private` at `3940964` (sibling `ergodis` a
symbolic link to the `c1205b` core worktree), one mutation of the builder at a time, reverted
before the next (the worktree is clean), each run against `rel_check`, `rel_lowering` and
`rel_reference_eval`:

| Builder mutation | Caught as |
| --- | --- |
| off-by-one domain: `union_of_sites` sets the bit of `value − 1` | `ColumnDomain { column, part: Values }` on complements and filters; 15 `rel_lowering` and 6 `rel_reference_eval` failures, `rel_check` failed |
| swapped operator: `CMP_LT` decided as `a > b` | filter `Facts` and `Digest`; 3 and 3 failures (`rel_check` passes: the fixture has no `<`) |
| wrong group key: the key drops column 0 instead of the aggregated column | aggregate `Digest`; 7 and 3 failures, `rel_check` failed |

Gates at `3940964` (against core `064cde2`), under `nix develop ../ergodis`: `cargo fmt --all
--check` clean; `cargo clippy --all-targets --all-features -D warnings` clean for the root
package and for `-p ergodis-tools`; suites `rel_layer_identities` (the pins, unedited, pass),
`rel_externals`, `rel_lowering` (53, parity and fingerprint assertions unedited),
`rel_reference_eval` (19, populations and assertions unedited; its comparison code is now the
library's), `rel_frontend_portability`, `rel_check`, the library's `rel_` unit tests (5), and
all of `ergodis-tools`' tests (44): all green. The full private `cargo test --all-features` was
not rerun at this commit; it belongs to the close.

#### Step 6: the tests

Committed as `db37035`, after the two fixes the suites exposed (`0d270c7`, `745b5b6`).

- **Two processes** (`tasks/tools/tests/rel_chain.rs::a_chain_written_by_one_process_is_accepted_by_another`):
  the built `ergodis-tools` runs `rel-lower --source-file tests/rel_chain/demo.rel --chain <dir>
  --externals <json>` in one child process and `rel-verify <dir> --records <file>` in another,
  with and without `--source-check`; the verifier prints `accepted: true` with the chain and
  program identities and the result table (relation, tuple count, digest) the producer printed;
  every issued record passes `replay_derivation`/`replay_ranked` against the chain's files; then
  one layer file extended on disk is refused by a third process with exit status 1 at
  `chain.json` `layers[1].source_id`. The directory is under `CARGO_TARGET_TMPDIR` and removed.
- **Every manifest leaf** (`every_manifest_leaf_mutation_is_refused_at_its_field`), over both
  fixtures: 968 mutations (integer plus one and zeroed, digest nibble, string byte, boolean,
  every other enum tag). Each is refused, at its own path unless a row of the reviewed table
  `LEAF_TABLE` says otherwise; every row must match some mutation. The rows fall under four
  reasons, stated in the test: a field compared as a whole names the whole (domain values and
  provenance, group columns, a literal-map entry, a dictionary entry); of two fields that must
  agree, the declaration's side is named (a construction's name, arity, layer and declaration
  index against the declaration pointing at it; a declaration's program id against its name);
  a literal-map entry naming another literal leaves its literal unmapped, which the rule check
  names at `layers[k].literals`; and a provenance tag with a payload of another shape, or an
  origin tag swap that orphans a derived relation, is refused by the decoder or at the last
  layer's declarations.
- **Every list** (`every_list_shape_mutation_is_refused_at_its_list`): 448 mutations (each entry
  dropped, duplicated, swapped with the next), refused at the list or inside it, with the table
  `LIST_TABLE` for construction lists (named at the declaration whose index moved), binding-site
  lists (the provenance), the layer list (a file unexpected or missing) and a dropped derived
  declaration (the last layer's declarations). The literal-map reordering was accepted before
  `0d270c7`.
- **Every certificate entry** (`every_certificate_entry_mutation_is_refused`): every layer's
  derivation certificate, each rule index, premise and tuple value plus one and zeroed (379), and
  its ranked certificate, each rank zeroed and lowered by one and each tuple value plus one and
  zeroed (183). With the manifest digest kept, each is refused at `layers[k].derivation` or
  `.ranked`; with the digest recomputed, by the core checker of its family (`Rejected`), carried
  with the layer and file, except three premise changes that the checker accepts, correctly: the
  rule `some(x) = unreached(x, _)` admits any `unreached` tuple with that `x` as its premise,
  and the three moved references land on another such tuple. The test allows acceptance only for
  premises and only with the original relations established. Raising a rank is not tried: a
  higher rank than the premises need is still a valid certificate.
- **Consistent forgeries** (`consistent_forgeries_are_refused_by_what_they_contradict`), each
  passing every digest and both core checkers (the layer re-admitted from its decoded form,
  evaluated and certified by `Demand`, identity and digests recomputed; the forging path with no
  edit reproduces the layer files byte for byte): a complement fact removed (refused at
  `layer-1.prepared` `complements[0]`, `Differs` with the removed tuple); a seeded relation's
  tuple removed in a later layer (`layers[1].declared[0]`, `Differs` naming `node` and the
  tuple); a complement record pointed at another relation of the same arity with its source
  name to match (`complements[1].relation`: the statement's check on the relation id comes before
  the one on `source`, so the design's expected `source` is named as `relation`); a filter
  rebuilt for `<` with facts, count and digest recomputed and the layer re-certified
  (`filters[0].operator`); and the statement with one negated literal made positive and its
  identity recomputed (`layer-1.prepared` `rules[j]`, the rule check).
- **Files** (`truncated_and_extended_files_are_refused`): every layer and certificate file and
  both JSON files, truncated by one byte, extended by `x`, and extended by a newline. A layer
  encoding no longer hashes to its identity (`layers[k].source_id`); every other change is a
  decode refusal at the file, except whitespace after a JSON value, which decodes to the same
  value and is accepted with the same chain identity. That is the design's stated property (a
  JSON file is named by the digest of what it decodes to, so two spellings have one identity),
  now asserted. A certificate above `--max-certificate-bytes` is refused before it is read.
- **Second fixture** `tests/rel_chain/fallback.rel`: the text constant `"a"` makes the fallback
  domain of `lone`'s negated literal (five values) differ from `node`'s bound domain (four), so
  the complement over `path` is built twice and one record carries a `Dictionary` provenance
  over the whole dictionary; `x > 2` gives a `Constant` operand. Accepted by the verifier; both
  mutation suites run over it too. `demo.rel` is unedited.
- **Certificate pins** (`tests/rel_layer_identities.rs::the_certificate_digests_of_every_layer_are_pinned`):
  per layer, the source identity and both certificate digests from `ChainWriter::layers()`, for
  both fixtures and the `stratified` (16), `columns` (16), `columns3` (8) and `aggregate` (16)
  cohorts. Its layer identities equal the existing pins, which are unedited.

Gates at `db37035` (against core `064cde2`): `cargo fmt --all --check` clean; clippy
`--all-targets --all-features -D warnings` clean for the root and `ergodis-tools`; suites
`rel_chain` (12), `rel_check` (3), `rel_layer_identities` (2, the original pin unedited),
`rel_externals`, `rel_frontend_portability`, `rel_lowering` (53, parity and fingerprint
assertions unedited), `rel_reference_eval` (19, the differential unedited), the library's `rel_`
unit tests (5) and `ergodis-tools` (41 + 3 + 1): all green.

#### Step 7: the A/B (receipts `4138f8b`)

Arms, all rustc 1.95.0 (59807616e 2026-04-14) read from each binary's `.comment`, release, default
features, retained with `~/src/ergodis-dev/scripts/retain-bin.sh` from clean trees in the private
worktree with `ERGODIS_FLAKE_DIR` set to the core worktree:

| Arm | Private | Core | Dirty | Retained name | Measured sha256 |
| --- | --- | --- | --- | --- | --- |
| control, derivation loop | `482d6e9` | `4b57649` | no | `closure_ballpark-c1205b-base-482d6e9` | `7de079c9…ba0c1` |
| control, stages | `482d6e9` | `4b57649` | no | `ergodis-tools-c1205b-base-482d6e9` | `2ee930b3…c75a0` |
| candidate, derivation loop | `db37035` | `064cde2` | no | `closure_ballpark-c1205b-db37035` | `03fb4927…12a83` |
| candidate, stages | `db37035` | `064cde2` | no | `ergodis-tools-c1205b-db37035` | `00a0ddb2…fc9f5` |

Method as milestone a: event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`,
100 per cent enabled on every measurement, five rounds alternating arm order, A/A null per cohort,
core 5, two-point differencing. Runner and logs under `~/.cache/ergodis/c1205b/`.

- **Derivation loop** (`ab.py --mode evaluate --repeats 3`, eighteen cohorts, load 0.72–0.89,
  no failures; receipt `analysis/datalog-comparison/ab-2026-09-22-chain-derivation-loop.json`):
  instruction ratios 0.99994 to 1.00001, every interval within about 1e-4 of unity and each
  null of the same size (largest `mutual:blocks:8192` 0.99994 [0.99988, 1.00000], null 0.99996);
  derived counts equal on every cohort; peak RSS within 16 KiB on every cohort. Symbol
  comparison (normalized `symbol_disasm.py`): of 61 `ergodis_rules::` symbols 58 are identical;
  one `Demand::evaluate_counting` instantiation (0x8e95 control, 0x8e64 candidate) differs in
  register allocation and spill slots, a ThinLTO perturbation from the D3 core commit (the
  loop's source is unchanged), and the other (0x87e6) is identical. The counts show no effect.
- **Stages, five default cohorts** (receipt `analysis/rel-frontend/performance-v11-chain-db37035.json`,
  load 1.2–1.8): scan, parse and admit within 4e-5 of unity; `lower` and `stratify` 0.99992 to
  0.99997 except `comment-string`, 0.9951–0.9957 (fewer instructions); `prepare` 1.00516
  [1.00498, 1.00534] (more).
- **Stages, construction cohorts** (receipt
  `analysis/rel-frontend/performance-v11-chain-constructions-db37035.json`, load 1.0–1.9):

  | Cohort | `lower` (byte/scalar) | `stratify` (byte/scalar) | scan, parse, admit |
  | --- | --- | --- | --- |
  | `datalog` | 0.99701 / 0.99728 | 0.99975 / 0.99975 | within 1e-5 |
  | `stratified` | 0.99263 / 0.99350 | 0.99973 / 0.99973 | within 2e-5 |
  | `columns` | 0.99271 / 0.99378 | 0.99973 / 0.99973 | within 1e-5 |
  | `columns3` | 0.99267 / 0.99357 | 0.99772 / 0.99790 | within 1e-5 |
  | `aggregate` | 0.99304 / 0.99385 | 0.99971 / 0.99971 | within 2e-5 |

  Every `lower` and `stratify` interval is narrower than 1e-5 (at most 3.6e-6); `scan` and
  `parse` intervals reach 7.4e-5 and 2.8e-5. Every A/A null reads 1.00000. Cycles settle nothing
  (intervals up to ±20 per cent on `datalog`).
- **Against the Fermi.** The Fermi predicted the timed `stratify` stage would *gain* a few
  thousand instructions per iteration on the construction cohorts; on four of them it lost
  0.2–0.4 million, and `lower`, which this milestone did not touch, lost 17–35 thousand.
  "Stage shifts, explained" below attributes both: code generation in functions whose source
  did not change, plus a heap-layout term, with the milestone's own added work bounded above
  by about 20 thousand instructions per iteration (an upper bound, not an attribution; see
  item 5 there), visible only on `columns3`, where little else runs.
- **Evidence out of the hot loop, by disassembly.** The candidate `ergodis-tools` has two
  `evaluate_with` instantiations (0x7ace and 0x7548 bytes). `evaluate` calls the 0x7548 one.
  Its callees do not include `Demand::transferable_source` or `<ChainWriter as Evidence>::layer`,
  which appear only among the other instantiation's callees, so the default `NoEvidence`
  instantiation has no sink code. A kernel-scoped `perf record` was not taken.

#### Stage shifts, explained (receipts `222b4f8`)

The bench stages are cumulative (`lower` runs parse, admit and lower; `stratify` runs all of
those and the backend), so each stage's own difference is read as a difference of stages.
Per-iteration instruction differences, candidate minus control, from the receipts at
`4138f8b`: scan, parse and admit within 25 on every construction cohort; the `lower` stage's
delta (the stage figure itself; `lower` − `admit` differs from it by at most 22) −16,953 (`datalog`), −28,947 (`stratified`), −35,141 (`columns`), −35,064
(`columns3`), −25,876 (`aggregate`); on the default cohorts −330 (`ascii`, `unicode`), −18,353
(`comment-string`) and zero on the two malformed cohorts, which never reach lowering.
`stratify`'s own (`stratify` − `lower`): −402,650, −399,398, −384,972, +16,598, −178,964.

Method: events counted, not shares. Each stage was run under callgrind at two repeat counts
per arm (`--repeat 32/64` for `lower`, `2/4` for `stratify`, 512 definitions, byte scanner)
and each function's per-iteration self cost taken as the difference, which removes startup and
the untimed description as `bench.py`'s differencing does. Callgrind is deterministic here
(three runs of one arm agree to 50 instructions in 5.1e9). It counts guest instructions: a
`rep movsb` counts per byte and `sha2` runs its portable compression, since valgrind does not
expose SHA-NI; the buckets keep those apart. Normalized disassembly
(`symbol_disasm.normalized`) compares code; `call_counts.py` confirms equal call counts.

- **`lower`: code generation, no work removed.** Callgrind's per-iteration lowering
  differences equal the perf ones to within 50 on every cohort (−16,996, −28,934, −35,148,
  −35,064, −25,874). `rel_frontend` source is identical between the arms. The ThinLTO
  inliner changed the shape: in the control `lower::run` holds the whole lowering with the
  passes inlined and `lower::lower` is a shell; in the candidate `run` is inlined into
  `lower::lower` (0x362f bytes) and five passes (`stratify`, `project`, `range_restrict`,
  `bind`, `plan_bodies`) are out of line, four more calls per lowering. The callees with most
  of the remaining cost (`build::constant`, `Rir::fingerprint`) are identical by normalized
  disassembly and retire the same counts. The executed-instruction mix of the lowering code
  on `stratified`, per lowering (`instr-mix.txt`): register-only instructions −45.3 thousand,
  loads other than stack −28.0 thousand, stores other than stack −4.7 thousand, stack loads
  +24.2 thousand, stack stores +26.7 thousand, branches −1.6 thousand (the receipt's branch
  difference is −1,643). The candidate keeps values in stack slots where the control
  re-derived or re-loaded them through pointers: a register-allocation outcome of a
  different inlining, not less lowering. `Workspace::admit` inlining `admit::admit` (0x92 to
  0x9e5 bytes) retires the same count (−26 per iteration).
- **`stratify`'s own shift: three code-generation moves, one heap-layout term, and the
  milestone's real added work.** Per iteration:

  | Cohort | native own Δ | native own Δ, fixed mmap threshold | callgrind: `dedup_rows` + slice sort | tuple digest (self) | rest of the code | code sum | heap-layout term (native − fixed) |
  | --- | --- | --- | --- | --- | --- | --- | --- |
  | `datalog` | −402,413 | −304,573 | −327,101 | 0 | +12,724 | −314,377 | −97,840 |
  | `stratified` | −399,127 | −437,341 | −524,648 | +65,529 | +8,126 | −450,993 | +38,214 |
  | `columns` | −384,990 | −452,295 | −525,158 | +65,529 | +9,156 | −450,473 | +67,305 |
  | `columns3` | +19,500 | +19,590 | −2,288 | +97 | +8,829 | +6,638 | −90 |
  | `aggregate` | −179,257 | −199,664 | −266,184 | +33,348 | +2,328 | −230,508 | +20,407 |

  "Native" is `perf stat` instructions with two-point differencing (`mmap_threshold.py`, three
  alternating rounds, every per-arm spread below 1,700); "fixed mmap threshold" reruns it
  with `GLIBC_TUNABLES=glibc.malloc.mmap_threshold=131072`, which turns off glibc's dynamic
  threshold and with it the heap-layout dependence of which allocations are mapped and which
  reallocations copy. The code sum leaves out callgrind's memcpy, allocator and SHA buckets,
  which depend on heap layout or on the SHA implementation. With the threshold fixed, the
  native difference and the callgrind code sum agree within 10 thousand on `datalog`, 14 on
  `stratified`, 2 on `columns`, 13 on `columns3` and 31 on `aggregate` (at most 4.3e-5 of the
  stage on the four long cohorts).
  1. **`dedup_rows`: register allocation, one instruction per tuple comparison.** Its source
     is unchanged and it is called the same number of times (75 in a `stratified` run, as is
     its callee `bcmp`, 1,576,788 times per three evaluations). Normalized disassembly
     (`dedup-rows-normalized-disasm.diff`, 0x1f4 to 0x1fe bytes): the candidate keeps the
     loop's `1 − n` in `r12` and spills one register across the `bcmp` call; the control kept
     it on the stack and moved two registers per iteration. Executed mix (`instr-mix.txt`):
     register moves −3.147 million, stack stores +1.574 million per three evaluations, net
     −1.574 million, one instruction per comparison: −525 thousand per iteration on
     `stratified` and `columns`, −266 thousand on `aggregate`, −264 thousand on `datalog`.
  2. **The slice sort's small-sort instantiation.** `small_sort_general` in the control,
     `small_sort_general_with_scratch` in the candidate, same call counts: −78 thousand per
     iteration on `datalog`, about zero elsewhere.
  3. **`tuple_digest` against `digest_of`: real, small.** The same bytes are hashed except
     for the domain-separated header, which adds three SHA-256 compressions per iteration on
     `stratified` (32,659 to 32,662) and one on `columns3`; the rewritten per-tuple feed loop
     retires 1.0 per cent more (+65.5 thousand on `stratified`, `columns`; +33 thousand on
     `aggregate`). The Fermi priced the header at about 1,000 instructions per construction;
     it did not price a slower feed loop.
  4. **The heap-layout term.** Native minus fixed-threshold: −98 thousand to +67 thousand,
     either sign. glibc's dynamic mmap threshold rises after the first large free, so where
     each arm's large vectors land, and whether a `realloc` moves them, follows the
     allocation history, which the candidate's changed evaluation reshapes. Callgrind shows
     the same kind of term with its own layout: on `aggregate`, +522 thousand memcpy per
     iteration comes entirely from `_int_realloc` copies (realloc calls 220 against 221).
     Not Ergodis work; any change to allocation order moves it.
  5. **The milestone's own added work is at most about 20 thousand per iteration**; the
     figures below are an upper bound, not an attribution. The "rest of the code" column
     mixes code generation with work: on `datalog` (one layer, no construction) its +12,724
     is `ergodis_rules`/`verify`/`contract` +3,954, whose source is unchanged apart from the
     core commit's perturbation, and other functions +9,176; on `columns3`, +6.8 thousand is
     the `evaluate` body moving into `evaluate_with`. The attributable part is the header
     compressions and the per-layer declaration and literal-map vectors. The column plus
     the header compressions: +8 to +13 thousand on `datalog`, `stratified` and `columns` (+2 thousand on
     `aggregate`, where an inlining move between `aggregate_over` and `BTreeMap::insert`
     offsets part of it), +15 to +20 thousand natively on `columns3` (whose 512-definition run is refused by the complement
     budget in its second layer, so the stage is short and nothing masks it). The Fermi said
     "a few thousand per iteration"; the measured figure is three to five times that, from
     the `evaluate` shell now calling `evaluate_with` (+6.4 thousand on `columns3`), the per
     layer declaration and literal-map vectors and their allocations (+4.2 thousand), and
     the header compressions.
- **`prepare` +174 per iteration: allocator path, not code.** `Workspace::new` is identical by
  normalized disassembly (0x129a bytes both). Under callgrind the candidate retires 70 fewer
  per iteration, all of it inside glibc's `_int_malloc`, `_int_free` and `unlink_chunk`. The
  stage is one allocation and drop of the workspace pools, whose glibc path depends on the
  heap state the process reaches before the loop, which differs between the two binaries
  (the candidate's command tree is larger). Branches +53 are consistent with that.

#### Peak RSS, Rel stages (receipts `222b4f8`)

`peak_rss.py`: VmHWM, as the bench binary reports it after `exec`, one fresh process per
measurement, `--repeat 2`, 512 definitions, byte scanner, five alternating rounds; median KiB,
with the fixed-mmap-threshold run (three rounds, `stratify` only) beside it. `wait4`'s
`ru_maxrss` is recorded too but is floored at the forking interpreter's 14.6 MB and not used.

| Cohort | `stratify` control | `stratify` candidate | Δ | fixed threshold: control | candidate | Δ |
| --- | --- | --- | --- | --- | --- | --- |
| `datalog` | 25,072 | 26,724 | +1,652 | 24,620 | 24,808 | +188 |
| `stratified` | 51,688 | 58,088 | +6,400 | 50,476 | 54,900 | +4,424 |
| `columns` | 57,164 | 57,308 | +144 | 56,192 | 56,392 | +200 |
| `columns3` | 6,824 | 6,924 | +100 | 6,768 | 6,948 | +180 |
| `aggregate` | 66,436 | 64,012 | −2,424 | 61,588 | 61,704 | +116 |

`admit` and `lower` on all ten cohorts, and `stratify` on the five default cohorts: the two arms'
medians within 84 KiB, inside the round-to-round range (about 5.9 to 6.6 MB).

- **The `stratified` cohort's +4.4 MB is real retention.** Massif under the fixed threshold
  (`massif-peak-stratified-*.txt`): peak heap 48,863,240 bytes against 53,048,608. The
  difference, 4,184,092 bytes, is exactly one allocation of the ranked checker
  (`Demand::verify_ranked` → `ranked::check_admitted_bounded`), live at the candidate's peak
  and not at the control's. The control compared `demand.verify_ranked(&ranked)? != checked`
  as a temporary, freed at the end of the statement; the candidate binds `let searched =
  demand.verify_ranked(&ranked)?` for the disagreement report, so the ranked checker's
  relations live to the end of the layer, across the checker/evaluator comparison whose
  `dedup_rows` copies make the peak. Fixed in `6575bba` (next subsection).
- **The other differences follow the heap layout:** under the fixed threshold `datalog`'s
  +1.65 MB is +0.19 MB and `aggregate`'s −2.4 MB is +0.12 MB. The remaining +0.1 to +0.2 MB is
  of the order of the candidate binary's larger text.

#### The ranked relations released (`6575bba`), re-measured (receipts `267acdd`)

`6575bba` adds `drop(searched)` directly after the derivation/ranked comparison in
`evaluate_with`, before the checker/evaluator comparison where a layer's memory peaks; nothing
else reads `searched`. New candidate arm: `ergodis-tools-c1205b-drop-71c25e7`, private
`71c25e7` (both fixes), core `064cde2`, clean, release, default features, rustc 1.95.0
(59807616e 2026-04-14), retained with `retain-bin.sh tasks/tools ergodis-tools --label
ergodis-tools-c1205b-drop` and `ERGODIS_FLAKE_DIR` at the core worktree; measured sha256
`775a8800f108361d1f514cb8a4f111aba9def11514444ea853a85e7aebcf7913`. Control unchanged
(`ergodis-tools-c1205b-base-482d6e9`).

Peak RSS (`peak_rss.py`, VmHWM, `--repeat 2`, 512 definitions, byte scanner; median KiB with
range; five rounds, and three with the fixed mmap threshold):

| Cohort | `stratify` control | `stratify` candidate `71c25e7` | Δ | fixed threshold: control | candidate | Δ | Δ at `db37035` |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `datalog` | 24,964 [24,924–25,020] | 25,088 [25,008–25,212] | +124 | 24,636 | 24,760 | +124 | +1,652 |
| `stratified` | 51,700 [51,640–51,772] | 51,960 [51,796–52,060] | +260 | 50,420 | 50,820 | +400 | +6,400 |
| `columns` | 57,044 [57,004–57,184] | 57,256 [57,176–57,284] | +212 | 56,220 | 56,296 | +76 | +144 |
| `columns3` | 6,720 [6,704–6,836] | 6,864 [6,836–7,016] | +144 | 6,720 | 6,888 | +168 | +100 |
| `aggregate` | 66,380 [66,368–66,532] | 66,644 [66,584–66,732] | +264 | 61,300 | 61,540 | +240 | −2,424 |

The `stratified` peak is back to within 0.26 MB of the control (0.5 per cent), the same +0.1 to
+0.4 MB every cohort shows, including `columns3`, which has no large checker allocation; that
residual is the larger binary and heap-layout noise, not retention. The 4.18 MB allocation is
gone from the peak.

Stage A/B (`bench.py --rounds 5 --cpu 5 --stages parse,admit,lower,stratify`, the six-event
set, 100 per cent enabled, receipt `analysis/rel-frontend/performance-v11-chain-drop-71c25e7.json`;
load 2.1–13.8, from another tenant, which widens cycles only). Per-iteration instruction
differences, candidate minus control; every A/A null within 7e-6 of unity:

| Cohort | `stratify` ratio byte / scalar [byte interval] | `stratify` Δ | own Δ (`stratify` − `lower`) | own Δ at `db37035` | own Δ at `db37035`, fixed threshold | lower own Δ |
| --- | --- | --- | --- | --- | --- | --- |
| `datalog` | 0.99981 / 0.99981 [0.999806, 0.999807] | −325,343 | −308,410 | −402,650 | −304,573 | −16,913 |
| `stratified` | 0.99969 / 0.99969 [0.999693, 0.999694] | −480,335 | −451,407 | −399,398 | −437,341 | −28,910 |
| `columns` | 0.99969 / 0.99969 [0.999693, 0.999695] | −479,282 | −444,160 | −384,972 | −452,295 | −35,104 |
| `columns3` | 0.99734 / 0.99755 [0.997342, 0.997344] | −21,552 | +13,496 | +16,598 | +19,590 | −35,029 |
| `aggregate` | 0.99965 / 0.99965 [0.999651, 0.999656] | −245,651 | −219,794 | −178,964 | −199,664 | −25,839 |

`lower` and admission are unchanged from `db37035` to within 40 instructions: the lowering code
generation is the same. `stratify`'s own difference moved by −94 to +94 thousand per iteration
between the two candidates, the size of the heap-layout term; the new candidate's figures sit
within 4 to 20 thousand of `db37035`'s fixed-threshold figures, so releasing one allocation
early reset the heap layout close to the fixed-threshold one rather than changing any
instruction path in the loop (the `drop` is one `free` per layer). `columns3` is 3 thousand
lower, within that term.

#### Cost of retaining the evidence (receipts `222b4f8`)

`chain_cost.py`, candidate binary, `rel-lower --cohort <c>` with and without `--chain`, one
process each, pinned to core 5, three alternating rounds, medians; one `rel-verify` of each
chain beside it. `columns3` is measured at 64 definitions: above 64 its run is refused by the
backend's complement budget (at 512: 134,217,728 complement facts against 4,194,304).

| Cohort | Defs | Layers | Wall plain → chain | Instructions plain → chain | Chain bytes | derivation / ranked / encodings / JSON and source | Peak RSS plain → chain (KiB) | `rel-verify`: wall, instructions, peak RSS |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `stratified` | 512 | 3 | 0.131 → 0.178 s (+36%) | 1.742 → 2.245 G (+29%) | 10,875,186 | 6,212,280 / 2,505,232 / 2,105,703 / 51,971 | 58,140 → 65,272 | 0.200 s, 2.640 G, 48,372 |
| `columns` | 512 | 3 | 0.133 → 0.178 s (+34%) | 1.747 → 2.254 G (+29%) | 11,108,251 | 6,350,996 / 2,573,628 / 2,109,825 / 73,802 | 57,684 → 69,124 | 0.194 s, 2.651 G, 52,556 |
| `columns3` | 64 | 2 | 0.169 → 0.211 s (+25%) | 1.733 → 2.387 G (+38%) | 14,029,349 | 7,646,447 / 3,219,500 / 3,147,804 / 15,598 | 135,264 → 135,236 | 0.241 s, 2.925 G, 114,056 |
| `aggregate` | 512 | 2 | 0.102 → 0.123 s (+21%) | 0.749 → 1.005 G (+34%) | 5,491,529 | 3,080,039 / 1,267,081 / 1,071,443 / 72,966 | 64,524 → 64,652 | 0.141 s, 1.245 G, 70,252 |

Beside the timed stage it is kept out of: the `stratify` stage retires 1.565 G (`stratified`),
1.567 G (`columns`) and 0.709 G (`aggregate`) per iteration, so retaining the chain costs about
a third of the stage again (0.50, 0.51 and 0.26 G), and 5 to 14 MB of files, of which the
derivation certificates are 54 to 57 per cent. The Fermi said "up to about twice a plain one";
measured +21 to +38 per cent. Checking a chain in another process costs 1.4 to 1.7 times the
plain producer run. The retaining run's peak RSS rises 7 to 11 MB on the three-layer cohorts
(one layer's encoding and certificates held while written) and not measurably on the others.
At `db37035` a refused run (`columns3` at 128 and at 512 definitions) exited 0 from `rel-lower
--chain` and left the layers written before the refusal in the directory, with no `chain.json`;
`rel-verify` refused that directory (`Missing`, `chain.json`). Fixed in `71c25e7`:

- **Choice: stage beside the target and rename into place on success.** `rel-lower` checks that
  the target is absent or an empty directory, writes the chain into a fresh sibling
  `<name>.partial-<pid>` in the same parent, and `rename`s it onto the target after the manifest
  is written (an empty target directory is replaced, which `rename` permits). An unpublished
  staging directory is removed when the run ends, on every refusal and error path. Chosen over
  deleting what was written because the target then never holds a partial chain at any
  instant, including when the process is killed or runs out of memory mid-run, when no
  cleanup runs: the most such a death leaves is a `.partial-<pid>` sibling, never a partial
  chain under the requested name. The rename is atomic within one filesystem, which the
  same-parent sibling guarantees.
- **Exit status.** Each of the six refusal paths (parse, admission, lowering, the backend's
  lowering budget, the evaluator's row capacity, any other stratified error) still prints its
  JSON report on stdout; with `--chain` it then returns an error, so the process exits 1 with
  "<stage> refused the source; no chain written to <dir>" on stderr. Without `--chain` the
  behavior is unchanged (exit 0 with the report), since that mode is a report tool.
- **Test** `tasks/tools/tests/rel_chain.rs::a_refused_run_exits_with_an_error_and_leaves_no_chain`:
  `columns3` at 128 definitions (layer 0 is evaluated and written, layer 1 refused) exits
  non-zero with `stage: backend`, `ok: false`, no chain at the target and nothing else in the
  parent; with an empty directory at the target the refusal leaves it empty; the same target
  then takes a complete chain at 8 definitions, with no staging directory left.

Replay (private worktree at `222b4f8`, arms retained as in the arms table; valgrind 3.26.0):

```sh
cd analysis/rel-frontend/chain-stage-shift
C=~/.cache/ergodis/bin/ergodis-tools-c1205b-base-482d6e9; D=~/.cache/ergodis/bin/ergodis-tools-c1205b-db37035
for c in datalog stratified columns columns3 aggregate; do
  python3 callgrind_attribution.py --control $C --candidate $D --cohorts $c --stage stratify \
      --lo 2 --hi 4 --work ~/.cache/ergodis/c1205b/cga --out callgrind-stratify-$c.json --run
  python3 callgrind_attribution.py --control $C --candidate $D --cohorts $c --stage lower \
      --lo 32 --hi 64 --work ~/.cache/ergodis/c1205b/cga --out callgrind-lower-$c.json --run
  python3 mmap_threshold.py $c 3
done
python3 peak_rss.py 5 peak-rss.json
GLIBC_TUNABLES=glibc.malloc.mmap_threshold=131072 python3 peak_rss.py 3 peak-rss-mmap-threshold.json stratify
python3 chain_cost.py 512 3
# Instruction mix: valgrind --tool=callgrind --dump-instr=yes --compress-pos=no --compress-strings=no
#   on `--stage lower --repeat 64` and `--stage stratify --repeat 2` (cohort stratified), then
#   instr_mix.py <binary> <out> ergodis_private::rel_frontend::lower:: (or ...::dedup_rows).
# Massif: GLIBC_TUNABLES as above, valgrind --tool=massif, `--stage stratify --repeat 1`, ms_print.
```

#### Remaining steps

In order; each is a commit on the private `c1205b` branch with the gates above, and the report
updated after it. The design sections above are the specification.

1. Done (`48ccaaa`).
2. Done (`3940964`), with 3.
3. Done (`3940964`).
4. Done (`c7d6ffa`). Gates: `cargo fmt --all --check`, clippy `--all-targets --all-features -D
   warnings` for the root and `ergodis-tools`, suites `rel_chain` (new), `rel_layer_identities`
   (pins unedited, pass), `rel_externals`, `rel_check`, `rel_lowering` (53), `rel_reference_eval`
   (19), `rel_frontend_portability`, the library's `rel_` unit tests and `ergodis-tools` (44): all
   green. The shared target held core rlibs last built through the `c1205b-mut` worktree's
   symbolic link (two `ergodis_contract` versions in one graph); `cargo clean -p` of the four core
   crates in the private target (5.1 GiB of their artifacts) and a rebuild fixed it. The
   manifest's `seeded[].external` is the deduplicated count beyond `P`'s facts, as noted below.
   Original notes: the record types in `rel_chain` have no
   serde yet (the manifest needs it, with digests as 64-character lowercase hex); `Declared`,
   `Origin`, `LiteralMap` and every `Program` part already derive it with
   `deny_unknown_fields`. The manifest's `seeded[].external` should be the count of tuples
   beyond `P`'s facts after deduplication, which is not `Seeded::external_tuples` (counted
   before duplicates are removed). `Evidence` trait with `const RETAIN: bool`, `NoEvidence`,
   `ChainWriter`; `evaluate` = `evaluate_with(.., &mut NoEvidence)`. In the retaining
   instantiation, per layer: `demand.transferable_source()` (expect `Prepared`), both
   certificates to the sink, `derivation_digest`/`ranked_digest` into the layer record. The
   manifest (`rel_chain::Manifest`, hex digests) and `program.json` written after `check`;
   `producer.json` beside them. `rel-lower --chain <dir>`, plus `--externals <json>` so the
   fixture's `ext` can be supplied from the command line.
5. Done (`6c0d24a`), design steps 1–7 as written, with these specifics and departures:
   - Files are read through one interface over a directory or a `ChainParts` map, one layer at
     a time; a file's bound is checked from the listing and again while it is read, so a file
     that grew after listing is still refused. `source.rel` and `lowering.json` come as a pair,
     are allowed without `--source-check` and required with it; `producer.json` is allowed and
     never read; anything else, and any entry that is not a file, is `Unexpected`.
   - `validate(&Program)` runs before anything indexes the statement: arity within the core's,
     one column type per column, canonical and distinct values, one type range per kind within
     the dictionary and agreeing with every value's kind, facts ascending and inside arity and
     dictionary, literal sign/relation/aggregate-column consistency, one term per column,
     constants in the dictionary, heads positive, bodies in range, join orders permutations,
     bindings in range, variables below each rule's count.
   - The per-layer rule check (design 6.3) runs before the input check, and a wrong relation at
     a replaced literal is reported at `layers[k].literals[i]`, anything else at
     `layer-k.prepared` `rules[j]`. A derived relation's facts in its deriving layer must equal
     `P`'s facts for it (the producer gives none; the corpus round trip shows `P` has none there).
   - Constructions: the decoded tuples of every construction are kept until the end, and
     `check_constructions_observed` compares each rebuilt construction with them tuple for tuple
     after its record checks, so a forged layer names the construction and the first differing
     tuple. Each layer's `domain` is checked against the manifest while decoding and against the
     dictionary the aggregates built once the construction check has passed.
   - The dependency-closure test follows `crate::` references transitively from `rel_verify`
     (comments stripped) and fails on `ergodis_rules`, `rel_stratified` or `Demand` in any
     reached source; it reaches `rel_chain`, `rel_rebuild`, `rel_frontend` and `rel_lowering`.
     The crate as a whole still depends on `ergodis-rules`; the closure is enforced at module
     level.
   - Named mutations covered in `tests/rel_chain.rs`: every layer's `source_id`; both
     certificate digests; a literal map entry pointed at another declaration; every seeded
     digest; `complements[0].source`, `filters[0].operator`, `filters[0].literal`,
     `complements[0].universe`, `complements[0].column_domains[0].type_start`,
     `aggregates[0].digest`; three derivation-certificate entries (rule index, premise, tuple
     value) with the manifest digest kept (refused at `layers[k].derivation`) and recomputed
     (refused by `check_recorded` with family `Derivation`); a missing, an extra and an
     oversized file. Each asserts the exact file and path.
   - Two processes, by hand (not yet a committed test): `rel-lower --source-file
     tests/rel_chain/demo.rel --chain <dir> --externals <json>` printed chain identity
     `513f1938…ce60098`; `rel-verify <dir> --source-check --records <file>` in a second process
     printed `accepted: true` with the same identity and wrote three layers' records;
     `--max-layer-bytes 10` refused `layer-0.prepared` as `TooLarge` with exit status 1.
   Gates at `6c0d24a`: fmt clean; clippy `-D warnings` clean for the root and `ergodis-tools`;
   `rel_chain` (6), `rel_layer_identities` (pins unedited), `rel_externals`, `rel_check`,
   `rel_lowering` (53), `rel_reference_eval` (19), `rel_frontend_portability`, the `rel_` unit
   tests and `ergodis-tools` (44): all green. The corpus round trip accepted 470 chains, 252
   of them with more than one layer.
6. Done (`0d270c7`, `745b5b6`, `db37035`); see "Step 6" above.
7. Done (receipts `4138f8b`, `222b4f8`; see "Step 7", "Stage shifts, explained", "Peak RSS"
   and "Cost of retaining the evidence" above). The stage shifts are attributed; peak RSS is
   measured per cohort and stage; the chain cost is measured on the four construction cohorts;
   both ABI harnesses pass at `064cde2`; the full private suite passes at `4138f8b` with nothing
   to fix. The two findings of step 7 are fixed: `6575bba` releases the ranked checker's
   relations before the checker/evaluator comparison, and `71c25e7` publishes a chain only when
   complete and fails a refused `--chain` run; re-measured against the same controls in
   receipts `267acdd` (see "The ranked relations released"). The chain-cost table above was
   measured on `db37035`; the staging rename adds one directory rename per run and was not
   re-timed.
8. **Close.** Full core and private gates at the final commits; fast-forward check of both
   branches onto their mains; the independent audit; `cache-gc.sh` dry run. The audit is
   done (not ready to close) and its findings are repaired or recorded open in "Repairs
   after audit" (private `8abe414`, `43527c6`, receipts `8d11ce4`; full private gate green at
   `43527c6`). Left: Tavis's call on a re-audit of the High repair and on landing (the
   branches are no longer fast-forwards of their mains), the open Low items (L7 decoding
   bounds, L8 crate split, I3 table rows), and the `cache-gc.sh` dry run. Scratch left for
   Tavis: `~/.cache/ergodis/worktrees/c1205b-repair-mut` (unregistered export, mutation
   runs) and its `mutrep` artifacts under `~/.cache/ergodis/target/ergodis-private/mutrep/`.

#### Divergence

Both `c1205b` branches still descend from their start points (core `4b57649`, private
`482d6e9`; checked with `git merge-base --is-ancestor`), core `c1205b` at `064cde2` and private
`c1205b` at `267acdd` (since the audit repairs, `8d11ce4`, three forward commits). The mains have moved since, by other work: core `main` is `831d56c`
(two commits: `b1cd0bc` WASM lock refresh, `831d56c` huge-page advice gated to Linux and
Android) and private `main` is `5e87740` (two commits on timing units, `85f2586`, `5e87740`).
So neither branch is a fast-forward of its current main any more; landing needs a rebase or
merge onto them and the gates again, which is Tavis's call. Not rebased. The scratch worktree `~/.cache/ergodis/worktrees/c1205b-mut` (a detached
private worktree at `3940964`, clean, and a symbolic link) remains registered in the private
repository; removing it is Tavis's call.

#### Repairs after audit

The independent audit (`notes/2026-09-22-c1205-milestone-b-audit.md`, verdict "not ready to
close": one High, two Medium, eight Low, three Info) is repaired in two private commits on
`c1205b`, `8abe414` and `43527c6`, on top of `267acdd`, with the re-measured receipts in
`8d11ce4`. Core is unchanged (`064cde2`). Still to do for the close: a re-read of the High
repair by a fresh auditor if Tavis wants one, the fast-forward question (see "Divergence"),
and the `cache-gc.sh` dry run.

| Finding | Disposition | Commit |
| --- | --- | --- |
| H1, binding sites trusted | Fixed. The verifier recomputes every binding site from its rule's source body and checks each binarized chain against that body (design below). The audit's forgery is a committed refusal test, with a test of the same class on a binarized chain | `8abe414` |
| M1, nine surviving verifier mutations | Seven killed by new consistent forgeries; two recorded as equivalent mutants (table below) | `8abe414` |
| M2, free order of the construction lists | Fixed: `complements`, `filters` and `aggregates` must be in declaration order (layer, then declaration) and any other order is refused at `<list>[i].layer` or `.declared`; test `construction_records_in_another_order_are_refused`; the ledger's "one free order" sentence corrected | `8abe414` |
| L1, `Stratified` vouches for records, not closure | Fixed as documentation: the type's doc now says it vouches for records consistent with the closure it carries, which `check` does not re-establish. The fields stay public because the tamper tests write them | `43527c6` |
| L2, bench records a run whose record check failed | Fixed: `rel-frontend-bench` returns an error, so the process exits non-zero and no receipt line is written; a backend refusal is still an ordinary outcome | `43527c6` |
| L3, `--externals` merges a repeated spelling | Fixed: the file is decoded entry by entry in file order, so the library refuses the repeat by name; test `tasks/tools/tests/rel_chain.rs::an_externals_file_repeating_a_spelling_is_refused` | `43527c6` |
| L4, publish atomic, not durable | Fixed: every file and the staging directory are `sync_all`ed before the rename and the parent after it. A power loss cannot be tested here; the refused-run test still passes | `43527c6` |
| L5, unread `source.rel` rides along | Fixed: `rel-verify` prints `"source_unchecked": true` when a source is present and `--source-check` is off; the two-process test asserts it both ways | `43527c6` |
| L6, undefined operators and duplicate names | Fixed in `validate`: an operator outside the `CMP_*`/`AGG_*` set of its sign, a non-zero operator on a positive or negative literal, and a repeated relation name or spelling are refused; test `a_statement_with_an_undefined_operator_or_a_repeated_name_is_refused` | `8abe414` |
| L7, verifier cost not bounded by its input bounds | Partly fixed: `rel_rebuild::aggregate` interns through a map built once. Open: `site_signature` still builds a whole-dictionary domain per column before the universe bound is tested, and serde decoding of a large `program.json` allocates several times the file. Both are bounded by the caller's size bounds; a real bound needs list-length limits before decoding, which is a decoder change for a later step | `8abe414` |
| L8, dependency-closure test textual | Partly fixed: the test now follows grouped `use crate::{..}` imports, refuses a `crate::` name that is no module (a re-export alias would be one), and scans the crate root's `use` lines for the forbidden names. Open: compiler-enforced separation needs `rel_chain`, `rel_rebuild` and `rel_verify` in a crate without an `ergodis-rules` dependency, an architecture change for Tavis | `8abe414` |
| I1, comments | Fixed: `rel_stratified.rs`'s milestone and ADR references and the change-history comment in `tests/rel_externals.rs` rewritten to describe the code | `43527c6` |
| I2, performance record | Fixed in this report: the 8k–20k figure is stated as an upper bound, not an attribution (Step 7, item 5 of "Stage shifts" and the mystery ledger); the replay commands for the construction-cohort `bench.py` run and the derivation-loop `ab.py` run added below; the between-session reproducibility limit and the `PERFORMANCE.md` invariant 1 exception recorded below | report |
| I3, loose mutation-table rows | Open: three `LEAF_TABLE`/`LIST_TABLE` rows accept a refusal anywhere in a wider path. Every mutation is still refused; tightening them changes only how precisely the error is named | — |
| Number slips | Fixed in this report: "every interval narrower than 1e-5" now says it of `lower` and `stratify` and gives the `scan`/`parse` widths; the `lower` delta is labelled as the stage figure, not `lower` − `admit`; `rel_externals` at `71c25e7` had 2 tests, not 1 | report |

**The High repair.** `ProgramRule` gains `source: Option<[u32; 2]>`, serialized only when
present, so a statement without a binarized rule is byte-identical and keeps its identity
(the `demo.rel` chain with the fixture's externals is still `c29a38ee…` from both the
`71c25e7` and the repaired binary). Binarization rewrites a rule's body in place, leaves its
head and every literal of its old body in the pool, and appends the chain's links with the
rule's variable base; every rule is built with its body directly after its head. So
`Program::of`, still a pure function of the lowered IR (D2 as approved), names the old body
`[head + 1, head + 1 + atoms)` for the parent and each link. The verifier then:

1. groups the rules naming one source body and requires a tree: two or more rules, one
   root, each other rule deriving an auxiliary relation that no other rule derives and
   exactly one positive literal of the tree reads with the head's own terms (distinct
   variables), no facts for it, every member reached from the root once;
2. requires the tree's non-link body literals to be the source body's literals one for one,
   and the source body to be read by no rule;
3. requires each link's head to hold only variables of its body and every variable its
   subtree's atoms share with the atoms outside it or with the root's head (so projecting
   the subtree commutes with the rest of the join, and the root derives exactly what the
   source body derives);
4. requires every rule's `bindings` to equal the sites the source body gives (a rule's own
   body when it names none): positive literals naming a relation, body order, then column.

No site is taken on trust, and no architecture change beyond D2 was needed. An auxiliary
relation holds its chain's intermediate join, which can exceed the source rule's projection
where a replaced literal is joined before an atom that binds its variable; the verifier's
module header now says so. The corpus round trip still accepts 470 chains, 252 multi-layer
and 25 with a binarized chain. The in-process `check` still reads the sites the frontend's
bind pass wrote; the offline verifier is where they are checked, and `rel_rebuild`'s header
now says that.

Tests (`tests/rel_chain.rs`): `a_binding_site_the_rule_does_not_hold_is_refused` is the
audit's forgery (the `stop` rule's site moved from `edge` column 1 to column 0, the complement
record and layer rebuilt over the new domain, the layer re-certified, the result, statement
identity and every digest recomputed; the forged model of `stop` is empty against the honest
`{4}`), refused at `program.json` `rules[r].bindings[v]`. `a_binarized_chain_is_checked_against_its_source_body`,
on a five-atom body with a negation: a link's site moved to `edge`, refused at its bindings;
the source body edited (`node(w)` made `edge(w, w)`) with every member's sites recomputed from
it, refused at `rules[m].source` ("an atom the source body does not hold"); the chain pointed
at another rule's body, refused ("a source body some rule reads").

**Mutation table.** A `git archive` export of `43527c6` at
`~/.cache/ergodis/worktrees/c1205b-repair-mut/ergodis-private` (sibling `ergodis` a symbolic
link to the core worktree), built under a separate profile (`CARGO_PROFILE_MUTREP_INHERITS=dev
cargo test --profile mutrep`, artifacts under `target/ergodis-private/mutrep/`, so the shared
`dev` artifacts are untouched). Each mutation applied alone and reverted before the next, run
against `--test rel_chain --test rel_check`; the source matched `43527c6` afterwards (`diff -r`).
Mutations are the audit's, by its numbering.

| Mutant | Check removed | Killing test | Result |
| --- | --- | --- | --- |
| audit M1 | a complement's relation must be established before its layer | `forgeries_aimed_at_each_statement_check_are_refused` (the two layers of `stop` merged into one) | killed: the merged chain is accepted |
| audit M2 | the same for an aggregate's relation | same test (the two layers of a `count` over a derived relation merged) | killed: accepted |
| audit M3 | a derived relation may be an input only after its deriving layer | same test (`stop` declared as an input of layer 0) | killed: accepted |
| audit M4 | derivation and ranked checkers must establish the same relations | none | survives; equivalent: both core checkers prove the layer's least model (a soundness pass and a closed-world pass, `ergodis-verify` `derivation.rs`), so two accepted certificates of one layer cannot disagree; the check guards against a defect in one checker only |
| audit M5 | a layer rule's variable count equals the statement's | none | survives; equivalent: `decode_prepared` ends in `admit_prepared`, which refuses a rule whose variable count is not its canonical numbering's, and the expected count is that numbering of the same atoms |
| audit M6 | a derived relation's facts in its own layer equal the statement's | same test (a fact injected into `sink`) | killed: accepted |
| audit M9 | a seeded relation holds every statement fact | same test (`mark`'s fact 5 replaced by 1, count unchanged) | killed: accepted |
| audit M12 | a layer rule's head equals the statement's | same test (`sink`'s rule made to derive `stop`) | killed: accepted |
| audit M13 | a layer holds exactly the statement's rules | same test (`sink(y) = edge(y, _)` appended) | killed: accepted |
| H1 sites | every rule's sites equal its source body's | `a_binding_site_the_rule_does_not_hold_is_refused`, `a_binarized_chain_is_checked_against_its_source_body` | killed: the audit's forgery is accepted |
| H1 chain | the chain is a binarization of its source body | `a_binarized_chain_is_checked_against_its_source_body` | killed: the refusal moves to `complements[0].column_domains[0].source` (that forgery rebuilds no record) |
| M2 order | construction lists in declaration order | `construction_records_in_another_order_are_refused` | killed: the permuted chain is accepted |

Every forgery in `forgeries_aimed_at_each_statement_check_are_refused` recomputes the layer
(re-admitted, evaluated and certified by `Demand`), the manifest's identity and certificate
digests, and the result entries from the forged layer's model, so under each mutant the chain
is accepted, not refused elsewhere. A generalized forging helper (`Layer`: decode a layer,
edit its relations, rules or facts, re-certify, install) and `merged` (two layers into one,
records moved and their digests recomputed) carry them.

**Preservation.** `tests/rel_layer_identities.rs` (both pins), `tests/rel_frontend_portability.rs`,
`tests/rel_lowering.rs` (53, parity and fingerprint assertions) and `tests/rel_reference_eval.rs`
(19, the differential) are unedited by these commits and pass. Core `demand_prepared.rs` is
untouched (no core change).

**Timed path.** No source on the timed `stratify` or `lower` path changed; `rel_stratified.rs`
changed only in comments and a doc comment. Code generation still moved, as with every change
to this crate: in the retained candidate `ergodis-tools-c1205b-repair-43527c6` (private
`43527c6`, core `064cde2`, clean, release, default features, rustc 1.95.0,
`retain-bin.sh tasks/tools ergodis-tools --label ergodis-tools-c1205b-repair` with the core
worktree as sibling; measured sha256
`88a7402757a64c61b7035c32378420ecb3dde120fbd80ac8d792dfd78eff9c42`) the `NoEvidence`
`evaluate_with` is 0x7886 bytes against 0x7538 in `71c25e7`, and `lower::lower` is a 0x500 shell
again (0x362f in `71c25e7`), by normalized `symbol_disasm.py`; `complement_over`, `filter_over`
and `layers_of` are identical. So the stage A/B and peak RSS were re-run against the same
control, `ergodis-tools-c1205b-base-482d6e9`.

Stage A/B (receipt `analysis/rel-frontend/performance-v11-chain-repair-43527c6.json`, private
`8d11ce4`; `bench.py --rounds 5 --cpu 5 --stages parse,admit,lower,stratify`, the six-event
set, 100 per cent enabled, load 1.5–4.2; every A/A null within 1.5e-5 of unity). Two earlier
runs of the same command without `--events` used the default eight-event set, which
multiplexed at 69–83 per cent enabled under a concurrent session's builds (A/A nulls up to
5.5e-3); they were discarded and overwritten. Per-iteration instruction differences,
candidate minus control:

| Cohort | `stratify` ratio [interval] | `stratify` Δ | own Δ (`stratify` − `lower`) | own Δ at `71c25e7` | `lower` Δ | `lower` Δ at `71c25e7` |
| --- | --- | --- | --- | --- | --- | --- |
| `datalog` | 0.99981 [0.999808, 0.999810] | −321,457 | −321,448 | −308,410 | −10 | −16,932 |
| `stratified` | 0.99938 [0.999375, 0.999376] | −977,687 | −977,666 | −451,407 | −21 | −28,928 |
| `columns` | 0.99937 [0.999374, 0.999375] | −980,436 | −980,412 | −444,160 | −25 | −35,122 |
| `columns3` | 1.00133 [1.001333, 1.001335] | +10,821 | +10,843 | +13,496 | −22 | −35,048 |
| `aggregate` | 0.99930 [0.999301, 0.999304] | −494,925 | −494,884 | −219,794 | −41 | −25,857 |

`lower` is back to the control's instruction count within 41 per iteration, consistent with
`lower::lower` returning to the control's shell shape: the 17–35 thousand the milestone's
candidates showed was code generation, as "Stage shifts, explained" said, and it is gone
without any lowering source change. `stratify`'s own difference fell a further 13 to 529
thousand per iteration on the four long cohorts; no timed source changed, so this is again
code generation or the heap-layout term, not attributed here (no callgrind or fixed-threshold
run was taken for this candidate). On `columns3`, where little else runs, the own difference
is +10.8 thousand against +13.5 thousand at `71c25e7`, inside the milestone's upper bound of
about 20 thousand.

Peak RSS (`peak_rss.py`, VmHWM, `--repeat 2`, 512 definitions, byte scanner; median KiB, five
rounds, and three with the fixed mmap threshold; receipts `chain-stage-shift/peak-rss-repair-43527c6.json`
and `-mmap-threshold.json`):

| Cohort | `stratify` control | candidate `43527c6` | Δ | fixed threshold: control | candidate | Δ | Δ at `71c25e7` |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `datalog` | 24,964 | 25,204 | +240 | 24,660 | 24,944 | +284 | +124 |
| `stratified` | 51,688 | 51,880 | +192 | 50,516 | 50,780 | +264 | +260 |
| `columns` | 57,016 | 57,312 | +296 | 56,164 | 56,372 | +208 | +212 |
| `columns3` | 6,756 | 6,952 | +196 | 6,816 | 6,896 | +80 | +144 |
| `aggregate` | 66,336 | 66,688 | +352 | 61,396 | 61,684 | +288 | +264 |

The same +0.1 to +0.4 MB residual as at `71c25e7`; nothing retained.

**Gates at `43527c6`** (against core `064cde2`, under `nix develop ../ergodis`, `choom -n
1000`, `-j 12`): `cargo fmt --all --check` clean; clippy `--all-targets --all-features -D
warnings` clean for the root and `-p ergodis-tools`; `cargo test --all-features
--no-fail-fast`: 43 test binaries, 1,199 passed, 0 failed, 17 ignored; the doctest target
failed to compile with the known stale-rlib collision (a concurrent session's build of
`ergodis-rules` from `~/src/ergodis`, which lacks `TransferableSource`), and after `cargo clean
-p ergodis-rules --profile dev` passed alone (2). `-p ergodis-tools`: 41 + 3 + 3 passed, the
new externals test included. The pins, parity, fingerprint and differential suites are among
those. Core gate not rerun: core is unchanged.

**Replay** (private worktree at `43527c6`; arms retained as above;
`E=instructions,cycles,branches,branch-misses,page-faults,minor-faults`, `A=analysis/datalog-comparison`,
`B=analysis/rel-frontend`, `C=~/.cache/ergodis/bin`, `ALL` the eighteen cohorts of milestone
a's replay block):

```sh
# The milestone b receipts that had no replay command (I2):
nix develop ../ergodis --command python3 $A/ab.py --a $C/closure_ballpark-c1205b-base-482d6e9 \
    --a-name control-482d6e9 --b $C/closure_ballpark-c1205b-db37035 --b-name chain-db37035 \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work ~/.cache/ergodis/c1205b/ab-evaluate --out $A/ab-2026-09-22-chain-derivation-loop.json
nix develop ../ergodis --command python3 $B/bench.py --binary $C/ergodis-tools-c1205b-db37035 \
    --control $C/ergodis-tools-c1205b-base-482d6e9 --rounds 5 --cpu 5 \
    --cohorts datalog,stratified,columns,columns3,aggregate \
    --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v11-chain-constructions-db37035.json
# The repaired candidate:
python3 $B/bench.py --binary $C/ergodis-tools-c1205b-repair-43527c6 \
    --control $C/ergodis-tools-c1205b-base-482d6e9 --rounds 5 --cpu 5 \
    --stages parse,admit,lower,stratify --cohorts datalog,stratified,columns,columns3,aggregate \
    --events $E --out $B/performance-v11-chain-repair-43527c6.json
cd $B/chain-stage-shift
R=$C/ergodis-tools-c1205b-repair-43527c6; K=datalog,stratified,columns,columns3,aggregate
python3 peak_rss.py 5 peak-rss-repair-43527c6.json stratify $R $K
GLIBC_TUNABLES=glibc.malloc.mmap_threshold=131072 \
    python3 peak_rss.py 3 peak-rss-repair-43527c6-mmap-threshold.json stratify $R $K
# Mutations: CARGO_PROFILE_MUTREP_INHERITS=dev cargo test --profile mutrep --all-features \
#   --no-fail-fast --test rel_chain --test rel_check, in a git archive export of 43527c6.
```

The receipts' method block records the rounds, cohorts and event set; `ab.py`'s repeats are
recorded as `[3, 6]` (the two differencing points). Intervals in every receipt are within one
session: the audit's rerun of the `71c25e7` stage A/B on the same binaries moved `columns3`'s
`stratify` delta by 1.6 thousand, about a hundred times the receipt's interval half-width,
through the heap-layout term. A between-session comparison of these figures should allow for
that.

Deviation recorded (I2): `PERFORMANCE.md` invariant 1 names "check" loops among the
allocation-free ones. `rel_rebuild` allocates per tuple by the approved design (D1 (a), a
set-based rebuild written for independence and clarity) and runs only in `check` and the
offline verifier, never on a timed path; it is an exception to that invariant, not an
oversight.

#### Mystery ledger (milestone b)

- **The fixture's dictionary-fallback literal records no `Dictionary` domain (settled).** The
  `lone` literal's variable is bound only by `some`, which its own layer derives, so its domain
  falls back to the whole dictionary; that dictionary holds exactly the four integers `node`
  holds, so the domain's values equal the bound domain of `unreached` and `gap`, and the builder
  shares their complement. Sharing depends on values only, which is exact: a complement is a
  function of its relation and its domains' values, and provenance only explains them. A
  `Dictionary` source in a record therefore appears only when the fallback domain differs from
  every other use site's; the mutation suite of step 6 should add a fixture line that makes one
  (for example a text constant in the dictionary).
  Correction (step 6): the claim above and in "Steps 2 and 3" that no record of `demo.rel`
  carries a `Dictionary` source is wrong. The filter of `far(x, y) = unreached(x, y) and x > y`
  does (both operands are bound only by `unreached`, which its own layer derives); it is only
  the complement that has none. The second fixture `fallback.rel` now gives a complement a
  `Dictionary` provenance (five values against the bound domain's four), and both mutation
  suites run over it.
- **Binding sites are not recoverable from a binarized rule's body (settled, then repaired).**
  See "Steps 2 and 3". Carrying the sites in `P` left them trusted (audit H1). Since private
  `8abe414` `P` also names each binarized chain's source body, which binarization leaves in
  the literal pool, and the verifier checks the chain against that body and recomputes every
  site from it; see "Repairs after audit".
- **Three premise changes accepted by the derivation checker (settled, correct).** With the
  certificate digest recomputed, moving the premise reference of three `some(x) = unreached(x,
  _)` derivations to the next derivation is accepted, because that derivation is another
  `unreached` tuple with the same `x`; a rule with a body variable the head does not bind has
  several valid supports per tuple. The unused second premise slot of that one-atom rule, made
  non-zero, is refused, so the checker is not ignoring slots. Certificates are therefore not
  unique for a model, and a chain's identity names one certificate among several valid ones.
- **Whitespace after a JSON file's value is accepted (settled, by design).** The manifest,
  statement and certificate files are named by the digest of what they decode to, as the design
  states for `P` ("two spellings of one statement have one identity"), so the verifier accepts
  a file with trailing whitespace and reports the same chain identity. The chain's byte image is
  therefore not unique; its identity is. A verifier that must also fix the bytes would compare
  each JSON file with the serialization of what it decoded (one serialization per file); not
  done, because the approved design chose the decoded form.
- **The `lower` stage lost 0.3 to 0.7 per cent of its instructions, and `stratify` lost 0.03 to
  0.2 per cent (settled; see "Stage shifts, explained").** `lower`: a ThinLTO inlining change
  (`lower::run` into `lower::lower`, five passes out of line) and the register allocation that
  followed; callgrind reproduces the perf differences to within 50 instructions per iteration,
  with the same calls and the same work. `stratify`'s own shift: `dedup_rows`, unchanged
  source, retires one instruction fewer per tuple comparison after a register-allocation
  change (−264 to −525 thousand per iteration); the slice sort's small-sort instantiation
  (−78 thousand on `datalog`); a heap-layout term that follows glibc's dynamic mmap
  threshold (−98 to +67 thousand, zeroed by fixing the threshold); and the milestone's real
  added work, at most about 20 thousand (the +8 to +20 thousand of item 5 is an upper bound,
  which mixes code generation with work, not an attribution), including three SHA-256
  compressions for the header and a 1 per cent slower per-tuple digest feed. With the threshold fixed, the native differences and
  the callgrind code sums agree within 2 to 31 thousand per iteration. The residual is not
  attributed per function natively; doing so would need a native exact per-function count
  (uprobes, which need `perf_event_paranoid` at most 1). `prepare` +174: `Workspace::new` is
  identical; the difference is in glibc's malloc and free paths and depends on the heap state
  at stage entry. None of the shifts is a saving this milestone made; each is kept as code
  generation or heap layout, and the added work is three to five times the Fermi's "few
  thousand".
- **The `stratified` cohort's `stratify` peak RSS rose 6.4 MB, 4.4 MB with the heap layout
  fixed (settled; fixed in `6575bba`: +0.26 MB against the control after the fix, the same
  residual as every other cohort).** The ranked checker's relations (4,184,092 bytes on this
  cohort) are now bound to `searched` for the disagreement report and live to the end of the
  layer, across the checker/evaluator comparison where the peak falls; the control freed
  them at the end of the comparison statement. Massif: peak heap 48.86 MB against 53.05 MB, the
  difference exactly that allocation. The design's performance section said the default path's
  peak RSS was unchanged; it was not, on this cohort. `6575bba` drops `searched` after the
  derivation/ranked comparison; with a new candidate (`71c25e7`) the `stratified` peak is
  51,960 KiB against the control's 51,700, and the stage A/B shows only a heap-layout move in
  `stratify` (see "The ranked relations released").
- **A refused `rel-lower --chain` run exited 0 and left a partial directory (settled, fixed
  in `71c25e7`).** Found while timing the chain: `columns3` at 128 and 512 definitions is
  refused by the complement budget in its second layer; the tool reported the diagnostic,
  exited 0, and left layer 0's three files without `chain.json` (`rel-verify` refused the
  directory, so nothing false was accepted). The chain is now staged in a sibling directory
  and renamed into place when complete, and a refused `--chain` run exits 1; tested by
  `a_refused_run_exits_with_an_error_and_leaves_no_chain`.
- **Literal-map order (settled, fixed in `0d270c7`).** The map was checked as a set, so a
  permuted map was a second spelling with a second chain identity. Correction (audit): it was
  not the only free order. The construction lists `complements`, `filters` and `aggregates`
  paired records with declarations through the `origin` index only, so a consistent
  permutation of a list and its origin indices verified under a new chain identity. Fixed in
  private `8abe414`: each list must be in declaration order, by layer and then by
  declaration, and any other order is refused.

## Milestone c

Not started.
