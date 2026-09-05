# C1062 probe 5: adversarial review and repair of the arm comparison

**Lane**: `complete-ports`
**Task**: C1062, probe 5 (review)
**Plan**: `2026-09-04-c1062-exploration-log.md`, § "Probe 5" and § "Process rules"
**Inputs**: the probe 5 report `2026-09-04-c1062-probe5-evolve-proposes-separator-refutes.md`; its
evidence files in `ergodis-private` `evidence/2026-09-04-causal-abstraction-arms.txt` and
`evidence/2026-09-04-causal-abstraction-full-sample-reach.txt`; the probe 6 baseline finding
(`2026-09-04-c1062-probe6-kary-design-and-decision-equivalence.md` § 5) as the mirror question.
**Code commit**: reviewed `ergodis-private` `632c7b4`; repairs committed as listed in § 6.
**Replay**: `cargo run --release --package ergodis-tools -- causal-abstraction-report` at defaults;
output retained at `ergodis-private` `evidence/2026-09-05-causal-abstraction-arms-reviewed.txt`.
**Verdict**: nine findings, two of them substantive. The "shortest separating intervention" rule was
returning the plain observation 84% of the time, and the partition arm's reported collapse was
duplicate refinements plus a stall exemption rather than anything about the method. The published
`0.770x` and `0.967x` reproduce exactly under the repaired code at the published budget, so nothing
here is an arithmetic correction; what changes is their weight. On paired seeds the `0.770x` is
`p = 0.180` and the `0.967x` is `p = 1.000`, so probe 5's second half survives as a direction rather
than as a measured penalty, and the one statistically real effect in the probe is the arm the report
wrote off — the partition the certificate induces, winning at `p = 0.002` and `p = 0.039` once the
two artifacts are removed. Details in § 7.

This note is written incrementally, in the order the review ran. § 1 is what was checked and how,
§ 2 the findings with evidence, § 3 what was changed, § 4 what was left alone, § 5 the
re-measurements, § 6 the commits, § 7 which of probe 5's numbers stand.

## 1. What was checked and how

Read in full: `src/causal_abstraction.rs` (all of it), the planted families in
`src/causal_fixtures.rs` (`two_group_model`, `group_term`, `two_group_term`, the five fixtures,
`SeparatorVerdict`, `PlantedFixture`), `tasks/tools/src/causal_abstraction_report.rs`, the
`enumerate_supports`, `solve_into`, and `observation_of` routines in `src/causal.rs`, the
`RankedEvolutionDriver` contract in the core's `theorem_search.rs`, both evidence files, and the
probe 5 report. `feature_synthesis.rs` was checked for whether probe 5 uses it at all (it does not;
see § 2.3).

The attack order followed the brief: arm fairness, statistical strength, the seal criterion,
blinding, the replay, the one-sidedness diagnosis, the partition-arm collapse, then module
correctness.

## 2. Findings

Each finding states the evidence, whether it is a defect or a wording problem, and what it does to
the reported verdict. Numbered for reference from § 3 and § 7.

### 2.1 The "shortest separating intervention" rule is nearly vacuous on these families, and it silently prefers the null intervention

`enumerate_supports` in `src/causal.rs` starts from the empty support, so `SignatureTable::build`
enumerates the **null intervention** (no pins, arity 0) as intervention index 0, followed by the
`A = v` and `B = v` pins at arity 1. Every fixture declares `intervenable = [A, B]` at arity one, so
the whole vocabulary is one arity-0 intervention and `2 · domain` arity-1 interventions.

`SignatureTable::separating_intervention` returns the first index whose observations differ, and
`refute` keeps the over-merged pair with the strictly smallest arity, first in scan order among ties.
Two consequences:

- Whenever *any* over-merged pair is already separated by observation alone, the "separating
  intervention" the separator arms return is the null intervention — no pin at all. The rule
  "shortest separating intervention" therefore reads, on these families, "prefer an over-merged pair
  the plain observation already distinguishes, else the lexicographically first over-merged pair".
  No arity-1 intervention is ever preferred over another by length, because they are all length one.
