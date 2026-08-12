# C909 — osculating-web Smith crown: exact gate and proof route

Date: 2026-08-12

Status: conceptual re-formulation and hostile correction. The all-degree
Smith theorem is not yet proved. No manuscript, PDF, mirror, or Lean edit.

## The rank correction

Let \(W_n=S^{(n,n)}_{\mathbf Z}\) be the two-row Specht/web lattice, and put
\[
 F^rW_n=\bigcap_{|S|<r}\ker J_S.
\]
If \(H(n,h)\) counts Dyck paths of semilength \(n\) and exact maximum height
\(h\), the candidate rank formula is
\[
 \operatorname{rank}F^rW_n=\sum_{h\leq n-r}H(n,h).          \tag{1}
\]

The signed jet ranks recently recorded as
\[
 (0,1,4,5)\quad(n=3),\qquad(0,1,6,13,14)\quad(n=4)
\]
agree exactly with (1). Indeed
\[
 \operatorname{rank}J_{<r}
 =C_n-\sum_{h\leq n-r}H(n,h).
\]
The \(n=4\) successive jet increments \((1,5,7,1)\) are the Dyck exact-height
sequence \((1,7,5,1)\) in reverse order, because jet maps increase while
\(F^\bullet\) decreases. Restoring the endpoint sign removes false apparent
rank drops; it does not refute the Dyck rank target.

This is a rank-consistency correction only. It proves neither saturation nor
the claimed Smith factors.

## The universal intrinsic gate

Put
\[
 \mathscr C_{2n}=
 \operatorname{Spec}\mathbf Z[t_1,\ldots,t_{2n},\Delta^{-1}],
 \qquad\Delta=\prod_{i<j}(t_j-t_i).
\]
For a matching \(m\), let
\[
 f_m(u)=\prod_{\{i,j\}\in m,\ i<j}(u_j-u_i).
\]
The coefficient-one Plucker relations make their span the free Specht bundle
\(\mathscr W_n\) over \(\mathscr C_{2n}\). Define universal coordinate jets
\[
 J_S(f)=[w_S]f(t-w),\qquad
 \mathscr F^r=\ker\left(
 \mathscr W_n\longrightarrow\bigoplus_{|S|<r}\mathcal O_{\mathscr C_{2n}}
 \right).                                                   \tag{2}
\]
This is the multilinear Plucker/Hodge-algebra slice restricted to the
universal configuration of points on \(\mathbf P^1\), with its osculating
filtration. Projective coordinate changes act by triangular jet changes with
unit diagonal, so (2) depends only on the ordered projective spectral packet.

> **Unimodular osculating-web theorem.** For every \(n,r\), the quotient
> \(\mathscr F^r/\mathscr F^{r+1}\) is locally free over
> \(\mathscr C_{2n}\), has rank \(H(n,n-r)\), and is saturated in the
> preceding quotient.

Equivalently, the maximal Fitting ideal of each cumulative jet map is the
unit ideal after inverting \(\Delta\). This is the earliest exact all-degree
gate. A single minor with an extra factor is irrelevant unless all minors
retain that factor; a Bezout combination of minors may become a unit over
\(\mathbf Z[t,\Delta^{-1}]\).

## Why this proves the C909 crown

For a split one-depth finite-etale graph, set
\[
 u_i=t_i-p^az_i.
\]
The \(r\)-th osculating layer acquires the factor \(p^{ar}\). The universal
theorem gives the squarefree support quotient
\[
 \bigoplus_{r=1}^{n-1}
    \left(R/p^{ar}R\right)^{H(n,n-r)}.                       \tag{3}
\]
Primitive doubled-slot volume factors and finite-unramified descent then give
the all-degree Hodge/product Smith formula. Since the theorem is integral
over the configuration scheme, it supplies the missing dyadic saturation
without a separate argument.

## Proof route

First return is not a filtration decomposition, so a web-basis induction
cannot suffice. The viable route is an integral Rees/standard-monomial
argument:

1. realize \(\mathscr W_n\) as the multilinear degree-\(n\) component of the
   integral Hodge algebra of \(\operatorname{Gr}(2,2n)\);
2. form the Rees module
   \[
   \mathcal R_n=\bigoplus_{r\geq0}\mathscr F^r q^r;
   \]
3. construct a Plucker-compatible cellular complex indexed by partial
   noncrossing matchings or Dyck prefixes, with coefficient-one skein
   differentials times root differences;
4. prove it split exact after inverting \(\Delta\), equivalently obtain an
   ASL Grobner degeneration with unit leading coefficients.

This makes the Rees module flat, yields the homogeneous Dyck basis and
prevents the Schur-complement sums that invalidate naive pivot arguments.
An integral fusion or Jantzen realization of this Rees module would be an
excellent conceptual proof, but it is a route to construct, not an imported
theorem: it must reproduce the coordinatewise jets in (2) and prove
integral flatness.

## Exact current boundary

Settled: finite-etale graph saturation and all polarization divided powers
do not use this gate; the signed small-rank data are consistent with the
Dyck profile; and the all-degree question is intrinsically an osculating
Specht Fitting/Rees problem.

Open: prove the universal local-freeness theorem, identify the full
semilength-four Fitting ideal rather than one minor, and place doubled-slot
volume factors in the same primitive integral Rees formalism.

## Mystery ledger

The ej+tt pass replaces the false choice between a fragile Dyck guess and a
broader census. The genuine theorem is a universal integral
osculating-Specht flatness statement. Whether its Rees module is a known
fusion or Jantzen object remains the precise conceptual mystery.
