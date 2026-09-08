# Complete-ports: Astra follow-up on layered exposition

Date: 2026-09-07. Reviewer: GPT-6 Astra.

This is a follow-up to my earlier journal-style assessment, not a fresh cold read. I reviewed the currently revised source, including the subsequently clarified capacity convention, revised reading-route mechanisms, regrouped adjacent-literature discussion, moved all-rank corollary, and running-example probability calculation. Line references are to the inspected sources under `papers/complete-repair-ports/`; editing was concurrent, so semantic labels remain the stable references.

## Assessment of this exposition pass

The manuscript now gives readers a substantially clearer reason to study the compositional question. The running binary example distinguishes a minimum-cost answer from a family of useful alternatives before introducing the formal machinery. Its later appearances explain the helper quotient, the gap between coefficient confinement and operational preservation, and repricing. These are genuine changes of viewpoint within one example, rather than repeated illustrations of the same definition.

The introduction also has a more credible hierarchy. The exact formula and operational theorem carry the main account; contextual minimization is identified as a secondary refinement. The Ergodis section explains what the mathematical representation enables, and the detailed evidence remains a separate reading route. The intended audience is still primarily coding theorists, with a more usable route for adjacent readers interested in exact optimization and resource allocation.

**Readiness of this pass:** the layered exposition is ready to proceed to the rendered-manuscript check. The identified safe-skip issue has been repaired; the remaining suggestions below are local terminology and economy refinements. I do not see a need for another substantial reorganization to achieve the requested motivation and layering. This is not an overall publication recommendation, a novelty verdict, or an empirical/formal verification result.

## Contribution and positioning

The opening question is now concrete: which information discarded by a cheap local repair becomes necessary when availability, shared capacities, or an outer functional constraint changes? The answer connects the coding-theoretic statements to an operational purpose without claiming that each familiar ingredient is new.

The revised literature discussion has three useful jobs: local recovery and workload models; the information passed through concatenation; and the information needed to distinguish future numerical responses. This organization is more informative than a succession of comparisons saying that neighboring work addresses something different. The paper explicitly acknowledges classical duality, relative-weight theory, and min–sum elimination, then identifies its target normalization, confinement distinction, and witnessed lifting law. That is an appropriately focused account of the manuscript's contribution as presented. I have not independently verified priority or the cited originals.

## Running example: correctness and explanatory scope

For target u and helpers (u,u,v,u+v), the stated inclusion-minimal supports are exactly {1}, {2}, and {3,4}. If neither copy of u is used, neither v nor u+v alone spans the target functional, while their sum does. Thus locality is one, but retaining all minimum-cardinality supports loses a repair available when helpers 1 and 2 fail.

The revised capacity sentence at `compositional_recovery.tex:88–90` explicitly charges each contacted helper once per request. Under that model, the three disjoint supports serve three requests, and retaining only the two singleton supports serves at most two. The qualification is necessary and now present: the example is about the paper's per-request load model, not broadcasting one recovered value to arbitrarily many identical requests.

The callback at `sections/02-confinement-transfer.tex:4–9` is exact. The three coefficient vectors (1,0,0,0), (0,1,0,0), and (0,0,1,1) have the same image under the helper generator, so their differences lie in its kernel. This explains the quotient's meaning before introducing its exact sequence.

The concatenation callback at `sections/03-positive-density.tex:202–219` is also correct. The full inner generator has repeated nonzero columns, hence dual distance two. The local target cost is one. For the full outer code L^N, the nonzero functional sector is absent and Gamma equals three. Appending a repeated-column relation in another block gives a cost-three nonconfined equation, while deleting that relation recovers the original local repair. Minimal supports remain local at every radius. The text expressly identifies this as the **zero-sector** example and retains `prop:functional-label-separation` for the separate nonzero-sector alignment obstruction. That scope distinction is important and well handled.

The optimizer callback at `sections/03a-exact-recovery-optimization.tex:103–113` gives the correct price function min(p1,p2,p3+p4) and the correct availability event. These formulas use the full minimal family, so a radius-bounded interpretation must allow the pair {3,4}, that is, radius at least two. No conflicting smaller radius is fixed in the passage. The example now makes support-antichain retention an answer to an already understood problem.

The example should not be asked to prove more than it does. It has rank-one target space and disjoint minimal supports. It therefore does not by itself exhibit the higher-rank geometry, the nonzero-sector representation separation, or nontrivial intersections among helper supports. The distinct F4 separation and geometric reliability-separation examples still have jobs; they should not be removed merely to maintain a single-example narrative. Also, disjoint helper sets do not make the corresponding success events mutually exclusive. The final revision uses this fact well: with independent survival probability one half, failure has probability (1/2)^2(1-1/4), so reliability is 13/16, whereas adding the three repair probabilities gives 5/4. I checked this calculation at `sections/03a-exact-recovery-optimization.tex:167–175`. It supplies the probability warning within the running example without implying that its physical supports intersect.

