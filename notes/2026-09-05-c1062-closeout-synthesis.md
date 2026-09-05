# C1062 closeout, revised after review: what a structural causal model is worth as a context language for Ergodis

**Lane**: `complete-ports`
**Task**: C1062, task-level closeout across probes 0, 1a, 1, 2, 3, 4, 5, 6, 7 and 8
**Supersedes**: `2026-09-04-c1062-closeout-synthesis.md`, which predates every review below
**Plan**: `2026-09-04-c1062-exploration-log.md` (probe index, thresholds, process rules, review index)
**Reviews**: `2026-09-05-c1062-probe1a-review.md`, `2026-09-05-c1062-probe1-review.md`,
`2026-09-05-c1062-probe2-review.md`, `2026-09-05-c1062-probe3-review.md`,
`2026-09-05-c1062-probe4-review.md`, `2026-09-04-c1062-probe5-fable-review.md`,
`2026-09-05-c1062-probe6-review.md`, `2026-09-05-c1062-probe7-review.md`,
`2026-09-05-c1062-probe8-review.md`. Probe 0 was not reviewed.
**Code**: `~/src/ergodis-private` (`causal*.rs`, `best_intervention.rs`, `actual_cause.rs`,
`causal_design.rs`); core changes: none from the probes, one repair recorded in
`2026-09-04-c1062-core-certificate-policy-repair.md`
**Status of the plan**: every probe except 9, the gated demonstration, is done and every probe except
0 has been adversarially reviewed. No engine computes a wrong answer. Every correction is in the layer
that says what the numbers mean.
**Scope**: private research. No manuscript, mirror, public-surface, or Ergodis-core change was made
by this closeout.

## 1. The question, and the answer

C1062 asked whether a finite structural causal model is another context language for the Ergodis
contextual quotient: lower the model plus a declared intervention vocabulary onto the observational
compiler, get exact causal abstraction, and use a separating intervention as the refutation witness.

The answer, after nine probes and nine reviews: **the lowering is real and exact, nothing built on it
is wrong, and nothing measured shows that compiling it buys what the task said it buys.** Every
engine — the lowering, best intervention, actual cause and responsibility, the counterfactual, the
seal loop, the design planner, the compositional reduction, the sequential window — reproduces every
published number under a re-derivation in code sharing nothing with the probes' own. That is the
task's solid floor and it is worth stating first.

Above that floor the previous closeout's central claim does not survive. It said that what compiling
buys is a replayable certificate, a decidable expressibility test, and completeness over words the
direct route never enumerated. The reviews damage all three. The exhaustion certificate cannot compact
along the axis that grows, and the reviews measured it flat rather than leaving it untested. The
expressibility test is a sufficient and conservative check with three parts, not the exact two-part
condition the probe stated. The completeness claim is false against probe 8's own oracle, which closes
a finite edit-state space and therefore already answers every word. Every economics tie of `1.00x` is
an identity of the carrier or a family too small to separate the arms, not a measurement of cost. Two
of the task's headline ratios — probe 2's `220x` and probe 7's `1.000e12x` — are withdrawn or reworded
as artifacts of instrumentation and fixture choice.

Two things move in the task's favour. The separating intervention does carry a teaching signal, in
both probes that measured it: probe 5's partition arm is the only statistically real effect in that
probe once a fitness artifact is removed, and probe 6's separator arm beats uniform sampling on nearly
every one of forty seeds where the single-seed report said the signal was absent. And probe 7's
reduction — the one route that never materializes the carrier — is exact on every fixture, verified
as partition equality rather than by class count, with its novelty differences confirmed against the
neighbouring paper itself.

## 2. Three faults that belong to the task, not to any probe

The reviews converge on three findings that no single probe owns.

**The independent oracle the plan demanded was never built.** Every probe's oracle is Rust in the same
module as the object it checks, sharing `solve_into`, `observation_of` and `enumerate_supports` with
the lowering. Probe 3's review found the concrete instance: for the interval between two commits, the
lowering and probe 1's direct-enumeration oracle shared the same support-enumeration bug, so probe 1's
agreement gate could not have caught it. The reviews supplied the missing independence retroactively
in scratch Python, one probe at a time, and every number held. That is why the correctness verdicts
stand — but they stand on the reviews' re-derivations, not on the probes' own gates.

