# C1192 — the sparse join index and the exact crossover policy: independent verification audit

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: COMPLETE. Written incrementally from the start of the audit.

## Scope

Target of the audit: `notes/2026-09-16-c1192-sparse-join-index-report.md`, the report on a second
addressing kind for the demand evaluator's join index and membership test with a measured selection
policy, against its task card `notes/2026-09-16-c1192-sparse-join-index.md`. It also covers the
C1188 derivation-loop `memmove` removal taken inside that task. Predecessors read for the shape and
rigor this audit imitates: `notes/2026-09-16-c1191-direct-constructor-audit.md` and
`notes/2026-09-15-c1190-milestone-c-audit.md`. Rules read in full before touching the code:
`~/src/ergodis-dev/PERFORMANCE.md`.

Code under audit, exactly the commits the report's table names. Core `~/src/ergodis`: `84ed62c`,
`d0a0ef3`, `a1c6767`, `6ab0dd5`, `24e399e`, the last of which is `HEAD`. Private
`~/src/ergodis-private`: `25cf4ed`, `6bfe187`, `f2804c4`, `1dfc6ed`, `4bcbc10`, `d2b1940`,
`b7921a0`, `8881837`, `8f27cb1`, `f12e27b`, `b46572e`, `8d9c5bd`, the last of which is `HEAD`. Every
diff was read; `b7921a0` is an empty commit that names a core pin and changes no file. Both
repositories were clean at the start of the audit and are clean now.

This audit is **read-only in both repositories**: no Rust source, test, fixture or receipt was
modified, and no transient mutation was applied to either tree. The two deliberate mutations were
run against a throwaway copy of the core exported with `git archive HEAD` into
`~/.cache/ergodis/c1192-audit/mutate/`, whose `.cargo/config.toml` points at its own target
directory so the shared one was untouched; that target was deleted afterwards. Every working file is
under `~/.cache/ergodis/c1192-audit/`, never `/tmp`. Nothing was staged or committed anywhere except
this file in `~/src/othello`.

Measurements use the retained binaries as retained, never rebuilt. All nine executables the report
names hash exactly as it records them, including `c1188probe-d2b1940` being byte-identical to
`closure_ballpark-b7921a0`.

## Verdict

**Every ratio, count, digest, boundary and gate in the report re-derives, and no code defect was
found. Two measurement records are wrong, and both are records rather than results.** All 1,394
ratio, interval, null and per-arm values across the seven `ab.py` receipts recompute **bit for bit**
from their raw `.jsonl` sidecars; every stage ratio, composed instruction count, peak resident set
and closure digest in both frontend tables reproduces to the printed digit from the nine `bench.py`
receipts; all sixteen boundary bisection points reproduce exactly, including each refusal's budget
name, found value and limit; all six Soufflé cases' wall, task-clock, instruction and resident-set
figures reproduce exactly from the receipts, and my own single-case replay agrees as a tuple set with
both Soufflé arms with both independent checkers verifying. My own re-runs reproduce the
derivation-loop A/B to 66 parts per million, the backend A/B to 10 parts per million with the
`dffdcd35…` closure digest identical across arms, and the three kernel-scoped profiles within
sampling noise, including that the loop's last out-of-line call is gone after C1188. Both deliberate
mutations fail, and each fails exactly the one test the report says is load bearing.

The two measurement defects are: **the reach table was never re-run at the shipped policy**, so one
of its rows records an addressing kind and a resident set the shipped evaluator does not produce
(`mutual` at the `blocks` density and N = 4,096 selects the direct counting-sorted index, not a
sparse one, and costs 539,468 KiB rather than the printed 464 MB); and **the native/WASM parity
digest has moved** from C1191's `f0e2b581…b448b40` to `349333d4…3f652ab`, because this task edited
`src/rel_frontend/lower.rs` and `src/rel_frontend/lower/passes.rs`, which is exactly what the parity
corpus covers — so the committed `portability-v1.json` is stale and remaining gap 2's reasoning,
which is about the evaluator, does not cover the front-end edit the task also made. Parity itself
holds: 243 cases, 530,505 canonical bytes, native and WebAssembly byte-equal.

The one policy constant a cycle ratio decides survives re-measurement in its bracket — my five-round
re-run puts the crossover between a density of 32 and a density of 64, where the report puts it — but
its endpoint magnitudes do not reproduce to the precision the report claims, and the report's own
supplementary cache set was never run on that pair. I ran it, and it supports the report's mechanism
with counted events for the first time: at the crossover the sparse arm issues 0.368 of the direct
arm's `cache-references` and 0.381 of its `L1-dcache-load-misses`, with A/A nulls of 1.009 and 0.986.

## What reproduced

