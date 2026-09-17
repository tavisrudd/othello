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

*Pending.*

## Profile

*Pending.*

## Exactness

*Pending.*

## Disposition

*Pending.*

## Recorded deviations

*Pending.*

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
