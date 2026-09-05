# C1062 exploration log: structural causal models in Ergodis

**Lane**: `complete-ports`
**Brief**: `2026-09-04-c1062-ergodis-causal-brief.md`
**Plan review**: `2026-09-04-c1062-plan-review.md` (adversarial; this plan is its revision)
**Code**: `~/src/ergodis-private` (core changes, if any, in `~/src/ergodis`)
**Status**: probes 0, 1a, 1, 3, 2, 7, 8, 4, 5 and 6 done; probe 9 remains, and the closeout
recommends dropping it. Task-level verdict: `2026-09-05-c1062-closeout-synthesis.md`, which
supersedes `2026-09-04-c1062-closeout-synthesis.md`.
Every probe except 0 has been adversarially reviewed; see § "Reviews" for what each review changed.
**Archive**: `2026-09-04-c1062-exploration-log-archive.md` holds the pre-run probe plans and the
running results narrative.

This is the routing document for C1062. The task asks whether a finite structural causal model
(SCM) is another context language for the Ergodis contextual quotient, and what that buys: exact
causal abstraction with separating interventions as counterexamples, an exact Halpern–Pearl
actual-causality and responsibility engine, exact best-intervention search over the compiled
quotient, an experiment-design layer over a bounded hypothesis family, and an Evolve loop that
names the quotient classes. Each probe gets its own dated report; this file carries only the probe
index, standing results, process rules, and the next step. Reports are the authority for numbers.

**This plan is revision two.** The first version rested on a lowering that is ill-typed, and the
adversarial review killed it. What changed is recorded in the next section, because the correction
is the most important content in the file.

## The lowering, corrected

The first plan said: state is the exogenous assignment `u`, generators are atomic interventions
`do(V := a)`, so forty generators replace `3^20` interventions. That is wrong. A generator in
`observational.rs` is a total map from states to states, and `do(V := a)` applied to `u` is a
solution of a *different model*; it is not an element of `U`. The generator has nowhere to land.
The exception is interventions on root variables only, where pinning a root is re-assigning its
exogenous value and `U` is closed — but the plan's own fixtures intervene on non-roots.

The forced repair: **state is the pair `(u, I)`**, where `I` is the current partial assignment of
pinned variables, later overriding earlier. Generators are total on that carrier. The consequences
are all bad for the original claim and must be carried openly:

- **The exponential moves from the vocabulary into the compile.** Materialized states number
  `|U| · ∏_V (|D_V| + 1)`. The forty-generator observation is true of the *vocabulary* and false of
  the *compile*. Probe 2 reports the materialized `(u, I)` count as raw states, never `|U|`.
- **The escape is an arity bound.** Restrict to interventions of arity at most `k`, expressed as
  the sort structure (states `|U| · Σ_{j ≤ k} C(n, j) d^j`) or as a `FiniteContextLanguage` over
  generator words. `continuation.rs` then gives the refinement tower `~_{≤1} ⊇ ~_{≤2} ⊇ …` for
  free. The tower need not stabilize — a threshold-`t` outcome keeps refining until arity near `t`
  — so stabilization is a reported object, not a stopping rule.
- **Word closure is vacuous for hard interventions.** Override composition is idempotent and
  commutative on distinct variables, so every word reduces to its final partial assignment and the
  reachable set from `u` is exactly `{(u, I)}`. Therefore `u ~ u'` iff `O(M_I(u)) = O(M_I(u'))` for
  every admissible `I` — a one-pass signature partition, which refinement recomputes at the same
  asymptotic cost. **The compiler's contribution is not the quotient on `U`.** It is (a) the uniform
  separator certificate and (b) the congruence on the intervened states `(u, I)`, which is the
  monoid action on `Q` and the thing that prunes the contingency search in probe 3.
- **The thesis has content only where the context alphabet is genuinely sequential**: unrolled
  time-indexed models, observe-then-act sequences in the epistemic layer, and non-idempotent
  operations such as soft or shift interventions. Probe 8 tests the first of those, deliberately.
