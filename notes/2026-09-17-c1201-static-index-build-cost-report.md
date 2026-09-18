# C1201 — the static join index's build cost: a rule for its representation

**Lane**: `ergodis`
**Date**: 2026-09-17
**Status**: COMPLETE, audited, and repaired. Written incrementally from the start, so a crash would
have left a partial record rather than none; the Fermi predictions below were written and committed
**before any code change**. The audit
(`2026-09-17-c1201-static-index-build-cost-audit.md`) returned **VETTED WITH REPAIRS, no code
defect**, and its nine repairs are applied — see **Audit repairs applied**. Three tables were taken
on an unretained probe build and are now labelled as such, with the retained candidate's committed
receipt printed beside them; the build repair turned out better than the original table said.

**The headline.** A join index over a relation that never grows now has a measured density rule as
well as a ceiling, and the counting sort no longer shifts its result. On `triangle` at N = 4,096,
where the fully bound third atom keys on both columns for a key space of 2^24, preparation falls to
**0.094**, peak resident memory to **0.084** (71,528 KiB to 5,988 KiB, so 69.9 MiB to 5.8 MiB), and
the whole process — read, prepare, evaluate once, write — to **0.193**; against compiled Soufflé the
same cohort crosses from **1.90 to 0.896**, from behind to ahead, with the control arm reproducing
C1193's recorded 1.92. Thirteen cohorts whose chosen kind does not change read **0.99999 to
1.00003** in derivation-loop instructions against A/A nulls inside 2.3 parts per hundred thousand,
and on two whose kinds do not change the fault counts and resident sets came out identical. Where the
kind does change the derivation loop costs **1.41 and 1.45 times** the instructions, which is stated
as a loss because Fermi prediction 2 was wrong: the direct probe wins at every density, right up to
the ceiling. The closeout then found that a density is a **proxy** — two cohorts with the same key
space, the same rows and the same density have opposite right answers — and bracketed the threshold
on `key_space / probes` between 18.2 and 273, consistent with one constant near 23, which names the
successor.

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
| candidate, derivation loop | every figure below | `8c04b7a` | `676f513` | no | `closure_ballpark-8c04b7a` | `c2b2533e1f82a7964c50462dabba7f7c9d82081a30ff86188e2bd191dc039fbc` |
| candidate, frontend and stratified backend | the lane's next control | `8c04b7a` | `676f513` | no | `ergodis-tools-8c04b7a` | `a2be41efb8a24fdd8ae4661ce66bf47cf349438b042de2b7d3bc990105d7d702` |

The candidate's private revision `8c04b7a` is an **empty commit** whose message re-pins the core, in
the shape C1193's `cb11550` used: this change is entirely in the core, and a retained arm is named by
its own repository's revision, so the private revision has to move for the arm to have a name. The
private repository's own source is identical at `3c8499d` and `8c04b7a`, which is what makes the two
`closure_ballpark` arms differ in the core change and nothing else.

**A third, unretained build appears in this report and must be named.** Locating the crossover
bracket needed `DIRECT_STATIC_DENSITY` set below the densities being swept, so a scratch build of the
example was made from the core source of `676f513` with only that constant differing (set to 4). It
is **not** a retained arm, it carries **no receipt**, and **two of this report's tables are measured
on it**: the coarse and fine crossover sweeps under "The sweep". Both are labelled there, and the
same sweep on the retained candidate — every density the shipped constant lets it reach — is printed
from its committed receipt in the subsection that follows them. An earlier revision of this report
said no kept figure was measured on the probe build; that was wrong, and the audit
(`2026-09-17-c1201-static-index-build-cost-audit.md`, defects 1 and 2) found it. Every headline
figure, every A/B ratio, the per-stage tables and the Soufflé rows are on the two retained arms.

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
| `othello` | `0e6e252` | the report skeleton, the reproduced baseline and the Fermi predictions, written before any code |
| `ergodis` | `676f513` | `DIRECT_STATIC_DENSITY`, the staggered counting-sort cursor, the crossover's test, and `SHA256SUMS` |
| `ergodis-private` | `8c04b7a` | the empty re-pin that names the measured arm |
| `ergodis-private` | `879f3ed` | the two measurement stages and the receipts |
| `ergodis-private` | `684b0e5` | the closeout's sweep at an independent row count |
| `ergodis` | `5c9d1b3` | audit repair: the constant's docstring quotes the receipted figures (doc comment only, no re-measurement) |
| `ergodis-private` | `ab6be13` | audit repair: `compare.py` captures Soufflé's version rather than its banner's separator |
| `othello` | `869270f` … here | this report, written incrementally at each milestone, and the audit repairs |

## What the shipped policy does, reproduced

`Policy::Auto` sends a join index over a **static** relation to the direct counting-sorted CSR
whenever its key space fits `MAX_DIRECT_KEYS` = 2^24, with no reference at all to how many rows the
relation has. C1192 made that choice deliberately and recorded it as deviation 5: the
counting-sorted bucket beat a binary search over the distinct keys at every density its ceiling
allows. That measurement was of the **probe**. Nothing priced the **build**.

Reproduced on the retained control `closure_ballpark-3c8499d`, pinned to core 5, three then nine
repeats, `triangle` under the n-ary body policy. **This table has no receipt**: it predates the two
measurement stages this task committed and was taken by hand to reproduce the card's figures before
any code. It replays with

```sh
C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1201
for ix in auto sparse-indexes; do for n in 4096 16384; do
  taskset -c 5 choom -n 1000 -- $C/closure_ballpark-3c8499d --evaluator demand \
      --evaluate-only --bodies nary --index $ix --program triangle $n sparse 9 $W/smoke
done; done
```

and the numbers stand on two independent reproductions: the C1201 audit re-ran the `auto` rows on the
retained control and read 30.57 ms against 31.15, 71,508 KiB exactly and 1.265 ms against 1.289 at
4,096, and 12.63 against 12.92 ms, 15,212 against 15,256 KiB and 10.40 against 11.529 ms at 16,384;
the C1193 audit independently reproduced the `sparse-indexes` rows.

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
31.15/3.38 ms preparation split above, and this host's memory coefficients (about 20 GiB/s of
streaming store bandwidth and about 400 ns for one minor fault, both from C1198's cold-start stage —
and the 20 GiB/s turns out to be the cold figure, corrected under prediction 3's result).

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
**0.11** ratio. Peak RSS **5.9 MiB**, a **0.082** ratio. Evaluation **between the two rows and near
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
table of `2 · distinct_keys` slots at sixteen bytes a slot (a `u64` key, a `u32` start, a `u32`
length), so about `3 · rows` random writes into `32 · distinct_keys` bytes — at `triangle` 4,096,
where every one of the 12,288 rows has a distinct key, that is 384 KiB and about 0.1 ms, cheaper than
the sorted kind's
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

**Both tables in this subsection were taken on the scratch probe build**, which is the core source of
`676f513` with `DIRECT_STATIC_DENSITY` set to 4 so that `auto` makes the middle index sparse at every
density, including the ones below the shipped constant where the crossover's lower end lies. Neither
carries a receipt. They are kept because the bracket's lower end cannot be measured any other way,
and because they are what the constant was chosen from. The **next** subsection prints the same sweep
on the retained candidate at the shipped constant, from a committed receipt, for every density the
shipped constant lets it reach; where the two overlap the receipt is the figure to quote and the
differences are a different binary rather than session drift — the probe build's peak RSS sits a
constant 328 KiB high on **both** arms at every domain.

Coarse pass, three rounds of nine repeats, load average 5.9 to 7.8 noted by hand (wall ratios widen
with load, which is one reason the crossover is bracketed rather than quoted to a digit):

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

Fine pass across the crossover, five rounds of fifteen repeats, load average 5.6 to 5.9 noted by
hand, same probe build:

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
key space without bound up to `MAX_DIRECT_KEYS`, where it is 27 ms and 64 MiB whatever the relation
holds, while below the crossover the sparse choice gives up a bounded fraction of one evaluation.

**The bracket's two ends have different provenance and the report should not blur them.** The lower
end, a density of 64 at a one-evaluation ratio of 0.968, is a probe-build figure and cannot be
measured on the shipped binary at all, because at the shipped constant both arms choose the same
kinds there. The upper end, a density of 74.7, is measured on the retained candidate and its
committed receipt reads **1.0382** with a break-even of **1.3 evaluations** — the next subsection.

### The same sweep on the retained candidate, at the shipped constant

Five rounds of fifteen repeats on `closure_ballpark-8c04b7a`, receipt
`sweep-2026-09-17-c1201-shipped-constant.json`, load average 1.35 noted by hand. This is the table to
quote wherever it overlaps the probe build's, and it covers every density the shipped constant lets
the sweep reach — 74.7 upward, since at or below 64 both arms choose the same kinds.

