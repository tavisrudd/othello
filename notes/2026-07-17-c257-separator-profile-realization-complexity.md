# C257 — separator-profile realization complexity

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — kill condition met. The two proposed realization costs are coordinate
projections of the established Pareto Hamming-embedding frontier, after taking a lower envelope
over full metric completions of the truncated profile. On full profiles, C246's private-gadget
bound is exactly the standard nonoptimal frontier point already recorded in that literature. Exact small tables would
therefore be instances of an existing optimization problem, not the required new compression
theorem or lower-bound family.

## Exact translation

Let `A={f_1,...,f_N}` be the active columns of a C246 realization in `B direct_sum U`, and put

```text
L = span(A),                 S = L intersection B,
psi : GF(q)^N -> L,          psi(e_i)=f_i,
C = psi^{-1}(S).
```

The active profile is the radius-`r` truncation of the quotient Hamming weight on `S` induced by
the restricted surjection `psi|C:C->S`; vectors of `B-S` have value `infinity`. Conversely, such
a Hamming-subspace quotient embeds in a projective metric space and supplies active columns with
the same truncated boundary profile. Thus this is an equivalence, not merely a resemblance.

Write

```text
s = dim(S),
a = dim(L)-dim(S),
b = N-dim(L).
```

Because `L` is a subspace of `B direct_sum U` and `L intersection B=S`, projection to `U` has rank
`dim(L)-dim(S)`. After removing unused auxiliary coordinates, `a` is exactly C257's auxiliary
dimension, while

```text
N = s+a+b                                                     (1)
```

is exactly its active-column count.

Riccardi and Sauerbier Couvee define an `(a,b)` Hamming embedding of an `s`-dimensional weighted
space by precisely a surjection from `GF(q)^(s+a+b)` onto an `(s+a)`-dimensional projective metric
space containing it. They call the Pareto-minimal pairs its **embedding frontier**. Consequently,
if `Comp_r(d)` denotes all pairs `(S,w)` where `S<=B`, `w` is a finite scale-invariant integral
weight on `S`, and

```text
trunc_r(w)(x)=d(x) for x in S,       d(x)=infinity for x outside S,
```

then the exact C257 objectives are

```text
mu_col(d) = min { s+a+b : (S,w) in Comp_r(d), (a,b) in Front(w) },
mu_dim(d) = min { a       : (S,w) in Comp_r(d), (a,b) in Front(w) }.   (2)
```

For profiles finite on all of `B`, `S=B`; only the lower envelope over full weights whose
radius-`r` truncation is `d` remains. For profiles with infinities, allowing a proper `S` also
captures active columns that never span those boundary directions. Equation (2) therefore covers
the truncation wrinkle without charging C246's optional dormant `(r+1)`-column spanning gadgets.

## The private construction is the published baseline

For a profile finite on all projective points of `S`, let `p_1,...,p_P` be representatives and
put `t_i=w(p_i)`. C246's private gadget uses

```text
N_private = sum_i t_i,
a_private = sum_i (t_i-1),
b_private = P-s.                                             (3)
```

Example 52 of Riccardi--Sauerbier Couvee gives exactly the frontier-feasible point

```text
(a,b) = (sum_i(t_i-1), P-s)
```

and explicitly notes that it is often not Pareto optimal. For truncated profiles C246 simply omits
the infinite-point gadgets; the resulting generating family induces one of the full completions in
(2), but need not equal Example 52's private construction for that completion. Their Example 54
nevertheless gives a uniform Pareto-optimal strict compression for every full scale-invariant
weight on `GF(2)^2`. The proposed compression phenomenon is therefore already present at theorem
level, not merely anticipated by neighboring work.

## Literature boundary

- Riccardi and Sauerbier Couvee, [*Fundamental Notions of Projective and
  Scale-Translation-Invariant Metrics in Coding Theory*](https://arxiv.org/abs/2505.06388),
  Sections 5.2--5.3, supply the exact Hamming-subspace/projective-embedding correspondence, define
  the two-parameter Pareto embedding frontier, identify (3), and give a uniform Pareto-optimal
  binary two-dimensional construction. Full text was checked from cache key `arXiv:2505.06388`, SHA-256
  `c765607134f8ed0b3fbd02cbbd8305c70b03ef7eb93bed5b32283a6f32cda38f`.
- D'Oliveira and Firer's [*Minimum dimensional Hamming
  embeddings*](https://doi.org/10.3934/amc.2017029) optimizes Hamming-cube dimension only after
  passing to **decoding equivalence**. That is a related but weaker objective: C246/C257 require
  the labeled exact quotient weights through radius `r`, not merely the same nearest-neighbor
  decisions.

The focused search found no basis for renaming the embedding frontier as separator-profile
realization complexity. The only residual specialization is algorithmic: enumerate metric
completions compatible with a truncation and evaluate their known frontiers. Without a new
frontier theorem or complexity separation, that does not pass C257's promotion gate.

## Disposition

Stop before constructing the requested binary/ternary optimum tables. Their entries would be
isolated evaluations of (2), precisely the outcome the task's kill clause excludes. Retain the
translation as the useful result: C246's semantic carrier is new in this lane, but minimum
column/auxiliary realization is owned by the Pareto Hamming-embedding frontier.
