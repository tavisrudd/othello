# C1198 — the demand workspace sized from rows: zero sentinels, high-water reset, lazy page commit

**Lane**: `ergodis`
**Date**: 2026-09-16 (closed 2026-09-17)
**Status**: DONE, GATED, AUDITED AND REPAIRED. Built, gated and measured, with every measurement the
card asked for taken, and with an `ej` and `tt` closeout pass whose findings are applied. Written
incrementally from before the first line of code, so a crash would have left a partial record rather
than none. Independently audited by C1199 (`2026-09-17-c1199-c1198-audit.md`), which reproduced every
recorded value and found one code defect and one wrong result; both are repaired by C1200
(`2026-09-17-c1200-c1198-repair-pass.md`), whose thirteen record and code repairs are applied here.
**The one claim this report got wrong is the cache-line stagger's mechanism**, and the corrected
account is in recorded deviation 1 and mystery ledger item 2.

## Status

**Done, gated and measured.** The demand evaluator's workspace reserves address space from the
caller's row bound and commits memory from the rows a program derives. **Peak resident set falls by
a factor of 3.1 to 29.6 at the default row bound** on the six memory cohorts, by 1.7 to 2.3 on three
of the four C1191 boundary cohorts, and by 3.7 on the Rel route's largest; **the derivation loop is
1.6 to 1.8 per cent cheaper in instructions** on the six cohorts C1192 used to show that its direct
path did not move. Against compiled Soufflé 2.5 on `closure` at the `blocks` density and N = 4,096,
the whole-process ratio at the harness's **default** row bound goes from C1192's **3.244 to 0.852** —
better than the 0.984 C1192 reached only by hand-sizing the bound — with peak resident set from
527 MB to 18 MB and preparation from 123.2 ms to 14.8 ms.

The instruction figure is the arm this task shipped, `ed99963`. C1200's repair for the domain defect
gives back 0.67 to 0.85 per cent of it, so against C1192's control the core the tree now carries
stands at 0.991 to 0.996 on those six cohorts; the memory result is untouched.

**The card's stated mechanism was wrong and the probes said so before any code.** The eager commit
was not the explicit `fill(NONE)`; it was `calloc` memsetting a workspace nobody had written to,
which a page-fault profile of the retained control attributes at 98.45 per cent. That reverses the
card's ordering of its own deliverables and is mystery ledger item 1.

**The gates.** Core: 81 test binaries, zero failures; clippy and `cargo fmt` clean; `SHA256SUMS`
current; `ergodis-rules` builds for `wasm32-unknown-unknown`, so the non-Unix fallback is a compiled
path. Private: 42 test binaries, zero failures, including the C1189 differential at zero
disagreements. The four Rel-route closure digests are unchanged from C1191 and C1192; the
native/WebAssembly parity manifest regenerates **identical in every field**, canonical digest
`349333d4…` unmoved; the output digest is identical across arms on every cohort of every A/B; the
derivation loop allocates zero and reserves zero under each of the five `Policy` variants; and two
deliberate mutations both fail, by name, in milliseconds.

**Every receipt** (paths under `~/src/ergodis-private/` unless stated):

| What | Receipt |
| --- | --- |
| the direct path, shipped arm, six cohorts | `analysis/datalog-comparison/ab-2026-09-17-c1198-direct-final.json` |
| the memory cohorts, shipped arm, six cohorts | `analysis/datalog-comparison/ab-2026-09-17-c1198-memory-final.json` |
| the same two, on `6078142`, two core commits and three private commits earlier | `analysis/datalog-comparison/ab-2026-09-16-c1198-{direct,memory}-shipped.json` |
| the supplementary cache run, on `6078142` | `analysis/datalog-comparison/ab-2026-09-16-c1198-cache-shipped.json` |
| the arm before the stagger, and the cache and TLB runs that diagnosed it | `analysis/datalog-comparison/ab-2026-09-16-c1198-prestagger-{direct,direct-b7921a0,memory,cache,tlb}.json` |
| the frontend and the stratified backend, five runs | `analysis/rel-frontend/performance-v9-c1198-{,datalog-,stratified-,columns-,aggregate-}6078142.json` |
| Soufflé 2.5, three sizes, default row bound | `analysis/datalog-comparison/results-2026-09-16-c1198-blocks.json` |
| Soufflé 2.5, the same three sizes, row bound 1.1 M | `analysis/datalog-comparison/results-2026-09-16-c1198-blocks-bounded.json` |
| the native/WebAssembly parity manifest, replayed unchanged | `analysis/rel-frontend/portability-v1.json` |
| the stagger and reset-constant probes | `~/.cache/ergodis/c1198/ab-{stagger-probe,reset-constant}.json` |
| the page-fault and kernel-scoped profiles, both arms | `~/.cache/ergodis/perf-c1198/` |
| **the stagger commit isolated, and the store-to-load-forward counters** (C1200) | `analysis/datalog-comparison/ab-2026-09-17-c1200-{stagger-isolated,stlf-stagger,stlf-nostagger}.json` |
| the locality run at N = 65,536 under the two row bounds (C1199) | `~/.cache/ergodis/c1199-audit/ab-locality.json` |

Every `ab.py` receipt has a `.jsonl` sidecar of its raw samples beside it, and `--resummarize`
rebuilds it without measuring. The reach, boundary and cold-start tables were taken by single
invocations of the committed tools and are reproduced by the replay block at the end.

**Nothing is half-built.** Every source change is committed in both repositories; `git status` is
clean in `ergodis`, `ergodis-private` and `othello`, and was clean before the first source change and
at every retain.

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
| intermediate candidate, before the stagger | `ergodis-private` | `356fce6` | `93e12cf` | no | `closure_ballpark-356fce6` | `7fcc12c1c1afb515b66ad24580c230413ffa239b11f4dc8768e82d0a4727affa` |
| intermediate candidate, frontend and backend, before the stagger | `ergodis-private` | `356fce6` | `93e12cf` | no | `ergodis-tools-356fce6` | `e02bf69b4f930f452cc8f05fb57769a791be4362f0a9bba1fd69d4358e3b642c` |
| candidate the frontend, backend, Soufflé, reach, boundary, cold-start and profile figures were taken on; carries `RESET_FILL_BYTES_PER_ROW` at 32, two core commits before the shipped arm | `ergodis-private` | `6078142` | `271d648` | no | `closure_ballpark-6078142` / `ergodis-tools-6078142` | `d4dc07ad565404a70efeb8eb905f64f39a5847f032a30c36f47588b6344c303a` / `78f0420cf5ab8f8bd277f09e0bd3e99990d370eb6c071eba8da47756185fad79` |
| **shipped candidate, and the control the next A/B should use** | `ergodis-private` | `ed99963` | `2be1e68` | no | `closure_ballpark-ed99963` / `ergodis-tools-ed99963` | `97a59d7a5c86dacab107dce7e8fa3e931adacf755d9e58e79b50eadb64268786` / `ce90b5af67b00eec1dfe64dece3fd656d4cc00415f5f6541a4679137cf7a451e` |

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

**Two candidate arms carry the figures, and the sections below name which.** The derivation-loop and
memory-cohort A/Bs are on the shipped arm `ed99963`; the supplementary cache A/B and the stagger
probe are on `6078142`, which is what their receipts record. The frontend and backend run, the
Soufflé comparison, the reach, boundary and cold-start tables and both `perf` profiles are on
`6078142`, retained before `ca64c34` (the reset assertion, test-only) and `2be1e68` (the fill boundary
from 32 to 64). The boundary change moves nothing on any cohort except the four it binds on, where it
was measured in isolation: peak resident set within 60 KiB, and instructions 0.986 on `closure` at
`blocks` and N = 65,536, so the Soufflé rows at that size are about 1.4 per cent above the shipped
arm in instructions and the other figures transfer unchanged.

**No foreign uncommitted file was present in either repository at any point.** `git status` was clean
in `ergodis`, `ergodis-private` and `othello` before the first source change, at each retain, and at
task close.

**One arm was added after the fact, by C1200, and it is the one that isolates the stagger.**
`~/.cache/ergodis/bin/c1198-stagger-probe`, measured sha256
`b4bf4c4514a5f0a93032bd89c21b85b9ee52a927c4bac30f6d7cca479f609a09`, is private `356fce6` with the
core at `271d648` — that is, the arm before the stagger with the stagger commit applied and nothing
else, which is the comparison this report needed and did not build. It was built from two detached
worktrees under `~/.cache/ergodis/worktrees/c1200-stagger/` and carries no manifest row, as the two
probes below do not. C1200 also checked that the worktree build path does not move the compiled
kernel: the same worktree pair at core `93e12cf` rebuilds `closure_ballpark-356fce6`'s
`Demand::evaluate_into` with an identical opcode histogram at 7,741 instructions.

