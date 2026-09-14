# C1170 — Punctuation fast path in the byte-dispatch scanner

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`
**Control**: `ergodis-tools` built at revision `9f1e57e` and retained as `ergodis-tools-9f1e57e`
(rebuild recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `3d6a7b8462eaa8ee27a66ceccc7d6e601ba01de5913eb2d9170be4e5374efcf3`,
rustc 1.95.0 (59807616e 2026-04-14) read from the binary's `.comment` section, release profile,
no features.

**Commits** (all on `main`, in order):

| Commit    | Contents                                                                    |
|-----------|-----------------------------------------------------------------------------|
| `6ed6ff9` | candidate A: the single-byte punctuation table, the three skipped shared-path re-tests, the short-ASCII variant-agreement test, the control A/A receipt |
| `7b8b873` | candidate B: the first-byte compound index on top of A, comparing spellings with a slice `starts_with` |
| `598426f` | candidate C: byte-wise compound comparison off the common punctuation path, replacing B's shape; the A and B receipts |
| `4311847` | the `delimiter` synthetic class and the census punctuation split; the C receipts |
| `b69fa5b` | the class-decomposition receipt at the candidate                             |
| `4e617aa` | `analysis/rel-frontend/README.md`                                           |
| `cfe4893` | one figure in that README stated per scan iteration                         |

## Status

Complete, with a large positive result and one instructive negative inside it.

Vetting notes (parent session, 2026-09-14): the 20 frontend tests and strict Clippy on the
library, the `rel_frontend` test target and `ergodis-tools` were re-run independently at `cfe4893`
and pass. The compound compare reads its second and third bytes through `get(..).unwrap_or(0)`,
so end-of-input is bounds-safe without a slow path; `as usize` appears only at index sites; no
`unsafe`, raw pointer or dependency was added. The absolute counts are internally consistent: the
658,098-instruction ASCII saving is the same figure from the scan-stage and parse-stage receipts.
Both performance documents' binding items (Fermi before build, call-free kernel-scoped profile,
zero-allocation regression, full counter set, git-visible arm citation, peak RSS, variant record,
shared target directory) are addressed in the Hot-path discipline and Method sections.

The punctuation fast path is kept, in the shape of candidate C. On the ASCII
cohort it removes **19.90 per cent of the parse stage** (ratio 0.8010, a paired
interval of width under one part in ten thousand) and 34.65 per cent of the scan
stage, and it is faster than the control on all five cohorts in the byte variant
while leaving the scalar variant at exactly 1.0000. That is above the previous
report's 10 to 18 per cent Fermi bracket; the counter-based half of that bracket
was the closer of the two methods.

The negative is inside the design. Candidate B put the compound index on the same
path as every punctuation token and compared spellings with a slice
`starts_with` over a table-supplied length. That lowers to an out-of-line libc
`memcmp`, which the scan-stage profile puts at 5.55 per cent, and candidate B
measured 40,072 instructions per ASCII scan iteration **worse** than candidate A,
which has no compound index at all. Candidate C fixes both halves — explicit
byte comparisons, and the common single-byte token left on candidate A's block —
and beats A by 0.67 points on ASCII.

A method result came out of the control run: the event set this lane had been
using multiplexes, and a set that fits the PMU takes the A/A instruction null
from 0.2 per cent to two parts per million. Effects of a tenth of a per cent are
now measurable here, which is what let candidate B's regression be read as a
signal rather than noise.

## Control

`ergodis-tools` was retained at `9f1e57e`, the `HEAD` of the frontend work with nothing of this
lane's uncommitted, before any source change. Retained name `ergodis-tools-9f1e57e`, measured sha256
`3d6a7b8462eaa8ee27a66ceccc7d6e601ba01de5913eb2d9170be4e5374efcf3`, rustc 1.95.0
(59807616e 2026-04-14), release profile, no features. That closes the toolchain gap the
previous report left open: control and candidates are now built by the same compiler, so a
candidate-over-control ratio is a code effect and not a compiler effect.

The retained bytes are identical to `ergodis-tools-c526b3f`, the previous report's measured
binary, because the four commits between `c526b3f` and `9f1e57e` touched only analysis scripts,
receipts and documentation. Nothing in the `ergodis-tools` dependency graph changed, so Cargo
produced the same executable and the sha256 matches.

Foreign uncommitted files present when every binary in this report was built (the same set as the
previous two reports, plus two more): campaign-console mockups and interface-review material
under `analysis/`, `packages/execution-provider/src/lib.rs`,
`packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Two of those are library modules, so they do compile into
`ergodis-tools`; none of them executes in the frontend, and they were byte-identical across all
three builds, so they are common to both arms and cancel in every ratio. No executable in this
report is reproducible from its commit alone.

### The A/A null on the control, and a method improvement

