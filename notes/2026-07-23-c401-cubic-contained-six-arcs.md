# C401 — cubic-contained uncovered loci of six-arcs

**Lane:** `crowns`

**Date:** 2026-07-23

**Verdict:** `ALL-FIELD EXACT CLASSIFICATION; THE CUBIC BRANCH COLLAPSES TO DEGREE AT MOST TWO`

**Literature depth:** no newly consulted source was read at full text. One paper was read partially
from its complete publisher PDF, one thesis was read through its repository metadata and indexed
section extracts, and one arXiv paper was read partially in HTML. This report also consumes C398's
separate audit, which read three sources at full text, without changing its attributions.

## The theorem

Let `A` be a six-arc in `PG(2,q)` and let

```text
U(A) = PG(2,q) \ union_{a != b in A} line(a,b).
```

Suppose `U(A)` is nonempty and is contained in the rational point set of a nonzero
`F_q`-curve of degree at most three. Then `q` is one of

```text
7, 8, 9, 11,
```

and, more strongly, `U(A)` is already contained in a curve of degree at most two. Up to
`PGammaL_3(q)` there are exactly nine classes, comprising ten `PGL_3(q)` classes:

| `q` | `|U(A)|` | minimum curve | GRS parent? | semilinear stabilizer | projective subclasses |
|---:|---:|:---|:---:|---:|---:|
| 7 | 2 | unique rational line | yes | 12 | 1 |
| 8 | 4 | pencil: 6 nonsingular conics, 3 rational line-pairs | no | 12 | 1 |
| 8 | 4 | pencil: 6 nonsingular conics, 3 rational line-pairs | yes | 18 | 1 |
| 9 | 6 | unique nonsingular conic | no | 6 | 2 |
| 9 | 4 | pencil: 7 nonsingular conics, 3 rational line-pairs | yes | 48 | 1 |
| 9 | 7 | unique nonsingular conic | no | 6 | 1 |
| 9 | 8 | unique nonsingular conic | yes | 8 | 1 |
| 9 | 8 | unique pair of rational lines | no | 8 | 1 |
| 11 | 12 | unique nonsingular conic | no | 60 | 1 |

Thus irreducible cubics, line-plus-conic cubics, three-line cubics, and nonreduced cubics produce
no additional six-arc class. This is a statement about the minimum containing degree: a locus
already on a line or conic can of course also be put on many reducible or nonreduced cubics by
multiplication. No survivor requires such a cubic.

The four non-GRS nonsingular-conic rows — one over `q=8`, two over `q=9`, and the full conic over
`q=11` — are exactly C398's four classes. The five additional semilinear rows are the `q=7` line
case, the GRS `q=8` pencil, two GRS `q=9` cases, and one non-GRS reducible `q=9` case.

## The reducible q=9 exception

Use `F_9 = F_3[a]/(a^2+1)` with polynomial-basis integer encoding and the standard frame

```text
(0,0,1), (0,1,0), (1,0,0), (1,1,1).
```

The unique semilinear non-GRS class whose locus is not on a nonsingular conic has final points

```text
(1,2,3), (1,6,4).
```

Its eight uncovered points lie on the unique quadratic

```text
7X^2 + 7Y^2 + 4Z^2 + 8XY + 6XZ + YZ = 0,
```

which, up to the displayed scalar, factors as

```text
(X + 4Y + 7Z)(X + 5Y + 7Z).
```

The two component lines each contain four locus points and their intersection is not in the locus.
No double line or nonsplit conjugate pair occurs in any minimum-degree quadratic profile.

The `ej` intrinsic upgrade removes the remaining coordinate-choice mystery. The projective
stabilizer induced on the six arc points is `C4`, with orbits of sizes two and four. The two
short-orbit vertices support the unique two tangents containing four uncovered points; these
tangents are exactly the two displayed factors. Across all thirty tangents, the number of uncovered
points has histogram

```text
1^16, 2^12, 4^2.
```

Each factor line has secant-multiplicity profile `0^4, 2^5, 5^1`: four uncovered points, five
ordinary twice-covered points, and its base arc vertex on five pair-secants. The arc has exactly
two Brianchon points, and the short-orbit vertex pair is a paired edge in both corresponding
perfect matchings. Thus the line-pair is recoverable intrinsically from the stabilizer and tangent
incidence, not merely from factoring a chosen coordinate form.

