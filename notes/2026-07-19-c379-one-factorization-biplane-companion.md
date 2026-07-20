# C379 companion — two one-factorizations behind the decorated deep-hole transform

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** complete; conceptual proof and explicit seed certificate closed, with the classical
one-factorization/biplane core retained only as a Clebsch compatibility corollary

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

The proof has only three finite seed obligations: the cross-sheet stabilizer intersections of
orders `12` and `10`, and one distinct same-sheet stabilizer intersection of order `6`.  C379's
primary certificate and independent replay already verify the corresponding orbit decompositions;
the following companion certificate fixes explicit representatives.

## Frozen seed representatives

Write `[a:b:c]` for the normalized projective point represented by `(a,b,c)`.  In the parent
`tau=8` convention, take

```text
M    = { [1:1:3]-[1:10:8], [1:1:8]-[1:10:3], [1:3:1]-[1:3:10],
         [1:4:4]-[1:7:4],  [1:4:7]-[1:7:7],  [1:8:1]-[1:8:10] }
N_5  = { [1:1:3]-[1:3:1],  [1:1:8]-[1:4:4],  [1:3:10]-[1:10:8],
         [1:4:7]-[1:8:1],  [1:7:4]-[1:10:3], [1:7:7]-[1:8:10] }
N_6  = { [1:1:3]-[1:1:8],  [1:3:1]-[1:7:4],  [1:3:10]-[1:7:7],
         [1:4:4]-[1:10:3], [1:4:7]-[1:10:8], [1:8:1]-[1:8:10] }
N_10 = { [1:1:3]-[1:1:8],  [1:3:1]-[1:10:8], [1:3:10]-[1:10:3],
         [1:4:4]-[1:8:10], [1:4:7]-[1:8:1],  [1:7:4]-[1:7:7] }.
```

Here `N_5,N_6` lie in the opposite sheet from `M`, while `N_10` lies in the same sheet.  Exact
stabilizer intersection gives

| seed | intersection order | element-order spectrum | suborbit | shared edges with `M` |
|:---|---:|:---|---:|---:|
| `N_5` | 12 | `1^1 2^3 3^8` (`A4`) | 5 | 0 |
| `N_6` | 10 | `1^1 2^5 5^4` (`D10`) | 6 | 1 |
| `N_10` | 6 | `1^1 2^3 3^2` (`S3`) | 10 | 0 |

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c379-one-factorization-seeds.py --check
sha256sum -c notes/2026-07-19-c379-one-factorization-seeds.sha256
```

Intentional regeneration is

```bash
python3 notes/2026-07-19-c379-one-factorization-seeds.py --write
```

The checker imports the independently written C379 replay only for the frozen field, matrix, group,
and matching conventions.  It reconstructs `A5<PSL_2(11)<PGL_2(11)`, selects the representatives
canonically, computes each stabilizer intersection directly, and identifies its isomorphism type by
the complete element-order spectrum.  The original primary checker remains the independent
cross-check for the two sheets, edge multiplicities, and design parameters; it does not independently
select these lexicographically minimal representatives.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| seed/root checker `.py` | 9,872 | `b7a649db2453527eed6a69881a78f2b09e4d5ffa957654d0546eb836ce3521c1` |
| seed/root certificate `.json` | 6,470 | `8fbcfb710baccb92e7f832c98c56222b83b2d30cb453edd76a4d27207a38f897` |

## Surviving Clebsch-specific theorem

The classical one-factorization admits a stronger geometric lift that is specific to C379.  For a
parent `X` and child-conic point `u`, let `rho_X(u)` be the unique point `x in X` such that

```text
(X - {x}) union {u}
```

lies on a conic.  Existence and uniqueness follow from the exact seven-arc census: every extension
has exactly one conic six-subset, and it contains the new point.  Equivalently, if `C_(X,x)` is the
conic through `X-{x}`, then

```text
rho_X^(-1)(x) = C_(X,x)(F_11) intersect Q(F_11).
```

**Root-resolution theorem.**  Each `rho_X:Q(F_11)->X` is a canonical two-to-one map.  For either
eleven-parent `PSL_2(11)` sheet, the assignment

```text
(X,x) |--> rho_X^(-1)(x)
```

is an equivariant bijection from its 66 parent-point flags to the 66 unordered pairs of child-conic
points.  The golden map `J` exchanges the two labelled resolutions, including the parent point and
child edge.  Thus every child secant has exactly one parent-point/root-family label in each
chirality sheet; its two endpoints give the two corresponding weak-del-Pezzo extensions.

Indeed, on the blow-up of `X union {u}`, the unique effective root has divisor class

```text
2H - sum_(y in X-{rho_X(u)}) E_y - E_u,
```

with square `-2` and canonical intersection zero.  Its two-to-one fibre records the pair of
extension directions producing the same deleted-parent label.  The seed/root checker verifies all
`66+66` labelled records, hashes their canonical serializations as
`b4a6ce9c9cbc75692d17a91bd85100d7ef1f8d6f5fe53712e8e3e6349acab3ab` and
`1a2c37e2796fccc035819d18b93fda5a60a056386bda508456347d3d5e031844`, and independently checks
`J`-equivariance.  This is stronger than recognizing an abstract one-factorization: it identifies
each factor edge with the five-parent conic, puncture, and `A1` root that produced it.

### Root-intersection reconstruction and the `A2` door

The matching decoration is itself recoverable from the weak-surface root data.  Fix a parent `X`
and distinct child points `u,v`.  On the blow-up of `X union {u,v}`, pull back the two root classes
from the respective seven-point extensions:

```text
alpha_u = 2H - sum_(y in X-{rho_X(u)}) E_y - E_u,
alpha_v = 2H - sum_(y in X-{rho_X(v)}) E_y - E_v.
```

Both have square `-2` and canonical intersection zero.  Direct intersection in the Picard lattice
gives

```text
alpha_u . alpha_v = -1,  if rho_X(u)=rho_X(v),
                       0,  otherwise.
