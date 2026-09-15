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

### Candidate 1 as built

`Rir::probe_relation` is one open-addressed probe over a new `relation_index` pool of `u32` slots
holding relation id + 1, sized `index_slots(Limits::relations)` — twice the relation bound rounded
up to a power of two, so a probe always meets an empty slot — reserved by `Rir::new`, and emptied
in place at the start of each lowering by the same `clear_index` helper the value dictionary's index
now shares. The key hash is FNV-1a over the spelling bytes from a seed that mixes the owning
module's node id by one multiply (`0x811c_9dc5 ^ module.wrapping_mul(0x9e37_79b9)`), rather than the
four byte-wise steps the value dictionary spends on an integer payload, because every spelling byte
that follows mixes the seed further. The high half of the hash is a 16-bit filter carried in the
`Relation` record's previously reserved half-word, so a colliding slot is rejected without entering
the spelling byte loop; the record's stride assertion is unchanged at 32 bytes and the filter is not
part of the canonical form, so no fingerprint moves.

A miss returns the filter and the empty slot it stopped at, and `declare_relation` takes that pair
and writes the slot. That is the C1170 lesson about `admit::insert`'s signature applied here: a
spelling is hashed once per resolution and the insert does not walk the probe chain a second time.
Nothing between a probe and its declaration writes the index, which is what makes the carried slot
still the right one; the two declaring call sites (`declare` and `resolve_name`) are the only places
that pass one.

**Exactness.** The pool holds at most one relation per `(owner, spelling)`, because `declare` probes
before declaring and several `def` clauses of one relation share the relation the probe found, and
`resolve_name` declares a free name at the top level only after failing to find one there. The index
therefore answers exactly what the scan's first-match-in-pool-order answered, rather than merely
agreeing on the measured cohorts. Auxiliary relations, which binarization pushes directly, are not
entered in the index and carry a zero filter: binarization runs after the build pass, which owns
every name resolution, so nothing probes the index again, and an auxiliary has no name parts and a
rule's span rather than a spelling's, so a probe that did reach one could only have matched by
accident.

**Shapes considered and not built.** A per-module chained bucket list keyed on the owner alone would
have kept the spelling comparison in the loop and merely shortened it, which is the wrong axis: the
comment-string cohort has one owner. Sorting the relation pool by spelling and binary-searching it
would have made the pool order — which the canonical form and the backend both read — depend on the
spellings, so the fingerprint would have moved for a reason that has nothing to do with the lowered
program. Re-using admission's symbol index directly was rejected because the lowering's key is
`(owner, spelling)` over its own relation ids and admission's is a spelling over symbol ids with
shadow flags; sharing the table would have coupled two stages' capacity bounds and two different
notions of owner.

**The index's clear is the one cost paid by a cohort that gains nothing.** It is 2,048 `u32` beside
the value index's existing 8,192, in the same in-place loop, outside every traversal. Clearing only
the slots the previous lowering wrote would need either the slot stored in each `Relation` record or
a re-hash of every previous spelling; both cost more than the bulk clear at these bounds, and the
bulk clear is the shape admission already uses.

### Candidate 3 as built, and why it exists

Candidate 3 is not in the task plan. Candidate 1's measurement put it there: the comment-string
stage difference fell by only half, and widening the profile showed a second scan over the same
896 × 895 / 2 pairs in `passes::mangle`, carrying a libc `bcmp` on its common path.

`Rir` gains a `mangled_index` pool, sized like the relation index from `Limits::relations`, but
sized and cleared inside `mangle` rather than in `Rir::clear`, because `mangle` is the only pass that
writes it and a lowering that fails before the closing pass should not pay for it. Each relation's
mangled name is hashed with FNV-1a over the IR's own byte pool, probed once, and — when the probe
found an equal name — disambiguated by appending the relation id and re-probed under the new name's
hash, so a later relation is compared against the disambiguated spelling exactly as before. The
entry is written only after `output[index]` names the final span, so every probe reads a span that
is written. The byte comparison is an explicit loop, which is what removes the `bcmp`.

**Exactness.** The old scan set a boolean on the first earlier equal name; the index sets it on any
equal name, and for a boolean those are the same question. A new fixture,
`two_relations_that_mangle_to_one_name_are_disambiguated`, drives the collision path directly:
`M:link` and a top-level definition spelled `M_link` both flatten to `M_link`, and the test asserts
that no two relations share a backend name and that one of them carries the id suffix. Nothing in
the parity corpus moved.

