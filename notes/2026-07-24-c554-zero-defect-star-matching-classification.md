# C554: zero-defect star--matching classification

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete. The universal reduction and the `k=6` classification are
proved below. At `k=7`, the required triangle decomposition of the
disjointness graph on the edges of `K_7` does not exist; two exact
independent recursions certify the finite abstract obstruction before any
projective realizability question. The general clique-decomposition,
arithmetic, Gram-rank, dual-conic, nucleus, and quantitative bad-edge
exports pass to C555.

## Scope

Let `A` be a `C`-complete `k`-arc in `PG(2,q)`, let
`m=floor(k/2)`, and assume the conic defect in
Theorem 3.1 of *Arcs complete outside a prescribed conic* vanishes:

    Delta_C(A)=0.

Write `r(x)` for the number of secants of `A` through `x` and put

    H={x notin A : r(x)=m}.

This report classifies the incidence structure forced by zero defect. It
does not reopen C210's repair-coset construction and makes no asymptotic
construction claim.

## The universal concurrency-clique decomposition

The matching structure exists before imposing zero defect.

### Theorem

For every `k`-arc `A`, the points `x notin A` with `r(x)>=2` canonically
decompose the edge set of `KG(k,2)`:

    E(KG(k,2)) = disjoint union over x of E(K_{r(x)}).

Here the vertices of `KG(k,2)` are the secants of `A`, indexed by the
edges of `K_k`, and the clique at `x` consists of the secants through `x`.

Indeed, secants through a point outside an arc use disjoint endpoint pairs
and hence form a matching, so they give a clique. Conversely, two vertices
of `KG(k,2)` are two secants with disjoint endpoint pairs; their unique
projective intersection lies outside `A` and places that graph edge in a
unique concurrence clique.

Thus the classical second moment

    sum_x C(r(x),2)=3*C(k,4)

is exactly the edge count of this clique decomposition. Zero defect says
that every nontrivial clique has the maximum possible order `m`, while
conic points are also forbidden to carry singleton cliques.

### Quantitative graph distance

Let `E_bad` be the `KG(k,2)` edges belonging to a concurrence clique of
order `2<=r<=m-1`. From the defect identity,

    |E_bad| <= ((m-1)/2)*m*Delta_C(A).

For an off-conic centre, this follows from

    C(r,2)/((r-1)(m-r)) = r/(2(m-r)) <= (m-1)/2.

For a conic centre the defect weight `r(m-r)` is larger, so the same bound
holds. Consequently, defect `o(m^2)` forces all but `o(|E(KG(k,2))|)`
disjoint secant pairs into maximum-matching concurrence cliques. This is
the precise approximate-arrangement statement exported to C555.

## The universal star--matching arrangement

### Theorem

If `k>=4`, then:

1. every point outside `A` has index `0`, `1`, or `m`; index zero occurs
   only on `C`;
2. the intersection of any two secants with disjoint endpoint pairs belongs
   to `H`;
3. the secants through any `x in H` form a maximum matching on the vertex
   set `A`;
4. the number of high-index centres is

       |H| = 3*C(k,4)/C(m,2)
           = (k-1)(k-3),  if k is even,
             k(k-2),      if k is odd;

5. every secant contains exactly

       k-3 high-index centres,  if k is even,
       k-2 high-index centres,  if k is odd.

Consequently, after applying any projective duality, the `C(k,2)` secants become
points indexed by the edges of `K_k`. Their determined lines are:

- `k` star lines of size `k-1`, one for each vertex of `K_k`; and
- `|H|` matching lines of size `m`, one for each high-index centre.

Two edge-points lie on a star line when their edges share a vertex, and on
a unique matching line when their edges are disjoint. Thus zero defect
forces a projectively embedded pairwise-balanced design whose blocks are
the stars and selected maximum matchings of `K_k`.

Equivalently, the matching blocks form a clique decomposition

    E(KG(k,2)) = disjoint union of copies of K_m,

where every clique is a maximum matching of `K_k`. This separates three
successive gates:

