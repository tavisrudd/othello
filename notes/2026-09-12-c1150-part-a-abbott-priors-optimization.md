# C1150 part A — Abbott's categorical programme, non-neural search priors, and categorical optimization

**Date:** 2026-09-12. **Lane:** ergodis. **Disposition:** reading and positioning study. No code
changes, no edits under `~/src/ergodis*`. Prior art informs; it never gates Ergodis product work.

## Opening summary

**Twenty-one named sources; two read at full text.** The two are Abbott & Zardini's
*Weaves, Wires, and Morphisms* (arXiv:2604.07242), the primary source this task named, and their
*Diagrammatic Negative Information* (arXiv:2404.03224), which the task did not name and which turned
out to matter more. Fourteen further sources were read partially, with the sections relied on stated
at each; five were consulted only as abstract or metadata, and one of those — Abbott, Xu & Maruyama's
*Category Theory for Artificial General Intelligence* — could not be obtained at all. Full ledger and
coverage in § 8.

**Headline.** The Abbott–Zardini programme's celebrated output is a way of writing down deep-learning
architectures so that broadcasting is unambiguous and the term compiles to several backends. That
output is a **representation and rewriting discipline**, not a search prior, and its quantitative
content is specific to GPU memory hierarchies. What transfers to Ergodis from that side is the
deliberate split between a semantic layer and a non-faithful algorithmic layer, so that "these two
plans compute the same answer at different cost" is derivable rather than documented.

The larger finding is elsewhere in the same research group. Abbott & Zardini's *Diagrammatic Negative
Information*, and the Censi–Frazzoli–Lorand–Zardini **nategories** paper it builds on, are about
composable impossibility: bans, lower bounds, and certificates of optimality. Their opening statement
of the problem is Ergodis' own: an optimal solution is a feasible solution together with a proof that
nothing better exists, and the second half has no categorical home in ordinary category theory because
a ban propagates backwards through composition. They also report a failed attempt worth more than
most successes here — you cannot put refusals in a separate structure and compose them among
themselves, because negative information composes only with positive information as a catalyst. That
lands directly on C1091 rejection fixture 9 (a feasible witness with unverified exclusion of cheaper
candidates is an upper bound, not a certified optimum) and on C1091's own nomination of
failure-to-admit-a-query as the cheapest available extension.

**What I would do with it.** Absorption rows 1, 2 and 3 in § 6 are one slice with one implementation:
an expansive ban over a preorder, with a composition rule. It gives the optimality certificate a
type, makes an admission refusal propagate instead of being rediscovered, and — the part that could
pay for itself in measured work — supplies the missing law relating a bound on a composite to bounds
on its parts, which `ordered_resource` does not currently have and which is what makes admissible
lower bounds usable inside an exact search.

**On the non-neural question the task posed.** What survives the removal of gradients and networks is
substantial and specific: monad and endofunctor algebras as structural constraints (generalising
"constant on classes" beyond equivalence relations); the polynomial span with a semiring as the
normal form of a dynamic program; bag-valued aggregation as the discipline that mechanically prevents
the overlapping-repair error; and closure theorems of the Fusion-Theorem shape as the crossing law
C1091 says is missing. What does not survive is the derivative. And there is a real hole: **no
categorical account of regularization or model-complexity control exists** that I could find, so
§ 5.6 proposes three readings of what one would mean for an exact engine and marks them as mine.

---

## 1. Ergodis objects a categorical lever could touch

Extracted from `notes/ergodis-architecture-context.md`, `~/src/ergodis/docs/glossary.md`, and
`notes/2026-09-07-c1091-core-semantic-contracts.md` (all read at full text as internal context, not
as literature sources).

| Ergodis object | What it is, in Ergodis' own vocabulary | Why a categorical structure could bite |
|---|---|---|
| Model / space / signature | Immutable validated mathematical structure with named carriers, scalar domain, basis/coordinate maps, resource identity. Equal dimensions do not authorize composition (C1091 §"Core types before UI shapes"). | This is literally a request for objects-with-morphisms rather than shapes: the "matrix from A to B vs C to D" rejection fixture is a typing discipline that a category supplies natively. |
| Query / target / objective | A question about a model: target (what is reconstructed/decided), objective (how admissible candidates are ordered, with units, direction, composition rules), observation contract, update contract. | Objectives with declared accumulation/aggregation/order are monoid- and semiring-shaped; `ordered_resource` already validates finite ordered monoids and Pareto fronts. |
| Plan compilation | Source → logical IR (PlanSpec/PlanOp) → physical plan (CompiledPlan, resolved fields, specialized ops). One model supports several plans for different questions, readouts and evidence needs. | Compilation is a functor-shaped object: a structure-preserving map from a specification category to an implementation category, with the preservation obligation as the functor law. |
| FeatureDag lowering | Feature IR — FeatureDag terms and declared evaluation semantics; overlaps the plan language but is not identical to it. | A DAG of typed terms with declared semantics is a free (symmetric monoidal) category presentation; lowering is the induced functor out of the free object. |
| Quotient / representative catalog / context | `ValidatedQuotient` and admitted observables (C1095): readout reuse with concrete distinguishing-pair rejection over a finite declared context. Representative catalogs preserve a lower envelope *collectively*, not witness-by-witness. Decision covers need not be equivalence relations. | Quotients are coequalizer-shaped; catalogs are not, and that distinction is exactly what C1091 corrects ("coarsest quotient is not a universal representation objective"). A categorical account has to handle both the quotient and the non-quotient case. |
| Admission checks | Permission to use a candidate for a particular problem and scope. Current core `Admission` wraps an opaque verified restriction; receipts identify replay material but cannot mint an `Admission`. Query admission = checking a representation supports a question. | Admission is a proof-carrying typing judgment. A categorical framing would be: admitted handles are morphisms in a category whose composition is only defined when contracts compose. |
| Certificates and independent verification | Independent leaf crate, no solver/host dependency, no generic trusted flag. Certificates compose only through checked rules; a proof transformer must establish the new claim's hypotheses. | Certificate composition is exactly a composition law with side conditions — a partial/fibred category, or a category of claims with certificate morphisms. |
| Campaigns / runs / lineage | Campaign = investigation over runs, with goals, budgets, lineage DAG, typed predecessor/fork/replay links, logical budget vs physical work. | Lineage is a free category on a graph; budgets are a graded/monoidal accounting. |
| Repair schedules and kicks | `RepairModel → RepairPlan → BudgetQuery` (C1093): compile once, admit budget changes, count/threshold/witness readouts. | Prepare-once/query-many with admitted parameter changes is a parametric (Para-like) or graded-comonad shape: the plan is a morphism parameterized by budget. |
| Evolve proposal ordering | Bounded WASM Evolve: shared ranked Rust/WASM proposals, independent family checkers, checked capacity bounds, learned-only reruns, retained late proposals as future knowledge. Evolve's search domain includes questions and designs, not only algorithms. | Ranking a proposal stream is a search prior. Compositional structure on the proposal space is what turns a flat ranking into a structured generator. |
| Preservation contracts (plural) | The strongest architectural consequence of C1091: different representations preserve different questions under different contexts and quantifiers; the representation carries the contract that licenses its use. | "Which questions does this map preserve" is the defining question of functorial semantics. This is the single strongest categorical hook in the whole system. |
| Rejection fixtures | Ten fixtures that must outlive every implementation (C1091 §"Rejection fixtures"), e.g. overlapping repairs `{1,2}`/`{2,3}` at survival 1/2 give 3/8 not 1/2; pairwise ε-closeness is not transitive. | Several are exactly the failure of a would-be functor/monoidal structure to exist. They are a ready-made test battery for any categorical claim: a proposed structure that "proves" fixture 3 or 10 is wrong. |

### What Ergodis already has that resembles categorical machinery

Recording this up front so the sweep does not propose what exists. From the architecture context
table and C1091:

- `ordered_resource.rs`: finite ordered monoids with validated laws, Pareto fronts, frozen query plans.
- `observational.rs`: typed finite deterministic presentations, declared contexts, exact contextual
  minimization, certificates.
- `OpenProblem`/`RetainedTree` (private `src/open_problem.rs`): a context-bearing compiled problem
  with a **composition/identity/readout core** plus optional Normalized/Tensor/Reconstruct problems,
  and matrix, function, monoid-index and semiring-window adapters. My inference: this is already a
  category-with-tensor in all but name — composition and identity are the stated core.
- `CompositionShape` (C1094): validated leaf count, padded capacity, node count for a retained binary
  composition tree; establishes storage geometry, explicitly *not* algebraic laws.
- `ValidatedQuotient` (C1095): readout reuse with distinguishing-pair rejection over a finite context.

The gap C1091 names is not "no abstractions" but that **local abstractions' semantic assumptions do
not cross family, compiler, verifier and client boundaries**. That is the target a categorical lever
must hit to be worth anything here.

---

## 2. Literature method and coverage

*(coverage statement and verbatim query log are consolidated in § 8 at the end of this file; each
source below carries its read-depth field inline.)*

---

## 3. Primary source: Vincent Abbott

### 3.1 Abbott & Zardini, *Weaves, Wires, and Morphisms* (arXiv:2604.07242)

**Citation (from the consulted source).** Vincent Abbott and Gioele Zardini, "Weaves, Wires, and
Morphisms: Formalizing and Implementing the Algebra of Deep Learning", *Transactions on Machine
Learning Research*, 08/2026; reviewed on OpenReview `forum?id=GiO8eom0jD`. Both authors at the
Laboratory for Information and Decision Systems, MIT. Funding acknowledged: DARPA Award
D25AC00373 and AFOSR agreement FA9550261B038.

**Read depth: full text.** Version read: arXiv:2604.07242v3 [cs.LG], 12 Aug 2026, which carries the
TMLR 08/2026 published header. Accessed by `curl` from `https://arxiv.org/pdf/2604.07242`, cached as
key `arXiv:2604.07242`, sha256
`8ff8f030fd155feaf428c5b76573e7b7451c5e737977ee568c972ead0d6102f7`, 35 pages, `pdftotext` extraction.
Sections read: 1 (Introduction), 2 (Encoding Mathematics, Defs 1–4), 3 (Categories, Defs 5–6, §3.1
Implementing Categories), 4 (Array-Broadcasted Category, Defs 7–14, Lemma 1), 5 (Key Operations),
6 (Results), 7 (Future Work), References, Appendix A.1 (proof of Lemma 1). Appendix B is a results
notebook of rendered figures and code listings; figure images are not recoverable from the text
extraction, so figure content is characterised from its captions only.

**Verified claim summary.** The paper's stated gap is that deep-learning architectures are
communicated informally, and that the specific missing formal notion is **broadcasting** — how an
operation is extended over additional axes. The paper's own worked ambiguity: a SoftMax written
`R^{nx} → R^{nx}` does not say whether `n` or `x` is the broadcast axis versus the target axis, and
without that the expression is "technically ambiguous and therefore impervious to robust
mathematical analysis". Their construction has four layers:

1. A **constructed term system**: a set of nominal mathematical entities Γ with core properties
   `π_k`, plus a term set G with an interpretation function `V_G : G → Γ`, such that evaluating
   inside the term system agrees with evaluating after interpretation (Defs 1–2). Core properties
   are implemented either **contravariantly**, as *construction rules* where a term remembers the
   inputs it was built from with a recovery function satisfying `T̂_c ⨟ T_c = Id` (Def 3), or
   **covariantly**, as *root terms* carrying the data needed to expose their properties natively
   (Def 4). Placeholder terms with unique identifiers carry open axis sizes (§2.4).
2. A **monoidal product category with rearrangements** (Defs 5–6). Rearrangements are finite
   functions `µ : I → J` classified by count — neutral (swap), increased (copy), decreased (delete)
   — and a designated subset is *natural*. Which rearrangements are natural is the paper's carrier
   of semantic content: copying is natural in `Set` but not in `Stoch`, because copying a die roll's
   result differs from rolling two dice.