| domain | facts | density | preparation, direct | preparation, big sparse | RSS, direct | RSS, big sparse | evaluation, direct | evaluation, big sparse | eval ratio | preparation + one evaluation | break-even evaluations |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 224 | 672 | **74.7** | 0.2549 ms | 0.2019 ms | 3,320 KiB | 3,156 KiB | 0.0356 ms | 0.0779 ms | 0.4570 | **1.0382** | **1.3** |
| 256 | 768 | 85.3 | 0.3088 | 0.2160 | 3,392 | 3,176 | 0.0407 | 0.0889 | 0.4578 | 1.1463 | 1.9 |
| 320 | 960 | 106.7 | 0.3894 | 0.2746 | 3,568 | 3,252 | 0.0516 | 0.1118 | 0.4615 | 1.1413 | 1.9 |
| 384 | 1,152 | 128.0 | 0.5023 | 0.3053 | 3,800 | 3,288 | 0.0608 | 0.1396 | 0.4355 | 1.2657 | 2.5 |
| 512 | 1,536 | 170.7 | 0.7333 | 0.3872 | 4,316 | 3,364 | 0.0821 | 0.1870 | 0.4390 | 1.4201 | 3.3 |
| 1,024 | 3,072 | 341.3 | 2.5221 | 0.7479 | 7,904 | 3,804 | 0.1718 | 0.4008 | **0.4286** | 2.3452 | 7.7 |
| 2,048 | 6,144 | 682.7 | 8.9636 | 1.5002 | 20,956 | 4,568 | 0.4941 | 0.8927 | 0.5535 | 3.9524 | 18.7 |
| 4,096 | 12,288 | 1,365.3 | 27.2986 | 2.7622 | 71,528 | 5,988 | 1.2565 | 1.8716 | **0.6714** | **6.1624** | 39.9 |

The one-evaluation ratio rises from **1.0382 at a density of 74.7 to 6.1624 at 1,365**, and the
direct kind's probe advantage over this range is **0.4286 to 0.6714**, so it is ahead by 1.49 to 2.33
times at every density the receipt covers. That is the refutation of Fermi prediction 2 on receipted
figures rather than on the probe build's, and it is the range to cite.

### The Fermi prediction this refutes, and it is the important one

**Prediction 2 said the direct probe into a 64 MiB offsets array would be no better than a binary
search over an L2-resident key array, and plausibly worse. It is wrong, and not marginally: the
direct probe is ahead at every density measured, by a factor of 1.49 to 2.33.** On the retained
candidate's receipt the eval ratio is 0.4286 to 0.6714 from a density of 74.7 to 1,365, and the probe
build extends the same picture down to 10.7, so C1192's deviation 5 was right about the probe even at
the ceiling — the counting-sorted bucket beats the binary search over the whole range, and the 64 MiB
array's cache behaviour never turns the comparison over.

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
`closure_ballpark-3c8499d` against the retained candidate `closure_ballpark-8c04b7a`, event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` at **100.00 per cent enabled**,
receipt `stages-2026-09-17-c1201-shift-direct.json`, load average about 1.4 noted by hand:

| domain | keys | preparation, control | preparation, candidate | ratio | minor faults, both | fault ratio | instruction ratio | peak RSS, both |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 512 | 262,144 | 0.7759 ms | 0.7518 ms | 0.9689 | 595 | 1.000 | 0.9995 | 4,316 KiB |
| 1,024 | 1,048,576 | 2.4265 | 2.2799 | 0.9396 | 1,510 | 1.000 | 0.9970 | 7,904 |
| 2,048 | 4,194,304 | 8.2279 | 7.8500 | 0.9541 | 4,784 | 1.000 | 0.9925 | 20,956 |
| 4,096 | 16,777,216 | 23.0332 | 20.9500 | **0.9096** | 17,459 | 1.000 | 0.9852 | 71,528 |

Removing the `keys`-entry `memmove` takes **9.0 per cent off the direct build at the ceiling** and
about 5 to 6 per cent from a quarter of the way down. The fault count is identical to the unit, which
is the check that the change is a pass removal and not a change of footprint; the peak resident set
is identical on both arms at every domain, which is the same check on the four extra bytes; and the
user-mode instruction ratio moves the same way (0.9852), which is the check that the removed pass was
real executed work and not only memory traffic.

**Fermi prediction 3 was right about the mechanism and wrong about the size, by a factor of three**:
it predicted 6.4 ms at 2^24 keys from 128 MiB of traffic at 20 GiB/s and measured **2.083 ms**, which
is about **61 GiB/s**. The 20 GiB/s figure came from C1198's *cold-start* stage, where every store
also takes a minor fault; a warm `memmove` over an already-resident 64 MiB array on this host runs at
about three times that. The cost model is corrected here rather than the measurement being explained
away: warm streaming traffic on this host is about 61 GiB/s and cold first-touch traffic about
20 GiB/s.

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

## The shapes considered, and the two that are not built

The sweep's refutation of Fermi prediction 2 reshapes this list, so it is worth being exact about
what each shape can and cannot deliver. The **direct** kind wins the probe at every density measured
and loses the build above about 69; the **sparse** kind is the mirror. A policy that chooses between
them is therefore choosing which one to give up, and the card's acceptance line asks for both. Two
further shapes can have both, and neither is built here.

### Not built: a plan-owned open-addressed hash over the distinct keys

The shape the measurement points at. A power-of-two table over the distinct keys, each slot holding
the key and its bucket's start and length in the plan's existing row array, so the bucket is
contiguous and ascending exactly as the two existing static kinds' buckets are. Occupancy needs no
sentinel key: every bucket the build inserts is non-empty by construction, so a length of zero *is*
the empty slot, which matters because a key space can saturate at `u64::MAX` and no key value is
reserved.

**Priced.** The build is `rows` insertions into about `2 · distinct_keys` slots — roughly
`3 · rows` random writes into `16 · distinct_keys` bytes, which is 288 KiB and about 0.1 ms at
`triangle` 4,096 against 2.9 ms for the sorted kind's `rows log rows` sort and 28 ms for the direct
kind's key-space passes. The probe is one multiply-shift, one L2-resident load and one key
comparison, about 25 cycles against the sorted kind's roughly 80 for a 13.6-iteration dependent
binary search. So it is predicted to be the cheapest build **and** the cheapest probe of the three,
and it is the only shape measured or priced here that satisfies the card's acceptance line as
written.

**Why it is not built.** It is a **fifth addressing kind**, and although its inner loop is the
static loop `next_row` already runs — so it is not a new kernel in the sense of a new derivation
loop — it needs its own arm in `Index::bucket`, two more `run::<KIND, BITMAP>` monomorphizations,
its own `is_static` and `next_row` membership, a `Policy` with three static outcomes rather than
two, a third value in the private driver's `addressing` report, and its own corpus pass in
`demand_sparse`. Two of those are the exact shapes C1193 measured as codegen hazards: adding
instantiations of a generic kernel moved an untouched loop by 2.6 to 3.9 per cent there, and a
driver-only change moved the scanner by 1.7 per cent under ThinLTO. **A fifth index kind is an
architecture choice, and the card hedges it explicitly** ("only if that is genuinely 'no new kernel';
otherwise mention it as not built and priced"), so it is priced and queued rather than taken inside
this task.

### Not built: demoting the index's mask and verifying the rest per row

The cheaper of the two, and it was not on the card's list. The `triangle`'s third atom is fully
bound, so the plan asks for an index keyed on **both** of `edge`'s columns — a key space of
`domain²`. Nothing forces that. An index keyed on column 0 alone has a key space of `domain`, **16
KiB** of offsets at N = 4,096 beside the 48 KiB row array it already needs, a build in microseconds,
and a probe that is one load; its buckets then
average three rows where one matches, and the other two are rejected by comparing the remaining key
column against the row — which is **exactly what `join::<VERIFY = true, _>` already does** for the
hashed kind, whose buckets may also hold rows of other keys.

**Priced.** Two extra row reads and two extra comparisons per probe, 36,864 probes at `triangle`
4,096, so about 74,000 extra row reads against 27 ms of preparation and 64 MiB saved — and unlike the
hash it needs no new storage and no new kind at all.

**Why it is not built.** The key fold in `Index::bucket` and in `run` walks every `OP_CONST` and
`OP_KEY` op, so a demoted mask needs a way to say "this column is bound but is not part of the key":
either a new op kind that the fold skips and `VERIFY` compares, or a mask-aware fold. Either is a
change to the innermost key computation of both kernels and it needs `join::<true, _>` instantiated
for the CSR arm, so it moves the instruction count of every cohort. It also interacts with the join
order, which the card puts out of scope. **Queued, and it is the first thing to try**, because it is
strictly less machinery than a fifth kind and gets the same two wins.

### Not built, and impossible in this encoding: the page-skipping prefix sum

Settled under Fermi prediction 4 above, and the argument stands after measurement: an untouched page
of a lazily reserved offsets array reads as zeros, and zeros break the monotonicity that
`offsets[key] .. offsets[key + 1]` depends on, giving either a slice panic or a spurious bucket of
every row before the gap, at each boundary between a written and an unwritten page. Dilating the
written set moves the boundary without removing it. The encoding that *can* absorb an untouched
page is a `(start, length)` or packed `(start, end)` pair per key, and that is a change to the probe
arm's arithmetic. Not an omission — a property of the encoding.

### Not built: a lazy `Pages` reservation for the offsets array, without skipping

This one survives the argument above, because the scan still writes every page and the array stays
monotone; all it removes is `calloc`'s explicit `memset`. **Priced at about 3 ms at 2^24 keys** from
the measured 61 GiB/s warm store bandwidth, and at **nothing at all in the shipped configuration**,
because after the density rule no index anywhere near 2^24 keys is direct and a small array's
`calloc` is served warm from the arena. Recorded as priced and not worth its `unsafe` surface at the
key spaces the rule now admits.

## Results

Every figure below is the retained control `closure_ballpark-3c8499d` against the retained candidate
`closure_ballpark-8c04b7a`, both from trees whose `git status --short` was empty and both recorded
`clean` in `MANIFEST.tsv`. The event set is
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` at **100.00 per cent enabled**
in every run. Pinned to core 5, under `choom -n 1000`, rounds alternating the arm order.

