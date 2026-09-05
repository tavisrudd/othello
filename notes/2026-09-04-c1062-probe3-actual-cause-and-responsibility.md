# C1062 probe 3: exact actual cause, responsibility, and the certificate that did not compact

**Lane**: `complete-ports`
**Task**: C1062, probe 3
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 0 for the responsibility formula and the pre-entered published verdicts; probe 1
for the lowering that supplies the class oracle.
**Code**: `ergodis-private` `3fcaa0c`, `925f19c`, `163d799`
**Replay**: `cd ~/src/ergodis-private && cargo test --release --package ergodis-private --lib
actual_cause:: -- --nocapture --test-threads=1`
**Evidence**: `ergodis-private` `evidence/2026-09-05-causal-actual-cause-repaired.txt`, the output of
that command after the review repairs. No evidence was retained when this report was written.
**Reviewed**: `2026-09-05-c1062-probe3-review.md`. Corrections are marked **[corrected]** below and
the original reasoning is kept wherever it explains how a number was reached.
**Verdict**: the engine is correct and reproduces every published verdict exactly. The exhaustion
certificate **does not** meet its predeclared 10% compactness threshold on these fixtures. Tavis
directed that this not close the probe; the finding is recorded and work continues, with the
emphasis moving to the decision layer.

## The engine

`ergodis-private/src/actual_cause.rs` implements the **modified** Halpern–Pearl definition: the
witness set `W` is held at its actual values and only the candidate cause is set away from its own.
The search ranges over `(X', W, x')` with the queried literal a conjunct of `X'`, layered by
`|X'| + |W|` so the first success is minimal by construction, with AC3 checked explicitly by a
bounded sub-search over every strict nonempty subset of the cause.

Degree of responsibility is `1 / (|X'| + |W|)`, per probe 0. The trap that motivated probe 0's
question is real and is now guarded by tests: transplanting Chockler–Halpern's `1/(k+1)` would
return responsibility 1 for every cause, because their `k` counts the witness variables whose value
*differs* from the actual context and under the modified definition none do.

## Published verdicts, all reproduced

Every value below was entered from probe 0's audit **before** the engine was run — commit order
confirms it: the audit landed at 15:10 and the engine at 15:54.

**[corrected] the "Published" column overstates four of the eight rows, and none of the eight values
discriminates the modified definition.** Halpern's IJCAI 2015 paper contains no degree-of-
responsibility values at all — one passing citation of Chockler–Halpern and nothing more. What
Example 3.1 publishes is the cause *shape*: conjunctive, each of `L = 1` and `MD = 1` is a but-for
cause; disjunctive, `L = 1 ∧ MD = 1` is a cause and neither singleton is. The degrees `1` and `1/2`
follow from applying the responsibility formula to those shapes, which is what probe 0's own § Q3.3
said ("my computation from Definition 2.5, not a published number") before this table wrote
"Published" over it. Both voting values *are* published, in Chockler–Halpern § 1, in the same
paragraph — cited here for only one of them. And Chockler–Halpern's `1/6` for the 11–0 vote is
`1/(k+1)` with `k = 5` other voters set **away** from their actual values, shape `|X| = 1, |W| = 5`;
the engine's `1/6` is `|X| = 6, |W| = 0` under the modified definition. Same number, different
object, and the same coincidence holds for the disjunctive forest fire and for rock throwing. The
discriminating evidence is the two shape cells this report already calls out, not the values. See
`2026-09-05-c1062-probe3-review.md` § 2.4. All eight verdicts were independently re-derived with no
compiler in the loop and reproduce exactly.

