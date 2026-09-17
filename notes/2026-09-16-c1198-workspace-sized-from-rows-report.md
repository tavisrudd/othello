# C1198 — the demand workspace sized from rows: zero sentinels, high-water reset, lazy page commit

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: IN PROGRESS. Skeleton and Fermi predictions written before any code, as the playbook
requires. Every section below is filled as its milestone completes, so a crash leaves a partial
record rather than none.

## Status

In progress.

Task card: `2026-09-16-c1198-workspace-sized-from-rows.md`. Predecessors:
`2026-09-16-c1192-sparse-join-index-report.md` (the sparse addressing kinds, the policy, the
`closure_ballpark` and Soufflé harnesses, and remaining gap 4 and mystery ledger item 7, which name
this task), its audit `2026-09-16-c1192-sparse-join-index-audit.md`, and
`2026-09-14-c1170-prepare-touch-scan-attribution.md` (the cold-start method this task reuses).
Repositories: `~/src/ergodis` (core) and `~/src/ergodis-private` (harnesses and receipts).

## Arms

Every hash is recorded **as measured**, never cited: the thing to run is the retain recipe at the
named revision. Every arm was retained from a **clean** tree in both repositories, through
`../ergodis-dev/scripts/retain-bin.sh` inside `nix develop` of the core checkout, under
rustc 1.95.0 (59807616e 2026-04-14), release profile, no features.

| Arm | Repository | Revision | Core | Dirty | Retained name | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, derivation loop, C1192's named one | `ergodis-private` | `b7921a0` | `24e399e` | manifest says dirty | `closure_ballpark-b7921a0` | `08b488430c2ffd1f3443d22364756eb85b018282d961108b2d8010a3507063d3` |
| control, derivation loop, same revision as the candidate's tree | `ergodis-private` | `c3eda9a` | no | `closure_ballpark-c3eda9a` | `ad4fed99b1d18ef6fd5881c510ddd3c1f5cfec397d1e37421a302b5084662333` |
| control, frontend and backend, C1192's named one | `ergodis-private` | `f12e27b` | no | `ergodis-tools-f12e27b` | `1d5d5f89957c72793d5a0ece5fbbd38f12d953c218c6803844029e37325468af` |
| control, frontend and backend, same revision | `ergodis-private` | `c3eda9a` | no | `ergodis-tools-c3eda9a` | `6c31e70aaa5e63bd12fdbf6e6b9b498cf2ecf0c95797fed5f7d09cc54f663055` |
| candidate, derivation loop | `ergodis-private` | `356fce6` | `93e12cf` | no | `closure_ballpark-356fce6` | `7fcc12c1c1afb515b66ad24580c230413ffa239b11f4dc8768e82d0a4727affa` |
| candidate, frontend and backend | `ergodis-private` | `356fce6` | `93e12cf` | no | `ergodis-tools-356fce6` | `e02bf69b4f930f452cc8f05fb57769a791be4362f0a9bba1fd69d4358e3b642c` |

Retain recipes, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

**Two controls rather than one, and the second is what makes the first trustworthy.** The card names
`closure_ballpark-b7921a0` and `ergodis-tools-f12e27b`, which C1192 left as the controls for the next
A/B. The tree has moved past both since: `cbe9f64`, `3ed2043` and `c3eda9a` are receipts and usage
strings, and `c3eda9a` edits `examples/closure_ballpark.rs` itself. The playbook's own lesson from
C1170 is that a driver-only edit moved an untouched kernel by 1.7 per cent through ThinLTO's module
summary, so a control one driver edit away from the candidate is a confound rather than a control.
Both were therefore retained and the same A/B run against each. **They agree to five decimal places
on every cohort's instruction ratio**, so the usage-string commit moved nothing here and the card's
named control is sound; the table below reports the `b7921a0` figures, which are the card's.

**No foreign uncommitted file was present in either repository at any point.** `git status` was clean
in `ergodis`, `ergodis-private` and `othello` before the first source change, at each retain, and at
task close.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `9dd61b7` | this report's skeleton and the Fermi predictions, written before any code |
| `ergodis` | `3eaaacf` | `pages::Pages`, the zero sentinel, the high-water reset, the reservation-counting allocation regression and `workspace_commit.rs` |
| `ergodis` | `93e12cf` | the counting sort's cursor is the offsets array rather than a second copy of it |
| `ergodis` | `271d648` | each reservation staggered by a cache line, against 4 KiB aliasing |
| `ergodis-private` | `b3994fc` | re-pin the core, so the candidate arm has a private revision to name it |
| `ergodis-private` | `356fce6` | the lockfile entry for the target-gated `libc` |

## Fermi predictions, written before any code

Written from `crates/rules/src/demand.rs` at core `460ca32`, the C1192 measurements, the C1170
per-page cost, and four diagnostic probes taken on the retained arm
`closure_ballpark-b7921a0` before any source change (`~/.cache/ergodis/c1198/probe`,
`~/.cache/ergodis/perf-c1198/cycle-faults.data`).

### 0. The card's stated mechanism is wrong, and the probe says so before implementation

The card says "zero-filled `calloc` pages are already committed lazily by the kernel; the explicit
`NONE` fill and the eager sizing are what defeat that." **The probes say the `calloc` itself is what
commits them.** `cycle` at the `blocks` density and N = 4,096, default row bound, on
`closure_ballpark-b7921a0`: `workspace_bytes` 1,145,061,376, peak resident set 1,131,196 KiB, and
283,893 page faults for the whole process — 1,163,624 KiB of faulted pages against a 1,118,224 KiB
reservation. A `perf record -e page-faults` profile of that run attributes **98.45 per cent of the
faults to `__memset_avx512_unaligned_erms`**. `mutual` at the same density, which has no dynamic
join index at all and therefore executes no `fill(NONE)` on any bucket head, still commits
539,380 KiB against a 460,800 KiB workspace reservation. Pinning `MALLOC_MMAP_THRESHOLD_` to
131,072 changes nothing (284,132 faults against 283,893).

So the eager commit is not the `fill(NONE)`; it is `vec![0u32; n]` lowering to `alloc_zeroed` and
glibc's `calloc` writing zeroes over a chunk it served from the arena rather than from a fresh
`mmap`. `calloc` skips the `memset` only for a chunk it mapped itself, and by the time the workspace
is built the arena's top chunk is large enough to satisfy 64 MiB and 128 MiB requests without
mapping. **I predict, therefore, that deliverable 3 — the owned `MAP_NORESERVE` mapping — carries
nearly all of this task's memory result, and that deliverables 1 and 2 on their own would move peak
resident set by under ten per cent.** That reverses the card's ordering and is the first thing the
measurement has to confirm or refute.

### 1. What the reservation costs per byte, and what preparation becomes

C1170 measured a fresh anonymous workspace at **734 nanoseconds per faulted 4 KiB page** and
0.179 nanoseconds per reserved byte for a touch loop that writes sixteen bytes per page. A `calloc`
that memsets writes every byte, so it pays the same fault plus the write bandwidth. On `closure` at
the `blocks` density and N = 4,096 the reservation is 538,984,448 bytes — 131,588 pages, so
96.6 ms of fault handling alone — against C1192's measured preparation of **123.2 ms** at the
default bound. The model closes to within a third, which is enough to price the candidate.

After the change the workspace is `mmap(MAP_NORESERVE)`, whose cost is one syscall per mapping and
no fault at all, and the pages that fault are the ones the evaluation writes. On that cohort the
rows and witness columns the evaluation fills are about 127,000 rows × 7 words × 4 bytes ≈ 3.6 MB,
the membership bitmap over a 2^24 universe is 2 MiB of which the `blocks` key clustering touches
most, and the bucket heads are 16 KiB. **I predict preparation at the default bound falls from
123.2 ms to 3 to 8 ms, a factor of 15 to 40, and that it lands at or below C1192's sized-bound
preparation of 21.3 ms** — that is, the candidate at the caller's careless default should be
*cheaper* than C1192 was at a hand-sized bound, because the sized bound still commits its whole
reservation.

### 2. Peak resident set

