# C446 — frozen marker matchings are not secant pencils

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `SHARP NEGATIVE; ROW 36 CLOSES; X3 LOSES ITS GEOMETRIC LEG`

## Result

None of the frozen C406 marker matchings is concurrent:

| type | field | frozen target matchings | secants per matching | concurrent |
|:---|---:|---:|---:|---:|
| A3 | `F_5` | 5 | 3 | 0 |
| B3 | `F_7` | 14 | 4 | 0 |
| H3 | `F_11` | 22 | 6 | 0 |

For every one of the 41 matchings, the normalized secant-line coefficient matrix has rank three.
The canonical JSON records every matching, its `PSL` sheet, every secant line, and the
lexicographically first nonzero `3 x 3` minor as a direct nonconcurrency witness. Consequently
there are no associated intruder points, point orbits, point stabilizers, or two-sheet point
correspondence to identify. Speculation-register row 36 closes negative, and X3 loses the proposed
geometric leg from X1.

There is also a short orbit--stabilizer obstruction. A point through which all `(q+1)/2` matching
secants pass has stabilizer order `2(q+1)` in `PGL_2(q)`, namely `12,16,24` for `q=5,7,11`.
The frozen matching stabilizers have orders `24,24,60`. Equivariance would force each matching
stabilizer into its concurrency-point stabilizer, which is impossible by order. The rank
certificate checks the stronger pointwise statement directly and does not rely on this argument.

Terminology note: a point lying on `(q+1)/2` secants and no tangents is conventionally an
*interior* point of an odd conic. The program's parenthetical “exterior points at q=7 lie on 4
secants” uses the opposite label; the certificate avoids the ambiguity and calls these
`secant_pencil_points`.

## Exact computation

The primary checker consumes only the frozen C406 Gate-1 JSON. It reconstructs `PGL_2(q)` and
`PSL_2(q)` from normalized `2 x 2` matrices, regenerates the `5/14/22` target matching orbits from
the frozen base matching, forms every secant by a projective cross product in the frozen conic
coordinates, and row-reduces the resulting line matrix over the prime field.

The independent replay imports no primary code. It recursively enumerates all perfect matchings
of the `6/8/12` conic points, tests concurrency by intersecting the first two secants and checking
all remaining lines, and independently rebuilds the target `PGL` orbit. It finds exactly
`10/21/55` concurrent matchings among all `15/105/10,395` perfect matchings, as required by the
`q(q-1)/2` secant-pencil points, and finds empty intersection with every frozen target orbit.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c446-marker-matching-concurrency.py --check
python3 notes/2026-07-21-c446-marker-matching-concurrency-replay.py
sha256sum -c notes/2026-07-21-c446-marker-matching-concurrency.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-21-c446-marker-matching-concurrency.py --write
```

The trusted boundary is exact Python integer arithmetic modulo `5,7,11`, projective
normalization, exhaustive finite enumeration, and the frozen C406 coordinates and base matchings.
The bundle proves only the stated finite A3/B3/H3 nonconcurrency. It does not classify other
matching orbits beyond the replay's concurrency count, alter the abstract selector obstruction,
or say anything about cap-lane positions or solvers.

All load-bearing byte counts and SHA-256 hashes are recorded in the adjacent checksum manifest.
