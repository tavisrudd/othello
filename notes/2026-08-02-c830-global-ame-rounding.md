# C830 — global rounding for stabilizer-AME approximate symmetries (2026-08-02)

**Lane**: `ame-lu`.

No claim in this report rests on a computation.  The argument is structural:
minimum-support sectors are orthogonal in the global operator space, and two
well-chosen sectors cover all parties.  No certificate bundle is needed.  No
novelty assertion is made; no literature audit was run.

## 0. Verdict

The global route is positive, with a qualified dimension dependence.

For a stabilizer \(\AME(2m,q)\) state, put
\[
 N_m=\binom{2m}{m+1},\qquad
 s_m=\sqrt{(m+1)^2+(m-1)^2}.
\]
If \(\Delta=U\rho U^\dagger-\rho\), the differences of all
\((m+1)\)-party marginals obey the exact collective estimate
\[
 \sum_{|A|=m+1}q^{m+1}\lVert\Delta_A\rVert_2^2
 \leq q^{2m}\lVert\Delta\rVert_2^2
 \leq 2q^{2m}\varepsilon(U)^2.                 \tag{0.1}
\]
Thus the faint signal in one marginal is not paid independently at every
support.  Averaging over pairs of \((m+1)\)-sets whose union is all \(2m\)
parties gives two marginals that both have good signal-to-noise ratio and
together recover a Clifford frame at every party.

The resulting aggregate frame scale is
\[
 \alpha_{m,q}=\frac{2q^m}{\sqrt{N_m}},           \tag{0.2}
\]
instead of the one-marginal scale \(2q^{(m+1)/2}\).  Since
\(N_m\sim4^m/\sqrt{\pi m}\),
\[
 \alpha_{m,q}\sim 2(\pi m)^{1/4}(q/2)^m.
\]
Consequently the defect threshold for coherent local frames is polynomial,
of order \(m^{-3/4}\), at \(q=2\); it has order
\(m^{-3/4}(2/3)^m\) at \(q=3\), which improves the old exponential base;
at \(q=4\) the exponential bases tie and aggregation improves the
frame-rounding prefactor; the original route remains better for \(q>4\).
The best proved theorem takes the larger of the two routes.  This proves a
global enhancement, but refutes the stronger hope that this particular
aggregation removes exponential dependence in every local dimension.

There are two useful endpoints.

1. A larger **frame-rounding threshold** gives an exact product-Clifford
   symmetry and a residual in the budget-free generator region.  At \(q=2\)
   it is \(\Theta(m^{-3/4})\).
2. If one insists on the older conclusion
   \(\sum_i\lVert h_i\rVert_{\mathrm{op}}\leq1/2\) and the sharp local
   constant \(\sqrt{6q/5}\), the same argument gives
   \(\Theta(m^{-5/4})\) at \(q=2\).  The extra \(m^{-1/2}\) is the cost of
   replacing collective \(\ell^2\) control by an \(\ell^1\) generator
   budget, not marginal dilution.

## 1. Metrics and exact hypotheses

Let \(q=p^e\), \(n=2m\), \(m\geq3\), and let
\(\rho=|\psi\rangle\langle\psi|\) be a stabilizer \(\AME(2m,q)\) state.
For a product unitary \(U=\bigotimes_iU_i\), write
\[
 \varepsilon(U)=\min_\theta
   \lVert U\psi-e^{i\theta}\psi\rVert
 =\sqrt{2-2|\langle\psi|U|\psi\rangle|}.
\]
The unnormalized Hilbert--Schmidt norm is \(\lVert\cdot\rVert_2\), and
one-site frame distance is normalized:
\[
 d_2(U_i,K_i)=q^{-1/2}\lVert U_i-K_i\rVert_2,
\]
with the phase of \(K_i\) free.  Put
\[
 \tau_p=\min\left\{\frac13,
       \frac{\sin(\pi/p)}{2\sqrt2}\right\},\qquad
 d_p=\sqrt{2-2p^{-1/2}}.
\]
The number \(\tau_p\) is exactly the quantitative-axis threshold already
used in C786; \(d_p\) is the ray-distance gap between distinct stabilizer
states.

## 2. The collective minimum-support identity

For an operator tensor, its **exact support** is the set of sites on which
its factor is traceless rather than scalar.  Exact-support subspaces are
pairwise Hilbert--Schmidt orthogonal.

