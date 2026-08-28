# C973 — GF(27) two-point switch probe

**Lane:** `reed-solomon` · **Date:** 2026-08-28 · **Status:** computational probe
report; measurements only, no new proof

**Scope:** a Rust probe of the two-point affine-plane switch mechanism of
`c973-2026-08-27-gf27-four-plane-switch-pencil.md` and the one-point rational
section (16a)--(16c), measured over the carrier-syndrome strata of
`c973-2026-08-27-carrier-nucleus-compression.md` §8.3.  Everything below is a
measured quantity; no interpretation beyond what was computed.

## 1. Setup

### Field model

`K = GF(27) = F3[x]/(x^3 - x - 1)`.  The cubic is irreducible over `F3`
(`0 -> -1`, `1 -> -1`, `2 -> 2`).  Elements are the integers `0..26` read as
base-three digit vectors, `n = d0 + 3 d1 + 9 d2 <-> d0 + d1 x + d2 x^2`, with
reduction `x^3 = x + 1`, `x^4 = x^2 + x`.  The generator `x` is the element
`3`.  Addition, multiplication, negation, inversion, the squares and one square
root per square are full `27`- and `27 x 27`-entry tables.

### Hankel equations

A monic degree-nine locator `g(t) = t^9 + sum_{i=0}^{8} g_i t^i` **closes** a
carrier syndrome `z = (z_2,...,z_8) in K^7 \ {0}` iff both equations of (3) of
the three-line note hold:

```
E1(g) = sum_{i=2}^{8} z_i g_{i-1} = 0,
E2(g) = sum_{i=2}^{8} z_i g_i     = 0.
```

Neither equation involves `g_9`.  `z` is **saturated** if some *split
nine-affine* locator (nine distinct roots in `K`) closes it.  Both equations
are homogeneous in `z`, so every statistic below is invariant under
`z -> lambda z` and is a function of the projective class.

### Incidence inventory

Built from scratch and cross-checked against the notes:

| object | count | check |
|---|---|---|
| affine `F3`-lines                         | 117  | every line locator is `t^3 + p t + q` |
| affine `F3`-planes                        | 39   | every plane locator is `t^9 + A t^3 + B t + C` |
| planes through a fixed line               | 4    | asserted for all 117 lines |
| switch candidates `(L, {x1,x2}, Pi)`      | 1404 | `117 * 3 * 4`, eq (17) |

### Switch solve

For a candidate `(L,{x1,x2},Pi)` let `Q(t)` be the monic degree-seven product
over the seven roots of `P_Pi` other than `x1,x2`, and

```
S(t) = (t-x1)(t-x2) + c1 (t-x2) + c2 (t-x1).
```

`(c1,c2)` is obtained by solving the two Hankel equations applied to
`g = Q*(t-x1)(t-x2) + c1 * Q*(t-x2) + c2 * Q*(t-x1)` directly by 2x2 Gaussian
elimination on the actual coefficient vectors; the closed forms (13) of the
switch note were not used.  Per candidate the probe records

* **nonsingular**: the 2x2 determinant is nonzero (unique `(c1,c2)`);
* **zero discriminant**: `disc = beta^2 - 4 gamma = beta^2 - gamma` vanishes,
  where `S = t^2 + beta t + gamma`;
* **split distinct**: `disc` is a nonzero square (so `S` has two distinct roots
  `beta -+ sqrt(disc)`, using `2^{-1} = -1` in characteristic three);
* **good**: split distinct and both roots avoid the seven roots of `Q`.  Roots
  equal to `x1` or `x2` are allowed, per §2 of the switch note.

`n_good > 0` means `z` is saturated through this mechanism, by an explicit
nine-distinct-root locator.

### Pencil parameter and the lambda split

For a line with canonical direction `d` (so `p = -d^2`) and a containing plane
with locator `t^9 + A t^3 + B t + C`, the pencil parameter is `kappa = p^3 - A`
from eq (6); the probe also asserts `B = -kappa p` and `C = q^3 - kappa q`.
Writing `lambda = kappa / d^6`, the probe verifies numerically that

```
lambda^4 + lambda + 1 = 0    for all 117 * 4 = 468 (line, plane) pairs,
```

and `lambda^4 + lambda + 1 = (lambda - 1)(lambda^3 + lambda^2 + lambda + 2)`
over `F3` with the cubic factor irreducible.  Measured: **exactly one plane per
line has `lambda = 1`** (117/117 lines), and for all 117 lines that plane's
direction space equals `span_{F3}(d, d x)` with `x^3 - x - 1 = 0`.  The four
distinct `lambda` values realized over all `(line, plane)` pairs are
`{1, 9, 13, 16}` in the digit encoding, i.e. `1` together with one Frobenius
orbit of size three.  This splits the 1404 candidates as **351 with
`lambda = 1`** and **1053 conjugate**.

### One-point switches (eq 16c)

For each of the 39 planes `P = t^9 + A t^3 + B t + C` set `Z = z_3 A`,
`R = z_2 B + z_4 A`; if `Z != 0` put `y = R/Z` and for each of the nine roots
`x` of `P` test

```
(x - y) phi(x) + Z = 0,
phi(x) = z_2(x^6 + A) + z_3 x^5 + z_4 x^4 + z_5 x^3 + z_6 x^2 + z_7 x + z_8.
```

`n_onept` counts the pairs `(P, x)` satisfying this **and** having `y` outside
the nine roots of `P`, i.e. those for which `g = (t-y) P(t)/(t-x)` is an actual
split nine-affine locator.

### Strata

The quotient coordinates are arranged as `M_z = [[z3, z6],[z4, z7]]`
(eq 25ad); the kernel coordinates are `(z2, z5, z8)`.

