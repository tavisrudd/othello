# C1203 — re-locating the growing join index's direct/sparse crossover

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: COMPLETE. Written incrementally from the start, so a crash would have left a partial
record rather than none; the Fermi predictions below were written and committed **before the first
sweep**, and before any source change in any repository.

**The headline.** The crossover `DIRECT_INDEX_DENSITY = 48` was set from **no longer exists on the
cohort it was set from**: on that cohort, under that instrument, the direct kind is now ahead by 19
to 21 per cent in cycles at every density the ceilings allow, where it was behind by 1.6 to 2.6 per
cent before the lazy workspace removed the per-evaluation fill. Where a crossover does still exist —
the two smallest block sizes at domain 4,096 — it is at a density of about **128 to 256** rather than
48, it **moves with the block size and the domain and not with the density**, and the counted events
say the mechanism is now the **L1 data TLB** rather than memory traffic: the TLB-miss ratio between
the two kinds crosses unity exactly where the cycle ratio does and no cache counter does. The finding
that decides the disposition was not on the card: every ratio this lane has ever measured for this
index is a **warm-loop** ratio, and on the **first** evaluation — the shape the driver, the
differential and the Rel route all run — the direct kind costs **2.4 to 3.0 times** the sparse kind's
time and **2.1 times** its peak resident memory, with a break-even of 11 to 182 evaluations. So the
one-evaluation regime crosses at a density of 4 to 16 and the repeated-evaluation regime at 128 or
never, **the shipped constant sits between them**, and no single density is right in both. The
constant is **unchanged**; its docstring is repaired to state what it actually trades.

Task card: `notes/2026-09-18-c1203-growing-index-crossover.md`. Predecessors:
`notes/2026-09-18-c1202-probe-count-index-rule-report.md` (the growing index at one density and four
probe counts), `notes/2026-09-16-c1192-sparse-join-index-report.md` (where `DIRECT_INDEX_DENSITY` was
set), `notes/2026-09-16-c1198-workspace-sized-from-rows-report.md` and
`notes/2026-09-17-c1200-c1198-repair-pass.md` (the lazy workspace and the fill-versus-walk rule that
removed the mechanism C1192 measured). Repositories: `~/src/ergodis` (core, the evaluator),
`~/src/ergodis-private` (the driver and the harnesses), `~/src/ergodis-dev` (`PERFORMANCE.md`, the
playbook, `retain-bin.sh`, `cache-gc.sh`), `~/src/othello` (this report).

## Arms

Every hash below is recorded **as measured**, never cited: the thing to run is the retain recipe at
the named revision. Both controls were retained **before the first source change of this task**, from
trees whose `git status --short` was empty, checked in the same command that read the revisions.

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
| control, derivation loop | every sweep below; both arms of the sweep are this one binary | `b47ade4` | `ca0609f` | no | `closure_ballpark-b47ade4` | `1b311763668845e34e653dd28bdfb30ef7373975fe54d72757fe57c198bbe682` |
| control, frontend and stratified backend | the Rel route | `b47ade4` | `ca0609f` | no | `ergodis-tools-b47ade4` | `d896673dac0cf60dd27d2528a4608e3d874f5f1b9807fc6bef2f7246adf73c03` |

C1202 named `closure_ballpark-5217cdb` and `ergodis-tools-ab6be13` as this lane's next controls. Both
predate the core audit repair `ca0609f`, so the playbook's "retain at the revision the tree actually
carries" applies and the pair above is retained fresh. **Neither retain hashes equal to its
predecessor** even though `ca0609f` changed two docstrings and one test's policy list and the private
commits since `5217cdb` changed only receipts and Python docstrings: `closure_ballpark` moved from
`616bd0cd…` to `1b311763…` and `ergodis-tools` from `d6495328…` to `d896673d…`. C1202 recorded the
same phenomenon between two of its own arms. It does not reach any figure in this report, because
**every arm of every sweep here is the same executable under two `--index` policies or two
`--max-rows` bounds**, which is the shape C1192 chose so that a compiler difference cannot be the
answer.

Candidate arms are added to this table as they are retained.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `cb43481e0` | the report skeleton, the arms and the Fermi predictions, written before any measurement |
| `ergodis-private` | `16fa25e` | `ab.py` records the per-link probe counter and can run under `choom`; `growing_index_table.py` subtracts the other indexes' cost |
| `ergodis-private` | `f8fb1c1` | the forced-policy sweep with its `closure` companion, and the confound-free sweep on `blocks4` |
| `ergodis-private` | `0638b62` | the block-size and domain families, the replication of the earlier crossover table, and the TLB and cache event runs |
| `ergodis-private` | `6405c1d` | a row-bound axis in `static_index_sweep.py`, per-arm policy in `static_index_stages.py`, and the first-evaluation, whole-process and lookup-census receipts |
| `othello` | `88b9f94e7` | the replication, the confound-free density sweep, the counted mechanism, memory, the fill-versus-walk regime and the first-evaluation stage |
| `ergodis` | `ae3a043` | `DIRECT_INDEX_DENSITY`'s docstring records what the constant actually trades |
| `ergodis` | `4a706f6`, `ergodis-private` `e7d560d` | the source-comment clean-up required by the rule recorded under **Source comments** below |
| `ergodis` | `d56f748` | the committed-page bound stated in terms of the packed key's leading runs |
| `ergodis-private` | `1500dc2` | the reproduction receipt and the one-evaluation crossover receipts |
| `othello` | this report | written incrementally at each milestone |

## Source comments: the rule this task was corrected against

Mid-task, Tavis set a binding rule for every Ergodis repository: **task identifiers, references to
this notes tree, and process notes of any kind are forbidden in source.** Comments, docstrings, test
names, identifiers and error strings carry the technical fact, the invariant, what the caller must
guarantee and the design rationale stated timelessly as a property of the code — the standard is
PostgreSQL's source. Measurement history, A/B and rejected-variant narrative, audit or review
mentions, dates as provenance, agent or model names, and cohort names used as provenance all belong
in the report and the commit message instead. A constant's comment says what quantity it trades and
against what, never which run fitted it.

Three additions of this task failed that rule and were repaired by forward commit
(`ergodis` `4a706f6`, `ergodis-private` `e7d560d`): `DIRECT_INDEX_DENSITY`'s rewritten docstring,
which named three tasks and this report's path and told the measurement story; `ab.py`'s
`--count-probes` paragraph and its `choom` comment, which cited a predecessor task as the reason for
each; and `growing_index_table.py`'s opening, which attributed the isolation defect to a task. Each
was rewritten to stand alone technically — the constant's docstring now states the two costs that
scale with the key space, the page-commit arithmetic and the address-translation trade, and says that
the value hedges two regimes and that moving it needs the evaluation count a plan is not told. The
check that the repair is complete is that
`git diff <start> -- '*.rs' '*.py' '*.sh' '*.toml' | rg '^\+' | rg '\bC[0-9]{3,4}\b|notes/'` is empty
in both repositories against this task's starting revisions (`ergodis` `ca0609f`, `ergodis-private`
`b47ade4`), and that the same added lines contain none of the forbidden vocabulary. Pre-existing
references were **not** touched; they are listed under **Incidental**.

## What the constant decides, and where it can bind at all

`Policy::index_direct` (core `crates/rules/src/demand.rs`) chooses the kind of a join index over a
relation that grows by `keys <= DIRECT_INDEX_DENSITY * rows`, where `rows` is the relation's
**capacity** — `min(universe, row_bound)`, not the rows it derives — and `keys` is
`domain^popcount(mask)`. Two ceilings bind first: `MAX_DIRECT_KEYS = 2^24` refuses the direct array
above 2^24 keys whatever the density, and `MAX_WORKSPACE_BYTES = 2^34` bounds the whole reservation.

Three consequences are arithmetic and are stated here because they set the sweep's shape:

1. **The density rule can only bind on a growing index whose key space is at most 2^24.** In the
   harness's program family the only such index is a fully bound atom over a growing binary
   relation, whose key space is `domain^2`, so the rule binds only at `domain <= 4,096`. At the
   card's suggested second domain of 16,384 the key space is 2^28, `MAX_DIRECT_KEYS` decides alone,
   and the constant is not consulted. The second domain in this report is therefore **2,048** (key
   space 2^22) and not 16,384, and that substitution is a result about the constant's reach rather
   than a convenience.
2. **A growing index on one bound column never reaches the rule either.** Its key space is the
   domain, at most 4,096 here, and the rule sends it direct for any row capacity above 85. So the
   constant is consulted, in practice, for exactly one shape: a two-column-bound index over a
   growing relation at a domain of at most 4,096.
3. **`--max-rows` is the density knob** and the only one that moves the density without moving the
   program: the key space is fixed by the domain and the mask, and the capacity is the caller's
   bound. Density `d` is reached at `--max-rows = 2^24 / d` for `domain = 4,096`. The bound must
   still hold every relation's derived rows, so the top of the sweep is set by the cohort:
   `cycle:blocks<N>:4096` derives `4,096 · N` rows into each of `path` and `back`, so the smallest
   admissible bound is `4,096 · N` and the highest reachable density is `4,096 / N`. `blocks4`
   reaches 1,024 and `blocks2` reaches 2,048.

