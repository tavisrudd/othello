# Tensor logic and the RelationalAI Datalog line — a reading study

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** bounded reading and positioning study.
No code written; nothing under `~/src/ergodis*` edited.

## Why this study exists

William Macready told Tavis he is marrying Vincent Abbott's categorical compilation to **tensor
logic** (`tensor-logic.org`, Pedro Domingos) as an external syntax, and that tensor logic is a
subset of the Datalog work done at RelationalAI with an einsum-based syntax. This study reads the
tensor-logic material and the RelationalAI line directly and says what they actually define, so
that the claim "tensor logic is a subset of X" can be assessed against X rather than against
recollection.

Two things carried in from earlier work in this lane. The C1150 and C1151 part B passes already
read **Suciu, Wang and Zhang on the semantic foundations of equality saturation** — weak term
acyclicity, and the two-way reduction between equality saturation and the database chase — and
that paper is from the same circle as the RelationalAI work; it is reused here at its recorded
depth rather than re-read. The C1151 absorption rows referenced below are: semiring-polymorphic
verifier, weight pushing over a semiring, weak term acyclicity, coalgebraic partition refinement,
and the VeriPB-style omission certificate.

## Rules followed

Read depth is recorded on every source unconditionally, including sources named only to be
dismissed. Every PDF fetched is added to the shared cache at `/tmp/persistent/tavis/lit-search/`
with its key and SHA-256. **Every arXiv or DOI identifier is resolved from the abstract page or
from returned metadata before fetching** — the C1151 pass guessed three identifiers from memory
and all three were wrong, so no identifier here is written from recollection.

## 1. Tensor logic: the language, its semantics, and what it does not have

### 1.1 Sources

**`tensor-logic.org`.** *Read depth: full text of the landing page* — fetched 2026-09-12. The page
is a few sentences plus links. Verbatim: tensor logic is "an AI programming language based on a
deep unification of deep learning and symbolic AI" that "combines the scalability and
gradient-based learning of neural networks with the transparency and reliability of symbolic
knowledge representation and reasoning." It links to the arXiv paper, a slide deck
(`homes.cs.washington.edu/~pedrod/tl.pptx` and `tls.pdf`), and a YouTube keynote. **The page
itself describes neither syntax nor semantics, does not mention Datalog or einsum, and does not
name its author** — the name appears only inside a URL path. Everything substantive below comes
from the paper.

**Pedro Domingos, "Tensor Logic: The Language of AI", arXiv:2510.12269v3 [cs.AI], submitted
14 October 2025, last revised 16 October 2025; DOI 10.48550/arXiv.2510.12269. Paul G. Allen
School of Computer Science & Engineering, University of Washington.** *Read depth: full text* —
arXiv v3 PDF, cached as `arXiv:2510.12269`, SHA-256
`597c71cac2b7c2aa93c90d39fcd4338574093f368b1065418738087e3d1f9a19`, 17 pages; read end to end
(§1 Introduction, §2 Background, §3 Tensor Logic with its representation/inference/learning
subsections, §4 Implementing AI Paradigms including the transformer table, §5 Reasoning in
Embedding Space, §6 Scaling Up, §7 Discussion). Identifier and metadata resolved from the arXiv
abstract page before fetching. Subject classes cs.AI, cs.LG, cs.NE, cs.PL, stat.ML. **Single
author.**

**Pedro Domingos, tensor logic slide deck (`homes.cs.washington.edu/~pedrod/tls.pdf`).** *Read
depth: partial* — cached as `domingos-tensor-logic-slides`, SHA-256
`46e40adf24cb3294876ab6a916bc30eb398424d201175f2b3f6aa25d82ed59ea`, 36 pages; read the syntactic
sugar, Turing-completeness, inference and summary slides. Used only where it states something
more compactly than the paper.

### 1.2 The exact language

