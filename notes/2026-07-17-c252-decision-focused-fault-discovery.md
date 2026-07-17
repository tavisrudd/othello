# C252 decision-focused active fault discovery

**Lane:** `rp-next`
**Status:** COMPLETE — synthetic sample-advantage gate passes; novelty gate fails. On an exact
16-model hidden-lineage fixture, decision-focused acquisition certifies a correct robust portfolio
in one singleton intervention for every truth, versus two for full-graph information gain and
coverage, `4.5` in expectation for uniform random order, and eight for a frozen incomplete-lineage
LDFI-style hazard enumeration. The acquisition rule is, however, a direct finite specialization of
established targeted active learning/value of information on the optimal decision. Retain the
fault-injection application and regression fixture, not a new learning algorithm or theory paper.

## Decision

Use decision-focused experimental design when fault injections are expensive and the operational
question is which remediation portfolio to deploy. Maintain a version space of dependency
hypergraphs, but learn only enough to prove that one portfolio is optimal in every surviving model.

Do not call this a new active causal-discovery objective. Expected information gain on the posterior
optimal decision is already an explicit targeted-active-learning criterion. The new content here is
the exact repair-portfolio instantiation and its comparison fixture.

## Exact finite formulation

Let `V` be a finite set of possible plan--dependency hypergraphs. For `G in V`, let `Opt(G)` be the
set of size-`k` portfolios maximizing C249's exact transversal resilience `rho_w`. A fault injection
`e` has deterministic observation `o_e(G)`, here the complete vector of plans disabled by one
failed domain. After observing `y`, update exactly:

```text
V <- { G in V : o_e(G) = y }.
```

The experiment may stop with a checked portfolio precisely when

```text
intersection { Opt(G) : G in V } is nonempty.
```

Any member of the intersection is optimal for the unknown true graph. This is a stronger and more
operational stop rule than recovering a unique graph: nuisance uncertainty may remain.

Under the fixture's uniform prior, the decision-focused acquisition is

```text
argmax_e  H(Opt(G) | observations)
          - E_y H(Opt(G) | observations, o_e(G)=y).
```

The full-graph baseline replaces `Opt(G)` by `G`. Coverage follows the frozen C251 domain order.
Uniform random uses all `8!` domain orders. The LDFI-style row enumerates singleton hazards from one
corrupted declared lineage, then covers the omitted domains; it compares objectives and is not a
reimplementation of MOLLY.

## Fixture

The experiment imports only C251's operational plan and opaque domain names. It creates a complete
`2 x 8` version space:

- one decision bit changes only the incidence of `fd_b`; in one state the C251 causal quartet is the
  unique optimum, while in the other state a distinct family of seven portfolios attains optimum
  resilience four;
- one independent nuisance variable chooses which of the eight plans depends on `fd_h`;
- moving `fd_h` changes the graph and injection outcome but never changes the optimum;
- every singleton intervention costs one and returns the full failed-plan vector;
- all `C(8,4)=70` portfolios and all transversal scores are recomputed exactly in every model.

Thus `fd_h` yields three bits of graph information and no decision information, while `fd_b` yields
one bit and completely resolves the portfolio decision. Other singleton observations resolve
neither.

## Results

All adaptive policies use the same observations, exact version-space update, costs, and certified
stop rule.

| acquisition policy | interventions, all 16 truths | mean | worst |
|---|---:|---:|---:|
| decision-focused optimal-portfolio information | `1` | `1.0` | `1` |
| full-graph information gain | `2` | `2.0` | `2` |
| frozen domain coverage | `2` | `2.0` | `2` |
| uniform random domain order | uniform on `1..8` | `4.5` | `8` |
| incomplete-lineage LDFI-style hazard enumeration | `8` | `8.0` | `8` |

Decision-focused acquisition chooses `fd_b` immediately and leaves all eight nuisance models live.
The common-optimum certificate is nevertheless exact. Full-graph information gain first chooses
`fd_h`, collapses eight nuisance states, and only then chooses `fd_b`. This is the intended strict
separation between learning the dependency graph and learning the deployment decision.

