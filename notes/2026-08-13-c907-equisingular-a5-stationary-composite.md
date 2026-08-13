# C907 equisingular \(A_5\) test for the stationary second composite

**Lane:** clebsch

**Verdict:** the corrected stationary lattice at a nodal cubic-surface fibre
has type \(A_5\), and its Weyl symmetry gives a sharp *conditional* geometric
exclusion of the second Rees composite.  If the strict cubic Rees object
descends through root-marked equisingular deformations and its endpoint
graded factors are \(W(A_5)\)-trivial, then the stationary composite vanishes.
This would rule out the local length-three string.  Neither the Picard--
Lefschetz disk nor Weyl symmetry alone proves those two strict hypotheses:
the standard \(A_5\) representation admits a nonzero equivariant stationary
composite.  The exact remaining carrier calculation is therefore a finite
representation test on the two endpoint Rees grades, followed only when that
test permits a stationary tensor.

This is a correction-aware report: the stationary lattice is \(A_5\), not
\(D_5\).  The correction changes the symmetry group, but not the earlier
Picard--Lefschetz parity obstruction.

## 1. The stationary root lattice and its geometric symmetry

Let \(L=E_6(-1)\otimes A\), where \(A=\mathbf Z[1/6]\), and let
\(\delta\) be the vanishing root of a one-node cubic surface.  Then

\[
 M=\delta^\perp\cap L\cong A_5(-1)\otimes A. \tag{1}
\]

For completeness, the determinant calculation is intrinsic:

\[
 \det(\delta^\perp\cap E_6)
 =\frac{\delta^2\det(E_6)}{\operatorname{div}(\delta)^2}
 =\frac{2\cdot3}{1^2}=6. \tag{2}
\]

It identifies the type as \(A_5\), and can be made explicit.  In the
\(E_6\) diagram with edges

\[
 \alpha_0-\alpha_2-\alpha_3-\alpha_4-\alpha_5,
 \qquad \alpha_1-\alpha_3,
\]

take \(\delta=\alpha_0\) and the negative highest root

\[
 \gamma=-(\alpha_0+2\alpha_1+2\alpha_2+
           3\alpha_3+2\alpha_4+\alpha_5).
\]

The chain

\[
 \gamma,\ \alpha_1,\ \alpha_3,\ \alpha_4,\ \alpha_5 \tag{3}
\]

lies in \(\delta^\perp\), has the \(A_5\) Cartan matrix, and has determinant
six; it is therefore all of \(M\).

The reflections in these five roots fix \(\delta\).  Hence the reflection
subgroup

\[
 W(M)=W(A_5)\cong S_6 \tag{4}
\]

acts by changing the auxiliary \(A_5\) marking while retaining the vanishing
root.  It has no stationary vector:

\[
 M^{W(A_5)}=0. \tag{5}
\]

Indeed a vector fixed by every root reflection is orthogonal to the five
roots in (3); they span \(M\), and their determinant is a unit in \(A\).

This is a symmetry of the *equisingular marked family*.  A single
one-parameter Picard--Lefschetz disk supplies only the reflection in
\(\delta\), not the \(W(A_5)\) marking symmetry.  To use (5), a strict
Stokes/Gamma construction must be natural under equisingular deformation and
independent of the auxiliary \(A_5\) marking.

## 2. The exact strict local test

Let \(G_0,G_2\) be the first and third associated Rees grades of a candidate
length-three cubic string at a root-marked \(A_1\) cubic-surface
degeneration.  Assume the strict local construction supplies a horizontal
stationary projection of the second composite

\[
 c_{\rm st}=\operatorname{pr}_{M}(N_1N_0)
 \in
 \bigl(M\otimes_A\operatorname{Hom}_A(G_0,G_2)\bigr)^{W(A_5)}. \tag{6}
\]

Here horizontality means descent through the root-marked equisingular
deformation, not merely equivariance for the local Picard--Lefschetz
involution.  Equation (6) is the exact required strictness datum: it records
the \(W(A_5)\) actions on both endpoint Rees grades and the stationary
projection of the actual sectorial product.

Since the \(A_5\) form is perfect over \(A\), the stationary tensor space is

