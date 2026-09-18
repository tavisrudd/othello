# C1202 — the probe-count index rule, mask demotion and the per-link probe counter

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: COMPLETE. Written incrementally from the start, so a crash would have left a partial
record rather than none, and the Fermi predictions below were written and committed **before any
code change**.

**The headline.** A fully bound atom no longer keys on every column it binds, and the index policy
no longer rules on a density. On `triangle` at N = 4,096 the derivation loop falls to **0.604** and
the whole process to **0.887** with preparation and peak resident memory **unmoved**, which is the
acceptance line C1201 measured as unreachable and reported as unmet; at 16,384 the loop falls to
**0.469** and the whole process to **0.790**. On `triangle:blocks:4096` — the cohort that has the
same key space, the same rows and the same density as `mutual:blocks:4096` and the opposite right
answer — the loop falls to **0.420**, and one constant on `key_space / probes` now gives those two
cohorts opposite kinds. Fifteen cohorts whose kinds do not change read **0.99985 to 1.00002** in
derivation-loop instructions against A/A nulls inside 2.7 parts per hundred thousand, because mask
demotion turned out to need **no kernel change at all**. The per-link probe counter that all of this
rests on measured the probe figures C1201 had to derive, and confirmed them exactly; carried
unconditionally it cost 0.11 to 2.55 per cent of the loop, so it is monomorphized and the production
path carries none of it.

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
| candidate, piece 1 monomorphized | the kept shape, and the control for pieces 2 and 3 | `8d43d4e` | `2dbb356` | no | `closure_ballpark-8d43d4e` | `cd3d1726f602ba7154cf8ea960f709c0b79351ed7ed6433f74eadbf261c25935` |
| the demotion sweep's one binary | `Auto` against `AutoUndemoted` | `d037e2a` | `12c7995` | no | `closure_ballpark-d037e2a` | `8865b9b9b3024e23f6e7c8e8faf130e9b60bc66e2761bf8506170eba6ba22fb0` |
| candidate, pieces 2 and 3, before the rows floor | the instructive negative | `1e539fe` | `42470ad` | no | `closure_ballpark-1e539fe` | `7b4be0fe2d69575a004515fc1ba0f627f57b23f94e4e06cf6e54dafa579a59e4` |
| candidate, pieces 2 and 3, kept | every figure below | `5217cdb` | `9edc07b` | no | `closure_ballpark-5217cdb` | `616bd0cdbb68a4b567be6846b479a06ee6796ec244cb2437ec9e87e6dae356d3` |

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
| `ergodis-private` | `8d43d4e`, `42d1852` | the two piece-1 receipts |
| `ergodis` | `30f5c43` | mask demotion: `OP_KEY → OP_CHECK` and one mask bit, no kernel line changed |
| `ergodis-private` | `e9e23c8` | the `blocks<N>` density, and the stages script's load, CPU, arm hashes and `--count-probes` |
| `ergodis` | `12c7995` | `Policy::AutoUndemoted`, the measurement corner for the demotion decision |
| `ergodis-private` | `d037e2a`, `d37f448` | `--index auto-undemoted`, the sweep script's `--arms` and `--densities`, and the two demotion sweeps |
| `ergodis` | `42470ad` | `DIRECT_STATIC_PROBES` replaces `DIRECT_STATIC_DENSITY`, and preparation's three passes |
| `ergodis` | `9edc07b` | the rule is floored by the rows, and the demotion pass is paid once per `(relation, mask)` |
| `ergodis-private` | `1e539fe`, `531f19b` | the two empty re-pins that name the arms |
| `ergodis-private` | `e372dd1`, `5217cdb` | the pre-floor receipts |
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

### The derivation loop under pieces 2 and 3 together

Control `closure_ballpark-8d43d4e` — the shipped density rule with the counter already
monomorphized, so this A/B isolates the two policy changes — against the kept candidate
`closure_ballpark-5217cdb`. Five rounds of three and six repeats, two-point differenced, event set
at 100.00 per cent enabled, load average 3.22 to 5.73 recorded by the receipt
`ab-2026-09-18-c1202-probe-rule-floored.json`. Every output digest, derived count, probe count and
candidate count is equal between the arms on all eighteen cohorts; the receipt records no failures.

| Cohort | kinds, control → candidate | changed | instructions | interval | A/A null | cycles |
| --- | :---: | :---: | ---: | --- | ---: | ---: |
| `closure:sparse:256` | `dd` → `dd` | no | 1.00000 | [0.99998, 1.00001] | 0.9999974 | 1.00530 |
| `closure:sparse:1024` | `dd` → `dd` | no | 1.00000 | [1.00000, 1.00000] | 1.0000006 | 0.99793 |
| `closure:dense:256` | `dd` → `dd` | no | 1.00000 | [1.00000, 1.00000] | 0.9999997 | 1.01403 |
| `closure:dense:512` | `dd` → `dd` | no | 1.00000 | [1.00000, 1.00000] | 0.9999996 | 1.00990 |
| `samegen:sparse:1024` | `ddd` → `ddd` | no | 1.00000 | [0.99999, 1.00001] | 0.9999989 | 0.99138 |
| `samegen:dense:512` | `ddd` → `ddd` | no | 1.00000 | [1.00000, 1.00000] | 0.9999996 | 0.99069 |
| `closure:blocks:4096` | `dd` → `dd` | no | 1.00001 | [0.99994, 1.00007] | 1.0000261 | 0.98404 |
| `closure:blocks:16384` | `dd` → `dd` | no | 1.00000 | [0.99998, 1.00001] | 1.0000010 | 0.98152 |
| `cycle:blocks:4096` | `ddd` → `ddd` | no | 1.00002 | [0.99999, 1.00005] | 1.0000269 | 1.00063 |
| `path3:sparse:4096` | `dd` → `dd` | no | 1.00000 | [0.99990, 1.00010] | 1.0000107 | 0.96342 |
| `path3:sparse:16384` | `dd` → `dd` | no | 1.00000 | [0.99997, 1.00002] | 0.9999931 | 0.98736 |
| `path4:sparse:4096` | `dd` → `dd` | no | 1.00000 | [0.99998, 1.00003] | 0.9999957 | 1.02312 |
| `path4:sparse:16384` | `dd` → `dd` | no | 0.99999 | [0.99999, 1.00000] | 0.9999972 | 1.00581 |
| `mutual:blocks:4096` | `s` → `s` | no | 0.99985 | [0.99964, 1.00006] | 0.9999383 | 0.99187 |
| `mutual:blocks:8192` | `s` → `s` | no | 0.99998 | [0.99987, 1.00009] | 1.0000101 | 0.99739 |
| **`triangle:sparse:4096`** | `dsd` → `dd` | **yes** | **1.30455** | [1.30445, 1.30464] | 1.0000088 | **0.60147** |
| **`triangle:sparse:16384`** | `dsd` → `dd` | **yes** | **1.25667** | [1.25658, 1.25676] | 1.0000184 | **0.47352** |
| **`triangle:blocks:4096`** | `dsd` → `ddd` | **yes** | **0.71717** | [0.71716, 0.71718] | 0.9999951 | **0.43392** |

