# C715 formula-level literature audit

**Lane:** `golden`

**Date:** 2026-07-31

## Verdict

Five primary sources were consulted; two were read at full text and three at
the stated partial depth.  The rational inverse of the six-point Joubert map
is classical in substance and nearly explicit in the modern literature.
Howard--Millson--Snowden--Vakil identify every matching bracket product with a
half-sum of two Segre coordinates and exhibit cross-ratios as ratios of such
pair sums.  The C715 inverse specializes this classical construction to the
frozen C707 outer marking; it is not a new parametrization of the Segre cubic.

The anomaly literature likewise treats
\(\sum q_i=\sum q_i^3=0\), its general integer parametrizations, the ten
\(3+3\) singular points, and the fifteen nonchiral planes.  C715 may claim only
the operator-specific transport: a rational charge point is synthesized by a
golden diagonal filter, with exact Slater normalization, fibrewise success
optimization, and the Boolean boundary.  The bounded searches below did not
locate that physical transport or its exact optimization, but this audit does
not support a priority claim for them.

## Sources

1. Ben Howard, John Millson, Andrew Snowden, and Ravi Vakil, *A description of
   the outer automorphism of \(S_6\), and the invariants of six points in
   projective space*.  **Read depth:** `full text`, arXiv v1, especially
   Sections 1 and 2.1--2.4.  Section 2.1 gives the signed-triangle Joubert map
   and the Segre equations; Section 2.4 gives
   \(X_{13|26|45}=(Z_a+Z_b)/2\) and its full \(S_6\)-orbit; the preceding
   cross-ratio discussion gives ratios of pair sums.  Cache key
   `arXiv:0710.5916`, SHA-256
   `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.

2. Benjamin Howard, John Millson, Andrew Snowden, and Ravi Vakil, *The
   relations among invariants of points on the projective line*.  **Read
   depth:** `full text`, cached arXiv version, especially Sections 1 and 3.
   It states that the equal-weight invariant ring for six ordered points is
   generated in degree one, identifies its quotient with the Segre cubic,
   and recalls the Joubert/Coble provenance.  Cache key `arXiv:0906.2437`,
   SHA-256
   `dfbdb89c3061b5987f59602a55d5eb40c7c29eab18f9203c0e43c6f765d37508`.

3. Davi B. Costa, Bogdan A. Dobrescu, and Patrick J. Fox, *Chiral Abelian
   gauge theories with few fermions*.  **Read depth:** `partial`, cached arXiv
   version, Introduction and Section 2.  Equations (2.2)--(2.3) give the cubic
   and gravitational anomaly equations; (2.9)--(2.11) give the merger and the
   general single-\(U(1)\) integer parametrization; (2.12) defines chirality by
   excluding zero charges and opposite pairs.  Cache key `arXiv:2001.11991`,
   SHA-256
   `c0a90e66e133fd11cc87c4857f9e542ffadc60764d726c39b2ecf41d7f61b89c`.

4. Ben Gripaios and Khoi Le Nguyen Nguyen, *Anomaly cancellation for a
   \(U(1)\) factor*.  **Read depth:** `partial`, cached arXiv version, the
   general geometry discussion and the equal-six-weight case around equation
   (3.4).  It identifies the six-charge anomaly variety with the Segre cubic,
   lists its ten singular points, and notes that projection from a node finds
   all rational points.  Cache key `arXiv:2508.11583`, SHA-256
   `8e9db79edfc38f338ff29875d7b7d5d671af0dfdd2892639b0eaed2f5d5e3b82`.

5. Ben Gripaios and Khoi Le Nguyen Nguyen, *Anomaly cancellation for two
   \(U(1)\) factors*.  **Read depth:** `partial`, arXiv v1, Section 4 through
   the opening of Section 4.1.  Equations (4.1)--(4.3) identify the
   single-factor six-charge variety, and the section records its ten nodes and
   fifteen nonchiral planes before studying lines for two factors.  The line
   classification belongs to C716's neighboring problem, not C715's inverse.
   Cache key `arXiv:2607.09879`, SHA-256
   `d9e4e7905e270e31a01c6c3a05e11388650cfd40579b2bf98d2bd9820d2493b3`.

## Formula comparison

The exact classical bridge needed by C715 is

\[
 X_{ij|kl|mn}=[ij][kl][mn]
   =\pm\frac{Z_r+Z_s}{2}.
\]

The first source prints one instance and states its \(S_6\)-orbit.  It also
prints a cross-ratio as a ratio of two pair sums.  C715's table of all fifteen
signs is therefore a marking translation and normalization check, not a new
birational idea.  The inverse chart

\[
 (\infty,0,1,a,b,c),\qquad
 a=\frac{X_{02|13|45}}{X_{03|12|45}},\quad
 b=\frac{X_{02|14|35}}{X_{04|12|35}},\quad
 c=\frac{X_{02|15|34}}{X_{05|12|34}}
\]

is the corresponding three-cross-ratio reconstruction in the frozen marking.

Costa--Dobrescu--Fox give a general quartic merger parametrization for all
integer solutions.  Gripaios--Nguyen give geometric rational parametrizations
by projection from a Segre node.  These solve the charge arithmetic directly;
neither source turns a charge point into C707 path controls or computes
three-fermion postselection cost.

## Bounded exact-combination screen

The following web queries were run verbatim on 2026-07-31:

- `"11" "-10" "-8" "5" "4" "-2" anomaly charges`;
- `"-3,-2,-1,0,1,3" anomaly`;
- `"golden conference" anomaly Segre filter`;
- `Joubert Segre anomaly inverse postselection`.

The returned candidates were either unrelated uses of “anomaly” and “filter”
or the already cached Abelian-anomaly papers above.  No candidate described
the golden conference transfer, the displayed path filter, or its
postselection optimization.  This is a narrow exact-combination screen, not a
field-wide negative.

MathSciNet was **NOT COVERED** because institutional authentication was not
available.  Google Scholar was **NOT COVERED** because automated access is not
reliable.  No forward-citation closure was attempted, and zbMATH was not used
to claim an absence.  Consequently the manuscript should attribute the
Joubert inverse and anomaly geometry classically and avoid “first” or “to our
knowledge” language for the operator-specific synthesis.

