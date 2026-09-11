# C1133: assembled manuscript referee report, adjacent-field reader

Date: 2026-09-10. Audience adopted: a birational geometer familiar with classical Hodge theory, but unfamiliar with quantum D-modules. Scope: journal-style full-manuscript review of `papers/cubic-stabilization-m1/cubic_stabilization_m1.tex` and all thirteen included mathematical sections, including all five appendices. No manuscript edits, source-theorem audit, computational replay, or Lean run was performed.

The assembled PDF reviewed has 31 pages and SHA-256 `1a717b8e3fc3c740bc11432454e8c4882d3075158f98c3c2de669b47561affb4`. I read its complete mathematical source and checked the rendered text's page boundaries throughout, with direct rendered-page inspection on pages 1, 14, 20, and 28. This is not a claim of a visual inspection of every page. Bibliography finishing work was said to be concurrent; findings below apply to this snapshot.

For clarity in this report, A denotes Theorem 1.2 (the seventeen-family numerical classification), B denotes Theorem 1.3 (rational Hodge conservation), C denotes Corollary 8.1 (very-general cancellation), and D denotes Corollary E.1 (bounded-degree geometric partner finiteness). These are report shorthand, not manuscript theorem labels.

## Summary and contribution

The paper proves that every smooth complex cubic threefold remains irrational after product with one projective line. It then proves that one stabilization preserves rationality for all smooth complex Picard-rank-one Fano threefolds. A second part shows that birational first stabilizations of members of the nine irrational families preserve rational third cohomology as a Hodge structure. Torelli and arithmetic consequences use further external results.

The common mechanism is intelligible to the intended adjacent reader. Select whole primary factors of the quantum Euler operator, using their full even rank and, in rank two, a residue attached to an elementary modification of the original lattice. The blowup comparison transports this selection, while independent center coordinates prevent different occurrences or curve classes from being identified. The selected numerical contributions vanish on all possible fourfold centers. Small quantum calculations and flatness supply nonzero values at the Fano endpoints and preserve them after the product with a projective line. Part II keeps odd representations instead of merely their dimensions and recovers a rational Hodge structure at the end.

The cubic calculation is the effective model case. It reveals why a residue gap of two-thirds matters, why the first positive-order coefficient of the separated connection is needed, and why a surface cannot supply the same obstruction.

## Significance and scope

If the imported quantum comparison statements apply with the lattice and coefficient properties used here, the unconditional every-member cubic theorem is a substantial result. The contrast between stably rational examples and their irrational first stabilization explains its scope without conflating this with stable irrationality. The full Fano classification gives the numerical construction a natural endpoint. Hodge conservation adds a different kind of information and deserves a separate part in the same paper.

I would retain the single-paper architecture. B shares too much of the selection, center, and endpoint arguments with A for a forced separation to improve this reader's experience. Conversely, the abstract and first page correctly keep the cubic theorem dominant. The larger statements do not make the title-page theorem conditional.

The paper distinguishes three qualifications successfully: generic quantum parameters are not generic moduli; A and B apply to every smooth member in their stated families; C requires a very general source hypersurface. D fixes a finitely generated field and a bound on extension degree and counts geometric classes, not twists. B explicitly supplies neither integral lattices nor polarizations. These distinctions survive the assembled presentation.

## Correctness within the reviewer's expertise

I found no fatal error in the deductions I can assess as a birational/Hodge reader. The weak-factorization reduction uses centers of dimension at most two and does not silently assume their rationality. The proof of surface vanishing treats nef-canonical surfaces and ruled surfaces separately. The ruled-surface step uses birationality to a product and point blowups, avoiding a circular appeal to fourfold invariance. The additional rank-three selector correctly requires vanishing of odd cohomology when a nef-canonical surface has second Betti number one. The square-zero holomorphic-one-form class gives a concise geometric justification of that assertion.

The cubic proof is complete at the advertised first stopping point, the end of Section 4 on page 13. Every necessary comparison, surface argument, small calculation, and product-persistence argument appears before its final contradiction. The independent split-basis calculation is a check, not a deferred missing step. The general Iritani--Koto projective-bundle theorem is not used by that proof or by A/B: the specialized projective-line lemma and the full-even-bulk ruled-product calculation do the required jobs.