* `rank0-kernel` — `M_z = 0`, the digit kernel `A = <e2,e5,e8>`; all 757
  projective classes (kernel normalized so its first nonzero coordinate is 1).
* `rank1-graph` / `rank1-offgraph` — all 784 rank-one projective quotient
  points, each with all `27^3 = 19683` kernel values, i.e. every projective
  class with rank-one quotient: `784 * 19683 = 15,431,472` syndromes,
  exhaustive.
* `rank2-random` — 20,000 uniformly random projective classes with
  `det M_z != 0`, seed `0xC973_2026_0828` (splitmix64).

### Frobenius-graph test

Writing a rank-one `M = [[a,b],[c,d]] = v w^T`, the column span is
`[v] = (a:c) = (b:d)` and the row span is `[w] = (a:b) = (c:d)`.  Four
candidate graph conditions were evaluated:

| id | condition | number of rank-one projective points |
|---|---|---|
| `graph_sigma`     | `[w] = ([v]_1^3 : [v]_2^3)`     | 28 |
| `graph_J_sigma`   | `[w] = ([v]_2^3 : -[v]_1^3)`    | 28 |
| `graph_sigma2`    | `[w] = ([v]_1^9 : [v]_2^9)`     | 28 |
| `graph_J_sigma2`  | `[w] = ([v]_2^9 : -[v]_1^9)`    | 28 |

All four are graphs of bijections of `P^1(K)`, so the count 28 does **not**
discriminate between them; the suggested test `a d^3 = c b^3` is not one of
them: for `M = v (sigma v)^T` one gets `a^2 b = c^3` and `a^3 d = c^4`, and all
28 `graph_sigma` points were checked to satisfy both, whereas only 4 of them
satisfy `a d^3 = c b^3`.  The probe therefore reports the four flags per quotient
point and additionally attempts an empirical separation: the per-fibre
statistic multiset is constant along an orbit of any group preserving the
switch family, so a statistically homogeneous 28-point class would identify the
graph orbit.  Section 4.6 records that no such class appears, and why.  The
`rank1-graph`/`rank1-offgraph` aggregate split in the tables uses
`graph_sigma`.

## 2. Replay

```
CARGO_TARGET_DIR=/home/tavis/.cache/c973-gf27-switch-probe-target \
  cargo build --release \
  --manifest-path notes/reed-solomon-tasks/c973-gf27-switch-probe/Cargo.toml
PROBE_THREADS=8 \
  /home/tavis/.cache/c973-gf27-switch-probe-target/release/probe full
```

Outputs land in `notes/reed-solomon-tasks/c973-gf27-switch-probe/out/`.
`probe bench` reruns only the geometry construction and the three sanity checks
plus a timing microbenchmark.  Seed: `0xC973_2026_0828` for the rank-two sample
and the one-point sanity check, `0x5EED_0001` and `0xABCD_1234` for the two
switch cross-checks.  Threads: 8.

## 3. Sanity checks

Verbatim from `out/checks.txt`:

```
lines: 117   planes: 39
pencil check: kappa/d^6 satisfies lambda^4+lambda+1=0 in 468/468 (line,plane) pairs;
  lines with exactly one lambda=1 plane: 117/117;
  lambda=1 plane direction equals span_F3(d, d*x) in 117 cases
switch candidates |B| = 1404
candidates with lambda = 1: 351   conjugate: 1053
distinct lambda values over all (line,plane): [1, 9, 13, 16]
sanity (16c) one-point identity: pass 200000 fail 0 (random z, plane, root; Z != 0)
sanity switch solve: Q*S closes z in 20000 cases, fails in 0
sanity n_good semantics: 5000 good candidates verified as split 9-distinct-root
  locators closing z, 0 bad
rank-one projective quotient points: 784; graph-convention counts
  [row=sigma(col), row=J.sigma(col), row=sigma^2(col), row=J.sigma^2(col)] = [28, 28, 28, 28]
total syndromes with n_good = 0 across strata: 0
wall time: 147.38 s, threads 8
```

1. **The one-point identity (16c) is confirmed.**  On 200,000 random triples
   `(z, plane, root)` with `Z != 0`, the predicate `(x-y) phi(x) + Z = 0` agreed
   with directly building `g = (t-y) P(t)/(t-x)` and testing both Hankel
   equations, in every case.  No discrepancy, so no re-derivation was needed.
2. **The switch solve is confirmed.**  On 20,000 random nonsingular candidates,
   the `(c1,c2)` obtained by Gaussian elimination was re-expanded into the
   explicit degree-nine product `Q(t) S(t)` and both Hankel equations were
   rechecked directly: 20,000 agreements, 0 failures.
3. **`n_good` means what it should.**  5,000 candidates counted as good were
   rebuilt as explicit nine-root locators and confirmed to have nine distinct
   roots in `K` and to close `z`; 0 bad.
4. **The pencil claim is confirmed.**  For every one of the `117 * 4 = 468`
   `(line, plane)` incidences, `kappa = p^3 - A` also satisfies `B = -kappa p`
   and `C = q^3 - kappa q`, and `lambda = kappa/d^6` is a root of
   `lambda^4 + lambda + 1`.  Each line has exactly one `lambda = 1` plane, whose
   direction space is `span_{F3}(d, d x)`; the other three planes carry the
   Frobenius orbit `{9, 13, 16}` of the irreducible cubic factor.

## 4. Results

### 4.1 Coverage and the headline

| stratum | syndromes (projective classes) | coverage |
|---|---:|---|
| `rank0-kernel`   | 757        | exhaustive |
| `rank1-graph`    | 551,124    | exhaustive (`28 * 27^3`) |
| `rank1-offgraph` | 14,880,348 | exhaustive (`756 * 27^3`) |
| `rank2-random`   | 20,000     | random sample, seed `0xC973_2026_0828` |
| total            | 15,452,229 | |

