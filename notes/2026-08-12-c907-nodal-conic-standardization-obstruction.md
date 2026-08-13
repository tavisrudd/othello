# C907 nodal conic standardization obstruction

**Lane:** `clebsch`

**Status:** source-audited negative result for the proposed
standardization-plus-strict-blowup proof of the nodal Clifford carrier bound.
Weak factorization does use only point and curve centers on smooth
threefolds, but it does not kill a designated node socle. More importantly,
the rank-one nodal fibre which carries the nonzero Clifford product cannot be
reduced to a smooth-discriminant **standard** conic bundle by the proposed
base blowups and elementary transformations.

## The relevant node is a double line, not a cross

At a node of the reduced discriminant of the smooth conic bundle in
`2026-08-12-c907-nodal-clifford-coniveau-obstruction.md`, the strict local
quadratic form is

\[
q=u^2+xv^2+yw^2\qquad\text{over }k[[x,y]],\tag{1}
\]

with discriminant `xy=0`. At `x=y=0` the fibre is

\[
u^2=0,\tag{2}
\]

a rank-one **double line**. This is exactly why the even Clifford fibre is
the exterior algebra on two generators and has the nonzero socle `ij`.

It must not be conflated with a rank-two **cross**, locally `ab=0`. The
distinction is the obstruction to the suggested standardization route.

## What a standard elementary transformation can do

Let `pi:X -> S` be a standard conic bundle over a smooth rational surface,
let `p` be a node of its discriminant
`Delta=D_1+D_2`, and let
`alpha:S' -> S` be the blow-up of `p` with exceptional curve `E`. For the
standard elementary transformations in the conic-bundle category, the new
discriminant is

\[
\Delta'=\alpha^*\Delta-E.\tag{3}
\]

Since

\[
\alpha^*\Delta=D_1'+D_2'+2E,\tag{4}
\]

equation (3) is

\[
\Delta'=D_1'+D_2'+E.\tag{5}
\]

Thus a standard transformation does not replace a nodal discriminant by the
disjoint strict transforms. It retains an exceptional discriminant component
meeting them. Prokhorov's Lemma 8.4 proves the stronger global statement:
fibrewise birationally equivalent standard conic bundles over smooth rational
surfaces have a nonsingular discriminant simultaneously. In particular a
standard nodal model cannot be made standard with smooth discriminant by a
sequence of the transformations (3).

This already blocks the proposed universal argument on the rational base
`S=P^2` of the explicit nodal calibration. It is enough to show that
standardization is not a route from the local exterior-algebra fibre to the
smooth-discriminant square-zero theorem.

## The available separation theorem has the opposite hypothesis

Ambrosi--Ancona, Proposition 6.1, gives a useful but different operation.
If `D_1,D_2` are smooth and transverse and **all** fibres over their
intersection are crosses, then after blowing up `D_1 intersect D_2` an
elementary transformation produces a conic bundle whose discriminant is the
disjoint union of the strict transforms. Their local normal form is

\[
\alpha c^2-ba=0,\qquad \alpha=\alpha_0t_1t_2,\tag{6}
\]

so the special fibre is `ba=0`, not (2). The proof uses the rank-one bundle
of singular **points** of these cross fibres to define the elementary
transformation. For a double line the singular locus is a whole line and
this input is absent.

The same source immediately warns that it does not know an analogous result
when the fibres over `D_1 intersect D_2` are nonreduced, and that a statement
as general as Proposition 6.1 cannot be true. Hence this separation theorem
cannot be cited as a standardization theorem for (1). It is a positive
cross-fibre tool, not a repair of the Clifford-node case.

## Exact weak-factorization consequence—and its limit

Suppose nevertheless that two smooth projective threefold models `X` and
`X'` are birational. Weak factorization in characteristic zero gives a
sequence of blow-ups and blow-downs with smooth centers. On a threefold a
nontrivial center has dimension zero or one: a smooth dimension-two center
is an effective Cartier divisor and its blow-up is an isomorphism.

Consequently, under the *future strict* C907 blow-up biproduct

\[
R_\alpha(\operatorname{Bl}_C X)
 \cong R_\alpha(X)\oplus
 \bigoplus_{j=1}^{\operatorname{codim}C-1}T^jR_\alpha(C),\tag{7}
\]

and the already required vanishing of point and curve primitive-sixth
packets, weak factorization would identify the **total** enriched packet of
`X` with that of `X'`.

It does not send a specified local Clifford class `ij` to zero. Equation
(7) has no map from the node radical to the exceptional summands, and when
those summands vanish it says that the total packet is preserved, not that a
nonzero local class disappears. To make the socle vanish one would need a
strict comparison identifying its image with a point/curve summand; that is
exactly the missing singular-point excision theorem isolated earlier.

Combining this with (5), any genuine standard-model factorization preserves
the nodal discriminant phenomenon rather than reducing it to a
smooth-discriminant Clifford order. A factorization through nonstandard or
singular conic models may exist, but then it needs a separate
operation-framed comparison and cannot be concluded from (7).

## Source audit

The following primary sources were checked at the stated loci.

1. Yu. Prokhorov, *The rationality problem for conic bundles*, Russian Math.
   Surveys 73 (2018), Lemma 8.4, states (3) for the elementary
   transformation and that discriminant nonsingularity is invariant among
   fibrewise birational standard conic bundles over smooth rational surfaces.
   [Primary PDF](https://www.mathnet.ru/links/4c7ffd71eb83011969db4ac9947a8e88/rm9811_eng.pdf).
2. E. Ambrosi and G. Ancona, *An Artin--Mumford criterion for conic bundles
   in characteristic two*, Proposition 6.1 and Remark 6.2, prove separation
   under the cross hypothesis and explicitly exclude the nonreduced-fibre
   extension. [Primary preprint](https://emiliano-ambrosi.perso.math.cnrs.fr/pdf/preprint/Crystalline%20AM.pdf).
   This is used only as an audit of the claimed elementary-transform
   mechanism; no characteristic-two conclusion is imported into C907.
3. D. Abramovich, K. Karu, K. Matsuki, and J. Wlodarczyk,
   *Torification and Factorization of Birational Maps*, proves weak
   factorization in characteristic zero. [arXiv:math/9904135](https://arxiv.org/abs/math/9904135).

## EJ/TT

- **EJ:** the elementary-transform route separates cross fibres, whereas the
  Clifford socle lives exactly at a double line. The hypothesis mismatch is
  the whole issue, not a missing choice of base blowups.
- **TT:** point/curve blowup formulas can make the total primitive packet
  birationally invariant, but cannot annihilate a named local extension.
  The desired node-socle vanishing remains a strict singular-support
  comparison problem.
