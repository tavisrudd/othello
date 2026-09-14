# C1185 — certificate size and generation cost

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Successor to C1183 (`2026-09-13-c1183-ranked-certificate.md`); reads with
C1184 (`2026-09-13-c1184-direct-checker.md`) and C1186 (`2026-09-13-c1186-presence-bitmap.md`).

## Question

C1183 measured the ranked-relation certificate at five bytes per derived tuple in its packed form
— four bytes of `u16` tuple plus one byte of rank — and read that as "the relation plus 25 % for
the ranks". Two questions were left open. What does producing a certificate cost against
evaluating, in time, allocations and copied bytes? And how far below five bytes per tuple can the
representation go: by bit-packing or delta-coding the ranks, by encoding the derived tuples in
relation order instead of derivation order, by dropping ranks where a round bound certifies them
implicitly, and how far is any of that from the entropy floor of the streams?

## What was built

No core change. Private `ergodis-private` `525fbdf` (the encoders, their tests and the harness
mode), `1722bcb` (one encoder fix and a first full table) and `a3c64f6` (the conditional-entropy
fix and the table this report carries), over core `ergodis` `1d600a5`, whose
`crates/rules/src/demand.rs` and `crates/verify/src/ranked.rs` are unchanged since C1184.

1. **A candidate-encoding library**, `ergodis-private/src/datalog_certificate_codecs.rs`. Every
   candidate is a paired encoder and decoder over a ranked certificate's *payload* — per declared
   relation, the derived tuples and one rank each — so each byte count is exact and each candidate
   is checked by decoding it back. The schema string and the 32-byte source identity are a fixed
   header every candidate shares and none of them writes; each encoding is self-describing given
   the domain and the relation arities, carrying its own per-relation counts and width parameter,
   which the throwaway encoders of C1183 did not.

   - **Row order** (the producer's listing order) with six rank codings: one fixed byte (C1183's
     packed form), `ceil(log2(max rank + 1))` bits, LEB128 rank differences, bit-packed rank
     differences, one (rank difference, run length) varint pair per run, and no rank bytes at all,
     with the rank taken to be the tuple's position in the listing.
   - **Key-sorted** forms, all three of which put the tuples in packed-key order and the ranks in
     that same order, bit-packed: relation-order CSR (first column as run lengths over the domain,
     second column LEB128 gap-coded inside each run), whole-relation LEB128 key gaps, and one bit
     per tuple-universe entry. The last two also have rank-free variants.
   - **Round blocks**: the rank column as one (rank difference, count) varint pair per run of equal
     rank, and each run's tuples sorted and coded either as LEB128 key gaps or, per block,
     whichever of the gap coding and a universe bitmap is smaller behind a tag byte.
   - **Entropy floors**: the zeroth-order entropy of each tuple column, the conditional entropy of
     the second column given the first and the relation, the zeroth-order entropy of the rank
     stream, and `log2 C(universe, tuples)` to leading term — the information in the tuple *set*,
     which is what an order-free encoding must carry.

   The three orders are not interchangeable, and that is the substance of the exploration. The
   demand evaluator appends rows in round order, so **the listed rank column is non-decreasing**,
   and in that order the ranks run-length code to a few dozen bytes for the whole certificate;
   but the tuple stream is then in no useful order and costs a fixed word per value. Sorting by
   key makes the tuple stream cheap and destroys the rank monotonicity, so the ranks must then be
   paid for in full; that is the reordering the task called for, and the ranks are encoded in the
   sorted order, as it required. Round blocks keep the rank runs and sort inside each one, so both
   streams stay cheap. The key-sorted encoders are therefore required to decode to the key-sorted
   permutation of the payload, and the round blocks to the run-sorted permutation, both of which
   the library computes so the round trip is checked against them rather than against a laundered
   expectation.

2. **A generation-profile harness mode**, `--certificates` in
   `ergodis-private/examples/closure_ballpark.rs`. It evaluates, then times both generators over
   the same repeat count, then calls each once more with a counting global allocator armed, and
   reports each generator's median time, its allocator requests, the bytes those requests asked
   for, and the payload it copies. Nothing else runs in that mode — no checker, no JSON, no output
   file — so a `perf record` of that process is a profile of evaluation and generation. `--encoders`
   adds the candidate table: for each candidate, its exact byte count, one encode time, one decode
   time, and the round-trip verdict.

3. **A runner over the size table**, `analysis/datalog-comparison/run-certificates.sh`, one pinned
   core and `choom -n 1000` per row, which is the measurement discipline of the earlier rows of
   this table.