> **Lemma 1 (orthogonal marginal energy).** Let
> \(\Delta=U\rho U^\dagger-\rho\).  For
> \(r=m+1\),
> \[
>  \sum_{|A|=r}q^r\lVert\Delta_A\rVert_2^2
>  \leq q^n\lVert\Delta\rVert_2^2
>  \leq2q^n\varepsilon(U)^2.                 \tag{2.1}
> \]

**Proof.**  The stabilizer expansion of \(\rho\) has no nonidentity term
of support at most \(m\).  Local conjugation preserves exact support:
it takes a traceless one-site operator to another traceless one-site
operator.  Therefore \(\Delta\) also has no component below support
\(r\), and tracing to an \(r\)-set \(A\) retains exactly its support-
\(A\) component.  If that component is \(D_A\otimes I_{A^c}\), then
\(\Delta_A=q^{n-r}D_A\), whence
\[
 \lVert D_A\otimes I_{A^c}\rVert_2^2
 =q^{-(n-r)}\lVert\Delta_A\rVert_2^2.
\]
Orthogonality of the support components gives
\(\sum_Aq^{-(n-r)}\lVert\Delta_A\rVert_2^2
\leq\lVert\Delta\rVert_2^2\), which is the first inequality after
multiplication by \(q^n\).  Finally
\[
 \lVert\Delta\rVert_2^2
 =2(1-|\langle\psi|U|\psi\rangle|^2)
 \leq2\varepsilon(U)^2.
\]
\(\square\)

For each \(r\)-set define the dimensionless axis error
\[
 \delta_A=q^{r/2}\lVert\Delta_A\rVert_2.
\]
The normalization is forced by the marginal itself: its nonidentity Weyl
tensor has diagonal coefficient \(q^{-r/2}\).  Lemma 1 says
\[
 E:=\sum_{|A|=r}\delta_A^2\leq2q^n\varepsilon(U)^2.       \tag{2.2}
\]

This is the point that the one-marginal proof misses.  It bounds every
\(\delta_A\) separately by \(2q^{r/2}\varepsilon\).  Equation (2.2)
bounds all of them with one global energy budget.

## 3. Two good sectors cover every party

> **Lemma 2 (covering pair).** There are \(r\)-sets \(A,B\) with
> \(A\cup B=[n]\) and
> \[
>  \delta_A^2+\delta_B^2
>  \leq\frac{2E}{N_m}
>  \leq\frac{4q^n}{N_m}\varepsilon(U)^2.        \tag{3.1}
> \]

**Proof.**  Join two \(r\)-sets when their union is \([n]\), equivalently
when their \((m-1)\)-element complements are disjoint.  This graph is
regular: for fixed \(A\), the complement of a neighbor is any
\((m-1)\)-subset of \(A\), so every vertex has
\(\binom{m+1}{m-1}\) neighbors.  Averaging
\(\delta_A^2+\delta_B^2\) over its edges therefore gives
\(2E/N_m\); one edge is no larger than the average. \(\square\)

Apply the quantitative diagonal-tensor axis lemma to each of these two
marginals.  If \(\max(\delta_A,\delta_B)<\tau_p\), then every site in
\(A\) has a Clifford \(K_i\) with
\(d_2(U_i,K_i)\leq\sqrt2\delta_A\), and every site in
\(A^c\subset B\) has one with
\(d_2(U_i,K_i)\leq\sqrt2\delta_B\).  Thus all parties are covered and
\[
 \sum_i\delta_i^2
 \leq (m+1)\delta_A^2+(m-1)\delta_B^2
 \leq r(\delta_A^2+\delta_B^2),                \tag{3.2}
\]
where \(\delta_i\) denotes the error of the sector assigned to party
\(i\).  In particular
\[
 \max_i\delta_i\leq\frac{2q^m}{\sqrt{N_m}}\varepsilon,qquad
 \sum_i\delta_i^2\leq\frac{4r q^n}{N_m}\varepsilon^2.  \tag{3.3}
\]

The local Cliffords obtained from the two sectors are coherent in the only
sense needed for rounding: they form one product Clifford
\(K=\bigotimes_iK_i\).  No equality between the two possible choices on
\(A\cap B\) is required; choose the \(A\)-sector there.

## 4. From frames to an exact symmetry without an \(\ell^1\) loss

The next lemma is the second structural saving.  The old proof bounded
\(\lVert(U-K)\psi\rVert\) by a telescoping sum of operator norms.  AME
two-uniformity instead makes the infinitesimal product directions exactly
orthogonal.

