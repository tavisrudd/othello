# C1191 — the direct constructor from the relational IR into the demand evaluator's prepared form

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: IN PROGRESS. Written incrementally from the start of the task, so a crash leaves a
partial record rather than none.

Task card: `2026-09-16-c1191-direct-constructor.md`. Decision record: private
`docs/adr/0004-rel-lowering-ir.md`, whose "direct constructor into the demand evaluator's prepared
form" is what this task builds. Predecessors: `2026-09-15-c1190-milestone-c.md` (the design note
"Designing for the direct constructor"), `2026-09-15-c1190-per-column-domains.md` (the 96 per cent
encoding finding and the boundary experiment), `2026-09-15-c1190-milestone-b.md` (layer programs and
complement records). Repositories: `~/src/ergodis` (core) and `~/src/ergodis-private` (driver).

## Arms

Filled in as each is retained. Every hash is recorded **as measured**, never cited: the thing to run
is the retain recipe at the named revision.

| Arm | Repository | Revision | Dirty | Retained name | rustc | Measured sha256 |
| --- | ---------- | -------- | ----- | ------------- | ----- | --------------- |
| (to be filled) | | | | | | |

Retain recipe for every arm, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

which re-executes itself inside `nix develop` of the core checkout, so the toolchain is the
`rust-toolchain.toml` pin.

## Commits

| Repository | Commit | What |
| ---------- | ------ | ---- |
| (to be filled) | | |

## Fermi predictions, written before any code

These are written from the per-column report's byte decomposition (about 44 bytes fixed plus about
1 byte per value in a materialized fact's canonical JSON, of which the tuple is about 4 per cent),
from milestone (c)'s boundary measurements (153, 302, 84 and 213 dictionary entries on four cohorts,
all at about 22,000 materialized facts in one layer), and from reading the core's bound constants.

### 1. Which bound binds after the serialization is gone, and where the boundary lands

Today a layer is refused by `Budget::ProgramBytes`: the canonical JSON of one layer's `Program`
against the core's `MAX_BYTES` of 1,048,576. Nothing in the prepared path serializes, so that
refusal has nothing to check and is replaced by whichever declared bound binds first. The candidates,
with the dictionary size `d` each admits on a cohort whose negated relation has arity two and both
columns over the whole dictionary:

| Bound | Value | Checked against | Largest `d` at arity two |
| ----- | ----: | --------------- | -----------------------: |
| `MAX_COMPLEMENT` (this route's own) | 2^22 = 4,194,304 | `∏ᵢ \|Dᵢ\|` per negated literal | **2,048** |
| `MAX_INDEX_KEYS` (core) | 2^24 = 16,777,216 | `domain^arity` of an indexed relation | 4,096 |
| `MAX_UNIVERSE` (core) | 2^30 | `domain^arity` of any relation | 32,768 |
| `MAX_DOMAIN` (core) | 65,536 | the declared domain | 65,536 |

**I predict `MAX_COMPLEMENT` is the bound that binds on `stratified`, at a dictionary of about
2,048**, against today's 153 — a factor of about **13.4**, which is the order of magnitude the
per-column closeout priced this lever at (it predicted "roughly 10×, to a dictionary of about 1,000
at arity two with whole-dictionary columns", so I predict it was right in order and about twice
conservative). On `columns`, whose two columns are disjoint halves, the same bound is
`(d/2)² ≤ 2^22`, so I predict about **4,096** against today's 302. On `columns3`, arity three, the
close pass checks `d³` against `MAX_INDEX_KEYS` for an indexed relation before the complement bound
can fire, so I predict **`MAX_INDEX_KEYS` at about 256** against today's 84 — a different bound on a
different cohort, and the first time on this route that the *core's addressing* rather than this
route's own materialization budget decides the reach. For the `aggregate` cohort's comparison filter,
`MAX_FILTER` is also 2^22 and the filter is `N(N−1)/2` over `|D₀|·|D₁| = N²` candidates, so I predict
the refusal at a key set of about **2,048** against today's 213.

The general statement I predict the measurement supports: **removing the serialization moves the
route's ceiling from about 22,000 materialized facts in one layer to about 4,000,000**, and what
binds after that is a declared materialization budget rather than an encoding.

### 2. What one materialized fact costs to hand the core, before and after

Today, per fact: a `Fact` with an owned relation `String` (one allocation plus a copy of about 20
bytes) and an owned `Vec<u32>` tuple (a second allocation); `encode_source` serializing about 45
bytes of JSON; SHA-256 over those 45 bytes; then `datalog::admit` re-resolving the relation name
through a `BTreeMap<&str, u32>` (a handful of string comparisons), re-checking every value, and
cloning the tuple into a third allocation inside `AdmittedFact`; then `Demand::new` copying the
tuple a fourth time into the per-relation `initial` vector and a fifth into the boxed slice. SHA-256
costs on the order of 17 instructions per byte here, so the hash alone is about **760 instructions
per fact**; I estimate the whole per-fact boundary cost at **600 to 1,200 instructions**.

In the prepared path, per fact: one store of `arity` words into a presized flat pool, a sort key, and
SHA-256 over `4·arity` bytes — about **140 instructions of hashing at arity two** and perhaps 40 of
everything else. I predict the per-fact boundary cost falls to **150 to 250 instructions**, a factor
of **4 to 6**, and that the hash is the dominant surviving term in both.

### 3. What the measured stage shows

The existing `rel-frontend-bench` stages stop at `lower`, the frontend's lowering into the relational
IR; no stage runs the stratified backend at all, which is why milestone (c) could measure a cohort at
512 definitions that the backend refuses at 214. **The candidate is therefore invisible to the
existing stage set**, and the first thing this task must build is a `stratify` stage that runs the
layer chain. That stage is harness work, so it is committed and a control retained at that revision
*before* the constructor is written, and the harness commit itself gets a parity A/B against
`ergodis-tools-b7c624d` showing `scan`, `parse`, `admit` and `lower` did not move.

I predict, on the `stratify` stage: `datalog` (purely positive, 513 input facts, no complement) down
**10 to 25 per cent**, because its boundary cost is the input facts only and its evaluation dominates;
`stratified` (three complements over a dictionary of 512 at the bench's 512 definitions) down **40 to
70 per cent**; `aggregate` down by a similar fraction; and the three cohorts that never reach the
backend at **1.000 within the nulls**. I predict `scan`, `parse` and `admit` at unity to within about
ten parts per million, and `lower` likewise, with the standing caveat this lane has now recorded five
times: the workspace builds with thin LTO and one codegen unit, and a swing of a few tenths of a per
cent on a cohort that cannot execute the change is code layout, which I will not read as a win or a
loss.

### 4. Memory

I predict the prepared path **reduces** peak resident set at the boundary, because the layer no
longer holds a serialized copy of itself: today a layer at the boundary materializes about 22,000
facts as `Fact` records (roughly 60 bytes of `String` and `Vec` headers plus two heap blocks each,
call it 120 bytes per fact, about 2.6 MB) and then a 1 MiB `Vec<u8>` of JSON. The prepared path holds
`4·arity` bytes per fact in one flat pool, about 176 KB at the same fact count. I predict peak RSS at
a fixed dictionary size falls by **1 to 4 MB** on the negation cohorts and is unchanged on the
cohorts that do not reach the backend. At the *new* boundary the absolute figures will of course be
far larger, and I predict I report them rather than only the ratio, which is the per-column audit's
one substantive finding about reporting.

### 5. Where the risk is

Not in the arithmetic: a prepared `Demand` either builds the same `RelationPlan`, `Step` and `Index`
structures as `Demand::new` or it does not, and the differential decides that. The two places I
expect to be wrong first are (a) **what a prepared `Demand` answers for `source()`**, because both
independent checkers take a `&Program` and a prepared `Demand` has none, so either the checkers grow
an admitted-form entry point or the prepared path loses its checkers — and losing the checkers would
lose the whole evidence chain this route rests on; and (b) **the fact identity**, because
`Demand::new` keeps facts in program order with duplicates recorded by index while a prepared source
has no program order at all, so the prepared source identity has to be defined over a canonical
*set* if it is to be stable under a re-ordering of supplied tuples. I predict at least one
instructive negative in each.

### 6. Expected differential disagreements

Zero, and for a reason that is weaker than milestone (b)'s: the prepared path is a second
construction of the *same* `RelationPlan`/`Step`/`Index` structures from the same information, not a
different reading of a construct, so the only way it can disagree is by building them wrongly. That
makes a deliberate mutation the load-bearing evidence rather than the corpus, and I predict I will
have to say so.

## Status

(to be filled)

## Design, and the shapes not built

(to be filled)

## Method

(to be filled)

## Results

(to be filled)

## Profile

(to be filled)

## Disposition

(to be filled)

## Recorded deviations

(to be filled)

## Remaining gaps

(to be filled)

## Mystery ledger

(to be filled)

## What this task left under `~/.cache/ergodis/`

(to be filled)

## Next steps

(to be filled)
