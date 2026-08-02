# C829 external mathematical cold read

**Lane:** `golden`

**Date:** 2026-08-02

**Frozen verdict:** **MINOR**

## Scope and independence

I read the authoritative fifteen-page manuscript
`papers/golden-quantum-statistics/golden_quantum_statistics.tex` as a cold
mathematical referee.  Before freezing this report I did not consult any
private task report, certificate, checker, replay, evidence manifest, or
generated output.  I reconstructed the continuous-control, Hermitian Pareto,
squared-spectrum rigidity, and quantitative stability arguments directly from
the manuscript.  I consulted the public full text of Et-Taoui,
arXiv:1409.5720 (cached SHA-256
`eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`),
only to confirm the cited one-parameter Hermitian conference family.

The principal theorems are correct as stated.  I found no missing hypothesis,
normalization error, false equality case, incorrect stability constant, or
incorrect threshold.  Two short completeness bridges should be printed, and
one cited realization should be made easier to audit.  These are minor
repairs because the omitted arguments are elementary and do not change any
claim.

## Reconstructed causal proof spine

### Continuous real control

Write (K(x)=\sum_i x_i u_i v_i^{\mathsf T}).  Each summand has rank one.
The projector calculation gives

\[
 p_1=\frac{6\sum_i x_i^2-(\sum_i x_i)^2}{20}\le \frac95.
\]

Equality requires both \(\sum_i x_i^2=6\) and \(\sum_i x_i=0\), hence a
balanced Boolean control.  Convexity of \(\lVert K\rVert_{S_4}^4\) reduces
the (p_2) maximum to cube vertices.  The four support-size spectra printed
in the paper give (p_2\le33/25).  Every two-minor and the determinant are
affine in each coordinate because a rank-one update contributes no quadratic
term to a minor.  Their squared moduli are separately convex, so the same
vertex reduction gives (e_2\le24/25) and (e_3\le16/125).

The exact determinant equality case follows as well.  If a maximizer had an
interior coordinate, convexity on that coordinate interval would force both
endpoints to be determinant maximizers.  Iterating would produce two
maximizing Boolean vertices differing in one sign.  That is impossible:
all maximizing Boolean vertices are balanced, while a one-sign flip is
unbalanced.  Thus every determinant maximizer is one of the twenty balanced
Boolean controls.

For the mixed sector, sort the eigenvalues as (a\ge b\ge c\), and put
(u=a+b), (v=ab).  Then

\[
 s_{(2,1)}=u(v+cu+c^2).
\]

It increases with (v), subject to
(v\le u^2/4) and (v\le24/25-cu), and then increases with (u) on each
active branch, subject to (u+c\le9/5).  Since (c\le3/5), the two active
bounds exchange at (c=1/5).  On (0\le c\le1/5), subtraction from (8/5)
is

\[
 \frac{(5c-1)(25c^2+50c-71)}{500}\ge0;
\]

on (1/5\le c\le3/5), it is

\[
 \frac{(5c-4)^2(5c-1)}{125}\ge0.
\]

Equality forces ((a,b,c)=(4/5,4/5,1/5)), hence determinant equality and a
balanced Boolean control.  Finally (h_3=e_3+p_1p_2) gives its bound and,
through equality in (p_1), the same equality set.

### Hermitian landscape and Pareto completeness

For a balanced triple, its Hermitian principal block has characteristic
polynomial (z^3-3z-2r_T).  With (H_T=I-A^2/5), Newton identities give
(p_1=9/5), (p_2=33/25), (e_2=24/25), and

\[
 e_3=\frac{4(5-r_T^2)}{125}.
\]

The symmetric-function identities give the other two displayed affine
functions of (t=r_T^2).  The continuous-control vertex reductions remain
valid for Hermitian entries because they use only linearity, rank one, and
the conference block identities.

For completeness of the frontier, let a feasible point be ((h,s,e)).  The
two supporting inequalities imply

\[
 \frac{125s-196}{4}\le
 \min\!\left\{\frac{317-125h}{4},\frac{20-125e}{4}\right\}.
\]

Together with (h\le317/125), (s\le200/125), and (e\le20/125), this
places some (t\in[0,1]) between those bounds.  The point
((317-4t,196+4t,20-4t)/125) then dominates ((h,s,e)).  Both supporting
inequalities are equalities on the segment, so its distinct points are
pairwise incomparable.  Et-Taoui's unimodular parameter (b) supplies a
fixed triangle with (r_T=\operatorname{Re}b), realizing every
(t\in[0,1]).

### Squared-spectrum rigidity

Complementary cross blocks have the same nonzero squared singular spectrum,
so complementary triples have the same (r_T^2).  The fixed first two
moments show that cut-independent squared spectrum, or constancy of any one
of the three sectors, is equivalent to (|r_T|=\rho) for every triangle.