Seven rounds, CPU 5, all five cohorts, `--stages parse`, event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults` (receipt
`analysis/rel-frontend/performance-v1-punct-control-aa.json`). The byte-over-byte instruction
nulls:

| Cohort          | Instructions            | Cycles                  |
|-----------------|-------------------------|-------------------------|
| ascii           | 1.000000 [0.999998, 1.000001] | 1.037 [0.985, 1.092] |
| unicode         | 1.000000 [0.999999, 1.000000] | 0.959 [0.840, 1.095] |
| comment-string  | 1.000002 [1.000000, 1.000004] | 1.001 [0.976, 1.028] |
| malformed-early | 1.000000 [0.999998, 1.000002] | 0.975 [0.936, 1.016] |
| malformed-late  | 1.000000 [0.999999, 1.000001] | 1.003 [0.969, 1.038] |

Every instruction null is within two parts per million of unity. That is two orders of magnitude
tighter than the 0.2 per cent the previous reports recorded, and the reason is the event set: this
one fits the PMU and does not multiplex, so instruction counts are reproducible to a few counts in
3.3 million rather than sampled. The four hardware events (`cycles` and `instructions` on fixed
counters, `branches` and `branch-misses` on two general-purpose counters) plus the two
kernel-counted software events were confirmed to run at 100 per cent enabled on this host. The
practical consequence is that an effect of a tenth of a per cent is now measurable in this lane,
where before it sat inside the null. Cycles are unchanged in character: intervals of 3 to 25 per
cent, settling nothing on their own.

## Candidate design

### What the previous report found, and what is being changed

The byte-dispatch fast path served exactly two classes, whitespace and identifiers. Every other
byte fell through to the shared scalar logic and re-ran, in order, `character()`,
`c.is_whitespace()`, `starts_with("//")`, `starts_with("/*")`, `starts_with("raw\"")`, the two
quote tests, `start(c)`, the digit test, a linear scan over eight compound spellings, and only then
the `match c` that assigns the kind. A single-byte operator or delimiter cost 126 instructions
against a short identifier's 101 and a whitespace byte's 13, and the ASCII cohort holds 7,232 of
them against 6,912 identifiers.

The ASCII cohort's punctuation, counted from the frozen source:

| Bytes | Tokens | Where they go |
|---|---:|---|
| `(` 1,856, `)` 1,856, `,` 768, `=` 640, `[` 384, `]` 384, `*` 192, `-` 128, `^` 128, `%` 64, `;` 64 | 6,464 | the kind table, one byte one kind, in all three candidates |
| `:` 384, `+` 128, `<` 64 | 576 | candidate A: the shared path. Candidates B and C: the kind table |
| `>=` 64, `:>` 64, `<++` 64, `<=` 64 | 256 | candidate A: the shared path's eight-spelling scan. Candidates B and C: the first-byte compound index |
| `...` 256 | 256 | the shared path's eight-spelling scan, in all three: its first byte is `.` |
| `.` 128, `/` 64 | 192 | the shared path, in all three |

So candidate A moves 6,464 of the 7,744 punctuation tokens (83 per cent) onto a table, and
candidates B and C add 832 more, reaching 94 per cent. The 448 tokens that remain on the shared
path are the `.` and `/` single bytes and the `...` spellings, all of which need more than their
first byte to decide.

### Candidate A, commit `6ed6ff9`

A fourth bit `PUNCT` in the existing 128-entry `CLASS` table, and a parallel `[Kind; 128]` table
`PUNCT_KIND`. `PUNCT` is set exactly for the ASCII bytes whose token the first byte decides on its
own: `( ) [ ] { } , ; @ # - * % ^ = |`. The fast path is then one byte advance, one table load and
the token store, and nothing else:

```rust
if k & PUNCT != 0 {
    p += 1;
    emit(w, PUNCT_KIND[b as usize], a, p)?;
    continue;
}
```

Both tables are built at compile time from one `const fn punct_of(b) -> Kind`, which returns
`Kind::Eof` for a byte that is not single-byte punctuation. `Eof` is never a punctuation kind, so
it is the empty marker, and `CLASS` sets `PUNCT` exactly where `punct_of` is not `Eof`. There is
one source of truth for which bytes are in the fast path and what they mean.

The bytes deliberately left out are those whose token the first byte does not decide: `.` may open
a number or `...`, `/` may open a line or block comment, `"` and `'` open literals, `!` alone is
not a token at all, and `< > + :` each begin a compound spelling. All of them fall through to the
shared path, which is unchanged.

Folded into the same commit, the three provably redundant re-tests named as a next step in the
previous report. The loop head now records whether the byte was classified by the table:

```rust
let classified = BYTE_SCAN && bytes[p] < 128;
let k = if classified { CLASS[bytes[p] as usize] } else { 0 };
```

and the shared path skips what the class bits have already answered:

- `c.is_whitespace()` becomes `!classified && c.is_whitespace()`. The `WS` bit is set for exactly
  ` `, `\t`, `\n`, `\r`, 0x0b and 0x0c, which is exactly the set of ASCII scalars with the Unicode
  White_Space property, so `char::is_whitespace` agrees with the bit on every ASCII byte; a set bit
  already continued the loop.
- `start(c)` becomes `!classified && start(c)`. The `START` bit is exactly `start` over ASCII. One
  byte sets `START` and still falls through — the `r` of `raw"` — but the literal branch above the
  identifier test consumes it and always continues or returns, so it never reaches this test.
- `c.is_ascii_digit()` becomes `k & CONT != 0` for a classified byte. `CONT` is set for the
  alphanumerics and `_`, and a classified byte that reaches this point has `START` clear, so `CONT`
  set means exactly an ASCII digit. The leading-dot number test beside it is untouched, since `.`
  is not classified into any of the four bits.

Under scalar dispatch `classified` is the compile-time constant `false` and `k` is `0`, so all
three guards fold away and the scalar variant compiles to what it compiled to before.

### Fermi estimate, written before the measurement

The previous report's bracket (10 to 18 per cent of the ASCII parse stage,
centred near 14) was for a fast path covering all of punctuation. The shape
actually built covers less, so the bracket was rescaled to it before any binary
was measured, using that report's counter method:

A table-dispatched punctuation token should cost the 13-instruction loop head
and byte-class dispatch, one table load, and the 23-instruction token store —
about 46 against the control's 126, saving 80 per token. Candidate A reaches
6,464 of the ASCII cohort's 7,232 single-byte punctuation tokens, so
6,464 × 80 = 517,120 instructions, 27.2 per cent of the scan stage and
**15.6 per cent of the parse stage**. Candidate B adds 576 single bytes and 256
of the 512 compound tokens, at about 80 and 58 each, for 578,048 in total, 30.4
per cent of the scan stage and **17.5 per cent of the parse stage**. The three
dropped re-tests are worth a further tenth of a per cent at most, because the
punctuation fast path has already removed almost everything that used to run
them: 1,024 fall-through entries per iteration remain against 8,768 before.

Measured, candidate C removed 19.90 per cent of the parse stage. The model was
right in direction and low by about two points, which is not an order of
magnitude, so the cost model stands; the "Where the saved instructions went"
section below decomposes the two points.

### Candidate B, commit `7b8b873`

A fifth bit `PLEAD`, set on the four `PUNCT` bytes that also begin a compound spelling, and a
`COMPOUND_SPAN: [(u8, u8); 128]` table indexing a six-entry `COMPOUND` array by that first byte.
`< > + :` join `PUNCT`, and the fast path tests at most three candidate spellings — three for `<`,
one each for `> + :` — instead of falling through to a linear scan over all eight:

```rust
let mut kind = PUNCT_KIND[b as usize];
let mut width = 1;
if k & PLEAD != 0 {
    let (lo, hi) = COMPOUND_SPAN[b as usize];
    // at most three `bytes[p..].starts_with(spelling)` tests
}
```

`...` and `!=` are not in the index because `.` and `!` are still not `PUNCT`; the shared path
still scans all eight spellings for them. The groups are disjoint by first byte, and the three
spellings that share `<` differ in their second byte, so the indexed order and the shared path's
order decide alike — the ordering that mattered in the shared scan (`<++` before `<=`) cannot
matter here.

### Why the output is identical

The change is a dispatch change over a partition of the ASCII byte range; no accepted or rejected
input moves. The gates below check that three ways: the 151-case native/WASM parity corpus keeps
its canonical SHA-256, the driver's own control requires the byte and scalar variants to agree on
tokens, nodes, failure and fingerprint for every measured operation, and a new test
`byte_dispatch_matches_the_shared_path_on_every_short_ascii_source` enumerates all 128 one-byte and
all 16,384 two-byte ASCII sources, plus all 4,096 three-byte sources over the compound, comment,
literal and number lead bytes, and requires the two variants to produce the same scanner result and
the same tokens on each. The scalar variant is the unchanged shared path, so that test is the
equivalence statement the candidates need.

The token record stays 16 bytes — the `const` size and alignment assertions in
`src/rel_frontend/mod.rs` are untouched and still compile — and the parser is untouched.

### Candidate C, commit `598426f`, which is what the tree keeps

Candidate B's two defects, both visible in its scan-stage profile and both fixed
here:

1. `bytes[p..].starts_with(spelling)` where `spelling` is a `&[u8]` taken from a
   table has a run-variable length, so rustc lowers it to a call to libc
   `memcmp`. The scan-stage symbol profile puts `__memcmp_evex_movbe` at 5.55 per
   cent. The shared path never had this problem: its eight spellings are `&str`
   literals in an unrolled `for` over an array literal, so each comparison has a
   constant length and inlines. `COMPOUND` is now `[(u8, u8, u8, Kind); 6]` —
   second byte, third byte, width, kind — and the comparison is one or two
   register compares. Bytes past the end of the source read as 0, and no spelling
   byte is NUL, so running off the end rejects, which is the required behaviour.
2. The `PLEAD` test and the resulting non-constant `width` sat on the path every
   punctuation token takes. The branch is now taken first, so a byte that leads
   no compound keeps candidate A's block verbatim and pays one bit test.

### Shapes considered and not built

Recorded so the next agent does not re-derive them.

- **`.` and `/` in the kind table.** Rejected before building: `.` may open a
  number or `...` and `/` may open either comment form, so each needs a second
  test that the other 15 bytes do not, and together they are 192 of the ASCII
  cohort's 7,744 punctuation tokens, 2.5 per cent of the class. The measured cost
  of leaving them out is about 11,000 instructions per iteration, 0.9 per cent of
  the candidate's scan stage.
- **A 128 × 128 second-byte dispatch table.** Rejected: 16 KiB of table to decide
  six spellings, against a 128-entry span table and at most three compares.
- **First-byte gating of the `//`, `/*` and `raw"` tests on the shared path.**
  Not built, and now worth much less than it was: only 1,024 bytes per ASCII
  iteration still reach them, against 8,768 before the fast path.

### Hot-path discipline

Stated against the contract in `~/src/ergodis-dev/PERFORMANCE.md` and the shared
playbook, both read in full for this task.

- **No new run-constant branch in the loop.** The byte/scalar split remains the
  existing `const BYTE_SCAN` monomorphization and nothing was added beside it.
  `classified` is not a toggle: it is a property of the byte being scanned
  (`BYTE_SCAN && bytes[p] < 128`), so it varies per iteration by construction,
  and under `BYTE_SCAN = false` it folds to a constant and every guard
  disappears. The scalar variant's exact 1.0000 instruction ratio against the
  control on all five cohorts and both stages is the measurement of that.
- **Call-free loop.** The candidate's kernel-scoped scan-stage profile — the
  `scan` stage runs UTF-8 validation and the scanner and nothing else — contains
  three symbols above a tenth of a per cent: `lexer::scan` 93.28 per cent,
  `lexer::keyword` 6.06 and `core::str::converts::from_utf8` 0.49. `keyword` is
  the one out-of-line call in the loop, once per identifier, and it predates this
  work; `from_utf8` runs once per scan, outside the loop. No libc symbol appears:
  the `memcmp` candidate B introduced is gone, and the remaining entries below a
  tenth of a per cent are clap argument parsing, the source SHA-256 and dynamic
  linking, all outside the timed loop.
- **Tiger-style records.** The three new tables are `const` arrays of
  range-sized integers: `CLASS` is `[u8; 128]`, `COMPOUND_SPAN` is
  `[(u8, u8); 128]`, `COMPOUND` is `[(u8, u8, u8, Kind); 6]`, and `PUNCT_KIND` is
  `[Kind; 128]` where `Kind` is `#[repr(u16)]`. Together they are under a
  kilobyte of read-only data with no heap, no pointer chasing and no indirection.
  `Token` is unchanged at 16 bytes with its existing
  `const _: () = assert!(size_of::<Token>() == 16 && align_of::<Token>() == 4)`.
  No `unsafe` block and no raw pointer was added.
- **Zero allocation.** The three allocation regressions in
  `tests/rel_frontend.rs` — `repeated_success_and_compact_failure_do_not_allocate`,
  `measurement_cohorts_are_deterministic_and_do_not_allocate` and
  `recovery_matches_compact_parse_over_cohorts_and_does_not_allocate` — all drive
  the byte-scan path through `Workspace::parse` and all pass. The candidates add
  only `const` tables and no allocation site.
- **Build hygiene.** Everything built into the shared
  `~/.cache/ergodis/target/ergodis-private`; no per-experiment target directory
  was created. Profile data was written under `~/.cache/ergodis/perf-c1170/`, not
  `/tmp`, which is tmpfs on this host.

## Method

