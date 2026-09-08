# Complete-ports: targeted proof-clarity follow-up

Date: 2026-09-07. Reviewer: GPT-6 Astra.

This is a bounded follow-up on `prop:rank-one-reliability-separation`, its extension `thm:rghw-reliability-separation`, and `prop:boundary-width-compilation`. It is not a fresh cold read. Paths below are relative to `papers/complete-repair-ports/`; line references describe the inspected source during the editing pass. No manuscript edits were made.

## Findings

The reliability construction and width algorithm appear repairable by exposing a few missing intermediate steps; neither requires replacing its mathematical mechanism. The largest gain is to justify why the unwanted plane incidences are avoidable, rather than invoking genericity before establishing that its forbidden conditions are proper. The width proof should state its precise dynamic-programming invariant and distinguish a count of state-pair combinations from the arithmetic required to process each pair.

### 1. RELIABILITY-SEED: give a rational seed before the free-point choices

Location: `sections/05-pointed-tutte.tex:67–101`, `prop:rank-one-reliability-separation`.

The instruction to avoid finitely many joining lines is sound only after showing that the initial forced intersections have no unwanted collinear triples and that a free point's entire assigned line is not forbidden. The current prose leaves that initial genericity step implicit. The following explicit rational seed closes it with elementary linear algebra.

Use homogeneous coordinates (x,y,z) over the rationals. The five supporting lines may be chosen as follows:

| Arrangement | ell1 | ell2 | ell3 | ell4 | ell5 |
|---|---|---|---|---|---|
| A | z=0 | x-y=0 | y=0 | x=0 | x+y+z=0 |
| B | x=0 | x+y+z=0 | z=0 | y=0 | x-y=0 |

For A, the already prescribed points are

```
0=e3, 1=e2, 4=e1-e3, 5=e1, 8=e1-e2.
```

Their only collinear triples are 045 and 158. This can be seen directly: 1,5,8 lie on z=0; 0,4,5 lie on y=0; every other triple from these five vectors is independent. In particular, among these fixed points ell2 contains only 0, ell4 contains only 0 and 1, and ell5 contains only 4 and 8.

For B, the already prescribed points are

```
1=e3, 8=e2, 7=e1-e2, 0=e1, 2=e1+e2-2e3.
```

Their only collinear triple is 078. The points 0,7,8 are on z=0. Any triple consisting of 2 and two of these points is independent because 2 has nonzero z-coordinate and every pair of 0,7,8 is independent. A triple consisting of 1 and two other fixed points is independent: the corresponding pairs of planar directions are selected from (1,0), (0,1), (1,-1), (1,1), which are pairwise nonparallel over the rationals. Each line assigned a free point contains exactly its intended fixed pair.

Now select the free points in the order already specified by the paper. At each step exclude all already chosen points, intersections with other supporting lines, and intersections with joining lines of pairs that are not meant to form a prescribed triple with the new point. Each forbidden intersection is a single point on the assigned line. A joining line coincides with the assigned line only for the intended pair, which is allowed. Each rational projective line has infinitely many rational points, so the selection can continue. In A, after selecting 2 on ell2, the pair 0,2 is the permitted pair when choosing 6. This proves exactly the required incidence lists, with no appeal to an unverified generic configuration.

Suggested proof prose after the seed data:

> The fixed points have only the displayed collinearities. Choose each remaining point on its assigned line, avoiding previously chosen points, the other supporting lines, and the finitely many unintended joining lines. The assigned line contains no previously chosen pair except the pair intended to complete a prescribed triple. Hence every exclusion removes only finitely many rational points, and every new collinearity is prescribed.

The seed is a human-checkable construction, not an exhaustive computational premise. It also permits beginning the proof over the rationals directly, instead of first choosing an unspecified infinite field and specializing later.

### 2. RELIABILITY-LIFT: explain rank three and preserve the independence conditions on reduction

Locations: `sections/05-pointed-tutte.tex:103–125`; `prop:rank-one-reliability-separation`.

The generic-lift step is correct, but one short bridge makes its completeness transparent: no four helper points are collinear. Every supporting line has exactly three selected points, and any other collinear triple was excluded. Therefore any four projected helper vectors span a three-dimensional space. Their lifted four-by-four determinant consequently has a nonzero cofactor, so it is a nonzero linear form in the four lift heights. For a listed triple, its projected rank is two and its unique relation likewise gives a nonzero linear form in the heights. Unlisted projected triples are already independent and need no extra avoidance condition.

Suggested addition:

> No four projected helpers are collinear, so every projected quadruple has rank three. Expanding its lifted determinant along the new coordinate exhibits a nonzero cofactor. The finitely many bad height choices are therefore proper rational hyperplanes; choose the heights outside their union.

For the finite-field step, specify clearing denominators and preserving the nonzero minors actually needed. One suitable formulation is:

> Clear column denominators. For each subset required to be independent, retain one nonzero integer minor witnessing that independence. Choose a prime dividing none of these finitely many minors. Required dependence determinants are identically zero and remain zero on reduction. Thus all required independence and dependence relations survive over the same prime field for both configurations.

This includes the independence of every triple involving the target and two helpers, needed to call each listed target-plus-triple dependence a circuit. The two codes then have dual distance four. Every four helpers are independent, whereas a hyperplane through the target corresponds to a quotient line and contains at most three helpers; this also makes the minimum-distance-six argument explicit.