### Candidate 2 as built

`Workspace` gains a `module_nodes` pool of node ids, reserved to `Limits::symbols` and cleared by
`admit` beside `definitions`. Admission's single declaring scan of the node pool already branches on
`NodeKind::Module`; it now pushes the node id in that arm, exactly as the `NodeKind::Definition` arm
has always pushed into `definitions`, and under the same overflow argument: `declare` has already
taken a symbol slot for the node and fails with `SymbolCapacity` when there is none, and the pool is
reserved to that same bound, so the push cannot overflow and no new failure path exists.
`build::declare_modules` then walks that list instead of sweeping the node pool. Ascending node id
is source order and is the order the sweep visited them in, so the first failure is still the first
in source order and `module_name`'s rejection of a qualified module header fires on the same node.

**Shapes considered and not built.** The task plan suggested a push at `Module` node creation in the
parser, which writes the node and would run once per module in a place that is already hot. It was
read and rejected on capacity, not on cost: the parser has no symbol bound to hang the pool on, so
the list would have to be reserved at `Limits::nodes` — 2 MiB rather than 64 KiB — to guarantee that
the node push fails before the list does, or it would introduce a capacity failure the parser does
not have today. In the loop the two are equal, one push per module node, and on all six measured
cohorts that push executes zero times because none of them declares a module. Recording the list
inside the lowering itself, on a first pass that then feeds later ones, was not considered further
because it is the sweep this candidate removes.

## Method