## The instrument, and how the other indexes are removed by subtraction

The `cycle` plan holds **three** join indexes: `edge` on column 0 (static, key space 4,096), `path`
on column 1 (grows, key space 4,096, and **no live step probes it**, because the step that would is
the one whose delta relation is the never-growing `edge`), and `path` on both columns (grows, key
space `domain^2`). Only the third is the one this task is about.

C1202's instrument — two `--max-rows` bounds under `Policy::Auto`, which flip only the third index
(`ddd` against `dds`) — is confound-free but can only ever bracket the density the shipped constant
already sits at, because `Auto` flips where `keys <= 48 · rows` and nowhere else. A sweep over
density therefore has to force the kind, and the forced policies move every index at once, which is
the isolation defect C1192 recorded.

**The subtraction that removes it exactly.** The `closure` plan over the same edge set holds
`edge` on column 0 and `path` on column 1 — **the same two indexes, with the same key spaces, the
same probe counts and the same row counts as in `cycle`** — and holds no third index, because it has
no rule with a fully bound growing atom. `cycle` is `closure` plus the one rule
`back(x,y) :- path(x,y), path(y,x).` So for each row bound `R`:

- `Δ_other(R)` = (`SparseIndexes` − `Direct`) measured on `closure:blocks<N>:4096` is the whole cost
  of flipping the two indexes that are not under test, at that bound;
- `Δ_all(R)` = the same difference on `cycle:blocks<N>:4096`;
- `Δ_growing(R) = Δ_all(R) − Δ_other(R)` is the large growing index's own contribution.

This is a subtraction of measured absolute per-evaluation counts, not a bound on a share, and it is
stronger than the arithmetic bound C1192 used. It is reported beside the raw `Δ_all` so a reader can
see how much of the effect the subtraction removes. The C1202 `Auto` bracket at densities 41.9 and
55.9 is re-run as the confound-free anchor that the corrected sweep must agree with at that density.

Both arms of every sweep point are **one executable**; the policies are `--index direct` and
`--index sparse-indexes`, which differ in no membership structure (a bitmap is chosen under both,
because `universe <= MAX_DIRECT_UNIVERSE`) and in no demotion decision (`Demand::demote` runs under
`Policy::Auto` only, and `cycle` has no fully bound static atom to demote in any case).

## Fermi predictions, written before any sweep

Written from the compiled shape of `crates/rules/src/demand.rs` at core `ca0609f`, C1202's measured
growing-index table, and C1201's host coefficients (about 61 GiB/s of warm streaming store
bandwidth, about 400 ns for one minor fault). Zen 5 here: 24 logical cores, L2 1 MiB per core, L1
data TLB about 64 entries.

### Prediction 1: the mechanism has changed identity, and it is now the hash, not the fill

C1192's mechanism was the direct shape's `fill(NONE)` over 2^24 words per evaluation. C1198 removed
it: `clear_indexes` walks the previous evaluation's rows whenever the table exceeds
`RESET_FILL_BYTES_PER_ROW = 64` bytes per row, and a 64 MiB head array against at most 131,072 rows
is four hundred times that, so **the direct arm's reset is a walk at every point of this sweep** and
costs one key recomputation and one scattered store per row.

What is left is a **footprint** argument, and it runs the other way from C1192's. The `blocks<N>`
edge set makes `path`'s keys clustered by construction: `key = x · domain + y` with `x` and `y` in
one block of `N` consecutive nodes, so each of the `domain` distinct `x` values owns one run of `N`
consecutive keys, `4N` bytes long. The direct head array therefore touches **`domain` distinct pages
and `domain` distinct cache lines** — 4,096 pages of address space, 256 KiB of actual lines at
`N <= 16` — however large the 64 MiB reservation is. The sparse shape hashes the same keys with a
multiply-shift and **destroys that clustering**: its touched footprint is its whole table,
`4 · table_slots(R)` bytes.

**Predicted**: the crossover is where the sparse table's footprint stops fitting the cache the direct
arm's clustered lines already fit — that is, at `4 · slots` of the order of a few hundred KiB, or
`slots` between 64 K and 128 K, or a row bound between 32,768 and 131,072, or a **density between 128
and 512**. Predicted with lower confidence than the mechanism: a scaling of C1202's measured
`+11.6 per cent` cycle penalty at `slots = 524,288` in proportion to the per-access latency the
sparse table's size implies leaves the sparse arm still about 1 per cent behind at density 1,024, so
the second-most-likely outcome is **the card's outcome 2** — no crossover below the reachable top —
and the least likely is a crossover at or below 256.

### Prediction 2: instructions will say "always direct", and cycles will decide

C1192 and C1202 both found this. The sparse probe adds a multiply-shift hash and a per-row key-column
verification that the direct bucket does not need. C1202 nevertheless measured instruction ratios of
0.990 to 1.030 — at or slightly below unity on three of four cohorts — so the instruction side is
**not** a clean "always direct" here and is predicted to stay within 3 per cent of unity across the
whole sweep, with cycles carrying the decision, as the playbook's second rule of attack ranks memory
traffic above instructions. Predicted: no instruction ratio outside [0.97, 1.04] anywhere in the
sweep.

### Prediction 3: the fill-versus-walk switch is inside the sweep, and it is not where the crossover is

`clear_indexes` fills when `4 · slots <= 64 · rows`. On `cycle:blocks4:4096` the previous
evaluation's `path` rows are 16,384, so the sparse arm fills while `slots <= 262,144` and walks above
it; `table_slots` makes `slots` the power of two at least the bound, so the switch sits between a
bound of 262,144 (density 64, fill) and 524,288 (density 32, walk). The direct arm walks everywhere.
**Predicted**: the switch sits at density 64 for `blocks4`, at 32 for `blocks8`, at 16 for `blocks16`
and at 8 for `blocks32` — that is, at the **low-density** end, below the predicted crossover, and the
two regimes are therefore separable rather than confounded. Predicted second-order effect on the
ratio at the switch: under 2 per cent, because a fill of 1 MiB is about 17 µs of streaming store
against a loop of 1 ms.

### Prediction 4: memory, in closed form

The direct head array commits one page per distinct value of the high-order bound column, which for
`blocks<N>` is `domain` pages: **16 MiB at domain 4,096, independent of `N` and of the row bound**,
against a 64 MiB reservation that stays address space. The sparse table commits `4 · slots` bytes
when it fills, and about `min(4 · slots, 4,096 · rows)` when it walks. **Predicted**: the direct kind
costs about 16 MiB more peak resident memory than the sparse kind at every density above about 4,
and *less* below it — the sparse table at density 1 is 64 MiB committed. So the memory column
crosses at a density near 4 and the time column (predicted) near 128 to 512, and between those two
points the constant is a genuine time-against-memory decision rather than a dominated one. This is
C1202's open item for Tavis in its growing-index form, and it is predicted to be an order of
magnitude smaller than C1202's static case (16 MiB against that cohort's 4.4× on 19 MB).

### Prediction 5: what happens to the constant

If prediction 1's range holds, `DIRECT_INDEX_DENSITY = 48` is **too low by a factor of three to ten**
and the direct kind is being given up over a wide band where it wins. If outcome 2 holds instead, the
density rule for growing indexes is doing no useful work anywhere the ceilings allow and the
recommendation would be to drop it — which is an ask-before item on this card and will be reported
with its numbers rather than implemented.

### Prediction 6: the second domain and the second density family

Predicted: the crossover density does not move materially between domain 4,096 and domain 2,048 at
the same `blocks<N>`, because the mechanism is a footprint ratio and both footprints scale with the
domain; and it *does* move with `N`, downward as `N` grows, because the direct arm's line count grows
with `N` (each `x` owns `4N` bytes) while the sparse arm's does not. Predicted crossover density
roughly proportional to `1/N` beyond `N = 16`, where the direct arm's run exceeds one cache line.

## Method (binding)

`~/src/ergodis-dev/PERFORMANCE.md` and `~/src/ergodis-dev/performance-playbook.md`, both read in full
before any edit or measurement, as were the three repositories' `AGENTS.md`. Event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` at 100 per cent enabled, with
the enabled fraction confirmed in each receipt; cache events in their own run with their own null.
Rounds alternate arm order and every round count is **even** (C1202 open item 4: a 2:1 arm order
biased one null to 0.97). An A/A null per cohort per sweep point. Every run pinned to core 5 and
wrapped in `choom -n 1000`. Two-point differencing between `repeats` and `2 · repeats`. Load average
recorded. Derived counts, digests, work counters and per-index lookup counts asserted equal between
arms at every point. Bulk output under `~/.cache/ergodis/c1203/`.

`perf_event_paranoid` is 2 here, so perf counts user-mode events only: preparation, first touch and
the resident high-water mark are read from **wall time, the minor-fault count and `VmHWM`**, and the
derivation loop is read from instructions and cycles. Each table below says which metric it is read
from.

