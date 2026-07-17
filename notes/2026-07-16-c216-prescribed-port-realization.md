# C216 prescribed repair-port realization in asymptotically good codes

**Lane:** `repairports`
**Status:** theorem and achievable regions derived at manuscript level; finite transfer core is
kernel-checked in C215/C224.

## Result

Every fixed bounded repair port already realized by a finite inner linear code is replicated with
positive density in an asymptotically good fixed-alphabet family when its persistent
zero-functional pointed obstruction lies above the repair radius. More precisely, that inequality
is necessary and sufficient for eventual confinement of all low-weight pointed witnesses; literal
repair-hypergraph equality follows. A simpler uniform sufficient condition is the familiar
inner-dual inequality `r+1 < 2 d(I^perp)`.

The outer code is allowed to vary, but the base field, inner code, port, and repair radius remain
fixed. Standard random linear outer codes give a scaled Gilbert--Varshamov region while
algebraic-geometry outer codes give a scaled TVZ region over square extension alphabets.

## Setup

Fix:

- a base field `F_q`;
- an inner `[m,k,d]_q` code `I` and an encoder `e : L -> I`, where `L = F_{q^k}` is viewed as a
  `k`-dimensional `F_q`-space;
- a repair radius `r` and inner coordinate `x`;
- the complete bounded inner repair port
  `P_x = repairHypergraph(I,x,r)`.

Write

```text
mu_x(beta) = min { wt(w) : Phi_I(w)=beta and w_x != 0 },
lambda(beta) = min { wt(w) : Phi_I(w)=beta }.
```

The value `mu_x(beta)` is infinity when its constrained fiber is empty. For at least two outer
blocks, define the persistent zero-functional obstruction

```text
z_x(I) = mu_x(0) + d(I^perp)     if I^perp != 0,
         infinity                if I^perp = 0.
```

This is exactly the closed zero sector proved in C215. It depends only on the fixed pointed inner
code, not on the outer family.

## Pointed replication theorem

Let `O_N <= L^N` be `L`-linear outer codes whose dual Hamming distances tend to infinity. Form the
ordinary concatenations

```text
C_N = O_N o I <= F_q^(mN).
```

Use the trace pairing to identify every `F_q`-linear functional on `L` with multiplication by a
unique element of `L` followed by `Tr_{L/F_q}`. Under this identification the functional dual of
`O_N` has the same support distance as the ordinary `L`-linear dual `O_N^perp`.

Then, for all sufficiently large `N` and every outer block `j`, every pointed dual witness of
weight at most `r+1` is confined to block `j` if and only if

```text
r + 1 < z_x(I).
```

Consequently, under this condition,

```text
repairHypergraph(C_N,(j,x),r)
  = embed_j(repairHypergraph(I,x,r))
```

The converse is deliberately stated for witness confinement, not literal equality of support
hypergraphs: as in C224, support equality can forget witness identity.

### Proof

C215 gives the exact pointed nonembedded cost as

```text
min(z_x(I), nonzeroOuterPointedFiberCost(I,O_N,j,x)).
```

Every representative of a nonzero functional has positive Hamming weight. Therefore every
nonzero functional-dual tuple costs at least its functional support size, even with the target
fiber constrained at `x`. The trace-pairing identification bounds the nonzero sector below by
`d(O_N^perp)`, which tends to infinity. Eventually the exact pointed cost is therefore controlled
only by `z_x(I)`. The C224 pointed transfer theorem converts the lower bound `r+2` into literal
embedded repair-hypergraph equality.

For all inner coordinates at once, it suffices that

```text
r + 1 < min_x z_x(I).
```

Because `mu_x(0) >= d(I^perp)`, the coarser hypothesis

```text
r + 1 < 2 d(I^perp)
```

is always sufficient. The exact `z_x(I)` condition may be strictly weaker at coordinates avoided
by minimum inner-dual words.

## Positive-density realization

