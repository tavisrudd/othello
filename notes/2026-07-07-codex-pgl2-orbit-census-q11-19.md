# Codex C15 report: PGL(2,q) orbit-collapse census for q=11,13,19

**Date:** 2026-07-07.

## Result

Reran the C5 PGL(2,q) methodology at q = 11, 13, 19. Lemma I's value-invariance
prediction survived all three prime-field checks:

| q | feat classes | on-conic records | PGL(2,q) maps | orbit buckets | collapse | values | mixed buckets |
|---:|---:|---:|---:|---:|---:|---|---:|
| 11 | 8 | 56 | 1,320 | 4 | 14.0x | N:22, P:34 | 0 |
| 13 | 12 | 108 | 2,184 | 5 | 21.6x | P:108 | 0 |
| 19 | 27 | 405 | 6,840 | 13 | 31.2x | P:405 | 0 |

So no pair of on-conic `S4` children in the same full-`PGL(2,q)` orbit had mixed game
values. The collapse is large enough to matter for Route C: per-orbit on-conic books would be
much smaller than per-raw-child books if the orbit bridge is formalized.

Together with C5's q=17 check (`273 -> 10`, mixed buckets `0`), the prime odd-plane data now
tested is:

| q | raw on-conic children | full-PGL buckets | mixed buckets |
|---:|---:|---:|---:|
| 11 | 56 | 4 | 0 |
| 13 | 108 | 5 | 0 |
| 17 | 273 | 10 | 0 |
| 19 | 405 | 13 | 0 |

## Method

Checker: [`2026-07-07-pgl2-orbit-census.py`](2026-07-07-pgl2-orbit-census.py).

Commands:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-codex-c15
/tmp/gridcap-codex-c15 feat 11 > /tmp/codex-feat11-c15.out
/tmp/gridcap-codex-c15 feat 13 > /tmp/codex-feat13-c15.out
/tmp/gridcap-codex-c15 feat 19 > /tmp/codex-feat19-c15.out
python3 ../notes/2026-07-07-pgl2-orbit-census.py \
  /tmp/codex-feat11-c15.out /tmp/codex-feat13-c15.out /tmp/codex-feat19-c15.out
```

Feat-log checks:

```text
/tmp/codex-feat11-c15.out:353:FEAT-SUMMARY q=11 root=P size3-classes=8 sanity=OK
/tmp/codex-feat13-c15.out:889:FEAT-SUMMARY q=13 root=P size3-classes=12 sanity=OK
/tmp/codex-feat19-c15.out:5725:FEAT-SUMMARY q=19 root=P size3-classes=27 sanity=OK
```

For each `CLS` class, the checker refits the conic through the logged `S3` and the two
directions:

```text
rc + eps*r + zeta*c + gamma = 0
rho = -zeta
A = -eps
B = rho*A - gamma
t = r - rho
```

For every logged `pos=on` child, it verifies the conic equation and hyperbola parameterization,
then forms the sorted six-set `{infinity, 0, t1, t2, t3, t4}`. The canonical form is the
lexicographically smallest image of the six-set under all non-singular Mobius maps over `F_q`,
modulo scalar normalization.

## Bucket Output

```text
q=11
feat_summary=root=P size3-classes=8 sanity=OK
pgl_maps=1320
on_records=56
buckets=4
collapse=56->4
bucket_size_hist={6: 1, 12: 1, 16: 1, 22: 1}
value_counts={'N': 22, 'P': 34}
constant_buckets=4
violations=0

q=13
feat_summary=root=P size3-classes=12 sanity=OK
pgl_maps=2184
on_records=108
buckets=5
collapse=108->5
bucket_size_hist={3: 1, 6: 1, 21: 1, 36: 1, 42: 1}
value_counts={'P': 108}
constant_buckets=5
violations=0

q=19
feat_summary=root=P size3-classes=27 sanity=OK
pgl_maps=6840
on_records=405
buckets=13
collapse=405->13
bucket_size_hist={6: 1, 10: 1, 12: 1, 18: 1, 19: 1, 20: 1, 32: 3, 34: 1, 40: 1, 74: 1, 76: 1}
value_counts={'P': 405}
constant_buckets=13
violations=0

TOTAL_VIOLATIONS=0
```

Representative largest buckets:

```text
q=11
canon=(0, 1, 2, 3, 4, 5) size=22 values={'N': 22}
canon=(0, 1, 2, 3, 4, 6) size=16 values={'P': 16}
canon=(0, 1, 2, 3, 5, 6) size=12 values={'P': 12}
canon=(0, 1, 2, 3, 5, 9) size=6 values={'P': 6}

q=13
canon=(0, 1, 2, 3, 4, 5) size=42 values={'P': 42}
canon=(0, 1, 2, 3, 5, 6) size=36 values={'P': 36}
canon=(0, 1, 2, 3, 4, 6) size=21 values={'P': 21}
canon=(0, 1, 2, 3, 5, 11) size=6 values={'P': 6}
canon=(0, 1, 2, 4, 5, 8) size=3 values={'P': 3}

q=19
canon=(0, 1, 2, 3, 4, 9) size=76 values={'P': 76}
canon=(0, 1, 2, 3, 4, 11) size=74 values={'P': 74}
canon=(0, 1, 2, 3, 4, 8) size=40 values={'P': 40}
canon=(0, 1, 2, 3, 4, 6) size=34 values={'P': 34}
canon=(0, 1, 2, 3, 6, 10) size=32 values={'P': 32}
canon=(0, 1, 2, 3, 6, 8) size=32 values={'P': 32}
canon=(0, 1, 2, 3, 4, 7) size=32 values={'P': 32}
```

## Interpretation

The q=11 on-conic data has exactly one N orbit and three P orbits. q=13 and q=19 are all-P on
the on-conic layer, so the constancy check is less adversarial there, but still confirms that
the parser/orbit machinery does not split a P bucket incorrectly.

For Route C, this supports an orbit-level compression target: certify one representative per
full-PGL six-set orbit, then prove transport back to each class child. The hard part is the
Lean orbit bridge, not the game-value invariance, which has now survived q=11,13,17,19.

## Adversarial Review

**Mixed-bucket reviewer.** The checker stops with nonzero exit status if any bucket has both
`P` and `N` records. This run ended with `TOTAL_VIOLATIONS=0`.

**Conic-parameter reviewer.** The checker does not trust logged class labels alone. It refits
the conic from the logged `S3`, verifies each `pos=on` child satisfies the equation, and checks
the recovered hyperbola parameter relation before canonicalizing.

**Group-action reviewer.** The PGL enumerator normalizes scalar multiples and asserts the exact
map count `q * (q^2 - 1)`. Counts matched for all three q.

**Scope reviewer.** This is a prime-field script matching C15. It intentionally does not handle
GF(9); the q=9 intrusion/orbit work used a separate GF(9) implementation.
