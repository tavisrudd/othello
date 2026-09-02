# Ergodis roadmap versus the external SOTA benchmark memo

**Lane**: `complete-ports` — the memo is about the Ergodis crate, its evolve layer, and its
benchmark story, all of which that lane owns.
**Date**: 2026-09-02
**Status**: review only. No task IDs allocated, no computation launched, no literature searched.
The external memo (`notes/2026-09-02-ergodis-external-sota-benchmark-memo-input.md`) is a
ChatGPT product whose claims about outside systems are unverified; every such claim below is
marked as needing a check before it can support a decision.

Abbreviations expanded on first use: SOTA = state of the art; CP-SAT = the constraint-programming
Boolean satisfiability solver in Google OR-Tools; MILP = mixed-integer linear programming;
ZDD = zero-suppressed binary decision diagram; qLDPC = quantum low-density parity-check;
VeriPB = the pseudo-Boolean proof-logging system of Bogaerts, Gocht, McCreesh and Nordström;
MAP-Elites = the multi-dimensional archive of phenotypic elites algorithm; ILP (in the evolve
context) = inductive logic programming; PSD = positive semidefinite.

---

## 1. Coverage matrix

| Memo item | Status in our records | Supporting note or task | Does the memo's framing add anything? |
|---|---|---|---|
| AlphaEvolve problem repository (67 problems) as a benchmark suite | NEW | AlphaEvolve appears in `2026-08-30-c985-ergodis-evolve-sota-literature-audit.md` and `2026-09-01-c985-evolve-sota-synthesis-lineages.md` only as an architecture to import from, never as a benchmark corpus | Yes, and this is the memo's single best contribution: we have treated AlphaEvolve as a design source and never as a public problem set we could run against. The 67-problem repository's existence is unverified and must be confirmed first. |
| FunSearch cap sets and admissible sets as a discovery benchmark | NEW for Ergodis; the cap-set *game* is a separate repository programme | `2026-07-04-capset-game-theorem.md` and the cap lane are about a different object (a combinatorial game on projective planes), not the FunSearch extremal cap-set construction | Partly. Scoring discovery probability under equal evaluator budgets is a genuinely new measurement axis for us; the "512-cap in dimension 8, 4 of 140 runs" figure is unverified. |
| MiniZinc Challenge structural instances, curated subset | NEW | The only MiniZinc mention in the record is a scope disclaimer in the optimization manuscript ("not a general replacement for OR-Tools, MiniZinc, Gurobi, CPLEX, SCIP"), quoted in `2026-08-29-c998-ergodis-partition-design.md` | Yes. A predeclared classifier for "Ergodis-shaped" instances plus running every qualifying instance including losses is a stronger protocol than anything we have written down, and it operationalizes a disclaimer we currently only assert. |
| Hadamard order 668 as a clean-room retro-solve benchmark with a known answer | NEW, as a benchmark; REJECTED only as a showcase | `2026-09-01-c985-evolve-sota-synthesis.md` §1.1 records existence at 668 settled on 2026-08-12; `2026-08-29-ergodis-portfolio-leverage-synthesis.md` §D.1 withdrew it as a showcase; `2026-08-31-ergodis-target-portfolio.md` §3 records the ownership exclusion | Yes. Read as a retro-solve with ground truth against published structure-aware routes, not a trophy, it is a clean external benchmark; see §2.1. |
| Magma exhaustive solving of quadratic systems over the two-element field as an adversarial control | NEW | Magma appears in the record only as a commercial competitor for minimum-distance computation (`2026-09-01-c985-evolve-sota-synthesis.md` §3.8), never as a negative control | Yes. The "publish the phase transition where we lose" idea is new to us and cheap; the claimed two-orders-of-magnitude enumeration advantage is unverified. |
| ZDD family-enumeration comparison | PARTIAL | The crate has a `zdd` module, and `2026-08-30-c1017-ergodis-core-performance-contract-remediation.md` treats it as a performance-remediation target; `2026-08-31-ergodis-instrument-test-targets.md` §4.2 records plainly that no ranked target makes it load-bearing and it may be speculative | Yes. This is the first concrete proposal that would make the ZDD module load-bearing, and it answers an open question we had already flagged as unresolved. |
| Formal Conjectures corpus and Lean export of a certificate | PLANNED, as the Lean checker rather than the corpus | `2026-08-29-ergodis-portfolio-leverage-synthesis.md` §A.4 queues a Lean-verified checker for the polynomial-time-checkable parts of a certificate, gated on the certificate formats freezing | Partly. Our plan verifies the *checker*; the memo proposes exporting a discovered finite lemma as a Lean proposition. The pipeline direction is new; Formal Conjectures itself (2,615 statements, 1,029 open) is unverified and is a corpus we have no use for. |
| Islands and explicit novelty niches over typed semantic signatures | PLANNED with existing work landed | `2026-08-30-c985-ergodis-evolve-sota-literature-audit.md` P1 records that the semantic-niche substrate has landed and that independent operator-prior islands with measured migration remain open; `2026-09-01-c985-evolve-sota-synthesis-lineages.md` item 9 specifies MAP-Elites descriptor axes | No. We have this ranked, sized, and partly built, with a stated gate (measure niche use before adding islands) that the memo does not have. |
| Curriculum design: a sealed predicate becomes a primitive for the next generation | PLANNED and partly landed | The theorem dependency graph in `2026-08-30-c985-ergodis-evolve-sota-literature-audit.md` P1 already composes type-compatible sealed nodes under an exact rule with cross-campaign replay | No, except as a framing. The memo's "ask for strictly stronger or orthogonal structure" is close to the Dalmatian acceptance filter we already ranked third in the first import batch. |
| Coordinate invention from raw masks or group elements | PLANNED, with the exact gap already named | `2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`: the blind harness recovered an exact candidate on all fourteen corpora, but the report states explicitly that this does not establish rediscovery from raw orbit masks, and specifies the next adapter (two opaque scalar observations per coordinate, one theorem-agnostic expander) | No. We hold a sharper version of this than the memo, including an explicit statement of what the current result does not show. |
| Cross-instance transfer (discover at one size, evaluate unchanged at another) | PARTIAL | `2026-09-01-c985-evolve-proposal-admission-architecture.md` requires separately fingerprinted training and verification contexts and a held-out direct-model replay; expected cross-instance reuse is already a term in the proposer-selection value estimate | Partly. We have the mechanism and the scoring term but no benchmark that makes unseen-size transfer the reported number. That is a cheap addition. |
| Theorem-gap benchmark: several observationally perfect predicates, one sound | NEW, and it is the memo's second real contribution | Nothing in the record constructs a corpus that punishes unsound pruning; the closest is the acceptance test in the SOTA audit for a deliberately-too-strong intended theorem | Yes. This directly measures the property the whole admission architecture exists to guarantee, and we currently assert that property rather than measure it. |
| Composition discovery: two or three sealed features compose into an exact reduction | PARTIAL | The bounded OR-composition theorem graph has landed with exact domain equality and marginal-coverage premise ranking (`2026-08-30-c985-ergodis-evolve-sota-literature-audit.md` P1) | Partly. We built the mechanism; we have never run a task that is infeasible without composition. Turning that into a planted benchmark is a small addition to work already done. |
| A public Ergodis StructureBench with 40–60 problems, mandatory metadata, and three tiers | NEW as a public suite; PARTIAL as measurement | `papers/complete-repair-ports/ergodis/BENCHMARKS.md` already reports paired controls, fresh-process protocol, high-water resident set size, and an external-validity run over all 169 entries of the MATA TACAS'24 Presburger list | Yes for the tier structure, especially the negative tier. The per-row metadata the memo asks for is largely what our benchmark document already records; what is missing is a single suite with a declared negative tier and a public home. |

