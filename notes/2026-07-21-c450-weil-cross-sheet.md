# C450 / T3 — cross-sheet modules and the Weil-roof verdict

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `SHARP NEGATIVE FOR THE 5+6 / 3+4 INCIDENCE-MODULE IDENTIFICATION; GREEN OUTER EXCHANGE AND Q(SQRT(-11)) WEIL PAIR; C449 BASELINE PASSES BUT DOES NOT DISCRIMINATE`

## Result

Let the two frozen `PSL_2(q)` matching sheets have size `q`, for `q=7,11`.  Between the sheets
there are exactly two relations: matchings share one edge, or they are disjoint.  Their incidence
matrices have the exact symmetric-design profiles

| `q` | relation | shape | row sum | `AA^T` | rank over `Q` |
|---:|:---|:---:|---:|:---|---:|
| 7 | shared edge | `7x7` | 4 | `2I+2J` | 7 |
| 7 | disjoint | `7x7` | 3 | `2I+J` | 7 |
| 11 | shared edge | `11x11` | 6 | `3I+3J` | 11 |
| 11 | disjoint | `11x11` | 5 | `3I+2J` | 11 |

Thus both complementary maps are invertible in characteristic zero.  Neither has a
`(q-1)/2`-dimensional kernel or a `(q+1)/2`-dimensional image.  The row, column, and image modules
are the sheet permutation modules

```text
q=7:   1 + 6,
q=11:  1 + 10_b.
```

The proposed identifications `3+4` and `5+6` therefore fail.  This is a module-multiplicity
obstruction, not a rank coincidence or a naming choice.

## Mandatory C449 torus baseline

The certificate first reproduces C449's restriction to the split Coxeter torus
`C_e`, `e=(q-1)/2`, directly from its action on `P^1(F_q)`:

```text
q=7:   fixed-point character [8,2,2]
q=11:  fixed-point character [12,2,2,2,2]

P^1 permutation module restricted to C_e
    = 2*trivial + 2*regular(C_e).
```

Hence the invariant dimension is four, the trivial character has multiplicity four, and every
nontrivial torus character has multiplicity two, exactly as C449 requires.

This baseline is necessary but not sufficient.  Gérardin's two Weil degrees restrict as

```text
(q-1)/2 component:  regular(C_e),
(q+1)/2 component:  2*trivial + every nontrivial character once.
```

After adjoining one trivial line, their sum also has multiplicities `4,2,...,2`.  Thus the
candidate `1 + Weil_- + Weil_+` passes the C449 restriction test at both primes.  The full
`PSL_2/SL_2` character and central-action computation is what rejects it: the actual sheet is
`1+6` or `1+10_b`, while the upper Weil constituent is genuine for `SL_2` and has central value
`-(q+1)/2`, so it cannot occur in a module factoring through `PSL_2`.

## Exact character data and relation-support modules

The computed `PSL_2(11)` class orders and sizes are

```text
orders: 1, 11, 11, 2, 3, 6, 5, 5
sizes:  1, 60, 60, 55, 110, 110, 132, 132.
```

The irreducible degrees are

```text
1, 5_a, 5_b, 10_a, 10_b, 11, 12_a, 12_b.
```

The two degree-five rows have values on the two order-11 classes

```text
(-1 + sqrt(-11))/2,  (-1 - sqrt(-11))/2
```

in opposite order.  Their period sums satisfy `x^2+x+3=0`, so their character field is exactly
`Q(sqrt(-11))`.  The computed outer `PGL_2(11)` automorphism swaps the two order-11 classes and
the two degree-five characters.  Inflated to `SL_2(11)`, these degree-five characters have central
value `+5`; the two degree-six Weil candidates have central value `-6`.  This matches the
Gérardin split into dimensions `(q-1)/2` and `(q+1)/2` and fixes which half descends.

For completeness, the permutation modules on the *supports* of the two cross relations decompose
as follows, in the displayed irreducible order:

```text
q=11, shared-edge 66-set, stabilizer D10:
  [1,1,1,0,2,1,1,1]

q=11, disjoint 55-set, stabilizer A4:
  [1,0,0,1,2,0,1,1]
```

So the shared-edge support module does contain both `5_a` and `5_b`, once each.  That is a genuine
Weil-character occurrence, but it is a 66-dimensional relation-support statement; it does not
turn the invertible 11-dimensional incidence map into `5+6`.

