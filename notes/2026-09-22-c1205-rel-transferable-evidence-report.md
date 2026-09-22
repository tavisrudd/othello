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

Not started.

## Milestone c

Not started.
