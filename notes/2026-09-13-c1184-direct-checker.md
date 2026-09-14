# C1184 — direct-addressed Datalog certificate checker

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Successor to C1183 (`2026-09-13-c1183-ranked-certificate.md`).

## Question

Both certificate checkers of C1183 — the derivation-trace checker and the ranked-relation
searching checker — ran 15–35× the evaluation time, and the C1183 reading attributed that to the
checkers' hash maps rather than to either certificate form: "the evaluator's direct-addressed
bitmap does the same membership work in a fraction of the time." Does rebuilding the checkers on
the evaluator's representations — universe-sized membership arrays, rank arrays and CSR join
indexes, built independently of the producer — bring check time to the same order as evaluation?

## What was built

Core `ergodis` `db96bcc` and `e6abc24` (two commits from `69ffd81`); private `ergodis-private`
`9f177c1` and `30c8263` (measurements only, no harness change).

1. **A shared store module**, `crates/verify/src/datalog_store.rs`, used by both checkers and by
   the closed-world pass they share. It holds no producer state: its only inputs are the admitted
   source and the certificate.
   - **Membership and rows.** One array per relation over its tuple universe
     (`AdmittedRelation::universe = domain^arity`), mapping a packed tuple key (`Admitted::pack`,
     unchanged) to the row that holds it. Membership and row lookup are one array load; the row
     then indexes contiguous tuple storage. Absent is zero and a stored row is `row + 1`, rather
     than the `u32::MAX` sentinel the task sketched, because `vec![0u32; n]` goes through
     `alloc_zeroed` and its pages are committed only where tuples land, while a sentinel fill
     writes the whole array. At the measured sizes that array is 64 MiB per binary relation over
     a 4096-element domain, so the difference is real time and real resident memory. `demand.rs`
     relies on the same property for its row stores.
   - **Ranks.** A `Vec<u32>` per relation parallel to the rows; facts are rank zero. A premise's
     rank is read from the row a probe already returned, so no tuple is packed twice.
   - **Join indexes.** CSR by (relation, column mask), built by counting sort into a `Vec<u32>`
     of `domain^popcount(mask) + 1` offsets and a `Vec<u32>` of rows; a probe is a slice. The
     counting sort uses one offset array — bucket sizes, exclusive prefix sum, scatter, then a
     single `copy_within` shift — rather than a second cursor array. Index slots are addressed
     directly by `relation * 2^MAX_ARITY + mask`, so there is no map of indexes either.
   - **Memory guard and fallback.** `DIRECT_LIMIT = 2^26` entries, which is 256 MiB for one
     membership array or one CSR offset array. A relation whose universe, or an index whose key
     space, exceeds it falls back to a **sorted key array searched with `partition_point`** —
     never a hash map. Both representations answer identically. Every size in the measurement
     table takes the direct path: domain at most 4096 with arity 2 is a universe of 2^24 and a
     largest index key space of 2^12.
   - The threshold is injectable through `derivation::check_bounded` and `ranked::check_bounded`,
     which take the budget as an argument; `check` is `check_bounded(.., DIRECT_LIMIT)` with its
     signature and behaviour unchanged. A public function rather than a `pub(crate)` parameter or
     a `cfg(test)` hook because the agreement and mutation tests that must exercise the fallback
     live in `crates/rules/tests/demand.rs`, an integration test of a different crate, which
     neither of those reaches.

2. **The derivation checker** (`derivation::check`) inserts into that store instead of a
   `Vec<HashSet<u64>>`, and resolves a fact premise through a `(relation, row)` pair instead of
   the per-fact heap `Vec<u32>` it used to keep. Every rejection class and variant is unchanged.
   The sorted fallback needs the keys a relation can hold before the first insert, which a
   tolerant pre-pass over `(rules[i], tuples[cursor..])` collects; it stops at the first anomalous
   position without reporting it, and the main loop then rejects at that same position, so nothing
   is inserted at or beyond it and no key is missed.

3. **The ranked checker** (`ranked::check`) uses the same store for membership, rows and ranks and
   the same CSR indexes for probes. Rank lookups are by row throughout — the cheap cut the C1183
   mystery ledger identified after a fully bound probe, taken generally rather than in that one
   place.

