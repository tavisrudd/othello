# C449 / T2 — split Coxeter-square torus

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `GREEN — THE COXETER SQUARE REDUCES TO A GENERATOR OF THE SPLIT MAXIMAL TORUS IN PSL_2(q) FOR A3/B3/H3`

## Result

For the frozen rank-three Coxeter systems, the orientation-preserving element relevant to T2 is
the Coxeter square `c^2`.  Its order is the middle exponent `e=h/2`.  At the already-certified
Coxeter conic field `q=h+1`, this becomes

```text
order(c^2) = h/2 = (q-1)/2,
```

exactly the order of a split maximal torus in `PSL_2(q)`.  Direct reduction in every frozen prime
frame gives:

| case | `h` | `q` | frozen affine action | order | determinant class |
|:--|--:|--:|:--|--:|:--|
| A3 | 4 | 5 | `x -> 4x` | 2 | square |
| B3, both silver primes | 6 | 7 | `x -> 2x` | 3 | square |
| H3, `zeta_5=3` | 10 | 11 | `x -> 9x` | 5 | square |
| H3, `zeta_5=9` | 10 | 11 | `x -> 4x` | 5 | square |

The checker constructs the complete diagonal square-determinant subgroup in each `PGL_2(q)` and
verifies that the powers of the displayed image equal it.  Thus “split-torus generator” is proved
by enumeration, not inferred from an order or a character table.

The displayed representatives use the frozen-group conjugate whose two eigenlines are the frozen
poles `0,infinity`.  Replacing a representative by its inverse reverses the cyclic orientation but
does not change its split torus or orbit partition.

## Exact `2+(q-1)` conic action

Every image fixes `0` and `infinity`.  The other `q-1` points split into the two square-coset
orbits of length `(q-1)/2`:

```text
A3: {0}, {infinity}, {1,4},             {2,3}
B3: {0}, {infinity}, {1,2,4},           {3,5,6}
H3: {0}, {infinity}, {1,3,4,5,9},       {2,6,7,8,10}
```

This is the requested `2+(q-1)` decomposition, refined to the literal orbit partition
`1+1+(q-1)/2+(q-1)/2`.  The moving orbits are exactly C441's frozen real/imaginary blocks for A3,
upper/lower cube triangles for B3, and alpha/beta pentagons for H3 (the block names exchange under
the frozen prime changes exactly as C441 records).

## Characteristic-zero provenance

No Coxeter conjugacy class is recalled from a table.  The primary checker rebuilds each frozen
vertex group and checks the following elements by their exact permutation of the char-0 vertices:

- A3: the square of multiplication by `i`, namely `x -> -x`, of order 2;
- B3: the body-diagonal rotation `x -> omega*x`, `omega^3=1`, of order 3;
- H3: C440's `S=diag(zeta_5,zeta_5^(-1))`, acting affinely by `x -> zeta_5^2*x`, of order 5.

Each lies in the reconstructed frozen rotation group and has two fixed vertices plus two cycles of
length `h/2`.  The checker also enumerates the centralizers and conjugacy-class sizes directly:
`8/3` for A3, `3/8` for B3, and `5/12` for H3 (centralizer/class), rather than importing a character
table.  Reduction through C441's exact vertex tables produces the finite matrices above.

## Meaning and boundary

T2 passes: the numerical law `q=h+1` has a uniform group mechanism.  The Coxeter square fills the
split maximal torus of `PSL_2(q)`, and the remaining two conic points are its eigenlines.  This
explains the common `2+(q-1)` action but does not prove that the torus mechanism causes the earlier
arrangement-complement equality; that equality remains C399's independently certified theorem.

The claim is rank-three and restricted to the frozen A3/B3/H3 models and their listed primes.  It
makes no novelty or priority claim, invokes no character-table identification, and changes none of
C399, C440, or C441.

## Reproducibility

From `/home/tavis/src/othello`:

```bash
uv run python3 notes/2026-07-21-c449-split-coxeter-torus.py --check
uv run python3 notes/2026-07-21-c449-split-coxeter-torus-replay.py
```

Intentional regeneration is the primary script without `--check`.  It reconstructs the frozen
char-0 groups, reduces the named Coxeter-square rotations, enumerates the diagonal `PSL_2` tori and
all `P^1(F_q)` orbits, and writes canonical timestamp-free JSON.  The independent replay does not
import the primary checker; it directly enumerates the five finite generator images, their powers,
determinant classes, and point orbits, then cross-checks representative moving blocks against the
frozen C441 certificate.  The primary `--check` also verifies all SHA-256 hashes and byte counts in
the adjacent manifest.

The trusted boundary is exact arithmetic in C440's frozen cyclotomic fields, exact prime-field
arithmetic, explicit permutation of the frozen vertex sets, the hash-pinned C399/C440/C441 inputs
listed in the JSON, and exhaustive finite enumeration.  There is no randomness, floating point,
scratch evidence, literature claim, or manuscript edit.