One encoder was fixed after the first full pass: the universe bitmap does not depend on the
listing order, so when it carries no ranks it no longer sorts. That took the tuple-only bitmap from
30 ms to 2 ms per million tuples and made it the cheapest candidate to encode as well as the
smallest, which matters because that candidate is the one the round-bound argument of question 2c
would ship.

## Acceptance

| Gate | Result |
|---|---|
| `cargo fmt --check` under the pinned 1.95.0 toolchain | clean |
| `cargo clippy -p ergodis-private --all-targets -- -D warnings` | clean |
| `cargo test --test datalog_certificate_codecs` | every test passes |
| Round trip on real data: every candidate on every row of the table decodes back to the payload it claims — the input for the row-order forms, the key-sorted permutation for the sorted forms, the run-sorted permutation for the round blocks | true for every candidate on every row (`round_trip` in each record) |
| Hand-computed sizes: each row-order coding, the CSR, gap and bitmap forms, and both round-block codings on a three-tuple payload over domain 4 whose first rank run is not in key order | exact match, with the count derived in a comment beside each |
| A dense block takes the bitmap and a sparse one the gaps, at the crossover computed by hand | pass |
| The codings that can express only a non-decreasing rank column decline a decreasing one, and the order-free codings accept it | pass |
| A tuple value outside the domain is refused by every encoder and by the entropy floor | pass |
| Entropy floor against a hand computation, including a relation that is its whole universe (set information zero) and one that is half of it (`universe * H2(1/2)`) | pass |
| The conditional entropy is taken inside each relation: two relations listing the same four pairs must give `log2 2`, not the `log2 4` that pooled degrees would give, and it must not exceed the second column's own entropy | pass |
| Core untouched, so the core gate does not apply | `git status` clean in `ergodis`; `crates/rules/src/demand.rs` at its C1184 content |

The gate run was the private package's formatting and lint over all its targets — which compiles
another session's in-progress modules in the same package, and passed — plus the new codec test
file. The rest of the private suite was not run: nothing here changes any path it covers, and the
workspace carries that session's uncommitted edits.

## Measurement

Harness built from private `1722bcb` over core `1d600a5`, `rustc 1.95.0 (59807616e 2026-04-14)`
from `nixpkgs`, release profile, no features. One row per process, `choom -n 1000`,
`taskset -c 3`, five warm evaluations and five calls of each generator per process, medians
reported; each candidate encoding is one encode and one decode, not a median. Two independent
passes over the whole table, either side of the bitmap encoder fix, are this table's own control:
every certificate byte count is identical between them, and the evaluation times agree to within
3 % on ten of the eleven rows and 10 % on dense closure 1024 (1 317 against 1 447 ms), which is
this box's ordinary drift on its longest row. The table below is the later pass, the one the
committed results file holds.

### Generation cost

| program | density | N | derived tuples | eval ms | trace gen ms | trace / eval | ranked gen ms | ranked / eval | trace requests | trace requested MB | ranked requests | ranked requested MB |
|---------|---------|------|------------|---------|----------|------|-------|-------|----|-------|---|-------|
| closure | sparse  |  256 |     62 979 |     1.9 |     0.4  | 0.20 |  0.01 | 0.005 | 20 |   2.3 | 4 |   0.8 |
| closure | sparse  | 1024 |    979 983 |    31.1 |     8.4  | 0.27 |  1.80 | 0.058 | 24 |  36.4 | 4 |  11.8 |
| closure | sparse  | 2048 |  3 954 709 |   129.2 |    37.8  | 0.29 |  8.34 | 0.065 | 26 | 146.2 | 4 |  47.5 |
| closure | sparse  | 4096 | 15 679 566 |   520.8 |   169.0  | 0.32 | 35.85 | 0.069 | 28 | 582.0 | 4 | 188.2 |
| closure | dense   |  256 |     65 536 |    22.6 |     0.5  | 0.02 |  0.07 | 0.003 | 20 |   2.4 | 4 |   0.8 |
| closure | dense   |  512 |    262 144 |   172.0 |     2.2  | 0.01 |  0.37 | 0.002 | 22 |   9.4 | 4 |   3.1 |
| closure | dense   | 1024 |  1 048 576 | 1 447.3 |    10.0  | 0.01 |  2.18 | 0.002 | 24 |  37.7 | 4 |  12.6 |
| samegen | sparse  | 1024 |    258 691 |     4.3 |     2.0  | 0.48 |  0.33 | 0.077 | 22 |   9.4 | 6 |   3.1 |
| samegen | sparse  | 4096 |  3 781 581 |    70.3 |    36.4  | 0.52 |  8.60 | 0.122 | 26 | 142.7 | 6 |  45.4 |
| samegen | dense   |  256 |    125 607 |     3.2 |     0.9  | 0.30 |  0.13 | 0.042 | 21 |   4.6 | 6 |   1.5 |
| samegen | dense   | 1024 |  2 065 210 |    54.0 |    19.7  | 0.36 |  4.39 | 0.081 | 25 |  74.9 | 6 |  24.8 |

