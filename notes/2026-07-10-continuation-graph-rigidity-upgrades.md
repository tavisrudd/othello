# Continuation-graph rigidity: embedded recovery, intrinsic traces, and semilinear extension

**Date:** 2026-07-10

## Executive conclusion

Continuation-graph rigidity separates into three materially different
questions.

1. **Embedded recovery:** if the ambient incidence geometry is known and an
   ambient collineation preserves the continuation graph, must it preserve
   the selected arc? This admits a clean, general answer in every finite
   partial linear space.
2. **Intrinsic trace recovery:** can the abstract graph recover the tangent
   lines and their centres without being told the ambient plane? For fixed
   arc size and sufficiently large order, the answer is yes, with explicit
   bounds.
3. **Semilinear extension:** must an abstract graph isomorphism come from an
   ambient collineation? This is false for one-, two-, and generally
   three-point arcs. For four-point projective frames it is true for every
   prime power `q>=13`.

The first item is useful companion infrastructure but is too elementary to
headline a paper. The other two now supply two independent headline
theorems:

- the abstract continuation graph of a four-point frame has exactly its
  ambient semilinear automorphisms for `q>=13`; and
- the full continuation complex of a `k`-arc canonically reconstructs the
  ambient plane and the arc whenever, with `r=C(k,2)`,

  ```text
  q>=r^2-r+k.
  ```

The latter retains collinear triples among future moves and repairs the
exact one- and two-point information loss of the graph.

The strongest current exact result is that, for a `k`-arc in a projective
plane, the abstract graph recovers all tangent traces when

```text
q-C(k-1,2) > k(k-2)+1,
```

and also recovers their partition by the `k` selected centres when

```text
q+2-k > k C(k-2,2).
```

For `k=8`, the combined graph threshold is `q>=127`. This is a true
intrinsic tangent/centre reconstruction statement, although its constants
are not expected to be sharp. The full-complex theorem has a different,
larger uniform threshold but reconstructs the entire ambient incidence
plane, not only the tangent-centre structure.

These results do not produce a winning cap-game strategy. They reconstruct
geometric data from the residual conflict relation and may justify symmetry
reductions, but they do not determine P/N value.

## 1. Definitions and the three rigidity levels

Let `(P,L)` be a finite partial linear space: two distinct points lie on at
most one common line. Let `K` be a `k`-cap, meaning that no line contains
three points of `K`. Its legal one-point continuation set is

```text
V_K = { x in P minus K : K union {x} is a cap }.
```

Define the continuation graph `G_K` on `V_K` by

```text
x ~_K y
  iff some line contains x, y, and a point of K.       (1.1)
```

Equivalently, `{x,y}` is an edge when the two individually legal moves are
not jointly legal over `K`.

Because `x` and `y` are individually legal, a line witnessing (1.1)
contains exactly one point of `K`. Thus every edge has a unique selected
centre.

The following levels must remain distinct.

### Level I — embedded rigidity

The ambient point-line geometry is known. An incidence automorphism `h`
maps `V_K` to `V_J` and preserves graph adjacency. The question is whether
`h(K)=J`.

### Level II — intrinsic trace and centre recovery

Only the abstract graph `G_K` is given. The goal is to recover:

- the traces in `V_K` of tangent lines to `K`; and
- the partition of those traces according to their selected centres.

### Level III — ambient extension

Given an abstract isomorphism `G_K -> G_J`, determine whether it is induced
by a collineation of the ambient geometries. This is strictly stronger than
recovering abstract centres. The fundamental theorem of projective geometry
applies only after enough point-line incidence has been reconstructed; it
cannot be invoked merely from a graph or code isomorphism.

## 2. Exact embedded reconstruction in partial linear spaces

Call a line `ell` a **visible tangent** to `K` if

```text
|ell intersect K|=1,
|ell intersect V_K|>=2.
```

Let `Sigma_K` be the set of visible tangents and define the embedded support
degree

```text
d_K(p)=|{ell in Sigma_K : p in ell}|.
```

### Theorem 2.1 — support-degree reconstruction [PROVED]

For every `p notin K`,

```text
d_K(p)<=k.                                           (2.1)
```

Consequently, if every `t in K` lies on more than `k` visible tangents, then

```text
K = {p in P : d_K(p)>k}.                            (2.2)
```

In particular, every ambient incidence automorphism carrying the embedded
continuation graph of `K` to that of an equal-size cap `J` carries `K` to
`J`.

#### Proof

A visible tangent through `p notin K` has a unique selected centre `t in K`.
Two distinct visible tangents through `p` cannot have the same centre,
because two points determine at most one line. Hence the support lines
through `p` inject into `K`, proving (2.1). A selected point satisfying the
hypothesis has support degree greater than `k`, while no outside point does,
which proves (2.2).

An ambient incidence automorphism maps graph edges and their supporting
lines to graph edges and their supporting lines. It therefore preserves
support degree. The image of the `k` high-degree points of `K` lies in `J`,
and equal cardinalities give equality. `square`

The original projective-plane theorem used two numerical hypotheses only to
force the support-degree gap. Equation (2.2) is the underlying reconstruction
identity.

### Corollary 2.2 — a uniform partial-linear-space criterion [PROVED]

Suppose every line has at least `b` points and every point lies on at least
`r` lines. It is sufficient that

```text
b-1-C(k-1,2)>=2,             r-(k-1)>k.             (2.3)
```

#### Proof

A tangent through `t` has at least `b-1` other points. A point on it can be
illegal only by lying on a secant among `K minus {t}`. There are at most
`C(k-1,2)` such secants, and each meets the tangent in at most one point.
Thus the first inequality makes every tangent visible.

