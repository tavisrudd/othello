# C219 complete-port reliability and Steiner threshold laws

**Lane:** `repairports`
**Status:** COMPLETE. Complete repair ports carry an exact Boolean reliability invariant, and the
C218 harmonic family has explicit Poisson survival windows with a qualitatively different
common-nucleus bottleneck at curve targets.

## Complete-port reliability calculus

Let `H_x` be the clutter of minimal helper sets repairing a target `x`, on helper set `V`. For a
surviving set `A subset V`, define

```text
f_H(A) = 1  iff  some E in H satisfies E subset A.
```

For independent helper survival probabilities `(s_v)`, put `R_H(s)=E[f_H]`. If `v in V`, define

```text
H - v = min {E in H : v notin E},
H / v = min {E - {v} : E in H},
```

where `min` discards nonminimal members. Conditioning on `v` gives the exact recurrence

```text
R_H(s) = (1-s_v) R_(H-v)(s) + s_v R_(H/v)(s).
```

Consequently

```text
partial R_H / partial s_v = R_(H/v) - R_(H-v)
                          = Pr(v is pivotal),
```

where pivotality is evaluated over the other helpers. Under homogeneous survival `s`, the
Russo--Margulis identity becomes

```text
d R_H(s) / ds = sum_v Pr_s(v is pivotal).
```

These formulas also give an exact dynamic program for any finite complete port. For an arbitrary
correlated failure law `mu`, reliability is simply `mu({A : f_H(A)=1})`; the product recurrence
need not survive, but the Boolean function does.

If `B(H)` is the clutter of minimal blockers and `F=V-A` is the failed set, then

```text
f_H(A)=0  iff  F contains some B in B(H).
```

Thus, if the minimum blocker size is `tau` and there are `b_tau` minimum blockers, homogeneous
failure probability `p=1-s` gives

```text
1-R_H(1-p) = b_tau p^tau + O(p^(tau+1)).
```

This shows exactly what the blocker census controls: the high-survival exponent and leading
coefficient, not the full reliability polynomial.

Exact port transfer preserves `H_x` up to relabeling. It therefore preserves `f_H`, every
multivariate reliability polynomial, every correlated-law reliability after transporting the law,
all pivotal influences, and every blocker coefficient. This is stronger than preserving locality,
matching number, or transversal number separately.

## Steiner Poisson-window theorem

Let `(V_n,B_n)` be any sequence of Steiner systems `S(3,4,n)`, and retain each point independently
with probability `s_n`. Let `X_n` count retained blocks. Then:

1. the scale for containing a block is `s_n asymp n^(-3/4)`;
2. if `s_n=c n^(-3/4)` for fixed `c >= 0`, then

   ```text
   X_n -> Poisson(c^4/24),
   Pr(X_n > 0) -> 1-exp(-c^4/24);
   ```

3. if `s_n=o(n^(-3/4))`, then `Pr(X_n>0)->0`, while if
   `s_n/n^(-3/4)->infinity`, then `Pr(X_n>0)->1`.

This is a Poisson threshold window, not a Friedgut--Kalai sharp-threshold claim: constant
multiples of the threshold scale have different nondegenerate limits.

For the proof, the number of blocks is

```text
b_n = n(n-1)(n-2)/24.
```

For any fixed block, exactly `3(n-4)` other blocks meet it in two points and
`2(n-4)(n-8)/3` meet it in one point; distinct blocks cannot meet in three points. At the proposed
scale, the total joint contribution of two-point overlaps is `O(n^4 s_n^6)=O(n^(-1/2))`, and that
of one-point overlaps is `O(n^5 s_n^7)=O(n^(-1/4))`. The dependency-graph Poisson criterion now
gives the limit. Markov's inequality below the scale and the same overlap counts in a second-moment
bound above it give the zero--one statements.

Applying this to C218 with `n=q+1`, the probability that the nucleus coordinate is repairable under
iid curve-helper survival `s=c n^(-3/4)` tends to

```text
1-exp(-c^4/24).
```

This is an inner-alphabet limit along `q=3^h`; it is distinct from C216's fixed-alphabet,
outer-blocklength asymptotic replication.

## Derived-design bottleneck at a curve target

