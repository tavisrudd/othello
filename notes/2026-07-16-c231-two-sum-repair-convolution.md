# C231 exact 2-sum repair convolution

**Lane:** `rp-next`
**Status:** COMPLETE. Radius-truncated Horn closure composes exactly across a matroid 2-sum through
one scalar locality-budget message per side and round; arrival times obey a budget-indexed
min--max convolution. A represented three-round relay proves that the interface law is operational,
not merely a restatement of direct-sum independence.

## Result

Let `M_1` and `M_2` have ground sets meeting in the single element `p`, with `p` neither a loop nor
a coloop, and let

```text
N = M_1 direct_sum_2 M_2
```

on `E'_1 disjoint_union E'_2`, where `E'_i=E(M_i)\{p}`. The standard 2-sum circuit theorem says
that the circuits of `N` are:

1. circuits of either `M_i` avoiding `p`; and
2. `(C_1 union C_2)\{p}` for circuits `C_i` of `M_i` containing `p`.

The second class is where locality budgets couple.

### Proposition 1 — the interface passes one scalar budget message

For an active set `A_i subseteq E'_i` and a target `e in E'_i\A_i`, define

```text
iota_(i,e)(A_i)
  = min { |C|-1 : C circuit of M_i, p notin C,
                  e in C, C\{e} subseteq A_i },

alpha_(i,e)(A_i)
  = min { |C|-2 : C circuit of M_i, p,e in C,
                  C\{p,e} subseteq A_i },

beta_i(A_i)
  = min { |C|-1 : C circuit of M_i, p in C,
                  C\{p} subseteq A_i },
```

with an empty minimum equal to infinity. Here `iota` is the cheapest internal repair,
`alpha` is the same-side cost of a repair assisted by the virtual interface coordinate, and `beta`
is the cheapest currently available certificate for that virtual coordinate.

For `A=A_1 union A_2`, one radius-`r` parallel round in `N` is exactly

```text
P_r^N(A) intersect E'_i
  = A_i union {
      e : iota_(i,e)(A_i) <= r
          or alpha_(i,e)(A_i) + beta_j(A_j) <= r
    },                                      {i,j}={1,2}.
```

The proof is the circuit decomposition. An internal circuit uses `|C|-1` helpers. A cross circuit
built from `C_i` and `C_j` uses

```text
(|C_i|-2) + (|C_j|-1)
```

helpers to repair a target in side `i`. The two circuit choices are independent, so minimizing the
sum separates into `alpha_(i,e)+beta_j`.

Thus, after identifying every value above `r` with infinity, the runtime information crossing the
separation is only

```text
beta_i(A_i) in {0,1,...,r,infinity}.
```

The target-specific `alpha` table remains local to its component. This is strictly smaller than
passing the full pointed circuit inventory across the interface.

### Corollary 2 — sequential closure and stopping cores compose

Iterating the coupled operator in Proposition 1 from `(S_1,S_2)` gives exactly the small-circuit
Horn closure `L_r^N(S_1 union S_2)`. No scheduling choice is required: the operator is monotone,
and its least fixed point is the order-independent sequential closure. At the terminal pair
`(A_1^*,A_2^*)`, an element `e in E'_i` lies in the stopping core exactly when

```text
iota_(i,e)(A_i^*) > r
and
alpha_(i,e)(A_i^*) + beta_j(A_j^*) > r.
```

This imports C230's stopping-core semantics into a genuine connected composition. Unlike ordinary
contraction, `beta_j` charges every helper used to synthesize the deleted gluing coordinate, so no
over-budget lifted circuit becomes spuriously local.

### Proposition 3 — arrival times use a budgeted min--max convolution

For a fixed survivor seed, let `tau(e)` be C230's synchronous arrival time. Refine the local
quantities by budget and readiness:

```text
I_(i,e)
  = min over internal circuits C with |C|-1<=r
      max_(u in C\{e}) tau(u),

A_(i,e)(s)
  = min over p,e-circuits C with |C|-2=s
      max_(u in C\{p,e}) tau(u),

B_i(q)
  = min over p-circuits C with |C|-1=q
      max_(u in C\{p}) tau(u).
```

Empty minima are infinity and empty maxima are zero. Then, for `e notin S_i`,

```text
tau(e)
  = 1 + min {
      I_(i,e),
      min_(s+q<=r) max(A_(i,e)(s), B_j(q))
    }.
```

