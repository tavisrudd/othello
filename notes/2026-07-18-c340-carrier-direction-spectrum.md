# C340: a square-root carrier barrier for constant-height relative-conic arcs

**Lane:** `crowns`

**Date:** 2026-07-19

**Status:** theorem; Stage A complete, Stage B stopped at its application/novelty gate.

## Result

Let `F=GF(Q)` have characteristic two, let `E/F` be quadratic, and write

```text
P(x,k)=[1:x:x^2+k] in PG(2,E).
```

For `i=1,...,m`, choose `a_i,k_i in E` and take the full constant-height
`F`-carrier layer

```text
L_i={P(a_i+r,k_i):r in F}.
```

Assume the `L_i` are distinct, and put `A=union_i L_i`.  Let `D_fin(A)` be the
set of `u in E` for which `[0:1:u]` lies on an `A`-secant.  If

```text
s = sum_C binom(n_C,2),
```

where `n_C` is the number of layers supported on the carrier coset `C in E/F`,
then

```text
|D_fin(A)| <= (Q-1) + (binom(m,2)-s)Q + s(Q-1)
             = (binom(m,2)+1)Q - 1 - s.                 (1)
```

In particular,

```text
|D_fin(A)| <= (binom(m,2)+1)Q - 1.                     (2)
```

Suppose the prescribed conic is the parabola completed by
`C_infinity=[0:0:1]`, and relative completeness requires every other point on
the line at infinity to lie on an `A`-secant.  That line has exactly `Q^2`
nonconic points `[0:1:u]`, so (2) forces

```text
binom(m,2) >= Q,
m >= ceil((1+sqrt(1+8Q))/2).                            (3)
```

Distinct full layers are disjoint, hence `|A|=mQ`.  Therefore every relatively
complete member of this architecture has

```text
|A| >= Q ceil((1+sqrt(1+8Q))/2)
     = (sqrt(2)+o(1))Q^(3/2)
     = (sqrt(2)+o(1))q^(3/4),                           (4)
```

where the ambient plane has order `q=Q^2`.  This is an architecture theorem,
not a lower bound for arbitrary arcs or arbitrary arcs complete outside a
conic.

## Proof

Take points `P(x,k_i)` and `P(y,k_j)` and put `p=x+y`; subtraction and addition
agree in characteristic two.  Their difference vector is

```text
[0:p:p^2+k_i+k_j].                                     (5)
```

If `p!=0`, the secant meets the line at infinity at

```text
[0:1:p+(k_i+k_j)/p].                                   (6)
```

Within any one layer, `p` runs through `F^*` and `k_i+k_i=0`.  Thus every
within-layer secant direction belongs to the same set `F^*`, and together the
`m` within-layer pair types contribute exactly `Q-1` finite directions.

For two layers on different `E/F` carrier cosets, `p` runs through one affine
`F`-coset not containing zero.  Equation (6) therefore supplies at most `Q`
finite directions.  There are `binom(m,2)-s` such layer pairs.

For two distinct layers on the same carrier coset, the heights differ and `p`
runs through `F`.  The value `p=0` gives `[0:0:1]=C_infinity`, while the
remaining values supply at most `Q-1` finite directions.  There are `s` such
pairs.  Taking the union bound over these exhaustive layer-pair types proves
(1) and (2).

Relative completeness requires all `Q^2` finite points of the infinity line,
so

```text
Q^2 <= (Q-1)+binom(m,2)Q.
```

After division by `Q`, the integer `binom(m,2)` is at least
`ceil(Q-1+1/Q)=Q`, which is equivalent to (3).  Distinct layers either have
disjoint `x`-carrier cosets or have the same `x` values and different heights,
so they are disjoint point sets.  This gives (4).

The endpoint `-1-s` is useful: reusing a carrier coset never helps the infinity
count.  No assumption that `A` is an arc is needed for the direction bound;
arc legality only narrows the architecture further.

## Relationship to C330

C330 is the `m=4` instance with one same-carrier pair, namely the two seed
layers, so `s=1`.  Equation (1) gives `7Q-2` exactly: `Q-1` common
within-layer directions, five different-carrier pair images of size at most
`Q`, and one same-carrier pair image of size at most `Q-1`.  Thus C340 both
recovers C330's endpoint and explains it structurally, without using C330's
special height values.  Its new content is that the same exhaustive count works
for arbitrary `m`, constant layer heights, and carrier placement.