All three candidates were measured against the same retained control with the committed harness
`analysis/rel-frontend/bench.py`, seven rounds, all five cohorts, 512 definitions, both scanner
variants, `--stages scan,parse,recover`, interleaved with candidate/control and byte/scalar order
alternating per round, an A/A null pair per cohort, under `perf stat` with two-point differencing
and pinned to CPU 5. No harness was re-derived for this task. The receipts are
`analysis/rel-frontend/performance-v1-punct-6ed6ff9.json`,
`performance-v1-punct-7b8b873.json` and `performance-v1-punct-598426f.json`.

### The arms

The retained executables are a local A/B convenience. Each arm is identified by what is
git-visible:

| Arm | Repository | Revision | Dirty | Profile | Features | rustc | Retain recipe | Measured sha256 |
|---|---|---|---|---|---|---|---|---|
| control     | `ergodis-private`, `main` | `9f1e57e` | dirty (foreign files listed above) | release | none | 1.95.0 | `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` | `3d6a7b84…4efcf3` |
| candidate A | `ergodis-private`, `main` | `6ed6ff9` | dirty (same set) | release | none | 1.95.0 | same | `0b482747…8f7fa6a1` |
| candidate B | `ergodis-private`, `main` | `7b8b873` | dirty (same set) | release | none | 1.95.0 | same | `f8193f82…1c8e75ff43` |
| candidate C | `ergodis-private`, `main` | `598426f` | dirty (same set) | release | none | 1.95.0 | same | `f08fecfa…49d9e951` |
| class decomposition | `ergodis-private`, `main` | `4311847` | dirty (same set) | release | none | 1.95.0 | same | `5785a178…5eadad52d` |

The measured hashes are recorded as measured, not cited: the thing to run is the recipe at the
revision. The repository-wide diff of the foreign files was hashed at the start of the task and
again after the last build and was identical, so every arm saw the same foreign tree. The
decomposition arm `4311847` adds a synthetic source class to the measurement binary and does not
touch `src/rel_frontend/lexer.rs`, whose bytes are identical to `598426f`'s.

### Counters

The event set is `instructions,cycles,branches,branch-misses,page-faults,minor-faults`, confirmed
at 100 per cent enabled on this host. Cache events do not fit alongside `branches` and
`branch-misses`, so a supplementary A/B of candidate C against the control on the ASCII cohort was
run with `instructions,cycles,cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses`
(receipt `performance-v1-punct-598426f-cache.json`), also confirmed non-multiplexing.

No `--representation-change` declaration was needed: these candidates add no `Kind` and remove
none, so the driver's fingerprint gate was left armed and passed on every operation, which is
itself an output-equality check on all five cohorts in both variants.

Instruction ratios decide. Cycle ratios are reported with their intervals and settle nothing on
their own. The box is shared with other agents' builds; the one-minute load average during the
rounds ranged from about 1.7 to 4.3, which is why the cycle intervals are 3 to 25 per cent wide
and the instruction intervals are not.

## Results

### Candidate over control, byte variant

Seven rounds each. Instruction ratios; the paired intervals on these are narrower than the fourth
decimal place, so they are given separately below for the headline row rather than repeated in
every cell. Candidate C is the kept shape.

| Operation | A instructions | B instructions | C instructions | C cycles |
|---|---|---|---|---|
| prepare                     | 1.0022 | 0.9992 | **1.0005** | 1.002 [0.951, 1.056] |
| ascii/scan/byte             | 0.6651 | 0.6862 | **0.6535** | 0.661 [0.633, 0.689] |
| ascii/parse/byte            | 0.8077 | 0.8199 | **0.8010** | 0.766 [0.729, 0.805] |
| ascii/recover/byte          | 0.8079 | 0.8200 | **0.8012** | 0.727 [0.643, 0.822] |
| unicode/scan/byte           | 0.9313 | 0.9362 | **0.9248** | 0.962 [0.941, 0.983] |
| unicode/parse/byte          | 0.9416 | 0.9458 | **0.9361** | 0.930 [0.685, 1.262] |
| unicode/recover/byte        | 0.9416 | 0.9458 | **0.9361** | 0.953 [0.870, 1.045] |
| comment-string/scan/byte    | 0.8536 | 0.8618 | **0.8548** | 0.813 [0.769, 0.860] |
| comment-string/parse/byte   | 0.8916 | 0.8977 | **0.8925** | 0.816 [0.777, 0.858] |
| comment-string/recover/byte | 0.8917 | 0.8978 | **0.8926** | 0.834 [0.779, 0.892] |
| malformed-early/scan/byte   | 0.6652 | 0.6863 | **0.6535** | 0.633 [0.605, 0.662] |
| malformed-early/parse/byte  | 0.6653 | 0.6864 | **0.6536** | 0.645 [0.612, 0.679] |
| malformed-early/recover/byte| 0.8079 | 0.8200 | **0.8012** | 0.769 [0.728, 0.813] |
| malformed-late/scan/byte    | 0.6650 | 0.6860 | **0.6533** | 0.651 [0.623, 0.681] |
| malformed-late/parse/byte   | 0.8076 | 0.8197 | **0.8009** | 0.767 [0.736, 0.799] |
| malformed-late/recover/byte | 0.8078 | 0.8198 | **0.8011** | 0.783 [0.732, 0.838] |

The headline, at full precision: **ascii/parse/byte 0.801047 [0.801046, 0.801048]**, and
ascii/scan/byte 0.653487 [0.653485, 0.653489]. The intervals are that narrow because the
non-multiplexing event set makes the instruction count essentially exact across rounds.

The `prepare` stage is unchanged, as it must be — it allocates and drops a workspace and runs no
scanner. The `*/parse/byte-null` rows track their `*/parse/byte` partners to the sixth decimal on
every cohort and are omitted from the table.

Cycles fall by more than instructions on the ASCII, malformed and comment-string cohorts (0.766
against 0.801 on the ASCII parse stage), which is consistent with removing a long chain of
dependent tests and a mispredicted spelling ladder and replacing it with two independent table
loads. Every cycle interval is wide enough that this is a remark, not a claim.

### Scalar variant: the negative control

| Operation | A | B | C |
|---|---|---|---|
| every `*/scan/scalar`, `*/parse/scalar`, `*/recover/scalar`, all five cohorts | 1.0000 | 1.0000 | 1.0000 |

