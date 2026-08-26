# C969 even diagonal tangent certificate

Let `q=2^m>=8` and let the full-length PRS code have redundancy
`r=q-1`, equivalently dimension two. In divided-power syndrome coordinates
consider

```text
s = e_(r-2).
```

Then `s` has exact syndrome distance `r`. Consequently the covering radius is
`r`, and `s` is a deep-hole direction.

## Direct locator proof

A degree-`t` locator `L=(L_0,...,L_t)` belongs to the Hankel kernel of `s`
exactly when each coefficient selected by a shift through coordinate `r-2`
vanishes.

For `t<=r-2`, the last two available shifts force `L_t=L_(t-1)=0` at
`t=r-2`, with the same degree defect after truncation for smaller `t`. Such a
locator cannot split into `t` distinct projective roots. Hence the distance is
at least `r-1`.

At `t=r-1`, the single Hankel equation is

```text
L_(r-2)=0.
```

A split locator containing infinity has affine degree `r-2`, so this
coefficient is its nonzero leading coefficient and cannot vanish. A split
locator with finite root set `A`, `|A|=r-1=q-2`, has

```text
L_(r-2) = -sum_(a in A) a.
```

The sum of all elements of `F_q` is zero. Thus `sum A=0` would say that the
two-element complement `{b,c}` also has sum zero. In characteristic two this
forces `b=c`, contradicting distinctness. No degree-`r-1` locator exists.

Any fixed `r` NRC columns form a basis of the syndrome space, so the general
redundancy upper bound supplies a degree-`r` representation. The distance is
therefore exactly `r`, and its existence forces covering radius `r`.

The orbit qualification is essential. For `e_(r-2)+lambda e_(r-1)`, the
terminal locator equation prescribes a generally nonzero root sum; two
distinct complementary elements can then realize it. C969 therefore compares
the exact semilinear canonical form with that of `e_(r-2)` and does not promote
the whole tangent carrier.

## Prior-art boundary

The radius is not new. Wu--Ding--Chen, Theorem 17(1), proves that for even
`q` and `k in {2,q-2}`, the covering radius of `PRS(k)` is `q-k+1`; at `k=2`
this is `q-1=r`.
[arXiv:2312.05534](https://arxiv.org/abs/2312.05534)

Xu gives explicit even-characteristic deep-hole families for the same two
dimensions; the `k=2` polynomial family is the received-word counterpart of
this distinguished syndrome direction.
[DOI 10.1051/wujns/2023281015](https://doi.org/10.1051/wujns/2023281015)

C969's contribution is the dimension-independent locator proof in its own
syndrome convention, exact semilinear orbit recognition, and a positive deep
certificate that independently replays the orbit, distance criterion, and
radius source. It also exposes the first higher-redundancy executable instance
at GF(16)/R15 and resolves the distinguished GF(8)/R7 direction without an
exponential locator search.

## Certificate route

Deep-certificate registry version 2 checks:

1. `p=2`, `r+1=q`, and valid full-projective request shape;
2. exact canonical equality with the `e_(r-2)` normal form;
3. intrinsic tangent-family detection;
4. distance `r`, the fixed locator/complement criterion, and the imported
   radius-source label; and
5. the canonical transporter by recomputation.

GF(8)/R7 is also checked independently by the exhaustive locator decoder:
`e_5` has distance seven, while `e_5+e_6` has distance six. A complete audit
of the 46 frozen nonpersistent semilinear representatives gives 45 at distance
six and only the fixed central nucleus `e_3` at distance seven. Generating the
persistent recurrence inventory gives two tangent and two sigma orbits: only
the nine-direction `e_5` tangent orbit has distance seven. Hence q8/R7 has
exactly ten projective deep-hole directions in two orbits, and certificate
version 3 replays the complete per-input locator decision. GF(16)/R15 checks
the formula certificate directly.