Two figures are reported for the derivation loop at every point and they are read differently. The
**cycles ratio** is `perf stat`'s, two-point differenced, with its 95 per cent interval and its A/A
null; on this box its A/A null runs to about one per cent and in two places to three, so it is a
band. The **evaluation median** is the driver's own `Instant` over its repeated derivation loop,
taken as the median over rounds of the per-round median of `2 · repeats` evaluations; it is not
differenced and not counted by perf, and on this run it reproduces to **0.1 to 0.2 per cent** on the
internal replicates described below. The two agree in sign and in magnitude everywhere, and where
the cycles interval is too wide to read, the evaluation median is what the bracket is read from.

**The sweep carries its own replicate.** `table_slots` rounds the caller's row bound up to a power of
two, so the pairs of bounds 349,525/262,144, 196,608/131,072, 98,304/65,536, 49,152/32,768 and
24,576/16,384 give the sparse arm **the same table** at two different densities. Each such pair is an
independent repetition of one measurement taken at a different time in the run, and the pairs agree
to 0.1 to 0.2 per cent in the evaluation median throughout. That is this run's own reproducibility
figure, and it is also the first evidence that the variable is the table and not the density.

## Result 1: on the cohort the constant was set from, the crossover is gone

`cycle` at the `blocks` density and N = 4,096 is C1192's cohort — `blocks` is sixteen nodes per
block — and `Policy::Direct` against `Policy::SparseIndexes` at a swept row bound is C1192's
instrument, confound and all. Re-run on the current kernel: eight rounds, repeats 5 and 10, CPU 5
under `choom -n 1000`, event set at 100.00 per cent enabled, load average 0.67 to 0.74, receipt
`analysis/datalog-comparison/ab-2026-09-18-c1203-c1192-replication.json`. Ratios are **sparse ÷
direct**, so above unity means the direct kind is right.

| density | C1192 cycles | this run, cycles | interval | A/A null | this run, evaluation median | corrected by the `closure` subtraction |
| ---: | ---: | ---: | --- | ---: | ---: | ---: |
| 1 | 1.5000 | 1.5194 | [1.419, 1.619] | 0.99811 | 1.4768 | 1.351 |
| 4 | 1.2285 | 1.4673 | [1.399, 1.535] | 1.00293 | 1.4327 | 1.314 |
| 16 | 1.0665 | 1.3239 | [1.305, 1.343] | 0.99706 | 1.3324 | 1.150 |
| 32 | 1.0508 | 1.2086 | [1.180, 1.237] | 1.00189 | 1.2163 | 1.048 |
| 64 | **0.9842** | **1.1942** | [1.175, 1.213] | 0.99414 | 1.1928 | 1.046 |
| 128 | **0.9911** | **1.1914** | [1.175, 1.208] | 0.99271 | 1.1919 | 1.039 |
| 256 | **0.9743** | **1.2026** | [1.188, 1.217] | 1.00856 | 1.1954 | 1.051 |

**The lowest-density end reproduces and the crossover end does not.** At a density of 1 the two runs
agree to 1.3 per cent, which is the check that this is the same instrument on the same machine; from
a density of 32 upward the direct kind is now ahead by 19 to 21 per cent where C1192 measured it
behind by 1.6 to 2.6 per cent. **The bracket C1192 located between 32 and 64, and set
`DIRECT_INDEX_DENSITY = 48` inside, does not exist on this kernel.** After the subtraction that
removes the two indexes the forced policy also flips, the index under test is still ahead by 3.9 to
5.1 per cent at every density from 32 to 256, so the disappearance is not an artefact of C1192's
isolation defect.

That is the card's outcome 2 **for this cohort**: no crossover below the feasibility ceilings. The
highest density measured is 256, and what stops the sweep there is the cohort's own derived rows —
`cycle:blocks:4096` derives 65,536 rows into each of `path` and `back`, and a row bound below that is
`Error::Budget`.

## Result 2: the confound-free sweep, and where a crossover does and does not exist

Below a row bound of 349,526 the shipped rule already sends the index under test sparse, so
`--index auto` and `--index direct` differ in **that index alone** at every bound in this sweep: the
static `edge` index is direct under both (`DIRECT_STATIC_PROBES` floors it by the rows, and it has
12,288 to 131,072 facts against a key space of 4,096), and `path` on column 1 is direct under both
(key space 4,096 against a capacity of at least 4,096). The kinds are `ddd` against `dds` at every
point and the receipts record them. This is C1202's instrument with the bound swept instead of
bracketed, and it needs no subtraction.

Eight rounds, alternating arm order, an A/A null per point, CPU 5 under `choom -n 1000`, event set at
100.00 per cent enabled, load average 0.44 to 0.82. Receipts
`analysis/datalog-comparison/ab-2026-09-18-c1203-auto-blocks<N>-<domain>.json`. Ratios are **sparse ÷
direct**; the evaluation-median column is the one the bracket is read from.

### Domain 4,096, five block sizes

| density | `blocks2` | `blocks4` | `blocks8` | `blocks16` | `blocks32` |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 48 | 1.0476 | 1.0657 | 1.0927 | 1.0557 | 1.0363 |
| 64 | 1.0422 | 1.0263 | 1.0342 | 1.0301 | 1.0231 |
| 85.3 | — | 1.0235 | 1.0289 | 1.0334 | 1.0207 |
| 128 | 0.9986 | 1.0073 | 1.0324 | 1.0171 | 1.0239 |
| 170.7 | — | 1.0074 | 1.0312 | 1.0212 | — |
| 256 | **0.9569** | **0.9846** | 1.0175 | 1.0312 | — |
| 341.3 | — | **0.9823** | 1.0153 | — | — |
| 512 | **0.9487** | **0.9673** | 1.0235 | — | — |
| 682.7 | — | **0.9680** | — | — | — |
| 1,024 | **0.9463** | **0.9790** | — | — | — |
| 2,048 | **0.9767** | — | — | — | — |

Evaluation medians, sparse ÷ direct. A dash is a density the cohort cannot reach: the top of each
column is set by the cohort's derived rows, and the gaps at 85.3, 170.7, 341.3 and 682.7 are bounds
not measured on the larger cohorts to keep their runs short. The direct arm's own evaluation median
is **flat across the whole sweep** — 0.9992 to 1.0081 ms on `blocks4` over a twenty-one-fold range of
row bound, 7.9466 to 7.9986 ms on `blocks16` — which is what the mechanism predicts and is the
control this table needs: the row bound does not reach the direct kind at all.

The cycles ratios agree in sign at every point and are in the receipts with their intervals and
nulls; on `blocks4` they read 1.0719, 1.0363, 1.0235, 0.9991, 1.0059, 0.9703, 0.9747, 0.9781, 0.9754
and 0.9909 against A/A nulls of 0.991 to 1.039. The instruction ratios stay in **[0.9877, 1.0536]**
across every cohort and domain, with A/A nulls inside 2 parts in 10^5, so Fermi prediction 2's
predicted band of [0.97, 1.04] holds everywhere except the two highest-density points of the smallest
domain, where collisions in a table at load factor 0.5 and 1.0 add verification work.

**So a crossover exists on the two smallest block sizes and nowhere else.** On `blocks2` it is
at a density of about **128** (0.9986 here and 1.0018 in the reproduction run, unity within the
between-run drift; the direct kind is ahead at 64 and behind at 256), on `blocks4` between **170.7 and 256**, and on `blocks8`,
`blocks16` and `blocks32` there is none up to the highest density each can reach — 512, 256 and 128 —
with the direct kind ahead by 1.5 to 3.5 per cent throughout.

### Two more domains

| density | `blocks4`, domain 2,048 | `blocks4`, domain 1,024 |
| ---: | ---: | ---: |
| 48 | 0.9979 | 1.0457 |
| 64 | 0.9817 | 1.0463 |
| 85.3 | 0.9843 | — |
| 128 | 0.9764 | 1.0996 |
| 170.7 | 0.9756 | — |
| 256 | 1.0127 | 1.0950 |
| 341.3 | 1.0142 | — |
| 512 | 1.0184 | — |

**Domain 2,048 crosses in the other direction**: the sparse kind is ahead by 1.6 to 2.4 per cent from
a density of 48 to 171 and behind by 1.3 to 1.8 per cent from 256 up, so its crossing at 171 to 256
has the opposite sign to `blocks4`'s at domain 4,096. **Domain 1,024 does not cross at all** and the
direct kind's margin *grows* with density, from 4.6 to 10.0 per cent. Fermi prediction 6 said the
crossover density would not move materially between domains 4,096 and 2,048 because both footprints
scale with the domain; that is **wrong**, and wrong in a way that is itself the result: the direct
arm's footprint scales with the domain in **pages**, and the page is a fixed 4 KiB, so halving the
domain halves the direct arm's page count without halving anything on the sparse side.

## Result 3: the mechanism, counted

C1192 named the mechanism with counted cache events: the direct shape's `fill(NONE)` over 2^24 words
per evaluation, which made the sparse arm issue 36 per cent of the direct arm's last-level cache
references. C1198 removed that fill. The supplementary runs here say the mechanism is now a different
one, and they are two separate runs with their own A/A nulls, six rounds each, repeats 9 and 18,
100.00 per cent enabled, load 0.67 to 0.74. Receipts
`ab-2026-09-18-c1203-tlb-blocks4-4096.json` and `ab-2026-09-18-c1203-cache-blocks4-4096.json`, both
on `cycle:blocks4:4096`, ratios sparse ÷ direct.