```

Indeed, the two classes share five parent exceptional terms in the first case and four in the
second, while their plane parts contribute four.  Consequently `M_X` is exactly the six-edge graph
cut out by root intersection `-1`; no separately remembered matching is needed once the twelve
extension roots and their pairwise comparison are available.  For a matched pair,
`alpha_u-alpha_v=E_v-E_u` is also a root, so `alpha_u` and `-alpha_v` generate an `A2` root
subsystem.  For an unmatched pair the two roots are orthogonal and generate `A1+A1`.

This gives the sharp handoff to the weak-degree-one problem: the 66 unordered pairs of child
directions split intrinsically into six `A2` pairs and sixty `A1+A1` pairs for each parent.  C381
can therefore ask whether the remaining effective `E8` root subsystem is determined by this
root-intersection type, rather than importing the matching as external combinatorial decoration.
It does not revive the smooth degree-one del Pezzo route: every eight-point set still contains the
six-point conic already present in either seven-point extension.

## Exact information lattice and golden polarity

Let `Omega=G/H` be the 22-parent locus for `G=PGL_2(11)` and parent stabilizer `H~=A5`, and put
`K=PSL_2(11)`.  Transitive `G`-equivariant quotients of `Omega` correspond to intermediate
subgroups `H<=L<=G`.  There are only three:

```text
H < K < G.
```

If `L<=K`, the prime index `[K:H]=11` gives `L=H` or `K`.  If `L` meets `G-K` and
`L intersect K=H`, then `H` has index two in `L`, so `L` normalizes `H`; but the certified
normalizer is `N_G(H)=H`, a contradiction.  The remaining case gives `L=G`.  Consequently the
only equivariant information levels have sizes `22`, `2`, and `1`: full matching-decorated parent,
binary chirality sheet, and undecorated child.  In particular there is no intermediate intrinsic
equivariant summary that partially recovers a parent.

The involution `J` also identifies the two eleven-parent sheets.  After this identification,
cross-sheet share-edge incidence becomes a symmetric polarity of the `2-(11,6,3)` design, with six
absolute points.  Its complementary biplane polarity has five absolute points.  This polarity is
formally forced by `J^2=1` and invariance of edge intersection; the checker records the two diagonal
counts.  The abstract polarity is not claimed new.  Its C379 meaning is that two same-sheet parents
are polar exactly when one parent's golden conjugate has a coincident `A1`-root fibre with the
other.

## Generalization boundary

For any six-arc `X` and candidate child conic `Q` over an odd field, the six deletion conics define
an obstruction hypergraph

```text
{ C_(X,x)(F_q) intersect Q(F_q) : x in X }.
```

This is the natural general object: fibre sizes may vary and need not cover `Q(F_q)`.  If all six
fibres are two-element sets and partition the rational child conic, then

```text
q+1 = |Q(F_q)| = 6*2 = 12,
```

so `q=11`.  Hence the perfect-matching/root-resolution phenomenon cannot extend unchanged to a
different odd field; q=11 is forced simultaneously by five-point conic interpolation and rational
fibre counting.  Any all-field continuation must study the variable obstruction hypergraph or its
Frobenius action, not posit another uniform one-factorization.  That moduli/arithmetic direction
remains unallocated.

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
> the factorizations, and their disjointness matrix is the eleven-point biplane.

That statement links four structures by explicit natural maps:

- non-GRS Clebsch parents and their reversible obstruction matchings;
- the index-two inclusion `PSL_2(11)<PGL_2(11)`;
- one-factorizations of `K_12`; and
- the symmetric `2-(11,5,2)` biplane.

The last three ingredients are classical.  The publication value here is the exact compatibility
with the deep-hole obstruction and golden Clebsch passage, stated as a corollary without novelty or
priority wording.

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

## Focused literature audit and disposition

**Verdict: `CLASSICAL CORE; RETAIN AS CLEBSCH COMPATIBILITY COROLLARY; NO NOVELTY CLAIM`.**
One source was read at `full text`; two were read at `partial` depth, and one at
`abstract/metadata only`.  The classical literature separately contains the sporadic
`PSL_2(11)`-invariant one-factorization of `K_12`, the unique eleven-point biplane, and the
`PGL_2(11)` action on 22 `A5` cosets whose valency-five and valency-six orbitals are the biplane
non-incidence and incidence graphs.  These results pre-empt the abstract group/combinatorics layer
of C379.  C379 retains the exact identification of its obstruction matchings with those classical
objects as an explanatory compatibility corollary.  This audit makes no claim that such a Clebsch
deep-hole identification is absent from the literature.

### Source ledger

- **P. J. Cameron and G. Korchmaros, “One-factorizations of complete graphs with a doubly
  transitive automorphism group,” DOI
  [`10.1112/blms/25.1.1`](https://doi.org/10.1112/blms/25.1.1).** Read depth:
  `abstract/metadata only`, using the Oxford Academic and University of St Andrews records for the
  published article.  The abstract classifies the doubly vertex-transitive factorizations and names
  the sporadic `K_12` example with full automorphism group `PSL_2(11)`.  The publisher PDF was
  inaccessible, so no stronger attribution to its internal construction is made.
- **D. Duncan and E. Ihrig, “The structure of symmetry groups of almost perfect one
  factorizations,” DOI
  [`10.1216/rmjm/1022009279`](https://doi.org/10.1216/rmjm/1022009279).** Read depth: `partial`,
  through the author-uploaded ResearchGate browser rendering of Section 2, specifically the
  `PC_12` example and Corollary 2.10.  The example gives the starter
  `(0,infinity)(1,2)(3,6)(4,8)(5,10)(7,9)` and states that `PSL_2(11)` acts two-transitively on its
  one-factors.  No PDF bytes were obtainable for the shared cache.
- **J. Pan, C. Wu, and F. Yin, “Edge-primitive Cayley graphs on abelian groups and dihedral
  groups,” DOI
  [`10.1016/j.disc.2018.08.023`](https://doi.org/10.1016/j.disc.2018.08.023).** Read depth:
  `partial`, using the indexed publisher text for Example 3.1.  It takes
  `G=PGL_2(11)`, `H~=A5`, and the 22-element coset space `[G:H]`, and identifies its connected
  orbital graphs of valencies five and six with the non-incidence and incidence graphs of the
  Hadamard design.  The publisher marked the article open archive, but automated PDF retrieval
  returned HTTP 403, so the exact passage was not cached.
- **A. Blokhuis and A. E. Brouwer, “Spectral characterization of a graph on the flags of the
  eleven point biplane,” DOI
  [`10.1007/s10623-011-9570-5`](https://doi.org/10.1007/s10623-011-9570-5).** Read depth:
  `full text`, published version, all sections.  Shared-cache key `10.1007/s10623-011-9570-5`,
  SHA-256 `1c5b54066b7514a76b88127f9a7a59c3f87d1545ed1f6c23189b1d54606f4325`.  Section 1 states
  uniqueness of the symmetric `2-(11,5,2)` design and gives its `F_11` translate construction;
  the rest of the paper concerns the associated 55-flag graph.

### Search and citation-graph record

The load-bearing web queries were, verbatim:

```text
"PSL(2,11)" "one-factorization" K12
"2-(11,5,2)" biplane PSL(2,11)
"PGL(2,11)" A5 22 cosets
"one-factorization" "projective line" 11 PSL
Clebsch "one-factorization" "PSL(2,11)"
"deep hole" "one-factorization" MDS "PSL(2,11)"
"del Pezzo" biplane "PSL(2,11)"
Clebsch deep-hole biplane matching
```

The last four targeted queries returned the classical factorization sources, unrelated uses of
“deep hole,” and general `PSL_2(11)`/del-Pezzo bibliography, but no source connecting deletion
conics or `A1` roots to this factorization.  This bounded query result is not promoted to an absence
claim.  Exact-title/DOI follow-ups resolved the four sources above.  The shared literature-cache manifest
was screened first for `biplane|one.factor|PSL.?2.?(11)|projective line` and returned zero cached
matches before the Blokhuis--Brouwer PDF was added.

Citation counts were queried on 2026-07-19 from pinned DOI records:

| seed | OpenAlex | Crossref | Semantic Scholar |
|:---|---:|---:|:---|
| Cameron--Korchmaros | 37 | 25 | NOT COVERED: HTTP 429 |
| Pan--Wu--Yin | 9 | 8 | NOT COVERED: service-level HTTP 429 |
| Blokhuis--Brouwer | 3 | 3 | NOT COVERED: service-level HTTP 429 |

The exact metadata queries were
`https://api.openalex.org/works/https://doi.org/<doi>`,
`https://api.crossref.org/works/<url-encoded-doi>`, and
`https://api.semanticscholar.org/graph/v1/paper/DOI:<url-encoded-doi>?fields=paperId,title,citationCount`.
The Semantic Scholar query for the Cameron--Korchmaros seed returned HTTP 429 twice, including once
with an explicit user agent; this was distinguished from an empty result and no count is inferred.