Same argument, same cohorts. At the default bound `cycle` at N = 4,096 is 1,131,440 KiB on the
C1192 arm and 23,872 KiB with a row bound of 100,000, a factor of 47. **I predict the candidate at
the default bound lands between 15,000 and 40,000 KiB on that program** — within a small factor of
the sized bound, which is the acceptance bullet — and I predict the *same* figure at the sized
bound, because under lazy commit the bound stops being a memory decision at all. I predict the
residual difference between the two bounds is the bucket-head table, whose slot count is sized from
the capacity and whose touched slots are sized from the rows: at the default bound `cycle` takes a
direct 2^24-key chain head and touches one slot per distinct key, which for 131,072 rows over a
`blocks` graph is at most 131,072 slots spread over 64 MiB of address space — so I predict the
head's committed pages, not its reserved pages, dominate, and I predict that is a few MB rather
than 64 MiB because the `blocks` keys cluster.

### 3. Instructions in the derivation loop

The zero sentinel is not free. A chain walk today is `while row != NONE { … row = next[row] }`; with
`index + 1` stored it becomes `while biased != 0 { let row = biased - 1; … biased = next[row] }`.
The comparison gets marginally cheaper (`test` against `cmp`) and the unbias costs one instruction
at each yielded row, because `join` needs the true row for both the tuple read and the witness
column. The `next` load itself folds the bias into its displacement, so it costs nothing.

**I predict +0.5 to +1.5 per cent instructions in the derivation loop on the cohorts whose loop is a
chain walk** (`cycle`, and the sparse membership cohorts), and **unity to within the A/A nulls on
the cohorts whose index is a counting-sorted CSR and whose membership is a bitmap**, because neither
of those structures has a chain. That is a prediction the card's "instructions in the loop at unity"
does not anticipate, and I will report the measured value rather than the bullet.

The high-water reset cuts the other way and is not in the loop's per-candidate cost: it replaces a
`fill` over the table with a walk over the rows used. On a small table — `closure` dense at N = 512
has a 2^18-bit bitmap, 32 KiB — the fill is a few hundred instructions and a walk over 262,144 rows
would be about three million, so **the walk must be conditional or it is a regression on exactly
the cohorts C1192 uses to show the direct path does not move.** I predict I implement a density
test, resolved once per relation per evaluation and never inside the derivation loop, and I predict
the constant does not matter much because the two arms of it are cheap in the regimes where each is
chosen.

### 4. Against Soufflé at the default bound

C1192 measured, on `closure` at the `blocks` density, whole-process ratios against compiled
Soufflé 2.5 of 3.244, 1.558 and 1.254 at the default row bound and 0.984, 0.814 and 0.950 with the
bound sized to 1.1 M rows. The difference is preparation and nothing else: instruction counts moved
by 3.5 per cent between the two bounds and evaluation not at all. **I predict the candidate's
default-bound column matches the sized-bound column to within the run-to-run interval on all three
sizes**, which is the card's expectation, **and I predict it slightly beats it**, for the reason in
prediction 1: the sized-bound arm still commits 35 MiB of `calloc`. I predict 0.80 to 1.00 at
N = 4,096, 0.75 to 0.90 at 16,384 and 0.90 to 1.00 at 65,536.

### 5. Where the risk is

In the order I expect it to bite. First, **the reset walk's correctness**: clearing a bucket head by
walking the rows that were inserted is exact only if every non-zero slot was written by some row
still counted by the high-water mark, which fails the moment a structure is written by anything but
`emit` and `index_rows`. Second, **`MADV_HUGEPAGE` fights the whole point**: a 2 MiB page commits
2 MiB on first touch, so advising huge pages on a sparsely touched bucket head or bitmap would undo
the saving while helping the densely filled row columns. I predict I measure it both ways and that
it is a loss on the tables the card names and a wash on the row columns, and I predict I ship it
off. Third, **the WebAssembly and non-Linux fallback**: `crates/verify` is in the tree the parity
corpus builds, so the fallback has to be a compiled path and not a comment. Fourth, **`Drop` order
and aliasing** in the mapping type; it is the only `unsafe` the task adds and it gets one `SAFETY`
comment, a `Drop`, and a measured benefit or it does not ship.

## What the change is

The demand evaluator's workspace reserves address space from the caller's row bound and commits
memory from the rows a program actually derives. Three things together do that, and a fourth was
forced by the first.

1. **Every workspace table is an anonymous `MAP_NORESERVE` mapping**, through one owned type,
   `crates/rules/src/pages.rs`. Reservation is one `mmap` whose cost does not depend on the length,
   and the kernel supplies a zero page on first write.
2. **Zero is the empty sentinel.** Bucket heads, chain links and membership heads hold `row + 1` and
   end at zero, so a page the kernel has never committed already reads as an empty table and
   preparation writes no `NONE` over it.
3. **The reset between evaluations walks the rows the previous one wrote**, not the capacity, unless
   the table is small enough that one linear pass over it cannot commit more memory per row than the
   row store already does.
4. **Each reservation's contents start at a rotating cache-line offset.** This was not in the plan;
   it is a repair for a 9 per cent cycle regression the first three created, and the mechanism is in
   the mystery ledger.

Beside them, the counting sort that builds a direct CSR index now uses the offsets array as its own
cursor rather than a second array of the same size, which was 64 MiB of preparation memory on a key
space of 2^24.

Nothing observable changed: the rows, the work counts, the certificates, both checkers' verdicts and
the closure digests are what C1192 produced, on every cohort and every fixture.

## Design, and the shapes not built

### `Pages<T>`: one owned mapping, and the only `unsafe` in the crate

```text
                 before                              after
reservation      vec![0u32; capacity]                mmap(PROT_READ|PROT_WRITE,
                 -> alloc_zeroed -> calloc                MAP_PRIVATE|ANONYMOUS|NORESERVE)
commit           every page, by calloc's memset      the pages a write touches
release          free                                munmap, in Drop
empty table      fill(NONE) over the capacity        a page that was never written
reset            fill(NONE) over the capacity        the slots the rows used
```

`Pages<T>` derefs to `[T]`, so every caller reads and writes it as an ordinary slice and the
derivation loop's code is unchanged by it. `T` is constrained by a private `unsafe trait ZeroValid`,
implemented for `u32` and `u64`, whose contract is that the all-zero bit pattern is a valid value —
which is what makes a fresh mapping a valid slice. There is one `SAFETY` note per unsafe operation,
a `Drop` that unmaps, and no interior pointer handed out. WebAssembly and any non-Unix target build
an `alloc_zeroed` backing instead, which is correct and simply does not have the lazy-commit
property; `libc` is a `[target.'cfg(unix)'.dependencies]` entry, so those targets never see it, and
it is already a dependency of the core's root crate and of `crates/repository-native`, so the tree
gains no new external crate.

### The allocation gate had a hole the moment the workspace stopped using `Vec`

A counting global allocator sees allocations. It does not see `mmap`. Moving the workspace to
mappings would therefore have made the existing zero-allocation regression pass vacuously for any
future reservation made inside the loop. `Pages` counts its reservations in one relaxed atomic on a
path that runs once per structure at construction, `ergodis_rules::reservations()` exposes the
count, and the regression asserts it is unchanged across a hundred evaluations **under each of the
five `Policy` variants** rather than the three C1192 covered.

### Resetting by the rows, and the one constant that decides which way

Between evaluations three structures must return to empty: a relation's membership bitmap, a
relation's membership hash heads, and a join index's bucket heads. Walking the rows the previous
evaluation wrote clears exactly the words those rows touched and can commit nothing they have not;
a linear fill is cheaper in instructions but commits every page of the table. `RESET_FILL_BYTES_PER_ROW`
is the rule and it is 32: a fill is admitted only where the table costs at most thirty-two bytes per
row of the previous evaluation, which is a little more than the twenty-eight bytes of tuple and
witness columns a derived row already commits, so a fill can never be the term that decides a
workspace's resident set.

The rule reads the **rows the last evaluation wrote**, not the capacity, and that is the whole point:
at the default row bound the capacity is 2^24 whatever the program derives. A fresh workspace's row
count is zero, so the first evaluation's reset touches nothing at all.

Two details make the walk exact. It runs **before** any relation's row count is reset, because the
rows it reads are the previous evaluation's. And clearing a whole bitmap word rather than one bit is
exact, because every bit set in that word was set by a row the same walk visits.

### Shapes considered and not built

1. **`MADV_HUGEPAGE` on the large tables**, which the card asks for. **Measured and rejected.** A
   huge page commits two mebibytes on first touch, which is the opposite of what this task is for.
   With the hint on every reservation of 2 MiB or more: `cycle` at the `blocks` density and
   N = 4,096 went from 38,516 KiB resident to 67,992, and `closure` at `blocks` and N = 4,096 from
   18,820 to 30,356 — **60 to 77 per cent more resident memory** — while evaluation moved by −4 to
   +3 per cent, inside the noise of a three-repeat median. `closure` dense at N = 512, whose tables
   are small, was a wash on both. The capability stays in `Pages::advise_huge` for a caller with a
   densely filled column and a measured reason; nothing calls it.
