# C1201 audit — the static join index's build cost, vetted with repairs

**Lane**: `ergodis`
**Date**: 2026-09-17
**Auditor**: Opus 5 (1M context), working alone; no sub-agents.
**Scope**: the C1201 report (`2026-09-17-c1201-static-index-build-cost-report.md`) against its card
(`2026-09-17-c1201-static-index-build-cost.md`), the core commit `ergodis` `676f513`, the private
commits `ergodis-private` `8c04b7a`, `879f3ed`, `684b0e5`, the committed receipts under
`~/src/ergodis-private/analysis/datalog-comparison/`, and `~/.cache/ergodis/bin/MANIFEST.tsv`.

## Verdict

**VETTED WITH REPAIRS.** No code defect. The shipped rule touches `Policy::Auto` alone, the
staggered counting-sort cursor is provably and empirically identical to the pass it replaces, and
the probe arm is untouched. Every headline result re-derives from a committed receipt, and the
biggest one replays live on the two retained binaries. The defect is in the record, not the
result: three of the report's tables — the coarse crossover sweep, the fine crossover sweep and the
build-repair measurement — were taken on the scratch probe build and carry no receipt, while a
committed receipt covering the same points on the retained candidate exists and disagrees with
them. The report's own Arms section says no kept figure was measured on the probe build, and its
closing disclosure says the points at and above a density of 74.7 replay directly on the retained
candidate and are the table printed; neither is true. The conclusions all survive, and the build
repair is in fact better than the report's table says (0.910 rather than 0.928 of the direct build
at the ceiling, which is the figure the report's own Disposition and mystery ledger already carry).
Nine repairs are listed at the end.

## What was replayed, and with which commands

| Replay | Command | Outcome |
| --- | --- | --- |
| Core commit and diff | `git -C ~/src/ergodis show 676f513 --stat` and `-- crates/rules/src/demand.rs`, `-- crates/rules/tests/demand_sparse.rs`, `-- SHA256SUMS` | three files, the constant, `index_direct`, `Index::csr`, one test and the evidence hash |
| Old-vs-new `csr` equivalence | an independent transcription of both versions of `Index::csr` into Python, 4,000 random key spaces and row multisets plus six edge cases (empty relation, all rows on one key, only key 0, only the last key) | zero mismatches on the `offsets[0..=keys]` prefix and on `rows`; the stagger's extra trailing entry equals the row count |
| Rules-crate gates at `676f513` | `nix develop ~/src/ergodis --command cargo test -p ergodis-rules -j 8`; then the same with `--test demand_sparse -- the_policy_chooses_from_the_key_space_and_the_rows --exact`; then `cargo fmt --all -- --check` and `cargo clippy -p ergodis-rules --all-targets -j 8 -- -D warnings` | 86 passed, 0 failed, 17 `test result: ok` blocks across 16 test binaries including `allocation`, no `FAILED`; the crossover test passes by name; fmt and clippy clean |
| Headline stages comparison, live | `static_index_stages.py --a $C/closure_ballpark-3c8499d --b $C/closure_ballpark-8c04b7a --work ~/.cache/ergodis/c1201-audit/stages-auto --index auto --rounds 3 --repeats 9 --cohorts triangle:sparse:4096,triangle:sparse:16384` | reproduced; see the table below |
| Arms | `sha256sum` of both retained `closure_ballpark` binaries; the four `MANIFEST.tsv` rows | all four hashes match the report to the character, all four `clean`; the `cb11550` pair `dirty` as the report says |
| Receipts | bounded `jq` extractions of `ab-…-unchanged-kinds.json`, `ab-…-changed-kinds.json`, `stages-…-auto.json`, `stages-…-kind-census.json`, `stages-…-shift-direct.json`, `sweep-…-shipped-constant.json`, `sweep-…-blocks-rows.json`, `sweep-…-blocks-ceiling.json`, `results-…-control.json`, `results-…-candidate.json` | every value below |

**Not re-run.** `compare.py` against Soufflé: it compiles three `.dl` programs with `gcc` and runs
five rounds of three systems over three sizes, which is far past a few minutes, so the Soufflé row
is checked against its two committed receipts and not re-measured. The whole-workspace
`cargo test --all-features` and the private suite were not run either; the rules crate is the crate
the change lives in and is the gate the task brief named.