`perf record` over the whole `--certificates` process, which is evaluation plus both generators and
nothing else. Closure sparse 4096: `Demand::evaluate_into` 53.6 %,
`__memmove_avx512_unaligned_erms` 23.3 %, `Demand::certificate` 15.8 %, `Demand::index_rows` 3.1 %,
nothing else above 1.3 %. Same generation sparse 4096: `evaluate_into` 32.2 %, the copy routine
29.1 %, `Demand::certificate` 24.7 %, `index_rows` 3.6 %, `__memset` 3.0 %. `ranked_certificate`
has no self time in either: it compiles to two bulk copies per grown relation, so all of its cost
is inside the copy routine.

### Certificate size, bytes per derived tuple

Every column is one encoder's exact output divided by the derived tuples it carries. `packed` is
C1183's form. The last three columns are floors, not candidates: `set floor` is
`log2 C(universe, tuples)` to leading term summed over the relations, `tuple H0` is
`H(column 0) + H(column 1 | column 0, relation)` — the conditional term taken inside each relation
and pooled by tuple count, since a pair can appear in two relations — and `rank H0` is the
zeroth-order entropy of the rank stream.

| program | density | N | packed | rank bits | rank delta varint | rank delta bits | rank runs | rank implicit | CSR | sorted gaps | bitmap | blocks gaps | blocks smaller | sorted gaps, no ranks | bitmap, no ranks | set floor | tuple H0 | rank H0 |
|---------|---------|------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|------|-------|
| closure | sparse  |  256 | 5.000 | 4.500 | 5.000 | 4.125 | 4.001 | 4.000 | 1.508 | 1.500 | 0.630 | 1.012 | 0.656 | 1.000 | 0.130 | 0.031 | 1.99 | 0.316 |
| closure | sparse  | 1024 | 5.000 | 4.500 | 5.000 | 4.125 | 4.000 | 4.000 | 1.502 | 1.500 | 0.634 | 1.012 | 0.661 | 1.000 | 0.134 | 0.047 | 2.49 | 0.314 |
| closure | sparse  | 2048 | 5.000 | 4.500 | 5.000 | 4.125 | 4.000 | 4.000 | 1.501 | 1.500 | 0.633 | 1.012 | 0.650 | 1.000 | 0.133 | 0.042 | 2.74 | 0.311 |
| closure | sparse  | 4096 | 5.000 | 4.500 | 5.000 | 4.125 | 4.000 | 4.000 | 1.501 | 1.500 | 0.634 | 1.012 | 0.676 | 1.000 | 0.134 | 0.047 | 2.99 | 0.312 |
| closure | dense   |  256 | 5.000 | 4.250 | 5.000 | 4.125 | 4.000 | 4.000 | 1.258 | 1.250 | 0.375 | 1.000 | 0.250 | 1.000 | 0.125 | 0.000 | 2.00 | 0.101 |
| closure | dense   |  512 | 5.000 | 4.250 | 5.000 | 4.125 | 4.000 | 4.000 | 1.254 | 1.250 | 0.375 | 1.000 | 0.250 | 1.000 | 0.125 | 0.000 | 2.25 | 0.101 |
| closure | dense   | 1024 | 5.000 | 4.250 | 5.000 | 4.125 | 4.000 | 4.000 | 1.252 | 1.250 | 0.375 | 1.000 | 0.250 | 1.000 | 0.125 | 0.000 | 2.50 | 0.101 |
| samegen | sparse  | 1024 | 5.000 | 4.625 | 5.000 | 4.250 | 4.000 | 4.000 | 1.640 | 1.627 | 1.638 | 1.061 | 1.061 | 1.002 | 1.013 | 0.546 | 2.13 | 0.486 |
| samegen | sparse  | 4096 | 5.000 | 4.625 | 5.000 | 4.250 | 4.000 | 4.000 | 1.632 | 1.628 | 1.734 | 1.064 | 1.064 | 1.003 | 1.109 | 0.563 | 2.61 | 0.500 |
| samegen | dense   |  256 | 5.000 | 4.500 | 5.000 | 4.250 | 4.000 | 4.000 | 1.508 | 1.500 | 0.631 | 1.003 | 0.430 | 1.000 | 0.130 | 0.033 | 1.99 | 0.330 |
| samegen | dense   | 1024 | 5.000 | 4.500 | 5.000 | 4.250 | 4.000 | 4.000 | 1.502 | 1.500 | 0.627 | 1.004 | 0.410 | 1.000 | 0.127 | 0.014 | 2.50 | 0.329 |