**No probe but 5 retained an evidence file.** Probe 6 retained its outcome tables but not the arm
table that carries its only measured claim. Everything else exists as terminal output from a command.
Every table reproduces on re-running at the reviewed commit except three of probe 2's, which the core
repair changed, and probe 3's certificate-policy table, which cannot be reproduced from the committed
code at all because its regression witness was rewritten to compare one policy against itself in the
same commit that reported the defect.

**No ratio had a paired-seed test behind it until the reviews added one, and two single-seed ratios
inverted under repetition.** Probe 5's `0.770x` penalty is `p = 0.180` on ten paired seeds; probe 6's
"no measurable signal" becomes a win on 36 to 40 of 40 seeds. Probe 2's paired `|t|` in the hundreds
is a timer-stability statistic, not an effect size. No ratio in this task should be read without a
spread behind it.

Predeclaration discipline was uneven rather than absent: probes 2 and 3 committed their thresholds
before their code, probe 2 then edited its threshold text in the results commit, and probes 6 and 7
landed code, verdicts and measurements in one commit, with six of probe 7's thirteen verdicts coming
from a wildcard default.

## 3. The repair that shaped everything, as it now stands

The original plan's lowering was ill-typed and the adversarial plan review killed it before any code:
`do(V := a)` applied to an exogenous assignment is a solution of a different model, so a generator has
nowhere to land. The forced repair makes the state the pair `(u, I)` of a context and the current
pinned assignment. Probe 1a's review checked the two results the whole plan revision rests on — the
`state = u` refutation and the signature-collapse proposition — and both are sound. Its consequences
are unchanged in kind and corrected in degree:

- **The exponential moved from the vocabulary into the compile**, but the envelope is wider than
  stated. Probe 1a's per-state constant `4(nd + 1)` is the interior-sort constant, and in the
  arity-bounded regime almost every state sits at the boundary where a sort carries `kd` generators.
  The realized cost is about `27` bytes per state at twenty binary variables and arity two, so the
  flat envelope is `|U| ≲ 10^5` rather than `10^4`. Probe 7's promotion from gated to expected
  survives on the argument that actually carries it — a canonical exogenous space fails by twelve
  orders of magnitude, which no constant of order ten touches — and probe 7's own table reproduces the
  correction on a fixture the review never saw.
- **Word closure is vacuous for hard pins**, so the compiler's contribution on that vocabulary is not
  the quotient on `U`. What probe 1a did not name is the trade its own sort structure makes: one sort
  per pinned support buys memory and gives up any identification of states with different pinned
  domains. A contingency candidate's pinned support is its sort, so the congruence on intervened
  states can never prune across witness sets. That is the ceiling probe 3 spent a session hitting, and
  it was derivable at pencil time.
- **The observation set is a dial, not a constant.** Unchanged and confirmed.
- **Relevance pruning is not in the lowering.** `CausalModel::lower` never calls
  `prune_irrelevant_exogenous`; the routine is correct where it runs, and probe 2's compression
  baseline is the one place outside a test where it runs.

Everything C1062 measured is a measurement of that carrier, and the reviews' repair of the constant
does not change any verdict that rested on it.

## 4. What each probe settled, after review

