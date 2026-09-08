# Cold referee report: Irrationality of Cubic Threefolds after One Stabilization

**Review date:** 2026-09-08. **Task:** C978, cubic-threefolds.
**Reviewed revision:** monorepo `ad952b6f4`; revision context: `1f368b9e2` to `ad952b6f4`, restricted to `papers/cubic-stabilization-m1/`.
**Recommendation:** accept after minor revision. I found one definite, localized overstatement about arithmetic forms, and several opportunities to shorten or clarify the exposition. I found no fatal error or unresolved proof gap in the principal argument during this review. This is a scholarly referee judgment with the limitations recorded below, not formal certification.

## Summary and contribution

The paper proves that the product of every smooth complex cubic threefold with a projective line is irrational. Its invariant counts whole rank-two primary summands of the generic even quantum connection with nonzero square-zero centered Euler operator and distinct formal exponent classes. The essential local construction modifies the canonical lattice along the image of the nilpotent operator. Pairing horizontality makes the resulting connection regular singular, and flatness preserves its residue. The cubic calculation gives exponent representatives −1/6 and −5/6. Quantum blowup and projective-bundle decompositions yield intrinsic additive formulas. Surface and curve vanishing then makes the count birationally invariant in dimension four, with values two on the stabilized cubic and zero on projective space.

The revision also defines a canonical-lattice count which can detect integral, nonzero residue gaps. A single rational matrix calculation treats degree-one, degree-two, and degree-three index-two Fano threefolds, with squared gaps 16/9, 1, and 4/9. Further consequences concern genus-eight Fano threefolds, universally CH0-trivial irrational fourfolds, an additive Grothendieck-group extension, and restrictions on possible rationalizing factorizations.

## Significance and scope

The uniform one-stabilization theorem is a substantial birational result. Its point is not a new computation of the cubic exponents in isolation: the paper properly attributes the neighboring monodromy calculation to Cai and the broader Euler-block approach to Katzarkov–Kontsevich–Pantev–Yu. What matters here is the passage through surface centers and preservation under stabilization. The paper makes that distinction intelligible.

The index-two extension fits naturally. It is supported by the same rank-two argument and replaces several separate calculations with one parameterized calculation. The degree-two resonant case gives a concrete reason to retain the canonical lattice. The spectral extension likewise earns its place by distinguishing the three squared gaps, exhibiting failure to factor through Hodge–Deligne data, and explaining the dimension-five limitation. These additions do not look like unrelated applications appended to inflate the paper.

My significance judgment is based on the manuscript and the particular primary sources inspected, especially Cai's introduction. I did not conduct a comprehensive priority search or verify the entire rapidly developing literature cited in the introduction.

## Correctness assessment

**Local connection argument.** I checked the coefficient identities in `prop:generic-spectral-connection-splitting`, `lem:A0preserve`, `lem:cyclic-primary-persistence`, and `prop:rank2-rigidity` (§2.1–2.2, PDF pp. 3–6). The Sylvester operator is invertible between separated primary spectra. The pairing argument uses its nondegenerate leading restriction and the isotropic line correctly. The persistence proof computes the commutant before assuming nilpotence away from the closed point, avoiding a circular argument. Its differential equation for N² is homogeneous, so formal uniqueness preserves its vanishing. After the modification, the remaining possible base pole is eliminated by the nonzero upper-right residue entry. This does not require nonresonance.

The statement that the residue conjugating matrix may use the first jet of the original gauge (`02-qdm-marker.tex`, lines 239–245) is useful and correct. Preservation of the original lattice implies preservation of the elementary modification; separate integral shifts of eigenlines would be a different operation. Consequently I see no reason to reject the strengthened lattice count merely because the degree-two exponent classes coincide.

**Geometric comparisons.** The delicate part is `lem:faithful-center-base-change`, not the final weak-factorization contradiction. I inspected Iritani's §2.2, Remark 2.3, (5.15), Remark 5.6, the connection formulas (5.42)–(5.43), Theorem 5.18, and §5.8.2, including (5.47)–(5.48). They support the graded-completion convention, reduced source, independent target coordinates, and regular comparison used in the manuscript. Iritani–Koto's Theorem 5.1 and Remarks 5.2–5.3 likewise supply the stated module isomorphism, connection compatibility, invertible joint Jacobian, and regular-z interpretation.

The injectivity argument has the necessary distinctions: at a fixed numerical curve class the reduced z-free coefficients are polynomial in the other even variables; bounded ample degree gives finite collision fibers; target divisor variables are not permitted in source coefficients; and full exponentials, rather than a fixed finite bulk truncation, distinguish the numerical classes. Independent unit coordinates then separate the spectra of different copies. I found no missing geometric hypothesis in these particular source-to-manuscript passages. I have not independently reproved the cited decomposition theorems.

