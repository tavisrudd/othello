# Mathematical spine for the application riffs

Status: live theorem registry  
Parent: [`../2026-07-12-riffing-on-applications.md`](../2026-07-12-riffing-on-applications.md)

This file is the single source of truth for mathematical claims suggested by the application riffs.
Riff files should link here rather than duplicate statements or proof status.

Design rules:

- Separate domain legality from game semantics.
- Separate discovery algorithms from certificate relations and checkers.
- State what is already formalized before advertising a candidate theorem.
- Treat generic hypergraph identities as infrastructure, not application novelty.
- Promote a theorem only when its statement is strong enough for the paper claim it supports.

## Status classes

- **Existing:** already present in the Lean or paper layer; may need a better public API.
- **Immediate:** a short generic theorem or direct corollary of existing infrastructure.
- **Substantial:** likely provable, but needs new definitions or nontrivial development.
- **Open:** a research target whose truth or sharp form is not yet established.

## Immediate and low-risk theorem program

### MATH_1 — Feature-factorization impossibility

Status: immediate  
Difficulty: low  
Lean feasibility: high  
Supports: `RIFF_19`–`RIFF_21`, `RIFF_239`–`RIFF_241`

Let `S` be a finite state space, `A` a normalized action space, `W(s) ⊆ A` the winning actions at
`s`, and `f : S → F` a feature map. If

```text
f(s) = f(t)  and  W(s) ∩ W(t) = ∅,
```

then no deterministic policy of the form `π = π̄ ∘ f` is winning at both `s` and `t`.

Proof sketch: factorization forces `π(s)=π(t)`; that common action cannot lie in two disjoint winning
sets.

Dependencies: a common action-label normalization and a theorem connecting `W(s)` to exact game
value. Domain-specific action identification must not be hidden in the feature map.

Next action: state a finite-set version independent of ProjectiveCap, then instantiate it with one
certified S4 collision pair.