## Checked values, reported against re-derived

Receipt-derived values are exact unless a tolerance is given; the live-replay column is a
three-round run at a load average of about 2.0 against the report's seven rounds.

| Value | Reported | Re-derived | Source |
| --- | ---: | ---: | --- |
| `triangle:sparse:4096` preparation ratio | 0.094 | 0.094 (receipt), 0.0972 (live) | `stages-auto`, live replay |
| `triangle:sparse:4096` peak RSS ratio | 0.084 | 0.0837 (receipt), 0.0832 (live) | same |
| `triangle:sparse:4096` whole process | 0.193 | 0.1928 (receipt), 0.1957 (live) | same |
| `triangle:sparse:4096` whole-process RSS | 0.080 | 0.0796 both | same |
| `triangle:sparse:4096` prep, control ÷ candidate ms | 30.9834 / 2.9138 | identical (receipt); 30.5692 / 2.9710 (live) | same |
| `triangle:sparse:4096` prep minor faults | 17,459 / 1,074 | identical; 17,455 / 1,069 (live) | same |
| `triangle:sparse:4096` derivation loop | 1.556 | 1.5555; 1.6203 (live) | same |
| `triangle:sparse:1024`, `mutual:blocks:4096`, `mutual:blocks:8192`, `triangle:sparse:16384` per-stage rows | every figure | every figure identical | `stages-auto` |
| Kind change census | exactly two cohorts change, `d`→`s` and `ddd`→`dsd` | exactly two, and the digest, derived, probe and candidate counts equal on all seventeen | `kind-census`, and the script raises `SystemExit` on either mismatch |
| Per-index key spaces in the kind table | all seventeen rows | all identical, including 2^24, 2^26 and 2^28 | `kind-census` |
| Thirteen unchanged-kind instruction ratios | 1.00000 … 1.00003 | identical at five decimals; the true range is 0.99999 to 1.00003 | `ab-unchanged-kinds` |
| Their intervals and A/A nulls | all twenty-six values | all identical | same |
| Their cycle ratios and derived counts | all twenty-six values | all identical | same |
| A/A null worst case | within 2.3e-5 | 2.23e-5 (`path3:sparse:4096`, 0.9999777) | same |
| Two changed-kind cohorts | 1.41212 and 1.44701 instructions, 1.48717 and 2.04451 cycles, nulls 1.0000977 and 1.0000267 | all identical | `ab-changed-kinds` |
| Soufflé, control arm | 21.76 / 57.35 / 54.69 ms, ratios 1.086 / 1.903 / 0.828 | all identical, `souffle_agrees: true` on every case | `results-control` |
| Soufflé, candidate arm | 19.39 / 27.04 / 54.34 ms, ratios 1.059 / 0.896 / 0.768 | all identical | `results-candidate` |
| Compiled Soufflé's own time | 29.2–29.5 and 68.2–69.1 ms | 29.47 / 29.17 and 69.14 / 68.25 | both receipts |
| C1193's recorded 1.92 | reproduced to within a per cent | C1193's report says 1.92; this control reads 1.903, 0.9 per cent | C1193 report, `results-control` |
| Per-fact preparation, all seventeen cohorts | 164 to 283 ns | every one of the seventeen re-divides to the printed integer | `kind-census` |
| The two former outliers | 1,956 and 549 ns per fact | 1,956.5 and 549.4 | same |
| Blocks-density sweep, eight rows | prep, eval and one-evaluation ratio | all twenty-four figures identical at the printed precision | `blocks-rows`, `blocks-ceiling` |
| Blocks-density RSS saving | 36 to 64 MB at the top | 36,068 and 64,136 KiB | same |
| Cost of the shipped constant on `triangle:blocks` | 7 to 39 per cent | 7.3 and 39.4 per cent of preparation plus one evaluation | same |
| Crossover, upper bracket point | 1.042 at a density of 74.7 | **1.0382** on the retained candidate | `sweep-shipped-constant` |
| Crossover, top of the sweep | 6.16 at a density of 1,365 | 6.1624 | same |
| Direct probe's advantage | 1.5 to 2.3 times, density 10.7 to 1,365 | 1.49 to 2.33 over the densities the retained-binary receipt covers, 74.7 to 1,365 | same |
| Build repair at the ceiling | **0.928**, 7.2 per cent (table) / 0.910 (Disposition and ledger) | **0.9096**; the table's 0.928 is in no receipt | `stages-shift-direct` |
| Build repair, the other three domains | 0.972 / 0.948 / 0.951 | 0.9689 / 0.9396 / 0.9541 | same |
| Build-repair fault counts | 527 / 1,442 / 4,716 / 17,391 | 595 / 1,510 / 4,784 / 17,459 | same |
| Build-repair instruction ratios | 0.999 / 0.993 / 0.984 / 0.973 | 0.9995 / 0.997 / 0.9925 / 0.9852 | same |
| Warm streaming bandwidth | 2.18 ms, 58 GB/s | 2.083 ms and 61 GiB/s from the receipt; the report's figures are GiB/s | same |
| Resident sets identical on the retained arms | identical at every domain | 4,316 / 7,904 / 20,956 / 71,528 KiB on both arms | same |
| `mutual:blocks:4096`, the settling datum | 1.957 against the direct kind | **2.49** for preparation plus one evaluation, 2.37 in the census, 1.955 for the whole process; 1.957 is in no receipt | `stages-auto`, `kind-census` |
| `key_space / probes` for the three families | 23.1, 18.2, 273 | 43,264/1,872 = 23.1, 16,777,216/921,600 = 18.2, 16,777,216/61,440 = 273.1, with the probe counts derived from the out-degree as the report says | arithmetic on the receipts |
| Coarse sweep table, eight rows | prep, RSS, eval, eval ratio, break-even | every row disagrees with the retained-binary receipt, with RSS a constant 328 KiB high on **both** arms at every domain | `sweep-shipped-constant` |
| Fine sweep table, the four rows at and above 74.7 | Δprep, Δeval, break-even, one-evaluation ratio | 0.053/0.0423/1.3/1.0382 against 0.0546/0.0431/1.3/1.042; and at 256, 0.0928/0.0482/1.9/1.1463 against 0.0729/0.0511/1.4/1.071 | same |
| Trees at close | `ergodis` `676f513`, private `684b0e5`, both clean | both at those revisions, `git status --short` empty in both | live |
| `~/.cache/ergodis/c1201/` | 16 MB, the named work directories | 16 MB; the Soufflé trees are `souffle-ctl` and `souffle-cand`, not the names the replay block prints | live |