Seven interleaved rounds through the committed harness `analysis/rel-frontend/bench.py`, all five
frozen cohorts plus `datalog`, both scanner variants, `--stages scan,parse,admit,lower`, pinned to
CPU 5, two-point differencing between N and N/2 iterations, and the non-multiplexing event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` — two fixed counters, two
general-purpose and two software, which is what runs at 100 per cent enabled on this PMU. Rounds
alternate candidate and control order and byte and scalar order, and each cohort carries a
byte-over-byte A/A null pair built from the `parse` stage, so every run carries its own noise floor.
Host: AMD Ryzen AI 9 HX 370, kernel 7.2.4, rustc 1.95.0 (59807616e 2026-04-14) on both arms.

Both arms run with a clean working tree, so no foreign uncommitted file enters either build; that is
a change from the milestone, whose two arms shared fifteen foreign files.

The driver's fingerprint gate is armed on every measured operation: the harness refuses to report
when candidate and control disagree on tokens, nodes, the failure record, the admission outcome or
the lowering fingerprint, and neither candidate here declared a representation change, so an
agreeing run is itself the exactness evidence for every cohort and both variants.

Stage costs are read as differences — `lower` minus `admit`, `admit` minus `parse` — because the
workspace builds with ThinLTO and one codegen unit, so a change anywhere in the module summary can
move untouched stages by a per cent or more; a difference of two stages that share the shifted code
does not move with it.

**An interruption to record.** The first attempt at the candidate-1 A/B calibrated all 56 operations
and then died at the first measured round with `FileNotFoundError: 'perf'`. `perf` resolves through
`~/.nix-profile/bin` and was present before and after, so the profile was swapped under the run by
another session on this shared box. No partial receipt was written and the run was repeated from
the start; nothing from the interrupted attempt is used.

## Results

### Candidate 1 — the relation index, `d8d9308` against `4b8cfd7`

Receipt: `analysis/rel-frontend/performance-v1-relindex-d8d9308.json`. A/A instruction nulls
1.000000 / 1.000000 / 1.000000 / 0.999999 / 0.999999 / 0.999994 on the six cohorts, so the protocol
carries its own noise floor at a few parts per million and a tenth-of-a-per-cent effect is readable.
The fingerprint gate agreed on tokens, nodes, failure record, admission outcome and lowering
fingerprint for every operation on both scanner variants.

Stage differences, instructions per iteration, byte scanner. The scalar column is the same
measurement through the scalar scanner and is given where it differs in the fourth digit.

| Cohort          | `lower`−`admit` control | `lower`−`admit` candidate |   Ratio | Per source byte after | Per source byte before |
|-----------------|------------------------:|--------------------------:|--------:|----------------------:|-----------------------:|
| ascii           |                  79,209 |                    79,566 |  1.0045 |                  1.85 |                   1.84 |
| unicode         |                  79,975 |                    80,344 |  1.0046 |                  1.30 |                   1.29 |
| comment-string  |              18,677,398 |                 9,059,804 |  0.4851 |                138.09 |                 284.66 |
| malformed-early |                       4 |                        −1 |     n/a |                  0.00 |                   0.00 |
| malformed-late  |                      −1 |                         0 |     n/a |                  0.00 |                   0.00 |
| datalog         |               1,299,538 |                 1,347,095 |  1.0366 |                 84.54 |                  81.56 |

The scalar variant gives 79,563 / 80,350 / 9,059,804 / 1,347,095 for the same four cohorts, so the
result does not depend on which scanner produced the tokens.

Every earlier stage is unmoved. `scan`, `parse` and `admit` candidate-over-control ratios are
1.00000 on every cohort and both variants, the largest departure being 0.99997 on the `datalog`
scan, which is at the level of that cohort's null. The whole-stage `lower` ratios are 0.53169 (byte)
and 0.54385 (scalar) on comment-string, 1.00842 and 1.00767 on datalog, and within one part in ten
thousand of unity elsewhere. Cycles move with instructions: the comment-string `lower` stage goes
from 3,123,418 to 1,743,212 cycles.

**The Fermi was wrong, and the way it was wrong is the finding.** I predicted the comment-string
difference would fall to about 285,000 instructions, a ratio near 0.015. It fell to 9,059,804, a
ratio of 0.4851 — the candidate removed 9,617,594 instructions, which over the 400,960 comparisons
the scan performed is **23.99 instructions per comparison**, not the 46 the model assumed. And
18,677,398 / 400,960 is 46.58, which is exactly the milestone's figure. So the milestone's "about
400,000 spelling comparisons at roughly 46 instructions each" was measuring the sum of *two*
quadratic scans over the same 400,960 pairs, and attributing both to one of them.

Widening the profile, as the playbook requires when measurement disagrees materially, found the
second one immediately. `passes::mangle` breaks a collision between two relations' mangled backend
names with `for earlier in 0..index`, comparing `rir.output[earlier]`'s length and then the bytes.
It is the same 896 × 895 / 2 pairs, and at 22.6 instructions each it is the whole of the 9,059,804
that remains. Its byte comparison is a slice equality over a runtime length, and the disassembly of
`lower::run` in the candidate binary shows it: **one `bcmp@GLIBC_2.2.5` call inside the loop**, at
`0x7efe12`, reached after the length test at `0x7efde7`. That is a libc call on a hot loop's common
path, which the contract forbids outright, and it is why this cohort's names — `label0` through
`label895`, four distinct lengths over 896 names — reach the byte comparison on most pairs rather
than being rejected on length.

This is dealt with as candidate 3 below. It is not in the task plan; the measurement put it there.

**The `datalog` loss, which was predicted in direction and missed in sign.** I predicted a saving
near 22,000 instructions on `datalog` and measured a loss of 47,557. The cause is in the compiled
loop and is not in doubt. `declare` on that cohort resolves the spelling `edge` 512 times against a
pool whose first entry is `edge`, so the scan answered on its first comparison; the index instead
hashes the spelling before it can probe at all. The disassembly of `probe_relation` gives the hash
loop as eight instructions per spelling byte — `movzbl`, `xor`, `imul`, `inc`, `cmp`, `jne` plus the
`cmp`/`jae` of the source bounds check — so about 780 resolutions of a four-to-eight-byte spelling
pay roughly 60 instructions each that the scan did not, which is the 47,557 to within a few per
cent. The index is a large win where the pool is large and a bounded loss where the pool is tiny and
the first comparison usually hits. That loss is 3.66 per cent of the `datalog` stage difference and
0.84 per cent of the whole `lower` stage.

**What it cost the cohorts that gain nothing.** ascii and unicode pay 357 and 369 more instructions
per lowering, which is the new index's bulk clear, and is what the Fermi said it would be.

**Reservation.** `prepare` — allocate a workspace and drop it — is 1.02363× the control
(interval [1.02356, 1.02370]); retained bytes go from 10,324,492 to 10,332,684, the 8,192 bytes of
the new index. That is a reservation cost paid once per workspace, not a per-source cost.

### Candidate 2 — the module index, `6e06a24` against `d8d9308`

Receipt: `analysis/rel-frontend/performance-v1-moduleindex-6e06a24.json`. A/A instruction nulls
1.000001 and 1.000000 on ascii and unicode and at that level on the rest. Fingerprint gate agreed on
every operation and both variants.

| Cohort          | `lower`−`admit` control | `lower`−`admit` candidate |  Ratio | `admit`−`parse` control | `admit`−`parse` candidate |  Ratio |
|-----------------|------------------------:|--------------------------:|-------:|------------------------:|--------------------------:|-------:|
| ascii           |                  79,564 |                     6,229 | 0.0783 |               1,258,884 |                 1,259,915 | 1.0008 |
| unicode         |                  80,348 |                     6,243 | 0.0777 |               1,446,303 |                 1,447,342 | 1.0007 |
| comment-string  |               9,059,801 |                 9,031,829 | 0.9969 |                 409,054 |                   409,575 | 1.0013 |
| malformed-early |                      −0 |                         2 |    n/a |                       3 |                         0 |    n/a |
| malformed-late  |                      −1 |                         1 |    n/a |                       1 |                         1 |    n/a |
| datalog         |               1,347,097 |                 1,317,835 | 0.9783 |               3,186,005 |                 3,186,601 | 1.0002 |

The scalar variant reproduces every figure to the fourth digit (6,225 / 6,240 / 9,031,836 /
1,317,835). `scan` and `parse` are 1.00000 on every cohort and both variants. Whole-stage `lower`
candidate-over-control: 0.98197 ascii, 0.99296 unicode, 0.99749 comment-string, 0.99497 datalog,
1.00000 on both malformed cohorts.

**Where the cost went, counted rather than assumed.** Admission rose on every cohort, and the
receipt separates the two reasons. The comment-string and `datalog` cohorts declare **no modules at
all**, so admission's new push never runs there, yet their `admit`−`parse` difference still rose by
521 and 596 instructions: that is the ThinLTO layout effect the playbook warns about, and it is why
a stage is read as a difference rather than alone. ascii and unicode declare **64 modules each**,
and their admission rose by 1,031 and 1,039 — about 510 more than the zero-module cohorts, or
roughly eight instructions per module node, which is the push and its capacity test. Against that,
ascii's lowering dropped 73,335 instructions. The exchange is 8 instructions in admission for about
1,150 in the lowering, per module, on this cohort.

**My Fermi contained a factual error and the receipt corrected it.** I wrote that none of the six
cohorts declares a module and that `declare_modules` would therefore be entered and left in under
ten instructions. The admission record says ascii and unicode declare 64 modules apiece; I had
checked comment-string and `datalog`, found none, and generalized. That is why the residual is 6,229
rather than the 1,000 to 4,000 I predicted: about 2,600 of it is 64 genuine `module_name` calls that
the list still has to make, and the rest is `Rir::clear`'s pool clears and the walk to the second
definition where lowering rejects. The direction and the size of the saving were right; the
composition of the residual was not.

**Reservation.** `prepare` is 1.01125× the candidate-1 control; retained bytes go from 10,332,684 to
10,365,452, the 32,768 bytes of `module_nodes` at the bench's `Limits::symbols` of 8,192.

### Candidate 3 — the mangled-name index, `ec5d1d6` against `6e06a24`

Receipt: `analysis/rel-frontend/performance-v1-nameindex-ec5d1d6.json`.

| Cohort          | `lower`−`admit` control | `lower`−`admit` candidate |  Ratio | `admit`−`parse` ratio |
|-----------------|------------------------:|--------------------------:|-------:|----------------------:|
| ascii           |                   6,227 |                     6,230 | 1.0005 |                1.0000 |
| unicode         |                   6,245 |                     6,244 | 0.9999 |                1.0000 |
| comment-string  |               9,031,845 |                 1,833,277 | 0.2030 |                1.0000 |
| malformed-early |                      −1 |                        −4 |    n/a |                   n/a |
| malformed-late  |                       0 |                        −3 |    n/a |                   n/a |
| datalog         |               1,317,835 |                 1,313,492 | 0.9967 |                1.0000 |

The scalar variant reproduces every figure (6,231 / 6,258 / 1,833,276 / 1,313,492). `scan`, `parse`
and `admit` are unity on every cohort and both variants — this candidate touches only the closing
pass, and the receipt says so.

The comment-string difference fell by 7,198,568 instructions, which over the same 400,960 pairs is
**17.95 instructions per pair**. Together with candidate 1's 23.99 that is 41.94 of the milestone's
46.58, and the remainder is the per-relation work neither scan was doing. The `datalog` saving of
4,343 instructions is the same mechanism at 14 relations: 91 pairs, most of them reaching the call.

## Composed: `ec5d1d6` against the `4b8cfd7` control

Receipt: `analysis/rel-frontend/performance-v1-lower-composed-ec5d1d6.json`. Seven interleaved
rounds, same protocol, A/A nulls at 1.000001 and below.

| Cohort          | `lower`−`admit` before | `lower`−`admit` after |  Ratio | Per source byte before | Per source byte after |
|-----------------|-----------------------:|----------------------:|-------:|-----------------------:|----------------------:|
| ascii           |                 79,209 |                 6,228 | 0.0786 |                   1.84 |                 0.145 |
| unicode         |                 79,978 |                 6,244 | 0.0781 |                   1.29 |                 0.101 |
| comment-string  |             18,677,419 |             1,833,276 | 0.0982 |                 284.66 |                 27.94 |
| malformed-early |                     13 |                    −1 |    n/a |                   0.00 |                  0.00 |
| malformed-late  |                     −1 |                    −1 |    n/a |                   0.00 |                  0.00 |
| datalog         |              1,299,541 |             1,313,490 | 1.0107 |                  81.56 |                 82.43 |

Whole-stage `lower`, candidate over control, instructions:

| Cohort          |    Byte |  Scalar |
|-----------------|--------:|--------:|
| ascii           | 0.98205 | 0.98657 |
| unicode         | 0.99299 | 0.99351 |
| comment-string  | 0.17984 | 0.20114 |
| malformed-early | 1.00000 | 1.00000 |
| malformed-late  | 1.00000 | 1.00000 |
| datalog         | 1.00257 | 1.00235 |

Earlier stages, candidate over control: `scan` and `parse` are 1.00000 on every cohort and both
variants (extremes 0.99998 and 1.00001, at the level of the nulls). `admit` is 1.00026 / 1.00010 /
1.00027 / 1.00001 / 1.00000 / 1.00014 on the six cohorts, byte variant, which is candidate 2's
module push on the two cohorts that declare modules and a ThinLTO layout shift on the ones that do
not; as `admit`−`parse` differences the same figures are 1.0008 / 1.0007 / 1.0013 / 1.0002.

**The `datalog` net is a loss of 1.07 per cent on the stage difference and the arithmetic closes
exactly.** Candidate 1 cost 47,557 instructions, candidate 2 saved 29,262 and candidate 3 saved
4,343, for a predicted net of +13,952 against the measured +13,949. That cohort has 14 relations, no
modules and 512 clauses of one spelling, so it is the shape every one of these three candidates is
worst on, and it is the shape the milestone built to price a lowering that completes. It is reported
as the loss it is.

**`prepare` is 1.06026× the control** (interval [1.06018, 1.06033]); retained bytes go from
10,324,492 to 10,373,644 — the relation index, the mangled-name index and `module_nodes`. That is
reserved address space charged once per workspace, not per source.

## Scaling: the quadratic becomes linear

*(filled in)*

## Disposition

*(filled in per candidate)*

## Instructive negatives

1. **The relation index loses on a cohort with few relations, and it was kept anyway.** `datalog`
   pays 47,557 more instructions per lowering, 3.66 per cent of its stage difference and 0.84 per
   cent of the whole `lower` stage, because the index hashes a spelling the scan would have matched
   on its first comparison. The decision to keep is not that the loss is small: it is that the loss
   is bounded by the call count while the win it buys is quadratic in the relation count, so the
   arms cross at a pool size of a few relations and never cross back. The bounded loss is design
   evidence and is recorded rather than tuned away.
2. **A cheap fix for that loss is visible and was not taken, because it is a separate change.** The
   hash loop costs eight instructions per byte, two of which are the source bounds check that
   `hash_span` pays on every iteration because it indexes `source[i]`. Taking the subslice once
   before the loop moves that check outside it and should take the per-byte cost to five or six,
   which would roughly halve the `datalog` loss. It also applies to `same()` and to admission's own
   `hash_of`, so it is a frontend-wide change with its own A/B, not a rider on this one.
3. **A profile-share cost model drove a Fermi that was wrong by a factor of thirty-two on the
   residual.** Predicting 285,000 and measuring 9,059,804 is not a small miss, and the reason it did
   not derail the task is that it was written down before the code, so the disagreement was
   immediately legible as a model failure rather than as a measurement anomaly. Widening the profile
   found the second scan within one disassembly.
4. **"No cohort declares a module" was asserted and is false.** ascii and unicode declare 64 modules
   each, which the admission record in every receipt says plainly. The Fermi checked two cohorts,
   found none, and generalized to six. It did not change a decision — candidate 2 wins either way —
   but it made the predicted residual wrong by the 2,600 instructions of 64 genuine `module_name`
   calls.
5. **A run was lost to the shared box.** The first candidate-1 A/B calibrated all 56 operations and
   then died at the first measured round because `perf` disappeared from `~/.nix-profile/bin`
   mid-run. Nothing partial was used; the run was repeated from the start.

## Mystery ledger

1. **Settled, and it reverses the milestone's attribution.** The milestone report priced the
   comment-string lowering as "about 400,000 spelling comparisons at roughly 46 instructions each"
   in `find_relation`. There were two scans over those same 400,960 pairs, not one: `find_relation`
   at 23.99 instructions per pair and `passes::mangle`'s collision check at 17.95, measured as the
   two candidates' savings. 46.58 was their sum. Neither figure was wrong; the attribution to a
   single site was. The lesson is the playbook's own: a per-unit cost inferred by dividing a stage
   by a count identifies a candidate and does not price it, because another site may be visiting the
   same units.
2. **Settled: there was a libc call on a hot loop's common path and no profile had shown it.** The
   milestone's kernel profile listed `__memcmp_evex_movbe` at 0.03 per cent, below the rendering
   limit, and concluded from the source that no slice comparison existed in the lowering loops. One
   did: `rir.mangled[a..b] == rir.mangled[c..d]` in `mangle`, which the compiler lowered to `bcmp`,
   visible in the disassembly of `lower::run` at `0x7efe12`. The source-level check missed it
   because it looked for `copy_from_slice`, `extend_from_slice`, `clone` and `to_vec` and not for
   slice equality. *Settled by*: the disassembly; the call is gone in `ec5d1d6`.
3. **Settled by counting the compiled body: interning does not cost about 330 instructions.**
   The milestone left open why `build::intern` appeared to cost ~330 instructions per constant,
   noting that figure was a profile share divided by a counted unit and that the shape had misled
   this lane before. The disassembly of `intern` in `ec5d1d6` is 256 instructions in total. Along the
   integer path — the one the `datalog` cohort takes — entry through the fully unrolled eight-step
   hash is 49 instructions, the probe setup is 27, one probe step is 16, and the push tail that
   writes the 32-byte `Value` and updates the length is about 25, so a call that misses and pushes
   is **roughly 115 instructions** and one that hits on the first probe is about 95. The text path
   is dearer: the spelling hash is 8 instructions per byte, a probe step is 39, and the spelling
   comparison inside it is 13 per byte, so a 50-byte string literal costs on the order of 500.
   The compiled body therefore prices the integer case at about a third of 330, which is the
   signature of sample skid landing on the call, exactly as the milestone suspected. *Still open*:
   the cohort-level claim. Pricing what interning contributes to a measured stage needs the
   synthetic single-class sources at two lengths that the playbook prescribes, and this task did not
   run them; it ran the disassembly count that the playbook names as the check on the guess. *Owner*:
   whoever next touches the value dictionary. One concrete lead is in the listing above: the `Value`
   push compiles to nine separate stores, including two four-byte zeroes for the record's
   `reserved: [0; 7]` padding, rather than two sixteen-byte stores.
4. **Settled: the index is a loss where the relation pool is tiny, and the cause is the hash.**
   Predicted a 22,000-instruction saving on `datalog`, measured a 47,557-instruction loss. The
   compiled hash loop is eight instructions per spelling byte — six for the FNV step and two for the
   source bounds check — so about 780 resolutions of a short spelling pay roughly 60 instructions
   that the linear scan, which answered on its first comparison, did not. *Not open*: the mechanism
   is read from the disassembly and the arithmetic closes. What is open is whether to act on it; see
   the next section.
5. **Open: admission's own quadratic on repeated `def` clauses, unchanged and now the largest single
   number in the composed stage.** The milestone found that `admit::insert` puts every clause of one
   relation on one home slot, so the `datalog` cohort's 512 clauses of `edge` walk a 512-entry probe
   chain, and admission costs 199.95 instructions per source byte there against 29.27 on ascii. That
   is admission's, it cancels in every stage difference in this report, and nothing here touched it.
   Now that the lowering's two quadratics are gone it is the only one left in the frontend.
   *Evidence gap*: none about the mechanism, which a fourfold-per-doubling scaling run already
   confirmed; the remedy — a second probe, chained buckets, or an owner-mixed key like the one
   candidate 1 uses — is unmeasured. *Owner*: a successor in this lane.
6. **Open: `qualified` still resolves a module by scanning `rir.modules` linearly.**
   `build::qualified` finds a module with `rir.modules.iter().find(…)` for each step of a qualified
   name, and `resolve_name` walks the module chain. No measured cohort exercises it at scale —
   ascii and unicode declare 64 modules but reject before the body phase — so there is no
   measurement here saying it costs anything. It is the same shape as the two scans this task
   removed, and it is named so that a cohort which does exercise it is not a surprise.
   *Evidence gap*: a cohort with many modules and many qualified references, which does not exist.
7. **No mystery remains about exactness.** Every arm agreed with its control on tokens, nodes, the
   failure record, the admission outcome and the lowering fingerprint, on six cohorts and both
   scanner variants, and the parity corpus is byte-identical at 213 cases and the same canonical
   SHA-256 through all three candidates.

## Replay commands

Run from `~/src/ergodis-private`. Every gate and every measurement ran under
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so gate and measurement describe one build.

```sh
# The arms. Each is the retain recipe at its own revision, with the tree clean.
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools     # at 4b8cfd7, d8d9308, 8ea0325