**Fifteen cohorts whose chosen kinds do not change read 0.99985 to 1.00002**, against A/A nulls
within 2.7 parts per hundred thousand, so they sit inside the nulls' own scatter. Their plans are
byte-identical between the arms, which is what mask demotion's `OP_KEY → OP_CHECK` encoding buys:
there is no kernel change for an unchanged cohort to pay for.

**The three cohorts that change a probed index are the result, and on two of them the instruction
count goes the wrong way while the cycles halve.** That is not a contradiction and the mechanism is
specific: mask demotion replaces a **dependent binary search** over 12,288 or 49,152 distinct
`u64` keys — about thirteen or fourteen serially dependent loads, each waiting on the last — with
**one load into a 16 KiB offsets array and three independent row reads**. The candidate retires 1.30
times the instructions on `triangle:sparse:4096` and runs it in 0.600 of the cycles; on
`triangle:sparse:16384` it is 1.257 times the instructions in 0.500 of the cycles. The playbook's
rule that instruction counts decide is a rule about changes that do the same work in fewer steps;
this is a representation change, and it is the case the playbook names when it says a change that
reduces instructions but lengthens dependent loads is a regression — read the other way round.
**The wall-clock medians agree with the cycles and are the figures the stage table below carries.**

`triangle:blocks:4096` is the cohort the probe-count rule was built for and it wins on both:
**0.717 of the instructions and 0.431 of the cycles**, because the rule reads `key_space / probes`
of 18.2 and gives the fully bound index the direct kind that the density rule of 273 refused it.

### The stages the two policy changes are about: preparation, resident memory, and one evaluation

Six rounds so the arm order alternates evenly, nine in-process evaluations for the loop figure,
load average 2.29 recorded by the receipt `stages-2026-09-18-c1202-probe-rule-floored.json`.
Preparation and resident memory are read from **wall time, the resident high-water mark and the
minor-fault count**, because `perf_event_paranoid` is 2 on this host and a build's cost is
`calloc`'s zeroing, first-touch faults and streaming stores. The whole-process arm reads the facts,
prepares, evaluates **once** and writes the output CSV.

| Cohort | kinds | preparation | | ratio | faults | peak RSS | | ratio | derivation loop | | ratio | whole process | | ratio |
| --- | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `triangle:sparse:1024` | `dsd` → `dd` | 0.7580 ms | 0.7595 | 1.002 | 486 → 487 | 3,816 KiB | 3,808 | 0.998 | 0.4118 ms | 0.2935 | **0.713** | 1.803 ms | 1.661 | **0.921** |
| `triangle:sparse:4096` | `dsd` → `dd` | 2.9309 | 2.8615 | 0.976 | 1,075 → 1,076 | 6,000 | 5,992 | 0.999 | 2.0092 | 1.2130 | **0.604** | 6.910 | 6.130 | **0.887** |
| `triangle:sparse:16384` | `dsd` → `dd` | 9.3217 | 8.9750 | 0.963 | 3,754 → 3,530 | 15,112 | 15,104 | 1.000 | 8.2767 | 3.8777 | **0.469** | 22.994 | 18.174 | **0.790** |
| `triangle:blocks:4096` | `dsd` → `ddd` | 12.3466 | 32.0062 | **2.592** | 6,466 → 22,500 | 19,052 | 83,180 | **4.366** | 38.2938 | 16.0982 | **0.420** | 59.471 | 57.395 | **0.965** |
| `mutual:blocks:4096` | `s` → `s` | 11.7176 | 11.7706 | 1.004 | 6,341 → 6,342 | 18,560 | 18,552 | 1.000 | 2.3464 | 2.3501 | 1.002 | 22.390 | 22.599 | 1.009 |
| `mutual:blocks:8192` | `s` → `s` | 24.9826 | 25.3047 | 1.013 | 14,667 → 14,668 | 37,964 | 37,956 | 1.000 | 5.0712 | 5.0019 | 0.986 | 47.396 | 47.725 | 1.007 |
| `path4:sparse:4096` | `dd` → `dd` | 2.0745 | 2.0759 | 1.001 | 4,891 → 4,892 | 19,396 | 19,388 | 1.000 | 6.1517 | 6.0212 | 0.979 | 17.855 | 17.696 | 0.991 |

**`triangle:sparse:4096` meets the criterion C1201 could not meet and stated as unmet.** C1201's
card asked for preparation and peak resident memory at the sparse row **and** the derivation loop at
the direct row, and C1201 measured that no choice between the two existing static kinds can have
both: its density rule bought preparation at 0.094 and paid 1.556 times the direct arm's loop. Mask
demotion has both. Preparation is **0.976** of the already-sparse control and peak resident memory
**0.999** — both unmoved, because the demoted index is 16 KiB that the plan was already holding for
`edge(x,y)`. The derivation loop is **1.2130 ms against C1201's forced-direct 1.2990 ms on the same
cohort**, so it is not merely near the direct row, it is below it. The whole process is **0.887**.

