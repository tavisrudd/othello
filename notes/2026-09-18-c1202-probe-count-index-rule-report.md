# C1202 — the probe-count index rule, mask demotion and the per-link probe counter

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: IN PROGRESS. Written incrementally from the start, so a crash leaves a partial record
rather than none. The Fermi predictions below were written and committed **before any code change**.

Task card: `notes/2026-09-18-c1202-probe-count-index-rule.md`. Predecessor:
`notes/2026-09-17-c1201-static-index-build-cost-report.md` and its audit
`notes/2026-09-17-c1201-static-index-build-cost-audit.md`, whose closeout named all three pieces of
this task. Repositories: `~/src/ergodis` (core, the evaluator), `~/src/ergodis-private` (the driver
and the harnesses), `~/src/ergodis-dev` (`PERFORMANCE.md`, the playbook, `retain-bin.sh`,
`cache-gc.sh`), `~/src/othello` (this report).

## Arms

Every hash below is recorded **as measured**, never cited: the thing to run is the retain recipe at
the named revision. Both controls were retained **before the first source change of this task**,
from trees whose `git status --short` was empty, checked in the same command that read the
revisions.

Retain recipes, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

Both re-execute themselves inside `nix develop` of the core checkout, whose devShell asserts its
rustc equals the `rust-toolchain.toml` pin. rustc 1.95.0 (59807616e 2026-04-14), release profile, no
features, on every row.

| Arm | Role | Private | Core | Dirty | Retained name | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, derivation loop | the kernel A/B for piece 1 | `ab6be13` | `5c9d1b3` | no | `closure_ballpark-ab6be13` | `c9089cf046d495cd0150899208c22d9c5380aeb92b2bf80398ef2174efb43077` |
| control, frontend and stratified backend | the Rel route | `ab6be13` | `5c9d1b3` | no | `ergodis-tools-ab6be13` | `d6495328d7aa8d6e675d31d6622365a9312cf108e28a78f6ed4084a73b12dc69` |
| candidate, piece 1 carried unconditionally | the counter's own cost | `83bff0a` | `2904489` | no | `closure_ballpark-83bff0a` | `c238685a743c4d1a8915f8d3fc1dd01f05bff19d1ce6ccc76f87fc28508fabb8` |
| candidate, piece 1 monomorphized | the kept shape, and piece 2's control | `8d43d4e` | `2dbb356` | no | `closure_ballpark-8d43d4e` | `cd3d1726f602ba7154cf8ea960f709c0b79351ed7ed6433f74eadbf261c25935` |

C1201 named `closure_ballpark-8c04b7a` and `ergodis-tools-8c04b7a` as this lane's next controls.
Both trees have since moved — core `676f513` → `5c9d1b3` (a doc comment and `SHA256SUMS`) and
private `8c04b7a` → `ab6be13` (`compare.py`'s version capture) — so the playbook's "retain at the
revision the tree actually carries" applies and the pair above is retained fresh. The two
`closure_ballpark` binaries do **not** hash equal even though no line either kernel executes
changed, which is recorded here as an observation and tested in the results as a cross-binary A/A
null rather than assumed away.

Candidate arms are added to this table as they are retained.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `f19c82c35` | the report skeleton, the reproduced baseline and the Fermi predictions, written before any code |
| `ergodis` | `2904489` | the per-link probe counter, carried unconditionally |
| `ergodis-private` | `83bff0a` | the driver reports it |
| `ergodis` | `2dbb356` | the counter is monomorphized on a `COUNT` const and `evaluate_into` dispatches to the uncounted instantiation |
| `ergodis-private` | `df2f5f4` | `--count-probes`, one extra counted evaluation outside the timed loop |
| `ergodis-private` | `8d43d4e`, `42d1852` | the two receipts |
| `othello` | this report | written incrementally at each milestone |

## The baseline this task starts from, reproduced

Retained control `closure_ballpark-ab6be13`, pinned to core 5 under `choom -n 1000`, n-ary bodies,
five in-process evaluations, taken by hand before any code change. **No receipt**: it predates this
task's measurement stages and exists to ground the Fermi predictions. It replays with

```sh
C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1202
for ix in auto direct; do for spec in "triangle 4096 sparse" "triangle 4096 blocks" "mutual 4096 blocks"; do
  set -- $spec
  taskset -c 5 choom -n 1000 -- $C/closure_ballpark-ab6be13 --evaluator demand \
      --evaluate-only --bodies nary --index $ix --program $1 $2 $3 5 $W/smoke
done; done
```

| Cohort | `--index auto` kinds | preparation | evaluation | peak RSS | preparation + one evaluation | `--index direct` preparation | `--index direct` evaluation | direct ÷ auto, preparation + one evaluation |
| --- | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `triangle:sparse:4096` | `dsd` | 3.040 ms | 2.052 ms | 5,824 KiB | 5.09 ms | 29.440 ms | 1.296 ms | 6.04 |
| `triangle:blocks:4096` | `dsd` | 17.995 | 53.038 | 19,004 | 71.03 | 43.446 | 22.424 | **0.928** |
| `mutual:blocks:4096` | `s` | 16.161 | 3.264 | 18,452 | 19.43 | 42.568 | 1.627 | **2.27** |

The two `blocks` rows reproduce C1201's closeout to within 2 per cent (it read 0.932 and 2.49 on
seven rounds against these five-repeat single-round figures), which is the check that this session
measures the same machine C1201 measured.

