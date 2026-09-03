# C1061 probe 20: sealed compilation obligations, and one decomposition under three semirings

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 probe 20. Part A turns probe 19's prose preconditions into checked artifacts in the
private proof layer's idiom; part B reinterprets the same pod decomposition under Boolean, counting,
and probability semirings.

Files (all in `ergodis-private`; `/home/tavis/src/ergodis` untouched and clean):

- `src/fleet_obligations.rs` — the sealed binding, the Horn registry, emit and replay-verify.
- `src/fleet_semirings.rs` — the three readouts, their brute-force oracles, and the overlap gap.
- `src/profile_vocabulary.rs` — `profile_congruence_corpus_with`, so a second semiring's readout can
  be scored over the same state and alphabet.
- `src/policy_topk.rs` — `Profile::of_response`, so a verifier can recompute a sealed profile.
- `tasks/tools/src/profile_vocabulary_bench.rs`, `tasks/tools/src/summary_cache_bench.rs`,
  `scripts/counter_ab.py`.
- `evidence/2026-09-03-lrc-fleet-counter-ab-probe20.json`.

**Commit hazard, and it went the other way this time.** I staged exactly my nine paths and checked
`git diff --cached --stat` immediately before committing — it showed those nine. Between that check
and the `git commit`, probe 18's agent staged its own files into the shared index, and my bare
`git commit` committed the whole index: `33b6ded` contains 16 files and 3,378 insertions, including
`src/generic_certificate.rs`, `src/open_problem.rs`, `tasks/tools/src/generic_certificate_bench.rs`,
`incremental_certificate_bench.rs`, `open_problem_bench.rs`, `parametric_lrc_bench.rs`, and
`tasks/tools/src/main.rs`. Probe 15 lost its work into another agent's commit; this time I swept
another agent's work into mine. The tree builds and all tests pass, and I have not rewritten
history, but probe 18's work is now committed possibly before it intended.

Checking the staged set is not sufficient protection, because the index is shared and the check is
not atomic with the commit. The only reliable fix is to stop sharing the index — a per-agent
worktree or `GIT_INDEX_FILE` per agent — and that is a coordinator-level decision, not something a
probe can adopt unilaterally.

## Part A — the obligations as checked artifacts

### A1. What is sealed

The certificate binds a fleet schema (pod count, budget grain, boundary alphabet) through an
`ExtractorDescriptor` whose parameter digest covers all three, and carries one **sealed
representative pod per interned profile** — capacities, demand, and availability mask. That is
enough for a verifier to recompute everything from first principles rather than trusting a claim.

Facts and rules, in the layer's Horn idiom:

| fact | established by |
|---|---|
| `REGISTERED_SCHEMA` | the sealed binding |
| `PROFILES_SEALED` | representatives present and within the verifier's bound |
| `CONVOLUTION_OPERATORS` | every profile's summary satisfies `cost[from][to] = f(to - from)` |
| `SUMMARIES_COMMUTE` | from `CONVOLUTION_OPERATORS` |
| `GRANT_BOUND` | from the schema's boundary alphabet |
| `SCAN_LIMIT_CAPPED`, `AGGREGATE_INCREASING`, `SHORTFALL_SATURATING`, `RESIDUAL_FORM` | the four closed-form assumptions, per representative |
| `CLOSED_FORM_ADMISSIBLE` | from all four assumptions |
| `FLEET_COMPILABLE` | from commutation, the grant bound, and admissibility |

Ten rules, ten Horn steps. The semantic content is not in the transcript — it is in
`check_profile`, which the **verifier re-runs for every representative**: it rebuilds the summary
with `pod_summary`, tests `is_convolution_operator`, runs probe 12's `check_assumptions` on the
representative's instance, and recomputes the profile from the closed-form budget response. The
transcript is then replayed against the sealed registry. A certificate whose profile, grant bound,
transcript, or provenance has been touched is refused; four tamper tests pin each path, and
`presentation_metadata_alone_cannot_authorize` pins that downgrading provenance to
`ObservedEvolved` fails rather than passing.

### A2. Measured

At 16,384 pods with the standard rack fleet the certificate seals **20 profiles**, carries **10 Horn
steps**, a grant bound of **3**, and **1,456 bytes**. Emit and verify instruction counts are in the
table in Part B4, since both were measured in the same pinned campaign.

The point of the artifact is not its size. It is that probe 19's two preconditions and probe 12's
four assumptions now fail loudly: if a future fleet's leaf summary stops being a convolution
operator — which is what a cost model depending on the absolute budget level would do — emission
fails with `NotConvolution` naming the profile, instead of the knapsack quietly returning a wrong
answer.

## Part B — one decomposition, three semirings

The decomposition never used anything specific to min-plus beyond associativity and the bounded
grant count, so each readout below is computed from the **same profile-count vector** under the
**same profile-level alphabet**, and each is checked against a brute-force oracle over the raw
fleet.

### B1. Boolean: can the fleet repair everything at all?

