# C1201 — the static join index's build cost: a rule for its representation

**Lane**: `ergodis`
**Date**: 2026-09-17
**Status**: IN PROGRESS. Written incrementally from the start of the task; the Fermi predictions
below were written and committed **before any code change**.

Task card: the C1201 row allocated at the C1193 closeout (`e0441b3ed`). Predecessors:
`2026-09-16-c1192-sparse-join-index-report.md` (the four addressing kinds and its deviation 5, which
priced the probe and not the build), `2026-09-16-c1198-workspace-sized-from-rows-report.md` (the
lazy `Pages` reservation, applied to the workspace and not to the plan),
`2026-09-17-c1193-nary-bodies-report.md` (the n-ary bodies that made `triangle` the cohort where
this cost is visible, and whose closeout measured it).

Repositories: `~/src/ergodis` (core, the evaluator), `~/src/ergodis-private` (drivers and
harnesses), `~/src/ergodis-dev` (`PERFORMANCE.md`, the playbook, `retain-bin.sh`, `cache-gc.sh`),
`~/src/othello` (this report).

## Arms

Every hash below is recorded **as measured**, never cited: the thing to run is the retain recipe at
the named revision. Both controls were retained from trees whose `git status --short` was empty,
**checked before the recipe ran** (this is the repair the C1193 audit asked for), and **before the
first source change of this task**.

Retain recipes, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

Both re-execute themselves inside `nix develop` of the core checkout, whose devShell asserts its
rustc equals the `rust-toolchain.toml` pin.

| Arm | Role | Private | Core | Dirty | Retained name | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, derivation loop | the kernel A/B | `3c8499d` | `09a5c2b` | no | `closure_ballpark-3c8499d` | `7f10dbc575abf84b0c72744163c6edf4fa5952b603f03395e18d89da02ef737b` |
| control, frontend and stratified backend | the Rel route | `3c8499d` | `09a5c2b` | no | `ergodis-tools-3c8499d` | `eee4551ee11e6a74d0940f1e854fd88963e2ad366ee9c22779f4edf86b19bd54` |

`MANIFEST.tsv` records `clean` for both rows, and `git status --short` was empty in
`~/src/ergodis-private` and in `~/src/ergodis` immediately before each recipe ran. The C1193 report
named `closure_ballpark-cb11550` and `ergodis-tools-cb11550` as the controls for the next A/B in this
lane; both are flagged `dirty` in the manifest and both predate the private default-body-policy flip
`3c8499d`, so they are **not** used as controls here. They are used once, and only once, to
reproduce the C1193 preparation figures.

Candidate arms are added to this table as they are retained.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | (this commit) | the report skeleton, the reproduced baseline and the Fermi predictions, written before any code |

## What the shipped policy does, reproduced

`Policy::Auto` sends a join index over a **static** relation to the direct counting-sorted CSR
whenever its key space fits `MAX_DIRECT_KEYS` = 2^24, with no reference at all to how many rows the
relation has. C1192 made that choice deliberately and recorded it as deviation 5: the
counting-sorted bucket beat a binary search over the distinct keys at every density its ceiling
allows. That measurement was of the **probe**. Nothing priced the **build**.

Reproduced on the retained control `closure_ballpark-3c8499d`, pinned to core 5, three then nine
repeats, `triangle` under the n-ary body policy:

| Program | `--index` | index kinds chosen | preparation | peak RSS | evaluation (median of 9) |
| --- | --- | --- | ---: | ---: | ---: |
| `triangle` 4,096 | `auto` | direct, **direct**, direct | 31.15 ms | 71,508 KiB | 1.289 ms |
| `triangle` 4,096 | `sparse-indexes` | sparse, sparse, sparse | 3.38 ms | 5,852 KiB | 2.369 ms |
| `triangle` 16,384 | `auto` | direct, **sparse**, direct | 12.92 ms | 15,256 KiB | 11.529 ms |
| `triangle` 16,384 | `sparse-indexes` | sparse, sparse, sparse | 15.27 ms | 15,068 KiB | 15.144 ms |

