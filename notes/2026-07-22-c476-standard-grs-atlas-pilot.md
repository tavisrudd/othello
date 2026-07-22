# C476: bounded standard-GRS determinant-atlas pilot

**Lane**: `reed-solomon`

**Date:** 2026-07-22

**Status:** complete at the mandated first collision; all support classes through `q=9` separate,
and the first canonical `q=11` support has one complete rank-one collision fibre resolved exactly
by C475's radical marker.

## Result

For each `q` in the fixed order `5,7,8,9,11`, the checker canonically enumerated the
`PGammaL_2(q)` orbits of six-subsets of `P1(F_q)`.  Within each support it exhaustively enumerated
all projective syndromes, retained exactly those for which all fifteen C475 bilinear evaluations
are nonzero, computed the full semilinear support stabilizer, and compared exact syndrome orbits
with raw four-cycle-atlas fibres.

The stop rule fires at

```text
q=11,
S={0,1,2,3,4,infinity},
first raw-atlas collision
  {(1,5,3), (1,6,3)}.                                   (1)
```

Both representatives in (1) have rank one and the all-one thirty-coordinate atlas.  Their
radicals lie in the two distinct stabilizer orbits

```text
{5,10},                  size 2,
{6,7,8,9},               size 4.                         (2)
```

The full semilinear stabilizer of `S` has order four and is a Klein four group: on all twelve
points of `P1(F_11)` its cycle-type profile is

```text
1^12:                 1 element,
1^2 2^5:              2 elements,
2^6:                  1 element.                         (3)
```

Thus (1) is not a numerical coincidence.  It is exactly C475's structural contraction of the
rank-one diagonal, and the radical marker separates the two projective-semilinear syndrome
orbits.  Every rank-two orbit processed before the stop has a distinct atlas.

The full action gives one further free recognition statement.  The three nonidentity involutions
have rational fixed-point sets

```text
empty,              {5,10},              {2,infinity}.  (4)
```

Hence the two-point complement orbit is intrinsically the fixed-point set of the unique stabilizer
involution whose rational fixed points both lie outside the support.  The other four complement
points form the remaining orbit.  C477 need not rediscover this split from raw coordinates.

The searched prefix contains six support classes, 38 deep syndrome directions, thirteen exact
syndrome orbits, twelve raw-atlas fibres, and one collision fibre.  The three later `q=11`
support classes were not analyzed, exactly as required by the stop rule.

## 1. Exact bounded census

Projective-line points are encoded by the field integers `0,...,q-1`, with infinity encoded by
`q`.  Each support representative contains the normalized frame `{0,1,infinity}` and is the
lexicographically least support in that frame-normalized orbit.

| `q` | six-subsets | `|PGammaL_2(q)|` | support classes | processed support | `|Stab(S)|` | deep directions | syndrome orbits | raw atlas fibres | collision? |
|---:|---:|---:|---:|:---|---:|---:|---:|---:|:---:|
| 5 | 1 | 120 | 1 | `{0,1,2,3,4,infinity}` | 120 | 0 | 0 | 0 | no |
| 7 | 28 | 336 | 1 | `{0,1,2,3,4,infinity}` | 12 | 2 | 1 | 1 | no |
| 8 | 84 | 1512 | 1 | `{0,1,2,3,4,infinity}` | 18 | 4 | 2 | 2 | no |
| 9 | 210 | 1440 | 2 | `{0,1,2,3,4,infinity}` | 8 | 8 | 2 | 2 | no |
| 9 | 210 | 1440 | 2 | `{0,1,2,3,6,infinity}` | 48 | 4 | 1 | 1 | no |
| 11 | 924 | 1320 | 4 | `{0,1,2,3,4,infinity}` | 4 | 20 | 7 | 6 | **yes** |

The four canonical `q=11` support classes are

```text
{0,1,2,3,4,infinity},
{0,1,2,3,5,infinity},
{0,1,2,3,6,infinity},
{0,1,2,3,7,infinity}.
```

Only the first was processed.  It was processed completely: all twenty deep directions, all
seven syndrome orbits, all six atlas fibres, and the entire stabilizer action are in the
certificate.

The orbit strata by `(rank, Delta-class)` are:

| `q`, support row | rank-one orbits | rank-two square-class orbits | rank-two nonsquare-class orbits |
|:---|---:|---:|---:|
| 5 | 0 | 0 | 0 |
| 7 | 1 | 0 | 0 |
| 8 | 1 | 1 nonzero class | — |
| 9, first | 1 | 1 | 0 |
| 9, second | 1 | 0 | 0 |
| 11, first | 2 | 1 | 4 |

Here `Delta=u_0*u_2-u_1^2`.  In characteristic two every nonzero element is a square, so the
certificate uses the label `nonzero-square` rather than pretending that a nontrivial square-class
split remains.  No raw-atlas collision crosses a rank or `Delta`-class boundary.

## 2. Exhaustiveness of support and stabilizer enumeration

The primary checker constructs every normalized matrix in `PGL_2(q)` and every Frobenius power.
There are exactly

```text
[F_q:F_p] * q * (q^2-1)                                 (5)
```

resulting point permutations, as asserted against the generated group.  Every six-subset is sent
through this complete group; its canonical representative is the least image containing the
standard ordered-frame set `{0,1,infinity}`.  This proves the support-class counts in the table.

For a fixed canonical support, retaining exactly the group elements that preserve it gives the
full semilinear stabilizer.  The primary checker applies the corresponding `Sym^2` matrix directly
to every syndrome in `PG(2,q)`.  It enumerates all `q^2+q+1` projective directions and retains `u`
precisely when

```text
beta_u(v_i,v_j) != 0             for all 15 support pairs.  (6)
```

By C475 and the plane-arc/MDS dictionary, (6) is exactly the deepest-syndrome condition.

The independent replay never enumerates normalized `PGL_2` matrices.  It normalizes every ordered
triple of support points to `(0,1,infinity)` using brackets.  A semilinear stabilizer element is
reconstructed uniquely from a Frobenius power and the images of one fixed ordered support frame.
It then partitions rank-two syndromes by the proved C475 atlas equality criterion and rank-one
syndromes by the induced radical-point action.  Agreement with the primary direct `Sym^2` orbits
therefore checks the group construction, support canonicalization, syndrome action, atlas
transformation, and radical descent by a structurally different route.

## 3. The complete first collision fibre

For the support in (1), the twenty deep directions split into

```text
rank one:       6 directions in orbits 2+4,
rank two:      14 directions in five orbits 4+2+4+2+2.  (7)
```

The two rank-one projective representatives are

```text
u_5=(1,5,3),        Delta=0,       rad(beta_u5)=5,
u_6=(1,6,3),        Delta=0,       rad(beta_u6)=6.        (8)
```

Since `5^2=6^2=3 mod 11`, these are exactly the doubled-point syndromes `(1,r,r^2)` attached to
the two complement orbits in (2).  Their bilinear edge labels factor as vertex products, so every
balanced four-cycle ratio is one.  C475 proves that no higher balanced edge monomial can separate
them.  The radical marker does separate them and gives two augmented-atlas fibres, one for each
exact syndrome orbit.

The five rank-two syndrome orbits have five distinct atlas records.  Four have nonsquare `Delta`
and one has square `Delta`; their orbit sizes sum to fourteen as in (7).  Therefore the only
collision on the complete first support is the diagonal contraction (8).

## 4. Pair-dictionary and characteristic-two checks

The C475 extra-juice review `notes/2026-07-22-reed-solomon-c475-ej-review.md` identifies a syndrome
with a binary quadratic/unordered pair on `P1`, with secant incidence equal to harmonicity.  Three
of its free predictions are visible exactly in the certificate.

1. A six-point support has `q-5` off-support conic points, all deep and rank one.  The certificate
   finds respectively `0,2,3,4,4,6` rank-one directions in the six processed rows.
2. The discriminant square class is invariant.  Adding it to the schema stratifies every computed
   orbit and no collision crosses its boundary.
3. At `q=8`, the nucleus `u=(0,1,0)` is deep, fixed by the full order-18 support stabilizer, and is
   the unique rank-two orbit.  Its atlas is the bracket/cross-ratio atlas of the support alone.  The
   other three deep directions are the off-support conic points in one rank-one orbit.

These are exact checks of the pair dictionary inside the bounded C476 domain, not a literature or
novelty claim about binary-form invariant theory.

## 5. Certificate schema

The JSON certificate records, for every field reached before the stop:

- the field convention, subset count, semilinear group order, complete canonical support list, and
  processed prefix;
- for every processed support, every stabilizer permutation of `P1`, its cycle profile, the full
  complement-orbit partition, and exact deep-syndrome/orbit counts;
