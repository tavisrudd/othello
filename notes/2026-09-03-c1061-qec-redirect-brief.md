# C1061 QEC redirect brief: compile the certified decoder policy, and build TigerBlossom

**Lane**: `complete-ports`
**Source**: Tavis's notes from Sol, 2026-09-03, after probes 13 and 17 closed the dense
space-cut decoder as a per-shot competitor to sparse blossom (64x to 82x more instructions at
matched accuracy, 15x after sparsity-aware composition, crossover only at a defect density where
decoding is meaningless). That negative stands. This brief reframes the QEC target rather than
fighting it.

## Reframing

Ergodis is not the per-shot decoder; it compiles the smallest certifiably safe decoder policy.
Dense all-boundary-state recomposition is the wrong online representation for sparse surface-code
syndromes. Five routes, in priority order.

### 1. Context-certified predecoder (pursue first)

The window decoder forced the seam state to zero; the exact result depends on whether the optimum
wants a seam error. Do not choose a seam state. For a local syndrome `s`, let `b` range over every
reachable boundary state through which the future can interact with the window, and let `K(s,b)`
be the set of commit-region corrections occurring among optimal witnesses conditional on `b`.

    Safe(s)  <=>  intersection over reachable b of K(s,b) is nonempty

If a correction `a` lies in the intersection, commit `a`: whatever future makes some `b` globally
optimal, a minimum-weight local explanation compatible with `b` already contains `a`. Otherwise
defer. Compile `s -> a | defer` offline, minimize it with the worklist automaton minimizer from
probe 13, and run it as a LUT/FSM tier hierarchy:

    T=2 policy: SAFE -> commit, else T=4 policy: SAFE -> commit, else T=6, else strong decoder

Probe 13's disagreement counts (389/40,000 at T=2 and 90/40,000 at T=6 at p=1%) suggest ambiguity
is sparse enough to test, but say nothing yet about safe/defer coverage. The deliverable is the
curve `certified fast-path coverage(p, d, T)`, with overall accuracy identical to the strong
decoder by construction (deferred cases go to it). Provenance tiers: PROVED SAFE may commit;
BOUNDED SAFE may commit under a declared fault bound; OBSERVED CONFIDENT is advisory only;
AMBIGUOUS goes to the strong decoder. Automated predecoding is not novel (NVIDIA AI predecoder
plus PyMatching; generalized qLDPC predecoders handling over 90% of workload); an automatically
synthesized, minimized, context-certified predecoder with zero-authority ambiguity fallback is
the distinctive version.

### 2. The dense boundary matrix is probably overparameterized (highest risk, highest upside)

The `W x W` table came from a minimum-weight matching problem, not a generic tropical matrix.
Matching costs indexed by exposed terminals form a valuated even delta-matroid;
matching-mimicking networks replace an interior by a finite terminal gadget; planar matching
boundary signatures satisfy Pfaffian / Grassmann--Plucker (matchgate) identities. Hypothesis: the
256-entry object at width 16 is an expanded form of a much smaller matching object. Probe:
convert each boundary table to a terminal-subset matching valuation; test the delta-matroid
exchange identities; test tropicalized matchgate/Wick identities on the planar repetition case;
recover the smallest weighted matching gadget reproducing every entry exactly; compose gadgets
and compare against dense min-plus. If 256 entries collapse to tens of parameters the negative
changes; if not, kill it quickly. This is the only route by which Ergodis stays an exact online
global decoder without reproducing sparse blossom (Fusion Blossom's insight is the same: work on
the sparse decoding graph, fusion cost depends on the boundary).

### 3. CPU instructions do not settle FPGA/ASIC

Dense fixed-size min-plus is hardware-friendly; blossom is branchy and pointer-heavy. At height T
a node has about `2^(3T)` add/compare candidates (64 at T=2, 512 at T=3, 4,096 at T=4), the tree
levels are fixed, so a pipeline has deterministic latency and can accept an event per cycle.
Synthesize T=2, 3, 4 before declaring the representation commercially dead; never a T=6
monolith; combine with the tier hierarchy above. Existing hardware decoders run well under 1 us.

### 4. Compete on soft output

