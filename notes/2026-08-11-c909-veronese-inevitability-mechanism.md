# C909 — why the quadratic integral lift is inevitable, and what comes next

Date: 2026-08-11
Status: structural synthesis and corrected higher-degree boundary; no
manuscript, PDF, mirror, Lean, or certificate change

## 1. The weighted quadratic lattice

Let `O` be a DVR with uniformizer `pi`.  A symmetric matrix-of-ideals lattice
is the weighted degree-two monomial/Rees lattice

\[
 \mathcal L_h=\bigoplus_{\alpha\in2\Delta_{n-1}\cap\mathbf Z^n}
       \pi^{h(\alpha)}O\,x^\alpha\subset\operatorname{Sym}^2(O^n),
 \tag{1}
\]

with

\[
                 h(2e_i)=a_i,\qquad h(e_i+e_j)=e_{ij}.
\]

An arbitrary collection `e_ij` need not come from a one-parameter filtration
of `O^n`; “weighted degree-two monomial/Rees lattice” is the safe intrinsic
description.

Yu's tropical positive-semidefinite condition is

\[
                       a_i+a_j\le 2e_{ij}.
 \tag{2}
\]

It says that every edge midpoint lies on or above the affine chord joining
the endpoint heights, or equivalently that the height function gives the
trivial lower subdivision of `2Delta`.

## 2. Why the integral lift is inevitable in degree two

Every lattice point of `2Delta` is either a vertex or the midpoint of one
edge.  There are no other coefficient slots.  The only necessary
straightening identity is therefore

\[
 (u+v)(u+v)^t-uu^t-vv^t=uv^t+vu^t.
 \tag{3}
\]

Condition (2) is exactly what lets the three rank-one terms in (3) be chosen
inside the prescribed weighted lattice.  No division by two occurs because
the off-diagonal symmetric-matrix coordinate is `uv^t+vu^t` itself.  This
explains at once:

1. why the criterion is pairwise;
2. why the tropical condition has an integral signed lift over every DVR;
3. why the defect decomposes independently over pairs; and
4. why residue characteristic two causes no exception to the lifting theorem.

More precisely, the rank-one hull raises each midpoint height to

\[
 e'_{ij}=\max\left\{e_{ij},
              \left\lceil\frac{a_i+a_j}{2}\right\rceil\right\},
\]

and hence