`triangle:sparse:16384` is the same result a size up and it was not asked for: its fully bound index
was already above `MAX_DIRECT_KEYS` and so was sparse under every policy, and demotion halves its
derivation loop (**0.469**) and takes **0.790** off the whole process with preparation and resident
memory unmoved.

**`triangle:blocks:4096` is the probe-count rule's cohort and it is a different trade, stated as
one.** Its bucket after demotion would be fifteen rows, which the measured guard refuses, so the
rule decides it instead and gives the fully bound index the direct kind at `key_space / probes` of
18.2. The derivation loop falls to **0.420** and preparation rises to **2.592** with peak resident
memory at **4.366** — 64 MiB of offsets for 61,440 rows. Over one evaluation that nets **0.965**,
and over two or more it is a large win; the memory is the cost and it is the reason the constant is
the conservative end of its bracket rather than the middle. The card's second acceptance bullet asks
for this cohort's preparation near the sparse figure under a demoted mask, and **that bullet is not
met for this cohort**: demotion is measured to lose there (0.637 in the sweep above) and the rule
takes the other branch.

**The three cohorts whose kinds do not change are nulls on every stage**: preparation within 1.3 per
cent, minor faults equal to the unit, resident sets equal to eight kibibytes, the loop within 2.1 per
cent and the whole process within 0.9 per cent.

### Every cohort's kinds, digests and work counters

The census over all eighteen cohorts, one round, which asserts the output digest, the derived count,
the probe count and the candidate count are equal between the arms per cohort and raises otherwise.
It ran to completion, so all eighteen agree. Receipt `stages-2026-09-18-c1202-kind-census.json`.

| Cohort | control | candidate | changed | candidate's key spaces (masks) | measured lookups per index |
| --- | :---: | :---: | :---: | --- | --- |
| `closure:sparse:256` | `dd` | `dd` | no | 256, 256 (1, 2) | 62,979 · 0 |
| `closure:sparse:1024` | `dd` | `dd` | no | 1,024, 1,024 (1, 2) | 979,983 · 0 |
| `closure:dense:256` | `dd` | `dd` | no | 256, 256 (1, 2) | 65,536 · 0 |
| `closure:dense:512` | `dd` | `dd` | no | 512, 512 (1, 2) | 262,144 · 0 |
| `samegen:sparse:1024` | `ddd` | `ddd` | no | 1,024 ×3 (2, 1, 2) | 259,714 · 1,023 · 0 |
| `samegen:dense:512` | `ddd` | `ddd` | no | 512 ×3 (2, 1, 2) | 508,446 · 1,021 · 0 |
| `closure:blocks:4096` | `dd` | `dd` | no | 4,096, 4,096 (1, 2) | 65,536 · 0 |
| `closure:blocks:16384` | `dd` | `dd` | no | 16,384, 16,384 (1, 2) | 262,144 · 0 |
| `cycle:blocks:4096` | `ddd` | `ddd` | no | 4,096, 4,096, 16,777,216 (1, 2, 3) | 65,536 · 0 · **69,632** |
| **`triangle:sparse:16384`** | `dsd` | `dd` | **yes** | 16,384, 16,384 (1, 2) | 196,608 · 0 |
| `path3:sparse:4096` | `dd` | `dd` | no | 4,096, 4,096 (1, 2) | 49,152 · 0 |
| `path3:sparse:16384` | `dd` | `dd` | no | 16,384, 16,384 (1, 2) | 196,608 · 0 |
| `path4:sparse:4096` | `dd` | `dd` | no | 4,096, 4,096 (1, 2) | 159,744 · 0 |
| `path4:sparse:16384` | `dd` | `dd` | no | 16,384, 16,384 (1, 2) | 638,976 · 0 |
| `mutual:blocks:4096` | `s` | `s` | no | 16,777,216 (3) | **61,440** |
| `mutual:blocks:8192` | `s` | `s` | no | 67,108,864 (3) | 122,880 |
| **`triangle:sparse:4096`** | `dsd` | `dd` | **yes** | 4,096, 4,096 (1, 2) | 49,152 · 0 |
| **`triangle:blocks:4096`** | `dsd` | `ddd` | **yes** | 4,096, 16,777,216, 4,096 (1, 3, 2) | 61,440 · **921,600** · 0 |

Three cohorts change and each for a stated reason: the two `triangle:sparse` sizes demote their
fully bound atom onto the index `edge(x,y)` already holds, and `triangle:blocks:4096` keeps its
fully bound mask and gets the direct kind from the probe rule. **`mutual:blocks:4096` and
`triangle:blocks:4096` now get opposite kinds from one constant** — the card's first acceptance
bullet — and the measured lookups say why: 61,440 against 921,600 into indexes of the same key
space over relations of the same size.

### The instructive negative: the rule before the rows floor

The first landing of the probe rule (core `42470ad`, arm `closure_ballpark-1e539fe`) had two
defects, both found by measuring it rather than by reading it, and both are recorded here as design
evidence rather than edited out. The receipt is
`stages-2026-09-18-c1202-probe-rule-prefloor.json`, six rounds of nine repeats, load average 1.89.

1. **An index no live step probes was sent to the kind with the larger build.** Its estimated probes
   are zero, so `key_space <= K · probes` is false at any key space and the rule chose sorted — which
   allocates and sorts one `(u64, u32)` pair per row. On `triangle:blocks:4096` that cost **2.8 ms**
   of preparation for a structure nothing reads, and it turned the cohort the rule was built for from
   a win into a wash: the whole process read **0.990** rather than the 0.93 C1201's sweep predicted.
   The repair is a floor, and it needs no new constant: the direct array is one `u32` per key against
   the sorted kind's twelve bytes per row, and its counting sort is linear against a sort, so direct
   is the cheaper build whenever `key_space <= rows` whatever the probes.
2. **The demotion guard's pass over the rows ran once per link rather than once per
   `(relation, mask)`.** `triangle` asks the same question of `edge` at three steps, so it paid three
   times: **0.50 ms** of preparation on `triangle:sparse:4096`, against a 2.90 ms baseline.

Both repairs are in core `9edc07b`, and the figures above are the pre-floor arm's; the kept arm's are
in the tables above and below.

### How the Fermi predictions came out