**Per-evaluation instruction counts**, two-point differenced between `repeats` and `2 · repeats` on
the same control, which is what the Fermi predictions below are fractions of:

| Cohort | kernel | repeats | instructions per evaluation |
| --- | --- | ---: | ---: |
| `triangle:sparse:4096` | n-ary, one live step of two links | 9 / 18 | 15,410,577 |
| `triangle:blocks:4096` | n-ary, one live step of two links | 3 / 6 | 486,113,555 |
| `mutual:blocks:4096` | two-atom | 9 / 18 | 29,242,654 |

**One live step, not three.** `triangle` has three semi-naive steps and `mutual` two, one per body
position, and all of their body atoms are the static relation `edge`. A step whose body has an atom
**before** the delta atom reads that atom's `delta_lo`, which is zero for a relation that never
grows, so `evaluate_into` skips it: only the step with the delta at body position 0 ever runs. That
is why the measured top-level `probes` counter is 12,288 and 61,440 — the fact count — rather than
three and two times it, and it is what makes C1201's derived per-index probe figures
(`rows × 3` and `rows × 15`) the right derivation. The counter built here checks that derivation
instead of trusting it.

## Fermi predictions, written before any code

Written from the compiled shape of `crates/rules/src/demand.rs` at core `5c9d1b3`, the baseline
table above, and C1201's measured host coefficients (about 61 GiB/s of warm streaming store
bandwidth, about 20 GiB/s cold, about 400 ns for one minor fault).

### Prediction 1: the per-link probe counter's own cost

A "probe" in the sense the cost model needs is one **bucket lookup** at one body-atom link: the
`match KIND` block of `Demand::run` for a two-atom step, and each `Demand::bucket` call of
`Demand::run_nary` for an n-ary one. Per evaluation the cohorts do

| Cohort | level 0 lookups | level 1 lookups | total bucket lookups |
| --- | ---: | ---: | ---: |
| `triangle:sparse:4096` | 12,288 | 36,864 | 49,152 |
| `triangle:blocks:4096` | 61,440 | 921,600 | 983,040 |
| `mutual:blocks:4096` | 61,440 | — | 61,440 |

**Two-atom kernel.** The count of lookups is the count of delta rows that pass the delta atom's
`bound` test, so the counter is one `u64` register increment beside the `probes += 1` that loop
already carries, on a path that has no other work. **Predicted one instruction per lookup**:
61,440 instructions on 29,242,654, or **0.21 per cent**, and plausibly less because the increment
retires in a slot the dependent bucket load leaves empty.

**n-ary kernel.** The lookup sites are the two `self.bucket(…)` calls, each of which already writes
`cursor[level]` and `end[level]`, so a `[u64; MAX_BODY]` counter indexed by `level` lands on a stack
line that is already hot. A load, an add and a store: **predicted three instructions per lookup**,
so 147,456 on 15,410,577 (**0.96 per cent**) at `triangle:sparse:4096` and 2,949,120 on 486,113,555
(**0.61 per cent**) at `triangle:blocks:4096`. This is the prediction most likely to force a
decision: if it measures at or above about one per cent the counter moves behind a const-generic
instrumentation switch on the out-of-line n-ary kernel, which costs the production instantiation
nothing and risks only the four extra out-of-line monomorphizations. Below about half a per cent it
stays unconditional, because it is then in the same class as the `probes` and `candidates` counters
the loop already carries and it enters the work-count parity contract as they do.

