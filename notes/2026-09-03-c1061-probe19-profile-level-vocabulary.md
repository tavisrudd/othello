# C1061 probe 19: fixing the alphabet instead of the state

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 19. Probe 15's congruence scorer refuted every multiset statistic on
*closure* and located the cause in the alphabet: the declared vocabulary names a pod, so a statistic
that forgets which pod holds which profile cannot predict the successor. This probe tests the fix at
the vocabulary level.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `src/profile_vocabulary.rs` — the profile-level alphabet, the count-vector state, the knapsack
  read straight off counts, the state-count formulas, and the congruence corpus.
- `src/policy_topk.rs` — `profile_of_pod`, the ingest step exposed so its cost can be measured
  separately.
- `src/delta_composition.rs` — `leaf_summary` and `node_summary` accessors (see below).
- `tasks/tools/src/profile_vocabulary_bench.rs`, `tasks/tools/src/summary_cache_bench.rs`,
  `scripts/counter_ab.py`.
- `evidence/2026-09-03-lrc-fleet-counter-ab-probe19.json`.

Committed as `ab05c40`. Only my own nine paths are in it — `git diff --cached --stat` was checked
against the working tree before committing, and probe 18's `src/open_problem.rs`,
`src/generic_certificate.rs`, `tasks/tools/src/incremental_certificate_bench.rs`,
`open_problem_bench.rs`, and `parametric_lrc_bench.rs` were left untouched. `git reset` cleared the
shared index first so nothing foreign could ride along, which is the guard probe 15's report asked
for after its work was swept into another agent's commit.

**Hook added for probe 18, as asked.** `CompositionTree::leaf_summary(leaf)` and
`node_summary(node)` on `delta_composition` return the retained summary without re-evaluating it.
Both are two-line accessors over the existing flat node array, so the cost was trivial; they give
the certificate chain a way to name a leaf's current summary and give a dedupe pass a way to compare
retained trees leaf by leaf.

## The change: re-index the alphabet, do not enrich the state

A schema-aware ingest layer applies the closed-form leaf decision to the raw pod event *first* and
emits the profile-level event it induces:

```text
DemandChanged { pod: 1, demand: 6 }   ->   Reprofile { from: p, to: q }
```

The alphabet is `Reprofile { from, to }`, `AddPod { profile }`, `RemovePod { profile }`, and
`GrainChanged` (which redefines every profile and so remains a rebase). Under it the count vector's
successor is `counts[from] -= 1; counts[to] += 1` — determined, with no reference to pod identity.
`RemovePod` on an empty profile and an out-of-range profile are no-ops, which keeps the step total
without inventing a pod; `remove_and_add_are_total_and_inverse_where_defined` pins that.

## 1. The congruence scorer's verdict

Corpus over count-vector states under the profile-level alphabet: 4 profiles, 364 states, 220 of
them carrying the conditions, 20 events, closure depth 3.

| statistic | features | quotient | exactness violations | closure violations | congruence |
|---|---|---|---|---|---|
| gain vector + baseline | 5 | 66 | 0 | 1,276 | no |
| profile counts, cap 2 | 4 | 79 | 141 | 512 | no |
| **profile counts, uncapped** | 4 | 220 | **0** | **0** | **yes** |

**The count vector is a congruence under the profile alphabet.** Zero exactness violations and zero
closure violations, confirmed by `verify_subset`'s exact re-scoring so the verdict does not rest on a
hash collision. Probe 15's 800 closure violations for the same statistic were entirely an artifact
of the pod-indexed alphabet.

The two controls matter as much as the result. Re-indexing the alphabet does **not** rescue a
statistic that genuinely forgets what the successor depends on: the gain vector still fails closure
(1,276 violations), and the capped counts now fail *exactness* too (141) as well as closure — capping
at 2 merges states whose optima differ once the knapsack can grant three levels. So the fix is
specific, not a licence for any coarse state.

## 2. The exact quotient

With `n` pods and `P` profiles the state is a multiset, so the state count is exactly

```
fixed fleet size:      C(n + P - 1, P - 1)
fleet size 0..=n:      C(n + P, P)
```

`state_counts_match_the_multiset_formula` checks both against direct enumeration for small cases.

For the measured fleet — 16,384 pods, **84 distinct profiles** observed — that is
**4.1 x 10^36 states**. Finite, and useless as a table.

