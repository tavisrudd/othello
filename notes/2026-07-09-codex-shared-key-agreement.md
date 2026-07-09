# C37 Shared-Key Agreement

Date: 2026-07-09.

## Summary

Added `rust/scripts/s4_raw_isect.py`, a raw-only `GCAPRAW3` intersection checker for S4 memo
dumps.  It reads the documented raw layout directly:

```text
header: 128 bytes
record: 24 bytes
key:    little-endian u128 as lo64, hi64
value:  bool byte, P=0 and N=1
tail:   7 zero padding bytes
```

Result:

- q=19 all 13 exact bucket roots: clean agreement on every shared key.
- q=23 all 22 exact bucket roots: clean agreement on every shared key.
- q=19 union versus q=23 union: zero shared keys, as expected for different q/GF headers.

No P-vs-N disagreement was found.

Full verbatim pairwise logs are saved under `rust/s4-dumps/2026-07-09/`:

- `c37-q19-isect.txt`
- `c37-q23-isect.txt`
- `c37-q19-q23-cross.txt`

## Tool

Script:

```text
rust/scripts/s4_raw_isect.py
```

The checker rejects non-raw formats by magic/version/header, checks `S4_CANON_ID`, q, GF hash,
root kind, value encoding, key format, record length, strict key order, value bytes, and record
padding.  Within one q/GF group it computes all pairwise overlap counts during a single sorted-union
stream, then reports union-level overlap multiplicity and any value disagreements.

Syntax check:

```bash
python3 -m py_compile scripts/s4_raw_isect.py
```

Output:

```text
<no output; exit 0>
```

## q=23 Raw Completion