| Claim under audit | Method | Result |
| --- | --- | --- |
| Arms and every retained binary: name, revision, rustc, measured sha256 | `sha256sum` on the nine executables against `~/.cache/ergodis/bin/MANIFEST.tsv` and the report's two tables | All nine hashes match exactly, including `c1188probe-d2b1940` = `closure_ballpark-b7921a0` = `08b4884…7063d3`. All rows carry rustc 1.95.0 (59807616e 2026-04-14), release, no features. Two rows say `dirty` where the report says clean — see defect 8 |
| Controls retained before the first source change | `MANIFEST.tsv` timestamps against `git log --date=iso-local` | `ergodis-tools-e0e7331` 09:48:24 and `closure_ballpark-e0e7331` 10:39:07, both before core `84ed62c` at 11:07:37 and private `25cf4ed` at 11:26:41. Exact |
| Every A/B ratio, interval, A/A null and per-arm mean in all seven `ab.py` receipts | `~/.cache/ergodis/c1192-audit/rederive.py`, which rebuilds the two-point per-iteration differences, the paired geometric-mean ratio and its t-interval from the raw `.jsonl` alone | 1,394 compared values, **worst relative deviation 0.000e+00** on six of the seven receipts. The seventh differs only on the one point that refused — see defect 9 |
| The direct-path table: six cohorts' instruction and cycle ratios, intervals, nulls, per-evaluation instruction counts, evaluation medians, peak resident sets | Same, over `ab-2026-09-16-c1192-direct.json` | Every figure exact: 0.95274 / 0.95251 / 0.90848 / 0.90665 / 0.98201 / 0.96163 with nulls 0.9999964 to 1.0000017; 45.25 M / 43.11 M through 5,013 M / 4,545 M; 180 measurements, 100.00 per cent enabled on all six events, load 2.835 to 4.839 |
| That the direct path is compared with itself: every join index direct and every membership a bitmap on those six cohorts | The receipts' per-cohort `addressing` block | All six select `direct: true` on every index and `bitmap: true` on every relation that grows. Exact |
| The work-count claims behind the mechanism: dense closure 33.6 M candidates against 328 K probes, same generation sparse 261 K against 261 K | Same receipt | 33,619,968 / 327,680 and 261,681 / 260,737. Exact |
| Frontend and stratified backend at `d2b1940`: `scan`, `parse`, `admit`, `lower`, the composed backend stage, cycles, peak RSS, closure digests | `~/.cache/ergodis/c1192-audit/frontend.py` over the five `performance-v7-*-d2b1940.json` receipts | Every one of the 29 figures matches to the printed digit: stage 0.99516 / 0.99433 / 0.99432 / 0.99499, cycles 1.0138 / 0.9935 / 1.0039 / 0.9953, digests `5c455ad4…`, `dffdcd35…`, `3f5c4cdd…`, `ec562d2c…` identical across arms |
| The same four cohorts after C1188 at `f12e27b` | Same, over the four `performance-v8-*` receipts | Stage 0.95739 / 0.98131 / 0.98134 / 0.98427, cycles 0.9670 / 0.9983 / 0.9902 / 0.9856, all four digests unchanged, 1,430 measurements at 100.00 per cent, load 2.79 to 5.91. Exact, and scan/parse/admit stay within 148 ppm of unity as the report says |
| My own backend A/B, two rounds, retained binaries | `bench.py --binary …-f12e27b --control …-e0e7331 --rounds 2 --cohorts stratified --definitions 128` | Composed candidate 165,033,252 against the receipt's 165,033,247 (0.03 ppm) and control 168,175,609 against 168,175,610; ratio 0.98132 against 0.98131. Closure digest `dffdcd35…` identical across arms |
| My own derivation-loop A/B, two rounds | `ab.py --a …-e0e7331 --b …-d2b1940 --mode full --rounds 2` on `closure:dense:512` and `samegen:sparse:1024` | 0.90659 against the report's 0.90665 (66 ppm) and 0.98200 against 0.98201 (10 ppm); derived counts identical; A/A nulls within 7 ppm of unity |
| The C1188 table: eight cohorts at 0.893 to 0.895 instructions and 0.71 to 0.92 cycles | `rederive.py` over `ab-2026-09-16-c1188-memmove.json` | 0.89459 / 0.89458 / 0.89473 / 0.89473 / 0.89392 / 0.89431 / 0.89486 / 0.89308 and cycles 0.7904 / 0.7715 / 0.7100 / 0.7065 / 0.7653 / 0.7879 / 0.7190 / 0.9220. Exact, bit for bit |
| The cache-event table: L1 loads per evaluation, all four ratios and all four A/A nulls, and which structure is sparse on each cohort | `rederive.py` and the receipts' `addressing` blocks | Every figure exact, including 1.285 G → 1.072 G at 0.8343 [0.8291, 0.8395] with a null of 1.0031, and `cache-misses` nulls of 1.07, 1.07 and 1.91. The sparse selections are as described: a `2^32` membership with 16,777,216 slots, a `2^26` static index with 122,880, a `2^24` dynamic index with 262,144 |
| The membership crossover, eleven points: instruction ratios, cycle ratios, A/A nulls, densities | `rederive.py` over the two membership receipts, and arithmetic on key space over row bound | All 33 figures exact; the densities 1, 4, 16, 64, 256, 16, 64, 256, 1,024, 512, 2,048 all divide out. The `SparseMembership` arm leaves every index direct, so this comparison really does move one structure |
| The static-index crossover, four points at density 273 | Same | 1.3916 / 1.3919 / 1.3920 / 1.3920 and cycles 2.0745 / 2.4254 / 2.1495 / 2.1635. Exact, and 2^24 / 61,440 = 273.07 |
| The dynamic-index crossover, seven points, and the bracket that sets `DIRECT_INDEX_DENSITY` | Same, plus my own five-round re-run of five of the densities | Every receipt figure exact. My re-run confirms the bracket — direct ahead at 32, behind at 64 — but not the endpoint magnitudes; see defect 3 |
| Soufflé, six cases: wall ratios with intervals, interpreter ratios, task-clock ratios, instruction counts, peak resident sets, the phase decomposition, tuple-set agreement | The two `results-2026-09-16-blocks*.json` receipts | Every figure exact, including 3.244 [2.960, 3.556] and 0.984 [0.866, 1.118]; instructions 400 / 423 / 801 M and 6,654 / 7,079 / 12,741 M; the phase table 123.2 / 5.7 / 2.8 / 1.1 / 132.8 ms and 21.3 / 5.7 / 2.7 / 1.0 / 30.7 ms; `souffle_agrees` and `interp_agrees_with_compiled` true on all six |
| My own Soufflé replay, one case, three rounds | `compare.py --bin …-b7921a0 --harness-args "--max-rows 1100000" --sizes closure:blocks:4096` | Tuple sets agree, interpreter equals compiled, both checkers verify; instructions 386 / 423 / 801 M identical to the receipt; wall ratio 1.017 [0.688, 1.505], which contains the report's 0.984 |
| The reach table's derived counts, refusals, and every kind and resident set except one row | `~/.cache/ergodis/c1192-audit/reach.py` on `closure_ballpark-b7921a0` and again on `closure_ballpark-1dfc6ed` | Eleven of twelve rows reproduce on both binaries: 15,679,566 / 4,194,304 / 15,787,097 / 65,536 / 262,144 / 1,048,576 / 983,040 / 131,072 / 2,097,152 derived, both `Budget` refusals, the `2^32` sparse membership at 2,097,152 slots, the `2^24` sparse dynamic index at 131,072 slots. The twelfth is defect 1 |
| The old ceiling, measured on the control | `closure_ballpark-e0e7331 --evaluator demand --program closure 65536 sparse` | `{"error":"Budget"}` with no `prepare_ns` and no addressing block, so the refusal is at admission before any evaluation, as the report says |
| The boundary table: four largest dictionaries, four refusals with budget name, found value and limit, the materialized counts, the peak resident sets, both checkers | `ergodis-tools-d2b1940 rel-lower` at the eight `--definitions` the replay block names, under `choom -n 1000` | `stratified` 2,047 at 4,187,141 complement, refused at 2,048 on "tuples of one layer's program" 4,197,376 against 4,194,304; `columns` 4,092 at 4,183,050, refused at 4,094 on 4,195,326; `columns3` 483 at 4,173,200, refused at 486 on "complement facts of one negated relation" 4,251,528 against 4,194,304 and 162³ = 4,251,528; `aggregate` dictionary 5,934 with base 4,911 at key set 2,046 and 2,092,035 filter facts, refused at 2,047 on 4,196,350. Peak RSS 1,386,664 / 2,724,276 / 3,138,432 / 2,306,496 KiB against the printed 1.39 / 2.72 / 3.14 / 2.31 GB. `verified`, `ranked_verified` and `checkers_agree` true on all four. **Every figure exact** |
| Gates, core: 80 test binaries, zero failures, including `demand_sparse` and the derivation allocation regression | `nix develop . --command cargo test --all-features -j 8` | Exit 0, 80 `test result: ok` blocks, zero failures |
| Gates, private: 42 test binaries, zero failures, driving `rel_lowering`, `rel_frontend`, `rel_frontend_portability` and `rel_reference_eval` | `choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private -p ergodis-tools -j 8` | Exit 0, 42 `test result: ok` blocks, zero failures; all four named suites ran |
| The C1189 differential at zero disagreements | `cargo test -p ergodis-private --test rel_reference_eval -- --nocapture --test-threads 1` | 19 passed, 0 failed; 400 aggregation, 400 comparison, 1,200 generated, 120 module-shadowing and 600 negation programs all accepted with no disagreement. The near-miss decomposition has moved since both prior audits — see finding 15 |
| Clippy and `cargo fmt --check`, both repositories | The report's four commands | Exit 0 with no diagnostics on all four |
| Certificate agreement between the two addressing kinds, and both checkers on the sparse path | Reading `crates/rules/tests/demand_sparse.rs` and running it | `run()` evaluates, then asserts `derivation::check` returns rows equal to the evaluator's for every relation and that `ranked::check` accepts; `agrees()` compares work counts, rows and serialized certificate **bytes** across `Auto`, `Direct` and `Sparse`, on both fixtures, on the generated closure family at six domains and two row bounds each, on a constant-key-column program, and on an arity-three program with repeated variables. The claim is exactly what the code asserts |
| The two deliberate mutations are load bearing | Delete each `VERIFY` guard in `Demand::join` in a `git archive` copy and rerun `demand_sparse` | Baseline 8 passed. Dropping the `OP_CONST` comparison: 7 passed, 1 failed, `a_constant_key_column_is_compared_against_a_colliding_row`. Dropping the `OP_KEY` comparison: the same single failure. Both mutations are caught, and only that one test catches them, which is the lesson mystery ledger item 4 records |
| Zero allocations entering the derivation loop repeatedly, under each of three policies | Reading `crates/rules/tests/allocation.rs` and running it | `repeated_demand_evaluation_has_no_allocation` loops over `Policy::Auto`, `Policy::Direct` and `Policy::Sparse`, enters `evaluate_into` 100 times under each with the counting allocator armed after setup, and asserts the count is 0. Passes |
| The kernel-scoped profile, three arms, and that the loop's only out-of-line call is gone after C1188 | `taskset -c 5 perf record -q -e instructions:u -F 4000`, regenerated from scratch on all three retained binaries | Control 81.71 / 17.04 / 0.72 / 0.27 against the report's 81.53 / 17.29 / 0.67 / 0.25; candidate 76.06 / 22.56 / 0.80 / 0.29 against 76.55 / 22.14 / 0.73 / 0.30; after C1188 **98.36 / 0.87 / 0.34 / 0.11** against 98.36 / 0.90 / 0.33 / 0.11. Every symbol within sampling noise, and no allocator, formatting, panic, trait-object or hash-table symbol appears on any arm at the 0.1 per cent cut |
| `MAX_WORKSPACE_BYTES` is a reachable, named refusal and `workspace_bytes()` is the figure checked | Reading `the_workspace_byte_ceiling_is_a_refusal` and `Demand::workspace` | The test builds 40 relations of arity four over `MAX_DOMAIN`, asserts `workspace_bytes() > MAX_WORKSPACE_BYTES` and `workspace()` gives `Error::Budget`, then re-prepares the same program at a row bound of 1,024 and takes a workspace. `workspace()` checks exactly `self.workspace_bytes()`. As described |
| No silent `u32` overflow anywhere a `2^32` universe reaches | Read every `pow`, `as u32` and `domain^arity` site in `crates/verify` and `crates/rules`; ran the test that drives it | Keys are `u64` end to end: `key_of` returns `u64`, `Demand::power` and `datalog::universe` are `checked_pow(…).unwrap_or(u64::MAX)`, and `JoinIndexes`' key space is `checked_pow` too. The checkers' `u32` arrays are gated by `DIRECT_LIMIT = 2^26`, so a `2^32` universe takes the sorted `u64` key array. `demand_sparse::a_universe_above_the_bitmap_ceiling_evaluates` runs a closure over `MAX_DOMAIN` with keys up to `2^32 − 1` and both checkers return the right 256 tuples. The two remaining unchecked `pow` sites are in the grounded `rule_contract` path, where arity is capped at three and `MAX_SCALARS` is tested after every add |
| The sparse probe loops are correct under full tables, wraparound and duplicate keys | Read `run`, `join`, `emit`, `index_rows`, `sorted` and `table_slots` | There is no wraparound to get wrong: both sparse structures chain rather than open-address. `table_slots(capacity)` is the smallest power of two at least the capacity, so the load factor never exceeds one and a full table is a long chain, not a failure. Duplicate keys share a bucket and are separated by the per-row key comparison in `join::<true, _>`; duplicate **tuples** cannot be inserted twice because `emit` walks the membership chain and returns early. An empty sorted index has no keys, `partition_point` returns 0 and `keys.get(0)` is `None`. A key mask of zero gives a key space of one and a one-entry index. `MODE_FULL` breaks out of an ascending CSR or sorted bucket and tests every element of a descending chain, which is the risk the Fermi named and the code gets right |
| The kind is a run constant decided once, with no per-probe branch | Read `evaluate_into`, `run`, `join`, `emit` | `evaluate_into` dispatches `self.run::<KIND, BITMAP>` in a ten-arm match **at step entry**, outside the delta loop; `run` is `#[inline(always)]` and matches on the const parameter; `join::<VERIFY, BITMAP>` takes a literal at each call site and `emit::<BITMAP>` likewise. `step.kind` is never read inside the delta loop. The pre-existing `if index.offsets.is_empty()` test inside the per-delta-row loop is gone, which is the mechanism the report credits for the direct path's own saving |
| Tiger records with asserted strides | Read the two `const _: () = assert!` sites and diff `Step` against `2517852` | `Op` is `#[repr(C)]` with `size_of == 8 && align_of == 4`; `Step` is `#[repr(C)]` with `size_of == 128 && align_of == 4`, unchanged from before the task because the new `kind` and `head_bitmap` fields fit inside the existing padding. The sparse structures are plain `Vec<u32>` bucket heads and a `next` column with no record type of their own. The requirement is met; the report never mentions it — see finding 16 |
| The two mirrored refusals are gone from the private lowering close and the stratified backend | `git show 25cf4ed -- src/rel_frontend/lower.rs src/rel_frontend/lower/passes.rs src/rel_stratified.rs` | `Budget::Universe` and `Budget::IndexKeys`, the constants `MAX_UNIVERSE` and `MAX_INDEX_KEYS`, the universe check in `close`, the two-atom index-key loop in `close` and the whole re-check block in `rel_stratified::evaluate` are all deleted. `rel_stratified` now prepares through `from_prepared_bounded(…, max_rows, Policy::Auto)` and maps `workspace()`'s `Error::Budget` to `LayerCapacity`. As described |
| The eleven recorded deviations | Each against the code | All eleven are present as described. I found no deviation present in the code and absent from the report. Deviation 1's consequence is under-stated — see defect 5 |

