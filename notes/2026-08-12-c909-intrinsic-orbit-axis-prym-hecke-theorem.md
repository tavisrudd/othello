# C909 — intrinsic orbit-axis Prym theorem and its Hecke consequence

Date: 2026-08-12

Status: higher-dimensional upgrade of the degree-one Prym/axis comparison;
valid over a smooth family base under the stated quotient and polarization
hypotheses. No manuscript, PDF, mirror, or Lean edit.

## The basis-free orbit-axis theorem

Let \(\rho:\widetilde C\to\widetilde C_0\) be a finite degree-\(m\) quotient
of smooth proper curves in characteristic zero. Suppose fixed-point-free
involutions \(\iota,\iota_0\) on the two curves commute with \(\rho\).
Writing \(C=\widetilde C/\iota\) and \(C_0=\widetilde C_0/\iota_0\), their
Pryms

\[
 P=\operatorname{Prym}(\widetilde C/C),\qquad
 P_0=\operatorname{Prym}(\widetilde C_0/C_0)
\]

carry their canonical principal polarizations \(\Xi,\Xi_0\). Let a finite
group act by polarized automorphisms on \(P\). Assume that \(\rho\) is the
geometric quotient by the same cyclic order-\(m\) subgroup \(C_m\), and let
\[
 C_m\triangleleft H,\qquad
 A=P^{H,0}=P^{C_m,0}\subset P,                              \tag{1}
\]
and suppose \(\dim P_0=\dim A=r\). Here \(A\) is intrinsic: it is the
connected image of the subgroup norm \(\sum_{h\in H}h\), with no choice of
a coefficient basis.

Pullback gives \(\phi=\rho^*:P_0\to P\); (1) makes its image \(A\), hence
\[
 \phi=i\bar\phi,\qquad \bar\phi:P_0\longrightarrow A.        \tag{2}
\]

Assume that \(A\) has a principal polarization \(\Xi_A\) for which the
restriction of \(\Xi\) is *scalar*:
\[
 i^*\Xi=e\Xi_A
\quad\Longleftrightarrow\quad
 i^\dagger i=[e].                                           \tag{3}
\]
Then \(e\mid m\). With \(s=m/e\),
\[
 \bar\phi^*\Xi_A=s\Xi_0,\qquad
 \deg\bar\phi=s^r.                                          \tag{4}
\]
Moreover \(\ker\bar\phi\subset P_0[s]\) is maximal isotropic. In
particular
\[
 m=e \quad\Longrightarrow\quad \bar\phi:(P_0,\Xi_0)
  \xrightarrow{\sim}(A,\Xi_A).                              \tag{5}
\]

This is a statement entirely in terms of the quotient Prym, its orbit axis,
and the restriction polarization. The principal polarization in (3) is
part of the intrinsic polarized-axis datum, not a coordinate basis. If no
such principal factor polarization is specified canonically, the fully
intrinsic nonscalar formula below is the correct replacement. Neither
statement uses a coordinate realization of the fixed space.

## Proof

For an etale double cover the ambient Jacobian theta restricts to twice the
principal Prym polarization. Since the Jacobian adjoint of \(\rho^*\) is
\(\rho_*\), the identity
\[
 \rho_*\rho^*=[m]
\]
gives, after restriction to the Pryms,
\[
 \phi^*\Xi=m\Xi_0.                                          \tag{6}
\]
The factors two from the two ambient Jacobian restrictions cancel in the
torsion-free Hom group of the abelian varieties. Substituting (2) and (3)
into (6) yields
\[
 e\,\bar\phi^*\Xi_A=m\Xi_0.                                 \tag{7}
\]

At the level of polarization homomorphisms, set
\[
 u=\lambda_{\Xi_0}^{-1}
    \bar\phi^\vee\lambda_{\Xi_A}\bar\phi\in\operatorname{End}(P_0).
\]
Equation (7) says \(eu=m\,1\). In \(\operatorname{End}^0(P_0)\),
\(u=(m/e)1\). A rational scalar that is an actual abelian-variety
endomorphism is an integer, since
\(\operatorname{End}(P_0)\cap\mathbf Q\,1=\mathbf Z\,1\). Thus \(s=m/e\)
is integral, proving the first equality in (4).

Taking degrees of its polarization homomorphisms gives
\[
 (\deg\bar\phi)^2=\deg(s\Xi_0)=s^{2r},
\]
so \(\deg\bar\phi=s^r\). The equality
\(\bar\phi^\dagger\bar\phi=[s]\) puts its kernel in \(P_0[s]\); the standard
polarized-isogeny argument makes it isotropic. Its order \(s^r\) is the
square root of \(|P_0[s]|=s^{2r}\), hence it is maximal isotropic.

## The completely intrinsic nonscalar formula