## 2. Corrections

**2.1 Hadamard order 668: void as a trophy, valid as a clean-room retro-solve.** The first
reading of the memo's fourth item, a public campaign to find an order-668 matrix, is closed:
existence at order 668 was announced on 2026-08-12 by Alpöge, Reynolds-Haertle and Voinov,
together with the other eleven previously open orders below 2000, and confirmed through three
independent sources (`2026-09-01-c985-evolve-sota-synthesis.md` §1.1); the leverage synthesis
withdrew 668 as a showcase on that basis (`2026-08-29-ergodis-portfolio-leverage-synthesis.md`
§D.1). The memo's actual proposal survives that fact and is improved by it: port one or more of
the published structure-aware routes (structured satisfiability over Goethals–Seidel and
supplementary-difference-set carriers with canonicalization under rotations, reflections and
multipliers, row-sum families and autocorrelation verification; and the spectral-sieve plus
meet-in-the-middle autocorrelation framework), run Ergodis on the identical finite search with
the published answer as ground truth, and compare compile and solve cost, certificate size, and
replay cost against an implementation that is already structure-aware rather than naive
satisfiability. A known answer makes the benchmark clean: the question is not whether a matrix
exists but how much of the published search each system removes exactly. The live private
work at order 2092 is separately reframed as class exclusion, a certified "no bordered
Goethals–Seidel array with four circulant blocks of the given carrier under the given multiplier
subgroup", because construction races are no longer available. The only remaining obstacle is
ownership: the target portfolio excludes Hadamard-, Legendre-pair- and conference-matrix-adjacent
targets as owned by another agent (`2026-08-31-ergodis-target-portfolio.md` §3). That is a
scope rule Tavis can lift for a benchmark task, and this review recommends lifting it for the
retro-solve only, not for construction work.

