# C909 — bounded novelty audit of the Veronese inevitability mechanism

Date: 2026-08-11
Lane: clebsch
Status: bounded primary-source/concept audit; no manuscript, PDF, mirror,
Lean, or commit edit

## Opening coverage and verdict

Two named sources are used below: one was read at **full-text** depth and one
at **partial** depth. The search was a bounded primary-literature search over
ranked title/abstract/snippet results, not an enumerated database or citation
graph. It found the tropical quadratic predecessor, but no exact source for
the signed integral DVR rank-one hull/cokernel, its dyadic divided-square
application, or the proposed higher-degree cellular Rees defect.

The safe priority position is layered:

* The lattice-point description of \(2\Delta\), the tropical PSD inequalities,
  the trivial subdivision, and the tropical rank-one hull are known. Yu is an
  exact predecessor for the tropical part; the midpoint observation itself is
  elementary.
* The explicit integral statement over a DVR is a different assertion. Under
  the C909 matrix-of-ideals hypotheses, the signed \(O\)-linear rank-one span
  has an exact coefficient cokernel, valid also in residue characteristic two.
  No exact predecessor for that formulation was located in this bounded
  search.
* Rees/Veronese and divided-power language is standard. The degree-\(d\ge3\)
  cellular multinomial defect in the mechanism note is a prediction, not a
  located theorem. The full package is therefore best described as a
  **plausibly new integral-to-geometric synthesis under bounded coverage**,
  not as a new tropical PSD mechanism or a globally established first.

## A. What is preempted

The points of \(2\Delta_{n-1}\) are \(2e_i\) and \(e_i+e_j\): vertices and
edge midpoints. This is elementary simplex combinatorics, not a priority
claim. The identity

\[
(u+v)(u+v)^t-uu^t-vv^t=uv^t+vu^t
\]

is likewise elementary polarization.

Yu proves the tropical counterpart: a symmetric tropical matrix is tropical
positive semidefinite exactly when

\[
x_{ii}+x_{jj}\le 2x_{ij},
\]

equivalently its \(2\Delta\) height function gives the trivial subdivision;
she also identifies the tropical PSD cone with the tropical convex hull of
symmetric tropical rank-one matrices. Thus the following wording is unsafe:
“the midpoint geometry,” “the pairwise tropical criterion,” or “the tropical
rank-one hull” is new. The mechanism note should instead say that it uses this
known polyhedral shadow to organize an integral lift.

Cartwright–Chan is an adjacent predecessor for inequality-controlled tropical
rank notions, but does not supply an additive DVR lattice theorem. It should
not be cited as a predecessor for the C909 cokernel or the graph application.

## B. The exact integral layer is not Yu's theorem

Let \(O\) be a DVR with uniformizer \(\pi\), and, in the local notation of
the C909 rank-one lemma, let

\[
\mathcal N(a,e)=\{A=A^t:A_{ii}\in\pi^{a_i}O,
                         \,A_{ij}\in\pi^{e_{ij}}O\},
\qquad
h_{ij}=\left\lceil\frac{a_i+a_j}{2}\right\rceil.
\]

Let \(\mathcal R\) be the \(O\)-span of all symmetric rank-one matrices
whose entries lie in the prescribed slots. The local calculation gives,
with the same slot and signed-vector hypotheses as the C909 theorem,

\[
\mathcal R=\mathcal N(a,e)
\quad\Longleftrightarrow\quad
e_{ij}\ge h_{ij}\quad\text{for every }i<j,
\]

and the sharper off-diagonal projection/cokernel formula

\[
\mathcal R_{ij}=\pi^{\max(e_{ij},h_{ij})}O,
\qquad
\mathcal N(a,e)/\mathcal R
 \cong\bigoplus_{i<j,\ e_{ij}<h_{ij}}
       O/\pi^{h_{ij}-e_{ij}}O.
\tag{C909.V.1}
\]

The proof uses the two diagonal rank-one corrections to the rank-one form
of \(\pi^t(\pi^r e_i+\pi^s e_j)\); no division by two is made. Consequently
the criterion and the quotient include the dyadic case. This is an
integral, signed \(O\)-linear statement, whereas Yu's hull is tropical
min-plus convexity over valuations. Tropicalization forgets signs, unit
coefficients, cancellation, and the finite torsion in (C909.V.1).

The exact quotient should be called a **rank-one-hull** or
**tropical-lift defect**. It is not automatically a divided-power or
minimal-class defect: failure of rank-one generation only proves a lattice
cokernel until a geometric realization identifies that cokernel with the
cohomological product obstruction.

When the matrix-of-ideals lattice comes from actual square-zero rank-one
divisor classes, the same integral lift gives the dyadic divided-square
consequence: every divisor class is a sum of square-zero classes, so its
divided powers are represented by ordinary products. This is a conditional
geometric application of (C909.V.1), not a statement in Yu.

## C. What is and is not claimed in higher degree

The words Rees algebra, Veronese, divided powers, polarization, and
multinomial coefficient belong to standard algebraic frameworks. The formal
identity

\[
(x_1+\cdots+x_r)^d
 =\sum_{m_1+\cdots+m_r=d}
   \binom{d}{m_1,\ldots,m_r}x_1^{m_1}\cdots x_r^{m_r}
\]

does not by itself establish a new theorem. For \(d\ge3\), lattice points of
\(d\Delta\) can have support on at least three coordinates, and polarization
can carry multinomial content. It is therefore reasonable to *predict* a
cellular compatibility object for

\[
\Gamma^d_{\mathrm{Rees}}(M)/V^d_{\mathrm{Rees}}(M),
\]