**Calculations and vanishing.** An exact symbolic replay constructed for this review verifies the universal characteristic polynomial, rational primary splitting, first Sylvester jet, modified residue, all three Fano specializations, and the separately split cubic appendix's complete printed A1 matrix. The outputs agree with `prop:universal-rank-two-residue`, `eq:RX`, and `prop:cubic-block-data`. Przyjalkowski's §2.6.1–2.6.2 and Theorem 2.6.6 give the anticanonical counting-matrix conventions and the entries (240,1248) and (48,160) used in Theorem 3.2. Proposition 2.6.4 gives the stated weighted-hypersurface models. The q versus anticanonical-degree normalization is consistent.

I checked the curve residue directly in the printed proof. The surface dimension inequality strictly raises ordinary degree when K is nef, so the whole even primary factor has rank at least three. The other surface cases reduce correctly using classification and the established operation formulas. Given those inputs, the projective endpoint and weak-factorization contradiction are short and valid.

**Consequences and additive extension.** The V14 projective-bundle birationality agrees with Kuznetsov's Theorems 2.17–2.18. The CH0 corollaries have the expected logical form, but their individual external inputs were not reverified in this review. Bittner's presentation, as invoked, gives the stated additive extension once the intrinsic formulas are available. The proof correctly factors an additive homomorphism through (L−1) without claiming multiplicativity or stable-birational invariance. The equal-Hodge-diamond example and the sign in the telescoping factorization formula check out. The new dimension-limit argument at `04-motivic.tex`, lines 176–184, is a useful and correct cancellation argument for group-valued invariants.

## Exposition, organization, and accessibility

The current paper has a clear first-pass route: the theorem is on page 1, the count and contradiction appear immediately, and the concrete rank-two construction precedes the abstract additive framework. The elementary-modification example on page 4 and the source/target exponential example on page 7 explain the two least routine changes of language. The table of Fano families on page 14 is compact and informative. The exposition is accessible to an adjacent algebraic geometer willing to learn the stated QDM conventions, although §2.3 remains demanding.

I inspected every rendered page, 1–20. I saw no clipped formulas, unreadable table, unresolved reference marker, or disruptive empty page. Page 7's table is dense but legible; page 20's bibliography is compact but orderly. The appendix occupies approximately one and a half pages and can be skipped without losing the main proof. Retaining it is defensible as an alternate-basis check, though it is the first optional material to move to supporting files if a venue imposes a strict limit.

## Major comments

There is no major correction requested. The main comparison and lattice-preservation claims deserve specialist attention because they carry the theorem, but the present read did not expose an unfilled step. I distinguish that favorable assessment from a verification of the full source literature or of the Lean artifact.

## Minor comments and requested revisions

1. **Definite localized error: arithmetic degree-five qualification.** `sections/03-applications.tex`, lines 99–100 (PDF p. 14), says that rationality assertions for degree-four and degree-five forms require separate arithmetic hypotheses. The cited Kuznetsov–Prokhorov Theorem 3.3 states that every smooth quintic del Pezzo threefold is k-rational; its proof is on printed p. 10. Degree four has the rational-point/line conditions in Theorem 3.5. Restrict the qualification to degree four, and state the unconditional degree-five result if retaining this arithmetic paragraph. This does not affect Theorem 3.2 over C.

2. **Exposition request, not a proof gap: spell out the remaining base pole.** In `prop:rank2-rigidity`, lines 231–233, insert a short explanation that the centered leading base coefficient is q_partial N by the preceding centralizer argument. Its upper-right z-pole becomes regular under diag(1,z); only the lower-left entry of the regular base coefficient can then create z^−1 kE21. This would make the passage substantially easier to check without enlarging the proof appreciably.

3. **Organization request: compress §2.8.** `sections/02-qdm-marker.tex`, lines 773–862, reintroduces occurrence-indexed notation and proves another version of the operation formulas after the intrinsic formulas and main theorem have already been established. The general monoid-valued statement is legitimate, but its approximately one-and-a-half pages interrupts the transition to the stronger Fano result. A shorter proposition and proof, or relocation next to the additive extension, would preserve its content and improve proportion. This is an editorial preference, not a demand to delete the general result.

4. **Clarify grading shifts precisely.** In §2.3's “Regularity in z” paragraph, the cited theorems intertwine the actual z-connections. Their nonzero homogeneous map degrees should not themselves suggest an extra unexplained operation on residue eigenlines. Say explicitly that the actual comparison preserves the relevant residues up to the stated common normalization shift, and that no separate regrading of eigenlines is being performed. The present conclusion about discriminants is sound; the phrasing could better distinguish homogeneous degree from connection gauge.

5. **Optional strength and economy.** Corollary 3.1 could be stated for positive lattice count, since the same proof works and Theorem 3.2 immediately needs it. If retained in its exponent-only form, it is correct. I would prioritize shortening §2.8 over adding another corollary.

## Editorial recommendation

I recommend acceptance after minor revision. The theorem is significant, the mechanism is communicated, and the strengthened index-two result is a coherent extension supported by the checked calculation and the same comparison argument. The definite correction above is peripheral. The requested exposition changes are small; they should not trigger another expansion of the manuscript or a replacement of its main organization.

