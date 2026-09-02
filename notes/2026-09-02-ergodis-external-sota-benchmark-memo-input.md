# External memo: SOTA evolve approaches and benchmarks for Ergodis (input, 2026-09-02)

Source: a ChatGPT memo supplied by Tavis on 2026-09-02, recorded verbatim as an input for the
roadmap review in `2026-09-02-ergodis-roadmap-vs-external-sota-memo.md`. Its claims about
external systems are unverified here; treat every citation as something to check before use.

---

For Ergodis, I would study systems in four buckets: program-evolution discovery, formal theorem proving, exact combinatorial solvers, and symbolic finite-structure systems. The best benchmark strategy is not to chase generic theorem-proving scores; it is to find places where Ergodis's distinctive claim—compile algebraic structure into a small exact quotient and emit replayable certificates—can be isolated.

The most directly relevant SOTA to study is AlphaEvolve/FunSearch. DeepMind has now published a repository of 67 mathematical problems used in the AlphaEvolve study, with prompts, verification code, initial programs, and many final evolved programs. That is unusually valuable because you can take selected problems and ask a different question: can Ergodis infer/compile a quotient representation in which the search becomes exact and certifying? FunSearch's cap-set, admissible-set, cyclic-graph and corner-free-set tasks are particularly attractive because they already live over finite algebraic/combinatorial structure.

I would target these benchmarks, in roughly this order:

1. AlphaEvolve's finite-field/combinatorics subset. This is probably your highest-value external benchmark suite. Do not initially try all 67. Pick perhaps 8–15 whose evaluator has obvious quotient structure: finite-field sets, Sidon/autocorrelation constructions, incidence-like problems, orbit problems, discrete geometry. Measure raw state size, quotient size, compile time, solve time, certificate size, independent replay time, and whether Evolve discovers any reduction not encoded by hand. The interesting comparison is not just "best objective found"; it is objective + proof of exhaustiveness over the compiled search space. AlphaEvolve's published repository makes this reproducible.
2. FunSearch cap sets and admissible sets. These are almost tailor-made for your discovery layer. FunSearch famously found a 512-cap in dimension 8, but the direct cap-set search was stochastic enough that only 4 of 140 runs found that construction. That gives you a good discovery benchmark with several separate questions: can Evolve rediscover the useful reflection/residue structure blind; can that predicate become a structural quotient; can Ergodis exactly optimize inside that quotient; and can the discovered rule transfer across dimensions? The benchmark should explicitly score discovery probability under equal evaluator budgets, not merely final answer.
3. MiniZinc Challenge structural instances, but only a curated subset. CP-SAT won the Fixed, Free and Parallel categories in the 2026 MiniZinc Challenge, so it remains the general exact-solver control you want. Do not position Ergodis against the whole Challenge—you already correctly say it is not a general CP replacement. Instead publish a predeclared classifier for "Ergodis-shaped" instances: repeated interfaces, linear conservation, group symmetry, finite-field labels, decomposable min-sum states, reconstructible blocks. Then run every qualifying instance, including losses. That would make your crossover claim much stronger than isolated application benchmarks.
4. Hadamard search outside 2092. Your private 2092 campaign is scientifically interesting but weak as an external benchmark because you control the corpus and reductions. A public Hadamard family gives you a hostile comparison. There is active exact SAT work on order 668 using Goethals–Seidel/SDS structure, canonicalization under rotations/reflections/multipliers, row-sum families and autocorrelation verification. There is also a separate search framework combining spectral sieves, canonical deduplication and meet-in-the-middle on autocorrelation vectors. Even if 668 is not the same mathematical regime, porting one or more published routes would be an excellent benchmark because the competing implementation is already structure-aware rather than naïve SAT.
5. Magma finite-polynomial systems. This is a less glamorous but very useful control. Current Magma documentation reports extremely optimized exhaustive solving of quadratic systems over GF(2), including cases where enumeration beats Gröbner/SAT by over two orders of magnitude. This gives you a clean adversarial benchmark: when Ergodis's quotient compiler has little to exploit, it should lose; when generated spans/gradings/symmetries collapse the system, it should win. Publishing the phase transition would sharpen the product's scope.
6. ZDD/BDD family enumeration. Since Ergodis emits compressed minimal-support families and exact reliability counts, benchmark against modern ZDD techniques rather than only hand-written controls. Recent work specifically targets fast exact enumeration of all cost-bounded solutions using ZDDs. Useful tasks would include minimal support sets, hitting-set-like repair families, exact reliability counting and constrained family enumeration. Here I would report not only runtime but compressed representation size versus Ergodis's family representation.

