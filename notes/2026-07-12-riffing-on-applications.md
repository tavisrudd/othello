# Riffing on applications

Verbatim archive of application brainstorms, with stable IDs added to each numbered idea.

The strongest commercial thread is not “sell the finite-geometry theorems.” It is to extract the machinery they produced: measuring hidden shared dependencies, solving highly symmetric combinatorial searches, and returning independently checkable evidence.

My rough ranking:

1. Shared-dependency resilience analysis
2. Proof-carrying combinatorial search
3. Repair-code analysis/compiler
4. Symmetry-aware solver infrastructure
5. ML/RL research platform for exact, symmetry-rich reasoning
6. Robust design and reconstruction tools


**RIFF_1**

## 1. Shared-dependency resilience analyzer

This seems like the clearest product-shaped idea.

The completion and repair work distinguishes several notions that operational tools often conflate:

- How many alternative recovery paths exist?
- How many are disjoint?
- What is the smallest set of failures that disables all alternatives?
- How much of a configuration can be deleted while leaving a unique completion?
- Which apparently diverse alternatives secretly share the same dependencies?

The repair hypergraph gives a natural model:

- Vertices: resources, services, suppliers, zones, credentials, maintainers, data sources, etc.
- Hyperedges: valid repair or recovery alternatives.
- `ν`: maximum number of mutually disjoint alternatives.
- `τ`: minimum failure set intersecting every alternative.
- `δ`: minimum deletion needed to reach an alternative completion or create ambiguity.

Potential markets:

- Kubernetes/cloud failover analysis
- Software supply-chain and SBOM risk
- Multi-cloud “independence” audits
- Manufacturing supplier resilience
- Network route and disaster-recovery audits
- Key custody and account-recovery systems
- Data pipelines with nominally redundant sources
- Incident-response runbooks

The important commercial message would be:

> Counting paths, replicas, regions, or providers overstates resilience when those alternatives share hidden dependencies.

A useful first product would ingest a relatively explicit dependency model—Terraform, Kubernetes manifests, CI pipelines, or manually supplied recovery recipes—and produce:

- minimal correlated cut sets;
- misleading-redundancy examples;
- the `τ/ν` gap;
- resources appearing in every minimal repair family;
- recommended changes that increase `τ`, not merely path count;
- small, replayable failure certificates.

The twisted-cubic examples where `τ` is not determined by representation count or disjoint availability are especially useful as adversarial test cases. The commercial challenge is extracting an accurate dependency hypergraph; once that exists, your mathematics offers more discriminating metrics than a dashboard that merely counts alternatives.


**RIFF_2**

## 2. Proof-carrying combinatorial search

The repo already contains much of the architecture for a general “solve, compress, independently verify” system:

- a finite constraint/game model;
- symmetry quotienting;
- exact search and transposition storage;
- queryable tablebases;
- conjecture mining;
- certificate extraction;
- independent proof-DAG validation;
- Lean checking for promoted results.

This could become a platform for finite search problems where customers care as much about auditability as the answer:

- scheduling and allocation;
- configuration safety;
- protocol-state exploration;
- combinatorial design;
- hardware-state verification;
- adversarial planning;
- small cryptographic searches;
- exhaustive scientific classification.

The key separation is commercially attractive:

```text
fast, highly optimized solver
        ↓
compact witness/certificate
        ↓
small independent checker
        ↓
optional Lean theorem
```

Customers would not need to trust the complicated high-performance solver. They would trust a much smaller checker, possibly with a formal theorem connecting the checker to the business claim.

A realistic product should initially support one narrow problem family. A universal combinatorial DSL plus automatic Lean proofs would be an enormous undertaking. But a vertical platform—for example, proof-carrying recovery analysis or proof-carrying code construction—is plausible.


**RIFF_3**

## 3. Repair-code analyzer or compiler

The coding work has an unusually concrete systems interpretation. Conventional LRC descriptions often emphasize:

- locality;
- number of repair sets;
- availability;
- minimum distance.

Your complete repair-hypergraph perspective asks a stronger question: what is the structure of all low-weight repairs, and how vulnerable are they to shared failures?

Possible tool:

```text
desired rate, alphabet, distance, locality,
failure-domain model, repair-radius bound
                    ↓
candidate code/construction
                    ↓
complete low-radius repair hypergraph
                    ↓
τ, ν, correlated-failure analysis
                    ↓
machine-checkable certificate
```

Potential users include distributed storage, archival systems, edge storage, and coded distributed computation.

The bounded-repair transfer lemma is especially interesting as compiler infrastructure: it allows a finite inner seed with desirable repair structure to be lifted into asymptotically good families while preserving the complete bounded-radius repair hypergraph locally. That resembles a reusable “construction primitive,” not just an isolated theorem.

Differentiation from existing coding software would be:

- optimize against a real failure-domain model;
- analyze all small repairs, not only advertised repair groups;
- detect hidden repair correlations;
- provide proof artifacts for distance/locality claims.

This is technically strong but commercially harder than the resilience analyzer: deploying a new code has substantial engineering, compatibility, and decoder-performance costs. An analyzer for existing codes may be the better entry point.


**RIFF_4**

## 4. A symmetry-aware exact-search library

Several techniques appear reusable well beyond these games:

- canonicalization under large automorphism groups;
- orbit-representative move generation;
- quotient-key transposition tables;
- residualization after constraints saturate;
- exact dense leaf tables;
- compact probabilistic/value stores for mining;
- early-break proof-DAG checking;
- HyperLogLog sizing before committing to a solve;
- solver-lineage differential testing.

A library could expose problems as:

- finite objects or states;
- legal extensions;
- a group action;
- a terminal/value recurrence;
- optional incremental slack or conflict updates.

The engine then supplies quotient search, memoization, orbit statistics, certificates, and an interactive state-query interface.

Best-fitting domains:

- combinatorial design enumeration;
- chemical graph enumeration;
- code equivalence and classification;
- finite-model finding;
- constraint games;
- small protocol state spaces;
- exact puzzle solving and generation.

Two particularly interesting algorithmic ideas are worth separating.

**RIFF_5**

### Lossy tablebases for scientific mining

Using BuRR lossily as a value store is inappropriate for authoritative play, but potentially excellent for hypothesis discovery:

1. Search an otherwise unaffordable state space approximately.
2. Mine candidate invariants or selectors.
3. Replay candidates against exact raw states.
4. Promote only independently checked claims.

That approximate-discovery/exact-verification split could be useful in enumeration-heavy science.

**RIFF_6**

### Saturated-residual compilation

The building-avoidance formulation suggests a general compiler:

```text
capacity-constrained incidence system
        ↓ saturate constraints incrementally
residual conflict graph/hypergraph
        ↓
Node-Kayles / independent-set search machinery
```

The underlying data structure would maintain:

- remaining slack per constraint;
- incident constraints per point;
- newly forbidden moves when slack hits zero;
- residual conflicts as bitsets;
- symmetry information carried through residualization.

That could unify packing, scheduling, avoidance games, and finite-geometry searches in one solver substrate.


**RIFF_7**

## 5. ML and RL applications

This may be the richest research direction, even if it is not the fastest commercial one.

**RIFF_8**

### Exact tablebases as high-quality training data

The states provide more than binary win/loss labels:

- exact Grundy values;
- remoteness;
- winning-move sets;
- number and diversity of successful replies;
- symmetry orbits;
- stabilizer sizes;
- proof/certificate structure;
- known feature collisions;
- transitions across different field orders or board sizes.

That supports experiments in:

- minimax value learning;
- learned move ordering;
- policy distillation;
- algorithmic generalization across `q` or `n`;
- symmetry-equivariant networks;
- uncertainty calibration;
- neural-guided exact search.

Because exact search remains the authority, an ML policy can improve ordering without compromising correctness.

**RIFF_9**

### A particularly good representation-learning benchmark

The odd-plane work has already established that many natural handcrafted representations are insufficient: states with the same summarized features can have opposite values, and some selectors are provably impossible within the tested feature space.

That makes the dataset valuable for representation research. One can distinguish:

- states equivalent under group action, which must have identical embeddings or outputs;
- superficially identical feature summaries with different values, which must remain distinguishable;
- the same geometric configuration embedded at different `q`, where naive finite-state transfer fails;
- local patterns whose values depend on globally labelled live-cell embeddings.

A useful loss could combine:

\[
L =
L_{\mathrm{value}}
+\lambda_{\mathrm{orbit}}L_{\mathrm{orbit}}
+\lambda_{\mathrm{collision}}L_{\mathrm{collision}}
+\lambda_{\mathrm{Bellman}}L_{\mathrm{Bellman}}.
\]

Here:

- `L_value` fits exact outcome, nimber, or remoteness;
- `L_orbit` forces invariance under genuine geometric symmetries;
- `L_collision` prevents collapse of known same-feature/opposite-value pairs;
- `L_Bellman` penalizes disagreement with the exact game recurrence.

This is more meaningful than generic augmentation: the repository supplies both positive invariances and concrete negative examples showing which abstractions must not be invariant.

**RIFF_10**

### Hierarchical RL policy

The live packet/absorption strategy naturally suggests a hierarchical policy:

1. Select a pencil or packet.
2. Select a center within that packet.
3. Respond adaptively after observing the opponent’s move.

This is more promising than asking a network to choose directly among all points. The high-level action can be symmetry-quotiented, while the low-level policy handles the labelled embedding that the failed static selectors missed.

Training targets could include:

- probability of preserving a winning response;
- worst-case rather than average child value;
- remoteness among winning moves;
- strategy freedom—the number of robust replies remaining;
- stabilizer/orbit information as auxiliary targets.

**RIFF_11**

### Learned potential functions as conjecture generators

The conic ledger resembles a Lyapunov or amortized-analysis certificate. That suggests training a model to discover potentials satisfying local inequalities such as:

\[
\Phi(s')-\Phi(s) \le b(s,a,s')
\]

over all relevant opponent-response packets.

A practical loop would be:

1. Fit a sparse linear, symbolic, or small neural potential to exact transitions.
2. Search aggressively for violations.
3. Add counterexamples.
4. Distill the result into a small inequality or piecewise formula.
5. Prove the distilled formula in Lean.

This could become a general neural-to-formal workflow for discovering amortized proofs. Sparse integer coefficients are preferable to opaque networks because the end goal is a theorem.

**RIFF_12**

### Differentiable robustness objectives

For recovery systems or code design, an ML objective could target an approximation to transversal robustness rather than path entropy or raw availability.

For a learned routing/repair policy:

- sample or adversarially optimize small failure sets;
- penalize when every repair option intersects the chosen failures;
- reward increases in the minimum hitting-set size;
- separately penalize concentration on common underlying resources.

