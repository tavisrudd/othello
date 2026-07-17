# C230 Horn-depth composition and the minor boundary

**Lane:** `rp-next`
**Status:** COMPLETE. The bounded scout rules out the naive same-radius deletion--contraction
recurrence, while an exact residual-Horn conditioning law, a causal min--max arrival-time equation,
and direct-sum profile factorization give the requested explanatory compression.

## Result

Let `M` be a matroid on `E`, fix a locality radius `r`, and retain the canonical small-circuit rule
system

```text
Sigma_r(M) = { (C\{e}) -> e : C a circuit, e in C, |C| <= r+1 }.
```

For a survivor seed `S`, put `A_0(S)=S` and let `A_(k+1)(S)` add in parallel every conclusion
whose body lies in `A_k(S)`. Write

```text
tau_S(e) = min { k : e in A_k(S) },
```

with `tau_S(e)=infinity` when `e` is never recovered. The terminal closure and stopping core are

```text
L_r(S) = {e : tau_S(e) < infinity},
K_r(S) = E \ L_r(S) = {e : tau_S(e) = infinity}.
```

### Proposition 1 — arrival times are a causal min--max circuit valuation

With `min(empty)=infinity`, `max(empty)=0`, and `1+infinity=infinity`, the arrival times are
characterized exactly by

```text
tau_S(e) = 0,                                                     e in S;

tau_S(e) = 1 + min_(C contains e, |C|<=r+1)
                    max_(u in C\{e}) tau_S(u),                    e notin S.
```

This is the tropical-looking `min`--`max` algebra naturally forced by repair: choose the fastest
available circuit, wait for its slowest helper, then spend one repair round. It is causal, not an
ordinary rank valuation. Any finite value has a strictly descending witness tree ending in `S`,
which proves uniqueness and excludes circular self-activation. The infinity locus is therefore the
stopping core without a separate peeling-order argument.

Let

```text
d_r(S) = max({0} union {tau_S(e) : tau_S(e)<infinity})
```

be the stabilization depth. This records all successful layers even when a nonempty stopping core
remains.

### Proposition 2 — exact component composition

If `M=M_1 direct_sum M_2`, every circuit lies in one component. Hence, for
`S_i=S intersect E_i`,

```text
tau_S(e) = tau_(S_i)^(M_i)(e)                  for e in E_i,
K_r^M(S) = K_r^(M_1)(S_1) disjoint_union K_r^(M_2)(S_2),
d_r^M(S) = max(d_r^(M_1)(S_1), d_r^(M_2)(S_2)).
```

This gives an exact factorization of the cumulative depth/core profile

```text
Z_(M,r)^(<=k)(x,y)
  = sum_(S subseteq E, d_r(S)<=k) x^|S| y^|K_r(S)|:

Z_(M_1 direct_sum M_2,r)^(<=k)
  = Z_(M_1,r)^(<=k) Z_(M_2,r)^(<=k).
```

Exact-depth layers are successive differences in `k`; the successful-seed depth profile is the
coefficient of `y^0`. Once `k>=|E|`, this specializes to the ordinary stopping-core enumerator.
Thus componentwise composition is not merely a closure tautology: it simultaneously transports
seed size, residual core size, successful depth, and partial-cascade depth.

### Proposition 3 — exact one-element residual conditioning

Fix `e in E`. There are two canonical rule systems on `E\{e}`:

```text
Sigma^-  = the rules from small circuits not containing e
         = Sigma_r(M\e),

Sigma^(e+) = every small-circuit rule with e fixed true,
             i.e. remove e from every rule body and discard conclusions e.
```

For `S subseteq E\{e}`, let `D=cl_(Sigma^-)(S)`. Also write `rho_e(D)=1` when a small circuit
`C` satisfies `e in C` and `C\{e} subseteq D`. Then

```text
L_r^M(S union {e}) = {e} union cl_(Sigma^(e+))(S),

L_r^M(S) = D,                                             rho_e(D)=0;
L_r^M(S) = {e} union cl_(Sigma^(e+))(D),                  rho_e(D)=1.
```

The proof is positive-Horn causality. Before `e` appears, exactly the deletion rules can fire, so
they saturate to `D`. If `D` cannot repair `e`, no later event can bootstrap it. If it can, fixing
`e` true leaves exactly the residual system `Sigma^(e+)`.

