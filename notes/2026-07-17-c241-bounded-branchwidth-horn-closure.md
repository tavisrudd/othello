# C241 — bounded-branchwidth terminal Horn closure

**Lane:** `rp-next`  
**Status:** COMPLETE. Truncated separator-vector response maps are contextually sufficient and
compose by a finite least-feedback rule. From a supplied width-bounded branch decomposition this
gives an explicit `f(r,w,q) poly(n)` algorithm for radius-`r` terminal Horn closure, its stopping
core, and their exact counts. Synchronous depth remains on C234's infinite expression carrier.

## Result

Let a `GF(q)`-represented matroid have a disjoint ground-set cut `E=X disjoint_union Y`, and put

```text
U_X = span(X),   U_Y = span(Y),   B = U_X intersect U_Y.
```

For a branch decomposition whose width convention is `dim B <= w`, the boundary has at most
`q^w` vectors. (If branch-width is defined as `lambda+1`, replace `w` below by `w-1`.) At fixed
radius `r`, write

```text
Q_r = {0,1,...,r,infinity}
P(B) = { d : B -> Q_r : d(0)=0 }.
```

Values larger than `r` are identified with `infinity`, and addition is truncated. A profile `d`
means that the context can synthesize boundary vector `b` using `d(b)` currently active helpers.
Profiles supplied by actual represented contexts obey extra scaling and subadditivity constraints,
but allowing every normalized function in `P(B)` gives a simpler closed finite carrier.

For a component `X`, private seed `S subseteq X`, and input `d in P(B)`, saturate the following
rule from `A=S`:

```text
e enters A iff
  min_(b in B) [ kappa_(A,e)(b) + d(b) ] <= r,

kappa_(A,e)(b)
  = minimum support size of coefficients on A whose sum is e-b.
```

Call the least fixed point `K_X(d)`. Its outgoing profile is

```text
R_X(d)(b) = minimum support size on K_X(d) whose sum is b,
```

again truncated to `Q_r`. The **terminal response map** is the finite table

```text
chi_X : d |-> R_X(d),                d in P(B),
```

and its passive weight table is

```text
omega_X(d) = (|K_X(d)|, |X-K_X(d)|).
```

The second coordinate is the exact local stopping-core size. The seed count `|S|` is stored once.

## Separator theorem

### Lemma 1 — exact pointwise separator convolution

For active sets `A_X subseteq X`, `A_Y subseteq Y`, and target `e in X`, the minimum number of
helpers in `A_X union A_Y` spanning `e` is

```text
min_(b in B) [ kappa_(A_X,e)(b) + c_(A_Y)(b) ],
```

where `c_(A_Y)(b)` is the minimum support size on `A_Y` spanning `b`.

**Proof.** If `e=a_X+a_Y`, then `a_Y=e-a_X` lies both in `U_Y` and in `U_X`, hence in `B`; the
support splits across the disjoint ground-set sides and gives the lower bound. Conversely, local
representations of `e-b` and `b` concatenate to a representation of `e`, giving the upper bound.
The usual small-circuit Horn rule is equivalent to this spanning rule: whenever `e` is spanned by
at most `r` helpers, a minimal subset contains a circuit through `e` of size at most `r+1`. QED.

This proof works over every finite field and needs neither binary symmetric difference nor a
one-dimensional gluing element.

### Theorem 2 — contextual sufficiency

If two seeded components have the same terminal response map `chi`, then substituting one for the
other in any represented context with the same labeled boundary preserves the context's terminal
boundary response and every context-private terminal active/core decision. If their weight tables
also agree, exact total active/core counts are preserved.

**Proof.** Expand component and context closure into the finite monotone system whose coordinates
are private active sets and the two directed boundary-cost profiles. Lemma 1 says these are exactly
the global Horn rules. For any fixed incoming profile, replace all private component rules by their
least saturation; the resulting batch is precisely `chi_X`. Batching a subset of monotone rules
does not change their least common fixed point: every common fixed point is batch-closed, and every
batch-fixed point is closed under each rule in the batch. Eliminating the component's private
coordinates therefore leaves the same boundary fixed-point equation whenever `chi` is the same.
Context-private decisions depend only on that equation. Private ground sets are disjoint, so the
weights add after the structural fixed point and cannot feed back into it. QED.

This passes C241's first gate: the proposed pointwise map is a contextual congruence, rather than
merely an empirical signature.

## Finite composition at a branch node

At a rooted binary branch node let the child parts be `X,Y`, the outside part be `O`, and write

```text
B_X = span(X) intersect span(Y union O),
B_Y = span(Y) intersect span(X union O),
B_Z = span(X union Y) intersect span(O).
```

The representation determines finite incidence relations

```text
Lambda_X = { (x,y,z) in B_X x B_Y x B_Z : x=y+z },
Lambda_Y = { (y,x,z) in B_Y x B_X x B_Z : y=x+z },
Lambda_Z = { (z,x,y) in B_Z x B_X x B_Y : z=x+y }.
```

For profiles `a,b`, let `a star_Lambda b` take the minimum truncated sum over the corresponding
relation. Given outside input `d in P(B_Z)`, start both child outputs at the unavailable profile
`bot(0)=0`, `bot(v)=infinity` for `v!=0`, and iterate

```text
p_X <- chi_X(p_Y star_(Lambda_X) d),
p_Y <- chi_Y(p_X star_(Lambda_Y) d)
```

simultaneously to the least fixed point. Then

```text
chi_Z(d) = p_X star_(Lambda_Z) p_Y,

omega_Z(d)
  = omega_X(p_Y star_(Lambda_X) d)
  + omega_Y(p_X star_(Lambda_Y) d).
```

### Theorem 3 — exact finite composition

