# C756 — split-fiber census and coherence cascade

**Lane**: `clebsch`
**Date**: 2026-08-02

## Verdict

The crown reformulation (F4) is **exactly equivalent to coherence (F3) on every split-fiber pair
examined** — 119 384 pairs across q = 5, 7, 11, 13, with zero disagreements. No counterexample to
the theory was found. The automatic structure assumed in the definition (all fiber roots
irrational, no two conjugate, all simple) also held on every pair, with zero assertion failures,
and is independently reconfirmed by the Python enumeration, which does not assume it.

Coherence itself is a **q = 5 phenomenon and dies immediately afterwards**. At q = 5 there are ten
F3 pairs, forming two affine orbits of size five that are exchanged by conjugation; both stated
frames are in that set, one in each orbit, and each orbit has normal form `(R, gamma) = (X^4, ζ)`
with ζ a primitive sixth root of unity in F_25. At q = 7, 11 and 13 there are **zero** F3 pairs,
and the collapse is caused by externality (F2), not by the derivative class (F1): F2 alone already
has zero survivors at every q ≥ 7, while F1 still passes 42, 660 and 2106 pairs respectively. The
best any pair achieves is roughly half the required ordered pairs (8 of 20 at q = 7, 22 of 42 at
q = 11, 30 of 56 at q = 13), so the population is not merely narrowly missing coherence.

A second, unasked-for result: **the stated Poisson heuristic overcounts split pairs by a factor of
about 2.4.** Replacing it with a heuristic that respects the forced structure of a fiber —
`C((q^2-q)/2, nn) * 2^nn / q^(nn-1)`, i.e. conjugation-free and rationality-free root sets subject
to nn-1 independent F_q-rationality conditions on the coefficients — brings prediction and
observation to within 13% at every exactly enumerated q and within 5% at q = 17 in the sample.

## Conventions

q an odd prime; eps the smallest nonsquare in F_q; F_{q^2} = F_q(s) with s^2 = eps; the element
a + b·s is stored as the index a + b·q. Conjugation is (a+bs)^q = a - bs, N(u) = u·u^q = a^2 -
eps·b^2, and chi(u) = legendre(N(u), q) with chi(0) = 0. t = (q+1)/2, nn = t+1 = (q+3)/2, and
sign_t = (-1)^t. R is monic of degree nn over F_q with R(0) = 0, written by its coefficient list
c_0 … c_nn with c_0 = 0 and c_nn = 1.

A split-fiber pair is (R, gamma) with gamma ∉ F_q and R(X) - gamma having nn distinct roots in
F_{q^2}; equivalently |R^{-1}(gamma)| = nn counted in F_{q^2}. The affine group acts by
X ↦ aX + b (a ∈ F_q^*, b ∈ F_q) as R ↦ a^{-nn}(R(aX+b) - R(b)) and gamma ↦ a^{-nn}(gamma - R(b)),
which on root sets is Z ↦ {(z-b)/a}; the constant term of the transformed R is zero by
construction. The implementation canonicalises on root sets, which determine the pair bijectively
(R = P - P(0) and gamma = -P(0), where P = prod (X - z)), and it verifies for every pair and every
group element that the image is again a listed split pair.

## Exact census

| q  | nn | monic R    | split pairs | unordered {gamma, gamma^q} | affine orbits | orbit sizes                 |
|----|----|------------|-------------|----------------------------|---------------|-----------------------------|
| 5  | 4  | 125        | 20          | 10                         | 4             | 4 × 5                       |
| 7  | 5  | 2 401      | 294         | 147                        | 7             | 7 × 42                      |
| 11 | 7  | 1 771 561  | 16 500      | 8 250                      | 150           | 150 × 110                   |
| 13 | 8  | 62 748 517 | 102 570     | 51 285                     | 698           | 624 × 156, 60 × 78, 14 × 39 |

