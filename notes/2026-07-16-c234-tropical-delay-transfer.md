# C234 infinite-carrier bottleneck-delay transfer

**Lane:** `rp-next`
**Status:** COMPLETE. Exact synchronous Horn depth on a tree of matroid 2-sums has a finite
recursive presentation over an explicitly infinite carrier of budget-indexed arrival profiles.
Choice is pointwise `min`, simultaneous readiness is a budgeted `max` convolution, one Horn round
is a unit delay, and tree feedback is the least-information fixed point. The presentation composes
associatively. A represented four-port binary center gives the genuinely branching law
`tau(y)=min(max(n,m),ell)`.

## Result

C232's infinite family is not an obstruction to finite **syntax**. It is an obstruction only to a
finite carrier. For fixed locality radius `r`, put

```text
D_r = {d : {0,...,r} -> N union {infinity} : d(k+1) <= d(k)}.
```

The meaning of `d(k)` is the earliest synchronous time at which a certificate using at most `k`
helpers is ready. Define

```text
(d plus e)(k) = min(d(k),e(k)),

(d times e)(k)
  = min_(i+j<=k) max(d(i),e(j)),

Z(d)(k) = d(k)+1,
```

where `infinity+1=infinity`. The zero profile is constantly `infinity`; the unit profile is
constantly zero. For a private helper ready at time `t`, write

```text
X_t(0)=infinity,        X_t(k)=t for k>=1.
```

Thus `plus` chooses the first available certificate, `times` adds locality costs while waiting for
all factors, and `Z` advances one parallel Horn round.

### Proposition 1 — the delay profiles form an idempotent bottleneck dioid

`(D_r, plus, times, zero, one)` is a commutative idempotent semiring, and `Z` is a monotone unary
operation.

**Proof.** Pointwise `min` gives the commutative idempotent addition. For three profiles,

```text
((d times e) times f)(k)
  = min_(i+j+h<=k) max(d(i),e(j),f(h))
  = (d times (e times f))(k),
```

so `times` is associative; symmetry gives commutativity. The constant-zero profile is its unit
because profiles are nonincreasing in the budget. Distributivity follows from

```text
max(a,min(b,c)) = min(max(a,b),max(a,c))
```

in the total order on arrival times, followed by minimization over budget splits. The all-infinite
profile is absorbing. Monotonicity of `Z` is immediate. QED.

This is tropical in the idempotent-semiring sense but is not the ordinary min-plus or max-plus
semiring: readiness uses `max`, while the independent locality resource is convolved additively.
“Budgeted bottleneck dioid” is therefore the precise name used here.

## Finite component syntax

Let a component have private elements `R`, labeled virtual elements `P`, and private seed `S`.
Give every incoming port `p` a delay profile `d_p`. For tentative private arrival times `t_u`, a
circuit `C` gives a private target `e` the certificate profile

```text
H_(C,e)
  = product_(u in (C intersect R)-{e}) X_(t_u)
    times product_(p in C intersect P) d_p.
```

Its local equations are

```text
t_e = 0                                                   if e in S,

t_e = 1 + min_(C circuit, e in C) H_(C,e)(r)             otherwise,

D_p = plus_(C circuit, p in C)
        ( product_(u in C intersect R) X_(t_u)
          times product_(q in (C intersect P)-{p}) d_q ).
```

Take the least-information solution: initialize every nonseed time and every unavailable profile
at `infinity`, then admit only improvements justified by the equations. The output `D_p` may depend
indirectly on `d_p`, because elements repaired earlier from the `p` side may later help a
certificate directed back toward `p`. Least fixed-point semantics excludes circular self-support.

Only circuits with at most `r` private helpers can contribute. With an explicit list of those
circuits, the displayed system is finite. It uses constants, `plus`, `times`, `Z`, evaluation at
`r`, and one least-fixed-point binder; its syntax size is linear in the total listed circuit-helper
incidence.

### Theorem 2 — exact and associative tree composition

For a tree of 2-sum components, wire the output profile at each end of an edge to the incoming
profile at the other end and take the least-information fixed point of all component equations.
Then:

1. every private `t_e` is exactly its global synchronous radius-`r` Horn arrival time;
2. every exposed `D_p(k)` is exactly the earliest time a size-at-most-`k` certificate for that port
   is ready; and
3. the composite is independent of the order in which subtrees are bracketed or eliminated.

**Proof.** At time zero, precisely the seeds have finite atomic profiles. Assume the statement
through time `h`. By the standard circuit theorem for a 2-sum, every global circuit is either local
or is obtained by joining interface-containing component circuits along the edges of its support
subtree. Its helper count is the sum of the local and branch helper counts, and its readiness time
is the maximum of their readiness times. Minimizing over budget splits is exactly `times`, and
minimizing over circuit choices is exactly `plus`. Applying `Z` to a private target makes it arrive
in round `h+1`. Conversely, every finite expression chooses local circuits and branch certificates;
joining them along their support subtree gives a global circuit with the asserted cost. This proves
exactness by induction on `h`.

All equations are monotone in the availability order. Any parenthesized composition merely
eliminates a subset of variables from the same finite recursive system. The least fixed point of a
block system projects to the nested least fixed points obtained by eliminating either block first:
each nested solution is a fixed point of the full system, and minimality in the two blocks gives
both inequalities. Hence composition is associative. QED.