Before C37, exact raw files existed for all q=19 bucket roots and only two q=23 roots.  I generated
the missing 20 q=23 raw roots with the current standalone solver:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-c37
```

Output:

```text
<no output; exit 0>
```

Command shape used for each missing q=23 representative:

```bash
target/gridcap-c37 s4dump 23 <rep> --cap 50000000 --out s4-dumps/2026-07-09/c37-q23-raw/q23-bucket<idx>-<rep>.raw
```

All 20 new q=23 dumps completed with `status=OK value=P`.  Record counts ranged from 6,448,466 to
13,618,259.  The two older exact q=23 raw dumps were reused:

- `s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw`
- `s4-dumps/2026-07-08/q23-bucket09-1256-1-2-5-6.raw`

## q=19 Check

Command:

```bash
python3 scripts/s4_raw_isect.py s4-dumps/2026-07-08/q19-bucket*.raw > s4-dumps/2026-07-09/c37-q19-isect.txt
```

Verbatim summary tail:

```text
PAIR group=0 a=9 b=12 shared=1077 disagreements=0 a_path=s4-dumps/2026-07-08/q19-bucket09-1-2-5-6.raw b_path=s4-dumps/2026-07-08/q19-bucket12-1-2-3-11.raw
PAIR group=0 a=10 b=11 shared=1003 disagreements=0 a_path=s4-dumps/2026-07-08/q19-bucket10-1-2-3-6.raw b_path=s4-dumps/2026-07-08/q19-bucket11-1-2-5-16.raw
PAIR group=0 a=10 b=12 shared=2841 disagreements=0 a_path=s4-dumps/2026-07-08/q19-bucket10-1-2-3-6.raw b_path=s4-dumps/2026-07-08/q19-bucket12-1-2-3-11.raw
PAIR group=0 a=11 b=12 shared=1097 disagreements=0 a_path=s4-dumps/2026-07-08/q19-bucket11-1-2-5-16.raw b_path=s4-dumps/2026-07-08/q19-bucket12-1-2-3-11.raw
UNION group=0 q=19 files=13 total_records=1725015 unique_keys=1531020 multi_keys=155219 duplicate_observations=193995 max_multiplicity=13 disagreement_keys=0
```

Interpretation: 1,531,020 unique q=19 canonical keys; 155,219 keys appear in at least two roots;
193,995 duplicate observations beyond the first occurrence; no disagreement keys.

## q=23 Check

Command:

```bash
python3 scripts/s4_raw_isect.py \
  s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw \
  s4-dumps/2026-07-08/q23-bucket09-1256-1-2-5-6.raw \
  s4-dumps/2026-07-09/c37-q23-raw/*.raw \
  > s4-dumps/2026-07-09/c37-q23-isect.txt
```

Verbatim summary tail:

```text
PAIR group=0 a=18 b=21 shared=42727 disagreements=0 a_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket18-12610.raw b_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket21-13710.raw
PAIR group=0 a=19 b=20 shared=122993 disagreements=0 a_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket19-12312.raw b_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket20-12313.raw
PAIR group=0 a=19 b=21 shared=31207 disagreements=0 a_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket19-12312.raw b_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket21-13710.raw
PAIR group=0 a=20 b=21 shared=21832 disagreements=0 a_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket20-12313.raw b_path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket21-13710.raw
UNION group=0 q=23 files=22 total_records=241627613 unique_keys=217478689 multi_keys=18319494 duplicate_observations=24148924 max_multiplicity=20 disagreement_keys=0
```

Interpretation: 217,478,689 unique q=23 canonical keys across the 22 S4 bucket roots; 18,319,494
keys appear in at least two roots; 24,148,924 duplicate observations beyond the first occurrence;
some keys appear in 20 roots; no disagreement keys.

## Cross-q Guard

Command:

```bash
python3 scripts/s4_raw_isect.py --only-cross-groups \
  s4-dumps/2026-07-08/q19-bucket*.raw \
  s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw \
  s4-dumps/2026-07-08/q23-bucket09-1256-1-2-5-6.raw \
  s4-dumps/2026-07-09/c37-q23-raw/*.raw \
  > s4-dumps/2026-07-09/c37-q19-q23-cross.txt
```

Verbatim summary tail:

```text
FILE idx=28 q=23 gf_hash=0a7cba6401a7d661 t4=1,2,6,19 status=P records=12977589 cap=50000000 root_key=07bdd54fa74dc70e3c0944e45bb2e403 path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket15-12619.raw
FILE idx=29 q=23 gf_hash=0a7cba6401a7d661 t4=1,2,3,10 status=P records=12727293 cap=50000000 root_key=06d37ffc1e2aadf594b38c83b8727066 path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket16-12310.raw
FILE idx=30 q=23 gf_hash=0a7cba6401a7d661 t4=1,2,6,14 status=P records=11815869 cap=50000000 root_key=0daa11646cb33f42b6db5f44e188debe path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket17-12614.raw
FILE idx=31 q=23 gf_hash=0a7cba6401a7d661 t4=1,2,6,10 status=P records=12606031 cap=50000000 root_key=0b2f5680bb661605541c9e5caf6dd831 path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket18-12610.raw
FILE idx=32 q=23 gf_hash=0a7cba6401a7d661 t4=1,2,3,12 status=P records=13618259 cap=50000000 root_key=05111ae6088cdee170a683536a306caa path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket19-12312.raw
FILE idx=33 q=23 gf_hash=0a7cba6401a7d661 t4=1,2,3,13 status=P records=6954420 cap=50000000 root_key=01992807c0c75e0232d930b6979fd703 path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket20-12313.raw
FILE idx=34 q=23 gf_hash=0a7cba6401a7d661 t4=1,3,7,10 status=P records=6920556 cap=50000000 root_key=0deb7d522f938a2062d02d326f1c91d9 path=s4-dumps/2026-07-09/c37-q23-raw/q23-bucket21-13710.raw
CROSS q_a=19 gf_a=b5e4495d6cf98c9b files_a=13 q_b=23 gf_b=0a7cba6401a7d661 files_b=22 shared_unique_keys=0 disagreements=0
```

## Bad-pattern Check

Command:

```bash
rg 'disagreements=[1-9]|disagreement_keys=[1-9]|shared_unique_keys=[1-9]' \
  s4-dumps/2026-07-09/c37-q19-isect.txt \
  s4-dumps/2026-07-09/c37-q23-isect.txt \
  s4-dumps/2026-07-09/c37-q19-q23-cross.txt
```

Output:

```text
<no output; exit 1 because there were no matches>
```

## Verdict

C37 passes.  The shared canonical key agrees across millions of overlapping exact raw entries:

- q=19 shared keys: 155,219 unique keys with multiplicity at least 2, zero disagreements.
- q=23 shared keys: 18,319,494 unique keys with multiplicity at least 2, zero disagreements.
- q=19 versus q=23: zero shared keys.

This is a scaled soundness check for `canon()` and the raw S4 oracle.  It does not prove absence of
all possible 128-bit fingerprint collisions, but it cross-validates the actually reached q=19/q=23
bucket corpora at the raw-table scale.