| Prediction | Outcome |
| --- | --- |
| 1, the counter's own cost: one instruction per lookup in the two-atom kernel and three in the n-ary one, so 0.21 and 0.96 per cent | **Wrong by about eight times.** Measured 1.47 and 2.55 per cent, at seven to ten and a half instructions per lookup, and the branch counts moved with them. The cost model failed in the way the playbook says to treat as a cost-model failure: the shape changed — the counter is monomorphized — rather than the constant being shaved. |
| 2, mask demotion needs no kernel change and `OP_CHECK` is the encoding | **Right**, and all three consequences held: unchanged cohorts are byte-identical, the work counters are invariant, and the demoted mask collides with an index the plan already holds. |
| 2, `triangle:sparse:4096`: evaluation 0.60 to 0.70 against `auto` and 0.95 to 1.10 against forced direct | **Right on the first and better than the range on the second**: 0.604 against `auto`, and 1.2130 ms against C1201's forced-direct 1.2990 ms, which is 0.934. |
| 2, `triangle:blocks:4096`: evaluation 35 to 48 ms demoted, winning end to end at 47 to 60 ms | **Wrong.** Demoted evaluation measured **66.96 ms** and demotion loses end to end at 0.637. The extra row reads cost about **3.5 ns** each rather than the one to two nanoseconds assumed — a bucket of fifteen rows in a 480 KiB row array is not a sequential read. This is the prediction the demotion guard exists because of. |
| 2, `mutual:blocks:4096`: evaluation 2.5 to 3.6 ms, winning end to end | **Level right, sign wrong.** Demoted evaluation measured 3.43 ms, inside the range, but the undemoted sorted arm measured 2.36 ms rather than the 3.26 the prediction assumed, so demotion loses at 0.920. |
| 3, the measured counter leaves `K ≈ 23` unmoved | **Right, exactly**: 36,864, 921,600 and 61,440 lookups, which are `rows × 3`, `rows × 15` and `rows`. |
| 4, the plan's estimate agrees with the counter on every cohort the rule decides | **Right**, and its one weakness came out where predicted, on a step whose delta relation grows. |
| 5, the two density constants do not merge | **Not settled.** The measurement was not taken; what the counter did buy is that the question is now sharp — `cycle:blocks:4096`'s growing index reads 241 keys per probe against a density of 1.0, so the two rules give it opposite answers. Mystery item 4. |

## Disposition

**Kept**, at core `9edc07b` with private `5217cdb`, four parts:

- **The per-link probe counter**, monomorphized on a `COUNT` const, with `evaluate_counted_into` as
  the instrumented entry point and `Demand::index_lookups` as the per-index split. The production
  derivation loop carries neither the counter nor its register.
- **Mask demotion** for a fully bound static atom, as `OP_KEY → OP_CHECK` plus one mask bit, guarded
  by `DEMOTE_BUCKET_ROWS = 7` on the exact average bucket. `Policy::AutoUndemoted` is the corner it
  is measured against.
- **`DIRECT_STATIC_PROBES = 23`** replacing `DIRECT_STATIC_DENSITY = 64`, applied as
  `key_space <= K · estimated_probes` floored by the relation's rows, with the estimate computed by
  `Demand::estimate_probes` over the steps that can run.
- **The `blocks<N>` density** and the three fields C1201's audit asked of `static_index_stages.py`,
  plus `--arms`, `--densities` and `--count-probes` on the two measurement scripts.

**Reverted by a forward commit: two defects of the rule's first landing**, both kept above as
instructive negatives with their measured cost — an index no live step probes being sent to the kind
with the larger build, and the demotion guard's row pass running once per link rather than once per
`(relation, mask)`.

**Not built, and priced**: `join::<VERIFY = true, _>` instantiated for the CSR arm, which the card
asked for and which the `OP_CHECK` encoding makes unnecessary; a constant key column's demotion,
which would need an unconditional comparison the plan has no operation for and so a new match arm in
both join sites; and not building an index no live step probes at all.

## Acceptance, per card bullet

| Bullet | Verdict |
| --- | --- |
| `mutual:blocks:4096` and `triangle:blocks:4096` both get the right kind under `Policy::Auto` | **Met.** The measured lookups are 61,440 and 921,600 into indexes of the same key space over relations of the same size, so `key_space / probes` is 273.1 and 18.2 and one constant of 23 gives them opposite kinds. `mutual` stays sparse and is a null on every stage; `triangle:blocks:4096` takes the direct kind and reads 0.420 of the derivation loop and 0.965 of the whole process. |
| `triangle:sparse:4096` and `triangle:blocks:4096` under the demoted mask: preparation near C1201's sparse figure, derivation loop at or near the direct row | **Met on `triangle:sparse:4096`, and not met on `triangle:blocks:4096`, which is a measured decision rather than a shortfall.** On `triangle:sparse:4096` preparation is 0.976 and peak resident memory 0.999 of the already-sparse control, and the derivation loop is 1.2130 ms against C1201's forced-direct 1.2990 ms on the same cohort — below the direct row, not merely near it. `triangle:blocks:4096` does not demote: its bucket would be fifteen rows and the crossover is measured between seven and nine, so demotion there costs 0.637 of preparation plus one evaluation. The probe rule takes that cohort instead. |
| Every cohort in the C1201 table: digest, derived, probe and candidate counts equal; certificates accepted by both checkers; C1189 differential zero disagreements under both body policies; parity digest reported | **Met.** The eighteen-cohort census asserts the four equalities per cohort and raises otherwise; it ran to completion. The core suite's `demand_sparse` runs the whole corpus a second time under `Policy::Sparse` **and** a third under `Policy::AutoUndemoted` and compares certificate **bytes**, so the demoted and undemoted plans are held to byte equality, and both independent checkers accept in every representation. The private suite's `rel_reference_eval` is the C1189 differential under both body policies and passes. **The parity digest is unmoved**: every cohort's `output_sha256` is equal between the arms, which the A/B and the census both assert. |
| Direct-path cohorts whose kind does not change: instructions within the A/A null or the loss stated as a loss | **Met.** Fifteen cohorts read 0.99985 to 1.00002 against A/A nulls within 2.7 parts per hundred thousand. Their plans are byte-identical, which is what the `OP_CHECK` encoding buys. |
| The per-link probe counter's own cost on the two-atom kernel measured and stated | **Met, and it changed the design.** Carried unconditionally it cost 1.47 per cent of `mutual:blocks:4096`'s instructions and 1.46 per cent of `closure:sparse:256`'s, at about seven to nine instructions per lookup rather than the one predicted, so it is monomorphized; the production path then measures 0.99167 and 0.99185 on those two cohorts. |
| Gates | **Met.** `cargo test --all-features` at 82 `test result: ok` blocks and zero `FAILED`, clippy `-D warnings` clean, `cargo fmt --check` clean, the allocation regression green under all five policies with the n-ary kernel included, `generate_evidence.py --write` in the same commits, and the private workspace's suite, clippy, fmt and `ruff` as in the replay block. |

