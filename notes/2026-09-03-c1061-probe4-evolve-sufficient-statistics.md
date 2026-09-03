# C1061 probe 4: evolve's new objective — smallest sufficient statistic closed under the update monoid

**Lane**: `complete-ports`
**Date**: 2026-09-03
**Task**: C1061 (Ergodis as a compiled dynamic decision engine), open-ended probe 4 (brief item 8).
**Brief**: `notes/2026-09-03-c1061-ergodis-compiled-dynamic-solver-brief.md`
**Predecessor**: `notes/2026-09-03-c1061-probe1-composition-survey-and-delta-prototype.md`

Contract documents read in full before any work: `/home/tavis/src/ergodis/CLAUDE.md`,
`/home/tavis/src/ergodis-contrib/PERFORMANCE.md`,
`/home/tavis/src/ergodis-contrib/performance-playbook.md`,
`/home/tavis/src/ergodis-private/CLAUDE.md`,
`notes/2026-08-30-c985-ergodis-adaptive-search-learning-adr.md`,
`notes/2026-08-30-c985-ergodis-campaign-control-spike.md`.

## Summary

The congruence objective was built, and on a planted family with a known sufficient statistic it
recovers that statistic exactly while the objective evolve has today returns a decoy. The two
decoy classes fail by *different* mechanisms, which is the design finding: the literal
Myhill–Nerode closure condition and observational exactness re-checked on the reachable closure
are independent conditions, and an objective needs both. On the probe-1 toy the minimal closed
statistic over the parameter record turns out to be the whole parameter record — probe 1's speedup
comes from the composition tree, not from any state compression — while the *summary* side does
compress, to a finite set of tropical-projective classes times one integer.

## Part A — where evolve keeps candidates, features, and fitness

The campaign control plane lives in the public core, not the private workspace:
`/home/tavis/src/ergodis/src/control/` with `vm.rs` (feature batch, typed bytecode, evaluator),
`evolution.rs` (the evolve loop), `synthesis.rs` (bounded decision-tree proposer), and
`mod.rs` (controller and bounded query model).

**The sealed feature vocabulary** is `FeatureBatch` (`vm.rs:48`). It is a dense presized batch
read from JSONL: a `presentation` string, a `problem` string, a boxed slice of field *names*, and
flat `row_ids` / `weights` / `expected` / `values` arrays. `expected` is a `bool` per row. The
vocabulary is sealed in the sense that a candidate program may name only the declared fields, and
the presentation hash binds the semantics of those fields to the batch; the feature-DAG transition
machinery in `/home/tavis/src/ergodis/src/feature_dag.rs` is the sanctioned way to move to a
richer presentation without silently reusing a learned result against different field semantics.

**A candidate** is a `PlanSpec` (`vm.rs:300`): a schema string, a name, a `PlanRole`
(`Diagnostic` or `Ordering`), a `PlanOutput` (`Predicate` or `Score`), an optional categorical
`PlanScope { field, mask }`, and a postfix `Vec<PlanOp>` program. `PlanOp` (`vm.rs:670`) is the
typed vocabulary: `Field`, `Const`, `Bool`, the arithmetic operators including `Gcd`,
`GaussianNorm`, `EisensteinNorm`, `Legendre { modulus }`, the six comparisons, the boolean
connectives, and `Select`. A prefix `ExpressionPlanSpec` (`vm.rs:351`) lowers to the same postfix
form, which stays the stable replay IR. Programs compile to `CompiledOp` (16 bytes, `repr(C)`,
size and alignment asserted at `vm.rs:753`) with a fused `FieldEqConst`-style opcode family and a
truth-table fast path for predicates of at most six leaves.

**The fitness is per row.** `evaluate_plan` (`vm.rs:1467`) walks the batch one row at a time and
returns `Evaluation { weighted_correct, weighted_false_positive, weighted_false_negative,
weighted_true, first_mismatch, outcome_hash, minimum_score, maximum_score, ... }`. The evolve loop
converts that into `CandidateScore { correct, false_positive, complexity }`
(`evolution.rs:764`, constructed at `evolution.rs:2317`), and every downstream mechanism — elite
selection, semantic niching by `FailureNiche`, outcome-hash deduplication, operator scorecards —
is keyed off that triple.

