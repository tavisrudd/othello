# C1191 — the direct constructor into the demand evaluator's prepared form: independent verification audit

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: COMPLETE. Written incrementally from the start of the audit.

## Scope

Target of the audit: `notes/2026-09-16-c1191-direct-constructor-report.md`, the report on the direct
constructor from the relational IR into the demand-driven evaluator's prepared form, against its task
card `notes/2026-09-16-c1191-direct-constructor.md`. Predecessors read for the state it builds on and
for the shape and rigor this audit imitates: `notes/2026-09-15-c1190-milestone-c-audit.md` and
`notes/2026-09-15-c1190-per-column-domains-audit.md`. Rules read in full before touching the code:
`~/src/ergodis-dev/PERFORMANCE.md`.

Code under audit, exactly the commits the report's table names. Core `~/src/ergodis` at `2517852`
(`Demand::from_prepared`, `datalog::admit_prepared`, the flat fact pool in `Admitted`, both checkers'
admitted-form entry points, the prepared-constructor suite and the constructor allocation
regression), which is `HEAD`. Private `~/src/ergodis-private` at `c60d335`, the five commits
`3778763`, `30cebc2`, `1c7e42c`, `8191ab7`, `c60d335`. Every diff was read in full. Both repositories
were clean at the start of the audit and are clean now; `git status --short` is empty in both.

This audit is **read-only in both repositories**: no Rust source, test, fixture or receipt was
modified, and no transient mutation was applied. Where a check needed code that does not exist in
either repository, it was written as a throwaway probe crate outside them, at
`~/.cache/ergodis/c1191-audit/probe/`, which links the core crates by path at their committed
revision and builds into its own target directory. Every working file is under
`~/.cache/ergodis/c1191-audit/`, never `/tmp`. Nothing was staged or committed anywhere except this
file in `~/src/othello`.

Measurements use the retained binaries `ergodis-tools-3778763` and `ergodis-tools-8191ab7` as
retained, never rebuilt. `8191ab7` is the measured candidate and the only later commit, `c60d335`,
adds five receipt JSON files and no code, so the retained binary and the private tip are the same
program. The `MANIFEST.tsv` timestamps corroborate the report's Arms table independently of it: the
two control arms were retained at 2026-09-15T23:35 and 2026-09-16T08:01, both before the core commit
`2517852` at 08:15, and the candidate at 08:38, after it — so the controls do carry core `3c3e7f8`
and the candidate core `2517852`, as the table says.

## Verdict

**Every record in the report reproduces, with one exception and a handful of trivial numeric slips.
No code defect was found.** All sixteen boundary bisection points reproduce exactly, in both the
default and the raised-workspace configuration, including every refusal's budget name, found value
and limit. Every A/B figure re-derives from the committed receipts to the printed digit, and my own
two-round re-runs of the `stratified` and `datalog` pairs reproduce the composed stage instruction
counts to within one part per million and the ratios to five digits. The closure SHA-256 is identical
across arms on all four cohorts. The parity replay regenerates 243 cases, 530,505 canonical bytes and
`f0e2b581…b448b40` byte-equal between native and WebAssembly, and every gate passes at the stated
counts. The independently regenerated kernel-scoped profile reproduces every symbol in the report's
table within sampling noise, including the absence of every serde symbol, of `datalog::admit`, of the
hash table inside it and of the allocator's consolidation work on the candidate.

The prepared source identity does what the card requires and more than the report's own mutations
show: it is computed by the core over a streamed canonical encoding with nothing supplied by the
caller, domain-separated from the wire identity by its own tag, invariant under reordering and
duplication of the supplied tuples, and it moved under every one of seven semantic mutations I tried,
six of which the report's three deliberate mutations do not cover. The JSON path is provably
untouched: `crates/verify/src/rule_contract.rs` is byte-identical to its pre-task revision, the one
line that computes the wire identity is unchanged, no test fixture was modified, and the whole core
suite is green.

The exception is a measurement defect: the `columns3` peak resident set in the raised-workspace
boundary table, 564 MB, was not measured under the command the table's own header states. Under
`--max-rows 16777216 --values 262144` that cohort's peak resident set is 2,140,716 KiB, a factor of
3.8 larger; 564 MB is what `--values 262144` alone gives. Nothing else in that table moves, and the
cohort's bound is genuinely unaffected by either flag, so the conclusion stands and only the figure
is from a different run.

## What reproduced

