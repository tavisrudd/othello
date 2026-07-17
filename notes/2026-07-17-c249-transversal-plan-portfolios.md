# C249 transversal-robust plan portfolios

**Lane:** `rp-next`
**Status:** COMPLETE — strict application separation, novelty kill. Exact failure-domain
transversals beat action and TF--IDF diversity on four equal-cost remediation witnesses, and beat a
pairwise shared-risk metric on a higher-order witness. However, the objective is the direct
finite-plan form of established shared-risk/d-failure-resilient routing and hitting-set
interdiction. Retain it as an agentic-remediation objective and checker, not as a new planning
problem or a stand-alone theory paper. Follow-on analysis allocates C250--C253 around certificates,
empirical common modes, active fault discovery, and continuation resilience.

## Decision

Keep the following generation objective. Require each proposed plan to emit a checked set of
failure-domain dependencies, then choose a cost/quality-feasible portfolio maximizing the minimum
cost of a simultaneous domain failure that disables every plan.

Do not use action, text-embedding, domain-union, or pairwise domain distance as a robustness claim.
They remain useful secondary objectives. Do not claim novelty for failure-domain-aware diverse
planning: shared-risk routing already optimizes alternatives against common and multiple failures,
including the same minimum-attacker interpretation.

## Exact objective

Let `D(p)` be the nonempty set of failure domains whose individual failure disables plan `p`, and
let `w(d)>0` be domain-interdiction costs. For a portfolio `P`, define

```text
rho_w(P) = min { sum_{d in F} w(d) : F intersects D(p) for every p in P }.
```

Thus `rho_w(P)` is the weighted transversal number of the plan--domain incidence hypergraph. The
unit-cost experiment writes it as `tau(P)`.

> **Proposition (exact resilience dictionary).** A portfolio retains at least one executable plan
> after every failure set of cost strictly less than `B` if and only if `rho_w(P) >= B`.

This is immediate: all plans are disabled exactly when the failed domains form a transversal. For
unit costs, `P` survives every set of at most `r` failed domains exactly when `tau(P)>r`.

The bounded generation problem is therefore

```text
maximize    rho_w(P)
subject to  |P| = k,
            cost(p) <= C and quality(p) >= Q for every p in P,
            every p passes the ordinary plan validator.
```

Lexicographic secondary objectives may minimize total execution cost and then maximize behavioral
diversity. The dependency sets are proof obligations, not embeddings inferred from prose: an
untrusted generator should name the credentials, control planes, vendors, regions, transports, and
trust roots needed by each plan, and a small checker should validate those claims against the action
model.

## Bounded corpus and fair baselines

The certificate contains five four-plan selection cases:

- database recovery, credential revocation, service failover, and patch remediation each have
  eight candidate plans;
- cross-control remediation has nine candidates and a deliberately higher-order risk pattern.

Every candidate has exactly four actions and exactly three failure domains. Every selected
portfolio has four plans. The first four cases pair four surface-diverse plans sharing one hidden
control domain with four surface-similar plans on independent control, transport, and identity
islands. The fifth is a fixed 3-uniform incidence system. These are adversarial unit-test witnesses,
not a claim about the prevalence of such patterns in natural LLM output.

All `C(8,4)=70` or `C(9,4)=126` portfolios are enumerated. Every transversal is also enumerated.
The comparison reports the entire co-optimal set for each baseline, so the strict separations do not
depend on a favorable tie-break.

The baselines are:

1. action diversity: lexicographically maximize minimum, then total, pairwise action-set Jaccard
   distance;
2. embedding diversity: the same rule on deterministic normalized TF--IDF word vectors;
3. failure-domain union size;
4. domain-frequency balancing: minimize maximum frequency, then sum of squared frequencies;
5. pairwise risk diversity: lexicographically maximize minimum, then total, domain-set Jaccard
   distance;
6. the exact transversal objective.

TF--IDF is intentionally modest: the experiment tests whether a reproducible text embedding sees a
hidden operational common cause, not whether a particular neural encoder can memorize the fixture.

## Results

The entries are the range of exact `tau` among **all** portfolios optimal for that baseline.

| Case(s) | action | TF--IDF | union | frequency | pairwise risk | exact |
|---|---:|---:|---:|---:|---:|---:|
| four surface witnesses | `1--2` | `2` | `4` | `4` | `4` | `4` |
| cross-control | `1--3` | `1--3` | `1--3` | `2--3` | `2` | `3` |

Consequently:

- all four surface cases strictly separate exact robustness from action diversity, even granting
  action diversity its most robust co-optimal portfolio: `2 < 4`;