**Two core commits were added after this task closed**, by the C1200 repair pass: core `e7116ba`
(the workspace records its program's domain, and the two missing gates) with private `aa04358`
re-pinning it, retained as `closure_ballpark-aa04358`, measured sha256
`a29f36177039ddc372de9b49fad5de2994063167ef9c4306e05a428ac55bfbcf`. That repair is not free: it
recompiles the kernel from 7,701 to 7,788 instructions and costs 0.67 to 0.85 per cent of the
derivation loop's instructions on the six direct-path cohorts
(`analysis/datalog-comparison/ab-2026-09-17-c1200-direct-repairs.json`). **The control for the next
A/B in this lane is therefore `closure_ballpark-aa04358` and not `closure_ballpark-ed99963`.**

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `9dd61b7` | this report's skeleton and the Fermi predictions, written before any code |
| `ergodis` | `3eaaacf` | `pages::Pages`, the zero sentinel, the high-water reset, the reservation-counting allocation regression and `workspace_commit.rs` |
| `ergodis` | `93e12cf` | the counting sort's cursor is the offsets array rather than a second copy of it |
| `ergodis` | `271d648` | each reservation staggered by a cache line, against 4 KiB aliasing |
| `ergodis` | `ca64c34` | the reset asserted directly, on a program whose chain indexes are walked |
| `ergodis` | `2be1e68` | the reset's fill boundary set from the measurement |
| `ergodis-private` | `b3994fc` | re-pin the core, so the candidate arm has a private revision to name it |
| `ergodis-private` | `356fce6` | the lockfile entry for the target-gated `libc` |
| `ergodis-private` | `b5f10e7` | `closure_ballpark --cold`, and the reservation and commit figures beside it |
| `ergodis-private` | `6078142` | the A/B receipts taken before the stagger, with the cache and TLB runs that ruled out a memory-hierarchy cause |
| `ergodis-private` | `6f898b8` | the receipts on the shipped arm: the derivation loop, the memory cohorts, the cache run, the frontend and backend, and Soufflé at both row bounds |
| `ergodis-private` | `2d368a3` | re-pin the core at the direct reset assertion |
| `ergodis-private` | `ed99963` | re-pin the core at the measured reset boundary |
| `ergodis-private` | `1f2fe44` | the receipts at the measured reset boundary |
| `othello` | `9dd61b7` onward | this report, written incrementally from before the first line of code and committed at every milestone |
| `ergodis` | `e7116ba` | **C1200**: the domain is part of the workspace shape, and the two gates the C1199 audit found missing |
| `ergodis-private` | `aa04358` | **C1200**: re-pin the core at the repairs |
| `ergodis-private` | `193ebd1` | **C1200**: the stagger commit isolated, and the repairs A/B against the shipped arm |

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
4. **Each reservation's contents start at a rotating cache-line offset.** This was not in the plan.
   The commit that introduced it does repair a 9 per cent cycle regression the first three created —
   `ergodis` `271d648` is worth 0.913 of the cycles of `closure` dense at N = 256 and N = 512 — but
   the offset it computes is not what does the repairing, and the mechanism this report first gave
   is not established. Mystery ledger item 2 carries the corrected account.

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
a `Drop` that unmaps, and no interior pointer handed out.

**One of those notes claimed more than the code provides, and it now says what it means.**
`Pages::zeroed`'s comment asserted that `reserve` returns storage "aligned to at least a cache
line". The Unix backing does — `mmap` returns page-aligned memory — but the portable backing is
handed `align_of::<T>()` and returns exactly that. There is no bug either way, because the stagger
is a multiple of sixty-four and sixty-four is a multiple of both element alignments, so the offset
pointer is aligned for `T` on both paths. The comment (`ergodis` `e7116ba`) now states what each
backing provides and draws the conclusion from the premise that holds. The alternative repair,
passing 64 to `reserve` on both paths, was rejected: it would change the portable backing's `Layout`
— the shape this change is measured against, and the shape the reservation is released with — to
buy an alignment nothing needs. WebAssembly and any non-Unix target build
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
is the rule and it ships at 64: a fill is admitted only where the table costs at most sixty-four bytes
per row of the previous evaluation. It was first set at 32 by reasoning — a little more than the
twenty-eight bytes of tuple and witness columns a derived row already commits, so a fill could never
be the term that decides a workspace's resident set — and then measured against 64 on the cohorts
that sit near the boundary; 64 takes up to ten per cent off their instructions for no measurable
memory, because a table within a small factor of its rows already has most of its pages committed by
those rows. The measurement is under **The reset's fill boundary, measured** and the reasoning that
made it necessary is mystery ledger item 5.

The rule reads the **rows the last evaluation wrote**, not the capacity, and that is the whole point:
at the default row bound the capacity is 2^24 whatever the program derives. A fresh workspace's row
count is zero, so the first evaluation's reset touches nothing at all.

Three details make the walk exact. It runs **before** any relation's row count is reset, because the
rows it reads are the previous evaluation's. Clearing a whole bitmap word rather than one bit is
exact, because every bit set in that word was set by a row the same walk visits. And the walk is
exact **given the same domain**, which is the premise it needs and the one this task originally left
unenforced: the walk recomputes each row's key with the current plan's domain, so a workspace handed
between two same-shape programs over different domains would be cleared at the wrong slots. The
C1199 audit found that `shape()` compared the row bound, the counts and every capacity and not the
domain, and measured the consequence on pristine shipped code — a chain closure over domain 4,096,
a matching closure over 2,048, then the first again into one workspace, and the third evaluation
does not terminate. `DemandWorkspace` now records the domain and **`shape()` enforces it**
(`ergodis` `e7116ba`), so that case is an ordinary `Error::Source` refusal and the premise is
checked rather than assumed.

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
`analysis/datalog-comparison/ab-2026-09-16-c1198-prestagger-direct-b7921a0.json` with its raw
sidecar; the same A/B against `closure_ballpark-c3eda9a` is
`ab-2026-09-16-c1198-prestagger-direct.json`. These are the six cohorts C1192 used to show that its direct path
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
looking for a mechanism. The candidate it settled on — 4 KiB aliasing between page-aligned
mappings — is the one part of this report that did not survive its audit; mystery ledger item 2
carries the counters that ruled out the alternatives, the measurement that rules this one out too,
and what is left open.

**The isolation this section first reported was the wrong comparison, and the corrected one is
below.** The first attempt compared a probe built from the `6078142` tree with the stagger
multiplied out (`~/.cache/ergodis/bin/c1198-nostagger-probe`, measured sha256
`551ae2e657adfe7d551e6a654c723f0c3016a9c0c921bf5487be5e3dc787a9d9`, a scratch build from a tree
dirty in exactly that one line) against **`6078142`**, not against the arm before the stagger. Both
of those binaries are already past the regression, so the comparison could not see it; and its own
intervals say as much. Receipt `~/.cache/ergodis/c1198/ab-stagger-probe.json`, five interleaved
rounds, CPU 5, 120 measurements, load 3.98 to 4.30:

| Cohort | instruction ratio | A/A null | cycle ratio [lo, hi] | cycle null |
| --- | ---: | ---: | ---: | ---: |
| `closure` dense 256 | **1.00000** [0.99999, 1.00000] | 1.0000023 | 0.6972 **[0.2678, 1.8153]** | 0.9915 |
| `closure` dense 512 | **1.00000** [1.00000, 1.00000] | 1.0000003 | 0.9228 [0.6937, 1.2275] | 0.8456 |
| `samegen` dense 512 | **1.00000** [1.00000, 1.00000] | 0.9999994 | 1.0052 [0.9884, 1.0223] | 0.9737 |
| `closure` blocks 4,096 | **1.00000** [0.99996, 1.00003] | 0.9999939 | 0.9986 [0.9712, 1.0268] | 0.9924 |

**The instruction column is sound and the cycle column settles nothing.** The rotating offset
changes the derivation loop's instruction count by nothing at all, to five decimal places on four
cohorts, which is what a change that runs once per reservation at construction should do. The 0.6972
on `closure` dense at N = 256 was quoted in an earlier revision of this report as "30 per cent off
the cycles"; **its own 95 per cent interval is [0.2678, 1.8153], which contains unity**, and the
companion dense-512 row's cycle A/A null of 0.8456 makes that row unreadable by this report's own
rule. Neither dense cohort supplies readable cycle evidence here. The C1199 audit reran the same
pair on a quiet box and measured the rotating offset's effect at **0.996 [0.978, 1.014]** on dense
256 and **0.996 [0.984, 1.008]** on dense 512, both intervals containing unity.

**The comparison that does isolate the stagger is C1200's, and it changes the conclusion.**
`c1198-stagger-probe` is private `356fce6` with core `271d648` — the pre-stagger arm with the
stagger commit applied and nothing else — measured against `closure_ballpark-356fce6`, five
interleaved rounds, CPU 5, 60 measurements at 100.00 per cent enabled, load 1.27 to 1.44. Receipt
`analysis/datalog-comparison/ab-2026-09-17-c1200-stagger-isolated.json`.

| Cohort | instruction ratio [lo, hi] | A/A null | cycle ratio [lo, hi] | cycle A/A null |
| --- | ---: | ---: | ---: | ---: |
| `closure` dense 256 | **0.99167** [0.99167, 0.99168] | 1.0000013 | **0.91303** [0.88841, 0.93832] | 1.00097 |
| `closure` dense 512 | **0.99160** [0.99160, 0.99160] | 1.0000008 | **0.91306** [0.90502, 0.92116] | 1.00142 |

**The stagger commit removes the regression** — 8.7 per cent of the cycles of both dense-closure
cohorts, against cycle A/A nulls inside 0.15 per cent of unity, so both rows are readable — **and
the rotating offset is not what removes it.** `c1198-nostagger-probe`, whose offset is multiplied
out to zero, measured against the same `356fce6` control gives the same answer: cycles 0.90617
[0.87774, 0.93551] and 0.90422 [0.89360, 0.91496] with nulls of 0.9988 and 0.9986, and instructions
0.99167 and 0.99160 to five decimal places. What the two probes share is the compiled body, not the
offset; the mechanism is in mystery ledger item 2.

**And the other 0.8 per cent of instructions is the stagger commit's too, not the harness's.** The
two candidate arms differ by the stagger commit *and* by `closure_ballpark`'s `--cold` mode, and an
earlier revision of this report attributed the move from 0.990 to 0.983 to the untimed driver mode
through ThinLTO. The arithmetic says otherwise: 0.98335 / 0.99161 is **0.99167**, which is exactly
what the stagger commit measures against `356fce6` on a probe that contains no driver edit at all.
The `--cold` mode contributes 1.00000. Mystery ledger item 3 carries the corrected attribution.

### The cohorts the reservation was costing, at the default row bound

Control `closure_ballpark-b7921a0` against the shipped candidate `closure_ballpark-ed99963`, five
interleaved rounds, CPU 5, the six-event set at 100.00 per cent over 180 measurements, load 4.31 to
5.98. Receipt `analysis/datalog-comparison/ab-2026-09-17-c1198-memory-final.json`.

| Cohort | derived | instruction ratio | A/A null | cycle ratio | cycle null | peak RSS, control / candidate KiB | factor |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` blocks 4,096 | 65,536 | 0.98501 | 1.0000162 | **0.9885** | 1.0113 | 539,388 / **18,356** | **×29.4** |
| `closure` blocks 16,384 | 262,144 | 0.99970 | 0.9999975 | 0.7186 | 0.8606 | 599,896 / **83,892** | **×7.2** |
| `closure` blocks 65,536 | 1,048,576 | 1.01659 | 0.9999938 | 0.7622 | 0.9435 | 817,064 / **264,380** | **×3.1** |
| `mutual` blocks 4,096 | 61,440 | 0.97546 | 1.0000734 | 0.8766 | 0.9182 | 539,400 / **82,896** | **×6.5** |
| `mutual` blocks 8,192 | 122,880 | 1.06050 | 1.0000642 | **0.9902** | 1.0165 | 493,276 / **37,908** | **×13.0** |
| `cycle` blocks 4,096 | 131,072 | 0.99055 | 1.0000064 | **0.8179** | 1.0213 | 1,131,304 / **38,260** | **×29.6** |

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
| `mutual` blocks 4,096 | **0.90318** | 1.0001341 | 0.9882 | 82,908 / 82,852 |
| `closure` blocks 65,536 | **0.98569** | 1.0000024 | 0.9833 | 264,396 / 264,368 |
| `mutual` blocks 8,192 | 0.99998 | 0.9999766 | 0.9216 | 37,920 / 37,888 |
| `closure` blocks 16,384 | 1.00001 | 1.0000012 | 1.0016 | 83,908 / 83,880 |

**Sixty-four is strictly better on the cohorts where it binds and costs nothing in memory**, so it is
what ships. The two cohorts that cross the boundary take 0.903 and 0.986 of the instructions and
their peak resident sets move by 56 and 28 KiB — that is, by nothing. The reason the fill is free
there is worth stating because it is not obvious: **a table whose bytes are within a small factor of
its rows has already had most of its pages committed by those rows**, so the fill writes pages that
are resident either way. The two structures four and sixteen times out walk under both values and do
not move, which is the control this comparison needs.

### Cache events on the cohorts the stagger commit repaired

Supplementary run on candidate `closure_ballpark-6078142` against control `closure_ballpark-b7921a0`,
the playbook's cache set with its own nulls: five interleaved rounds, CPU 5, `--evaluate-only`,
100.00 per cent enabled, load 3.17 to 3.39. Receipt
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
supplies for the mystery ledger: after the stagger commit, nothing about the loop's memory behaviour
differs from the control. That was read at the time as confirmation that the change only moved where
the tables sit; the measurements in mystery ledger item 2 say the change also moved what the loop is
compiled to, and this table does not distinguish the two.

### Reach and resident set at the default row bound

Every row is the candidate arm `closure_ballpark-6078142` in `--evaluate-only` mode under
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

`closure_ballpark --cold` on the candidate arm `closure_ballpark-6078142`, `cycle` at the `blocks` density and N = 4,096, pinned
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

The candidate arm `closure_ballpark-6078142` against Soufflé 2.5 (32-bit word, from the nix store at
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
| control `closure_ballpark-b7921a0`, from `cycle-faults.data` | `__memset_avx512_unaligned_erms` **98.45 %**, nothing else above 0.5 % |
| candidate `closure_ballpark-356fce6`, from `cycle-faults-candidate.data` | `Demand::index_rows` 53.16 %, `Demand::evaluate_into` 18.99 %, `Map::fold` 7.59 %, `hashbrown::RawTable::reserve_rehash` 5.06 %, `__memmove_avx512_unaligned_erms` 3.80 %, `_int_malloc` 2.53 %, `__memset_avx512_unaligned_erms` **1.27 %**, `main` 1.27 %, `push_decimal` 1.27 %, `datalog::admit` 1.27 %, `ergodis_verify::rule_contract::parse_rules::atom` 1.27 %, `serde_json::ser::format_escaped_str` 1.27 % |

The candidate row is `356fce6` and an earlier revision of this report labelled it `6078142`: the
`perf` header of `~/.cache/ergodis/perf-c1198/cycle-faults-candidate.data` records the command as
`closure_ballpark-356fce6`, which is the arm the percentages above are faithful to. The conclusion
is unaffected, because `356fce6` already carries all three deliverables and the table is about where
the faults come from. The last two symbols are the twelve-symbol listing completed: an earlier
revision printed ten of the twelve above the one-per-cent cut.

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

| Symbol | control `b7921a0` | candidate `6078142` |
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

**The derivation loop's compiled body differs between `closure_ballpark-6078142` and the shipped
arm in exactly the constant that moved.** The core moved twice after `6078142` was retained.
`ca64c34` adds the reset assertion and its test program and changes no other code; a release rebuild
at that revision differs from the retained binary in 236,456 bytes of symbol layout while
`Demand::evaluate_into` disassembles to the same **7,701** instructions, line for line. `2be1e68`
sets `RESET_FILL_BYTES_PER_ROW` from 32 to 64, and the reset rule is inlined into `evaluate_into`:
on the shipped arm `closure_ballpark-ed99963` the function is again 7,701 instructions and the
disassembly differs in **three instructions, each a `shl $0x5` that became `shl $0x6`** (the
`32 × rows` product), with every other instruction identical. (7,701 by `objdump -d
--no-show-raw-insn`; an earlier revision of this report said 7,702, a counting convention rather
than a different body.) The direct-path and memory-cohort A/Bs were taken on the shipped arm and the
cache A/B on `6078142`; the figures taken on `6078142` describe a kernel that differs from the
shipped one only in that multiplier, whose effect is measured under **The reset's fill boundary,
measured**.

**The core has moved once more since, and that move does change the kernel.** `e7116ba` adds the
domain to the workspace's shape, and `Demand::evaluate_into` recompiles from 7,701 instructions to
**7,788** with the body rewritten, at a measured cost of 0.67 to 0.85 per cent of the derivation
loop's instructions on the six direct-path cohorts. The comparison itself runs once per evaluation
and cannot be that; the measured difference on `closure` sparse at N = 256 is 255,531 instructions
per evaluation over 62,979 derived tuples, four per row. See the C1200 report and mystery ledger
item 11.

## Exactness

| Gate | Outcome |
| --- | --- |
| Core `cargo test --all-features` at `ca64c34`, at the shipped `2be1e68` (2026-09-17, review pass), and at C1200's `e7116ba` | **81 test binaries, zero failures** all three times, including the `workspace_commit` suite, the two in-module reset tests, and the `pages` reservation tests |
| **The domain is part of the shape** (C1200, `e7116ba`) | `a_same_shape_program_over_a_different_domain_is_refused_rather_than_evaluated`: a plan over domain 2,048 is refused with `Error::Source` on a workspace reserved over 4,096, the two plans reserve identical workspace bytes, and the refusal leaves the first plan's own evaluation unchanged. With the comparison removed it fails by name in 0.38 s; before the repair the same sequence did not terminate, past a 60-second cap |
| **The fill-versus-walk rule is bound by a test** (C1200, `e7116ba`) | `a_bucket_head_large_against_its_rows_is_never_returned_to_empty_by_a_fill`, on a cohort whose bucket head is 2^24 slots over 209 rows: the shipped rule commits **180,224 bytes** on the first evaluation and **zero** on the second, the inverted rule commits **71,409,664**, and the threshold is a quarter of the head. Inverting the rule passed every test in the crate before this |
| **The stagger offset in `Drop` is bound by a test** (C1200, `e7116ba`) | `a_dropped_reservation_releases_the_whole_mapping_and_not_the_staggered_slice`: 200 reservations of 256 MiB move `VmSize` by **0 KiB** on the shipped `Drop` and by **55,980,192 KiB** when `Drop` releases `ptr` rather than `base`. That mutation passed every test in the crate before this, and it leaks because `munmap` on an address that is not page aligned fails with `EINVAL` |
| Private `cargo test -p ergodis-private -p ergodis-tools` at `ed99963` | **42 test binaries, zero failures**, the same count C1192 recorded; this drives `rel_lowering`, `rel_frontend`, `rel_frontend_portability` and `rel_reference_eval` |
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

## What the Fermi got right and wrong

| Prediction | Measured | Verdict |
| --- | --- | --- |
| 0. The commit is `calloc`, not the `fill(NONE)`; deliverable 3 carries nearly all of the result | 98.45 per cent of the control's faults in `memset`, and a cohort with no `fill(NONE)` at all still fully committed | **Right**, and it reverses the card |
| 1. Preparation at the default bound falls by 15 to 40 times, to 3 to 8 ms, landing at or below C1192's sized-bound 21.3 ms | 123.2 ms → **14.8 ms**, a factor of 8.3, below the sized bound as predicted but above the predicted band | **Direction right, size wrong**: the band priced only the faults and forgot that preparation also admits 61,440 facts, which is most of the 14.8 ms |
| 2. `cycle` at N = 4,096 lands between 15,000 and 40,000 KiB at the default bound, within a small factor of the sized bound | **38,260 KiB** against 22,352 sized, a factor of 1.7 | **Right**, at the top of the band |
| 3. +0.5 to +1.5 per cent instructions on chain cohorts, unity elsewhere | **−1.6 to −1.8 per cent everywhere**, and the memory cohorts are −2.5 to +6.1 | **Wrong in sign**: the unbias does cost an instruction per yielded row, and the `fill(NONE)` it replaced cost more |
| 3b. The reset walk must be conditional or it regresses the direct-path cohorts | It is conditional, and the constant is load bearing on five structures | **Right**, and the constant then had to be measured rather than reasoned |
| 4. The default-bound Soufflé column matches the sized column on all three sizes, at 0.80 to 1.00, 0.75 to 0.90 and 0.90 to 1.00 | **0.852, 0.819, 1.172** | **Right on two of three**; the largest size does not converge, and the reason is locality rather than commit |
| 5a. The reset walk's exactness is the first risk | It was: the gate that catches a wrong reset had to be rewritten after the first one did not discriminate | **Right** |
| 5b. `MADV_HUGEPAGE` fights the whole point and will be measured off | 60 to 77 per cent more resident memory, evaluation inside the noise, shipped off | **Right** |
| 5c. The WebAssembly fallback must be a compiled path | It is, and it is checked by an explicit `wasm32-unknown-unknown` build | **Right** |

The one prediction that was wrong in sign is the interesting one, and the cost model behind it was
wrong in the way the playbook warns about: it priced the instruction the unbias adds to a chain step
and did not price the `fill(NONE)` the zero sentinel removes from every evaluation, which is the
larger term on every cohort measured.

## Disposition

**Kept**, by the forward commits in the table above; nothing is reverted. Four changes, measured:

1. **The lazily committed workspace** (`ergodis` `3eaaacf`): peak resident set falls by a factor of
   3.1 to 29.6 at the default row bound on the memory cohorts, by 1.7 to 2.3 on three of the four
   C1191 boundary cohorts, and by 3.7 on the Rel route's `datalog` cohort; the derivation loop is
   1.6 to 1.8 per cent cheaper in instructions on the six cohorts where nothing about the tables
   changed.
2. **The counting sort's cursor** (`ergodis` `93e12cf`): `mutual` at the `blocks` density and
   N = 4,096 went from 144,616 KiB to 82,804.
3. **The cache-line stagger commit** (`ergodis` `271d648`): **0.913 of the cycles** of `closure`
   dense at N = 256 and N = 512 against the arm before it, with cycle A/A nulls inside 0.15 per cent
   of unity, and 0.99167 and 0.99160 of the instructions. It is what makes the change a wall-time
   win rather than a wall-time loss on the dense cohorts. **What does the repairing is not the
   rotating offset**: a probe whose offset is multiplied out to zero gives the same 0.906 and 0.904
   against the same control. An earlier revision of this report credited the offset with "30 per
   cent off the cycles", from a point estimate of 0.6972 whose own interval is [0.2678, 1.8153];
   the offset's measured effect is 0.996 [0.978, 1.014] and 0.996 [0.984, 1.008], both containing
   unity. Mystery ledger item 2.
4. **The direct reset assertion** (`ergodis` `ca64c34`): no measured effect, and the derivation
   loop's disassembly is unchanged; it is the gate that makes the first change's correctness
   checkable in milliseconds instead of by a hang.

**One variant was measured and rejected**: `MADV_HUGEPAGE` on every reservation of two mebibytes or
more, which costs 60 to 77 per cent more resident memory on the cohorts this task exists for and
moves evaluation inside the noise. `Pages::advise_huge` remains as a capability with no caller.

## Recorded deviations

1. **The reservations are staggered by a cache line**, which the card did not ask for and which no
   part of the design anticipated. The commit is a repair for a 9 per cent cycle regression the
   first three deliverables created, and without it the change is a memory win and a wall-time loss
   on the dense cohorts, so it is not optional: `ergodis` `271d648` measures 0.913 of the cycles of
   `closure` dense at N = 256 and at N = 512 against the arm before it, with readable nulls
   (`analysis/datalog-comparison/ab-2026-09-17-c1200-stagger-isolated.json`). **The mechanism this
   report first gave for it is wrong.** The rotating offset is not what repairs the regression — a
   probe with the offset multiplied out to zero repairs it just as completely — so the 4 KiB
   aliasing story is an explanation the measurement does not support. What the two probes share is
   the compiled body. Mystery ledger item 2 carries the corrected account and the open part.
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
   table costs at most **sixty-four** bytes per row the previous evaluation wrote — the shipped
   value, measured against 32 under **The reset's fill boundary, measured** — so it can never commit
   materially more than the row store already has. The card's intent, that the reset must not be
   sized from the caller's bound, holds exactly, because the rule reads the rows and not the
   capacity. The constant's own doc comment states the structure count the measurement found: seven
   structures between a quarter and eight times the shipped boundary, five of them within a factor
   of two of it, which is the same table as the one under **The reset's fill boundary, measured**
   read against 64 rather than 32.
8. **Deliverable 4 is unchanged code.** "Capacity from the program where a bound exists" already
   described the evaluator: an input relation's capacity is its fact count and a derived relation's
   is `min(domain^arity, row_bound)`. The per-column domain product needs the C1191 closing pass,
   which does not exist. Nothing was written for item 4, and what it would still buy is recorded
   under **Remaining gaps**.

## Remaining gaps

1. **The checkers now cost more memory than the evaluator, by a factor of up to eight, and they have
   the same defect this task just fixed.** On `closure` at the `blocks` density and N = 4,096 the
   whole Ergodis process peaks at **17,892 KiB** and the derivation checker alone peaks at
   **138,928 KiB**; at N = 65,536 the warm pass peaks at 656,496 KiB against the evaluator's 271,800.
   `crates/verify/src/datalog_store.rs` allocates `vec![0u32; domain^arity]` and
   `vec![0u64; domain^arity / 64]` per relation, which is the same `calloc` that commits every page
   before a tuple exists. It already uses zero as its absent sentinel — it is where this task's
   deliverable 1 came from — so all it needs is the reservation. **What blocks it is a binding, not a
   measurement**: `ergodis_verify::implementation_identity()` hashes the checker source files by
   name, so adding a module there moves a digest that certificates bind to. *Owner*: a successor with
   permission to move that digest, or to place `Pages` where both crates can reach it without
   entering the identity. This is the largest single memory term the lane now has.
2. **A hash table sized from the caller's bound still costs locality even when it costs no memory.**
   At N = 65,536 the Soufflé ratio is 1.172 at the default row bound against 0.963 with the bound
   sized, and the phase table puts 157 ms of it in preparation and 216 ms in evaluation. The
   membership table there is sparse with 2^24 slots at the default bound and 2^21 at the sized one,
   and a million rows scattered over sixteen million slots miss more than a million scattered over
   two million. Lazy commit removes the memory cost of an over-declared bound and not the cost of
   hashing into a table sized from it. **The two smaller sizes are now identical under both bounds,
   phase for phase**, so this is confined to the case where the table is large in absolute terms.
3. **The reset walk recomputes each row's key, and it does not have to.** `mutual` at N = 8,192 pays
   6.1 per cent of its instructions for a reset that walks 122,880 rows and recomputes `key_of` for
   each. The insertion path already loads the bucket head it is about to overwrite, so a slot that
   was zero is a *newly touched* slot and could be appended to a compact list at no extra load; the
   reset would then be a walk over touched slots with no key recomputation and no row read at all.
   It costs one presized column per structure — free under lazy reservation — and a predicted branch
   per insertion. **Not built**: it is a hot-loop change and needs its own A/B, and the cost it
   removes is 6 per cent of one cohort. *Owner*: whoever takes the next derivation-loop task.
4. **Deliverable 4's capacity-from-the-program is still `min(domain^arity, row_bound)`.** The
   per-column domain product needs the C1191 closing pass, which does not exist. This no longer costs
   memory, but it still decides the row-capacity refusal: `closure` sparse at N = 8,192 and `samegen`
   sparse at N = 16,384 are refused by `MAX_ROWS` exactly as C1192 recorded. The alternative the card
   asked to be named if this gap remained is **a resumable mid-round budget exit** — a round that
   exhausts the row capacity returning a resumable state rather than `Error::Budget` — and it is
   named here and not built.
5. **A page read before it is written costs two minor faults and commits on the second.** The cold
   stage takes 11,291.7 faults per iteration for 6,128 committed pages, and the extra 5,164 are reads
   of the shared zero page, measured directly. `MADV_POPULATE_WRITE` over the pages a plan can
   predict, or writing before reading on the bucket-head path, would remove them. Nothing here turns
   on it; it is the first thing to look at for a faster cold start.
6. **`MAX_WORKSPACE_BYTES` now bounds something much cheaper than it used to.** It is `2^34` and it
   bounds a reservation that costs one `mmap` per table. What a caller actually risks is the commit,
   and nothing bounds that. A commit ceiling would be a different mechanism — a budget checked as
   pages are touched — and is not designed here.
7. **The stagger costs up to one page per table of address space and that is not in
   `workspace_bytes()`.** The figure `MAX_WORKSPACE_BYTES` checks is the logical length; the actual
   reservation is that plus at most 4,032 bytes per table. On any plan the ceiling can refuse, the
   difference is far below the ceiling's own granularity, but the two numbers are not the same number
   and the code says so in one place and not the other.
8. **Nothing here measures a parallel workspace.** `Pages` is `Send` and `Sync` where `T` is, and
   worker workspaces are per worker, so nothing about the change is shared; but no parallel A/B was
   run, because the demand evaluator has no parallel mode to run one in.

## Mystery ledger

1. **Settled, and it corrects the card's stated mechanism before any code was written: the eager
   commit was `calloc`, not the `fill(NONE)`.** The card says "zero-filled `calloc` pages are already
   committed lazily by the kernel; the explicit `NONE` fill and the eager sizing are what defeat
   that." Three probes on the retained control say otherwise. A 1,145,061,376-byte workspace took
   283,893 page faults and a 1,131,196 KiB resident set, and **98.45 per cent of those faults are
   attributed to `__memset_avx512_unaligned_erms`**. `mutual`, which has no dynamic join index and
   therefore executes no `fill(NONE)` on any bucket head at all, still committed 539,380 KiB against
   a 460,800 KiB reservation. Pinning `MALLOC_MMAP_THRESHOLD_` changed nothing. glibc's `calloc`
   skips its `memset` only for a chunk it mapped itself, and by the time the workspace is built the
   arena's top chunk satisfies 64 MiB and 128 MiB requests without mapping. Fermi prediction 0 said
   deliverable 3 would carry nearly all of the result and that deliverables 1 and 2 alone would move
   peak resident set by under ten per cent; the measurement agrees, and the ordering in the card is
   reversed. *Nothing about this item is open.*

2. **Reopened by the C1199 audit and half settled by C1200: the stagger commit repairs the 9 per
   cent cycle regression, the rotating offset does not, and the mechanism is not what this report
   first said.** The regression is real. Moving the workspace off the heap made `closure` dense at
   N = 256 and N = 512 **9 per cent slower in cycles while executing 0.8 per cent fewer
   instructions**, against cycle A/A nulls of 1.0019 and 0.9999 that make both rows readable, and
   C1199 reproduced it at 1.087 [1.070, 1.105] and 1.092 [1.081, 1.103] against the C1192 control.

   *What was eliminated, and holds.* The supplementary cache run put `L1-dcache-loads` at 1.019 to
   **1.028** — the three cohorts are 1.01924, 1.02401 and 1.02837 — and `L1-dcache-load-misses` at
   0.908 to 0.989, with nulls inside **five** parts per thousand (the largest is 1.0050582), so more
   loads and no more misses; and a TLB run put `ls_l1_d_tlb_miss.all` at 1.014 to 1.086 on absolute
   counts of three thousand to four hundred thousand per evaluation, far too small to buy 9 per cent
   of cycles.

   *What this report concluded from that, and what is wrong with it.* The conclusion was the
   load-store unit: every anonymous mapping starts on a page boundary, so a row column and a
   membership table have identical low twelve address bits at the same row index, and a load whose
   page offset matches a pending store's is held for a false dependency even when the two addresses
   are megabytes apart. The isolating A/B offered for it compared a probe with the offset multiplied
   out against `6078142` — two binaries that are **both already past the regression** — and reported
   0.697 of the cycles on `closure` dense at N = 256 from a point estimate whose own interval is
   [0.2678, 1.8153] beside a companion row with a cycle null of 0.8456. That comparison supplies no
   readable cycle evidence on either dense cohort, and C1199's rerun of it puts the offset's effect
   at 0.996 [0.978, 1.014] and 0.996 [0.984, 1.008].

   *What C1200 measured instead.* `c1198-stagger-probe` is the pre-stagger arm with the stagger
   commit applied and nothing else. Against `closure_ballpark-356fce6` it is **0.91303 [0.88841,
   0.93832]** and **0.91306 [0.90502, 0.92116]** in cycles with nulls of 1.00097 and 1.00142, and
   0.99167 and 0.99160 in instructions. So the commit is the repair. But `c1198-nostagger-probe`,
   whose offset is multiplied out to zero, measured against the **same** control gives 0.90617 and
   0.90422 in cycles and the same 0.99167 and 0.99160 in instructions — so the offset is not what
   repairs it. What the two probes share is the compiled body: `Demand::evaluate_into` is 7,741
   instructions without the stagger commit and 7,701 with it, and the stagger probe, the no-stagger
   probe and `6078142` have identical opcode histograms.

   *And the counter that would show the stated mechanism exists and runs against it.* An earlier
   revision of this item said "the counter that would show it is not in the playbook's supplementary
   set". It is on this PMU: `ls_bad_status2.stli_other` (store-to-load-forward conflicts) and
   `ls_stlf` (successful forwards), both AMD Zen core events, both at 100.00 per cent enabled. On
   both probe pairs against `356fce6`, `ls_stlf` moves by at most 1.2 per cent; the conflict counter
   is unreadable on three of four rows, and on `closure` dense 512 the **faster** arm carries 1.39
   and 2.53 times as many conflicts, on absolute counts of 1.35 × 10^5 to 1.54 × 10^6 against
   6.8 × 10^7 to 5.8 × 10^8 cycles. Receipts
   `analysis/datalog-comparison/ab-2026-09-17-c1200-stlf-{stagger,nostagger}.json`.

   *Open*: why a source change to a module the derivation loop never calls recompiles that loop into
   a body that is 0.8 per cent cheaper in instructions and 9 per cent cheaper in cycles. *Evidence
   gap*: the instruction-level account of the two bodies — the histograms differ, so the difference
   is not scheduling alone — and a kernel-scoped `perf annotate` of both arms on `closure` dense at
   N = 256 bucketed into named address ranges, which would say where the cycles went. *Settled*: the
   commit is the repair, the offset is not the mechanism, and the offset is kept on its zero-cost
   merits rather than on a benefit.

3. **Withdrawn and replaced by C1200: the 0.8 per cent of instructions is the stagger commit's, not
   the untimed harness mode's.** An earlier revision of this item read the move in the derivation
   loop's instruction ratio from 0.990 to 0.983 as C1170's lesson repeating — a driver-only edit
   moving an untouched kernel through ThinLTO's module summary — because the stagger probe showed
   1.00000 on four cohorts and the two candidate arms differ by the stagger *and* by
   `closure_ballpark --cold`. **The probe that showed 1.00000 compares two binaries that both carry
   the stagger commit**, so it could only ever have shown the rotating offset's contribution, which
   is indeed nothing. Measured directly on a probe with the stagger commit and no driver edit, the
   commit is worth **0.99167 and 0.99160** of the instructions on the two dense cohorts; and
   0.98335 / 0.99161, the two arms' own ratios against the same control in this report, is 0.99167.
   The `--cold` mode therefore contributes 1.00000 and the lesson this item drew does not apply
   here. *Nothing about the attribution is open; what is open is item 2's mechanism, which is the
   same question.*

4. **Settled the hard way, and it is a warning about what a corpus can see: the test that had to
   exist could not be an integration test.** Deleting the join indexes' reset passed every test in
   `workspace_commit.rs` and then made `allocation.rs` spin for nine minutes without terminating. Two
   structural reasons, both worth carrying. A stale bucket head holds the previous evaluation's last
   row for a slot, so reinserting that row makes `next[row]` point at the row itself and the chain is
   self-referential: the symptom of a reset that clears too little is **non-termination, never a wrong
   answer**, so a suite that only evaluates twice hangs rather than failing. And a closure program
   never exercises it at all, because its chain index is consulted only by the step whose delta atom
   is the input relation, where `MODE_FULL`'s limit is zero in the first round and the step is
   skipped. The gate that works asserts the tables directly after calling the two reset paths, on a
   same-generation recursion, and fails in milliseconds by name under either mutation. *Nothing about
   this item is open; the lesson is the same shape as C1192's item 4 — a test that hopes for the
   symptom is not a test.*

5. **Settled, and it withdraws a claim this report made in an earlier revision: the reset's fill
   boundary is load bearing, and 32 was the wrong value.** The constant was set by reasoning and the
   code said "every cohort measured sits two or more orders of magnitude from this boundary". Five
   structures sit between 0.5 and 2.1 times 32 and two more at 4 and 16 — that is, seven between a
   quarter and eight times the shipped 64, five of them within a factor of two of it, which is what
   the constant's doc comment now says. Measured at 64 against 32 on
   the four cohorts that bind: **0.903 and 0.986 of the instructions on the two that cross, with peak
   resident set moving by 56 and 28 KiB, which is nothing.** The mechanism is the part worth keeping:
   a table whose bytes are within a small factor of its rows has already had most of its pages
   committed by those rows, so a fill writes pages that are resident either way and the choice is
   purely an instruction-count one there. *Nothing about this item is open.*

6. **Settled, and it is a number that does not divide the way it should: 11,291.7 faults per
   iteration for 6,128 committed pages.** A read of an untouched anonymous page costs a minor fault
   and commits nothing, because the kernel maps the shared zero page; the write that follows costs a
   second fault and commits. Measured directly with a 32 MiB anonymous mapping on this host: a read
   pass over 8,192 pages took **8,196 faults and zero resident kilobytes**, and the write pass that
   followed took **8,192 faults and 32,768 KiB**. The derivation loop reads a bucket head before it
   writes it, so about 5,164 of the faults per iteration are free in memory and not in time. *Nothing
   about this item is open; what to do about it is remaining gap 5.*

7. **Settled, and it is the measured negative the card asked for the opposite of: `MADV_HUGEPAGE`
   loses.** With the hint on every reservation of two mebibytes or more, `cycle` at `blocks` and
   N = 4,096 went from 38,516 KiB resident to 67,992 and `closure` at `blocks` and N = 4,096 from
   18,820 to 30,356 — 60 to 77 per cent more memory — while evaluation moved by −4 to +3 per cent,
   inside the noise of a three-repeat median. A huge page commits two mebibytes on first touch, which
   is the opposite of what a lazily committed workspace is for. *Nothing about this item is open.*

8. **Open, and the first counted evidence now runs against the explanation: the two smaller Soufflé
   sizes converged under the two row bounds and the largest did not.** At N = 4,096 and 16,384 the
   default-bound and sized-bound columns are identical phase for phase; at N = 65,536 the default
   bound still costs 157 ms of preparation and 216 ms of evaluation, and the whole-process ratio is
   1.172 against 0.963. The explanation on offer is locality — a membership table of 2^24 slots
   against 2^21 for the same million rows.

   *The structural half is measured and holds.* The receipts' own addressing blocks put **both** join
   indexes at 65,536 direct slots under **both** bounds, so the sparse membership table at 16,777,216
   slots against 2,097,152 is the only structure whose shape changes between them and there is no
   index confound. *And commit is excluded by arithmetic.* The two arms differ by 19,304 KiB of peak
   resident set, 4,826 pages, which at C1170's measured 734 ns per faulted page is **3.5 ms against a
   373 ms residual**, a factor of 106.

   *The mechanism half is not measured, and the counters point the other way.* C1199 ran the
   playbook's supplementary cache set on `closure:blocks:65536` with one binary under the two bounds,
   three rounds, CPU 5, identical output digest, 1,048,576 rows derived on both arms
   (`~/.cache/ergodis/c1199-audit/ab-locality.json`), sized bound over default bound:

   | Event | default bound, per evaluation | sized bound | ratio | A/A null |
   | --- | ---: | ---: | ---: | ---: |
   | `cache-references` | 1.313e7 | 1.726e7 | **1.3151** [1.2819, 1.3492] | 1.0103 |
   | `cache-misses` | 4.222e6 | 6.401e6 | **1.5160** [1.4895, 1.5429] | 0.9954 |
   | `L1-dcache-loads` | 1.114e9 | 1.203e9 | 1.0795 [1.0768, 1.0822] | 0.9995 |
   | `L1-dcache-load-misses` | 5.911e6 | 8.112e6 | **1.3722** [1.3580, 1.3866] | 1.0000 |

   The **sized** bound — the faster one — issues 32 per cent more cache references, 52 per cent more
   cache misses and 37 per cent more L1 load misses per evaluation, with every A/A null inside one
   per cent. **The caveat that keeps this from being a refutation is real**: `--evaluate-only` reuses
   one warm workspace and its two-point difference measures the steady-state loop, while the phase
   table's 216 ms is one cold evaluation, so the two regimes are not the same measurement. What the
   table removes is the intuition the explanation rested on.

   *Evidence gap*: the same cohort with the table's slot count varied independently of the row bound,
   with cache and TLB counters, which needs a selector the evaluator does not have. A cheaper
   intermediate available today is the cold single-evaluation regime instrumented directly: `perf
   stat` the `--process` arm under both bounds with the cache set, which attributes the 216 ms rather
   than the steady-state loop. It is the same shape as remaining gap 2 and the same owner.

9. **Open, and it is the new largest memory term: the checkers.** The evaluator's whole process is
   17,892 KiB on `closure` blocks at N = 4,096 and the derivation checker peaks at 138,928 KiB — the
   checker is now **7.8 times** the thing it checks. `datalog_store.rs` has the same `calloc`
   behaviour over `domain^arity` entries and already uses zero as its absent sentinel, so the
   remedy is the one this task just built. *Evidence gap*: none on the cause; the blocker is that
   `implementation_identity()` hashes the checker sources, so the fix moves a digest certificates
   bind to. Recorded as remaining gap 1 with that constraint.

10. **Settled, and it is the figure a caller feels: the row bound has stopped being a memory
    decision.** `cycle` at N = 4,096 cost 1,131,440 KiB at the default bound and 23,872 with a bound
    of 100,000 in C1192, a factor of 47. It now costs 38,260 at the default bound and 22,352 sized, a
    factor of 1.7; `closure` at `blocks` and N = 65,536 is 264,312 against 244,672, a factor of 1.08.
    Against compiled Soufflé the default-bound whole-process ratio at N = 4,096 went from **3.244 to
    0.852** with peak resident set from 527 MB to 18 MB, and preparation from 123.2 ms to 14.8 ms.
    The surprise worth recording is that the default bound now **beats** the hand-sized bound C1192
    had to use, because the sized bound still committed everything it reserved. *Nothing about this
    item is open.*

11. **Open, added by C1200: the repair for the domain defect costs 0.67 to 0.85 per cent of the
    derivation loop's instructions, and the comparison is not what costs it.** Recording the domain
    in `DemandWorkspace` and comparing it in `shape()` recompiles `Demand::evaluate_into` from 7,701
    instructions to 7,788 and measures 1.00673 to 1.00854 against `closure_ballpark-ed99963` on the
    six direct-path cohorts, with A/A nulls inside three parts per million
    (`analysis/datalog-comparison/ab-2026-09-17-c1200-direct-repairs.json`). The check runs once per
    `evaluate_into` and compares one `u32`; the measured difference on `closure` sparse at N = 256 is
    255,531 instructions per evaluation over 62,979 derived tuples, four per row, so it is the body
    and not the check. One variant was tried and rejected: `#[inline(never)]` on `shape` gives 7,916
    instructions, worse than either. *Evidence gap*: the same one as item 2 — what about a field
    added to a cold record recompiles the hot loop, and where in the body the four instructions per
    row sit. A kernel-scoped `perf annotate` of both arms, bucketed into named address ranges, is the
    measurement. *Owner*: whoever takes the next derivation-loop task; a correctness gate is not
    revertible for an instruction count.

12. **Settled by C1200, and it is the defect the C1199 audit found in shipped code:
    `shape()` accepted a workspace whose reset would not terminate.** `shape()` compared the row
    bound, the relation and index counts, every capacity, arity, bitmap choice and table length, and
    `DemandWorkspace` recorded the row bound and not the domain — while the high-water reset
    recomputes every row's key with the current plan's domain. Before this task the reset was a
    `fill(NONE)` over the capacity and was domain-independent, so the omission cost nothing; the
    high-water walk is what made it decide which slots are cleared. Two same-shape programs over
    domains 4,096 and 2,048 sharing one workspace were accepted, evaluated correctly twice, and did
    not terminate on the third call, because a stale bucket head makes `next[row]` point at the row
    itself. No shipped caller reaches it — the harness and `rel_stratified::evaluate` build a
    workspace per program and per layer — so this was a hole in a safety net rather than a wrong
    shipped result, but `shape()` exists to reject an incompatible workspace and it accepted one that
    hangs the evaluator. Repaired in `ergodis` `e7116ba` and bound by a test. *Nothing about this item
    is open; its cost is item 11.*

No discovery-track entry. Everything found was inside what the task was looking for, with one
exception folded into item 6 rather than logged, because the read-then-write fault pair is a property
of this workspace's own access pattern and not an incidental observation about anything else.

## Replay commands

Run from `~/src/ergodis-private` unless stated. Every gate and every measurement was run under
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so the gates and the measurements describe one build.

```sh
# Gates, core.
cd ~/src/ergodis
nix develop . --command cargo test --all-features -j 8
nix develop . --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
nix develop . --command cargo fmt --all -- --check
# The WebAssembly fallback is a compiled path, not a comment.
nix develop . --command nix shell nixpkgs#lld --command \
    cargo build -p ergodis-rules --target wasm32-unknown-unknown --release -j 8
cd ~/src/ergodis-private

# Gates, private. This drives rel_lowering, rel_frontend, rel_frontend_portability
# and rel_reference_eval, which is the C1189 differential.
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private -p ergodis-tools -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private -p ergodis-tools \
    --lib --bins --tests --examples -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check

# The arms. Each is retained from a checkout at its own revision.
git checkout c3eda9a && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout c3eda9a && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
git checkout 356fce6 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout 6078142 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout 6078142 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
git checkout ed99963 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout ed99963 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools

A=analysis/datalog-comparison
CTL=~/.cache/ergodis/bin/closure_ballpark-b7921a0       # the card's control
CTL2=~/.cache/ergodis/bin/closure_ballpark-c3eda9a      # same revision as the candidate's tree
CAND=~/.cache/ergodis/bin/closure_ballpark-ed99963      # the shipped arm
W=~/.cache/ergodis/c1198
DIRECT=closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512
MEMORY=closure:blocks:4096,closure:blocks:16384,closure:blocks:65536,mutual:blocks:4096,mutual:blocks:8192,cycle:blocks:4096

# The direct path, where the tables are small. Run against both controls; they
# agree to five decimal places, which is what says the card's control is sound.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CTL --a-name control \
    --b $CAND --b-name candidate --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts $DIRECT --work $W/ab-work --out $A/ab-2026-09-17-c1198-direct-final.json

# The cohorts the reservation was costing, at the default row bound.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CTL --a-name control \
    --b $CAND --b-name candidate --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts $MEMORY --work $W/ab-work --out $A/ab-2026-09-17-c1198-memory-final.json

# The supplementary cache set, and the TLB set that ruled out a TLB cause. The
# candidate arm here is 6078142, which is what the receipt records.
CE=cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses
TE=ls_l1_d_tlb_miss.all,ls_l1_d_tlb_miss.all_l2_miss,dtlb-loads,dtlb-load-misses
CAND6=~/.cache/ergodis/bin/closure_ballpark-6078142
nix develop ~/src/ergodis --command python3 $A/ab.py --a $CTL --a-name control \
    --b $CAND6 --b-name candidate --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts closure:dense:512,closure:blocks:4096,samegen:dense:512 --events $CE \
    --work $W/cache-work --out $A/ab-2026-09-16-c1198-cache-shipped.json

# The reach and resident-set table. One process, one evaluation, no certificates.
R=$W/reach-work
for a in "closure 4096 sparse" "closure 8192 sparse" "closure 2048 dense" \
         "samegen 8192 sparse" "samegen 16384 sparse" "closure 4096 blocks" \
         "closure 16384 blocks" "closure 65536 blocks" "mutual 4096 blocks" \
         "mutual 8192 blocks" "cycle 4096 blocks"; do
  choom -n 1000 -- $CAND --evaluator demand --evaluate-only --program $a 1 $R
done
for a in "closure 65536 blocks" "mutual 65536 blocks" "cycle 65536 blocks"; do
  choom -n 1000 -- $CAND --evaluator demand --evaluate-only --program $a 1 $R --max-rows 1100000
done
choom -n 1000 -- $CAND --evaluator demand --evaluate-only --program cycle 4096 blocks 1 $R --max-rows 100000

# The cold-start stage, three repeat counts for the two-point difference. The
# stage is read from its fault count and its wall time, never from instructions.
for n in 10 20 40; do
  choom -n 1000 -- taskset -c 5 perf stat -e page-faults,minor-faults \
      $CAND --evaluator demand --evaluate-only --cold --program cycle 4096 blocks $n $R
done

# Page faults by symbol, both arms: where the commit comes from. The arms are
# b7921a0 and 356fce6, and the two files are named as they are on disk.
P=~/.cache/ergodis/perf-c1198
for pair in "b7921a0 cycle-faults" "356fce6 cycle-faults-candidate"; do
  set -- $pair
  taskset -c 5 perf record -q -e page-faults -c 200 -o $P/$2.data -- \
      ~/.cache/ergodis/bin/closure_ballpark-$1 --evaluator demand --evaluate-only \
      --program cycle 4096 blocks 1 $R
  perf report -q -i $P/$2.data --no-children --percent-limit 1 --sort symbol
done

# The kernel-scoped instruction profile, both arms: b7921a0 and 6078142.
for arm in b7921a0 6078142; do
  taskset -c 5 perf record -q -e instructions:u -F 4000 \
      -o $P/closure-dense-$arm.data -- \
      ~/.cache/ergodis/bin/closure_ballpark-$arm --evaluator demand --program closure \
      --certificates 512 dense 20 $R
  perf report -q -i $P/closure-dense-$arm.data \
      --no-children --percent-limit 0.004 --sort symbol
done

# The frontend and the stratified backend.
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
B=analysis/rel-frontend
T=~/.cache/ergodis/bin/ergodis-tools-6078142
C=~/.cache/ergodis/bin/ergodis-tools-f12e27b
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T --control $C \
    --rounds 5 --cpu 5 --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v9-c1198-6078142.json
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T --control $C \
    --rounds 5 --cpu 5 --cohorts datalog --stages scan,parse,admit,lower,stratify \
    --events $E --out $B/performance-v9-c1198-datalog-6078142.json
for c in stratified columns aggregate; do
  nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T --control $C \
      --rounds 5 --cpu 5 --cohorts $c --definitions 128 \
      --stages scan,parse,admit,lower,stratify --events $E \
      --out $B/performance-v9-c1198-$c-6078142.json
done

# The C1191 boundary cohorts: the largest dictionary that runs and the first
# that is refused, on both arms. --definitions counts definitions; the table's
# "dictionary" is definitions × columns (2 for columns and aggregate, 3 for
# columns3), which is how 2,046 reads as 4,092 and 161 as 483.
F="--max-rows 16777216 --values 262144"
for n in 2047 2048; do choom -n 1000 -- $T rel-lower --cohort stratified --definitions $n --max-tuples 0 $F; done
for n in 2046 2047; do choom -n 1000 -- $T rel-lower --cohort columns    --definitions $n --max-tuples 0 $F; done
for n in 161 162;   do choom -n 1000 -- $T rel-lower --cohort columns3   --definitions $n --max-tuples 0 $F; done
for n in 2046 2047; do choom -n 1000 -- $T rel-lower --cohort aggregate  --definitions $n --max-tuples 0 $F; done

# Soufflé 2.5, compiled and interpreted, both -j1, on the blocks cohorts. The
# second run differs only in the row bound the caller declares.
S="nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake nixpkgs#time -c"
$S python3 $A/compare.py --bin ~/.cache/ergodis/bin/closure_ballpark-6078142 \
    --work $W/souffle-work --out $A/results-2026-09-16-c1198-blocks.json \
    --rounds 5 --cpu 5 --sizes closure:blocks:4096,16384,65536
$S python3 $A/compare.py --bin ~/.cache/ergodis/bin/closure_ballpark-6078142 \
    --work $W/souffle-work-bounded --out $A/results-2026-09-16-c1198-blocks-bounded.json \
    --rounds 5 --cpu 5 --harness-args "--max-rows 1100000" --sizes closure:blocks:4096,16384,65536

# The native/WebAssembly parity replay, which regenerates the committed manifest.
choom -n 1000 -- nix develop ~/src/ergodis --command python3 \
    analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json

# C1200: the probe that isolates the stagger commit. Two sibling detached
# worktrees, because the private crate pins the core by path; copied by hand,
# because retain-bin.sh would name it by the private revision 356fce6.
D=~/.cache/ergodis/worktrees/c1200-stagger
git -C ~/src/ergodis worktree add --detach $D/ergodis 271d648
git -C ~/src/ergodis-private worktree add --detach $D/ergodis-private 356fce6
(cd $D/ergodis-private && nix develop ~/src/ergodis --command \
    cargo build --example closure_ballpark --release -j 8)
cp ~/.cache/ergodis/target/ergodis-private/release/examples/closure_ballpark \
   ~/.cache/ergodis/bin/c1198-stagger-probe

# C1200: the stagger commit isolated, and the store-to-load-forward counters on
# both probe pairs against the arm before the stagger.
SE=ls_bad_status2.stli_other,ls_stlf,cycles,instructions
P=~/.cache/ergodis/bin/closure_ballpark-356fce6
nix develop ~/src/ergodis --command python3 $A/ab.py --a $P --a-name prestagger-356fce6 \
    --b ~/.cache/ergodis/bin/c1198-stagger-probe --b-name stagger-probe \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts closure:dense:256,closure:dense:512 \
    --work ~/.cache/ergodis/c1200/stagger-work \
    --out $A/ab-2026-09-17-c1200-stagger-isolated.json
for pair in "c1198-stagger-probe stagger-probe stlf-stagger" \
            "c1198-nostagger-probe nostagger-probe stlf-nostagger"; do
  set -- $pair
  nix develop ~/src/ergodis --command python3 $A/ab.py --a $P --a-name prestagger-356fce6 \
      --b ~/.cache/ergodis/bin/$1 --b-name $2 --mode evaluate --rounds 5 --cpu 5 \
      --repeats 3 --cohorts closure:dense:256,closure:dense:512 --events $SE \
      --work ~/.cache/ergodis/c1200/$3-work --out $A/ab-2026-09-17-c1200-$3.json
done

# C1200: the kernel body across the stagger commit, by opcode histogram. The
# stagger probe, the no-stagger probe and 6078142 are identical; 356fce6 is not.
for b in closure_ballpark-356fce6 c1198-stagger-probe c1198-nostagger-probe \
         closure_ballpark-6078142; do
  objdump -d --no-show-raw-insn ~/.cache/ergodis/bin/$b \
    | awk '/evaluate_into.*>:/{f=1;next} /^$/{if(f)exit} f{sub(/^[ \t]*[0-9a-f]+:[ \t]*/,"");print $1}' \
    | sort | uniq -c | sort -rn > ~/.cache/ergodis/c1200/hist-$b.txt
done
```

Inputs are deterministic: the C1182 xorshift64 generators seeded by the domain and the `blocks`
density, which uses no random stream at all.

## What this task left under `~/.cache/ergodis/`

**Retained binaries.** `bin/closure_ballpark-c3eda9a` and `bin/ergodis-tools-c3eda9a` are the
same-revision controls, retained from clean trees before the first source change, and they exist to
show that the card's controls are sound. `bin/closure_ballpark-356fce6` and
`bin/ergodis-tools-356fce6` are the arm before the stagger; the first is the control every stagger
measurement is taken against and the second is cited by nothing. `bin/closure_ballpark-6078142` and
`bin/ergodis-tools-6078142` are the arm the frontend, backend, Soufflé, reach, boundary and
cold-start figures were taken on. `bin/closure_ballpark-ed99963` and `bin/ergodis-tools-ed99963` are
the arm this task shipped. `bin/closure_ballpark-aa04358` is the arm after C1200's repairs and is
**the control the next A/B should use**.

**Three probe builds, none of them a retained control and none carrying a manifest row**:
`bin/c1198-nostagger-probe`, measured sha256
`551ae2e657adfe7d551e6a654c723f0c3016a9c0c921bf5487be5e3dc787a9d9`, the `6078142` tree with the
rotating offset multiplied out; `bin/c1198-reset64-probe`,
`0a7096a979e65485166b390044d50c60eab501d8edcff713983820b60a6e50de`, which set the reset boundary;
and C1200's `bin/c1198-stagger-probe`,
`b4bf4c4514a5f0a93032bd89c21b85b9ee52a927c4bac30f6d7cca479f609a09`, the pre-stagger arm with the
stagger commit applied and nothing else, which is the pair that isolates it. The first two are
scratch builds from trees dirty in one expression; the third is built from two detached worktrees
under `worktrees/c1200-stagger/`, which were removed at C1200's close.

**Under `perf-c1198/` (317 KB):** the two page-fault profiles and the two kernel-scoped instruction
profiles. **Under `c1198/` (16 MB):** the A/B work directories (`ab-work`, `cache-work`), the reach
probes' fact files (`reach-work`, `probe`), the two Soufflé work trees (`souffle-work` and
`souffle-work-bounded`), the stagger and reset-constant probe receipts, the parity replay's
regenerated manifest, the private test log, and the two batch scripts the measurement runs used.

