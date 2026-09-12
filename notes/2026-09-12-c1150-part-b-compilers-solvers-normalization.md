# C1150 part B — categorical structure in compilers, solvers, normalization and certificates

**Date:** 2026-09-12. **Lane:** `ergodis`. **Disposition:** reading and positioning study.
No code was written and nothing under `~/src/ergodis*` was edited.

## Opening summary

This is part B of a two-part categorical-literature study for Ergodis, covering four sweep
themes: compiler design, solvers, normalization and evolution, and certificates and verification.
Part A (a sibling agent) covers Vincent Abbott's diagram papers, categorical deep learning and
cats4ai search priors, and optics/Para-style categorical optimization; those are deliberately
absent here.

**Twenty-six named sources. Two were read at full text** — Elliott's "Compiling to Categories"
and Bakirtzis and Topcu's two-page "AlgebraicSystems" position paper. Eighteen were read at
partial depth with the specific sections recorded, five at abstract or metadata only, and one
(the Categorical Abstract Machine) at secondary only through Elliott's related-work section. The
full tally and the coverage statement are in §6. This is a positioning study, not a novelty or
priority verdict: no conclusion here depends on the absence of prior work, and the single absence
claim I do make — no categorical treatment of evolutionary operators was located — rests on web
search alone and is carried forward as an open gap rather than a verdict.

**What the sweep found.** The four highest-value levers are all small, bounded and concrete, and
three of them return a usable answer whether they succeed or fail.

1. **Ergodis's `FeatureDag` simplifier can be given, or denied, a defensible canonical-form claim
   by a single offline graph check.** Suciu, Wang and Zhang's weak term acyclicity is a purely
   syntactic condition on a rewrite rule set — no input data, no runtime — and their Theorem 46
   upgrades it from "terminates" to "converges in polynomially many steps." Ergodis's identity
   list is small and fixed. Either the check passes, and the claim becomes defensible, or it
   fails and names the offending identity.
2. **Ergodis's min-plus verifier is a semiring computation written against exactly one semiring,
   and the literature says the algorithm does not depend on that choice.** Green, Karvounarakis
   and Tannen's Proposition 3.5 and Theorem 4.3, Little, He and Kayas's tupling construction, and
   Baril, Couceiro and Lagerkvist's certificate-to-semiring extension together mean that Ergodis's
   three distinct witness contracts — one canonical witness, the whole feasible set, the ability
   to lift some optimum — can be three instantiations of one generic checker rather than three
   checkers. Their ∆-product additionally answers the min-cost *counting* readout that C1093's
   repair family already exposes.
3. **Mohri's weight pushing plus unweighted minimization gives a linear-time canonical form for
   exactly the acyclic tropical structure Ergodis's summary trees have.** Acyclicity is what makes
   the twins property hold for free, and Ergodis's summary structure is a tree by construction.
   This is the cheapest single item in the report.
4. **The contract Ergodis's representative catalogs need already has a working proof format, and
   it is not the obvious one.** VIPR-style certificates verify only reasoning that preserves every
   feasible solution; VeriPB's redundance-based strengthening rule verifies the stronger and more
   useful contract — a transformation may discard feasible solutions provided one optimum
   survives — by exhibiting a witness substitution `ω` plus a proof that `ω` does not worsen the
   objective. That `ω` is precisely C1091's "witness lift."

**Two structural diagnoses.** First, every boundary between Ergodis's model views currently
carries a prose sentence saying the crossing is *not* discharged — the summary leaf does not
establish that it lowers the source model, `CompositionShape` does not validate algebra or query
preservation, lowering does not transfer proof authority into `PlanSpec`. Bakirtzis and Topcu's
horizontal/vertical distinction names this exactly: Ergodis has horizontal composition everywhere
and vertical composition nowhere. Second, Ergodis's plural-preservation-contract spine is an
indexed family of categories, and the two formalisms that already express such a family —
decorated cospans for contracts that compose, operad algebras for contracts that aggregate
bottom-up over a fixed shape — are worth using as design vocabulary well before they are worth
implementing.

**What I recommend against.** Adopting string diagrams as an IR (Ergodis's term DAG is Cartesian,
the easy case, and pays none of the cost that machinery removes), adopting open games (single-agent
optimization under information constraints is not a strategic game; take only the interface
lesson that decision covers need bidirectional morphisms), and building any general framework
before the four bounded experiments above have been run.

Prior art informs; it never gates. Nothing in this report argues that an Ergodis direction is
blocked because something similar exists elsewhere, and several absorption rows are worth doing
precisely because someone else has already paid the design cost.

## Ergodis objects a categorical lever could touch

Extracted from `notes/ergodis-architecture-context.md`, `~/src/ergodis/docs/glossary.md`,
`~/src/ergodis/docs/scalar-plan-semantics.md`, `~/src/ergodis/docs/language-semantics.md`,
`~/src/ergodis/docs/summary-transitions.md`, `~/src/ergodis/docs/observable-admission.md`, and
`notes/2026-09-07-c1091-core-semantic-contracts.md`. Objects are named as Ergodis names them;
my own characterisation of what each object *is mathematically* is marked as mine.

### O1. Plan compilation: source → logical IR → physical plan

Three levels with explicit boundaries (`language-semantics.md` table): plan text / expression
JSON / bytecode JSON as **source**; `PlanSpec` + `PlanOp` as the **logical IR** (a named,
scoped scalar predicate or score over integer feature fields, carried as a nonempty post-order
program); `CompiledPlan` and private compiled operations as the **physical plan** (checked
fields, types, bounds, implementation-specific fast forms). The compiler may fuse field/constant
comparisons into a small predicate truth table, and those physical forms must preserve the
logical semantics. Tracing uses unfused operations and "is not a second language."

The compiled-plan hash binds logical `PlanSpec` syntax under the current implementation only —
not field-schema order, compiler version, feature-extractor semantics, or target. Callers must
bind those contexts separately.

*My characterisation:* this is a three-stage translation with a declared semantics-preservation
obligation at each stage and an explicit statement that the identity of a stage's artifact does
not carry the ambient context. That is exactly the shape a functorial-semantics framing
addresses, and exactly the shape where a naive "same hash ⇒ interchangeable" reuse rule breaks.

### O2. FeatureDag lowering

`FeatureDag` nodes are **canonical hash-consed operations in topological order**; `FeatureId`
denotes the canonical node order. Node forms: Input, Constant, Add, Sub, Mul, Mod, Abs,
GaussianNorm, EisensteinNorm. Arithmetic is checked signed arithmetic; **overflow is an
evaluation error**. Whole-DAG evaluation returns the topologically ordered vector of *all* node
values, not a selected root. Snapshot restoration verifies canonical topological construction,
and **simplification uses only universal algebraic identities, never observed corpus data**.

`feature_term_program` lowers one selected supported root into `PlanOp` without recursion. The
documented gap is sharp and load-bearing: lowering is *not* unconditional error equivalence,
because whole-DAG evaluation evaluates every node while lowering follows only the selected
root's dependencies, and a simplification can discard an expression that would have failed.
Lowering does not transfer DAG identity, sharing, degree, feature provenance or proof authority
into `PlanSpec`.

The stated preservation obligation for future optimizations: a rewrite of a strict `PlanSpec`
program must preserve **both its result and its error domain** on in-scope rows, not merely
equality of the corresponding unbounded-integer polynomial. A weaker contract must declare its
input-domain precondition.

*My characterisation:* hash-consing with canonical node order is congruence closure over a term
signature — the same data an e-graph maintains, minus the equivalence-class union and minus the
extraction step. And "preserve result *and* error domain" is precisely the statement that the
denotation lands in a partiality (Maybe/exception) monad rather than in Set, so the sound
rewrite rules are the ones valid in the Kleisli category, not the ones valid for total integer
polynomials. Whole-DAG versus selected-root is a second, independent observation boundary and
Ergodis already tests it as such.

### O3. Quotients, representative catalogs, contexts, admitted observables

`ValidatedQuotient::new` checks a compiled quotient against a supplied `FinitePresentation`
using the core compilation verifier; the handle then admits concrete-state-indexed `u32`
observation tables, and admission succeeds **exactly when each table is constant within every
quotient class**. Rejection returns two concrete states in the same class with different
requested outputs. The compilation checker verifies that declared generators induce well-defined
class transitions, so an admitted readout agrees with the concrete readout after every
well-typed generator sequence. **No quotient minimality for the new observable is claimed** —
reusing an existing quotient can retain extra classes.

The glossary marks the general **quotient** contract as planned: "a transformation that
identifies equivalence classes or other fibres with explicit cost and witness-lifting
obligations. Not every filter is a quotient."

C1091 corrects "coarsest quotient" as a universal objective, and separates four representation
contracts that are *not* quotients: **representative catalogs** (preserve the same optimum over
a retained family collectively, without merging individual witnesses), **Pareto/resource
envelopes**, **event circuits**, and **decision covers / policies**. It also records that
approximate closeness need not be transitive, so pairwise ε-closeness does not yield a valid
quotient.

*My characterisation:* `ValidatedQuotient` + `AdmittedObservable` is the Myhill–Nerode situation
made executable — a congruence on a deterministic presentation, plus a factorization test for
whether a given output map descends through it. The "not minimal" caveat is the statement that
Ergodis computes *a* quotient through which the observable factors, not the *initial* such
quotient. Representative catalogs are the interesting case precisely because they are not
quotients: they are a lower-envelope-preserving subobject, not a coequalizer.

### O4. Admission checks

Glossary: **admission** is "permission to use a particular candidate for a particular problem
and scope"; core `Admission` wraps a **verified restriction** (an opaque result from the
independent finite verifier binding one coordinate restriction to one problem) and binds
candidate provenance separately. A **receipt** is a serialized account of an admission check —
"deserializing it cannot create `Admission`." **Query admission** checks that a representation
supports a particular question and its assumptions; rejection is not a false answer.

C1091's cheap-extension finding: make *failure to admit a query* a structured, reusable
counterexample path (distinguishing context, failed lift, violated assumption, uncovered source
case, incompatible information state) feeding Evolve, clients and durable records.

*My characterisation:* admission handles are an opaque-token discipline — a proof-relevant
"there exists a morphism" witness that cannot be forged by producing a value of the right type.
The structured-rejection direction is the request that the negative case also be proof-relevant.

### O5. Certificates and independent verification (min-plus summary transitions)

`ergodis-verify::min_plus_transition` checks a fixed 4×4 **min-plus** summary format with
SHA-256 backend 1, with no optimizer dependency, implementing composition and authenticated tree
replay itself. Costs use bounded arithmetic: `u32::MAX` denotes absence and finite sums
**saturate** to that sentinel — explicitly *not* an unbounded-integer min-plus guarantee. A
delta must name the current artifact, root, sequence and real leaf; the old leaf and every
sibling summary/digest must match the retained authenticated state before the leaf and its
root path are replaced. The verifier retains both node summaries and digests (memory linear in
padded tree size, logarithmic transition work) because a composed value can mask a changed
sibling summary.

Explicit scope limits: a successful check establishes composition of the supplied initial
summaries and subsequent authenticated replacements. It does **not** establish that a domain
event produced the new leaf, that an initial leaf correctly lowers the source model, or that a
root cost proves domain optimality. Equal summaries can come from different source models or
events. Schema `ERGGSN01` snapshots / `ERGGDL01` deltas for `min-plus-matrix`; "other algebras
and hash backends require other checkers."

*My characterisation:* this is a monoid homomorphism from a tree of leaf updates into the
min-plus (tropical) semiring of 4×4 matrices, authenticated by a Merkle structure, with the
saturating `u32::MAX` making the carrier a *bounded* tropical semiring rather than the usual
one. The stated "other algebras require other checkers" is the parametricity gap: the checker is
written against one semiring instead of against the semiring interface.

### O6. Campaigns, runs, records, bundles

**Campaign** = an investigation developing candidates, checking them and running solves under
goals and budgets; **run** = the planned unit of persisted execution with its own history and
result; **run record** = immutable boundary with RunId, spec reference, sequence, source and
artifact references, and typed predecessor or fork linkage; **lineage DAG** (planned) = bounded
acyclic history with typed predecessor, fork and replay links, where evidence dependencies have
their own edge meanings; **run bundle** = a bounded portable container that checks included
content and parent links and reports missing dependencies. Git analogy is explicitly limited:
unqualified **merge** must not imply that two runs' correctness claims combine automatically.

### O7. Repair schedules, kicks, tabu / neighbourhood search

`RepairModel → RepairPlan → BudgetQuery` (C1093, private LRC adapter): compile once, admit
budget changes, then count / threshold / witness readouts over a fixed known repair family;
"no universal recovery schema." Native execution includes repair scheduling and separately
launched controlled searches. Glossary keeps **search mode** (ProofGenerating vs Heuristic) as
the execution's evidence obligation, independent of origin, package visibility and plan role.

*(Tabu/kick specifics are not exposed in the public docs I was given; I treat the neighbourhood
operator and its restart/perturbation schedule as the object, and mark any claim about their
current implementation as not verified here.)*

### O8. Evolve proposal ordering and admission

