# C1209 — contract crate split: independent read-only audit

**Lane**: `ergodis`
**Date**: 2026-09-21

**Verdict**: **The split is sound as a move, and the record is accurate about the code. One
substantive defect: the performance repair is half done on a false disassembly reading, and the
report asserts the opposite three times.** Every claim about the *move* holds under independent
re-derivation — no type, budget, schema string, encoding, error variant or `thiserror` message
changed; the declared exceptions are exactly what they say and nothing rode along; the dependency
direction is clean with no re-exports; all five identity hexes recompute from committed bytes and
the checker identity moves exactly once; no pinned digest was edited; the core and private suites
reproduce the report's counts exactly (1021/0 and 1171/0). The accepted work needs two code
changes before close — `#[inline]` on `Admitted::pack`, or a restatement of why not that matches
the disassembly, and the missing contract forgery case — plus one wrong sentence in a public document and several
report corrections. Nothing found here calls the two identities, the record format or the
correctness of the split into question.

Scope audited: core `~/src/ergodis` `db7fec6`, `83eec12`, `f7b0d16` against parent `96aee9b`;
private `~/src/ergodis-private` `55dab0c`, `a082a07` against `74f974c`. Both working trees were
clean at the start of the audit (`git status --short` empty in each). Nothing was edited and no
commit was made in either repository.

---

## 1. Is it a move? (card item 1)

**Method.** Every `crates/verify/src/*.rs` blob at `96aee9b` (12 files) and every
`crates/verify/src/*.rs` + `crates/contract/src/*.rs` blob at `f7b0d16` (18 files) was extracted
with `git show` and compared as a *multiset of lines*, so a line that merely changed file is
invisible and only genuine content change survives:

```
cat old/*.rs | sort > old-all.txt ; cat new/*.rs | sort > new-all.txt ; diff old-all.txt new-all.txt
  old 5294 lines, new 5498 lines, 334 differing lines
  → 65 removed non-blank, 251 added non-blank
```

Every one of those 316 lines was read. They fall entirely into: module docstrings, `use` path
retargets (`crate::` → `ergodis_contract::`), the two identity tables and their completeness
tests, the record's second field, `RECORD_SCHEMA`, the `#[inline]`, the four `Grounded` field
reads rewritten as accessor calls, the `check_invariance` visibility widening, and one rustfmt
reflow of `verify_support`'s signature onto one line (a consequence of importing
`SupportCertificate` directly instead of through `support::`).

**Targeted invariance checks on the same two sets** (identical multisets unless noted):

| Filter | Result |
|---|---|
| `#\[error\(` — every `thiserror` message | **identical**, byte for byte |
| `^pub const [A-Z_]*SCHEMA` | identical except the new `pub const RECORD_SCHEMA: u32 = 2;` |
| `MAX_[A-Z]* *: *usize *=` — every budget | **identical** |
| item signature lines (`enum`/`struct`/`fn`/`trait`/`impl`/`type`) | differs only by the identity machinery, the two `sources_are_complete` tests, `check_invariance` private→`pub`, contract's new `implementation_identity`, and the `verify_support` reflow |

**Per-file, non-doc added lines** (`diff -u0 old/<f> new/<f>`, filtering `+//!`/`+///`/blank):

- `contract/composition_graph.rs`: **none**. `ProductRule`, `Limits` and `Error` are the
  originals byte for byte; the file is the old one with the replay block deleted.
- `contract/derivation.rs`, `contract/ranked.rs`: one line each, `use crate::rule_contract::Error;`.
- `contract/support.rs`: one line, `use crate::weight::TransitionWeight;`.
- `contract/rule_contract.rs`: two lines — `use crate::composition_graph::{self, ProductRule};`
  and the `pub fn check_invariance(…)` widening.
- `contract/weight.rs`, `contract/datalog.rs`: rename at 100 % similarity at `83eec12`
  (`datalog.rs` later takes the `#[inline]` in `f7b0d16`).
- `verify/{composition_graph,derivation,ranked,support,datalog_store,min_plus_transition}.rs`:
  `use` lines only.
- `verify/finite_lowering.rs`: **no change at all**.
- `verify/binary_composition.rs`: `RECORD_SCHEMA`, the `contract: ContentId` field with its
  docstring, `schema: RECORD_SCHEMA`, `contract: ergodis_contract::implementation_identity()`.
- `verify/grounded.rs`: the lifted block. Diffed against lines 650–770 of the original
  `rule_contract.rs`: the only body differences are `grounded.inputs` → `grounded.inputs()`,
  `grounded.products` → `grounded.products()`, `grounded.source_id` → `grounded.source_id()`,
  and the signature reflow. No item, predicate or constant changed.

**Each declared exception checked, and nothing rode along:**

| Declared exception | Verified |
|---|---|
| record gains a second identity field | `VerificationRecord.contract: ContentId`, `AdmissionReceipt.contract`, `WireReceipt.contract`; no other field added anywhere |
| record schema 1 → 2 | `pub const RECORD_SCHEMA: u32 = 2;` replaces the literal `schema: 1`; the constant is new |
| verify domain tag v2 → v3 | `IDENTITY_DOMAIN = "ergodis/direct-binary-composition-check/v3"` |
| `check_invariance` made `pub` | the single visibility change in the whole diff |
| `Limits`/`ProductRule`/graph `Error` relocation | byte-identical, see above |
| `#[inline]` on `Admitted::tuple` | `f7b0d16` is 2 files: 4 added / 1 removed line in `crates/contract/src/datalog.rs` (the attribute plus two docstring lines), and the regenerated `SHA256SUMS`. Nothing else. |
| clippy allow on `AdmissionOutcome` | `#[allow(clippy::large_enum_variant)]` plus a four-line docstring; no other change to the enum |