1. abstract clique-decomposition existence;
2. rank-three projective realizability after adjoining the `k` star blocks;
3. compatibility with the distinguished dual lines coming from `C`.

### Proof

The equality criterion in the defect identity gives

    r(x) in {1,m}  for x outside A union C,
    r(y) in {0,m}  for y in C.

Relative completeness excludes index zero off `C`. Two secants with
disjoint endpoint pairs meet outside `A` at a point of index at least two,
so equality forces index `m`. Distinct secants through a point outside the
arc use disjoint endpoint pairs; the `m` secants through a point of `H`
therefore form a maximum matching.

The classical second moment now has only the high-index contribution:

    |H|*C(m,2)=3*C(k,4).

Substitution of `k=2m` and `k=2m+1` gives the two displayed formulas.

Fix a secant `ab`. Among the other `C(k,2)-1` secants, exactly
`2(k-2)` meet it at `a` or `b`. Every remaining secant meets `ab` at a
point of `H`, and each such centre accounts for `m-1` of the remaining
secants. Hence the number on `ab` is

    (C(k,2)-1-2(k-2))/(m-1),

which simplifies to `k-3` in even size and `k-2` in odd size. The dual
description follows directly.

### Odd-size omitted-vertex balance

If `k=2m+1`, every matching block omits one vertex. Each vertex is omitted
by exactly

    2m-1=k-2

matching blocks.

To see this, fix a vertex `v` and count pairs of disjoint edges avoiding
`v`. There are `3*C(2m,4)`. A matching block omitting `v` contributes
`C(m,2)` such pairs, while a block containing `v` contributes
`C(m-1,2)`. Substituting the total number
`|H|=(2m+1)(2m-1)` and solving gives `2m-1`.

### Incidence Gram identity

Let `B` be the zero-one incidence matrix whose columns are the
`C(k,2)` dual secant points and whose rows are all star and matching
blocks. Every two columns lie together in exactly one block. A column lies
on `k-1` blocks for even `k` and `k` blocks for odd `k`. Hence, over the
integers,

    B^T B =
      J+(k-2)I,  if k is even,
      J+(k-1)I,  if k is odd.

This supplies immediate modular rank tests for any proposed abstract
decomposition. It does not by itself prove rank-three representability or
nonrepresentability.

## The dual conic refinement

Put `s=|H intersect C|` and fix a projective duality. A point `y in C`
maps to a distinguished line `y^*` in the dual plane. If `y^*` contains
the dual point of one `A`-secant, then the primal secant passes through
`y`; zero defect forces `r(y)=m`. Therefore:

- every distinguished line `y^*`, for `y in C`, meets the dual secant set
  in either zero or `m` points; and
- the `s` distinguished matching lines are exactly the duals of the centres
  in `H intersect C`.

In odd characteristic, conic polarity identifies the dual plane with the
original plane and these distinguished lines are the tangents to the
dual conic. In even characteristic the polar form of a conic is degenerate
and the nucleus replaces this polarity picture; the characteristic split
must not be suppressed.

Moreover,

    I_C(A)=m*s

and the zero-defect equation determines `s`:

    s = C(k,2)(q-1) - (q^2-k) - (6/m)C(k,4)
      = C(k,2)(q-1) - q^2 + k - |H|(m-1).

Thus the right side must be an integer satisfying

    0 <= s <= min(q+1, 2*C(k,2)/m).

These are necessary arithmetic conditions before any finer use of polarity.

### Even-characteristic nucleus amplification

Assume `q` is even and let `nu` be the nucleus of `C`.

- If `nu in A`, the `k-1` tangent secants have distinct contact points on
  `C`. Each contact point has positive index and hence index `m`, so

      s>=k-1,  I_C(A)=m*s>=m(k-1).

- If `nu notin A`, relative completeness and zero defect give

      r(nu) in {1,m}.

  The tangent secants are exactly those through `nu`, so their number is
  either `1` or `m`; their distinct contact points are matching centres on
  `C`.

