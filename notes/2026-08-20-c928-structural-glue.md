# C928: structural realization and surjectivity of the mod-two glue

**Date:** 2026-08-20

**Status:** structural proof complete modulo the named integral
Clemens--Griffiths cylinder isomorphism; full transfer surjectivity on the
kernel remains separate

## Result

Let `X` be a smooth cubic threefold, `J` its intermediate Jacobian,
`F -> J` the Albanese-embedded Fano surface, and

\[
\psi:F\times F\longrightarrow J,
\qquad (l,l')\longmapsto a(l')-a(l).
\]

Let `M=Bl_0 Theta` and use the degree-six model and notation of the C908
adjudication note.  Assuming the classical integral cylinder isomorphism

\[
p_*\pi_E^*:H^3(F,\mathbf Z)/\mathrm{tors}
\xrightarrow{\sim}H^3(X,\mathbf Z),
\]

the endpoint Kunneth classes `beta tensor 1` realize all divided-power
generators of the saturation defect:

\[
b_*q_*\mu^*(\beta\otimes1)
=\psi_*(\beta\otimes1)
\equiv
\Theta^{[2]}\wedge y(\beta)
\pmod{L_3\bigwedge^3\Lambda},
\]

up to the one global sign fixed by the difference-map and orientation
conventions.  The sign is immaterial in the exponent-two quotient.

Here

\[
y:H^3(F,\mathbf Z)/\mathrm{tors}\xrightarrow{\sim}\Lambda
\]

is the integral composition of Albanese Gysin, Poincare wedge duality, and
the principal polarization.  Therefore the geometric glue

\[
\rho:H^3(X,\mathbf Z)/2\longrightarrow
\operatorname{Sat}/L_3\bigwedge^3\Lambda
\]

is onto.  Together with its already structural injectivity, it is an
isomorphism.  Moreover

\[
b_*H^3(M,\mathbf Z)=\operatorname{Sat}
=L_3\bigwedge^3\Lambda+\Theta^{[2]}\wedge\Lambda
\]

without HNF or an enumeration of the 940 generators.

## Pontryagin endpoint identity

The only algebra needed is the following basis lemma for a principally
polarized abelian fivefold.  Write

\[
H^*(J,\mathbf Z)=\bigwedge^*\Lambda,
\qquad
\Theta=\sum_{i=1}^5 e_i\wedge f_i,
\qquad
\mathrm{vol}=\Theta^{[5]}.
\]

For `xi in wedge^9 Lambda`, let `y(xi) in Lambda` be its integral
symplectic wedge-dual.  Then

\[
\xi\star\Theta^{[3]}
=\pm\Theta^{[2]}\wedge y(\xi).
\tag{1}
\]

The sign is constant once the orientation and Pontryagin conventions are
fixed.

To prove (1), it suffices by linearity to take `xi` to be the oriented top
monomial with one of the ten basis one-forms omitted.  In the defining
adjunction

\[
\int_J(\xi\star\Theta^{[3]})\wedge\eta
=\int_{J\times J}
\operatorname{pr}_1^*\xi\wedge
\operatorname{pr}_2^*\Theta^{[3]}\wedge m^*\eta,
\]

only terms supplying the omitted one-form to the first factor and the two
complementary full symplectic pairs to the second factor survive.  Each
surviving term occurs once because `Theta^[3]` is a divided power.  The
result is precisely the pairing of `Theta^[2] wedge y(xi)` with `eta`.
Unimodularity of the degree-five wedge pairing proves (1).  This checks ten
basis elements, not 940 geometric generators, and the argument is uniform
under symplectic change of basis.

## Application to the difference map

The minimal-class identity is

\[
a_*1=[F]=\Theta^{[3]}.
\]

For `beta in H^3(F,Z)/tors`, put `xi=a_*beta in wedge^9 Lambda`.  Since
`psi=m circ ((-a) times a)`, the endpoint class satisfies

\[
\psi_*(\beta\otimes1)
=(-1)^*\xi\star\Theta^{[3]}
=-\xi\star\Theta^{[3]}.
\]

Equation (1) gives the asserted divided-power class.  The map
`beta -> xi` is the Poincare adjoint of
`a^*:H^1(J,Z)->H^1(F,Z)`, and the latter is the integral Albanese
isomorphism.  Wedge duality and the principal polarization are unimodular,
so `y` is an integral lattice isomorphism.

Clean base change from the C908 adjudication gives

\[
e_X^*q_*\mu^*(\beta\otimes1)=p_*\pi_E^*\beta.
\]

Thus the same ten endpoint classes map isomorphically to `H^3(X,Z)` and,
under `b_*`, to all ten generators of the saturation quotient.  This is
exactly the onto half of `rho`.

## Equality of the pushforward lattice

The topological exact sequence

\[
0\to\bigwedge^3\Lambda\xrightarrow{b^*}H^3(M,\mathbf Z)
\xrightarrow{e_X^*}H^3(X,\mathbf Z)\to0
\]

is already human-proved in the adjudication note.  Choose the ten transfer
lifts above.  They and `b^* wedge^3 Lambda` generate `H^3(M,Z)`.  Their
pushforwards lie in `Theta^[2] wedge Lambda`, while

\[
b_*b^*\alpha=\Theta\wedge\alpha=L_3\alpha.
\]

The structural saturation theorem therefore gives both inclusions and hence
equality with `Sat`.  This eliminates certificate CHECKs 3--5 from the
headline lattice and glue theorem.

## Boundary of the result

This argument proves that endpoint transfer classes lift every quotient
direction and that their pushforwards generate the saturation together with
`b^* wedge^3 Lambda`.  It does **not** yet prove that the transfer image
itself contains every `b^*alpha`.  Consequently the stronger statement

\[
q_*\mu^*:H^3(F\times F,Z)\twoheadrightarrow H^3(M,Z)
\]

still needs a structural kernel-generation argument; certificate CHECK 7
has not been silently promoted.

## Dependency audit update

| assertion | status after this pass |
|---|---|
| saturation formula and Smith factors | structural, unconditional |
| symplectic naturality of the saturation quotient | structural, unconditional |
| endpoint realization of every quotient generator | structural modulo the named integral Albanese/cylinder input |
| onto half and closed formula for `rho` | structural modulo the same input |
| `b_*H^3(M)=Sat` | structural modulo the topological exact sequence and cylinder input |
| full integral surjectivity of `q_*mu^*` | still certificate-backed; kernel generation open |

## Mystery ledger

| question | status | evidence or gate |
|---|---|---|
| Why does the glue use `Theta^[2]`? | settled | Pontryagin multiplication of the Albanese endpoint by `[F]=Theta^[3]` |
| Why is `rho` onto? | settled | endpoint classes plus the two unimodular integral isomorphisms |
| Does the exact sign matter? | no for the glue | target has exponent two; fix it only for integral exposition |
| Does the transfer hit the kernel integrally? | open | identify diagonal-zero Kunneth classes mapping to a primitive basis of `L_3 wedge^3 Lambda` |
