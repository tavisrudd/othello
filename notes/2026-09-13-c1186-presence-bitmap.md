# C1186 — a presence bitmap beside the checker membership array

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Successor to C1184 (`2026-09-13-c1184-direct-checker.md`).

## Question

C1184 replaced the certificate checkers' hash maps with a direct-addressed array per relation
mapping a packed tuple key to its row, and named one lever it did not pull: that array holds four
bytes per universe entry where the demand evaluator's membership bitmap holds one bit, so a
membership probe stream touches 64 MB per binary relation over a 4096-element domain instead of
2 MB. The closed-world pass is the checkers' largest single cost and every one of its probes is
membership-only — it never wants the row. Does giving the store a presence bitmap for those probes
close part of the check/eval gap C1184 left open, in particular the 6.7× and 9.4× on sparse same
generation? And, separately, C1184 could not say what the checkers' own memory cost is, because
the harness reported a whole-process high-water mark set by its certificate encoders. What is it?

## What was built

Core `ergodis` `564ad08` and `7476962`; private `ergodis-private` `2e34534` (harness) and
`dafe625` (measurements).

1. **A presence bitmap in the direct representation** (`564ad08`). `Keys::Direct` became
   `{ cells: Vec<u32>, present: Vec<u64> }`, the bitmap holding one bit per universe entry —
   `ceil(universe / 64)` words, so 2 MiB beside a 64 MiB row array for a binary relation over a
   4096-element domain. `insert` sets both. `RelationStore::contains(relation, key)` reads only
   the bitmap. The sorted fallback has no bitmap and answers `contains` from its slot search: the
   binary search that finds the slot has already touched the only cache line a bitmap could have
   saved, so a second structure there would cost memory for nothing.

2. **The closed-world pass reads the bitmap.** Both head checks in `derivation::closed_world` —
   the unary branch and the binary branch — moved from `row_of(..).is_none()` to `!contains(..)`.
   Those are the only membership-only probes in either checker; a bounded search for
   `row_of(..).is_some()` found nothing else. Everything the ranked checker probes goes through
   `JoinIndexes::probe`, whose fully bound case must return the row — the caller either slices the
   premise tuple out of the row store or reads the rank column at that row — so those probes still
   touch the row array, and the ranked checker is therefore the one that benefits less.

3. **The insert decision moved to the presence bit** (`7476962`, a separate commit so it could be
   reverted). Testing `cells[key]` first put a cold load from the 64 MB row array on the dependency
   chain of the branch that decides whether the insert is a duplicate, and the write behind that
   branch could not issue until the load resolved. Testing the presence bit resolves the branch
   from the 2 MB array and lets the row-cell store proceed independently. I predicted this would be
   flat — a fresh insert writes the row cell either way, so the only load saved is on a duplicate,
   and duplicates are rejections — and measured it anyway, as instructed. The prediction was wrong:
   five rotated rounds gave the trace checker 0.86× on closure sparse 4096 and 0.77× on same
   generation sparse 4096, and the ranked checker 0.91× on both. Kept.

4. **Checker-only peak resident memory in the harness** (`ergodis-private` `2e34534`). `VmHWM` is
   a whole-process high-water mark, so what C1184 reported was the certificate encoders' peak.
   Writing `5` to `/proc/self/clear_refs` (`CLEAR_REFS_MM_HIWATER_RSS`) resets that mark to the
   current resident set; the harness now resets immediately before each checker call, reads
   `VmHWM` immediately after, and reports the difference over the `VmRSS` read at the reset as
   `verify_peak_rss_kb` and `ranked_verify_peak_rss_kb`. The mechanism was checked before any
   harness code was written, against a deliberate 512 MiB touched allocation: after the reset
   `VmHWM` equals `VmRSS`, and the mark then moved by 512.004 MB. Because a single final `VmHWM`
   read would now be the peak since the last reset rather than the run's, the run's own peak is
   kept as the largest reading across the segments, so `peak_rss_kb` still means what it meant.

   **One deliberate deviation.** The task asked for the encodings to be dropped from memory before
   the checks. `representation_sizes`, which is what actually sets the process peak, already runs
   after both checks, so the only thing alive across them is the serialized certificate (90 MB and
   46 MB at the largest row). Freeing that early would change what is resident while the checker
   runs, and that is the one thing an A/B against the retained C1184 control has to hold fixed; the
   reset baseline already counts it, so the checker's own peak does not need it gone. I built it
   both ways and kept the non-dropping one. The consequence is that no reported number moved:
   `peak_rss_kb` is 236 MB on closure sparse 1024 against C1184's 231 MB for the same row, which is
   run-to-run noise, and with the early drops it had fallen to 221 MB.

