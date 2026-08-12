# C909 — exhaustive distinct-root falsification test for the Dyck filtration

Date: 2026-08-11  
Status: bounded finite-field audit; no manuscript, PDF, mirror, Lean, or
commit change

## Verdict

No rank-profile drop was found beyond root collisions in the tested cases.
The pairwise-etale condition (all `t_i-t_j` units) survives the following
exhaustive tests:

\[
\begin{array}{c|c|c|c}
\text{squarefree size}&\text{field}&\text{distinct tuples tested}&\text{cumulative rank profile}\\ \hline
6&\mathbf F_7&5040\text{ total }(120\text{ affine-normalized})&(1,4,5,5)\\
6&\mathbf F_8&20160\text{ total }(360\text{ normalized})&(1,4,5,5)\\
6&\mathbf F_9&60480\text{ total }(840\text{ normalized})&(1,4,5,5)\\
6&\mathbf F_{11}&332640\text{ total }(3024\text{ normalized})&(1,4,5,5)\\
8&\mathbf F_8&40320\text{ total }(720\text{ normalized})&(1,6,13,14,14).
\end{array}
\]

The corresponding Smith valuation rows are therefore

\[
\ell=3:\quad 0,1^3,2,
\qquad
\ell=4:\quad 0,1^5,2^7,3.
\]

The `F_8` test is characteristic two and so gives a direct dyadic check: no
extra sign or factor-of-two degeneration appeared.  This is evidence that
pairwise etale roots are the right local hypothesis, not a proof of the
all-`ell` filtered matching lemma.

## Normalization and completeness

The coefficient-block ranks are invariant under affine change
`t_i\mapsto a t_i+b` with `a\ne0`, and under permutation of slot labels.
For an ordered tuple, the unique affine normalization of the first two
entries is `(t_1,t_2)=(0,1)`.  Thus the normalized counts are:

* `ell=3`, `q=7`: `(q-2)P_4=120`, representing all `7P_6=5040` tuples;
* `ell=3`, `q=8`: `6P_4=360`, representing all `8P_6=20160` tuples;
* `ell=3`, `q=9`: `7P_4=840`, representing all `9P_6=60480` tuples;
* `ell=3`, `q=11`: `9P_4=3024`, representing all `11P_6=332640` tuples;
* `ell=4`, `q=8`: `6!=720`, representing all `8!=40320` tuples.

The squarefree size eight test uses the minimal field with enough distinct
roots and is exhaustive modulo the affine normalization.  It is stronger
than a random-root check and includes every ordering of the eight roots.

## Computation

For each noncrossing matching `P` on `2ell` slots, expand

\[
 v_P=\prod_{(i,j)\in P}(\delta_{ij}X_iX_j+p^aB_{ij})
     =\sum_{r=0}^{ell}p^{ar}v_{P,r}.
\]

For each `r`, form the coefficient matrix `F_{ell,r}` in the exterior basis
with exactly `2r` `Y` letters.  Row-reduce the vertically concatenated blocks
`F_{ell,0},…,F_{ell,r}` over the finite field.  The expected profiles are

\[
\rho_{3,*}=(1,4,5,5),
\qquad
\rho_{4,*}=(1,6,13,14,14).
\]

For the odd fields, arithmetic is ordinary prime-field arithmetic.  For
`F_8`, arithmetic uses `F_2[u]/(u^3+u+1)`; for `F_9`,
`F_3[u]/(u^2+1)`.  The `F_9` run was for the six-slot case; the exhaustive
eight-slot run was `F_8`.

## Scope and remaining gap

The audit rules out the most immediate hostile alternatives:

* a hidden dependence on the ordering of distinct roots;
* a special odd-prime collision not visible from `δ_ij\ne0`;
* a characteristic-two sign/factorial failure at `ell=3` or `4`.

It does not prove that every maximal minor needed for the all-`ell` rank
profile is a unit times a Vandermonde product, nor does it prove the web
unitriangular lemma for arbitrary unit root-form coefficients.  The correct
repair remains an all-`ell` filtered straightening theorem; the present note
supports retaining pairwise etale roots as its likely sharp hypothesis.