Literature / novelty: state abstraction and bisimulation already formalize when policies or values
factor through an abstraction, and CEGAR already uses counterexamples to refine unsafe abstractions.
See Aarts et al., [Automata Learning Through Counterexample-Guided Abstraction
Refinement](https://link.springer.com/chapter/10.1007/978-3-642-32759-9_4). `MATH_1` is a small
certificate-facing lemma, not a new abstraction theorem; novelty would come from exact normalized
game collisions that close a declared feature language.

### MATH_2 — Minimum abstraction refinement is a transversal

Status: immediate  
Difficulty: low  
Lean feasibility: high  
Supports: `RIFF_19`–`RIFF_21`, `RIFF_42`

Let `C` be a finite set of certified collision pairs and `P` a finite predicate vocabulary. For each
collision `c`, let `E_c ⊆ P` contain the predicates that distinguish its two states. A predicate set
`R ⊆ P` resolves every collision iff `R` is a transversal of `{E_c | c ∈ C}`. Hence minimum
refinement size is the transversal number of this separation hypergraph.

Proof sketch: unfold “every collision is separated by some selected predicate.”

Dependencies: reuse the generic finite hypergraph/transversal layer. This theorem certifies
minimality only within the declared predicate vocabulary.

Next action: define a small `Separates` API and connect it to `FiniteGeom.Hypergraph`.

Literature / novelty: minimum distinguishing predicates are a form of Test Cover, and exact learning
uses teaching/identification dimensions. See Crowston et al.,
[Parameterized Study of the Test Cover Problem](https://arxiv.org/abs/1212.0117), and the survey
[Queries revisited](https://doi.org/10.1016/j.tcs.2003.11.004). The transversal equivalence is
classical infrastructure. A paper contribution would be the certified collision hypergraph and
closed predicate vocabulary, not this reduction.

### MATH_3 — Mex certificate characterization

Status: immediate; overlaps the existing Grundy characterization  
Difficulty: low  
Lean feasibility: very high  
Supports: `RIFF_25`, `RIFF_106`

For a finite well-founded game graph and proposed labeling `g : V → ℕ`, `g` is the
Sprague–Grundy function iff every state `s` satisfies:

1. exclusion: no child has label `g(s)`;
2. coverage: for every `j < g(s)`, some child has label `j`.

Proof sketch: these are exactly the membership and non-membership halves of `mex`.

Dependencies: explicit normal-play move relation and well-foundedness, following the local
NodeKayles/Grundy API rather than introducing a second game semantics.

Next action: audit the existing `NodeKayles` theorem names and add only the certificate-facing
wrapper that is missing.

Literature / novelty: the mex characterization is classical Sprague–Grundy theory. Work on compound
games also treats mex and composition explicitly; see
[On the Sprague-Grundy function of compound games](https://arxiv.org/abs/1903.08138). This item is
supporting formal infrastructure. The possibly novel ML claim is to use the two mex obligations as
structured training signals and exact certificates.

### MATH_4 — Local mex consistency gives global uniqueness

Status: immediate  
Difficulty: low  
Lean feasibility: very high  
Supports: `RIFF_25`, `RIFF_40`

On a finite well-founded game graph, there is a unique labeling satisfying the local exclusion and
coverage obligations at every state.

Proof sketch: well-founded induction; child labels are already unique, so mex is unique.

Consequence: a learned labeling that passes the exact local checker is the exact Grundy function,
regardless of how it was proposed.

Next action: prove uniqueness as a corollary of `MATH_3` and expose it as the ML paper's trust
boundary.

Literature / novelty: uniqueness follows immediately from classical recursive SG semantics and is
not a new CGT result. Its useful contribution is architectural: it justifies an exact post-training
checker whose authority is independent of the learned model.

### MATH_7 — Repair tolerance equals transversal number

Status: existing in generic form / immediate RepairCodes corollary  
Difficulty: low  
Lean feasibility: very high  
Supports: `RIFF_3`, `RIFF_117`–`RIFF_120`

For a coordinate `i`, let `H_i` be the complete bounded-radius repair hypergraph. The smallest set
of helper-coordinate failures disabling every repair of `i` is exactly `τ(H_i)`. Thus every failure
set of size `< τ(H_i)` leaves a repair, and some failure set of size `τ(H_i)` disables all repairs.

Proof sketch: “disables every repair” means “intersects every repair edge.”

Dependencies: define the complete repair hypergraph without selecting advertised repair sets.

Next action: add a `RepairCodes`-level statement whose terminology matches the paper.

Literature / novelty: LRC availability and hypergraph-based repair constructions are established;
see Kim and Song,
[Hypergraph-Based Binary Locally Repairable Codes with Availability](https://doi.org/10.1109/LCOMM.2017.2730183).
The equality with a transversal number is definitional hypergraph duality. Novelty must come from
using the *complete* bounded-repair family and proving new `τ/ν` behavior, not from `MATH_7` alone.

### MATH_10 — Robust solution family iff `τ > f`

Status: immediate  
Difficulty: low  
Lean feasibility: very high  
Supports: `RIFF_91`–`RIFF_94`, `RIFF_181`, `RIFF_194`, `RIFF_195`

Let acceptable solutions form hyperedges over their required failure domains. At least one solution
survives every failure set of size at most `f` iff the solution-family hypergraph has transversal
number greater than `f`.

Proof sketch: a failure set defeats the whole family exactly when it is a transversal.

Weighted version: minimum disruption cost is the minimum-weight transversal.

Next action: formalize the unweighted equivalence and keep weighted optimization outside the first
Lean layer.

Literature / novelty: survivable routing with shared-risk resource groups and recoverable robust
optimization already model common-cause failures and recourse; see
[Recoverable Robust Optimization with Commitment](https://arxiv.org/abs/2306.08546) and
[SRLG-diverse multicast routing](https://doi.org/10.1016/j.cor.2009.12.009). `MATH_10` is a generic
hypergraph characterization. The possible novelty is optimizing `τ` over an acceptable *family* of
solutions and comparing it with pairwise diversity.

### MATH_12 — Defining-query/transversal duality

Status: immediate  
Difficulty: low  
Lean feasibility: high  
Supports: `RIFF_74`, `RIFF_113`, `RIFF_114`, `RIFF_149`, `RIFF_229`, `RIFF_276`

Let `X` be a finite hidden-object family and `Q` a finite query family. For target `x` and competitor
`y ≠ x`, define the disagreement edge

```text
E(x,y) = {q ∈ Q | answer q x ≠ answer q y}.
```

A query set `D` uniquely identifies `x` iff `D` intersects every `E(x,y)`. Therefore minimum
nonadaptive identifying-query size equals the transversal number of the disagreement hypergraph.

Proof sketch: `D` identifies `x` exactly when every competitor differs on at least one selected
query.

Next action: formalize this before domain-specific oracle definitions; it is the common base for
privacy, experiment design, and semantic compression.

Literature / novelty: this is the target-specific form of Test Cover/teaching dimension. Minimum
test collections distinguish items by response signatures, and teaching sets distinguish one target
from its competitors; see [Parameterized Study of the Test Cover
Problem](https://arxiv.org/abs/1212.0117) and
[Recursive Teaching Dimension, VC-Dimension and Sample Compression](https://jmlr.org/papers/v15/doliwa14a.html).
The transversal statement is classical. New work requires a structured continuation family with
new exact parameters or query bounds.

### MATH_13 — Information lower bound for reconstruction

Status: immediate  
Difficulty: low  
Lean feasibility: high  
Supports: `RIFF_74`, `RIFF_151`, `RIFF_229`

If each adaptive query has at most `b` responses and there are `N` possible hidden-object
equivalence classes, any deterministic worst-case reconstruction tree has depth at least
`ceil(log_b N)`.

Proof sketch: a depth-`d` `b`-ary decision tree has at most `b^d` leaves.

Symmetry refinement: `N` counts object orbits under the declared equivalence, not raw labelings.

Next action: prove a finite cardinality form without real logarithms first (`N ≤ b^d`), then derive
the numeric corollary.

Literature / novelty: decision-tree counting lower bounds are standard in group testing and exact
query learning; [Queries revisited](https://doi.org/10.1016/j.tcs.2003.11.004) surveys the latter.
`MATH_13` is a baseline that any continuation-oracle result must beat using restricted query
structure; it is not independently novel.

### MATH_17 — Minimal inconsistency/repair duality

Status: established database/diagnosis principle; immediate finite theorem  
Difficulty: low  
Lean feasibility: high  
Supports: `RIFF_51`, `RIFF_127`, `RIFF_200`, `RIFF_201`

For a finite constraint system, let the hyperedges be its minimal inconsistent fact subsets. A fact
deletion set restores consistency iff it intersects every minimal inconsistent subset. Minimum
repairs are therefore minimum transversals of the inconsistency hypergraph.

Proof sketch: if an inconsistent subset survives, the repaired facts remain inconsistent; if no
minimal inconsistent subset survives, no inconsistent subset survives.

Novelty posture: infrastructure only, not a new database theorem.

Next action: decide whether the financial-completion prototype needs formal minimality or merely a
checked finite witness.

Literature / novelty: conflict hypergraphs and repairs are established database theory. Chomicki,
Marcinkowski, and Staworko explicitly compute consistent answers using conflict hypergraphs
([CIKM 2004](https://doi.org/10.1145/1031171.1031254)); Staworko and Chomicki extend the framework
to universal constraints ([arXiv:0809.1551](https://arxiv.org/abs/0809.1551)). This theorem should be
cited as imported infrastructure, not claimed as an application-paper result.

## Certificate and transfer theorems

### MATH_5 — Symmetry-quotiented game-certificate soundness

Status: substantial  
Difficulty: medium  
Lean feasibility: high  
Supports: `RIFF_2`, `RIFF_106`, `RIFF_145`

Let a finite group act on a finite normal-play game while preserving legal moves. A canonical proof
DAG contains:

- a P-record whose complete canonical child set consists of certified N-records;
- an N-record with at least one certified P-child.

If canonicalization is orbit-sound, every reference decreases a well-founded rank, and each local
record checks, then the root record has the true P/N value.

Grundy extension: replace P/N obligations with the `MATH_3` mex obligations over canonical child
values.

Proof sketch: prove value invariance under the group action, then induct over certificate rank.

Next action: define the abstract action/canonicalization interface and instantiate it first with an
existing small NodeKayles certificate, not the full PGL dataset.

Literature / novelty: SAT has mature proof logging and certified checking, including LRAT
([Efficient Certified RAT Verification](https://arxiv.org/abs/1612.02353)), and certified symmetry
breaking already exists
([Certified Symmetry and Dominance Breaking](https://ojs.aaai.org/index.php/AAAI/article/view/20283)).
Game backward-induction certificates are also standard in principle. A distinct result would need a
generic theorem for dynamic group quotienting plus early-break game DAGs and a demonstrated
certificate-size/check-time advantage over SAT encoding.

### MATH_6 — Lossy-hint noninterference

Status: substantial  
Difficulty: medium  
Lean feasibility: medium  
Supports: `RIFF_5`, `RIFF_30`, `RIFF_106`, `OBS_8`, `OBS_17`

If a hint function affects only the permutation in which a complete exact search explores legal
moves, replacing the hint by an arbitrary function does not change the returned value.

The theorem does not apply if hints suppress moves, alter terminal classification, supply unverified
cutoff values, or participate in state equality.

Proof sketch: show the exact recurrence is invariant under permutation of its finite child list.
For early-break P/N search, prove that any found witness is checked and exhaustive branches remain
complete.

Next action: prove the simple exhaustive and P/N early-break forms; defer alpha–beta semantics.

Literature / novelty: correctness independence from move ordering is standard for exhaustive
recurrences and correctly implemented alpha–beta search. Succinct retrieval/static functions are
also mature; see [Fast Scalable Construction of (Minimal Perfect Hash)
Functions](https://arxiv.org/abs/1603.04330). `MATH_6` is useful because it makes the project's trust
boundary explicit, but it is unlikely to be novel unless generalized to a certified mixed
exact/lossy search architecture with nontrivial pruning.

### MATH_8 — Bounded-repair confinement preserves the complete repair hypergraph

Status: substantial wrapper around an existing transfer lemma  
Difficulty: low–medium  
Lean feasibility: high  
Supports: `RIFF_3`, `RIFF_117`

If every concatenated-code dual word of weight at most `r+1` is supported in one inner block, then
the complete radius-`r` repair hypergraph at each coordinate is canonically isomorphic to the
corresponding inner-code repair hypergraph. Consequently `ν`, `τ`, and every isomorphism-invariant
bounded-repair statistic transfer exactly.

Proof sketch: repairs correspond to low-weight dual words containing the target coordinate;
confinement gives both edge inclusions, and equality transfers hypergraph invariants.

Dependencies: the existing `RepairCodes.Transfer.transfer_lemma` and a new explicit repair-edge API.

Next action: write the repair-hypergraph definition and prove edge extensionality before pursuing
new code families.

Literature / novelty: locality-preserving concatenation and repair-set constructions are broad
areas, so a deeper coding audit is required. The potentially distinct point is *complete* bounded
repair-hypergraph equality derived from dual-word confinement, rather than preservation of selected
repair groups or locality parameters. The theorem is promising as the formal hinge of the coding
paper, but should not be called novel until searched against concatenated LRC and availability
literature.

### MATH_11 — Finite double-oracle termination and correctness

Status: substantial but standard  
Difficulty: low–medium  
Lean feasibility: medium  
Supports: `RIFF_72`, `RIFF_91`, `RIFF_92`, `RIFF_132`

Alternate between an exact minimum transversal of the current solution family and an oracle that
returns an acceptable solution avoiding that transversal. In finite solution and failure spaces:

1. every successful iteration adds a genuinely new solution;
2. the procedure terminates;
3. if no avoiding solution exists, the current transversal defeats every acceptable solution;
4. exact optimization oracles yield the corresponding global optimum/decision result.

Proof sketch: strict finite growth plus the separation-oracle specification.

Novelty posture: correctness infrastructure; the OR paper still needs a distinctive objective or
algorithmic bound.

Next action: state oracle contracts independently of any MIP implementation.

Literature / novelty: constraint generation, double-oracle methods, diverse near-optimal solutions,
and recoverable robustness are established. Compare
[DiversiTree](https://doi.org/10.1287/ijoc.2022.0164) and
[Recoverable Robust Optimization with Commitment](https://arxiv.org/abs/2306.08546). Finite
termination under exact separation is standard. Any novelty must lie in the transversal-family
objective, approximation guarantees, or a specialized oracle—not `MATH_11` itself.

### MATH_18 — Specification-family transversal and assumption reversal distance

Status: substantial definitions with immediate finite consequences  
Difficulty: low–medium  
Lean feasibility: medium  
Supports: `RIFF_208`–`RIFF_210`, `RIFF_213`

For a finite family of successful specifications, let each specification carry the assumptions or
exposures sufficient to invalidate it. The minimum shared invalidation set is the transversal
number of that family. If assumption specifications are vertices of a weighted edit graph and the
conclusion is a vertex label, assumption reversal distance is the shortest-path cost to a vertex
with the opposite conclusion.

Proof obligations:

- witness soundness: the returned edit path actually produces the opposite conclusion;
- minimality relative to the declared graph and weights;
- invariance under semantics-preserving renaming of assumptions.

Novelty posture: the mathematics is elementary; value depends on a defensible assumption language
and empirical comparison with multiverse/specification-curve analysis.

Next action: keep this out of Lean until the backtest semantic model is stable.

Literature / novelty: multiverse and specification-curve analysis already enumerate defensible
analysis choices—see Steegen et al.
([Multiverse Analysis](https://doi.org/10.1177/1745691616658637)) and Simonsohn et al.
([Specification Curve Analysis](https://doi.org/10.1038/s41562-020-0912-z))—while Bailey et al.
analyze backtest overfitting
([The Probability of Backtest Overfitting](https://doi.org/10.21314/JCF.2016.322)). Shortest-path
distance and transversal definitions are elementary. A paper needs a defensible semantic assumption
graph, exact reversal witnesses, and empirical value beyond existing specification curves.

## Substantial structural theorems

### MATH_15 — Generic packet-strategy theorem

Status: substantial  
Difficulty: medium  
Lean feasibility: medium  
Supports: `RIFF_10`, `RIFF_22`, `RIFF_23`, the odd-plane packet/absorption frontier

Consider a finite alternating game organized into opponent/reply rounds. Suppose a strategy chooses
a packet at each defender state such that every permitted opponent continuation admits a legal
reply restoring an invariant. If a well-founded rank strictly decreases within a uniformly bounded
number of rounds, the packet rule induces a winning strategy.

Useful variants:

- potential may stay flat on individual rounds;
- strict progress occurs over a bounded window;
- packet choice is value-blind but the reply is adaptive.

Proof sketch: dependent choice of replies plus well-founded induction rules out an infinite play;
the invariant prevents the defender from being the first player without a move.

Dependencies: state the generic normal-play semantics first; keep the geometric packet lemma
separate.

Next action: extract the exact quantifier pattern from the live odd-plane handoff before fixing the
API.

Literature / novelty: well-founded ranking/progress arguments and finite-game backward induction are
classical, while CEGIS synthesis of Lyapunov/ranking certificates is well developed; for example,
[Formal Synthesis of Lyapunov Neural Networks](https://www.cs.ox.ac.uk/people/alessandro.abate/publications/cAAGP20.pdf).
The generic implication “invariant plus progress gives a strategy” is infrastructure. A potentially
new theorem is the exact packet-shaped `exists/forall/exists` rule needed by the odd-plane game,
especially if it permits bounded-window rather than per-round descent and closes a new family.

### MATH_16 — Completion family induces an error-correcting identification code

Status: substantial  
Difficulty: medium  
Lean feasibility: high  
Supports: `RIFF_113`, `RIFF_114`, `RIFF_229`, `RIFF_230`, `RIFF_276`

For hidden objects `X` and queries `Q`, encode each object by its response word
`c_x = (answer q x)_{q∈Q}`. Then:

- defining-query sets are coordinate sets separating the target codeword;
- minimum pairwise response distance `d` permits correction of `⌊(d-1)/2⌋` adversarial response
  errors and `d-1` erasures;
- restricted query families give punctured identification codes.

Proof sketch: standard Hamming balls and erasure uniqueness, after proving object equivalence iff
response words agree.

Novelty posture: the generic theorem is classical coding theory; novelty requires a structured
completion family with new distance/defining-set bounds.

Next action: prove the generic construction after `MATH_12`, then look for one geometric family with
nontrivial parameters.

Literature / novelty: response signatures, Test Cover, identifying/teaching sets, group testing, and
sample compression already connect queries to codes and identification. See
[A New Abstract Combinatorial Dimension for Exact Learning via
Queries](https://doi.org/10.1006/jcss.2001.1794) and
[Sample Compression Schemes for VC Classes](https://arxiv.org/abs/1503.06960). Generic Hamming
error/erasure correction is classical. Novelty requires new parameters for a structured geometric or
continuation family, not the induced-code observation.

## Open research targets

### MATH_9 — Exact `τ/ν` formulas for geometric repair-code families

Status: open  
Difficulty: high  
Lean feasibility: only after a paper proof  
Supports: `RIFF_117`–`RIFF_120`

Targets include:

- exact coordinatewise `τ_i` and `ν_i` for the twisted-cubic–axis family;
- an exact or sharp asymptotic ratio for the Roth–Lempel hot coordinate;
- classification of coordinate orbits by repair-hypergraph isomorphism type;
- a sharp general upper bound attained by one construction.

Known base: strict `τ_i > ν_i` and the generic `τ ≤ p·ν` bound are already formalized; do not
advertise them as new targets.

Next action: compute orbit-resolved exact values for the next feasible fields and infer a statement
that is stronger than strict separation.

Literature / novelty: hypergraph LRC constructions and disjoint availability are established, but
the shallow search did not locate exact matching/transversal spectra for the project's complete
repair hypergraphs. This is the strongest apparent source of genuinely new mathematics in the
registry. The audit must still cover stopping sets, recovery-set systems, batch/PIR codes, and
availability bounds before fixing the claim.

### MATH_14 — Continuation-oracle reconstruction with query bounds

Status: open  
Difficulty: high  
Lean feasibility: after continuation rigidity  
Supports: `RIFF_74`–`RIFF_76`, `RIFF_150`, `RIFF_151`

Candidate statement: for the four-frame family over `F_q`, `q ≥ 13`, a declared
feasible-extension oracle determines the hidden frame configuration up to its ambient semilinear
stabilizer, with an explicit adaptive or nonadaptive query bound.

The planned continuation-rigidity theorem establishes reconstruction from the full continuation
object, not automatically efficient oracle reconstruction. Required new work:

- formal oracle and attacker-knowledge model;
- explicit reconstruction algorithm;
- query upper bound;
- lower bound stronger than `MATH_13` if possible;
- robustness to missing or corrupted answers.

Next action: finish/audit the N1 continuation-rigidity theorem, then identify the smallest subset of
continuation relations actually used by its proof.

Literature / novelty: hidden-graph reconstruction from distance or connected-component oracles is an
active field—see [Graph Reconstruction via Distance Oracles](https://arxiv.org/abs/1304.6588) and
[Graph Reconstruction with a Connected Components Oracle](https://arxiv.org/abs/2509.05002)—and
black-box model extraction is established
([Stealing Machine Learning Models via Prediction APIs](https://arxiv.org/abs/1609.02943)). A
continuation oracle on a semilinear finite-geometric family appears structurally different, but both
the oracle definition and query bounds must be new; full-graph rigidity alone is insufficient.

### MATH_19 — Completion-length/robustness/certificate tradeoff

Status: open  
Difficulty: high  
Lean feasibility: after a precise semantic-code model  
Supports: `RIFF_95`, `RIFF_96`, `RIFF_113`

Seek nontrivial lower and upper bounds relating:

- defining-query or defining-subset size;
- completion/response distance;
- decoder side information;
- uniqueness-certificate size;
- total encoded length.

The theorem must count the reconstruction rule and certificate honestly. Without such a bound,
“semantic compression” remains a reframing of defining sets.

Next action: select one finite object family, define the complete bit-cost model, and test whether
any existing examples beat canonical plus entropy-coded storage.

Literature / novelty: defining/critical sets, teaching dimension, Test Cover, sample compression,
and combinatorial-object compression all occupy this territory. Relevant starting points include
[Defining Sets and Critical Sets in (0,1)-Matrices](https://doi.org/10.1002/jcd.21326),
[Compressing combinatorial objects](https://arxiv.org/abs/1601.03689), and
[Sample Compression Schemes for VC Classes](https://arxiv.org/abs/1503.06960). This target has high
reframing risk. A publishable theorem must count decoder and certificate side information and prove
a nontrivial tradeoff or separation for a specific family.

## Recommended implementation order

1. `MATH_12` — defining-query/transversal duality.
2. `MATH_16` — induced identification code.
3. `MATH_1` — feature-factorization impossibility.
4. `MATH_2` — refinement/transversal identity.
5. `MATH_3` and `MATH_4` — mex certificate and uniqueness.
6. `MATH_5` — quotient P/N certificate soundness.
7. `MATH_8` — complete repair-hypergraph preservation.
8. `MATH_10` — robust-family tolerance.
9. `MATH_6` — lossy-hint noninterference.
10. `MATH_15` — generic packet strategy.

The first eight should be approachable without solving a new open problem. `MATH_9`, `MATH_14`,
and `MATH_19` are the clearest genuine research targets.
