# C904/C909 second-family scout: cubic automorphism loci

## Scope and verdict

This is a bounded primary-source audit of the cyclic, (A_4), (A_5),
(PSL_2(11)), and Klein automorphism loci for smooth cubic threefolds.  The
question is stricter than (J(X)\sim E^5): the proposed second family would
also need a source-backed finite-etale marked presentation of the relevant
cycles or lattice packet.

**Verdict.**  No second positive-dimensional family is source-certified.
Hartlieb's (A_5) component (M_{H_1}) remains the only positive-dimensional
automorphism family found in this bounded audit for which every intermediate
Jacobian is explicitly proved isogenous to (E^5).  The cyclic locus is
four-dimensional, the (A_4\subset PSL_2(11)) locus is two-dimensional, and
the full (PSL_2(11)) locus is zero-dimensional.  The (A_4)-cyclic
intersection is one-dimensional, but no source checked here proves that its
Jacobians are all (E^5), let alone supplies a finite-etale marking.  It is a
candidate requiring new work, not a second-family theorem.

This is a bounded-source conclusion, not a claim that no other cubic family
can ever have an elliptic-power Jacobian.

## Exact source-backed geometry

Hartlieb, arXiv:2304.03214, Theorem 2.1, lists the six maximal automorphism
groups of smooth cubic threefolds.  In the notation used there, (Y_1,ldots,Y_6)
are the corresponding maximal examples; (Y_5) is the Klein cubic with full
group (PSL_2(11)), while (Y_1,Y_6) are the Fermat-type cyclic examples.
Hartlieb's Corollary 3.5 records CM for all six maximal examples.  His
Remark 3.6 records the stronger elliptic-power statements

* (J(Y_1)\sim E^5) and (J(Y_6)\sim E^5) for the Fermat CM elliptic curve;
* (J(Y_5)\sim E_{11}^5), the Klein/11 CM elliptic curve (use (E_{11})
  notation rather than guessing the CM field from secondary renderings).

These are isolated points, and (Y_1,Y_6,Y_5) are already accounted for by
the (A_5) geometry below.  Roulleau's primary computation for the Klein
cubic (arXiv:1001.4853) gives its period lattice, Fano-surface fibrations, and
Néron--Severi data; it does not provide a moving finite-etale marked
presentation.

Hartlieb's Section 5 gives the relevant positive-dimensional loci:

* The cyclic locus (M^{\mathrm{cyc}}) consists of cyclic triple covers of
  (mathbf P^3) branched over cubic surfaces.  It is a four-dimensional
  special subvariety (Hartlieb Section 3, using the Allcock--Carlson--Toledo
  period construction).  The source does not assert (J(X)\sim E^5) for a
  general cyclic member.  The two source-certified cyclic (E^5) points
  (Y_1,Y_6) lie on the already-known (A_5) component.
* The (A_4) family (M_{G_1}\subset PSL_2(11)) has dimension two and its
  Jacobian image is a two-dimensional special subvariety (Proposition 5.2).
  Remark 5.3 says (M_{G_1}) contains the Klein cubic and meets the cyclic
  locus in dimension one.  Neither proposition nor remark says that this
  one-dimensional intersection has all Jacobians isogenous to (E^5).
* There are two (A_5) components (M_{H_1},M_{H_2}) (Lemma 5.5), with
  (M_{H_1}\cap M_{H_2}=\{Y_1,Y_6\}).  Proposition 5.7 and Remark 5.8 prove
  that (M_{H_1}) is one-dimensional and every (J(X)), (X\in M_{H_1}),
  is isogenous to (E_X^5), via the five-dimensional rational irreducible
  (A_5)-representation and its rational commutant.  No analogous
  all-member (E^5) statement is made for (M_{H_2}).
* The full (PSL_2(11)) family containing the Klein cubic has
  (dim M_G=0) and (dim Z_G=0) (Section 3).  Thus it cannot itself be a
  positive-dimensional second family.  Hartlieb's subgroup analysis says
  that among the noncyclic positive-dimensional cases satisfying his stated
  criterion, only the (A_4) and (A_5) cases occur.

The order-five locus is a useful near miss, not a second answer.  The primary
van Geemen--Yamauchi result (arXiv:1506.05346) gives, generically, an
elliptic factor times the square of an abelian surface with real
multiplication, (J\sim E\times B^2), for a cubic with an order-five
automorphism.  The (A_5) overlap is the special elliptic-power case; this
does not promote the larger order-five or cyclic locus to (E^5).

## Dimension and marking boundary

The period map places the cyclic and (A_4) families in (A_5) with
dimensions four and two, respectively.  A fixed elliptic-power/isogeny
construction varies through a countable union of one-dimensional Hecke/Shimura
curves in (A_5).  Consequently the full cyclic or full (A_4) family cannot
be identified with an (E^5) family merely from its automorphisms.  The
one-dimensional (A_4\cap M^{\mathrm{cyc}}) intersection could in principle
be one of those curves, but the cited sources supply neither that equality nor
an isogeny/polarization calculation proving it.

The literature cited above also does not supply the stronger finite-etale
marked presentation used in the C904 construction (a finite etale marking,
the associated integral lattice packet, and the factorable cycle data).
The cyclic period construction and the Klein period/Fano calculations are
not substitutes for such a presentation.  For the isolated Klein point, a
finite scheme-theoretic marking would be vacuous as a moving family and would
still require an explicit cycle/lattice construction.

## Safe paper-facing wording

Use:

> Among the automorphism loci covered by Hartlieb's positive-dimensional
> classification criterion, the only locus presently source-certified to
> have all intermediate Jacobians isogenous to an elliptic fifth power is the
> one-dimensional (A_5) component (M_{H_1}).  The cyclic locus and the
> (A_4)-cyclic intersection remain possible targets, but the cited sources
> do not prove the required elliptic-power statement or provide the required
> finite-etale marking.

Do not use “there is no other (E^5) cubic family” without the bounded-audit
qualifier.  Hartlieb's criterion classifies certain positive-dimensional
automorphism families, not all possible elliptic-power loci.

## Primary-source ledger

* N. Hartlieb, *Special subvarieties in the moduli space of cubic threefolds*,
  arXiv:2304.03214, Theorem 2.1, Corollary 3.5, Remarks 3.6 and 5.3/5.8,
  Propositions 5.2/5.7, Theorem 6.1.
* S. Roulleau, *The Fano surface of the Klein cubic threefold*,
  arXiv:1001.4853.
* B. van Geemen--T. Yamauchi, order-five automorphisms and intermediate
  Jacobians, arXiv:1506.05346.
* J. Wei--X. Yu, classification of automorphism groups of smooth cubic
  threefolds, arXiv:1907.00392.