The reachable set on the 10^5-event stream is **37,979 states** with **zero value disagreements**
against the retained tree. So the trajectory visits a vanishing fraction of a colossal state space,
and the states essentially never repeat.

## 3. The transducer on the enriched alphabet

Table keyed `(count vector, profile event) -> (count vector, value delta)`, trained on a stream and
replayed on a fresh one at 16,384 pods:

| training events | states | transitions | conflicts | rebases / 100k | value errors |
|---|---|---|---|---|---|
| 400,000 | 142,015 | 376,175 | **0** | 99,999 | **0** |
| 800,000 | 270,616 | 741,447 | **0** | 99,999 | **0** |

**Zero conflicts at both lengths**, where probe 12's gain-state table developed 2 then 4 conflicting
keys and probe 15's capped-count keys never closed. The transition really is a function now.

And it is worthless as a *table*: the rebase rate is 99.999%, because the count vector almost never
repeats. That is the same wall probe 15 hit, and re-indexing the alphabet does not move it.

The resolution is that the transducer should be **computed, not tabulated**. Its transition is a
decrement and an increment; its output is a three-level knapsack over the counts. Both are cheap
closed forms, so there is nothing to look up. `TopKPolicy` *is* that transducer, and it fails closed
on an unseen profile through `PolicyError::ProfileCapacity` rather than guessing. Over the 10^5
stream it reproduced the tree's optimum on every event.

## 4. End-to-end cost: ingest plus policy against the tree

Pinned binary `~/.cache/ergodis/bin/ergodis-tools-probe19`, SHA-256
`181e407e45bc19a12120fc0f14cda66613bd9b9559e16e494f1f52bb3ec00aae`, fixed 4,096-event window,
eight interleaved rounds, two-point differencing, paired log-ratios. Instructions are primary;
cycle intervals carry the noise.

| operation | instructions | cycles | IPC |
|---|---|---|---|
| retained-tree delta | 15.3k | 2.8k | 5.41 |
| **ingest + policy, end to end** | **1.3k** | **291** | 4.60 |
| ingest alone (closed-form leaf + intern) | 780 | 202 | 3.86 |
| decided leaf alone (no interning) | 740 | 197 | 3.76 |
| tree's own leaf alone | 9.1k | 1.5k | 5.99 |

| comparison | instructions | cycles [95% CI] |
|---|---|---|
| **tree delta over ingest + policy** | **11.40x** | **9.67 [9.19, 10.17]** |
| tree delta over ingest alone | 19.54x | 13.90 [12.97, 14.89] |
| ingest + policy over ingest alone | 1.71x | 1.44 [1.41, 1.47] |
| ingest over decided leaf alone | 1.05x | 1.03 [1.02, 1.04] |
| tree's own leaf over decided leaf | 12.24x | 7.68 [7.55, 7.82] |

The decomposition is clean and the cost is where the theory says it should be. Of the 1.3k
instructions per event, **780 are ingest** and about **520 are the compiled transducer** — the
count decrement and increment plus the three-level knapsack. Ingest is within 1.05x of the bare
closed-form leaf, so interning costs about 40 instructions; the leaf decision is essentially the
entire ingest cost. The tree spends 9.1k on its own leaf alone, 12.24x the decided leaf, because
`pod_summary` makes ten published-kernel calls where the decided path makes four closed-form ones.

## Verdict

**Yes: the online optimizer for this fleet is now an exact compiled transducer plus a
constant-cost ingest.** Precisely:

- **Exact.** The count vector is a congruence under the profile-level alphabet — zero exactness and
  zero closure violations from the scorer over the whole reachable closure, confirmed by exact
  re-scoring — and the transducer showed zero conflicts on both the 400,000- and 800,000-event
  training streams and zero value disagreements against the retained tree over 10^5 events.
- **Constant cost.** 780 instructions of ingest and about 520 of transducer, 1.3k in total against
  the tree's 15.3k, an 11.40x reduction with the cycle interval [9.19, 10.17] excluding 1.0. The
  cost does not depend on the fleet size, and probe 15 measured it as fleet-shape independent.
- **Fail-closed.** An unseen profile beyond the compiled capacity returns `PolicyError`, and a grain
  change is a rebase because it redefines every profile.

