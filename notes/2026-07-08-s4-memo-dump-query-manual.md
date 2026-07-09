# S4 Memo Dump / Query Manual

This manual covers the Rust `s4dump`, `s4freeze`, `s4query`, and `s4mine` modes in
[`2026-07-06-grid-cap-solver.rs`](2026-07-06-grid-cap-solver.rs).  These modes are for targeted
pattern mining around normalized on-conic S4 roots in the residual `PG(2,q)` grid game.

## Build

From the repository root:

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-s4
```

From `rust/`, use:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
```

The modes use the standalone solver file directly; they do not require Cargo.

## What Is Dumped

An S4 root is given by four nonzero conic parameters:

```text
t1,t2,t3,t4
```

and represents the affine grid cells:

```text
{(t, 1/t) : t in {t1,t2,t3,t4}}
```

`s4dump` runs the existing recursive solver from that root and dumps the canonical memo entries it
has solved before completion or cap abort.  A dump is therefore a partial or complete value oracle
for states reachable and solved during that search, not a complete database for every state at that
ply.

The parser sorts the four `t` values, so `1,2,3,4` and `4,3,2,1` denote the same root.

## Raw Versus Compact

There are two restore formats.

Raw dump:

```text
exact sorted mmap table
key = u128 Board::canon key
value = bool, false=P and true=N
```

Use raw dumps for validation and anything certificate-adjacent.  Raw lookup is exact relative to
the solver's canonical key.

Compact archive:

```text
BuRR-style bumped ribbon archive
key = folded u64 canonical key
value = 1-bit P/N
membership = fingerprint bits
```

Use compact archives for exploratory pattern mining when the raw file is too large.  A compact
archive can have false positives in principle; increase `--fp-bits` for safer exploratory queries
and confirm any surprising result against raw or by direct solve.  `s4freeze` rejects folded-key
collisions inside the represented raw corpus, but membership false positives remain possible for
keys outside the corpus.

## Safe Restore Headers

Both formats carry fixed headers before records/layers, following the Queens BuRR pattern:

```text
magic
format version
header length
canonicalizer id
GF table hash
root kind
q
normalized t4 parameters
root affine cells
root canonical key
MAXW
key format
value encoding
record/layer counts
```

The compact archive additionally records:

```text
fold id
source raw-record count
fingerprint width
load target
source root status
```

`s4query` rejects mismatched roots, GF encodings, and stale/foreign formats before answering.  Raw
restore also scans the mapped record table for strict key ordering, legal value bytes, and zero
record padding.

## Commands

### `s4dump`

```bash
/tmp/gridcap-s4 s4dump <q> <t1,t2,t3,t4> --out <raw-file> [--cap <slots>]
```

Example:

```bash
/tmp/gridcap-s4 s4dump 17 1,2,3,4 --cap 1000000 --out /tmp/s4-q17.raw
```

Typical output:

```text
S4DUMP q=17 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 9), (3, 6), (4, 13)] status=OK value=P records=64728 cap=1000000 solve-elapsed=0.182 dump-elapsed=0.003 out=/tmp/s4-q17.raw
```

Important fields:

- `status=OK`: the root value was solved.
- `status=ABORTED`: the memo cap was reached; the dump is partial.
- `records`: number of solved canonical memo entries written.  The cap is a soft abort threshold:
  a run can write slightly more records than `--cap` because the recursive solver checks the cap
  before expansion and inserts solved parents afterward.
- `value`: root value if solved, otherwise `-`.

### `s4freeze`

```bash
/tmp/gridcap-s4 s4freeze <raw-file> <burr-file> [--fp-bits <bits>] [--load <0.1..1.0>]
```

Example:

```bash
/tmp/gridcap-s4 s4freeze /tmp/s4-q17.raw /tmp/s4-q17.burr --fp-bits 40 --load 0.90
```

Typical output:

```text
S4FREEZE raw=/tmp/s4-q17.raw out=/tmp/s4-q17.burr records=64728 keys=64728 fold-collisions=0 fp-bits=40 load=0.900 layers=2 bits/key=45.720 file-bytes=370144 build-elapsed=0.005
```

Interpretation:

- `fold-collisions=0`: no two raw `u128` keys folded to the same compact `u64` key.  Any folded-key
  collision aborts the freeze.
- `fp-bits=48` is a better default for serious exploratory q=25 mining; smaller values are useful
  for quick smoke tests.

### `s4query`