## Code read

| Area | Finding |
| --- | --- |
| `DIRECT_STATIC_DENSITY` and `Policy::index_direct` | Exact, and Auto-only. The ceiling `keys <= MAX_DIRECT_KEYS` stays outside the match, so it binds under every policy; `Direct` and `SparseMembership` still return true and `Sparse` and `SparseIndexes` still return false, unchanged lines. The Auto arm selects `DIRECT_INDEX_DENSITY` when the relation grows and `DIRECT_STATIC_DENSITY` when it does not, then tests `keys <= density · max(rows, 1)` with a saturating multiply. Units and inequality are what the report states: key space per row, direct while the density is at most 64, `<=` so a density of exactly 64 is still direct. |
| What `rows` means for a static index | The report's claim that it is the exact fact count is right: `Demand::new_bounded` sets `capacity = fact_of.len()` when `grows` is false and `universe.min(row_bound)` when it is, and `index_direct` is called with `plan.capacity`. So the rule needs no new input, as the report says. |
| The staggered cursor, by argument | Exact. Let `S[k]` be the true start of bucket `k`. The counting pass leaves `offsets[j] = count[j-2]`; the inclusive scan from index one leaves `offsets[j] = S[j-1]`, so `offsets[k+1]` is the start of bucket `k`; placement advances `offsets[key+1]` once per row, so it ends at `S[k]+count[k] = S[k+1]`; `offsets[0]` is never written by either pass and the scan left it zero, which is `S[0]`. The final array is therefore `S[j]` at every `j` in `0..=keys`, exactly what the old `copy_within` plus zero-write produced, and the one extra trailing entry holds the row count and is never read. Empty buckets are right because an unadvanced cursor leaves start equal to end. |
| The staggered cursor, by test | 4,000 random cases and six edge cases agree on both the offsets prefix and the rows array. No test in the crate binds the equality *directly*; it is bound indirectly and adequately, because `demand_sparse` runs the whole corpus a second time under `Policy::Sparse` and compares certificate bytes, so a wrong CSR fails. Worth a successor's one-screen unit test on the bucket contents. |
| The probe | Untouched. `Index::bucket`'s `KIND_CSR` arm and the two `next_row` sites still read `offsets[key]` and `offsets[key+1]` only; the diff contains no change to either, and nothing in the crate reads `offsets.len()` for a CSR index or accounts bytes from it. So the four extra bytes are invisible outside the build. |
| Hot-loop allocation and run-constant branches | None added. The new `if grows` sits in `index_direct`, which runs once per index at plan build; `csr` still makes one `vec!` of `keys + 2` and the scan runs one extra iteration. The removed `copy_within` is a whole pass gone. |
| Overflow and bounds | `keys <= MAX_DIRECT_KEYS` = 2^24, so `keys + 2` cannot overflow a `usize` and the largest counting index, `key + 2` with `key <= keys - 1`, is in bounds. |
| Docstrings | They match the code, including the corrected "one entry per key plus a terminator, and one further entry the staggered cursor counts into" on the `offsets` field and the whole rewritten `Index::csr` derivation, which I checked line by line against the argument above. No `unsafe` and no `SAFETY` comment is added or changed by this commit. One nuance: the constant's docstring quotes "ahead … by 3.2 per cent" at a density of 64 and "behind by 4.2 per cent" at 74.7, both from the unreceipted probe-build sweep; the retained candidate's receipt reads 3.8 per cent behind at 74.7. |
| The crossover test | It brackets the rule at `ceil(key_space / DIRECT_STATIC_DENSITY)` facts and one fact below, asserting direct and then sparse, so it binds the inequality and the "rows means facts" reading tightly and survives a change to the constant's value — which is what the report claims for it. Nothing binds the value 64 itself, correctly, since 64 is a measurement and not a contract. |
| Card's deliverable and scope | Met: the rule is a density on key space against row count, the two kernels reach the chosen kind through the existing `KIND_*` dispatch with no new kind, and `Auto` is the only policy whose choice moves. Nothing in the diff touches join ordering or the checkers' store. |

