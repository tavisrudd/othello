# Paper V cold referee — packet C/L

PDF SHA-256: fffe903ea1fdd664173e48030aad5086df09c0e7c7bfcbaa7aee1662f2915543

Packet: C/L — conference matrices and integral lattices; manuscript focus Sections 3--4 and 7--9.

Permitted sources actually read: 3 of 4 mathematical sources were read at full text; the fourth was read at the exact pages cited by the manuscript.

- Reviewer dossier: notes/2026-08-10-clebsch-paper-v-reviewer-dossier.md, partial, only Section 3's Edwin van Dam and Willem Haemers entries, Sections 7--8, and Sections 12--13.
- J. M. Goethals and J. J. Seidel, *Orthogonal matrices with zero diagonal*, full text, published 1967 article, cache key 10.4153/CJM-1967-091-8, SHA-256 68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734; relied on Sections 1--3 for conference-matrix definitions, switching equivalence, and the symmetric congruence condition.
- W. H. Haemers and L. Parsaei Majd, *Spectral symmetry in conference matrices*, full text, published version in *Designs, Codes and Cryptography* 90 (2022), cache key 10.1007/s10623-021-00858-8, SHA-256 86a4d6e41f62ef224f5a410653120794bf756ad9a9e2dc2aaa4bdc2f4f4c799e; relied on Sections 1--2 and 6 for switching, symmetric conference conventions, known small-order classification, and sign-symmetry.
- F. C. Bussemaker, R. A. Mathon, and J. J. Seidel, *Tables of two-graphs*, partial, author-report pagination pp. 12, 21, and 83 (the exact manuscript-cited pages), cache key 10.1007/BFb0092256, SHA-256 ac9d300a4a0e5f46d4d4b36b66d5f620f616ffad3197ae93fad50b8ff224748a; relied on the order-six discussion, the conference-two-graph overview, and Table 9. The source records the unique order-six conference two-graph and its alternating-group automorphism action.
- R. Chapman, *Conference matrices and unimodular lattices*, full text, author preprint dated 19 July 2000 corresponding to the 2001 published article (the published typeset version was not separately checked), cache key 10.1006/eujc.2001.0539, SHA-256 1cfd6204e987c924135e2f2f78e833a8ab8f43059b7065ae96bc3934786123fa; relied on Sections 2--3. Chapman treats skew conference matrices, the imaginary quadratic action, and the lattices denoted there by \(D_n^+\), so the manuscript's description of it as a nearby skew/imaginary analogue is accurate.

Verdict: GO

## Main theorem in my own words

On the six-axis \(A_5\)-carrier, the singular quartic of a selected metric chordal cubic recovers the six Sylow-\(5\) axes; the two \(A_5\)-invariant order-six conference orientations are then intrinsic, and the literal outer involution sends a normalized chordal generator to its oriented conference generator by the exact linear formula

\[
c=8^{-1}(q_\Pi-1)h.
\]

The same recovered six-set canonically distinguishes the rank-five augmentation lattice from the rank-six \(D\)-type weight lattice while identifying their four-dimensional binary heart. Uniformly for every symmetric conference matrix of order \(n\equiv2\pmod4\), \((I+B)/2\) forces and stabilizes exactly \(D_n^\vee=\mathbf Z^n+\mathbf Z(\mathbf1/2)\); its mod-two coefficient algebra is split for \(n\equiv2\pmod8\) and is \(\mathbf F_4\) for \(n\equiv6\pmod8\). At \(n=6\), the residue is the unique nonsplit three-dimensional \(\mathbf F_4A_5\)-module with natural two-dimensional heart, and conference reversal and the outer normalizer both act on its commutant field by Frobenius.

## Earliest unsupported implication

- Locator: none in packet scope; the first potentially vulnerable chain is Lemma 3.3 through Proposition 4.1.
- Printed claim: the recovered six-set determines the unordered opposite conference pair, and one coefficient comparison gives \((q_\Pi-1)h=8c_B\).
- Why it follows / does not follow: first-row switching normalization makes the negative edges on the remaining five labels a \(2\)-regular graph, hence a pentagon. This gives the order-six switching class without a census; the \(A_5\)-invariant pair and its exchange by the nontrivial normalizer coset follow on the fixed transitive six-set. Since \(q_\Pi\) is a linear involution and \(c_B\) spans its one-dimensional anti-invariant line, \(q_\Pi h-h\) is a scalar multiple of \(c_B\). The printed normalized coefficient values are \(9-1=8\), while \([x_0^2x_1]c_B=1\), so the scalar is exactly \(8\), not merely a projective or square-class value.
- Smallest counterexample or missing lemma: none. The only implicit step is the standard observation that the transitive degree-six \(A_5\)-action is the coset action on its conjugate \(D_{10}\) subgroups; it is local and already encoded by the stabilizer quotient in Proposition 3.2.
- Downstream scope: the selected-line bridge, its orientation sign, and the lattice/Frobenius comparison all remain valid.

