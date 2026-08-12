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
