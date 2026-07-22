# C463 — A3 companion `Z/2` torsor and bit-carrier duality

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `GREEN — THE A3 ANTIPODAL MATCHING IS PRIME-INDEPENDENT, BUT ITS TWO COMPANION
ONE-FACTORIZATIONS FORM A FREE Z/2 GALOIS TORSOR; B3 HAS ONE FIXED COMPANION`

## Result

Under C444's frozen `P^1(F_5)` labels, the projective octahedral `S4` has matching-orbit census

```text
orbit size:       1  4  6
number of orbits: 1  2  1.
```

The unique fixed matching is the frozen antipodal matching

```text
M0 = {0,inf}{1,4}{2,3}.
```

Both size-four orbits, and no other orbit, complete `M0` to a one-factorization of `K_6`.  In the
canonical certificate ordering they are

```text
C0:
  {0,1}{2,4}{3,inf}   {0,2}{1,inf}{3,4}
  {0,3}{1,2}{4,inf}   {0,4}{1,3}{2,inf}

C1:
  {0,1}{2,inf}{3,4}   {0,2}{1,3}{4,inf}
  {0,3}{1,inf}{2,4}   {0,4}{1,2}{3,inf}.
```

The frozen Galois action `i -> -i` induces `(2 3)` on `P^1(F_5)`.  It fixes `M0` and exchanges
`C0 <-> C1`, with no fixed companion.  Hence the unordered companion family descends, while a
chosen companion does not: it is the asserted nontrivial `Z/2` companion torsor over `Z[i]`.

The two primes above 5 give the exact reduction table

| generic companion | `(2-i)`, `i -> 2` | `(2+i)`, `i -> 3` |
|:--|:--|:--|
| `C0` | `C0` | `C1` |
| `C1` | `C1` | `C0` |

Thus each named companion prefers exactly one prime relative to the canonical reduced companion
`C0`; conjugating the naming exchanges both preferred primes.  The intrinsic content is the free
swap, not an absolute sign on either companion.

## B3 control

For C444's `sqrt2 -> 3` projective `S4` on `P^1(F_7)`, exact enumeration gives

```text
orbit size:        1  3  4  6  12
number of orbits:  1  4  2  4   5.
```

The unique fixed matching is C444's antipodal matching
`{0,inf}{1,3}{2,6}{4,5}`.  Exactly one size-six orbit completes it to a one-factorization of
`K_8`.  The action `omega -> omega^2`, inducing `(1 2)(3 6)` in the frozen labels, fixes this
companion.  The B3 companion torsor is therefore trivial and descends.  This does not erase B3's
bit: C444 already places it in the two antipodal-matching reductions, which occupy opposite
`PSL_2(7)` sheets.

## Certified three-case table

| case | antipodal matching | companion family | certified bit carrier |
|:--|:--|:--|:--|
| H3 | golden-prime sheet reductions | four companions with free `Z/4` action | companion family at `Z/4` strength |
| B3 | two silver reductions in opposite `PSL_2(7)` sheets | one Galois-fixed companion | antipodal-matching sheet split; companion torsor trivial |
| A3 | prime-independent fused matching | two companions freely swapped by `i -> -i` | companion family at `Z/2` strength |

The H3 row is copied by hash reference from the C443 and C462 certificates; C463 does not
recompute it.  This is a three-case comparison, not a proposed law for other Coxeter groups or
primes.

## Closeout strengthening

The `i -> -i` vertex permutation is not in the projective `S4`.  Adjoining it produces a group of
order 48, exactly the full abstract stabilizer of `M0` in `S_6`; the projective `S4` has index two.
Thus the companion swap is not an accidental relabeling: it is precisely the missing index-two
symmetry of the antipodal matching.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
uv run python3 notes/2026-07-21-c463-a3-companion-torsor.py --check
uv run python3 notes/2026-07-21-c463-a3-companion-torsor-replay.py
(cd notes && sha256sum -c 2026-07-21-c463-a3-companion-torsor.sha256)
```

Intentional regeneration is
`uv run python3 notes/2026-07-21-c463-a3-companion-torsor.py`.  The primary checker reconstructs
the C444 projective groups from their exact matrix models, enumerates all perfect matchings and
matching orbits, tests every one-factorization edge-by-edge, and computes both Galois actions.
The independent replay imports no primary code: it uses explicit permutation generators and a
separate orbit enumerator, and independently checks the A3 order-48 stabilizer upgrade.  Inputs are
hash-pinned in the canonical JSON.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary checker | 13,247 | `04920162cdd861ecd2db81b3c03e86c88cfbf142d6152ea8c1c60a653a724e87` |
| independent replay | 4,772 | `d314535ac2f2bb00167672257555de7298f057bf6cea96c6202dde826d875de3` |
| canonical JSON | 10,686 | `238ca16b5795a6044421e5614a18bb122a272b42e129d581ea58137dd0a3b0fd` |

The trusted boundary is exact finite arithmetic and exhaustive enumeration in the frozen C444
labels, plus hash-referenced H3 facts from C443/C462.  There is no floating point, randomness,
literature claim, moment computation, secant product, or manuscript edit.

## Mystery ledger

- **Settled in the closeout pass:** why the A3 swap is structurally distinguished.  It completes
  the projective `S4` to the full order-48 stabilizer of the antipodal matching.
- **Open:** why the bit carrier migrates from the antipodal sheet in B3 to companion torsors of
  strengths `Z/2` and `Z/4` in A3 and H3.  The exact evidence is only this three-case table; no
  mechanism theorem spans the cases.  Phase-3 synthesis owns any comparative explanation, and
  this report supplies no evidence for extrapolation.

## Boundary

C463 certifies only the frozen H3/B3/A3 facts in the table.  It does not claim a general
companion-torsor law, recompute H3, revive C443's cut tensor clause, or infer a manuscript theorem.
