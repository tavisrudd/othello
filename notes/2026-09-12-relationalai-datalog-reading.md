# Tensor logic and the RelationalAI Datalog line — a reading study

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** bounded reading and positioning study.
No code written; nothing under `~/src/ergodis*` edited.

## Opening summary

Eleven named sources: two at full text (the `tensor-logic.org` landing page and Domingos's tensor
logic paper, read end to end), eight at partial depth — six of those at algorithm depth — and one
supporting slide deck. Every arXiv identifier and DOI was resolved from an abstract page or venue
record before fetching.

**Macready's characterisation is accurate about the core and generous about the periphery.** Tensor
logic's central identification — a Datalog rule is a join followed by a projection, and that is an
einsum — is exactly the `K`-relation semantics of `datalog°` specialised to the Boolean semiring,
and Rel's own paper opens with `def MatrixMult[{A},{B},i,j] : sum[ [k] : A[i,k]*B[k,j] ]`. What
tensor logic adds beyond that subset is embedding-space reasoning and gradients. What it lacks is
everything the Datalog line spent a decade proving: **no semirings** (`max =` and `avg =` are
syntactic sugar with no laws stated, and `avg` is not a semiring operation), **no negation**, **no
termination or convergence theory** (forward chaining stops when nothing new can be derived "or a
stopping criterion is satisfied", and the language is Turing-complete), no aggregation-in-recursion
semantics, no join algorithms or complexity bounds, no certificates, and no described
implementation.

**The most useful single transfer is a two-line check that came out positive.** Abo Khamis, Ngo,
Pichler, Suciu and Wang prove that a `datalog°` program over a POPS converges iff `P ⊕ ⊥` is
stable, and in `N` steps when it is 0-stable. Ergodis's bounded min-plus has all costs
non-negative, so `u^(0) = 0` and `u^(1) = min(0, u) = 0` for every `u`: **it is 0-stable, and every
fixpoint over it converges in polynomially many steps.** The saturating `u32::MAX` sentinel does
not interfere, because the stability computation never forms a saturating sum. That separates two
requirements the C1151 pass had entangled: weight pushing needs *division* (which saturation
breaks), while fixpoint convergence needs *stability* (which Ergodis has). Their semi-naive `⊖` is
a comparison rather than a division, and Ergodis's leaf-delta verifier is already structurally a
semi-naive step.

**The FGH-rule settles a shape.** `G(F(X)) = H(G(X))` makes "iterate then project" equal "project
then iterate", and read as source-step / summary-abstraction / summary-step it is precisely
Ergodis's explicitly-undischarged obligation that a leaf correctly lowers the source model. Three
passes have now reached this square by three routes — operad algebra homomorphisms, model-validity
of a Lawvere theory's relations, and this — so the shape is settled and only the discharge is open.
The FGH paper discharges it by counterexample-guided inductive synthesis with z3, and Ergodis
already holds the counterexample corpus C1091 specifies.

**What Ergodis has that this line does not:** an independent certificate for optimality with
exclusion coverage, admission as an unforgeable handle, and the separation of provenance, search
mode, coverage and verification. Nothing in the RelationalAI line produces an artifact a separate
checker consumes to establish that an answer is optimal and cheaper candidates were excluded — the
FGH-rule verifies program *equivalence*, and egglog produces equality *explanations*, which are
different objects. **What Ergodis lacks and should take:** worst-case-optimal join evaluation with
the AGM bound, a convergence theory for recursion over an arbitrary algebra, semi-naive evaluation
with aggregation inside recursion, and a synthesis-based optimiser for recursive programs.

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

## 3. Mapping onto Ergodis

Ergodis object labels (O1–O9) and absorption rows are those of the C1150 and C1151 part B passes.
Inferences here are mine unless attributed.

### 3.1 The single most useful transfer: Ergodis's min-plus algebra is 0-stable

The C1151 pass established, by reading OpenFst's `reweight.h`, that **weight pushing requires
`Divide`**, and therefore that Ergodis's saturating `u32::MAX` sentinel blocks it. `datalog°`
supplies the complementary fact, and it goes the other way.

Ergodis's summary algebra is min-plus over `u32` with `u32::MAX` as the absent element and `0` as
the multiplicative identity, and **all costs are non-negative**. Apply the stability definition
directly. For any element `u`:

```
u^(0) = 1                = 0
u^(1) = 1 ⊕ u = min(0, u) = 0      because u ≥ 0
```

so `u^(0) = u^(1)`, every element is **0-stable**, and the semiring is 0-stable. By the third
clause of Theorem 1.2, **every `datalog°` program over Ergodis's summary algebra converges in `N`
steps**, where `N` is the number of ground IDB tuples — polynomial in the input. This is the same
reason the authors give for `Trop₊`, and it is worth noting that they also observe `Trop₊` **fails
the ascending chain condition** while still converging, so the usual sufficient condition would
have given the wrong answer here.

The saturation does not interfere: the stability computation only ever compares `0` against
`min(0, u)` and never forms a saturating sum. So the two algebraic requirements come apart
cleanly, and this is the finding I would lead with:

| Operation                       | Requirement      | Ergodis's bounded min-plus  |
|---------------------------------|------------------|-----------------------------|
| Weight pushing (OpenFst)        | division         | fails, saturating sentinel  |
| Fixpoint convergence (datalog°) | stability        | holds, and is 0-stable      |
| Semi-naive delta (datalog°)     | a comparison     | holds                       |

The practical consequence: **Ergodis does not need to fix the sentinel to get a fixpoint
semantics with a convergence bound**; it needs to fix the sentinel only for canonicalisation by
weight pushing. Those are separable pieces of work, and C1151's row 3 sequencing should be read
with that separation in mind.

### 3.2 Ergodis's summary-transition verifier is already a semi-naive step

`ergodis-verify::min_plus_transition` accepts a snapshot and then a sequence of deltas; each delta
names one real leaf, the checker verifies the old leaf and every sibling summary and digest
against retained state, and then replaces the leaf and its path to the root. Structurally that is
exactly the semi-naive move: recompute only what changed, not the whole tree.

What `datalog°` adds is the *condition* under which that is sound for an algebra other than
min-plus. Their `⊖` is a comparison — `v ⊖ u = v` if `v < u`, else `⊥` — with the stated rationale
that a store keeps only tuples whose value is `≠ ⊥`, so `⊖` returning `⊥` means "no update
needed". Ergodis's verifier makes the same decision implicitly by comparing against retained
state. Writing the condition down as a `⊖` on the weight type is the small change that would let
the same verifier serve another algebra — which is precisely C1151's row 4
(semiring-polymorphic verifier) with one more required operation on the interface. The
`Properties()`-mask pattern borrowed from OpenFst in C1151 §5.3 gains two more bits to declare:
**stable / `p`-stable / 0-stable**, and **has `⊖`**.

### 3.3 The FGH-rule is the commuting square Ergodis's leaf-lowering obligation needs

Ergodis's `summary-transitions.md` states plainly that a successful check "does not establish …
that an initial leaf correctly lowers the source model, or that a root cost proves domain
optimality", and `CompositionShape` (C1094) "does not validate algebra, source lowering or query
preservation". C1151's row 8 proposed an operad-algebra homomorphism as the checkable form of that
obligation. The FGH-rule is the same square, arrived at from the database side and with a
synthesis procedure attached:

```
G(F(X)) = H(G(X))
```

Read `F` as one step of the source-model computation, `G` as the abstraction to the summary, and
`H` as one step of the summary-level computation. The square says exactly *the summary of a source
step equals a summary step on the summary* — which is the leaf-lowering obligation, and by
induction (their Theorem 3.1's commuting diagram) it lifts to the whole iteration. Three
independent routes have now reached this square in three passes: algebra homomorphisms over an
operad (C1151 §3.4), the model-validity condition on a Lawvere theory's relations (C1151 §4.2),
and the FGH-rule here. I regard that as settled: **the square is the right shape for the
obligation, and the open question is only how to discharge it.**

The FGH paper answers the how in a way Ergodis can copy directly. Finding `H` given `F` and `G` is
counterexample-guided inductive synthesis with z3 as the verifier and the counterexample database
driving the next round. Ergodis already has the two halves this needs: a rejection-fixture corpus
(C1091's ten fixtures) that is exactly a counterexample database, and a family of small finite
models where a candidate `H` can be checked exhaustively rather than by SMT.

### 3.4 What a tensor-logic or Rel program compiled to an Ergodis plan would need

Taking the Macready proposal seriously — tensor logic as external syntax, compiled through
categorical machinery into something Ergodis executes — here is what the compilation target must
carry that the source language does not currently declare.

1. **A semiring (POPS) parameter.** Tensor logic's `=` defaults to `+ =` over the reals, with
   `max =` and `avg =` as sugar. An Ergodis plan needs to know *which* `(⊕, ⊗, ⊥, 1, ⊑)` it is
   executing in, because the admission checks, the readout semantics and the certificate all
   depend on it. `avg =` is not a semiring operation and would have to be rejected at the boundary
   or desugared into a pair (sum, count) — which is itself the tupling construction from
   Little–He–Kayas recorded in C1150.
2. **A recursion/fixpoint contract with a stability declaration.** Tensor logic's forward chaining
   stops "when no new elements can be computed **or a stopping criterion is satisfied**", and the
   language is Turing-complete, so nothing can be promised in general. An Ergodis plan must carry
   either a stability witness for its POPS (giving Theorem 1.2's `N`-step or `Σ(p+2)^i` bound) or
   an explicit declaration that the result is budget-truncated and therefore not a fixpoint. This
   is the same distinction C1151's row 2 draws between saturation and a budget in `egg`.
3. **An aggregation contract separating the four semantics C1091 already separates.** `datalog°`
   makes `∃` into an `⊕`-aggregate; Ergodis's C1091 insists that accumulation along a realization,
   aggregation over alternative realizations, the objects counted, and quantification over
   information histories are four different things. A compiled tensor-logic equation says which
   `⊕` but not which of the four it means, and C1091's rejection fixture 3 (overlapping repairs at
   independent survival 1/2 giving 3/8, not 1/2) is precisely a program that would type-check as an
   einsum and be wrong.
4. **An exactness statement that is not a step function.** Tensor logic's reliability argument is
   a probability bound falling with embedding dimension, recovering exact deduction only at
   `T → 0`. Ergodis's glossary forbids an unqualified "exact". A compiled plan would have to
   declare which of the two regimes it is in, and a plan derived from an embedded-space program
   cannot be labelled ProofGenerating.
5. **Negation handled explicitly.** Tensor logic has none. `datalog°` offers the `THREE` POPS and
   Fitting's semantics as one principled route. Any Ergodis-facing surface that admits negation
   needs to pick one and say so.

### 3.5 What Ergodis has that this line lacks

Stated as mine, and stated narrowly enough to be checkable.

**Independent certificates for optimality with exclusion coverage.** `datalog°` computes a least
fixpoint and the fixpoint is the answer; correctness rests on the implementation being right. The
FGH-rule verifies *program equivalence* with z3, and egglog/`egg` can produce equality
*explanations*, but nothing in this line produces an artifact a separate checker consumes to
establish "this is the optimum and every cheaper candidate was excluded". That is exactly
Ergodis's representative-catalog contract and the VeriPB-style `red`-rule certificate of C1151's
row 6 — and note that the VeriPB line is a *different* community (Gocht, Nordström, Gleixner) from
this one.

**A separation between origin, search mode, coverage and verification.** Ergodis's glossary keeps
provenance, search mode (ProofGenerating versus Heuristic), coverage (CompleteFiniteProblem versus
RestrictedOnly) and verification as independent dimensions, and forbids a generic `verified` flag.
Neither tensor logic nor Rel has an analogue; a Rel relation is computed or it is not.

**Admission as an unforgeable handle.** Ergodis's `Admission` wraps a verified restriction and "a
receipt … deserializing it cannot create `Admission`". The Datalog line's analogue of admission is
type-checking plus, at best, an SMT proof obligation discharged at compile time.

**Exact search with declared exclusion.** C1016's provenance rule — exact computational
enumerations grant negative coverage, heuristic predicates never do — has no counterpart here. A
Datalog fixpoint is complete over the derivable facts by construction, which is a different and
weaker statement than "the search space was exhausted".

What Ergodis does **not** have, and this line does: worst-case-optimal join evaluation with the
AGM bound, a convergence theory for recursion over an arbitrary algebra, semi-naive evaluation
with aggregation inside recursion, and a synthesis-based optimiser for recursive programs. Those
are the four things worth taking.

### 3.6 Which C1151 rows this touches

| C1151 row                       | Touched by                | Effect                               |
|---------------------------------|---------------------------|--------------------------------------|
| 4 semiring-polymorphic verifier | datalog POPS, Theorem 1.2 | add stability and a minus to the API |
| 3 sentinel then weight pushing  | the 0-stability result    | decouples fixpoint from the sentinel |
| 2 weak term acyclicity          | Suciu, Wang, Zhang        | unchanged; egglog is its system form |
| 5 coalgebraic partition refine  | egglog instance + rebuild | congruence closure is the union-find |
| 8 operad algebra homomorphism   | the FGH-rule              | same square, with CEGIS to discharge |
| 6 VeriPB omission certificate   | nothing in this line      | remains Ergodis's differentiator     |

## 4. Absorption table

Same six fields as the C1151 pass plus the requirement column (`neither` = no gradient, no neural
network, no GPU). Ordered by value per unit of effort. Detail under the index, because several
fields do not compress to a cell.

| #  | Candidate                               | Ergodis object      | Requirement  | Confidence |
|----|-----------------------------------------|---------------------|--------------|------------|
| 1  | Declare stability on the weight type    | O5 verifier, O4     | neither      | high       |
| 2  | Semi-naive delta with an explicit minus | O5 summary deltas   | neither      | high       |
| 3  | FGH square for the lowering obligation  | O5 leaves, C1094    | neither      | medium     |
| 4  | POPS as the plan's algebra parameter    | O1 plans, O4        | neither      | medium     |
| 5  | CEGIS plus counterexample corpus        | O8 Evolve, O9       | neither      | medium     |
| 6  | Free Join as the join inner loop        | O1 execution        | neither      | low        |
| 7  | egglog as one fixpoint engine           | O2, O3, O8          | neither      | low        |

### Row detail

**Row 1 — declare stability on the weight type** (Abo Khamis–Ngo–Pichler–Suciu–Wang, Theorem 1.2).
*Expected benefit:* a convergence bound for any iterative computation over Ergodis's cost algebra,
turning "the loop terminates because we budgeted it" into "the loop terminates in `N` steps because
the algebra is 0-stable". *Cheapest experiment:* add `stable`, `p_stable(p)` and `zero_stable` to
the properties mask C1151's row 4 already proposes, prove 0-stability for the bounded min-plus
weight by the two-line argument in §3.1, and assert it in a test. *Measured gate:* the proof is
mechanical and the test is a unit test; the real gate is that an existing iterative arm, run to a
fixpoint rather than to its budget, terminates within the `N`-step bound on the retained fixture
set — and if it does not, the discrepancy identifies where the implemented algebra differs from
the declared one. *Requirement: neither.* *Confidence: high* — the theorem is published and the
0-stability check for non-negative min-plus is immediate.

**Row 2 — semi-naive delta with an explicit `⊖`** (same paper, equations (6)–(7)). *Expected
benefit:* Ergodis's leaf-delta verification generalises past min-plus without needing division,
which is what blocks weight pushing. *Cheapest experiment:* add `⊖` to the weight interface with
the contract "return `⊥` when no update is needed", implement it for the bounded min-plus as the
strict-improvement comparison, and route the existing `verify_delta_for_leaf` path through it.
*Measured gate:* byte-identical acceptance and rejection on every current delta fixture, plus a
constructed fixture where the new value ties the old (the `v ≥ u` branch) that must produce no
update. *Requirement: neither.* *Confidence: high* — it formalises what the verifier already does.

**Row 3 — the FGH square for the leaf-lowering obligation** (Wang–Abo Khamis–Ngo–Pichler–Suciu,
Theorem 3.1). *Expected benefit:* converts the explicitly-undischarged obligation that "an initial
leaf correctly lowers the source model" into a commuting square checkable on instances, and by
their induction argument the square lifts to the whole iteration rather than to one step.
*Cheapest experiment:* for one bounded family, write `F` (source step), `G` (leaf abstraction) and
`H` (summary step) explicitly and check `G(F(X)) = H(G(X))` exhaustively on a small finite model.
*Measured gate:* the square holds on every instance of the small model, and a deliberately wrong
`G` breaks it. *Requirement: neither.* *Confidence: medium* — the shape is now confirmed from
three directions, but exhaustive checking on small models is evidence and not discharge, and
scaling the check to a real family is the open part.

**Row 4 — POPS as the plan's algebra parameter** (the `datalog°` language definition). *Expected
benefit:* a compiled plan states which `(⊕, ⊗, ⊥, 1, ⊑)` it executes in, so readout semantics,
admission and certificates can all reference it instead of assuming min-plus; and it is the piece
a tensor-logic or Rel front end would have to supply. *Cheapest experiment:* write the POPS
interface and instantiate it for the three algebras Ergodis already uses somewhere (Boolean for
GF(2) admission, bounded min-plus for summaries, and the counting semiring for C1093's count
readout), then check that each existing readout is expressible. *Measured gate:* every existing
readout is expressed without a special case, and any readout that needs one is a finding —
specifically, whether C1093's count readout is the min-cost count or the all-solutions count, the
question C1150 left open. *Requirement: neither.* *Confidence: medium* — the abstraction is well
specified, but whether Ergodis's readouts actually factor through it is unknown from documentation.

**Row 5 — CEGIS with the rejection-fixture corpus as the counterexample database** (the FGH paper's
implementation). *Expected benefit:* Evolve gains a way to *search for* a preservation-contract
witness rather than only to check a proposed one, with the search driven by counterexamples it
already collects. *Cheapest experiment:* take one C1091 rejection fixture, treat it as the seed
counterexample, and run a bounded enumerative search for an `H` satisfying the row-3 square on the
small finite model. *Measured gate:* the search either finds an `H` that survives all ten C1091
fixtures, or reports the fixture that kills each candidate — both outcomes are usable.
*Requirement: neither.* *Confidence: medium* — CEGIS is standard and Ergodis has the corpus, but
the synthesis space for representation contracts is much less structured than for query rewrites.

**Row 6 — Free Join as the join inner loop** (Wang–Willsey–Suciu; Ngo–Ré–Rudra for the bound).
*Expected benefit:* if Ergodis ever evaluates a relational front end (tensor logic, Rel) as a
plan, this is the state of the art for the inner loop, it is a Rust library, and the AGM bound
gives a complexity statement rather than a heuristic. *Cheapest experiment:* none yet — this is
gated on Ergodis actually having a multi-relation join workload, which it does not today.
*Measured gate:* when attempted, output size against the AGM bound `Π_F |R_F|^{x_F}` for the
query's fractional edge cover, and wall clock against a binary-join baseline. *Requirement:
neither.* *Confidence: low* — excellent work, no current Ergodis workload.

**Row 7 — egglog as one fixpoint engine** (Zhang et al.). *Expected benefit:* one system providing
congruence closure, lattice-valued analyses and extraction, which is C1151's rows 2, 5 and 7
served by a single engine; and the two motivating failures it fixes (unsound rewrites lacking
side-condition analyses; ad-hoc union-find in a Datalog analysis) are both failure modes Ergodis
could reach. *Cheapest experiment:* express one `FeatureDag` identity set plus its overflow side
conditions as an egglog program and compare the saturated result against the current simplifier.
*Measured gate:* the saturated e-graph's extracted term is never worse than the simplifier's on
the corpus, and every rewrite with a side condition is guarded by an analysis rather than applied
unconditionally. *Requirement: neither.* *Confidence: low* — adopting an external fixpoint engine
conflicts with Ergodis's zero-allocation hot-loop discipline and its one-engine direction; the
value is as a reference semantics and an offline analysis tool, not as a shipped dependency. Note
also footnote 4 of the egglog paper: `:merge` may be non-monotone, so the fixpoint is not
guaranteed in general — the same gap as tensor logic's stopping criterion.

## 5. What to ask Macready

Each question is grounded in something a source actually defines, with the source named so the
question is answerable rather than rhetorical.

1. **Which POPS, and is it stable?** Tensor logic's `=` defaults to `+ =` over the reals with
   `max =` and `avg =` as sugar and no algebraic laws stated. `datalog°` makes the algebra explicit
   and Theorem 1.2 ties termination to stability of `P ⊕ ⊥`. *What semiring or POPS does the
   compiled artifact execute in, and do you have a stability witness for it?* `avg =` in particular
   is not a semiring operation.

2. **What is the recursion contract?** Tensor logic is Turing-complete (via recurrent networks;
   the slides say so explicitly, adding "But Datalog is not"), and forward chaining stops when
   nothing new can be computed **or a stopping criterion is satisfied**. *Is the compiled fragment
   restricted to one where the first disjunct is guaranteed, and by what criterion?* Weak term
   acyclicity (Suciu–Wang–Zhang) and `p`-stability (Theorem 1.2) are the two published answers.

3. **Which direction is the subset claim?** Tensor logic's core identification — a Datalog rule is
   a join then a projection, and that is an einsum — is `datalog°` at the Boolean semiring, and
   Rel's own teaser is `def MatrixMult[{A},{B},i,j] : sum[ [k] : A[i,k]*B[k,j] ]`. But tensor logic
   also has embedding-space reasoning and gradients, which are not in the Rel or `datalog°` papers.
   *Is "subset" meant about the core language only, and is the embedding-space layer in or out of
   the compilation target?*

4. **Where does Abbott's categorical compilation sit relative to the FGH-rule?** The FGH-rule is a
   commuting square `G(F(X)) = H(G(X))` whose discharge is CEGIS plus z3. That is a
   naturality/algebra-homomorphism condition. *Is the categorical layer doing the same job — proving
   that an abstraction commutes with a step — and if so, is it discharging it by construction or by
   verification?* If by construction, that is strictly better than CEGIS and worth knowing.

5. **What is the story for negation?** Tensor logic has none. `datalog°` gives one principled
   route: the `THREE` POPS with Fitting's three-valued semantics. *Is negation in scope, and if so
   which semantics?*

6. **What is checkable afterwards?** Tensor logic's reliability argument is a probability bound
   falling with embedding dimension, exact only as `T → 0`. `datalog°` computes a least fixpoint
   whose correctness rests on the implementation. Neither produces an artifact an independent
   checker consumes. *Is a certificate in scope for the compiled pipeline, and at what granularity
   — equality of two programs (which the FGH-rule and egglog can do), or optimality of an answer
   with exclusion coverage (which nothing in this line does)?*

7. **Is aggregation-in-recursion intended, and which of the four aggregation semantics?**
   `datalog°`'s whole point is that aggregation inside recursion is what pure Datalog cannot do,
   and their semi-naive extension is what makes it efficient. Ergodis's C1091 separates
   accumulation along a realization, aggregation over alternatives, the physical objects counted,
   and quantification over information histories. *An einsum says which `⊕`; what says which of the
   four?*

8. **Sparse/dense split, or Tucker everywhere?** Domingos's §6 offers both: hand sparse subtensors
   to a query engine and dense ones to a GPU, or make everything dense by Tucker decomposition at
   a controlled error probability. *Which one is the plan, and if Tucker, is the error probability
   acceptable given that the output is meant to feed a verifier?*

9. **Which implementation is the reference?** The tensor logic paper describes no implementation
   and names CUDA as future work. Free Join is a standalone Rust library; egglog is a working
   system; Rel is in production as a Snowflake co-processor. *Which of these, if any, is the
   execution target — and is anything running today?*

## 6. Coverage and search record

### Read-depth tally

**Eleven named sources.** Two at **full text**: the `tensor-logic.org` landing page (which is a few
sentences) and Domingos's tensor logic paper, read end to end. Eight at **partial**, six of those
at algorithm depth with the specific definitions, theorems and algorithms this report uses read in
full and proofs read by statement: `datalog°`, the FGH-rule paper, the Generic Join survey, Free
Join, egglog, and Rel — plus Suciu–Wang–Zhang and Green–Karvounarakis–Tannen carried in at the
depths recorded in the C1150 and C1151 passes without re-reading. One at **partial** as a
supporting artifact: Domingos's slide deck.

No verdict here depends on the absence of prior work. This is a positioning and reading study, not
a novelty audit.

### Identifier resolution

Every arXiv identifier and DOI below was **resolved before fetching**, from the arXiv abstract page
or from the venue's own landing page, never written from memory. This is a direct response to the
C1151 pass, in which three guessed identifiers all turned out to be wrong papers. The resolutions:

- `arXiv:2510.12269` — from the link on `tensor-logic.org`, confirmed against the arXiv abstract
  page (title, single author, v3, 16 Oct 2025, DOI 10.48550/arXiv.2510.12269).
- `arXiv:2105.14435` — from search results naming the PODS 2022 paper and its DOI
  10.1145/3517804.3524140; author list and affiliations then taken from the PDF's own title block.
- `arXiv:2202.10390` — resolved from the arXiv abstract page (title, five authors in order, v1,
  21 Feb 2022).
- `arXiv:2301.10841` — from search results, confirmed against the PDF title block (three authors,
  all University of Washington, DOI 10.1145/3589295).
- `arXiv:2304.04332` — from search results; the eight authors and their affiliations taken from
  the PDF's own author block.
- `arXiv:2504.10323` — resolved from the arXiv abstract page (fifteen authors in order, v2,
  24 Apr 2025, DOI 10.1145/3722212.3724450); affiliations from the PDF title block.
- `arXiv:1310.3314` — from search results against the dblp and ACM records (SIGMOD Record 42(4),
  pp. 5–16, DOI 10.1145/2590989.2590991).

### Cache additions

New keys: `arXiv:2510.12269`, `domingos-tensor-logic-slides`, `arXiv:2105.14435`,
`arXiv:2202.10390`, `arXiv:2301.10841`, `arXiv:2304.04332`, `arXiv:2504.10323`, `arXiv:1310.3314`.
Reused without re-fetching: `arXiv:2501.02413`, `10.1145/1265530.1265535`. SHA-256 values are
quoted in each source's entry. Fetches went through
`/tmp/persistent/tavis/lit-search/fetch_c1151b.sh`, which refuses any download whose magic bytes
are not `%PDF`. Nothing was left in the RAM-backed scratchpad.

### Load-bearing queries, verbatim

Web search only; every query returned results, so an empty result was never mistaken for an error.

1. `"Convergence of Datalog over (Pre-) Semirings" Khamis Ngo Pichler Suciu Wang arXiv`
2. `"Free Join" "Unifying Worst-Case Optimal and Traditional Joins" Wang Willsey Suciu arXiv`
3. `egglog "Better Together: Unifying Datalog and Equality Saturation" Zhang Wang Willsey Tatlock
   arXiv PLDI`
4. `RelationalAI "Rel" language paper relational knowledge graph Aref declarative SIGMOD arXiv`
5. `"Optimizing Recursive Queries with Program Synthesis" Wang Suciu SIGMOD arXiv identifier`
6. `Ngo Re Rudra "Skew Strikes Back" "new developments in the theory of join algorithms" arXiv
   identifier SIGMOD Record`

Two page fetches: `https://tensor-logic.org` and the arXiv abstract pages for `2510.12269`,
`2202.10390` and `2504.10323`.

### Not covered

- **The tensor logic YouTube keynote and the `.pptx` deck** were not watched or opened; the `.pdf`
  slide deck was read instead, at the depth recorded.
- **No tensor logic implementation was examined**, because the paper describes none and links
  none. If one exists outside the paper I did not find it.
- **No Rel implementation, documentation site, or Snowflake integration was examined** — only the
  SIGMOD paper. Rel's production behaviour may differ from the paper's presentation.
- **The `datalog°` proofs (§§2–7) were not read**, so every convergence claim here is quoted as the
  authors state it and not independently checked. The one thing I *did* check is the 0-stability of
  Ergodis's bounded min-plus, which is a two-line application of their definition and is my own
  derivation, marked as such in §3.1.
- **Free Join's and the FGH paper's reported speedups are unverified**, read from abstracts and
  introductions.
- **Semantic and semiring-based query optimization** beyond the FGH-rule was not covered; the
  `datalog°` paper refers to "a companion paper [81]" for an optimisation technique subsuming magic
  sets, which is the FGH paper I did read, but the broader semantic-optimisation literature was out
  of budget. Recorded as an open gap.
- **zbMATH Open, OpenAlex, Crossref and Semantic Scholar were not queried.** MathSciNet: NOT
  COVERED (institutional authentication). Google Scholar: NOT COVERED (blocks automated access).
- **No Ergodis source code was read.** The mappings in §3 rest on `summary-transitions.md`, the
  glossary, and the C1091 report, all of which may lag their implementations. In particular, the
  claim that Ergodis's summary weights are non-negative `u32` with `u32::MAX` as the absent element
  comes from `summary-transitions.md`; the 0-stability conclusion depends on it and should be
  re-checked against the code before anything is built on it.

