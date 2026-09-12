# C1151 part A — gradient-shaped and probabilistic structure for Ergodis, read for capability

**Date:** 2026-09-12. **Lane:** ergodis. **Disposition:** capability-first reading study. No code
changes, no edits under `~/src/ergodis*`.

**Posture.** This is about what Ergodis could be made to do, not about what is new. Prior art is a
template to absorb, never a gate. Gradient-based methods and small learned models (linear models,
small multilayer perceptrons, tree ensembles) are **in scope**. **GPU is in scope too**: WebGPU and
Rust `wgpu`-style bindings are available if acceleration helps larger structure searches in Evolve.
The single hard exclusion is dependence on deep or large neural networks. Sources are read to
algorithm depth where they are load-bearing, and where a reference implementation exists I say what
the code actually computes.

Companion: `2026-09-12-c1150-part-a-abbott-priors-optimization.md` (first pass, structure-first).
Absorption rows referenced as "C1150 row N" point at that file's § 6 table.

## Opening summary

**Sixteen named sources, one read at full text** — Aksu's *Odds Law*, read end to end with its proofs
checked. The other fifteen were read to algorithm depth rather than in full, which is the intended
consequence of reading for capability: I read the definitions, theorems, cost formulas and result
tables, and say at each point which sections carry the claim. Four *code* files were read end to end,
across three repositories inspected at source. Full ledger in § 8.

**The organising idea.** A gradient or a learned model is admissible inside an exact engine in
exactly three roles — it may **order**, it may **bound**, and it may **propose parameters**. It may
never certify. Bounding is the interesting one and the reason gradients belong here at all: a dual
object does not have to be *found* exactly, only *checked* exactly. So a subgradient walk in floating
point that emits a rational multiplier vector, rounded and repaired to dual feasibility and then
evaluated in exact arithmetic, is a **certificate guesser** whose output is a certified lower bound.
The heuristic never signs anything.

**The unification that surprised me.** Willerton shows the Legendre-Fenchel transform — the engine of
convex and Lagrangian duality — is the nucleus of a profunctor enriched over the extended reals, and
that the *same construction over the Booleans is the Galois connection of a relation*. My inference:
the composable-ban machinery of the first pass and numeric dual bounds are one polarity construction
at two enrichments. Ergodis needs one ban store with a `reason` field, where `Bool` gives a hard
refusal and an ordered semiring gives a bound. That collapses three of this file's absorption rows
into one implementation.

**What the code actually does, since that was the question.** `pyncd` and `tsncd` contain **no cost
model, no tiling, no kernel generation and no negative-information machinery at all** — the
"solver" is 39 lines expanding symbolic axis-size expressions into sums of products, configuration
generation collects free variables and lets you bind them by hand with no search, the compiler emits
`nn.Module` trees over einops with the source comment "For now, we just use Einops", and the
hypergraph package has a rewriting *mechanism* with no rule set and no objective, used to normalise
terms before display. The co-design implementation I could reach represents infeasibility as a
lattice top or an empty antichain carrying **no reason, no scope and no certificate**, so it cannot be
transported, checked, or composed. The theory of composable negative information exists; nothing in
this lineage implements it.

**Concrete capability items.** Small models already work: in Gasse et al.'s own baseline rows,
LambdaMART — a gradient-boosted tree ensemble, no network, no GPU — beat SCIP's expert-tuned default
branching rule on easy instances (7.19 s vs 8.98 s) inside an exact solver whose bound guarantees
were untouched. For discrete parameters, Wilson & Zanasi settle expressiveness: `PolyCirc_{Z_p}` is
functionally complete for prime `p`, and Ergodis already carries 54 prime specialisations — but their
documented wrap-around failure, where two sub-models sharing a parameter sum gradients to zero in
`Z₂`, is C1091 rejection fixture 3 arriving from a third direction, and the fix is a saturating
semiring `Sat_n` with `x+y = min(n-1, x+y)`, which is an ordered-resource monoid Ergodis already has.
The largest thing I missed on the first pass is not categorical at all: **equality saturation**
supplies the order-free rewrite search and cost-driven extraction that both the weaves line and the
ZX line are missing, it is a Rust library, and its `e-class analysis` mechanism is a ready-made slot
for a preservation contract.

**On the *Odds Law* preprint.** Its mathematics checks out where I verified it — the odds law is
Bayes' rule in odds form, the threshold dichotomy including the verdict-swap case for `Λ < 1` is
correct, the information ceiling is correctly conditioned, and the recursion master theorem's union
bound is sound. Two results rest on proof sketches I would not lean on: the "no universal
decomposition advantage" corollary, whose sketch treats a verifier as a rewiring of base-solver calls
when it is an extra information source, and the complete-lattice lemma, whose joins are an admitted
idealisation — though the fixed-point theorem it supports also has a direct budget argument that does
not need it. **For Ergodis the whole reliability half is vacuous**, because an exact checker has
`α = 0`, so `Λ = ∞` and one gate suffices; the paper says this itself. What survives is the *cost*
valuation, which is an exact semiring homomorphism where reliability is only lax, and it yields
`(1/p)(c_propose + c_check)` per admitted proposal and `T ≥ ln δ / ln(1-p)` for a budget. The
amplification theorem returns in one place only: cascading *independently implemented* checkers
against implementation faults, which is the C1097 defect class. Asked specifically whether the
algebra orders cheap screens before exact checks, the answer is that the paper's marginal-log-odds
water-filling is the wrong tool in this regime, but two lines of its cost homomorphism give the right
one — **a one-sided screen (`β_s = 1`, mandatory, or completeness dies) pays exactly when
`c_s < c_x·(1-p)·(1-α_s)`**, which is the same object as the § 2.2 dual-bound prune and is decidable
from one instrumented run.

**On GPU.** The weaves cost model's entire hardware dependence is four numbers per level — capacity,
transfer rate, level-graph edges, and bytes per value — so it retargets to WebGPU by substitution.
With `maxComputeWorkgroupStorageSize` at 16 KiB against Hopper's shared memory, and `H* ∝ M^{-β}`,
the model gives a usable design rule before any WGSL is written: prefer `β = 0.5` tiled formulations
over `β = 1` broadcast ones. `u32` is exact in WGSL and there is no f64, which sets the boundary
cleanly — **the GPU filters and orders, the CPU certifies**.

---

## 1. The exactness invariant this whole file is written against

Before any of the machinery: the one rule that decides whether a gradient or a learned model is
admissible inside Ergodis at all.

Ergodis' glossary already separates the pieces needed to state it. `Search mode` is the execution's
evidence obligation (ProofGenerating or Heuristic) and is explicitly *independent of origin*.
`Heuristic` is defined as "a choice lacking the required coverage justification for a stronger
claim", with the note that "a heuristic execution can still use admitted reductions; heuristic does
not mean generated". `Admission` is permission to use a candidate for a particular problem and
scope. `Witness` is a concrete object supporting an existence claim that "does not by itself prove
optimality or an exhaustive negative result".

So the invariant is:

> **A learned or continuous component may choose, order, or bound. It may never certify.**

Three admissible roles follow, and they are the three the task named:

| Role | What the component emits | Why exactness survives |
|---|---|---|
| **Ordering** (proposal ranking, branching choice, kick selection) | A permutation or a score | The set of candidates is unchanged; only the order of exploration changes. Completeness is a property of the enumeration, not of the order. A bad score costs time, never correctness. |
| **Bounding** (relaxation-derived lower bounds, learned bound predictions used as *dual* values) | A number plus a certificate of its validity | The number is *checked*, not trusted. A dual-feasible vector is verifiable by exact arithmetic independently of how it was found. Gradient descent is then a *search for a certificate*, and the certificate checker is the gate. |
| **Parameter proposal** (Evolve tuning radius, budget, tolerance, structural hyperparameters) | A candidate parameter setting | The parameter enters the existing admission path. C1091 already requires that changing a semantic parameter creates a new contract; a learned proposal does not bypass that, it just proposes faster. |

And one inadmissible role, stated so it is not accidentally reintroduced: a learned component must
never supply the *exclusion* half of an optimality claim, never prune a candidate without a checked
ban, and never be the source of a coverage verdict. That is C1091 rejection fixture 9 again.

The rest of this file is organised by what each body of work can contribute to those three roles.

---

## 2. Gradient-shaped material dropped on the first pass

### 2.1 Duality as the place a continuous method earns exact standing

This is the most important idea in this file, so it goes first, and it is stated before any source
because the sources only supply pieces of it.

A branch-and-bound-style exact search needs two things at every node: a **primal** object (a feasible
witness, giving an upper bound on a minimisation) and a **dual** object (a lower bound proving no
candidate in this subtree can beat the incumbent). The primal object must be exact. **The dual object
does not have to be found exactly — it has to be *checkable* exactly.** A dual-feasible point gives a
valid bound whatever produced it: a heuristic, a float solve, a subgradient walk, a learned
predictor. Weak duality is the licence, and the check is a finite arithmetic verification.

That asymmetry is the whole opening for gradient methods in an exact engine, and it maps onto
Ergodis' existing vocabulary without straining it. In glossary terms: the dual object is a
`Certificate` for the claim "no candidate in this scope is better than `v`", the checker is the
independent verification context, and the search that produced it carries whatever `Search mode` it
likes, because `Search mode` is explicitly independent of origin. A subgradient loop in floating
point that emits a rational dual vector, which is then checked in exact arithmetic, is a
ProofGenerating step whose interior is heuristic.

**Willerton, *The Legendre-Fenchel transform from a category theoretic perspective*
(arXiv:1501.03791).** Citation from the consulted source: Simon Willerton, arXiv:1501.03791v1
[math.CT], 15 Jan 2015. **Read depth: partial** — abstract and table of contents; cached as
`arXiv:1501.03791`, sha256 `7bf988957db0547b8ee1ef4644b0aa106e8742d64ef7cac0ca9fd0da8ebef4f2`,
30 pages; the nucleus construction and the Toland-Singer discussion were not read in detail.

What it supplies: the Legendre-Fenchel transform — the engine of convex and Lagrangian duality —
arises as **Pavlović's "nucleus of a profunctor"** for categories enriched over the extended reals
`R̄ = [-∞, +∞]`. The pairing between a vector space and its dual is an `R̄`-profunctor, and taking its
nucleus reconstructs much of the theory. The sentence that matters for an exact engine is the
Boolean specialisation the abstract states directly: **"For a relation between sets viewed as a
{true, false}-valued profunctor, the construction of the nucleus is the construction of the Galois
connection associated to the relation."**

**My inference, and it ties this file to C1150.** Convex duality and the composable-ban machinery of
C1150 rows 1–2 are the *same construction at two different enrichments*. Over `R̄` you get
Legendre-Fenchel and a real-valued dual bound; over the Booleans you get a Galois connection between
a set of candidates and a set of constraints ruling them out — which is exactly an expansive ban and
its upward closure. Ergodis therefore does not need two mechanisms. It needs one polarity
construction parameterised by the enrichment, with `Bool` giving hard bans and `R̄` giving numeric
bounds. If that is right, then the ban data structure in § 4.1 and the dual-bound path in § 2.2 share
an implementation, and the ordered-resource semiring is the parameter that selects which.

**Boisseau & Piedeleu, *Graphical Piecewise-Linear Algebra* (arXiv:2111.03956).** Citation from the
consulted source: Guillaume Boisseau (University of Oxford) and Robin Piedeleu (University College
London); arXiv:2111.03956v1 [cs.LO], 6 Nov 2021; published as *Lecture Notes in Computer Science*,
pp. 101–119, doi `10.1007/978-3-030-99253-8_6` (bibliographic detail from OpenAlex; I read the
preprint). **Read depth: partial** — abstract, §1 Introduction, the Graphical Polyhedral Algebra
preliminaries including the semantics of polyhedral relations, and Example 1 (Duality). Cached as
`arXiv:2111.03956`, sha256 `8ca646ab0d35500c105ef18f397b8c26d1e11698d951adf551f4a5929c2454a8`,
21 pages. Not read: the normal-form and completeness proofs, or the electrical-circuit application.

What it supplies, at algorithm depth: a **prop** whose arrows `n → m` are finitely generated
polyhedra of `K^n × K^m`, that is, sets `{(x,y) : A(x;y) + b ≥ 0}` — an LP feasible region as a
*composable morphism* — with a **complete equational axiomatisation** (`IH⁺_≥`, cited to Bonchi,
Piedeleu, Sobociński & Zanasi), so that polyhedral relations can be reasoned about purely by diagram
rewriting. Piecewise-linear relations (finite unions of polyhedra) are then captured by adding a
single axiom, and the paper shows this is the smallest such extension.

Their "duality" (Example 1) is the compact-closed one: cups and caps bend a diagram's left ports to
the right, giving `⟦d^op⟧ = {(y,x) : (x,y) ∈ ⟦d⟧}`, with mirrored generators `≥` ↦ `≤`. **This is
relational transposition, not LP duality**, and I state that plainly because the temptation to
conflate them is strong: nothing in this paper computes an optimum, a dual multiplier, or a bound.
What it does give is the *compositional* half — feasible regions compose by wiring, and the
composition is sound and complete equationally.

**The gap between those two papers is where Ergodis' own work would sit** (**my inference**):
Willerton has the duality but no composition of subsystems; Boisseau–Piedeleu have the composition of
polyhedral constraints but no optimization. A compositional Lagrangian duality — "the dual bound of a
composite plan from the dual bounds of its parts" — is not, as far as I found, published. Recorded as
a searched-and-found-nothing in § 8, with the caveat that three query phrasings is a thin search and
nothing here depends on the absence.