## Coverage, evidence, and limits

- **Read fully:** `cubic_stabilization_m1.tex` (including abstract, disclosure, and all 26 bibliography entries), all five included section files (1,551 section-source lines), and all 20 rendered PDF pages. The PDF pages were inspected as individually rendered images at a 1,250-pixel longest dimension; source reading supplied the fine mathematical text. The substantive mathematical source diff was inspected by file and bounded section ranges. I did not inspect the binary PDF patch.
- **Public verification material:** read the universal-residue README and both `derive.py` and `check_indicial.py` fully; sampled the main verification README and revised claim-map coverage/caution entries relevant to the new results. The current manuscript openly marks the strengthened classification and geometric comparison statements as absent or partial formal coverage. No Lean/lake command, formal build, or theorem certification was performed. I did not run the paper build gate.
- **Literature actually inspected:** the precise excerpts identified above from Iritani, Iritani–Koto, Przyjalkowski, and Kuznetsov–Prokhorov; Beauville's main theorem, conventions, and formulas (2.1)–(2.3); Kuznetsov's Theorems 2.17–2.18; Cai's introduction and stated exponent comparison. These were cached primary texts, not previous reviews. No paper was read entirely for this literature check. No new literature fetch was needed.
- **Not independently reverified:** the original proofs of the decomposition theorems; minimal-surface classification; AKMW weak factorization; Bittner's theorem; the individual Voisin/Colliot-Thélène/Yang–Yu–Zhu inputs; current stable-rationality examples and very-general results; the companion sharpness manuscript; completeness of the priority account. These are imported inputs or neighboring claims, not findings of error.
- **Independence:** no earlier referee report, drafting conversation, C1128/C1131 conclusion, or other reviewer's finding was consulted. The lane handoff was omitted to preserve that explicit boundary. No manuscript was changed.

Cached primary-source SHA-256 identifiers (keys are unversioned cache keys; the source texts display the cited versions):

| Key | SHA-256 |
|---|---|
| arXiv:2307.13555 (v3) | c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b |
| arXiv:2307.03696 (v4) | 5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624 |
| arXiv:math/0507232 (v3) | 62e3e974bbddb580acade0728bf6513076c4548c15c3cf885c809f6eb8052e0c |
| arXiv:1911.08949 (v3) | 0cdc0dd962fb6af047976dea0976566d9a256b801842aad388133cc677b9e203 |
| arXiv:alg-geom/9501008 (v1) | 9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3 |
| arXiv:math/0303037 (v1) | 3223183a958572759e6f8ac3a26a7801c1dd13c6e6edd04f917d1646b5ec2a74 |
| arXiv:2608.01577 (v1) | 06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e |

### Reproducible finite algebra bundle

Working directory: `/home/tavis/src/othello`.

```sh
uv run --with sympy==1.14.0 python3 notes/2026-09-08-c978-cold-diff-review-check.py
```

Expected stdout is exactly `notes/2026-09-08-c978-cold-diff-review-check.json`, with status `pass`. Inputs are the matrices printed in Proposition 2.8 and Appendix A, over Q(a,b,q) with q(2a+b) nonzero and Q(r) with r nonzero. No randomness is used. The script solves the first off-diagonal gauge equations rather than substituting the printed gauge coefficients, and checks the universal and separately split cubic presentations. This is a trusted SymPy 1.14.0 execution checking finite algebra, not geometric transport or an independently formalized proof. I inspected the public checker implementations as well; the review script is a fresh implementation of the same mathematical first-jet method, not an independently discovered proof strategy.

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| 2026-09-08-c978-cold-diff-review-check.py | 2426 | 906c7d77a7034bb4e52b97689952f6cd7114685cf283f40d974a1b9bd7e56a00 |
| 2026-09-08-c978-cold-diff-review-check.json | 698 | 245a3075ce919d02d639e1bd56fd60170593a924dafb673479e145ef6660b98f |

### Mystery ledger: bounded ej + tt closeout

The closeout pass asked whether resonance actually invalidates the stronger count and whether the additional families dilute the cubic argument. The first is settled at the level of this review by regular original-lattice transport, the elementary modification, the nonresonant-free Lax calculation, and the exact degree-two residue {0,−1}. The second is settled editorially by the shared universal calculation and the new information retained by the spectrum. The group-valued blowup formula's inability to give a birational obstruction two dimensions higher is explained by the printed codimension-two blowup argument. No additional task-owned mathematical mystery emerged. The remaining gaps are the explicitly limited literature/formal coverage above, not a new conjecture or a fabricated follow-up.

**Handoff:** report and adjacent checker/output are intentionally uncommitted under the parent agent's shared-index instruction. Parent owns reconciliation, manifest, and commit.

Vibe check: the central proof and new Fano extension withstand this cold read; fix the degree-five arithmetic sentence and make a few small cuts.

`go cubic-threefolds`
