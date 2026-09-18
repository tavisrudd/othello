# C1202 audit — the probe-count index rule, mask demotion and the per-link probe counter

**Lane**: `ergodis`
**Date**: 2026-09-18
**Auditor**: Opus 5 (1M context), working alone; no sub-agents.
**Scope**: the C1202 report (`2026-09-18-c1202-probe-count-index-rule-report.md`) against its card
(`2026-09-18-c1202-probe-count-index-rule.md`), the core commits `ergodis` `2904489` … `9edc07b`,
the private commits `ergodis-private` `83bff0a` … `b47ade4`, the committed receipts under
`~/src/ergodis-private/analysis/datalog-comparison/`, `~/.cache/ergodis/bin/MANIFEST.tsv`, and
`~/src/ergodis-dev/PERFORMANCE.md` with `performance-playbook.md`, both read in full before any
measurement.

**Read-only** on all three repositories except this file. Nothing was committed by this audit.

## Verdict

**VETTED WITH REPAIRS, and the result is stronger than the record.** No code defect: mask demotion
is exactly `OP_KEY → OP_CHECK` plus one mask bit with no kernel line changed, its three properties
hold under reading and under two adversarial cases built here, the production derivation loop
carries neither the counter nor its register, and the probe rule's floor and estimate are one-sided
in the directions the report claims. The eighteen-cohort census reproduces field for field, the
kept arm's derivation loop reproduces to within eleven parts per million on four of five cohorts,
and the core gates reproduce exactly. Every headline — the loop at 0.604 and the whole process at
0.887 on `triangle:sparse:4096` with preparation and resident memory unmoved, 0.469 at 16,384,
0.420 on `triangle:blocks:4096`, opposite kinds for the two cohorts of equal density from one
constant, the counter's measured refutation of Fermi prediction 1, and the growing index's answer
by measurement — re-derives from a committed receipt. Sixteen defects are listed at the end, all in
the record and the prose; the two that would change a printed conclusion are the demotion sweeps'
mislabelled lookup column and the demotion cost model's distinct count, and correcting the second
strengthens the conclusion it supports.

## Receipts, and what re-derives from them

Every receipt named below is tracked in `ergodis-private` and was re-read from the working tree at
`b47ade4`, whose `git status --short` is empty.

| Receipt | Commit that added it | What the report draws from it |
| --- | --- | --- |
| `ab-2026-09-18-c1202-probe-counter.json` | `8d43d4e` | the unconditional counter's cost, seven rows |
| `ab-2026-09-18-c1202-probe-counter-const.json` | `42d1852` | the production path, eighteen rows |
| `sweep-2026-09-18-c1202-demotion-triangle.json` | `d37f448` | the `triangle` demotion sweep, seven rows |
| `sweep-2026-09-18-c1202-demotion-mutual.json` | `d37f448` | the `mutual` demotion sweep, six rows |
| `ab-2026-09-18-c1202-probe-rule.json` | `e372dd1` | the pre-floor derivation loop |
| `stages-2026-09-18-c1202-probe-rule-prefloor.json` | `5217cdb` | the instructive negative's figures |
| `ab-2026-09-18-c1202-probe-rule-floored.json` | `010e500` | the kept arm's derivation loop, eighteen rows |
| `stages-2026-09-18-c1202-probe-rule-floored.json` | `fe18961` | the per-stage table, seven rows |
| `stages-2026-09-18-c1202-kind-census.json` | `fe18961` | the eighteen-cohort census |
| `ab-2026-09-18-c1202-growing-index.json` | `b47ade4` | `DIRECT_INDEX_DENSITY`'s four points |

### What re-derives exactly

Checked by a script that reads each receipt and compares every printed figure; only the exceptions
below failed.

- **The unconditional counter's table** (seven cohorts): every instruction ratio, both interval
  ends, every A/A null, and every Δ-instructions-per-lookup figure (7.00 to 10.49, and 0.80 on
  `path4:sparse:4096`), where the lookup counts come from the census receipt. Rounds, repeats,
  event set at 100.00 per cent, load average 2.17 to 2.33 and an empty failure list are all in the
  receipt.
- **The production path's eighteen rows**: every instruction ratio, both interval ends, every A/A
  null and every cycle ratio. Seventeen below unity; the spread 0.025 to 1.633 per cent, which the
  report prints as 0.03 to 1.63.