| probe | claim under test | verdict after review |
|-------|------------------|----------------------|
| 0 | no mature actual-causality engine exists; the compiled object is unpublished | **half false**, unreviewed and unchanged: three engine lineages exist; the full-observation quotient is Balke–Pearl's response-function partition; the refinement algorithm with a separating witness was not located |
| 1a | the flat carrier is practical | **viable, and the envelope is `\|U\| ≲ 10^5`**, six to nine times wider than reported; the kill criterion as written could not have fired; the sort structure forecloses the cross-support pruning the same note promised probe 3 |
| 1 | the lowering is correct against external truth | **passes**: 60 contexts to exactly 32 classes, class for class, now corroborated by an implementation sharing no code; the predeclared separator-replay gate was replaced by an arity-boundary gate and never run, and the four printed separators all replay when the review runs them; relevance pruning is claimed in the lowering and is not there |
| 2 | compiling pays for the decision query | **exact, and the economics fail by more than reported**: the `220x` over concrete-state search is withdrawn, being a ratio of per-query workspace clears with the arms memoized unalike (`102x` like for like, and even that is a memset); the compression threshold passes on one family rather than two, because the published credit ratio is not the predeclared one; the `1.00x` against memoized re-solve is an identity of the carrier, and the memoized baseline fills its table in half the solves the identity charges it with; the timing workload has no query with a nonempty answer |
| 3 | an exact, certificate-carrying Halpern–Pearl engine | **correct, certificate refuted on compactness**: every verdict and both discriminating shapes re-derive independently; the verifier fraction is flat near seventy percent as the model grows, and structurally cannot fall because classes never span sorts; only domain width can move it; four rows labelled "Published" are computed from published shapes, and every value in the table is one the original definition also yields |
| 4 | the twin network becomes a path | **measurement stands, precondition restated**: two arms exact, two wrong (`0/1` and `2/3` against `1/3`), `O ⊇ E` sufficient and not necessary; the stated two-part condition omits the outcome-observed check the code makes and admits a wrong answer, `O ⊇ E ∪ {Y}` alone is refuted by the probe's own third row, and the three checks are jointly sufficient and conservative rather than exact |
| 5 | separating interventions are unusually good counterexamples | **refuted for the pair, reversed for the partition**: `0.770x` and `0.967x` reproduce exactly and are `p = 0.180` and `p = 1.000` on paired seeds; the separator rule was returning the null intervention 84% of the time; the partition arm's collapse was duplicate refinements plus a stall exemption, and repaired it wins at `p = 0.002` and `p = 0.039` |
| 6 | decision equivalence is a cheaper identification target | **structural half stands, comparative half inverts**: sharing an optimal action is not transitive, so no quotient expresses the stopping rule; the gap result is an existence result by construction; the predeclared `1.00x` loss holds only under the simultaneous-optimality criterion; the separator arm wins on 36 to 40 of 40 seeds at two to eight percent, below the `1.10x` bar and not absent |
| 7 | a compositional route reaches scale | **exact, and the ceiling claim is scoped to its fixtures**: every cell re-derives and the coarsest-product-refinement claim holds as partition equality; a four-context fixture with correlated parents gives composed 4 against a ceiling of 2, so the gate's equality assertion is false in general; `1.000e12x` is the fixture dial `(20/2)^12`; 25.6 µs is real work on the mechanism tables, not a rate over contexts; one of four predicted losses is an arity-rung mismatch |
| 8 | the "another context language" thesis has content | **non-vacuity holds; what it buys does not**: no cursor generator idempotent, no pair commuting, edit states past the window, all exhaustively searched and controlled; completeness over unbounded words is false against the probe's own oracle; only 7 of the 34 order-essential certificates are order-essential at the pair level; "a richer vocabulary is a finer quotient" is contradicted by its own table; `1.00x` is a ratio of two counts bounded below by one |

## 5. No measurement shows that compiling makes an answer cheaper

The previous closeout read three `1.00x` results as three independent measurements of one structural
negative. The reviews show they are not measurements. Probe 2 prints `states / (contexts ×
interventions)`, which is one by construction of the carrier. Probe 8 prints
`edit_states / |reachable|`, two combinatorial counts with no solve in them, which cannot fall below
one. Probe 6's greedy-versus-exact tie is a family-size effect, and its mean comparison is against a
tree that minimizes the worst case rather than the mean.

The direction survives and is, if anything, understated. Probe 2's memoized baseline prunes by cost
and fills its table in 16,640 solves where the compile performs 33,024, so the identity credits the
baseline with twice the work it actually does and the compile loses by more than the report says; and
the like-for-like gap against the concrete search is dominated by a 297,216-byte workspace clear
rather than by search. On the one timing family, half the contexts answer
at cost zero and the other half are unreachable, so no arm ever ran the query the probe is about.
Nothing in C1062 has timed a compiled query winning, and nothing has timed one on a workload where the
answer is nontrivial.

Probe 7 remains the only route that changes the arithmetic, because it never materializes
`|U| · π_k`. Its cost is linear in the mechanism-table size and independent of the context count,
which is the defensible form of its scale claim.

## 6. What the compiler is actually worth here

Take the previous closeout's three items in turn.