**Per-index attribution costs nothing in the loop.** The kernels return their per-level counts and
`evaluate_into` folds them into a per-index array once per step per round, which is the playbook's
"accumulated cheaply and reconciled once at a boundary".

**`lookups` is policy-invariant, which is why it belongs in `Evaluation`.** One lookup happens per
delta row that binds and per descent into a deeper level, and neither depends on the addressing
kind; `demand_sparse`'s `agrees` compares whole `Evaluation` values across `Auto`, `Direct` and
`Sparse` over the corpus, so adding the field makes the corpus test bind it.

### Prediction 2: mask demotion needs no kernel change at all, and the card's shape is not the
cheapest one

The card prices demotion as an op kind the key fold skips plus `join::<VERIFY = true, _>`
instantiated for the CSR arm. **There is a cheaper encoding that already exists in the plan**, and
it is worth stating before the code because it changes what the A/B can be expected to show.

A fully bound atom's column that holds an already-bound variable carries `OP_KEY`, which the key
folds in `Demand::run` and `Demand::bucket` multiply into the packed key and which `Demand::join`
and `Demand::bind_link` compare against the matched row **only under `VERIFY`**. The plan's existing
`OP_CHECK` carries exactly the other half of that pair: the key folds skip it (it falls into their
`_ => {}` arm) and `join` and `bind_link` compare it against the row **unconditionally**. So
demoting a bound-variable column out of the index mask is precisely `OP_KEY → OP_CHECK` plus
clearing that column's mask bit, and **not one line of either kernel changes**. No new op kind, no
new addressing kind, no new instantiation, no new storage.

Three consequences, all checkable:

1. Every cohort whose plan does not demote executes byte-identical code, so its instruction ratio is
   within the A/A null **by construction** rather than by measurement — the same status C1201's
   fifteen unchanged cohorts had.
2. The work counters are invariant under demotion. A demoted bucket holds rows of other values in
   the dropped column; `join` rejects them before producing a candidate and `bind_link` rejects them
   before descending, which is the same treatment a repeated variable's equality check already gets.
   So `derived`, `candidates`, the new `lookups` and the output digest are all unchanged, and the
   parity assertions are exact rather than approximate.
3. A demoted mask often **collides with an index the plan already holds**. `triangle`'s third atom
   `edge(z,x)` demotes to a key on column 0, which is the mask `edge(x,y)`'s index already carries,
   so the plan drops from three indexes to two and the demoted atom's index costs nothing to build
   at all.

**Predicted for `triangle:sparse:4096`.** The demoted index is 4,096 keys, 16 KiB of offsets, shared
with index 0. Preparation falls to admission plus two small direct builds: C1201 measured this
cohort's per-fact preparation at 177 ns over 12,288 facts, so **2.1 to 2.4 ms**, against 3.040 today
and 29.44 forced direct. The probe becomes one load into a 16 KiB array that sits in L1, then three
rows read from a 48 KiB row array and three `OP_CHECK` comparisons, where the sorted arm does a
13.6-iteration dependent binary search over 96 KiB and the direct arm one load into 64 MiB.
36,864 level-1 lookups × two extra row reads ≈ 74,000 extra row reads. **Predicted evaluation at or
below the forced-direct 1.296 ms**, so a ratio of **0.60 to 0.70 against today's `auto`** and
**0.95 to 1.10 against forced direct** — which is the card's unmet C1201 criterion, met.

**Predicted for `triangle:blocks:4096`.** The demoted bucket holds fifteen rows where one matches, so
921,600 lookups pay fourteen extra row reads each: **12.9 million extra row reads** into a 480 KiB
row array, at roughly one to two nanoseconds each, is **13 to 26 ms** on top of the forced-direct
22.42 ms. **Predicted evaluation 35 to 48 ms**, between the 22.42 direct and the 53.04 sparse rows,
with preparation at about 11.7 ms (61,440 facts × 190 ns) against 17.995 today and 43.45 direct.
**Predicted preparation plus one evaluation 47 to 60 ms against 71.03 today and 65.87 forced
direct**, so demotion is predicted to win end to end on this cohort while **losing the derivation
loop** against forced direct by 1.6 to 2.1 times.

