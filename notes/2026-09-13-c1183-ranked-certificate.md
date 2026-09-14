# C1183 — ranked-relation certificates and certificate representation cost

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Successor to C1182 (`2026-09-13-c1182-demand-driven-datalog.md`).

## Question

The C1182 derivation certificate (rule plus two premise references plus the tuple, per derived
tuple, as JSON) was 5–25× the output relation in bytes. Is that the representation (JSON) or the
structure (an explicit trace)? Both were measured, and the structural alternative was built.

## What was built

Core `ergodis` `69ffd81` (two commits from `40e78d5`), private `ergodis-private` `7cc7175`
plus the measurement commit.

1. **Ranked-relation certificate** — `crates/verify/src/ranked.rs`, `RankedCertificate`
   (`finite-boolean-ranked-certificate.v1`): per declared relation, the derived tuples and one
   rank each; facts are rank zero and are not listed. Nothing else. The evaluator emits it from a
   new per-row round column (`Demand::ranked_certificate`); the round a tuple was derived in is
   its rank.
2. **Searching checker** — `ranked::check`. It re-admits the source, admits every listed tuple
   into a packed-tuple → (rank, row) map, builds hash join indexes for the column masks the
   search can need (both atom orders of every rule; a fully bound atom is answered from the rank
   map, no index), then for each listed tuple of rank `r` looks for a rule with that head whose
   body matches with every premise of rank below `r`, walking the smaller of the two atom
   orders' index buckets. The closed-world pass is the C1182 one, factored into
   `derivation::closed_world` and shared by both checkers. Soundness by search, local fixedness
   by the shared pass, well-foundedness by rank: the C1173 argument with the trace replaced by a
   bounded search.
3. **Representation measurement** — the private harness encodes both certificate forms with
   real encoders and reports exact byte counts: JSON, fixed little-endian `u32`, LEB128 varint,
   and for the trace a delta-coded varint form with the recomputable tuple dropped; for the
   ranked form additionally packed `u16` tuples with a one-byte rank, and the rank column alone.
   The output relation as CSV and as packed `u16` is listed for reference.

## Acceptance

| Gate | Result |
|---|---|
| Ranked certificate verified on every C1182 agreement case: fixtures, C1179 family N ≤ 24, 256 generated programs per run; checker relations equal the trace checker's | pass (`tests/demand.rs`) |
| Negative controls: schema/identity/relation-count binding, dangling value, zero rank, out-of-domain value, tuple on an input relation, duplicate, every rank lowered below its justification, an underivable extra tuple, a dropped tuple; uniform rank shift accepted | each as expected (`ranked_certificate_rejects_every_mutation_class`) |
| Zero allocations in the derivation loop with the added round column | 0 (`tests/allocation.rs`) |
| `cargo fmt --check`, clippy `-D warnings`, `cargo test --all-features` (verify, rules), manifest regenerated | clean, 18 test binaries pass |

## Measurement

Harness `closure_ballpark` built from private `7cc7175` over core `69ffd81` (pinned `rustc 1.95.0`), one pinned core,
five warm evaluations per case, single run; sizes in MB are exact encoder outputs. "trace" is the
C1182 derivation certificate, "ranked" the new one. Check times are the independent checkers on
the same box; both are hash-map based and unoptimized.

| program | density | N | derived tuples | output tuples | max rank | eval ms | trace check ms | ranked check ms | trace JSON MB | trace u32 | trace varint | trace delta, no tuple | ranked JSON | ranked u32 | ranked packed | ranked varint | ranks only | output CSV | output u16 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| closure | sparse | 256 | 62979 | 62979 | 12 | 2 | 7 | 22 | 1.2 | 1.3 | 0.5 | 0.4 | 0.6 | 0.8 | 0.3 | 0.3 | 0.1 | 0.4 | 0.3 |
| closure | sparse | 1024 | 979983 | 979983 | 13 | 31 | 246 | 699 | 20.8 | 19.6 | 9.5 | 5.9 | 9.6 | 11.8 | 4.9 | 4.7 | 1.0 | 7.7 | 3.9 |
| closure | sparse | 2048 | 3954709 | 3954709 | 13 | 128 | 1601 | 3840 | 91.5 | 79.1 | 39.7 | 26.6 | 43.2 | 47.5 | 19.8 | 19.3 | 4.0 | 35.2 | 15.8 |
| closure | sparse | 4096 | 15679566 | 15679566 | 15 | 528 | 8600 | 19134 | 384.0 | 313.6 | 166.3 | 114.0 | 180.3 | 188.2 | 78.4 | 77.4 | 15.7 | 148.3 | 62.7 |
| closure | dense | 256 | 65536 | 65536 | 2 | 21 | 66 | 84 | 1.2 | 1.3 | 0.6 | 0.4 | 0.6 | 0.8 | 0.3 | 0.3 | 0.1 | 0.5 | 0.3 |
| closure | dense | 512 | 262144 | 262144 | 2 | 166 | 534 | 643 | 5.2 | 5.2 | 2.4 | 1.5 | 2.5 | 3.1 | 1.3 | 1.2 | 0.3 | 2.0 | 1.0 |
| closure | dense | 1024 | 1048576 | 1048576 | 2 | 1307 | 4403 | 4931 | 21.9 | 21.0 | 9.9 | 6.5 | 10.3 | 12.6 | 5.2 | 5.0 | 1.0 | 8.2 | 4.2 |
| samegen | sparse | 1024 | 258691 | 132795 | 24 | 4 | 24 | 96 | 5.2 | 5.2 | 2.5 | 1.5 | 2.7 | 3.1 | 1.3 | 1.2 | 0.3 | 1.0 | 0.5 |
| samegen | sparse | 4096 | 3781581 | 1930883 | 30 | 69 | 776 | 1892 | 90.2 | 75.6 | 38.9 | 22.7 | 46.5 | 45.4 | 18.9 | 18.8 | 3.8 | 18.3 | 7.7 |
| samegen | dense | 256 | 125607 | 62909 | 10 | 3 | 13 | 48 | 2.4 | 2.5 | 1.1 | 0.7 | 1.2 | 1.5 | 0.6 | 0.5 | 0.1 | 0.5 | 0.3 |
| samegen | dense | 1024 | 2065210 | 1033985 | 12 | 53 | 397 | 1133 | 44.2 | 41.3 | 20.0 | 13.1 | 20.4 | 24.8 | 10.3 | 9.8 | 2.1 | 8.1 | 4.1 |

