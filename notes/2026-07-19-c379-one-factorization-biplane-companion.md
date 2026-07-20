# C379 companion — two one-factorizations behind the decorated deep-hole transform

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** active C379 follow-up; conceptual proof drafted, with explicit seed representatives and
focused literature closure still required before final disposition

**Parent:** `notes/2026-07-19-c379-clebsch-deep-hole-extension.md`

## Certified input

C379 proves on the complete q=11 fixed-conic `A5_6` locus that:

- the common child is the twelve-point conic `Q(F_11)`;
- there are exactly 22 parent six-arcs under `PGL_2(11)`;
- each parent `X` canonically cuts `Q(F_11)` into a perfect matching `M_X` through its six
  five-parent conics;
- the 22 matchings are distinct and `Stab(M_X)=Stab(X)~=A5`; and
- C377's outer map `J` exchanges the two golden parents and their matchings.

Thus the reversible object is `(Q,M_X)`, not the undecorated conic and not a two-point parent fibre.

## Certified refinement

C379's version-two certificate and independent replay prove the sharper organization:

```text
22 matching-decorated parents
          = 11 parents in one PSL_2(11) orbit
          + 11 parents in the other PSL_2(11) orbit.
```

Inside either eleven-element orbit, the eleven perfect matchings partition all 66 edges of the
complete graph on `Q(F_11)`.  Each orbit is therefore a one-factorization of `K_12`.  The element
`J` lies in the other `PGL_2(11)/PSL_2(11)` coset and exchanges the two one-factorizations.

Between the two sheets, a matching from one side and a matching from the other share either zero or
one edge.  The exact cross-sheet distribution is

```text
66 pairs share one edge;       55 pairs are disjoint.
```

The `11 x 11` incidence relation “share an edge” has row and column degree six, and every two rows
have three common neighbors.  It is therefore a symmetric `2-(11,6,3)` design.  Its complement is
a symmetric `2-(11,5,2)` design, hence an eleven-point biplane.

The primary checker constructs the index-two subgroup as the normal closure of the parent `A5`
under `J`.  The independent replay reconstructs it instead as the commutator subgroup of the full
order-1320 group.  Both certify the two sheets, all edge multiplicities, the `J` exchange, the
complete `11 x 11` incidence matrix, and both design parameter sets.  The finite statement is now
paper-facing; novelty and priority are not.

## Conceptual group-theoretic proof

The finite certificate admits a short conceptual proof once the two local subgroup incidences are
isolated.  Write

```text
G = PGL_2(11),       K = PSL_2(11),       H = Stab_G(M_X) ~= A5,
```

where `M_X` is one obstruction matching.  Here `G/H` denotes the 22-element homogeneous space of
left cosets, not a quotient group: `H` is not normal in `G`.

**Proposition.**  The 22 obstruction matchings are the union of two `K`-invariant
one-factorizations of the complete graph on `P^1(F_11)`.  The outer coset `G-K` exchanges the two
factorizations.  Between them, the relation “share an edge” is a symmetric `2-(11,6,3)` design,
and disjointness is its complementary `2-(11,5,2)` biplane.

**Proof.**  Since `K` is normal of index two in `G`, the intersection `H intersect K` is normal in
`H` with index at most two.  The simple group `H ~= A5` has no subgroup of index two, so `H<K`.
Consequently the transitive 22-point `G`-set `G/H` restricts to two `K`-orbits, each of size

```text
[K:H] = 660/60 = 11.
```

These are the two matching sheets.  Every element of `G-K`, in particular the golden outer map
`J`, exchanges them.

The natural action of `K` on the twelve conic points `P^1(F_11)` is two-transitive: after sending
the first point to infinity, the unipotent translations in its stabilizer act transitively on the
remaining eleven affine points.  Hence `K` is transitive on the 66 unordered pairs of conic
points, which are the edges of `K_12`.  Fix either eleven-matching sheet.  Edge multiplicity in
that sheet is constant by `K`-transitivity, while the total number of edge occurrences is

```text
11 matchings * 6 edges per matching = 66 = |E(K_12)|.
```

Thus every edge occurs exactly once: each sheet is a one-factorization of `K_12`.

It remains to identify the cross-sheet incidence without enumerating the full `11 x 11` matrix.
Fix `M` in the first sheet.  Its stabilizer `H` acts on the opposite sheet with two suborbits of
sizes five and six.  This is the first local seed check: representatives `N_5,N_6` have

```text
H intersect Stab_K(N_5) ~= A4,       H intersect Stab_K(N_6) ~= D10,
```

so orbit--stabilizer gives `60/12=5` and `60/10=6`; the two orbits exhaust the eleven opposite
matchings.  The number `s(N)=|M intersect N|` of shared edges is constant on each suborbit.  If its
values are respectively `a,b`, the already proved one-factorization property of the opposite
sheet gives

```text
5a + 6b = sum_N |M intersect N| = 6.
```

The only solution in nonnegative integers is `(a,b)=(0,1)`.  Hence precisely the six-element
suborbit shares an edge with `M`, each such matching shares exactly one edge, and the five-element
suborbit is disjoint from `M`.

Finally, the degree-eleven action of `K` on either sheet is two-transitive.  Equivalently, the
stabilizer `H` is transitive on the other ten points; the second local seed check exhibits an
intersection of two distinct same-sheet `A5` stabilizers of order six, hence an `H`-orbit of size
`60/6=10`.  The `K`-invariant cross-sheet relation therefore has constant pair multiplicity
`lambda`.  Counting pairs of incident points inside blocks gives

```text
11 * binom(6,2) = binom(11,2) * lambda,
```