The carrier is necessarily infinite. At C232's radius two, the relay `F_n` has, under its
unit-cost source input, the profile

```text
lambda_n(k) = infinity for k<2,
              n-1      for k>=2.
```

These are pairwise distinct scalar delay elements. With the terminal parallel consumer included,
the observed target delay is `n`. Thus the old `F_n` obstruction is represented honestly rather
than quotiented away.

## A genuinely branching represented example

Work over `GF(2)` at radius five. Take a center with ports `p,q,u,s`, private seeded elements
`a,c1,c2,c3`, and columns relative to the basis `p,q,a,u,c1,c2`

```text
s = p+q+a,              c3 = s+u+c1+c2.
```

Its complete circuit set is

```text
C1 = {s,p,q,a},
C2 = {s,u,c1,c2,c3},
C3 = {p,q,a,u,c1,c2,c3}.
```

At radius five, a source-fed `F_L` can jump across at most four triangles per round: its cost-two
output profile becomes ready at time `ceil((L-1)/4)`. Attach

```text
F_(4n-3), F_(4m-3), F_(4ell-3)
```

at `p,q,u`, and attach a parallel consumer `{s,y}` at `s`. Seed every relay edge element and every
source element, as well as `a,c1,c2,c3`; leave all relay basis elements and `y` inactive. The three
incoming cost-two profiles are ready at times `n-1,m-1,ell-1` respectively. This reindexing is
important: it retains every longer circuit of the represented relays rather than pretending that
the radius-two propagation speed survives at radius five.

Toward `s`, `C1` simultaneously uses the `p` and `q` profiles plus the unit-cost helper `a`, so it
has cost five and readiness `max(n-1,m-1)`. Circuit `C2` uses the `u` profile and the three private
helpers `c1,c2,c3`, so it also has cost five and readiness `ell-1`. The two alternatives compete by
`min`. The consumer adds one Horn round:

```text
tau(y)
  = 1 + min(max(n-1,m-1), ell-1)
  = min(max(n,m),ell).
```

This is not a disguised path example. One alternative requires two incoming interfaces at once;
the other is a third incoming interface, and changing any of the three delays can change the
output. It exhibits both the budget convolution and the min--max timing law in one fixed binary
component.

## Representation and evaluation growth

The theorem is semantic, but the finite presentation has an explicit bounded evaluation method.
Suppose the eligible local circuits are supplied as a list with total helper-incidence `L`, there
are `N` private elements and `B` directed boundary profiles, and the desired time horizon is `H`.
Truncate values above `H` to `infinity`. There are `(N+B)(r+1)` scalar profile coordinates, each of
which improves at most `H+1` times. A binary profile convolution costs `O(r^2)`. Fair relaxation
therefore terminates after at most

```text
(N+B)(r+1)(H+1)
```

coordinate improvements and admits the deliberately loose bound

```text
O((N+B)(r+1)(H+1) L r^2)
```

for a scan-based evaluator, with linear syntax storage and `O((N+B)r+L)` working storage. Exact
private arrivals need no horizon beyond `H=N`: every nonterminal synchronous round activates at
least one new private element. These are bounds for an explicit circuit-list input, not an FPT
claim and not a claim that eligible circuits can be listed efficiently from an arbitrary matrix.

## Verification

[`2026-07-16-c234-tropical-delay-transfer.py`](2026-07-16-c234-tropical-delay-transfer.py) checks
the algebra and the represented branching construction independently. It exhausts all 35 monotone
profiles of length four over `{0,1,2,infinity}`, checking 1,225 pairs and 42,875 triples for the
identity, commutativity, associativity, idempotence, and distributivity laws.

The script independently enumerates all binary relay circuits through length six and checks the 56
circuits against the uniform interval formula; in particular, it does not retain only the relay's
triangles. It then builds the branching matroid by the exact circuit rule for successive 2-sums and
runs direct global synchronous Horn closure. For all 27 triples `1<=n,m,ell<=3`, using relay
lengths through nine, the direct target arrival agrees with `min(max(n,m),ell)`. The largest replay
has 59 global elements and 927 circuits. The machine-readable result is
[`2026-07-16-c234-tropical-delay-transfer.json`](2026-07-16-c234-tropical-delay-transfer.json).

## Prior-art boundary and disposition

Max-plus dioids are standard tools for synchronization in discrete-event systems; for example,
[McGettrick](https://arxiv.org/abs/math/0010095) studies synchronization equations over max-plus.
Rational semimodules and finite descriptions over max-plus-type semirings are likewise classical;
see [Gaubert and Katz](https://arxiv.org/abs/math/0208014). C234 does not claim a new general
semiring or weighted-automata theorem. Its specific contribution is the exact repair-port
translation: locality costs use an independent budget convolution, circuit helpers synchronize by
`max`, alternatives use `min`, Horn rounds use `Z`, and 2-sum feedback uses the least-information
fixed point.

The presentation is finitely recursive, but it is not called a classical rational series here:
the guarded fixed point and target-delay operator are essential, and no equivalence with a standard
weighted-automaton rationality class has been proved. This closes C234 at the stronger safe point:
exact associative finite syntax exists, its carrier is explicitly infinite, its evaluation growth
is bounded for circuit-list input, and the first genuine branching test passes.