| Fixture | Value | Computed | Shape found | Source |
|---|---|---|---|---|
| Forest fire, conjunctive, `L = 1` | `dr = 1` | `1/1` | `\|X\|=1, \|W\|=0` | Halpern IJCAI 2015 Ex. 3.1 |
| Forest fire, conjunctive, `MD = 1` | `dr = 1` | `1/1` | `\|X\|=1, \|W\|=0` | same |
| Forest fire, disjunctive, `L = 1` | `dr = 1/2` | `1/2` | `\|X\|=2, \|W\|=0` | same |
| Forest fire, disjunctive, `MD = 1` | `dr = 1/2` | `1/2` | `\|X\|=2, \|W\|=0` | same |
| Rock throwing, `ST = 1` (Suzy) | `dr = 1/2` | `1/2` | `\|X\|=1, \|W\|=1`, witness `{BH}` | Ibrahim diss. § 2.4 |
| Rock throwing, `BT = 1` (Billy) | `dr = 0` | `0/1` | not a cause | same |
| Voting 11–0 | `dr = 1/6` | `1/6` | `\|X\|=6, \|W\|=0` | same |
| Voting 5–4 | `dr = 1` | `1/1` | `\|X\|=1, \|W\|=0` | Chockler–Halpern 2004 § 1 |

Two results are worth calling out because they are the ones a weaker implementation gets wrong.
The **disjunctive forest fire** returns the conjunctive cause `L = 1 ∧ MD = 1` with each conjunct at
one half; a singleton-only search would report "not a cause, responsibility 0" and look clean. The
**rock throwing** fixture recovers the witness set `{BH}` held at its actual value zero, which is
exactly the published witness, and correctly finds Billy not to be a cause under any definition.

## The measurement that failed its threshold

| fixture | degree | candidates | pruned | entries | distinct classes | verifier fraction | unclassified |
|---|---|---|---|---|---|---|---|
| forest-fire-conjunctive | 1/1 | 1 | 0 | 0 | 0 | 0.00% | 0 |
| forest-fire-disjunctive | 1/2 | 3 | 0 | 2 | 2 | 66.67% | 0 |
| rock-throwing-suzy | 1/2 | 4 | 0 | 3 | 3 | 75.00% | 0 |
| rock-throwing-billy | 0/1 | 40 | 15 | 32 | 16 | 58.18% | 0 |
| voting-5-4 | 1/1 | 1 | 0 | 0 | 0 | 0.00% | 0 |

**[corrected]** the column headed `classes` counted certificate **entries**, not classes: the class
memo is reset per cause, so one class is recorded again under every cause that reaches it. On
`rock-throwing-billy` the 32 entries cover 16 distinct classes, so the fraction reads `58.18%` on
entries and `29.09%` on classes. Which is the right numerator depends on whether the certificate is
a list of obligations a verifier replays or a list of classes whose membership covers every
candidate, and deduplicating across causes is not obviously sound because the coverage argument is
per cause — so both are now reported rather than one silently chosen. Both miss the threshold. The
`unclassified` column is also new: a surviving candidate the oracle cannot classify used to be
dropped from the certificate silently, so an oracle-free run reported `0.00%` indistinguishably from
a row with no negative to certify. It is zero on every row here.

The predeclared threshold was a verifier fraction below 10%. It is missed by a wide margin on every
row that has a non-trivial negative.

**Read the numbers before reading the verdict.** The rows with 0% have a certificate of size zero
because the cause is found on the first or only candidate — there is no negative to certify, so
those are not passes. The one row with a real exhaustion obligation, `rock-throwing-billy`, searched
55 candidates in total, pruned 15 of them by class (27%), and recorded 32 classes. A search space of
55 is far too small for a class-based negative to compress: the class count is bounded by the
quotient size, which is a fixed property of the model, while the candidate count grows
combinatorially in the pool size and the size bound. **The prediction that follows is that the
fraction improves sharply with model size, and it is currently untested** — probe 1a's envelope
(`|U| ≲ 10^4` at arity two or three) is what limits how far it can be pushed on the flat carrier,
which is a second reason probe 7's compositional route matters.

So the compactness claim is not refuted, it is **unmeasured at any interesting scale**, and the
statement today is that the certificate has not been shown to compact. Per Tavis's direction this
does not close the probe.

**[corrected] the prediction is refuted on the model-size axis, and there is a structural reason it
cannot hold there.** The premise above conflates two axes: growing the *size bound* on a fixed model
does grow the candidate count against a fixed quotient, but growing the *model* grows the quotient
too. Measured on losing-voter queries with a genuine exhaustion obligation, the verifier fraction is
flat — `70.59%`, `68.00%`, `66.67%`, `65.85%` at five, seven, nine and eleven voters with a size
bound of two, and `73.27%`, `71.91%`, `70.59%` at bound three — with pruning falling to **zero** on
the larger rows. The one row that improves is `rock-throwing-billy` at a larger size bound,
`58.18%` to `35.64%`, still three and a half times the threshold.