`../ergodis-dev/scripts/cache-gc.sh` was run in its listing mode at task close and **nothing was
deleted**. It scanned 47 entries and showed 15 as unreferenced and old enough to remove, none of them
this task's: the largest are `datalog-comparison` at 281 MB, `perf-c1170` at 162 MB, `module-loading`
at 124 MB, `worktrees` at 105 MB and `application-workspace` at 21 MB, all from other lanes or
earlier tasks. This task's `c1198` and `perf-c1198` both show as kept. Deletion is the user's call.

## The control for the next A/B

For the derivation loop, **`~/.cache/ergodis/bin/closure_ballpark-aa04358`**, measured sha256
`a29f36177039ddc372de9b49fad5de2994063167ef9c4306e05a428ac55bfbcf`, retained from a **clean** tree at
`ergodis-private` `aa04358` with core `ergodis` `e7116ba` under rustc 1.95.0 (59807616e 2026-04-14),
release profile, no features, through
`../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release`. This is the
arm after C1200's repairs; `closure_ballpark-ed99963`, measured sha256
`97a59d7a5c86dacab107dce7e8fa3e931adacf755d9e58e79b50eadb64268786`, is the arm this task shipped and
is one core commit behind it.

For the frontend and the stratified backend, `~/.cache/ergodis/bin/ergodis-tools-ed99963`, measured
sha256 `ce90b5af67b00eec1dfe64dece3fd656d4cc00415f5f6541a4679137cf7a451e`, retained from the
`ed99963` clean tree through `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools`. C1200
did not re-retain it; a task that measures the Rel route should, because `e7116ba` changes the
kernel that route calls.

