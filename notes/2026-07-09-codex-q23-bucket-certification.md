# C54 q=23 Full-PGL Bucket Certification

Date: 2026-07-09.

## Result

**PASS: all 22 full-`PGL(2,23)` on-conic S4 bucket roots are rules-certified P at the
early-break proof-DAG layer.**

The new `s4pncheck` mode independently reconstructs the residual grid board and legal moves from
each declared root. It does not call the minimax solver. It checked all `241,627,613` records in
the 22 existing `GCAPRAW3` dumps, with exact reachability coverage and zero game-equation
failures.

Combined with C53's Lean theorem `ProjectiveCap.Sym2Bridge.onconic_value_bridge`, the q=23 row may
now be stated as:

> q=23 is computed and rules-certified at the S4 full-PGL bucket layer.

This is still not a Lean theorem for `Projective.InitialPStatement`. The checker is native Rust,
and it trusts the documented `Board::canon` u128 key as the state identifier, as C54 permits.

## Certificate Contract

The existing P/N dumps come from the early-break recursion `s4_g`; they are not all-children
Grundy tables. The sound certificate encoded by one raw dump is therefore a reply-book DAG:

- a P row must contain **every** legal child, and every child must be N;
- an N row must contain at least one P child witness;
- other children of an N row may be absent because they are irrelevant to the existential N
  obligation;
- every present child is recursively checked;
- every record in the dump must be reachable from the root through present child edges;
- terminal rows must be P.

Thus `omitted-n-edges` is expected and explicitly measured. A missing P-row child, an N row with
no P witness, a P row with a P child, an N terminal, an unreachable raw record, or any raw
header/root/format inconsistency is a hard failure. This is the explicit-P-reply-book substrate
from C54 option 3, represented directly by the already-generated early-break raw table; it is
strictly smaller than regenerating an all-children Grundy table.

Raw restore additionally checks magic/version, header and record sizes, canonicalizer id, root
kind, `MAXW`, q, GF-table hash, normalized t4, root cells/key, status/value encoding, strict key
order, legal value bytes, exact file length, flags, and zero padding.

## Implementation

Modified:

- `notes/2026-07-06-grid-cap-solver.rs`: added `s4pncheck` and record-index-returning raw lookup;
- `notes/2026-07-08-s4-memo-dump-query-manual.md`: documented the proof-DAG contract;
- `rust/scripts/s4-c54-check-suite.sh`: fixed 22-root inventory and reproducible timed suite.

