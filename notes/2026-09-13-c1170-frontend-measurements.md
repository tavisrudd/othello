# C1170 — frontend measurements, bounded recovery, and the scanner cost model

**Lane**: `ergodis`
**Date**: 2026-09-13
**Repository**: private `~/src/ergodis-private` (branch `main`, base `051f734`). Core untouched.

Continues `2026-09-12-c1170-owned-rel-frontend.md`: the retained interleaved parser
measurements the handoff asked for, then the first recovery gap. The syntax/admission gap list
is unchanged except for the diagnostics family (see the manifest note).

## Status

C1170 remains open. This stop delivers the measurement harness with its receipt, a cost model
that redirects the next performance step, and bounded multi-error recovery with parity and
allocation evidence. Private commits, oldest first:

| Commit    | Contents                                                                                       |
| --------- | ---------------------------------------------------------------------------------------------- |
| `99281a2` | deterministic measurement cohorts, `ergodis-tools rel-frontend-bench`, interleaved perf driver  |
| `fefa9f9` | bounded declaration-level recovery, parity recovery records, first counter receipt              |
| `1940023` | workspace Clippy repair (foreign files; see below)                                              |
| `f820daf` | ASCII class-table scanner fast path (kept by the A/B below), recovery receipt, control mode      |

Gates re-run at each commit: strict Clippy on the private library, the tools binary and both
frontend test targets; the frontend integration tests (17) and the native probe; the native/WASM
parity replay; `rustfmt --check` on every changed file.

## Measurement harness

- `src/rel_frontend/corpus.rs` freezes five deterministic cohorts of 512 top-level items: ASCII,
  Unicode (Greek/CJK identifiers, `⊗`, qualified Unicode symbols), comment/string (line and block
  comments, plain, triple and raw strings), and the ASCII cohort with one syntax error in the
  first or the last item. Generation is a pure function of the cohort name and item count; every
  receipt records each cohort's SHA-256.
- `ergodis-tools rel-frontend-bench` measures one (cohort, scanner variant, stage) triple and
  prints one JSON line: source bytes and hash, token and node counts, occupied and retained
  bytes, peak RSS, the failure record if any, and per-iteration nanosecond percentiles. Stages
  are cumulative boundaries: `prepare` (workspace allocation), `parse` (UTF-8 validation, scan,
  parse), `recover`, `enrich` (error-only enrichment), `render`, `composed` (all of them with a
  fresh workspace). No stage stands in for admission or lowering. Cohort generation, hashing,
  the byte/scalar equality control and output happen outside the timed loop; a `black_box`
  witness (token count, last node end, failure code) defeats dead-code elimination without
  charging a traversal to either arm.
- `analysis/rel-frontend/bench.py` runs every operation each round under `perf stat` pinned to
  one core, with two-point differencing (repeat N versus N/2) so process startup and setup cancel,
  alternating byte/scalar order per round, one byte-versus-byte A/A pair per cohort for null
  drift, and optional candidate-versus-control binaries. Comparisons are paired log ratios with
  Student t intervals. The receipt records the retained binary hash, repository commit,
  toolchain, CPU, method, and the census per operation.

Receipts: `analysis/rel-frontend/performance-v1.json` (all cohorts, stages `parse`, `enrich`,
`render`, `composed`; retained `ergodis-tools-99281a2`) and `performance-v1-recover.json`
(`parse` versus `recover`; retained `ergodis-tools-fefa9f9`). Seven rounds each, CPU 5, AMD
Ryzen AI 9 HX 370.

## Findings

