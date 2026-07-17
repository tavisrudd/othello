# C233 terminal-closure transfer algebra

**Lane:** `rp-next`
**Status:** COMPLETE. After synchronous arrival times are forgotten, radius-truncated Horn repair on
a tree of matroid 2-sums has a finite structural control alphabet depending only on the radius and
interface width. Exact active and stopping-core counts are separate integer-valued output weights:
they compose by addition at the least boundary fixed point and necessarily have an infinite carrier.

## Result

C232's obstruction is entirely a timing obstruction. Terminal saturation compresses a component to
a monotone map on a fixed finite boundary lattice. These finite control maps determine all contextual
boundary behavior. They do not determine exact counts, but count tables are passive weights: they do
not feed back into the structural fixed point and add exactly across the private ground-set partition.

For fixed radius `r` and interface width `w`, this gives a genuine finite terminal-response algebra,
with at most

```text
sum_(k=0)^w (r+2)^(k (r+2)^k)
```

labeled structural controls of arity at most `w`. This crude bound counts all functions, not only the
monotone realizable ones. There is no corresponding radius/width-only bound on the exact weighted
algebra: C232's binary triangle relays all have the same terminal control from length two onward,
while their active and core weights grow without bound.

## Terminal component control

Fix

```text
Q_r = {0,1,...,r,infinity}
```

with truncated addition. Order it by availability: `a <=_A b` when `b` is no more expensive than
`a`. Thus `infinity` is the least-information element, and improving a certificate moves upward.

Let a represented or abstract matroid component have labeled virtual set `P`, private ground set
`R`, and private seed `S subseteq R`. For `q in Q_r^P` and `A subseteq R`, use C232's one-step map

```text
delta_q(A)
  = A union {
      e in R-A : there is a circuit C containing e,
      (C intersect R)-{e} subseteq A,
      |(C intersect R)-{e}| + sum_(p in C intersect P) q_p <= r
    }.
```

Its terminal local closure is

```text
K(q) = lfp_(A superset S) delta_q(A).
```

For an outgoing port `p`, do not charge the branch beyond `p` to synthesize `p`. Define

```text
F_p(q)
  = min {
      |C intersect R| + sum_(s in (C intersect P)-{p}) q_s :
      C a circuit containing p,
      C intersect R subseteq K(q)
    },
```

truncated to `Q_r`. The input `q_p` may affect `K(q)`: this is essential because private elements
can be repaired from the `p` side and later help a certificate directed back toward `p`. Circular
self-support is still excluded by the least fixed point in the composition theorem below.

The **terminal structural control** and **count weight** are the finite tables

```text
chi_X : q |-> F(q) in Q_r^P,
omega_X : q |-> (|K(q)|, |R-K(q)|) in N^2.
```

Both maps are monotone in boundary availability. The second coordinate of `omega` is the exact
stopping-core count. More precisely, at input `q`, an element `e` lies in the local terminal core
exactly when every circuit `C` containing `e` either contains another private core element or has

```text
|(C intersect R)-{e}| + sum_(p in C intersect P) q_p > r.
```

This is C231's stopping condition with all incident subtree certificates simultaneously present.

### Proposition 1 — radius/width-bounded structural finiteness

For fixed `r` and a fixed labeled port set `P`, terminal contextual boundary behavior has only
finitely many possible controls `chi_X`, independently of `|R|`. If `|P|=k`, their number is at most

```text
|Q_r|^(k |Q_r|^k) = (r+2)^(k (r+2)^k).
```

**Proof.** The domain `Q_r^P` has `(r+2)^k` elements and the codomain `Q_r^P` has
`(r+2)^k` elements. A control is one function between these two finite sets. Monotonicity and
matroid realizability only reduce the count. Summing over `k<=w` gives the displayed width bound.
QED.

The point is not the crude cardinality estimate. Unlike C232's Moore signatures, no iteration
history remains in the state: `K(q)` has already saturated every private Horn implication possible
under the fixed boundary input.

## Exact composition on a 2-sum tree

Let a tree `T` index components `X_v`. Each edge `e=uv` identifies one labeled virtual element in
each endpoint, and distinct incident edges use distinct virtual elements. Write `q_(v,e)` for the
certificate supplied to `v` by the component on the other side of `e`. From the node controls form
the coupled boundary operator

```text
Phi(q)_(v,e) = F_(u,e)(q_u),       e=uv.
```

All coordinates start at `infinity`. Since every `F_v` is monotone on a finite availability lattice,
iteration reaches the least fixed point

```text
q* = lfp Phi.
```

Exposed ports in a larger tree context are simply held at a parameter vector `z`; the same least
fixed point is taken over internal incidences only.

### Theorem 2 — terminal fixed-point and weighted composition law

The global radius-`r` sequential Horn closure of the glued 2-sum tree has private part

```text
L_r^T(S) intersect R_v = K_v(q_v*)
```

at every node. Consequently its exact terminal statistics are

