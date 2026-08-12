# C909 — internal cubic ν6 upper bound from the odd (H^3) sector

Date: 2026-08-12  
Status: short proof/addendum audit; no manuscript, PDF, mirror, or Lean edit

## Verdict

**Conditional GO, with an exact small-quantum calculation and one explicit
continuation gate.**  No WCI classification is needed to show that the odd
(H^3) summand contributes no primitive sixth-root formal monodromy.  At the
small point, the cubic ν6 count is exactly two once Cai's already computed
rank-one even blocks are included: the rank-two zero-even block contributes
(e^{\pm\pi i/3}), while both the odd (H^3) block and the two nonzero
one-dimensional even blocks have integral formal monodromy.

To promote this equality from the small point to the whole quantum atom, the
paper must state the parity-equivariant formal-isomonodromy theorem and work
on the connected reduced unramified spectral component containing that point.
Small-quantum vanishing alone does not prove that every even-bulk quantum
product acts trivially on (H^3).

## 1. Small quantum calculation

Let (X) be a smooth cubic threefold, (H\in H^2(X)) its hyperplane class,
and α\in H^3(X).  The Fano index is two, so a degree-(d) Novikov term has
cohomological degree (4d).  Therefore
\[
 \deg\bigl((H*\alpha)_{d}\bigr)=2+3-4d=5-4d.
 \tag{1}
\]
For (d=0), (H^5(X)=0) by Poincare duality and (H^1(X)=0).  For
(d=1), the target would be (H^1(X)=0), and for (d\ge2) the target
degree is negative.  Hence
\[
                         H*H^3(X)=0.
 \tag{2}
\]

The same conclusion follows from the divisor axiom together with the
three-point virtual-dimension condition: inserting the divisor (H) reduces
positive-degree invariants to the corresponding two-point invariants, and
the degree constraint leaves no class in the required odd target degrees.
The grading argument (1) is the cleaner proof and does not require choosing
an output basis.

In the small quantum connection convention
\[
 \nabla_{z\partial_z}=z\partial_z+\mu-z^{-1}(E*),
 \qquad \mu|_{H^k}=\frac{k-3}{2},
 \tag{3}
\]
one has (E=2H) on the small slice.  Equations (2)--(3) give
\[
 E*\alpha=0,
 \qquad \mu|_{H^3}=0.
 \tag{4}
\]
Thus the rank-(b_3(X)=10) odd summand has constant formal solutions and
formal monodromy (1).  Cai's explicit first-gauge calculation gives
residue (0) on each of the two nonzero-eigenvalue one-dimensional even
blocks; his zero-even rank-two block has indicial roots
(-1/6,-5/6\), i.e. formal monodromy (e^{\pm\pi i/3}).  At the small
point the total primitive sixth-root multiplicity is therefore exactly
\[
                              \nu_6(X)=2.
 \tag{5}
\]

## 2. Even-bulk continuation: the precise gate

Restrict the big/maximal A-model to the parity-fixed base (even bulk).  The
μ2 parity action commutes with the quantum connection, so the odd (H^3)
subbundle remains a direct invariant block.  On the connected **reduced
unramified** spectral component containing the small point, the formal
isomonodromy statement gives constancy of the formal-monodromy conjugacy
class.  Because the transport is μ2-equivariant, it preserves the even and
odd blocks separately.  Consequently the odd block continues to have
monodromy (1), and the two primitive sixth-root eigenvalues in the even
zero block remain exactly two:
\[
                              \nu_6(\alpha_X)=2.
 \tag{6}
\]

This is the correct internal upper-bound mechanism.  It uses formal
isomonodromy, not a classification of all WCI atoms.

## 3. Hostile caveats

1. Equation (2) is a **small-slice** statement.  Even bulk classes such as
   higher-degree even cohomology are not all killed by the elementary degree
   count; one must use parity and formal-isomonodromy rather than claim that
   every big even-bulk product vanishes on (H^3).
2. Formal-isomonodromy is local on a connected reduced unramified spectral
   component.  To claim (6) for every smooth cubic or every point of a global
   moduli/quantum base, the paper must provide the continuation path or a
   global deformation-invariance statement avoiding spectral collisions.
   Without this, (5) is theorem-grade only at the small point and (6) is
   conditional on the stated component.
3. The comparison between Cai's connection and KKPYY's maximal atomic
   F-bundle must preserve the loop variable and use only integral formal
   gauges; otherwise the residue calculation does not transfer automatically.
4. If the paper defines ν6 only for the zero atom, say so.  The equality for
   the total cubic chemical formula additionally uses Cai's integral residues
   on the two nonzero one-dimensional even atoms and the odd calculation
   above.

## Safe conclusion

The strongest honest sentence is:

> At the small quantum point, the odd (H^3)-summand is quantum-trivial and
> has formal monodromy (1); together with Cai's even calculation this gives
> the exact cubic sixth-root multiplicity (2).  On any connected reduced
> unramified parity-fixed spectral component reached by formal-isomonodromic
> transport, the same equality persists.  No WCI classification is needed;
> the remaining issue is the explicit continuation/atom-comparison gate.

