# Paper V cold referee — packet G

PDF SHA-256: `fffe903ea1fdd664173e48030aad5086df09c0e7c7bfcbaa7aee1662f2915543`

Packet: G — singular cubic geometry; Sections 2–3, the characteristic-eleven two-chordal-lines lemma, neutral base change, and source return.

Permitted sources actually read: the complete frozen twenty-page PDF first; reviewer dossier §3, only the complete Lisa Marquand entry; §5 in full; and §§12–13 in full. No external source was opened. In particular, no paper cited by the manuscript, no Paper I–IV source, and no computational artifact was used.

Verdict: GO

## Main theorem in my own words

For the fixed metric augmentation representation of \(A_5\) over \(\mathbf F_{11}\), the Paper-II signed cubic is one of two normalized chordal cubics. Its singular rational normal quartic contains a split twelve-point \(A_5/C_5\)-orbit; quotienting each pair by its Sylow-five stabilizer canonically recovers the six axes \(A_5/D_{10}\). The literal outer action on those recovered axes carries either selected chordal line to the conference line by \(8^{-1}(q_\Pi-1)\). With the metric and the selected line retained, this construction and its inverse preserve the declared source markings; forgetting the selected line leaves precisely the stated residual involution. All geometric constructions commute with neutral scalar extension.

## Earliest unsupported implication

- Locator: none in the assigned surface.
- Printed claim: the first potentially vulnerable implication is Lemma 3.1's scheme-theoretic equality between the saturated Jacobian scheme of the Hankel determinant and the rational normal quartic.
- Why it follows / does not follow: it follows. Four minors occur among the derivatives, the two remaining minors are recovered after localization on \(D(z_2)\), \(D(z_0)\), and \(D(z_4)\), and the displayed derivative equations show these opens cover the projective Jacobian scheme. This proves equality after saturation, not merely equality of rational points.
- Smallest counterexample or missing lemma: none found. The later reducedness assertion in Lemma 4.2 also supplies the required tangent argument: averaging kills deformation of the projective \(A_5\)-action in characteristic 11, while the one-dimensional equivariant Hom space kills projective deformation of the Veronese embedding.
- Downstream scope: Proposition 3.2, Lemma 4.2, Corollaries 4.3 and 6.2, and the packet-G portion of Theorem 1.2 remain intact.

## Controlling findings

1. [passes] [Lemma 3.1] The Jacobian proof is genuinely scheme-theoretic. The localization identities recover both missing Hankel minors, and the cover argument justifies saturation.
2. [passes] [Proposition 3.2] The \(A_5\subset \operatorname{PSL}_2(11)\) argument bounds a rational-point stabilizer by \(5\); split \(C_5\)-eigenlines give two reduced \(\mathbf F_{11}\)-points per Sylow subgroup; disjointness and the count of twelve exhaust the quartic. The map \(G/C_5\to G/D_{10}\) is canonical and leaves the two points above each axis unordered. The order-ten convention \(D_{10}\) is explicit and consistent.
3. [passes] [Lemma 4.2 and Corollary 6.2] The two faithful projective degree-two representations, exchanged by the outer automorphism, yield at most two equivariant Veronese quartics; Proposition 2.1 and its outer image yield two distinct ones. The \(H^1(A_5,\mathfrak{pgl}_2)=0\) and multiplicity-one argument excludes infinitesimal thickening. Both points are rational over the base field, so their reduced two-point scheme and the split fixed divisors persist under every stated neutral field extension.
4. [passes] [Proposition 2.1 and Corollary 6.1] The source-return claim is restricted to the retained decorated output. The metric \(Q_0\), marked axes, sheet sign, bridge \(T\), and fixed pivot are not claimed to be reconstructed from an unmarked cubic. The displayed forward and reverse tensor maps undo the operations in reverse order, and no source-local chart or undeclared cover is promised.
5. [passes] [Definitions 1.1, 5.1; Proposition 5.2] Scalar rigidity is never attributed to the cubic alone: the actual cubic and metric jointly impose scalar equations of coprime degrees. The six-set used by the outer operator is recovered from the marked \(A_5\)-action on the singular quartic, not from the unmarked chordal cubic and its larger projective automorphism group.

## Human-proof deletion test

Ignoring Section 11, its checker, its certificate, and every claim of replay leaves the packet-G proof complete. Proposition 2.1 uses a finite coordinate calculation, but the manuscript prints the intertwiner, the normalized coefficient vector, the projectivity, and the decisive polynomial identity; the checker is described only as independent replay evidence. Lemmas 3.1 and 4.2, Proposition 3.2, the neutral-base-change argument, and the formal source inverse do not use the checker. If one deleted the printed coordinate identities themselves rather than merely computational references and outputs, the particular Paper-II placement and its scalar \(8\) would of course no longer be established; that is not an external-script dependency.

## Attribution and novelty boundary

The manuscript explicitly assigns the characteristic-zero invariant pencil and chordal members to Pinardin–Zhang, the larger unmarked automorphism group to Cheltsov–Marquand–Tschinkel–Zhang, and limits its own geometric claim to the characteristic-eleven reduced/exhaustive lemma, marked stabilizer quotient, normalization, and composition with source return. Because packet G did not authorize reading those papers and none was opened, this report confirms only that the printed priority boundary is appropriately narrow and internally consistent; it does not independently certify source depth or novelty.

## Minimal repair, if verdict is not GO

Not applicable.
