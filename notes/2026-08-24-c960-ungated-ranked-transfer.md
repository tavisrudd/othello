# C960 ungated ranked transfer

**Lane**: `complete-ports`

**Date**: 2026-08-24
**Status**: active; theorem proved, priority audit in progress, no manuscript change yet

## Question

Can the exact ungated weighted formula for one recovered coordinate be extended to an arbitrary
nonzero subspace of internally recoverable target combinations, so that the distance-gated RGHW
theorem and the pointed finite-length theorem become specializations of one exact formula?

## Setup

Let the represented inner code have coordinate split (E=P\sqcup J), let

\[
 \Phi_I:\mathbb F_q^E\longrightarrow L^*
\]

be the inner functional map, and let (0\ne T\le W_P=\operatorname{im}G_P\cap
\operatorname{im}G_J). Fix a section

\[
 \alpha:T\longrightarrow\mathbb F_q^P,
 \qquad G_P\alpha=\operatorname{id}_T.
\]

For (B\in\operatorname{Hom}_{\mathbb F_q}(T,L^*)), define the ordinary and target-constrained
minimum-support lifting functions

\[
 \lambda_{I,T}(B)=
 \min\left\{
 |\operatorname{supp}Y(T)|:
 Y:T\longrightarrow\mathbb F_q^E\text{ linear},\ 
 \Phi_IY=B
 \right\},
\]

\[
 \mu_{I,P,T}(B)=
 \min\left\{
 |\operatorname{supp}\beta(T)|:
 \beta:T\longrightarrow\mathbb F_q^J\text{ linear},\ 
 \Phi_I(\alpha,\beta)=B
 \right\}.
\]

The value is (+\infty) if the displayed lifting set is empty. Here support of the image of a
linear map is the union of the supports of all its values. A different section changes the
target-coordinate normalization but not the exact obstruction after that normalization has been
fixed. In particular,

\[
 \mu_{I,P,T}(0)=\rho_T(I),
\]

the least helper-union size of an internal normalized recovery system for (T).

Let (O\le L^N) be an (L)-linear outer code, fix block (j), and assume the coordinate projection
(O\to L) at (j) is nonzero, hence surjective. Put

\[
 \mathcal B_T(O)=
 \operatorname{Hom}_{\mathbb F_q}\bigl(T,\operatorname{FD}(O)\bigr).
\]

For (B\in\mathcal B_T(O)), write (B=(B_h)_{h=1}^N), where
(B_h:T\to L^*).

## Exact theorem

Define

\[
 \Gamma_{j,T}(O,I)=
 \min\left\{
 \mu_{I,P,T}(0)+d(I^\perp),
 \min_{0\ne B\in\mathcal B_T(O)}
 \left(
 \mu_{I,P,T}(B_j)+
 \sum_{h\ne j}\lambda_{I,T}(B_h)
 \right)
 \right\}.
\tag{C960.1}
\]

Then \(\Gamma_{j,T}(O,I)\) is exactly the least helper-union size of a nonconfined normalized
recovery system for (T) at block (j) in (O\circ I).

For (1\le t\le\ell=\dim W_P), put

\[
 \Gamma_{j,t}(O,I)=
 \min_{\substack{T\le W_P\\ \dim T=t}}
 \Gamma_{j,T}(O,I).
\tag{C960.2}
\]

Then every normalized recovery system of helper cost at most (r), for every internally
recoverable (t)-dimensional target subspace, is confined to block (j) if and only if

\[
 r<\Gamma_{j,t}(O,I).
\tag{C960.3}
\]

Below that threshold, restriction to the target block and zero extension are inverse bijections on
normalized recovery systems and preserve coefficients and exact helper supports.

## Proof

A normalized recovery system is an \(\mathbb F_q\)-linear map

\[
 Y:T\longrightarrow (O\circ I)^\perp
\]

whose target-block coordinates have the prescribed target normalization. Write (Y_h) for its
restriction to inner block (h), and put

\[
 B_h=\Phi_IY_h.
\]

The blockwise functional-dual decomposition, applied pointwise to every (u\in T), says that
((B_h(u))_h\in\operatorname{FD}(O)). Linearity in (u) therefore gives

\[
 B=(B_h)_h\in\operatorname{Hom}_{\mathbb F_q}(T,\operatorname{FD}(O)).
\]

Conversely, choosing compatible linear lifts (Y_h) for the components of any such (B) produces
a linear map into the concatenated dual. The target-block normalization is exactly the constraint
in the definition of \(\mu_{I,P,T}(B_j)\).

The helper-coordinate sets of distinct inner blocks are disjoint. Hence, for fixed nonzero (B),
the minimum possible helper-union size is the sum of the independently minimized block supports,