Evolve is "an autonomous system for discovering useful structure, representations, theorems and
parameters"; quotient minimization is one strategy, not its definition. Its optimization target
includes compilation, queries, updates, verification and memory, and it may select direct
solving, partial compilation or an unminimized representation. Delivered state: bounded WASM
Evolve with **shared ranked Rust/WASM proposals and independent family checkers**, separate
discovery workers, checked capacity bounds, Hadamard row relations and CSS source symmetries
applied to active execution at declared safe points as well as queued queries; learned-only
reruns recheck retained proofs with discovery off.

C1091's loop: propose a representation **and its claimed preservation/update contract**, search
for structure, challenge the contract, admit at the appropriate evidence level. Candidate kinds
include decompositions, symmetry actions, signatures, catalogs, relaxations, rewrite rules and
execution strategies. Evolve's search domain also includes **questions and designs**, not only
algorithms for a fixed question, and C1091 separates strategy search, question design, and
source-design synthesis.

### O9. The plural-preservation-contract spine

C1091's strongest architectural consequence: **different representations preserve different
questions, under different contexts and quantifiers, and a representation must carry the
contract that licenses its use.** The contract table pairs each representation kind with its
preservation obligation and required boundary. Witness equality is itself plural: preserving one
canonical witness, preserving the feasible witness set, and preserving the ability to lift some
valid optimum are three different contracts.

*My characterisation:* this is the single most category-shaped statement in the Ergodis corpus.
"A representation carries the contract that licenses its use" is the definition of an object in
a category whose morphisms are contract-respecting maps, and "different representations preserve
different questions" is the statement that there is no one such category but an indexed family
of them. Any absorption proposal below is judged against whether it makes that indexing
executable rather than decorative.

---

## 1. Compiler design: functorial compilation, lowering, and rewriting as a category

### 1.1 Compiling to categories (Elliott)

**Conal Elliott, "Compiling to Categories", Proc. ACM Program. Lang. 1, ICFP, Article 27
(September 2017), 27 pages, DOI 10.1145/3110271.** *Read depth: full text* — author's PDF at
`conal.net/papers/compiling-to-categories/compiling-to-categories.pdf`, cached as
`conal-elliott-2017-compiling-to-categories`, SHA-256
`950b8cd0118ab75ec72719024cb963f3a27af916e3ca23af797c386422cc0f7a`, 27 pages; read end to end
(§§1–13 and Appendix A). Only this ICFP version was read.

Elliott's starting point is Lambek's result that the models of the simply typed λ-calculus are
exactly the cartesian closed categories, with a compositional syntactic translation from the
λ-calculus into CCC vocabulary. He turns that into a GHC plugin: a pseudo-function
`ccc :: (a → b) → (a ‘k‘ b)` whose applications are pushed inward by rewrite rules until they
disappear, run inside GHC's own simplifier so that ordinary optimisation interleaves with the
translation. One Haskell definition is then interpretable in many categories: computation graphs
compiled to Verilog, linear maps, automatic differentiation, incremental computation, interval
analysis, entailments between type constraints, polynomials, and a purely syntactic category used
for debugging. Each interpretation is "a (possibly closed) cartesian functor", and the
homomorphism equations (`H id ≡ id`, `H (g ∘ f) ≡ H g ∘ H f`, `H (f △ g) ≡ H f △ H g`,
`H (curry f) ≡ curry (H f)`, and so on) *are* the rewrite rules that change categories.

Five specific mechanisms in the paper bear directly on Ergodis and are the reason I read it in
full rather than skimming.

**Constrained categories (§6).** The naive `Category` class is "too simplistic for many useful
target categories" because different categories restrict which types can be objects. Elliott adds
an associated constraint `type Ok k a :: Constraint` to the `Category` class and threads it
through every operation's signature (`(∘) :: Ok₃ k a b c ⇒ …`). Hardware generation needs
representability as collections of wires; differentiation needs vector-space structure.

**Products of categories (§7.3).** `data (p ⊗ q) a b = p a b ⊗ q a b`, with every categorical
operation acting componentwise, so that one translation yields two interpretations at once — his
example is a graph *and* its syntactic form. "Why give only one interpretation to a functional
program when we can give two?"

**Unboxing and reboxing (§10.1).** The bulk of §10 is about keeping GHC's unboxed numeric
representations while still translating to categories: find applications of boxing constructors,
replace them by late-inlining synonyms, apply reboxing rules pushing the synonym inward
(`boxI (u +# v) = addC (boxI u, boxI v)`), then eliminate the unboxing case scrutinees. The
result has only category-generalised numeric operations, boxed variables, and boxing synonyms on
literals.

**Translation without closure (§10.2).** For categories that are cartesian but not cartesian
closed — his example is vector spaces with linear maps — one converts first in the closed `(→)`
category and then eliminates `apply`, `curry`, `uncurry` using laws such as
`apply ∘ (curry (g ∘ exr) △ f) = g ∘ f`. He notes this works provided no primitive operation
involves exponentials in its type, "which seems a harmless restriction."

**Costs, stated by the author (§12).** "Compilation to categories is costly for large
computations, with a great deal of inlining, simplification, translation to CCC form, and
conversion to alternative categories", and the cost is paid redundantly for every use of a
top-level definition. His earlier plugin supported **separate compilation** by emitting, for each
top-level binding, a rewrite rule `ccc (f @v₁ … @vₙ) = ccc rhs`, but "it is not so clear how to
adapt this scheme to support multiple categories, including ones not yet defined when a library
module is compiled." Recursive definitions can make repeated inlining non-terminating, though
recursion is explicit in GHC Core and could be routed to a categorical fixed-point interface.
Separately, monomorphisation "does not always have a finite result" under polymorphic recursion,
so the translation sometimes fails to terminate.

He also records the contrast with deep embedding (§13): a deep embedded DSL loses sharing and
must recover it by common-subexpression elimination, "an awkward and expensive phase"; compiling
to categories never loses sharing because it never leaves the host compiler's representation.

**The Categorical Abstract Machine**, via Elliott's §11. *Read depth: secondary only* — I did
not read Cousineau, Curien and Mauny (1987) or Curien's categorical combinators (1986); the
characterisation here is Elliott's, in his related-work section, at the full-text depth recorded
above. He describes the CAM as "an execution model for terms from the language of cartesian closed
categories", emerging from Curien's categorical combinators and used as the basis of an
implementation of the Caml dialect and of ML, and states that it "does not appear to have been
used to give multiple CCC-based interpretations (each with its own semantics and notion of
execution)." That distinction — one execution model versus many interpretations of one
translation — is the whole point for Ergodis, so it is worth carrying accurately.

**Mapping to Ergodis.** Elliott's structure is the exact shape of O1/O2 with one part missing.
Ergodis already has the source language, the logical IR (`PlanSpec`/`PlanOp`), and several
interpretations of the same term: `FeatureDag::evaluate` (whole-DAG, checked integers),
`feature_term_program` lowering (selected root), `CompiledPlan::evaluate_row` (fused physical
form), the Python reference evaluator `python/plan_semantics.py`, and the unfused tracing form.
What is missing is any statement that these are *the same functor applied to different targets*.
Today the agreement between them is established by a conformance corpus — 1,984 deterministic
rows in `tests/feature_lowering_semantics.rs`, plus `tests/plan_semantics.rs` against the Python
oracle — rather than by construction.

Four mappings, all mine:

1. **`Ok k a` is query admission.** Ergodis states the same requirement without a mechanism:
   "a matrix from space A to B differs from an equally sized matrix from C to D", "equal
   dimensions or matching serialized byte counts cannot authorize composition or cache reuse",
   and query admission is "checking that a representation supports a particular question and its
   assumptions." Elliott's constrained-category pattern is the type-level form of exactly this —
   the target declares which objects it admits, and the constraint is carried by every composition.
   It does not replace Ergodis's runtime admission (which validates data, not types), but it is
   the right shape for the *static* half, and the two are complementary.

2. **`k ⊗ k'` retires the "tracing is not a second language" worry structurally.** Ergodis's
   documentation has to *assert* that tracing "cannot affect result, scope, or authority" and
   that the unfused diagnostic form agrees with the fused physical form. In the product category,
   a single translation produces both arms and they cannot diverge, because both are built by the
   same componentwise operations. The same construction is how Ergodis could carry a physical
   plan and a cost/coverage account together with no second traversal.

3. **The partiality gap is real and Elliott does not cover it.** Ergodis's target is *partial*
   (overflow is an evaluation error) and its two evaluators differ in which subterms they force —
   whole-DAG evaluation can fail where selected-root lowering succeeds. A cartesian functor into
   total functions cannot express that. The correct target is a Kleisli category for a
   partiality/error monad, and the whole-DAG-versus-selected-root split is then a strictness
   difference between two Kleisli interpretations rather than a defect in either. Elliott's
   `Graph` category is itself Kleisli-like over a state monad, so the pattern is present; the
   error-monad instantiation is not. Ergodis's `scalar-plan-semantics.md` already states the
   obligation in the right terms — "preserve both its result and its error domain on in-scope
   rows" — which is why I treat this as a naming-and-typing lever rather than a research problem.

4. **The cost gate is named by the author and it is the one Ergodis cares about.** Ergodis's
   binding direction forbids accepting native slowdown as the price of abstraction. Elliott's
   §10.1 is direct evidence that category-generalised compilation and unboxed hot representations
   coexist — the reboxing machinery exists precisely to keep them together — and §10.2 shows the
   non-closed cartesian mode, which is the relevant one since `PlanSpec` has no higher-order
   operations. But §12 says the *compile-time* cost is significant and that separate compilation
   across multiple target categories was not solved. For Ergodis that is the gate to measure:
   compiler and checker costs count in end-to-end measurements by its own rule, so the experiment
   must time compilation, not just execution.

### 1.2 E-graphs and equality saturation, categorically

Ergodis's `FeatureDag` is hash-consed with canonical node order, and its simplifier "uses only
universal algebraic identities, never observed corpus data." That is congruence closure over a
term signature without the equivalence-class union and without extraction — i.e. the substrate of
an e-graph with the e-graph's distinguishing feature removed. Three sources bear on what adding
that feature would and would not buy.

**Aleksei Tiurin, Chris Barrett, Dan R. Ghica, Nick Hu, "Equivalence Hypergraphs: DPO Rewriting
for Monoidal E-Graphs", arXiv:2406.15882v2 [cs.LO], 20 May 2025.** *Read depth: partial* —
arXiv PDF, cached as `arXiv:2406.15882`, SHA-256
`a9cecd93c8b793a4f397ac270cae0d65ec6e9ce78dda63c3e3c666060238b2c3`, 39 pages; sections read in
full: abstract, §I Introduction (including §I.A E-graphs, §I.B Semilattice-enriched categories,
§I.C Combinatorial representation), the soundness-and-completeness statement, and §VII
Conclusion. The DPO boundary-complement machinery in §V–VI and Appendices A–F was skimmed only,
so I do not rely on its details.

The result: e-graphs over an algebraic theory correspond to morphisms of **Cartesian categories
enriched over the category of semilattices**. The semilattice enrichment is the whole trick — the
semilattice's binary operator lets you form formal non-empty joins `f₁ + … + fₙ : A → B` of
parallel morphisms, and that join *is* the e-class structure. The Cartesian structure is what
expresses arbitrary sharing; dropping to merely monoidal structure still supports the full
e-hypergraph rewriting theory, which is how the paper generalises e-graphs from algebraic to
monoidal theories. They then give a combinatorial representation — hierarchical hypergraphs with
"e-boxes", called e-hypergraphs — forming a category `EHyp(Σ)` with coproducts (disjoint union)
and an initial object (empty e-hypergraph), and specify rewriting by an extension of double
pushout (DPO) rewriting. Their soundness and completeness statement is that morphisms in the free
semilattice-enriched symmetric monoidal category are equal **iff** there is a sequence of DPO
rewrites between their combinatorial representations, each induced by a structural equality or by
the monoidal theory. The representation deliberately "factors out the structural SMC equations
while remaining sensitive to the complexity-relevant equations induced by the enrichment."
Declared future extensions: functorial boxes (for Cartesian closure), ZX-calculus spiders, and
trace — the last of which they note conventional e-graphs already use to encode infinite
equivalence classes.

**Dan Suciu, Yisu Remy Wang, Yihong Zhang, "Semantic foundations of equality saturation",
arXiv:2501.02413v1 [cs.PL], 5 January 2025.** *Read depth: partial* — arXiv PDF, cached as
`arXiv:2501.02413`, SHA-256
`99bbc4173e98f76280fa83c1150776f0da0fbfce8ee28ddbc9d301ab4f6467a2`, 31 pages; read in full:
abstract, §1 Introduction and the complete "Our contribution" statement of results, §6 on weak
term acyclicity with Examples 34–35, §7 Conclusion, and Appendix E's Definition 45 and Theorem 46
with its proof sketch. The tree-automaton development in §3, the chase correspondence in §4 and
the undecidability reductions in §5 were read only through their statements in §1.

