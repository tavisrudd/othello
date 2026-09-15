# C1190 lowering kernel candidates — the relation index, the module index, and the mangled-name index

**Lane**: `ergodis`
**Date**: 2026-09-15
**Status**: COMPLETE. Three kernel candidates built, priced before the code, measured against
retained controls and all three kept. The comment-string cohort's lowering stage difference falls
from 18,677,419 to 1,833,276 instructions — a ratio of 0.0982 — and its scaling goes from fourfold
to twofold per doubling of the definition count, which is the quadratic becoming linear. The ascii
and unicode stage differences fall to 0.0786 and 0.0781. The `datalog` cohort is a net 1.07 per cent
loss, reported as such. Written incrementally from the start of the task, so a crash would have left
a partial record rather than none.

**Repository**: `~/src/ergodis-private` (private, no remote), consuming `~/src/ergodis` read-only.
Rules: `~/src/ergodis-dev/PERFORMANCE.md` and `~/src/ergodis-dev/performance-playbook.md`.

**Predecessor**: `2026-09-15-c1190-milestone-a.md`. This task takes its "Remaining gaps" 1 and 2 —
the quadratic relation scan and the node-pool sweep every lowering pays — and prices, builds and
measures each as a kernel candidate against a retained control.

**Commits**: private `ergodis-private` `d8d9308`, `b689c85`, `6e06a24`, `154b827`, `ec5d1d6`,
`38b025f`, `a93ae96`, from `4b8cfd7`. Three source commits, one per candidate, and four receipt
commits. Full table in the disposition section below.

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

*(Everything above this line was written before any code. The measurements are in the Results
section; the comment-string prediction was wrong by a factor of thirty-two and that is what found
candidate 3, the ascii and unicode predictions were right in direction and low in the residual, and
the datalog prediction had the wrong sign.)*

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

Four runs at 64, 128, 256 and 512 definitions, three rounds each, candidate and control interleaved,
`--stages parse,admit,lower`. Receipts `analysis/rel-frontend/performance-v1-lower-scaling-<N>-ec5d1d6.json`.
The figure is the `lower` minus `admit` instruction difference, byte scanner.

Comment-string, which is where both quadratics lived:

| Definitions | Before (`4b8cfd7`) | Ratio to previous | After (`ec5d1d6`) | Ratio to previous |
|------------:|-------------------:|------------------:|------------------:|------------------:|
|          64 |            468,517 |                 — |           225,002 |                 — |
|         128 |          1,397,970 |              2.98 |           451,058 |              2.00 |
|         256 |          4,749,336 |              3.40 |           910,412 |              2.02 |
|         512 |         18,677,417 |              3.93 |         1,833,278 |              2.01 |

The before column rises towards fourfold per doubling, which is what a quadratic converges to once
the linear term stops mattering. The after column is 2.00, 2.02, 2.01 — linear, to within a per
cent, across three doublings. That is the claim this task set out to establish and it does not rest
on one cohort size.

ASCII, where the node-pool sweep lived:

| Definitions | Before (`4b8cfd7`) | Ratio to previous | After (`ec5d1d6`) | Ratio to previous |
|------------:|-------------------:|------------------:|------------------:|------------------:|
|          64 |             11,455 |                 — |             2,705 |                 — |
|         128 |             21,137 |              1.85 |             3,194 |              1.18 |
|         256 |             40,488 |              1.92 |             4,213 |              1.32 |
|         512 |             79,208 |              1.96 |             6,224 |              1.48 |

The before column is linear in the node count, as the milestone's audit found. The after column is
sublinear because what remains is no longer proportional to the source: `Rir::clear`'s two index
clears are proportional to `Limits` and not to the input, and they are most of the 2,705 at 64
definitions. The part that still grows is the modules the cohort declares.

## Kernel-scoped profile after, and where the saving went

`perf record -e instructions:u -F 4000`, pinned to CPU 7, on the `lower` stage of `ec5d1d6`, which
runs the scanner, the parser, admission and the lowering, so the lowering's symbols are read as a
group. Profile data under `~/.cache/ergodis/perf-c1190/`.

**Comment-string, 512 definitions, 4,000 iterations** (`lower-comment-string-ec5d1d6.data`), every
symbol at or above a tenth of a per cent:

| Symbol                              | Share  |
|-------------------------------------|-------:|
| `lexer::scan`                       | 25.88% |
| `lower::run`                        | 24.37% |
| `parser::Parser::expression`        |  9.93% |
| `admit::run`                        |  5.29% |
| `lower::build::intern`              |  4.36% |
| `lower::build::declare_relation`    |  3.49% |
| `lower::build::probe_relation`      |  3.46% |
| `admit::declare`                    |  2.97% |
| `lower::build::term`                |  2.90% |
| `lower::build::distribute`          |  2.84% |
| `lower::build::constant`            |  2.13% |
| `admit::admit`                      |  1.92% |
| `lower::build::copy_literal`        |  1.70% |
| `lower::build::formula`             |  1.37% |
| `parser::Parser::item`              |  1.05% |
| `admit::bind_list`                  |  1.02% |
| `core::str::converts::from_utf8`    |  0.99% |
| `lexer::keyword`                    |  0.96% |
| `lower::build::atom`                |  0.82% |
| `lower::build::resolve_name`        |  0.62% |
| `parser::Parser::node`              |  0.47% |
| `lower::build::leading_columns`     |  0.41% |
| `lower::build::record_column_types` |  0.32% |
| `lower::build::check_arity`         |  0.26% |
| `parser::parse`                     |  0.26% |

The fourteen lowering symbols sum to 49.05 per cent; the stage difference puts the lowering at
1,833,276 of the composed `lower` stage's 3,693,372, or 49.64 per cent. The two methods agree to
six tenths of a point, which is what makes this profile an attribution rather than a picture.

**Out-of-line calls seen inside the lowering traversals**, listed as the contract requires:
`build::intern`, `build::declare_relation`, `build::probe_relation`, `build::term`,
`build::distribute`, `build::constant`, `build::copy_literal`, `build::formula`, `build::atom`,
`build::resolve_name`, `build::leading_columns`, `build::record_column_types`,
`build::check_arity`, `passes::clone_literal` and `Rir::fingerprint`. Every one is this stage's own
code and none is libc.

**The libc question, answered at threshold zero rather than at a rendering limit.** Rendered with
`--percent-limit 0`, the comment-string profile's only libc symbols are
`__memset_avx512_unaligned_erms` at 0.06 per cent — the three index clears and the stratifier's
resizes, all bulk operations proportional to a `Limits` bound and outside every traversal — and
`__memmove_avx512_unaligned_erms`, `_int_malloc`, `_int_free_create_chunk` and `cfree` at 0.00 per
cent, which are the driver's own startup and JSON output. **No `memcmp` and no `bcmp` appears at
any threshold**, which is a change from the control: the `bcmp` this task removed was in
`lower::run` at `0x7efe12` and is gone from the disassembly of `ec5d1d6`. The disassembly of
`probe_relation` confirms the same for the new code: its only calls are five
`panic_bounds_check` targets, all at the function's tail and off the common path.

**Datalog, 512 definitions, 2,000 iterations** (`lower-datalog-ec5d1d6.data`), top of the profile:
`admit::declare` 51.53 per cent, `parser::Parser::expression` 9.93, `lexer::scan` 8.40,
`lower::run` 7.47, `admit::run` 3.77, `lower::build::constant` 3.41, `lower::build::intern` 3.07,
`lower::build::probe_relation` 2.72, `Rir::fingerprint` 1.84. The eleven lowering symbols sum to
22.01 per cent against the stage difference's 23.19, agreeing to 1.2 points. `admit::declare` at
half the profile is admission's repeated-spelling quadratic, unchanged by this task and now the
largest single cost in the composed stage; it is mystery-ledger item 5.

**Where the saving went, on comment-string.** Before, `find_relation` and the inlined `mangle`
collision scan were the stage. After, the largest lowering symbol is `lower::run` itself — the
build loop with `mangle`, `close` and the per-relation passes inlined into it — and the two
replacements are visible and small: `probe_relation` at 3.46 per cent and `declare_relation`, which
now carries the index write, at 3.49. Interning a 50-byte string literal 896 times is 4.36 per cent
and is the largest single call the lowering still makes on this cohort.

## Disposition

All three candidates are **kept**, each by the forward commit that introduced it. Nothing was
reverted.

