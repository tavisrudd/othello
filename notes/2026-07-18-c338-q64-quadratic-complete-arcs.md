# C338: the `PG(2,64)` quadratic code and 171 complete 26-arcs

**Lane:** `crowns`
**Date:** 2026-07-18
**Verdict:** `SURVIVES-EXACT-ENUMERATOR / NARROW-STRUCTURED-COMPLETIONS`

## Result

Let `A` be any of the three projective C300 classes of 24-arcs in `PG(2,64)`.  The
quadratic evaluation code on `A` has exact parameters

```text
[24,6,14]_64.
```

For the frozen representative, the numbers `N_i` of projective nonsingular conics meeting `A`
in exactly `i` points are

| `i` | `N_i` |
|---:|---:|
| 0 | 734,990,115 |
| 1 | 281,772,032 |
| 2 | 50,691,446 |
| 3 | 5,769,336 |
| 4 | 483,862 |
| 5 | 29,240 |
| 6 | 1,632 |
| 7 | 16 |
| 8 | 47 |
| 9 | 0 |
| 10 | 2 |

The exact Hamming weight enumerator is

```text
1
+ 126 z^14
+ 2,961 z^16
+ 1,008 z^17
+ 102,816 z^18
+ 1,842,120 z^19
+ 32,491,620 z^20
+ 379,917,216 z^21
+ 3,275,736,786 z^22
+ 17,938,752,552 z^23
+ 47,090,629,530 z^24.
```

The 126 minimum words are the 63 nonzero scalar multiples of each of the two quadrics cutting
the intrinsic disjoint `10+10` conic sections.  Their two 14-coordinate supports intersect in
the four-point remainder of C300's intrinsic `10+10+4` decomposition.

Let `D` be the 19 missing directions on the line at infinity.  For every pair `{u,v}` in
`C(D,2)`, the set

```text
A union {u,v}
```

is a complete 26-arc.  Thus C338 gives 171 structured completions.  C300's full projective and
semilinear stabilizers are the same order-four translation group.  That group fixes the line at
infinity pointwise, so all 171 pairs are singleton orbits under both stabilizers.  Each completed
arc has full projective automorphism group of order four and full semilinear automorphism group
of order four.

The 171 completions have 164 exact conic-intersection signatures for intersections at least five:
157 signatures occur once and seven occur twice.  Every completion has exactly two ten-point
conics.  Thirty-six have no nine-point conic and 135 have between one and six; the complete
171-row signature certificate is in the JSON artifact.  This is a stabilizer-orbit
classification as requested by C338; it does not claim that distinct singleton orbits remain
inequivalent under arbitrary projectivities that change the distinguished C300 base arc.

Every completion yields a non-GRS, nonextendable `[26,3,24]_64` MDS code.  Its dual is a
`[26,23,4]_64` MDS code of covering radius two, hence quasi-perfect.  The arc--MDS and
complete-arc--covering-code dictionaries are classical; the surviving result is the exact
structured completion package, not those translations.

## Stage A proof

### Nonsingular conics and the five moments

There are

```text
lambda_0 = q^2 (q^3-1)
```

nonsingular conics in `PG(2,q)`.  The numbers through a fixed arc `j`-subset for `0 <= j <= 4`
are

```text
lambda_0 = q^2(q^3-1),
lambda_1 = q^2(q^2-1),
lambda_2 = q^2(q-1),
lambda_3 = (q-1)^2,
lambda_4 = q-2.
```

The last two formulas follow after sending three noncollinear points to the coordinate points.
A conic through them has equation `dXY+eXZ+fYZ=0` and is nonsingular exactly when `def != 0`.
A fourth frame point imposes one nontrivial linear equation, leaving `q-2` nonsingular members.

Double-counting pairs `(C,S)` with `S` a `j`-subset of `A cap C` gives

```text
sum_i binom(i,j) N_i = binom(24,j) lambda_j,    0 <= j <= 4.
```