For reference on the same rows, the output relation alone is 4.000 bytes per tuple as packed `u16`
(C1183's `output_packed_u16`), and the ranked certificate as the JSON the core actually writes was
11.50 bytes per tuple at closure sparse 4096 (C1183's 180.3 MB).

### Encode and decode cost, milliseconds

| program | density | N | eval ms | packed enc / dec | rank runs enc / dec | CSR enc / dec | bitmap enc / dec | blocks smaller enc / dec | bitmap, no ranks enc / dec |
|---------|---------|------|---------|-------------|-------------|---------------|---------------|---------------|-------------|
| closure | sparse  |  256 |     1.9 |   0.1 / 0.1 |   0.1 / 0.1 |     1.3 / 0.1 |     1.0 / 0.2 |     0.6 / 0.3 |   0.1 / 0.2 |
| closure | sparse  | 1024 |    31.1 |   1.9 / 1.7 |   1.9 / 1.3 |    22.1 / 2.2 |    19.0 / 3.9 |    11.1 / 5.3 |   1.7 / 2.8 |
| closure | sparse  | 2048 |   129.2 |  7.5 / 13.9 |   7.6 / 5.5 |   103.0 / 11.1 |   92.8 / 15.7 |    48.8 / 28.8 |  6.9 / 11.1 |
| closure | sparse  | 4096 |   520.8 | 44.2 / 58.5 | 41.6 / 52.4 |   441.6 / 67.3 | 499.1 / 101.1 |   222.8 / 125.0 | 28.2 / 66.5 |
| closure | dense   |  256 |    22.6 |   0.1 / 0.1 |   0.1 / 0.1 |     1.2 / 0.1 |     1.1 / 0.2 |     0.6 / 0.3 |   0.1 / 0.2 |
| closure | dense   |  512 |   172.0 |   0.5 / 0.5 |   0.5 / 0.3 |     5.4 / 0.5 |     4.7 / 0.9 |     2.8 / 1.1 |   0.5 / 0.7 |
| closure | dense   | 1024 | 1 447.3 |   2.0 / 1.7 |   2.1 / 1.4 |    23.4 / 2.1 |    19.7 / 3.5 |    10.5 / 4.2 |   1.9 / 2.7 |
| samegen | sparse  | 1024 |     4.3 |   0.5 / 0.4 |   0.5 / 0.3 |     5.4 / 0.8 |     4.4 / 1.2 |     2.7 / 1.5 |   0.5 / 0.8 |
| samegen | sparse  | 4096 |    70.3 |  7.2 / 11.6 |   7.1 / 5.4 |    85.5 / 11.5 |   93.8 / 17.7 |    44.4 / 22.4 |  8.6 / 12.1 |
| samegen | dense   |  256 |     3.2 |   0.2 / 0.2 |   0.2 / 0.2 |     2.4 / 0.4 |     2.1 / 0.5 |     1.4 / 0.6 |   0.2 / 0.3 |
| samegen | dense   | 1024 |    54.0 |   4.0 / 3.5 |   4.2 / 2.9 |    45.4 / 5.8 |    42.5 / 8.5 |    27.3 / 10.9 |   4.0 / 5.6 |

### Reading

1. **Generation is a copy, and the ranked generator runs at memory bandwidth.** Its allocator
   requests are four per evaluation for closure and six for same generation — exactly two per grown
   relation plus the two of the result — and the bytes it requests equal the payload it copies to
   within 200 bytes on every row, so it does no growth reallocation at all. At the largest row it
   copies 188.2 MB in 35.85 ms, 5.3 GB/s of payload on one core. It costs 0.2 % to 12 % of
   evaluation: 7 % on the largest closure row, 12 % on the tightest same-generation row, and
   essentially nothing on dense closure, where evaluation emits 268 M candidates for 1.05 M tuples.
2. **The trace generator costs five times as much, and the reason is visible in the counters.** It
   is 20–52 % of evaluation, and it requests 1.86× its own payload (582.0 MB for a 313.6 MB payload
   at the largest row) in 20–28 requests. Two mechanisms: it builds a scatter array holding one
   `(relation, row)` pair per derivation so the trace can be emitted in global derivation order,
   which is 125.4 MB of random-access writes at the largest row and is not part of the payload; and
   its tuple list grows by doubling where its rule and premise lists are exactly reserved. Its
   effective rate is 2.6 GB/s against the ranked generator's 5.3. A `reserve` on that one list is a
   free cold-path change, measured here only through the allocator counters; the scatter is inherent
   to the trace form.
3. **Varint coding of the ranks buys nothing; run-length coding buys all of it.** LEB128 rank
   differences come to exactly 5.000 bytes per tuple, the same as one fixed byte, because every
   difference is a separate byte however small it is — the granularity the C1183 ledger suspected,
   now measured. Bit-packing the ranks gives 4.25–4.625 and bit-packing the differences 4.125–4.25.
   Run-length coding the rank column gives **4.000**: the whole rank column of the largest
   certificate is 58 bytes, and of the largest same-generation certificate 107 bytes, against
   15 679 566 and 3 781 581 bytes for one byte per tuple. The evaluator's row order makes this
   exact rather than opportunistic — rows are appended in round order, so the listed rank column
   cannot decrease. That is not assumed: the run-length and round-block encoders refuse a
   decreasing column and would have reported declining instead of a byte count, and they encoded
   every row of the table.
4. **So the rank column is not the certificate's cost, and C1183's "the relation plus 25 %" was an
   artefact of the tuple encoding.** With the ranks run-length coded the certificate is the tuple
   stream and nothing else, and the tuple stream in derivation order is four bytes per tuple of
   `u16` pairs — the same four bytes the consumer's relation costs in that encoding, which is why
   the ratio looked like 1.25. Encode the tuples as a set instead and the relation falls to
   0.125–1.11 bytes per tuple while the certificate has nothing left to amortize the ranks against.
5. **Relation order is a 4× win on the tuple stream, and a universe bitmap is a 30× one where the
   relation is dense.** Sorting by packed key and LEB128 gap-coding gives 1.000 bytes per tuple for
   the tuples alone on every row — one byte is the LEB128 minimum, and these relations are dense
   enough that nearly every gap fits in it. CSR over the first column with gap-coded second columns
   is 0.002–0.013 bytes per tuple *worse* than gap-coding the packed key directly, since it spends
   a varint on every first-column degree including the empty ones and saves only the first column's
   own gaps. One bit per universe entry gives 0.125–0.134 bytes per tuple wherever the relation is
   most of its universe (all closure rows, dense same generation) and 1.01–1.11 where it is not
   (sparse same generation, 12 % dense).
6. **The best rank-carrying candidate is round blocks, and it is 4.7× to 20× smaller than C1183's
   packed form.** It keeps the rank runs, so the ranks cost a few dozen bytes, and sorts inside each
   run, so the tuples are gap-coded or bitmapped per block: 0.250 bytes per tuple on dense closure
   (20× the packed form), 0.410–0.430 on dense same generation (12×), 0.650–0.676 on sparse closure
   (7.4×), 1.061–1.064 on sparse same generation (4.7×). Against the JSON the core actually emits it
   is 17× smaller on the largest row. The one candidate that beats it anywhere is the single
   universe bitmap with bit-packed ranks on sparse closure, by 6 % (0.634 against 0.676), and the
   mechanism for that is exact: sparse closure derives 15.7 M of a 16.8 M universe across fifteen
   rank runs, so one bitmap costs 0.134 bytes per tuple and the per-block bitmaps cost five times
   that, while its ranks bit-pack into four bits, 0.5 bytes per tuple. The same single bitmap is
   1.5–1.6× *worse* than round blocks on sparse same generation, where the relations are 12 % dense and
   the block gaps are cheaper than either. Round blocks are within 1.07× of the best candidate on
   every row; nothing else is.
7. **The best candidate is 1.9× the set floor at best and 14× at worst, and which floor binds says
   where the remaining slack lives.** The rank stream's zeroth-order entropy is 0.10–0.50 bytes per
   tuple and run-length coding beats it by four orders of magnitude, because the floor prices a rank
   per tuple while the listing order makes the ranks a monotone step function — the information is
   the round boundaries, of which there are at most the number of rounds. The tuple stream's
   zeroth-order floor `H(c0) + H(c1 | c0, relation)` is 1.99–2.99 bytes per tuple, which the sorted
   forms beat by the same argument: it prices an ordered stream and the certificate carries a set.
   The relevant floor is
   the set one, `log2 C(universe, tuples)`, at 0.000–0.563 bytes per tuple. Sparse same generation
   lands closest to it: 1.064 against 0.563, a factor 1.9, which is the LEB128 one-byte minimum
   against a 4.5-bit average gap. Sparse closure is a factor 14 off (0.676 against 0.047) and dense
   closure infinitely off (0.250 against 0.000) because its derived relation is *exactly* its whole
   universe, so the set carries no information at all and every byte spent is the encoding's
   framing.
8. **The small encodings cost sorting, and round blocks cost half as much of it as a global sort.**
   At the largest row: packed encodes in 44.2 ms (8 % of evaluation), round blocks in 222.8 ms
   (43 %), the global-sort forms in 442–499 ms (85–96 %). Decode is 52–125 ms. So the 7.4× size win
   is bought with roughly five times the encode time, still under half of evaluation, and the
   tuple-only bitmap is both the smallest and the cheapest of all — 28.2 ms, below the packed form,
   because it needs no sort at all, only a scatter.
9. **No candidate changes what the checker must do, except the rank-free ones.** The checkers index
   by packed key and by row and never depend on the listing order, so a key-sorted or round-blocked
   listing is checkable by the existing `ranked::check` with no change to the search, the closed
   world pass, or any rejection class; its insert pass would in fact become sequential in key order,
   which is a locality gain nobody has measured. I implemented no checker here, so no check cost is
   reported for any candidate.

### The round-bound question (2c), stated exactly

Three devices could drop the rank column, and the measurement settles the question before any
checker is written.

- **Rank implicit in the listing position.** The certificate carries no ranks and the checker
  admits a premise if and only if it appears strictly earlier in the listing. This is sound —
  position order is a well-founded total order that refines the round order — and complete for this
  evaluator, whose rows are appended in derivation order. The checker cost is *unchanged*: the
  comparison `rank(relation, row) < rank` becomes a comparison of the row index it already holds,
  provided the listing is one global sequence. Requirement: per-relation lists make positions
  comparable only within a relation, so a program deriving two relations (same generation derives
  `sg` and `up`) needs either an interleaved listing with a relation tag or the ranks kept.
  **Measured payoff: nothing.** Row order with implicit ranks is 4.000 bytes per tuple and row order
  with run-length ranks is 4.000 as well; the difference is 8 to 107 bytes over the whole
  certificate. Dropping the ranks is not worth a format complication once they are coded as runs.
- **A certificate carrying only the number of rounds**, the `certificate.rounds` device C1176 pinned
  to the `min(N, M + 1)` convergence bound for the grounded path. Here the checker would recompute
  each tuple's round semi-naively from the facts and the listed tuple set and require the fixpoint
  to be reached within the claimed bound and to equal the listed set. The cost this shifts is exact
  and total: the checker becomes the evaluator, so checking costs about one evaluation plus the
  closed-world comparison. C1186 measures the ranked checker at 0.7× evaluation on the three dense
  closure rows and 3.0× to 7.7× on the other eight, so on those eight this shift would *reduce*
  wall time and on the dense ones it would raise it — and either way it abandons what a certificate
  is for, since the verifier then recomputes the answer rather than checking a witness, and no
  asymmetry between producing and checking survives. Its size is the tuple-only row of the table,
  0.125–1.11 bytes per tuple plus one varint.
- **Ranks only where needed.** A tuple derivable from facts alone needs no rank, and iterating that
  observation is stratification by round, which is the previous device. A sound intermediate would
  have to list the round boundaries and nothing else — which is exactly the run-length rank column.
  **For this evaluator the rank column and the round-boundary information are the same object**, and
  coding it as runs already costs a few dozen bytes, so there is no size left to recover by shifting
  work to the checker.

## Decision

**One core format change is warranted, and it is not the one C1183's table pointed at.** The rank
column should be carried as runs, not one integer per tuple. It is exact for this evaluator (rows
are appended in round order, so the listed ranks cannot decrease), it costs `O(rounds)` bytes
instead of `O(tuples)`, it is a strict win in every encoding including the JSON the core writes
today, and it requires nothing of the checker but expanding the runs, which is cheaper than parsing
the integers it replaces. The producer-side obligation is the one sentence that must go in the
format's contract: the listing is in non-decreasing rank order.

**The larger win needs a binary encoding, and the measurement names which one.** Round blocks —
rank runs, and each run's tuples sorted and coded as LEB128 key gaps or as a universe bitmap,
whichever is smaller for that block — are 0.250 to 1.064 bytes per derived tuple against 5.000 for
C1183's packed form (4.7× to 20×) and 11.50 for the JSON the core emits (17× on the largest row).
It is within 1.07× of the best candidate on every row of the table, it needs no global sort, and it
changes nothing about what the checker must verify. That is a measured win by the standard this task
was given, so the format change is justified; implementing it in core is a successor task, not this
one, since it is a new wire encoding plus its decoder plus its share of the core gate.

**What is not worth doing:** varint rank deltas (exactly zero benefit), CSR over the first column
(slightly worse than gap-coding the packed key, and it only works for a binary relation), dropping
ranks for an implicit position order (8–107 bytes on a certificate of megabytes), and moving the
round computation to the checker (it dissolves the certificate).

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis-private/src/datalog_certificate_codecs.rs` | `31078208199f345d0c0f2c450b348879fde12e254b18e76bd1931db161da4785` |
| `ergodis-private/tests/datalog_certificate_codecs.rs` | `57a7088d5b7f9cf320fc63f667449555e70c989fb747ea865e05e20554830bdb` |
| `ergodis-private/examples/closure_ballpark.rs` | `9f47b3945975041a6970102c222d3d25fab90c978e21863a867a024a53705916` |
| `ergodis-private/analysis/datalog-comparison/run-certificates.sh` | `70cd5232a452c107f54decc25c7ce526bb0c1677655f61b25e50d6ef4eede388` |
| `ergodis-private/analysis/datalog-comparison/results-2026-09-13-c1185.jsonl` (21 616 bytes, the whole table above) | `f0d32cc6b06f2b15f8d49338d9135bb48558870b2ce7d8878a3974f881eb9297` |
| `ergodis/crates/rules/src/demand.rs` (the two generators, unchanged since C1183) | `433d055f053a51d84783721ec7359b8c019572e3f05192cd9f5a5c49f1402c3d` |
| `ergodis/crates/verify/src/ranked.rs` (the certificate type and its checker, unchanged since C1184) | `c9213b3738f7831e894452c0fb91e2c76c4386dcccee97e99bdec1ccbbfbc8da` |

Commits: private `ergodis-private` `525fbdf` (the encoders, their tests, the harness mode),
`1722bcb` (the bitmap encoder fix and a first full table), `a3c64f6` (the conditional-entropy fix
and the table above) and `89ab135` (one more negative control in the tests); a concurrent session's
`4429e68` sits between `1722bcb` and `a3c64f6` and touches none of these files. Core `ergodis`
`1d600a5`, unmodified by this task. Toolchain `rustc 1.95.0 (59807616e 2026-04-14)` from `nixpkgs`, matching
`rust-toolchain.toml`; release profile, no features.

Build the harness from those commits:

```
cd ~/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc --command cargo build --example closure_ballpark --profile release
```

Replay the whole table, which writes the JSON lines of `results-2026-09-13-c1185.jsonl`:

```
./analysis/datalog-comparison/run-certificates.sh \
  ~/.cache/ergodis/target/ergodis-private/release/examples/closure_ballpark <workdir> 5 --encoders
```

Replay one row, and the `perf record` target:

```
choom -n 1000 -- taskset -c 3 <harness> --evaluator demand \
  --program <closure|samegen> --certificates [--encoders] <N> <sparse|dense> 5 <workdir>
perf record -F 997 -o <workdir>/row.perf.data -- taskset -c 3 <harness> --evaluator demand \
  --program closure --certificates 4096 sparse 5 <workdir>
```

Inputs are the C1182 deterministic generators (xorshift64 seeded by the domain: closure
`0x9E3779B97F4A7C15 ^ N`, same generation `0x2545F4914F6CDD1D ^ N`), no other randomness. The
independent replay of every byte count is its decoder: each encoding is decoded back and required
to equal the payload it claims, on every row, and the same encoders are put to hand-computed sizes
and generated round trips in `tests/datalog_certificate_codecs.rs`. The generation times are the
harness's own `Instant` medians and the allocator counts come from a counting global allocator armed
only around one call of each generator; the `perf` shares are a sampled cross-check of the same
process, not the source of any number in the tables.

## Mystery ledger (`ej` + `tt` closeout)

- **The evaluator spends a fifth of its time in `memmove`, and that is not this task's subject.**
  On closure dense 1024 the `--certificates` process is 77.0 % `Demand::evaluate_into` and 21.3 %
  `__memmove_avx512_unaligned_erms`, with certificate generation at 0.7 % of the run — so the copy
  routine is called from the derivation loop, which a DWARF-unwound profile confirms (21.0 % of the
  process is the copy routine under `evaluate_into`). The mechanism is in the source:
  `Demand::read` and `Demand::emit` copy a tuple with `copy_from_slice` over a *runtime* length,
  which lowers to a library call, and `read` is called once per join candidate — 268 M times on
  that row. A fixed-width copy, an arity-monomorphized `read`, or a bounded element loop would
  remove the call. Unmeasured, and it is a lever on evaluation, not on certificates; it wants its
  own task with an interleaved A/B. This is the one genuinely incidental finding of the task and it
  is worth more than anything in the decision above.
- **Dense closure's derived relation is its entire tuple universe, so its set floor is zero bytes.**
  Settled as arithmetic, open as an encoding opportunity: at N = 1024 the closure of a graph with
  256 out-edges per node is all 1 048 576 pairs, so a form that records "complete" or the complement
  would cost a handful of bytes where round blocks cost 262 156. A per-block complement or run
  container (what Roaring would call one) is the generic version of that and is not over-fitting to
  this generator; it was not implemented, and the three dense-closure rows are the only ones where
  it would matter by more than a few per cent.
- **Round blocks pay for the universe bitmap once per block, which is why one global bitmap beats
  them on sparse closure.** Settled as to mechanism and quantified (fifteen blocks against one, 0.5
  bytes per tuple of bit-packed ranks against a few dozen bytes of runs, net 6 %). What is open is
  the obvious hybrid: one bitmap for the union plus per-block bitmaps only where a block is dense,
  or a bitmap of the union with the ranks bit-packed in key order but entropy-coded rather than
  fixed-width, whose floor is the 0.31 bytes per tuple in the table against the 0.5 the four-bit
  field spends. Neither was implemented; the gain available is bounded by 0.676 → about 0.36 bytes
  per tuple on sparse closure and nothing elsewhere.
- **I expected varint rank deltas to help and they were exactly neutral.** Settled: 5.000 bytes per
  tuple against 5.000 for a fixed byte, because a LEB128 field cannot be shorter than one byte and
  the differences are almost all zero. The lesson generalizes to any stream whose symbols are
  smaller than a byte: the win is in run-length or bit-level coding, never in varints. The C1183
  ledger had guessed the granularity but not measured it.
- **The trace generator's 1.86× allocation overshoot is a free fix I did not take.** Settled as to
  cause (a growing tuple list and a 125 MB scatter array), deliberately not fixed: it is a core
  change, the trace certificate is not the form worth shipping, and another session is curating the
  core's evidence tree, so running the core gate's `generate_evidence.py --write` would have
  collided with it. Owner: whoever next touches `Demand::certificate`.
- **My first conditional-entropy figure was not a conditional entropy.** Settled: pooling the
  first-column degrees across the relations reported `H(c1 | c0)` above `H(c1)` on the
  same-generation rows (2.12 against 1.99 bytes per tuple at N = 256), which is impossible. The
  formula uses the second column's values being distinct under a fixed first column, which holds
  inside a relation and not across two that can list the same pair; taking the contribution per
  relation and pooling by tuple count fixes it, conditions on the relation as well, and is the
  right floor for a certificate that lists the relations separately. Nothing else in the table
  moved, and the lesson is the check that caught it: a conditional entropy that exceeds its
  unconditional one is arithmetic, not a surprising result.
- **No claim here depends on the box's timing behaviour.** Byte counts are exact and reproduce
  bit-for-bit across the two passes; only the time columns are measurements, and the two passes
  agree on evaluation time to within 3 % on ten rows of eleven and 10 % on the longest. Nothing
  needs a retained-control A/B because nothing is compared across builds.

The evaluator's `memmove` share is the one incidental finding of this task — I was profiling
certificate generation and it is a lever on evaluation. The `ergodis` lane has no discovery-track
companion to append it to, and this task's scope was this file, so it is recorded in the ledger
above and raised for allocation rather than logged.
