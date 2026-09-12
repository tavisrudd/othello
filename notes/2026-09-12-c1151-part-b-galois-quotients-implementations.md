# C1151 part B — Galois connections, quotient algorithms, symmetry, and what the reference implementations actually compute

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** capability study. No code written; nothing
under `~/src/ergodis*` edited.

**Status: IN PROGRESS — written incrementally, source by source.**

## Posture

This is a capability pass, not a novelty pass. The question throughout is **what can Ergodis do
after absorbing this that it cannot do now**, and prior art is a template to copy, never a gate.
Where a reference implementation exists, I read its code and say what it actually computes, rather
than what its paper says it computes.

Gradient-based search and small simple neural networks are in scope. Only methods that need deep
or large networks, or a GPU, are out; those are marked as such and dropped.

Read depth is recorded on every source unconditionally, including sources named only to be
dismissed. Every PDF fetched is added to the shared cache at `/tmp/persistent/tavis/lit-search/`
with its key and SHA-256.

Companion: `2026-09-12-c1150-part-b-compilers-solvers-normalization.md` (first pass). Its
absorption rows 1–5 are re-treated here at algorithm depth in §5; its Ergodis-object map (O1–O9)
is reused rather than repeated, and I refer to those labels directly.

## 1. Galois connections and abstract interpretation

### 1.1 What the framework actually says

**Patrick Cousot, Radhia Cousot, "Abstract Interpretation Frameworks", Journal of Logic and
Computation 2(4):511–547, 1992.** *Read depth: partial* — author's PDF from
`di.ens.fr/~cousot/publications.www/`, cached as `10.1093/logcom/2.4.511`, SHA-256
`19591e44a5584e27547538d3ed553a7b26b78d9fe234f129fbba3c2a735f89bb`, 38 pages; read in full:
abstract, §1 Introduction, Example 4.6 (the Galois connection framework) with equation (4.12),
and the widening/narrowing iteration definitions (4.34)–(4.36), Propositions 6.10, 6.12 and 6.17
by statement. Proofs were not read. `pdftotext` mangles this paper's lattice symbols, so where a
symbol mattered I cross-checked against the PLILP'92 paper below rather than relying on the
extraction.

**Patrick Cousot, Radhia Cousot, "Comparing the Galois Connection and Widening/Narrowing
Approaches to Abstract Interpretation", PLILP 1992, LNCS 631, pp. 269–295.** *Read depth:
partial* — author's PDF from the same site, cached as `cousot-plilp-1992-galois-vs-widening`,
SHA-256 `498546a795fdae4667658030ea0d2eb51a979ad4edd9a601643a3e99d1cf79e3`, 29 pages; read in
full: abstract, §1, §2 (the collecting-semantics setup and Examples 1–3), §3's widening and
narrowing axioms (6)–(8) and (10)–(11), the iteration sequences (9) and (12), and Example 11
(interval widening and narrowing, equations 13–14). The type-graph widening (Example 12) and the
proofs in the appendix were skimmed.

**Patrick Cousot, Radhia Cousot, POPL 1977, "Abstract Interpretation: A Unified Lattice Model for
Static Analysis of Programs by Construction or Approximation of Fixpoints", DOI
10.1145/512950.512973.** *Read depth: abstract/metadata only* — the author's PDF was fetched and
cached under that DOI key, SHA-256
`5d2956eed13b2d40f6e15c2087fb870c3dea54a332fe46ee07cea608ca417238`, 16 pages, but `pdftotext`
extracted **zero words**: it is an image scan and the cache records it as `no-text`. I did not
read it. Everything attributed to the 1977 and 1976 papers below comes from the two 1992 papers
at the depths recorded above, which cite them as `[CC76]` and `[CC77a]`.