The rank-zero and rank-one coverage together is every projective carrier class
whose quotient matrix `M_z` has rank at most one.

**No syndrome in any stratum has `n_good = 0`.**  The two-point affine-plane
switch saturates every one of the 15,452,229 classes examined, always by an
explicit split nine-affine locator.  `out/failures.tsv` contains only its
header, and the exhaustive `C(27,9)` fallback of deliverable 2 was therefore
never triggered by a failure.  (It was still run on the extremal syndromes of
§4.4 as a cross-check.)

### 4.2 Per-stratum summary

From `out/summary.tsv` (means over the stratum; `n_good_lambda1` counts good
candidates among the 351 with `lambda = 1`, `n_good_conjugate` the other
1053):

| stratum | min `n_good` | mean `n_good` | min `n_good_lambda1` | mean | min `n_good_conjugate` | mean | min `n_onepoint` | mean |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `rank0-kernel`   | 222 | 331.99 | 57 | 83.00 | 156 | 248.99 | 0 | 0.00 |
| `rank1-graph`    |  78 | 339.33 |  0 | 84.83 |  78 | 254.50 | 0 | 8.36 |
| `rank1-offgraph` |  78 | 339.06 |  0 | 84.76 |  78 | 254.29 | 0 | 8.05 |
| `rank2-random`   | 209 | 339.57 | 44 | 84.89 | 153 | 254.67 | 0 | 8.35 |

Switch-matrix and character bookkeeping (eq (18)):

| stratum | mean `n_nonsingular` | min | mean `n_zero_disc` | mean `n_split_distinct` |
|---|---:|---:|---:|---:|
| `rank0-kernel`   | 1301.99 | 1296 | 46.37 | 604.63 |
| `rank1-graph`    | 1352.07 | 1104 | 50.08 | 626.88 |
| `rank1-offgraph` | 1350.21 | 1012 | 49.94 | 626.06 |
| `rank2-random`   | 1351.84 | 1012 | 50.12 | 627.00 |

Equation (18) is bookkeeping rather than an independent measurement: with
`Z_Delta` zero discriminants and `n_sq` nonzero-square discriminants among
`|B_ns|` nonsingular candidates, `sum chi = 2 n_sq - |B_ns| + Z_Delta`, so
`(|B_ns| + sum chi - Z_Delta)/2 = n_sq`.  The recorded triple
`(n_nonsingular, n_zero_disc, n_split_distinct)` therefore *is* the eq (18)
data, and the collision margin visible in the histogram is
`n_split_distinct - n_good`, whose mean is `626.06 - 339.06 = 287.0` on the
largest stratum and whose value at the §4.4 minimizers is `546 - 78 = 468`.
The probe did not record the joint minimum of that difference.

### 4.3 Distribution shape

Quantiles over each stratum, computed from `out/histograms.tsv`:

| metric | stratum | min | p01 | p25 | median | p75 | p99 | max |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| `n_good`            | `rank0-kernel`   | 222  | 222  | 222  | 366  | 366  | 1300 | 1404 |
| `n_good`            | `rank1-graph`    | 78   | 276  | 322  | 338  | 355  | 396  | 1404 |
| `n_good`            | `rank1-offgraph` | 78   | 278  | 321  | 338  | 356  | 397  | 1404 |
| `n_good`            | `rank2-random`   | 209  | 283  | 323  | 340  | 356  | 398  | 442  |
| `n_good_lambda1`    | `rank0-kernel`   | 57   | 57   | 57   | 84   | 84   | 325  | 351  |
| `n_good_lambda1`    | `rank1-graph`    | 0    | 63   | 78   | 84   | 91   | 105  | 351  |
| `n_good_lambda1`    | `rank1-offgraph` | 0    | 64   | 78   | 84   | 91   | 106  | 351  |
| `n_good_lambda1`    | `rank2-random`   | 44   | 65   | 79   | 85   | 91   | 106  | 127  |
| `n_good_conjugate`  | `rank0-kernel`   | 156  | 156  | 165  | 282  | 282  | 975  | 1053 |
| `n_good_conjugate`  | `rank1-graph`    | 78   | 210  | 240  | 254  | 267  | 300  | 1053 |
| `n_good_conjugate`  | `rank1-offgraph` | 78   | 206  | 240  | 254  | 267  | 301  | 1053 |
| `n_good_conjugate`  | `rank2-random`   | 153  | 210  | 242  | 255  | 268  | 301  | 337  |
| `n_nonsingular`     | `rank0-kernel`   | 1296 | 1296 | 1296 | 1300 | 1300 | 1404 | 1404 |
| `n_nonsingular`     | `rank1-graph`    | 1104 | 1294 | 1349 | 1354 | 1358 | 1369 | 1404 |
| `n_nonsingular`     | `rank1-offgraph` | 1012 | 1279 | 1348 | 1354 | 1358 | 1369 | 1404 |
| `n_nonsingular`     | `rank2-random`   | 1012 | 1287 | 1349 | 1354 | 1359 | 1369 | 1404 |
| `n_split_distinct`  | `rank0-kernel`   | 444  | 444  | 444  | 720  | 720  | 1300 | 1404 |
| `n_split_distinct`  | `rank1-graph`    | 529  | 561  | 610  | 627  | 642  | 683  | 1404 |
| `n_split_distinct`  | `rank1-offgraph` | 444  | 556  | 609  | 626  | 642  | 683  | 1404 |
| `n_split_distinct`  | `rank2-random`   | 415  | 567  | 612  | 627  | 643  | 680  | 725  |
| `n_zero_disc`       | `rank0-kernel`   | 0    | 0    | 36   | 36   | 36   | 364  | 364  |
| `n_zero_disc`       | `rank1-graph`    | 0    | 31   | 44   | 50   | 56   | 71   | 156  |
| `n_zero_disc`       | `rank1-offgraph` | 0    | 32   | 44   | 50   | 55   | 71   | 156  |
| `n_zero_disc`       | `rank2-random`   | 20   | 32   | 44   | 50   | 56   | 71   | 106  |
| `n_onepoint`        | `rank0-kernel`   | 0    | 0    | 0    | 0    | 0    | 0    | 0    |
| `n_onepoint`        | `rank1-graph`    | 0    | 0    | 6    | 8    | 11   | 16   | 21   |
| `n_onepoint`        | `rank1-offgraph` | 0    | 0    | 6    | 8    | 10   | 16   | 21   |
| `n_onepoint`        | `rank2-random`   | 0    | 0    | 6    | 8    | 10   | 16   | 24   |