**Predicted for `mutual:blocks:4096`.** 61,440 lookups × fourteen extra row reads ≈ 860,000, about
1 to 2 ms on top of the forced-direct 1.627 ms, so evaluation **2.5 to 3.6 ms** against 3.264 today
and preparation about **11.7 ms** against 16.161. **Predicted preparation plus one evaluation 14 to
15 ms against 19.43 today and 44.20 forced direct.**

So demotion is predicted to be the best of the three representations end to end on **all three**
cohorts, and the risk it carries is the one the bucket size names: a relation whose demoted buckets
are large pays the extra row reads without bound. That is why the demotion decision below is
guarded and the guard's constant is measured rather than assumed.

### Prediction 3: what the measured probe counter will do to C1201's fitted `K`

C1201 fitted `K ≈ 23` on `key_space / probes` from probe counts **derived from the generators'
out-degree**, and the derivation assumed the fully bound index is probed `rows × out-degree` times.
Prediction 1's step analysis says that derivation is right — one live step per program — so
**`K ≈ 23` is predicted to survive the counter**, and the counter's value is that it turns an
assumption into a measurement over the whole cohort set rather than over the two families the
derivation was written for. The three cohorts' ratios are predicted to come out at C1201's values:
`triangle:sparse` crossover ≈ 23.1, `triangle:blocks:4096` = 18.2, `mutual:blocks:4096` = 273.1.

If instead the counter reads three times the derived figure on `triangle` and twice it on `mutual` —
the "all steps run" reading — then `K` divides by roughly that factor and every fitted number in
C1201's cost-model table moves. The measurement decides; the prediction is that it does not move.

### Prediction 4: the estimate the plan can compute, and where it is exact

The plan estimates the probes into one index as, summed over every step and every link that uses it,
the delta relation's row count times the product of the average fan-out of each **earlier** link in
that step's join order, with fan-out estimated as `rows / min(key_space, rows)`.

- The **first** level is exact for a step whose delta relation never grows: the delta scan is the
  relation's fact count. For a growing delta relation the plan has only the row bound, which is
  `2^24` by default, so the estimate is a gross overestimate and biases that index towards direct —
  the cheap-probe, expensive-build side. Predicted effect on the cohort set: none, because every
  static index in the `closure`, `samegen`, `path3` and `path4` families has a key space of `domain`
  against `domain` or `3 · domain` rows and is direct under any rule.
- The fan-out estimate `rows / min(key_space, rows)` is **exact whenever every key of the mask is
  present**, which is true of all three generators: `edge` on one column at the `sparse` density is
  12,288 rows over 4,096 keys, so 3; at `blocks` 61,440 over 4,096, so 15; at `dense` `domain/4`.
- The step-skipping of prediction 1 is **not** in the estimate: a plan that estimated every step as
  live would overestimate `triangle` threefold and `mutual` twofold. Predicted resolution: the
  estimate skips a step exactly as `evaluate_into` does, when the step has a link before the delta
  atom on a relation that never grows, which is a plan-time property.

**Predicted agreement with the measured counter: exact on every cohort in the C1201 set.** Any
disagreement is a defect in one of the three bullets and is reported as such.

### Prediction 5: `DIRECT_INDEX_DENSITY = 48` and whether one constant replaces both

A growing index is rebuilt every round, so its build cost is `key_space` words of reset traffic per
**round** rather than once per plan, while its saving is still one probe's worth per lookup. The
same proxy-versus-cause argument therefore applies, with rounds as an extra factor: the crossover
should be on `key_space · rounds / probes` rather than on `key_space / rows`. **Predicted: the two
constants do not merge**, because the static rule's `key_space / probes` has no rounds in it, and a
single constant would have to absorb a round count that varies from 2 to hundreds across the cohort
set. The measurement that decides is two workloads with equal density and different probes per
round into a growing index.

## Method (binding)