**Verdict on item 1: it is a move.** No type, budget, schema string, encoding, error variant or
`Display` string changed.

---

## 2. Dependency direction and re-exports (card item 2)

- `crates/contract/Cargo.toml` `[dependencies]` is exactly `serde`, `serde_json`, `sha2`,
  `thiserror` — **no workspace member**, and no `[dev-dependencies]` section at all.
- `crates/verify/Cargo.toml` gains exactly one line, `ergodis-contract = { path = "../contract" }`.
  Its pre-existing dev-dependency on the root crate is unchanged.
- The contract dependency is also present in `crates/rules`, `crates/runtime`, the root
  `Cargo.toml` and `~/src/ergodis-private/Cargo.toml`. `wasm/Cargo.toml` and
  `tasks/tools/Cargo.toml` are untouched, as the report says.
- **No re-export of a moved path.** `rg '^\s*pub use' crates/contract/src crates/verify/src`
  returns one line, `crates/verify/src/lib.rs:19: pub use datalog_store::DIRECT_LIMIT;`, which
  predates the split and points at a module that stayed. There is no `pub use ergodis_contract`
  anywhere.
- **No stale `ergodis_verify::` path to a moved item** in core Rust, private Rust, core `docs/`,
  `DESIGN.md`, `README.md`, `scripts/` or `python/`. The surviving `ergodis_verify::` references
  name `min_plus_transition`, `finite_lowering`, `binary_composition` or the new `grounded`, all
  correct. The one exception is the artifact the report itself flags:
  `~/src/ergodis-private/analysis/rel-frontend/coverage-v1.json` still says
  `ergodis_verify::rule_contract::Program` in its prose; the report declares this deliberately
  left alone as a dated coverage record.
- Both guard scripts pass under the Nix toolchain, with the strings the report quotes:

```
python3 scripts/check-verifier-dependencies.py
  verifier dependency boundary passed: the contract and four approved external direct
  dependencies; 25 packages in normal/build closure; no solver or host package     (exit 0)
python3 scripts/check-runtime-dependencies.py
  runtime boundary passed: runtime -> core, rules, verifier; no reverse or default host edge
                                                                                   (exit 0)
```

  Reading the scripts confirms the assertions are the pair: contract's direct set must equal the
  four externals, verify's must equal those four plus `ergodis-contract`, and verify's workspace
  closure must equal `{verify, contract}`. The runtime script's expected closure includes
  `ergodis-contract` and `ergodis-modules`.

---

## 3. The two identities (card item 3)

**Hashed lists name every `src/*.rs` of their crate.** Contract's `HASHED_SOURCES` has 8 entries
and `crates/contract/src/` holds exactly 8 `.rs` files; verify's has 10 and `crates/verify/src/`
holds exactly 10, `support.rs` and the new `grounded.rs` included. The `support.rs` omission the
ADR names as pre-existing is repaired.

**The completeness test does fail when a module is missing — demonstrated, not just reasoned.**
Both crates carry an identical `sources_are_complete` test that builds `listed` from the names in
`HASHED_SOURCES`, builds `present` by
`std::fs::read_dir(concat!(env!("CARGO_MANIFEST_DIR"), "/src"))` filtered to `*.rs`, and calls
`assert_eq!(listed, present)` on the two `BTreeSet`s. Set equality fails in both directions. Both
tests ran and passed in the core suite (two `test tests::sources_are_complete ... ok` lines). In a
throwaway detached worktree at `f7b0d16` under `~/.cache/ergodis/worktrees/c1209-audit`, removed
with `git worktree remove` afterwards:

```
$ touch crates/contract/src/zz_probe.rs
$ cargo test -p ergodis-contract --lib sources_are_complete
failures:
    tests::sources_are_complete
test result: FAILED. 0 passed; 1 failed; …
```

Two gaps in the same test are demonstrated in finding 8.

**Independent recomputation of every reported hex, from committed bytes.** A standalone Python
re-implementation of each `implementation_identity` (SHA-256 over `RULE_ID` ‖ `RULE_VERSION`
little-endian ‖ the domain string ‖ each listed file's blob, in listed order; the contract's
omits the rule prefix) fed by `git show <rev>:<path>`:

| Identity | Revision | Recomputed | Report |
|---|---|---|---|
| checker, v2 tag, 11 files | `96aee9b` | `efcfa1af06d8ee380bc0578e8bd80a11996c600caf36e275176b1bd3c1f7f313` | matches |
| checker, v2 tag, 11 files | `db7fec6` | `efcfa1af…f313` (unchanged) | consistent |
| checker, v3 tag, 10 files | `83eec12` | `0ea8d53f610945bdcb867341aa8fcdae6e6d3b7580518856179b48bf34cf6498` | matches |
| checker, v3 tag, 10 files | `f7b0d16` | `0ea8d53f…6498` (unchanged) | matches |
| contract, 8 files | `83eec12` | `85346c30659b5f5d8ddd5f36a7659a2d9eae13e206b3a08292e3112afe0504b2` | matches |
| contract, 8 files | `f7b0d16` | `2b68f01e3995ff310017539d6c1cbbc339ba3452eac65e959a52e131ae434100` | matches |

**The checker identity moved exactly once across the three commits**: unchanged by `db7fec6`,
changed by `83eec12`, unchanged by `f7b0d16`. The three stated reasons are all visible in the
diff (six files leave the list, `support.rs` and `grounded.rs` join it, the tag goes v2 → v3).

