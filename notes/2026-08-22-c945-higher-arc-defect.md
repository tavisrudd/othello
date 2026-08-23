# C945 — prescribed-hole defects for higher arcs

**Lane:** `relconic`

**Date:** 2026-08-22

**Status:** active theorem-development and literature-audit phase; the manuscript is
untouched pending a go/no-go gate.

## Objective

Determine the natural theorem level of the prescribed-hole defect method for
complete `(k,s)`-arcs.  Promote the extension only if it yields structural rigidity
or a sharper general bound, rather than merely a formally broader identity.

## Candidate intrinsic theorem

Let `A` be a `(k,s)`-arc in a projective plane of order `q`.  Let `E_s(A)` be
the linear `s`-uniform hypergraph on `A` whose edges are the intersections of
the `s`-secants with `A`, and let `nu` be its matching number.  Write `t` for
the number of `s`-secants, `d(a)` for the number through `a`, and `r(x)` for
the number through an external point `x`.  Then

```
S1 = t(q+1-s),
S2 = C(t,2) - sum_a C(d(a),2).
```

For prescribed holes `H`, covered required locus `X`, and
`I_H = sum_{h in H} r(h)`, the proposed defect is

```
Delta_H = S1 - 2 S2/nu - I_H/nu - |X|,

nu Delta_H
  = sum_{x in X} (r(x)-1)(nu-r(x))
    + sum_{h in H} r(h)(nu-r(h)).
```

The cap `r(x) <= nu` is sharper than the elementary
`r(x) <= floor(k/s)`: the concurrent `s`-secants give a matching in
`E_s(A)`.

Every disjoint pair of hyperedges meets at a unique external point.  Hence the
concurrence classes canonically decompose the disjointness graph of `E_s(A)`
into cliques.  At zero defect every nontrivial clique has order `nu`; covered
required points have index `1` or `nu`, and holes have index `0` or `nu`.
The existing edge- and vertex-deletion stability proofs appear to transfer with
`floor(k/2)` replaced by `nu`.

## Multiplicity extension

The natural two-moment statement allows a uniform required multiplicity
`lambda`, not only ordinary coverage.  Let every non-hole required point lie on
between `lambda` and `M` members of a line family, where `M` is a global index
cap.  With `R` the required locus, the exact identity is

```
(M+lambda-1)S1 - 2S2 - lambda I_H - lambda M |R|
  = sum_{x in R} (r(x)-lambda)(M-r(x))
    + sum_{h in H} r(h)(M-r(h)).
```

Indeed, the required-point summand expands to
`(M+lambda-1)r-2C(r,2)-lambda M`, and the hole summand results after
subtracting `lambda r`.  Both are nonnegative.  Equality permits required
indices only in `{lambda,M}` and hole indices only in `{0,M}`.  For
`lambda=1` this is the original prescribed-hole defect.

Applied to the `s`-secants of a `(k,s)`-arc with `M=floor(k/s)`, this
defines a `lambda`-fold maximal-secant covering problem.  The candidate
fixed-`s,lambda` asymptotic bound is

```
k >= sqrt(lambda s(s-1)q) + (s+1)/2 - O_{s,lambda}(q^(-1/2)).
```

The cancellation leaving the additive term independent of `lambda` is a
feature to verify carefully: the `(lambda-1)S1/M` gain and the second-moment
loss cancel at order `q^(3/2)` except for the same `s`-dependent residue as
at `lambda=1`.

## Equality archetypes

The multiplicity theorem organizes several standard embedded designs by the
two roots of the same quadratic.

- A maximal arc of degree `s` has `k=(s-1)q+s`, line characters `0,s`,
  and every external point lies on `k/s=M` `s`-secants.  It is an upper-root
  equality family.
- A unital in a plane of order `q^2` has `k=q^3+1`, `s=q+1`, and line
  characters `1,s`.  Counting its points over the `q^2+1` lines through an
  external point gives exactly `q^2-q` `s`-secants.  Since
  `floor(k/s)=q^2-q+1`, it is a lower-root equality family for
  `lambda=q^2-q`.
- A Baer subplane of order `q` in a plane of order `q^2` has
  `k=q^2+q+1`, `s=q+1`, and line characters `1,s`.  The same pencil count
  gives exactly one `s`-secant through every external point, the lower-root
  equality family for `lambda=1`.

Thus the proposed theorem does more than repackage completeness: it places
ordinary complete arcs, maximal arcs, unitals, and subplanes in one
maximal-secant concurrency framework.  This is the current positive answer to
the structural/notability gate, subject to precedence checking.

## Candidate new numerical consequence

Put