The three indexes of the n-ary `triangle` plan are, in order: `edge` on column 0 (key space
`domain`), `edge` on **both** columns (key space `domain²`, the fully bound third atom), and `edge`
on column 1 (key space `domain`). The relation has `3 · domain` rows at the `sparse` density, so
the three densities (key space per row) are `1/3`, `domain/3` and `1/3`.

**This reproduction changes the shape of the problem the card poses, and it is the most useful thing
measured before any code.** At N = 16,384 the big index's key space is 2^28, which is *above*
`MAX_DIRECT_KEYS`, so `Auto` already holds it sparsely — and the mixed choice it lands on there,
**small indexes direct and the big one sparse**, is both the cheapest preparation (12.92 against
15.27 ms) and the fastest evaluation (11.529 against 15.144 ms) of the two available policies. The
forced `sparse-indexes` arm is worse on *every* axis at 16,384. So the target configuration is not
"sparse like the `sparse-indexes` row"; it is the mixed choice that the ceiling produces by accident
at 16,384 and that nothing produces at 4,096. A density rule is exactly the thing that produces it
at both sizes, and the 16,384 row is a natural control for it: the rule must reproduce the choice
the ceiling already makes there, so preparation, RSS, evaluation, work counts and the output digest
must all be unmoved at 16,384.

The card's `--index auto` figures (27 ms, 71 MB, 0.87 ms) reproduce within the drift expected of a
different binary and a different body-policy default: 31.15 ms and 71,508 KiB here, and the
evaluation figure differs because the card's was a three-repeat median and this is a nine-repeat
median on a pinned core.

## Fermi predictions, written before any code

Written from the compiled shape of `crates/rules/src/demand.rs` at core `09a5c2b`, the measured
31.15/3.38 ms preparation split above, and this host's memory coefficients (about 20 GB/s of
streaming store bandwidth and about 400 ns for one minor fault, both from C1198's cold-start stage).

### Prediction 1: where the 27.8 ms of extra preparation sits

`Index::csr` is five passes over an `offsets` array of `keys + 1` `u32`, which is 64 MiB at
`keys` = 2^24:

1. `vec![0u32; keys + 1]` — `alloc_zeroed`, which `pages.rs` already documents as glibc `calloc`
   serving a large request and then zeroing it with an explicit `memset`: 16,384 minor faults and
   64 MiB of stores. **Predicted 6.5 ms of fault time plus 3.2 ms of stores ≈ 10 ms.**
2. The counting pass: one random increment per row, 12,288 rows into a 64 MiB array, every one a
   miss. **Predicted 12,288 × 100 ns ≈ 1.2 ms.**
3. The exclusive scan `for k in 1..offsets.len()` — a sequential read-modify-write over the whole
   array, 128 MiB of traffic. **Predicted 6.4 ms.**
4. The placement pass: 12,288 random read-modify-writes. **Predicted 1.2 ms.**
5. `offsets.copy_within(..keys, 1)` — a 64 MiB `memmove`, 128 MiB of traffic. **Predicted 6.4 ms.**

Plus the `munmap` at drop. **Total predicted ≈ 26 ms against a measured 27.8 ms**, which closes to
7 per cent — good enough to price candidates from, and it says the cost is memory traffic over the
key space and not instructions over the rows. **The metric each stage is read from**: preparation is
wall time and minor faults, because `perf_event_paranoid` is 2 on this host and the whole of stages
1 and 5 is kernel time and streaming stores that a user-mode instruction count barely sees.

### Prediction 2: the density rule, and what it is worth

A rule `key_space <= D_static · rows` for a **static** index, with `rows` the relation's exact fact
count (for a non-growing relation `RelationPlan::capacity` *is* `fact_of.len()`, so the rule needs no
new input). At `triangle` 4,096 the three densities are `1/3`, `1,365` and `1/3`, so any `D_static`
between about 4 and 1,000 gives the mixed choice: the two small indexes direct, the big one sparse.

