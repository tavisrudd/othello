# C150 — structural explanation of Q25 multiplicity

**Lane**: `alt-orbit-repair`

**Date:** 2026-07-15
**Status:** REPORTED — moment-only route rejected; five residual minimizer classes clear C151 gate

## Goal

Explain the externally observed minimum of 32 legal conjugate pairs in the exceptional Q25 profile
`(f,e)=(2,3)` by a small moment/collision inequality, stopping before any census-sized formal
artifact.

## Exact starting point

Here `E=17`, `N=10`, and `M=12`. The checked aggregate balance specializes to

```text
L + 17*12 = 17*10 + B + R,
L = B + R - 34.
```

Thus the target `L≥32` is exactly the coupling inequality `B+R≥66`. Separate extrema from the
existing census, `B≥18` and `R≥42`, prove only `L≥26`; the remaining six cannot come from treating
invisibility and collision redundancy independently.

For the 170 candidate pairs on empty carriers, let `n_j` count charge multiplicity `j`. Then

```text
sum n_j = 170,
L = n_0,
204 - B = sum j*n_j,
R = sum (j-1)*n_j  (j≥1),
T = sum choose(j,2)*n_j,
2T = empty-nonfixed second moment.
```

The known minimum witness has `B=23`, `R=43`,
`(n_0,n_1,n_2,n_3,n_4)=(32,101,31,6,0)`, and moment split `(18,94,98)`.

## Scout

1. Extend a lane-local copy of the independent C++ enumerator to aggregate compact tuples
   `(L,B,R,fixedMoment,occupiedMoment,emptyMoment,n_0,…,n_4)`.
2. Test whether `L`, or equivalently `B+R`, is forced by a smaller tuple and identify the strongest
   low-dimensional inequality valid over all normalized arcs.
3. Form the corresponding integer LP in the multiplicity counts plus any genuinely geometric
   moment constraints; seek a short dual certificate for `B+R≥66`.
4. Stop if every successful inequality encodes essentially the full coordinate census.

The C99 enumerator is owned by the Baer lane and remains unchanged. C150 uses
`notes/2026-07-15-c150-f2-structure-enumerator.cpp` as its lane-local scout.

## Census result

The lane-local C++ scout independently preserves the established 469,600 normalized-arc census and
minimum 32. The full legal-count histogram is:

```text
32:1600  33:1200  34:2800  35:5600  36:12000  37:26000
38:39000 39:65200 40:73600 41:85800 42:68200 43:43000
44:29200 45:10400 46:4400 47:1600
```

Only nine invisibility values occur. Their empirical collision frontier is:

```text
B       18 19 20 21 22 23 24 25 26
min R   52 50 51 46 46 43 42 42 44
B+minR  70 69 71 67 68 66 66 67 70
```

Thus the exact target `B+R≥66` is visible as a clean coupled frontier, with equality only at
`(B,R)=(23,43)` and `(24,42)`.

The first moments collapse to exact functions of `B` on every enumerated arc:

```text
fixed first moment    = 34
occupied first moment = 230 + 2B
empty first moment    = 408 - 2B.
```

This is structurally clean but insufficient. Fixed/occupied second moments leave legal-count width
10; all first and second moments together leave width 8; `(n₂,n₃,n₄)` leaves width 7. No tested
proper compact tuple determines `L`.

## Moment/LP disposition

`notes/2026-07-15-c150-aggregate-lp-check.py` grants the aggregate model the separately observed
strong inputs `B≥18` and empty endpoint moment at least 96. It still admits

```text
L=8, B=18, R=24, T=48, (n₀,n₁,n₂,n₃,n₄)=(8,154,0,0,8).
```

Even adding the separately observed global minimum `R≥42` yields only `L≥26`, attained in the
uncoupled LP at `(B,R)=(18,42)`. Therefore a short proof of 32 cannot be extracted from these
aggregate moments or their separate extrema. It needs either a new genuinely geometric `B/R`
coupling or a small residual classification. C150 stops the moment-only route here, as required by
its decision gate.

## Minimizer classification gate

The 1,600 minimum arcs have four compact moment/multiplicity tuples, each occurring 400 times, but
the residual projective action refines them into exactly five classes. The ordered fixed-pair
stabilizer in `PGL(3,5)` has order 400. Direct action on all minimizers gives:

```text
canonical orbit triple   class size   stabilizer
65,93,154                    200           2
65,96,216                    400           1
65,98,251                    400           1
65,119,232                   200           2
65,123,279                   400           1
```

The class sizes sum to 1,600, and the action maps every member back into the minimum set. This
clears C151's explicit go/no-go gate: the minimum set collapses to five residual equivalence
classes, three free and two with involutory stabilizer. C151 should use these five representatives
for constructions/equality classification and seek a compact universal coverage-count certificate
for `L≥32`; it should not emit 32 explicit legal witnesses for every normalized row.

## Reproduction

The scout was compiled with `g++ -O3 -std=c++20 -Wall -Wextra -Wpedantic` and run on one pinned
core. It completed in 4.08 seconds with 5,568 kB peak RSS. All internal identities, the 170-candidate
count, group order 400, minimum-set closure, and class-size total are asserted by the executable.
The aggregate LP checker completed in 0.86 seconds.

```text
f30a89c97c3470ee15a2556953e04ea77f45bb29b5fd00df0a388b218ef4bd53  c150-f2-structure-enumerator.cpp
baa9cdda9142c78af897fde810285a2d86fce8a988e980205fb221c6c97649ab  c150-aggregate-lp-check.py
```

The five-class result remains independently reproducible computational evidence until C151
promotes the residual action and exact minimum through a checked certificate.