## Defects found

**1. The reach table was never re-run at the shipped policy, and one of its rows records a kind the
shipped evaluator does not choose. Moderate; measurement.** Location: the "Reach: the closure and
same-generation families" table, whose header says "Every row is the candidate
`closure_ballpark-1dfc6ed`", and specifically its `mutual` / `blocks` / 4,096 row, printed as "index
sparse, key space 2^24" at "464 MB". That binary carries the core at `d0a0ef3`, before `6ab0dd5` set
the policy from the measurement: it has `DIRECT_INDEX_DENSITY = 32` with no distinction between an
index over a relation that grows and one over an input relation, and a `DIRECT_BITMAP_DENSITY = 96`
that no longer exists. Under the shipped policy a static index has no density rule at all — the
ceiling decides alone — so `mutual`'s index over `edge`, whose key space is exactly `2^24` and
therefore exactly `MAX_DIRECT_KEYS`, is **direct**. Measured on `closure_ballpark-b7921a0`:
`direct: true`, `slots: 16,777,216`, peak resident set **539,468 KiB**, against `1dfc6ed`'s
`direct: false`, `slots: 61,440`, 475,524 KiB. The 63,944 KiB difference is the 2^24-entry `u32`
offsets array, which is the whole of the effect. Every other row of the table gives the same kind and
the same resident set on both binaries, so this is the one row that moved. The report's own
"Every retained control" table calls `closure_ballpark-1dfc6ed` a "superseded candidate; its A/B was
re-run at `d2b1940`" and does not say that the reach table was not re-run with it. *Repair*: re-run
the reach table on `closure_ballpark-b7921a0`, correct that row to "index direct, key space 2^24" at
539 MB, and say in the table header which binary and which policy revision each row is from. The row
carries no reach claim either way — 2^24 is exactly at the retired `MAX_INDEX_KEYS`, which accepted
it — and the `mutual` at 8,192 row above the ceiling is the one that does.