### 4.4 The exact minimizers: 27 syndromes with `n_good = 78`

Across all 15,452,229 classes the minimum of `n_good` is **78**, attained by
exactly **27** projective classes, listed in full in `out/extremes.tsv` (mode
`dump`).  They are precisely

```
z = (0, 1, z4, z5, z6, z7, z8),      one class for each of the 27 values of z4,
```

with `z2 = 0`, `z3 = 1`.  In order of `z4 = 0,1,...,26` they are

```
0,1,0,0,0,0,0     0,1,1,1,2,2,2     0,1,2,1,1,2,1     0,1,3,9,8,24,26
0,1,4,16,7,19,18  0,1,5,13,6,21,23  0,1,6,9,4,24,13   0,1,7,13,3,21,16
0,1,8,16,5,19,9   0,1,9,12,23,10,21 0,1,10,4,22,23,3  0,1,11,22,21,7,10
0,1,12,20,19,8,14 0,1,13,15,18,14,19 0,1,14,3,20,18,5 0,1,15,25,24,6,17
0,1,16,11,26,17,24 0,1,17,5,25,26,4 0,1,18,12,16,10,15 0,1,19,22,15,7,20
0,1,20,4,17,23,6  0,1,21,25,12,6,22 0,1,22,5,14,26,8  0,1,23,11,13,17,12
0,1,24,20,11,8,25 0,1,25,3,10,18,7  0,1,26,15,9,14,11
```

All 27 have the identical switch profile

```
n_nonsingular = 1326, n_zero_disc = 156, n_split_distinct = 546,
n_good = 78, n_good_lambda1 = 0, n_good_conjugate = 78, n_onepoint = 0.
```

The exhaustive `C(27,9) = 4,686,825`-subset search finds **6,890** split
nine-affine locators closing each of them, so they are saturated with a wide
margin; the switch mechanism sees 78 of those 6,890.  The 27 are simultaneously
the unique minimizers of `n_good`, of `n_good_lambda1` (value 0) and of
`n_good_conjugate` (value 78).  One of them, `z = (0,1,0,0,0,0,0)`, has
quotient on the Frobenius graph under the `sigma` convention; the other 26 do
not, so this extremal set is not a graph phenomenon (see §4.6).

Under the natural degree-eight reading (`g_9 = 0`, `g_8 = 1`, i.e. the same two
Hankel equations applied to a monic degree-eight locator), 26 of the 27 admit
2,088 split eight-subsets and one, `z = (0,1,26,15,9,14,11)`, admits 2,028.
This is reported for completeness only: eq (14)/(15) of the compression note
restricts the target union to affine `S subset K` with `|S| = 9`, i.e. the
point at infinity is the *normalized forbidden point*, so an
eight-affine-plus-infinity locator is excluded by the problem statement rather
than merely hard to formulate.  The count above is not evidence that such a
locator would be admissible.

### 4.5 Does a small sub-family already suffice?

* **`lambda = 1` planes alone (351 of the 1404 candidates): no.**  `n_good_lambda1 = 0`
  for exactly 27 projective classes — the same 27 of §4.4, one in `rank1-graph`
  and 26 in `rank1-offgraph`.  Mean 84.8, median 84.
* **The three conjugate planes alone (1053 candidates): yes, everywhere covered.**
  `n_good_conjugate` never vanishes: its minimum is 78 (27 classes), 156 on
  `rank0-kernel` (27 classes) and 153 on the rank-two sample (1 class).  On all
  15,452,229 classes examined the conjugate sub-family alone already saturates.
* **One-point switches (16c) alone: no.**  `n_onepoint = 0` for all 757
  rank-zero classes (forced: `z3 = 0` makes `Z = z3 A = 0` for every plane),
  for 19,892 of the 551,124 `rank1-graph` classes, for 1,068,316 of the
  14,880,348 `rank1-offgraph` classes, and for 795 of the 20,000 rank-two
  samples — 1,089,760 classes in all, about 7.1% of the covered set.  Where it
  is nonzero it is small: mean 8.0-8.4, maximum 24.

So the sub-family question has a clean split: the single `lambda = 1` plane per
line is *not* enough, the three Frobenius-conjugate planes per line *are* enough
on everything measured, and the one-point rational sections are far from enough.

### 4.6 Quotient stratification, and what the Frobenius graph does not explain

The per-quotient-point statistics (`out/quotient_points.tsv`; the fibre
statistic multiset is constant along an orbit of any group that preserves the
switch family) partition the 784 rank-one projective quotient points into

