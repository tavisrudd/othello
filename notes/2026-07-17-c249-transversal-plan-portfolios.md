# C249 transversal-robust plan portfolios

**Lane:** `rp-next`
**Status:** COMPLETE — strict application separation, novelty kill. Exact failure-domain
transversals beat action and TF--IDF diversity on four equal-cost remediation witnesses, and beat a
pairwise shared-risk metric on a higher-order witness. However, the objective is the direct
finite-plan form of established shared-risk/d-failure-resilient routing and hitting-set
interdiction. Retain it as an agentic-remediation objective and checker, not as a new planning
problem or a stand-alone theory paper.

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