**The certificate.** Where it was measured, it does not compact. Probe 3's exhaustion certificate
covers a candidate count dominated by the choice of witness set, and a compiled class never spans
sorts, so the certificate can only merge settings of one cause with one witness set — a factor of
`d^c − 1`, which is one for singleton binary causes. The review measured the verifier fraction flat
from five to eleven voters and from size bound two to four, with pruning falling to zero on the larger
rows, and on the distinct-class reading the one real row is `29.09%` rather than `58.18%`, still a
miss. The only lever that can reach the ten-percent threshold is domain width, and that fixture is a
session's work. Elsewhere the certificate is thin in a different way: probe 1 decoded its separators
and never replayed them, probe 5's separators were the null intervention 84% of the time, and probe
7's `refinement_witness` returns a pair of contexts exhibiting the composed quotient's own
incompleteness, not a replayable experiment. The one place a certificate carries information no pin
set carries is probe 8: under a non-idempotent, non-commuting vocabulary the separating word's order
and repetitions matter. That is a statement about the witness, not about cost. It holds for every
certificate the enumeration emitted and, at the level of the pairs, for seven of thirty-four.
And those separators do not round-trip through the compiler — `separating_words` searches the model
and checks separation through `observe` — so the word certificate does not need the compile either.

**The expressibility test.** Probe 4's three checks — evidence set is a union of classes, action is
declared, outcome is observed — are jointly sufficient, decidable on the classes, and conservative.
They are not exact: within the probe's own fixture family a query can fail the checks and be exact
anyway, and the sweep finds hundreds of such combinations. Dropping any one check admits a wrong
answer; the fifth arm the review built, with the evidence observed and the outcome not, returns `0`
against `1/3` under the two checks the report kept. What a caller learns from "inexpressible" is that
the quotient carries no guarantee, not that the answer is wrong. This is still the most useful thing
the compilation turned out to provide, and probe 1a's review notes that it was not on the pencil
probe's list of what the compiler adds — it was unforeseen. The review also found the result the probe
left on the table: the two failure modes are asymmetric. An abduction failure is representative-shaped
and some representative choice hits the truth; a prediction failure is structural and no choice does.

**Completeness over unenumerated words.** False. The direct route in probe 8 closes a finite
edit-state space by breadth-first search in at most eight steps and then answers every word of every
length, exactly as the compiled machine does; twenty thousand random length-twenty words per
vocabulary all land inside the closed set. The advantage was stated against a word-enumerating route
that the plan itself ruled out and that exists nowhere in the repository.

What survives as the compiler's contribution is therefore narrow: exactness against external truth on
the flat carrier, the congruence on intervened states as an available object that only probes 2 and 3
consume, and a sufficient decidable safety check for counterfactual queries. None of those needed a
faster answer, and none was shown to need the compile rather than the direct signature partition.

## 7. What reversed in the task's favour

**The separating intervention teaches, as a constraint and as a selection rule.** Probe 5's
separator-partition arm — the whole observation partition the separating intervention induces,
imposed over every context — was written off because it sealed one run in twelve on the second
family. That collapse was duplicate refinements inflating the fitness by one copy per round plus a
stall exemption that let the run burn its budget. Repaired, the arm seals eleven of twelve on that
family and wins at `p = 0.039` there and `p = 0.002` on the smallest family, sealing in the fewest
rounds of any arm wherever it seals. Probe 6's separator-of-sampled-pair arm, reported from one seed as
carrying no signal, beats uniform sampling among splitting experiments on 40, 40, 37 and 36 of 40
seeds on the four non-degenerate families, recovering a sixth to a half of the gap between random and
optimal. The effect is small and below the predeclared `1.10x` informativeness bar. It is not absent,
and probe 6's claim to be a second measurement of probe 5's null is withdrawn: one is a null with a
negative lean, the other a small consistent positive.

**Probe 7's ceiling claim is stronger than its own gate checks**, holding as partition equality on
every coordinate of every fixture where the tool compares block counts. The novelty argument's three
differences against Madaleno, Misra and Markham's coarsening work hold against the paper itself, and
its interventional coarsening turns out to be equality of intervened-ancestor sets — a graphical
condition, further from probe 7's object than the report's paraphrase suggested.

## 8. What died, and should not be revived without new evidence

