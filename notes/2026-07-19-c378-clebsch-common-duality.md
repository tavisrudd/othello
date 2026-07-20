# C378 — Clebsch common duality

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; FULL GOLDEN PGL2(11) COMPLETION; EXACT ORTHOGONAL FUSION; RANK-16 SIGNED FOURIER REFINEMENT`

**Literature depth:** one external source was read at full-text depth and one at partial depth with
its load-bearing passage checked against the authoritative scan.  The exact compatibility and
fingerprint screens located no predecessor, but Semantic Scholar rate-limited one required
forward-citation query, MathSciNet was inaccessible, and automated Google Scholar was unavailable.
Accordingly this report makes no priority or “first” claim.

## Theorem

Let `V=F_11^3` with quadratic form

```text
Q(x,y,z)=x^2+y^2+z^2,
```

let `G_+` be C372's projective `A5` for the `tau=8` Clebsch parent, and put

```text
        [ 1  0  0 ]
J =     [ 0  0 -1 ].
        [ 0 -1  0 ]
```

Then:

1. `J^T J=I`, and `J G_+ J=G_-`, where `G_-` is the golden-conjugate `tau=4`
   projective `A5`.
2. `H=<G_+,J>` has projective order `1320`, preserves the nonsingular conic `Q=0`, and
   therefore is the full conic stabilizer

   ```text
   H = PO_3(11) ~= PGL_2(11).
   ```

3. Its projective orbits have sizes `12,55,66`; after scalar lifting its affine nonzero
   orbits have sizes `120,550,660`.  As actual subsets of `V`, not merely by cardinality,
   these are exactly C372's fusion blocks

   ```text
   {3},       {1,5,6},       {2,4,7}.
   ```

Thus the same integral golden passage that exchanges C377's two marked Clebsch parents closes
C372's rank-eight `A5` syndrome fission to its standard rank-four affine orthogonal fusion.
Golden chirality is precisely data forgotten by this symmetry completion.

## Conceptual group proof

Dye recalls the classical identification `PO_3(K) ~= PGL_2(K)` for a nonsingular conic.  Over
`F_q`, restriction to the conic is faithful and every projectivity of the conic is induced by a
unique element of `PGL_2(q)`, so the projective conic stabilizer has order

```text
|PGL_2(q)| = q(q^2-1).
```

The exact checker establishes `J^T J=I`, conjugation of the two `A5` fibres, preservation of all
twelve isotropic directions, and `|<G_+,J>|=11(11^2-1)=1320`.  Containment plus equality of orders
therefore gives the group equality.  The quadratic-form classification of projective directions
then gives the isotropic, nonsquare, and square orbits; the checker additionally compares every
vector in these orbits with C372's three displayed unions.  The proof does not infer scheme equality
from group order or orbit sizes alone.

## The conjugate-fission gate

The higher gate is positive, but its precise object is finer than the rank-four quotient.

Let `X_+` and `X_-` be the two rank-eight translation schemes in the same syndrome space.  Their
projective groups meet in

```text
K = G_+ intersection G_-,        |K|=12,
```

the `A4` subgroup selected by the ordered golden pair.  The fifteen nonempty intersections of an
`X_+` relation with an `X_-` relation are not yet an association scheme: one intersection splits.
One exact coherent-refinement step produces the sixteen scalar-`K` orbits, with valencies

```text
1,60,40,60,120,30,120,60,120,120,60,120,120,60,120,120.
```

A second step is stable.  Hence the smallest common coherent refinement is the rank-16
scalar-`A4` translation scheme, not a direct sum of the two rank-eight Bose--Mesner algebras.

This scheme is again Fourier self-dual under the dot product: its exact eigenmatrix `P_16` satisfies
`P_16^2=1331 I`.  The map `J` fixes eight relations (the identity and seven nonzero) and exchanges four pairs,

```text
(1,10), (3,13), (6,14), (9,11).
```

Consequently its adjacency algebra has a `12+4` even/odd decomposition under `J`; both ordinary
convolution and entrywise multiplication respect the `C2` grading.  Once the `+` sheet is chosen,
the four oriented differences form the signed sector, and Fourier transform restricts to

```text
M_odd =
  -11    0   44  -22
    0  -11   22   44
   22   11   11    0
  -11   22    0   11,

