# Paper V alignment-import blind review

**Artifact reviewed:** `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`  
**SHA-256:** `4a53b2c415f38bf401216be7492b78aab9255715a55706073662cadea36ee92c`  
**Identified commit:** `5b11e0b923ad9501950b09b9e3895a670b775414`  
**Review mode:** independent whole-PDF journal-referee read. I did not consult prior reviews, repair notes, scripts, certificates, or manuscript sources.

## Recommendation

**MINOR.** The six-point alignment-recognition lemma is correct, naturally scoped to the recovered six-set, and placed at the right mathematical transition. It improves the paper's intrinsic-recognition story. It does not yet improve the formal theorem spine as much as the abstract and conclusion suggest, because Theorem 1.2 neither states it nor uses it to construct the equivalence. One small integration edit would turn it from a strong diagnostic aside into an explicit output of the main classification.

## Main theorem

On the fixed neutral quadratic augmentation carrier of the six Sylow-5 subgroups of $A_5$ over $\mathbf F_{11}$, normalized metric chordal shadows are naturally equivalent to expanded metric carriers and to oriented order-six conference packages equipped with a selected compatible chordal line. The singular quartic recovers the split twelve-point $A_5/C_5$-orbit and its quotient six-set $A_5/D_{10}$; outer difference recovers the oriented conference cubic. Forgetting the selected chordal line leaves exactly a residual $C_2$-quotient rather than an equivalence.

The integral companion theorem says that the recovered six-set distinguishes the rank-five augmentation lattice and rank-six $D$-type weight lattice while identifying their common four-dimensional binary heart. For symmetric conference order $n\equiv2\pmod4$, $(I+B)/2$ minimally stabilizes $D_n^\vee$, with the stated mod-eight split/inert residue. At order six, the residue is the unique nonsplit extension of a trivial $\mathbf F_4$-line by the natural $\mathbf F_4A_5$-module, and conference reversal/outer reversal acts as Frobenius.

## Earliest unsupported implication

The earliest unsupported implication as ordered in the manuscript is in Proposition 2.1 (page 6): it concludes that the Paper-II projection is a **normalized** metric chordal shadow. Definition 1.1 makes normalization mean that

\[
(q_\Pi-1)h=\alpha c_B,\qquad \alpha^2=8^2.
\]

The proof of Proposition 2.1 establishes the chordal placement, fixes the Paper-II scalar, and computes $U(h_M)=8H$, where $H$ is the chordal Hankel cubic. It does not yet compute the coefficient of the conference outer difference. That computation first appears in Proposition 4.1 (page 10). Proposition 4.1 in turn cites Proposition 2.1 for the line identification and scalar choice. The mathematics is not circular if Proposition 2.1 is weakened to “a metric chordal shadow with the displayed fixed scalar,” with normalization then concluded in Proposition 4.1. As written, however, the support arrives four pages after the assertion and the displayed $8H$ can be mistaken for the required $8c_B$.

This is a presentation-order defect, not evidence that the claimed normalization is false.

## The imported six-point lemma

Lemma 3.4 is correct. For a triple $t=\{x,y,z\}$ and $w\notin t$, its three comparison signs $\alpha,\beta,\gamma$ satisfy $\alpha\beta\gamma=1$. Hence the aligned-four-set indicator is

\[
\frac{(1+\alpha)(1+\beta)(1+\gamma)}8
=\frac{1+\alpha+\beta+\gamma}{4}.
\]

Summing first over $w$, then over triples, counts each aligned four-set four times and gives

\[
16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2.
\]

Since this is an integer sum of squares, emptiness is equivalent to every pair defect vanishing; with zero diagonal and off-diagonal signs, this is exactly $S^2=5I$. The final $A_5$-fixed-pair statement then follows from Lemma 3.3.

### Scope and placement

The scope is substantively right: it is a six-point statement, and it claims only that the recovered $A_5$-fixed conference pair is the $A_5$-fixed part of the empty-alignment locus. It does not pretend that alignment recovers the selected chordal line or the full marking. Its placement immediately after recovery of the six-set and conference pair, and before outer difference, is the best place for it.

Two local wording fixes would make the scope airtight:

1. Say explicitly that $S$ is a Seidel representative with zero diagonal and off-diagonal entries in $\{\pm1\}$. “Symmetric sign matrix” alone can be read as having signed diagonal entries, while the last step uses $(S^2)_{xx}=5$.
2. Say that the defect identity and sum of squares are evaluated in $\mathbf Z$. The surrounding carrier is over $\mathbf F_{11}$, where “sum of squares vanishes” would not by itself imply termwise vanishing.

## Does the import improve or dilute the spine?

It improves the conceptual spine but slightly dilutes the rhetorical spine in the present version.

The improvement is real: before the import, the conference pair is recovered by the classical uniqueness of the order-six switching class. Lemma 3.4 adds an intrinsic test in the paper's own sparse-shadow language: the conference locus is exactly what four-point alignment cannot see. That directly supports the series theme and clarifies why a six-point conference shadow is the correct companion object.

The dilution is only architectural. The abstract gives the result its own paragraph, the introduction calls it a “second intrinsic description,” and the conclusion makes it one of the four return steps, but Theorem 1.2 omits it and Proposition 5.2 does not use it. A reader following theorem statements alone can therefore regard the lemma as an attractive side result. The clean repair is to add it as an explicit output under Theorem 1.2, for example between current parts (i) and (ii): the recovered conference pair is precisely the pair of $A_5$-fixed alignment-invisible two-graphs. No proof reorganization is needed.

## Other referee comments

- Lemma 4.2's final sentence, “the final assertion follows after base change,” is too compressed for a result quantified over every extension $K/k$. The preceding argument begins with $f\in\Pi_k$. State that the same projective-representation/Hom-space argument is geometric (over an algebraic closure), or formulate the chordal-member subscheme first and then base-change the proved equality of schemes. This is a clarification, not a contrary example.
- The rendered lemma page is clean and readable, and the full 21-page PDF has no visible layout failure. The imported lemma does not create a float, heading, or page-break problem.
- The paper is unusually careful about retained versus reconstructed markings. The new lemma respects that discipline: it recognizes the unmarked conference locus and does not claim the selected-line data.

## Required changes for GO

1. Move the normalization conclusion from Proposition 2.1 to Proposition 4.1, or add an explicit forward dependency and remove any appearance that $U(h_M)=8H$ proves the conference coefficient.
2. Add the alignment-recognition output to Theorem 1.2, or reduce its prominence in the abstract and conclusion. Adding it to the theorem is the stronger edit.
3. In Lemma 3.4, specify the Seidel diagonal/off-diagonal convention and that the sum-of-squares argument is integral.
4. Expand the geometric/base-change justification in Lemma 4.2 by one or two sentences.

With those changes, I would recommend **GO**.

## Vibe check

Good and close: the import adds a memorable intrinsic characterization without introducing a mathematical gap; the remaining issues are theorem integration and proof-order hygiene.
