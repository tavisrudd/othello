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

| Repository | Commit | What |
| --- | --- | --- |
| `othello` | `e9650e0` | this report's skeleton and the Fermi predictions, written before any code |
| `othello` | `71b55e5` | the controls retained, and the shared-target stale-artifact finding |
| `ergodis` | `d677a8b` | bodies of up to four atoms in the demand evaluator, and both checkers |
| `ergodis` | `089c6d9` | the three corpus cases the mutation pass showed the suite was missing |

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

## Method

To be written.

## Results

To be written.

## Profile

To be written.

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

To be written.

## Mystery ledger

To be written.

## Remaining next steps

To be written.

## What this task left under `~/.cache/ergodis/`

To be written.