This is the automata-theoretic rather than the categorical account, and it is the more directly
useful of the two for Ergodis. An E-graph is defined as a **reachable deterministic tree
automaton with possibly infinitely many states**: automaton states correspond to e-classes,
transitions to e-nodes, and a term is represented by the E-graph iff accepted by it as a standard
tree automaton. They prove that **between any two E-graphs there is at most one homomorphism**,
so E-graphs are rigid tree automata. Equality saturation is then defined as the least fixpoint of
an immediate consequence operator; the fixpoint always exists and is unique even when the
procedure does not terminate. Their **Finite Convergence Lemma** says that if the least fixpoint
is finite then the procedure converges in finitely many steps — non-obvious because e-matching
and insertion grow the E-graph while congruence closure can shrink it, and the authors note the
analogous statement *fails* for tuple- and equality-generating dependencies. They then connect
equality saturation to the database chase in both directions, characterise "EGD-fair" chase
sequences, and give the termination trichotomy: single-instance termination is R.E.-complete,
all-term-instance termination is Π₂-complete, all-E-graph-instance termination is undecidable
with the exact upper bound open. §6 gives a sufficient syntactic criterion — **weak term
acyclicity**, after the classical weak acyclicity of Fagin et al. — under which equality
saturation terminates on all input E-graphs.

The criterion itself (their Definition 45) is a check on a finite graph built from the rule set
alone, with no reference to any input. Nodes are **positions** `(f, i)` — argument `i` of symbol
`f`. For each rule `lhs → rhs`: for each variable of `rhs`, add ordinary edges from each of its
positions in `lhs` to each of its positions in `rhs`; and for each proper non-variable
sub-pattern `p` of `rhs` that does **not** occur in `lhs`, add **special** edges from each
position of each variable of `p` in `rhs` to each position of `p`. The rule set is weakly term
acyclic when no cycle contains a special edge. **Theorem 46**: a weakly term acyclic rewriting
system makes equality saturation converge in a number of steps **polynomial in the size of the
input E-graph** — not merely finite. The proof ranks positions by the maximum number of special
edges on an incoming path and bounds, by induction on rank, the number of distinct e-classes that
can appear. They note the criterion is strictly more powerful than translating the rules to
dependencies and applying classical weak acyclicity, because a sub-pattern of `rhs` that already
occurs in `lhs` introduces no new e-class, and because functional dependencies pin the e-classes a
pattern can reach to those determined by its own variables.

**Glenn Sun, Yihong Zhang, Haobin Ni, "E-Graphs as Circuits, and Optimal Extraction via
Treewidth", arXiv:2408.17042v2 [cs.DS], 14 November 2024.** *Read depth: abstract/metadata only*
— arXiv PDF already in the cache (fetched 2026-09-02), SHA-256
`c5fce6d0d3d8d208fd2e068aeb32d260d3312f1bb78436966c969017ae309673`, 16 pages; abstract and the
opening of §1 were read, nothing further. Recorded because it fixes the cost of the extraction
step: e-graph extraction is NP-hard (they cite Stepp 2011), practice uses greedy extraction or
integer linear programming, and their contribution is an optimal algorithm in `2^{O(w²)}·poly(w,n)`
time parameterised by treewidth `w`, plus circuit-style simplifications that cut e-graph size and
treewidth by 40–80% on a measured dataset.

**Mapping to Ergodis.** Three concrete consequences, and I mark the judgements as mine.

First, the semilattice-enrichment result says exactly what Ergodis would be adding if it let
`FeatureDag` hold alternatives rather than a single canonical term: a join operation on parallel
morphisms. That is a small, local change to the node algebra — not a new compiler. It is also the
real reason Ergodis's current simplifier is restricted to "universal algebraic
identities": a destructive rewriter must only apply rules that are unconditionally sound, whereas
a join-carrying structure can hold a rewrite that is only *sometimes* profitable and decide later.
Ergodis's `scalar-plan-semantics.md` states the phase-ordering hazard in its own vocabulary —
"an identity that removes overflowing work or introduces lazy branches can change observable
behavior" — without naming it as phase ordering.

Second, Suciu–Wang–Zhang's termination results are simultaneously the gate and the cheapest
experiment in this report. Ergodis's `FeatureDag` carries a declared **node bound** and **degree
bound**; those bounds make saturation trivially terminating by truncation, but truncated
saturation is not a least fixpoint and therefore carries no "we found the best form" claim. Weak
term acyclicity is the criterion that would license the claim, and checking it costs a graph
traversal over Ergodis's *fixed* identity list — a one-off offline analysis, no runtime cost, no
input data, and a definite yes-or-no answer. Ergodis's identities are the universal algebraic
laws for add/sub/mul/mod/abs/norm over checked integers, so this is a small graph. If the answer
is yes, Theorem 46 gives polynomial-time saturation and the "canonical form" claim becomes
defensible; if no, the specific cycle containing a special edge names the offending identity and
the family where the claim must be weakened. Either outcome is useful, which is rare.

The rigidity result (at most one homomorphism between E-graphs) is the reason a canonical-form
claim can be stated at all: it makes "the e-graph reached" independent of the order the rules
fired, given the same fixpoint.

Third, extraction is where the cost lands, and it is NP-hard in general. This matters because
Ergodis's existing `FeatureDag` snapshot/simplify path is presently cheap and deterministic. Any
adoption must keep the cheap path as the default and treat saturation-plus-extraction as an
explicitly budgeted, ablatable alternative — which is the same discipline Ergodis already applies
to "general traversal remains an explicit labelled ablation, not a deliberately weaker default."

### 1.3 String-diagram rewriting: what a sound rewriting theory costs

**Filippo Bonchi, Fabio Gadducci, Aleks Kissinger, Paweł Sobociński, Fabio Zanasi, "String Diagram
Rewrite Theory I: Rewriting with Frobenius Structure", Journal of the ACM 69(2), March 2022;
arXiv:2012.01847.** *Read depth: partial* — arXiv PDF, cached as `arXiv:2012.01847`, SHA-256
`241e36b151698ea788a3518c15b6275edf90d33438e027a51792af3645219d07`, 57 pages; abstract and
introduction read, the rest skimmed for the statement of the correspondence only. The arXiv
version was read, not the JACM version of record.

**Filippo Bonchi, Fabio Gadducci, Aleks Kissinger, Paweł Sobociński, Fabio Zanasi, "String Diagram
Rewrite Theory III: Confluence with and without Frobenius", Mathematical Structures in Computer
Science, June 2022, pp. 1–41; arXiv:2109.06049.** *Read depth: abstract/metadata only* — arXiv
PDF, cached as `arXiv:2109.06049`, SHA-256
`d624d99f4a94493b2b098020cfbe2f615b5997b6aa4a26105bd3f16bda3b60fe`, 43 pages. Recorded as the
owner of the confluence half of the theory. Volume/page detail above is as given by the Cambridge
Core landing page consulted through search results, not from the article PDF.

The load-bearing statement, which I take from Part I and from Tiurin et al.'s summary of it:
when a symmetric monoidal theory contains a Frobenius algebra, string diagrams are in **one-to-one
correspondence with labelled hypergraphs**, and equational reasoning corresponds precisely to
hypergraph rewriting; Part II handles the symmetric-monoidal case without Frobenius, and Part III
owns confluence in both settings. Tiurin et al. build directly on this series — their DPO theory
for e-hypergraphs is "guided by the established methodology of creating a correspondence between
string diagrams and graph rewriting."

**Mapping to Ergodis.** My reading, not the authors': this series is the reason I would *not*
recommend Ergodis adopt string diagrams as an IR. `FeatureDag` is a Cartesian (copy-and-discard)
term DAG, which is the easy case; the machinery in these papers exists to make rewriting sound
when copy and discard are *not* freely available, and Ergodis pays no price it is currently
avoiding. The series is worth holding as the reference for the one place Ergodis's structure does
leave the Cartesian world: composition trees over the min-plus summary algebra (O5), where the
"wires" carry resources with genuine ownership semantics — C1091's rejection fixture 3 (overlapping
repairs `{1,2}` and `{2,3}` at independent survival 1/2 give availability 3/8, not 1/2) is exactly
a failure of naive copying, and the rule "set support uses union; additive acquisitions can
double-charge shared coordinates" is exactly the statement that the relevant category is not
Cartesian.

---

## 2. Solvers: sheaves, comonads, cospans, open games, and semiring dynamic programming

### 2.1 Sheaves and contextuality: local consistency without global consistency

**Samson Abramsky, Adam Brandenburger, "The Sheaf-Theoretic Structure Of Non-Locality and
Contextuality", New Journal of Physics 13 (2011) 113036; arXiv:1102.0264v7 [quant-ph],
29 November 2011.** *Read depth: partial* — arXiv v7 PDF, cached as `arXiv:1102.0264`, SHA-256
`a06560481dd4dfdd91f0d031221be1aa1152e3cd5d15300e1a08c9f8df7f1f48`, 33 pages; read in full:
abstract, §1 Introduction with the complete contribution list, the presheaf definitions
(`E : P(X)^op → Set` and the distribution presheaf built on it), and §6's constraint-satisfaction
material including Proposition 6.4. Proofs in §4, §5, §7–§9 were not read. The arXiv version was
read, not the New Journal of Physics version of record.

The framework: measurements form a cover `M` of a variable set `X`; local data are sections over
each context `C ∈ M`; the event structure is a presheaf `E : P(X)^op → Set`, composed with a
distribution functor to give a presheaf of distributions on sections. The central theorem (their
Theorem 8.1) is a strict equivalence between realisation by a factorizable hidden-variable model
and the existence of a **global section gluing a compatible family** on that presheaf.
Contextuality is then, exactly, an obstruction to the existence of a global section. They
distinguish a strict hierarchy — probabilistic contextuality, possibilistic contextuality,
strong contextuality — and place Bell, Hardy and GHZ at successively higher levels.

The part that matters for a solver: **Proposition 6.4.** Given a model `e` over a cover `M` with
outcome set `O`, put `S_e(C) := supp(e_C) ⊆ O^C` for each context, and associate the constraint
satisfaction problem `(X, O, {S_e(C) | C ∈ M})`, where a CSP is a triple (variables, values,
constraints), a constraint is a pair `(C, S)` with `C ⊆ V` and `S ⊆ K^C`, and an assignment
satisfies it if its restriction lands in `S`. Then a probabilistic model is **maximally
contextual if and only if the associated CSP has no solution**. This is a two-way dictionary:
constraint satisfiability *is* the existence of a global section of the support presheaf.

**Samson Abramsky, Rui Soares Barbosa, Kohei Kishida, Raymond Lal, Shane Mansfield,
"Contextuality, Cohomology and Paradox", arXiv:1502.03097v2 [quant-ph], 5 March 2017 (LIPIcs
version, CSL 2015).** *Read depth: partial* — arXiv v2 PDF, cached as `arXiv:1502.03097`,
SHA-256 `ec9132bf45b5c42c2cd5124407807d538ad346e11996bd05035d831f39796620`, 18 pages; read in
full: abstract, §1 Introduction including the three-way unification list and the "Mathematical
structure" paragraph, and the All-vs-Nothing definitions (Definition 3, Theorem 4 statements).
Cohomology computations and the remaining proofs were not read.

Their unification is stated explicitly in three bullets: in **quantum contextuality** the local
data come from measurements on compatible observables and no global section means no
hidden-variable explanation; in **databases** the local data are relation tables and no global
section is the failure of the universal relation assumption; in **constraint satisfaction** the
local data are constraints on subsets of variables and no global section is the CSP's
unsatisfiability. They then give a much more general formulation of "All-vs-Nothing" arguments —
**local consistency and global inconsistency of systems of linear equations** — show that an
extensive class of such arguments arises in the **stabiliser fragment of quantum mechanics**
(which they note plays a central role in quantum error correction and measurement-based quantum
computation), and prove that every All-vs-Nothing argument is witnessed by a **cohomological
obstruction** to extending local sections to global ones, characterised via the connecting
homomorphism of a long exact sequence.

**Samson Abramsky, Georg Gottlob, Phokion G. Kolaitis, "Robust Constraint Satisfaction and Local
Hidden Variables in Quantum Mechanics", Proceedings of the 23rd International Joint Conference on
Artificial Intelligence (IJCAI 2013), Beijing, pp. 440–446.** *Read depth: abstract/metadata
only* — metadata and abstract retrieved from the ACM Digital Library landing page
(`dl.acm.org/doi/10.5555/2540128.2540193`) and a second index, both via web search; the full text
was not obtained. Recorded because it fixes the complexity of the corresponding decision problem:
they introduce **robust** CSPs, asking whether every partial assignment of a given length that
violates no constraint extends to a solution, show specific robust colorability and robust
satisfiability problems NP-complete, and use that to establish intractability of detecting
local-hidden-variable models. The page range above is from the consulted landing pages, not from
the paper itself.

**Mapping to Ergodis.** This cluster is the closest fit in the whole study to what Ergodis's
verification layer already does, and the fit is at the level of mathematical content rather than
analogy. Ergodis's `crates/verify` performs "independent bounded GF(2) verification"; C1091's
recovery and privacy families are stated over GF(2) source models with target subspaces and
parity-check edits; the QEC family is explicitly the stabiliser fragment. The All-vs-Nothing
setting is *linear systems over Z₂ that are consistent on every context and inconsistent
globally* — which is the same object as a parity-check system that is locally satisfiable but has
no codeword, and Ergodis's C1091 note that "changing a parity check can create or remove
candidates and alter logical triviality" is the same failure mode viewed from the edit side.