- every syndrome-orbit representative, orbit size, rank, `Delta` class, canonical thirty-entry
  atlas, and the radical plus its orbit representative on rank one;
- every raw atlas fibre and every collision fibre; and
- the exact first-collision stop coordinate.

The augmented key `(raw atlas, radical orbit on rank one)` has exactly as many fibres as syndrome
orbits on every processed support.  This is checked rather than inferred from the output table.

## 6. Evidence and replay

The atomic evidence bundle is

```text
notes/2026-07-22-c476-standard-grs-atlas-pilot.md
notes/2026-07-22-c476-standard-grs-atlas-pilot.py
notes/2026-07-22-c476-standard-grs-atlas-pilot-replay.py
notes/2026-07-22-c476-standard-grs-atlas-pilot.json
notes/2026-07-22-c476-standard-grs-atlas-pilot.sha256
```

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c476-standard-grs-atlas-pilot.py --check
python3 notes/2026-07-22-c476-standard-grs-atlas-pilot-replay.py
sha256sum -c notes/2026-07-22-c476-standard-grs-atlas-pilot.sha256
```

The implementation uses Python 3.13 standard-library exact integer/table arithmetic and the frozen
C398 polynomial-basis field model.  The certificate records the C398 script's SHA-256 and byte
count as a load-bearing input.  Serialization is sorted, timestamp-free JSON; `--check` regenerates
it in a temporary directory and compares exact bytes without changing the worktree.

Trusted boundary: the C398 finite-field tables; exhaustive normalized-matrix enumeration in the
primary checker; exhaustive ordered-frame normalization in the replay; C475's proved determinant,
atlas, and radical criteria; and Python integer/JSON correctness.  The independent replay imports
no C476 primary code.

## 7. Scope boundary

The exact negative statement is only:

> No raw-atlas collision occurs on any six-point support class for `q=5,7,8,9`.

The exact positive statement is the complete first support fibre at `q=11` described in (1)--(8).
Nothing here classifies the three later `q=11` support classes, any larger field, another support
size, arbitrary non-GRS parents, or affine received words.  The result does not support a novelty
or priority claim for the pair dictionary, binary-form invariants, or Reed--Solomon deep holes.

The collision activates C477.  Its input is already reduced to the order-four stabilizer action
on the two complement orbits (2); classical binary-sextic/quadratic covariants are candidate
language only if the radical description fails to give the desired intrinsic theorem.

## Extra-juice closeout and mystery ledger

- **Settled — whether the first collision is a new rank-two resonance.**  It is not.  Every
  rank-two orbit before the stop separates; the first collision is exactly C475's rank-one
  contraction.
- **Settled — whether the radical correction is sufficient in the first fibre.**  Yes.  The two
  radicals lie in the exact complement orbits of sizes two and four, so the augmented atlas
  recovers both semilinear syndrome orbits.
- **Settled — the characteristic-two prediction.**  The q=8 nucleus is the unique fixed rank-two
  deep hole and has the support-only bracket atlas predicted by the pair dictionary.
- **Settled — whether discriminant class adds another collision discriminator here.**  It is a
  free and useful stratum label, but the first collision lies entirely at `Delta=0`; it neither
  splits nor obscures that fibre.
- **Settled cheaply — intrinsic recognition inside the computed action.**  The two-point orbit is
  the rational fixed set of the unique stabilizer involution whose fixed points avoid the support;
  the other nontrivial elements have fixed sets `empty` and `{2,infinity}`.
- **Open for C477 — coordinate-free collision theorem.**  C477 owns deriving that involution and
  its external fixed pair directly from the unlabelled support sextic, proving the complete fibre
  theorem without coordinates, and stating the radical discriminator's sharp minimality.
- **Open by the stop rule — later q=11 supports.**  Their representatives are certified, but no
  syndrome or atlas claim is made for them.  They may be resumed only if a later allocated task
  explicitly changes the present first-collision boundary.
- **No other C476 mystery remains.**  The searched prefix, first fibre, stabilizer action, and
  augmented recovery are exact and independently replayed.

## Vibe check

Excellent: the pilot reaches a collision only at q=11, and the collision is maximally interpretable
rather than pathological.  C475's radical marker resolves it exactly, while the q=8 nucleus and
discriminant strata confirm that the pair dictionary is already organizing the finite data.