with face incidences and prime support controlled in part by multinomial
coefficients. But the mechanism note does not yet construct that complex,
prove its exactness, or identify its \(p\)-primary homology with C908's
carry/ghost complex. In particular, “the higher-degree obstruction is exactly
multinomial cellular homology” is not ready as a theorem or novelty sentence.

The bounded searches returned standard adjacent Rees/Veronese and divided-
power terminology, but no promoted full-text primary source stating this
specific filtered symmetric-lattice defect, nor the proposed bridge to the
finite-etale graph NS problem. This licenses only the wording “no exact
predecessor was located in the bounded search,” not “no one has considered
the mechanism.”

## Exact predecessor map

| Layer | Status | Safe attribution |
|---|---|---|
| \(2\Delta\) vertices/edge midpoints | elementary | no novelty claim |
| Tropical PSD inequality and trivial subdivision | known | Yu, Theorems 1–2 |
| Tropical rank-one hull/Gram interpretation | known | Yu, Theorem 4 and Corollary 6 |
| Adjacent tropical symmetric-rank notions | known | Cartwright–Chan, §3 and Theorem 6 |
| Signed integral DVR iff and formula (C909.V.1) | not located in bounded search | C909 local theorem; do not call tropical novelty |
| Dyadic square-zero/divided-power graph consequence | not located in bounded search | C909 geometric application, conditional on graph/descent lemmas |
| \(d\ge3\) Rees/Veronese cellular multinomial complex | prediction | open research target, not a result |

The conceptual mechanism as a whole therefore has no exact predecessor in the
two primary sources read and in the bounded adjacent searches, but its
individual conceptual ingredients are not new. The defensible novelty is the
explicit arithmetic bridge and its graph-Néron–Severi application, subject to
the hypotheses already recorded in the C909 notes.

## Source records

### Josephine Yu, *Tropicalizing the positive semidefinite cone*

* Read depth: **full text** — cached arXiv PDF, version v1, with complete
  pdftotext extraction; relied on Theorems 1–2, Lemma 3, Theorem 4, and
  Corollary 6.
* Access/version: arXiv:1309.6011v1 PDF fetched from the arXiv PDF endpoint;
  landing page: https://arxiv.org/abs/1309.6011.
* Cache key: arXiv:1309.6011.
* SHA-256:
  ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6.

Yu works with real Puiseux valuations and tropical min-plus convexity. The
paper does not state an \(O\)-linear rank-one lattice span, the finite DVR
cokernel, dyadic lifting, divided-power saturation, or an abelian-variety
graph application. The last sentence is an audit inference from the cited
scope, not a quotation.

### Dustin Cartwright and Melody Chan, *Three notions of tropical rank for
symmetric matrices*

* Read depth: **partial** — cached arXiv PDF, version v1, and extracted text;
  read the Introduction and §3, relying on the symmetric Barvinok-rank
  definitions, Proposition 3, and Theorem 6.
* Access/version: arXiv:0912.1411v1 PDF fetched from the arXiv PDF endpoint;
  landing page: https://arxiv.org/abs/0912.1411.
* Cache key: arXiv:0912.1411.
* SHA-256:
  65a2973ccaef502abf7381a9dfa85af3bd0aa502d1e5b1aa148a8a7a453200a5.

This is adjacent tropical rank literature, not a source for additive DVR
matrix-of-ideals, Rees, divided-power, or graph-NS assertions.

## Search protocol and gaps

Exact queries run in the bounded search included:

* “Veronese” “divided power” lattice
* “Rees algebra” “Veronese” semigroup normality
* “multinomial” “divided powers” symmetric algebra integral
* “cellular resolution” Veronese semigroup lattice points simplex
* “divided power algebra” “Veronese”
* “multinomial coefficients” “divided powers” polynomial algebra
* “2 Delta” tropical positive semidefinite
* symmetric matrix lattice over DVR generated by rank one forms
* valuation matrix \(2e_{ij}\ge a_i+a_j\) rank one
* rank-one generated symmetric lattice DVR

Results were screened over title and abstract/snippet fields; no finite
database set was enumerated, and no citation graph was run. Search hits for
general divided-power, Rees, Veronese, toric-normality, and cellular-resolution
frameworks were not promoted as exact predecessors without a load-bearing
full text. MathSciNet is **NOT COVERED** (institutional authentication
unavailable); zbMATH Open is **NOT systematically covered**; Google Scholar
is **NOT COVERED** (automated access blocked); OpenAlex, Crossref, and
Semantic Scholar citation graphs were **NOT RUN**. No exhaustive search of
quadratic-lattice or divided-power monographs was attempted.

## Safe wording for the owning ledger

> Yu's tropical PSD/trivial-subdivision and tropical rank-one-hull results
> provide the known polyhedral shadow of the quadratic argument. We give an
> explicit signed integral DVR lifting criterion and coefficient cokernel,
> including residue characteristic two, and apply it to the compatible
> finite-etale graph Néron–Severi lattice. Under the bounded search recorded
> here, no exact predecessor for this arithmetic-to-geometric package was
> located. The proposed \(d\ge3\) cellular Rees/Veronese multinomial defect is
> a conjectural extension, not part of the established theorem.

Do not write “the tropical rank-one mechanism is new,” “this is the first
Veronese divided-power obstruction,” or “multinomial cellular homology is
proved.” If the higher-degree target later becomes a theorem, it needs a new
literature pass at that time.

## Audit checklist

* Novelty verdict lives in this audit/owning ledger only; manuscript and
  summaries were not edited.
* Yu's tropical claims are credited; the integral and geometric claims are
  kept separate from them.
* The higher-degree language is explicitly marked predictive.
* Coverage gaps and the absence of citation-graph enumeration are recorded.
