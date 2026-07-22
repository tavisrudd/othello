# C469 — Witt/Golay equivariance bridge

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `SHARP SEPARATION — THE WITT RESTRICTION IS G/A5 + G/D12, NOT G/A5 + G/A4; THE FULL-SUPPORT WORDS ARE 1 + G/A5, NOT G/(C11:C5)`

## Result

The frozen C452 translation order supports an exact `PSL_2(11)` action on C464's eleven ternary
Golay coordinates.  The projective matrices

```text
T = [[1,1],[0,1]],     S = [[0,-1],[1,0]]
```

generate all 660 elements, and their induced permutations preserve the code, its selected
incidence rows, the residual edge formula, and every projective weight family checked below.
The generator action tables are literal arrays in the certificate.

The proposed three-row dictionary has these exact dispositions:

| object | proposed | exact disposition |
|:--|:--|:--|
| selected weight-five supports | `G/A5` (11) | **proved** |
| residual weight-five supports / `K_11` edges | `G/A4` (55), identified with C450 disjoint pairs | **dead**; the orbit is `G/D12` |
| full-support projective words | `G/(C11:C5)` (12) | **dead**; the action is `1 + G/A5` |

Thus the 66 Witt blocks restrict under the frozen `G=PSL_2(11)` as

```text
G/A5  disjoint-union  G/D12,
```

with sizes `11+55`.  This is a theorem about the frozen `PSL_2(11)` action only; it makes no
claim about the full code or design automorphism group and no `M_11` claim.

## The selected eleven blocks

For every one of the 660 group elements, the coordinate image of the support of incidence row
`i` is the support of the induced image row.  The eleven supports form one orbit.  The anchor

```text
row 0, support {3,4,5,7,10}
```

has stabilizer order 60 and element-order census

```text
1^1 2^15 3^20 5^24,
```

the exact `A5` census.  This proves the first dictionary row as `G/A5`, with the anchor and all
stabilizer member IDs recorded in the JSON.

## Sharp obstruction for the two 55-sets

C464's residual support attached to an edge `{i,j}` remains equivariant under all 660 elements:

```text
support(1-r_i-r_j) |-> support(1-r_{g i}-r_{g j}).
```

However, the stabilizer of an unordered edge has element-order census

```text
source residual edge:       1^1 2^7 3^2 6^2  = D12,
C450 disjoint relation pair: 1^1 2^3 3^8      = A4.
```

The abstract stabilizer types already rule out a `G`-equivariant bijection.  Exhaustively comparing
the source anchor stabilizer with all 55 target stabilizers finds zero matches.  Independently,
their orbit partitions on either frozen eleven-point sheet are respectively

```text
D12: 2+3+6,        A4: 1+4+6.
```

Conjugation by C450's nonsquare outer matrix
`Rz=[[1,10],[1,1]]` also gives zero target stabilizer matches, as it must because an automorphism
cannot change the abstract stabilizer type.  Therefore the equality `55=|G:A4|` was the false
step: this degree-11 action has a `D12` unordered-pair stabilizer, and the residual set is
`G/D12`.  Equal cardinalities with C450's `G/A4` set do not lift to an equivariant bridge.

## Full-support projective words

The twelve scalar pairs split into orbits of sizes `1+11`.  The all-one projective word is fixed
by all 660 group elements.  A nonconstant anchor has stabilizer order 60 with the `A5` order
census above, whereas a point in the natural `P^1(F_11)` action has stabilizer order 55 with
census

```text
1^1 5^44 11^10.
```

This decisively kills the proposed transitive `G/(C11:C5)` identification.

The replacement is intrinsic.  Every nonconstant full-support projective word uses the two
nonzero ternary symbols with multiplicities `5+6`; the positions of the minority symbol form one
of the eleven selected Witt blocks.  This gives an explicit `G`-equivariant bijection between the
moving eleven-word orbit and the selected `G/A5` block orbit.  The certificate records all eleven
word/block pairs and checks the formula over all 660 elements. More exactly, if `r_i` is incidence
row `i`, then the moving orbit is precisely

```text
{ [1+r_i] : i=0,...,10 }.
```

Projectivization turns the five entries equal to `2` (or, after rescaling, the five entries equal
to `1`) into the intrinsic minority-symbol block.

## Second-order extra juice: complete secant closure

The failed transitive twelve-point guess hides a stronger projective theorem.  Take the twelve
full-support points

```text
[1], [1+r_0], ..., [1+r_10]  in P(C_11).
```

Their `C(12,2)=66` secant lines split into the same `11+55` orbits as the Witt blocks.  Each line
has two further `F_3`-points, one of weight five and one of weight six:

- the eleven lines from `[1]` to `[1+r_i]` contain `[r_i]` and its weight-six complementary
  point, recovering the selected blocks;
- the 55 lines between `[1+r_i]` and `[1+r_j]` contain the residual point because
  `[1+r_i]+[1+r_j]=-[1-r_i-r_j]`, and their fourth points have the complementary supports.

