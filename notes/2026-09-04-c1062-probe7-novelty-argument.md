# C1062 probe 7: the novelty argument against the variable-partition coarsening line

**Lane**: `complete-ports`
**Task**: C1062, probe 7 (unblocking argument; no code)
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 0 (`2026-09-04-c1062-probe0-prior-art-and-landscape-audit.md`) for the audit and
the warning that raised this block; probe 1a (`2026-09-04-c1062-probe1a-carrier-and-cost-model.md`)
for the carrier envelope; probe 1 (`2026-09-04-c1062-probe1-lowering-and-towers.md`) for the
response-function gate; probe 2 (`2026-09-04-c1062-probe2-best-intervention-and-economics.md`) for
the structural timing failure.
**Reviewed**: `2026-09-05-c1062-probe7-review.md`, which read arXiv:2601.10531v2 in full rather than
probe 0's summary of it. Corrections are marked **[corrected]** below.
**Verdict**: probe 7 is **unblocked, and the block dissolves rather than being argued past**.

**[corrected]**, three items, none of which changes the verdict.

- All three differences in § 4 check out against the paper itself. Two hold more strongly than
  stated: Corollary 16's consistency additionally carries a Gaussianity assumption, and Definition 8's
  interventional coarsening merges nodes with *equal intervened-ancestor sets*, which is a graphical
  condition rather than the behavioural indistinguishability probe 0's paraphrase suggests — two nodes
  with the same intervened ancestors can respond to those interventions completely differently.
- **Half of § 8's gate is discharged.** That gate asks for `RePaRe` to be read past `partial` depth
  "to confirm that its interventional coarsening is not secretly computing an exogenous-side object
  under a variable-side presentation". Definition 8 settles it without needing the proof of Theorem 10:
  the coarsening is `chi(v) = chi(w) <=> I-an_G(v) = I-an_G(w)` over the node set, and there is no
  exogenous or latent object anywhere in it. What remains of the gate is the `RefineTest` body.
- **Two of this note's requirements on probe 7 were not met, and probe 7's report now says so.**
  § 3 ingredient 3 asserts that the arity bound entering as a reachability restriction "is what makes
  the arity tower a compositional object"; it is not implemented, the composed passes compute the
  full-arity rung, and § 4 difference 4's "two declared dials, each with a measured tower" is
  therefore one dial for probe 7 and two only for probe 1's flat lowering. § 4 difference 3 required
  probe 7 to carry the separating-intervention witness through the factorization "or say that it did
  not"; it did not, and the report now says so. The
compositional route does not have to move onto the variable-partition carrier, and it should not.
Two corrections ride along: one standing claim is retired, and one piece of prior art is imported
rather than re-invented.

## 1. The block, restated

Probe 0 found Madaleno, Misra and Markham, "Coarsening Causal DAG Models" (arXiv:2601.10531v2,
2 April 2026), whose `RePaRe` algorithm recursively refines a partition of the **variable set**,
whose keywords literally include "partition refinement lattice", and whose *interventional
coarsening* merges nodes indistinguishable with respect to the available interventions. Probe 0's
warning was conditional and precise: `RePaRe`'s carrier — a partition of the variable set — is
exactly the carrier the `(u, I)` quotient cannot express, so *if* probe 7 pivots to the
compositional route in order to make "these 27 states are one causal variable" expressible, it
pivots onto `RePaRe`'s carrier, and the novelty argument then rests on the algorithmic axis alone.
The exploration log turned that into a hard gate: probe 7 does not start until the argument is
written down.

## 2. The conflation inside the block, and why the antecedent is not forced

Two different things travel under the word "compositional" in this task, and the block silently
assumes they are the same thing.

**(a) Compositionality as a scaling device.** Factor the computation of the quotient *of the
exogenous space* along the DAG, so that the `|U| · π_k` pair carrier is never materialized. The
carrier is unchanged; only the way it is computed changes.

**(b) Variable merging.** Make "these 27 states are one causal variable" expressible. This changes
the carrier — from the exogenous space to a partition of the variable set, as in `RePaRe`, or to
endogenous settings under a `τ` map, as in Beckers and Halpern's constructive abstraction.