**Predicted for `triangle` 4,096 under the rule**: preparation at the `sparse-indexes` row plus the
two small direct builds, which are 16 KiB arrays and cost microseconds — **3.4 to 3.6 ms**, a
**0.11** ratio. Peak RSS **5.9 MB**, a **0.082** ratio. Evaluation **between the two rows and near
the direct one**: the small indexes' probes are the ones the direct kind wins, and the big index's
direct probe is a random load into a 64 MiB array — a guaranteed last-level miss at about 80 to 200
cycles — against a binary search over 12,288 distinct `u64` keys, 96 KiB that fits L2, at about
13.6 iterations of a few instructions each. **So the big index's direct probe is predicted to be no
better than the sparse one and plausibly worse**, and the prediction is evaluation **at or below the
1.289 ms all-direct figure**, i.e. a ratio of **0.95 to 1.05 against `auto`** and **0.41 to 0.45
against `sparse-indexes`**.

That last part is the prediction most likely to be wrong, and it is the one that makes this a
representation decision rather than a preparation fix: if it holds, the direct CSR at 2^24 keys is
losing on the probe as well as the build and deviation 5 was measured at densities where the
offsets array still fitted cache.

**Predicted for `triangle` 16,384 under the rule**: nothing moves, because the ceiling already
produces the same choice. Preparation, RSS, evaluation and the output digest within the A/A null.

**Predicted for the C1192 and C1193 cohorts**: the `closure`, `samegen`, `mutual` and `cycle`
families index a *growing* relation, which `DIRECT_INDEX_DENSITY` already rules on, so their choice
cannot move. The static index in every one of them is `edge` (or `parent`) on one column, key space
`domain` and `3 · domain` or `domain` rows, so density `1/3` or `1` — far below any plausible
`D_static`, and their choice cannot move either. **Predicted: no kind change on any C1192 or C1193
cohort, so their instruction ratios are within the A/A null by construction, not by measurement.**
The one cohort at risk is `path4` at 4,096, whose last atom may be fully bound; its key space is
checked in the results.

### Prediction 3: eliminating the shift, which is free

`copy_within(..keys, 1)` exists because the placement pass uses the `offsets` array as its own
cursor and so destroys the starts. It does not have to. Counting into `offsets[key + 2]` in an array
of `keys + 2` entries, scanning inclusively from index 1, and placing with `offsets[key + 1]` as the
cursor leaves, after placement, `offsets[key]` = start of bucket `key` and `offsets[key + 1]` = end
of bucket `key` — because `offsets[key]` was the *end* cursor of bucket `key - 1`, which is the start
of bucket `key`, and `offsets[0]` is never written by placement. An empty bucket is correct too: its
cursor is never advanced, so start equals end. **The probe expression `offsets[key]..offsets[key+1]`
is unchanged, so this is a build-only change with no kernel change at all**, costs four extra bytes,
and removes stage 5. **Predicted saving 6.4 ms at 2^24 keys, and a proportional 20 to 25 per cent of
every direct static build.** It is worth taking on its own merits and it is worth taking *before*
the crossover sweep, because a cheaper direct build moves `D_static` up.

### Prediction 4: a lazy `Pages` reservation for the plan's offsets array — and why the
page-skipping scan is impossible without touching the probe

Replacing `vec![0u32; keys + 1]` with a `Pages<u32>` `MAP_NORESERVE` reservation removes stage 1's
`memset` (predicted 3.2 ms of stores at 2^24) but **not** its faults, because the scan writes every
page anyway. **Predicted saving 3 ms at 2^24 keys and nothing at a small key space**, where `calloc`
serves from the arena and the pages are already warm. After prediction 2 no index at 2^24 keys is
direct at all, so this is predicted to be worth **almost nothing in the shipped configuration** and
is priced here rather than built.

