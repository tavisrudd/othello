# C171 — global nearest-conic gap and local move orbits

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. Exact claim boundary, both Git-indexed checkers, manuscript
synchronization, warning-free PDF build, and independent post-edit review passed.

## Correct global invariant

For a six-arc `A` in `PG(2,11)`, define the **nearest-conic discrepancy**

`delta(A) = min_Q |U(A) triangle Q(F_11)|`,

where `Q` ranges over all nonsingular conics. This is not a metric on arcs. It is a nonnegative
PGL-invariant function: `U(gA)=gU(A)`, and PGL permutes the nonsingular conics, so
`delta(gA)=delta(A)`.

The exact 15-class theorem is:

- the Clebsch class is the unique class with `delta=0`;
- every non-Clebsch six-arc satisfies `delta>=12`;
- the bound 12 is sharp and is attained by two projective classes;
- the class-counted delta histogram is
  `{0:1,12:2,13:1,14:3,15:1,16:4,17:2,18:1}`.

This repairs the old global gloss without speaking about “every other embedded arc.” Distinct
embedded representatives of the Clebsch class also have delta zero, as they must.

## Exact class table

The canonical first four points are always
`(0,0,1),(0,1,0),(1,0,0),(1,1,1)`. The table records the final pair, number of
frame-normalized representatives, stabilizer order, `|U|`, delta, number of nearest conics,
maximum intersection with a nearest conic, and one normalized coefficient witness.

| class | final pair | reps | stab | `|U|` | delta | nearest | intersection | conic witness |
|---|---|---:|---:|---:|---:|---:|---:|---|
| C01 | `(1,2,3),(1,3,2)` | 180 | 2 | 20 | 12 | 1 | 10 | `(1,1,1,7,0,7)` |
| C02 | `(1,2,3),(1,3,4)` | 60 | 6 | 18 | 14 | 6 | 8 | `(1,0,6,1,3,9)` |
| C03 | `(1,2,3),(1,3,6)` | 120 | 3 | 19 | 13 | 3 | 9 | `(1,2,1,1,2,6)` |
| C04 | `(1,2,3),(1,3,7)` | 120 | 3 | 19 | 17 | 60 | 7 | `(1,0,3,4,8,5)` |
| C05 | `(1,2,3),(1,3,9)` | 90 | 4 | 20 | 16 | 23 | 8 | `(1,0,2,1,7,2)` |
| C06 | `(1,2,3),(1,4,2)` | 180 | 2 | 20 | 16 | 8 | 8 | `(1,2,3,3,7,3)` |
| C07 | `(1,2,3),(1,4,8)` | 360 | 1 | 21 | 17 | 11 | 8 | `(1,0,3,6,9,4)` |
| C08 | `(1,2,3),(1,4,9)` | 90 | 4 | 20 | 16 | 16 | 8 | `(1,1,0,1,5,9)` |
| C09 | `(1,2,3),(1,5,6)` | 90 | 4 | 20 | 16 | 8 | 8 | `(1,0,8,1,1,3)` |
| C10 | `(1,2,3),(1,6,2)` | 60 | 6 | 19 | 15 | 3 | 8 | `(1,1,8,7,10,9)` |
| C11 | `(1,2,3),(1,6,7)` | 30 | 12 | 16 | 12 | 9 | 8 | `(1,0,2,1,7,2)` |
| C12 | `(1,2,3),(1,7,4)` | 72 | 5 | 22 | 18 | 25 | 8 | `(1,0,3,4,1,6)` |
| C13 | `(1,2,3),(1,8,9)` | 60 | 6 | 18 | 14 | 9 | 8 | `(1,0,2,1,7,2)` |
| C14 | `(1,2,3),(1,9,10)` | 30 | 12 | 18 | 14 | 9 | 8 | `(1,1,0,1,8,1)` |
| C15 | `(1,3,4),(1,4,5)` | 6 | 60 | 12 | 0 | 1 | 12 | `(1,6,7,1,7,9)` |

The 1548 frame-normalized representatives have exact class multiplicities
`[6,30,30,60,60,60,72,90,90,90,120,120,180,180,360]`, recovering stabilizer orders by
`360/m`. The checker enumerates all 177156 projective ternary quadrics, retains exactly
`11^2(11^3-1)=160930` nonsingular conics, asserts each has 12 points and each point lies on 14520
conics, and cross-checks every direct XOR distance against the intersection formula.

## Local orbit explanation

For the fixed embedded Clebsch pair `(A,C)`, retain the local quantity
`d_C(B)=|U(B) triangle C|` only on one-point neighbors. The 252 neighbors split into eight closed
orbits under `Stab(A)~=A5`:

| orbit | size | `d_C` | `|U intersect C|` | `|U|` |
|---:|---:|---:|---:|---:|
| 1 | 30 | 18 | 6 | 18 |
| 2 | 60 | 19 | 7 | 21 |
| 3 | 30 | 20 | 6 | 20 |
| 4 | 30 | 20 | 6 | 20 |
| 5 | 30 | 20 | 6 | 20 |
| 6 | 12 | 22 | 6 | 22 |
| 7 | 30 | 22 | 4 | 18 |
| 8 | 30 | 24 | 4 | 20 |

This recovers both aggregate histograms. The orbit rows are further distinguished by whether the
replacement lies on the conic, polarity incidence, and the secant/tangent/external type of the
deleted--replacement line. Those incidence refinements belong in the discovery log/report, not
necessarily the manuscript table.

The local values `d_C(B)` are not values of global `delta(B)`; only `delta(B)<=d_C(B)` is automatic.
The local lower bound 18 and global non-Clebsch lower bound 12 must remain separate statements.

## Durable artifacts

- `papers/clebsch-hexagon-code/check_global_conic_gap.py`, SHA-256
  `bb989b90c2dffe2d8bf71dce8c9b5aa879ddcf2d1abed724934dc24f4cbeea18`, runtime about 28 seconds.
- `papers/clebsch-hexagon-code/check_perturbation_gap.py`, SHA-256
  `0af4aa625539a8d317079276eacbc9364d1d0f653ea7c2362a4e59e22b7b6756`.

Both are standard-library-only, Git-indexed, finish with `all assertions passed`, and pass
`git diff --check`.

Validation:

- `check_global_conic_gap.py`: exact replay passed in about 28 seconds with roughly 60 MiB peak RSS.
- `check_perturbation_gap.py`: exact replay passed in under two seconds.
- Tectonic manuscript build: warning-free.
- Independent post-edit review: all class/form counts, the direct-XOR cross-check, unique displayed
  zero class, exact local orbits, both aggregate histograms, PGL invariance, and the separation of
  `delta` from `d_C` passed with no line-specific issue.