Thus equality amplifies the manuscript's universal nucleus incidence loss:
individual tangent contacts cannot occur and must extend to full matching
centres.

## Classification at `k=6`

### Theorem

Let `A` be a six-arc in a Desarguesian projective plane. Its secant
arrangement has no intersection of index two outside `A`—equivalently,
every point of positive secant index has index `1` or `3`—if and only if
the field has characteristic two, contains `F_4`, and `A` is projectively
equivalent to

    (1,0,0), (0,1,0), (0,0,1), (1,1,1),
    (1,w,w^2), (1,w^2,w),

where `w^2+w+1=0`. This is the scalar extension of the six-point hyperoval
in `PG(2,4)`.

If this arrangement is also zero-defect and `C`-complete, then `q=4`.
Conversely, in `PG(2,4)` the displayed hyperoval is disjoint from the
nonsingular conic

    x^2+y^2+z^2+xy+xz+w*yz=0,

and is a zero-defect `C`-complete six-arc.

### Proof

For six points, `m=3`. Given four vertices, each of the three intersections
of opposite sides has index at least two. Index three forces the secant
through the remaining pair to pass through all three diagonal points.
Thus the diagonal points of every complete quadrangle are collinear.
After projectively normalizing four vertices to

    e_1, e_2, e_3, (1,1,1),

their diagonal points are

    (1,1,0), (1,0,1), (0,1,1).

Their determinant is `2`, so the field has characteristic two. Their line
is `x+y+z=0`; write the fifth point as

    (1,t,1+t),  t notin {0,1}.

Apply the same condition to the quadrangle consisting of the first three
frame points and this fifth point. Its diagonal line has equation

    t(1+t)x+(1+t)y+t z=0.

The fourth frame point must lie on that line, giving

    t^2+t+1=0.

The sixth point is the intersection of this diagonal line with
`x+y+z=0`, namely `(1,t^2,t)`. This proves necessity and uniqueness up to
projectivity.

Conversely, the six displayed points form the hyperoval in `PG(2,4)`.
Every point outside it lies on exactly three of its secants: the five lines
through such a point partition the six hyperoval points into secant pairs
and exterior lines, hence exactly three are secants. Scalar extension
preserves all intersections among the fifteen secants, while new points on
those lines have index one. This proves the arrangement assertion.

For a zero-defect `C`-complete six-arc, the arithmetic formula above becomes

    s=-q^2+15q-39,
    0<=s<=10.

The prime-power possibilities are `q=4` and `q=11`; the arrangement
classification requires characteristic two and an `F_4` subfield, leaving
`q=4`. For the displayed quadratic, its values at the six hyperoval points
are respectively

    1, 1, 1, w^2, w^2, w^2,

so it is disjoint from the arc. Its polar radical is `(w,1,1)`, where the
quadratic takes value `1`; hence the conic is nonsingular. Since every
point outside the hyperoval lies on three secants, the arc is complete
before any hole is allowed and therefore is `C`-complete. The five conic
points contribute `s=5` high-index centres, as required.

## Combinatorial nonexistence at `k=7`

Here `m=3`, `|H|=35`, and every secant lies on five high-index centres.
Let `D=KG(7,2)` be the disjointness graph whose 21 vertices are the edges of
`K_7`, with adjacency when two edges are disjoint. A high-index centre gives
a triangle of `D`, namely a three-edge near-perfect matching of `K_7`.

Zero defect is therefore equivalent, at the abstract incidence level, to a
triangle decomposition of `D`:

    E(D) = disjoint union of 35 matching triangles.

Indeed, `D` is 10-regular and has 105 edges. Every pair of disjoint
secants has a unique intersection, and index three supplies one further
secant through that centre. Conversely, each matching triangle accounts
for its three pairs of disjoint secants, so exactly 35 triangles are
required.

For two fixed disjoint edges, three vertices remain. The third secant
through their intersection may join any one of the three remaining pairs,
leaving the last vertex unmatched. Thus, unlike `k=6`, local completion is
not unique. In particular, one may not infer that every perfect matching on
an arbitrary six-subset is concurrent.