`~/src/ergodis-dev/PERFORMANCE.md` and `~/src/ergodis-dev/performance-playbook.md`, both read in
full before any edit. Event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`
at 100 per cent enabled, cache events in their own run. Rounds alternate arm order with an A/A null
per cohort. Pinned to core 5 under `choom -n 1000`. Keep or revert by commit. Bulk output under
`~/.cache/ergodis/c1202/`.

## Results

### Piece 1: the per-link probe counter

**What it counts and what it read.** One increment per bucket lookup at one body-atom link, in
total as `Evaluation::lookups` and split by index as `Demand::index_lookups`. Measured on the
eighteen-cohort set through the driver's new `--count-probes`:

| Cohort | kernel | top-level `probes` | bucket lookups | per index |
| --- | --- | ---: | ---: | --- |
| `triangle:sparse:4096` | n-ary | 12,288 | 49,152 | 12,288 · **36,864** · 0 |
| `triangle:blocks:4096` | n-ary | 61,440 | 983,040 | 61,440 · **921,600** · 0 |
| `mutual:blocks:4096` | two-atom | 61,440 | 61,440 | **61,440** |
| `closure:sparse:4096` | two-atom | 15,691,854 | 15,679,566 | 15,679,566 · 0 |
| `cycle:blocks:4096` | two-atom | 196,608 | 135,168 | 65,536 · 0 · **69,632** |
| `path4:sparse:4096` | n-ary | 12,288 | 159,744 | 159,744 · 0 |

**Fermi prediction 3 holds, and C1201's derived probe figures were right.** The fully bound index
of `triangle:sparse:4096` is probed 36,864 times, which is `rows × 3`, and of
`triangle:blocks:4096` 921,600 times, which is `rows × 15`; `mutual:blocks:4096`'s is probed 61,440
times, which is `rows`. Those are exactly the three numbers C1201's cost model derived from the
generators' out-degree, so `key_space / probes` is 1,365.3, 18.2 and 273.1 as it reported, and the
fitted `K ≈ 23` is unchanged by the measurement. The counter turns the derivation into an
observation, and it did not move it.

**The counter's own cost, which is the reason it is an instrument and not a resident counter.**
Carried unconditionally — one `u64` increment in the two-atom kernel and one `[u64; MAX_BODY]`
increment per level in the n-ary one — the A/B against the retained control read:

| Cohort | instructions, unconditional counter ÷ control | interval | A/A null | Δ instructions per lookup |
| --- | ---: | --- | ---: | ---: |
| `closure:sparse:256` | 1.01461 | [1.01460, 1.01462] | 1.0000021 | 9.05 |
| `closure:dense:512` | 1.00067 | [1.00067, 1.00067] | 1.0000000 | 10.49 |
| `samegen:sparse:1024` | 1.02279 | [1.02278, 1.02279] | 0.9999998 | 8.52 |
| `cycle:blocks:4096` | 1.00792 | [1.00789, 1.00794] | 0.9999948 | 10.08 |
| `mutual:blocks:4096` | 1.01470 | [1.01454, 1.01487] | 0.9999398 | 7.00 |
| `triangle:sparse:4096` | 1.02554 | [1.02539, 1.02570] | 1.0000581 | 8.01 |
| `path4:sparse:4096` | 1.00114 | [1.00112, 1.00117] | 1.0000026 | 0.80 |

Receipt `ab-2026-09-18-c1202-probe-counter.json`, five rounds of three and six repeats, event set at
100.00 per cent enabled, load average 2.17 to 2.33 recorded by the receipt. The full set ranges
**1.00114 to 1.02554** in instructions.

**This refutes Fermi prediction 1, and the refutation is the useful part.** The prediction was one
instruction per lookup in the two-atom kernel and three in the n-ary one. The measurement is
**seven to ten and a half instructions per lookup** on six of the seven cohorts and **0.80** on the
seventh, and the branch counts moved by the same fraction as the instruction counts — which an
unconditional register increment cannot do. So the cost is not the counter's arithmetic. It scales
with lookups because the increment sits beside the four-op key fold that runs once per lookup, and
about eight instructions is what that fold costs: the counter displaced the fold's code rather than
adding to it. `path4:sparse:4096` shows the same change costing almost nothing in the `BODY = 4`
monomorphization, which is the tell that this is register allocation and inlining rather than work.
**The cost model was wrong in the way the playbook says to treat as a cost-model failure rather than
as something to shave**, so the shape changed instead of the constant.

**The kept shape: the counter is monomorphized.** `Demand::run` and `Demand::run_nary` take a
`COUNT` const, `evaluate_into` dispatches to the uncounted instantiation, and
`evaluate_counted_into` is the instrumented twin. That is `PERFORMANCE.md`'s third invariant
applied to instrumentation, and the card's own hedge. The driver's `--count-probes` runs **one
extra counted evaluation outside the timed loop**, so the loop every harness times is the
production one and two-point differencing removes the extra evaluation from every per-iteration
figure.

**The production path against the control**, receipt
`ab-2026-09-18-c1202-probe-counter-const.json`, five rounds of three and six repeats, event set at
100.00 per cent enabled, load average 2.71 to 4.49:

| Cohort | instructions, candidate ÷ control | interval | A/A null | cycles |
| --- | ---: | --- | ---: | ---: |
| `closure:sparse:256` | 0.99185 | [0.99184, 0.99187] | 1.0000013 | 0.99074 |
| `closure:sparse:1024` | 0.99190 | [0.99190, 0.99191] | 0.9999996 | 0.98835 |
| `closure:dense:256` | 0.98399 | [0.98399, 0.98400] | 0.9999960 | 0.97007 |
| `closure:dense:512` | 0.98367 | [0.98367, 0.98367] | 1.0000003 | 0.97430 |
| `samegen:sparse:1024` | 1.00122 | [1.00122, 1.00122] | 0.9999992 | 1.00587 |
| `samegen:dense:512` | 0.99877 | [0.99877, 0.99877] | 1.0000003 | 1.01752 |
| `closure:blocks:4096` | 0.98571 | [0.98569, 0.98574] | 1.0000058 | 1.07854 |
| `closure:blocks:16384` | 0.98504 | [0.98501, 0.98506] | 0.9999931 | 1.09054 |
| `cycle:blocks:4096` | 0.98466 | [0.98463, 0.98469] | 0.9999813 | 1.07228 |
| `triangle:sparse:16384` | 0.99693 | [0.99685, 0.99701] | 0.9999930 | 1.00773 |
| `path3:sparse:4096` | 0.99107 | [0.99098, 0.99116] | 0.9999892 | 0.99546 |
| `path3:sparse:16384` | 0.98618 | [0.98616, 0.98620] | 1.0000159 | 1.03786 |
| `path4:sparse:4096` | 0.99969 | [0.99968, 0.99970] | 0.9999950 | 1.08346 |
| `path4:sparse:16384` | 0.99975 | [0.99974, 0.99976] | 0.9999942 | 1.00581 |
| `mutual:blocks:4096` | 0.99167 | [0.99145, 0.99189] | 1.0000022 | 1.03423 |
| `mutual:blocks:8192` | 0.98854 | [0.98841, 0.98866] | 1.0000624 | 1.02640 |
| `triangle:sparse:4096` | 0.99679 | [0.99670, 0.99688] | 1.0000101 | 0.97449 |
| `triangle:blocks:4096` | 0.99431 | [0.99430, 0.99432] | 0.9999990 | 1.00280 |

Every output digest, derived count, probe count and candidate count is equal between the arms on all
eighteen cohorts; the receipt records no failures.

**Seventeen of the eighteen cohorts come out cheaper than the control, by 0.03 to 1.63 per cent, and
that is not a win this change designed.** The production instantiation executes the same operations
the control did — the counter, its register and the reconciliation are all absent — so a ratio of
0.984 is a **codegen effect of making the step loop generic**, of the same family and the same size
as the two C1193 measured (2.6 to 3.9 per cent from adding instantiations of a generic kernel, 1.7
per cent from a driver-only change under ThinLTO). It is recorded as an unexplained gain rather than
claimed, and it goes in the mystery ledger. What the table does establish is the thing the
acceptance bullet asks for: **the per-link probe counter costs the production derivation loop
nothing**, and the eighteen A/A nulls, all within 6.2 parts per hundred thousand of unity, say the
protocol is sound.

### Piece 2: mask demotion, and the crossover that decides it

**The built shape is cheaper than the card's, and it changes no kernel line.** The card priced
demotion as a new op kind the key fold skips plus `join::<VERIFY = true, _>` instantiated for the
CSR arm. The plan already carries both halves of that pair: `OP_KEY` is folded into the packed key
and compared against the matched row only under the verify flag, and `OP_CHECK` is skipped by the
fold and compared unconditionally by `Demand::join` and `Demand::bind_link`. So demoting a bound
column is `OP_KEY → OP_CHECK` plus one mask bit, entirely inside plan construction. No new op kind,
no new addressing kind, no new instantiation of either kernel, no new storage, and every cohort
whose plan does not demote executes byte-identical code. The `VERIFY = true` instantiation the card
asked for is **not built**, and this is why: it would have added two monomorphizations of an
`inline(always)` kernel to `evaluate_into`, which is the shape C1193 measured at 3.9 per cent on
cohorts that never enter the new code.

**The surviving key is a prefix, which makes the demoted index free more often than not.**
`triangle`'s third atom `edge(z,x)` demotes to a key on column zero, which is the mask
`edge(x,y)`'s index already carries, so the plan drops from three indexes to two and the demoted
atom's index costs nothing at all to build.

**The crossover, measured.** The `blocks<N>` density added to the driver puts `N` nodes in each
complete block, so the out-degree is `N − 1` and that is exactly the average bucket a demoted index
holds. `Policy::AutoUndemoted` is `Auto` with demotion alone switched off, so both sides run on one
binary and differ in that one decision — the same reason `SparseIndexes` and `SparseMembership`
exist. Retained arm `closure_ballpark-d037e2a`, three rounds of five repeats, receipt
`sweep-2026-09-18-c1202-demotion-triangle.json`, `triangle` at domain 4,096:

| density | bucket `b` | facts | lookups into the demoted link | undemoted preparation | undemoted evaluation | demoted preparation | demoted evaluation | undemoted ÷ demoted, preparation + one evaluation |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `blocks4` | 3 | 12,288 | 49,152 | 2.906 ms | 2.253 ms | 2.912 ms | 1.394 ms | **1.1983** |
| `blocks6` | 5 | 20,472 | 122,808 | 5.098 | 6.796 | 5.294 | 4.987 | **1.1570** |
| `blocks8` | 7 | 28,672 | 229,376 | 5.342 | 8.966 | 5.502 | 8.655 | **1.0106** |
| `blocks10` | 9 | 36,840 | 368,280 | 7.252 | 14.604 | 7.292 | 16.183 | **0.9310** |
| `blocks12` | 11 | 45,024 | 540,192 | 8.472 | 21.089 | 8.271 | 27.628 | **0.8234** |
| `blocks14` | 13 | 53,200 | 744,464 | 9.682 | 29.173 | 9.527 | 44.262 | **0.7223** |
| `blocks16` | 15 | 61,440 | 983,040 | 12.268 | 38.191 | 12.209 | 66.961 | **0.6373** |

The same sweep on `mutual`, receipt `sweep-2026-09-18-c1202-demotion-mutual.json`, whose two-atom
step probes the index once per fact rather than once per two-path:

| density | bucket `b` | facts | lookups | undemoted evaluation | demoted evaluation | undemoted ÷ demoted, preparation + one evaluation |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `blocks4` | 3 | 12,288 | 12,288 | 0.631 ms | 0.387 ms | **1.0924** |
| `blocks8` | 7 | 28,672 | 28,672 | 1.523 | 1.310 | **1.0073** |
| `blocks12` | 11 | 45,024 | 45,024 | 2.446 | 2.579 | **0.9839** |
| `blocks16` | 15 | 61,440 | 61,440 | 2.359 | 3.431 | **0.9196** |
| `blocks24` | 23 | 94,080 | 94,080 | 3.801 | 3.958 | 0.9713 |
| `blocks32` | 31 | 126,976 | 126,976 | 5.205 | 5.390 | 0.9757 |

**`DEMOTE_BUCKET_ROWS` is set to 7**, the largest bucket at which demotion is measured ahead on both
families. The `triangle` sweep brackets the crossover between a bucket of 7 (1.0106) and 9 (0.9310)
and linear interpolation puts it at about 7.3; the `mutual` sweep brackets it between 7 (1.0073)
and 11 (0.9839).

**The last two `mutual` rows are this sweep's null and they are not tight.** At buckets of 23 and 31
the guard already refuses demotion, so both arms build the identical plan on the identical binary,
and they read 0.9713 and 0.9757 rather than unity. Three rounds alternate the arm order 2:1, which
biases the arm that runs first in a majority of rounds; the crossover rows are read against that
null, and the 1.0073 at a bucket of 7 is 3.4 per cent above it while the 0.9839 at 11 is 1.0 per
cent above it. **On the null-corrected reading `mutual`'s crossover is past a bucket of 11**, so 7
is conservative for that family. An even round count fixes the protocol and is a queued candidate.

**Why this constant is a bucket size while the index rule is not a density.** Demotion is only
reached when the undemoted mask would be held sorted, so the comparison is one probe against one
probe: `rows / distinct` row reads out of a contiguous bucket against a binary search over the
distinct keys plus one row read. **The probe count cancels**, which is exactly what did not happen
in C1201's density. And the build difference — a sort of the rows against a counting sort over the
demoted key space — sits inside the noise of preparation on this family: the two arms' preparation
agrees to 0.5 per cent at every point of the `triangle` sweep. So what is left is a bound on the
bucket, and the constant closes the cost model: at 4,096 distinct keys the search is about twelve
dependent steps, the crossover is between 7 and 9 row reads, so **a binary-search step costs about
0.6 of a row read on this host**. That also says the constant should grow with `log2(distinct)`
rather than being flat, which is an open item.

### Piece 3: the rule on estimated probes

`DIRECT_STATIC_DENSITY = 64` is replaced by `DIRECT_STATIC_PROBES = 23`, applied as
`key_space <= DIRECT_STATIC_PROBES · estimated_probes` in `Policy::Auto`'s static branch.
`DIRECT_INDEX_DENSITY = 48` keeps the growing branch.

**The estimate.** For each join index, summed over every step and every link that uses it: the delta
relation's row count times the product of the average fan-out of each **earlier** link in that
step's join order, with the fan-out estimated as `rows / min(key_space, rows)` and a step that can
never run contributing nothing. Nothing can decide an index's kind until every step is known, so
`Demand::prepare` now builds index **shapes** and then makes three passes over them: estimate the
probes, demote the masks the estimate says will not be addressed directly, re-slot and estimate
again, then materialize. Demotion never moves a probe count — a row a demoted bucket yields and the
join rejects produces no descent — which is what lets the first estimate decide the demotion without
a fixed point.

**The dead-step rule is part of the estimate and it matters by a factor of three.** A step whose
delta relation never grows can only run in the first round, and in the first round every relation's
`delta_lo` is zero, so a body atom **before** the delta atom bounds it to no rows and
`evaluate_into` skips it. `triangle` has three steps and `mutual` two; one of each ever runs. An
estimate that counted them all would be three and two times too large and would put every ratio on
the wrong side of the constant.

**The estimate against the measured counter**, on the cohorts whose static index the rule decides:

| Cohort | index | key space | estimated probes | measured lookups | `key_space` ÷ probes | rule | C1201's measured right answer |
| --- | --- | ---: | ---: | ---: | ---: | :---: | --- |
| `triangle:sparse:4096` | `edge` on both columns | 16,777,216 | 36,864 | 36,864 | 455.1 | demote | — |
| `triangle:blocks:4096` | `edge` on both columns | 16,777,216 | 921,600 | 921,600 | 18.2 | **direct** | direct, 0.932 |
| `mutual:blocks:4096` | `edge` on both columns | 16,777,216 | 61,440 | 61,440 | 273.1 | **sparse** | sparse, 2.49 |

**The estimate is exact on every cohort the rule decides**, which closes C1201's mystery item 4, and
`triangle:blocks:4096` and `mutual:blocks:4096` — the pair with the same key space, the same rows
and the same density and opposite right answers — get opposite kinds from one constant, which is the
card's first acceptance bullet.

**Where the estimate is not exact, and in which direction.** A step whose delta relation grows has
no row count at plan time, so the estimate uses that relation's capacity, which at the default row
bound is 2^24. On `closure:blocks:16384` that reads 16,777,216 against a measured 262,144, a
sixty-four-fold overestimate; it biases such an index towards direct, which is the cheap-probe and
expensive-build side, and no cohort in the set is decided by it — every static index reached from a
growing delta has a key space of `domain` against `domain` or `3 · domain` rows and is direct under
any rule. It is in the mystery ledger as the estimate's one known weakness.

**A side effect worth naming: an index no live step probes is now held sparsely.** `triangle`'s and
`path4`'s plans each hold an index that only dead steps reference; its estimated probes are zero, so
the rule gives it the cheapest build. That is the right answer for an index nothing reads, and it
changes preparation and resident memory on those cohorts without touching a loop instruction. The
better answer — not building it at all — is a queued candidate rather than taken here, because the
plan would then hold an index whose arrays are empty and whose safety rests on the dead-step
argument being right rather than on the bounds check.

## Mystery ledger

To be filled in at the closeout.

## Candidates to queue, no identifiers allocated

To be filled in at the closeout.

## Replay commands

To be filled in as each piece lands.
