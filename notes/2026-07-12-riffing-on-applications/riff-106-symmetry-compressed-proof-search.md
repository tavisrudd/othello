# Symmetry-aware exact search with compressed proof artifacts

Status: exploratory paper agenda  
Primary source: `RIFF_4`–`RIFF_6`, `RIFF_29`, `RIFF_30`, `RIFF_106`–`RIFF_110`, `RIFF_125`  
Existing substrate: PGL-quotiented keys, orbit search, dense leaf tables, BuRR stores, raw dumps, and
independent proof-DAG validation

## Mathematical spine

- [`MATH_5`](math.md#math_5--symmetry-quotiented-game-certificate-soundness) — local quotient-DAG
  obligations certify the root game value.
- [`MATH_6`](math.md#math_6--lossy-hint-noninterference) — arbitrary lossy hints preserve exactness
  when they affect ordering only.

## Thesis

For symmetry-rich finite search, the durable output should be a compact independently checkable
proof DAG rather than a raw search tree or trusted tablebase. Compression occurs at several layers:
group quotienting, repeated-subproblem merging, value retrieval, early-break certificates, and
certificate-aware move ordering. Lossy structures may guide discovery but never determine the
authoritative result.

## Minimum publishable contribution

1. Specify the search/certificate architecture and its trust roles precisely.
2. Quantify compression from raw tree to canonical DAG to final certificate on multiple instances.
3. Demonstrate a succinct value or routing layer with exact independent replay.
4. Show that certificate-aware search can improve artifact size or check time without compromising
   solve correctness.

## Research agenda

### Phase 1 — Artifact taxonomy

- Authoritative state/value records.
- Fingerprinted or probabilistically exact indexes.
- Lossy hints for ordering or mining.
- Early-break proof records.
- Terminal external certificates checked by a small verifier.

### Phase 2 — Measurements

- Raw nodes and distinct raw states.
- Canonical orbit states.
- DAG edges and early-break edges retained.
- Bits per key/value and total certificate bytes.
- Solve, serialization, and independent check time.

### Phase 3 — Compression mechanisms

- Stabilizer-orbit branching.
- Hash-consed canonical subproblems.
- Template dictionaries by orbit type.
- Delta encoding with canonical transporters.
- Succinct value retrieval plus exact fingerprints or replay.

### Phase 4 — Generality check

- Use at least two game/search families with different symmetry groups.
- Add one small non-game constraint problem if feasible.
- Separate generally reusable techniques from PGL-specific engineering.

## Paper spine

1. **Introduction:** search results as compressed proof objects.
2. **Problem model and group actions.**
3. **Canonical DAG construction.**
4. **Trust-indexed storage layers.**
5. **Certificate extraction and independent checking.**
6. **Certificate-aware search objectives.**
7. **Evaluation and ablations.**
8. **Reproducibility and limitations.**

## Shallow literature and novelty check

Closest precedents found:

- SAT proof logging and small verified checkers are highly developed; LRAT was designed for
  efficient certified checking:
  [Efficient Certified RAT Verification](https://arxiv.org/abs/1612.02353).
- Symmetry and dominance breaking can itself be certified in combinatorial optimization:
  [Certified Symmetry and Dominance Breaking for Combinatorial Optimisation](https://ojs.aaai.org/index.php/AAAI/article/view/20283).
- Minimal perfect hashing, static functions, and retrieval structures are mature succinct-data
  structure areas; see
  [Fast Scalable Construction of (Minimal Perfect Hash) Functions](https://arxiv.org/abs/1603.04330).
- General canonization frameworks already cover graphs, hypergraphs, codes, and permutation groups:
  [A unifying method for canonizing combinatorial objects](https://arxiv.org/abs/1806.07466).

Preliminary verdict: **methods-note novelty, not a new proof-system claim**. The credible gap is the
measured integration of dynamic group quotienting, game-equation early-break DAGs, trust-indexed
lossy/exact stores, and independent replay at hundreds of millions of records. Each component has
strong precedent; the evaluation must show a combination or tradeoff unavailable from simply
encoding the problem in SAT and emitting LRAT.

Required deeper audit:

- proof certificates for solved games and retrograde tablebases;
- certifying dynamic symmetry breaking in graph search/SAT;
- proof-DAG minimization and streaming certificate checking.

## Kill criteria

- Compression gains come almost entirely from ordinary transposition merging rather than symmetry
  or certificate design.
- The checker must replicate most of the solver, defeating the trust-boundary claim.
- BuRR or approximate-memory novelty cannot be separated from established retrieval techniques.
- Results are reported only on one bespoke instance family.