| Claim under audit | Method | Result |
| --- | --- | --- |
| Arms: repository, revision, clean tree, rustc, retain recipe, measured hashes | `sha256sum` on the three retained binaries, their `.sha256` sidecars and the `MANIFEST.tsv` rows | All three hashes match the report's table exactly; all three rows say `clean`, `rustc 1.95.0 (59807616e 2026-04-14)`, `release`, no features. The receipts carry the same hashes |
| Boundary, tool defaults: `stratified` 1,024 at 1,047,043 complement facts, refused at 1,025 by the evaluator's row capacity at layer 1 | `ergodis-tools-8191ab7 rel-lower --cohort stratified --definitions {1024,1025} --max-tuples 0` under `choom -n 1000` | Dictionary 1,024, 1,047,043 complement facts; 1,025 gives `"id":"capacity"`, budget "derived rows of one relation of one layer", layer 1, limit 1,048,576. Exact |
| Boundary, tool defaults: `columns` 1,820 at 826,738, refused at dictionary 1,822 on the lowering workspace's fact pool, 4,097 against 4,096 | Same command, `--definitions {910,911}` | Dictionary 1,820, 826,738 complement facts; 911 gives `REL0503`, budget `facts`, found 4,097, limit 4,096, stage `lower`. Exact |
| Boundary, tool defaults: `columns3` 255 at 614,082, refused at 258 on `MAX_INDEX_KEYS`, 17,173,512 against 16,777,216 | Same command, `--definitions {85,86}` | Dictionary 255, 614,082 complement facts; 86 gives `REL0503`, budget "join index key space domain^k", found 17,173,512, limit 16,777,216. Exact, and 258³ = 17,173,512 |
| Boundary, tool defaults: `aggregate` dictionary 3,959 at key set 1,365 with 930,930 filter facts, refused at key set 1,366 on the fact pool | Same command, `--definitions {1365,1366}` | Dictionary 3,959, 930,930 filter facts; 1,366 gives `REL0503`, budget `facts`, 4,097 against 4,096. Exact |
| Boundary, workspace raised: `stratified` 2,047 at 4,187,141, refused at 2,048 by `Budget::LayerTuples`, 4,197,376 against 4,194,304 | Same command plus `--max-rows 16777216 --values 262144` | Dictionary 2,047, 4,187,141 complement facts, peak RSS 1,387,680 KiB; 2,048 gives `REL0503`, budget "tuples of one layer's program", found 4,197,376, limit 4,194,304, stage `backend`. Exact |
| Boundary, workspace raised: `columns` 4,092 at 4,183,050, refused at dictionary 4,094 on `LayerTuples`, 4,195,326 against 4,194,304 | Same, `--definitions {2046,2047}` | Dictionary 4,092, 4,183,050 complement facts, peak RSS 2,724,524 KiB; 2,047 gives found 4,195,326 against 4,194,304. Exact; the report's 2.73 GB against my 2.72 is run-to-run noise |
| Boundary, workspace raised: `columns3` unchanged at 255, `aggregate` at a post-extension dictionary of exactly 4,096 with 996,166 filter facts, refused at key set 1,413 on `MAX_INDEX_KEYS`, 16,793,604 against 16,777,216 | Same, `--definitions {85,86}` and `{1412,1413}` | `columns3` identical to the default configuration, 255 and 614,082, refused on the same bound and the same numbers. `aggregate` dictionary exactly 4,096, 996,166 filter facts, peak RSS 1,852,284 KiB; 1,413 gives found 16,793,604 against 16,777,216, and 4,098² = 16,793,604. Exact. The peak RSS of the `columns3` row is not what this command gives — see defect 1 |
| The dictionary-extension rate, "about 2.9 entries per key" | Arithmetic on the two measured points | 3,959 / 1,365 = 2.900 and 4,096 / 1,412 = 2.901. Exact |
| The ×13.4, ×13.5, ×3.04 and ×6.6 factors and the ×190 on the fact ceiling | Arithmetic against milestone (c)'s 153, 302, 84 and 618 | 2047/153 = 13.38, 4092/302 = 13.55, 255/84 = 3.036, 4096/618 = 6.63, 4,194,304/22,000 = 190.6. Every factor as printed |
| A/B, five cohorts that never reach the backend: every `scan`, `parse`, `admit` and `lower` ratio, the `stratify` − `lower` nulls, the five A/A nulls, the load and the enabled fraction | `~/.cache/ergodis/c1191-audit/rederive` over `analysis/rel-frontend/performance-v6-prepared-8191ab7.json` | Every one of the twenty ratios matches the report's table to the printed digit; the composed nulls are +0.9/−1.0, −0.7/+0.9, +1.3/−1.6, +1.7/−4.2, −2.8/−2.9 instructions, which is the report's ±4; A/A nulls 1.0000013, 1.0000002, 0.9999989, 1.0000008, 1.0000018; load 2.02 to 2.36; enabled 100.00 per cent on all six events over 1,617 measurements |
| A/B, backend stage: all four cohorts' stage instructions, instruction ratios, cycle ratios, wall medians, peak RSS and A/A nulls | Same, over the four per-cohort receipts | `datalog` 1,680,329,956 / 1,690,474,760 = 0.99400, cycles 0.96864; `stratified` 168,175,532 / 323,491,619 = 0.51988, cycles 0.47000; `columns` 168,662,964 / 326,736,068 = 0.51621, cycles 0.46909; `aggregate` 59,064,703 / 136,776,315 = 0.43183, cycles 0.44332. Peak RSS −28.4, −28.7 and −10.9 per cent. A/A nulls 1.0000118, 1.0000013, 1.0000011, 0.9999855. Every figure exact; two wall figures are means rather than medians, see defect 4 |
| My own interleaved A/B, two rounds, against the two retained binaries | `bench.py --binary …-8191ab7 --control …-3778763 --rounds 2 --cpu 5 --stages scan,parse,admit,lower,stratify` on `stratified` at 128 definitions and on `datalog` | `stratified` composed candidate 168,175,594 against the receipt's 168,175,532 (0.4 ppm) and control 323,491,833 against 323,491,619 (0.7 ppm), ratio 0.51988. `datalog` candidate 1,680,329,557 (0.2 ppm) and control 1,690,475,329 (0.3 ppm), ratio 0.99400. Closure digests identical across arms in both. Enabled 100.00 per cent, load 1.29 to 1.85 |
| The closure SHA-256 is identical across arms on every cohort, and the four quoted prefixes | The four receipts' `stratify` records, and my own two re-runs | `5c455ad4…ab8101a`, `dffdcd35…e896c6fb`, `3f5c4cdd…13c39e4f`, `ec562d2c…54e314e1e`, each identical on both arms. Exact |
| The control's three `stratified` layers serialize to 748,012 bytes against the candidate's 33,281-value tuple payload, at 16,897 materialized facts | The two arms' `stratification` records in the `stratified` receipt | Control `layer_bytes` 748,012, candidate `layer_values` 33,281, `layer_facts` 16,897 on both arms, `complement_facts` 16,195 on both arms. Exact |
| The `datalog` loss: 30,162 minor faults per iteration on the candidate against the control's | The `minor-faults` counters in the `datalog` receipt and in my own re-run | 30,162.0 against 4,967.7 in the receipt and 30,162.0 against 4,968.25 in my re-run. The candidate figure is exact; the control's is 4,968, not the report's 4,971 — see defect 3 |
| Peak resident set unchanged on `datalog`, 127 MB on both arms | The same records | 127,240 / 127,592 KiB in the receipt, 127,468 / 127,664 in my re-run. Exact |
| The harness A/B moved no measured stage, and is the first receipt carrying the load average and the counter enabled fraction over 1,337 measurements | `analysis/rel-frontend/performance-v5-harness-3778763.json` | Every candidate-over-control instruction ratio within 11 ppm of unity, every A/A null within 5 ppm; enabled 100.00 per cent on all six events over 1,337 measurements each; load 1.84 to 2.49; binary `3778763` against control `b7c624d` with the hashes the report's table gives. Exact |
| Mystery ledger 5: the harness commit moves `comment-string`'s lowering stage by about eight instructions on 1.89 million, a ratio of 1.00000 to five places | Same receipt, `lower` minus `admit` | 1,888,651.6 against 1,888,644.3, a delta of 7.3 instructions and a ratio of 1.0000039. As claimed |
| Gates, core: `cargo test --all-features`, every binary including the prepared-constructor suite and the constructor allocation regression | `nix develop ~/src/ergodis --command cargo test --all-features -j 8` | Exit 0, every test binary passed, zero failures. The prepared suite is seven tests, all passing, and `the_prepared_constructor_allocates_independently_of_the_fact_count` passes |
| Gates, private: `rel_lowering` 52, `rel_frontend` 28, `rel_frontend_portability` 1, `rel_reference_eval` 19, all passing; the differential's zero disagreements | `choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private --test rel_lowering --test rel_frontend --test rel_frontend_portability --test rel_reference_eval -j 8` | 52 / 28 / 1 / 19 passed, 0 failed. Exact, and the fixture count went 51 → 52 as the report says |
| The committed independent Python oracle | `python3 tests/support/rel_closure_oracle.py --check tests/support/rel-closure-expected.json` | 18 fixtures agree |
| Parity: 243 cases, 530,505 canonical bytes, byte-equal, SHA-256 `f0e2b581…b448b40`, unchanged | `choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py --output ~/.cache/ergodis/c1191-audit/portability-audit.json` | All four figures reproduce, and the regenerated receipt differs from the committed `portability-v1.json` in exactly three fields: the two rebuilt library hashes and the source hash of `src/rel_frontend/lower.rs`, which this task edited. `canonical_sha256` and `record_summary` are identical field for field, so the report's reading — the corpus compares the lowered relational IR's canonical bytes, which this change does not touch — is right, and structurally so rather than by luck |
| Gates, private whole-package: `cargo test -p ergodis-private -p ergodis-tools`, every test binary, zero failures | `choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private -p ergodis-tools -j 8` | Exit 0; 42 test-result blocks, every one `ok`, zero `FAILED` and no compilation error. The run does drive every other lane's suite in this workspace, as the report says |
| Clippy, both repositories, and `cargo fmt --check`, both repositories | The report's two Clippy lines and two `fmt` lines | Exit 0 with no diagnostics on all four |
| The kernel-scoped profile: every symbol in the report's table, the saving's attribution, and the out-of-line calls | `taskset -c 5 perf record -q -e instructions:u -F 4000` on `rel-frontend-bench --cohort stratified --stage stratify --definitions 128 --repeat 300`, on each retained binary, read at a 0.15 per cent cut | Regenerated from scratch, share times stage instructions: `format_escaped_str` 29.7 M control and absent on the candidate (report 28.40); serde entry serialization and `itoa` 22.6 M / absent (22.07); `datalog::admit` 22.4 M / absent (22.26); the hash table and its hashers 21.9 M / absent (22.61); `Vec::push_mut` 13.1 M / absent (12.94); `malloc_consolidate`, `cfree` and `_int_free_chunk` 12.4 M / 0.3 M (12.07); `memmove` 19.2 / 11.4 (19.47 / 12.36); `memcmp` 4.21 / 2.20 (4.27 / 2.61); SHA-256 6.60 / 1.06 (6.34 / 0.92); `Demand::prepare` 2.40, `ipnsort` 2.66, `Streaming::word` 1.48, `admit_prepared` 1.30 on the candidate only (2.61, 2.54, 1.35, 1.31); `closed_world` 18.5 / 16.7, `evaluate_into` 13.2 / 13.6, `JoinIndexes::probe` 10.9 / 15.0, `RelationStore::insert` 13.4 / 11.6. Every figure within sampling noise of the report's, and the prepared boundary sums to 7.84 M against the report's 7.8 M |
| The wall-time loss diagnosis: the faults collapse with glibc's thresholds pinned and the two arms' wall times become equal | `MALLOC_TRIM_THRESHOLD_=2^30 MALLOC_MMAP_THRESHOLD_=2^30 taskset -c 5 ergodis-tools-<arm> rel-frontend-bench --cohort datalog --stage stratify --definitions 512 --repeat 40 --timings`, against the same without the variables | Unpinned, the candidate's loop minor faults are 1,206,486 over 40 iterations, exactly 30,162 per iteration, against the control's 191,573; its median iteration is 119.21 ms against 100.08. Pinned, the candidate's total falls to **2** and the control's to **281**, and the medians become 94.73 ms and 95.08 ms — equal to within 0.4 per cent. The mechanism reproduces exactly; the report's absolute 65.2 ms does not, see defect 2 |
| A single `rel-lower` invocation is not slower on the candidate | Nine alternating pairs of `taskset -c 5 ergodis-tools-<arm> rel-lower --cohort datalog --definitions 512 --max-tuples 0`, medians of the `stratified` nanosecond field | Candidate 114.6 ms against control 116.2 ms, peak RSS 127,104 against 127,644 KiB. The report's 102.8 / 106.9 ms and 126,992 / 127,568 KiB reproduce in direction, in the size of the gap and in the RSS to within half a per cent; the absolute wall figures are about ten per cent higher on my run and have no committed replay command, see defect 2 |
| The JSON path, `Demand::new`, `encode_source`, `identity_of` and every pre-existing certificate keep their identity | `git diff 3c3e7f8 HEAD -- crates/verify/src/rule_contract.rs`; the commit's file list; the one line in `admit` that computes the wire identity | `rule_contract.rs` is byte-identical to its pre-task revision. The commit touches six files and no test fixture. `admit`'s `let source_id = rule_contract::identity_of(&rule_contract::encode_source(program)?)` is unchanged, and `Admitted::fact_count` on the wire path is `program.facts.len()`, which is what the certificate's `fact_count` was compared against before. The only pinned 64-hex identity in the core tests, `tests/fixtures/parametric_certificate.json`, is untouched and its test passes |
| Claim that no caller of `Demand::source()` existed in either repository | `rg '\.source\(\)'` over both repositories' crates, src and tests | Every hit is on `ergodis_rules::Prepared` or on a runtime query type, not on `Demand`. The claim holds — and it is checked by the compiler, since the whole core suite builds against the new `Option` signature |

