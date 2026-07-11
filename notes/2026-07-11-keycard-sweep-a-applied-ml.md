# Applied-ML key-card sweep A

**Date:** 2026-07-11  
**Scope:** statistics, information geometry, ML/RL, encoding, and software systems; storage/LRC applications excluded.

## Ranked candidates

### 1. Identifiable four-view representation learning — **DIRECT theorem, TRANSLATION application**

- **Cards:** K11.
- **Primitive:** the uncoloured union of four fibre-equality relations on
  `M_(0,5)(F_q)` determines its gauge group exactly: only `S4` and Frobenius remain for `q>=13`.
- **User/problem:** symbolic or finite-field multi-view learning where latent states are observed through four lossy relational views; obtain an exact identifiability theorem rather than an informal “up to permutation” claim.
- **Smallest MVP/falsifier:** at `q=13`, train from the four equality matrices with view colours removed, then test whether every zero-loss relabelling lies in the proved group. Add controlled edge noise and measure canonical-state recovery. Failure is that the exact noiseless rigidity gives no useful noisy/statistical stability.
- **Novelty risk:** medium. Algebraic multi-view identifiability is mature, but this finite uncoloured reduct and exact gauge group appear unusual; a stability theorem is needed for broad ML interest.

### 2. Lossless constraint sketches and canonical serialization — **DIRECT primitive, TRANSLATION system**

- **Cards:** K12, K19, K20.
- **Primitive:** binary and ternary minimal nonfaces intrinsically reconstruct the ambient object; binary data alone provably loses information, and the required marking is known.
- **User/problem:** compact, canonical interchange and deduplication of relational datasets whose records arise from sparse forbidden configurations; also exact isomorphism fingerprints for scientific databases.
- **Smallest MVP/falsifier:** encode a corpus of finite configurations as continuation complexes, reconstruct bit-for-bit, and compare size/collision rate with graph-only encodings. Kill it if ternary data costs as much as the original incidence table or canonicalization dominates runtime.
- **Novelty risk:** medium-high because hypergraph serialization is established; value lies in a proved minimal-enough schema for this family.

### 3. Adversarial feature-route resilience — **TRANSLATION**

- **Cards:** K14, K16, K17.
- **Primitive:** for all minimal inference supports, matching `nu` measures simultaneous disjoint routes, transversal `tau-1` measures exact arbitrary feature failures, and fractional matching measures throughput; these can separate sharply and survive modular composition.
- **User/problem:** sensor fusion, cascaded inference, and feature-on-demand systems currently scored only by route count or disjoint redundancy.
- **Smallest MVP/falsifier:** represent each prediction route by its required-feature set; compare `nu`, `tau`, and observed worst-case outage accuracy on the explicit all-symbol seed, then on one real feature graph. Kill if support extraction is unstable or exact `tau` adds no decision value over ordinary robustness tests.
- **Novelty risk:** high at the abstract level—matching versus hitting set is classical—but a complete inference-support profile and composition theorem may be useful.

### 4. Completion distance as a statistical breakdown point — **TRANSLATION-NEEDED**

- **Cards:** K6, K7.
- **Primitive:** minimum deletions needed to permit a different completion, plus the intersection core shared by every completion; relative multiple saturation certifies the threshold.
- **User/problem:** incomplete experimental designs, latent-table completion, and discrete model identification: distinguish parameters forced by the data from those merely selected by an optimizer.
- **Smallest MVP/falsifier:** compute core and completion distance for small incomplete Latin/design tables, then compare with posterior/model multiplicity under random and adversarial missingness. Kill if it merely reproduces known teaching dimension, rigidity, or breakdown-number invariants.
- **Novelty risk:** high until a non-geometric model class yields a new bound.

### 5. Voltage-aware potential shaping — **SPECULATIVE**

- **Cards:** K3–K5.
- **Primitive:** a candidate charge combining slack, components, intruders, parity, cycle voltage, and sumset support; counterexamples prove which state variables cannot be omitted.
- **User/problem:** sparse-reward RL on dynamically changing conflict graphs.
- **Smallest MVP/falsifier:** use exact q=13/q=17 tables, potential-based shaping `gamma*Phi(s')-Phi(s)`, and ablate voltage/sumset terms before labels are inspected. Kill if sample efficiency does not improve or gains require oracle value features.
- **Novelty risk:** very high; reward shaping is classical and current `Psi` is empirical.

## Best bet

The four-view `M_(0,5)` reduct is the strongest unexpected bridge: it offers an exact finite identifiability/gauge theorem, with noisy stability as the single sharp gate to information-geometry and multi-view-learning relevance.
