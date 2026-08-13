# C907 — what the C908 theta lattice can measure in a fivefold factorization

Date: 2026-08-13

Status: exact blowup-packet reduction and negative verdict for the first
framed-carrier test.  In degree five, a
weak factorization of `X x P^2` can absorb the cubic Hodge structure only
through three explicit kinds of centers.  The C908 depth-two class is
potentially sensitive to the two-layer packet of a surface center, especially
the Fano surface.  It cannot by itself exclude the three-layer packet of a
curve center; that packet is the integral avatar of the minimal-theta/odd-
curve escape.  Thus C908 is useful as a secondary **carrier-framing**
invariant, not as a bare lattice obstruction.  The smallest proposed use,
however, fails: the exceptional divisor gives a primitive identity component
between the two layers of a codimension-three surface packet, so an even
`2S` polarization component does not leave a parity obstruction.

There is also a terminology correction.  The exact sequence in C908

\[
 0\longrightarrow \wedge^3\Lambda\longrightarrow H^3(M,\mathbf Z)
 \longrightarrow H^3(X,\mathbf Z)\longrightarrow0                 \tag{1}
\]

splits because its quotient is free.  The nontrivial theorem is the canonical
gluing of its image under `(b_*,e_X^*)`, with quotient of index `2^10`; it is
not an abstract nonsplit extension of abelian groups.

## 1. The degree-five carrier equation

Let `V=X x P^2`, where `X` is a smooth cubic threefold.  Since `H^1(X)=0`,

\[
 H^5(V,\mathbf Z)=H^3(X,\mathbf Z)\otimes H^2(P^2,\mathbf Z)
                  \cong H^3(X,\mathbf Z)(-1).                       \tag{2}
\]

For the blowup of a smooth fivefold `Y` along a smooth center `Z` of
codimension `c`, the integral blowup formula gives

\[
 H^5(\operatorname{Bl}_Z Y)
 \cong H^5(Y)\oplus
 \bigoplus_{i=1}^{c-1}H^{5-2i}(Z)(-i).                              \tag{3}
\]

All summands are integral and primitive.  Consequently the only odd
packets which can carry the rank-ten cubic structure in a fivefold weak
factorization are:

| center | codimension | contribution to `H^5` |
|---|---:|---|
| threefold `T` | 2 | `H^3(T)(-1)` |
| surface `S` | 3 | `H^3(S)(-1) + H^1(S)(-2)` |
| curve `C` | 4 | `H^1(C)(-2)` |
| point | 5 | `0` |

Applied along a zigzag from `V` to `P^5`, (3) gives an equality of integral
polarized Hodge structures

\[
 H^3(X)(-1)\oplus\bigoplus_{a\in A}P(Z_a)
 \cong \bigoplus_{b\in B}P(Z_b),                                  \tag{4}
\]

where `P(Z)` is the packet in the table, with signs/side determined by the
orientation of the blowup.  Any purely cohomological Gold proof has to show
that the distinguished summand on the left cannot be canceled in (4).

## 2. Why the Fano surface is the dangerous surface carrier

For the Fano surface `F` of lines on `X`, the cylinder correspondence gives

\[
 H^1(F)(-1)\cong H^3(X)                                             \tag{5}
\]

integrally (up to the conventional sign of the polarization).  Poincare
duality gives the corresponding identification through `H^3(F)`.  Hence a
codimension-three occurrence of `F` contributes **two** cubic-type copies to
degree five:

\[
 H^3(F)(-1)\oplus H^1(F)(-2).                                      \tag{6}
\]

They are not unrelated copies.  C908 computes the integral map coupling the
two Fano-surface layers: cup product with the incidence curve is `2S`, where
`S` is the unimodular symplectic form.  Its cokernel is therefore

\[
 \operatorname{coker}(C_s\cup-)
   \cong H^3(X,\mathbf Z)\otimes\mathbf F_2.                         \tag{7}
\]

The same mod-two space is canonically the gluing quotient
`Sat/L_3 wedge^3 Lambda`, the `L_5` cokernel, and the depth-two quotient of
the rank-ten escape lattice.  This is exactly the kind of datum forgotten by
the unframed direct sum (4).  It can in principle obstruct a cancellation
which tries to identify the two exceptional layers by a unimodular map.

This suggests the only plausible C907 use of C908: enrich (4) by a canonical
exceptional-depth map and follow the class (7), not merely the rank-ten Hodge
summand.  Section 4 tests the ordinary Lefschetz/Gysin framing and shows that
it is not sufficiently canonical or restrictive.

## 3. The curve escape, and why C908 alone is insufficient

Across all odd degrees, a codimension-four curve center contributes three
copies of `H^1(C)`:

\[
 H^1(C)(-1)\subset H^3,qquad
 H^1(C)(-2)\subset H^5,qquad
 H^1(C)(-3)\subset H^7.                                             \tag{8}
\]

These form a primitive three-step exceptional/Lefschetz string, of exactly
the same length as

\[
 H^3(X)\otimes H^*(P^2).                                           \tag{9}
\]

Thus no universal argument based only on the existence, rank, or abstract
polarization of the cubic Hodge structure can work: a curve whose Jacobian
contains the required integral factor is a formally perfect carrier.  More
generally, an odd-degree curve correspondence is already perfect modulo two,
even when it is not an integral direct factor.  Algebraicity of an odd
multiple of the minimal theta class is precisely the known mechanism which
makes such an odd curve carrier possible.  It can occur on special
universally-`CH_0`-trivial cubic loci, while all the C908 lattice formulas
remain true.

Therefore the depth-two class (7) cannot prove Gold without one more theorem.
One must show either:

1. every curve carrier occurring in a **geometric fivefold factorization**
   inherits the same even/depth-two defect, despite the abstract string (8);
   or
2. after an odd curve carrier is allowed, the normal-bundle/framing maps
   forced by the factorization still cannot cancel the C908 gluing class.

This is strictly stronger than universal `CH_0` triviality and is not
provided by the current C908 theorem.

## 4. The codimension-three blowup calculation: negative

Let `pi:tilde Y->Y` be the blowup of a smooth fivefold along a smooth surface
`S`.  Write `j:E=P_S(N)->tilde Y`, `p:E->S`,
`xi=c_1(O_E(1))`, and use the convention

\[
 j^*[E]=-\xi.                                                       \tag{10}
\]

The exceptional part of `H^5(tilde Y)` has the two generators

\[
 j_*(p^*H^3(S)),\qquad j_*(\xi\,p^*H^1(S)).                         \tag{11}
\]

The degree-three exceptional layer is `j_*p^*H^1(S)`.  Take an integral
polarization on the blowup of the standard form

\[
 \widetilde A=\pi^*A-mE,\qquad m>0.                                \tag{12}
\]

The projection formula and (10) give, for `alpha in H^1(S)`,

\[
 \begin{aligned}
 \widetilde A\cup j_*p^*\alpha
 &=j_*\bigl(j^*\widetilde A\cup p^*\alpha\bigr)\\
 &=j_*p^*(A|_S\cup\alpha)
   +m\,j_*(\xi p^*\alpha).                                        \tag{13}
 \end{aligned}
\]

Under the two summands (11), the framed map is therefore

\[
 H^1(S)\longrightarrow H^3(S)\oplus H^1(S),\qquad
 \alpha\longmapsto(A|_S\cup\alpha,m\alpha).                       \tag{14}
\]

For `S=F`, if `A|_F=C_s`, the first component is exactly C908's `2S`.
But the second component is `m id`.  Taking `m=1`—available after replacing
`A` by a sufficiently ample divisor before blowing up—makes (14) a primitive
split injection regardless of the parity of the first component:

\[
 \alpha\longmapsto(2S\alpha,\alpha).                              \tag{15}
\]

Hence the first C908 carrier test is **refuted**.  Ordinary integral blowup
and Lefschetz data do not force the Fano-surface packet to remain at depth
two; the exceptional direction supplies a depth-one lift for free.  The same
mechanism makes the three-layer curve packet primitive when the exceptional
coefficient is one.

Any surviving C908 route must therefore transport the specific theta maps
`(b_*,e_X^*)` or an equally rigid canonical framing.  An arbitrary ample
class, the cohomological blowup decomposition, and its exceptional divisor
are not enough.  No such functorial theta construction across a fivefold
weak factorization is currently available.

## EJ / TT / AA

- **EJ:** the ordinary blowup packet upgrades the apparently even Fano map
  `2S` to the primitive graph `(2S,id)`.  The parity shadow is erased as soon
  as the exceptional direction is retained.
- **TT:** the integral transfer `H^3(F x F)->H^3(M)` is surjective.  That is
  evidence that unframed additive invariants are highly carrier-realizable,
  not evidence for stable irrationality.
- **AA:** the smallest dangerous carrier kills the proposed obstruction.
  Do not invest in a universal C908-to-Gold correspondence unless it
  preserves the *canonical theta framing* and excludes the exceptional
  identity component in (15).

## Inputs

- `2026-08-12-c908-h3-lattice-adjudication.md`.
- `2026-08-12-c908-z2-naturality-checks.md`.
- The integral cohomological blowup formula and the Kunneth formula; all
  fivefold carrier equations in this note are derivations.
