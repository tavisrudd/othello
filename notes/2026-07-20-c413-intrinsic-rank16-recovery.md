# C413 — intrinsic rank-16 golden-pair recovery and three-view Hecke tomography

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; ABSTRACT RANK-16 SCHEME RECOVERS THE UNORDERED GOLDEN PAIR; THREE CONJUGATE HECKE VIEWS REMOVE THE 4/6-FIBRE OBSTRUCTION`

## Result

C378's abstract rank-16 scalar-`A4` translation scheme intrinsically recovers the four `J`-paired
odd relations and the unordered pair of golden rank-eight `A5` fusions.  Its intersection tensor
has algebraic automorphism group exactly `C2`: the identity and the simultaneous swap of all four
odd pairs induced by `J`.  There is no independent pair-flip ambiguity.

Among the `201,600` mechanically generated rank-eight fusion candidates with the intrinsic Clebsch
valency pattern

```text
1, 60, 100, 120, 150, 300, 300, 300,
```

the Bannai--Muzychuk row-sum test leaves exactly two.  They are C378's `tau=8` and `tau=4`
rank-eight schemes, and the sole nontrivial algebraic automorphism exchanges them.  C373's
intrinsic reconstruction applied to each recovered fusion therefore gives the unordered golden
`A5` pair; their intersection is the intrinsic `K=A4`.

On the 22 matching-decorated parents `G/H`, with `G=PGL_2(11)` and `H=A5`, this `K` has orbit sizes

```text
1,1,4,4,6,6.
```

The two singleton cosets are exactly the golden matching pair, and C379's faithful matching
decoration recovers the corresponding unordered Clebsch-parent pair.  Choosing an orientation of
the global `J` torsor selects one member; the abstract scheme alone correctly does not.

C437's within-fibre obstruction can also be removed without raising the moment degree.  The 55
conjugates of the C411 `A4` view form a canonical `G`-equivariant tomography family.  One view has
six fibres and no pair of views separates more than 12 of the 22 parents, but three views can
separate all 22.  Exactly 880 of the `binom(55,3)=26,235` triples separate; they form two `G`-orbits
of sizes 220 and 660.  Thus three is the sharp number of conjugate rank-two Hecke views for full
parent-label recovery.  An individual triple is a choice, while the full 55-view family and the two
separating-triple orbits are canonical.

There is a further intrinsic distinction between those two orbits.  A triple in the orbit of size
220 has setwise stabilizer of order six, with element-order distribution `1,2^3,3^2`; it is `S3`,
and its induced action on the three channels is the full symmetric group.  A triple in the orbit
of size 660 has only a `C2` setwise stabilizer, acting through two channel permutations.  Thus the
220-orbit is the unique maximally symmetric family of minimal separating instruments.  This
canonically selects a family, not an individual member of that family.

Finally, C378's exact Fourier self-duality transports the intrinsic recovery theorem to the dual
side: because `P_16^2=1331 I`, the same recovered `J`-pairs and unordered golden fusion pair can be
read from the primitive-idempotent/Krein presentation after the Fourier identification.  This is
an algebraic dual recovery statement only; it does not supply the geometric interpretation of the
odd Fourier image sought by C415.

## Intrinsic relation recovery

Start only with the rank-16 intersection tensor and valencies.  Iteratively color a relation by
its current color and, for every ordered pair of color classes, the multiset of structure constants
`p_ij^k` over that rectangle.  Stabilization gives

```text
{0},{2},{4},{5},{7},{8},{12},{15},
{1,10},{3,13},{6,14},{9,11}.
```

These are eight individually recovered relations and exactly C378's four `J`-pairs.  Any algebraic
automorphism must preserve these stable classes.  Exhausting the remaining `2^4=16` pair flips
leaves only

```text
identity,
(1 10)(3 13)(6 14)(9 11)=J.
```

Hence the odd four-space and its global sign torsor are intrinsic to the abstract structure
constants.  The calculation does not import C378's relation names to obtain the partition; those
names are used only afterward to identify the recovered pairs with the frozen geometry.

## Intrinsic fusion recovery

A Clebsch rank-eight fusion must have the displayed valency multiset.  Since the rank-16 valencies
are

```text
1; 30; 40; five copies of 60; eight copies of 120,
```

every candidate has the forced block shapes

```text
1 | 60 | 40+60 | 120 | 30+120 | three copies of (60+120+120).
```

The checker generates every assignment of these shapes.  For each column partition it applies the
Bannai--Muzychuk criterion to C378's exact eigenmatrix: the row sums must take exactly eight row
signatures.  Deduplication leaves precisely the two partitions recorded in the certificate.  They
match the two known golden fusions as sets of rank-16 relations and are exchanged by `J`.

This is the promised intrinsic recovery rather than a supplied-coordinate restatement: “rank-eight
fusion with the Clebsch valency pattern” is a predicate on the abstract eigenmatrix, and it has one
unordered two-element solution set.

## Parent recovery

Each recovered rank-eight fusion satisfies C373's theorem: a distinguished valency-60 constituent
recovers the characteristic translation group, the six scalar-line column blocks, and the affine
`A5` stabilizer.  Applying this to the two fusions recovers the unordered `A5_+,A5_-` pair.  C378
then gives

```text
K=A5_+ intersection A5_- = A4,
<A5_+,A5_-> = PGL_2(11).
```

The induced action on the 22 conjugate `A5` parents is `G/H`.  C411's double-coset theorem gives
the exact `K`-orbit decomposition `1,4,6 / 1,4,6`.  The two fixed cosets are the two `A5` parents
containing the recovered `K`, equivalently the singleton depth profiles.  In C379's frozen
dictionary those cosets carry the unique fixed matching and its `J`-mate, and matching decoration
recovers the parent faithfully.  The composite therefore recovers the unordered golden parent pair
from the abstract rank-16 scheme.

No preferred parent is claimed.  The only algebraic automorphism is exactly the global operation
that swaps the two recovered fusions, odd-relation orientations, singleton profiles, matchings, and
parents.

## Conjugate-view tomography

Let `D_K:G/H -> K\G/H` be C411's six-valued depth map, which separates its six double cosets.  For
every conjugate `K^g`, transport this view to obtain `D_(K^g)`.  There are exactly

```text
[G:N_G(K)] = 1320/24 = 55
```

distinct views.  Their full product is canonical and `G`-equivariant.  The exact joint-fibre
spectra are:

| views | number of joint cells | number of choices |
|:---:|---:|---:|
| 2 | 9 | 220 |
| 2 | 10 | 110 |
| 2 | 12 | 1,155 |
| 3 | 10,12,13,14,15,16,18,19,20 | 25,355 total |
| 3 | **22** | **880** |

Thus two views never suffice and three sometimes do.  The 880 separating triples split into two
`G`-orbits of sizes `220+660`.  This is stronger than merely observing that all conjugates must
separate in a primitive action: it gives the sharp tomography width and exact orbit structure.

Orbit--stabilizer sharpens the canonicality statement.  The size-220 orbit has stabilizer `S3`
and the induced channel action has order six, whereas the size-660 orbit has stabilizer `C2` and
induced channel action of order two.  Hence “minimal, separating, and maximally channel-symmetric”
intrinsically specifies exactly the 220-member orbit.

The result lessens, but does not repeal, C437's obstruction.  No higher polynomial in one view can
separate points in the same fibre.  Separation comes from adding independently positioned Hecke
channels.  A canonical system uses all 55 channels or one entire orbit of separating triples; a
single three-channel instrument requires choosing a triple.

## Literature boundary

This report adds **zero newly full-read sources**.  It inherits C378's one-full/one-partial audit,
C406/C411's six-full baseline, C373's partial CI/isomorphism sources, and C400's three-full
association-scheme boundary.  The claim-specific search adds:

- Francis Buekenhout, Julie De Saedeleer, and Dimitri Leemans, *On the rank two geometries of the
  groups PSL(2,q): part II* (2013): **partial**, open published PDF from the Slovenian Digital
  Library, abstract, Sections 3--5 subgroup/coset-geometry setup, and the appendix entries for
  `Gamma(PSL_2(q);A5,A5,A4)`.  This directly pre-empts the bare `A5--A4--A5` coset geometry and its
  uniqueness up to the stated group actions.  It does not discuss the q=11 rank-16 translation
  scheme, its two intrinsic rank-eight fusions, signed depth profiles, or conjugate Hecke
  tomography.
- Ryabov's CI and separability results remain at the read depths recorded by C373/C400.  They bound
  the generic Cayley/Schur-ring language but do not make this rank-16 scheme automatically
  separable; the known TI and quasiregular criteria already fail at q=11.

The exact web screens were `"PGL(2,11)" "A4" "A5" cosets`, `"PGL_2(11)" "A4"
association scheme`, `"A4" "F_11^3" translation scheme`, `"PGL(2,11)" base size A5`, and exact
title/geometry searches for the Buekenhout--De Saedeleer--Leemans paper.  They located the classical
rank-two coset geometry but no exact rank-16 reconstruction or three-view theorem.  No new forward-
citation closure was run; MathSciNet and Google Scholar remain uncovered.  Accordingly this report
makes no unrestricted novelty or priority claim.  Its defensible contribution is the exact
Clebsch-specific reconstruction/compression composition.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13.12:

```bash
python3 notes/2026-07-20-c413-intrinsic-rank16-recovery.py --check
python3 notes/2026-07-20-c413-intrinsic-rank16-recovery-replay.py
sha256sum -c notes/2026-07-20-c413-intrinsic-rank16-recovery.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-20-c413-intrinsic-rank16-recovery.py --write
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 14,842 | `0e24dd3f556247f2015cd37a7a32467881925cfdbde67aa673920b5f6cd1f18d` |
| independent replay | 9,531 | `faf282965ead20b06422ef032ab170e4bd88b7e933e47806d3d9d749a2d5c6bb` |
| canonical JSON | 2,773 | `4b094a336e975cd446113a33685ddb9c2b5aa02bb28bd599496a33f4366c9303` |

The primary rebuilds C378's exact rank-16 tensor/eigenmatrix and C411's group/matching action from
their frozen constructors.  The replay independently reconstructs the H3 reflection groups,
rank-16 translation classes and tensor, relation refinement, algebraic pair flips, the two claimed
fusions, the 55 conjugate views, and the complete pair/triple joint-cell spectra.  The trusted
boundary is exact prime-field/integer arithmetic, the standard Bannai--Muzychuk fusion criterion,
C373's proved intrinsic rank-eight reconstruction theorem, and C379's proved faithful
matching-decoration recovery.

The certificate does not prove general separability of the rank-16 scheme, a portable theorem for
all `A5--A4--A5` geometries, or a canonical choice of one separating triple.  It canonically
distinguishes the maximally symmetric orbit of 220 triples, and Fourier self-duality gives a dual
algebraic recovery, but neither assertion supplies C415's missing geometric odd-sector map.

## Disposition

C413 passes.  The abstract scheme recovers exactly the unordered information that geometry permits,
and three conjugate Hecke views sharply eliminate C411's individual fibre loss.  C433's derived
socle channel remains useful for reducing modular dimension inside one view, but it is no longer
needed to recover the 22 parent labels once conjugate tomography is allowed.