- Ties are broken by scan order (`left` ascending, then `right` ascending), so the returned pair is
  **deterministic and biased toward the lowest-numbered contexts**. Context numbering is the
  mixed-radix exogenous index with the decoy digits fastest, so low-numbered contexts are the ones
  that differ from the starting sample in the fewest coordinates.

This is a code-versus-report mismatch, not a bug in the sense of an incorrect computation: the
report's § 1 describes the arm as "the one whose minimal separating intervention is shortest" and
§ 5 says "one separating intervention there hands over a whole sound refinement constraint", where
the intervention in question is mostly the observation partition itself. It also means the
`separator pair` arm confounds three things — always choosing an over-merge (one-sidedness),
preferring observationally separated pairs, and lexicographic determinism — and the report's § 4
attributes the loss to the first without a control for the other two. The `within kind` arm removes
the first but keeps the other two, so its return to `0.967x` is consistent with the diagnosis but
does not isolate it. See § 2.6 and the new `random over-merge` arm in § 3.

### 2.2 Report and code disagree on the statistic, and the measure is not the one the plan predeclared

`paired_ratio` in the report binary computes the **median of per-seed ratios**
`random_rounds / arm_rounds` over seeds where both arms sealed. The report's § 2 says the thresholds
are judged "as a ratio of medians". On `group counts` the ratio of medians would be
`14.0 / 18.5 = 0.757`, and on `pair counts` `5.0 / 5.5 = 0.909`, where the report prints `0.770x`
and `1.000x`. The code's statistic is the more defensible one for paired data; the report's wording
is wrong.

Separately, the plan row for probe 5 and the report's own header predeclare the threshold as
"beats the random-counterexample arm **on generations**", and the plan's third correction names
"generations-to-seal as the measure". The fixture source (`SeparatorVerdict`) predeclares
"`0.8x` the random arm's median **rounds**", and the binary judges rounds only. Rounds are a coarse
integer (medians of 3 to 5 on the small families), so a paired ratio on rounds saturates at
`1.000x` for many seeds; generations is the finer, plan-declared measure. Both are now printed and
judged (§ 3); § 5 reports what the generations measure says.

### 2.3 The seal criterion is a partition distance, as the plan demanded — confirmed

`corpus_violations` scores a term by the number of sampled context pairs whose merged/separated
status differs from the quotient's, plus for each refinement the number of distinct
`(term label, partition cell)` pairs beyond the number of distinct term labels. Both terms are zero
exactly when the term's kernel agrees on the sample and refines every accumulated partition. The
seal test in `refute` is exact kernel equality over all pairs of contexts, and `kernel_labels` maps
term values to first-appearance labels so a bijective re-encoding scores identically. Probe 5 does
not import `feature_synthesis.rs` at all; it carries its own `SynthesisDriver` on the core's
`RankedEvolutionDriver`, so the plan's regression concern does not arise. The test
`the_planted_term_seals_and_a_permuted_relabelling_seals_with_it` compares labels for equality,
which is legitimate only because both sides are first-appearance canonical; that is the case. No
defect.

### 2.4 Blinding holds, with two qualifications to state rather than fix

The search sees `BlindCorpus` rows (permuted digits under opaque positions), the sampled context
ids, and — through `corpus_violations` — the quotient's merge/separate verdict on sampled pairs.
That last item is the oracle's legitimate answer, not a leak of coordinates. The planted term is
built from the permutation only inside the fixture's own assertion and the report's rendering.
Qualifications: (a) the starting sample is contexts `0..6`, which in the fixtures' digit order vary
only the decoy and the low bits of `B`, so every arm starts with information about `B` and none
about `A` — identical across arms, so fair for the comparison, but it is a structured rather than a
random start; (b) the mutation vocabulary (`CONSTANTS = 1..5`, `MODULI = 2..8`) contains every
constant and modulus the planted terms use, which is an ordinary synthesis vocabulary but was
chosen knowing the families. Neither affects the arm comparison.

### 2.5 The replay is a bookkeeping check, not an independent semantic check