\[
 \bigl(M\otimes\operatorname{Hom}(G_0,G_2)\bigr)^{W(A_5)}
 \cong
 \operatorname{Hom}_{W(A_5)}
 \bigl(M,\operatorname{Hom}(G_0,G_2)\bigr). \tag{7}
\]

Thus the strict local gate is:

\[
 \boxed{\quad
 \operatorname{Hom}_{W(A_5)}
 \bigl(M,\operatorname{Hom}(G_0,G_2)\bigr)=0
 \quad} \tag{8}
\]

for the actual equisingular actions.  If (8) holds, then \(c_{\rm st}=0\).
In particular it holds when both \(G_0\) and \(G_2\) are
\(W(A_5)\)-trivial, because (5) applies.

If the first Rees arrow has the sign Picard--Lefschetz character, its square
is stationary.  Consequently under the root-targeting hypothesis of the
previous local audit, (8) kills the *entire* second composite, not only one
coordinate of it: a sign target is forbidden by Picard--Lefschetz parity and
the only remaining primitive target is \(M\).

This isolates a concrete calculation for a strict realization:

1. construct the two local strict arrows \(N_0,N_1\) over the root-marked
   equisingular germ;
2. record the \(S_6=W(A_5)\) modules \(G_0,G_2\);
3. decompose \(\operatorname{Hom}(G_0,G_2)\) and apply (8);
4. only if an \(A_5\)-standard summand survives, compute the corresponding
   finite set of stationary matrix coefficients of \(N_1N_0\).

No global weak-factorization or Fano classification is involved in this
local test.

## 3. Why the symmetry is sharp, not automatic

Weyl symmetry alone does not make the composite vanish.  Write the \(A_5\)
lattice in its standard form

\[
 M=\{(u_1,\ldots,u_6)\in A^6:\textstyle\sum_i u_i=0\},
\]

with \(S_6\) permuting coordinates.  The symmetric bilinear map

\[
 \kappa(u,v)_i
 =u_iv_i-\frac16\sum_{j=1}^6u_jv_j \tag{9}
\]

is nonzero and \(S_6\)-equivariant:

\[
 \kappa:\operatorname{Sym}^2(M)\longrightarrow M. \tag{10}
\]

Equivalently, \(M\) occurs in \(\operatorname{End}(M)\), so

\[
 \bigl(M\otimes\operatorname{End}(M)\bigr)^{W(A_5)}\ne0. \tag{11}
\]

Hence an endpoint Rees grade that carries the standard \(A_5\) representation
can support a nonzero stationary second composite while respecting the full
equisingular Weyl symmetry.  This is the symmetry-refined version of the
earlier formal parity countermodel.  It shows that one cannot replace the
strict representation test (8) by an assertion of geometric naturality
alone.

## 4. Consequence for the corrected Silver threshold

The sharp numerical Silver threshold only needs to exclude a nonzero second
composite that could create a length-three center string.  The nodal
cubic-surface threat now has an exact dichotomy:

- equisingular descent plus the vanishing test (8) excludes it;
- a surviving \(A_5\)-standard summand of
  \(\operatorname{Hom}(G_0,G_2)\) is the sole representation channel in
  which the strict stationary coefficient must still be computed.

The result does not establish either the requisite strict Stokes/Gamma
descent or the endpoint module calculation.  It does replace the former
mislabelled stationary-\(D_5\) question by a finite \(S_6\)-module test with a
specified tensor to evaluate.

## EJ/TT and mystery ledger

- **EJ:** the large stationary lattice is not merely an obstruction; its
  \(A_5\) symmetry reduces the local carrier problem to one representation
  multiplicity.
- **TT:** do not infer equisingular symmetry from the one-disk
  Picard--Lefschetz calculation.  It is an additional deformation-descent
  theorem, and it is sharp because (9) survives when the endpoint grades
  carry \(M\).
- **Settled:** the correct stationary lattice and exact symmetry gate are
  \(A_5\), \(W(A_5)=S_6\), and (8).
- **Open:** construct the strict equisingular Stokes/Gamma product and read
  its \(S_6\) endpoint modules; no genuine mystery remains about what local
  coefficient must be tested.