**One construct.** "The sole construct in tensor logic is the tensor equation." A tensor logic
program is a set of tensor equations. The left-hand side is the tensor being computed; the
right-hand side is "a series of tensor joins followed by a tensor projection, and an optional
univariate nonlinearity applied elementwise to the result." Join signs are implicit and the
projection is onto the indices appearing on the left. Tensors are written `Name[i, j, …]`.
Domingos states: "This is the entire definition of tensor logic. There are no keywords, other
constructs, etc."

**The two primitives, defined exactly as in the paper.**

```
projection      π_α(T) = Σ_β T_αβ          β = T's indices not in α
join            (U ⋈ V)_αβγ = U_αβ V_βγ    β = the shared indices
```

If `U` has rank `r`, `V` has rank `r′` and `|β| = q`, then `U ⋈ V` has rank `r + r′ − q`. With no
shared indices the join degenerates to the tensor (Kronecker) product; with all indices shared it
degenerates to the elementwise (Hadamard) product. **For Boolean tensors, join is database join
and projection-followed-by-step is database projection.**

**The identification with Datalog.** "A relation is a compact representation of a sparse Boolean
tensor" and "a Datalog rule is an einsum over Boolean tensors, with a step function applied
elementwise to the result" — specifically the Heaviside step `H(x) = 1 if x > 0 else 0`. His
worked example:

```
Aunt(x, z) ← Sister(x, y), Parent(y, z)
A_xz = H(S_xy P_yz) = H( Σ_y S_xy P_yz )
```

The step function is needed because several witnesses `y` can make the sum exceed 1.

**Two deviations from classical Einstein notation, both explicit.** First, "the summed-over
indices are those that do not appear in the LHS, and thus a repeated index may or may not be
summed over" — so `Y[i] = step(W[i] X[i])` does *not* sum over `i`. Second, "tensor elements are 0
by default, and equations with the same LHS are implicitly summed", which is what preserves the
correspondence with multiple Datalog rules sharing a head.

**Syntactic sugar, declared not to increase expressiveness:** multiple terms per equation; index
functions (`X[i, t+1] = W[i, j] X[j, t]`); normalisation (`softmax`); other tensor functions
(`concat`); **alternate projection operators — "`max =` or `avg =` instead of `+ =`, which `=`
defaults to"**; slices; procedural attachment; and Datalog syntax, where parentheses instead of
square brackets means Boolean.

**Inference** is "tensor generalizations of forward and backward chaining". Forward chaining
treats the program as linear code, executing each equation in turn "computing the tensor elements
for which the necessary inputs are available; this is repeated until no new elements can be
computed **or a stopping criterion is satisfied**." Backward chaining treats each equation as a
function called from the query, with subquery elements "assigned 0 by default" when no equation
defines them.

**Learning.** Because there is one statement type, differentiation is uniform: if
`Y[…] = T[…] X₁[…] … Xₙ[…]` then `∂Y[…]/∂T[…] = X₁[…] … Xₙ[…]`, so "the gradient of a tensor logic
program is also a tensor logic program, with one equation per equation and tensor on its RHS."
Varying program structure per example is handled by backpropagation through structure.
**Tucker decomposition in tensor logic is presented as a generalisation of predicate invention.**

**What "reasoning" means here.** §5 is the paper's own headline claim. Objects get embeddings
(random unit vectors, or learned); a set becomes a superposition `S[d] = V[x] Emb[x, d]`, and
membership is recovered by a dot product thresholded at ½, "similar to a Bloom filter", with error
probability falling with embedding dimension. A binary relation embeds as
`EmbR[i, j] = R(x, y) Emb[x, i] Emb[y, j]`, a tensor product representation after Smolensky, and
`D[A, B] = EmbR[i, j] Emb[A, i] Emb[B, j] ≃ R(A, B)`. Rules embed by replacing antecedents and
consequents with their embeddings, and chaining proceeds over the embedded rules. With learned
embeddings, `Sim[x, x′] = Emb[x, d] Emb[x′, d]` is a Gram matrix and "similar objects 'borrow'
inferences from each other, with weight proportional to their similarity." Applying a sigmoid with
temperature `T`, "setting its temperature parameter `T` to 0 effectively reduces the Gram matrix
to the identity matrix, making the program's reasoning purely deductive", and raising `T` makes
reasoning "increasingly analogical". So **"sound reasoning" here means: approximate deduction whose
error probability is controlled by embedding dimension, exactly recovering deduction in the `T → 0`
limit** — not a proof-carrying notion.

