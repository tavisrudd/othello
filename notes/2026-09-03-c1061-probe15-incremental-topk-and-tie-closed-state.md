# C1061 probe 15: incremental top-k, tie-closed state, and a measurement correction

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 15, building on probe 12's structural result that leaf summaries commute and
the fleet optimum is a three-level knapsack over the multiset of leaf profiles.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `src/policy_topk.rs` — the allocation-free incremental policy.
- `src/fleet_congruence.rs` — the fleet corpus for the probe-4 congruence scorer.
- `tests/policy_topk_allocations.rs` — zero-allocation regression.
- `tasks/tools/src/tie_state_bench.rs` — the tie-multiplicity sweep and the scorer report.
- `tasks/tools/src/summary_cache_bench.rs`, `scripts/counter_ab.py` — harness fix and new operations.
- `src/congruence_search.rs` — **one additive public constructor** (`CongruenceCorpus::from_parts`)
  so a probe in another module can reuse the audited scorer instead of reimplementing it. This is a
  shared file; the change adds no behaviour and touches nothing existing.
- `evidence/2026-09-03-lrc-fleet-counter-ab-probe15{,-leaf,-fixed,-final}.json`; the `-final` file
  is the campaign against the retained hashed binary and is the source of every reported figure.

**Commit status — needs the coordinator's attention.** All of this probe's work is committed and
its tests pass, but **not under my own commit**: while I was staging, the probe-14 agent's commit
`1cd8960` ("Record the empirical answer to the ADR's gating question") swept my staged index and
untracked files into itself. `src/policy_topk.rs`, `src/fleet_congruence.rs`,
`tests/policy_topk_allocations.rs`, `tasks/tools/src/tie_state_bench.rs`, the
`CongruenceCorpus::from_parts` hook, the harness changes, and all four evidence files are in
`1cd8960` rather than in a probe-15 commit. Nothing is lost and I have not rewritten history. The
shared-index hazard is that a concurrent `git add -A` or `git commit -a` consumes another agent's
staged work; agents sharing this repository should stage and commit in one step with explicit
pathspecs, or the index needs to stop being shared.

## 0. A measurement correction that invalidates probe 12's headline

Probe 12 reported that the compiled policy costs **28% more instructions per event** than the
retained tree, and probe 15 set out to close that gap. The gap was an artifact of my own harness.

The counter harness sizes an operation by wall time and derives per-operation counters by
differencing runs at `N` and `N/2` repeats. That cancels setup **only if setup is constant in `N`**.
The policy, table, and leaf operations pre-drove a driver tree for `repeat` events in setup, so
their setup scaled with `N` and the differencing charged each of them for **one extra tree update
per event**. The diagnostic that exposed it was measuring the tree's own leaf evaluation in
isolation: it came out at 26.1k instructions against 16.2k for the whole tree delta that contains
it, which is impossible.

The fix is a fixed-size pre-drawn event window (4,096 entries) that the measured loop cycles
through, so setup no longer scales with `repeat`. Re-measured, at 16,384 pods:

| operation | probe 12 / earlier probe 15 | corrected | what the error was |
|---|---|---|---|
| retained-tree delta | 16.2k | **15.2k** | setup drew events only; error negligible |
| probe 12 rescanning policy | 20.7k | **5.4k** | inflated by one tree update |
| probe 12 compiled table | 18.9k | **2.8k** | inflated by one tree update |
| probe 15 incremental top-k | 18.8k | **1.3k** | inflated by one tree update |

**Probe 12's conclusion is therefore wrong and is corrected here: the compiled policy is 2.81x
cheaper than the tree, not 1.28x more expensive.** A correction note belongs on probe 12's report.
The wider lesson is that a differencing harness needs its setup pinned, and that a per-operation
sanity check — is a part cheaper than the whole that contains it? — catches the class of error that
statistics cannot.

## Part A — the incremental top-k policy

### A1. What was built

`TopKPolicy` exploits two facts probe 12 established but did not use:

- **A class's discount vector never changes**; only its multiplicity does. So the classes are kept
  in an order sorted by discount, fixed at intern time, and an event only moves counts inside it.
- **The knapsack grants at most three levels**, so it needs only the three best `d(1)` values, the
  two best `d(2)`, and the best `d(3)`. A walk down the fixed order collects them and stops as soon
  as the slots are full, which is one or two classes deep on a real fleet.