My inference: the practical lever is not "adopt sheaf cohomology" but "recognise that Ergodis's
`observational.rs` declared-contexts machinery and the sheaf `E : P(X)^op → Set` are the same
data, so a rejection can be reported as a **named obstruction class** rather than as a bare
`unsupported`." C1091 asks precisely for that — a structured counterexample naming distinguishing
context, failed lift, violated assumption, uncovered source case, or incompatible information
state. The sheaf hierarchy gives those names a total order (probabilistic ⊂ possibilistic ⊂
strong), and the Z₂ case gives a *computable* witness — a parity combination of local equations
summing to a contradiction — rather than merely a pair of states. That is a better
counterexample object than a pair of distinguishing states, because it is checkable by the
verifier without re-running the solver.

The gate is Abramsky–Gottlob–Kolaitis: the robust-extension question is NP-complete, so the
obstruction must be *produced by* the failing search, never *searched for* separately.

### 2.2 Game comonads: local consistency, treewidth, and a resource parameter

**Samson Abramsky, Anuj Dawar, Pengming Wang, "The Pebbling Comonad in Finite Model Theory",
LICS 2017; arXiv:1704.05124v1 [cs.LO], 17 April 2017.** *Read depth: partial* — arXiv PDF, cached
as `arXiv:1704.05124`, SHA-256
`d7be26825bf2d70baee103fc119faa46670e6e12adb73c1cdb4eca5acfd40e7f`, 12 pages; read in full:
abstract with its five-item result list, §1 Introduction, and the section headings and statements
for §6 (coalgebra number and treewidth) and §8 (strong k-consistency). Proofs were not read.

The construction takes a relational structure `A` to `T_k A`, a comonad whose coKleisli morphisms
`A → B` are exactly Duplicator's winning strategies in the existential k-pebble game. The results
relied on here: the existence of a homomorphism `A → B` is an equivalent formulation of the basic
CSP; isomorphism in the coKleisli category characterises elementary equivalence in k-variable
logic with counting quantifiers; **treewidth is characterised by the coalgebra number** — the
least `k` for which `A` carries a coalgebra structure for the k-pebbling comonad — with the
coalgebra giving treewidth of `A` itself and the map to `T_k A` giving treewidth of its core; and
coKleisli morphisms characterise **strong k-consistency**, which the authors call a fundamental
notion in constraint satisfaction, together with a Cai–Fürer–Immerman construction giving a CSP
not solvable by k-local consistency tests though polynomial-time solvable by Gaussian elimination.
They note `T_k A` is infinite but of bounded treewidth.

**Mapping to Ergodis.** Two things, both mine. First, this is the clean statement of a
distinction Ergodis states informally as "coverage": a coKleisli morphism is a solution *with a
declared resource budget of k pebbles*, and the comonad's counit is what forgets the budget. That
is the same shape as Ergodis's separation of "witness readout, optimum readout and independently
certified optimality" — a witness found under a bounded search and a witness certified against
the whole admitted domain are different morphisms in different categories, and the comonad names
which. Second, the Cai–Fürer–Immerman example is a live warning for Evolve: it is a CSP family
that *defeats every local-consistency heuristic at fixed k* while being easy by Gaussian
elimination, i.e. precisely the situation where a learned neighbourhood/repair rule set will look
saturated and be wrong. Ergodis's search is over GF(2) structure, which is where CFI lives, so
this is not a remote hazard.

### 2.3 Decorated and structured cospans: composing open subproblems

**Brendan Fong, "Decorated Cospans", Theory and Applications of Categories (as posted);
arXiv:1502.00872v3 [math.CT], 11 August 2015.** *Read depth: partial* — arXiv v3 PDF, cached as
`arXiv:1502.00872`, SHA-256
`86e09ad5a834a0471eeedfb83ac80953652e09e0bedda954820eb8bda3321a61`, 25 pages; abstract and §1
Introduction read, the rest skimmed only for the hypergraph-category statement.

Given a category `C` with finite colimits and a braided monoidal `(D, ⊗)`, a lax braided monoidal
functor `F : (C, +) → (D, ⊗)` yields a symmetric monoidal category whose objects are those of `C`
and whose morphisms are a cospan `X → N ← Y` in `C` **together with a decoration**, an element
`1 → F N` in `D`. Crucially, decorated cospan categories are **hypergraph categories**: every
object carries a special commutative Frobenius monoid, and the functors between them preserve it.

**John C. Baez, Kenny Courser, Christina Vasilakopoulou, "Structured Versus Decorated Cospans",
Compositionality 4(3), ISSN 2631-4444; arXiv:2101.09363v4 [math.CT], 30 August 2022.** *Read
depth: partial* — arXiv v4 PDF already in the cache (fetched 2026-08-27), SHA-256
`979e69fc230230f4b44c68406d6a46fb4c589bce8686ea2a4fb3100d0d8d6455`, 39 pages; abstract and the
comparison statement read; the double-category proofs were not read.

They compare two ways of presenting open systems. A **structured cospan** for a functor
`L : A → X` is a diagram `L(a) → x ← L(b)` in `X`; a **decorated cospan** for a pseudofunctor
`F : A → Cat` is `a → m ← b` with an object of `F(m)`. Each yields a symmetric monoidal double
category, and under stated conditions the two become isomorphic when `X` is the Grothendieck
category `∫F`. Applications cited: electrical circuits, Petri nets, dynamical systems,
epidemiological modelling.

