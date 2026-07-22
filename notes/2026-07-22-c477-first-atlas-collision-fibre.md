# C477: intrinsic theorem for the first determinant-atlas collision fibre

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** complete.  The frozen q=11 fibre is a branch-versus-ordinary fibre of the intrinsic
Klein quotient.  Quadratic evaluation rank is constant; the number of legal second extensions is
the first prescribed control that separates; and nontrivial radical stabilizer is the sharp
cardinality-minimal discriminator.

## Result

Let `C` be the Veronese conic in `PG(2,11)`, parametrized only for calculation by
`v(t)=(1,t,t^2)` and `v(infinity)=(0,0,1)`, and let

```text
S={0,1,2,3,4,infinity} subset P1(F_11).
```

Write `G=Stab_PGL2(11)(S)`.  The complete first-fibre theorem is:

1. `G` is a Klein four group.  Its orbits on `S` have sizes `4+2`, and its orbits on
   `P1(F_11)-S` are

   ```text
   R={5,10},                    O={6,7,8,9}.               (1)
   ```

2. The three nonidentity involutions have geometric fixed pairs respectively inside `S`, outside
   `S`, and over `F_121` but not `F_11`.  Their rational fixed loci are

   ```text
   {2,infinity},                {5,10},                    empty.       (2)
   ```

   Consequently `R` is intrinsically the unique rational fixed pair of an element of `G` that is
   disjoint from `S`.  It is the external branch fibre of `P1 -> P1/G`; `O` is ordinary.

3. The complete raw rank-one C475 atlas fibre consists of all six radicals in the complement.
   All thirty four-cycle coordinates are one for every radical, so all fifteen pairwise atlas
   equalities hold.  Exact syndrome orbits are nevertheless the two sets in (1), represented by
   `(1,5,3)` and `(1,6,3)`.

4. Define the intrinsic ramification bit

   ```text
   epsilon(u)=1  iff  Stab_G(rad(beta_u)) is nontrivial.                 (3)
   ```

   It is `1` on `R` and `0` on `O`.  Thus (3) separates the two syndrome orbits.  Any invariant
   separating a two-orbit fibre needs at least two values, and (3) has exactly two; it is therefore
   cardinality-minimal.  Within the balanced edge-monomial invariant class, separation is
   impossible because C475 proves that every such invariant factors through the contracted torus
   quotient.  The radical orbit is the minimal lossless C475 refinement, and (3) is its one-bit
   specialization on this fibre.

This theorem depends only on the unlabelled conic support and its automorphism action.  The
displayed parametrization gives an exact verification, not additional structure in the definition.

## The prescribed discriminators, in order

For a radical `r`, let `A_r=S union {r}` on the conic.  Its legal continuation locus `L_r` is the
set of projective points `x` for which `A_r union {x}` remains an arc.  Join two vertices of `L_r`
in the continuation graph when they can be adjoined simultaneously; its complement is the
extension-conflict graph.

| discriminator | `r=5` (branch orbit) | `r=6` (ordinary orbit) | verdict |
|:---|---:|---:|:---|
| quadratic evaluation rank of `A_r` | 5 | 5 | does not separate |
| quadratic evaluation rank of `L_r` | 6 | 6 | does not separate |
| `|L_r|` | 11 | 7 | **first prescribed separator** |
| conflict edges | 40 | 11 | separates |
| continuation edges | 15 | 10 | separates |
| continuation degree multiset | `0,2^5,4^5` | `0^2,4^5` | separates |
| continuation graph | `K5 disjoint-union C5 disjoint-union K1` | `K5 disjoint-union 2 K1` | separates |

Thus evaluation rank loses the orbit distinction.  The extension-conflict stage already succeeds:
the scalar continuation count `|L_r|` separates `11` from `7`, before graph isomorphism data is
needed.  It is intrinsic because it counts extensions defined solely by three-column independence
of the unlabelled extended arc.  The continuation graphs provide a stronger control: the common
`K5` is the five still-omitted conic points, while the off-conic continuations induce `C5 union K1`
in the branch case and `2 K1` in the ordinary case.  Thus the graphs are nonisomorphic by exact
component structure, not merely by their vertex counts.

The ramification bit remains the smaller final answer: it has the least possible two-value
codomain and explains why the fibre splits, while the extension counts certify that the same split
has genuine downstream MDS-extension content.

An additional extra-juice check identifies how the branch involution acts on that content.  The
`K5` component is exactly the five omitted points of the original conic, the `C5` is entirely
off-conic, and the isolated vertex is off-conic.  The unique nonidentity element fixing the branch
radical acts with cycle type `1+2+2` on both five-vertex components and fixes the isolated vertex.
Thus the off-conic pentagon carries the same reflection profile as the conic `K5`; it is not an
unstructured five-cycle accidentally left by the exhaustion.  This still falls short of deriving
the pentagon adjacency from the Klein quotient alone.

## Proof of the intrinsic geometry

Choose any projective identification of `C` with `P1`.  Directly exhausting the `1320` normalized
matrices of `PGL2(11)` and retaining those that preserve `S` gives four elements.  In one
normalization their nonidentity maps are

```text
A(t)=4-t,
B(t)=(1-t)/(1+5t),
C(t)=(3-t)/(1+5t).                                      (4)
```