## The `ej` and `tt` closeout

Run after the acceptance gate passed. Three things came out of it, and the second is the one that
changes what a successor should build.

### `K = 23` is derivable from this task's own per-unit costs, and comes out at 20.6

C1201 fitted the constant at one located crossover and could not check it against anything. The
per-stage receipt has both coefficients now, on `triangle:blocks:4096`, which is the cohort whose
fully bound index the rule decides:

- the direct kind's **extra build** is 32.0062 − 12.3466 = **19.66 ms** over 16,777,216 keys, so
  **1.17 ns per key**;
- its **probe saving** is 38.2938 − 16.0982 = **22.20 ms** over 921,600 lookups into that index, so
  **24.1 ns per probe**.

`K` is the ratio of one probe's saving to one key's build cost, so the measured coefficients predict
**20.6 keys per probe**, against the 23 the constant carries. **The two agree to 12 per cent, and
the prediction is the conservative side.** Nothing in the cohort set distinguishes 20 from 23 —
`triangle:blocks:4096` sits at 18.2 and `mutual:blocks:4096` at 273.1 — so the constant is left at
23 and the derivation is recorded rather than acted on. It also says where the constant would move:
the build coefficient is streaming stores and first-touch faults over the key space and the probe
saving is a dependent binary search, so `K` is a property of this host's memory system and not of
the workload, which is the first thing worth checking on another machine.

### The demotion guard and the index rule are the same comparison written twice

The `tt` observation, and it reshapes the successor. The policy is now choosing among **three**
representations for one atom — direct on the full mask, sorted on the full mask, and direct on a
demoted mask — with **two thresholds fitted independently**, one in keys per probe and one in rows
per bucket. Both are the same inequality, `build + probes × probe_cost`, evaluated on a different
pair: the probe count cancels in the demotion comparison because both sides pay one probe each and
their builds are within noise, and it does not cancel in the index comparison because one side's
build scales with the key space. **Neither constant is a property of its own decision; both are
faces of one cost function with three per-unit coefficients** — a key of direct build, a row read,
and a binary-search step — and this task measured all three (1.17 ns, and the ratio 0.6 between the
last two). A successor that enumerates the candidate `(mask, kind)` pairs for an atom and prices
them from those three coefficients would replace both constants, would extend to the fifth hashed
kind without a fourth constant, and would answer the growing-index question in the same frame.

### The plan now has a cardinality estimator, and it should be named as one

`Demand::estimate_probes` is the textbook independence-assumption join-size estimate: the delta rows
times the product of each earlier level's average fan-out. Its known failure mode is correlated
attributes, and this cohort set does not exercise it — the `blocks` generator is maximally
correlated *within* a block and the estimate is still exact, because every key of the mask is
present and the fan-out is uniform. **So "exact on every cohort" is a statement about these
generators and not about the estimator**, and that is worth saying before the estimate is trusted
for anything larger. The two places it is already known to be loose are in the mystery ledger: a
growing delta relation, where it uses the row bound, and a mask whose keys are concentrated, where
`min(key_space, rows)` overestimates the distinct keys. The demotion guard deliberately does **not**
use the estimate for exactly that reason and measures the distinct count instead.

### Cheap adjacent items, taken and not taken

Taken, because they fell out of runs already being made: `triangle:blocks:4096` is now in the
standing eighteen-cohort set of `ab.py`'s runs and of the census (C1201 candidate 7, with `mutual`
at `blocks` already there); `static_index_stages.py` emits the load average, the CPU and each arm's
binary hash (C1201 candidate 9 and audit defect 4), and `static_index_sweep.py` gained `--arms`,
`--densities` and `--count-probes` with its existing defaults unchanged so C1201's receipts still
replay.

Not taken, with the reason: the supplementary cache-event run on `triangle:sparse:4096` under both
forced policies (C1201 candidate 6 and open item 2, C1193 open item 3). It did not fall out of any
run made here, and this task's cycle ratios are already explained by a dependent-load argument the
cache events would test rather than decide. It stays queued.

**One projection, labelled as a projection and not a measurement.** C1201's receipted Soufflé row
has `triangle:sparse:4096` at **0.896** of compiled Soufflé on the arm this task's control descends
from, and this task's whole process on that cohort is **0.887** of that control. The arithmetic
gives about **0.79**, but the two figures are from different sessions and Soufflé's own time moved
by 1.3 per cent between C1201's two sessions, so this is an estimate to check rather than a result.
Re-running `compare.py` on the kept arm is the cheapest remaining external datum in the lane.

## Mystery ledger

### Settled

1. **Do the probe counts C1201 derived from the generators' out-degree match the kernel?** Yes,
   exactly, on every cohort: 36,864 = `rows × 3` at `triangle:sparse:4096`, 921,600 = `rows × 15` at
   `triangle:blocks:4096`, 61,440 = `rows` at `mutual:blocks:4096`. So `key_space / probes` is
   1,365.3, 18.2 and 273.1 as C1201 reported and its fitted `K ≈ 23` is unmoved. This closes C1201's
   mystery item 4 in the direction that nothing has to be refitted.