| density | cycles | `ls_l1_d_tlb_miss.all` | its A/A null | `ls_l1_d_tlb_miss.all_l2_miss` | its null | `L1-dcache-loads` | `L1-dcache-load-misses` | `cache-references` |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 48 | 1.0733 | **2.0939** | 1.0002 | 0.0487 | 1.0178 | 1.0126 | 1.0902 | 1.0511 |
| 128 | 1.0132 | **1.0250** | 0.9996 | 0.0047 | 1.0032 | 1.0213 | 0.9914 | 0.9215 |
| 256 | 0.9981 | **0.3573** | 0.9996 | 0.0423 | 1.0102 | 1.0163 | 0.9408 | 0.8676 |
| 512 | 0.9865 | **0.2194** | 1.0015 | 0.0226 | 0.9821 | 1.0189 | 0.9418 | 0.9229 |
| 1,024 | 0.9720 | **0.1738** | 1.0013 | 0.0036 | 1.0110 | 1.0318 | 0.9459 | 0.9227 |

**The L1 data-TLB miss ratio crosses unity between a density of 128 and 256, which is where the
cycles ratio crosses unity, and no other counter does.** At the low-density end the sparse arm misses
the L1 data TLB twice as often as the direct arm; at the high-density end it misses it a fifth as
often, and the cycles follow. The L1 data-cache loads are 1.3 to 3.2 per cent higher on the sparse
arm at every point, exactly as C1192 found and for the same reason — the hash, the chain and the
key-column verification — and the L1 load misses and last-level references move by less than the
TLB counter does and in the same direction as the cycles only where the TLB counter already explains
them. `cache-misses` carries A/A nulls of 0.89 to 1.20 on these points and is not read.

**The mechanism in one sentence.** The `blocks<N>` edge set makes `path`'s keys clustered by
construction — `key = x · domain + y` with both in one block of `N` consecutive nodes, so each of the
`domain` distinct leading values owns one run of `4N` consecutive bytes — and a direct-addressed head
array therefore touches `domain` **pages** however large its reservation, while the multiply-shift
hash of the sparse shape scatters those same keys over its whole table and touches
`min(4 · slots, 4,096 · rows)` bytes. The comparison is between `domain` pages entered `3N + 1` times
each and `slots` random slots in a table of `4 · slots` bytes, and the crossing is where the second
stops costing more address translations than the first. That is why the answer moves with the block
size and with the domain and **not with the density**: the density enters only through `slots`.

Fermi prediction 1 predicted a footprint mechanism and a crossing between densities 128 and 512 on
`blocks4`; the crossing is between 128 and 256 by cycles and between 171 and 256 by the evaluation
median, so the range was right. The prediction named the cache as the resource and the measurement
says it is the TLB, which is the sharper answer and the one the counted events supply.

## Result 4: the fill-versus-walk regime, located exactly

`clear_indexes` fills a table when `4 · slots <= 64 · rows`, the rows being the previous evaluation's.
The direct arm's head array is 2^24 slots against at most 131,072 rows, so it is four hundred times
the boundary and **walks at every point of every sweep here** — which is precisely the mechanism
C1192 measured being gone. The sparse arm's table is `table_slots(bound)`, so it walks while
`table_slots(bound) > 16 · rows` and fills below:

| cohort | previous evaluation's rows | fill admitted while `slots <=` | walks at these densities | fills at these densities |
| --- | ---: | ---: | --- | --- |
| `blocks2:4096` | 8,192 | 131,072 | 48, 64 | 128 and above |
| `blocks4:4096` | 16,384 | 262,144 | 48 | 64 and above |
| `blocks8:4096` | 32,768 | 524,288 | none | all |
| `blocks16:4096` | 65,536 | 1,048,576 | none | all |
| `blocks32:4096` | 131,072 | 2,097,152 | none | all |
| `blocks4:2048` | 8,192 | 131,072 | none | all |
| `blocks4:1024` | 4,096 | 65,536 | none | all |

**The switch sits at the low-density end and the crossover does not.** On `blocks4` the single
largest step in the sweep is the one across the switch — 1.0657 at density 48, where the sparse arm
walks 16,384 scattered stores, against 1.0263 at 64, where it fills 1 MiB — and on `blocks2` the same
step is 1.0422 to 0.9986. Both crossovers are three or more points above the switch and sit entirely
inside the fill regime, so the two regimes are separable and neither crossover is a fill-versus-walk
artefact. Fermi prediction 3 located the switch correctly on `blocks4` and put its size at "under 2
per cent"; measured it is **3.8 per cent** on `blocks4` and 4.2 on `blocks2`, so the prediction was
right about where and low by about a factor of two about how much.

## Result 5: memory, beside every ratio

Peak resident set, `VmHWM`, from the same receipts. The direct arm's figure does not move with the
row bound at all, and the sparse arm's tracks its table.

| cohort | peak RSS, direct | peak RSS, sparse at density 48 | at 256 | at 1,024 | direct − sparse, high density |
| --- | ---: | ---: | ---: | ---: | ---: |
| `blocks2:4096` | 25,064 KiB | 10,732 | 8,940 | 8,748 | **+16,316 KiB** |
| `blocks4:4096` | 27,360 | 13,028 | 11,236 | 11,044 | **+16,316** |
| `blocks8:4096` | 31,756 | 17,424 | 15,632 | — | **+16,124** |
| `blocks16:4096` | 38,284 | 23,952 | 22,160 | — | **+16,124** |
| `blocks32:4096` | 52,428 | 38,096 | — | — | **+15,356** at density 128 |
| `blocks4:2048` | 14,220 | 6,544 | 6,096 | — | **+8,124** |
| `blocks4:1024` | 8,348 | 4,384 | 4,272 | — | **+4,076** |

**The direct kind's resident cost is one page per distinct leading key value, and that is `domain`
pages**: 16 MiB at domain 4,096, 8 MiB at 2,048, 4 MiB at 1,024, independent of the block size and of
the row bound, against a reservation of `4 · keys` bytes — 64 MiB at domain 4,096 — that stays
address space. Fermi prediction 4 predicted exactly this closed form and the 16 MiB figure, and
predicted that the memory column crosses near a density of 4 while the time column crosses far above
it; the memory part is confirmed to the kilobyte and the crossing densities are 4 and 171 to 256, so
the band in which the constant is a genuine time-against-memory decision is the one the prediction
named. At the density where the shipped constant actually decides, the direct kind costs **2.1 times
the peak resident set** of the sparse kind on `blocks4` and buys 6.6 per cent of the warm loop.

## Result 6: the first evaluation, and what it does to the whole decision

Everything above is a **warm** figure. `ab.py`'s two-point differencing removes process startup,
preparation and the first evaluation from every per-iteration ratio by construction, so C1192's
bracket, C1202's table and results 1 to 5 above are all statements about a derivation loop entered
repeatedly on one workspace. The card asks for the other stage, and it inverts the decision.

`static_index_sweep.py` at `--repeats 1` times exactly one evaluation of a fresh workspace;
at `--repeats 9` the same figure is the median of nine. Six rounds, alternating arm order, CPU 5 under
`choom -n 1000`. Receipts `sweep-2026-09-18-c1203-stages-blocks<N>-repeats<1|9>.json`. Wall time and
`VmHWM`, which is what a first-touch stage is read from; the minor-fault counts are below.

| cohort | density | first evaluation, direct | first evaluation, sparse | ratio | warm, direct | warm, sparse | ratio |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `blocks4:4096` | 48 | 9.880 ms | 4.203 ms | **0.425** | 1.0079 ms | 1.0786 ms | 1.070 |
| `blocks4:4096` | 128 | 9.974 | 3.872 | **0.388** | 1.0089 | 1.0424 | 1.033 |
| `blocks4:4096` | 256 | 9.791 | 3.696 | **0.378** | 1.0045 | 1.0019 | 0.997 |
| `blocks4:4096` | 512 | 9.616 | 3.278 | **0.341** | 1.0057 | 0.9735 | 0.968 |
| `blocks4:4096` | 1,024 | 7.425 | 2.441 | **0.329** | 1.0069 | 0.9833 | 0.977 |
| `blocks16:4096` | 48 | 15.308 | 11.139 | **0.728** | 8.0077 | 8.3749 | 1.046 |
| `blocks16:4096` | 128 | 15.292 | 10.700 | **0.700** | 8.0430 | 8.2210 | 1.022 |
| `blocks16:4096` | 256 | 15.248 | 10.662 | **0.699** | 8.0702 | 8.3443 | 1.034 |

**The first evaluation of a direct-addressed growing index costs 2.4 to 3.0 times the sparse kind's
on `blocks4` and 1.4 times on `blocks16`**, and the absolute premium — 4.2 to 6.3 ms on `blocks4`,
4.2 to 4.6 ms on `blocks16` — is the first touch of those `domain` pages. Against a warm saving of
0.03 to 0.37 ms per evaluation, the break-even is:

| cohort | density | direct's extra first evaluation | direct's warm saving per evaluation | evaluations to repay |
| --- | ---: | ---: | ---: | ---: |
| `blocks4:4096` | 48 | 5.677 ms | 0.0707 ms | **80** |
| `blocks4:4096` | 128 | 6.102 | 0.0335 | **182** |
| `blocks4:4096` | 256 | 6.095 | −0.0026 | never |
| `blocks4:4096` | 512 | 6.338 | −0.0322 | never |
| `blocks16:4096` | 48 | 4.169 | 0.3672 | **11.4** |
| `blocks16:4096` | 128 | 4.592 | 0.1780 | **25.8** |
| `blocks16:4096` | 256 | 4.586 | 0.2741 | **16.7** |

**The whole process is the one-evaluation shape, and the sparse kind wins it everywhere.** The
driver's `--process` mode reads the facts, prepares, evaluates once and writes the CSV; at the row
bound where the shipped constant actually decides — 349,525, a density of 48 — six rounds on one
binary under the two policies give, from
`analysis/datalog-comparison/stages-2026-09-18-c1203-process-density48.json`:

| cohort | whole process, direct | whole process, sparse | ratio | process peak RSS, direct | sparse | minor faults, direct | sparse |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `cycle:blocks2:4096` | 8.676 ms | 4.051 ms | **0.467** | 24,732 KiB | 10,400 | 10,912 | 3,746 |
| `cycle:blocks4:4096` | 15.218 | 9.309 | **0.612** | 26,728 | 12,396 | 11,505 | 4,339 |
| `cycle:blocks16:4096` | 34.383 | 30.225 | **0.879** | 38,116 | 23,784 | 15,895 | 8,729 |
| `cycle:blocks32:4096` | 74.309 | 70.269 | **0.946** | 53,452 | 39,120 | 21,409 | 14,243 |

Preparation is unmoved between the arms — 2.743 against 2.751 ms on `blocks4`, 24.985 against 24.971
on `blocks32` — because a growing index builds nothing at preparation; the whole of the difference is
the first evaluation's first touch, and the minor-fault column counts it: 7,166 more faults on
`blocks4`, which is the 4,096 pages of the head array plus the pages the sparse arm's own table does
not need.

## Result 7: the one-evaluation regime has its own crossover, and it is at a density of 4 to 16

The table above stops at density 48 because that is the highest density at which `Auto` still chooses
the direct kind, and the one-evaluation comparison has to continue below it to find where the direct
kind starts being right. Below 48 the confound-free instrument does not exist, so this is the forced
policy with the `closure` subtraction, at `--repeats 1` so that the timed evaluation is the first one:
six rounds, alternating arm order, wall time and `VmHWM`. Receipts
`sweep-2026-09-18-c1203-first-eval-{cycle,closure}.json`, `cycle:blocks4:4096` against
`closure:blocks4:4096`.

| density | first evaluation, direct | sparse, raw | `Δ_all` | `Δ_other` | `Δ_growing` | corrected ratio | peak RSS, direct | sparse |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 9.768 ms | 30.143 | +20.375 | +5.488 | **+14.888** | **2.524** | 27,324 KiB | 75,364 |
| 4 | 9.739 | 16.464 | +6.726 | +4.686 | **+2.040** | **1.210** | 27,324 | 41,216 |
| 16 | 9.771 | 7.499 | −2.273 | +1.714 | **−3.986** | **0.592** | 27,324 | 19,120 |
| 48 | 9.790 | 5.713 | −4.077 | +1.115 | **−5.192** | **0.470** | 27,324 | 15,024 |
| 128 | 8.273 | 3.671 | −4.603 | +0.570 | **−5.173** | **0.375** | 27,324 | 11,952 |
| 256 | 7.376 | 3.073 | −4.303 | +0.534 | **−4.837** | **0.344** | 27,324 | 11,440 |

**The one-evaluation crossover is between a density of 4 and 16, and the peak resident set crosses in
the same interval** — 41,216 KiB against 27,324 at density 4, 19,120 against 27,324 at 16. Both are
the same arithmetic: the direct kind commits one page per distinct leading key value, which is
`domain` pages, and the sparse kind commits about `min(4 · slots, 4,096 · rows)` bytes, and the two
are equal at `slots = 1,024 · domain`, which for domain 4,096 is a row bound of about 4.2 million and
a density of 4. Fermi prediction 4 named that crossing at "a density near 4" from the closed form
before any of this was measured.

**So the two regimes have two different crossovers, an order of magnitude apart, and they bracket the
shipped constant rather than agreeing with it.** A plan evaluated once wants the direct kind below a
density of about 4 to 16; a plan evaluated many times wants it below 128 on the smallest block sizes
and at every reachable density on the larger ones. `DIRECT_INDEX_DENSITY = 48` sits between them.

## Result 8: the reproduction, and the between-run drift

An independent re-run of the confound-free sweep on `cycle:blocks4:4096` and `cycle:blocks2:4096`,
taken **under a deliberately different load** — a full `cargo test --all-features -j 12` of the core
was running, and the run's recorded load average is **8.93 to 11.02** against the original run's 0.44
to 0.82. Same binary, same arms, same eight rounds, receipt
`ab-2026-09-18-c1203-reproduction-underload.json`.

| density | `blocks4` first run | `blocks4` re-run | drift | `blocks2` first run | `blocks2` re-run | drift |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 48 | 1.0657 | 1.0738 | +0.8 pt | 1.0476 | 1.0583 | +1.1 pt |
| 64 | 1.0263 | 1.0308 | +0.4 | 1.0422 | 1.0510 | +0.8 |
| 128 | 1.0073 | 1.0009 | −0.6 | 0.9986 | 1.0018 | +0.3 |
| 256 | 0.9846 | 0.9801 | −0.5 | 0.9569 | 0.9604 | +0.4 |
| 512 | 0.9673 | 0.9724 | +0.5 | 0.9487 | 0.9479 | −0.1 |
| 1,024 | 0.9790 | 0.9782 | −0.1 | 0.9463 | 0.9430 | −0.3 |

Evaluation medians, sparse ÷ direct. **Between-run drift is at most 1.1 percentage points and the
sign is unchanged at every one of the twelve points**, so both brackets reproduce: `blocks4` crosses
between 128 and 256 in both runs and `blocks2` sits within three parts in a thousand of unity at 128
in both.

**The cycles ratios do not survive the load and are not read from this run.** Their A/A nulls run
0.80 to 1.13 and their intervals span half a unit, which is the playbook's own statement that cycle
intervals widen with box load while the decision-grade figures do not; the instruction ratios
reproduce to five decimals across the two runs at every point. This is the reason the brackets above
are read from the evaluation median rather than from `perf`'s cycle counter, and it is stated rather
than worked around.

## How the Fermi predictions came out

| Prediction | Outcome |
| --- | --- |
| 1, the mechanism is a footprint argument and not the fill, with a crossing between densities 128 and 512 on `blocks4` | **Right on both, and the counted events sharpen it.** The crossing is between 128 and 256; the prediction named the cache as the resource and the measurement says it is the **L1 data TLB**, whose miss ratio between the two kinds crosses unity at the same point and is the only counter that does. The prediction also said the direct arm would be independent of the row bound, and its evaluation median is flat to 0.9 per cent over a twenty-one-fold range. |
| 1, second-most-likely outcome: no crossover below the reachable top | **Right for five of the seven cohorts measured** — every block size of eight and above at domain 4,096, and domain 1,024 — which the prediction called the less likely branch and which is the majority answer. |
| 2, instruction ratios stay inside [0.97, 1.04] with cycles deciding | **Right except at two points.** The measured range is [0.9877, 1.0536]; the two points above 1.04 are domain 1,024 at densities 128 and 256, where the sparse table's load factor reaches 0.5 and 1.0 and collisions add key verification. Cycles decided everywhere. |
| 3, the fill-versus-walk switch sits at density 64 on `blocks4` and below the crossover, worth under 2 per cent | **Right about where and low by a factor of two about how much.** The switch is exactly at 64 on `blocks4` and 128 on `blocks2`, three or more points below both crossovers, and it is worth 3.8 and 4.2 per cent. |
| 4, the direct kind commits `domain` pages — 16 MiB at domain 4,096 — independent of block size and row bound, and the memory column crosses near density 4 | **Right to the kilobyte.** 16,316 KiB at domain 4,096, 8,124 at 2,048, 4,076 at 1,024, unmoved by the block size and the bound; the resident sets cross between densities 4 and 16, and so does the first evaluation. |
| 5, the constant is too low by a factor of three to ten, or the rule should be dropped | **Both wrong, and this is the prediction the result contradicts.** The warm loop wants a higher value and the one-evaluation regime wants a much lower one; the shipped 48 sits **between** the two crossovers this task located, so no single value is right and neither direction is an improvement on its own. |
| 6, the crossover density does not move between domains 4,096 and 2,048, and moves downward with the block size | **Half right.** It moves downward with the block size as predicted — from never on `blocks8` and above to 128 to 256 on `blocks4` and about 128 on `blocks2` — and it does **not** hold across domains: domain 2,048 crosses with the opposite sign and domain 1,024 does not cross at all, because the direct arm's footprint scales with the domain in pages and a page is a fixed size. |

## Disposition