M_odd^2 = 1331 I_4.
```

Changing the named chirality sheet reverses the oriented differences; it does not choose an
absolute sign.  The substantive result is the exact scalar-`A4` coherent refinement and its
four-dimensional Fourier block.  The abstract fact that an algebra automorphism yields a `C2`
eigenspace grading is standard and is not claimed as new.  No AME, Gale, cubic-surface, decoder, or
deep-hole-fibre consequence is inferred here; those need their own compatibility gates.

## Source audit and positioning

### Classical conic and `A5` boundary

- R. H. Dye, *Hexagons, Conics, A5 and PSL2(K)*, DOI
  [`10.1112/jlms/s2-44.2.270`](https://doi.org/10.1112/jlms/s2-44.2.270).
  **Read depth: partial**, user-supplied scan pages 270--271 and their OCR reconstruction.  Page
  270, section 1.2, was checked directly against `dye-270.png` (SHA-256
  `e8403d5ec07f7ab475195d41733ea52833458ccc59713fc27d15658c48eabc35`).  It states the
  classical `PO_3(K) ~= PGL_2(K)` conic group and `P Omega_3(K) ~= PSL_2(K)` commutator boundary.
  Pages 270--271 place the relevant `A5` hexagons inside that conic action.  Dye does not discuss
  syndrome association schemes, the q=11 rank-eight fission, or the signed Fourier block.

The pinned Dye DOI resolved to OpenAlex `W2026622256`.  On 2026-07-19 OpenAlex reported 13 citing
works and Crossref reported 10.  Semantic Scholar returned HTTP 429, so its independent count and
set are **NOT COVERED**.  The largest available set, OpenAlex's 13 records, was screened over title,
year, and DOI.  It consisted of conic-code, oval-factorization, primitive-arc, cubic, and Dye's later
surface papers plus one unrelated assessment item; no title or metadata described the q=11
association-scheme compatibility.  This is a metadata screen, not full-text closure.

### Fusion and Galois terminology

- Jesse Lansdown and William J. Martin, *Rational Delsarte designs and Galois fusions of
  association schemes*, DOI
  [`10.4153/S000843952510146X`](https://doi.org/10.4153/S000843952510146X).
  **Read depth: full text**, published open-access version, all sections; cache key
  `10.4153/S000843952510146X`, SHA-256
  `13498249e762f205bafe72735ec480152b0c76fb90546535da09be19740257b5`.  Proposition 3.2
  supplies the meet behavior of fusion algebras; sections 3.1 and 4 treat splitting-field Galois
  action on primitive idempotents and its Delsarte/MacWilliams consequences.  That mechanism does
  not identify the present construction: C372's eigenmatrix is integral, while C378 conjugates two
  geometric `A5` orbit partitions by an outer projectivity.  The rank-16 common refinement, rather
  than the rank-four common fusion, carries the signed sector.

The pinned DOI resolved successfully in all three required citation services.  OpenAlex resolved it
to `W4416300436` and reported zero citations; Crossref reported zero; Semantic Scholar resolved it
to `bfa9b824d0ad21827cc52b85ed52b314de649cb0` and reported zero.  Each response contained the
pinned title, distinguishing a genuine zero from an empty or failed response.

### Exact screens

The load-bearing web queries were, verbatim:

```text
"PGL(2,11)" "A5" association scheme fission
"PGL_2(11)" A5 orthogonal group three dimensional finite field
Galois conjugate association schemes fusion fission orbital algebra
"rank-eight" A5 fission "orthogonal" association scheme 1331
"1331" association scheme A5 Fourier self-dual
"A4" translation association scheme F_11^3 rank 16
"signed MacWilliams" association scheme involution fission
```

The first screen promoted the Lansdown--Martin paper above; the exact fingerprint searches returned
no matching paper.  This licenses only the bounded statement “no predecessor was located in the
recorded screen.”  MathSciNet was not institutionally accessible and is **NOT COVERED**; automated
Google Scholar access was unavailable; Semantic Scholar's Dye forward query was rate-limited.
There is therefore no novelty or priority verdict.

## Exact evidence and replay

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c378-clebsch-common-duality.py --check
python3 notes/2026-07-19-c378-clebsch-common-duality-replay.py
sha256sum -c notes/2026-07-19-c378-clebsch-common-duality.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-19-c378-clebsch-common-duality.py --write
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker `.py` | 12,219 | `e45e71c5e87ccc334fab3b926e5189373e24485adf11ed1cbaacfc6771610bdc` |
| independent replay `.py` | 4,614 | `71d0a6799f4b567736881c431d758b90eff33fbd131b9cc91e9b04ef119e9c57` |
| canonical certificate `.json` | 7,431 | `3b311e5ee8ba5d09510fe18e4c5f3e30223c804d49b7c5b206e125ce1ad879dc` |

The primary standard-library checker pins C341's orbit generator, constructs both conjugate `A5`
groups, exhausts the generated projective group, compares every affine orbit with the C372 fusion,
computes the common coherent refinement, its complete intersection tensor and exact eigenmatrix,
and verifies ordinary and entrywise `C2` grading plus the odd Fourier square.  The certificate stores
the full rank-16 eigenmatrix and a canonical hash of the intersection tensor.

The independent replay imports neither the primary checker nor C341.  It reimplements finite-field
matrix arithmetic, the `H3` roots and reflection groups, both group closures, affine orbits, the
rank-16 Fourier matrix, the `J` relation action, and the signed block.  It reads the certificate only
to fix the primary's canonical relation order and then recomputes every checked entry.

The trusted boundary is Python 3 exact integer arithmetic, exhaustive finite enumeration, C341's
pinned q=11 orbit labelling in the primary checker, the independent root/reflection reconstruction,
and the classical conic-stabilizer identification.  The computation does not prove a general-field
fusion theorem, identify every automorphism of the rank-16 scheme, classify isomorphic schemes of
order 1331, or establish a marked deep-hole fibre theorem.

## Hand-back

C378's required first gate is green and the signed/Fourier gate yields one exact new structural
consequence.  It does not authorize a broader AME, surface, Gale, or all-prime program.  C379 has
since completed the independent marked deep-hole-fibre/iteration probe: the undecorated transform
terminates, matching decoration recovers all 22 parents, and `PSL_2(11)` organizes the matchings
into two one-factorizations with biplane cross-incidence.  C380 may formalize only the stable
group-orbit-to-fusion seam, signed finite matrix identity, and bounded C379 leaves.
