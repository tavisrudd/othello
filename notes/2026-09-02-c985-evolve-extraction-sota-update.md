# C985 evolve/extraction SOTA update

**Date:** 2026-09-02  
**Scope:** bounded architecture import; no novelty or priority verdict

## Summary

This update consulted two primary preprints, **0 at full-text depth and 2 at partial
depth**. The strongest immediate import for Ergodis is exact simplification before
feature extraction or quotienting. Heuristic local-cost thresholds are useful proposer
and warm-start mechanisms but cannot authorize pruning. A treewidth-parameterized exact
backend is a later high-value option when a promoted expression/evidence graph remains
sparse after simplification.

## Findings and Ergodis decisions

1. **Keep heuristic extraction outside authority.** Yin et al.'s e-boost combines a
   parallel heuristic, a local-cost threshold, and warm-started ILP. The paper explicitly
   states that its threshold can remove a globally optimal node. Ergodis may import that
   pattern for proposer scheduling, probation, and warm starts, but never for a negative
   theorem or exact-pruning claim.
2. **Simplify before paying extraction cost.** Sun, Zhang, and Ni translate e-graphs to
   cyclic monotone circuits, simplify them, and then run exact tree-decomposition DP.
   Their reported corpus reductions make lossless simplification the first implementation
   target here: constant folding and universal algebraic identities should run before the
   observational value quotient.
3. **Treewidth DP is the next exact backend, not the first patch.** Their bag state retains
   the boundary evaluation, which true values are locally justified, and boundary
   reachability needed for cycles. This is another instance of exact finite interface
   state. It should be imported if promoted theorem/evidence graphs become large and
   sparse enough that measured width is small.
4. **Non-additive costs remain an opening, not a claim.** Sun et al. identify general
   child-dependent costs as an open difficulty and suggest retaining multiple minimal
   symbolic costs. Ergodis already has bounded Pareto and contextual-state machinery that
   could instantiate that idea. A broader literature audit and a real control are required
   before any novelty statement.

## Sources and read depth

- Jiaqi Yin, Zhan Song, Chen Chen, Yaohui Cai, Zhiru Zhang, and Cunxi Yu,
  *e-boost: Boosted E-Graph Extraction with Adaptive Heuristics and Exact Solving*,
  arXiv:2508.13020v2 (2025). **Read depth: partial** — cached PDF/text key
  `arXiv:2508.13020`, SHA-256
  `f4ae758b3410282be4ea5415e25c21c41488581a6e929e5ddf94fc3eef83a538`; read the
  abstract, Introduction, Section IV.B–C threshold/exact-solving discussion, Section V
  setup, and Conclusion. The 558x/19.04% figures are the authors' reported benchmark
  summaries, not independently reproduced here.
- Glenn Sun, Yihong Zhang, and Haobin Ni, *E-Graphs as Circuits, and Optimal Extraction
  via Treewidth*, arXiv:2408.17042v2 (2024). **Read depth: partial** — cached PDF/text key
  `arXiv:2408.17042`, SHA-256
  `c5fce6d0d3d8d208fd2e068aeb32d260d3312f1bb78436966c969017ae309673`; read the
  abstract, Introduction, Section 3.2 algorithm, Section 4.2 evaluation discussion, and
  Section 5 future directions. The `2^{O(w^2)} poly(w,n)` bound and simplification
  percentages are the authors' statements.

## Search trace and coverage

Primary-source metadata was queried through the arXiv API with:

```text
search_query=all:"equality saturation"; sortBy=submittedDate; descending; max_results=10
search_query=all:"e-graph extraction"; sortBy=submittedDate; descending; max_results=10
```

The second query returned the two selected exact/hybrid extraction papers among its recent
results. This was a bounded mechanism search, not an exhaustive predecessor or
forward-citation audit. No absence claim is licensed. ACM DL, Semantic Scholar,
OpenAlex, Crossref, zbMATH, MathSciNet, and Google Scholar were not covered because no
novelty verdict is made. The supplied arXiv versions, not later published versions, were
read.

## Next implementation gate

Implement a source-to-source exact `FeatureDag` simplifier with a complete old-to-new node
map, checked constant folding, and only universally valid identities. Compare every source
and simplified node on exhaustive bounded rows, then measure compile/evaluation economics.
Do not add heuristic threshold pruning to the authority path.