## Why the classification is finite

Let `C` be a nonzero plane cubic over `F_q`, with `q>=4`. It cannot contain every rational point:
on an affine chart its polynomial has degree at most three in each variable, strictly below `q`.
Choose a rational point `P` off `C`. Each of the `q+1` lines through `P` restricts the cubic to a
nonzero binary cubic and hence contains at most three points of `C`. Therefore

```text
#C(F_q) <= 3(q+1).
```

If `U(A)` lies on `C`, every point off `C` is covered by one of the fifteen pair-secants of `A`.
Consequently

```text
q^2 + q + 1 - 3(q+1) <= 15(q+1),
q^2 - 2q - 2 <= 15(q+1).
```

The inequality fails at `q=18`, so `q<=17`. Orders two and three admit no six-arc, leaving the
complete residual prime-power list

```text
q = 4,5,7,8,9,11,13,16,17.
```

This is the theorem-level cutoff; the census is not extrapolated beyond a search range.

## Exact quotient and certificate

The checker normalizes every ordered projective frame to the standard frame, quotients first by
`PGL_3(q)` and then by Frobenius, and verifies both projective and semilinear orbit partitions.
The complete quotient ledger is:

| `q` | projective six-arc classes | semilinear six-arc classes | qualifying projective classes | qualifying semilinear classes |
|---:|---:|---:|---:|---:|
| 4 | 1 | 1 | 0 | 0 |
| 5 | 1 | 1 | 0 | 0 |
| 7 | 3 | 3 | 1 | 1 |
| 8 | 5 | 3 | 2 | 2 |
| 9 | 7 | 6 | 6 | 5 |
| 11 | 15 | 15 | 1 | 1 |
| 13 | 26 | 26 | 0 | 0 |
| 16 | 61 | 22 | 0 | 0 |
| 17 | 74 | 74 | 0 | 0 |

For every class the checker computes `U(A)`, solves the linear evaluation kernels in degrees one,
two, and three, and keeps exactly the nonzero cubic kernels. It independently recomputes the locus
by minimum-support syndrome search, verifies the frame orbit-stabilizer identity, classifies every
minimum-degree quadratic by its rational line components and point count, and explicitly partitions
each semilinear orbit into projective subclasses. The four non-GRS nonsingular-conic representatives
are required to equal the tracked C398 certificate exactly.

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-23-c401-cubic-contained-six-arcs.py --check
sha256sum -c notes/2026-07-23-c401-cubic-contained-six-arcs.sha256
```

The checker uses only the Python standard library and imports C398's tracked finite-field and
six-arc quotient implementation. Its trusted boundary is Python integer arithmetic, the explicit
polynomial-basis field models, frame normalization, and exact Gaussian elimination. It does not
formalize the field bound or coordinate census in Lean.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| C401 checker `.py` | 20,601 | `995a884f7bfc2df890c95c62b605bc273353bb72a4d59b51dc3a1ae7ce5ca9f6` |
| C401 certificate `.json` | 29,417 | `dc0b6989dabc43daa8f45d10f50136a29540ba5bc56c359bbb9de1bb8a4866b5` |
| C398 input checker `.py` | 17,444 | `e01fc095bb51dd561d5b71c91d0f775b24ec1d97c8909d7879f3bd7fa499dcfc` |
| C398 input certificate `.json` | 8,713 | `e68bd03d88afd2c6c05a76fe9ef9b4254cb614c3b2f9f4c252c60222289e6f68` |

## Literature and promotion boundary

The raw small-field arc classes are classical territory. Martin's general incidence equations
already give the old small-order completeness boundary for six-arcs. Hameed records seven
projective six-arc classes in `PG(2,9)`, six incomplete, and treats separately the two classes
whose source arc lies on a nonsingular conic. Kaplan--Kimport--Lawrence--Peilen--Weinreich explain
that raw counts of six-arcs are polynomial and classical. C398's audit separately pre-empts the
full-conic `q=11` row and delimits its four non-GRS nonsingular-conic synthesis.

No consulted source stated the present all-field implication

```text
degree-at-most-three containment of U(A)
    => q<=17
    => degree-at-most-two containment
