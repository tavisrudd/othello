# C1150 — category theory for the Ergodis core and Evolve

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: COMPLETE (reported 2026-09-12); successor slices unallocated

## Goal

A literature study, not an engine change. Determine where category-theoretic
structure gives Ergodis (the compiled exact-optimization / contextual-quotient
core) and Ergodis Evolve (autonomous structure discovery, admission and repair)
a concrete lever for optimization, regularization, structure learning and
exploration, and rank the candidates as absorption targets with a stated
evidence gate for each.

## Primary source

- Vincent Abbott, arXiv:2604.07242 (read first, in full), then every other
  recent Abbott paper and coauthored work (categorical deep learning, string
  diagrams / neural circuit diagrams, functorial compilation of models to
  hardware). Record for each: the categorical structure used, what it buys, and
  whether the same structure appears in an Ergodis object (plans, quotients,
  representative catalogs, certificates, campaigns, repair schedules, feature
  DAG lowering, admission checks).

## Broad sweep (each theme gets its own section in the report)

1. **Compiler design**: categorical semantics of compilation and lowering;
   functorial/optics-based IR passes; equational rewriting and e-graphs seen
   categorically; how this maps onto Ergodis plan compilation and FeatureDag
   lowering.
2. **Search priors, non-neural**: categorical / compositional inductive biases
   (the cats4ai programme, geometric and categorical deep learning) reinterpreted
   for exact search, proposal distributions, and Evolve's discovery ordering.
3. **Solvers**: categorical formulations of constraint satisfaction, exact
   cover, MIP/SAT propagation, dynamic programming and min-plus algebra;
   compositional solving (open games, decorated cospans, sheaf-theoretic CSP
   and cohomological obstructions).
4. **Optimization and regularization**: categorical descriptions of gradient
   and non-gradient optimization (lenses/optics, parametric categories,
   reverse derivative categories), and what a categorical regularizer means
   for a discrete exact engine.
5. **Normalization and evolution**: canonical forms and quotients as
   coequalizers/colimits, rewriting to normal form, categorical accounts of
   evolutionary and genetic operators, and structure-preserving mutation for
   Evolve.
6. **Adjacent**: applied category theory for scientific computing and
   verification (categorical certificates, proof-relevant checking), since
   Ergodis certificates and independent verification are a natural fit.

## Deliverables

- Reading dossier at this path: one subsection per source with citation,
  verified claim summary, and the Ergodis object it touches.
- A ranked absorption table: candidate structure, Ergodis object, expected
  benefit, cheapest experiment, and evidence gate (measured, not argued).
- Incidental leads go to `notes/ergodis-discovery-track.md` with provenance.
- Follow `notes/literature-audit-conventions.md` for search recording and use
  the shared literature cache before fetching.

## Constraints

- No edits under `~/src/ergodis*`; product framing per the lane rule: prior
  art informs, never gates.
- No neural-network methods as deliverables; categorical structure only.

## Report (2026-09-12)

**Status**: reading complete; synthesis below. No engine edits. Two dossier halves,
each written by one Opus sub against the literature-audit conventions and checked
here for read-depth fields and ledger consistency:

- Part A, Abbott and Zardini's programme, non-neural search priors, categorical
  optimization and regularization: `2026-09-12-c1150-part-a-abbott-priors-optimization.md`
  (21 sources: 2 full text, 14 partial, 5 abstract/metadata; one could-not-access).
- Part B, compilers, solvers, normalization and evolution, certificates:
  `2026-09-12-c1150-part-b-compilers-solvers-normalization.md`
  (26 sources: 2 full text, 18 partial, 5 abstract/metadata, 1 secondary only).

Both parts are positioning studies. Every absence claim in them rests on web search
plus OpenAlex/Crossref phrasing families at most, and each is marked as a weak negative,
never a verdict. MathSciNet and Google Scholar are NOT COVERED throughout.

### Verdict on the named primary source

Abbott and Zardini, *Weaves, Wires, and Morphisms* (arXiv:2604.07242, full text), is a
representation and rewriting discipline for deep-learning architectures whose quantitative
content is GPU-memory specific. What transfers is one design move: a semantic layer plus a
deliberately non-faithful algorithmic layer, so "same answer, different cost" is derivable
rather than documented. It is not a search prior and gives Evolve no proposal ordering.

The load-bearing find in the same group is *Diagrammatic Negative Information*
(arXiv:2404.03224, full text) and its upstream nategories paper (Censi, Frazzoli, Lorand,
Zardini, arXiv:2207.13589, partial). They open with Ergodis's own problem, that an optimum is
a witness plus a proof that nothing better exists, and they show the negative half needs a
composition rule of its own: bans compose with positive information as catalyst, never among
themselves. That is C1091 rejection fixture 9 and C1091's "failure to admit" extension.

### Combined ranking (both parts, my merge)

The two halves converge on one object seen from two sides. Part A's composable ban is the
exclusion half of a certificate; part B's semiring-polymorphic verifier and VeriPB
redundance rule are the checker and the proof format for the same half. Rows below are
ordered by value per unit of effort; the part-level tables keep the full six fields.