`replay_separator` calls `CausalModel::solve_into` and `observation_of`, the same two routines
`SignatureTable::build` uses to produce the table. It does not consult the table, so it does verify
that the recorded `(intervention, left, right)` triple is a separator under the model's own solver
— a real check on index bookkeeping across the arms' plumbing. It is not independent of the solver.
The independent corroboration of the table is the ground-truth gate (`root_classes` under the
compiler and `signature_classes` by direct enumeration agree with the table on every family). The
report's phrase "re-solved against the causal model itself — not read back from the signature
table" is accurate; "certificates replay" should not be read as more than that. Also, the `2,849`
count includes the random arm's separators (the random arm records a separating intervention
whenever its sampled pair happens to be an over-merge) and includes arity-0 null interventions;
§ 5 gives the split.

### 2.6 The one-sidedness diagnosis is under-controlled

§ 4 of the report explains the `0.770x` by the separator rule always returning an over-merge. That
is what the code does. But the arm also (i) prefers pairs the null intervention separates and (ii)
returns the lexicographically first such pair, deterministically (§ 2.1). The `within kind` arm
removes the one-sidedness and keeps (i) and (ii); it returns to `0.967x`, which shows that (i)+(ii)
carry no signal *once the kind is balanced*. It does not show that one-sidedness alone produces
the loss; a one-sided arm that samples uniformly among over-merges is the missing control. Added as
the diagnostic `random over-merge` arm in § 3; measured in § 5.

### 2.7 The separator-partition collapse has two mechanical causes in the code before any weighting question

Two things in `seal_abstraction` act only on the `SeparatorPartition` arm:

- **Duplicate refinements.** `corpus.refinements.push(table.induced_partition(index))` never checks
  whether that partition is already present. With one null intervention and `2 · domain` pins, there
  are at most `1 + 2 · domain` distinct partitions, and § 2.1 says the null one is returned whenever
  it can be. So the refinements list fills with copies of the observation partition, and each copy
  adds the same violation count to the fitness again — the weighting the report's § 5 worries about
  is not "equal weight", it is a weight that grows by one per round.
- **Stall exemption.** The stall rule (`STALL_LIMIT = 3` consecutive rounds adding no new context)
  is skipped for this arm, on the theory that it adds a refinement instead. Once the refinement is a
  duplicate, the round adds nothing, and the run burns its whole budget: the report's own row shows
  `group counts` / `separator partition` at `9.2` contexts after `27.9` rounds with `334` merge
  refutations and `0` fallbacks.

The report treats "intrinsic or a weighting artifact" as the open question. The prior question is
whether the collapse survives deduplication and a uniform stall rule. Fixed and re-measured in § 5,
with a `--pair-weight` knob for the weighting question the report asked.

### 2.8 The stall rule interacts asymmetrically with the deterministic arm

A round can add nothing to the corpus only when the proposed term does not fit the corpus
(otherwise any violated pair contains a new context). In that state the random arm draws from all
violated pairs, almost all of which contain a context outside the small sample, so it nearly always
grows. The separator-pair arm returns the lexicographically first over-merged pair, which is very
often two low-numbered contexts already in the sample. So the deterministic arm hits the stall
abort more readily, and an aborted run is recorded unsealed and drops out of the paired ratio. The
new `stalled` flag on `SealOutcome` and the `stalls` column expose how often this happened; § 5
reports a run with the stall rule disabled.

### 2.9 Module correctness

- Allocation in hot loops: `corpus_violations` allocates two `BTreeSet`s per refinement per
  candidate evaluation; `kernel_labels` builds a fresh `FeatureDag`, workspace, and `HashMap` per
  candidate; `mutate` and `canonicalize` allocate per mutation. The repository's zero-allocation
  contract is stated for solve adapters and hot records; this is a synthesis fitness whose cost is
  dominated by DAG evaluation over all contexts, and the core evolution driver clones candidates
  anyway. Recorded as a deviation, not fixed (§ 4).
- Search is iterative (`drive_ranked_evolution_streaming`), no recursion in the module.
- Determinism: all randomness is `SplitMix` seeded from `seed`; `HashMap`s are used for lookup
  only, with labels assigned by insertion count, so output is order-independent. The baseline
  replay reproduced the committed evidence byte for byte (§ 5).
- `paired_ratio` returns `None` when fewer than half the seeds seal in both arms; consistent with
  the `n/a` entries.
- `refutation_returns_nothing_once_the_kernel_is_the_quotient` omits the fourth arm; extended.
- The random arm pays the full separator scan (`best_separator` is computed for every arm), which
  wastes wall time but does not touch any reported measure.