For the discovery layer, I would study three architectures closely.

First, AlphaEvolve/FunSearch's population diversity and sampling mechanics, even if you retain typed expressions instead of code. FunSearch uses islands specifically to avoid convergence and favors both score and program brevity. Your syntax-cost objective already gives you an MDL-like bias; adding explicit novelty niches over typed semantic signatures could plausibly be better than pure Pareto ranking on false positives/coverage/cost.

Second, study formal theorem-proving systems primarily for their training loop, not as competitors. Formal Conjectures now contains 2,615 Lean statements, including 1,029 open research conjectures, specifically intended as a zero-contamination research-level benchmark. Ergodis should not try to beat Lean provers on PutnamBench. Instead, the interesting integration benchmark would be:

raw finite problem → Ergodis exact computation → candidate invariant / finite lemma / obstruction → export proposition + finite certificate → Lean verification

That would connect your "proof authority" story to the current formal-math ecosystem without pretending Ergodis is a general ATP.

Third, study neural/symbolic conjecture discovery for curriculum design. The emerging useful pattern is iterative: generate conjecture → falsify cheaply → prove exactly → feed verified structure back into later search. Your typed feature DAG and contextual tablebases already resemble a much more constrained version of this. The thing I would borrow is difficulty progression: once a predicate is sealed, make it available as a primitive and ask the next generation to discover strictly stronger or orthogonal structure, rather than repeatedly rediscovering equivalent predicates.

I would create a public benchmark suite of your own, because no existing benchmark measures exactly what you care about. Something like Ergodis StructureBench with, say, 40–60 problems and mandatory metadata:

| Metric | Why it matters |
|---|---|
| Raw assignments | baseline combinatorial size |
| Quotient states | actual structural compression |
| Compression ratio | central architectural claim |
| Compile cycles | structure is not free |
| Solve cycles | hot-loop performance |
| Peak RSS | relevant for huge exact searches |
| Certificate bytes | proof/certification cost |
| Replay cycles | independent trust cost |
| Control solver result | external validity |
| Control solver time/RSS | comparative performance |
| Blind-discovery success rate | Evolve capability |
| Predicate AST cost | interpretability |
| Holdout false positives | generalization |
| Whether predicate became theorem | discovery-to-proof conversion |

The benchmark needs three deliberately different tiers. Tier A should be positive controls where the intended quotient is known and Ergodis ought to dominate. Tier B should be "structure present but hidden," where Evolve sees raw typed observations and must recover the quotient or predicate. Tier C should be negative controls where CP-SAT/MILP/SAT/Magma/ZDD should win. The negative tier may be the most persuasive part of the paper because it demonstrates that "structure compiler" is an empirically testable category rather than branding.

For the Evolve layer specifically, I would add four benchmark tasks that are harder than your current blind rediscovery test:

- Coordinate invention: raw masks/group elements only; success requires inventing orbit invariants or sufficient statistics.
- Cross-instance transfer: discover on q or n, then evaluate unchanged on unseen sizes.
- Theorem-gap benchmark: construct datasets where multiple predicates are observationally perfect but only one corresponds to a valid quotient/reduction; reward systems that refuse unsound pruning.
- Composition discovery: no single shallow predicate solves the task, but two or three previously sealed features compose into an exact reduction.

That last one is especially important. Rediscovering fourteen banked reductions is a strong regression test, but the genuinely SOTA question is whether the system can accumulate a mathematical vocabulary and thereby solve later problems that were infeasible before.

I would also make order 668 Hadamard a public adversarial campaign alongside your private 2092 work. There are now public, structured SAT and meet-in-the-middle implementations with enough detail to reproduce symmetry breaking and verification. That gives reviewers something they can independently inspect and prevents the discovery claims from depending entirely on a private corpus.

If I were prioritizing six months of work, I would do: AlphaEvolve finite-field subset → FunSearch cap/admissible sets → public H(668) structured search → curated MiniZinc structural set → ZDD support-family comparisons → Lean export of one Ergodis certificate. That combination would put you in direct contact with essentially every relevant frontier: LLM mathematical discovery, exact combinatorial optimization, symbolic structure exploitation, and machine-checkable proof.
