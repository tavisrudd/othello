# C956 cold referee report: Sharpness of Irrationality after One Stabilization for Cubic Threefolds

**Reviewed artifact:** `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`, including both appendices, generated mathematical TeX values, bibliography, and all 19 pages of the accompanying PDF. The paper tree agrees with monorepo revision `ad952b6f4`; the ambient HEAD advanced during this read, but a scoped `git diff --quiet ad952b6f4 -- papers/cubic-stabilization-irrationality` passed. Revision context: baseline `1f368b9e2` to `ad952b6f4`.

**Independence:** This report was commissioned as a journal-style cold review. I had the assigned scope and revision diff, but did not read previous referee reports, drafting conversations, task conclusions, or the other referee's findings. I deliberately did not load the historical lane handoff. The report assesses the complete current paper, not only its changes.

## Summary and contribution

The paper proves a uniform two-variable rationalization theorem for quartic del Pezzo surfaces with a rational point and stably permutation geometric Picard lattice. Its main construction chooses a saturated rank-three subtorus of the rank-five projective Cox torus, finds a descended tangent section meeting general orbits uniquely, and identifies its quotient with projective four-space. An equivariant generic torsor trivialization identifies the same quotient with the surface times a rational two-dimensional torus.

Applied over the function fields of the two specified cubic fibrations, this gives rationality of each cubic series after two stabilizations. The separately imported one-stabilization obstruction then makes the level exactly two for the two cubic threefolds, over every characteristic-zero field. The fourfold and generic-surface consequences are useful formulations of that exactness. The finite-index slice theorem and the full-I3 rank-four obstruction explain, respectively, an extension and a limitation of the method.

## Significance and scope

The surface theorem is a substantial refinement of the previously available uniform stabilization bound, and the quotient construction is sufficiently concrete to explain where the number two comes from. The exact cubic level is the most memorable consequence, but it depends essentially on the companion lower-bound theorem. This paper does not independently establish that lower bound.

The selected-simplex torus identification and the residual norm-one torus description fit naturally: they explain the lattice calculation already needed by the proof. The linearization corollary is a short, legitimate application of exact stabilization, with its overlap with Popov acknowledged. The finite-index discussion earns its space because it proves dominance and degree divisibility for the particular rational slice component and supplies a geometric example of strict divisibility. The Chow and torsion-order paragraphs are standard consequences, appropriately presented as consequences rather than separate major advances. They do not provide new nonrational quotients with coprime slice indices, and the text says so.

I would retain these extensions. I would not expand them into a broader survey or add more consequences. The current 19-page length is reasonable, with roughly four pages devoted to certificates, verification, and references.

## Correctness

I found no definite mathematical error and no unresolved proof gap in the paper's new main argument within the scope of this review.

1. **Quotient criterion, `thm:torus-quotient`, lines 264–390, pp. 4–5.** The cofactor vector gives the correction through character differences, and the integral-basis hypothesis removes finite ambiguity. Descent is applied to the unique corrected point, not to a choice of torus coordinates. The supplied point in the isomorphism open ensures that the image component meets the open where tangent projection is invertible. Consequently its image is dense in the appropriate linear projective space. Although the wording later says “generically injective, hence birational,” the preceding isomorphism-open hypothesis supplies the stronger fact needed even beyond characteristic zero. I do not regard that sentence as an inseparability gap.

2. **Tangent section and descent, `prop:tangent-section`, lines 567–681, pp. 8–9.** The proof correctly separates split geometric existence, compatibility with tangent projection, and arithmetic descent. Birationality of the universal tangent projection over the generic tangent point supplies a common isomorphism open. Intersecting this with the evaluation open is legitimate on the geometrically integral product. The successive density arguments produce ground-field points in a nonempty fibre; they do not require any printed split witness to descend. The kernel of the total evaluation functional then defines the ground-field slice. A notational clarification at the beginning would help; see minor comment 1.