Fifteen operations per candidate, all at ratio 1.0000 with a zero-width interval. The scalar
variant executes the same instruction count as the control on every cohort and stage, which is the
measurement of the claim that `classified` and `k` fold to compile-time constants under
`BYTE_SCAN = false` and the shared path is untouched.

### Absolute per-iteration instructions

| Operation | Control `9f1e57e` | A | B | C |
|---|---:|---:|---:|---:|
| ascii/scan/byte            | 1,899,201 | 1,263,248 | 1,303,320 | 1,241,103 |
| ascii/parse/byte           | 3,307,809 | 2,671,856 | 2,711,926 | 2,649,711 |
| unicode/parse/byte         | 9,438,578 | 8,887,550 | 8,926,980 | 8,835,327 |
| comment-string/parse/byte  | 1,620,213 | 1,444,609 | 1,454,463 | 1,446,024 |
| malformed-early/parse/byte | 1,896,870 | 1,261,924 | 1,301,942 | 1,239,809 |

Candidate C removes 658,098 instructions from the ASCII scan stage per iteration, which is 15.3
instructions per source byte or 42.5 per token.

Wall time, from the probe's own per-iteration timer and secondary to the counters: the ASCII parse
stage's median iteration is 169,115 nanoseconds on the control and 134,541 on candidate C, a ratio
of 0.796 that agrees with the instruction and cycle ratios.

Peak resident set, ASCII parse stage: control 5,916 KiB, candidate C 5,912 KiB; ASCII scan stage,
control 5,452 and candidate 5,392. The new tables are under a kilobyte of read-only data and the
difference is process-to-process noise.

### A/A nulls

| Cohort | Control-only run | Candidate A run | Candidate B run | Candidate C run |
|---|---|---|---|---|
| ascii           | 1.000000 [0.999998, 1.000001] | 1.000000 | 1.000000 | 1.000001 [1.000000, 1.000002] |
| unicode         | 1.000000 [0.999999, 1.000000] | 1.000000 | 1.000000 | 1.000000 [0.999999, 1.000001] |
| comment-string  | 1.000002 [1.000000, 1.000004] | 1.000000 | 1.000000 | 1.000000 [0.999997, 1.000003] |
| malformed-early | 1.000000 [0.999998, 1.000002] | 1.000000 | 1.000000 | 0.999999 [0.999993, 1.000006] |
| malformed-late  | 1.000000 [0.999999, 1.000001] | 1.000000 | 1.000000 | 1.000000 [0.999999, 1.000001] |

### Cache and load behaviour

Supplementary A/B of candidate C against the control, ASCII cohort, seven rounds, receipt
`performance-v1-punct-598426f-cache.json`. Its own A/A instruction null is 1.0011 [0.9988, 1.0033],
looser than the main run's because this event set displaces the fixed-counter pair less cleanly;
it is a supplement, not a decision metric.

| Event | Scan stage, control | Scan stage, candidate | Ratio | Parse stage ratio |
|---|---:|---:|---:|---:|
| instructions           | 1,899,620 | 1,240,921 | 0.6532 | 0.8001 |
| cycles                 |   317,873 |   204,859 | 0.6445 | 0.7928 |
| L1 data-cache loads    |   437,947 |   350,250 | 0.7998 | 0.9227 |
| L1 data-cache misses   |     5,139 |     5,141 | 1.0006 | 0.9997 |
| Last-level references  |     5,217 |     5,187 | 0.9944 | 1.0169 |

Data-cache loads fall by 20 per cent on the scan stage while L1 misses are flat to four decimal
places. The three new tables are under a kilobyte of read-only data indexed by a byte that is
already in a register, so they live in L1 permanently and add no traffic; what falls is the load
count of the classification ladder they replace. Last-level cache misses are single digits per
iteration in both arms and carry no information here.

### Per-class coefficients and the census prediction

`scan-decompose.py` at revision `4311847`, five rounds, CPU 5, three-event set (receipt
`analysis/rel-frontend/performance-v1-scan-classes-4311847.json`), against the previous report's
figures for the same measurement on the control:

| Class | Control | Candidate | Change |
|---|---:|---:|---:|
| Punctuation the kind table decides (`(`)      | 126.45 | **38.45** | −88.00 |
| Punctuation that leads a compound (`+`)       | 126.45 | **67.45** | −59.00 |
| Compound operator (`<=`)                      | 107.89 | **76.89** | −31.00 |
| Number, per token                             | 106.00 | **82.00** | −24.00 |
| String, per token                             |  88.00 | **78.00** | −10.00 |
| Identifier up to 7 bytes, per token           |  66.25 | **64.25** |  −2.00 |
| Identifier 8 bytes or more, per token         |  31.23 | **29.26** |  −1.97 |
| Identifier, per body byte                     |  11.70 |   11.70   |   0.00 |
| Whitespace, per byte                          |  13.45 |   13.45   |   0.00 |

The single repeated-punctuation source no longer decomposes the class, because the fast path
treats `(` and `+` differently, so a `delimiter` class of repeated `(` was added and the census
counts punctuation in two buckets. The number and string rows are the three dropped shared-path
re-tests being paid for by the classes that still reach them: a number token saves 24 instructions
and a string token 10, neither of which is punctuation at all.

Census of the ASCII cohort with those coefficients:

| Class | Tokens | Bytes | Predicted instructions | Share of the scan stage |
|---|---:|---:|---:|---:|
| Identifier                           | 6,912 | 25,091 |   707,273 | 57.3 % |
| Punctuation, table-decided           | 6,464 |  6,464 |   248,533 | 20.1 % |
| Whitespace                           |     — |  7,872 |   105,867 |  8.6 % |
| Number                               |   832 |  1,469 |    82,105 |  6.6 % |
| Punctuation, not table-decided       |   768 |    768 |    51,800 |  4.2 % |
| Compound operator                    |   512 |  1,344 |    39,370 |  3.2 % |
| **Predicted total**                  |       |        | **1,234,948** | |
| **Measured scan stage**              |       |        | **1,241,096** | |