**Scaling.** Two routes: separation of concerns (dense subtensors on GPUs, sparse ones handed to
"a database query engine, by treating (sub)tensors as relations", so that "the full panoply of
query optimization can then be applied"); or convert sparse to dense by Tucker decomposition, at
"a small probability of error, but this can be controlled by appropriately setting the embedding
dimension and denoising results by passing them through step functions." Next steps named in §7
include "implementing tensor logic directly in CUDA".

### 1.3 What tensor logic does not have

Stated as absences I checked for and did not find, not as criticisms.

- **No semirings.** The word does not occur. Summation is ordinary `+` over the reals, with
  `max =` and `avg =` offered as *syntactic sugar*. `avg` is not a semiring operation at all, and
  no algebraic law is required of any of them. There is no statement of which laws a projection
  operator must satisfy for the join/project identities to hold.
- **No negation.** The paper contains no negation operator, no stratification condition, and no
  discussion of well-founded or three-valued semantics.
- **No termination or convergence theory.** Forward chaining repeats "until no new elements can be
  computed **or a stopping criterion is satisfied**" — a budget, with no characterisation of when
  the first disjunct fires. There is no fixpoint existence theorem, no monotonicity requirement,
  and no complexity statement. The paper notes tensor logic is Turing-complete via recurrent
  networks (and the slides add "But Datalog is not"), which settles the matter: **termination
  cannot be guaranteed in general, and the paper offers no fragment where it can.**
- **No aggregation-in-recursion theory.** `max =` inside a recursive equation is syntactically
  permitted and semantically unaddressed.
- **No query optimisation, no join algorithms, no complexity bounds.** §6 defers these to "a
  database query engine".
- **No certificates and no verification.** Correctness of an inference is not a checkable object;
  §5's reliability claim is a probabilistic bound plus a temperature knob.
- **Symbolic AI gets three sentences.** §4.2 in its entirety says a Datalog program is a valid
  tensor logic program, that this suffices for "reasoning and planning in function-free domains",
  and that "accommodating functions (as in Prolog) requires implementing unification in tensor
  logic", which is not done.
- **No implementation is described or linked** in the paper; CUDA implementation is future work.

My inference, marked as mine: the claim that tensor logic is "a subset of the RelationalAI Datalog
work with an einsum-based syntax" is **accurate about the core and generous about the periphery**.
The core identification — a Datalog rule is a join followed by a projection, and that is an einsum
— is exactly `datalog°`'s `K`-relation semantics specialised to the Boolean semiring, and §2 below
shows RelationalAI's line states it with the algebra attached. What tensor logic adds beyond that
subset is the embedding-space machinery of §5 and gradient-based learning; what it lacks is every
convergence, negation, aggregation and optimisation result that the Datalog line spent a decade
establishing.

## 2. The RelationalAI line

### 2.1 `datalog°`: Datalog over partially ordered pre-semirings

**Mahmoud Abo Khamis (RelationalAI, Berkeley), Hung Q. Ngo (RelationalAI, Berkeley), Reinhard
Pichler (TU Wien), Dan Suciu (University of Washington), Yisu Remy Wang (University of
Washington), "Convergence of Datalog over (Pre-) Semirings", PODS 2022, DOI
10.1145/3517804.3524140; journal version in Journal of the ACM 71(2); arXiv:2105.14435v5 [cs.DB],
24 January 2024.** *Read depth: partial, at algorithm depth* — arXiv v5 PDF, cached as
`arXiv:2105.14435`, SHA-256
`9f360b1a6b3c3f85ecce5ee232e080857cd01378278fd39dc2923d8c065f094b`, 55 pages; read in full: the
abstract, §1 Introduction, §1.1 Overview of the Results (the five convergence cases, the stability
definition, Theorem 1.2, the ACC discussion, the semi-naïve development with the `⊖` operator, and
the negation-via-`THREE` paragraph), and §1.2. Proofs in §§2–7 were read by statement only.
Affiliations are as printed on the paper. This is the **most load-bearing source in this study.**

**The language.** `datalog°` generalises Datalog from sets to `K`-relations (Green, Karvounarakis
and Tannen's construction, already read in the C1150 pass): a `P`-relation of arity `k` maps
`k`-tuples to a **partially ordered commutative pre-semiring (POPS)** `P` with operations `⊕, ⊗`,
a partial order `⊑` and a least element `⊥`. Datalog's `∧, ∨, ∃` become `⊗, ⊕, ⊕_Z`. Their own
framing of why this matters: "importantly, an existential quantifier `∃` becomes an `⊕`-aggregate
operator." Standard relations are `B`-relations, bags are `N`-relations, **sparse tensors are
`R`-relations**.

Their headline example is worth quoting because it is the same equation Ergodis's summary
transitions compute:

```
T(X, Y) :- E(X, Y) ⊕ ⊕_Z ( T(X, Z) ⊗ E(Z, Y) )
```

Over the Boolean semiring this is transitive closure. Over `Trop₊` — non-negative reals with
infinity, `(⊕, ⊗) = (min, +)`, order reversed so `x ⊑ y` iff `x ≥ y` — "the same `datalog°` program
will express similar problems, in exactly the same way": all-pairs shortest paths. Over `Trop^p₊`
it computes the top `p+1` shortest paths.

**Why POPS rather than semiring.** Least-fixpoint semantics needs a partial order, and the
generalisation past *naturally ordered* semirings is load-bearing for real programs — their
bill-of-materials example "is naturally expressed over the lifted reals, `R⊥`, which is a POPS that
is not naturally ordered."

**The convergence theorem.** For a semiring `S` and `u ∈ S`, write `u^(p) := 1 ⊕ u ⊕ u² ⊕ … ⊕ u^p`.
Then `u` is **`p`-stable** if `u^(p) = u^(p+1)`; `S` is `p`-stable if every element is; `S` is
**stable** if every element is `p`-stable for some `p` depending on the element. For any POPS `P`,
the set `P ⊕ ⊥ = {u ⊕ ⊥ | u ∈ P}` is a semiring (their Proposition 2.4), and everything is stated
about it.

> **Theorem 1.2.** Given a POPS `P`:
> - Every `datalog°` program converges **iff** the semiring `P ⊕ ⊥` is stable.
> - Every program converges in a number of steps depending only on `|ADom(I)|` **iff** `P ⊕ ⊥` is
>   `p`-stable for some `p`. More precisely, every program converges in `Σ_{i=1}^{N} (p+2)^i` steps,
>   where `N` is the number of ground tuples of IDB predicates over `ADom(I)`; and if the program is
>   **linear** (at most one IDB predicate per rule body) it converges in `Σ_{i=1}^{N} (p+1)^i` steps.
> - If `P ⊕ ⊥` is **0-stable**, every program converges in `N` steps — polynomial time in the input
>   database.

Two remarks they make and I will use. First, the Ascending Chain Condition is **sufficient but not
necessary**: "`Trop₊` is 0-stable, and therefore every `datalog°` program converges on `Trop₊`, yet
it does not satisfy the ACC condition." Second, the naïve algorithm is the Kleene iteration;
Newton's method converges in fewer steps but each step requires solving an inner least fixpoint,
and "one experimental evaluation has found that it is not" more efficient in practice, so the paper
analyses only the naïve algorithm.

**Semi-naïve evaluation over a semiring.** The classical semi-naïve delta recurrence needs a
"minus". For the tropical semiring they define

```
v ⊖ u  =  v   if v < u
          ∞   if v ≥ u
```

and the APSP semi-naïve loop becomes

```
δ^(t)(X,Y)   = ( min_Z δ^(t−1)(X,Z) + E(Z,Y) ) ⊖ T^(t)(X,Y)
T^(t+1)(X,Y) = min( T^(t)(X,Y), δ^(t)(X,Y) )
```

with the stated rationale that a database stores only tuples whose value is `≠ ⊥`, so `⊖` returning
`∞` signals "no update needed". **This `⊖` is a comparison, not a division** — which is the
contrast with OpenFst's weight pushing recorded in the C1151 pass, where `Reweight` needs `Divide`
and therefore cancellativity.

**Negation.** Interpreting `datalog°` over a three-valued POPS they call `THREE`, with
`not(0) = 1`, `not(1) = 0`, `not(⊥) = ⊥`, which is monotone with respect to Fitting's knowledge
order `⊥ ≤_k 0`, `⊥ ≤_k 1`, gives Datalog-with-negation under Fitting's three-valued semantics,
"hence, in cases when Fitting's 3-valued semantics coincides with the well-founded semantics, so
does `datalog°` equipped with the function `not`."

### 2.2 The FGH-rule: optimising recursive programs by a commuting square

**Yisu Remy Wang, Mahmoud Abo Khamis, Hung Q. Ngo, Reinhard Pichler, Dan Suciu, "Optimizing
Recursive Queries with Program Synthesis", SIGMOD 2022, DOI 10.1145/3514221.3517827;
arXiv:2202.10390v1 [cs.DB], 21 February 2022.** *Read depth: partial, at algorithm depth* — arXiv
PDF, cached as `arXiv:2202.10390`, SHA-256
`6cb34e4614662be0d1818934481159352bc40f538852433f62e5b5b63b5a4ba3`, 23 pages; read in full: the
abstract, §1's overview of the FGH-rule and the query-synthesis framing, §3's statement and proof
sketch of Theorem 3.1, and the connected-components example of Figure 1. Sections 4–8 (known
optimisations recovered, loop-invariant inference, evaluation) were read by statement only.
Identifier and author order resolved from the arXiv abstract page before fetching.

The rule is a commuting square and nothing more. Given an iterative program that loops `F` and then
applies `G` to produce the answer ("the FG-program"), and an alternative that applies `G` once and
then loops `H` ("the GH-program"):

> **Theorem 3.1 (The FGH-Rule).** If `G(F(X)) = H(G(X))`, then the FG-program is equivalent to the
> GH-program.

The worked example is connected components. The unoptimised program computes transitive closure
`TC(x, y)` and then a min-aggregate `CC[x] :- min_y {L[y] | TC(x, y)}`, at `O(n²)` space; the
optimised program computes `CC[x] :- min(L[x], min_y {CC[y] | E(x, y)})` directly in a single
recursive rule with min-aggregation, at `O(n)` space. They state the FGH-rule "can express
previously known optimizations for Datalog, including magic sets and semi-naive evaluation", and
report "speedups of up to 4 orders of magnitude" across three already-optimised Datalog systems.

The implementation is the part worth knowing: finding `H` is a synthesis problem, not pattern
matching. "The FGH-rule often requires exploring a very large space, which cannot be covered by a
limited set of rules", so they use **counterexample-guided inductive synthesis (CEGIS)**, verify
candidates with **z3**, and use the verifier's counterexample database to drive the next round.
The abstract also names "an equality saturation system" among the tools.

### 2.3 Worst-case optimal joins: Generic Join and Free Join

**Hung Q. Ngo, Christopher Ré, Atri Rudra, "Skew Strikes Back: New Developments in the Theory of
Join Algorithms", ACM SIGMOD Record 42(4):5–16 (2013), DOI 10.1145/2590989.2590991;
arXiv:1310.3314.** *Read depth: partial, at algorithm depth* — arXiv PDF, cached as
`arXiv:1310.3314`, SHA-256
`3344097ec9cb5da34e101fc6a8ad2fffcec0d28b4a4cc48812084325a34049e3`, 24 pages; read in full: §1's
framing, §3.1's statement of the AGM bound, and Algorithm 3 (Generic-Join) with its runtime
argument. The power-of-two-choices development in §2 and the later sections were skimmed.
Identifier, venue and page range resolved by search against the dblp and ACM records.

A join query over attribute set `V` is a hypergraph `H = (V, E)` with a relation `R_F` per
hyperedge. A **fractional edge cover** is a point `x = (x_F)` with `Σ_{F : v ∈ F} x_F ≥ 1` for every
`v ∈ V` and `x ≥ 0`. The **AGM inequality** (Atserias–Grohe–Marx, Grohe–Marx) bounds the output:

```
|Q| = | ⋈_{F∈E} R_F |  ≤  Π_{F∈E} |R_F|^{x_F}
```

**Generic-Join** (their Algorithm 3) achieves that bound up to a log factor:

```
Generic-Join( ⋈_{F∈E} R_F ):
    if |V| = 1:  return ⋂_{F∈E} R_F
    pick I with 1 ≤ |I| < |V|
    L ← Generic-Join( ⋈_{F∈E_I} π_I(R_F) )
    for each t_I ∈ L:
        Q[t_I] ← Generic-Join( ⋈_{F∈E_J} π_J(R_F ⋈ t_I) )
        Q ← Q ∪ {t_I} × Q[t_I]
    return Q
```

with overall runtime `Õ(m·n·Π_F |R_F|^{x_F})`. The structural point is that Generic Join processes
**one attribute at a time across all relations sharing it**, where binary join processes **two
relations at a time across all their shared attributes**.

**Yisu Remy Wang, Max Willsey, Dan Suciu (all University of Washington), "Free Join: Unifying
Worst-Case Optimal and Traditional Joins", Proc. ACM Management of Data 1(2), 20 June 2023, DOI
10.1145/3589295; arXiv:2301.10841v2 [cs.DB], 27 January 2023.** *Read depth: partial* — arXiv
PDF, cached as `arXiv:2301.10841`, SHA-256
`ff7683faf2a11214dd6259d4d38d12a0bee300de4ade3f85424f3fec69ed0f45`, 13 pages; read in full: the
abstract and §1 Introduction with the full contribution list and results; §§2–6 skimmed.

Their observation is that the two paradigms sit at opposite corners of one design space — "each
join operation may process any number of attributes and relations" — and Free Join covers the
whole space. Three contributions: an algorithm converting any binary join plan into a Free Join
plan "that runs as fast or faster" (so existing cost-based optimisers are reused; they take plans
from DuckDB's optimiser); **COLT**, a Column-Oriented Lazy Trie that builds inner subtries on
demand and "completely eliminates the cost of trie building for left tables", addressing what they
identify as the main practical inefficiency of Generic Join; and the first vectorised execution
algorithm for Generic Join. **Implemented as a standalone Rust library.** Reported: on acyclic
queries up to 19.36× faster than binary join and 31.6× faster than Generic Join; on cyclic queries
up to 15.45× and 4.08× respectively. I have not verified these figures.

They also record a useful negative about plan search: "since the theoretical analysis of Generic
Join guarantees worst case optimality for any variable order, it is a folklore belief that Generic
Join is more robust than binary join plans to poor choices of the" order — and the paper's framing
is that this belief needs revisiting, since runtime does depend on the order.

### 2.4 egglog: Datalog and equality saturation as one fixpoint system

**Yihong Zhang (University of Washington), Yisu Remy Wang (University of Washington), Oliver Flatt
(University of Washington), David Cao (UC San Diego), Philip Zucker (Draper Laboratory), Eli
Rosenthal (Google), Zachary Tatlock (University of Washington), Max Willsey (University of
Washington), "Better Together: Unifying Datalog and Equality Saturation", Proc. ACM Program. Lang.
7, PLDI, Article 125 (June 2023), DOI 10.1145/3591239; arXiv:2304.04332v4 [cs.PL], 15 May 2023.**
*Read depth: partial, at algorithm depth* — arXiv PDF, cached as `arXiv:2304.04332`, SHA-256
`bf26d308dc3d3840dfd36e4453c89da57b66cf25c172bef15992e4d27fded487`, 33 pages; read in full: the
abstract, §1 Introduction with the two motivating failures, the lattice-semantics paragraphs of
§3, and §4.2's core-egglog semantics including the instance definition, the canonicalisation
function, the `flatten` definition of Figure 6, and the immediate-consequence/rebuilding split
with footnote 4. Affiliations are as printed. Evaluation sections were skimmed.

egglog "supports efficient incremental execution, cooperating analyses, and lattice-based
reasoning" like Datalog, and "term rewriting, efficient congruence closure, and extraction of
optimized terms" like equality saturation. The two motivating failures are concrete and worth
carrying: Herbie, an equality-saturation floating-point optimiser, "relies on unsound rewrites
because it lacks the analyses to prove that certain rewrites are safe (e.g. `x/x → 1` only if
`x ≠ 0`)" and must validate and discard afterwards; cclyzer++, a Datalog points-to analysis,
"resorted to an ad-hoc implementation of union-find, because the provided implementation of
equivalence relations was too slow", and the complexity caused bugs.

**Core semantics.** Given uninterpreted constants `N` and a complete lattice `L = (C, ⊑, ⊔)` over
interpreted constants, an instance is a pair `I = (DB, ≡)` where `DB` is a set of function entries
`f(v₁,…,v_k) ↦ v` and `≡` is an equivalence relation on `N ∪ C` in which interpreted constants are
equivalent only to themselves. Canonicalisation `λ_≡(t) = min{t′ : t′ ≡ t}` under an arbitrary
total order picks representatives. The semantics is **two operators**: an inflationary immediate
consequence operator `T_P↑(I) = DB ∪ T_P(I)`, and a **rebuilding** operator restoring congruence.
Their footnote 4 is the important caveat: the union with `DB` is needed because "rule applications
in standard Datalog are monotone. This is not the case in egglog in general" — a `:merge`
expression may be any egglog expression, not only a lattice join, and a rule reading a lower bound
that increases over time is non-monotone. The uninterpreted constants "play a similar role as
e-class ids in EqSat or labelled nulls in the chase from the database literature."

### 2.5 Rel and the relational knowledge graph

**Molham Aref (RelationalAI), Paolo Guagliardo (University of Edinburgh), George Kastrinis
(RelationalAI), Leonid Libkin (RelationalAI and University of Edinburgh), Victor Marsault (LIGM,
Université Gustave Eiffel, CNRS), Wim Martens (RelationalAI and University of Bayreuth), Mary
McGrath, Filip Murlak (University of Warsaw), Nathaniel Nystrom (RelationalAI), Liat Peterfreund
(Hebrew University), Allison Rogers (RelationalAI), Cristina Sirangelo, Domagoj Vrgoč, David Zhao,
Abdul Zreika, "Rel: A Programming Language for Relational Data", SIGMOD 2025, DOI
10.1145/3722212.3724450; arXiv:2504.10323v2 [cs.DB], last revised 24 April 2025.** *Read depth:
partial* — arXiv v2 PDF, cached as `arXiv:2504.10323`, SHA-256
`80460b3169da289432f44ebe6b03ab59f77dbeaf7d2d097d51d5f97b4d995d03`, 14 pages; read in full: the
author block, the abstract, §1's four-feature list and the matrix-multiplication teaser, §2 on
graph normal form, §3's code-flow-and-recursion material, and §7's influences. Sections 4–6 were
skimmed. Author order and affiliations resolved from the arXiv abstract page and the paper's own
title block; a few authors' affiliations are not printed and are omitted rather than guessed.

Rel's stated goal is to leave the sublanguage paradigm: "Rel is a new relational language whose key
design goal is to go beyond this paradigm with features that allow for programming in the large,
making it possible to fully describe end to end application semantics." Its four named features:
"(1) manipulation of both logical formulas and entire relations; (2) powerful recursion built on
the foundations of Datalog; (3) abstraction and application as key constructs; (4) variables that
can range over tuples and relations."

**The einsum connection is explicit in the paper's own teaser**, and this is the sentence most
relevant to Macready's claim:

```
def MatrixMult[{A},{B},i,j] : sum[ [k] : A[i,k]*B[k,j] ]
```

with the comment that "since relations can easily model vectors, matrices, and tensors, Rel can
naturally deal with analytics and ML workloads" and that "the Rel definition of matrix
multiplication mimics its mathematical definition".

**Graph normal form (GNF)** is the data-modelling half: (1) for each `k`-ary relation, either all
`k` columns are the key, or the first `k−1` columns are; and (2) the unique identifier property —
no two disjoint concepts share an identifier across the database. GNF requires sixth normal form,
implies every relation is a set, and removes the need for nulls ("rather than using a null in the
non-key column, we simply omit the whole tuple"). "Relational databases in GNF can be thought of as
Relational Knowledge Graphs." The motivating principles are *indivisibility of facts* and *things,
not strings*.

**Recursion and control.** Rule order has no effect on semantics. Control relations `output`,
`insert` and `delete` are defined like any other relation and carry the side effects. Influences
named in §7: LogiQL/LogicBlox, Soufflé, .QL of Semmle, and **Dyna** — "with the latter two
reflected in Rel's ability to handle infinite sets and to combine recursion with numerical
computations" — plus Dedalus and Statelog for rule-driven updates, and Data HiLog for relation
variables.

**What the Rel paper does not contain:** the word *semiring* does not appear. Rel is the product
language — Datalog with first-order bodies, aggregation, abstraction and GNF — while `datalog°` is
the theory of what recursion-plus-aggregation *means*. They are the same research programme seen
from two ends, and it is worth not conflating them.

### 2.6 Carried in from earlier passes

**Dan Suciu, Yisu Remy Wang, Yihong Zhang, "Semantic foundations of equality saturation",
arXiv:2501.02413v1 [cs.PL], 5 January 2025.** *Read depth: partial* — cached as
`arXiv:2501.02413`, SHA-256
`99bbc4173e98f76280fa83c1150776f0da0fbfce8ee28ddbc9d301ab4f6467a2`, read in the C1150 and C1151
passes at the depth recorded there (abstract, §1 with the full contribution statement, §6 and
Appendix E's Definition 45 and Theorem 46). Not re-read here. It is the direct bridge: E-graphs
are reachable deterministic tree automata, equality saturation is the least fixpoint of an
immediate consequence operator, and there is a two-way reduction between equality saturation and
the database chase, with **weak term acyclicity** as a syntactic criterion giving polynomial-step
convergence. Two of its three authors are in the RelationalAI orbit, and the paper cites egglog as
the system unifying the two sides.

**Todd J. Green, Grigoris Karvounarakis, Val Tannen, "Provenance Semirings", PODS 2007, DOI
10.1145/1265530.1265535.** *Read depth: partial* — cached, read in the C1150 pass (§§1–4 in full).
Not re-read. This is the `K`-relation construction `datalog°` builds on, and its Theorem 4.3 — that
positive relational algebra over any commutative semiring factors through the polynomial semiring
`N[X]` — is the universality statement behind "one algorithm, many semirings".
