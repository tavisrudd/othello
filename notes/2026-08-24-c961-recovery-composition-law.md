# C961 — Composition of prescribed-coset recovery costs

**Lane**: `complete-ports`

**Status**: ACTIVE; EXACT ORDINARY COMPOSITION AND THE REQUIRED TARGET-BOUNDARY REFINEMENT DERIVED;
PRIORITY AND COUNTEREXAMPLE GATES OPEN

## Question

For a tower of finite fields (F\subseteq L\subseteq M), let (B) be an inner
(F)-linear represented code with message space (L), let (A) be an (L)-linear represented code with
message space (M), and let (A\circ B) be their concatenation.  Determine whether the minimum union
supports of prescribed cosets, the target-normalized costs, and the exact nonconfinement thresholds
compose from the corresponding data of (A) and (B).

The target is an equality, not merely a support-distance estimate.  Zero and nonzero
outer-functional sectors must remain separate.

## Current answer

The ordinary prescribed-coset support function composes by an exact min-plus substitution.
The target-normalized scalar minimum does not retain enough boundary data to be closed under
composition.  The smallest evident closed object is the boundary-conditioned support kernel that
keeps the prescribed target coefficient map as well as the prescribed functional map.  These
kernels compose exactly and associatively; the current (\lambda), (\mu), and (\Gamma) are obtained
from them by specialization and minimization.

## 1. Ordinary prescribed-coset support

Use the trace pairing to identify
\[
 \operatorname{Hom}_F(L,F)\cong L,
 \qquad
 \operatorname{Hom}_L(M,L)\cong M,
 \qquad
 \operatorname{Hom}_F(M,F)\cong M.
\]
Let
\[
 \phi_B:F^{E_B}\longrightarrow L,
 \qquad
 \phi_A:L^{E_A}\longrightarrow M
\]
be the resulting dual restriction maps.  The composite map on an array
(y=(y_e)_{e\in E_A}) is
\[
 \phi_{A\circ B}(y)=\phi_A\bigl((\phi_B(y_e))_{e\in E_A}\bigr).
\]
For a finite-dimensional (F)-space (T) and an (F)-linear prescribed map (b:T\to L), put
\[
 \Lambda_{B,T}(b)=
 \min_{\phi_By=b}|\operatorname{supp}y(T)|.
\]
For (c:T\to M), the exact composition law is
\[
 \boxed{
 \Lambda_{A\circ B,T}(c)=
 \min_{\substack{x:T\to L^{E_A}\\\phi_Ax=c}}
 \sum_{e\in E_A}\Lambda_{B,T}(x_e).
 }
 \tag{C1}
\]

**Proof.** Any lift (y:T\to F^{E_A\times E_B}) determines the intermediate maps
(x_e=\phi_B y_e).  The final support is a disjoint union over inner blocks, so its cardinality is
the sum of their union supports.  At fixed (x), the inner-block lifts are independent and attain
their minima separately.  Minimizing over the lifts (x) of (c) gives (C1).  No cancellation across
blocks is possible because their coordinate sets are disjoint.

Repeated application of (C1) is associative: both parenthesizations minimize over the same full
array of intermediate maps and add the same leaf-block support costs.  This is ordinary elimination
of independent variables in the min-plus semiring.

## 2. Boundary-conditioned support kernel

Let a represented code have dual restriction map (\phi:F^E\to V) and split
(E=P\sqcup J).  For maps
\[
 a:T\to F^P,
 \qquad b:T\to V,
\]
define
\[
 \mathcal K_{\phi,P,T}(a,b)=
 \min\left\{
 |\operatorname{supp}y_J(T)|:
 y:T\to F^E,\ y_P=a,\ \phi y=b
 \right\},
 \tag{C2}
\]
with value infinity when the fiber is empty.  This is a literal boundary-conditioned minimum
support, not a new metric.

If the target set in (A\circ B) meets the inner block (e) in (P_e\subseteq E_B), write
(a=(a_e)_e).  Then
\[
 \boxed{
 \mathcal K_{A\circ B,P,T}(a,c)=
 \min_{\substack{x:T\to L^{E_A}\\\phi_Ax=c}}
 \sum_{e\in E_A}\mathcal K_{B,P_e,T}(a_e,x_e).
 }
 \tag{C3}
\]
Here (P) is the union of the copies of (P_e), and an empty (P_e) makes the local kernel equal to
the ordinary cost (\Lambda_{B,T}(x_e)).  The proof is the same blockwise disjoint-support argument
as for (C1).

The target-normalized cost in C960 is a marginal of this kernel:
\[
 \mu_{I,P,T}(b)=
 \min_{G_Pa=\operatorname{id}_T}\mathcal K_{\phi_I,P,T}(a,b).
 \tag{C4}
\]
Thus (\mu) alone has already forgotten which target coefficient map attained the minimum.  A later
concatenation can couple that map to an outer coordinate map, so an exact composition law cannot in
general use only the marginalized values (\mu).  Formula (C3), followed by the normalization
minimum (C4), is the closed exact replacement.

## 3. Consequences for exact confinement

For a composite inner code (C=A\circ B), substitute (C1) and (C3) into C960's exact formula
\[
 \Gamma_{j,T}(O,C)=
 \min\left\{
 \rho_T(C)+d(C^\perp),
 \min_{0\ne H:T\to\operatorname{FD}(O)}
 \left(
 \mu_{C,P,T}(H_j)+\sum_{h\ne j}\Lambda_{C,T}(H_h)
 \right)
 \right\}.
\]
This gives an exact nested min-plus expression from the leaf-code kernels and the functional duals
at each level.  Its value is independent of parenthesization because (C3) is associative.

The scalar threshold (\Gamma) is an output of this calculation, not a closed input to another
level: it retains only the least escape and discards the functional and target-boundary labels that
the next level constrains.  A concrete separation example is still required before recording this
non-composability as a theorem.

## Open gates

1. Construct the smallest explicit pair showing that identical marginalized (\mu) or identical
   first-level (\Gamma) values do not determine a second-level threshold.
2. State and prove the sharp coarse inequalities obtained by replacing each local kernel in (C3)
   by its minimum and maximum nonzero costs.
3. Audit generalized concatenated-code, trellis/dynamic-programming, generalized covering-radius,
   and min-plus factor-graph literature for (C1)--(C3).
4. Apply to the manuscript only if the exact closed object and priority boundary remain concise.
