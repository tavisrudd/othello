# C1170 — Scanner keyword lookup and the reserved-word set

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`
**Control**: `ergodis-tools` built from a clean checkout at `5e6345f` and retained as
`ergodis-tools-5e6345f` (rebuild recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools
ergodis-tools` at that revision)

**Commits** (all on `main`, in order): `2840757` reserved-word policy and packed keyword lookup
(candidate A), `5a1e11f` first-byte length-set prefilter on top of it (candidate B), `fcd7d1a`
removal of the prefilter after measurement.

Provenance. The control is the first in this measurement series built from a tree with no foreign
uncommitted files, which matters for the `prepare` question left open by the Pratt-loop report.
Both candidate executables were built from trees that still carried foreign uncommitted files:
campaign-console mockups and interface-review material under `analysis/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`tests/partitioned_join_profile.rs` and `tests/quadratic_residual_profile.rs`. None of those
executes in the frontend and the change under test is exactly the committed diff, but the candidate
binaries are not reproducible from their commits alone.

## Status

Complete, with a negative performance result. Two items from the C1170 handoff were taken: the
scanner keyword lookup, which the previous report named as the largest remaining scanner cost
after `lexer::scan` at 8.54 per cent of parse-stage instructions, and the lexical reserved-word gap
in `analysis/rel-frontend/coverage-v1.json`. The reserved-word gap is closed and the
over-reservation defect it hid is fixed. The keyword rewrite is a wash on the production byte
scanner and buys about 1 to 3 per cent on the scalar variant; the 8 to 10 per cent attributed to
`lexer::keyword` by symbol share was sample skid, not compare work. Candidate A is kept, candidate
B was reverted.

## Reserved-word policy

The Rel reference keyword table (https://rel.relational.ai/rel/ref/lexical-symbols, section
Keywords) lists exactly 26 keywords: `and`, `as`, `bound`, `def`, `else`, `end`, `entity`,
`exists`, `false`, `for`, `forall`, `from`, `ic`, `if`, `iff`, `implies`, `in`, `module`, `not`,
`or`, `then`, `true`, `use`, `where`, `with`, `xor`. The lexical page
(https://rel.relational.ai/rel/ref/lexical) does not enumerate keywords itself and says only that
some identifiers are keywords.

The prototype reserved 32 spellings plus `_`: the 26 table entries plus `declare`, `value`, `type`,
`import` and `doc`. None of those five is in the keyword table. `value` and `type` appear only as
grammar terminals on the value-types page (`Declaration := Annotation* "value" "type" Id …`), `doc`
and `declare` are declaration-start spellings the prototype recognises, and `import` has no
reference basis at all — Rel imports are written `with … use`. The over-reservation was a real
defect: `def value = 1`, `def type(x) = …`, `def doc = …` and `def import = 1` were rejected with
`ExpectedName` although they are legal relation names.

The new policy is that reserved words are exactly the 26 table entries plus the anonymous variable
`_`. `doc`, `value`, `type` and `declare` became contextual. The scanner emits them as
`Kind::Name` carrying a `Token::flags` marker (`FLAG_DOC` = 1, `FLAG_VALUE` = 2, `FLAG_TYPE` = 3,
`FLAG_DECLARE` = 4, defined in `src/rel_frontend/mod.rs`), and the parser consults the flag only at
the start of a top-level item: a `doc`-flagged name immediately followed by a string is a
doc-string item and a recovery synchronisation point; `value` followed by a `type`-flagged name,
and `declare` followed by a name, reject as `UnsupportedSyntax` exactly as before. Anywhere else
these four are ordinary names, and `import` is an ordinary name everywhere. The token kinds
`Declare`, `Value`, `Type`, `Import` and `Doc` were removed from `Kind`, which renumbers
`CustomOp`, `CustomMul` and `CustomAdd` — the renumbering has a measurement consequence recorded
below.

Two tests were added in `tests/rel_frontend.rs`.
`reserved_words_are_exactly_the_reference_keyword_table` checks that each of the 27 reserved
spellings scans to its kind; that each with a suffix letter, a suffix digit or a leading
underscore, and each in upper case or capitalised, scans as a name; that the four contextual
spellings carry their flag and become plain names with a suffix; that no two reserved words of
length at least four share both their first four and their last four bytes, which is the
comparison the packed key actually performs; and that `import`, `requires`, `ensures`, `__`,
`impliesx` and `implied` are names. `contextual_spellings_are_names_except_at_item_start` covers
the positives `def type = 1`, `def value(x) = type(x) and doc(x)`,
`module value def type = doc end` and `doc "about f" def f = 1`; the negatives `value type Person`
and `declare person(x)` rejecting as `UnsupportedSyntax` and `doc def f = 1` rejecting as
`UnexpectedToken`; and bare `value`, `doc(1)` and `declare + 1` parsing as expressions. The
diagnostics test's keyword control changed from `def value = (1, 2]` to `def module = (1, 2]`.

The native/WASM parity corpus in `tests/rel_frontend_portability.rs` changed
`("def value = 1", false)` to `true` and added `def module = 1` (false),
`def type(x) = doc(x) and declare(x)` (true), `doc "about f" def f = 1` (true),
`value type Person` (false) and `declare person(x)` (false). The regenerated receipt
`analysis/rel-frontend/portability-v1.json` records 151 cases and 335,671 canonical bytes with
native and WASM byte-equal, canonical SHA-256
`5f707d3737b32071e0bebfca304ff1a5e2902fa0152937ddada60bd5aa194cc8`, against 146 cases and 333,381
bytes before.

The lexical family of `analysis/rel-frontend/coverage-v1.json` now describes the prototype as
reserving exactly the reference keyword table plus `_`, with `doc`, `value`, `type` and `declare`
contextual at item start, and its remaining entry is now "Reference Unicode boundary conformance".
Unicode boundary conformance is the only lexical gap still open.

Gates: the targeted frontend tests in `tests/rel_frontend.rs` pass (19 tests), and strict Clippy
passes on the library, on that test target and on the `ergodis-tools` crate.

## The two keyword-lookup candidates

Candidate A (`2840757`). `lexer::keyword` now takes `&[u8]` and switches on length: length 1 is
`_` or a name; lengths 2 and 3 pack their bytes into a word; lengths 4 to 7 pack two overlapping
little-endian `u32` windows, the first four and the last four bytes, into a `u64`; anything longer
than 7 is a name immediately. The resulting `(length, key)` pair is matched against `const` packed
constants built by a `const fn pack`. There is no byte loop and no runtime-length `memcmp`.

Candidate B (`5a1e11f`) added, on top of A, a 256-entry `FIRST` table keyed by the first byte and
holding the bit set of reserved and contextual word lengths that start with that byte, so most
names are rejected by one load and one bit test before any comparison. After measurement B was
removed again in `fcd7d1a`; the tree keeps A.

## Method

Both candidates were measured against the same retained control with
`analysis/rel-frontend/bench.py --control … --rounds 7 --cpu 5 --stages parse,recover`, all five
cohorts, 512 definitions, interleaved with the order of the two binaries alternating per round and
with A/A null pairs, under `perf stat` with two-point differencing. The receipts are
`analysis/rel-frontend/performance-v1-keyword-2840757.json` and
`analysis/rel-frontend/performance-v1-keyword-5a1e11f.json`; they carry the binary hashes, so cite
the receipts rather than the retained-binary paths.

The driver's fingerprint gate fired on the Unicode cohort. Removing five token kinds renumbers the
custom-operator kinds, so the representation fingerprint differs even though the parse is
identical. The first run aborted after all seven rounds. A new `--representation-change REASON`
flag records the declared reason and the list of differing operations in the receipt while still
requiring equal token counts, equal node counts and identical failure on every operation; both
receipts were produced with it.

Instruction ratios decide. Cycle ratios are reported with their intervals and settle nothing on
their own.

## Results

Candidate over control, seven rounds. The `*/parse/byte-null` rows are the driver's null-pair
operation measured candidate over control; the separate byte-over-byte A/A nulls within each binary
follow in the second table.

| Operation                       | Candidate A instructions | Candidate B instructions | Candidate A cycles   | Candidate B cycles   |
|---------------------------------|--------------------------|--------------------------|----------------------|----------------------|
| prepare                         | 1.0037 [0.9905, 1.0171]  | 1.0014 [0.9948, 1.0081]  | 1.002 [0.965, 1.040] | 0.977 [0.954, 0.999] |
| ascii/parse/byte                | 0.9980 [0.9957, 1.0004]  | 0.9980 [0.9941, 1.0019]  | 1.004 [0.978, 1.031] | 0.954 [0.881, 1.033] |
| ascii/parse/scalar              | 0.9803 [0.9790, 0.9816]  | 0.9828 [0.9811, 0.9845]  | 0.942 [0.905, 0.981] | 0.947 [0.913, 0.983] |
| ascii/recover/byte              | 0.9982 [0.9958, 1.0007]  | 0.9980 [0.9956, 1.0005]  | 0.984 [0.951, 1.018] | 0.946 [0.914, 0.978] |
| ascii/recover/scalar            | 0.9819 [0.9807, 0.9831]  | 0.9819 [0.9797, 0.9841]  | 0.945 [0.921, 0.970] | 0.968 [0.914, 1.026] |
| ascii/parse/byte-null           | 0.9972 [0.9940, 1.0004]  | 0.9995 [0.9980, 1.0011]  | 1.006 [0.975, 1.038] | 0.962 [0.919, 1.007] |
| unicode/parse/byte              | 0.9938 [0.9878, 0.9998]  | 0.9930 [0.9901, 0.9960]  | 0.996 [0.975, 1.017] | 0.992 [0.964, 1.021] |
| unicode/parse/scalar            | 0.9891 [0.9853, 0.9929]  | 0.9909 [0.9890, 0.9928]  | 1.005 [0.943, 1.071] | 0.992 [0.956, 1.029] |
| unicode/recover/byte            | 0.9975 [0.9915, 1.0034]  | 0.9935 [0.9901, 0.9969]  | 0.995 [0.966, 1.026] | 0.992 [0.953, 1.031] |
| unicode/recover/scalar          | 0.9897 [0.9858, 0.9936]  | 0.9905 [0.9879, 0.9932]  | 0.984 [0.960, 1.009] | 1.016 [0.983, 1.050] |
| unicode/parse/byte-null         | 0.9972 [0.9904, 1.0042]  | 0.9945 [0.9922, 0.9968]  | 1.003 [0.982, 1.024] | 1.003 [0.955, 1.054] |
| comment-string/parse/byte       | 1.0018 [0.9985, 1.0050]  | 0.9979 [0.9967, 0.9991]  | 1.022 [1.002, 1.042] | 1.006 [0.981, 1.032] |
| comment-string/parse/scalar     | 0.9898 [0.9876, 0.9920]  | 0.9892 [0.9869, 0.9914]  | 0.969 [0.935, 1.006] | 0.986 [0.963, 1.009] |
| comment-string/recover/byte     | 1.0019 [0.9980, 1.0057]  | 0.9983 [0.9955, 1.0010]  | 1.001 [0.975, 1.027] | 0.994 [0.968, 1.020] |
| comment-string/recover/scalar   | 0.9896 [0.9873, 0.9918]  | 0.9876 [0.9860, 0.9891]  | 0.956 [0.920, 0.993] | 0.946 [0.905, 0.988] |
| comment-string/parse/byte-null  | 1.0000 [0.9958, 1.0042]  | 0.9976 [0.9959, 0.9993]  | 0.980 [0.948, 1.014] | 0.973 [0.946, 1.001] |
| malformed-early/parse/byte      | 0.9960 [0.9936, 0.9985]  | 0.9963 [0.9936, 0.9989]  | 0.969 [0.914, 1.027] | 0.894 [0.864, 0.925] |
| malformed-early/parse/scalar    | 0.9713 [0.9682, 0.9744]  | 0.9715 [0.9688, 0.9741]  | 0.914 [0.862, 0.968] | 0.904 [0.853, 0.957] |
| malformed-early/recover/byte    | 0.9976 [0.9943, 1.0009]  | 0.9975 [0.9956, 0.9994]  | 0.997 [0.980, 1.015] | 0.932 [0.887, 0.980] |
| malformed-early/recover/scalar  | 0.9812 [0.9797, 0.9827]  | 0.9812 [0.9791, 0.9832]  | 0.957 [0.905, 1.011] | 0.949 [0.882, 1.021] |
| malformed-early/parse/byte-null | 0.9975 [0.9944, 1.0006]  | 0.9980 [0.9959, 1.0002]  | 0.938 [0.891, 0.989] | 0.868 [0.831, 0.906] |
| malformed-late/parse/byte       | 0.9996 [0.9975, 1.0017]  | 0.9977 [0.9948, 1.0006]  | 0.974 [0.954, 0.995] | 0.941 [0.912, 0.971] |
| malformed-late/parse/scalar     | 0.9829 [0.9811, 0.9847]  | 0.9819 [0.9797, 0.9841]  | 0.973 [0.945, 1.003] | 0.948 [0.893, 1.007] |
| malformed-late/recover/byte     | 1.0004 [0.9990, 1.0017]  | 0.9967 [0.9953, 0.9981]  | 0.982 [0.944, 1.023] | 0.963 [0.894, 1.037] |
| malformed-late/recover/scalar   | 0.9807 [0.9785, 0.9829]  | 0.9819 [0.9798, 0.9840]  | 0.941 [0.904, 0.981] | 0.967 [0.921, 1.015] |
| malformed-late/parse/byte-null  | 0.9982 [0.9963, 1.0001]  | 0.9987 [0.9966, 1.0008]  | 0.989 [0.963, 1.015] | 0.965 [0.929, 1.003] |

Byte-over-byte A/A null instruction ratios within each run:

| Cohort          | Candidate A run         | Candidate B run         |
|-----------------|-------------------------|-------------------------|
| ascii           | 0.9986 [0.9954, 1.0018] | 1.0014 [0.9984, 1.0044] |
| unicode         | 1.0015 [0.9934, 1.0096] | 1.0016 [0.9981, 1.0052] |
| comment-string  | 0.9989 [0.9960, 1.0017] | 0.9991 [0.9964, 1.0017] |
| malformed-early | 1.0004 [0.9984, 1.0023] | 1.0008 [0.9988, 1.0028] |
| malformed-late  | 0.9980 [0.9955, 1.0006] | 1.0009 [0.9987, 1.0031] |

Every null sits within 0.3 per cent of unity with an interval containing 1.0, so the measurement is
sound; it is the effect that is absent. On the byte scanner, the production variant, the result is
a wash on every cohort: ASCII parse is 0.9980 [0.9957, 1.0004] for candidate A and
0.9980 [0.9941, 1.0019] for candidate B. The scalar variant improves by roughly 1 to 3 per cent —
ASCII parse 0.9803 [0.9790, 0.9816] for A, malformed-early parse scalar 0.9713 for A and 0.9715
for B. Cycle intervals span 3 to 7 per cent and are consistent with the instruction result without
adding to it. Candidate B's prefilter is not distinguishable from candidate A anywhere.

The `prepare` stage is 1.0037 [0.9905, 1.0171] for A and 1.0014 [0.9948, 1.0081] for B. The
1.2 per cent `prepare` offset reported in the Pratt-loop report against the dirty `f820daf` control
does not appear against this clean control, which supports that report's explanation of the offset
as code layout rather than anything in the frontend.

## Instruction profile

`perf record -e instructions:u -F 4000`, ASCII cohort, parse stage, byte scanner, 512 definitions,
2,000 iterations, pinned to CPU 7. Event totals: control 6.621 × 10⁹, candidate A 6.604 × 10⁹,
candidate B 6.608 × 10⁹.

| Symbol                                     | Control `5e6345f` | Candidate A `2840757` | Candidate B `5a1e11f` |
|--------------------------------------------|-------------------|-----------------------|-----------------------|
| `rel_frontend::lexer::scan`                | 45.88 %           | 52.39 %               | 51.92 %               |
| `rel_frontend::parser::Parser::expression` | 40.13 %           | 39.79 %               | 39.51 %               |
| `rel_frontend::lexer::keyword`             | 9.69 %            | 3.36 %                | 3.81 %                |
| `rel_frontend::parser::Parser::item`       | 1.77 %            | 1.93 %                | 2.13 %                |
| `rel_frontend::parser::Parser::node`       | 1.30 %            | 1.53 %                | 1.81 %                |
| `core::str::converts::from_utf8`           | 0.67 %            | 0.63 %                | 0.60 %                |

`perf annotate` on the control's `keyword` symbol explains the whole result. Of that symbol's
samples, 27.65 per cent and 27.11 per cent land on its first two instructions, `dec %rsi` and
`cmp $0x6,%rsi` — the entry to the length switch — and a further 12.20 per cent on a single
`cmove`. The body is a jump table on length followed by integer `xor`/compare against packed
literal constants such as `xor $0x6564,%eax` and `mov $0x6572616c,%ecx`, with no `bcmp` or `memcmp`
call anywhere.

So rustc and LLVM had already lowered the string `match` to exactly the length-switch-plus-word-
compare form that candidate A writes by hand. The 8 to 10 per cent share attributed to
`lexer::keyword` was sample skid onto the call entry — the cost of the call and return and of the
preceding identifier-scan loop's final stores — not comparison work. The rewrite moves that same
work inline, `scan` rises by very nearly the amount `keyword` falls, and the total is unchanged.
The scalar variant's small gain comes from dropping the `&str` re-slicing and the UTF-8 boundary
bookkeeping on the slow path, not from the comparison.

## Disposition

Candidate A is kept. It is the explicit form of what the compiler was already producing, it is not
slower on any cohort, and it carries the contextual-word flags the new reserved-word policy needs.
Candidate B is reverted: it adds a table and a branch for no measurable return.

The keyword lookup is recorded as an instructive negative for the symbol-share cost model. A small
leaf symbol's `perf record` share is not its instruction cost; before spending a candidate on one,
confirm the attribution by a differencing A/B or by inlining the symbol and watching where the
share goes.

## Mystery ledger

1. Settled. `lexer::keyword` at 8.54 per cent of parse-stage instructions was sample skid on the
   call entry, not compare work. Settled by `perf annotate` of the control symbol plus the A/B,
   which agree: the share moves into `scan` and the total does not change.
2. Settled. The 1.2 per cent `prepare` offset carried over from the Pratt-loop report does not
   reproduce against a control built from a clean tree (1.0037 [0.9905, 1.0171] and
   1.0014 [0.9948, 1.0081], both intervals containing 1.0). The layout explanation given there
   holds, and no frontend cause needs to be sought.
3. Open. `lexer::scan` is now 52 per cent of the ASCII parse stage, and its cost has not been
   attributed below the symbol level. The next probe is `perf annotate` of the identifier loop and
   the token store inside `scan`, or a scan-only measurement stage that isolates it from the
   parser.
4. Settled, documentation. The parity-replay paragraph in `analysis/rel-frontend/README.md`
   named a 146-case corpus after the receipt moved to 151; private `cbcb921` corrects it.

## Remaining next steps

1. Build the cold-start `prepare-touch` stage. `prepare` still does not charge first-touch page
   faults, so a fresh or resized workspace's real cost is unmeasured.
2. Attribute `lexer::scan` below the symbol level: identifier loop against token stores against
   punctuation dispatch. It is now the majority of the ASCII parse stage and every remaining
   scanner decision depends on that split.
3. Close the remaining syntax gaps by coverage-manifest family: caret entity references, string
   interpolation, and reference Unicode boundary conformance in the lexical family.
4. Begin the first semantic admission checks, name binding and arity.

No backend or evaluator was adopted in this work and nothing was published.
