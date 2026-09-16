# C1192 — a sparse join index in the demand evaluator, with an exact crossover policy

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: IN PROGRESS. Written incrementally from the start of the task, so a crash leaves a
partial record rather than none.

Task card: `2026-09-16-c1192-sparse-join-index.md`. Predecessors: `2026-09-13-c1182-demand-driven-datalog.md`
(the evaluator and the recorded "exact crossover unmeasured"), `2026-09-13-c1184-direct-checker.md`
and `2026-09-13-c1186-presence-bitmap.md` (the checkers' stores, which already carry a sorted
fallback), `2026-09-16-c1191-direct-constructor-report.md` (the boundary cohorts and remaining gap 1,
which names this change). Repositories: `~/src/ergodis` (core) and `~/src/ergodis-private`
(drivers and harnesses).

## Arms

Filled in as each is retained. Every hash is recorded **as measured**, never cited: the thing to run
is the retain recipe at the named revision.

| Arm | Repository | Revision | Dirty | Retained name | rustc | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, closure/same-generation harness | `ergodis-private` | `e0e7331` | no | `closure_ballpark-e0e7331` | 1.95.0 (59807616e 2026-04-14) | `c1c3aecce4a888c01a0fab20ec860e18d0c504b38132ad1ab852f8d87fdbe10f` |
| control, frontend and stratified backend | `ergodis-private` | `e0e7331` | no | `ergodis-tools-e0e7331` | 1.95.0 (59807616e 2026-04-14) | `e58752d20e1856353a9787ed50d31b158daf8b87aaef26ca4e0c55c28882dbbb` |

Retain recipes, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

Both re-execute themselves inside `nix develop` of the core checkout, so the toolchain is the
`rust-toolchain.toml` pin. Both control arms were retained from a clean tree at `ergodis-private`
`e0e7331` with core `ergodis` `2517852`, **before the first source change of this task**.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | | this report's skeleton and the Fermi predictions, written before any code |

## Fermi predictions, written before any code

Written from the compiled shape of `crates/rules/src/demand.rs`, the bound constants, and the
C1182 and C1191 measurements.

### 1. Which bound binds on which family, and what the reach becomes

The card and the programme review both say `MAX_INDEX_KEYS` caps every binary relation at a domain
of 4,096. That is true of an index whose key mask names **two** columns, and it is the reason
`columns3` and `aggregate` stop where C1191 measured them. It is **not** what stops the closure and
same-generation families, and I predict the measurement will show that, because their join masks all
have population count one:

- `path(x,z) :- path(x,y), edge(y,z)` binds `y` from the delta atom, so the `edge` index keys on
  column 0 alone: `domain^1`. The mirrored step keys `path` on column 1 alone. Same for all three
  same-generation rules.

So for those two families `MAX_INDEX_KEYS = 2^24` is reached only at a domain of 16,777,216, far
above `MAX_DOMAIN = 65,536`. **I predict the bound that actually stops closure and same generation
today is `MAX_UNIVERSE = 2^30`** — the derived relation's membership bitmap over `domain^arity` —
which at arity two is a domain of 32,768, and that the second bound behind it is `MAX_ROWS = 2^24`
on the derived rows. I predict the C1182 generated closure family (out-degree three, random targets)
cannot reach N = 16,384 under **any** index change, because its closure is essentially complete
(0.93 N² measured at N = 4,096, which is 15.68 M rows against a row capacity of 16.78 M): I predict
N = 8,192 is refused by `MAX_ROWS` with the output near 62 M. The same generation family is
0.115 N², so I predict it is refused by `MAX_ROWS` at N = 16,384 (about 31 M rows) and runs at
N = 8,192 (about 7.7 M).

Therefore I predict the reach the card asks for — closure and same generation at N = 16,384 and
65,536 — is **not reachable on the existing generated families at all**, for a reason that has
nothing to do with the index, and that the task must add a family whose domain is large and whose
closure is small to demonstrate the removed ceiling. I predict I add one deterministic edge
generator (disjoint blocks) and one program whose join mask has population count two, and that
these are the two cohorts that carry the reach claim.

### 2. What the sparse structure costs per probe

