# C235 capacitated batch-repair region

**Lane:** `rp-next`
**Status:** COMPLETE. The one-round integral and fractional regions are the standard recovery-set
service regions, specialized to a fixed failed target set. A common-helper proposition isolates the
series bottleneck, and the q=9 harmonic two-target region has exact symmetry-reduced primal and
dual certificates.

## Result

Let `M` be a represented matroid on `E`, let `T subseteq E` be the coordinates unavailable at the
start of a repair round, and put `U=E\T`. For each `t in T`, let `R_t^U` be the inclusion-minimal
radius-`r` repair sets for `t` contained in `U`. Give each live helper `u in U` capacity `c_u`.

The **fractional one-round service region** is

```text
S_F(T,U,c) = {lambda in R_+^T : there are x_(t,A) >= 0 such that
                sum_(A in R_t^U) x_(t,A) = lambda_t              for every t,
                sum_(t,A: u in A) x_(t,A) <= c_u                for every u }.
```

For integral `c`, the **integral one-round service region** `S_I(T,U,c)` uses the same equations
with `x_(t,A)` and hence `lambda_t` nonnegative integers. Thus `S_I subseteq S_F intersect Z^T`,
with possible strict containment. The total fractional throughput is the packing LP

```text
max sum_(t,A) x_(t,A)
subject to sum_(t,A: u in A) x_(t,A) <= c_u,  x >= 0,               (1)
```

whose dual assigns nonnegative helper prices `y_u`:

```text
min sum_u c_u y_u
subject to sum_(u in A) y_u >= 1 for every labeled repair (t,A).    (2)
```

The target label matters: the same helper set used for two different targets represents two
different jobs.

### Proposition 1 — a mandatory helper gives an exact simplex under slack elsewhere

Suppose every `R_t^U` is nonempty and one helper `z` lies in every repair in every `R_t^U`. Then

```text
S_F(T,U,c) subseteq {lambda >= 0 : sum_t lambda_t <= c_z}.          (3)
```

If also `c_u >= c_z` for every other helper, equality holds. For integral capacities the analogous
integer equality holds:

```text
S_I(T,U,c) = {lambda in Z_+^T : sum_t lambda_t <= c_z}.             (4)
```

Indeed, summing all routed demand gives the load at `z`, proving (3). Conversely, choose one repair
`A_t` for each target and route all `lambda_t` through it. No helper receives more than the total
load `sum_t lambda_t`. The same construction is integral when `lambda` is integral. This is a port
statement rather than a finite-table observation: a common series helper completely determines the
region whenever every other capacity is at least its capacity.

## Exact q=9 harmonic separation

Use C218's quartic--nucleus system over `GF(9)`. Its ten curve points carry the harmonic Steiner
system `S(3,4,10)`, and every radius-four repair of a curve target `t` is

```text
{N} union (B\{t}),  where B is a harmonic block containing t.      (5)
```

Take two failed curve targets `T={0,infinity}`. A one-round repair may not use the other failed
target. Of the 12 harmonic blocks through either target, four also contain the other target, so
exactly eight admissible repairs remain for each. There are eight live ordinary curve helpers.
Every such helper lies in exactly three admissible repairs for `0` and three for `infinity`: a pair
of points lies in four blocks of `S(3,4,10)`, and exactly one of those blocks contains the other
failed target.

Give every ordinary curve helper the common capacity `c` and the nucleus capacity `c_N`. For fixed
rates `(lambda_0,lambda_infinity)`, distribute each target's traffic uniformly over its eight
repairs. Every ordinary helper then has load

```text
3(lambda_0+lambda_infinity)/8,
```

while `N` has load `lambda_0+lambda_infinity`. Conversely, summing the eight ordinary capacity
constraints counts each job three times, and the nucleus constraint counts each job once. Hence the
entire fractional region, not merely its maximum-sum point, is

```text
S_F = {(lambda_0,lambda_infinity) >= 0 :
       lambda_0+lambda_infinity <= min(c_N, 8c/3)}.                 (6)
```

Equitably averaging the eight repairs of each target reduces (1) to two variables `a,b`, the flow
on each repair of the two targets:

```text
maximize 8(a+b)
subject to 3(a+b) <= c,  8(a+b) <= c_N,  a,b >= 0.                 (7)
```

This is the promised structured reduction; no unstructured q=9 optimizer is needed.

### Matching primal and dual certificates

At unit capacity `c=c_N=1`, put flow `1/16` on each of the 16 labeled repairs. This serves
`(1/2,1/2)`, loads `N` exactly to one, and loads every ordinary helper to `3/8`. In the dual, put
weight one on `N` and zero elsewhere. Every repair is covered and the dual value is one, so

```text
max fractional total throughput with N = 1.                        (8)
```