## Defects, by severity

1. **Measurement record. The build-repair table is the scratch probe build and is superseded by a
   committed receipt it disagrees with.** The table's four rows (0.972, 0.948, 0.951, 0.928, fault
   counts 527/1,442/4,716/17,391, instruction ratios 0.999/0.993/0.984/0.973) appear in no receipt.
   `stages-2026-09-17-c1201-shift-direct.json`, which is the same measurement on the two retained
   arms, reads 0.9689, 0.9396, 0.9541, 0.9096, faults 595/1,510/4,784/17,459 and instruction ratios
   0.9995/0.997/0.9925/0.9852, with the resident sets identical on both arms at every domain. The
   report quotes the receipted 0.910 in its Disposition and in settled mystery item 5 and the
   unreceipted 0.928 in the table, calling both "the direct build at the ceiling", without saying
   they are two runs. The headline "7.2 per cent off the direct build at the ceiling" understates
   the receipted 9.0 per cent, and the Fermi-3 correction's "2.18 ms, which is 58 GB/s" is the same
   unreceipted run; the receipt's delta is 2.083 ms, or 61 GiB/s.
2. **Measurement record. Both crossover sweep tables are the probe build, not only their rows below
   a density of 64.** The coarse table's peak RSS sits a constant 328 KiB above
   `sweep-2026-09-17-c1201-shipped-constant.json` at every domain **and on both arms**, which is a
   different binary and not session drift; its preparation, evaluation and break-even columns differ
   throughout (at a density of 1,365: 29.3571 against 27.2986 ms, 71,856 against 71,528 KiB, 36.9
   against 39.9 evaluations to break even). The fine table's four rows at and above 74.7 differ the
   same way (at 74.7 the one-evaluation ratio is 1.042 against the receipt's 1.0382; at 85.3, 1.071
   against 1.1463; at 128.0, 1.228 against 1.2657; break-even 1.4 against 1.9 at 85.3). So the
   report's closing sentence — that those points "replay directly on `closure_ballpark-8c04b7a` and
   are the table above" — is false, and the Arms section's "no kept figure is measured on it" is
   contradicted by both tables and by defect 1. What survives intact: the refutation of Fermi
   prediction 2 (the retained candidate's own receipt has the direct probe ahead by 1.49 to 2.33
   times from a density of 74.7 to 1,365), the upper end of the crossover bracket (1.0382, still
   above unity, with a break-even of 1.3 evaluations), and every conclusion drawn from them. The
   lower end of the bracket, a density of 64 at 0.968, cannot be measured on the shipped binary at
   all and remains a probe-build figure — which the report is right about and should simply say for
   the whole table.
