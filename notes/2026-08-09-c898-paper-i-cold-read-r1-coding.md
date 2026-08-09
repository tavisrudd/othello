# C898 Paper I cold read, round 1 — coding theory

**Frozen PDF:** \`papers/clebsch-rigidity/clebsch_rigidity.pdf\`  
**PDF SHA-256:** \`95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83\`  
**Persona packet:** Packet K — Kaipa coding read  
**Initial human-proof verdict:** \`GO\`

I read the frozen PDF before inspecting any public supplement. For the packet comparison I read Kaipa, arXiv:1612.05447 (especially Proposition 1 and the covering-radius hypothesis); Zhang--Wan--Kaipa, arXiv:1901.05445 (Definitions II.1 and II.3); Davydov--Marcugini--Pambianco, arXiv:2101.12722 (Definition 6.1 and Theorem 6.3); and Ball--Lavrauw, arXiv:1908.10772 (Theorem 17).

## Strongest theorem I believe the paper proves

For a six-arc $A\subset PG(2,11)$, containment of its uncovered locus $U(A)$ in any conic forces $A$ to be the Clebsch hexagon; equivalently, among the associated $[6,3,4]_{11}$ MDS codes the condition that the projective maximum-distance syndrome locus is a conic recognizes the non-GRS Clebsch monomial-equivalence class, and for a fixed syndrome conic it determines the six-column realization up to the stabilizer of that conic.

## Causal proof reconstruction

For a redundancy-three MDS code, the parity-check column rays form a plane arc, and the minimum number of columns spanning a syndrome direction is its coset distance: column rays have weight one, points on secants have weight at most two, and points missed by every secant have weight three. Thus nonempty $U(A)$ forces covering radius three and identifies $U(A)$ with the projective deep-hole syndrome locus. For six-arcs at $q=11$, the chord-defect identity gives

\[
|U(A)|=22-c(A),
\]

where $c(A)$ is the number of triple-chord concurrences. Dye's bound $c(A)\leq 10$ gives $|U(A)|\geq 12$. If $U(A)$ lies on a conic, the line bound also gives $|U(A)|\leq 12$, including the degenerate cases. Equality therefore forces $c(A)=10$, and Dye's equality classification forces the Clebsch orbit. Its exterior chords leave the twelve rational points of the associated nonsingular conic uncovered, so the locus is exactly that conic. Projective equivalence of the unordered parity-check rays is then precisely monomial equivalence of the code. Finally, DMP's arc--coset formulas turn the twelve projective directions into $12(11-1)=120$ deep-hole cosets and give $\binom63=20$ minimum-weight leaders in every such coset; multiplying by $|C|=11^3$ gives the received-word count.

## Earliest unsupported implication

Within the assigned coding-theory chain, the earliest step not demonstrated from the PDF alone is the opening assertion of Section 6 that the $6\times6$ evaluation matrix of the parity-check columns on $X^2,XY,XZ,Y^2,YZ,Z^2$ is nonsingular. The displayed $H$ makes this a short exact calculation, and the cited normal-rational-curve/GRS dictionary correctly turns it into the non-GRS conclusion, but the determinant (or a kernel witness) is not shown. I classify this as a compressed finite check, not a proof gap.

## Controlling findings

1. **Proof.** The code/geometric implication is sound and does not import a Reed--Solomon-only theorem: the manuscript proves rigidity for an arbitrary six-column plane MDS realization and uses the general parity-check-column span interpretation of syndrome distance.

2. **Normalization.** The quotient ladder is correct and unusually explicit. A projective syndrome point is one scalar class of nonzero syndromes, hence represents $q-1=10$ distinct cosets; a coset contains $11^3$ received words; and leaders/nearest codewords are counted separately. The totals $12$, $120$, $2400$, and $159720$ agree with DMP Theorem 6.3 and with the elementary syndrome count.

3. **Proof/citation.** The covering-radius hypothesis that is delicate in Kaipa and Zhang--Wan--Kaipa is not silently assumed here. Redundancy is three, every syndrome is spanned by three independent parity-check columns, and the exhibited uncovered points rule out radius two. This is exactly DMP's incomplete-arc case.

4. **Normalization/exposition.** “Reconstructs the code” is ultimately stated at the correct strength: Theorem 1.1 fixes the projective arc orbit, Corollary 4.2 fixes the orbit relative to a specified conic, and the paragraph after that corollary translates this to monomial equivalence. The introductory phrase “six-column realization” could be read as labelled recovery until that paragraph, but the formal claim itself is not overstated.

5. **Computation/exposition.** The non-GRS conclusion uses the correct equivalence notion and the correct conic criterion, but its only paper-internal verification is the unexpanded nonsingularity assertion identified above. Showing one determinant value would make this advertised feature independently auditable at negligible cost.

## Novelty relative to Packet K

The packet literature passes from a fixed RS/PRS or general MDS code to its extension points and deep-hole classes, whereas this paper proves the inverse small-arc statement that the entire conic-shaped projective deep-hole syndrome locus recognizes a specific non-GRS monomial-equivalence class and recovers its parity-check geometry.

The initial \`GO\` verdict is frozen here before supplement inspection: the one compressed determinant check is finite, explicit, and non-causal for the rigidity theorem, while every coding-theory hypothesis and quotient conversion controlling the headline claim is visible and correct in the human proof.

## Supplement postscript

After freezing the report above, I inspected only the allowed public verification surface. Its trust manifest routes the conic-locus proposition through an independent exact replay and routes the decoding oracle through both kernel-checked terminals and the paper-owned \`check_decoding.py\`. Running that checker exhaustively over all 133 projective points of \(PG(2,11)\) reproduced the twelve uncovered conic directions, the secant-index spectrum \((12,90,15,10)\), the nonzero-coset distance distribution \((60,1150,120)\), the nearest-word multiplicities \((960,150,100,120)\), all twenty weight-three supports per deep-hole syndrome, and the projective/monomial automorphism orders \(60/600\); all assertions passed. This resolves any residual concern about finite syndrome enumeration, scalar-to-coset counts, leader multiplicities, and the displayed witness's conic locus. It does not repair the human-exposition point in Finding 5: the supplement route inspected does not display the quadratic-evaluation determinant used for the non-GRS sentence. The categorical verdict remains \`GO\`.
