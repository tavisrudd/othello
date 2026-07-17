# C232 multi-interface transfer and the triangle-relay obstruction

**Lane:** `rp-next`
**Status:** COMPLETE — NEGATIVE FINITENESS RESULT. C231's scalar interface law lifts exactly to a
multi-interface response calculus on every tree of 2-sums, and behavioral equivalence is a valid
contextual replacement congruence. It does not have a state bound depending only on locality radius
and interface width: already at radius two and width two, a binary triangle relay gives infinitely
many response behaviors and arbitrarily large exact synchronous depth.

## Result

There are two separate conclusions.

1. The positive compositional statement survives. A node with several virtual elements is an
   exact finite-input transducer: its response toward one interface is a function of the scalar
   costs arriving at its other interfaces, and one Horn round is driven by the full incoming cost
   vector. On a 2-sum tree, directed subtree messages and node updates recover the global parallel
   Horn round exactly.
2. The hoped-for radius/width-bounded finite quotient fails. Fixed `r=2` and two virtual elements
   already admit components whose outgoing response first becomes finite after any prescribed
   number of rounds. This remains an obstruction after private size and active count are removed
   from the observable, so it is not the trivial fact that exact counts are unbounded.

Thus C231 gives an exact transfer **calculus**, but not a finite transfer **alphabet** independent
of component size.

## Multi-interface state

Fix a locality radius `r` and write

```text
Q_r = {0,1,...,r,infinity},
```

with truncated addition. Let a component `M` have a labeled virtual set `P` and private ground set
`R=E(M)-P`. A state is `x=(M,P,A)` with `A subseteq R` active. For an incoming vector
`q in Q_r^P`, a circuit `C` containing a private target `e` has current cost

```text
kappa_e(C;A,q)
  = |(C intersect R)-{e}| + sum_(p in C intersect P) q_p,
```

provided every other private element of `C` lies in `A`; otherwise its cost is infinity. Define

```text
delta_q(A)
  = A union {e in R-A : min_(C circuit, e in C) kappa_e(C;A,q) <= r}.
```

For an outgoing interface `p`, the same component must not use the branch beyond `p` to synthesize
`p`. Its response to costs `z in Q_r^(P-{p})` is therefore

```text
mu_p(A;z)
  = min {
      |C intersect R| + sum_(s in (C intersect P)-{p}) z_s :
      C circuit, p in C, C intersect R subseteq A
    },
```

again truncated to `Q_r`. The multi-interface observable is the full response table

```text
rho_x = (mu_p(A;z))_(p in P, z in Q_r^(P-{p})).
```

For exact seed/core/depth counts, use

```text
o_r(x) = (|R|, |A|, rho_x).
```

The count coordinates may instead be treated as output weights, but doing so does not remove the
response-latency obstruction below.

### Proposition 1 — exact directed-message law on a 2-sum tree

Let a tree `T` index components `M_v`; each edge `uv` uses distinct virtual elements in its two
endpoint components, and all virtual elements are nonloops and noncoloops. For a global active
tuple `(A_v)`, orient every edge both ways. The cheapest current certificate inside the component
of `T-uv` containing `v` satisfies

```text
m_(v->u)
  = mu_(v,uv)(A_v; (m_(w->v))_(w adjacent to v, w != u)).
```

These equations have a unique value: after deleting `uv`, they recurse from the leaves of the
rooted `v`-side subtree. One global parallel Horn round is exactly

```text
A_v^+
  = delta_((m_(u->v))_(u adjacent to v))(A_v)
```

at every node.

**Proof.** The circuit theorem for one 2-sum has the two cases used in C231: a circuit stays on one
side, or two interface-containing circuits are combined and the virtual element is deleted. Apply
that theorem successively from the leaves of the support subtree of a global circuit. At a node,
its local circuit chooses which incident virtual elements occur. The branches beyond those
elements are disjoint, so their certificate sizes add and their minimizations are independent.
This gives `mu` for a directed subtree and `delta` for a private target. Conversely, composing the
chosen local and branch circuits along those tree edges constructs the asserted global circuit.
Truncation is sound because an over-budget branch can never occur in a radius-`r` repair. QED.

This is the exact multi-interface lift of C231's scalar law. A response is generally not one scalar
per node: it is one scalar-valued table per outgoing port because a local circuit may use several
other virtual elements at once.

## Moore congruence and contextual replacement

For states with the same labeled virtual set, define the depth-`k` Moore signatures by

```text
sigma_0(x)     = o_r(x),
sigma_(k+1)(x) = (o_r(x), (sigma_k(delta_q(x)))_(q in Q_r^P)).
```

Two states are behaviorally equivalent when all their finite-depth signatures agree, equivalently
when they have the same output trace under every finite input word.

### Proposition 2 — behavioral equivalence is a tree-context congruence

Replacing one node-state in any 2-sum tree by a behaviorally equivalent state preserves every
directed scalar-message trace, every node active-count trace, and hence the global seed size,
terminal core size, and synchronous depth histogram.