This is essentially adversarial dropout over shared dependency domains. It would operationalize the repo’s recurring observation that many alternatives do not imply resilience.

**RIFF_13**

### Mex-aware learning

Grundy values offer a richer target than win/loss. A predicted nimber must satisfy:

- no child has the same nimber;
- every smaller nimber occurs among the children.

Those conditions can become auxiliary structural losses rather than treating nimber prediction as ordinary multiclass classification. A model that predicts the right label for the wrong structural reasons will violate the mex constraints and can be detected.


**RIFF_14**

## 6. Robust experimental design and unique completion

The completion-core theory can be read as a general theory of reconstructing a maximal design after deletions.

Possible applications:

- sensor placement;
- assay and diagnostic-panel design;
- test-suite minimization;
- experimental block designs;
- database keys and record linkage;
- calibration targets;
- crowdsourced annotation panels;
- sparse measurement layouts.

The key question becomes:

> After some observations or components disappear, is the intended maximal configuration still the unique compatible completion?

`δ(C)` measures the first radius at which an alternative completion appears. The defining-set/transversal quantity measures how much must be retained to rule out every alternative.

A design tool could search for configurations maximizing:

- minimum unique-completion radius;
- worst-case completion distance;
- tolerance under structured, rather than arbitrary, deletions;
- ease of reconstructing the original design.

The finite-geometry families provide exact calibration cases against which generic heuristics can be tested.


**RIFF_15**

## 7. Canonical reconstruction and fingerprinting

Continuation graphs contain enough local extension information, in special cases, to reconstruct the underlying plane, secants, and arc. Algorithmically, this suggests a broader pattern:

> Represent an object by the compatibility or continuation structure of its legal extensions, then reconstruct or fingerprint the hidden object.

Possible applications:

- canonical fingerprints for combinatorial designs;
- code-equivalence testing;
- recovering schema or topology from compatibility observations;
- graph provenance;
- detecting whether two generated datasets came from equivalent hidden structures;
- identifying automorphism groups of structured instances.

This is unlikely to become a generic graph-isomorphism competitor. Its strength is for structured families where the continuation object has a rigidity theorem. Within such families, one might replace an expensive generic isomorphism search with semilinear normalization and field automorphisms.

There is also a possible security angle: if an obfuscation scheme exposes enough continuation or repair structure, rigidity may allow recovery of its hidden geometric representation. That would require a careful cryptographic audit before making any claim.


**RIFF_16**

## 8. Constraint-game and adversarial planning DSL

The common line-capacity model is broad enough to serve as a compact adversarial-planning language:

- resources are points;
- forbidden or capacity-limited combinations are lines/hyperedges;
- players alternately consume feasible resources;
- saturation changes the residual conflict structure.

Commercial analogues might include:

- adversarial resource reservation;
- spectrum/channel allocation;
- slot or berth allocation;
- contested scheduling;
- security hardening where attacker and defender alternately constrain options;
- drafting mechanisms with incompatibilities.

The normal-play game itself may not match a real business objective, but the state representation, slack updates, residual compilation, and exact adversarial search do.

A useful research question is which real problems naturally possess enough symmetry for the quotient machinery to matter. Without symmetry or small certificates, this becomes another exponential optimizer.


**RIFF_17**

## 9. Puzzle generation and game analytics

The direct CGT results could support a smaller consumer or educational product:

- automatically generated impartial games with prescribed nimbers;
- puzzles requiring a unique winning move;
- difficulty controlled by remoteness or strategy freedom;
- interactive explanations backed by tablebases;
- finite-geometry game visualizations;
- benchmark suites for game-playing agents.

The ability to select a target nimber is useful for composing disjunctive-sum puzzles with controlled answers. This is technically elegant, though probably a niche business rather than the main opportunity.


**RIFF_18**

## 10. Lean-certified mathematical components

The formalized foundations may have standalone value as trusted infrastructure:

- finite hereditary independence systems;
- hypergraph matching/transversal facts;
- completion distance;
- MDS and Singleton foundations;
- repair-code transfer;
- exact finite certificates;
- symmetry-respecting game recurrences.

The immediate users would be researchers and high-assurance coding projects, not a broad commercial market. The longer-term opportunity is making the formal layer the trusted backend of one of the products above. “The optimizer found this” is much weaker than “a small checker established this, and the checker’s meaning is machine-proved.”

## Where I would place bets

If choosing three concrete experiments:

1. **Resilience benchmark.** Model several real or synthetic cloud recovery systems as repair hypergraphs. Compare path count, entropy, `ν`, and `τ` against injected correlated failures. Test whether `τ` better predicts loss of recoverability.

2. **Neural-guided exact search.** Train a symmetry-invariant move-ordering policy on smaller `q`, then measure node reduction on held-out orders while exact search retains correctness. Include known feature-collision pairs as a representation audit.

3. **Proof-carrying solver prototype.** Extract one existing game or code search into a clean pipeline producing a result, compact certificate, independent checker, and Lean theorem. Measure certificate size, checking time, and the effort required to instantiate a second problem.

The first has the clearest commercial story, the second is probably the best ML paper, and the third could become the deepest long-term technical moat.

The underlying source material is summarized in [papers-index.md](/home/tavis/src/othello/papers/papers-index.md) and [2026-07-09-work-summary.md](/home/tavis/src/othello/notes/2026-07-09-work-summary.md).
There is enough here for a coherent ML research program, not just “train a policy on the games.” The distinctive asset is the combination of:

- exact values and strategies;
- large symmetry groups;
- parameterized families across `q`, `n`, and geometry;
- known failures of natural abstractions;
- independently checkable search traces;
- formal theorem endpoints.

That gives you something most game-learning benchmarks lack: ground truth not only for the answer, but for invariance, abstraction failure, recurrence consistency, proof structure, and counterexamples.


**RIFF_19**

## 1. Certified representation-insufficiency benchmark

This may be the strongest standalone ML paper.

You have many pairs of states where:

- a substantial handcrafted feature dictionary agrees;
- natural symmetry or incidence summaries agree;
- the states nevertheless have opposite game values;
- in some cases, whole classes of pointwise value-blind policies are known to fail.

That can become a benchmark for whether learned representations preserve the information actually needed for decision-making.

### Core question

When does an apparently reasonable state abstraction cease to be a sufficient statistic for optimal control?

This connects to:

- state abstraction in RL;
- bisimulation;
- representation learning;
- GNN expressivity;
- belief-state construction;
- causal state representations;
- sufficient statistics for planning.

### Dataset structure

Each example could carry:

- full state;
- exact game value or nimber;
- legal action set;
- group orbit and stabilizer;
- handcrafted feature vector;
- collision class—all states sharing that vector;
- whether the collision class is value-homogeneous;
- smallest known refinement that separates it;
- exact winning replies;
- remoteness and strategy freedom.

The benchmark task is not merely value prediction. It asks whether a representation:

1. identifies genuinely equivalent states;
2. separates states known to require different decisions;
3. generalizes across field order;
4. exposes when its own abstraction is unsafe.

### Possible paper

**“Certified Counterexamples to State Abstraction in Combinatorial Games”**

Experiments:

- MLPs on mined features;
- message-passing GNNs on incidence graphs;
- higher-order GNNs;
- transformers over points, lines, and live cells;
- symmetry-equivariant architectures;
- explicit quotient architectures;
- models augmented with global labelled-embedding information.

A particularly good result would be an expressivity ladder:

```text
static counts
< incidence GNN
< higher-order/local-subgraph model
< labelled continuation model
< exact or near-exact value separation
```

The mathematical counterexamples keep the paper from becoming another benchmark leaderboard: they prove that certain representations cannot solve the task, regardless of training scale.


**RIFF_20**

## 2. Invariance versus sufficiency

There is a subtle paper hiding inside the difference between these two requirements:

- A representation should be invariant under genuine automorphisms.
- It must not be invariant under transformations that erase value-relevant embedding information.

ML practice often rewards “more invariance.” Your data shows why excessive invariance can be fatal.

### Proposed objective

Let `G` be the genuine state automorphism group. Train an encoder `z` with:

\[
z(s)=z(g\cdot s),\qquad g\in G,
\]

while forcing separation of certified abstraction collisions:

\[
d(z(s),z(t)) \ge m
\]

whenever `s` and `t` share the tempting coarse abstraction but have different exact values.

This gives a paired objective:

- quotient exactly what mathematics says is irrelevant;
- retain everything demonstrated to affect optimal decisions.

### Possible paper

**“Invariant but Not Blind: Learning Symmetries Without Destroying Decision-Relevant Structure”**

This could generalize beyond games to molecules, physical systems, code equivalence, and relational planning. The larger message is that invariance selection is a model-specification problem, not simply a regularizer.


**RIFF_21**

## 3. Abstraction-refinement by counterexample

The failed selector and feature programs suggest a CEGAR-like ML loop: counterexample-guided abstraction refinement.

Start with a compact learned or symbolic representation. Then:

1. Solve or sample states.
2. Find a pair collapsed by the representation but requiring different decisions.
3. Extract the smallest relational witness separating them.
4. Add a feature, attention relation, or latent-state refinement.
5. Repeat.

This is analogous to counterexample-guided abstraction refinement in verification, but applied to learned planning representations.

### Variants

- Refine a symbolic feature vocabulary.
- Grow the receptive field of a GNN only where required.
- Add labelled relations selected by a counterexample miner.
- Split latent clusters when exact Bellman behavior differs.
- Learn a decision tree over group-invariant predicates.

### Paper angle

**“Counterexample-Guided Representation Learning for Exact Planning”**

The key metric is not just held-out accuracy. It is the number and size of unresolved certified collisions after each refinement round.

A successful method might produce a compact new mathematical invariant along the way.


**RIFF_22**

## 4. Neural discovery of amortized potentials

The conic ledger and packet/absorption route are almost tailor-made for learned proof discovery.

Instead of learning `V(s)` directly, learn a potential `Φ(s)` satisfying local adversarial inequalities. For example:

\[
\forall a_{\mathrm{opp}}\;\exists a_{\mathrm{reply}}:
\Phi(s'') \le \Phi(s) + c
\]

or a packet-level aggregate inequality.

This is closer to:

- neural Lyapunov functions;
- ranking-function synthesis;
- invariant generation;
- amortized program analysis;
- control-barrier certificates.

### Model choices

Start interpretable:

- sparse linear combinations of geometric statistics;
- integer-coefficient polynomial features;
- small decision trees;
- max/min of a few affine potentials;
- symbolic expressions over orbit and defect counts.