**The gap this creates.** `CandidateScore` is a function of the multiset of per-row outcomes. An
optimization congruence is not: condition (1) is about *pairs* of states colliding under `phi`, and
condition (2) is about how a *pair* behaves under an event. Neither is expressible as a row label.
The closest existing thing is `feature_ceiling` (`mod.rs:790`), which sorts the rows by their full
feature vector, groups equal vectors, and reports `distinct_feature_vectors`, `ambiguous_groups`,
and `unavoidable_weighted_errors` plus the first opposite-label collision. That is exactly
condition (1) — but for the *whole* vocabulary rather than a candidate `phi`, and with no notion of
a state change at all. Probe 4's scorer is `feature_ceiling` generalized in both directions:
per-candidate, and closed under an event vocabulary.

## Part B — the congruence objective as an evaluator

New tier-1 module, no task ID in the name per the private workspace's layout rules:

- `/home/tavis/src/ergodis-private/src/congruence_search.rs` — the scorer, the planted family, and
  the probe-1 binding.
- `/home/tavis/src/ergodis-private/tasks/tools/src/congruence_search_report.rs` — the driver, wired
  as the `congruence-search-report` subcommand of the existing `ergodis-tools` binary (no new
  `src/bin` file).
- one `pub mod congruence_search;` line in `/home/tavis/src/ergodis-private/src/lib.rs` and three
  lines in `/home/tavis/src/ergodis-private/tasks/tools/src/main.rs`.

Nothing under `/home/tavis/src/ergodis` was touched, and neither
`delta_composition.rs` nor the concurrent certificates module was edited; the probe-1 binding reads
`delta_composition`'s public API only, and keeps its own hashable `(offset, capacity, enabled)`
key rather than deriving `Hash` on that crate's Tiger-style `LeafParameters` record.

### B1. Inputs

A `CongruenceCorpus` holds a raw corpus of states, an event vocabulary, and the exact optimizer's
answer per state:

- a row-major `states x width` sealed feature matrix,
- a row-major `states x events` successor index table,
- `opt_value` and `opt_witness` per state (the observable: value *and* witness class),
- a raw-corpus flag and a *checked* flag per state.

`ClosureBuilder::close` interns the corpus, closes it breadth-first under the sampled generators to
a declared depth, then interns one further ring. Only states at depth at most the declared depth
are *checked*; the extra ring exists solely so every checked state has all its successors present
in the table. Without that ring the outermost states would be scored against missing successors,
which silently understates the closure violation count.

A candidate `phi` is a projection onto a subset of the sealed vocabulary — the analogue of an
evolve plan being a program over the sealed field list, restricted to the projection fragment so
that exhaustive enumeration is possible and a negative result is exact rather than sampled.

### B2. The score

`CongruenceCorpus::score_subset` groups the checked states by `phi` and returns

```text
SubsetScore {
    corpus_exactness,      // colliding corpus states that disagree on Opt
    closure,               // (class, event) pairs whose images land in different classes
    reachable_exactness,   // colliding reachable states that disagree on Opt
    quotient,              // number of distinct phi values on the checked set
    size,                  // number of selected features
}
```

The three violation counters are never collapsed into one scalar, matching the adaptive-search
ADR's rule that correctness is a lexicographic constraint and not a term in a fitness sum. A
candidate is admissible only when all three are zero; admissible candidates are then ranked by
fewest features, then coarsest quotient.

Single-step closure is sufficient for closure under arbitrary event *words* because the checked set
is generator-closed by construction: if every class survives one generator and every image is
itself checked, induction on word length gives closure under every word. That is why the builder
closes the set before scoring rather than sampling random event sequences.

Class keys are 128-bit mixes of the selected feature values, so grouping is a sort rather than a
tuple comparison. A collision would silently merge two classes and could manufacture a false
congruence, so `verify_subset` re-scores with exact tuple comparison and the driver confirms the
reported winner that way on every run (`winner_verified_by_exact_tuple_comparison true` below).

`partition_signature` fingerprints the *partition* a candidate induces, because distinct feature
subsets routinely induce the same quotient — adding a feature already determined by the others
changes nothing — so a raw count of admissible subsets overstates how many different answers the
search found.

### B3. Cost boundary

