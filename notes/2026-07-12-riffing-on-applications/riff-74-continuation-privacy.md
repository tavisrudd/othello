# Continuation privacy and compatibility-oracle reconstruction

Status: exploratory paper agenda  
Primary source: `RIFF_74`–`RIFF_76`, `RIFF_150`, `RIFF_151`  
Existing mathematical base: continuation-graph rigidity and semilinear reconstruction program

## Mathematical spine

- [`MATH_12`](math.md#math_12--defining-querytransversal-duality) — minimum nonadaptive identifying
  queries are a transversal problem.
- [`MATH_13`](math.md#math_13--information-lower-bound-for-reconstruction) — response-tree counting
  gives the baseline adaptive query lower bound.
- [`MATH_14`](math.md#math_14--continuation-oracle-reconstruction-with-query-bounds) — efficient
  reconstruction for the four-frame continuation oracle is the open target.

## Thesis

An interface can conceal its internal object while leaking which proposed extensions remain valid.
For structured families, the accept/reject or continuation relation may reconstruct the hidden
topology, policy, code, or geometry. Continuation privacy measures how many adaptive observations
are required to distinguish or reconstruct the hidden structure, and how defensive response
coarsening trades diagnostic utility for privacy.

## Minimum publishable contribution

1. Define a precise compatibility-oracle model and attacker knowledge.
2. Prove reconstruction or distinguishing bounds for one restricted structured family.
3. Give an explicit query algorithm and matching or meaningful lower bound.
4. Evaluate at least one defensive mechanism: query restriction, response coarsening, noise, or
   decoy-compatible completions.

The first paper should stay close to a family already covered by continuation rigidity rather than
claim a universal API vulnerability.

## Research agenda

### Phase 1 — Threat model

- Hidden object family and prior public structure.
- Allowed adaptive queries.
- Response alphabet: accept/reject, error class, timing, or next-step prompt.
- Reconstruction target: exact labels, isomorphism class, sensitive substructure, or policy rule.

### Phase 2 — Restricted theorem

- Translate the four-frame continuation graph into an oracle experiment.
- Determine how much of the full graph an adaptive querier must observe.
- Bound query complexity using symmetry and canonical reconstruction.
- Separate information-theoretic identifiability from efficient reconstruction.

### Phase 3 — Defensive design

- Coarsen responses while preserving legitimate completion capability.
- Maintain several hidden objects consistent with every public trace.
- Measure ambiguity/completion distance after each query.
- Explore decoy traces only if they can be modeled without security theater.

### Phase 4 — Software analogue

- Build a synthetic authorization, configuration, or topology validator with known hidden structure.
- Test reconstruction and defenses end to end.
- Avoid real-system claims until disclosure and ethics procedures exist.

## Paper spine

1. **Introduction:** legality metadata is structural information.
2. **Continuation-oracle model and privacy definitions.**
3. **Structured hidden-object family.**
4. **Reconstruction theorem and query algorithm.**
5. **Lower bounds and ambiguity.**
6. **Defensive response mechanisms.**
7. **Synthetic system evaluation.**
8. **Security scope and open problems.**

## Shallow literature and novelty check

Closest precedents found:

- Model extraction from black-box prediction APIs is established:
  [Stealing Machine Learning Models via Prediction APIs](https://arxiv.org/abs/1609.02943).
- Hidden-graph reconstruction from restricted query oracles is an active graph-algorithm area; see
  [Graph Reconstruction via Distance Oracles](https://arxiv.org/abs/1304.6588) and
  [Graph Reconstruction with a Connected Components Oracle](https://arxiv.org/abs/2509.05002).
- Defenses that price or restrict information revealed by queries also exist in model-extraction
  research.

Preliminary verdict: **the security category is established; the oracle and theorem may still be
distinct**. Novelty must come from a continuation/feasible-extension oracle over a structured hidden
incidence object, sharp reconstruction or distinguishing bounds, and a quantified utility/privacy
tradeoff. Merely demonstrating that repeated accept/reject queries reveal a policy would overlap
model extraction and membership-query learning.

Required deeper audit:

- exact learning with membership/equivalence queries;
- active automata learning and policy inference;
- topology discovery, constraint acquisition, and API schema inference;
- query-based privacy definitions beyond differential privacy.

## Kill criteria

- Reconstruction requires essentially enumerating the complete hidden object, providing no oracle
  advantage.
- The theorem depends on an unrealistically generous query interface.
- Defensive mechanisms are equivalent to simply withholding all useful responses.
- The mathematical family is too remote from any plausible software interface to motivate the
  security framing.
