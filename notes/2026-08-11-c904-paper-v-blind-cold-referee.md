# Blind cold referee report

## Hash

SHA-256 of the reviewed PDF `golden_companion_reconstruction.pdf`:

`c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`

This matches the expected frozen hash.

## Recommendation

**MAJOR**

## Theorem in my own words

The paper claims two linked results. First, on the fixed five-dimensional quadratic augmentation representation of (A_5) over ℓ=ᵓ₁₁, a normalized chordal cubic with its selected chordal line and an oriented order-six conference package determine one another: the singular rational normal quartic recovers a canonical twelve-point (A_5/C_5) orbit and hence the six-point carrier (A_5/D_{10}), while applying the outer normalizer difference (q_Π-1) to the chordal generator produces the conference generator. Forgetting the selected chordal line leaves exactly a residual (C_2)-ambiguity. Second, the recovered six-set supports both an augmentation lattice and a (D)-type root/weight lattice with the same four-dimensional binary heart; a normalized symmetric conference operator stabilizes (D_n^∨), and in order six its mod-two normalization gives a nonsplit three-dimensional ᵓ₄-module whose two golden orientations are exchanged by Frobenius.

## Earliest unsupported implication

The earliest load-bearing unsupported implication is **Proposition 2.1, pp. 5–6**. From the one-dimensionality of an intertwiner space, the argument passes to the assertion that the Paper-II signed tensor, after the outer-twisted bridge and scalar normalization, is the Hankel chordal cubic and has outer-difference coefficient (8). Uniqueness of the intertwiner up to scalar does not imply chordality, select the outer twist, or determine either scalar. The matrix (T) is printed, but the matrices ρₓ₅, ρₐₘ, the tensor ν, and its resulting coefficient vector are not; likewise (U) is printed without the cubic (h_M) needed to check the stated substitution. The paper explicitly imports the source tensor from [9] and later points to a checker, so this implication cannot be verified from the manuscript itself.

Its downstream scope is substantial but not total: it controls the claimed placement of Paper II, the exact scalar (8) in Proposition 4.1, the normalized bridge in Corollary 4.2, the exact-return claims of Section 6, and therefore the advertised series-wide geometric correspondence. The scheme calculation for the Hankel cubic in Section 3 and most of the lattice/module results in Sections 7–9 can stand independently once their inputs are assumed.

## Controlling findings

1. **Mathematical correctness — Proposition 2.1, pp. 5–6.** The central placement computation is not a proof available in the paper. The displayed (T) and (U) cannot be checked against undisplayed representations and an undisplayed tensor, and mentioning the replay in Section 11 does not establish the claimed identity. This is a major gap because it is the only bridge from the earlier signed moment to the chordal normal form.

2. **Mathematical correctness — Proposition 4.1 and Corollary 4.2, p. 9.** The matrix ([q_Π]=\begin{pmatrix}-1&8\\0&1\end{pmatrix}) is justified by saying that one coefficient was compared, but neither the coefficient-normalized triangle cubic (c_B) nor that comparison is displayed. Nor is it shown in the manuscript that the particular permutation ((3,4,5,6)) normalizes the chosen embedded (A_5). The qualitative anti-invariant-line argument is plausible, but the exact normalized formula (c=8^{-1}(q_Π-1)h) is unsupported and propagates into Theorem 1.2(ii).

3. **Exposition with correctness consequences — Definition 1.1, p. 3; Definition 5.1 and Proposition 5.2, pp. 9–10.** The groupoids are not defined independently enough for a categorical equivalence: morphisms include “exactly the coordinated relabelings explicitly allowed in the source package,” but those packages and allowed Hom-sets are not formally specified in this paper. Moreover (C^{\mathrm{conf}}_L) is defined by requiring that the proposed inverse already be a normalized chordal shadow. This makes essential surjectivity partly definitional, while full faithfulness invokes unspecified “allowed coordinated relabeling.” The theorem needs explicit objects, morphisms, and compositions with no appeal to source-local conventions.

4. **Mathematical scope — Theorem 1.2 and Corollary 6.2, pp. 3 and 11–12.** The assertion for every field extension requires exhaustion of the chordal locus in the invariant pencil and compatibility of its two lines with base change. The introduction attributes the two chordal members to [8], but the paper proves only the behavior of the asserted Paper-II line and its (q_Π)-image. A precise imported theorem or an internal discriminant/Jacobian calculation is needed before the claimed equivalence for all normalized shadows over all (K/ᵓ₁₁) follows.

## Deletion test

Deleting Proposition 2.1 and the source-return claims of Section 6 removes the evidence that the Paper-II tensor produces the specified chordal generator and removes the numerical normalization tying it to the conference cubic. Sections 3 and 7–9 still contain a potentially publishable conditional geometric recovery statement and a largely independent lattice/module theorem, but Theorem 1.2 must then be restated conditionally and the headline claim that Papers I–III are returned exactly no longer follows. Deleting only Section 11 changes nothing mathematically, because the manuscript says the checker is evidence rather than a premise; at present, however, the written proof does not replace that evidence.

## Attribution / novelty

The paper commendably gives a narrow attribution boundary for the exceptional six-point dictionary, chordal cubics, conference switching, and nearby lattice/module results (Introduction, pp. 1–2; Sections 8–9, pp. 13–16). From the PDF alone, however, the claimed new composition and exact returns cannot be separated cleanly from four same-author predecessor preprints [9]–[12], because essential input data and source conventions are imported rather than restated. Priority and novelty are therefore not assessable on the present self-contained record. If the missing bridge is supplied, the marked compatibility and the identification of the geometric involution with Frobenius would be a meaningful synthesis; as written, the significance is conditional on the unverified placement and normalization.

## Minimal repair

Supply a self-contained verification leaf: define the two (A_5) generators on (A_M) and (W_5), print the projected tensor ν (or its full cubic coefficient vector), define the coefficient-normalized (c_B), and show explicitly that (T) intertwines, that the chosen outer representative normalizes (G), that the transformed cubic is the Hankel determinant, and that (q_Πh-h=8c_B). Then replace the source-dependent groupoid language by formal object and morphism definitions, and either prove or quote precisely the theorem exhausting the two chordal points after arbitrary scalar extension. The lattice theorem may remain as a second main result, but the final torsor identification should be stated conditional on the repaired geometric bridge until that bridge is proved.