All of them are at the shape their tree carried, and unlike C1192's pair all were retained from a
clean tree with no foreign uncommitted file in either repository. **One caution for whoever runs the
next A/B**, and it is the opposite of the one an earlier revision of this report gave: a source
change anywhere in the core's module graph can recompile `Demand::evaluate_into` wholesale and move
it by most of a per cent, which this lane has now measured three times — the stagger commit at
0.9917, the domain field at 1.0085, and C1170's driver edit at 1.017 on the scanner. A change that
"cannot touch the loop" still needs its own retain and its own control.

## Vibe check

Very good, and the result is larger than the card's own framing expected because the card's stated
mechanism was wrong. The eager commit was never the `fill(NONE)`; it was `calloc` memsetting a
workspace nobody had written to, which a page-fault profile attributes at 98.45 per cent before a
line of code was changed. Reserving each table as an anonymous `MAP_NORESERVE` mapping, making zero
the empty sentinel and resetting by the rows rather than the capacity takes peak resident set down by
a factor of 3.1 to 29.6 at the default row bound, and the derivation loop is 1.6 to 1.8 per cent
*cheaper* in instructions rather than merely unmoved. The caller's row bound has stopped being a
memory decision: `cycle` at N = 4,096 was 47 times its sized-bound footprint and is now 1.7 times it.