C300's elimination checker found `N_5,N_6,N_7,N_8,N_9,N_10 =
29240,1632,16,47,0,2`.  The C338 checker independently reconstructs every rich conic by a
closed frame formula through five points and obtains the same six values.  The five triangular
moment equations then give `N_0,...,N_4` in the table above.  Their sum is
`q^2(q^3-1)=1,073,737,728`.

### Degenerate quadrics

The arc line distribution is

```text
external = 2,877,    tangent = 1,008,    secant = 276.
```

At each arc point there are 42 tangents and 23 secants.  Counting unordered distinct rational
line pairs by type, correcting for the common arc point, gives zero-count distribution

```text
intersection 0  4,137,126
intersection 1  2,920,680
intersection 2  1,304,100
intersection 3    261,096
intersection 4     31,878.
```

Repeated lines contribute `(2877,1008,276)` at intersections `(0,1,2)`.  A nonsplit singular
conic is a Frobenius-conjugate line pair through one rational singular point.  For each of the
`q^2+q+1=4161` points there are `q(q-1)/2=2016` such pairs, and its rational zero locus is just
that point.  Hence these contribute `24*2016` at intersection one and
`(4161-24)*2016` at intersection zero.  The complete degenerate distribution is therefore

```text
intersection 0  12,480,195
intersection 1   2,970,072
intersection 2   1,304,376
intersection 3     261,096
intersection 4      31,878,
```

summing to `(q^2+q+1)(q^2+1)=17,047,617`, the exact number of projective singular ternary
quadratic forms.  Adding nonsingular and singular counts gives
`1+q+...+q^5` projective quadrics.  Multiplication by `q-1=63`, followed by the zero word,
produces the displayed enumerator and total `64^6` codewords.  Since no nonzero quadratic
vanishes on all 24 points, evaluation is injective and the dimension is six.

## Stage B proof and classification

The original arc is affine-complete and its entire uncovered locus is the 19-set `D` on one
line.  A point of `D` is on no old secant, so adjoining it creates no collinear triple with two
old points.  Two distinct points of `D` meet on the line at infinity, which contains no old
point.  Thus every pair gives a 26-arc.  After adjoining `{u,v}`, their common line covers every
remaining point of `D`; all affine points were already covered.  Hence every one of the 171 arcs
is complete.

The checker nevertheless replays all 171 arc and completeness tests directly against all 4,161
projective points.  It also verifies the four translation stabilizers among all 4,096 affine
translations.  Because C300 already certifies that these translations are the full projective
and semilinear stabilizers and they fix infinity pointwise, the pair-orbit statement follows.

To certify the *full* automorphism orders of the completions rather than merely lower bounds, the
checker tests all 325 two-point deletions of each 26-arc.  In every case the adjoined pair is the
unique deletion leaving a 24-arc with exactly 19 uncovered collinear points.  This property is
intrinsic and invariant under projective and semilinear maps.  Every automorphism must therefore
preserve the distinguished pair and its C300 base, so it belongs to the order-four base-pair
stabilizer.  The lower and upper bounds agree.

Finally, an `[n,3,n-2]_q` GRS presentation places the projective columns on a conic.  Every C338
completion has maximum conic intersection ten, so none is GRS.  Completeness is exactly
nonextendability of the projective MDS code.  Using the 26 columns as a parity-check matrix gives
the dual `[26,23,4]_64` code.  Every projective syndrome is a column or lies on a secant, so the
covering radius is at most two; it is not one because 26 is smaller than the 4,161 projective
syndrome directions.  Thus the radius is exactly two.

## Literature and database matrix

| Proposed headline | Closest source and exact overlap | Difference / verdict |
|---|---|---|
| quadratic evaluation on a point set | Ronan Quarez, [*Some subsets of points in the plane associated to truncated Reed--Muller codes with good parameters*](https://doi.org/10.1016/j.dam.2005.03.018), defines the same degree-two homogeneous evaluation map and dimension-six truncated projective Reed--Muller framework | General mechanism is prior art.  Quarez treats examples over `GF(7),GF(8),GF(9)`, not this 24-set, `GF(64)` distribution, enumerator, or minimum-support geometry. `SURVIVES-EXACT-ENUMERATOR`. |
| existence or size record for a complete 26-arc in `PG(2,64)` | Davydov--Faina--Marcugini--Pambianco's ACCT spectrum states that complete `k`-arcs exist for every `22 <= k <= 35`; Bartoli et al., [2016 bounds/tables](https://doi.org/10.1007/s00022-015-0277-z), is the later broad table | A 26-arc is known and 26 is not a size record. `STOP-EXISTENCE/RECORD`; `NARROW-STRUCTURED-COMPLETIONS`. |
| classification of the C300 two-direction completions | Small-complete-arc tables record sizes and search bounds, not this C300-derived family, its 171 fixed-base stabilizer orbits, intrinsic deletion certificate, automorphism orders, or conic signatures | No collision located. `SURVIVES-STRUCTURED-CLASSIFICATION`, bounded to the explicit stabilizer action and stated full automorphism theorem. |
| non-GRS/nonextendable MDS and radius-two quasi-perfect dual | Arc--linear-MDS equivalence and complete-arc--quasi-perfect-code correspondence are classical; see Thas's [MDS/arcs survey](https://lematematiche.dmi.unict.it/index.php/lematematiche/article/view/593) and Nagy's [saturating-set correspondence](https://arxiv.org/abs/1701.01379) | Parameters and dictionaries are not new.  Only their exact realization by all 171 structured completions survives. `NARROW`. |
| database novelty | The current [Magma best-known-code tables](https://magma.maths.usyd.edu.au/magma/handbook/text/1980) cover only fields of orders `2,3,4,5,7,8,9`; the La Jolla repository is a covering-*design* table, not a `GF(64)` linear-code classifier | Database absence is not evidence of novelty and no record claim is made. |

Forward-citation closure was run on the two closest items.  Crossref and OpenAlex report no citing
works for Quarez's paper; zbMATH indexes it as `Zbl 1091.94042`.  The four indexed forward
citations of the 2016 arc-bounds paper concern `PG(3,q)`/radius-three bounds, general radius-two
and radius-three length bounds, almost-complete conic subsets, and probabilistic saturating sets;
none classifies `PG(2,64)` 26-arcs or quadratic evaluation on a fixed 24-arc.  Searches through
2026 located no later exact collision.  MathSciNet's public interface did not expose a usable
forward-citation list, so the positive closure rests on full-text/source searches plus
Crossref/OpenAlex/zbMATH rather than a claim of exhaustive MathSciNet access.

## Evidence and replay

The atomic evidence bundle is:

- `notes/2026-07-18-c338-q64-quadratic-complete-arcs.py`;
- `notes/2026-07-18-c338-q64-quadratic-complete-arcs.json`;
- `notes/2026-07-18-c338-q64-quadratic-complete-arcs_SHA256SUMS`.

Replay from the repository root:

```bash
python3 notes/2026-07-18-c338-q64-quadratic-complete-arcs.py \
  > /tmp/c338-q64-quadratic-complete-arcs.json