B's essential proof is in Section 7, not in an appendix. In particular it includes a common rational Hodge group, the distinction between fixed parameters and the full fiber, fixed-base faithfulness, selection before odd extraction, center vanishing, constant representation multiplicities under continuation, endpoint doubling, cancellation in a free representation group, restoration of the common weight, and rational descent by a nonzero determinant polynomial. The last step is especially effective: the reader is not asked to infer rational isomorphism merely from equality after complexification. Using a separate comparison field at each blowup and telescoping representation multiplicities is also explicitly justified.

C and D do not follow from rational Hodge conservation alone. The body clearly identifies rational generic Torelli as C's additional theorem. Appendix E identifies arithmetic intermediate Jacobians, the corrected bounded-degree isogeny theorem, polarization finiteness, and cubic Torelli as D's additional inputs. The finite-kernel argument after the isogeny bound is complete, and the text correctly does not bound the field of definition of the isogeny by the degree of the partner's defining field.

My verification limit matters: I have not independently checked the recent quantum sources, the exact source hypotheses of rational generic Torelli or the corrected isogeny bound, or the nine matrix inputs against their original literature. The manuscript gives exact attribution and an explicit distinction between finite calculations and geometric transport; that is assessable exposition, not independent source certification. I am confident in the downstream birational and Hodge deductions as written, but would not substitute this adjacent-field report for a primary quantum specialist's assessment of the coefficient-completion and lattice comparisons.

## Exposition and organization

The strongest passages are:

1. The opening paragraph. It states precisely why the familiar intermediate-Jacobian obstruction does not immediately survive stabilization. The reader knows what the new invariant must prevent.
2. The rank-two frame calculation in Section 2.2. The matrix of the modified residue makes the otherwise opaque elementary modification concrete, including the derivative correction and the dependence on the next coefficient.
3. The model `x,y -> q` versus `x -> q exp(s), y -> q exp(t)` in Section 3. It supplies the right mental picture before the reduced-ring proof, and the statement that source coefficients cannot depend on target variables identifies the actual logical danger.
4. The proof of the specialized projective-line lemma. Independence of the fiber Novikov parameter explains separation, and the explicit mention of mixed bulk directions explains what flatness must add to a small product formula.
5. The opening and final proof of Section 7. The former tells the reader exactly what changes at the Hodge interface; the latter restores rational Hodge structures without suggesting that individual spectral labels descend.
6. Appendix B's example of equal Hodge diamonds with different invariant values, and its codimension-two blowup argument limiting higher-dimensional birational invariance. These explain what the construction measures and why its dimension-four scope is structural.

The two parts provide a meaningful hierarchy rather than merely dividing pages. The first-page placement of A does not displace the cubic theorem, and B starts with a separate result statement and a clear list of reused ingredients. The assembled numerical table on page 14 and final Hodge proof on page 20 are readable and complete. The matrix table on page 28 is small but usable as technical input data. I found no unresolved `??` navigation markers in the extracted PDF text.

## Major comments

No major reconstruction of the body is needed. The one substantial clarification concerns the reading map and the exact meaning of an optional appendix.

1. **Distinguish skippable extensions from required input verification.** The introduction says that the appendices contain finite input data and optional general-bundle/additive extensions. This is not literally false, but a reader can too easily turn it into a promise that all appendices are optional for A/B. Proposition 5.2 explicitly defers its nine matrices, normalization, finite calculation, and every-member deformation bridges to Appendix D. Those are required inputs to A and B. Appendices A--C are skippable for the core route; Appendix D is skippable on a conceptual first pass only if Proposition 5.2 is accepted, and Appendix E is a separate arithmetic application. Say this once in the reading map. The cubic route really can skip every appendix.

This is a dependency-labeling correction, not a request to move the nine matrices into the main body. The present body gives the selection and proof mechanism; the finite input belongs comfortably in an appendix.

## Minor comments