3. **Measurement record. The `mutual` figure in the closeout's settling datum is untraceable.** "the
   right answer is opposite on them: 0.932 for the direct kind on the triangle and 1.957 against it
   on `mutual`" — 0.932 is the blocks sweep's one-evaluation ratio, but no receipt holds 1.957 and no
   combination of receipted figures produces it. The comparable quantity, preparation plus one
   evaluation direct over sparse, is 2.49 from the seven-round `stages-auto` receipt and 2.37 from
   the census; the whole-process inverse is 1.955. The finding is unaffected and stronger with the
   right number.
4. **Measurement record. The stages and sweep receipts record no load average, no CPU, no binary
   hash and no repeat count**, so the report's "load average 1.4 to 1.6 during the per-stage runs",
   "2.7 to 3.4", "5.6 to 5.9", "5.9 to 7.8" and "1.45 to 1.56" are unreceipted, and "recorded per
   receipt" holds only for the two `ab.py` receipts. Even there the range is wrong: the A/B receipts
   record 2.53 to 2.57 and 2.86 to 4.57, so the report's "1.9 to 4.6" has no low end. The pinning
   and the OOM preference *are* code-backed — both scripts build the command as
   `perf stat … taskset -c <cpu> choom -n 1000 -- <binary>` — they are simply not in the output.
5. **Measurement record. The kind-census replay command does not reproduce its receipt.** `$ALL` is
   `$UNCH` plus three cohorts, which is sixteen; the committed receipt holds seventeen, the extra
   being `path4:sparse:16384`, which is in the report's kind table and in no run command. The
   Soufflé loop's `--work $W/souffle-$name` also does not match the directories on disk,
   `souffle-ctl` and `souffle-cand`.
6. **Measurement record, minor. The pre-change baseline table has no receipt and no replay
   command.** Its `auto` rows reproduce on the retained control in my live replay (30.57 ms against
   31.15, 71,508 KiB exactly, 1.265 ms against 1.289; and at 16,384, 12.63 ms against 12.92,
   15,212 KiB against 15,256, 10.40 ms against 11.529), and the C1193 audit independently reproduced
   the `sparse-indexes` rows, so the numbers stand. They are simply absent from the bundle.
7. **Measurement record, minor. "Identical to the byte" is a property of that run, not of the
   arms.** The receipt does show 3,753 / 3,753 faults and 15,116 / 15,116 KiB on
   `triangle:sparse:16384` and 14,666 / 14,666 and 37,948 / 37,948 on `mutual:blocks:8192`. My
   three-round replay of the first reads 3,744 against 3,748 faults and 15,212 against 15,248 KiB.
   The plan the two arms build there is identical, so the expectation is right, but exact equality is
   page placement and does not reproduce.
8. **Measurement record, minor. "Soufflé 2.5" is not in the receipt.** The `souffle_version` field
   of both `results-…json` files is a line of dashes: the version capture in `compare.py` picked up
   a separator instead of the version. Everything else in those receipts — the CPU pin, the rounds,
   the harness hash matching the retained arm, the per-program `.dl` and compiled hashes, and
   `souffle_agrees: true` on every case — is present and correct.