```bash
/tmp/gridcap-s4 s4query <q> <t1,t2,t3,t4> --raw <raw-file>
/tmp/gridcap-s4 s4query <q> <t1,t2,t3,t4> --burr <burr-file>
```

The shell reads commands from stdin:

```text
state
moves
play r,c
pop
replies r,c
bench <iters>
help
quit
```

Example:

```bash
printf 'state\nmoves\nreplies 0,0\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --raw /tmp/s4-q17.raw
```

Output rows:

```text
STATE ply=4 cells=1,1 2,9 3,6 4,13 legal=104 value=P
MOVE r=5 c=8 geom=int value=N
REPLY x=0,0 y=5,8 ygeom=int value=P
```

Geometry labels are relative to the normalized conic `r*c = 1`:

```text
root  one of the original S4 cells
on    on the conic but not already selected
ext   external off-conic point
int   internal off-conic point
anom  unexpected tangent count
```

`value=unknown` means the queried canonical key is not in the dump/archive.  This is expected for
partial capped q=25 dumps.

### `s4mine`

```bash
/tmp/gridcap-s4 s4mine <q> <t1,t2,t3,t4> --raw <raw-file> \
  [--depth <plies>] [--state-rows] [--replies <none|all|p|n|unknown>] \
  [--max-reply-moves <n>] [--max-states <n>]

/tmp/gridcap-s4 s4mine <q> <t1,t2,t3,t4> --burr <burr-file> ...
```

`s4mine` is the non-interactive batch layer.  It emits:

- `ROOTMOVE` rows for every legal root child, with geometry, known value, and reply count;
- `ROOTSUMMARY` aggregate counts by geometry and known value;
- `PLY` rows for deduplicated reachable states through `--depth`, grouped by absolute ply;
- optional `STATE` rows for each deduplicated state with `--state-rows`;
- optional `REPLY` / `REPLYSUM` rows for root moves selected by `--replies`.

Default settings:

```text
--depth 2
--replies none
--max-states 100000
```

Useful examples:

```bash
/tmp/gridcap-s4 s4mine 17 1,2,3,4 --raw /tmp/s4-q17.raw --depth 2
```

```bash
/tmp/gridcap-s4 s4mine 17 1,2,3,4 --raw /tmp/s4-q17.raw \
  --depth 1 --state-rows --replies n --max-reply-moves 1
```

The reply filter is applied to the value of the root child after the opponent's move.  For a
P-valued S4 root, legal first moves should be N-valued children, so `--replies n` is usually the
first root-reply sample to inspect.

## Pattern-Mining Recipes

The current q>=9 mining priorities are summarized in
[`2026-07-08-q-ge-9-pattern-mining-agenda.md`](2026-07-08-q-ge-9-pattern-mining-agenda.md).  In
particular, `s4mine` now gives a first systematic ply-by-ply structure pass over an S4 dump.  It
does not yet compute live-conic counts, defect spectra, or best-repair scores; those remain feature
extensions for the next miner layer.

### Root Child Census

Use this to classify known first intrusions from a partial or complete root dump:

```bash
/tmp/gridcap-s4 s4mine 25 1,2,3,5 --raw /path/q25.raw --depth 0
```

Use the `ROOTMOVE` rows, or just the aggregate `ROOTSUMMARY` row:

```text
geom  known P  known N  unknown
on
ext
int
```

This is the first check for whether q=25 follows the q=17/q=19 intrusion pattern.

### Reply / Guard Mining

For each interesting intrusion `x`, run:

```bash
printf 'replies 0,0\nquit\n' \
  | /tmp/gridcap-s4 s4query 25 1,2,3,5 --raw /path/q25.raw
```

For a batch root-level reply sample, use:

```bash
/tmp/gridcap-s4 s4mine 17 1,2,3,4 --raw /path/q17.raw \
  --depth 1 --replies n --max-reply-moves 1
```

Look for:

- internal `P` replies;
- replies that are legal for multiple worst moves;
- replies that empty the live conic;
- mismatch between raw and compact results.

The current query shell reports `on/ext/int`; live-conic counts are a natural next batch-miner
extension.

### Interactive Walk

Use `play` and `pop` to inspect a line:

```text
state
play 0,0
state
moves
pop
state
quit
```

The shell keeps a stack of positions.  It does not mutate the dump.

### Query Benchmark

Use:

```text
bench 10000
```

This repeats lookup over the current legal children.  The benchmark precomputes child positions
once before timing, so it measures canonicalization plus mapped-store lookup rather than allocator
churn.