3. **Computational existence on all smooth parameters, Appendix A.** I replayed the reconstruction and the separate certificate checker. The symbolic four-open cover, localized empty-case identities, and generated TeX agree. I additionally examined a possible specialization hazard in the symbolic nullspace basis. Its only parameter-dependent poles are powers of `b`, already excluded by the displayed discriminant. Thus there is no hidden pole locus on the smooth moduli domain in these witness bases. This additional check uses the published `cox_data` definition and is not an independent reconstruction of the twenty quadrics from geometry.

4. **Equivariant product quotient, `thm:two-variable`, lines 690–744, pp. 9–10.** Stable permutation gives a direct-product identity with quasi-trivial tori and hence H1 vanishing over the function field. A rational section trivializes the torsor equivariantly. Quotienting first by the scalar subtorus and then by T3 is therefore justified; a nonequivariant birational equivalence would not have sufficed. The nonminimal reduction and the finite-coefficient descent from arbitrary characteristic-zero fields to a subfield embeddable in C are sound.

5. **New torus descriptions, lines 500–558, p. 7.** The four-weight augmentation lattice is the character lattice of `Res(E4/k) Gm / Gm`, not of the norm-one torus. The manuscript has this duality in the correct direction. The residual three generators, with their sole sum relation, instead give the character lattice of the cubic norm-one torus. The printed residual matrices preserve that set and agree with the ambient action. The explicit three-ratio correction is consistent with the weight order. The paper wisely does not identify E3 with an ordinary cubic resolvent of E4.

6. **Applications, Section 5.** The generic-surface, partner, and fibration statements follow from the stated function-field identities, including infinite stabilization levels. For `cor:torus-linearization-level` (lines 938–969, p. 12), the rank-two invariant field after m trivial variables is exactly `k(X_j)(s_1,...,s_m)`. A primitive rank-one restriction has invariant field `k(X_j)(u^b v^(-a))`, so its exact level is one. A unimodular complementary monomial supplies the diagonal coordinate. Over C, the finite-subgroup invariant monomial lattice has rank two, giving the claimed rational quotient. These arguments concern rational actions, as explicitly stated.

7. **Finite index and zero-cycles, `thm:finite-index-slice` and `cor:finite-index-chow`, lines 977–1135, pp. 12–14.** The component is defined through the tangent-projection isomorphism open, so it is geometrically integral and descends. The differential argument proves dominance. Over algebraically closed constants, the finite intersection torsor has constant abelian kernel; its field-factor degrees divide the kernel order. Geometric integrality permits the degree to be compared after extending constants. The scroll example satisfies the stated tangent and minor hypotheses and has the asserted inverse. The moving/push-pull argument kills CH0 of degree zero by each parametrization degree; Bezout and localization give the subsequent conclusions. I see no unjustified replacement of a degree by the total index.

8. **Rank-four obstruction, `prop:rank-four-descent`, lines 1148–1213, pp. 14–15.** Rank-four subtori are correctly reduced to saturated invariant rank-one character kernels. The four simultaneous sign systems exhaust such kernels. The independent integer checker confirms the unique line, distinct weights, orbits of sizes four and twelve, all 4,368 five-subsets, 1,992 unimodular subsets, and zero descended five-subsets. The negative conclusion is carefully limited to this representation and the full I3 image.

The imported statements remain a real boundary. I checked their locations and compatibility as detailed below; I did not independently prove the OADP theorem, the four-type classification, the cubic lower bound, or the very-general non-stable-rationality theorem. None should be described as newly verified by these certificate runs.

## Exposition, organization, and accessibility

The two quotient descriptions in the introduction give a good first-pass explanation. The dimension count is useful, and the reordered geometric-existence / compatibility / arithmetic-descent proof is easier to follow than a mixture of those steps. The rank-one cofactor example and scroll example are well chosen. The warning that an executable number-field parametrization needs additional descended data is accurate and improves the claim of constructiveness.

A birational geometer can follow the proof without understanding every large coefficient in Appendix A. Adjacent readers will still need familiarity with Cox rings and universal torsors; that is appropriate for the scope. The elementary torus descriptions reduce that cost. On all 19 rendered pages I saw no clipped formula, broken reference, unusable table, or serious layout obstruction. Page 16's witness table is separated from its introductory paragraph on page 15; this is a mild navigation issue only. The displayed Bezout identity continues onto page 18 naturally enough.