**The verification record.** `VerificationRecord` carries `checker: ContentId` and
`contract: ContentId` as separate named fields, each with its own docstring;
`binary_composition::verify` fills them from `implementation_identity()` and
`ergodis_contract::implementation_identity()` respectively. Both are compared on admission, in
two places: `binary_composition::replay` accepts only on whole-record equality
(`verified.record == *record`), and `admission::solve_bound_reduction` adds the explicit clause
`|| admission.verified.record().contract != contract_identity()` beside the existing checker
clause. `AdmissionReceipt` and `WireReceipt` both gained the field, and
`replay_admission` copies `receipt.contract` back into the rebuilt record.

---

## 4. Invariants, gates and publication coverage (card item 4)

**No pinned constant was edited.** Across the whole range `96aee9b..f7b0d16`, excluding
`SHA256SUMS` and `Cargo.lock`, no added or removed line contains a hex literal of 16 characters
or more. `tests/admission_pipeline.rs`, which holds the only pinned checker hex in either tree
(`PRE_EXTRACTION_CHECKER_ID`, asserted with `assert_ne!`), is not in the commits' file list at
all.

**Every changed test and example file changes only imports, aliases and formatting**, plus the
two new contract assertions in `tests/verifier_boundary.rs`. No fixture bytes, expected value,
digest or oracle input was touched. The same holds for `crates/rules/src` and
`crates/runtime/src`: the only non-`use` changes are `derivation::premise_stride` called
unqualified, `rule_contract::verify{,_support}` becoming `grounded::verify{,_support}`, and the
`WireReceipt.contract` field with its projection.

**Gates re-run by this audit** (Nix toolchain, shared target dir):

| Gate | Command | Result |
|---|---|---|
| core tests | `nix develop ~/src/ergodis --command cargo test --all-features --no-fail-fast -j 12` | exit 0, **1021 passed, 0 failed**, 84 `test result: ok` sections, zero `FAILED` — reproduces the report exactly |
| verifier boundary | `python3 scripts/check-verifier-dependencies.py` | exit 0, string as quoted above |
| runtime boundary | `python3 scripts/check-runtime-dependencies.py` | exit 0, string as quoted above |
| manifest | `python3 python/generate_evidence.py --check` | exit 0, silent |
| publication guards | `bash tests/publication-guards.sh` | **105 passed, 0 failed**; `public-lint: clean` on every staged and shipped tree |
| format | `cargo fmt --all -- --check`, both repositories | exit 0, clean |
| private tests | `nix develop ~/src/ergodis --command cargo test --all-features --no-fail-fast -j 12` in `~/src/ergodis-private` | exit 0, **1171 passed, 0 failed**, 40 `test result: ok` sections — reproduces the report exactly |

The private run includes all five reference-evaluator differential tests the report names
(`the_committed_fixtures_agree_with_the_reference_evaluator`, `the_generated_corpus_agrees`,
`the_negation_corpus_agrees`, `every_figure_three_and_four_equation_agrees_with_the_reference_evaluator`,
`the_recorded_rejection_surface_agrees`), all green, and the core run includes
`dynamic_updates_match_independent_python_oracle` and
`a_prepared_source_is_admitted_to_the_same_shape_as_the_wire_source`.

**Publication lint and export manifest do include the new crate, not skip it.**
`python/generate_evidence.py`'s `HASHED_TREES` walks `crates` whole, so `SHA256SUMS` carries all
nine contract paths (`Cargo.toml` plus the eight sources); three spot-checked entries
(`crates/contract/src/datalog.rs`, `crates/contract/src/lib.rs`, `crates/verify/src/grounded.rs`)
match `sha256sum` on the working tree byte for byte, and the whole manifest verifies under
`--check`. `scripts/public-lint.sh` enumerates its target with `find "$tree_dir"`, so it has no
crate list to update and cannot silently skip a new directory; `.publicignore`,
`.public-lint-allow` and `.publication-profile` name no crate path, which is why the report's
"no change" verdict on them is right.

**The two private receipt pins reproduce as stated.**
`evidence/2026-09-12-privacy-lowering.sha256` pins `finite_lowering.rs` at `68ee2202…f0b2`, and
the file still hashes to exactly that. `analysis/weighted-normalization/SHA256SUMS` pins
`min_plus_transition.rs` at `61390899…c2ca`; the file now hashes to `7c55b24b…afd4`, so that pin
no longer verifies. The report's justification for leaving it alone also reproduces: both
receipts' `Cargo.lock` pins were already stale before this task (private lock at `74f974c` hashes
`b2f8e002…`, pinned `ebeb7931…`; core lock at `96aee9b` hashes `12fe7846…`, pinned `b9fdafe1…`).

---

## 5. Comment standard, public documents and ADR 0005 (card item 5)

**Every added comment line was read.** Inside the two packages the genuinely new comment lines
were isolated with the same multiset method as §1 (so that comments which merely moved file are
not counted); outside them, every added `//`/`#` line in the range was extracted. All of them
describe the code as it stands. There is no task identifier, no `notes/` path, no process word
(`moved`, `split out`, `now lives`, `previously`, `formerly`), no measurement history and no
agent name in any added comment, in core or in private `55dab0c`. The two `rg` hits for
`used to ` are both the ordinary verb ("it is not used to quotient or accelerate anything",
"A digest used to bind bounded inputs").

Two comments deserve naming because they are the ones that could have carried process:

- the `#[inline]` docstring in `crates/contract/src/datalog.rs` says only that both Datalog
  checkers call the accessor once per listed tuple, across the package boundary, where the
  compiler's cross-package heuristic leaves it out of line. The measured 0.071 per cent lives in
  the commit message, not the source;