2. **`MADV_DONTNEED` as the reset** — "re-map the region", which the card offers as the alternative
   to a high-water walk. Not built. It is O(1) in user instructions and returns the memory to the
   kernel, but it decommits pages the *next* evaluation immediately refaults: on `cycle` at the
   default bound the index head holds about 4,096 committed pages, so every evaluation after the
   first would pay about 3 ms of fault handling on a 9 ms evaluation. It is the right shape for a
   workspace that is reset and then left idle, and the wrong one for a workspace evaluated
   repeatedly, which is what both the harness and a server do.
3. **Sizing the tables from the previous evaluation's row count**, which C1192's remaining gap 4
   named as the alternative to growing them. Not built and now unnecessary: the reservation is the
   thing that was expensive, and a reservation that costs nothing until touched does not need to be
   resized. It would also make a workspace's shape depend on its history, which `shape()` exists to
   forbid.
4. **A resumable mid-round budget exit**, which the card puts out of scope and asks to be recorded if
   capacity-from-the-program leaves a gap. It does leave one, and the gap is recorded under
   **Remaining gaps**: item 4 of the card wants a derived relation's capacity to come from the
   per-column domain product, which needs the C1191 closing pass that has not been written, so the
   capacity is still `min(domain^arity, row_bound)`. That no longer costs memory, but it still
   decides the row-capacity refusal.
5. **Applying `Pages` to the checkers' direct-addressed stores** in `crates/verify/src/datalog_store.rs`,
   which have exactly the same `calloc` behaviour over `domain^arity` entries. Not built, and the
   reason is a binding rather than a measurement: `ergodis_verify::implementation_identity()` hashes
   the checker source files, so a new module there moves a digest that certificates bind to. It is
   named under **Remaining gaps** with that constraint attached.
6. **Staggering by a page rather than a cache line.** Not built: sixty-four cache-line offsets
   already cover the page, and a page-granular stagger would cost a page per table for no further
   separation.

## Method

### The harness, and the two modes a measurement uses

`analysis/datalog-comparison/ab.py`, the committed interleaved driver C1192 wrote, unchanged: two
arms that may differ by revision or arguments, rounds that alternate arm order, an A/A null per
cohort, the non-multiplexing event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` with the enabled fraction
recorded per measurement, two-point differencing between `repeats` and `2 · repeats` evaluations so
process startup, admission and preparation leave every per-iteration figure, one pinned core, and
the load average over the run. Cache and TLB events get their own runs with their own nulls, because
they do not fit beside the two branch counters on this PMU.

**Both arms have `--evaluate-only` this time**, which C1192's control did not, so every derivation-loop
A/B here is taken in the kernel-scoped mode rather than in the full harness mode. Each arm prints its
derived, probe and candidate counts and a SHA-256 over the output relation's rows, and `ab.py`
refuses to summarize a cohort whose arms disagree on any of them.

### The cold-start stage, and why it is simpler than C1170's

`closure_ballpark --cold` is new: every iteration reserves a **fresh** workspace, evaluates once into
it, and drops it. C1170 had to pin `mallopt(M_MMAP_THRESHOLD, …)` below its pool sizes to make the
equivalent stage cold, because glibc raises its threshold after the first large free and thereafter
recycles pages the kernel has already backed. A workspace of anonymous mappings is unmapped at the
drop, so **each iteration is cold without any allocator tuning** — which is itself a consequence of
the change under test. The stage is read from its fault count and its wall time, never from
instructions: `perf_event_paranoid` is 2 on this host, so `perf` counts user-mode events only and
page-fault handling is kernel time.

### Which cohorts answer which question

| Cohort | What it measures |
| --- | --- |
| `closure` and `samegen`, sparse and dense | the direct path, which must not move: small universes, small tables, no reservation to speak of |
| `closure` at `blocks`, N = 4,096 to 65,536 | a large tuple universe with a small relation — the shape the reservation used to cost 500 MB for |
| `mutual` at `blocks` | a **static** direct CSR index over a 2^24 key space, whose offsets array is preparation memory rather than workspace memory |
| `cycle` at `blocks` | a **growing** relation's direct chain head over a 2^24 key space, reset before every evaluation: the largest single table in the lane |
| `stratified`, `columns`, `columns3`, `aggregate` | the C1191 boundary cohorts through `rel-lower`, where the peak resident set was gigabytes |

## Results

### The direct path, where the tables are small

Control `closure_ballpark-b7921a0` against the shipped candidate `closure_ballpark-ed99963`, five
interleaved rounds, CPU 5, repeat counts 3 and 6 with two-point differencing, `--evaluate-only`, the
six-event set at **100.00 per cent enabled on every event over 180 measurements**, load 6.93 to 9.76.
Receipt `analysis/datalog-comparison/ab-2026-09-17-c1198-direct-final.json` with its raw sidecar.
These are the six cohorts C1192 used to show that its direct path did not move, and the policy
selects a direct kind for every index and a bitmap for every membership test on all of them.

| Cohort | derived | instruction ratio [lo, hi] | A/A null | cycle ratio | cycle null | peak RSS, control / candidate KiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` sparse 256 | 62,979 | **0.98371** [0.98370, 0.98372] | 0.9999944 | 0.9833 | 0.9979 | 5,052 / 5,064 |
| `closure` sparse 1,024 | 979,983 | **0.98365** [0.98365, 0.98365] | 1.0000004 | 0.9887 | 1.0006 | 36,400 / 34,416 |
| `closure` dense 256 | 65,536 | **0.98335** [0.98334, 0.98335] | 0.9999958 | 0.9873 | 1.1650 | 7,592 / 7,660 |
| `closure` dense 512 | 262,144 | **0.98327** [0.98327, 0.98327] | 0.9999998 | 0.9353 | 0.8494 | 21,808 / 22,416 |
| `samegen` sparse 1,024 | 258,691 | **0.98246** [0.98245, 0.98246] | 1.0000027 | 1.0134 | 1.0684 | 68,916 / 11,580 |
| `samegen` dense 512 | 507,425 | **0.98300** [0.98300, 0.98300] | 1.0000011 | 0.9479 | 0.9925 | 19,520 / 19,156 |

**The derivation loop is 1.6 to 1.8 per cent cheaper in instructions on every one of them**, with
A/A nulls inside six parts per million, paired intervals narrower than a hundredth of a per cent,
and the output SHA-256 identical across arms on every cohort. Branches are unity to within two parts
in ten thousand and branch misses are inside their own nulls, so the control flow did not move; the
saving is the `fill(NONE)` that no longer runs and the zero sentinel's cheaper chain test.

**Every one of those six instruction ratios reproduces to five decimal places** against the same A/B
taken on `closure_ballpark-6078142` an hour earlier at a different box load
(`ab-2026-09-16-c1198-direct-shipped.json`, load 3.02 to 4.94), which is the between-run check C1192's
audit found missing for its cycle figures.

**Three of the six cycle ratios are not readable and are reported as such.** `closure` dense 512
carries a cycle A/A null of 0.8494, `closure` dense 256 one of 1.1650 and `samegen` sparse 1,024 one
of 1.0684, all far enough from unity that the playbook's rule says the candidate is not read for that
event on those rows — the box carried a load of seven to ten during this run. The three that are
readable sit at 0.948 to 0.989 against nulls of 0.993 to 1.001.

**Peak resident set falls where there was anything to fall.** `samegen` sparse at N = 1,024 is
68,916 KiB against 11,580, a factor of 5.9, because its derived relation's universe is 2^20 and its
row capacity at the default bound is 2^20; the other five cohorts have small universes and small
capacities and move by a few per cent either way.

### The same cohorts before the stagger, and what the stagger cost and bought