3. A **monoidal array category** `[C; I]` (Defs 7–10). Arrays `[X; P]` are introduced as *synthetic
   objects* isomorphic to `Π_{p ∈ El(P)} X` via a join/separator isomorphism pair, deliberately
   using only the monoidal product structure rather than hom-functors. The paper states the reason
   explicitly: the hom-functor route needs Cartesian closure, and `C(R,R)` is unmeasurable, which
   makes a probabilistic or computational reading intractable. Batch lift `[f; P]` and reindexing
   `[X; η]` are both compositional (Lemma 1: `[f ⨟ g; P] = [f;P] ⨟ [g;P]`, `[X; ρ⨟η] = [X;η] ⨟
   [X;ρ]`), and they commute past each other — "Yoneda sliding" — **only** when `η` is natural or
   `f` is deterministic. Appendix A.1 proves this.
4. **Weaves** (Def 11): tags on each indexing object marking it as tiled (front) or target (back),
   which integrates indexing information into the operation rather than hanging it off to the side.
   The concrete instantiation takes `B = BorelStoch` (standard Borel spaces, Markov kernels) as base
   and `A` = axes with finite affine transformations `η(x) = Λ_η·x + v_η` as the indexing category,
   then layers `Para` on top for learned weights, then an algorithmic layer `Alg` with a functor
   `F : Alg → Para([B;A])`.

Deliverables the paper claims and demonstrates: mirrored Python (`pyncd`) and TypeScript (`tsncd`)
implementations; autoalignment of axis sizes framed as finding functors `F_f, F_g` unifying the
intermediate object; configuration generation by scanning for free UIDs; compilation to PyTorch;
conversion to hypergraphs for rewriting; diagram rendering; and a full representation of DeepSeek-V3
including multi-head latent attention, mixture-of-experts and complex/real datatypes.

**The most load-bearing design decision, for our purposes.** The `Alg → Para([B;A])` functor is
deliberately **not** faithful. The paper says so directly: in `Alg` one may have `f₀ ≠ f₁` even
though `F(f₀) = F(f₁)`, because "optimizing implementation details lies in exploring
mathematically-equivalent yet algorithmically-distinct expressions", written `f₀ ≡ f₁`. Inserting
`[X;[1,0]] ⨟ [X;[1,0]]` cannot be reduced to the identity in `Alg` even though it is the identity
downstairs. So the semantic functor is the *equivalence oracle* and the algorithmic category is the
*search space*, and the two are kept deliberately apart.

**Categorical structure used.** Symmetric monoidal categories with explicitly declared natural
rearrangements; synthetic objects and canonical forms (a functor `mod⟨A′,η,η′⟩` that erases an
isomorphic duplicate without loss of generality); `Para` for parameterization; `BorelStoch` as a
Markov category; hypergraph presentations of symmetric monoidal terms for rewriting; a
non-faithful functor from an implementation layer to a semantic layer.

**What it buys the authors.** (i) Composition is only well-typed when shapes agree, so shape bugs
become type errors; (ii) one algebraic term compiles to several backends, and the PyTorch backend is
explicitly described as incidental rather than privileged; (iii) equivalent-but-distinct
implementations are enumerable by rewriting on the hypergraph form while the semantic functor
certifies equivalence; (iv) equivariance results fall out of sliding a reindexing through an
expression — they derive translational equivariance of convolution that way (Figure 17); (v) the
naturality side condition mechanically blocks unsound rewrites, their worked case being that
repetition does not slide past dropout.

**Ergodis objects the same structure could touch** (the mapping is **my inference**, not the
paper's):

- The split between `Alg` and `Para([B;A])` is the same split Ergodis already needs between
  **physical plan / CompiledPlan** and **logical IR / PlanSpec**, with one addition Ergodis does not
  currently state: a non-faithful functor makes "these two plans answer the same query but differ in
  cost" a *derivable* relation rather than a *documented* one. That is exactly the C1091 claim that
  one model supports several plans for different questions and readouts.
- **Naturality-as-a-declared-property** maps onto Ergodis' rejection fixtures. Fixture 3 (overlapping
  repairs `{1,2}`, `{2,3}` at survival 1/2 give 3/8, not 1/2) is, in Abbott–Zardini's vocabulary,
  precisely the failure of copying to be natural: you may not duplicate a shared resource and treat
  the copies as independent. Fixture 7 (a reused privacy mask presented as fresh) is the same
  failure. My inference: Ergodis could carry a per-operation naturality declaration and mechanically
  refuse the rewrites those fixtures forbid, instead of relying on the fixtures as regression tests.
- **Weaves/broadcasting** map onto **FeatureDag lowering**: the ambiguity Abbott–Zardini remove (which
  axis is tiled, which is target) is the same ambiguity that makes a feature-DAG term underdetermine
  its kernel. Ergodis' architecture context already insists kernels and specialized layouts must be
  preserved; a weave-like annotation is a candidate way to make the layout choice part of the term
  rather than part of the hand-written kernel.
- **Placeholder terms with UIDs and configuration generation** map onto **repair schedules and
  budget queries**: `RepairModel → RepairPlan → BudgetQuery` is compile-once/admit-budget-changes,
  which is structurally the same as building a term with open axis sizes and configuring them later.