This is analysis-time code. It runs once to derive a quotient and has no place in a solve hot loop,
so the zero-allocation solve invariant does not bind it; the per-subset inner loop nevertheless
reuses one caller-owned scratch buffer and allocates nothing per candidate. The exhaustive
enumeration over all subsets of size at most three of a 19-feature vocabulary against a 26,160-state
checked set completes in about 2.7 seconds in release.

## Part C — the planted test

### C1. The family

Raw state `x = (a, b, c)` with `a` and `b` integer lists and `c` a counter. The planted optimum is

```text
Opt(x) = min(a) + sum(b) + T[c mod 3],    T = [0, 7, 3],    witness class = c mod 3
```

so the planted sufficient statistic is `phi* = (min a, sum b, c mod 3)`. The event vocabulary has
seven generators: `PushA(-3)`, `PushA(1)`, `PushA(5)`, `AddB(-2)`, `AddB(3)`, `Step(1)`, `Step(2)`.
Each one descends to `phi*` — `min` and `sum` are the right aggregates for appending, and the
residue is closed under stepping — so `phi*` is a genuine congruence for this monoid, which is what
makes it a planted answer rather than a hoped-for one.

The corpus generator (SplitMix64, declared seed) emits `a` **sorted ascending**. That is the trap:
`a[0] == min a` on every raw corpus state, so no amount of corpus evidence can separate the two.

The sealed vocabulary has 19 features: the three planted coordinates, index and aggregate decoys
(`a_0`, `a_1`, `a_last`, `a_max`, `a_sum`, `a_len`, `b_0`, `b_last`, `b_min`, `b_len`, `c`,
`c_mod_2`, `c_mod_5`), the linear collapse `a_min_plus_b_sum`, and — deliberately — the answer
itself as `opt_value` and `opt_witness`.

### C2. Result

```
cd /home/tavis/src/ergodis-private
cargo build --release -p ergodis-tools
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools congruence-search-report
```

Seed 2026, 64 raw corpus states, closure depth 3: 34,880 interned states of which 9,856 are checked,
7 events, 19 features.

| candidate | size | quotient | corpus exactness | closure | reachable exactness | verdict |
|---|---|---|---|---|---|---|
| `{a_min, b_sum, c_mod_3}` — the planted statistic | 3 | 615 | 0 | 0 | 0 | **congruence** |
| `{a_0, b_sum, c_mod_3}` — the index decoy | 3 | 583 | 0 | **0** | **2,199** | rejected |
| `{a_min_plus_b_sum, c_mod_3}` — the linear collapse | 2 | 103 | 0 | **5,644** | 0 | rejected |
| `{opt_value, opt_witness}` — the answer itself | 2 | 103 | 0 | **5,644** | 0 | rejected |
| `{a_min, b_sum, c}` — an unnecessary refinement | 3 | 1,792 | 0 | 0 | 0 | congruence, ranked below |
| `{a_min, c_mod_3}` — drops a planted coordinate | 2 | 33 | **34** | 0 | 8,544 | rejected |

Exhaustive enumeration over all 1,159 subsets of size at most three finds **18 admissible subsets
inducing exactly 2 distinct partitions**: the quotient-615 partition, whose smallest-and-coarsest
representative is exactly the planted `{a_min, b_sum, c_mod_3}`, and the quotient-1,792 refinement
that carries `c` instead of `c mod 3`. The other 16 admissible subsets are redundant spellings of
the same 615-class partition (for instance `{a_min, b_sum, opt_value}`, where the third feature is
already determined by the first two). The winner is confirmed by exact tuple comparison.

**The control, and the point of the probe.** Ranking the same 1,159 candidates by the objective
evolve has today — exact on the raw corpus, then fewest features, then coarsest quotient, closure
ignored — returns `{c_mod_3, a_min_plus_b_sum}` at size 2 and quotient 103, with the answer itself
`{opt_value, opt_witness}` tied in the same top group. Every one of the top five candidates a static
objective produces has 5,644 closure violations. A statistic that is perfect on every row you have
and is destroyed by one event is precisely what a per-row objective cannot see.

### C3. The two decoys fail differently, and that is a design finding