9. **Prose.** Ten items, none of which changes a conclusion: (a) "Thirteen cohorts … read 1.00000 to
   1.00003" — `closure:blocks:16384` reads 0.99999, in the report's own table, so the range is
   0.99999 to 1.00003, and it appears twice; (b) "48 KiB of offsets at N = 4,096" in the mask
   demotion pricing, twice — a key space of 4,096 is 16 KiB of offsets, which the report says
   correctly elsewhere, and 48 KiB is the rows array; (c) the not-built hash is priced with two
   formulas for one number, `24 · rows` (which is the 288 KiB quoted) and `16 · distinct_keys`
   (which is 192 KiB); (d) "7 to 39 per cent of one whole evaluation" is of preparation *plus* one
   evaluation; (e) "an eighth to a quarter of the memory" — 0.084 is a twelfth; (f) "the direct
   build's cost grows with the key space without bound", in the report and in the shipped docstring,
   where `MAX_DIRECT_KEYS` in fact caps it at 64 MiB and about 28 ms; (g) "a single constant on
   `key_space / probes` gets all three" overstates the fit, since the two checks only require the
   constant to lie between 18.2 and 273 — open item 3 says exactly this and the closeout's wording
   should match it; (h) 58 and 20 "GB/s" are GiB/s; (i) "71.5 MB" for 71,528 KiB, which is 71.5 MiB,
   throughout; (j) the word "probes" carries two magnitudes in one report — the receipted top-level
   counter, which equals the fact count, and the fan-out-derived per-index count the cost model
   uses, which is three or fifteen times larger. The report flags the derivation in queued
   candidate 2 but never says the two numbers are different quantities.

## Acceptance, per card bullet

| Bullet | Verdict |
| --- | --- |
| `triangle` at 4,096 and 16,384 under `Auto`: preparation and peak RSS at or near the sparse row, evaluation at or near the direct row; Soufflé row re-run | **Partly met, and the shortfall is stated plainly with its cause.** Preparation and peak RSS are at the sparse row at 4,096 (0.094 and 0.084, replayed live at 0.097 and 0.083) and unmoved at 16,384. Evaluation is not at the direct row and cannot be: the derivation loop costs 1.556 times the direct arm, because the measurement refuted the assumption the criterion rests on — the direct probe is ahead at every density the retained candidate's receipt covers. The report gives this its own subsection, names the refuted prediction, and prices the two representations that would meet the criterion instead of reinterpreting it. The Soufflé row is re-run on both arms with `agree: true` on every case. |
| Every C1192 and C1193 cohort under `Auto`: instruction ratio within the A/A null where the kind does not change; kind changes listed per cohort with the rule that made them | **Met.** Thirteen cohorts measured in the A/B at 0.99999 to 1.00003 against nulls within 2.23e-5, two more measured as per-stage nulls, and all seventeen listed with their per-index key space, rows, density and kind. Exactly two kinds change and both are explained by the one rule. `path4:sparse:16384` is in the census and the kind table but in neither timing run; its plan is identical between the arms, so nothing is at risk, but the report's phrasing implies a measurement it does not have. |
| Exactness: the differential, both checkers, `demand_nary`, `demand_prepared`, the C1192 collision cases; work counts unchanged where the kind is unchanged | **Met for the parts I re-ran, and asserted in code for the rest.** The rules crate's suite passes clean at `676f513`, `allocation` included. `static_index_stages.py` raises on a digest or work-counter mismatch per cohort, so the census's seventeen equalities are assertions and not inspections. The private differential I did not re-run. |
| Performance-contract validation; a retain from a tree whose `git status --short` is empty, checked before the recipe; report with Mystery ledger; audit | **Met, and the C1193 audit's finding 1 is repaired.** All four arms are `clean` in `MANIFEST.tsv` with the hashes the report prints, and both retained binaries still hash to those values. The Mystery ledger's five open items each name a concrete evidence gap and an owner, and the report says outright that none is manufactured, which is right: three are measurements nobody has taken, one is a constant fitted at a single point, and one is an unmeasured argument by analogy. This audit is the last piece. |

**On the two decisions the report leaves open.** Keeping `DIRECT_STATIC_DENSITY` at 64 is the right
call on the evidence: it is correct on the family it was fitted to and on `mutual:blocks`, its error
on `triangle:blocks` is bounded at 7 to 39 per cent of preparation plus one evaluation while buying
36 to 64 MB of resident memory, and the rule it replaced had no bounded error at all — 5.2 times
slower end to end and 65 MB held for a relation of 12,288 rows. The successor should replace the
rule's shape rather than its constant, and the per-link probe counter is the first piece of work,
since all three unbuilt shapes need it. Mask demotion is the cheaper of the two shapes that could
meet the card's acceptance line as written, and I agree with the report's ordering.