### Reading

1. **Representation is a 1.2× effect.** JSON against fixed `u32` words: 384 against 314 MB for
   the largest trace, 180 against 188 MB for the ranked form (JSON is even slightly smaller
   than `u32` there, since ranks and small values print short).
2. **Redundancy plus varint is the next 2.7×.** Varint-coding the trace fields halves it
   (166 MB); dropping the recomputable tuple and delta-coding the premise references brings the
   trace to 114 MB, 7.3 bytes per derivation, close to its information content.
3. **The structural change is the large one.** The ranked form packs to 78 MB for 15.7 M
   tuples, 5 bytes per tuple, of which 4 are the relation itself as `u16` pairs; the ranks
   alone are 15.7 MB, one byte per tuple. So the certificate costs 25 % over the relation the
   consumer receives anyway, against 1.8× for the best trace encoding and 6× for the JSON trace.
4. **What it costs in checking.** The searching checker is 1.1× the trace checker on dense
   closure (where the trace checker's closed-world join dominates both), 2.2× on sparse closure
   (19.1 against 8.6 s at 15.7 M tuples) and 2.4–4× on same generation, where each `sg` tuple
   has two rules to try and the two-parent DAG gives wider buckets. Before the fully bound
   probes were routed through the rank map the sparse-closure figure was 30 s: building a
   full-column hash index over 15.7 M rows was the cost.
5. **Both checkers remain 15–35× the evaluation time.** That is the hash-map checker, not the
   certificate: the evaluator's direct-addressed bitmap does the same membership work in a
   fraction of the time. A direct-addressed checker is the obvious next step and would benefit
   both forms equally.

## Decision

The ranked-relation certificate is the right default for this rule class: it is the relation
plus one byte per tuple, and its checker's extra search is bounded by the join degree. The
derivation trace stays available for consumers that want a trace with no search (or a
small-degree guarantee that does not hold, such as a rule whose smaller bucket is still large).

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis/crates/verify/src/ranked.rs` | `b3a779addd01675bb4cf37c72e12411eb945820ee1eb67bcfaf3817b49d32ec8` |
| `ergodis/crates/verify/src/derivation.rs` | `74a88362008594712172337d302d5d9f7293aa7c4e1bc8d565a288d059e75d28` |
| `ergodis/crates/rules/src/demand.rs` | `433d055f053a51d84783721ec7359b8c019572e3f05192cd9f5a5c49f1402c3d` |
| `ergodis/crates/rules/tests/demand.rs` | `cde4d5516beaac49bad5a20c7707d6f983d7a8b3a53011aab3dca02b842e1a9b` |
| `ergodis-private/examples/closure_ballpark.rs` | `f098d3359417c880c4f07a6c7b6bfa41d49bafcbf2054ed3a277d2f739026eae` |
| `ergodis-private/analysis/datalog-comparison/results-2026-09-13-c1183.jsonl` (10 501 bytes, private `64cefc9`) | `1293bf1fcc4d29cd4082bbb159f0ce4bd6d92274cfc575f16090b625fe663ba6` |

Replay: build the harness from private `7cc7175` with core `69ffd81` checked out beside it
(`retain-bin.sh . closure_ballpark --example --profile release`; a retained local binary is a
convenience, not evidence), then for each row `taskset -c 3 <harness> --evaluator demand --program <closure|samegen>
<N> <sparse|dense> 5 <dir>`; the JSON line carries `representation.*`, `verify_ns` and
`ranked_verify_ns`. Inputs are the C1182 deterministic generators. Independent replay of each
certificate is its checker; both checkers' relations were compared with each other and with the
evaluator's rows on every case.

## Mystery ledger (`ej` + `tt` closeout)

- **JSON smaller than fixed `u32` for the ranked form.** Settled: short decimal numbers plus
  one separator beat four fixed bytes; nothing open.
- **Why the search costs 2× on sparse closure when the degree is 3.** Per tuple the checker does
  about nine hash probes (two order probes, then per candidate a rank lookup, a fully bound probe
  and a second rank lookup) against one insert for the trace; the second rank lookup after a
  fully bound probe is redundant and a cheap cut, not taken here. The rest is the hash map.
  Owner: the direct-addressed checker, unallocated.
- **Rank column entropy.** Max rank 15 on sparse closure and 30 on same generation: the rank
  fits four or five bits, so the 1 byte per tuple could be halved by bit packing. Not measured;
  the relation dominates either way.
- **Trace information content.** 7.3 bytes per derivation after delta coding against an
  estimate of about 5 (log₂ of |path| × |edge|); the gap is LEB128 granularity and the rule
  byte. No mystery.

No discovery-track entry: nothing incidental beyond the task's question.