## Validation Recipe

Compile:

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-s4
```

Exact q=17 dump:

```bash
/tmp/gridcap-s4 s4dump 17 4,3,2,1 --cap 1000000 --out /tmp/s4-manual-q17.raw
```

Expected core facts:

```text
t4=[1, 2, 3, 4]
status=OK
value=P
records=64728
```

Freeze:

```bash
/tmp/gridcap-s4 s4freeze /tmp/s4-manual-q17.raw /tmp/s4-manual-q17.burr --fp-bits 40 --load 0.90
```

Expected core facts:

```text
records=64728
keys=64728
fold-collisions=0
layers=2
```

Raw and compact query agreement:

```bash
printf 'state\nmoves\nreplies 0,0\nbench 20\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --raw /tmp/s4-manual-q17.raw \
  > /tmp/s4-manual-q17.raw.out

printf 'state\nmoves\nreplies 0,0\nbench 20\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --burr /tmp/s4-manual-q17.burr \
  > /tmp/s4-manual-q17.burr.out

grep -E '^(STATE ply|MOVE r=|REPLY x=)' /tmp/s4-manual-q17.raw.out \
  > /tmp/s4-manual-q17.raw.value-rows
grep -E '^(STATE ply|MOVE r=|REPLY x=)' /tmp/s4-manual-q17.burr.out \
  > /tmp/s4-manual-q17.burr.value-rows
diff -u /tmp/s4-manual-q17.raw.value-rows /tmp/s4-manual-q17.burr.value-rows
```

The diff should be empty.  In the validation run, both files had 164 deterministic value rows.

Raw and compact mining agreement:

```bash
/tmp/gridcap-s4 s4mine 17 1,2,3,4 --raw /tmp/s4-manual-q17.raw \
  --depth 2 --max-states 20000 > /tmp/s4-manual-q17.raw.mine

/tmp/gridcap-s4 s4mine 17 1,2,3,4 --burr /tmp/s4-manual-q17.burr \
  --depth 2 --max-states 20000 > /tmp/s4-manual-q17.burr.mine

grep -E '^(ROOTMOVE|ROOTSUMMARY|PLY|TRUNCATED|S4MINE-DONE)' \
  /tmp/s4-manual-q17.raw.mine > /tmp/s4-manual-q17.raw.mine.rows
grep -E '^(ROOTMOVE|ROOTSUMMARY|PLY|TRUNCATED|S4MINE-DONE)' \
  /tmp/s4-manual-q17.burr.mine > /tmp/s4-manual-q17.burr.mine.rows
diff -u /tmp/s4-manual-q17.raw.mine.rows /tmp/s4-manual-q17.burr.mine.rows
```

The diff should be empty.  In the validation run, the q=17 summary rows included:

```text
ROOTSUMMARY moves=104 known=104 move_on=12 move_ext=56 move_int=36 child_P=0 child_N=104 child_unknown=0
PLY ply=4 states=1 value_P=1 value_N=0 value_unknown=0 legal_avg=104.000 child_N=104 child_unknown=0
PLY ply=5 states=104 value_N=104 legal_min=57 legal_max=65 legal_avg=60.423 child_P=180 child_N=2506 child_unknown=3598
PLY ply=6 states=3109 value_P=90 value_N=1230 value_unknown=1789 legal_min=22 legal_max=37 legal_avg=29.585 child_unknown=66762
```

The unknowns at deeper plies are expected: an `OK` early-break S4 dump proves the root value, but it
is not a full reachable-state database.

Root mismatch guard:

```bash
printf 'state\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,5 --raw /tmp/s4-manual-q17.raw
```

Expected result: exit code `2` and a `dump root mismatch` message.

Corrupt-header guard:

```bash
cp /tmp/s4-manual-q17.raw /tmp/s4-manual-q17-bad.raw
printf X | dd of=/tmp/s4-manual-q17-bad.raw bs=1 count=1 conv=notrunc status=none
printf 'state\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --raw /tmp/s4-manual-q17-bad.raw
```

Expected result: exit code `2` and a `bad raw memo magic` message.

Illegal raw value guard:

```bash
cp /tmp/s4-manual-q17.raw /tmp/s4-manual-q17-badvalue.raw
printf '\002' \
  | dd of=/tmp/s4-manual-q17-badvalue.raw bs=1 seek=144 count=1 conv=notrunc status=none