> **Lemma 3 (collective logarithm).** After changing the phases of the
> \(K_i\), write \(K_i^\dagger U_i=e^{ih_i}\) up to a scalar, with
> \(h_i\) traceless Hermitian and principal eigenangles.  Then
> \[
>  D^2:=\sum_i\lVert h_i\rVert_F^2
>  \leq\frac{\pi^2q}{2}\sum_i\delta_i^2,        \tag{4.1}
> \]
> and, with \(V=K^\dagger U=\bigotimes_ie^{ih_i}\) up to phase,
> \[
>  \lVert(V-I)\psi\rVert\leq D/\sqrt q.          \tag{4.2}
> \]
> If \(\max_i\delta_i\leq q^{-1/2}\), every \(h_i\) has spectral spread
> at most \(\pi\).

**Proof.**  For principal angles \(\mu_a\),
\(|\mu_a|\leq(\pi/2)|e^{i\mu_a}-1|\).  Subtracting their mean only
decreases the sum of squares, so
\[
 \lVert h_i\rVert_F^2
 \leq\frac{\pi^2}{4}\lVert K_i^\dagger U_i-I\rVert_2^2
 \leq\frac{\pi^2q}{2}\delta_i^2.
\]
The normalized Hilbert--Schmidt estimate also makes each eigenvalue chord
at most \(\sqrt{2q}\delta_i\).  At
\(\delta_i\leq q^{-1/2}\) all principal angles lie in an arc of length at
most \(\pi\), giving the spread claim.

Put \(M=\sum_ih_i^{(i)}\), so \(V=e^{iM}\).  Two-uniformity and
tracelessness give
\(\langle\psi|M^2|\psi\rangle=D^2/q\).  The operator inequality
\(2-2\cos M\leq M^2\) now gives (4.2). \(\square\)

Combining (3.3) and (4.1),
\[
 D\leq \pi\sqrt{\frac{2qr q^n}{N_m}}\,\varepsilon,qquad
 \lVert(U-K)\psi\rVert\leq
 c_{m,q}\varepsilon,quad
 c_{m,q}:=\pi\sqrt{\frac{2r q^n}{N_m}}.         \tag{4.3}
\]

If \((1+c_{m,q})\varepsilon<d_p\), the triangle inequality in projective
state distance puts \(K\psi\) less than \(d_p\) from \(\psi\).
Both are stabilizer states, so the stabilizer overlap gap forces
\(K\psi\in\mathbb C\psi\).  Thus \(K\) is an exact symmetry.  This step
uses a constant stabilizer gap, not compactness.

## 5. Global rounding theorem

> **Theorem 4 (aggregate global rounding).** Let \(m\geq3\), and define
> \[
> \begin{split}
> R_{\rm agg}=\min\biggl\{&
>  \frac{\tau_p\sqrt{N_m}}{2q^m},
>  \frac{\sqrt{N_m}}{2q^{m+1/2}},
>  \frac{\sqrt{N_m}}{2\pi\sqrt{2r}\,q^m},\\
> &\frac{d_p}{1+\pi\sqrt{2r q^{2m}/N_m}}
> \biggr\},\qquad r=m+1 .                       \tag{5.1}
> \end{split}
> \]
> If \(\varepsilon(U)<R_{\rm agg}\), then
> \[
>  U=g\bigotimes_i e^{ih_i},qquad g\in G(\psi)
> \]
> up to a global phase, where the \(h_i\) are traceless, have spectral
> spread at most \(\pi\), satisfy \(D\leq\sqrt q/2\), and obey
> \[
>  D\leq\pi\sqrt q\,\varepsilon(U).             \tag{5.2}
> \]

**Proof.**  The first bound in (5.1) lets Lemma 2 and the quantitative-axis
lemma construct all \(K_i\).  The second gives the spread hypothesis in
Lemma 3.  The third and (4.3) give \(D\leq\sqrt q/2\).  The fourth and
the stabilizer gap make \(K=g\) exact.  The residual
\(V=g^\dagger U\) has the same defect as \(U\), so the budget-free
stability theorem applies with \(c\geq4/\pi^2\) and gives
\(D\leq2\sqrt{q/c}\varepsilon\leq\pi\sqrt q\varepsilon\). \(\square\)

