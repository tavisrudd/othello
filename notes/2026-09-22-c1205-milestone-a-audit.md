# C1205 milestone a — independent audit

**Lane**: `ergodis`
**Date**: 2026-09-22
**Under audit**: core `~/src/ergodis` `a92050a` (diff against `2b71f67`), private
`~/src/ergodis-private` `bfd79c9` (receipts), report
`notes/2026-09-22-c1205-rel-transferable-evidence-report.md` section "Milestone a", card
`notes/2026-09-18-c1205-rel-transferable-evidence.md`.

Status: complete. Findings: 0 high, 1 medium, 7 low, 3 info. Verdict: accept milestone a after
the medium finding and the test gaps (L1–L3) are repaired; no identity, soundness or performance
claim is overturned.

## Findings, by severity

No high-severity finding. The decoder is sound and canonical, identities are unmoved, and the
checker entries bind as claimed. The defects are in test discrimination, one false claim about
the test certificates, and several inaccurate statements in docstrings and the report.

### Medium

**M1. On `closure.json` the "certificates the producer cannot emit" are exactly the producer's.**
The reference producer in `crates/verify/tests/prepared_source.rs` emits, for the closure fixture,
a derivation certificate and a ranked certificate whose `identity_of` digests are
`5360dca7…d541b6` and `e34e6082…4c1767`: byte for byte the evaluator's certificates pinned in
`crates/rules/tests/demand_prepared.rs::the_identities_and_certificates_of_both_routes_are_pinned`
(prepared closure row). Only on `same_generation.json` do they differ (`f942770d…`, `1c7f61bd…`
against the evaluator's `45356bc3…`, `97d921fc…`). Evidence: scratch test `audit_reference_digests`
appended in the audit worktree, output
`AUDIT 7f987bdd 5360dca7…d541b6 e34e6082…4c1767 derivs=12` and
`AUDIT 0e333c41 f942770d…66e67 1c7f61bd…2b6d3 derivs=23`.
- Failure scenario: a defect in `check_prepared` that accepts only the evaluator's own derivation
  order would pass `certificates_are_checked_from_the_bytes_alone` on closure; the card's
  acceptance item "tests include certificates the producer cannot emit" rests on the
  23-derivation same-generation fixture alone. The module doc ("list derivations in an order that
  producer never emits"), the test doc ("which the demand-driven evaluator cannot emit in this
  order") and the report's Tests section state it for both fixtures, which is false.
- Repair: make divergence structural rather than incidental — e.g. list each round's derivations
  in reverse rule order and reverse tuple order, or emit a valid non-round-major topological order
  — and add a third fixture with more than one recursive rule. Assert in `demand_prepared.rs`
  (which sees both producers) that the reference certificates differ from the evaluator's on every
  fixture. Correct the doc comments and the report sentence.

### Low

**L1. The input-bound test does not test the bound.** `the_decoder_refuses_what_admission_refuses…`
checks `decode_prepared(&vec![0u8; MAX_PREPARED_BYTES + 1]) == Err(Budget)`. The first word of
that input is domain 0, which the decoder's domain check refuses with the same `Error::Budget`.
Mutation: `if false && bytes.len() > MAX_PREPARED_BYTES` in `decode_prepared` — all ten
`prepared_source` tests pass. The test comment "The input bound is checked before anything is
read" is not verified by anything.
- Repair: pad a valid fixture encoding to `MAX_PREPARED_BYTES + 1` bytes; without the bound it is
  `Error::Encoding` (trailing bytes), with it `Error::Budget`.

**L2. The certificate decoder bound has no test.** No test in the core names
`MAX_CERTIFICATE_BYTES` or feeds an oversized input to `decode_derivation_certificate` or
`decode_ranked_certificate` (searched `crates/` and `tests/`). Removing either check fails nothing.
- Repair: one test per decoder with `MAX_CERTIFICATE_BYTES + 1` bytes of a JSON object prefix
  (`Error::Source` without the bound, `Error::Budget` with it).

**L3. The decoder's count guards are caught only by a process abort.** Mutating out the
`relation_count > MAX_RELATIONS` guard makes `every_single_byte_change_is_refused_or_names_another_source`
abort the whole test binary with `memory allocation of 51539607600 bytes failed` (SIGABRT; a
relation count flipped to `0x80000002`, times 24-byte `PreparedRelation`); the rule-count guard
likewise (`68719476800` bytes, 32-byte `DecodedRule`). The guards are real and needed, but the
test that catches them does so by crashing, not by a named assertion, and only through the
0x80 mask landing on a count's high byte.
- Repair: an explicit test: `domain=1, relation_count=0x8000_0002` (and the same for
  `rule_count`) on a short input expects `Error::Budget`.

**L4. The decode memory statement is wrong by a factor of about two; non-canonical fact lists are
sorted before being refused.** `MAX_PREPARED_BYTES`'s doc and the report say a decode holds "the
input, its parsed buffers and the admitted form, each about the input's size — within a few times
one gibibyte". Per tuple the decode holds the input, the parsed rows (1×), `AdmittedFact`
(12 bytes per tuple: 1.5× the input for binary, 3× for unary), `tuples` (1×), admission's sort
keys `(u64, u32)` (16 bytes per tuple: 2× for binary, 4× for unary) and the re-encode buffer (1×).
Measured with a scratch example (`crates/contract/examples/audit_mem.rs` in the audit worktree,
release, 128 MiB input): canonical binary relation, peak RSS 854,372 kB = 6.4× input
(0.89 s); 128 MiB of duplicate unary tuples, peak RSS 788,920 kB = 5.9× input, refused with
`Error::Encoding` only after admission sorted 33.5 M keys; `facts` and `tuples` are also reserved
for the pre-deduplication count, so reserved memory is about 10× input. At the bound that is
about 6.5–7 GiB resident (10 GiB reserved) before the checker allocates anything, and a 1 GiB
decode cannot run on wasm32 at all. Nothing is unbounded, so this is Low, but the stated
arithmetic is wrong and the refusal of a non-canonical fact list costs a full sort.
- Repair: refuse non-increasing tuples during the parse (one comparison of each tuple with its
  predecessor; the admission sort then never sees a duplicate, and the canonicality comparison
  stays as the backstop), and state the real multiple (about seven times the input) in the
  docstring and the report. Consider a caller-supplied bound on the checker entries.

**L5. `encode_prepared` returns bytes the decoder refuses for a self-consistent hand-built
`Admitted`.** The report says the binding check "makes the function total over any `Admitted` and
never wrong about what it returns". `has_prepared_layout` checks offsets and relation order, not
tuple order, distinctness, rule shape, or input flags. Scratch test
`audit_hand_built_admitted_encodes_to_refused_bytes`: swap two tuples of relation 0 of an admitted
closure (layout intact), set `source_id = prepared_identity(swapped bytes)`; `encode_prepared`
returns `Ok(swapped bytes)` and `decode_prepared` refuses them with `Error::Encoding`. All
`Admitted` fields are `pub`, so such a value is constructible by any caller.
- Repair: either state the precondition (input produced by `admit_prepared`/`decode_prepared`) and
  drop "total over any `Admitted`" from the report, or make `has_prepared_layout` also require
  strictly increasing packed keys per relation (cheap, one pass), which closes the fact-order
  case; the rule-shape cases need the precondition.

**L6. `prepared_encoding()` overloads `Error::Schema`.** `Error::Schema` means "unsupported rule
or certificate schema/algebra"; here it means "this plan's transferable form is a program". It
works, and `runtime::recursive` already uses `Schema` for a wrong-variant refusal, but the caller
must know which error means which. Recommendation (question 4): one method that cannot be asked
the wrong question,
`Demand::transferable_source(&self) -> Result<TransferableSource<'_>, Error>` with
`enum TransferableSource<'a> { Wire(&'a Program), Prepared(Vec<u8>) }` (the `Result` carries only
`Budget`), and drop `prepared_encoding` or keep it as a thin wrapper. An `Option<Result<…>>`
would also be honest but nests awkwardly. Milestone b is the first consumer, so now is the time.

**L7. Report inaccuracies** (each re-derived; none changes a conclusion):
- The path-length null's replay command writes `$W/ab-path-length.json` under `~/.cache`, but the
  committed receipt is `analysis/datalog-comparison/ab-2026-09-22-prepared-bytes-path-length-null.json`;
  the replay block does not reproduce the committed file.
- `python3 python/generate_fixtures.py --check` is listed as the plan-fingerprint and
  parity-digest gate. It regenerates the Python oracle's fixtures and compares them with the
  committed files; this commit touches neither the generator nor any fixture, so the gate is
  vacuous for this change (0.6 s). The Rust side of parity is exercised inside `cargo test`.
- "The backend stage … moves by −1.5 × 10⁻⁵ … in the favourable direction … as predicted": the
  datalog cohort's own A/A drift reads 1.000015 [0.999995, 1.000035], the same magnitude, so the
  −25,590 instructions per iteration are not evidence of a code effect in either direction. The
  Fermi's "a few instructions per call" was never turned into a number (admissions and encoded
  bytes per iteration were not counted), so "inside the size the Fermi allowed" is not checkable.
- Receipts carry only the private revision; the control arm's name `control-8de4932` does not
  carry its core revision `2b71f67` (the report's arm table does). PERFORMANCE.md rule 6 wants it
  per arm; the report table satisfies it, the receipts do not.
- The same-generation prepared ranked digest is abbreviated `97d921fc…05660` (five trailing hex
  digits where every other cell has six). Cosmetic.

### Info

- **I1. Checker independence is process independence.** `check_prepared` re-admits through
  `ergodis_contract::datalog::decode_prepared` → `admit_prepared`, the same code the producer's
  `Demand::new_prepared` runs. A defect in `admit_prepared` is shared by producer and checker —
  exactly as on the wire route, where both run `datalog::admit`. Not a regression; the doc's
  "independently of the producer" should read "without the producer's objects".
- **I2.** Every decode refusal, including `Error::Budget`, becomes `Rejection::Binding`, so a
  checker caller cannot tell an oversized source from a malformed one. Matches the wire entries.
- **I3.** Relation order and rule order are part of the identity (facts are a set, rules and
  relations are lists). Pre-existing definition, unchanged; noted because "one encoding per
  source" holds with source meaning the ordered lists.

## Answers to the audit questions

1. **Decoder canonicality and soundness: sound.** Acceptance requires
   `write_encoding(admit_prepared(parse(b))) == b`. Hence (a) `encode(decode(b)) = b` for every
   accepted `b`; (b) two accepted inputs that decode to one `Admitted` are equal, so each admitted
   source has one encoding; (c) for `A` from `admit_prepared`, `decode(encode(A)) == A`, because
   the encoding carries every non-derived field of `Admitted` (`universe`, `index`, `fact_count`
   are recomputed identically, tuples are already sorted and distinct). Every lossy step of the
   parse (non-UTF-8 name → `""`, variable word > 255 → 255, arity 0 with any count) is either
   refused by admission or caught by the final byte comparison. Checked by hand: truncation,
   trailing bytes, huge name length, count × arity overflow (`checked_mul`), arity 0 with count
   `u32::MAX` (no allocation, then `Error::Source`), `values * 4` only after `fits`, `u32` offsets
   (at most 2^28 values under the bound), key packing (`65536^4 - 1` fits `u64`). No panic path
   found for any input. Allocation before refusal: bounded by the budgets (at most 64 relations,
   1,024 rules × 256 atoms, each atom's slots checked against the remaining input) and by the
   input for facts; the relation- and rule-count guards are load-bearing (L3). Memory multiple:
   L4.
2. **Identity preservation: confirmed.** The new pin test
   `the_identities_and_certificates_of_both_routes_are_pinned`, copied verbatim into a worktree
   at `2b71f67` (it uses only API present there), passes there: all twelve values (wire and
   prepared source identities, derivation- and ranked-certificate digests, both fixtures) are the
   old revision's. The byte stream written by `write_encoding` is, field for field, the stream the
   old `admit_prepared` wrote (read from the diff). `datalog::admit` (the wire route) is not in
   the diff. `generate_fixtures.py --check` exits 0 (vacuous, L7); the private reference-evaluator
   differential and `rel_lowering` tests pass at the current HEADs (below).
3. **Checker entries: independent of the producer's objects.** Both `check_prepared_bounded`
   take only `(&[u8], &Certificate, direct_limit)`, decode, then run the unchanged
   `check_admitted_bounded`, which compares `certificate.source_id` with the decoded `source_id`
   (`crates/verify/src/derivation.rs:206`, `ranked.rs:235`). The decoded identity is the hash of
   exactly the accepted bytes, so a certificate of source A passes against bytes of B only on a
   SHA-256 collision; wire and prepared identities are separated by their distinct NUL-terminated
   tags. Shared code with the producer: I1.
4. **`SourceForm` / `Demand`.** The enum names the regime and removes the ambiguity of
   `None`; `Demand::verify` still takes `check_admitted` for a prepared plan (documented as the
   in-process path, as the card asks). `prepared_encoding()`: recommendation in L6.
5. **Bounds.** `1 << 30` is defensible as a ceiling (the largest committed cohorts need tens of
   MB) but the memory arithmetic in its doc is wrong (L4: about 6.5× resident, 10× reserved,
   measured). Sharing it with the certificate decoders is reasonable: a flat `Vec<u32>` JSON
   certificate costs at most about 2 bytes of JSON per 4-byte value, so its parse is 2–4× the
   input with vector growth. Untested: L1, L2.
6. **Tests.** Mutations (scratch worktree): re-encode comparison removed → 2 of 10 fail (killed);
   relation-count guard removed → test binary aborts (killed by crash, L3); rule-count guard
   removed → aborts (L3); input-size bound removed → all pass (survived, L1). Certificate bound:
   no test (L2). Producer-cannot-emit: half false (M1).
7. **Performance record: re-derives; residual explained.** All eighteen derivation-loop rows of
   the report match the receipt to the printed digits, as do the Rel-cohort and `datalog`-cohort
   figures. Arms: the manifest rows give private revision, clean flag, rustc 1.95.0, release, no
   features for all four binaries; the candidates were retained at 10:33:47 after `a92050a` was
   committed at 10:32:11; the controls' hashes equal the `-pack-a082a07` retains; the controls
   carry no `write_encoding` symbol, the candidate tools binary does. Disassembly: both
   `evaluate_counting` instantiations and all 61 `ergodis_rules::` symbols compare empty under
   `symbol_disasm.py` except `<Policy as Debug>::fmt`; `check_admitted_bounded` (both checkers)
   compare empty in the tools binaries; `admit_prepared` 0x19e4 → 0x11ad and `write_encoding`
   0x1c33, `Streaming::word` call sites 8 → 5, all as reported. The "identical in all 18 cohorts"
   claim is one binary's code, so it covers every cohort. **The `closure:sparse:256` residual is
   settled:** reproduced at 1.000035 [1.000024, 1.000045] (+1,336 instructions per evaluation);
   it persists unchanged under environment padding of 0–56 bytes (+974 to +1,541 per
   evaluation over twelve paddings), so it is not stack placement. Callgrind on both arms at
   `repeats` 3 and 6 gives per-evaluation `evaluate_counting` and `index_rows` counts identical
   between arms (35,353,621 and 3,338,552); the whole difference (+1,861 per evaluation) is glibc
   `malloc_consolidate` (+965), `unlink_chunk` (+347) and `HashMap::insert` (+532): process-level
   heap and hash-table costs that do not cancel in the two-point difference because the
   control's 3-repeat run pays about 2,900 more `malloc_consolidate` instructions than its
   6-repeat run. It is a differencing artifact of heap layout, not loop work. The report's
   mystery-ledger item can close with this cause.
8. **Gates at current HEADs: all green.** Core `a92050a`: `cargo fmt --all -- --check`, `cargo
   clippy --all-targets --all-features -j 12 -- -D warnings`, `cargo test --all-features
   --no-fail-fast -j 12`: exit 0, 85 `test result: ok` blocks, 0 failed (58 s, warm cache).
   Private `bfd79c9` against core `a92050a`: `cargo fmt --check`, clippy as above, `cargo test
   --all-features --no-fail-fast -j 12`: exit 0, 14 min 14 s, 40 result blocks, 1,171 passed,
   0 failed, including the five `rel_reference_eval` tests the report names. The sub's skipped
   final full run is now covered.
9. **Comments: no violation found.** Every added comment line in `crates/` of the diff was
   scanned for task IDs, notes paths, review or finding names, process narrative and measurement
   history; none. "recorded values" in `demand_prepared.rs` describes what the test pins, not
   history.
10. **Report numbers:** every figure in the milestone a section re-derives except those noted in
    M1, L4, L5 and L7.

## Reproduced numbers

| Claim                                             | Report                      | Reproduced                                    | Source                                   |
|---------------------------------------------------|-----------------------------|-----------------------------------------------|------------------------------------------|
| Prepared/wire identities and certificate digests  | old = new, 12 values        | pin test passes at `2b71f67`                  | old-revision worktree                    |
| Core test blocks                                  | 85 ok, 0 failed             | 85 ok, 0 failed                               | core gate run                            |
| Private tests                                     | 1,171 passed, 40 sections   | 1,171 passed, 40 sections                     | private gate run                         |
| `closure:sparse:256` instructions                 | 1.00004 [1.00003, 1.00004]  | 1.000035 [1.000024, 1.000045]                 | `ab.py` rerun, 5 rounds                  |
| `mutual:blocks:4096` instructions                 | 1.00012 [0.99989, 1.00035]  | 1.000005 [0.999716, 1.000294]                 | `ab.py` rerun                            |
| `path4:sparse:16384` instructions                 | 1.00000 [0.99999, 1.00001]  | 1.000002 [0.999993, 1.000011]                 | `ab.py` rerun                            |
| Output digest `closure:sparse:256`                | agree                       | `997ab86a3ab9…` both arms, equals receipt     | `ab.py` rerun                            |
| Path-length A/A                                   | 0.999999                    | 0.9999985 in the committed receipt            | receipt                                  |
| Stratify per iteration                            | 1,683,070,216 vs …095,806   | 1,683,070,216.15 vs 1,683,095,805.7           | datalog receipt                          |
| Stratify page faults                              | 4,914.7 vs 4,918.2          | 4,914.7 vs 4,918.2                            | datalog receipt                          |
| Rel-cohort comparisons, worst                     | 56, `prepare` 0.99997       | 56, `prepare` 0.99997 [0.99986, 1.00009]      | Rel receipt                              |
| Measurements                                      | 1,623 and 340               | 1,623 and 340                                 | receipts                                 |
| `admit_prepared` / `write_encoding` sizes         | 0x19e4 → 0x11ad; 0x1c33     | same                                          | `nm -S` on the retained tools binaries   |
| `Streaming::word` call sites                      | 8 → 5                       | 8 → 5                                         | `symbol_disasm.py`                       |
| Decode peak RSS                                   | "a few times", each ~1×     | 6.4× (binary), 5.9× (dup unary), ~10× reserved | scratch example, 128 MiB input          |

## Scratch state created by this audit

- Worktrees (detached; registered in `~/src/ergodis/.git/worktrees`):
  `~/.cache/ergodis/worktrees/audit-c1205-old` at `2b71f67` (pin test appended to
  `crates/rules/tests/demand_prepared.rs`) and `~/.cache/ergodis/worktrees/audit-c1205-mut` at
  `a92050a` (all mutations reverted; two scratch tests appended to
  `crates/verify/tests/prepared_source.rs`; `crates/contract/examples/audit_mem.rs`).
- `~/.cache/ergodis/audit-c1205-private-gate.txt`, `~/.cache/ergodis/audit-c1205-sym/`
  (disassembly listings), `~/.cache/ergodis/audit-c1205-ab/` (A/B rerun, padding probe,
  callgrind outputs).
- Build products in the shared target dirs. Nothing was edited, committed or staged in the three
  repositories other than this file.

## Verdict

Accept, with repairs before the task closes. The byte form is canonical and sound, the checker
entries admit independently of the producer's objects and bind to the bytes, identities and
certificates are unmoved, every gate is green, and the performance record re-derives with its one
open residual now explained as a heap-consolidation artifact of the two-point difference. Repair
before close: M1 (make the reference certificates structurally different from the evaluator's
and assert it), L1–L3 (tests that discriminate the byte bound, the certificate bound and the count
guards), and the wording of L4, L5 and L7 in the docstrings and report. L6 is a decision for
milestone b's first consumer.