The affine group has order q(q-1). At q = 7 and q = 11 it acts freely on split pairs. At q = 5
every orbit has a stabiliser of order 4, and at q = 13 seventy-four orbits have a nontrivial
stabiliser (sixty of order 2, fourteen of order 4), which is why 102 570 is not a multiple of 156.
The action was verified closed on the split-pair set at every q.

### Heuristic comparison

`naive` is the Poisson-style prediction `q^(nn-1) · (q^2 - q) / nn!` requested in the task.
`refined` is `C((q^2-q)/2, nn) · 2^nn / q^(nn-1)`.

| q  | observed | naive     | observed/naive | refined  | observed/refined |
|----|----------|-----------|----------------|----------|------------------|
| 5  | 20       | 104.2     | 0.192          | 26.9     | 0.744            |
| 7  | 294      | 840.4     | 0.350          | 271.2    | 1.084            |
| 11 | 16 500   | 38 665.0  | 0.427          | 14 662.1 | 1.125            |
| 13 | 102 570  | 242 777.0 | 0.422          | 95 658.1 | 1.072            |

The naive ratio is not drifting towards 1; it settles near 0.42. The deficit is structural, not
statistical: a split fiber can contain no element of F_q and no conjugate pair (both force
gamma ∈ F_q), and the naive count ignores that restriction. The refined count imposes it and lands
within 13%.

## Cascade funnel

| q  | split   | F2 alone | F1    | F1 & F2 | F3 |
|----|---------|----------|-------|---------|----|
| 5  | 20      | 10       | 10    | 10      | 10 |
| 7  | 294     | 0        | 42    | 0       | 0  |
| 11 | 16 500  | 0        | 660   | 0       | 0  |
| 13 | 102 570 | 0        | 2 106 | 0       | 0  |

F1 survival is 50%, 14.3%, 4.0% and 2.05% — in each case about five times the 2^{-nn} rate that
independent signs would give, so the derivative class is genuinely biased towards (-1)^t but is
nowhere near decisive. Externality is the wall: at every q ≥ 7 no split pair at all satisfies F2,
so F1 & F2 and F3 are empty for reasons that have nothing to do with F1.

### Coherence histogram

Number of ordered pairs (i, j), i ≠ j, meeting both F3 sign conditions, out of the nn(nn-1)
required.

| q  | required | histogram (satisfied ordered pairs → count of split pairs)                                                                                             |
|----|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| 5  | 12       | 0 → 10, 12 → 10                                                                                                                                        |
| 7  | 20       | 2 → 42, 6 → 126, 8 → 126                                                                                                                               |
| 11 | 42       | 2 → 220, 4 → 550, 6 → 1210, 8 → 3080, 10 → 3520, 12 → 2750, 14 → 2200, 16 → 1320, 18 → 660, 20 → 880, 22 → 110                                         |
| 13 | 56       | 4 → 624, 6 → 2340, 8 → 6708, 10 → 8112, 12 → 13806, 14 → 16692, 16 → 15132, 18 → 16224, 20 → 9360, 22 → 6396, 24 → 5148, 26 → 1560, 28 → 312, 30 → 156 |

At q = 5 the distribution is all-or-nothing: a split pair is either fully coherent or has no
coherent ordered pair whatsoever. That dichotomy is gone at q = 7, where the histogram is supported
on only three values, and by q = 11 and 13 the distribution is broad and unimodal with a maximum at
about 54% of the required pairs. Nothing gets close to coherence.

## F4 crown verification

For every split-fiber pair at q = 5, 7, 11 and 13 — 119 384 pairs in total — the induced subgraph
of the Cayley graph on F_{q^2} with connection set {u ≠ 0 : chi(u) = (-1)^{t+1}} on the 2·nn
vertices Z ∪ Z^q is the complete bipartite graph K_{nn,nn} minus the perfect matching z ↔ z^q,
with Z and Z^q independent, **if and only if** F3 holds. Disagreements: **zero at every q**. The
Python cross-check reruns the same equivalence independently at q = 5 and 7 and also reports zero.