At line 120, use “minimum-cardinality recovery sets” or “radius-three minimal recovery sets,” rather than the potentially broader “minimum recovery sets.” The earlier paragraph correctly explains that larger inclusion-minimal supports exist; preserve that distinction in the conclusion of the construction.

The extension `thm:rghw-reliability-separation` needs no comparable expansion. Its projection argument pays the component minimum on every active disjoint block, and its full-quotient radius forces each padding support. The explicit generator-map realization at lines 190–199 should remain: it establishes that the abstract pairs belong to the coding problem under discussion.

### 3. WIDTH-INVARIANT: distinguish linearly completable states from realized states

Location: `sections/03a-exact-recovery-optimization.tex:201–246`, `prop:boundary-width-compilation`.

The displayed affine space contains syndromes that can be completed using the contribution **spaces**. A restricted local choice table, for example after helper failures, may realize only some of those points. The theorem's wording “feasible partial syndromes ... lie in” is correct, but the proof should keep the distinction explicit.

Let A_S denote the displayed affine space. Define the message at z in A_S as the minimum cost of choices in subtree S whose total contribution is z, and set it to infinity if no such choices exist. Then:

- A global feasible assignment restricts to A_S at every cut, because its outside choices supply c-z. Thus the affine restriction never deletes an optimum.
- At a leaf, scanning actual local choices computes exactly this message, including unavailable entries.
- At an internal node, choices in the two disjoint children combine precisely when their contributions add to the parent state. Minimizing over child pairs proves the invariant without assuming every point of A_S is realized.
- At the root the only possible retained syndrome is c; its entry is the global optimum, or infinity if there is no feasible assignment.

Suggested concise insertion:

> The affine set describes linear compatibility, not realization by the local tables. Store at each of its points the least cost of actual subtree choices with that contribution, with infinity for an unrealized point. Every globally feasible assignment survives these restrictions. The leaf scan and child-pair recurrence preserve this invariant, and the root entry at c is the desired optimum.

The statement that the algorithm returns an attaining lift should be conditional on a finite optimum. Empty or infeasible choice tables do not admit a lift. For the separate radius budget, retain the best cost at each exact helper count already at the leaves; a local table that has previously discarded all but one unconstrained minimizer may not contain the alternatives needed for this version.

### 4. WIDTH-COST: qualify arithmetic work without changing the width exponent

Locations: `sections/03a-exact-recovery-optimization.tex:223–228,249–259`; `prop:boundary-width-compilation`.

The stated O(n q^(2tw)) **pair-combination count** is justified: each child has at most q^(tw) affine states, and a binary tree with n leaves has O(n) internal nodes. The radius-budget variant contributes the stated factor (r+1)^2.

The following prose then says the bound counts arithmetic operations. Processing a pair also requires coordinate conversion, syndrome addition, a parent-membership test, and indexing. These are not uniformly one field operation when t, w, and the ambient dimension vary. A safe formulation is:

> These are counts of state-pair combinations. The affine coordinate maps can be precomputed by polynomial linear algebra; processing a pair has polynomial arithmetic cost in the interface dimensions, in addition to cost addition and comparison. Thus the width-dependent exponential factor is q^(2tw). Exact rational valuations also incur their arithmetic bit cost.

Alternatively, state a precise word-RAM encoding and indexing model if claiming constant-time pair processing. No such model is needed for the mathematical point of this proposition. Retain the existing qualifications that local compilation is charged separately, target normalization enlarges the interface, support/Pareto alternatives incur additional output/pruning costs, and requesting all syndromes has an output-size cost. Those are hypotheses and scope boundaries, not redundant disclaimers.

## Prose that can fund these additions

1. **Delete the duplicate incidence-skeleton table**, `sections/05-pointed-tutte.tex:87–98`. It repeats the concurrency and intersection data at lines 70–86. Replace it with the rational seed table or vectors above; that adds the missing existence information in substantially the same space.
2. **Shorten the representation preamble**, lines 63–65, to: “Realize the listed triples as plane collinearities, then lift so that precisely their unions with the target are four-column circuits.” This keeps the proof strategy and removes repeated purpose wording.
3. **Remove the repeated definition of clutter**, lines 24–25, already given in the recovery-model section. Keep the statement that these are the complete radius-three minimal families and the larger-support example at lines 26–28; those delimit the claim.
4. **Compress the transition into antichains**, `sections/03a-exact-recovery-optimization.tex:114–117`, to: “Retain these alternatives within each functional label. For each ordinary label b, let ...”. The probability warning is developed immediately after the pricing/availability proposition, so repeating it in this transition adds no hypothesis.
5. **Remove the second general repricing explanation**, lines 181–184, after preserving the first sentence requiring a separate radius constraint. The running example and antichain construction have already shown that unit-cost minimization discards later price alternatives. Proceed directly from the radius qualification to the service LP dual. Do not remove the fractional/integral distinction at lines 197–199.

These cuts leave the proof mechanisms, feasibility conditions, evidence boundaries, and operational examples intact. They provide room for the seed and the precise width invariant without making the manuscript appreciably more discursive.

## Scope and disposition

I read the full rank-one realization and full-rank extension, the surrounding section opening, and the current pricing/availability and width passages. The seed calculations above are elementary symbolic checks spelled out in this note; no benchmark, exhaustive search, Lean execution, or external literature comparison was performed. The proposed repairs concern completeness of exposition and the interpretation of the complexity bound. The original finite constructions and the width-dependent state bound need not be abandoned.

This note is intentionally uncommitted for the parent to inspect and commit.