## The prepared source identity, probed independently

The card's constraint 2 is the sharpest thing in this task, and the report's own mutation 1 makes the
point that an identity defect is invisible to every corpus this lane has. So I probed it from outside
both repositories, with a program none of the committed tests uses: four relations (`edge`, `path`,
`seed`, `hits`), three rules including one with a constant slot and one two-atom body, and facts on
two relations. The probe is `~/.cache/ergodis/c1191-audit/probe/src/main.rs`, and all twenty-seven of
its checks pass.

**The core computes it, and the caller supplies nothing hashed by trust.** `PreparedSource` has no
hash field of any kind; `admit_prepared` builds a `Streaming` over `PREPARED_SCHEMA`, streams the
domain, the relations, the rules and the sorted deduplicated fact set through a 512-byte stack window
into SHA-256, and returns `stream.finish()`. Nothing the size of the encoding is held, which is the
reading of the card's "no intermediate buffer" that the report records as deviation 4.

**It is domain-separated, and the encoding is injective.** The tag is `finite-boolean-prepared-rules.v1`
followed by a zero byte, and it is not `rule_contract::SCHEMA`. Every variable-length field is
length-prefixed or count-prefixed — the relation name by its byte length, the rule body by its atom
count, each atom by its slot count, each relation's facts by its tuple count with the arity known
from the relation table — so the encoding is self-delimiting and no two distinct prepared sources can
line up. I tested the one boundary where a length prefix is what stands between two sources: relations
named `ab` and `c` against relations named `a` and `bc`, with everything else identical, hash
differently.