The index decoy `{a_0, b_sum, c_mod_3}` scores **zero closure violations**. `a_0` is genuinely
closed: `PushA` appends, so it never changes `a[0]`. What it fails is *exactness on the reachable
closure* — after one `PushA(-3)` below the current first element, two states that agreed on `a_0`
now have different minima and different optima. Conversely `{opt_value, opt_witness}` is
observationally exact everywhere by construction and fails only closure: knowing the optimum does
not let you predict how a `PushA` changes it, because you cannot separate `min a` from `sum b`
inside the sum.

So the literal Myhill–Nerode condition (2) does **not** subsume observational exactness re-checked
on the reachable set, and vice versa. An objective that keeps only "exact on the corpus" plus
"collisions stay collisions" would admit the index decoy. Both counters are load-bearing, and
`SubsetScore` keeps them separate for that reason.

### C4. Stability

| seed | depth | raw corpus | checked states | winner | quotient |
|---|---|---|---|---|---|
| 2026 | 3 | 64 | 9,856 | `{a_min, b_sum, c_mod_3}` | 615 |
| 2026 | 3 | 48 | 7,392 | `{a_min, b_sum, c_mod_3}` | 556 |
| 2026 | 4 | 48 | 26,160 | `{a_min, b_sum, c_mod_3}` | 722 |
| 7 | 3 | 48 | 7,390 | `{a_min, b_sum, c_mod_3}` | 559 |

At seed 2026 and depth 4 the counts scale as expected and the verdicts are unchanged: the index
decoy moves to 6,496 reachable-exactness violations with closure still 0, and the collapse and
answer decoys move to 12,272 closure violations with reachable exactness still 0. The admissible set
is still 18 subsets over 2 partitions.

```
ergodis-tools congruence-search-report --seed 2026 --depth 4 --corpus 48
ergodis-tools congruence-search-report --seed 7    --depth 3 --corpus 48
```

## Part D — sealing sufficiency rather than observing it

Everything in Part C is an *observation on a sampled closure*. Under the C985 rule that observed
predicates carry no pruning authority — enforced in the code by the `proof_authority: false` fields
on the feature-DAG snapshot, transition, and bundle artifacts
(`/home/tavis/src/ergodis/src/feature_dag.rs:115,126,1140,1459` and the rejection at 1130/1155/1477)
and on the theorem-search snapshot (`theorem_search.rs:636,735,760`) — a discovered `phi` may order
work and may be reported, but may not be installed as the online machine's state. Promotion needs a
proof, and the proof obligation has a definite shape.

### D1. The typed obligation

For a candidate `phi` over declared state type `X`, event type `M`, and observable
`Opt : X -> V x W`, promotion requires three lemmas, all quantified over *all* states rather than a
corpus:

1. **Factorization.** There exists `opt_hat : Q -> V x W` with `Opt = opt_hat . phi`. Discharging
   this is what makes the maintained state answer the question at all.
2. **Descent of each generator.** For every `m` in the declared vocabulary there exists
   `step_hat(m) : Q -> Q` with `phi(m . x) = step_hat(m)(phi(x))` for all `x`. This is the
   representation `rho : M -> End(Q)` the brief names; discharging it per generator suffices,
   because `rho` extends to words by composition.
3. **Envelope totality.** Every event the adapter can emit is in the declared vocabulary, or exits
   through `REBASE_REQUIRED`. Without this the first two lemmas are vacuous for the events that
   actually occur.

Two of the three are checkable by a bounded exhaustive argument when `Q` and the generator set are
finite, which is the same shape as the existing strongest algebraic gate in the tree:
`validate_finite_ordered_monoid` (`/home/tavis/src/ergodis/src/ordered_resource.rs:53`) exhaustively
certifies identity, commutativity, associativity, and monotonicity over all triples of a compact
element universe. A `validate_finite_congruence(phi, generators, opt_hat)` in the same spirit —
certifying factorization and descent over the whole finite `Q x M`, not over a corpus — is the
natural sealed artifact and the natural first promotion gate. Where `Q` is infinite (a cost carried
in `Z`, as in probe 1), the descent lemma has to be discharged structurally instead, one generator
at a time, and that is a proof obligation rather than a check.

### D2. The replay gate