## Controlling findings

1. [GO] [Lemma 3.3] The uniqueness claim has the correct scope: it is the intrinsic unordered pair of \(A_5\)-invariant opposite switching classes on the recovered six-set, not uniqueness of a labeled matrix. Switching, relabeling, negation, and orientation reversal remain distinct. The pentagon argument is structural, and the exact cited pages of Bussemaker--Mathon--Seidel corroborate the classical order-six boundary.

2. [GO] [Proposition 4.1 and Corollary 4.3] The scalar \(8\) is rigidified linearly. The conference pair is constructed before the coefficient comparison; the anti-invariant line is already known; and the single displayed coefficient gives \(9-1=8\). Thus no finite enumeration substitutes for the outer-difference proof, and the selected line is correctly retained to avoid the residual \(uq\)-deck ambiguity.

3. [GO] [Theorem 8.1] The full uniform \(D_n^\vee\) saturation is proved without an order-six census or Smith form. After switching the first row positive, every column of \(I+B\) is odd, so \(\phi_B\mathbf Z^n\subseteq\mathbf Z^n+\mathbf Zh\), while \(\phi_Be_0=h\) forces every stable over-lattice containing \(\mathbf Z^n\) to contain \(h\). Orthogonality gives row sums \(n-1,1,\ldots,1\), hence \(\phi_Bh=h+((n-2)/4)e_0\), proving preservation. A diagonal switch preserves the same lattice because it sends \(h\) to \(h\) modulo \(\mathbf Z^n\), and conjugates the operator accordingly.

4. [GO] [Theorem 8.1] The mod-eight coefficient algebra is not inferred from dimension alone. The identity \(\phi_B^2-\phi_B=((n-2)/4)I\) gives \(t^2+t+1\), hence \(\mathbf F_4\), for \(n\equiv6\pmod8\), and \(t(t+1)\), hence \(\mathbf F_2\times\mathbf F_2\), for \(n\equiv2\pmod8\). In the split case the displayed relations \(\bar e_0=\sum_{i>0}\bar e_i\) and \(\bar\phi_B(\bar e_0)=\bar h\) show that \(\bar\phi_B\) is neither \(0\) nor \(1\), so the product algebra acts faithfully. (The dossier questions saying \(0/4\pmod8\) are packet-only slips; the manuscript's \(2/6\pmod8\) residues are correct.)

5. [GO] [Proposition 7.1 and Propositions 9.1--9.2, Theorem 9.3] The common binary heart is obtained canonically from the permutation lattice, not by identifying the rank-five and rank-six lattices. At order six, normalization before reduction supplies an actual \(\mathbf F_4\)-action. The printed fixed-vector and commutator calculations prove nonsplitting and identify the natural heart; the triangle-presentation cocycle calculation gives a one-dimensional \(\mathbf F_4\) extension space and endpoint scalars make its three nonzero classes one middle-module isomorphism class. Finally \(B\mapsto-B\) sends \(\phi\mapsto1-\phi\), so on the primitive scalars it is \(\omega\mapsto\omega^2\); the outer normalizer exchanges the same two oriented conference classes and therefore induces the same Frobenius-semilinear operation.

## Human-proof deletion test

Deleting Section 11's checker, JSON, hashes, replay command, and every appeal to computational verification leaves the packet's proofs complete. Lemma 3.3 is a five-cycle normalization argument; Proposition 4.1 uses a printed matrix and one explicit coefficient identity; Proposition 7.1 is a canonical reduction calculation; Theorem 8.1 is a parity, row-sum, and polynomial-identity proof valid for all \(n\equiv2\pmod4\); and Section 9 prints the fixed-space, commutator, cocycle, and Frobenius arguments. No packet claim requires a script or unpublished certificate.

## Attribution and novelty boundary

The classical boundary is accurately drawn at the depth checked. Goethals--Seidel supplies the standard conference and switching framework. Bussemaker--Mathon--Seidel supplies the classical order-six conference two-graph and its automorphism data. Haemers--Parsaei Majd concerns symmetric conference spectra, switching, small orders, and sign-symmetry, not the integral root--weight saturation. Chapman constructs quadratic-order module structures from skew conference matrices on \(D_n^+\), not the symmetric \((I+B)/2\) action on \(D_n^\vee\) proved here. These sources therefore support the manuscript's claim that the ingredients have nearby classical forms while the marked outer-difference composition and the symmetric uniform \(D_n^\vee\) saturation are the paper's asserted contributions. This was a source-boundary check, not an exhaustive priority search, so it does not license a stronger absence-of-predecessor claim.

## Minimal repair, if verdict is not GO

Not applicable.