**It is a function of the tuple set.** Reversing every relation's tuples and emitting each one twice
gives the same identity; so does reversing one relation's tuples alone. That replicates the core's own
test on a different program.

**It moves on every semantic change I tried, including six the report's mutations do not cover.**
Flipping a relation's `input` flag, renaming a relation, changing a rule's constant slot from `2` to
`3`, changing one fact, widening the domain by one although no fact uses the new value, dropping a
rule, and reordering two rules all give a different identity. A permutation of one rule's body is
also a different identity and the same closure, which is worth stating plainly: the prepared identity
is of the program *as presented*, including its join order, not of the program up to equivalence.
That is the same property the wire identity has and is not a defect, but the report does not say it.

**The two routes agree on the admitted form and differ only in the identity.** For the probe's
program, `admit_prepared` and `admit` produce identical `relations`, identical `rules`, an identical
flat tuple pool, identical `(relation, offset)` fact records and an identical `fact_count` of 7, and
different `source_id`s. That is a stronger statement than the differential can make, because it
compares the structures rather than the fixed point they produce.

**Both checkers accept the prepared certificate, the closures agree, and the certificates bind only
to their own source.** On the same program the prepared plan and the wire plan return the same rows
for every relation and the same rounds, derivations, probes and candidates; `derivation::check_admitted`
and `ranked::check_admitted` establish the same relations as each other and as the wire checker; the
prepared certificate is refused by the wire plan and the wire certificate by the prepared plan; and
`Demand::source()` is `None` on the prepared plan and `Some` on the wire one.