They are commuting involutions with `AB=C`, hence form `V4`.  Their complete point permutations
give (1) and (2).  The fixed-point quadratic of each Mobius map has respectively square, square,
and nonsquare discriminant for the three nonidentity elements, proving that the empty rational
fixed locus in (2) is a conjugate pair over `F_121`, not an omitted rational pair.

For a coordinate check of the quotient, the invariant function

```text
J(t)=t(4-t)(1-t)(3-t)/(1+5t)^2                         (5)
```

has degree four and is constant on the four `G`-orbits:

```text
J^-1(0)        ={0,1,3,4},
J^-1(infinity) ={2,infinity},
J^-1(3)        ={5,10},
J^-1(10)       ={6,7,8,9}.                              (6)
```

The first two fibres partition `S`; the last two partition its complement.  Equations (2) and (6)
make the external branch fibre independent of labels or the chosen quotient coordinate.

For a rank-one syndrome with radical `r`, C475 factors every nonzero edge evaluation as a product
of one factor at each endpoint.  Every balanced four-cycle ratio is therefore one.  Since the
deep rank-one directions are exactly the omitted conic points, the raw fibre is the entire
six-point complement.  Equivariance of the radical map identifies projective syndrome orbits with
the `G`-orbits (1), proving the fibre and minimality claims.

Finally, the finite checker enumerates all `133` projective points, tests every required `3 x 3`
minor for each `A_r`, and then tests simultaneous two-point extensions.  Exact row reduction of
the degree-two Veronese evaluations gives the two rank rows above.  A separate replay constructs
`G` from (4), enumerates projective points by normalized nonzero triples rather than affine charts,
uses a six-term determinant, and independently recovers all counts and degree multisets.

## Evidence and replay

The atomic evidence bundle is

```text
notes/2026-07-22-c477-first-atlas-collision-fibre.md
notes/2026-07-22-c477-first-atlas-collision-fibre.py
notes/2026-07-22-c477-first-atlas-collision-fibre-replay.py
notes/2026-07-22-c477-first-atlas-collision-fibre.json
notes/2026-07-22-c477-first-atlas-collision-fibre.sha256
```

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c477-first-atlas-collision-fibre.py --check
python3 notes/2026-07-22-c477-first-atlas-collision-fibre-replay.py
sha256sum -c notes/2026-07-22-c477-first-atlas-collision-fibre.sha256
```

The primary generator uses Python 3.13 standard-library exact arithmetic and freezes the C476 JSON
by SHA-256 and byte count, but reconstructs the stabilizer, fibre, atlas, ranks, and graphs without
importing C476 code.  The timestamp-free, sorted JSON certificate records all stabilizer
permutations and fixed geometry, all six atlas equalities, both exact syndrome orbits, and the two
control profiles.  `--check` regenerates into a temporary directory and compares exact bytes.

Trusted boundary: Python integer/JSON correctness; exhaustive normalized-matrix and projective-point
enumeration in the primary generator; the explicit Klein presentation and independent point and
determinant implementations in the replay; and C475's proved rank-one factorization and radical
equivariance.  The computation proves only this frozen q=11 support and fibre.  It says nothing
about the three later q=11 supports, other fields, rank-two collisions, or arbitrary GRS codes.

## Extra-juice closeout and mystery ledger

- **Settled — whether the prescribed controls merely restate ramification.**  No.  Evaluation rank
  is blind, but the branch orbit has eleven legal second extensions versus seven on the ordinary
  orbit.  The quotient split therefore controls nontrivial downstream extension geometry.
- **Settled cheaply in the closeout pass — the exact graph behind `11` versus `7`.**  The common
  conic component is `K5`; the off-conic pieces are `C5 union K1` and `2 K1`.  This is stronger and
  cleaner than the raw edge and degree counts.
- **Settled in the requested second extra-juice pass — how ramification acts on the pentagon.**
  The branch involution has cycle type `1+2+2` on both the conic `K5` and the off-conic `C5`, and
  fixes the off-conic isolated vertex.  The primary certificate now records component vertices,
  conic membership, and these cycle profiles; the independent replay reconstructs them directly.
- **Settled — the smallest first successful prescribed statistic.**  The full conflict graph is
  unnecessary: its vertex count already separates `11` from `7`.
- **Settled — sharp intrinsic minimality.**  Nontrivial radical stabilizer is a canonical one-bit
  invariant, and no separator of two nonempty orbits can use fewer than two values.
- **Settled — whether any higher balanced edge monomial can repair the collision.**  C475's full
  torus-quotient theorem rules this out; all six points have the same all-one atlas.
- **Open, but outside C477 — a direct quotient explanation for the off-conic `C5`.**  The second
  pass proves that the branch involution acts on it as a reflection, exactly matching its action on
  the conic `K5`, but no coordinate-free derivation of the five adjacency edges from Klein
  ramification is proved here.  Any promotion belongs to a newly allocated Reed--Solomon task; it
  is not needed for this fibre theorem.
- **No other C477 mystery remains.**  Stabilizer action, branch geometry, atlas equality,
  discriminator order, and independent finite replay are complete.

## Vibe check

Excellent: the apparently featureless all-one atlas fibre has a canonical one-bit explanation,
and the mandated controls reveal extra structure rather than a redundant label.  The first useful
extension statistic is just a vertex count, while the full finite claims replay independently.