- the `#[allow(clippy::large_enum_variant)]` docstring on `AdmissionOutcome` states the shape
  fact (two content identities wider than a refutation) and the reason for holding the variant
  inline. No lint name, no history.

**Public documents.** `rg 'C1[0-9]{3}|notes/20..-'` over `docs/`, `DESIGN.md`, `README.md`,
`crates/contract/src`, `crates/verify/src` and `src/admission.rs` returns nothing. The
`DESIGN.md` crate-table row, the contributor-boundaries paragraph, `docs/rule-contract.md`'s
checker sentence and replay command, and `docs/verification.md`'s two-identity paragraph all
describe the code as built. One sentence does not — see finding 2.

**ADR 0005** is `Status: Accepted`, dated 2026-09-21, and its three open cut questions are
answered in a dedicated section. Its account of what was built checks out against the code:
the contract's seven modules and the checker's nine plus `lib.rs`; the new `grounded` module;
`check_invariance` as the single forced visibility change; both `Rejection` enums crossing
because `Error::Derivation`/`Error::Ranked` carry them as payloads while `Error::Support` is a
unit variant so `support::Rejection` stays; all five decoders in the contract; `support::derive`
in the contract with `check` left behind; `Limits` moved with `ProductRule` and the graph
`Error`; `weight.rs` whole and byte-identical with its private `sealed` module. The claim that
the only pinned checker hex anywhere is the `assert_ne!` historical value also holds.

---

## 6. The performance evidence (card item 6)

**The arms are what the report says they are.** All eight measured sha256 values reproduce
against `~/.cache/ergodis/bin/`: `closure_ballpark-74f974c` `e8e2b139…`, `-55dab0c`
`97bd6231…`, `-inline-55dab0c` `478f9e9c…`, `ergodis-tools-74f974c` `6a9c0a86…`, `-55dab0c`
`e579be0e…`, `-inline-55dab0c` `b6b666e7…`, `rules-contract-properties-96aee9b` `a63989ff…`,
`-83eec12` `23e4d63c…`. The `ab.py` and `bench.py` receipts carry the same hashes in their `arms`
and `binary`/`control` blocks, so the JSON and the retained executables agree.

**The ratios re-derive from the receipt files.** Recomputing from
`analysis/datalog-comparison/ab-2026-09-21-c1209-derivation-loop.json` reproduces all eighteen
rows of the report's derivation-loop table — instruction ratio, 95 % interval, A/A null, cycle
ratio and derived counts — to the printed digit, and the worst deviation is exactly
`mutual:blocks:4096` at `1.000070` against its own null of `1.0000242`. Derived, probe and
candidate counts and the output digest are equal on every cohort and in the inline run too. The
inline run's worst deviation is `triangle:sparse:4096` at `1.000052` against a null of
`1.37e-5`, as reported.

Recomputing candidate-over-control instruction ratios from the `bench.py` `operations` blocks
reproduces both `datalog`-cohort tables exactly: split `datalog/stratify/byte` and
`/scalar` at `1.00071`, `prepare` `1.00005`, `parse/byte` and `parse/byte-null` `1.00002`,
`scan/scalar` `0.99998`, the remaining six at `1.00000`; repaired `stratify` at `0.99953`,
`prepare` `1.00003`, the two parse rows `1.00001`, the remaining seven `1.00000`. The repaired
stage retires 1,682,835,524 instructions against the control's 1,683,620,476 — the report's
785,000-instruction, 0.047 per cent win. Counter enablement is 100 per cent on all 341/342
datalog measurements and all 1,623/1,622 Rel-cohort measurements, and `failures` is empty in both
`ab.py` receipts.

**The "identical instruction for instruction" claim holds, and this audit verified it directly.**
Reimplementing the report's normalization (disassemble one symbol's address range with
`objdump -d --no-show-raw-insn --start-address/--stop-address`, rewrite an intra-function branch
target as an offset from the function start and an inter-function call target as its callee
symbol, elide RIP displacements):

| Symbol | Control `74f974c` | Split `55dab0c` | Repair `f7b0d16` |
|---|---|---|---|
| production `Demand::evaluate_counting` (0x87e6) | 7,659 insns | **identical** | **identical** |
| `Prepared::evaluate_into` (0x1f8) | 118 insns | **identical** | **identical** |
| `Prepared::propagate` (0x4a0) | 269 insns | **identical** | **identical** |
| counted `evaluate_counting` | 0x8e89, 7,898 insns | 0x8e64, 7,893 insns | 0x8e64 |

and the counted instantiation's call multiset differs in exactly one entry,
`core::panicking::panic_bounds_check` 123 → 122 (156 → 155 calls total), which is what the
report says. Note that rewriting *call* targets as offsets rather than as callee symbols makes
the production kernel appear to differ; the report's one-line description of its normalization is
therefore under-specified, and no normalizer is committed (finding 5).

**The load-pass symbol sizes reproduce**: `derivation::check_admitted_bounded`
0x14c9 → 0x12e8 → 0x13a8 and `ranked::check_admitted_bounded` 0x2858 → 0x2616 → 0x272b, in both
`closure_ballpark` and `ergodis-tools`. So do the carrier and support readings in the two
`rules-contract-properties` test binaries: **zero** out-of-line `TransitionWeight` method symbols
on either arm, three `composition_graph::propagate` instantiations on both with two sizes
identical (0x7e7, 0x79b) and one changed (0x7df → 0x7d2), `support_check` 0x2cf for both carriers
on both arms, `Prepared::support_certificate` 0xe11 on both, and `verify_support` 0x296 → 0x24f.