For each fixed `x`, the port `P_x` occurs at the `N` targets `(j,x)` inside a word of length `mN`.
Thus it occurs with target density `1/m`. If the condition holds for every `x`, every coordinate of
`C_N` carries its corresponding inner port, and the `N` disjoint inner blocks replicate the whole
pointed port system.

This is a prescribed-port theorem in the following precise sense:

> Any finite pointed repair port representable as `repairHypergraph(I,x,r)` for an inner linear
> code satisfying `r+1 < z_x(I)` occurs with positive density in an asymptotically good family over
> the same fixed base alphabet.

No claim is made that every abstract hypergraph is linearly representable or satisfies the inner
condition.

## Scaled random-code region

Let `Q=q^k` and fix `0<R<1`. Define the `Q`-ary entropy

```text
H_Q(delta) = delta log_Q(Q-1) - delta log_Q(delta)
             - (1-delta) log_Q(1-delta).
```

For `0 < delta, delta_perp < 1-1/Q` satisfying

```text
H_Q(delta)       < 1-R,
H_Q(delta_perp)  < R,
```

a first-moment argument for a random `L`-linear subspace gives outer codes with

```text
rate(O_N) -> R,
d(O_N)/N >= delta,
d(O_N^perp)/N >= delta_perp.
```

Indeed, the expected numbers of low-weight nonzero words in the code and dual have exponential
rates `R+H_Q(delta)-1` and `H_Q(delta_perp)-R`, respectively, so both expectations tend to zero
simultaneously.
The positive dual relative distance also makes every outer coordinate projection surjective for
large `N`.

The concatenated family therefore has

```text
R_concat       -> (k/m) R,
delta_concat   >= (d/m) delta,
```

while preserving every prescribed port satisfying the inner condition. Taking `delta` arbitrarily
close to `H_Q^{-1}(1-R)` gives the nontrivial scaled GV frontier

```text
delta_concat >= (d/m) H_Q^{-1}(1 - (m/k) R_concat)
```

with the usual strict-limit convention and `0<R_concat<k/m`.

## Scaled algebraic-geometry region

When `Q` is a square, let `A(Q)` be Ihara's constant and choose a tower with genus-to-length ratio
approaching `gamma = 1/A(Q)`. Evaluation codes and their differential duals give, for

```text
gamma < R < 1-gamma,
```

simultaneously

```text
rate(O_N) -> R,
delta(O_N)       >= 1-R-gamma,
delta(O_N^perp)  >= R-gamma.
```

Hence

```text
R_concat       -> (k/m) R,
delta_concat   >= (d/m) (1-R-gamma).
```

Using `A(Q) >= sqrt(Q)-1` yields the explicit TVZ-type line with
`gamma <= 1/(sqrt(Q)-1)`. For the paper's completed `[20,4,9]_9` seed,
`Q=9^4=6561`, `k/m=1/5`, `d/m=9/20`, and `gamma=1/80`, recovering the C214
Pareto line as one instance of the general prescribed-port theorem.

## Value and novelty boundary

The asymptotic coding ingredients and concatenated rate/distance calculation are standard. The
value of C216 is the exact local statement: a fixed pointed represented-matroid port is replicated
at positive density, and the sole persistent obstruction is the inner zero-functional pointed
cost. This packages C215's local cost theory into a reusable realization theorem without claiming
new GV or TVZ bounds.

## Validation boundary

- The finite pointed cost decomposition and equality with full search are kernel-checked in
  `RepairPorts/FunctionalCost.lean`.
- Pointed repair-hypergraph transfer is kernel-checked in
  `RepairCodes/WeightedTransferExact.lean`.
- The trace-pairing identification, random first-moment family, AG family, and asymptotic parameter
  calculation are manuscript arguments here.
- This lane does not edit the completed `RepairCodes` theorem chain or the current parent paper.

## Next step

Package the finite-family implication as a light `RepairPorts` Lean wrapper if an aggregate library
entry becomes available. Mathematically, C216's promotion gate is met; the next lane work is the
bounded C217 gauge-invariant scout.
