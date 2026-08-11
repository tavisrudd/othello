# Paper V cold referee — packet O

PDF SHA-256: `fffe903ea1fdd664173e48030aad5086df09c0e7c7bfcbaa7aee1662f2915543`

Packet: O — outer \(S_6\), invariant theory, and marking groupoids; manuscript Sections 1 and 4--6, with downstream scope through Theorem 1.2 and every later use of its marked carrier.

Permitted sources actually read: frozen repaired PDF, full text, 20 pages; reviewer dossier §3, Andrew Snowden entry only, full assigned entry; reviewer dossier §§6 and 12--13, full assigned sections. External permitted sources actually read: none. Thus 0 external sources were read at full text. No prior report, repair discussion, script, certificate, source file, or other rereview was consulted.

Verdict: GO

## Main theorem in my own words

Over every field extension of \(\mathbf F_{11}\), a normalized actual chordal cubic on the fixed metric augmentation carrier determines its singular rational normal quartic, the split twelve-point \(A_5/C_5\)-orbit on that quartic, and the quotient six-set \(A_5/D_{10}\). The literal odd normalizer of this recovered six-set acts linearly on the two-dimensional invariant cubic pencil. Once one of the two chordal lines is selected, its difference from the identity identifies the normalized chordal generator with an oriented conference generator. This construction and its inverse give equivalences of metric groupoids, including their morphisms. If the selected chordal line is forgotten, the remaining ambiguity is exactly the free involution
\[
  uq:(L,h,c)\longmapsto(qL,-qh,c),
\]
so the unselected conference groupoid is the action-groupoid quotient, not an unqualified one-to-one correspondence.

The source-return statement is correspondingly decorated: Papers I and III return only after adjoining the selected chordal line and their stated bridge data, while Paper II returns its chosen signed tensor only together with its fixed multiplicity-one bridge and pivot. The later lattice and Frobenius conclusions use the six-set recovered by this marked equivalence; they do not enlarge the equivalence or recover omitted source-local data.

## Earliest unsupported implication

- Locator: Theorem 1.2 and §4, especially the paragraph before Proposition 4.1.
- Printed claim: the odd normalizer induces a canonical linear involution \(q_\Pi\) on the invariant pencil, independent of the scalar in an intertwiner and of the chosen representative of the outer coset.
- Why it follows / does not follow: it follows. The operator is transported from the literal permutation isometry of the recovered six-set. Rescaling the intertwiner cancels in \(T^{-1}P_\tau T\). Replacing \(\tau\) by an element of the same outer coset composes with \(G=A_5\), which acts trivially on \(\Pi=\operatorname{Sym}^3(A_0^*)^G\). Hence the action is linear before projectivization and its square is the identity on \(\Pi\).
- Smallest counterexample or missing lemma: none. The possible scalar counterexample \(\zeta I\), \(\zeta^3=1\), is excluded at the groupoid level because the metric also imposes \(\zeta^2=1\).
- Downstream scope: the construction validates Proposition 4.1, the selected-line inverse in Corollary 4.3, the morphism definitions in §5, the \(uq\)-deck, Corollary 6.1, and the identification of outer reversal with the marked involution used in Theorem 9.3.

## Controlling findings

1. [sound] [§4, Proposition 4.1 and Corollary 4.3] The outer operation is taken on the literal recovered permutation module and only then transported. The formula
   \[
     (q_\Pi-1)h=8c_B
   \]
   is linear, sign-sensitive, and invertible on either selected chordal line. The selected line is therefore genuine input on the conference side, not something reconstructed from the conference cubic.

2. [sound] [Definition 5.1 and Proposition 5.2] Full faithfulness is proved on actual morphisms. For a fixed normalizer label \(\tau\), the six augmentation-frame points form a projective frame, so the projective map is unique; two linear lifts differ by \(\lambda\). Preservation of \(Q_0\) and of the actual cubic gives \(\lambda^2=\lambda^3=1\), hence \(\lambda=1\). Switching remains an explicit gauge on \([B]\) and is not mistaken for an extra linear automorphism of the augmentation hyperplane.

3. [sound] [end of Proposition 5.2] The unselected assertion is correct at groupoid, not merely orbit-set, level. Given an unselected conference morphism and a selected source lift, functoriality of the two-point chordal scheme sends its line to exactly one of the two target lines. Choosing that target lift gives the ordinary Hom component; choosing the other gives the uniquely \(uq\)-tagged component. Conversely, forgetting the tag gives the original normalizer morphism. Thus the quotient has precisely the extra isotropy already visible as the odd normalizer composed with \(-I\); it neither loses nor duplicates morphisms.

4. [sound] [§5.1] The dependency table keeps line, normalized actual generator, conference orientation, and outer choice distinct. After \(L\) is fixed, the sheet sign and conference orientation are linked by \(8^{-1}(q_\Pi-1)\); after \(L\) is forgotten, \(uq\) fixes \(c\); the full Klein four appears only when both chordal and conference orientations are forgotten. I found no hidden \(\mu_3\), no unrecorded line choice, and no incorrect fibre cardinality.

5. [sound] [Corollary 6.1 and Scope after Theorem 1.3] The source returns are explicitly relative to decorated packages. Paper II retains \(W_5,T\), its pivot, and the chosen sheet; Papers I and III retain \(L\), with Paper III additionally retaining its full bridge datum. The inverse formulas undo the metric duality, polynomialization, pivot, and intertwiner in reverse order. No arbitrary object of an earlier paper, twisted carrier, or omitted chart is claimed to be reconstructed.

## Human-proof deletion test

Ignoring §11 and every mention of replay, scripts, certificates, or checker output leaves the packet-O proof intact. The only finite normalization used by the outer bridge is printed in Proposition 2.1: the intertwiner, coefficient vector, projectivity, and polynomial identity \(U(h_M)=8H\) are all displayed. Sections 3--5 then give structural arguments for recovery, outer difference, scalar rigidification, and the groupoid quotient. The checker is corroboration of the placement leaf, not a premise for the equivalence or its morphism statement.

The downstream main-theorem scope also remains appropriately bounded. Sections 7--9 use the recovered six-set but do not use a computational replacement for the packet-O equivalence, and §10 compares Frobenius-orbit mechanisms without asserting a new geometric functor between Paper IV and the upper branch.

## Attribution and novelty boundary

Within the assigned packet, the manuscript distinguishes classical outer-six and conference ingredients from its claimed composition: the marked compatibility, scalar normalization, exact information loss, and root--weight residue. No external source was opened in this rereview, so I do not independently certify theorem-level priority or the depth of the Howard--Millson--Snowden--Vakil attribution. I found no internal overclaim of an unmarked equivalence: the paper repeatedly states that the unmarked chordal geometry has larger automorphisms and that the selected-line bridge is the new, narrower assertion. On the permitted material, no attribution defect controls the mathematical verdict.

## Minimal repair, if verdict is not GO

Not applicable.