The 66 weight-five points obtained this way exhaust all Witt blocks, and the 66 weight-six points
exhaust all their complements.  The certificate records every secant and both interior points;
the independent replay reconstructs the full census.  Thus the task's three finite layers are not
merely adjacent orbits: the `1+11` full-support configuration has the Witt design as its complete
secant shadow.

## Third-order extra juice: unpunctured Hadamard model

Appending the parity coordinate

```text
c_12 = -sum(c_1,...,c_11)  in F_3
```

turns the punctured code into an exact self-dual `[12,6,6]_3` code with weight distribution

```text
1 + 264 z^6 + 440 z^9 + 24 z^12.
```

The twelve punctured full-support points extend to all twelve projective weight-12 points.  Choose
the representatives `[1],[1+r_i]` above, extend them, and replace ternary entries `1,2` by signs
`+1,-1`.  The resulting `12x12` sign matrix `H` satisfies the exact integer identity

```text
H H^T = 12 I_12.
```

Thus the full-support configuration is a Hadamard row system.  On every one of its 66 secants,
both interior points now have weight six; the resulting 132 projective points exhaust all 264
minimum words up to scalar.  Puncturing the parity coordinate splits each pair back into the
weight-five Witt point and its weight-six complement from the preceding section.

This is the conceptual unpunctured explanation Tao's question exposes.  The computation proves
the self-dual extension, enumerator, Hadamard identity, and minimum-word secant exhaustion.  It
does **not** claim or classify an `M_11`, `M_12`, or full monomial automorphism group; that larger
symmetry question remains outside C469's boundary.

## Cheap consistency controls

No general automorphism census was run.  The requested neighboring weights give only these exact
support-orbit controls:

| weight | projective words | supports | support orbit sizes |
|---:|---:|---:|:--|
| 5 | 66 | 66 | `11+55` |
| 6 | 66 | 66 | `11+55` |
| 8 | 165 | 165 | `55+110` |
| 9 | 55 | 55 | `55` |

Both generators preserve each family.  These counts are consistency checks, not additional
classification claims.

## Certificate and reproducibility

The atomic bundle consists of this report, the primary generator
`notes/2026-07-21-c469-witt-golay-equivariance.py`, the independent replay
`notes/2026-07-21-c469-witt-golay-equivariance-replay.py`, the canonical certificate
`notes/2026-07-21-c469-witt-golay-equivariance.json`, and the checksum manifest
`notes/2026-07-21-c469-witt-golay-equivariance.sha256`.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c469-witt-golay-equivariance.py --check
python3 notes/2026-07-21-c469-witt-golay-equivariance-replay.py
sha256sum -c notes/2026-07-21-c469-witt-golay-equivariance.sha256
```

Intentional regeneration is the primary command without `--check`.  It hash-pins the C450, C452,
and C464 JSON inputs; enumerates all projective matrices and selects the 660 square-determinant
elements; reconstructs both matching-sheet actions; exhaustively checks all object actions and
stabilizers; and writes stable, timestamp-free JSON.

The independent replay imports neither the primary generator nor its helpers.  It constructs the
group instead by breadth-first word enumeration in `S,T`, independently rebuilds the sheet and
code actions, re-enumerates all 729 codewords, and rechecks the three dispositions, order spectra,
sheet-orbit obstructions, intrinsic minority-symbol map, neighboring-weight controls, input pins,
and recorded generator tables.

The trusted boundary is exact integer and prime-field arithmetic plus the hash-pinned C450/C452/
C464 certificates.  The computation certifies the frozen `PSL_2(11)` action and no larger
automorphism group.

## Mystery ledger

- **Settled — the two 55s.** They are different homogeneous spaces: residual edges are `G/D12`,
  while C450 disjoint relation pairs are `G/A4`.  Element orders and sheet orbit partitions give
  independent decisive obstructions.
- **Settled — the twelve full-support words.** The all-one word supplies the fixed point, and the
  exact formula `[1+r_i]` identifies each of the other eleven words with a selected Witt block.
  Hence the exact action is `1+G/A5`.
- **Settled by second-order extra juice — why all 66 Witt blocks appear.** The 66 secants of the
  twelve full-support points contain exactly the 66 weight-five Witt points and their 66
  weight-six complements; fixed-to-moving and moving-to-moving lines give the selected/residual
  split.  This is an exact projective mechanism, not a cardinality coincidence.
- **Settled by the Tao/unpuncturing pass — the source of the twelve-point geometry.** Parity
  extension gives a self-dual `[12,6,6]_3` code; the twelve weight-12 projective points are the rows
  of an exact order-12 Hadamard matrix, and their secants exhaust all projective minimum words.
  A possible larger Mathieu-group interpretation is explicitly unproved and outside this task.
- **No genuine C469 mystery remains.** Every proposed orbit has a proved or dead disposition, the
  failed equal-cardinality bridges have exact mechanisms, and all task-owned claims pass an
  independent replay.  Broader `M_11` symmetry remains outside scope rather than an unresolved
  premise of this result.
