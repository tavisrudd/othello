# Targeted referee reread of revised cubic-phase companion

Date: 2026-09-07. This is a targeted reread after the cold report, not another blind review. The original `2026-09-07-c1102-cold-referee.md` is preserved. Scope: revised `main.tex`, sections 01–04, and the new shadow checker/certificate. The full paper style guide was read before the original review and applied again here. Bibliography, registry and appendix cleanup and the PDF rebuild were still being completed by the parent agent; I did not assess their final state. No manuscript edits or commits were made.

## Assessment

**The substantive accessibility revision succeeds.** The opening now identifies the resource question, separates the p=11 Clifford-product result from the p=7 bounded preparation result, and locates the contribution relative to the established signed-orthogonality framework. The dictionary and translation family have clear jobs. The spectrum section explains why its invariant is useful before introducing its formulas, and the factory section now explains the three-step argument before the interval proof.

The shadow normalization and geometric-lift corrections are mathematically sound, and the new checker passes. I found no new central mathematical error. The remaining changes are local precision and exposition fixes, rather than another structural rewrite. My verdict remains **minor revision**, with the separate public-artifact release condition from the cold report still applicable.

## Concrete residual issues

1. **Fix the ordering for the explicitly named shadow involution.** At `sections/04-shadow.tex:39–40`, `(01)(24)(35)` uses indices for six matching pairs without saying which pair has each index. The stored certificate uses the order

   `({0,1}, {10,infinity}, {2,5}, {3,7}, {4,9}, {6,8})`.

   This differs from the order in the displayed base matching in section 1. Define this ordered six-set when introducing A. Otherwise a reader following the displayed matching order constructs a different named permutation. This is a necessary exact-convention correction.

2. **Attach the shadow-only qualification to the q identity, not coordinate negation.** At `04-shadow.tex:61–64`, the statement that coordinate negation conjugates the full homogeneous gate to its inverse is immediately followed by “The identity is on the shadow.” The full-F coordinate-negation identity is not restricted to the shadow. Move the scope sentence before the sheet-reversal discussion or say explicitly: “The q-exchange identity concerns the shadow; it makes no assertion about extending q to the ten-qudit gate.” The coordinate-negation identity itself is correct globally.

3. **Finish the conference/augmentation conventions.** At `04-shadow.tex:9–20`, the definitions agree with the source: A is the sum-zero subspace on six axes, and the conference cubic is the restriction of the signed triangle sum for a symmetric zero-diagonal ±1 matrix with B²=5I. However, a conference matrix under an arbitrary labeling need not have A5-invariant triangle products. Describe B as the selected conference matrix *whose triangle products are invariant under the reconstructed A5 action*. The certificate's five-coordinate arrays use the augmentation basis `(e_0-e_5,...,e_4-e_5)`; record that basis and the six-axis order alongside the certificate or in the manuscript. The current certificate records a normalized conference coefficient vector rather than a matrix B. It is sufficient to pin that representative, but do not imply that an unspecified arbitrary B necessarily produces the chosen cubic with the chosen labels.

4. **Give “chordal” its one-clause geometric meaning.** The revised section defines the pencil and conference cubic, but still does not tell the adjacent reader that the Hankel cubic is the secant variety of a rational normal quartic. That gloss would explain why the singular curve mentioned at `04-shadow.tex:67–68` matters, and why this is a geometric interpretation rather than merely a second polynomial coordinate calculation. New symbols v0,...,v4 correctly solve the earlier confusion with octavic coordinates.

5. **Replace a few remaining terms that interrupt the first-pass route.** These are optional but cheap:

   - At `03-factory.tex:46–57`, expand QRM as quantum Reed–Muller and RS as Reed–Solomon at first use.
   - At `02-spectrum.tex:115–117`, “the bound need not be attained” gives the needed qualification without introducing an unexplained SIC fiducial.
   - The Macaulay inverse-system paragraph at `03-factory.tex:99–103` interrupts the newly clear route from Waring rank to the factory comparison. It is legitimate mathematics, but could become a brief optional remark or move to the geometric interpretation section. Its present placement asks a quantum-information reader to learn another language just before the operational theorem.
   - At `01-trades.tex:24–28`, “Theorem ... is the dictionary, not the novelty claim” still sounds like review dialogue. A direct formulation such as “This dictionary gives the framework for the resource interpretation and finite comparisons below” retains the scholarly boundary without announcing a defense.

6. **Keep the final open question visibly finite.** `04-shadow.tex:79–81` speaks of the source “stopping ... beyond p=13.” The evidence concerns the tested primes 17 and 19. Writing “the absence of hits at p=17,19 after the p=13 example” would communicate the observed phenomenon without suggesting an all-primes stopping theorem. This is a scope clarification, not a new mathematical objection.

These findings were sent to the parent while its final edits were still in progress; source line numbers refer to the snapshot I reread and may move after those corrections.

## Exact shadow verification

Read `verification/shadow_check.py` in full and checked its relation to the source conventions. Ran:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 /home/tavis/src/othello/papers/clebsch-cubic-phase/verification/shadow_check.py --check
```

Result: PASS. The script checks the actual pullback `h(qy)=2*normalized_second(y)`, the involutory exchange after defining the actual second representative as `h(qy)`, and the normalized pullback using `8q`. It also visits the 1320 stored geometric actions, finds exactly 60 preserving the embedding, identifies them with the stored A5, and checks determinant 1 for each restriction while det(q)=-1. It additionally checks directly that q is absent from the restrictions. This repairs the invalid non-equivariance inference in the historical script.

The manuscript correctly distinguishes polynomial pullback from action on phase states: if C_A sends `|y>` to `|Ay>`, then `C_A|h> = |h composed with A^{-1}>`. Consequently **7q** is the state map to the normalized second representative, because `(7q)^{-1}=8q` and `2*8³=1 mod 11`. The scalar convention and the direction of the Clifford map are now both correct. Coordinate negation likewise gives the stated full gate conjugacy.

The new check relies on the stored reconstructed representation and bridge inputs. It verifies the advertised assertions about all those matrices; it does not independently derive the PGL representation from scratch or reconstruct the A5 constituent anew. I did not rerun the large Hessian censuses or the full historical shadow pipeline. The original cold report's remaining evidence limits still apply.

## Reader trajectory and positioning

The introduction now permits an adjacent reader to retain the complete result without first mastering conic matching geometry. Its explicit distinction between the two field sizes prevents a serious potential misunderstanding. The CSS definition and parameter gloss are proportionate, and the translation example is now motivated as a control rather than another competing headline. The conic paragraph names the three stages and gives a legitimate route for deferring coefficient details.

The spectrum opening identifies the invariant's job, the single-qudit example demonstrates the rank formula, and the later use of rare large Pauli moduli in Waring rank no longer comes as an unexplained change of topic. The synthesis-rank definition and factory strategy paragraph substantially improve understanding while leaving the exact assumptions intact. Attribution to Watson et al. now distinguishes the source's stronger logical triple-product restrictions from the criterion actually used here.

The final shadow section remains the most demanding part for quantum-information readers, but the new augmentation/pencil/conference definitions make it tractable. With the ordering, scope and geometric-gloss corrections above, it can function as a bounded geometric interpretation rather than a dependency on an unread companion.

No further broad literature sweep or additional theorem is needed to complete this targeted accessibility revision. Final bibliography completion, rendered-page inspection and public reproducibility remain separate checks for the parent to finish.

Vibe: the paper now has a coherent first-pass route; the remaining issues are precise and small.

`go clebsch`
