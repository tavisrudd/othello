# C904: the BdGF Poincare cube is the wrong Kunneth channel

Date: 2026-08-11

Status: theorem-grade red-team; Paper V research only; no manuscript or
Lean change

## Verdict

The Beckmann--de Gaay Fortman cycle does pull integrally to
\(M\times M\), is invariant under swapping the two factors, and exists over
the generic marked family once the relative minimal curve is given.  It
does **not** realize the \((1,5)\) inverse-Lefschetz identity channel and
cannot give an odd multisection of
\(\operatorname {Sym}^2M\to J\).

The reason is exact and simpler than the earlier Fano scalar-four
calculation.  Its class

\[
                         \frac{p^3}{3!}
\]

is pure of Kunneth bidegree \((3,3)\).  Pullback to the theta resolution
does not change that bidegree.  The \((1,5)\) identity needs an integral
inverse-Lefschetz kernel and is absent.

Moreover the anti-graph calculation is explicit.  If a rational or
integral quotient class \(z\) has ordered pullback

\[
             q^*z=(b\times b)^*\frac{p^3}{3!},
\]

then

\[
                         \deg(z/J)=-80.                     \tag{0.1}
\]

The natural integral pushforward \(q_*T\) has degree \(-160\).  Signs depend
on the Poincare convention, but the magnitudes and evenness do not.  Thus
even a hypothetical integral descent of the unhalved ordered class is far
from odd.

## 1. Construction and relative status

Let \((A,\Theta)\) be the principally polarized intermediate Jacobian of
dimension five, let \(p=c_1(\mathcal P)\) on \(A\times A\), and let

\[
                       c=\frac{\Theta^4}{4!}
\]

be represented by an integral one-cycle \(Z\).  Define

\[
 \tau=j_{1,*}Z+j_{2,*}Z-\Delta_*Z.
\]

Beckmann--de Gaay Fortman, using the Moonen--Polishchuk Pontryagin divided
powers, construct the integral cycle

\[
                    S=\tau^{[7]}\in CH^3(A\times A),
             \qquad [S]=\frac{p^3}{3!}.                    \tag{1.1}
\]

Let \(b:M=\operatorname {Bl}_0\Theta\to A\) be the theta resolution and
put

\[
                       T=(b\times b)^*S\in CH^3(M\times M). \tag{1.2}
\]

This pullback is defined because the varieties are smooth.  It is integral.

For the marked one-parameter family, the existing
\(Z_{\min}\in CH^4(\mathcal J/B)\) restricts to a cycle over
\(K=\mathbf C(B)\).  The absolute divided-power construction applied over
\(K\) produces \(S_K\) and hence \(T_K\); both spread after shrinking
\(B\).  This gives a horizontal integral cycle on some dense open.  It does
not by itself give a canonical extension over the cusps, because the
printed divided-power theorem is absolute rather than a general relative
semiabelian extension theorem.

Thus relative existence on the smooth generic locus is not the
obstruction.

## 2. Swap parity

Let \(s_A\) exchange the factors of \(A\times A\).  The cycle \(\tau\) is
fixed by \(s_A\): the two axis terms are exchanged and the diagonal term is
fixed.  Pontryagin divided powers are functorial for monoid automorphisms,
so

\[
                         s_A^*S=S                           \tag{2.1}
\]

already in Chow, not just in cohomology.  Consequently the factor swap
\(s_M\) fixes \(T\).

The cohomological sign is consistent with (2.1).  In a symplectic basis,

\[
 p=\sum_i(e_i\wedge f_i'-f_i\wedge e_i'),
\]

and exchanging the factors, including the Koszul sign, fixes \(p\).  In
Kunneth coefficient notation the \((3,3)\) tensor is alternating, exactly
as required for invariance under geometric swap in odd degree.

Let

\[
 q:M^2\longrightarrow\operatorname {Sym}^2M
\]

be the quotient.  Swap invariance gives a canonical rational descent

\[
                         z_{\mathbf Q}=\frac12q_*T.          \tag{2.2}
\]

At the cohomological level \(q^*[z_{\mathbf Q}]=[T]\).  Integral descent of
the particular Chow cycle \(T\) is not automatic: fixed-locus
multiplicities can leave a two-primary obstruction in the image of the
integral quotient pullback.  The natural class \(q_*T\) is integral, but
its ordered pullback is \(2[T]\).

This Chow-descent distinction does not affect the negative result below.
Even if an integral \(z\) with ordered class \([T]\) exists, its degree is
the even number (0.1).

## 3. Why this is not the \((1,5)\) identity

Each factor of \(p\) has bidegree \((1,1)\).  Therefore

\[
                         \frac{p^3}{3!}
       \in H^3(A,\mathbf Z)\otimes H^3(A,\mathbf Z)         \tag{3.1}
\]

and has no \((1,5)\) or \((5,1)\) component.  Ordinary pullback along
\(b\times b\) preserves the bidegrees, so \([T]\) lies wholly in

\[
                         H^3(M)\otimes H^3(M).              \tag{3.2}
\]

As a codimension-three correspondence on the fourfold \(M\), it acts from
\(H^5(M)\) to \(H^3(M)\).  It does not act from \(H^3(M)\) to \(H^1(M)\),
which is the map needed to extract the \(L H^1\) summand and realize the
odd coefficient identity.

The rational algebraic \((1,5)\) projector found in the full Kunneth audit
is instead

\[
              {}^t\Gamma_b\circ\Lambda_A^2\circ\Gamma_b,
                                                                  \tag{3.3}
\]