printf 'state\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --raw /tmp/s4-manual-q17-badvalue.raw
```

Expected result: exit code `2` and a `raw memo value byte 2` message.

Raw key-order guard:

```bash
cp /tmp/s4-manual-q17.raw /tmp/s4-manual-q17-badorder.raw
dd if=/tmp/s4-manual-q17.raw of=/tmp/s4-manual-q17-firstkey.bin \
  bs=1 skip=128 count=16 status=none
dd if=/tmp/s4-manual-q17-firstkey.bin of=/tmp/s4-manual-q17-badorder.raw \
  bs=1 seek=152 count=16 conv=notrunc status=none
printf 'state\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --raw /tmp/s4-manual-q17-badorder.raw
```

Expected result: exit code `2` and a `raw memo keys not strictly sorted` message.

Compact layer-count guard:

```bash
cp /tmp/s4-manual-q17.burr /tmp/s4-manual-q17-badlayers.burr
printf '\101\000\000\000\000\000\000\000' \
  | dd of=/tmp/s4-manual-q17-badlayers.burr bs=1 seek=88 count=8 conv=notrunc status=none
printf 'state\nquit\n' \
  | /tmp/gridcap-s4 s4query 17 1,2,3,4 --burr /tmp/s4-manual-q17-badlayers.burr
```

Expected result: exit code `2` and an `s4 burr layer count 65` message.

## q=25 Partial-Dump Example

The first full-PGL q=25 bucket representative is:

```text
t4=[1,2,3,5]
cells=[1,1;2,3;3,2;5,15]
```

A useful partial exploratory dump:

```bash
/tmp/gridcap-s4 s4dump 25 1,2,3,5 --cap 2000000 --out /tmp/q25-hard-2m.raw
/tmp/gridcap-s4 s4freeze /tmp/q25-hard-2m.raw /tmp/q25-hard-2m.burr --fp-bits 48 --load 0.90
```

Measured on the current solver:

```text
s4dump:
  status=ABORTED
  records=2000001
  solve elapsed about 8.8s
  raw dump elapsed about 0.09s

s4freeze:
  keys=2000001
  fold-collisions=0
  layers=2
  bits/key about 54.45
  file about 13.6 MB
  build elapsed about 0.22s
```

Query throughput from the 2M-entry q=25 partial corpus:

```text
raw mmap query:     about 3.7M probes/s
compact mmap query: about 3.0M probes/s
```

The raw table is faster for this workload; compact archives are mainly a disk-footprint lever.

A small 100K-entry q=25 smoke dump of the hard `[1,2,3,5]` root validates the partial-coverage
semantics:

```bash
/tmp/gridcap-s4 s4dump 25 1,2,3,5 --cap 100000 --out /tmp/s4mine-q25-100k.raw
/tmp/gridcap-s4 s4mine 25 1,2,3,5 --raw /tmp/s4mine-q25-100k.raw --depth 1
```

Core output:

```text
S4DUMP ... status=ABORTED value=- records=100003
ROOTSUMMARY moves=330 known=0 move_on=20 move_ext=172 move_int=138 child_unknown=330
PLY ply=4 states=1 value_unknown=1 legal_avg=330.000 child_unknown=330
PLY ply=5 states=330 value_unknown=330 legal_min=235 legal_max=245 legal_avg=240.539 child_unknown=79378
```

This is still useful geometry/branching data, but it gives no child values at that cap.

## Perf / Tiger-Style Notes

The dump/query tools are cold infrastructure around the existing solver:

- `s4_g` was not given any new query/archive branches.
- archive structs are outside the recursive hot path;
- mmap unsafe blocks are isolated in `MmapFile` and document their invariants;
- query benchmark child positions are precomputed once before timing;
- remaining query cost is mostly `Board::canon`.
- `s4mine` deduplicates BFS states by canonical key and reports unknowns instead of treating missing
  store entries as values.

Sampled profiles:

```text
live q=25 cap=500k:
  Board::canon about 95% of samples

compact q=25 query:
  Board::canon about 72%
  query/archive lookup about 27%
```

The next performance lever for query-heavy mining is not the archive format; it is avoiding repeated
canonicalization for the same legal-child list or adding a batch miner that computes each child key
once and aggregates immediately.

## Storage Policy

`/tmp` is scratch and may be tmpfs.  Use it for smoke tests only.  For durable q=25 mining outputs,
write to an explicit persistent path and do not commit large raw/archive files unless they have been
intentionally curated.  Small summaries can go under `notes/data/`.