## The recorded deviations, checked against the code

All eight are present in the code as described, and I found none present in the code and absent from
the report.

1. **The flat fact pool.** `AdmittedFact` is `#[repr(C)]` with `offset` and `relation` and `index`,
   and a `const _: () = assert!(size_of::<AdmittedFact>() == 12)` pins the stride, exactly as
   `PERFORMANCE.md`'s Tiger-style rule asks. `Admitted::tuples` is the pool and `Admitted::tuple()`
   the accessor, and the wire `admit` fills it the same way, so the per-tuple allocation is gone from
   both paths.
2. **`check_admitted` on both checkers, and the wire path admitting twice.** `derivation::check_bounded`
   and `ranked::check_bounded` still begin with `datalog::admit(program)` and then call the new
   `check_admitted_bounded`, and `Demand::verify` / `verify_ranked` hand the wire program to the
   `&Program` door whenever there is one. So a wire plan admits its source in `Demand::new` and again
   inside each checker, and a prepared plan admits it once. The asymmetry is real and is exactly as
   recorded.
3. **The two identities differ**, confirmed above and by the core's own test.
4. **The 512-byte stack window**, confirmed above.
5. **Canonical variable numbering checked, not accepted.** The `resolve` closure in `admit_prepared`
   walks the body atoms with `bind` true and the head with `bind` false, refuses a variable above the
   running `next`, and refuses a declared `variables` count no slot reaches. The core's budget test
   exercises both ends.
6. **`Budget::ProgramBytes` replaced by `Budget::LayerTuples` at `MAX_COMPLEMENT`'s value.** The
   constant is `1 << 22` and a lowering fixture asserts it equals `MAX_COMPLEMENT`. The claim that the
   bound is checked before each construct is enumerated is true of two of the three constructs — see
   defect 5.
7. **`rel-lower --values`**, present with the default `1 << 12`, and the default `--max-rows` is
   `1048576`, both as the boundary tables state.
8. **`rel_lowering::project` untouched.** Diffing the function body between `4554a52` and `HEAD` gives
   no change; the file's only edits are `name_of` and `atom_of` losing `pub(crate)` and `atom_named`
   folding away. One lowering fixture, at `tests/rel_lowering.rs:1269`, still calls it, and nothing in
   `rel_stratified.rs` does.

