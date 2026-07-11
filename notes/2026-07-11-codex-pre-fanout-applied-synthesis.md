# Codex pre-fanout applied synthesis: ranked cross-domain uses

**Date:** 2026-07-11  
**Provenance:** root-authored synthesis of the application brainstorms produced
before the three-agent key-card fanout.  It intentionally excludes the fanout
reports so that the independent views remain comparable.  
**Input deck:** [projective-cap portfolio key cards](2026-07-11-projective-cap-portfolio-key-cards.md)

## Status language

- **DIRECT:** the proved object already has the stated mathematical meaning in
  the target setting.
- **TRANSLATION:** there is an exact-looking map, but a domain theorem or
  benchmark is still needed.
- **SPECULATIVE:** useful research prompt, not yet an application claim.

## Master ranking

The ranking combines expected mathematical reach, plausible practical value,
distance to a falsifiable prototype, and how much of the portfolio it reuses.

| Rank | Direction | Key cards | Maturity | Decisive next gate |
|---:|---|---|---|---|
| 1 | Shared-dependency resilience analyzer | K14, K16, K17 | DIRECT/near prototype | Beat ordinary path-count and availability metrics on one real dependency graph |
| 2 | Robust identifiability and deletion-breakdown theory | K6, K7, K8 | TRANSLATION | Prove equivalence for one statistical model class and compute a nontrivial example |
| 3 | Canonical reconstruction and constraint engine | K11, K12, K19 | DIRECT for structured geometries | Implement canonicalization/reconstruction and compare with generic graph-isomorphism tooling |
| 4 | Repair-aware erasure-code compiler | K14--K17 | DIRECT | Implement a finite RS-outer/twisted-axis-inner code and benchmark repair/outage trade-offs |
| 5 | Proof-carrying finite-search platform | K18--K20 | DIRECT methodology | Generalize one certificate pipeline outside the cap project |
| 6 | Finite-moduli reduct rigidity | K11, K12 | DIRECT theorem; research expansion | Prove a first `M_(0,n)` theorem beyond the four-map `M_(0,5)` case |
| 7 | Relative multiple-saturation and robust experimental design | K7 | TRANSLATION | Obtain a sharp bound or equality family for `t_h(q)` |
| 8 | Sparse-mixture moment identifiability | K6, K8 | TRANSLATION | Translate NRC transversal distance into a standard finite-mixture identifiability statement |
| 9 | ML shared-failure diversity loss | K14, K17 | TRANSLATION | Show a differentiable transversal surrogate predicts correlated dropout better than entropy/diversity |
| 10 | Completion-core schema/provenance monitor | K6, K7, K12 | TRANSLATION | Demonstrate minimum deletion certificates on a relational or configuration dataset |
| 11 | Galois-orbit compression and subfield-aware encoding | K9, K10, K19 | TRANSLATION | Produce an explicit family with a parameter, decoder, or enumeration advantage |
| 12 | Voltage/cycle-consistency losses | K3 | TRANSLATION | Find a signed-network task where local features fail and the cycle bit closes the gap |
| 13 | Potential-shaped and counterexample-guided RL | K3, K4, K18, K20 | TRANSLATION | Compare policy learning with and without certified geometric shaping on held-out orders |
| 14 | Secret-recovery/access-structure design | K14--K17 | TRANSLATION | State and audit privacy, not only reconstruction, for a concrete scheme |
| 15 | Projective fiducials and partial-view matching | K11, K12 | SPECULATIVE | Establish noise stability over real/quantized coordinates |
| 16 | Phylogenetic or marginal-view reconstruction | K11 | SPECULATIVE | Give an exact map from a standard marginal/quartet observation model to the four-map reduct |
| 17 | Rank-metric/network-code insertion spectra | K13 | TRANSLATION | Compute a full list distribution for a non-scalar MRD spread set |
| 18 | Hypergraph-ML and optimization benchmarks | K2, K14, K16, K18 | DIRECT as data generation | Show algebraic instances expose a failure unseen on random benchmarks |
| 19 | Structural compression by minimal conflicts/orbits | K12, K19 | TRANSLATION | Measure actual space reduction on a sparse structured corpus |
| 20 | Game/puzzle AI and certified strategy books | K1, K3, K4, K18 | DIRECT niche | Package a verifier and explainable strategy artifact for an external game |

## 1. Larger mathematical prizes

### 1.1 A robustness theory for locally repairable systems

