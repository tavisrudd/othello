# C1203 — re-locating the growing join index's direct/sparse crossover

**Lane**: `ergodis`
**Date**: 2026-09-18
**Status**: IN PROGRESS. Written incrementally from the start; the Fermi predictions below were
written and committed **before the first sweep**, and before any source change in any repository.

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
| `othello` | (this section is filled as commits land) | the report skeleton and the Fermi predictions, written before any measurement |

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