## Defects found

**1. The `columns3` peak resident set in the raised-workspace boundary table was measured under a
different command than the table states. Moderate; measurement.** Location: the table headed "**And
with the workspace raised** (`--max-rows 16777216 --values 262144`, both flags of the committed tool,
so these replay from this revision too)", `columns3` row, peak RSS "564 MB". Under that command the
cohort's peak resident set is **2,140,716 KiB**, a factor of 3.8 larger than the figure printed. I
attributed it by running the four flag combinations at `--definitions 85`: no flags 561,356 KiB,
`--values 262144` alone 563,728 KiB, `--max-rows 16777216` alone 2,139,432 KiB, both 2,140,716 KiB.
So the printed 564 MB is the `--values`-only run. The mechanism is that the demand evaluator's row
store is reserved eagerly from `--max-rows`, and `columns3`'s arity-three relations pay three words
per reserved row, which is why raising a capacity the cohort never uses still costs 1.6 GB. The other
three rows of that table do reproduce under the stated command — 1,387,680, 2,724,524 and 1,852,284
KiB against the report's 1.39, 2.73 and 1.86 GB — so this is the one row that does not. Nothing about
the boundary itself changes: `columns3` is refused at 258 on `MAX_INDEX_KEYS` with or without either
flag, which is the point the row exists to make. *Repair*: print the `columns3` row's peak RSS as
2.14 GB under the stated flags, or say in the row that it was taken with `--values` alone because
`--max-rows` cannot move that cohort's bound — and, either way, say that raising `--max-rows` to 2^24
by itself costs about 1.6 GB of reserved rows, which is a fact the "Remaining gaps" section about
layer memory would use.