If the nucleus constraint is removed (equivalently `c_N=infinity`), put flow `1/6` on every labeled
repair. Each ordinary helper has load one and the served vector is `(4/3,4/3)`. The matching dual
puts weight `1/3` on each of the eight ordinary helpers: every three-helper support has weight one
and the dual value is `8/3`. Therefore

```text
max fractional total throughput without the N bottleneck = 8/3.   (9)
```

The unit-capacity integral regions are also exact:

```text
with N:     {(0,0),(1,0),(0,1)},
without N: {(i,j) in Z_+^2 : i+j <= 2}.                            (10)
```

In particular, the two distinct unit requests `(1,1)` can be assigned disjoint ordinary
three-helper supports, but cannot be served when both supports must also consume the unit-capacity
nucleus.

This is a strict availability-versus-throughput statement in the defensible sense. Each failed
curve target still has eight distinct locality-four repair alternatives after conditioning on the
other failure, and the ordinary-helper subsystem supports both unit requests simultaneously. Yet
the represented repair equations all pass through one common coordinate, so the actual integral
batch throughput is one and the fractional capacity falls from `8/3` to one. The conclusion is not
that the usual disjoint-repair availability number misses the nucleus: C218 already gives each
curve target `(nu,tau)=(1,1)`. It is that a large family of targetwise alternatives does not imply
cross-target service, and the exact service region records that congestion without ambiguity.

## Sequential convention

The one-round regions above are static: `U` is the set live at the start of the round, and no member
of `T` can be used as a helper during that round. For sequential service, use C229's synchronous
Horn convention:

1. solve a capacitated schedule using only the current live set;
2. add every coordinate completed in that schedule to the live set at the end of the round;
3. only in the next round may those recovered coordinates occur in repair sets.

Capacities are per-round service budgets and reset at the next round. Allowing a coordinate to be
recovered and consumed inside the same LP would create order-dependent or circular schedules;
charging one capacity budget across the whole horizon would instead be a different dynamic
flow-control model. Neither is claimed here.

## Verification

[`2026-07-16-c235-capacitated-batch-repair.py`](2026-07-16-c235-capacitated-batch-repair.py)
reconstructs C218's `GF(9)` harmonic blocks and checks:

- 8 admissible repairs for each of `0` and `infinity` after excluding both failed targets;
- ordinary-helper degrees `3+3=6` across the two labeled repair families;
- the loads and objectives in both fractional primal/dual certificate pairs;
- by exhaustive scheduling, both integral regions in (10).

The deterministic certificate is
[`2026-07-16-c235-capacitated-batch-repair.json`](2026-07-16-c235-capacitated-batch-repair.json).

## Batch/PIR and service-rate boundary

The polytope definition is established service-rate theory, not a new invariant. Kazemi, Karimi,
Soljanin, and Sprintson define the fractional and integral service-rate regions with exactly the
recovery-set allocation and per-server capacity constraints above, identify the fractional problem
with fractional matching, and show that the unit-capacity integral setting specializes to multiset
primitive batch codes and repeated single-file demands to PIR codes:
[arXiv:2001.09146](https://arxiv.org/abs/2001.09146). Aktas, Joshi, Kadhe, Kazemi, and Soljanin give
the broader coded-storage service-rate formulation and its batch-code connection:
[arXiv:2009.01598](https://arxiv.org/abs/2009.01598).

Classical batch/PIR definitions primarily request information symbols. Because the targets here are
stored projective-system coordinates, the closest current static language is the all-symbol version:
Boruchovsky, Gruica, Niemann, and Yaakobi require disjoint recovery sets for arbitrary multisets of
stored columns in [arXiv:2601.04041](https://arxiv.org/abs/2601.04041). C235 is narrower in one
direction and richer in another: it fixes a particular failed target set, forbids self-service and
other failed targets as helpers, and computes its capacitated fractional and integral regions; it
does not prove a worst-case all-symbol batch/PIR property or construct a new batch/PIR code.

The three full texts were read from cache keys `arXiv:2001.09146`, `arXiv:2009.01598`, and
`arXiv:2601.04041`, with SHA-256 values respectively
`a52f36467c4aba2deffaa0df820e98f7d43d6c82b1ca96a7c90db890000571b9`,
`35325300b0e98e951ab362a3ab3ada74f344b0008c99db27d68f3872a5aaed5f`, and
`64d12f7e49d474c8db407ff341cc2e8cab800a88ad8cbf078244579068933062`.

## Disposition

C235 passes its bounded gate. The general common-helper proposition accompanies the exact harmonic
calculation; the q=9 LP is symmetry-reduced and has matching primal/dual certificates; the
sequential-helper convention is fixed; and the service-rate/batch/PIR boundary is explicit. The
novelty candidate, under the repository's none-found convention, is only the exact application to
the quartic--nucleus repair port and its clean `8/3`-to-`1` bottleneck certificate, not the service
polytope itself.

The next lane task is C236's cubic/harmonic flagship closure comparison.