These equations equal the response and weights obtained by directly saturating `X union Y` under
`d`.

**Proof.** Lemma 1 gives each child input convolution and the parent output convolution. The only
remaining issue is circular support: a child output may have used an element enabled by the other
child. Starting from `bot` and selecting the least fixed point is exactly forward Horn chaining and
admits no unsupported cycle. As in Theorem 2, saturating a child's internal rules before the next
boundary update is a monotone batching operation and preserves the global least fixed point.
Disjointness gives the weight sum. QED.

Composition is associative up to relabeling because either parenthesization is rule batching inside
the same global least fixed point. This is semantic associativity; no claim is made that arbitrary
table encodings have identical byte layouts.

## State bound and algorithm

If `k=dim B<=w`, then

```text
m_k := |P(B)| = (r+2)^(q^k-1).
```

Hence the number of labeled structural response maps at a `k`-boundary is at most

```text
m_k^m_k = (r+2)^((q^k-1) (r+2)^(q^k-1)).
```

This intentionally crude bound counts nonmonotone and unrealizable maps. Scaling invariance could
replace nonzero vectors by projective points, but is unnecessary for fixed-parameter finiteness.
Weight entries are integers in `[0,n]`; as in C233, exact weights form an infinite family across
all input sizes even though each table has finite domain.

Given the representation, seed set `S`, and a width-`w` branch decomposition:

1. root and binarize the decomposition and compute every boundary subspace by Gaussian elimination;
2. build each seeded leaf response table by enumerating its at most `m_w` inputs;
3. at each internal node, precompute the three `Lambda` relations and apply Theorem 3 for every
   parent input profile;
4. at the root, whose boundary is zero-dimensional, read off the unique active/core weights;
5. retain the chosen fixed-point transitions and leaf outcomes as backpointers to output the actual
   terminal closure and stopping-core sets, not just their sizes.

Each feedback iteration strictly improves a coordinate of one of two profiles unless fixed. There
are at most `2 q^w (r+1)+1` iterations. A naive relation convolution costs at most `q^(3w)` field
table operations. Thus the complete computation has time

```text
f(r,w,q) n^O(1)
```

and `f(r,w,q) n^O(1)` space with explicit computable `f`; after the supplied decomposition and
boundary bases are normalized, the response-table pass is linear in the number of tree nodes times
that parameter function. This computes the closure for one supplied seed set and its
`(|S|,|closure|,|core|)` profile. It does not enumerate all `2^n` seed sets.

## Deterministic verification beyond one-element gluing

[`2026-07-17-c241-bounded-branchwidth-horn-closure.py`](2026-07-17-c241-bounded-branchwidth-horn-closure.py)
implements independent finite-field support minimization, direct Horn saturation, terminal response
tables, and least-feedback composition. Its machine-readable output is
[`2026-07-17-c241-bounded-branchwidth-horn-closure.json`](2026-07-17-c241-bounded-branchwidth-horn-closure.json).

The components are three disjoint triples whose pairwise spans meet in a genuine two-dimensional
separator. At radius two the verifier checks:

- over `GF(2)`, all 64 normalized truncated input profiles and every seed on two children: 4,096
  direct-versus-composed response/active-set comparisons;
- over `GF(3)`, all eight profiles realized by the third component plus three deterministic
  abstract profiles, across every two-child seed: 512 comparisons;
- over each field, every one of the 512 seeds on the full three-component context against direct
  global saturation.

All 5,632 comparisons pass; nontrivial boundary feedback takes at most two macro iterations. The
binary test is exhaustive over the entire proposed abstract input alphabet, not only over profiles
realized by a small catalog.

## Prior-art and claim boundary

Hliněný's bounded-branchwidth parse-tree work already gives finite tree automata for MSO-definable
properties of finite-field represented matroids
([JCTB 96 (2006), 325--351](https://doi.org/10.1016/j.jctb.2005.08.005)), and his Tutte-polynomial
paper gives an explicit recursive parse-tree computation
([CPC 15 (2006), 397--409](https://doi.org/10.1017/S0963548305007297)). Terminal membership can in
principle be phrased in MSO by quantifying over every radius-`r` Horn-closed superset of the seed.
Accordingly, C241 does **not** claim the first generic FPT consequence of bounded branchwidth.

The contribution here is the repair-specific algebra the generic theorem does not expose: the
exact separator quantity is truncated support cost for every boundary vector; its composition is
the displayed min-sum convolution plus least feedback; contextual equivalence has a direct proof;
and closure/core witnesses and exact weights follow in the same pass. This is also different from
the Tutte parse-tree state, which tracks rank-polynomial data rather than a seeded Horn least fixed
point.

Decomposition construction is outside the theorem because C241 takes the decomposition as input.
Jeong--Kim--Oum give a direct FPT construction for finite-field subspace branch decompositions
([arXiv:1711.01381](https://arxiv.org/abs/1711.01381)). Choi--Korhonen--Oum now give
`O_(k,F)(n^2)+O(n^omega)` exact construction, quadratic when the representation is already in
standard form ([arXiv:2605.14428](https://arxiv.org/abs/2605.14428)). Combining either constructor
with C241 is valid, but is not counted as a new decomposition algorithm.

Finally, the finite table records only terminal availability. C232's triangle relays have identical
terminal controls and unbounded distinct delays, so synchronous depth cannot be added to this finite
state. Exact timing remains on C234's explicitly infinite bottleneck-delay expression carrier.

## Disposition

C241 passes both gates: contextual sufficiency is proved before the tree DP, and the full result has
an exact separator theorem, finite composition law, explicit state bound, bounded-branchwidth
algorithm, prior-art boundary, and deterministic width-two verification over two fields.