**2.2 The memo's framing of Evolve as a discovery engine understates the admission boundary.**
The memo asks whether Evolve can "rediscover the useful reflection/residue structure blind" and
scores discovery probability. Our architecture is explicit that no proposer has proof authority:
a proposal cannot prune, merge states, reduce anchors, or support a certificate until its
family-specific admission contract passes, and there is deliberately no generic "verified" bit
(`2026-09-01-c985-evolve-proposal-admission-architecture.md`, Decision and Safeguards). Any
benchmark we adopt must report admitted artifacts and exact search work removed alongside
discovery probability, or it will measure the wrong thing.

**2.3 "Proof of exhaustiveness over the compiled search space" is a stronger claim than we can
currently make externally.** The memo's proposed headline for the AlphaEvolve subset is
objective plus exhaustiveness proof. Our certificate prior-art assessment
(`2026-08-29-ergodis-certificate-prior-art-veripb.md` §5.1) finds every individual component of
the certificate bundle anticipated — per-pair separating words by Smetsers–Moerman–Jansen and
Kupferman–Lavee–Sickert, certified symmetry breaking and orbit-style reasoning by the VeriPB
ecosystem — with only the integrated pipeline unoccupied. Externally facing exhaustiveness
language therefore needs the standard trust-tier wording (enumeration by one implementation,
witness replayed by a second) that the portfolio requires travel verbatim with every entry
(`2026-08-31-ergodis-target-portfolio.md` §1, target 1).

**2.4 The memo does not know which problems we have already ruled out.** The target portfolio's
list of problems not to point Ergodis at (§3) excludes, with reasons, the cap game on odd
projective planes (the bottleneck is a proof object, not a search), complete arcs of square-root
size, Latin-square transversals, the rank of three-by-three matrix multiplication over the
two-element field, mutually unbiased bases and symmetric informationally-complete measurements,
and the whole Hadamard-adjacent family. Any FunSearch- or AlphaEvolve-derived shopping list must
be filtered against that section before a task is written, or we will re-derive rejections.

**2.5 Correcting one framing in our own favour: our nearest true competitor is not AlphaEvolve.**
The memo studies AlphaEvolve and FunSearch as the systems to beat. The lineages report identifies
automatic dominance breaking (Lee and Zhong) as the one system producing the same product —
sound, automatically generated pruning constraints — with soundness by construction rather than
by corpus, and VeriPB proof logging as the natural externally checkable output format
(`2026-09-01-c985-evolve-sota-synthesis-lineages.md`, Direct competitors). Any benchmark write-up
must position against those two, which the memo never mentions.

## 3. Recommended roadmap updates

