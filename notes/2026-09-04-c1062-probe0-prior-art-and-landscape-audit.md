# C1062 probe 0: prior-art and landscape audit

**Lane**: `complete-ports`
**Task**: C1062 probe 0 — bounded prior-art and landscape audit for the structural-causal-model
(SCM) spike in Ergodis.
**Brief**: `2026-09-04-c1062-ergodis-causal-brief.md`
**Routing document**: `2026-09-04-c1062-exploration-log.md` (§ "Probe 0" is this probe's spec)
**Conventions**: `notes/literature-audit-conventions.md`
**Date of searches**: 2026-09-04

## Opening summary and read-depth accounting

Verdicts in short:

- **Q1 — a mature engine exists, in fact three lineages of them.** The brief's expectation that
  "no mature fast engine exists" is **false**. HP2SAT (Ibrahim, Rehwald & Pretschner 2019), the
  MaxSAT/ILP successor (Ibrahim & Pretschner, ATVA 2020), and an Answer Set Programming engine
  (Özcan, Alrajeh & Craven, KR 2025) all check Halpern–Pearl actual causality under the **modified**
  definition on acyclic **binary** models at thousands of variables. The narrowed claim written in
  advance by the brief — "a compiled, certificate-carrying engine versus a per-query SAT or ILP
  encoding" — **survives**, but three of its four differentiators must be renamed, and one of them
  (raw speed) must be dropped.
- **Q2 — the compiled object is partly published and partly not.** The full-observation quotient
  **is** Balke and Pearl's 1994 response-function partition; this is confirmed at the level of the
  original text, and the construction is credited there to Pearl 1993. The *algorithm* — coarsest
  quotient of a finite SCM's exogenous space under indistinguishability by every admissible
  intervention, computed by partition refinement, emitting a separating intervention as the
  refutation witness for each separated pair — was **not located** in any index. The bisimulation
  intersection the reviewer flagged is **partly occupied**: "bisimulation under intervention" is a
  published notion (Chakraborty, Caulfield & Pym), with a Hennessy–Milner correspondence but no
  minimisation algorithm and no quotient computation. A partition-refinement algorithm over a
  *variable*-partition lattice with interventional coarsenings does exist (Madaleno, Misra & Markham,
  "Coarsening Causal DAG Models"), and is the nearest published neighbour to probe 7.
- **Q3 — the responsibility formula the plan needs is `1/(|X| + |W|)`.** Under the modified
  Halpern–Pearl definition the denominator counts **both** the size of the cause `X` (our `X'`) and
  the size of the contingency set `W`, minimised jointly. The brief's `1/(k + 1)` is the original
  Chockler–Halpern 2004 formula, and in that formula `k` is *not* `|W|` — it is the number of
  variables in `W` whose value in `w` differs from their actual value in the context. Under the
  modified definition no `W` variable ever differs from its actual value, so the 2004 counting
  degenerates to zero and cannot be transplanted.

**Read depths.** Thirty-six sources are named below. **Zero were read at full text.** Sixteen are
`partial` (the sections named in each entry, from a PDF or HTML page fetched and extracted locally);
sixteen are `abstract/metadata only`; three are named as background only and were not accessed at all
(Pearl 1993a, Kanellakis–Smolka, Paige–Tarjan), with no verdict resting on their content; and one is
**could not access** — Halpern's *Actual Causality*, MIT Press 2016, chapter 6, the primary reference
Q3 asks for. One source (Rubenstein et al. 2017) additionally carries a `secondary only`
characterisation through Beckers & Halpern 2019. One screened set of 28 DBLP records is recorded in
Q1.5 with its provenance, fields and discriminator; "screened" is not a read depth.

The Q3 formula therefore rests on three independent restatements of the book's definition rather than
on the book, and that gap is carried forward explicitly in § Coverage.

All fetched PDFs were added to the shared literature cache at `/tmp/persistent/tavis/lit-search/`
with the keys and SHA-256 values recorded per source below.

---

## Q1 — engines for Halpern–Pearl actual causality

### Q1.1 HP2SAT (Ibrahim, Rehwald & Pretschner 2019)

**Exists, unmaintained, modified definition, binary only, computes minimal `W`.**

- **Source**: "Efficiently Checking Actual Causality with SAT Solving", arXiv:1904.13101v1,
  30 Apr 2019. Cache key `arXiv:1904.13101`, sha256
  `71234116d745525e3d7cf4b2084ea4bf216733561cc70794c3be4176c307b482`.
  **Read depth**: `partial` — abstract, § 1.2 (complexity and prior work), § 3 (Definition 2, the
  actual-cause conditions), § 4.1–4.3 (the two SAT encodings, Algorithm 1, "Minimality of `W`",
  AC3 encoding, the combined AC2/AC3 optimisation), and the evaluation table headers. Preprint
  version read; the published version (Ibrahim, Rehwald & Pretschner, in *Foundations of Trusted
  Autonomy*-style venue per the paper's own header) was not read, so all characterisations below are
  of the preprint.
- **Definition variant**: the **modified** Halpern–Pearl definition. The paper states
  ("To the best of our knowledge, no previous work has tackled the technical implementation of the
  (modified) version of HP yet"), and its Definition 2 has AC2 in the modified form — `W` is fixed at
  its actual values `w`, with no separate AC2(b).
- **Scope**: acyclic causal models with **binary** variables only.
- **Scale reported**: "causality is computed efficiently in less than 5 seconds for models that
  consist of more than 4000 variables" (abstract).
- **Responsibility**: not computed directly, but the paper adds an All-SAT variant specifically
  because "to compute the degree of responsibility, a minimal `W` is required", and gives the
  modification that yields a minimal `W`.
- **Witness / certificate**: it returns the satisfying assignment, hence a concrete `W` and setting
  `x'`. That is a witness for AC2. There is no exported, independently checkable certificate of the
  *exhaustion* half (that no smaller `W` or no proper subset of the cause works); that side is
  discharged inside the SAT solver's UNSAT result and by All-SAT enumeration.
- **Maintenance**: `github.com/amjadKhalifah/HP2SAT1.0`, Java, MIT licence, created 2018-08-29, last
  push 2024-12-30, 2 stars, 0 forks, 2 open issues, not archived. **Read depth**:
  `abstract/metadata only` — GitHub REST API repository record, retrieved 2026-09-04.

### Q1.2 MaxSAT / ILP formulation (Ibrahim & Pretschner, ATVA 2020)

**Exists, computes degree of responsibility explicitly, and one of its encodings is reported
unsound by a later paper.**

- **Source**: "From Checking to Inference: Actual Causality Computations as Optimization Problems",
  arXiv:2006.03363v1, 5 Jun 2020; published in *Automated Technology for Verification and Analysis*
  (ATVA 2020), LNCS 12302, DOI 10.1007/978-3-030-59152-6_19. Cache key `arXiv:2006.03363`, sha256
  `2be8216820f6e1ad189874a06e5d23cff24d4c779c8b1967b5a7da19cdbbcabb`.
  **Read depth**: `partial` — abstract, § 1, § 2 (Definition 2 actual cause, Definition 3 degree of
  responsibility, the rock-throwing worked example), § 3 opening (encoding construction), the
  benchmark description, and the reference list. Preprint read, not the LNCS version.
- **Contribution**: three encodings — an ILP and a MaxSAT encoding for *checking* (both of which also
  return a minimal cause from a non-minimal candidate, which the authors call semi-inference), and an
  ILP encoding for *inference* (finding causes with no candidate supplied).
- **Definition variant**: modified Halpern–Pearl, binary acyclic models.
- **Scale reported**: "Using models with more than 8000 variables, checking is computed in a matter
  of seconds, with MaxSAT outperforming ILP in many cases. In contrast, inference is computed in a
  matter of minutes."
- **Responsibility**: yes, and it is the *objective function*. Their Definition 3 is
  `dr = 1/(|W| + |X|)`, and § 4 states "maximizing the responsibility entails minimizing the sizes of
  both the cause and the contingency sets".
- **Witness / certificate**: the optimal assignment gives `X`, `W`, and `x'`. Optimality is the
  solver's, not an exported certificate.
- **Code**: released as a branch of the same repository,
  `github.com/amjadKhalifah/HP2SAT1.0/tree/hp-optimization-library`.
- **Correction on record**: Özcan, Alrajeh & Craven (KR 2025) state that the ATVA 2020 claim "that
  the relevant formula `G*` is satisfiable iff AC2 holds — is incorrect", and that allowing effect
  variables in interventions would fix it at a cost. **This is their claim, read in their paper, not
  verified by me against the ATVA proof.** The practical consequence for us is in § Consequences.

### Q1.3 Answer Set Programming engine (Özcan, Alrajeh & Craven, KR 2025)

**Exists, is the current state of the art by the authors' own measurements, actively updated, and
guarantees minimal contingency sets.**

- **Source**: "Reasoning About Actual Causality in Answer Set Programming", Proceedings of the 22nd
  International Conference on Principles of Knowledge Representation and Reasoning (KR 2025), paper
  59, Daniel Özcan, Dalal Alrajeh, Robert Craven (Imperial College London). Cache key `kr:2025:59`,
  sha256 `3f7ac291b9313af1a683a551864048df77d4ec9bc1b7cdb854a839d4005ec8f0`.
  **Read depth**: `partial` — abstract, § 1, the definition section (modified HP adoption and the
  reduct construction), the related-work paragraph on Ibrahim et al., Proposition 6, and the
  evaluation section (benchmark composition and runtime/memory results).
- **Capabilities**: three query types in one framework — *Checking* (is this event a cause?),
  *Finding* (which sub-events of a failed candidate are causes?), *Inferring* (enumerate all actual
  causes with no candidate). The authors state theirs "is the first to support all three tasks within
  a unified framework, guaranteeing minimal contingency sets and outperforming prior implementations
  in both runtime and memory".
- **Definition variant**: "We adopt the most recent — modified — definition (Halpern, 2015)".
  Binary models, acyclic.
- **Scale reported**: same benchmark suite as Ibrahim et al. — 500 Checking/Finding queries and 187
  Inferring queries over 37 binary models, 21 with fewer than 400 endogenous variables and 16 with up
  to roughly 8,000. They apply a query-specific reduct: "some queries on models with about 8,000
  variables reduced to roughly 700 relevant variables". Reported runtimes: their tool under 10 s and
  under 1 GB across the suite; MaxSAT up to 25 s "without enforcing minimality"; the third comparator
  suffers memory exhaustion with two runs above 50 minutes and 17 GB.
- **Responsibility**: **not computed.** The words "responsibility" and "blame" appear once in the
  paper, in an unrelated sentence about neighbourhood dynamics. This is the clearest gap in the
  strongest engine.
- **Witness / certificate**: it returns all solutions with minimal contingency sets, which the
  authors frame as "supporting transparency". Minimality is enforced through `asprin` preferences
  over answer sets, so the optimality argument lives inside `clingo`. **My inference, marked as
  mine:** this is a witness plus solver-internal optimality, not an exported exhaustion certificate a
  third party can replay without the solver.
- **Maintenance**: `github.com/DanHOzcan/HP_ASPBinary`, Python, created 2025-08-01, last push
  2026-02-24. **Read depth**: `abstract/metadata only` — GitHub REST API record, 2026-09-04.

### Q1.4 ChiRho's causal-explanation module

**Exists, actively maintained, modified definition — and it samples rather than enumerates, exactly
as the probe's question anticipated.**

- **Source**: "Actual Causality and the modified Halpern-Pearl definition", ChiRho documentation
  page, `basisresearch.github.io/chirho/actual_causality.html`, fetched 2026-09-04.
  **Read depth**: `partial` — page fetched with `curl`, HTML stripped locally, and the following
  sections read verbatim: Summary, "Intuitions and formalization", the implementation section
  describing `SearchForExplanation`, and "Comments on example selection". Not cached as a PDF (it is
  a web page); no sha256 recorded.
- **Definition variant**: "the so-called Halpern-Pearl modified definition of actual causality
  (J. Halpern, MIT Press, 2016)".
- **Method**: **sampling, not enumeration**, and the documentation says so outright: "Instead of full
  enumeration, we will be approximating the answers with sampling. In particular, answering an actual
  causality query requires investigating the consequences of intervening on all possible witness
  candidate nodes in all possible combinations thereof... While complete enumeration would work for
  smaller models, we implement a more general approximate method, which draws random sets of witness
  nodes multiple times and intervenes on those sampled sets." Witness preemption probability is
  `0.5 + witness_bias`; an antecedent bias steers the search toward smaller causes.
- **Responsibility**: not computed. The page's own comment on the voting example says the notion of
  actual causality implemented there "is not enough to capture these intuitions" and points at
  responsibility and blame as the missing piece.
- **Certificate**: none. The output is a table of sampled antecedent/witness configurations.
- **Fixtures it ships**, with the book locations it cites: stone-throwing (*Actual Causality* p. 3),
  forest fire (Example 2.3.1, p. 28), doctors, friendly fire, voting (Example 2.3.2).
- **Maintenance**: `github.com/BasisResearch/chirho`, Python, 277 stars, last push 2026-07-24, not
  archived. **Read depth**: `abstract/metadata only` — GitHub REST API record, 2026-09-04.

### Q1.5 Successors and neighbours, 2021–2026

**Screened set.** DBLP publication search for the phrase `actual causality`, retrieved 2026-09-04,
returned 28 hits; the screen ran over title and venue only, and the discriminator was "does the title
indicate an implemented reasoning engine, a definitional variant, or an application?". The whole set
is listed here rather than filtered, because the set is small and its composition is itself the
evidence for the coverage claim:

| Year | Title (abbreviated) | Venue |
|------|---------------------|-------|
| 2026 | Mitigating Causal Bias in LLMs via Potential Outcomes and Actual Causality Theory | EACL |
| 2026 | Efficient Discovery of Actual Causality in Stochastic Systems | VMCAI |
| 2026 | Reconciling Consistency-Based Diagnosis with Actual-Causality-Based Explanations | CoRR |
| 2026 | Explaining Failures of Cyber-Physical Systems with Actual Causality | CoRR |
| 2026 | Beyond But-for Test: Counterfactual Explanation in Abstract Argumentation via Actual Causality | CoRR |
| 2026 | Actual causality in fault trees | CoRR |
| 2025 | On the Semantics of Actual Causality in Situation Calculus Concurrent Game Structures | Canadian AI |
| 2025 | Reasoning About Actual Causality in Answer Set Programming | KR |
| 2025 | AC-Reason: Theory-Guided Actual Causality Reasoning with Large Language Models | CoRR |
| 2025 | Efficient Discovery of Actual Causality with Uncertainty | CoRR |
| 2024 | Efficient Discovery of Actual Causality Using Abstraction Refinement | IEEE TCAD |
| 2024 | Efficient Discovery of Actual Causality using Abstraction-Refinement | CoRR |
| 2023 | Embracing Background Knowledge in the Analysis of Actual Causality: An ASP Approach | TPLP |
| 2023 | (same, preprint) | CoRR |
| 2022 | Actual Causality and Responsibility Attribution in Decentralized POMDPs | AIES |
| 2022 | Action Languages Based Actual Causality in Decision Making Contexts | PRIMA |
| 2022 | (two further preprint duplicates of the above) | CoRR |
| 2021 | An Actual Causality Framework for Accountable Systems | (TUM dissertation) |
| 2020 | From Checking to Inference: Actual Causality Computations as Optimization Problems | ATVA (+ CoRR) |
| 2020 | Actual Causality Canvas: A General Framework for Explanation-Based Socio-Technical Constructs | ECAI |
| 2020 | Actual Causality in Contextual Abduction | ICLP Workshops |
| 2019 | Efficiently Checking Actual Causality with SAT Solving | CoRR |
| 2018 | Situation Calculus Semantics for Actual Causality | AAAI (+ COMMONSENSE 2017) |
| 2018 | Actual Causality in a Logical Setting | IJCAI |
| 2016 | Actual Causality (the book) | — |

One member is promoted for individual discussion.

**Rafieioskouei & Bonakdarpour, "Efficient Discovery of Actual Causality using
Abstraction-Refinement".** arXiv:2407.16629v3, 30 Aug 2024; journal version in *IEEE Transactions on
Computer-Aided Design of Integrated Circuits and Systems*, 2024. Cache key `arXiv:2407.16629`,
sha256 `a8cc22c6a29e33c7ce77bc532bc66d82b38b462611bc2d0caa53bf2a2afbbc27`.
**Read depth**: `partial` — abstract, § 1, the definition section (Definition 4, with AC2(a) and
AC2(b) present), § 3 opening on the SMT formulation, and the case-study list. Preprint read, not the
TCAD version.

This one matters to us for three reasons. It models Halpern–Pearl causality over **transition
systems** rather than plain SCMs, which is the same interventional-transition-system framing our
probe 8 proposes. It runs an **abstraction-refinement loop** to shrink the model before the
counterfactual search, reporting improvement "by several orders of magnitude" over a plain SMT
encoding. And its application domain is exactly the C1062 brainstorm's top-ranked one: root cause of
safety violations in cyber-physical systems, demonstrated on a Mountain Car neural controller, a
reinforcement-learned Lunar Lander controller, and an F-16 autopilot MPC controller. It uses the
**updated** (not modified) HP definition — AC2(a) and AC2(b) both appear — computes no degree of
responsibility, and its solver is Z3. Two follow-ups appear in the screened set: "Efficient Discovery
of Actual Causality with Uncertainty" (2025) and "Efficient Discovery of Actual Causality in
Stochastic Systems" (VMCAI 2026). **Read depth for the two follow-ups**: `abstract/metadata only` —
DBLP title and venue records; neither was retrieved.

### Q1.6 Does the narrowed claim survive?

Stated in the brief before the search: if engines exist, the claim narrows to "a compiled,
certificate-carrying engine versus a per-query SAT or ILP encoding". **That claim survives, and it
now has four named differentiators of visibly unequal strength.** Ranking them by how much of the
gap the audit actually shows:

1. **Non-binary finite domains.** All three engines are restricted to binary models — HP2SAT and
   the ATVA encodings by construction ("in binary models such a setting is the negation of the actual
   setting"), the ASP engine explicitly ("for all acyclic binary causal models"). Ergodis' lowering
   is over arbitrary finite domains. This is the least contestable gap and nobody has closed it.
2. **Degree of responsibility.** Only the ATVA 2020 line computes it, and only as a scalar objective;
   the strongest current engine (ASP) does not compute it at all, and ChiRho does not either. Our
   probe 3 deliverable includes it.
3. **An exported exhaustion certificate.** No engine exports one. All three discharge minimality
   inside a solver — UNSAT, an ILP optimum, or `asprin` preferences over answer sets. This is the
   differentiator that matches Ergodis' existing certificate discipline, and it is the one the probe
   should lead with.
4. **Amortisation across queries against one compile.** All three engines re-encode per query. This
   is the compilation argument and it is untested by anyone; it is also the one that the exploration
   log already flagged as unsupported in its revision-one form, so it must be earned rather than
   assumed.

**What must be dropped:** any claim of being first, and any claim resting on raw runtime. On raw
runtime the field is at 8,000 binary variables in seconds, and the ASP engine's reduct prunes 8,000
variables to about 700 before search. A speed race is not winnable as a framing and should not be
attempted as one.

---

## Q2 — novelty of the compiled object

### Q2.1 Balke and Pearl's response-function partition: **confirmed**

The exploration log's claim — that with every endogenous variable observed and the full
`do(pa(V) := p)` vocabulary on a canonical exogenous space, the compiled relation *is* Balke and
Pearl's 1994 response-function partition — is **confirmed against the original text**.

- **Source**: Alexander Balke and Judea Pearl, "Counterfactual Probabilities: Computational Methods,
  Bounds and Applications", *Proceedings of the Tenth Conference on Uncertainty in Artificial
  Intelligence* (UAI-94), pp. 46–54; retrieved as arXiv:1302.6784. Cache key `arXiv:1302.6784`,
  sha256 `74bf10565ad2d84272617650081d793fcf90a03d488589dc13e901339271ccfe`.
  **Read depth**: `partial` — § 1 (the interpretation of counterfactuals as external action), the
  response-function-variable construction and its four-case display, the passage introducing
  response-function variables for all variables in the model, and the reference list. arXiv posting
  of the UAI-94 paper read; no other version consulted.

The construction, in the paper's own words: given the exogenous variable `ε_b` feeding `B` with
parent `A`, "each value in `ε_b`'s domain specifies a response function that maps each value of `A`
to some value in `B`'s domain. In general, the domain for `ε_b` could contain many components, but it
can always be replaced by an equivalent variable that is **minimal, by partitioning the domain into
equivalence regions, each corresponding to a single response function**". They then give the
equivalence classes explicitly as the four-valued map `r_b`, and name the result a
*response-function variable*.

Two attribution points must be carried:

- Balke and Pearl credit the minimality-by-partition step to **[Pearl, 1993a]** — Judea Pearl,
  "Aspects of graphical models connected with causality", *Proceedings of the 49th Session of the
  International Statistical Institute*, Florence, August 1993, pp. 391–401, with a short version in
  *Statistical Science*. **Read depth for Pearl 1993a**: not accessed; it is named here because
  Balke and Pearl name it, and any priority statement we make must run back to it, not stop at 1994.
- The published construction partitions **per variable**, and forms the joint canonical space as the
  product of the per-variable response-function variables. Our quotient is a partition of the joint
  exogenous space. **My inference, marked as mine:** these coincide when each exogenous variable
  feeds exactly one endogenous variable, and our quotient is the joint partition induced by the tuple
  of response functions when exogenous variables are shared. Probe 1's fixture is written as
  "class-for-class agreement with the product of per-variable response-function partitions", which is
  the right comparison for the unshared case; if the fixture model has a shared exogenous variable,
  the expected object is the joint partition and the fixture text needs one clause added.

**Consequence:** probe 1's gate 1 is external truth, correctly identified, and stands. Nothing about
probe 1 needs to be cut. But the report must not present the full-observation quotient as new.

### Q2.2 The causal-abstraction line: definitional or learned, never the coarsest quotient

Every paper in the target list characterises *when a proposed abstraction is valid*, or *learns an
approximate abstraction from data*. None computes the coarsest exact abstraction, and none emits a
separating intervention as a refutation witness.

- **Rubenstein et al. 2017**, "Causal Consistency of Structural Equation Models", arXiv:1707.00819.
  **Read depth**: `abstract/metadata only` — arXiv API record. Introduces *exact transformations*
  between structural equation models as a consistency notion; the abstract frames it as formalising
  when two models "agree in their predictions of the effects of interventions", not as computing one
  from the other. Also characterised at `secondary only` depth through Beckers & Halpern 2019 § 1,
  which describes it as the starting point of their hierarchy.
- **Beckers & Halpern 2019**, "Abstracting Causal Models", AAAI-19, DOI
  10.1609/aaai.v33i01.33012678. Cache key `10.1609/aaai.v33i01.33012678`, sha256
  `49ebd3238aaf589071eaafe95164cea08d6f7b4d38febe7d168f4dbfe53a87c3`. **Read depth**: `partial` —
  abstract, the causal-model definitions, and a targeted scan for the words "coarsest", "algorithm",
  and "compute". The paper is a sequence of successively more restrictive **definitions** — exact
  transformation, uniform transformation, τ-abstraction, strong abstraction, constructive
  abstraction — with results showing that micro-to-macro variable-combining procedures are instances
  of strong abstraction. There is no algorithm and no coarsest-abstraction construction. This
  confirms the brief's framing that the literature asks "is this proposed abstraction causally
  valid?" rather than "compute the coarsest valid one".
- **Beckers, Eberhardt & Halpern 2019**, "Approximate Causal Abstraction", UAI 2019. Cache key
  `uai:2019:approximate-causal-abstraction`, sha256
  `2363543543654ad60e76ce88c14aee5d50e88ab6b2b135d40aa6701a97b61be3`. **Read depth**:
  `abstract/metadata only` — the PDF was fetched and cached but only its title block was read.
- **Rischel & Weichwald 2021**, "Compositional Abstraction Error and a Category of Causal Models",
  arXiv:2103.15758, UAI 2021. **Read depth**: `abstract/metadata only` — arXiv API record. The
  abstract's own framing is a compositional *error measure* for moving between fine- and
  coarse-grained variables, in a category of causal models. This is the direction probe 7 names, and
  nothing in the abstract computes a coarsest quotient.
- **Geiger et al. 2021**, "Causal Abstractions of Neural Networks", arXiv:2106.02997, and
  **Geiger et al. 2023/2024**, "Causal Abstraction: A Theoretical Foundation for Mechanistic
  Interpretability", arXiv:2301.04709v4. **Read depth**: `abstract/metadata only` for both — arXiv
  API records. The 2021 paper aligns neural representations with variables in an interpretable causal
  model and *verifies* the alignment by interchange interventions — proposal-and-check, which is
  precisely the shape probe 5 proposes to invert. The 2023 paper generalises the theory from
  mechanism replacement to arbitrary mechanism transformation.
- **Zennaro 2023**, "Abstraction between Structural Causal Models: A Review of Definitions and
  Properties", arXiv:2207.08603. **Read depth**: `abstract/metadata only` — arXiv API record. It is
  a review of maps between SCMs under an interventional-consistency requirement, which is further
  evidence that the field's object is the requirement, not the construction.
- **Massidda et al.**, "Causal Abstraction with Soft Interventions", arXiv:2211.12270. **Read
  depth**: `abstract/metadata only` — arXiv API record. Extends τ-abstraction from Beckers & Halpern
  2019 to soft interventions. Relevant to the exploration log's observation that hard-intervention
  word closure is vacuous: soft interventions are exactly where it is not.
- **Kekić, Schölkopf & Besserve**, "Targeted Reduction of Causal Models", arXiv:2311.18639v2;
  published in *Proceedings of the 40th Conference on Uncertainty in Artificial Intelligence* (UAI
  2024), pp. 1953–1980. **Read depth**: `abstract/metadata only` — arXiv API record plus the PMLR
  listing. Targeted Causal Reduction condenses an intervenable model into causal factors explaining a
  *specific target*, learned from interventional simulation data with an information-theoretic
  objective. This is the published neighbour of our `O` = declared-outcome case, and it is
  **learned and approximate**, where ours is exact and combinatorial. That contrast is the correct
  positioning sentence for probe 1's report.
- **Madaleno, Misra & Markham**, "Coarsening Causal DAG Models", arXiv:2601.10531v2, 2 Apr 2026.
  Cache key `arXiv:2601.10531`, sha256
  `8fd6884b4b69128aef2ea6ce1da203d9b7009c76bb0889a5f77f557f4724f3aa`. **Read depth**: `partial` —
  abstract, keyword line, § 1 (the partition refinement lattice), Algorithm 1 (`RePaRe`), Theorem 6
  (completeness of `RePaRe` relative to Refine- and IsEdge-oracles), § 2.2 (interventional
  coarsening) and Theorem 10 (its identifiability), and the `RefineTest` procedure header.

  **This is the closest published object to probe 7 and must be cited by it.** The paper's keywords
  literally include "partition refinement lattice". Its `RePaRe` algorithm recursively refines a
  partition of the **variable set**, and its "interventional coarsening" merges nodes indistinguishable
  with respect to the available interventions. Three differences keep it from pre-empting our object,
  and all three should be stated in probe 7's report rather than left implicit: it partitions
  *variables*, not the exogenous space; it *learns* from interventional data with unknown intervention
  targets and is consistent in the sample limit, rather than computing an exact quotient of a known
  finite model; and its refinement is driven by oracle tests, not by a separating intervention
  returned as a replayable counterexample. Note that its carrier — a partition of the variable set —
  is exactly the carrier the exploration log says our `(u, I)` quotient **cannot express**. That
  makes it the natural comparison point for probe 7's compositional route and, separately, a reason
  probe 5's "these 27 states are one causal variable" framing must stay off the `(u, I)` carrier.

### Q2.3 The bisimulation intersection: partly occupied

**The notion is published; the algorithm was not located.**

- **Chakraborty, Caulfield & Pym**, "Causality and Decision-making: A Logical Framework for Systems
  and Security Modelling", arXiv:2508.01758v1, 3 Aug 2025. Cache key `arXiv:2508.01758`, sha256
  `a7eeb347443118ab57b58c429babee345a5233f2087e602c41be312680d0b675`. **Read depth**: `partial` —
  abstract, § 1 outline, § 6 (the two van Benthem–Bergstra–Hennessy–Milner theorems and the statement
  of Theorem 2), and the appendix passage giving "the full definition of our model-changing notion of
  bisimulation".

  They define **bisimulation under intervention**, "extending the standard back-and-forth (zig-zag)"
  conditions to interventions on mechanisms, and prove two van Benthem–Bergstra–Hennessy–Milner
  correspondence theorems: bisimilar interface-admitting models satisfy the same formulas, and under
  finiteness, logical equivalence implies the existence of a bisimulation under intervention. A
  targeted scan of the text for "quotient", "coarsest", and "partition refinement" returned nothing.
  **My inference, marked as mine:** they characterise the equivalence logically and do not compute
  the quotient, do not minimise, and produce no separating intervention. The novelty risk to our
  *notion* is real and the phrase is taken; the novelty on the *algorithm* is not touched.

  A shorter version exists: Pinaki Chakraborty, Tristan Caulfield, David Pym, "Local Causal Reasoning
  in Multiagent Systems (Extended Abstract)", *Communications in Computer and Information Science*,
  *Advances in Explainable Agentic AI and Large Language Models*, 2026, pp. 73–95, DOI
  10.1007/978-3-032-20548-3_6. **Read depth**: `abstract/metadata only` — Crossref record; the
  Springer chapter page redirects to an authentication endpoint and was not retrieved.

- **Kanellakis & Smolka; Paige & Tarjan.** **Read depth**: not accessed. They are named here only as
  the classical partition-refinement algorithms for bisimilarity, and no verdict below rests on their
  content. Their relevance is that our compiled relation is a bisimulation of the interventional
  labelled transition system and would be computed by exactly this family of algorithms.

### Q2.4 The negative, with its searched domain and stop condition

**Claim being discharged:** no published work computes the coarsest partition of a finite SCM's
exogenous space under indistinguishability by every admissible intervention, by partition refinement,
emitting a separating intervention as the refutation witness for each separated pair.

Four independent indexes were queried on 2026-09-04. Each query is recorded verbatim. For each
service, an empty result was distinguished from an error by first running a query on the same service
known to return hits.

**OpenAlex** (`api.openalex.org/works`, `filter=title_and_abstract.search:`):

| Query | Count | Screen result |
|---|---|---|
| `"structural causal model" AND bisimulation` | 0 | — |
| `"partition refinement" AND causal AND intervention` | 0 | — |
| `bisimulation AND "causal model"` | 1 | "Universal Decision Models" (2021); not a quotient algorithm |
| `bisimulation AND intervention AND causal` | 2 | both are the Chakraborty–Caulfield–Pym extended abstract |
| `"causal bisimulation"` | 16 | all concurrency theory (causal trees, π-calculus, action refinement); none is Pearl-style causality |
| `"causal abstraction" AND ("coarsest" OR "maximal abstraction")` | 2 | two Zenodo copies of one philosophy-of-explanation preprint |
| `"interventional equivalence" AND exogenous` | 0 | — |
| `"causal abstraction" AND algorithm AND exact` | 2 | two copies of "Multi-Granularity Causal Structure Learning"; a learning method |
| `"response function" AND "canonical partition" AND causal` | 0 | — |

Non-empty control: `"C-ADL"` returned 76, confirming the endpoint answers.

**arXiv API** (`export.arxiv.org/api/query`):

| Query | Total |
|---|---|
| `all:bisimulation AND all:"structural causal"` | 0 |
| `all:bisimulation AND all:"causal abstraction"` | 0 |
| `all:"causal abstraction" AND all:bisimulation` | 0 |
| `abs:"partition refinement" AND abs:"causal"` | 0 |
| `abs:"causal abstraction" AND abs:"coarsest"` | 0 |

Non-empty control: `all:"causal abstraction"` returned 68, so the zeros are genuine empties on this
index rather than a broken query form.

**DBLP** (`dblp.org/search/publ/api`):

| Query | Hits | Screen result |
|---|---|---|
| `bisimulation causal model intervention` | 0 | — |
| `causal abstraction partition refinement` | 0 | — |
| `bisimulation structural causal` | 0 | — |
| `causal quotient intervention` | 0 | — |
| `bisimulation causal` | 2 | both concurrency theory (non-interleaving applied π-calculus; concurrency/causality/conflict games) |

Non-empty controls: `causal abstraction` returned 88 and `bisimulation minimization` returned 11, so
the zeros are genuine.

**Crossref** (`api.crossref.org/works`, `query.bibliographic=`). Crossref's total-results figure is
not a conjunctive match count and is not reported here as evidence. Three queries were run —
`bisimulation structural causal model intervention quotient`, `partition refinement interventional
equivalence structural causal model`, and `coarsest causal abstraction partition refinement` — and
the top eight relevance-ranked results of each were screened over title only. None combined
interventional causal semantics with partition-refinement minimisation. The only adjacent hit worth
recording is "Relation coarsest partition method to observability of probabilistic Boolean networks"
(2024), which applies coarsest-partition machinery to Boolean control network observability rather
than to structural causal models.

**Stop condition.** Searching stopped when all four services returned either zero conjunctive hits or
only members already screened, and when the two nearest neighbours (bisimulation under intervention;
`RePaRe` coarsening) had been retrieved and read at `partial` depth. **Verdict: no predecessor
located for the algorithm, at this depth, on these four indexes.** The one width requirement of the
conventions is met — OpenAlex, Crossref, and Semantic Scholar were each to be queried independently;
Semantic Scholar failed repeatedly with HTTP 429 (see § Coverage), and DBLP and arXiv were used as
the substituting independent indexes. Because Semantic Scholar did not answer, this negative is
carried as "not located on four indexes", not as "does not exist".

---

## Q3 — the responsibility formula and the pre-entered fixture verdicts

### Q3.1 The original formula (Chockler & Halpern 2004), and why it cannot be transplanted

- **Source**: Hana Chockler and Joseph Y. Halpern, "Responsibility and Blame: A Structural-Model
  Approach", arXiv:cs/0312038v1, 17 Dec 2003; published in *Journal of Artificial Intelligence
  Research* 22 (2004), pp. 93–115, DOI 10.1613/jair.1391. Cache key `arXiv:cs/0312038`, sha256
  `f0661531b35b38c4ed3bf377626294e2a8c75589b7779eff4d9811188ae0a938`. **Read depth**: `partial` —
  § 1 in full (which is where every fixture number appears), and § 3 Definition 3.2. arXiv preprint
  read; the JAIR published version was not read, and the paper's own DOI is cited from the Ibrahim &
  Pretschner reference list rather than from a JAIR page.

Definition 3.2, verbatim in substance: the degree of responsibility of `X = x` for `φ` in `(M, u)` is
0 if `X = x` is not a cause; otherwise it is `1/(k + 1)` where there is a partition `(Z, W)` and a
setting `(x', w)` for which AC2 holds such that **`k` variables in `W` have different values in `w`
than they do in the context `u`**, and no partition and setting satisfying AC2 has fewer than `k`
such differing variables.

**The trap, stated plainly.** `k` is not `|W|`. It counts only the `W` variables whose contingency
value *differs* from their actual value. Under the **modified** Halpern–Pearl definition, `W` is
always held at its actual values, so that count is identically zero and the 2004 formula degenerates
to `1` for every cause. The brief's `1/(k + 1)` is therefore not merely "the original formula" — it
is a formula whose counting rule has no content under the definition probe 3 intends to implement.

### Q3.2 The modified-definition formula: `1/(|X| + |W|)`

Three independent restatements agree, and all three cite Chockler & Halpern 2004 together with
Halpern's 2016 book:

1. **Ibrahim & Pretschner, ATVA 2020, Definition 3**: "The degree of responsibility of `X = x` w.r.t.
   a cause `X = x` for `φ` ... is 0 if `X = x` is not in `X = x`; otherwise is `1/(|W| + |X|)` given
   that `|W|` is the smallest set of variables that satisfies AC2." Cited to [8] = Chockler & Halpern
   2004 and [13] = Halpern, *Actual Causality*, MIT Press 2016. **Read depth**: `partial`, as
   recorded in Q1.2.
2. **Ibrahim, TUM dissertation 2021, Definition 2.5** — the fullest statement located, and the one to
   implement from. Cache key `mediatum:1577467`, sha256
   `979725165d74b2b43df5df73dc920d32c40b8e389602605dc83d396891567f4a`. **Read depth**: `partial` —
   § 2.4 (Definition 2.5 and the surrounding voting/rock-throwing discussion), § 4 (the objective
   derivation `1/(|X| + |W|)`), and the reference list. Verbatim:

   > The degree of responsibility of `X = x` for `φ` in `(M, u)` **according to the modified HP
   > definition** ... is 0 if `X = x` is not part of a cause of `φ` in `(M, u)` according to the
   > modified HP definition; it is `1/k` if there exists a cause `X = x` of `φ` and a witness
   > `(W, w, x')` to `X = x` being a cause of `φ` in `(M, u)` such that (a) `X = x` is a conjunct of
   > `X = x`, (b) `|W| + |X| = k`, and (c) `k` is minimal, in that there is no cause `X₁ = x₁` for `φ`
   > and a witness `(W', w', x₁')` to `X₁ = x₁` being a cause of `φ` in `(M, u)` according to the
   > modified HP definition that includes `X = x` as a conjunct with `|W'| + |X₁| < k`.

   Note the form is `1/k`, not `1/(k + 1)`: since a cause is non-empty, `|X| ≥ 1` and the denominator
   is already at least 1. The `+1` of the 2004 formula is absorbed by counting `|X|`.
3. **Triantafyllou, Singla & Radanovic**, "Actual Causality and Responsibility Attribution in
   Decentralized Partially Observable Markov Decision Processes", AIES 2022, arXiv:2204.00302. Cache
   key `arXiv:2204.00302`, sha256
   `8304d9fa1e70146be7e2877fdfb94d1446416aa58d581daabe681acd61f51b59`. **Read depth**: `partial` —
   § 4.1 Definition 4.1 and the paragraph following it. Their restatement of the Chockler–Halpern
   notion under a general definition `D` sets `k = |A| + |W|` where `A` is the actual cause and `W`
   the contingency, and comments that "the CH definition captures the important idea that an agent's
   degree of responsibility should depend on the size of the actual causes it participates in, the
   size of their corresponding contingencies, and its degree of participation."

**Answer to the question the probe asked.** Under the modified definition the denominator counts
**both** `|X'|` (the full conjunctive cause containing the variable of interest) **and** `|W|` (the
whole contingency set, not merely its changed members), minimised jointly over all
(cause, witness) pairs in which the variable appears as a conjunct. The exploration log's statement —
"the responsibility denominator counts `|X'|` as well as `|W|` under the modified definition" — is
**correct as written**, and the brief's `1/(k + 1)` must be replaced everywhere.

**Citation status of the book.** Halpern, *Actual Causality*, MIT Press, Cambridge MA, 2016, chapter
6 ("Responsibility and Blame") is the reference the probe asked for and **could not be accessed**;
see § Coverage. The chapter/section number for the definition is therefore **not** stated here, and
must not be invented. Any manuscript-facing citation should read "Halpern 2016, ch. 6" only after
someone has the book open; the safe citation today is Ibrahim's dissertation Definition 2.5 together
with Chockler & Halpern 2004 Definition 3.2.

### Q3.3 Pre-entered fixture verdicts

Two definitions must be kept apart in the fixture table, because several fixtures give the *same
number for different reasons* and a probe that conflates them will pass for the wrong cause.

**Under the original/updated definition** — source: Halpern, "Cause, responsibility, and blame: a
structural-model approach", *Law, Probability and Risk* 14:2 (2015), pp. 91–118. Cache key
`10.1093/lpr/mgv005`, sha256 `3208c12e746367b42047f58b93cf37a24a97819aca14ea208f08783520799e69`.
**Read depth**: `partial` — § 1 (all the fixture numbers), § 3 Definition 3.1, and § 5 (Definition
5.1 and the worked responsibility values). Author's own PDF from his Cornell page; the journal
version was not read, and the paper works with *extended* causal models carrying a normality order,
which the Suzy/Billy value below depends on. Chockler & Halpern 2004 § 1 is the second source for the
voting numbers.

| Fixture | Published verdict and value | Source |
|---|---|---|
| Voting, 11–0 | each Mr. B voter is a cause; `dr = 1/6` ("since 5 changes have to be made before a vote is critical") | Chockler & Halpern 2004 § 1; repeated Halpern 2015 § 5 |
| Voting, 1001–0 | `dr = 1/501` for any voter | Chockler & Halpern 2004 § 1 |
| Voting, 5–4 | `dr = 1` for each Mr. B voter ("each voter is critical"); `dr = 0` for each Mr. G voter | Chockler & Halpern 2004 § 1 |
| Voting, 6–5 | `dr = 1` for each Mr. B voter | Halpern 2015 § 5 |
| Forest fire, disjunctive, context (1,1,1) | lightning and arsonist **each** have `dr = 1/2` | Halpern 2015 § 5 |
| Forest fire, conjunctive, context (1,1,2) | lightning and arsonist **each** have `dr = 1` | Halpern 2015 § 5 |
| Rock throwing (late preemption) | Billy `dr = 0` (not a cause). Suzy: `dr = 1` if the setting `(ST=0, BT=1, BH=0)` is allowable, `dr = 1/2` if instead only the settings where Billy does not throw are allowable | Halpern 2015 § 5, which makes the value explicitly dependent on the extended model's allowable settings |
| Rock throwing, plain causal model | Suzy `dr = 1/2`, Billy `dr = 0` | Chockler & Halpern 2004 § 1 |

**Under the modified definition** — sources: Halpern, "A Modification of the Halpern–Pearl Definition
of Causality", IJCAI 2015, pp. 3022–3033. Cache key `ijcai:2015:modified-hp-def`, sha256
`caf8d029f6b991546fcad6cbd6fab25855087a811ce773446b62140959b6af1d`. **Read depth**: `partial` —
Example 3.1 (forest fire, both scenarios) and Example 3.2 (rock throwing) in full, plus the
definition statement. Author's PDF from his Cornell page; the IJCAI proceedings version was not read.
Plus Ibrahim's dissertation § 2.4 for the numeric values.

| Fixture | Published verdict | Responsibility |
|---|---|---|
| Forest fire, **conjunctive** `FF = L ∧ MD`, context (1,1) | "all the definitions agree that both the lightning and the arsonist are causes, since each of `L = 1` and `MD = 1` is a but-for cause" — so each is a singleton cause with `W = ∅` | `dr = 1` for each. **`|X| = 1`, `|W| = 0`; my computation from Definition 2.5, not a published number.** |
| Forest fire, **disjunctive** `FF = L ∨ MD`, context (1,1) | "According to the modified definition `L = 1 ∧ MD = 1` is a cause of `FF = 1`. Intuitively, the values of both `L` and `MD` have to change in order to change the value of `FF`, so they are both **part of a cause, but not causes**." | `dr = 1/2` for each of `L = 1` and `MD = 1`. **`|X| = 2`, `|W| = 0`; my computation from Definition 2.5, not a published number.** |
| Rock throwing | `ST = 1` is a cause with `W = {BH}` held at its actual value 0; `BT = 1` is not a cause under any of the definitions | `dr(ST = 1) = 1/2` and `dr(BT = 1) = 0`, **published** in Ibrahim's dissertation § 2.4: "the responsibility of `ST = 1` is `1/2`, because we had `W = {BH}`, and the responsibility of `BT = 1` is 0" |
| Voting, 11–0 | each voter is part of a cause `X` with `|X| = 6` and `W = ∅` | `dr = 1/6`, **published** in Ibrahim's dissertation § 2.4 |

**The trap probe 3 was built to catch is real and now has a citation.** The exploration log warned
that a singleton-cause search under the modified definition returns a clean-looking "not a cause,
responsibility 0" on the disjunctive fire. Halpern's IJCAI 2015 Example 3.1 says exactly this in
words: under the modified definition `L = 1` alone is *not* a cause, only part of one. The
disjunctive fire is therefore the single most valuable fixture in the set, and it must be entered
with the conjunctive cause `L = 1 ∧ MD = 1` and `dr = 1/2` per conjunct before the run.

**Two numbers are my computation, not published, and are flagged as such** in the table above: the
conjunctive-fire `dr = 1` and the disjunctive-fire `dr = 1/2` under the *modified* definition. They
follow from Halpern's published cause verdicts plus Ibrahim's Definition 2.5 by direct substitution
(`W = ∅` in both scenarios), and they happen to coincide with the values Halpern 2015 § 5 publishes
under the *original* definition — but they coincide for a different reason, so the coincidence must
not be read as confirmation. If probe 3 needs these two as published oracles rather than derived
ones, the book's chapter 6 is where to look, and it is the access gap recorded below.

---

## Landscape-claim resolutions

All six unverified claims from § 1 of the brief. Searches run 2026-09-04.

| Claim | Verdict | Evidence |
|---|---|---|
| pyAgrum 3.0 moves causal machinery to C++, July 2026 | **CONFIRMED** | PyPI release history for `pyagrum`: 3.0.0 uploaded 2026-07-17, 3.1.1 on 2026-08-19. The aGrUM `CHANGELOG.md` (fetched from both the GitLab and GitHub mirrors, identical) opens its 3.0.0 entry: "This major release brings three headline changes: **the causal module is promoted from pure Python to a first-class C++** ..." and lists SWIG Python bindings for the C++ `CausalModel`, `CausalFormula`, `DoorCriteria`, and `Counterfactual` classes, plus renames (`observedBN()` → `observationalBN()`, `Counterfactual::getResult()` → `impact()`). **Read depth**: `partial` — the 3.0.0 and 3.1.0 sections of the changelog; PyPI JSON metadata. **Scope note, mine:** this is do-calculus, identification and counterfactual machinery, not actual causality; it does not compete with probe 3. |
| FLOP at ICLR 2026 with a Rust implementation | **CONFIRMED, but it is a different problem** | Wienöbst et al., "Embracing Discrete Search: A Reasonable Approach to Causal Structure Learning", arXiv:2510.04970v2, submitted 2025-10-06, revised 2026-02-27, arXiv comment field "Accepted at ICLR 2026". The paper states "we offer a Rust implementation at github.com/CausalDisco/flopsearch ready-to-use from Python", and the benchmark section notes it is "Rust and single-threaded". Cache key `arXiv:2510.04970`, sha256 `febf13bd692ca3e28ced50cd1172c50f23da6cc7f2ff4ebee65e1ed472dc2226`. **Read depth**: `partial` — abstract, the implementation and benchmark passages. **FLOP is score-based causal *structure learning* for linear models — causal discovery from data.** It has nothing to do with actual causality or causal abstraction, and is explicitly out of C1062 scope per the exploration log. |
| I-FLOP, "six days ago" | **CONFIRMED as a paper; the date claim is unverifiable and was wrong when made** | "I-FLOP: Fast Learning of Order and Parents from Interventional Data", arXiv:2608.28245v1, submitted 2026-08-28. **Read depth**: `abstract/metadata only` — arXiv API record. It extends FLOP from observational to interventional data using the interventional BIC score of Hauser and Bühlmann (2012). Again causal discovery, not actual causality. The brainstorm's "six days ago" cannot be checked against the brainstorm's own date; the paper is one week old as of this audit. |
| C-ADL embedding SCMs in architecture description languages | **CONFIRMED** | Mohammad Tanhaei, "C-ADL: A causal architecture description language for design-time root cause analysis and counterfactual reasoning in distributed systems", *Journal of Systems and Software* vol. 239, issued 2026-09, DOI 10.1016/j.jss.2026.112902. **Read depth**: `abstract/metadata only` — OpenAlex title/abstract search hit plus the Crossref record (title, sole author, journal, volume, issue date). The Crossref record carries no abstract and the full text was not retrieved. This sits in the same application space as probe 9's end-to-end demo. |
| May 2026 translation of binary Halpern SCM reasoning into dynamic logic of propositional assignments | **NOT FOUND** | Searched domain: OpenAlex `title_and_abstract.search` for `"dynamic logic of propositional assignments" AND causal` (0) and `"propositional assignments" AND causality AND Halpern` (0); arXiv API `all:"dynamic logic of propositional assignments" AND all:causal` (0), with a non-empty control confirming the endpoint answers; one web search on the full phrase plus "Halpern Pearl causality structural equation models translation 2026", whose results were all older logic-of-causality work (Bochman; Andreas & Günther; Beckers' *Actual Causality in a Logical Setting*, IJCAI 2018) and nothing matching. Stop condition: three independent formulations across two indexes plus a web search returned nothing dated 2026 on this topic. **Do not repeat this claim.** |
| SMILE 2.4.7, June 2026 | **NOT FOUND** | Searched domain: BayesFusion's own documentation — `support.bayesfusion.com/docs/SMILE.pdf` reports "Version 2.2.4.R1, Built on 4/27/2024"; `support.bayesfusion.com/docs/Wrappers.pdf` reports "Version 2.4.R1, Built on 10/15/2025"; `support.bayesfusion.com/docs/SMILE/introduction.html` reports version 2.2.4, built 4/27/2024; `download.bayesfusion.com/files.html` shows no 2.4.7 string; `support.bayesfusion.com/docs/SMILE/changes.html` returns nothing. Plus one web search on "BayesFusion SMILE engine version 2.4.7 release 2026". Stop condition: the vendor's own manuals and download index carry no version 2.4.7 and nothing dated June 2026. **Do not repeat this claim.** |

**A seventh claim, from the brief's § 4, is refuted by this audit.** The brief's line that the
landscape contains "no mature fast engine for Halpern actual causality" is false; see Q1. The brief
itself already predicted this and wrote the consequence branch in advance, which is why the
correction costs nothing.

---

## Coverage

- **Halpern, *Actual Causality*, MIT Press 2016, chapter 6 — COULD NOT ACCESS.** This is the primary
  reference Q3 named. Attempts: `direct.mit.edu/books/oa-monograph/3451` returns HTTP 403 to both a
  plain and a browser user-agent; the DOAB record (handle 20.500.12854/78541, DOI
  10.7551/mitpress/10809.001.0001) carries only a cover image, MARC, ONIX, RIS and TSV bitstreams
  with no PDF; OAPEN's search returned no matching item; Halpern's Cornell site hosts
  `causalitybook-ch1-3.html` only, and `causalitybook-ch4-6`, `causalitybook-ch6`, `causalitybook`
  and their `.pdf` forms all return 404. **Consequence:** the exact chapter/section number of the
  book's responsibility definition is not stated in this report, and the modified-definition formula
  rests on three independent secondary restatements (Q3.2) rather than on the book. Keep "to our
  knowledge" on any claim that would have been gated on the book text, and resolve this before any
  manuscript-facing use. It is not manuscript-facing today: C1062 is private research.
- **Semantic Scholar — NOT COVERED.** Every query returned HTTP 429 across eight retries with 12–20 s
  backoff, both foreground and backgrounded, with and without a mailto user-agent; one query
  (`partition refinement causal model intervention quotient`) succeeded once and returned 67
  irrelevant hits. DBLP and arXiv were used as the two substituting independent indexes for the Q2
  negative. The conventions' three-service requirement is met in count but not with the named third
  service, and the Q2 negative is stated as "not located on four indexes" accordingly.
- **MathSciNet — NOT COVERED** (institutional authentication, unreachable from an agent session).
  zbMATH Open was not queried; the subject matter is computer science rather than mathematics
  reviewing, so this is a gap of low expected yield but it is a gap.
- **Springer chapter 10.1007/978-3-032-20548-3_6 — could not access** (redirects to an
  authentication endpoint). Its content is characterised from the Crossref record and from the
  authors' longer arXiv paper, which was read at `partial` depth.
- **Rubenstein et al. 2017, Rischel & Weichwald 2021, Geiger et al. 2021 and 2023, Zennaro 2023,
  Massidda et al., Kekić et al., Beckers–Eberhardt–Halpern 2019 — searched and found, but read only
  at `abstract/metadata only` depth.** Each was retrieved (arXiv API records; the
  Beckers–Eberhardt–Halpern PDF was fetched and cached but not read past its title block). The Q2.2
  verdict — that this line defines or learns abstractions rather than computing the coarsest one —
  rests on abstracts plus the one paper in the line read at `partial` depth (Beckers & Halpern 2019).
  **That is the weakest link in this report's Q2 negative**, and one afternoon of reading would
  strengthen it. It is not weak enough to change any consequence below.
- **Pearl 1993a** ("Aspects of graphical models connected with causality", ISI Proceedings) — not
  accessed. Named because Balke & Pearl credit the partition-minimality step to it; any priority
  statement must chase it.
- **Rafieioskouei & Bonakdarpour 2025 and 2026 follow-ups** — not retrieved; DBLP records only.

---

## Consequences for the C1062 plan

### Probe 3 (exact actual causality and responsibility) — reframed, not cut, and it gets harder

**It is not cut.** But four things change, and one of them is a correctness fix that would have
produced wrong numbers.

1. **The responsibility formula changes before any code.** Implement `dr = 1/(|X| + |W|)`, minimised
   jointly over (cause, witness) pairs in which the queried variable is a conjunct, per Ibrahim's
   Definition 2.5. Delete `1/(k + 1)` from the brief and the exploration log. The reason is not
   cosmetic: `k` in the 2004 formula counts *changed* `W` variables, and under the modified
   definition nothing in `W` changes, so a literal transplant returns `dr = 1` for every cause.
2. **The framing is now "compiled and certificate-carrying versus per-query encoding", and its
   differentiators are ordered by strength**: non-binary finite domains first (no engine has them),
   degree of responsibility second (the strongest engine does not compute it), an exported exhaustion
   certificate third (nobody exports one), amortisation across queries fourth (untested by anyone,
   and the one the exploration log already flagged as needing to be earned). **Drop any framing that
   depends on being first or on raw speed.** The field is at 8,000 binary variables in seconds.
3. **The baseline and oracle change.** The comparator is no longer HP2SAT. It is the KR 2025 ASP
   engine (`github.com/DanHOzcan/HP_ASPBinary`, last pushed 2026-02-24), which reports beating the
   SAT, MaxSAT, and ILP strategies on their own benchmark suite in both runtime and memory. Its
   benchmark — 500 Checking/Finding and 187 Inferring queries over 37 binary models — is public at
   the URL its paper gives, and it is the natural external agreement fixture for our binary cases.
   Separately: **do not use the ATVA 2020 inference encoding as an oracle.** Özcan et al. state its
   `G*` satisfiability claim is incorrect. Use the ASP engine's verdicts, or Halpern's published
   fixture verdicts, and treat any disagreement with ATVA 2020 as expected rather than alarming.
4. **The `sat.rs` question resolves toward "drop the A/B and say so".** The exploration log offered a
   choice between writing a small DPLL and dropping the comparison. Given that the external field has
   moved to ASP with `asprin` preference optimisation, a hand-rolled DPLL would be a comparison
   against a straw arm. Better use of the same hours: make the exhaustion certificate exportable and
   independently replayable, since that is the differentiator no engine has.

The predeclared kill criterion — verifier work above 10% of search work, or no amortisation — stands
unchanged and is still the right test.

### Probe 1 (lowering, oracle, Balke–Pearl fixture, towers) — unchanged, with one clause to add

Gate 1 is confirmed as external truth. Balke & Pearl's response-function partition is real, is stated
in the 1994 UAI paper in the form the plan assumed, and the credit runs back to Pearl 1993a. Keep the
gate exactly as written.

One clause to add: the published construction partitions **per exogenous variable** and forms the
canonical space as a product. If probe 1's fixture model has any exogenous variable feeding more than
one endogenous variable, the expected object is the joint partition induced by the tuple of response
functions, not the product — state which case the fixture is in.

One positioning sentence to add to probe 1's report, now that the neighbour is identified: with
`O` = declared outcome the compiled relation is the exact, combinatorial counterpart of Kekić,
Schölkopf & Besserve's Targeted Causal Reduction (UAI 2024), which learns an approximate
target-specific reduction from interventional simulation data. Exact-versus-learned is the honest
distinction and it is a good one.

### Probe 7 (compositional lowering along the DAG) — gains a mandatory comparison, and a warning

Probe 7 is described in the plan as "the Rischel–Weichwald direction". That is still right, but a
closer neighbour now exists and probe 7 cannot be written without it.

**Madaleno, Misra & Markham, "Coarsening Causal DAG Models" (arXiv:2601.10531, April 2026)** runs a
recursive partition-refinement algorithm, `RePaRe`, over the **partition refinement lattice of the
variable set**, with a completeness theorem relative to refinement oracles, and defines
*interventional coarsening* as merging nodes indistinguishable with respect to the available
interventions. The vocabulary overlap with probe 7's pitch is near total, and the paper's own
keywords include "partition refinement lattice".

Three differences keep it from pre-empting us, and probe 7's report must state all three rather than
let a reader find them: it partitions variables where we partition the exogenous space; it learns
consistently in the sample limit from interventional data with unknown targets where we compute an
exact quotient of a known finite model; and its refinement is oracle-driven where ours returns a
replayable separating intervention. **The warning:** `RePaRe`'s carrier is a partition of the
variable set, which is exactly the carrier the exploration log says the `(u, I)` quotient *cannot
express*. If probe 7 pivots to the compositional route to make "these 27 states are one causal
variable" expressible, it is pivoting onto `RePaRe`'s carrier, and the novelty argument then has to
be made against `RePaRe` on the algorithmic axis alone. That is a real argument — exact versus
learned, witness-carrying versus oracle-driven — but it is a different argument from the one the plan
currently anticipates, and probe 7 should not start until it has been written down.

### Cross-cutting: no probe is cut, and one phrase is no longer ours to coin

Nothing in this audit kills a probe. The pre-emption that was most feared — a published exact engine
for the modified definition — exists, and the brief's pre-written consequence branch absorbs it
cleanly.

Two smaller adjustments:

- **"Bisimulation under intervention" is a published term** (Chakraborty, Caulfield & Pym 2025, with
  van Benthem–Bergstra–Hennessy–Milner correspondence theorems). Per the standing terminology rule,
  use their term rather than coining one, and cite them whenever the quotient is described as a
  bisimulation. What remains ours on that axis is the *minimisation algorithm and the separating
  witness*, not the equivalence notion.
- **Probe 9's demo must not claim application novelty.** Rafieioskouei & Bonakdarpour (IEEE TCAD
  2024, plus 2025 and 2026 follow-ups) already run abstraction-refinement Halpern–Pearl root-cause
  analysis over transition systems for cyber-physical safety violations, and Tanhaei's C-ADL
  (*Journal of Systems and Software*, 2026) embeds SCMs in an architecture description language for
  design-time root-cause analysis and counterfactual reasoning. Probe 9 remains a demonstration
  artifact, never evidence, and it should cite both rather than present the incident-to-repair story
  as new territory.
