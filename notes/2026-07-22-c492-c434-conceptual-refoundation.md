# C492 — conceptual six-stratum proof and based Ω-level re-foundation

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `CERTIFIED — c=6 IS A TWO-SHEET DOUBLE-COSET THEOREM; THE SIX-LEVEL IS
BASED-GROUPOID FUNCTORIAL, NOT AN UNBASED G-QUOTIENT; B3/H3 EXHAUST THE C434
FINITE-GEOMETRY REALIZATION CLASS`

This report certifies the hand derivation left by C434. It makes no novelty or priority claim.

## The abstract two-sheet theorem

Let `Γ ◁ G` have index two, let `Ω = G/H` with `H ≤ Γ`, and base the action at
`x = H`. The two `Γ`-orbits are the sheets `Ω+` and `Ω-`. Assume the following
based two-sheet data.

1. As an `H`-set,
   `Ω+ = {x} ⊔ H/S0`, with `H/S0` transitive.
2. As an `H`-set,
   `Ω- = H/Sa ⊔ H/Sb`.
3. Both opposite-sheet actions are 2-transitive:
   `#Si\H/Si = 2` for `i ∈ {a,b}`.
4. The two opposite-sheet stabilizers are transverse:
   `H = Sa Sb`, equivalently `#Sa\H/Sb = #Sb\H/Sa = 1`.

Choose an outer involution `j` with `y = jx ∈ Ω-` and call `(x,y)` a golden
pair. Then

```text
K = Stab_G(x) ∩ Stab_G(y) = H_y
```

is conjugate in `H` to `Sa` or `Sb`. It has exactly three orbits on each
sheet and hence

```text
#K\Ω = 6.
```

### Proof

Suppose `K = Si` and write `Sj` for the other opposite-sheet stabilizer.
On the opposite sheet,

```text
#K\Ω- = #K\H/K + #K\H/Sj = 2 + 1 = 3.
```

The first term is two because the action on `H/K` is 2-transitive: a point
stabilizer has its fixed point and one orbit on the remaining points. The
second is one because `H = K Sj`. Thus `#K\Ω- = 3`.

Moreover `jKj⁻¹ = K`, since

```text
j(H ∩ jHj⁻¹)j⁻¹ = jHj⁻¹ ∩ H.
```

Consequently `j` pairs the three `K`-orbits on one sheet with the three on
the other, including their sizes. In particular,

```text
#K\Ω+ = #K\Ω- = 3
```

and, because `x` is the singleton own-sheet orbit,
`#K\H/S0 = 2` follows rather than being an extra axiom. Hence
`#K\Ω = 3 + 3 = 6`. This proves that the earlier
"largest-suborbit avoidance" is only sheet bookkeeping: `jx` lies on
`Ω-`, while the size-`q-1` orbit `H/S0` lies on `Ω+`.

## The four exact small-group tables

The C492 certificate constructs `S4` and `A5` as permutation groups and
checks every double-coset leg directly. Here `S0` is the stabilizer of the
nonbase own-sheet orbit.

| `H` | `S0` | golden `K` | own-sheet orbits | opposite-sheet orbits | legs `(own,same,cross)` |
|:--|:--|:--|:--|:--|:--|
| `S4` | edge `V4` | `D8` | `1,2,4` | `1,2,4` | `2,2,1` |
| `S4` | edge `V4` | `S3` | `1,3,3` | `1,3,3` | `2,2,1` |
| `A5` | `N(C3) ≅ S3` | `A4` | `1,4,6` | `1,4,6` | `2,2,1` |
| `A5` | `N(C3) ≅ S3` | `D10` | `1,5,5` | `1,5,5` | `2,2,1` |

Thus the two possible `K` types are precisely the point stabilizers in the
two opposite-sheet components. The certificate also checks the exact
factorizations

```text
A5 = A4 D10,          S4 = D8 S3.
```

In both factorizations the two factors meet in order `2`. Thus the
transverse leg has a common order-two gluing seam in both exceptional
models, not merely the same double-coset count. More precisely, each cross
cell is `K/C2`; its sizes are `6,5,4,3` in the four rows above.

This is the promised conceptual explanation of the class-independent
count: changing the outer-involution class changes which Borel is `K` and
changes orbit sizes, but it does not change the `2 + 1` double-coset count
on either relevant decomposition.

## Exact Bruhat statement, including the seam

The opposite sheet is the union of two small projective lines:

```text
A5:  P¹(F4) ⊔ P¹(F5),       5 + 6 = 11,
S4:  P¹(F2) ⊔ P¹(F3),       3 + 4 = 7.
```

The stabilizers are the corresponding Borels:

```text
A4 = B(PSL2(4)),       D10 = B(PSL2(5)),
S3 = B(PGL2(3)),       D8 = pullback of B(PGL2(2)).
```

For a golden `K`, the same-type leg is the rank-one Bruhat decomposition
`#B\H/B = 2`; the cross-type leg is one cell by Borel transversality, i.e.
the exact factorization above. Therefore the opposite sheet is exactly
"two Bruhat cells plus one transverse cell."

The own-sheet leg is deliberately not renamed Bruhat. It is the separate
rank-two incidence consequence `#K\H/S0 = 2`, transported from the
opposite sheet by `j`: in `S4`, `H/S0` is the
six-edge action, and in `A5`, `H/S0` is the ten-point action on Sylow
`3`-subgroups. Both candidate Borels have two orbits in the applicable
action, as the exact certificate independently verifies. Thus the minimal
abstract theorem needs only opposite-sheet 2-transitivity, cross-Borel
factorization, and the golden involution. This closes C434's unresolved
Bruhat seam without overstating it or adding an incidence axiom.

