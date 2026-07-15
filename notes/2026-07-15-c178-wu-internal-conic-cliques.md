# C178: Wu internal-orbit conics over F11

**Date:** 2026-07-15
**Lane:** `gem-mining`
**Status:** **REPORTED**; first cell complete and negative for the proposed six-point gem route

## Verdict

Junhua Wu's length-12 internal-point orbit conics do **not** contain a six-set whose
15 joins are all passant to the fixed conic in `PG(2,11)`.  The exact obstruction is
stronger: the two `PSL(2,11)`-orbits of Wu conics have passant-join clique numbers
respectively **4** and **3**.  Thus this construction cannot directly supply an
all-internal analogue of the Clebsch six-arc, and there is no six-set uncovered locus
to test in this cell.

This is a statement about Wu's specific length-12 `H_P`-orbit conics, not about every
conic contained in the 55 internal points and not about arbitrary all-internal
six-arcs.

## Exact reconstruction

The checker uses the fixed conic

```text
C : XZ = Y^2
```

and the symmetric-square action of `H = PSL(2,11)` on `PG(2,11)`.  It reconstructs
133 projective points, the 12 points of `C`, 55 internal points, 66 external points,
and all 660 elements of `H`.  The action is transitive on the internal points; each
internal-point stabilizer has order 12.  Its orbit-length distribution on the 55
internal points is

```text
1^1, 3^2, 6^4, 12^2.
```

Consequently the 55 point stabilizers produce 110 length-12 orbit occurrences.  All
110 are distinct.  Under `H` they split into two orbits of 55 conics.  A conic in
either orbit has setwise stabilizer of order 12, with element-order histogram
`{1:1, 2:7, 3:2, 6:2}`; it is the dihedral group of order 12 and acts regularly on
the conic.

For every one of the 110 point sets the checker independently verifies:

- exactly 12 distinct points, all internal to `C`;
- 66 distinct pair-lines, hence no three points collinear;
- quadratic evaluation rank five, a unique nonsingular containing conic, and equality
  with that conic's full `F_11` point set;
- among the 55 passant lines to `C`, 19 meet the Wu conic in zero points and 36 meet
  it in two points.  No passant line has any other intersection size.

This reproduces the `q=11` case of Wu's orbit-conic and even-intersection construction
before asking the new clique question.

## Passant-join graphs

For each Wu conic, put an edge between two of its points exactly when their join is
passant to `C`.  Direct enumeration of every clique on every one of the 110 conics
gives the following two graph types.

| Wu-conic orbit | vertices / degree / edges | clique counts `(1,2,3,4)` | clique number | maximum cliques | orbits under conic stabilizer |
|---|---:|---:|---:|---:|---:|
| 1 | `12 / 6 / 36` | `12, 36, 36, 12` | **4** | 12 | 2 (sizes 6, 6; stabilizer 2 each) |
| 2 | `12 / 6 / 36` | `12, 36, 28, 0` | **3** | 28 | 3 (sizes 12, 12, 4; stabilizers 1, 1, 3) |

The exact clique census is the obstruction: despite Wu's `0-or-2` intersection
property and despite both graphs being 6-regular Cayley graphs of the order-12
dihedral stabilizer, neither graph has even a five-clique.  In particular there are
zero six-cliques across all Wu conics, before or after deduplication.

## Interpretation for the paper program

The construction is genuinely adjacent to the gem lane: it uses the same fixed-conic
internal/external/passant geometry and the same symmetric-square `PSL(2,q)` action.
But its coding result is a binary incidence/null-space code on all internal points,
not the `F_11` length-six MDS/deep-hole code in the Clebsch paper.  It therefore poses
no novelty collision with the present coding theorem.

The useful positive residue is a small structural question for a follow-on: identify
the two order-12 dihedral Cayley graphs intrinsically and prove their clique numbers
4 and 3 without enumeration.  That would explain exactly why the even-intersection
orbit conics stop short of a six-point all-passant configuration.  It is not needed
for the current Clebsch manuscript.

## Reproduction and provenance

Checker: `notes/2026-07-15-c178-wu-internal-conic-cliques.py` (Python standard library
only; deterministic ordering; fail-closed assertions).

Command from `rust/`:

```bash
/usr/bin/time -f 'wall_seconds=%e max_rss_kb=%M' \
  python3 ../notes/2026-07-15-c178-wu-internal-conic-cliques.py
```

First measured run on 2026-07-15: 0.22 s wall time and 14,660 KiB maximum RSS. An independent
root-agent rerun passed in 0.24 s and 14,320 KiB maximum RSS. Final checker
SHA-256:

```text
5fa8f2d6a1dd848fbfddc090a0158721ea08b96085dc55c0b317fb4a7985eec2
```

The checker and report were added to git together with explicit pathspecs before C178 was closed.
`git ls-files --error-unmatch notes/2026-07-15-c178-wu-internal-conic-cliques.py` succeeds, so the
cited computation is not an untracked session artifact.