Only then try neural potentials. An opaque network may guide discovery, but the useful endpoint is a small expression that can be proved.

### Training loop

1. Train on currently enumerated transitions.
2. Use exact search to maximize violation of the proposed inequality.
3. Add the worst counterexample.
4. Retrain or synthesize.
5. Distill into a sparse formula.
6. Formalize the final local inequalities in Lean.

### Possible paper

**“From Neural Potentials to Formal Amortized Proofs in Adversarial Combinatorics”**

The strongest result would not require solving the uniform odd-plane theorem. Even recovering a known ledger, discovering a sharper packet potential, or proving a bounded finite family would make a compelling methods paper.


**RIFF_23**

## 5. Quantified-action neural policies

Ordinary policies learn:

\[
\pi(s)\to a.
\]

But the mathematical structure here often has the form:

\[
\exists\text{ packet }P\;\forall\text{ opponent moves }o\;
\exists\text{ reply }r.
\]

That suggests a policy architecture matching the proof quantifiers:

1. high-level actor selects a packet/pencil/orbit;
2. adversary module selects the hardest opponent continuation;
3. reply module chooses an adaptive response;
4. critic scores the entire two-stage obligation.

This is closer to game-semantic or quantified planning than ordinary one-step RL.

### Training objective

For packet `P`:

\[
Q(s,P)=\min_o\max_{r\in R(s,P,o)} V(s,P,o,r).
\]

The policy maximizes this worst-case packet value. Exact search can supervise every layer.

### Possible paper

**“Learning Quantified Strategies: Hierarchical Policies for ∃∀∃ Games”**

Second-order benefit: the learned hierarchy may expose the correct mathematical decomposition even if raw value prediction does not.


**RIFF_24**

## 6. Strategy freedom as a learning target

Win/loss is a coarse target. Two winning states can differ radically:

- one has a single brittle winning reply;
- another has many independent winning replies;
- some replies remain robust under downstream perturbations;
- others lead to very long or fragile continuations.

Define auxiliary quantities such as:

- number of winning actions;
- orbit count of winning actions;
- minimum stabilizer size of a winning action;
- remoteness;
- reply entropy;
- worst-case future winning-action count;
- packet coverage;
- adversarially robust reply count.

A policy could optimize lexicographically:

1. preserve exact win;
2. maximize strategy freedom;
3. minimize remoteness or computational burden.

### Why this matters

In approximate deployment, choosing a theoretically winning but unique and brittle continuation is dangerous. A policy with many fallback continuations may tolerate model error, execution noise, or incomplete search.

### Paper

**“Beyond Value: Learning Strategy Freedom in Exact Games”**

This could connect to robust control and option diversity. Exact tables let you test whether conventional policy entropy is actually correlated with meaningful strategic redundancy.

I suspect it often will not be—mirroring the repair-hypergraph finding that alternative count and disjoint availability can mismeasure resilience.


**RIFF_25**

## 7. Grundy-structured learning

Nimbers provide a rare structured multiclass learning target. The target is not an arbitrary label:

\[
G(s)=\operatorname{mex}\{G(s'):s'\in\operatorname{children}(s)\}.
\]

A valid prediction therefore obeys two kinds of constraints:

- exclusion: no child has nimber `G(s)`;
- coverage: every nimber smaller than `G(s)` appears among the children.

### Structured loss

If the model predicts parent distribution `p_s(k)` and child distributions `p_c(k)`, add:

- an exclusion penalty when parent and any child assign mass to the same nimber;
- a coverage penalty when a likely parent nimber `k` lacks child support for some `j<k`;
- ordinary supervised loss where exact labels exist.

One could also predict the child-value set and apply a differentiable mex layer.

### Paper

**“Learning Sprague–Grundy Values with Mex-Consistent Neural Networks”**

Baselines:

- flat classification;
- recursive GNN;
- set transformer over child embeddings;
- differentiable mex;
- supervised plus structural consistency;
- training on small `n`, testing on larger `n`.

This is a clean algorithmic-learning paper because the recurrence supplies self-supervision on unlabelled states: even when exact parent values are unavailable, predicted parent and child distributions can be constrained to agree.


**RIFF_26**

## 8. Learning disjunctive composition

Grundy theory gives exact composition:

\[
G(A+B)=G(A)\oplus G(B).
\]

That creates an unusually crisp benchmark for compositional generalization.

Train on individual components and small sums, then test whether models infer XOR-like nimber composition on:

- unseen component combinations;
- larger heaps;
- components from different game families;
- states whose graph representations have been joined without an explicit component marker.

### Questions

- Does a GNN discover connected-component decomposition?
- Does it learn ordinary addition instead of nim-sum?
- Can an architecture learn nim-sum extrapolatively?
- Does explicit recursive supervision help?
- Can mechanistic interpretability recover binary XOR circuits in the network?

### Paper

**“Exact Compositional Generalization from Sprague–Grundy Games”**

The repo’s warning that a tempting conic/zone decomposition is empirically false is especially useful. The benchmark can contain:

- true disjunctive decompositions;
- visually tempting but coupled non-decompositions.

The task becomes learning when composition is valid, not merely learning how to combine components.


**RIFF_27**

## 9. Learning whether a decomposition is sound

This is a second-order version of the previous idea.

A model receives a proposed partition of a state and predicts:

- genuinely independent;
- weakly coupled;
- invalid decomposition;
- smallest witness to coupling.

Training data can be generated by comparing exact combined values against nim-sums of purported components.

Applications extend beyond games:

- factored MDPs;
- modular planning;
- distributed systems;
- causal decomposition;
- divide-and-conquer optimization.

### Paper

**“Learning When to Factor: Counterexamples to Modular Planning”**

The conic-plus-zone failure is a good motivating case: visually and geometrically plausible components can remain coupled through legality constraints.


**RIFF_28**

## 10. Neural move ordering with zero correctness debt

This is the most straightforward applied-ML project.

Use a learned model only to order moves inside alpha-beta, proof-number search, or exact recursive evaluation. The exact solver still establishes the result.

Advantages:

- no risk of incorrect published values;
- clean metric: nodes and wall time;
- abundant exact supervision;
- easy ablations;
- failures only cost performance.

### Useful targets

- probability a move is winning;
- expected cutoff depth;
- remoteness;
- subtree size;
- likelihood of producing a reusable transposition;
- orbit-level rather than raw-move priority.

### Interesting experiment

Compare:

- imitation of best exact move;
- direct subtree-size regression;
- pairwise ranking;
- learning-to-search objectives based on actual node reduction;
- policies trained on smaller `q`;
- online adaptation during a new `q` census.

### Paper

**“Symmetry-Aware Learned Move Ordering for Exact Combinatorial Search”**

The PGL-quotiented keys and stabilizer orbits give a principled architecture. A good result would measure not just average speedup but tail behavior across hard orbit buckets.


**RIFF_29**

## 11. Learned canonicalization and orbit selection

Canonicalization is often a major cost in symmetry-heavy search. A model could predict:

- a likely canonical group element;
- a small candidate set containing the true canonical representative;
- stabilizer type;
- orbit size;
- a canonical anchor point or frame.

The exact canonicalizer then verifies or completes the result.

This again incurs no correctness debt. Even an imperfect model can reduce group enumeration.

### Paper

**“Speculative Canonicalization: Learned Proposals with Exact Verification”**

Second-order applications include:

- graph isomorphism heuristics;
- chemical canonicalization;
- code equivalence;
- theorem-prover normalization;
- symmetry breaking in SAT/CP.

The best architecture would probably predict a sequence of anchors rather than a full group element.


**RIFF_30**

## 12. Approximate memory for discovery, exact memory for proof

The lossy BuRR use suggests a broader ML/systems paper about asymmetric correctness requirements.

During scientific discovery:

- false positives may be tolerable;
- false negatives may be more dangerous, or vice versa;
- approximate storage can unlock much larger hypothesis-mining runs;
- every promoted result is later replayed exactly.

One could learn which states deserve exact retention and which can be kept in a compressed approximate structure.

### Learned memory controller

For each state, predict:

- probability it will be queried again;
- scientific importance;
- likelihood an approximation error changes a mined conclusion;
- whether it lies near a decision boundary;
- whether an exact certificate will eventually depend on it.

Then allocate:

- exact table entry;
- succinct exact fingerprint;
- lossy value;
- discard/recompute.

### Paper

**“Risk-Aware Approximate Memory for Exact Scientific Search”**

The novelty would be evaluating approximation by its effect on discovered conjectures, not just cache hit rate.


**RIFF_31**

## 13. Active conjecture discovery

The solver can serve as an environment for active scientific learning.

Rather than uniformly solving buckets, choose the next state, orbit, or field order that maximally distinguishes competing conjectures.

Suppose candidate hypotheses predict different outcomes based on:

- stabilizer size;
- depletion;
- pencil defect;
- orbit type;
- packet statistics;
- field arithmetic.

An acquisition function selects the cheapest computation with greatest expected hypothesis discrimination.

### This resembles

- Bayesian experimental design;
- active learning;
- automated scientific discovery;
- version-space elimination.

### Paper

**“Active Experiment Design for Computational Mathematics”**

The q=29 census is a dramatic example: it is expensive, so one would like to know whether smaller targeted solves can distinguish the live explanations. The system could search for individual buckets or transition families where candidate theories disagree most strongly.

Second-order benefit: negative results become structured information about which conjecture families have been eliminated.


**RIFF_32**

## 14. Stabilizers as an uncertainty prior

Highly symmetric states may be:

- easier to generalize;
- overrepresented after quotienting;
- strategically atypical;
- more likely to admit compact certificates;
- misleadingly “simple” while sitting at a phase boundary.

This suggests studying how orbit and stabilizer information interacts with model uncertainty.

Potential questions:

- Are large-stabilizer states predicted more accurately?
- Does quotient-balanced training outperform raw-state-balanced training?
- Should uncertainty be calibrated per orbit rather than per state?
- Do rare orbit types dominate OOD failures?
- Does the smallest-orbit anchor correspond to model confidence, and should it?

### Paper angle

**“Orbit-Aware Calibration in Symmetric Decision Problems”**

A critical data-splitting rule emerges: random state splits are invalid because symmetry-related states leak almost exact copies across train and test. Splits should be by orbit, configuration class, or field order.

That dataset methodology itself is useful.


**RIFF_33**

## 15. Cross-order generalization and latent arithmetic

Training across finite fields asks whether a model learns geometry or merely memorizes order-specific statistics.

Tasks:

- train on `q≤19`, test on `q=23,25`;
- train on prime fields, test on prime powers;
- train on non-depleted orders, test on depleted orders;
- test characteristic transfer;
- test whether adding field operations explicitly improves generalization.

Architectures could compare:

- incidence-only GNNs;
- coordinate-aware models;
- finite-field neural arithmetic modules;
- semilinear-equivariant models;
- models with explicit Frobenius actions.

### Paper

**“Neural Generalization Across Finite Fields”**

The depleted/non-depleted behavior is valuable because modular residue heuristics fail. A model that succeeds must learn something richer than `q mod m` or local count statistics.

A negative result could also be publishable: standard relational models may interpolate within an order but fail completely across field structure.


**RIFF_34**

## 16. GNN expressivity through continuation reconstruction

The continuation graph/complex work gives a way to ask whether a neural model can reconstruct a hidden geometry from legal-extension relations.

Tasks of increasing difficulty:

1. identify the original arc points;
2. reconstruct secant classes;
3. infer point-line incidence;
4. predict the automorphism group or stabilizer;
5. canonicalize the recovered geometry;
6. distinguish nonisomorphic geometries with similar local statistics.

Because there are mathematical reconstruction theorems, one knows that the information is present. Failure is therefore architectural or statistical, not information-theoretic.

### Paper

**“Can Graph Neural Networks Recover a Geometry from Its Continuation Structure?”**

This could become a controlled benchmark for local versus global GNN expressivity. Higher-order or spectral models may be required where ordinary message passing collapses configurations.


**RIFF_35**

## 17. Formal-proof-conditioned learning

Most theorem-proving datasets begin with text or proof states. Here, one can connect a large computation to a small formal certificate.

Train models to predict:

- which computational facts need certification;
- the right certificate decomposition;
- reusable lemmas;
- proof boundaries between generic theorem and finite computation;
- a small trusted checker interface;
- which symmetries should be proven once rather than enumerated repeatedly.

### Paper

**“Learning Certificate Interfaces Between High-Performance Search and Formal Proof”**

The model’s job is not necessarily to write Lean. It can discover the right abstraction boundary:

```text
large solver output
→ compressed mathematical certificate
→ generic soundness theorem
→ small kernel computation
```

That boundary-selection problem is underexplored and could be more important than tactic prediction.


**RIFF_36**

## 18. Proof complexity as a policy objective

Two moves may both win, but one may lead to a vastly smaller certificate or proof tree.

Define a proof-aware policy optimizing:

- win first;
- then certificate size;
- checker time;
- Lean elaboration cost;
- proof-DAG width;
- number of distinct orbit representatives.

This creates a new notion of “best move”: easiest to certify.

### Applications

- theorem discovery;
- model checking;
- exact planning with audit requirements;
- proof-producing optimization.

### Paper

**“Learning Strategies That Are Easy to Certify”**

Second-order insight: the most human-explainable or formally tractable strategy may not be the shortest-win strategy. ML can search for low-proof-complexity witnesses explicitly.


**RIFF_37**

## 19. Robust ensemble learning through repair hypergraphs

The repair-code results translate naturally to ensemble systems.

Suppose each valid decision or recovery path uses a set of:

- models;
- data sources;
- features;
- tools;
- human reviewers;
- external services.

Treat those sets as hyperedges. Then:

- raw number of paths resembles representation count;
- disjoint availability resembles `ν`;
- minimum common attack/failure set resembles `τ`.

An ensemble with many nominal decision paths may still be fragile if a small set of shared features or data sources intersects all of them.

### ML application

Design ensembles to maximize transversal robustness under realistic failure domains, not merely prediction diversity.

Examples:

- medical decision support using overlapping source datasets;
- retrieval-augmented systems whose “independent” answers cite the same upstream source;
- multi-agent systems whose agents share a base model;
- fraud systems whose features all depend on one identity provider;
- safety monitors trained on overlapping data.

### Paper

**“Beyond Ensemble Diversity: Hypergraph Measures of Shared-Dependency Robustness”**

This could be commercially significant. A compelling experiment would compare:

- disagreement;
- error correlation;
- path entropy;
- disjoint model count;
- hypergraph transversal robustness;

against targeted failures of shared datasets, features, or services.


**RIFF_38**

## 20. Multi-agent systems: apparent diversity versus causal diversity

A second-order extension is particularly timely.

Ten agents using different prompts are not ten independent agents if they share:

- the same base model;
- retrieval corpus;
- toolchain;
- system prompt assumptions;
- fine-tuning data;
- verifier.

Represent each agent’s successful reasoning path by its dependency set. Then calculate whether every path can be disrupted by one shared failure.

This gives a principled way to distinguish:

- behavioral diversity;
- representation diversity;
- infrastructure diversity;
- causal dependency diversity.

The repo’s `τ > ν` and non-monotonicity phenomena suggest that no single conventional diversity count will suffice.


**RIFF_39**

## 21. Adversarial training as hitting-set search

Instead of generic perturbations, train an adversary to find a small set of shared resources whose removal defeats every valid policy or repair route.

This is a hitting-set game:

\[
\min_{F}|F|
\quad\text{such that}\quad
F\cap R\ne\varnothing
\text{ for every successful route }R.
\]

The learner tries to construct new routes avoiding the current hitting set; the adversary updates the hitting set.

This becomes a double-oracle procedure:

1. adversary proposes a compact failure set;
2. policy generator finds a successful route avoiding it;
3. route is added to the repair hypergraph;
4. repeat until no route exists.

Applications:

- robust tool-using agents;
- resilient routing;
- ensemble construction;
- recovery policy design;
- code repair optimization.

### Paper

**“Adversarial Route Generation for Shared-Dependency Robustness”**

This is one of the nicest bridges between the coding theory and RL sides of the repo.


**RIFF_40**

## 22. Mechanistic interpretability on exact algorithms

Sprague–Grundy learning and finite-field games are good interpretability targets because the correct internal algorithm is precisely defined.

Questions:

- Does a transformer implement mex?
- Does it represent nimbers in binary?
- Does it compute XOR compositionally?
- Does a GNN recover orbit/stabilizer features?
- Does the model learn a potential resembling the conic ledger?
- Does it memorize field orders or implement finite-field operations?

Unlike natural-language interpretability, there is a known algorithm against which circuits can be compared.

### Paper

**“Mechanistic Interpretability of Learned Combinatorial Game Algorithms”**

A strong experiment would train on disjunctive sums, identify an XOR-like circuit, and causally intervene on the internal nimber representation.


**RIFF_41**

## 23. Phase-transition and exceptional-order detection

The depleted orders `{11,17}` amid otherwise non-depleted behavior resemble rare structural exceptions. This supports ML work on anomaly detection in mathematical families.

Train on per-order or per-bucket structural summaries and ask the model to:

- identify exceptional orders;
- quantify epistemic uncertainty;
- propose features explaining the exception;
- select the next order to compute;
- avoid inventing false modular laws.

The point is not simply prediction. It is whether ML can distinguish:

- a genuine arithmetic pattern;
- finite-sample coincidence;
- an embedding-dependent structural transition.

### Paper

**“Learning Exceptional Cases in Computational Mathematics Without Hallucinating Laws”**

Evaluation can reward calibrated abstention and falsifiable feature proposals, rather than raw accuracy over a tiny number of orders.


**RIFF_42**

## 24. A theorem-discovery benchmark with negative knowledge

Most theorem-discovery benchmarks contain true statements and perhaps randomly generated false ones. Your project has something more valuable: extensively investigated conjecture families with explicit counterexamples and closure reasons.

A dataset could include:

- conjecture;
- supporting range;
- first counterexample;
- counterexample type;
- whether a repaired version exists;
- proof status;
- feature family eliminated;
- computational cost of falsification.

Tasks:

- rank conjectures by plausibility;
- propose the cheapest discriminating test;
- repair a false conjecture;
- predict whether a counterexample is local or parameter-dependent;
- generate a separating invariant;
- summarize what the counterexample actually rules out.

### Paper

**“Learning from Dead Conjectures: A Benchmark for Falsification-Aware Mathematical Reasoning”**

That could be much more informative than training exclusively on successful theorem statements.


**RIFF_43**

## 25. Second-order research infrastructure

Several ideas become possible only after the first ML layer exists.

**RIFF_44**

### Solver–learner flywheel

```text
exact solver produces states
→ model finds uncertain or structurally novel regions
→ active solver targets those regions
→ counterexamples refine representation
→ improved policy accelerates solver
→ larger exact dataset becomes available
```

This is a genuine closed-loop scientific system rather than one-off supervised learning.

**RIFF_45**

### Learned search as a mathematical microscope

Feature attribution or symbolic distillation from a successful OOD policy may reveal:

- a missing invariant;
- a useful packet decomposition;
- a new stabilizer statistic;
- the correct labelled embedding feature;
- a candidate amortized potential.

The model does not have to prove the theorem to contribute. It can identify the coordinates in which a proof is likely to live.

**RIFF_46**

### Formalization as anti-overfitting

Lean supplies an unusually strong final validation stage:

- numerical fit suggests an invariant;
- adversarial search tests it;
- symbolic distillation makes it legible;
- formal proof establishes the universal claim.

This turns theorem proving into the mathematical analogue of a truly held-out test set.

**RIFF_47**

### Certificate cost as scientific regularization

Among equally predictive hypotheses, prefer the one producing:

- smaller certificates;
- fewer exceptional cases;
- simpler orbit decompositions;
- shorter formal proofs;
- cheaper independent checks.

That is an operational version of Occam’s razor.

## Paper program I would prioritize

A coherent sequence might be:

1. **Certified Counterexamples to State Abstraction in Combinatorial Games**

   Package the exact states, feature collisions, symmetry classes, and OOD splits. This establishes the benchmark.

2. **Invariant but Not Blind**

   Introduce the symmetry-invariance plus certified-separation objective and compare relational architectures.

3. **Mex-Consistent Neural Networks**

   A focused algorithmic paper using exact Grundy recurrence and disjunctive composition.

4. **Counterexample-Guided Neural Potential Discovery**

   Use the solver to synthesize and falsify amortized potentials, ending with symbolic or Lean-checked claims.

5. **Beyond Ensemble Diversity**

   Transfer the complete-repair-hypergraph metrics to ML ensembles or tool-using agents.

6. **Learning Certificate-Friendly Search**

   Combine neural move ordering, proof complexity, and exact verification.

The first, third, and fifth are relatively separable. The potential-discovery paper is the highest-upside one because it could simultaneously advance ML methodology and unlock new mathematics.

The central theme tying all of them together would be:

> Exact combinatorial systems let us train models not merely to predict answers, but to respect symmetries, detect insufficient abstractions, satisfy recursive semantics, survive adversarial counterexamples, and emit claims that can ultimately be certified.
