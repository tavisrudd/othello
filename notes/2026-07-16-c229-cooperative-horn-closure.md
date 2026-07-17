# C229 cooperative ports and bounded Horn closure

**Lane:** `rp-next`
**Status:** COMPLETE. Full cooperative ports are derived conjunctions of the complete singleton
ports, while bounded sequential repair is the genuinely new operational layer: it is forward
chaining under the small-circuit implications and can lie strictly between parallel local repair
and full span recovery.

## Result

Let `M` be the column matroid of a linear code on ground set `E`. Fix a target set `T` and an
allowed helper universe `U subseteq E\T`. For `H subseteq U`, write

```text
f_t(H) = 1[t in cl_M(H)],                 f_T(H) = 1[T subseteq cl_M(H)].
```

Let `H_t^U` be the clutter of inclusion-minimal subsets of `U` repairing `t`, and let `H_T^U` be
the analogous clutter for joint recovery of all of `T`.

### Proposition 1 — the full joint port is a clutter conjunction

For every represented matroid, target set, and helper universe,

```text
f_T(H) = product_(t in T) f_t(H),

H_T^U = min_subseteq {
    union_(t in T) A_t : A_t in H_t^U for every t in T
}.
```

Thus full cooperative recovery contains no invariant beyond the family of complete singleton
ports on the common allowed universe. It does contain useful derived data: different targets may
share helpers, so the minimum cooperative cost can be strictly smaller than the sum of separate
minimum costs, and the joint reliability is generally not the product of marginal reliabilities.

For a linear code, this is exactly Rawat--Mazumdar--Vishwanath cooperative repair: the coordinates
in `T` are functions of those in `H` precisely when every target column lies in the span of the
helper columns. The displayed clutter identity follows because a finite set satisfying every
singleton predicate contains a minimal witness `A_t` for each `t`; conversely their union satisfies
every predicate by monotonicity.

### Proposition 2 — bounded sequential repair is small-circuit Horn closure

For locality radius `r`, form the definite Horn implication system

```text
Sigma_r = { (C\{e}) -> e : C a circuit of M, e in C, |C| <= r+1 }.
```

For survivors `S`, let `P_r(S)` add in one parallel round every coordinate repairable from at most
`r` members of the original `S`, and let `L_r(S)` be the least fixed point obtained by forward
chaining `Sigma_r`. Then

```text
S subseteq P_r(S) subseteq L_r(S) subseteq cl_M(S).
```

The first inclusion can be strict because an earlier local repair can be used in a later equation.
The second can be strict because a full-span dependency may require more than `r` available
coordinates and have no chain of small circuits.

If `F=E\S` is the erasure set, then:

- parallel radius-`r` repair succeeds exactly when `P_r(S)=E`;
- sequential radius-`r` repair succeeds exactly when `L_r(S)=E`;
- full linear/MAP recovery succeeds exactly when `cl_M(S)=E`.

Equivalently, repeatedly delete an erased element that is the unique erased member of some circuit
of size at most `r+1`. The order-independent residual is `E\L_r(S)`, the small-circuit stopping
core. Sequential repair succeeds exactly when this core is empty. This is the joint, iterated
version of C226's target-specific stopping-certificate boundary.

With all circuits admitted, the distinction disappears:

```text
L_infinity(S) = P_infinity(S) = cl_M(S).
```

Indeed, for each `e in cl_M(S)\S`, some circuit satisfies `e in C subseteq S union {e}`, so the
complete matroid closure is already obtained in one unbounded round. Iteration becomes meaningful
only after the locality truncation.

## A smallest strict three-level example

Over `GF(5)`, take the six columns

```text
        a b c x y w
G = [   1 0 0 1 1 1
        0 1 0 1 1 2
        0 0 1 0 1 3 ].
```

Set `S={a,b,c}` and `r=2`. One parallel round adds only `x`, since `x=a+b`. Forward chaining then
adds `y`, since `y=x+c`. No pair among `{a,b,c,x,y}` spans `w`; every circuit containing `w` has
size four. But `S` is a basis, so full span recovery adds all three erased columns. Therefore