4. **The closed-world pass** (`derivation::closed_world`, still shared) takes the store and the
   index set instead of a `&dyn Fn` membership closure and a per-rule `HashMap` index. Two
   consequences beyond removing the hashing: it reuses indexes the ranked search already built,
   and a second atom whose columns are all bound is answered from the membership array instead of
   an index over the whole relation. The C1183 report recorded that a full-column index over
   15.7 M rows was the single largest cost in the ranked checker; the closed-world pass was still
   paying it.

5. **The head tuple is never materialized** in the closed-world pass or the ranked search
   (`e6abc24`, the one fix the profile below prompted). `head_matches` and `head_key` read the
   rule's head slots and the current bindings directly, so there is no reused `Vec` write and no
   slice comparison — the latter went out to `memcmp` for two or three `u32` values.

Certificate formats, schema strings, public types, both `Rejection` enums and the `Error`
conversions are unchanged. `implementation_identity()` now also hashes the new module's source.
The measurement harness `examples/closure_ballpark.rs` is byte-identical to C1183's.

## Acceptance

| Gate | Result |
|---|---|
| `cargo fmt --check` under the pinned 1.95.0 toolchain | clean |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo test --all-features`, run twice after each of the two commits (the random-program tests seed differently per run) | exit 0 every time, every test binary and doc-test group passes |
| `python3 python/generate_evidence.py --write` in the same commit as each source change | `SHA256SUMS` regenerated, `tests/evidence_manifest.rs` passes |
| Existing `crates/rules/tests/demand.rs`: both checkers agree with the evaluator on the fixtures, the C1179 family N ≤ 24 and 256 generated programs per run | pass, unchanged |
| `derivation_certificate_rejects_every_mutation_class` and `ranked_certificate_rejects_every_mutation_class`: schema, identity and relation-count binding, dangling value, zero rank, out-of-domain value, tuple on an input relation, duplicate, every rank lowered below its justification, an underivable extra tuple, a dropped tuple; uniform rank shift accepted | each as expected |
| New: every agreement case and every mutation is put to the sorted fallback as well, through `check_bounded(.., 0)`, and the two representations must return the identical `Result` | pass |
| New: CSR builder against a brute-force scan on every bucket of every column mask, arity 2 and 3, including empty buckets and the last key, in both representations; the fully bound mask answered from the membership array; the sorted store's undeclared-key splice | pass (`datalog_store::tests`) |
| New: arity 3 with constants in body atoms, against the grounded oracle; arity 4 with constants, against the evaluator's rows | pass |
| Zero allocations in the derivation loop (`crates/rules/tests/allocation.rs`) | pass, unchanged |
| Whole gate re-run at `a8e52fd`, after a concurrent session landed two commits on top (untracking Python bytecode caches, rewriting two comments in `crates/rules/tests/demand.rs` that named task identifiers) | clean |

The existing random program generator draws relation arities one and two only
(`vec((1u8..=2, any::<bool>()), relation_count)`), so it does **not** cover arity 3 or 4; it does
cover constants in body atoms. Hence the two added arity tests. Arity 4 cannot be cross-checked
against the grounded evaluator at all — `rule_contract::ground` refuses `arity > 3` and more than
three variables per rule — so that test asserts `Prepared::new` returns `Error::Source` and then
uses the demand evaluator's own rows as the oracle for both checkers in both representations.

## Measurement

The C1183 table was taken on a healthier box: three back-to-back replays of it here drifted
monotonically worse (closure sparse 4096 evaluation 518, 662, 892 ms across passes) with 22 GB of
27 GB in use and swap full, and same-generation evaluation came out at 1.7× the C1183 figure with
byte-identical evaluator code. Comparing today's numbers against the C1183 table would therefore
have measured the box. The table below is instead an **interleaved A/B against the retained C1183
harness** `nix2-7cc7175`, which is what `PERFORMANCE.md` requires in any case: three rotated
rounds per row, one pinned core (`taskset -c 3`), `choom -n 1000`, three warm evaluations per
process, medians reported. Each binary reports its own evaluation time in the same round, and the
two agree to within 1% on every row — the evaluator is unchanged, so that agreement is the
measurement's own control.

| program | density | N | derived tuples | eval ms | trace check ms C1183 → C1184 | ranked check ms C1183 → C1184 | trace/eval C1183 → C1184 | ranked/eval C1183 → C1184 |
|---------|---------|------|------------|---------|------------------------------|-------------------------------|--------------------------|---------------------------|
| closure | sparse  |  256 |     62 979 |       2 |          7 → 2               |            23 → 6             |      3.7 → 1.1           |        11.7 → 3.0         |
| closure | sparse  | 1024 |    979 983 |      32 |        239 → 42              |           718 → 145           |      7.7 → 1.3           |        23.2 → 4.6         |
| closure | sparse  | 2048 |  3 954 709 |     134 |      1 641 → 299             |         4 036 → 718           |     12.7 → 2.2           |        31.3 → 5.4         |
| closure | sparse  | 4096 | 15 679 566 |     523 |      8 829 → 1 426           |        19 424 → 3 000         |     17.1 → 2.7           |        37.6 → 5.7         |
| closure | dense   |  256 |     65 536 |      21 |         66 → 17              |            84 → 21            |      3.1 → 0.8           |         3.9 → 1.0         |
| closure | dense   |  512 |    262 144 |     167 |        550 → 122             |           648 → 144           |      3.3 → 0.7           |         3.8 → 0.9         |
| closure | dense   | 1024 |  1 048 576 |   1 335 |      4 470 → 943             |         5 055 → 1 007         |      3.4 → 0.7           |         3.8 → 0.8         |
| samegen | sparse  | 1024 |    258 691 |       4 |         28 → 17              |            88 → 31            |      6.5 → 3.9           |        20.5 → 7.2         |
| samegen | sparse  | 4096 |  3 781 581 |      71 |        789 → 479             |         1 974 → 671           |     10.9 → 6.7           |        27.4 → 9.4         |
| samegen | dense   |  256 |    125 607 |       3 |         14 → 4               |            42 → 11            |      4.2 → 1.2           |        12.6 → 3.5         |
| samegen | dense   | 1024 |  2 065 210 |      54 |        414 → 120             |         1 161 → 252           |      7.7 → 2.2           |        21.5 → 4.6         |

Both checkers verified every row and both agreed with the evaluator's output relation on every
row (`verified_agrees` and `ranked_verified_agrees` true in all 66 records).

Peak resident memory is unchanged: 3 665 → 3 650 MB at the largest row, and within 25 MB
everywhere. That is not a null result for the checkers, it is a limitation of the harness — it
reports process-wide `VmHWM`, and the process peak is set by `representation_sizes`, which holds
the JSON, fixed-`u32`, varint, delta-varint, packed and CSV encodings of both certificates in
memory simultaneously (about 1.1 GB at the largest row). A checker-only figure needs the check to
run in its own process or the harness to sample RSS around it; that is a follow-up, not something
to invent a number for.

### Reading

1. **The hash maps were the cost, as C1183 supposed.** With nothing changed but the checkers'
   representations, the derivation-trace checker is 1.6–6.2× faster and the ranked searching
   checker 2.8–6.5× faster, on identical certificates over identical inputs. The largest row goes
   from 8.8 s to 1.4 s for the trace and 19.4 s to 3.0 s for the ranked form.
2. **The trace checker is now at or below evaluation on closure.** Every closure row is between
   0.7× and 2.7× evaluation, and the three dense rows are *below* it. Dense closure is where the
   evaluator emits 268 M candidates for 1.05 M derived tuples, so the closed-world pass
   re-enumerates the same matches with a cheaper inner loop — no witness columns to write, no
   delta bookkeeping — and wins.
3. **The ranked checker sits at 3–6× evaluation on sparse closure and does not reach the 3×
   target.** Its extra work over the trace checker is exactly the per-tuple justification search:
   two order probes, then per candidate a rank read and an inner probe. That search is what buys
   the certificate its size — the ranked form is the relation plus one byte per tuple against
   1.8–6× the relation for the trace — so this is the price of the smaller certificate, now paid
   at 5.7× evaluation instead of 37.6×.
4. **Same generation is the worst ratio for both, and the reason is that its evaluation is the
   most productive.** It derives 3.78 M tuples from 3.79 M candidates: almost every join match
   yields a new tuple, so the evaluator does nearly no wasted work (19 ns per derived tuple). The
   closed-world pass must still enumerate all 3.79 M matches and probe membership for each, with
   none of that productivity to amortize against. The check/eval ratio is therefore governed by
   the ratio of the closed-world per-match cost to the evaluator's per-candidate cost, and it is
   worst exactly where evaluation is tightest.
5. **What the profile says is left.** `perf record` on samegen sparse 4096, whole process:
   `closed_world` 13.5%, `ranked::check_bounded` 10.1%, `head_tuple` 8.4% (now only the derivation
   checker's insert path), `RelationStore::insert` 7.6%, `JoinIndexes::probe` 5.3%; the remainder
   is the harness serializing 137 MB of certificate JSON. Before `e6abc24` the third largest
   symbol was `__memcmp_evex_movbe` at 13.5%, which is what prompted that commit; it is gone from
   the profile afterwards, and the interleaved A/B of that one change on that one row measured
   trace 0.975× and ranked 0.922× — real, and smaller than the profile share suggested.

## Decision

Keep the direct-addressed checkers as the only implementation; there is no case for retaining the
hash-map versions. The derivation-trace certificate is now checkable at the same order as
evaluation across the board except sparse same generation, and the ranked-relation certificate —
the one worth shipping, since it is the relation plus a byte per tuple — is checkable at 3–9×
evaluation instead of 12–38×.

The identified next lever, stated as a lever and not as a prediction: the membership array holds
four bytes per universe entry where the evaluator's bitmap holds one bit, so the closed-world
probe stream touches 64 MB per binary relation over a 4096-element domain instead of 2 MB. A
presence bitmap alongside the row array would make the probe cache-resident at the cost of one
extra bit per universe entry and one extra write per insert; the row array is needed only where a
fully bound probe must return a row. Unmeasured.

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis/crates/verify/src/datalog_store.rs` at `c8e627e` (review fix: a probe of an unbuilt join index panics instead of yielding no rows, since an empty answer in the closed-world pass would accept an unclosed relation set; at `e6abc24`, the content the measurements ran on, `49a814d542a0f791b0f68e51dac856814eaf7b5f6536c929d14ee39cabc65667`) | `ea71f4115f236a6bfa855dff914681561d6b13bef43dbb86403c8aff7229fa2d` |
| `ergodis/crates/verify/src/derivation.rs` | `6dd70ad3c76644f4f358eb503304a3489f756f74232e0dd76d61c4971b963426` |
| `ergodis/crates/verify/src/ranked.rs` | `c9213b3738f7831e894452c0fb91e2c76c4386dcccee97e99bdec1ccbbfbc8da` |
| `ergodis/crates/verify/src/lib.rs` | `26ccc372b25161b1f8814e47333485095942d87da339ffa8432a8fa2428a3dda` |
| `ergodis/crates/rules/tests/demand.rs` at `e6abc24`, the content the gates ran on | `9e2fc72d2216a81fd60f4c3c772d47fdeb2d2b5c05e11a89fe0eae4301f240a4` |
| `ergodis/crates/rules/tests/demand.rs` at `a8e52fd`, after a concurrent session rewrote two comments that named task identifiers | `d6bbbf5dbc4ecf3d006707c4a0724900dc862a5643fa4b582e16ded4b7774893` |
| `ergodis-private/examples/closure_ballpark.rs` (unchanged from C1183) | `f098d3359417c880c4f07a6c7b6bfa41d49bafcbf2054ed3a277d2f739026eae` |
| `ergodis-private/analysis/datalog-comparison/ab-2026-09-13-c1184.tsv` (63 241 bytes, the A/B above) | `ffb2ea2473db96b86ddafaefcf0d27cc978089f4287589f8d6924dc5eca37faf` |
| `ergodis-private/analysis/datalog-comparison/results-2026-09-13-c1184.jsonl` (10 494 bytes, single-run full table with certificate sizes) | `b343cd5d00eeb55ec17d01463c72c6a3f8a76159332797f158f45c43ef7d2bfe` |
| candidate harness: `closure_ballpark` from private `9f177c1` over core `e6abc24` | built from those commits; the binary itself is not cited |
| control harness: `closure_ballpark` from private `7cc7175` over core `69ffd81` (the C1183 build) | built from those commits; the binary itself is not cited |

