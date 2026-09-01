# C985 — Ergodis evolve-system SOTA audit and implementation priorities

**Lane:** `complete-ports`  
**Date:** 2026-08-30  
**Implementation status refreshed:** 2026-09-01
**Scope:** optional theorem-discovery/campaign layer, not solver authority

## Verdict

Ergodis is not yet competitive with the leading evolutionary coding systems as
an autonomous proposal engine: it still lacks broad proposal generation,
independent islands, profile-driven target graphs, and a learned policy.  Since
the original audit, however, the deterministic P0 selector and bounded P1
substrate have landed: impact/cost scorecards, exploration-floor allocation,
semantic niches, resumable elite mutation, exact hindsight fragments,
type-compatible theorem-DAG composition, mandatory cross-campaign replay, and
explicit frozen-field error strata.  Root/debt/exceptional-state target graphs
and broad proposal generation remain open.

It is already stronger than those systems in a different and important layer:
the exact experimental substrate. Candidate plans are typed and compiled,
finite evaluations are exact, outcome equivalence is hashed, counterexamples
are replayable, evidence is bounded and streamed, live solver steering is
optional, and diagnostic/ordering evidence is prevented from masquerading as
proof. The solver hot path can remain allocation-free and effectively unaware
of the campaign layer.

The best strategy is therefore not to reproduce AlphaEvolve around arbitrary
source programs. It is to import the strongest search-control mechanisms while
retaining Ergodis's smaller typed genome and exact semantic boundary:

```text
typed theorem/attack plan
  -> exact staged evaluation
  -> semantic + behavioural archive
  -> max-oriented target selection
  -> counterexample/hindsight refinement
  -> replay or proof extraction
```

This makes Ergodis a complementary system: less general as a source-code
generator, more rigorous and potentially far more sample-efficient when a
problem has already been compiled into exact finite observables.

## Comparison with the strongest relevant systems

| Capability | Relevant SOTA | Ergodis now | Consequence |
|---|---|---|---|
| Proposal breadth | AlphaEvolve evolves whole files with an LLM ensemble; CodeEvolve adds inspirations, meta-prompts, and depth refinement | bounded hand-written mutations over a typed VM | large autonomy gap, but a much smaller and safer search space |
| Diversity | AlphaEvolve uses MAP-Elites/islands; open CodeEvolve uses CVT-MAP-Elites, islands, and migration | exact outcome classes plus failure/operator/cost niches and bounded resumable elites | add genuinely independent operator-prior islands only after measured niche use |
| Evaluation economy | AlphaEvolve uses cascades and parallel evaluators | exact monotone cascade, failure targeting, bitmap premise screening, and bounded full replay | add operational shadow stages and profile-directed batches |
| Target selection | TTT-Discover uses maximum-oriented PUCT; runtime CodeEvolve profiles weighted component graphs | deterministic best-impact-per-cost heap plus a live bounded target graph, one-slot exploration floor, evidenced refresh, explicit non-pruning numeric/structural mutation routing, and exact source-target attribution | add a bounded target-local learner that abstains when theorem-derived repair already dominates |
| Learning from a campaign | TTT-Discover updates the model at test time; HTPS trains online from proof search | no learned proposal policy | defer weight updates until exact archives and rewards are calibrated |
| Learning from failure | Minimo hindsight-relabels failed proof trees into achieved theorems and proofs | typed proper subexpressions are retained only after zero-false-positive replay, with explicit no-authority obligations | extend from frozen feature rows to intermediate solver states and proof handles |
| Cumulative theory | Minimo identifies lemma accumulation and premise selection as necessary for depth | bounded OR-composition DAG, exact domain equality, marginal-coverage/cost premise rank, and cross-campaign replay | extend obligations to solver states and import kernel proof handles |
| Trace diagnosis | EvoTrace/EvoReplay retain source, lineage, prompts, evaluation metadata, replay interventions, and cycling tests | bounded event ledger and streamed trials, but incomplete lineage/replay schema and no cycling diagnostic | make every candidate replayable and detect equivalent reversions before evaluation |
| Runtime focus | runtime CodeEvolve selects profiled hot components and prunes context | campaign-local measured profiles can be refreshed without authority; the first private alignment watcher now publishes exact root strata and observed cost | measure held-out utility, then add debt/exceptional-state publishers only where counters already exist |
| Exactness boundary | most systems rely on task evaluators and may overfit them | explicit `proof_authority: false`, hostile replay, exact witnesses/counterexamples | retain this as the non-negotiable architectural edge |