Both promotions of probe 7 were promotions of (a), and neither asks for (b):

- **Probe 1a promoted it on memory.** Its argument is entirely about the flat carrier's envelope —
  `4(nd + 1)` bytes per state, roughly `1.2 × 10^7` states at `n = 20, d = 2`, hence `|U| ≲ 10^4` at
  arity two or three, and a canonical exogenous space out of reach by orders of magnitude. The fix
  that argument asks for is "do not materialize `Val(U) × pins`", which is (a).
- **Probe 2 promoted it on the decision layer.** Its timing failure is structural: the flat lowering
  solves the model once per materialized state, and that state count is exactly the work a memoized
  re-solve does to fill a table over every context, measured at `1.00x`. The only regime where the
  compiled query can win is the one where the context space cannot be memoized and the carrier is
  never materialized. That is also (a).

So the log's sentence — "pivoting to the compositional route **to make variable merging
expressible** means pivoting onto that paper's carrier" — has an antecedent that nothing in this
task forces. **Probe 7 declines (b) and builds (a).** With that decision made, `RePaRe` is a
vocabulary neighbour and not a carrier neighbour, and the block does not apply. Section 7 states
what declining costs, so this is a trade rather than a dodge.

## 3. What probe 7 builds, stated as an object rather than as a direction

Fix an acyclic finite structural causal model `M = (U, V, F)` with declared observation set `O ⊆ V`,
declared intervenable set, and arity bound `k`. The flat relation, from probe 1a section 4, is

```
u ~ u'   iff   O(M_I(u)) = O(M_I(u'))   for every admissible pin set I with |dom I| <= k.
```

Probe 7 computes this relation, and its class function, **without enumerating `Val(U)`**, through
three ingredients.

1. **A factorization over exogenous variables, not over endogenous ones.** For each exogenous
   variable `U_j`, its local class is the tuple, over the endogenous children `V` that read `U_j`, of
   `V`'s mechanism as a function of `U_j` with `V`'s other parents ranging over their reachable
   configurations. Factoring on the exogenous side is what makes a shared exogenous parent correct:
   probe 0's clause — that a variable feeding more than one endogenous variable needs the joint
   partition of the response tuple rather than a product of per-variable partitions — is satisfied by
   construction rather than by a side condition. In the Markovian case where each `U_j` feeds exactly
   one `V`, this local class **is** Balke and Pearl's 1994 per-variable response-function partition.
2. **A backward pass computing what downstream can observe.** For each endogenous `V`, a partition
   `Π_V` of its domain `D_V` such that two values in one block are indistinguishable by every
   observed descendant, uniformly over the contexts and pins the arity bound allows. `Π_V` is
   discrete for `V ∈ O` and is otherwise the coarsest partition that every child's mechanism carries
   into its own `Π`. Local response functions are then read modulo `Π`, which is how a restricted
   observation set coarsens the quotient compositionally instead of by re-enumeration.
3. **The arity bound entering as a reachability restriction.** Response functions need only agree on
   the parent configurations that arity-`k` interventions can actually produce, which is what makes
   the arity tower a compositional object rather than `k + 1` independent compiles.

The composed class of a context is the tuple of its per-exogenous-variable local classes; it is
computed in time linear in the number of exogenous variables, and the working memory is
`Σ_j |D_j|` rather than `∏_j |D_j|`.

**The variable set is never partitioned.** Every endogenous variable keeps its identity and its
domain, no macro-variable is constructed, and no `τ` map onto a coarser model is claimed. `Π_V` is a
partition of one variable's *values*, which is a coarsening of the observation channel, not a
merging of variables.

## 4. Why `RePaRe` does not pre-empt that object

Four differences, of which probe 0 named three. All four belong in probe 7's report, stated rather
than left for a reader to find.

1. **Carrier.** `RePaRe` refines a partition of the variable set. Probe 7 refines a partition of the
   exogenous space, held factored over exogenous variables. These are partitions of different sets
   and neither lattice embeds in the other; a merge in one is not a merge in the other, and there is
   no coarsening relation between the two answers. This is the difference the block feared would be
   lost, and it is not lost, because probe 7 declines the pivot.