**Where the load averages come from.** The two `ab.py` receipts **record** theirs: 2.86 to 4.57 on
the unchanged-kind run and 2.53 to 2.57 on the changed-kind run, so **2.5 to 4.6** across the A/B.
The per-stage and sweep receipts record **no** load average, no CPU and no per-arm binary hash,
because `static_index_stages.py` and `static_index_sweep.py` do not emit them; the figures quoted for
those runs — about 1.4 to 1.6 for the per-stage tables, 1.35 for the sweep at the shipped constant,
1.45 to 1.56 for the blocks sweep — were **noted by hand from `uptime` beside each run** and are not
in the bundle. The pinning and the memory-pressure preference are code-backed in both scripts, which
build every command as `perf stat … taskset -c <cpu> choom -n 1000 -- <binary>`; they are simply not
in the output. Adding the three fields is queued as a candidate rather than done here, because
changing the scripts now would leave the committed receipts describing a different program.

### The derivation loop on the thirteen cohorts whose kind does not change

Five rounds, three then six repeats, two-point differenced, with an A/A null per cohort.

| Cohort | instructions, candidate ÷ control | interval | A/A null | cycles | derived |
| --- | ---: | --- | ---: | ---: | --- |
| `closure:sparse:256` | 1.00000 | [0.99999, 1.00001] | 1.0000026 | 1.00729 | 62,979 = 62,979 |
| `closure:sparse:1024` | 1.00000 | [1.00000, 1.00000] | 0.9999990 | 0.99945 | 979,983 = 979,983 |
| `closure:dense:256` | 1.00000 | [0.99999, 1.00001] | 1.0000007 | 0.99800 | 65,536 = 65,536 |
| `closure:dense:512` | 1.00000 | [1.00000, 1.00000] | 1.0000003 | 0.99082 | 262,144 = 262,144 |
| `samegen:sparse:1024` | 1.00000 | [0.99999, 1.00000] | 1.0000007 | 1.01403 | 258,691 = 258,691 |
| `samegen:dense:512` | 1.00000 | [1.00000, 1.00000] | 1.0000008 | 1.00066 | 507,425 = 507,425 |
| `closure:blocks:4096` | 1.00001 | [0.99995, 1.00006] | 1.0000029 | 0.99021 | 65,536 = 65,536 |
| `closure:blocks:16384` | 0.99999 | [0.99997, 1.00001] | 0.9999936 | 1.01739 | 262,144 = 262,144 |
| `cycle:blocks:4096` | 1.00001 | [0.99998, 1.00005] | 1.0000086 | 0.97880 | 131,072 = 131,072 |
| `triangle:sparse:16384` | 1.00003 | [0.99994, 1.00011] | 1.0000068 | 1.00419 | 15 = 15 |
| `path3:sparse:4096` | 1.00001 | [0.99999, 1.00003] | 0.9999777 | 0.99944 | 110,213 = 110,213 |
| `path3:sparse:16384` | 1.00002 | [1.00000, 1.00003] | 1.0000029 | 0.98795 | 441,937 = 441,937 |
| `path4:sparse:4096` | 1.00000 | [0.99997, 1.00003] | 0.9999982 | 1.02269 | 327,629 = 327,629 |

**The acceptance criterion is met with room: every instruction ratio is 0.99999 to 1.00003 and every
A/A null is within 2.3 parts per hundred thousand of unity, so the ratios sit inside the nulls'
own scatter.** That is what it should be — the plan these cohorts build is byte-identical between the
arms, so the measurement is a check on the protocol as much as on the change, and the nulls being as
tight as the ratios is the evidence that it is one.

### The derivation loop on the two cohorts whose kind changes

| Cohort | instructions | interval | A/A null | cycles | derived |
| --- | ---: | --- | ---: | ---: | --- |
| `triangle:sparse:4096` | 1.41212 | [1.41200, 1.41224] | 1.0000977 | 1.48717 | 48 = 48 |
| `mutual:blocks:4096` | 1.44701 | [1.44630, 1.44771] | 1.0000267 | 2.04451 | 61,440 = 61,440 |

**This is the cost the rule pays, stated as a loss and not rounded away**: where the kind changes the
derivation loop costs 1.41 and 1.45 times the instructions, and 1.49 and 2.04 times the cycles.
`mutual:blocks:4096` at a density of 273 reads 1.447 in instructions and 2.045 in cycles against
C1192's independently measured 1.39 and 2.1 to 2.4 for the same two kinds at the same density — the
two agree, which is a cross-validation of both measurements and of the claim that the probe
difference is a property of the representation rather than of either task's harness.

### The stages the rule is about: preparation, resident memory, and one whole evaluation

Seven rounds, nine in-process evaluations for the loop figure, alternating arm order. Preparation and
resident memory are read from **wall time, the resident high-water mark and the minor-fault count**;
the whole-process arm reads the facts, prepares, evaluates **once** and writes the output CSV.

| Cohort | kinds | stage | control | candidate | ratio |
| --- | :---: | --- | ---: | ---: | ---: |
| `triangle:sparse:1024` | `ddd` → `dsd` | preparation | 2.4814 ms | 0.7556 ms | **0.305** |
| | | preparation, minor faults | 1,510 | 485 | 0.321 |
| | | peak RSS | 7,904 KiB | 3,804 KiB | 0.481 |
| | | derivation loop | 0.1777 ms | 0.4021 ms | 2.263 |
| | | whole process | 3.3402 ms | 1.7777 ms | **0.532** |
| `triangle:sparse:4096` | `ddd` → `dsd` | preparation | 30.9834 ms | 2.9138 ms | **0.094** |
| | | preparation, minor faults | 17,459 | 1,074 | 0.062 |
| | | peak RSS | 71,528 KiB | 5,988 KiB | **0.084** |
| | | derivation loop | 1.2990 ms | 2.0206 ms | 1.556 |
| | | whole process | 36.5502 ms | 7.0477 ms | **0.193** |
| | | whole process, peak RSS | 70,840 KiB | 5,640 KiB | 0.080 |
| `triangle:sparse:16384` | `dsd` → `dsd` | preparation | 9.3207 ms | 9.2650 ms | 0.994 |
| | | preparation, minor faults | 3,753 | 3,753 | **1.000** |
| | | peak RSS | 15,116 KiB | 15,116 KiB | **1.000** |
| | | derivation loop | 8.2418 ms | 8.2061 ms | 0.996 |
| | | whole process | 23.0207 ms | 22.9279 ms | 0.996 |
| `mutual:blocks:4096` | `d` → `s` | preparation | 33.8304 ms | 11.6743 ms | **0.345** |
| | | preparation, minor faults | 22,438 | 6,340 | 0.283 |
| | | peak RSS | 82,936 KiB | 18,544 KiB | **0.224** |
| | | derivation loop | 1.1611 ms | 2.3737 ms | 2.044 |
| | | whole process | 43.7490 ms | 22.3740 ms | **0.511** |
| | | whole process, peak RSS | 82,724 KiB | 19,100 KiB | 0.231 |
| `mutual:blocks:8192` | `s` → `s` | preparation | 25.1647 ms | 25.0102 ms | 0.994 |
| | | preparation, minor faults | 14,666 | 14,666 | **1.000** |
| | | peak RSS | 37,948 KiB | 37,948 KiB | **1.000** |
| | | derivation loop | 5.0092 ms | 5.0221 ms | 1.003 |
| | | whole process | 47.6243 ms | 47.1862 ms | 0.991 |

