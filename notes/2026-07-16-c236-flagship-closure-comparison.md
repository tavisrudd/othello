# C236 cubic/harmonic flagship closure comparison

**Lane:** `rp-next`
**Status:** COMPLETE. Radius-three sequential closure equals full matroid closure on the completed
cubic--axis family over every `GF(3^h)`, while an explicit q=9 quartic--nucleus seed has inert
radius-four sequential closure but spans the entire projective system.

## Result

Let `K=GF(3^h)`. In `PG(3,K)` write

```text
C(t) = (1,t,t^2,t^3),     C(infinity) = (0,0,0,1),
A(v) = (0,1,v,0),         A(infinity) = (0,0,1,0),
E = C(P^1(K)) union A(P^1(K)).
```

Let `M_q` be the column matroid on `E`, and let `L_3` denote C229's sequential Horn closure using
circuits with at most three helpers. Then, for every survivor set `S subseteq E`,

```text
L_3(S) = cl_(M_q)(S).
```

Thus the completed cubic family strictly separates one-round radius-three repair from sequential
radius-three repair, as observed in Fable R4(c), but it cannot separate sequential local repair
from full-span recovery.

The quartic--nucleus harmonic family behaves differently. Over the verifier's
`GF(9)=GF(3)[x]/(x^2+1)`, with integers encoding `a+b x` as `a+3b`, take

```text
S_harm = {V(infinity), V(0), V(1), V(x), V(2+x)}.
```

This set contains no harmonic block. Consequently no radius-four circuit rule fires and

```text
L_4(S_harm) = S_harm,              |L_4(S_harm)| = 5.
```

But the five curve points are independent by C218, hence form a basis of the rank-five q=9
projective system. Therefore

```text
cl(S_harm) = Gamma_4 union {N},     |cl(S_harm)| = 11.
```

This certifies the requested strict in-family separation.

## Cubic proof

The complete radius-three circuit table has two kinds:

1. every three distinct points of the axis line;
2. three distinct curve points together with their unique completion-axis point.

For finite parameters `s,t,u`, the second point is

```text
A((st+su+tu)/(s+t+u))  if s+t+u != 0,
A(infinity)             if s+t+u = 0,
```

with the usual degenerate formulas for triples containing `C(infinity)`. This is precisely the
sigma-completion table from R4.

It is enough to prove that every `Sigma_3`-closed subset `H` of `E` is a matroid flat: applying
this to `H=L_3(S)` gives `cl(S) subseteq H`, while circuit soundness gives the reverse inclusion.
Put

```text
a = |H intersect A(P^1(K))|,       c = |H intersect C(P^1(K))|.
```

The axis-triple rules force `a` to be `0`, `1`, or `q+1`.

- If `a=0`, then `c<=2`: any three curve points would add their completion-axis point. Such a
  set is a flat, since the twisted cubic has no three collinear points and there are no mixed
  three-circuits.
- If `a=1`, four curve points are impossible. Indeed, closure would force the completion of every
  curve triple to be the one axis point already in `H`. But two triples sharing a curve pair and
  having the same completion lie in the same plane; four distinct twisted-cubic points would then
  be coplanar, contradicting their independence. Hence `c<=3`. For `c=3`, closure forces the axis
  point to be their completion, and `H` is exactly that plane section. For `c=2`, any additional
  curve point in the plane spanned by `H` would complete a mixed four-circuit and would already
  have been added. The cases `c<=1` are immediate from the absence of non-axis three-circuits.
- If `a=q+1` and `c>=2`, any missing curve point forms a mixed four-circuit with two curve points
  already in `H` and its completion point on the fully present axis. Thus `H=E`. If `c=0`, `H` is
  the axis flat. If `c=1`, it is the plane section consisting of the axis and that curve point:
  a plane through the axis has equation `alpha X_0 + delta X_3=0`, whose restriction to the curve
  has at most one projective root because `t -> t^3` is a bijection of `K`.

These cases exhaust every Horn-closed set and prove the theorem for all `h>=1`. The same argument
also explains the cascade operationally: two axis points expose the entire axis, after which two
curve points expose every curve point; three curve points plus a noncompletion axis point create a
second axis point; and four curve points necessarily create at least two distinct completions.

## Harmonic certificate

For the finite parameter set `{0,1,x,2+x}`:

```text
no three distinct parameters sum to zero,
e_2(0,1,x,2+x) = 1+x != 0.
```

C218's harmonic-block criterion says that a block through `infinity` corresponds to a zero-sum
finite triple, while a four-finite-point block has `e_2=0`. Hence none of the five four-subsets of
`S_harm` is a block.

Every radius-four circuit in the quartic--nucleus system is `{N} union B` for a harmonic block
`B`. With `N` absent, the first possible sequential step would need all four points of some `B`;
there is none, so the seed is already Horn-closed. In contrast, the normal rational quartic makes
every five curve points independent. The separation is therefore structural, not a timing
artifact: the cubic's small circuits can manufacture the entire rank-two axis from two completion
values, whereas every harmonic curve-repair rule is gated by the absent nucleus and the only rule
that can manufacture the nucleus requires a complete harmonic block.

## Verification

[`2026-07-16-c236-flagship-closure-comparison.py`](2026-07-16-c236-flagship-closure-comparison.py)
imports the independent committed cubic and harmonic verifiers and checks:

- the complete small-circuit table at q=3 and q=9;
- the four-curve distinct-completion lemma for every four-set;
- all Horn-closed subsets at q=3 and q=9, confirming that each is matroid-closed;
- the explicit q=9 harmonic field identities, absence of a contained block, rank five, inert
  sequential closure, and full eleven-point matroid closure.

At q=3 there are 53 common closed sets, with rank histogram `1,8,23,20,1`; at q=9 there are 388,
with rank histogram `1,20,146,220,1`. The finite replay is a guard for the all-field proof, not its
source. The deterministic machine-readable output is
[`2026-07-16-c236-flagship-closure-comparison.json`](2026-07-16-c236-flagship-closure-comparison.json).

## Disposition

C236 passes its success gate positively on both flagships. The cubic conjecture holds uniformly,
and the harmonic witness is explicit and checked. No further cubic/harmonic census or closure-class
claim is needed. The next ordered task is C237's bounded `U(3,8)` holonomy-sensitive MPC probe.