For completeness, C786's one-sector proof gives a radius
\[
 R_{\rm one}=\min\left\{
 \frac{\tau_p}{2q^{(m+1)/2}},
 \frac{1}{4\sqrt2\pi(2m)q^{(m+2)/2}}
 \right\}.                                      \tag{5.3}
\]
The best proved budget-free rounding radius is
\(\max\{R_{\rm agg},R_{\rm one}\}\), using the conclusion belonging to
the selected route.  The aggregate route dominates asymptotically for
\(q=2,3,4\) for frame rounding; the one-sector route dominates for \(q>4\).

If the exact conclusion of the manuscript's decomposition corollary is
required, retain the telescoping estimate.  The covering pair gives
\[
 \sum_i\min_\phi\lVert U_i-e^{i\phi}K_i\rVert_{\rm op}
 \leq b_{m,q}\varepsilon,qquad
 b_{m,q}=\frac{2\sqrt{2q}\,s_mq^m}{\sqrt{N_m}}. \tag{5.4}
\]
Therefore
\[
 R_{\rm agg}^{\ell^1}=\min\left\{
 \frac{\tau_p\sqrt{N_m}}{2q^m},
 \frac{1}{2\pi b_{m,q}}
 \right\}                                       \tag{5.5}
\]
implies the factorization with
\(\sum_i\lVert h_i\rVert_{\rm op}\leq1/2\) and then
\(D\leq\sqrt{6q/5}\varepsilon\).  Taking the larger of (5.5) and the
old radius (5.3) is the strongest proved version with the old conclusion.

## 6. Scale comparison

Stirling gives
\[
 \frac{\sqrt{N_m}}{q^m}
 \sim \frac{(2/q)^m}{(\pi m)^{1/4}}.
\]
The binding collective-\(\ell^2\) clause of (5.1) therefore has order
\[
 R_{\rm agg}=\Theta_q\bigl(m^{-3/4}(2/q)^m\bigr),       \tag{6.1}
\]
while the \(\ell^1\) version (5.5) has order
\[
 R_{\rm agg}^{\ell^1}
 =\Theta_q\bigl(m^{-5/4}(2/q)^m\bigr).                 \tag{6.2}
\]
Against the previous \(q^{-(m+2)/2}/m\) scale:

| local dimension | best structural effect |
|---|---|
| \(q=2\) | polynomial: \(m^{-3/4}\) for frame rounding, \(m^{-5/4}\) with the old \(\ell^1\) conclusion |
| \(q=3\) | exponential remains, but the base improves from \(3^{-1/2}\) to \(2/3\) |
| \(q=4\) | the exponential bases tie; aggregation improves the frame-rounding prefactor, while the old route has the better \(\ell^1\) prefactor |
| \(q>4\) | the one-sector estimate is stronger |

This boundary has a simple explanation.  There are about \(4^m\)
minimum supports, while the global operator space contributes the factor
\(q^{2m}\) in (2.1).  Orthogonal aggregation wins exactly while the
support multiplicity outgrows the field-dimension cost, namely \(q<4\).
No manipulation of (2.1) alone can reverse that comparison for \(q>4\).

The generator-coordinate estimates remain constant-scale once a frame is
known: Theorem 4 gives \(D\leq\pi\sqrt q\varepsilon\), and the smaller
\(\ell^1\) radius gives the manuscript's
\(D\leq\sqrt{6q/5}\varepsilon\).  The dimension dependence belongs only
to recognizing the correct discrete frame.

## 7. Adversarial family pass

The required falsifier pass was structural rather than computational.

1. **Distributed near-identity rotations.**  These can have many nonzero
   local generators, but Lemma 3 treats them in \(\ell^2\), and the
   budget-free theorem gives the claimed residual estimate.  They explain
   why an \(\ell^1\) conclusion loses an extra square root of \(m\); they
   do not obstruct frame rounding.
2. **Nonsymmetry product Cliffords.**  Their local frames are already
   exact, but their defect is at least \(d_p\) by stabilizer-overlap
   quantization.  The fourth clause of (5.1) is precisely the exclusion of
   this family.
3. **The binary Hadamard family.**  C796 proved
   \(\varepsilon(H^{\otimes2m})^2\geq1\) for every stabilizer
   \(\AME(2m,2)\), by the binary Singleton bound.  It is not a hidden
   equality case of the aggregate estimate.
4. **Energy concentrated on a few minimum supports.**  This is the direct
   attack on averaging.  Lemma 2 survives it: regularity of the covering
   graph, not uniform distribution of the errors, produces a good covering
   pair.  Concentration can make most sectors unusable but cannot make
   every covering edge expensive.