```text
P_2(S)       = {a,b,c,x}
L_2(S)       = {a,b,c,x,y}
cl_M(S)      = {a,b,c,x,y,w}.
```

Operationally, `{x,y}` is sequentially but not parallel repairable at locality two. For erasures
`{x,y,w}`, locality-two peeling repairs `x` and `y` and leaves the stopping core `{w}`, whereas
full cooperative recovery repairs all three from the common helper set `{a,b,c}`.

Six columns are minimal for any strict radius-two chain of this form. If
`L_2(S) < cl_M(S)`, then `rank(S)>=3`, because every element in the span of a rank-at-most-two set
is already in `P_2(S)`. Strict `P_2(S)<L_2(S)` requires one element added in the first round and a
different element added later. Strict `L_2(S)<cl_M(S)` requires a third element outside the Horn
closure. Hence `|E|>=3+2+1=6`, and the displayed example attains the bound.

## Verification

[`2026-07-16-c229-cooperative-horn-closure.py`](2026-07-16-c229-cooperative-horn-closure.py)
performs independent modular Gaussian elimination and circuit enumeration. It checks all 64 seed
sets of the six-column representation, including:

- full circuit-Horn closure equals matroid closure;
- unbounded repair closes in one round;
- size-at-most-three circuit Horn closure equals sequential radius-two repair;
- `P_2(S) subseteq L_2(S) subseteq cl_M(S)` for every seed;
- the joint predicate and minimal-union formula for all 665 target/helper cases.

The machine-readable result is
[`2026-07-16-c229-cooperative-horn-closure.json`](2026-07-16-c229-cooperative-horn-closure.json).

## Prior-art boundary

The focused audit found all three surrounding theories, so none is claimed as new in isolation.

- Rawat, Mazumdar, and Vishwanath define `(r,l)` cooperative locality as recovery of any `l`
  failed coordinates from one common set of at most `r` intact coordinates. Their paper studies
  rate/distance bounds and constructions, not the complete targetwise clutter operation above:
  [arXiv:1409.3900](https://arxiv.org/abs/1409.3900).
- Song, Cai, and Yuen explicitly distinguish parallel recovery from sequential recovery in which
  already repaired symbols may be reused. Their focus is code-level `(n,k,r,t)` guarantees,
  bounds, and constructions:
  [arXiv:1610.09767](https://arxiv.org/abs/1610.09767).
- Berczi, Boros, and Makino identify matroid circuit clauses as matroid Horn functions and prove
  equality of Horn and matroid closure. Their object uses the complete circuit family; C229's
  operational distinction comes from truncating by circuit size:
  [arXiv:2301.06642](https://arxiv.org/abs/2301.06642).

The cached source hashes are respectively
`8e71095933dff7b4c083b47fa52f5ae8bafb85b8fd4e649121dc84ee26975037`,
`6aacd2b590e73c571961d6dd921fae9ad7c2378088cabae1171bbd50668b5a50`, and
`a7150e01acd2f4bf86454bdc11bad436f29832d38ea749e95b072b02e7cae0d5`.

The defensible contribution is the synthesis: complete cooperative ports are the clutter
conjunction of restricted singleton ports; full circuit logic adds no depth because matroid closure
is one-round; locality truncation creates an iterated Horn closure with an exact stopping-core
semantics and a smallest strict represented separation. No broad priority claim is made beyond
this focused comparison.

## Disposition

C229 passes its bounded gate. The tempting claim that full joint ports supply a new invariant is
closed negatively: they are derived from singleton complete ports. The bounded Horn layer is a
real operational refinement, however, and gives a clean architecture:

```text
singleton complete ports --conjunction--> cooperative full-span ports
radius-r circuit ports    --Horn chain--> sequential local closure
```

This result is strong enough to retain as repair-port theory. It does not by itself justify a new
code-construction task or an unrestricted cooperative-LRC program.