| class | size | min `n_good` | mean `n_good` | description |
|---|---:|---:|---:|---|
| A | 702 | 256 | 339.605 | `z3 != 0`, generic |
| B |  27 |  78 | 339.605 | `z3 != 0`, the fibres of §4.4 |
| C |  27 | 254 | 331.973 | `(z3,z4,z6,z7) = (0,0,1,*)` |
| D |  27 | 227 | 331.973 | `(z3,z4,z6,z7) = (0,1,0,*)` |
| E |   1 | 274 | 331.973 | the point `(0,0,0,1)` |

The mean splits the 784 points as **729** (`z3 != 0`) versus **55** (`z3 = 0`),
and the 55 are exactly the rank-one quotient points with `z3 = 0`.  This split
is not the `{28, 756}` Frobenius-graph split of eq (25y).  Structural remark,
not a measurement: it cannot be, because the
switch family is built from affine `F3`-lines and planes and from locators with
nine *affine* roots, so it is equivariant only for the affine group
`AGammaL(1,27)` and not for the `PGL2(27)` twisted action whose orbits (25y) and
(25ab) are.  Concretely, the 28 `graph_sigma` points are distributed across the
classes as 26 in A, 1 in B and 1 in E, and the 27 minimizing quotient points of
class B contain 1 point that is on the graph under the `sigma` and `sigma^2`
conventions, 2 that are on it under the `J.sigma` and `J.sigma^2` conventions,
and 24 that are off the graph under all four.

The four candidate graph conditions of §1 all select exactly 28 points, so the
count 28 does not identify the intended convention, and the switch statistics do
not either, because they are constant across the graph/off-graph divide.  The
probe therefore reports all four flags per quotient point and uses
`graph_sigma` only as a label for the aggregate split; **no measured quantity
here distinguishes the Frobenius-graph fibre from the off-graph fibre.**  The
proved-tame/wild distinction of (25ag)-(25aj) is invisible to this mechanism.

### 4.7 Tightness of the nonsingularity bounds of §4 of the switch note

The switch note proves `|B_ns| >= 702` when `z2 != 0`, `>= 1023` when
`z2 = 0, z3 != 0`, and `>= 1012` when `z2 = z3 = 0`.  Measured over the covered
set:

* the global minimum of `n_nonsingular` is **1012**, attained by 704 classes
  (702 in `rank1-offgraph`, 2 in the rank-two sample), **all of which have
  `z2 = z3 = 0`**.  The third bound is therefore exactly attained.
* the next value up the tail is 1104, attained by 2,925 classes, again all
  with `z2 = z3 = 0`.  Every dumped class with `n_nonsingular <= 1104` has
  `z2 = z3 = 0`, so on the covered set `|B_ns| >= 1105` whenever
  `(z2, z3) != (0,0)`.  Bounds 1 and 2 (702 and 1023) are far from tight.
* the classes attaining `n_nonsingular = 1012` have `n_good` between 209 and
  237, so the worst switch-matrix supply is not the worst split supply.

## 5. Outputs

All in `notes/reed-solomon-tasks/c973-gf27-switch-probe/out/` (75 KB total).

| file | bytes | sha256 |
|---|---:|---|
| `summary.tsv`         |    783 | `c4e27630867f927f807cc0f05c525c86792ff1f51c5f07945a6832f04a0a6469` |
| `histograms.tsv`      |  80081 | `9c517e58034019390e024e503124376e91569d64f102fd9f5d2d27851f40f76a` |
| `quotient_points.tsv` |  36678 | `731a280bbb71bb478803598c25bfaad6eb431d6a17413e53eb78efd1e656634e` |
| `extremes.tsv`        | 246435 | `b74072f6359b8b8f27b8c788ecc6a87201ed43f554d9331153738cb2eb26a34e` |
| `failures.tsv`        |    107 | `9c037c55318769bc1561bceb2341f13b28abd87db0098426c28c98645f484421` |
| `checks.txt`          |    923 | `b1153a87c1c1f8f6746d3d0edd53154700de8af354601e16c3b94574d1cc0456` |

Generator: `notes/reed-solomon-tasks/c973-gf27-switch-probe/src/main.rs`,
sha256 `b7c7fdfae6440c59c93940653606fda82f899f2df7898cbd1a19ff4fe8d8c829`
(the final version, including the §7 `e3` and §8 `certify` modes; the `full` and
`dump` code paths are unchanged from the runs above, and re-running `full`
reproduced `summary.tsv`, `histograms.tsv` and `quotient_points.tsv`
byte-for-byte);
`Cargo.toml` sha256
`5c1d8c53c3bb7413355bc5be2d6d83cc8d02cd0088eb9b1f0ee18451b7f9b893`.
`failures.tsv` is header-only by construction: no syndrome failed.  The only
run-to-run variation in these outputs is the wall-time line of `checks.txt`;
the four TSVs are byte-stable across reruns.

`extremes.tsv` is produced by the second mode

```
PROBE_THREADS=8 DUMP_NS=1104 \
  /home/tavis/.cache/c973-gf27-switch-probe-target/release/probe dump
```

which rescans the same strata (same seed) and lists every class with
`n_good <= 120`, `n_good_lambda1 <= 10`, or `n_nonsingular <= 1104`, together
with its exhaustive `C(27,9)` and `C(27,8)` locator counts.  It emitted 3,656
rows.

## 6. Runtime

Single machine, 8 worker threads, `choom -n 1000`, resident set under 130 MB.

| pass | wall time |
|---|---|
| geometry + sanity checks + `full` strata scan | 147.38 s |
| `dump` rescan with exhaustive counts on 3,656 classes | 294.68 s |

Measured throughput: 72.3 microseconds per syndrome for the 1404-candidate
switch scan plus the 39-plane one-point scan, and 51.8 ms for one full
`C(27,9)` exhaustive sweep.