- all four strictly separate exact robustness from TF--IDF diversity: `2 < 4`;
- the risk-aware union, frequency, and pairwise metrics correctly find fully domain-disjoint
  portfolios on those easy cases;
- cross-control is the higher-order falsifier: every pairwise-risk-optimal portfolio has `tau=2`,
  while exactly three portfolios attain `tau=3`.

The last result is the blocker-theoretic gain. Pairwise distances only see two-plan overlaps; a
minimum transversal is a joint property of the whole portfolio. Union and frequency can contain an
exact winner among their ties, but neither certifies that it selected one.

The executable certificate is
[`2026-07-17-c249-transversal-plan-portfolios.py`](2026-07-17-c249-transversal-plan-portfolios.py),
and the complete corpus, co-optimal counts, scores, selected portfolios, and minimum-transversal
witnesses are in
[`2026-07-17-c249-transversal-plan-portfolios.json`](2026-07-17-c249-transversal-plan-portfolios.json).

## Literature and novelty boundary

The planning and routing literatures meet cleanly here.

- Srivastava et al., *Domain Independent Approaches for Finding Diverse Plans*,
  [IJCAI 2007](https://www.ijcai.org/Proceedings/07/Papers/325.pdf), already formulate diverse-plan
  generation through action-, state-, and causal-structure distances. C249's action baseline is a
  bounded set-selection version of that standard family, not a new baseline.
- Katz and Sohrabi, *Reshaping Diverse Planning*,
  [AAAI 2020](https://ojs.aaai.org/index.php/AAAI/article/download/6543/6399), explicitly separate
  plan quality guarantees from diversity metrics and select a required-size subset from generated
  plans. C249 follows that discipline by holding action cost and portfolio size fixed.
- Lee, Modiano, and Lee, *Diverse Routing in Networks With Probabilistic Failures*,
  [DOI 10.1109/TNET.2010.2050490](https://doi.org/10.1109/TNET.2010.2050490), model correlated
  failures by shared-risk groups and optimize a primary/backup pair for minimum joint failure
  probability. Deterministic SRLG-disjointness is exactly the single-common-risk special case.
- Zhang and Modiano, *Robust Routing in Interdependent Networks*,
  [arXiv:1709.03033](https://arxiv.org/abs/1709.03033), define two paths to be `d`-failure resilient
  when no removal of at most `d` supply nodes disables both. They also exhibit that counting shared
  risks can disagree with the actual minimum disabling set. On a finite candidate portfolio,
  C249's `tau-1` is precisely this adversarial resilience level, extended from two routes to `k`
  arbitrary plans.

The exact transversal formulation is still useful in planning because arbitrary remediation plans
are not network paths, and checked domain annotations provide a concrete agent interface. But that
is an application and systems translation. The robust-routing result satisfies C249's kill
condition: an established interdiction/diverse-routing baseline already owns the same frontier.

## Disposition

C249 passes its reproducible-separation gate and its generation-objective gate, but fails the new-
planning-problem gate. Preserve three artifacts:

1. `rho_w` as the exact portfolio robustness score;
2. the cross-control fixture as a regression test against pairwise diversity surrogates;
3. the proof-carrying dependency annotation as the product-facing interface.

Do not allocate a transversal-robust planning paper from these results. A future product experiment
would need real generated remediation plans, blinded domain annotation, neural-embedding baselines,
and execution/fault injection. That is an empirical validation task, not missing theory in C249.

## Follow-on analysis: what remains after the novelty kill

The static score is not the end of the useful route. It changes where the novelty must live. A
credible follow-on cannot be “minimal cut sets for plans”: reliability engineering already treats
minimal cut sets as the prime failure objects, and shared-risk routing already interprets the
minimum disabling set as adversarial resilience. The surviving seam is the **agent-facing evidence
boundary** between natural-language remediation, executable plan semantics, observed system
lineage, and an independently checked portfolio guarantee.

### Ranked adjacent approaches

#### 1. Proof-carrying common-cause remediation

The strongest adjacent object is a certificate bundle containing:

1. an ordinary plan-validity witness;
2. action-derived dependency provenance, with every dependency justified by a typed action rule or
   observed execution edge rather than asserted in prose;
3. an upper-bound witness when the attacker finds a cheap transversal; and
4. a proof log that no transversal below the claimed budget exists.

Planning already has formally verified validators and certifying algorithms. Abdulaziz--Koller give
a formally verified temporal-plan validator
([DOI 10.1609/aaai.v36i9.21197](https://doi.org/10.1609/aaai.v36i9.21197)); Mugdan--Christen--Eriksson
give optimality certificates
([DOI 10.1609/icaps.v33i1.27206](https://doi.org/10.1609/icaps.v33i1.27206)); and the 2025--2026
agentic PDDL pipeline already places ordinary validators behind LLM-produced planning abstractions
([arXiv:2512.09629](https://arxiv.org/abs/2512.09629)). The open-looking combination is not plan
validation alone, but **dependency completeness plus a portfolio-wide common-cause lower bound**.

The bounded technical route is concrete. Compile “there exists a failure set of cost `< B` that
hits every plan” to pseudo-Boolean SAT. A satisfying assignment is a cheap attack; an
unsatisfiability proof is a resilience certificate checked by a small proof logger/checker such as
the general VeriPB architecture ([project](https://veripb.org/)). The hard and potentially novel
part is proving that the plan-to-dependency compilation is complete for the declared action model.

#### 2. A real common-mode remediation benchmark

The synthetic C249 corpus is only a unit test. A useful empirical object would generate remediation
plans across models, agent architectures, prompt/specification variants, tool sets, and planning
languages, then execute them under hidden credential, control-plane, region, vendor, network, and
trust-root failures. Domain annotations must be blinded to the portfolio selector and audited
against traces or fault injections.

This is now sharply adjacent to Ron--Baudry--Monperrus, *N-Version Programming with Coding Agents*
([arXiv:2606.20158](https://arxiv.org/abs/2606.20158)). Their 48 implementations and one-million-test
campaign find substantial agent common-mode failure, often at ambiguous or difficult parts of the
shared specification, while also finding real benefit from three-version voting. That closes a
generic “multiple AI agents improve reliability” claim. It does **not** yet answer whether
pre-execution causal portfolio selection beats model/language/prompt diversity for remediation
plans, or whether a small dependency certificate predicts injected coincident failures.

#### 3. Continuation rather than initial-state resilience

C249 assumes every alternative remains available. Real remediation consumes credentials, mutates
state, changes routing, and may cross irreversible boundaries. Define a prefix-indexed score

```text
rho_cont(P) = min over reachable execution prefixes s of
              minimum failure cost disabling every valid continuation from s.
```

Switching cost, compensation, and shared destructive prefixes then become first-class. A portfolio
can have large initial `rho_w` but collapse after one common step. Generic contingent planning,
fault-tolerant planning, plan repair, and workflow compensation are mature, so novelty would require
an exact state-indexed blocker law or compact certificate, not the observation that plans should
adapt. Stonebraker--Zhou--Kraft--Li's 2026 AC/DC workflow program already combines durable execution,
physical backout, and saga compensation
([CIDR 2026](https://www.vldb.org/cidrdb/2026/consistency-and-correctness-in-data-oriented-workflow-systems.html));
it is a mandatory boundary for this route.

#### 4. Counterexample-guided common-cause discovery

When the dependency model is incomplete, alternate:

1. propose a portfolio and its current dependency proof;
2. search for the cheapest modeled disabling scenario;
3. inject or simulate that failure;
4. refine the dependency model or portfolio from the counterexample.

The loop itself is not new. Dawson--Fan alternate robust planning with adversarial falsification
([arXiv:2203.02038](https://arxiv.org/abs/2203.02038)), and adversarial planning already studies
static and adaptive removal of planning actions
([arXiv:2205.00566](https://arxiv.org/abs/2205.00566)). The remaining opportunity is a
proof-producing, plan-portfolio-specific loop in which each injected failure either invalidates a
dependency claim or shrinks the set of portfolio-relevant uncertain models.

## Second brainstorm from new perspectives

The following pass deliberately starts outside diverse planning.

### Reliability engineering: success trees, not self-reported labels

Fault-tree analysis identifies minimal cut sets, while the dual success-tree view identifies
minimal sets of functioning components. C249's family `{D(p) : p in P}` is already a particularly
simple success structure. Automatic cut-set generation by model checking is established
([Kromodimoeljo--Lindsay, arXiv:1506.03555](https://arxiv.org/abs/1506.03555)).

**New seam:** compile each action's preconditions, effects, compensations, and environmental
assumptions into a plan success tree, then preserve enough provenance to explain the portfolio's
minimal cut sets. The result should be marketed as an agent-to-safety-analysis compiler, not as new
cut-set mathematics.

### Distributed systems and chaos engineering: test the missing lineage

Alvaro et al.'s Lineage-Driven Fault Injection converts successful outcome lineage to SAT, injects
candidate failure combinations, and either finds a counterexample or exhausts the bounded
falsifiers ([MOLLY/LDFI paper](https://people.ucsc.edu/~palvaro/molly.pdf)). This is extremely close
to C249's proposed attacker/checker and rules out a broad novelty claim for SAT-guided fault
injection.

**New seam:** plans are *prospective alternatives* produced by untrusted agents, whereas LDFI
analyzes derivations in an executing distributed program. Join declared plan provenance with
observed lineage, and target tests only at discrepancies that could change which portfolio
maximizes `rho_w`. This “decision-focused LDFI” is narrower than full fault-space exhaustion and is
directly falsifiable against LDFI and random chaos baselines.

### Causal experimental design: learn only decision-relevant dependencies

Wang et al. actively inject faults to learn unknown microservice communication/error-propagation
graphs and use them for fault localization
([DOI 10.1609/aaai.v37i13.26868](https://doi.org/10.1609/aaai.v37i13.26868)). Full causal-graph
recovery may be unnecessary for portfolio selection.

**New seam:** maintain a version space of dependency hypergraphs and choose the next intervention
to distinguish only models whose optimal remediation portfolios differ. The target is fewer
injections to certify the same portfolio decision, not a more accurate global causal graph. Compare
against random injection, coverage, LDFI hazard search, and generic active causal discovery.

### Transactional workflows: the fallback itself can need repair

Saga compensation and durable execution show that an action's failure semantics include both its
forward effect and whether its compensation remains executable. A fallback portfolio that shares
an orchestrator, compensation service, idempotency key store, or audit log may have a hidden common
cause after partial execution even when its initial plans are domain-disjoint.

**New seam:** model forward and compensating actions symmetrically and compute continuation
resilience over the combined workflow state. The smallest worthwhile witness must strictly separate
initial `rho_w`, ordinary strong/strong-cyclic success, and compensation-aware continuation
resilience.

### Security games: useful attacker models, low novelty

Attack-graph countermeasure selection already optimizes defensive controls under budget and models
attacker/defender action costs; see Stan et al.
([arXiv:1906.10943](https://arxiv.org/abs/1906.10943)) and Soikkeli--Muñoz-González--Lupu
([arXiv:1904.03082](https://arxiv.org/abs/1904.03082)). A Stackelberg or moving-target restatement of
C249 is therefore unlikely to be novel.

**Possible import:** use adaptive attackers, recovery cost, and collateral action cost as baselines
for continuation resilience. Do not allocate a generic security-game formulation.

### Specification diversity: diversify assumptions before implementations

The coding-agent N-version result locates many common failures in shared specification ambiguity.
Operational plans likewise share implicit assumptions about authority, observability, naming,
freshness, and rollback. Merely switching models or prompts does not diversify those assumptions.

**New seam:** require each plan to emit a compact assumption ledger and select a portfolio that
covers competing interpretations of unresolved requirements. This is likely a benchmark feature,
not a stand-alone theory: conformant/robust planning under model uncertainty is mature, and the
novel evidence would have to be empirical reduction of common-mode remediation failures.

### Human and organizational domains: sociotechnical common causes

Credentials and cloud regions are not the only domains. Approval chains, on-call ownership,
vendor escalation, maintenance windows, shared runbooks, and the same human reviewer can disable
otherwise disjoint technical plans.

**New seam:** extend the benchmark annotation schema to sociotechnical dependencies and test
whether purely technical portfolio selection overstates resilience. Human-reliability and common-
cause analysis are established, so this is an operational extension rather than a mathematical
novelty claim.

## Promoted follow-on queue

The follow-ons are allocated in expected-value order:

1. **C250 — proof-carrying remediation portfolios.** Build the typed dependency semantics and an
   independently checked lower-bound certificate. This decides whether there is a defensible formal
   object beyond fault-tree/LDFI repackaging.
2. **C251 — agent remediation common-mode benchmark.** Use C250's schema to test model, prompt,
   language, tool, specification, and assumption-ledger diversity under blinded fault injection.
3. **C252 — decision-focused active fault discovery.** Learn only the uncertain dependency edges
   that can change the selected robust portfolio; compare against LDFI, generic causal discovery,
   coverage, and random injection.
4. **C253 — compensation-aware continuation resilience.** Test whether a state-indexed blocker
   invariant adds anything beyond contingent planning, fault-tolerant planning, and durable saga
   semantics.

Security games, probabilistic SRLGs, generic N-version agents, generic fault trees, and generic
counterexample-guided planning remain citation-only imports. They are not separate tasks.
