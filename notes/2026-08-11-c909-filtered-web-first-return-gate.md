# C909 — filtered web lemma: exact first-return gate

Date: 2026-08-11

Status: hostile correction.  The proposed all-degree Dyck-height formula is
not proved by the present first-return paragraph.  This note isolates the
precise integral minor statement still required.  No manuscript, PDF,
mirror, Lean, or commit change.

## 1. The honest filtered matrix

Let `R` be a DVR and let

\[
 t_1,\ldots,t_{2n}\in R,\qquad
 \delta_{ij}=t_j-t_i\in R^\times\quad(i\ne j).
\tag{1}
\]

For a perfect matching `m` put

\[
 f_m(u)=\prod_{\{i,j\}\in m,\ i<j}(u_j-u_i).
\tag{2}
\]

The coefficient-one Pluecker skein relations give the free web module
`W_n`, with the noncrossing matchings as an `R`-basis.  Its rank is the
Catalan number `C_n`.  In the graph application one writes

\[
 u_i=t_i-p^a z_i.
\tag{3}
\]

For the combinatorial calculation it is essential to first make the formal
replacement `w_i=p^a z_i`; thus all coefficients below are taken in
`R[w_1,\ldots,w_{2n}]` and no division by `p` has occurred.  Define

\[
 J_S(f)=[w_S]f(t-w),\qquad
 F^rW_n=\bigcap_{|S|<r}\ker J_S.
\tag{4}
\]

Here `w_S=\prod_{s\in S}w_s`.  Since every edge factor is linear, the
matrix entries are completely explicit:

\[
 J_S(f_m)=
 \begin{cases}
  \epsilon(m,S)\displaystyle\prod_{
  \{i,j\}\in m,\ \{i,j\}\cap S=\varnothing}\delta_{ij},
  & |S\cap\{i,j\}|\leq1\text{ for every edge }\{i,j\}\in m,\\[6pt]
  0,&\text{otherwise}.
 \end{cases}
\tag{5}
\]

The sign is irrelevant.  Thus every *raw nonzero entry* is a unit times a
product of root differences, including at `p=2`.  This is the correct,
chart-level formulation of the desired filtered lemma.

## 2. Dyck indexing and the desired conclusion

A noncrossing matching is read left-to-right: write an up-step at a left
end and a down-step at a right end.  This is its Dyck path.  Let
`H(n,h)` be the number of such paths of exact maximum height `h`, and let
`B(n,h)=\sum_{q\leq h}H(n,q)`.  Equivalently, if
`b_{m,q}^{(h)}` counts prefixes of length `m` ending at height `q` and
staying in `0,\ldots,h`, then

\[
 b_{0,0}^{(h)}=1,\qquad
 b_{m+1,q}^{(h)}=b_{m,q-1}^{(h)}+b_{m,q+1}^{(h)},
 \qquad B(n,h)=b_{2n,0}^{(h)}.
\tag{6}
\]

The sought saturated web statement is exactly

\[
 \operatorname{rank}_R F^rW_n/F^{r+1}W_n=H(n,n-r),
 \qquad
 \operatorname{rank}_R F^rW_n=B(n,n-r).
\tag{7}
\]

After the substitution (3), a degree-`r` term receives precisely the factor
`p^{ar}`.  Hence (7), *if proved with saturated quotients*, gives the
claimed Smith factors.  The counting recurrence (6) by itself is only the
target rank calculation, not an elimination proof.

## 3. First return is not a filtered block decomposition

The set of noncrossing matchings has the familiar first-return disjoint
union

\[
 \operatorname{NC}_n=
 \coprod_{s=1}^n
 \bigl\{(1,2s)\sqcup m_{\rm in}\sqcup m_{\rm out}:
 m_{\rm in}\in\operatorname{NC}_{s-1},\;
 m_{\rm out}\in\operatorname{NC}_{n-s}\bigr\}.
\tag{8}
\]

It is a decomposition of the web *basis*.  It is not a decomposition of the
jet filtration: the constant row `J_\varnothing` is nonzero on every
first-return sector, and the kernel that begins `F^1` mixes them.  Already
for `n=2`, with

\[
 A=[12][34],\qquad B=[14][23],\qquad [ij]=u_j-u_i,
\tag{9}
\]

the two terms belong to different first-return sectors, yet

\[
 E=\delta_{14}\delta_{23}A-\delta_{12}\delta_{34}B\in F^1W_2.
\tag{10}
\]

Moreover

\[
 [w_1]E(t-w)=
 \pm\delta_{23}\delta_{34}\delta_{24}\in R^\times.
\tag{11}
\]

Thus `F^1W_2=RE`, and `F^2W_2=0`, giving the row `(1,1)` in this one
case.  It also shows exactly why an induction cannot simply "retain the
webs below a height cap": even its first nontrivial filtered vector is a
parameter-dependent combination across first-return sectors.

## 4. What an actual unit-pivot induction must supply

For a chosen ordered jet row `S` and two current columns `C,C'`, the only
legitimate Gaussian operation is