The corpus-level scorer stays useful after promotion, as the falsifier rather than the evidence.
The natural artifact mirrors the existing diagnostic bundles: a portable, versioned record carrying
the presentation hash, the feature-DAG snapshot hash, the candidate's canonical and lowered plan
hashes, the event vocabulary's own hash, the closure depth and generator list, the three violation
counters, the quotient size, the partition fingerprint, and `proof_authority: false`. Restore
re-derives the closure from the recorded seed and generators and re-checks every counter before the
record may be used, exactly as `SoundTheoremArchive` restore rechecks soundness on the stored corpus
and as the feature-DAG transition replays every target cell. A `phi` that has passed only this gate
may be reported, may seed a proposal, and may order work; it may not become state.

### D3. What promotion to the online machine additionally needs

Beyond the three lemmas, installing `phi` as the maintained state of the delta engine needs:

1. **A representation of `Q` that meets the hot-record contract** — plain data, explicit `repr`,
   asserted size and alignment, no owned dynamic container. `delta_composition::Summary` is the
   worked example: `repr(C, align(64))`, one cache line, size and alignment asserted at compile
   time.
2. **`step_hat(m)` implemented allocation-free**, with the allocation-count regression that the
   performance contract requires for every new solve kernel.
3. **The incremental differential gate** already used ad hoc in four private search adapters and
   adopted by probe 1: every incremental path checked against a fresh full recomputation on a
   deterministic event stream, after every single event.
4. **A collapse law for the event monoid**, since a run of events must fold to one equivalent
   update. Probe 1's section B2 is the cautionary case: a saturating `u32` offset store was
   observationally fine and broke the collapse law, and the fix was to store signed and clamp at
   evaluation. Probe 4 hits the same class of defect from the other side in Part E.
5. **A `REBASE_REQUIRED` classification per event type**, parametric versus structural, so an event
   outside the compiled envelope is refused rather than silently mishandled.

## Part E — the minimal closed quotient on the probe-1 toy

Two different quotients live in probe 1, and they compress very differently.

### E1. The parameter quotient does not compress

Take the raw state to be what the declared `Delta` vocabulary actually acts on: the mutable
parameter record `(offset, capacity, enabled)` per leaf. Sealed vocabulary for a 2-leaf chain:
`offset_i`, `clamped_i` (the evaluation-time `max(0, offset)`), `capacity_i`, `enabled_i`,
`sum_offset`, `sum_clamped`, a lossless `class_word` packing every leaf's `(capacity, enabled)`, a
lossy `class_word_lossy` that collapses a disabled leaf to one code, and `optimum`. Events: a bump
of each sign, two capacity settings, and both enable settings, on every leaf — 12 generators.
Seed 2026, 48 raw corpus states, closure depth 2: 5,571 interned states, 1,973 checked.

| candidate | size | quotient | corpus exactness | closure | reachable exactness | verdict |
|---|---|---|---|---|---|---|
| `{optimum}` — the maintained value | 1 | 23 | 0 | **3,692** | 0 | rejected |
| `{sum_clamped, class_word}` | 2 | 442 | 0 | **2,885** | 0 | rejected |
| `{sum_offset, class_word}` | 2 | 709 | **2** | 0 | **211** | rejected |
| `{offset_0, offset_1, class_word_lossy}` | 3 | 1,551 | 0 | **447** | 0 | rejected |
| `{offset_0, offset_1, class_word}` | 3 | **1,973** | 0 | 0 | 0 | **congruence** |

Exhaustive enumeration to size three finds 3 admissible subsets inducing **1** partition
(`{offset_0, sum_offset, class_word}` and `{offset_1, sum_offset, class_word}` are the same thing
written differently). Its quotient is 1,973 — equal to the checked-state count. **Every checked
state is its own class: on the parameter side there is no compression at all.** The minimal
sufficient statistic closed under probe 1's declared event vocabulary is the full parameter record.

That is a useful negative and it sharpens probe 1's own claim. Probe 1's roughly 8,000-fold gap
between an event and a fresh solve at 16k leaves comes entirely from the *composition tree* —
recomputing one leaf-to-root path instead of the whole chain — and not from any state quotient.
Nothing about the parameter state was compressible; the win was structural.

Three of the four rejections are individually instructive:

- **`{optimum}` fails closure.** The maintained answer alone does not determine how the next event
  changes it. This is the same phenomenon as the planted family's `{opt_value, opt_witness}` decoy,
  reproduced on the real probe-1 vocabulary: the maintained view is not a valid projection state,
  which is the entire reason the retained tree exists.
- **`{sum_clamped, class_word}` fails closure** because `offset` is clamped to zero only at leaf
  evaluation. Knowing `sum max(0, offset_i)` does not determine `sum max(0, offset_i + d)`.
  Symmetrically `{sum_offset, class_word}` is closed but not *exact*, because the signed sum does
  not determine the clamped one. Probe 1's B2 fix — store signed, clamp at evaluation — bought an
  exact collapse law, and this measurement is the price it paid: the clamp is exactly what forces
  the closed statistic to be per-leaf rather than one scalar. That trade was not visible from
  probe 1's own gates.
- **`{offset_0, offset_1, class_word_lossy}` fails closure** because collapsing a disabled leaf to a
  single code discards the capacity that `SetEnabled { enabled: true }` will restore. A lossy store
  breaks closure, not exactness — the same failure shape as B2, in a second guise. This decoy was
  found by accident: the first version of the packing was the lossy one, and the closure counter
  reported 447 violations on what was meant to be the reference answer.

### E2. The summary quotient does compress, to a finite set times an integer

The normalized boundary matrices the brief and probe 1's item C3 point at behave completely
differently. Tropical projective normalization — subtract the smallest finite entry, preserve the
absent sentinel — is compatible with min-plus composition, and that is checked as a property test
(`normalization_is_compatible_with_composition`): normalizing at every intermediate step gives the
same class as normalizing once at the end.

Because a `CostBump` adds a constant to every finite entry of a leaf, the *normalized* leaf class is
invariant under the offset entirely. A leaf therefore occupies one of only five classes under the
declared vocabulary: capacity 0, 1, 2, 3 while enabled, plus the absorbing disabled class. Composing
a chain of those:

| leaves | leaf-class assignments | distinct normalized root classes |
|---|---|---|
| 2 | 25 | 12 |
| 3 | 125 | 36 |
| 4 | 625 | 98 |
| 5 | 3,125 | 219 |
| 6 | 15,625 | 540 |

Assignments grow by a factor of 5 per leaf; distinct normalized root classes grow by about 2.5, so
the composed summary genuinely collapses and the collapse strengthens with length.

For a *chain* the scalar separates exactly: every stage is used exactly once on any path, so the
optimum is the zero-offset optimum plus the sum of the clamped per-leaf offsets. The exact answer to
brief item 4 is therefore:

> The minimal closed quotient on the probe-1 toy is `Q = (a finite set of tropical-projective
> normalized boundary classes) x Z`, with `CostBump` acting freely on the `Z` factor and
> `SetCapacity` / `SetEnabled` acting on the finite factor. It is infinite only through the `Z`, and
> becomes finite under a cost cap.

That is the brief's "if the quotient is finite, exact optimization becomes a finite weighted
transducer" reduced to a concrete, measured statement — and it upgrades probe 1's C3 item 2 from a
proposal to a result.

### E3. Does evolve find it?

On the parameter side, yes: the exhaustive search over the sealed vocabulary returns the correct
answer and rejects all four decoys, including one nobody planted. On the summary side, no — and the
reason is a real limitation rather than a search failure. Evolve's typed VM computes `i64`-valued
programs over scalar fields (`PlanOp` in `vm.rs:670`); a normalized `4 x 4` min-plus matrix class is
not an `i64` and no composition of `Add`/`Min`/`Mod`/`Legendre` produces one. Reaching E2's quotient
through evolve would require either a matrix-valued feature admitted into the sealed vocabulary, or
a pre-sealed `normalized_class_id` feature computed by the generator — which is what the feature-DAG
presentation-transition machinery already exists to do safely. Naming that as the concrete next
integration is the actionable part: the search machinery is adequate, the *presentation* is not.

## Commands and artifacts

```
cd /home/tavis/src/ergodis-private
cargo test -p ergodis-private --lib congruence_search --release   # 10 passed
cargo fmt --all --check                                           # clean
cargo clippy -p ergodis-private -p ergodis-tools --all-targets -- -D warnings   # clean
cargo build --release -p ergodis-tools
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools congruence-search-report
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools congruence-search-report \
    --seed 2026 --depth 4 --corpus 48
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools congruence-search-report \
    --probe1-census-leaves 6
```