Two structural notes that the census confirms numerically. Non-adjacency of z and z^q is automatic:
z - z^q = 2bs with b ≠ 0, so N(z - z^q) = -4b^2·eps and chi(z - z^q) = -chi_q(-1) = (-1)^t ≠
(-1)^{t+1}. Independence of Z^q is not an extra condition either, since chi(u^q) = chi(u) makes it
the conjugate restatement of independence of Z. So F4 is a faithful graph-theoretic repackaging of
F3, with the matching non-edge free of charge.

## The ten coherent pairs at q = 5 (eps = 2)

These are all of them. `A` and `B` label the two affine orbits, which are exchanged by
conjugation; both stated frames appear, one in each orbit.

| orbit | R                | gamma | Z                     |
|-------|------------------|-------|-----------------------|
| A     | X^4              | 3+3s  | 2+s, 4+2s, 1+3s, 3+4s |
| A     | X^4+X^3+X^2+X    | 2+3s  | 3+s, 0+2s, 2+3s, 4+4s |
| A     | X^4+3X^3+4X^2+2X | 2+3s  | 0+s, 2+2s, 4+3s, 1+4s |
| A     | X^4+2X^3+4X^2+3X | 2+3s  | 4+s, 1+2s, 3+3s, 0+4s |
| A     | X^4+4X^3+X^2+4X  | 2+3s  | 1+s, 3+2s, 0+3s, 2+4s |
| B     | X^4              | 3+2s  | 3+s, 1+2s, 4+3s, 2+4s |
| B     | X^4+X^3+X^2+X    | 2+2s  | 4+s, 2+2s, 0+3s, 3+4s |
| B     | X^4+3X^3+4X^2+2X | 2+2s  | 1+s, 4+2s, 2+3s, 0+4s |
| B     | X^4+2X^3+4X^2+3X | 2+2s  | 0+s, 3+2s, 1+3s, 4+4s |
| B     | X^4+4X^3+X^2+4X  | 2+2s  | 2+s, 0+2s, 3+3s, 1+4s |

Each orbit contains the monomial pair (X^4, ζ) with ζ = 3±2s a primitive sixth root of unity in
F_25; that is the cleanest normal form for the q = 5 solution. Note X^4 = X^{q-1} here, and
nn = q - 1 holds only at q = 5, so the monomial normal form is a coincidence of that field and does
not suggest a family.

### Frame check

Both stated frames are present and pass everything.

- `R = X^4+3X^3+4X^2+2X`, `gamma = 2+3s`, `Z = {s, 2+2s, 4+3s, 1+4s}` — split, F1 ✓, F2 ✓, F3 ✓,
  F4 crown ✓, F4 agrees with F3 ✓. (Orbit A. The stated root list `{s, 1+4s, 2+2s, 4+3s}` is the
  same set.)
- `R = X^4+2X^3+4X^2+3X`, `gamma = 2+2s`, `Z = {s, 3+2s, 1+3s, 4+4s}` — split, F1 ✓, F2 ✓, F3 ✓,
  F4 crown ✓, F4 agrees with F3 ✓. (Orbit B. Same set as the stated `{s, 4+4s, 1+3s, 3+2s}`.)

Eight other split pairs at q = 5 pass F3, listed above; they are exactly the remaining members of
the two orbits.

## Random-sample density at q = 17, 19, 23, 29

10^7 uniformly random monic R with R(0) = 0 per q, drawn from a xorshift64 stream sharded into 256
fixed shards with per-shard seeds derived from a fixed base seed, so the result is a deterministic
function of (q, sample size, seed) and does not depend on the thread count. `naive rate` is
(q^2 - q)/nn!; `refined rate` is the refined heuristic per R. Split fibers always come in conjugate
pairs, so the number of R with at least one is exactly half the fiber count in every case here; the
Wilson interval is for the per-R rate and is compared against half the fiber-rate predictions.

