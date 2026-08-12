# C909 — conformal-block kernel closure of the osculating-web crown

Date: 2026-08-12

Status: structural reduction with a candidate filtered-dilation closure;
the final ambient-saturation seam remains under hostile audit. No manuscript,
PDF, mirror, or Lean edit.

Terminology warning: the earlier proposed *universal* osculating-web theorem
over \(\mathbf Z[t_i,\Delta^{-1}]\) remains unproved and is not needed. The
theorem below is the mixed-characteristic statement used in C909.

## 1. Correction to the earlier no-go

The fixed Temperley--Lieb/Jones--Wenzl submodule is not the C909 jet
filtration. That negative statement remains correct. The relevant object is
instead the **moving** genus-zero \(\mathfrak {sl}_2\) conformal-block
subbundle. Its weighted raising operator packages the coordinate jets of a
homogeneous web polynomial.

Let \(R\) be a characteristic-zero domain, let
\(t=(t_1,\ldots,t_{2n})\in R^{2n}\), and let \(W_{n,R}\) be the integral
two-row web/Specht lattice realized by the homogeneous, translation-invariant
multilinear polynomials
\[
 f_m(u)=\prod_{\{i,j\}\in m}(u_j-u_i).
\]
Put
\[
 D_t=\sum_{i=1}^{2n}t_i\frac{\partial}{\partial u_i}
\]
and denote its Hasse divided powers by \(D_t^{[q]}\). Define
\(F^r_tW_{n,R}\) by vanishing of all coefficients of total \(w\)-degree
less than \(r\) in \(f(t-w)\).

> **Directional-kernel lemma.** Integrally, for \(0\le r\le n\),
> \[
> F^r_tW_{n,R}=\bigcap_{q=n-r+1}^{n}\ker D_t^{[q]}.
> \tag{1}
> \]
> If \(R\) is a characteristic-zero domain, torsion-freeness collapses this
> tail to
> \[
> F^r_tW_{n,R}=\ker D_t^{[n-r+1]}=\ker D_t^{\,n-r+1}.
> \tag{2}
> \]

Indeed, homogeneity gives the integral Taylor identity
\[
 f(t-w)=\sum_{j=0}^{n}(-1)^jD_t^{[n-j]}f(w).
\tag{3}
\]
The displayed summand is the homogeneous \(w\)-degree \(j\) part. Hence order
at least \(r\) is the simultaneous vanishing of \(D_t^{[n-j]}f\) for
\(j<r\), which is (1). In characteristic zero the first term implies the
tail: composing with ordinary directional derivatives gives nonzero integral
multiples of the later Hasse powers, and torsion-freeness cancels those
integers. No integer is inverted in the integral lattice.

Equivalently, in the standard multiaffine tensor notation, if
\(E_t^{[q]}\) is the divided weighted raising operator, then
\[
 P(E_t^{[q]}\Phi)=
 \sum_{|B|=n-q}(\partial_B^H P_\Phi)(t)y_B.
\tag{4}
\]
This coefficient identity fixes the affine convention and identifies the
full tail in (1) with the coordinate-Hasse jet condition.

## 2. Identification with the moving conformal block

In the polynomial realization of the tensor product of \(2n\) standard
\(\mathfrak {sl}_2\)-modules, the weighted raising operator defining the
genus-zero conformal block at \(t\) is
\[
 e_t=\sum_i t_i e^{(i)}.
\]
On the affine invariant polynomial model it is \(D_t\). For weight
\((n,n)\) the defect parameter is zero, so the level-\(\ell\) conformal
block over a characteristic-zero field \(K\) is
\[
 \operatorname{CB}^{\ell}_t(n,n)=
 \ker(e_t^{\ell+1}:W_{n,K}\longrightarrow K[u]).
\tag{5}
\]
Taking \(\ell=n-r\), (2) gives the exact configuration-dependent equality
\[
 F^r_tW_{n,K}=\operatorname{CB}^{\,n-r}_t(n,n).
\tag{6}
\]
This explains the moving line already visible for \(n=2\); it is not a fixed
Jones--Wenzl submodule.

For every pairwise-distinct configuration over a characteristic-zero field,
the fusion rule therefore gives
\[
 \operatorname{rank}F^r_tW_{n,K}=B(n,n-r),\qquad
 \operatorname{rank}F^r_t/F^{r+1}_t=H(n,n-r),
\tag{7}
\]
where \(B(n,h)\) counts Dyck paths of semilength \(n\) of height at most
\(h\), and \(H(n,h)\) those of exact height \(h\).

## 3. Integral saturation over the DVR actually used

Let \(R\) now be a finite unramified extension of \(\mathbf Z_p\), and let
the \(t_i\in R\) have pairwise-distinct residues. The full Hasse-jet target
in (1) is free over \(R\). Thus
\[
 W_{n,R}/F^r_tW_{n,R}\simeq\operatorname{im}(J_{<r})
\]
is torsion-free, hence free, so \(F^r_tW_{n,R}\) is saturated. More
importantly, restriction of the degree-\(r\) Hasse jet gives
\[
 F^r_tW_{n,R}/F^{r+1}_tW_{n,R}\hookrightarrow R[u].
\tag{8}
\]
Its kernel before quotienting is exactly \(F^{r+1}_t\), using the full tail
in (1). Every successive quotient is therefore torsion-free and hence free
over the DVR. Its rank is the characteristic-zero rank (7). This proves the
integral osculating-web saturation required by C909, including \(p=2\),
without constructing a determinant minor and without a Jones--Wenzl
projector.