Direct probe: one load from `head[key]`, a random access over `4·K` bytes. Sparse probe: a
multiply-shift hash of the packed key (about four instructions), one load from `head[h]` over
`4·S` bytes where `S` is the presized power-of-two table, and then, per row the chain yields, a
comparison of the key columns against the probe's values — because a hash bucket may hold rows of
other keys, which direct addressing cannot. The tuple those columns live in is already loaded by
the join step, so the verification is two to four instructions and no extra load.

I predict the sparse kind costs **6 to 12 more instructions per probe** plus the wasted chain
steps, which at a load factor of one half I predict at about 0.3 rows per probe. Against a join
step I estimate at 30 to 60 instructions per candidate, that is **10 to 25 per cent more
instructions in the join step** and, since the derivation loop is roughly half of evaluation on the
closure family, **5 to 15 per cent more instructions on evaluation at equal work**.

**So I predict instructions alone say "always direct", and that the crossover is not an instruction
question.** What the sparse kind buys is memory and memory traffic: the direct dynamic index
allocates `4·K` bytes and, critically, `head.fill(NONE)` writes all of them at the start of every
evaluation, while the sparse one writes `4·S` with `S` sized from the relation's rows. I predict
the crossover in cycles and wall time sits where the reset traffic and the random-access footprint
outweigh the extra instructions, at **K between 4 and 32 times the row count**, and that the
measured value is closer to 8 than to 32. I predict I will have to say plainly that this is the
one figure in this lane a cycle ratio decides rather than an instruction ratio, and that above the
crossover the choice is not speed at all but feasibility, because the direct array does not exist.

### 3. What the direct path does when it is still selected

Nothing. The selection is made once at preparation; the derivation loop is dispatched once per step
at entry rather than per probe, which is a strict improvement on today's shape, where
`if index.offsets.is_empty()` is tested inside the per-delta-row loop on a value that is constant
for the whole step. I predict the direct path is **unchanged to within the A/A nulls** on every
existing cohort, and I predict a small win — **0 to 2 per cent** — from hoisting that run-constant
branch, most visible on same generation sparse, where the delta rows are many and the chains short.

### 4. Memory, and what replaces the removed bounds

Removing `MAX_UNIVERSE` and `MAX_INDEX_KEYS` as refusals does **not** raise the worst-case
workspace; I predict it lowers it. Today a relation's bitmap is `domain^arity / 8` bytes whatever
its row count, up to 128 MB, and a dynamic index is `4 · domain^popcount` bytes, up to 64 MB, again
whatever its row count. With a selection policy every structure is `O(rows)` except a direct array
the policy chose because it was small. I predict the worst case per relation falls from about
190 MB independent of rows to about `(8 + arity) · 4 · rows` bytes plus a bounded direct array, and
that the replacement refusal is `MAX_ROWS` plus a named workspace byte ceiling, both through
`Error::Budget`.

I predict peak resident set at equal N is **lower** on the sparse arm wherever the relation is
sparse and **slightly higher** where it is dense, and that the dense closure family at N = 1,024 is
the case where direct is the right choice by a wide margin: its universe is 2^20 and it derives
2^20 rows, a density of one.

### 5. Expected differential disagreements

Zero, and for the same weak reason C1191 recorded: the sparse kind answers the same query as the
direct kind, so a corpus that exercises the query only sees them agreeing. The load-bearing evidence
is therefore (a) running the whole existing test corpus a second time with the policy forced to
sparse, which is what C1186 did with the checkers' sorted fallback, and (b) deliberate mutations.
I predict at least one instructive negative in the chain-verification path: the case I expect to
get wrong first is a key column that is a **constant** rather than a bound variable, because the
direct index folds a constant into the key and a chain walk must compare it.

### 6. Where the risk is

Three places, in the order I expect them to bite. First, `MODE_FULL`'s `limit`: the CSR path breaks
out of a bucket when a row index reaches the limit because a counting sort leaves each bucket
ascending, while a chain is descending and must test every element; a sparse bucket mixes keys, so
neither the break nor the ordering argument transfers. Second, the `candidates` work counter, which
must stay exactly equal across kinds for the A/B to be a comparison at equal work — so a row the
chain yields that does not match the key must be rejected before it counts. Third, `u64::pow`
overflowing once `domain^arity` is no longer bounded: at domain 65,536 and arity four that is
exactly 2^64, so every universe computation has to saturate rather than wrap.

## Status

Not yet built.
