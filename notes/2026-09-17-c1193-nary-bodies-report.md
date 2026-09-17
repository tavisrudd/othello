# C1193 — bodies of more than two atoms in the demand evaluator

**Lane**: `ergodis`
**Date**: 2026-09-17
**Status**: IN PROGRESS. Written incrementally from the start of the task, so a crash leaves a
partial record rather than none. The Fermi predictions below were written before any code.

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

To be filled in as each lands.

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

To be written as the design lands.

## Method

To be written.

## Results

To be written.

## Profile

To be written.

## Exactness

To be written.

## Disposition

To be written.

## Mystery ledger

To be written.

## Remaining next steps

To be written.

## What this task left under `~/.cache/ergodis/`

To be written.
