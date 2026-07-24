# C548 — exact four-copy contraction rank-drop divisor

**Lane:** `crowns`

**Date:** 2026-07-23

**Status:** complete; positive two-divisor theorem with exact `S6/A4` multiplicities

## Result

Let

```text
A = -4t(t-1)^2,
B = (t^2-t+1)(t^2-3t+1),
z = (B/A)^2,
G = t^4-4t^3+7t^2-4t+1.
```

Work on C396's admitted non-GRS pencil

```text
2t(t-1)BG != 0.
```

For each of the 720 party relabellings of C397's fixed four-copy contraction, quotient the
universal three-dimensional diagonal kernel by deleting the first bra-message block.  The resulting
matching matrix has size `24 x 21`.  Exact polynomial row reduction and maximal-minor witnesses
prove that its rank is generically 21 and that the reduced party-orbit rank-drop scheme is exactly

```text
(B^2-2A^2)(9B^2-4A^2)=0,
```

equivalently

```text
(z-2)(9z-4)=0.
```

There is no extra horizontal or vertical component on the admitted pencil.  Every active term has
rank exactly 20 along the generic point of its component.  The detector has no claim beyond these
two divisors: it does not recover `z`, classify the pencil, or strengthen C397's already-closed
q=13 arbitrary-LU theorem.

The six rational irreducible component factors used by the checker are

```text
B^2-2A^2
  = (t^4-10t^3+19t^2-10t+1)
    (t^4+2t^3-5t^2+2t+1),

3B-2A
  = (t^2+t+1)(3t^2-7t+3),

3B+2A
  = (t^2-5t+1)(3t^2-5t+3).
```

The same 96 party terms drop on both `z=2` quartics.  The same 192 terms drop on the two
quadratics of either signed `z=4/9` sheet; the two signed-sheet supports are disjoint.  Thus every
geometric point above `z=2` has histogram

```text
rank 20^96, rank 21^624,
```

and every geometric point above `z=4/9` has

```text
rank 20^192, rank 21^528.
```

## Exact `S6/A4` mechanism

The multiplicities are single double-coset sizes, not unexplained divisibility by the generic
projective `A4`.

For `z=2`, the 96-term support is

```text
L2 g2 R2,
L2 ~= S4 x C2,   |L2|=48,
R2 ~= D8 x C2,   |R2|=16,
L2 intersect g2 R2 g2^-1 ~= C2^3,   order 8,
```

so

```text
|L2 g2 R2| = 48*16/8 = 96.
```

For each signed `z=4/9` sheet, the 192-term support is

```text
L4 g+ R4   or   L4 g- R4,
L4 ~= S4,        |L4|=24,
R4 ~= S4 x C2,   |R4|=48,
L4 intersect g± R4 g±^-1 ~= S3,     order 6,
```

and hence

```text
|L4 g± R4| = 24*48/6 = 192.
```

The two double cosets are disjoint.  The common projective `A4` is the derived subgroup of `L4`
and sits in `L2`; its left action on `S6` is free.  Quotienting therefore gives exactly

```text
96/12 = 8
```

classes over `z=2` and

```text
192/12 = 16
```

classes on either signed `z=4/9` sheet.  This supplies the missing classical explanation of
C397's sixteen quotient classes.

The permutation representations give a concrete six-point model.  `L4 ~= S4` is the tetrahedral
edge action on six edges, its derived `A4` is the rotational tetrahedral group, and
`L2 ~= R4 ~= S4 x C2` is the full octahedral action on six vertices.  The
`R2 ~= D8 x C2` subgroup preserves an opposite vertex pair and its equatorial square.  The seams
are respectively the coordinate-reflection `C2^3` and the triangular `S3`.  Thus the mechanism is
literal tetrahedral/octahedral six-point incidence at the party-permutation level, not just an
abstract order calculation.  No larger contraction census or tensor-network construction is
involved.

## Exceptional characteristics

The complete exceptional-prime support follows from the derivative, boundary, and cross-resultants:

```text
{2,3,5,7,11,13,41}.
```

- Characteristic 2 is excluded by the odd-field pencil and by the polynomial code basis.
- In characteristic 3, `B^2-2A^2=G^2`, while both signed `4/9` factors are supported on
  `t(t-1)=0`; the admitted detector locus is empty.
- In characteristic 5, `9B^2-4A^2` is a unit times `G^2`; the `z=4/9` divisor is entirely the
  excluded GRS boundary.  The `z=2` divisor remains.
- In characteristic 7,

  ```text
  9B^2-4A^2 = 2(B^2-2A^2),
  ```

  so the two `z` divisors merge and the scheme becomes the doubled pullback divisor.  The
  `96`-term support and the relevant `192`-term signed support are disjoint, giving
  `rank 20^288, rank 21^432` at every admitted point.  The checker independently verifies the
  three rational admitted parameters `t=2,4,6`; the component factorization gives the same
  `96+192` law over the quadratic points.
