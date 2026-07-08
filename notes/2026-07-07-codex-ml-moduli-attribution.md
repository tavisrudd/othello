# C18 ML/moduli attribution report

## Summary

Phase 1 is complete. Dataset: 32 full-PGL on-conic orbit buckets for q=11,13,17,19, with
constant labels per bucket from C5/C15.

Result: null law. The feature dictionary has useful attribution signals, especially product
orders of conic involutions, but every shallow candidate found on the required forward split
`train={11,13}, test={17,19}` either collapses to the all-P baseline on the held-out set or
misclassifies q=19 P buckets when trying to recover q=17 N buckets. Reverse split overfits
q=17/19 and fails on q=11/13. No phase-2 q=23 probe was run.

## Commands

Pure standard-library run:

```text
python3 ../notes/2026-07-07-ml-moduli-attribution.py \
  /tmp/codex-feat11-c15.out /tmp/codex-feat13-c15.out \
  /tmp/codex-feat17.out /tmp/codex-feat19-c15.out \
  > /tmp/c18-ml-attribution.out
```

uv/sklearn cross-check:

```text
UV_CACHE_DIR=/tmp/uv-cache uv run --with numpy --with scikit-learn \
  python3 ../notes/2026-07-07-ml-moduli-attribution.py --sklearn \
  /tmp/codex-feat11-c15.out /tmp/codex-feat13-c15.out \
  /tmp/codex-feat17.out /tmp/codex-feat19-c15.out \
  > /tmp/c18-ml-attribution-sklearn.out
```

Package versions: `numpy 2.4.6`, `sklearn 1.9.0`.

## Feature Dictionary

Computed 53 features per orbit bucket:

- q arithmetic: `q mod 3/4/8/12`, `nu2(q-1)`, `nu2(q+1)`, prime-factor counts of `q-1/q+1`.
- orbit size/stabilizer size under full `PGL(2,q)`.
- quadratic-character counts for finite points, finite pair differences, and infinity-to-point pairs.
- cross-ratio orbit features over all 15 four-subsets: character counts, multiplicative orders,
  special values `-1`, `2`, and `1/2`.
- conic-involution features: for each 2-subset of the six points, form the split involution
  fixing that pair; for all 105 products, record PGL order counts/divisibilities, split vs
  nonsplit/parabolic type counts, and gcd sums against `q-1` and `q+1`.

## Bucket Table

| q | canon | size | label |
|---:|---|---:|:---:|
| 11 | `(0,1,2,3,4,5)` | 22 | N |
| 11 | `(0,1,2,3,4,6)` | 16 | P |
| 11 | `(0,1,2,3,5,6)` | 12 | P |
| 11 | `(0,1,2,3,5,9)` | 6 | P |
| 13 | `(0,1,2,3,4,5)` | 42 | P |
| 13 | `(0,1,2,3,4,6)` | 21 | P |
| 13 | `(0,1,2,3,5,6)` | 36 | P |
| 13 | `(0,1,2,3,5,11)` | 6 | P |
| 13 | `(0,1,2,4,5,8)` | 3 | P |
| 17 | `(0,1,2,3,4,5)` | 36 | N |
| 17 | `(0,1,2,3,4,6)` | 72 | N |
| 17 | `(0,1,2,3,4,7)` | 36 | N |
| 17 | `(0,1,2,3,4,8)` | 36 | N |
| 17 | `(0,1,2,3,4,9)` | 18 | P |
| 17 | `(0,1,2,3,4,10)` | 36 | N |
| 17 | `(0,1,2,3,4,inf)` | 18 | P |
| 17 | `(0,1,2,3,5,9)` | 12 | P |
| 17 | `(0,1,2,3,6,14)` | 3 | P |
| 17 | `(0,1,2,3,10,inf)` | 6 | P |
| 19 | `(0,1,2,3,4,5)` | 12 | P |
| 19 | `(0,1,2,3,4,6)` | 34 | P |
| 19 | `(0,1,2,3,4,7)` | 32 | P |
| 19 | `(0,1,2,3,4,8)` | 40 | P |
| 19 | `(0,1,2,3,4,9)` | 76 | P |
| 19 | `(0,1,2,3,4,11)` | 74 | P |
| 19 | `(0,1,2,3,4,inf)` | 18 | P |
| 19 | `(0,1,2,3,6,7)` | 10 | P |
| 19 | `(0,1,2,3,6,8)` | 32 | P |
| 19 | `(0,1,2,3,6,9)` | 20 | P |
| 19 | `(0,1,2,3,6,10)` | 32 | P |
| 19 | `(0,1,2,3,6,16)` | 19 | P |
| 19 | `(0,1,2,3,11,inf)` | 6 | P |

