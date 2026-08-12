# C909 — tropical rank-one judo: what the DVR theorem can honestly claim

Date: 2026-08-11  
Lane: clebsch  
Status: bounded literature/concept audit; no manuscript, PDF, mirror, Lean, or
commit edit

## Opening coverage and verdict

One source was read at full-text depth and one at partial depth. The focused
search found an exact tropical analogue of the valuation inequality and
rank-one hull, but no source stating the integral additive DVR lattice
criterion, its signed rank-one lift, or its finite-etale graph-Néron--Severi
application.

The correct priority-judo is therefore:

* the inequality \(2e_{ij}\ge a_i+a_j\) and the tropical rank-one cone are
  **preempted as tropical geometry**;
* the DVR iff is an elementary integral lifting lemma, not a new tropical
  theorem;
* the exact quotient of a matrix-of-ideals lattice by its rank-one span is a
  stronger local formulation and appears not to be stated in the focused
  sources; and
* applying that lift to arbitrary-depth finite-etale graph NS lattices, then
  obtaining all-degree cohomological PD saturation, is the strongest plausible
  C909 application. It is not a claim of new tropical PSD theory.

## The five judo moves

### 1. Integral lift of the tropical PSD cone — strongest and ready

For
\[
\mathcal N(a,e)=
\{A=A^t:A_{ii}\in\pi^{a_i}O,\ A_{ij}\in\pi^{e_{ij}}O\},
\]
the tropical condition
\[
2e_{ij}\ge a_i+a_j
\tag{C909.1}
\]
is exactly the condition that signed admissible rank-one matrices span the
entire \(O\)-lattice \(\mathcal N(a,e)\). The lift is explicit:
choose \(t,r,s\) with
\[
t+r+s=e_{ij},\qquad t+2r\ge a_i,\qquad t+2s\ge a_j,
\]
then subtract the two diagonal rank-one forms from
\(\pi^t(\pi^re_i+\pi^se_j)(\pi^re_i+\pi^se_j)^t\). No division by two is
used, so the statement is valid over dyadic DVRs.

Yu’s tropical result supplies the valuation cone and tropical rank-one hull;
the signed \(O\)-linear lift, including unit coefficients and negative
fractional-vector valuations, is the extra integral statement. The local
lemma itself is short enough that its novelty should not be overstated.

### 2. Exact rank-one-hull defect module — strongest conceptual upgrade

Let \(h_{ij}=\lceil(a_i+a_j)/2\rceil\), and let \(\mathcal R\) be the
admissible rank-one span inside \(\mathcal N(a,e)\). The same proof gives
the stronger identity
\[
\mathcal R_{ij}=\pi^{\max(e_{ij},h_{ij})}O
\quad\text{in each off-diagonal slot},
\]
and therefore
\[
\mathcal N(a,e)/\mathcal R
\cong
\bigoplus_{i<j,\ e_{ij}<h_{ij}}
 O/\pi^{\,h_{ij}-e_{ij}}O.
\tag{C909.2}
\]
This is an exact coefficient-lattice defect, not merely an iff criterion.
It is canonical for the chosen filtered spectral packet and invariant under
rescaling a spectral line
\[
a_i\mapsto a_i+2r_i,\qquad
e_{ij}\mapsto e_{ij}+r_i+r_j.
\]
It should be called a rank-one-hull or tropical-lift defect, not automatically
a minimal-class or divided-power defect: failure of rank-one generation does
not by itself prove that a distinguished divided power is nonzero in the
ordinary product quotient.

### 3. Rees/filtered spectral-packet theorem — strongest canonical formulation,
but needs packaging

Replace a split eigenbasis by the filtered finite-etale packet carrying the
line-depth filtration. The matrix-of-ideals data are the degree-two part of a
Rees lattice, and (C909.1) is invariant under filtered-line rescaling and
Galois permutation. The resulting theorem can be stated without naming
individual eigenvectors:

> A filtered finite-etale spectral packet has full rank-one NS saturation
> exactly when its pairwise coefficient ideals satisfy the integral
> Cauchy--Schwarz inclusions \(I_{ij}^2\subset I_{ii}I_{jj}\).

For the block-respecting graph presentations now in scope, the graph
congruence gives cross depths at least \(\max(a_i,a_j)\), so the condition is
automatic. This packages the arbitrary-depth theorem as a canonical filtered
packet result, while honestly retaining the marked elliptic graph structure.
The remaining work is descent of the filtered packet and a basis-free
definition of the product lattice; no new tropical source is needed.

### 4. Finite-etale graph NS all-degree saturation — best geometric payoff

After finite unramified splitting, the graph NS lattice is a symmetric
matrix-of-ideals lattice. The tropical inequality then gives actual
rank-one divisor classes. Pullback to the elliptic power is decomposable, so
each such class squares to zero; consequently
\[
\operatorname{PD}\langle\operatorname{NS}(A)\rangle^k
=\operatorname{im}\bigl(\operatorname{Sym}^k\operatorname{NS}(A)
\to H^{2k}(A,\mathbf Z)\bigr)
\]
for every \(k\), after faithful-flat descent and localization.

