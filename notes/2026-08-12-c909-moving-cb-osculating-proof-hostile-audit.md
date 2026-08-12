# C909 — hostile audit of the moving-CB osculating proof

Date: 2026-08-12  
Status: independent hostile audit; no manuscript, PDF, mirror, Lean, or
certificate edit

## Verdict

The proposed argument has a precise correction.

### Literal scalar-direction reading: MAJOR failure

If

\[
 D_z=\sum_i z_i\partial_{u_i}
\]

is a single directional operator and the result is evaluated at \(u=z\),
then the claim

\[
 F^r=\ker D_z^{[n-r+1]}
\]

is false already for \(n=3,r=2\).  Homogeneity gives

\[
 (D_zP)(z)=nP(z),\qquad
 (D_z^qP)(z)=n(n-1)\cdots(n-q+1)P(z),                 \tag{1}
\]

up to the chosen divided-power normalization.  Thus all these scalar
directional kernels are just the evaluation kernel \(P(z)=0\) in
characteristic zero, whereas \(F^2\) imposes the first-jet conditions and
has rank one for the six-slot web.  The Taylor direction is a new variable
\(w\):

\[
 P(z-w)=\sum_q(-1)^q
 \left(\sum_iw_i\partial_{u_i}\right)^{[q]}P(u)\big|_{u=z},    \tag{2}
\]

not \(D_z\) with the direction identified with the base point.

### Correct full-jet/CB reading: GO for the kernel identity, but not for the
all-\(n\) Smith theorem

Replace the scalar operator by the full divided-power jet map

\[
 \mathcal J_q(z):W_n\longrightarrow
 \bigoplus_{|A|=q}R,\qquad
 P\longmapsto\bigl(\partial_A P(z)\bigr)_{|A|=q},              \tag{3}
\]

or, representation-theoretically, pair the image of
\(\gamma_{q}(E_z)\) against every source weight vector.  Then, over a
torsion-free DVR \(R\),

\[
 F^r_z=\bigcap_{q<r}\ker\mathcal J_q(z)
      =\ker\mathcal J_{r-1}(z)
      =\operatorname{Ann}\operatorname{im}\gamma_{n-r+1}(E_z). \tag{4}
\]

The first equality is Taylor for multilinear matching polynomials.  The
second is Euler descent: if \(|A|=d<r-1\),

\[
 (n-d)\partial_A P(z)
 =\sum_{i\notin A}z_i\partial_{A\cup\{i\}}P(z).              \tag{5}
\]

Since \(R\) is torsion-free and \(n-d\ne0\), vanishing of the order-\(d+1\)
layer forces vanishing of the order-\(d\) layer.  The last equality follows
from the coefficient-dual invariant pairing and the identity

\[
 \langle P,\gamma_{n-r+1}(E_z)v_A\rangle=\partial_A P(z),
 \qquad |A|=r-1.                                             \tag{6}
\]

This corrected statement is an integral subbundle identity and does not need
etaleness.  It is the right moving-CB interpretation.

## 1. What kernel saturation does prove

For each \(r\), \(\mathcal J_{r-1}\) has free target, so \(F^r\) is a saturated
submodule of the free web lattice \(W_n\).  Moreover

\[
 F^{r+1}=\ker\bigl(\mathcal J_r|_{F^r}\bigr),
\]

hence \(F^r/F^{r+1}\) is torsion-free and therefore free over a DVR.  This
justifies the following part of the proposed proof:

* the filtration is integral;
* its successive quotients are free;
* after passing to the fraction field, conformal-block/fusion theory can
  identify their ranks with the bounded-height Dyck numbers, provided the
  marked roots are distinct.

This also explains why the \(n=3\) etale calculation has ranks
\(1,4,5\) for the evaluation, first-jet, and Hessian row spans, hence
\(\operatorname{rank}(F^1,F^2,F^3)=(4,1,0)\).

## 2. The exact missing step: free graded quotients are not unit minors

The kernel argument does **not** prove the integral osculating-web/Smith
theorem.  It proves that \(F^r/F^{r+1}\) is free, but the leading jet map

\[
 \operatorname{gr}^r_F W_n=F^r/F^{r+1}
 \longrightarrow \bigoplus_{|A|=r}R,\qquad
 [P]\longmapsto(\partial_A P(z))_A                         \tag{7}
\]

