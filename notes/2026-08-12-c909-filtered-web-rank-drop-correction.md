# C909 — signed-jet correction confirms the filtered-web rank profile

Date: 2026-08-12

Status: bounded correction and confirmation of the rank target; no manuscript,
PDF, mirror, or Lean edit

## Finding

The first diagnostic mistakenly discarded the sign recording whether a jet
hits the right endpoint of an oriented bracket.  Restoring that sign removes
the apparent special cross-ratio rank drops and confirms the proposed rank
profile in the tested domains.

For a noncrossing matching `m`, let

```text
 f_m(u)=product_{(i,j) in m}(u_j-u_i),
 J_S(f)=[w_S] f(t-w).
```

The exact sign in a jet is

```text
 J_S(f_m)=(-1)^(number of right endpoints in S)
          product_{edges disjoint from S}(t_j-t_i),
```

provided `S` meets every matching edge at most once, and is zero otherwise.
Keeping that sign, exact Gaussian elimination over finite fields gives the
following ranks for the map comprising all jets of order `<r`:

```text
 semilength n=3:  (0,1,4,5),
 semilength n=4:  (0,1,6,13,14).
```

They are constant in exhaustive collision-free tests over `F_11` and
`F_13`.  They are exactly the ranks predicted by the Dyck-height filtration:
if `B(n,h)` counts paths of height at most `h`, then

```text
 rank(jets of order <r)=C_n-B(n,n-r).
```

Indeed the exact-height multiplicities are `(1,3,1)` for `n=3` and
`(1,7,5,1)` for `n=4`; reading the cumulative ranks in the reverse
osculating order gives the displayed arrays.  The earlier unsigned pilot
produced spurious special cross-ratio drops solely because it discarded the
right-endpoint sign.

Thus the numerical target survives and the supposed rank-drop
counterexamples are withdrawn.  This still does not prove saturation or the
Smith factors: exact rank over several finite fields cannot replace the
nested unit-minor theorem.  The finite-etale divided-power saturation theorem
is independent and remains proved by rank-one square-zero generation.

## Structural meaning

The corrected filtration is compatible with maximum Dyck height.  The first
two exact profiles

```text
 C_3=5:   graded increments 1,3,1;
 C_4=14:  graded increments 1,5,7,1
```

are precisely the exact-height multiplicities read in reverse osculating
order.  The raw jets nevertheless remember which endpoint of an oriented
bracket is hit, so any crown proof must retain the oriented sign while
constructing its unitriangular basis.

The most plausible structural object is the osculating filtration of the
two-row Specht/Kempe module at a configuration of points on `P^1`.  Its
associated graded should be computed as an `sl_2`/Specht filtration, not by
termwise first-return decomposition of unoriented webs.

## Reproducibility boundary

This note records a bounded exact diagnostic, not a paper-facing theorem.
The check enumerated all `2n`-subsets of:

```text
 F_11 for n=3 and n=4,
 F_13 for n=4,
```

using exact modular Gaussian elimination on the signed formula above.
Before any promotion, the calculation must be packaged under the repository
reproducibility conventions with a primary script, frozen output, hashes,
and an independent replay.  The mathematical next step is a symbolic proof
of the corrected rank sequence, not a larger finite census.

## Crown consequence

The clean top-tier crown remains:

> Identify the intrinsic osculating filtration of the two-row Specht/Kempe
> module, prove its saturated integral associated-graded theorem, and then
> derive the exact all-degree Hodge/product Smith groups of finite-etale
> elliptic-power presentations.

The rank target now has stronger exact evidence, but the load-bearing
saturated nested-minor theorem remains open.
