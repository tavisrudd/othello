# C202: q=9 repair-extremizer classification

**Date:** 2026-07-15
**Lane:** `repaircodes`
**Status:** REPORTED

## Result

For the completed q=9 cubic--axis seed, the locality-optimal radius-three repair clutters have an
exact extremizer classification under the 72-element target stabilizer in the support action of
the monomial `PGL(2,9)` group:

| target | extremizer | optimum | labelled extremizers | orbits |
|---|---:|---:|---:|---:|
| cubic | disjoint repair family | 4 | 324 | 7 |
| cubic | blocker | 8 | 45 | 2 |
| axis | disjoint repair family | 7 | 3,780 | 65 |
| axis | blocker | 13 | 486 | 8 |

The full radius-four minimal port has the following exact census:

| target | extremizer | optimum | labelled extremizers | orbits |
|---|---:|---:|---:|---:|
| cubic | disjoint repair family | 4 | 94,078,188 | 1,306,963 |
| cubic | blocker | 8 | 9 | 1 |
| axis | disjoint repair family | 7 | 306,180 | 4,265 |
| axis | blocker | 15 | 108 | 2 |

Thus the bounded structural upgrade is useful for the locality-optimal radius-three port and for
all minimum blockers.  A representative-by-representative classification of full-port maximum
matchings is not a useful paper object: even after symmetry it has more than 1.3 million cubic
types.  The exact Burnside census records that negative boundary.

## Certificate and independent checks

The replay script is
[`2026-07-15-c202-repair-extremizers.py`](2026-07-15-c202-repair-extremizers.py), and its committed
orbit certificate is
[`2026-07-15-c202-repair-extremizers.json`](2026-07-15-c202-repair-extremizers.json).

The script:

1. imports the independent q=9 finite-field/matroid verifier and enumerates all 6,072 circuits of
   size at most five;
2. reconstructs all 720 normalized `PGL(2,9)` transformations on the cubic parameter line, derives
   the axis action from the unique three-cubic/one-axis completion relation, and checks that every
   transformation preserves the complete circuit inventory;
3. solves set packing and set cover with exact, dependency-free dynamic programs and cross-checks
   the optima against the original verifier's independent solvers;
4. canonicalizes every radius-three maximum matching and every minimum blocker at both radii;
5. certifies the large radius-four matching orbit counts by Burnside's lemma, counting fixed
   matchings as disjoint cyclic edge-orbit packings; and
6. optionally emits eight standard binary LP models with `--write-lp DIR` for replay in an external
   ILP solver.

Every orbit representative and orbit size that is small enough to be structurally useful is in
the JSON.  For the two large full-port matching sets, the certificate retains the fixed-count
distribution and exact Burnside quotient rather than materializing millions of representatives.

## What the extremizers are

At a cubic-infinity target, the radius-three clutter is the properly sum-coloured complete graph:
an edge is `{C(s), C(t), A(s+t)}`.  A maximum disjoint family is therefore a rainbow near-perfect
matching of the nine finite cubic parameters.  The seven q=9 orbits are genuinely distinct under
the affine target stabilizer.

The 45 minimum cubic blockers split into exactly two q=9 forms:

- 9 blockers containing every finite cubic except one;
- 36 blockers obtained by omitting two finite cubics `C(s),C(t)` and selecting the single axis
  coordinate `A(s+t)` together with the other seven finite cubics.

Only the first form remains a blocker after every radius-four repair is exposed, giving the single
full-port orbit of size 9.

At an axis-infinity target, the radius-three clutter is a disjoint union on vertex classes: the
complete graph on the nine other axis points and the twelve zero-sum cubic triples, which are the
affine lines of `AG(2,3)`; cubic infinity is isolated.  Hence every maximum family is a near-perfect
axis matching together with a parallel class of three cubic lines.  The simultaneous target
stabilizer couples these choices into 65 orbits.  Every minimum blocker is eight of the nine axis
vertices together with the complement of a maximum four-point zero-sum-free cubic set, producing
486 labelled blockers and eight coupled orbits.

For the full axis port, the 108 minimum blockers have two orbits, of sizes 36 and 72.  Equivalently,
their four-point complements are the two target-avoiding maximum-section types: one contains cubic
infinity and two finite cubic points, and the other contains three finite cubic points; both also
contain the unique omitted finite axis point.

Both forms give symbolic size-`q-1` blocker constructions over every `q=3^h`.  The q=9
certificate proves that they are exhaustive at q=9; the present uniform cardinality proof does not
classify equality, so uniform exhaustiveness is not claimed.

## Symbolic persistence verdict

The optimizer *decompositions* persist over `q=3^h`, but the finite orbit lists do not.

- Cubic radius-three maximum families remain rainbow near-perfect matchings in the sum-coloured
  `K_q`.  The two q=9 blocker forms above persist as optimal constructions, but proving that they
  exhaust equality for every `h` is a separate restricted-sumset classification.  The all-but-one
  finite-cubic construction is also a symbolic full-port minimum blocker.
- Axis radius-three maximum families remain the product of a near-perfect matching on the other
  axis coordinates and a partition of the additive group into zero-sum triples.  At q=9 such a
  partition is a parallel class of affine lines; in higher dimension line partitions need not be
  a single parallel class.
- Axis radius-three minimum blockers reduce exactly to an omitted axis vertex plus the complement
  of a maximum zero-sum-free set.  A uniform orbit classification would therefore require the
  separate classification of maximum caps in the elementary abelian 3-group.

The q=3 boundary replay confirms the non-persistence of a fixed orbit list: its radius-three
cubic/axis maximum-family orbit counts are 1/1 rather than 7/65, while its blocker orbit counts are
2/2 rather than 2/8.  The right general theorem is therefore the structural reduction above, not a
claim that the q=9 orbit representatives form field-uniform types.

## Publication disposition

The two-form cubic blocker classification is clean enough for a short structural remark.  The
axis result is best stated as a reduction to affine-line partitions and maximum zero-sum-free sets.
The 65-orbit table and the radius-four matching census belong in reproducibility material, not the
paper body.  No current theorem or novelty wording changes on the strength of this computation.