Certificate formats, schema strings, public types, both `Rejection` enums, `Error` conversions and
the public `check`/`check_bounded` signatures are unchanged.

## Acceptance

| Gate | Result |
|---|---|
| `cargo fmt --check` under the pinned 1.95.0 toolchain | clean, after each commit |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean, after each commit |
| `cargo test --all-features --no-fail-fast`, run twice after each commit | exit 0 every time, 78 test-binary and doc-test groups pass, no failures |
| `python3 python/generate_evidence.py --write` in the same commit as each source change | `SHA256SUMS` regenerated, `tests/evidence_manifest.rs` passes |
| `hooks/pre-commit`, newly active on `main` | ran on both core commits and printed `public-lint: clean`; off `public` it materializes the staged paths as empty files and applies only the generated-artifact rule, so it refused nothing here |
| Existing agreement tests: both checkers against the evaluator on the fixtures, the C1179 closure family N ≤ 24, the arity-3 and arity-4 programs, and 256 generated programs per run | pass, unchanged |
| Existing negative controls: both mutation-class tests, every case put to the sorted fallback as well through `check_bounded(.., 0)` and required to return the identical `Result` | pass, unchanged |
| New: `the_presence_bitmap_and_the_row_array_agree` — every key of the universe, in both representations, before and after inserts, for (domain 20, arity 2) = 400 keys = seven bitmap words and (domain 6, arity 3) = 216 keys = four words; one insert sets exactly one bit | pass |
| New: `csr_buckets_match_a_brute_force_scan` now also compares `contains` against the brute-force set at every fully bound key, in both representations | pass |
| Zero allocations in the derivation loop (`crates/rules/tests/allocation.rs`) | pass, unchanged |
| `/proc/self/clear_refs` mechanism verified against a deliberate 512 MB allocation | delta 512.004 MB |

## Measurement

Interleaved A/B against the retained C1184 harness `c1184b-9f177c1`: five rotated rounds per row,
one pinned core (`taskset -c 3`), `choom -n 1000`, three warm evaluations per process. Each round
runs both binaries adjacently, so the statistic is the **paired per-round ratio**, whose median
cancels the drift that spoiled a three-round attempt on this box; the t-score is of the paired log
ratios. The two binaries share the evaluator, so the paired evaluation ratio is the measurement's
own control: it came out between 1.004 and 1.061 with every t-score below 2, and the two rows at
the top of that range (closure dense 1024 at 1.052, same generation sparse 1024 at 1.061) are the
rows to read most cautiously. Only the candidate reports the checker-only peak-RSS columns; the
control predates them.

| program | density | N | derived tuples | eval ms | trace ms C1184 → C1186 | ranked ms C1184 → C1186 | trace speedup (t) | ranked speedup (t) | trace/eval | ranked/eval | trace check MB | ranked check MB |
|---------|---------|------|------------|-------|-----------------|------------------|---------------|---------------|------|------|-----|-----|
| closure | sparse  |  256 |     62 979 |     2 |     2 → 2       |     6 → 6        | 1.00× (−0.4)  | 1.02× (+0.5)  | 1.1  | 3.0  |   0 |   1 |
| closure | sparse  | 1024 |    979 983 |    33 |    47 → 44      |   172 → 154      | 1.06× (−0.3)  | 1.08× (+0.1)  | 1.4  | 4.7  |  15 |  19 |
| closure | sparse  | 2048 |  3 954 709 |   141 |   319 → 234     |   725 → 805      | 1.38× (+3.5)  | 1.04× (−0.0)  | 1.7  | 5.7  |  60 |  76 |
| closure | sparse  | 4096 | 15 679 566 |   574 | 1 561 → 970     | 3 483 → 2 739    | 1.59× (+9.2)  | 1.16× (+6.9)  | 1.7  | 4.8  | 346 | 344 |
| closure | dense   |  256 |     65 536 |    23 |    18 → 18      |    23 → 22       | 0.94× (−1.6)  | 1.00× (+0.8)  | 0.8  | 1.0  |   1 |   3 |
| closure | dense   |  512 |    262 144 |   182 |   133 → 132     |   149 → 151      | 1.01× (−0.6)  | 0.99× (+0.9)  | 0.7  | 0.8  |   5 |  11 |
| closure | dense   | 1024 |  1 048 576 | 1 501 | 1 026 → 1 114   | 1 135 → 1 096    | 0.92× (−1.4)  | 1.00× (+0.3)  | 0.7  | 0.7  |  18 |  43 |
| samegen | sparse  | 1024 |    258 691 |     5 |    30 → 17      |    47 → 34       | 1.65× (+5.8)  | 1.17× (+3.2)  | 3.6  | 7.3  |  15 |  17 |
| samegen | sparse  | 4096 |  3 781 581 |    75 |   529 → 322     |   741 → 581      | 1.73× (+16.3) | 1.31× (+6.3)  | 4.3  | 7.7  | 191 | 199 |
| samegen | dense   |  256 |    125 607 |     3 |     4 → 4       |    13 → 13       | 0.97× (−2.2)  | 1.01× (+0.6)  | 1.2  | 3.8  |   1 |   2 |
| samegen | dense   | 1024 |  2 065 210 |    58 |   130 → 100     |   311 → 268      | 1.28× (+3.8)  | 1.15× (+2.6)  | 1.7  | 4.6  |  36 |  40 |

