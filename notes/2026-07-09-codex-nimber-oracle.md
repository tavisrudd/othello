# C35 report: S4 Grundy oracle and coupling residuals

Date: 2026-07-09.

## Summary

Implemented a separate exact-Grundy S4 path in `2026-07-06-grid-cap-solver.rs`:

- `s4gdump`: all-children mex solver, raw `u128 -> u8 Grundy` dump format (`GCAPGRD1`).
- `s4gcheck`: shared-key validation against existing P/N raw dumps.
- `s4gmeasure`: S5/S6 true-Grundy measurements against `conic_nk_xor` and, where computable,
  `zone_nk_xor`.

Validation passed on every shared key tested.  The measurement verdict is negative for the
disjunctive-sum model: true game Grundy is not the live-conic xor, and even when the off-conic zone
Node-Kayles value is fully computable (`q=13`, and a q=17 S6 subset), `g = conic XOR zone` fails on
most rows.

## Format / implementation notes

The existing P/N raw/BuRR path is unchanged.  Grundy dumps use their own magic/version and keep the
same 128-byte guarded header shape:

```text
magic = GCAPGRD1
version = 1
canonicalizer = S4_CANON_ID
root kind = normalized on-conic inverse graph
value encoding = S4_VALUE_GRUNDY_U8
key format = u128 canonical key
record = key lo, key hi, u8 Grundy, zero padding
header extras = root Grundy byte, max observed Grundy byte
```

The solver asserts every observed Grundy value is `< 64`; max observed in these runs was `6`.

## Build

Command:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
```

Result: build passed.

## q=17 sizing gate

P/N baseline, same binary:

```bash
/run/current-system/sw/bin/time -f 'TIME elapsed=%e maxrss_kb=%M' \
  target/gridcap s4dump 17 1,2,3,4 --out /tmp/c35-q17-pn.raw
```

Output:

```text
S4DUMP q=17 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 9), (3, 6), (4, 13)] status=OK value=P records=64728 cap=none solve-elapsed=0.172 dump-elapsed=0.002 out=/tmp/c35-q17-pn.raw
TIME elapsed=0.18 maxrss_kb=19616
```

Exact Grundy:

```bash
/run/current-system/sw/bin/time -f 'TIME elapsed=%e maxrss_kb=%M' \
  target/gridcap s4gdump 17 1,2,3,4 \
  --out s4-dumps/2026-07-09/c35/q17-root-1234.grundy.raw
```

Output:

```text
S4GDUMP q=17 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 9), (3, 6), (4, 13)] status=OK root-grundy=0 value=P records=186466 cap=none max-grundy=6 solve-elapsed=0.830 dump-elapsed=0.007 out=s4-dumps/2026-07-09/c35/q17-root-1234.grundy.raw
TIME elapsed=0.84 maxrss_kb=27220
```

Cost at this root: `2.88x` records, `4.7x` wall, and `1.39x` max RSS versus the early-break P/N
dump.

## Validation

q=9 smoke:

```bash
target/gridcap s4gdump 9 1,2,3,4 --out s4-dumps/2026-07-09/c35/q09-root-1234.grundy.raw
target/gridcap s4gcheck 9 1,2,3,4 \
  --grundy s4-dumps/2026-07-09/c35/q09-root-1234.grundy.raw \
  --raw s4-dumps/2026-07-08/q09-root-1234-1-2-3-4.raw
