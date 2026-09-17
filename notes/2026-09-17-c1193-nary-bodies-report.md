# C1193 — bodies of more than two atoms in the demand evaluator

**Lane**: `ergodis`
**Date**: 2026-09-17
**Status**: COMPLETE. Written incrementally from the start of the task, so a crash would have left a
partial record rather than none; the Fermi predictions below were written before any code.

**The headline.** A rule body of up to four atoms is joined directly, with no intermediate relation:
on the family where the intermediate dominates — a triangle, whose auxiliary must carry all three
variables to produce a result of tens — the derivation loop is **0.52 and 0.61 of the binarized
chain's instructions**, derives three to four orders of magnitude fewer tuples, converges in two
rounds instead of three, peaks at 71 MB instead of 192, and halves the whole-process gap to compiled
Soufflé from 4.39 to 1.92. On the two path families, where the intermediate is a real relation
rather than a scaffold, it is 0.93 to 0.96 in instructions and 0.74 to 0.78 in cache misses. The
two-atom path costs **1.7 to 2.1 per cent** of its instructions, which is stated as a loss rather
than rounded away; the first landing cost 11.6 and both of its mechanisms were found and repaired.
The C1189 differential decides every source under both policies with zero disagreements, and both
independent checkers accept every n-ary certificate.

Task card: `2026-09-16-c1193-nary-bodies.md`. Predecessors this builds on:
`2026-09-16-c1192-sparse-join-index-report.md` (the index kinds the join goes through),
`2026-09-16-c1198-workspace-sized-from-rows-report.md` and
`2026-09-17-c1200-c1198-repair-pass.md` (the workspace shape and the recompile-drift caveat),
`2026-09-15-c1189-reference-evaluator.md` (the differential harness and its generators),
`2026-09-15-c1190-milestone-a.md` (binarization through `order_positives`),
`2026-09-16-c1191-direct-constructor-report.md` (the direct `Demand` constructor).

Repositories: `~/src/ergodis` (core), `~/src/ergodis-private` (lowering, drivers, harnesses),
`~/src/ergodis-dev` (`PERFORMANCE.md`, the playbook, `retain-bin.sh`, `cache-gc.sh`), `~/src/othello`
(this report). Both code trees were clean at the start of the task, verified with
`git status --short`; no foreign uncommitted file was present in either.

## Arms

Every hash is recorded **as measured**, never cited: the thing to run is the retain recipe at the
named revision. Both controls were retained from clean trees **before the first source change of
this task**, at private `193ebd1` with core `e7116ba`, rustc 1.95.0 (59807616e 2026-04-14), release
profile, no features. Retain recipes, from `~/src/ergodis-private`:

```sh
../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
```

Both re-execute themselves inside `nix develop` of the core checkout, whose devShell asserts its
rustc equals the `rust-toolchain.toml` pin.

| Arm | Role | Private | Core | Dirty | Retained name | Measured sha256 |
| --- | --- | --- | --- | --- | --- | --- |
| control, derivation loop | the kernel A/B | `193ebd1` | `e7116ba` | no | `closure_ballpark-193ebd1` | `a29f36177039ddc372de9b49fad5de2994063167ef9c4306e05a428ac55bfbcf` |
| control, frontend and stratified backend | the Rel route | `193ebd1` | `e7116ba` | no | `ergodis-tools-193ebd1` | `ece06d113eefdf022c8465a950538b130e00c0ba32e4d325242cac1cf98bf01c` |
| candidate, derivation loop | every figure below | `cb11550` | `09a5c2b` | no | `closure_ballpark-cb11550` | `2888aecb8c9e80b370b42511ea7cffbd4bfaa25be7abab4c006fda5696dd1128` |
| candidate, frontend and stratified backend | the `datalog` rows | `cb11550` | `09a5c2b` | no | `ergodis-tools-cb11550` | `4c10145c54839a9793792b30a266c00ed0e9377d464a2c1624c63c9cf3080414` |
| superseded, the first landing | the variants table's first row | `4b854ff` | `089c6d9` | no | `closure_ballpark-4b854ff` | `00f6ed444440a2c487285b493d90f7e9c79a5a0dd1d845949e20ca8f6ca01e52` |
| superseded | cited by nothing | `e8f0e06` | `089c6d9` | no | `closure_ballpark-e8f0e06` | `4f6f54c12904cce92776209d05a404fe2a27fb25668b6450d2d15d5508f035c5` |

**Both trees were clean at every retain**, and `retain-bin.sh` recorded `clean` for each. Neither
arm carries a foreign uncommitted diff, so no ratio here is cancelling one. A foreign `cargo test`
from another session was running on the box during the first direct-path attempt and is visible in
that run's load average; every figure kept below was taken at loads of 0.51 to 5.28, recorded per
receipt, and instruction ratios decide.

**The derivation-loop control the handoff named is current, and the retain proves it.**
`closure_ballpark-193ebd1` is **byte-identical** to `closure_ballpark-aa04358`
(`a29f3617…c55bfbcf`), so the private receipts commit `193ebd1` is not a build input of that example
and the C1200 control is the control at private HEAD. The frontend control had to be re-retained, as
the task's own framing anticipated: `ergodis-tools-ed99963` was built against core `2be1e68`, and
core `e7116ba` changed the kernel it calls, so `ergodis-tools-193ebd1`
(`ece06d11…f98bf01c`) supersedes it.

### One thing the first retain found, before any source change

**The C1200 stagger probe left artifacts in the shared target directory that break a clean-tree
build of the private workspace.** The first retain attempt failed with eleven type errors of the
form "there are multiple different versions of crate `ergodis_verify` in the dependency graph",
naming `/home/tavis/.cache/ergodis/worktrees/c1200-stagger/ergodis/crates/verify/src/rule_contract.rs`
as one of them — a path that no longer exists, because C1200 removed both worktrees at its close.
The dependency graph itself is clean: `cargo tree -d -e normal --workspace` shows exactly one
`ergodis-verify`, at `/home/tavis/src/ergodis/crates/verify`. What was stale was the shared target
directory `~/.cache/ergodis/target/ergodis-private`, which the worktree build wrote into because the
worktree inherited the private repository's `.cargo/config.toml`; an `rmeta` built from the worktree
sat at the filename cargo expected for the current tree's unit and its mtime made the fingerprint
look fresh. This is exactly the stale-rlib failure the playbook names for concurrent checkouts
sharing a target directory. Repaired the way the playbook prescribes — **rebuild, never clean**: one
`touch` over the core's `crates/**/*.rs` invalidated the fingerprints, and the retain then succeeded
and reproduced `closure_ballpark-aa04358` byte for byte. No file was deleted and no target directory
was cleaned. Logged to the discovery track, because nothing about this task was looking for it.

## Commits

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `e9650e0` | this report's skeleton and the Fermi predictions, written before any code |
| `othello` | `71b55e5` | the controls retained, and the shared-target stale-artifact finding |
| `ergodis` | `d677a8b` | bodies of up to four atoms in the demand evaluator, and both checkers |
| `ergodis` | `089c6d9` | the three corpus cases the mutation pass showed the suite was missing |
| `ergodis-private` | `c3135f8` | binarization becomes a body policy; the differential decides both |
| `ergodis-private` | `e8f0e06` | the harnesses: one binary under two arguments, work counts that may differ, the three Soufflé programs |
| `ergodis-private` | `4b854ff` | the certificate size report reads every width from the program |
| `ergodis` | `09a5c2b` | the two-atom kernel pays nothing for the n-ary one: constant-index witness slots, `run_nary` out of line |
| `ergodis-private` | `cb11550` | re-pin the core at that repair, so the measured arm has a private revision to name it |
| `ergodis-private` | `26d2468` | the receipts |
| `othello` | `e9650e0` … `8a813fd` | this report, written incrementally |

## Fermi predictions, written before any code

Written from the compiled shape of `crates/rules/src/demand.rs` at core `e7116ba`, the C1182 and
C1192 per-candidate figures for the derivation loop, and the degree structure of the harness's
generators.

### 1. What the intermediate costs, and therefore what removing it can save

The lowering's binarization turns a body of `k` atoms into `k - 1` rules through `k - 2`
auxiliaries, and every auxiliary tuple is a **derived tuple**: a membership probe, a row-store
write, its witness columns, and an index insert at the next round boundary. The n-ary evaluator
does the same joins and emits only the head. So the saving is the auxiliaries' emit traffic and
their memory, not the join enumeration.

Take the two families the card names, on the harness's `sparse` density (three out-edges per node,
so `|e| = 3N` and the out-degree is 3).

**Path of three**, `p3(x,w) :- e(x,y), e(y,z), e(z,w)`. Binarized it is
`aux(x,z) :- e(x,y), e(y,z)` and `p3(x,w) :- aux(x,z), e(z,w)`. The first rule produces about `9N`
candidates and derives up to `9N` auxiliary tuples; the second produces about `27N` candidates.
The n-ary body produces about `9N` partial matches at its second level and about `27N` candidates
at its third, and emits only the `p3` tuples. So candidates fall by roughly a quarter (36N → 27N)
and derived tuples by the whole auxiliary relation. At the 30 to 60 instructions per candidate
C1182 and C1192 measured for this loop, I predict **0.70 to 0.85 of the instructions** and
**0.80 to 0.95 of the peak resident set** on this family, with the instruction ratio the decisive
one.

**Triangle**, `tri(x,y) :- e(x,y), e(y,z), e(z,x)`. Binarized the auxiliary must carry all three
variables — the suffix mask needs `z` for the last atom and `x, y` for the head — so
`aux(x,y,z) :- e(x,y), e(y,z)` is an arity-three relation of about `9N` tuples, and the result is
the triangles, of which a random digraph with out-degree three has on the order of tens whatever
`N` is. The last atom `e(z,x)` has both columns bound, so it is a membership probe and not a
bucket walk in either arm. Binarized therefore pays `9N` emits plus `9N` probes; n-ary pays `9N`
probes. I predict **0.35 to 0.55 of the instructions** here and a derived-tuple count smaller by
three orders of magnitude at `N = 4,096`. This is the family where the intermediate dominates, and
it is the headline the card is asking for.

