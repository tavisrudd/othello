# C1061 probe 7: other problem domains and solve shapes

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 7 (domains beyond coded repair; "one decomposition, several semirings").
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**Predecessors**: probes 1, 2, 5 read in full; 3 and 4 skimmed.

Contract documents read in full before any work: `/home/tavis/src/ergodis/CLAUDE.md`,
`/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`, and the quantum-codes lane handoff
`notes/handoffs/2026-08-25-quantum-codes.md`.

## Question and verdict structure

Probes 1, 2, 3 and 5 all measured the same shape: a min-plus chain or balanced tree of
boundary-indexed summaries with a repair kernel at the leaves. This probe asks which *other*
shapes the compiled-dynamic-decision framing supports. Each domain gets the same five-part
verdict: (a) open-system decomposition and interface width, (b) event vocabulary and its algebra,
(c) optimization congruence and quotient size, (d) sequence-benchmark numbers against a fresh
solve, (e) which target semirings the decomposition supports.

Four domains were examined; three were prototyped and measured, one is argued.

## Files and commands

All work is in `ergodis-private`; `/home/tavis/src/ergodis` was not modified and its working tree
is clean. Committed as `cc59d6a`, with `src/lib.rs` staged as an exact patch so only my three
module lines were included and the concurrent `parametric_lrc` agent's line stayed in the working
tree.

- `/home/tavis/src/ergodis-private/src/semiring_tree.rs` — the semiring-generic retained
  composition tree: a `Semiring` trait, five instantiations, a const-generic-width `Summary`, the
  balanced tree with `set_leaf` path repair, and a law checker.
- `/home/tavis/src/ergodis-private/src/syndrome_window.rs` — the QEC decoding instantiation:
  schema, event contract, closed-form leaf, brute-force oracle, tropical normalization, orbit
  census.
- `/home/tavis/src/ergodis-private/src/policy_automaton.rs` — the policy automaton: trace
  composition tree, transition-monoid enumeration, Moore minimization, re-minimization locality.
- `/home/tavis/src/ergodis-private/tests/other_domain_shapes_allocations.rs` — zero-allocation
  regression for both update paths.
- `/home/tavis/src/ergodis-private/tasks/tools/src/other_domain_shapes_bench.rs` — the
  `other-domain-shapes-bench` subcommand of the existing `ergodis-tools` binary.

```
cd /home/tavis/src/ergodis-private
cargo test --release -p ergodis-private --lib -- semiring_tree:: policy_automaton:: syndrome_window::
                                                            # 16 passed
cargo test --release --test other_domain_shapes_allocations # 1 passed
cargo fmt -p ergodis-private -p ergodis-tools
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings
cargo build --release -p ergodis-tools
ergodis-tools other-domain-shapes-bench --mode census --resources 4 --operations 20000
ergodis-tools other-domain-shapes-bench --mode syndrome-delta --distance 4 --rounds 256 \
    --operations 3000 --verify
ergodis-tools other-domain-shapes-bench --mode policy-delta --positions 1024 --operations 5000 --verify
```

Both `--verify` runs re-check the incremental answer against a cold solve inside the measured
loop and completed with no mismatch. The crate-wide clippy gate reports three errors, all inside
`/home/tavis/src/ergodis-private/src/parametric_lrc.rs`, a concurrent agent's in-progress module
that I did not touch; my own files are clean under the same gate.

### Measurement method

Per the coordinator's instruction, **hardware counters are the primary metric and wall time is
secondary**, because the box is running other agents' builds and benchmarks. Every per-operation
figure comes from `perf stat -e instructions,cycles` on two run sizes of the same mode, differenced
so that process startup, instance generation and the snapshot bind cancel — the counter method the
performance playbook prescribes. The driver
(`scratchpad/probe7_ab.sh`) runs eight interleaved rounds, and each round executes both sizes of
both arms in a fixed order so that drift affects both arms of a pair equally. The analysis
(`scratchpad/analyze.py`) reports `n`, mean and standard deviation per arm, and a paired
`t` statistic and 95% confidence interval on the **log ratio** across rounds, exponentiated back to
a ratio. A difference is called a win only when the interval excludes 1.0.

## Domain 1 — quantum error correction: syndrome decoding as a chain over rounds

### The instance