The `q=7` control is parallel.  In degree order `1,3_a,3_b,6,7,8`, the shared-edge `28`-set
(`S3` stabilizer) has multiplicities `[1,0,0,2,1,1]`, the disjoint `21`-set (`D8` stabilizer) has
`[1,0,0,2,0,1]`, and the seven-point sheet is `1+6`.  The `3_a,3_b` Weil pair is absent from both
relation supports, sharpening the negative control.

The canonical JSON records every character row, class size/order, field degree/conductor,
subgroup-induced multiplicity, split-torus restriction, and the central idempotents in the exact
class-sum form

```text
e_chi = (chi(1)/|G|) sum_C conjugate(chi(C)) ClassSum(C).
```

## Outer exchange and the two X-chain candidates

C445's transporter reduces to

```text
Rz: x |-> (x+10)/(x+1),       matrix [[1,10],[1,1]],       det=2 mod 11.
```

Since `2` is nonsquare modulo 11, direct action on the frozen matchings verifies that `Rz` swaps
the two sheets, preserves both cross relations, and swaps the endpoints of every relation edge.
It induces the same nontrivial `PGL_2/PSL_2` quotient bit as C449's diagonal outer element.

The comparison has one important qualification: `Rz` does **not** literally swap C449's two
Legendre blocks in the fixed `0,infinity` torus frame.  It moves those poles and conjugates the
split torus.  Thus it realizes the same outer quotient character, but it is not C449's chosen
torus-normalizing representative.

The X-chain candidates now have exact dispositions:

- **D1 passes:** C460's overlap-5 graph is exactly the 66-edge shared-one-matching-edge graph,
  after canonical row-order alignment.
- **B passes at the quotient level:** the prime/sheet bit and `Rz` determinant bit are the same
  nontrivial `PGL_2/PSL_2` class.  The frozen-frame torus representative is not literally `Rz`.

## C460 secondary control

C460's `22x55` cloud-incidence matrix has ordinary left module

```text
2*(1+10_b),       kernel = one trivial sheet-sign line,
image = 1+2*10_b, rank 21.
```

Its ranks in characteristics two and three are `11` and `20`.  These do not match the modular
rank-drop profiles of either `11x11` cross relation: their nullities are respectively `1,6` for
the shared-edge matrix and `0,5` for the disjoint matrix.  Moreover `2` and `3` divide
`|PSL_2(11)|`, so ordinary semisimple character subtraction cannot explain the extra kernels.
No common Weil-constituent explanation is promoted.

## Weil reference and naming boundary

The naming uses Paul Gérardin, *Three Weil representations associated to finite fields*,
*Bulletin of the AMS* 82 (1976), 268--270, DOI `10.1090/S0002-9904-1976-14017-7`.  The full
three-page paper was read from the disk cache; SHA-256
`010d33d76214ba58404847f4bfba39f3a469b80ceb68a41e012b65e42f5c59e3`.  Its load-bearing statement
is the split of the `q`-dimensional symplectic Weil representation into the two simple degrees
`(q+1)/2` and `(q-1)/2`.  The finite computation, not the citation, supplies the character values,
fields, central actions, outer permutation, and module multiplicities used here.

## Reproducibility

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c450-weil-cross-sheet.py --check
python3 notes/2026-07-21-c450-weil-cross-sheet-replay.py
sha256sum -c notes/2026-07-21-c450-weil-cross-sheet.sha256
```

Intentional regeneration is the primary command without `--check`.  It reconstructs both frozen
matching-sheet actions and relation matrices, verifies stabilizers and design Grams, computes the
C449 restrictions, compares `Rz` and the C460 graph, and asks GAP 4.15 (through `nixpkgs#gap`) for
character tables and subgroup-induced characters of the explicitly constructed finite groups.

The independent replay imports no primary C450 code.  It rebuilds both relation matrices from the
canonical sheets, repeats all rational and modular ranks and Grams, independently checks `Rz`,
verifies input hashes and all decomposition dimensions, and separately reconstructs the GAP
degree, subgroup, and outer-action data.

Trusted boundary: exact integer/rational/prime-field arithmetic, GAP's exact finite-group character
algorithms, the hash-pinned frozen inputs, and Gérardin's stated Weil-degree theorem.  The bundle
does not claim a new character table, a modular decomposition theorem in characteristics two or
three, or a manuscript edit.  The sharp negative affects only the proposed Weil roof; C406/C445/
C460 sheet geometry remains intact.