**2. The native/WASM parity digest has moved and the committed parity receipt is stale. Moderate;
measurement.** Location: remaining gap 2, "The native/WASM parity replay was not re-run … C1191's
argument that the parity corpus compares the lowered relational IR and is structurally downstream of
anything an evaluator does still holds, but the hash is not re-recorded here." I re-ran it:
243 cases, 530,505 canonical bytes and native/WebAssembly byte equality all hold, but
`canonical_sha256` is **`349333d4a4cc34a8ef8b64b5f68cdd127b967ff24d538de426eba28793f652ab`** against
the committed `analysis/rel-frontend/portability-v1.json`'s `f0e2b581…b448b40`. The regenerated
receipt differs from the committed one in exactly four fields: the two rebuilt library hashes and the
source hashes of `src/rel_frontend/lower.rs` and `src/rel_frontend/lower/passes.rs` — the two files
`25cf4ed` edits. `record_summary` and the decoder negative controls are identical field for field.
So the argument is sound about the *evaluator* and does not cover the *front-end* edit this task also
made: removing two `Budget` variants and two refusals from the closing pass changes the canonical
bytes the parity corpus compares. *Repair*: regenerate `portability-v1.json` and record the new
digest, or state in the gap that the digest is expected to move because the task edits the lowering
pass and give the new value. The parity property itself is intact.

**3. The crossover's cycle endpoints do not reproduce to the precision the report claims, and the
supplementary run that would settle the mechanism was never taken on that pair. Minor; measurement.**
Location: "The crossover, measured", the `cycle` table and the paragraph beginning "**The crossover
in cycles is between a density of 32 and a density of 64**: the direct kind is ahead by 5.1 per cent
at 32 and behind by 1.6 per cent at 64." My own five-round re-run of the same binary, arms and cohort
puts those two points at **1.0303** and **0.9669** — direct ahead by 3.0 per cent at 32 and behind by
3.3 per cent at 64. The bracket is confirmed and `DIRECT_INDEX_DENSITY = 48` stays inside it, and the
instruction ratios reproduce to five decimals (1.04611 against 1.04612, 1.05155 against 1.05156), so
the conclusion stands. What does not stand is the precision argument: the report defends the band by
noting that "the cycle A/A nulls in these runs are within 2 parts per 10,000 of unity … so the 0.974
to 1.051 band that brackets the crossover is separated from unity by more than the noise floor." An
A/A null bounds within-run noise between two adjacent measurements; it says nothing about
reproducibility between runs taken hours apart, and between-run drift here is about two percentage
points on a band 6.7 points wide. The playbook's rule is to count events rather than argue from a
timing ratio, and the report's own supplementary cache set was run only on C1188, not on the
crossover. I ran it on the crossover pair, five rounds, and it is the first counted-event support the
mechanism has: at a density of 32 the sparse arm issues **0.3677** of the direct arm's
`cache-references` (A/A null 1.009) and **0.3805** of its `L1-dcache-load-misses` (null 0.986) while
issuing 1.027 of its L1 data loads; at 64 the same figures are 0.3554, 0.3619 and 1.033. That is the
`fill(NONE)` over `2^24` words showing up as memory traffic, exactly as the report argues from cycles
alone. *Repair*: commit that cache run as a receipt beside the others, state the crossover endpoints
as a reproducible band rather than two figures to one decimal, and replace the A/A-null sentence with
the counted-event one.

