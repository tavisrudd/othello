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
| `othello` | (this one) | the report skeleton, the reproduced baseline and the Fermi predictions, written before any code |

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

To be filled in as each piece lands.

## Mystery ledger

To be filled in at the closeout.

## Candidates to queue, no identifiers allocated

To be filled in at the closeout.

## Replay commands

To be filled in as each piece lands.