**The Galois connection (JLC'92, Example 4.6, equation 4.12).** Concrete properties `P♮` and
abstract properties `P` are complete lattices, and the correspondence is an abstraction map
`α : P♮ → P` with a concretization `γ : P → P♮` such that

> `∀c ∈ P♮ . ∀a ∈ P . α(c) ⊑ a ⇔ c ⊑♮ γ(a)`

The soundness relation is exactly `α(c) ⊑ a`, and `α(c) = ⊓{a | ⟨c,a⟩ ∈ σ}` — the abstraction is
the *best* sound abstract value, obtained as a greatest lower bound. This is the whole content of
"sound approximation" in one line: `a` is a sound abstract answer for `c` iff `c` is within the
concretization of `a`, and `α` picks the tightest such `a` when one exists.

**Widening (PLILP'92, equations 6–8).** A widening is `∇ : L × L → L` with

1. `∀x,y ∈ L . x ⊑ x ∇ y`
2. `∀x,y ∈ L . y ⊑ x ∇ y`
3. for every increasing chain `x⁰ ⊑ x¹ ⊑ …`, the chain `y⁰ = x⁰`, `yⁱ⁺¹ = yⁱ ∇ xⁱ⁺¹` **is not
   strictly increasing** — i.e. it stabilises.

The upward iteration with widening (equation 9) is then

```
X̂⁰ = ⊥
X̂ⁱ⁺¹ = X̂ⁱ                if F(X̂ⁱ) ⊑ X̂ⁱ
       = X̂ⁱ ∇ F(X̂ⁱ)        otherwise
```

and its limit is a sound upper approximation of `lfp F`, reached in finitely many steps. They note
that on a join-semilattice satisfying the ascending chain condition, `⊔` is itself a widening —
so widening strictly generalises "just use a finite lattice".

**Narrowing (PLILP'92, equations 10–12).** A narrowing `Δ : L × L → L` satisfies
`(y ⊑ x) ⇒ (y ⊑ (x Δ y) ⊑ x)` and stabilises every decreasing chain. The downward iteration
`X̌⁰ = Â`, `X̌ⁱ⁺¹ = X̌ⁱ Δ F(X̌ⁱ)` is ultimately stationary and **every term** is a sound upper
approximation — so it can be stopped at any point and the intermediate answer is still valid.

**The interval domain, concretely (PLILP'92, Example 11).** `L = {⊥} ∪ {[ℓ,u] | ℓ ∈ ℤ∪{−∞},
u ∈ ℤ∪{+∞}, ℓ ≤ u}`, with

```
⊥ ∇ X = X ;  X ∇ ⊥ = X
[ℓ₀,u₀] ∇ [ℓ₁,u₁] = [ if ℓ₁ < ℓ₀ then −∞ else ℓ₀ ,
                      if u₁ > u₀ then +∞ else u₀ ]

⊥ Δ X = ⊥ ;  X Δ ⊥ = ⊥
[ℓ₀,u₀] Δ [ℓ₁,u₁] = [ if ℓ₀ = −∞ then ℓ₁ else ℓ₀ ,
                      if u₀ = +∞ then u₁ else u₀ ]
```

The widening "extrapolates unstable bounds to infinity"; the narrowing "improves infinite bounds
only". The authors explicitly note the widening is **not monotone**: `[0,1] ⊑ [0,2]` but
`[0,1] ∇ [0,2] = [0,+∞] ⋣ [0,2] = [0,2] ∇ [0,2]`. That is not a defect — soundness of the
iteration does not need monotonicity of `∇` — but it is the trap anyone reimplementing it falls
into.

Their thesis, which is the capability point: infinite abstract domains with widening/narrowing are
**strictly more powerful** than the Galois-connection approach restricted to finite lattices or
lattices with the chain condition, and restricting to finite lattices "can only be to the
detriment of precision."

### 1.2 What Ergodis gains

**Ergodis objects touched:** O4 admission checks; `ordered_resource` bounds and Pareto fronts
(C1091's table lists `src/ordered_resource.rs` as "finite ordered monoids, validated laws, Pareto
fronts and frozen query plans"); the bounded-probe step in C1091's plan item E, query-directed
autonomous compilation; and O2 `FeatureDag`'s checked-overflow semantics.

Three distinct capabilities, in increasing order of what they unlock.

**(a) Interval analysis as a second interpretation of a `FeatureDag`, for static overflow
screening.** This was an incidental lead in the first pass; on capability grounds it is a
first-class item. Ergodis's `FeatureDag` arithmetic is checked signed arithmetic where **overflow
is an evaluation error**, and `feature_term_program` lowering already has a documented
observation-boundary problem: whole-DAG evaluation evaluates every node while lowering follows
only the selected root's dependencies, so a simplification can discard an expression that would
have failed. Interval analysis answers the underlying question directly and statically: *given
declared input ranges, can this subterm overflow at all?* The abstract transfer functions are
four-line: for `Add`, `[a,b] + [c,d] = [a+c, b+d]`; for `Mul`, the min and max of the four corner
products (Elliott's `IFun` instance in the first pass gives exactly this); for `Abs` and the
Gaussian/Eisenstein norms, the monotone image of the box; for `Mod` by a positive `u16` modulus,
`[0, m−1]` and tighter when the input interval is already inside a residue.

The capability is new, not a restatement: Ergodis today distinguishes "reachable overflow" from
"unrelated overflow" *in a test corpus* (`tests/feature_lowering_semantics.rs`). Interval analysis
makes that a decidable property of a term plus an input declaration, which is what the lowering
needs to know before it discards a subterm. No fixpoint, no widening — a `FeatureDag` is acyclic,
so a single topological pass computes the exact interval abstraction with no iteration at all.
That makes this the cheapest item in the whole study.

**(b) Widening as the missing piece of the bounded-probe step.** C1091's plan item E asks for
"bounded proposal/probe/challenge/admission selection" and says budgeted probing "must account for
its own cost and support abandoning a losing compilation." The widening axioms are exactly a
specification for that: a probe that must terminate but must still return something sound. The
third axiom — every increasing chain stabilises — is the termination guarantee, and the first two
are soundness. What Ergodis currently has instead is a budget counter, which gives termination but
no statement about the answer at the cut-off. A widening gives both, and the narrowing phase adds
the property Ergodis most wants from a budgeted process: **every intermediate term of the
downward iteration is already sound**, so the probe can be stopped at an arbitrary point by the
budget and the answer is still usable.

My inference: the thing to copy is not the interval domain but the *shape* — an abstract iteration
in which the loop body is `if F(X) ⊑ X then stop else X ∇ F(X)`, and a separate downward pass that
can be truncated freely. That shape is what makes a probe's cost controllable without making its
answer conditional.

**(c) Galois connection as the type of an admission check.** Ergodis's glossary says query
admission is "checking that a representation supports a particular question and its assumptions"
and that "rejection is not a false answer to that question." Equation (4.12) is the statement that
`α(c) ⊑ a ⇔ c ⊑♮ γ(a)`: a representation `a` is admissible for a concrete situation `c` exactly
when `c` lies inside `γ(a)`. The two readings of admission Ergodis keeps apart — "is this
representation sound here" and "what is the best representation here" — are the two sides of the
same adjunction, and `α(c)` is the canonical answer to the second. Where Ergodis's admission is a
yes/no predicate today, a Galois-connection formulation additionally yields the *best* admissible
representation as a greatest lower bound, which is a constructive upgrade rather than a
reformulation.

The caveat I would attach, and it is the authors' own: the best-abstraction map `α` exists only
when the greatest lower bound exists. The 1992 papers' whole point is that many useful abstract
domains do not have one, and that insisting on it costs precision. So Ergodis should not require
every representation family to carry an `α`; the soundness relation `σ` alone (JLC'92 §4) is the
weaker hypothesis that still supports the framework, and it is closer to what Ergodis's
representation contracts actually assert.

### 1.3 Experiments and gates

**Experiment A (interval screening).** Implement the interval abstraction as a second
interpretation over `FeatureDag`, one topological pass, no iteration. Declare input ranges from
the existing `FeatureBatch` limits. *Gate:* on the existing 1,984-row lowering corpus, every row
the concrete evaluator overflows must be flagged as *possible* by the abstraction (soundness, zero
false negatives permitted), and the count of rows flagged possible but not actually overflowing is
reported as the precision number. A second gate: for every selected-root lowering that discards a
subterm, the abstraction must say whether the discarded subterm could have overflowed — the
current corpus documents both cases and can be used as the oracle.

**Experiment B (widening-shaped probe).** Take one existing bounded probe in the Evolve proposal
path and restructure it as an upward iteration with an explicit widening plus a truncatable
downward narrowing pass. *Gate:* the probe terminates in the same or fewer steps than the current
budget cut-off on the retained fixtures, and — the part that is new — the answer returned at every
truncation point of the narrowing pass is checkable as a sound bound by the existing independent
checker.

**Neither experiment needs gradients, a neural network, or a GPU.** Interval propagation over an
acyclic DAG is, however, embarrassingly data-parallel across rows: the same topological schedule
applied to `k` independent input boxes is a width-`k` map, which is a plausible `wgpu` compute
kernel if Evolve ever screens a large candidate population at once. I would not start there — the
single-pass CPU version is small enough to be the first experiment — but the parallel formulation
is immediate and is noted in the absorption table.

## 2. Bisimulation, partition refinement, coalgebraic minimization

This is the section with the largest capability gap between what Ergodis has and what is
available off the shelf. Ergodis's `ValidatedQuotient` checks a *supplied* compiled quotient
against a `FinitePresentation` and explicitly declines to claim minimality. Partition refinement
**computes** the coarsest such quotient, and the generic coalgebraic version computes it for
weighted, probabilistic and polynomial (signature) systems from one implementation.

### 2.1 The classical algorithms, and the one trick that makes them fast

**Hopcroft's trick.** Both Hopcroft's `O(n log n)` DFA minimization and Paige–Tarjan's
`O(m log n)` relational coarsest-partition algorithm rest on the same accounting: when a block is
split into `k` parts, you may do work proportional to all `k−1` **smaller** parts but never to
the largest part. Jacobs and Wißmann state it as a design rule (§2.4 of their paper, read below):
"if we split `{1,…,9}` into `{1,3}`, `{5,7,9}`, `{2,4,6,8}`, then `{1,3}`, `{5,7,9}` are both
considered 'smaller parts', whereas `{2,4,6,8}` is the larger part." The consequence is that each
element changes block-number at most `O(log n)` times, because each change at least halves the
size of the block containing it.

**Paige–Tarjan's three-way split, concretely** (as restated by Wißmann–Dorsch–Milius–Schröder,
Example 6.3, read at the depth recorded in §2.2). Maintain two partitions `X/P` (subblocks) and
`X/Q` (compound blocks) with `P` finer than `Q`. Initially `X/Q = {X}` and `X/P` is the partition
by output behaviour — for deterministic automata, final versus non-final; for transition systems,
deadlock versus live; for weighted systems, grouped by the sum of outgoing weights. Then iterate
while `P ≠ Q`:

```
1. pick a subblock S ∈ X/P with S ⊊ C for some compound block C ∈ X/Q
2. refine X/Q by splitting C into S and C\S
3. refine X/P to the coarsest refinement in which two states are distinguished
   whenever the transition structure distinguishes them up to Q   ("stability")
```

Steps 1 and 2 are transition-type independent; only initialization and step 3 depend on the
system type. Step 3's implementation is the interesting part. Splitting `C` into `S` and `C\S`
splits each `B ∈ X/P` into at most three blocks: states with edges to `S` but not `C\S`, states
with edges to both, and states with edges to `C\S` but not `S`. This is done in time linear in
the number of **ingoing edges to `S`** — independent of `|C\S|` and `|B|` — by giving all edges
from one state `x` into one compound block `C` a **shared integer counter** (each edge holds a
pointer to a counter cell). When `C` splits, count the edges from `x` into `S`; if the count
equals the shared counter, all of `x`'s edges to `C` went to `S`; if it is smaller, decrement the
shared counter by `n` (which correctly updates every sibling edge at once) and allocate a fresh
counter of value `n` for the edges into `S`.

### 2.2 The generic version: one algorithm, many system types

**Thorsten Wißmann, Ulrich Dorsch, Stefan Milius, Lutz Schröder, "Efficient and Modular
Coalgebraic Partition Refinement", Logical Methods in Computer Science 16(1) (2020), pp.
8:1–8:63; arXiv:1806.05654.** *Read depth: partial* — arXiv PDF, cached as `arXiv:1806.05654`,
SHA-256 `1cab984653b130c003faa3078885fac873dbf7f6d8cc00bbf2000faf5d005488`, 63 pages; read in
full: abstract, §1 Introduction with the related-work accounting, §3's informal Algorithm 3.1 and
Remark 3.2, Example 3.3 (Paige–Tarjan and Valmari–Franceschinis as instances), Definition 5.1
(zippability) with Examples 5.4 and 5.10, Example 6.3 (the counter trick), and Definition 6.4
(the refinement interface). Proofs, the categorical Algorithm 4.9 and the complexity proof in §7
were read by statement only.

The algorithm is parametric in a **type functor** `H : Set → Set`, so a coalgebra `ξ : X → HX`
is the system. Instances recover: `H = P_f` for unlabelled transition systems, `H = 2 × (−)^A`
for deterministic automata over a fixed alphabet, `H = M^(−)` for `M`-weighted transition
systems, Segala systems, and colour refinement.

Two conditions make it work and make it fast.

**Zippability (Definition 5.1).** `H` is zippable when the canonical map
`H(A + B) → H(A+1) × H(1+B)` is monic. Every **polynomial** functor is zippable (Example 5.4(3)),
as are constant functors, the identity, `P_f`, the bag functor `B_f`, monoid-valued functors
`M^(−)`, and finite products and coproducts of zippable functors. `P_f P_f` is **not** zippable
(Example 5.10), which also shows zippable functors are closed under neither quotients nor
composition. This matters to Ergodis because it is the precise condition under which the cheap
"split three ways" step is correct; without it the refinement step is simply wrong, not just slow.

**The refinement interface (Definition 6.4).** Given a functor encoding — a label set `A` and a
map `♭ : HX → B_f(A × X)` presenting the coalgebra as labelled edges — a refinement interface is
a set `W` of weights plus two functions

```
init   : H1 × B_f A  →  W
update : B_f A × W   →  W × H3 × W
```

subject to two commuting squares relating them to a weight map `w : P_f X → (HX → W)`, such that
`update` applied to (the edges into `S`, the weight for `C`) yields (the weight for `S`, the
three-way classifier in `H3`, the weight for `C\S`). The integer counter of Paige–Tarjan is the
instance `W = 2 × ℕ` with `w(C)(t) = (|t \ C| > 0, |t ∩ C|)`,
`init(z, n) = (0, n)`, `update(n_S, (r, n_C)) = ((r ∨ (n_{C\S} > 0), n_S), …)`. For monoid-weighted
systems, `W = G × G` with `w(C)(f) = (Σ_{y∉C} f(y), Σ_{y∈C} f(y))` and
`init(h₁, e) = (0, Σe)`, `up(e, (r,c)) = (r, c − Σe, Σe)`.

**Complexity.** If the interface operations run in linear time, the algorithm runs in
`O(m · log n)` with `n` nodes and `m` edges, matching the best known bounds for transition
systems (Paige–Tarjan), weighted systems (Valmari–Franceschinis), colour refinement
(Berkholz–Bonsma–Grohe) and Hopcroft's DFA algorithm.

**Antti Valmari, "Bisimilarity Minimization in O(m log n) Time", Applications and Theory of Petri
Nets 2009 (PETRI NETS 2009), Paris, LNCS 5606, pp. 123–142, DOI 10.1007/978-3-642-02424-5_9.**
*Read depth: abstract/metadata only* — resolved via web search against the Springer and Tampere
University Research Portal landing pages; the full text was not obtained (Springer paywall, no
open preprint located). Recorded because it is the source of the **refinable partition data
structure with amortized constant-time operations**, and because its bound holds even when the
number of transition labels is not fixed. That last point is the one Ergodis would care about and
it is the one I could not verify from the paper itself. The related Valmari–Franceschinis Markov
chain lumping algorithm (cited as `[VF10]` throughout Wißmann et al.) is characterised here only
through Wißmann et al.'s Example 3.3, at that paper's recorded depth: it works for `ℝ`-weighted
systems, and its initial partition groups states by the sum of outgoing weights.

I flag this as an **access gap**, not a searched-and-found-nothing: the algorithmic content I use
below comes from Wißmann et al. and from Jacobs–Wißmann, both read directly.

### 2.3 What the fastest current implementation actually computes

**Jules Jacobs, Thorsten Wißmann, "Fast Coalgebraic Bisimilarity Minimization",
arXiv:2204.12368 (POPL 2023 version).** *Read depth: partial* — arXiv PDF already in the cache,
SHA-256 recorded in the manifest under `arXiv:2204.12368`; read in full: abstract, §1
Introduction with the memory-comparison paragraph, §2.4 (Hopcroft's trick), §2.5 with Algorithms
1 and 2, §4.1's definition of a signature, and the artifact/repository statements. The formal
coalgebra development in §3 and the benchmark tables in §6 were read by statement only.

Their generic algorithm makes at most `O(m log n)` calls to the functor-specific operation. Their
own framing of the tradeoff is worth quoting: more specialised algorithms "can be asymptotically
faster than our algorithm (usually by a factor of `O(m/n)`)", but theirs "is especially well
suited to efficient implementation." The headline measurement: the distributed CoPaR algorithm
needed a **265 GB cluster** to minimize an automaton with 1.3 million states and 260 million
edges; **Boa does the same automaton in 1.7 GB**, because it needs no large auxiliary structures
and stores the automaton in an immutable binary format.

The pseudocode (their Algorithm 2):

```
procedure PartRefSetFun(automaton)
    put all states in one block; mark all states dirty
    while the number of blocks grows:
        pick a block with dirty states
        compute the successor structures of the dirty states and one clean state
        mark all states in the block clean
        split the block, keeping the old block number for the largest sub-block
        mark all predecessors of changed states dirty
```

The two ideas are (i) a state's successor structure changes only if one of its successors changed
block, so track dirty/clean; and (ii) all clean states of a block share the same successor
structure, so recomputing **one** clean representative suffices.

**Reference implementation: Boa** (`github.com/julesjacobs/boa`, Rust; archived at Zenodo DOI
10.5281/zenodo.7150706). *Read depth: full text of `src/optalg.rs` (183 lines), `src/refpart.rs`
(271 lines), and the canonicalisation and back-reference portions of `src/coalg.rs` (423 lines),
fetched from `raw.githubusercontent.com/julesjacobs/boa/master/` on 2026-09-12 into the session
scratchpad.* What it actually computes:

- **`RefinablePartition`** is four flat vectors plus a worklist:
  `buffer: Vec<State>` (all states, grouped by block), `position: Vec<u32>` (inverse index),
  `state2block: Vec<u32>`, and `partition: Vec<(u32,u32,u32)>` where a block is a triple
  `(start, mid, end)` with `start..mid` **clean** and `mid..end` **dirty**, plus
  `worklist: VecDeque<u32>` of blocks holding at least one dirty state. Initial state is
  `partition = vec![(0, 0, n)]` — one block, every state dirty.
  *(Implementation note: the doc comment on the `partition` field states the opposite convention
  — "start..mid are dirty and mid..end are clean" — and contradicts both the `new()` comment and
  `mark_dirty`, which early-returns on `mid <= pos` as "already dirty". The field comment is
  stale. Worth knowing before reading the file.)*
- **`mark_dirty` is `O(1)`** and allocation-free: it decrements the block's `mid`, then swaps the
  state with whatever sat at `mid−1`, updating `position` for both. It early-returns for
  singleton blocks (`end − start <= 1`), which is a real optimisation, not a special case.
- **`refiners(id)`** returns `buffer[mid−1 .. end]` when clean states exist, else
  `buffer[start .. end]` — the dirty states plus exactly one clean representative, in `O(1)`.
- **`refine(block, signatures)`** is a **counting sort** by signature: `counts_vec` then `cumsum`,
  then a single pass writing each state to its slot and updating `position`. The largest
  sub-block (`index_of_max`) keeps the old block id; the others get fresh ids appended to
  `partition`. Clean states are only iterated when the largest sub-block is *not* the one the
  clean states landed in — which is exactly the Hopcroft accounting. It returns the new block ids,
  and the caller marks every predecessor of those states dirty via `coa.state_backrefs(state)`.
  The source carries a `TODO` that the old id should go to "the block with the fewest
  predecessors" rather than the largest block — an unexploited improvement.
- **Back-references** are built once in `Coalg::new` as a CSR-style pair
  (`backrefs: Vec<u32>`, `backrefs_locs: Vec<u32>`) by a two-pass count-then-fill.
- **The signature is a 64-bit FxHash digest, not an exact key.** `canonicalize_unsafe` walks the
  encoded successor structure substituting current block ids for states and folds it into an
  `FxHasher64`: ordered children (`LIST_TYP`) are hashed in order; unordered (`SET_TYP`,
  `TAG_TYP`) are collected, `sort_unstable()`ed, deduplicated and then hashed; weighted nodes
  (`ADD_TYP`, `MAX_TYP`, `OR_TYP`) go through `hash_with_op`, which sorts by child signature,
  folds duplicate children's weights with `+`, `max` or `|`, and hashes the resulting
  `(signature, aggregated weight)` pairs. So **the aggregation of weights into the same successor
  block happens inside the signature**, which is what makes weighted lumping fall out of the same
  code path.

The consequence Ergodis must not miss: **Boa's result is correct only up to 64-bit FxHash
collisions.** FxHash is a fast non-cryptographic hash; a collision merges two inequivalent states
silently. Paige–Tarjan's counter-based split is exact by comparison. Boa's own test suite
(`optalg.rs`) hedges against this empirically — `paper_fixtures_match_naive_refinement` and
`generated_graphs_match_naive_refinement` compare against the naive exact algorithm on the paper
fixtures and on 100 random graphs of up to 40 states — but that is a test, not a proof. For a
system whose whole design premise is that "a successful build does not prove mathematical
preservation," this is exactly the kind of trust boundary Ergodis has to state explicitly.

**Fabian Birkmann, Hans-Peter Deifel, Stefan Milius, "Distributed Coalgebraic Partition
Refinement", arXiv:2204.06248 [cs.DS], 13 April 2022.** *Read depth: abstract/metadata only* —
arXiv PDF, cached as `arXiv:2204.06248`, SHA-256
`152020f149feec99eb1f3332c43bc689700cbccea51a3f05fde9a73d9f419176`, 22 pages; abstract and §1
opening read. Recorded for the parallelism question: they extend the **Blom–Orzan** signature-based
distributed algorithm to the coalgebraic level and implement it in CoPaR, motivated by memory
rather than time — "memory consumption is a bottleneck for handling systems with a large state
space, while running times are fast" — and report that "running times are low in most experiments,
but there is a significant penalty for some."

**Hans-Peter Deifel, Stefan Milius, Lutz Schröder, Thorsten Wißmann, "Generic Partition Refinement
and Weighted Tree Automata", arXiv:1811.08850.** *Read depth: abstract/metadata only* — arXiv
PDF, cached as `arXiv:1811.08850`, SHA-256
`178d0489d414f8571fbc1b464356cee8d25230335f2e4bb2dff4b32a0d0f9a93`, 28 pages. Recorded as the
source that extends the generic algorithm to **weighted tree automata** over a field or a
cancellative monoid, which is the instance closest to Ergodis's retained composition trees.

### 2.4 What Ergodis gains, and which quotient this computes

**Ergodis objects touched:** O3 — `ValidatedQuotient`, `AdmittedObservable`, and representative
catalogs; O5 — the min-plus summary trees; O8 — Evolve's structure discovery, since a computed
coarsest quotient is a proposal generator rather than a proposal checker.

Three capabilities, in order of how directly they land.

**(a) Compute the quotient Ergodis currently only checks.** `ValidatedQuotient::new` takes a
compiled quotient and verifies that declared generators induce well-defined class transitions.
Partition refinement over `H = 2 × (−)^A` (deterministic presentations with an output) *produces*
the coarsest such quotient in `O(m log n)`, and does so for weighted presentations
(`H = M^(−)`) with no change of algorithm. The documented limitation that "reusing an existing
quotient can retain extra classes" is then not a caveat to live with but a measurable gap: run
refinement, compare class counts.

**(b) The refinement interface is the right generalisation boundary, and Ergodis already has
its analogue.** `init`/`update` over a weight set `W` is a small, non-categorical API — two
functions and two equations. Ergodis would implement it once per representation family, exactly
as it already implements a checker per family. The zippability condition tells it in advance
which families this is sound for: polynomial functors (so the `FeatureDag` signature — Input,
Constant, Add, Sub, Mul, Mod, Abs, GaussianNorm, EisensteinNorm — qualifies), monoid-weighted
structures (so min-plus summaries qualify), and finite products and coproducts of these. `P_f P_f`
does not, which is a genuine boundary rather than an artifact.

**(c) The min-plus summary tree is a weighted coalgebra and refinement lumps it.** Wißmann et
al.'s weighted instance sums the weights of edges into each block; Boa's `hash_with_op` with
`ADD_TYP` does exactly that fold in the signature. For Ergodis's tropical algebra the fold is
`min` rather than `+`, which Boa already supports as `MAX_TYP`/`OR_TYP`-shaped idempotent folds.
*Caveat carried from the first pass:* Ergodis's `u32::MAX` saturation means the weight monoid is
not cancellative, and the `[VF10]`-style algorithms for weighted lumping assume a group or a
cancellative monoid in places (the weighted interface above uses `c − Σe`, a subtraction). The
generic paper's own extension to non-cancellative settings is the weighted-tree-automata work
recorded above, which I did not read at depth. **This is the single most important open question
in this section** and it is checkable rather than speculative.

### 2.5 Experiments and gates

**Experiment C (compute the coarsest quotient).** Encode one existing `FinitePresentation` in
Boa's input format and run `partref_nlogn`; separately implement the same refinement directly in
Rust against Ergodis's own structures (Algorithm 2 above is ~60 lines given the `RefinablePartition`
design, which is public and small). *Gate:* the computed partition refines every quotient
`ValidatedQuotient` currently accepts for that presentation, and is no coarser than any of them;
on the corpus, report how many extra classes the existing quotients retain. Exactness must be
established against the naive algorithm on the whole corpus, **not** assumed from Boa's hashing —
either use exact signature keys, or accept the hash and state the collision bound as a declared
precondition of the result.

**Experiment D (weighted lumping of a min-plus summary tree).** Instantiate the refinement
interface for the bounded tropical weight monoid and lump one summary tree. *Gate:* the lumped
tree's root cost equals the original's for every leaf assignment in the fixture set, and — the
part that tests the real risk — a fixture deliberately constructed to saturate at `u32::MAX`
either lumps correctly or is rejected by an explicit non-cancellativity check, never silently
mis-lumped.

**Parallelism.** Signature-based refinement is the data-parallel formulation: computing the
signature of every dirty state in a block is a pure map over states with no cross-state
dependence, and Blom–Orzan's distributed algorithm is built on exactly that observation. A
`wgpu` compute kernel over a CSR-encoded coalgebra is a plausible experiment — signature
computation is the hot loop and it is a per-state fold over a contiguous edge slice. But
Jacobs–Wißmann's result argues against starting there: they beat a 265 GB distributed cluster
with a single-machine 1.7 GB Rust implementation, so the first experiment should be the
single-threaded Rust one, and GPU only if measurement shows the signature map dominating.
*Needs: neither gradients nor a neural network; GPU-parallel formulation exists but is not the
cheapest first step.*

## 3. Symmetry: orbits, groupoids, and symmetry breaking in exact search

### 3.0 The distinction this section turns on

There are two different things one can do with a group `G` acting on a search space `X`:

- **Assume invariance.** Restrict the search to the fixed-point set `X^H` for a subgroup `H`.
  This is *lossy*: solutions outside `X^H` are not found. It is a shard, and its emptiness is a
  statement only about that shard.
- **Quotient the search.** Search `X/G` instead of `X`, by ensuring that exactly one
  representative of each orbit is ever visited. This is *lossless*: every orbit that contains a
  solution is still reached.

C1016's multiplier program is the first kind. Its card says a multiplier shard "assumes each
`X_i` is invariant under the subgroup generated by a unit of `Z/522`", and having closed 148 of
167 nontrivial units it concludes that "the search cannot inherit an orbit structure and runs on
unrestricted sign vectors." That conclusion is correct about the *first* kind and says nothing
about the second. The symmetry group of the defining equation still acts on the unrestricted
search space, and the second kind of reduction does not need any `X_i` to be individually
invariant. Making that separation is the capability content of this section; §3.4 says which
parts of C1016 it can and cannot reach.

### 3.1 Canonical augmentation: generate one representative per class, with no global isomorphism test

**Brendan D. McKay, "Isomorph-free exhaustive generation", Journal of Algorithms 26 (1998)
306–324.** *Read depth: partial* — author's PDF (`users.cecs.anu.edu.au/~bdm/papers/orderly.pdf`,
which states it "approximately matches the published version … except for one corrected value in
Table 2 and the erratum noted in Section 7"), cached as
`mckay-1998-isomorph-free-exhaustive-generation`, SHA-256
`cda1821ad8d37600eb5a0bba642457c06be77cb4d2507ce6f1095d31f089a351`, 19 pages; read in full: §1
Introduction's taxonomy of methods, §2's complete formal development (conditions C1–C7,
M1–M3, Lemma 1, procedures `scan` and `scan2`, Theorems 1–3), and the worked triangle-free-graph
example threaded through it. The Latin rectangle and block design applications in §§5–7 and the
statistical estimation material were skimmed.

McKay's taxonomy separates **orderly generation** (there is a canonical labelled object in each
isomorphism class and that is the one generated — Faradžev, Read) from **canonical construction
path** generation, which is his subject: "objects are produced by somehow augmenting a smaller
object, with only objects made via a canonical augmentation being accepted. Intermediate objects
can even be relabelled at random with no effect."

The machinery. Each labelled object `X` has a set `L(X)` of **lower objects** (ways of shrinking)
and `U(X)` of **upper objects** (ways of growing); a group `G` acts on all of them. The single
onerous ingredient is a function `m : L → 2^Ľ` satisfying

```
M1.  L(X) = ∅          ⇒  m(X) = ∅
M2.  L(X) ≠ ∅          ⇒  m(X) is an orbit of Aut(X) acting on L(X)
M3.  m(X^g) = m(X)^g    for every g ∈ G
```

`m` induces a unique **parent** map `p` on isomorphism classes (Lemma 1), so the classes form a
forest rooted at the irreducible objects, and generation is a depth-first traversal of that
forest:

```
procedure scan(X : labelled object, n : integer)
    output X
    for each orbit A of Aut(X) acting on U(X):
        select any X̂ ∈ A
        if f'(X̂) ≠ ∅:
            select any Y̌ ∈ f'(X̂), with Y̌ ∈ L(Y)
            if o(Y) ≤ n and Y̌ ∈ m(Y):  scan(Y, n)
```

**Theorem 1:** `scan(X₀, n)` outputs **exactly one** labelled object from each isomorphism class
of order at most `n` descended from `X₀`. In McKay's own informal phrasing: "given an isomorphism
class … we make a set of potential children by applying `f'`. These are tested using `m` to see
which are real children and which are not."

Two practical notes he makes and I would carry across. First, a usable `m` can be defined
crudely — "consider all the labellings of `X`, choose the one greatest under some ordering … let
`v*` be the vertex labelled 1 … define `m(X)` to be the lower objects `⟨X,v⟩` with `v` equivalent
to `v*` under `Aut(X)`" — and then improved with real canonical-labelling tools plus cheap
invariant screening beforehand. Second, `scan2` replaces the `Aut(X)`-orbit computation with
explicit isomorphism testing **restricted to the children of one node**, which is the version to
reach for when computing automorphism orbits is the awkward part. Theorem 3 additionally lets the
traversal be split across independent parallel runs.

### 3.2 Canonical labelling in practice

**Brendan D. McKay, Adolfo Piperno, "Practical graph isomorphism, II".** *Read depth:
abstract/metadata only* — arXiv PDF already in the cache as `arXiv:1301.1493`, SHA-256
`2173fcd10d99c269eec4d28d2089887452eb972456c52a1b961a2bf186194029`, 22 pages. Recorded as the
authority for the `nauty`/`Traces` individualization–refinement method; I did not read it for
this task.

**Adolfo Piperno, "Search Space Contraction in Canonical Labeling of Graphs",
arXiv:0804.4881v2 [cs.DS], 26 January 2011.** *Read depth: abstract/metadata only* — arXiv PDF,
cached as `arXiv:0804.4881`, SHA-256
`813e1bcf10a267e89c0ebb8a7a31b8a94738159f47ecc69d1798c8a361d65d3c`, 26 pages; abstract and §1
opening read. *(Cache note: this key was fetched while looking for a Valmari paper and was
initially recorded under the wrong title; the manifest entry has been corrected, with the
misfiling recorded in its `note` field. The same correction was applied to `arXiv:2006.09055`,
which is a nonabelian Hodge theory paper and not the partition-refinement paper I was after.)*
Recorded for one fact used below: the individualization–refinement paradigm computes a canonical
labelling **and** the automorphism group together, and its inner refinement step is colour
refinement — the same 1-Weisfeiler-Leman procedure that appears in §2 as an instance of generic
partition refinement. That is not a coincidence to note in passing: it means one refinement
implementation serves both the quotient computation of §2 and the canonical-form computation
here.

### 3.3 Symmetry breaking inside an exact search

**Jo Devriendt, Bart Bogaerts, Maurice Bruynooghe, Marc Denecker, "Improved static symmetry
breaking for SAT", SAT 2016, LNCS 9710, pp. 104–122, DOI 10.1007/978-3-319-40970-2_8.** *Read
depth: partial* — author's PDF at `bartbogaerts.eu/articles/2016/003/`, cached as
`devriendt-2016-improved-static-symmetry-breaking-sat`, SHA-256
`daf6c22f8718e1a5a4c0214c11fb5578378ca858e7d869a5a487989d36658dce`, 17 pages; read in full:
abstract, §1 Introduction, §3's Definition 1 and Theorem 1 with its proof, and §4's Definition 2
and Theorem 2. The experimental evaluation was skimmed.

Their framing is the useful one: a symmetry breaking formula is **sound** if it preserves at
least one assignment from each class of symmetric assignments, and **complete** if it preserves
at most one. Symmetries are found by converting the problem to a coloured graph whose
automorphism group is the problem's symmetry group and handing it to `nauty`, `saucy` or `bliss`
— which is the direct bridge from §3.2 to search.

**The lex-leader constraint (their Definition 1, after Crawford, Ginsberg, Luks and Roy).** Given
a symmetry `π` and a variable order, `LL_π` eliminates every assignment whose image under `π` is
lexicographically smaller. Crawford et al.'s original form:

```
∀i :  (∀j < i : x_j ⇔ π(x_j))  ⇒  ¬x_i ∨ π(x_i)
```

**Their Theorem 1** gives a compact CNF encoding: with `Supp(π) = {x₁,…,xₙ}` in order and fresh
auxiliaries `y₀,…,y_{n−1}`,

```
y₀
¬y_{i−1} ∨ ¬x_i ∨ π(x_i)          1 ≤ i ≤ n
y_j ∨ ¬y_{j−1} ∨ ¬x_j             1 ≤ j < n
y_j ∨ ¬y_{j−1} ∨ π(x_j)           1 ≤ j < n
```

— three ternary clauses per variable in the support, against Aloul et al.'s two clauses of size
three plus two of size four. The conjunction over a subset of the group is sound but not
necessarily complete, and in practice the constraint is truncated at `k` auxiliaries because
group size forbids covering every element.

**Their Theorem 2 (row interchangeability).** If a variable matrix `M : Ro × Co → Σ` has a row
interchangeability symmetry group and the variable order is row-major (`x_{ij} ≺ x_{i'j'}` iff
`i < i'`, or `i = i'` and `j ≤ j'`), then the lex-leader constraints for the **adjacent-row
transpositions alone** break the whole group **completely**, in linear size. They stress the
order must match the matrix or the theorem fails. This is the one case where a full symmetric
group is broken completely and cheaply, and it is a template rather than an exotic result.

**Katrin Herr, Richard Bödi, "Symmetries in Integer Programs", arXiv:0908.3331v1 [math.CO],
23 August 2009.** *Read depth: abstract/metadata only* — arXiv PDF, cached as `arXiv:0908.3331`,
SHA-256 `b46b53721df02fa2967c70f3cb32da5e272f7801ebcea1d7ff58828111af8509`, 16 pages; abstract
and §1 opening read. Recorded for the diagnosis rather than the theorem: "symmetry in integer
programs usually entails many equivalent solutions, the branches belonging to these solutions
cannot be pruned, which leads to very poor performance." Their own result — an integer program
whose symmetry group is an alternating group `A_n` is solvable in time linear in `n` — I did not
verify and do not use.

**Markus Anders, Sofia Brenner, Gaurav Rattan, "satsuma: Structure-based Symmetry Breaking in
SAT", SAT 2024; arXiv:2406.13557.** *Read depth: abstract/metadata only* — arXiv PDF, cached as
`arXiv:2406.13557`, SHA-256
`150a8291988716e197ee7076443c8e51594f1b57daa8f0e2441c45d24a321546`, 28 pages. Recorded as the
current state of the art succeeding BreakID, and as evidence that this is a live engineering
area rather than settled history. Not used for any claim here.

**James Ostrowski, Jeff Linderoth, Fabrizio Rossi, Stefano Smriglio, "Orbital branching",
IPCO 2007; journal version Mathematical Programming 126(1):147–178 (2009), DOI
10.1007/s10107-009-0273-x.** *Read depth: abstract/metadata only* — resolved through the
Springer and Optimization Online landing pages via web search; no PDF was obtainable and none
was cached. The characterisation here is from those landing pages: the method computes, at each
node, the orbits of the variables under **the symmetry group remaining after branching** —
including symmetry not present at the root — and uses those orbits to partition the feasible
region. The distinction that matters for Ergodis is that this is **dynamic** symmetry exploitation
(recomputed down the tree) against the **static** preprocessing of BreakID; I could not verify
the reported speedups and do not cite them. Bibliographic detail is from the landing pages, not
the article.

**Coverage note.** I made three separate attempts to obtain François Margot's survey "Symmetry in
Integer Linear Programming" (the *50 Years of Integer Programming* chapter) and each returned an
HTML interstitial rather than a PDF; the cache's magic-byte check rejected them. Recorded as
**could not access**, not as searched-and-found-nothing. Nothing in this section depends on it,
but it is the standard survey and its absence is a real gap in this section's coverage.

### 3.4 Groupoids, and the link back to §2

A group acting on a set gives an **action groupoid** `X // G`: objects are the states, and a
morphism `x → y` is a `g ∈ G` with `g·x = y`. Two facts make this the right vocabulary rather
than decoration. First, the set of connected components `π₀(X // G)` **is** the orbit set `X/G`,
so "quotient by symmetry" and "connected components of the action groupoid" are the same
computation, and the isotropy group at `x` is `Aut(x)` — the same `Aut(X)` that McKay's condition
M2 quantifies over. Second, a groupoid is what you need when the symmetry is **partial** —
isomorphisms between sub-objects rather than automorphisms of the whole — which is precisely
McKay's situation, where `f` and `f'` relate different objects and only `m` refers to `Aut(X)`.

The link to §2 is concrete rather than analogical. Colour refinement computes the coarsest
partition stable under the transition structure; the orbit partition of `Aut` is always a
refinement of it, and the two coincide exactly when the structure is amenable. Nauty's inner loop and the colour-refinement instance of
generic partition refinement (listed by Wißmann et al. among the bounds their algorithm matches,
citing Berkholz–Bonsma–Grohe) are the same procedure. So an Ergodis implementation of §2's
refinement interface is also the inner loop of a canonical-labelling routine — one
implementation, two capabilities.

### 3.5 What Ergodis gains, with C1016 as the concrete target

**Ergodis objects touched:** C1016's bordered Goethals–Seidel search over `Z/522`, specifically
its exact enumeration arms and its inequivalent-shell corpus; O8 Evolve's structure discovery;
O3 representative catalogs (a catalog of orbit representatives *is* a representative catalog with
a group-theoretic coverage argument).

**The symmetry group C1016 actually has.** The bordered target is the supplementary difference
set `4-{522; 260, 261, 261, 261; 520}`: four subsets `X_i ⊆ Z/522` with
`Σ_i X_i X_i^{-1} = 523 + 520·T` in the integral group ring. That equation is invariant under at
least: (i) **independent translation** of each `X_i`, since `(t + X)(t + X)^{-1} = X X^{-1}` in
an abelian group; (ii) **common unit multiplication** `X_i ↦ g·X_i` for a unit `g`, since
`(gX)(gX)^{-1} = g X X^{-1} g^{-1} = X X^{-1}`; and (iii) **permutation of the three blocks of
equal size 261**. That is `522⁴ · 3!` from (i) and (iii) alone, before any units. Every one of
these is a symmetry of the *unrestricted* problem and none of them requires any `X_i` to be
invariant under anything. This is my own derivation from the card's stated equation, not a claim
from any source, and it should be checked against the private implementation before anything is
built on it — in particular whether the Goethals–Seidel array and the border impose extra
conditions that kill (iii).

Three capability claims follow, in decreasing confidence.

**(a) Exact enumeration arms can carry isomorph rejection today.** The card records exhaustive
enumerations — "a subset-sum over projected orbits" deciding 167 units, "1,984,512 sealed `q18`
source interfaces", and "the exhaustive two-transfer census over all twelve then-banked plateau
states". These are exactly the setting McKay's `scan` addresses: an inductive construction where
one representative per isomorphism class suffices. Where the enumeration is over a structure with
a `522⁴·3!` group acting, the reduction is not marginal. The gate is not "is it faster" but "does
it still cover" — canonical augmentation's Theorem 1 is what makes the coverage claim
provable rather than hoped for, which matters because C1016's own provenance rule says exact
computational enumerations grant negative coverage and heuristic predicates do not.

**(b) The inequivalent-shell corpus needs a declared group and gets an exact key.** The card says
the corpus is "now 39 inequivalent shells, up from the twelve the campaign ran on". Inequivalent
under *what*? A canonical form under a declared group turns that from a pairwise test into a
lookup key: compute the canonical representative, index by it, and the corpus is deduplicated
exactly and incrementally. If the group currently used is smaller than the one in the derivation
above, some of the 39 are the same shell and the corpus is narrower than it looks; if it is
larger, the reverse. Either way the number is only meaningful with the group attached. Cheap to
settle.

**(c) The inner tabu loop is where this does *not* apply, and saying so matters.** The live arm
is "a full-neighbourhood tabu step with exact incremental per-swap deltas". Canonical-form
computation per step would destroy the incremental delta structure that makes that step viable,
and a single-element swap does not move along a translation orbit anyway. So symmetry reduction
is a lever on enumeration, corpus management and restart seeding — **not** on the descent. The
one measurable question it does raise: tabu tenure and aspiration are defined on states, so two
states in the same orbit are distinct tabu states, and a plateau of the size the card reports
(the `q174` fibre "holds about `2^1322` exact solutions") may contain large orbits that the
search re-enters. Whether that costs anything is a measurement, not an argument.

**What the card already measured, and I am not contradicting.** The character-domain move set —
"exactly the per-block Galois multipliers, 81 elements above a fixed `q174` state and 1,296 above
a fixed `q29` shell" — is a group-action move set, was exhaustively censused on every banked
plateau state, and "improves nothing". That is a measured negative about using the group as a
*descent operator*. It says nothing about using it as a *quotient* for enumeration or dedup,
which is a different use of the same group, and the distinction is exactly §3.0's.

### 3.6 Experiments and gates

**Experiment E (declare the group, canonicalise the corpus).** Write down the symmetry group of
the bordered SDS as implemented, including whatever the Goethals–Seidel array and border impose,
and implement a canonical form for it — for the translation part this is the cyclic-string
canonical rotation (Booth's algorithm, linear time), for the block permutation a sort of the
three equal blocks by their canonical rotations, for units a minimum over the surviving unit
orbit. *Gate:* recompute the equivalence classes of the 39-shell corpus under the declared group
and report the class count. A change in either direction is a finding; no change confirms the
corpus. Also: the canonical key must be a pure function of the shell, verified by canonicalising
each shell from several random group translates and checking the key is identical.

**Experiment F (isomorph-free enumeration on one banked arm).** Take one already-completed exact
enumeration — the two-transfer census is the smallest — and re-run it as a canonical augmentation
with `m` defined by the canonical form from Experiment E. *Gate:* the set of objects output is in
bijection with the equivalence classes of the original exhaustive output (so the original result
is reproduced, not merely approximated), and the node count is reported against the original.
Because C1016's provenance rule requires exact enumerations to grant negative coverage, this
gate is coverage-preservation first and speed second.

**Experiment G (lex-leader for one shard).** For any arm expressible as a Boolean/CNF or 0–1 ILP
sub-problem, add lex-leader constraints for the adjacent generators of the block-permutation
subgroup using Theorem 1's three-ternary-clause encoding, with the row-major variable order
Theorem 2 requires. *Gate:* the solution count over the shard drops by exactly the expected orbit
factor and no previously-found solution's orbit disappears — checked by re-expanding each
surviving solution under the group and confirming every original solution is recovered.

**Parallelism and other requirements.** McKay's Theorem 3 explicitly licenses splitting the
`scan` traversal across independent runs, so canonical augmentation is **embarrassingly parallel
at the subtree level** with no shared state. That is a good fit for CPU threads and a poor fit
for a GPU: the work per node is irregular (canonical labelling with backtracking) and the tree is
unbalanced. Orbit enumeration and canonical rotation over fixed-length sign vectors, by contrast,
*are* uniform data-parallel kernels — computing the canonical rotation of `k` candidate vectors
of length 522 is a width-`k` map with a fixed inner loop, and a `wgpu` kernel is plausible if
Evolve ever canonicalises a large population per generation. *Needs: neither gradients nor a
neural network; GPU-plausible for the canonical-rotation map, CPU-parallel for the traversal.*

## 4. Lawvere theories, free models, and polynomial functors

## 5. First-pass rows 1–5 at algorithm depth, with reference-implementation inspection

## 6. Set aside on the first pass, reassessed on capability alone

## 7. Absorption table

## 8. Coverage and search record

## 9. Incidental leads