**The two cohorts whose kind is unchanged are nulls on every stage**: the wall figures agree within
0.9 per cent, and in this run the minor-fault count and the peak resident set came out identical —
3,753 against 3,753 faults and 15,116 against 15,116 KiB on `triangle:sparse:16384`, 14,666 and
37,948 on `mutual:blocks:8192`. **Exact equality there is a property of that run, not of the arms.**
The plan the two arms build on those cohorts is identical, so equality is the expectation; but a
fault count is page placement, and the audit's three-round replay of `triangle:sparse:16384` reads
**3,744 against 3,748** faults and 15,212 against 15,248 KiB. What the figures establish is that the
two arms commit the same pages to within a few, so the plan they build has the same footprint — not
that the counters are bit-reproducible.

**On the two that change, the whole process is 5.2 and 2.0 times faster and holds a twelfth and a
quarter of the memory** (0.080 and 0.231 of the whole-process peak), and the derivation loop is 1.6
and 2.0 times slower. That is the trade, and the whole-process column is the one the rule optimizes
because it is the one-evaluation regime.

### The Soufflé row

`compare.py` against Soufflé 2.5 — the version is the session's `nix shell nixpkgs#souffle`, which
resolves to `souffle-2.5` in the store, and **not** the receipt's `souffle_version` field, which
captured a separator line; see the replay section — compiled and interpreted, both `-j1`, whole process to whole
process with equal read, prepare, evaluate and write boundaries, five rounds pinned to core 5, run
on both arms in the same session minutes apart. The derived relation agrees on every case in every
system (`agree: true` throughout).

| Cohort | kind change | Ergodis, control | Ergodis, candidate | compiled Soufflé | ratio, control | ratio, candidate |
| --- | :---: | ---: | ---: | ---: | ---: | ---: |
| `triangle:sparse:1024` | `ddd` → `dsd` | 21.76 ms | 19.39 ms | 20.7 ms | 1.086 | **1.059** |
| `triangle:sparse:4096` | `ddd` → `dsd` | 57.35 ms | 27.04 ms | 29.2–29.5 ms | 1.903 | **0.896** |
| `triangle:sparse:16384` | none | 54.69 ms | 54.34 ms | 68.2–69.1 ms | 0.828 | 0.768 |

**The headline result. `triangle` at 4,096 crosses from 1.90 times compiled Soufflé to 0.896 — from
behind to ahead — and the control arm reproduces C1193's recorded 1.92 to within a per cent**, which
is what makes the comparison a measurement of this change rather than of two sessions. The C1193
report called this "the one family where it should be ahead"; it now is.

The 16,384 row is a cohort whose kind does not change, and its two Ergodis figures agree to 0.6 per
cent (54.69 against 54.34 ms). Its *ratio* differs by 7 per cent because Soufflé's own time moved
between the two sessions (68.2 against 69.1 ms), which is a reminder that an external ratio carries
the external system's variance and the internal figure is the one to read.

## Disposition

**Kept**, at core `676f513` with private `879f3ed`, both parts:

- `DIRECT_STATIC_DENSITY = 64`, the measured one-evaluation crossover's conservative end, applied in
  `Policy::index_direct`'s `Auto` branch alone. `Direct`, `Sparse`, `SparseIndexes` and
  `SparseMembership` keep their meanings, and the two ceilings still bind under every policy.
- `Index::csr`'s staggered counting-sort cursor, which removes the `keys`-entry `memmove` with the
  probe expression unchanged, worth 0.910 of the direct build at the ceiling.

**Reverted: nothing.** No variant of either part measured as a wash or a loss, so there is no
forward revert to record. The two shapes that were *not built* are priced above with their reasons,
and one of them — the page-skipping prefix sum — is recorded as impossible in this encoding rather
than as untried.

**The one acceptance criterion this task does not meet, stated plainly.** The card asks for
`triangle` at 4,096 and 16,384 under `Policy::Auto` to have "preparation and peak RSS at or near the
sparse row, evaluation at or near the direct row". Preparation and peak RSS are at the sparse row:
0.094 and 0.084 at 4,096, and unmoved at 16,384 where they already were. **Evaluation is not at the
direct row and cannot be**: the measurement refuted the assumption the criterion rests on, because
the direct kind's probe is faster at every density measured, so a policy choosing between the two
existing static kinds buys preparation by spending evaluation. The derivation loop costs 1.56 times
the direct arm at 4,096, and the whole process — preparation and one evaluation together, which is
what the criterion is ultimately about — is 0.193. Meeting the criterion as written needs a third
static representation, and the two candidates for it are priced above, with mask demotion the
cheaper. This is reported as an unmet criterion with its measured cause rather than reinterpreted to
fit.

## The `ej` and `tt` closeout

Two things came out of it, both cheap, and the second is the most useful measurement in the report.

### Preparation is now admission-bound on every cohort, and it was not before

Free, from the kind census already run. Preparation divided by the input relation's fact count, on
the candidate, over all seventeen cohorts:

| Cohort | facts | preparation, control | preparation, candidate | candidate, ns per fact |
| --- | ---: | ---: | ---: | ---: |
| `closure:sparse:256` | 768 | 0.2426 ms | 0.2175 ms | 283 |
| `closure:sparse:1024` | 3,072 | 0.7160 | 0.7060 | 230 |
| `closure:dense:256` | 16,384 | 3.9349 | 3.4657 | 212 |
| `closure:dense:512` | 65,536 | 11.8773 | 11.8578 | 181 |
| `samegen:sparse:1024` | 1,023 | 0.4107 | 0.2266 | 222 |
| `samegen:dense:512` | 1,021 | 0.2159 | 0.2116 | 207 |
| `closure:blocks:4096` | 61,440 | 11.5505 | 14.1326 | 230 |
| `closure:blocks:16384` | 245,760 | 50.1862 | 50.0271 | 204 |
| `mutual:blocks:4096` | 61,440 | **33.7499** | **11.7496** | 191 |
| `mutual:blocks:8192` | 122,880 | 24.5214 | 25.1766 | 205 |
| `cycle:blocks:4096` | 61,440 | 11.7302 | 11.6651 | 190 |
| `triangle:sparse:4096` | 12,288 | **24.0434** | **2.1769** | 177 |
| `triangle:sparse:16384` | 49,152 | 9.3212 | 9.3924 | 191 |
| `path3:sparse:4096` | 12,288 | 2.0381 | 2.0204 | 164 |
| `path3:sparse:16384` | 49,152 | 9.1982 | 8.9255 | 182 |
| `path4:sparse:4096` | 12,288 | 2.0503 | 2.1081 | 172 |
| `path4:sparse:16384` | 49,152 | 8.9858 | 8.8618 | 180 |

**Every cohort now sits between 164 and 283 ns per input fact, across a range of 768 to 245,760
facts and five program families**, and the two that were outliers — `triangle:sparse:4096` at 1,956
ns per fact and `mutual:blocks:4096` at 549 — are now 177 and 191. So the static index's build is no
longer the leading term in preparation anywhere, and what remains is proportional to the facts:
admission, the row store, and the fact-to-relation projection. That is a **new leading term worth its
own task**, and it is worth about 50 ms on `closure:blocks:16384`, which is more than this task
removed from `triangle`. It is also the figure that says this task is finished: nothing about the
index's build is above the noise of the per-fact cost any more.

(The single reading that moves the wrong way, `closure:blocks:4096` at 11.55 to 14.13 ms, is a
cohort whose kinds do not change and whose fault count and resident set are identical between the
arms in the census; it is one round at one repeat, taken for the kind table and not for citing, and
the seven-round run of its sibling `mutual:blocks:8192` reads 0.994.)

### The crossover is not a density, and two cohorts with the same density settle it

This is the `tt` question — what is the rule's variable really? — and the measurement answers it.
The `triangle` at the `blocks` density has 15,360 to 61,440 rows where the same program at the
`sparse` density has 576 to 12,288, so it probes a key space of the same shape with a workload an
order of magnitude larger. Sweeping it, five rounds, load average 1.45 to 1.56:

| domain | facts | density of the swept index | preparation, direct | preparation, sparse | evaluation, direct | evaluation, sparse | preparation + one evaluation, direct ÷ sparse |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1,024 | 15,360 | 68.3 | 5.18 ms | 3.01 ms | 4.39 ms | 8.72 ms | **0.815** |
| 1,280 | 19,200 | 85.3 | 5.95 | 3.57 | 4.94 | 11.27 | **0.734** |
| 1,536 | 23,040 | 102.4 | 7.01 | 4.34 | 5.94 | 13.70 | **0.718** |
| 1,792 | 26,880 | 119.5 | 8.51 | 4.76 | 6.89 | 16.03 | **0.741** |
| 2,048 | 30,720 | 136.5 | 10.89 | 5.97 | 7.91 | 17.77 | **0.792** |
| 2,560 | 38,400 | 170.7 | 14.68 | 7.09 | 9.86 | 23.14 | **0.812** |
| 3,072 | 46,080 | 204.8 | 19.07 | 8.54 | 12.08 | 28.77 | **0.835** |
| 4,096 | 61,440 | 273.1 | 30.88 | 12.11 | 16.08 | 38.29 | **0.932** |

**The direct kind is ahead end to end at every density from 68 right up to the key-space ceiling at
273, where the sparse-density family crossed at 69.** So `DIRECT_STATIC_DENSITY = 64` is the correct
constant for one family and the wrong one for the other, and the quantity it reads is a proxy rather
than the cause.

**The datum that settles what the cause is.** `mutual:blocks:4096` and `triangle:blocks:4096` have
**the same key space** (2^24), **the same row count** (61,440), **the same density** (273) and the
same input relation, and the right answer is **opposite** on them. The comparable quantity is
**preparation plus one evaluation, direct over sparse**: **0.932** for the direct kind on the
triangle, from the blocks sweep above, and **2.49** against it on `mutual`, from the seven-round
`stages-2026-09-17-c1201-auto.json` receipt — (33.8304 + 1.1611) ÷ (11.6743 + 2.3737). The
single-round kind census reads **2.37** for the same quantity independently, and the whole-process
ratio is 1.955 the other way round. Nothing a density rule can see distinguishes the two cohorts.
What distinguishes them is the **probe count**: `mutual(x,y) :- edge(x,y), edge(y,x)` probes the
fully bound index once per edge, 61,440 times, and `tri(x,y) :- edge(x,y), edge(y,z), edge(z,x)`
probes it once per two-path, 15 times more often at this density. Fifteen times more probes over the
same build, and the sign flips.

**The cost model, and exactly what was fitted.** Direct pays when `key_space <= K · probes`, with `K`
the ratio of one probe's saving to one key's build cost. Fitting `K` at the sparse family's crossover
(domain about 208: key space 43,264 against about 1,872 probes) gives **`K` ≈ 23**, and the other two
cohorts are then **consistency checks that bracket the threshold rather than measurements of it** —
they only require it to lie somewhere between 18.2 and 273:

**A note on what "probes" means here, because the report uses the word for two different
quantities.** The receipted `probes` counter is the kernel's *top-level* count and equals the input
relation's fact count on every cohort in this report. The numbers in the table below are the *per-index*
probe counts of the fully bound link, which nothing counts today: they are **derived from the
generators' out-degree** — three at the `sparse` density and fifteen at `blocks`, so `rows × 3` and
`rows × 15` — and they are three and fifteen times the receipted counter. Making them measured rather
than derived is queued candidate 2.

| Cohort | key space | probes into the swept index | `key_space / probes` | model says | measured |
| --- | ---: | ---: | ---: | :---: | :---: |
| `triangle:sparse`, crossover | 43,264 | ~1,872 | 23.1 | at the crossover | crossover (calibration point) |
| `triangle:blocks:4096` | 16,777,216 | ~921,600 | 18.2 | direct, just | direct, 0.932 |
| `mutual:blocks:4096` | 16,777,216 | 61,440 | 273 | sparse, far | sparse, 2.49 |

A threshold on `key_space / probes` anywhere between 18.2 and 273 gets all three, including the pair
a density rule cannot tell apart, and the value fitted at the one crossover located, 23, sits inside
that window. **The model is not yet measured to a digit — the two checks bracket it and do not pin
it, which is open item 3 — but its variable is settled, and that names the successor exactly: rule on
an estimated probe count, not on rows.** The plan can estimate it — it has the join order, which link sits at
which level, and, once the earlier static indexes are built, each one's rows over its distinct keys,
which is the average fan-out that multiplies into the next level's probe count.

**Why the shipped constant stays at 64 anyway, and what it costs.** The probe-count rule is an
architecture change to the policy and needs its own task. Between the two constants a single
density can take, 64 is the one whose errors are bounded: it is right on `triangle:sparse` by
construction and right on `mutual:blocks`, and on `triangle:blocks` it costs 7 to 39 per cent of
**preparation plus one evaluation** while **saving 36 to 64 MiB of resident memory** (36,068 and
64,136 KiB) at the top of that range. The rule it replaces had no bounded error at all — it was 5.2
times slower end to end on `triangle:sparse:4096` and held 64 MiB of offsets for a relation of 12,288
rows. Choosing the conservative end
of a proxy over an unbuilt cost model is the decision, and this is the measurement that prices it.

## Mystery ledger

### Settled

1. **Where does the static index's 27.8 ms of extra preparation sit?** In memory traffic over the key
   space, not in work over the rows. Fermi prediction 1 decomposed it into five passes over a 64 MiB
   array and predicted 26 ms against 27.8 measured, closing to 7 per cent, and the stagger's
   receipted 2.083 ms confirms the one pass it removed.
2. **Does the direct kind's probe hold up at the ceiling, where its offsets array is far larger than
   cache?** Yes, and this refutes Fermi prediction 2. The direct probe is ahead by 1.49 to 2.33 times
   over the densities the retained candidate's receipt covers, 74.7 to 1,365, with the probe build
   extending the same picture down to 10.7. So C1192's deviation 5 was right about the probe over the
   whole range and the two static kinds are a strict trade rather than one dominating.
3. **What is the crossover for one evaluation, and is a density the right thing to measure?** The
   crossover on the `sparse`-density `triangle` is bracketed between a density of 64 and 74.7. **A
   density is not the right thing to measure**: the same program at the `blocks` density has the
   direct kind ahead from 68 to 273, and `mutual:blocks:4096` and `triangle:blocks:4096` have
   identical key space, rows and density with opposite answers. The cause is the probe count, and
   the threshold on `key_space / probes` is bracketed between 18.2 and 273 by the other two families,
   with 23 fitted at the one crossover located; the probe counts are derived from the generators'
   out-degree and are not the receipted top-level `probes` counter.
4. **Can a lazily reserved offsets array skip untouched pages in its prefix sum?** No, not with this
   probe. Zeros in an untouched page break the monotonicity that `offsets[key]..offsets[key+1]`
   depends on, giving a slice panic on one side of a page boundary and a spurious bucket of every
   prior row on the other; dilating the written set moves the boundary without removing it. The
   encoding that absorbs an untouched page is a `(start, length)` pair per key, which is a probe
   change. Settled by argument, before any code, and the argument is in prediction 4.
5. **Does the `keys`-entry shift have to exist?** No. Staggering the counting cursor one entry to the
   right leaves the array in the shape the probe reads with no further pass, for four extra bytes and
   with the probe expression textually unchanged: **0.9096** of the direct build at the ceiling, with
   the fault count identical to the unit, the peak resident set identical on both arms, and the
   instruction ratio at 0.9852. The audit also checked the equality by argument and against an
   independent transcription of both versions over 4,000 random cases and six edge cases, with zero
   mismatches.
6. **Do the two kinds still agree on everything observable?** Yes, and on more than the suite
   asserts: the output digest, the derived count, the probe count and the candidate count are equal
   between the arms on all seventeen cohorts, the two whose kind changes included, asserted per
   cohort by the harness rather than inspected. The core suite's `demand_sparse` runs the whole
   corpus a second time under `Policy::Sparse` and compares certificate **bytes**, and it passes.
7. **Was the C1193 audit's retain complaint fixable?** Yes. Both controls and both candidates here
   were retained from trees whose `git status --short` was empty, checked before each recipe ran, and
   all four rows read `clean` in `MANIFEST.tsv`.
8. **Was the 400 KiB resident-set gap in the first shift measurement the change?** No. It was the
   scratch probe binary. Re-run on the two retained executables, the resident set is identical to the
   byte at every domain.

### Open

1. **What is the per-fact 164-to-283 ns of preparation, and why does it vary by 1.7 times across
   cohorts?** After this change every cohort's preparation is proportional to the input fact count at
   that rate, and it is now the leading term — 50 ms on `closure:blocks:16384`. *Evidence so far*:
   seventeen cohorts spanning 768 to 245,760 facts, all inside that band, with no visible dependence
   on the program family or the index kinds; the candidates for the cost are `Admitted`'s fact list,
   the per-relation row store built by `extend_from_slice`, and the `fact_of` projection. *Evidence
   gap*: a kernel-scoped profile of `Demand::new_bounded` on a fact-heavy cohort with no index of any
   size, and a per-fact instruction count from two fact counts at one domain. *Owner*: a successor
   task; this is where preparation now is.