**Mapping to Ergodis.** The decoration *is* the plural-preservation contract (O9). A cospan
`X → N ← Y` with a decoration is literally "an open subproblem with declared interfaces, carrying
extra data about itself"; composition is pushout on the apex, and the lax monoidal functor `F` is
the law saying how two subproblems' decorations combine when glued. Ergodis's C1091 has this
structure already, written out in prose: composition must preserve physical ownership ("set
support uses union; additive acquisitions can double-charge shared coordinates; shared
transmissions require subspace alignment"), and `CompositionShape` (C1094) validates the geometry
but explicitly "does not validate algebra, source lowering or query preservation." The lax
monoidal functor is the missing algebra piece, and the Frobenius/hypergraph structure is exactly
what says wires may be freely merged and split — which is *true* for Ergodis's coordinate
identifications and *false* for its resource accounting, so the two must be different decorations
over the same cospan, not one.

The Baez–Courser–Vasilakopoulou comparison matters practically: "structured" (a functor into a
category of already-typed things) is closer to how Ergodis is built — validated typed family
objects with interfaces — while "decorated" is closer to how Ergodis talks about contracts. The
isomorphism result says one does not have to choose ideologically; it says they agree when the
structured side is the Grothendieck construction of the decorating pseudofunctor, which is a
concrete check, not a philosophy.

### 2.4 Open games: quantifier order made compositional

**Neil Ghani, Jules Hedges, Viktor Winschel, Philipp Zahn, "Compositional Game Theory", LICS 2018;
arXiv:1603.04641v3 [cs.GT], 15 February 2018.** *Read depth: partial* — arXiv v3 PDF, cached as
`arXiv:1603.04641`, SHA-256
`e9fa2be8d010bbba12c75de9b5ff8af0007bbade0927569ba8edbf3e78d6d351`, 10 pages; abstract and §1
Introduction read in full; the equilibrium-preservation proofs were not read.

Open games are morphisms of a symmetric monoidal category, composed sequentially by categorical
composition and simultaneously by monoidal product, and drawn as string diagrams that visualise
information flow. The key new concept is **coutility**: the utility an open game generates and
returns to its environment, which is what makes a game "open" rather than closed. They show a
variety of games are faithfully represented, in the sense of having the same Nash equilibria and
off-equilibrium best responses. They are explicit about the difficulty: "the equilibria of a
composite game are not necessarily made up from those of the component games, and locally optimal
moves are not guaranteed to be globally optimal."

**Mapping to Ergodis.** That last sentence is C1091's rejection fixture 5 verbatim in another
vocabulary — three optimal-action sets `{a,b}`, `{b,c}`, `{a,c}` where pairwise compatibility
does not justify merging all worlds — and fixture 4, where a single-failure-complete catalog omits
the only action safe under unresolved alternatives. Open games are the existing formalism for
"a component's optimum depends on what its environment does with the answer", and coutility is
the name for the backward channel Ergodis's decision-cover contract needs and does not have.

I do **not** recommend adopting open games. Ergodis's decision problems are single-agent
optimisation with information constraints, not strategic games, and the lens/optic machinery
underneath open games is part A's territory. What is worth taking is the diagnosis: Ergodis's
"decision cover / policy" contract row currently says only "common-action or sequential
nonanticipation obligations, not pointwise optimum alone." Open games show that stating such an
obligation compositionally requires a *bidirectional* morphism — forward play, backward coutility
— and that a forward-only representation cannot express it. If Ergodis ever implements decision
covers as composable objects, the interface must be bidirectional from the start; retrofitting a
backward channel onto a forward-only plan type is the expensive version.

### 2.5 Semiring dynamic programming and the min-plus certificate

**Max A. Little, Xi He, Ugur Kayas, "Dynamic programming by polymorphic semiring algebraic shortcut
fusion", arXiv:2107.01752v5 [cs.DS], 4 January 2024.** *Read depth: partial* — arXiv v5 PDF
already in the cache (fetched 2026-08-27), SHA-256
`a0655fd6433cb72a06bed4f42138e60fc841add8b82352a500358c48e4d95b29`, 31 pages; read in full:
abstract, §1 Introduction, §2.3 simplifying the constraint algebra (statement), §2.5 tupling
semirings, and the min-plus worked example around the shortest-path specification. Derivations in
§3–§5 were skimmed.

The method: write a self-evidently correct brute-force specification that generates and evaluates
every candidate, then derive an efficient implementation by **shortcut fusion**, with correctness
carried by the derivation rather than argued after the fact. **Semiring polymorphism** is what
makes one derivation serve many problems: they list optimization, optimal probability and Viterbi
decoding, probabilistic marginalization, logical inference, fuzzy sets, differentiable softmax,
and relational and provenance queries as instances. **Semiring lifting** augments a specification
with combinatorial constraints expressed as an algebra homomorphism, and those constraints fuse
into the derived algorithm. Two specific mechanisms matter here. The **tupling trick**: pairing a
semiring `S` with the generator semiring `G` gives the Viterbi (arg-max-plus) semiring
`S × G` with `(u,x) ⊕ (v,y)` selecting the better component and taking the union on ties, and
`(u,x) ⊗ (v,y) = (u+v, x∘y)`, so value and witness are computed in one pass with no backtracing;
they note the same construction extends to maintaining the **top-k optima**, not just one.

**Ambroise Baril, Miguel Couceiro, Victor Lagerkvist, "New Perspectives on Semiring Applications to
Dynamic Programming", arXiv:2512.03916v1 [cs.CC], 3 December 2025.** *Read depth: partial* — arXiv
PDF already in the cache (fetched 2026-08-27), SHA-256
`84caf8499e0464471b1f651281e9577aab4d8d0a058af0672ae0132514777a1a`, 55 pages; abstract and the
statement of the ∆-product and its purpose read; the FPT proofs were not read. The cache title
reads "…Semiring Applications to Constraint Satisfaction"; the PDF's own title page reads
"New Perspectives on Semiring Applications to Dynamic Programming", and I use the PDF's.

Their general construction gives a **semiring extension of any problem with a reasonable notion of
certificate** (they say, e.g., any NP problem), yielding cost variants and counting variants
uniformly, with **no idempotence assumption** on the semiring. They introduce an associative
operation on semirings called the **∆-product** whose purpose is to let the dynamic program
**count the number of minimum-cost solutions** — which they describe as an overlooked problem —
and they prove fixed-parameter tractability with respect to clique-width and treewidth for
finite-domain CSPs and for connected dominating set.

**Todd J. Green, Grigoris Karvounarakis, Val Tannen, "Provenance Semirings", PODS 2007, DOI
10.1145/1265530.1265535.** *Read depth: partial* — publisher PDF already in the cache (fetched
2026-08-27), SHA-256 `74e092702db58518afeaf909e1d3380848165b2cb9ae75dc6822b04f66aa5be0`,
10 pages; §§1–4 read in full (motivating examples, the `K`-relation definition, the positive
relational algebra, Propositions 3.3–3.5, and the provenance-polynomial development through
Theorem 4.3). The Datalog fixed-point material (§5–§6), the finiteness algorithms (§7), the
distributive-lattice specialisation (§8) and query containment (§9) were read only through the
contribution list in §1.

A **`K`-relation** is a function `R : U-Tup → K` with finite support, tagging every possible
tuple with an element of `K`. Union adds tags, projection sums them, join and selection multiply
them. **Proposition 3.4** is the justification for the algebraic choice: the expected relational
identities (union associative/commutative with identity, join associative/commutative and
distributive over union, projections and selections commuting appropriately) hold **if and only
if** `(K, +, ·, 0, 1)` is a commutative semiring. They point out what is deliberately *absent*
from that list — idempotence of union and self-join — because those fail for bag semantics.
Instantiating `K` recovers each known system: `(B, ∨, ∧)` gives set semantics, `(N, +, ·)` bag
semantics, positive Boolean formulas give Imielinski–Lipski c-tables, and event sets give the
Fuhr–Rölleke–Zimányi probabilistic algebra.

Two results carry the universality. **Proposition 3.5**: applying a map `h : K → K′` tagwise
commutes with every positive relational-algebra query **if and only if `h` is a semiring
homomorphism**. **Proposition 4.2**: for the semiring `N[X]` of polynomials with variables the
tuple ids and coefficients in `N`, every valuation `v : X → K` extends to a *unique* semiring
homomorphism `Eval_v : N[X] → K`. Together these give **Theorem 4.3**: `q(R) = Eval_v ∘ q(R̄)`,
where `R̄` is the abstractly-tagged version of `R` — the semantics over *any* commutative semiring
factors through the provenance polynomials. They stress that the polynomial records not only
which inputs contribute but **how**: `2s² + rs` says the output tuple is computed in three ways,
two using input `s` twice and one using `r` and `s`, which plain why-provenance (which returns
just the set `{r, s}`) cannot distinguish.

**Mapping to Ergodis.** This is the tightest and cheapest mapping in the report, because Ergodis's
verifier is *already* a semiring computation and is *already* written against exactly one semiring.

`ergodis-verify::min_plus_transition` checks a fixed 4×4 min-plus summary format, composes
summaries up an authenticated tree, and its documentation says outright that "other algebras and
hash backends require other checkers." Green–Karvounarakis–Tannen and Baril–Couceiro–Lagerkvist
both say the same thing from the other side: the *algorithm* does not depend on the semiring; only
the carrier and the two operations do. So the checker's dependence on min-plus is an
implementation choice, not a mathematical necessity — the Merkle authentication, the sibling-digest
comparison and the tree replay are semiring-agnostic, and only the 64-byte summary layout and the
saturating `u32::MAX` absorbing element are min-plus-specific.

Three concrete consequences, stated as mine:

1. **The saturation is a real mathematical caveat, not just an engineering one.** The docs say
   finite sums saturate to `u32::MAX` and that this "is not an unbounded-integer min-plus
   guarantee." In semiring terms: `u32::MAX` is intended as the additive identity `∞` of the
   tropical semiring, but a *saturating* `+` is not the tropical `⊗` — `⊗` must be strictly
   monotone and cancellative enough that `a ⊗ ∞ = ∞` is the only way to reach `∞`. Saturation
   makes a large finite cost indistinguishable from absence. This is checkable: either prove a
   bound under which no reachable composition saturates, or record it as a declared precondition
   on the certificate. Today it is neither.

2. **The tupling trick supplies exactly the witness/optimum separation Ergodis's glossary
   demands.** The glossary insists "witness readout, optimum readout and independently certified
   optimality differ," and C1091 adds that preserving one canonical witness, the whole feasible
   set, and the ability to lift *some* optimum are three contracts. `S × G` with union-on-ties is
   the second; `S × G` with the tie-break of Little et al.'s equation (37) is the first; the
   top-k extension is the Pareto/envelope contract. These are *three different semirings over the
   same transition structure*, which means Ergodis's three witness contracts can be three
   instantiations of one generic verifier rather than three checkers.

3. **Green–Karvounarakis–Tannen name the condition under which a summary may be reinterpreted.**
   Proposition 3.5 says a tagwise map commutes with every query exactly when it is a semiring
   homomorphism. Ergodis's summary-transition documentation observes that "equal summaries can
   come from different source models or events" and that the APIs "establish consistency with the
   caller's interpretation, not unique source or event identity." The semiring framing sharpens
   that: reinterpreting a cost summary under a different valuation is sound precisely when the
   reinterpretation is a homomorphism, and Theorem 4.3 says the polynomial semiring is the
   representation that keeps *every* such reinterpretation available at once. A verifier that
   retained provenance polynomials rather than evaluated costs could answer "which leaves does
   this root cost depend on, and how many times each" without re-running anything — which is the
   dependency-set question Ergodis's cache-validity contract asks and currently answers by
   declaration.

4. **The ∆-product answers a question Ergodis's repair family already asks.** C1093's
   `RepairModel → RepairPlan → BudgetQuery` supports "count/threshold/witness readouts" over a
   fixed repair family. Counting minimum-cost solutions is precisely the ∆-product's stated
   purpose. Whether Ergodis's existing count readout is the min-cost count or the all-solutions
   count is not stated in the material I read, and that ambiguity is worth resolving before any
   generalisation.

---

## 3. Normalization and evolution: quotients, confluence, and structure learning

### 3.1 Minimization as a factorization, parametric in the output category

**Thomas Colcombet, Daniela Petrişan, "Automata Minimization: A Functorial Approach", Logical
Methods in Computer Science 16(1) (2020), pp. 32:1–32:28; arXiv:1712.07121.** *Read depth:
partial* — arXiv PDF (the LMCS journal version, as the PDF's own header states) already in the
cache (fetched 2026-08-27), SHA-256
`ff1fc5eccf5a537f07e85ad6b57151f8b54023a27011301ca699354f2b10df54`, 28 pages; read in full:
abstract, §1 Introduction with the complete result list, §2's minimization-by-factorization
material through Remark 2.6, and the statement of §2.3's sufficient conditions. The Choffrut and
Brzozowski instantiation proofs (§4, §5) and the syntactic-monoid section (§6) were not read.

They define an automaton directly as a **functor** from a category `I_word` representing input
words to a category `C` representing computation and output: deterministic automata are functors
into **Set**, nondeterministic automata functors into **Rel**, and **weighted automata over a
semiring `S` are functors into `S-Mod`**. Given a language `L`, the category `Auto(L)` of
`C`-automata accepting `L` has an initial automaton `A_init(L)` and a final automaton
`A_final(L)`, and the **minimal automaton is the image factorization**

> `A_init(L) ↠ Min(L) ↪ A_final(L)`

through a factorization system `(E, M)`. Lemma 2.3 gives that `Min(L)` divides every other
automaton recognizing `L`; Remark 2.6 gives that minimization is an endofunctor. The sufficient
conditions on the output category are the existence of certain limits and colimits plus a
suitable factorization system, and the initial/final automata are phrased as **Kan extensions**.
They also lift adjunctions between output categories to adjunctions between automata categories,
recovering determinization (via the Kleisli adjunction between Rel and Set) and Brzozowski's
algorithm (via `Set ⊣ Set^op`, and via `S-Mod ⊣ S-Mod^op` in the weighted case).

**Mapping to Ergodis.** `ValidatedQuotient` + `AdmittedObservable` sits in the left half of this
picture: Ergodis computes *some* congruence and then checks whether a requested observable
factors through it, explicitly declining to claim minimality ("reusing an existing quotient can
retain extra classes"). Colcombet–Petrişan say what the missing right half is — the final
automaton `A_final(L)`, i.e. the observation-indexed object — and that the minimal quotient is
the image of the unique map from the reachable part into it. Two implications, mine:

The rejection Ergodis returns today (two concrete states in one class with different outputs) is
precisely the statement that the candidate quotient does *not* sit below `A_final` for the new
observable. The framework says the constructive repair is available and canonical: refine along
the image factorization for that observable rather than recompiling a new plan from scratch. That
turns C1091's planner choice ("refine the representation, compile another plan, or retain the
current question") from a three-way judgement call into a computation for the first branch.

The parametricity in the output category is what makes this reach Ergodis's other
representations. The same statement with `C = S-Mod` for `S` the tropical semiring is the min-plus
version — the object O5's certificates live over. That is the single most reusable idea in this
section: *one* minimization construction, instantiated at Set for `observational.rs` presentations
and at `S-Mod` for cost-carrying representations.

### 3.2 Weighted minimization is a real algorithm, and tropical is where it gets conditional

**Mehryar Mohri, "Weighted Automata Algorithms", in Handbook of Weighted Automata (Monographs in
Theoretical Computer Science), Springer, DOI 10.1007/978-3-642-01492-5_6.** *Read depth: partial*
— publisher PDF already in the cache (fetched 2026-08-27), SHA-256 recorded in the cache manifest
under key `10.1007/978-3-642-01492-5_6`; read in full: the chapter opening, §6.4 Minimization
including Theorem 8, and the determinizability material containing Theorems 5 and 6. Shortest
distance, composition and epsilon-removal sections were skimmed. Author affiliations as printed:
Courant Institute and Google Research. The numbered theorems are attributed by Mohri to his
reference [38]; I have not read [38] itself.

The concrete algorithm: a deterministic weighted automaton is minimal when no two distinct states
are equivalent *after any redistribution of weights along paths*. **Theorem 8**: given a
deterministic weighted automaton over a semiring `S` for which the conditions of weight pushing
hold, performing (1) weight pushing, then (2) classical unweighted minimization treating each
(label, weight) pair as a single label, yields a minimal weighted automaton equivalent to the
input. Complexity for the tropical semiring is `O(|Q| + |E|)` in the acyclic case and
`O(|E| log |Q|)` in general.

The conditional part is determinization, not minimization. **Theorem 5**: a tropical weighted
automaton with the **twins property** is determinizable. **Theorem 6**: for trim unambiguous
tropical weighted automata, determinizable ⟺ twins property ⟺ subsequentiable. The twins property
is testable in `O(|Q|² + |E|²)` for trim unambiguous and cycle-unambiguous automata, and — the
part that matters most for Ergodis — **any acyclic weighted automaton over a zero-sum-free
semiring has the twins property and is determinizable**.

**Mapping to Ergodis.** Ergodis's min-plus summary structure is a **tree** — the verifier
composes leaf summaries up a padded binary tree — so it is acyclic by construction, so the twins
property holds for free and both determinization and minimization are available at linear cost.
My conclusion: if Ergodis ever wants a canonical form for its min-plus representations (for cache
keying, for deduplicating catalog entries, for deciding whether two compiled plans are the same
plan), weight pushing plus unweighted minimization is an off-the-shelf, linear-time answer for
exactly the acyclic case Ergodis is in. This is the cheapest single item in the whole report.
The caveat is the one already noted in §2.5: saturating `u32` arithmetic is not the tropical `⊗`,
and weight pushing moves weights along paths, so a pushing step could plausibly create or destroy
a saturation. That must be checked, not assumed.

### 3.3 Confluence, completion, and a hard negative result about normal forms

**Dimitri Ara, Albert Burroni, Yves Guiraud, Philippe Malbos, François Métayer, Samuel Mimram,
"Polygraphs: From Rewriting to Higher Categories", preprint of a book published by Cambridge
University Press, DOI 10.1017/9781009498968; arXiv:2312.00429v2 [math.CT], 4 September 2025.**
*Read depth: partial* — arXiv v2 PDF, cached as `arXiv:2312.00429`, SHA-256
`ca92a986c19ee19e77fee98f9f3cdb81d53502c33ffa7d4e187021651f2e7309`, 669 pages; read in full:
abstract and the Preface's treatment of convergence, Tietze transformations and completion, the
universality problem, and Squier's homological/homotopical conditions. Nothing beyond the preface
was read; the arXiv preprint was read, not the Cambridge University Press version of record. All
attributions below are as the preface states them.

The relevant chain. A rewriting system is **convergent** when terminating and confluent; given
termination, Newman's lemma reduces confluence to **local** confluence, and this holds for
abstract rewriting systems independent of the formalism (strings, terms, and so on). The same
notion was found independently for presentations of algebras as **Gröbner bases** (Shirshov 1962,
Buchberger 1965), where Newman's lemma is the diamond lemma. **Completion** algorithms — Buchberger
for Gröbner bases, Knuth–Bendix for term rewriting, Nivat for string rewriting — add rules or
generators to force confluence, and the rules to add are determined by **critical branchings**,
called S-polynomials in the linear setting, which are the minimal obstructions to confluence.
**Tietze transformations** are the two elementary moves (add a generator equal to a product of
existing ones; add a relation derivable from existing ones) that connect any two presentations of
the same object.

Then the negative result. The **universality problem** (Jantzen) asks whether a finitely presented
monoid with a decidable word problem always admits a finite convergent presentation. Kapur and
Narendran showed the Artin presentation of the positive braid monoid `B₃⁺` (two generators, one
relation `aba = bab`) admits no convergent presentation by adding or removing *relations* alone,
though adding a *generator* does yield one. **Squier (1987) answered the general question
negatively**: the homology groups determined by a presentation of a monoid are invariants of the
monoid rather than of the presentation; a finite convergent presentation forces the third homology
group `H₃(M)` to have finite rank; and Squier exhibited a finitely presented monoid with decidable
word problem whose `H₃` is not of finite rank, hence admitting no finite convergent presentation.

**Mapping to Ergodis.** This is the discipline-imposing source for Evolve's normal-form catalogs,
and I state the consequence as mine. Evolve's job description includes discovering "rewrite rules"
and representations, and Ergodis's `FeatureDag` already has a canonical form under a fixed
identity set. The chain above says three separate things about that ambition:

1. **Completion is the right mechanism and it is mechanical.** If Evolve proposes a rewrite rule
   set, critical-pair computation says exactly which additional rules are needed for confluence,
   and it is a finite local computation on the rule set — not a search. If Ergodis wants a
   defensible "this is the canonical form" claim for its simplifier, critical-pair completion of
   its identity list is the standard way to get it, and it is a one-time offline analysis.
2. **Adding generators is a legitimate and sometimes necessary move.** The `B₃⁺` example is the
   clean demonstration that a rule set can be un-completable within a fixed signature and
   completable after introducing a new operation. Evolve proposing *new FeatureDag node kinds*
   is therefore not scope creep — it can be the only route to a normal form. That is a genuine
   argument for letting Evolve's proposal space include signature extensions, not merely
   parameters.
3. **"Decidable equality" does not buy "canonical form", and the obstruction is computable.**
   Squier's theorem is the reason no amount of engineering effort is guaranteed to produce a
   finite confluent rule set for a given admitted family. Ergodis should therefore never write a
   contract of the form "the catalog stores normal forms" without either exhibiting the convergent
   presentation or declaring the family where it holds. The homological obstruction gives a
   principled way to stop looking, which is more valuable operationally than a proof of success
   would be.

Confluence in the diagrammatic setting is owned by **String Diagram Rewrite Theory III**
(Bonchi–Gadducci–Kissinger–Sobociński–Zanasi, cited with its read depth in §1.3), which is where
to look if the rewriting ever moves off Cartesian terms.

### 3.4 Structure learning in the applied-category-theory sense

**John D. Foley, Spencer Breiner, Eswaran Subrahmanian, John M. Dusel, "Operads for complex system
design specification, analysis and synthesis", Proceedings of the Royal Society A 477(2250),
article 20210099 (2021); arXiv:2101.11115v2 [cs.SE], 25 May 2021.** *Read depth: partial* — arXiv
v2 PDF, cached as `arXiv:2101.11115`, SHA-256
`5be390206227359d2d0e3a167c6673a3c29dab5b29c2ffb08c0b342527cb4582`, 33 pages; read in full:
abstract, the four "views of an operad" framing, the operad-algebra definition (§2 around
equation 2.2), and the key-performance-indicator coherence discussion. The synthesis section (§6)
and case studies were skimmed. Journal volume/article number above comes from the Royal Society
landing page reached via search, not from the arXiv PDF. Affiliations as printed: Metron Inc.,
NIST, Carnegie Mellon.

Their framing is unusually implementable. An **operad** is an API: a collection of abstract types
and operations, where a type is best understood as "a boundary or interface, rather than a
system," and an operation is one step of hierarchical decomposition. An **operad algebra**
`A : O → Set` is a concrete implementation: a set `A(X)` of instances for each type, and for each
operation `f : ⟨Xᵢ⟩ → Y` a function `A(f)` assembling component instances into a composite
instance, subject to functor-like coherence rules. The point of having several algebras over one
operad is that one might carry **state** and another carry **key performance indicators**, with an
**algebra homomorphism** extracting KPIs from state; the coherence conditions then guarantee that
computing KPIs bottom-up and computing state bottom-up then extracting agree — the paper's phrase
is that this "just works" under hierarchical decomposition. Type-checking rules out syntactically
invalid designs, restricting the design space before any semantic reasoning.

**Eli Sennesh, "Learning a Deep Generative Model like a Program: the Free Category Prior",
arXiv:2011.11063v1 [cs.LG], 22 November 2020.** *Read depth: partial* — arXiv PDF, cached as
`arXiv:2011.11063`, SHA-256
`c1f18d8f97297cfb469c39807e446456ab37b9e617ffc192725524fded2754e9`, 6 pages; abstract, the
contributions paragraph, and the "free category prior over programs" section were read; the
Omniglot experiments were skimmed. This is a workshop-length preprint, not a journal article.

The claim relied on: representing programs as morphisms in a **finitely generated free category**
lets one sample programs that are "correct by construction," whose support must contain the data,
**without maintaining a symbol table or performing additional type-checking steps**. The
motivating failure it is set against is that not every grammatical program in a probabilistic
context-free grammar's support has a meaningful likelihood — they cite an experiment finding 35%
of sampled hypotheses for a logical-rule task were tautologies or contradictions. Structure and
parameters are learned end-to-end, and the sampling procedure is a random walk over paths in the
generating multigraph.

**Coverage note on structure learning.** I searched specifically for categorical or algebraic
accounts of *evolutionary* operators — crossover, mutation, selection — and found nothing. The
verbatim query was `category theory genetic algorithm crossover mutation functorial
structure-preserving evolutionary operators`; every result was standard evolutionary-computation
material or patents, with no category-theoretic treatment. A second query,
`"applied category theory" program synthesis mutation search "structure learning" wiring diagram
amortized inference`, returned categorical *structure learning* (DisCoPyro, the free category
prior, and survey material) but again nothing on evolutionary operators as such. This is a
**searched and found nothing** outcome over web search only; I did not query zbMATH, OpenAlex,
Crossref or Semantic Scholar for it, so it licenses a weak negative at best and is recorded as an
open gap rather than a verdict.

**Mapping to Ergodis.** The Foley et al. operad-algebra picture is a direct answer to a problem
Ergodis states and does not solve: `CompositionShape` (C1094) "establishes storage geometry, not
algebraic laws or evidence authority." An operad algebra is the missing layer — the operad is the
composition shape, and *each* algebra over it is one of the things Ergodis wants to compute
bottom-up over that shape: the state space, the cost summary, the resource envelope, the coverage
account. The algebra-homomorphism coherence condition is precisely the check that Ergodis's
min-plus summary agrees with the underlying source model, which O5's documentation currently
lists as an explicitly *unestablished* obligation ("it does not establish that an initial leaf
correctly lowers the source model"). Stated as mine: the coherence square between the state
algebra and the cost algebra is a concrete, checkable formulation of that missing obligation, and
it is checkable on small instances by construction rather than by proof.

The free category prior is the weaker of the two for Ergodis's purposes but makes one point worth
keeping. Evolve proposes candidates and then admits or rejects them; the free-category framing
says that if the proposal space is generated by typed operations, ill-typed proposals cannot be
generated at all, so no separate type-check pass is needed. Ergodis already has this for
`FeatureDag` (nodes reference only earlier nodes; inputs index the supplied row) and already gets
the benefit. Where it does *not* have it is at the level Evolve actually searches — representations
with preservation contracts — and that is the level at which "correct by construction" would
actually save admission work.

---

## 4. Certificates and verification

### 4.1 The nearest live comparator is not categorical: pseudo-Boolean proof logging

The most directly usable finding in this section came from the non-categorical side, and it
answers a question Ergodis's own certificate-interoperability direction (private ADR 0003, which
names VIPR, VeriPB and SAT proof ecosystems as candidate targets) has already opened.

**Alexander Hoen, Andy Oertel, Ambros Gleixner, Jakob Nordström, "Certifying MIP-Based Presolve
Reductions for 0–1 Integer Linear Programs", arXiv:2401.09277v2 [math.OC], 20 March 2024;
also published in the CPAIOR 2024 proceedings, DOI 10.1007/978-3-031-60597-0_20.** *Read depth:
partial* — arXiv v2 PDF already in the cache (fetched 2026-08-29), SHA-256
`4f3cd31796e50305c96a764a6f3478cf7f2a679f3e046a25c71712832402934b`, 19 pages; read in full:
abstract, §1 Introduction including the VIPR comparison, §2.1's statement of the
redundance-based strengthening rule and the checked deletion rule, and §2.2's objective-update
rule. The individual presolver certifications (§3) and the experiments (§4) were skimmed. The
Springer DOI is from the landing page reached via search, not from the arXiv PDF.

Two statements carry the weight. First, on the state of the art in exact optimization: for
numerically exact MIP solvers the **VIPR** format exists, "but it currently only allows
verification of feasibility-based reasoning, which must preserve all feasible solutions. In
particular, it does not support the verification of dual presolving techniques that may exclude
feasible solutions as long as one optimal solution remains." The consequence they draw is that an
exact MIP solver's certificate "would only establish correctness under the assumption that all
the presolving steps were valid."

Second, the mechanism **VeriPB** uses to get past that. Alongside cutting-planes rules, which can
only derive semantically implied constraints, VeriPB has a **redundance-based strengthening**
rule that derives a *non-implied* constraint `C` provided this changes neither feasibility status
nor optimal value. The proof obligation is discharged by exhibiting a **witness substitution ω**
together with subproofs of

> `C ∪ D ∪ {¬C} ⊢ (C ∪ D ∪ {C})↾ω ∪ {f ≥ f↾ω}`

whose meaning is: any assignment satisfying the premises but violating `C` can be mapped by `ω`
to one that satisfies `C` too and gives an objective value at least as good. Deletion is
similarly disciplined: the proof keeps a **core set** `C` and a **derived set** `D`; deleting
from `D` is always allowed, but deleting from the core requires the **checked deletion rule** —
showing the constraint could be re-derived by redundance-based strengthening. They also identify
a hazard in objective updates: when the presolver rewrites `f` to `f′` and then uses
redundance-based reasoning, the proof goal "ω cannot worsen the objective" must still be
discharged against the *original* `f`, which is obvious to the presolver and not to the checker.

**Mapping to Ergodis.** This is the same distinction Ergodis's C1091 makes and has no format for.
VIPR's restriction — preserve all feasible solutions — is C1091's contract "preserving the
feasible witness set." VeriPB's redundance rule is the contract "preserving the ability to lift
some valid optimum", and `ω` is the lift. In C1091's vocabulary, `ω` is the **witness lift** that
the representative-catalog contract requires ("same optimum over retained family for admitted
queries … source family coverage, signatures, baseline valuation, radius/adversity and actual
witness lifts"). The literature therefore already has a *checkable proof format for exactly the
contract Ergodis's catalogs need*, and it is the stronger contract, not the weaker one.

Three consequences, stated as mine. (1) The catalog-omission certificate C1091 asks for in plan
item C ("a separate checker validates the omission argument relative to the admitted family")
has a known shape: it is a witness substitution plus a proof that it does not worsen the
objective. (2) The core/derived split with checked deletion is the discipline Ergodis's
admission-handle model already reaches for — a receipt names replayable material and does not
itself confer authority — and it is worth reading as an existing design for the same invariant.
(3) The objective-update hazard is a direct warning for Ergodis's budget admission: C1093 admits
budget changes against a compiled `RepairPlan`, and the analogous failure is a reduction
certified against an updated budget/objective while the recorded claim references the original.
Ergodis's rule that "changing a time budget need not invalidate the mathematical identity;
changing radius, admitted contexts or the meaning of a threshold does" is the right
distinction; VeriPB shows the checker needs the old objective, not just the new one, to verify it.

### 4.2 Compositional verification as functorial semantics

**Georgios Bakirtzis, Ufuk Topcu, "AlgebraicSystems: Compositional Verification for Autonomous
System Design", arXiv:2203.16343v1 [cs.LO], 3 March 2022.** *Read depth: full text* — arXiv PDF,
cached as `arXiv:2203.16343`, SHA-256
`12de4fb4c304b8120992fc0fcd278119541b5a21d77b4b0d3e412891a5a19b59`, 2 pages; this is a short
position paper and was read end to end. Authors as printed: both at the University of Texas at
Austin; the affiliation guess in my fetch command was wrong and is corrected here.

Their framing: compositional verification "attempts to combat emergence by implementing model
transformation as structure-preserving maps between model views", and viewing models as
**algebras** lets one reason compositionally between them. They separate **horizontal**
composition — composing same-type models into larger ones within one formalism, which they call
a generally accepted line of work — from **vertical** composition, relating or enforcing a
hierarchy *among multiple formalisms*, which they identify as the harder and more interesting
rule and the one category theory supplies. They state plainly that compositionality is about
refinement and abstraction. The proposal is a conglomeration of algebraic methods so that
formalisms and tools are interoperable through both kinds of composition.

**Mapping to Ergodis.** The horizontal/vertical distinction names the exact gap in Ergodis's
architecture map. Ergodis has horizontal composition in several places — `CompositionShape` and
the retained binary composition tree, the min-plus summary composition, run-bundle parent links.
What it does not have is vertical composition: the relations *between* its model views. The views
are enumerated in the architecture map and the glossary (source model, `FinitePresentation`,
compiled quotient, compiled plan, physical plan, min-plus summary tree, run record) and every
boundary between them is currently described in prose as an obligation that is explicitly *not*
discharged — "it does not establish that an initial leaf correctly lowers the source model",
"`CompositionShape` … does not validate algebra, source lowering or query preservation",
"lowering does not transfer DAG identity, sharing, degree, feature provenance or proof authority
into `PlanSpec`". Each of those sentences names a missing vertical map. That is my inference, not
the authors' claim, but it is a mechanical reading of Ergodis's own documentation.

### 4.3 Applied category theory as scientific-computing infrastructure

**Evan Patterson, Owen Lynch, James Fairbanks, "Categorical Data Structures for Technical
Computing", Compositionality 4(5), ISSN 2631-4444; arXiv:2106.04703v5 [math.CT], 19 July 2022.**
*Read depth: partial* — arXiv v5 PDF, cached as `arXiv:2106.04703`, SHA-256
`a761f212956292923af9fb393bd562d81fc44d6b5640c4c23b5394e14f447299`, 27 pages; read in full:
abstract, table of contents, §1 Introduction including the performance claim, and the statements
about generic limits and colimits and about the benchmark comparison. The acset formalism (§3–§4)
and benchmark detail (§5.5) were skimmed. Affiliations as printed: Topos Institute; Universiteit
Utrecht; University of Florida.

**C-sets** are functors from a finitely presented category `C` to **Set** — a graph, for instance,
is a functor from the category with two parallel arrows. **Acsets** (attributed C-sets) extend
these with data attributes of fixed types, giving a joint generalization of graphs and data
frames that also covers wiring diagrams and Petri nets with rate constants, and derived from
earlier work on algebraic databases. Two claims matter for a comparison with Ergodis. First,
**finite limits and colimits of acsets on a fixed schema are computed generically** — the
pullbacks, pushouts and quotients are available for free once the schema is declared, not
implemented per structure. Second, the performance claim: the Julia implementation "achieves
performance competitive with state-of-the-art graph libraries," benchmarked against LightGraphs.jl,
and the authors describe this combination of performance and generality in categorical data
structures as apparently novel. They place the work in the AlgebraicJulia ecosystem.

**CatColab (Topos Institute).** *Read depth: abstract/metadata only* — the project page at
`topos.institute/work/catcolab/` was fetched and summarised; the source repository and the
`catcolab.org` application itself were not examined, and no paper was read. As stated there,
CatColab is "a collaborative environment for formal, interoperable, conceptual modeling" and
"software for making models of the world together", aiming at "a system in which anyone, from
citizen to scientist, can contribute their piece of understanding of the world in a language in
which they're comfortable." Its stated concepts are **logics** (domain-specific, e.g. database
schemas or biochemical regulatory networks), **models** ("well-defined mathematical objects"
specified declaratively within a logic), and **diagrams** ("instances of a model"), with
**morphisms, migrations and compositions** named as future additions.

**Amirhossein Akbar Tabatabai, "An Introduction to Categorical Proof Theory", arXiv:2408.09488v2
[math.LO], 24 March 2025.** *Read depth: abstract/metadata only* — arXiv v2 PDF, cached as
`arXiv:2408.09488`, SHA-256
`825b2fa989ee309ff4d59ba3d7438332b004d93ff62e8e0d509373afd2c40d88`, 146 pages; only the title
page and table of contents were read. Recorded as the reference for the proofs-as-morphisms
tradition (proofs as auxiliary objects, Gentzen, categorical proof theory, type theory) that the
phrase "proof-relevant certificate" appeals to. Nothing in this report rests on its content.

**Mapping to Ergodis.** The AlgebraicJulia comparison is worth making precisely because it is
*unfavourable in the direction people expect and favourable in the other*. Ergodis's portable
records, bundles and repository (C1101/C1103/C1107/C1114/C1115) do what acsets do not attempt —
identity, publication, bounded browser and native persistence, and an explicit separation between
"stored metadata and bundle parsing" and "executable activation or proof authority." Acsets do
what Ergodis's composition layer does not — generic limits and colimits on a declared schema, so
that a pullback or a quotient is derived rather than hand-written per structure. The Patterson
et al. benchmark result is the relevant existence proof against the reflex that a categorical
data layer must cost performance; my caveat is that Ergodis's bar is not "competitive with a
graph library" but "no native slowdown accepted as the price of portability or abstraction",
with zero-allocation hot loops and retained A/B counter gates, and the Julia result does not
transfer to that bar.

CatColab is the closer comparison for a different reason: its logic/model/diagram split is the
same three-layer shape as Ergodis's problem-and-language bounded context (problem specification /
typed plans / instances), and its declared future work — morphisms, migrations, compositions — is
the same vertical-composition gap §4.2 identifies in Ergodis. Neither system has it yet.

---

## 5. Absorption table

Ordered by my estimate of value per unit of effort, best first. "Confidence" is confidence that
the lever would pay off if the experiment were run, not confidence that the experiment is worth
running. Prior art informs and never gates: nothing here is blocked because it exists elsewhere,
and several rows are worth doing precisely *because* someone else has already paid the design
cost.

The index below is the short form; the six required fields for each row are written out in full
underneath it, because several of them do not compress to a table cell without losing the part
that makes them actionable.

| #  | Candidate categorical structure        | Ergodis object            | Confidence |
|----|----------------------------------------|---------------------------|------------|
| 1  | Weak term acyclicity of a rule set     | O2 FeatureDag identities  | high       |
| 2  | Weight pushing plus minimization       | O3 catalogs, O5 summaries | high       |
| 3  | Semiring-polymorphic verifier          | O5 certificates, O4       | high       |
| 4  | Redundance rule with witness lift      | O3 catalogs, O4 receipts  | high       |
| 5  | Product of categories                  | O1 physical vs tracing    | medium     |
| 6  | Kleisli target for partiality          | O1/O2 lowering            | medium     |
| 7  | Semilattice-enriched terms (joins)     | O2 FeatureDag, O8 Evolve  | medium     |
| 8  | Operad plus several algebras           | O5 leaf lowering, C1094   | medium     |
| 9  | Sheaf obstruction classes              | O4 admission failures     | medium     |
| 10 | Minimization as image factorization    | O3 ValidatedQuotient      | medium     |
| 11 | Decorated / structured cospans         | O9 contracts              | low        |
| 12 | Bidirectional decision-cover morphisms | O9 decision covers        | low        |

### Row detail

**Row 1 — weak term acyclicity of a rewrite system** (Suciu–Wang–Zhang, Definition 45 and
Theorem 46). *Ergodis object:* O2, the `FeatureDag` simplification identities. *Expected benefit:*
either a defensible "this is the canonical form, reached in polynomially many steps" claim for the
simplifier, or a named identity that forbids the claim. *Cheapest experiment:* build the weak term
dependency graph over Ergodis's fixed identity list — nodes are positions `(op, i)`, special edges
run from the positions of a variable of an `rhs` sub-pattern absent from `lhs` to the positions of
that sub-pattern — and look for a cycle through a special edge. Offline, no runtime, no input
data. *Evidence gate:* binary, since the graph either contains such a cycle or does not; if it
does not, additionally confirm the simplifier's fixpoint is reached within the polynomial bound on
the existing 1,984-row corpus. *Confidence: high* — the criterion is purely syntactic over a small
fixed rule set and returns a usable answer either way.

**Row 2 — weight pushing then unweighted minimization over a semiring** (Mohri, Theorem 8).
*Ergodis object:* O3 catalog and quotient normal forms, O5 min-plus summary trees. *Expected
benefit:* a canonical form for cost-carrying representations in `O(|Q| + |E|)` on acyclic inputs,
usable for cache keying and catalog deduplication. *Cheapest experiment:* apply weight pushing
followed by label-pair minimization to an existing min-plus summary tree and check the result is
state-minimal and cost-equivalent. *Evidence gate:* cost-equivalence on every leaf assignment in
the existing fixture set, and an explicit check that pushing never moves a finite cost across the
`u32::MAX` saturation boundary. *Confidence: high* — the tree structure is acyclic, so the twins
property holds by Mohri's stated corollary and the algorithm applies unconditionally.

**Row 3 — semiring polymorphism of the verifier** (Little–He–Kayas §2.5; Baril–Couceiro–Lagerkvist;
Green–Karvounarakis–Tannen Propositions 3.5 and Theorem 4.3). *Ergodis object:* O5,
`ergodis-verify::min_plus_transition`, and O4 admission. *Expected benefit:* one checker rather
than one per algebra, with witness, optimum, top-k and minimum-cost-count readouts as
instantiations instead of separate code paths. *Cheapest experiment:* parameterise the existing
checker over `(carrier, ⊕, ⊗, 0, 1)`, re-run the current min-plus conformance fixtures through the
generic path, then add the Viterbi tupled semiring `S × G` as a second instantiation and compare
its witness against the existing witness readout. *Evidence gate:* byte-identical results on every
current min-plus fixture, plus no regression on the retained native A/B counter gates — the
generic path must add no allocation or dynamic dispatch in the hot loop. *Confidence: high* — the
sources are explicit that the algorithm is semiring-independent, and Ergodis's own documentation
already says other algebras need other checkers.

**Row 4 — redundance-based strengthening with an explicit witness substitution**
(Hoen–Oertel–Gleixner–Nordström §2.1). *Ergodis object:* O3 representative catalogs, O4 admission
receipts, and C1091's plan item C omission certificate. *Expected benefit:* a checkable
certificate for "this reduction preserves the optimum but not the feasible set" — the contract
Ergodis's catalogs need and which VIPR-style feasibility proofs cannot express. *Cheapest
experiment:* encode one bounded recovery-family catalog omission as a witness substitution `ω`
plus the subproofs `C ∪ D ∪ {¬C} ⊢ (C ∪ D ∪ {C})↾ω ∪ {f ≥ f↾ω}`, and check it with an independent
checker. *Evidence gate:* the independent checker accepts the certificate and separately rejects a
deliberately broken omission — C1091 fixture 4, the single-failure-complete catalog that drops the
only action safe under unresolved alternatives. *Confidence: high* — the format is implemented and
in use for 0–1 integer linear programs, and Ergodis's GF(2)/binary families are in exactly that
setting.

**Row 5 — product of categories `k ⊗ k′`** (Elliott §7.3). *Ergodis object:* O1, the physical plan
versus the tracing form; also O5 cost and coverage accounting carried alongside execution.
*Expected benefit:* the diagnostic trace and the fused physical plan cannot diverge, because one
translation builds both — an asserted invariant becomes a structural one. *Cheapest experiment:*
implement the tracing evaluator and `CompiledPlan::evaluate_row` as two arms of one componentwise
interpretation and run the existing plan-semantics corpus once through the product. *Evidence
gate:* identical results and identical error domains across the full corpus, and no additional
work in the non-traced path — the trace arm must be removable at compile time, not at run time.
*Confidence: medium* — structurally clean, but Ergodis's zero-allocation requirement makes "the
product arm costs nothing when unused" the real question, and that is a Rust monomorphisation
question rather than a category-theory one.

**Row 6 — Kleisli category for a partiality/error monad as the compilation target** (Elliott
§§2–4, adapted; the partiality instance is my extension, not his). *Ergodis object:* O1 and O2
lowering, and the whole-DAG versus selected-root observation boundary. *Expected benefit:* makes
"preserve result *and* error domain" a typed property of the target rather than a prose
obligation, and recasts the two evaluators as two declared strictness choices rather than a
discrepancy to be tested around. *Cheapest experiment:* define the target interface — objects are
typed field tuples carrying an `Ok`-style admissibility predicate, morphisms are checked partial
arithmetic maps — and implement `FeatureDag::evaluate` and `feature_term_program` lowering against
it. *Evidence gate:* the existing `tests/feature_lowering_semantics.rs` reachable and unrelated
overflow cases still separate the two interpretations, and the conformance corpus passes unchanged
through both. *Confidence: medium* — the mathematics is routine and the work is a typed refactor
of a stable surface, but the payoff is clarity and a place to hang future targets rather than a
measurable win.

**Row 7 — semilattice-enriched terms: joins of parallel morphisms** (Tiurin–Barrett–Ghica–Hu).
*Ergodis object:* O2 `FeatureDag`, and O8 Evolve's rewrite-rule proposals. *Expected benefit:* the
DAG can hold alternatives, so a rewrite that is only sometimes profitable is retained and chosen
later — the phase-ordering escape Ergodis currently forgoes by admitting only unconditionally
sound identities. *Cheapest experiment:* add a join node to `FeatureDag`, apply a rule set
non-destructively to a bounded depth, and extract using the existing cost model. *Evidence gate:*
extracted terms are never worse than the current simplifier's output on the corpus, with
construction plus extraction time measured against the current simplify path and an explicit
budget at which the saturating path is abandoned. *Confidence: medium* — the structure is small
and the paper supplies sound and complete rewriting, but extraction is NP-hard (Sun–Zhang–Ni), so
the win depends entirely on whether Ergodis's DAGs have the low treewidth that makes exact
extraction affordable.

**Row 8 — an operad with several algebras over one composition shape, related by algebra
homomorphisms** (Foley–Breiner–Subrahmanian–Dusel). *Ergodis object:* O5's unproved leaf-lowering
obligation, and `CompositionShape` (C1094). *Expected benefit:* turns "the summary agrees with the
source model" from an undischarged assumption into a commuting square checkable on instances.
*Cheapest experiment:* declare `CompositionShape` as the operad, the source-model state assignment
as one algebra, the min-plus summary as another, and the leaf lowering as the homomorphism; check
the square on small composition trees. *Evidence gate:* the two bottom-up computations agree on
every tree in the fixture set, and a deliberately wrong leaf lowering makes the square fail.
*Confidence: medium* — conceptually the right frame and cheap on small instances, but the general
obligation is a proof and passing on instances is evidence rather than discharge.

**Row 9 — sheaf-style obstruction classes as the shape of a rejection** (Abramsky–Brandenburger
Proposition 6.4; Abramsky–Barbosa–Kishida–Lal–Mansfield on All-vs-Nothing arguments). *Ergodis
object:* O4 admission failures, and C1091's structured-counterexample path. *Expected benefit:* a
rejection that names which obstruction, carrying a parity-combination witness over Z₂ that the
verifier can check without re-running the solver — strictly more useful than a pair of
distinguishing states. *Cheapest experiment:* on a GF(2) recovery or privacy instance that fails
admission, emit the locally-consistent, globally-inconsistent linear combination and check it
independently. *Evidence gate:* the emitted combination is verified by the independent checker and
a fabricated one is rejected; and the cost stays inside the failing search, since producing the
witness must not require a separate search — Abramsky–Gottlob–Kolaitis show the robust-extension
question is NP-complete. *Confidence: medium* — the mathematics fits Ergodis's GF(2) and stabiliser
setting exactly, but whether the failing solver already holds the data needed to emit the witness
is an implementation question this study cannot settle.

**Row 10 — minimization as the image factorization `A_init ↠ Min ↪ A_final`, parametric in the
output category** (Colcombet–Petrişan §2). *Ergodis object:* O3, `ValidatedQuotient` and
`AdmittedObservable`. *Expected benefit:* converts "refine the representation" from a planner
judgement call into a computation — refine along the factorization for the rejected observable
rather than recompiling. *Cheapest experiment:* on a rejected observable, construct the
observation-indexed final object and take the image factorization, then compare against
recompiling a fresh quotient. *Evidence gate:* the refined quotient admits the observable, is no
coarser than necessary, and costs less than a fresh compile on the existing corpus. *Confidence:
medium* — the construction is standard and the `Set` case is immediate, but the cost comparison
against Ergodis's already-cheap recompile is the whole question.

**Row 11 — decorated or structured cospans as the type of an open subproblem** (Fong;
Baez–Courser–Vasilakopoulou). *Ergodis object:* O9 preservation contracts, and composition of open
subproblems. *Expected benefit:* gives the contract a composition law rather than a prose
obligation, and separates the freely-mergeable wire structure from the resource accounting that is
not freely mergeable. *Cheapest experiment:* type one existing composition — the LRC repair family
or a GF(2) recovery instance — as a decorated cospan with two decorations, coordinate
identification and resource accounting, and check that C1091 fixture 3 (overlapping repairs
`{1,2}` and `{2,3}` at independent survival 1/2 giving 3/8) comes out right. *Evidence gate:*
fixture 3 and the "additive acquisitions double-charge shared coordinates" rule both hold by
construction rather than by special-case code. *Confidence: low* — the framing is clearly correct
and useful for design, but I found no evidence it reduces implementation work at Ergodis's scale,
and the double-category machinery is heavy for two decorations.

**Row 12 — bidirectional morphisms (forward play, backward coutility) for decision covers**
(Ghani–Hedges–Winschel–Zahn). *Ergodis object:* O9's decision-cover and policy contract row.
*Expected benefit:* a representation in which a component's obligation can depend on what its
environment does with the answer, which a forward-only plan type cannot express. *Cheapest
experiment:* do not implement. Record the interface requirement instead: if decision covers ever
become composable objects, the morphism type is bidirectional from the start. *Evidence gate:*
none — this row is a design constraint, not an experiment. *Confidence: low* — open games address
strategic multi-agent settings while Ergodis's problems are single-agent under information
constraints, so the transferable content is one interface decision, and the optic machinery
underneath belongs to part A.

### What I would not do

**Do not adopt string diagrams as an IR.** `FeatureDag` is a Cartesian term DAG, the easy case;
the Bonchi et al. machinery exists to make rewriting sound where copy and discard are not free,
and Ergodis is not currently paying that price. Keep the series as the reference for the one
place Ergodis does leave the Cartesian world — resource-carrying composition, where C1091's
fixture 3 is exactly a copying failure.

**Do not build a general categorical framework before rows 1–4.** Rows 1, 2, 3 and 4 are all
concrete, bounded, and each returns a usable answer whether it succeeds or fails. They also
happen to be the four rows whose payoff does not depend on any other row landing first. Ergodis's
own maintenance rule — report separately what is proposed, implemented privately, admitted for a
family, exposed to native, exposed to WASM, and actually tested — applies to every row here, and
nothing in this report has been tested.

---

## 6. Coverage and search record

### Read-depth tally

**Twenty-six named sources.** Two were read at **full text**: Elliott's "Compiling to Categories"
and Bakirtzis–Topcu's "AlgebraicSystems" (a two-page position paper). Eighteen were read at
**partial** depth, each with the sections relied on recorded in its entry; in every case the
abstract and introduction were read in full together with the specific sections whose statements
this report uses, and proofs were generally not read. Five carry **abstract/metadata only**:
Sun–Zhang–Ni on e-graph extraction, String Diagram Rewrite Theory III, Abramsky–Gottlob–Kolaitis,
the CatColab project page, and Tabatabai's categorical proof theory introduction. One carries
**secondary only**: the Categorical Abstract Machine (Cousineau–Curien–Mauny 1987), characterised
from Elliott's related-work section at the full-text depth recorded for that paper.

This is a positioning study, not a novelty or priority verdict, so no claim here depends on the
absence of prior work. The one absence claim I do make — that I found no categorical account of
evolutionary operators — is explicitly marked below as a weak negative resting on web search
alone.

### Cache additions

Every PDF fetched for this task was added to the shared literature cache at
`/tmp/persistent/tavis/lit-search/` with its key and SHA-256. New keys added by this task:
`arXiv:2406.15882`, `arXiv:2501.02413`, `arXiv:2012.01847`, `arXiv:2109.06049`,
`conal-elliott-2017-compiling-to-categories`, `arXiv:1102.0264`, `arXiv:1502.03097`,
`arXiv:1704.05124`, `arXiv:1603.04641`, `arXiv:1502.00872`, `arXiv:2106.04703`,
`arXiv:2101.11115`, `arXiv:2312.00429`, `arXiv:2203.16343`, `arXiv:2011.11063`,
`arXiv:2408.09488`. Already present and reused without re-fetching: `arXiv:2101.09363`,
`arXiv:2107.01752`, `arXiv:2408.17042`, `arXiv:2512.03916`, `10.1145/1265530.1265535`,
`10.1007/978-3-642-01492-5_6`, `arXiv:2401.09277`, `arXiv:1712.07121`. SHA-256 values are quoted
in each source's entry above; the helper used for the fetches is
`/tmp/persistent/tavis/lit-search/fetch_c1150b.sh`, which refuses any download whose magic bytes
are not `%PDF`. No download was left in the RAM-backed scratchpad.

### Load-bearing queries, verbatim

Web search (the only bibliographic service queried; each returned results, so an empty result was
never mistaken for an error):

1. `categorical semantics of e-graphs equality saturation colimit` — produced the two e-graph
   sources this report leans on (arXiv:2406.15882, arXiv:2501.02413).
2. `"string diagram rewrite theory" Bonchi Gadducci Kissinger Sobocinski Zanasi arXiv Frobenius`
   — produced the three-part series and its arXiv identifiers.
3. `category theory branch and bound categorical semantics optimization solver functorial` —
   returned general functorial-semantics material (adjoints as solutions to optimization problems,
   limits as constrained optima) and an IEEE item titled "Category Theory for Optimization", but
   **nothing combining branch-and-bound with categorical semantics**. Recorded as searched and
   found nothing for that specific combination, over web search only.
4. `Abramsky Gottlob Kolaitis "robust constraint satisfaction" local hidden variables IJCAI` —
   resolved the IJCAI 2013 paper's authors, venue, pages and abstract.
5. `operads wiring diagrams hierarchical structure learning applied category theory sheaf
   learning` — produced Foley et al. and the Spivak operad-of-wiring-diagrams line.
6. `category theory genetic algorithm crossover mutation functorial structure-preserving
   evolutionary operators` — **nothing categorical**; every result was standard
   evolutionary-computation material or patents.
7. `"applied category theory" program synthesis mutation search "structure learning" wiring
   diagram amortized inference` — produced categorical *structure learning* (DisCoPyro, the free
   category prior, survey material) but again nothing on evolutionary operators.
8. `compositional verification functorial semantics proof certificate category theory
   "compositional proof" formal methods` — produced Bakirtzis–Topcu and the categorical
   proof-theory introduction.
9. `VeriPB pseudo-Boolean proof logging VIPR mixed integer programming certificate verification` —
   produced Hoen et al. and the VeriPB/VIPR repository descriptions used for the §4.1 comparison.

One page fetch: `https://topos.institute/work/catcolab/` (after `https://catcolab.org/` returned
no extractable content — recorded as **could not access** for that URL specifically).

### Not covered

- **zbMATH Open, OpenAlex, Crossref and Semantic Scholar were not queried.** No verdict in this
  report rests on a citation count or on an enumerated citing set, so the width requirement for
  citation-graph negatives is not triggered; but it does mean the two "found nothing" outcomes
  above (queries 3 and 6) rest on web search alone and are weak negatives. Carry them forward as
  open gaps, not as licenses.
- **MathSciNet: NOT COVERED** — institutional authentication, unreachable from this session.
- **Google Scholar: NOT COVERED** — blocks automated access.
- `catcolab.org` itself returned no extractable content to the fetcher; the CatColab
  characterisation rests entirely on the Topos Institute project page.
- **Ergodis-side facts not verified here.** This is a reading study and I read no Ergodis source
  code. Several mappings rest on documentation statements that may lag the implementation, and
  three specific gaps are flagged in the text: whether C1093's count readout is a min-cost count
  or an all-solutions count; whether Ergodis's tabu/kick and neighbourhood machinery has the shape
  I assumed in O7 (the public documents I was given do not describe it); and whether a failing
  admission search already holds the data needed to emit an obstruction witness (absorption row 9).
- **Part A's territory was not covered by design**: Vincent Abbott's diagram papers, categorical
  deep learning and cats4ai search priors, and optics/Para-style categorical optimization. Open
  games (§2.4) touch the optic literature and are discussed only for their quantifier-order
  content; the lens machinery itself is deferred to part A.

---

## 7. Incidental leads

Observations met while searching that are outside this task's scope. Recorded with provenance;
not written to the discovery track by me, and not promoted to any C-item.

1. **Trace structure encodes infinite equivalence classes in e-graphs.** Tiurin et al.'s
   conclusion (arXiv:2406.15882, §VII, read at the depth recorded in §1.2) lists trace as a
   future extension and notes in passing that trace "can be used to express feedback in
   categorical models of digital circuits and, indeed in conventional e-graphs to encode infinite
   equivalence classes." A finitely-presented infinite equivalence class is a different object
   from a truncated saturation, and could matter to any Ergodis representation that wants to say
   "these are equivalent for all `n`" rather than "these were equivalent up to the node bound."
   Unpursued.

2. **Equality saturation and the database chase are the same procedure up to encoding.** Suciu,
   Wang and Zhang (arXiv:2501.02413, §1 and §4 statements) reduce the Skolem chase to equality
   saturation and equality saturation to the standard chase, and introduce **EGD-fair** chase
   sequences, which they describe as "of independent interest." Anything Ergodis wants from
   incremental view maintenance or from Datalog-style incremental recomputation is reachable from
   the e-graph side and vice versa. Unpursued.

3. **Cai–Fürer–Immerman structures defeat local consistency but fall to Gaussian elimination.**
   Abramsky, Dawar and Wang (arXiv:1704.05124, §8) give this as an example of a CSP not solvable
   by `k`-local consistency tests though polynomial-time solvable by Gaussian elimination. Since
   Ergodis's search space is GF(2) structure, this is a concrete adversarial family for any
   learned local repair rule — a rule set can look saturated on it and be wrong. Worth holding as
   a negative control for Evolve, not as a task.

4. **Interval analysis is a cartesian category and Elliott has the instance.** Elliott §7.7 (full
   text) gives `IFun` with `Interval (a × b) = Interval a × Interval b` and the interval
   arithmetic for `addC`/`mulC`. If Ergodis ever wants cheap bounds on a `FeatureDag` term — for
   pruning, for overflow pre-screening, or for the "bounded probe" step in C1091's query-directed
   compilation — this is a drop-in second interpretation of the same term, and the min/max product
   rule is four multiplications. Noted because Ergodis's checked arithmetic already needs to know
   whether a subterm *can* overflow, and interval analysis answers exactly that question
   statically. Unpursued.

5. **Polynomial functions form a bicartesian category with exact root/extremum analysis.**
   Elliott §7.8 (full text): "as long as one uses only addition and multiplication as primitives,
   functional programs can be compiled into polynomials, which can then be analyzed efficiently
   and exactly, finding roots, minima and maxima, derivatives, and integrals, as well as evaluated
   efficiently in parallel using parallel prefix algorithms." Ergodis's `FeatureDag` is almost
   exactly this signature (add, sub, mul, plus modulus, abs and two norms). Unpursued, and
   flagged with the caveat that the modulus and norm nodes leave the polynomial fragment.

6. **Adjoint functors as solutions to optimization problems, limits as constrained optima.**
   Surfaced by search query 3 above (`category theory branch and bound …`) in general
   functorial-semantics material rather than in any single source I read at depth. Recorded
   because it is the framing under which a categorical account of branch-and-bound would most
   likely be written if one existed, and none was found. Provenance: web search result summaries
   only; no source read.