After root dephasing, write the lower block as
(S=\rho A+i\sqrt{1-\rho^2}B).  For (0<\rho<1), its row sums make (A)
a symmetric two-positive/two-negative sign graph and (B) a regular skew
tournament.  The positive graph of (A) is a pentagon.  The imaginary part
of (S^2=5I-J) requires (AB+BA=0), while the displayed three-entry
combination is twice a sum of three signs and cannot vanish.  Thus the
interior range is impossible.

At \(\rho=0\), bordering (B) by the root sign row and its negative column
produces an integral skew matrix \(\widetilde B\) with
(\widetilde B^2=-5I_6\).  Hence \(\det\widetilde B=125\), contradicting
the fact that an even-dimensional integral skew determinant is the square of
an integral Pfaffian.  Therefore \(\rho=1\), and the dephased matrix is real.
The converse is immediate.

### Stability constants and threshold

For triangle products (z_T) of (C) and (w_T\in\{\pm1\}) of any aligned
real representative,

\[
 1-(\operatorname{Re}z_T)^2\le |z_T-w_T|^2
 \le3\sum_{e\subset T}|C_e-R_e|^2.
\]

There are twenty triangles, each edge occurs four times, and Frobenius norm
counts both matrix orientations.  Thus
(20\delta\le6\lVert C-R\rVert_F^2\), giving
(d_{\mathbb R}(C)^2\ge(10/3)\delta).

For the reverse direction, root dephasing identifies the ten projective cut
pairs with the ten root triangles.  Rounding each remaining upper entry to
the sign of its real part costs at most
(2[1-(\operatorname{Re}C_{ij})^2]) per upper entry, hence

\[
 x^2=\lVert C-R\rVert_F^2\le40\delta.
\]

Also

\[
 \lVert R^2-5I\rVert_2\le x(2\sqrt5+x).
\]

The threshold is exact for this argument because

\[
 40\frac{6-\sqrt{35}}{20}
 =12-2\sqrt{35}=(\sqrt7-\sqrt5)^2.
\]

Strict inequality therefore gives (x<\sqrt7-\sqrt5) and
(x(2\sqrt5+x)<2).  The diagonal of (R^2) is five and every off-diagonal
entry is an even integer, so the operator-norm bound forces
(R^2=5I).  This proves the local upper bound with the manuscript's
unnormalized Frobenius convention.

## Numbered comments

1. **Continuous-control equality case, Theorem 5.2, proof at source lines
   606--607.**  Separate convexity proves the value but does not by itself
   prove the printed phrase “with equality exactly at the balanced vertices.”
   Add the one-coordinate endpoint argument reconstructed above.  This also
   makes the equality claims for (h_3) and (s_{(2,1)}) visibly complete.

2. **Pareto completeness, Theorem 6.2, proof at source lines 687--694.**
   The two supporting inequalities do imply domination by the entire segment,
   but the interval-selection step is omitted.  Print the one-line bounds on
   (t) from the reconstruction above.  Also cite the exact theorem/equation
   in Et-Taoui or display the order-six one-parameter matrix: realization of
   every (t\in[0,1]) is part of completeness, not merely background.

3. **Stability normalization, Theorem 6.3 and equations
   `stability-lower`--`stability-upper`.**  Checked with the unnormalized
   Frobenius convention.  The factors (20\), (6\), (40\), and (10/3)
   are correct.  The strict threshold is exactly the value needed to make the
   parity norm less than two.  No change requested.

4. **Squared rigidity, Theorem 6.3, source lines 747--768.**  The pentagon
   parity and Pfaffian-square endpoint exclusions are complete and
   classification-free.  For reader speed, say explicitly that complementary
   blocks (R) and (R^*\) have the same squared singular spectrum; this is
   the bridge from ten projective cuts to all twenty triangle holonomies.
   This is expository and not a logical defect.

## Optional expository improvements

- State once before Theorem 5.2 that every (K(x)) is a contraction, which is
  the source of (0\le\lambda_i\le1) in the mixed-sector lemma.
- In the mixed-sector lemma, include the positive denominators in the two
  displayed factorizations; “factors through” currently makes the sign check
  slower than necessary.
- In the reverse stability paragraph, record
  (|u-\operatorname{sgn}(\operatorname{Re}u)|^2
  =2(1-|\operatorname{Re}u|)\le2(1-(\operatorname{Re}u)^2)).
  This makes the constant (40) immediate.
- Replace “would equate an odd integer with an even integer” in the pentagon
  step by the sharper statement that a sum of three signs cannot be zero.

## Verdict boundary

**MINOR.**  The paper's four audited mathematical packages survive the cold
read.  The requested repairs concern two omitted elementary completeness
bridges and one citation locator.  No theorem statement, constant, threshold,
or scope boundary needs revision.  This verdict is frozen before author
triage and before inspection of private reports or certificates.