The result also sharpens the originally requested asymptotic statement.  The
exact necessary carrier count is (3), not merely `m=Omega(sqrt(Q))`, and the
corresponding leading constant in the size obstruction is `sqrt(2)`.

## Literature and novelty boundary

| Source | Level checked | Boundary relevant to C340 |
|---|---|---|
| Giulietti--Montanucci, [*On Hyperfocused Arcs in PG(2,q)*](https://arxiv.org/abs/math/0601488) | full text; cached as `arXiv:math/0601488`, SHA-256 `feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9` | Translation arcs are hyperfocused because their secants use a minimum linear blocking set; generalized hyperfocused arcs are related to embedded one-factorizations.  This is a few-direction theorem, not a lower bound for covering every nonconic infinity point with a union of carriers. |
| Blokhuis--Ball--Brouwer--Storme--Szonyi, [*On the number of slopes of the graph of a function defined on a finite field*](https://web.mat.upc.edu/simeon.michael.ball/direction.pdf) | full text | Classifies possible numbers of directions of a single `Q`-point graph in `AG(2,Q)` using divisibility and linearity.  C340 instead takes pairwise reciprocal images between `F`-carrier layers in `PG(2,Q^2)` and asks for all `Q^2` required directions. |
| Csajbok, [*On bisecants of Redei type blocking sets and applications*](https://arxiv.org/abs/1504.06748) | full text | Develops structural results for Redei-type blocking sets and reconnects them to the classical direction problem; it does not state the carrier-count coverage bound (1)--(4). |
| Blokhuis--Marino--Mazzocca, [*Generalized hyperfocused arcs in PG(2,p)*](https://doi.org/10.1002/jcd.21371) | publisher abstract and metadata | Classifies prime-plane generalized hyperfocused arcs and relates them to dual `3`-nets.  Its minimum secant-blocker problem is opposite to C340's full infinity-coverage requirement. |
| DeOrsey--Hartke--Williford, [*A Classification of Hyperfocused 12-Arcs*](https://arxiv.org/abs/2105.08300) | full text | Uses embedded one-factorizations to classify the `12`-point hyperfocused case.  It confirms that one-factorization language itself is classical and cannot carry a novelty claim here. |
| Korchmaros--Pace--Sonnino, [*One-factorisations of complete graphs arising from ovals in finite planes*](https://doi.org/10.1016/j.jcta.2018.06.006) | abstract/metadata | Constructs and represents one-factorizations from finite-plane ovals.  It reinforces the same boundary: an algebraic edge-colouring needs a new parameter or theorem beyond its geometric origin. |
| Alon--Gutner, [*Balanced Families of Perfect Hash Functions and Their Applications*](https://arxiv.org/abs/0805.4300) | abstract and theorem statement | Perfect-hash utility is stated through injectivity on every prescribed subset and explicit family size/construction time.  C340 currently has no map from its secant colours to such a guarantee. |

The defensible claim is therefore narrow: equations (1)--(4) are the exact
constant-height carrier obstruction obtained by combining C330's coordinate
identity with exhaustive layer-pair counting.  No claim is made that direction
counting, hyperfocused arcs, embedded one-factorizations, or finite-geometric
secret sharing is new.

## Stage B stop

The proposed seven-map spectrum would colour edges by secant directions, but
proper edge-colouring and geometric one-factorization viewpoints are already
standard in the hyperfocused literature.  The task's application gate requires
an explicit scheduling, hashing, blocking, or secret-sharing parameter.  No
such parameter follows from the current reciprocal-map family, and a colour
count of at most `7Q-2` alone merely restates C330.

Accordingly Stage B stops before a fibre census.  This does not assert that the
seven reciprocal maps have no interesting spectrum; it records that, under the
task's mechanical gate, computing that spectrum would presently be an
ungrounded finite census rather than a crown-scale result.  Stage A passes
independently, exactly as the task card permits.

## Evidence boundary

This is a proof-only result.  Equations (5)--(6), the partition of unordered
layer pairs by carrier coset, and the `Q^2` required infinity points give the
complete argument.  No computation, random sample, generated certificate, or
untracked artifact supports the theorem.  The trusted input is C330's
coordinate model and relative-completeness convention; source-lane files are
consumed read-only.

## Vibe check

Clean and useful rather than spectacular: the four-layer failure is now an
exact all-`m` architecture barrier with the right `q^(3/4)` scale and leading
constant, while the tempting edge-colouring sequel correctly fails its applied
novelty gate before consuming effort.
