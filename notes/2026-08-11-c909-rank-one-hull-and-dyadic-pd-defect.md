# C909 — rank-one hull and the first dyadic divided-power defect

Date: 2026-08-11  
Status: exact local consequence of the tropical criterion; human proof; no
manuscript, PDF, mirror, Lean, or certificate change

## 1. Exact rank-one hull

For the symmetric DVR ideal lattice `L(a,e)` of
`2026-08-11-c909-tropical-rank-one-classification.md`, put

\[
 m_{ij}=\left\lceil\frac{a_i+a_j}{2}\right\rceil,
 \qquad e'_{ij}=\max(e_{ij},m_{ij}).
\]

Then the integral span of all admissible rank-one forms is exactly

\[
                    L(a,e')\subset L(a,e).
 \tag{1}
\]

Necessity is the pairwise valuation bound for every rank-one form. Sufficiency
is the explicit rank-one straightening at depth `e'_ij`, together with the
diagonal generators. Consequently

\[
 L(a,e)/\langle\text{rank-one forms}\rangle
  \cong\bigoplus_{i<j:e_{ij}<m_{ij}}
       p^{e_{ij}}O/p^{m_{ij}}O.
 \tag{2}
\]

Thus the tropical inequalities compute the whole rank-one defect, not only
its vanishing.

## 2. Dyadic degree-two converse

Let `p=2` and suppose one pair fails midpoint convexity:

\[
                       2e_{ij}<a_i+a_j.
 \tag{3}
\]

On the corresponding coefficient two-plane take the integral divisor

\[
                   D=2^{e_{ij}}(E_{ij}+E_{ji}).
\]

Its divided square is integral and its top coefficient on that two-plane has
valuation `2e_ij` (up to sign). The ordinary products of two allowed divisor
classes have top-coefficient ideal

\[
       (,2^{a_i+a_j},\ 2^{,2e_{ij}+1},).
 \tag{4}

Indeed, a diagonal-by-diagonal product contributes depth `a_i+a_j`; a
cross-by-cross product carries the two orderings and hence the additional
factor `2`; diagonal-by-cross terms have the wrong bidegree. Therefore (3)
gives

\[
 \operatorname{ord}\left(rac{D^2}{2}mod P^2\right)ge2,
 \qquad
 2\frac{D^2}{2}=D^2\in P^2,
\]

so this class has exact order two in the divided-square/product quotient.

This proves an actual defect in the local two-axis coefficient quotient. It
also proves the corresponding global cohomological defect whenever the marked
coefficient two-plane descends to an abelian subtorus of the graph quotient,
or whenever an algebraic cohomological projector onto that plane is supplied.
Such a subtorus need not descend for a mixed or unequal-depth graph, so no
unconditional global restriction argument is asserted here.

At odd primes, the cross-by-cross coefficient `2` is a unit; (4) contains
`p^{2e_ij}`, so this degree-two argument gives no obstruction. Failure of
rank-one generation can still occur there, but an actual divided-power defect
requires a higher-degree or different functional.

## Consequence

For dyadic symmetric ideal coefficient lattices, every failed tropical
midpoint inequality has a canonical order-two divided-square witness in its
local two-axis coefficient quotient. It is a global defect under the stated
subtorus/projector hypothesis.

This is a local cohomological statement. It assumes the coefficient-plane
restriction is realized in the marked elliptic-power presentation and makes
no Chow assertion.

## Mystery ledger

* **Settled:** the exact rank-one cokernel is the direct sum (2).
* **Settled:** every dyadic tropical failure produces an actual order-two
  divided-square defect in the local two-axis coefficient quotient.
* **Open:** descend that witness globally without assuming a coefficient
  subtorus or an algebraic projector.
* **Open:** at odd primes, identify the first degree detecting a failed
  midpoint inequality and compute its exact order.
* **Open:** package the pairwise dyadic witnesses without a chosen coefficient
  basis.
