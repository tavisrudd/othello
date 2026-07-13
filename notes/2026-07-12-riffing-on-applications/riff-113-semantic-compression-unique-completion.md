# Semantic compression by unique completion

Status: exploratory paper agenda  
Primary source: `RIFF_95`, `RIFF_96`, `RIFF_113`, `RIFF_114`, `RIFF_184`, `RIFF_202`  
Existing mathematical base: completion distance, defining sets/transversals, continuation
reconstruction

## Mathematical spine

- [`MATH_12`](math.md#math_12--defining-querytransversal-duality) — identifying-query sets are
  transversals of pairwise disagreement edges.
- [`MATH_16`](math.md#math_16--completion-family-induces-an-error-correcting-identification-code) —
  a completion family induces a response code with ordinary error/erasure guarantees.
- [`MATH_19`](math.md#math_19--completion-lengthrobustnesscertificate-tradeoff) — honest bit-cost,
  robustness, and certificate tradeoffs are the open theorem target.

## Thesis

A combinatorial object can be compressed semantically by storing a small defining subset or query
trace together with a deterministic reconstruction rule and a certificate of unique completion.
The same invariant controls robustness to deletion and description length, linking completion
theory, experimental identification, and certified encoding.

## Minimum publishable contribution

1. Define a semantic completion code for a finite hereditary independence system or another sharply
   specified object class.
2. Relate code length to defining-set/transversal parameters and deletion robustness to completion
   distance.
3. Give exact families or bounds where the semantic encoding is nontrivially smaller than the raw
   representation.
4. Provide an efficient decoder and uniqueness certificate for at least one structured family.

## Research agenda

### Phase 1 — Model and baselines

- Choose one object class: complete caps, finite designs, constrained configurations, or exact
  solver states.
- Define what side information the decoder receives.
- Compare against canonical raw, entropy-coded, and symmetry-quotiented representations.
- Prevent hidden information from being smuggled into the reconstruction rule.

### Phase 2 — Bounds

- Lower-bound defining-set size from the alternative-completion hypergraph.
- Upper-bound it using explicit constructions.
- Relate error/erasure tolerance to separation among query-response codewords.
- Determine when uniqueness certificates erase the nominal compression gain.

### Phase 3 — Algorithms

- Find small defining sets exactly on finite instances.
- Develop greedy or symmetry-aware approximations.
- Implement deterministic reconstruction and ambiguity witnesses.
- Measure encoded bytes, decode time, and checker time.

### Phase 4 — One applied demonstration

- Compressed configuration, trace, research dossier, or experimental design.
- Make the application secondary to the formal coding model.
- Report cases where semantic compression loses to ordinary compression.

## Paper spine

1. **Introduction:** omit what feasibility uniquely reconstructs.
2. **Completion systems and semantic codes.**
3. **Defining sets, transversals, and lower bounds.**
4. **Robust decoding and completion distance.**
5. **Exact structured families.**
6. **Algorithms and implementation.**
7. **Compression experiments.**
8. **Privacy and leakage:** reconstructability is not always desirable.

## Shallow literature and novelty check

Closest precedents found:

- Defining and critical sets are established for designs and constrained matrices; Cavenagh studies
  partial `(0,1)`-matrices with unique completion:
  [Defining Sets and Critical Sets in (0,1)-Matrices](https://doi.org/10.1002/jcd.21326).
- Algorithms for smallest defining sets of designs long predate this proposal:
  [An Algorithm for Finding Smallest Defining Sets of t-Designs](https://combinatorialpress.com/jcmcc-articles/volume-014/an-algorithm-for-finding-smallest-defining-sets-of-t-designs/).
- Generic compression of non-sequential combinatorial objects is also established:
  [Compressing combinatorial objects](https://arxiv.org/abs/1601.03689).

Preliminary verdict: **high risk of being a reframing unless a coding theorem lands**. “Store a
defining set and reconstruct” is implicit in defining-set theory. A distinct result needs an
explicit semantic code model, total-bit accounting including decoder/certificate side information,
new lower or upper bounds linking completion robustness to code length, and a family with measured
gain over canonical plus entropy coding.

Required deeper audit:

- teaching dimension, sample compression schemes, identifying codes, and test covers;
- succinct certificates for unique completion;
- reconstruction codes and erasure-robust combinatorial encodings.

## Kill criteria

- Certificate and decoder side information consume the compression gain.
- Computing a defining set or decoding is intractable even on the selected structured family.
- The contribution reduces to a renamed defining-set result without a new coding theorem.
- The applied demonstration relies on an unrealistic shared reconstruction rule.