The gain vector and the grant come from a **single** pass (`solve`), where probe 12 re-solved the
knapsack four times to build the same vector. Interning uses an open-addressed table keyed on the
exact packed budget response, so there is no hashing of a 20-byte profile and no allocation;
exceeding the compiled profile capacity returns a bounded `PolicyError` rather than growing.

### A2. Measured

Instructions per event at 16,384 pods, eight interleaved rounds, paired log-ratios:

| operation | instructions | cycles | IPC |
|---|---|---|---|
| retained-tree delta | 15.2k | 2.8k | 5.38 |
| **incremental top-k policy** | **1.3k** | **294** | 4.55 |
| probe 12 rescanning policy | 5.4k | 1.2k | 4.60 |
| probe 12 compiled table | 2.8k | 680 | 4.05 |
| decided leaf alone (diagnostic) | 740 | 197 | 3.76 |
| tree's own leaf alone (diagnostic) | 9.1k | 1.5k | 5.86 |

| comparison | instructions | cycles [95% CI] | verdict |
|---|---|---|---|
| **tree delta over incremental top-k** | **11.37x** | **9.59 [8.95, 10.27]** | **target met** |
| rescanning policy over incremental top-k | 4.05x | 3.98 [3.56, 4.45] | faster |
| tree delta over probe 12 rescanning policy | 2.81x | 2.41 [2.14, 2.72] | faster |
| tree delta over probe 12 compiled table | 5.52x | 4.40 [3.17, 6.11] | faster |
| top-k rack fleet over unique fleet | 1.03x | 1.02 [0.98, 1.06] | fleet-shape independent |
| tree's own leaf over decided leaf | 12.24x | 7.84 [7.26, 8.46] | faster |
| top-k event over decided leaf alone | 1.81x | 1.49 [1.43, 1.56] | — |

**The target is met with room to spare: 11.37x fewer instructions than the tree, cycle interval
[8.95, 10.27] excluding 1.0 comfortably.** The cost decomposes cleanly: 740 instructions are the
decided leaf re-profiling, which every path must pay, and the remaining ~560 are interning, the
count move, and the knapsack — so the policy is now within 1.81x of the irreducible leaf cost.

The other diagnostic is worth stating on its own: the tree's leaf evaluation costs 9.1k instructions
against the decided leaf's 740, a 12.24x gap, because `pod_summary` makes ten published-kernel calls
where the decided path makes four closed-form ones. Most of the tree's per-event cost was never the
tree.

### A3. State and allocations

| quantity | value at 16,384 pods |
|---|---|
| top-k policy state | **56,320 bytes** |
| distinct profile classes held | 16 |
| retained tree state (value-only) | 3,014,656 bytes |
| ratio | **53.5x less state** |

`tests/policy_topk_allocations.rs` drives 50,000 pre-drawn events through a warmed policy under a
counting global allocator and asserts **zero** allocations, then asserts zero again for a `solve`
call, and checks the value against the tree.

