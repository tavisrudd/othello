# C1190 lowering kernel candidates — the relation-resolution index and the module index

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: IN PROGRESS. Written incrementally from the start of the task, so a crash leaves a
partial record rather than none.

**Repository**: `~/src/ergodis-private` (private, no remote), consuming `~/src/ergodis` read-only.
Rules: `~/src/ergodis-dev/PERFORMANCE.md` and `~/src/ergodis-dev/performance-playbook.md`.

**Predecessor**: `2026-09-15-c1190-milestone-a.md`. This task takes its "Remaining gaps" 1 and 2 —
the quadratic relation scan and the node-pool sweep every lowering pays — and prices, builds and
measures each as a kernel candidate against a retained control.

**Commits**: recorded per candidate in the disposition section below.

## The control, retained before the first source change

| Arm     | Repository        | Revision  | Dirty | Retained name           | Measured sha256                                                    |
|---------|-------------------|-----------|-------|-------------------------|--------------------------------------------------------------------|
| control | `ergodis-private` | `4b8cfd7` | no    | `ergodis-tools-4b8cfd7` | `da7566ce09da1a7eb390ed56136ffb02306b6ad9698f7e075d75d78dc11b8fed` |

Retained by `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` run from
`~/src/ergodis-private` with `4b8cfd7` checked out and the working tree clean; the script
re-executes itself inside `nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the
`rust-toolchain.toml` pin. `release`, no features, rustc 1.95.0 (59807616e 2026-04-14). The hash is
recorded as measured, not cited: the thing to run is the retain recipe at that revision.

The milestone report named `ergodis-tools-41553c9` as the next control. The three commits since it
(`37b2713`, `c8e5344`, `5180507`, and then `7a8bc5a`, `7018acc`, `4b8cfd7`) touch the coverage
manifest, the closing pass's empty-program rejection, a formatter sweep and C1130 provider work;
none touches `src/rel_frontend`, `src/rel_lowering.rs`, `tasks/tools` or `analysis/rel-frontend`.
The playbook rule is nevertheless to retain at the revision the tree carries, so the control here is
`4b8cfd7`, freshly retained, and not the one the milestone named. One difference matters for the
record: `41553c9` was built from a tree carrying fifteen foreign uncommitted files, and `4b8cfd7`
is built from a clean tree, so every arm of this task is reproducible from its commit alone.

## Fermi predictions, written before any code

Both are priced from figures the milestone report already measured: the comment-string cohort's
`lower` minus `admit` difference of 18,676,502 instructions over 65,610 source bytes with 896
relations declared, its scaling series, the ascii and unicode differences of 79,208 and 79,977 over
12,288 and 12,416 nodes, and the `datalog` cohort's 1,299,495 over 5,096 nodes. Node counts of the
four cohorts, read from the control's own receipt line at 512 definitions: ascii 12,288, unicode
12,416, comment-string 3,584, datalog 5,096.

### Candidate 1 — the relation-resolution index

**What is removed.** `Rir::find_relation` is a linear scan over the relation pool, called from
`declare`, `resolve_name` and `qualified`. On the comment-string cohort `declare` calls it 896
times against a pool that grows from zero to 895, which is 896 × 895 / 2 = **400,960 record
comparisons**. At the milestone's measured ~46 instructions per comparison that is **18.44 M
instructions, 98.7 per cent of the 18,676,502 measured for the whole stage difference**. The cost
model closes on the measurement to better than two per cent before the candidate is priced, which
is the condition the playbook puts on using a model at all.

**What replaces it.** One open-addressed probe keyed by `(owner module, spelling)`, in the same
shape as admission's symbol index: presized from `Limits::relations` to a power of two at twice
that bound, cleared inside reserved capacity at the start of each lowering exactly as the value
index is, FNV over the spelling bytes from a seed that mixes the owner id, linear probe, a 16-bit
hash filter carried in the `Relation` record's existing reserved half-word, and comparison by the
`same()` byte loop. The hash is computed once per call and handed to the insert, which is the
C1170 lesson about `admit::insert`'s signature. Per call: two instructions for the seed mix, about
three per spelling byte (the comment-string spellings `label0`…`label895` average 7.5 bytes, so
about 25), and 15 to 25 for the probe and the record compare — **40 to 60 instructions**, against
the 46 × (pool size) the scan costs.

**Predicted outcome.** The declaring phase falls from 18.44 M to 896 × ~55 ≈ **49,000
instructions**. The comment-string `lower` minus `admit` difference should land near **285,000
instructions, about 4.3 per source byte**, against the measured 284.66 — a ratio near **0.015** on
the stage difference. The residual is the node-pool sweep (3,584 nodes × 6.4 ≈ 23,000), 896 text
interns, 896 fact pushes, the per-relation passes and the closing `REL0503`. I will believe this
model if the measured difference lands between 200,000 and 600,000; above that the residual rather
than the scan was the bulk, and the profile widens rather than the constants being re-guessed.
The scaling series 468,393 / 1,397,718 / 4,748,879 / 18,676,568 at 64 / 128 / 256 / 512
definitions, whose ratios 2.98 / 3.40 / 3.93 converge on the fourfold rise a quadratic demands,
should come back with ratios near 2 per doubling.

**Where it does nothing, stated in advance.** The ascii and unicode cohorts reject inside `declare`
at the second definition with one relation in the pool and never reach the scan; their only change
is one more bulk clear in `Rir::clear`, 2,048 `u32` beside the value index's existing 8,192, which
is outside every traversal. On `datalog` the pool reaches six relations during the build pass, so
the old cost is about (512 declares × 1 + 272 name resolutions × 3) × 46 ≈ 61,000 instructions,
4.7 per cent of that cohort's 1,299,495, and the new cost is about 784 × 50 ≈ 39,000. A saving
near 22,000, or 1.7 per cent. This candidate is close to a wash wherever the relation count is
small, and saying so in advance is what makes the comment-string result a result rather than a
selected cohort.

**The datalog repeat-spelling lesson does not transfer, and that is the one thing worth checking
in the design.** Admission's index holds one symbol per `def` clause, so the `datalog` cohort's 512
clauses all spelled `edge` share one home slot and `admit::insert` walks a 512-entry probe chain —
the quadratic the milestone found in admission. This index holds one entry per distinct
`(owner, spelling)`, because `declare` looks the relation up before declaring it and several `def`
clauses of one relation share it. The 512 clauses of `edge` are therefore one entry, every one of
the 512 declares hits it on the first probe, and no chain forms. The pool also holds at most one
relation per `(owner, spelling)`, so the index lookup is exactly equivalent to the scan's
first-match-in-pool-order rather than merely agreeing on these cohorts.

### Candidate 2 — the module index

**What is removed.** `build::declare_modules` sweeps the whole node pool for `NodeKind::Module`
before the first declaration, at about 6.4 instructions per node, and every lowering pays it
including one that rejects immediately. On ascii that sweep is 12,288 × 6.45 = 79,208 instructions,
which is the entire stage difference; on unicode 12,416 × 6.44 = 79,977, likewise; on
comment-string about 3,584 × 6.4 ≈ 23,000; on datalog about 32,000, or 2.5 per cent of 1,299,495.

**What replaces it.** A list of module node ids recorded by a pass that already walks every node,
read by `declare_modules` in place of the sweep. Both producers were read before choosing.

- *Admission's declaring sweep* (`admit::check`) already walks every node once and already branches
  on `NodeKind::Module`, and it already records `w.definitions` under exactly the argument needed
  here: the pool cannot overflow because `declare` has taken a symbol slot for the node and fails
  with `SymbolCapacity` when there is none, and the pool is reserved to the same bound. A module
  list there adds no branch, no new failure path, and 64 KiB of reservation at
  `Limits::symbols`.
- *The parser* writes the node, so a push at `Module` node creation is one instruction in a place
  that runs once per module. But the parser has no symbol bound to hang the capacity on; the list
  would have to be reserved at `Limits::nodes` (2 MiB) to guarantee that the node push fails first,
  or it would introduce a capacity failure the parser does not have today.

I take admission. The task plan suggested the parser as likely cheapest; the two are equal in the
loop (one push per module node, and none of the six measured cohorts declares a module at all), and
admission is cheaper in reservation and carries no new failure mode. That is a deviation from the
plan's suggestion and it is recorded here with its reason.

**Predicted outcome.** `declare_modules` becomes a walk over a list that is empty on every cohort
measured here, so it is entered and left in under ten instructions. ascii and unicode `lower` minus
`admit` should fall from about 79,200 to whatever `Rir::clear`'s two bulk index clears and the walk
to the second definition cost, which I put at **1,000 to 4,000 instructions**. The width of that
prediction is deliberate: both clears lower to an ERMS `memset`, which retires very few
instructions for a great many cycles, so the instruction figure may sit far below what the cycle
figure implies, and the stage is then read from cycles as well. datalog falls by about 32,000
(2.5 per cent) and comment-string by about 23,000, which after candidate 1 is roughly eight per
cent of that cohort's remaining difference.

**What must not move, and it is the real check on this candidate.** The cost moves into an earlier
stage, so `parse` and `admit` ratios must come back at unity on every cohort and both scanner
variants, with equal fingerprints and equal failure records. On these cohorts admission's new push
executes zero times, because none of them declares a module, so anything other than unity there is
a ThinLTO layout effect and is read as one.

### Composed

If both land, the composed `lower` minus `admit` against `4b8cfd7` should be near 0.015 on
comment-string, near 0.03 on ascii and unicode, and near 0.96 on datalog, with `scan`, `parse` and
`admit` at unity everywhere.

## Candidate design and shapes considered but not built

*(filled in with the implementation)*

## Method

*(filled in with the measurements)*

## Results

*(filled in with the measurements)*

## Disposition

*(filled in per candidate)*

## Instructive negatives

*(filled in)*

## Mystery ledger

*(filled in)*

## Replay commands

*(filled in)*

## Gates

*(filled in)*

## What this task left under `~/.cache/ergodis/`

*(filled in)*