2. **Epistemic status.** `RePaRe` learns, consistently in the sample limit, from interventional data
   with unknown intervention targets. Probe 7 computes the exact quotient of a fully specified finite
   model, and every class boundary is a theorem about that model rather than an estimate.
3. **Refutation witness.** `RePaRe`'s refinement is driven by `Refine-` and `IsEdge-` oracle tests,
   and its completeness theorem is stated relative to those oracles. Probe 7's refinement returns a
   separating intervention word, decoded by `decode_word` into an explicit experiment and replayable
   against the model by a party who trusts neither the compiler nor an oracle. Probe 1 already ships
   this on the flat lowering; probe 7 must carry it through the factorization or say that it did not.
4. **Declaration surface.** `RePaRe`'s interventional coarsening is relative to the interventions the
   data happens to contain. Probe 7's quotient is relative to two declared dials, the observation set
   `O` and the arity bound `k`, each with a measured tower — probe 1 shipped both, and the
   response-function fixture's `7 → 28 → 32` arity tower and `17 → 30 → 32` observation tower are
   what a user reads to choose a declaration.

**What would pre-empt probe 7, stated so a later reader can check it.** An exact algorithm that,
from a fully specified finite acyclic structural causal model, computes the coarsest partition of the
*exogenous* space under a declared bounded intervention vocabulary and a declared observation set,
from the factored model rather than by enumerating contexts. Nothing in probe 0's audit is that, and
section 8's bounded search did not find it.

## 5. The rest of the causal-abstraction line does not reach it either

Taken from probe 0's audit, with its read depths carried forward rather than upgraded here.

- **Beckers and Halpern 2019** ("Abstracting Causal Models", AAAI-19), read at `partial` depth with a
  targeted scan for "coarsest", "algorithm" and "compute", is a sequence of successively more
  restrictive *definitions* — exact transformation, uniform transformation, `τ`-abstraction, strong
  abstraction, constructive abstraction — with no algorithm and no coarsest construction. Its carrier
  is endogenous settings, on which the `(u, I)` state is strictly finer, since it remembers whether
  `V = 1` is natural or pinned.
- **Rischel and Weichwald 2021** is a compositional *error measure* for moving between fine- and
  coarse-grained variables in a category of causal models. Probe 7 is still "the Rischel–Weichwald
  direction" in spirit, but nothing in that work computes a coarsest quotient.
- **Rubenstein et al. 2017**, **Zennaro 2023**, **Massidda et al.** and **Geiger et al. 2021/2023**
  supply consistency requirements and proposal-and-check verification. The field's object there is
  the requirement a proposed abstraction must satisfy, not the construction of the best one.
- **Kekić, Schölkopf and Besserve** (UAI 2024) is the published neighbour of the `O` = declared
  outcome case and is learned and approximate where probe 7 is exact and combinatorial.
- **Balke and Pearl 1994** owns the per-variable response-function partition outright. Probe 7 uses
  it as the base case of the factorization and claims nothing about it; probe 1's gate 1 already
  verifies agreement class for class, 60 contexts to exactly 32 classes.

## 6. The prior art the compositional route must import rather than invent

This is the finding that most changes what probe 7 may claim, and it is not in probe 0's audit
because probe 0 searched the causal-abstraction literature and this lies outside it.

**Givan, Dean and Greig, "Equivalence notions and model minimization in Markov decision processes",
Artificial Intelligence 147 (2003), 163–223**, computes the coarsest homogeneous partition — the
stochastic-bisimulation quotient — of a Markov decision process by partition refinement carried out
over a *factored* representation (a dynamic Bayesian network with structured conditional
probability tables) rather than over an enumerated state space. Block splitting is performed
symbolically on the factored description, which is precisely the manoeuvre section 3 relies on.
Alongside it sits the concurrency-theory line on compositional and decompositional bisimulation
minimization of labelled transition systems, where component-wise minimization is sound because
bisimulation is a congruence.