```text
active(T) = sum_v omega_v^active(q_v*),
core(T)   = sum_v omega_v^core(q_v*),
seed(T)   = sum_v |S_v|.
```

The composite response at exposed ports is obtained from the same fixed point. Hence equal controls
are a contextual congruence for terminal boundary behavior, and equal pairs `(chi,omega)` are a
contextual congruence for exact active/core counts.

**Proof.** Consider the fine-grained finite monotone system whose coordinates are all private active
sets and all directed boundary costs. Its rules are

```text
A_v    |-> delta_(q_v)(A_v),
q_(v,e)|-> mu_(u,e)(A_u; q_u away from e).
```

C232's directed-message proposition, which is the iterated standard 2-sum circuit theorem, says
that these are exactly the global Horn rules after every cross-component circuit is decomposed along
its support subtree. Starting from the private seeds and all-infinite messages therefore computes
the global least closure.

Now batch all private rules at a node while holding `q` fixed. Their least fixed point is exactly
`K_v(q_v)`, and the resulting directed outputs are `F_v(q_v)`. Replacing a finite family of monotone
rules by its saturation does not change the least common fixed point: every common fixed point is
closed under the batch, while every batch-fixed point is closed under each rule in the batch. Thus
eliminating the private coordinates leaves precisely `q=Phi(q)`, selected at its least fixed point
from all-infinite input. Restoring the eliminated coordinates gives `A_v=K_v(q_v*)`.

The private sets of distinct nodes are disjoint in a 2-sum, so active, core, and seed cardinalities
add. The fixed point depends only on the controls `chi_v`, never on the weights `omega_v`; contextual
replacement and the exposed-port statement follow from the same equations. QED.

This is an exact algebraic separation:

```text
finite structural control chi
        determines q*
                 |
                 v
integer tables omega --evaluate at q*--> add component weights.
```

It is not a finite alphabet for exact counts. Each `omega` has finite domain but unbounded integer
entries, so the weighted carrier is infinite.

## Triangle relays: timing disappears, weights do not

Replay C232's binary component `F_n` at radius two. Its ports are `p=e_0`, `q=e_n`; its private
columns are

```text
x_i=e_i                         (1 <= i < n),
s_i=e_(i-1)+e_i                 (1 <= i <= n),
```

and all `s_i` are seeded. For every `n>=2`, the terminal structural control is the same map on
`Q_2^2`:

```text
F_n(a,b) = (2,2)          if min(a,b) <= 1,
           (infinity,infinity) otherwise.
```

Indeed, a boundary certificate of cost zero or one starts the adjacent triangle and terminal
saturation walks across the whole path. With neither such input, no `x_i` can start. Once the path
is active, each endpoint has its two-private-helper triangle certificate of cost two. Thus all
response delays `n-1` from C232 collapse to one terminal control.

The weights retain unbounded size information:

```text
omega_n(infinity,infinity) = (n, n-1),
omega_n(1,infinity)        = (2n-1, 0).
```

So one fixed structural class contains arbitrarily large active counts and arbitrarily large
stopping cores. This proves both sides of the boundary sharply: finite control survives, while an
exact finite count alphabet cannot.

## Verification

[`2026-07-16-c233-terminal-closure-transfer.py`](2026-07-16-c233-terminal-closure-transfer.py)
independently checks the definitions over `GF(2)`. Its machine-readable output is
[`2026-07-16-c233-terminal-closure-transfer.json`](2026-07-16-c233-terminal-closure-transfer.json).

The bounded two-port catalog contains 22 simple rank-at-most-three representations, 186 seeded
component states, and radii one through three. Across 558 state/radius cases it enumerates every
boundary input, terminal closure, outgoing response, and active/core weight; checks boundary
monotonicity and the exact stopping-core condition; and finds respectively `3,27,27` distinct
structural controls but `50,46,45` distinct weighted behaviors. At every radius, some one structural
control carries several count tables.

The independent composition catalog uses 19 one-port representations and all 140 component/seed
states. For all 58,800 ordered represented-2-sum seed/radius states, it compares the least boundary
fixed point and summed component weight against direct circuit enumeration in the glued binary
representation. Every active count agrees; nontrivial boundary feedback takes up to two macro
iterations.

Finally, for every `2<=n<=32`, the verifier constructs the triangle circuit system and checks the
closed formulas above. All 31 relays have one structural control and 31 distinct integer weight
tables, reaching a 63-private-column component with unavailable-boundary weights `(32,31)`.

## Boundary and disposition

C233 answers the terminal question positively and isolates exactly what is finite. The result is a
finite **structural** algebra for boundary closure, extended by explicitly infinite integer output
weights. It neither reintroduces arrival times nor gives a finite exact-count alphabet.

No tree-DP or FPT runtime claim is made. The theorem is a semantic composition result; an algorithmic
bound would still need an explicit representation for realizable controls, construction costs, and
decomposition input model. C234 may now restore synchronous depth honestly by moving to an
infinite-carrier delay algebra rather than treating the triangle family as finite-state.