**2. The one measured loss is diagnosed with figures that have no committed replay command, and its
absolute wall figure does not reproduce. Minor; reproducibility.** Location: the "Disposition"
section's two bullets, and the "Replay commands" block, which contains neither the pinned-threshold
experiment nor the single-invocation comparison. Everything load-bearing in the diagnosis reproduces:
with `MALLOC_TRIM_THRESHOLD_` and `MALLOC_MMAP_THRESHOLD_` at 2^30 the candidate's loop minor faults
fall from 1,206,486 to 2 over forty iterations and the control's from 191,573 to 281, and the two
arms' median iterations become 94.73 ms and 95.08 ms, equal to within 0.4 per cent — so the mechanism
is the allocator returning pages between iterations, exactly as the report says, and the instruction
ratio was not hiding a regression. What does not reproduce is the absolute figure: the report gives
"medians of about 65.2 ms over three alternating pairs each" and I measure about 95 ms on both arms,
under the only command the report's own description supports. The single-invocation comparison
reproduces in direction and in the size of the gap (114.6 against 116.2 ms, and peak RSS 127,104
against 127,644 KiB against the report's 126,992 and 127,568) but not in absolute wall time (the
report's 102.8 and 106.9 ms). *Repair*: add both commands to the replay block with their flags and
their iteration counts, and either re-measure the pinned-threshold medians at the revision or state
them as a ratio, which is the part that carries the argument.

**3. The control's minor-fault count is 4,968, not 4,971. Trivial.** Location: "The A/B: the backend
stage" and the "Disposition", both of which say "4,971 on the control". The `datalog` receipt's
`minor-faults` mean is 4,967.7 and my own re-run gives 4,968.25. The candidate's 30,162 is exact in
both. *Repair*: 4,968.

**4. The `datalog` row of the backend A/B table gives means in a column labelled "wall p50". Trivial;
internal consistency.** Location: the column "wall p50, candidate over control". The three backend
cohorts' figures are the receipts' `ns.p50`; `datalog`'s 120.4 and 100.2 ms are its `ns.mean`, whose
p50s are 120.67 and 100.27. The ratio is 1.20 either way. *Repair*: use the p50s, or label the
column as the mean for that row.

**5. "Checked against the projected total before each construct is enumerated" is true of the
complement and the filter and not of the aggregate. Minor; prose against code.** Location: recorded
deviation 6, and the doc comment on `MAX_LAYER_TUPLES` in `src/rel_stratified.rs`, which says the
same thing and adds "so the refusal carries its numbers and nothing large is built first". The
complement checks `layer_tuples + universe` at line 1478 and the filter at line 1572, both before
anything is enumerated; the aggregate calls `aggregate_over` at line 1352 and only then adds its
count and tests the bound, at lines 1390 to 1391. This is not a memory hole — an aggregate emits at
most one tuple per group of a closure the driver already holds, so nothing larger than an existing
relation can be built before the test — but the invariant as written is stronger than the code. The
refusal still carries its numbers. *Repair*: say that the complement and the filter are checked
against their projected universe before enumeration and the aggregate against its actual count after,
which is safe because an aggregate cannot exceed the closure it reads; or move the aggregate's test
in front of `aggregate_over` using the aggregated closure's tuple count as the projection.

**6. "About 6,500 instructions per materialized fact" does not divide into the figures beside it.
Trivial; arithmetic.** Location: the "Where the saving went" paragraph. The prepared side does
divide: 7.8 M over 16,897 materialized facts is 462, and the report says about 460. The wire side's
"about 120 M" over the same 16,897 is about **7,100**, not 6,500. *Repair*: 7,100, or give the
denominator the 6,500 came from.

**7. The candidate's profile carries three more libc and allocator symbols above the stated cut than
the sentence admits. Trivial; precision.** Location: "**Out-of-line calls in the candidate's loops**
… Two libc symbols appear". In my regeneration the candidate also shows `__rustc::__rust_alloc`,
`malloc` and `cfree` at 0.18 per cent each, above the 0.15 per cent cut the same section declares.
They are the per-layer setup allocations rather than calls inside a loop, which is what the sentence
means and what the allocation regression pins, so the claim is right and its wording is not.
*Repair*: "Two libc symbols appear inside the loops", and note the allocator symbols as setup with
the regression that bounds them.

**8. The pinned-threshold fault figures mix per-iteration and per-run units in one sentence. Trivial.**
Location: the "Disposition" bullet, "the candidate's faults go to 0 to 2 per iteration and the
control's to 279". My measurement at forty iterations gives 2 and 281 as run totals, which is 0.05
and 7 per iteration, so the two halves of the sentence are in different units. *Repair*: give both as
run totals with the iteration count, since that is what the harness reports.

**9. The constructor's allocation regression observes a constant rather than zero, and the report
does not say which invariant it is claiming. Minor; evidence scope.** Location: the acceptance line
"allocation regression on the constructor" and the Exactness table's "the constructor allocation
regression". `PERFORMANCE.md` invariant 1 asks a changed hot loop to ship a regression that "enters
the real loop repeatedly after setup and observes zero". The constructor is not a loop and cannot
observe zero: it allocates the plan's own row stores, steps and indexes. What
`the_prepared_constructor_allocates_independently_of_the_fact_count` asserts is that the count is
equal at 256, 512 and 1,024 facts and below 64, after entering the constructor eight times at each
size — which is the right invariant for a constructor and a genuinely stronger one than the wire
path's, whose count grows at about two allocations per fact. The evaluator's own per-derivation
zero-allocation regression is untouched by the commit and still passes. *Repair*: one sentence saying
the constructor's regression pins independence from the fact count rather than zero, and that the
zero-allocation regression it does not replace is the evaluator's.

**10. "Prepared" now names two unrelated things in one crate. Trivial; terminology.** Location: the
new `PreparedSource` / `Demand::from_prepared` against the pre-existing `ergodis_rules::Prepared`
(`crates/rules/src/lib.rs:49`), the min-plus contract plan that `crates/runtime/tests/update_cost.rs`
drives. A reader of `ergodis_rules` now meets `Prepared` and "prepared source" meaning different
things. Nothing is wrong and nothing needs renaming today. *Repair*: one line in the core module
documentation distinguishing them, or none.

## Replay commands and their outcomes

Run from `~/src/ergodis-private` unless noted. Every gate and every measurement went through
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin.

```sh
# Arms. Outcome: all three hashes and all three MANIFEST rows reproduce.
sha256sum ~/.cache/ergodis/bin/ergodis-tools-{b7c624d,3778763,8191ab7}

# Gates. Outcome: core exit 0, every binary green; private 52 / 28 / 1 / 19; oracle 18; fmt clean.
nix develop ~/src/ergodis --command cargo test --all-features -j 8      # in ~/src/ergodis
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_lowering --test rel_frontend --test rel_frontend_portability \
    --test rel_reference_eval -j 8
nix develop ~/src/ergodis --command python3 tests/support/rel_closure_oracle.py \
    --check tests/support/rel-closure-expected.json
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test \
    -p ergodis-private -p ergodis-tools -j 8      # 42 result blocks, all ok
nix develop ~/src/ergodis --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
choom -n 1000 -- nix develop ~/src/ergodis --command cargo clippy \
    -p ergodis-private -p ergodis-tools --lib --bins --tests -j 8 -- -D warnings

# Parity. Outcome: 243 cases, 530,505 bytes, byte-equal, f0e2b581…b448b40; the regenerated
# receipt differs from the committed one only in the two library hashes and one source hash.
choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output ~/.cache/ergodis/c1191-audit/portability-audit.json

# The boundary, both configurations, from the retained candidate rather than a rebuild.
# Outcome: all sixteen points exact. Script: ~/.cache/ergodis/c1191-audit/boundary.sh
B=~/.cache/ergodis/bin/ergodis-tools-8191ab7
for n in 1024 1025; do choom -n 1000 -- $B rel-lower --cohort stratified --definitions $n --max-tuples 0; done
for n in 910 911;   do … --cohort columns   --definitions $n --max-tuples 0; done
for n in 85 86;     do … --cohort columns3  --definitions $n --max-tuples 0; done
for n in 1365 1366; do … --cohort aggregate --definitions $n --max-tuples 0; done
R="--max-rows 16777216 --values 262144"
for n in 2047 2048; do … --cohort stratified --definitions $n --max-tuples 0 $R; done
for n in 2046 2047; do … --cohort columns    --definitions $n --max-tuples 0 $R; done
for n in 85 86;     do … --cohort columns3   --definitions $n --max-tuples 0 $R; done
for n in 1412 1413; do … --cohort aggregate  --definitions $n --max-tuples 0 $R; done

# The columns3 peak-RSS attribution of defect 1. Outcome: 561,356 / 2,139,432 / 563,728 / 2,140,716 KiB.
for a in "" "--max-rows 16777216" "--values 262144" "--max-rows 16777216 --values 262144"; do
    choom -n 1000 -- $B rel-lower --cohort columns3 --definitions 85 --max-tuples 0 $a; done

# Two A/B pairs at two rounds. Outcome: composed stage counts within 0.7 ppm of the receipts,
# ratios 0.51988 and 0.99400 to five digits, closure digests identical across arms.
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
for c in "stratified --definitions 128" "datalog"; do
  choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
      --binary ~/.cache/ergodis/bin/ergodis-tools-8191ab7 \
      --control ~/.cache/ergodis/bin/ergodis-tools-3778763 --rounds 2 --cpu 5 --cohorts $c \
      --stages scan,parse,admit,lower,stratify --events $E \
      --out ~/.cache/ergodis/c1191-audit/ab-$(echo $c | cut -d' ' -f1).json; done

# The kernel-scoped profile, regenerated on both arms. Outcome: every symbol of the report's
# table reproduces within sampling noise.
for arm in 3778763 8191ab7; do
  taskset -c 5 perf record -q -e instructions:u -F 4000 -o ~/.cache/ergodis/c1191-audit/audit-$arm.data \
      -- ~/.cache/ergodis/bin/ergodis-tools-$arm rel-frontend-bench --cohort stratified \
      --stage stratify --definitions 128 --repeat 300
  perf report -q -i ~/.cache/ergodis/c1191-audit/audit-$arm.data --stdio --percent-limit 0.15 --no-children
done

# The wall-loss diagnosis, which the report's replay block does not carry. Outcome: faults
# 1,206,486 → 2 on the candidate and 191,573 → 281 on the control over forty iterations, and
# medians 94.73 ms against 95.08 ms with the thresholds pinned.
for arm in 8191ab7 3778763; do
  MALLOC_TRIM_THRESHOLD_=$((1<<30)) MALLOC_MMAP_THRESHOLD_=$((1<<30)) taskset -c 5 \
    ~/.cache/ergodis/bin/ergodis-tools-$arm rel-frontend-bench --cohort datalog --stage stratify \
    --definitions 512 --repeat 40 --timings; done

# The identity probe, outside both repositories. Outcome: twenty-seven checks, all passing.
cd ~/.cache/ergodis/c1191-audit/probe && nix develop ~/src/ergodis --command cargo run --release -j 8
```

## What a repair pass must change

1. The `columns3` row's peak resident set in the raised-workspace boundary table: 2.14 GB under the
   stated flags, or a stated reason the row was taken with `--values` alone. Add the fact that
   `--max-rows 16777216` alone reserves about 1.6 GB of rows on that cohort.
2. The replay block: add the pinned-threshold experiment and the single-invocation comparison with
   their flags and iteration counts, and re-state or ratio-ise the 65.2 ms median, which does not
   reproduce.
3. Recorded deviation 6 and the `MAX_LAYER_TUPLES` doc comment: the projected-total check is before
   enumeration for the complement and the filter and after it for the aggregate.
4. Four numbers and two labels: the control's minor faults are 4,968; the `datalog` wall column is a
   mean for that row; the wire boundary is about 7,100 instructions per materialized fact, not 6,500;
   the pinned-threshold fault figures are run totals over forty iterations, not per-iteration.
5. Two sentences of scope: the constructor's allocation regression pins independence from the fact
   count rather than zero, and the candidate's out-of-line calls claim is about calls inside the
   loops, since allocator symbols do appear above the profile's cut.
6. One free strengthening the report has earned and does not take: the prepared and wire routes
   produce **identical admitted forms** — the same relations, rules, flat tuple pool, fact records and
   source fact count, differing only in the identity. That is a structural statement about the
   construction, where the differential can only compare fixed points, and it is what mystery ledger
   item 6 is asking for.
