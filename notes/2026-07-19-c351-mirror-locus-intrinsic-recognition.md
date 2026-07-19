# C351: intrinsic recognition of the mirror family

**Date:** 2026-07-19
**Lane:** `crowns`
**Status:** complete bounded negative; the three uncoloured interfaces do not determine the marked mirror parameters

## Result

The requested intrinsic reconstruction theorem is false for the stated uncoloured inputs.
There are two C333 members over `F_11`,

```text
(delta,b)=(2,2)  and  (delta,b)=(2,4),
```

which are inequivalent under C350's exact marked equivalence (preserve the conic, burned orbit,
and mirror; forget centre-orbit order and representatives), but have all three of the same
forgotten objects:

1. isomorphic uncoloured residual graphs;
2. isomorphic uncoloured edge-multiplicity unions of the four repair matchings; and
3. projectively equivalent unmarked six-point systems, hence monomially equivalent associated
   `[6,3,4]_11` codes.

Both configurations lie on determinant sheet `+-`, generate the full group of order
`|PGL_2(11)|=1320`, and have the generic marked stabilizer `<tau>`.  The collision is therefore
not a subfield, `A5`, `S4`, or enhanced `C2 x C2` automorphism exception.  It is an
information-theoretic loss caused by forgetting the mirror/centre decomposition itself.

Consequently no algorithm, polynomial-time or otherwise, can recover `tau`, the two centre
orbits, or `[delta,b]` up to C350 marked equivalence from any one of the three stated objects on
the full C333 promise family.  A list-valued recognizer may return both marked lifts, and a
coloured or geometrically marked input may select one, but neither is the requested intrinsic
recovery.

## Exact collision certificate

Encode infinity by `11`.  The two residual live sets are

```text
L_22 = [0,1,2,4,6,9,10,11]
L_24 = [0,1,2,3,5,7,8,11].
```

In the displayed index orders, the permutation

```text
[0,1,2,6,3,4,5,7]
```

is an isomorphism of their simple residual graphs.  On all twelve projective-line vertices,

```text
[0,1,2,6,8,9,3,10,4,5,7,11]
```

is an isomorphism of the loop-deleted edge-multiplicity repair unions.  Finally, the projective
matrix

```text
[4  6  3]
[0 10  1]
[0  9  1]
```

maps the unmarked six-point system for `(2,2)` onto that for `(2,4)`.  Direct substitution checks
all three witnesses.

The C350 quotient representatives are nevertheless different:

```text
(2,2): (((0,1),(2,0)), ((1,2),(4,6)))
(2,4): (((0,1),(2,0)), ((1,4),(8,6))).
```

Neither is fixed by the residual simultaneous-sign projectivity, so both are on the generic
marked-stabilizer stratum.  This is the load-bearing inequivalence: the code projectivity and graph
isomorphisms do not transport the hidden C350 marking.

## Bounded scan and exceptional strata

The deterministic scan exhausts every passing C333 parameter in the first four odd prime fields:

| `q` | parameters | residual collision pairs | repair collision pairs | code collision pairs | collisions in all three |
|---:|---:|---:|---:|---:|---:|
| 5 | 1 | 0 | 0 | 0 | 0 |
| 7 | 4 | 0 | 0 | 6 | 0 |
| 11 | 13 | 6 | 3 | 26 | 1 |
| 13 | 6 | 0 | 0 | 1 | 0 |

Thus the raw `[6,3,4]` code already forgets the parameters maximally at `q=7`: all six pairs of
distinct normalized parameters are code-equivalent.  The graph and repair interfaces first collide
at `q=11` in this scan.

The small-field automorphism audit also identifies the expected ambiguity phenomenon.  For
`q=7`, `(delta,b)=(6,4)` has four fixed-point-free nonadjacent involutory automorphisms of both
the residual and repair objects, split into two conjugacy classes in the respective uncoloured
automorphism groups.  Three of the four repair candidates normalize the true set of four matching
permutations.  Hence even recovering “an admissible mirror” need not recover the supplied mirror;
this is recorded as an exceptional uncoloured-object stratum, not confused with C350's marked
`C_2 x C_2` stabilizer count.