| Candidate                     | Commit    | Retained arm            | Verdict | Why                                                                                                                |
|-------------------------------|-----------|-------------------------|---------|--------------------------------------------------------------------------------------------------------------------|
| 1 — relation-resolution index | `d8d9308` | `ergodis-tools-d8d9308` | keep    | comment-string `lower`−`admit` 0.4851; bounded 3.66 per cent loss on `datalog`, which the design predicted in kind |
| 2 — module index in admission | `6e06a24` | `ergodis-tools-6e06a24` | keep    | ascii and unicode `lower`−`admit` to 0.078; 8 instructions per module node added to admission                      |
| 3 — mangled-name index        | `ec5d1d6` | `ergodis-tools-ec5d1d6` | keep    | comment-string `lower`−`admit` 0.2030 and one libc `bcmp` removed from a hot loop's common path                    |

Receipts, all committed under `analysis/rel-frontend/` in `ergodis-private`:
`performance-v1-relindex-d8d9308.json`, `performance-v1-moduleindex-6e06a24.json`,
`performance-v1-nameindex-ec5d1d6.json`, `performance-v1-lower-composed-ec5d1d6.json`, and
`performance-v1-lower-scaling-{64,128,256,512}-ec5d1d6.json`. Receipt commits `b689c85`, `154b827`,
`38b025f` and `a93ae96`.

Arms, each retained by `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at its own
revision with the working tree clean, `release`, no features, rustc 1.95.0 (59807616e 2026-04-14):

| Arm         | Revision  | Dirty | Measured sha256                                                    |
|-------------|-----------|-------|--------------------------------------------------------------------|
| control     | `4b8cfd7` | no    | `da7566ce09da1a7eb390ed56136ffb02306b6ad9698f7e075d75d78dc11b8fed` |
| candidate 1 | `d8d9308` | no    | `930691c5f6599b4bfad8e2bc2cb4161f45a98f488986a838da2fc4bf1197271f` |
| candidate 2 | `6e06a24` | no    | `37027ef76beec7c1de423f32e0f8178cdea89162aa69d2d744c768a931b9400f` |
| candidate 3 | `ec5d1d6` | no    | `9ac5cd1fb1142e22680429e1ec27045baea81c71e1b4aa76c296998b07d6058f` |

Every hash is recorded as measured, not cited; the thing to run is the retain recipe at the named
revision. No foreign uncommitted file was present in `ergodis-private` at any point during this
task, so every arm is reproducible from its commit alone — which is a change from the milestone,
whose two arms shared fifteen foreign files.

## Remaining next steps, in the order their evidence supports

1. **Admission's repeated-spelling quadratic.** `admit::declare` is 51.53 per cent of the composed
   `lower` stage on `datalog` and the mechanism is already confirmed by a fourfold-per-doubling
   scaling run. It is now the largest single cost in the frontend and the only quadratic left in it.
   The key that candidate 1 uses — the owner mixed into the spelling hash — is one candidate remedy
   and is unmeasured.
2. **Take the source bounds check out of the spelling hash and comparison loops.** `hash_span`,
   `same` and admission's `hash_of` index `source[i]` inside their loops, which costs two of the
   eight instructions per byte the disassembly shows. Taking the subslice once moves the check
   outside. It would roughly halve candidate 1's `datalog` loss and touches admission as well, so it
   is a frontend-wide change with its own A/B.
3. **The `Value` push writes nine stores for a 32-byte record**, including two four-byte zeroes for
   its `reserved: [0; 7]` padding. Interning is the largest single call the lowering still makes on
   comment-string.
4. **`build::qualified` still scans `rir.modules` linearly** for each step of a qualified name. No
   cohort exercises it at scale, so there is no measurement saying it costs anything; it is the same
   shape as the two scans this task removed.

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
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools     # at 4b8cfd7, d8d9308, 6e06a24, ec5d1d6

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
    --binary $C/ergodis-tools-6e06a24 --control $C/ergodis-tools-d8d9308 \
    --rounds 7 --cpu 5 --cohorts $COHORTS --stages scan,parse,admit,lower --events $E \
    --out analysis/rel-frontend/performance-v1-moduleindex-6e06a24.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary $C/ergodis-tools-ec5d1d6 --control $C/ergodis-tools-6e06a24 \
    --rounds 7 --cpu 5 --cohorts $COHORTS --stages scan,parse,admit,lower --events $E \
    --out analysis/rel-frontend/performance-v1-nameindex-ec5d1d6.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary $C/ergodis-tools-ec5d1d6 --control $C/ergodis-tools-4b8cfd7 \
    --rounds 7 --cpu 5 --cohorts $COHORTS --stages scan,parse,admit,lower --events $E \
    --out analysis/rel-frontend/performance-v1-lower-composed-ec5d1d6.json

# The scaling probes: the quadratic against the linear, at four definition counts.
for N in 64 128 256 512; do
  nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
      --binary $C/ergodis-tools-ec5d1d6 --control $C/ergodis-tools-4b8cfd7 \
      --rounds 3 --cpu 5 --definitions $N --cohorts comment-string,ascii \
      --stages parse,admit,lower --events $E \
      --out analysis/rel-frontend/performance-v1-lower-scaling-$N-ec5d1d6.json
done

# The kernel-scoped profiles.
mkdir -p ~/.cache/ergodis/perf-c1190
perf record -q -e instructions:u -F 4000 \
    -o ~/.cache/ergodis/perf-c1190/lower-comment-string-ec5d1d6.data -- \
    taskset -c 7 $C/ergodis-tools-ec5d1d6 rel-frontend-bench --cohort comment-string \
    --stage lower --variant byte --definitions 512 --repeat 4000
perf record -q -e instructions:u -F 4000 \
    -o ~/.cache/ergodis/perf-c1190/lower-datalog-ec5d1d6.data -- \
    taskset -c 7 $C/ergodis-tools-ec5d1d6 rel-frontend-bench --cohort datalog \
    --stage lower --variant byte --definitions 512 --repeat 2000
perf report -i ~/.cache/ergodis/perf-c1190/lower-comment-string-ec5d1d6.data --stdio -g none \
    --percent-limit 0.05
```