- No off-by-one found in `initial_corpus`, `paired_ratio`, or the medians.

## 3. What was changed

All in `ergodis-private`, using the Edit tool, no new binary, one subcommand as before.

`src/causal_abstraction.rs`:

- `Corpus` gains `pair_weight` (default 1, the measured weighting) and a `refine` method that
  refuses an identical refinement; `corpus_violations` multiplies the sampled-pair term by the
  weight. Finding 2.7.
- `SealConfig` gains `stall_limit` (default `STALL_LIMIT = 3`, now `pub`) and `pair_weight`.
  `seal_abstraction` applies the stall rule uniformly: a round that adds neither a new context nor
  a new refinement counts as stalled, for every arm. Findings 2.7 and 2.8. Consumed separators are
  recorded before the stall check, so the replay count now includes the aborting round's
  certificate (the old code dropped it).
- `SealOutcome` gains `stalled`, distinguishing a stall abort from a round-cap.
- New diagnostic arm `CounterexampleArm::RandomOverMerge`: one-sided like the separator-pair arm,
  uniform among over-merged pairs. Its extra reservoir draws only when that arm is running, so the
  predeclared arms consume exactly the random stream they were measured under. Finding 2.6.
- `CounterexampleArm::is_predeclared` and a docstring on `SeparatorPair` that states what the
  shortest-first rule does on a single-arity vocabulary with the null intervention enumerated.
  Finding 2.1.
- Tests: `refutation_returns_nothing_once_the_kernel_is_the_quotient` now covers all five arms;
  new tests pin the pair weight, the refinement dedup, the arity structure of the vocabulary
  (null intervention first, every pin arity one, `1 + 2 · domain` interventions), and that the
  three one-sided arms return an over-merge with a replayable certificate whenever one exists.

`tasks/tools/src/causal_abstraction_report.rs`:

- Flags `--stall-limit`, `--pair-weight`, and repeatable `--family` (substring filter). Defaults
  reproduce the measured configuration.
- Per arm: `stalls` and `null` columns (stall aborts; arity-0 separators), and the paired ratio on
  both rounds and generations.
- A spread table per arm: paired seed count, wins/ties/losses on rounds, min–max and quartiles of
  the per-seed round ratio, an exact two-sided sign test on wins against losses, and quartiles of
  the generations ratio. Finding 2.2 and the statistical-strength question.
- The threshold table judges each predeclared arm on both the fixture's rounds measure and the
  plan's generations measure; a separate table shows the diagnostic arms on both measures.
- The replay line splits the count into all separators and null-intervention separators.

## 4. What was left alone, and why

- The allocation pattern in the fitness path (§ 2.9). Changing `corpus_violations`'s refinement
  metric to something allocation-free would change the partition arm's numbers for a reason
  unrelated to any finding; the DAG evaluation dominates anyway.
- The predeclared arms' selection rules, the seed derivation, the starting sample, and the
  mutation vocabulary. Changing any of these would make the measured numbers non-reproducible, and
  the pre-repair replay reproduced the committed evidence exactly (§ 5), which is worth keeping.
- The ten pre-existing clippy findings in other `tasks/tools` modules. The files touched here add
  none (`cargo clippy --workspace --all-targets`, filtered to `causal_abstraction`).
- The reach diagnostic (`evidence/2026-09-04-causal-abstraction-full-sample-reach.txt`) and the
  report's § 7; nothing found bears on it.
- The exploration log and closeout synthesis, per the brief.

## 5. The re-measurement

Two configurations are reported, because the published measurement did not use the binary's
defaults and changing the code and the budget at once would confound the repair with the budget.

**Run A, the defaults** (12 seeds, 40 rounds, sample 6, patience 10, 80 generations, beam 8, stall
limit 3, pair weight 1): `cargo run --release --package ergodis-tools -- causal-abstraction-report`,
retained at `ergodis-private` `evidence/2026-09-05-causal-abstraction-arms-reviewed.txt`.

**Run B, the published configuration** — the like-for-like comparison, since it is the exact command
in the probe 5 report's header, so only the code differs:
`cargo run --release --package ergodis-tools -- causal-abstraction-report --seeds 12 --rounds 30
--patience 25 --generations 300 --max-candidates 200000`, retained at
`evidence/2026-09-05-causal-abstraction-arms-published-config.txt`. Reported in § 5b.