**4. The `cycle` crossover moves three join indexes, not one. Minor; measurement scope.** Location:
"Both arms are the **same binary** with the kind of one structure forced", and the `cycle` table it
introduces. `Policy::SparseIndexes` forces every join index, and `cycle`'s plan has three: `edge` on
column 0 (static, key space 4,096), `path` on column 1 (grows, key space 4,096) and `path` on both
columns (grows, key space `2^24`). The report attributes the crossover to the third. The receipts
show all three flipping, and the two small ones flip the *wrong* way for the sparse arm: their sparse
tables are sized from the caller's row bound, so at the crossover point the second index goes from
4,096 direct slots to 262,144 sparse ones. The confound is small on the reset side — about 258 K extra
words against the 16.5 M the large index saves, 1.6 per cent of the effect — and unquantified on the
instruction side, and it biases the measurement toward choosing direct, so the shipped constant is
conservative rather than wrong. But "one structure's kind forced on each arm" means one structure
*class*, not one index, and the constant the policy applies per index is not measured on one index.
*Repair*: say that the sweep moves all three of `cycle`'s indexes and give the reset-word arithmetic
that bounds the other two's share; or add a `--index` selector that forces one index by key space.

**5. "A program the evaluator accepted before makes exactly the same choices" holds only at the
default row bound. Minor; prose against code.** Location: the Status paragraph and "What replaced the
two refusals", which calls it "the strongest available form of 'the direct path does not move'", and
the doc comment on `MAX_DIRECT_KEYS`. Before the task, `Demand::new` refused a key space above
`MAX_INDEX_KEYS` and `workspace_bounded(max_rows)` took the row bound, which the index kind did not
read. Now `Policy::Auto` makes a growing relation's index sparse when `keys > 48 · capacity`, and
`capacity = min(domain^arity, row_bound)`. At `MAX_ROWS` the density is at most one for every index
the ceiling allows, so the claim is exactly true for `Demand::new` and `from_prepared`, and it also
holds at every bound the Rel route uses. It is false for a caller that supplies a bound below about
`keys / 48`, and the report's own reach table contains such a case: `cycle` at N = 4,096 with
`--max-rows 100000` selects a sparse index for a key space of `2^24` that the old evaluator accepted
and addressed directly. Nothing observable changes — the certificates are byte-identical either way —
but the sentence as written is stronger than the code. *Repair*: "a program the evaluator accepted
before at the default row bound makes exactly the same choices", and note that a caller-supplied bound
below `keys / DIRECT_INDEX_DENSITY` is where the policy now differs.

**6. "0.7 to 10.0 ms to check" are certificate emission times, not verification times, and neither is
inside the compared process. Minor; measurement.** Location: the Soufflé section's closing sentence,
"Ergodis also emits and verifies a certificate (1.3 to 24.0 MB, 0.7 to 10.0 ms to check), which
Soufflé does not." The byte figures are right: `certificate_bytes` is 1,281,462 and 24,035,494. The
time figures are `certify_ns`, the emission, which runs 0.74 to 9.95 ms. Independent verification is
`verify_ns` at **36.4 to 619.0 ms** and `ranked_verify_ns` at 35.7 to 711.8 ms, fifty times larger.
Separately, the wall ratios the section reports come from `compare.py`'s `--process` arm, which
`compare.py`'s own header describes as "read facts, admit, evaluate once, write CSV" — it emits no
certificate at all, so neither cost is inside the 0.98-against-compiled-Soufflé figure. *Repair*:
"1.3 to 24.0 MB, 0.7 to 10.0 ms to emit and 36 to 619 ms to check independently, neither of which is
inside the process the wall ratios compare."

**7. The `4bcbc10` frontend receipts do not "agree to the printed digit". Minor; prose.** Location:
"the same five runs at `4bcbc10`, the revision before the policy constants were set, are committed
beside them and agree to the printed digit on every instruction ratio." Recomputed from those
receipts, the four backend stage ratios are 0.99538 / 0.99442 / 0.99443 / 0.99513 against
`d2b1940`'s 0.99516 / 0.99433 / 0.99432 / 0.99499 — they differ in the fourth decimal, by up to 2.2
parts in ten thousand, and the printed figures are five-decimal. The scan, parse, admit and lower
ratios differ in the sixth decimal against six printed. The conclusion the sentence supports — that
setting the policy constants moved nothing on these cohorts — is right; the wording is not.
*Repair*: "agree to within two parts in ten thousand on every stage ratio".

**8. `closure_ballpark-b7921a0` was retained from a dirty tree, and the core revision of every arm is
recorded nowhere but the report. Minor; provenance.** Location: "**Every retained control**, all
through `../ergodis-dev/scripts/retain-bin.sh` inside `nix develop` of the core checkout, **from a
clean tree**", and "The control for the next A/B", which says `closure_ballpark-b7921a0` was
"retained from a clean tree at `ergodis-private` `b7921a0` with core `ergodis` `24e399e`". Its
`MANIFEST.tsv` row says **`dirty`**, as does `c1188probe-d2b1940`'s, which the report does declare.
`retain-bin.sh` sets that flag from `git status --porcelain` of the crate directory, so something was
uncommitted in `ergodis-private` at 12:26:00; PERFORMANCE.md's evidence rule asks for the dirty flag
"with the foreign files named" and neither the manifest nor the report names them. Separately, the
core is a path dependency and no manifest row records its revision, so "with core `ergodis`
`24e399e`" is an assertion the manifest cannot corroborate for any arm; the only corroboration is that
`b7921a0` is byte-identical to the probe the report says was built from a dirty tree after C1188.
*Repair*: mark that arm dirty in the report's table with the files that were uncommitted, or re-retain
it from a clean tree; and have `retain-bin.sh` record the path-dependency core revision, which would
make the whole arms table self-evidencing.

