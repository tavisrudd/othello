# Wildcard key-card sweep C

**Date:** 2026-07-11  
**Scope:** shallow independent sweep; exact correspondences only

## Survivors

### 1. Adversarial reliability versus service capacity

**Cards:** K14, K16, K17.

**Translation.** For one stored symbol, minimum repair supports are a hypergraph. Its matching number `nu` is the maximum number of helper-disjoint simultaneous repair choices; its transversal number `tau` is the minimum number of unavailable helpers that disables every minimum repair; its fractional matching is the corresponding splittable service rate. K16 supplies an all-symbol code with `tau>nu`; K17 copies the entire bounded-radius hypergraph into every concatenated inner block, provided the outer dual distance is at least `r+2`.

**Bigger prize.** Fixed-alphabet, positive-rate, positive-distance storage families with separately certified parallelism, adversarial outage tolerance, and fractional service capacity—parameters normally collapsed into “availability.”

**First falsifier.** Check that the operational model really restricts to minimum-size linear repairs and independent helper capacity; allowing larger repairs or shared bandwidth can change all three optima. Mathematically, violate the outer dual-distance gate and search for a cross-block low-weight dual word.

**Maturity:** theorem-ready inner/transfer package; systems significance unbenchmarked.

### 2. Latent geometry from compatibility-only data

**Cards:** K11, K12.

**Translation.** Treat legal continuations as records and fibre coincidences of the four rational projections as equality-only observations. K11 identifies every automorphism of that uncoloured observation graph (`q>=13`) as geometric `S4` plus Frobenius. More generally, K12 treats forbidden pairs and collinear triples as minimal nonfaces of a simplicial complex and reconstructs the plane, selected arc, and secant arrangement above an explicit threshold.

**Bigger prize.** An identifiability theorem for recovering a latent finite-field schema from anonymized joins or local incompatibility data, with possible error-correcting/noisy reconstruction variants. This is closer to database dependency discovery and discrete structure learning than to another cap theorem.

**First falsifier.** Delete or merge one observation channel and recompute automorphisms; one extra nongeometric automorphism kills identifiability. For the complex, test just below the profile threshold or under one corrupted minimal nonface.

**Maturity:** exact noiseless rigidity; robustness and algorithms open.

### 3. Proof-carrying reward shaping and state discovery

**Cards:** K3, K4, K18, K20.

**Translation.** The residual game is a finite deterministic MDP. Use `Psi` only as a potential-shaped training reward, while terminal game value remains the objective; attach a rules-checkable certificate to every accepted trajectory. K3 supplies a precise representation obstruction: quotient features that omit the `Z2` cycle voltage alias states known to require different behavior. K20 turns refuted selectors and decompositions into mandatory held-out counterexamples.

**Bigger prize.** A benchmark and workflow for neural-guided discovery in combinatorial games where dense heuristic rewards accelerate search but proof-carrying outputs prevent reward hacking; failed abstractions actively refine the state representation.

**First falsifier.** Freeze features and reward before training, then test whether identical feature-plus-voltage states still have mixed optimal actions on held-out exact tables or whether shaping worsens cross-order generalization.

**Maturity:** deployable research software pattern; no policy theorem.

### 4. Additive-structure compression of search states

**Cards:** K5, K18.

**Translation.** A conic parameter set `T` determines exactly the direction set `T+T`; small doubling therefore licenses a generalized-arithmetic-progression representation instead of a quadratic chord list. Certificates can expand the compressed state before rules checking.

**Bigger prize.** Output-sensitive memo keys and trajectory compression for large finite-geometry searches, possibly exposing the structured states on which a uniform selector should be sought.

**First falsifier.** Measure `|T+T|/|T|` on predeclared exact trajectories; saturation near `q` or the `d=4` empty-reservoir phase removes the advantage.

**Maturity:** exact encoding map; performance hypothesis only.

## Independent ranking

1. K14+K16+K17: strongest immediate publishable/application package.
2. K11+K12: most surprising larger mathematical prize.
3. K3+K4+K18+K20: best software/ML research program.

**Combination not to overlook:** K3+K11+K19. Reduct rigidity determines the legal global symmetries, while voltage proves that an unmarked quotient still loses a necessary holonomy bit. Together they prescribe a canonical encoding: quotient by `S4`/Frobenius, but retain signed-cycle voltage. That is an exact minimal-state design principle for both tablebases and equivariant graph models.