The ground-truth gate passes on all five families by all three routes in both runs, before any arm
runs. Run B is the one that carries the argument, so it is reported first.

### 5b. Run B, the published configuration: the numbers reproduce, their strength does not

**The two headline ratios come back identical.** On `group counts`, separator pair is `0.770x` and
separator within kind is `0.967x` — the published values to three decimals, under the repaired code
at the published budget. Nothing in the repair moved the predeclared arms, which is the first thing
this review had to establish and the reason the arm-fairness findings are about interpretation
rather than about arithmetic.

Ratios are `random rounds / arm rounds`, median over the seeds where both arms sealed, so above one
means the arm finished sooner.

| family | arm | sealed | rounds | vs random | on generations | null |
|---|---|---|---|---|---|---|
| pair counts | separator pair | 12/12 | 5.4 | `1.000x` | `0.949x` | 47 |
| pair counts | separator partition | 12/12 | 3.3 | **`1.667x`** | `1.526x` | 13 |
| pair counts | separator within kind | 12/12 | 5.1 | `1.000x` | `0.956x` | 38 |
| pair counts | random over-merge | 12/12 | 5.4 | `1.000x` | `0.930x` | 32 |
| pair parities | separator pair | 12/12 | 7.9 | `0.889x` | `0.900x` | 57 |
| pair parities | separator partition | 12/12 | 6.2 | `1.171x` | `1.344x` | 18 |
| group counts | separator pair | 10/12 | 19.4 | `0.770x` | `0.744x` | 189 |
| group counts | separator partition | 11/12 | 8.2 | **`1.619x`** | `1.850x` | 63 |
| group counts | separator within kind | 11/12 | 15.3 | `0.967x` | `1.036x` | 106 |

`group parities` and `group residues` still produce too few paired seals to report a ratio.

**The spread is the finding.** By the exact two-sided sign test on paired seeds, ties dropped:

| family | arm | paired | w/t/l | rounds q1..q3 | min..max | `p` |
|---|---|---|---|---|---|---|
| pair counts | separator partition | 12 | 10/2/0 | `1.312..1.667` | `1.000..2.000` | **`0.002`** |
| group counts | separator partition | 10 | 8/1/1 | `1.556..1.845` | `0.900..2.571` | **`0.039`** |
| group counts | separator pair | 10 | 2/1/7 | `0.584..0.986` | `0.519..1.800` | `0.180` |
| pair counts | separator pair | 12 | 2/5/5 | `0.833..1.000` | `0.600..1.250` | `0.453` |
| pair counts | random over-merge | 12 | 1/6/5 | `0.833..1.000` | `0.600..1.250` | `0.219` |
| group counts | separator within kind | 10 | 4/1/5 | `0.908..1.338` | `0.438..1.700` | `1.000` |
| pair parities | separator pair | 12 | 4/1/7 | `0.724..1.233` | `0.364..1.600` | `0.549` |

Three consequences, in the order they matter.

**The `0.770x` is directionally right and statistically unestablished.** Seven of ten paired seeds
have the separator-pair arm slower, two faster, one tied, at `p = 0.180`, with per-seed ratios from
`0.519` to `1.800`. The direction the report drew is the direction the data leans, but "worse, at
`0.770x`, about `30%` more rounds" reads as a measured penalty and ten paired seeds at `p = 0.180`
do not support that reading. The `0.967x` is a genuine wash and now has the statistic to say so:
four wins, one tie, five losses, `p = 1.000`.

**The partition arm's collapse was the artifact finding 2.7 predicted, and the arm is the one real
effect in the probe.** With duplicate refinements refused and one stall rule for every arm, it goes
from "wins on the smallest family, `1/12` sealed on the next" to sealing 11 of 12 on `group counts`
and winning there at `1.619x` on rounds and `1.850x` on generations, `p = 0.039`, alongside
`1.667x` at `p = 0.002` on `pair counts`. It also seals in the fewest rounds of any arm wherever it
seals. The question the report carried — "intrinsic, or an artifact of equal fitness weighting" —
is answered, and by neither branch: it was duplicate refinements inflating the fitness by one copy
per round, plus a stall exemption that let the run burn its whole budget. The `--pair-weight` knob
remains for the weighting question, which is now separate and much smaller.

