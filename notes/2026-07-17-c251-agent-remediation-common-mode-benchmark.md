# C251 agent-remediation common-mode benchmark

**Lane:** `rp-next`
**Status:** COMPLETE — the deterministic blinded fixture passes its synthetic gate, but does not
establish an empirical agent or production-system advantage. Certified causal selection has zero
coincident failures in both strata while every surface/generation baseline has a strictly positive
best-tie rate. The result is a benchmark construction and falsifiable hypothesis, not evidence that
real annotations are reliable.

## Decision

Retain the executable corpus as the C250 annotation contract's first fault-injection test and as a
fixture for C252. Do not claim that certified causal portfolio selection beats N-version or
embedding diversity on real agent-generated remediations. That claim requires independently
generated plans, independent blinded annotation, and intervention on an external execution system.

The useful controlled finding is narrower: equal marginal plan risk and conspicuous diversity along
model, prompt, language, tool, text, and action axes do not determine common-mode risk. When the
hidden causal incidence differs, exact transversal selection can separate portfolios that all the
surface metrics prefer in the other direction.

## Executable corpus and blinding

The corpus contains two matched eight-plan scenarios:

1. four surface-diverse plans share an operational control-plane dependency;
2. four surface-diverse plans share one ambiguous interpretation of the target specification.

Each scenario also contains four surface-similar plans whose pairs of dependencies are disjoint.
The eight hidden domains cover credential, control plane, region, vendor, transport, trust root,
specification ambiguity, and a sociotechnical approval chain. Every plan has cost one and exactly
two dependencies, so every selector sees the same portfolio cost and every selected portfolio has
the same `5/12` mean per-plan failure rate over the campaign. The causal advantage therefore cannot
come from choosing individually safer plans.

Selectors see either public plan metadata or opaque names such as `fd_a`. The executable freezes
the complete maximizing set for every selector before consulting a separate execution lineage and
hidden label manifest. It hashes the hidden manifest into the result but does not disclose it to a
selector. The campaign exhausts all eight singleton and all 28 pair injections in each scenario.

The compared selectors are:

- exact unit-cost transversal number on C250-style opaque typed lineage;
- action vocabulary diversity;
- bag-of-words/Jaccard embedding proxy diversity;
- joint model, prompt, language, and tool-axis diversity;
- the same generation-axis selection with majority voting, only for a non-state-changing binary
  verdict; and
- the exact mean over all 70 equal-cost portfolios as the random baseline.

All maximizing ties are retained. The gate compares the causal selector's worst maximizing tie
with each baseline's best maximizing tie, so ordering or a favorable secondary tie-break cannot
create the separation.

## Results

Both strata give the same coincident-failure rates over 36 injections:

| selector | maximizing ties | best coincident rate | worst coincident rate |
|---|---:|---:|---:|
| certified causal | 1 operational / 2 specification | `0/36` | `0/36` |
| action diversity | 1 | `8/36` | `8/36` |
| embedding proxy | 17 | `2/36` | `8/36` |
| generation axes | 5 | `2/36` | `8/36` |
| N-version axes | 5 | `2/36` | `8/36` |
| random, exact population mean | 70 portfolios | `1/24` | not a tie range |

For majority failure, the causal range is again zero; action diversity is `8/36`, and the best
embedding/generation/N-version tie is also `8/36`. Thus the strict result survives the voting
threshold where voting is semantically permitted. Voting is not assigned semantics for competing
state-changing remediations.

The declared C250 lineage and the separately stored execution lineage agree in all 128
plan-by-domain cells (`kappa=1`) and all 16 plans. A mutation deleting one executed dependency is
detected. This is only a fixture-integrity test: both ledgers were authored from the same synthetic
causal design. It cannot validate annotation reliability in the field.

Run the checked benchmark with:

```sh
python3 notes/2026-07-17-c251-agent-remediation-common-mode-benchmark.py --emit
```

Artifacts:

- [`2026-07-17-c251-agent-remediation-common-mode-benchmark.py`](2026-07-17-c251-agent-remediation-common-mode-benchmark.py)
- [`2026-07-17-c251-agent-remediation-common-mode-corpus.json`](2026-07-17-c251-agent-remediation-common-mode-corpus.json)
- [`2026-07-17-c251-agent-remediation-common-mode-results.json`](2026-07-17-c251-agent-remediation-common-mode-results.json)

## Literature boundary

The benchmark's ingredients are established; only the particular controlled comparison is being
retained.

- Ron, Baudry, and Monperrus test 48 agent-generated implementations on one million inputs. They
  find substantial common-mode failure concentrated around difficult or ambiguous specification
  regions, while three-version majority voting still reduces mean failures
  ([arXiv:2606.20158](https://arxiv.org/abs/2606.20158)). This closes any generic claim that agent or
  language diversity cannot help, and makes shared-specification faults mandatory here.
- Classical diverse planning already studies action-set metrics, their pathologies, interaction
  with plan length, and information/compression-based alternatives
  ([Roberts--Howe--Ray 2014](https://ojs.aaai.org/index.php/ICAPS/article/view/13649),
  [Goldman--Kuter 2015](https://ojs.aaai.org/index.php/AAAI/article/view/9669)). C251 does not
  introduce a new plan-diversity metric; it tests whether those proxies track a hidden failure
  objective.
- APB separates planning from execution and tests robustness to extraneous tools, broken tools, and
  infeasible tasks across 4,209 cases
  ([arXiv:2606.04874](https://arxiv.org/abs/2606.04874)). AgentRx provides 115 manually annotated
  failed trajectories including incident management and an auditable diagnostic pipeline
  ([arXiv:2602.02475](https://arxiv.org/abs/2602.02475)). Those are stronger real-agent evaluation
  models than this synthetic corpus.
- Chaos engineering frames controlled perturbation as an attempt to falsify a steady-state
  hypothesis under realistic events
  ([Principles of Chaos Engineering](https://principlesofchaos.org/)). MOLLY/LDFI reasons backward
  from outcome lineage, uses SAT to choose injections, and can exhaust bounded candidate failures
  ([Alvaro--Rosen--Hellerstein 2015](https://people.ucsc.edu/~palvaro/molly.pdf)). C251 neither
  replaces chaos practice nor improves LDFI's injection search.
- Standard validators already separate a plan from its validity judgment; formally verified
  temporal validation is practical
  ([Abdulaziz--Koller 2022](https://ojs.aaai.org/index.php/AAAI/article/view/21197)). The execution
  oracle here is deliberately outside the selector and is not a new validator.

## Gate disposition

The synthetic success gate passes: the run is blinded at the selector boundary, deterministic,
stratified by operational versus specification common modes, annotation-consistent, and strictly
separates the causal selector without a tie-break. The empirical gate remains unpassed. The
fixture's causal truth was designed, not independently discovered, and the bag-of-words proxy is
not a neural embedding baseline.

Accordingly, retain the corpus and exact negative control, but phrase the conclusion as a benchmark
hypothesis: *if independently audited causal annotations predict injected outcomes, exact portfolio
selection can reduce common-mode failure missed by generation-axis diversity.* C252 may use this
fixture only as a unit test before testing decision-focused discovery under hidden, incomplete
lineage.