The prediction is 0.50 per cent below the measurement, against 0.10 per cent before the change.
The residual has a named cause: the 192 `.` and `/` tokens stay on the shared path entirely and
the 256 `...` tokens do too, and the census charges all of them at the compound-lead rate of
67.45, which undercharges them by roughly 11,000 instructions in total. That is about 0.9 per cent
of the scan stage, which brackets the 0.50 per cent residual. The check closes.

The census script still reproduces the previous report's number exactly when handed the previous
receipt — 1,897,242 predicted against 1,899,194 measured, −0.10 per cent — because a receipt
without the `delimiter` source predates the fast path, where the two punctuation cases cost the
same, and the script falls back to one coefficient.

## Instruction profile

`perf record -e instructions:u -F 4000`, ASCII cohort, byte scanner, 512 definitions, pinned to
CPU 7. The scan stage at 4,000 iterations, which runs UTF-8 validation and the scanner and nothing
else, and the parse stage at 2,000 iterations for comparability with the earlier reports.

| Symbol | Control, scan | A, scan | B, scan | C, scan | Control, parse | C, parse |
|---|---|---|---|---|---|---|
| `rel_frontend::lexer::scan`                | 91.38 % | 88.61 % | 84.29 % | 93.28 % | 51.77 % | 42.87 % |
| `rel_frontend::lexer::keyword`             |  7.30 % |  9.77 % |  8.43 % |  6.06 % |  4.43 % |  3.21 % |
| `libc __memcmp_evex_movbe`                 |    —    |    —    |  5.55 % |    —    |    —    |    —    |
| `core::str::converts::from_utf8`           |  1.10 % |  1.48 % |  1.44 % |  0.49 % |  0.44 % |  0.55 % |
| `rel_frontend::parser::Parser::expression` |    —    |    —    |    —    |    —    | 39.51 % | 48.29 % |
| `rel_frontend::parser::Parser::node`       |    —    |    —    |    —    |    —    |  1.75 % |  2.48 % |
| `rel_frontend::parser::Parser::item`       |    —    |    —    |    —    |    —    |  1.72 % |  2.02 % |

Shares are of a shrinking total, so read them beside the absolute counts above. The scanner is now
42.87 per cent of the ASCII parse stage where it was 51.77, and the parser, which is untouched, is
the majority of it for the first time in this series at 48.29 per cent.

The `__memcmp_evex_movbe` row is candidate B's defect and the reason it lost to candidate A. It
does not appear in the candidate C profile, nor does any other libc symbol above a hundredth of a
per cent inside the loop.

### Where the saved instructions went

`perf annotate --percent-type global-period` on the control's `scan`, bucketed into the named
address ranges of `analysis/rel-frontend/scan-regions.py` (whose ranges were read off a build
byte-identical to this control):

| Region of the control's `scan` symbol | Share |
|---|---:|
| Token store, non-identifier      | 16.89 % |
| Compound-spelling ladder         | 15.40 % |
| Byte-class dispatch              |  9.43 % |
| `start(c)` and digit test        |  3.39 % |
| Operator kind arms               |  2.93 % |
| Operator jump table              |  1.90 % |
| `is_whitespace` test             |  1.76 % |

Those seven regions are what a punctuation token walked. The candidate's `scan` compiles to a
different layout, so its ranges were re-read from its own disassembly rather than reused. The
punctuation fast path is one contiguous block at symbol offsets `+0x02d8` to `+0x0355`, and the
annotated instructions in it are, in order: `lea 0x1(%r13),%rbp` (advance one byte),
`test $0x10,%cl` and `jne` (the `PLEAD` bit, taken to the compound block), the token capacity
check `mov 0x64(%r12),%ecx` / `cmp` / `jae`, one `movzwl (%rcx,%rax,2),%r14d` — that is the
`PUNCT_KIND` load, a 16-bit indexed table read — the capacity-growth branch that is never taken,
and then the five stores of the 16-byte token with `inc %rbx`. Twenty-two instructions, on top of
the thirteen-instruction loop head and byte-class dispatch at `+0x0040` to `+0x006d`. Thirty-five
against the control's 126, and the counter method measured 38.45, which is the same number from an
independent direction.

So the saving is the disappearance of the classification ladder, the compound ladder and the
operator jump table from the punctuation path, replaced by one table load. Decomposing the
measured 658,098 instructions per ASCII scan iteration by the per-class coefficient changes:

| Source of the saving | Tokens | Per token | Instructions |
|---|---:|---:|---:|
| Punctuation moved to the kind table   | 6,464 | 88.00 | 568,832 |
| Punctuation moved to the compound index | 576 | 59.00 |  33,984 |
| Compound operators moved to the index |   256 | 31.00 |   7,936 |
| Numbers, from the dropped re-tests    |   832 | 24.00 |  19,968 |
| Identifiers, from the dropped re-tests| 6,912 |  ≈2.0 |  13,798 |
| **Accounted**                         |       |       | **644,518** |
| **Measured**                          |       |       | **658,098** |

The 13,580-instruction remainder is the `...` and `.` and `/` tokens, which stay on the shared path
and are charged nothing in this decomposition although the dropped re-tests speed them up too.

### Against the previous report's Fermi bracket

The previous report bracketed a full punctuation fast path at 10 to 18 per cent of the ASCII parse
stage by two methods: the profile deconvolution (method (a)) said 13.1 per cent, and the per-class
counters (method (b)) said 18.4 per cent. Measured, the shape actually built removed **19.90 per
cent**.

The counter method was closer, and it was closer for a structural reason rather than luck. Method
(a) estimated the saving by guessing which named address ranges a fast path would remove and what
fraction of two of them would survive — a judgement about code it had not seen. Method (b)
estimated it from a measured per-token cost and a counted number of tokens, and needed only one
guess, the cost of the replacement, which it put at 46 instructions against a measured 38.45. Both
methods also missed the re-test removal's effect on numbers and strings, which no punctuation
estimate contained. This is the second time in this lane that the counter method has beaten the
profile-share method on the same question, the first being the keyword lookup, where a symbol's
`perf record` share turned out to be sample skid. The lesson is the same one, stated positively: to
price a change, count the events it removes and measure what one costs; use the profile to find the
candidate and to check the result, not to size it.

## Disposition

Candidate C is kept, and it is the shape the tree carries at `598426f`. It is faster than the
control on every cohort in the byte variant and identical in the scalar variant, it wins on ASCII
by 19.90 per cent of the parse stage, and every output gate holds.