- Characteristics 11, 13, and 41 are pullback-ramification exceptions at `t=-1`: respectively
  the `3B+2A`, `3B-2A`, and `B^2-2A^2` divisor has a double root.  The matrix rank does not drop
  further: the exact histograms remain `20^192,21^528`, `20^192,21^528`, and
  `20^96,21^624`.

Thus characteristic 7 is the only merger of the two `z` divisors.  Characteristics 11, 13, and
41 affect only the ramification of the map from the `t`-pencil to the reduced `z`-line; 3 and 5
remove detector components by the already-excluded boundary.

The four nonboundary exceptional primes have a one-line arithmetic explanation.  At `t=-1`,
`A=16` and `B=15`, so

```text
B^2-2A^2    = 225-512  = -287 = -7*41,
9B^2-4A^2   = 2025-1024 = 1001 = 7*11*13.
```

The common factor 7 is the divisor merger; the residual factors 41, 11, and 13 are exactly the
three ramification-only primes.

## Evidence and replay

From the repository root:

```bash
python3 notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.py --check
sha256sum -c notes/2026-07-23-c548-c397-contraction-rank-drop-divisor.sha256
```

The dependency-free checker:

- constructs the polynomial `24 x 21` quotient matrix directly from C397's frozen contraction;
- performs exact quotient-field row reduction on all six rational component factors for all 720
  party relabellings;
- produces integral maximal-minor witnesses whose only content prime is 2 and whose admitted
  zero sets lie inside the displayed two-divisor union, excluding every extra component;
- reconstructs each rank-drop support as one exact `S6` double coset and records the left, right,
  and seam element-order histograms;
- computes the complete derivative/boundary/cross-resultant prime support; and
- independently replays every admitted parameter over
  `q=7,11,13,17,19,23,29,31` by direct finite-field Gaussian elimination.

The canonical JSON records the component masks in lexicographic `S6` order, all quotient-rank
histograms, compact maximal-minor witness statistics, double-coset certificates, exceptional
resultants, and finite-prime replay counts.  The trusted boundary is exact integer/rational
polynomial arithmetic and Gaussian elimination.  The exact quotient calculation and direct
finite-field replay are independent evaluation paths; no floating point, random choice, or
external computer-algebra package is used.

The adjacent checksum manifest records byte counts and SHA-256 hashes for the report, checker, and
certificate.

## `ej`/Tao closeout and mystery ledger

The closeout sharpens the raw `96/192` observation in three ways.  First, the 192 terms are one
double coset on each of two signed sheets, explaining why a fixed finite-field fibre always sees
192 even though the signed supports are disjoint.  Second, the generic `A4` quotient gives both
the previously noticed sixteen classes and an unanticipated eight-class `z=2` companion.
Third, separating reduced `z`-geometry from pullback ramification exposes 11, 13, and 41 without
mistaking them for new detector components.  The `ej` pass further identifies the double-coset
groups as tetrahedral/octahedral six-point actions and compresses all four nonboundary exceptional
primes into the two displayed evaluations at `t=-1`.

| feature | disposition |
|:---|:---|
| Exact rank-drop support | **Settled:** precisely `(z-2)(9z-4)=0` on the admitted pencil. |
| Why the multiplicities are `96/192` | **Settled:** single `S6` double cosets of sizes `48*16/8` and `24*48/6`. |
| Whether the double-coset groups have six-point geometry | **Settled by `ej`:** tetrahedral edges, octahedral vertices, and the axis/equator stabilizer realize all three groups. |
| Why C397 saw sixteen `A4` quotient classes | **Settled:** the signed `4/9` double coset is a free union of sixteen `A4` cosets. |
| Whether `z=2` has a companion quotient | **Settled by `ej`:** it is a free union of eight `A4` cosets. |
| Characteristic-7 count `288` | **Settled:** the divisors merge while their `96`- and `192`-term supports remain disjoint. |
| Other exceptional characteristics | **Settled:** 3 and 5 are excluded-boundary coincidences; `-7*41` and `7*11*13` at `t=-1` explain the merger/ramification primes. |
| Whether the scalar recovers the whole pencil | **Settled negatively by scope:** it is exactly a two-divisor detector and is constant-rank elsewhere. |
| Whether polyhedral incidence alone forces the constants `2` and `4/9` | **Still open but outside the stop rule:** the Fitting calculation proves the constants and the double cosets explain their multiplicities, but no coordinate-free Gale derivation of the two constants is known.  No successor is allocated. |

No task-owned gate remains; the last row is the sole residual conceptual mystery.

## Vibe check

Excellent: the preflight factorization survives exactly, the two unexplained counts become small
double-coset formulas with a precise `A4` quotient, and the arithmetic exceptions separate cleanly
into boundary, merger, and ramification phenomena.