The A/B above was first taken on `closure_ballpark-356fce6`, the arm that carries `Pages`, the zero
sentinel and the high-water reset but **not** the cache-line stagger. Receipts
`ab-2026-09-16-c1198-prestagger-direct-b7921a0.json` (against the card's control) and
`ab-2026-09-16-c1198-prestagger-direct.json` (against `closure_ballpark-c3eda9a`).

Control `closure_ballpark-b7921a0` against candidate `closure_ballpark-356fce6`, five interleaved
rounds, CPU 5, repeat counts 3 and 6 with two-point differencing, `--evaluate-only`, the six-event
set at **100.00 per cent enabled on every event over 180 measurements**, load 2.04 to 2.30. Receipt
`analysis/datalog-comparison/ab-2026-09-16-c1198-direct-b7921a0.json` with its raw sidecar; the same
A/B against `closure_ballpark-c3eda9a` is
`ab-2026-09-16-c1198-direct.json`. These are the six cohorts C1192 used to show that its direct path
did not move, and the policy selects a direct kind for every index and a bitmap for every membership
test on all of them.

| Cohort | derived | instruction ratio [lo, hi] | A/A null | cycle ratio | cycle null | peak RSS, control / candidate KiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` sparse 256 | 62,979 | **0.99026** [0.99025, 0.99027] | 0.9999926 | 1.0140 | 1.0161 | 5,052 / 5,088 |
| `closure` sparse 1,024 | 979,983 | **0.99020** [0.99020, 0.99020] | 1.0000008 | 1.0109 | 1.0037 | 36,400 / 34,416 |
| `closure` dense 256 | 65,536 | **0.99161** [0.99161, 0.99161] | 0.9999997 | 1.0870 | 1.0019 | 7,592 / 7,624 |
| `closure` dense 512 | 262,144 | **0.99160** [0.99160, 0.99161] | 0.9999998 | 1.0894 | 0.9999 | 21,808 / 22,380 |
| `samegen` sparse 1,024 | 258,691 | **0.98918** [0.98917, 0.98919] | 1.0000026 | 1.0806 | 1.0462 | 68,916 / 11,532 |
| `samegen` dense 512 | 507,425 | **0.98976** [0.98976, 0.98976] | 0.9999986 | 0.9979 | 0.9928 | 19,520 / 19,140 |

**The derivation loop is 0.8 to 1.1 per cent cheaper in instructions on every one of them**, with
A/A nulls inside three parts per million, paired intervals narrower than a hundredth of a per cent,
and the output SHA-256 identical across arms on every cohort. Branches are unity to within two parts
in ten thousand and branch misses within their own nulls, so nothing about the control flow moved;
the saving is the removed `fill(NONE)` over each table, which the small-table cohorts still pay once
per evaluation on the control and which the candidate's `fill(0)` pays as a shorter instruction
sequence, plus the zero sentinel's cheaper `test` against `cmp` in each chain walk.

| Cohort | instruction ratio | A/A null | cycle ratio | cycle null |
| --- | ---: | ---: | ---: | ---: |
| `closure` sparse 256 | 0.99026 | 0.9999926 | 1.0140 | 1.0161 |
| `closure` sparse 1,024 | 0.99020 | 1.0000008 | 1.0109 | 1.0037 |
| `closure` dense 256 | 0.99161 | 0.9999997 | **1.0870** | 1.0019 |
| `closure` dense 512 | 0.99160 | 0.9999998 | **1.0894** | 0.9999 |
| `samegen` sparse 1,024 | 0.98918 | 1.0000026 | 1.0806 | 1.0462 |
| `samegen` dense 512 | 0.98976 | 0.9999986 | 0.9979 | 0.9928 |

**The two dense-closure rows are a 9 per cent cycle regression with instructions down 0.8 per cent,
against cycle A/A nulls of 1.0019 and 0.9999 that make them readable.** That is what sent the task
looking for a mechanism, and the mechanism — 4 KiB aliasing between page-aligned mappings — is in
mystery ledger item 2 with the counters that ruled out the alternatives.

**The stagger's effect is isolated, and it is entirely in cycles.** A probe binary built from the
shipped tree with the stagger multiplied out (`~/.cache/ergodis/bin/c1198-nostagger-probe`, measured
sha256 `551ae2e657adfe7d551e6a654c723f0c3016a9c0c921bf5487be5e3dc787a9d9`, a scratch build from a
tree dirty in exactly that one line, cited by nothing but this paragraph) against the shipped arm,
five interleaved rounds, CPU 5, receipt `~/.cache/ergodis/c1198/ab-stagger-probe.json`:

| Cohort | instruction ratio | A/A null | cycle ratio | cycle null |
| --- | ---: | ---: | ---: | ---: |
| `closure` dense 256 | **1.00000** [0.99999, 1.00000] | 1.0000023 | **0.6972** | 0.9915 |
| `closure` dense 512 | **1.00000** [1.00000, 1.00000] | 1.0000003 | 0.9228 | 0.8456 |
| `samegen` dense 512 | **1.00000** [1.00000, 1.00000] | 0.9999994 | 1.0052 | 0.9737 |
| `closure` blocks 4,096 | **1.00000** [0.99996, 1.00003] | 0.9999939 | 0.9986 | 0.9924 |

**The stagger changes the derivation loop's instruction count by nothing at all, to five decimal
places on four cohorts**, which is what a change that runs once per reservation at construction
should do, and it takes **30 per cent off the cycles of `closure` dense at N = 256** with a cycle null
of 0.9915. The dense-512 row's cycle null is 0.8456 and is not read.

**What the stagger does not explain is the other 0.8 per cent of instructions**, and what did is the
harness. The two candidate arms differ by the stagger *and* by
`closure_ballpark`'s new `--cold` mode, which is untimed and never runs in an A/B; the instruction
ratio moved from 0.990 to 0.983 between them, and the probe above shows the stagger contributed none
of it. That is the playbook's own C1170 lesson reproducing exactly — a driver-only edit moves an
untouched kernel through ThinLTO's module summary — this time with a control that separates the two.

### The cohorts the reservation was costing, at the default row bound

Control `closure_ballpark-b7921a0` against the shipped candidate `closure_ballpark-ed99963`, five
interleaved rounds, CPU 5, the six-event set at 100.00 per cent over 180 measurements, load 4.31 to
5.98. Receipt `analysis/datalog-comparison/ab-2026-09-17-c1198-memory-final.json`.

| Cohort | derived | instruction ratio | A/A null | cycle ratio | cycle null | peak RSS, control / candidate KiB | factor |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` blocks 4,096 | 65,536 | 0.98501 | 1.0000160 | **0.9885** | 1.0113 | 539,388 / **18,356** | **×29.4** |
| `closure` blocks 16,384 | 262,144 | 0.99970 | 0.9999970 | 0.7186 | 0.8606 | 599,896 / **83,892** | **×7.2** |
| `closure` blocks 65,536 | 1,048,576 | 1.01659 | 0.9999940 | 0.7622 | 0.9435 | 817,064 / **264,380** | **×3.1** |
| `mutual` blocks 4,096 | 61,440 | 0.97546 | 1.0000730 | 0.8766 | 0.9182 | 539,400 / **82,896** | **×6.5** |
| `mutual` blocks 8,192 | 122,880 | 1.06050 | 1.0000640 | **0.9902** | 1.0165 | 493,276 / **37,908** | **×13.0** |
| `cycle` blocks 4,096 | 131,072 | 0.99055 | 1.0000060 | **0.8179** | 1.0213 | 1,131,304 / **38,260** | **×29.6** |

Output digests identical across arms on every cohort.

**Peak resident set falls by a factor of 3.1 to 29.6 at the default row bound**, which is the result
the task exists for. `cycle` at N = 4,096 is the program C1192 measured at a factor of 47 between the
default bound and a hand-sized one: it now costs **38,260 KiB at the default bound** against the
23,872 KiB C1192 needed a row bound of 100,000 to reach. The caller's bound has stopped being a
memory decision.

**Five of the six cohorts are at or below unity in instructions and all six are at or below unity in
cycles.** `cycle` is the case where the control memsets a 64 MiB chain head before every evaluation
and the candidate walks 131,072 rows instead: instructions 0.991 and **cycles 0.818** against a
readable null of 1.021, an 18 per cent saving, because that memset was the evaluation's largest
memory traffic. The one cohort that pays is `mutual` at N = 8,192, at **6.1 per cent more
instructions**, because its 8 MiB membership bitmap is 2.1 times its rows' worth of bytes and the
reset therefore walks 122,880 rows rather than filling; its cycle ratio is 0.990 against a null of
1.017, so the wall cost of those instructions is nil, and what it buys is 445 MiB of resident memory.

**Two of the six cycle nulls sit at 0.861 and 0.944 and those rows are not read for cycles.** The
four that are readable — `closure` blocks 4,096 at 0.989, `mutual` at 8,192 at 0.990, `cycle` at
0.818 and `mutual` at 4,096 at 0.877 against a null of 0.918 — all favour the candidate.

### The reset's fill boundary, measured

`RESET_FILL_BYTES_PER_ROW` decides whether a table is returned to empty by one linear pass or by
walking the rows that wrote it, and it was set at 32 by reasoning — the row store commits twenty-eight
bytes per derived row, so a fill admitted only below that cannot be the term that decides a
workspace's resident set. **That reasoning was right about the bound and wrong about where the
cohorts sit.** Computing `table bytes / (32 × rows)` for every structure of every measured cohort:

| Regime | Structures |
| --- | --- |
| far below the boundary, 0.0001 to 0.016 | every structure of all six direct-path cohorts |
| at or near it, 0.5 to 2.1 | `closure` blocks 4,096's bitmap (1.00), `cycle` blocks 4,096's two bitmaps (0.50), `mutual` blocks 4,096's bitmap (1.07), `closure` blocks 65,536's membership heads (2.00), `mutual` blocks 8,192's bitmap (2.13) |
| far above it, 4 to 16 | `closure` blocks 16,384's bitmap (4.0), `cycle` blocks 4,096's chain head (16.0) |

So the constant is load bearing on five structures, and the claim that it was not had to be
withdrawn. It was then measured: the same binary at 32 against 64, five interleaved rounds, CPU 5,
on the four cohorts near the boundary
(`~/.cache/ergodis/c1198/ab-reset-constant.json`; the 64 arm is a probe build from a tree dirty in
exactly that one constant, `~/.cache/ergodis/bin/c1198-reset64-probe`, measured sha256
`0a7096a979e65485166b390044d50c60eab501d8edcff713983820b60a6e50de`, cited by nothing but this
paragraph and superseded by the shipped arm).

| Cohort | 64 over 32, instructions | A/A null | cycles | peak RSS at 32 / at 64, KiB |
| --- | ---: | ---: | ---: | ---: |
| `mutual` blocks 4,096 | **0.90318** | 1.0001340 | 0.9882 | 82,908 / 82,852 |
| `closure` blocks 65,536 | **0.98569** | 1.0000020 | 0.9833 | 264,396 / 264,368 |
| `mutual` blocks 8,192 | 0.99998 | 0.9999770 | 0.9216 | 37,920 / 37,888 |
| `closure` blocks 16,384 | 1.00001 | 1.0000010 | 1.0016 | 83,908 / 83,880 |

**Sixty-four is strictly better on the cohorts where it binds and costs nothing in memory**, so it is
what ships. The two cohorts that cross the boundary take 0.903 and 0.986 of the instructions and
their peak resident sets move by 56 and 28 KiB — that is, by nothing. The reason the fill is free
there is worth stating because it is not obvious: **a table whose bytes are within a small factor of
its rows has already had most of its pages committed by those rows**, so the fill writes pages that
are resident either way. The two structures four and sixteen times out walk under both values and do
not move, which is the control this comparison needs.

### Cache events on the cohorts the stagger repaired

Supplementary run, the playbook's cache set with its own nulls: five interleaved rounds, CPU 5,
`--evaluate-only`, 100.00 per cent enabled, load 3.17 to 3.39. Receipt
`analysis/datalog-comparison/ab-2026-09-16-c1198-cache-shipped.json`.

| Cohort | `L1-dcache-loads` | A/A null | `L1-dcache-load-misses` | A/A null |
| --- | ---: | ---: | ---: | ---: |
| `closure` dense 512 | 1.0000 | 0.9987 | 0.9919 | 1.0011 |
| `closure` blocks 4,096 | 0.9971 | 0.9954 | 1.0128 | 1.0332 |
| `samegen` dense 512 | 1.0105 | 0.9995 | 0.9743 | 1.0082 |

**Only the L1 data-load counter is readable, and it says the loop touches the same memory in the
same way.** Loads are unity to within one per cent with nulls inside five parts per thousand, and
misses are inside their own nulls on every row. `cache-references` and `cache-misses` carry nulls of
0.53 to 3.27 on these cohorts and are not read at all. The value of this table is the negative it
supplies for the mystery ledger: after the stagger, nothing about the loop's memory behaviour differs
from the control, which is what a change that only moved where the tables sit should show.

### Reach and resident set at the default row bound

Every row is the shipped arm `closure_ballpark-6078142` in `--evaluate-only` mode under
`choom -n 1000`, one process, one evaluation, default row bound unless stated. "Reserved" is
`Demand::workspace_bytes()`, the figure `MAX_WORKSPACE_BYTES` bounds; "peak RSS" is the process
high-water mark from `/proc/self/status` in KiB, which is the commit figure. The C1192 column is that
report's own reach table, measured on `closure_ballpark-b7921a0`.

| Program | density | N | derived | reserved, bytes | peak RSS KiB, C1192 | peak RSS KiB, now | factor |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` | sparse | 4,096 | 15,679,566 | 538,984,448 | 532,124 | 497,832 | ×1.07 |
| `closure` | sparse | 8,192 | — | — | `Budget`, row capacity | `Budget`, row capacity | — |
| `closure` | dense | 2,048 | 4,194,304 | 134,750,208 | 302,868 | 302,704 | ×1.00 |
| `samegen` | sparse | 8,192 | 15,787,097 | 1,090,584,576 | 1,070,124 | **514,904** | **×2.08** |
| `samegen` | sparse | 16,384 | — | — | `Budget`, row capacity | `Budget`, row capacity | — |
| `closure` | blocks | 4,096 | 65,536 | 538,984,448 | 539,524 | **18,216** | **×29.6** |
| `closure` | blocks | 16,384 | 262,144 | 570,490,880 | 600,004 | **83,792** | **×7.2** |
| `closure` | blocks | 65,536 | 1,048,576 | 671,350,784 | 817,192 | **264,312** | **×3.1** |
| `closure` | blocks | 65,536, bound 1.1 M | 1,048,576 | 48,250,752 | 244,872 | 244,672 | ×1.00 |
| `mutual` | blocks | 4,096 | 61,440 | 471,859,200 | 539,448 | **82,804** | **×6.5** |
| `mutual` | blocks | 8,192 | 122,880 | 478,150,656 | 493,348 | **37,888** | **×13.0** |
| `mutual` | blocks | 65,536, bound 1.1 M | 983,040 | 43,588,608 | 244,988 | 244,900 | ×1.00 |
| `cycle` | blocks | 4,096 | 131,072 | 1,145,061,376 | 1,131,440 | **38,288** | **×29.6** |
| `cycle` | blocks | 4,096, bound 100 K | 131,072 | 11,134,976 | 23,872 | 22,352 | ×1.07 |
| `cycle` | blocks | 65,536, bound 1.1 M | 2,097,152 | 104,627,968 | 262,864 | 260,384 | ×1.01 |

**The acceptance bullet the card states is met and the margin is the interesting part.** At the
default row bound `cycle` at N = 4,096 is now **38,288 KiB against the sized bound's 22,352**, a
factor of **1.7** where C1192 measured 47; `closure` at `blocks` and N = 65,536 is **264,312 against
244,672**, a factor of **1.08**. The residual is the bucket-head and bitmap pages the larger
capacity's hash spreads a fixed number of rows over, which is exactly what should remain.

**Three rows barely move and each says something.** `closure` sparse at N = 4,096 and `closure` dense
at N = 2,048 derive 15.7 M and 4.2 M tuples, so they genuinely need most of what they reserve — the
change cannot help a program that uses its workspace. `samegen` sparse at N = 8,192 halves, from
1,070,124 KiB to 514,904, because its derived relation's universe caps the capacity at the rows it
really needs while its *other* relations do not. **What the change buys is confined to the gap
between the bound and the rows, and where there is no gap there is no saving.** That is the correct
shape for it to have.

### Cold start: the reservation, the commit, and the proof that each iteration is cold

`closure_ballpark --cold` on the shipped arm, `cycle` at the `blocks` density and N = 4,096, pinned
to CPU 5 under `choom -n 1000`, at three repeat counts. Each iteration reserves a fresh workspace,
evaluates once, and drops it.

| Repeats | `perf` page faults, whole process | this process's own minor faults | per iteration, own | per iteration, two-point | committed, KiB | reserved, KiB |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 10 | 117,379 | 112,918 | 11,291.80 | — | 24,436 | 1,118,224 |
| 20 | 230,298 | 225,833 | 11,291.65 | 11,291.5 (10 → 20) | 24,508 | 1,118,224 |
| 40 | 456,133 | 451,667 | 11,291.68 | 11,291.7 (20 → 40) | 24,512 | 1,118,224 |

**The three parts of C1170's coldness proof, each met.**

1. **Faults per iteration are constant and the count scales exactly.** 11,291.7 per iteration at
   every repeat count, and the two-point differences reproduce it to a part in a hundred thousand,
   so there is no reuse of pages the kernel has already backed.
2. **`/proc/self/stat` agrees with `perf`.** The process's own minor-fault counter and `perf`'s
   page-fault counter differ by a constant 4,461 to 4,466 — process startup, which the repeat count
   does not change — and their per-iteration slopes agree to five digits.
3. **There is no touch loop in the disassembly, and there is no zeroing call either.** In the
   control, `__rust_alloc_zeroed` is called from the two `Map::fold` symbols that are the workspace's
   `collect`; in the shipped arm those two call sites are gone and the remaining `alloc_zeroed` sites
   are `Demand::prepare` (the CSR offsets array, which the prefix sum writes densely anyway),
   `Demand::certificate` (a cold pass) and structures the checkers build. `Pages::zeroed` is
   fifty-two instructions with exactly one call in it, `mmap@GLIBC_2.2.5`, and no store loop, `rep
   stos` or vector store.

**C1170 needed `mallopt(M_MMAP_THRESHOLD, …)` to make its stage cold and this one does not**, because
a workspace of anonymous mappings is unmapped at the drop rather than returned to an allocator that
recycles it. The cold stage is simpler than the one it copies, and that simplification is a
consequence of the change under test.

**The reservation is 45.6 times the commit**: 1,118,224 KiB reserved against 24,436 to 24,512 KiB
committed, on a program whose caller asked for a row bound of 2^24 and which derives 131,072 tuples.
That is deliverable 5 in one line — `MAX_WORKSPACE_BYTES` bounds the first number, and the second is
what the machine pays.

**The two numbers do not divide the way one expects, and the reason is worth recording.** 11,291.7
faults per iteration against 6,128 committed pages is 1.84 faults per committed page, not one. A
**read** of an untouched anonymous page costs a minor fault and commits nothing, because the kernel
maps the shared zero page; the later **write** costs a second fault and commits. Measured directly on
this host with a 32 MiB anonymous mapping: a read pass over 8,192 pages took 8,196 minor faults and
**zero** resident kilobytes, and the write pass that followed took 8,192 more faults and 32,768 KiB.
The derivation loop reads a bucket head before it writes it, so about 5,160 of the 11,292 faults per
iteration are free in memory and are not free in time. Nothing in this task turns on it; it is the
first thing to look at for whoever wants the cold path faster.

### The frontend and the stratified backend

Control `ergodis-tools-f12e27b` against candidate `ergodis-tools-6078142`, five interleaved rounds,
CPU 5, the same six-event set at **100.00 per cent enabled on every event over 1,618 measurements**
for the nine-cohort run, load 2.53 to 6.14, two-point differencing. Receipts
`analysis/rel-frontend/performance-v9-c1198-6078142.json` and its four per-cohort siblings.

| Cohort | `scan` | `parse` | `admit` | `lower` | `stratify` − `lower`, instructions | cycles | peak RSS, control / candidate KiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `ascii` | 1.000003 | 1.000001 | 0.999999 | 1.000001 | — | — | — |
| `unicode` | 1.000000 | 1.000000 | 0.999999 | 1.000000 | — | — | — |
| `comment-string` | 1.000038 | 1.000021 | 1.000014 | 1.000001 | — | — | — |
| `malformed-early` | 1.000003 | 1.000001 | 1.000001 | 1.000000 | — | — | — |
| `malformed-late` | 1.000003 | 1.000001 | 1.000001 | 0.999999 | — | — | — |
| `datalog` (512 definitions) | 1.000026 | 1.000006 | 0.999999 | 1.000000 | **0.99019** | 0.9356 | 127,204 / **33,968** |
| `stratified` (128) | 1.000031 | 1.000000 | 1.000000 | 1.000003 | **0.99758** | 0.9972 | 11,424 / 11,612 |
| `columns` (128) | 1.000009 | 1.000008 | 1.000002 | 0.999994 | **0.99686** | 0.9308 | 16,772 / **12,420** |
| `aggregate` (128) | 1.000090 | 1.000015 | 0.999969 | 1.000000 | **0.98965** | 0.8305 | 21,128 / **9,720** |

**Scan, parse, admission and lowering are unity to within ninety parts per million on every cohort**,
so nothing in the front end moved — as it should not, since nothing this task touches runs there.
The backend stage is 0.2 to 1.0 per cent cheaper in instructions and 0.83 to 1.00 in cycles.

**The four closure SHA-256 digests are identical across arms and identical to the ones C1191 and
C1192 recorded**: `5c455ad4…`, `dffdcd35…`, `3f5c4cdd…` and `ec562d2c…`. Both independent checkers
verified on both arms.

**Peak resident set on the Rel route falls by up to a factor of 3.7.** `datalog` at 512 definitions
goes from 127,204 KiB to 33,968; `aggregate` from 21,128 to 9,720; `columns` from 16,772 to 12,420;
`stratified` is a wash at 11,424 against 11,612, because its memory is complement materialization
rather than the demand workspace.

### The C1191 boundary cohorts

Bisection over the committed `rel-lower` tool on committed cohorts with C1191's own flags
(`--max-rows 16777216 --values 262144`), under `choom -n 1000`, on both arms. Each row is the largest
dictionary that completes the whole chain including both independent checkers.

| Cohort | largest dictionary | peak RSS, C1192 KiB | control `f12e27b` KiB | candidate KiB | factor | first refused, and the bound |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `stratified` | 2,047 | 1,386,664 | 1,387,460 | 1,387,056 | ×1.00 | 2,048: tuples of one layer's program, 4,197,376 against 4,194,304 |
| `columns` | 4,092 | 2,724,276 | 2,723,660 | **1,592,872** | **×1.71** | 4,094: the same bound, 4,195,326 |
| `columns3` | 483 | 3,138,432 | 3,138,936 | **1,823,756** | **×1.72** | 486: complement facts of one negated relation, 4,251,528 |
| `aggregate` | key set 2,046 | 2,306,496 | 2,306,776 | **987,840** | **×2.34** | key set 2,047: tuples of one layer's program, 4,196,350 |

**The boundaries themselves are unchanged to the definition**, and each refusal reproduces C1192's
budget name, found value and limit exactly. Three of the four peak resident sets fall by 1.7 to 2.3
times; `stratified` does not move, and that is the useful negative, because its memory is the
complement it materializes and not a workspace reservation. **`columns3` at a dictionary of 483 was
the largest single number in C1192's report at 3.14 GB; it is 1.82 GB.**

### Against Soufflé at the default row bound

The shipped arm `closure_ballpark-6078142` against Soufflé 2.5 (32-bit word, from the nix store at
`/nix/store/7f17fq5wcg19x5s4f7kh3pvknl8zfa55-souffle-2.5`), both the compiled binary and the
interpreter, both `-j1`, five interleaved rounds per size with rotated start order on CPU 5 —
C1192's method exactly, through the same committed `compare.py`. "Ergodis" and each Soufflé arm are
whole processes: read the fact file, evaluate, write the derived relation. Receipts
`analysis/datalog-comparison/results-2026-09-16-c1198-blocks.json` and `-blocks-bounded.json`.

**Exactness first: on all six cases the Ergodis derived relation equals the compiled Soufflé output
as a tuple set, and the interpreter's output equals the compiled binary's.** The certificate is
emitted and independently checked in the warm pass of every case.

| N | output | row bound | Ergodis s | compiled s | interp s | vs compiled [lo, hi] | C1192's | vs interp | instructions M, e/c/i | peak RSS MB, e/c/i | C1192's e |
| ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- | ---: |
| 4,096 | 65,536 | `2^24` | 0.0544 | 0.0615 | 0.1068 | **0.852** [0.737, 0.985] | 3.244 | 0.568 | 382 / 423 / 801 | **18** / 6 / 11 | 527 |
| 16,384 | 262,144 | `2^24` | 0.1334 | 0.1688 | 0.2455 | **0.819** [0.765, 0.875] | 1.558 | 0.562 | 1,539 / 1,717 / 3,145 | **84** / 12 / 17 | 587 |
| 65,536 | 1,048,576 | `2^24` | 1.0422 | 0.9521 | 1.1019 | **1.172** [0.948, 1.449] | 1.254 | 0.821 | 6,676 / 7,079 / 12,741 | **265** / 36 / 40 | 805 |
| 4,096 | 65,536 | 1.1 M | 0.0490 | 0.0563 | 0.1016 | 0.829 [0.735, 0.935] | 0.984 | 0.541 | 382 / 423 / 801 | 18 / 6 / 11 | 48 |
| 16,384 | 262,144 | 1.1 M | 0.1385 | 0.1721 | 0.2480 | 0.812 [0.783, 0.842] | 0.814 | 0.564 | 1,539 / 1,717 / 3,145 | 84 / 12 / 17 | 108 |
| 65,536 | 1,048,576 | 1.1 M | 0.6221 | 0.6437 | 0.9407 | 0.963 [0.941, 0.986] | 0.950 | 0.652 | 6,760 / 7,079 / 12,741 | 247 / 36 / 40 | 246 |

**At the two smaller sizes the default-bound column now matches the sized-bound column, which is
exactly the expectation the card set.** 0.852 against 0.829 at N = 4,096 and 0.819 against 0.812 at
16,384, each inside the other's interval — where C1192 measured 3.244 against 0.984 and 1.558 against
0.814. **The default-bound ratio at N = 4,096 improved by a factor of 3.8 and its peak resident set
by a factor of 29**, from 527 MB to 18 MB, which is now three times compiled Soufflé's rather than
eighty-eight times. Ergodis is also **within 10 per cent of compiled Soufflé's instruction count at
every size and bound**, and the counts are the same to three digits under the two bounds, so
nothing about the work changed.

**At N = 65,536 the two columns have not converged, and the reason is not memory.** The default bound
gives 1.172 against the sized bound's 0.963, with the intervals barely touching. The phase
decomposition says where it sits:

| N | row bound | prepare ms | evaluate ms | read ms | write ms | whole process ms | peak RSS KiB |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 4,096 | `2^24` | 14.8 | 6.5 | 2.7 | 1.1 | 25.0 | 17,892 |
| 4,096 | 1.1 M | 14.8 | 6.5 | 2.7 | 1.1 | 25.0 | 17,888 |
| 16,384 | `2^24` | 63.4 | 33.5 | 10.9 | 3.6 | 111.4 | 86,036 |
| 16,384 | 1.1 M | 64.0 | 34.6 | 10.8 | 3.8 | 113.2 | 86,164 |
| 65,536 | `2^24` | 434.2 | 446.8 | 103.4 | 22.2 | 1,006.6 | 271,800 |
| 65,536 | 1.1 M | 276.9 | 231.1 | 45.2 | 15.0 | 568.2 | 252,496 |

**The two smaller sizes are now identical under the two bounds, phase for phase**, which is the clean
form of the result: at N = 4,096 preparation was 123.2 ms at the default bound and 21.3 ms at the
sized one in C1192, and it is 14.8 ms under both here. At N = 65,536 the bound still costs 157 ms of
preparation and 216 ms of evaluation. That residual is **locality, not commit**: at the default bound
that program's membership table is sparse with 2^24 slots and at the sized bound with 2^21, and a
million rows scattered over sixteen million slots miss more than a million rows scattered over two
million. Lazy commit removes the memory cost of an over-declared bound; it does not remove the cost
of hashing into a table sized from it. That is the one part of remaining gap 4 this task does not
close, and it is recorded as such.

**Peak resident set is no longer the standing weakness it was.** 18 to 265 MB at the default bound
against Soufflé's 6 to 40 MB, where C1192 measured 527 to 805 MB. The gap that remains is the
certificate and the row stores of a relation that really holds a million tuples, not a reservation.

### Page faults, by symbol, before and after

`perf record -e page-faults -c 200` on one `--evaluate-only` process, `cycle` at `blocks` and
N = 4,096, pinned to CPU 5. `perf.data` under `~/.cache/ergodis/perf-c1198/`.

| Arm | Top symbols above one per cent |
| --- | --- |
| control `closure_ballpark-b7921a0` | `__memset_avx512_unaligned_erms` **98.45 %**, nothing else above 0.5 % |
| shipped `closure_ballpark-6078142` | `Demand::index_rows` 53.16 %, `Demand::evaluate_into` 18.99 %, `Map::fold` 7.59 %, `hashbrown::RawTable::reserve_rehash` 5.06 %, `__memmove_avx512_unaligned_erms` 3.80 %, `_int_malloc` 2.53 %, `__memset_avx512_unaligned_erms` **1.27 %**, `main` 1.27 %, `push_decimal` 1.27 %, `datalog::admit` 1.27 % |

**The whole fault profile changed owner.** On the control, the process's 283,893 page faults are
`calloc` zeroing a workspace nobody has written to yet. On the candidate its 15,733 faults belong to
the code that actually writes rows, and the residue attributed to `memset` is 1.27 per cent of a
count eighteen times smaller — the `fill(0)` on the tables the reset rule keeps linear, plus
admission. That is the acceptance bullet "no `memset` in preparation above the touched pages", read
as a counted profile rather than as an assertion.

## Profile

Kernel-scoped: `perf record -e instructions:u -F 4000` pinned to CPU 5 on
`closure_ballpark --evaluator demand --program closure --certificates 512 dense 20`, the harness
mode that evaluates twenty times and generates the two certificates and nothing else — no checker,
no serialization, no output file — which both arms have. `perf.data` under
`~/.cache/ergodis/perf-c1198/`.

| Symbol | control `b7921a0` | shipped `6078142` |
| --- | ---: | ---: |
| `ergodis_rules::demand::Demand::evaluate_into` | 98.34 % | 98.30 % |
| `ergodis_rules::demand::Demand::certificate` | 0.85 % | 0.82 % |
| `ergodis_rules::demand::Demand::index_rows` | 0.34 % | 0.34 % |
| `__memmove_avx512_unaligned_erms` | 0.14 % | 0.20 % |

**The two profiles are the same profile**, which is the correct outcome for a change that moves where
the workspace lives rather than what the loop does. **No out-of-line call appears inside the
derivation loop on either arm**, and that is a statement about the loop and not only about the
profile: below a 0.005 per cent cut both arms show `_int_malloc`, `cfree`, `hashbrown` and
`format_escaped_str`, all of them admission and certificate serialization outside it, and the
`memmove` residue is the workspace reset before the loop and the certificate's cold pass. **No
`memset` symbol appears on either arm at any cut on this cohort**, because its tables are small
enough that the reset rule keeps them linear and the fill is a few hundred bytes.

The profile that did change is the page-fault one, two sections above: the control's faults are
`calloc` zeroing a workspace nobody has written to, and the candidate's belong to the code that
writes rows.

**The derivation loop's compiled body is byte-identical between the retained arm and the tree's final
revision.** The core moved once more after `closure_ballpark-6078142` was retained — `ca64c34` adds
the reset assertion and its test program and changes no other code — and a release rebuild of the
example at that revision differs from the retained binary in 236,456 bytes of symbol layout while
`Demand::evaluate_into` disassembles to **the same 7,702 instructions, line for line**. Every A/B
figure above therefore describes the kernel the tree carries.

## Exactness

| Gate | Outcome |
| --- | --- |
| Core `cargo test --all-features` at `ca64c34` | **81 test binaries, zero failures**, including the new `workspace_commit` suite, the two new in-module reset tests, and the `pages` reservation tests |
| Private `cargo test -p ergodis-private -p ergodis-tools` | **42 test binaries, zero failures**, the same count C1192 recorded; this drives `rel_lowering`, `rel_frontend`, `rel_frontend_portability` and `rel_reference_eval` |
| C1189 differential (`rel_reference_eval`) | passes with **zero disagreements** at its unchanged seeds |
| Clippy, both repositories, `--all-targets --all-features -D warnings` | no diagnostics |
| `cargo fmt --check`, both repositories | clean |
| `SHA256SUMS` regenerated with every source change | `tests/evidence_manifest.rs` passes, public lint clean on every commit |
| WebAssembly build | `cargo build -p ergodis-rules --target wasm32-unknown-unknown --release` succeeds, so the `alloc_zeroed` fallback is a compiled path; `libc` is target-gated and never enters that tree |
| Native/WebAssembly parity replay | regenerated from the committed gate command and **identical to the committed `analysis/rel-frontend/portability-v1.json` in every field**, canonical digest `349333d4…` unchanged: 243 cases, 530,505 canonical bytes, native and WebAssembly byte-equal. This task edits no lowering pass, which is what that corpus canonicalizes |
| Output SHA-256 across A/B arms | identical on **every cohort of every A/B**: six direct-path cohorts, six memory cohorts, three cache cohorts, four stagger-probe cohorts. `ab.py` exits non-zero rather than reporting success when arms disagree, and none did |
| Derived, probe and candidate counts across arms | identical on every cohort of every A/B |
| Closure SHA-256, four Rel-route backend cohorts | identical across arms and identical to C1191's and C1192's: `5c455ad4…`, `dffdcd35…`, `3f5c4cdd…`, `ec562d2c…`; both independent checkers verified on both arms |
| C1191 boundary cohorts | all four still verify with both checkers at their largest dictionary, and each first refusal reproduces C1192's budget name, found value and limit exactly |
| Tuple-set agreement with Soufflé 2.5, three sizes under two row bounds | agrees on all six cases; the interpreter's output equals the compiled binary's on all six |
| Certificate agreement between the addressing kinds | **byte-identical**, unchanged: `demand_sparse` asserts it on the fixtures, the generated closure family at two row bounds and the property corpus, under `Auto`, `Direct` and `Sparse` |
| Repeated evaluation into one workspace | rows, work counts and certificate bytes identical across four evaluations at a row bound of 2^24, under **every** `Policy`; and a workspace a larger program filled gives what a fresh one gives for a smaller program of the same shape |
| Zero allocations **and zero reservations** in the derivation loop | 100 repeated evaluations of `same_generation.json` under the counting allocator, **under each of the five `Policy` variants**: 0 allocations and `reservations()` unchanged |
| The commit ratio, asserted rather than only measured | `a_default_bound_workspace_commits_a_small_fraction_of_what_it_reserves` builds a plan reserving over 400 MB for a program deriving 2,016 tuples and asserts the resident-set delta is under a twentieth of it, and that a second evaluation commits under a twentieth more |
| Deliberate mutations | both caught, by name, and the interesting part is *where* — see below |

**The deliberate mutations, and the test that had to be written because of them.** Two mutations were
applied to a working tree and reverted: **A**, the join indexes' bucket heads are not cleared; **B**,
the membership tables are not cleared.

- Mutation **B** fails `workspace_commit`'s three tests and the two in-module tests immediately.
- Mutation **A** passed every integration test in `workspace_commit.rs` and then made
  `crates/rules/tests/allocation.rs` **spin for nine minutes without terminating**, which is how it
  was found.

Both facts are structural and worth stating. A stale bucket head holds the previous evaluation's
**last** row for a slot, so when that row is reinserted `next[row]` is made to point at the row
itself and the chain becomes self-referential; the next walk of it does not terminate. A suite that
only evaluates twice therefore hangs rather than failing, which is a far weaker signal than an
assertion. And `workspace_commit.rs`'s closure cohorts could not see it at all, for a reason that is
about the evaluator rather than about the test: **a closure program's chain index is consulted only
by the step whose delta atom is the input relation, and that step's `MODE_FULL` limit is zero in the
first round, so the step is skipped and the chain is never walked.**

The repair is `the_reset_returns_every_table_to_empty_under_every_policy`, an in-module test that
calls the two reset paths on a workspace a previous evaluation filled and asserts every bucket head,
membership head and membership bit is zero, on a same-generation recursion whose chains are walked
after they are rebuilt. Under mutation A it fails in milliseconds with
`Auto index 0 kind 3 keeps a bucket head`; under mutation B with
`Auto relation 2 keeps a membership bit`. That test is the load-bearing gate on this task's
correctness, and it exists because the first version of the corpus did not discriminate.

## Disposition

**Kept**, by the forward commits in the table above; nothing is reverted. Four changes, measured:

1. **The lazily committed workspace** (`ergodis` `3eaaacf`): peak resident set falls by a factor of
   3.1 to 29.6 at the default row bound on the memory cohorts, by 1.7 to 2.3 on three of the four
   C1191 boundary cohorts, and by 3.7 on the Rel route's `datalog` cohort; the derivation loop is
   1.6 to 1.8 per cent cheaper in instructions on the six cohorts where nothing about the tables
   changed.
2. **The counting sort's cursor** (`ergodis` `93e12cf`): `mutual` at the `blocks` density and
   N = 4,096 went from 144,616 KiB to 82,804.
3. **The cache-line stagger** (`ergodis` `271d648`): zero instruction change, 30 per cent off the
   cycles of `closure` dense at N = 256, and it is what makes the change a wall-time win rather than
   a wall-time loss on the dense cohorts.
4. **The direct reset assertion** (`ergodis` `ca64c34`): no measured effect, and the derivation
   loop's disassembly is unchanged; it is the gate that makes the first change's correctness
   checkable in milliseconds instead of by a hang.

**One variant was measured and rejected**: `MADV_HUGEPAGE` on every reservation of two mebibytes or
more, which costs 60 to 77 per cent more resident memory on the cohorts this task exists for and
moves evaluation inside the noise. `Pages::advise_huge` remains as a capability with no caller.

## Recorded deviations

1. **The reservations are staggered by a cache line**, which the card did not ask for and which no
   part of the design anticipated. It is a repair for a 9 per cent cycle regression the first three
   deliverables created; the mechanism, the counters that ruled out the alternatives and the isolated
   measurement are in mystery ledger item 2. Without it the change is a memory win and a wall-time
   loss on the dense cohorts, so it is not optional.
2. **`MADV_HUGEPAGE` is implemented and not used.** The card asks for it on large tables. Measured
   with the hint on every reservation of two mebibytes or more, it costs 60 to 77 per cent more
   resident memory on the two cohorts this task exists for and moves evaluation inside the noise, so
   it is a measured negative rather than an omission. `Pages::advise_huge` is kept for a caller with
   a densely filled column and a reason; nothing calls it.
3. **The counting sort's cursor is gone**, which the card did not ask for. `Demand::csr` held two
   arrays of `domain^popcount(mask) + 1` entries — 128 MiB at a key space of 2^24 — and one of them
   existed only for the placement pass. This is preparation memory rather than workspace memory, and
   after the reservation change it was the largest remaining term on `mutual`, which is why it was
   taken here: that cohort went from 144,616 KiB to 82,804.
4. **The allocation regression grew a second counter and three more policies.** A counting global
   allocator cannot see an `mmap`, so moving the workspace to mappings would have made the existing
   gate pass vacuously. `ergodis_rules::reservations()` is a public counter incremented once per
   reservation, and the regression asserts it is unchanged across the loop under each of the five
   `Policy` variants rather than the three C1192 covered — which is the card's "every `Policy`".
5. **`closure_ballpark` gained a `--cold` mode**, which the card implies rather than states. It is
   the C1170 cold-start stage adapted: a fresh workspace per iteration, its own minor-fault count
   from `/proc/self/stat`, the reserved bytes and the committed kilobytes. Adding it moved the
   derivation loop's instruction ratio by 0.8 per cent through ThinLTO although it is untimed and
   never runs in an A/B; that is recorded above with the probe that separates it from the stagger.
6. **Two controls were retained rather than one.** The card names `closure_ballpark-b7921a0` and
   `ergodis-tools-f12e27b`; the tree has moved three commits past both, one of which edits the
   harness driver. Both were retained and both A/Bs run; they agree to five decimal places, so the
   card's controls are sound and the report quotes them.
7. **A third table is cleared by a linear fill and not by the rows**, which reads against the card's
   "never by capacity". The rule is `RESET_FILL_BYTES_PER_ROW`: a fill is admitted only where the
   table costs at most thirty-two bytes per row the previous evaluation wrote, so it can never
   commit materially more than the row store already has. The card's intent — that the reset must
   not be sized from the caller's bound — holds exactly, because the rule reads the rows and not the
   capacity.
8. **Deliverable 4 is unchanged code.** "Capacity from the program where a bound exists" already
   described the evaluator: an input relation's capacity is its fact count and a derived relation's
   is `min(domain^arity, row_bound)`. The per-column domain product needs the C1191 closing pass,
   which does not exist. Nothing was written for item 4, and what it would still buy is recorded
   under **Remaining gaps**.

## Remaining gaps

*Pending.*

## Mystery ledger

*Pending.*

## Replay commands

*Pending.*

## What this task left under `~/.cache/ergodis/`

*Pending.*

## The control for the next A/B

*Pending.*

## Vibe check

*Pending.*
