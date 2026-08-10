# C900 sealed citation final gate

**Date:** 2026-08-09  
**Manuscript inspected:** `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` (current working copy)  
**Verdict:** **GO**

This was an independent, sealed citation check. I did not inspect any C900 dossier, review, synthesis, proof audit, handoff, trust manifest, Git diff, or Git history.

## 1. Ball's index equations

The citation `Ball~\cite[p.~34]{Ball1997}` at the proposition titled “Classical first and second index equations” is correctly placed.

Ball defines (c_i) as the number of points outside a complete (k)-arc that lie on exactly (i) bisecants. On the final published page, p. 34, his displayed equations include

\[
 \sum_i i c_i=\frac{k(k-1)(q-1)}2,
 \qquad
 \sum_i \binom{i}{2}c_i=
 \frac{k(k-1)(k-2)(k-3)}8.
\]

With the manuscript's (r(x)) equal to the number of secants through an external point, grouping external points by (r(x)=i) gives exactly

\[
 \sum_{x\notin A}r(x)=\binom{k}{2}(q-1),
 \qquad
 \sum_{x\notin A}\binom{r(x)}2=3\binom{k}{4}.
\]

Thus the page is right and the conventions are compatible. Ball states the equations for complete arcs, whereas the manuscript proves them for every arc; this is not an overreach in the citation because the manuscript supplies its own complete double-counting proof and cites Ball only for classical provenance.

Source checked: Simeon Ball, “On small complete arcs in a finite plane,” *Discrete Mathematics* 174 (1997), 29–34, DOI `10.1016/S0012-365X(96)00315-9`; author-hosted full text at `https://web.mat.upc.edu/people/simeon.michael.ball/complete.pdf` (downloaded bytes SHA-256 `b59d6ec7b7bb5e50a807cdd580ae84f6eacd2ec3b22e8329c549962a82eb26d7`). The journal pagination and DOI agree with the manuscript bibliography.

## 2. Ball Theorem 3.1 boundary

The separate sentence says: “For ordinary complete arcs, the leading \(\sqrt{2q}\) scale is classical; compare Ball~\cite[Theorem~3.1]{Ball1997}. The theorem below obtains the displayed additive refinement for conic-relative completeness from the prescribed-hole correction.”

Ball's Theorem 3.1 is indeed about an ordinary complete (k)-arc and gives a lower bound with leading term \(\sqrt{2q}\). The manuscript expressly limits the comparison to that classical scale, then attributes the conic-relative refinement to its own prescribed-hole argument. It does not use Ball as support for conic-relative completeness.

## 3. Mathon classification and attribution boundary

The primary citation is bibliographically correct and directly on topic:

> R. Mathon, “The partial geometries \(\operatorname{pg}(5,7,3)\),” *Congressus Numerantium* 31 (1981), 129–139.

Independent bibliographic corroboration gives the same author, title, volume, year, and page span. Later literature consistently attributes to this paper the classification into exactly two inequivalent geometries (equivalently \(\operatorname{pg}(4,6,3)\) in the common (s,t,\alpha) convention). In particular, Reichard–Woldar explicitly say that Mathon obtained the two geometries and proved they are the only ones; Gezek–Tonchev likewise state that exactly two such partial geometries exist up to isomorphism and attribute the classification to Mathon.

The manuscript keeps all three logical roles separate:

1. Mathon 1981 supplies the external completeness statement: there are precisely two abstract classes.
2. Reichard–Woldar report that result and give later constructions of representatives, together with automorphism-group and distinction results.
3. The manuscript's appendix reconstructs/checks representatives but expressly says it is not used to prove completeness; the subsequent determinant/Singular argument is identified as the paper's own rank-three projective-realization test.

The convention switch is also stated explicitly: Reichard–Woldar's line-size/point-degree notation \(\operatorname{pg}(5,7,3)\) corresponds to the common \(\operatorname{pg}(4,6,3)\) notation. No construction, classification, or realization claim is conflated.

I did not locate an openly accessible scan of Mathon's 1981 article itself. The conclusion here is therefore the requested bibliographic and attribution-boundary check, supported by the exact primary citation and independent later full-text accounts, not a fresh re-execution of Mathon's classification.

## Mystery ledger

The final extra-value/expert-skeptic pass found no genuine mathematical or citation mystery. The sole evidence gap is access to Mathon's original full text; it does not block this bibliographic gate because the primary reference is exact, its title is claim-specific, and multiple independent later sources explicitly identify that paper as the two-class completeness proof. A theorem-page citation to Mathon would require consulting a scan, but the manuscript makes no theorem- or page-level assertion about the internal location of Mathon's result.

## Final gate

No actionable citation, convention, attribution, or evidence-boundary defect remains in the three requested areas. **GO.**