AlphaEvolve's published ablations support evolution, rich context, meta-prompt
evolution, full-file evolution, and mixed model capability as jointly useful.
Its evaluator cascade, multiple metrics, asynchronous throughput pipeline, and
MAP-Elites/island database are the directly reusable architectural pieces.[1]
The mathematical follow-up reports that search heuristics, rather than direct
objects, are often the right genome; it also emphasizes expert intervention,
families of correlated instances, continuous score shaping, and a separate
generalizer mode.[2]

The open CodeEvolve study provides the cleanest reproducible search baseline:
island evolution, CVT-MAP-Elites, inspiration-based crossover, lineage-local
depth refinement, meta-prompt exploration, and plateau-triggered exploration.
Its controlled comparison reports leading results on six of nine tasks against
OpenEvolve and ShinkaEvolve under matched conditions, while its ablations say
the interaction of components matters more than one operator alone.[3]

TTT-Discover sharpens the objective. Discovery needs one exceptional state,
not high mean reward. It therefore uses an entropic, maximum-seeking objective
and PUCT whose exploitation term is the best descendant reward, not the mean,
while preserving exploration through visit counts. Its matched baselines use
the same model and 25,600-sample budget.[4] Ergodis should import the selection
principle before considering test-time weight updates: its exact campaign
archive already supplies better-calibrated values than a generic reward model.

Minimo and HTPS supply the theorem-side bridge. Minimo generates well-typed
conjectures by construction and converts otherwise failed proof searches into
new true statements and proof data by hindsight relabeling.[5] HTPS treats a
proof as an AND/OR hypergraph, selects whole partial proof hypertrees, batches
leaf expansion, and trains online from minimal proof trees and critic states.[6]
For Ergodis, failed attack plans should similarly yield achieved subrelations,
minimal obstruction predicates, and candidate intermediate lemmas rather than
only a negative score.

Two 2026 diagnostics change the implementation order. Runtime CodeEvolve uses
measured time/frequency on a component graph to select writable targets and
then applies a validation cascade; it reports 15.22x average speedup across
seven selected Java hotspots, though this is an enterprise case study rather
than a matched general benchmark.[7] EvoTrace finds that roughly 30% of added
lines in its traces reintroduce previously deleted lines, that best lineages
are short, and that late mathematical gains are often recoverable by a small
Bayesian hyperparameter sweep.[8] Ergodis should therefore add replay/cycling
diagnostics and route numeric tuning to a cheap specialist instead of spending
general evolution budget on it.

## Highest-value implementation order

### P0 — persistent replayable search graph and anti-cycling

Persist a compact candidate record:

```text
candidate hash, semantic hash, parent hashes, operator,
generation/island, exact score vector, presentation hash,
first obstruction, evaluation stages passed, artifact path
```

The semantic hash is the lowered plan plus scope; the outcome hash is behaviour
on the frozen corpus. Reject exact structural repeats before compilation and
skip already-known outcome classes unless they enter a new behavioural niche.
Record add/drop operator inverses so a short cycle is detectable without
retaining full text. This directly attacks the EvoTrace pathology while making
campaign replay and cross-run persistence possible.

**First slice landed.** Daemon evolution records the stable compiled hash of
each parent, a typed mutation-operator label, the child plan and compiled hash,
exact evaluation, and outcome-equivalence link in every streamed trial.
Structural repeats are rejected before compilation/evaluation, and only the
best-ranked representative of an exact outcome class is expanded in a
generation. Summary counters expose structural and outcome-expansion
rejections. Durable restore across campaigns and inverse-edit fingerprints
remain open.