```

or the nine-row semilinear uncovered-locus table. The direct search was bounded, however, and the
raw constituent classifications are prior art. C401 is therefore an exact portable synthesis and
a useful negative result — there is no cubic flagship branch — not a promoted novelty claim.

### Read-depth ledger

- **G. E. Martin, _On Arcs in a Finite Projective Plane_, DOI
  `10.4153/CJM-1967-030-2`: `partial`.** Read from the complete Cambridge publisher PDF:
  introduction, elementary incidence setup, Theorem 21, and the small Desarguesian complete-arc
  list. The paper supplies general completeness/incidence context, not the low-degree locus
  classification.
- **Fouad Kadem Hameed, _Weighted (k,n)-arcs in the projective plane of order nine_ (1989):
  `partial`.** Read the Royal Holloway repository metadata and full-text-index extracts for
  §§3.5--3.8. The 29 MB PDF fetch timed out and was not cached. The extracts state the seven
  projective six-arc classes, six incomplete cases, and two source-conic cases; they do not expose
  the complete uncovered-locus tables needed here.
- **Nathan Kaplan, Susie Kimport, Rachel Lawrence, Luke Peilen, Max Weinreich,
  _Counting Arcs in Projective Planes via Glynn's Algorithm_, arXiv:1612.05246:
  `partial`.** Read the arXiv abstract, introduction, and Theorem 1.4 in HTML. The paper counts
  arcs rather than classifying secant-uncovered loci. It was not present in the shared PDF cache.
- **C398's external source set: `secondary only` here.** The source characterizations and read
  depths are inherited from `notes/2026-07-20-c398-conic-deep-hole-classification.md`, whose audit
  read Blokhuis--Seress--Wilbrink, Kaipa, and Van de Voorde at full text. C401 reruns the exact
  certificate interface rather than re-auditing those papers.

Load-bearing direct queries, run 2026-07-23, were:

```text
"six-arc" "cubic" PG(2,q) secants uncovered points
"6-arc" cubic curve finite projective plane
arc "uncovered points" cubic finite projective plane
"points not covered" secants arc PG(2,q) cubic
classification 6-arcs PG(2,9) projective equivalence
"6-arcs" "PG(2,9)"
"6-arc" "PG(2,9)"
complete arcs projective plane order 9 6-arc classification
"uncovered points" "two lines" arc PG(2,q)
"6-arc" "two lines" PG(2,9)
"seven projectively distinct 6-arcs"
"Bianchon points" arc PG(2,9)
```

MathSciNet and Google Scholar were not covered. No forward-citation exhaustion claim is made.

## ej + Tao closeout and mystery ledger

The closeout pass made three cheap upgrades. First, it replaced a prospective taxonomy of cubic
decomposition types by the stronger minimum-degree collapse, so reducible and nonreduced cubics
cannot masquerade as new arc classes. Second, it exposed and certified the `q=9` projective split:
five semilinear survivor classes are six projective classes, agreeing with the classical
seven-class census after the unique complete class is removed. Third, it factored the sole
non-GRS reducible quadratic and recorded its `4+4` component distribution.

- **Settled:** whether an irreducible or reducible cubic supplies a genuinely new family. It does
  not; every survivor has a line or quadratic container.
- **Settled:** whether Frobenius hides a `q=9` exception. It fuses exactly one survivor pair, and
  both projective subclasses carry the same unique nonsingular-conic profile.
- **Settled by the `ej` intrinsic upgrade:** the unique non-GRS `q=9` `4+4` rational-line-pair
  locus is selected by the `C4` stabilizer's short two-point orbit. Its vertices support the only
  tangents containing four uncovered points, and those tangents are the two quadratic factors.
  The `1^16,2^12,4^2` tangent histogram and the two Brianchon matchings make the extraction
  coordinate-free.

No genuine C401 mystery remains.

## Hand-back

- C398 retains its four non-GRS nonsingular-conic classes and its literature boundary.
- C401 closes the entire degree-at-most-three branch: ten projective classes, nine semilinear
  classes, all already of minimum degree at most two.
- The intended cubic flagship does not exist. C402 remains the next queued independent pilot.