## What this audit left under `~/.cache/ergodis/`

`c1201-audit/stages-auto/`, 248 KB: the work directory of the one live replay, cited only here.
Nothing else was written, nothing was deleted, and no cache entry was garbage-collected. Deletion
is Tavis's call.

## Repairs, for a repair pass to apply

1. Replace the build-repair table with `stages-2026-09-17-c1201-shift-direct.json`'s four rows
   (0.9689, 0.9396, 0.9541, 0.9096; faults 595/1,510/4,784/17,459; instruction ratios
   0.9995/0.997/0.9925/0.9852; resident sets identical on both arms), and correct the surrounding
   prose: 9.0 per cent off the direct build at the ceiling rather than 7.2, and about 5 to 6 per
   cent a quarter of the way down. Keep the existing 0.910 in the Disposition and in settled mystery
   item 5, which are already this receipt.
2. Correct the Fermi-3 arithmetic to the receipted delta: 2.083 ms at 2^24 keys, so warm streaming
   traffic on this host is about 61 GiB/s and cold first-touch about 20 GiB/s, and say GiB rather
   than GB.
3. Say that both crossover sweep tables were taken on the scratch probe build, not only their rows
   below a density of 64, and replace the closing claim that the points at and above 74.7 replay on
   `closure_ballpark-8c04b7a`. Print the retained candidate's own numbers for the rows
   `sweep-2026-09-17-c1201-shipped-constant.json` covers — one-evaluation ratio 1.0382 at a density
   of 74.7 rising to 6.1624 at 1,365, break-even 1.3 evaluations at 74.7, and the eval-ratio range
   0.4286 to 0.6714 — and state the bracket as a density of 64 (probe build, 0.968) to 74.7
   (retained candidate, 1.0382). Then fix the Arms section's "no kept figure is measured on it".
4. Replace `mutual`'s 1.957 with 2.49 and name the quantity: preparation plus one evaluation, direct
   over sparse, from the seven-round `stages-auto` receipt. Note the census's 2.37 as the
   independent single-round reading.
5. Correct the A/B load-average range to 2.5 to 4.6, and say that the stages and sweep runs' load
   averages were noted by hand rather than recorded, because neither script emits one. Add the three
   missing fields — load average, CPU and per-arm binary hash — to `static_index_stages.py` and
   `static_index_sweep.py` as a queued candidate, since `ab.py` and `compare.py` already record them.
6. Add `path4:sparse:16384` to the `$ALL` list in the replay block so the census command reproduces
   its receipt, and correct the Soufflé work-directory names to `souffle-ctl` and `souffle-cand`.
7. Give the pre-change baseline table a replay command, and say it has no receipt and that its
   `auto` rows were reproduced by this audit on the retained control and its `sparse-indexes` rows
   by the C1193 audit.
8. State the identical fault counts and resident sets on the two unchanged-kind cohorts as a
   property of that run — the plan is identical, so equality is expected, but it is page placement
   and does not reproduce — and note that a three-round replay reads 3,744 against 3,748 faults on
   `triangle:sparse:16384`.
9. Fix the prose items: the thirteen-cohort range to 0.99999 to 1.00003 in both places; 16 KiB of
   offsets rather than 48 KiB in the mask-demotion pricing and in queued candidate 3; one formula
   for the hash's build footprint; "of preparation plus one evaluation" for the 7-to-39-per-cent
   figure; a twelfth rather than an eighth of the memory; "without bound up to `MAX_DIRECT_KEYS`"
   in the report and in the `DIRECT_STATIC_DENSITY` docstring; the docstring's 4.2 per cent to the
   receipted 3.8; GiB and MiB throughout; that the cost model's probe counts are derived from the
   out-degree and are a different quantity from the receipted top-level `probes` counter; and soften
   "one constant gets all three" to what was fitted, namely a threshold the two checks place between
   18.2 and 273. Note that "Soufflé 2.5" rests on the session and not on the receipt, whose version
   field captured a separator line, and fix that capture in `compare.py`.
