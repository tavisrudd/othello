# C716 source and marking audit

**Lane:** `golden`

**Date:** 2026-07-31

## Verdict

Two primary sources are used.  One was read at full text and one at the
partial depth stated below.  The 21-component Fano classification is prior
work: fifteen components are planes of lines contained in the fifteen Segre
planes, and six are split degree-five del Pezzo surfaces.  The outer
permutation of the six Joubert coordinates, the matching dictionary, and the
cross-ratio inverse are likewise classical.

C716 therefore makes no novelty claim for the Fano surface, its component
count, or its del Pezzo geometry.  Its task-owned return is the frozen C707
marking, the exact one-moving-path Golden realization, and the coupled
determinant--Pfaffian form of the mixed anomalies.

## Sources

1. Ben Gripaios and Khoi Le Nguyen Nguyen, *Anomaly cancellation for two
   \(U(1)\) factors*.  **Read depth:** `partial`, arXiv v1, Sections 4.1 and
   4.2.1 and Appendix E.  Section 4.1 proves that the Fano variety has 21
   two-dimensional irreducible components, with fifteen plane components and
   six smooth rational chiral components.  Section 4.2.1 identifies each
   chiral component over \(\mathbb Q\) with the split degree-five del Pezzo
   surface, the blow-up of \(\mathbf P^2\) at four rational points.  Equation
   (4.15), equations (4.19)--(4.20), and Appendix E fix the source labels
   \(D_0,\ldots,D_5\) used in C716's component comparison.  Cache key
   `arXiv:2607.09879`, SHA-256
   `d9e4e7905e270e31a01c6c3a05e11388650cfd40579b2bf98d2bd9820d2493b3`.

2. Ben Howard, John Millson, Andrew Snowden, and Ravi Vakil, *A description of
   the outer automorphism of \(S_6\), and the invariants of six points in
   projective space*.  **Read depth:** `full text`, arXiv v1, with Sections
   1.1--1.6 and 2.1--2.4 used.  Sections 1.1--1.6 give the six-object outer
   action; Section 2.1 identifies the six-point quotient with the Segre cubic
   and the signed outer representation; Section 2.4 identifies matching
   brackets with half-sums of Joubert coordinates.  Cache key
   `arXiv:0710.5916`, SHA-256
   `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.

## Exact marking comparison

Applying the C715 matching-ratio inverse to generic representatives printed
in the first source gives

\[
 D_0\mapsto\mathcal D_4,\quad
 D_1\mapsto\mathcal D_1,\quad
 D_2\mapsto\mathcal D_0,\quad
 D_3\mapsto\mathcal D_2,\quad
 D_4\mapsto\mathcal D_3,\quad
 D_5\mapsto\mathcal D_5,
\]

where \(\mathcal D_i\) is the C707-marked component obtained by moving path
\(i\) while the other five path points remain fixed.  This comparison is a
coordinate translation, not a competing component labelling.  The exact
representatives and symbolic five-point cross-ratio test are stored in the
C716 certificate bundle.

## Coverage boundary

This was an attribution and formula-comparison audit, not a priority or
forward-citation audit.  It makes no absence claim.  MathSciNet, zbMATH,
Google Scholar, citation graphs, and later-version searches were not needed
for the imported theorem and were not covered.