## Ω-level foundation and groupoid invariance

The canonical unbased information maps are

```text
Ω  →  {Γ-sheets}  →  {*},
2q →       2       →   1.
```

They are `G`-equivariant. The middle six-level is different: `K` is not
normal in `G`, so `Ω → K\Ω` is not a quotient of `G`-sets and must not be
presented as one.

Define a based golden-pair object to be `(G,Γ,Ω,x,j)` satisfying the
two-sheet axioms above, with `j` an outer involution and `y=jx`. A morphism
is a group isomorphism together with an equivariant bijection carrying
`(x,j)` to `(x',j')`. It carries

```text
K = Stab(x) ∩ Stab(jx)
```

to `K'` and hence induces a canonical bijection `K\Ω ≅ K'\Ω'`, compatible
with the sheet map and the involution pairing. Therefore

```text
(G,Γ,Ω,x,j) ↦ (K\Ω → Γ\Ω, j)
```

is a functor on the golden-pair groupoid. Changing the golden pair
conjugates the construction and gives an isomorphic six-set, but after
forgetting the pair there is in general no distinguished six-level. This
is the exact meaning of "portable" for the C434 middle stratum.

There is also an intrinsic sheet readout. The two sheets give the two
`Γ`-conjugacy classes of point stabilizers `H` and `tHt⁻¹`. They are
distinct exactly when `N_G(H)` contains no outer element: equality of the
classes is equivalent to `t⁻¹γ ∈ N_G(H)` for some `γ ∈ Γ`. Hence C434's
`N_G(H)=H` hypothesis makes the sheet bit intrinsic. At `q=5`, an outer
normalizer fuses the two classes; C493 owns that near-miss.

## Completeness of the finite-geometry realization class

For the C434 reflection-parent geometry, `|G/H|=2q` forces

```text
|H| = (q²-1)/2.
```

For `q≥5`, Dickson's subgroup classification excludes the Borel,
cyclic/dihedral, and proper subfield families by their orders. The
exceptional orders `12,24,60` leave only

```text
(q,H) = (5,A4), (7,S4), (11,A5).
```

The `q=5` case fails the self-normalizer hypothesis because, under
`PGL2(5) ≅ S5`, its `A4` is normal in an outer `S4`. The C434 certificate
checks the hypotheses and geometric realization at `q=7` and `q=11`.
Thus B3 and H3 are the complete realization class of the C434 theorem.
This does not claim that the abstract two-sheet axioms have no realizations
in other groups.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c492-c434-conceptual-refoundation.py --check
python3 notes/2026-07-22-c492-c434-conceptual-refoundation-replay.py
sha256sum -c notes/2026-07-22-c492-c434-conceptual-refoundation.sha256
```

Intentional regeneration:

```bash
python3 notes/2026-07-22-c492-c434-conceptual-refoundation.py --write
```

The primary checker constructs the four small-group double-coset tables,
all exact factorizations, and every orbit-size list. The independent replay
enumerates double cosets directly with a separate implementation. The
trusted boundary is Python's exact tuple/set arithmetic and the standard
permutation models of `S4` and `A5`. The ambient conic geometry,
outer-involution sweep, and normalizer hypotheses are consumed from C434,
not recomputed here.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary checker `.py` | 7,673 | `9c46212e0d1ab8ddce7dbbc681ed4a526383dd0a7fb274986734e4cd8061ea95` |
| independent replay `.py` | 3,004 | `333428d4a95d7cb8bf00eb61e74f2caf95a4ea77e42c855ed6498ed1daf6e64f` |
| canonical JSON | 4,430 | `ca0304a2b4e95d51c47da510831565e6e80eaaf66ba00708089eb7304c8017d9` |

Load-bearing C434 inputs:

| input | bytes | SHA-256 |
|:--|--:|:--|
| C434 report | 16,673 | `ec3a0997c883404710ba2d86e29f2cd0848312e2c20bdbbbad84c923a74b6243` |
| C434 canonical JSON | 12,477 | `6d0e0106aa04dfcfe694f74494eaf86743a3254c62c6c1e878000301ec2f0899` |

## Mystery ledger (ej closeout)

Settled:

- The own-sheet `#K\H/S0=2` leg is not a missing Bruhat
  interpretation or an independent axiom. It is forced by the golden
  involution from the opposite-sheet `2+1` count, and is independently
  certified in the six-edge and ten-Sylow-`3` models.
- Equality of the two per-sheet orbit-size lists is forced by
  `jKj⁻¹=K`; it is not an extra numerical coincidence.
- The middle six-set is canonical only over the golden-pair groupoid. The
  unbased `G`-object canonically retains only the `2q → 2 → 1` levels.
- The sheet bit itself is the two-class stabilizer torsor and is intrinsic
  exactly under the no-outer-normalizer condition.
- Both cross-type factorizations meet in `C2`; the two exceptional
  projective-line structures share one uniform order-two transverse seam.

No genuine C492 mystery remains. The `q=5` loss of the stabilizer-class
readout and the possible existence of a decorated geometric avatar are the
explicitly allocated C493 question, not residue of this proof.