**Rank 1/4/9.** The central distinction is between:

- number of recovery alternatives;
- disjoint parallel availability `nu`;
- fractional service capacity; and
- the minimum shared blocker `tau`.

The twisted-cubic--axis family and bounded-repair transfer lemma show that
strict all-symbol `tau>nu` can coexist with fixed alphabet, positive rate and
positive relative distance.  The larger prize is a trade-off theory for

```text
(rate, distance, locality, availability, service capacity, outage tolerance).
```

That theory would apply not only to storage codes but to any system whose
recovery workflows form a hypergraph.

### 1.2 Finite-moduli reduct rigidity

**Rank 6.** The frame graph is the uncoloured union of four selected
forgetful-map fibre relations on `M_(0,5)(F_q)`.  Its arbitrary graph
automorphisms recover the four colours and are only `S_4` plus Frobenius.
The larger problem is to determine which uncoloured subsets of forgetful or
cross-ratio relations on `M_(0,n)(F_q)` still reconstruct the marked moduli
object.  This connects finite moduli, association schemes, latent-view
identifiability and graph automorphisms.

### 1.3 Relative multiple-saturation asymptotics

**Rank 7.** Completion resilience asks that every undesired external point
retain at least `h` secant certificates while designated holes remain exempt.
Sharp asymptotics, stability or equality classifications for `t_h(q)` would
simultaneously advance defining sets, multiple-covering codes and adversarial
completion robustness.

### 1.4 Robust reconstruction of punctured incidence structures

**Rank 3.** Continuation-complex faithfulness currently assumes exact binary
and ternary minimal nonfaces.  A stability theorem under missing, corrupted or
sampled incidences would reach graph reconstruction, schema recovery and
error-correcting reconstruction of relational structures.

## 2. Information geometry, statistics and scientific inference

The natural landing zone is algebraic/combinatorial statistics rather than
classical Fisher--Rao geometry.

### 2.1 Robust experimental design

**Rank 2/7.** Treat generator columns as measurement vectors.  A repair support
is a minimal subset of sensors from which a target contrast remains estimable.
Then `nu` counts disjoint estimators and `tau-1` is the exact arbitrary sensor-
failure budget.  Completion distance is the minimum observation deletion that
destroys unique model identification.  This suggests active designs that
maximize completion distance rather than determinant or average information
alone.

### 2.2 Sparse-mixture and moment identifiability

**Rank 8.** The NRC vector

```text
(1,t,t^2,...,t^d)
```

is a truncated moment vector of a point mass.  Spans of several NRC points are
finite atomic-mixture moment models.  Minimal representation supports encode
alternative sparse decompositions, and their transversal number is the number
of dictionary atoms that must be removed before every decomposition disappears.
This is a candidate breakdown parameter for sparse-mixture identifiability.

### 2.3 Hierarchical and toric statistical models

**Rank 10/19.** Circuits of a design matrix are toric moves; minimal nonfaces
encode forbidden low-order interactions.  Continuation-complex extraction may
therefore inform robustness of Markov bases, cell deletion and reconstruction
of hierarchical models.  This requires a genuine model-class translation, not
only terminological similarity.

### 2.4 Stable conclusions across a version space

**Rank 2/10.** A completion core is the set of facts common to all complete
models compatible with partial observations.  It can support conservative
prediction, causal-structure stability, machine-unlearning impact analysis and
data-poisoning budgets: report a conclusion only when it remains in every
completion after the allowed deletions.

### 2.5 Phylogenetic/moduli connection

**Rank 16.** `M_(0,n)` and its tropicalization occur in phylogenetic tree
spaces; forgetful maps correspond to dropping marked leaves.  The rigidity
theorem motivates reconstruction from an unlabelled union of marginal or
leaf-deletion coincidences.  No direct standard phylogenetic observation model
has yet been shown equivalent, so this remains speculative.

## 3. Compression, encoding and applied software

### 3.1 Dependency-resilience intelligence

**Rank 1.** Model alternative ways to restore a service, derive a feature,
support an answer or source a component as hyperedges.  Compute:

- disjoint parallel workflows (`nu`);
- fractional load-balanced capacity;
- minimum coordinated outage (`tau`);
- critical shared dependencies and certificates.

Candidate domains are cloud failover, microservices, feature stores, multi-
cloud repair, supply chains, RAG evidence and tool-using agents.  The concrete
commercial claim to test is that path counts and entropy systematically
overstate resilience when alternatives share hidden dependencies.