5. **Energy spread uniformly over all minimum supports.**  This is the
   opposite extremum and makes the averaging constant in Lemma 2 sharp up
   to the two-sector cover.  It shows why the factor
   \(q^m/\sqrt{N_m}\) should not be advertised as removable by the present
   method.
6. **Scalar logarithm revivals.**  The generators with spread \(2\pi\)
   and zero defect from C786 lie outside Theorem 4's spread-\(\pi\)
   residual region.  The frame conclusion itself rounds them to the scalar
   Clifford, as it should.

No family refutes global rounding.  The pass does refute a stronger claim:
minimum-support aggregation by itself does not yield a constant defect
threshold uniformly in \(q,m\), because its exact energy ledger has the
\((2/q)^m\) boundary.  This is a boundary of this proof, not a claim that
no stronger theorem exists.

## 8. Trust and review boundary

Lemmas 1--3 and Theorem 4 are proved here.  The only imported mathematical
inputs are:

- the stabilizer-AME minimum-support theorem;
- the quantitative diagonal-tensor axis lemma and its phase/additivity/
  symplectic completion, with threshold \(\tau_p\);
- stabilizer overlap quantization; and
- the already proved budget-free local stability theorem.

Each is stated and proved in the current manuscript.  C786 had flagged the
general quantitative-axis passage as unaudited; the present proof does not
repair or worsen that dependency.  It changes only how the marginal errors
are budgeted.  There is no computation to reproduce or check independently.

An adversarial reread checked the three likely normalization failures:
partial trace contributes \(q^{n-r}\), exact-support norm contributes only
\(q^{(n-r)/2}\), and the marginal diagonal coefficient is
\(q^{-r/2}\).  Their product is exactly the \(q^n\) in (2.1), not
\(q^{n+r}\) or \(q^{n-r}\).  It also checked that local conjugation
preserves exact support, which is necessary for the orthogonal projection
argument.

## 9. Manuscript disposition

Adopt Lemma 1, the covering-pair argument, and Theorem 4 immediately before
the existing explicit-threshold theorem.  Present the aggregate theorem as
the low-dimensional enhancement and retain the one-marginal theorem because
it is stronger for \(q>4\) and gives the better \(\ell^1\) prefactor at
\(q=4\).  The introduction and comparison table should separate frame
rounding from the legacy \(\ell^1\) conclusion.  Do not say constant
threshold, optimal threshold, or limit.

## 10. Extra-juice and Tao closeout

The cheap upgrade exposed by the proof is Lemma 3: two-uniformity converts
framewise Hilbert--Schmidt errors into state distance in \(\ell^2\), so the
frame-rounding theorem is larger by a square root of \(m\) than the legacy
\(\ell^1\) decomposition radius.  Keeping only (5.5) would hide the main
gain.

The Tao-style question is where the number \(4\) comes from.  It is not a
quantum exceptional dimension.  It is the entropy-free counting balance
between the approximately \(4^m\) balanced minimum supports and the
\(q^{2m}\) global Hilbert--Schmidt normalization.  That identifies the next
possible improvement cleanly: a proof beyond \(q=3\) must use more than
orthogonality of the minimum-support sectors, for example the algebraic
relations among different sectors or the full higher-weight stabilizer
distribution.

## 11. Mystery ledger

- **Why is \(q=4\) the boundary?** Settled: it is the exact exponential
  counting balance \(N_m\asymp4^m\) against \(q^{2m}\), not an AME
  existence or Clifford phenomenon.  The remaining polynomial comparison
  depends on whether the conclusion uses collective \(\ell^2\) or global
  \(\ell^1\) control.
- **Why are the frame and legacy thresholds separated by \(m^{1/2}\)?**
  Settled: Lemma 3 uses the AME second moment and keeps collective
  \(\ell^2\) control; the legacy conclusion imposes an \(\ell^1\) budget.
- **Can algebraic relations among support sectors beat (2.1) for
  \(q>4\)?** Open.  The exact missing evidence is a coercive relation
  between distinct support blocks beyond Hilbert--Schmidt orthogonality.
  This is a possible successor, not part of C830.
- **Is the aggregate scale sharp among actual stabilizer-AME states?**
  Open.  Uniformly spread abstract support energy makes Lemma 2 sharp, but
  no product-unitary family is known to realize that ledger.  A sharpness
  claim would need such a family or a converse inequality.