## 7. The single syndrome `z = e_3`

Replay: `PROBE_THREADS=8 <binary> e3`.  Deterministic, no sampling.  Outputs
`out/e3-good78.tsv`, `out/e3-collisions.tsv`, `out/e3-ninesets.tsv`,
`out/e3-summary.txt`.

### 7.1 The closure condition

For `z = e_3 = (0,1,0,0,0,0,0)` the two Hankel equations collapse to
`E1(g) = g_2 = 0` and `E2(g) = g_3 = 0`.  With
`g(t) = prod_{s in S}(t-s) = sum_k (-1)^{9-k} e_{9-k}(S) t^k` this is
`e_7(S) = e_6(S) = 0`, as stated.  The switch profile is
`n_nonsingular = 1326`, `n_zero_disc = 156`, `n_split_distinct = 546`,
`n_good = 78`, `n_good_lambda1 = 0`, `n_onepoint = 0`.

### 7.2 The 78 good switch candidates

`out/e3-good78.tsv` lists all 78 rows, each with the line direction `d`
(canonical projective representative), the line offset `q` from
`R(t) = t^3 + p t + q`, the three line points, the removed pair `{x1,x2}` and
the retained third point `x3 = -x1-x2`, the pencil parameter `kappa` and its
`lambda = kappa/d^6` with label, the nine points of the plane, the replacement
roots `{y1,y2}`, and the resulting nine-set `S`.  Field elements are the
base-three digit encoding of §1.

Two structural facts fall out immediately.

* **The good candidates carry no `lambda = 1` plane.**  By label the split is
  `l1: 26, l2: 26, l3: 26` with `lambda = 1` contributing 0, where
  `l1 = 9, l2 = 13, l3 = 16` are the three roots of
  `lambda^3 + lambda^2 + lambda + 2` and `lambda = 1` is the fourth root of
  `lambda^4 + lambda + 1`.
* **All 78 nine-sets are distinct**, so the good candidates and the good
  nine-sets are in bijection here.

Under the multiplicative torus `x -> a x`, `a in K^*` (order 26, and containing
`x -> -x` as the element `a = -1 = 2`, so that map contributes no extra
identifications), the 78 candidates fall into **exactly 3 orbits, each of size
26** — one per conjugate `lambda`.  Orbit representatives, with all fields:

| orbit | cand | `d` | `q` | line | `{x1,x2}` | `x3` | `kappa` | `lambda` | plane | `{y1,y2}` | nine-set `S` |
|---:|---:|---:|---:|---|---|---:|---:|---|---|---|---|
| 0 | 40 | 1 | 5 | `9,10,11`  | `{9,11}`  | 10 | 13 | `l2 = 13` | `0,1,2,9,10,11,18,19,20`  | `{8,15}`  | `0,1,2,8,10,15,18,19,20` |
| 1 | 54 | 1 | 4 | `12,13,14` | `{12,13}` | 14 | 16 | `l3 = 16` | `0,1,2,12,13,14,24,25,26` | `{6,11}`  | `0,1,2,6,11,14,24,25,26` |
| 2 | 69 | 1 | 3 | `15,16,17` | `{15,16}` | 17 | 9  | `l1 = 9`  | `0,1,2,15,16,17,21,22,23` | `{7,12}`  | `0,1,2,7,12,17,21,22,23` |

The three torus orbits are permuted by the cube Frobenius: all three have the
same torus-and-Frobenius canonical form (mask `18811`), so under the group of
order 78 generated by the torus and `sigma` the 78 good candidates form a
**single orbit**.

### 7.3 Collision breakdown of the 468 split-distinct-but-colliding candidates

Of the 546 candidates whose replacement quadratic splits with distinct roots,
`546 - 78 = 468` are discarded because a root lands in the seven retained roots
of `Q`.  Classifying each by which retained points are hit
(`out/e3-collisions.tsv`):

| collision type | candidates | colliding roots per candidate |
|---|---:|---:|
| retained third point `x3 = -x1-x2` | 78  | 1 |
| one of the six off-line retained points | 390 | 1 |
| both kinds simultaneously | 0 | — |
| two colliding roots | 0 | — |
| total | 468 | |

Every discarded candidate loses exactly one root, never two, and never one of
each kind.  By pencil label:

| collision type | `lambda = 1` | conjugate `l1,l2,l3` |
|---|---:|---:|
| retained third point `x3` | 0   | 78  |
| off-line retained point   | 156 | 234 |

All 156 split-distinct `lambda = 1` candidates collide, always with an off-line
retained point and never with `x3`; the 78 `x3` collisions are entirely on the
conjugate planes.  The conjugate planes account for `546 - 156 = 390`
split-distinct candidates, splitting as `78` good, `78` colliding at `x3` and
`234` colliding off-line.

### 7.4 All 6,890 nine-sets closing `e_3`

The exhaustive `C(27,9)` sweep returns 6,890 nine-point sets `S` with
`e_6(S) = e_7(S) = 0`.  Under the torus they form **266 orbits**: 264 of size
26 and 2 of size 13 (`264*26 + 2*13 = 6890`).  The two short orbits are the
sets with a nontrivial stabilizer, i.e. `S = -S`; their representatives are
`{0,3,5,6,7,10,11,19,20}` and `{0,4,5,7,8,11,17,19,22}`.  Under the order-78
group generated by the torus and `sigma` there are 92 classes: 87 fusing three
torus orbits and 5 Frobenius-stable single orbits.

Classification of the orbit representatives (`out/e3-ninesets.tsv`), by the
maximal intersection of `S` with one of the 39 affine planes:

| max plane intersection | orbits | sets | reading |
|---:|---:|---:|---|
| 9 | 0   | 0    | `S` is an affine `F3`-plane |
| 8 | 0   | 0    | `S` is a one-point switch of a plane |
| 7 | 3   | 78   | `S` is a two-point switch of a plane |
| 6 | 108 | 2808 | — |
| 5 | 155 | 4004 | — |

so in the requested categories:

| category | orbits | sets |
|---|---:|---:|
| (a) affine `F3`-plane | 0 | 0 |
| (b) union of three parallel `F3`-lines (not a plane) | 0 | 0 |
| (c) affine plane with a two-point switch | 3 | 78 |
| (d) none of those | 263 | 6812 |

The 78 sets of category (c) are exactly the 78 nine-sets produced by the good
switch candidates of §7.2, so for `e_3` the two-point switch mechanism finds
every set that is within two points of a plane and, necessarily, nothing else:
it reaches 78 of the 6,890 solutions, `1.1%`.

Categories (a) and (b) are empty for a short reason, which the computation
confirms rather than discovers.  For three parallel lines
`g = prod_{i}(L_p(t) + q_i)` with `u = t^3 + pt` one gets
`g = u^3 + e_1 u^2 + e_2 u + e_3`, hence `g_2 = p^2 e_1` and `g_3 = p^3 + e_2`.
Closure forces `e_1 = 0` and `e_2 = -p^3`, so the three `q_i` are the roots of
the `F3`-linear polynomial `X^3 - p^3 X - e_3`.  Its kernel is
`{X : X^2 = p^3}` and `p^3 = -(d^3)^2`, so a nonzero kernel element would make
`-1` a square in `GF(27)`; the squares form the subgroup of odd order 13, which
contains no element of order two, so `-1` is a nonsquare.  The kernel is trivial,
the polynomial has a single root, and three distinct `q_i` cannot exist.  Every
affine plane is a union of three parallel lines, so (a) is empty as well —
equivalently, every plane locator `t^9 + A t^3 + B t + C` has `A = -f^2 - d^6`
with `f, d != 0`, which is nonzero for the same reason.

One further measurement: every one of the 6,890 sets contains at least one
affine `F3`-line, and none contains more than five.  By orbit:

| lines contained in `S` | orbits | sets |
|---:|---:|---:|
| 1 | 30 |  780 |
| 2 | 76 | 1976 |
| 3 | 73 | 1898 |
| 4 | 54 | 1378 |
| 5 | 33 |  858 |

### 7.5 Outputs

| file | bytes | sha256 |
|---|---:|---|
| `e3-good78.tsv`     |  7185 | `07e4b937b59a8e3b3b054c5eaec08d4fc15dbc95c66a3bbabf6a89aca5c3c5bc` |
| `e3-collisions.tsv` | 20718 | `1cef7f2c32f5106b0c5597506c0f7be755cede9e482e92e27b83db96097727dd` |
| `e3-ninesets.tsv`   | 14132 | `d18c89b10ea4606bdbd7ee0714a14f64dd57c2757e0956f8431fd383f251328a` |
| `e3-summary.txt`    |   893 | `b22c55d2fed1579a09a017495121022c8bca002af8a61c49e7094bde184381c1` |

Generator hash and the reproducibility check for the earlier passes are in §5.

## 8. Complete GF(27) certificate sweep

Every projective carrier class was scanned, not a stratified sample.

### 8.1 What was certified

> For `K = GF(27) = F3[x]/(x^3 - x - 1)`, every one of the
> **402,321,277** projective classes `z in PG(6,27)`, i.e. every
> `z = (z_2,...,z_8) in K^7 \ {0}` up to scaling, admits a monic degree-nine
> locator `g` with **nine distinct roots in `K`** satisfying both Hankel
> equations `sum_{i=2}^{8} z_i g_{i-1} = 0` and `sum_{i=2}^{8} z_i g_i = 0`.
> Moreover every such `g` produced here is a **two-point affine-plane switch**,
> and every class admits at least **78** distinct ones.

`402,321,277 = (27^7 - 1)/26`, so the sweep is the whole projective space; no
carrier-membership condition was imposed, so the statement holds a fortiori on
the maximal carrier `N^(8) Gamma_10(F_27)` of eq (15) of the compression note.
The `C(27,9)` exhaustive fallback was wired in for any class the switch failed
on and was **invoked zero times**, because the switch never failed.

### 8.2 Method

Mode `certify` enumerates the 20,440 projective quotient points
`(z_3,z_4,z_6,z_7)` of `PG(3,27)` (normalized so the first nonzero quotient
coordinate is 1), and for each one scans all `27^3 = 19,683` kernel values
`(z_2,z_5,z_8)`; the 757 classes of the rank-zero kernel plane are scanned
separately.  `20440 * 19683 + 757 = 402,321,277`.

Inside a fibre the quotient coordinates are constant, so each of the six Hankel
functionals per switch candidate is an affine function of the kernel with a
constant folded once per fibre; the three kernel coordinates are then peeled off
in nested loops so the innermost step costs two table lookups per functional.
This fibre-specialised scan was cross-checked against the general `scan()` of
§1 on 2,000 random classes of one fibre: **2,000 agree, 0 differ**.  It made the
sweep about 2.5 times faster than the §4 scan (`72.3 us` down to `28 us` per
class of single-thread work).

Progress was written to `out/certify-progress.txt` every 500 quotient points
(quotient points done, elapsed seconds, classes done, unsaturated so far), so an
interruption would have left an auditable partial record.

### 8.3 Result

From `out/certify-summary.txt`:

```
quotient points scanned: 20440
total projective carrier classes: 402321277
(27^7 - 1)/26 = 402321277
global min n_good: 78 at z = 0,1,0,0,0,0,0
classes with n_good = 0 (fallback invocations): 0
unsaturated classes (no split nine-affine locator at all): 0
mean n_good over all classes: 339.3223
wall time: 1588.17 s, threads 8
```

By quotient type:

| type | quotient points | classes | min `n_good` |
|---|---:|---:|---:|
| `rank0-kernel`   |      1 |         757 | 222 |
| `rank1-graph`    |     28 |     551,124 |  78 |
| `rank1-offgraph` |    756 |  14,880,348 |  78 |
| `rank2`          | 19,656 | 386,889,048 | 195 |
| total            | 20,441 | 402,321,277 |  78 |

The exhaustive rank-zero and rank-one figures agree exactly with §4.2, which is
an independent-path check: those strata were rescanned here by the
fibre-specialised code and reproduced the same minima.

Low tail of the global `n_good` distribution (`out/certify-histogram.tsv`):

| `n_good` | classes | where |
|---:|---:|---|
| 78  |    27 | the 27 rank-one classes of §4.4 and §7 |
| 195 |   702 | 351 rank-two quotient points, e.g. `(z3,z4,z6,z7) = (0,1,2,0)` with kernel `(0,1,2)` |
| 209 | 2,106 | 234 rank-two quotient points, e.g. `(0,1,3,1)` with kernel `(0,2,13)` |
| ... | | |
| 1404 | 6,904 | every switch candidate good |

so the global minimum 78 is attained only by the 27 syndromes already isolated
in §4.4, and the best possible worst case on the rank-two bulk is 195.  Minima
of the per-quotient-point rows in the low tail:

| min over fibre | quotient points | rank | example quotient point |
|---:|---:|---:|---|
|  78 |   1 | 1 (`graph_sigma`) | `1,0,0,0` |
|  78 |  26 | 1 (off graph)     | `1,2,1,2` |
| 195 | 351 | 2                 | `0,1,2,0` |
| 209 | 234 | 2                 | `0,1,3,1` |
| 222 | 117 | 2                 | `0,1,1,0` |
| 227 |  27 | 1 (off graph)     | `0,1,0,0` |

`out/certify-unsaturated.tsv` is header-only: **no unsaturated class exists.**

### 8.4 Independent replay of the witnesses

The sweep also dumped, for a seeded sample of 200 classes drawn uniformly from
all 402,321,277 (splitmix64, seed `0xC973_CE47_1F1C`, index-space sampling so the
kernel plane is included at its true weight), the explicit witness nine-set from
the first good switch candidate.  `verify_witnesses.py` re-derives `GF(27)` from
scratch, shares no code with the Rust program, rebuilds each monic locator from
its root set and checks that the support has nine distinct elements of `K`, that
the locator is monic of degree nine, that both Hankel equations vanish, and that
each listed point really is a root of the rebuilt polynomial:

```
witness rows checked: 200
rows failing: 0
all witnesses verified: nine distinct roots in GF(27) and both Hankel equations hold
```

### 8.5 Replay

```
CARGO_TARGET_DIR=/home/tavis/.cache/c973-gf27-switch-probe-target \
  cargo build --release \
  --manifest-path notes/reed-solomon-tasks/c973-gf27-switch-probe/Cargo.toml
PROBE_THREADS=8 choom -n 1000 -- \
  /home/tavis/.cache/c973-gf27-switch-probe-target/release/probe certify
python3 notes/reed-solomon-tasks/c973-gf27-switch-probe/verify_witnesses.py
```

`PROBE_QLIMIT=<n>` truncates the sweep to the first `n` quotient points for a
smoke test.  Deterministic apart from the wall-time lines; the witness sample is
seeded, so `certify-witness-sample.tsv` is reproducible.

Runtime 1,588.17 s (26.5 min) on 8 threads.  Memory is bounded by construction:
each worker holds a 19,683-entry `u16` fibre counter, a 1,405-entry histogram
and a 1,404-entry candidate table, under 100 KB per thread, plus a single
output buffer under 1 MB.

### 8.6 Outputs

| file | bytes | sha256 |
|---|---:|---|
| `certify-summary.txt`        |    532 | `f7d3ade14aca0e6112b146c13e3d67a663b37fcdf716e234aa7083c4b5ac7c0a` |
| `certify-quotient-rows.tsv`  | 840844 | `63bd14bcf01db2f17ff63293fd8fcecb48ac7df10f64bfeee18ae6e8c7f376d4` |
| `certify-histogram.tsv`      |   2453 | `aa456c3d2d310064a781e83acccb648c631901948a4bd30d626f331510f37c56` |
| `certify-unsaturated.tsv`    |     21 | `6d70875f05005089e5258180f7e635e53a62a04c23eb1243e261ad5e0dd6354f` |
| `certify-witness-sample.tsv` |   8378 | `5dc58017fd6e0fe48140f515caa742a8491d8999272b5836c2304a9f46cdfa6a` |
| `certify-progress.txt`       |   1029 | `c138052a9e654f7a0689c60027549c2789e282da2c883af6eb8f3ba82db1066b` |

Verifier `verify_witnesses.py`, 5,204 bytes, sha256
`fee500e1fd55f4c7ca3f9409b1dc4b95d2f3b8c17b2eea4b1b0bd7121cfd4d73`.
Generator `src/main.rs` sha256 as in §5.

`certify-quotient-rows.tsv` has one row per quotient point: index, the quotient
point, its rank and `graph_sigma` flag, the fibre size 19,683, the minimum
`n_good` over the fibre, the kernel value attaining it, the number of fallback
invocations, and the number of unsaturated classes.  The last two columns are
zero in all 20,440 rows.