and hence `lambda=3`.  There are eleven points, eleven blocks, and degree six on both sides, so
the relation is a symmetric `2-(11,6,3)` design.  Complementation gives block size five and

```text
lambda_complement = 11 - 2*6 + 3 = 2,
```

which is the symmetric `2-(11,5,2)` biplane.  This proves the proposition.  `square`

The proof has only two finite seed obligations: the cross-sheet stabilizer intersections of
orders `12` and `10`, and one distinct same-sheet stabilizer intersection of order `6`.  C379's
primary certificate and independent replay already verify the corresponding orbit decompositions;
a paper proof can display explicit representatives or cite the standard degree-eleven
`PSL_2(11)` action once the focused literature audit identifies the appropriate classical source.

## The corrected information hierarchy

The finite q=11 fibre has three distinct levels:

```text
binary golden orientation
    = choice of one of two 11-matching one-factorizations
                         |
                         | choose one matching
                         v
matching-decorated parent (Q,M_X)
                         |
                         | forget the matching
                         v
undecorated GRS conic Q, with 22 parents collapsed.
```

This repairs two tempting but false formulations.

1. The two golden parents are not the whole fibre over `Q`; they are one distinguished cross-sheet
   pair among 22 parents.
2. The binary outer character can exchange the two eleven-parent systems without canonically
   choosing a parent inside either system.

Accordingly a future arithmetic or moduli theorem may use the two one-factorizations as a genuine
binary target, while recovery of an individual Clebsch parent requires the finer matching datum.
The rank-four orthogonal fusion from C378 is yet coarser: its `J`-fixed algebra is not obtained by
forgetting only this one bit.

## Why this could matter

The useful theorem is not merely that a biplane occurs.  The certified strong compatibility is:

> The 22 Clebsch parents lost by the deep-hole transform are exactly the perfect matchings in two
> `PSL_2(11)`-invariant one-factorizations of the child conic; the golden outer passage exchanges
> the factorizations, and their cross-incidence is the eleven-point biplane.

That statement links four structures by explicit natural maps:

- non-GRS Clebsch parents and their reversible obstruction matchings;
- the index-two inclusion `PSL_2(11)<PGL_2(11)`;
- one-factorizations of `K_12`; and
- the symmetric `2-(11,5,2)` biplane.

The likely classical status of the last three ingredients lowers standalone novelty.  Potential
novelty lies only in their exact identification with the deep-hole obstruction and golden Clebsch
passage.

## Completed pre-freeze certification gate

Before any moduli machinery, C379's finite bundle now records and replays:

1. the canonical index-two subgroup `PSL_2(11)` inside the certified order-1320 conic stabilizer;
2. the two parent-orbit lists of size 11;
3. edge multiplicity one in each eleven-matching sheet;
4. `J` exchanging the two sheets;
5. the cross-intersection counts `66` and `55`;
6. the `2-(11,6,3)` parameters and complementary `2-(11,5,2)` biplane; and
7. invariance under relabeling of the conic and replacement of a parent by an equivalent marked
   presentation.

The primary and replay use different subgroup constructions, and the version-two canonical JSON
records the two ordered matching sheets and cross-incidence matrix.  The `.sha256` manifest pins
all three load-bearing artifacts.

## Focused literature gate

No new source was read for this observation.  Before novelty wording, search primary literature and
forward citations for:

- `PGL_2(11)` acting on the 22 cosets of an `A5` subgroup;
- the two `PSL_2(11)`-invariant one-factorizations of `K_12`;
- the unique or standard eleven-point `2-(11,5,2)` biplane and its automorphism group; and
- constructions of that biplane from pairs of one-factorizations or from the projective line over
  `F_11`.

The audit must distinguish “the classical biplane is known” from “its canonical appearance as the
Clebsch deep-hole obstruction is known.”  No absence claim follows from the current keyword-level
awareness.

## Red-team stops

- Do not call the 22-parent locus a two-sheet fibre.  Only its quotient into two eleven-element
  `PSL_2(11)` orbits is binary.
- Do not call either sheet canonical without specifying the unordered two-set; `J` exchanges them.
- Do not promote a parameter match alone.  The bundle certifies the actual incidence matrix and its
  equivariant construction from the matching-decorated child; the source audit must still identify
  its classical isomorphism and ownership.
- Do not jump from `11`, `12`, or `PGL_2(11)` to Mathieu or Witt structures.  Continue only if an
  additional canonical incidence map forces such a connection.
- Do not infer a new moduli cover from the finite q=11 split.  First prove which marked functor has
  the two one-factorizations as its fibre.
- Add this layer to C380 only through the frozen finite API and bounded checker leaves; do not
  formalize general biplane or one-factorization classification machinery.

## Valuable off-ramps

1. **Classical combinatorics, new compatibility:** retain the biplane as a concise conceptual
   corollary explaining how the 22 recoverable parents organize.
2. **Entirely classical:** use the factorization only as exposition for C379's matching theorem.
3. **Literature pre-empts the compatibility:** retain the exact factorization only as exposition
   for C379's already proved 22-matchings bijection.
4. **Arithmetic transport succeeds:** allocate a separate task for Frobenius on the unordered pair
   of one-factorizations, not for another golden intertwiner.

## Hand-back

The seven-item certificate extension is complete, but C379 remains live for two publication-facing
gates.  First, replace the conceptual proof's three seed obligations by explicit representatives
in the frozen conventions: cross-sheet stabilizer intersections of orders `12` and `10`, and one
distinct same-sheet intersection of order `6`.  Second, complete the focused source audit above and
decide whether the one-factorization/biplane layer belongs as a headline compatibility theorem or
as an explanatory corollary.  Regardless of novelty disposition, C379's matching-decorated
inversion and its `11+11` organization remain the authoritative finite result.
