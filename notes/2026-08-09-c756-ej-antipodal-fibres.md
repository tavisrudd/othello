# C756 EJ upgrade: antipodal defect-two fibres

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
defect-two star-moment route; no manuscript edit

## Verdict

The centered moment collapse has an immediate geometric consequence.  On
every one of the 16 required complete directions, the degree-two residual
factor has zero linear coefficient.  Its roots are therefore antipodal:
\[
 \{u_t,-u_t\}.
\]
Thus a two-double fibre consists of two parallel collision lines exchanged
by central inversion about the centroid of the 55 star nodes.  A triple
fibre can occur only on the parallel line through that centroid.

The residual parameter is exactly the covariance quadratic.  Since the TT
separator argument proved that covariance is nonsingular, at most two of the
16 complete directions can have a triple fibre.  Equivalently, for every arc
point \(P\),
\[
 D_3(P)\le2,
 \qquad
 32\le D_2(P)\le34.                                       \tag{1}
\]
This is a new bounded restriction on the first open defect-two case.  It is
not yet a contradiction; all-two-double fibres remain possible when the
covariance form is anisotropic.

## 1. Centering removes the residual trace

Retain the affine model with \(r_0\) at infinity and let
\[
 S_0=\{v=(x_v,y_v)\}
\]
be its 55 star nodes.  Translate so that
\[
 \sum_{v\in S_0}v=0.                                      \tag{2}
\]
For direction \(t\), write \(c_v(t)=y_v-tx_v\) and
\[
 H(t,C)=\prod_{v\in S_0}(C-c_v(t)).                       \tag{3}
\]
The coefficient of \(C^{54}\) is
\[
 -\sum_vc_v(t)
 =-\sum_vy_v+t\sum_vx_v=0                                \tag{4}
\]
identically, not merely on the complete directions.

If \(t\) is complete, the defect-two factorization is
\[
 H(t,C)=(C^{53}-C)(C^2+a_tC+b_t).                         \tag{5}
\]
Comparing the \(C^{54}\) coefficient with (4) gives \(a_t=0\).  Hence
\[
 H(t,C)=(C^{53}-C)(C^2-u_t^2)                             \tag{6}
\]
over the algebraic closure, with \(u_t^2=-b_t\).  Complete splitting over
\(\mathbf F_{53}\) says in fact that \(u_t\in\mathbf F_{53}\).

In the two-double profile, \(u_t\ne0\), and the two repeated parallel lines
have coordinates \(u_t\) and \(-u_t\).  In the triple profile the residual
factor is a square.  Combined with zero trace, this forces \(u_t=0\), so the
tripled line is the line of direction \(t\) through the affine centroid.

## 2. The covariance quadratic is the excess parameter

Put
\[
 M=\sum_{v\in S_0}v,v^{\mathsf T}
\]
and let \(z_t=(-t,1)^{\mathsf T}\), so that
\(c_v(t)=z_t^{\mathsf T}v\).  The second projection moment is
\[
 p_2(t)=\sum_vc_v(t)^2=z_t^{\mathsf T}Mz_t.                \tag{7}
\]
Newton's identity and (5) give
\[
 p_2(t)=-2e_2(t)=-2b_t=2u_t^2.                            \tag{8}
\]
Therefore, on every complete direction,
\[
 \boxed{u_t^2=\tfrac12z_t^{\mathsf T}Mz_t.}               \tag{9}
\]

The covariance form is nonsingular by the degree-9 separator argument.  A
nonsingular binary quadratic has at most two projective zeros.  Equations
(6)--(9) show that its zero directions among the 16 centers are exactly the
triple fibres.  This proves
\[
 \#\{\text{triple complete directions at }P_0\}\le2.      \tag{10}
\]
If \(M\) is anisotropic, the number is zero; if it is split, it is at most
two according to whether its isotropic directions belong to the required
internal-center set.

## 3. Translation to the diagonal counts

At defect two, the pair-coupled identity is
\[
 32=D_2(P_0)-D_3(P_0).                                    \tag{11}
\]
Each triple fibre contributes exactly one concurrent three-matching, so
\(D_3(P_0)\) is the number of triple complete directions.  Combining
(10)--(11) yields (1).  Summed over all twelve arc points,
\[
 \sum_{P\in A}D_3(P)\le24,
 \qquad
 384\le\sum_{P\in A}D_2(P)\le408.                         \tag{12}
\]

This sharply limits the six-point correction that previously made the
masked diagonal expansion appear unbounded.  It does not evaluate the
remaining four-point mask, so (12) alone should not be fed back into the
closed pair-budget route.

## 4. Arithmetic normalization and remaining gate

Up to an affine linear change of coordinates, the nonsingular covariance
form \(z^{\mathsf T}Mz\) has one of the two binary square classes: split or
anisotropic.  Equation (9) requires it to take a square value on all 16
internal complete-center directions.  This character condition is adjacent
to, but not identical with, the internal/external character on the
distinguished passant \(r_0\).

A bare comparison of two binary quadratics on 16 points is not strong enough
for a Weil contradiction.  The next calculation must insert the eleven
arrangement directions and the degree-10 star generators.  The economical
case split is:

1. **anisotropic covariance:** all 16 fibres are two-double; test the
   generator contractions after normalizing \(M\) to the anisotropic norm;
2. **split covariance:** its at most two isotropic directions are the only
   possible triple fibres; test whether their conic types and the eleven
   arrangement directions are compatible with all 55 nodes being internal.

Stop if the square-value condition (9) is used without the star generators;
two unrelated quadratic half-sets can agree on 16 points.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Residual root sum on a complete direction | settled | zero after centroid normalization |
| Geometry of two-double fibres | settled | antipodal parallel lines |
| Geometry of a triple fibre | settled | line through the centroid |
| Residual square parameter | settled | half the covariance value, equation (9) |
| Triple fibres per arc point | bounded | at most two |
| Singular covariance | impossible | TT degree-9 separator argument |
| Remaining cases | open | nonsingular split and anisotropic covariance |

## Next action

Normalize nonsingular \(M\) separately in its split and anisotropic square
classes.  Contract the degree-10 star generators in each normal form, using
the antipodal residual identity (9), and test whether either case forces a
singular covariance or violates the conic type of an arrangement direction.