**Path of four** gives the same shape one level deeper: two auxiliaries instead of one, about `27N`
first-level and `81N` second-level intermediate tuples against a result of about `81N`. I predict
**0.55 to 0.75**.

### 2. Free Join against a plain nested index join, priced before either is built

Free Join's leapfrog step pays for itself when several atoms constrain **the same unbound
variable** and the intersection of their buckets is much smaller than any one bucket — the
worst-case-optimal case. On every cohort reachable here the binding order leaves at most one atom
with an unbound key column, and the atoms after it are either bucket walks on a distinct variable
or fully bound membership probes, so there is nothing to intersect and leapfrog degenerates to the
nested plan plus its own bookkeeping.

Against that, leapfrog needs a structure the C1192 index is not. The shipped index is keyed on a
**column mask** — a counting-sorted CSR or a chained hash over the packed key of those columns —
and answers "the rows whose masked columns equal this key". Leapfrog needs, per attribute order, a
trie whose level `i` is sorted on attribute `i` and supports `seek`. Building one per relation per
attribute order, rebuilt at every round boundary for a relation that grows, is a second indexing
structure with its own reset, its own crossover policy and its own memory; C1192's own measurement
says a dynamic index's reset traffic is what decides its representation, so a per-round trie build
is exactly the cost that structure was chosen to avoid.

I therefore predict, before measuring, that the nested index join is within a small constant factor
of Free Join on everything the harness can reach, and that a Free Join landing would be priced by
its trie build rather than by its joins. **Plan: land the nested index join, measure it, and record
Free Join as a shape considered and not built with this pricing attached** — which is exactly the
latitude the card gives ("a plain nested generic join is an acceptable first landing if the
measurement says so"). The measurement that would overturn this is a cyclic body over relations
whose binding order cannot fully bind any atom after the first; I predict I will have to say that
no such cohort exists in this lane today and name it as the gap.

### 3. What the new kernel costs per unit

Per partial match the n-ary kernel adds, over what the binary kernel does: one read of the link
record (loop-invariant, resident in L1 for the whole delta scan), one branch on the link's
addressing kind (a run constant threaded as a field, predicted, about one instruction), the key
computation over the link's four ops (8 to 12 instructions), the bucket lookup (one load on a
direct kind), and per row yielded the op-binding loop (about 10 instructions) plus saving and
restoring the variable array across the descent (eight words each way).

That is 40 to 60 instructions per level, against the binary kernel's own 30 to 60 per candidate.
**I predict the n-ary join is not cheaper per candidate than the binary one** — it is 1.0 to 1.3
times as expensive per unit — and that the whole of the win in prediction 1 comes from emitting
fewer tuples. If the measurement shows the n-ary arm ahead by more than prediction 1 allows, the
cost model is wrong about the emit and I will widen the profile rather than re-guess the constants.

### 4. The two-atom path

The two-atom path must not move. I predict it does move, by the amount C1200 measured for three
semantically irrelevant source changes: **0.8 to 1.7 per cent of `evaluate_into`'s instructions in
an unpredictable direction**, because this task changes two of that function's data layouts (the
other atom's ops move out of `Step` into a link pool, and `left_of`/`right_of` become one
interleaved premise column). I predict I will have to disassemble `Demand::evaluate_into` in both
binaries and report its instruction count, and that the A/B ratio on the six direct-path cohorts
will be readable, small, and not attributable to a mechanism. I predict `workspace_bytes()` is
**unchanged to the byte** for every program whose longest body is two atoms, because the premise
column of stride two occupies exactly the two words `left_of` and `right_of` occupied.

### 5. The differential

Zero closure disagreements between the two body policies, and for a strong reason rather than a
weak one: C1189 already establishes that the binarized lowering's closure equals an
order-independent reference evaluator's on every corpus program, so if the n-ary route also equals
that reference evaluator then the two policies agree with each other. The reference evaluator has
**no body-length bound and no binarization**, which is exactly what makes it the right oracle here;
this is the payoff C1189's closeout predicted.

I predict the differential finds one to three real defects in the new code, and I predict where:
first in the semi-naive decomposition for `k >= 3` — the rule that atoms before the delta position
see only rows older than this round's delta and atoms after it see everything — because with `k = 2`
there is exactly one such atom and the generalization has `k - 1` of them, so a missing or
duplicated derivation is the natural first error; and second in the checkers' closed-world pass,
which today hard-codes `body[0]` and `body.get(1)`.

### 6. Where the risk is, in the order I expect it to bite

**`MAX_VARIABLES` binds before `MAX_BODY` does.** A rule holds at most eight distinct variables.
Four binary atoms can need five; four ternary atoms can need twelve. So a generator that emits
four-atom bodies over arity-three relations will produce programs the core refuses with
`Error::Budget`, and the differential must record those as backend divergences with their exact
budget rather than as disagreements. I predict this is the largest single population shift in the
corpus.

**The index count grows quadratically in the body length.** Each of the `k` steps of a `k`-atom rule
needs an index for each of its `k - 1` links, and the masks differ per step because the bound set
differs, so a rule contributes up to `k(k - 1)` distinct (relation, mask) pairs against two today.
At `MAX_BODY = 4` that is twelve per rule. Every dynamic index reserves `slots + capacity` words, so
`workspace_bytes()` grows with it and `MAX_WORKSPACE_BYTES` becomes reachable on a program that is
fine today. I predict at least one cohort refused for that reason and predict I will report it as a
budget refusal rather than raise the ceiling.

**The bucket enumeration cannot be monomorphized per level without combinatorial blowup.** Four
addressing kinds at up to three levels is `4^3 = 64` instantiations of the kernel, doubled by the
head's membership kind. I predict I thread the kind as a plain field resolved once at preparation —
the escape the playbook itself names for when a const generic cannot reach the site — leave the
two-atom kernel on its fully monomorphized path so no existing cohort changes kernel, and record
the deviation with the instantiation count that made it.

## Design, and the shapes not built

### What a body of `k` atoms compiles to

```text
rule           h :- a_1, a_2, …, a_k
steps          one per body position p: the delta atom is a_p
links          the other k - 1 atoms, in the plan's chosen join order
what a link may join
               body position < p   the rows derived before this round's delta
               body position > p   every row the link's index holds
```

A combination of premises with at least one delta member appears in exactly the
step whose `p` is its **first** delta position, so the `k` steps cover each
combination once and only once. That argument is the whole of the semi-naive
correctness for an n-ary body and it is the generalization of the two-atom
`Δa ⋈ (full_b ∪ Δb)` / `full_a ⋈ Δb` pair, which is its `k = 2` case.

Three properties make this a join-plan change rather than a semantic one.

**The link order is a join order and nothing else.** Which rows a link may join
is decided by its atom's **body position** relative to the delta atom's, which
the link record carries; the order the links are visited in is chosen
separately, greedily, by how many key columns are already bound. So permuting a
rule's body changes the plan and not the closure — which is asserted directly,
and is also what a deliberate mutation of the ordering function demonstrates
(see **Exactness**).

**One derivation still names one rule and one premise per body atom, in body
order.** The premise block of a derivation is
`derivation::premise_stride(body) = max(2, body)` references wide, so a
certificate of a one- or two-atom rule is byte for byte what it was — a one-atom
rule has always written a zero into its unused second slot — and a longer body
simply occupies more slots. The premise list is therefore variable-stride and is
read by walking the rules rather than by indexing, which is the one change to
the certificate format and is a widening rather than a break.

**The two-atom kernel reads the fields it always read.** A step with one link
keeps that link inline in the `Step` record, in the `other_ops`, `other`,
`index`, `mode` and `kind` fields it has always had, and the fully monomorphized
`run::<KIND, BITMAP>` kernel is unchanged. A step with two or three links leaves
those fields `NONE` and reads its links from a pool. The cost is 32 bytes per
n-ary step of unused inline ops, in storage the record had as padding anyway;
the benefit is that no existing cohort changes kernel.

### The records