may have a non-saturated image.  A free source and free quotient do not force
the image of an injection into a free target to be primitive: multiplication
by \(p\),

\[
 R\hookrightarrow R,\qquad x\longmapsto px,                 \tag{8}
\]

has free source and zero kernel but nonunit leading coefficient.

The same abstract issue occurs for a filtered matrix.  Let
\(W=Re_0\oplus Re_1\), let the degree-zero row be \(e_0^\vee\), and let the
degree-one row on \(F^1=Re_1\) be \(p\,e_1^\vee\).  Every kernel and every
successive quotient is free, but the Rees/jet matrix has a genuine \(p\)
Smith factor.  Thus

\[
 \text{free kernels and characteristic-zero ranks}
 \;\not\Rightarrow\;
 \text{saturated leading jet minors}.                       \tag{9}
\]

For C909 the needed additional statement is precisely that every map (7) has
a saturated image after the previous layers are eliminated, equivalently that
nested pivot minors are units times products of root differences.  Pairwise
etale roots make the raw entries in (3) unit products, but do not by
themselves prevent Schur-complement sums from acquiring positive valuation.
This is the unimodular osculating-web theorem still required beyond the
moving-CB interpretation.

The semilength-three case is closed by the existing symbolic certificate:
the relevant determinantal valuations are \(0,1,2,3,5\), with non-graph
factors products of the six root differences.  Semilength four has exhaustive
finite-field support but an unresolved symbolic extra factor; arbitrary
semilength remains open.

## 3. Divided powers and characteristic two

The divided-power normalization is mandatory for base change.  For commuting
square-zero \(E_i\),

\[
 E_z^q=q!\,\gamma_q(E_z),\qquad
 \gamma_q(E_z)=\sum_{|S|=q}z_SE_S.                          \tag{10}
\]

Over a torsion-free \(\mathbf Z_2\)-DVR, annihilators of the two images agree
because \(q!\) is a nonzero nonzerodivisor.  Over \(R/2R\), ordinary powers
can collapse: \(E_z^2=0\) while \(\gamma_2(E_z)\) is generally nonzero.
Therefore an integral CB subbundle that is intended to commute with
reduction must use \(\gamma_q\), or the integral hyperalgebra, not ordinary
powers.

Likewise, the raw Temperley–Lieb trace pairing has loop parameter \(2\) and
is not unimodular at \(2\).  The pairing in (6) must be the coefficient-dual
pairing between the integral web lattice and the dual weight-zero module (or
an explicitly divided-power-renormalized web pairing).  The premise that
the \(n=2\) formula matches C909 already implicitly requires this
normalization; the unnormalized two-matching Gram matrix is proportional to

\[
 \begin{pmatrix}4&2\\2&4\end{pmatrix},
\]

which degenerates mod \(2\).

## 4. \(n=3\) and the first genuine boundary

For the corrected full-jet map and six pairwise distinct residual roots:

\[
\begin{array}{c|c|c|c}
r&\ell=n-r&\text{CB/jet equations}&\text{row rank}\\ \hline
1&2&P(z)=0&1\\
2&1&\partial_iP(z)=0&4\\
3&0&\partial_i\partial_jP(z)=0&5.
\end{array}
\]

Thus \(F^1,F^2,F^3\) have ranks \(4,1,0\), and the identity survives
the dyadic unramified etale case.  No \(n=3\) etale mismatch was found; the
symbolic six-slot unit-minor theorem proves the required rank/profile.

The earliest exact failure is therefore not an \(n=3\) etale counterexample
but the scalar-\(D_z\) interpretation, which fails at \(n=3,r=2\) over
characteristic zero.  If the scalar notation is repaired to mean (3), the
earliest unresolved issue is the all-\(n\) primitive-leading-minor theorem,
already beyond the closed \(n=3\) case.

## Final grade

**MINOR repair** if \(D_z^{[q]}\) is explicitly defined as the full
divided-power jet/CB map (3), the pairing is coefficient-dual, and the
all-\(n\) unit-minor theorem remains a separate hypothesis.

**MAJOR** if the manuscript identifies the scalar directional operator
\(\sum z_i\partial_{u_i}\) with the full Taylor jet, or claims that free
kernel quotients plus fusion ranks prove integral saturation.  The first
failure is equation (1); the second is the primitive-image gap (8)--(9).