2. **Where exactly does the direct probe's advantage come from at 2^24 keys?** A random load into a
   64 MiB array should miss the last level and cost more than a 13.6-iteration binary search over
   96 KiB, and it does not — it is 1.5 to 2.3 times cheaper. *Evidence so far*: the ratio holds from
   a density of 10.7 to 1,365 and the instruction ratio (1.41 to 1.45 against the sparse arm) is
   smaller than the cycle ratio (1.49 to 2.04), so part of it is instructions and part is the
   dependent-load chain of the search. *Evidence gap*: the supplementary cache-event run
   (`cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses`) with its own null, on
   `triangle:sparse:4096` under both forced policies — one invocation, and C1193's open item 3 asked
   for the same run for a different reason. *Cheap.*
3. **Is `K` ≈ 23 stable, or is it itself workload-dependent?** It was fitted at one crossover and
   checked against two cohorts on the correct side of it, which is a consistency check and not a
   measurement of the constant. *Evidence gap*: a crossover located directly in a family whose probe
   count per row differs again from 3 and 15 — `path3` or `path4` with a fully bound final atom, or
   the `blocks` triangle above the ceiling, which `MAX_DIRECT_KEYS` currently puts out of reach.
   *Owner*: the probe-count policy task, which needs the constant anyway.
4. **Would the probe-count estimate the plan can compute agree with the true probe count?** The
   estimate would multiply each level's average fan-out, which is exact for the first level and an
   independence assumption after that. *Evidence gap*: the estimate computed beside the kernel's
   actual per-link probe counter, over the whole cohort set — and there is no per-link probe counter
   today, only the one top-level `probes`. That counter is the first piece of work the successor
   needs.
5. **`DIRECT_INDEX_DENSITY` = 48 for growing indexes was measured the same way and may have the same
   defect.** A dynamic index's build is also proportional to its key space and its saving to its
   probe count, so the same proxy-versus-cause argument applies to it. *Evidence so far*: nothing
   measured here; every growing index in the cohort set sits at a density below 1.0, four orders
   inside the constant, so no cohort exercises it. *Evidence gap*: C1192's sweep re-run at two
   workloads with the same density and different probe counts per row, which is the shape that
   settled the static case. *Owner*: the same successor, because one cost model would replace both
   constants.

No genuine mystery is being manufactured: items 1, 2 and 4 are concrete measurements nobody has
taken, item 3 is a constant fitted at one point, and item 5 is an argument by analogy that is
explicitly unmeasured.

## Candidates to queue, no identifiers allocated

1. **Rule the index choice on an estimated probe count instead of a density.** The largest measured
   effect available: it is the only rule shape that gets `mutual:blocks:4096` and
   `triangle:blocks:4096` both right, and it would replace `DIRECT_STATIC_DENSITY` and probably
   `DIRECT_INDEX_DENSITY` with one constant on `key_space / probes`. Needs a per-link probe counter
   first (candidate 2).
2. **A per-link probe counter in `Evaluation`.** One increment per bucket lookup, which the loop
   already branches on. It is the instrument candidate 1 needs, it would make this report's probe
   figures measured rather than derived from the graph's degree, and it is the missing half of
   C1193's queued `matches` counter.
3. **Demote a fully bound atom's index mask and verify the remaining key columns per row.** Priced
   above under the shapes not built: it is the cheapest shape that gets both the cheap build and the
   O(1) probe, needs no new storage and no new kind, and would let the `triangle`'s third atom index
   one column for 16 KiB of offsets instead of two for 64 MiB. It needs an op kind the key fold skips and
   `join::<true, _>` instantiated for the CSR arm, so it is a kernel change with its own A/B.
4. **A plan-owned open-addressed hash over the distinct keys**, the card's candidate (c), priced
   above. A fifth addressing kind; strictly more machinery than candidate 3 for the same two wins.
5. **Preparation's per-fact cost**, which this task made the leading term everywhere. Open item 1.
6. **The supplementary cache-event run on `triangle:sparse:4096` under both forced policies**, which
   closes open item 2 here and C1193's open item 3 in one invocation.
7. **`triangle` and `mutual` at the `blocks` density have no cohort in `ab.py`'s list**, and they are
   the two that discriminate the rule shapes. Worth adding to the standing cohort set.
8. **A `Pages` reservation for the plan's offsets array**, priced at about 3 ms at 2^24 keys and at
   nothing in the shipped configuration. Recorded so it is not rediscovered as an omission.
9. **Record the load average, the CPU and each arm's binary hash in `static_index_stages.py` and
   `static_index_sweep.py`.** `ab.py` and `compare.py` already emit all three, and their absence is
   why this report's per-stage and sweep load averages are noted by hand rather than receipted, which
   the audit raised as defect 4. Not done inside this task because changing the scripts would leave
   the committed receipts describing a different program.
10. **A unit test on a CSR index's bucket contents.** The staggered cursor's equality with the pass it
    replaced is bound only indirectly today, by `demand_sparse` running the whole corpus a second
    time under `Policy::Sparse` and comparing certificate bytes — which does catch a wrong CSR. The
    audit verified the equality by argument and by 4,000 random cases against an independent
    transcription, and suggests one screen of direct assertion on the offsets and rows arrays.

## Replay commands

Run from `~/src/ergodis-private` unless noted. Every gate and every measurement went through
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so the gates and the measurements describe one build. Working files under `~/.cache/ergodis/c1201/`.

```sh
# Gates, core, at 676f513. Outcome: exit 0, 82 `test result: ok` blocks, zero
# FAILED; clippy and fmt clean; the allocation regressions green.
cd ~/src/ergodis
nix develop . --command cargo test --all-features --no-fail-fast -j 8
nix develop . --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
nix develop . --command cargo fmt --all -- --check
nix develop . --command cargo test -p ergodis-rules --test allocation -j 8
nix develop . --command python3 python/generate_evidence.py --write   # SHA256SUMS
cd ~/src/ergodis-private

# Gates, private. This drives rel_lowering, rel_frontend, rel_frontend_portability
# and rel_reference_eval, which is the C1189 differential under both policies.
# Outcome: 42 test binaries, zero failures.
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test \
    -p ergodis-private -p ergodis-tools --no-fail-fast -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private -p ergodis-tools \
    --lib --bins --tests --examples -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check
nix shell nixpkgs#ruff -c ruff check analysis/datalog-comparison/static_index_*.py

# The crossover test in the core suite, which brackets DIRECT_STATIC_DENSITY from
# the constant itself and so survives a change to its value.
nix develop ~/src/ergodis --command cargo test -p ergodis-rules --test demand_sparse -j 8 \
    -- the_policy_chooses_from_the_key_space_and_the_rows

# The arms, each retained with the tree at its own revision and `git status
# --short` empty, checked before the recipe ran; the control pair before the
# first source change of the task. The recipe is idempotent: at the same
# revision it reports the existing retained copy and exits zero.
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example         # private 3c8499d, core 09a5c2b
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools            # private 3c8499d, core 09a5c2b
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example         # private 8c04b7a, core 676f513
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools            # private 8c04b7a, core 676f513

A=analysis/datalog-comparison; C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1201
UNCH=closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512,closure:blocks:4096,closure:blocks:16384,cycle:blocks:4096,triangle:sparse:16384,path3:sparse:4096,path3:sparse:16384,path4:sparse:4096
ALL=$UNCH,path4:sparse:16384,mutual:blocks:4096,mutual:blocks:8192,triangle:sparse:4096

# The derivation loop on the cohorts whose kind does not change. Outcome:
# 0.99999 to 1.00003 in instructions, nulls within 2.3e-5.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-3c8499d \
    --a-name control-3c8499d --b $C/closure_ballpark-8c04b7a --b-name candidate-8c04b7a \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $UNCH \
    --work $W/ab-work --out $A/ab-2026-09-17-c1201-unchanged-kinds.json

# The two cohorts whose kind changes. Outcome: 1.412 and 1.447 in instructions.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-3c8499d \
    --a-name control-3c8499d --b $C/closure_ballpark-8c04b7a --b-name candidate-8c04b7a \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts triangle:sparse:4096,mutual:blocks:4096 \
    --work $W/ab-changed --out $A/ab-2026-09-17-c1201-changed-kinds.json

# Preparation, peak RSS and one whole evaluation. Outcome: 0.094 preparation,
# 0.084 peak RSS and 0.193 whole process on triangle:sparse:4096; exact nulls on
# the two cohorts whose kinds are unchanged.
nix develop ~/src/ergodis --command python3 $A/static_index_stages.py \
    --a $C/closure_ballpark-3c8499d --a-name control-3c8499d \
    --b $C/closure_ballpark-8c04b7a --b-name candidate-8c04b7a \
    --work $W/stages-auto --index auto --rounds 7 --repeats 9 \
    --cohorts triangle:sparse:1024,triangle:sparse:4096,triangle:sparse:16384,mutual:blocks:4096,mutual:blocks:8192 \
    --out $A/stages-2026-09-17-c1201-auto.json