Exactness gates: `topk_policy_matches_the_retained_tree` (20,000 events on 512 pods, compared every
event) and `topk_policy_matches_the_rescanning_policy_including_the_gain_vector` (10,000 events,
comparing the optimum, the whole gain vector, and the baseline against probe 12's implementation).
The `tie-state-bench` driver additionally asserts policy-versus-tree agreement on every one of its
training events, which is where the 10^5-event requirement is met at 16,384 pods.

## Part B — does tie multiplicity close the state?

Probe 12 attributed the conflicting table keys to the multiplicity of pods tied at the top of the
discount order. This sweeps state keys from the gain vector through count vectors capped at `c` to
the uncapped count vector, at 16,384 pods, replaying 100,000 fresh events after each training run.

Two implementation notes first. Keys are built from the **exact packed profile identity**, not from
instance-local class indices — probe 12 lost a measurement to that confusion, and my first pass here
lost another to a hand-rolled 64-bit identity that overflowed and collided; the packed response key
is collision-free by construction. And each replay event is resynchronized against the policy, so
every event is measured independently rather than measuring one early divergence repeatedly.

| state key | train | states | transitions | conflicts | rebases /100k | value errors |
|---|---|---|---|---|---|---|
| gain vector | 400,000 | **7** | 4,496 | 2 | 1,362 | 1 |
| counts, cap 2 | 400,000 | 717 | 105,623 | 3 | 99,997 | 0 |
| counts, cap 3 | 400,000 | 1,096 | 125,682 | 1 | 99,997 | 0 |
| counts, cap 4 | 400,000 | 1,453 | 139,707 | 1 | 99,997 | 0 |
| counts, uncapped | 400,000 | 142,015 | 376,175 | **0** | 99,999 | 0 |
| gain vector | 800,000 | **7** | 5,273 | 4 | 949 | 1 |
| counts, cap 2 | 800,000 | 1,287 | 183,497 | 4 | 99,997 | 0 |
| counts, cap 3 | 800,000 | 1,877 | 215,567 | 2 | 99,997 | 0 |
| counts, cap 4 | 800,000 | 2,420 | 238,682 | 3 | 99,997 | 0 |
| counts, uncapped | 800,000 | 270,616 | 741,447 | **0** | 99,999 | 0 |

**Capping does not close the conflicts.** Caps 2, 3, and 4 still show one to four conflicting keys at
both training lengths. The reason is structural and was predictable: a capped count sitting *at* the
cap could stand for the cap or for any larger number, so its image under a decrement is ambiguous.
No finite cap is closed under a vocabulary that removes a pod from a class.

**Only the uncapped count vector is conflict-free** — zero conflicts at both 400,000 and 800,000
training events. It is the exact sufficient statistic. But it buys that exactness by having
essentially one state per event: 142,015 states from 400,000 events and 270,616 from 800,000, with a
fresh-stream rebase rate of **99.999%**. The table never generalizes, so as a compiled artifact it
does nothing.

**The exact quotient, stated plainly.** For the value alone, counts capped at three suffice, because
the knapsack grants at most three levels. For closure under the declared vocabulary, no capped
statistic works, and the coarsest exactly-closed count statistic is the **uncapped profile-count
vector**. It is finite for a fixed fleet size — the number of multisets of `P` profiles over `n`
pods — but that count grows combinatorially in `n`, and the reachable set on any real stream grows
with the stream. So there is no state key that is both exact and compressive: the gain vector
compresses to 7 states with a 1% rebase rate and one value error per 100,000 events; the exact key
compresses to nothing.

## Part C — the congruence scorer's verdict

Replay can only say "no counterexample yet on this stream". The probe-4 congruence scorer closes a
state space under the declared vocabulary and then checks *every* class for value exactness and
one-step closure, which is a decision over the whole reachable set. `fleet_congruence.rs` builds
that corpus for a three-pod fleet with a restricted vocabulary, and scores each candidate statistic.

Corpus: 1,991 states, 469 of them carrying the conditions, 21 declared events, closure depth 2.

| statistic | features | quotient | exactness violations | closure violations | congruence |
|---|---|---|---|---|---|
| gain vector + baseline | 5 | 18 | **0** | 2,347 | no |
| profile counts, cap 3 | 13 | 95 | **0** | 800 | no |
| profile counts, uncapped | 13 | 95 | **0** | 800 | no |
| per-pod profile assignment | 3 | 133 | **0** | 82 | no |
| per-pod profile + parameters | 9 | 298 | **0** | **0** | **yes** |

Three things follow, and the first is a correction to how Part B should be read.

**Every candidate is exact for the value.** Not one class of states sharing a statistic disagrees on
the optimum. The value congruence was never in doubt; what fails is closure.

**No multiset statistic is closed, including the uncapped counts.** The scorer refutes the count
vector with 800 closure violations. The reason is that the declared vocabulary names a **pod**:
`DemandChanged { pod: 1, .. }` maps two fleets with identical profile counts to different successors,
because pod 1 holds a different profile in each. A statistic that forgets which pod holds which
profile cannot predict the image of a pod-indexed event.

This reconciles with Part B rather than contradicting it. Probe 12's table and Part B's sweep take
the observed `(from profile, to profile)` pair as **input** alongside the state, and that input
supplies exactly the pod-identity information the count vector discards — which is why the uncapped
counts showed zero conflicts there. So what exists is a transducer over an **enriched alphabet**
(the class transition), not a transducer over the state under the declared event alphabet.

**The violation count decreases monotonically as pod identity is restored** — 2,347 for the gain
vector, 800 for the counts, 82 for the per-pod profile assignment, 0 once the per-pod parameters are
included — and the only congruence found retains the raw per-pod parameters. Mechanically, that says
the optimization congruence for this fleet under a pod-indexed vocabulary is essentially the raw
state.

`verify_subset_agrees_with_the_hashed_scorer` re-scores each verdict with exact tuple comparison
rather than hashed class keys, so no verdict here rests on a hash collision.

## Validation

```
cargo test -p ergodis-private --lib policy_topk --release        # 4 passed
cargo test -p ergodis-private --lib fleet_congruence --release   # 3 passed
cargo test --test policy_topk_allocations --release              # 1 passed
ergodis-tools tie-state-bench --pods 16384 --train-events 400000,800000 --replay-events 100000
ergodis-tools tie-state-bench --pods 512 --congruence-pods 3 --congruence-depth 2
python3 scripts/counter_ab.py --binary <bin> --rounds 8 --pods 16384 --min-repeat 1000000 \
    --only-ops delta_value,topk_event_rack,topk_event_unique,policy_event_rack,table_event_rack,decided_leaf_rack,kernel_leaf_rack \
    --out evidence/2026-09-03-lrc-fleet-counter-ab-probe15-fixed.json
```

**Retained-binary check.** `retain-bin.sh` refused to overwrite the executable retained earlier in
the session: the same git revision had produced a different binary (retained
`ebad841806ce01149e3b5aa507f76b2b002bac5df7e06505c11582d458c35e69`, rebuilt
`fd61165d2fe3df30a87895cb7150b0915db195eb97f08b8ecbc535bfb2d948de`), because the working tree had
moved on. Rather than report numbers from an executable I could not name, I retained the final build
as `~/.cache/ergodis/bin/ergodis-tools-probe15-final`
(`fd61165d2fe3df30a87895cb7150b0915db195eb97f08b8ecbc535bfb2d948de`) and re-ran the whole campaign
against it; `evidence/2026-09-03-lrc-fleet-counter-ab-probe15-final.json` is that run and is the
source of every figure above. The instruction ratios reproduced exactly and the cycle intervals
tightened, which is the expected signature of a quieter box rather than a different binary.

All counter comparisons are paired within one process across eight interleaved rounds, with
instructions primary and cycle intervals reported.

## Mystery ledger

- **My own harness produced a wrong headline for probe 12, and statistics did not catch it.** The
  paired intervals were tight and consistent; the error was in what was being measured, not in the
  measurement. The check that caught it was a physical sanity condition — a part came out more
  expensive than the whole containing it. Worth institutionalizing: every counter campaign should
  include one containment pair.
- **The scorer refutes the uncapped count vector, which Part B found conflict-free.** Reconciled
  above — the two use different alphabets — but it means the phrase "the exact sufficient statistic"
  must always name the alphabet it is exact for. Probe 12's report and mine both used it loosely.
- **The gain state's 7 states survive every fleet and stream length tested** and still carry one
  value error per 100,000 events. Nothing yet explains why the reachable set is exactly 7, and the
  error rate has not been characterized as a function of tie frequency.
- **The top-k policy is now within 1.81x of the bare decided leaf**, so further work on the policy
  itself has little headroom; the remaining lever is the leaf, where the decided path already beats
  the kernel path 12.24x. Whether four closed-form calls can become one incremental update under a
  parameter change is untested.
- **`CongruenceCorpus::from_parts` is a shared-file addition.** It adds no behaviour, but it is a
  file another agent owns; if that agent prefers a different shape for the hook, this is the place
  to say so.

## Vibe check

The strongest and the most uncomfortable probe of the series. Part A met its target decisively —
11.37x fewer instructions than the tree, 53.5x less state, zero allocations — but only after the
same measurement pass revealed that probe 12's central performance claim was an artifact of my
harness charging every policy event for a tree update it never performed. Part B settled the tie
question negatively: no capped multiplicity closes the state, the uncapped count vector does but
compresses to nothing, so there is no key that is both exact and compressive. Part C then refuted
the multiset statistics outright by a mechanical closure check, and located the real congruence at
the per-pod parameter vector — with the reconciliation that probe 12's table works because it reads
the class transition as input rather than deriving it from state.

## Next probes

1. Post a correction to probe 12's report: the compiled policy is 2.81x cheaper than the tree, not
   1.28x more expensive, and the compiled table 5.52x cheaper.
2. Add a containment pair (a part-versus-whole operation) to every counter campaign as a standing
   sanity check.
3. Score the enriched alphabet mechanically: make the class transition an explicit input symbol in
   the corpus and confirm the scorer then admits the count vector as a congruence, which would
   close the loop between Parts B and C.
4. Make the leaf incremental — update the four decided values under a parameter change rather than
   recomputing them — the only remaining lever with headroom in the policy path.
5. Characterize the gain state's error rate as a function of tie frequency, to say when the 7-state
   approximation is safe to deploy behind a fail-closed path.