The three A/Bs above are, in order, candidate 1 against the control, candidate 2 against candidate
1, and the composed tip against the control; the candidate-3 line between them measures the
mangled-name index against candidate 2.

## Gates

Every gate was run after each kept commit and again at the tip, `ec5d1d6`, from
`~/src/ergodis-private` under `nix develop ~/src/ergodis` (rustc 1.95.0). The table is the run at
the tip.

| Gate                                                                                                    | Outcome                                                                                                                      |
|---------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| `cargo test -p ergodis-private --test rel_lowering --test rel_frontend --test rel_frontend_portability` | 25, 28 and 1 passed, 0 failed (`rel_lowering` gained the mangled-name collision fixture)                                     |
| `cargo clippy -p ergodis-private --lib --tests -- -D warnings`                                          | no diagnostics                                                                                                               |
| `cargo clippy -p ergodis-tools --bins -- -D warnings`                                                   | no diagnostics                                                                                                               |
| `cargo fmt -p ergodis-private -p ergodis-tools -- --check`                                              | clean                                                                                                                        |
| Independent oracle                                                                                      | 8 fixtures agree with the committed expectations                                                                             |
| Native/WASM parity replay                                                                               | 213 cases, 433,805 canonical bytes, byte-equal, SHA-256 `04b5ebdd72fb08184f3143e3ca8393d207b9a6109c549e9806e1bfae02bb23b0`   |
| Allocation regression                                                                                   | `the_lowering_stage_does_not_allocate` observes zero, retained bytes unchanged                                               |
| Driver fingerprint gate                                                                                 | equal tokens, nodes, failure, admission outcome and lowering fingerprint on every cohort and both variants, in all four A/Bs |
| Stride assertions                                                                                       | `Relation` still 32 bytes, 4-byte aligned; the hash filter reuses its reserved half-word                                     |

The parity hash is the one the milestone recorded and it did not move through any of the three
candidates, which is the intended result: an index is not part of the canonical IR.

**On the allocation gate.** All three new pools are reserved by `Rir::new` or `Workspace::new`. The
relation index and the mangled-name index are sized on first use inside that reserved capacity, and
the test's warm-up already drives a full lowering over four sources before counting, so both are
sized before the counted loop begins. `module_nodes` is pushed rather than written and needs no
sizing pass. The gate still covers four of the stage's exit paths and not `REL0505`, exactly as the
milestone recorded; this task did not change that.

## What this task left under `~/.cache/ergodis/`

Retained executables, each with its `.sha256` sidecar and a `MANIFEST.tsv` row:
`bin/ergodis-tools-4b8cfd7` (the control), `bin/ergodis-tools-d8d9308`, `bin/ergodis-tools-6e06a24`
and `bin/ergodis-tools-ec5d1d6`. `ergodis-tools-ec5d1d6` is the control the next A/B in this lane
should use, and the earlier three are what make this report's three separate A/Bs re-runnable.