The LDFI-style result must be read narrowly. LDFI reasons backward from observed lineage to generate
fault combinations capable of falsifying an outcome; it is not designed to repair a deliberately
omitted dependency model. The eight-step row shows the failure mode of exhaustive hazard order under
incomplete prospective lineage, not that this toy policy dominates MOLLY on its native program-
verification task.

Executable artifacts:

- [`2026-07-17-c252-decision-focused-fault-discovery.py`](2026-07-17-c252-decision-focused-fault-discovery.py)
- [`2026-07-17-c252-decision-focused-fault-discovery-results.json`](2026-07-17-c252-decision-focused-fault-discovery-results.json)

Run with:

```sh
python3 notes/2026-07-17-c252-decision-focused-fault-discovery.py --emit
```

## Literature boundary

The boundary is decisive.

- Filstroff et al., *Targeted Active Learning for Bayesian Decision-Making*, explicitly maximize
  expected information gain on the posterior distribution of the optimal downstream decision and
  contrast it with learning the whole predictive model
  ([arXiv:2106.04193](https://arxiv.org/abs/2106.04193)). C252's acquisition is exactly its finite,
  noiseless version with `Opt(G)` as the decision random variable. This triggers the kill condition.
- Huang et al., *Amortized Bayesian Experimental Design for Decision-Making*, likewise optimize
  experiments for downstream decision utility rather than parameter information
  ([arXiv:2411.02064](https://arxiv.org/abs/2411.02064)). The idea is active through modern
  decision-aware experimental design, not a dormant naming coincidence.
- He and Geng's active causal-network design minimizes candidate structures using minimax and
  maximum-entropy interventions
  ([JMLR 2008](https://www.jmlr.org/papers/v9/he08a.html)). This owns the full-graph baseline rather
  than the downstream-decision target.
- Wang et al. already use programmable fault injections and logs to learn an error-propagation
  causal graph for distributed applications, with fault localization as a downstream task
  ([AAAI 2023](https://ojs.aaai.org/index.php/AAAI/article/view/26868)). C252 changes what uncertainty
  the intervention targets; it does not introduce fault-injection causal learning.
- Alvaro, Rosen, and Hellerstein's MOLLY alternates concrete faulty executions with SAT search over
  lineage-derived falsifiers until it finds a failure or exhausts the bounded space
  ([SIGMOD 2015 paper](https://people.ucsc.edu/~palvaro/molly.pdf)). Decision invariance is a distinct
  stop objective, but the broad lineage-guided fault-search loop is established.
- Counterexample-guided robust planning already alternates plan optimization and adversarial
  falsification ([Dawson--Fan 2022](https://arxiv.org/abs/2203.02038)). C252's version-space update is
  therefore not a novel counterexample-guided planning architecture.
- Chaos engineering deliberately injects realistic events to falsify steady-state hypotheses and
  recommends prioritizing events by impact or frequency
  ([Principles of Chaos Engineering](https://principlesofchaos.org/)). Domain coverage is a modest
  reproducible baseline here, not a claim to represent full chaos practice.

## Gate disposition

The bounded sample gate passes exactly, including strict separation from every required baseline
under the declared equal-cost policy definitions. The novelty gate fails because targeted active
learning already optimizes the same query.

Retain three product-facing pieces:

1. the common-optimum intersection as a proof-producing stop certificate;
2. optimal-portfolio information gain as the correct acquisition translation;
3. the nuisance-versus-decision fixture as a regression test against graph-recovery objectives.

Do not allocate a decision-focused active-learning paper from C252. A credible empirical follow-up
would need independently generated candidate plans, an externally sourced dependency version
space, noisy/repeated interventions with realistic unequal blast-radius costs, and a faithful LDFI
implementation on the same executable system. The current authored simulator proves only that the
objective distinction can create an exact sample advantage.
