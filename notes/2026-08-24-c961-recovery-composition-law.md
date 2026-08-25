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
For numerical target-normalized costs, the corresponding closed input is the prescribed-coset
support function of the helper restriction, together with the intermediate target contribution.
If exact target coefficients are also to be transported, the boundary-conditioned lift kernel
retains them.  Both forms compose exactly and associatively.  The scalar threshold (\Gamma) does
not compose by itself: it forgets the functional labels that the next outer code constrains.

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

## 2. Target contributions and the boundary-conditioned kernel

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

For numerical support costs the target coefficient map can be compressed to its message
contribution.  Write
\[
 \phi=(\phi_P,\phi_J),
 \qquad
 u=\phi_Pa:T\to U_P=\operatorname{im}\phi_P.
\]
Then
\[
 \mathcal K_{\phi,P,T}(a,b)
 =\Lambda_{\phi_J,T}(b-u),
 \tag{C3}
\]
because the target coordinates are uncharged and the helper constraint is exactly
(\phi_Jy_J=b-u).  Thus the helper-restriction prescribed-coset function
(\Lambda_{\phi_J,T}) is enough for numerical composition.  The fuller kernel (\mathcal K) is
needed only when the actual target coefficients, rather than their minimum support cost, are part
of the output.

If the target set in (A\circ B) meets the inner block (e) in (P_e\subseteq E_B), write
(a=(a_e)_e).  Then
\[
 \boxed{
 \mathcal K_{A\circ B,P,T}(a,c)=
 \min_{\substack{x:T\to L^{E_A}\\\phi_Ax=c}}
 \sum_{e\in E_A}\mathcal K_{B,P_e,T}(a_e,x_e).
 }
 \tag{C4}
\]
Here (P) is the union of the copies of (P_e), and an empty (P_e) makes the local kernel equal to
the ordinary cost (\Lambda_{B,T}(x_e)).  The proof is the same blockwise disjoint-support argument
as for (C1).

Equivalently, set (u_e=\phi_{B,P_e}a_e).  The target-normalized numerical cost is
\[
 \boxed{
 \mu_{A\circ B,P,T}(c)=
 \min_{\substack{u,x:T\to L^{E_A}\\
                  u_e(T)\subseteq U_{P_e}\\
                  \phi_Au=\operatorname{id}_T,\ \phi_Ax=c}}
 \sum_{e\in E_A}\Lambda_{\phi_{B,J_e},T}(x_e-u_e).
 }
 \tag{C5}
\]
For (P_e=\varnothing), this local term is the ordinary full-block cost
(\Lambda_{B,T}(x_e)).  Formula (C5) is the exact numerical target composition law.  It also shows
why the single marginalized value (\mu_{I,P,T}(b)) is not the natural compositional input: the
next level optimizes over the labelled intermediate maps (u_e,x_e), not merely over their final
minimum.

## 3. Consequences for exact confinement

For a composite inner code (C=A\circ B), substitute (C1) and (C5) into C960's exact formula
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
at each level.  Its value is independent of parenthesization because (C4) is associative.

The same calculation gives the inner-dual distance needed by the zero-functional sector:
\[
 d((A\circ B)^\perp)=
 \min\left\{
 d(B^\perp),
 \min_{0\ne z\in\operatorname{FD}(A)}
 \sum_{e\in E_A}\Lambda_{B,\langle1\rangle}(z_e)
 \right\}.
 \tag{C6}
\]
The first term is a nonzero inner-dual word in one block; the second is a nonzero middle
functional tuple with independently minimum inner representatives.  This keeps the two sectors
separate at every depth.

The scalar threshold (\Gamma) is an output of this calculation, not a closed input to another
level: it retains only the least escape and discards the functional labels that the next level
constrains.

## 4. Explicit failure of scalar composition

Work over (F_2), identify the two-dimensional message space with (L=F_4), and write its nonzero
elements as (a=1), (b=\omega), and (c=\omega^2=a+b).  Take the first coordinate as target and let
the two represented inner codes have generator columns
\[
 I_1:(a,a,b),
 \qquad
 I_2:(a,a,c).
\]
For both codes the target has one-helper recovery cost (1) and the inner dual has distance (2), so
the zero-functional first-escape value is (3).  Their ordinary coset costs are
\[
\begin{array}{c|ccc}
 &a&b&c\\ \hline
 \Lambda_{I_1}&1&1&2\\
 \Lambda_{I_2}&1&2&1
\end{array}
\]
and their target-block helper costs are
\[
\begin{array}{c|ccc}
 &a&b&c\\ \hline
 \mu_{I_1}&0&2&1\\
 \mu_{I_2}&0&1&2.
\end{array}
\]
Let the length-two outer code have trace-dual (\operatorname{FD}(O)) equal to the
(L)-line spanned by ((1,\omega)).  Its nonzero sector has minimum
\[
 \min_{s\in L^\times}\bigl(\mu_{I_i}(s)+\Lambda_{I_i}(s\omega)\bigr)
 =\begin{cases}1,&i=1,\\2,&i=2.\end{cases}
\]
Hence the exact first nonconfined costs are (1) and (2), although the two zero-functional scalar
inputs are both (3).  A single scalar threshold therefore cannot be iterated; the labelled coset
costs in (C1) and (C5) are necessary.

## 5. Sharp support-distance envelopes

For fixed (B,T), let
\[
 \delta_{B,T}=\min_{0\ne z:T\to L}\Lambda_{B,T}(z),
 \qquad
 R_{B,T}=\max_{0\ne z:T\to L}\Lambda_{B,T}(z).
\]
If (c\ne0), then (C1) gives
\[
 \boxed{
 \delta_{B,T}\Lambda_{A,T}(c)
 \leq \Lambda_{A\circ B,T}(c)
 \leq R_{B,T}\Lambda_{A,T}(c).
 }
 \tag{C7}
\]
Every lift of (c) has at least (\Lambda_{A,T}(c)) nonzero coordinate maps, proving the lower
bound.  A support-minimizing lift has exactly that many, and each costs at most (R_{B,T}), proving
the upper bound.  Both constants are optimal without further hypotheses: take a one-coordinate
outer realization and prescribe a map attaining the relevant extremum.

Replacing (\Lambda_{B,T}) by the helper-restriction costs in (C5) gives the analogous sharp
weighted-support envelopes for target-normalized recovery.  These inequalities are the precise
coarsening obtained when the labelled fiber costs are replaced by their extreme nonzero values.

## Open gates

1. Audit generalized concatenated-code, trellis/dynamic-programming, generalized covering-radius,
   and min-plus factor-graph literature for (C1)--(C6).
2. Independently red-team the trace-tower identifications, the target normalization in (C5), and
   the explicit scalar separation.
3. Apply to the manuscript only if the exact closed object and priority boundary remain concise.