At most `k-1` lines through `t` contain another selected point, so at least
`r-(k-1)` are tangents. The second inequality and Theorem 2.1 finish the
proof. `square`

This applies directly to finite projective and affine spaces, linear spaces,
and any polar or generalized-polygon point-line geometry satisfying the
displayed local bounds. The exact support-degree formulation is preferable
when the geometry is irregular.

### Theorem 2.3 — dimension-sensitive projective bound [PROVED]

Let `K` be a `k`-cap in `PG(n,q)`, and put

```text
theta_(n-1)(q)=1+q+...+q^(n-1),
```

the number of lines through a point. Every selected point lies on at least

```text
theta_(n-1)(q)-(k-1)-C(k-1,2)                      (2.4)
```

visible tangents. Hence embedded rigidity holds whenever

```text
theta_(n-1)(q)>2k-1+C(k-1,2).                      (2.5)
```

#### Proof

There are `theta_(n-1)(q)-(k-1)` tangent lines through a selected point `t`.
Call one unsupported if it contains at most one legal point. Since it has
`q` points other than `t`, an unsupported tangent contains at least `q-1`
points blocked by secants of `K minus {t}`.

One such selected secant contains `q+1` points, two of them selected. Viewed
from `t`, its remaining points lie on at most `q-1` tangent lines through
`t`. Double-counting incidences between unsupported tangents and selected
secants shows that at most `C(k-1,2)` tangents are unsupported. This gives
(2.4), and Theorem 2.1 gives (2.5). `square`

For planes, the original per-tangent estimate is normally sharper. For
dimension at least three, the large pencil size in (2.5) can prove rigidity
even when not every tangent is visible.

## 3. The graph as a hypergraph line graph and a nonlinear code

Return to a projective plane. For every `t in K`, let `Sigma_t` be the
`q+2-k` tangent lines through `t`. For `x in V_K`, define

```text
S_x={xt:t in K} subset union_(t in K) Sigma_t.       (3.1)
```

### Proposition 3.1 — intersection representation [PROVED]

The sets `S_x` form a `k`-uniform linear hypergraph `H_K`, and

```text
|S_x intersect S_y|
  = 1  if x ~_K y,
    0  otherwise.                                   (3.2)
```

Thus `G_K` is the intersection graph, or line graph, of `H_K`.

#### Proof

Since `x` is legal, `xt` is a tangent for every `t in K`, so `|S_x|=k`.
If two sets share a tangent symbol, `x,y` lie on that tangent and are
adjacent. Conversely, an adjacent pair lies on its unique tangent witness.
Two distinct points cannot share two lines. `square`

Equivalently, choose each `Sigma_t` as a coordinate alphabet and define

```text
Phi_K(x)=(xt)_(t in K) in product_(t in K) Sigma_t.  (3.3)
```

This is an injective nonlinear length-`k` code. Distinct codewords agree in
at most one coordinate, so its minimum Hamming distance is at least `k-1`;
the graph joins exactly the pairs at distance `k-1`.