Commits: core `ergodis` `db96bcc` (the direct-addressed checkers), `e6abc24` (the head-tuple
cut) and `c8e627e` (the review fix above; full gate re-run green at that commit); private `ergodis-private` `9f177c1` (first full table) and `30c8263` (the A/B and the
re-run table). Toolchain `rustc 1.95.0 (59807616e 2026-04-14)` from `nixpkgs`, matching
`rust-toolchain.toml`; release profile, no features.

Build the harness:

```
cd ~/src/ergodis-private
nix shell nixpkgs#cargo nixpkgs#rustc -c ../ergodis-contrib/scripts/retain-bin.sh \
  . closure_ballpark --example --profile release --label c1184b
```

Replay one row of the table, exactly as C1183 specifies it:

```
taskset -c 3 <harness built above> --evaluator demand \
  --program <closure|samegen> <N> <sparse|dense> 5 <dir>
```

The JSON line carries `eval_median_ns`, `verify_ns`, `ranked_verify_ns`, `peak_rss_kb` and
`representation.*`. The A/B interleaves that command between the two retained harnesses, three
rotated rounds per row with three repeats, which is `ab-2026-09-13-c1184.tsv`; each of its lines
is `A|B`, the round number, then the JSON line. Inputs are the C1182 deterministic generators
(xorshift64 seeded by the domain: closure `0x9E3779B97F4A7C15 ^ N`, same generation
`0x2545F4914F6CDD1D ^ N`), no other randomness. The independent replay of each certificate is the
other checker plus exact tuple-set comparison with the evaluator's rows, which the harness
asserts on every row.

