# C410 — same-scalar-tower pointed collision by balanced composition

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `BOUNDED NEGATIVE; EVERY SPANNING q=7 SIX-POINT EXTERNAL-LINE CLOSURE HAS POINTED-CONSTANT UNIVERSAL-DEPTH FIBRES`

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

A user-authorized follow-up closes the omitted frame-free types rather than enlarging
the field or complement size.  Every spanning six-point set contains a noncollinear
triple, so normalize that triple to the coordinate basis and test the
`binom(57-3,3)=24,804` extensions.  Only 60 normalized representations contain no
projective frame.  They form one `U`-fibre with one `P`-profile:

```text
24,804 normalized noncollinear-triple extensions
    60 frame-free representations
     1 frame-free U-fibre
     0 frame-free pointed-collision fibres.
```

Together, the frame and frame-free gates cover every spanning six-point complement in
`PG(2,7)` under external-line closure.

Thus every realizable difference `Delta=e_B-e_B'` in the frozen signed
frame-extension module satisfying `U(B)=U(B')` also satisfies `P(B)=P(B')`.  This is a
bounded negative, not a general implication `ker(U) subset ker(P)`.

The revised stop rule now applies: larger fields, seven/eight-point trades, symbolic
moduli, random canonical-code search, and unrestricted Prouhet--Tarry--Escott
parametrization do not remain hidden inside C410.  The two materially larger viable
directions are allocated separately as C418 and C419.

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
first test takes every geometrically realizable six-point frame extension and partitions
their pair differences coefficientwise by the full `U` ledger.  The follow-up uses a
fixed noncollinear triple and retains exactly the frame-free residue, closing the full
spanning six-point class.  This avoids
the invalid move of cancelling different constant depth shifts or assuming separable
background factorization.  External-line closure, nonnegative multiplicities, and
essentiality are automatic here: six points are fewer than `q+1`, and the fixed frame
spans the plane.

No universal-depth fibre separates coordinate repair, puncturing, or syndrome
multiplicity.  Consequently neither the ideal degree-two ledger `{2,2,5}` versus
`{1,4,4}` nor a more general arithmetic parametrization is invoked after the frozen
geometric gate fails.

## Scope and nonclaims

This computation is complete for every spanning six-point subset of `PG(2,7)` under
external-line closure, modulo the two normalizations just described.  It does not cover
`q>7`, complements of size at least seven, arrangements outside external-line closure,
nonseparable multi-switch compositions outside this family, or higher-rank
arrangements.  In
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
the 1,378 normalized frame extensions and the 60 frame-free representations among all
24,804 normalized noncollinear-triple extensions, projective incidence, and the
elementary transitivity of `PGL_3(7)` on ordered projective frames and noncollinear
triples.  The JSON certificate stores all 15 frame-fibre summaries and digests of every
frame and frame-free universal/pointed candidate record.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker `.py` | 14,075 | `27aad0a2efa94073d2f345436a9c604888d4e640256cbfdd9c88a45a14a5a276` |
| independent replay `.py` | 9,263 | `d9be17a3c83b3345e6e4cbb6e8d1de30e979f6c6871b80996526d4d047b955e4` |
| certificate `.json` | 8,704 | `c15f65c9d5bc16dc1140a70013c48f2a86749373ee44ae224420a23bbc913e40` |

## Larger attacks and routing

The attacks that genuinely change scale or method are specified in
`notes/2026-07-20-c418-c419-c410-successors.md`.

- **C418** owns the `F_7` seven/eight-point Pasch, four-endpoint, common-core, and
  incidence-2-switch kernel.  It must solve `ker(U)\ker(P)` first and separately certify
  projective realizability; no raw configuration census is authorized.
- **C419** owns fixed-incidence realization moduli.  It holds every original and adjoint
  incidence in `U` fixed and tests whether an exact determinant/elimination stratum
  admits different pointed secant or puncture conditions.

Code-first canonical augmentation, SAT/ILP filtering, and the degree-two
Prouhet--Tarry--Escott ledger are documented there as subordinate tools, not separately
allocated open-ended searches.

## Hand-back

C410 closes negatively after the bounded frame-free follow-up.  The exact C408 defect
is reproduced, all 15 frame-containing universal-depth fibres are pointed-constant, and
the remaining 60 frame-free representations form one pointed-constant fibre.  Thus all
spanning q=7 six-point external-line closures are exhausted.  Larger balanced trades and
fixed-incidence moduli are routed to C418 and C419 rather than silently expanding C410.