## Major comments

There are no major mathematical revision requests from this read.

For the editor, the exact-level title and fourfold consequence require independent acceptance of the companion one-stabilization theorem. My favorable verdict on the upper-bound paper must not be read as a second independent review of that theorem. If that input were not accepted, the uniform surface theorem and cubic upper bounds would remain the contribution supported by this report, while the exact-level claims would require qualification.

## Minor comments

1. **Split notation in the evaluation map.** At lines 579–589 (`prop:tangent-section`, p. 8), `ev_{p,x}: H_p -> k^4` and the separate `x_j` are written before the geometric-base-change convention is made explicit. In a nonsplit form those weight components need not be k-defined. State that this display is over the splitting field (or use geometric notation there), and that invertibility is a Galois-invariant open condition. The later use of `lambda -> lambda(x)` is already the correct descended formulation. This is an exposition request, not a defect in the descent proof.

2. **Field range at the Popov citation.** At lines 953–955, the conclusion is over arbitrary characteristic-zero k, whereas Popov sets up his paper over an algebraically closed field. The assertion used here remains valid for a split torus over k by diagonalization and a basis of the kernel character lattice. Add that short reason, and optionally cite Popov's Lemma 5 alongside Theorem 4. No weakening of the corollary is needed.

3. **Fix the Cox form once.** At lines 124–126 and the beginning of Section 3, clarify that for a nonsplit S the chosen projective Cox model is the form attached to the universal torsor with a rational point used later. Section 4 makes the choice, but an earlier one-clause convention would prevent readers from wondering whether an arbitrary Cox twist is intended. The existing torsor construction resolves the mathematics.

4. **Small cuts.** The warning against specialization is repeated at the beginning and end of the short proof of `cor:cubics` (lines 747–768); one occurrence suffices. The sentence about not identifying a cubic resolvent (line 557) could be omitted unless a concrete ambiguity elsewhere requires it. The ordinary cubic-resolvent identification is not used. Neither change should remove the useful distinction between splitting-field coordinates and descended points.

## Editorial recommendation

**Accept after minor revision**, assuming the imported companion lower bound receives its own satisfactory mathematical review. The central quotient and descent construction is substantial and, on this read, correct. The additional structural results fit naturally and remain proportionate to the main theorem. The minor requests above improve precision and access; they do not require a new main proof or a larger computation. This is a referee judgment with the explicit coverage limits below, not formal certification or a claim that every background theorem has been re-proved.

## Reading and verification record

**Read fully:** all 1,444 lines of the current primary manuscript; both generated mathematical TeX files; all 19 rendered PDF pages; the README; the entire primary-manuscript revision diff. I also read the changed verification-program hunks and changed public guide/claim/source-ledger hunks. No previous review material was used. Rendered page images were temporary owned intermediates and were deleted after inspection.

**Sampled code and artifact context:** the reconstruction's input matrices, Cox relations, tangent/nullspace/witness construction, and check-mode entry point; the slice checker's main certificate and residual-lattice checks; the rank-four checker's rational elimination, affine-action, orbit, and subset checks. I did not line-read every verification file, run the full build gate, or rebuild the PDF. The manuscript and certificate checking modes were read-only. No Lean or lake command ran.

**Primary literature inspected:**