The larger version — skip untouched pages in the scan, carrying the running total across gaps, with a
per-page touched bitmap from the counting pass — **cannot be made correct without changing the
probe**, and the argument is short enough to settle it now. The probe reads
`offsets[key] .. offsets[key + 1]`, so the array must be monotone non-decreasing at *every* adjacent
pair. An untouched page reads as zeros. Take a key `k` that is the last entry of a written page and
`k + 1` the first entry of an unwritten one: `offsets[k]` is the running total `R` and
`offsets[k + 1]` is a stale zero, so the probe forms the range `R..0` and Rust's slice index panics.
Take the mirror case and the probe forms `0..R`, a spurious bucket of `R` rows. Dilating the touched
set by one page on each side does not fix it: the boundary between a written and an unwritten page
simply moves, and the same pair recurs wherever the running total is already non-zero. **What the
zeros of an untouched page can encode correctly is a `(start, length)` or a packed `(start, end)`
pair per key — `(0, 0)` is a valid empty bucket at every position, needing no monotonicity — and
that is a change to the `KIND_CSR` probe arm's arithmetic**, which would move the instruction count
of every cohort whose kind does not change and so fails this task's own acceptance criterion.
**Recorded as not built, with its reason, and not as an omission.**

### Prediction 5: a plan-owned open-addressed hash over the distinct keys

Priced and **not built, because it is not "no new kernel"**. The existing `KIND_HASHED` arm reads
`workspace.indexes[step.index].head[scatter(key, index.slot_mask)]` and then walks
`workspace.indexes[step.index].next[row]`, chaining through *workspace* storage sized from the
growing relation's capacity, with `join::<true, _>` re-verifying the key columns per row. A
plan-held hash over distinct keys has neither the workspace arrays nor the per-row chain — it would
hold contiguous buckets like the two static kinds — so it needs its own probe arm and its own
`next_row` case. **Predicted, had it been built**: a build of `rows` insertions into a power-of-two
table of `2 · distinct_keys` slots, so about `3 · rows` random writes into `24 · rows` bytes — at
`triangle` 4,096 that is 288 KiB and about 0.1 ms, cheaper than the sorted kind's
`rows log rows` sort, and a probe of one hash, one load and one key comparison against a table that
fits L2. It is the shape that would beat both existing static kinds at this density. It is a fifth
kind and a kernel change, and this task's deliverable is a representation *decision*, so it is
queued.

### What is chosen, and why

**Candidate (a), the static density rule, and prediction 3's free build repair.** (a) is the only
one of the four that changes no kernel instruction on any cohort whose chosen kind does not change,
which is this task's acceptance criterion; prediction 3 is build-only and its probe expression is
textually and semantically identical. (b) and (c) are priced above and queued. `D_static` is
measured, not assumed, and the crossover is stated in terms the plan has at preparation:
`key_space` and the relation's exact row count.

**The amortization the plan does not know.** The direct build is paid once per plan and the probe
saving accrues per evaluation, so the true crossover depends on how many evaluations a plan serves,
which `Demand::new_bounded` cannot know. The rule is therefore written for **one evaluation**, and
that choice is justified rather than assumed: the driver's own `--evaluate-only` mode amortizes over
its repeats, `compare.py` measures a whole process that evaluates once, and the C1189 differential
evaluates each of its 1,200 programs once. A plan that is evaluated thousands of times would want a
larger `D_static`, and the measurement below reports the crossover as a function of the evaluation
count so that a future policy with a caller-supplied hint has the curve to read.

## The crossover, measured

### Method

The sweep is **three points on one binary**, which is what the forced policies exist for. With
`DIRECT_STATIC_DENSITY` temporarily set to 4, `--index auto` on the n-ary `triangle` gives *direct,
sparse, direct* and `--index direct` gives *direct, direct, direct*, so the two arms differ in
**exactly one index's kind** — the fully bound third atom's, whose key space is `domain²` against
`3 · domain` rows. Sweeping the domain therefore sweeps that one index's density, and every other
structure in the plan, every work count and the output digest are identical between the arms (the
sweep asserts the digest, the derived count and the probe count per point and refuses otherwise).
Rounds alternate the arm order. Pinned to core 5 with `taskset -c 5`, under `choom -n 1000`.

Preparation and peak RSS are read from **wall time and the resident high-water mark**, not from
instruction counts: `perf_event_paranoid` is 2 on this host, so `perf` counts user-mode events only,
and the dominant parts of a direct build are `calloc`'s zeroing, the minor faults of first touch and
streaming stores. Evaluation is the median of the driver's own repeated derivation loop.