- **"Generator" widens to "declared atomic mechanism edit"**, not just value assignment, so that
  disable-block, force-signal, and policy interventions `do(V := g(pa(V)))` are expressible. Each
  is still a total typed map from a declared finite set. The linear-vocabulary statement then reads
  "linear in the declared edit set", which is what it should always have said.
- **The observation is a declared query-relevant variable set, not just the outcome.** Level-3
  abduction needs the evidence set to be a union of classes, which holds iff `O ⊇ E`; actual-cause
  verdicts need the actual values of the cause and candidate contingency variables. With `O` equal
  to every endogenous variable on a root-exogenous model the quotient is the identity. So `O` is a
  dial from coarse to trivial, and `|Q|` must be reported as a function of `|O|`.

**What the compiled relation actually is.** With `O` = declared outcome, it coarsens the *exogenous*
space with endogenous variables and vocabulary unchanged — Beckers–Halpern's `τ` is the identity on
endogenous settings and the commuting square is trivial. It is closest to targeted reduction of
causal models. With `O` = all endogenous variables and the full `do(pa(V) := p)` vocabulary on a
canonical exogenous space, it is **exactly Balke and Pearl's 1994 response-function partition**.
That is a known object, a mandatory correctness fixture, and a novelty risk. Beckers–Halpern
variable-merging abstraction ("these 27 states are one causal variable") lives on a different
carrier — endogenous settings — and there `(u, I)` is strictly *finer*, since it remembers whether
`V = 1` is natural or pinned. The full atomic vocabulary is also exactly what makes nontrivial
merges impossible, which is why Beckers–Halpern restrict the allowed intervention set. **The
linear-vocabulary claim and the interesting-abstraction claim pull in opposite directions**, and no
probe may quietly claim both.

## Probe index

| Probe | Name                                                | Size | Predeclared threshold | Verdict | Report |
|-------|-----------------------------------------------------|------|-----------------------|---------|--------|
| 0     | Prior-art and landscape audit                       | S    | every landscape claim in the brief resolved or discarded | **done**: engines exist, no probe cut; responsibility formula corrected; probe 7 gains a near neighbour | `2026-09-04-c1062-probe0-prior-art-and-landscape-audit.md` |
| 1a    | Pencil: carrier, cost model, signature collapse     | S    | closed-form state count; collapse stated and proved | **done**: viable but narrow; envelope `\|U\| ≲ 10^4` at arity 2–3; probe 7 promoted | `2026-09-04-c1062-probe1a-carrier-and-cost-model.md` |
| 1     | Lowering, oracle, Balke–Pearl fixture, towers       | M    | class-for-class agreement on the response-function fixture | **done**: 60 contexts to 32 classes, all three gates pass; contract one-quarter delivered | `2026-09-04-c1062-probe1-lowering-and-towers.md` |
| 2     | **Best intervention, and the economics that follow** | L    | compiled beats memoized re-solve on the enumeration query, residual compression above the orbit baseline | **done**: compression passes (4.97x, 2.00x), timing fails structurally; quotient worth 220x over concrete-state search | `2026-09-04-c1062-probe2-best-intervention-and-economics.md` |
| 3     | Exact actual causality and responsibility           | L    | verifier work under 10% of search; published verdicts matched | **done**: all eight published verdicts reproduced; certificate missed 10% at a 55-candidate scale; not closed | `2026-09-04-c1062-probe3-actual-cause-and-responsibility.md` |
| 4     | Level-3 counterfactual and the observation precondition | M | exact under `O ⊇ E ∪ {Y}`; demonstrably wrong without it | **done**: two arms exact, two wrong (0/1 and 2/3 against a true 1/3); `O ⊇ E` is sufficient and not necessary, and the exact two-part condition is decidable on the classes | `2026-09-04-c1062-probe4-counterfactual-precondition.md` |
| 5     | Evolve proposes, separator refutes                  | M    | seals to the exact kernel, and beats the random-counterexample arm on generations | **done, then revised**: the loop seals up to reparameterization; the separator-*pair* arm is `0.770x` and the kind-balanced arm `0.967x`, both reproduced and both statistically unestablished (`p = 0.180`, `p = 1.000`); the separator-*partition* arm's reported collapse was a fitness artifact and it wins at `p = 0.002` and `p = 0.039` after repair | `2026-09-04-c1062-probe5-evolve-proposes-separator-refutes.md`, revised by `2026-09-04-c1062-probe5-fable-review.md` |
| 6     | k-ary experiment design and decision equivalence    | M    | measured gap between full and decision-sufficient identification, plus a near-zero gap on the negative family | **done**: met on both halves; gaps run from `1.00x` on the predeclared loss to zero experiments and to a decision reached where identification is impossible, and decision-sufficiency is not an equivalence relation at all | `2026-09-04-c1062-probe6-kary-design-and-decision-equivalence.md` |
| 7     | Compositional lowering along the DAG                | L    | composed quotient equals the flat one on small models | **done**: reduction exact, `4.1e15` contexts to 4,096 in 25.6 µs; the composed quotient is a product partition and equals the flat one on 9 of 13 families, reaching the product ceiling on every coordinate | `2026-09-04-c1062-probe7-novelty-argument.md`, `2026-09-04-c1062-probe7-compositional-lowering.md` |
| 8     | Unrolled sequential window                          | S    | word closure non-vacuous, measured | **done**: met sharply — cursor vocabulary has 0/4 idempotent, 0/6 commuting, minimal words past the window, and all 34 length-≥2 separators order-essential, against a control with none; economics 1.00x as predeclared | `2026-09-04-c1062-probe8-unrolled-sequential-window.md` |
| 9     | End-to-end: incident to minimal repair              | L    | demo only, never counted as evidence | gated on 2 and 3 | — |