**Every predeclared threshold is still missed, on both measures.** No separator arm reaches the
predeclared `1.25x` on a family predicted "separator", and neither family predicted "wash" is one —
`pair parities` has separator pair at `0.889x`, outside the `1.1x` band on the other side. Ten of
ten threshold rows read "missed" under the fixture's rounds measure and the plan's generations
measure alike. That is harsher than the published report and is recorded rather than retuned.

Finding 2.1 is confirmed empirically: **2,601 of the 3,100 replayed separating interventions were
the null intervention**, 84%, so the "shortest separating intervention" rule was overwhelmingly
returning the plain observation.

### 5a. Run A, the defaults: the same picture at a different budget

Run A agrees on every qualitative point at a smaller per-round budget, which is worth recording
because it shows the conclusions are not an artifact of one budget. Separator pair on `group counts`
is `0.690x` at `p = 0.727` on eight paired seeds; separator within kind is `1.667x` at `p = 1.000`;
separator partition wins on three families, significant only on `pair counts` at `p = 0.002`. The
noisier `group counts` rows are the ones whose paired counts fall to eight and five, which is the
expected consequence of a tighter budget leaving fewer runs sealed in both arms. The two arms whose
published values reproduce exactly do so only in run B, at the published budget, as they should.

## 6. Commits

- `ergodis-private`: the module and report changes of § 3, the new evidence file, and the rustfmt
  reflow the formatter applied to five sibling `causal_*.rs` files that were not rustfmt-clean.
- `othello`: this note and the probe 5 report revision.

Validation before commit: `cargo test --release --package ergodis-private --lib` passes (895 tests),
and the report binary runs clean at defaults.

## 7. Which of probe 5's numbers stand

| claim | status |
|---|---|
| the loop seals, recovering the planted abstraction up to reparameterization | **stands**, unchanged |
| ground truth agrees by all three routes on every family | **stands**, re-verified |
| the separating *pair* is not a better counterexample than a uniformly sampled violated pair | **stands as a direction**, not as an established effect |
| `0.770x` on the largest sealing family | **reproduces exactly**, but is `p = 0.180` on ten paired seeds spanning `0.519..1.800`: the report should not read it as a measured `30%` penalty |
| `0.967x` for the kind-balanced arm | **reproduces exactly**, and is now backed as a wash: four wins, one tie, five losses, `p = 1.000` |
| the separator arm is one-sided, and that explains the loss | **stands as a description of the code, weakened as an explanation**: the loss it explains is not statistically established, and the new `random over-merge` arm — one-sided but uniform among over-merges — sits at `1.000x` on `pair counts`, so one-sidedness alone costs nothing measurable there |
| `1.667x` for the partition arm on the smallest family, collapsing to `1/12` sealed on the next | **superseded**: the collapse was duplicate refinements plus a stall exemption; repaired, the arm seals 11 of 12 on `group counts` and wins there at `p = 0.039`, alongside `p = 0.002` on `pair counts` — the only significant effects in the probe |
| all 2,849 separating interventions replay | **stands as bookkeeping**, with the count 3,100 under the repaired code, 2,601 of them the null intervention, and the check acknowledged as sharing the model's solver |
| staging beats handing over the whole quotient at once | **stands**, untouched by this review |

**Verdict.** Probe 5's first half is intact, its numbers reproduce exactly, and its second half
survives as a direction rather than as an established effect. The conclusion should be read as
"nothing here shows the separating pair is an informative counterexample", not as "the separating
pair is `30%` worse": ten paired seeds at `p = 0.180` lean that way without establishing it. The one
real effect in the probe runs the other way, and the report had written it off. The *partition* the
certificate induces — the sound refinement constraint over all contexts, rather than the pair — wins
on two families at `p = 0.002` and `p = 0.039`, and its reported collapse was duplicate refinements
plus a stall exemption rather than anything about the method. The brief's claim was about the
separating intervention as a witness. The measurement now says the witness is worth something
exactly when it is used as a constraint over every context, and nothing measurable when it is used
as a pair.