These finite results do not assert that every larger field has a collision, nor do they classify all
uncoloured automorphism strata.  One generic collision is enough to refute the promised recovery
theorem, and the exact task gate did not authorize replacing recovery by a list decoder or adding
markings.

## Algorithmic implication closure

The implication chain stops before geometry:

```text
uncoloured bounded-degree graph
    -> polynomial-time isomorphism/canonization machinery
    -/> hidden matching colours or marked mirror
    -/> C350 marked class
```

Luks's bounded-valence result already puts isomorphism of these maximum-degree-four graphs in
polynomial time.  That settles comparison of forgotten objects, not inversion of the forgetful map.
The explicit `q=11` fibre has size at least two, so no stronger canonizer can repair the missing
information.

For codes, projectivizing nonzero generator columns recovers exactly the unmarked six-point set.
That code/point-set equivalence is classical and recent algorithms refine how equivalence is tested;
none supplies the discarded choice of conic, burned orbit, mirror, or centre-orbit partition.  The
displayed projectivity proves that this is a real fibre, not an algorithmic weakness.

A strengthened input does admit direct recovery: if the conic carrier and four matching colours are
retained, each colour class determines its Frégier centre as the common intersection of its secant
lines, and the three pairings of four centres give a constant-size linear test for `tau`.  This is
precisely the supplied colouring/marking route excluded by C351, so it is not promoted as the task's
theorem.

## Novelty and forward-citation audit

Five external sources are named below: one was read at **full text**, three at **partial** depth,
and one at **abstract/metadata only** depth.  No located source states the C333 forgetful-map
collision.  This is a narrow negative certificate, not a priority claim for graph canonization,
code equivalence, the Frégier dictionary, or commuting-involution graphs.

| Source | Read depth and access | Boundary for C351 |
|:--|:--|:--|
| E. M. Luks, *Isomorphism of graphs of bounded valence can be tested in polynomial time*, DOI `10.1016/0022-0000(82)90009-5` | **abstract/metadata only**, publisher record and abstract, consulted 2026-07-19; full text not obtained | pre-empts novelty of polynomial-time isomorphism for the residual's bounded-degree graph class; it does not invert a noninjective forgetful map |
| I. Bouyukliev and S. Bouyuklieva, *About Code Equivalence -- a Geometric Approach*, arXiv:2202.02086 v1 | **partial**, cached PDF/text SHA-256 `a69e90db8361401a53ef767afdc1d816e28bf513117e9d8546a6b025d1d1bd3b`; abstract and Sections 1--3 read | supplies the code/multiset-of-projective-points equivalence and incidence-matrix canonization boundary |
| M. Kreuzer, *Code Equivalence, Point Set Equivalence, and Polynomial Isomorphism*, arXiv:2511.06843 v2 | **partial**, cached PDF/text SHA-256 `b01aae41b539e77739e03d10a22dcc74dfc9f1e844eb2b8c9b0dd8198e3c209f`; abstract, Sections 1--2, Theorem 6.5, Section 8, and conclusion read | gives current reductions between linear-code, point-set, algebra, and polynomial equivalence; no recovery of discarded geometric markings |
| J. Bryden and P. Rowley, *Automorphism Groups of the `PSL_2(q)` Commuting Involution Graphs*, arXiv:2509.25901 v2 / DOI `10.1515/jgth-2025-0143` | **full text**, cached PDF/text SHA-256 `e212b62827e7815c4aa0de283428fc735a245940ff5bea5f04be5b390a587bc4` | its vertices are one conjugacy class of involutions and adjacency is commutation; C351's vertices are projective-line points and its four involutions are forgotten edge colours, so the objects and rigidity statements differ |
| P. Tranchida, *Triples of involutions in `PGL(2,q)` and their incidence geometries*, arXiv:2411.10299 v1 / DOI `10.2140/iig.2025.22.25` | **partial**, cached PDF/text SHA-256 `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`; abstract, introduction, Sections 2.1--2.2 and 3--5 read | supplies the Frégier point--involution dictionary and triple/subgroup geometry, not reconstruction from an uncoloured four-generator union |