**The unmeasured-by-counters part is stated plainly and the reason is correct.** The report says
the grounded replay and `support::check` have no driver because those symbols are absent from
every executable in either repository, and substitutes a disassembly reading of the one release
artifact that instantiates them. The symbol evidence above confirms the substitute is adequate
for the question asked (is the inline still there), and the report does not dress it up as a
measurement.

**Replay commands cite commits and tracked files.** Every `~/.cache/ergodis/bin/...` path in the
replay block is the *output* of a `retain-bin.sh` recipe printed immediately above it at a named
revision, and the report states in so many words that each hash is "recorded as measured, never
cited: the thing to run is the retain recipe at the named revision". No cache path is offered as
sole evidence. The receipts themselves are tracked files in private `a082a07`.

**But one disassembly reading in the report is wrong, and it changes the conclusion of the
repair** — finding 1 below.

---

## Findings

### 1. CODE — high. `Admitted::pack` also lost its inline; the repair is incomplete, and the report states the opposite

The report says, in three places, that `Admitted::pack` kept its inline and therefore needs no
attribute:

> `Admitted::tuple` lost its inline; `Admitted::pack` did not. … `Admitted::pack` is emitted but
> has no call site in either binary, so it is still inlined where it is used.

> `Admitted::pack` does **not** get the attribute, because the disassembly shows it inlined at
> every site it is actually called from; giving it one would be a guess rather than a measurement.

> `Admitted::tuple` has no out-of-line symbol in either rebuilt binary, and neither `tuple` nor
> `pack` has a single call site left.

All three are false. `pack` is called out-of-line through the GOT from the *same two load passes*
as `tuple`, both before and after the repair:

```
$ objdump -d <bin> | grep -cE 'Admitted4pack17h[0-9a-f]+E\$got'   # and the same for 5tuple
binary                            tuple-GOT-refs   pack-GOT-refs
ergodis-tools-74f974c                      0                0     (control: both fully inlined)
ergodis-tools-55dab0c                      4                4
ergodis-tools-inline-55dab0c               0                5
closure_ballpark-74f974c                   0                0
closure_ballpark-55dab0c                   4                4
closure_ballpark-inline-55dab0c            0                5
```

Attributing each reference to its owning function (same normalization as §6):

```
closure_ballpark-55dab0c         pack: call ×2 in ergodis_verify::ranked::check_admitted_bounded
                                       call ×2 in ergodis_verify::derivation::check_admitted_bounded
closure_ballpark-inline-55dab0c  pack: call ×2 in ranked::check_admitted_bounded
                                       call ×1 + hoisted GOT load ×2 in derivation::check_admitted_bounded
```

and one raw site, for concreteness:

```
8a9cb: ff 15 2f e3 06 00  call *0x6e32f(%rip)   # f8d00 <..._ZN16ergodis_contract7datalog8Admitted4pack...$got>
```

The claim cannot be rescued by reading a different artifact: the two binaries the report names are
`ergodis-tools` and `closure_ballpark`, and in the other retained binaries
(`rules-contract-properties-*`, `ergodis-*`) neither accessor appears at all, because nothing
there reaches the Datalog load passes.

The source confirms `pack` is on exactly the same per-element path the report justifies `tuple`'s
attribute by: four call sites, `crates/verify/src/derivation.rs:112,131` and
`crates/verify/src/ranked.rs:227,230`, of which
`candidates[r].push(admitted.pack(admitted.tuple(fact)))` runs once per admitted fact and
`listed.chunks(arity).map(|tuple| admitted.pack(tuple))` once per listed tuple. `pack` itself is
a three-line mixed-radix fold over the tuple — exactly the shape the cross-package inlining
heuristic was expected to cover and did not.

So the split cost **two** lost inlines on the Datalog load passes, not one, and `f7b0d16`
repaired one of them. The measured 0.047 per cent win on `datalog/stratify` is real and is not
called into question; what is wrong is the report's reason for stopping there, and the claim that
nothing is left.

*Repair.* Add `#[inline]` to `Admitted::pack` in `crates/contract/src/datalog.rs`, with a
docstring of the same shape as `tuple`'s. Re-retain `ergodis-tools` with a fresh `--label` at the
new core revision and rerun the one operation that exercises the path, against the **same**
pre-split control already on disk:

```sh
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-<new-label> \
    --control ~/.cache/ergodis/bin/ergodis-tools-74f974c --rounds 5 --cpu 5 --cohorts datalog \
    --stages scan,parse,admit,lower,stratify \
    --events instructions,cycles,branches,branch-misses,page-faults,minor-faults \
    --out analysis/rel-frontend/performance-v11-<label>-datalog-55dab0c.json
```

Keep on a measured further gain, revert on a wash, and record the outcome either way. The
contract identity moves a third time, which the receipt inventory already shows costs nothing.
Then correct the three sentences above in the task report. If the decision is instead to leave
`pack` out of line, the report must say so on the true reading — that a second inline was lost
and deliberately not repaired — rather than on the false one.

### 2. PROSE — medium. `docs/verification.md` names the wrong set of default members

The paragraph rewritten by `83eec12` reads:

> The root workspace includes `ergodis`, `ergodis-contract`, `ergodis-verify`, `ergodis-rules`,
> `ergodis-modules`, `ergodis-runtime` and `ergodis-repository-native`. The first five of those
> are default members …

The manifest says otherwise:

```
$ rg -n '^default-members' Cargo.toml
3:default-members = [".", "crates/contract", "crates/verify", "crates/runtime",
                     "crates/repository-native", "crates/rules"]
```

