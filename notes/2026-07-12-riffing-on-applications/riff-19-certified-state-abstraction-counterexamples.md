# Certified counterexamples to state abstraction

Status: exploratory paper agenda  
Primary source: `RIFF_19`–`RIFF_21`, `RIFF_27`, `RIFF_42`  
Existing empirical base: S4 state dumps, feature miners, exact values, failed selector and
decomposition programs

## Thesis

State abstractions should be evaluated by two obligations: they must identify states related by
genuine invariances, and they must separate states whose optimal decisions differ. Exact
combinatorial games can provide certified abstraction collisions—states with the same proposed
summary but different values or required actions—and therefore support a stronger benchmark than
held-out prediction accuracy alone.

## Minimum publishable contribution

1. Release a curated set of exact abstraction collisions with independent value certificates.
2. Define evaluation metrics for unsafe collisions, valid invariance recovery, and refinement cost.
3. Benchmark representative tabular, graph, higher-order, and symmetry-aware encoders.
4. Demonstrate at least one counterexample-guided refinement method that removes a meaningful class
   of collisions without destroying valid invariance.

## Dataset design

Each record should include:

- full canonical state and ruleset parameters;
- exact outcome, nimber where available, and optimal-action orbit set;
- group orbit and stabilizer metadata;
- candidate abstraction/feature vector;
- collision-class identifier;
- smallest known relational witness separating opposing values;
- proof-DAG or raw-record validation reference.

Splits must be by orbit, configuration family, and field order. Random state splits would leak
symmetry-equivalent examples.

## Research agenda

### Phase 1 — Curate the negative-knowledge ledger

- Convert the work-summary's closed feature and selector paths into explicit abstraction classes.
- Extract minimal opposing-value pairs for each class.
- Distinguish a refuted single feature from a refuted closed feature language.
- Attach replay commands and hashes to every promoted collision family.

### Phase 2 — Establish baseline expressivity

- Tabular MLP over mined features.
- Incidence-graph message-passing network.
- Higher-order or subgraph GNN.
- Point/line transformer with explicit labels.
- Exact symmetry-quotient model.

### Phase 3 — Counterexample-guided refinement

- Cluster states in the learned representation.
- Search exact tables for same-cluster/opposite-decision pairs.
- Add the smallest separating relation or architectural channel.
- Track unresolved certified collisions rather than only accuracy.

### Phase 4 — Generalization test

- Hold out field orders and depleted/non-depleted classes.
- Measure calibration and collision rate under distribution shift.
- Test whether a model distinguishes true disjunctive decomposition from the refuted conic/zone
  decomposition.

## Paper spine

1. **Introduction:** abstractions can be accurate yet decision-unsafe.
2. **Exact game setting:** states, group actions, values, and certificates.
3. **Certified collision benchmark:** abstraction families and data construction.
4. **Metrics:** invariance, unsafe collision rate, calibration, and refinement complexity.
5. **Model comparison:** relational and symmetry-aware baselines.
6. **Counterexample-guided refinement:** method and ablations.
7. **Cross-parameter generalization:** what survives across `q`.
8. **Implications:** RL abstraction, causal representation, and theorem discovery.

## Shallow literature and novelty check

Closest precedents found:

- RL state abstraction and bisimulation already provide formal criteria for behavior-preserving
  aggregation; recent work continues to systematize which semantics abstractions preserve.
- Counterexample-guided abstraction refinement is mature in verification and has been used in
  planning and automata learning; for example, Aarts et al.,
  [Automata Learning Through Counterexample-Guided Abstraction Refinement](https://link.springer.com/chapter/10.1007/978-3-642-32759-9_4).
- Counterexample-guided learning also appears directly in constrained neural learning:
  [Counterexample-Guided Learning of Monotonic Neural Networks](https://arxiv.org/abs/2006.08852).

Preliminary verdict: **distinct benchmark opportunity, not a new abstraction theory**. The strongest
novelty is a corpus where collisions, values, valid symmetries, and required action differences are
all exact and independently certified, including closed negative feature languages and false
decompositions. The CEGAR loop itself cannot be claimed as new.

Required deeper audit:

- exact or adversarial benchmarks for bisimulation/state abstraction;
- representation “anti-invariance” and contrastive counterexample datasets;
- behavioral equivalence testing in deterministic games and planning.

## Kill criteria

- The collision corpus is too small or too specific to compare model classes.
- Labels cannot be distributed with independently replayable evidence.
- A simple omitted feature trivially resolves nearly all advertised collisions.
- The paper drifts into claiming general impossibility beyond the explicitly closed abstraction
  language.