- **The kept arm's derivation loop, eighteen rows**: every instruction ratio, interval, null and
  cycle ratio, including the three changed cohorts (1.30455, 1.25667, 0.71717 in instructions and
  0.60147, 0.47352, 0.43392 in cycles). Derived, probe and candidate counts are equal between the
  arms on all eighteen in the receipt itself.
- **The census, eighteen rows**: every kind pair, every key-space list, every mask list and every
  per-index lookup split, and the digest, derived, probe, candidate and lookup equality per cohort.
- **The per-stage table, seven cohorts**: preparation, fault counts, resident sets, derivation loop
  and whole-process figures on both arms, and every ratio except the two rounding slips in defect 8.
- **Both demotion sweeps**: facts, both arms' preparation and evaluation, and every
  one-evaluation ratio, on all thirteen rows.
- **The growing-index table**: derived counts, instruction ratios, intervals, nulls, cycle ratios
  and both wall medians on all four points, and the kinds `ddd` at `--max-rows 400000` against
  `dds` at 300000 read out of the receipt's own addressing records.
- **The `ej` closeout's derivation of `K`**: 32.0062 − 12.3466 = 19.66 ms over 2^24 keys is
  1.17 ns per key; 38.2938 − 16.0982 = 22.20 ms over 921,600 lookups is 24.1 ns per probe; the
  ratio is 20.55, which the report prints as 20.6.
- **The instructive negative's whole-process figure**: 0.990 on `triangle:blocks:4096` re-derives
  from the pre-floor stages receipt.
- **The arms table**: all seven measured sha256 values match `MANIFEST.tsv` to the character and
  match the binaries on disk today; all five kept arms are `clean`, both `df2f5f4` and `531f19b`
  are `dirty`, and their hashes are identical to the clean retains at `8d43d4e` and `5217cdb`
  exactly as the report says. rustc 1.95.0 (59807616e 2026-04-14), `release`, no features on every
  row.

### What does not re-derive, or carries no receipt

1. **`closure:sparse:4096` is in no receipt of this task.** The piece-1 lookup table introduces
   itself as "measured on the eighteen-cohort set through the driver's new `--count-probes`", but
   `closure:sparse:4096` is not in `$ALL`, and a grep of every JSON receipt in
   `analysis/datalog-comparison/` finds the cohort nowhere. Its row (top-level probes 15,691,854,
   bucket lookups 15,679,566, per index 15,679,566 · 0) is an unreceipted hand run.
2. **The demotion sweeps' "lookups into the demoted link" column is the total lookup count.** At
   `blocks4` the receipt's `index_lookups` for the undemoted arm is `[12,288, 36,864, 0]`, so the
   demoted link takes 36,864 and the table's 49,152 is `lookups`. Every row is the same
   substitution: 102,336 rather than 122,808, 200,704 rather than 229,376, 331,440 rather than
   368,280, 495,168 rather than 540,192, 691,264 rather than 744,464, and 921,600 rather than
   983,040. The report's own prose uses the correct per-link figure (921,600 at `blocks16`), so
   only the column is wrong.
3. **"The two arms' preparation agrees to 0.5 per cent at every point of the `triangle` sweep" is
   false.** The receipt's demoted-over-undemoted preparation ratios are 1.0019, 1.0384, 1.0299,
   1.0055, 0.9764, 0.9840 and 0.9952 — a spread of 3.8 per cent with no consistent sign. The
   conclusion the sentence supports (the build difference is inside preparation's noise on this
   family) survives, because the sign alternates; the stated bound does not.
4. **The A/A null bound quoted for the fifteen unchanged cohorts excludes the worst of them.**
   `mutual:blocks:4096`'s null in the floored A/B is 0.9999383, a deviation of 6.2 parts per
   hundred thousand, not the 2.7 the report quotes three times. 2.7e-5 is the worst of the other
   fourteen (`cycle:blocks:4096`, 1.0000269). This matters for one reading only: that cohort's
   reported 0.99985 is 1.5e-4 from unity against its own 6.2e-5 null, so it is about two nulls
   wide rather than five.
5. **The unconditional counter's range is quoted from the wrong low end.** The headline says
   "0.11 to 2.55 per cent" and the piece-1 text "The full set ranges 1.00114 to 1.02554"; the
   receipt's minimum over the eighteen cohorts is 1.00067 on `closure:dense:512`, which is in the
   report's own seven-row table. The range is 0.067 to 2.554 per cent.
