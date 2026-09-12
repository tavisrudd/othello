# C1151 part B — Galois connections, quotient algorithms, symmetry, and what the reference implementations actually compute

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** capability study. No code written; nothing
under `~/src/ergodis*` edited.

## Opening summary

Twenty-six named sources: eleven papers read at partial depth with the sections recorded, ten at
abstract or metadata only, and **five reference implementations read at source level** — Boa,
`egg`, OpenFst, VeriPB and Catlab.jl. No paper was read at full text, which is the deliberate
shape of a capability pass: the depth went into code and into the specific theorems the
absorption rows rest on. Full tally and coverage statement in §8.

**The largest capability gain is that Ergodis can compute quotients rather than check them.**
`ValidatedQuotient` today verifies a supplied compiled quotient and explicitly declines to claim
minimality. Coalgebraic partition refinement *produces* the coarsest behavioural quotient in
`O(m log n)` from one implementation covering deterministic, weighted and polynomial
presentations, and the fastest current tool is a 183-line Rust main loop over four flat vectors
that minimized a 1.3-million-state automaton in 1.7 GB where a distributed predecessor needed a
265 GB cluster. Its refinement interface is two functions and two equations, not a categorical
framework.

**Three findings exist only because the source was read, and two of them change a
recommendation.**

1. **Boa's signatures are 64-bit FxHash digests**, so the fastest generic minimizer is exact only
   up to hash collision. Its own test suite hedges empirically against a naive reference. Any
   Ergodis adoption must choose: exact keys, or a declared collision bound on the claim.
2. **OpenFst's weight pushing requires `Divide` and explicitly skips arcs at `Zero`** because
   `∞ − ∞` is meaningless. That relocates the blocker the first pass flagged: the tropical
   semiring is fine and OpenFst supports it; what blocks Ergodis is the **saturating `u32::MAX`
   sentinel**, which makes a large finite cost indistinguishable from absence. The first
   experiment is therefore not weight pushing but settling the sentinel.
3. **Catlab's coequalizer is union-find plus a sorted renumbering** — the same structure as
   `egg`'s e-class union-find and Boa's signature renumbering. "Compute a colimit" costs a
   union-find and a sort, so adopting the vocabulary is an API decision, not a performance one.

**Four levers are new relative to the first pass and each is small.** *Interval analysis* over a
`FeatureDag` is a single topological pass — the DAG is acyclic, so no fixpoint and no widening —
and it decides statically whether a subterm can overflow, which is the question selected-root
lowering must answer and currently answers only by test corpus. *Cousot–Cousot widening* supplies
the bounded-probe step with what a budget counter cannot: soundness at the cut-off, plus a
narrowing pass every intermediate term of which is already a valid bound. *McKay's canonical
augmentation* outputs exactly one representative per isomorphism class with a coverage theorem,
which matters for C1016 because its own provenance rule grants negative coverage only to exact
enumerations. And `FeatureDag` **is** a presented Lawvere theory — free term algebra modulo the
simplifier's identities — which turns "which identities may the simplifier use" into a definition
(the relation must hold in the checked-integer model, error domain included) discharged once per
identity instead of argued per rewrite.

**The sharpest single distinction in this pass is in §3.0.** C1016's multiplier program *assumes*
invariance under a subgroup, which is lossy and whose emptiness says nothing beyond that shard.
Quotienting the search by the group that acts on the *unrestricted* problem is lossless and needs
no `X_i` to be invariant under anything. The card's conclusion that "the search cannot inherit an
orbit structure" is correct about the first and silent about the second. My own derivation from
the card's equation gives a symmetry group of order at least `522⁴·3!` acting on the unrestricted
bordered search — not verified against the private implementation, and absorption row 8 is
conditional on that check. It is a lever on enumeration, corpus deduplication and restart seeding,
and explicitly **not** on the inner tabu loop, whose incremental per-swap deltas a canonical-form
computation would destroy.

**On the widened scope.** Nothing in the top six absorption rows needs a gradient, a neural
network, or a GPU. Where a GPU formulation exists it is recorded — signature-based refinement is
a pure per-state map, 1-WL stable colouring has a linear-algebraic form that is matrix–vector
multiplication, canonical rotation of fixed-length sign vectors is a uniform width-`k` map — but
in every case the measured evidence says build the CPU version first. One row uses a *small
model* with no network at all: a sliding-window upper-confidence-bound bandit for Evolve's
proposal ordering, which attacks what `egg`'s `BackoffScheduler` attacks with a fixed heuristic,
using a reward Ergodis already computes. One row needs gradients, and its risk is entirely in
choosing a continuous relaxation, not in the differentiation.

**A process note that belongs in the summary because it affects the cache everyone shares.** I
guessed three arXiv identifiers from memory and all three were wrong — two fetched unrelated
papers and one fetched a relevant paper under the wrong name. All three manifest entries were
corrected with a recorded `note`. The magic-byte check cannot catch this class of error, because
the bytes are a perfectly good PDF of the wrong paper. Resolve identifiers by search before
fetching.

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

### 4.1 A term rewriting system *is* a presentation of an algebraic theory

**Dimitri Ara, Albert Burroni, Yves Guiraud, Philippe Malbos, François Métayer, Samuel Mimram,
"Polygraphs: From Rewriting to Higher Categories", arXiv:2312.00429v2 [math.CT], 4 September
2025; book version Cambridge University Press, DOI 10.1017/9781009498968.** *Read depth: partial*
— arXiv PDF already in the cache, SHA-256
`ca92a986c19ee19e77fee98f9f3cdb81d53502c33ffa7d4e187021651f2e7309`, 669 pages; for this task I
read §4.3.6–4.3.8 (critical branchings and the critical branching lemma) and the whole of §13.1
(§§13.1.8–13.1.15: Lawvere theories, the free Lawvere theory and its adjunction, congruences,
term rewriting systems as presentations, and models), plus §13's introductory road map. In the
companion C1150 pass I read the book's preface in full; that covered Newman's lemma, convergence,
Tietze transformations, Knuth–Bendix completion and Squier's theorem, and I do not repeat those
here. The arXiv preprint was read, not the Cambridge version of record.

The four definitions that matter, in the book's own terms:

- **Lawvere theory (§13.1.8).** For a fixed set `P₀` of sorts, a `P₀`-sorted Lawvere theory is a
  cartesian category `C` with a finite-product-preserving, identity-on-objects functor
  `(F/P₀)^op → C`. Objects are (tuples of) sorts; a morphism `u → a` is a term in context.
- **Free theory (§13.1.9–13.1.10).** The forgetful functor `W₀ : Law_{P₀} → S_{P₀}` from theories
  to signatures has a left adjoint `L₀`, whose value on a signature `P` is the theory `P*`. `P*`
  is the term algebra: all well-sorted terms, no equations.
- **Term rewriting system and the theory it presents (§13.1.12).** A term rewriting system is a
  signature plus a set `P₂` of rules `A : φ ⇒ ψ : u → a` between parallel terms. The theory it
  presents is `P̄ = P*/P₂` — the free theory quotiented by the congruence (§13.1.11) generated by
  the rules.
- **Model (§13.1.13).** A model of `C` is a finite-product-preserving functor `C → Set`.
  Concretely, for a presentation `P`: a set `⟦a⟧` per sort, a function
  `⟦α⟧ : ⟦a₁⟧×…×⟦aₙ⟧ → ⟦a⟧` per operation, **such that `⟦φ⟧ = ⟦ψ⟧` for every relation
  `A : φ ⇒ ψ`.**

And the confluence result that makes normal forms computable: **§4.3.7, the critical branching
lemma** — "a 2-polygraph is locally confluent if and only if all its critical branchings are
confluent" — where a critical branching is a local branching that is *overlapping and minimal*,
the set of them is finite for a finite system (§4.3.9–4.3.14 give the classification and the
enumeration algorithm), and §4.3.8 notes they can be halved by symmetry.

### 4.2 What this says about `FeatureDag`, exactly

**Ergodis objects touched:** O2 `FeatureDag` and its simplifier; O1's several evaluators.

The mapping is not an analogy; it is an identification, and each line of it is checkable against
`scalar-plan-semantics.md`.

| Polygraphs §13.1  | Ergodis                                       |
|-------------------|-----------------------------------------------|
| sorts `P0`        | checked signed integer, plus the u16 modulus  |
| signature `P1`    | the nine FeatureDag node kinds, with arities  |
| free theory `P*`  | the FeatureDag term algebra, hash-consed      |
| rules `P2`        | the simplifier's universal identities         |
| presented theory  | the theory FeatureDag is intended to denote   |
| model into Set    | one evaluator (Rust, Python oracle, interval) |
| normal form       | a chosen representative of a hom-set          |

Expanding the two rows that do not fit a cell: the signature is `Input`, `Constant`, `Add`,
`Sub`, `Mul`, `Mod`, `Abs`, `GaussianNorm` and `EisensteinNorm` with their arities; and the free
theory `P*` is the `FeatureDag` term algebra with hash-consing, canonical topological order and
sharing, while the presented theory is `P̄ = P*/P₂`.

Four consequences.

**(a) The free/presented distinction is the one Ergodis's documentation is circling.**
`FeatureDag` snapshots and hash-consing give the *free* theory: two terms are the same node iff
they are syntactically equal up to sharing. The simplifier's identities are the presentation of
the *quotient*. The compiled-plan hash "identifies logical syntax under the current
implementation" — that is a `P*` identity, not a `P̄` identity, and the documentation's warning
that the hash "does not include field-schema order, compiler version, feature-extractor semantics
or target" is the statement that the same `P*` element can have different models. Naming the two
levels separately is a documentation change with no code cost and it removes a standing
ambiguity.