The reason: a compiled class never spans sorts, and a contingency candidate's pinned support *is*
its sort, so two candidates with different witness sets can never be in the same class. Pruning can
only collapse the settings of one fixed support, a factor of `d^{|X|} − 1`, which for singleton
causes over binary variables is one — no compaction at all — while the candidate count is dominated
by the witness-set choice `C(|pool| − |X|, |W|)`. That is why the fraction is invariant to the
number of variables.

**The live axis is domain width, not model size.** Ten per cent is reachable only when candidates
with `d^{|X|} − 1 ≥ 10` dominate the count and their settings actually collide in class: binary
variables need causes of size four or more, or a single-variable cause over a domain of twenty.
Probe 7's thresholded sources over domain 20 are the natural test bed and they sit inside the flat
envelope, which the probe 1 review shows is `|U| ≲ 10^5` rather than `10^4`. See
`2026-09-05-c1062-probe3-review.md` § 2.3.

## A defect in the core's quotient-only certificate policy

Found while measuring, and it is a core issue rather than a lane one. Compiling the same lowering
under three certificate policies:

| voters | arity | states | sorts | quotient-only | split transcript | exhaustive pair audit |
|---|---|---|---|---|---|---|
| 4 | 3 | 1,040 | 15 | ok, 15 classes | ok, 15 | ok, 15 |
| 5 | 2 | 1,632 | 16 | ok, 16 classes | ok, 16 | ok, 16 |
| 5 | 3 | 4,192 | 26 | **error** | ok, 26 | ok, 26 |
| 6 | 2 | 4,672 | 22 | **error** | ok, 22 | ok, 22 |
| 6 | 3 | 14,912 | 42 | **error** | ok, 42 | ok, 42 |

`CertificatePolicy::QuotientOnly` fails with `generator N is not compatible with class M`, while
`SplitTranscript` and `ExhaustivePairAudit` both succeed **and agree with each other on the class
count**.

**[corrected] the threshold is the state count, not the sort count.** Both readings fit these five
points — sorts split 15, 16 against 22, 26, 42; states split 1,040, 1,632 against 4,192, 4,672,
14,912 — but only one has a mechanism, and it is in the core: `multiway_admission` in
`ergodis/src/observational.rs` opens with `if presentation.state_count() < 4_096 { return
Rejected }`, and `QuotientOnly` and `AdaptiveTranscript` route into the broken multiway refiner only
once that gate admits them. `4,096` sits precisely inside the unexplained window between `1,632` and
`4,192`. The refiner bug beneath it is a real core defect, reproduced and repaired independently in
`2026-09-04-c1062-core-certificate-policy-repair.md` (core `6cc9668`); probe 2 separately withdrew
the sort-count hypothesis. See `2026-09-05-c1062-probe3-review.md` § 2.2.

**[corrected] the regression witness named below was inert.** Commit `925f19c`, "avoid the
quotient-only policy", rewrote the row *labelled* `"quotient-only"` inside
`locate_the_voting_compile_failure` to compile under `SplitTranscript` — one policy compared against
itself — so the test printed `ok` on every row and the table above was not reproducible from
committed code. That test is replaced by
`every_certificate_policy_agrees_on_the_voting_lowerings`, which exercises all five policies,
asserts they agree on the class count, asserts the sweep reaches the 4,096-state gate, and pins the
repaired behaviour rather than the failure. At core `6cc9668` all five agree on all nine rows.

The lowering is not at fault. A range check added to `lower` verifies that every generator
transition lands inside its declared target sort, and it passes on all of these; two independent
policies agree on the answer. The most likely locus is the quotient-only path's internal transcript
construction, which the C983 record notes was recently reworked so that "quotient-only still entered
the quadratic synchronous refiner; it now constructs and verifies the compact transcript
internally".