Candidate B's shape was removed by the forward commit `598426f` rather than left in place. It is an
instructive negative twice over. First, a `starts_with` against a slice whose length comes from a
table has a run-variable length and lowers to an out-of-line libc `memcmp`; the equivalent
literal-by-literal comparison the shared path does inlines. Second, work put on a branch that every
token of a class takes is paid by every token of that class: B's `PLEAD` test and non-constant
width cost about one instruction on each of the 6,464 tokens that gain nothing from it, which is
visible as the 0.10-point loss candidate C still carries against candidate A on the comment-string
cohort, where compound leads are almost absent. Candidate C recovers it everywhere else because
that cohort is the only one where the index has nothing to do.

Candidate A is not kept, but it is the right control for the compound index: the index is worth
0.67 points of the ASCII parse stage once it stops calling `memcmp` and stops taxing the common
path, and it is worth −1.2 points when it does neither.

The three shared-path re-test removals were folded in rather than measured separately, as the
previous report recommended. They are not separately identified by the A/B, but the class
decomposition prices them: 24 instructions per number token and 10 per string token, which are
classes with no punctuation in them at all, so the attribution is unambiguous. Their effect on the
ASCII cohort is about 34,000 instructions, 2.7 per cent of the candidate's scan stage.

The lane's measurement protocol changes as a result of the control run. The default six-hardware-
event set multiplexes; `instructions,cycles,branches,branch-misses` plus the two kernel-counted
software events does not, and takes the A/A instruction null from 0.2 per cent to two parts per
million. Every future A/B in this lane should use it. Cache events need their own run.

## Mystery ledger

1. **Settled.** Whether a punctuation fast path would pay, and how much. It removes 19.90 per cent
   of the ASCII parse stage, above the previous report's 10-to-18 bracket. Settled by an
   interleaved seven-round A/B against a toolchain-matched control, with the scalar variant at
   exactly 1.0000 as a negative control and the class decomposition agreeing from an independent
   direction (38.45 measured against 35 counted off the disassembly).
2. **Settled, and it changes how the lane sizes a candidate.** Which of the previous report's two
   attribution methods to trust. The counter method predicted 18.4 per cent against a measured
   19.90; the profile-deconvolution method predicted 13.1. The counter method needs one guess and
   the profile method needs several, and this is the second time in this lane the profile share has
   been the weaker estimator of a change's size.
3. **Settled, and it was a defect.** Candidate B was slower than candidate A despite doing strictly
   more dispatch from tables. The cause is a libc `memcmp` call at 5.55 per cent of the scan stage,
   introduced by a slice comparison of run-variable length, plus a per-token tax on a branch most
   tokens do not need. Both are removed in candidate C, whose kernel-scoped profile contains no
   libc symbol inside the loop.
4. **Settled.** The previous report's method assumption about the event set. The six-event set
   multiplexes; a four-hardware-event set does not and makes the A/A instruction null two parts per
   million rather than 0.2 per cent. Confirmed by the enabled-fraction field of `perf stat` and by
   five A/A nulls in each of four runs.
5. **Settled, and it reopened and closed the previous report's open item 4.** That item asked
   whether the class model's 0.10 per cent agreement was exact or the sum of compensating errors
   between punctuation and identifier. The fast path answered it in passing by splitting punctuation
   into two cost classes with a 29-instruction gap: a model built on the single old coefficient
   overshoots the candidate's measured scan stage by 14.6 per cent, and a model with the split is
   0.50 per cent low with a named residual. If the old agreement had been compensating errors, the
   split would not have landed this close. The out-of-sample cohort test the previous report asked
   for is still not done, and is still the stronger check.
6. **Open, and it is the next candidate.** The token store is now the largest identified single
   component of the scanner: 16.89 per cent of the control's `scan` symbol at the non-identifier
   site alone, 23.2 instructions for a 16-byte record written as five stores behind a capacity
   check, and five of the twenty-two instructions in the candidate's punctuation fast path are that
   store. Whether assembling the token in one or two registers and storing it as a single 16-byte
   write is faster is a measured question, not an assumption. The evidence gap is one A/B; the
   alignment of the token pool and whether the write can be a single unaligned 16-byte store are the
   things to establish first.
7. **Open, small.** Candidate C is 0.10 points worse than candidate A on the comment-string
   cohort — 1,415 instructions per iteration — because that cohort has almost no compound leads and
   every punctuation token there pays the `PLEAD` bit test for nothing. The arithmetic says one
   instruction per punctuation token, which matches. It is accepted as the price of the index on
   cohorts that use it. The evidence gap, if anyone wants to remove even that, is whether a
   two-entry class table indexed to give the fast path a single combined test compiles to fewer
   instructions than the two tests; that is a codegen question, not a design one.
8. **Settled, and it is a third data point for item 2.** `lexer::keyword`'s profile share of the
   scan stage is unstable enough to be useless as a cost. The control binary measured here is
   byte-identical to the one the previous report profiled — the same sha256 — and the two runs put
   `keyword` at 7.30 and 6.05 per cent of the same stage, a fifth of the value apart. Across the
   four builds profiled here the share ran 7.30, 9.77, 8.43 and 6.06 per cent while the function
   itself never changed and the identifier path changed by two instructions per token. At
   `-F 4000` over a stage this short the symbol carries few enough samples that return skid onto
   its call site moves the share by points. Read the class coefficients, not the share.

## Gates and replay

Run from `~/src/ergodis-private`.