- **Autoalignment as a functor search** maps onto **query admission**: "find functors `F_f`, `F_g`
  unifying the intermediate object, else fail" is a small, decidable, structured admission check,
  and its failure is structured output rather than a crash — which is exactly what C1091 identifies
  as the cheapest available extension ("make failure to admit a query a structured, reusable
  counterexample path").

**What does not carry over.** The paper is entirely about describing and compiling a *fixed*
architecture; there is no search, no optimization objective, and no proposal ordering anywhere in
it. Its costs live in a layer (`Alg`) whose contents are explicitly declared out of scope. So it
supplies Ergodis a **representation and rewriting discipline**, not a search prior.

### 3.2 Abbott's other work — corpus and how it was enumerated

The corpus was enumerated from OpenAlex author id `A5064852905` (ten records, of which eight are by
this Vincent Abbott; one 2011 engineering-education record and one 1988-era record share only the
surname). Cross-checked against the reference list of arXiv:2604.07242, which names the same set
plus the two software packages. **Screened set record:** 275 OpenAlex works matched
`raw_author_name.search:Vincent Abbott`; the screen ran over author display names and titles, with
the mechanical discriminator "an authorship whose `display_name` is exactly `Vincent Abbott`", which
reduced 275 to 2 seed records and then to the 10-record author listing. The remainder are dentistry,
pharmacology and genomics papers by other Abbotts and are covered by this set record, not
individually.

The corpus, oldest first:

| Work | Year | Categorical structure | Read depth here |
|---|---|---|---|
| Abbott, Xu, Maruyama, *Category Theory for Artificial General Intelligence* | 2024 | (see §3.7) | abstract/metadata only |
| Abbott, *Neural Circuit Diagrams* (arXiv:2402.05424; TMLR 2024) | 2024 | functor string diagrams, monoidal products, Cartesian/monoidal axes | partial |
| Abbott & Zardini, *Functor String Diagrams* (arXiv:2404.00249) | 2024 | functors, natural transformations, hom-functors, Yoneda | partial |
| Abbott & Zardini, *Diagrammatic Negative Information* (arXiv:2404.03224) | 2024 | nategories, preorders as 2-categories, hom-functor predicates, `DP` co-design relations | full text |
| Abbott & Zardini, *FlashAttention on a Napkin* (arXiv:2412.03317; TMLR 2025) | 2024/25 | monoidal/array categories with explicit memory hierarchy levels | partial |
| Abbott, Kamiya, Glowacki, Atsumi, Zardini, *Accelerating ML Systems via Category Theory* (arXiv:2505.09326; AGI 2025) | 2025 | neural circuit diagrams applied to spherical attention | partial |
| Abbott & Zardini, *Weaves, Wires, and Morphisms* (arXiv:2604.07242; TMLR 2026) | 2026 | see §3.1 | full text |
| `pyncd` / `tsncd` software (mit-zardini-lab) | 2026 | implementation of the above | not consulted (software, not a source) |

Coauthors as the sources show them: Gioele Zardini (MIT LIDS) on five works; Kotaro Kamiya, Gerard
Glowacki, Yu Atsumi on the AGI 2025 paper; Tom Xu and Yoshihiro Maruyama on the AGI 2024 paper. I
found no Abbott coauthorship with Bruno Gavranović or Paul Wilson; Gavranović appears only in
Abbott's reference lists. The first two Abbott papers list Australian National University; from
*Diagrammatic Negative Information* onward the affiliation is MIT LIDS.

### 3.3 Abbott & Zardini, *Diagrammatic Negative Information* (arXiv:2404.03224)

**Citation (from the consulted source).** Vincent Abbott (College of Engineering, Computing and
Cybernetics, Australian National University) and Gioele Zardini (MIT LIDS), "Diagrammatic Negative
Information", arXiv:2404.03224v2 [math.CT], 26 June 2024. The PDF is formatted as an EPTCS-style
submission ("Submitted to: Preprint"); I did not establish which venue, if any, published it.

**Read depth: full text.** Version read: arXiv:2404.03224v2, 26 Jun 2024. Cached as
`arXiv:2404.03224`, sha256 `7105a105dfdef47bb82a4d2a50a5d14f2102c9e7447cba87ea7f3de1aafa72dd`,
14 pages. Sections read: all (1 Introduction, 2 Background, 3 Diagrammatic Preorders, 4
Applications, 5 Diagrammatic Co-designs, 6 Conclusion, References). Twenty figures carry a large
share of the argument and are not recoverable from `pdftotext`; figure content is characterised from
captions and surrounding prose, so the diagrammatic derivations themselves are taken on the text's
description rather than checked.

**This is the most directly relevant Abbott paper to an exact-optimization engine**, and it is not
the one the task named. Its subject is *negative information*: what is **not** possible. The paper's
own framing of why this needs special treatment is worth stating exactly, because it is the crux. A
ban on morphisms `a → b` propagates to `b → c` and `a → c`, because those compose into `a → b`
routes, so banning the former must ban the latter — and that is backwards from ordinary categorical
composition, which composes `a → b` with things into `a` or out of `b`. The paper names Dijkstra and
A* as the everyday techniques that live on this structure.

**Verified claim summary.** Prior work (Censi, Frazzoli, Lorand & Zardini, "Categorification of
Negative Information using Enrichment", ACT 2022, arXiv:2207.13589 — cited as [4]) introduced
**nategories**: a category augmented with *norphisms* `Nom_C(a;b)` representing bans, an
incompatibility relation `i_ab : Nom × Hom → 2`, and two *inexact* composition functions
`Hom(a;b) × Nom(a;c) → Nom(b;c)` and `Nom(a;c) × Hom(b;c) → Nom(a;b)`, subject to two equivariance
conditions. Abbott & Zardini's contribution is to show this needs no new algebra: currying the
incompatibility relation turns a norphism into an ordinary morphism `C(a,b) → 2` in `Set`, and then
the two "inexact" compositions are just the two ways a morphism can act on such a predicate — either
as a hom-functor `C(a,_)` applied to a morphism, or as a natural transformation
`C(c,_) → C(a,_)` (Yoneda). They then present preorders as transforms (adding an initial object `1`
with unique identifiers `x_{x1} : 1 → x`, so `y_{1y} = x_{x1} ⨟ ≤_{xy}` and a `≤` becomes a
rewriting step rather than a 2-cell to reason about), and encode the equivariance condition as a
preorder in `2_≤` with `0 ≤ 1`. That yields, as they note, a property the original formulation did
not make explicit: **bans are expansive** — if `f` is infeasible and `f ≤ g`, then `g` is banned
too, which is precisely "limiting the search space of un-banned morphisms".

Two applications are worked:

1. **Triangle inequality → admissible heuristic.** Starting from `L(f ⨟ g) ≤ L(f) + L(g)` for a
   general `L : C(a,b) → R`, negating both sides gives an expression of the same shape as inexact
   norphism composition, but with codomain `R` rather than `2`. A lower bound `µ` on distance from
   `a` to `c` is then a norphism `(−L) ⨟ (≥ −µ) : C(a,c) → 2`, and composing with monotone
   non-decreasing morphisms inherits the inexact composition. So a bound-propagation rule is derived,
   not postulated. Their motivating examples of the triangle inequality include parsing with
   probabilistic grammars and the fact that two separately-trained network layers give worse loss
   than jointly trained ones.
2. **Co-design (`DP`).** `DP` is a category of relations between Boolean vector spaces where a
   vector `f : 1 → P` is a functionality requirement (upward-closed) and a covector `r : P → 1` is a
   resource availability (downward-closed); morphisms are design problems and composition is relation
   contraction, with `∨` for addition and `∧` for multiplication, so every morphism is automatically
   monotone non-decreasing. Their result: because `DP` is a closed category with internal homs from
   `∨`-outer-products and duals `P^op` from the monoidal unit `η_P : 1 → P^op ⊗ P`, **norphisms in
   `DP` are internal** — a ban on `P → Q` is itself a design problem `P^op ⊗ Q → 1`. So negative
   information needs no separate machinery in `DP`, and norphism composition there is *exact*, not
   inexact. Any design problem `P^op ⊗ Q → 1` can be written as a `∨`-sum of bans
   `n = ∨_i (f[i]^op ⊗ r[i])`. Physical resource conservation ("a resource pool cannot produce more
   than itself") is expressible as a norphism schema via a transposed negation, which bans everything
   offering more than the identity between a resource and itself without banning the identity.

**What it buys the authors.** A ban becomes a first-class composable object, so a constraint stated
once about one hom-set propagates automatically to every hom-set that could route around it, and in
`DP` it propagates by ordinary composition with no special rules. The expansiveness of bans over the
preorder is what makes a single stated impossibility prune a whole upward-closed set.

**Ergodis objects the same structure could touch** (**my inference**):

- **This is the natural categorical home for Ergodis' `Admission` and its refusals.** Ergodis
  currently treats a failed query admission as an "unsupported" outcome, and C1091 flags making that
  a structured reusable counterexample path as the cheapest available extension. A norphism is
  exactly that object: a refusal that is *composable*, so that "this representation does not support
  that question" propagates to every plan that could be built through it, rather than being
  rediscovered per plan.
- **Expansive bans are the exclusion-coverage argument Ergodis needs for certified optimality.**
  C1091 rejection fixture 9 says a feasible witness with unverified exclusion of cheaper candidates
  is an upper bound, not certified optimality. A norphism over the cost preorder is a certificate
  shape for the exclusion half: it bans an upward-closed set in one object, which is exactly the
  "everything at least this expensive is out" argument.
- **The triangle-inequality derivation is a template for Ergodis' bound propagation.** Ergodis'
  `ordered_resource` already supplies finite ordered monoids with validated laws and Pareto fronts;
  what it does not supply is a rule for how a bound on a composite relates to bounds on parts. The
  paper's `L(f⨟g) ≤ L(f) + L(g)` route gives that rule its categorical form, with the monotonicity
  requirement stated as the side condition. My inference: this is the cheapest genuine lever in the
  whole Abbott corpus for Ergodis, because Ergodis already has the ordered monoid and is missing
  precisely the composition-of-bounds law.
- **`DP` co-design maps onto Ergodis' budget/capability admission.** The functionality-vs-resource
  split with upward/downward closure is the same shape as `RepairModel → RepairPlan → BudgetQuery`
  (what must be achieved vs what is available), and the internal-norphism result says budget
  infeasibility can be represented in the same language as the budget query itself rather than as an
  out-of-band error.

**What does not carry over (negative information).** The paper is `Set`-and-`Rel`-shaped and has no computational content:
no algorithm, no complexity claim, no measurement. `DP` is finite Boolean-relational, while Ergodis
objectives are ordered-monoid valued, so the internal-norphism result would have to be re-established
over the actual objective algebra rather than imported. The paper also does not address *discovering*
bans, only representing and propagating given ones.

### 3.4 Abbott & Zardini, *FlashAttention on a Napkin* (arXiv:2412.03317)

**Citation (from the consulted source).** Vincent Abbott (Department of Computer Science, University
College London) and Gioele Zardini (MIT LIDS), "FlashAttention on a Napkin: A Diagrammatic Approach
to Deep Learning IO-Awareness", arXiv:2412.03317v2 [cs.LG], 19 Jan 2025. Published in *Transactions
on Machine Learning Research* 2025 per the reference list of arXiv:2604.07242 (OpenReview
`forum?id=pF2ukh7HxA`); the version I read is the arXiv preprint, and I did not compare it against
the published version.

**Read depth: partial.** Version read: arXiv:2412.03317v2. Cached as `arXiv:2412.03317`, sha256
`03dce23b4e57a0070cbd4997986ff12a529fe3c3d9f3d49d1cb7578aca93be95`, 34 pages. Sections read:
Abstract, §1.1 Background, §1.2 Contributions, §3.1 Matrix Multiplication, §5.6 Configuration Table,
Appendix A.1 Fusion Theorem. Not read: §2 (the diagram scheme itself), §4 (multi-level performance
models and quantization), §5.1–5.5 (step-by-step Hopper derivation), §6 (FlashAttention bottleneck
analysis), Appendix A.2–A.3 and B. Figures are again not recoverable from the extraction.

**Verified claim summary.** The paper extends Neural Circuit Diagrams to carry resource usage and
the distribution of tasks across a GPU memory hierarchy, so that a tiling/streaming strategy and its
performance model are *derived by relabelling* rather than hand-designed. Their stated motivation:
FlashAttention achieved roughly a sixfold throughput gain over native PyTorch but took three
iterations over three years, and automated compilers have lagged. The central structural result is
the **Fusion Theorem** (Appendix A.1, Theorem 1): *composition and weaving of a streamable algorithm
which does not remove the streamed axis yields a streamable algorithm.* Streamability depends on two
things stated explicitly — polymorphism over the streamed axis (the algorithm is defined for that
axis at any size) and the existence of an **accumulator** `B` letting the streamed input be split.
The worked matrix-multiplication derivation (§3.1) turns a diagram plus a memory bound
`M ≥ g_a g_c + g_a s_b + s_b g_c` into the conclusions that square tiling `g_a = g_c` is optimal and
that total transfers obey `H ≥ 2abc·M^{-0.5} + ac` — as against the `M → ∞` assumption that yields
`H = ab + bc + ac`. Tiling then recurses down the hierarchy. §5.6 turns the remaining free variables
into a configuration table against Hopper's shared-memory and register limits.

The paper states its own epistemic aim in a form worth quoting for our purposes: it wants "a
theoretical framework to link assumptions about GPU behaviour to claims about performance", so that
experiments address stated hypotheses instead of post-hoc rationalisations, which it argues are
"trained on the 'test set' of prior successful approaches".

**Categorical structure used.** Neural Circuit Diagrams (monoidal/array-categorical) annotated with
memory hierarchy levels and resource counts; the Fusion Theorem is a closure property of a
structural predicate under composition and broadcasting.

**What it buys the authors.** A cost model that is *derived from the same term* as the algorithm, so
that changing the algorithm changes the cost model mechanically; and a soundness condition (does the
modification preserve the streamed axis?) that says in advance whether a fusion is legal.

**Ergodis objects the same structure could touch** (**my inference**): The Fusion Theorem's shape —
a structural predicate closed under the composition operators of the language — is the shape Ergodis
needs for **preservation contracts under plan composition**. C1091 records the gap precisely: good
abstractions exist locally but "their semantic assumptions do not consistently cross family,
compiler, verifier and client boundaries". A Fusion-Theorem-shaped statement ("property P of a plan
is preserved by composition and by lifting, provided the composition does not destroy X") is exactly
the crossing law that is missing. Ergodis' `CompositionShape` (C1094) currently validates storage
geometry and explicitly *not* algebraic laws; a closure property over an admitted predicate is the
algebraic law that would sit next to it. Separately, deriving a cost model from the plan term rather
than measuring it addresses C1091's caution that "compilation estimates are predictions with
calibration evidence"; a derived model at least makes the assumptions auditable.

**What does not carry over.** The entire quantitative content is GPU memory-hierarchy specific
(DRAM/SMEM/register levels, tensor cores, warpgroups). Ergodis' hot paths are zero-allocation
iterative CPU/WASM loops with retained A/B counter gates; the transfer-cost algebra does not
transfer, only the derivation discipline.

### 3.5 Abbott, Kamiya, Glowacki, Atsumi, Zardini, Maruyama, *Accelerating Machine Learning Systems via Category Theory* (arXiv:2505.09326)

**Citation (from the consulted source).** Vincent Abbott and Gioele Zardini (MIT LIDS), Kotaro Kamiya
and Yu Atsumi (SyntheticGestalt, Tokyo), Gerard Glowacki and Yoshihiro Maruyama (School of
Informatics, Nagoya University), "Accelerating Machine Learning Systems via Category Theory:
Applications to Spherical Attention for Gene Regulatory Networks", arXiv:2505.09326v1 [math.CT],
14 May 2025. Published version per the arXiv:2604.07242 reference list: *Artificial General
Intelligence: 18th International Conference, AGI 2025, Reykjavik, Iceland, August 10–13, 2025,
Proceedings, Part I*, pp. 1–11, Springer-Verlag, ISBN 978-3-032-00685-1, doi
`10.1007/978-3-032-00686-8_1`. Note the author lists differ: the arXiv version has six authors
including Maruyama, while the citation in arXiv:2604.07242 gives "Vincent Abbott, Kotaro Kamiya,
Gerard Glowacki, et al." I read the preprint, not the published chapter.

**Read depth: partial.** Version read: arXiv:2505.09326v1. Cached as `arXiv:2505.09326`, sha256
`50f9c7e60b04d6f81e29238698d237d363beaa05b37373a4d812cf3bebc64efe`, 14 pages. Sections read:
Abstract, §1 Introduction (opening), the results passage reporting benchmark numbers, and the
Generalized Streamability appendix (Definition 1 Streamable Function, Definition 2 Normalized
Contraction, Lemma 2, Theorem 2 with proof). Not read: the kernel-implementation sections on tensor
core layout and the gene-regulatory-network domain motivation in full.

**This is the only paper in the Abbott corpus where the algebra proposes a new design and a measured
gate decides it**, which makes it the closest analogue to Ergodis Evolve.

**Verified claim summary.** Definition 1 makes streamability precise: a polymorphic
`f : X^n → Y`, defined for every `n`, is **streamable** if there is a polymorphic accumulator
`B : Y × X^n → Y` with `B(f(x), y) = f(x ⊕ y)` where `⊕` is concatenation along the `n`-axis; and
post-composition with any `t : Y → Z` preserves streamability. Definition 2 defines a *normalized
contraction* from a pair of activation functions `a₁, a₂` and an aggregator `b`:
`N(x)_i = a₁(x_i)/b(Σ_j a₂(x_j))`, followed by a linear contraction. Lemma 2 proves normalized
contractions are streamable by exhibiting the accumulator
`B((o,z),(x,y)) = (o + Σ_i a₁(x_i)y_i, z + Σ_i a₂(x_i))` and verifying it composes correctly over
concatenation. Theorem 2 then uses the Fusion Theorem to conclude: **attention with SoftMax replaced
by any other normalization operation remains streamable.**

The move that matters: the theorem characterises a *family* of admissible designs, not one design.
The authors then pick a new member of that family — replace SoftMax with an L2 norm, giving
"spherical attention" — specifically to dodge the special-function-unit bottleneck of the exponential
while keeping the streaming property. They implement the resulting kernel ("FlashSign") and report
measured results on an A100: around 200 TFLOP/s at large sequence lengths, 64% of the A100's stated
312 TFLOP/s FP16 tensor-core peak, up to **3.60× PyTorch**, and comparable to fine-tuned
FlashAttention-2 (which they note uses warp-shuffling advantages their derivation did not exploit),
with PyTorch hitting out-of-memory at large sequence lengths where theirs does not.

**What it buys the authors.** A theorem that enumerates an admissible design family, a principled
reason to try a specific untried member, and a measured result that settles whether the reasoning
paid. They describe this explicitly as evidence that diagrams are "suitable as a high-level
framework for the automated development of efficient, novel AI architectures".

**Ergodis objects the same structure could touch** (**my inference**): this is the template for
**Evolve proposal generation with a structural admission gate**. The pattern is:
(1) an algebraic property (`streamable`) with a *constructive witness* (the accumulator `B`);
(2) a closure theorem saying which term-level modifications preserve it;
(3) therefore an admissible family whose members are generated, not enumerated by hand;
(4) a measured gate deciding among them. Ergodis' Evolve already has ranked proposals with
independent family checkers and checked capacity bounds; what it does not have is a *generator*
whose admissible set is delimited by a closure theorem. The accumulator `B` is also the exact
structure Ergodis' `ordered_resource` monoid supplies — an accumulation law along a realization —
which is why this is the transferable half rather than the GPU half.

**What does not carry over.** One design was proposed by humans reading a theorem, not by a search
procedure; there is no proposal ordering, no regret accounting, no budget. The measured gate is
throughput on one accelerator, not exactness or coverage.

### 3.6 The two 2024 diagram papers (supporting, lower relevance)

**Abbott, *Neural Circuit Diagrams*.** Citation: Vincent Abbott (Australian National University),
"Neural Circuit Diagrams: Robust Diagrams for the Communication, Implementation, and Analysis of
Deep Learning Architectures", *Transactions on Machine Learning Research* 12/2023; OpenReview
`forum?id=RyZB4qXEgt`; read as arXiv:2402.05424v1 [cs.LG], 8 Feb 2024.
**Read depth: partial** — abstract and section headings only; cached as `arXiv:2402.05424`, sha256
`348e3c3e23184a64feb7031117605ff9ed6681b2fcfc3bd7a6770c3a449dc876`, 35 pages. This is the origin
paper for the diagram language: it claims to track the changing arrangement of data, show precisely
how operations broadcast over axes, and keep a close correspondence between diagram and code; it
covers the transformer, convolution, ResNets, U-Net and the vision transformer, and analyses
backpropagation and time/space complexity. It predates the categorical formalisation and is
superseded for our purposes by arXiv:2604.07242.

**Abbott & Zardini, *Functor String Diagrams*.** Citation: Vincent Abbott (ANU) and Gioele Zardini
(MIT LIDS), "Functor String Diagrams: A Novel Approach to Flexible Diagrams for Applied Category
Theory", arXiv:2404.00249v2 [math.CT], 26 Jun 2024; formatted as an EPTCS-style preprint, publication
venue not established here. **Read depth: partial** — abstract and §1 introduction; cached as
`arXiv:2404.00249`, sha256 `8989646bca32eb9407685279b706dd4d9c53732317d86acb7b6764cb9a50e728`,
19 pages. The stated contribution is a diagram calculus that can display functors, natural
transformations and products at once — which ordinary monoidal string diagrams cannot — validated by
proving the Yoneda lemma diagrammatically, by showing it subsumes monoidal string diagrams, and by
underpinning neural circuit diagrams. It is the machinery *Diagrammatic Negative Information* uses;
its own content is notational, and I did not verify the Yoneda proof.

### 3.7 Abbott, Xu & Maruyama, *Category Theory for Artificial General Intelligence* — NOT ACCESSED

**Citation (from consulted metadata services).** Vincent Abbott, Tom Xu, Yoshihiro Maruyama,
"Category Theory for Artificial General Intelligence", in *Artificial General Intelligence* (Lecture
Notes in Computer Science), Springer Nature Switzerland, 2024, pp. 119–129, doi
`10.1007/978-3-031-65572-2_13`. Page range from Crossref and OpenAlex, which agree.

**Read depth: abstract/metadata only** — and in fact **not even the abstract**. What was retrieved:
title, authors, venue, year, page range and DOI from OpenAlex (work record) and Crossref (message
record). OpenAlex carries no `abstract_inverted_index` for it; Crossref carries no `abstract` field;
Semantic Scholar returns `abstract: null` with an explicit publisher-elision notice and
`openAccessPdf.status: CLOSED`. No arXiv preprint appears under the author's arXiv or OpenAlex
listing. **This is a "could not access" outcome, not a "searched and found nothing" one**, and it is
carried forward as an open gap: the one Abbott paper whose title is squarely about general
intelligence rather than about deep-learning notation is the one I could not read. If part B or a
successor wants the corpus closed, this is the item to obtain.

---

## 4. Sweep (a): non-neural search priors and compositional inductive bias

The brief for this section is the hard one: the categorical-deep-learning programme is stated in
terms of networks and gradients, and Ergodis has neither. So each entry below is followed by an
explicit **non-neural residue** — what survives when the gradient and the network are removed. Where
nothing survives, I say so.

### 4.1 Gavranović, Lessard, Dudzik, von Glehn, Araújo & Veličković, *Position: Categorical Deep Learning is an Algebraic Theory of All Architectures* (arXiv:2402.15332)

**Citation (from the consulted source).** Bruno Gavranović (Symbolica AI; University of Edinburgh),
Paul Lessard (Symbolica AI), Andrew Dudzik (Google DeepMind), Tamara von Glehn (Google DeepMind),
João G.M. Araújo (Google DeepMind), Petar Veličković (Google DeepMind; University of Cambridge),
"Position: Categorical Deep Learning is an Algebraic Theory of All Architectures", *Proceedings of
the 41st International Conference on Machine Learning*, Vienna, PMLR 235, 2024. The first four
authors are marked equal contribution. The authors add a parsing note: the title is to be read as
"Categorical Deep Learning is an Algebraic {Theory of All Architectures}".

**Read depth: partial.** Version read: arXiv:2402.15332v2 [cs.LG], 6 Jun 2024. Cached as
`arXiv:2402.15332`, sha256 `16d3632a3e323b7fdcc1901c6c44bf1ec28711d3a8cd286485e6cf6a511bc248`,
32 pages. Sections read: Abstract, §1.1 Our Opinion, §1.2 Our Position, §1.3 The Power of Category
Theory, §2.2 Endofunctors and their (Co)algebras with Definitions 2.8–2.12 and Examples 2.9–2.12,
§4 New Horizons. Skimmed via heading index only: §2.1 (monads and their algebras, Definitions
2.1–2.7), §3 (2-categories and parametric morphisms, `Para`, algebraically free monads), and the
appendices. Not read: the RNN/weight-tying derivations in Appendix I, which carry much of the
"recovers implementations" claim.

**Verified claim summary.** The paper's diagnosis is a gap between two ways of specifying models:
**top-down** — state the constraints a model must satisfy, the exemplar being geometric deep learning
(Bronstein, Bruna, Cohen & Veličković), where layers are derived by solving equivariance constraints
— and **bottom-up** — state the implementation as a sequence of tensor operations. Their stated
limitation of the top-down route is sharp and is the reason this section exists: geometric deep
learning "is only able to represent equivariance to symmetries" because it is built on group theory,
and its usability tracks how easy the equivariance constraints are to solve. Their proposal is the
universal algebra of **monads valued in a 2-category of parametric maps**. The pieces that matter
without any networks in sight:

- A **monad algebra homomorphism** generalises an equivariant map. Group actions are one monad
  (`(G × −, η, µ)` on `Set`); everything expressible as a monad gives a notion of
  structure-respecting map, and monads are not restricted to groups.
- Dropping down to **algebras for a bare endofunctor** `a : F(A) → A` (no equations) recovers
  ordinary data structures: `List(A)` is the initial algebra of `1 + A × −`, binary trees the initial
  algebra of `A + (−)²`. Initiality is what makes a **fold** unique — a homomorphism out of the
  initial algebra to any other algebra exists and is unique.
- Dually, **coalgebras** `a : A → F(A)` model non-terminating/productive computation: Mealy machines
  are coalgebras of `(I → O × −)`, and they also treat streams and Moore machines coalgebraically.
- §4 names polynomial functors and containers as the route to "programs with types you can reason
  about", and speculates about networks "that learn only well-typed functions by choosing appropriate
  algebras as their domain and codomain".

**What it buys the authors.** One vocabulary in which a constraint ("respects this structure") and
an implementation ("is this fold over this datatype") are the same kind of object, so the two
specification styles can be related rather than juxtaposed.

**Non-neural residue, and the Ergodis object it touches** (**my inference**): remove the gradients
and `Para` and what is left is *the statement that a structural constraint is a monad algebra and a
structure-respecting transformation is a homomorphism of algebras*. That is entirely about discrete
structure and holds verbatim for an exact engine.

- It is a direct generalisation of Ergodis' **`ValidatedQuotient` and admitted observables**. C1095
  admits a readout by checking it is constant on classes of a validated finite quotient; "constant on
  classes" is the special case of "is an algebra homomorphism" for the quotient monad. The
  generalisation buys the thing C1091 explicitly asks for, namely a contract that is not limited to
  equivalence relations — because monads are not limited to group actions, and their algebras are not
  limited to quotients.
- The initial-algebra/unique-fold fact is the licence Ergodis needs for **FeatureDag lowering**: if
  the feature IR is presented as the initial algebra of a signature endofunctor, then *every*
  semantics is a unique fold, and two lowerings agreeing on the signature agree everywhere. That is a
  proof obligation reduced from "check the whole DAG" to "check each constructor".
- The coalgebra half touches **campaigns and repair schedules**: a campaign that produces an output
  and a successor campaign given an input is literally a Mealy coalgebra, and coalgebraic
  bisimulation is the corresponding "same observable behaviour" relation.

**What does not carry over.** `Para` and the 2-categorical lifting exist to accommodate learned
weights and backpropagation; for Ergodis they are dead weight unless the parameter is a budget (see
§5.3). The paper is explicitly a *position paper*: it demonstrates that known architectures are
recovered, and reports no measurement of anything. It also offers no guidance on *choosing* the
monad, which the authors themselves flag ("results rely on choosing the right category to operate
in; much like results in geometric deep learning relied on the choice of symmetry group") — for
Ergodis that choice is the whole problem, since discovering the right structure is Evolve's job.

### 4.2 Dudzik & Veličković, *Graph Neural Networks are Dynamic Programmers* (arXiv:2203.15544)

**Citation (from the consulted source).** Andrew Dudzik and Petar Veličković (both DeepMind,
marked equal contribution), "Graph Neural Networks are Dynamic Programmers"; read as
arXiv:2203.15544v3 [cs.LG], 10 Oct 2022. The paper reports experiments on the CLRS algorithmic
reasoning benchmark; I did not establish its published venue from a consulted source.

**Read depth: partial.** Cached as `arXiv:2203.15544`, sha256
`9f1a4d7b021d8ee30c352dd9076c6dbf75874552f6f64625ac192aa7f751de70`, 18 pages. Sections read:
Abstract, §1 Introduction, §4 The integral transform in full (polynomial spans, pullback, argument
and message pushforwards, the bag/multiset construction, the semiring requirement), §5 Bellman-Ford,
and the passage instantiating GNN message passing as an integral transform. Not read: the
experimental sections and the appendices on monads over lists and bags and on polynomial functors.

**Despite the title, the transferable content of this paper is not about neural networks at all.**

**Verified claim summary.** They introduce the **polynomial span** `W ←i− X −p→ Y −o→ Z` over finite
sets, where `W` carries inputs, `Z` outputs, `X` arguments and `Y` messages, and the **integral
transform** built from it: given data `[S, R] := {f : S → R}` for a value set `R`, the transform is

- the **pullback** `i* f = f ∘ i` (easy, composition);
- the **argument pushforward** `p⊗`;
- the **message pushforward** `o⊕`, which cannot be defined by inverting `o` — the preimage lands in
  the power set and loses multiplicities, so it is defined into `bag(R)`, finite multisets, i.e.
  formal sums: `(o⊕ m)(u) := Σ_{e ∈ o^{-1}(u)} m(e)`.

They conjecture the transform is a polynomial functor with `p⊗` and `o⊕` as dependent product and
dependent sum. The value set `R` must be a **semiring** `(R, ⊗, ⊕)`, and they note the converse: a
set with two suitable aggregators is a semiring. Their two instantiations are the point: real
numbers with `(×, +)` for message-passing networks, and the **tropical/min-plus semiring**
`(N ∪ {∞}, +, min)` for Bellman-Ford, which they then write out as an explicit polynomial span with
`i` the source/target functions on copies of the edge set, `p` collapsing the copies into the
computed message, and `o` the target function.

**What it buys the authors.** A single diagram in which an algorithm and a network are two choices
of semiring, so that alignment between them becomes a structural comparison rather than an analogy.

**Non-neural residue, and the Ergodis object it touches** (**my inference**): the entire
polynomial-span/integral-transform apparatus is defined over finite sets and an arbitrary semiring.
Set `R` to min-plus and no network remains — what remains is **a general form for a dynamic
program**, parameterised by (i) the span shape, (ii) the semiring, and (iii) the two pushforwards.

- Ergodis' `OpenProblem`/`RetainedTree` already carries **semiring-window adapters** and a
  composition/identity/readout core. The integral transform says what the *general* shape of a
  readout over a span is, and in particular that the aggregation step must be a bag/formal-sum
  operation rather than a set operation. That is C1091 **rejection fixture 3** stated structurally:
  the paper's own reason for using bags is that a subset of `R` cannot tell you whether multiple
  messages had the same value, which is exactly why overlapping repairs `{1,2}` and `{2,3}` do not
  give 1/2.
- It supplies a **factorisation of a plan into a span plus a semiring**, and therefore an axis along
  which Evolve can propose: hold the span, vary the semiring (count witnesses, minimise weight,
  Pareto-accumulate) and get a family of related queries over one compiled structure. That is exactly
  the C1091 "one model, several plans specialised for the query" statement, with a concrete
  parameterisation attached.

**What does not carry over.** The alignment argument itself (sample complexity in the neural tangent
kernel regime) is meaningless without a network. The polynomial-functor claim is stated as a
conjecture, not a theorem.

### 4.3 Dudzik, von Glehn, Pascanu & Veličković, *Asynchronous Algorithmic Alignment with Cocycles* (arXiv:2306.15632)

**Citation (from the consulted source).** Andrew Dudzik, Tamara von Glehn, Razvan Pascanu, Petar
Veličković (all Google DeepMind), "Asynchronous Algorithmic Alignment with Cocycles";
arXiv:2306.15632v3 [cs.LG], 12 Jan 2024. Published venue not established from a consulted source.

**Read depth: partial** — abstract and §1 Introduction only. Cached as `arXiv:2306.15632`, sha256
`7a974f7de9e7b05e9e520a300c368d6a6edf4d9cc0deae3a31fa142a3b0ee635`, 17 pages. The cocycle
definitions and the invariance proofs were not read, so the technical claims below are taken from the
abstract's own statement of them.

**Verified claim summary (from the abstract and introduction).** Typical message-passing networks
"blur the distinction between the definition and invocation of the message function", forcing every
node to send at every layer, synchronously — whereas in a dynamic program, at most steps only a
handful of nodes have a meaningful update, so intermediate steps must learn identity functions. The
authors separate node state update from message invocation, obtain a formulation supporting
asynchronous computation, and claim implementations "provably invariant under various forms of
asynchrony".

**Non-neural residue, and the Ergodis object it touches** (**my inference**): "separate the
definition of an update from its invocation, and prove the result invariant under the order and
timing of invocations" is a statement about **schedules**, not about networks. Ergodis has exactly
this problem in **repair schedules and kicks**, and in Evolve's late-arriving proposals — the
architecture context records that "already-arrived late proposals can be retained as future knowledge
without changing completed race evidence", which is a hand-maintained asynchrony invariant. An
invariance-under-asynchrony theorem for an update operator is the general form of that rule. I flag
this as a lead rather than a finding, because I read only the abstract and introduction.

### 4.4 Shiebler, Gavranović & Wilson, *Category Theory in Machine Learning* (arXiv:2106.07032)

**Citation (from the consulted source).** Dan Shiebler, Bruno Gavranović and Paul Wilson, "Category
Theory in Machine Learning"; per the reference list of arXiv:2604.07242, presented at Applied
Category Theory 2021. Read as arXiv:2106.07032.

**Read depth: abstract/metadata only** — specifically, title, authors and venue from the reference
list of arXiv:2604.07242 plus the cached PDF's page count. The bytes were fetched and cached
(`arXiv:2106.07032`, sha256 `e2b502259256e472ebfba5b2e3b0b8159a2a33510deeacb6fe31f753ebdd48d7`,
43 pages) but I did not open the text. **Nothing in this report rests on it.** It is recorded because
a later reader should know a survey exists at exactly this intersection and was not mined; if part B
wants breadth rather than depth, this is the cheapest place to get it.

### 4.5 What the sweep did *not* find

Two negatives, both recorded as **searched and found nothing** rather than "could not access", with
the queries in §8:

1. **No categorical-deep-learning work that drops the network.** Every member of the programme I
   located states its results in terms of layers, parameters and losses. The structures (monad
   algebras, endofunctor algebras, integral transforms) are network-independent, but nobody in this
   programme has published the non-neural specialisation. My inference: this is an opportunity rather
   than a warning — the translation work is genuine and unclaimed — but it also means Ergodis would
   be doing it without a worked precedent to copy.
2. **No categorical treatment of proposal ordering or search-prior construction.** I found
   compositional accounts of *what* a search space is (co-design, `DP`, spans) and of *what* a valid
   move is (rewriting, algebra homomorphisms), but nothing that assigns a categorical structure to
   the *order* in which candidates are tried. Evolve's proposal ranking has no prior art in this
   literature to absorb.

---

## 5. Sweep (b): categorical optimization and regularization

### 5.1 Censi, Frazzoli, Lorand & Zardini, *Categorification of Negative Information using Enrichment* (arXiv:2207.13589)

**Citation (from the consulted source).** Andrea Censi, Emilio Frazzoli, Jonathan Lorand and Gioele
Zardini (Institute for Dynamic Systems and Control, Department of Mechanical and Process Engineering,
ETH Zurich), "Categorification of Negative Information using Enrichment", in J. Master & M. Lewis
(eds.), *Fifth International Conference on Applied Category Theory (ACT 2022)*, EPTCS 380, 2023,
pp. 22–40, doi `10.4204/EPTCS.380.2`. Acknowledges discussions with David I. Spivak and comments from
Valeria de Paiva, Brendan Fong and David Yetter; Zardini supported by SNSF NCCR Automation grant
51NF40_180545.

**Read depth: partial.** Version read: arXiv:2207.13589 (EPTCS-typeset). Cached as
`arXiv:2207.13589`, sha256 `4c60e21cda2d08b046dcd62e17f3659c09bc4151366225039d218efdedac2216`,
19 pages. Sections read: Abstract, §1 Introduction (all of §1.1–§1.3), §2 thin categories, Definition
1 (Nategory) and Definition 2 (Exact nategory), the Examples 3–6 index, Proposition 17 with its
(neut), (covar), (contravar) conditions, and §9 Conclusions. Not read in detail: §5 Berg, §6 `DP`,
§7 the dialectica category `GSet` and its monoidal product (Definitions 11, 14), and §8's enrichment
proof.

**This is the single most on-point source in the whole study for an exact-optimization engine, and
its opening sentence states Ergodis' certified-optimality problem exactly.** In the authors' words:
"in planning problems, providing an optimal solution is the same as giving a feasible solution (the
'positive' information) together with a proof of the fact that there cannot be feasible solutions
better than the one given (the 'negative' information)." Compare C1091 rejection fixture 9: a
feasible witness with unverified exclusion of cheaper candidates is an upper bound, not certified
optimality. These are the same statement.

**Verified claim summary.** Motivating cases the authors give: a certificate of infeasibility for
motion planning ("what is the equivalent concept in category theory?"); a certificate of optimality
for weighted shortest paths, where they observe that Dijkstra's algorithm constructs positive and
negative information simultaneously; **heuristics for A\*, which they identify outright as negative
information** ("they provide a lower bound on the cost of a path between two points. And better
heuristics make the algorithm faster. Again, we ask, what could be the categorical counterpart of
heuristics?"); and impossibility in co-design, where a morphism `F → R` is a Boolean profunctor
`F^op × R → Bool` and one wants to say that no realizable `d` satisfies `d(2J, 1J)`.

Their construction (Definition 1) is the nategory summarised in §3.3 above. Three design decisions
they state and defend:

- They deliberately reject building negative information "on top of a category, at a higher level,
  using logic", wanting positive and negative at the same level.
- Norphisms and morphisms are **not** mutually exclusive in general — unlike proofs and refutations
  in intuitionistic logic, a norphism and a morphism between the same objects can coexist and give
  complementary information. Shulman's proofs-and-refutations work is cited as the early influence,
  with the intuitionistic identity `P(X → Y) = (P(X) → P(Y)) × (R(Y) → R(X))`.
- An early attempt to make a "twin category" of norphisms **failed**, and they report why: "negative
  information cannot be composed independently of positive information". Norphisms need morphisms as
  catalysts.

The enrichment result (§7–8, Proposition 17): categories enriched in de Paiva's dialectica category
`GSet` with a modified monoidal product yield nategories, but ones satisfying extra regularity —
identities act neutrally (`id ▷ n = n`, `n ◁ id = n`), compatibility with composition
(`(f ⨟ g) ▷ n = g ▷ (f ▷ n)` and `n ◁ (g ⨟ h) = (n ◁ h) ◁ g`) and commuting actions. They
deliberately keep these *out* of the definition of nategory because examples they care about violate
them, and they give a worked failure. Their stated open problem is whether nategories can be
recovered exactly by a different enrichment.

**What it buys the authors.** A composable object for impossibility and for lower bounds, so that a
certificate of optimality has the same type discipline as the solution it certifies.

**Ergodis objects this touches** (**my inference**):

- **Certificates and independent verification.** Ergodis' glossary already distinguishes witness
  ("does not by itself prove optimality or an exhaustive negative result") from independently
  certified optimality, and distinguishes `Coverage` (CompleteFiniteProblem vs RestrictedOnly).
  A norphism is the type of the missing half. Concretely: a `Coverage` claim *is* negative
  information, and the nategory composition rules say how one composes with a morphism, which is what
  the glossary currently handles by saying certificates "compose only through checked rules" without
  saying what the rules are.
- **Admission and its refusals**, as in §3.3.
- **Evolve's counterexamples.** C1091 asks that a counterexample be structured output — distinguishing
  context, failed lift, violated assumption, uncovered source case, incompatible information state.
  Those are five species of negative information, and the nategory says the thing that matters
  operationally: each can be *propagated* rather than merely recorded.
- **The failed twin-category attempt is the most valuable single sentence for us.** It is an
  experimental negative from people who tried: you cannot build a separate "refusal registry"
  alongside the plan algebra and compose refusals in it. Any Ergodis design that puts admission
  failures in their own table, composed among themselves, is attempting the thing these authors
  report does not work.

**What does not carry over.** No algorithm, no complexity, no implementation. The exact-nategory
condition (Definition 2, "⇔" rather than "⇒") is the case where bans are tight, and the paper does
not say which practical settings satisfy it.

### 5.2 Censi, *A Mathematical Theory of Co-Design* (arXiv:1512.08055)

**Citation (from the consulted source).** Andrea Censi, "A Mathematical Theory of Co-Design",
arXiv:1512.08055v7 [cs.LO], 12 Oct 2016. Published venue not established from a consulted source.

**Read depth: partial.** Cached as `arXiv:1512.08055`, sha256
`ac2cea710793939e891ccf5d46f5ff9b2d5ec50c75ebc09d23c7dab9d0a966a3`, 18 pages. Sections read:
Abstract, §I Introduction, and the order-theoretic preliminaries on antichains, upper closure, chains
and Kleene's theorem. Not read: the Scott-continuity proofs, the composition operators, or the
worked robotics examples.

**Verified claim summary.** A design problem is a tuple of functionality space, implementation space
and resource space with a feasibility relation; design problems interconnect (possibly recursively)
into co-design problems, which induce optimization problems of the form "find the minimal resources
needed to implement a given functionality", whose **solution is an antichain — a Pareto front**. For
**Monotone Co-Design Problems**, where functionality and resources are complete partial orders and
the feasibility relation is monotone and Scott continuous, the author states the result that matters
here, and I quote its scope precisely because the scope is the point: the induced optimization
problems are "multi-objective, nonconvex, nondifferentiable, noncontinuous, and not even defined on
continuous spaces; yet, there exists a complete solution." The antichain of minimal resources is a
**least fixed point**, computable by **Kleene's algorithm** iterating in the space of antichains, and
the computation needed is bounded by a graph property quantifying the interdependence of the
subproblems.

**What it buys the authors.** Exact, complete Pareto solutions for recursively interconnected design
problems in a setting where no analytic optimization method applies, plus a complexity handle tied to
problem structure rather than to problem size.

**Ergodis objects this touches** (**my inference**): this is the closest published analogue to what
Ergodis' `ordered_resource` module is for — finite ordered monoids, validated laws, Pareto fronts,
frozen query plans. Three specific transfers: (i) **antichains as the solution type**, with an upper
closure operator, rather than a single optimum, which matches C1091's "Pareto/resource envelope"
representation contract; (ii) **least-fixed-point-by-Kleene-iteration as the solution method for
recursive interconnection**, which is the shape Ergodis needs when a repair plan's budget depends on
another plan's output; (iii) **a complexity bound stated as a function of an interdependence graph
property**, which is the kind of predictive cost model C1091 wants to distinguish from calibration
evidence. Caution belongs with (iii): I read the claim, not the proof.

**What does not carry over.** Monotonicity and Scott continuity are strong hypotheses. C1091's
warning that "unit-cost minima do not admit arbitrary repricing" and that additive acquisitions can
double-charge shared coordinates says Ergodis has objectives that are *not* simply monotone in the
required sense; establishing which Ergodis families are MCDP-shaped is itself work.

### 5.3 Lenses, optics and parametric categories

**Cruttwell, Gavranović, Ghani, Wilson & Zanasi, *Deep Learning with Parametric Lenses*.**
Citation (from the consulted source): Geoffrey S. H. Cruttwell (Mount Allison University, Canada),
Bruno Gavranović (University of Strathclyde), Neil Ghani (University of Strathclyde), Paul Wilson
(independent, UK), Fabio Zanasi (University College London and University of Bologna);
arXiv:2404.00408v1 [cs.LG], 30 Mar 2024. **Read depth: partial** — abstract, the introduction's
statement of scope, Examples 3.24–3.26 (gradient ascent in `Smooth` and in the Boolean-circuit
category `POLY_{Z₂}`, and gradient descent requiring commutative-group monoids), and Example 4.4
(basic learning in Boolean circuits). Cached as `arXiv:2404.00408`, sha256
`1e4881a7b98d1a2053a7f782a7ca633c6a77ad6538bc55ac187c41320f6f4304`, 40 pages. Not read: the bulk of
the lens algebra and the optimiser zoo.

The claim: a categorical semantics for machine learning in terms of **lenses, parametric maps and
reverse derivative categories**, encompassing ADAM, AdaGrad and Nesterov momentum, several loss
functions, and several architectures. The part that matters here is that the same framework "can be
realised in the discrete setting of Boolean and polynomial circuits": in `POLY_{Z₂}`, addition is
XOR, so the gradient-ascent reparameterisation is "XOR the current parameter with the requested
change", and the learning `put` map reduces to `put(a, p, b_t) = p + p′` where
`(p′, a′) = R[f](p, a, f(p, a) + b_t)`. Gradient *descent* (as opposed to ascent) is the case
requiring every monoid in the category to be a commutative group — an explicit statement of when the
continuous intuition needs extra structure the discrete case lacks.

**Cockett, Cruttwell, Gallagher, Lemay, MacAdam, Plotkin & Pronk, *Reverse Derivative Categories*.**
Citation (from the consulted source): R. Cockett (University of Calgary), G. Cruttwell (Mount
Allison), J. Gallagher (Dalhousie), J.-S. P. Lemay (University of Oxford), B. MacAdam (Calgary),
G. Plotkin (Google Research), D. Pronk (Dalhousie); arXiv:1910.07065v1 [cs.LO], 15 Oct 2019.
**Read depth: abstract/metadata only** — title page and abstract; cached as `arXiv:1910.07065`,
sha256 `aa7c2cd80b0f3538abec1aa7c741ccb1f2bb2bd8bb981cf0c9fe64516a2e97a1`, 25 pages. It is the
axiomatic source the two papers above rest on; nothing in this report rests on its internal content.

**Wilson & Zanasi, *Reverse Derivative Ascent: A Categorical Approach to Learning Boolean
Circuits*.** Citation (from the consulted source): Paul Wilson (University College London;
University of Southampton) and Fabio Zanasi (University College London); *Proceedings of Applied
Category Theory*, EPTCS 333, 2021, doi `10.4204/eptcs.333.17` (the DOI from OpenAlex; the PDF is the
EPTCS typesetting, pages in the 240s–250s). Read as arXiv:2101.10488. **Read depth: partial** —
abstract, §1 Introduction, §4.2 Empirical Results including Table 1, and Lemma 19's setting. Cached
as `arXiv:2101.10488`, sha256 `2dce4761a9ee6c37f75a0d99ddbeb8f47c3a096a3b44620882c0c7e7eb5e0e31`,
14 pages.

**This is the direct answer to the task's question "what would a regularizer mean for a discrete
exact engine", approached from the derivative side.** The algorithm is defined at the level of
reverse differential categories, learns parameters of models expressed as morphisms there, and —
their emphasis — learns Boolean circuit parameters *directly*, in contrast to binarised neural
network approaches. The honest part is the scale: Table 1 reports 98.0% on two-class Iris (both
binary and one-hot encodings), 73.3% on full Iris, and 99.2% on two-class MNIST with a
`pseudoLinear : 784 + 784 → 1` model. That is a proof of concept, not a competitive optimizer.

**Capucci, Gavranović, Hedges & Rischel, *Towards Foundations of Categorical Cybernetics*.**
Citation (from the consulted source): Matteo Capucci, Bruno Gavranović, Jules Hedges, Eigil Fjeldgren
Rischel (MSP Group, University of Strathclyde); arXiv:2105.06332. **Read depth: partial** — abstract
and §1 Introduction. Cached as `arXiv:2105.06332`, sha256
`9dad6a087398adf23d38fad154eec784ccb74177ead977ee6c7095934dd3a549`, 14 pages. The construction is
**parametrised optics**: combine `Para(C)` (morphisms parameterised by a monoidal category of
parameters) with the optics construction for bidirectional flow, giving "open systems that have
bidirectional information flow, with a control on the forward direction and an objective on the
backwards direction". Their observation is that this pattern recurs at multiple levels: a network
layer, a gradient-descent optimiser, and a game-theoretic agent are all instances.

**Ergodis objects these touch** (**my inference**): the forward-control/backward-objective pattern
is the shape of **`RepairModel → RepairPlan → BudgetQuery`** and of Evolve's propose/evaluate loop:
forward, a plan under a parameter; backward, an objective value that determines the next parameter.
Ergodis compiles once and admits budget changes, which is `Para` with the budget as the parameter
object. The stronger and less obvious transfer is the **lens laws themselves**: a lens is a `get`
paired with a `put` satisfying round-trip conditions, and Ergodis' representation contracts include
precisely such a round trip — the **witness lift**. C1091 §"Representation contracts" requires
"actual witness lifts" for a representative catalog and distinguishes preserving one canonical
witness, preserving the feasible witness set, and preserving the ability to lift *some* valid
optimum. Those three are three different lens laws over the same `get`/`put` pair. My inference: this
is the cleanest available formalisation of a distinction C1091 currently states in prose and has no
type discipline for.

**What does not carry over.** Every paper in this group is aimed at *learning parameters by
differentiation*. Ergodis' parameters are budgets, radii, adversity bounds and admitted contexts, and
C1091 is explicit that changing the semantic ones creates a new contract even when the kernel is
unchanged — which is precisely the case where a smooth update rule is the wrong object. The
`Para`/lens skeleton transfers; the derivative does not.

### 5.4 Rewriting as optimization: the existence proof from quantum circuits

**Duncan, Kissinger, Perdrix & van de Wetering, *Graph-theoretic Simplification of Quantum Circuits
with the ZX-calculus*.** Citation (from the consulted source): Ross Duncan (University of Strathclyde
and Cambridge Quantum Computing), Aleks Kissinger (University of Oxford), Simon Perdrix (CNRS LORIA,
Inria-MOCQUA, Université de Lorraine), John van de Wetering (Radboud University Nijmegen); read as
arXiv:1902.03178v6 [quant-ph], 26 May 2020, dated 27 May 2020 on the title page. The typesetting is
the *Quantum* journal style; I did not confirm the published volume and page from a consulted source,
so the venue is left unstated. **Read depth: partial** — abstract and §1 Introduction. Cached as
`arXiv:1902.03178`, sha256 `bff4a29bb5a06e1ce25701866a3aac6b763fdb2f839003222b7bdcff5e1beac9`,
33 pages.

**Why this is in a report about Ergodis.** It is the strongest available demonstration that a
*categorical rewrite calculus*, applied to a *discrete exact* problem, produces a real optimizer with
real wins — no gradients, no networks, no approximation. The pipeline: interpret circuits as
ZX-diagrams (a lower-level graphical language); simplify using two graph transformations, local
complementation and pivoting; then extract a circuit back out. The extraction step is where the
soundness lives, and their result is a structural one — the simplified diagram's underlying graph
always has **generalised flow**, which yields a *deterministic* extraction procedure. For Clifford
circuits this gives a normal form asymptotically optimal in size with a new smaller upper bound on
gate depth for nearest-neighbour architectures; for Clifford+T and general circuits it produces
smaller circuits than "cut-and-resynthesise" methods because the rewriting can "see around" gates
obstructing the Clifford structure.

**Ergodis object this touches** (**my inference**): the architecture is *exactly* the one Abbott &
Zardini sketch but do not complete — lower a term into a permissive graphical normal form where more
rewrites are available, optimize there, then extract back under a structural guarantee. For Ergodis
this maps onto **plan compilation and FeatureDag lowering**: the expensive part is not finding
rewrites but guaranteeing that the optimized object can be turned back into an executable plan. ZX's
answer — an invariant (generalised flow) maintained by the rewrite set, which certifies extractability
— is the pattern worth copying, and it is a pattern Ergodis can state as a preservation contract.

**Bonchi, Gadducci, Kissinger, Sobociński & Zanasi, *String Diagram Rewrite Theory I: Rewriting with
Frobenius Structure*.** Citation (from the consulted source): Filippo Bonchi and Fabio Gadducci
(University of Pisa), Aleks Kissinger (University of Oxford), Paweł Sobociński (Tallinn University of
Technology), Fabio Zanasi (University College London); arXiv:2012.01847v2 [cs.LO], 3 Feb 2022.
**Read depth: abstract/metadata only** — abstract and CCS/keyword block. Present in the shared cache
from a prior fetch under key `arXiv:2012.01847` (sha256 beginning `241e36b151698ea7`); my re-fetch
was refused as a duplicate and I did not compare the two blobs, so the bytes I read are the
previously cached ones. The claim: string-diagram rewriting modulo a Frobenius structure corresponds
exactly to **double-pushout hypergraph rewriting**, proved sound and complete, generalised to
multiple Frobenius structures, with a termination strategy derived for Interacting Bialgebras.

**Ergodis relevance** (**my inference**): this is the theory underneath Abbott & Zardini's
"convert the term to a hypergraph and rewrite there" move, and it names the price — the correspondence
holds *modulo Frobenius structure*, i.e. when the wires can be freely joined and split. Any Ergodis
adoption of hypergraph rewriting on plans has to establish that its composition structure supports
the corresponding laws, or accept a weaker correspondence.

### 5.5 Colcombet & Petrişan, *Automata Minimization: a Functorial Approach* (arXiv:1712.07121)

**Citation (from the consulted source).** Thomas Colcombet and Daniela Petrişan (CNRS, IRIF,
Université de Paris), "Automata Minimization: a Functorial Approach", *Logical Methods in Computer
Science*, Volume 16, Issue 1 (2020), pp. 32:1–32:28; submitted 21 Dec 2017, published 23 Mar 2020;
journal version of an earlier conference paper. **Read depth: partial** — abstract and §1
Introduction. Present in the shared literature cache from a prior fetch under key `arXiv:1712.07121`;
its read depth here does not inherit from whatever earlier task cached it.

**Why it is here.** It is the one source I found that states **general conditions under which a
minimal object is guaranteed to exist**, which is the question Ergodis' `ValidatedQuotient` and
C1091's correction to "coarsest quotient" are circling. Their move is to define an automaton directly
as a **functor** from a category representing input words to a category representing computation and
output — deterministic automata as `Set`-valued, non-deterministic as `Rel`-valued — and then: (a)
give sufficient conditions **on the output category** so that minimization of the corresponding
automata is guaranteed; (b) lift adjunctions between output-value categories to adjunctions between
categories of automata; (c) unify determinization, minimization and syntactic algebras, including
explanations of Choffrut's minimization for subsequential transducers and of Brzozowski's algorithm.

**Ergodis object this touches** (**my inference**): C1091 corrects "coarsest quotient is not a
universal representation objective" and notes that decision covers need not be equivalence relations
and that representative catalogs preserve a lower envelope collectively. Colcombet–Petrişan give the
other half of that correction constructively: rather than asserting minimization is or is not
available, they make availability a **checkable property of the output category**. My inference: an
Ergodis analogue would be a per-family predicate — "does this family's readout category admit
minimization?" — decided once at compile time, with the non-minimizable families routed to catalogs
instead of quotients. That converts a judgement call in C1091's prose into a compile-time check.

### 5.6 Regularization: a genuine gap

The task asked what a "regularizer" could mean for a discrete exact engine. **I found no categorical
account of regularization, model-complexity control, or Occam-style bias.** This is a
**searched-and-found-nothing** outcome over the queries in §8, not an access failure: the searches
returned results, they were simply about something else — the word "categorical" in the statistics
sense (categorical variables, categorical forecasts, categorical climate forecasts) dominates every
phrasing I tried. The only category-theoretic work the regularization queries surfaced was Cruttwell,
Gavranović, Ghani, Wilson & Zanasi, *Categorical Foundations of Gradient-Based Learning*, doi
`10.1007/978-3-030-99336-8_1`, 2022 — **read depth: abstract/metadata only**, in fact title and DOI
only, retrieved from an OpenAlex search-result listing; I did not open it, and I make no claim about
how it treats regularization. It is the ESOP predecessor of *Deep Learning with Parametric Lenses*
(§5.3), which I did read.

What the literature does supply, and what I would offer in place of an absent categorical
regularizer (**this synthesis is my inference, not any source's claim**): the analogue of
regularization for an exact engine is not a penalty term but a **restriction of the admissible
category**. Three concrete readings, each grounded in a source above:

1. **Regularization as choice of monad** (§4.1): constraining candidate structures to be algebras of
   a chosen monad is a hard inductive bias with no tuning parameter. The "complexity" being
   controlled is the size of the admissible class, and the control is exact rather than soft.
2. **Regularization as an expansive ban** (§3.3, §5.1): a norphism bans an upward-closed set of
   candidates. A cost-preorder norphism is a hard version of what a penalty does softly, and it has
   the property a penalty lacks — it is composable, so one ban prunes every route around it.
3. **Regularization as an antichain restriction** (§5.2): keeping only the minimal antichain, rather
   than the whole feasible set, is a complexity control that provably loses nothing for a monotone
   objective. C1091's "representative catalog preserves the optimum over the retained family
   collectively" is the same idea, and the co-design fixed-point machinery is the version with a
   termination and complexity story attached.

The honest statement is that (1)–(3) are reinterpretations I am proposing, not results anyone has
published, and that the absence of a categorical regularization literature is a real gap rather than
a search failure on my part — with the caveat that a negative from three services on one phrasing
family is weaker than a negative from an exhaustive screen, and I did not run an exhaustive screen
because no deliverable here depends on the absence.

---

## 6. Absorption table

Prior art informs; it never gates. Nothing below is blocked because it exists elsewhere — where a
published result exists it is a template to absorb, and where none exists the work is simply
unclaimed. Confidence is mine.

| # | Candidate categorical structure | Ergodis object it touches | Expected benefit | Cheapest concrete experiment | Measured evidence gate | Confidence |
|---|---|---|---|---|---|---|
| 1 | **Norphism (composable ban) over the objective preorder**, from Censi–Frazzoli–Lorand–Zardini and Abbott–Zardini | Certificates and independent verification; the exclusion half of a certified optimum | An optimality certificate gains a type: witness (morphism) + expansive ban (norphism). Exclusion coverage becomes a composable object rather than an argument in prose | Take one already-solved exact family with a certified optimum and re-express its exclusion argument as an upward-closed ban over the cost preorder. Check the existing checker still accepts, and that the ban composes with one plan-extension step | The re-expressed certificate must verify against the *unmodified* independent checker, and must reject C1091 fixture 9 (feasible witness, unverified exclusion) as an upper bound rather than an optimum | **High** — it formalises a distinction Ergodis already draws and enforces, so failure would be visible immediately and cheaply |
| 2 | **Nategory inexact composition as the propagation rule for admission refusals** | Query admission; Evolve's structured counterexamples | A refusal recorded once propagates to every plan that could route around it, instead of being rediscovered per plan; delivers C1091's "cheapest extension" (failure-to-admit as a reusable path) | Instrument one family's admission checks so a refusal records the (model, query, scope) triple as a ban, then measure how many later admission checks in a campaign are answered from the ban set rather than re-run | Count of admission checks short-circuited over a real campaign, and zero incorrect short-circuits against a full re-check replay | **High** — the mechanism is bookkeeping, and the correctness gate (replay every short-circuit) is exact |
| 3 | **Triangle-inequality-derived bound propagation** (`L(f⨟g) ≤ L(f)+L(g)` composed with monotone maps) | `ordered_resource`; plan composition; repair scheduling | A stated law for how a bound on a composite relates to bounds on parts, which `ordered_resource` currently lacks. Directly enables A\*-style admissible lower bounds inside an exact search | Add a monotone-composition law to one ordered-resource family and use it to prune a bounded search that currently enumerates; A/B against the unpruned arm | Node/work-count reduction on the retained A/B counters, with identical exact answers on every case; no native slowdown on the unpruned path | **High** — the algebra is already in place, the missing piece is one law, and the gate is a counter Ergodis already keeps |
| 4 | **Polynomial span + semiring (integral transform)** as the normal form of a dynamic program, from Dudzik–Veličković | `OpenProblem`/`RetainedTree` semiring-window adapters; query-directed plan specialisation | Factors a plan into span shape × semiring, so one compiled span serves several queries (count, min-weight, Pareto) — C1091's "one model, several plans" with a concrete parameterisation | Express one existing DP kernel as an explicit span and re-derive two of its current readouts by changing only the semiring. Compare against the two hand-written kernels | Bit-identical results to both existing kernels, and a measured cost comparison: the shared-span version must not regress the hot loop beyond the retained allocation/layout assertions | **Medium** — the structure fits, but Ergodis' fastest kernels are specialised precisely where this abstraction generalises, and C1091 records historical leaf-fusion overhead from exactly this kind of move |
| 5 | **Bag/multiset (formal-sum) aggregation discipline** | Objective algebra; aggregation over alternative realizations | Mechanically prevents the set-vs-multiset error that C1091 fixture 3 (overlapping repairs, 3/8 not 1/2) and fixture 7 (reused mask) encode as tests | Type the aggregation step in one family as bag-valued and check that the fixtures fail to typecheck rather than failing at runtime | Fixtures 3 and 7 rejected at construction time; no change to any currently passing result | **High** — narrow, local, and the fixtures are already written |
| 6 | **Naturality declarations on operations (which of copy/delete/swap are natural)**, from Abbott–Zardini | Plan rewriting; FeatureDag lowering; shared-resource accounting | A rewrite engine that refuses unsound rewrites by construction: you may not duplicate a shared resource and treat copies as independent | Annotate the FeatureDag operation set with copy/delete naturality and attempt a small rewrite pass; verify it refuses the fixture-3 rewrite | The rewrite pass produces only plans that agree exactly with the unrewritten plan on the full differential corpus | **Medium** — the annotation is cheap; the value depends on Ergodis actually wanting a rewrite pass, which is not currently on the frontier |
| 7 | **Fusion-theorem-shaped closure property for an admitted predicate** ("property P survives composition and lifting provided X is preserved"), from Abbott–Zardini and Wilson–Zanasi's streamability | Preservation contracts across family/compiler/verifier boundaries — C1091's named central gap | Turns "this representation preserves that question" from a documented claim into a derived one, and makes a contract checkable at each composition step rather than only end-to-end | Pick one existing preservation contract (the C1095 admitted-observable one is the most self-contained) and state it as a closure property under the plan-composition operators; check it holds or find the counterexample | Either a proof for the admitted family plus a checker that validates it per composition step, or an explicit counterexample added to the rejection-fixture list | **Medium** — high value if it lands, but it is the one item here that could turn out to be false for Ergodis' actual operators, and finding that out is itself the result |
| 8 | **Constructive witness for a structural predicate** (streamability = existence of an accumulator `B` with `B(f(x),y) = f(x⊕y)`) used as an Evolve admission gate | Evolve proposal generation and admission | Evolve gets a *generator* whose admissible set is delimited by a theorem, rather than a ranked list of hand-proposed candidates — the Abbott spherical-attention pattern | Choose one Ergodis operator family with an ordered-resource accumulator; state the closure theorem; enumerate two or three untried members of the admissible family and run them | At least one generated member must pass the existing independent family checker and beat the incumbent on the retained performance gate; a generated member that fails the checker is also a result | **Medium** — the published instance produced one good design from human reading, not from search; whether generation scales is unknown, and that is what the experiment tests |
| 9 | **Lens laws as the type discipline for witness lifting** | Representation contracts; representative catalogs; quotient/catalog readouts | Gives distinct types to the three witness contracts C1091 distinguishes in prose: preserve one canonical witness / preserve the feasible set / preserve the ability to lift some valid optimum | Write the `get`/`put` pair for the existing catalog pilot and state which lens laws hold; check each against the C1091 fixtures 4, 8 and 9 | Each of the three contracts must be separately expressible, and the catalog pilot must be classifiable as exactly one of them without ambiguity | **Medium** — the formalisation is clearly right; the open question is whether it changes any decision or merely renames one |
| 10 | **Kleene least-fixed-point iteration over antichains for recursively interconnected problems**, from Censi | Campaigns with interdependent budgets; `RepairPlan` chains whose budgets depend on each other's outputs | Exact complete Pareto solutions for recursive interconnection, plus a complexity bound stated in terms of an interdependence graph property rather than raw size | Construct the smallest Ergodis case with genuinely mutual budget dependence and solve it by antichain fixed-point iteration; compare against whatever the current code does (likely: refuse, or iterate ad hoc) | Termination with the complete antichain, and agreement with brute-force enumeration on a small instance | **Medium** — the theory requires monotonicity and Scott continuity, and C1091's repricing and double-charging cautions say some Ergodis objectives will not satisfy them; establishing which families qualify is the real work |
| 11 | **Minimization-availability as a checkable property of the output category**, from Colcombet–Petrişan | `ValidatedQuotient`; the quotient-vs-catalog routing decision | Converts C1091's judgement ("coarsest quotient is not a universal objective") into a compile-time predicate that routes a family to a quotient when minimization is guaranteed and to a catalog when it is not | State the condition for two existing families — one that currently quotients successfully and one where quotients are known to fail — and check the predicate separates them | The predicate must agree with the known outcome on both families, with no hand-tuning | **Medium** — the source is about automata over words, and whether the conditions transfer to Ergodis' readout categories is genuinely open |
| 12 | **Lower-then-optimize-then-extract under a maintained structural invariant** (ZX generalised flow) | Plan compilation; FeatureDag lowering to physical plans | Permits aggressive optimization in a permissive intermediate form while guaranteeing an executable plan comes back out — the guarantee is the invariant, not a post-hoc check | Identify a candidate invariant for one plan family that certifies extractability, and test it on a lowering that currently has no optimization stage | Every optimized term must extract to a runnable plan, and the extracted plans must match the unoptimized plan exactly on the differential corpus | **Low** — the highest ceiling and the least evidence that Ergodis' plan forms admit such an invariant; ZX's flow property is specific to its calculus and took the field years to find |
| 13 | **Monad algebras as the generalisation of admitted observables beyond equivalence relations** | `ValidatedQuotient`; admitted observables; decision covers | Extends admission from "constant on classes" to "respects this structure", covering the non-equivalence cases C1091 calls out (decision covers, catalogs) | Re-express the C1095 distinguishing-pair rejection as an algebra-homomorphism check and see whether it extends to one decision-cover case that currently has no admission story | The re-expression must accept everything C1095 currently accepts and reject everything it currently rejects, before any extension is attempted | **Low** — conceptually clean and genuinely more general, but Ergodis has no worked decision-cover implementation to extend it onto, so the experiment risks being a renaming exercise |
| 14 | **Reverse derivative in a discrete category** (`POLY_{Z₂}`) as a local-update rule without gradients | Evolve parameter proposals over discrete parameters | A principled local update for discrete parameters where no gradient exists | Take one Ergodis discrete parameter currently tuned by enumeration and apply a reverse-derivative-style local update | Must match or beat enumeration's best value at lower cost on a retained benchmark | **Low** — the published evidence is Iris and two-class MNIST; there is no demonstration at any scale, and Ergodis' parameters are mostly semantic rather than numeric, which is the case C1091 says needs a new contract anyway |

**If only one thing is done:** rows 1, 2 and 3 form one coherent slice — negative information as a
first-class composable object, with the optimality certificate, the admission refusal and the
admissible bound all being instances. They share a single implementation (an expansive ban over a
preorder with a composition rule), they are the three highest-confidence rows, and each has an exact
gate. Row 3 alone is the one that could pay for itself in measured work reduction.

---

## 7. Incidental leads

Recorded with provenance, per instruction, and **not** written to the discovery track by me. None of
these is in scope for C1150 part A.

1. **Colfax Research, "Categorical foundations for CuTe layouts" (2025).** Found in the reference
   list of arXiv:2604.07242, which cites it as
   `https://research.colfax-intl.com/download/categories-of-layouts/`. Provenance: reference entry
   "Colfax Research. Categorical foundations for cute layouts, 2025." An industrial GPU-kernel team
   has published a categorical account of memory layouts. Not fetched or read. Relevant to any future
   Ergodis work on layout algebra rather than to this task.
2. **Censi, Lorand & Zardini, *Applied Compositional Thinking for Engineering* (work-in-progress
   book).** Cited in arXiv:2604.07242 as "Andrea Censi, Jonathan Lorand, and Gioele Zardini. Applied
   Compositional Thinking for Engineering. 2024. URL https://bit.ly/3qQNrdR. work-in-progress book",
   and in arXiv:2404.03224 reference [5] under the title *Applied Category Theory for Engineering*
   with the same URL. Note the two titles differ between the two consulted sources; I did not resolve
   which is current. Not fetched.
3. **The `pyncd` and `tsncd` packages (mit-zardini-lab).** Cited in arXiv:2604.07242 as
   `https://github.com/mit-zardini-lab/pyncd` and `.../tsncd`. A working implementation of the
   construction in §3.1, including PyTorch compilation and hypergraph rewriting, in Python and
   TypeScript. Not inspected. Relevant if anyone wants to see how the term algebra is actually
   represented before designing an Ergodis analogue.
4. **Shulman's "proofs and refutations" work.** Cited in arXiv:2207.13589 as reference [8] and
   described there as an early influence, with the intuitionistic identity
   `P(X → Y) = (P(X) → P(Y)) × (R(Y) → R(X))`. I did not retrieve the bibliographic entry itself.
   Potentially the cleanest statement of the positive/negative duality for anyone pursuing absorption
   row 1.
5. **Wilson & Zanasi have two further papers on differentiable polynomial circuits** — "An axiomatic
   approach to differentiation of polynomial circuits", *Journal of Logical and Algebraic Methods in
   Programming* 135:100892, 2023, and "Categories of differentiable polynomial circuits for machine
   learning", ICGT, LNCS 13349, pp. 77–93, Springer, 2022. Provenance: reference list of
   arXiv:2404.00408, entries [60] and [61]. Not read. These are where the discrete-derivative theory
   went after arXiv:2101.10488 and would be the place to look before attempting absorption row 14.
6. **A prior session already cached two sources this study needed.** `arXiv:1712.07121` (functorial
   automata minimization) and `arXiv:2012.01847` (string diagram rewrite theory) were both already in
   the shared literature cache when I looked. I do not know which task fetched them. Worth noting
   because it means some categorical material has been touched in this collection before, and the
   read-depth records for it live in whatever report did that, not here.

---

## 8. Method, verbatim queries, and coverage

### 8.1 Boundary

No deliverable in this report depends on the absence of prior work. There is no novelty verdict, no
priority claim, no forward-citation closure and no pre-emption check here; the deliverable is a
positioning study whose conclusions are about what to try, not about what is new. Under
`notes/literature-audit-conventions.md` § Boundary, the full apparatus therefore does not bind — but
the **Attribution** section binds regardless, because this report characterises sources, and the
read-depth field is applied unconditionally to every source named, including every source named only
to be set aside. The two negatives I do state (§4.5 and §5.6) are recorded with their queries and
their outcome type so that a later reader can judge their strength; neither carries any weight beyond
"I looked here and did not find it".

### 8.2 Source ledger by read depth

**Full text: 2 of 21 named sources.**

- Full text (2): `arXiv:2604.07242`, `arXiv:2404.03224`.
- Partial (14): `arXiv:2402.05424`, `arXiv:2404.00249`, `arXiv:2412.03317`, `arXiv:2505.09326`,
  `arXiv:2207.13589`, `arXiv:2402.15332`, `arXiv:2203.15544`, `arXiv:2306.15632`, `arXiv:1512.08055`,
  `arXiv:2404.00408`, `arXiv:2101.10488`, `arXiv:2105.06332`, `arXiv:1902.03178`, `arXiv:1712.07121`.
- Abstract/metadata only (5): `10.1007/978-3-031-65572-2_13` (also a could-not-access outcome),
  `arXiv:2106.07032`, `arXiv:1910.07065`, `arXiv:2012.01847`,
  `10.1007/978-3-030-99336-8_1`.
- Review only, secondary only: none.

The full-text count is deliberately low relative to the source count: the task budgeted 12–20 sources
read at depth, and the two documents the task made load-bearing — the named primary source and the
one Abbott paper that turned out to bear directly on exact optimization — were read end to end, with
the rest read to the depth needed to state what structure they supply and what it costs. Every
section-level claim above names the sections it rests on.

### 8.3 Verbatim load-bearing queries

arXiv author enumeration (both **failed**, and the failure is why OpenAlex carries the enumeration):

```
curl -sG 'http://export.arxiv.org/api/query' --data-urlencode 'search_query=au:"Abbott_V"' \
  --data-urlencode 'start=0' --data-urlencode 'max_results=60' \
  --data-urlencode 'sortBy=submittedDate' --data-urlencode 'sortOrder=descending'
      -> HTTP 301, zero bytes

curl -sL -G 'https://export.arxiv.org/api/query' --data-urlencode 'search_query=au:"Vincent Abbott"' \
  --data-urlencode 'max_results=60' --data-urlencode 'sortBy=submittedDate' \
  --data-urlencode 'sortOrder=descending'
      -> body "Rate exceeded." (14 bytes)
```

OpenAlex (all succeeded; empty vs error distinguished by HTTP 200 plus a well-formed
`meta.count` field):

```
https://api.openalex.org/works?filter=raw_author_name.search:Vincent%20Abbott&per-page=50&mailto=tavisrudd@damnsimple.com
      -> meta.count = 275; screened to 2 seed records (see §3.2)
https://api.openalex.org/works?filter=author.id:A5064852905&per-page=50&mailto=tavisrudd@damnsimple.com
      -> meta.count = 10; this is the Abbott corpus of §3.2
https://api.openalex.org/works/https://doi.org/10.1007/978-3-031-65572-2_13?mailto=tavisrudd@damnsimple.com
      -> record present; no abstract_inverted_index
https://api.openalex.org/works?search=reverse+derivative+ascent+boolean+circuits&per-page=8&mailto=...
https://api.openalex.org/works?search=categorical+regularization+model+complexity&per-page=8&mailto=...
https://api.openalex.org/works?search=categorical+dynamic+programming+optimization&per-page=8&mailto=...
https://api.openalex.org/works?search=minimum+description+length+category+theory+functor&per-page=6&mailto=...
https://api.openalex.org/works?search=compositional+inductive+bias+without+neural+networks&per-page=6&mailto=...
https://api.openalex.org/works?search=operad+search+space+program+synthesis&per-page=6&mailto=...
https://api.openalex.org/works?search=string+diagram+rewriting+optimisation+e-graph&per-page=6&mailto=...
```

Crossref (succeeded; empty vs error distinguished by HTTP 200 and a `message.total-results` field):

```
https://api.crossref.org/works/10.1007/978-3-031-65572-2_13?mailto=tavisrudd@damnsimple.com
      -> record present, no `abstract` field
https://api.crossref.org/works?query.bibliographic=category+theory+regularization+inductive+bias&rows=8&mailto=...
      -> total-results 2194458, a loose full-text match; nothing category-theoretic in the top 8
```

Semantic Scholar (one DOI lookup succeeded; **both title searches failed**):

```
https://api.semanticscholar.org/graph/v1/paper/DOI:10.1007/978-3-031-65572-2_13?fields=title,abstract,year,venue,authors
      -> record present; abstract null with an explicit publisher-elision notice; openAccessPdf.status CLOSED
https://api.semanticscholar.org/graph/v1/paper/search?query=Vincent+Abbott+neural+circuit+diagrams&fields=title,year,authors,externalIds,venue&limit=10
      -> no `data` key returned; on re-run the service answered HTTP 429 "Too Many Requests"
https://api.semanticscholar.org/graph/v1/paper/search?query=category%20theory%20regularization%20model%20complexity&fields=title,year,venue&limit=5
      -> HTTP 429 "Too Many Requests"
```

### 8.4 Coverage statement

**Searched and found nothing** (licenses the two stated negatives, at the strength the queries
support):

- No categorical-deep-learning work that states its results without networks and gradients (§4.5.1),
  over the OpenAlex searches above plus the reference lists of `arXiv:2402.15332`, `arXiv:2203.15544`
  and `arXiv:2404.00408`, which I read.
- No categorical structure assigned to proposal ordering or search-prior construction (§4.5.2), same
  coverage.
- No categorical account of regularization or model-complexity control (§5.6), over OpenAlex and
  Crossref. Stop condition: three distinct phrasing families ("categorical regularization / model
  complexity", "minimum description length category theory functor", "category theory regularization
  inductive bias") each returning only statistics-sense "categorical" results.

**Could not access** (licenses nothing; carried forward as open gaps):

- **`10.1007/978-3-031-65572-2_13`, Abbott, Xu & Maruyama, *Category Theory for Artificial General
  Intelligence*.** Closed access at Springer; no abstract exposed by OpenAlex, Crossref or Semantic
  Scholar; no arXiv preprint in the author's listing. This is the one Abbott paper whose subject is
  general intelligence rather than deep-learning notation, so the corpus characterisation in §3.2 is
  incomplete in exactly the place most likely to matter for Evolve.
- **Semantic Scholar title search**: rate-limited (HTTP 429) on every attempt. The corpus enumeration
  therefore rests on OpenAlex plus the reference lists of two Abbott papers, not on three independent
  services. Nothing here depends on a citation count, so this does not invalidate a verdict, but a
  later task that needs a forward-citation set must not treat §3.2 as a screened citing-works set.
- **arXiv author API**: rate-limited. Same consequence.
- **MathSciNet: NOT COVERED.** Institutional authentication required and unreachable from this
  session. Nothing in this report is gated on it, since no absence claim here is load-bearing.
- **zbMATH Open: not queried.** Freely reachable and simply not used; recorded so that a later reader
  does not assume it was.

**Figures.** Several of the most important sources (`arXiv:2404.03224` above all, with twenty
figures; also `arXiv:2412.03317` and `arXiv:2604.07242`) carry a large share of their argument in
diagrams that `pdftotext` does not recover. Where a claim rests on a figure, I have characterised it
from the caption and surrounding prose and said so at the point of use. No diagrammatic derivation in
this report was checked against the diagram itself.

**Caching.** Every PDF fetched for this study was added to the shared literature cache at
`/tmp/persistent/tavis/lit-search/` with its key and SHA-256; the hashes appear inline with each
source above. Two keys (`arXiv:1712.07121`, `arXiv:2012.01847`) were already present from earlier
work and were not re-fetched; for `arXiv:2012.01847` the cache refused my duplicate add, so the bytes
I read are the previously cached ones (sha256 beginning `241e36b151698ea7`) and I did not compare
them against a fresh fetch. Cache presence records fetched bytes only and is never evidence of
reading; the read-depth fields above are the record of what was read.