### 2.2 Continuous relaxation as a bound source, with the checking boundary drawn

Ergodis' architecture context already names VIPR and VeriPB as candidate certificate-interoperability
targets (private ADR 0003, C1148). Those are exactly the formats in which a *dual* object for a
discrete problem is written down and checked. So the plumbing Ergodis is already contemplating is the
plumbing this section needs.

The concrete pattern, with no categorical dressing:

```
solve_node(subproblem, incumbent):
    # 1. Continuous relaxation. Any method. Floating point is fine.
    #    Simplex, interior point, subgradient ascent on a Lagrangian,
    #    a learned predictor of good multipliers - all admissible here.
    lambda_hat = <heuristic search, gradient-based, inexact>

    # 2. Round to exact rationals and REPAIR to dual feasibility.
    lambda = exact_repair(lambda_hat)          # exact arithmetic
    if not dual_feasible(lambda): return NO_BOUND

    # 3. Weak duality gives a certified lower bound.
    bound = exact_dual_objective(lambda)       # exact arithmetic

    # 4. The ban. This is the object C1150 row 1 wants.
    if bound >= incumbent:
        return Ban(scope=subproblem, reason=DualCertificate(lambda, bound))
```

Step 2 is the whole trick and it is where "gradient method" becomes "certificate producer": the
inexact result is a *guess at a certificate*, and the repair-then-check step is what converts it.
Failure at step 2 costs a node's worth of time and nothing else. My inference for Ergodis: this is
the cheapest way to let a gradient into the engine without touching any evidence claim, because the
bound is produced by `exact_dual_objective` and the heuristic never signs anything.

**Ergodis object touched:** bound tightening inside exact search; `Coverage` claims; the certificate
interoperability work already queued as C1148.

### 2.3 Reverse derivative categories for discrete parameters — read at algorithm depth

**Wilson & Zanasi, *An axiomatic approach to differentiation of polynomial circuits*.** Citation from
the consulted source: P. Wilson (University of Southampton, University Road, Southampton, SO17 1BJ,
UK) and Fabio Zanasi (University College London, Gower Street, London, WC1E 6BT, UK, and University
of Bologna, Via Zamboni, Bologna, 40126, Italy), *Journal of Logical and Algebraic Methods in
Programming* 135 (2023) 100892; received 31 Dec 2022, revised 21 Jun 2023, accepted 22 Jun 2023,
available online 30 Jun 2023; CC BY. **Read depth: partial** — abstract, §1 Introduction, Definition
4.1 (`PolyCirc_S`), the group-completion material around Proposition 4.11, §5 Functional Completeness
including Theorem 5.2 and Example 5.3, all of §6 (case studies) and §7 (conclusions). Cached as
`10.1016/j.jlamp.2023.100892`, sha256
`031328bcd874223ff1e9588f09212d307e2c0a5fd49a52a0c1f4cb312b458bee`, 28 pages, obtained from the UCL
Discovery open-access copy of the published article. Not read: the full axiom lists and the
soundness/completeness proofs in §3–4.

This is the C1150 lead item 5 promoted to a read source, and it is substantially more useful than the
ACT 2021 paper it follows.

**What it actually says.** `PolyCirc_S` is the cartesian distributive category presented by
generators and equations whose morphisms are polynomial circuits over a **commutative semiring `S`**
— explicitly "a more expressive version of the boolean circuits of Lafont, with wires carrying values
from an arbitrary semiring instead of `Z₂`". The results that matter:

- **Theorem 5.2 (functional completeness criterion).** For a *finite* commutative semiring `S`, a
  category `C` is functionally complete with respect to `S` iff there is a monoidal functor
  `F : C → FinSet_S` whose image contains the constants `s ∈ S`, addition, multiplication, and
  `compare`. The proof is constructive and is a one-line algorithm: since `S` is finite, encode any
  `f : S^m → S` as its function table, `x ↦ Σ_{s ∈ S^m} compare(s, x) · f(s)`, and decompose
  `S^m → S^n` into `n` such maps using cartesianness. So **the entire question of expressiveness
  reduces to whether `compare` is constructible from constants, `+` and `·`.**
- **Example 5.3.** `PolyCirc_{Z_p}` is functionally complete for prime `p`, by Fermat's little
  theorem (`a^{p-1} ≡ 1 mod p`, so equality testing is a polynomial).
- **The failure mode they document, §6.** Using modular arithmetic as the gradient semiring makes
  gradients *wrap around*. Their worked case: two sub-models `f₁`, `f₂` sharing a parameter `P` and
  applied to different parts of the input; the reverse derivative sums their contributions, and over
  `Z₂` when both gradients are 1, the sum is 0 and `P` is never updated. They state what one actually
  wants: "here we should prefer that 1 + 1 = 1 to 1 + 1 = 0."
- **Their fix, Definition 6.1: the saturating semiring `Sat_n`** on `{0,…,n-1}` with
  `x₁ + x₂ := min(n-1, x₁+x₂)` and `x₁ · x₂ := min(n-1, x₁·x₂)`, noted as equivalent to the semiring
  `B(n, n-1)`. It is a commutative semiring and explicitly not a ring.
- For most semiring choices `PolyCirc_S` is *not* functionally complete, so the usable model class is
  `PolyCirc^=_S`, the version with `compare` adjoined.

**Why this lands on Ergodis specifically, and it lands hard** (**my inference**). Three connections:

1. Ergodis' native `compose` and its provider "share all 54 prime specializations" per the
   architecture context, and the GF(2)/GF(4)/prime-field machinery is already there. Example 5.3 says
   `PolyCirc_{Z_p}` is functionally complete for exactly those `p`. Whatever discrete learned
   component Ergodis might want over a prime field, the expressiveness question is already answered
   and the answer is yes.
2. **The gradient wrap-around failure is C1091 rejection fixture 3 wearing different clothes.** Two
   sub-models sharing a parameter, whose contributions are summed in a semiring where the sum loses
   the multiplicity, is the same error as overlapping repairs `{1,2}` and `{2,3}` being treated as
   independent. Wilson & Zanasi's answer — change the semiring so accumulation saturates instead of
   wrapping — is a design rule Ergodis can apply directly, and it confirms from an independent
   direction the C1150 conclusion that the aggregation structure is where these errors live.
3. **`Sat_n` is an ordered-resource semiring.** `min(n-1, x+y)` is a capped accumulation, which is
   what a budget with a ceiling does. Ergodis' `ordered_resource` already validates finite ordered
   monoid laws. So the semiring in which an Ergodis reverse derivative would be taken is a semiring
   Ergodis already implements.