C337 was also read in full as an internal source.  Its successful heavy-conic recovery uses an
intrinsic `2Q,Q,Q` incidence fingerprint that is absent here.  C295 remains externally gated and has
no completed reconstruction artifact to duplicate.

Forward citation closure was rerun on 2026-07-19 for the two recent involution seeds, pinned by DOI.
For Tranchida (`10.2140/iig.2025.22.25`), OpenAlex (`W4414036822`), Crossref, and Semantic Scholar
each returned citation count zero.  For Bryden--Rowley (`10.1515/jgth-2025-0143`), OpenAlex
(`W7128787643`), Crossref, and Semantic Scholar also each returned zero.  The largest screened set
therefore had size zero; the fields screened were the services' citing-work metadata, and an empty
JSON result was distinguished from an HTTP/API error.  The load-bearing API queries were:

```text
https://api.openalex.org/works/https://doi.org/<DOI>
https://api.crossref.org/works/<DOI>
https://api.semanticscholar.org/graph/v1/paper/DOI:<DOI>?fields=title,citationCount,citations.title,citations.year
```

Exact-title searches were also run for the two involution papers and for bounded-valence
canonization, code/point-set equivalence, association schemes, coherent configurations, and graph
colour reconstruction.  C350's same-day audit records zbMATH Open's title-only Tranchida record
`8090423`; a repeat exact-title web search exposed no additional review or citing work.  MathSciNet
was **NOT COVERED** because institutional authentication was unavailable.  Google Scholar was
**NOT COVERED** because automated access is blocked.  These gaps license no global absence claim;
the mathematical verdict rests on the explicit collision, not on literature silence.

## Evidence, replay, and trusted boundary

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-19-c351-mirror-locus-intrinsic-recognition.py --check
sha256sum -c notes/2026-07-19-c351-mirror-locus-intrinsic-recognition.sha256
```

The standard-library generator deterministically enumerates all passing C333 parameters over
`F_5,F_7,F_11,F_13`; builds the residual graph, uncoloured repair edge-multiplicity matrix, and
six-point code; performs exact backtracking graph isomorphism and exact projective-frame
equivalence; checks C350 marked inequivalence, sheet, generated group order, and enhanced-stabilizer
status; and records direct witnesses.  There is no random seed.  JSON is sorted, timestamp-free,
and schema-tagged.  `--check` regenerates into a temporary directory and leaves the worktree
unchanged.

| Load-bearing artifact | Bytes | SHA-256 |
|:--|--:|:--|
| C333 finite-field/family input | 15,338 | `698a5c02762c7a13ba18b422449c2fea514f7335d25bf0a90b40431c21665a4a` |
| C350 quotient/equivalence input | 11,569 | `288709ee581519484d8117b21e47bc19426f9cbb9a6335d368dd3ccdd3a42c2b` |
| C351 generator/checker | 16,332 | `804c613f9fabf8249192a775a92a3fe90a5d64904e6b83a3b1274fb6ea057b9e` |
| C351 canonical certificate | 4,941 | `29b0876c3d350be772c3026bee1847b4b5023495383cfe48e968518a47737868` |

The collision is checked twice in one executable: first by uniform pair enumeration, then by direct
substitution of the saved permutations and projectivity into independently rebuilt objects.  The
trusted boundary is the C333 finite-field implementation and C350 marked-equivalence theorem.  The
computation does not prove an all-field collision theorem, classify every exceptional stratum, or
rule out recovery after adding colours, carrier geometry, or a promise that excludes the certified
fibre.

## Vibe check

Disappointing as a crown, but decisive and useful: the strongest possible generic recognition claim
dies on a clean full-group, generic-stabilizer `q=11` fibre, so there is no reason to spend effort on
more elaborate canonization.  The positive route now requires an explicitly stronger input, not a
better invariant of the same forgotten object.