**Proof.** At round zero the two response tables and count outputs agree. Proposition 1 evaluates
all directed messages by well-founded subtree recursion; replacing an equal response table leaves
every message unchanged. The replaced node therefore receives the same input vector in both
trees. Behavioral equivalence is closed under every transition `delta_q`, so the successor states
remain equivalent. Induction on global rounds proves equality of all message and count traces.
The terminal core and depth histogram are read from those traces. QED.

This validates the C231 scout's automata-theoretic test. On any fixed finite component catalog,
ordinary Moore refinement computes the minimal exact contextual quotient. What fails is a uniform
bound on that quotient as component size grows.

## The fixed-width triangle relay

For every `n>=1`, work over `GF(2)^(n+1)` with basis `e_0,...,e_n`. Define a center component `F_n`
with virtual elements `p,q`, private elements `x_1,...,x_(n-1),s_1,...,s_n`, and columns

```text
p   = e_0,
q   = e_n,
x_i = e_i                         (1 <= i < n),
s_i = e_(i-1) + e_i               (1 <= i <= n).
```

Treat `x_0=p` and `x_n=q`. The columns are distinct and nonzero, and the complete circuit inventory
through cardinality three is

```text
{x_(i-1), s_i, x_i},              1 <= i <= n.
```

Indeed, a binary three-circuit is a triple whose columns sum to zero. Two basis columns sum to a
listed weight-two column exactly when they are consecutive. A basis column cannot be the sum of
two distinct path-edge columns, and three path-edge columns cannot sum to zero because a path has
no nonempty even-degree edge set. There are no loops or parallel pairs in the center. In
particular, both virtual elements lie in circuits. Seed every `s_i`. Supply the `p` interface
at cost one and leave the `q` input unavailable. At radius two, synchronous local rounds add

```text
round 1: x_1,
round 2: x_2,
...
round n-1: x_(n-1).
```

The response toward `q` is infinity at local times `0,...,n-2` and becomes two at time `n-1`, via
the last triangle `{x_(n-1),s_n,q}`. For the fixed input word `(q_p,q_q)=(1,infinity)` this first
finite-output time distinguishes every `F_n` from every `F_m` with `m!=n`.

Only three-element circuits can affect this trace. For a private target, an internal feasible
circuit has at most two private helpers; a feasible circuit using `p` has at most one private helper
in addition to the unit incoming cost. The same count applies to an outgoing `q`-certificate.
Circuits using the unavailable `q` input have infinite cost. Thus longer circuits cannot shortcut
the relay.

### A genuine 2-sum-tree context

Attach at `p` a binary parallel pair `{p,z}` with `z` seeded, and at `q` a parallel pair `{q,y}`
with `y` initially inactive. Both gluing elements are noncoloops. The two 2-sums simply replace
`p` by `z` and `q` by `y`, so direct radius-two closure from

```text
S_n = {z,s_1,...,s_n}
```

has exactly the addition layers

```text
x_1, x_2, ..., x_(n-1), y.
```

The terminal target arrives in round `n`. Hence the obstruction is visible in an actual three-node
2-sum tree, not only under an artificial input word.

### Theorem 3 — no radius/width-only finite behavioral alphabet

At radius two and interface width two, the response-only Moore quotient contains infinitely many
classes. Consequently there is no exact finite transfer state set bounded solely by `r` and `|P|`
that advances one synchronous round and preserves all boundary-message or depth traces.

**Proof.** If two relay states shared a behavioral class, they would have equal response traces
under the constant input word above. Their first finite `q`-response times would then agree. For
`F_n` that time is `n-1`, so the states are pairwise inequivalent. QED.

This is stronger than the immediate count obstruction: the proof discards `|R|` and `|A|` and uses
only the finite-valued boundary response trace.

## Verification

[`2026-07-16-c232-triangle-relay.py`](2026-07-16-c232-triangle-relay.py) independently constructs
the binary columns and enumerates every circuit through cardinality three. For `1<=n<=32` it checks
the exact triangle inventory, noncoloop interfaces, local response trace, and direct glued Horn
layers. The checks reach rank 33 and a 65-column center, with outgoing delay 31 and terminal depth
32. The machine-readable summary is
[`2026-07-16-c232-triangle-relay.json`](2026-07-16-c232-triangle-relay.json).

The proof is uniform in `n`; the computation is a replay guard, not the basis for extrapolation.

## Boundary and disposition

C232 settles the proposed finite-algebra question negatively at fixed radius and width while
retaining an exact positive composition law. It rules out a finite Moore-state vocabulary for the
full synchronous message/depth profile without another bound.

It does not rule out:

- an exact terminal-closure algebra that forgets arrival depth;
- a finite quotient after bounding component size, propagation depth, or observation horizon;
- a finitely presented algebra with an infinite carrier, such as a delay or tropical-series weight;
- algorithms specialized to decomposition trees whose pieces have additional structure.

No tree-DP or fixed-parameter claim follows from C231's finite one-interface catalog. The natural
next question, if this lane continues, is whether terminal closure alone has a finite
radius/width-bounded response quotient, or whether a separate fixed-point obstruction survives
after all timing information is erased.