**(b) The criterion for "which identities may the simplifier use" becomes a definition rather
than a judgement call.** §13.1.13 requires `⟦φ⟧ = ⟦ψ⟧` in every model. So an identity may go into
`P₂` **only if it holds in the checked-integer model**, error domain included. An identity valid
over ℤ but not over checked `i64` with overflow — for example anything that removes a
multiplication that would have overflowed — is simply not a relation of this theory. Ergodis
states the obligation ("preserve both its result and its error domain on in-scope rows") and this
gives it a home: the obligation is model-validity of the relation, and it can be discharged once
per identity rather than argued once per rewrite.

**(c) Partiality is a real obstruction and the book names the analogue.** §13.1.14 remarks that
"there is no Lawvere theory corresponding to fields: intuitively, this is because the inverse
operation is only partially defined (0 is not invertible)." Overflow makes `Add`, `Sub`, `Mul`
and the norms partial in exactly that sense, so the `FeatureDag` signature is **not** literally a
single-sorted Lawvere theory whose models live in Set. The repair is the same one §1 and the
first pass's row 6 point at: take models in a category of partial maps (equivalently the Kleisli
category of the error monad). This is the third independent route to the same conclusion in two
passes, which is itself a reason to treat it as settled rather than open.

**(d) Normal forms are exactly as available as convergence is.** A normal form is a canonical
representative of a hom-set of `P̄`; it exists and is computable when the rewriting system is
convergent; convergence is termination plus confluence; confluence reduces to the *finite* set of
critical branchings by §4.3.7; and the missing rules are added by Knuth–Bendix completion. This
is the same conclusion §5's row 1 reaches from the equality-saturation side, by a different
route, and the two checks are complementary rather than redundant: weak term acyclicity bounds
the saturation, critical-pair confluence establishes that the destructive simplifier reaches a
unique normal form.

### 4.3 Polynomial functors for campaigns

**Nelson Niu, David I. Spivak, "Polynomial Functors: A Mathematical Theory of Interaction",
arXiv:2312.00990v2 [math.CT], 16 August 2024; published in the London Mathematical Society
Lecture Note Series (Cambridge University Press).** *Read depth: partial* — arXiv PDF, cached as
`arXiv:2312.00990`, SHA-256
`02d87ffacc1a54b5cbff1d7b93aa96018afcbda0caa62af0e321bbf4be01c6a5`, 372 pages; read in full: the
preface and chapter road map, §4.1 (Definition 4.1, Moore machines, with Example 4.2's transition
diagram), and §4.2 (Definition 4.18, dependent dynamical systems, Example 4.19's polybox picture,
and Remark 4.20). The comonoid/retrofunctor development of Part II and the parallel-product
constructions of §4.3 were read by their table-of-contents entries only. The arXiv preprint was
read, not the Cambridge version.

**Definition 4.1 (Moore machine):** a state-set `S`, a position (output) set `I`, a direction
(input) set `A`, and two functions `return : S → I`, `update : S × A → S`.

**Definition 4.18 (dependent dynamical system):** a lens `φ : S y^S → p` for a set `S` and a
polynomial `p`. The domain `S y^S` is the *state system*; the codomain `p` is the *interface*;
the on-positions function `φ₁ : S → p(1)` is `return`; the on-directions map
`φ♯ : p[φ₁(−)] → S` is `update`. The picture (Example 4.19) is a channel: the state system
supplies `s ∈ S`, `return` converts it to a position `i ∈ p(1)`, the interface offers the
direction-set `p[i]`, an interacting agent picks `a ∈ p[i]`, and `update` produces the next state
`t ∈ S`.

The part that earns its place here is **Remark 4.20**, which anticipates the obvious objection —
why should the available directions depend on the *position* rather than on the state? — and
answers it as a design principle: "the system's interface should capture everything about how it
interacts with the outside world. In particular, the system's position should capture everything
an external observer could possibly perceive about the system, while the direction-set should
capture all the ways in which an external agent can choose to interact with the system. But if
the set of directions available to an external agent changes, the external agent should be able
to detect this fact."

**Ergodis objects touched:** O6 campaigns, runs and records; the control-plane command/event
vocabulary in the glossary; the frontend action table.

