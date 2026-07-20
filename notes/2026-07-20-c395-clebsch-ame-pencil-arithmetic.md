# C395 — all-odd-field AME pencil and tetrahedral arithmetic phase

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; EXACT ALL-ODD-FIELD ARC/GRS COUNT AND A4--S4--A5 PHASE`

## The theorem

Let `F_q` be a finite field of odd order and let `H_t` have the six ordered projective columns

```text
(0,1,1-t), (0,1,t-1),
(1,1-t,0), (1,t-1,0),
(1,0,-t),  (1,0,t).
```

Write `chi` for the quadratic character of `F_q`, extended by `chi(0)=0`. Then:

1. The columns of `H_t` form a six-arc exactly when

   ```text
   t(t-1)(t^2-t+1)(t^2-3t+1) != 0.
   ```

   Consequently the number of admitted parameters is exactly

   ```text
   q - 4 - chi(-3) - chi(5).
   ```

2. In the displayed column and quadratic-monomial order, the six-point conic-evaluation
   determinant is exactly

   ```text
   8t(t-1)^2(t^4-4t^3+7t^2-4t+1).
   ```

   Hence an admitted member is GRS exactly when

   ```text
   f(t) = t^4-4t^3+7t^2-4t+1 = 0.
   ```

   The number `R_q` of such parameters has the exact character formula

   ```text
   R_q = sum_(s^2=-1) (1 + chi(-1+4s)).
   ```

   Equivalently, `R_q=0` if `chi(-1)=-1`; if `i^2=-1`, then

   ```text
   R_q = 2 + chi(-1+4i) + chi(-1-4i).
   ```

   This expression is independent of the choice of `i`. Thus the pencil has exactly
   `q-4-chi(-3)-chi(5)-R_q` admitted non-GRS parameters.

   More explicitly, the GRS root count has the four arithmetic phases

   | condition | `R_q` |
   |:---|---:|
   | `chi(-1)=-1` | `0` |
   | `chi(-1)=1`, `char(F_q) != 17`, and `chi(17)=-1` | `2` |
   | `char(F_q)=17` | `3` |
   | `chi(-1)=chi(17)=1` and `char(F_q) != 17` | `2+2chi(-1+4i)`, hence `0` or `4` |

   The phase split follows particularly cleanly from

   ```text
   (-1+4i)(-1-4i)=17.
   ```

   Thus `chi(17)=-1` forces the two characters to be opposite, `chi(17)=1` forces them
   to agree, and characteristic 17 is the ramified three-root case.

3. The admitted specialization `t=-1` exists in every odd characteristic other than `3` and `5`.
   Its full projective stabilizer over `F_q` is

   | characteristic | full stabilizer | order | GRS? |
   |:---:|:---:|---:|:---:|
   | `17` | `S4` | 24 | yes |
   | `31` | `A5` | 60 | no |
   | every other admitted odd characteristic | `A4` | 12 | no |

   This classification is unchanged by extending the field within a fixed characteristic.

4. Consequently `t=-1` gives two infinite, extension-stable comparison towers: an `S4`-symmetric
   GRS `AME(6,17^n)` member for every `n>=1`, and an `A5`-symmetric non-GRS `AME(6,31^n)` member
   for every `n>=1`.

For every admitted parameter, `ker(H_t)` is an `[6,3,4]_q` MDS code and the standard equal-phase
CSS construction gives a minimal-support stabilizer `AME(6,q)` state. The non-GRS count above
therefore gives the exact non-GRS subfamily in this pencil. This invokes the standard MDS--AME
dictionary; it is not a new construction and does not classify local-unitary equivalence.

## Proof

Direct expansion of the twenty three-column determinants gives ten signed/scaled polynomial
shapes. Their radical factors are exactly

```text
t, t-1, t^2-t+1, t^2-3t+1.
```

The two quadratics have respectively `1+chi(-3)` and `1+chi(5)` roots. They have no common root:
subtracting their equations gives `2t=0`, while `t=0` satisfies neither. Neither has root `0` or
`1`. Adding the two linear exclusions proves the arc count.

The exact `6 x 6` conic-evaluation expansion gives the determinant in part 2. The certificate also
recomputes

```text
Res(f,t^2-t+1) = Res(f,t^2-3t+1) = 4,
disc(f) = 272 = 2^4*17.
```

Thus no quartic root is removed by the arc conditions in odd characteristic. For `t != 0`, put
`s=t+t^-1-2`. The identity

```text
f(t) = t^2(s^2+1)
```

reduces the quartic roots to the equations `s^2=-1` and
`t^2-(s+2)t+1=0`. The latter has `1+chi((s+2)^2-4)=1+chi(-1+4s)` roots,
which proves the formula for `R_q`. The formula also handles characteristic 17 correctly, where
one quadratic discriminant is zero.

For the symmetry statement, at `t=-1` the six integral points are

```text
(0,1,+-2), (1,+-2,0), (1,0,+-1).
```

The following two integral projectivities generate a group of order 12 on them:

```text
A = diag(1,1,-1),
B = [[0,1,0],[0,0,1],[2,0,0]].
```

Their induced permutations are `(0 1)(4 5)` and `(0 2 4)(1 3 5)`, the six-edge action of `A4`.
To prove fullness and locate every modular jump, fix the projective frame `(0,1,2,4)`. For each of
all `6! = 720` point permutations, solve over `Q` for the unique candidate projectivity and take
the gcd of the cleared cross-product residuals on all six points. Twelve permutations have zero
residual identically. The other 708 have exact obstruction distribution

```text
gcd 1:632, 2:4, 8:8, 16:4, 17:8, 31:48, 34:4.
```

Candidate-matrix denominators use only `2,3,5`. Characteristics `3` and `5` are precisely the odd
characteristics where `t=-1` is not an arc, and therefore the only admitted odd enhancement primes
are `17` and `31`. Repeating the complete construction with frame `(0,2,3,5)` gives the identical
permutation groups.

In characteristic 17, adjoining the certified projectivity

```text
[[1,0,0],[0,0,15],[0,9,0]]
```

gives element-order profile `1^1,2^9,3^8,4^6`, hence the order-24 octahedral group `S4`. In
characteristic 31, adjoining

```text
[[1,15,8],[22,11,22],[19,24,12]]
```

gives profile `1^1,2^15,3^20,5^24`, hence the order-60 icosahedral group `A5`. The construction
records every group element and checks closure from the displayed generators. Since the unique
candidate transformation for any point permutation solves a linear system over the prime field,
an extension field cannot create another permutation. Finally,

```text
(t^2-t+1)|_(t=-1)=3, (t^2-3t+1)|_(t=-1)=5, f(-1)=17,
```

so the characteristic-17 enhancement is exactly simultaneous with the GRS transition, whereas the
characteristic-31 enhancement remains non-GRS.

## Free corollaries and bounded hand-backs

- **C396:** use the exact arc and quartic factors to delete degenerate and GRS parameters before
  projective canonicalization.  The four root-count phases provide arithmetic strata for selecting
  prime-power controls.  They do not determine the projective quotient or prove holonomy
  completeness.
- **C397:** LU or Clifford equivalence is never compared across different local dimensions.  Over
  each characteristic-17 field, compare the `S4`-symmetric GRS member only with non-GRS members
  over that same field.  Over each characteristic-31 field, compare the `A5`-symmetric non-GRS
  member only with GRS classes over that same field.  In `F_31` itself the pencil has no GRS
  parameter because `chi(-1)=-1`, so those controls must be external GRS classes.  Stage B remains
  gated on an operational Clifford, logical, or operator-pushing invariant; projective stabilizer
  order alone is not an operational advantage.
- **C399:** the 720-permutation obstruction-gcd argument is a portable template for proving that a
  fixed integral orbit configuration has only finitely many modular stabilizer jumps.  C399 must
  still construct one canonical `A3/B3/H3` orbit functor; this pencil does not supply that missing
  common mechanism.
- **C402:** characteristic 31 is an exact infinite non-GRS `A5` control tower and characteristic 17
  an enhanced-symmetry GRS control tower, but every LU comparison must stay within one field.  In
  `F_31`, use external GRS classes because the pencil itself has none.  An explicit identification
  with C402's fixed integral `H3` presentation and a uniform LU invariant remain required.
- **No C398 shortcut:** source conic membership of a six-arc and containment of its complete
  deepest-syndrome locus in a conic are different predicates.  C395 proves nothing about the latter
  and does not bypass C398's incidence bound or semilinear pilot.

All substantive follow-ups are already allocated as C396, C397, C399, and C402.  The phase table
and extension towers are absorbed here and require no new queue ID.

## Exact evidence and replay

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-20-c395-clebsch-ame-pencil-arithmetic.py --check
sha256sum -c notes/2026-07-20-c395-clebsch-ame-pencil-arithmetic.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 24,069 | `a9dd5ba6e4344142a6ec368c86310a08bd307a2a78501c9af708ac7e2abb6b52` |
| certificate `.json` | 11,632 | `fb3caffc82601e85b9594424154cfaf9b44d4f95bce856a50ba0ec9a739cb6d8` |

The deterministic standard-library checker uses exact integer polynomials, Bareiss resultants,
rational projective transformations, and direct arithmetic in explicit finite-field quotients. It
replays the formulas and the refined GRS phase table over prime fields
`7,11,13,17,19,23,29,31,37` and genuine extension fields
`F_9,F_25,F_27,F_49`. The symbolic identities prove the all-field statement; the field list is a
regression replay, not an extrapolation.

The stabilizer check has two independent frame choices. The conic criterion is checked both from
the symbolic determinant and by direct finite-field Gaussian elimination. The trusted boundary is
Python 3 integer/rational arithmetic, the explicit irreducible-polynomial presentations of the four
extension fields, exhaustive permutation enumeration, and the standard arc--MDS,
six-arc--conic/GRS, and MDS--AME dictionaries. The certificate does not classify projective or
monomial equivalence for general `t`, LC/LU equivalence, phase-deformed states, or AME states
outside this pencil.

## Focused source and forward-citation audit

### Read-depth summary

This C395 audit newly read **zero external papers in full** and **one external paper partially**.
It uses the AME source boundary **secondarily only** through C374. The exact symmetry-jump theorem
above rests on the certificate, not on an absence claim, and no novelty or priority claim is made.

| source | read depth and access | boundary |
|:---|:---|:---|
| R. H. Dye, *Hexagons, Conics, A5 and PSL2(K)*, DOI `10.1112/jlms/s2-44.2.270` | **partial**: user-supplied authoritative scan, page 272, located through `dye-1991-reconstructed.txt` and verified against `dye-272.png`; reconstruction SHA-256 `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`, page-image SHA-256 `eb5e941178f4d5af189754fee9098d6507e98ad493ba54efda64c66180fc350f`; publisher metadata also checked at Oxford Academic | Dye owns the classical `A5`-stabilized Clebsch-hexagon/conic geometry and its characteristic-5 exception. C395 does not claim the tetrahedral/octahedral/icosahedral group types themselves; its exact result is the arithmetic phase of this displayed pencil. |
| Raissi--Gogolin--Riera--Acin, *Optimal quantum error correcting codes from absolutely maximally entangled states* | **secondary only** through C374, which read arXiv `1701.03359v2` partially at Sections III and VI; cache key `arXiv:1701.03359`, SHA-256 `768f70614685a881ba7902428164fe9e2cf0e78be123cd344c6e838ac072e673` | Owns the MDS-to-minimal-support-AME and CSS stabilizer construction. |

On 2026-07-20 the exact queries

```text
"characteristic 31" tetrahedral six points A5 projective geometry
"characteristic 17" octahedral six arc finite field
"six axes" A5 characteristic 31 projective plane
Dye Hexagons conics A5 PSL2(K) 1991 DOI
```

were screened over returned titles/snippets. They located Dye and generic six-axis material but no
record naming this pencil or both enhancement primes. This is discovery coverage, not a licensed
absence claim.

For the pinned Dye DOI, OpenAlex resolved seed `W2026622256`, reported 13 citing works, and returned
all 13. The set was screened over title plus available abstract using the verbatim discriminator
`characteristic 17|characteristic 31|tetrahedral|octahedral|reciprocal quartic|AME(6`; zero records
were retained. Crossref resolved the DOI but supplied a null `is-referenced-by-count`, so its
forward set is **NOT COVERED** rather than empty. Semantic Scholar returned HTTP 429 and is likewise
**NOT COVERED**. MathSciNet and Google Scholar were not accessible. These gaps are why C395 makes
no priority statement and does not use “to our knowledge.”

## Ownership and hand-back

- C384 retains the exact `q=11` two-class monomial/LU theorem.
- C374 retains the holonomy and marginal-moment invariance proofs.
- C396 retains projective equivalence and holonomy completeness/failure across the pencil.
- C397 retains the operational Clifford/logical/operator-pushing gate.
- C395 proves only the all-odd-field static arithmetic theorem and the complete `t=-1` projective
  stabilizer phase above.