## Forward Split

Train q=11,13; test q=17,19.

Baseline:

```text
majority=P train=8/9 test=18/23 TP=0 TN=18 FP=0 FN=5
```

Best pure depth-3 tree:

```text
if invprod_div_qm <= 25.5:
  P
else:
  N
tree train=9/9 test=14/23 TP=0 TN=14 FP=4 FN=5
```

Best univariate/symbolic candidates:

```text
invprod_order_sum <= 859.5 -> true:N false:P train=9/9 test=18/23
invprod_order_mean_x100 <= 818.572 -> true:N false:P train=9/9 test=18/23
invprod_order_eq_5 <= 21 -> true:P false:N train=9/9 test=18/23
(stabilizer_size <= 71) and (pair_diff_chi_1 <= 5.5) -> true:N false:P train=9/9 test=18/23
```

These match the held-out accuracy of the all-P majority baseline; they do not recover the five
q=17 N buckets while keeping q=19 all-P.

sklearn cross-check:

```text
tree train=1.000 test=0.783
  |--- invprod_order_eq_5 <= 21.00
  |   |--- class: 0
  |--- invprod_order_eq_5 >  21.00
  |   |--- class: 1
l1_logistic train=0.889 test=0.565 nonzero=7
top coefficients: invprod_div_qp, cr_order_even, invprod_order_div_2, pair_diff_chi_-1
```

The sklearn tree's 18/23 is again the majority-level result. L1 logistic is worse and falsifies
itself by predicting several q=19 P buckets as N while still missing q=17 N buckets.

## Reverse Split

Train q=17,19; test q=11,13.

```text
majority=P train=18/23 test=8/9 TP=0 TN=8 FP=0 FN=1
```

Best pure depth-3 tree:

```text
if pair_diff_chi_1 <= 8.5:
  P
else:
  if invprod_gcd_qp_sum <= 292:
    N
  else:
    P
tree train=23/23 test=5/9 TP=0 TN=5 FP=3 FN=1
```

Best symbolic candidates overfit q=17/19 and get only 8/9 on q=11/13, i.e. no better than
the P baseline:

```text
(stabilizer_size <= 207) and (q_mod_8 <= 2) -> true:N false:P train=23/23 test=8/9
(stabilizer_size <= 207) and (num_pf_q_minus_1 <= 1.5) -> true:N false:P train=23/23 test=8/9
```

sklearn reverse:

```text
tree train=1.000 test=0.667
l1_logistic train=0.870 test=0.222 nonzero=10
```

## Falsification Notes

- q=13 and q=19 are all P (`q=13: 5/5`, `q=19: 13/13`), while q=17 is split (`5 N`, `5 P`).
- Configuration-heavy rules that separate q=17 N buckets tend to mark q=19 P buckets as N.
- q-arithmetic-only rules explain q=13/q=19 all-P too easily but fail to separate q=17's mixed
  column.
- Product-order/involution features are the strongest attributions, but shallow formulas built
  from them are not cross-q laws on this dataset.

Conclusion: no disciplined small law is ready for the proof lane. The next useful action is not
q=23 probing; it is either richer structural features for the two-intruder residual or more
training primes with mixed on-conic values.
