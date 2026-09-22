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
records in the chain, fresh records as the verifier's output. Implementation in progress; see
"Implementation" below.

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

Written incrementally. Stopped by the context budget after the commits below; the exact
remaining steps are under "Remaining steps".

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
| private `c1205b` | `48ccaaa` | `Error::CheckersDisagree(Disagreement { layer, relation, tuple, held_by, missing_from })` with `Party::{Derivation, Ranked, Evaluator}` and a merge walk (`first_difference`), for both the derivation/ranked and the checker/evaluator comparison; `Error::Record(RecordMismatch { kind, index, field })` replacing `ComplementMismatch`, with `RecordKind`, `RecordField`, `DomainPart` and a `Display` path such as `complements[0].column_domains[0].values`; `tuple_digest(DigestKind, scope, name, arity, tuples)` under tag `ergodis-private/rel-chain.v1` replacing `digest_of` in the builder and the record check; the tamper test now asserts the field of each of its seven tampers; unit tests for the disagreement and for digest separation; the bench witness keeps `3 << 60 | layer` and `4 << 60 | index` |

Core gate at `064cde2`: `generate_evidence.py --write`, `cargo fmt --all -- --check`, `cargo clippy
--all-targets --all-features -D warnings`, `cargo test --all-features` (85 `ok` blocks, zero
FAILED), `generate_fixtures.py --check`, `check-runtime-dependencies.py`,
`check-verifier-dependencies.py`: all passed in one run. Every pinned identity and certificate
digest in `demand_prepared.rs` and `prepared_source.rs` passed unedited. Native and WASM ABI
harnesses not rerun: the change adds a method to `Demand`, which the grounded ABI does not
reach (to be rerun with the final core gate).

Private gates per commit: `cargo fmt --check`, `cargo clippy --all-targets --all-features -D
warnings`, and the suites `rel_layer_identities`, `rel_externals`, `rel_lowering` (53, the
parity and fingerprint assertions unedited) and `rel_reference_eval` (19, the differential
unedited), all green at `1f8200b`, `d77f3d2` and `48ccaaa`. Full private `cargo test
--all-features --no-fail-fast` on the tree committed as `48ccaaa` (against core `064cde2`):
exit 0, 17 min, 42 `ok` blocks, 1,177 passed, 0 failed. This milestone adds five tests so far
(the identity pin, two externals tests, two `rel_stratified` unit tests); the base count at
`482d6e9` was not rerun, so the remaining difference from milestone a's 1,171 is unattributed.

#### Remaining steps

In order; each is a commit on the private `c1205b` branch with the gates above, and the report
updated after it. The design sections above are the specification.

1. Done (`48ccaaa`).
2. **Checked and unchecked types.** Rename today's `Stratified` to `Evaluation` (pub fields); add
   per-layer `declared: Vec<Declared { name, arity, input, origin }>` (move `names`, `arities`,
   `inputs` into the report after `Demand` is built; `origin` from `index_of` and the three
   construction lists) and `literals: Vec<(u32, u32)>` (RIR literal id, declared index, pushed
   wherever `atom_over` is set). `LayerReport` stops being `Copy`. Add
   `rel_chain::Program::of(&Rir, &Readout)` (the `P` table in the design, serde,
   `deny_unknown_fields`, identity `SHA-256(tag ‖ 0 ‖ serde_json::to_vec)`), and
   `check(Evaluation, &Rir) -> Result<Stratified, Error>` with a sealed `Stratified` (private
   field, `Deref<Target = Evaluation>`). `check` runs the construction checker against `P` for
   every field in the design's field table (extend `RecordKind` with `Literal`, `Declared`,
   `Seeded`, and `RecordField` with `Layer`, `Uses`, `Declared`, `Name`, `Dictionary`,
   `DictionaryBefore`, `ColumnType`, `TypeStart`, `TypeEnd`, `Literal`). Remove
   `verify_records`; update `tests/rel_lowering.rs` (`stratified` helper, tamper test),
   `tests/rel_reference_eval.rs`, `tasks/tools/src/rel_lower.rs`, and
   `rel_frontend_bench.rs`'s untimed description (check `bench.py` first for whether it
   compares `records_verified` between arms; if so keep it as constant `true`).
3. **Independent rebuild (D1 (a)).** New module `src/rel_rebuild.rs` as specified (typed value
   decoding, `BTreeSet` domains, odometer complement, typed-value comparisons promoted from
   `tests/rel_reference/mod.rs` with the test tree importing them back, group-then-fold
   aggregates). The construction checker calls it. Differential test against the builder over
   the committed fixtures and the generated corpus; construction-level mutation checks in a
   scratch worktree (off-by-one domain, swapped operator, wrong group key), each caught.
4. **Evidence sink and chain writer.** `Evidence` trait with `const RETAIN: bool`, `NoEvidence`,
   `ChainWriter`; `evaluate` = `evaluate_with(.., &mut NoEvidence)`. In the retaining
   instantiation, per layer: `demand.transferable_source()` (expect `Prepared`), both
   certificates to the sink, `derivation_digest`/`ranked_digest` into the layer record. The
   manifest (`rel_chain::Manifest`, hex digests) and `program.json` written after `check`;
   `producer.json` beside them. `rel-lower --chain <dir>`, plus `--externals <json>` so the
   fixture's `ext` can be supplied from the command line.
5. **Offline verifier.** `src/rel_verify.rs` (`verify_chain`, `verify_parts`, sealed
   `VerifiedChain`, `ChainError` with file, layer and field path), steps 1–7 of the design;
   `ergodis-tools rel-verify <dir> [--source-check] [--records <file>] [--max-layer-bytes N]
   [--max-certificate-bytes N]`; the source-scan test that `rel_verify` and `rel_rebuild`
   import neither `ergodis_rules` nor `rel_stratified`.
6. **Tests.** `tasks/tools/tests/rel_chain.rs` (two processes: `rel-lower --chain` then
   `rel-verify --records`, then replay of the records); `tests/rel_chain.rs` (every manifest
   leaf, list-shape mutations, the six named categories, consistent forgeries, file-level
   cases, in-process `check` table). Extend `tests/rel_layer_identities.rs` to pin both
   certificate digests per layer, now that they are recorded.
7. **A/B.** Candidates retained from the final commits with labels `closure_ballpark-c1205b` and
   `ergodis-tools-c1205b`; symbol comparison; `ab.py --mode evaluate` over the eighteen cohorts;
   `bench.py` over the five default cohorts and over `datalog,stratified,columns,columns3,aggregate`,
   exactly as in the design's A/B plan; receipts committed in private; results against the
   Fermi. Then native and WASM ABI harnesses against the final core.
8. **Close.** Full core and private gates at the final commits; fast-forward check of both
   branches onto their mains; the independent audit; `cache-gc.sh` dry run.

#### Divergence

At the time of stopping, core `main` is `4b57649` and private `main` is `482d6e9`, the start
points; both `c1205b` branches fast-forward onto them.

## Milestone c

Not started.