The ten gates in `congruence_search.rs`:

- `the_planted_statistic_is_a_congruence` — and its hashed score equals its exact-tuple score.
- `the_answer_itself_is_corpus_perfect_but_not_closed`.
- `the_index_decoy_is_corpus_perfect_but_breaks_on_a_continuation`.
- `the_linear_collapse_decoy_is_coarser_and_not_closed` — and strictly coarser than the planted
  statistic, so it is a genuine control rather than a tie.
- `dropping_a_planted_coordinate_fails_corpus_exactness` — all three coordinates are necessary.
- `exhaustive_search_recovers_the_planted_statistic` — no congruence of size at most two exists.
- `a_static_objective_prefers_a_decoy` — the corpus-only ranking tops out on a non-congruence.
- `normalization_is_compatible_with_composition`.
- `probe1_leaf_classes_are_offset_independent`.
- `probe1_parameter_quotient_admits_no_small_congruence`.

Host: the usual development box, NixOS, release profile, shared target directory
`~/.cache/ergodis/target/ergodis-private`. Seed 2026 unless stated. Nothing under
`/home/tavis/src/ergodis` was modified.

## Mystery ledger

- **Settled: the two decoy classes fail different conditions.** The index decoy is closed but not
  reachably exact; the answer-itself and linear-collapse decoys are exact but not closed. Neither
  condition subsumes the other, so both counters stay in the score. Found by measurement, not
  predicted.
- **Settled: probe 1's parameter state has no compressible quotient.** The minimal closed statistic
  is the whole parameter record (quotient equals checked-state count exactly). Probe 1's speedup is
  structural, from the retained tree.
- **Settled: probe 1's B2 fix has a measured cost.** Clamping the offset at evaluation instead of at
  store bought an exact collapse law and, in exchange, forces the closed statistic to carry a signed
  offset per leaf rather than one scalar sum. Neither `sum_offset` nor `sum_clamped` is admissible;
  the first fails exactness, the second fails closure.
- **Settled: the summary quotient is finite times `Z`.** Five normalized classes per leaf
  independent of the offset, and 12 / 36 / 98 / 219 / 540 distinct normalized roots at 2 to 6 leaves
  against 25 / 125 / 625 / 3,125 / 15,625 assignments.
- **Open, and the reason it stays open is a presentation limit, not a search limit.** Evolve's typed
  VM is `i64`-valued, so the E2 quotient is unreachable from the current sealed vocabulary. The gate
  is whether a `normalized_class_id` feature can be sealed through the existing feature-DAG
  presentation transition without weakening its replay guarantee. Not attempted.
- **Open: 18 admissible subsets over 2 partitions is a redundancy the ranking papers over.** The
  minimality tie-break among the 16 redundant spellings of the 615-class partition is lexicographic
  by column index, which is arbitrary. A principled search should rank partitions, not subsets, and
  `partition_signature` is the piece needed to do it; the enumeration does not yet use it as the
  primary key. Cheap, and it would make the reported winner canonical rather than incidental.
- **Open: the projection fragment is not the plan fragment.** Probe 4's candidates are subsets of
  sealed features, which makes exhaustive enumeration and exact negatives possible but is strictly
  weaker than evolve's program grammar. Whether a `phi` requiring a *derived* term — a residue, a
  saturating combination — can be found by the same objective under mutation search rather than
  enumeration is untested. The scorer is grammar-agnostic, so this is an integration question, not a
  redesign.
- **Open: closure depth 3 to 4 is a sample, not a proof.** Every reported congruence is a congruence
  *on the sampled closure*. Part D says what a proof would be; none was attempted. No result here
  may be given pruning authority.

## Vibe check

Good, and sharper than expected. The planted test did its job on the first run — the static
objective returns the answer itself as the "best" statistic, which is the cleanest possible
demonstration that a per-row fitness cannot see closure — and two of the four probe-1 rejections
were failure modes nobody planted, including one that turned an accidental bug in my own encoding
into a control. The one genuinely disappointing result is that probe 1's toy has no state
compression on the parameter side, but that is worth knowing precisely, and the summary side
compresses exactly as the brief predicted.