| Gate | Command | Outcome |
|---|---|---|
| Frontend tests | `nix shell nixpkgs#rustc nixpkgs#cargo -c cargo test -p ergodis-private --test rel_frontend -j 8` | 20 passed, 0 failed (19 before, plus the new short-ASCII variant-agreement test) |
| Clippy, library and test target | `nix shell nixpkgs#rustc nixpkgs#cargo nixpkgs#clippy -c cargo clippy -p ergodis-private --lib --test rel_frontend -j 8 -- -D warnings` | no diagnostics |
| Clippy, tools binary | `nix shell nixpkgs#rustc nixpkgs#cargo nixpkgs#clippy -c cargo clippy -p ergodis-tools --bins -j 8 -- -D warnings` | no diagnostics |
| Formatting | `nix shell nixpkgs#rustfmt -c rustfmt --check --edition 2021 src/rel_frontend/lexer.rs tests/rel_frontend.rs tasks/tools/src/rel_frontend_bench.rs` | all clean except two pre-existing diffs in `tests/rel_frontend.rs`, both present at `9f1e57e` (lines 695 and 707 there) and neither touched |
| Native/WASM parity replay | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json` | 151 cases, 335,671 canonical bytes, byte-equal, canonical SHA-256 `5f707d3737b32071e0bebfca304ff1a5e2902fa0152937ddada60bd5aa194cc8` unchanged |
| Driver fingerprint gate | armed on every measured operation of all three A/B runs (no `--representation-change`) | equal tokens, nodes, failure and fingerprint against the control on all five cohorts in both variants |
| Census backward compatibility | the same census script against the previous report's class receipt | 1,897,242 predicted against 1,899,194 measured, −0.10 per cent, reproducing that report exactly |

Every gate was run again at the final `HEAD` (`4e617aa`) and passes there.

The parity receipt was regenerated because the candidates change the recorded source hash of
`src/rel_frontend/lexer.rs`. The canonical output hash is identical, which is the statement that no
candidate changed what the frontend accepts or produces. The three allocation regressions inside
`tests/rel_frontend.rs` still assert zero allocations and still pass; the candidates add only
`const` tables and no allocation site.

Measurement replay, in order. `$CONTROL` is `ergodis-tools` retained at `9f1e57e` and
`$CANDIDATE_<rev>` the same binary retained at that revision, each by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` run with that revision checked
out.

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
python3 analysis/rel-frontend/bench.py --binary "$CONTROL" --rounds 7 --cpu 5 \
    --stages parse --events $E \
    --out analysis/rel-frontend/performance-v1-punct-control-aa.json
for c in 6ed6ff9 7b8b873 598426f; do
  python3 analysis/rel-frontend/bench.py --binary "$CANDIDATE_$c" --control "$CONTROL" \
      --rounds 7 --cpu 5 --stages scan,parse,recover --events $E \
      --out analysis/rel-frontend/performance-v1-punct-$c.json
done
python3 analysis/rel-frontend/bench.py --binary "$CANDIDATE_598426f" --control "$CONTROL" \
    --rounds 7 --cpu 5 --cohorts ascii --stages scan,parse \
    --events instructions,cycles,cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses \
    --out analysis/rel-frontend/performance-v1-punct-598426f-cache.json
python3 analysis/rel-frontend/scan-decompose.py --binary "$CANDIDATE_4311847" --rounds 5 --cpu 5 \
    --out analysis/rel-frontend/performance-v1-scan-classes-4311847.json
"$CANDIDATE_4311847" rel-frontend-bench --cohort ascii --stage scan --repeat 1 --dump-source ascii.txt
python3 analysis/rel-frontend/cohort-census.py ascii.txt \
    --classes analysis/rel-frontend/performance-v1-scan-classes-4311847.json --measured 1241096
```

The profiles, for each of `9f1e57e`, `6ed6ff9`, `7b8b873` and `598426f`:

```sh
perf record -q -e instructions:u -F 4000 -o scan-<rev>.data -- taskset -c 7 \
    "$BIN" rel-frontend-bench --cohort ascii --stage scan --variant byte \
    --definitions 512 --repeat 4000
perf report -i scan-<rev>.data --stdio -g none --percent-limit 0.0
perf annotate -i scan-<rev>.data --stdio --percent-type global-period \
    -s 'ergodis_private::rel_frontend::lexer::scan' > scan-<rev>.txt
python3 analysis/rel-frontend/scan-regions.py scan-9f1e57e.txt
```

`scan-regions.py`'s named address ranges are valid for the control, whose executable is
byte-identical to the build they were read off; they do not apply to any candidate, whose ranges
were re-read from its own disassembly.

## Remaining next steps

1. **The token store is the next candidate, and it is now the largest identified component.** It is
   16.89 per cent of the control's `scan` symbol at the non-identifier site alone, 23.2 instructions
   for a 16-byte record, and five of the twenty-two instructions of the new punctuation fast path.
   The question is whether one 16-byte store beats five narrow ones; establish the token pool's
   alignment first.
2. **Use the non-multiplexing event set for every A/B in this lane.**
   `instructions,cycles,branches,branch-misses,page-faults,minor-faults` is confirmed at 100 per
   cent enabled here and makes the instruction null two parts per million. Cache events need a
   separate run; they do not fit alongside the two branch counters.
3. **Retain a control at the kept revision `598426f` before the next A/B**, so the next change is
   measured against the shape the tree actually carries rather than against `9f1e57e`.
4. **The out-of-sample cohort test for the class model is still not done.** Predicting the
   comment-string cohort would test the coefficients against comment and string classes, and needs a
   `comment` synthetic class and a census classifier that understands `//`, `/*`, triple and raw
   strings. It is a larger job than the `delimiter` class was, and the punctuation split having
   landed at 0.50 per cent is evidence for the model but not that test.
5. **Size the workspace to the source**, unchanged from the previous report: `Limits::default`
   reserves 21 MB whatever the input and the cold-start measurement prices that at about 3.8
   milliseconds of first touch, against the 157 pages a 43 KB source fills. This is a design
   question to raise before it is built.
6. **The 2 MiB-page question for the pools** is unchanged and untested: one A/B of `prepare-touch`
   with `madvise(MADV_HUGEPAGE)` would settle whether cold start halves.
7. The syntax and admission items are unchanged: caret entity references, string interpolation,
   reference Unicode boundary conformance, then the first semantic admission checks.

Cache hygiene, for the user's decision rather than mine: this task left five retained executables
in `~/.cache/ergodis/bin/` (`ergodis-tools-9f1e57e`, `-6ed6ff9`, `-7b8b873`, `-598426f` and
`-4311847`) and eight `perf.data` files totalling 153 KiB under `~/.cache/ergodis/perf-c1170/`.
None is cited as evidence anywhere; the receipts carry the hashes. Nothing was deleted, and none of
it is in `/tmp`.

No backend or evaluator was adopted in this work and nothing was published.