This coding dictionary is useful but must not be oversold. The code need not
be linear, additive, or a full MDS code. In particular, MacWilliams extension
theorems do not imply that a graph isomorphism is monomial or semilinear.
Dyshko's
[MacWilliams Extension Theorem for MDS additive codes](https://arxiv.org/abs/1504.01355)
emphasizes both the strength of extension theorems under additive hypotheses
and their failure in general nonlinear settings.

Classical context for line graphs of uniform linear hypergraphs includes
Naik, Rao, Shrikhande, and Singhi,
[Intersection Graphs of `k`-Uniform Linear Hypergraphs](https://doi.org/10.1016/S0197-5060(08)70711-8).

## 4. Intrinsic recovery of tangent traces

For a tangent line `ell`, write

```text
B_ell=ell intersect V_K.
```

It is a clique in `G_K`. Not every graph clique need lie on one tangent:
different edges may have different selected centres.

### Lemma 4.1 — non-tangent clique bound [PROVED]

Assume `k>=2`. If a clique `C` of `G_K` is not contained in one tangent
trace, then

```text
|C|<=k(k-2)+1.                                      (4.1)
```

#### Proof

Fix `x in C`. Partition `C minus {x}` into sets `C_t`, where `y in C_t` when
the edge `xy` is centred at `t in K`.

For every nonempty `C_t`, choose `z in C` outside the tangent line `xt`; such
a `z` exists because the whole clique is not contained in that trace. Let
`u` be the centre of `xz`. For `y in C_t`, let `s_y` be the centre of `zy`.
The centres `s_y` are distinct: otherwise two distinct points of the line
`xt` would also lie on one line through `z`. Moreover, `s_y` is neither `t`
nor `u`, since either equality would force `z` or `y` onto both `xt` and
`xu`. Hence `|C_t|<=k-2`.

There are at most `k` parts, so

```text
|C|-1=sum_t |C_t|<=k(k-2).
```

This proves (4.1). `square`

Deza's general weak-Delta-system theorem gives the related bound
`k^2-k+1` for arbitrary `k`-uniform linear hypergraphs; see
[Deza, Solution d'un probleme de Erdos-Lovasz](https://doi.org/10.1016/0095-8956(74)90059-8).
Lemma 4.1 improves it for this continuation geometry because the hypergraph
symbols are resolved into selected centres.

### Theorem 4.2 — abstract tangent-trace recovery [PROVED]

If

```text
q-C(k-1,2)>k(k-2)+1,                               (4.2)
```

then the tangent traces are exactly the maximal cliques of `G_K` having more
than `k(k-2)+1` vertices. Thus every abstract graph isomorphism
`G_K -> G_J` canonically induces an isomorphism between their uncoloured
tangent-trace hypergraphs.

#### Proof

A tangent contains `q` points other than its centre. At most
`C(k-1,2)` are blocked by secants among the other selected points, so its
trace has at least the left side of (4.2) vertices.

Lemma 4.1 says every clique above the displayed threshold lies in one
tangent trace. Such a trace is maximal: any vertex adjacent to its whole
trace would create a still larger clique and hence would have to lie in the
same trace. Conversely, every maximal clique above the threshold is the full
trace containing it. `square`

For `k=8`, condition (4.2) is `q>70`, improving the direct Deza threshold
`q>=79` to `q>=71`.

## 5. Intrinsic recovery of the selected centres

Theorem 4.2 recovers tangent traces but initially forgets which traces have
the same selected centre. In a projective plane, this resolution can also be
recovered for sufficiently large `q`.

Form the disjointness graph `D_K` whose vertices are recovered tangent
traces, with two traces adjacent when they are disjoint as subsets of
`V_K`.

### Theorem 5.1 — centre-class recovery [PROVED]

Assume (4.2), and put

```text
T=q+2-k,                       c=C(k-2,2).
```

If

```text
T>kc,                                               (5.1)
```

then the `k` centre classes are exactly the maximal cliques of `D_K` having
more than `kc` members. Consequently, the abstract continuation graph
recovers:

1. its tangent traces;
2. their partition into `k` selected centres; and
3. the incidence triples `(t,x,y)` in which `x,y in V_K` lie with the
   recovered centre `t` on a tangent.

#### Proof

The `T` tangent traces with the same centre are pairwise disjoint, so they
form a clique in `D_K`.

Let `A` be a trace centred at `t`, and fix `u!=t`. A tangent at `u` is
disjoint from `A` only when the two ambient tangent lines meet at an illegal
point. Their intersection cannot lie on a secant involving `t` or `u`, since
the corresponding line would cease to be tangent. It must therefore lie on
one of the `c=C(k-2,2)` secants with both endpoints in
`K minus {t,u}`. Each such secant determines at most one tangent through
`u`, so at most `c` traces centred at `u` are disjoint from `A`.

Now take a disjointness clique using at least two centre classes. Choose
members `A,B` with distinct centres. The member `A` bounds the contribution
from every other centre class by `c`, and `B` supplies the same bound for
the centre class of `A`. Hence the mixed clique has at most `kc` members.
Under (5.1), every larger clique is contained in one centre class, and
maximality recovers the whole class. `square`

This argument is plane-specific. In dimension at least three, tangent lines
with different centres can be skew, so disjointness no longer recognizes a
common centre.

The current uniform thresholds are:

| `k` | tangent traces recovered when | centres recovered when | combined integer threshold |
|---:|---:|---:|---:|
| 3 | `q>5` | `q>1` | `q>=7` |
| 4 | `q>12` | `q>6` | `q>=13` |
| 5 | `q>22` | `q>18` | `q>=23` |
| 6 | `q>35` | `q>40` | `q>=41` |
| 8 | `q>70` | `q>126` | `q>=127` |

These are sufficient, not claimed sharp. The `O(k^3)` centre threshold is
the most obvious target for improvement.

## 6. Exact obstructions to ambient extension

Intrinsic trace recovery does not imply that graph automorphisms are
ambient collineations.

### Proposition 6.1 — one-point obstruction [PROVED]

For a one-point cap in `PG(n,q)`, the abstract continuation graph is

```text
theta_(n-1)(q) disjoint copies of K_q.
```

Its abstract automorphism group is vastly larger than the ambient point
stabilizer.

### Theorem 6.2 — the two-point graph is always a rook graph [PROVED]

Let `K={a,b}` in any projective plane of order `q`. Then

```text
G_K isomorphic to K_q square K_q.                  (6.1)
```

The isomorphism type is independent of the projective plane.

#### Proof

The legal points are precisely the `q^2` points outside the line `ab`. Map
such a point `x` to the ordered pair of tangent lines `(ax,bx)`. Every choice
of one tangent at `a` and one tangent at `b` meets in a unique legal point.
Two points are adjacent exactly when they share one of these two tangent
lines, which is rook adjacency. `square`

Thus nonisomorphic projective planes of the same order have identical
two-point continuation graphs. In `PG(2,q)`, for prime `q>=5`,

```text
|Aut(G_K)|=2(q!)^2,
```

whereas the setwise PGL stabilizer of `{a,b}` has order

```text
2q^2(q-1)^2.
```

The groups already differ at `q=5`.

### Theorem 6.3 — a three-point multiplicative obstruction [PROVED]

Let `K` be a triangle in `PG(2,q)`. After taking its vertices as the
coordinate points, every legal point has a unique form

```text
(x:y:1),                 x,y in F_q^*.
```

Under this identification,

```text
(x,y) ~ (x',y')
  iff x=x' or y=y' or x/y=x'/y'.                   (6.2)
```

Every automorphism `alpha` of the multiplicative group `F_q^*` therefore
induces a graph automorphism

```text
(x,y) |-> (alpha(x),alpha(y)).                     (6.3)
```

If `alpha` is not a field automorphism, (6.3) is not induced by a
semilinear collineation stabilizing `K`.

#### Proof

The three equalities in (6.2) record the tangent pencils at the three
coordinate vertices. A group automorphism preserves equality and quotient,
so (6.3) preserves adjacency.

The map (6.3) preserves each of the three tangent-pencil partitions. Any
ambient collineation inducing it must therefore fix all three triangle
vertices. Such a semilinear collineation is represented by a diagonal matrix
followed by a field automorphism `sigma`; on normalized points it acts as

```text
(x,y) |-> (A sigma(x),B sigma(y)).
```

Since a group automorphism fixes `1`, equality with (6.3) forces `A=B=1`
and `alpha=sigma`. `square`

For example, inversion on `F_5^*` gives a nonambient continuation-graph
automorphism. More generally the obstruction occurs whenever
`Aut(F_q^*)` is larger than the Frobenius subgroup.

Therefore a blanket semilinear-extension theorem can begin no earlier than
`k=4`.

## 7. The four-point frame as the first exact gate

Every four-arc in `PG(2,q)` is a projective frame. Normalize it as

```text
K={(1:0:0),(0:1:0),(0:0:1),(1:1:1)}.
```

### Proposition 7.1 — four-coordinate normal form [PROVED]

The legal continuation points are

```text
Omega={ (x,y) : x,y notin {0,1}, x!=y }.
```

The map

```text
(x,y) |-> ( x, y, x/y, (x-1)/(y-1) )              (7.1)
```

is an injective length-four code over four alphabets of size `q-2`, and two
vertices are adjacent exactly when their words agree in one coordinate.

#### Proof

The six secants of the frame have equations

```text
X=0, Y=0, Z=0, X=Y, X=Z, Y=Z.
```

After normalizing `Z=1`, avoiding them is exactly the displayed description
of `Omega`. Direct line equations through the four frame points show that
their pencil parameters are, up to harmless reparametrization,

```text
x,       y,       x/y,       (x-1)/(y-1).
```

Equality of a pencil parameter is precisely adjacency with the corresponding
selected centre. `square`

For `q>=13`, Theorems 4.2 and 5.1 recover the four coordinate partitions
from the abstract graph. After composing with the unique projectivity
realizing a permutation of the frame, a coordinate-preserving graph
automorphism must therefore satisfy functional equations of the form

```text
alpha(x)/beta(y) = gamma(x/y),

(alpha(x)-1)/(beta(y)-1)
  = delta((x-1)/(y-1))                             (7.2)
```

for all admissible `x,y`.

### Lemma 7.2 — punctured multiplicative isotopy [PROVED]

Let `F=F_q`, put `D=F minus {0,1}`, and suppose permutations
`alpha,beta,gamma` of `D` satisfy

```text
alpha(x)/beta(y)=gamma(x/y)                        (7.2)
```

for all distinct `x,y in D`. If `q>=5`, then

```text
alpha=beta=gamma=chi,
```

where `chi` extends to an automorphism of the multiplicative group `F^*`.

#### Proof

The map

```text
(x,y) |-> (alpha(x),beta(y))
```

sends `Omega` injectively to itself: the right side of (7.2) is never `1`,
so the two output coordinates are distinct. Finiteness makes the map onto.
The row with first coordinate `x` omits the column `x`; its image omits
`beta(x)`. But the complete output row with first coordinate `alpha(x)`
omits `alpha(x)`. Therefore `alpha(x)=beta(x)` for every `x`. Write the
common permutation as `h`.

In multiplicative notation, (7.2) becomes

```text
h(ry)=gamma(r)h(y)                                 (7.3)
```

whenever `r,y,ry` are all different from `1`. Extend `gamma(1)=1`. If
`r,s,rs!=1`, choose

```text
y notin {1,s^(-1),(rs)^(-1)}.
```

Such a `y` exists because `|F^*|>=4`. Applying (7.3) twice gives

```text
gamma(rs)=gamma(r)gamma(s).
```

The missing inverse case follows by choosing `y notin {1,r}` and comparing
`h(y)` with `h(rr^(-1)y)`. Thus `gamma` extends to a multiplicative-group
automorphism.

Equation (7.3) also shows that `h(x)/gamma(x)` is independent of
`x in D`, say `h(x)=A gamma(x)`. Since both maps permute `D`, one has

```text
A D=D.
```

But `A D=F^* minus {A}`, whereas `D=F^* minus {1}`. Hence `A=1`, proving
the lemma. `square`

### Lemma 7.3 — simultaneous shifted isotopy forces Frobenius [PROVED]

Suppose permutations `alpha,beta,gamma,delta` of `D` satisfy both equations

```text
alpha(x)/beta(y)=gamma(x/y),

(alpha(x)-1)/(beta(y)-1)
  = delta((x-1)/(y-1))                             (7.4)
```

for all distinct `x,y in D`. Then all four maps are the restriction of one
field automorphism of `F_q`.

#### Proof

Lemma 7.2 gives

```text
alpha=beta=gamma=chi,
```

where `chi` is a multiplicative-group automorphism. Define

```text
eta(z)=1-chi(1-z),             z in D.
```

The maps `z |-> 1-z`, `chi`, and `w |-> 1-w` all permute `D`, so `eta`
does too. Substituting `x=1-z`, `y=1-w` into the second equation gives

```text
eta(z)/eta(w)=delta(z/w).
```

Applying Lemma 7.2 again shows that `eta=delta=lambda` for another
multiplicative-group automorphism.

Write

```text
chi(x)=x^m,                 lambda(x)=x^n,
```

where `1<=m,n<=q-2` and both exponents are coprime to `q-1`. The identity
defining `eta` says

```text
(1-z)^m+z^n=1
```

for every `z in D`; it also holds at `z=0,1`. The polynomial

```text
(1-X)^m+X^n-1
```

therefore has all `q` field elements as roots but degree at most `q-2`, so
it is zero. Comparing degrees gives `m=n`, and then

```text
(1-X)^m=1-X^m.
```

All intermediate binomial coefficients vanish in the characteristic `p`.
By Lucas's theorem, this happens exactly when `m=p^i`. Thus all four maps
are the same Frobenius automorphism. `square`

### Theorem 7.4 — semilinear rigidity of the frame graph [PROVED]

Let `K` be a projective frame in `PG(2,q)`. For every prime power `q>=13`,

```text
Aut(G_K)=Stab_PGammaL(3,q)(K)                      (7.5)
```

as permutation groups on `V_K`. In particular,

```text
|Aut(G_K)|=24 [F_q:F_p].                           (7.6)
```

#### Proof

Theorems 4.2 and 5.1 intrinsically recover the four tangent-pencil classes
when `q>=13`. Every graph automorphism therefore permutes those four
classes. Any permutation of a projective frame is realized by a unique
projectivity. Compose by its inverse, reducing to an automorphism that
preserves all four classes.

Such an automorphism induces four symbol permutations satisfying (7.4).
Lemma 7.3 makes them one common field automorphism, which is induced by a
semilinear collineation fixing the normalized frame. The reverse inclusion
is immediate because every semilinear frame stabilizer preserves legal
points and collinearity. The PGL stabilizer of a projective frame is `S_4`,
and the field automorphism group has order `[F_q:F_p]`, giving (7.6).
`square`

The bound `q>=13` is an intrinsic-resolution threshold, not an algebraic
one: Lemmas 7.2–7.3 already classify coordinate-preserving automorphisms for
`q>=5`. At `q=5`, the full graph is

```text
K_6 minus 3K_2,
```

whose automorphism group has order `48`, twice the order of the PGL frame
stabilizer. The extra symmetry moves the geometric coordinate resolution to
a different resolution. The remaining orders `q=7,8,9,11` require only a
small exact exception table, not a new uniform proof.

### 7.5 Moduli-space identification and novelty boundary

Normalize five ordered points of `P^1` as

```text
(p1,p2,p3,p4,p5)=(infinity,0,1,x,y).
```

Then `Omega` is exactly `M_(0,5)(F_q)`. Four of its five forgetful maps to
`M_(0,4)` have, up to standard cross-ratio reparametrization, coordinates

```text
x,  y,  x/y,  (x-1)/(y-1).
```

The map forgetting `p1=infinity` is omitted. Thus `G_K` is precisely the
**uncoloured four-forgetful-map fibre-coincidence graph**: two rational
moduli points are adjacent when one of those four map values agrees. The
graph forgets both the fifth map and which retained map witnesses an edge.

Bruno and Mella prove that the algebraic automorphism group of the full
compactified moduli space is `S_5`; see
[Bruno--Mella, JEMS 15 (2013)](https://doi.org/10.4171/JEMS/382).
Stabilizing the omitted marking gives the expected `S_4`, with Frobenius
supplying the finite-field semilinear factor. This does **not** imply
Theorem 7.4: their input is an algebraic automorphism of the full moduli
object, whereas Theorem 7.4 starts from an arbitrary permutation of the
finite rational point set preserving only one uncoloured binary relation.
Intrinsic recovery of the four fibre partitions is the extra rigidity.

The cross-ratio graphs of Gardiner--Praeger--Zhou use all ordered distinct
pairs on `PG(1,q)` and prescribe adjacency by a cross-ratio orbit. They are
relevant automorphism-method prior art but do not subsume this four-map
reduct; see
[Gardiner--Praeger--Zhou, JLMS 64 (2001)](https://doi.org/10.1112/S0024610701002150).

The narrow surviving novelty claim is therefore arbitrary
**graph-permutation rigidity of the four-map reduct**: the uncoloured graph
reconstructs its four forgotten colours, after which every automorphism is
induced by `S_4` and Frobenius.

## 8. The full continuation complex

The graph forgets future collinear triples on lines avoiding `K`. The
natural stronger object is

```text
Delta_K={X subset V_K : K union X is a cap}.        (8.1)
```

### Proposition 8.1 — exact minimal nonfaces [PROVED]

The minimal nonfaces of `Delta_K` are exactly:

1. pairs `{x,y}` whose line contains one point of `K`; and
2. collinear triples `{x,y,z}` whose line contains no point of `K`.

#### Proof

Every failure of the cap condition contains a collinear triple. A triple
with two points of `K` cannot contain a legal continuation point. A triple
with one point of `K` gives a forbidden pair of continuations. A triple with
no point of `K` is minimally forbidden exactly when none of its pairs is
already forbidden, equivalently when its line avoids `K`. No larger minimal
nonface is possible. `square`

Thus the graph is only the two-element part of the residual collinearity
clutter. The three-element part records line incidence that the graph loses.

### Theorem 8.2 — the two-point complex reconstructs the plane [PROVED]

Let `q>=3`, let `K={a,b}` in an arbitrary projective plane, and suppose only
the abstract complex `Delta_K` is given. Then `Delta_K` determines:

1. the affine plane obtained by deleting `ab`;
2. the two distinguished parallel classes corresponding to `a` and `b`;
3. the projective completion; and therefore
4. the ambient projective plane and the unordered pair `K`, up to incidence
   isomorphism.

#### Proof

The pair-minimal-nonface graph is the rook graph from Theorem 6.2. Its two
families of maximal `q`-cliques recover the affine lines in the two parallel
classes corresponding to `a` and `b`.

Every remaining affine line contains `q>=3` legal points and no selected
point. Its collinear triples are precisely the three-element minimal
nonfaces containing no forbidden pair. Taking maximal subsets for which
every three-subset is such a minimal nonface recovers all remaining affine
lines. Disjointness recovers their parallel classes.

The projective completion of an affine plane is canonical: add one point for
each parallel class and one line through the added points. The two pair-edge
classes identify the added points `a,b`. `square`

This exactly repairs the graph obstruction: all planes of order `q` have the
same two-point continuation graph, but their continuation complexes recover
their affine and projective incidence structures.

### Theorem 8.3 — profiled arrangement-completion lemma [PROVED]

Let `D` be an arrangement of `r` lines in a projective plane `Pi` of order
`q`, put

```text
U=Pi minus union D,
```

and retain the traces on `U` of every line outside `D`. Define

```text
a=max_(ell notin D) |ell intersect union D|,

delta=max_(P in union D) |{D in D:P in D}|.
```

If

```text
q+1-delta>=a^2-a+2,

q+1>=delta^2-delta+2,                              (8.2)
```

then this trace incidence structure canonically reconstructs `Pi` and the
deleted arrangement `D`.

#### Proof: deleted points

Form the disjointness graph on the retained line traces. For every deleted
point `P in union D`, the retained lines through `P` form a clique

```text
C_P,                 |C_P|=q+1-d_P>=q+1-delta,
```

where `d_P` is the number of deleted lines through `P`.

Conversely, let `C` be any clique of disjoint retained traces. For each
corresponding ambient line `ell`, put

```text
A_ell=ell intersect union D.
```

This set has at most `a` points. For two members `ell,m` of the clique,
their traces are disjoint exactly because their unique ambient intersection
is deleted, so

```text
|A_ell intersect A_m|=1.
```

Pad every `A_ell` to size `a` using private symbols. Deza's weak-Delta-system
theorem says that a pairwise-one-intersecting family of at least

```text
a^2-a+2
```

`a`-sets has one common element. The first condition in (8.2) therefore
makes the deleted points exactly the maximal disjoint-trace cliques of at
least this size. Membership in those cliques recovers their incidence with
every retained line.

#### Proof: deleted lines

On the reconstructed deleted points, join `P,Q` when no retained line
contains both. Their unique ambient join is then a deleted line, and the
converse is immediate.

For a deleted point `P`, let

```text
B_P={D in D:P in D}.
```

Inside a clique of the new graph, the sets `B_P` have size at most `delta`
and
pairwise intersection exactly one. Pad with private symbols and apply Deza
again. Every clique of size at least `delta^2-delta+2` has a common deleted
line. The second condition in (8.2) ensures that each actual deleted line,
with `q+1` reconstructed points, is such a large clique. The deleted lines
are therefore precisely the maximal large cliques.

We have recovered all points, all retained and deleted lines, and every
incidence between them. This reconstructs `Pi` and `D`. `square`

Since `a,delta<=r`, the simpler condition `q>=r^2+1` is always sufficient.
The profile form is stronger when the deleted arrangement has controlled
concurrence.

### Theorem 8.4 — full continuation-complex reconstruction [PROVED]

Let `K` be a `k`-arc, `k>=3`, in an arbitrary projective plane `Pi` of
order `q`, and put

```text
r=C(k,2),
a_K=max_(ell notin the secant arrangement)
        |ell intersect union{ab:a,b in K, a!=b}|.
```

The secant arrangement satisfies

```text
delta=k-1,                    a=a_K<=r.
```

Indeed, the selected arc points have multiplicity `k-1`, while every other
point lies on at most `floor(k/2)` secants. If

```text
q>=max{a_K^2-a_K+k,
       k^2-3k+3,
       a_K+k^2-k+1},                                (8.3)
```

then the abstract continuation complex `Delta_K` canonically reconstructs:

1. the complete incidence plane `Pi`;
2. the arrangement of the `r` secants of `K`; and
3. the selected arc `K`.

Consequently, every abstract isomorphism

```text
Delta_K isomorphic to Delta_J
```

extends uniquely to an incidence isomorphism `(Pi,K) isomorphic to
(Pi',J)`. For Desarguesian planes, that extension is semilinear.

Using only `a_K<=r` recovers a coarser configuration-free bound. The
profiled form (8.3) can be substantially smaller when the actual secant
arrangement has many collisions. It can be sharpened further by replacing
the third occurrence of `a_K` with the maximum deleted-point count on
tangent lines only.

#### Proof

Proposition 8.1 recovers the compatible pairs and their collinear
three-element minimal nonfaces. For a compatible pair `x,y`, its external
line trace is exactly

```text
L(x,y)={x,y} union
       {z:{x,y,z} is a three-element minimal nonface}.
```

An external line loses precisely its intersection with the secant union, so

```text
|L(x,y)|>=q+1-a_K>=3.
```

Thus all external-line traces are visible and recovered.

For tangent traces, use the representation `S_x` from Proposition 3.1.
Deza's theorem shows that a pair-nonface clique of at least

```text
k^2-k+2
```

vertices has one common tangent symbol. Every tangent contains at least

```text
q+1-a_K
```

legal points, and the third term in (8.3) makes this at least
`k^2-k+2`. Hence the maximal
large pair-nonface cliques recover all tangent traces. Together with the
external traces, these are exactly the traces of every line outside the
secant arrangement.

The displayed bound implies both profile inequalities in Theorem 8.3, so
apply that theorem to reconstruct `Pi` and its `r` secant lines. It remains
to identify `K`. Every `t in K` lies on exactly `k-1` of those secants. If
`P notin K`, then the secants through `P` use pairwise disjoint pairs of
endpoints: two sharing an endpoint would intersect at that endpoint and at
`P`. Therefore

```text
deg_D(P)<=floor(k/2)<k-1.
```

It follows that

```text
K={P:deg_D(P)=k-1}.                                (8.4)
```

Every reconstruction step is intrinsic, proving the extension and
uniqueness statements. `square`

The first explicit thresholds are

| arc size `k` | deleted secants `r` | sufficient order |
|---:|---:|---:|
| 3 | 3 | `q>=9` |
| 4 | 6 | `q>=34` |
| 5 | 10 | `q>=95` |
| 8 | 28 | `q>=764` |

These are method bounds, not expected sharp. Their significance is the
uniform reconstruction theorem, not the numerical constants.

### 8.5 Prior-art boundary: Bruck, Metsch, and pseudo-complements

The reconstruction theorem must not be advertised as the first theorem
about completing a projective plane after lines or points have been removed.
There are three distinct layers, with different novelty status.

**Bruck nets are adjacent but not the same object.** A net of order `q` has
`q^2` points and several complete parallel classes; completing it adds missing
parallel classes while retaining all points. Bruck's
[finite-net completion theorem](https://doi.org/10.2140/PJM.1963.13.421),
and Metsch's later cubic improvement, give unique affine completions under
small-deficiency hypotheses. In contrast, Theorem 8.3 deletes the entire
union of an arrangement of projective lines, its retained line traces have
varying sizes, and completion restores both points and lines. Except for the
single-line affine case, the net theorems do not apply directly. Their
clique-and-claw philosophy is nevertheless an important methodological
precedent for the Deza reconstruction above.

**Long-line finite linear spaces are the genuine overlap.** The retained
trace structure in Theorem 8.3 is an abstract finite linear space: every two
surviving points have one retained joining line, every surviving point has
degree `q+1`, and every retained line has at least `q+1-a` points.
Beutelspacher and Metsch proved that regular finite linear spaces of degree
`q+1` with sufficiently long lines embed in a projective plane of order `q`;
see
[Embedding Finite Linear Spaces in Projective Planes](https://doi.org/10.1016/S0304-0208(08)73124-4)
and the
[1987 sequel](https://doi.org/10.1016/0012-365X(87)90098-7).
Their result starts from an arbitrary intrinsic linear space and supplies an
embedding under a general large-line bound. Here existence is promised from
the start, while (8.2) supplies an explicit quadratic, two-profile
reconstruction: erased points, deleted lines, and their singular incidence
lattice are all intrinsically identified. A full-text audit of Metsch's
uniqueness chapter is still required before claiming that canonical recovery
or automorphism lifting is new under his stronger general bound.

**Small arrangements have direct prior art.** Batten's
[complement-of-two-lines theorem](https://doi.org/10.1017/S1446788700034595)
already gives unique embedding in the relevant two-line regime, and its
references include affine complements of three intersecting lines, complete
triangles, and pseudo-complements of quadrilaterals. Thus the `r=2` instance
of Theorem 8.3 is at most a new short proof, while fixed `r=3,4` claims carry
high prior-art risk.

The defensible candidate novelty is therefore the following chain:

1. recover the retained trace linear space intrinsically from the binary and
   ternary minimal nonfaces of `Delta_K`;
2. recover an arbitrary deleted arrangement under the profile conditions
   `(a,delta)`, with an explicit canonical procedure and quadratic bound;
3. exploit the secant arrangement to recover the arc by (8.4), yielding the
   full-faithfulness statement of Theorem 8.4.

The first and third steps are not statements in the Bruck--Metsch embedding
theorems. The second is a structured promised-input refinement in their
research neighborhood, not a wholly new completion paradigm. Publication
claims should be centered on the complete chain, and on any improvement or
sharpness result for the profile bound, rather than on projective completion
alone.

### Arrangement-complement sharpening problem [OPEN]

For `k>=2`,

```text
V_K = PG(2,q) minus union {ab : a,b in K}.          (8.5)
```

An ambient line avoiding `K` retains at least

```text
q+1-C(k,2)
```

legal points, while a tangent retains at least
`q-C(k-1,2)`. Theorem 8.4 proves unique completion with the explicit
profile-sensitive threshold `q>=r^2-r+k`. The remaining problem is to exploit
the special secant arrangement of an arc to reduce this threshold, classify
small-order exceptions, and determine its correct order of growth.

## 9. Matroid, coding, and other geometry translations

### 9.1 Matroid extensions

For `k>=2`, every individual legal point gives the same abstract rank-three
restriction `U_(3,k+1)`. Thus abstract single-element extension theory cannot
locate continuation points within a representation. Crapo's classical
theorem characterizes single-element matroid extensions by modular cuts; see
[Single-element extensions of matroids](https://commons.wikimedia.org/wiki/File:Single-element_extensions_of_matroids_(IA_jresv69Bn1-2p55).pdf).

The continuation graph adds representation-sensitive two-extension data:

```text
x ~_K y
  iff {t,x,y} is a circuit for some t in K.
```

The full continuation complex additionally records the three-circuits lying
entirely among continuation points. A worthwhile matroid theorem would have
to exploit this multi-extension compatibility, not merely rename modular
cuts.

### 9.2 Nonlinear-code isometries

After centre recovery, `G_K` determines the coordinate fibres of the code
(3.3). The semilinear-extension question becomes:

> When does every isometry of the distance-`(k-1)` graph of this special
> nonlinear, nearly Singleton-sized code extend to coordinate and symbol
> permutations arising from `PGammaL(3,q)`?

This is adjacent to MDS extension theory but outside the hypotheses of the
standard linear and additive theorems. The four-frame equations (7.2) are a
more productive starting point than invoking MacWilliams abstractly.

### 9.3 Polar spaces and generalized polygons

Theorem 2.1 applies verbatim to the point-line geometries of polar spaces and
generalized polygons. Insert the appropriate number of singular lines
through a point and bound the selected secants meeting a tangent singular
line. This can reconstruct a selected cap from an embedded continuation
graph. Intrinsic centre recovery needs a new idea because singular lines may
be disjoint even when their centres differ.

### 9.4 Higher capacities and higher links

For a line-capacity game allowing at most `d` selected points per line, the
pair-conflict graph sees lines already containing `d-1` selected points. It
therefore reconstructs near-saturated lines rather than individual centres.
The natural general object is the graded continuation complex, or the links
of the forbidden-set hypergraph in several dimensions. A useful theorem must
state which skeleton suffices to recover the selected set; merely defining
the higher link is not progress.

## 10. New extremal parameters

The proofs isolate two concrete projective extremal problems.

Define

```text
m(k)=max |C|,
```

where the maximum ranges over all continuation-graph cliques of all
`k`-arcs that are not contained in one tangent trace. Lemma 4.1 gives

```text
m(k)<=k(k-2)+1.                                    (10.1)
```

Likewise, let `r(k)` be the maximum size of a disjointness clique of tangent
traces using at least two selected centres. Theorem 5.1 gives

```text
r(k)<=k C(k-2,2).                                  (10.2)
```

Natural targets are:

1. determine either parameter exactly for an infinite set of `k`;
2. prove `m(k)=O(k)` or `r(k)=O(k^2)` using projective incidence;
3. classify equality or near-equality configurations; and
4. translate improved bounds directly into intrinsic reconstruction
   thresholds.

A sharp result here could itself support a short graph/finite-geometry paper.
Without sharpness, (10.1)–(10.2) are useful middle lemmas rather than
headlines.

## 11. Realistic interest, use, and citability

The current components have different external prospects.

| component | likely role | likely external value |
|---|---|---|
| Embedded support-degree identity | companion infrastructure | useful for symmetry audits, low standalone citability |
| Partial-linear-space and higher-dimensional bounds | generality section | broad applicability, but elementary |
| Intrinsic tangent-trace recovery | first genuinely new-looking theorem | moderate finite-geometry/graph-theory interest |
| Intrinsic centre recovery | stronger middle theorem | useful if thresholds are improved or shown sharp |
| Rook and multiplicative obstructions | essential scope classification | memorable examples, companion results |
| Four-frame functional equations | principal research target | high specialist interest if completely classified |
| Full-complex reconstruction | broadest route | potentially highest citability through incidence reconstruction |

As it stands, the embedded theorem alone should remain a proposition in the
broader arc-extension/reconstruction package. The trace and centre theorems,
together with exact low-`k` obstructions, plausibly support a specialist
short note after a serious prior-art check, but the loose thresholds make the
case borderline.

A standalone continuation-rigidity paper becomes substantially stronger if
one of the following lands:

1. every four-frame graph automorphism is classified, with a semilinear
   theorem and explicit small-field exceptions;
2. `m(k)` or `r(k)` is determined sharply or given nontrivial asymptotics;
3. continuation complexes uniquely reconstruct complements of bounded
   secant arrangements; or
4. the special nonlinear-code isometry problem is solved for an infinite
   arc family.

The likely users are:

- finite geometers classifying arcs and their stabilizers;
- coding theorists studying nonlinear near-MDS codes and isometry extension;
- graph theorists studying representations of graphs as line graphs of
  uniform linear hypergraphs;
- computational geometers using graph canonization to prune arc orbit
  searches; and
- game-certification work that must prove a residual symmetry really
  stabilizes the selected configuration.

The cap-game origin is unlikely to drive citations. The work should be
presented in the established languages of arc reconstruction, punctured
incidence geometry, hypergraph line graphs, and code automorphisms.

## 12. Recommended next gates

### Route A — four-frame automorphisms [FIRST]

1. Compute `Aut(G_K)` and the induced frame stabilizer for
   `q=5,7,9,11,13`, freezing the graph definition before inspecting groups.
2. Record whether tangent traces and centre classes are unique even below
   the uniform bounds.
3. If the ambient group survives, prove the restricted isotopy equations
   (7.2) force a common field automorphism.
4. If it fails, classify the extra generators and test whether adding the
   three-element continuation data removes them.

Success is a complete automorphism-group theorem with explicit small-order
exceptions. Failure is an infinite nonambient family, which is itself a
useful obstruction theorem and redirects funding to Route B.

### Route B — full-complex completion [SECOND]

1. Formalize the line traces recovered from pair and triple minimal
   nonfaces.
2. Prove or refute unique completion for complements of the secant
   arrangements of four- and five-arcs.
3. Test nonisomorphic order-nine planes: the two-point graph must collide,
   while Theorem 8.2 predicts their full complexes do not.
4. Generalize only after the bounded-arrangement completion lemma is clear.

### Route C — sharp extremal thresholds [FALLBACK]

Determine `m(k)` first for `k=4,5,6` and classify extremal mixed cliques.
Proceed to `r(k)` only if the resulting improvement materially lowers the
centre-recovery threshold.

### Scope audit

- Do not describe an ambient-collineation theorem as abstract graph
  reconstruction.
- Do not infer semilinearity from MacWilliams without linear or additive
  hypotheses.
- Do not extrapolate the plane disjointness argument to dimensions with
  skew lines.
- Do not infer strategy value from reconstructed legality.
- Do not call the closure or support-degree formalism a headline without a
  sharp family, asymptotic theorem, or semilinear-extension result.