Both checkers verified every row and agreed with the evaluator's output relation on every record.

### Reading

1. **The bitmap pays where the closed-world pass is membership-bound, and only there.** The trace
   checker gains 1.28× to 1.73× on the five rows whose relations are large and sparse — sparse
   closure at N ≥ 2048, all three larger same-generation rows — with t-scores from +3.5 to +16.3.
   Sparse same generation at N = 4096, the row C1184 identified as the worst, improves most:
   529 ms to 322 ms, taking its check/eval ratio from 6.7–6.9× to 4.3×.
2. **Dense closure gains nothing, and may lose a little.** Its relations are nearly full, so the
   row array is hot anyway and there is no locality to win; the bitmap is then one more array to
   write on every insert. Measured 0.92×–1.01× with |t| ≤ 1.6, which is not a significant loss, but
   it is the right sign for the mechanism and worth stating rather than rounding to "no change".
   The two small dense rows behave the same way.
3. **The ranked checker gains less, for a stated reason.** Its probes go through
   `JoinIndexes::probe`, whose fully bound case has to return the row so the caller can slice the
   premise tuple or read the rank column, so they still touch the row array; only the shared
   closed-world pass at the end reads the bitmap. It gains 1.15× to 1.31× on the large sparse rows
   and nothing elsewhere.
4. **The checkers' own memory cost is small, and the C1184 open item is closed.** On the largest
   row the trace checker peaks at 346 MB and the ranked checker at 344 MB, against a process peak
   of 3 650 MB; on sparse same generation at N = 4096 it is 191 MB and 199 MB against 846 MB. So
   the certificate encoders, not the checkers, own the process peak — which is what C1184
   suspected but could not measure. The checker figures are close to the sum of their parts: for
   closure sparse 4096, two 64 MB row arrays, two 2 MB bitmaps, 125 MB of rows and 63 MB of ranks.
5. **Where the remaining time is.** `perf record` on same generation sparse 4096, restricted to
   `ergodis_verify` symbols, which are 34.4% of the process's cycles — the rest is the harness
   serializing certificates, and renormalizing to the checker share is the correction C1184 learned
   to apply: `closed_world` 22.8%, `JoinIndexes::probe` 22.4%, `ranked::check_bounded` 19.6%,
   `RelationStore::insert` 14.2%, `JoinIndexes::build` 6.2%, `derivation::check_bounded` 5.6%,
   `head_tuple` 3.2%, and the remainder below 2.5% each. Nearly half the checker's time is now the
   join enumeration itself — walking index buckets and unifying — rather than membership.

## Decision

Keep both commits. The presence bitmap costs one bit per universe entry and one write per insert,
and buys 1.3× to 1.7× on the trace checker and 1.15× to 1.3× on the ranked checker wherever the
relations are large and sparse; the small adverse effect on dense relations is within noise and
does not justify making the bitmap conditional on density. The insert-path change is kept on
measurement, against my own prediction.