**Instructions decide; cycles are noisy here.** Instruction counts per iteration repeat to about
half a per cent across rounds. Cycle counts vary 20–30 per cent round to round because other
builds ran on the box during the run (including this task's own), and the A/A null pairs show
cycle ratios from 0.85 to 1.27 with instruction ratios of 1.000 ± 0.005. Cycle ratios are
reported with their intervals and are not used for any verdict below.

**Baseline cost, byte scanner, `parse` stage, per source byte / per token:**

| Cohort         | Bytes  | Tokens | Instr/byte | Instr/token | Cycles/byte (noisy) | p50 wall |
| -------------- | -----: | -----: | ---------: | ----------: | ------------------: | -------: |
| ASCII          | 43,008 | 15,489 |      126.0 |         350 |                  42 |   353 µs |
| Unicode        | 61,888 | 15,617 |      181.7 |         720 |                  66 |   914 µs |
| comment/string | 65,610 |  4,609 |       34.4 |         489 |                  10 |   135 µs |
| malformed late | 42,935 | 15,469 |      125.9 |         349 |                  43 |   358 µs |
| malformed early| 42,956 | 15,463 |       73.9 |         205 |                  31 |   220 µs |

Roughly 120 MB/s on ASCII. That is far from a scanner-bound frontend: a byte-class scanner
runs at a handful of instructions per byte. The malformed-early row shows the scan alone costs
about 74 instructions per byte (the parse stops at item one), so scanning is over half the
ASCII total and parsing the rest.

**ASCII byte dispatch is not the lever.** Scalar over byte, instructions: ASCII 1.049
[1.043, 1.055], Unicode 1.011 [1.004, 1.018], comment/string 1.091 [1.086, 1.096], malformed
early 1.079, malformed late 1.049. The byte dispatch saves 1–9 per cent of instructions and
no cycle ratio is conclusive. The scalar control stays as the matched variant.

**Where the instructions go** (perf record, ASCII parse, instructions:u): `Parser::expression`
40 %, `lexer::scan` 23 %, `lexer::continuation` 13 %, `lexer::emit` 12 %, `lexer::start` 7 %,
`lexer::keyword` 3 %. The identifier-class helpers were out-of-line calls into
`char::is_alphabetic` / `is_numeric` per identifier byte, and every `s[p..]` slice paid a
UTF-8 boundary check. Those are the scanner half of the cost; the parser half is the
continuation-frame Pratt loop at roughly 32-byte frame push/pop per operand and operator.

**Error stages cost nothing on success and about ten instructions per byte on failure.**
`enrich`, `render` and `composed` are within noise of `parse` on the three well-formed cohorts.
On malformed-late, enrichment adds about 445,000 instructions on a 43 KB source: the excerpt
builder scans the source for line context. `prepare` is 2,500 instructions: `try_reserve_exact`
does not touch pages, so first-use page faults are charged to the first parse of a fresh
workspace, not to `prepare`; `composed` reuses freed pages and therefore does not surface them
either. A cold-start measurement remains open.

**Recovery is free on well-formed input and costs one full parse on early failure.**
`recover` minus `parse`, byte scanner: ASCII +959 instructions (43 KB source), malformed late
−4,553, malformed early +2,286,056 — the recovering parse continues through the remaining 511
items the compact parse skips, landing at the ASCII full-parse cost (5.46 M instructions).

## Bounded recovery

`Workspace::parse_recovering(bytes, sink: &mut [Failure]) -> Recovery` (and the scalar
variant). After a failure inside one top-level item, that item's partial nodes are truncated,
the frame stack cleared, the failure written to the next sink slot, and parsing resumes at the
next `def`, `module`, `@`, `doc`, or a module-closing `end` (only while a module is open).
Progress is forced when the failing item consumed nothing. Scanner and capacity failures are
terminal and record one failure. `Recovery { failures, truncated }` reports the count and
whether the sink filled or a capacity failure stopped early. `nodes()` afterwards is the parsed
subset of items with intact module parents; this is not a repaired tree. The compact `parse`
reports exactly the first recovered failure. `Failure::default()` is a documented placeholder
for unused slots.

Evidence: three new integration tests (multi-error ordering and codes, sink bounds including
a zero-length sink, module `end` synchronization with module span closure, terminal scanner
failures, stray top-level closers, unclosed module, the malformed cohorts recovering to exactly
one failure and 511 definitions, zero allocations over repeated recovering parses); the parity
corpus now carries a recovery record per case (count, truncation flag, failures, recovered node
count) plus four multi-error sources — 146 cases, 333,381 canonical bytes, native and WASM
byte-equal, 32 multi-failure cases, decoder consumption check extended
(`portability-v1.json`, canonical SHA-256 `5792fd09…`).

Known cascade: an `end` that closes a broken `if … end` inside an open module is taken as the
module's end. The sink bound keeps it finite; expression-level recovery is the manifest's
remaining diagnostics item.

## Scanner fast path A/B

The cost model above pointed at the scanner's out-of-line Unicode class calls and per-slice
UTF-8 boundary checks. `lexer.rs` now carries a 128-entry ASCII class table (whitespace,
identifier start, identifier continuation) used by the byte-dispatch variant for whitespace
and identifiers only; every other byte, every non-ASCII byte and `raw"` fall through to the
shared scalar logic, so the accepted language is unchanged (the parity replay produced the
identical canonical SHA-256). The three helpers are inlined. The scalar variant keeps its
`char` path.

Interleaved A/B, candidate over retained control `ergodis-tools-fefa9f9`, `parse` stage, seven
rounds (`performance-v1-lexer-table.json`; the retained `ergodis-tools-f820daf` is byte-identical
to the measured candidate):

| Cohort          | Instructions ratio [95 %] | Cycles ratio [95 %]  | Instr/byte before → after |
| --------------- | ------------------------: | -------------------: | ------------------------: |
| ASCII           |      0.766 [0.763, 0.768] | 0.689 [0.661, 0.718] |             127.2 → 97.4  |
| Unicode         |      0.926 [0.921, 0.931] | 0.881 [0.847, 0.916] |             182.6 → 169.0 |
| comment/string  |      0.816 [0.811, 0.820] | 0.742 [0.719, 0.767] |                           |
| malformed early |      0.600 [0.597, 0.602] | 0.496 [0.459, 0.535] |                           |
| malformed late  |      0.767 [0.766, 0.768] | 0.700 [0.677, 0.724] |                           |

The scan-only cohort (malformed early) drops 40 per cent of instructions; whole ASCII parse
drops 23 per cent. Cycle intervals exclude 1.0 for every cohort in this quieter run. The
scalar control also improved 7–23 per cent from the inlining alone, so the byte-versus-scalar
gap is now the table's contribution. All regression, allocation and parity gates pass
unchanged. Parsing is now the larger half of the ASCII cost.

## Foreign clippy repair

The user asked for Clippy to be fixed regardless of source. An Opus sub-agent repaired the
private workspace; every diff was re-read here (private `1940023`; workspace Clippy exits 0,
1,011 library tests pass). Root causes: the provider crates share `src/sparse_fault_search.rs` and
`src/partitioned_additive_join.rs` whose C1177 tests need `proptest` and `allocation_test`;
`packages/fault-provider` had no dev-dependencies and `packages/execution-provider/src/lib.rs`
included `allocation_test` only under the `qec` feature. The `williamson_parallel_profile` target
carries a narrowly scoped `dead_code` allowance because it includes a library module by path and
uses one entry point. The `plane12` capacity prune now prunes the `remaining == 0` case
instead of wrapping (solutions unchanged, node counts may differ). `cargo fmt --check` still
reports pre-existing drift in eight files that were not touched; formatting them is a separate
decision.

## Mystery ledger

- Cycle noise of 20–30 per cent in the first receipt versus under 5 per cent in the later ones:
  attributed to concurrent builds on the box (this task's own and the clippy sub-agent's);
  the A/A null pairs make it visible and the instruction metric is unaffected. Not a
  mystery, but the first receipt's cycle columns should not be quoted.
- The scalar control sped up 7–23 per cent from inlining alone, so the earlier "byte dispatch
  saves 1–9 per cent" reading was measuring the call overhead of the class helpers as much as
  decoding. Settled by the A/B; the matched-variant design is retained.
- `prepare` at 2,500 instructions cannot represent first-use cost: page faults land in the
  first parse. Open; owned by the cold-start stage in the next steps.
- No unexplained discrepancy remains in the recovery or parity gates.

## Manifest and next steps

`coverage-v1.json` diagnostics family: bounded declaration-level recovery moved to the
prototype column; remaining are expression-level recovery, cascade suppression at `end`,
semantic provenance and the editor adapter. All other families are unchanged; semantic admission
remains absent.

Next for C1170, in order of expected value:

1. Parser half of the cost: the Pratt continuation loop is 40 per cent of ASCII instructions.
   Measure a smaller frame (16 bytes) and operand fast paths (atom followed by a binary operator
   without a frame round-trip) under the same harness.
2. Cold-start boundary: charge first-touch page faults of a fresh workspace explicitly (a
   `prepare-touch` stage), since production parses will often use a fresh or resized workspace.
3. Remaining syntax gaps by manifest family, starting with the lexical reserved-word set and
   caret entity references (both scanner-only), then interpolation.
4. Semantic admission: name binding and arity as the first admitted checks, feeding the
   Ergodis lowering that this frontend exists to serve.