### The sweep

Coarse pass, three rounds of nine repeats, load average 5.9 to 7.8 (recorded; wall ratios widen with
load, which is why the crossover is bracketed rather than quoted to a digit):

| domain | facts | density of the big index | prep, all direct | prep, big sparse | RSS, all direct | RSS, big sparse | eval, all direct | eval, big sparse | eval ratio | evaluations to break even |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 32 | 96 | 10.7 | 0.0588 ms | 0.0574 ms | 3,340 KiB | 3,336 KiB | 0.0059 ms | 0.0100 ms | 0.59 | 0.3 |
| 64 | 192 | 21.3 | 0.0769 | 0.0765 | 3,368 | 3,360 | 0.0106 | 0.0203 | 0.52 | 0.0 |
| 128 | 384 | 42.7 | 0.1374 | 0.1215 | 3,452 | 3,404 | 0.0200 | 0.0423 | 0.47 | 0.7 |
| 256 | 768 | 85.3 | 0.2864 | 0.2136 | 3,720 | 3,504 | 0.0408 | 0.0907 | 0.45 | 1.5 |
| 512 | 1,536 | 170.7 | 0.7476 | 0.3849 | 4,644 | 3,692 | 0.0822 | 0.1865 | 0.44 | 3.5 |
| 1,024 | 3,072 | 341.3 | 2.4838 | 0.7492 | 8,232 | 4,132 | 0.1820 | 0.4108 | 0.44 | 7.6 |
| 2,048 | 6,144 | 682.7 | 8.5259 | 1.4919 | 21,284 | 4,896 | 0.5052 | 0.8980 | 0.56 | 17.9 |
| 4,096 | 12,288 | 1,365.3 | 29.3571 | 2.8990 | 71,856 | 6,316 | 1.3258 | 2.0437 | 0.65 | 36.9 |

Fine pass across the crossover, five rounds of fifteen repeats, load average 5.6 to 5.9:

| domain | facts | density | Δ preparation (direct − sparse) | Δ evaluation (sparse − direct) | evaluations to break even | preparation + one evaluation, direct ÷ sparse |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 96 | 288 | 32.0 | +0.0034 ms | +0.0165 ms | 0.2 | 0.907 |
| 128 | 384 | 42.7 | +0.0118 | +0.0231 | 0.5 | 0.934 |
| 160 | 480 | 53.3 | +0.0171 | +0.0272 | 0.6 | 0.953 |
| 192 | 576 | **64.0** | +0.0288 | +0.0369 | 0.8 | **0.968** |
| 224 | 672 | **74.7** | +0.0546 | +0.0431 | 1.3 | **1.042** |
| 256 | 768 | 85.3 | +0.0729 | +0.0511 | 1.4 | 1.071 |
| 320 | 960 | 106.7 | +0.1161 | +0.0602 | 1.9 | 1.144 |
| 384 | 1,152 | 128.0 | +0.1807 | +0.0786 | 2.3 | 1.228 |

**The one-evaluation crossover is bracketed between a density of 64 and 74.7**, where the
preparation-plus-one-evaluation ratio crosses unity and the break-even evaluation count crosses one.
Linear interpolation puts it at about 69. `DIRECT_STATIC_DENSITY` is set to **64**, the conservative
end of the bracket, and deliberately so: above the crossover the direct build's cost grows with the
key space without bound (28 ms and 65 MB at a density of 1,365), while below it the sparse choice
gives up a bounded fraction of one evaluation.

### The Fermi prediction this refutes, and it is the important one

**Prediction 2 said the direct probe into a 64 MiB offsets array would be no better than a binary
search over an L2-resident key array, and plausibly worse. It is wrong, and not marginally: the
direct probe is ahead at every density measured, by a factor of 1.5 to 2.3.** The eval-ratio column
is 0.44 to 0.65 from a density of 10.7 to 1,365, so C1192's deviation 5 was right about the probe
even at the ceiling — the counting-sorted bucket beats the binary search over the whole range, and
the 64 MiB array's cache behaviour never turns the comparison over.