This strictly reaches beyond the minimal cofactor (\(k=g-1\)): it includes
all polarization divided powers and the top class. Its readiness is
conditional on the exact graph-basis congruence, compatibility of the local
finite-etale algebras, and base-change equality for the prescribed NS/product
lattices. The result is cohomological and presentation-dependent, not a
Chow theorem or a theorem about arbitrary ppavs.

### 5. Toric-normality / tropical Gram-factorization route — interesting but
not yet ready

Yu’s tropical Gram factorization suggests a toric or Rees degeneration in
which the rank-one hull is the normal semigroup generated by valuation
vectors of \(vv^t\). If made precise, this could give a basis-free
semigroup-saturation proof and perhaps a functorial defect module.

At present this is only a direction. Tropical convex addition is a minimum,
whereas the C909 lattice is an \(O\)-linear signed span; residue-unit
cancellation and dyadic signs are invisible to the tropical semiring.
Toric normality alone therefore cannot replace the explicit signed lift or
the graph NS descent. Do not promote this as an existing theorem.

## Strength/readiness ranking

| Move | Strength | Readiness | Honest position |
|---|---:|---:|---|
| Integral tropical lift (C909.1) | medium | ready | elementary new packaging of a preempted tropical inequality |
| Exact defect module (C909.2) | high | ready locally | stronger local algebra; not yet a geometric PD defect |
| Rees filtered-packet form | high | conditional | canonical presentation of the same criterion |
| Finite-etale graph all-degree PD saturation | highest application | conditional/near-ready | strongest C909 theorem, subject to graph and descent hypotheses |
| Toric normality/Gram factorization | potentially highest | speculative | research direction, not current evidence |

## Literature record

### Josephine Yu, *Tropicalizing the positive semidefinite cone*

* Read depth: **full text** — cached arXiv PDF and complete pdftotext
  extraction; relied on Theorem 1 (inequalities
  \(x_{ii}+x_{jj}\le2x_{ij}\)), Lemma 3 (symmetric tropical rank-one
  matrices), and Theorem 4 (tropical rank-one convex hull).
* Version/access: arXiv:1309.6011v1 PDF fetched from the arXiv PDF endpoint.
* Cache key: arXiv:1309.6011.
* SHA-256:
  ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6.

Yu works over real Puiseux series and tropical min-plus convexity. The source
does not state an \(O\)-linear lattice span, a dyadic signed lift, or an
abelian-variety graph application.

### Dustin Cartwright and Melody Chan, *Three notions of tropical rank for
symmetric matrices*

* Read depth: **partial** — cached arXiv PDF and extracted text; relied on
  the Introduction/Section 3 definitions of symmetric Barvinok rank and
  Proposition 3, plus Theorem 6’s inequality-based finite-rank bound.
* Version/access: arXiv:0912.1411v1 PDF fetched from the arXiv PDF endpoint.
* Cache key: arXiv:0912.1411.
* SHA-256:
  65a2973ccaef502abf7381a9dfa85af3bd0aa502d1e5b1aa148a8a7a453200a5.

This source studies tropical secant rank, not additive DVR lattices or
divided powers. It supports the adjacent-framework classification only.

## Search protocol and coverage boundary

Exact queries run:

* symmetric matrix lattice over DVR generated by rank one forms
* tropical positive semidefinite cone rank one symmetric matrices valuation
* valuation matrix 2e_ij >= a_i+a_j rank one
* symmetric bilinear form over a discrete valuation ring orthogonal sum rank one
* quadratic forms over discrete valuation rings diagonalization rank one
* integral symmetric matrices generated by rank one forms valuation ideals
* valuation symmetric matrices rank-one tropical cone
* symmetric bilinear forms DVR rank one decomposition ideals
* rank-one generated symmetric lattice DVR

The search provider returned ranked result pages; no finite database set or
citation graph was enumerated. Search results were screened over title and
abstract/snippet fields. No exact DVR matrix-of-ideals theorem was promoted
from those results.

MathSciNet: **NOT COVERED** (institutional authentication unavailable).  
zbMATH Open: **NOT systematically covered**.  
Google Scholar: **NOT COVERED** (automated access blocked).  
OpenAlex/Crossref/Semantic Scholar citation graphs: **NOT RUN**.  
No exhaustive quadratic-lattice monograph search was attempted.

## Final priority verdict

Yu preempts the tropical cone inequality and tropical rank-one hull, so C909
should not claim those as new. The exact integral DVR lifting identity and
the defect module (C909.2) are elementary local results not found in this
bounded search. The defensible substantive claim is the application:
compatible finite-etale, block-respecting graph NS lattices satisfy the
midpoint condition automatically, yielding all-degree ordinary
divisor-product saturation after faithful-flat descent. This is a
plausibly new synthesis under the recorded coverage, not a claim of a new
tropical framework.