6. **"The branch counts moved by the same fraction as the instruction counts" overstates the
   agreement.** In the same receipt `triangle:sparse:4096` moved 2.554 per cent in instructions
   against 4.035 per cent in branches, and `path4:sparse:4096` — the cohort the report calls "the
   same change costing almost nothing" — moved 0.114 per cent in instructions against 1.378 per
   cent in branches. The inference the sentence draws (the cost is not an unconditional register
   increment) is stronger with the true figures, not weaker, but "almost nothing" is an
   instruction-only statement.
7. **Three of the four growing-index lookup counts are unreceipted.** `ab.py` records no lookup
   counter, so 20,480, 36,864 and 135,168 at `cycle:blocks4/8/32:4096` appear in no receipt; only
   `cycle:blocks16:4096`'s 69,632 does, through the census's `cycle:blocks:4096` row. All four fit
   `derived / 2 + domain` exactly, and the key-space-per-probe column (819, 455, 241, 124) is the
   arithmetic on them, so the figures are consistent and simply not receipted.
8. **Two rounding slips in the per-stage table**, both immaterial: `triangle:sparse:16384`'s peak
   RSS ratio is 15,104 / 15,112 = 0.999, printed as 1.000; `mutual:blocks:4096`'s preparation ratio
   is 11.7706 / 11.7176 = 1.005, printed as 1.004.
9. **The per-stage load average is a per-cohort field, and the quoted 2.29 is one cohort's.** The
   receipt's per-cohort loads run 2.27 to 2.33; `triangle:sparse:4096`, whose row is the report's
   headline, is 2.29.
10. **The Method section's "Pinned to core 5 under `choom -n 1000`" is true of the stage and sweep
    runs and false of every `ab.py` receipt.** `static_index_stages.py` and `static_index_sweep.py`
    build `perf stat … taskset -c <cpu> choom -n 1000 -- <binary>`; `ab.py` builds
    `perf stat … taskset -c <cpu> <binary>` and never has (no `choom` in its history). Pieces 1,
    the floored derivation loop and the growing-index run are all `ab.py`. The pin is real in both.
11. **The baseline table and the per-evaluation instruction counts carry no receipt**, which the
    report states plainly for the first ("**No receipt**") and does not state for the second
    (15,410,577, 486,113,555 and 29,242,654 instructions per evaluation, two-point differenced by
    hand on the control).
12. **The arms table's Core column rests on the session.** `retain-bin.sh` records only the
    revision of the crate directory it builds, so `MANIFEST.tsv` carries the private revision and
    nothing about the core checkout. The two empty re-pin commits are the intended substitute, and
    one of them (`531f19b`) does not name the revision it pins — the message says "the floored
    probe rule" rather than `9edc07b`.
13. **The instructive negative's 2.8 ms does not re-derive.** The pre-floor and floored per-stage
    receipts were taken with the same control, which agrees between them to 0.01 per cent
    (12.3481 against 12.3466 ms), so their candidate preparations are directly comparable:
    33.7107 against 32.0062 ms, a difference of **1.71 ms**, not the 2.8 the report gives for the
    sorted build of the index no live step probes. The same comparison also shows the defect was
    broader than the report says — it cost 0.106, 0.531, 1.575 and 0.318 ms on
    `triangle:sparse:1024`, `:4096`, `:16384` and `path4:sparse:4096` as well, because those
    cohorts' second index went sorted too (`ds` against the floored `dd`).
14. **The second instructive negative's 0.50 ms is not separated from the first.** The report
    reads it as the pre-floor candidate against its own control on `triangle:sparse:4096`
    (3.3924 − 2.8966 = 0.496 ms), but that difference also contains the dead index held sorted,
    which the cross-run comparison prices at 0.53 ms on the same cohort. The two repairs landed in
    one commit and the receipts do not separate them; the total is right and the attribution of the
    whole of it to the demotion pass is not receipted.

## The measurements this audit re-ran

Load average 4.3 to 4.5 at the start of the session against the report's 1.9 to 5.7, on the same
host (`grover`), core 5, `choom -n 1000` wrapping every run, one heavy process at a time. Bulk
output under `~/.cache/ergodis/c1202-audit/`.