**Honest limits.** The paper is theory plus case studies; §7 states the empirical work as *planned*,
not done ("we plan to use this work … as the basis for practical machine learning tools … we would
like to experimentally verify"). The only measured results in this line remain the Iris and two-class
MNIST numbers of the ACT 2021 paper. So this is a well-founded mechanism with no demonstrated scale.

### 2.4 Small learned heuristics as branching and proposal scorers

**Bengio, Lodi & Prouvost, *Machine Learning for Combinatorial Optimization: a Methodological Tour
d'Horizon* (arXiv:1811.06128).** **Read depth: partial** — §1 opening, §2's statement of the MILP
relaxation and branch-and-bound setting, §3.1 (demonstration vs experience), and all of §3.2's three
templates (3.2.1 end-to-end, 3.2.2 learning to configure, 3.2.3 alongside). Cached as
`arXiv:1811.06128`, sha256 `c7839cf585e879fe835da0a4b8c268ff98b5febe334bb9482a7a00014d533411`,
47 pages.

The survey's taxonomy is the right frame for Ergodis and its third template is the admissible one.
**End-to-end** (ML emits the solution) is out: it yields no guarantee. **Learning to configure**
(ML sets parameters once, then the exact algorithm runs) is admissible and cheap. **ML alongside the
optimization algorithm** — the exact algorithm repeatedly queries the same model for a low-level
decision — is the one that matters, and the survey states the exactness argument for it in as many
words: in the branch-and-bound case "the general algorithm remains a branch-and-bound framework, with
the same software architecture and the same guarantees on lower and upper bounds, but the branching
decisions made at every node are left to be learned." The authors also note up front that ML being
approximate "does not systematically mean that incorporating learning will compromise overall
theoretical guarantees."

**Gasse, Chételat, Ferroni, Charlin & Lodi, *Exact Combinatorial Optimization with Graph
Convolutional Neural Networks* (arXiv:1906.01629).** Bibliographic detail from the consulted PDF:
33rd Conference on Neural Information Processing Systems (NeurIPS 2019), Vancouver; code at
`https://github.com/ds4dm/learn2branch`. The author list is taken from OpenAlex and the paper title
page; I read the preprint. **Read depth: partial** — abstract, §1 Introduction, the state-encoding
section (bipartite constraint/variable graph, 64-dimensional embeddings, a final two-layer perceptron
on variable nodes with masked softmax), §5.1 experimental setup, and Table 2. Cached as
`arXiv:1906.01629`, sha256 `0a2e92e58ee5056ee709fb6bf9f93f340fe06a5a41b75adddf99bf81428e6381`,
19 pages.

**The measured numbers, because they are the point.** SCIP 6.0.1 backend, one-hour limit, cuts at the
root only, restarts off, trained on easy instances only. On Set Covering, solving time in seconds and
instances solved:

| Rule | Easy | Medium | Hard (wins / solved) |
|---|---|---|---|
| FSB (full strong branching) | 17.30 | 411.34 | 3600.00, 0 / 0 |
| RPB (SCIP default reliability pseudocost) | 8.98 | 60.07 | 1677.02, 4 / 65 |
| TREES (ExtraTrees) | 9.28 | 92.47 | 2869.21, 0 / 35 |
| SVMRANK | 8.10 | 73.58 | 2389.92, 0 / 47 |
| LMART (LambdaMART) | **7.19** | 59.98 | 2165.96, 0 / 54 |
| GCNN | 6.59 | 42.48 | 1489.91, 66 / 70 |

**The row that matters for Ergodis is LMART, not GCNN.** LambdaMART — a gradient-boosted tree
ensemble, no network, no GPU needed at inference — beat the state-of-the-art hand-designed SCIP
default on easy instances (7.19 s vs 8.98 s) and matched it on medium (59.98 vs 60.07). SVMRANK, a
linear ranking model, also beat the default on easy instances. The graph network wins at scale, but
the *existence* result — a learned branching scorer beating an expert-tuned rule inside an exact
solver, with the solver's guarantees untouched — is already established by models small enough to
evaluate in a hot loop.

**Ergodis objects touched** (**my inference**): three, in increasing order of cost.

- **Evolve proposal ordering.** Features are already available (family, capacity bounds, prior race
  outcomes, checked symmetry counts). A ranking model over proposals changes only the order in which
  independent family checkers are invoked. Nothing it emits enters an evidence claim.
- **Kick selection in repair scheduling.** Same argument: a kick is a restart perturbation, and the
  set of reachable states is unchanged by which kick is chosen.
- **Branching/variable ordering inside the exact kernels.** Highest value and highest cost, because
  this is a hot loop under the zero-allocation and A/B counter discipline. A linear scorer over
  precomputed integer features is the only form that could plausibly survive those gates; a tree
  ensemble likely cannot, and that is an empirical question with an existing measurement apparatus.

**What must not be copied from this literature.** These papers evaluate on *average solving time over
an instance distribution*. Ergodis' gates are exactness, coverage, and retained A/B counters. A
learned scorer that improves the mean while occasionally producing a catastrophic tail is acceptable
in the MILP-benchmark culture and is not obviously acceptable here; C1091 already names "bad-tail
selection regret" as a thing to measure, and that measurement, not mean time, is the right gate.

---

## 3. Markov categories and proposal distributions

### 3.1 What a Markov category is, in the form that decides things

**Fritz, *A synthetic approach to Markov kernels, conditional independence and theorems on sufficient
statistics* (arXiv:1908.07021).** Citation from the consulted source: Tobias Fritz; arXiv:1908.07021,
98 pages. The paper credits the Markov-category axioms to prior work of Golubtsov and of Cho &
Jacobs. **Read depth: partial** — abstract, the section-by-section overview in §1 (which states the
content of §§2, 3, 10, 11, 12 explicitly), Definition 2.1's surrounding discussion including Remarks
2.3 and 2.4 and the semicartesian characterisation, and the §1 summaries of Definition 10.1
(deterministic morphisms), Remark 10.13, and Definition 11.5 (conditionals). Cached as
`arXiv:1908.07021`, sha256 `99ee420f2e620a1e40e23d7dd8b3608c01f9f07bb32850703d33b9e03d48cb4e`.
Not read: the proofs, the Gaussian category, the sufficient-statistics theorems.

The structure, stripped to what an engineer needs:

- A **Markov category** is a symmetric monoidal category in which every object `X` carries a
  commutative comonoid — a `copy_X : X → X ⊗ X` and a `del_X : X → I` — compatibly with `⊗`.
- `del` is natural: equivalently the monoidal unit `I` is **terminal**, equivalently the category is
  semicartesian. Concretely: you may always discard, and discarding after a process is the same as
  not running it. This is normalisation — total probability is preserved.
- `copy` is **not** natural in general. That single fact is the entire difference between probability
  and determinism, and Fritz makes it the definition: **Definition 10.1 says a morphism is
  *deterministic* exactly when it preserves the comultiplication**, i.e. when copying its output
  equals copying its input and running it twice. In `FinStoch`, `Stoch` and `Gauss` the deterministic
  morphisms are precisely those involving no randomness. The deterministic morphisms form a
  *cartesian monoidal subcategory* (Remark 10.13).
- Remark 2.4 notes the degenerate case: a cartesian monoidal category has a unique comonoid structure
  on every object and is therefore automatically a Markov category — "the interesting Markov
  categories are those not of this form."
- §11 adds four optional axioms, and the one that decides what you can compute is **existence of
  conditionals** (Definition 11.5). Fritz records that **conditionals fail in `Stoch`** but hold in
  the finite setting. The others are randomness pushback ("any stochastic operation can be
  implemented by first generating randomness and then executing a deterministic function which uses
  it as an additional input"), positivity, and causality.

**Cho & Jacobs, *Disintegration and Bayesian Inversion via String Diagrams* (arXiv:1709.00322).**
Citation from the consulted source: Kenta Cho (National Institute of Informatics, 2-1-2 Hitotsubashi,
Chiyoda-ku, Tokyo 101-8430, Japan) and Bart Jacobs (Institute for Computing and Information Sciences,
Radboud University, P.O. Box 9010, 6500 GL Nijmegen, the Netherlands); arXiv:1709.00322v3 [cs.AI],
8 Feb 2019; received 31 August 2017, revised 7 December 2018. **Read depth: partial** — abstract and
§1 Introduction. Cached as `arXiv:1709.00322`, sha256
`cf72be7552f56ac4765b5cc6b815c31b505e4cd63502386de854caa699739598`, 39 pages. Not read: the
graphical proofs or the measure-theoretic existence results.

What it supplies: **disintegration** ("joint = conditional · marginal", extracting a channel from a
joint state) and **Bayesian inversion** (turning a channel plus a state into a channel in the
opposite direction) as graphical operations, with each definable from the other. Bayesian inversion
is what backward inference is. Existence is discussed separately for discrete probability and for
measure-theoretic probability via standard Borel spaces and via likelihoods — again, the discrete
case is the easy one.

### 3.2 What compositional structure an Evolve proposal distribution should have

This subsection is **my inference throughout**; the sources supply the vocabulary and the theorems,
not the application.

Evolve currently has ranked proposals with independent family checkers. A "proposal distribution over
plans" is the natural next object, and the Markov-category axioms say exactly which properties it
must and must not have. Six consequences, in order of how much they constrain an implementation:

1. **The proposal distribution must live in a Markov category, not a cartesian one.** The whole point
   of Remark 2.4 is that if you build proposals out of ordinary functions you get a cartesian
   category and randomness is fictitious. Sampling must be a morphism, not a side effect.

2. **`del` naturality is the normalisation obligation, and it is a real check.** If a proposal
   generator can fail, time out, or be rejected mid-construction, and you drop that branch, you have
   broken `del` naturality unless the mass is renormalised. A sub-probability generator is *not* a
   Markov category morphism. Ergodis' bounded Evolve with budgets and abandoned compilations is
   precisely a setting where generation can fail, so this is not a pedantic point: **either
   renormalise, or move to the sub-Markov (semicartesian without terminality) setting deliberately
   and say so.**

3. **`copy` non-naturality is the sharing rule for proposals, and it is C1091 fixture 3 for the third
   time in two reports.** Proposing a plan and then duplicating it is not the same as proposing twice.
   A cache that memoises "the proposal for context `c`" and hands the same sample to two consumers is
   making a copy-is-natural assumption, and the two consumers are then correlated. If Evolve's
   accounting treats them as independent evidence, the arithmetic is wrong in exactly the
   3/8-not-1/2 way.

4. **Determinism is a *checkable property*, not a declaration.** Definition 10.1 gives a test:
   does copying the output equal copying the input and re-running? Ergodis already needs to
   distinguish a deterministic compilation step from a randomised proposal step, and this gives the
   predicate. It also gives the licence Abbott–Zardini rely on: a deterministic morphism commutes
   with every rearrangement, so plan-rewriting that is unsound for randomised steps is sound for
   deterministic ones.

5. **Conditionals exist in the finite case, so Evolve may condition.** This is the payoff of the
   `Stoch`-versus-finite distinction. "Given that the last three proposals in this family were
   refuted, what should I propose next?" is a conditional of a joint distribution, and Cho–Jacobs'
   disintegration is the operation that produces it. Because Ergodis' admitted contexts are finite
   and declared (the `ValidatedQuotient` and `observational` machinery is explicitly finite), the
   existence obstruction Fritz records for `Stoch` does not apply. **A learning-from-refutations loop
   is therefore well-defined, not merely plausible.**

6. **Bayesian inversion is the structure of learning from a refuted proposal.** Forward: a channel
   from "structural hypothesis" to "observed checker outcome". Backward: the inverted channel updates
   the hypothesis distribution from the outcome. C1091 asks that counterexamples be structured output
   — distinguishing context, failed lift, violated assumption, uncovered source case, incompatible
   information state. Those five species are exactly the codomain of the forward channel, so the
   inversion is well-typed: a structured counterexample updates a distribution over structural
   hypotheses. That is the cleanest formulation I have of what "Evolve learns from its failures"
   would mean concretely, and it needs no network at all — a tabular conditional over a finite
   declared context suffices.

**The exactness boundary stays where § 1 put it.** A proposal distribution orders and selects; it
never certifies. Its posterior is an ordering prior, and every proposal it emits still faces the
unchanged independent family checker.

**Ergodis objects touched:** Evolve proposal ordering and admission; the structured-counterexample
path; repair-schedule kick selection (a kick is a sample from a proposal distribution over
perturbations, and points 2 and 3 apply verbatim).

### 3.3 Aksu, *Odds Law: The Decomposition Algebra* (arXiv:2606.15712)

**Citation (from the consulted source).** Hidayet Aksu, "Odds Law: The Decomposition Algebra — On How
Intelligence Organizes Itself to Solve Difficult Problems Reliably", arXiv:2606.15712v1 [cs.CR],
14 June 2026. Single author, contact address `hidayetaksu@gmail.com`, **no institutional affiliation
given**. It announces itself as the theory half of a two-part programme ("Theory: Odds Law →
Framework: Maestro Order"), with a companion report said to build a harness and measure the predicted
laws; I did not look for the companion, so **every empirical claim in this line is unexamined here.**

**Read depth: full text.** Version read: arXiv:2606.15712v1, the only version. Cached as
`arXiv:2606.15712`, sha256 `d513d6bcaf86434ad5e451645376cc7041b8b72c9387ecdc0b54ba233a891168`,
10 pages, 8,804 words, `pdftotext` extraction. All sections read: 1 Introduction, 2 The Solver Model
(Defs 2.1–2.3), 3 The Decomposition Algebra (Def 3.1, Prop 3.2), 4 Reliability Composition Laws
(Lemmas 4.1–4.4), 5 Amplification and the Threshold Dichotomy (Thms 5.1–5.2), 6 Self-Organization as
a Fixed Point (Lemmas 6.1–6.2, Thm 6.3, Prop 6.4, Algorithm 1), 7 Fundamental Limits (Thms 7.1–7.2,
Cors 7.3–7.4), 8 The Cost–Reliability Frontier (Prop 8.1, Tables 3–4), 9 Recursive Decomposition
(Prop 9.1, Thm 9.2, Cor 9.3), 10 Selective Reliability (Def 10.1, Prop 10.2), 11 Generator–Verifier
Games (Def 11.1, Thm 11.2), 12 Related Work, 13 Discussion, References. Figures 1 and 2 are not
recoverable from the extraction and are characterised from captions.

**Standing.** Weighed as instructed: single author, no affiliation, a `cs.CR` primary class that does
not match the content, v1 only, and the measurements deferred to an unexamined companion. Against
that: **I checked the proofs, and the mathematics I checked is correct.** The apparatus is elementary
— Bayes in odds form, Hoeffding, the union bound, Knaster–Tarski, the data-processing inequality, a
latent-factor variance decomposition — and correctly deployed. The framing is considerably grander
than the content; the content is nonetheless usable. Details below.

#### 3.3.1 The construction

Solvers are Markov kernels `s : X ⇝ A ∪ {⊥}` where `⊥` is an explicit abstention symbol, composed in
the Kleisli category of the subdistribution monad. Two scalar valuations are deliberately separated:
**coverage** `cov(s) = P[s(x) ≠ ⊥]` (the probability of committing) and **reliability**
`ρ(s) = P[a ∈ Y*(x) | a ≠ ⊥]` (conditional correctness *on committed answers*), with a distribution-free
worst-case variant. The stated reason for the separation is that "a solver may raise reliability by
abstaining more". Four combinators generate the free algebra `𝔄(B)` over a base set `B`: sequential
composition `;`, parallel ensembling `⊕_A`, verification gating `V_v`, and recursion `μ`.

A verifier is a kernel `v : X × A ⇝ {acc, rej}` summarised by **completeness** `β = P[acc | correct]`
and **false-acceptance** `α = P[acc | wrong]`, with **discrimination** `Λ = β/α`. The gate `V_v(g,T)`
resamples from the generator until acceptance, abstaining after `T` rejections.

**Two valuations, and the asymmetry between them is the useful part.** Cost is an **exact
homomorphism** into a commutative semiring, instantiated as `(ℝ≥0 ∪ {∞}, +, ·)` counting expected
base-solver invocations: `c(s_k ; … ; s_1) = Σ_i c(s_i)`, `c(⊕_A(s,n)) = n·c(s) + c(A)`, and
`c(V_v(g,T)) = E[N]·(c(g) + c(v))`. **Reliability is only a lax homomorphism** — it does not factor
through structure exactly, and §4 gives upper and lower bounds instead. Proposition 3.2 then observes
that on the sub-algebra generated by verification gates, log-odds `ℓ = log(ρ/(1-ρ))` *is* a monoid
homomorphism, `ℓ ↦ ℓ + Σ_i log Λ_i`, and pairing it with cost gives a graded monoid
`(ℝ × ℝ≥0, +)` whose slope `Δℓ/Δc` is the quantity optimised in §6.

#### 3.3.2 The proofs I checked

**Lemma 4.3, the odds law — correct, and it is Bayes' rule.** `o_post = o_pre · Λ` where
`Λ = β/α`. The proof is one line: `P[corr|acc]/P[wrong|acc] = (P[acc|corr]/P[acc|wrong]) ·
(P[corr]/P[wrong]) = (β/α)·(p/(1-p))`. That is the standard odds form of Bayes' theorem, correct as
stated, requiring `α > 0` and independence of the verifier's errors from the generator's given
correctness — both hypotheses are stated. It extends to the resampling gate because rounds are
i.i.d., so conditioning on the accepting round gives the same posterior. **The paper calls this its
"central tool" and names itself after it; it is a textbook identity.** The contribution is the
framing — recognising `Λ` as the object to engineer — not the derivation.

**Theorem 5.1, amplification — correct, on a strong hypothesis that the paper does not hide.** `k`
gates multiply the odds by `Π Λ_i`, giving reliability `1-δ` at depth
`k ≥ (log((1-δ)/δ) + log((1-p₀)/p₀))/log Λ = O(log(1/δ)/log Λ)`. The proof requires the gates'
acceptances to be **conditionally independent given correctness**, which is the load-bearing and very
strong assumption. §7.1 is explicit that gates re-reading the same evidence have their effective `Λ`
collapse toward 1.

**Theorem 5.2, the threshold dichotomy — correct, including the part that is easy to get wrong.**
For verification: `Λ > 1` is Theorem 5.1. `Λ = 1` means `β = α`, so acceptance is independent of
correctness and the posterior equals the prior, and composing uninformative gates preserves that —
correct. For `Λ < 1` (that is, `β < α`) they **swap the verifier's verdicts**, giving discrimination
`(1-β)/(1-α)`; I checked this, and `β < α` does imply `(1-β)/(1-α) > 1`, so the swapped verifier is
informative and `Λ* = 1` is indeed the sole critical value. For voting, `p* = 1/2`: above it,
Hoeffding gives `ρ ≥ 1 - exp(-2n(p-½)²)`; below it, the law of large numbers drives the majority to
being *always wrong*; at exactly `½` the votes carry no information. All correct, and Lemma 4.2's
Hoeffding application is the right form for `[0,1]`-bounded variables.

**Theorem 7.1, the information ceiling — correct and carefully stated.**
`E[log o_post - log o_pre] = D_KL(P_{W|C=1} ‖ P_{W|C=0})`, the expectation being *under the
correct-candidate verdict distribution* — which is what makes it a KL divergence rather than a
Jeffreys divergence, and the paper states the conditioning explicitly. The data-processing extension
(no cascade of verifiers that are all functions of the same evidence `Z` beats the best decision
based on `Z`) is the standard argument. This is the honest and general version of the paper's
message, and in my view the strongest result in it.

**Theorem 9.2, the recursion master theorem — correct.** Union bound over `N = (b^{d+1}-1)/(b-1)`
nodes each verified to local error `η` gives overall error `≤ Nη`; setting `η = δ/N` gives per-node
depth `O((log(1/δ) + d log b)/log Λ)` and total cost `O(b^d(log(1/δ) + d log b)/log Λ)`. Proposition
9.1's unverified recurrence `r(d) = ρ_c·r(d-1)^b` unrolls to
`r(d) = ρ_c^{(b^d-1)/(b-1)}·p^{b^d}`, which I verified, and which decays **doubly exponentially in
depth**.

**Two proofs that do not carry their weight, and I would not rely on either.**

- **Corollary 7.4, "no universal decomposition advantage", is a proof *sketch* and is the weakest
  claim in the paper.** The sketch asserts that "combinators are deterministic re-wirings of
  base-solver calls", so uniform averaging over oracles leaves the marginal correctness distribution
  unchanged. But a verifier is **not** a rewiring of base-solver calls — it is an additional
  information source with its own `(β, α)`, and the whole paper is about what that source buys. The
  claim is plausible in the sense that a *fixed* verifier averaged over all families has `Λ → 1`, but
  that is Theorem 7.1's content, not a Wolpert–Macready transport. **The informative version of "no
  free lunch" here is the information ceiling**, and the paper's own gloss concedes as much:
  combinators "do not manufacture reliability; they transport the information already present".
- **Lemma 6.1's complete lattice is a sketch with an admitted idealisation** — the join uses "an
  idealized selector that returns a correct member if any branch is correct", and arbitrary
  joins/meets come from a Dedekind–MacNeille completion whose adjoined elements need not be
  strategies. So Knaster–Tarski in Theorem 6.3 is applied to a completion, not to the strategy set.
  **This does not matter operationally**, because Theorem 6.3 also carries a direct finite-termination
  argument: every step that changes the strategy spends at least the cost `c_min > 0` of the cheapest
  combinator and the budget `κ` caps total spend, so the iteration is constant after at most
  `⌈κ/c_min⌉` steps. The lattice apparatus is decoration on a budget argument. I note this because
  the categorical framing is the reason this paper reached me, and it is the part that is least
  load-bearing.

**One presentational point worth recording rather than scoring.** The paper says both "Kleisli
category of the subdistribution monad" and `Δ(A ∪ {⊥})`. These are equivalent presentations —
adjoining an explicit `⊥` to the answer space turns subdistributions into genuine distributions — and
the paper uses them interchangeably without comment. The equivalence matters for § 3.2 point 2 above:
**making abstention an explicit answer is exactly the clean way to keep `del` natural when a generator
can fail**, which is the normalisation obligation I flagged as an open design choice for Evolve. Aksu
resolves it by construction. That is a direct, usable answer to a question I raised two sections ago.

#### 3.3.3 What this means for Ergodis: α = 0 kills §5 and promotes §8

**Ergodis' independent verification context has `α = 0` within a checker's declared scope.** The
paper states the consequence itself: "a perfect verifier (`α = 0`, `Λ = ∞`) certifies correctness
outright". So for Ergodis:

- **The entire amplification apparatus is vacuous.** One gate takes the odds to infinity. Theorem 5.1's
  `O(log(1/δ))` depth, Theorem 5.2's dichotomy, Proposition 3.2's log-odds cascade, Proposition 6.4's
  water-filling over `Δ log o / Δc`, and Table 4's worked cascade all describe a regime Ergodis is not
  in. **Do not import the log-odds objective.** Maximising log-odds gain per unit cost is the wrong
  objective function when the log-odds are already infinite after the first exact check.
- **`α = 0` is a claim about a specific checker implementation, not a law**, and that is where the
  amplification theory becomes relevant again. Ergodis' own record makes the point: C1097 found a
  legacy sibling-forgery gap — a checker that was not in fact sound. Two *independently implemented*
  checkers with small nonzero implementation-fault rates `α₁, α₂` do give a genuine `Λ₁Λ₂` cascade,
  and Theorem 5.1 then says what independent reimplementation buys. **This is the one place the
  amplification theorem applies to Ergodis, and it applies to checker-implementation trust, not to
  mathematical correctness.** Theorem 7.1's conditional-independence caveat bites hard here: two
  checkers sharing a library share evidence, and their effective `Λ` collapses toward 1.
- **What is left, and it is the useful half, is the cost homomorphism.** Cost is an *exact*
  homomorphism, reliability only a lax one — so in the regime where reliability is settled by one
  gate, the exact homomorphism is the whole content. With `α = 0` and a complete checker `β = 1`,
  Lemma 4.4's per-round acceptance probability `q = pβ + (1-p)α` collapses to `q = p`, giving two
  formulas Ergodis can use directly:
  - **Expected cost per admitted proposal** `= (1/p)·(c_propose + c_check)`.
  - **Budget for admission with probability `1-δ`**: commit probability is `1-(1-p)^T`, so
    `T ≥ ln δ / ln(1-p)` proposals.
  Those are exact, elementary, and immediately applicable to an Evolve campaign whose proposals
  succeed with rate `p`.
- **The recursion master theorem inverts.** With `α = 0` per node, `η = 0`, so `Nη = 0` and the union
  bound is trivially satisfied: **a verified recursive campaign is exactly correct at any depth**, and
  the paper's polylogarithmic reliability overhead vanishes. What remains is Proposition 9.1's
  warning in cost form: the number of nodes is `b^d`, and total cost is
  `Σ_v (1/p_v)(c_propose,v + c_check,v)`. The doubly-exponential collapse of unverified recursion
  (`r(d) = ρ_c^{(b^d-1)/(b-1)} p^{b^d}`) is the precise statement of why an Evolve campaign that
  decomposes without checking each level is worthless — and Ergodis already checks each level, so the
  paper's content for Ergodis is the cost recurrence, not the reliability one.

#### 3.3.4 Ordering cheap screens before exact checks — what the algebra does and does not say

This was the specific question, and the answer has two halves.

**What the paper says: not this.** Proposition 6.4's water-filling condition `∂ log o / ∂c_j = λ`
allocates budget to equalise marginal log-odds gain per cost. With `α = 0` that objective is
degenerate. Proposition 8.1's comparison ("verification dominates whenever a sufficiently
discriminating checker exists") is about verification versus *voting*, not about screens versus exact
checks. **The paper has no result on ordering an imprecise screen before an exact check**, because it
never considers a verifier whose purpose is to save another verifier's cost rather than to raise
reliability.

**What the algebra gives once you ask the right question — this derivation is mine, from the paper's
Lemma 4.3 and Lemma 4.4, and is not in the paper.** Put a cheap screen `(β_s, α_s)` at cost `c_s` in
front of an exact check at cost `c_x` (`β = 1`, `α = 0`), with generation cost `c_g` and proposal
correctness rate `p`. A candidate is admitted iff it is correct *and* passes the screen, so expected
generations per admission is `1/(p β_s)`; by Wald, expected exact checks per admission is that times
the screen pass rate `q_s = p β_s + (1-p) α_s`, which simplifies to

```
exact checks per admitted proposal  =  1 + 1/(o_pre * Lambda_s)         where o_pre = p/(1-p)
```

— a pleasing form, and it reduces to `1/p` when the screen is uninformative (`Λ_s = 1`), as it must.
Total expected cost per admitted proposal is
`C(screen) = (1/(p β_s))(c_g + c_s) + (q_s/(p β_s))·c_x`, against `C(none) = (1/p)(c_g + c_x)`.

**Now the constraint that matters for an exact engine.** A screen with `β_s < 1` rejects some correct
candidates. In Ergodis terms that destroys the coverage claim: the search is no longer complete over
the admitted family, and a ProofGenerating run silently becomes Heuristic. **So `β_s = 1` is
mandatory, not optional** — the screen must be *one-sided*, rejecting only candidates it can rule out.
Setting `β_s = 1` and simplifying the inequality `C(screen) < C(none)` gives

```
    the screen pays  <=>   c_s  <  c_x * (1 - p) * (1 - alpha_s)
```

and since `Λ_s = 1/α_s` when `β_s = 1`, equivalently `c_s < c_x·(1-p)·(1 - 1/Λ_s)`.

**Read it in words: a screen is worth running exactly when it costs less than the exact check times
the fraction of exact checks it eliminates** — `(1-p)` being the share of proposals that are wrong,
and `(1-α_s)` the share of those the screen catches. So `Λ` does enter, but only through
`α_s = 1/Λ_s`, and **the decision rule is a cost inequality, not a log-odds rate**. That is the direct
answer: the paper's marginal-rate machinery is the wrong tool, and the right tool is one line of its
cost homomorphism.

**And this closes a loop with § 2.2.** A one-sided screen with `β_s = 1`, `α_s < 1` is precisely a
sound relaxation-based prune: a dual bound never rejects an optimal solution (`β_s = 1`) and rejects
some non-optimal subtrees (`α_s < 1`). **The screen formalism and the dual-certificate formalism are
the same object**, and `c_s < c_x(1-p)(1-α_s)` is the rule for when computing the bound is worth it.
The `α_s` of a relaxation is one minus its prune rate, which is measurable from a single instrumented
run.

**On the no-free-lunch corollary and Ergodis.** Corollary 7.4 averages over *all* problem families.
Ergodis is a compiled exact engine for specific declared families, which is the structured case the
paper's own gloss exempts ("they only help on the structured problem families we actually face"). The
usable residue is not a constraint but a measurement discipline: **`α_s` and `p` are family-specific,
so the screen-ordering inequality must be evaluated per family and not assumed to transfer** — which
is exactly how Ergodis' family-specific admission architecture is already organised.

**Two further items worth carrying.** §10's Chow's-rule threshold (commit iff posterior correctness
exceeds `1 - c_abs/c_err`) is the right shape for deciding when an Evolve campaign should abstain and
escalate rather than keep proposing, and it needs only a calibrated score. §11's Λ-robustness is a
sharper warning than it first appears: a verifier is `Λ`-robust if `β/α†(v) ≥ Λ` against a
*worst-case* generator optimising for acceptance. The paper's observation that "proof checkers and
type systems are robust in this sense (their false-acceptance is bounded by soundness, independent of
how the prover was chosen); learned reward models and shallow heuristics often are not" is the
argument for why a **learned** screen must still be one-sided by construction rather than by
training: an Evolve loop that optimises proposals against a learned screen is a Stackelberg game the
screen loses.

---

## 4. C1150 rows 1–4 at algorithm depth

The first pass gave these as structures. This section gives the data and the operation. Pseudocode
is Rust-flavoured but deliberately not Ergodis API; the point is the shape, not the signature.

### 4.1 Rows 1 and 2 — the ban, and what it composes with

Rows 1 (composable ban as the exclusion half of a certified optimum) and 2 (admission refusals that
propagate) are **one data structure**. The nategory result says why they must be: negative
information composes only with positive information as a catalyst, so a ban is not a free-standing
record but an object indexed by the hom-set it constrains.

**The data.**

```rust
/// A ban on morphisms from `src` to `dst`, expansive over the cost preorder.
/// Semantically: the set of plans `p : src -> dst` such that `pred(p)` holds
/// is excluded, and the set is UPWARD CLOSED - if p is banned and p <= q,
/// then q is banned too.
struct Ban<Obj, Cost> {
    src: Obj,
    dst: Obj,
    /// The threshold. Everything with cost >= this is out.
    /// `Cost = Bool` recovers a hard ban; `Cost = OrderedResource` a bound.
    floor: Cost,
    /// Why. Never a bare flag - this is what the checker re-derives.
    reason: BanReason<Obj, Cost>,
}

enum BanReason<Obj, Cost> {
    /// A dual-feasible vector proving no plan here beats `floor`.
    DualCertificate { multipliers: ExactVec, value: Cost },
    /// This representation does not support this query. Structured, per C1091.
    AdmissionRefusal { violated: Contract, witness: DistinguishingPair<Obj> },
    /// Derived: this ban follows from another by composition (below).
    Transported { from: BanId, along: MorphismId, direction: Dir },
}
```

Two facts are load-bearing and both come from the sources. **Expansiveness** is Abbott & Zardini's
contribution over the original nategory formulation: `f` infeasible and `f ≤ g` implies `g` banned,
which is what makes one ban prune an upward-closed set rather than a point. **`reason` is not
optional**: a ban with no reason is exactly what the co-design implementations do (§ 4.4 below) and
it is why their infeasibility results cannot be checked or reused.

**The composition.** This is the operation that ordinary category theory does not give you, and it
runs *backwards*.

```rust
/// Transport a ban along a morphism. Two directions, because a ban on
/// src -> dst constrains anything that could route around it.
///
/// Given ban n on (a -> c) and a morphism f : a -> b, we must ban
/// (b -> c) - otherwise f ; g would circumvent n.
fn transport_pre<O, C>(f: &Morphism<O, O>, n: &Ban<O, C>) -> Option<Ban<O, C>> {
    debug_assert_eq!(f.src, n.src);
    // The side condition. Without monotonicity the transported floor is
    // not valid and we must refuse rather than guess.
    if !f.is_monotone_nondecreasing() { return None; }
    Some(Ban {
        src: f.dst.clone(),
        dst: n.dst.clone(),
        // Triangle inequality, stated the way C1150 row 3 wants it:
        //   L(f ; g) <= L(f) + L(g)   =>   L(g) >= L(f ; g) - L(f)
        // so a floor on the composite induces a floor on the tail.
        floor: n.floor.monus(&f.cost_lower_bound()),
        reason: BanReason::Transported {
            from: n.id(), along: f.id(), direction: Dir::Pre,
        },
    })
}

/// Dual direction: ban n on (a -> c) and g : b -> c forces a ban on (a -> b).
fn transport_post<O, C>(n: &Ban<O, C>, g: &Morphism<O, O>) -> Option<Ban<O, C>> { /* mirror */ }
```

`monus` is truncated subtraction — in a `Sat_n`-style ordered semiring (§ 2.3) it is the operation
that keeps the floor in the resource poset instead of falling off the bottom. **Note that
`transport_pre` returns `Option`**: the monotonicity side condition is a genuine gate, and the
honest behaviour on failure is to emit no ban rather than an unsound one. That is the same discipline
as Abbott–Zardini's naturality side condition on index sliding.

**What this buys, concretely.** An admission refusal recorded once at `(model, query, scope)` is
transported to every plan that composes through that point, so the refusal is answered from the ban
set instead of re-running the check. And the `DualCertificate` variant means a bound found by a
gradient method (§ 2.2) enters the *same* structure as a structural refusal. One store, one
composition law, two enrichments — which is the Willerton unification of § 2.1 cashed out.

**Where it must be stored.** Not in a global table. The nategory failure result says bans indexed
independently of the morphisms they constrain do not compose; the index must be the hom-set. In
Ergodis terms that means the ban store is keyed by (source identity, query identity, scope), which is
the same key `Admission` already uses.

### 4.2 Row 3 — bound composition as an inference rule

Separated out because it is the row with the best cost/benefit and it is small.

```
Given:  an ordered-resource monoid (R, +, <=, 0)
        a plan composition operator  ;
        a lower-bound map  lb : Plan -> R

Require (this is the property to prove per family, once):
        SUBADDITIVITY   lb(p ; q)  <=  lb(p) + lb(q)
        MONOTONICITY    p <= q  implies  lb(p) <= lb(q)

Then the pruning rule is:
        if  lb(prefix) + admissible_h(suffix_target)  >=  incumbent:
                prune, and emit Ban{ floor: incumbent, reason: ... }

where admissible_h is any map with  admissible_h(t) <= true_cost(t),
i.e. an ADMISSIBLE HEURISTIC in exactly the A*/Dijkstra sense.
```

The nategories paper is the source for reading `admissible_h` as negative information: Censi,
Frazzoli, Lorand & Zardini identify A\* heuristics outright as negative information providing a lower
bound on path cost, and note that better heuristics make the algorithm faster. The link to § 2 is
then immediate and is the reason this section sits in this file rather than the last one: **a learned
or gradient-derived `admissible_h` is admissible as long as its output is clamped below by something
checkable.** Two ways to clamp, both standard:

- `admissible_h := min(learned_estimate, known_valid_bound)` — never worse than the valid bound, so
  admissibility is preserved by construction and the learned part can only help.
- `admissible_h := exact_dual_objective(repair(learned_multipliers))` — the § 2.2 pattern, where the
  learned object is a guess at a certificate and the repair-and-evaluate step produces the number.

The second is strictly better because the learned part can exceed the hand-written bound and remain
valid. The first is a one-afternoon experiment.

**Ergodis object:** `ordered_resource`, which supplies `(R, +, ≤, 0)` and Pareto fronts and does not
currently carry the subadditivity law. **Gate:** the retained single/parallel A/B work counters must
show a node-count reduction with bit-identical answers on the whole differential corpus.

### 4.3 Row 4 — the integral transform, written out

The C1150 entry said "polynomial span plus semiring". Here is what that is as code, following
Dudzik & Veličković's construction.

```
A polynomial span is four finite sets and three functions:

        W  <--i--  X  --p-->  Y  --o-->  Z

    W = where inputs live        X = arguments
    Y = messages                 Z = where outputs live

Data on a set S with values in a semiring R is  [S, R] = { f : S -> R }.

    integral_transform(span, R, f : [W,R]) -> [Z,R]:
        # 1. PULLBACK. Free - just composition.
        a : [X,R]  =  \x -> f(i(x))

        # 2. ARGUMENT PUSHFORWARD - dependent PRODUCT along p, using (*).
        m : [Y,R]  =  \y -> PROD_{x in p^-1(y)} a(x)

        # 3. MESSAGE PUSHFORWARD - dependent SUM along o, using (+).
        #    MUST be a bag/multiset fold, not a set fold.
        out : [Z,R] = \z -> SUM_{y in o^-1(z)} m(y)
```

Three things that are easy to get wrong and that the source is explicit about:

- **Step 3 must aggregate over a multiset.** Dudzik & Veličković's stated reason is that the preimage
  `o^{-1}` lands in the power set, and a *set* of values "will fail to detect multiplicities; we are
  unable to tell from a subset of `R` whether multiple messages had the same value." Using a set here
  is C1091 rejection fixture 3 — it is the overlapping-repairs error at the level of the data
  structure.
- **`R` must be a semiring, and the choice of `R` is the query.** Their two instantiations: `(ℝ, ×, +)`
  for message-passing networks, `(ℕ ∪ {∞}, +, min)` — the min-plus/tropical semiring — for
  Bellman-Ford. They also note the converse holds: a set with two suitable aggregators, subject to
  reasonable conditions, *is* a semiring.
- **The span shape is the plan; the semiring is the readout.** For Bellman-Ford the span is built from
  the edge set with `i` the source/target functions, `p` collapsing copies of `E` into the computed
  message, and `o` the target function. Changing only `R` turns the same span into path counting,
  minimum weight, or a Pareto accumulation.

**The Ergodis experiment this implies is small and sharp.** `OpenProblem` already has
semiring-window adapters. Express one existing dynamic-programming kernel as an explicit span; re-derive
two of its current readouts by changing only `R`; compare bit-for-bit against the two hand-written
kernels and measure the hot loop against the retained allocation and layout assertions. The risk is
real and named in C1091: the ADR records historical leaf-fusion overhead from exactly this kind of
generalisation, so a regression here is a plausible outcome and is itself a useful result.

### 4.4 What the reference implementations actually do

The task asked what `pyncd`/`tsncd` or another implementation does for the negative-information part.
Short answer: **`pyncd` and `tsncd` do nothing at all for it, and the one co-design implementation I
could reach represents infeasibility as a value with no reason attached.** Details, because the
details are the useful part.

**`pyncd` (github.com/mit-zardini-lab/pyncd).** **Read depth: source inspection** — repository tree
listing via the GitHub API (70 blobs, untruncated), plus full reads of `README.md`,
`solver/numeric_solver.py`, `term_utilities/generate_config.py`, and symbol-level inspection
(`grep` of class/function definitions) of `graphs/Hypergraph.py`, `graphs/HypergraphAnalysis.py`,
`graphs/Hypergraph2Morphism.py`, `torch_compile/torch_compile.py` and
`data_structure/BroadcastedCategory.py`. Last pushed 2026-08-13. Files were fetched raw from
`raw.githubusercontent.com` at `HEAD`; I did not pin a commit SHA, so a later reader may see different
content.

What is actually in it:

- `data_structure/` — the term algebra of arXiv:2604.07242: `Term`, `Category`, `ProductCategory`,
  `BroadcastedCategory`, `StrideCategory`, `Operators`, `Numeric`.
- `construction_helpers/` — operator overloading: `@` sequential composition with **automatic axis
  alignment**, `*` products, `>>` batch lifting.
- `graphs/` — the morphism↔hypergraph round trip, cited in the README to the Piedeleu–Zanasi string
  diagram introduction. `AuxiliaryGraph.replace` / `replace_multiple` and a `ReverseCrawler` give the
  *mechanism* for subgraph rewriting. There is **no rewrite rule set, no rewrite search, and no cost
  function to rewrite against.** The README says the round trip is used to "normalize an expression
  before it is displayed" — the hypergraph form is a canonicalisation for rendering, not an optimizer.
- `solver/numeric_solver.py` — **39 lines**, and the honest summary is that it expands symbolic axis-size
  expressions into sum-of-products form (`expand_to_addition` distributes `Multiplication` over
  `Addition` by `itertools.product`). The one other function is commented out. This is not a solver in
  any optimization sense.
- `term_utilities/generate_config.py` — **95 lines**. `NumericConfig` walks a term collecting
  `FreeNumeric` leaves, groups them into `EqualityClass` buckets by name, and lets you assign integer
  values. That is the "degrees of freedom" story of the paper: *find the free variables and bind
  them*. There is no search over bindings, no objective, and no constraint.
- `torch_compile/torch_compile.py` — **332 lines**. Emits `nn.Module` trees: `Composed` ↦
  `nn.Sequential`, `ProductOfMorphisms` ↦ `nn.ModuleList`, broadcasted operations ↦ einops calls. The
  source carries the comment `# For now, we just use Einops`. No kernel generation, no tiling, no
  device selection.

**There is no cost model, no performance model, no memory-hierarchy code, and no negative-information
machinery anywhere in `pyncd`.** The transfer-count algebra and the Hopper configuration table of
*FlashAttention on a Napkin* live in the papers as derivations and a spreadsheet; they are not in the
package.

**`tsncd` (github.com/mit-zardini-lab/tsncd).** **Read depth: source inspection** — repository tree
listing only, no file contents. It is a TypeScript renderer: `CategoryRenderer.ts` (36 KB),
`BroadcastedCategoryRenderer.ts`, `StrideCategoryRenderer.ts`, draw helpers, an HTML render handler,
and a websocket transfer layer. Nothing computational.

**A monotone co-design implementation (github.com/cbriat/codesign-mcdp).** I could not reach a
Censi-authored `mcdp` repository — `AndreaCensi/mcdp`, `AndreaCensi/PyMCDP` and three other guesses
all returned HTTP 404, and a GitHub repository search for co-design/MCDP returned only two results.
So this is a **third-party from-scratch Python library for Monotone Co-Design Problems**, not the
author's own, and I have not checked it against the theory. **Read depth: source inspection** — tree
listing plus a full read of `codesign/solver.py` (595 lines) and targeted reads of `README.md`.
Fetched at `HEAD`, unpinned.

`kleene_loop` is the C1150 row 10 algorithm written out, and it is worth having because it is
specific where the paper is abstract:

- **Seed**: `A = Antichain.singleton(R_loop, R_loop.bottom())` — cold start at the bottom of the inner
  resource poset. A `start_from` parameter allows **warm starting** from a near-correct antichain,
  documented as able to "dramatically reduce iteration count in parameter sweeps". That is directly
  the Ergodis prepare-once/admit-budget-changes pattern.
- **One step**: for each point `r` in the current antichain, build the inner functionality from the
  outer `F` values plus `r`'s value on the fed-back loop axis, evaluate the inner design problem,
  cap runaway numerics to `+inf`, then `a_r.filter_above(r)` — keep only outputs dominating the
  resource that produced them, which enforces the feedback inequality — and finally
  `Antichain.union_min` to merge the per-point expansions back into one minimal antichain.
- **Four termination tests, in order**: (1) empty result ⇒ infeasible, collapse to `⊤`; (2)
  `A_next == A` ⇒ least fixed point reached, the success case; (3) every point pinned at the loop-axis
  top ⇒ the feedback demand can never be met, infeasible; (4) any numeric component past a divergence
  cap ⇒ stop and flag `diverged`.
- **Robustness detail worth copying**: an `OverflowError`/`ValueError`/`ZeroDivisionError` inside a
  module's evaluation is caught and treated as *local* infeasibility (`⊤`) rather than a crash, "so
  the rest of the antichain still iterates".

**And here is the negative-information answer.** The README states it exactly: "`status` and
`feasible` are orthogonal. `status='converged'` with `feasible=False` is a clean infeasibility (the
antichain settled at ⊤)." **Infeasibility is represented as a lattice value — the top element, or the
empty antichain — carrying no reason, no scope record, and no certificate.** It cannot be transported
to a neighbouring problem, cannot be checked by anything other than re-running the solve, and cannot
be composed. Termination tests 1 and 3 both produce "infeasible" and the result does not distinguish
them.

That is precisely the gap C1150 rows 1–2 identify, now confirmed against running code rather than
inferred from papers: **the theory of composable negative information exists, and the implementations
in this lineage do not implement it.** For Ergodis that is an opportunity rather than a warning —
there is no reference implementation to copy, so the `reason` field in § 4.1 is the design decision
that would distinguish an Ergodis ban store from what exists.

---

## 5. The weaves cost model against a WebGPU/wgpu backend for Evolve

With GPU back in scope, the quantitative half of *FlashAttention on a Napkin* stops being background
and becomes a candidate tool. This section says what it actually is, whether it retargets, what
kernels it would describe for Evolve, and what the existing packages give you (nothing).

### 5.1 The cost model, extracted

**Source.** Abbott & Zardini, arXiv:2412.03317v2, now **read depth: partial, extended from C1150** —
adding §2.1 (diagramming functions and data types), §2.2 (hierarchy levels, transfer cost and memory
usage, compute approximation), §2.3 (group partitioning), §4.1 (optimal transfers), §4.2 (multi-level
performance models) and §4.3 (quantization) to the sections read previously. Same cached bytes,
sha256 `03dce23b4e57a0070cbd4997986ff12a529fe3c3d9f3d49d1cb7578aca93be95`.

The model is smaller than its reputation, which is the good news:

- A **hierarchy is a graph of levels with their connections** (§2.2, Figure 7), and the paper states
  that these "model real GPU, and provide levels corresponding to logical abstractions" — the levels
  are not hardwired to any vendor.
- Arrays are **coloured by the level they live on**. Then, verbatim from §2.2: **total transfer cost
  `H_ℓ` is "the total size of data loaded to and saved from a level, equal to the sum of the size of
  arrays changing colors"**, and **memory usage `M_ℓ` is "lower bounded by the maximum size of data
  at a level for any column"**. The objective is to minimise total transfers subject to
  `M_ℓ ≤ M_ℓ^max`.
- **Compute** is approximated as the cost of the base operation times the size of the axes it is
  weaved over; a `k`-size contraction is `2k` FLOPs, so an `m×k` by `k×n` product is `2mkn`.
- **Group partitioning** (§2.3) is the one optimization move: if an algorithm is weaved over an axis,
  split the axis, apply the mapped function, rejoin. The low-level memory usage is then computed
  from the *group* size `g_a` rather than the full axis.
- **§4.1** states that the resulting optimum has a standard closed form:
  `H*(a⃗, M) = Σ_t α_t(a⃗) · M^{-β_t}`, where `t` indexes terms, `α_t` depends on axis sizes, and
  `β_t ≥ 0`. **The exponent is diagnostic**: they report `M^{-1}` for attention, meaning data is
  broadcast to all groups, and `M^{-0.5}` for matrix multiplication, meaning square tiling.
- **§4.2** composes levels: `H = Σ_t α_t(a⃗) · (Σ_ℓ Ḣ_ℓ^{-1} · M_ℓ^{-β_t})`, where `Ḣ_ℓ^{-1}` is a
  per-level weighted transfer cost, with `M_{ℓ0} → ∞` and `Ḣ_{ℓ0}^{-1} = 0` for the top level.
- **§4.3** handles bytes versus values: with `q` bytes per value, `M_ℓ = M_ℓ^{Bytes} / q` and
  `Ḣ_ℓ^{-1} = (Ḣ_ℓ^{Bytes} / q)^{-1}`.

**So the model's entire hardware dependence is four numbers per level** — capacity in bytes, transfer
rate in bytes, the level graph's edges, and `q`. Nothing in it is Hopper-specific; the Hopper content
of the paper is §5's worked derivation and configuration table, not the model.

### 5.2 Retargeting to WebGPU: the numbers are available and the shape fits

**Source for the limits.** W3C WebGPU specification, `https://www.w3.org/TR/webgpu/`, fetched
2026-09-12. **Read depth: partial** — the "supported limits" table and the optional-features list
only, extracted from the fetched HTML; I did not read the specification text. The document is a
living specification and the numbers below are its *default* maximums, which a given adapter may
exceed or an implementation may expose differently.

| WebGPU default limit | Value | Role in the cost model |
|---|---|---|
| `maxComputeWorkgroupStorageSize` | 16384 bytes | `M_{ℓ1}^{Bytes}` — the shared-memory tile budget |
| `maxComputeInvocationsPerWorkgroup` | 256 | ceiling on the group size `g_a` |
| `maxComputeWorkgroupSizeX` / `Y` | 256 | per-dimension tile shape bound |
| `maxComputeWorkgroupsPerDimension` | 65535 | dispatch fan-out, i.e. how many candidates per launch |
| `maxStorageBufferBindingSize` | 134217728 bytes (128 MiB) | working-set bound at level `ℓ0` |
| `maxBufferSize` | 268435456 bytes (256 MiB) | total resident problem size |

Optional features named in the specification's feature list include `"shader-f16"` and
`"subgroups"` — both **optional**, so a portable kernel cannot assume either. There is no f64 in this
list.

**The three-level graph is therefore:** storage buffer (`ℓ0`, 128 MiB binding, host-visible) →
workgroup storage (`ℓ1`, **16 KiB**) → thread-private registers (`ℓ2`, implementation-defined). That
is exactly the two-to-three level shape the paper's worked examples use, so the derivations transfer
without modification to their structure. What changes is that `M_{ℓ1}` is 16 KiB rather than Hopper's
shared-memory budget, which is roughly an order of magnitude smaller — and since `H* ∝ M^{-β}`, a
smaller `M` means **more transfers, with the penalty governed by `β`**. Concretely, the model
predicts that a `β = 0.5` workload (matrix-multiplication-shaped, square tiling) degrades as
`M^{-0.5}` and so loses about a factor of 3 in transfer count for a 10× smaller tile memory, while a
`β = 1` workload (broadcast-shaped) loses the full 10×. **That is a usable design rule before writing
any kernel: on WebGPU, prefer the `β = 0.5` formulations.** (The arithmetic in this paragraph is mine,
substituting into the paper's formula; the paper does not discuss WebGPU.)

### 5.3 What kernels this would describe for Evolve

**My inference throughout.** Four candidate kernel families for Evolve's candidate evaluation and
neighbourhood scans, ordered by how well the cost model fits them.

1. **Batched independent candidate scoring.** One workgroup per candidate structure, candidates
   packed contiguously in a storage buffer. Pure streaming: every byte is read once, `β = 1`, and the
   model predicts a bandwidth-bound kernel whose time is `(bytes of candidate set) / Ḣ_{ℓ0}`. This is
   the least interesting case analytically and the most likely to pay immediately, because Evolve's
   proposals are independent by construction and the dispatch ceiling of 65535 workgroups per
   dimension is far above any plausible proposal batch.
2. **Neighbourhood scans with a shared prefix.** Evaluating all `k`-neighbours of a current structure
   shares most of the work. This is *exactly* the streamability setting: if the score is a fold with
   an accumulator `B` satisfying `B(f(x), y) = f(x ⊕ y)` (Wilson–Zanasi's Definition 1 as used in
   C1150 § 3.5), then the Fusion Theorem says composition and weaving preserve streamability, so the
   shared prefix can be computed once into workgroup storage and the neighbours streamed past it.
   **This is the case where the paper's machinery earns its keep**, because the theorem tells you in
   advance whether the fusion is legal and the cost model tells you the tile size.
3. **GF(2)/GF(4) packed-bitset kernels.** XOR and popcount over `u32` lanes. WebGPU's `u32` is exact,
   no optional feature is needed, and Ergodis' existing packed representations map directly. This is
   the most exactness-safe family.
4. **Min-plus (tropical) semiring products for bound computation.** This is C1150 row 4 / § 4.3 above
   with `R = (ℕ ∪ {∞}, +, min)`, and it is matrix-multiplication-shaped, so the paper's square-tiling
   result (`g_a = g_c` optimal, `H ≥ 2abc·M^{-0.5} + ac`) applies unchanged — the derivation comes
   from the dot product being streamable, not from anything about floating point. Over integers this
   is exact. It produces *bounds*, which under § 1 are checkable, so it sits on the admissible side.

**The exactness boundary for all four.** WGSL guarantees exact `u32`/`i32`; `f16` and subgroups are
optional; there is no f64 and therefore no route to exact rational arithmetic on the GPU. So the rule
is: **the GPU filters and orders; the CPU certifies.** A GPU pass emits a ranked shortlist or a set
of candidate bounds, and every one that matters is re-derived in exact arithmetic on the host before
it enters any claim. That is the same boundary as § 2.2's dual-certificate repair step, and it means
a GPU backend needs no new evidence story at all — it is an ordering device under § 1's first row.

### 5.4 What `pyncd`/`tsncd` emit today, against this

Restating § 4.4's finding in this context, because it is the direct answer to the question:

- **No cost model exists in the code.** `H_ℓ`, `M_ℓ`, `α_t`, `β_t`, `Ḣ_ℓ^{-1}` and `q` appear nowhere.
  The `solver/` package is 39 lines of symbolic sum-of-products expansion over axis-size expressions.
- **No tiling or group partitioning exists in the code.** `generate_config.py` collects free axis-size
  variables and lets you bind them by hand; there is no search over bindings and no memory constraint.
  The Hopper configuration table of §5.6 of the paper is a table in the paper.
- **The compilation target is PyTorch, via einops**, with the source comment `# For now, we just use
  Einops`. There is no kernel emission of any kind, no WGSL, no CUDA, no Triton.
- **The rewriting mechanism exists but has no rules and no objective.** `graphs/` implements the
  morphism↔hypergraph round trip with `replace`/`replace_multiple` and a `ReverseCrawler`; the README
  says its purpose is to normalise an expression before display.

**So the honest position is that the weaves line offers Ergodis a derivation discipline and a
four-parameter cost model to implement, not a compiler to adopt.** The implementation cost is
therefore the cost of writing the cost model against Ergodis' own plan terms — which is small, since
the model is six lines of arithmetic — plus the cost of a WGSL backend, which is the real expense and
is independent of anything in these papers.

---

## 6. Consciously set aside on the first pass

Named, and re-assessed on capability alone — no novelty, no priority, no "is it well covered".

### 6.1 Equality saturation and e-graphs — the largest miss

I skipped this on the first pass because it surfaced in a search result, is not category theory, and
looked like standard compiler engineering. On capability it is **the most directly usable item in
either report**, because it is the operational layer that both the Abbott–Zardini hypergraph story
and the ZX story are missing.

**Willsey, Nandi, Wang, Flatt, Tatlock & Panchekha, *egg: Fast and Extensible Equality Saturation*.**
Citation from the consulted sources: Max Willsey, Chandrakana Nandi, Yisu Remy Wang (University of
Washington, Seattle), Oliver Flatt (University of Utah, Salt Lake City), Zachary Tatlock (University
of Washington), Pavel Panchekha (University of Utah); read as arXiv:2004.03082v3 [cs.PL], 7 Nov 2020;
published with doi `10.1145/3434304` (2021), with a second record at doi `10.1145/3815481` (2026) —
both from OpenAlex; I did not determine the relationship between the two records. **Read depth:
partial** — abstract and §1 Introduction. Already present in the shared cache under key
`arXiv:2004.03082` (sha256 beginning `058eb744cb833c47`) from an earlier fetch; my add was refused as
a duplicate and I did not compare bytes.

**What it gives you.** An **e-graph** extends union-find to compactly represent equivalence classes
of expressions while maintaining closure under congruence. **Equality saturation** grows the e-graph
by repeatedly applying pattern-based rewrites; the paper's key operational observation is that
**"these rewrites only add information to the e-graph, eliminating the need for careful ordering"** —
so the phase-ordering problem that plagues ordinary rewriting disappears. At a fixed point
(saturation) or timeout, an **extraction** procedure pulls out the best expression with respect to a
cost function. Their two contributions are `rebuilding`, an amortised invariant-restoration technique
giving asymptotic speedups, and **`e-class analyses`, a general mechanism for attaching
domain-specific analysis data to equivalence classes**. It is an open-source **Rust** library.

**Why this is the missing piece, and it is my inference:** § 5.4 established that `pyncd` has a
rewriting *mechanism* with no rules, no search and no objective; C1150 § 5.4 established that ZX gets
its wins by rewriting under a maintained invariant with a deterministic extraction step. Equality
saturation supplies exactly the two things neither has: a **search discipline that does not require
choosing rewrite order**, and an **extraction step driven by an explicit cost function**. Put the
three together and the architecture is complete:

```
plan term  --lower-->  e-graph
           --saturate with rewrite rules (order-free, monotone)-->
           --extract by cost function-->  optimized plan term
                      ^                            ^
                      |                            |
        e-class analysis carries the      cost function = the weaves
        structural invariant (the ZX      transfer model of section 5.1
        "generalised flow" role, or       (or Ergodis' own measured cost)
        Ergodis' preservation contract)
```

**Three specific fits to Ergodis**, all mine:

1. **`e-class analysis` is where a preservation contract lives.** An e-class analysis is a lattice
   value computed per equivalence class and maintained under merging. A preservation contract — "this
   class of plans answers query `Q` exactly", "this class is streamable with accumulator `B`",
   "capacity bound `k` holds here" — is exactly that shape. So the C1150 row 7 closure property has a
   standard implementation slot, and if the property fails to be maintained under a merge, the
   framework tells you.
2. **It is Rust.** Ergodis is Rust with a hard zero-allocation hot-loop discipline. Equality
   saturation belongs in the *cold* compilation stage, which is where Ergodis already puts semantic
   richness ("Semantic richness belongs at cold validation/compilation boundaries", C1091). The fit is
   architectural, not just linguistic.
3. **The extraction cost function is the natural home for a learned or measured cost model.** § 1's
   ordering role applies verbatim — extraction chooses among *provably equivalent* expressions, so a
   bad cost model yields a slow plan, never a wrong one. **This is the single safest place in the
   entire system to put a learned component**, because equivalence is established by the rewrite
   rules and the learned part only breaks ties.

I have not checked whether any published work combines equality saturation with string-diagram or
hypergraph rewriting in the Bonchi–Gadducci–Kissinger–Sobociński–Zanasi sense; that would be worth a
bounded search before building.

### 6.2 The `Para` construction — under-rated on the first pass

C1150 § 5.3 called `Para` "dead weight unless the parameter is a budget", which was the
novelty-flavoured reading. On capability: `Para(C)` has objects those of `C` and a morphism
`⟨θ, f⟩ : X → Y` given by a parameter object `θ` and a map `f : θ ⊗ X → Y`, composing as
`⟨θ,f⟩ ⨟ ⟨φ,g⟩ = ⟨φ ⊗ θ, (id_φ ⊗ f) ⨟ g⟩` — parameters **accumulate into a tape** while the
composition of the underlying maps is undisturbed (Abbott & Zardini's Definition 14, restating Fong,
Spivak & Tuyéras).

Read without any gradient in mind, that is precisely **prepare-once/query-many with the query
parameters threaded through composition automatically**, which is Ergodis' `RepairModel → RepairPlan
→ BudgetQuery` and its retained-provider "source/query normalization" pattern. The tape is the
accumulated parameter list of a composite plan — exactly what you need to know in order to say which
parameter changes are admitted without recompilation. **That is a capability, not a formalisation**:
it tells you mechanically which parameters a composite exposes. I mis-rated it because I was reading
`Para` as backpropagation scaffolding.

### 6.3 Geometric deep learning, with the network removed

C1150 passed over geometric deep learning as the "top-down" foil in the categorical-deep-learning
position paper and did not assess it. Stripped of networks, its method is: **given a group action,
derive the admissible operator set by solving the equivariance constraints.** That is invariant
theory and orbit computation, and it requires no gradient at all. Gavranović et al.'s own stated
limitation — that usability "directly correlates with how easy it is to resolve equivariance
constraints" — is a statement about a computation, not about learning.

Ergodis already runs in this territory: the architecture context records "checked capacity bounds,
Hadamard row relations and CSS source symmetries" applied to active execution, and composed CSS root
orbits in the learned-rule ADR. **The capability question is whether symmetry-reduced search can be
driven from a declared group action rather than family-by-family**, and the geometric-deep-learning
method — solve the commutant, enumerate the admissible operators — is a template for that. Not
assessed further here; flagged as a genuine gap in both reports.

### 6.4 String Diagram Rewrite Theory — promoted from "standard" to "the termination story"

C1150 read this at abstract depth and treated it as background theory for the hypergraph move. On
capability, the sentence that matters is the last one of its abstract: they derive **a termination
strategy for Interacting Bialgebras**. Termination and confluence are precisely what turns a rewrite
*mechanism* into an optimizer you can run unattended, and § 6.1's equality saturation sidesteps
ordering but still needs a saturation bound. The double-pushout correspondence is sound *and
complete* modulo Frobenius structure, so it also tells you when the hypergraph representation is
faithful — which is the soundness obligation for § 6.1's lowering step.

### 6.5 ZX-calculus — under-read as an "existence proof"

C1150 § 5.4 treated Duncan–Kissinger–Perdrix–van de Wetering as evidence that categorical rewriting
can optimize discrete exact problems. On capability the connection to Ergodis is closer than that:
Ergodis has delivered CSS and quantum-error-correction families, composed CSS root orbits, and
residual-charge discovery. ZX is the standard rewrite calculus for exactly those objects, and it has
maintained open implementations. **I did not pursue the implementations and should have**; a bounded
follow-up should establish what the current tooling computes, since a Rust implementation would sit
directly alongside Ergodis' existing QEC kernels. Flagged, not assessed.

### 6.6 Things re-checked and still set aside

- **Shiebler, Gavranović & Wilson, *Category Theory in Machine Learning*** (`arXiv:2106.07032`,
  **read depth: abstract/metadata only**, unchanged from C1150 — the PDF is cached and I did not open
  it). A survey. Surveys give orientation, not capability. Still unread by me, still worth mining if
  breadth is wanted.
- **Cockett, Cruttwell, Gallagher, Lemay, MacAdam, Plotkin & Pronk, *Reverse Derivative
  Categories*** (`arXiv:1910.07065`, **read depth: abstract/metadata only**). Superseded for our
  purposes by Wilson–Zanasi § 2.3, which instantiates it at the semiring level where Ergodis lives.
- **Dudzik, von Glehn, Pascanu & Veličković, *Asynchronous Algorithmic Alignment with Cocycles***
  (`arXiv:2306.15632`, **read depth: partial**, abstract and introduction, unchanged). Still a lead
  rather than a finding: "separate update definition from invocation, prove invariance under
  asynchrony" is the right shape for Evolve's late-proposal retention rule, and I have not read the
  theorem.

---

## 7. Absorption table (C1151 part A)

Same six fields as C1150 § 6, plus the dependency column. "Neither" means no gradient and no learned
model is required for the row to pay. Confidence is mine. Rows are numbered C1151-1 upward to avoid
collision with C1150's numbering.

| # | Candidate structure | Ergodis object | Expected benefit | Cheapest experiment | Measured gate | Needs | Conf. |
|---|---|---|---|---|---|---|---|
| **C1151-1** | **Dual-certificate bound from an inexact continuous relaxation**, repaired to exact rational dual feasibility (§ 2.2) | Bound tightening in exact search; `Coverage`; the C1148 certificate-interoperability work | Lets any continuous or gradient method produce a *certified* lower bound, because the bound is emitted by exact arithmetic and the heuristic only guesses the multipliers | Take one exact family that currently prunes by a hand-derived bound. Add a float relaxation, round-and-repair to dual feasibility, evaluate the dual objective exactly, and prune on it | Bit-identical optimal answers on the full differential corpus; node-count reduction on the retained A/B work counters; every emitted bound independently re-checkable in exact arithmetic | **Gradient** (optional — simplex works too) | **High** — the exactness argument is weak duality and the checker is arithmetic, so failure is visible immediately |
| **C1151-2** | **Learned scorer for Evolve proposal ordering** (linear or gradient-boosted tree over existing features) (§ 2.4) | Evolve proposal ordering and admission | Reorders which proposals reach the independent family checkers first. The Gasse et al. baselines show LambdaMART and a ranking SVM beating an expert-tuned rule inside an exact solver, with guarantees untouched | Log the features Evolve already has (family, capacity bounds, prior race outcomes, symmetry counts) against realised proposal value for one campaign; fit a ranking model offline; replay the campaign with the new order | Time-to-first-admitted-proposal and total campaign work, measured against the current order on retained campaigns; and **bad-tail selection regret**, not mean, per C1091 | **Small NN / small model** (tree ensemble or linear; no GPU) | **High** — ordering cannot affect correctness, the features exist, and the experiment is offline |
| **C1151-3** | **Ban store with a `reason` field and backward transport** (§ 4.1), unifying admission refusals and dual certificates | `Admission`; certificates; Evolve's structured counterexamples | One store answers "is this excluded?" for both structural refusals and cost bounds, and a refusal recorded once is transported to every plan routing through it instead of re-derived | Instrument one family's admission checks to emit `Ban{reason}` records; implement `transport_pre`/`transport_post` with the monotonicity gate; measure how many later checks are answered from the store | Count of checks short-circuited over a real campaign with **zero** incorrect short-circuits under full re-check replay; and the `Option` return must actually fire on non-monotone morphisms | **Neither** | **High** — pure bookkeeping with an exact replay gate; the co-design implementation in § 4.4 shows what the absence of `reason` costs |
| **C1151-4** | **Subadditivity law on `ordered_resource` enabling admissible-heuristic pruning** (§ 4.2) | `ordered_resource`; plan composition; repair scheduling | Supplies the missing composition-of-bounds rule, which is what makes A\*-style pruning available inside an exact search | Prove `lb(p⨟q) ≤ lb(p)+lb(q)` for one family, add `admissible_h := min(learned_est, known_valid_bound)`, prune | Node/work-count reduction on retained A/B counters with identical exact answers; admissibility must hold by construction (the `min` clamp) rather than by assumption | **Neither** (a learned `h` is an optional upgrade) | **High** — carried over from C1150 row 3, now with the clamp construction that makes the learned variant safe |
| **C1151-5** | **Equality saturation over plan terms with cost-driven extraction** (`egg`-style, § 6.1) | Plan compilation; FeatureDag lowering; the rewriting mechanism Ergodis does not have | Order-free rewrite search — the phase-ordering problem disappears because rewrites only add information — plus an extraction step that picks the cheapest provably-equivalent plan | Encode one plan family's rewrite rules, saturate on a handful of real plans, extract with a simple cost function, compare against the current hand-lowered plan | Every extracted plan must agree exactly with the unoptimized plan on the differential corpus; cold-compile time must stay inside the compilation budget; at least one plan must extract strictly cheaper | **Neither** (a learned cost function is an optional upgrade, and is the safest possible place for one) | **Medium-high** — the mechanism is proven and in Rust; the open question is whether Ergodis plan terms have enough non-trivial equivalences to make saturation worth it |
| **C1151-6** | **`e-class analysis` carrying a preservation contract** (§ 6.1) | Preservation contracts across compiler/verifier boundaries — C1091's named central gap | Gives the C1150 row 7 closure property a standard implementation slot, and makes violation under class merging detectable rather than silent | Attach one existing contract (the C1095 admitted-observable check is the most self-contained) as an e-class analysis over the C1151-5 prototype | The analysis must be maintained correctly under every merge, verified by re-running the contract check on extracted representatives; a merge that would violate it must be observable | **Neither** | **Medium** — depends entirely on C1151-5 landing first |
| **C1151-7** | **`PolyCirc_S` reverse derivative over a saturating or prime semiring** for discrete parameter tuning (§ 2.3) | Evolve parameter proposals over discrete parameters; prime-field kernels | A principled local update for discrete parameters, with functional completeness settled for `Z_p` (prime `p`) by Theorem 5.2 and Example 5.3 — and Ergodis already carries 54 prime specialisations | Pick one discrete Ergodis parameter currently tuned by enumeration; express the objective as a polynomial circuit over `Sat_n`; run reverse-derivative ascent; compare to enumeration | Must reach enumeration's best value at strictly lower cost on a retained benchmark; the semiring must be `Sat_n`-like, not modular, or the wrap-around failure the authors document will silently stall updates | **Gradient** (discrete reverse derivative; no network) | **Low-medium** — the theory is solid and the semiring fit is excellent, but the only published measurements are Iris and two-class MNIST, and §7 of the paper lists the empirical work as planned |
| **C1151-8** | **Markov-category discipline on Evolve's proposal distribution** — normalisation (`del` natural), sharing (`copy` not natural), determinism as a checkable predicate (§ 3) | Evolve proposal sampling; kick selection; the structured-counterexample path | Prevents two specific silent errors — unnormalised generators after abandoned compilations, and correlated samples from a memoised proposal treated as independent evidence | Audit the current proposal path for both: does an abandoned generation renormalise, and is any proposal cached and reused across consumers? | Both audits answered explicitly in code, and a test reproducing the C1091 fixture-3 arithmetic (overlapping events at independent survival ½ giving 3/8) against the accounting path | **Neither** | **High** — this is an audit with a known-answer test, and the Wilson–Zanasi gradient wrap-around case is the same bug arriving from a third direction |
| **C1151-9** | **Conditioning and Bayesian inversion over a finite declared context** — learning from refuted proposals (§ 3.2) | Evolve proposal ordering; structured counterexamples | Turns "Evolve learns from its failures" into a defined operation: a tabular conditional over the finite admitted context, updated by disintegration. Conditionals exist in the finite case (they fail in `Stoch`), so this is well-defined rather than merely plausible | Build a tabular joint over (structural hypothesis class × counterexample species) from retained campaign logs; condition; use the posterior as the C1151-2 ordering prior | Replayed campaigns must reach the same admitted set with less work; the posterior must never gate admission, only order it | **Neither** (tabular; a small model is an optional upgrade) | **Medium** — well-defined and cheap, but its value depends on there being enough retained refutation data to condition on |
| **C1151-10** | **Weaves transfer-cost model retargeted to WebGPU** — `H*(a⃗,M)=Σ_t α_t M^{-β_t}` with WebGPU's level graph and limits (§ 5) | Evolve candidate evaluation and neighbourhood scans | Predicts tile sizes and which formulations survive a 16 KiB workgroup budget *before* any WGSL is written; the `β` exponent alone says prefer `β=0.5` (tiled) over `β=1` (broadcast) shapes | Derive `α_t`, `β_t` for one Evolve neighbourhood scan by hand from the paper's recipe (transfer cost = arrays changing level; memory = max resident per column); predict the optimal group size against `maxComputeWorkgroupStorageSize` | A `wgpu` prototype of that one kernel must land within a stated factor of the predicted transfer count, and must beat the CPU scan on the retained benchmark; predictions made **before** measurement and recorded | **Neither** for the model; **GPU** for the backend | **Medium** — the model is six lines of arithmetic and clearly retargets, but the whole value rides on the WGSL backend, which these papers do not help with |
| **C1151-11** | **Tropical (min-plus) semiring span kernels on GPU** — C1150 row 4 instantiated at `R = (ℕ∪{∞}, +, min)` on `u32` lanes (§ 4.3, § 5.3) | `OpenProblem` semiring-window adapters; bound computation | Exact integer dynamic programming on the GPU with the paper's square-tiling result (`g_a=g_c`, `H ≥ 2abc·M^{-0.5}+ac`) applying unchanged, since it follows from streamability of the dot product and not from floating point | Express one DP bound computation as a span with `R` = min-plus; write the `u32` WGSL kernel; check against the CPU kernel | Bit-identical results to the CPU kernel on every case (exactness is free here — `u32` is exact in WGSL); measured speedup on the retained benchmark | **GPU** | **Medium** — exactness is genuinely free, but the kernel is real engineering and `wgpu` dispatch overhead may eat the win at Ergodis' problem sizes |
| **C1151-12** | **`Para` tape as the admitted-parameter-change contract** (§ 6.2) | `RepairModel → RepairPlan → BudgetQuery`; retained provider source/query normalization | Mechanically derives which parameters a *composite* plan exposes, so "which changes are admitted without recompilation" is computed rather than documented | Compute the accumulated parameter object for two composed plans in the existing repair pilot and compare against the hand-maintained list of admitted budget changes | The computed tape must exactly match the hand-maintained admitted set, or the mismatch must be a real bug in one of them | **Neither** | **Medium** — the construction is trivial; the value is in whether the hand-maintained list is currently wrong anywhere |
| **C1151-13** | **Learned branching/variable ordering inside exact kernels** (§ 2.4) | The hot loop of the exact kernels | The largest potential win in the table (Gasse et al. report SCIP default 1677 s → 1490 s with 70 vs 65 solved on their hard set) and the only row that touches a hot path | Offline only at first: log branching decisions and outcomes, fit a **linear** scorer over integer features, measure predicted vs realised improvement without deploying | Deployment gated on the full hot-loop discipline — zero allocation, retained single/parallel A/B counters, layout assertions — plus bad-tail regret, not mean time | **Small NN / small model**, and probably must be linear to survive the hot-loop gates | **Low-medium** — high value, but the published wins come from models that will not fit Ergodis' hot-loop constraints, and the linear variant is the untested one |

| **C1151-14** | **One-sided screen ordering by the cost inequality `c_s < c_x·(1-p)·(1-α_s)`** (§ 3.3.4), derived from Aksu's cost homomorphism | Evolve proposal admission; the exact checker's invocation count; the § 2.2 dual-bound prune, which is the same object | Decides when a cheap imprecise screen in front of the exact check pays, by a measurable inequality rather than by judgement. Both quantities on the right are measurable from one instrumented run: `p` is the proposal success rate, `α_s` is one minus the screen's prune rate on wrong proposals | Instrument one Evolve family for a campaign: log `p`, the screen's `α_s`, `c_s` and `c_x`. Evaluate the inequality. If it predicts the screen pays, enable it and compare total checker invocations against the unscreened arm | Predicted versus realised reduction in exact-check invocations, with the prediction recorded **before** the run; and the admitted set must be **identical** to the unscreened arm, which is the test that `β_s = 1` actually holds | **Neither** (a learned screen is an optional upgrade, and must still be one-sided by construction) | **High** — the derivation is two lines of Wald plus Bayes, both quantities are measurable, and the identical-admitted-set check catches a non-one-sided screen immediately |
| **C1151-15** | **Cost-recurrence master theorem for verified Evolve campaigns** (§ 3.3.3): with `α = 0` the reliability recursion is trivial and the live object is `Σ_v (1/p_v)(c_propose,v + c_check,v)`, with per-node admission budget `T ≥ ln δ / ln(1-p)` | Campaign budgeting; repair schedules; recursive decomposition in Evolve | Turns "how much budget does this campaign need" into a closed-form prediction from per-node proposal success rates, replacing a wall-clock guess. Also gives the abstain-and-escalate threshold (Chow's rule, § 3.3.4) a principled form | Fit `p_v`, `c_propose,v`, `c_check,v` from retained campaign logs for one decomposed campaign; predict total cost and the per-node budget `T`; compare against what the campaign actually spent | Predicted versus actual total invocations within a stated factor on retained campaigns, prediction recorded first; and the `T` budget must achieve the stated `1-δ` admission rate empirically | **Neither** | **Medium-high** — the formulas are exact under i.i.d. proposals, and the open question is whether Evolve proposals are close enough to i.i.d. for the prediction to hold; a large miss is itself a finding about proposal correlation |
| **C1151-16** | **`Λ`-cascade across independently implemented checkers** (§ 3.3.3), i.e. Theorem 5.1 applied to checker-implementation trust rather than mathematical correctness | Independent verification; the C1097 sibling-forgery class of defect | Quantifies what a second, independently written checker buys: odds of an implementation fault multiply down by `Λ₁Λ₂`. Gives a reason to reimplement a checker that is stronger than "belt and braces" | Estimate `α` for one existing checker from its defect history (C1097 is one data point), then state what a second independent implementation would have to satisfy to reach a target fault odds | An estimate of `α` with its evidence, and an explicit check of the conditional-independence hypothesis: shared libraries, shared authors, and shared test corpora all collapse the effective `Λ` toward 1 | **Neither** | **Low-medium** — the theorem is correct and the application is real, but estimating `α` for a checker from a handful of historical defects is weak evidence, and the independence hypothesis is the hard part |

**If only one thing is done:** C1151-1 and C1151-3 together. They are the same object — a ban with a
reason — reached from the two directions this file is about, and between them they let a gradient
method into the engine (as a certificate guesser) and make its output compose (as a transported ban)
without touching a single evidence claim. C1151-4 is the cheapest standalone win. C1151-5 is the
biggest architectural bet and the one whose payoff is least predictable from the outside. **C1151-14
is the cheapest of all** — it is an inequality evaluated against two numbers a single instrumented
campaign produces, and it decides a question (screen before exact check, or not) that recurs
everywhere in the engine.

---

## 8. Method, sources and coverage

### 8.1 Boundary, and a note on read depth for code

No deliverable in this report depends on the absence of prior work. It is a capability study: the
question everywhere is "would this make Ergodis able to do something it cannot do now", never "is
this new". The Attribution and read-depth obligations of `notes/literature-audit-conventions.md`
still bind, because this report characterises sources, and **every source named carries a read-depth
field, including sources named only to be set aside**.

**One extension, declared rather than smuggled.** Three of the sources here are code repositories,
and the vocabulary `{full text, partial, review only, secondary only, abstract/metadata only}` is
written for documents. I have used **`source inspection`** for these, and in each case stated exactly
which files were read in full, which were inspected only at symbol level (class and function
definitions via `grep`), and which were seen only as a tree listing. None was fetched at a pinned
commit — all reads are from `HEAD` on the date below — so a later reader may see different content;
that is recorded as a weakness of these three records, not papered over.

### 8.2 Source ledger by read depth

**Literature sources read at full text: 1 of 16 named in this file** — Aksu, `arXiv:2606.15712`, read
end to end including every proof. The other fifteen were read to algorithm depth rather than in full,
which is a deliberate consequence of the brief: I read the sections carrying the algorithm —
definitions, theorems, cost formulas, result tables — and every claim above names the sections it
rests on. Four *code* files were also read end to end.

**New in this report:**

- **Full text (1):** `arXiv:2606.15712` (Aksu, *Odds Law: The Decomposition Algebra*). All thirteen
  sections plus references; proofs of Lemmas 4.1–4.4, Theorems 5.1–5.2, 7.1–7.2, 9.2, 11.2 and
  Propositions 3.2, 8.1, 9.1, 10.2 checked rather than taken from the abstract, with the two
  proof-sketch weaknesses recorded in § 3.3.2. Figures 1–2 unrecoverable from the text extraction and
  characterised from captions. The companion "Maestro Order" report, which carries the paper's
  empirical claims, was **not sought or read**, so nothing empirical from that programme is assessed
  here.
- **Partial (10):** `arXiv:1501.03791` (Willerton, Legendre-Fenchel); `arXiv:2111.03956`
  (Boisseau & Piedeleu, graphical piecewise-linear algebra); `10.1016/j.jlamp.2023.100892`
  (Wilson & Zanasi, polynomial circuits — the most substantially read, §§1, 4.1, 5, 6, 7);
  `arXiv:1811.06128` (Bengio, Lodi & Prouvost); `arXiv:1906.01629` (Gasse et al.); `arXiv:1908.07021`
  (Fritz, Markov categories); `arXiv:1709.00322` (Cho & Jacobs); `arXiv:2004.03082` (egg); the W3C
  WebGPU specification; and `arXiv:2412.03317` (Abbott & Zardini, napkin) **re-read and extended**
  beyond its C1150 depth to cover §§2.1–2.3 and 4.1–4.3.
- **Source inspection (3):** `mit-zardini-lab/pyncd` — tree listing (70 blobs, untruncated), full
  reads of `README.md`, `solver/numeric_solver.py` (39 lines) and `term_utilities/generate_config.py`
  (95 lines), symbol-level inspection of `graphs/Hypergraph.py`, `graphs/HypergraphAnalysis.py`,
  `graphs/Hypergraph2Morphism.py`, `torch_compile/torch_compile.py`,
  `data_structure/BroadcastedCategory.py`; last pushed 2026-08-13. `mit-zardini-lab/tsncd` — tree
  listing only, no file contents; last pushed 2026-08-13. `cbriat/codesign-mcdp` — tree listing, full
  read of `codesign/solver.py` lines 203–430 (the `kleene_loop`) and targeted reads of `README.md`.
- **Abstract/metadata only (1):** `10.1287/ijoc.2016.0723`, Alejandro Marcos Alvarez, Quentin
  Louveaux & Louis Wehenkel, "A Machine Learning-Based Approximation of Strong Branching", *INFORMS
  Journal on Computing* 29(1), pp. 185–195, 2017 — title, authors, venue and pages from OpenAlex
  only. It surfaced in the branching search and is the canonical small-model (tree-ensemble) strong-branching
  approximation, but I did not obtain it and **nothing in this report rests on it**; the small-model
  evidence in § 2.4 comes from Gasse et al.'s own baseline rows instead.

**Carried from C1150 and re-assessed here on capability**, at the read depths recorded there and not
re-read except where stated: `arXiv:2604.07242`, `arXiv:2402.15332`, `arXiv:2203.15544`,
`arXiv:2306.15632`, `arXiv:2207.13589`, `arXiv:1902.03178`, `arXiv:2012.01847`, `arXiv:1712.07121`,
`arXiv:2106.07032`, `arXiv:1910.07065`.

### 8.3 Verbatim queries

GitHub (all HTTP 200 unless noted; empty vs error distinguished by a parseable JSON body with the
expected fields):

```
https://api.github.com/repos/mit-zardini-lab/pyncd          -> present, Jupyter Notebook, pushed 2026-08-13
https://api.github.com/repos/mit-zardini-lab/tsncd          -> present, TypeScript, pushed 2026-08-13
https://api.github.com/repos/AndreaCensi/mcdp               -> 404
https://api.github.com/repos/AndreaCensi/PyMCDP             -> 404
https://api.github.com/repos/zupermind/mcdp                 -> 404
https://api.github.com/repos/co-design-tools/mcdp           -> 404
https://api.github.com/repos/AndreaCensi/mcdp-book          -> 404
https://api.github.com/search/repositories?q=co-design+mcdp+monotone&per_page=8
      -> total_count 2: fgolemo/mcdp (HTML), cbriat/codesign-mcdp (Jupyter Notebook)
https://api.github.com/repos/mit-zardini-lab/pyncd/git/trees/HEAD?recursive=1    -> 70 blobs, truncated: False
https://api.github.com/repos/mit-zardini-lab/tsncd/git/trees/HEAD?recursive=1
https://api.github.com/repos/cbriat/codesign-mcdp/git/trees/HEAD?recursive=1
```

OpenAlex (all HTTP 200 with a well-formed `meta`/`results` body):

```
.../works?search=axiomatic+approach+differentiation+polynomial+circuits&per-page=5
.../works?search=graphical+piecewise+linear+algebra+string+diagrams&per-page=5
.../works?search=verifying+integer+programming+results+certificate&per-page=5      -> nothing relevant
.../works?search=machine+learning+combinatorial+optimization+tour+horizon&per-page=5 -> nothing relevant
.../works?search=learning+to+branch+mixed+integer+strong+branching+approximation&per-page=5
.../works?search=lens+optics+Lagrangian+duality+compositional+optimization&per-page=6 -> nothing relevant
.../works?search=category+theory+convex+duality+Legendre+transform+functor&per-page=6 -> Willerton
.../works?search=compositional+linear+programming+duality+string+diagram&per-page=6  -> nothing relevant
.../works?search=egg+fast+extensible+equality+saturation&per-page=4
.../works/https://doi.org/10.1016/j.jlamp.2023.100892   (for the open-access location)
.../works/https://doi.org/10.1007/978-3-030-99253-8_6   (for the arXiv location)
.../works/https://doi.org/10.1287/ijoc.2016.0723        (metadata only; no open copy listed)
```

Other:

```
https://arxiv.org/pdf/2606.15712  -> Aksu, "Odds Law"; supplied by Tavis as an arXiv id, not found by search
https://www.w3.org/TR/webgpu/     -> 4.5 MB HTML; supported-limits table and feature list extracted
https://arxiv.org/abs/2111.03956  -> title confirmed "Graphical Piecewise-Linear Algebra" before fetching the PDF
https://link.springer.com/content/pdf/10.1007/978-3-030-99253-8_6.pdf -> returned 3 KB of HTML, not a PDF; superseded by the arXiv copy
```

### 8.4 Coverage

**Searched and found nothing** (weak negatives; nothing here depends on them):

- **No compositional account of Lagrangian or LP duality.** Willerton has the duality without
  composition of subsystems; Boisseau & Piedeleu have compositional polyhedral constraints without
  optimization. Three query phrasings, OpenAlex only. Stop condition: all three returned either
  unrelated physics/optics results or the two papers already found. This is a thin search and I would
  not defend it as a novelty claim — it is recorded because § 2.1 says the gap is where Ergodis' own
  work would sit, and a reader should know how hard I looked.
- **No published combination of equality saturation with string-diagram/hypergraph rewriting in the
  double-pushout sense.** Not searched at all, actually — flagged in § 6.1 as worth a bounded search
  before building. Recorded here as **not searched**, which licenses nothing.

**Could not access / not obtained:**

- `10.1287/ijoc.2016.0723` (Alvarez, Louveaux & Wehenkel). INFORMS; no open copy listed by OpenAlex;
  not fetched. Nothing rests on it.
- **No Censi-authored co-design implementation was reachable.** Five direct repository probes
  returned 404 and a GitHub repository search returned two results, neither by Censi. The MCDP code
  read in § 4.4 is therefore a **third-party from-scratch implementation** and I have not validated it
  against the theory; the conclusion drawn from it — that infeasibility is a reasonless lattice value
  — is a statement about *that* code, and the same conclusion should not be attributed to the authors
  of the theory without checking their own tooling.
- **No commit SHAs pinned** on any of the three repositories.
- **The companion report to `arXiv:2606.15712` ("Maestro Order") was not sought.** Aksu defers the
  measurement of every predicted law to it. So the *Odds Law* assessment in § 3.3 rests entirely on
  proofs I checked and on no empirical evidence whatsoever, and the absorption rows derived from it
  (C1151-14, C1151-15, C1151-16) inherit that: their mathematics is elementary and verified, their
  applicability to real proposal streams is untested by anyone. This is a **could-not-access-because-
  not-attempted** gap, and a cheap one to close if the rows are pursued.
- **MathSciNet: NOT COVERED** (institutional authentication, unreachable). **zbMATH Open: not
  queried.** Neither gates anything here.

**Caching.** Every PDF fetched for this study is in the shared cache at
`/tmp/persistent/tavis/lit-search/` with the SHA-256 recorded inline at each source. `arXiv:2004.03082`
(egg) was already present from earlier work and my add was refused as a duplicate; I read the
previously cached bytes (sha256 beginning `058eb744cb833c47`) and did not compare against a fresh
fetch. Cache presence records fetched bytes, never reading.