The largest citing set was OpenAlex's 37-work Cameron--Korchmaros set, obtained from
`https://api.openalex.org/works?filter=cites:W2053256074&per-page=200&select=id,doi,display_name,publication_year,abstract_inverted_index`.
All 37 titles and available abstract token sets were screened with the discriminator
`one.?factor|biplane|hadamard|PSL|projective|A.?5|K.?12`; eight generic factorization or
`PSL_2(11)`-geometry records matched.  Their OpenAlex metadata did not contain `Clebsch` or
`deep-hole`; this is only a title/abstract screen, not an absence result.  The analogous complete
OpenAlex sets for Pan--Wu--Yin (nine works, seven generic edge-primitive hits) and
Blokhuis--Brouwer (three works, all general biplane/graph papers) were also screened over titles and
available abstracts.  Crossref supplied independent counts but no citing-set enumeration used in
the screen.

### Coverage gaps and claim boundary

The Cameron--Korchmaros full text, the Pan--Wu--Yin PDF, and the full Buekenhout--Cara--Vanmeerbeek
coset-geometry paper were not reachable.  Semantic Scholar citation counts were unavailable because
of rate limiting.  MathSciNet and Google Scholar were not covered; zbMATH was used only to confirm
the Cameron--Korchmaros metadata.  These gaps forbid a manuscript-bound “to our knowledge” claim
about the Clebsch compatibility.  They do not weaken the positive pre-emption verdict for the
classical one-factorization/biplane core, which is explicit in the sources above.

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

1. **Classical combinatorics, compatibility corollary:** retain the biplane as a concise conceptual
   corollary explaining how the 22 recoverable parents organize.
2. **Entirely classical:** use the factorization only as exposition for C379's matching theorem.
3. **Literature pre-empts the compatibility:** retain the exact factorization only as exposition
   for C379's already proved 22-matchings bijection.
4. **Arithmetic transport succeeds:** allocate a separate task for Frobenius on the unordered pair
   of one-factorizations, not for another golden intertwiner.

## Hand-back

The seven-item finite certificate, conceptual proof, frozen seed witnesses, root-resolution lift,
root-intersection reconstruction into six `A2` and sixty `A1+A1` pairs, information-lattice theorem,
golden polarity, and focused source audit are complete.  C379 exits at
the first valuable off-ramp: the classical one-factorization/biplane appears as a compatibility
corollary, while the paper-facing mathematical content is the Clebsch-specific lift from factor
edges to punctures, deletion conics, and effective `A1` roots.  No novelty or priority wording is
authorized by the present audit.  C379's matching-decorated inversion and its `11+11` organization
remain the authoritative finite result.  C380 may consume only the bounded statement and checker
interface; it should not formalize general one-factorization or biplane classification machinery.