Ergodis's glossary already insists on this separation and states it as a rule rather than a type.
Its command/event pairs (`RequestRunCancellation` versus `RunCancelled`; "a cancellation request
is not a cancelled run"), its rule that "attach … never implicitly start duplicate work", its
"Open run — view stored results/history; does not start work", and its insistence that a
conflict be explained as "This campaign is already running elsewhere" are all statements about
*which commands are available given what the client can observe*. Remark 4.20 is the argument for
exactly that discipline, and the lens type `S y^S → p` is its signature: `p(1)` is the set of
observable campaign/run states, `p[i]` is the command set legal in state `i`, and `S` is the
private state the client never sees.

The concrete value, stated as mine: Ergodis currently expresses this as prose plus per-endpoint
validation. Writing the interface as a position-indexed command set makes illegal commands
*unrepresentable at the boundary* rather than rejected inside it, and makes the frontend's action
table a projection of one declaration instead of a parallel hand-maintained list. That is a
schema/IDL-shaped change, not a category-theory library, and it is the kind of change whose
payoff shows up as removed divergence between the native host, the WASM host and the browser UI —
which is exactly the fragmentation the architecture context names as the thing to resolve.

The caution: this is a **design vocabulary** win, and I have no evidence it reduces code. I would
not import a polynomial-functor library; I would write down `p` for the campaign interface once
and check that every existing command lands in some `p[i]`. Any command that does not is a bug or
a missing observable, and finding which is the experiment.

### 4.4 Experiments and gates

**Experiment H (declare the theory, validate the relations).** Write out the `FeatureDag`
signature and the simplifier's identity set as a term rewriting system `P`, then for each rule
`φ ⇒ ψ` check model-validity in the checked-integer model **including the error domain** — that
is, `⟦φ⟧` and `⟦ψ⟧` agree on value *and* on which inputs fault. *Gate:* every rule currently used
by the simplifier is either validated or moved to a declared-precondition list with its
precondition written down; the existing 1,984-row corpus must show no row where a validated rule
changes the fault set. Cross-check with the interval abstraction of Experiment A, which can
discharge many preconditions statically.

**Experiment I (critical branchings of the identity set).** Enumerate the critical branchings of
`P₂` by §4.3.14's algorithm and check each for confluence. *Gate:* a finite list of critical
branchings with a confluence verdict for each; any non-confluent one is either resolved by
Knuth–Bendix completion (adding the derived rule, which must itself pass Experiment H) or
recorded as a known incompleteness of the normal form. Pairs with the weak-term-acyclicity check
in §5.1: acyclicity bounds the search, confluence makes the answer unique.

**Experiment J (campaign interface as a polynomial).** Write `p` for the campaign/run control
interface: enumerate the observable states `p(1)` and, for each, the legal command set `p[i]`.
*Gate:* every command in the current control-plane surface appears in at least one `p[i]`, and
every `(state, command)` pair the current implementation rejects is absent from `p`. Discrepancies
in either direction are the finding.

*Needs: none of these require gradients, a neural network, or a GPU. Experiment I's critical-pair
enumeration is a quadratic pairwise scan over a small rule set — parallelisable but far too small
to be worth it.*

## 5. First-pass rows 1–5 at algorithm depth, with reference-implementation inspection

All source inspections below were fetched on 2026-09-12 from
`raw.githubusercontent.com` into this session's scratchpad and read there. Line counts are of the
files as fetched. These are code reads, and I record them as `full text` or `partial` of the
named file, not of any paper.

### 5.1 Row 1 — weak term acyclicity: the check, in pseudocode

Restating Suciu–Wang–Zhang's Definition 45 as something implementable. Nodes of the **weak term
dependency graph** are *positions* `(f, i)` — argument slot `i` of operation symbol `f`. For a
term `u` and a subterm `v`, `Pos_u(v)` is the set of positions `(f, i)` such that
`f(p₁,…,p_{i−1}, v, p_{i+1},…,pₙ)` occurs as a sub-pattern of `u`. A rule is *non-degenerate*
when its left side is not a bare variable; a degenerate rule `x → rhs` is first expanded into one
non-degenerate rule per operation symbol.

```
build_weak_term_dependency_graph(rules R over signature Σ):
    V := { (f, i) : f ∈ Σ, 1 ≤ i ≤ arity(f) }
    E := ∅                      # ordinary edges
    E* := ∅                     # special edges
    for each rule (lhs → rhs) in R:
        for each variable x occurring in rhs:
            for u in Pos_lhs(x), v in Pos_rhs(x):
                E := E ∪ {(u, v)}
        for each proper non-variable sub-pattern p of rhs
                 such that p does NOT occur in lhs:
            for each variable x in p:
                for u in Pos_rhs(x), v in Pos_rhs(p):
                    E* := E* ∪ {(u, v)}
    return (V, E, E*)

weakly_term_acyclic(R):
    (V, E, E*) := build_weak_term_dependency_graph(R)
    return no cycle of (V, E ∪ E*) contains an edge of E*
```

The cycle test is a strongly-connected-component decomposition (Tarjan, linear): the rule set is
weakly term acyclic iff no special edge has both endpoints in the same SCC. For Ergodis's nine
`FeatureDag` operations the vertex set is at most a couple of dozen positions, so this is a
minutes-of-work script, not a project.

**Theorem 46** is what the check buys: weakly term acyclic ⇒ equality saturation converges in
**polynomially many steps in the size of the input e-graph**. The proof ranks each position by
the maximum number of special edges on any incoming path (finite exactly because no cycle carries
a special edge), and bounds by induction on rank the number of distinct e-classes reachable at
positions of that rank.

**Reference implementation: `egg`** (`github.com/egraphs-good/egg`, Rust). *Read depth: full text
of `src/extract.rs` (333 lines) and `src/unionfind.rs` (93 lines); partial of `src/run.rs`
(the `StopReason` enum, the `Runner` limit setters, the `RewriteScheduler` trait and the
`SimpleScheduler`/`BackoffScheduler` documentation).* What it actually does about termination:
**nothing principled — it uses budgets.** `StopReason` is `Saturated | IterationLimit(usize) |
NodeLimit(usize) | TimeLimit(f64) | Other(String)`, with documented defaults of **30 iterations,
10,000 e-nodes and 5 seconds**. The default scheduler is `BackoffScheduler`, described in its own
doc comment as implementing "exponential rule backoff … If a rewrite search yields more than this
limit, then we ban this rule for a number of iterations, double its limit, and double the time it
will be banned next time. This seems effective at preventing explosive rules like associativity
from taking an unfair amount of resources." `SimpleScheduler` — no backoff — exists and is
explicitly *not* the default.

That is the capability gap stated precisely. `egg` in production reaches `Saturated` or it hits a
budget, and only the first of those licenses any claim about the result. The weak-term-acyclicity
check is a *static* certificate that `Saturated` will be reached, which no amount of budget
tuning can supply. Ergodis's `FeatureDag` node and degree bounds are budgets of the same kind.

*Also worth carrying from `egg`:* its extraction is **not optimal**. `Extractor::find_costs` is a
worklist fixpoint (`VecDeque` of e-class ids, re-enqueueing parents when a class's cost improves)
— a Bellman–Ford/Dijkstra-shaped relaxation — and the `CostFunction` trait documents the required
precondition: "your cost function should be _monotonic_, i.e. `cost` should return a `Cost`
greater than any of the child costs of the given e-node." This computes the optimal **tree** cost,
which does not credit sharing. `egg` ships a separate `src/lp_extract.rs` for integer-linear-program
extraction, which is the optimal DAG-cost route. This matches the NP-hardness noted in the first
pass and is the reason its row 7 stayed at medium confidence.

### 5.2 Row 2 — weight pushing: the construction, and why Ergodis's saturation blocks it

The construction (Mohri's Theorem 8, first pass §3.2):

```
minimize_weighted(A):                 # A deterministic, over semiring S
    d := shortest_distance(A)         # d[q] = ⊕ over paths q → final of ⊗ of arc weights
    push(A, d)                        # reweight every arc by d
    return unweighted_minimize(A)     # Hopcroft, treating (label, weight) as one label
```

**Reference implementation: OpenFst** (`src/include/fst/push.h`, 155 lines, and
`src/include/fst/reweight.h`, 127 lines; `src/include/fst/float-weight.h` consulted for the
tropical weight). *Read depth: full text of `push.h` and `reweight.h`; partial of
`float-weight.h` (the `TropicalWeightTpl` definition and the `Properties()` bitmasks).* Source
fetched from the `kkm000/openfst` mirror.

`Push` is three lines of composition:

```cpp
ShortestDistance(*fst, &distance, type == REWEIGHT_TO_INITIAL, delta);
if (remove_total_weight) total_weight = ComputeTotalWeight(...);
Reweight(fst, distance, type);
if (remove_total_weight) RemoveWeight(fst, total_weight, ...);
```

`Reweight` is where the algebra lives, and its own comment states the requirement exactly: "The
weight must be left distributive when reweighting towards the initial state and right distributive
when reweighting towards the final states. An arc of weight `w`, with an origin state of potential
`p` and destination state of potential `q`, is reweighted by `p⁻¹ ⊗ (w ⊗ q)` when reweighting
towards the initial state, and by `(p ⊗ w) ⊗ q⁻¹` when reweighting towards the final states."
In code:

```cpp
if (type == REWEIGHT_TO_INITIAL)
    arc.weight = Divide(Times(arc.weight, nextweight), weight, DIVIDE_LEFT);
if (type == REWEIGHT_TO_FINAL)
    arc.weight = Divide(Times(weight, arc.weight), nextweight, DIVIDE_RIGHT);
```

**Weight pushing requires `Divide`.** OpenFst checks the algebraic precondition at run time
against a properties bitmask on the weight type and fails loudly:

```cpp
if (type == REWEIGHT_TO_FINAL && !(Weight::Properties() & kRightSemiring)) {
    FSTERROR() << "Reweight: Reweighting to the final states requires "
               << "Weight to be right distributive: " << Weight::Type();
    fst->SetProperties(kError, kError); return;
}
```

and `TropicalWeightTpl::Properties()` returns
`kLeftSemiring | kRightSemiring | kCommutative | kPath | kIdempotent`, with
`Zero() = +∞` and `One() = 0`; tropical `Divide` is float subtraction. The code deliberately
**skips** every arc touching `Zero`: `if (weight != Weight::Zero())`, and
`if (nextweight == Weight::Zero()) continue;` — because `∞ − ∞` is meaningless.

**The Ergodis consequence, now verified at code level rather than suspected.**
`ergodis-verify::min_plus_transition` uses `u32::MAX` as the absent/`Zero` sentinel and
**saturates finite sums to it**. OpenFst's skip test distinguishes "this is `Zero`" from "this is
a large finite weight"; under saturation Ergodis cannot, because a genuinely finite cost that
saturated is now byte-identical to absence. So weight pushing is not blocked by the tropical
semiring — that semiring is fine, and OpenFst supports it — it is blocked by the **saturating
representation**. Two clean repairs exist and neither is exotic: widen the accumulator so no
reachable composition saturates (and prove the bound), or carry an explicit `Option`-style
absent flag distinct from the numeric maximum. This changes row 2's experiment from "try weight
pushing" to "first settle the sentinel, then weight pushing is off-the-shelf."

### 5.3 Row 3 — a semiring-polymorphic verifier: the interface to copy

The template is OpenFst's weight concept, and it is the part worth imitating rather than the
algorithms. A weight type supplies `Zero()`, `One()`, `Plus`, `Times`, `Divide`, `Member()`,
`Quantize()`, `Reverse()`, a `Type()` string, and — the piece Ergodis does not currently have —
a static **`Properties()` bitmask** drawn from `kLeftSemiring`, `kRightSemiring`, `kCommutative`,
`kIdempotent`, `kPath`. Every algorithm that needs an algebraic precondition tests that mask and
refuses with a named error identifying the weight type.

```
verify_min_plus_transition<W: Weight>(snapshot, deltas):
    require(W::properties() & (LEFT_SEMIRING | RIGHT_SEMIRING))
    state := decode_and_check(snapshot)          # semiring-agnostic
    for delta in deltas:
        check artifact / root / sequence / leaf identity      # semiring-agnostic
        check every sibling summary and digest against state  # semiring-agnostic
        new_root := fold_up_path(delta.leaf, W::plus, W::times)   # only here
        commit if new_root matches
```

Everything except `fold_up_path` — decoding, the Merkle sibling comparison, replay ordering,
the sequence-overflow checks — is independent of `W`. The first pass argued this from the
literature (Green–Karvounarakis–Tannen Proposition 3.5: a tagwise map commutes with every query
iff it is a semiring homomorphism); OpenFst is the existence proof that a production library is
built exactly this way, and its `Properties()` mask is the mechanism that keeps the genericity
sound rather than merely convenient.

The three instantiations the first pass wanted, concretely: `W = Tropical` gives the optimum;
`W = Tropical × Generator` with union-on-ties gives optimum **plus** the witness set in one pass
(Little–He–Kayas equation 35); `W = Tropical × Generator` with a tie-break gives one canonical
witness (their equation 37); and the top-`k` variant gives the Pareto/envelope contract. The
properties mask is where the saturation problem from §5.2 gets declared instead of discovered:
a saturating `u32` min-plus weight would advertise neither `kLeftSemiring` nor `kRightSemiring`
in a `Divide`-using algorithm, and the refusal would be automatic.

### 5.4 Row 4 — VeriPB's redundance rule: exact syntax and what the checker verifies

**Reference implementation: VeriPB** (`github.com/StephanGocht/VeriPB`). *Read depth: full text of
the proof-format sections of `README.rst` (the rule summary, the "Redundancy Based Strengthening"
section, and the "Subproofs" section); full text of the `AddRedundant` class in
`veripb/rules_dominance.py` together with `objectiveCondition`; partial of `veripb/rules.py` (the
rule-identifier table only). One integration-test proof file,
`tests/integration_tests/correct/dominance/optimization.pbp`, was read in full.*

**Exact syntax.** One rule per line:

```
red [OPB style constraint] ; [substitution]
```

Real lines from the checker's own test suite (`optimization.pbp`, quoted verbatim):

```
pseudo-Boolean proof version 1.2

f

red 1 ~x2 1 ~x3 1 x1 >= 1 ; x1 → x2 , x2 → x3 , x3 → x1
red 1 x1 1 x2 >= 1 ; x1 → 1 , x2 → 0 , x3 → 0
red 1 ~y1 1 ~y2 1 y3 >= 3 ; y1 → 0 , y2 → 0 , y3 → 1
```

So the witness `ω` is a comma-separated list of `literal → literal-or-constant` mappings, written
after a semicolon; a witness may permute variables (first line) or fix them to `0`/`1` (second
and third).

**What is checked.** The README states the condition directly:

> `F ∧ ¬C ⊨ (F ∧ C)↾ω`

"every assignment satisfying the constraints in the database `F` but falsifying the to-be-added
constraint `C` can be transformed into an assignment satisfying both by using the assignment (or
witness) `ω`". "If the redundancy rule is used in the context of optimization and/or dominance
breaking, additional conditions are checked."

**How the checker discharges it** (`AddRedundant.compute`, read in full). It negates `C` and
makes `¬C` available; then it generates proof goals:

1. `computeEffected(context, witness)` — the constraints in the database that the substitution
   actually touches. Each becomes a subgoal, **auto-discharged when `negated.implies(ineq)`**
   (a cheap syntactic implication check), otherwise left for RUP or an explicit subproof. The
   counter `stats.numGoalCandidates` versus `stats.numSubgoals` is precisely the count of goals
   considered versus goals that actually needed work — the checker instruments its own cheap path.
2. One subgoal for the added constraint itself under the witness: `ineq.substitute(witness)`.
3. Subgoals from the active **order**, but only `if not order.varsSet.isdisjoint(witnessDict)` —
   the order conditions are skipped entirely when the witness does not touch order variables.
4. One subgoal from the **objective**: `objectiveCondition(context, witness)` walks the objective's
   `(literal, coefficient)` terms and builds the pseudo-Boolean constraint expressing
   `f ≥ f↾ω`. Literals the witness does not remap "will disappear anyway, so no reason to add
   them" (the source's own comment).

There is also a fast path: when the proof provides no explicit subproof, and the running
`autoRUPstreak` exceeds 5, the checker first tries a plain reverse-unit-propagation check
(`ineq.rupCheck`) or a direct lookup (`context.propEngine.find(ineq)`), and only falls back to
generating goals if that fails.

**Explicit subproof syntax**, from the README:

```
red 1 x1 >= 1 ; x1 -> 1 ; begin
    proofgoal #1
        pol -1 -2 +
        c -1
    end

    proofgoal 1
        rup >= 1 ;
        c -1
    end
end
```

Goal identifiers: a goal originating from a database constraint carries that constraint's id; all
other goals are `#`-numbered "in the following order (if applicable): the constraint to be
derived (only redundancy), one goal per constraint in the order, one goal for the negated order
(only dominance), objective condition (only for optimization problems)". Each proof goal must
derive contradiction. The README's own tip is to run with `--trace` to see the required goals.

**What Ergodis gains, restated as capability.** Ergodis's representative-catalog contract is
"same optimum over retained family for admitted queries … and actual witness lifts". The `red`
rule is that contract as a one-line checkable certificate: the omitted candidate is the
constraint, the lift is `ω`, and the objective subgoal is exactly the obligation that the lift
does not worsen the answer. The implementation detail worth copying is the *structure* of the
discharge — a cheap syntactic implication test first, an explicit subproof only for the goals
that survive it — because that is what makes the certificate small in the common case. The
detail worth copying second is `--trace`: the checker can enumerate the goals it needs before the
prover writes anything.

### 5.5 Row 5 — product of categories, and what "compute a colimit" costs

There is no pseudocode worth writing for the product construction itself: `(p ⊗ q) a b = p a b ⊗
q a b`, every operation acts componentwise, and in Rust it is a pair of associated types with a
paired impl. What was worth checking is the *adjacent* claim from the first pass — that a
categorical data layer gives limits and colimits "for free" — because the question is what that
actually costs at run time.

**Reference implementation: Catlab.jl** (`AlgebraicJulia/Catlab.jl`, Julia). *Read depth: full
text of `src/categorical_algebra/cats/limits_colimits/Coequalizers.jl` (55 lines) and the
coequalizer and quotient-projection portions of
`src/categorical_algebra/setcats/skelfinsetcat/Colimits.jl`; the file listing of the
`limits_colimits` directory was enumerated via the GitHub trees API.*

The `Coequalizers.jl` module is entirely interface: a GATlab theory
`ThCategoryWithCoequalizers` declaring `colimit(p::ParallelDiagram)::Colimit` and a `universal`
property, plus dispatch helpers. The computation lives in the skeletal-finite-set model, and it
is **union-find**:

```julia
function colimit(para::ParallelMorphisms)
    f1, frest = para[1], para[2:end]
    m, n = length(dom(para)), length(codom(para))
    sets = IntDisjointSets(n)
    for i in 1:m, f in frest
        union!(sets, f1(i), f(i))
    end
    q = quotient_projection(sets)
    ColimitCocone(Multicospan(codom[model](q), [q]; cat=model), FreeDiagram(para))
end

function quotient_projection(sets::IntDisjointSets)
    h = [ find_root!(sets, i) for i in 1:length(sets) ]
    roots = unique!(sort(h))
    FinFunction([ searchsortedfirst(roots, r) for r in h ], length(roots))
end
```

So: merge the pairs identified by the parallel maps, take roots, sort the roots to get a
deterministic dense renumbering, and return the projection. That is the same union-find that
`egg`'s `src/unionfind.rs` implements for e-classes and the same canonical renumbering that
Boa's `renumber` performs on signatures.

**The plain reading, and it is a useful one.** The categorical vocabulary buys *uniformity* —
one `coequalizer` that works for every model of the theory, and a `universal` property that makes
the factorisation available rather than hand-written — not a new algorithm. For Ergodis this is a
positive finding rather than a deflation: it means adopting "quotient = coequalizer" costs a
union-find and a sort, which Ergodis can afford anywhere, and the decision is about API shape
rather than about performance. It also means the three quotient computations in this study —
e-class merging, behavioural partition refinement, and coequalizers in finite sets — share one
data structure, so an Ergodis implementation of any of them is most of an implementation of the
others.

## 6. Set aside on the first pass, reassessed on capability alone

Each item below was named in the first pass and either deferred, marked low-confidence, or filed
as an incidental lead. Reassessed here on the single question of what Ergodis could do with it,
with the scope now including gradient-based search, small neural networks, and GPU compute.

### 6.1 Promoted

**Interval analysis.** Was incidental lead 4. Now §1.2(a): a single topological pass over a
`FeatureDag` decides statically whether a subterm can overflow, which is the question the
selected-root lowering already has to answer and currently answers only by test corpus. Cheapest
item in either pass.

**E-graph extraction cost.** Was the reason first-pass row 7 stayed medium. It is now a solved
engineering problem rather than an open one.

> **Jiaqi Yin, Zhan Song, Chen Chen, Yaohui Cai, Zhiru Zhang, Cunxi Yu, "e-boost: Boosted E-Graph
> Extraction with Adaptive Heuristics and Exact Solving", arXiv:2508.13020v2 [cs.AI], 23 August
> 2025.** *Read depth: abstract/metadata only* — arXiv PDF already in the cache, SHA-256 recorded
> in the manifest under `arXiv:2508.13020`, 16 pages; abstract read. Three components, all in
> scope and none needing a neural network: **parallelised heuristic extraction** exploiting "weak
> data dependence to compute DAG costs concurrently"; **adaptive search-space pruning** with a
> parameterised threshold retaining only promising candidates; and **initialised exact solving**
> that formulates the reduced problem as an integer linear program with warm start. Reported:
> "558× runtime speedup over traditional exact approaches (ILP)" and "19.04% performance
> improvement over" the heuristic baseline. I have not verified those figures.

The pattern — cheap parallel heuristic, threshold prune, warm-started exact solve on the residue
— is directly reusable for any Ergodis step where an exact answer is wanted and a heuristic is
affordable, which is most of the Evolve proposal path. It also happens to be the same shape as
C1091's "bounded probes and exact fallback".

**Reverse-mode automatic differentiation over a term graph.** Was out of scope in the first pass
(optics were part A's territory, and gradients were not in scope). With gradient-based search
admitted, one specific result becomes relevant.

> **Mario Alvarez-Picallo, Dan R. Ghica, David Sprunger, Fabio Zanasi, "Functorial String Diagrams
> for Reverse-Mode Automatic Differentiation", arXiv:2107.13433v1 [cs.PL], 28 July 2021 (CSL 2023
> version cited elsewhere as LIPIcs 252, 6:1–6:20).** *Read depth: partial* — arXiv PDF, cached as
> `arXiv:2107.13433`, SHA-256
> `a08ba2a6b89db8d6048fef58dec51d076bda67dbb5337b5eb591645ab09d4a1d`, 28 pages; abstract and §1
> Introduction read. They give a hierarchical string-diagram calculus capturing closed monoidal and
> cartesian closed structure, formulate the Pearlmutter–Siskind reverse-AD algorithm in it, and
> "prove for the first time its soundness"; the implementation vehicle is a class of hierarchical
> hypergraphs they call **hypernets**, given as a sound and complete representation.

Why this matters to Ergodis rather than to machine learning: hypernets are the same hierarchical
hypergraph structure Tiurin et al. use for monoidal e-graphs (§1.2 of the first pass), so the
rewriting substrate for AD and for equality saturation is one substrate. If Ergodis ever wants a
gradient of a continuous relaxation of a `FeatureDag`-shaped objective — for Evolve parameter
tuning, or for a continuous surrogate of a discrete search — this is the sound construction, and
it reuses machinery already argued for. The obvious caveat is that `FeatureDag` is
integer-valued with checked arithmetic, so differentiating it requires first choosing a
continuous relaxation, and that choice is the real work; the AD machinery is not the hard part.

**Bandit-based adaptive operator selection for Evolve.** Not in the first pass at all; surfaced
here because "small simple models" are now in scope and because it needs no network whatsoever.

> **Álvaro Fialho, Luis Da Costa, Marc Schoenauer, Michèle Sebag, "Analyzing bandit-based adaptive
> operator selection mechanisms", Annals of Mathematics and Artificial Intelligence 60(1):25–64
> (2010), DOI 10.1007/s10472-010-9213-y.** *Read depth: partial* — author's draft via HAL
> (`inria-00519579`), already in the cache under the DOI key; abstract and author/venue front
> matter read. Each genetic operator is an arm of a multi-armed bandit and the reward is the
> fitness improvement it produced. Their point is that the standard Upper Confidence Bound
> algorithm solves exploration-versus-exploitation optimally only in **static** settings while
> operator selection is dynamic, so they propose a UCB variant using a **sliding time window** for
> both the exploitation and the exploration terms, and build a testbed with smooth transitions
> between reward regimes plus a real evolutionary algorithm on the Royal Road problem.

The Ergodis object is O8, Evolve's **proposal ordering**, which the architecture context describes
as "shared ranked Rust/WASM proposals". A sliding-window UCB is a few dozen lines, has no training
phase, no model to ship, and no inference cost, and it directly attacks the thing `egg`'s
`BackoffScheduler` attacks with a fixed heuristic (ban a rule, double its limit, double its ban
time). It is also a strictly better fit than `BackoffScheduler` for Ergodis's case, because
Ergodis's reward — did this proposal survive admission and improve the measured objective — is
already computed and recorded.

**GPU formulations of the quotient computations.** Newly in scope. Two concrete results.

> **Jan Martens, Jan Friso Groote, Lars van den Haak, Pieter Hijma, Anton Wijs, "A linear parallel
> algorithm to compute bisimulation and relational coarsest partitions", arXiv:2105.11788v1
> [cs.DC], 25 May 2021.** *Read depth: partial* — arXiv PDF, cached as `arXiv:2105.11788`,
> SHA-256 `0da1ef80db64cb03dd250d094322b3e43a6bd39e0ca24109cc0577066dddffeb`, 22 pages; abstract
> and §1 opening read. "The first linear time algorithm to calculate strong bisimulation using
> parallel random access machines": with `n` states, `m` transitions and `|Act| ≤ m` labels, on
> `max(n, m)` processors, time `O(n + |Act|)` and space `O(n + m)`. Their motivation is precisely
> the GPU question — "the best-known PRAM algorithm has time complexity `O(n log n)` on a smaller
> number of processors making it less suitable for massive parallel devices such as GPUs" — and
> they report a GPU implementation showing "the linear time-bound is achievable on contemporary
> hardware."

> **Filippo Biondi, Mirco Tribastone, Max Tschaikowski, "Scaling Weisfeiler–Leman Expressiveness
> Analysis to Massive Graphs with GPUs", arXiv:2607.02603v1 [cs.DC], 1 July 2026.** *Read depth:
> partial* — arXiv PDF, cached as `arXiv:2607.02603`, SHA-256
> `8434f52b47ffde1b8cc84fecbe15d53e9ca3caa29745cdb1ae2ff8e54da625d1`, 22 pages; abstract and §1
> opening read. They identify two bottlenecks in classical stable-colouring computation — it is
> "inherently sequential" and "global", requiring the whole graph in memory — and answer both with
> a **linear-algebraic interpretation of 1-WL stable colouring**: a randomized refinement
> algorithm with tight probabilistic guarantees, plus a correctness-preserving batching scheme
> that "decomposes the graph into independently processable subgraphs while provably returning a
> stable coloring of the original graph". Their CUDA implementation reports "speedups up to two
> orders of magnitude over classical CPU-based partition refinement" and stable colourings on
> graphs with over 30 billion edges.

The capability statement for Ergodis: the refinement step of §2 and the canonical-labelling inner
loop of §3 have the same linear-algebraic reformulation, that reformulation is matrix–vector
multiplication, and matrix–vector multiplication is what a `wgpu` compute kernel does well. The
batching result matters more than the speedup for Ergodis, because it is what makes the
computation work without holding the whole structure in device memory — the same constraint the
browser target imposes.

**The trust caveat that comes with both, and with Boa.** Biondi et al.'s refinement is
*randomized* with probabilistic guarantees; Boa's signatures are 64-bit FxHash digests (§2.3).
Every fast route to a quotient in this study trades exactness for speed somewhere. Ergodis's
verification context forbids an unqualified "verified", so any adoption must state which: an
exact CPU path as the authority and a fast randomized path as an accelerator whose output is
re-checked, or a declared probabilistic bound recorded on the claim.

### 6.2 Reassessed and still deferred, with the reason sharpened

**String diagrams as an IR.** The first pass said do not adopt, because `FeatureDag` is Cartesian
and pays none of the cost the machinery removes. That still holds for the plan language. What
changed is that two *other* things Ergodis might want — reverse-mode AD (§6.1) and monoidal
e-graphs — are built on the same hierarchical-hypergraph substrate, so if either is ever adopted
the substrate arrives with it. The recommendation is therefore sharper than before: do not adopt
string diagrams *for the plan IR*, and if AD or saturation is adopted, take the hypergraph
representation from that work rather than inventing one.

**Decorated cospans (first-pass row 11).** Still low confidence and still design-level. The
capability reassessment does not move it: it gives the preservation contracts a composition law,
which is valuable when writing the contracts down and worth nothing at run time. Keep as
vocabulary.

**Open games (first-pass row 12).** Unchanged: single-agent optimisation under information
constraints is not a strategic game, and the transferable content remains the one interface
decision (decision covers need bidirectional morphisms). The optics underneath are part A's.

**Datalog and the chase (first-pass incidental lead 2).** Suciu–Wang–Zhang's two-way reduction
between equality saturation and the chase means `egglog`-style unification of Datalog and
equality saturation is available. The capability that would buy — incremental recomputation of
derived facts when a source changes — maps onto Ergodis's update contracts and cache-validity
question. I still set it aside, for a reason rather than by omission: Ergodis's update problem is
about *authority* (which admissions survive an edit) more than about *recomputation*, and the
chase gives the second without the first.

**Provenance polynomials for dependency tracking (first-pass §2.5).** Reassessed and worth one
sentence more than it got: Green–Karvounarakis–Tannen's `N[X]` semiring answers "which leaves
does this root cost depend on, and with what multiplicity" without re-running anything, which is
exactly the dependency-set half of Ergodis's cache-validity contract. It is a *different* weight
type in the semiring-polymorphic verifier of §5.3, not a separate mechanism — so it costs nothing
extra once row 3 lands. Promoted from "worth noting" to "free rider on row 3".

**Squier's theorem as a stopping rule (first-pass §3.3).** Unchanged in substance but worth
restating as capability: it is the result that tells Ergodis when to *stop* looking for a finite
convergent presentation, via a computable homological obstruction. Negative results that bound
effort are capability, not trivia.

**The polynomial fragment of `FeatureDag` (first-pass incidental lead 5).** Elliott §7.8 notes
that programs using only addition and multiplication compile to polynomials, which admit exact
root, extremum, derivative and integral analysis and parallel-prefix evaluation. `FeatureDag`'s
`Add`/`Sub`/`Mul`/`Constant`/`Input` nodes are exactly that fragment; `Mod`, `Abs`,
`GaussianNorm` and `EisensteinNorm` leave it. With gradients in scope the derivative half is now
interesting, but the realistic assessment is that the fragment is probably too small in practice —
the norms are the point of the feature language. Worth a measurement (what fraction of live
`FeatureDag`s are polynomial?) before anything else.

### 6.3 Still out, and why

The only hard exclusion is dependence on deep or large neural networks. Three lines of work fall
there and are named so they are not rediscovered: neural-guided e-graph extraction and learned
rewrite schedulers that require a trained network in the loop (e-boost's threshold heuristic is
the in-scope alternative and reportedly beats the ILP baseline by 558× without one); graph neural
network approaches to symmetry and isomorphism, which are additionally *bounded above* by 1-WL —
which §6.1's GPU result computes exactly and far more cheaply; and learned surrogate objectives
for combinatorial search, where C1016's own measurements already show the difficulty is the move
set rather than the scoring.

Two of those three are worth noting for a second reason: in both cases the classical algorithm is
not merely adequate but strictly stronger. A GNN cannot distinguish what 1-WL cannot, so
computing 1-WL directly is both exact and cheaper. That is an argument from capability, not from
taste.

## 7. Absorption table

Ordered by my estimate of value per unit of effort, best first. The **Requirement** column answers
the scope question directly: `neither` means no gradient, no neural network and no GPU;
`GPU optional` means a known data-parallel formulation exists but the CPU version should be built
first; `GPU` means the parallel formulation is the point; `small model` means a small simple
learner with no network; `gradient` means gradient-based search. Nothing here needs a deep or
large neural network.

The six required fields per row are written out under the index, because several do not compress
to a table cell without losing the part that makes them actionable.

| #  | Candidate                               | Ergodis object       | Requirement  | Confidence |
|----|-----------------------------------------|----------------------|--------------|------------|
| 1  | Interval abstraction over FeatureDag    | O2 FeatureDag        | neither      | high       |
| 2  | Weak term acyclicity check              | O2 identities        | neither      | high       |
| 3  | Sentinel fix, then weight pushing       | O5 summaries         | neither      | high       |
| 4  | Semiring-polymorphic verifier           | O5 verifier, O4      | neither      | high       |
| 5  | Coalgebraic partition refinement        | O3 quotients         | GPU optional | high       |
| 6  | VeriPB-style omission certificate       | O3 catalogs, O4      | neither      | high       |
| 7  | Widening-shaped bounded probe           | O4 probes            | neither      | medium     |
| 8  | Canonical form + isomorph rejection     | C1016 search         | GPU optional | medium     |
| 9  | Theory relations + critical branchings  | O2 simplifier        | neither      | medium     |
| 10 | Sliding-window UCB proposal ordering    | O8 Evolve            | small model  | medium     |
| 11 | Parallel heuristic + warm-started exact | O8 Evolve, O2        | neither      | medium     |
| 12 | Campaign interface as a polynomial      | O6 campaigns         | neither      | medium     |
| 13 | GPU linear-algebraic refinement         | O3 quotients, C1016  | GPU          | low        |
| 14 | Reverse-mode AD on a relaxation         | O8 Evolve            | gradient     | low        |

### Row detail

**Row 1 — interval abstraction over `FeatureDag`** (Cousot–Cousot PLILP'92 Example 11's interval
domain; Elliott §7.7's `IFun` instance for the transfer functions). *Expected benefit:* a static,
per-term answer to "can this subterm overflow given declared input ranges", which is the question
selected-root lowering must answer and currently answers only by test corpus. *Cheapest
experiment:* one topological pass over the DAG carrying `[lo, hi]` per node — `Add` adds
endpoints, `Mul` takes min and max of the four corner products, `Abs` and the norms take the
monotone image, `Mod m` gives `[0, m−1]`. No fixpoint, no widening, because the DAG is acyclic.
*Measured gate:* on the 1,984-row lowering corpus, every row the concrete evaluator faults must
be flagged possible (zero false negatives, non-negotiable), and the count flagged-possible but
not-actually-faulting is reported as the precision number; separately, for every discarded
subterm in a selected-root lowering the abstraction must state whether it could have faulted, with
the existing corpus as oracle. *Requirement: neither* — though propagating `k` independent input
boxes through one fixed topological schedule is a width-`k` map and a plausible `wgpu` kernel if
Evolve ever screens a large population. *Confidence: high* — smallest construction in either pass,
exact soundness statement, and it discharges an obligation Ergodis has already written down.

**Row 2 — weak term acyclicity of the identity set** (Suciu–Wang–Zhang, Definition 45 and
Theorem 46; pseudocode in §5.1). *Expected benefit:* a static certificate that the simplifier's
rule set saturates in polynomially many steps, or a named identity that forbids the claim.
*Cheapest experiment:* build the position graph (at most a couple of dozen vertices for nine
operations), run Tarjan, check no special edge lies inside an SCC. *Measured gate:* binary; if
acyclic, additionally confirm the fixpoint is reached within the polynomial bound on the existing
corpus, and if not, report the offending cycle and the identity that creates it. *Requirement:
neither.* *Confidence: high* — minutes of work, returns a usable answer either way, and it is the
one thing `egg`'s budget-based `StopReason` cannot give.

**Row 3 — settle the min-plus sentinel, then weight pushing** (Mohri Theorem 8; OpenFst
`reweight.h` inspection in §5.2). *Expected benefit:* a linear-time canonical form for
cost-carrying representations, usable for cache keys and catalog deduplication — but only after
the blocker is removed. *Cheapest experiment:* **not** weight pushing. First decide whether any
reachable composition in the retained corpus saturates to `u32::MAX`, by instrumenting the
existing verifier to count saturations; then either widen the accumulator with a proved bound or
add an explicit absent flag distinct from the numeric maximum. Weight pushing is the second
experiment, not the first. *Measured gate:* zero saturating compositions over the whole fixture
set under the chosen representation, demonstrated rather than argued; then cost-equivalence of
the pushed tree on every leaf assignment. *Requirement: neither.* *Confidence: high* that the
blocker is real — OpenFst's code explicitly skips arcs at `Zero` because `∞ − ∞` is meaningless,
and saturation makes that skip undecidable — and high that the repair is routine.

**Row 4 — semiring-polymorphic verifier with a properties mask** (OpenFst's weight concept as the
template; Green–Karvounarakis–Tannen Prop. 3.5 and Thm 4.3 for why it is sound;
Little–He–Kayas §2.5 for the tupled instantiations). *Expected benefit:* one checker instead of
one per algebra, with optimum, canonical witness, full witness set, top-`k` and provenance
polynomials as instantiations; and algebraic preconditions declared rather than discovered.
*Cheapest experiment:* parameterise the existing checker over `(carrier, ⊕, ⊗, 0, 1)` plus a
`properties()` bitmask, re-run current min-plus fixtures through the generic path, then add the
Viterbi tupled weight as a second instantiation. *Measured gate:* byte-identical results on every
current fixture; the tupled instantiation's witness matches the existing witness readout; and no
regression on the retained native A/B counter gates — no allocation, no dynamic dispatch in the
hot loop. *Requirement: neither.* *Confidence: high* — OpenFst is the existence proof that a
production library is built this way, and row 3's blocker becomes a declared property instead of
a surprise.

**Row 5 — compute the quotient rather than check it** (Wißmann–Dorsch–Milius–Schröder's
refinement interface; Jacobs–Wißmann's Algorithm 2 and the Boa source read in §2.3). *Expected
benefit:* Ergodis moves from verifying a supplied quotient to **producing the coarsest** one, in
`O(m log n)`, from one implementation covering deterministic, weighted and polynomial
presentations. This is the largest single capability gain in the study. *Cheapest experiment:*
implement Algorithm 2 directly against Ergodis structures — the `RefinablePartition` design is
four flat vectors plus a worklist and `refine` is a counting sort, so this is on the order of
sixty lines — and run it on one existing `FinitePresentation`. *Measured gate:* the computed
partition refines every quotient `ValidatedQuotient` currently accepts for that presentation and
is no coarser than any of them; the number of extra classes the existing quotients retain is
reported; and **exactness is established against a naive reference on the whole corpus rather
than assumed** — Boa's signatures are 64-bit FxHash digests, so either use exact keys or record
the collision bound as a declared precondition. *Requirement: GPU optional* — signature
computation is a pure per-state map and Martens et al. give a PRAM-linear GPU algorithm, but
Jacobs–Wißmann beat a 265 GB cluster with 1.7 GB single-machine Rust, so start on the CPU.
*Confidence: high* — the algorithm is published, implemented, benchmarked, and in Rust.

**Row 6 — a VeriPB-style omission certificate for representative catalogs** (VeriPB `red` rule;
exact syntax and checker behaviour in §5.4). *Expected benefit:* a checkable certificate for
"this reduction preserves the optimum but not the feasible set" — the catalog contract Ergodis
states and cannot currently check, and the one VIPR-style feasibility proofs cannot express.
*Cheapest experiment:* encode one bounded recovery-family catalog omission as a constraint plus a
witness substitution `ω` in `red`-style syntax, and discharge the four goal families the checker
generates: effected database constraints, the added constraint under `ω`, order conditions (skip
when the witness misses the order variables), and the objective condition `f ≥ f↾ω`. *Measured
gate:* an independent checker accepts the certificate and rejects a deliberately broken omission
(C1091 fixture 4 — the single-failure-complete catalog that drops the only action safe under
unresolved alternatives). Report the ratio of goal candidates to goals actually needing a
subproof, which is what determines whether certificates stay small. *Requirement: neither.*
*Confidence: high* — the format is implemented, in use for 0–1 integer linear programs, and
Ergodis's GF(2)/binary families sit in exactly that setting.

**Row 7 — a widening-shaped bounded probe** (Cousot–Cousot PLILP'92 axioms (6)–(8), (10)–(11),
iterations (9) and (12)). *Expected benefit:* C1091's bounded-probe step gains a soundness
statement at the cut-off, which a budget counter cannot give; and the narrowing pass makes
**every intermediate answer** sound, so the probe can be truncated anywhere. *Cheapest
experiment:* restructure one existing Evolve probe as `if F(X) ⊑ X then stop else X ∇ F(X)`, plus
a truncatable downward `X Δ F(X)` pass. *Measured gate:* terminates in no more steps than the
current budget cut-off on the retained fixtures, and — the new part — the answer at every
truncation point of the narrowing pass is accepted as a sound bound by the existing independent
checker. *Requirement: neither.* *Confidence: medium* — the mathematics is settled and small, but
whether Ergodis's probes have a lattice structure to widen over is an implementation question
this study could not settle from documentation.

**Row 8 — canonical form and isomorph-free enumeration for C1016** (McKay's `scan` with
conditions M1–M3 and Theorem 1; Devriendt et al.'s Theorems 1 and 2 for the lex-leader
alternative). *Expected benefit:* the exact enumeration arms shrink by the orbit factor of a
group of order at least `522⁴·3!`, **with a provable coverage statement** — which matters because
C1016's own provenance rule says only exact enumerations grant negative coverage; and the
inequivalent-shell corpus gets an exact incremental key instead of a pairwise test. *Cheapest
experiment:* write down the group as implemented (including whatever the Goethals–Seidel array
and border impose — my derivation in §3.5 is from the card's equation and must be checked against
the private code), implement the canonical form (Booth's linear-time canonical rotation for
translations, sort the three equal blocks, minimise over the surviving unit orbit), and
recompute the 39-shell corpus's class count. *Measured gate:* the canonical key is a pure
function of the shell, verified by canonicalising several random group translates of each shell
and checking the key is identical; then the class count, where a change in either direction is
the finding. A second gate for enumeration: re-running the two-transfer census as a canonical
augmentation must reproduce the original result up to the equivalence, not merely approximate it.
*Requirement: GPU optional* — canonical rotation of `k` fixed-length sign vectors is a uniform
width-`k` map and a plausible `wgpu` kernel; the `scan` traversal itself is irregular and belongs
on CPU threads, where McKay's Theorem 3 licenses independent parallel runs. *Confidence: medium*
— the machinery is certain, but the size of the win depends on the real group, which I derived
rather than verified, and the inner tabu loop is explicitly **not** a target (§3.5(c)).

**Row 9 — validate the theory's relations, then its critical branchings** (Polygraphs §13.1.13 for
model-validity, §4.3.7 for the critical branching lemma, §4.3.14 for the enumeration algorithm).
*Expected benefit:* "which identities may the simplifier use" becomes a definition (the relation
must hold in the checked-integer model, error domain included) discharged once per identity
instead of argued per rewrite; and confluence of the destructive simplifier becomes a finite
check. *Cheapest experiment:* write the signature and identity set as a term rewriting system;
validate each rule in the checked-integer model; enumerate critical branchings and test each for
confluence. *Measured gate:* every rule is either validated or moved to a declared-precondition
list with its precondition written down, and no validated rule changes the fault set on the
existing corpus; the critical-branching list is finite and each entry carries a confluence
verdict, with non-confluent ones either completed (the added rule itself passing validation) or
recorded as a known incompleteness. *Requirement: neither.* *Confidence: medium* — certain to
produce a correct answer, uncertain whether the answer changes anything, since the identity set
may already be sound and confluent. The value is that the claim becomes checkable.

**Row 10 — sliding-window UCB for Evolve proposal ordering** (Fialho–Da Costa–Schoenauer–Sebag).
*Expected benefit:* proposal ordering adapts to which operators are currently paying, rather than
to a fixed heuristic; and unlike `egg`'s `BackoffScheduler` it uses the reward signal Ergodis
already computes (did the proposal survive admission and improve the measured objective).
*Cheapest experiment:* replace the current ranking with a UCB whose exploitation and exploration
terms are both computed over a sliding window, on one delivered Evolve family. *Measured gate:*
time-to-first-admitted-proposal and total admitted proposals per unit wall clock, against the
current ranking, on the retained overnight fixtures — with the run-to-run spread reported, since
C1016's card shows that spread can be the size of the effect. *Requirement: small model* — a few
dozen lines, no training phase, no shipped artifact, no inference cost. *Confidence: medium* —
the mechanism is simple and well-studied, but the paper's own point is that these algorithms are
sensitive to their hyper-parameters, so a null result is a plausible outcome.

**Row 11 — parallel heuristic, threshold prune, warm-started exact** (e-boost's three-part
pattern). *Expected benefit:* a general shape for any Ergodis step that wants an exact answer and
can afford a heuristic first, which is most of the Evolve proposal path and all of extraction if
row 7 of the first pass is ever pursued. *Cheapest experiment:* apply it to one existing exact
arm — compute the heuristic answer in parallel, prune to a parameterised threshold band, and
warm-start the exact solver from the heuristic solution. *Measured gate:* the exact answer is
unchanged (this is the whole point — pruning must be shown not to remove the optimum on the
fixture set, or the threshold must be declared as an approximation), and wall clock against the
unpruned exact run. *Requirement: neither* — CPU-parallel; e-boost's parallelism comes from "weak
data dependence", not from a GPU. *Confidence: medium* — the pattern is reported to work well
elsewhere and matches C1091's own "bounded probes and exact fallback" language, but the
threshold's safety is problem-specific and is exactly what the gate has to establish.

**Row 12 — campaign interface as a polynomial** (Niu–Spivak Definition 4.18 and Remark 4.20).
*Expected benefit:* illegal commands become unrepresentable at the boundary instead of rejected
inside it, and the frontend action table becomes a projection of one declaration rather than a
hand-maintained parallel list — which is where native/WASM/browser divergence currently comes
from. *Cheapest experiment:* write `p` for the campaign/run control interface: enumerate the
observable states `p(1)` and, for each, the legal command set `p[i]`. Do not import a library.
*Measured gate:* every command in the current control-plane surface appears in at least one
`p[i]`, and every `(state, command)` pair the implementation currently rejects is absent from `p`.
Discrepancies in either direction are the finding. *Requirement: neither.* *Confidence: medium*
— the diagnosis is solid and the exercise is cheap, but the payoff is removed divergence, which
is real and hard to measure in advance.

**Row 13 — GPU linear-algebraic refinement** (Biondi–Tribastone–Tschaikowski; Martens et al.).
*Expected benefit:* refinement and canonical labelling on structures too large for the sequential
path, and — more important for Ergodis than the speedup — a **correctness-preserving batching
scheme** that avoids holding the whole structure in device memory, which is the same constraint
the browser target imposes. *Cheapest experiment:* none yet. This row is gated on row 5: build the
CPU refinement first, measure where the time actually goes, and only then consider a `wgpu`
kernel for the signature/matvec step. *Measured gate:* when attempted — identical partition to the
exact CPU path on the whole corpus, since the published algorithm is randomized with probabilistic
guarantees and Ergodis's verification context forbids an unqualified "verified". *Requirement:
GPU.* *Confidence: low* — not because the work is doubtful but because Ergodis has no measured
instance large enough to need it, and Jacobs–Wißmann's single-machine result argues the threshold
is far away.

**Row 14 — reverse-mode AD over a continuous relaxation** (Alvarez-Picallo–Ghica–Sprunger–Zanasi).
*Expected benefit:* gradients of a continuous surrogate of a `FeatureDag`-shaped objective, for
Evolve parameter tuning or a continuous relaxation of a discrete search, with a soundness proof
for the algorithm and a hypergraph representation shared with the e-graph work. *Cheapest
experiment:* before any AD, choose and justify a continuous relaxation of one integer-valued
objective and check it correlates with the exact objective on banked states. The relaxation is
the work; the differentiation is not. *Measured gate:* rank correlation between the relaxed and
exact objectives on the banked C1016 plateau corpus, and whether gradient descent on the
relaxation reaches states the discrete search does not. C1016's own evidence is a caution here:
the card reports that the difficulty is the move set rather than the scoring, and that a
descent operator can look better and still fail in a controlled fibre. *Requirement: gradient.*
*Confidence: low* — the categorical machinery is sound and beside the point; the risk is entirely
in the relaxation, and Ergodis's measured history says scoring changes have not been the lever.

### Sequencing

Rows 1, 2, 3 and 9 are all small, local to `FeatureDag` or the verifier, and independent of each
other. Row 4 depends on row 3's sentinel decision. Row 5 is the largest capability gain and
depends on nothing. Row 6 is independent. Rows 13 and 14 are explicitly gated on measurements
that do not exist yet, and I would not start either.

## 8. Coverage and search record

### Read-depth tally

**Twenty-six named sources.** Eleven papers were read at **partial** depth, each with the
sections relied on recorded in its entry — and for a capability pass "partial" means the
definitions, theorems and algorithms this report uses were read in full while proofs generally
were not. Ten carry **abstract/metadata only**. Five are **reference implementations read at
source level**, with the files and line counts recorded in each entry: Boa, `egg`, OpenFst,
VeriPB and Catlab.jl. **No paper was read at full text**, and that is a deliberate shape for this
pass rather than an omission: the depth budget went into source code and into the specific
theorem statements the absorption rows depend on. The companion first pass
(`2026-09-12-c1150-part-b-compilers-solvers-normalization.md`) records its own tally, including
two full-text paper reads, and several of its partial reads are reused here without re-reading —
notably the Polygraphs preface and the Suciu–Wang–Zhang contribution statement.

This is a capability study. No verdict here depends on the absence of prior work, and no novelty
or priority claim is made or implied.

### Reference implementations inspected

| Tool    | Language | Files read                                       |
|---------|----------|--------------------------------------------------|
| Boa     | Rust     | optalg.rs, refpart.rs, coalg.rs, hmap.rs         |
| egg     | Rust     | extract.rs, unionfind.rs, run.rs                 |
| OpenFst | C++      | push.h, reweight.h, float-weight.h               |
| VeriPB  | Python   | README.rst, rules_dominance.py, rules.py, a .pbp |
| Catlab  | Julia    | Coequalizers.jl, skelfinsetcat/Colimits.jl       |

All were fetched from `raw.githubusercontent.com` on 2026-09-12 into this session's scratchpad,
except the OpenFst headers, taken from the `kkm000/openfst` mirror. Repository file listings were
obtained through the GitHub trees API. Three findings in this report exist only because the code
was read and contradict or sharpen what the papers say:

1. **Boa's signatures are 64-bit FxHash digests**, so its minimization is exact only up to hash
   collision; its own test suite hedges empirically against the naive algorithm.
2. **OpenFst's `Reweight` requires `Divide`**, and explicitly skips arcs touching `Zero` — which
   is what makes Ergodis's saturating `u32::MAX` sentinel, not the tropical semiring, the blocker
   for weight pushing.
3. **Catlab's coequalizer in skeletal finite sets is union-find plus a sorted renumbering** — the
   same structure as `egg`'s e-class union-find and Boa's signature renumbering.

A fourth is a documentation defect rather than a finding: Boa's `RefinablePartition::partition`
field comment states the clean/dirty convention backwards relative to `new()` and `mark_dirty`.

### Cache additions and corrections

New keys added by this task: `10.1093/logcom/2.4.511`, `cousot-plilp-1992-galois-vs-widening`,
`10.1145/512950.512973` (status `no-text` — see below), `arXiv:2004.03082`, `arXiv:1806.05654`,
`arXiv:2204.06248`, `arXiv:1811.08850`, `mckay-1998-isomorph-free-exhaustive-generation`,
`devriendt-2016-improved-static-symmetry-breaking-sat`, `arXiv:0908.3331`, `arXiv:2406.13557`,
`arXiv:2312.00990`, `arXiv:2107.13433`, `arXiv:2105.11788`, `arXiv:2607.02603`. Reused without
re-fetching: `arXiv:2204.12368`, `arXiv:2508.13020`, `arXiv:1301.1493`, `arXiv:2312.00429`,
`10.1007/s10472-010-9213-y`. SHA-256 values are quoted in each source's entry. The fetch helper
is `/tmp/persistent/tavis/lit-search/fetch_c1151b.sh`, which refuses any download whose magic
bytes are not `%PDF`; the C1150 helper it was copied from had been removed from the cache
directory between sessions.

**Two corrections were written back into the shared cache manifest**, because a wrong title in a
shared cache is worse than a missing entry. Both were fetched under guessed arXiv identifiers
that turned out to belong to unrelated papers:

- `arXiv:2006.09055` — requested as a coalgebraic partition-refinement paper; it is Biswas and
  Dumitrescu, "Nonabelian Hodge theory for Fujiki class C manifolds".
- `arXiv:2306.10863` — requested as Niu–Spivak on polynomial functors; it is Choksatchawathi et
  al., "ApSense: Data-driven Algorithm in PPG-based Sleep Apnea Sensing".

A third, `arXiv:0804.4881`, was fetched while looking for a Valmari paper and is Piperno's
"Search Space Contraction in Canonical Labeling of Graphs" — a relevant paper, but not the one
requested; its title was corrected too and it is cited in §3.2 under its real identity. Each
corrected entry carries a `note` field recording the misfiling. **The lesson is worth stating: I
guessed three arXiv identifiers from memory and all three were wrong.** Identifiers should be
resolved by search before fetching, and the magic-byte check does not catch this class of error
because the bytes are a perfectly good PDF of the wrong paper.

`10.1145/512950.512973` (Cousot–Cousot POPL 1977) is cached with status `no-text`: the PDF is an
image scan and `pdftotext` extracted zero words. I did not read it, and everything attributed to
the 1976 and 1977 papers comes through the two 1992 papers.

### Load-bearing queries, verbatim

Web search was the only bibliographic service queried; every query returned results, so an empty
result was never mistaken for an error.

1. `Cousot "abstract interpretation frameworks" Galois connection widening narrowing journal
   logic computation 1992 pdf` — resolved the JLC and PLILP papers and their author-site PDF URLs.
2. `Valmari "bisimilarity minimization in O(m log n) time" 2009 refinable partition arXiv` —
   established that the paper is LNCS 5606 pp. 123–142 and **not** on arXiv.
3. `CoPaR coalgebraic partition refinement tool implementation github Wissmann Milius` — located
   the CoPaR tool and the distributed and weighted-tree-automata follow-ups.
4. `"orbital branching" Ostrowski Linderoth Rossi Smriglio pdf symmetric integer programs` —
   resolved venue and page range; no obtainable PDF.
5. `BreakID "improved static symmetry breaking" SAT Devriendt Bogaerts lex-leader row symmetry
   pdf` — located the author-hosted PDF actually used.
6. `Spivak Niu "Polynomial Functors: A Mathematical Theory of Interaction" arXiv number book pdf`
   — corrected my wrong identifier to arXiv:2312.00990.
7. `Lawvere theory free algebra normal form term rewriting "algebraic theory" presentation clone
   survey pdf open access` — established that the Polygraphs book's §13.1 covers exactly the
   needed material, after Hyland–Power proved unobtainable.
8. `GPU parallel equality saturation e-graph OR GPU partition refinement bisimulation CUDA
   data-parallel` — produced both GPU sources used in §6.1.

### Could not access

These license nothing and are carried forward as open gaps.

- **François Margot, "Symmetry in Integer Linear Programming"** (the *50 Years of Integer
  Programming* chapter). Three URLs attempted; each returned an HTML interstitial rejected by the
  cache's magic-byte check. This is the standard survey for §3 and its absence is that section's
  main coverage gap.
- **Antti Valmari, "Bisimilarity Minimization in O(m log n) Time"** (LNCS 5606). Springer
  paywall, no open preprint located. Its refinable-partition data structure and its claim that
  the bound holds with an unbounded label alphabet are characterised in §2.2 only through
  Wißmann et al.'s citations, and marked as such.
- **Ostrowski, Linderoth, Rossi, Smriglio, "Orbital branching"** (Math. Prog. 126(1)). No PDF
  obtainable; §3.3 uses only the Springer and Optimization Online landing-page descriptions, and
  reports no speedups.
- **Hyland and Power, "The Category Theoretic Understanding of Universal Algebra: Lawvere
  Theories and Monads"**. Four URLs attempted, all HTML. Not needed in the end — the Polygraphs
  book's §13.1 supplied the definitions at better depth for this purpose.
- **Cousot–Cousot POPL 1977** — cached but unreadable (image scan, no OCR performed).

### Not covered

- **zbMATH Open, OpenAlex, Crossref and Semantic Scholar were not queried.** No verdict here
  rests on a citation count or an enumerated citing set, so the citation-graph width requirement
  is not triggered. **MathSciNet: NOT COVERED** (institutional authentication). **Google Scholar:
  NOT COVERED** (blocks automated access).
- **No Ergodis source code was read.** This remains a documentation-and-literature study. Several
  mappings rest on statements in `scalar-plan-semantics.md`, `summary-transitions.md`,
  `observable-admission.md` and the C1016 task card that may lag their implementations.
- **The C1016 symmetry group in §3.5 is my own derivation** from the supplementary-difference-set
  equation as the task card states it. I did not verify it against the private implementation,
  and in particular I could not check whether the Goethals–Seidel array or the border kills the
  block-permutation part. Everything in absorption row 8 is conditional on that check.
- **Part A's territory was excluded by design** and remains so: Vincent Abbott's diagram papers,
  categorical deep learning and cats4ai search priors, and optics/Para-style categorical
  optimization. Row 14's automatic differentiation touches the boundary and is deliberately
  scoped to the hypergraph representation rather than to the optics.
- **The e-boost figures (558× over ILP, 19.04% over the heuristic baseline) are unverified**, read
  from its abstract only. Likewise Biondi et al.'s "two orders of magnitude" and 30-billion-edge
  claim, and Jacobs–Wißmann's 1.7 GB versus 265 GB comparison — that last one read from their
  introduction rather than from the benchmark tables.

## 9. Incidental leads

Observations met while searching that are outside this task's scope. Recorded with provenance,
not written to the discovery track by me, and not promoted to any C-item.

1. **Three quotient computations in this study share one data structure.** `egg`'s e-class
   union-find (`src/unionfind.rs`, read in full), Catlab's coequalizer in skeletal finite sets
   (`IntDisjointSets` plus `quotient_projection`, read in full), and Boa's dense signature
   renumbering are the same union-find-plus-canonical-renumbering pattern. An Ergodis
   implementation of any one is most of an implementation of the others. Noted because it changes
   the cost estimate for adopting several absorption rows at once, and because nobody in the
   sources says it.

2. **`egg`'s greedy extractor is a Bellman–Ford relaxation with a documented monotonicity
   precondition.** `Extractor::find_costs` (`src/extract.rs`, read in full) is a worklist over
   e-classes re-enqueueing parents on improvement, and the `CostFunction` trait requires
   "`cost` should return a `Cost` greater than any of the child costs". Ergodis's
   `ordered_resource` finite ordered monoids are exactly the setting where that precondition
   either holds by construction or fails informatively. Unpursued, but it is the cheapest possible
   check on whether an Ergodis cost model is extraction-compatible.

3. **`P_f P_f` is not zippable, and zippable functors are closed under neither composition nor
   quotients** (Wißmann et al., Example 5.10). This is a sharp boundary on which representation
   families admit the fast refinement step, and "nested nondeterminism" is exactly the shape that
   fails. Worth holding as a rejection fixture if Ergodis ever composes representation families
   automatically.

4. **Boa's `refine` carries an unexploited optimisation as a `TODO`**: "assign the old ID to the
   block with the fewest predecessors" rather than to the largest block. The Hopcroft bound is
   stated in terms of block size, but the actual work is proportional to predecessor count, so the
   two criteria differ. Noted as an open micro-optimisation in a published tool, not as an Ergodis
   task.

5. **VeriPB instruments its own cheap path.** `AddRedundant.compute` maintains
   `stats.numGoalCandidates` against `stats.numSubgoals` — goals considered versus goals that
   actually needed proof — and an `autoRUPstreak` counter that switches strategy after five
   consecutive cheap successes. That is a small, general pattern for any checker with a fast path
   and a slow path, and Ergodis's admission checks have exactly that shape.

6. **Hypernets are the shared substrate for automatic differentiation and for monoidal
   e-graphs.** Alvarez-Picallo–Ghica–Sprunger–Zanasi's hierarchical hypergraphs (arXiv:2107.13433,
   read at the depth recorded in §6.1) and Tiurin et al.'s e-hypergraphs (first pass, §1.2) are
   the same class of structure, from overlapping author groups. If Ergodis ever adopts either, the
   representation arrives with it. Unpursued.

7. **Randomized refinement with probabilistic guarantees is becoming the norm at scale.**
   Biondi–Tribastone–Tschaikowski's GPU 1-WL (§6.1) is randomized; Boa's signatures are hashed.
   Both are correct with high probability rather than certainly. For a system whose vocabulary
   forbids an unqualified "verified", this is a category of trust boundary that will keep
   recurring, and it may deserve a named policy — exact authority path plus fast accelerator with
   recheck — rather than a per-adoption decision. Recorded as an observation about a pattern, not
   as a proposal.

8. **The 1-WL upper bound is an argument against graph neural networks here, not merely a
   limitation of them.** Message-passing architectures cannot distinguish what 1-WL cannot, and
   §6.1's GPU result computes 1-WL exactly at web scale. Wherever Ergodis might have reached for a
   learned graph model for symmetry or isomorphism, the classical algorithm is both exact and
   cheaper. Noted because it is a reusable argument, not a one-off.