# Gates.
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_lowering --test rel_frontend --test rel_frontend_portability -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private --lib --tests -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo clippy -p ergodis-tools --bins -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check
python3 tests/support/rel_closure_oracle.py --check tests/support/rel-closure-expected.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output analysis/rel-frontend/portability-v1.json

# The three A/Bs. E is the non-multiplexing event set.
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
C=~/.cache/ergodis/bin
COHORTS=ascii,unicode,comment-string,malformed-early,malformed-late,datalog
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary $C/ergodis-tools-d8d9308 --control $C/ergodis-tools-4b8cfd7 \
    --rounds 7 --cpu 5 --cohorts $COHORTS --stages scan,parse,admit,lower --events $E \
    --out analysis/rel-frontend/performance-v1-relindex-d8d9308.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary $C/ergodis-tools-8ea0325 --control $C/ergodis-tools-d8d9308 \
    --rounds 7 --cpu 5 --cohorts $COHORTS --stages scan,parse,admit,lower --events $E \
    --out analysis/rel-frontend/performance-v1-moduleindex-8ea0325.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary $C/ergodis-tools-8ea0325 --control $C/ergodis-tools-4b8cfd7 \
    --rounds 7 --cpu 5 --cohorts $COHORTS --stages scan,parse,admit,lower --events $E \
    --out analysis/rel-frontend/performance-v1-lower-composed-8ea0325.json

# The scaling probes: the quadratic against the linear, at four definition counts.
for N in 64 128 256 512; do
  nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
      --binary $C/ergodis-tools-8ea0325 --control $C/ergodis-tools-4b8cfd7 \
      --rounds 3 --cpu 5 --definitions $N --cohorts comment-string,ascii \
      --stages parse,admit,lower --events $E \
      --out analysis/rel-frontend/performance-v1-lower-scaling-$N-8ea0325.json
done

# The kernel-scoped profiles.
mkdir -p ~/.cache/ergodis/perf-c1190
perf record -q -e instructions:u -F 4000 \
    -o ~/.cache/ergodis/perf-c1190/lower-comment-string-8ea0325.data -- \
    taskset -c 7 $C/ergodis-tools-8ea0325 rel-frontend-bench --cohort comment-string \
    --stage lower --variant byte --definitions 512 --repeat 2000
perf report -i ~/.cache/ergodis/perf-c1190/lower-comment-string-8ea0325.data --stdio -g none \
    --percent-limit 0.05
```

## Gates

*(filled in)*

## What this task left under `~/.cache/ergodis/`

*(filled in)*