**9. A twelfth crossover point refused, was summarized anyway, and is not disclosed. Minor;
measurement and harness.** Location: the membership crossover table ("eleven density points") and the
method paragraph "a cohort whose arms disagree on any of them is reported as a failure and is not
summarized". `ab-2026-09-16-c1192-crossover-membership.json` contains a twelfth row,
`closure:blocks:16384` at `--max-rows 65536`, with `"error": "Budget"` — that cohort derives 262,144
rows against a bound of 65,536 — and a summarized instruction ratio of 1.0359 with an interval of
[0.00029, 3741.45] and an A/A null of 3.56. It is the one row of the seven receipts my re-derivation
does not reproduce as a meaningful number, and it is the only reason that receipt's worst deviation is
not zero. The report is right to leave it out of the table, and wrong not to say that one sweep point
refused. On the harness: `ab.py` appends every row to `results` whatever it found, then raises
`SystemExit` at the very end, so a disagreeing or refusing cohort **is** summarized into the committed
receipt and the process merely exits non-zero. Its agreement check also compares one sample per arm —
round 0 at the low repeat count — not every measurement. *Repair*: one sentence in the report saying
the twelfth point is a row-capacity refusal; and in `ab.py`, drop the counter block from a row whose
`error` is set, and compare the agreement fields across all samples rather than the first.

**10. The reach table's peak-RSS column mixes two unit conventions. Trivial; internal consistency.**
Four rows divide `peak_rss_kb` by 1,000 — `closure` sparse 4,096 at 532 (532,084 KiB), `closure` dense
2,048 at 303 (302,752), `samegen` sparse 8,192 at 1.07 GB (1,070,016) and `closure` blocks 4,096 at
539 (539,360) — and eight divide by 1,024: 586 (599,936), 798 (817,000), 239 (244,744), 239 (244,628),
464 (475,548), 482 (493,304), 21 (21,540) and 257 (262,796). The two conventions differ by 2.4 per
cent, and both appear in the same column. The Soufflé table is uniformly MiB and the boundary table
uniformly KiB over 10^6, each internally consistent. *Repair*: one convention for the reach column,
stated once.

**11. "221 ms and 239 MB" pairs a time from one configuration with a resident set from another.
Trivial.** Location: "the candidate evaluates it in 221 ms with a resident set of 239 MB when the
caller sizes the row bound", repeated in the vibe check. On `closure_ballpark-1dfc6ed`, `closure` at
the `blocks` density and N = 65,536 evaluates in **221 ms at the default row bound**, where the
resident set is 798 MiB; with `--max-rows 1100000` it is 175 ms at 239 MiB. On the shipped
`closure_ballpark-b7921a0` the bounded run is 141 to 147 ms over three repetitions. So the sentence
understates the shipped figure by a third and attributes the default-bound time to the bounded run.
*Repair*: "evaluates it in about 145 ms with a resident set of 239 MiB when the caller sizes the row
bound, against 179 ms and 798 MiB at the default bound", measured on the shipped arm.

**12. Small numeric and range slips. Trivial.**
- The frontend run's measurement count is **1,624**, not 1,625; every one of the six events has
  `n = 1624` in `performance-v7-sparse-d2b1940.json`.
- Branch misses on the direct-path A/B run **0.9865 to 1.0088** against nulls of **0.9916 to 1.0109**;
  the report prints "0.987 to 1.007" and "0.996 to 1.013", so each range misses one endpoint.
- The five cohorts that never reach the backend measure, candidate against control, (−0.79, −3.14),
  (−0.88, +0.24), (−0.16, −1.81), (+0.13, +2.73) and (+1.19, −1.48) instructions; the report prints
  (0, −3), (0, 0), (0, −1), (0, 2) and (1, −1), four of which are not the nearest integer. The point —
  ±3 instructions on a stage that runs nothing — is unaffected.
- The static-index crossover table's first row was taken at `--max-rows 262144`, which the row does
  not say while the other three name their bounds.
- `crates/verify/src/datalog.rs:400` still lists `MAX_UNIVERSE` among the budgets `admit_prepared`
  enforces "over the same constants"; the constant was deleted in `84ed62c` and the budget is no
  longer enforced.
- The Soufflé receipts' `souffle_version` field captured a row of dashes rather than a version string,
  so "Soufflé 2.5" rests on the nix store path, which does read `souffle-2.5`.
- "the derivation loop now has no out-of-line call at **any threshold this profile resolves**" is true
  of the loop and not of the profile: at a 0.005 per cent cut the post-C1188 arm shows `malloc`,
  `cfree`, `hashbrown` and `format_escaped_str`, all of them admission and certificate serialization
  outside the loop. Same wording issue as C1191's defect 7.

**13. The committed harness's usage string names three of the five policies the report's replay block
uses. Trivial; replay.** `examples/closure_ballpark.rs:783` prints `[--index auto|direct|sparse]`
while the parser at line 809 accepts `sparse-indexes` and `sparse-membership` too, and every crossover
command in the report's replay block passes one of those two. The module doc comment at line 14 is
staler still: no `--index`, no `--max-rows`, no `--evaluate-only`, and `--program closure|samegen`
without `mutual` or `cycle`. *Repair*: update both strings in `f2804c4`'s successor.

**14. "Output SHA-256 … identical on every cohort of every A/B" overstates by one receipt. Trivial;
scope.** The full-mode direct-path A/B records `output_sha256: null` on all six cohorts, because the
retained control predates the kernel-scoped mode that prints it; that A/B's row agreement rests on the
derived, probe and candidate counts alone, which do agree. The eight `evaluate`-mode cohorts of the
C1188 run carry the hash and agree. *Repair*: "on every cohort of every kernel-scoped A/B".

**15. The C1189 differential's near-miss decomposition has moved since both prior audits and the
report does not note it. Minor; observation.** The 400 near-miss programs now come out as **382
rejected** — 63 range-restriction, 45 stratification, 274 outside-fragment — with **18 backend
divergences**, all `REL0503` on "relation arity" with found 5. Both C1190's and C1191's audits record
387 rejected (74, 53, 260) with 13 divergences, and `tests/rel_reference_eval.rs` is byte-identical
across the interval, so the corpus did not change. Five more programs reaching the backend is the
direction removing the two refusals predicts; the eleven-, eight- and fourteen-program shifts inside
the rejected classes are not explained by that and I did not establish their cause. Zero
disagreements holds throughout, so nothing load bearing is in question. *Repair*: record the new
decomposition in the report's Exactness row, and note the shift as a consequence of the refusal
removal, or run the differential at `c60d335` to attribute it.