| q  | nn | samples | R with a split fiber | split fibers | observed fiber rate | naive rate | refined rate | 95% Wilson (per R)   |
|----|----|---------|----------------------|--------------|---------------------|------------|--------------|----------------------|
| 17 | 10 | 10^7    | 147                  | 294          | 2.940e-5            | 7.496e-5   | 3.095e-5     | [1.251e-5, 1.728e-5] |
| 19 | 11 | 10^7    | 14                   | 28           | 2.800e-6            | 8.568e-6   | 3.593e-6     | [8.340e-7, 2.350e-6] |
| 23 | 13 | 10^7    | 0                    | 0            | 0                   | 8.126e-8   | 3.484e-8     | [0, 3.841e-7]        |
| 29 | 16 | 10^7    | 0                    | 0            | 0                   | 3.881e-11  | 1.700e-11    | [0, 3.841e-7]        |

**The naive heuristic is far from the observation and the refined one is not.** At q = 17 the
naive per-R prediction is 3.748e-5, well outside the interval [1.251e-5, 1.728e-5]; the refined
prediction 1.548e-5 sits inside it. At q = 19 the naive 4.284e-6 is outside [8.34e-7, 2.35e-6] and
the refined 1.796e-6 is inside. Observed-over-refined on fiber rates is 0.95 at q = 17 and 0.78 at
q = 19.

The q = 23 and q = 29 rows are **uninformative, not negative results**: the refined model predicts
0.17 and 0.000085 expected hits in 10^7 draws, so observing zero says nothing. The 95% upper bound
of 3.8e-7 per R exceeds the prediction by a factor of about 22 at q = 23 and about 45 000 at
q = 29. Detecting a split fiber at q = 29 by uniform sampling would need on the order of 10^11
draws; that route is not worth taking.

## Independent replay

Two independent code paths, written from opposite ends of the problem, agree exactly.

The Rust census enumerates every monic R by a loop-free reflected mixed-radix Gray code over the
coefficient vector, carrying the values R(z) incrementally over one representative per conjugate
pair of irrational z, and looks for a fiber of size nn. The Python cross-check instead enumerates
every nn-element subset of the whole of F_{q^2} — rational elements and conjugate pairs included,
nothing assumed — forms P(X) = prod (X - z), and keeps the subset when P has coefficients in F_q in
degrees 1 … nn-1 and gamma = -P(0) is irrational. Because it never restricts the subsets, it
independently establishes, rather than assumes, that split-fiber root sets avoid F_q and contain no
conjugate pair.

At q = 5 and q = 7 the two agree on every compared field: split-pair count, unordered gamma-pair
count, affine orbit count, orbit-size histogram, orbit-action closure, the full funnel
(split / F2-alone / F1 / F1 & F2 / F3), the F3 orbit count, the coherence histogram, the F4
disagreement count (zero), the assertion-failure count (zero), and the exact list of F3 root sets.
The comparison is run by the Python script itself and exits nonzero on any mismatch.

At q = 11 and q = 13 the Python subset enumeration is infeasible (C(121,7) ≈ 1.1e10). There the
Gray-code sweep is instead checked against a second, deliberately naive Rust path that recomputes
each polynomial's values by plain Horner evaluation with no incremental state; the raw split-pair
totals agree at all four q. Independently of both sweeps, every reported split pair has its root
set recovered from scratch by a full scan over all q^2 - q irrational elements inside the analysis
routine, and that scan re-verifies |Z| = nn, distinctness, irrationality and conjugate-freeness for
each pair.

**Trusted boundary.** The Rust brute-force recount shares the field arithmetic tables and the
fiber-detection predicate with the Gray-code sweep, so at q = 11 and 13 the completeness of the
enumeration rests on those shared components; only q = 5 and q = 7 have a fully independent
second implementation. Everything reported is a statement about the specific eps chosen (the
smallest nonsquare of F_q) — the census was not repeated for other choices of eps, though the
F_{q^2} isomorphism class does not depend on it. Nothing here proves anything for q ∉ {5, 7, 11,
13}; the q ≥ 17 rows are sampling estimates only, and the q = 23 and q = 29 rows carry no
information at all about coherence.