Sizes are relative within one fast session: S is under an hour, M is one to three, L is a session.
Gating: `0 ∥ 1a → 1 → {2, 3, 4, 5, 8} → {6, 7} → 9`. Probe 3 depends on probe 2 only for the
class-pruning machinery, which probe 3 owns.

## Reviews

Each review is adversarial, read-only, and independent: it re-derives the probe's numbers from the
definitions in code that shares nothing with the probe's own, and it proposes patches without
applying them. The reviews are the authority for what a probe's numbers now mean.

| Probe | Review | Correctness | What the review changed |
|-------|--------|-------------|-------------------------|
| 1a    | `2026-09-05-c1062-probe1a-review.md` | the `state = u` refutation and the signature-collapse proposition both hold | recommending sorts over a context language forecloses the contingency pruning it promised, since a class never spans sorts and a candidate's pinned support *is* its sort — the ceiling probe 3 later spent a session hitting, derivable at pencil time; the closed-form count is a uniform-domain special case one fixture already falls outside |
| 1     | `2026-09-05-c1062-probe1-review.md` | survives; the response-function gate is external truth | probe 1a's per-state constant is the interior-sort one, so the envelope is `\|U\| ≲ 10^5` not `10^4`; the predeclared separator-replay gate was silently swapped and never run; relevance pruning has no caller; `class_of` does not bound its context argument |
| 2     | `2026-09-05-c1062-probe2-review.md` | survives everything attacked, including minimax regret | the `220x` is withdrawn — it times a 297,216-byte array clear, and like-for-like is `102x`; the credit ratio's denominator changed after predeclaration and `restricted-vocabulary` is `1.000x` under the declared metric; the timing loss is larger than reported and misattributed |
| 3     | `2026-09-05-c1062-probe3-review.md` | survives; all eight verdicts and both cause shapes re-derived | the named regression witness compares one policy against itself; the sort-count diagnosis is the `4,096`-state admission gate; the compactness excuse is refuted — the fraction is flat in model size, and only domain width can move it; four rows marked "Published" are computed, not published |
| 4     | `2026-09-05-c1062-probe4-review.md` | survives; all four arms re-derived class vector by class vector | the stated precondition omits the outcome-observed check the code makes, and a fifth arm returns `0` against a true `1/3`; `O ⊇ E ∪ {Y}` is refuted by the probe's own third row; the condition is sufficient and conservative, not exact; the two failure modes are asymmetric under representative choice |
| 5     | `2026-09-04-c1062-probe5-fable-review.md` | ratios reproduce | the separator rule was returning the null intervention; the partition arm's collapse was a fitness artifact; the two headline ratios are statistically unestablished and the partition arm is the probe's only real effect |
| 7     | `2026-09-05-c1062-probe7-review.md` | theorem sound; all thirteen fixtures re-derived; the coarsest-product-refinement claim verified as partition equality where the tool compares block counts | the ledger's open item closes against the probe — a four-context fixture with correlated parents gives composed 4 against a ceiling of 2, so the `ensure!`/`assert_eq!` demanding ceiling equality assert something false in general and will hard-fail on it; `wide-conjunction-arity-1` is an arity-rung mismatch, not a non-product shape; the `1.000e12x` is a fixture dial and the scale check tests plumbing, not the theorem; the three novelty differences hold against the paper itself |
| 8     | `2026-09-05-c1062-probe8-review.md` | every number reproduces from the binary and from an independent implementation; the control is measured, not assumed | the completeness-over-unbounded-words claim is false against probe 8's own oracle, which closes a finite edit-state space and already answers every word — 20,000 sampled length-twenty words per vocabulary land inside it; only 7 of the 34 separators are order-essential over *all* minimal separators; the richer-vocabulary-is-finer statement is contradicted by its own table; the `1.00x` is a ratio of two counts with no solve in it |
| 6     | `2026-09-05-c1062-probe6-review.md` | structural half survives, including non-transitivity | the "no teaching signal" finding is single-seed and inverts at forty seeds (37–40 of 40 in favour of the separator); the predeclared loss is a property of the strong decision-sufficiency criterion, not of the family |