## Mystery ledger (`ej` + `tt` closeout)

- **Peak resident memory did not move, though the hash maps did.** Settled, and it is a
  measurement limitation rather than a result: the harness reports process-wide `VmHWM`, and the
  peak belongs to `representation_sizes`, which materializes six encodings of both certificates
  at once. Open gap: no checker-only memory figure exists. It needs the check in its own process
  or an RSS sample bracketing it — a small harness change, owner is a successor task.
- **Same generation resists.** Settled as to mechanism, open as to remedy: its evaluation is
  almost perfectly productive (3.78 M derived from 3.79 M candidates), so there is nothing for the
  closed-world pass's re-enumeration to amortize against, and the checkers sit at 6.7× and 9.4×
  evaluation there. The measured next lever is the membership array's 64 MB footprint against the
  evaluator's 2 MB bitmap; unmeasured, and the owner is a successor task.
- **`memcmp` was 13.5% of the process but removing it bought 2.5% and 7.8%.** Settled: the
  profile share is of the whole harness process, which spends most of its time serializing
  137 MB of certificate JSON, so a share of the process is not a share of the checkers. The
  lesson is that this harness's profiles cannot be read as checker profiles without that
  correction — worth remembering before the next profile of it.
- **Evaluation is unchanged and that is the control.** The A/B's two binaries agree on evaluation
  time to within 1% on every row, which is what makes the check-time deltas attributable. No
  mystery, but it is the reason the earlier cross-day comparison was discarded.
- **The box drifted during the work.** Three consecutive replays of the same table got
  monotonically slower and same-generation evaluation ran 1.7× the C1183 figure with identical
  code. Settled by switching to the interleaved A/B, whose numbers put same-generation evaluation
  back at 71 ms against C1183's 69 ms. Nothing open, but no cross-session timing comparison should
  be trusted on this host without a retained control.

No discovery-track entry: nothing incidental beyond the task's own question.