where \(\Lambda_A\) is the Lefschetz-lowering correspondence.  Formula
(3.3) changes bidegree by Gysin and inverse-Lefschetz operations; ordinary
pullback of (1.1) does not.  Confusing these two constructions is the whole
proposed bypass.

## 4. Exact quotient degree

Let \(\iota:M\to M\) lift inversion on \(A\), put

\[
                      j=(1,\iota):M\longrightarrow M^2,
            \qquad h=b^*\Theta.
\]

The normalized Poincare class satisfies the theorem-of-the-square identity

\[
                 (1,[-1])^*p=-2\Theta.                     \tag{4.1}
\]

Hence

\[
 j^*[T]
   =b^*(1,[-1])^*\frac{p^3}{3!}
   =-8\frac{h^3}{3!}.                                      \tag{4.2}
\]

For a class \(z\) on the symmetric square with ordered pullback \([T]\),
the integral half anti-graph formula gives

\[
                 \lambda(z)=\frac12j^*[T]
                     =-4\frac{h^3}{3!},
 \qquad
                 \deg(z/J)=\int_Mh\,\lambda(z).            \tag{4.3}
\]

Since \(M\to\Theta\) is a resolution and \(A\) is principally polarized,

\[
                 \int_Mh^4=\int_A\Theta^5=5!=120.          \tag{4.4}
\]

Combining (4.3) and (4.4) gives

\[
                 \deg(z/J)=-4\frac{120}{3!}=-80.           \tag{4.5}
\]

For the natural integral class \(q_*T\), the ordered cohomology class is
\(2[T]\), so its degree is \(-160\).  If the opposite convention
\(p\mapsto-p\) is used, both signs reverse and nothing else changes.

This calculation also independently checks the channel diagnosis: the
full Kunneth parity theorem says every \((3,3)\) contribution is even, and
(4.5) exhibits the precise even value here.

## 5. Boundary of the no-go: full Neron--Severi cubes

The argument above kills the canonical BdGF class, not every integral
divisor polynomial on \(A\times A\).  This distinction is structural.  If

\[
 x=\operatorname {pr}_1^*\Theta,
 \qquad y=\operatorname {pr}_2^*\Theta,
 \qquad p=c_1(\mathcal P),
\]

then \(p^3\) is pure \((3,3)\), whereas mixed cubic monomials such as
\(p y^2\) and \(x^2p\) have \((1,5)\) and \((5,1)\) bidegrees.  Allowing
graph divisors for the full endomorphism order enlarges this mixed space
further.  A genuinely integral full-Neron--Severi combination could
therefore evade the channel obstruction proved here.

Such a candidate has three separate acceptance tests:

1. its \((5,1)\) action must be the coefficient identity integrally, not
   only over \(\mathbf Q\);
2. it must already be swap invariant in integral Chow--symmetrizing
   \(\Gamma\) as \(\Gamma+s^*\Gamma\) introduces a factor two;
3. its invariant ordered class must lie in the integral image of the
   symmetric-square quotient, and its anti-graph half must have odd degree.

The known Smith form \(1^{110}2^{10}\) says that the canonical rational
inverse-Lefschetz operator fails the first test in ten dyadic directions.
The residual-\(C_3\) computation supplies no no-go character: invariant odd
cohomology tensors exist.  Thus there is currently neither a full-NS
integral projector nor a conceptual proof that none exists.  If one is
found, its symmetric descent and anti-graph normalization must be audited
afresh; the value \(80\) is specific to \(p^3/3!\).

## 6. Exact conclusion

The BdGF construction supplies all of the following:

1. an integral horizontal ordered cycle \(T\) after shrinking the smooth
   marked base;
2. exact swap invariance in Chow;
3. a rational class on the relative symmetric square;
4. an integral pushed-down class \(q_*T\).

It supplies none of the following:

1. the \((1,5)\) inverse-Lefschetz identity;
2. an odd multisection of \(\operatorname {Sym}^2M\to J\);
3. an integral identity correspondence for the cubic;
4. a canonical extension over the semistable boundary.

The earlier Fano scalar four is therefore irrelevant to this attempted
theta-resolution shortcut.  The shortcut dies before reaching the Fano
surface: pure \((3,3)\) Kunneth type forces degree \(80\), while the natural
integral quotient pushforward doubles it to \(160\).

## 7. Source boundary

No new external source was needed.  The exact BdGF sign, integral
divided-power construction, generic-family spreading boundary, and primary
source ledger are in
`notes/2026-08-10-c904-bdgf-poincare-cube-scalar-audit.md`.  The symmetric
square transfer lattice and half anti-graph degree formula are proved in
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`.  The
rational algebraic \((1,5)\) inverse-Lefschetz correspondence and its exact
integral dyadic defect are in
`notes/2026-08-11-c904-c3-kunneth-descent-boundary.md`.

## Mystery ledger (EJ + TT closeout)

- **Settled:** swap parity is positive in Chow; no hidden antisymmetry kills
  the ordered cycle.
- **Settled:** horizontal generic-fibre construction exists from the
  relative \(Z_{\min}\) after shrinking.
- **Settled negatively:** the Poincare cube is pure \((3,3)\), not the
  \((1,5)\) identity, and its best possible quotient degree has magnitude
  \(80\).
- **Open but irrelevant to oddness:** whether this particular invariant
  Chow cycle descends integrally rather than only rationally.  Either answer
  leaves its degree even.
- **Open:** the genuine integral \((1,5)\) inverse-Lefschetz lift.  BdGF's
  cycle does not change its ten dyadic elementary divisors.