1. Appendix A, page 21, says that injectivity for each center summand is “established below.” The proof now occurs earlier in Lemma 3.1. Replace the stale directional reference with that semantic reference.
2. A few items carried along the cubic route serve the later generalization: the rank-three persistence lemma and the discussion of retained grading data in Section 2 are examples. Their presence does not break completeness, but a brief local indication that rank three will be used in Section 5 would spare a first-pass cubic reader from assigning it equal priority. No large rearrangement is necessary.
3. The abstract's “even rank and canonical rank-two residue” compresses the four rank-three cases severely. Adding a few words indicating that their odd dimension is retained would make the announced classification mechanism match the body more transparently.
4. Section 7 repeats the rank-one-even-factor/zero-odd-part proof already given in Lemma 5.1. The repeated proof is short and useful in isolation, but a direct backward citation could save space if pagination becomes tight. Do not cut the rational descent proof to achieve the same saving.
5. Appendix A's generic additive-invariant apparatus is denser and less geometrically concrete than the core numerical proof. Its optional placement is appropriate. It should not be restored ahead of the cubic contradiction.

## Before/after preference: explicitly nonblind

The comparison PDF is `/tmp/persistent/tavis/c1133-integration/before.pdf`, 20 pages, SHA-256 `6ee4f570d5954262dff595b260900d2dda058a1560e9921f122c433647928ffe`. I compared its opening, proof organization and page-boundary progression against the assembled 31-page version. Chronology and the reason for the revision were supplied, so this preference is **nonblind**. The old version also lacks the new full A/B content: the comparison measures organization together with increased scope, not a controlled equal-content stylistic experiment.

I prefer the assembled version. The old paper puts the coefficient setup, general bundle comparison, cubic calculation, surface argument, endpoint and abstract additive criterion inside one long Section 2. The new paper gives the reader named stages and a visibly completed cubic theorem before the expanded classification and Hodge part. It also replaces the main route's general-bundle dependency with a specialized product argument that explains mixed-bulk continuation. The gain is navigability and a more direct account of the proof's required inputs, not fewer pages to the cubic theorem: both versions reach that contradiction at about page 13. The extra eleven pages chiefly buy the enlarged results and their verification boundaries.

## Editorial recommendation and separate assessments

**Recommendation: accept after minor revision of navigation and dependency wording, subject to the normal primary-specialist source/proof assessment.** On the assembled-exposition question, the single-paper integration succeeds. The numerical theorem is logically independent of B; B has a complete body proof; C/D retain their separate hypotheses and imported sources. The appendix-reading qualification and stale direction should be fixed before circulation.

- **Adjacent-field accessibility: 4/5.** A mathematically mature birational reader can recover the causal argument, identify the trust boundary and stop after the cubic proof. The reduced graded coefficient comparison remains the steepest passage, as its mathematical role warrants.
- **Confidence in the assessed birational/Hodge deductions and hierarchy: high (4/5).** The center argument, stabilization logic, representation cancellation and rational descent were followed directly.
- **Confidence in independent verification of the specialized quantum/source inputs: limited (2/5).** Those original sources and finite data were not independently replayed or audited in this read. This is a scope limitation, not a discovered defect.
- **Preference confidence: high (4/5), nonblind.** The structural gain is apparent despite the larger page count; no numerical claim of measured reader improvement is intended.

## Review provenance and closeout

No drafting conversation or earlier full referee report was provided or opened. The mandatory repository lane handoff did contain administrative summaries of earlier review verdicts, so this report is a fresh assembled-content read but is not perfectly blinded against prior verdicts. The handoff read also produced an over-10,000-token truncated response, a command-shaping failure; it was not repeated. Subsequent manuscript reads used explicit bounded section chunks. These limitations are recorded rather than describing the review as fully blind.

The explicit `ej` + `tt` closeout question was whether one can extract a useful improvement without disturbing the now-complete proof structure. The inexpensive improvement is the appendix dependency sentence and the corrected backward reference. No mathematical rewrite is indicated by this read.

**Mystery ledger:** no new mathematical mystery arose within this review's remit. The outstanding uncertainty is specialist validation of the imported quantum comparison and geometric inputs; this is an evidence boundary, not a conjecture created by the integration. The parent task retains that audit and final assembled validation.