2. **Why is only one of `triangle`'s three semi-naive steps ever live?** A step whose delta relation
   never grows scans its delta in the first round and nowhere else, and in the first round every
   relation's `delta_lo` is zero, so a body atom **before** the delta atom bounds the step to no
   rows. The counter reads the top-level `probes` at the fact count rather than three times it, and
   the plan's estimate now encodes the same rule.
3. **What does an unconditional per-link probe counter cost?** About **eight instructions per
   lookup**, not the one the increment is, and the branch counts move by the same fraction — so it is
   a codegen effect on the four-op key fold beside it rather than the counter's arithmetic. Fermi
   prediction 1 was wrong by a factor of eight and the shape changed rather than the constant: the
   counter is monomorphized and the production instantiation carries neither it nor its register.
4. **Can a fully bound atom demote its index mask without a kernel change?** Yes, and the card's
   shape was not the cheapest. `OP_KEY` is folded into the key and compared only under the verify
   flag; `OP_CHECK` is skipped by the fold and compared unconditionally. Demotion is `OP_KEY →
   OP_CHECK` plus one mask bit, so no new op kind, no new addressing kind, no new instantiation and
   no new storage, and eleven cohorts measured inside their A/A nulls because their plans are
   byte-identical.
5. **Where is the demotion crossover?** Between an average bucket of 7 and 9 rows on `triangle` and
   between 7 and 11 on `mutual`, measured on one binary under `Auto` against `AutoUndemoted`. The
   cost model closes on it: at 4,096 distinct keys the sorted probe is about twelve dependent search
   steps, so a search step costs about **0.6 of a row read** on this host.
6. **Why does the demoted arm retire 1.26 to 1.30 times the instructions and run in half the
   cycles?** Because it replaces a serially dependent binary search — thirteen or fourteen loads
   each waiting on the last — with one load and three independent row reads. This is the case the
   playbook names when it says a change that reduces instructions but lengthens dependent loads is a
   regression, read the other way round.

### Open

1. **Why is the production path 0.4 to 1.6 per cent cheaper than the control after the counter was
   monomorphized?** Seventeen of eighteen cohorts came out below unity against a control that
   executes the same operations, so it is a codegen effect of making the step loop generic, of the
   same family and size as the two C1193 measured. *Evidence so far*: the whole eighteen-cohort
   table, every A/A null within 6.2 parts per hundred thousand, and work counters equal on every
   cohort. *Evidence gap*: a disassembly comparison of `evaluate_counting::<false>` against the
   control's `evaluate_into`, and a kernel-scoped symbol profile of both. *Why it matters*: if it can
   be understood it is a free one per cent for every cohort in the lane, and if it cannot it is a
   warning that this lane's sub-per-cent results carry a codegen term nobody is controlling.
2. **`DEMOTE_BUCKET_ROWS` is flat and the cost model says it should grow with `log2(distinct)`.**
   The crossover is where `b` row reads cost what a binary search over the distinct keys costs, and
   the search is logarithmic in the distinct count. The constant is fitted at one distinct count,
   4,096. *Evidence gap*: the same `blocks<N>` sweep at domains 1,024 and 16,384, which moves
   `log2(distinct)` by two either way and should move the crossover with it. *Cheap*: two more sweep
   invocations on the retained arm.
3. **The probes estimate for a step whose delta relation grows uses the row bound.** On
   `closure:blocks:16384` that is 16,777,216 against a measured 262,144, a sixty-four-fold
   overestimate. It biases such an index towards direct, the cheap-probe and expensive-build side,
   and no cohort in the set is decided by it. *Evidence gap*: a cohort where a growing delta feeds a
   **static** index with a large key space, which none of the seven programs builds.
4. **`DIRECT_INDEX_DENSITY = 48` for growing indexes: the two rules disagree on a real cohort and
   the disagreement is now measurable.** `cycle:blocks:4096`'s growing index on both of `path`'s
   columns has a key space of 2^24 and a capacity of 2^24, a density of 1.0 that keeps it direct,
   and the per-link counter reads **69,632 lookups**, so `key_space / probes` is **241** — which the
   static constant of 23 would send sparse. *Evidence so far*: the counter, and nothing measured
   about which answer is right. *Evidence gap*: `cycle:blocks:4096` with that one index forced each
   way at equal work, which C1192's `--max-rows` sweep is the instrument for. *Owner*: a successor;
   the question is now sharp, which it was not before the counter.
5. **The demotion sweep's null is 0.97, not 1.00.** Three rounds alternate the arm order 2:1, so the
   arm that runs first in the majority of rounds is favoured; the two `mutual` rows where the guard
   already refuses demotion build identical plans on one binary and still read 0.9713 and 0.9757.
   *Evidence gap*: none needed — an even round count fixes it, and the per-stage run that followed
   used six rounds. The crossover rows are read against that null in the text above.

6. **`K` is fitted at 23 and derived at 20.6 from this task's own coefficients.** The `ej` closeout
   above prices one key of direct build at 1.17 ns and one probe's saving at 24.1 ns on
   `triangle:blocks:4096`, which predicts the constant within 12 per cent on the conservative side.
   *Evidence gap*: no cohort in the set distinguishes 20 from 23, and both coefficients are
   properties of this host's memory system rather than of the workload. *Owner*: the successor that
   replaces both constants with one cost function.

No genuine mystery is being manufactured. Items 1 and 4 are measurements nobody has taken, item 2 is
a constant fitted at one point with the model that says where to fit it next, item 3 is a stated
weakness with its direction, item 5 is a protocol defect with its fix, and item 6 is a constant
whose derivation now exists and whose fitted and derived values differ by less than the cohort set
can see.

## Candidates to queue, no identifiers allocated

1. **Settle `DIRECT_INDEX_DENSITY`.** Open item 4: the static and growing rules give opposite answers
   on `cycle:blocks:4096`'s growing index and one measurement decides whether one constant replaces
   both. The per-link counter, which this task built, is what makes the question askable.
2. **Fit `DEMOTE_BUCKET_ROWS` as a function of `log2(distinct)`.** Open item 2, two sweep
   invocations on a retained arm.
3. **Do not build an index no live step probes.** The rule now gives it the cheapest build; not
   building it at all is cheaper still. Held back because the plan would then hold an index whose
   arrays are empty and whose safety rests on the dead-step argument rather than on a bounds check.