The default members are all seven *except* `ergodis-modules`. "The first five of those" names
`ergodis-modules` (which is not one) and omits `ergodis-runtime` and
`ergodis-repository-native` (which are). The member list itself is correct; only the
default-member sentence is wrong. This is a public document, and the sentence is new in this
commit.

*Repair.* Replace with "All but `ergodis-modules` are default members, so ordinary workspace
validation exercises the leaf."

### 3. RECORD — medium. The card's Lean-audit-gate acceptance line is not demonstrated

The card's first acceptance line requires that "the Lean audit gate's Rust-side inputs … pass".
The design step plans for it — "Rebuild the library and rerun the gate as a check, no edit
expected" — but the report's "Gates run" table has no row for it, and no other section records a
run. The table does cover the native and wasm32 ABI harnesses, which is the neighbouring
acceptance clause, not this one.

*Repair.* Either run the gate's Rust-side inputs per
`~/src/othello/lean/WeightedRules/README.md` and add the row, or state in the report that it was
not rerun and why the argument stands without it (the `ergodis_module_v1` ABI and the
`lean_boundary_fixtures` example's schema are unchanged, and the example is compiled by
`cargo test --all-features`). Do not leave the acceptance line silently unaddressed.

### 4. RECORD — low. The stratify instruction count is attributed to the wrong arm

> The stratify interval is degenerate because the instruction count is deterministic: the stage
> retires 1,684,818,752 instructions per iteration on the control and about 1.19 million more on
> the candidate.

From `performance-v11-c1209-split-datalog-55dab0c.json`, 1,684,818,752 is the **candidate**
(`datalog/stratify/byte`) and the control is 1,683,620,740. The 1.19-million delta is right; the
arms are swapped, and as written the sentence implies a candidate figure of about 1,686,016,000,
which no measurement contains.

*Repair.* "…the stage retires 1,683,620,740 instructions per iteration on the control and about
1.19 million more on the candidate."

### 5. RECORD — medium. The disassembly normalizer is neither committed nor specified precisely enough to replay

The load-bearing claim of the whole performance section — the production `evaluate_counting`
instantiation being identical instruction for instruction — rests on a normalization described in
one sentence: `objdump -d -C --no-show-raw-insn` over a symbol's address range, "with branch
targets rewritten relative to the function start and RIP displacements elided". No script is
committed with the receipts in `a082a07` (its eight files are all `ab.py`/`bench.py` JSON), and
the description as written is wrong for inter-function calls: rewriting a `call` target relative
to the function start makes the two arms differ at instruction 12, because the callee sits at a
different absolute address in each binary. Replaying the claim requires guessing that calls are
normalized by callee symbol instead. This audit reproduced the claim only after making that
substitution.

*Repair.* Commit the normalizer as a small script beside the receipts (private
`analysis/datalog-comparison/` is the natural home) and cite it in the report's replay block,
stating that call targets are normalized to the callee symbol and intra-function branches to an
offset from the function start.

### 6. RECORD — low. Three load-average figures in the report do not reproduce

Recomputed from the receipts' own `load_average` blocks:

| Report says | Receipt | File |
|---|---|---|
| "this box was running at load average 5.4 throughout" (Method) | no receipt exceeds 4.11 | all four |
| "load average over the rounds was 1.3–3.3" (§2) | 1.03–1.83 (Rel) and 2.66–3.40 (datalog) | `…split-55dab0c.json`, `…split-datalog-55dab0c.json` |
| "load average 1.9–3.3" (§4, repaired datalog run) | 1.85–4.11 | `…inline-datalog-55dab0c.json` |
| "load average 1.1–1.9" (§4, repaired Rel run) | 1.14–1.92 — **reproduces** | `…inline-55dab0c.json` |

These are measurement-condition annotations and none of them changes an instruction verdict, but
they are numbers in a reproducibility report that the committed receipts contradict.

*Repair.* Quote each run's own `load_average.min`/`.max` and drop the global "5.4".

### 7. CODE — low. The receipt-level forgery test has no contract case

`tests/verifier_boundary.rs` gained a forged-`record.contract[0]` row, but
`tests/admission_pipeline.rs:168` still flips only `forged.checker[0]`, although the design step
called for a case in both. The field *is* bound — `replay_admission` copies `receipt.contract`
into the rebuilt record and `binary_composition::replay` compares by whole-record equality — so
this is a coverage gap, not a soundness gap.

*Repair.* Add, beside the existing block:

```rust
forged = admission.receipt().clone();
forged.contract[0] ^= 1;
assert!(matches!(
    replay_admission(&problem, &candidate, &forged, budget()),
    Err(AdmissionError::Receipt)
));
```

### 8. CODE — low. `sources_are_complete` checks names, not bytes, and cannot see a submodule directory

The test compares the `BTreeSet` of names in `HASHED_SOURCES` against the `BTreeSet` of
`src/*.rs` file names. Two things slip through: an entry whose name string and `include_bytes!`
path disagree (`("support.rs", include_bytes!("ranked.rs"))`) passes, and a future module written
as `src/foo/mod.rs` is a directory entry that `.filter(|name| name.ends_with(".rs"))` discards, so
it would be silently outside both the list and the check. The report notes the flat-`src/`
precondition; nothing enforces it.

Both gaps were demonstrated in the same throwaway worktree at `f7b0d16`, which was removed
afterwards. With `crates/contract/src/sub/mod.rs` created and the `support.rs` entry rewritten to
`("support.rs", include_bytes!("ranked.rs"))` — a list that hashes the wrong bytes under a name
that still matches — the test passes:

```
$ cargo test -p ergodis-contract --lib sources_are_complete
test tests::sources_are_complete ... ok
test result: ok. 1 passed; 0 failed; …
```

*Repair.* In both crates' tests, additionally assert for each listed entry that its bytes equal
`std::fs::read(Path::new(env!("CARGO_MANIFEST_DIR")).join("src").join(name))`, and fail on any
`src/` entry that is a directory.

### 9. PROSE — low. ADR 0005's unforeseen-consequence sentence is garbled

> `min_plus_transition.rs` therefore took a one-line import change, which is the single non-move
> line inside the two moved files' bodies; `finite_lowering.rs` is untouched.

`min_plus_transition.rs` and `finite_lowering.rs` did not move — they stayed in
`ergodis-verify` — and the import change is not the single non-move line in the split, since
`composition_graph.rs`, `derivation.rs`, `ranked.rs`, `support.rs` and `datalog_store.rs` all took
import retargets too. What is true is that it is the single changed line inside the two files that
the private receipts pin by hash.

*Repair.* "`min_plus_transition.rs` therefore took a one-line import change. It and
`finite_lowering.rs` are the two files the private weighted-normalization and privacy-lowering
receipts pin by hash; `finite_lowering.rs` is untouched, and the one line in
`min_plus_transition.rs` breaks the former pin."

### 10. PROSE — low. Two small internal inconsistencies in the report

- §2 of the performance section: "the largest deviation from unity in instructions is 2 parts in
  100,000 (`comment-string/scan/byte` and `comment-string/parse/byte-null` …)". Recomputed from
  `performance-v11-c1209-split-55dab0c.json`, the largest of the 56 is `prepare` at
  `1.000027`; `comment-string/scan/byte` is second at `1.000024` and the drift null
  `comment-string/parse/byte-null` third at `1.000018`. The magnitude is right, the named
  operation is not, and the null is smaller than both rather than tied with one.
- "The cut as built", non-move-lines bullet: "plus **four** files where the mirrored module names
  collide in one scope and an alias resolves it", followed by a list of **six**
  (`crates/rules/tests/{contract_properties,properties,boolean,contracts}.rs`,
  `crates/runtime/tests/{update_cost,update_properties}.rs`). Six is correct
  (`rg -l verify_grounded`), and deviation 4 says six.

### 11. RECORD — low. The docstring-demonstration row cannot be re-derived

The table showing the contract identity moving to `d4146e0a…d86baf` under "one docstring line
added above `UNRANKED`" was produced by a probe test that was removed and an edit that was
reverted; neither the probe nor the exact text of the added line is recorded anywhere, so that
hex is unreproducible. The *conclusion* is sound and does not need the probe: verify's
`HASHED_SOURCES` names only its own ten files, so no contract edit can reach it, and this audit
confirmed the checker identity is byte-identical at `83eec12` and `f7b0d16` across a contract
source change (`f7b0d16` edits `crates/contract/src/datalog.rs`; the checker identity stays
`0ea8d53f…6498` while the contract identity moves `85346c30…04b2` → `2b68f01e…4100`).

*Repair.* Drop the middle row's hex or replace the demonstration with the `83eec12` → `f7b0d16`
pair, which is a real committed instance of the same fact.

### 12. PROSE — low. The runtime guard's pass message understates what it asserts

`scripts/check-runtime-dependencies.py` prints "runtime -> core, rules, verifier" while asserting
that the closure is `{runtime, core, verifier, rules, modules, contract}`. A reader of the gate
output cannot tell that `ergodis-modules` and `ergodis-contract` are in the checked set.

*Repair.* "runtime -> core, contract, verifier, rules, modules; no reverse or default host edge".

---

## Reproduced without finding

Everything below was checked against the committed bytes, the committed receipts or a re-run, and
came out exactly as the report, the card or ADR 0005 states.

**The move itself**

1. The 316-line multiset difference between the old twelve verify sources and the new eighteen
   sources across both packages is wholly accounted for by docstrings, import retargets, the
   identity machinery, the record's second field, `RECORD_SCHEMA`, the `#[inline]`, the four
   accessor rewrites, the `check_invariance` widening and one rustfmt reflow.
2. Every `thiserror` `#[error("…")]` string is byte-identical across the split.
3. Every `MAX_*` budget and every `*_SCHEMA` constant is byte-identical; `RECORD_SCHEMA` is the
   only new one.
4. `check_invariance` is the only visibility widening in the entire diff.
5. `crates/contract/src/composition_graph.rs` carries `ProductRule`, `Limits` and the graph
   `Error` byte for byte, with no added line that is not a docstring.
6. `weight.rs` and `datalog.rs` are 100 %-similarity renames at `83eec12`; `weight.rs` is still
   byte-identical at `f7b0d16`.
7. `crates/verify/src/finite_lowering.rs` is untouched by all three commits.
8. `crates/verify/src/min_plus_transition.rs` changes exactly one line, the carrier-trait import.
9. `crates/verify/src/grounded.rs` is the lifted checker block with only `grounded.inputs`,
   `.products` and `.source_id` becoming accessor calls, plus one signature reflow.
10. `f7b0d16` touches two files: the `#[inline]` with its docstring, and `SHA256SUMS`.
11. The `#[allow(clippy::large_enum_variant)]` on `AdmissionOutcome` is the only lint annotation
    added, and it changes no behaviour or API.

**Dependencies and identities**

12. `ergodis-contract` depends on no workspace member and has no dev-dependencies;
    `ergodis-verify` gains exactly one dependency.