### P0 — exact evaluator cascade

Use lexicographic stages:

1. permanent counterexamples and corruptions;
2. tiny exhaustive strata;
3. training corpus;
4. hostile held-out strata;
5. bounded shadow probes with states/instructions/theorem-cost counters;
6. full exact replay or certificate gate.

Every stage has a declared row/work/byte budget. Unsound candidates stop
immediately. Diagnostic and ordering candidates use paired operational races;
no noisy runtime score can grant proof authority.

**First slice landed.** Frozen-batch evolution now evaluates in fixed 64-row
blocks. Once the current beam is full, a candidate stops only when its observed
false-positive count and the optimistic assumption that every unseen row is
correct still cannot match the beam's worst exact survivor. Thus rejection is a
proof from monotone partial counts, not a sampling heuristic. Rejected trials
remain in streamed evidence with lineage, compiled hash, and rows examined;
summary counters report rejected candidates and total rows evaluated. A
128-row planted control verifies both early stopping and preservation of the
perfect survivor. Multiple semantic strata and operational shadow stages remain
open.

### P0 — maximum-oriented target selection — landed

Status 2026-09-01: exact parent-relative impact/cost scorecards feed a
deterministic diminishing-return max-heap.  Every parent receives one
exploration slot; no-signal campaigns retain balanced allocation.  Paired
gain/cost extrema, overflow-free rational comparison, and synthetic
cost-asymmetry/no-starvation controls close this item.

The landed selector replaces static beam truncation with the following
deterministic PUCT-like order over candidate/root pairs:

```text
best descendant impact
+ prior from semantic rank / exact margin
+ exploration bonus from visits and uncertainty
- theorem evaluation cost
```

The primary value is exceptional descendant states or instructions avoided,
not mean predicate accuracy.  The current implementation deliberately needs no
neural model: persistent scorecards and exact reliability statistics supply the
signal.

### P1 — semantic islands and quality-diversity niches — niche substrate landed

Status 2026-09-01: failure class, operator family, and logarithmic evaluation
cost define bounded semantic niches; exact output remains an independent
class.  Fresh niche elites precede global fill, while resumable mutation
cursors let retained parents consume only untried offspring.  Independent
operator-prior populations and measured migration remain open.

Use a small fixed island count with different operator priors: obstruction
repair, scope mutation, expression structure, theorem-kernel composition, and
numeric tuning. Define niches from semantics rather than code shape:

- false-positive and false-negative profile;
- exact output class;
- root/field/rank scope;
- primitive/kernel family;
- proof/certificate footprint;
- operational cost bucket.

Migration should copy compact elites, not mutable shared state. A global
append-only counterexample set is shared by every island.

### P1 — exact hindsight and theorem accumulation — first DAG landed

Status 2026-09-01: typed proper Boolean subexpressions with positive coverage
and zero frozen-batch false positives enter a bounded, explicitly untrusted
ledger.  Compatible nodes compose under the exact OR rule after adaptive
coverage screening and full replay.  Archives persist and revalidate the DAG
across compatible campaigns.  Exact domain equality and marginal
counterexample-separation per semantic cost now rank premise pairs.
Solver-state invariants, richer partial domain overlap, and kernel proof handles
remain open.

When a candidate fails, inspect its opcode trace and the exact search states it
did settle. Extract:

- the longest sound prefix;
- subexpressions with zero false positives;
- smallest counterexample-separating predicates;
- intermediate invariants true on all reached children;
- proof/certificate handles already produced by kernels.

Store these in a theorem dependency DAG with domains and replay obligations.
Candidate generation may compose only type-compatible nodes. Premise selection
uses observed utility, domain overlap, and cost; it does not make a theorem
trusted.

### P1 — profile-driven campaign targeting