4. **Understand the generic step loop's one per cent.** Open item 1.
5. **A plan-owned open-addressed hash over the distinct keys**, C1201's candidate 4, still unbuilt
   and now less attractive: mask demotion gets the cheap build and the O(1) probe for a fully bound
   atom without a fifth addressing kind.
6. **Preparation's per-fact cost**, C1201's open item 1 and candidate 5, untouched here and still
   the leading term.
7. **The supplementary cache-event run**, C1201's candidate 6 and open item 2 and C1193's open item
   3. Not taken here: this task's A/B is a representation change whose cycle ratios are explained by
   the dependent-load argument, and the cache run would test that explanation rather than the
   decision.
8. **A `matches` counter beside the lookups counter**, C1193's queued instrument: with the two, the
   plan could estimate selectivity as well as fan-out, which is the other half of the join-order
   question this task left alone.

## Replay commands

Run from `~/src/ergodis-private` unless noted. Every gate and every measurement went through
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin.
Working files under `~/.cache/ergodis/c1202/`.

```sh
# Gates, core, at 9edc07b. Outcome: exit 0, 82 `test result: ok` blocks, zero
# FAILED; clippy and fmt clean; the allocation regression green under all five
# policies, the n-ary kernel included.
cd ~/src/ergodis
nix develop . --command cargo test --all-features --no-fail-fast -j 12
nix develop . --command cargo clippy --all-targets --all-features -j 12 -- -D warnings
nix develop . --command cargo fmt --all -- --check
nix develop . --command cargo test -p ergodis-rules --test allocation -j 12
nix develop . --command python3 python/generate_evidence.py --write   # SHA256SUMS
cd ~/src/ergodis-private

# Gates, private. This drives rel_lowering, rel_frontend, rel_frontend_portability
# and rel_reference_eval, which is the C1189 differential under both body policies.
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test \
    -p ergodis-private -p ergodis-tools --no-fail-fast -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private -p ergodis-tools \
    --lib --bins --tests --examples -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check
nix shell nixpkgs#ruff -c ruff check analysis/datalog-comparison/static_index_*.py

# The arms, each retained with the tree at its own revision and `git status
# --short` empty, checked before the recipe ran.
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private ab6be13, core 5c9d1b3
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools      # private ab6be13, core 5c9d1b3
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private 83bff0a, core 2904489
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private 8d43d4e, core 2dbb356
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private d037e2a, core 12c7995
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private 1e539fe, core 42470ad
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private 5217cdb, core 9edc07b

A=analysis/datalog-comparison; C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1202
ALL=closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512,closure:blocks:4096,closure:blocks:16384,cycle:blocks:4096,triangle:sparse:16384,path3:sparse:4096,path3:sparse:16384,path4:sparse:4096,path4:sparse:16384,mutual:blocks:4096,mutual:blocks:8192,triangle:sparse:4096,triangle:blocks:4096

# Piece 1, the counter carried unconditionally. Outcome: 1.00114 to 1.02554.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-ab6be13 \
    --a-name control-ab6be13 --b $C/closure_ballpark-83bff0a --b-name counter-83bff0a \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-counter --out $A/ab-2026-09-18-c1202-probe-counter.json

# Piece 1, the counter monomorphized. Outcome: 0.98367 to 1.00122.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-ab6be13 \
    --a-name control-ab6be13 --b $C/closure_ballpark-8d43d4e --b-name counted-8d43d4e \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-counter-const --out $A/ab-2026-09-18-c1202-probe-counter-const.json

# Piece 2, the demotion crossover: one binary, Auto against AutoUndemoted, with
# the block size sweeping the demoted bucket. Outcome: the crossover between a
# bucket of 7 and 9 on the triangle and between 7 and 11 on mutual.
nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py \
    --bin $C/closure_ballpark-d037e2a --work $W/demote-sweep --program triangle \
    --arms auto-undemoted,auto --count-probes --domains 4096 --rounds 3 --repeats 5 \
    --densities blocks4,blocks6,blocks8,blocks10,blocks12,blocks14,blocks16 \
    --out $A/sweep-2026-09-18-c1202-demotion-triangle.json
nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py \
    --bin $C/closure_ballpark-d037e2a --work $W/demote-sweep --program mutual \
    --arms auto-undemoted,auto --count-probes --domains 4096 --rounds 3 --repeats 5 \
    --densities blocks4,blocks8,blocks12,blocks16,blocks24,blocks32 \
    --out $A/sweep-2026-09-18-c1202-demotion-mutual.json

# Pieces 2 and 3, the derivation loop, before and after the rows floor.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-8d43d4e \
    --a-name density-8d43d4e --b $C/closure_ballpark-1e539fe --b-name probes-1e539fe \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-rule --out $A/ab-2026-09-18-c1202-probe-rule.json
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-8d43d4e \
    --a-name density-8d43d4e --b $C/closure_ballpark-5217cdb --b-name probes-5217cdb \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $ALL \
    --work $W/ab-rule2 --out $A/ab-2026-09-18-c1202-probe-rule-floored.json

# Preparation, peak RSS and one whole evaluation, six rounds so the arm order
# alternates evenly, with the per-link counter recorded per cohort.
nix develop ~/src/ergodis --command python3 $A/static_index_stages.py \
    --a $C/closure_ballpark-8d43d4e --a-name density-8d43d4e \
    --b $C/closure_ballpark-5217cdb --b-name probes-5217cdb \
    --work $W/stages-rule2 --index auto --rounds 6 --repeats 9 --count-probes \
    --cohorts triangle:sparse:1024,triangle:sparse:4096,triangle:sparse:16384,triangle:blocks:4096,mutual:blocks:4096,mutual:blocks:8192,path4:sparse:4096 \
    --out $A/stages-2026-09-18-c1202-probe-rule-floored.json

