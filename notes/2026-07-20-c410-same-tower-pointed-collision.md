# C410 — same-scalar-tower pointed collision by balanced composition

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `BOUNDED NEGATIVE; q=7 SIX-POINT FRAME-EXTENSION UNIVERSAL-DEPTH FIBRES ARE POINTED-CONSTANT`

## Result

The first structurally natural C410 gate contains no same-tower pointed collision.  Fix
`q=7`, six complement points, and a projective frame.  Every six-point configuration
containing a frame is projectively equivalent to one of the

```text
binom(57-4,2)=1,378
```

extensions of the standard frame

```text
(1,0,0),(0,1,0),(0,0,1),(1,1,1).
```

For each extension, close the complement by every external line.  Let `U` be the pair
consisting of the original arrangement characteristic polynomial and the complete
universal weighted-adjoint projective depth-count polynomial, with every depth count
stored as its coefficients in `Q^2,Q,1`.  Let `P` be the sorted coordinate
repair/availability profile together with the sorted excluded-syndrome secant-
multiplicity profile.  The one-coordinate puncture deck is already determined by the
repair counts.

The exact census gives

```text
1,378 normalized extensions
   15 U-fibres
    0 U-fibres containing more than one P-profile.
```

Thus every realizable difference `Delta=e_B-e_B'` in the frozen signed
frame-extension module satisfying `U(B)=U(B')` also satisfies `P(B)=P(B')`.  This is a
bounded negative, not a general implication `ker(U) subset ker(P)`.

The task's stop rule applies: the search does not move to a larger field, more complement
points, frame-free configurations, random canonical-code search, or unrestricted
Prouhet--Tarry--Escott parametrization.

## Why this is the promised balanced gate

The checker first reconstructs the C408 control.  Its two realizable six-point switches
have equal original characteristic polynomial and unequal pointed profiles, but their
universal-depth defect is exactly

```text
(Q-7)(-x+2x^2-2x^4+x^5)
  =(Q-7)x(x-1)^3(x+1).
```

Equivalently, the nonzero depth coefficients, in the basis `Q^2,Q,1`, are

```text
depth 1: (0,-1,  7)
depth 2: (0, 2,-14)
depth 4: (0,-2, 14)
depth 5: (0, 1, -7).
```

So one C408 switch is not in `ker(U)` even though it vanishes at the base field.  The
frozen test then takes every geometrically realizable six-point frame extension and
partitions their pair differences coefficientwise by the full `U` ledger.  This avoids
the invalid move of cancelling different constant depth shifts or assuming separable
background factorization.  External-line closure, nonnegative multiplicities, and
essentiality are automatic here: six points are fewer than `q+1`, and the fixed frame
spans the plane.

No universal-depth fibre separates coordinate repair, puncturing, or syndrome
multiplicity.  Consequently neither the ideal degree-two ledger `{2,2,5}` versus
`{1,4,4}` nor a more general arithmetic parametrization is invoked after the frozen
geometric gate fails.

## Scope and nonclaims

This computation is complete only for six-point subsets of `PG(2,7)` that contain a
projective frame, modulo the normalization just described.  It does not cover spanning
six-point sets with no frame, `q>7`, complements of size at least seven, nonseparable
multi-switch compositions outside this family, or higher-rank arrangements.  In
particular it proves neither nonexistence of a same-scalar-tower pointed collision nor
that universal weighted-adjoint data determine pointed profiles in general.

The result makes no novelty or priority claim.  Classical incidence/design trades,
Prouhet--Tarry--Escott solutions, saturating sets, covering codes, and punctured-code
interpretations remain prior-art interfaces rather than claimed contributions.  Since
the bounded gate is negative, no focused forward-citation audit was needed for a
paper-facing positive claim.

## Evidence and replay

Run from `/home/tavis/src/othello`:

```bash
python3 -B notes/2026-07-20-c410-same-tower-pointed-collision.py --check
python3 -B notes/2026-07-20-c410-same-tower-pointed-collision-replay.py
sha256sum -c notes/2026-07-20-c410-same-tower-pointed-collision.sha256
```

Intentional regeneration is:

```bash
python3 -B notes/2026-07-20-c410-same-tower-pointed-collision.py --write
```

The primary checker uses canonical projective vectors, bit-mask incidence, pairwise
intersection blocks, and coefficientwise universal-depth polynomials.  The replay
imports no primary code: it finds singular points by scanning all projective points,
derives the universal polynomial by independently separating exclusive line points from
multi-line intersections, and recomputes every candidate and fibre digest.

The trusted boundary is exact prime-field arithmetic in `F_7`, complete enumeration of
the 1,378 normalized frame extensions, projective incidence, and the elementary fact
that `PGL_3(7)` is transitive on ordered projective frames.  The JSON certificate stores
all 15 fibre summaries and a digest of every universal/pointed candidate record.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker `.py` | 11,451 | `05edfb6e3ab52691f1758f2b5e33f4e55888c0b8b8f5a41e729975f4a0289a38` |
| independent replay `.py` | 7,119 | `54b66256e502ae6eec0c54eb6a5cef72427b3b9270256b03a3bd78ebdf2d87e7` |
| certificate `.json` | 7,959 | `1131e88816a2d3ce20c1f63383e41b21d7d8f53fd3c81ec0304f51fb3d51ecc5` |

## Hand-back

C410 closes negatively at its first frozen structural bound.  The exact C408 defect is
reproduced, but all 15 universal-depth fibres in the normalized q=7 six-point
frame-extension family are pointed-constant.  Per the task contract, this result does
not authorize a larger census or another field/size gate.