Locality costs add across the 2-sum, while readiness times combine by `max`; the fastest feasible
choice combines by `min`. This is the exact 2-sum counterpart of C230's causal circuit valuation.
For stepwise closure, the scalar `beta_i(A_i)` suffices. The budget-indexed readiness curve is what
packages all arrival times without replaying every round.

## A strict three-round interface relay

Take two copies of the binary matroid represented by

```text
        p a b c d
G = [   1 0 1 0 0
        0 1 1 0 1
        0 0 0 1 1 ].
```

Its circuits are

```text
{p,a,b}, {a,c,d}, {p,b,c,d}.
```

Name the non-interface elements of the second copy `u,v,w,z` in the corresponding order, take the
2-sum along `p`, and set radius `r=3`. From

```text
S = {b,c,d,v,w},
```

parallel forward chaining has exactly these addition layers:

```text
round 1: {a}    via the left internal circuit {a,c,d};
round 2: {u}    via the cross circuit {a,b,u,v};
round 3: {z}    via the right internal circuit {u,w,z}.
```

The cross circuit is the union of `{p,a,b}` and `{p,u,v}` with `p` deleted. In the scalar law,
the left side sends `beta_1=2` after round one, while repairing `u` has assisted same-side cost one;
`1+2=r`. The repaired `u` then unlocks a final internal repair on the right. All eight non-interface
elements are recovered.

This example separates C231 from C230's direct-sum factorization: information genuinely crosses
the separation and increases synchronous repair depth.

## Verification

[`2026-07-16-c231-two-sum-repair-convolution.py`](2026-07-16-c231-two-sum-repair-convolution.py)
implements independent binary rank and circuit enumeration. It constructs 19 simple binary
component representations with a non-coloop interface, forms all 361 ordered represented 2-sums,
and checks every seed at radii one through five: 98,000 seed/radius states and 285,600 nonseed
arrival equations.

For every case it verifies:

- the standard 2-sum circuit formula against circuits enumerated directly from the glued matrix;
- the scalar-message parallel-step identity;
- equality of the iterated coupled operator and direct Horn closure;
- the budgeted min--max arrival-time convolution.

The scout is nonvacuous: it records 2,916, 3,996, and 4,092 one-step cross-interface additions at
radii three, four, and five respectively. It separately checks the strict three-round relay above.
The machine-readable certificate is
[`2026-07-16-c231-two-sum-repair-convolution.json`](2026-07-16-c231-two-sum-repair-convolution.json).

## Prior-art boundary

The circuit description of a 2-sum and the role of 1-, 2-, and 3-sums in matroid decomposition are
classical; no novelty is claimed for them. Seymour's decomposition theorem is the foundational
structural reference:
[Seymour, *Decomposition of regular matroids*](https://doi.org/10.1016/0095-8956(80)90075-1).

Song, Cai, and Yuen define sequential local recovery and prove code-level bounds and constructions,
but do not give a matroid-sum interface calculus or depth convolution:
[arXiv:1610.09767](https://arxiv.org/abs/1610.09767). Berczi, Boros, and Makino develop full
matroid circuit Horn functions, but not radius-truncated circuit systems or locality-budgeted
2-sum composition:
[arXiv:2301.06642](https://arxiv.org/abs/2301.06642).

The cached hashes for the latter two sources are respectively
`6aacd2b590e73c571961d6dd921fae9ad7c2378088cabae1171bbd50668b5a50` and
`a7150e01acd2f4bf86454bdc11bad436f29832d38ea749e95b072b02e7cae0d5`.

The defensible C231 contribution is the synthesis forced by truncation: cross-circuit cardinality
becomes an additive locality budget, terminal closure passes a scalar cheapest-certificate message,
and synchronous depth lifts this to a budget-indexed min--max convolution. This exact interface law
is not present in the focused sources above. No broader priority claim is made.

## Disposition

C231 passes its gate and answers C230's strongest open composition question positively. The next
bounded question is whether these per-round scalar messages admit a finite transfer algebra for the
full seed/core/depth profile on a tree of 2-sums. That requires a congruence scout: component seeds
with the same proposed boundary signature must remain indistinguishable against every bounded test
partner. Without that test, a tree-DP or fixed-parameter claim would be premature.