**Raising, not fixing** — `~/src/ergodis` is C1017's active surface. C1062 works around it by using
`SplitTranscript`, which was the right workaround: no probe 3 number was ever taken under a
miscompiling policy. The regression witness is now
`every_certificate_policy_agrees_on_the_voting_lowerings`, which runs in under a second and prints
the table above with five policy columns instead of three.

## Two defects fixed in the lane's own code

1. **Support sets were generated as positions, used as variable ids.**
   `enumerate_supports` produced indices `0..intervenable.len()`, while sort sizing, the local index
   split, and the generator target lookup all index domains by variable id. Every fixture built so
   far declares `intervenable = 0..n`, where the two coincide, so nothing was observably wrong — and
   any model with a non-contiguous intervention vocabulary would have been silently miscompiled.
   Found by reading rather than by a failing test, which is worth noting: the existing fixtures
   could not have caught it.
2. **The lowering did not check its own transition ranges.** Added, with a typed error, so that a
   malformed presentation fails at the lowering with a variable-level message instead of surfacing
   much later as an opaque class id inside the compiler.

**[added] what defect 1 says about probe 1's oracle gate.** The three pre-fix call sites of
`enumerate_supports` were `carrier_cost`, `lower` and `signature_classes` — probe 1's "independent
direct-enumeration oracle". The lowering and its oracle shared the defective routine identically, so
probe 1's gate ("all seven fixtures agree") passed while both sides were wrong for any model whose
intervenable set is not `0..n`. "The existing fixtures could not have caught it" is right, and
neither could the oracle. That is the general shape of the shared-code weakness, recorded in
`2026-09-05-c1062-probe1-review.md` § 2.4.

3. **[added by the review] Three further repairs in this module.** `class_of` did not bound its
   context argument and returned a later sort's class instead of `None`; probe 3 is the consumer
   where a wrong class silently prunes a candidate and can move a degree of responsibility to zero.
   The exhaustion certificate silently omitted any candidate the oracle could not classify; it now
   counts them, and the verifier fraction is documented as meaningful only when that count is zero.
   And AC3's witness search was capped by the caller's `maximum_size`, which errs toward declaring a
   non-minimal cause minimal and under-reporting responsibility; it now ranges over every subset of
   the remaining pool. **No verdict or number moved**: all eight published verdicts and every cell of
   the certificate table are unchanged under the uncapped search.

## Foreign-lane note

`tasks/tools/src/tiger_blossom_bench.rs` is uncommitted and currently does not compile
(`time_shots` not found), which blocks the whole `ergodis-tools` binary. That is C1061's file,
mid-edit by a concurrent session. The probe-3 measurement was therefore taken through the library
test target instead of the tools subcommand; the subcommand is committed and will work once that
lane's edit lands. This is the second foreign-lane obstruction recorded today, after the seven
clippy findings in probe 1's report.

## Where this leaves the probe

Against the plan's kill criterion — no compact negative, or no amortization — the compactness half
is missed and the amortization half was not reached, because the timing arm lives in the blocked
tools binary. Tavis directed that the probe not close on this, and the direction is right for a
reason worth stating: **the exhaustion certificate is a property of the negative, and the negative
is only expensive at a scale the flat carrier cannot yet reach.** Killing on a 55-candidate search
would be drawing a conclusion from the wrong regime.

## Next, and a change of emphasis

Tavis's steer is that the **decision layer** is what to lean into. That agrees with the adversarial
plan review, which called the missing optimization probe the plan's largest faithfulness gap: this
is a spike for an exact optimization compiler, the brainstorm's proposal 6 is optimization over
interventions, and no probe computed `best_intervention`. It is also where the compiled quotient
plausibly pays, since "find the cheapest intervention reaching this outcome" is a search over the
monoid action on the quotient rather than a single re-solve.

Actual causality now becomes an **input** to that layer rather than the headline: the minimal
contingency is what turns "this failed" into "this is the smallest change that would have prevented
it", which is a decision, not an attribution. Probe 2 is therefore promoted to the spine, and its
first deliverable is `best_intervention` with a cost model, followed by minimax regret over a
bounded model set.
</content>