Fix a point `x` of an `S(3,4,n)`. Removing `x` from every block through it gives an
`S(2,3,m)` on `m=n-1` points. It has `m(m-1)/6` triples, and each triple meets exactly
`3(m-3)/2` others. If curve helpers survive independently with probability
`s=c m^(-2/3)`, the number of surviving derived triples therefore converges to
`Poisson(c^3/6)` by the same dependency calculation.

In the C218 port, however, every curve-target repair also contains the nucleus `N`. If `N` survives
independently with probability `rho`, then

```text
Pr(x is repairable) -> rho (1-exp(-c^3/6)).
```

Under homogeneous survival, `rho=s`. Hence there is no vanishing-probability success threshold:
the common helper is a series bottleneck. For every fixed `0<s<1`, the derived design supplies a
repair with probability tending to one but total repairability tends only to `s`; approaching
reliability one requires nucleus survival tending to one. This is the main qualitative distinction
between nucleus and curve targets.

## Exact q=9 applications

For a port on `N` helpers, write its homogeneous reliability in Bernstein form

```text
R(s) = sum_(k=0)^N a_k s^k (1-s)^(N-k),
```

where `a_k` is the number of successful `k`-helper survivor sets. C202's exact q=9 ports give:

| target | radius | repairs | `tau` | high-survival failure |
|---|---:|---:|---:|---:|
| cubic | 3 | 36 | 8 | `45 p^8 + O(p^9)` |
| cubic | 4 | 1,962 | 8 | `9 p^8 + O(p^9)` |
| axis | 3 | 48 | 13 | `486 p^13 + O(p^14)` |
| axis | 4 | 1,038 | 15 | `108 p^15 + O(p^16)` |

Thus the full cubic port improves the leading coefficient without changing the exponent, whereas
the full axis port improves the exponent by two. Matching and minimum-blocker values alone do not
display this distinction.

For C218 at q=9, the nucleus target has

```text
(a_0,...,a_10) = (0,0,0,0,30,180,210,120,45,10,1),
```

with 72 minimum blockers of size five. A curve target has

```text
(a_0,...,a_10) = (0,0,0,0,12,72,126,84,36,9,1),
```

and the nucleus singleton is its unique minimum blocker.

## Verification

[`2026-07-16-c219-repair-reliability.py`](2026-07-16-c219-repair-reliability.py) imports the C202
and C218 verifiers rather than reconstructing their geometries. It performs an upward Boolean zeta
transform over each helper set, computes every Bernstein coefficient for the four C202 ports and
the two C218 target types, and checks the first failure layer against the committed blocker counts.
It also enumerates the q=9 `S(3,4,10)` and derived `S(2,3,9)` block intersections and checks the
closed formulas used in the Poisson proof. Its deterministic output is
[`2026-07-16-c219-repair-reliability.json`](2026-07-16-c219-repair-reliability.json).

## Prior-art and novelty boundary

Reliability polynomials, deletion--contraction methods, pivotal influences, Russo--Margulis, and
dependency-graph Poisson approximation are classical. The proof lens and cautions are recorded in
[`expert-personas/janson-odonnell-reliability-thresholds.md`](expert-personas/janson-odonnell-reliability-thresholds.md),
with load-bearing references to Janson's Poisson approximation work, O'Donnell's Boolean-functions
text, and Friedgut--Kalai's symmetric threshold theorem.

A bounded search found adjacent work on Poisson approximation, random covering designs, and random
hypergraphs that *contain spanning Steiner systems*. The last problem is different from asking
whether a random vertex subset of a fixed Steiner system contains one block. No source was found
that states the two C218 repair limits or the common-nucleus bottleneck in complete-port language.
These are none-found application claims, not priority claims.

## Disposition

C219 meets its promotion gate with an exact general recurrence/influence calculus and two uniform
Steiner threshold laws. The strongest new content is the contrast between a genuine sparse
Poisson repair window at the nucleus and a series bottleneck at every curve target. This is a clean
section-level contribution and operational interpretation, but the underlying probability tools
are classical; it should support a repair-ports paper rather than be sold as a stand-alone
probability theorem.

The next lane task is C220, but its stop rule remains binding: begin only from a sharply stated
additive equality or stability conjecture.