diff -u notes/2026-07-18-c338-q64-quadratic-complete-arcs.json \
  /tmp/c338-q64-quadratic-complete-arcs.json
python3 notes/2026-07-18-c338-q64-quadratic-complete-arcs.py --check
sha256sum -c notes/2026-07-18-c338-q64-quadratic-complete-arcs_SHA256SUMS
```

The run is deterministic in `GF(64)=GF(2)[x]/(x^6+x+1)`.  It checks 42,504 base five-subsets,
all 4,161 lines, all 171 completion pairs, all 4,161 plane points for completeness, and all 325
deletions of every completion.  Shared four-point pencils and three-point conic spaces reduce
repeated work without sampling.  The trusted boundary is the small finite-field implementation,
projective line/coverage routines imported from the committed C210 evidence, the closed five-point
conic formula, and exhaustive finite enumeration.  The independent checks are C300's separate
Gaussian-elimination rich-conic enumeration, the five incidence moments, the singular-form total,
the line-pair incidence derivation, and the direct 171-pair coverage replay.  This proves only the
stated `PG(2,64)` package.

## Discovery-track retrospective

Review against the crowns companion found no new incidental lead.  The closed conic-pencil
enumeration, singular line-pair formula, intrinsic deletion invariant, and literature narrowing
were all sought C338 deliverables, so they remain here rather than being duplicated in the
append-only discovery track.

## Vibe check

Stage A is a clean exact code theorem with a genuinely informative enumerator and minimum-word
geometry.  Stage B is also strong as a structured completion theorem, but the literature audit
correctly removes the tempting existence/size-record headline: 26-arcs over `GF(64)` were already
known.  The momentum is good because the surviving claims are certificate-backed and precise;
the main limitation is that the 171 singleton stabilizer orbits are not asserted to be 171 full
projective equivalence classes.