One qualification, and it is the load-bearing one. **"Finite transducer" here means computed, not
tabulated.** The state space is `C(n + P - 1, P - 1)` — 4.1 x 10^36 for 16,384 pods and the 84
profiles observed — and the reachable set on a 10^5 stream is 37,979 states that essentially never
repeat, so a lookup table misses 99.999% of the time. What makes the transducer cheap is that both
its transition (one decrement, one increment) and its output (a three-level knapsack over the
counts) are closed forms, so there is nothing to look up. Anyone reading "finite" as "tabulable"
will build a 99.999%-miss cache.

### What remains domain-specific

Exactly the ingest, and nothing downstream of it:

- **The closed-form leaf decision** (`repaired_decided` and the profile it builds) — this is the
  only part that knows about capacities, demands, upgrade domains, or the LRC code. It is 780 of the
  1.3k instructions.
- **The profile alphabet's identity**: what makes two pods interchangeable. Here it is the packed
  budget response, justified by probe 9's derivation and probe 12's family test.

Everything after the ingest is domain-neutral: counts, a decrement and an increment, and a knapsack
over a bounded number of grants. Two structural preconditions sit underneath and should be recorded
as compilation obligations rather than assumed:

1. **Leaf summaries must commute** — true here because a leaf's cost depends only on the budget it
   consumes, not on the absolute budget level, which makes them min-plus convolution operators. A
   cost model that depended on the absolute level would collapse the whole reformulation.
2. **The grant count must be bounded** (three levels here), which is what makes the knapsack a
   constant-size top-k rather than a general optimization.

## Mystery ledger

- **Zero conflicts and a 99.999% rebase rate in the same table.** Both are correct and they say
  different things: the transition is a genuine function, and the state is too fine to memoize. The
  probe series has now hit this wall from three directions (gain state, capped counts, count
  vector), which is strong evidence that no useful *tabulation* exists for this fleet — but that is
  an empirical pattern across three attempts, not a proof.
- **84 profiles observed where probe 6 measured 82 budget responses.** Close but not equal; the
  small difference is unexplained and probably reflects the different event stream, but nobody has
  checked that the profile map is injective on responses.
- **Capped counts now fail exactness, not just closure.** Under the pod-indexed alphabet they were
  exact and only failed closure; under the profile alphabet with cap 2 they show 141 exactness
  violations. That is expected — capping at 2 cannot see a three-pod grant — but it means the cap
  must be at least the grant count, which nothing in the code enforces.
- **The state-count formula is exact but the reachable-set growth is not characterized.** 37,979
  states from 10^5 events looks sublinear; whether it saturates or keeps growing is unmeasured and
  decides whether a bounded cache could ever pay.

## Validation

```
cargo test -p ergodis-private --lib profile_vocabulary --release   # 6 passed
cargo test -p ergodis-private --lib policy_topk --release
cargo test --test policy_topk_allocations --release
ergodis-tools profile-vocabulary-bench --pods 16384 --train-events 400000,800000 --replay-events 100000
python3 scripts/counter_ab.py --binary ~/.cache/ergodis/bin/ergodis-tools-probe19 --rounds 8 \
    --pods 16384 --min-repeat 1000000 \
    --only-ops delta_value,topk_event_rack,profile_ingest_rack,decided_leaf_rack,kernel_leaf_rack \
    --out evidence/2026-09-03-lrc-fleet-counter-ab-probe19.json
```

## Vibe check

The cleanest result of the series. Probe 15 diagnosed the closure failure as a property of the
alphabet rather than the state, and that diagnosis turned out to be exactly right: re-indexing the
events by profile makes the count vector a congruence with zero violations, and the two controls
confirm the fix is specific rather than a licence for any coarse state. The compiled optimizer is
now exact, 11.40x cheaper than the tree, and 60% of its cost is the one genuinely domain-specific
step. The wall that remains is memoization, not correctness: the state space is astronomically
large, so the transducer has to be computed rather than looked up — which is fine, because both its
transition and its output are closed forms.

## Next probes

1. Characterize reachable-state growth against stream length to settle whether any bounded cache
   could pay, and close out the tabulation question the series has now hit three times.
2. Enforce the cap-at-least-grant-count condition in the capped-count statistic, or drop the capped
   variant now that it is refuted on both alphabets.
3. Record the two compilation obligations — commuting leaf summaries, bounded grant count — as
   checkable preconditions rather than prose, so a future domain fails loudly instead of silently.
4. Check that the profile map is injective on budget responses, which would explain the 84-versus-82
   difference and let the profile alphabet be keyed on the response directly.