```

Output:

```text
S4GDUMP q=9 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 2), (3, 6), (4, 5)] status=OK root-grundy=0 value=P records=17 cap=none max-grundy=1 solve-elapsed=0.000 dump-elapsed=0.000 out=s4-dumps/2026-07-09/c35/q09-root-1234.grundy.raw
S4GCHECK q=9 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 2), (3, 6), (4, 5)] pn-records=16 grundy-records=17 shared=16 pn-only=0 grundy-only=1 mismatches=0 max-grundy=1 verdict=PASS
```

q=13:

```text
S4GCHECK q=13 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 7), (3, 9), (4, 10)] pn-records=553 grundy-records=1117 shared=553 pn-only=0 grundy-only=564 mismatches=0 max-grundy=3 verdict=PASS
```

q=17:

```text
S4GCHECK q=17 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 9), (3, 6), (4, 13)] pn-records=64728 grundy-records=186466 shared=64728 pn-only=0 grundy-only=121738 mismatches=0 max-grundy=6 verdict=PASS
```

q=19:

```text
S4GDUMP q=19 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 10), (3, 13), (4, 5)] status=OK root-grundy=0 value=P records=2691979 cap=none max-grundy=6 solve-elapsed=16.893 dump-elapsed=0.114 out=s4-dumps/2026-07-09/c35/q19-root-1234.grundy.raw
TIME elapsed=17.01 maxrss_kb=238424
S4GCHECK q=19 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 10), (3, 13), (4, 5)] pn-records=147727 grundy-records=2691979 shared=147727 pn-only=0 grundy-only=2544252 mismatches=0 max-grundy=6 verdict=PASS
```

## Coupling measurements

q=13:

```text
GPLY ply=5 states=40 known=40 missing=0 true_hist=1:12,3:28 conic_known=40 conic_unknown=0 conic_hist=0:24,1:16 residual_hist=1:12,2:16,3:12 zone_known=40 zone_unknown=0 zone_sum_match=12 zone_sum_mismatch=28 zone_residual_hist=0:12,1:6,2:8,3:10,5:4
GPLY ply=6 states=329 known=329 missing=0 true_hist=0:89,1:22,2:218 conic_known=329 conic_unknown=0 conic_hist=0:159,1:170 residual_hist=0:63,1:48,2:90,3:128 zone_known=329 zone_unknown=0 zone_sum_match=145 zone_sum_mismatch=184 zone_residual_hist=0:145,1:108,2:20,3:56
```

q=17:

```text
GPLY ply=5 states=104 known=104 missing=0 true_hist=3:104 conic_known=104 conic_unknown=0 conic_hist=0:56,1:48 residual_hist=2:48,3:56 zone_known=0 zone_unknown=104 zone_sum_match=0 zone_sum_mismatch=0 zone_residual_hist=-
GPLY ply=6 states=3109 known=3109 missing=0 true_hist=0:207,1:1143,2:858,4:463,5:394,6:44 conic_known=3109 conic_unknown=0 conic_hist=0:1319,1:1167,2:250,3:373 residual_hist=0:482,1:829,2:455,3:442,4:367,5:340,6:114,7:80 zone_known=798 zone_unknown=2311 zone_sum_match=154 zone_sum_mismatch=644 zone_residual_hist=0:154,1:118,2:57,3:84,4:108,5:131,6:73,7:73
```

q=19:

```text
GPLY ply=5 states=148 known=148 missing=0 true_hist=1:148 conic_known=148 conic_unknown=0 conic_hist=0:58,1:90 residual_hist=0:90,1:58 zone_known=0 zone_unknown=148 zone_sum_match=0 zone_sum_mismatch=0 zone_residual_hist=-
GPLY ply=6 states=6870 known=6870 missing=0 true_hist=0:5220,2:282,3:1269,5:32,6:67 conic_known=6870 conic_unknown=0 conic_hist=0:2665,1:2151,2:961,3:1093 residual_hist=0:2312,1:1864,2:1288,3:1307,4:14,5:20,6:41,7:24 zone_known=0 zone_unknown=6870 zone_sum_match=0 zone_sum_mismatch=0 zone_residual_hist=-
```

## Verdict

The conic-only `conic_nk_xor` is a useful feature but not the true game nimber.  At q=17 S6 it
matches only `482/3109` exact states; at q=19 S6 it matches `2312/6870`.

The stronger tested decomposition `g = g_conic XOR g_zone` is also false.  In the fully zone-known
q=13 sample it matches only `12/40` S5 states and `145/329` S6 states.  In the q=17 S6 subset where
the zone graph Grundy is computable, it matches `154/798` states.  This supports Fable's review:
the conic and off-conic zone are coupled by intruder moves, so the proof lane should be a
maintenance/termination argument, not "steer conic xor to zero, then solve a disjoint zone."