**16. No defect: the Tiger-layout acceptance item is met and unreported.** The card's deliverable
asks the new index kind to be "allocation-free and call-free in the derivation loop, Tiger layout, one
asserted stride". The allocation and call-freedom are both evidenced. The stride is asserted — `Op` at
8 bytes and align 4, `Step` at 128 and align 4, the latter unchanged from `2517852` because the new
`kind` and `head_bitmap` fields consumed two of the eight existing padding bytes — and the sparse
structures introduce no new record type, only `Vec<u32>` bucket heads and a `next` column. The report
never uses the words "Tiger" or "stride" and has no Exactness row for them. *Repair*: one Exactness
row naming the two asserted strides and saying the sparse structures carry no record of their own.

I found no code defect. In particular the addressing policy, the monomorphized dispatch, the
key-column verification, the saturating universe, the row-capacity and workspace-byte refusals, the
membership chain, the sorted static index and both checkers' behaviour at a `2^32` universe are all
what the report says they are.

## Replay commands and their outcomes

Run from `~/src/ergodis-private` unless noted. Every gate and every measurement went through
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin.
Working files under `~/.cache/ergodis/c1192-audit/`.

```sh
# Arms. Outcome: all nine hashes and all nine MANIFEST rows reproduce; two say dirty.
cd ~/.cache/ergodis/bin && sha256sum closure_ballpark-{e0e7331,1dfc6ed,d2b1940,b7921a0} \
    c1188probe-d2b1940 ergodis-tools-{e0e7331,4bcbc10,d2b1940,f12e27b}

# Every A/B ratio, recomputed from the raw samples alone. Outcome: 1,394 values, worst
# relative deviation 0.000e+00 on six receipts; the seventh differs only on the refused point.
python3 ~/.cache/ergodis/c1192-audit/rederive.py analysis/datalog-comparison/ab-2026-09-16-*.json

# The frontend and backend stage ratios. Outcome: every figure to the printed digit.
python3 ~/.cache/ergodis/c1192-audit/frontend.py analysis/rel-frontend/performance-v{7,8}-*.json

# Gates. Outcome: core exit 0 with 80 binaries green; private exit 0 with 42; clippy and fmt
# clean on both; the C1189 differential 19 passed with zero disagreements.
nix develop . --command cargo test --all-features -j 8                      # in ~/src/ergodis
nix develop . --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
nix develop . --command cargo fmt --all -- --check
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private -p ergodis-tools -j 8
choom -n 1000 -- nix develop ~/src/ergodis --command cargo clippy -p ergodis-private \
    -p ergodis-tools --lib --bins --tests --examples -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_reference_eval -j 8 -- --nocapture --test-threads 1

# Parity. Outcome: 243 cases, 530,505 bytes, byte-equal — and canonical_sha256 349333d4…3f652ab
# against the committed f0e2b581…b448b40. See defect 2.
choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output ~/.cache/ergodis/c1192-audit/portability-audit.json

# The reach table on the shipped arm and on the arm the report used. Outcome: eleven of twelve
# rows identical; mutual/blocks/4096 is direct at 539,468 KiB on b7921a0 and sparse at
# 475,524 KiB on 1dfc6ed. Script: ~/.cache/ergodis/c1192-audit/reach.py, and rss.py for raw KiB.
python3 ~/.cache/ergodis/c1192-audit/reach.py ~/.cache/ergodis/bin/closure_ballpark-b7921a0
python3 ~/.cache/ergodis/c1192-audit/reach.py ~/.cache/ergodis/bin/closure_ballpark-1dfc6ed

# The boundary table, from the retained tool rather than a rebuild. Outcome: all sixteen points
# exact, including every budget name, found value and limit, and the four peak resident sets.
T=~/.cache/ergodis/bin/ergodis-tools-d2b1940; F="--max-rows 16777216 --values 262144"
for n in 2047 2048; do choom -n 1000 -- $T rel-lower --cohort stratified --definitions $n --max-tuples 0 $F; done
for n in 2046 2047; do … --cohort columns   --definitions $n --max-tuples 0 $F; done
for n in 161 162;   do … --cohort columns3  --definitions $n --max-tuples 0 $F; done
for n in 2046 2047; do … --cohort aggregate --definitions $n --max-tuples 0 $F; done

# Two A/B pairs, one from each harness. Outcome: 0.90659 against 0.90665 and 0.98200 against
# 0.98201; backend stage 0.98132 against 0.98131 with the closure digest identical across arms.
A=analysis/datalog-comparison; C=~/.cache/ergodis/bin/closure_ballpark
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C-e0e7331 --a-name control \
    --b $C-d2b1940 --b-name candidate --mode full --rounds 2 --cpu 5 --repeats 3 \
    --cohorts closure:dense:512,samegen:sparse:1024 \
    --work ~/.cache/ergodis/c1192-audit/ab-work --out ~/.cache/ergodis/c1192-audit/ab-direct-audit.json
choom -n 1000 -- nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-f12e27b \
    --control ~/.cache/ergodis/bin/ergodis-tools-e0e7331 --rounds 2 --cpu 5 \
    --cohorts stratified --definitions 128 --stages scan,parse,admit,lower,stratify \
    --events instructions,cycles,branches,branch-misses,page-faults,minor-faults \
    --out ~/.cache/ergodis/c1192-audit/bench-stratified-audit.json

# The crossover bracket, five rounds, five densities. Outcome: instructions to five decimals;
# cycles 1.2495 / 1.0937 / 1.0303 / 0.9669 / 0.9800 against the report's 1.2285 / 1.0665 /
# 1.0508 / 0.9842 / 0.9911. Bracket confirmed, endpoints drift about two points. See defect 3.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C-d2b1940 --a-name direct \
    --b $C-d2b1940 --b-name sparse --a-args "--index direct" --b-args "--index sparse-indexes" \
    --mode evaluate --rounds 5 --repeats 3 --cpu 5 --cohorts cycle:blocks:4096 \
    --sweep "--max-rows 4194304;--max-rows 1048576;--max-rows 524288;--max-rows 262144;--max-rows 131072" \
    --work ~/.cache/ergodis/c1192-audit/sweep-work --out ~/.cache/ergodis/c1192-audit/ab-crossover-audit5.json

# The cache set on the crossover pair, which the report never ran. Outcome: at density 32 the
# sparse arm is 0.3677 of the direct arm's cache-references (null 1.0092) and 0.3805 of its
# L1-dcache-load-misses (null 0.9859) while issuing 1.0267 of its L1 loads; at 64, 0.3554,
# 0.3619 and 1.0328. Counted-event support for the reset-traffic mechanism.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C-d2b1940 --a-name direct \
    --b $C-d2b1940 --b-name sparse --a-args "--index direct" --b-args "--index sparse-indexes" \
    --mode evaluate --rounds 5 --repeats 3 --cpu 5 --cohorts cycle:blocks:4096 \
    --sweep "--max-rows 524288;--max-rows 262144" \
    --events cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses \
    --work ~/.cache/ergodis/c1192-audit/sweep-work --out ~/.cache/ergodis/c1192-audit/ab-crossover-cache.json

# One Soufflé case with tuple-set agreement. Outcome: agree true, interpreter equals compiled,
# both checkers verify, instructions 386 / 423 / 801 M, wall ratio 1.017 [0.688, 1.505].
nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake nixpkgs#time -c python3 $A/compare.py \
    --bin $C-b7921a0 --work ~/.cache/ergodis/c1192-audit/souffle-work \
    --out ~/.cache/ergodis/c1192-audit/souffle-audit.json --rounds 3 --cpu 5 \
    --harness-args "--max-rows 1100000" --sizes closure:blocks:4096

# The kernel-scoped profiles, regenerated on all three arms. Outcome: every symbol within
# sampling noise; after C1188, evaluate_into 98.36 and memmove 0.11 per cent.
for arm in e0e7331 d2b1940 b7921a0; do
  taskset -c 5 perf record -q -e instructions:u -F 4000 \
      -o ~/.cache/ergodis/c1192-audit/perf/$arm.data -- $C-$arm --evaluator demand \
      --program closure --certificates 512 dense 20 ~/.cache/ergodis/c1192-audit/work
  perf report -q -i ~/.cache/ergodis/c1192-audit/perf/$arm.data --no-children \
      --percent-limit 0.1 --sort symbol
done

# The two deliberate mutations, against a throwaway copy of the core, never the repository.
# Outcome: baseline 8 passed; each mutation gives 7 passed, 1 failed, and the failure is
# a_constant_key_column_is_compared_against_a_colliding_row in both cases.
cd ~/src/ergodis && git archive HEAD | tar -x -C ~/.cache/ergodis/c1192-audit/mutate
# …point that copy's .cargo/config.toml at its own target dir, delete one VERIFY guard at a
# time in crates/rules/src/demand.rs, then:
nix develop ~/src/ergodis --command cargo test -p ergodis-rules --test demand_sparse -j 8
```