**Add: a negative-control benchmark tier.** Expected artifact: a section of
`papers/complete-repair-ports/ergodis/BENCHMARKS.md` reporting instances where Ergodis loses,
with the structural reason stated. Control: whichever incumbent wins that shape — CP-SAT for
unstructured constraint instances, Magma's enumeration for dense quadratic systems over the
two-element field, a ZDD library for family enumeration. Acceptance gate: the boundary is
predeclared before running, and at least one predicted loss and one predicted win land on the
predicted side. This is the memo's most persuasive idea and it costs little, because our
benchmark protocol (fresh process per sample, seven paired rounds, rotated order, high-water
resident set size) already produces the required rows.

**Add: a theorem-gap corpus for the evolve admission path.** Expected artifact: a planted corpus
on which several predicates are observationally perfect and exactly one corresponds to a valid
reduction. Control: the same corpus run with admission disabled, so that the unsound predicates
are shown to be admitted without it. Acceptance gate: admission rejects every observationally
perfect but unsound predicate with a compact counterexample, and admits the sound one. This turns
the central safeguard from an assertion into a measurement.

**Re-rank upward: the ZDD comparison.** Our own record calls the ZDD module speculative for want
of a load-bearing target. A minimal-support and reliability-counting comparison against a modern
ZDD library, reporting compressed representation size as well as runtime, either justifies the
module or retires it. Acceptance gate: a decision either way, recorded, rather than a benchmark
row.

**Option only, not on the roadmap (Tavis, 2026-09-02): the order-668 clean-room retro-solve.** Priority goes to the external benchmark suites (AlphaEvolve subset, FunSearch cap and admissible sets, curated MiniZinc, Magma, ZDD) and to iterating on Evolve's capabilities; revisit 668 only after those. Expected artifact:
one published route reimplemented as a control, the same finite search compiled by Ergodis, and
a benchmark row reporting exact work removed, certificate bytes, and replay cost with the
published matrix as ground truth. Control: the published structure-aware implementation.
Acceptance gate: both sides reach the known answer on the identical search domain, the Ergodis
certificate replays independently, and the row states which search stages Ergodis compiled away.
Not a construction campaign; see §2.1.

**Leave as is: the evolve engine import batch.** The first four imports — failure-derived
generalisation and specialisation constraints from Popper, a subexpression value bank with
observational equivalence from bottom-up syntax-guided synthesis, the Dalmatian acceptance
filter, and a Pareto front over coverage and evaluation cost at zero false positives — are each
at most half a day, independent, and leave exact semantics untouched
(`2026-09-01-c985-evolve-sota-synthesis-lineages.md`, Where to take evolve). Nothing in the memo
displaces them, and its islands and curriculum suggestions are downstream of them.

**Leave as is: the qLDPC exact-distance line and the open QDistSAT instances.** These remain the
highest-value external contact we have, because an incumbent has published a list of instances it
cannot finish and we have already finished one, and because published distance tables say "upper
bound" in their own captions. No external benchmark suite improves on that.

**Investigate before committing: the AlphaEvolve problem repository.** Confirm the repository
exists, is licensed for use, and contains evaluators with the claimed structure. If it does, a
subset of eight to fifteen finite-field and combinatorial problems is the best public benchmark
proposal on the table. If it does not, the item disappears, so verification precedes allocation.

## 4. Two candidate tasks to start immediately

Neither allocates an identifier; both are sized to one or two sessions and use tooling that
already exists — the Ergodis crate, the evolve admission architecture, and the retained-binary
A/B tooling from the build-artifact hygiene work.

**Negative-control benchmark tier for the Ergodis benchmark document** (lane: `complete-ports`).
Goal: replace the assertion that Ergodis is not a general constraint-programming replacement with
a measured boundary. That boundary is current positioning, not a ceiling: every predicted or
measured loss is a candidate for absorption, as the ZDD and BP-OSD imports already were. Inputs: the existing six application scenarios and their controls in
`papers/complete-repair-ports/ergodis/BENCHMARKS.md`; the corrected paired-round protocol already
documented there; the retained-binary A/B tooling. Deliverables: a predeclared one-page
classifier saying which instance shapes Ergodis claims (repeated interfaces, linear conservation,
group symmetry, finite-field labels, decomposable minimum-sum states, reconstructible blocks) and
which it does not; a new benchmark section with at least three instances predicted to lose and
three predicted to win, each run against the matching incumbent control, reporting runtime,
high-water resident set size, and where applicable compiled representation size; and the
prediction recorded before the measurements. Gates: the classifier is committed before any run;
every row is reproduced by the documented replay command; at least one predicted loss and one
predicted win land as predicted, and any misprediction is reported rather than removed. It must
not claim a general solver comparison, a win on any instance outside the declared shapes, or that
the classifier is complete.