Three findings are common to every reviewed probe and belong to the task rather than to any one of
them. **No probe retained an evidence file on disk** except probe 5. **Single-seed ratios inverted
twice** under repetition, in probes 5 and 6, so no ratio in this task should be read without a
paired-seed test behind it. And **the independent oracle the plan demanded was never built**: each
probe's oracle shares `solve_into`, `observation_of` and `enumerate_supports` with the lowering it
checks. The reviews supply that independence retroactively in scratch Python and the numbers hold,
which is why the correctness verdicts stand.

## Scope, and the decisions behind it

- **Acyclic finite deterministic mechanisms only.** Cyclic SCMs need a solution concept first.
  Sequential targets are reachable by bounded unrolling, which probe 8 tests rather than assumes.
- **The probabilistic layer is deferred, and this is a decision with a reason, not an omission.**
  Brief section 5 demanded a measured negative control against a junction-tree-class baseline;
  revision one silently dropped both that and `P(y | do(i))`. The deferral stands because the
  deterministic layer must work first, but the eventual native negative control is named here: a
  variable-elimination enumerator over the same finite model, roughly a hundred lines of Rust. No
  external package, per the lane's native preference.
- **Out of scope:** general causal discovery from observational data; any wrapper on or dependency
  on pyAgrum, HUGIN, SMILE, DoWhy, or ChiRho; mechanistic interpretability of neural networks —
  and note the real reason is not "no finite substrate" but the carrier problem, since this
  quotient cannot express "these states are one variable" at all; any paper, manuscript, mirror, or
  public-surface change.

## Terminology