| # | Lever | Ergodis object | Cheapest experiment | Gate | Conf. |
|---|---|---|---|---|---|
| 1 | Composable ban over the objective preorder with triangle-inequality bound composition (A rows 1–3) | certificates, admission refusals, `ordered_resource` | type the exclusion half of one family's certificate as a ban; give `ordered_resource` the law `L(f⨟g) ≤ L(f)+L(g)` | measured work reduction from admissible bounds on a frozen C1016 or C1143 workload; refusal reuse counted across plans | high |
| 2 | Semiring-polymorphic min-plus verifier (B row 3) | independent checker, three witness contracts | instantiate the existing checker over a second semiring (counting ∆-product for C1093's count readout) | same checker accepts/rejects the same fixtures under both semirings; no new checker code path | high |
| 3 | VeriPB redundance-based strengthening as the catalog proof format (B row 4) | representative catalogs, witness lift (C1091) | emit one catalog transformation as a redundance step with witness substitution ω | independent VeriPB-style check passes; VIPR-style feasibility check demonstrably cannot express it | high |
| 4 | Weak term acyclicity of the FeatureDag identity set (B row 1) | FeatureDag simplifier | offline syntactic check on the fixed identity list | passes (polynomial canonical-form claim defensible) or names the offending identity | high |
| 5 | Weight pushing + minimization as canonical form for acyclic tropical summaries (B row 2) | summary trees, catalogs | run Mohri's construction on existing summary trees | linear-time canonical form; identical summaries collapse | high |
| 6 | Naturality declarations on copy/delete/swap (A row 6) | plan rewriting, shared-resource accounting | annotate FeatureDag operations; reject the C1091 fixture-3 overlapping-repair rewrite by construction | fixture 3 rejected without a runtime check | medium |
| 7 | Polynomial span + semiring as DP normal form (A row 4) | OpenProblem/RetainedTree adapters | factor one compiled span to serve count/min-weight/Pareto | one compilation, three readouts agree with existing paths | medium |
| 8 | Fusion-theorem-shaped closure as the vertical-composition contract (A row 7, B diagnosis) | preservation contracts across family/compiler/verifier | state one boundary's crossing as a closure theorem and test it | the "not discharged" sentence at that boundary is removed with a test | medium |
| 9 | Monad algebras beyond equivalence relations (A row 13) | ValidatedQuotient, decision covers | re-express one decision-cover admission as an algebra condition | admission accepts the same set; no new false positives | medium |
| 10 | Sheaf obstruction classes for admission failures (B row 9) | admission | emit the obstruction witness from a failing admission search | witness independently checked | medium |
| 11 | Streamability-style constructive witness as an Evolve generator gate (A row 8) | Evolve proposals | delimit one family's admissible proposals by an accumulator theorem | proposals outside the set never admitted; count of wasted proposals drops | medium |
| 12 | Reverse derivative in a discrete category (A row 14) | Evolve discrete parameters | apply to one enumeration-tuned parameter | matches or beats enumeration at lower cost | low |
| 13 | Decorated cospans / operad algebras as contract vocabulary (B rows 8, 11) | plural-preservation-contract spine | design vocabulary only | none yet | low |

Rows 1–3 are one implementation slice and should be allocated together. Rows 4 and 5 are
cheap, independent, and return a usable answer whether they pass or fail.

**Recommended against** (both parts agree): string diagrams as an IR (FeatureDag is
Cartesian, the easy case), open games (single-agent optimization is not strategic; keep only
the bidirectional-morphism interface lesson for decision covers), and any general categorical
framework before rows 1–5 have run.

### ej + tt closeout

- Unification (done here, cheap): the composable ban composes bounds by min-plus addition,
  so row 1 is the tropical-semiring instantiation of row 2's polymorphic checker. One generic
  verifier over {min-plus, counting, lower-bound} semirings covers rows 1, 2 and 7. Whoever
  implements rows 1–3 should design the verifier interface first.
- The vertical-composition gap is named twice: part A's Fusion-theorem closure and part B's
  Bakirtzis–Topcu horizontal/vertical diagnosis. Ergodis has horizontal composition everywhere
  and vertical composition nowhere; row 8 is the first step and is cheap to state.
- Tao-style question left open: is the ban composition rule strictly more than the dual
  order? Censi et al. report that a twin category fails; the reason (catalyst dependence) is
  stated but not proved sharp in the sources read. Verify against arXiv:2207.13589 §3 before
  building on it.
- Adversarial control for Evolve, noted in passing by part B: Cai–Fürer–Immerman structures
  defeat k-local consistency but fall to Gaussian elimination, and Ergodis's search space is
  GF(2). Any learned local repair rule can look saturated on them and be wrong. Logged to the
  discovery track, not allocated.

### Mystery ledger

| Item | Settled? | Gap or owner |
|---|---|---|
| No categorical account of regularization / model-complexity control | open, weak negative | three phrasing families over OpenAlex + Crossref; MathSciNet not covered; part A §5.6 proposes three readings marked as the auditor's own |
| No categorical account of evolutionary or genetic operators | open, weak negative | web search only; carry forward as a gap, not a verdict |
| No categorical account of branch-and-bound | open, weak negative | web search only; adjoints-as-optimization is the framing under which one would be written |
| Ergodis-side facts assumed by part B: C1093 count readout is min-cost vs all-solutions; O7 tabu/kick shape; whether a failing admission search already holds obstruction data | open | verify against `~/src/ergodis*` before allocating rows 2, 10 |
| Abbott, Xu and Maruyama, *Category Theory for AGI* (Springer chapter) | could not access | open gap; no claim rests on it |

No manufactured mysteries beyond these.

### Successor allocation (unallocated; needs Tavis)

1. Rows 1–3 as one private implementation slice with the verifier interface designed first.
2. Rows 4 and 5 as one cheap offline slice on the FeatureDag identity list and summary trees.