A distance-`D` repetition code under a phenomenological noise model: an independent data-error
channel on each of the `D` qubits per round and an independent measurement-error channel on each of
the `M = D - 1` detectors per round. Writing `e_t` for the round-`t` data error and `f_t` for the
round-`t` measurement error, with `f_{-1} = 0` and a final perfect round forcing `f_{T-1} = 0`, the
observed detector vector is `d_t = H e_t + f_t + f_{t-1}` for the path incidence matrix `H`.

The decisive structural fact is that conditioning on `(f_{t-1}, f_t)` fixes `H e_t = d_t + f_t +
f_{t-1}`, and `H` has a one-dimensional kernel (the all-ones logical operator), so that equation has
**exactly two solutions**, distinguished by `e_0`. The round is therefore a closed-form function of
`(f_{t-1}, f_t, logical increment)` with no search inside the leaf — the opposite of the LRC fleet,
where ten kernel calls per leaf dominated everything.

This is a real decoder, not a toy: `compiled_chain_matches_brute_force_minimum_weight_decoding`
checks the compiled answer against exhaustive enumeration over all `2^15` error patterns at
`D = 3, T = 3` on 40 planted instances, entry by entry, including the absent case.

### (a) Decomposition and interface width

The chain axis is **time**, the leaf is one round, and the boundary label is `(f, l)`: the current
round's measurement-error vector together with the accumulated logical parity. Interface width is
`W = 2^M * 2 = 2^D`. The observable is the pair of root entries `(0,0)` and `(0,1)` — the best
explanation of the whole detector history in each logical class — and the decoder returns their
argmin.

Interface width is therefore **exponential in the code distance**, and that is the domain's
governing fact. It is measured directly, not argued. Per-event instruction counts at 1,024 rounds,
three interleaved rounds per distance, two-size differenced:

| distance `D` | width `W = 2^D` | instructions per event | sd | cycles per event | sd | growth vs previous |
|---|---|---|---|---|---|---|
| 2 | 4 | 5,040 | 0 | 1,730 | 56 | — |
| 3 | 8 | 37,525 | 0 | 11,075 | 310 | 7.45x |
| 4 | 16 | 281,580 | 0 | 89,079 | 69 | 7.50x |
| 5 | 32 | 2,565,491 | 0 | 633,159 | 85,000 | 9.11x |
| 6 | 64 | 21,974,623 | 3 | 4,856,519 | 1,684,546 | 8.57x |

The growth factor is 8 per unit of distance, which is exactly `W^3` for `W` doubling: composition
is cubic in the boundary width and the width doubles with each unit of distance. Instruction counts
are deterministic to within a few counts (`sd` of 0 to 3 over three rounds), so the exponent is
measured cleanly even on a loaded box; cycle counts carry real variance at the two largest widths
and are reported for completeness rather than as the basis of any claim.

**The wall is concrete.** At `D = 6` a single event costs 22 million instructions, which is more
than the entire fresh solve of the 16,384-pod LRC fleet in probe 2. Probe 1's finding that interface
width rather than system size is the controlling parameter is confirmed here in its sharpest form,
and it means the time-axis chain is only viable for small-distance codes or short windows. The
standard fix in the literature — decompose along space into code patches and use a matching or
union-find decoder inside each patch — is a *different* decomposition with a different leaf, and it
is not what this prototype measures.

### (b) Event vocabulary and its algebra