The sharpest number is the Soufflé one. On the cohort C1192 measured at **3.244 times compiled
Soufflé at the default row bound**, this evaluator is now **0.852** — better than the 0.984 C1192
could only reach by hand-sizing the bound — with peak resident set from 527 MB to 18 MB and
preparation from 123.2 ms to 14.8 ms. At the two smaller sizes the default-bound and sized-bound
columns are identical phase for phase. At N = 65,536 they are not, and the residual is locality
rather than memory: a hash table sized from an over-declared bound still costs misses even when its
pages cost nothing. That is the one part of C1192's remaining gap 4 this does not close.

Two things nearly went wrong and both are worth carrying. The first three deliverables together made
dense closure **9 per cent slower in cycles while executing fewer instructions**, and neither the
cache set nor the TLB set showed it. The commit that repairs it is the cache-line stagger —
measured at 0.913 of the cycles on both dense cohorts against the arm before it, with readable
nulls — but **the mechanism this report first gave for it is wrong, and the audit that found that is
the reason to read this paragraph twice.** The rotating offset is not what repairs the regression: a
probe with the offset multiplied out to zero repairs it just as completely, and the two probes
differ only in the offset while sharing a compiled body that the stagger commit rewrote from 7,741
instructions to 7,701. The store-to-load-forward counters the 4 KiB-aliasing story predicts do exist
on this PMU, and they say the faster arm has *more* conflicts. What removes the 9 per cent is a
recompilation, and why a recompilation is worth 9 per cent of cycles is open.