\[
 \mu_{I,P,T}(B_j)+\sum_{h\ne j}\lambda_{I,T}(B_h).
\]

The projection hypothesis is used only here: if a functional-dual tuple were supported solely at
block (j), testing it against outer words whose (j)-th coordinate ranges over all of (L)
would force its (j)-th functional to vanish. Thus every nonzero (B\in\mathcal B_T(O)) has a
nonzero component outside block (j), and every realization in the nonzero-(B) sector is
nonconfined.

If (B=0), every block map takes values in (I^\perp=\ker\Phi_I). The target block costs at least
\(\mu_{I,P,T}(0)=\rho_T(I)\). Nonconfinement requires a nonzero map
(T\to I^\perp) in some other block. Every such map has image support at least (d(I^\perp)),
and equality is attained by

\[
 u\longmapsto f(u)v,
\]

where (0\ne f\in T^*) and (v\) is a minimum-weight word of (I^\perp). Hence the exact
zero-functional cost is

\[
 \rho_T(I)+d(I^\perp).
\]

The zero and nonzero functional sectors are exhaustive, which proves (C960.1). Minimizing over all
(t)-dimensional (T\le W_P) proves (C960.2)--(C960.3), including necessity because a minimizing
subspace and minimizing lifts attain the displayed cost. The coefficient/support bijection below
threshold is the same restriction--zero-extension argument as in the gated theorem.

## Specializations

### One target coordinate

For (P=\{x\}) and \(\dim T=1\), helper support is total word support minus the normalized target
coordinate. After identifying a basis of (T) and rescaling the target coefficient, (C960.1)
becomes the existing pointed weighted formula:

\[
 \Gamma_{j,1}(O,I)=Z_{j,x}(O,I)-1.
\]

Thus (r<\Gamma_{j,1}) is exactly (Z_{j,x}>r+1). This is a global-minimum specialization; no
pointwise identity between the target-constrained lifting functions is needed or claimed.

### Outer-dual-distance gate

Under trace duality, a nonzero element of \(\operatorname{FD}(O)\) has block support at least
(d(O^\perp)). If (0\ne B\in\mathcal B_T(O)), then some (u\in T) gives a nonzero tuple
(B(u)), so at least (d(O^\perp)-1) helper blocks have nonzero lifting cost. Consequently

\[
 d(O^\perp)>r+1
 \quad\Longrightarrow\quad
 \text{every nonzero-functional sector costs more than }r.
\]

At radius (r), the exact criterion therefore reduces to

\[
 r<\rho_T(I)+d(I^\perp).
\]

Minimizing over \(\dim T=t\) and using

\[
 \min_{\dim T=t}\rho_T(I)=M_t(D_P,K_P)
\]

recovers the manuscript's gated theorem exactly:

\[
 r<M_t(D_P,K_P)+d(I^\perp).
\]

The additive RGHW expression is the zero-functional candidate, hence an upper bound on the first
ungated escape cost. It becomes the exact numerical first escape cost once, for example,

\[
 d(O^\perp)\ge M_t(D_P,K_P)+d(I^\perp)+1.
\]

It should not be described as a general lower bound on the ungated obstruction.

## Anti-smuggling audit

- The optimization is over linear maps (T\to\operatorname{FD}(O)), not independently chosen
  functional tuples for a basis of (T). This retains all linear compatibility conditions.
- Each \(\lambda_{I,T}\) and \(\mu_{I,P,T}\) minimizes the union support of the whole image
  subspace. Summing per-vector or per-basis minima would be invalid and is not used.
- Blockwise additivity is legitimate only because distinct inner blocks have disjoint coordinate
  sets. No within-block support additivity is asserted.
- The target projection hypothesis is essential for identifying a nonzero functional sector with
  nonconfinement. Without it, a nonzero tuple supported at the target block can be block-confined.
- The zero-functional external cost is (d(I^\perp)), not a higher generalized weight, because a
  rank-one external perturbation suffices regardless of \(\dim T\).
- The theorem gives an exact finite-length optimization but not a closed formula for its lifting
  functions. The RGHW formula is the computable specialization after the outer-distance gate.
- No computation, certificate, or formal theorem is used in the proof.

## Literature-audit status

The first broad four-query web call exceeded the context-output budget and was discarded as a
command-shaping failure. It supplies no evidence. The replacement audit uses narrow primary-source
queries, records every consulted source with read depth, and distinguishes classical quotient/code
support invariants from the exact concatenated-recovery formula above.

## Mystery ledger

To be completed after the priority, manuscript, and closeout gates.