The declared vocabulary is `DetectorFlipped`, `DataErasureToggled`, `MeasurementErasureToggled`,
`RoundReplaced` (all parametric, affecting exactly one round's leaf), plus `CodeDistanceChanged` and
`WindowLengthChanged`, which return `RebaseRequired`. The affected set is derived from two declared
schema facts — rounds are coupled only through the `(f, l)` boundary, and every mutable parameter is
owned by exactly one round — rather than hardcoded per handler, following probe 2's contract shape.

The algebra is **genuinely better than in probes 1, 2 and 5**, and this is the most interesting
algebraic finding of the probe. Every toggle event is its own inverse, and toggles on distinct
coordinates commute, so the toggle part of the update monoid is an **elementary abelian 2-group**:
commutative, involutive, and a group rather than a monoid. A run of events on one round folds to
three XOR masks in `RoundRun`, so any stretch of the event log collapses exactly, events can be
sharded and reordered freely, and rollback is algebraic rather than requiring a retained snapshot.
Probe 1 had to repair a lossy saturating store to get exact collapse and probe 2's availability
events were last-writer-wins; here the group structure is present in the domain itself, because a
syndrome bit is a bit. `toggle_events_commute_and_are_involutions` and
`a_collapsed_run_equals_event_by_event_application` gate both properties.

`RoundReplaced` is the exception: it is last-writer-wins and discards earlier detector toggles, so
the full monoid is a group extended by a reset, not a group.

### (c) Optimization congruence and quotient size

The congruence is exact for the declared vocabulary by the same three conditions probe 1 verified:
the observable is a root entry, min-plus matrix product is associative with the identity as unit,
and each event names one leaf whose summary is a pure function of its parameter record.
`retained_window_matches_a_cold_solve_after_every_event` checks the retained answer against a cold
solve after every one of 3,000 events at `D = 4`.

The quotient is **not** as small as probe 2's. Tropical normalization over a 20,000-event stream at
`D = 3`, width 8, 1,024 rounds:

| | raw | tropically normalized |
|---|---|---|
| leaf summaries | 4 | 4 |
| root summaries | 799 | 42 |

Normalization collapses the root summaries 19-fold but leaves 42 classes, against the two to four
probe 2 measured on the LRC fleet. The leaves do not collapse at all, because with no erasures
active the four distinct detector values already give four distinct residual shapes. So the
finite-weighted-transducer ending that probe 2 made plausible for coded repair is **weaker here**:
42 states times an integer offset is still a compilable object, but it is not the four-state
transducer probe 2 pointed at, and the count is measured on one stream at the smallest interesting
distance rather than bounded.

**Offline orbit compilation.** The brief asked whether compiling by syndrome orbit under the code
automorphism group shrinks the table. For the ring version of the code, whose automorphism group is
the cyclic group of rotations (and the dihedral group with reflection added):

| detectors | raw syndromes | cyclic orbits | dihedral orbits | cyclic ratio | dihedral ratio |
|---|---|---|---|---|---|
| 4 | 16 | 6 | 6 | 2.67 | 2.67 |
| 6 | 64 | 14 | 13 | 4.57 | 4.92 |
| 8 | 256 | 36 | 30 | 7.11 | 8.53 |
| 10 | 1,024 | 108 | 78 | 9.48 | 13.13 |
| 12 | 4,096 | 352 | 224 | 11.64 | 18.29 |
| 14 | 16,384 | 1,182 | 687 | 13.86 | 23.85 |
| 16 | 65,536 | 4,116 | 2,250 | 15.92 | 29.13 |
| 18 | 262,144 | 14,602 | 7,685 | 17.95 | 34.11 |

`orbit_census_matches_burnside_on_small_rings` gates these against the published binary necklace and
bracelet counts (6, 8, 14 and 6, 8, 13 for lengths 4, 5, 6).

The verdict is unambiguous and negative for the compile-by-orbit hope: the reduction ratio is
`m` for the cyclic group and about `2m` for the dihedral group, exactly the group order, while the
raw table grows as `2^m`. A linear-in-`m` saving against an exponential-in-`m` table is not a
compilation strategy. This is the same lesson as probe 5's hostile-stream finding — the symmetry
group is small relative to the parameter space — arriving through a completely different route, and
the two together are strong evidence that symmetry reduction is a fleet-structure or
instance-structure win in this framework, never a structural bound.

### (d) Sequence benchmark against a fresh solve

Eight interleaved rounds, `D = 4` (width 16), 1,024 rounds in the window, two-size differencing
(20,000 against 40,000 events for the delta arm, 200 against 400 for the fresh arm). The delta arm
applies one event and reads the maintained root; the fresh arm applies the same event and then
re-evaluates every leaf and recomposes the chain from scratch.

| metric | fresh solve, mean per operation | sd | delta, mean per operation | sd | paired ratio | 95% CI | paired `t` | verdict |
|---|---|---|---|---|---|---|---|---|
| instructions | 37,934,226 | 16 (0.00%) | 281,576 | 22 (0.01%) | 134.7x | [134.7, 134.7] | 177,452 | win |
| cycles | 10,406,961 | 2,367,413 (22.75%) | 89,167 | 5,248 (5.89%) | 114.0x | [95.6, 136.0] | 63.6 | win |

`n = 8` rounds for both. Both intervals exclude 1.0, so both are wins; the cycle interval is wide
because the fresh arm's cycle count varied 23% round to round on a machine running other agents'
work, which is exactly why the instruction count is the load-bearing number.

Retained state is 2,097,152 bytes at 1,024 rounds and width 16; the update path recomposes 11 nodes
of 2,048, or 0.54% of the tree, and allocates nothing
(`probe_seven_update_paths_allocate_nothing_in_steady_state`, 20,000 events).

**The ratio is two orders of magnitude smaller than probe 2's**, and the reason is structural rather
than incidental. In probe 2 the leaf was ten expensive kernel calls, so eliminating 16,383 of 16,384
leaf evaluations bought about 10,000x. Here the leaf is closed form and composition dominates, so
the delta win is only the ratio of the path length to the chain length — about `1024/11 = 93`, plus
the leaf term, giving the measured 135. Stated as a rule: **the delta speedup in a chain is set by
how expensive the leaf is relative to the composition, not by how long the chain is.** A domain with
a cheap leaf and a wide interface gets a logarithmic win and nothing more.

Wall time is reported only as a secondary check: 1.02 ms per event at width 16 with 256 rounds in
`--verify` mode, which includes the in-loop cold-solve oracle and is therefore not a delta timing.

### (e) Semirings the decomposition supports

All five instantiated semirings compose over the identical compiled topology with no recompilation:
min-plus, max-plus, Boolean, counting, and sum-product over probabilities. `Summary` is generic in
the semiring and the leaf evaluator is generic through a `RoundCost` trait that scores one round
transition; `semiring_laws_hold` checks the additive and multiplicative identities, commutativity,
both associativities, annihilation and both distributive laws on sample sets for each.

For this domain the functors are not decoration — **they are different decoders**:

- min-plus over Hamming weight is minimum-weight decoding, the matching-decoder objective;
- sum-product over the channel probabilities is degeneracy-summing maximum-likelihood decoding;
- counting counts the explanations of each logical class;
- Boolean decides feasibility of each class.

On a 12-round planted instance at `D = 3`: min-plus `[7, 7]`, max-plus `[51, 51]`, Boolean
`[true, true]`, counting `[8589934592, 8589934592]`, probability `[6.192e-12, 3.409e-12]`. The
counting semiring is exactly the brute-force count of consistent patterns per class, gated by
`counting_semiring_counts_the_explanations_brute_force_finds` against exhaustive enumeration. The
min-plus classes tie at weight 7 while the probability functor separates them, which is the textbook
statement that minimum-weight and maximum-likelihood decoding differ under degeneracy — and here it
falls out of running two functors over one compiled tree.

Measured over 2,000 planted trials per noise level at `D = 3`, 8 rounds:

| planted error rate | min-plus logical error rate | sum-product logical error rate | trials where the two functors disagree |
|---|---|---|---|
| 1/4 | 0.4955 | 0.4970 | 531 |
| 1/8 | 0.3720 | 0.3760 | 376 |
| 1/16 | 0.1800 | 0.1720 | 156 |
| 1/32 | 0.0545 | 0.0530 | 49 |

The two decoders disagree on 2.5% to 27% of instances depending on noise, with sum-product ahead at
the two lower rates. This is the strongest concrete evidence in the C1061 series for the brief's
"one compiled topology, several functors" claim: the functor is not a reporting choice, it changes
the answer, and swapping it costs one type parameter.

## Domain 2 — security policy automata

### The instance

A capability policy over `r` resources: states are subsets of granted resources plus an absorbing
deny sink, symbols are `grant(x)`, `revoke(x)` and `use(x)`, and `use` of an ungranted resource
moves to deny. This is a real policy shape rather than a random automaton, and it separates the two
composition axes cleanly.

### (a) Decomposition and interface width

The summary of a stretch of request trace is its **transition function** `Q -> Q`. Because the
policy is deterministic, the summary is a function rather than a relation: interface width is `|Q|`
entries and composition is `|Q|` lookups, against `|Q|^2` entries and `|Q|^3` work for the
Boolean-matrix composition a nondeterministic policy would force. Determinism is the whole
performance story in this domain, and it is the sharpest contrast with domain 1, where the summary
is an unavoidable `W x W` matrix.

At 4 resources the policy has 17 states and 12 symbols; over a 4,096-position trace the retained
tree holds 557,056 bytes and a single-position update recomposes 13 nodes.

### (b) Event vocabulary and its algebra

Two event classes with genuinely different affected sets:

- `SymbolReplaced(position, symbol)` — parametric, one leaf, last-writer-wins, a monoid with no
  inverses and no commutativity (replacing position 3 then position 3 again is not the same as the
  reverse).
- `RuleChanged(state, symbol, target)` — **not leaf-local**. It touches every trace position
  carrying that symbol. The affected set is derived from an inverted symbol-to-position index built
  at bind time. Measured on a 4,096-position trace with 12 symbols: a rule change touches 341.3
  leaves on average and recomposes 1,664 nodes, against 13 nodes for a single-position edit. That is
  a 128-fold wider affected set, and it is the first event in the C1061 series whose affected set is
  a fixed *fraction* of the artifact rather than a path.
- `StateAdded` and any change to `|Q|` are structural and require a rebase.

The composition target is the Boolean semiring in the sense that the answer is permit or deny, but
the summary monoid is the **transition monoid** of the automaton, not a matrix semiring.

### (c) Optimization congruence and quotient size

Here the congruence is finite **by construction**, with no normalization argument needed — the
strongest contrast with the tropical domains, where finiteness had to be measured and could not be
bounded. Two traces are indistinguishable for every future continuation exactly when their
transition functions agree, so the quotient is the transition monoid, of size at most `|Q|^|Q|`.

| resources | states | symbols | transition monoid | distinct summaries retained over a 4,096-position trace | Myhill--Nerode classes |
|---|---|---|---|---|---|
| 2 | 5 | 6 | 26 | 25 | 5 |
| 3 | 9 | 9 | 126 | 120 | 9 |
| 4 | 17 | 12 | 626 | 409 | 17 |

The monoid is tiny — 626 elements for a state space that admits `17^17` functions — and the retained
tree's distinct summaries stay under it, as `the_transition_monoid_is_finite_and_bounds_the_retained_summaries`
asserts. A 626-entry transition table over 12 symbols is a compiled finite transducer that could be
emitted directly, which is the brief's "exact optimization becomes a finite weighted transducer"
ending actually reached rather than approached.

**Is incremental re-minimization local?** The unreplicated capability policy is already minimal
(Myhill--Nerode classes equal states at every size), so no rule change can alter its partition and
the question is vacuous there — a measurement artifact worth stating, because it looks like a
perfect locality result and is not one. The honest test uses a deliberately non-minimal policy:
`replicated_capability_policy(3, k)` replicates each state `k` times so that the minimal quotient has
9 classes against `9k` states, and one rule change can genuinely split a class. Measuring the
label-invariant partition change — how many unordered state pairs flip from equivalent to separated
or back — over 500 single-rule changes at 3 resources:

| replicas | states | Myhill--Nerode classes | trials with the partition unchanged | mean separated pairs | mean merged pairs | total pairs | mean flipped fraction | worst flipped pairs |
|---|---|---|---|---|---|---|---|---|
| 2 | 18 | 9 | 60 / 500 | 7.14 | 0.00 | 153 | 0.047 | 9 |
| 3 | 27 | 9 | 60 / 500 | 21.41 | 0.00 | 351 | 0.061 | 27 |
| 4 | 36 | 9 | 60 / 500 | 42.83 | 0.00 | 630 | 0.068 | 54 |

Two findings. First, **re-minimization is local in the partition but not rare**: 88% of single rule
changes alter the partition, but each alters only 4.7% to 6.8% of the pair relation, and the flipped
fraction grows only slowly with the state count. Second, and cleanly one-directional, **every change
separates and none merges**: a rule change breaks equivalences and never creates them, in every one
of 1,500 trials. That is a monotone, semilattice-shaped update on the quotient — refinement only —
which is exactly the join-semilattice special case the brief flags as offering extra leverage
(idempotent, monotone pruning). An incremental minimizer for this event class only ever needs to
split blocks, never to merge them, which is the cheap direction. The one caveat is that the trials
apply a change and revert it, so the result is about single changes against a fixed baseline, not
about the compounding of a long edit sequence.

Reported alongside these is the label-dependent count of states whose class *label* changed; it
over-counts when a split renumbers later classes, and the pair counts above are the figures to use.

### (d) Sequence benchmark against a fresh solve

Eight interleaved rounds, 4,096-position trace, 4 resources, two-size differencing (40,000 against
80,000 edits). The delta arm edits one position and reads the maintained root; the fresh arm edits
one position and re-executes the whole trace directly through the automaton, which is what a policy
engine without retained state does.

| metric | fresh, mean per operation | sd | delta, mean per operation | sd | paired ratio | 95% CI | paired `t` | verdict |
|---|---|---|---|---|---|---|---|---|
| instructions | 44,375 | 0 (0.00%) | 3,403 | 0 (0.00%) | 13.0x | [13.0, 13.0] | 1,551,582 | win |
| cycles | 38,440 | 511 (1.33%) | 1,028 | 304 (29.60%) | 39.0x | [30.1, 50.5] | 33.6 | win |

`n = 8`. Both intervals exclude 1.0. The delta path allocates nothing over 20,000 edits.

The instruction ratio of 13 is close to the structural prediction `4096 / (13 * 17) = 18.5`
discounted by the fresh path's cheaper inner step, so the counter and the model agree. The **cycle
ratio of 39 is three times the instruction ratio**, and that gap is a real effect rather than noise:
the fresh arm walks 4,096 positions through a serially dependent chain of table lookups whose
address depends on the previous result, so it is latency-bound, while the delta arm's 13 nodes fit
in cache and its 17-entry gather has no cross-node dependency. The delta path's cycle standard
deviation of 29.6% reflects how short the measured work is (about 1,000 cycles per edit) against a
loaded box; the instruction count, deterministic to zero variance, is the number to quote.

### (e) Semirings the decomposition supports

Function composition over a deterministic automaton is not a matrix semiring, so this decomposition
does **not** slot into the generic `Summary` type, and that is a finding rather than an omission:
the "one decomposition, several semirings" claim has a precondition, namely that the summary is a
matrix over a semiring. Determinism buys a 17-fold cheaper composition and costs the functor
freedom.

The lift is available if wanted: represent the summary as a Boolean `|Q| x |Q|` matrix and every
listed semiring applies again — Boolean for reachability under a nondeterministic policy, counting
for how many rule paths permit a trace, min-plus for the cheapest permitting path under rule costs,
probability for a stochastic policy. The cost is `|Q|^2` state and `|Q|^3` composition, which at
17 states is 289 entries and 4,913 operations against 17 lookups. The trade is explicit and
measurable; nothing about it was prototyped.

## Domain 3 — network resilience on a Clos or fat-tree fabric (argued, not prototyped)

Not prototyped: the two prototyped domains consumed the probe's budget, and the argument below is
strong enough to say what a prototype would have to overcome.

**(a) Decomposition and interface width.** The natural leaf is a pod and the natural boundary is the
pod's core-facing uplink set. For a `k`-ary fat-tree each pod has `(k/2)^2` uplinks — 576 at
`k = 48` — so a per-uplink min-plus boundary summary would be 331,776 entries per node and
composition would be `576^3` about `1.9 x 10^8` operations, an order of magnitude worse than domain
1's measured wall at `D = 6`. Taken literally, the interface is far too wide.

The escape is that a healthy fat-tree's uplinks are **interchangeable under the fabric's
automorphism group**, so the boundary collapses to a small number of uplink *classes*, and the
effective width is driven by the number of distinct failure and congestion classes at the boundary
rather than by the link count. That makes it a close structural analogue of probe 5's leaf-class
memoization, and it inherits probe 5's negative control: the collapse is large when the fabric is
uniform and disappears as failures become individually distinguishable. The controlling parameter is
therefore the number of concurrently distinct boundary conditions, and the compiled artifact would
need a rebase or a class-cache miss path when that number exceeds the compiled envelope. That is a
testable hypothesis, and it is the first thing a probe here should measure.

**(b) Event vocabulary.** `LinkFailed` / `LinkRecovered` are involutive toggles, as in domain 1, and
commute across distinct links, so the failure part of the vocabulary is again an elementary abelian
2-group. `LinkCapacityChanged` and `DemandAdded` / `DemandRemoved` are last-writer-wins and additive
respectively; `SwitchAdded` and any change of `k` are structural. The affected set of a link failure
is the pod owning the link plus its ancestors, which is a path — the good case, unlike domain 2's
rule change.

**(c) Congruence.** Min-plus shortest-path composition over a frozen quotient already exists in the
core (`/home/tavis/src/ergodis/src/frozen_shortest_path.rs`, with `solve_validated` and
`verify_result`), so the composition law is available; the open question is whether the boundary
class set stays finite under the failure vocabulary, which is precisely the domain-1 question and
would be settled the same way, by a normalized-class census under a hostile stream.

**(d) Numbers.** None. Marked inconclusive.

**(e) Semirings.** This is the best fit of the four for the multi-functor claim, because the
practical objectives are genuinely different semirings over one topology: min-plus for latency,
max-min (bottleneck) for bandwidth, Pareto for the latency-bandwidth pair — the core already has
Pareto-front composition in `ordered_resource.rs` — Boolean for reachability under failure, and
probability for path availability. All five are matrix semirings over the same boundary, so unlike
domain 2 the generic `Summary` type applies directly.

## Domain 4 — one decomposition, several semirings

This was folded into domain 1 rather than run as a separate combinatorial-market or
storage-placement instance, because the QEC chain turned out to give a sharper test: there the
different functors are different *decoders* with measurably different error rates, whereas over a
repair topology the alternative semirings would mostly re-derive quantities nobody disputes. The
verdict is in domain 1(e) and the supporting numbers are the decoding-accuracy table.

The reusable asset is `/home/tavis/src/ergodis-private/src/semiring_tree.rs`: a `Semiring` trait
with five instantiations and a law checker, a const-generic-width `Summary` with `compose_into`,
`zero` and `identity`, and a balanced `RetainedTree` with `bind`, `set_leaf`, `fresh_root` and the
state and path accessors. It is the trait layer probe 1's survey (item A6.4) listed as missing, and
it is domain-neutral: both domain 1 and the Boolean-matrix lift of domain 2 instantiate it without
change. Promotion to the public core is plausible but not yet justified — it has two consumers, both
in this probe.

One negative worth recording: the probability semiring's laws hold only up to floating-point
rounding, since `f64` addition is not associative. The law checker passes it on dyadic samples and
would fail on adversarial ones. Any use of the probability functor for an exact claim needs a
log-domain or rational representation; it is fine for a decoder that compares two magnitudes.

## Ranking against the brief's hypothesis

The brief ranked domains 1 to 5 on compositional quotient, delta algebra and bounded interface. This
probe's measurements revise three rows and add one.

| Domain | Brief's overall | Measured or argued here | Revision |
|---|---|---|---|
| Security FSM / policy | 5 | Quotient finite by construction and tiny (626 elements at 17 states); trace-edit delta a measured 13.0x in instructions, 39.0x in cycles; update monotone (splits only, never merges) | **Confirmed, with one correction**: rule-change events have an affected set 128x wider than a path, so the delta win applies to trace events and not to policy edits. Interface width is `\|Q\|`, the best of any domain measured. |
| Coded checkpoint recovery / storage repair | 5 | Probes 1, 2, 5: 10,000x delta win, 2 to 4 normalized classes | Unchanged; still the strongest measured domain |
| Network resilience / routing | 4.5 | Argued only; raw interface far too wide, rescued only by fabric symmetry, which probe 5's negative control says is fleet-structure-dependent | **Downgrade to conditional.** The rating depends on an unmeasured claim about boundary-class collapse. Best multi-semiring fit of any domain. |
| QEC decoding (new row) | not ranked | Congruence exact; update monoid is an abelian 2-group (the best algebra measured anywhere in C1061); interface width `2^D` measured to grow `8x` per unit distance; delta win only 134.7x; orbit compilation reduces by the group order against an exponential table | **Add at about 3.** Excellent algebra, excellent event vocabulary, and a hard exponential interface wall at distance 5 to 6 for this decomposition. |
| Sparse expressive markets | 4 | Not examined | — |
| Generic MILP | bad target | Not examined | — |

The two cross-domain rules this probe adds to the brief:

1. **The delta speedup in a chain is set by the leaf-to-composition cost ratio, not the chain
   length.** Probe 2's 10,000x came from an expensive leaf; domain 1's 135x and domain 2's 13x come
   from cheap leaves. A domain with a cheap leaf gets a logarithmic win and nothing more, and that is
   predictable before any code is written.
2. **Symmetry reduction is an instance-structure win, never a structural bound.** Probe 5 measured
   this on the hostile LRC stream (a collapse ratio of 1.034); the orbit census here reaches the same
   verdict by a different route, since a group of order `m` or `2m` cannot dent a table of size
   `2^m`. Any future proposal to "compile by orbit type" should be required to state the group order
   against the table size first.

## Mystery ledger

- **42 normalized root classes, against probe 2's two to four.** Both are measured on one stream.
  The difference is plausibly that the LRC leaf cost function `100 * unserved + 7 * levels` has very
  few residual shapes while the syndrome leaf's shape varies with the detector vector, but that has
  not been checked. Open; the cheap test is a normalized-class census at `D = 4` and `D = 5` to see
  whether the count grows with width, which would settle whether 42 is a small constant or the start
  of an exponential.
- **The cycle ratio in domain 2 is 3x the instruction ratio (39.0 against 13.0).** Attributed above
  to the fresh path's serially dependent lookup chain being latency-bound. That attribution is
  reasoned, not measured: settling it needs a cache-miss and stalled-cycle counter run, which was not
  done. It matters because the 39x figure is the one a systems audience would quote and only the 13x
  is structurally defensible.
- **The delta arm's cycle standard deviation is 29.6% in domain 2 and 5.9% in domain 1.** Both arms
  execute deterministic instruction streams (instruction sd of zero), so the variance is entirely
  environmental — the box is running other agents' builds. It is why every claim here rests on the
  instruction counts. Not settled; settling it needs an idle box, pinning, and a fixed governor,
  which the probe did not have.
- **Every rule change in domain 2 separates pairs and none merges, in 1,500 trials.** This looks like
  a theorem about single-transition perturbations of a replicated automaton rather than a
  coincidence, and it would be worth proving rather than sampling, because a proved
  refinement-only property licenses a split-only incremental minimizer with no merge path at all.
  Open, and cheap to attack: the replicated construction makes all replicas of a state equivalent
  through a single shared future, and changing one transition can only destroy that sharing.
- **Domain 1's decoder is exact but the code is a repetition code**, whose parity check has a
  one-dimensional kernel, which is what makes the leaf closed-form. A genuine surface or CSS code has
  a higher-dimensional kernel and the leaf becomes a minimum-weight coset search rather than a table
  lookup — which would move this domain toward probe 2's cost profile (expensive leaf, better delta
  ratio) while making the interface wider still. That trade is unmeasured and is the single most
  informative follow-on for this domain. The existing `bp_osd.rs` (`BinaryParityCheck`,
  `BpOsdWorkspace::decode`) is the natural leaf kernel for it and was not used here.