The framework already computes the minimum cost in both logical classes, so the complementary
gap `Delta(s) = C_1(s) - C_0(s)` is free. Soft output drives yoked/hierarchical codes,
postselection, abort, adaptive windows (a 2026 adaptive-window decoder cuts buffer size about
40% on a spatiotemporal gap). Next external baseline is PyMatching's `decode_gap`, not only
`decode`. For k logical qubits the naive gap needs up to `4^k` decodes, where the quotient
machinery may differentiate. Beyond min-weight, change semiring to logical-class likelihood mass
(sum over errors with the given syndrome and class), i.e. maximum-likelihood logical decoding,
which MWPM is not.

### 5. Stop benchmarking where PyMatching is mathematically ideal

Probe 13's detector model is a pure matching graph. Keep that negative prominent, but move the
next campaign to bivariate-bicycle / qLDPC CSS codes, correlated circuit noise, leakage and
erasures, multiple logical qubits, code deformation, and families with large automorphism
groups, where no sparse-blossom representation dominates and automatic decoder synthesis is
worth more. The claim there is "given this stabilizer structure and noise model, Ergodis
discovers the decoder representation and compiles a specialized policy", not "faster BP".

Deprioritized: the distance 15/25/51 crossover sweep (a crossover near d=3,000 is not commercially
relevant) and ordinary sliding windows (they fix the seam pathology, not the representation).

## TigerBlossom: an internal zero-allocation sparse-blossom kernel

Worth testing as a specialized reimplementation of sparse blossom, not a Rust translation of
PyMatching and not the dense kernel. PyMatching v2 is performance-conscious C++ but not
bounded-memory software: its arena mallocs when the free list empties, the flooder owns growing
vectors, a radix-heap event queue, and pointer-linked `DetectorNode*` / `GraphFillRegion*` /
`AltTreeNode*` objects. The bar is high: probe 13 measured 497 / 843 / 1,195 / 1,484 instructions
per decode at d = 3 / 5 / 7 / 9 and p = 1%. Zero allocation alone will not give 10x. Prior for an
algorithmically identical generic port: 0.8x to 1.2x. Prior for Tiger discipline plus code-family
specialization plus fixed graph plus exact common-case fast paths: 1.5x to 3x, with higher gains
possible in some error regimes. A tie is still useful: a deterministic-tail, bounded-memory
substrate Ergodis can specialize and emit is a better base for productization and FPGA
translation than a C++ library call.

Design:

- Compile the detector model into a `KernelSpec`: node and edge counts, max degree, integer
  weights, max simultaneous defects, max blossom objects, event capacity, observable count.
  Workspace allocated once at init; the hot loop has no malloc, no growth, no hash map, no
  formatting, no virtual dispatch, no unbounded recursion.
- Integer IDs (`u16`, `NONE = MAX`) instead of pointers; consider SoA for regions.
- Specialize the graph away: compile-known degree and neighbor offsets for interior nodes,
  separate boundary kernels; no adjacency loads for repeated interior geometry.
- Fixed-capacity radix heap from arrays; ask whether a bucket/calendar queue suffices when edge
  weights come from a small finite vocabulary.
- Exact fast paths before blossom: 0 defects return; 2 and 4 defects direct; non-interacting
  clusters local; the compiler may prove sufficient predicates for each. Every fast path exact.
- Epoch/generation stamps instead of clearing state; reset scales with touched state, not
  detector count.
- Batch-internal SIMD for the front and back ends (defect extraction, zero-syndrome detection,
  logical parity); multiple independent workspaces per core.
- Scope: compiled graph plus syndrome bits in, logical prediction plus weight/gap out. No Python
  API, loaders, or CLI. Roughly 2 to 4k lines of disciplined Rust for the first
  repetition/surface implementation. PyMatching's core is several thousand lines across driver,
  flooder, matcher, search, tracker.

Experiment: freeze probe 13's inputs; reproduce PyMatching at d in {3, 5, 7, 9, 15, 25} and p in
{0.001, 0.01, 0.05}; require the same MWPM weight, the same logical prediction modulo tie policy,
zero allocations across the batch, bounded memory. Report instructions, cycles, branches and
misses, L1 and LLC misses, peak workspace bytes, p50 / p99 / max per shot, paired A/B with CIs,
pinned binary hashes, fixed-window harness.

Architecture: `ergodis-qec` = compiled FastPath (zero/small/simple patterns, exact local rules)
plus TigerBlossom (general exact fallback). Claim: same exact MWPM answer as PyMatching,
substantially less work on the target code family.