- Tschinkel–Zhang: initially the cached older text at key `arXiv:2608.20029`, SHA-256 `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`, sampling Lemma 2.1, Remark 2.2, Theorem 2.4, Theorem 3.4/Corollary 3.5, Proposition 4.1/Lemma 4.2, and the cubic fibration discussion. Its numbering differs from v2. I therefore checked the current cited [v2 primary HTML](https://arxiv.org/html/2608.20029v2), especially Theorem 2.4, Proposition 4.1/Lemma 4.2, and Propositions 5.1/5.3. The stated hypotheses and uses agree. I did not independently re-prove its OADP or classification results or re-transcribe all twenty equations.
- Popov: cached `arXiv:1110.2410`, SHA-256 `0d08a8504457aa1c9292b6174639d6b1516cb3351f75ae5c0b372226ef223ff1`; read the field convention, Theorem 4/Lemma 5, Theorem 5 and Corollary 5. This confirms both the invariant-field mechanism and the acknowledged predecessor examples. [Primary version](https://arxiv.org/abs/1110.2410v4).
- Chatzistamatiou–Levine: cached `arXiv:1605.01913`, SHA-256 `a17393ffaaa755bc9dcbcde12ce11ce52537e5a54bff174b8ccb23071476afb5`; sampled Definition 1.1 and Lemma 1.3, confirming the orientation convention and divisibility formulation. [Primary source](https://arxiv.org/abs/1605.01913).
- Kuznetsov: cached `arXiv:math/0303037`, SHA-256 `3223183a958572759e6f8ac3a26a7801c1dd13c6e6edd04f917d1646b5ec2a74`; sampled the flop paragraph and Theorems 2.17–2.18. The projective-bundle correspondence is the one the manuscript invokes. [Primary source](https://arxiv.org/abs/math/0303037).
- Engel–de Gaay Fortman–Schreieder: located Corollary 1.4 in cached text and checked its statement in the cited [v3 primary HTML](https://arxiv.org/html/2507.15704v3). I did not read its proof. The older cached PDF has SHA-256 `f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee`.
- Rudd companion: inspected only the local statement `thm:every-cubic`, `papers/cubic-stabilization-m1/sections/01-introduction.tex`, lines 12–19, as the imported lower-bound input. No review of its proof is claimed.

The remaining bibliography was read as bibliography, not as full source texts. In particular, I did not independently inspect the original Voskresenskii, Manin, CT–Coray, ACTP, or Shepherd-Barron papers in this review. The two-dimensional torus rationality and high-degree del Pezzo rationality results were treated as classical inputs. No novelty or priority verdict based on absence of earlier work is claimed; this was not a complete literature search. Cache lookups preceded public-source retrieval, and no cache entries were overwritten.

**Reproducible computation bundle:** from `/home/tavis/src/othello`, run:

```sh
uv run --with sympy==1.14.0 python3 notes/2026-09-08-c956-cold-diff-review-check.py
uv run --with sympy==1.14.0 python3 notes/2026-09-08-c956-cold-diff-review-extra.py
```

The first wrapper retains exact commands, return codes, stdout/stderr, Python/SymPy versions, and hashes/byte counts of load-bearing check inputs in `2026-09-08-c956-cold-diff-review-check.json`. All three commands passed: reconstruction, independent slice checker, and independent integer rank-four checker. The second retains the denominator-domain check and the orbit-correction/scroll-inverse identities in the adjacent `extra.json`. It reuses the published Cox transcription; it is independent only of the cover calculation, not of those geometric inputs. An exploratory stronger assertion that these bases have no parameter-dependent poles failed because they contain `1/b`; the final check tests the correct requirement, that all poles are excluded on the stated smooth open, and passes. This was a rejected test hypothesis, not a discovered manuscript defect.

The adjacent SHA-256 manifest records script/output and reviewed-manuscript hashes and byte counts. The report and bundle remain uncommitted solely because the parent explicitly owns the shared-index commit; only these owned notes paths were written. The parent must commit the bundle together before representing it as committed evidence.

## Mystery ledger and closeout

The explicit ej+tt closeout asked whether the characteristic-lattice dualities hide an interchange of norm-one and quotient tori, whether a finite-index component can have degree smaller than its index, and whether symbolic bases introduce omitted exceptional loci. The duality check settled the first, the geometric scroll settles the second, and the retained denominator check settles the third on the exact four witness domains. No genuine new mathematical mystery remains from this bounded review. Expanded ground-field parametrizations remain an implementation task requiring the additional data listed in the manuscript; they are not needed to close an existence proof.

Vibe check: mathematically coherent upper-bound paper; minor precision edits remain, with the companion lower bound independently owned.

The next action is the parent's reconciliation and ordinary minor revision, followed by the existing review gates; no new task ID was allocated here.

go cubic-threefolds