\[
 C'\longmapsto C'-\frac{J_S(C')}{J_S(C)}C,
\tag{12}
\]

when `J_S(C)` is a unit.  Formula (5) makes this safe for an *initial* raw
entry.  After one elimination, however, `J_{S'}(C')` is a Schur-complement
combination of products of `\delta_{ij}`.  Pairwise distinctness says that
each product is a unit; it says nothing about the sum.  For example, a sum
of two such products can vanish modulo the maximal ideal without any
`\delta_{ij}` vanishing.

Consequently the often-written cap transition matrix

\[
 \begin{pmatrix}U_{\rm open}&*\\0&D\,U_{\rm close}\end{pmatrix},
 \qquad D=\operatorname{diag}(\pm\delta_{ij}),
\tag{13}
\]

is not established by (5) or by the first-return decomposition.  Its lower
left zero would have to be proved for the *already eliminated columns*, not
just for individual matching products.  The informal statement that a jet
"hits both ends of a newly closed edge" proves only one vanishing in (5);
it does not give this block zero.

An exact proof gate is therefore the following nested-minor theorem.

> **Unimodular osculating-web theorem (needed).**  For every `n` and `r`
> there are sets of noncrossing-web columns and squarefree jet rows, nested
> as `r` increases, for which the corresponding row-reduced pivot determinant
> is `\pm\prod_{i<j}\delta_{ij}^{e_{ij}}`.  The number of pivots first
> appearing at level `r` is `H(n,n-r)`.

The product form, rather than merely a nonzero determinant over the fraction
field, is what proves both arbitrary-residue-characteristic rank and
saturation.  An equivalent proof may give an explicit cap-state order and
verify (13) by a Pluecker calculation at every step; it must prevent all
Schur-complement sums.

## 5. Verdict for the all-degree claim

Equations (4)--(6) give a finite, completely explicit matrix problem and
verify the proposed Dyck profile in the elementary `n=2` case.  They do not
provide the required nested minors for general `n`.  Hence the displayed
all-degree Hodge/product quotient and its claimed elementary divisors remain
conditional.  Neither finite-etale splitting nor the fact that all root
differences are units repairs this gap.  No failure of the numerical Dyck
profile is asserted here; the conclusion is only that the present
first-return argument is insufficient for a theorem.

## 6. Specht--Vandermonde route: exact input and its boundary

There is a useful reformulation, but it does not close the gate.  Under the
standard tableau/noncrossing matching bijection, `W_n` is the integral
two-row Specht lattice `S^{(n,n)}`.  For a tableau `T` with two-element
columns `{i,j}`, its Specht polynomial is exactly

\[
 \operatorname{sp}_T(u)=\prod_{\{i,j\}\text{ a column of }T}(u_j-u_i).
\tag{14}
\]

The standard-polytabloid theorem gives an integral basis indexed by standard
tableaux, and the two-row instance of (14) is the matching basis used above.
This is the classical polynomial realization of a Specht module; it is also
the `2\times2`-minor case of integral Grassmannian standard monomial theory.

The relevant classical **confluent Vandermonde identity** is likewise fully
integral if one uses Hasse derivatives.  For distinct `c_1,\ldots,c_s` and
positive multiplicities `m_i`, the map

\[
 R[u]_{<N}\longrightarrow\bigoplus_{i=1}^sR^{m_i},\qquad
 f\longmapsto\bigl(D^{(q)}f(c_i)\bigr)_{0\leq q<m_i},
 \quad N=\sum_i m_i,
\tag{15}
\]

has determinant, up to sign,

\[
 \prod_{i<j}(c_j-c_i)^{m_i m_j}.
\tag{16}
\]

Here `D^{(q)}u^d=\binom dq u^{d-q}`.  Thus (16) has neither trace nor
factorial denominators and is a unit over `R` whenever the differences are
units.  It follows either by the usual alternating-polynomial argument or
by the Hermite interpolation proof; in the latter normalization the Hasse
derivatives are exactly what removes the familiar factorial factors.

This identity is **not** yet an answer to the web problem.  The source of
(15) is a one-variable polynomial lattice of rank `N`, whereas (4) is the
restriction of a multiaffine two-row Specht lattice of rank `C_n`, with
coordinatewise jets.  An LGV determinant would close the gap only after one
constructs a network whose path matrix is this *specific* nested jet minor
and whose unique nonintersecting family has weight (16), or its product over
the relevant pairs.  No such network/matrix identification has been
constructed here.  Invoking LGV before that construction merely rewrites a
determinant with possible cancellation.

The closest checked sources provide only these two inputs:

* De Concini--Eisenbud--Procesi, *Hodge algebras*, Astérisque 91 (1982),
  §11, Theorem 11.1: integral standard-monomial/Pluecker straightening.
* The classical confluent-Vandermonde/Hermite-interpolation determinant
  (15)--(16), with Hasse derivatives for its characteristic-free form.

Neither statement proves the osculating rank profile (7) for
`S^{(n,n)}`.  In particular, a recent paper about *confluent Vandermonde
forms* is not a substitute: its displayed realizations use ordinary
derivatives and factorial normalizations, and it treats the full symmetric
group harmonic space rather than this two-row, coordinatewise-jet lattice.