- **The separating pair as a counterexample.** Probe 5: nothing measures an advantage for the pair,
  and its rule was mostly returning the plain observation. The usable form is the induced partition.
- **Variable merging, and the "hundred thousand variables become a fifty-state machine" line.**
  Retired in probe 7 and untouched by review; the exogenous carrier is kept deliberately.
- **First-engine and raw-speed framing for actual causality.** Closed by probe 0. Probe 3's review
  narrows the correctness case further: every value in the verdict table is one the original
  definition also produces, so the discriminating evidence is the two cause shapes, not the eight
  numbers.
- **Decision equivalence as a quotient.** Probe 6: the stopping rule is a covering condition, not a
  partition, and the review calls this the strongest result in the probe.
- **Completeness over unbounded words as what compilation buys.** Probe 8, § 6 above.
- **"A richer vocabulary is a finer quotient."** The unit shift has the smallest edit space and the
  finest quotient; the mechanism is whether the vocabulary can invert what the natural run discards.
- **The `220x`, the `1.000e12x` as a discovered compression, and the `846x` certificate cost.** The
  first is withdrawn, the second is `(20/2)^12` set by the fixture, and the third is superseded by the
  core repair to roughly `300x`.

## 9. What is ours, after the audit and the reviews

Probe 0's audit was not reviewed and its strip stands as drawn: the full-observation quotient is Balke
and Pearl's response-function partition and a correctness fixture rather than a result; "bisimulation
under intervention" is Chakraborty, Caulfield and Pym's term; factored partition refinement descends
from Givan, Dean and Greig and no algorithmic novelty is claimed for it. What was not located in any
index is the specific combination: the coarsest quotient of a finite model's exogenous space under
indistinguishability by every admissible intervention, computed by refinement, emitting a separating
intervention as the refutation witness, with the arity tower as a reported object.

Two overclaims in the novelty argument are withdrawn by probe 7's review. The arity dial has no
compositional form, so probe 7 delivered one declared dial, the observation set, and not two. And the
separating-intervention witness was not carried through the factorization, which the note itself said
must be done or said not to have been done; neither happened. What the flat lowering delivers on the
witness is decoding, verified by the review's replay of the four printed words.

## 10. The core defect, as the reviews leave it

The core miscompiled the causal lowerings under four of its five certificate policies, and it was a
real refiner bug repaired in the follow-up recorded in
`2026-09-04-c1062-core-certificate-policy-repair.md`. Three things are now settled that the probes
recorded differently. The threshold is the `4,096`-state admission gate into the multiway refiner
combined with a shape condition, not the sort count — probe 3's own state column located it between
`1,632` and `4,192`, and probe 2's "neither sorts nor states" is half wrong. The test probe 3 named as
the regression witness compares `SplitTranscript` against itself and prints all-ok, so the published
failure table cannot be reproduced from the committed code; the right replacement is a test pinning
the repaired agreement. And the policy choice is load-bearing for probes 2, 3 and 8: their carriers reach or cross the
admission floor and their numbers are safe only because every measured table compiles under
`SplitTranscript` or the exhaustive audit; probes 1 and 4 are below the floor and safe regardless.

## 11. Live defects and gaps the reviews leave open

None of these changes a published number today. Each is a trap for the next fixture or the next
caller, and every one has a patch written in its review.

- **Probe 7's product-ceiling gate asserts a false-in-general equality** and will hard-fail on the
  first fixture with correlated endogenous parents feeding a mechanism that reads an exogenous
  variable only where the correlation forbids. The invariant that holds is refinement.
- **`CausalLowering::class_of` does not bound its context argument** and returns a later sort's
  class instead of `None`. Probe 3 is the consumer where a wrong class silently prunes a candidate and
  can move a degree of responsibility to zero.
- **Probe 8's report buckets a failed separator search as "separated by observation"**; at
  `--max-word 1` the cursor's length-zero column inflates from 59 to 93.
- **Probe 3's certificate silently omits any candidate the oracle cannot classify**, so an
  oracle-free run reports `0.00%` indistinguishably from a genuine no-negative row, and a size bound
  above the lowering's arity certifies less than the search established.
- **Probe 3's AC3 witness search is capped by the caller's size bound**, undocumented, erring toward
  under-reporting responsibility.
