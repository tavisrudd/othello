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

For fixed `s` and `q -> infinity`, the candidate asymptotic consequence is

```
k >= sqrt(s(s-1)q) + (s+1)/2 - O_s(q^(-1/2)).
```

The classical first-moment argument has the same leading term but only the
additive threshold `1/2`; thus the second moment appears to improve the
additive term by `s/2`.  At `s=2`, the degree and pair-packing bounds are
equalities and this specializes to the paper's existing `3/2` term.

## Gates before manuscript work

1. Prove the intrinsic identity, clique decomposition, and stability statements
   with all edge cases (`nu=1`, holes, incomplete arcs) explicit.
2. Make the scalar optimization rigorous, including floors and the range in
   which its maximum occurs at `T`; prove an explicit asymptotic error term.
3. Compare the numerical bound with Alabdullah--Hirschfeld and other general
   complete `(k,s)`-arc bounds at full-text depth.
4. Audit whether the higher-secants second-moment inequality or its additive
   improvement is already known.  No novelty verdict is made yet.
5. Test structured curve-derived families where `t`, `d(a)`, or `nu` are known;
   this decides whether the intrinsic theorem has applications beyond the
   universal bound.