### Theorem

The graph `KG(7,2)` has no decomposition into matching triangles.
Consequently, no seven-arc in any projective plane has zero defect with
respect to any prescribed conic.

### Exact finite proof

There are 105 near-perfect matchings of `K_7`. Each of the 105 disjoint
edge pairs belongs to exactly three of them. A decomposition is therefore
an exact cover of 105 constraints by 35 three-constraint blocks.

By `S_7`-transitivity on near-perfect matchings, a hypothetical cover may be
normalized to contain

    {01,23,45}, omitting 6.

The primary bit-mask exact-cover recursion exhausts this normalized domain
in 97 nodes, reaches depth 27, and finds no cover. An independent
set-based recursion generates each of the three completions of a disjoint
edge pair directly from its three unused vertices; it exhausts the same
normalized domain in 2,906 nodes, reaches depth 29, and also finds no
cover. Both use exact integer/set operations and have no external
dependencies or nondeterminism.

The evidence bundle is:

- `notes/2026-07-24-c554-k7-triangle-decompositions.py` (14,839 bytes);
- `notes/2026-07-24-c554-k7-triangle-decompositions.json` (992 bytes);
- `notes/2026-07-24-c554-k7-triangle-decompositions.sha256`.

Replay from the repository root with

    python3 notes/2026-07-24-c554-k7-triangle-decompositions.py \
      --check-evidence \
      notes/2026-07-24-c554-k7-triangle-decompositions.json
    sha256sum -c \
      notes/2026-07-24-c554-k7-triangle-decompositions.sha256

The computation proves only the stated finite graph-decomposition
nonexistence. The geometric implication is exact because the universal
reduction maps every zero-defect seven-arc to such a decomposition. No
coordinate enumeration, field restriction, or conic search is used.

## Literature boundary

No novelty claim is made in this report for the terminology or abstract
graph-decomposition statements. Before manuscript insertion, the owning
paper task must audit prior work on clique decompositions of Kneser graphs,
matching designs, the six-point `F_4` hyperoval configuration, and
characteristic-dependent line arrangements. The theorems above are proved
self-containedly or by the committed finite evidence bundle; that proof
status is separate from priority.

## C555 export

For nonzero defect, every intersection of disjoint secants which is not a
maximum-matching centre lies in one of the nonextremal sets `M` or `J` of
the paper's stability corollary. C555 should count bad *pairs of disjoint
edges*, not only bad centres: a centre of index `r` absorbs `C(r,2)` such
pairs. The natural next statistic is

    sum_x C(r(x),3),

which counts concurrent triples of pairwise disjoint secants. At zero
defect it equals

    |H|*C(m,3).

The C554 dual arrangement and its `(0,m)` tangent intersection property are
the exact equality object against which a third-moment or polarity deficit
should be measured.

## Mystery ledger

- **General embeddability:** the `ej`+`tt` pass sharpened the object to a
  maximum-matching clique decomposition of `KG(k,2)` followed by rank-three
  representation. The `k=7` object is excluded abstractly; abstract
  existence and projective realizability for `k>=8` remain open and belong
  to a future successor only if C555 needs them.
- **Conic tangents:** zero defect turns the secant-pole set into a
  `(0,m)`-set for the distinguished dual lines, and in odd characteristic
  for rational tangents under polarity. The nucleus amplification settles
  the first even-characteristic consequence. A stronger divisibility or
  spectral obstruction remains open for C555.
- **Robustness scale:** settled at the combinatorial level by the universal
  variable-clique decomposition and
  `|E_bad|<=m(m-1)Delta_C(A)/2`. The remaining evidence gap is geometric:
  candidate moment-bound sizes can have defect of order `m^2`, precisely
  where this estimate need not make the bad-edge density small. C555 owns
  the additional moment or polarity input.
- **Priority:** the graph-decomposition and hyperoval literature has not yet
  been audited. No novelty wording may enter the manuscript until a
  task-specific literature audit closes this item.