The scalar hypothesis (3) is necessary for the quotient \(m/e\) to be
defined. Without it, put
\[
 \Lambda_A=i^*\Xi,\qquad
 \delta_A=\sqrt{\deg\lambda_{\Lambda_A}}
\]
(\(\delta_A\) is the product of the elementary divisors of the restriction
polarization). Equation (6), which requires no choice of \(\Xi_A\), implies
the exact basis-free degree formula
\[
                 \deg\bar\phi=\frac{m^r}{\delta_A}.         \tag{8}
\]
It follows by taking degrees in
\(\bar\phi^*\Lambda_A=m\Xi_0\). Existence forces
\(\delta_A\mid m^r\).

Formula (8) is the correct general higher-dimensional replacement. It is
not licit to call \(\delta_A^{1/r}\) an axis exponent unless the entire
polarization, not merely its degree, is scalar.

For example, on \(E^2\) with its product principal polarization, the
polarizations of types
\[
 (e,e)\quad\text{and}\quad(1,e^2)
\]
have the same degree \(e^4\), but their Rosati operators are respectively
\(e\,1\) and \(\operatorname{diag}(1,e^2)\). Their discriminant modules,
and thus their local graph/level data, are different. The numerical degree
cannot replace (3). This is the exact no-go for a purported
degree-only \(m/e\) theorem.

## Family and finite-etale spectral packet

The theorem globalizes over a connected smooth base provided:

1. \(\rho\) is a finite locally free degree-\(m\) quotient of smooth proper
   curve families and commutes with the etale double-cover involutions;
2. the connected Pryms and the norm image \(A\) are abelian schemes of
   constant dimension;
3. the equality of fixed abelian subschemes in (1) and the scalar
   restriction relation (3) hold fibrewise (equivalently as relative Hom
   identities).

Then (2)--(4) are relative identities. Equality may be checked on one
generic fibre: relative Hom is unramified, while the displayed maps are
global. No trace or averaging denominator is used.

For a prime \(p\nmid s\), \(\bar\phi[p^a]\) is an isomorphism of finite
etale local systems. It is a polarization **similitude** of multiplier
\(s\), not generally a literal symplectic isomorphism:
\[
 e_{\Xi_A}(\bar\phi x,\bar\phi y)
   =e_{\Xi_0}(x,y)^s.
\]
This correction matters at odd \(p\). It nevertheless preserves
isotropicity, self-adjointness (a scalar unit rescales the bilinear form),
and finite-etaleness of a graph spectral packet. At \(p=2\), an odd
multiplier is automatically one on the Weil pairing; at every prime it is
literal symplectic when \(s=1\).

Thus a finite-etale self-adjoint gluing packet transfers through (2) at all
primes not dividing \(s\); at primes dividing \(s\) no such conclusion is
available from the quotient alone. In the six-axis application
\(m=e=5\), so \(s=1\): every finite level, in particular the actual
two-primary graph kernel, transfers exactly.

## Exact moduli consequence

When (3) holds, \((P_0,A,\bar\phi)\) is a point of the genus-\(r\)
\(s\)-similitude Hecke correspondence:
\[
 \bar\phi^*\Xi_A=s\Xi_0,\qquad \deg\bar\phi=s^r.             \tag{9}
\]
For \(s=1\) this is the diagonal, so the quotient-Prym presentation and the
orbit-axis presentation define the same marked ppav point, not merely a
Hecke-related point. This is the exact reason the \(r^2=T\) resolvent marks
the actual six-axis kernel rather than an auxiliary isogenous system.

If \(s=\ell\) is prime, \(\ker\bar\phi\) is a Lagrangian \(\ell\)-plane in
\(P_0[\ell]\). Over full \(\ell\)-level the corresponding Hecke projection
has exactly
\[
                     \prod_{j=1}^r(\ell^j+1)               \tag{10}
\]
geometric outgoing Lagrangian branches. Formula (10) is deliberately not
claimed for composite \(s\), where kernels of \(s\)-similitude isogenies can
have several elementary-divisor types.

For the current \(r=1,m=e=5\) family, (9) is the diagonal rather than a
five-Hecke branch. The marked signed cover is therefore a genuine
presentation curve in the finite-etale Hecke stack. As before, this does
not make it a connected component of the whole higher-dimensional stack.

## Application to the \(A_5\) six-axis family

Take \(C_m=C_5\triangleleft D_5=H\), \(m=5\), and the quotient Prym of
van Geemen--Yamauchi. The invariant-line calculation gives (1), and the
primitive Roulleau normalization gives \(e=5\). Hence \(s=1\), recovering
the degree-one comparison and exact \(K[2]\) marking in
2026-08-12-c909-prym-axis-degree-one-modular-kernel-bridge.md.

## Mystery ledger

The \(ej+tt\) pass yields one free upgrade: in higher dimension the correct
object is a specified Hecke correspondence, and the degree is exactly
\((m/e)^r\) in the scalar case, not \(m/e\). The same pass closes the
tempting degree-only generalization negatively: equal restriction degrees
do not determine the local level packet.

The remaining open boundary is a nonscalar geometric orbit axis whose
restriction polarization type can be computed and whose quotient Prym
realizes a nontrivial \(s\)-Hecke branch. That is a new family problem, not
a consequence of the present six-axis data.