"Bisimulation under intervention" is a published term (Chakraborty, Caulfield and Pym 2025, with
van Benthem–Bergstra and Hennessy–Milner correspondence theorems). Per the standing rule against
coining, use their term and cite them whenever this quotient is described as a bisimulation. What is
ours on that axis is the minimization algorithm and the separating witness, not the equivalence
notion.

## Process rules

- Each probe writes its own dated report before the next starts; this log gets a row and a one-line
  verdict.
- Every row carries a predeclared numeric threshold, in the C1061 style ("break-even 1.13 updates",
  "15 of 18 cells"), entered before the run.
- Predeclare shape verdicts before measuring, per C1038, with at least one predicted loss per
  measurement probe.
- Every negative states its exact searched domain and stop condition.
- Commit owned paths as each probe's validation passes; no accumulation.
- Tier rules from `ergodis-private/AGENTS.md`: tier-1 library code, one subcommand on the lane
  crate, no new `src/bin`, shared build cache.

## Status and next step

All nine planned probes are resolved: probes 0 through 8 ran and each has an independent
adversarial review — probes 1a, 1, 2, 3, 4, 6, 7 and 8 reviewed on 2026-09-05, probe 5 on
2026-09-04 — and probe 9, the gated end-to-end demonstration, is recommended for dropping, since
every component it would chain is already built and independently replayed and the plan forbids
counting the demonstration as evidence. The task is ready to close on Tavis's call.

The task-level verdict is `2026-09-05-c1062-closeout-synthesis.md`, which supersedes the 2026-09-04
version: the lowering is exact and mostly not worth compiling, with three independent economics
measurements tying at `1.00x`; the thesis has content only under a sequential non-idempotent
vocabulary; and what the compiler buys is the certificate, the decidable expressibility test, and
completeness over words the direct route never enumerated.

Three successors deserve allocation, in this order.

1. **A repair-and-retention pass over the reviews' patches**, which is the precondition for trusting
   anything below it: fix the live defects the reviews name, replace probe 3's inert regression
   witness with one that pins the repaired agreement, add the fixtures the reviews wrote (probe 7's
   correlated-parents counterexample and shared-source-merging model, probe 4's fifth arm), retain an
   evidence file for every probe, and apply each review's wording repairs to its report so the
   reports stop saying what the reviews refuted.
2. **The two measurements that can still move a verdict**: probe 3's wide-domain fixture together
   with its amortization arm, the last untested route to a positive certificate result on the flat
   carrier; and the compositional counterfactual crossover, probe 7's reduction under probe 4's
   query, which composes exact pieces into a measurement nobody has taken.
3. **The economics question, restated.** Whether the certificate can be emitted without compiling
   the carrier is answered — probes 5 and 8 already do it from the direct route, and completeness is
   not a differentiator. The replacement question is whether any declaration makes compiling cheaper
   than the direct signature partition; probe 8's strict-subset vocabulary and a probe 2 timing
   workload with nontrivial answers are the two cheap places to look. A negative there would let the
   `1.00x` results be reported as a design input rather than as three coincidences.

Carried forward, none blocking: the arity tower is computed at full price per rung rather than
incrementally through `plan_layered_greedy_schedule`; the intervention-vocabulary quotient is empty
for hard edits and should be re-measured under a non-idempotent vocabulary rather than dropped;
probe 3's amortization arm was never measured; and whether the compiled machinery buys anything on
probe 6's outcome table — probe 1's signature construction transposed onto the hypothesis index —
is unmeasured.

The two Ergodis-core defects this task raised are repaired in
`2026-09-04-c1062-core-certificate-policy-repair.md` (core `6cc9668`). One item remains for C1017:
the deferred-verification artifact carries no unverified marker.

The manuscript-facing rule stands: no paper, mirror, or public-surface change came out of this
task, and any application framing must cite Rafieioskouei and Bonakdarpour (IEEE TCAD 2024, with
2025 and 2026 follow-ups) and Tanhaei's C-ADL (*Journal of Systems and Software*, 2026), which
already occupy the root-cause-analysis territory.
