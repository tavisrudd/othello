# Codex C5 PGL(2,17) orbit value-invariance check (2026-07-07)

## Result

Lemma I's q=17 consistency prediction passes on the regenerated `feat` data:

- q=17 `feat` run: `3297` extension records, `21` size-3 classes, `sanity=OK`.
- on-conic records tested: `273 = 21 * (17 - 4)`.
- full `PGL(2,17)` maps enumerated: `4896`.
- raw on-conic children collapse to `10` PGL-orbits of 6-point parameter sets.
- mixed-value orbit buckets: `0`.

So every pair of q=17 on-conic size-4 positions whose parameter sets
`{infinity, 0, t1, t2, t3, t4} subset P1(F_17)` are equivalent under full `PGL(2,17)` has the
same game value in this data. This does not prove Lemma I, but it finds no counterexample and
shows the full-PGL moduli collapse is large: `273` children to `10` buckets.

## Method

I rebuilt a private copy of the solver binary under `/tmp` and did not edit
`2026-07-06-grid-cap-solver.rs`.

Commands:

```bash
rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-codex-c5
{ time /tmp/gridcap-codex-c5 feat 17 > /tmp/codex-feat17.out; } 2> /tmp/codex-feat17.err
python3 /tmp/codex_pgl2_orbit_check.py /tmp/codex-feat17.out > /tmp/codex-pgl2-orbit-check.out
```

Runtime:

```text
real 0m33.124s
user 0m32.844s
sys  0m0.099s
```

Feat-log checks:

```text
3319 /tmp/codex-feat17.out
3297 X q=17 records
21 CLS q=17 records
FEAT-SUMMARY q=17 root=P size3-classes=21 sanity=OK
```

For each `CLS` class, the parser refits:

```text
rc + eps*r + zeta*c + gamma = 0
rho = -zeta
A = -eps
B = rho*A - gamma
t = r - rho
```

It verifies each logged `pos=on` cell satisfies the conic equation and the hyperbola relation
`(r-rho)(c-A)=B`, then forms the sorted 6-set `{infinity, 0, t1, t2, t3, t4}`. In the canonical
tuples below, `17` denotes `infinity`.

The PGL canonical form is the lexicographically smallest image of the 6-set over all matrices
`[[a,b],[c,d]]` over `F_17` with nonzero determinant, modulo scalar normalization. The enumerator
asserts the expected map count `17 * (17^2 - 1) = 4896`.

## Bucket Table

```text
q=17
pgl_maps=4896
on_records=273
buckets=10
bucket_size_hist={3: 1, 6: 1, 12: 1, 18: 2, 36: 4, 72: 1}
value_counts={'N': 216, 'P': 57}
constant_buckets=10
violations=0

canon=(0, 1, 2, 3, 4, 6)    size=72  values={'N': 72}
canon=(0, 1, 2, 3, 4, 10)   size=36  values={'N': 36}
canon=(0, 1, 2, 3, 4, 8)    size=36  values={'N': 36}
canon=(0, 1, 2, 3, 4, 7)    size=36  values={'N': 36}
canon=(0, 1, 2, 3, 4, 5)    size=36  values={'N': 36}
canon=(0, 1, 2, 3, 4, 17)   size=18  values={'P': 18}
canon=(0, 1, 2, 3, 4, 9)    size=18  values={'P': 18}
canon=(0, 1, 2, 3, 5, 9)    size=12  values={'P': 12}
canon=(0, 1, 2, 3, 10, 17)  size=6   values={'P': 6}
canon=(0, 1, 2, 3, 6, 14)   size=3   values={'P': 3}
```

## Interpretation

The q=17 data is not merely consistent with Lemma I; it is sharply orbit-separated here:
all five N-orbits are the larger buckets, and all five P-orbits are the smaller buckets. That
may be useful for the next intrusion-calculus pass, because the on-conic value law at q=17 can
be described as a 10-row full-PGL orbit table rather than 273 child values or 21 per-class
lists.

