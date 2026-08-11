# Paper V alignment import: C/L cold review

**Date:** 2026-08-11  
**Verdict:** **MINOR**  
**Scope:** Lemma 3.4, *Six-point alignment recognition*, its dependence on Lemma 3.3, and the surrounding attribution boundary.

## Frozen surface

- PDF: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`
- verified SHA-256: `4a53b2c415f38bf401216be7492b78aab9255715a55706073662cadea36ee92c`
- import commit: `5b11e0b9`
- rendered location: page 9 of 21

I reviewed the frozen PDF and the imported source directly. I did not consult prior reviews, review scripts, or certificates.

## Verdict

The lemma is mathematically correct. Its signs, the factors (4) and (16), and the final equivalence with the conference equation all check. The relation to the preceding intrinsic (A_5)-conference pair is also correct, and the attribution paragraph keeps the new direct six-point count separate from the cited general results.

The only requested repair is local self-containment. The statement says only “a symmetric sign matrix (S),” although the proof uses the Seidel convention

\[
S_{xx}=0,\qquad S_{xy}=S_{yx}\in\{\pm1\}\quad(x\ne y).
\]

It also does not say explicitly that the identity is invariant under switching and complement, even though the concluding reference to the unordered opposite pair uses exactly those facts. This is a clarity omission, not a gap in the argument.

A sufficient repair is to replace the first sentence by

> Let \(\Delta\) be a two-graph on a six-set \(\Omega\), represented by a symmetric Seidel sign matrix \(S\), so \(S_{xx}=0\) and \(S_{xy}\in\{\pm1\}\) for \(x\ne y\).

and add after the displayed defect identity:

> Switching leaves \(\sigma\) and \(m\) unchanged, while complementation negates both; hence the identity and the empty-alignment condition are invariant under switching and complement.

## Line-by-line algebra audit

1. For a pair (p=\{x,y\}),
   \[
   S_{xy}(S^2)_{xy}
   =S_{xy}\sum_z S_{xz}S_{zy}
   =\sum_{z\notin\{x,y\}}S_{xy}S_{yz}S_{zx}
   =m(xy).
   \]
   The omitted (z=x,y) terms vanish because the Seidel diagonal is zero. The sign is positive.

2. For (t=\{x,y,z\}) and (w\notin t), the product
   \(alpha\beta\gamma\) is the product of the four triangle signs of the four-set (t\cup\{w\}). Every edge occurs twice, so the product is (1).

3. With \(\alpha\beta\gamma=1\), one has \(\alpha\beta=\gamma\), \(\alpha\gamma=\beta\), and \(\beta\gamma=\alpha\). Therefore
   \[
   \frac{(1+\alpha)(1+\beta)(1+\gamma)}8
   =\frac{1+\alpha+\beta+\gamma}{4}.
   \]
   This equals one precisely when all four triangle signs agree, and zero in the other three sign patterns. The factor (1/4) is correct.

4. There are exactly three choices of (w\) outside a triple because \(|\Omega|=6\). In
   \(\sigma(t)\sum_{p\in\binom t2}m(p)\), each of the three pairs contributes one term from the third vertex of (t), giving the constant (3); the remaining nine terms are exactly the three \(\alpha+\beta+\gamma\) sums. Hence
   \[
   \lambda_3(t)=\frac{\sigma(t)}4\sum_{p\in\binom t2}m(p).
   \]

5. Summing over triples counts each aligned four-set four times. After exchanging sums, a fixed pair (p=\{x,y\}) contributes
   \[
   m(p)\sum_{t\supset p}\sigma(t)=m(p)^2.
   \]
   Thus
   \[
   4|A(\Delta)|=\frac14\sum_p m(p)^2,
   \qquad
   16|A(\Delta)|=\sum_p m(p)^2.
   \]
   Both the intermediate factor (4) and the final factor (16) are correct.

6. The defects (m(p)) are integers, so the sum of their squares vanishes exactly when every defect vanishes. Since each diagonal entry of (S^2) is the sum of five off-diagonal squares, it equals (5). The off-diagonal entries vanish exactly when all defects vanish, because (S_{xy}=\pm1). Therefore
   \[
   A(\Delta)=\varnothing\quad\Longleftrightarrow\quad S^2=5I.
   \]

## Switching, complement, and the preceding (A_5) pair

For a diagonal sign matrix (D), switching sends (S) to (DSD). Every vertex sign occurs twice in a triangle product, so \(\sigma\) is unchanged. Equivalently,
\[
(DSD)_{xy}\bigl((DSD)^2\bigr)_{xy}
=D_{xx}D_{yy}S_{xy}\,D_{xx}D_{yy}(S^2)_{xy}
=m(xy).
\]
Thus the defect identity is genuinely an identity of the two-graph, independent of its Seidel representative.

Complement sends (S) to (-S). It negates every triangle sign and every (m(xy)), preserves the property that the four triangle signs on a four-set are constant, and preserves both \(\sum m^2\) and (S^2). Hence the empty-alignment locus is closed under the opposite-class involution used in Lemma 3.3.

The preceding pentagon normalization gives twelve labeled order-six conference switching classes. For the recovered subgroup (G\cong A_5\le S_6), an oriented conference class has stabilizer (G), and
\[
N_{S_6}(G)/G\cong C_2.
\]
Consequently exactly two labeled conference two-graphs are fixed by this recovered (G); they are complementary/opposite. Lemma 3.4 identifies the whole empty-alignment locus with the conference locus, so its final sentence correctly recovers precisely the unordered pair already constructed in Lemma 3.3. It does not strengthen the marking: the alignment test recognizes the twelve-class locus, while the recovered (A_5)-action selects the opposite pair and the earlier marked construction selects the needed invariant pair data.

## Attribution boundary

The boundary is appropriately stated.

- Gillespie's Section 4.1 treats coherent and incoherent four-set counts for regular two-graphs. The present lemma applies to an arbitrary two-graph on six points and derives a pair-defect square identity directly, so the manuscript does not pass off Gillespie's regular counting result as this lemma.
- Iranmanesh--Askari Farsangi, Theorem 2.4, gives the general power-sum lower bound with equality exactly for conference Seidel matrices; at exponent four this is the cited fourth-power equality criterion. The citation description is accurate.
- The order-six conference switching class and pentagon representative remain attributed to the classical sources in Lemma 3.3. The new paragraph claims only the direct order-six defect count “used here” and ends with an explicit no-priority statement for the composition. There is no visible priority overclaim.

## Rendered check

Page 9 renders the entire lemma and proof legibly on one page. The nested binomial notation, (z\notin\{x,y\}), the (16\)-identity, the two (1/4) factors, and (S^2=5I) are visually intact. There is no bad break or collision at the transition from Lemma 3.3 or into the following paragraph.

## Mystery ledger

The closeout (ej+tt) pass found no unresolved mathematical mystery in this import. The only live item is the explicit Seidel/invariance sentence above; it has a complete local repair and no successor research gate.