The ordinary power in (5) is used only for the rank calculation over the
fraction field. The integral lattice is defined by the full Hasse tail (1),
so no factorial is inverted. Collapse to one ordinary-power kernel over
\(R\) follows from torsion-freeness, not from treating
\((n-r+1)!\) as a unit. In equal characteristic \(p\), the single
divided-power kernel can enlarge; no universal fibrewise claim is made.

## 4. Consequence for the C909 Smith crown

The following lemma would remove the need for primitive minors in the chosen
jet target, provided its ambient hypotheses match the graph product lattice.

> **Filtered-dilation lemma.** Let \(R\) be a DVR, let
> \(G=\bigoplus_{j=0}^nG_j\) be free, and let \(V\subset G\) be a saturated
> free submodule. Put
> \[
> F^rV=V\cap\bigoplus_{j\ge r}G_j,\qquad
> \delta_a|_{G_j}=p^{aj}.
> \]
> Suppose \(\delta_a(V)\subset V\). Then
> \[
> \operatorname{coker}(\delta_a:V\to V)
> \simeq\bigoplus_{r=0}^n(R/p^{ar}R)^{\operatorname{rank}\gr_F^rV}.
> \tag{9}
> \]

To prove this, split the saturated flag over the DVR,
\(V=\bigoplus_rE_r\), with \(F^rV=\bigoplus_{j\ge r}E_j\).  For
\(e\in E_r\), one has
\(\delta_a(e)\in V\cap p^{ar}G=p^{ar}V\); the equality uses saturation of
\(V\subset G\).  Put
\(\phi(e)=p^{-ar}\delta_a(e)\).  Its degree-\(r\) component equals that of
\(e\), so \(\phi(e)-e\in F^{r+1}V\).  Hence \(\phi\) is filtration-
unitriangular and belongs to \(\operatorname{GL}(V)\).  Relative to the
chosen splitting,
\[
 \delta_a=\phi\circ\bigoplus_r p^{ar}\operatorname{id}_{E_r},
\]
which proves (9).  Notice that the leading-jet image in its chosen free
target need not be primitive; the lemma only uses saturation of \(V\) in the
actual exterior-coordinate lattice.

For a split one-depth finite-etale graph put
\(u_i=t_i-p^az_i\). Expansion in the saturated flag above multiplies the
\(r\)-th graded layer by \(p^{ar}\).  Here \(G\) is the squarefree exterior
coordinate lattice, \(V\) is the saturated integral Hodge/web lattice, and
\(\delta_a(V)\) is exactly the divisor-product lattice.  The unscaled web
lattice is saturated by the coefficient-one standard-monomial basis, and
the graph shear is an integral unipotent change of exterior coordinates.
Thus the filtered-dilation lemma gives, on
squarefree support of size \(2n\),
\[
 \bigoplus_{r=1}^{n-1}(R/p^{ar}R)^{H(n,n-r)}.
\tag{10}
\]
The already proved multidegree decomposition supplies the primitive
doubled-slot volume factors, and finite-unramified faithful-flat descent
returns the result to \(\mathbf Z_p\). Consequently the all-degree formula is
no longer conditional on a unit-minor conjecture:
\[
 \Delta^k\cong
 \bigoplus_{\ell=2}^{\min(k,g-k)}
 \bigoplus_{h=1}^{\ell-1}
 (R/p^{a(\ell-h)}R)^{N(g,k,\ell)H(\ell,h)},
\tag{11}
\]
where
\[
 N(g,k,\ell)=
 \binom{g}{k+\ell}\binom{k+\ell}{k-\ell}.
\tag{12}
\]
Conditional on the ambient identification in the preceding paragraph, this
is the full local integral Hodge-versus-divisor-product Smith quotient
for the marked, one-depth finite-etale elliptic graph locus. It agrees with
the independently proved codimension-two and codimension-three cases and
with every exact low-width computation.

## 5. Priority and scope

The ingredients must be credited separately:

* the moving weighted-operator definition and bounded-height Dyck rank are
  standard \(\mathfrak {sl}_2\) conformal-block theory;
* the Taylor identity is elementary;
* the new C909 content is recognizing the graph-shear osculating lattice as
  that moving conformal-block kernel, retaining its integral lattice at
  every prime by the DVR kernel argument, and translating its level
  filtration into the complete Smith quotient (11).

This does not prove the stronger universal local-freeness statement over
\(\mathbf Z[t_i,\Delta^{-1}]\): a kernel in a free module over that
higher-dimensional ring need not be locally free, and equal-characteristic
fibres can have larger single-power kernels. Nor does it identify a fixed
Temperley--Lieb integral lattice with the jet lattice, prove a Chow-ring
statement, remove the marked elliptic-power presentation, or cover
non-etale/Jordan collisions. It reduces the precise mixed-characteristic
finite-etale all-degree crown to checking that the graph product lattice is
the filtered dilation of the saturated web lattice inside the actual
exterior-coordinate lattice. That check, not the conformal-block rank
calculation, is now the earliest gate.

## 6. Final hostile checklist

1. Pinpoint the all-distinct-point characteristic-zero rank statement in
   (7), rather than only a generic rank.
2. Re-run the \(n=2,3,4\) matrices against the full Hasse tail over
   \(\mathbf Z_2\).
3. Verify in the graph normalization that the unscaled web lattice is
   saturated in the exterior-coordinate lattice and that its filtered
   dilation is exactly the divisor-product lattice.
4. Preserve the distinction between the prescribed graph divisor lattice
   and the full Neron--Severi lattice in the CM case.