The second is a testing failure, and the audit found a third of the same kind. Deleting the index
reset passed every integration test and then hung for nine minutes, because a reset that clears too
little produces non-termination rather than a wrong answer, and because a closure program never
walks the chain index at all; the gate that catches it asserts the tables directly and had to be
written after the fact. What the C1199 audit then showed is that two more of this task's load-bearing
decisions were bound by nothing — inverting the fill-versus-walk rule and leaking every staggered
reservation both passed the whole crate — and that `shape()` accepted a workspace whose reset would
not terminate. All three now have a test, and the third one's repair costs 0.8 per cent of the
derivation loop's instructions, which is the same unexplained recompilation effect again.

Two constants in this report are measured rather than reasoned, and one of them started out
reasoned and wrong. `RESET_FILL_BYTES_PER_ROW` was set at 32 with a code comment claiming no cohort
was near the boundary; five structures sit within a factor of two of it, and measuring 64 against 32
took 9.7 per cent off one cohort's instructions for no memory at all. `MADV_HUGEPAGE`, which the card
asked for, costs 60 to 77 per cent more resident memory and is shipped off.

What the task leaves is a clean successor and a large one: **the checkers now cost more memory than
the evaluator by a factor of up to eight**, and `datalog_store.rs` has the same `calloc` defect and
already uses the same zero sentinel. The only thing in the way is that
`implementation_identity()` hashes the checker sources, so the fix moves a digest certificates bind
to — a decision rather than a measurement.