### 3.2 Repair-code compiler

**Rank 4.** A Rust library could ingest a generator/parity-check matrix,
enumerate all bounded dual supports, calculate per-coordinate locality,
`nu`, `tau` and fractional capacity, then verify an outer dual-distance gate
and emit encoders plus repair schedules.  A practical first construction uses
the `[19,4,8]_9` seed with a Reed--Solomon outer code over `F_(9^4)`.

### 3.3 Canonical serialization and deduplication

**Rank 3/19.** Rigidity and orbit transport can provide canonical labels,
symmetry-aware cache keys and one-representative-per-orbit storage.  A frame
plus recovered coordinate partitions may replace a full incidence table.
This is compression only for structured, symmetric data; the continuation
complex itself can be larger than the original object.

### 3.4 Minimal-conflict constraint engines

**Rank 3/10/19.** Store only illegal pairs and irreducible illegal triples,
rather than all legal subsets.  This supports incremental validation, SAT,
product configuration, infrastructure-as-code checks, scheduling constraints,
digital twins and database denial constraints.  Completion cores add
provenance: which inputs force each derived restriction?

### 3.5 Proof-carrying finite computation

**Rank 5.** The reusable software pattern is:

```text
proved reduction -> optimized search -> compact certificate
                 -> independent rules-only validator -> trust-tier report.
```

Applications include finite-code searches, combinatorial designs, exhaustive
configuration audits, optimization certificates, tablebases and protocol
parameter validation.

### 3.6 Galois-orbit compression and mixed-field encoding

**Rank 11.** Store invariant configurations by marked orbit representatives
and stabilizers, retaining necessary Frobenius pairing rather than an unmarked
PGL type.  Coding prospects include subfield-rational MDS lengthening,
mixed-alphabet codes and network coding.  No competitive parameter or decoder
advantage has yet been established.

### 3.7 Secret recovery

**Rank 14.** View a target coordinate as a secret and repair supports as
authorized reconstruction teams.  `nu` counts disjoint teams; `tau-1` counts
unavailable participants tolerated.  Privacy thresholds and leakage have not
been audited, so a repair code cannot simply be advertised as secret sharing.

### 3.8 Projective vision/fiducials

**Rank 15.** Projective frames and cross-ratio coordinates suggest invariant
marker matching and partial-view reconstruction.  The finite theorem is exact,
but a practical application requires quantitative stability under real noise,
quantization and incorrect correspondences.

## 4. Loss functions and learning objectives

### 4.1 Shared-failure diversity loss

**Rank 9.** For a learned family of recovery routes `H`, use the fractional
transversal relaxation

\[
\tau^*(H)=\min_{z\ge0}\left\{\sum_vz_v:
             \sum_{v\in R}z_v\ge1\ \forall R\in H\right\}.
\]

A differentiable objective is

\[
L=L_{task}+\lambda L_{cost}-\mu\tau^*
  +\rho\max_v load(v).
\]

It trains ensembles, RAG systems, feature derivations or tool routers against
shared failure rather than rewarding route count or entropy alone.  Exact
integer `tau` is generally hard; LP layers, greedy adversaries and rounding are
the first implementation choices.

### 4.2 Completion-margin loss

**Rank 2.** Train the desired latent completion to remain unique after up to
`h-1` observation deletions:

\[
L_{comp}=\max_{|D|<h}\max_{y'\ne y,\ y'\in Comp(x\setminus D)}
          [m+s(y')-s(y)]_+.
\]

Potential uses are feature dropout, sensor loss, model identification, partial
views and training-data deletion.  Exact adversarial deletion is feasible only
for structured models; learned masks or combinatorial oracles are surrogates.

### 4.3 Core-stability and abstention loss

**Rank 10.** Penalize prediction variation across all completions compatible
with partial data, and abstain when the target is not in the robust core.  This
could support conservative causal inference, data governance and model-risk
reporting.

### 4.4 Minimal-nonface energy

**Rank 19.** For pair/triple conflict complexes, define an energy model with
sparse penalties only on irreducible conflicts.  This is attractive when the
minimal-nonface description is far smaller than the legal-state space.

### 4.5 Symmetry and marked-orbit consistency

**Rank 11/15.** Use group-orbit augmentation and consistency penalties, but
retain pairings or voltage data proven necessary.  Ordinary invariant training
is standard; the portfolio contributes counterexamples showing when an
unmarked quotient silently identifies distinct states.

### 4.6 Voltage/cycle-consistency loss

**Rank 12.** For signed local transformations, penalize inconsistent cycle
holonomy:

\[
L_{cycle}=\sum_C\ell\left(\prod_{e\in C}\sigma_e,1\right).
\]

Possible targets include signed GNNs, pose synchronization, parity decoding,
circuit diagnosis and multi-agent agreement.  The motivating exact result is
that static local coordinates can agree while the Z2 cycle voltage changes the
game value.

## 5. Reinforcement learning and policy training

### 5.1 Potential-based shaping

**Rank 13.** For a state potential `Phi`, use

\[
r'(s,a,s')=r(s,a,s')+\eta(\gamma\Phi(s')-\Phi(s)).
\]