That changes what this task is and what it can deliver. **The static index's whole problem is its
build, and the two existing static kinds are a strict trade rather than a dominance**: the direct
kind is faster to probe everywhere and slower to build above a density of about 69. A rule can
therefore buy preparation and resident memory only by *giving up* evaluation, and the card's
acceptance line — preparation and peak RSS at the sparse row **and** evaluation at the direct row —
**cannot be met by any choice between these two kinds**. It needs a third representation that is
cheap to build and O(1) to probe, which is the card's own candidate (c), priced below and not built.
This is stated as an unmet acceptance criterion rather than reinterpreted.

### The build repair (prediction 3), measured alone

Interleaved seven rounds, both arms at `--index direct` so the kinds are identical, control
`closure_ballpark-3c8499d` against the staggered-cursor candidate, event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` at **100.00 per cent enabled**,
load average 2.7 to 3.4:

| domain | keys | preparation, control | preparation, candidate | ratio | minor faults, both | fault ratio | instruction ratio |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | 262,144 | 0.7979 ms | 0.7756 ms | 0.972 | 527 | 1.000 | 0.999 |
| 1,024 | 1,048,576 | 2.5174 | 2.3873 | 0.948 | 1,442 | 1.000 | 0.993 |
| 2,048 | 4,194,304 | 8.5771 | 8.1536 | 0.951 | 4,716 | 1.000 | 0.984 |
| 4,096 | 16,777,216 | 30.3048 | 28.1225 | **0.928** | 17,391 | 1.000 | 0.973 |

Removing the `keys`-entry `memmove` takes **7.2 per cent off the direct build at the ceiling** and
about 5 per cent from a quarter of the way down. The fault count is identical to the unit, which is
the check that the change is a pass removal and not a change of footprint, and the user-mode
instruction ratio moves the same way (0.973), which is the check that the removed pass was real
executed work and not only memory traffic.

**Fermi prediction 3 was right about the mechanism and wrong about the size, by a factor of three**:
it predicted 6.4 ms at 2^24 keys from 128 MiB of traffic at 20 GB/s and measured 2.18 ms, which is
58 GB/s. The 20 GB/s figure came from C1198's *cold-start* stage, where every store also takes a
minor fault; a warm `memmove` over an already-resident 64 MiB array on this host runs at nearly three
times that. The cost model is corrected here rather than the measurement being explained away: warm
streaming traffic on this host is about 58 GB/s and cold first-touch traffic is about 20.

One bookkeeping note on that table: the candidate's peak RSS reads 400 KiB above the control's at
**every** domain, including 512, where the offsets array is 1 MiB and the change adds four bytes. A
constant offset at every size is the two binaries differing, not the change; it is confirmed against
the retained candidate below.

## Which cohort's choice changes, and the rule that changed it

Every C1192 and C1193 cohort, plus both path families at both sizes, under `Policy::Auto` on the
control and on the candidate. `S` marks a static relation and `G` a growing one; `d` and `s` are the
direct and sparse kinds in the plan's index order. The density is the key space over the relation's
rows, which for a static relation is its exact fact count and for a growing one is the plan's
capacity.

| Cohort | facts | control | candidate | changed | per-index key space / rows = density (kind) |
| --- | ---: | :---: | :---: | :---: | --- |
| `closure:sparse:256` | 768 | `dd` | `dd` | no | S 256/768 = 0.33 (d) · G 256/65,536 = 0.004 (d) |
| `closure:sparse:1024` | 3,072 | `dd` | `dd` | no | S 1,024/3,072 = 0.33 (d) · G 1,024/1,048,576 (d) |
| `closure:dense:256` | 16,384 | `dd` | `dd` | no | S 256/16,384 = 0.02 (d) · G (d) |
| `closure:dense:512` | 65,536 | `dd` | `dd` | no | S 512/65,536 = 0.01 (d) · G (d) |
| `samegen:sparse:1024` | 1,023 | `ddd` | `ddd` | no | S 1,024/1,023 = 1.0 (d) · G ×2 (d) |
| `samegen:dense:512` | 1,021 | `ddd` | `ddd` | no | S 512/1,021 = 0.5 (d) · G ×2 (d) |
| `closure:blocks:4096` | 61,440 | `dd` | `dd` | no | S 4,096/61,440 = 0.07 (d) · G (d) |
| `closure:blocks:16384` | 245,760 | `dd` | `dd` | no | S 16,384/245,760 = 0.07 (d) · G (d) |
| **`mutual:blocks:4096`** | 61,440 | `d` | `s` | **yes** | S 16,777,216/61,440 = **273.1** (d → s) |
| `mutual:blocks:8192` | 122,880 | `s` | `s` | no | S 67,108,864/122,880 = 546.1 (s, above the ceiling already) |
| `cycle:blocks:4096` | 61,440 | `ddd` | `ddd` | no | S 4,096/61,440 = 0.07 (d) · G 4,096/2^24 (d) · **G 2^24/2^24 = 1.0 (d)** |
| **`triangle:sparse:4096`** | 12,288 | `ddd` | `dsd` | **yes** | S 4,096/12,288 = 0.33 (d) · S 16,777,216/12,288 = **1,365.3** (d → s) · S 0.33 (d) |
| `triangle:sparse:16384` | 49,152 | `dsd` | `dsd` | no | S 0.33 (d) · S 268,435,456/49,152 = 5,461 (s, above the ceiling already) · S 0.33 (d) |
| `path3:sparse:4096` | 12,288 | `dd` | `dd` | no | S 4,096/12,288 = 0.33 (d) ×2 |
| `path3:sparse:16384` | 49,152 | `dd` | `dd` | no | S 16,384/49,152 = 0.33 (d) ×2 |
| `path4:sparse:4096` | 12,288 | `dd` | `dd` | no | S 4,096/12,288 = 0.33 (d) ×2 |
| `path4:sparse:16384` | 49,152 | `dd` | `dd` | no | S 16,384/49,152 = 0.33 (d) ×2 |

The output digest, the derived count, the probe count and the candidate count are **equal between
the two binaries on every one of the seventeen cohorts**, the two that change kind included, which
is the exactness check the addressing kinds are supposed to satisfy and is asserted per cohort by the
probe script rather than inspected.

**Exactly two cohorts change, and both change for the same reason.** The fifteen that do not split
into three groups, and each group is a separate confirmation:

1. **Every growing index is unmoved**, because `DIRECT_INDEX_DENSITY` already ruled it and this
   change does not touch that branch. `cycle:blocks:4096`'s third index is the interesting one: a
   growing relation at key space 2^24 and capacity 2^24, density exactly 1.0, which is far inside
   the dynamic crossover of 48 and stays direct. Fermi prediction 2 got this right.
2. **Every static index keyed on one column is unmoved**, at densities 0.01 to 1.0, because a key
   space of `domain` against `domain` or `3 · domain` rows is two to four orders of magnitude inside
   a crossover of 64. This is the group that covers `closure`, `samegen`, `path3` and `path4`
   entirely, and it is why those families' instruction ratios are within the null **by construction
   rather than by measurement** — the plan they build is identical.
3. **Two static indexes were already above the ceiling** and were already sparse:
   `mutual:blocks:8192` at 2^26 and `triangle:sparse:16384` at 2^28.

**Fermi prediction 2 was wrong about one cohort, and it is the cohort C1192 measured the static
probe on.** The prediction said no C1192 or C1193 cohort could change. `mutual:blocks:4096` changes:
its single static index is `edge` on both columns at a key space of 2^24 against 61,440 rows, a
density of 273 — and 273 is precisely the density C1192's deviation 5 quotes when it says the
counting-sorted bucket is worth 1.39 times the instructions and 2.1 to 2.4 times the cycles of a
binary search. So the new rule takes away, on that cohort, exactly the win C1192 measured. That is
the trade the crossover decides and it has to be measured on the cohort itself rather than inferred
from the `triangle` sweep, because `mutual`'s evaluation is much longer and so amortizes more of the
build.