The bounded static stratum is landed: up to four explicitly named frozen-batch
fields can partition semantic niches by their exact tuple on the candidate's
first mismatching row, while row weights retain global impact priority. Tuples
are interned once per row into compact class IDs and the daemon persists a
bounded selected-class histogram with exact values. This directly supports
precomputed combinations of root, debt, rank, and exceptional-state classes,
and a strict bounded profile can now attach measured mass/unit cost and
dependency/continuation edges. Its cycle-safe transitive closure sums reachable
work once and guides only surplus expansion quota after the one-slot
exploration floor. Semantic evaluation and authority do not consume profile
weights. The generic watcher-side accumulator is now landed:
campaign-local absolute observations and edges canonicalize independently of
message order, snapshot directly into `evolve-start`, and persist the complete
profile plus verified hash in evidence. Thus private/application producers no
longer need to build a temporary graph file; they only need to publish their
domain counters. An explicit `evolve-profile-refresh` now coalesces the newest
snapshot into a one-slot job mailbox. At the next generation boundary the
worker validates it against the frozen batch and streams the full profile and
hash before changing expansion priority. Cancellation and evidence exhaustion
stop before application, and the footer reports the exact refresh count. Each
node can now select balanced, numeric-first, or structural-first mutation
order. Failure-derived thresholds remain first, every strategy reaches the same
finite candidate set, and changed routes selectively reset stale continuation
cursors. Thus the profile can route proposal effort without gaining pruning or
proof authority.

Root progress is connected; debt ledgers, exceptional-state counts, and perf
counters remain application-publisher frontiers. A child now carries its
source target class into evidence, including when it repairs that target and
has no remaining mismatch, so target-local operator value is attributable
without inference from the child's next failure.

The first operational adapter is now landed privately for alignment search. It
groups the existing coarse heartbeat by exact root orbit, initial packing, and
sizing status, publishes changed absolute root-count/maximum-cost observations,
and selects numeric- or structural-first routing from runtime-configured shape
thresholds. All sampling, aggregation, serialization, and socket work stays in
the auxiliary watcher; the search publication and safe-point paths are
unchanged.

The first application gate is now measured on exact alignment root-cost
corpora. Numeric routing reaches the exact 39/56 observable-interface ceiling
on the development corpus in 32 candidates / 5,376 semantic-op rows versus 49
/ 8,232 balanced, a 1.53x gain. On the separately frozen held-out corpus, every
route reaches its exact 20/35 interface ceiling at candidate 2 / 210 rows
because the counterexample-threshold theorem fires before generic ordering.
Numeric routing is neutral on discovery there and only reduces completed work
and evidence bytes by about 5%. This rejects unconditional routing while
supporting a contextual policy with a built-in-theorem abstention rule.

### P2 — learned proposer or test-time training

The archives and source-target attribution are now sufficient for the first
bounded learner. The useful learned object remains operator-family and target
selection, not arbitrary Rust generation. TTT-style weight adaptation is
expensive and optimizes a less transparent state; an offline contextual bandit
over typed mutations remains the first baseline. It must use exact improvement
per semantic-op row, preserve the one-slot exploration floor and complete
finite mutation set, and abstain whenever the failure-derived repair has
already supplied an improving child for that source target. A frozen replay
must reproduce every policy update and chosen route from the evidence stream.

## Near-term acceptance tests

1. Replaying a campaign from its durable graph produces identical semantic and
   outcome hashes without reevaluating cached nodes.
2. A synthetic add/drop cycle is rejected before VM evaluation.
3. On a frozen campaign, the cascade evaluates fewer full rows while returning
   the same Pareto elites as exhaustive evaluation.
4. PUCT selection beats static beam selection on held-out best-found score at
   equal exact evaluation work, over multiple seeds.
5. Islands retain more semantic outcome classes than one population at equal
   work, without increasing permanent-counterexample failures.
6. A failed search yields at least one independently replayable sublemma in a
   fixture where the intended theorem is deliberately too strong.
7. Profile-driven targeting chooses a planted expensive primitive/root and
   leaves a planted cold target on the cheap path.

## Literature-audit protocol

This is a systems-positioning and import audit, not a novelty or priority
claim. No absence claim is made. Search used arXiv-oriented web discovery and
targeted primary-paper retrieval. The exact new queries were:

```text
site:arxiv.org 2026 automated theorem discovery evolutionary search runtime profile target selection theorem proving
site:arxiv.org 2025 2026 LLM theorem conjecture generation proof search self improvement archive MAP elites
site:arxiv.org 2026 algorithm discovery evolutionary code search successive halving evaluator cascade
arXiv 2605.04677 theorem proving runtime profile weighted component graph MCTS target selection
site:arxiv.org "runtime profile" "target selection" theorem proving 2026
site:arxiv.org "EvoTrace" "EvoReplay" 2605.20086
```

Opening full-text count: **1 of 8** sources was read in full. The other seven
were read at the exact partial depths below. All eight PDFs and extracted texts
are in the shared persistent literature cache.

## Sources and read depth

1. Novikov et al., *AlphaEvolve: A coding agent for scientific and algorithmic
   discovery*, arXiv:2506.13131v1. **Partial:** abstract; Sections 1, 2.1–2.6,
   4, 5, and 6. Cache key `arXiv:2506.13131`, SHA-256
   `f092c8cbd65da89951ee6496374da9a54963f9035758c25ac6e4625f506df9ad`.

2. Georgiev, Gómez-Serrano, Tao, Wagner, *Mathematical Exploration and
   Discovery at Scale*, arXiv:2511.02864v3. **Partial:** abstract; Sections
   1–5, including search mode, generalizer mode, meta-analysis, ablations, and
   future work. Cache key `arXiv:2511.02864`, SHA-256
   `77b43844077c98c26dfc76ad391cadbbd53d48a1d290ddae575ff4d1bcdef9d2`.

3. Assumpção et al., *CodeEvolve: an open-source evolutionary framework for
   algorithmic discovery and optimization*, arXiv:2510.14150v6. **Partial:**
   abstract; Sections 1–5.4. Cache key `arXiv:2510.14150`, SHA-256
   `5ba07cdc336db7052c1ada4849f5d4b9577da6e0621ca61f0300b0a84eea4cf8`.

4. Yuksekgonul et al., *Learning to Discover at Test Time*,
   arXiv:2601.16175v2. **Partial:** abstract; Sections 1–3.3 and 4–4.1.3. Cache
   key `arXiv:2601.16175`, SHA-256
   `4656ec28d800002d9a3e3f83a71c7d9032ef5f1873cd953b8808a8391ce06ec7`.

5. Poesia et al., *Learning Formal Mathematics From Intrinsic Motivation*,
   arXiv:2407.00695v2. **Partial:** abstract; Sections 1–5. Cache key
   `arXiv:2407.00695`, SHA-256
   `1a7d6468b9f6b67a7203a2778067e57a7fd610b2a8738664adffdbc47f43f02f`.

6. Lample et al., *HyperTree Proof Search for Neural Theorem Proving*,
   arXiv:2205.11491v1. **Partial:** abstract; Sections 1–6.3. Cache key
   `arXiv:2205.11491`, SHA-256
   `9deff4b44772a176314016ce0b277cac20649f2ed8784031f34a6b29bb64fa48`.

7. Borra et al., *CodeEvolve: LLM-Driven Evolutionary Optimization with
   Runtime-Enriched Target Selection for Multi-Language Code Enhancement*,
   arXiv:2605.04677v1. **Full text.** Cache key `arXiv:2605.04677`, SHA-256
   `56f7427dc9ed8488c5ca781fe4d53a58f3265134f92c190b114e017384e71026`.

8. Pelleriti et al., *What Do Evolutionary Coding Agents Evolve?*,
   arXiv:2605.20086v1. **Partial:** abstract; Sections 1–6. Cache key
   `arXiv:2605.20086`, SHA-256
   `b8f592bd68429b4c5f7cee2878a316941acf3cdf80215a0d78c08c25a73722f3`.

The audit did not attempt MathSciNet, zbMATH, Google Scholar, or exhaustive
forward-citation coverage because it makes no novelty-negative claim. Those
channels would be required before asserting priority for a new search method.