## Strong passages

1. **Motivation before notation:** introduction lines 72–97 move from a failed symbol to three specific reasons for retaining more information. The distinction between a helper's cost and the functional it supplies is understandable before extension fields appear.
2. **Actual principal formula:** the introduction gives the feasible maps, target normalization, functional dual, and both Gamma sectors before `thm:main`. The reader can now tell what is being minimized. The separate nonzero-kernel input is explained, rather than hidden inside “labelled costs.”
3. **Different mechanisms remain different:** the latest reading route distinguishes the zero/nonzero sector split, independent block lifting, and deletion of external coefficients for minimal supports. This is more faithful than describing all three proofs by one common slogan.
4. **Appropriate demotion of a refinement:** introduction lines 239–246 explain contextual compression in ordinary language, specify the fixed target leaf and numerical observation, and leave the projective details to the later subsection. This improves access without removing the precise result.
5. **Resource mathematics drives the software section:** the progression from the example's price/availability functions to support antichains, pricing, and fixed-query width gives Ergodis a mathematical purpose. The section's closing discussion connects reconstruction, pricing completeness, updates, and optimality to their required data.
6. **Changed reliability question is explicit:** the projective-simplex section now says that some t-dimensional target space may be chosen after observing the survivors, unlike a prescribed T. This is exactly the sort of local explanation needed at a change of mathematical language.

## Remaining friction and actionable refinements

### Reading routes: the identified skip issue is resolved

The instruction to skip `sec:contextual-refinement` is safe for the preceding exact escape theorem, minimal-support theorem, and composition law: their proofs do not depend on that subsection. Reading the relative-weight section initially for definitions and theorem statements is likewise sufficient for the proposed first pass; its proofs can be revisited when auditing the local invariant.

Initially the contextual subsection also contained `cor:all-rank-bottleneck`, although that simple restriction-to-a-line result is not a numerical table-compression theorem. The final source moves it before `sec:contextual-refinement`: its label is now at line 495, and the optional subsection begins at line 539. This removes the navigation mismatch. A reader following the skip can retain the elementary all-rank consequence while postponing the technical numerical-context development. The generated-span optimization remark still uses the bounded-outer-test result: readers who skip its proof should understand that this optional reduction is being accepted as a stated theorem, not derived by the elementary DP proof. This is a normal and safe first-pass dependency, not a defect.

### Numerical “tables” still need a precise referent

The introductory contextual paragraph says “Two tables are numerically equivalent if every compatible outer code gives the same bounded escape cost.” For escape responses, the retained numerical data include the separate zero-sector/nonzero-kernel information, not just ordinary and target-normalized fibre minima. Earlier passages now explain this correctly. Calling the compared objects “numerical states, including the zero-sector cost” would prevent the shorter paragraph from reopening the previous interface ambiguity. This is a terminology refinement, not a failure of the contextual theorem.

### Keep the optional paths operationally legible

The current routes identify which mathematics can be postponed. One additional small clarification would help: “read for its definitions and statements,” rather than simply “read for its statements,” for `sec:relative-weights`. Definitions of the pair and its recovered space remain necessary even when the proofs are deferred. Conversely, the artifact/measurement layer can be skipped to follow the human theorem proofs, but not to assess the historical implementation or performance claims. The manuscript's logical evidence boundary supports that distinction.

### Minor economy

The introduction remains dense after the running example, but its density is now principally mathematical rather than navigational. I would not add another overview table. Any further shortening should target repeated summaries of the same retained-data distinctions, not remove the newly explicit domains or normalization conditions. In the related-work section, retain the three question-based groups and avoid adding further neighboring topics unless they change the contribution account.

## Review coverage and limits

I reviewed the revised introduction and reading routes; the running-example callbacks in the three named sections; the opening of each body section; the contextual skip paragraph and its destination; the all-rank corollary's location and subsequent move; the optimization section's operational closing route and final probability callback; and the full latest adjacent-literature discussion. The supporting theorem proofs had been read in the earlier cold review. This pass does not re-audit every unchanged proof, citation, software assertion, or evidence artifact.

No manuscript edits, builds, Lean runs, benchmarks, literature searches, or PDF-layout inspections were performed in this follow-up. The parent is checking layout/builds and the literature narrative separately. Earlier referee reports remain unchanged, and this report is left uncommitted for the parent to review.