The consequence is a restriction on probe 7's claims, and it should be applied before the code is
written rather than after a reviewer finds it. **Probe 7 may not claim algorithmic novelty for
"refine a partition without materializing the state space".** That technique family is thirty years
old, it is the right technique, and probe 7 imports it. What survives the import is the object of
section 3 — the coarsest exogenous quotient under two declared dials — the separating-intervention
witness, exactness against a learned or estimated alternative, and the specific factorization, which
is per exogenous variable with its child response tuple plus a backward value-partition pass, and is
not a dynamic-Bayesian-network block split.

**Read depth, marked.** Givan, Dean and Greig is characterized here at `secondary only` depth, from
search-result summaries and standing knowledge; the paper was not retrieved or read. That is
sufficient to bind probe 7's internal claims and is *not* sufficient for any external claim. See
section 8.

## 7. What declining the pivot costs, stated plainly

- **Variable merging stays unexpressible.** It was not on the `(u, I)` carrier and it is not on the
  factored one. Any statement of the form "these 27 states are one causal variable" is outside
  C1062, and probe 5's planted-coordinate framing must stay off it as well.
- **One standing claim is retired.** The exploration log's "hundred thousand variables become a
  fifty-state machine" is a variable-merging sentence and is now withdrawn rather than deferred. Its
  replacement, which probe 7 can actually try to earn, is: *a hundred thousand exogenous contexts
  fall into fifty classes, and the class of any one of them is computed in time linear in the number
  of exogenous variables without enumerating the other contexts.* Probe 7's report states whichever
  of those two numbers it actually measures, and neither is a claim about variable count.
- **The weaker argument is deferred, not won.** If variable merging is ever wanted, it is a separate
  task on a separate carrier, and there the novelty argument has to be made against `RePaRe` on the
  algorithmic axis alone — exact versus learned, witness-carrying versus oracle-driven. That is a
  real argument and a weaker position, and this note deliberately does not enter it.

## 8. Search record and the gate on any external claim

Three bounded queries were run for this note, on the one axis probe 0 did not cover, namely whether
the coarsest interventional quotient of the exogenous space has already been computed compositionally
from a factored model.

| Query | Domain | Result |
|-------|--------|--------|
| compositional bisimulation minimization structural causal model exogenous space quotient exact | web search, first result page | The compositional-minimization line for Markov decision processes and labelled transition systems, none of it about structural causal models. **Negative** for the intersection. |
| response function partition factored coarsest interventional equivalence exogenous variables finite SCM algorithm | web search, first result page | Givan–Dean–Greig model minimization (imported in section 6); Bongers–Forré–Peters–Mooij foundations of structural causal models; nothing computing this quotient. **Negative**, one import. |
| model minimization / bisimulation, causal model interventions, coarsest partition from factored representation, 2024–2025 | web search, first result page | No result at the intersection; the causal-abstraction hits are the ones probe 0 already holds. **Negative.** |

Stop condition: three queries, first result page each, no new candidate at the stated intersection
after the second query's single import. This is a bounded internal-scoping search, not an audit under
`notes/literature-audit-conventions.md`.

**The gate.** C1062 is private research with no paper or public-surface claim, so this argument
governs internal scoping only. Before any external claim of novelty for probe 7's object, run the
full audit under `notes/literature-audit-conventions.md` with, at minimum, Givan–Dean–Greig read at
full depth and `RePaRe` read past the `partial` depth probe 0 reached — specifically its `RefineTest`
body and the proof of Theorem 10, to confirm that its interventional coarsening is not secretly
computing an exogenous-side object under a variable-side presentation.

## 9. Verdict, and the three sentences probe 7's report must carry

Probe 7 starts. Its report carries, in its own words:

1. That its carrier is the exogenous space held factored over exogenous variables, that `RePaRe`
   partitions the variable set, and that neither answer is a coarsening of the other.
2. That the factored partition-refinement technique is imported from the model-minimization line
   descending from Givan, Dean and Greig, not invented here, and that what is claimed is the object,
   the two declared dials, the separating-intervention witness, and exactness.
3. That variable merging is out of scope on purpose, and the "hundred thousand variables become a
   fifty-state machine" line is retired in favour of a statement about exogenous contexts and the
   cost of one class lookup.
