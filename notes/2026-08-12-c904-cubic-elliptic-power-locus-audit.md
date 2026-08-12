# C904: cubic/elliptic-power locus and nonvacuity audit

Date: 2026-08-12  
Status: bounded source-backed geometry scout; no manuscript, PDF, Lean, or
commit change

## Executive verdict

The elliptic-power quantifier is genuinely nonvacuous beyond isolated highly
symmetric cubics.  Hartlieb's primary-source analysis identifies a
one-dimensional family (M_{H_1}) of smooth cubic threefolds admitting the
irreducible (A_5)-representation of degree five, and states that **every**
member has

\[
                         J(Y)\sim E_Y^5
\]

for some elliptic curve (E_Y).  This is the natural source-side version of
the C904 (A_5) pencil.  The family contains the Klein cubic and meets the
cyclic cubic locus in exactly the two points (Y_1) (Fermat) and (Y_6).
Thus the C904 theorem quantified over every smooth member of its pencil is a
family theorem, not an argument resting on a single Fermat/Klein example.

The bounded audit found no second positive-dimensional cubic family, distinct
from this (A_5) component, for which (J(Y)sim E^5) is source-certified.
There are several additional isolated (E^5) examples, and larger
automorphism loci with only partial elliptic-power overlap; these must not be
counted as new families.

## Exact source facts

Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of
cubic threefolds*, proves/records:

* the cubic intermediate-Jacobian locus is a 10-dimensional locally closed
  subvariety of (A_5), while (dim A_5=15);
* the (A_5)-automorphism locus has two components (M_{H_1}cup M_{H_2});
  (M_{H_1}) is one-dimensional, contains the Klein cubic (Y_5), and its
  intersection with the cyclic/order-five component is exactly
  ({Y_1,Y_6});
* for every (Yin M_{H_1}), the irreducible rational (A_5)-module (W_5)
  has endomorphism algebra (mathbf Q), and the cited representation theorem
  yields an elliptic curve (E_Y) with (J(Y)sim E_Y^5);
* the cyclic cubic locus is four-dimensional, so its Fermat point (Y_1)
  being (E^5) does not make the generic cyclic family elliptic-power;
* among maximal-automorphism isolated cubics, the source explicitly records
  (J(Y_1)sim E^5), (J(Y_6)sim E^5), and
  (J(Y_5)sim E_{11}^5), with (E) the Fermat CM elliptic curve and
  (E_{11}) CM by (mathbf Q(\sqrt{-11})).