```
M = floor(k/s),
D = floor((k-1)/(s-1)),
T = floor(k(k-1)/(s(s-1))),
C = 1 + s(D-1),
L = q+1-s.
```

The `s`-secant hypergraph is linear, so `t <= T`; moreover
`d(a) <= D` and `sum_a d(a)=st`.  Consequently

```
2 S2 = t(t-1) - sum_a d(a)(d(a)-1)
     >= t max(0,t-C).
```

For a complete `(k,s)`-arc, or with `h` prescribed holes outside which all
points are covered, this would give

```
q^2+q+1-k-h
  <= max_{0 <= t <= T} [tL - t max(0,t-C)/M].
```

There is a sharper one-dimensional integer envelope.  For fixed `t`, maximize
`sum_a C(d(a),2)` subject to `0 <= d(a) <= D` and
`sum_a d(a)=st`: if `u=floor(st/D)` and `v=st-uD`, the convex maximum is
`u C(D,2)+C(v,2)`.  Thus one may replace the coarse lower bound on `S2` by

```
G(t) = C(t,2) - u C(D,2) - C(v,2),
```

and maximize `tL-2 max(0,G(t))/M` over the feasible integer range
`t <= min(floor(k(k-1)/(s(s-1))), floor(kD/s))`.  The coarse display is
retained because it exposes the asymptotics.

When the coarse objective is increasing through its feasible range, replacing
floors by safe real relaxations gives the clean necessary inequality

```
q^2+q+1-k-h
 <= k(k-1)(q+1-s)/(s(s-1))
    - (k-1)(k-s)(k-s^2+s-1)/(s(s-1)^2),
```

for `k >= s^2-s+1`.  The factorization follows from
`P-Cbar=(k-s)(k-s^2+s-1)/(s(s-1))`, where
`P=k(k-1)/(s(s-1))` and `Cbar=1+s(k-s)/(s-1)`.

For fixed `s` and `q -> infinity`, the candidate asymptotic consequence is

```
k >= sqrt(s(s-1)q) + (s+1)/2 - O_s(q^(-1/2)).
```

The classical first-moment argument has the same leading term but only the
additive threshold `1/2`; thus the second moment appears to improve the
additive term by `s/2`.  At `s=2`, the degree and pair-packing bounds are
equalities and this specializes to the paper's existing `3/2` term.

## Literature status

- Alabdullah--Hirschfeld, *A new lower bound for the smallest complete
  `(k,n)`-arc in `PG(2,q)`*, Designs, Codes and Cryptography (2019), DOI
  `10.1007/s10623-018-00592-8`: **full text**, published open-access PDF,
  cache key `10.1007/s10623-018-00592-8`, SHA-256
  `b70116f426fb6ca1e733fafc4d2f6434993c55006ba900344b7bfa4abbd32961`.
  Their Theorem 2.1 combines completeness with the pair-packing upper bound
  on the number of `n`-secants.  It uses only the first external coverage
  moment; no second external concurrency moment or additive refinement appears.
- Bastioni--Micheli, *On complete m-arcs*, arXiv:2303.13670v1:
  **partial**, abstract, introduction, and arc definitions; cache SHA-256
  `f5eb03dab26f3cc701d9917db70d85409629174fc5ac279c59bbca1505517c40`.
  This establishes direct topical adjacency through constructions from curves,
  but has not yet been used for a novelty verdict.
- Korchmaros--Nagy--Szonyi, *Algebraic approach to the completeness problem
  for `(k,n)`-arcs in planes over finite fields*, arXiv:2302.10162v1 / later
  JCTA 204 (2024): **partial**, abstract and introduction; cache SHA-256
  `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`.
  This confirms the maximal-secant coverage formulation and the relevance of
  prescribed uncovered loci.  No absence claim rests on this partial read.

The audit currently has one full-text source and two partial sources.  A
novelty or priority verdict remains open.

## Gates before manuscript work

1. Prove the intrinsic identity, clique decomposition, and stability statements
   with all edge cases (`nu=1`, holes, incomplete arcs, and uniform required
   multiplicity `lambda`) explicit.
2. Make the scalar optimization rigorous, including floors and the range in
   which its maximum occurs at `T`; prove an explicit asymptotic error term.
3. Compare the numerical bound with Alabdullah--Hirschfeld and other general
   complete `(k,s)`-arc bounds at full-text depth.
4. Audit whether the higher-secants second-moment inequality or its additive
   improvement is already known.  No novelty verdict is made yet.
5. Test structured curve-derived families where `t`, `d(a)`, or `nu` are known;
   this decides whether the intrinsic theorem has applications beyond the
   universal bound.