The remaining check/eval gap is no longer a membership-representation problem. Half the checker
time is bucket enumeration and unification, so the next lever is the enumeration itself — for
instance ordering the closed-world scan so that a rule's first atom is the one with the smaller
relation, which the pass does not currently choose. Unmeasured, and not attempted here.

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis/crates/verify/src/datalog_store.rs` | `9d2c472a5837f4e52897c53baba7cfba261968434fb0d48fb1d90462420fe409` |
| `ergodis/crates/verify/src/derivation.rs` | `c6d4f0e3275d6859202988870c9192fd00bf817a10d65bac47f7e7d0580c4c20` |
| `ergodis-private/examples/closure_ballpark.rs` | `99f2020908e189eaa0ef7ddfd26a41eea2d7b6bc92312d0110dcbc527e9b9a30` |
| `ergodis-private/analysis/datalog-comparison/ab-2026-09-13-c1186.tsv` (108 698 bytes, the A/B above) | `5c9bdc68e8eb67841accf08ff38a410b5f004ecaaf2d201bdb7c306004d57c80` |
| `ergodis-private/analysis/datalog-comparison/results-2026-09-13-c1186.jsonl` (11 162 bytes, single-run full table with certificate sizes and the peak-RSS fields) | `170a8be9a98f70c50716036f64bea9056bb245b76204147eb212c8d7010b0c69` |
| candidate harness: `closure_ballpark` from private `2e34534` over core `7476962` | built from those commits; the binary itself is not cited |
| insert-path control: `closure_ballpark` from private `30c8263` over core `564ad08` (bitmap only) | built from those commits; the binary itself is not cited |
| C1184 control: `closure_ballpark` from private `9f177c1` over core `e6abc24` | built from those commits; the binary itself is not cited |

Commits: core `ergodis` `564ad08` (the presence bitmap) and `7476962` (the insert decision);
private `ergodis-private` `2e34534` (checker-only peak RSS in the harness) and `dafe625` (the
measurements). Toolchain `rustc 1.95.0 (59807616e 2026-04-14)` from `nixpkgs`, matching
`rust-toolchain.toml`; release profile, no features.

Build the harness:

```
cd ~/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc -c ../ergodis-contrib/scripts/retain-bin.sh \
  . closure_ballpark --example --profile release --label c1186c
```

Replay one row:

```
taskset -c 3 <harness built above> --evaluator demand \
  --program <closure|samegen> <N> <sparse|dense> 5 <dir>
```

The JSON line carries `eval_median_ns`, `verify_ns`, `ranked_verify_ns`, `verify_peak_rss_kb`,
`ranked_verify_peak_rss_kb`, `peak_rss_kb` and `representation.*`. The A/B interleaves that command
between the two retained harnesses, five rotated rounds per row with three repeats, which is
`ab-2026-09-13-c1186.tsv`; each of its lines is `A|B`, the round number, then the JSON line, and
the paired statistic is the per-round ratio. Inputs are the C1182 deterministic generators
(xorshift64 seeded by the domain: closure `0x9E3779B97F4A7C15 ^ N`, same generation
`0x2545F4914F6CDD1D ^ N`), no other randomness. The independent replay of each certificate is the
other checker plus exact tuple-set comparison with the evaluator's rows, which the harness asserts
on every row; and every agreement and mutation case in the test suite is additionally put to the
sorted fallback, which has no bitmap, so the two representations cross-check each other.

## Mystery ledger (`ej` + `tt` closeout)

- **I predicted the insert-path change would be flat and it was a 1.17–1.31× win.** Settled, with
  a mechanism: the saving is not a load but a dependency. Testing the row cell puts a cold load
  from the 64 MB array on the dependency chain of the branch that decides duplicate or not, and
  the write behind that branch cannot issue until it resolves; testing the presence bit resolves
  the branch from a 2 MB array. Nothing open, but it is a standing warning that "the cache line is
  touched either way" is not the same argument as "the latency is on the critical path either way".
- **The checkers' memory cost was never the process peak.** Settled and measured: 346 MB against a
  3 650 MB process peak on the largest row. The C1184 ledger's open item is closed. What remains
  open is nothing about the checkers — it is that the harness's `peak_rss_kb` measures its own
  encoders, which is fine as long as nobody reads it as a checker figure.
- **Dense closure is very slightly slower with the bitmap.** Not settled, and deliberately not
  chased: 0.92×–1.01× with |t| ≤ 1.6 is inside the noise on this box, and the sign is what the
  mechanism predicts (a nearly full relation has no locality to win and pays one more write per
  insert). The exact gap would need a quieter box or many more rounds; the decision does not turn
  on it, since making the representation conditional on density would cost more in complexity than
  the largest plausible loss.
- **The ranked checker's fully bound probes still touch the row array.** Settled as to why — the
  caller needs the row for the premise tuple or the rank — and it bounds what the bitmap could ever
  buy that checker. A ranked checker that wanted the same win would have to answer the rank from a
  key-indexed structure instead of a row-indexed one, which trades the 2 MB bitmap back for a
  universe-sized rank array. Not attempted, and not obviously worth it.
- **The box drifts within a single A/B.** A three-round run gave a paired evaluation control off
  by up to 40% on one row and produced an uninterpretable table; five rounds with the paired
  per-round statistic brought the control to within 6% on every row. Settled procedurally: on this
  host, report the paired per-round ratio, never the ratio of medians, and print the evaluation
  control beside every result.
- **Retained harness binaries are not evidence.** The bundle originally listed the `~/.cache`
  binaries with hashes; corrected at close to cite only the core and private commits each was
  built from, and `cache-gc.sh --apply` was then run. Replay rebuilds from those commits.

No discovery-track entry: nothing incidental beyond the task's own question.