**`DIRECT_INDEX_DENSITY` is left at 48, and this report is the measurement that keeps it.** The
docstring is repaired (`ergodis` `ae3a043`, `4a706f6`) because its stated justification described a
cost the kernel no longer pays; no policy line, no constant and no public API changed, so there is no
kind change to validate, no cohort table to re-run and no parity digest to move.

The reasoning, with the numbers:

1. **No value of a density constant is right across the measured set.** The warm loop puts the
   crossover at about 128 on `blocks2`, between 128 and 256 on `blocks4`, and nowhere below the
   ceilings on `blocks8`, `blocks16`, `blocks32` and domain 1,024; domain 2,048 crosses with the
   opposite sign. Raising the constant to 128 would gain at most 3.5 per cent of the warm loop on the
   cohorts where the direct kind is right and lose up to 5.4 per cent on the two where it is not.
2. **Lowering it is worse, not better.** Below a density of 48 the direct kind is right on every
   measurement taken here, in the warm loop (1.05 to 1.52 at densities 1 to 32), in the first
   evaluation (2.52 and 1.21 at densities 1 and 4) and in peak resident memory (27,324 KiB against
   75,364 at the default row bound). At the **default** bound of 2^24 the density is 1 at domain
   4,096, so in ordinary use the constant is not near its decision point at all; it only decides for
   a caller who passes a small `--max-rows`.
3. **The two regimes bracket it.** A plan evaluated once wants the direct kind below a density of 4
   to 16; a plan evaluated many times wants it below 128 or everywhere. 48 lies between. That is a
   hedge, and this report says so in the docstring rather than claiming a measured crossover.

**The decision left open for Tavis**, stated with its numbers and not taken here, is whether the
growing index's rule should read the **evaluations a plan expects** instead of a density. The
evidence for it is the break-even table: 11 to 182 evaluations to repay the direct kind's first
touch, against a driver, a differential and a Rel route that all evaluate once, and a whole process
that is 1.6 times faster and holds 2.2 times less resident memory under the sparse kind at the
density where the constant decides. Acting on that is either a change to how a plan is built (it
would have to be told the count) or dropping the density rule for growing indexes, and the card fences
both, so neither is implemented. **The recommendation is to allocate that as a successor rather than
to move this constant**, because moving it cannot express the finding.

## Acceptance, per card bullet

| Card bullet | Status |
| --- | --- |
| Where do cycles cross on the current kernel, swept from density 1 through at least 1,024 | **Answered.** Density 1 to 256 on the cohort the constant was set from (no crossing; the direct kind ahead by 19 to 21 per cent raw and 3.9 to 5.1 corrected), and 48 to 1,024 on `blocks4`, 48 to 2,048 on `blocks2`, under a confound-free instrument. The crossing is between 128 and 256 on `blocks4` and about 128 on `blocks2`; there is none on the other five cohorts. |
| A second program and a second domain | **Second domain: done**, and two of them — 2,048 and 1,024 — with the card's suggested 16,384 shown to be **outside the constant's reach** (key space 2^28 exceeds `MAX_DIRECT_KEYS`, so the ceiling decides alone). **Second program: not possible in the committed harness**, and that is a measured statement rather than an omission: of its seven programs only `cycle` has a join index over a **growing** relation whose key space exceeds the domain. `mutual` and `triangle` have `domain^2` indexes over the **input** relation, `samegen`'s growing indexes bind one column, and `closure`, `path3` and `path4` have none. Named as a successor below. |
| Does the fill-versus-walk switch sit near the crossover | **Answered, with the boundary computed per cohort and confirmed.** The direct arm walks everywhere; the sparse arm's switch is at density 64 on `blocks4`, 128 on `blocks2` and outside the sweep on every other cohort. Both crossovers sit three or more points above it, inside the fill regime. |
| What does the direct kind cost in peak RSS and committed pages where it wins | **Answered in closed form and measured**: one page per distinct leading key value, `domain` pages, 16,316 KiB at domain 4,096, 8,124 at 2,048 and 4,076 at 1,024, independent of the block size and the row bound; 2.1 times the sparse kind's whole peak at the density where the constant decides. RSS is beside every ratio in every table. |
| First evaluation against repeated evaluation at the bracket points | **Answered, and it changed the disposition.** The direct kind's first evaluation costs 2.4 to 3.0 times the sparse kind's on `blocks4` and 1.4 times on `blocks16`, the whole process is 1.06 to 2.14 times slower, and the break-even is 11 to 182 evaluations. |
| The cache-event run at the bracket points; does the counted traffic agree with the mechanism claimed | **Done, in two supplementary runs with their own nulls**, and the answer is that the claimed mechanism had to be corrected: the L1 data-cache and last-level counters move by less than the cycles do, and the L1 data-TLB miss ratio crosses unity exactly where the cycles ratio does. |
| The isolation defect addressed or re-priced | **Addressed two ways.** The primary sweep uses `--index direct` against `--index auto`, which differs in the index under test alone at every bound below 349,526 with the kinds recorded per point; and where a forced policy is unavoidable — below density 48, and in the replication of the earlier table — the other indexes' cost is removed by measuring the same difference on the `closure` plan, which holds those indexes and not the one under test. |
| One binary; derived counts, digests, work counters and per-index lookup counts equal at every point; `--count-probes` in receipts | **Done.** Every arm of every sweep is `closure_ballpark-b47ade4`. `ab.py` refuses any point whose arms disagree on the output digest, the derived, probe, candidate and round counts, and — under the flag added here — the total and per-index lookup counts; no point was refused. The census receipt `ab-2026-09-18-c1203-lookup-census.json` carries the per-index lookups for all seven cohorts, which closes the predecessor's three unreceipted figures. |
| Even round counts | **Done**: every timing run is eight rounds and every stage run six. |
| Reproduced by an independent re-run hours apart or under a different load, with drift stated | **Done under a different load** — 8.93 to 11.02 against 0.44 to 0.82 — with drift at most 1.1 percentage points and no sign change at any of twelve points. The cycles ratios do not survive that load and are said not to. |
| If the constant changes, the full validation battery | **Not applicable**: it does not change. |
| If the constant does not change, say so with the measurement that keeps it | **Done** under **Disposition**. |
| Gates | **Done**: core `cargo test --all-features` (exit 0, 82 `test result: ok` blocks, zero `FAILED`), clippy `-D warnings` clean, `cargo fmt --check` clean, the allocation regression green under every policy, `generate_evidence.py --write` in the same commit as the source change, `ruff` clean on all four harness scripts, private `cargo fmt --check` clean, and the private workspace test suite (exit 0, 42 `test result: ok` blocks, zero `FAILED`), which is where the frontend, lowering, portability and reference-evaluation differentials run. |

## The `ej` and `tt` closeout

### The variable the rule should read is derivable from what the plan already knows

