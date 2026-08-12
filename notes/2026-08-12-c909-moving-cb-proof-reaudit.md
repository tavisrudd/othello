# C909 — re-audit after the moving-CB polynomial-output clarification

Date: 2026-08-12  
Status: corrected hostile audit; no manuscript, PDF, mirror, Lean, or
certificate edit

## Corrected verdict

The earlier scalar-direction objection does not apply if \(D_z^{[q]}P(w)\)
means a polynomial in the independent variable \(w\), as clarified:

\[
 D_z=\sum_i z_i\partial_{u_i},\qquad
 D_z^{[q]}P(w)\in R[w_1,\ldots,w_{2n}]_{n-q}.                 \tag{1}
\]

For multilinear homogeneous web polynomials,

\[
 P(z-w)=\sum_{q=0}^{n}(-1)^qD_z^{[q]}P(w).                  \tag{2}
\]

Thus vanishing of the entire degree-\((r-1)\) Taylor component
\(D_z^{[n-r+1]}P(w)\), followed by the divided-power composition law, forces
all lower-degree components over a torsion-free DVR.  The corrected identity

\[
 F^r_z=\ker\!\left(D_z^{[n-r+1]}:W_n\to R[w]_{r-1}\right)   \tag{3}
\]

is sound, and it is equivalent to the moving CB annihilator after using the
coefficient-dual web pairing.

The all-\(n\) integral Smith theorem still does **not** follow from this
kernel identity, free kernels, and characteristic-zero fusion ranks.  The
graph Smith factors require the first nonzero Taylor maps to have primitive
images in the fixed integral exterior target.  A saturated filtration of the
source does not imply that target primitiveness.

## 1. Taylor identity and kernel equality

For a matching monomial, each edge factor contributes either a \(z_i\) or a
\(w_j\) term in \(P(z-w)\).  Divided powers of
\(\sum_i z_i\partial_{u_i}\) choose the \(z\)-endpoints without factorials.
This gives (2) directly; for \(P=u_1u_2\),

\[
 D_z^{[2]}P(w)=z_1z_2,\quad
 D_z^{[1]}P(w)=z_1w_2+z_2w_1,\quad
 P(w)=w_1w_2.
\]

The C909 condition that all Taylor components of degrees \(<r\) vanish is

\[
 F^r_z=\bigcap_{q=n-r+1}^{n}\ker D_z^{[q]}.                 \tag{4}
\]

The divided-power composition relation is

\[
 D_z^{[a]}D_z^{[b]}
 =\binom{a+b}{a}D_z^{[a+b]}.                                \tag{5}
\]

If \(D_z^{[n-r+1]}P=0\), apply \(D_z^{[s]}\) for \(s>0\).  Equation (5)
gives a nonzero integer times \(D_z^{[n-r+1+s]}P=0\).  Over a torsion-free
DVR this integer is a nonzerodivisor, so all higher \(q\)-components vanish.
Hence (3) and (4) agree.

Equivalently, in the tensor realization, the source weight vectors \(v_A\)
with \(|A|=r-1\) satisfy

\[
 \langle P,\gamma_{n-r+1}(E_z)v_A\rangle
 =\partial_A P(z),
\]

which are exactly the coefficients of \(D_z^{[n-r+1]}P(w)\).  This is the
correct integral moving-CB comparison.

## 2. What the saturated-kernel argument really proves

Let

\[
 L_r=D_z^{[n-r]}|_{F^r}:F^r\longrightarrow
 R[w_1,\ldots,w_{2n}]_{r}.                                  \tag{6}
\]

Then \(F^{r+1}=\ker L_r\).  Since the target is free over a DVR,

\[
 F^r/F^{r+1}\simeq\operatorname{im}L_r
\]

is torsion-free and hence free.  Also each \(F^r\subset W_n\) is saturated as
a kernel into a free target.  These are genuine integral conclusions.

Over the fraction field, the standard moving-CB theorem can identify the
ranks with fusion/path counts \(B(n,n-r)\), so the successive ranks are
\(H(n,n-r)\), assuming distinct marked points.  This proves the *source
filtration ranks* and their freeness.

## 3. Why graph Smith still needs target primitiveness

The graph product map is a Rees-type map whose degree-\(r\) term is

\[
 \lambda^r L_r(P),\qquad \lambda=p^a.                       \tag{7}
\]

Smith factors depend on the content of \(L_r(F^r)\) in the fixed integral
degree-\(r\) exterior lattice.  Freeness of
\(F^r/F^{r+1}\) does not imply that this image is primitive.

The simplest abstract countermodel is

\[
 W=Re_0\oplus Re_1,\qquad
 F^1=Re_1,\qquad F^2=0,
\]

with degree-zero map \(e_0\mapsto 1\) and leading map
\(L_1(e_1)=p\,v\) into a free target \(Rv\).  All kernels and successive
quotients are free and saturated, but the Rees matrix is

\[
 \begin{pmatrix}1&0\\0&p\lambda\end{pmatrix},              \tag{8}
\]

whose second Smith valuation is \(a+1\), not the predicted \(a\).  The
nonprimitive image \(pRv\) is invisible to the source filtration.

Consequently, to derive the C909 Smith profile one still needs an
osculating-web primitive-image theorem:

\[
 \operatorname{im}\!\left(
 F^r/F^{r+1}\xrightarrow{\,L_r\,}
 \bigoplus_{|S|=r}R\right)
 \text{ is saturated for every }r,                          \tag{9}
\]

or an equivalent nested family of unit minors after previous layers are
eliminated.  Pairwise etale roots make raw matching coefficients products of
unit differences, but do not formally rule out positive valuations in
Schur-complement combinations.  This is exactly the earlier filtered-web
proof gate.

Thus:

\[
 \text{CB kernel identity + free filtration}
 \not\Rightarrow
 \text{integral osculating-web Smith theorem}.               \tag{10}
\]

The graph Smith problem does require target primitiveness; source
saturation alone is insufficient.

## 4. \(n=3\), characteristic two, and the earliest boundary

For six slots and pairwise distinct residual roots, the symbolic calculation
gives row ranks

\[
 \operatorname{rank}(D_z^{[3]})=1,\qquad
 \operatorname{rank}(D_z^{[2]})=4,\qquad
 \operatorname{rank}(D_z^{[1]})=5,                          \tag{11}
\]

hence

\[
 \operatorname{rank}(F^1,F^2,F^3)=(4,1,0).                  \tag{12}
\]

The rank-five Hessian minors and the successive Smith determinantal
valuations \(0,1,2,3,5\) have non-graph factors that are products of root
differences.  Therefore no \(n=3\) etale counterexample occurs, including
after unramified dyadic splitting.

The divided-power normalization remains essential over \(p=2\):

\[
 E_z^q=q!\gamma_q(E_z).
\]

Over \(\mathbf Z_2\), ordinary and divided-power annihilators agree because
\(q!\) is a nonzero nonzerodivisor.  Over \(\mathbf F_2\), ordinary
\(E_z^2\) vanishes while \(\gamma_2(E_z)\) need not; the integral CB
subbundle must use divided powers to commute with reduction.

## Final grade

**GO after notation repair:** the polynomial-output \(D_z^{[q]}P(w)\)
identity gives the moving-CB interpretation and the integral saturated
source filtration.

**MAJOR overclaim:** claiming that this alone proves the all-\(n\) graph Smith
profile. The unresolved input is (9), a primitive leading-image/unit-minor
theorem. The first actual etale case \(n=3\) is already closed and has no
counterexample; the first unresolved width remains \(n=4\), not \(n=3\).