In this standard form, shaping preserves optimal policies.  Candidate features
include reservoir slack, defect components, intruders, cycle voltage,
completion distance and remaining repair tolerance.  The empirical charge
`Psi` is suitable for training or curriculum design, not a correctness proof.

### 5.2 Adversarial repair/routing RL

**Rank 1/13.** One policy selects a repair workflow under load while an
adversary removes correlated helpers.  Reward combines completed service,
bandwidth, maximum load and remaining transversal tolerance.  Algebraic
hypergraphs supply environments with exact optima for evaluation.

### 5.3 Counterexample-guided policy distillation

**Rank 5/13.** Train by imitation from exact tablebases, search for the smallest
state defeating the learned selector, add that state to the curriculum, and
repeat.  A learned policy is then distilled into a value-blind symbolic rule
and subjected to exhaustive falsification.  Exact values may train a policy but
cannot appear in a claimed proof selector.

### 5.4 Symmetry-safe state abstraction

**Rank 3/13.** Canonicalize states only by symmetries whose marked data are
proved sufficient.  The negative results warn against quotients that discard
Frobenius pairing, voltage or dynamic intruder state.

### 5.5 Active experiment selection

**Rank 2/7.** Let the action select the next observation or design point and
reward increased completion distance or reduced completion ambiguity.  This is
an RL formulation of robust experimental design rather than game play.

## 6. Other commercial and interdisciplinary possibilities

1. **RAG evidence resilience:** recovery sets are independent sufficient source
   sets; `tau` is the smallest corpus/source outage removing every support.
2. **Feature-store repair:** alternative feature derivations are hyperedges;
   schedule them by fractional matching and audit shared services by `tau`.
3. **Supply-chain resilience:** replace helpers with suppliers or processes;
   distinguish nominal alternatives from shared-facility blockers.
4. **Multi-agent tool redundancy:** analyze alternative tool sequences and
   hidden common APIs or credentials.
5. **Hypergraph-ML benchmarks:** algebraic instances have exact symmetry and
   matching/transversal labels, useful for learned combinatorial solvers.
6. **Rank-metric/network coding:** compute insertion/list spectra for MRD spread
   sets rather than only scalar direction sets.
7. **Game and puzzle tooling:** verified strategy books, puzzle generation,
   tablebase compression and explainable move certificates.
8. **Signed-network diagnostics:** use voltage-aware cycle state for parity
   faults and inconsistent local transformations.

## 7. Recommended product sequence

1. Build a generic Rust `repairgraph` library: enumerate bounded recovery
   supports; compute/approximate `nu`, `tau`, fractional matching and minimal
   outage certificates.
2. Add linear-code import and the concatenation verifier.
3. Benchmark on storage codes, then one noncoding dependency graph such as a
   feature pipeline or microservice topology.
4. Add proof-carrying certificates for the exact finite computations.
5. In parallel, prototype continuation-complex canonicalization on structured
   configuration data.
6. Fund statistical/ML translations only after an exact model-class theorem or
   a benchmark shows benefit over standard robustness/diversity measures.

## 8. Important nonclaims

- Error-correcting codes add redundancy; they are not general-purpose data
  compressors.  The correct pipeline is compress first, then encode.
- `Psi` is not a proved game invariant or a proof-admissible RL oracle.
- A large number of recovery alternatives does not imply large `tau`, batch
  recovery, privacy or stopping-set guarantees.
- Unmarked symmetry quotients can lose Frobenius pairing or cycle voltage.
- Finite-field projective rigidity does not automatically give numerical
  stability over the reals.
- The proposed commercial uses need domain benchmarks; mathematical exactness
  alone is not evidence of product demand.