13. No re-export of any moved path exists in either package.
14. No stale `ergodis_verify::` path to a moved item survives in core Rust, private Rust, core
    documents, `DESIGN.md`, `scripts/` or `python/`; the one prose survivor in private
    `analysis/rel-frontend/coverage-v1.json` is the one the report declares.
15. Both crates' hashed lists name every `src/*.rs` file of their crate, `support.rs` included.
16. All five reported identity hexes recompute from committed bytes, digit for digit.
17. The checker identity moves exactly once across `db7fec6`, `83eec12`, `f7b0d16`.
18. Both `sources_are_complete` tests fail on a name-set mismatch in either direction, and both
    ran green.
19. `VerificationRecord`, `AdmissionReceipt` and `WireReceipt` each carry `checker` and
    `contract` as separate named fields; both are compared, by whole-record equality in
    `binary_composition::replay` and by an explicit clause in `admission::solve_bound_reduction`.
20. `tests/verifier_boundary.rs` forges both `record.checker[0]` and `record.contract[0]`.

**Invariants and gates**

21. No pinned digest was edited anywhere in the three core commits.
22. `tests/admission_pipeline.rs` and its `assert_ne!` historical checker pin are untouched.
23. Every changed test, example, `crates/rules/src` and `crates/runtime/src` line is an import,
    an alias, a reflow, or the new contract field — no fixture, expected value or oracle input.
24. Core `cargo test --all-features`: **1021 passed, 0 failed, 84 sections, zero FAILED** —
    the report's figure exactly.
25. `cargo fmt --all -- --check` clean in both repositories.
26. Both dependency guard scripts pass with the strings the report quotes.
27. `python/generate_evidence.py --check` clean; `SHA256SUMS` carries all nine
    `crates/contract/` paths and three spot-checked entries match the working tree.
28. `bash tests/publication-guards.sh`: **105 passed, 0 failed**, `public-lint: clean` on every
    staged and shipped tree. The lint enumerates its target with `find`, so the new crate cannot
    be silently skipped, and `.publicignore`/`.public-lint-allow`/`.publication-profile` name no
    crate path.
29. The `finite_lowering.rs` pin still verifies at `68ee2202…f0b2`; the
    `min_plus_transition.rs` pin is broken (`61390899…c2ca` pinned, `7c55b24b…afd4` actual), and
    the report states this plainly in three places — the invariants table, the deviations list and
    a dedicated section — with the reproducible justification that both receipts' `Cargo.lock`
    pins were already stale before this task.

**Comments, documents and the ADR**

30. Every added comment line in the three core commits and private `55dab0c` describes the code
    as it stands; none carries a task identifier, a `notes/` path, process narrative, measurement
    history or an agent name.
31. No task identifier appears in `docs/`, `DESIGN.md`, `README.md` or any new source.
32. ADR 0005 is Accepted, dated, answers its three open cut questions, and its account of the
    module layout, the two `Rejection` enums, the decoders, `support::derive`, `Limits`, the
    sealed carrier and the single visibility change all match the code as built.
33. Private `55dab0c` is a pure path retarget: no signature, type or body changed, and
    `tasks/tools`, `tasks/gem-hunt` and `tasks/hadamard-2092` are untouched.

**Performance**

34. All eight retained-binary sha256 values reproduce against `~/.cache/ergodis/bin/`, and the
    receipts' `arms`/`binary`/`control` blocks carry the same hashes.
35. All eighteen derivation-loop rows — ratio, interval, A/A null, cycle ratio, derived counts —
    re-derive from the receipt, as does the worst-deviation claim on `mutual:blocks:4096`.
36. Both `datalog`-cohort tables re-derive from the receipts, including the 1,682,835,524 vs
    1,683,620,476 figures and the 0.047 per cent win.
37. Counter enablement is 100 per cent on every measurement in all four bench receipts, and both
    `ab.py` receipts record zero failures.
38. The production `Demand::evaluate_counting` instantiation (0x87e6, 7,659 instructions),
    `Prepared::evaluate_into` (118) and `Prepared::propagate` (269) are identical instruction for
    instruction on all three arms, verified independently by this audit.
39. The counted instantiation goes 0x8e89/7,898 → 0x8e64/7,893 and its call multiset differs in
    exactly one entry, `panic_bounds_check` 123 → 122.
40. `derivation::check_admitted_bounded` 0x14c9 → 0x12e8 → 0x13a8 and
    `ranked::check_admitted_bounded` 0x2858 → 0x2616 → 0x272b, in both drivers.
41. No `TransitionWeight` method of either carrier has an out-of-line symbol on either arm of the
    `rules-contract-properties` pair; three `propagate` instantiations on both, two unchanged in
    size and one 0x7df → 0x7d2; `support_check` 0x2cf for both carriers on both arms;
    `Prepared::support_certificate` 0xe11 on both; `verify_support` 0x296 → 0x24f.
42. `Admitted::tuple` has no out-of-line symbol in the control, four GOT references in each split
    binary from the two load passes, and none after the repair.
43. The unmeasured-by-counters paths are stated plainly, with the correct reason (no executable
    in either repository links those symbols) and a disassembly substitute that answers the
    question asked.
44. The replay block's cache paths are all outputs of a `retain-bin.sh` recipe at a named
    revision, and the report says in terms that the hashes are measured, not cited.

**Not re-verified by this audit** (accepted on the report's record, since re-running them is out
of proportion to a read-only audit): the native C ABI harness, the wasm32 build and
`wasm_abi.mjs`, `python/generate_fixtures.py --check`, and `cargo clippy --all-targets
--all-features -- -D warnings`. `cargo fmt --check` was re-run and is clean, and the full test
suite, which covers the evidence manifest and the public lint, is green.