Build command:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-c54
```

Output:

```text
<no output; exit 0>
```

## Validation Gates

Known small roots, including the q=11 N-valued control:

```bash
target/gridcap-c54 s4pncheck 9 1,2,3,4 --raw s4-dumps/2026-07-08/q09-root-1234-1-2-3-4.raw
target/gridcap-c54 s4pncheck 11 1,2,3,4 --raw s4-dumps/2026-07-08/q11-root-1234-1-2-3-4.raw
target/gridcap-c54 s4pncheck 13 1,2,3,4 --raw s4-dumps/2026-07-08/q13-root-1234-1-2-3-4.raw
target/gridcap-c54 s4pncheck 17 1,2,3,4 --raw s4-dumps/2026-07-08/q17-root-1234-1-2-3-4.raw
```

Verbatim outputs:

```text
S4PNCHECK q=9 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 2), (3, 6), (4, 5)] root=P records=16 seen=16 unseen=0 p-nodes=7 n-nodes=9 terminal=3 edges=31 present-edges=29 omitted-n-edges=2 missing-p-edges=0 terminal-n=0 p-has-p-child=0 n-without-p-child=0 max-ply=8 failures=0 verdict=PASS elapsed=0.000
S4PNCHECK q=11 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 6), (3, 4), (4, 3)] root=N records=42 seen=42 unseen=0 p-nodes=18 n-nodes=24 terminal=13 edges=117 present-edges=76 omitted-n-edges=41 missing-p-edges=0 terminal-n=0 p-has-p-child=0 n-without-p-child=0 max-ply=10 failures=0 verdict=PASS elapsed=0.000
S4PNCHECK q=13 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 7), (3, 9), (4, 10)] root=P records=553 seen=553 unseen=0 p-nodes=202 n-nodes=351 terminal=148 edges=1926 present-edges=1269 omitted-n-edges=657 missing-p-edges=0 terminal-n=0 p-has-p-child=0 n-without-p-child=0 max-ply=12 failures=0 verdict=PASS elapsed=0.004
S4PNCHECK q=17 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 9), (3, 6), (4, 13)] root=P records=64728 seen=64728 unseen=0 p-nodes=21257 n-nodes=43471 terminal=15272 edges=249749 present-edges=174368 omitted-n-edges=75381 missing-p-edges=0 terminal-n=0 p-has-p-child=0 n-without-p-child=0 max-ply=16 failures=0 verdict=PASS elapsed=0.452
```

Semantic header mutation gate:

```bash
cp s4-dumps/2026-07-08/q11-root-1234-1-2-3-4.raw /tmp/c54-q11-bad-header.raw
printf '\001' | dd of=/tmp/c54-q11-bad-header.raw bs=1 seek=60 count=1 conv=notrunc status=none
target/gridcap-c54 s4pncheck 11 1,2,3,4 --raw /tmp/c54-q11-bad-header.raw
```

Verbatim output:

```text
s4pncheck: root record/status mismatch: header=P record=N
```

Exit status was 2, as required.

Semantic record-value mutation gate (the first q=11 record byte is N=`1`, flipped to P=`0`):

```bash
cp s4-dumps/2026-07-08/q11-root-1234-1-2-3-4.raw /tmp/c54-q11-bad-value.raw
printf '\000' | dd of=/tmp/c54-q11-bad-value.raw bs=1 seek=144 count=1 conv=notrunc status=none
target/gridcap-c54 s4pncheck 11 1,2,3,4 --raw /tmp/c54-q11-bad-value.raw
```

Verbatim output:

```text
S4PNCHECK q=11 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 6), (3, 4), (4, 3)] root=N records=42 seen=42 unseen=0 p-nodes=19 n-nodes=23 terminal=13 edges=117 present-edges=76 omitted-n-edges=38 missing-p-edges=3 terminal-n=0 p-has-p-child=1 n-without-p-child=0 max-ply=10 failures=4 verdict=FAIL elapsed=0.000 first-bad=P row has P child: parent=00150b1a079611ba7322ff392a7cd348 child=005a4aa361c6c748d4ba6a07ab341a69 move=8,7
```

Exit status was 1, as required.

## Inventory and Full Suite

`target/gridcap-c54 s4bucketlist 23` reproduced 22 full-PGL buckets. The two pre-C37 exact roots
are bucket 8 (`1,2,3,4`) and bucket 12 (`1,2,5,6`); the other 20 are under
`rust/s4-dumps/2026-07-09/c37-q23-raw/`. Raw restore confirmed every header was root-matched,
status P, and exact rather than aborted.

C37's independent sorted-union check remains:

```text
UNION group=0 q=23 files=22 total_records=241627613 unique_keys=217478689 multi_keys=18319494 duplicate_observations=24148924 max_multiplicity=20 disagreement_keys=0
```

First-bucket sizing was `107.14s` wall and `209,052 KB` peak RSS for 7,268,365 records. That
projected the full suite within the C54 8h/8GB gate, so the complete one-core run was launched:

```bash
scripts/s4-c54-check-suite.sh
```

Full verbatim output is in:

```text
rust/s4-dumps/2026-07-09/c54-q23-pncheck.log
```

Per-bucket results:

| idx | representative | C29/C37 label | records | wall s | max RSS KB | check |
|---:|---|:---:|---:|---:|---:|:---:|
| 0 | `1,3,4,9` | P | 7,268,365 | 107.14 | 209,052 | PASS |
| 1 | `1,2,3,8` | P | 13,148,006 | 204.60 | 347,096 | PASS |
| 2 | `1,2,3,5` | P | 12,313,159 | 193.41 | 327,344 | PASS |
| 3 | `1,2,5,11` | P | 12,997,669 | 239.85 | 343,268 | PASS |
| 4 | `1,2,5,10` | P | 6,632,635 | 97.05 | 193,936 | PASS |
| 5 | `1,2,6,8` | P | 7,198,921 | 105.27 | 206,984 | PASS |
| 6 | `1,3,4,11` | P | 12,857,763 | 200.64 | 340,208 | PASS |
| 7 | `1,2,3,11` | P | 12,283,339 | 227.33 | 326,764 | PASS |
| 8 | `1,2,3,4` | P | 12,572,289 | 195.67 | 333,716 | PASS |
| 9 | `1,2,3,7` | P | 13,082,584 | 205.37 | 345,556 | PASS |
| 10 | `1,2,5,15` | P | 12,702,614 | 236.79 | 336,824 | PASS |
| 11 | `1,2,5,18` | P | 8,366,118 | 125.90 | 234,212 | PASS |
| 12 | `1,2,5,6` | P | 14,201,898 | 222.27 | 371,836 | PASS |
| 13 | `1,2,3,6` | P | 6,448,466 | 130.66 | 189,120 | PASS |
| 14 | `1,2,5,7` | P | 11,933,770 | 187.98 | 318,156 | PASS |
| 15 | `1,2,6,19` | P | 12,977,589 | 203.71 | 343,128 | PASS |
| 16 | `1,2,3,10` | P | 12,727,293 | 212.12 | 337,296 | PASS |
| 17 | `1,2,6,14` | P | 11,815,869 | 269.19 | 317,576 | PASS |
| 18 | `1,2,6,10` | P | 12,606,031 | 215.48 | 334,952 | PASS |
| 19 | `1,2,3,12` | P | 13,618,259 | 233.69 | 358,816 | PASS |
| 20 | `1,2,3,13` | P | 6,954,420 | 158.30 | 202,752 | PASS |
| 21 | `1,3,7,10` | P | 6,920,556 | 105.26 | 201,112 | PASS |

Aggregate parsed from the durable log:

```text
roots=22 pass=22 records=241627613 seen=241627613 p_nodes=75748013 n_nodes=165879600 terminal=50375851 edges=988106416 present_edges=717404772 omitted_n_edges=270701644 failures=0 wall_seconds=4077.68 maxrss_kb=371836
```

Every bucket had:

```text
unseen=0 missing-p-edges=0 terminal-n=0 p-has-p-child=0 n-without-p-child=0 failures=0 verdict=PASS
```

## Trust Statement

C54 closes the ordinary native-rules certificate gap for the 22 q=23 bucket labels. The complete
chain is now:

1. C29 enumerates the 22 full-PGL representatives and labels them P.
2. C37 supplies exact raw dumps and finds zero value disagreements on 18,319,494 shared keys.
3. C54 independently checks the legal-move proof DAG for every raw record and all 22 roots.
4. C53's Lean full-PGL bridge transports those roots to every on-conic S4 child.

The remaining gap to a fully Lean-unconditional q=23 `Projective.InitialPStatement` is a Lean
consumer/reflection theorem for these certificates plus the surrounding fixed-q assembly. No new
q=23 solving or duplicate representative work is needed.