This is a genuine deletion-like recursion, but its live branch is a **lift-filtered residual**, not
the same-radius small-circuit system of `M/e`. It gives an exact terminal closure and stopping-core
recursion. Exact synchronous times remain most cleanly represented by Proposition 1; collapsing
the deletion phase to `D` intentionally forgets when its elements arrived.

## Why ordinary deletion--contraction fails

The bounded scout found both failures over `GF(2)` at radius two.

### Deletion can remove a repairable relay

Take columns

```text
a=(1,0,0), b=(0,1,0), c=(0,0,1), x=(1,1,0), y=(1,1,1).
```

From `S={a,b,c}`, the small circuits `{a,b,x}` and `{x,c,y}` recover `x` in round one and `y` in
round two. In `M\x`, the surviving dependency `{a,b,c,y}` has size four, so radius two recovers
nothing. Therefore

```text
L_2^M(S)\{x} = {a,b,c,y} != L_2^(M\x)(S) = {a,b,c}.
```

An erased element is not the same as a permanently deleted element: it may return and relay the
cascade.

### Contraction can admit an over-budget lifted circuit

Take the binary `U(3,4)` representation

```text
a=(1,0,0), b=(0,1,0), c=(0,0,1), w=(1,1,1).
```

Its only circuit has size four. Even with `a` initially live, radius two cannot recover `w` from
`{b,c}`. But contracting `a` turns that circuit into the size-three circuit `{b,c,w}`, so the
same-radius system of `M/a` does recover `w`:

```text
L_2^M({a,b,c})\{a} = {b,c} != L_2^(M/a)({b,c}) = {b,c,w}.
```

Contraction has silently discounted the live coordinate from the locality budget. The residual
system avoids this by retaining only circuits whose lifts were already of size at most `r+1`.
These witnesses rule out the tempting identification of the two conditioned branches with
`M\e` and `M/e`; they do not claim that no more highly stateful minor recursion can exist.

## Verification

[`2026-07-16-c230-horn-depth-composition.py`](2026-07-16-c230-horn-depth-composition.py) performs
independent binary rank and circuit calculations. It exhausts all 127 nonempty restrictions of the
seven nonzero vectors of `GF(2)^3`, checking every distinguished element and every seed on the
remaining ground set: 5,103 element/seed cases. In every case it verifies the min--max arrival
equation, identifies the stopping core with the infinity locus, and checks both branches of the
residual-conditioning law. It also checks 81 cumulative-profile direct-sum identities and the two
explicit minor counterexamples.

The machine-readable certificate is
[`2026-07-16-c230-horn-depth-composition.json`](2026-07-16-c230-horn-depth-composition.json).

## Prior-art boundary

Song, Cai, and Yuen define sequential local recovery through an order in which previously repaired
symbols may be reused, and characterize success by the existence of a currently repairable erasure.
Their results concern code-level erasure guarantees, rate bounds, and constructions, not the full
seedwise depth/core profile or the element-conditioning law above:
[arXiv:1610.09767](https://arxiv.org/abs/1610.09767).

Berczi, Boros, and Makino give the standard definite-Horn forward-chaining closure and prove that
the complete circuit clauses recover matroid closure. They explicitly note that one-step behavior
can depend on the chosen CNF even when the terminal Horn function does not. Accordingly, C230's
depth is attached to the canonical radius-truncated circuit presentation `Sigma_r(M)`, not asserted
to be an invariant of an abstract terminal closure operator:
[arXiv:2301.06642](https://arxiv.org/abs/2301.06642).

The cached source hashes are respectively
`6aacd2b590e73c571961d6dd921fae9ad7c2378088cabae1171bbd50668b5a50` and
`a7150e01acd2f4bf86454bdc11bad436f29832d38ea749e95b072b02e7cae0d5`.

No novelty claim is made for generic Horn forward chaining, min--max scheduling recurrences, or
direct-sum factorization in isolation. The defensible repair-port contribution is the combined
package: canonical small-circuit arrival times, a profile that composes exactly, an exact
lift-filtered one-element recursion, and sharp represented witnesses showing why ordinary
same-radius deletion--contraction is the wrong algebra.

## Disposition

C230 passes its gate. The next genuinely stronger question is whether the residual state closes
under a one-coordinate parallel connection or matroid 2-sum, with locality budgets convolved across
the interface. A direct attack on a Tutte-style same-radius recurrence is closed by the two
counterexamples above.