The two costs that decide this are `distinct leading key values` (the pages the direct head array
commits, and the pages its probes enter) and `slots` (the sparse table's footprint). The plan knows
`slots` exactly — it is `table_slots(capacity)`. It does **not** know the distinct leading values of a
relation that has not been derived yet, but it knows an upper bound, the domain, and for the shapes
this evaluator compiles the leading bound column is a variable ranging over the domain, so `domain` is
the bound and it is tight whenever the relation covers its leading column. That is enough to state
the direct kind's committed pages as `min(domain^(popcount(mask) - 1) · something, keys) · 4 / page`
at plan time — the cheap version being simply `domain` pages for a two-column key. **Taken here:**
nothing is built, but the report records that the quantity is available, which is what a successor
needs to know before it is allocated.

### The probe counter already estimates the other half

`Demand::estimate_probes` exists and the per-link counter measures it. A rule on
`committed pages × fault cost` against `probes × probe saving` is the same shape as the static rule
already shipped, with one new term — the fault cost — and one unknown, the evaluation count. So the
successor is not a new mechanism but the existing static rule with a first-touch term. **Taken here:**
recorded, not built; the card fences it.

### What Terence Tao would ask that this task did not

*Is the block structure of the cohort doing the work, rather than the index?* The `blocks<N>` edge set
makes the keys maximally clustered, which is the best case for a direct array and the worst for a
hash. A cohort whose keys are **uniform** over the key space would remove the direct arm's page
advantage entirely and should cross far lower. Every cohort here is `blocks<N>`, so the measured
crossovers are all from one key distribution, and the report's claims are stated for it. **This is
the largest unexamined degree of freedom in the result** and it is named as open item 1 rather than
patched: the harness's `sparse` and `dense` densities give uniform keys but their transitive closures
at these domains are far too large to sweep, so a new generator is needed and that is a successor.

*Is `table_slots`'s power-of-two rounding hiding a factor of two?* It is visible rather than hidden:
the pairs of bounds that round to one table agree to 0.1 to 0.2 per cent, which is how this run knows
its own reproducibility, and it means the effective grid is the powers of two and the density axis is
a relabelling of it. **Taken here:** the report reads every bracket as a `slots` bracket as well as a
density bracket, and the disposition rests on the `slots` reading.

*Why is the instruction ratio below unity on most cohorts when the sparse path does strictly more
work per probe?* The sparse kind adds a hash, a chain load and a key-column verification and should
cost more instructions at equal probes; measured it is 0.987 to 1.001 on most points. Unexplained,
and carried as open item 2.

### Cheap items taken

- `ab.py` now records the per-link probe counter and can run under `choom -n 1000`, which closes the
  predecessor's two recorded harness gaps in one commit.
- `static_index_sweep.py` gained a row-bound axis and `static_index_stages.py` per-arm policy and
  arguments, so a single binary under two policies is now a first-class arm in both stage scripts
  rather than only in `ab.py`.
- `growing_index_table.py` makes the subtraction that isolates one index reproducible from a receipt.
- The constant's docstring no longer asserts a cost the kernel does not pay.

### Cheap items not taken

- Adding a program with a large growing index to the driver: it is the only way to get a second
  program and it is a driver change with its own fixture and digest, which is a successor and not a
  closeout item.
- A `perf record` profile: every measurement here is a counted A/B or a wall-and-fault stage, and no
  question in the card is about where inside the loop the time sits.

## Mystery ledger

### Settled

1. **Where the crossover went.** The mechanism the constant was set from — a linear fill of the whole
   key space before every evaluation — is gone, because a table above the fill boundary is now
   cleared by walking the rows that wrote it, and a 2^24 head array is four hundred times that
   boundary at every size reachable here. On the cohort the constant was set from, the direct kind is
   now ahead at every density the ceilings allow.
2. **What replaced it.** Address translation, counted rather than inferred: the L1 data-TLB miss
   ratio between the two kinds crosses unity at the same point as the cycle ratio, while the
   data-cache and last-level counters do not.
3. **Why the answer depends on the block size.** The direct head array commits and enters one page
   per distinct leading key value and the number of entries per page is the rows per leading key, so
   a relation with more rows per key amortizes the same pages over more accesses; the sparse table
   has no such structure.
4. **Why the answer depends on the domain.** The direct arm's footprint scales with the domain in
   pages, and a page is a fixed size, so halving the domain halves the direct arm's page count while
   nothing on the sparse side moves.
5. **Whether the fill-versus-walk switch confounds the crossover.** It does not: it sits three or more
   points below both crossovers, its position is computed exactly per cohort, and both crossovers are
   inside the fill regime.
6. **Whether the density is the variable.** It is not. Each bracket is equally a `slots` bracket, the
   internal replicates that share a table at two densities agree to 0.1 to 0.2 per cent, and the sign
   of the answer moves with the block size and the domain at a fixed density.
7. **What the direct kind costs in memory.** One page per distinct leading key value, confirmed to the
   kilobyte at three domains, independent of the block size and the row bound.

### Open

1. **Every cohort here has clustered keys, and the crossover may be an artefact of that.**
   `blocks<N>` gives the direct array its best case. The evidence gap is a cohort with keys uniform
   over `domain^2` and a derived count small enough to sweep; the harness has no such generator, and
   `sparse` and `dense` at these domains derive far too much. Owner: a successor that adds one.
2. **The sparse kind costs fewer instructions than the direct kind on most cohorts**, 0.987 to 1.001,
   although its probe does strictly more work. The evidence gap is a disassembly of the two probe
   paths and of `bucket`'s bounds check against a 64 MiB slice versus a small one. Owner: a
   successor; nothing in this task's decision turns on it.
3. **The first-touch premium is 1.4 µs per page, not the 400 ns a minor fault costs here.** 4,096
   pages against a measured 4.2 to 6.3 ms of extra first evaluation. Page-table construction over a
   64 MiB reservation and the TLB cost of the first pass are the candidates; neither is separated.
   The evidence gap is a fault-count and wall-time stage that varies the reservation size at a fixed
   page count. Owner: open.
4. **Two retained binaries do not hash equal across commits that change no compiled line.** Observed
   again here on both `closure_ballpark` and `ergodis-tools`. It reaches nothing in this report
   because every arm is one binary, but it means a retained control cannot be reproduced bit for bit
   from its revision. Owner: open, and it is the predecessor's observation as well.
5. **Whether the whole-process advantage survives a plan that is evaluated twice or three times.**
   The break-even is 11 evaluations on `blocks16` and 80 to 182 on `blocks4`, so the answer is
   presumably no, but no stage here runs two or three evaluations of one plan. The evidence gap is a
   `--repeats 2,3,5` stage. Owner: whoever takes the evaluation-count successor.

## Candidates to queue, no identifiers allocated

1. **A rule on committed pages against probes, with an evaluation count.** The finding this task
   cannot act on: the growing index's kind is decided by the pages the direct array commits, the
   faults they cost, and how many evaluations amortize them. The static rule already has the shape;
   this adds a first-touch term and needs the plan to be told the count. **This is the recommended
   next item.**
2. **A uniform-key cohort for the growing index.** Open item 1, and the check on every crossover in
   this report. Needs a generator whose transitive closure is bounded but whose keys are spread over
   `domain^2`.
3. **A second program with a large growing index**, so no constant rests on one program's shape.
4. **Record the core revision in `retain-bin.sh`'s manifest**, which the predecessor named and did not
   do; it is why this report's Core column is a session record rather than a recoverable figure.
5. **Why two binaries differ when no compiled line does** — open item 4, a reproducibility question
   about retained controls rather than a performance one.
6. **The per-probe instruction anomaly**, open item 2.

## Replay commands

Run from `~/src/ergodis-private` unless noted. Every gate and every measurement went through
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin.
Working files under `~/.cache/ergodis/c1203/`.

```sh
# Gates, core, at 4a706f6. Outcome: exit 0, 82 `test result: ok` blocks, zero
# FAILED; clippy, fmt and the public lint clean; the allocation regression green
# under every policy.
cd ~/src/ergodis
nix develop . --command cargo test --all-features --no-fail-fast -j 12
nix develop . --command cargo clippy --all-targets --all-features -j 12 -- -D warnings
nix develop . --command cargo fmt --all -- --check
nix develop . --command cargo test -p ergodis-rules --test allocation -j 12
nix develop . --command python3 python/generate_evidence.py --write   # SHA256SUMS
cd ~/src/ergodis-private

# Gates, private.
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test \
    -p ergodis-private -p ergodis-tools --no-fail-fast -j 8
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check
nix shell nixpkgs#ruff -c ruff check analysis/datalog-comparison/ab.py \
    analysis/datalog-comparison/static_index_{sweep,stages}.py \
    analysis/datalog-comparison/growing_index_table.py

# The one arm, retained with the tree at its own revision and `git status
# --short` empty, checked before the recipe ran. Both sweep arms are this binary.
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example   # private b47ade4, core ca0609f
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools      # private b47ade4, core ca0609f

A=analysis/datalog-comparison; C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1203
B=$C/closure_ballpark-b47ade4
AUTO="--a $B --a-args '--index direct' --a-name direct --b $B --b-args '--index auto' --b-name sparse"

# The confound-free density sweep: one binary, two policies, the row bound swept.
# Below a bound of 349,526 the two policies differ in the index under test alone.
# Outcome: a crossing between 128 and 256 on blocks4 and about 128 on blocks2;
# none on blocks8, blocks16, blocks32 or domain 1,024.
nix develop ~/src/ergodis --command python3 $A/ab.py $AUTO \
    --mode evaluate --rounds 8 --cpu 5 --repeats 9 --choom --cohorts cycle:blocks4:4096 \
    --sweep '--max-rows 349525;--max-rows 262144;--max-rows 196608;--max-rows 131072;--max-rows 98304;--max-rows 65536;--max-rows 49152;--max-rows 32768;--max-rows 24576;--max-rows 16384' \
    --work $W/auto-b4 --out $A/ab-2026-09-18-c1203-auto-blocks4-4096.json
# and the same with --cohorts cycle:blocks8:4096 (bounds to 32768, --repeats 9),
# cycle:blocks16:4096 (to 65536, --repeats 5), cycle:blocks32:4096 (to 131072,
# --repeats 3), cycle:blocks2:4096 (to 8192), cycle:blocks4:2048 (bounds 87381 …
# 8192) and cycle:blocks4:1024 (bounds 21845 … 4096).

# The replication of the earlier crossover table: that table's own cohort, its
# own forced-policy instrument, with the closure companion that prices the two
# indexes the forced policy also flips. Outcome: the low-density end reproduces
# to 1.3 per cent and the crossover end is gone.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $B --a-args '--index direct' \
    --a-name direct --b $B --b-args '--index sparse-indexes' --b-name sparse \
    --mode evaluate --rounds 8 --cpu 5 --repeats 5 --choom \
    --cohorts cycle:blocks:4096,closure:blocks:4096 \
    --sweep '--max-rows 16777216;--max-rows 4194304;--max-rows 1048576;--max-rows 524288;--max-rows 262144;--max-rows 131072;--max-rows 65536' \
    --work $W/c1192-repl --out $A/ab-2026-09-18-c1203-c1192-replication.json
python3 $A/growing_index_table.py $A/ab-2026-09-18-c1203-c1192-replication.json \
    --base closure --table          # the corrected column
python3 $A/growing_index_table.py $A/ab-2026-09-18-c1203-auto-blocks4-4096.json \
    --base '' --table               # every confound-free sweep reads this way

# The mechanism: two supplementary runs, each with its own A/A null.
nix develop ~/src/ergodis --command python3 $A/ab.py $AUTO --mode evaluate --rounds 6 \
    --cpu 5 --repeats 9 --choom --cohorts cycle:blocks4:4096 \
    --events 'instructions,cycles,ls_l1_d_tlb_miss.all,ls_l1_d_tlb_miss.all_l2_miss' \
    --sweep '--max-rows 349525;--max-rows 131072;--max-rows 65536;--max-rows 32768;--max-rows 16384' \
    --work $W/tlb-b4 --out $A/ab-2026-09-18-c1203-tlb-blocks4-4096.json
nix develop ~/src/ergodis --command python3 $A/ab.py $AUTO --mode evaluate --rounds 6 \
    --cpu 5 --repeats 9 --choom --cohorts cycle:blocks4:4096 \
    --events 'cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses' \
    --sweep '--max-rows 349525;--max-rows 131072;--max-rows 65536;--max-rows 32768;--max-rows 16384' \
    --work $W/cache-b4 --out $A/ab-2026-09-18-c1203-cache-blocks4-4096.json

# The first evaluation against the warm loop, same cohorts, two repeat counts.
for rep in 1 9; do
  nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py --bin $B \
      --work $W/stages-r$rep --program cycle --densities blocks4 --domains 4096 \
      --arms direct,auto --row-bounds 349525,131072,65536,32768,16384 \
      --rounds 6 --repeats $rep --count-probes \
      --out $A/sweep-2026-09-18-c1203-stages-blocks4-repeats$rep.json
done   # and --densities blocks16 with --row-bounds 349525,131072,65536

# The one-evaluation crossover below density 48, where only a forced policy
# reaches, with the closure subtraction. Outcome: it crosses between 4 and 16.
for p in cycle closure; do
  nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py --bin $B \
      --work $W/first-$p --program $p --densities blocks4 --domains 4096 \
      --arms direct,sparse-indexes \
      --row-bounds 16777216,4194304,1048576,349525,131072,65536 \
      --rounds 6 --repeats 1 --out $A/sweep-2026-09-18-c1203-first-eval-$p.json
done

# The whole process, one binary under two policies, at the bound where the
# constant decides. Outcome: sparse ÷ direct of 0.467 to 0.946.
nix develop ~/src/ergodis --command python3 $A/static_index_stages.py --a $B \
    --a-name direct --a-index direct --a-args '--max-rows 349525' --b $B \
    --b-name sparse --b-index auto --b-args '--max-rows 349525' --work $W/proc-48 \
    --rounds 6 --repeats 9 --count-probes \
    --cohorts cycle:blocks4:4096,cycle:blocks16:4096,cycle:blocks2:4096,cycle:blocks32:4096 \
    --out $A/stages-2026-09-18-c1203-process-density48.json

# The lookup census, which is not a timing run: two rounds of one repeat, with
# the per-link counter recorded and asserted equal between the arms.
nix develop ~/src/ergodis --command python3 $A/ab.py $AUTO --mode evaluate --rounds 2 \
    --cpu 5 --repeats 1 --choom --count-probes \
    --cohorts cycle:blocks2:4096,cycle:blocks4:4096,cycle:blocks8:4096,cycle:blocks16:4096,cycle:blocks32:4096,cycle:blocks4:2048,cycle:blocks4:1024 \
    --sweep '--max-rows 349525;--max-rows 131072;--max-rows 65536' \
    --work $W/census --out $A/ab-2026-09-18-c1203-lookup-census.json

# The reproduction, taken under a different load.
nix develop ~/src/ergodis --command python3 $A/ab.py $AUTO --mode evaluate --rounds 8 \
    --cpu 5 --repeats 9 --choom --cohorts cycle:blocks4:4096,cycle:blocks2:4096 \
    --sweep '--max-rows 349525;--max-rows 262144;--max-rows 131072;--max-rows 65536;--max-rows 32768;--max-rows 16384' \
    --work $W/repro --out $A/ab-2026-09-18-c1203-reproduction-underload.json
```

Inputs are deterministic: the `blocks<N>` density is the complete digraph inside each consecutive
block of `N` nodes, which uses no random stream at all, and `cycle:blocks<N>:<domain>` derives
`domain · N` rows into each of `path` and `back` whatever the row bound.

## Incidental

Two observations this task was not looking for.

**Pre-existing task references in Ergodis source.** The rule recorded under **Source comments** binds
new work; the trees already carry references that predate this task and were **not** touched. In
`~/src/ergodis`: `crates/rules/src/demand.rs`, `crates/verify/src/datalog.rs`, and the tests
`crates/rules/tests/{allocation,demand_sparse,demand_prepared,workspace_commit,demand_nary}.rs`. In
`~/src/ergodis-private`: `examples/closure_ballpark.rs`,
`src/{proof_synthesis,fabric_routing,tiger_blossom_graph,hall_core,transcript_leakage,causal_abstraction}.rs`,
`src/feature_interval/audit.rs`, and under `analysis/`,
`check_notebook_integration.py`, `sage/check_qldpc_certificate.py`, `campaign-console/bake_run.py`
and `datalog-comparison/static_index_sweep.py` and `static_index_stages.py`. The listing is a bounded
`rg -l -m 1` over `crates/`, `src/`, `python/`, `analysis/` and `examples/` and is not exhaustive
beyond those roots. The main agent owns the sweep.

**A growing index that no live step probes is still built, reset and filled every evaluation.**
`path` on column 1 in both the `cycle` and the `closure` plans receives **zero** bucket lookups — the
step that would probe it has a delta relation that never grows, so it never runs — and yet it is
inserted into on every round and cleared on every evaluation, at a cost proportional to the relation's
rows. Under a forced sparse policy at the default row bound it is also given a 64 MiB table for a key
space of 4,096. The predecessor's queued candidate "do not build an index no live step probes" is
about the static case; this is the growing case and it is strictly worse, because the static one pays
once at preparation and this one pays every evaluation. Not acted on here.

## What this task left under `~/.cache/ergodis/`

**Two retained binaries**, `bin/closure_ballpark-b47ade4` and `bin/ergodis-tools-b47ade4`, both
recorded `clean` in `bin/MANIFEST.tsv` at private `b47ade4` and core `ca0609f`. The first is the one
arm of every measurement here and **is the control the next A/B in this lane should use**, unless the
core docstring commits `ae3a043` and `4a706f6` are taken as a reason to retain afresh — they change
no compiled line, but the observation under mystery ledger item 4 is that this does not guarantee an
identical binary.

**`c1203/`, 26 MB**: the work directories of every run in the replay block — `auto-b2`, `auto-b2b`,
`auto-b4`, `auto-b4-1024`, `auto-b4-2048`, `auto-b8`, `auto-b16`, `auto-b32`, `c1192-repl`,
`cache-b4`, `census`, `first-cycle`, `first-closure`, `proc-48`, `repro`, `smoke`, `stages-r1`,
`stages-r9`, `sweep-b4`, `tlb-b4`, and the two generated fact files. Everything here regenerates from
the replay block.

**No `perf-c1203/`**: this task took no `perf record` profile. Every measurement is a `perf stat` A/B
through `ab.py` or a wall-time and fault-count stage through the two sweep scripts.

`../ergodis-dev/scripts/cache-gc.sh` was run **as a dry run only and nothing was deleted; that is
Tavis's call.** It scanned 41 entries and lists six as unreferenced and old enough to remove —
`c1190-audit`, `c1190-milestone-c-audit`, `c1191`, `c1191-audit`, `perf-c1191` and `perf-c1192`,
together about 1.8 MB. This task's `c1203` is kept as younger than two days. The largest entries it
lists are `certdist` at 270 MB, `c985` at 104 MB, `worktrees` at 105 MB, `split` at 31 MB,
`c1203` at 26 MB, `representation-attribution` at 16 MB and `corpora` at 13 MB; `bin/` is **713 MB**,
which is still where the growth in this cache is.

## Resume state

| Repository | HEAD at close | Range this task added |
| --- | --- | --- |
| `~/src/ergodis` | `d56f748` | `ca0609f` … `d56f748`, all documentation: no policy line, constant or public item changed |
| `~/src/ergodis-private` | `1500dc2` | `b47ade4` … `1500dc2`, the four harness changes and the receipts |
| `~/src/othello` | this report's last commit | `cb43481e0` … here |

Nothing is half-built and no path is untracked in any of the three repositories.

## Vibe check

Good, and the answer is not the one the card expected. The crossover the constant was set from is
**gone** — on its own cohort, under its own instrument, the direct kind is now ahead at every density
the ceilings allow — and where a crossover still exists it is at 128 to 256 rather than 48 and it
moves with the block size and the domain, so no density constant is right across the set. The counted
events say the mechanism is now the data TLB rather than memory traffic, which is a cleaner
explanation than the one predicted. The finding that matters most was not on the card at all: every
ratio in this lane's history is a **warm-loop** ratio, and on the first evaluation — the shape the
driver, the differential and the Rel route all actually run — the direct kind costs 2.4 to 3.0 times
the sparse kind's time and twice its resident memory. The constant stays at 48 because it sits
between two real crossovers and moving it cannot express that; the successor that can is a rule that
reads the evaluations a plan expects.