- **`exogenous_states` saturates silently past `u64`**, and three routines disagree about the
  coordinate limit.
- **Probe 6's `ArmMetrics::mean` divides a censored sum by the uncensored run count**, flattering
  any arm that stalls.
- **Probe 2's `class_of(...).unwrap_or(u32::MAX)`** turns a lookup failure into a silent merge.

## 12. Mystery ledger, task level

- **Why is every economics ratio exactly `1.00x`?** Settled, and not as the previous closeout had it:
  two of the three are identities that could not have come out otherwise, and the third is a
  family-size tie. There was never a measurement to explain. **Closed.**
- **Probe 3's certificate compactness.** Refuted on the model-size axis with a structural reason.
  **Open on the domain-width axis only**, predicted of order `1/(d − 1)`, one fixture, one session.
- **Probe 3's amortization arm.** Still unmeasured; the foreign obstruction that blocked it is gone
  and the measurement is one flag on the existing subcommand. **Open and cheap.**
- **Probe 7's composed quotient reaching the product ceiling.** **Closed in the negative** by a
  four-context counterexample whose mechanism is the forward pass's per-variable reachability product.
  The conjecture that equality holds whenever that product is realized is unproved and would convert
  the ceiling column into a checkable side condition.
- **Probe 4's weakest decidable sufficient condition.** Necessity is closed as false. Whether a
  strictly weaker class-level test is still sufficient is **open**; the natural candidate defeats the
  point by re-solving per context.
- **Probe 5's induced-partition collapse.** **Settled by the review** as a code artifact, by neither
  branch of the weighting question the report posed. The weighting knob remains and the question is
  now separate and small.
- **The intervention-vocabulary quotient is empty for hard edits** and was never re-measured under the
  non-idempotent vocabulary probe 8 built. **Open and cheap**, unchanged.
- **Probe 8's economics gate.** The identity breaks only for a vocabulary whose reachable edit set is
  a strict subset of the declared encoding. **Open**: a synthetic fixture does it; whether a
  vocabulary anyone would declare has the property is the real question.
- **Probe 6 never trades probe price against repair price in one objective**, so "decision-sufficient"
  is one point on a family of stopping rules. **Open.**
- **The `u64` context index caps probe 7's next scale claim, not the published one.** Unchanged, with
  the saturating interface noted above.
- **No genuine mystery remains about the central thesis.** It was tested where it has content, under
  a sequential non-idempotent vocabulary, and the non-vacuity held. What that content buys was tested
  and did not hold. That is a complete answer to the question C1062 asked.

## 13. Recommendation

Probe 9 is a demonstration the plan says must never count as evidence, and every component it would
chain is built and now independently re-derived. **Close C1062 without probe 9**, as before.

Three successors deserve allocation, in order.

1. **A repair-and-retention pass over the reviews' patches.** Fix the live defects in § 11, replace
   probe 3's inert regression witness with one that pins the repaired agreement, add the fixtures the
   reviews wrote (probe 7's correlated-parents counterexample and shared-source-merging model, probe
   4's fifth arm), retain an evidence file for every probe, and apply each review's wording repairs to
   its report so the reports stop saying things the reviews refuted. This is bookkeeping, and it is the
   precondition for anything below being trusted.
2. **The two measurements that can still move a verdict.** Probe 3's wide-domain fixture and its
   amortization arm, which together are the last untested route to a positive certificate result on the
   flat carrier; and the compositional counterfactual crossover — probe 7's reduction under probe 4's
   query — which probe 4's review confirms is the open cost question and which composes existing exact
   pieces into a measurement nobody has taken.
3. **The economics question, restated.** The previous closeout asked whether the certificate could be
   emitted without compiling the carrier. Probes 5 and 8 already do that — their separators come from
   the direct route — and completeness is not a differentiator, so the question in that form is answered.
   The replacement is narrower: is there any declaration under which compiling is ever cheaper than
   the direct signature partition? Probe 8's strict-subset vocabulary and a probe 2 timing workload with
   nontrivial answers are the two cheap places to look, and a negative there would let the `1.00x`
   results be reported as a design input rather than as three coincidences.

The core-side items — the deferred-verification artifact carrying no "unverified" marker, and the
certificate-policy witness — belong with C1017 rather than here.