A pod is satisfied at `l` levels when its unserved count is zero, so each profile has a
**satisfaction threshold** — the fewest levels that clear it, or none at all. The fleet is feasible
exactly when every occupied profile has a threshold and the thresholds, weighted by multiplicity,
fit inside the grant bound. That is a closed form over the counts.

`boolean_readout_matches_the_oracle` checks it against a direct per-pod threshold sum over the raw
fleet for five seeds and pod counts 1 through 64.

### B2. Counting: how many optimal grant patterns?

The gain is a function of the counts and so is the number of pod choices realizing it: enumerate the
grant shapes (multisets of levels summing to at most the bound), assign their slots to profiles in
nondecreasing order to avoid double counting, and weight each assignment by the product of binomials
`C(count, taken)`.

`counting_readout_matches_the_oracle_on_small_fleets` checks both the gain and the pattern count
against exhaustive enumeration of every per-pod level assignment, for three seeds and one to five
pods. On a 64-pod fleet with the data domains boosted so the shared budget actually binds, the best
gain is **579** and it is realized by **7,833 distinct grant patterns** — a readout the min-plus
optimum cannot express.

### B3. Probability, and a deliberate negative

Each profile gets a repair probability per level by enumerating the 512 availability masks of its
nine upgrade domains once, at compile time. The `(+, x)` convolution over the counts then gives, for
each total budget, the sum over allocations of the product of per-pod probabilities.
`probability_convolution_matches_a_direct_sum_over_allocations` checks it against direct enumeration
on a four-pod fleet.

**That sum is not reliability.** The events "allocation A repairs everything" and "allocation B
repairs everything" overlap, so the semiring over-counts. `overlap_gap` computes both on a three-pod
fleet: the semiring total is **2.188380** against a true probability of **0.109419**, an
**overlap ratio of 20.0** — and the semiring total exceeds 1, which is the clearest possible sign
that it is not a probability. The correct reading is that the probability semiring computes a
weighted count over allocations, which is a union-bound surrogate; getting true reliability needs an
inclusion-exclusion or a per-pod threshold decomposition, which is what `overlap_gap`'s exact branch
does and which is **not** a semiring readout over this decomposition.

### B4. Does the profile quotient stay closed?

The congruence scorer, run over the same count-vector state and profile-level alphabet with each
readout as the observable:

| readout | quotient | exactness violations | closure violations | congruence |
|---|---|---|---|---|
| min-plus optimum | 220 | 0 | 0 | **yes** |
| Boolean feasibility | 220 | 0 | 0 | **yes** |
| counting patterns | 220 | 0 | 0 | **yes** |

**The count vector remains a congruence under all three semirings.** That is the strongest form of
"one decomposition, several semirings" available here: not merely that each readout can be computed,
but that the same compiled state stays exact and closed for each.

### B5. Which semirings stay computed-closed-form, and which need the tree

Pinned binary `~/.cache/ergodis/bin/ergodis-tools-probe20`, SHA-256
`6e01b74570ed48e37596186174691036ae74fe236825c119eb9a94e7a292f46d`, fixed-window harness, eight
interleaved rounds, two-point differencing, paired log-ratios.

| operation | instructions | cycles | IPC |
|---|---|---|---|
| retained-tree delta (reference) | 15.3k | 3.1k | 4.91 |
| min-plus event (ingest + policy) | 1.3k | 288 | 4.64 |
| **Boolean readout** | **39** | **7** | 5.72 |
| counting readout | 627.3k | 95.7k | 6.56 |
| probability readout | 650.0k | 146.5k | 4.44 |
| obligation certificate emit | 345.7k | 58.0k | 5.96 |
| obligation certificate verify | 172.5k | 30.5k | 5.65 |

| comparison | instructions | cycles [95% CI] | direction |
|---|---|---|---|
| min-plus event over Boolean readout | 34.30x | 42.34 [40.97, 43.75] | Boolean is **cheaper** |
| counting readout over min-plus event | 468.92x | 331.81 [328.82, 334.82] | counting is **dearer** |
| probability readout over min-plus event | 485.86x | 508.06 [498.09, 518.24] | probability is **dearer** |
| obligation emit over verify | 2.00x | 1.89 [1.66, 2.15] | verify is half of emit |

(The rendering script labels any ratio above one "faster"; for cost ratios that word means the
numerator is larger, so the direction column above is the one to read.)

**None of the three needs the tree.** Every readout is a function of the profile-count vector, and
the scorer confirms the state stays a congruence for each, so the compiled transducer serves all of
them from the same state and the same alphabet. What separates them is cost, and it separates them
sharply:

- **Boolean stays closed-form and is the cheapest thing in the series** — 39 instructions, a
  multiply-accumulate over occupied profiles with an early exit, 34.30x below the min-plus event and
  392x below the tree delta. Feasibility is nearly free once the thresholds are compiled.
- **Min-plus stays closed-form and cheap** — the bounded top-k of probe 15, 1.3k instructions.
- **Counting and probability stay closed-form but are not cheap as implemented** — 627.3k and
  650.0k instructions, roughly 470x and 486x the min-plus event. Both enumerate grant shapes and
  their assignments to profiles rather than reading a bounded top-k, so they scale with the profile
  count rather than with the grant bound. That is an implementation property, not a semiring
  property: the same incremental top-k trick that took the min-plus policy from 5.4k to 1.3k should
  apply, and is untested. The probability readout additionally pays a compile-time cost of 512
  availability masks per profile, which is not in the per-event figure.