**Theorem-gap corpus and admission measurement for evolve** (lane: `complete-ports`). Goal:
measure, rather than assert, that the admission boundary refuses unsound pruning that is perfect
on the corpus. Inputs: the blind evolve harness and the fourteen opaque corpora described in
`2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`; the proposal and admission lifecycle
in `2026-09-01-c985-evolve-proposal-admission-architecture.md`; the existing counterexample
replay and failure-core machinery. Deliverables: one planted corpus family in which at least
three typed predicates have zero false positives on the training view and exactly one is a valid
reduction on the held-out direct model; a run showing which predicates evolve proposes and which
admission accepts; a compact counterexample recorded for each rejection; and a short report
stating the exact searched domain and the corpus construction, so the negative is falsifiable.
Gates: the sound predicate is admitted, every unsound one is rejected with a replayable
counterexample, the run is deterministic across two invocations, and the training and
verification views are separately fingerprinted. It must not claim that admission is sound in
general, that the result transfers to unplanted corpora, or that evolve discovered mathematics —
the planted corpus is a test of the boundary, not of discovery.

## 5. Future work, grouped by the memo's four buckets

**Program-evolution discovery.**
- Confirm the AlphaEvolve problem repository exists and is usable, then select eight to fifteen finite-field and combinatorial problems.
- Score blind discovery probability under equal evaluator budgets on a FunSearch-shaped construction task.
- Add cross-instance transfer as a reported number: discover at one size, evaluate unchanged at unseen sizes.
- Add a composition-discovery benchmark in which no single shallow predicate suffices and two or three sealed features must compose.
- Add independent operator-prior islands with measured migration, once niche use is measured.
- Implement the remaining evolve imports in the ranked batch, ending with proof-log output for banked theorems.

**Formal theorem proving.**
- Export one Ergodis-discovered finite lemma plus its certificate as a Lean proposition and check it.
- Build the Lean-verified checker for the polynomial-time-checkable certificate parts, once formats freeze.
- Do not pursue Formal Conjectures as a benchmark corpus; it measures general automated theorem proving, which is not our claim.

**Exact combinatorial solvers.**
- Curate a MiniZinc Challenge subset against a predeclared "Ergodis-shaped" classifier and run every qualifying instance, losses included.
- Add Magma's exhaustive quadratic-system solving over the two-element field as a negative control and publish the phase transition.
- Keep closing the open QDistSAT instances and certifying estimated bivariate-bicycle table entries; these outrank every item above.
- Position any write-up against automatic dominance breaking and VeriPB proof logging, not against AlphaEvolve.

**Symbolic finite-structure systems.**
- Benchmark minimal-support and reliability-counting families against a modern ZDD library, reporting compressed size, and decide the ZDD module's fate.
- Assemble a public benchmark suite with the three tiers — known quotient, hidden structure, and negative control — reusing the existing benchmark metadata and the MATA external-validity run.
- Order-668 clean-room retro-solve against a published structure-aware route, with the known matrix as ground truth; needs the Hadamard ownership exclusion lifted for benchmark use (§2.1, §3).

## 6. Trust boundary

Every external claim in the memo under review is unverified here, and several are stale, most
importantly the Hadamard order 668 framing. All statuses above come from the repository's own
notes as cited; no literature was searched and no computation was run for this review. The
coverage matrix's "NEW" entries mean "absent from the notes read for this review", not "absent
from the repository" and certainly not "novel in the field". Rankings and recommendations are one
session's judgement.

## 7. Scope framing (Tavis, 2026-09-02)

"Ergodis is not a general-purpose constraint solver" is today's positioning, not a permanent
limit. The aim is the fastest and best tool for the problems we target, and that aim has already
absorbed and improved functionality the framing would exclude (ZDD family enumeration, BP-OSD).
Classifiers and negative-control tiers are predictions for a run, not product boundaries; a loss
is recorded as an absorption target, never as confirmation of a box.