# The build repair alone, both arms forced to the same kinds. Outcome: 0.910 of
# the direct build at the ceiling, fault counts and resident sets identical.
nix develop ~/src/ergodis --command python3 $A/static_index_stages.py \
    --a $C/closure_ballpark-3c8499d --a-name control-3c8499d \
    --b $C/closure_ballpark-8c04b7a --b-name candidate-8c04b7a \
    --work $W/stages-direct --index direct --rounds 7 --repeats 9 \
    --cohorts triangle:sparse:512,triangle:sparse:1024,triangle:sparse:2048,triangle:sparse:4096 \
    --out $A/stages-2026-09-17-c1201-shift-direct.json

# The kind census over all seventeen cohorts, which asserts digest and work
# equality and is not a timing run. Outcome: exactly two cohorts change.
nix develop ~/src/ergodis --command python3 $A/static_index_stages.py \
    --a $C/closure_ballpark-3c8499d --a-name control-3c8499d \
    --b $C/closure_ballpark-8c04b7a --b-name candidate-8c04b7a \
    --work $W/census --index auto --rounds 1 --repeats 1 --cohorts $ALL \
    --out $A/stages-2026-09-17-c1201-kind-census.json

# The crossover sweep at the shipped constant. Outcome: one-evaluation ratio
# 1.038 at a density of 74.7 rising to 6.16 at 1,365.
nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py \
    --bin $C/closure_ballpark-8c04b7a --work $W/sweep-shipped --rounds 5 --repeats 15 \
    --domains 224,256,320,384,512,1024,2048,4096 \
    --out $A/sweep-2026-09-17-c1201-shipped-constant.json

# The same sweep at an independent row count, which refutes a pure density rule.
# Outcome: the direct kind ahead end to end at every density from 68 to 273.
nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py \
    --bin $C/closure_ballpark-8c04b7a --work $W/sweep-blocks --program triangle \
    --density blocks --rounds 5 --repeats 9 --domains 1024,1280,1536,1792,2048,2560 \
    --out $A/sweep-2026-09-17-c1201-blocks-rows.json
nix develop ~/src/ergodis --command python3 $A/static_index_sweep.py \
    --bin $C/closure_ballpark-8c04b7a --work $W/sweep-blocks --program triangle \
    --density blocks --rounds 5 --repeats 5 --domains 3072,4096 \
    --out $A/sweep-2026-09-17-c1201-blocks-ceiling.json