- No algebraic mystery remains in the update algebras themselves: domain 1's group structure and
  domain 2's monoid structure were both stated in advance and confirmed by test.

## Vibe check

Good, and more informative in its negatives than its wins. Three genuinely different shapes were
examined and two prototyped to exact-agreement gates: quantum error correction gave the best update
algebra seen anywhere in C1061 (an abelian 2-group, so runs collapse and rollback is free) together
with the hardest wall (interface width `2^D`, measured growing 8x per unit distance, unusable past
distance 6), and the policy automaton gave the only domain where the congruence is finite by
construction rather than by measurement, with a 626-element transition monoid that could be emitted
as a compiled transducer today. The orbit-compilation idea from the brief is measured and dead in
this form. The single most useful general finding is that a domain's delta speedup is predictable
before writing code from the leaf-to-composition cost ratio, which explains probe 2's 10,000x and
this probe's 135x and 13x with one rule.

## Next probes

1. Replace the repetition code with a real CSS code from the existing machinery, using
   `bp_osd.rs`'s `BinaryParityCheck` as the leaf kernel, and re-measure the leaf-to-composition
   ratio and the interface width. This is the one experiment that would tell us whether QEC decoding
   is a probe-2-shaped domain or stays interface-bound.
2. Census the normalized root classes at `D = 4` and `D = 5` to decide whether 42 is a constant or
   grows with width.
3. Emit the 626-element transition monoid of the 4-resource capability policy as a compiled
   transducer and measure a trace evaluation against the retained tree. The brief's finite-transducer
   ending is closer here than in any other domain.
4. Prove, rather than sample, that a single transition change to a replicated automaton refines the
   Myhill--Nerode partition and never coarsens it, then build the split-only incremental minimizer it
   licenses.
5. Prototype the Clos fabric with `frozen_shortest_path.rs` at the leaves and measure the boundary
   class collapse under a failure stream, with probe 5's unique-pod negative control included from
   the start.