\[
 \mathcal L_h/\langle\hbox{admissible rank-one forms}\rangle
 \cong
 \bigoplus_{i<j,\ e_{ij}<e'_{ij}}
 O/\pi^{e'_{ij}-e_{ij}}O.
 \tag{4}
\]

The length in (4) is the vertical distance from an edge midpoint to Yu's
cone.  This valuation defect can occur at every prime.  What is specifically
dyadic is the subsequent geometric statement: a failed midpoint inequality
produces an order-two divided-square obstruction because an ordinary product
has two cross terms.

## 3. Why the finite-etale graph theorem becomes automatic

At each positive depth, split the finite-etale slope algebra after a finite
unramified coefficient extension.  On a scalar block write

\[
                         T_i=t_iI+p^{a_i}S_i.
\]

The graph-basis integrality conditions give the exact cross depth

\[
 e_{ij}=\max\{a_i,a_j,
              a_i+a_j-v_p(t_j-t_i)\}.
 \tag{5}
\]

Thus `e_ij>=max(a_i,a_j)`, and therefore (2) holds automatically.  Etaleness
is used to split the slope into scalar slots at each fixed truncated depth;
it is not a claim that arbitrary lifts at different depths have unit
difference.  Cross-depth coincidence only changes the third term in (5) and
does not threaten the midpoint inequality.  Same-depth non-etale collision
is the genuine boundary because the idempotent splitting itself may fail.

Once the split graph Neron--Severi lattice is rank-one generated, its
rank-one divisor classes pull back to decomposable alternating forms and
square to zero.  For a sum `D=sum D_i` of such classes,

\[
                       D^{[k]}=\frac{D^k}{k!}
                       =\sum_{|I|=k}\prod_{i\in I}D_i.
 \tag{6}
\]

Faithful-flat descent and localization then give the all-degree integral
divisor-product theorem.  The old mixed-adjugate calculation is no longer
the mechanism; it is one degree of the rank-one straightening theorem.

## 4. The first higher-degree warning

The corresponding statement for pure powers in degree at least three is not
controlled by the lower subdivision alone.  This fails in the smallest
possible case.  Let `V=Ze+Zf` and work in `Gamma^3(V)`.  In the basis

\[
 e^{[3]},\quad e^{[2]}f,\quad ef^{[2]},\quad f^{[3]},
\]

the two middle coordinates of a pure divided cube are

\[
                   (ae+bf)^{[3]}:\qquad (a^2b,ab^2).
 \tag{7}
\]

They have the same parity, since

\[
                         a^2b-ab^2=ab(a-b)\equiv0\pmod2.
\]

The vectors `(1,1)` and `(4,2)` show that their span is exactly the
same-parity sublattice of `Z^2`.  Hence the pure divided cubes have an exact
`Z/2` cokernel although the height on `3Delta_1` is flat and its subdivision
is trivial.

This corrects two tempting extrapolations:

* trouble need not wait for a support-three lattice point; it already occurs
  along an edge of `3Delta`; and
* the ordinary symmetric-power polarization identity with coefficient `d!`
  cannot be transferred directly to `Gamma^d`.  The integral comparison
  between `Sym^d` and `Gamma^d` has its own content.

The higher-degree invariant is therefore an **evaluation/polarization
lattice**, not just a tropical subdivision.  It records congruences among
the functions `a^{d-r}b^r` and their multivariable analogues.  Its defect is
killed after inverting `d!`, but its exact primary decomposition requires a
new calculation.

## 5. What this now predicts

The corrected prediction has two independent inputs:

1. a tropical height defect, measuring failure of the lower-subdivision
   inequalities; and
2. an integral evaluation defect that can survive even for a flat height.

For `d=2`, the second input vanishes in the symmetric-matrix normalization,
so Yu's cone completely controls integral lifting.  For `d>=3`, both inputs
are required.  The next structural target is to compute the pure-power span
inside the weighted divided-power lattice as an integer-valued-polynomial
evaluation lattice, then combine it with the face filtration of `dDelta`.

The appearance of congruences and prime-power contents makes a comparison
with C908's carry/ghost complex plausible, but no chain map or equivalence is
presently proved.  The degree-three example shows that such a comparison
cannot require nilpotent slopes or higher-dimensional faces: a universal
polarization-content term must already be present before the nilpotent carry
term is added.

## 6. Priority boundary

The polyhedral skeleton is known.  Yu proves that tropical PSD quadratic
forms are exactly the height functions giving the trivial subdivision of
`2Delta`, and that this cone is the tropical convex hull of tropical
rank-one symmetric matrices.  The lattice-point observation and quadratic
polarization identity are elementary.

The candidate new content is the integral arithmetic synthesis:

* the signed DVR lifting criterion and exact direct-sum defect (4), including
  residue characteristic two;
* the proof that finite-etale graph Neron--Severi lattices automatically
  satisfy Yu's condition by two-sided source integrality;
* the resulting all-degree ordinary divisor-product saturation; and
* the corrected separation of tropical and evaluation defects beyond degree
  two.

No exact predecessor for this package was located in the bounded audit at
`2026-08-11-c909-veronese-inevitability-literature-audit.md`.  The safe
description is a **plausibly new integral-to-geometric synthesis under the
recorded coverage**, not a new tropical PSD theorem.  The higher-degree
evaluation theory is a research target, not an established result.

## Mystery ledger

* **Settled:** quadratic lifting is inevitable because `2Delta` has only
  vertices and edge midpoints and (3) straightens each midpoint independently.
* **Settled:** the exact valuation defect is the direct sum (4).
* **Settled:** trivial subdivision alone does not control pure powers from
  degree three onward; flat `3Delta_1` already has a `Z/2` defect.
* **Open:** compute the weighted pure-power evaluation lattice in every
  degree and residue characteristic.
* **Open:** separate its universal polarization content from the additional
  nilpotent carry measured in C908.
* **Open:** construct a canonical comparison with the ghost/de Rham complex;
  no theorem-grade bridge is currently claimed.