## Mystery ledger

- **Why 0.42?** The naive Poisson heuristic's shortfall is settled: the refined heuristic accounting
  for conjugation-free, rationality-free root sets tracks the exact counts to within 13% at
  q = 7, 11, 13 and within 5% at q = 17 in the sample. Residual open: the refined heuristic
  overshoots at q = 5 (0.744) and undershoots slightly at q ≥ 7 (1.07–1.13) with no clear trend to
  1; the residual is plausibly the falling-factorial correction plus dependence between the nn-1
  rationality conditions, but that has not been computed. Not load-bearing for any coherence claim.
- **Nontrivial stabilisers appear at q = 13 and nowhere else in the range.** Fourteen orbits have a
  stabiliser of order 4 and sixty of order 2 in the affine group of order 156; at q = 7 and 11 the
  action is free. Unexplained. Open, with no owner; it does not affect any funnel count, since F3 is
  empty at q = 13 either way.
- **The all-or-nothing coherence histogram at q = 5** — every split pair scores either 0 or 12 —
  is not reproduced at any larger q, where the support is an interval. This is consistent with
  q = 5 being degenerate (nn = q - 1 only there), but no argument for the dichotomy was found.
  Open.
- **F1 is uniformly about five times more likely than independent signs would predict**, at every
  q from 7 to 13. The constancy of that factor is unexplained. Open; low value, since F2 alone
  already empties the cascade.
- **Settled, not mysterious**: F4 ≡ F3 is a tautology given chi(u^q) = chi(u) and
  chi(z - z^q) = (-1)^t, and the census confirms it on all 119 384 pairs. The coherence collapse at
  q ≥ 7 is owned by F2, not F1, and it is not marginal: the best pairs reach only about half the
  required ordered pairs.

## Replay

Working directory `/home/tavis/src/othello/notes`. `$SCRATCH` is any writable scratch directory;
nothing is written into the `rust/` crate. Toolchain used: rustc 1.93.1, Python 3.13.12, 24 cores.

```
rustc -O -o "$SCRATCH/c756_census" 2026-08-02-c756-split-fiber-census.rs
"$SCRATCH/c756_census" 2026-08-02-c756-split-fiber-census.json
python3 2026-08-02-c756-split-fiber-census.py --qs 5,7 \
        --json 2026-08-02-c756-split-fiber-census.json
```

The census run takes about 90 seconds wall clock (about 3 seconds of it is the exact q = 13 sweep;
most of the rest is the 4 × 10^7 sampling draws) and the Python cross-check about 2 seconds. The
certificate contains no timestamps, no host paths and no wall-clock timings, and regenerating it
twice produces byte-identical output; this was verified. Timings are printed to stderr only. The
Python script prints `CROSS-CHECK: AGREE` and exits 0 on success, nonzero on any mismatch.

Optional environment overrides exist for smoke tests only and must not be set for the certificate
run: `C756_QS` (comma-separated list of census primes) and `C756_SAMPLES` (per-q sample size).

### Artifact hashes

| file                                    | bytes | SHA-256                                                          |
|-----------------------------------------|-------|------------------------------------------------------------------|
| 2026-08-02-c756-split-fiber-census.rs   | 36467 | c6aec0b1a02c4ba879208154e8b939901d56bb4cea9750e3327c1591ed963888 |
| 2026-08-02-c756-split-fiber-census.py   | 10022 | 4a63411717c0e1de2d9de749da26f7cd40e53154c85f4395f04a5d33f5f736e7 |
| 2026-08-02-c756-split-fiber-census.json | 6629  | dd69ec43e1e92a8cb4ccfbff30ba160b06bfb586e4ee18eb9fc87eb3039f37cd |