## What a repair pass must change

1. **Re-run the reach table on `closure_ballpark-b7921a0`** and correct the `mutual` / `blocks` /
   4,096 row: the shipped policy chooses the direct counting-sorted index there, not a sparse one,
   and the peak resident set is 539,468 KiB rather than 464 MB. Say in the table header which binary
   and which policy revision the rows are from, since `closure_ballpark-1dfc6ed` predates `6ab0dd5`.
2. **Regenerate `analysis/rel-frontend/portability-v1.json`** and record the new canonical digest
   `349333d4…3f652ab`, and rewrite remaining gap 2: the parity corpus is downstream of the
   *evaluator* change but not of this task's edits to `src/rel_frontend/lower.rs` and
   `lower/passes.rs`, which is why the digest moved. Parity itself is intact at 243 cases and
   530,505 byte-equal canonical bytes.
3. **Commit a cache-event run on the crossover pair** and rewrite the precision argument for
   `DIRECT_INDEX_DENSITY`. The bracket reproduces; the endpoints do not reproduce to one decimal, and
   an A/A null bounds within-run noise rather than between-run drift. The counted evidence that does
   settle the mechanism is `cache-references` at 0.368 and `L1-dcache-load-misses` at 0.381 on the
   sparse arm with nulls of 1.009 and 0.986.
4. **Say that the `cycle` sweep moves three join indexes**, not one, and bound the two small ones'
   share with the reset-word arithmetic (about 258 K extra sparse words against the 16.5 M the
   `2^24` index saves).
5. **Qualify the no-change claim**: a program the evaluator accepted before makes exactly the same
   choices *at the default row bound*; a caller-supplied bound below `keys / DIRECT_INDEX_DENSITY`
   is where the policy now differs, and the reach table's `cycle` row at `--max-rows 100000` is such
   a case.
6. **Correct the certificate sentence**: 0.7 to 10.0 ms is emission; independent checking is 36 to
   619 ms; and the `--process` arm the Soufflé wall ratios compare emits no certificate at all.
7. **Correct three reproducibility statements**: the `4bcbc10` receipts agree to two parts in ten
   thousand, not to the printed digit; `closure_ballpark-b7921a0` was retained from a dirty tree, and
   its core revision is recorded nowhere but the report; the output SHA-256 agreement is over every
   kernel-scoped A/B, not every A/B.
8. **Disclose the refused sweep point** — `closure:blocks:16384` at `--max-rows 65536` is a
   row-capacity refusal — and fix `ab.py` so a row whose `error` is set carries no counter summary,
   and so the agreement fields are compared across every sample rather than the first.
9. **One unit convention for the reach table's peak-RSS column**, and correct "221 ms and 239 MB" to
   the shipped arm's bounded figure of about 145 ms at 239 MiB, against 179 ms at 798 MiB at the
   default bound.
10. **The small slips**: 1,624 measurements not 1,625; branch-miss ratios 0.987 to 1.009 against
    nulls of 0.992 to 1.011; the five null-stage deltas rounded to the nearest instruction; the
    static-index table's first row is at `--max-rows 262144`; `crates/verify/src/datalog.rs:400`
    still names the deleted `MAX_UNIVERSE`; the Soufflé receipts captured no version string; and the
    profile's "no out-of-line call at any threshold" is about the loop, since allocator and serde
    symbols do appear below a 0.005 per cent cut.
11. **Update the harness's usage string and module doc** to name `sparse-indexes` and
    `sparse-membership`, which every crossover replay command uses, and the `mutual` and `cycle`
    programs.
12. **Record the differential's new near-miss decomposition** — 382 rejected (63, 45, 274) with 18
    backend divergences, against the 387 (74, 53, 260) with 13 that both prior audits recorded at an
    unchanged corpus — and either attribute the shift or name it as unexplained.
13. **One free strengthening the report has earned**: add an Exactness row for the Tiger requirement.
    `Op` and `Step` both carry `#[repr(C)]` and an asserted stride, `Step`'s is unchanged at 128
    bytes because the two new fields fit the existing padding, and the sparse structures introduce no
    record type of their own. The card asked for it and the report never claims it.