# Soufflé, compiled and interpreted, both -j1, whole process to whole process.
# Outcome: triangle at 4,096 crosses from 1.903 to 0.896. The work directory
# names are the ones on disk; `souffle-ctl` is the control arm.
S="nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake nixpkgs#time -c"
for arm in 3c8499d:ctl:control 8c04b7a:cand:candidate; do
  rev=${arm%%:*}; dir=$(echo $arm | cut -d: -f2); name=${arm##*:}
  $S python3 $A/compare.py --bin $C/closure_ballpark-$rev --work $W/souffle-$dir \
      --out $A/results-2026-09-17-c1201-$name.json --rounds 5 --cpu 5 \
      --sizes triangle:sparse:1024,4096,16384
done
```

**The crossover sweep's tables do not all replay from a retained binary.** The two tables under
"The sweep" are the scratch probe build throughout, not only their rows below a density of 64: that
build is the core source of `676f513` with `DIRECT_STATIC_DENSITY` set to 4, and nothing shipped
reproduces them. The rows below a density of 64 — the crossover bracket's lower half — *cannot* be
measured on the shipped binary at all, because there both arms of `static_index_sweep.py` choose the
same kinds and the script correctly reports no swept index. The rows at and above 74.7 have a
retained-binary equivalent, which is the `sweep-shipped-constant` command above and the table printed
beside them; the two differ, and the receipted one is the one to quote. An earlier revision of this
report claimed the probe build's own rows at and above 74.7 replay on `closure_ballpark-8c04b7a`; the
audit found that false and it is corrected here.

**The Soufflé version rests on the session, not on the receipt.** Both `results-…json` files record a
`souffle_version` of a separator line, because `souffle --version` prints a rule of dashes first and
`compare.py` took line one. The version behind these rows is Soufflé 2.5, from the
`nix shell nixpkgs#souffle` above resolving to `souffle-2.5` in the store. Repaired in `compare.py`
at private `ab6be13`, which reads the `Version:` field and falls back to the resolved store path;
receipts written before it carry the separator.

Inputs are deterministic: the C1182 xorshift edge generator seeded by the domain for the `sparse`
and `dense` densities, and the `blocks` density's complete digraph inside each consecutive block of
sixteen nodes, which uses no random stream at all.

## What this task left under `~/.cache/ergodis/`

**Four retained binaries, 34 MB.** `bin/closure_ballpark-3c8499d` and `bin/ergodis-tools-3c8499d`
are this task's controls; `bin/closure_ballpark-8c04b7a` and `bin/ergodis-tools-8c04b7a` are the
candidate arms every figure above is measured on and are **the controls the next A/B in this lane
should use**. All four are recorded `clean` in `bin/MANIFEST.tsv`, and the `ergodis-tools` pair is
retained for the lane's Rel route rather than used by this report, which touches no frontend path.

**`c1201/`, 16 MB.** Every `static_index_*` and `ab.py` work directory (`ab-work`, `ab-changed`,
`census`, `stages`, `stages-auto`, `stages-direct`, `sweep`, `sweep-shipped`, `sweep-blocks`), the
`probe` and `smoke` directories from reproducing the baseline, and the two Soufflé work trees at
2.1 MB each — the generated fact files, the compiled `.dl` binaries and every system's output CSV,
which is most of the 16 MB. Nothing was deleted at task close; everything here is regenerable from
the replay block.

**No `perf-c1201/`.** This task took no `perf record` profile: its two stages are a preparation cost
read from wall time and faults, and a derivation loop whose A/B `ab.py` already instruments with
`perf stat`. The kernel-scoped profile open item 2 asks for is a cache-event `perf stat` run, not a
`perf record`, and it is queued rather than taken.

`../ergodis-dev/scripts/cache-gc.sh` was run in its listing mode and **nothing was deleted; that is
the user's call.** It scanned 37 entries and reports **zero unreferenced and old enough to remove** —
every entry is either referenced by an evidence file or younger than two days, this task's `c1201`
among the latter. The largest entries it lists are `certdist` at 270 MB, `worktrees` at 105 MB,
`c985` at 104 MB, `split` at 31 MB, `c1192` at 20 MB, `c1193`, `c1198`, `representation-attribution`
and `c1201` at 16 MB each, and `corpora` at 13 MB. The eighteen entries C1193's close listed as
unreferenced are no longer so, which is what a referenced-entry scan should do once the reports that
name them are committed.

## Resume state for the next session

**The task is complete, the audit is in, its nine repairs are applied, and every tree is
committed.** Nothing is half-built and no path is untracked in any of the three repositories.

| Repository | HEAD at close | Range this task added |
| --- | --- | --- |
| `~/src/ergodis` | `5c9d1b3` | `09a5c2b` … `5c9d1b3` (two commits, the second doc-comment only) |
| `~/src/ergodis-private` | `ab6be13` | `3c8499d` … `ab6be13` (four commits) |
| `~/src/othello` | this report's last commit | `8863a56` … here |

**The measured arms are unchanged by the repair pass.** `closure_ballpark-8c04b7a` is still the
binary every figure is measured on, because `5c9d1b3` changes only a doc comment and `ab6be13` only
a receipt field. A successor that wants a control at the repaired revisions can retain one; nothing
here needs it.

**Retained controls for the next A/B in this lane**, both at `ergodis-private` `8c04b7a` with core
`ergodis` `676f513`, rustc 1.95.0 (59807616e 2026-04-14), release, no features, **both `clean` in
the manifest**:

- derivation loop: `~/.cache/ergodis/bin/closure_ballpark-8c04b7a`, measured sha256
  `c2b2533e1f82a7964c50462dabba7f7c9d82081a30ff86188e2bd191dc039fbc`;
- frontend and stratified backend: `~/.cache/ergodis/bin/ergodis-tools-8c04b7a`, measured sha256
  `a2be41efb8a24fdd8ae4661ce66bf47cf349438b042de2b7d3bc990105d7d702`.

They supersede `closure_ballpark-cb11550` and `ergodis-tools-cb11550`, which C1193 named and which
are flagged `dirty`, and `closure_ballpark-3c8499d` / `ergodis-tools-3c8499d`, which are this task's
controls and stay for its replay.

**Left undone, deliberately:** the lifecycle close for C1201 (archive the row, delete it from the
live queue, update the lane handoff), which belongs to whoever closes the task, and the ten queued
candidates, none of which has an identifier.

**Decisions left open for Tavis**, both stated with their evidence above and neither taken here:
whether `DIRECT_STATIC_DENSITY` should stay at 64 or move now that the closeout shows a density is a
proxy for the probe count (the recommendation is that it stays, and that the successor replaces the
rule's *shape* rather than its constant), and which of the three shapes not built — the probe-count
cost model, mask demotion, or a fifth hashed static kind — is worth allocating first (the
recommendation is mask demotion, as the cheapest that gets both wins, with the per-link probe counter
allocated alongside it because every one of the three needs it).

## Audit repairs applied

The audit `2026-09-17-c1201-static-index-build-cost-audit.md` returned **VETTED WITH REPAIRS, no code
defect**, with nine numbered repairs. All nine are applied.

| # | Repair | Applied |
| :---: | --- | --- |
| 1 | The build-repair table is the probe build and is superseded by `stages-…-shift-direct.json` | **Applied.** The table now prints the receipt's four rows (0.9689, 0.9396, 0.9541, 0.9096; faults 595/1,510/4,784/17,459; instruction ratios 0.9995/0.9970/0.9925/0.9852; peak resident sets identical on both arms), and the prose says **9.0 per cent** off the direct build at the ceiling rather than 7.2, and 5 to 6 per cent a quarter of the way down. The 0.910 already in the Disposition and in settled mystery item 5 was this receipt and is unchanged. The stale note about a 400 KiB resident-set gap is deleted, because it was the probe binary and the receipt shows equality. |
| 2 | Fermi-3 arithmetic and units | **Applied.** The measured delta is **2.083 ms** at 2^24 keys, so warm streaming traffic on this host is about **61 GiB/s** and cold first-touch about **20 GiB/s**, in GiB throughout including the prediction that used the cold figure. |
| 3 | Both sweep tables are the probe build; the closing replay claim is false | **Applied.** "The sweep" now opens by saying both its tables are the scratch probe build with no receipt and why the bracket's lower end needs it, a new subsection prints the retained candidate's own sweep from `sweep-…-shipped-constant.json` (one-evaluation ratio **1.0382** at a density of 74.7 rising to **6.1624** at 1,365, break-even **1.3** at 74.7, eval-ratio range **0.4286 to 0.6714**), the bracket is stated as 64 (probe build, 0.968) to 74.7 (retained candidate, 1.0382), the refutation of Fermi prediction 2 is requoted at 1.49 to 2.33 from the receipt, the Arms section's "no kept figure is measured on it" is replaced by a paragraph naming the probe build and the two tables on it, and the replay section's false claim is replaced by what actually replays. |
| 4 | `mutual`'s 1.957 is untraceable | **Applied.** Replaced by **2.49**, named as preparation plus one evaluation, direct over sparse, with its arithmetic from the seven-round `stages-…-auto.json` receipt, the census's independent **2.37** noted, and the whole-process 1.955 distinguished. The cost-model table's cell is 2.49. |
| 5 | Load averages | **Applied.** The A/B range is corrected to **2.5 to 4.6** (the receipts record 2.86–4.57 and 2.53–2.57), and the report now says the per-stage and sweep load averages were noted by hand from `uptime` because neither script emits one, while the pinning and `choom` preference are code-backed in both. Adding load average, CPU and per-arm binary hash to the two scripts is **queued candidate 9** rather than done, because changing them would leave the committed receipts describing a different program. |
| 6 | The census replay command and the Soufflé work-directory names | **Applied.** `$ALL` gains `path4:sparse:16384`, so it is the seventeen the receipt holds, and the Soufflé loop writes `souffle-ctl` and `souffle-cand`, the directories on disk. |
| 7 | The pre-change baseline table has no receipt and no replay command | **Applied.** It now carries its replay command, says outright that it has no receipt and predates the committed measurement stages, and cites both independent reproductions — this audit's on the `auto` rows and the C1193 audit's on the `sparse-indexes` rows. |
| 8 | "Identical to the byte" is a property of that run | **Applied.** The claim is restated as a property of that run with the audit's three-round replay quoted (**3,744 against 3,748** faults, 15,212 against 15,248 KiB on `triangle:sparse:16384`), and what the figures do establish — the same pages committed to within a few, so the same plan footprint — is separated from bit-reproducibility. The same softening is in the headline and the vibe check. |
| 9 | Ten prose and docstring items, and the `compare.py` capture | **Applied.** The thirteen-cohort range is **0.99999 to 1.00003** in all three places including the replay comment; mask demotion is **16 KiB of offsets** in both places, with the 48 KiB row array named separately; the not-built hash has one formula, `32 · distinct_keys` bytes, so **384 KiB** at `triangle` 4,096; the 7-to-39-per-cent figure is "of preparation plus one evaluation"; "an eighth to a quarter" is **a twelfth and a quarter**; "without bound" is "without bound up to `MAX_DIRECT_KEYS`", where the build is 27 ms and 64 MiB, in the report **and** in the shipped docstring; the docstring's 4.2 per cent is the receipted **3.8**; GiB and MiB throughout; the cost model's probe counts are labelled as derived from the generators' out-degree and distinguished from the receipted top-level `probes` counter, which they are three and fifteen times; "one constant gets all three" is softened to the bracket 18.2 to 273 that the two checks actually place, matching open item 3; and "Soufflé 2.5" is attributed to the session with the receipt's separator-line field named. The `compare.py` capture is repaired at private `ab6be13`. |

**Two repairs changed code, and neither needs re-measurement.** The core commit `5c9d1b3` is
doc-comment only — `DIRECT_STATIC_DENSITY`'s docstring, plus the regenerated `SHA256SUMS` — so the
compiled evaluator at `676f513` and at `5c9d1b3` is the same program, every figure in this report
still describes the retained arms, and no A/B was re-run; `cargo fmt --check` and
`clippy -p ergodis-rules -D warnings` were run and are clean. The private commit `ab6be13` changes
`compare.py`'s version capture, which is metadata written into the receipt and is read by nothing
that times anything; `ruff check` is clean. The two measurement stages and every receipt are
untouched, so every table above still describes the program that produced it.

**One thing the audit found that this pass did not act on**, recorded so it is not lost: the
staggered cursor's equality with the pass it replaced is bound only indirectly in the crate, by
`demand_sparse` running the corpus a second time under `Policy::Sparse` and comparing certificate
bytes. The audit verified it by argument and by 4,000 random cases plus six edge cases against an
independent transcription of both versions, with zero mismatches. A direct unit test on the bucket
contents is **queued candidate 10**.

## Vibe check

Good, and the headline is the one the C1193 closeout predicted would be the largest lever in the
lane. On `triangle` at 4,096 preparation drops to **0.094**, peak resident memory to **0.084**, the
whole process to **0.193**, and the comparison against compiled Soufflé crosses from **1.903 to
0.896** — from behind to ahead on the one family where this evaluator should be ahead, with the
control arm reproducing C1193's recorded 1.92 so the crossing is this change and not two sessions.
Thirteen cohorts are unmoved to within three parts per hundred thousand, two cohorts whose kinds do
not change came out with identical fault counts and resident sets, and the build also got a free
5 to 9 per cent from removing a pass nobody had questioned.

One thing is a real loss and is stated as one: where the kind changes, the derivation loop costs
**1.41 and 1.45 times** the instructions, because Fermi prediction 2 was wrong and the direct probe
wins at every density, right up to the ceiling. So the card's acceptance line — preparation at the
sparse row *and* evaluation at the direct row — **is not met and cannot be by any choice between the
two existing static kinds**, which is a finding rather than a shortfall; it needs a third
representation, and two are priced.

The most interesting result is not in the card at all. `mutual:blocks:4096` and
`triangle:blocks:4096` have the same key space, the same row count and the same density, and the
right answer is **opposite** on them — 0.932 for the direct kind on the triangle against 2.49 on
`mutual`, both preparation plus one evaluation — because one probes the index fifteen times more
often. So the density rule this task shipped is a proxy; the threshold on `key_space / probes` is
bracketed between 18.2 and 273 with 23 fitted at the one crossover located, and the plan has what it
needs to estimate the probes. That is the next lever and it subsumes both of the policy's density
constants.

One last thing, and it is the part of this task that needed the audit. Three of the report's tables
were taken on a scratch probe build and carry no receipt, while a committed receipt covering the same
ground on the retained candidate existed and disagreed with them; the report then claimed no kept
figure was on the probe build and that the sweep's upper rows replayed on the retained binary,
neither of which was true. Every conclusion survived and the build repair turned out **better** than
the table said, 9.0 per cent at the ceiling rather than 7.2. The record was the defect, not the
result, and the repairs are listed below.