# The kind census over the eighteen cohorts, which asserts digest and work
# equality per cohort and is not a timing run.
nix develop ~/src/ergodis --command python3 $A/static_index_stages.py \
    --a $C/closure_ballpark-8d43d4e --a-name density-8d43d4e \
    --b $C/closure_ballpark-5217cdb --b-name probes-5217cdb \
    --work $W/census --index auto --rounds 1 --repeats 1 --count-probes --cohorts $ALL \
    --out $A/stages-2026-09-18-c1202-kind-census.json
```

Inputs are deterministic: the C1182 xorshift edge generator seeded by the domain for the `sparse`
and `dense` densities, and the `blocks` and `blocks<N>` densities' complete digraph inside each
consecutive block, which uses no random stream at all.

## What this task left under `~/.cache/ergodis/`

**Seven retained binaries.** `bin/closure_ballpark-ab6be13` and `bin/ergodis-tools-ab6be13` are this
task's controls; `bin/closure_ballpark-83bff0a`, `-8d43d4e`, `-d037e2a`, `-1e539fe` and `-5217cdb`
are the five candidate arms every figure above is measured on, and `closure_ballpark-5217cdb` is
**the control the next A/B in this lane should use**. All seven are recorded `clean` in
`bin/MANIFEST.tsv` except `closure_ballpark-df2f5f4` and `closure_ballpark-531f19b`, which are two
retains taken with an untracked receipt file present, are flagged `dirty`, are **not used by any
figure**, and whose hashes are identical to the clean retains at the next revision — which is itself
the evidence that the untracked receipts did not reach the binary.

**`c1202/`, 22 MB.** The work directories of every run above: `ab-counter`, `ab-counter-const`,
`ab-rule`, `ab-rule2`, `census`, `demote-sweep`, `smoke`, `stages-rule` and `stages-rule2`.
Everything here regenerates from the replay block.

**No `perf-c1202/`.** This task took no `perf record` profile: every measurement is a `perf stat`
A/B through `ab.py` or a wall-time and fault-count stage through `static_index_stages.py`.

`../ergodis-dev/scripts/cache-gc.sh` was run in its listing mode and **nothing was deleted; that is
Tavis's call.** It scanned 39 entries and reports **zero unreferenced and old enough to remove** —
every entry is either named by an evidence file or younger than two days, this task's `c1202` among
the latter. The largest entries it lists are `c1143` at 260 MB, `certdist`, `c1018` at 108 MB,
`worktrees` at 105 MB, `c985`, `c1016` at 51 MB, `split`, `bb756` at 28 MB, `c1202` at 22 MB and
`c1192` at 20 MB. `bin/` itself is **706 MB** across the whole manifest, which is where the growth
in this cache now is.

## Resume state for the next session

**The task is complete and every tree is committed.** Nothing is half-built and no path is untracked
in any of the three repositories.

| Repository | HEAD at close | Range this task added |
| --- | --- | --- |
| `~/src/ergodis` | `9edc07b` | `5c9d1b3` … `9edc07b` (five commits) |
| `~/src/ergodis-private` | the last receipt commit | `ab6be13` … here |
| `~/src/othello` | this report's last commit | `f19c82c35` … here |

**Retained controls for the next A/B in this lane**, at `ergodis-private` `5217cdb` with core
`ergodis` `9edc07b`, rustc 1.95.0 (59807616e 2026-04-14), release, no features, `clean` in the
manifest:

- derivation loop: `~/.cache/ergodis/bin/closure_ballpark-5217cdb`, measured sha256
  `616bd0cdbb68a4b567be6846b479a06ee6796ec244cb2437ec9e87e6dae356d3`;
- frontend and stratified backend: `~/.cache/ergodis/bin/ergodis-tools-ab6be13`, measured sha256
  `d6495328d7aa8d6e675d31d6622365a9312cf108e28a78f6ed4084a73b12dc69`, which this task did not move
  and which supersedes `ergodis-tools-8c04b7a`.

**Left undone, deliberately:** the lifecycle close for C1202, which belongs to whoever closes the
task, and the eight queued candidates, none of which has an identifier.

**Decisions left open for Tavis**, both stated with their evidence above and neither taken here.
First, whether `triangle:blocks:4096`'s direct kind is worth **4.4 times the peak resident memory**
for a whole process of 0.965 and a derivation loop of 0.420 — the recommendation is that it is,
because the rule is written for one evaluation and a plan evaluated twice is already well ahead, but
the memory is the largest single cost this task adds and the constant that decides it (23 fitted,
20.6 derived) is close enough to the cohort's 18.2 that moving it to 20 would flip the cohort with
no other effect on the set. Second, which of the open items to allocate first — the recommendation
is the growing-index constant (`DIRECT_INDEX_DENSITY`, mystery item 4), because the per-link counter
has made it a one-measurement question and it is the last density in the policy.

## Vibe check

Very good, and the part that is best was not on the card. Mask demotion turned out to need **no
kernel change at all** — `OP_KEY → OP_CHECK` and one mask bit, because the plan already carried both
halves of the pair the card was going to build — so fifteen cohorts are inside their A/A nulls by
construction and `triangle` at 4,096 meets the acceptance line C1201 measured as unreachable between
the two existing static kinds: the loop at **0.604** and the whole process at **0.887** with
preparation and resident memory unmoved. `triangle:sparse:16384` was a free 2.1× on the loop that
nobody asked for. The probe-count rule does what C1201 said it would: `mutual:blocks:4096` and
`triangle:blocks:4096` get opposite kinds from one constant, and the counter says why — 61,440
lookups against 921,600.

Two things are stated as costs rather than rounded away. The demoted cohorts retire **1.26 to 1.30
times the instructions** while running in half the cycles, because the change trades a dependent
binary search for independent row reads; the playbook's "instructions decide" rule is about changes
that do the same work in fewer steps, and this is not one. And `triangle:blocks:4096` buys a 0.420
loop with **4.4 times the peak resident memory** and a whole process of 0.965 — a large win only for
a plan evaluated more than once, which the rule is deliberately not written for.

The uncomfortable result is the one in the mystery ledger: monomorphizing the counter made
seventeen of eighteen cohorts **0.4 to 1.6 per cent cheaper** than a control executing the same
operations. That is a codegen term this lane is not controlling, it is the same size as the effects
the lane chases, and it deserves a look before the next sub-per-cent claim.
