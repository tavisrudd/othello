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
wall time: 144.23 s, threads 8
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
| `checks.txt`          |    923 | `70c9f62645b747fdb227f7c2c57370a400ab0852c218584a699b434233197f8d` |

Generator: `notes/reed-solomon-tasks/c973-gf27-switch-probe/src/main.rs`,
sha256 `afd1929df72a0f07cc262ecd9fa2258c85cc43d69ec6430ee556b5680c74293a`;
`Cargo.toml` sha256
`5c1d8c53c3bb7413355bc5be2d6d83cc8d02cd0088eb9b1f0ee18451b7f9b893`.
`failures.tsv` is header-only by construction: no syndrome failed.

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
| geometry + sanity checks + `full` strata scan | 144.23 s |
| `dump` rescan with exhaustive counts on 3,656 classes | 294.68 s |

Measured throughput: 72.3 microseconds per syndrome for the 1404-candidate
switch scan plus the 39-plane one-point scan, and 51.8 ms for one full
`C(27,9)` exhaustive sweep.