| Record | Stride | Alignment | What changed |
| --- | ---: | ---: | --- |
| `Step` | 128 | 4 | **unchanged**; `swapped` became `position` (the delta atom's body position, which is also its premise slot) and the freed padding took `links` and `link_count` |
| `Link` | 64 | 64 | new: one non-delta atom's ops, relation, index, addressing kind, arity, body position and whether it is before the delta |
| `Op` | 8 | 4 | unchanged |

`Link` is a cache-line record because a step reads its whole plan in
`link_count` line fetches once at entry and then reads compact indices only. It
is 64 bytes for 44 bytes of payload because `Op` is eight; shrinking `Op` to
four — a domain value fits `u16` and a variable index `u8` — would make `Link` a
32-byte record and `Step` **one cache line**, and is a hot-record change with its
own A/B that this task does not take. It is a queue candidate below.

The witness columns changed shape. `left_of` and `right_of`, one `u32` column
each, become one interleaved `premises` column whose stride is the head
relation's own `premise_width`: the longest body of any rule heading it. A
relation derived by rules of at most two atoms therefore reserves the two words
it always reserved, `Demand::workspace_bytes()` is unchanged to the byte for
every such plan, and a witness write touches one cache line instead of one per
premise.

### The join the links run, and the join that was not built

What landed is a **left-deep nested index join** over the links: each link
computes its key from the constants and the variables bound before it, probes
the C1192 index on exactly those columns, and walks the bucket, descending on an
explicit presized frame stack of at most `MAX_BODY - 1` levels. No intermediate
relation is declared and nothing is materialized between levels.

**Free Join was not built, and the reason is the index, not the idea.** Free
Join's leapfrog step pays when several atoms constrain the same *unbound*
variable and the intersection of their buckets is far smaller than any one
bucket. The shipped index answers "the rows whose masked columns equal this
key": a counting-sorted CSR or a chained hash over the packed key of a column
mask. Leapfrog needs, per attribute order, a trie whose level `i` is sorted on
attribute `i` and supports `seek` — a second indexing structure with its own
build, its own reset at every round boundary for a relation that grows, its own
crossover policy and its own memory. C1192's own measurement says a dynamic
index's **reset traffic** is what decides its representation, so a per-round trie
build is exactly the cost that structure was chosen to avoid. Against that, on
every cohort this lane can reach the binding order leaves at most one atom with
an unbound key column and the atoms after it are bucket walks on a distinct
variable or fully bound membership probes, so there is nothing to intersect.

Two things that follow, and are recorded rather than assumed. The plan the
greedy order produces on a chain is already tight: a three-atom chain over one
binary relation needs **two** indexes, not the `k(k - 1) = 6` the shape allows,
because every link is keyed on one column or the other. And a body one of whose
atoms shares no variable with any other does need a mask-of-nothing index, which
is a single bucket holding the whole relation — a full scan, correct and slow —
and the plan reports it rather than refusing.

### Shapes considered and not built

1. **Free Join / leapfrog triejoin**, as above: priced by its trie build, with
   no cohort in this lane where it can pay. The measurement that would overturn
   this is a cyclic body whose binding order cannot fully bind any atom after the
   first; no such cohort exists here today and that is named as the gap.
2. **Monomorphizing the kernel on each level's addressing kind.** Four kinds at
   up to three levels is `4^3 = 64` instantiations, doubled by the head's
   membership kind: 128 copies of the kernel. Rejected. Each link's kind is
   threaded as a plain field resolved once at preparation, which is the escape
   the playbook itself names for when a const generic cannot reach the site. The
   kernel *is* monomorphized on the two run constants a const generic can reach:
   the body length (three or four) and the head's membership kind, four
   instantiations. **Recorded deviation**, with its per-row cost measured below.
3. **Keeping `left_of` and `right_of` and adding two more columns.** Rejected:
   it raises `workspace_bytes()` for every program including two-atom ones, so
   the reservation of a plan that has not changed would change.
4. **A fixed premise stride of `MAX_BODY` in the certificate.** Rejected: it
   changes every existing certificate's bytes to buy a constant stride the
   checker does not need, since the checker holds the rule and therefore the
   body length.
5. **Raising the grounded path's bound to match.** Not possible and not wanted: a
   `ProductRule` is a binary product in the carrier — one output, one left input,
   one right input — so a three-atom body has no grounded form. `ground` refuses
   what `datalog::admit` admits, over one wire format and one source identity,
   and that boundary is a test.
6. **A join order computed in the core from measured statistics.** Out of scope
   by the card. The greedy here is the same variable-sharing heuristic the Rel
   lowering's `order_positives` applies, computed over the atoms a step has left
   to place; the lowering's order still decides the body order the core receives
   and therefore breaks the core's ties.

## The lowering's body policy, and what it is for

Binarization becomes `BodyPolicy::{Binarize, Nary}` on the lowering, threaded
through `Workspace::lower_with`, `rel_lowering`, `rel_stratified`, the
`rel-lower` operator tool and the `rel-frontend-bench` driver as a
`--body-policy binarize|nary` flag whose default is the shipped policy, so every
existing invocation and every committed receipt replays unchanged.

The policy decides exactly one number: how many body atoms a rule may keep. The
pass that was `binarize` is now `plan_bodies`, and it chains a body longer than
that through the same auxiliaries, the same `order_body` join order and the same
`live` suffix masks — under `Nary` the chain simply stops when what remains
fits, at four atoms rather than at two. With `keep` two the pass is
byte-for-byte the shape milestone (a) shipped, which is what the unchanged
native/WebAssembly parity digest below says.

**One thing the plumbing found, and it corrects a Fermi prediction.** The
variables budget is enforced in `passes::project`, which runs **before** body
planning, so it has always applied to the *unbinarized* rule: a three-atom body
with nine distinct variables was refused under binarization too, and
binarization never rescued a wide body. Fermi prediction 6 expected the variable
budget to be the largest population shift between the two policies and it is not
a shift at all. What can still differ is a budget the auxiliaries themselves
consume — the relation count, the rule count and an auxiliary's own arity — so
the n-ary policy can only ever accept **more** programs, which is what the
corpus census asserts.

## Method

### The harness and the two arms

The derivation-loop A/B is `analysis/datalog-comparison/ab.py`, the committed
interleaved driver C1192 wrote, in the shape the playbook prescribes: rounds
that alternate arm order, an A/A null per cohort, the non-multiplexing event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` with the
enabled fraction recorded per measurement, two-point differencing between
`repeats` and `2 · repeats` evaluations so that process startup, admission and
preparation leave every per-iteration figure, one pinned core, and the load
average over the run. Cache events get their own run with their own nulls.

**The two arms of this task's central comparison are one binary under two
arguments**, not two revisions: the same `closure_ballpark` runs
`--bodies binarized` and `--bodies nary` on one source family. That is what
makes the comparison a body-policy comparison and not a program comparison, and
it removes the recompile drift that has confounded three reports in this lane
from the central figure entirely — both arms are the same compiled kernel.

It also required one change to the driver, which is a recorded deviation. `ab.py`
refused to summarize a cohort whose arms disagree on derived, probe, candidate
or round counts — the right check for two revisions of one program and the wrong
one for two programs with one closure, which is exactly what a binarized body
and its n-ary twin are. `--work-may-differ` narrows the agreement check to the
output relation's tuple count, its SHA-256 and the failure code, all of which
must still agree, and the receipt now carries **both** arms' work counts rather
than one. The derived-tuple ratio the card asks for is that pair.

### Which cohorts answer which question

| Cohort | What it is | What it measures |
| --- | --- | --- |
| `triangle` at `sparse` | `tri(x,y) :- edge(x,y), edge(y,z), edge(z,x).` against `aux(x,y,z) :- edge(x,y), edge(y,z).` and `tri(x,y) :- aux(x,y,z), edge(z,x).` | the family where the intermediate dominates: an arity-three auxiliary of about `9N` tuples against a result of tens |
| `path3` at `sparse` | `p3(x,w) :- edge(x,y), edge(y,z), edge(z,w).` against its two-rule chain | the family where the intermediate is real work but not the whole of it |
| `path4` at `sparse` | the four-atom chain against two auxiliaries | the same one level deeper, and the only cohort that enters the four-atom kernel |
| `closure`, `samegen`, sparse and dense | the C1182 generators, unchanged | **the two-atom path, which must not move**, against the retained control |
| the `datalog` cohort through `rel-frontend-bench` | a Rel source with a three-atom body every sixty-fourth definition | the lowering and the stratified backend under the two policies, on a real source rather than a hand-written program |

The two-atom cohorts are measured against the **retained control**
`closure_ballpark-193ebd1`, because there the question is whether this task's
changes to `Step`, the premise columns and the dispatch moved the shipped
kernel; the body-policy cohorts are measured candidate against candidate,
because there the question is about the source.

## What the differential says, before any timing

The C1189 harness now decides **every** source under both body policies and
compares each with the same reference evaluator. Zero disagreements, and the
corpus that establishes it is wider than it was: the in-fragment generator draws
its body length from one to four rather than one to three, and the harness gates
the mix it actually wrote.

| Corpus | Programs | Outcome under both policies |
| --- | ---: | --- |
| the eight committed milestone (a) fixtures | 8 | accepted, closures equal to the committed Python oracle's |
| the milestone (a) audit's further programs | 6 | as recorded |
| the recorded rejection surface | as recorded | each with its semantic class, **identical under both policies** |
| the Addendum A equations | 35 | each decided twice, same outcome |
| the surface-construct table | as recorded | same outcome |
| the seeded in-fragment generator | 1,200 | **all accepted under both policies**, no divergence, no semantic rejection |
| the seeded near-miss generator | 400 | as recorded |
| the name-resolution templates | 120 | all accepted |

**The generated corpus's body-length mix, counted on what the generator wrote
and gated against a floor:** 732 bodies of one atom, 1,516 of two, **1,329 of
three and 1,134 of four**. Before this task the generator drew one to three and
the fourth atom arrived only when a wide head forced it; a corpus that drifted
back to two-atom bodies would agree trivially under both policies, which is what
the floor of 200 per length is against.

**A semantic rejection is the same under both policies and the harness asserts
it**; a *budget* refusal is allowed to differ, because the binarized program
declares auxiliary relations the n-ary one does not and can therefore exhaust a
relation, rule or arity bound the n-ary one never reaches. On this corpus it
does not differ: both policies accept all 1,200 generated programs and diverge
on nothing.

## Results

### The two-atom path, against the retained control

Control `closure_ballpark-193ebd1` against candidate `closure_ballpark-cb11550`, five interleaved
rounds, CPU 5, repeat counts 3 and 6 with two-point differencing, the six-event set at **100.00 per
cent enabled over 180 measurements**, load 3.19 to 5.28. Receipt
`analysis/datalog-comparison/ab-2026-09-17-c1193-direct.json` with its raw sidecar.

| Cohort | derived | instructions [lo, hi] | A/A null | cycles [lo, hi] | cycle null | branches | branch misses | peak RSS control / candidate KiB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `closure` sparse 256 | 62,979 | **1.02128** [1.02127, 1.02129] | 1.0000043 | 1.0214 [1.0155, 1.0274] | 0.97561 | 1.0147 | 1.0069 | 5,088 / 5,056 |
| `closure` sparse 1,024 | 979,983 | **1.02143** [1.02143, 1.02143] | 1.0000000 | 1.0123 [0.9966, 1.0283] | 0.99544 | 1.0149 | 0.9859 | 34,424 / 34,408 |
| `closure` dense 256 | 65,536 | **1.01699** [1.01698, 1.01699] | 1.0000012 | 1.0548 [1.0328, 1.0774] | 0.99965 | 1.0009 | 1.0041 | 7,660 / 7,644 |
| `closure` dense 512 | 262,144 | **1.01696** [1.01696, 1.01697] | 1.0000001 | 1.0472 [1.0333, 1.0613] | 1.00002 | 1.0005 | 1.0007 | 22,416 / 22,400 |
| `samegen` sparse 1,024 | 258,691 | **1.02052** [1.02052, 1.02053] | 0.9999993 | 1.0350 [1.0193, 1.0510] | 1.00158 | 1.0240 | 1.0563 | 11,580 / 11,568 |
| `samegen` dense 512 | 507,425 | **1.02064** [1.02064, 1.02064] | 0.9999996 | 1.0133 [1.0046, 1.0221] | 0.99973 | 1.0188 | 0.9952 | 19,156 / 19,140 |

Derived, probe and candidate counts identical on every cohort. **Peak resident set is lower on
every cohort**, by 12 to 32 KiB: the interleaved premise column touches one page where two columns
touched two.

**The path costs 1.7 to 2.1 per cent of its instructions, and that is a loss to state plainly
rather than round away.** The A/A nulls are inside four parts per million, so it is a measurement
and not noise. `Demand::evaluate_into` is **7,872 instructions against the control's 7,788**, a
1.1 per cent larger body, which is the band three earlier reports in this lane record for source
changes the loop does not execute (C1170's bench-driver dump path, C1198's stagger commit, C1200's
workspace field: 0.8 to 1.7 per cent). Two of this task's changes are executed by that path, so
some of the 2 per cent is real work and not drift: the witness write moved into one interleaved
column, which costs a multiply and one bounds-check pair per **derived** tuple where two columns
cost two indexed stores, and `join` builds a premise pair where it built two registers.

### The record of accepted and rejected variants

Every row is the same quick two-point probe against `closure_ballpark-193ebd1`, pinned to CPU 5,
repeats 3 and 6, instructions only; the shipped row is confirmed by the full interleaved A/B above,
which reproduces its `closure` dense 256 figure to five decimal places.

| Variant | `closure` dense 256 | `closure` sparse 1,024 | `samegen` sparse 1,024 | `evaluate_into` |
| --- | ---: | ---: | ---: | ---: |
| the first landing: witness slot at `premises[step.position]`, `run_nary` inlined | 1.11551 | — | — | 12,624 |
| constant-index witness slots, `run_nary` still inlined | 1.05854 | — | — | 12,855 |
| **shipped**: constant-index slots, `run_nary` out of line | **1.01699** | **1.02143** | **1.02053** | **7,872** |
| shipped plus the premise width carried on `Step` | 1.03370 | 1.03467 | 1.03280 | — |
| shipped plus the n-ary limits and dispatch outlined too | 1.04315 | 1.05614 | 1.06007 | 7,946 |

**The two rejected variants are the instructive half.** Carrying the head's premise width on the
`Step` record — one byte in storage the record already had, removing an array access and its bounds
check from the innermost write path — makes the loop **1.6 per cent worse**. Outlining the n-ary
limits and dispatch as well as the kernel, which shrinks `evaluate_into` by nothing the two-atom
path executes, makes it **2.6 to 3.9 per cent worse**. Neither changes a line the two-atom cohorts
run. They are two more instances of the lever C1200 named and put on the discovery track, now with
the sign against the change that should have been free, and they are the reason the shipped
configuration is the one measurement chose rather than the one reasoning would have.

Passing the premise pair by value rather than by reference was also tried and is **exactly
identical** to five decimal places on all three cohorts, so the by-value form is kept for being the
simpler one and not for being faster.

### The body policy, on the families the card names

One binary, `closure_ballpark-cb11550`, under two arguments: `--bodies binarized` against
`--bodies nary`. Five interleaved rounds, CPU 5, repeats 3 and 6, the six-event set at **100.00 per
cent enabled over 150 measurements**, load 1.77 to 1.99, `--work-may-differ`. Receipt
`analysis/datalog-comparison/ab-2026-09-17-c1193-body-policy.json`.

**The output relation's SHA-256 and its tuple count are identical on every cohort**; the driver
fails the run rather than summarizing it otherwise, and it reported no failure.

| Cohort | output tuples | derived, binarized → n-ary | rounds | instructions [lo, hi] | A/A null | cycles [lo, hi] | cycle null | peak RSS KiB |
| --- | ---: | --- | --- | ---: | ---: | ---: | ---: | --- |
| `triangle` sparse 4,096 | 48 | 36,912 → **48** | 3 → 2 | **0.52263** [0.52260, 0.52266] | 0.9999698 | 0.3972 [0.2048, 0.7703] | 0.88328 | 192,232 → 71,492 |
| `triangle` sparse 16,384 | 15 | 147,471 → **15** | 3 → 2 | **0.61324** [0.61320, 0.61329] | 0.9999939 | 0.4053 [0.3727, 0.4407] | 1.06066 | 149,952 → 15,140 |
| `path3` sparse 4,096 | 110,213 | 147,053 → 110,213 | 3 → 2 | **0.95927** [0.95920, 0.95934] | 1.0000454 | 0.9330 [0.9006, 0.9666] | 0.99880 | 14,084 → 11,260 |
| `path3` sparse 16,384 | 441,937 | 589,360 → 441,937 | 3 → 2 | **0.93405** [0.93403, 0.93408] | 1.0000145 | 0.8266 [0.8040, 0.8498] | 1.01593 | 94,272 → 58,524 |
| `path4` sparse 4,096 | 327,629 | 474,682 → 327,629 | 4 → 2 | **0.94849** [0.94849, 0.94850] | 1.0000026 | 0.9634 [0.8801, 1.0545] | 1.01902 | 25,560 → 19,344 |

The `triangle` cycle rows are **not readable** and are printed with their nulls to say so: the A/A
null is 0.883 at 4,096 and 1.061 at 16,384, both far outside the noise floor the playbook requires
before a cycle ratio may be read. The instruction rows on those cohorts are readable, with nulls
inside three parts per hundred thousand.

**The headline is `triangle`, and it is the shape the card predicted.** The binarized chain must
carry all three variables through its auxiliary — the last atom needs `z` and the head needs `x`
and `y` — so it derives about `9N` intermediate tuples to produce a result of tens, and the n-ary
body derives only the result. Instructions fall to 0.52 and 0.61, the derived-tuple count by three
to four orders of magnitude, the round count from three to two, and peak resident memory from 192 MB
to 71 MB and from 146 MB to 15 MB.

**`path3` and `path4` are the honest middle, and they came out worse than the Fermi.** The
intermediate there is a real relation and not a scaffold, so removing it saves the emits and not the
joins: derived tuples fall by 25 to 31 per cent and instructions by only 4 to 7. Prediction 1 said
0.70 to 0.85 for `path3` and 0.55 to 0.75 for `path4`; the measurement is 0.93 to 0.96. The cost
model was wrong in exactly the direction prediction 3 warned of — the n-ary join is not cheaper per
unit than the binarized chain's — and the correction is in the per-unit table below.

### The supplementary cache-event run

Same two arms, the playbook's cache set with its own run and its own nulls, five rounds, CPU 5,
**100.00 per cent enabled on every event**, load 0.90 to 0.98. Receipt
`analysis/datalog-comparison/ab-2026-09-17-c1193-body-policy-cache.json`.

| Cohort | L1 d-cache loads | its null | L1 load misses | its null | cache references | its null | cache misses | its null |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `triangle` sparse 4,096 | 0.5655 | 0.9912 | **0.2761** | 1.0054 | 0.2619 | 0.9761 | 0.2020 | 1.0006 |
| `path3` sparse 16,384 | 0.9745 | 1.0038 | **0.7798** | 0.9924 | 0.7592 | 0.9876 | 0.7399 | 1.0241 |
| `path4` sparse 4,096 | 0.9665 | 1.0019 | **0.7435** | 1.0011 | 0.6883 | 1.0159 | 0.4866 | 0.9303 |

**This is the second result and it is larger than the instruction ratio says.** On `path3` and
`path4` the loop issues 97 per cent of the loads it issued and **misses 74 to 78 per cent** of what
it missed: not writing the intermediate relation removes memory traffic out of proportion to
instructions, which is why the cycle ratio on `path3` at 16,384 is 0.827 against an instruction
ratio of 0.934. The `path4` cache-miss row carries a null of 0.930 and is reported with that caveat
rather than read.

### The Rel route: the `datalog` cohort under the two policies

`ergodis-tools-cb11550` against itself with `--body-policy nary` and `--body-policy binarize`, five
rounds, CPU 5, the six-event set at 100.00 per cent enabled over 342 measurements, load 0.51 to
1.00. Receipt `analysis/rel-frontend/performance-v10-c1193-body-policy-datalog.json`.

| Stage | binarize | nary | ratio [lo, hi] |
| --- | ---: | ---: | ---: |
| `scan`, `parse`, `admit` | — | — | 1.00000 to within one part per hundred thousand |
| `lower` | 5,704,353 | 5,677,200 | 0.99524 [0.99524, 0.99524] |
| `lower` − `admit`, the lowering alone | 1,353,567 | 1,326,412 | **0.97994** |
| `stratify` | 1,694,944,191 | 1,683,686,087 | 0.99336 [0.99336, 0.99336] |
| `stratify` − `lower`, the backend alone | 1,689,239,838 | 1,678,008,887 | **0.99335** |

And what the lowered program itself becomes, from `rel-lower --cohort datalog --definitions 512`
under each policy, both verified:

| | relations | auxiliaries | rules | binarized rules | literals | canonical fingerprint |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `binarize` | 14 | 8 | 96 | 8 | 272 | `16adff1ed85f7e04` |
| `nary` | **6** | **0** | **88** | 0 | 256 | `06aa82af43b2b958` |

The lowering is 2.0 per cent cheaper because it builds eight fewer relations and eight fewer
synthetic rules; the backend — projection, evaluation, certification and both independent checkers
over every layer — is 0.66 per cent cheaper. That is small and it is what this cohort can offer:
eight of its ninety-six rules have three atoms, and C1192's mystery ledger item 9 already recorded
that this stage is mostly materialization rather than the derivation loop.

### Against Soufflé 2.5, which is the engine that motivated the task

The three families now have `.dl` programs and a `compare.py` row each, so the comparison the card's
"Why" section rests on — that Soufflé plans an n-ary join natively and this path did not — is a
measurement rather than a citation. Whole-process wall, five interleaved rounds, CPU 5, compiled
Soufflé with `-j1`, and the derived relation compared as a tuple set on every case. Receipts
`analysis/datalog-comparison/results-2026-09-17-c1193-{binarized,nary}.json`.

| Program | N | output | binarized, wall over compiled Soufflé | n-ary, wall over compiled Soufflé | peak RSS binarized → n-ary → Soufflé, KiB |
| --- | ---: | ---: | ---: | ---: | --- |
| `triangle` | 1,024 | 48 | 1.486 [1.181, 1.870] | **1.167** [0.873, 1.559] | 24,340 → 7,772 → 4,832 |
| `triangle` | 4,096 | 48 | 4.394 [4.058, 4.757] | **1.918** [1.806, 2.038] | 191,548 → 70,820 → 4,932 |
| `path3` | 1,024 | 27,303 | 0.804 [0.790, 0.818] | 0.877 [0.666, 1.156] | 5,068 → 4,768 → 5,044 |
| `path3` | 4,096 | 110,213 | 0.690 [0.512, 0.931] | **0.569** [0.528, 0.614] | 14,328 → 11,440 → 5,984 |
| `path4` | 1,024 | 78,955 | 0.557 [0.433, 0.716] | 0.612 [0.481, 0.780] | 7,952 → 7,184 → 5,696 |
| `path4` | 4,096 | 327,629 | 0.373 [0.366, 0.381] | **0.349** [0.338, 0.361] | 25,856 → 19,532 → 9,112 |

Soufflé's tuple set agrees with this evaluator's on all six cases, and its interpreter agrees with
its compiled binary on all six. The n-ary policy **halves the triangle gap**, from 4.39 times
compiled Soufflé to 1.92, and improves both larger path cases; the two `1,024` path rows are the
only ones where it is behind, and there the whole process is about twenty milliseconds of which the
evaluation is one or two, so the ratio is reading process startup.

### The per-unit cost of the new kernel

The n-ary join has no retained control, so the playbook's rule for a new kernel applies: it is
accepted with a recorded per-unit cost budget, its kernel-scoped profile, and its zero-allocation
and call-free evidence.

The unit is a **body match at any depth** — a row a link yielded that bound successfully, complete
or partial. That count is not instrumented, and it does not need to be: the binarized twin's rules
correspond one to one to the n-ary body's levels, so its `candidates` counter **is** the n-ary
kernel's match count on the same cohort. (The n-ary kernel's own `candidates` counts complete body
matches only, which is what that counter has always meant and is not the unit its work is
proportional to; a `matches` counter would make the budget self-evidencing and is a candidate below.)

| Cohort | matches | n-ary instructions per match | n-ary ns per match | binarized instructions per match |
| --- | ---: | ---: | ---: | ---: |
| `triangle` sparse 4,096 | 36,912 | 295.6 | 32.1 | 565.7 |
| `triangle` sparse 16,384 | 147,471 | 433.7 | 55.8 | 707.1 |
| `path3` sparse 4,096 | 147,384 | 233.5 | 12.8 | 243.4 |
| `path3` sparse 16,384 | 589,725 | 259.4 | 36.8 | 277.7 |
| `path4` sparse 4,096 | 478,023 | 233.2 | 13.1 | 245.9 |

**233 to 434 instructions and 13 to 56 nanoseconds per body match** is the budget the next change to
this kernel is measured against. The spread is the cohort and not the kernel: `triangle`'s second
link is a fully bound membership probe into an index over `domain²`, whose locality is the worst of
the five, and its per-match cost rises with `N` while the two path families' barely do.

## Recorded deviations

1. **`ab.py` gained `--work-may-differ` and its receipt carries both arms' work
   counts.** The driver refused to summarize a cohort whose arms disagree on
   derived, probe, candidate or round counts, which is the right check for two
   revisions of one program and the wrong one for a binarized body against its
   n-ary twin — two programs with one closure. The output relation's count, its
   SHA-256 and the failure code must still agree under the flag. **A consequence
   to state:** `row["derived"]` and its three siblings are now a mapping of arm
   name to count rather than one scalar, so re-summarizing an older receipt with
   this driver produces the new shape. The committed receipts themselves are
   untouched, and an audit that re-derives from the `.jsonl` sidecars — which is
   how C1200's audit did it — reads the raw samples and not the summary.
2. **`bench.py` gained `--binary-args` and `--control-args`.** An arm is now a
   binary and the extra arguments it is run with, which is the shape `ab.py`
   already had; both default to empty, so an existing invocation is unchanged.
3. **The `closure_ballpark` harness gained three programs and one flag**, which
   the card did not ask for. Without `triangle`, `path3` and `path4` there is no
   cohort whose body is longer than two atoms, and without `--bodies` the two
   arms of the central comparison would be two binaries rather than one binary
   under two arguments.
4. **The body policy is a lowering option, not a `Limits` field.** `Limits` is a
   capacity structure and a policy is not a capacity, so it is an argument to
   `Workspace::lower_with` and is threaded through the passes rather than stored.
5. **Under `BodyPolicy::Nary` a body of more than four atoms is still chained,
   down to four.** The same pass, the same auxiliaries and the same join order;
   only the stopping point moves. A grouping that chained five atoms into two
   groups of three would be a different policy and is not built.
6. **The allocation gate's reservation counter needed a lock.**
   `ergodis_rules::reservations()` is one process-wide atomic, so a sibling test
   reserving a workspace on another thread inflates it; before this task there
   was exactly one gate reading it and the fragility was invisible. Both gates
   now take a mutex. The allocation counter itself is thread-local and needs
   none.
7. **`rule_contract::parse_rules` now admits up to `datalog::MAX_BODY` atoms.**
   The textual form admits what the wire format admits and each consumer applies
   its own bound; `ground` still refuses a body of more than two, which a test
   asserts on a program `parse_rules` accepts.

## Profile

`perf record -e instructions:u -F 4000`, pinned to CPU 5, on `closure_ballpark-cb11550` in its
`--evaluate-only` mode — read the generator, prepare once, then the derivation loop and nothing
else — over `path3` at the sparse density and N = 16,384 with sixty iterations, so the one-shot
output path is under a quarter of a per cent. Profile data under
`~/.cache/ergodis/perf-c1193/path3-{binarized,nary}.data`.

| Symbol | binarized | n-ary |
| --- | ---: | ---: |
| `Demand::run_nary` | — | **88.58 %** |
| `Demand::evaluate_into` | **93.91 %** | 9.40 % |
| `Demand::index_rows` | 4.22 % | below 0.05 % |
| everything else above 0.05 % | 1.05 % | 0.99 % |

The derivation loop is 98.13 per cent of the binarized profile and 97.98 per cent of the n-ary one.
Everything else is the harness's own one-shot path — `serde_json`, `sha2`, `itoa`,
`__memmove_avx512_unaligned_erms`, `_int_malloc`, `hashbrown` — each below a quarter of a per cent
and none of it inside a loop. **`index_rows` falls out of the n-ary profile**, and that is where
part of the saving went: 4.22 per cent of the binarized profile is the auxiliary relation's chain
index being rebuilt at every round boundary, and the n-ary program has no auxiliary to index.

**Every out-of-line call inside the kernels, read from the disassembly rather than from the
profile's resolution**, which is the playbook's own rule for this claim. `Demand::run_nary`, 1,407
instructions per instantiation, calls **nothing but `panic_bounds_check` and `slice_index_fail`** —
panic paths on the cold side of a branch, never taken. No libc symbol, no allocator, no formatting,
no trait-object dispatch. `Demand::evaluate_into`, 7,872 instructions, calls `index_rows` twice, the
four `run_nary` instantiations once each, the same two panic helpers, and **`memset@GLIBC` twice**:
those two are the reset's fill path, which C1198 measured and bounded by
`RESET_FILL_BYTES_PER_ROW`, and they sit before the round loop rather than inside it.

**Layout.** `Link` is `#[repr(C, align(64))]` with
`const _: () = assert!(size_of::<Link>() == 64 && align_of::<Link>() == 64)`; `Step` keeps its
asserted 128-byte stride and align 4 unchanged, and `Op` its 8-byte stride. Nothing else the loop
reads is a record.

**Allocation.** `repeated_n_ary_evaluation_has_no_allocation` enters the real loop a hundred times
after setup, on a program with a two-atom recursion, a three-atom triangle and a four-atom chain,
under every one of the five addressing policies, and observes **zero allocations and zero
reservations**, with both n-ary relations asserted non-empty so the kernel is known to have been
entered. The pre-existing derivation-loop gate is unchanged and green.

## Exactness

### The core gates

| Gate | Outcome |
| --- | --- |
| `cargo test --all-features` at `ergodis` `089c6d9` | exit 0, **82 `test result: ok` blocks, zero `FAILED`** — the 81 C1200 recorded plus the new `demand_nary` binary |
| `cargo clippy --all-targets --all-features -- -D warnings` | exit 0, no diagnostics |
| `cargo fmt --all -- --check` | exit 0 |
| `SHA256SUMS` | regenerated by `python3 python/generate_evidence.py --write` in the same commit as every source change; `tests/evidence_manifest.rs` passes and the public lint is clean |
| `cargo test -p ergodis-rules --test allocation` | 5 tests green, including the new `repeated_n_ary_evaluation_has_no_allocation`: a hundred entries into the n-ary loop under every addressing policy, **zero allocations and zero reservations** |
| The naive oracle, on eight n-ary programs under five policies | every relation's tuple set equal, with both checkers accepting and both replays holding the same tuple sets rather than the same counts |
| The hand-binarized twin of each of the eight | equal on every relation the source names, and the twin derives strictly more tuples |
| Repeated evaluation into one workspace | same work counts, same rows and the **same certificate** on four consecutive evaluations, under every policy |

The oracle is the load-bearing part and it is worth saying what it is. It
enumerates every assignment of a rule's variables over the finite domain and
tests each body atom for membership, iterating whole passes until one adds
nothing. It has no index, no delta, no join order, no addressing policy and no
body-length bound, and it reads the wire `Program` rather than the admitted
form. So an agreement is evidence about the evaluator and not about one
implementation compared with itself — and in particular it is evidence about the
semi-naive decomposition, which is the part of an n-ary body that can silently
derive *too little* and which no self-comparison can see.

### The deliberate mutations, and what each one cost

Every mutation ran against a `git archive HEAD` throwaway copy under
`~/.cache/ergodis/c1193/mutate/` with its own target directory, never against
the repository. Each was applied with the Edit tool and reverted by restoring
the file from `git show HEAD:<path>`.

| # | The mutation | Tests failing, of ten | What caught it |
| --- | --- | ---: | --- |
| A | `Link::old` set for **every** link, so an atom after the delta may see only the older rows | 6 | the independent derivation checker: `Incomplete(0)` — the closed-world pass finds a body match whose head was never derived |
| B | the witness slot written by **link order** instead of body position | 3 | the derivation checker: `Unification(0)` — the premise tuple does not unify with the atom it is named against |
| C | the sparse bucket's key comparison removed from `bind_link` | 1 | only `a_colliding_bucket_is_verified_inside_an_n_ary_join`, the constructed single-slot case |
| D | the link **order** made body order, ignoring what is bound | 1 | only the plan-shape assertion; **every closure test passes** |
| E | the checker's premise walk truncated to two atoms | 4 | `every_premise_slot_of_an_n_ary_derivation_is_load_bearing`: "premise slot 2 is not load bearing" |
| F | the checker's closed-world pass skips a body longer than two atoms | 1 | the truncated-certificate assertion: "a certificate missing its last derivation was accepted" |

**Three of these changed what the suite is, and that is the useful part.**

Mutation C passed the whole suite on the first attempt, which is C1192's lesson
arriving again: the multiply-shift hash is close to injective on the key ranges
every natural cohort uses, so no sparse bucket ever holds two keys and the
comparison the sparse kind needs is never exercised. The repair is the same one
C1192 found — construct the collision rather than hope for it — and here that is
a plan whose row bound is one, so every derived relation holds at most one row
and every hash table has exactly one slot. The new case covers both a constant
key column and one bound by an earlier atom, inside a three-atom body, and
deleting the comparison now fails it.

Mutation B failed only one test on the first attempt, and the reason is a fact
about the corpus worth recording: on a chain the greedy join order **agrees with
body order at every delta position**, because the candidates tie on bound key
columns and on free variables and the tiebreak is body order. So a witness
written by link order is indistinguishable from one written by body position on
every case the corpus had. The repair is a body whose written order is not the
order the plan joins it in, and with it three tests catch the mutation.

Mutation F had nothing to fail against at all: every certificate the corpus
produces is complete, so a closed-world pass that silently skips n-ary rules
accepts all of them. The repair is an assertion that a certificate **missing its
last derivation** is rejected, which only the closed-world pass can do.

**Mutation D is a negative control and it is the one to read carefully.** Making
the link order ignore what is bound changes the plan visibly — the three-atom
chain goes from two indexes to four, one of them a mask-of-nothing full scan —
and **every closure, certificate and checker assertion still passes**. That is
direct evidence for the design claim that the link order is a join order and the
body position is the semantics, rather than an argument that it is.

## Disposition

**Kept**, by the forward commits in the table above; nothing is reverted, and the variants that lost
are recorded above with their measurements rather than left in the tree.

1. **The n-ary evaluator and both checkers** (`ergodis` `d677a8b`, `089c6d9`, `09a5c2b`): a body of
   up to four atoms is joined directly, the two-atom path costs 1.7 to 2.1 per cent of its
   instructions and no more memory, and every derived tuple of an auxiliary relation is work the
   evaluator no longer does.
2. **The body policy in the lowering** (`ergodis-private` `c3135f8`): binarization is selectable,
   the binarized program is the measured control for the same source, and the differential decides
   every source under both.
3. **The harness and driver changes** (`ergodis-private` `e8f0e06`, `4b854ff`): one binary under two
   arguments is the A/B, the receipt carries both arms' work counts, and the engine that motivated
   the task has a row on the same cohorts.

**The default body policy stays `Binarize`, and the measurement says the other way.** On every
cohort whose body is longer than two atoms the n-ary policy is cheaper in instructions (0.52 to
0.96), in rounds, in derived tuples, in peak resident set and in reserved workspace, and it halves
the gap to compiled Soufflé on `triangle`. Three things hold the default where it is, and each is a
condition a successor can discharge rather than an argument against the policy:

- **Three prior reports' replay commands reproduce their receipts only under it.** C1190's, C1192's
  and C1198's `lower` and `stratify` rows on the `datalog` cohort are taken with no
  `--body-policy` flag, and flipping the default would silently change what those commands measure.
- **The milestone (a) fixture suite is written against it.** Thirteen assertions in
  `tests/rel_lowering.rs` name auxiliary counts, binarized-rule counts and the chain's own
  diagnostics; under an n-ary default they would stop exercising the chain rather than fail. Pinning
  that suite's one helper to `BodyPolicy::Binarize` is a one-line change and is what a flip should
  carry.
- **The native/WebAssembly canonical digest and the `datalog` lowering fingerprint would both move**
  (`349333d4…` and `16adff1ed85f7e04` to `06aa82af43b2b958`), which is a recorded change two reports
  cite and wants its own commit and its own regenerated manifest.

So the recommendation is explicit: **flip the default to `Nary` in a change that pins the milestone
(a) helper, regenerates the parity manifest and states the two moved digests**, and until then every
caller that wants the better plan passes one word. C1195's benchmark suite should carry **both**
rows rather than choose, because the pair is the result.

## The `ej` and `tt` closeout

### Free upgrades taken, because they were in reach here

**The engine that motivated the task now has a row.** C1182 recorded "Soufflé plans n-ary joins
natively" as the gap and C1193's card quotes it; until this task the lane had no cohort on which to
measure it, because `compare.py` carried only transitive closure and same generation. Three `.dl`
files and three `PROGRAMS` entries later, the claim is a table: n-ary halves the triangle gap and
improves both larger path cases, and Soufflé's tuple set agrees with this evaluator's on all six.
That closes half of C1192's remaining gap 1, which asked for exactly this and named the missing
`.dl` files. `mutual` and `cycle` still have none.

**The `closure_ballpark` usage strings the C1192 audit found stale are current**, which was C1192's
remaining gap 7: the module doc now names every program and every flag, and the `--index` list is
the one the parser accepts.

**The certificate size report reads every width from the program** rather than assuming two. It had
assumed a binary arity for the premise block, the derived tuple and every ranked relation, which the
binarized triangle breaks in three places at once; the repair is `4b854ff` and it is the only reason
that arm has a `--certificates` figure at all.

**The allocation gate's reservation counter is no longer thread-fragile.** It reads one
process-wide atomic and a sibling test reserving a workspace inflates it; with one such gate the
fragility was invisible and with two it fails immediately.

### What is surprising, and what it opens

**The static index's *build* cost is unmeasured, and `triangle` is the cohort that exposes it.** At
N = 4,096 the third atom `edge(z,x)` is fully bound, so its index keys on both columns — a key space
of `domain²` = 2^24, just inside `MAX_DIRECT_KEYS` — and `Policy::Auto` chooses the direct
counting-sorted CSR, whose offsets array is 64 MiB of eagerly allocated and fully touched memory in
the **plan**. Measured directly on the shipped binary:

| `--index` | preparation | peak RSS | evaluation |
| --- | ---: | ---: | ---: |
| `auto` | 27.0 ms | 71,516 KiB | 0.87 ms |
| `sparse-indexes` | **3.5 ms** | **5,904 KiB** | 2.39 ms |

Preparation is thirty times the evaluation on the shipped policy, and forcing the sparse kind trades
1.5 ms of evaluation for 23.5 ms of preparation and 65 MB. **This is what makes Ergodis 1.92 times
compiled Soufflé on `triangle` at 4,096 while being 0.35 times it on `path4`** — and it is a policy
gap and not an addressing one. C1192's recorded deviation 5 says the static index has no density
rule because "the counting-sorted bucket beats a binary search at every density its ceiling allows";
that measurement was of the **probe**, and the build was never priced. C1198 made the *workspace*
lazy and left the plan's CSR eager. A density rule for a static index, or a `Pages` reservation for
its offsets array, is the successor, and it is worth more on this cohort than anything in this task.

**The n-ary plan needs *fewer* indexes than the binarized one, not more.** Fermi risk 2 predicted
`k(k - 1)` distinct (relation, mask) pairs per rule against two today, and reserved workspace growing
with it. Measured, at N = 1,024:

| Program | indexes, binarized → n-ary | membership structures | reserved workspace bytes |
| --- | --- | --- | --- |
| `triangle` | 4 → **3** | 3 → 2 | 771,883,008 → **33,685,504** |
| `path3` | 3 → **2** | 3 → 2 | 63,180,800 → 33,685,504 |
| `path4` | 4 → **2** | 4 → 2 | 96,870,400 → 37,879,808 |

Two things collapse the count: a chain's atoms share one variable with each neighbour, so every link
is keyed on one column or the other and the `k(k - 1)` masks fall onto two; and each auxiliary
relation the binarized program declares needs an index of its own. The prediction was wrong in the
comfortable direction and the reason is worth keeping, because it is the same reason the join order
is tight.

**The candidate counter does not count what an n-ary kernel's work is proportional to.**
`Evaluation::candidates` means "head tuples produced by a body match", so for a three-atom body it
counts complete matches and not the partial ones each level makes — which is why `triangle`'s n-ary
arm reads 227,342 instructions per candidate. The per-unit budget above is built from the binarized
twin's counter instead, which is exact because the chain's rules are the n-ary body's levels; a
`matches` counter incremented at every successful bind would make the budget self-evidencing at the
cost of one increment per yielded row in the n-ary kernel only. Queued below rather than taken,
because adding it now would invalidate the A/B that was just run.

### Candidates to queue, no identifiers allocated

1. **A density rule, or a lazy reservation, for a static join index's offsets array.** The largest
   measured effect anywhere in this report: 27.0 ms of preparation and 65 MB against 3.5 ms and
   6 MB on one cohort. It also decides the `triangle` row against Soufflé.
2. **Shrink `Op` to four bytes**, which makes `Link` a 32-byte record and `Step` **one cache line**.
   A domain value is below 65,536 and a variable index below eight, so both fit; it is a hot-record
   change with its own A/B, and given the two rejected variants above its sign is not predictable
   from reasoning.
3. **An `Evaluation::matches` counter**, so an n-ary kernel's per-unit budget is instrumented rather
   than inferred from its binarized twin.
4. **Flip the default body policy to `Nary`**, with the three conditions under **Disposition**.
5. **Chain a body longer than four atoms into groups of four rather than down to four.** The pass
   stops as soon as what remains fits, so a five-atom body becomes one auxiliary plus four atoms; a
   nine-atom body becomes five auxiliaries plus four rather than two groups. Nothing in the fragment
   reaches it today.
6. **`mutual` and `cycle` still have no Soufflé row**, which is what remains of C1192's gap 1.
7. **`ab.py` still summarizes a row whose run refused**, which is C1192's gap 8, untouched.

## Mystery ledger

**Settled.**

1. **Does removing the intermediate relation pay, and where?** Yes, and the size depends entirely on
   what fraction of the work the intermediate is. Where it is a scaffold — `triangle`, whose
   auxiliary must carry all three variables to produce a result of tens — instructions fall to 0.52
   and 0.61 and peak resident memory by 2.7 and 9.9 times. Where it is a real relation — `path3`,
   `path4` — the derived-tuple count falls by a quarter to a third and instructions by only 4 to 7
   per cent, because the joins are the same joins and only the emits are saved.
2. **Is the n-ary join cheaper per unit than the binarized chain?** No, and Fermi prediction 3 said
   so before the code: per body match the n-ary kernel costs 233 to 434 instructions against the
   chain's 244 to 707, and the part of that gap which is not the emit is the chain's own index
   rebuild. The whole of the win is doing fewer emits, not cheaper joins.
3. **Does the link order change the answer?** No, and the evidence is a mutation rather than an
   argument: making the order ignore what is bound changes the plan visibly — a three-atom chain
   goes from two indexes to four, one of them a mask-of-nothing full scan — and every closure,
   certificate and checker assertion still passes.
4. **Does `MAX_VARIABLES` bind before `MAX_BODY`, as Fermi risk 6 predicted?** In the core, yes; in
   the **lowering**, it never did anything of the sort, because `passes::project` numbers variables
   before body planning and has always applied the bound to the unbinarized rule. Binarization never
   rescued a wide body, so the two policies have the same acceptance surface on that axis and the
   predicted population shift does not exist.
5. **Does the index count grow quadratically in the body length?** No — it falls. See the table
   above.
6. **Why was the first landing 11.6 per cent slower on the two-atom path?** Two mechanisms, both
   measured and both repaired: the witness slot written at a run-time index kept a stack array in
   memory across the innermost function (about fourteen instructions per candidate on dense
   closure), and inlining the four n-ary instantiations into `evaluate_into` displaced the register
   allocation of a loop they never enter (a further 3.9 per cent).
7. **Does the parity digest move?** No. It holds at
   `349333d4a4cc34a8ef8b64b5f68cdd127b967ff24d538de426eba28793f652ab`, 243 cases, 530,505 canonical
   bytes, native and WebAssembly byte-equal, and the regenerated manifest differs from the committed
   one in exactly five fields: the three edited source hashes and the two rebuilt library hashes.
   With the policy at two atoms `plan_bodies` emits what `binarize` emitted.

**Open.**

1. **Why do two changes that should be free make the two-atom kernel measurably worse?** Carrying
   the premise width on `Step` removes an array access and a bounds check from the innermost write
   path and costs 1.6 per cent; outlining the n-ary limits and dispatch removes code the two-atom
   path never executes and costs 2.6 to 3.9 per cent. *Evidence so far*: the shipped configuration's
   `evaluate_into` is 7,872 instructions against the control's 7,788, and the opcode difference from
   the control is dominated by `lea`, `imul` and `jae` — the premise column's multiply and its
   bounds check, replicated across the inlined `emit` sites. *Evidence gap*: a kernel-scoped
   `perf annotate` of the three bodies bucketed into validated address ranges, and a spill count from
   their stack traffic. *Owner*: the build-configuration and profile-guided-optimization sweep
   C1200's discovery-track entry proposes; this is the fourth and fifth instance of that lever and
   the first where the sign is against the change that should have been free.
2. **How much of the two-atom path's residual 1.7 to 2.1 per cent is the premise column and how
   much is drift?** The premise column is real executed work — one multiply and one bounds-check
   pair per derived tuple, and a premise pair where `join` had two registers — but a per-derived-row
   cost cannot account for 2 per cent on `closure` dense 256, which derives 65,536 rows out of
   4,210,688 candidates. So most of it is per candidate, which points at `join` rather than `emit`.
   *Evidence gap*: a variant that writes two separate premise columns for a body of at most two
   atoms, which would separate the storage change from the call-shape change. *Not taken here*: it
   would fork the hottest function in the crate for about two per cent.
3. **Why is `triangle`'s per-match cost 296 instructions at N = 4,096 and 434 at N = 16,384 when the
   two path families' barely move?** The likely reason is the fully bound link's index locality — a
   probe into an index over `domain²` — but nothing measures it. *Evidence gap*: the cache-event run
   at both `triangle` sizes rather than one. *Cheap*, one `ab.py` invocation.

No discovery-track entry beyond the one already logged: everything else here was inside what the
task was looking for.

## Remaining next steps

1. The seven candidates under the closeout, of which the static index's build cost is the largest
   measured effect in this report.
2. A body of more than four atoms has no cohort. `plan_bodies` chains one down to four and
   `demand_nary`'s corpus has none, because no source in the Rel fragment writes one today.
3. Nothing here measures a parallel workspace, unchanged from C1198: the demand evaluator has no
   parallel mode to measure one in.

## Replay commands

Run from `~/src/ergodis-private` unless noted. Every gate and every measurement went through
`nix develop ~/src/ergodis`, whose devShell asserts its rustc equals the `rust-toolchain.toml` pin,
so the gates and the measurements describe one build. Working files under `~/.cache/ergodis/c1193/`.

```sh
# Gates, core. Outcome: exit 0, 82 `test result: ok` blocks, zero FAILED;
# clippy and fmt clean; the two allocation regressions green.
cd ~/src/ergodis
nix develop . --command cargo test --all-features -j 8
nix develop . --command cargo clippy --all-targets --all-features -j 8 -- -D warnings
nix develop . --command cargo fmt --all -- --check
nix develop . --command cargo test -p ergodis-rules --test allocation -j 8
nix develop . --command python3 python/generate_evidence.py --write   # SHA256SUMS
cd ~/src/ergodis-private

# Gates, private. This drives rel_lowering, rel_frontend, rel_frontend_portability
# and rel_reference_eval, which is the C1189 differential under both policies.
choom -n 1000 -- nix develop ~/src/ergodis --command cargo test -p ergodis-private -p ergodis-tools -j 8
nix develop ~/src/ergodis --command cargo clippy -p ergodis-private -p ergodis-tools \
    --lib --bins --tests --examples -j 8 -- -D warnings
nix develop ~/src/ergodis --command cargo fmt -p ergodis-private -p ergodis-tools -- --check

# The corpus census the differential prints rather than asserts in full.
nix develop ~/src/ergodis --command cargo test -p ergodis-private \
    --test rel_reference_eval -j 8 -- --nocapture --test-threads 1

# The native/WebAssembly parity replay, which regenerates the committed manifest.
# Outcome: canonical digest 349333d4..., 243 cases, 530,505 canonical bytes.
choom -n 1000 -- nix develop ~/src/ergodis --command python3 \
    analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json

# The arms. Each is retained from the tree at its own revision; the control pair
# was retained before the first source change of the task.
git checkout 193ebd1 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout 193ebd1 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
git checkout cb11550 && ../ergodis-dev/scripts/retain-bin.sh . closure_ballpark --example --profile release
git checkout cb11550 && ../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools

A=analysis/datalog-comparison; C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1193
DIRECT=closure:sparse:256,closure:sparse:1024,closure:dense:256,closure:dense:512,samegen:sparse:1024,samegen:dense:512
NARY=triangle:sparse:4096,triangle:sparse:16384,path3:sparse:4096,path3:sparse:16384,path4:sparse:4096

# The two-atom path against the retained control. Outcome: 1.017 to 1.021 in
# instructions with nulls inside four parts per million.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-193ebd1 \
    --a-name control-193ebd1 --b $C/closure_ballpark-cb11550 --b-name candidate-cb11550 \
    --mode evaluate --rounds 5 --cpu 5 --repeats 3 --cohorts $DIRECT \
    --work $W/direct-work --out $A/ab-2026-09-17-c1193-direct.json

# The body policy: one binary, two arguments. Outcome: 0.523 to 0.959 in
# instructions, output digests identical on every cohort.
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-cb11550 \
    --a-name binarized --a-args "--bodies binarized" --b $C/closure_ballpark-cb11550 \
    --b-name nary --b-args "--bodies nary" --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts $NARY --work-may-differ --work $W/policy-work \
    --out $A/ab-2026-09-17-c1193-body-policy.json

# The supplementary cache set, its own run and its own nulls.
CE=cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses
nix develop ~/src/ergodis --command python3 $A/ab.py --a $C/closure_ballpark-cb11550 \
    --a-name binarized --a-args "--bodies binarized" --b $C/closure_ballpark-cb11550 \
    --b-name nary --b-args "--bodies nary" --mode evaluate --rounds 5 --cpu 5 --repeats 3 \
    --cohorts triangle:sparse:4096,path3:sparse:16384,path4:sparse:4096 --events $CE \
    --work-may-differ --work $W/policy-cache-work \
    --out $A/ab-2026-09-17-c1193-body-policy-cache.json

# The Rel route on the datalog cohort, one binary under two policies.
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
B=analysis/rel-frontend; T=$C/ergodis-tools-cb11550
nix develop ~/src/ergodis --command python3 $B/bench.py --binary $T \
    --binary-args "--body-policy nary" --control $T --control-args "--body-policy binarize" \
    --rounds 5 --cpu 5 --cohorts datalog --stages scan,parse,admit,lower,stratify --events $E \
    --out $B/performance-v10-c1193-body-policy-datalog.json

# What the lowered program becomes under each policy.
for p in binarize nary; do
  choom -n 1000 -- $T rel-lower --cohort datalog --definitions 512 --max-tuples 0 --body-policy $p
done

# Soufflé 2.5, compiled and interpreted, both -j1, on the three new families
# under each body policy. Outcome: the derived relation agrees on all six cases
# in both arms; n-ary halves the triangle gap.
S="nix shell nixpkgs#souffle nixpkgs#gcc nixpkgs#gnumake nixpkgs#time -c"
for p in nary binarized; do
  $S python3 $A/compare.py --bin $C/closure_ballpark-cb11550 --work $W/souffle-$p \
      --out $A/results-2026-09-17-c1193-$p.json --rounds 5 --cpu 5 \
      --harness-args "--bodies $p" \
      --sizes triangle:sparse:1024,4096 path3:sparse:1024,4096 path4:sparse:1024,4096
done

# The kernel-scoped profile, both policies, sixty iterations so the harness's
# one-shot path is under a quarter of a per cent.
P=~/.cache/ergodis/perf-c1193; mkdir -p $P
for p in binarized nary; do
  taskset -c 5 perf record -q -e instructions:u -F 4000 -o $P/path3-$p.data -- \
      $C/closure_ballpark-cb11550 --evaluator demand --evaluate-only --bodies $p \
      --program path3 16384 sparse 60 $W/perf-work
  perf report -q -i $P/path3-$p.data --no-children --percent-limit 0.05 --sort symbol
done

# The static index's build cost, which is the largest unexplained figure here.
for ix in auto sparse-indexes; do
  choom -n 1000 -- $C/closure_ballpark-cb11550 --evaluator demand --evaluate-only \
      --bodies nary --index $ix --program triangle 4096 sparse 3 $W/smoke
done

# The six core mutations, each against a `git archive HEAD` throwaway copy under
# ~/.cache/ergodis/c1193/mutate with its own target directory, never against the
# repository, each reverted with `git show HEAD:<path>`:
#   A  Link::old = (body_position != position)      -> 6 of 10 fail, Incomplete(0)
#   B  premises[level + 1] instead of link.position -> 3 of 10 fail, Unification(0)
#   C  `let verify = false` in bind_link            -> 1 of 10 fails, the collision case
#   D  the link order made body order               -> the plan changes, no closure does
#   E  the checker's premise walk `.take(2)`        -> 4 of 10 fail
#   F  closed_world skips a body over two atoms     -> the truncated certificate is accepted
# And the cross-repository one, which is the differential's own: mutation A in a
# throwaway core beside a throwaway private checkout, each with its own target
# directory, then the Rel differential against it.
#   -> 8 of 19 test binaries fail, the seeded 1,200-program corpus among them,
#      and the failure is the core's own derivation checker refusing:
#      "the core refused a lowered program: Core(Derivation(Incomplete(5)))"
```

Inputs are deterministic: the C1182 xorshift edge generator seeded by the domain, the C1189 corpus
seeded by `0x000c_1189_0915`, and the `demand_nary` digraph `x -> (3x + 1) mod N`,
`x -> (x² + 2) mod N`, which uses no random stream at all.

## What this task left under `~/.cache/ergodis/`

**Four retained binaries, 35 MB.** `bin/closure_ballpark-193ebd1` and `bin/ergodis-tools-193ebd1`
are the controls, retained from clean trees before the first source change;
`bin/closure_ballpark-cb11550` and `bin/ergodis-tools-cb11550` are the arms every figure above is
measured on and are **the controls the next A/B in this lane should use**.
`bin/closure_ballpark-4b854ff` and `bin/closure_ballpark-e8f0e06` are superseded candidates whose
A/B was re-run at `cb11550`; `bin/closure_ballpark-4b854ff` is the arm the "first landing" row of the
variants table is measured on, and `bin/ergodis-tools-e8f0e06` is cited by nothing.

**`c1193/`, 18 MB.** The three `ab.py` work directories, the `perf` work directory, the two Soufflé
work trees (7.6 MB each — the generated fact files, the compiled `.dl` binaries and every system's
output CSV), the smoke and probe directories, and five disassemblies and opcode histograms of
`Demand::evaluate_into` across the control and the variants.

**`perf-c1193/`, 185 KB.** The two kernel-scoped profiles.

**Deleted at task close**: `c1193/mutate` and `c1193/xchain`, the `git archive` copies every
mutation ran against, and `c1193/target`, their build directory. All are regenerable from the replay
block. Nothing under `bin/` was deleted.

`../ergodis-dev/scripts/cache-gc.sh` was run in its listing mode and **nothing was deleted; that is
the user's call.** It scanned 52 entries and showed **18 as unreferenced and old enough to remove**,
none of them this task's: the largest are `datalog-comparison` at 281 MB, `perf-c1170` at 162 MB,
`module-loading` at 124 MB, `worktrees` at 105 MB (kept as younger than two days),
`application-workspace` at 21 MB, and a tail of `perf-c1170-gaps*`, `perf-c1190`,
`property-tests`, `rel-frontend-reference`, `rule-contract`, `rule-runtime`, `js-wasm-tests`,
`lean-incremental-replay`, `browser-control-review` and `vet-7wV5`. This task's `c1193` and
`perf-c1193` show as younger than two days and every binary this report names shows as referenced
through `bin/MANIFEST.tsv`.

## Resume state for the next session

**The task is complete and every tree is committed.** Nothing is half-built, nothing is untracked,
and no path is left uncommitted in any of the three repositories.

| Repository | HEAD at close | Range this task added |
| --- | --- | --- |
| `~/src/ergodis` | `09a5c2b` | `e7116ba` … `09a5c2b` (three commits) |
| `~/src/ergodis-private` | `26d2468` | `193ebd1` … `26d2468` (five commits) |
| `~/src/othello` | this report's last commit | `4cd81ef` … here |

**Retained controls for the next A/B in this lane**, both from clean trees at `ergodis-private`
`cb11550` with core `ergodis` `09a5c2b`, rustc 1.95.0 (59807616e 2026-04-14), release, no features:

- derivation loop: `~/.cache/ergodis/bin/closure_ballpark-cb11550`, measured sha256
  `2888aecb8c9e80b370b42511ea7cffbd4bfaa25be7abab4c006fda5696dd1128`;
- frontend and stratified backend: `~/.cache/ergodis/bin/ergodis-tools-cb11550`, measured sha256
  `4c10145c54839a9793792b30a266c00ed0e9377d464a2c1624c63c9cf3080414`.

They supersede `closure_ballpark-193ebd1` and `ergodis-tools-193ebd1`, which are this task's own
controls and stay for its replay.

**Every gate is green at the committed heads.** The private
`cargo test -p ergodis-private -p ergodis-tools` was re-run at `26d2468` and reports **42 test
binaries, zero failures**; the core's `cargo test --all-features` at `09a5c2b` reports **82
`test result: ok` blocks, zero failures**; clippy with `-D warnings` and `cargo fmt --check` are
clean over both workspaces including examples; `SHA256SUMS` is current; and the native/WebAssembly
parity manifest is regenerated with its canonical digest unmoved.

**Exact commands to pick this up.**

```sh
# 1. The lifecycle close, which this task was told not to do: archive the C1193
#    row, delete it from the live queue, update the lane handoff and log the
#    incidental gem, in one coherent commit, per notes/task-lifecycle-conventions.md.
#    The discovery-track entry this task appended is already committed
#    (notes/ergodis-discovery-track.md, 2026-09-17, the stale shared-target finding).

# 2. The next lever, which is larger than this task's and is measured under
#    "The `ej` and `tt` closeout": a density rule, or a `Pages` reservation, for
#    a static join index's offsets array. Reproduce the figure with
C=~/.cache/ergodis/bin; W=~/.cache/ergodis/c1193
for ix in auto sparse-indexes; do
  choom -n 1000 -- $C/closure_ballpark-cb11550 --evaluator demand --evaluate-only \
      --bodies nary --index $ix --program triangle 4096 sparse 3 $W/smoke
done
# auto: 27.0 ms preparation, 71,516 KiB peak RSS, 0.87 ms evaluation
# sparse-indexes: 3.5 ms preparation, 5,904 KiB peak RSS, 2.39 ms evaluation
```

**Decisions left open for Tavis**, both stated with their evidence above and neither taken here:
the default body policy (the measurement favours `Nary`; three conditions under **Disposition** must
be discharged with it), and whether to delete the eighteen unreferenced cache entries
`cache-gc.sh` lists, none of which are this task's.

## Vibe check

Good, and the headline is bigger than the card asked for on one family and smaller on the others.
A three-atom body with a scaffold intermediate — the triangle — costs **0.52 of the instructions**,
derives forty-eight tuples where the binarized chain derives thirty-seven thousand, and peaks at
71 MB instead of 192; against compiled Soufflé the gap halves from 4.39 to 1.92. The two path
families are the honest middle at 0.93 to 0.96, worse than the Fermi, and the reason is the one
prediction that held: the n-ary join is not cheaper per unit, so the whole win is the emits.

One blemish, stated rather than rounded away. The two-atom path costs **1.7 to 2.1 per cent** of its
instructions, which is above the 0.8-to-1.7 band three earlier reports record for drift, and the
first landing cost 11.6. Both mechanisms were found and repaired — a witness slot written at a
run-time index, and four n-ary instantiations inlined into a function they have no business in — and
what remains is partly real work in the premise column and partly the same unexplained lever. Two
variants that should have been free made it **worse**, which is the fourth and fifth instance of
that lever and the first with the sign against the obvious change; the record of them is the useful
part.

The thing worth carrying forward is not in the card at all: on `triangle` at N = 4,096 the shipped
addressing policy spends **27 ms of preparation and 65 MB** building a direct counting-sorted index
for a static relation, against 3.5 ms and 6 MB for the sparse kind, and that single decision is what
puts this evaluator behind Soufflé on the one family where it should be ahead. C1192 measured the
probe and never priced the build. That is the next lever, and it is larger than this task's.
