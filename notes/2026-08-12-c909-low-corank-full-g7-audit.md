# C909 — low-corank formula and all degrees through dimension seven

Date: 2026-08-12  
Status: hostile count/boundary audit; no manuscript, PDF, mirror, Lean, or
commit change

## Verdict: GO, conditional only on the established `ell=2,3` blocks

With the convention that `\binom nr=0` outside `0\le r\le n`, the proposed
low-corank formula is exactly the `ell=2,3` truncation of the general
multidegree formula:

\[
 Q^k\cong
 (R/\pi^a)^{N_2+3N_3}
 \oplus (R/\pi^{2a})^{N_3},
\tag{1}
\]

where

\[
 N_2=\binom g4\binom{g-4}{k-2},
 \qquad
 N_3=\binom g6\binom{g-6}{k-3}.
\tag{2}
\]

If `m=min(k,g-k)\le3`, no squarefree residual block with semilength
`ell\ge4` occurs.  Thus the codimension-two block, the squarefree
codimension-three block, and the saturated repeated-support blocks are all
the required inputs; no unresolved all-degree Dyck lemma is needed.

## 1. Exact equivalence with the support formula

The general count for a residual squarefree matching module of semilength
`ell` is

\[
 N(g,k,\ell)=\binom g{k+\ell}\binom{k+\ell}{k-\ell}.
\tag{3}
\]

For `ell=2`, direct factorial cancellation gives

\[
\begin{aligned}
N(g,k,2)
 &=\binom g{k+2}\binom{k+2}{k-2}\\
 &=\frac{g!}{4!(k-2)!(g-k-2)!}\\
 &=\binom g4\binom{g-4}{k-2}=N_2.
\end{aligned}
\tag{4}
\]

For `ell=3`, similarly

\[
 N(g,k,3)=
 \binom g6\binom{g-6}{k-3}=N_3.
\tag{5}
\]

The first block has residual profile `(0,1)`, hence one exponent-`a`
factor per component.  The six-slot block has profile `(0,1,1,1,2)`, hence
three exponent-`a` and one exponent-`2a` factors per component.  Equations
(4)--(5) therefore give (1).

Combinatorially, `N_2` chooses four single slots and then `k-2` doubled slots
from the remaining `g-4`; `N_3` chooses six single slots and then `k-3`
doubled slots from the remaining `g-6`.  This also makes the zero-boundary
convention transparent.

## 2. Boundaries in `k`

* `k=0,1` or `g-k=0,1`: both `N_2,N_3` vanish, so `Q^k=0`.
* `min(k,g-k)=2`: `N_3=0`; only the four-slot defect remains.
* `min(k,g-k)=3`: both blocks may occur; this is precisely the codimension
  three formula and its Poincare dual.
* For `g\le7`, every `0\le k\le g` satisfies `min(k,g-k)\le3`, so (1)
  covers all degrees.  For `g=8,k=4`, the hypothesis first fails and the
  semilength-four block is not covered by this audit.

The count is Poincare-symmetric:

\[
 \binom{g-4}{g-k-2}=\binom{g-4}{k-2},
 \qquad
 \binom{g-6}{g-k-3}=\binom{g-6}{k-3}.
\tag{6}
\]

This is a support-count consistency check; it does not follow merely from
unimodularity of total cohomology, since the Hodge and product sublattices
need not be perfect duals.

## 3. Complete table for `g\le7`

Only one side of the symmetric degree pairs is listed; the opposite degree
has the same quotient.

\[
\begin{array}{c|c|c}
g & k\text{ (nonzero cases)} & Q^k \\ \hline
0,1,2,3 & \text{none} & 0 \\ 
4 & 2 & (R/\pi^a)^1 \\ 
5 & 2,3 & (R/\pi^a)^5 \\ 
6 & 2,4 & (R/\pi^a)^{15} \\ 
6 & 3 & (R/\pi^a)^{33}\oplus R/\pi^{2a} \\ 
7 & 2,5 & (R/\pi^a)^{35} \\ 
7 & 3,4 & (R/\pi^a)^{126}\oplus (R/\pi^{2a})^7
\end{array}
\tag{7}
\]

For example, at `g=6,k=3`, `N_2=\binom64\binom21=30` and
`N_3=\binom66\binom00=1`, giving `30+3=33` exponent-one classes and one
exponent-two class.  At `g=7,k=3`, `N_2=\binom74\binom31=105` and
`N_3=\binom76\binom10=7`, giving `105+21=126` and seven exponent-two
classes.

The entries `g=5,k=3`, `g=6,k=4`, and `g=7,k=4` are not new blocks: they are
the Poincare-dual placements of the same support counts, with `N_3=0,1,7`
respectively as dictated by (2).

## 4. Proof boundary

This low-corank statement is a theorem once the following local inputs are
accepted:

1. the proved four-slot Smith profile `(0,1)` for arbitrary etale roots;
2. the proved six-slot profile `(0,1,1,1,2)`, including arbitrary roots and
   the dyadic unit-minor choice;
3. the primitive volume-factor embedding for repeated-support multidegrees;
4. faithful-flat base change of the marked integral Hodge and product
   lattices.

The unresolved all-`ell` filtered-web lemma begins at `ell=4` and is
irrelevant for every degree in `g\le7`.  No Chow or geometric realization is
being asserted: `Q^k` is the ambient integral Hodge/product quotient for the
marked finite-etale graph presentation.

## Bottom line

The compact `(N_2,N_3)` formula is exactly correct for
`min(k,g-k)\le3`, including all degrees for `g\le7`; there is no counting or
boundary correction.  The only qualifications are the inherited local
unit-minor, primitive-volume, and descent proof gates listed above.