### The eighteen-cohort census

```sh
choom -n 1000 -- nix develop ~/src/ergodis --command python3 \
  analysis/datalog-comparison/static_index_stages.py \
  --a $C/closure_ballpark-8d43d4e --a-name density-8d43d4e \
  --b $C/closure_ballpark-5217cdb --b-name probes-5217cdb \
  --work ~/.cache/ergodis/c1202-audit/census --index auto --rounds 1 --repeats 1 \
  --count-probes --cohorts $ALL --out ~/.cache/ergodis/c1202-audit/census-audit.json
```

Exit 0, which is itself the assertion: the script raises `SystemExit` when a cohort's output
digest differs or when its derived, probe or candidate counts differ, so running to completion on
all eighteen is the equality claim. Compared field by field against the committed census, **every
arm's kinds, key spaces, masks, total lookups, per-index lookups, digest, derived, probe and
candidate counts are identical** — zero differences over eighteen cohorts and two arms. The
`lookups` equality between arms is not asserted by the script, only the four the report names; it
holds in both receipts.

### The interleaved A/B on five cohorts

The report's replay block with the kept arm `closure_ballpark-5217cdb` against
`closure_ballpark-8d43d4e`, five rounds, three and six repeats, core 5, event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` at 100.00 per cent enabled,
load average 2.89 to 3.05, no failures, work counters equal between the arms on every cohort.

| Cohort | report | this replay | reproduction | report cycles | this replay |
| --- | ---: | ---: | ---: | ---: | ---: |
| `triangle:sparse:4096` | 1.30455 | 1.30454 | **4 ppm** | 0.60147 | 0.60419 |
| `triangle:blocks:4096` | 0.71717 | 0.71717 | **1 ppm** | 0.43392 | 0.42246 |
| `mutual:blocks:4096` | 0.99985 | 1.00010 | **248 ppm** | 0.99187 | 0.97459 |
| `path4:sparse:4096` | 1.00000 | 1.00001 | **3 ppm** | 1.02312 | 1.00405 |
| `closure:blocks:4096` | 1.00001 | 1.00000 | **11 ppm** | 0.98404 | 1.00240 |

The three changed-kind cohorts and one unchanged one reproduce to within eleven parts per million.
`mutual:blocks:4096` moves by 248 ppm, which is the cohort whose own A/A null is 62 ppm in the
report's receipt and 23 ppm here: its reported 0.99985 and this replay's 1.00010 are both a few
nulls from unity, so the finding (an unchanged kind is a null) holds and the figure printed to five
decimals does not. Cycle ratios move by up to 2 per cent under a different load, as the playbook
says they will.

### The core gates at `9edc07b`

| Gate | Command | Outcome |
| --- | --- | --- |
| Suite | `nix develop . --command cargo test --all-features --no-fail-fast -j 8` | exit 0, **82** `test result: ok` blocks, 1,019 tests passed, zero `FAILED` |
| Clippy | `… cargo clippy --all-targets --all-features -j 8 -- -D warnings` | exit 0, clean |
| Format | `… cargo fmt --all -- --check` | exit 0, clean |
| Allocation | `… cargo test -p ergodis-rules --test allocation -j 8` | exit 0, 5 passed, `repeated_n_ary_evaluation_has_no_allocation` included |
| Evidence | `… python3 python/generate_evidence.py --check` | exit 0; `SHA256SUMS` is regenerated in all six core commits |

The 82 blocks and the zero failures are exactly what the report's acceptance table claims. The
private workspace's suite, clippy, fmt and `ruff`, and `compare.py` against Soufflé, were not
re-run here.

## Code read, `crates/rules/src/demand.rs` at `9edc07b`

| Area | Finding |
| --- | --- |
| Mask demotion changes no kernel line, and `OP_CHECK` pre-existed | **Both true.** `30f5c43` touches three files and its `demand.rs` diff is three hunks — the new constant at line 157, the `Self::demote(…)` call inside plan construction, and the two new functions — all of them above the kernels, which begin around line 2200. At `30f5c43^`, `OP_CHECK` is already defined, already produced by `link_ops` for a repeated free variable, and already compared unconditionally at both join sites (`OP_CHECK if vars[op.value] != other[column] => return Ok(0)` in `join`, `=> return false` in `bind_link`), while `OP_KEY` at the same two sites is guarded by `VERIFY`/`verify`. The key folds in `run` and `bucket` match `OP_CONST` and `OP_KEY` and drop everything else into `_ => {}`, so they skip `OP_CHECK` by construction. |
| Property 1: same ascending row order | **Holds, from the builders.** `Index::csr` walks rows `0..count` in order and appends each into its key's cursor, and `Index::sorted` sorts `(key, row)` pairs, so in both kinds a bucket's rows ascend. A demoted bucket is the union of the full-mask buckets that share the surviving key, still in ascending row order, and the `OP_CHECK` filter removes elements without reordering. The emission order is therefore the same sequence for the same delta row. |
| Property 2: a rejected row produces no candidate and no descent | **Holds.** `join` returns `Ok(0)` on an `OP_CHECK` mismatch before `candidates` is incremented or `emit` is called; `bind_link` returns `false` before the descent. `lookups` is incremented once per bucket lookup, above the row loop, so it cannot move either. |
| Property 3: the `row >= limit` break stays exact | **Holds, and is unreachable for a demoted index.** The break is exact because the bucket ascends. It is also never taken: only a relation that never grows demotes, a finite limit is set only for a link *before* the delta atom (`link.old != 0`, or `MODE_FULL` in the two-atom kernel), and for a static relation that limit is `delta_lo`, which is zero in the first round — so the step is skipped as empty — and the full row count in every later round, which no row index reaches. The property is sound and, at the shipped shape, vacuous. |
| Adversarial case for property 2, run | **No defect.** `out(x,y) :- edge(x,y), t(x,y,y).` over a domain of 256 with 760 edges and a `t` holding both `(x,y,y)` and a decoy `(x,y,y+1)` per edge: under `Auto` the fully bound ternary atom demotes from mask 7 (a key space of 2^24, sorted) to mask 1 (256 keys, direct), which is the case where **two** dropped columns carry the *same* bound variable. Work counts, every relation's rows and the certificate bytes are equal to `AutoUndemoted`, `Direct` and `Sparse`, and both checkers accept in every representation; all 760 heads are derived exactly once, so every decoy row is rejected. |
| Adversarial case for the concentrated kept column | **Already covered upstream, and reproduced.** `demotion_is_refused_when_the_demoted_bucket_is_the_whole_relation` in `demand_sparse.rs` is exactly this case. An independent one built here — `s` with column zero constant — behaves the same: `Auto` keeps the sorted mask-3 index and agrees with `AutoUndemoted` on every observable. |
| Highest-first dropping, and whether the most-distinct column would be exact | **Exact, better in one constructible case, and no cohort in the set is affected.** Which columns survive has no bearing on exactness: every dropped column becomes `OP_CHECK` and is compared against each row, and the ascending-order and limit arguments are independent of the choice. In the adversarial case above, column zero is concentrated on one key and column one is not: the prefix rule demotes to column zero, `demotion_pays` measures a bucket of the whole relation and refuses, and a most-distinct-column rule would have demoted with a bucket of one. For the standing cohorts the question is empty — in the `sparse` generator at domain 4,096 column zero has 4,096 distinct values against column one's 3,881 (at 16,384, 16,384 against 15,590), so the prefix rule already keeps the better column, and under `blocks` both columns have every key. The prefix additionally buys the collision with the index the plan already holds, which a distinct-count rule would not guarantee. |
| `evaluate_into` carries no counter | **Confirmed three ways.** `evaluate_into` is `self.evaluate_counting::<false>(workspace)`; every counter site is `if COUNT { … }` on a const generic; the retained binaries carry four `Demand::run_nary` symbols at `ab6be13` (no counter) and at `83bff0a` (counter unconditional) and **eight** at `5217cdb`, which is the `COUNT` monomorphization the report describes, with two `evaluate_counting` bodies of 34,790 and 36,496 bytes. The driver calls `evaluate_counted_into` once after the timed samples, and `static_index_stages.py` adds `--count-probes` only to the evaluate-only arm, so neither the timed loop nor the whole-process figure contains it. `demand_sparse.rs` binds the counter directly: it asserts `lookups == 0` through the production entry point, the counted and uncounted evaluations agree on every other observable, and the totals are 12 and 48 on two hand-computed programs under `Auto`, `Direct` and `Sparse`. |
| `demotion_pays`'s bitmap | **Preparation, bounded, and paid once per `(relation, mask)`.** It runs inside `Demand::prepare`, never in an evaluation. The bitmap is `key_space / 64` words, and `demotion_pays` is reached only after `index_direct` returned true, which requires `key_space <= MAX_DIRECT_KEYS = 2^24`, so the allocation is at most 2 MiB — an eighth of the direct index it is deciding on, as the docstring says, and the `debug_assert` is a restatement of a bound the caller already enforces in release. `9edc07b`'s `pays` vector memoizes the answer per `(relation, candidate mask)`, which is the repair for the second instructive negative. |
| `Demand::estimate_probes` | **Sound, and exact for the reasons the report gives.** For each step it skips `step_is_dead`, takes the delta relation's capacity, adds it to the first link's shape and multiplies by `fan_out` before each later link — the delta rows times the product of earlier fan-outs, as documented. `fan_out` is `rows.div_ceil(min(key_space, rows))`, exact when every key is present *and* the fan-out is uniform, which the `sparse` (three out-edges per node) and `blocks` (a complete block) generators both are; `div_ceil` and the `capacity` of a growing relation both bias upward, which biases towards direct. The independence assumption is the textbook one and the report names it as such. One consequence worth stating: after demotion the shapes are re-slotted and a merged shape's probe count is the **sum** of the links that point at it, so pass three can only raise a demoted shape's probes above the value pass one demoted it on — a demoted mask therefore cannot come back as sorted. |
| The rows floor in `index_direct` | **Exact and one-sided.** `keys <= DIRECT_STATIC_PROBES.saturating_mul(probes.max(1)).max(u64::from(rows))`, inside the `keys <= MAX_DIRECT_KEYS` ceiling and only on the `Auto`/`AutoUndemoted` static branch; `Direct`, `Sparse`, `SparseIndexes` and `SparseMembership` are unchanged lines. With zero estimated probes the threshold is the row count, which is the "direct is the cheaper build whenever the key space is at most the rows" argument, and the saturating multiply plus `power`'s saturation to `u64::MAX` make overflow impossible. |
| `Policy::AutoUndemoted` | **A measurement corner, and it is in the corpus test but not in the allocation gate.** `demand_sparse`'s `agrees` now runs the corpus under four policies and compares work counts, rows and certificate **bytes** for `Auto` against `AutoUndemoted` as well as against `Direct` and `Sparse`. `crates/rules/tests/allocation.rs` still enumerates the five older policies, so the sixth is not covered there. |
| Docstring accuracy | **One stale figure, one imprecision.** `evaluate_counted_into`'s docstring says the unconditional counter cost "**0.11 to 2.55 per cent** … across the seventeen-cohort set". The receipt's range over the set is 0.067 to 2.554 per cent and the set is eighteen cohorts. `DEMOTE_BUCKET_ROWS` reads 7 at `9edc07b` as the report says (16 when the constant landed at `30f5c43`). The `demote` docstring's "the surviving key is a prefix of the atom's columns" is a prefix of the *mask's* columns: a mask that does not start at column zero survives as a subsequence, which weakens the collision argument but nothing else. |

## Prose audit

**The acceptance table is supported by the evidence on every bullet**, with the two qualifications
below. The first bullet's opposite kinds from one constant, the third bullet's four equalities, the
fourth bullet's fifteen unchanged cohorts, the fifth bullet's counter cost and the sixth bullet's
growing-index answer all re-derive from receipts or reproduce live, and the gates reproduce exactly
(82 `test result: ok` blocks, zero failures, clippy and fmt clean, the allocation regression green).
The qualifications are that the allocation regression covers five of the **six** policies — the new
`Policy::AutoUndemoted` is not in it — and that the private workspace's suite and the C1189
differential were not re-run by this audit.

**The unmet `triangle:blocks:4096` bullet is stated as a measured decision, correctly.** The report
says outright that the second acceptance bullet "is not met for this cohort", names the measurement
that decides it (a bucket of fifteen rows against a crossover measured between seven and nine, so
demotion reads 0.637 of preparation plus one evaluation), and prices what the rule takes instead
(a derivation loop of 0.420 and a whole process of 0.965 for 4.4 times the peak resident memory).
Every one of those figures re-derives from a receipt. It then hands the memory decision to Tavis
with the alternative spelled out — moving the constant from 23 to 20 flips that cohort and nothing
else in the set. That is the right shape for an unmet criterion.

**The two instructive negatives are real negatives, reported with their cost, and one of their two
figures does not re-derive.** Both are repairs made by a forward commit at `9edc07b` and both are
kept in the report rather than edited out, which is what the playbook asks. The dead-index defect's
whole-process figure (0.990 against the 0.93 the C1201 sweep predicted) re-derives exactly; its
2.8 ms of preparation does not (the receipts price it at 1.71 ms, and the defect also cost 0.1 to
1.6 ms on four cohorts the report does not mention). The demotion-pass defect's 0.50 ms is right as
a total but is not separated from the first defect by any receipt.

**The mystery ledger is not padded.** Seven settled items and five open ones, each open item with a
named evidence gap and either an owner or a stated cheap next measurement, and the report says
outright that nothing is manufactured. That reading holds: open item 1 (the generic step loop's one
per cent) is a measurement nobody has taken and the report resists claiming it as a win; item 2 is a
constant fitted at one distinct count with the model that says where to fit it next; item 3 is a
stated one-sided weakness; item 4 is a protocol defect with its fix; item 5 is a constant whose
fitted and derived values differ by less than the cohort set can resolve. Three defects in it:
settled item 4 says "eleven cohorts measured inside their A/A nulls" where the table and every other
passage say fifteen; settled item 5's cost model reads the sorted probe as "about twelve dependent
search steps" at 4,096 distinct keys, but the index it replaces is keyed on **both** columns, so its
distinct count is the row count — 12,288 to 61,440, or fourteen to sixteen steps, exactly as the
mechanism paragraph says elsewhere — which puts a search step at about **0.5** of a row read rather
than 0.6 and strengthens the same conclusion that the constant should grow with `log2(distinct)`;
and the closing recommendation points at "the growing-index constant (`DIRECT_INDEX_DENSITY`,
mystery item 4)", which is **settled** item 7, while open item 4 is the demotion sweep's null.

**No `~/.cache` path is cited as evidence.** The Arms table says every hash is recorded as measured
and that the thing to run is the retain recipe at the named revision, and it gives both recipes; the
Resume state repeats the two kept hashes and labels them measured; the cache listing at close is a
listing and is named as one. The replay block's `C=~/.cache/ergodis/bin` is the convenience the
playbook allows, with the retain recipe beside it. Receipts are cited by basename rather than by
their tracked path, which the replay block's `A=analysis/datalog-comparison` resolves.

## Defects, by severity

This list consolidates the findings above into what a repair pass would apply; each item names the
repair. **No code defect.** Demotion's three properties hold, the encoding changes no kernel line, the
production path carries no counter, the rows floor and the probe estimate are one-sided in the
direction they claim, the guard's allocation is bounded plan-time work, and two adversarial cases
built for this audit — a demoted atom whose two dropped columns carry the same bound variable, and
an atom whose prefix column is concentrated — agree with `AutoUndemoted`, `Direct` and `Sparse` on
work counts, rows and certificate bytes.

### Records

1. **`closure:sparse:4096` is in no receipt.** One row of the piece-1 lookup table, introduced as
   the eighteen-cohort set, is a cohort outside `$ALL` that no receipt of this task contains.
   *Repair*: re-run that cohort with `--count-probes` into a receipt, or drop the row and say the
   table is the six cohorts the census covers.
2. **The demotion sweeps' lookup column is mislabelled.** It prints total lookups under the heading
   "lookups into the demoted link"; the demoted link's own counts are the receipt's
   `index_lookups[1]`, 36,864 rising to 921,600. *Repair*: print `index_lookups[1]` and rename the
   column, or rename it "lookups, all links".
3. **"Preparation agrees to 0.5 per cent at every point of the `triangle` sweep" is false.** The
   receipt's ratios span 0.976 to 1.038. *Repair*: "agrees to within 4 per cent with the sign
   alternating, so the build difference is inside preparation's noise on this family".
4. **The dead-index negative's 2.8 ms does not re-derive; the receipts price it at 1.71 ms**, and
   the defect also cost 0.106 to 1.575 ms on four other cohorts. *Repair*: print the cross-run
   difference with both receipts named, and add the four cohorts.
5. **The A/A null bound quoted for the fifteen unchanged cohorts, 2.7 parts per hundred thousand,
   excludes the worst of them** — `mutual:blocks:4096` at 6.2 — and it is quoted three times.
   *Repair*: say 6.2, and note that this cohort's 0.99985 is about two of its own nulls from unity.
6. **The unconditional counter's range is quoted as 0.11 to 2.55 per cent**; the receipt's low end
   over the set is 0.067 per cent on `closure:dense:512`, which is in the report's own table. The
   same figure and a "seventeen-cohort set" are in the shipped `evaluate_counted_into` docstring.
   *Repair*: 0.067 to 2.554 per cent over eighteen cohorts, in the report and the docstring.
7. **"The branch counts moved by the same fraction as the instruction counts" overstates it.**
   Branches moved 1.4 to 4.0 per cent against instructions' 0.07 to 2.6, and `path4:sparse:4096` —
   called "almost nothing" — moved 0.11 per cent in instructions and 1.38 in branches. *Repair*:
   give both ranges; the inference is stronger, not weaker.
8. **Three of the four growing-index lookup counts carry no receipt**, because `ab.py` records no
   lookup counter; only `cycle:blocks16:4096`'s 69,632 is receipted, through the census. *Repair*:
   say the counts were read by hand from `--count-probes` runs, or add `--count-probes` to `ab.py`.
9. **The Method section's `choom -n 1000` is not true of the `ab.py` receipts.** The two stage and
   sweep scripts wrap the binary in `choom`; `ab.py` never has. *Repair*: say which runs are under
   it, or add it to `ab.py`.
10. **Small record slips.** The per-stage table's `triangle:sparse:16384` RSS ratio is 0.999, not
    1.000, and `mutual:blocks:4096`'s preparation ratio is 1.005, not 1.004; the quoted per-stage
    load of 2.29 is one cohort's field and the run spans 2.27 to 2.33; the per-evaluation
    instruction table carries no receipt and, unlike the baseline table, does not say so; the
    demotion-pass negative's 0.50 ms is not separated from the dead-index negative by any receipt.
11. **The arms table's Core column rests on the session.** `MANIFEST.tsv` records only the private
    revision, and the re-pin commit `531f19b` does not name the core revision it pins. *Repair*:
    name the revision in the re-pin message, or have `retain-bin.sh` record the core checkout's
    revision beside the crate's.

### Prose

12. **"Eleven cohorts measured inside their A/A nulls"** in settled mystery item 4, against fifteen
    everywhere else. *Repair*: fifteen.
13. **The demotion cost model's distinct count is the domain, not the index's.** Settled item 5 and
    the piece-2 closing paragraph read the sorted probe as twelve dependent steps at 4,096 distinct
    keys; the index being replaced is keyed on both columns and holds one key per row, so it is
    fourteen to sixteen steps and a search step costs about 0.5 of a row read. *Repair*: use the row
    count, print 0.5, and keep the `log2(distinct)` conclusion, which the correction strengthens.
14. **The closing recommendation points at the wrong ledger item.** "The growing-index constant
    (`DIRECT_INDEX_DENSITY`, mystery item 4)" is settled item 7; open item 4 is the demotion sweep's
    null, and the work being recommended is queued candidate 2, locating the growing crossover on
    the kept arm. *Repair*: name candidate 2 and settled item 7.
15. **"The allocation regression green under all five policies"** — there are six now, and
    `Policy::AutoUndemoted` is not in `allocation.rs`. *Repair*: say five of six, and add the sixth
    to that gate, which is one line.
16. **The piece-1 lookup table does not say which plan its per-index split belongs to.** It is the
    undemoted control's, which is the right choice for a table about what the counter measured, but
    the kept arm's split for `triangle:sparse:4096` is `49,152 · 0` rather than
    `12,288 · 36,864 · 0`. *Repair*: name the arm in the caption.

## What this audit left under `~/.cache/ergodis/`

`c1202-audit/`, 35 MB: the census replay (`census/`, `census-audit.json`), the five-cohort A/B
replay (`ab-audit/`, `ab-audit.json`), the four gate logs, the `adversarial/` scratch crate with its
own `target/` under the same directory. Nothing was deleted and no cache entry was garbage
collected; deletion is Tavis's call. Nothing was written to any of the three repositories except
this file, and nothing was committed.

