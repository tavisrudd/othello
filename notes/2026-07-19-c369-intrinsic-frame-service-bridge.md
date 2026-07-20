# C369: intrinsic frame reconstruction to service--PIR extremizers

**Lane:** `crowns`

**Verdict:** `THEOREM; THE UNCOLOURED FRAME GRAPH RECOVERS THE EXACT MAXIMAL-SERVICE TARGET TRIPLE`

## Result

Let `K` be a projective frame in `PG(2,q)`, with `q>=13`, and let `G_K` be its abstract
uncoloured continuation graph.  Regard the four points of `K` as the columns of the projective
`[4,3,2]_q` MDS code recovered in C295.  Then `G_K` intrinsically recovers the three diagonal
points

\[
 D_K=\{ab\cap cd:\{\{a,b\},\{c,d\}\}\text{ is a partition of }K\}.
\]

For every requested projective target `P` outside `K`, let `r_K(P)` be the number of pairs of
columns of `K` spanning `P`.  The one-target fractional service capacity `s_K(P)` and maximum
number `kappa_K(P)` of pairwise disjoint recovery groups are

| `r_K(P)` | target position | `s_K(P)` | `kappa_K(P)` |
|---:|---|---:|---:|
| 0 | a legal continuation, hence a vertex of `G_K` | `4/3` | `1` |
| 1 | on exactly one frame secant | `3/2` | `1` |
| 2 | in `D_K` | `2` | `2` |

Consequently the following data are equivalent and intrinsic to the uncoloured graph:

1. `P` lies in the recovered diagonal triple `D_K`;
2. the four columns split into the two nonfixed projection-involution orbits through `P`;
3. `P` has the maximum possible one-target service capacity `2`; and
4. `P` has the maximum possible disjoint PIR availability `2`.

In particular, C295's forgotten conic marking causes no obstruction.  For every nonsingular conic
containing `K`, C357's extremizer predicate on targets off that conic descends to the same diagonal
triple `D_K`.  The conic determines a full projection involution, but its restriction relevant to
the four stored columns is exactly the graph-recovered secant pairing and is independent of which
containing conic was chosen.

There is one important boundary: the vertices of `G_K` are precisely the `r_K(P)=0` targets, so
none of them is an extremizer.  The positive bridge uses C295's reconstruction of the ambient
plane and frame, not a mistaken identification of continuation vertices with C357 extremizers.

## Compatibility proof

C295 reconstructs from `G_K`, uniquely up to semilinear frame equivalence, the field order, the
standard Desarguesian plane, the four-point frame, and its projective-column code.  It therefore
reconstructs all six frame secants and their intersections.  Because no three points of `K` are
collinear, two secant pairs through one target cannot share a frame point.  Hence `r_K(P)` is at
most two; equality holds exactly when the two pairs partition `K`, which gives precisely the three
points in `D_K`.  Every semilinear frame equivalence permutes this diagonal triple, so the
construction is independent of every choice in C295's reconstruction.

For the operational formulas, a two-column recovery group exists exactly when its secant contains
`P`.  Every three columns of the frame span the plane and recover every target.  Supersets of a
smaller recovery group may be discarded.

- If `r=0`, the four minimal groups are the four triples.  Weight `1/3` on each gives service
  `4/3`, and total server work gives the matching upper bound because every group has size at
  least three.
- If `r=1`, write the unique pair as `ab`; the other minimal groups are `acd` and `bcd`.  Weight
  `1/2` on all three groups gives service `3/2`.  Server dual weights
  `(1/2,1/2,1/4,1/4)` on `(a,b,c,d)` cover every recovery group and prove optimality.
- If `r=2`, the two secant pairs partition `K`; unit weight on both gives service `2`, which is
  optimal by total server capacity.

C357's disjoint-recovery formula at `m=4`,

\[
 \kappa=r+\left\lfloor\frac{4-2r}{3}\right\rfloor,
\]

gives `1,1,2` for `r=0,1,2`.  Thus the maximal-service and maximal-PIR predicates coincide exactly
on `D_K`, proving the claimed compatibility map.

## Prior theorems consumed and novelty boundary

- C295 supplies stable `q>=13` full-faithful reconstruction of the plane, frame, and unmarked
  projective-column code from `G_K`.
- C357 supplies the projection-involution/secant-pair criterion and the exact disjoint-PIR formula.

The new program-facing statement is their compatibility: C357's extremizer predicate survives the
conic marking forgotten by C295 and becomes an invariant of the abstract uncoloured continuation
graph.  The exact `4/3,3/2,2` capacity stratification is the elementary four-column specialization
that makes the map explicit.  No independent priority claim is made for the classical diagonal
points of a complete quadrangle or for elementary fractional packing duality.

## Scope

This is an operational theorem on the same reconstructed four-frame/code class, but it is not a
game-value theorem.  It neither determines a continuation-game nimber nor consumes any C294 value
data, so it does not clear C296.  It does not choose a containing conic, recover C357's full-conic
internal/external classification, treat frames below `q=13`, or extend the bridge to larger arcs.

No computation is load-bearing: the result is a direct composition of the two cited theorems plus
the displayed three-case linear-program calculation.