The obligation certificate costs **345.7k instructions to emit and 172.5k to verify** for 20 sealed
profiles, about 8.6k per profile verified. Verify is exactly half of emit because emission runs the
same per-profile checks and then verifies its own output — the emitter does not trust itself.

## Verdict

**Part A.** Probe 19's two prose preconditions and probe 12's four assumptions are now checked
artifacts: a sealed schema binding, a ten-step Horn derivation, and a replay that recomputes every
semantic check from sealed representatives rather than trusting the transcript. Tampering with a
profile, the grant bound, the transcript, or the provenance all fail closed, each pinned by a test.

**Part B.** The same pod decomposition carries Boolean, counting, and probability readouts over the
same count-vector state and profile-level alphabet, each checked against a brute-force oracle, and
the congruence scorer confirms the count vector remains exact and closed under all three. None
requires the retained tree. Cost, not structure, is what differs: Boolean is 34x cheaper than
min-plus, counting and probability about 470-486x dearer because their readouts enumerate
assignments instead of maintaining a bounded top-k.

The one genuine negative is the probability semiring's meaning. It computes a sum over allocations,
which over-counts by a factor of **20.0** against the true probability on a three-pod fleet and
exceeds 1 outright, so it is a union-bound surrogate rather than reliability. Getting reliability
needs a per-pod threshold decomposition, which is not a semiring readout over this decomposition.
Anyone who reads "probability semiring" as "reliability" will ship a number above 1.

## Mystery ledger

- **The min-plus knapsack is degenerate on the default generated fleets.** Best gain zero, because
  adding global parity capacity also raises the aggregate data load, so the per-domain test tightens
  as fast as the budget loosens; the binding resource is the data-domain capacity, not the shared
  budget. The semiring demonstrations only become non-trivial once the data domains alone are
  boosted. This is a real property of the LRC instance and it means every gain figure in probes 12
  through 19 was measured in a near-degenerate regime — the exactness results are unaffected, but
  the *interestingness* of the optimum was overstated.
- **Boolean feasibility is false for any fleet of realistic size.** Three levels cannot cover
  thousands of pods, so the readout is only informative on small fleets or as a per-rack rollup.
  Nothing currently exposes it at a useful granularity.
- **Counting and probability cost ~470x the min-plus event and nobody has tried to fix it.** The
  incremental top-k that fixed min-plus should transfer, since the same bounded-grant argument
  applies; until measured, the "one decomposition, several semirings" claim is structurally true but
  practically lopsided.
- **The 512-mask reliability precomputation assumes independent per-domain availability.**
  Correlated failures — the case a rack-aware operator actually cares about — would break the
  product form, and the certificate does not seal that assumption because it is a property of the
  input distribution rather than of the schema.

## Validation

```
cargo test -p ergodis-private --lib fleet_obligations --release   # 6 passed
cargo test -p ergodis-private --lib fleet_semirings --release     # 6 passed
cargo test -p ergodis-private --lib profile_vocabulary --release  # 6 passed
ergodis-tools profile-vocabulary-bench --pods 64 --grain 2 --capacity-boost 12
python3 scripts/counter_ab.py --binary ~/.cache/ergodis/bin/ergodis-tools-probe20 --rounds 8 \
    --pods 16384 --min-repeat 200000 \
    --only-ops delta_value,topk_event_rack,obligation_emit,obligation_verify,semiring_boolean,semiring_counting,semiring_probability \
    --out evidence/2026-09-03-lrc-fleet-counter-ab-probe20.json
```

My library modules are clippy-clean. Foreign breakage to flag, not mine and untouched: crate-wide
`cargo clippy` currently fails on one `ptr_arg` lint in probe 18's `src/generic_certificate.rs`.

## Vibe check

Both parts landed, and the second one produced the sharpest negative of the series. The obligations
are now artifacts that fail loudly instead of prose that quietly stops holding, and the
three-semiring reinterpretation worked structurally — same state, same alphabet, congruence
preserved, each readout oracle-checked. But two things deserve to be said plainly: the probability
semiring does not compute reliability and will happily return a number above 1, and the min-plus
knapsack has been running in a near-degenerate regime this whole time because the shared budget is
not the binding resource on these fleets. Neither invalidates an exactness result; both change what
the numbers mean.

## Next probes

1. Apply the incremental top-k to the counting and probability readouts and re-measure the 470x gap.
2. Re-run the probe 12 through 19 gain figures on a data-boosted fleet where the shared budget
   actually binds, and say which conclusions were regime-dependent.
3. Seal the independence assumption behind the reliability readout, or replace it with a correlated
   availability model and a readout that admits inclusion-exclusion.
4. Expose Boolean feasibility at a per-rack granularity, where three levels can actually cover the
   pods and the answer is informative.