Profile data: `perf-c1190/lower-comment-string-ec5d1d6.data` and `perf-c1190/lower-datalog-ec5d1d6.data`,
the two kernel-scoped profiles the attribution above is read from. `perf-c1190/lower-datalog-41553c9.data`
is the milestone's and is named by its report, not by this one.

All of these are named by this report, so `scripts/cache-gc.sh` will show them as referenced. No
deletion was performed; that is the user's call.

## Vetting pass (2026-09-15, Fable, after the Opus run)

Every claim above was re-checked against the tree and the receipts before this report was accepted.

- **Gates re-run at `ec5d1d6`**: the three test targets pass (25, 28, 1), both Clippy runs are
  clean, `fmt --check` is clean, the oracle reports eight fixtures in agreement, and the parity
  replay reproduces 213 cases at the recorded canonical hash with the tree left clean.
- **Receipts re-derived**: the six composed `lower`−`admit` ratios and the `admit`−`parse` ratios
  were recomputed from `performance-v1-lower-composed-ec5d1d6.json` and match the tables above to
  every printed digit. The four retained arms are in `MANIFEST.tsv` as clean-tree builds at rustc
  1.95.0 with the hashes listed.
- **Code read**: the three indexes are reserved by `Rir::new`/`Workspace::new`, cleared inside
  reserved capacity, and probed with the explicit byte loops; `Relation` keeps its 32-byte stride
  with the hash filter in the formerly reserved half-word; `module_nodes` is bounded by the same
  symbol slot the module's declaration consumes; the `filter` field stays out of the canonical form,
  which the unchanged parity hash confirms.

**One defect found, older than this task, and fixed** (private `b7c26e5`, receipt
`analysis/rel-frontend/performance-v1-resolve-order-b7c26e5.json`). `build::resolve_name` probed the top level *before*
the module chain, so inside a module a bare name resolved to a top-level definition of the same
spelling ahead of the module's own member. The module-scope contract
(`2026-09-14-c1170-module-scopes.md`) is innermost owner first, and admission resolves that way. The
probe that exposed it:

```
def e = {(1, 2)}
def f(x) = e(x, _)
module M
  def f(x) = e(_, x)
  def g(x) = f(x)
end
```

At `ec5d1d6` the closure of `M:g` was `{(1)}`; it is now `{(2)}`, and the fixture
`a_module_member_shadows_a_top_level_definition_inside_the_module` in `tests/rel_lowering.rs` asserts
both that and the top-level reading. The loop now walks the chain from its innermost entry and probes
`TOP` last, keeping the top-level miss as the key the free-name declaration takes. No parity case had
this shape, so the canonical hash is unchanged (213 cases, `04b5ebdd72…02bb23b0`); a parity case for
it is a candidate addition, not made here because it would move the hash on a vetting commit.

A/B of `b7c26e5` against `ergodis-tools-ec5d1d6`, five rounds, CPU 5, the six-event
non-multiplexing set, all six cohorts and both variants, A/A instruction nulls within four parts per
million: `parse` and `admit` are 1.00000 everywhere; `lower`−`admit` is 6,227 → 6,226 on ascii,
6,243 → 6,242 on unicode, 1,833,280 → 1,831,740 on comment-string (0.9992) and 1,313,490 →
1,313,663 on `datalog` (1.0001). A wash, as a probe-order change on cohorts that never exercise the
module chain in the body phase should be. Retained as `ergodis-tools-b7c26e5` (measured sha256
`a8bae90c64ad43ece35f079a6ed2fd3074eb2e673ca19de9145759c266a5e336`), which is now the control for
the next frontend A/B.

Gates at `b7c26e5`: `rel_lowering` 26 passed, `rel_frontend` 28, `rel_frontend_portability` 1, 0
failed; both Clippy runs clean; `fmt --check` clean; parity 213 cases at the unchanged hash.

## Vibe check

Good, and better than the plan asked for. The two planned candidates both landed, and the first
one's measurement disagreeing with its Fermi by a factor of thirty-two is what found a third
quadratic and a libc call sitting on a hot loop's common path that no profile had shown. The
comment-string lowering is a tenth of what it was and scales linearly across three doublings. The
one blemish is a one per cent net loss on the `datalog` cohort, whose cause is understood to the
instruction and whose remedy is a named, separately measurable next step.