Primary source: [Hartlieb, arXiv:2304.03214](https://arxiv.org/abs/2304.03214),
especially the published text's Propositions 32--34, Remark 35, Remark 23,
and Proposition 45.

The order-five locus is not generically (E^5): van Geemen--Yamauchi prove
for a smooth cubic with an order-five automorphism that

\[
                         J(X)\sim E\times B^2,
\]

where (B) is an abelian surface with real multiplication by
(mathbf Q(\sqrt5)).  The (A_5) one-dimensional component is the special
overlap where the stronger (E^5) description applies.

Primary source: [van Geemen--Yamauchi, arXiv:1506.05346](https://arxiv.org/abs/1506.05346),
Introduction and Proposition 1.6 (with Proposition 1.7 for the special
elliptic-power member).

## Locus geometry and the dimension-count trap

For a fixed elliptic-power gluing type, the map

\[
                         E\longmapsto E^5
\]

with a fixed principal level/gluing datum is one-dimensional.  Allowing all
finite isogeny/gluing types gives a countable union of one-dimensional Hecke
curves in (A_5), denoted here by (mathscr H_{E^5}).  Therefore the naive
expected dimension of an independent intersection is

\[
                         10+1-15=-4,
\]

so a generic cubic IJ locus and a generic fixed elliptic-power Hecke curve
should not meet.  This is only a dimension heuristic for the countable union,
not a literature-wide emptiness theorem.

The (A_5) component is a special containment: the one-dimensional image
(J(M_{H_1})) lies in (mathscr H_{E^5}).  The correct conceptual picture is
not “a random intersection of a 10-fold and a Hecke curve,” but a shared
PEL/automorphism construction forcing containment.  Since the cubic Torelli
map is locally closed (and injective on polarized IJ's), the one-dimensional
family is non-isotrivial as a family of cubics.  Before identifying notation
literally, the manuscript should state that C904's Roulleau pencil is the
corresponding irreducible (A_5) component (or cite the parameter change).

## Candidate ledger

| candidate | source-backed (J\sim E^5) status | C904 relevance |
|---|---|---|
| (M_{H_1}), irreducible (A_5) component | Every member; one-dimensional | The actual family-level nonvacuity source; matches the C904 (A_5) pencil up to notation/parameterization check |
| Klein cubic (Y_5) | (J(Y_5)\sim E_{11}^5) | Isolated member of (M_{H_1}), not a second family |
| Fermat (Y_1) | (J(Y_1)\sim E^5), (E) CM by (mathbf Q(\zeta_3)) | Isolated cyclic point, also in (M_{H_1}) |
| (Y_6) | (J(Y_6)\sim E^5) with the Fermat CM elliptic curve | Isolated cyclic point, also in (M_{H_1}) |
| cyclic cubic locus (M^{\rm cyc}) | Four-dimensional; contains (Y_1,Y_6), but not generically (E^5) | Larger automorphism locus, not a second elliptic-power family |
| order-five locus | (J\sim E\times B^2), (B) RM by (mathbf Q(\sqrt5)) | Two-dimensional near miss; its (A_5) overlap is (M_{H_1}) |
| (A_5) permutation component (M_{H_2}) | No all-member (E^5) claim found; intersects (M_{H_1}) at (Y_1,Y_6) | Do not fold into the C904 elliptic-power theorem |
| other maximal-automorphism (Y_2,Y_3,Y_4) | CM is recorded, but the checked source does not assert (E^5) | Isolated CM points, status insufficient for C904's (E^5) theorem |

Hartlieb's Theorem 36 is useful negative scope: within its criterion for
positive-dimensional special subvarieties generically contained in the cubic
IJ locus, the possibilities are the cyclic locus or the (A_4/A_5) loci
containing the Klein cubic; it does not prove that every such locus is
elliptic-power.  This is a bounded classification result, not an unconditional
claim that no unrelated (E^5) family exists anywhere.

## Consequences for the C904 quantifier

1. The sentence “for every smooth member of the (A_5) pencil” is
   nonvacuous and materially stronger than three isolated examples: the
   source supplies a one-dimensional family with (J(Y)\sim E_Y^5) fiberwise.
2. Fermat, Klein, and (Y_6) are validation points inside that family, not
   independent second-family mechanisms.
3. The universal-(CH_0) and one-step irrationality statements remain C904
   theorems on the smooth (A_5) pencil; the elliptic-power source only
   supplies the integral minimal-class mechanism.  It does not imply that
   the cyclic fourfold locus or the order-five twofold locus satisfies the
   C904 cycle detector.
4. A genuinely broader theorem would require a new family whose IJ is
   elliptic-power but which is not the (A_5) component.  No such family was
   source-verified in this bounded audit.

## Hostile scope warnings

* Do not infer complex (J\sim E^5) from a finite-field Weil polynomial
  ((T^2+aT+p)^5).  The Fermat/Klein finite-field calculations are arithmetic
  shadows; the complex (E^5) claims need the complex Hodge/automorphism
  sources above.
* Do not infer that the whole cyclic cubic locus is (E^5) from its Fermat
  point.  Its dimension is four, whereas the elliptic-power Hecke packet is a
  countable union of curves.
* Do not call (Y_5), (Y_1), or (Y_6) a second family: Hartlieb places them
  on the (A_5) component (with (Y_5) the distinguished non-cyclic point).
* Do not turn the dimension count into an absence/novelty claim.  The safe
  wording is: “In this bounded primary-source audit, no additional
  positive-dimensional (E^5) cubic family was located.”

## Bottom line

The C904 master locus is already a special one-dimensional containment in the
intersection of the cubic IJ locus with the elliptic-power Hecke packet.  Its
quantifier is family-level and nonvacuous.  The bounded source record supports
isolated Fermat/Klein/(Y_6) checks and an order-five near miss, but no second
positive-dimensional elliptic-power cubic family.
