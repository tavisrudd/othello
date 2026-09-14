# C1170 — cold-start `prepare-touch` and the attribution of `lexer::scan`

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`
**Base commit**: `cbcb921` ("Rel frontend README: the parity corpus has 151 cases")
**Control**: `ergodis-tools` built at revision `5e6345f` and retained as `ergodis-tools-5e6345f`
(rebuild recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision)

**Measured binary**: `ergodis-tools` built at `c526b3f` and retained as `ergodis-tools-c526b3f`
(rebuild recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that
revision). Built from a tree carrying foreign uncommitted files belonging to other work —
campaign-console mockups under `analysis/`, `packages/execution-provider/src/lib.rs`,
`packages/hadamard-provider/tests/contracts.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs` — so it is not reproducible from its commit alone. None of
those executes in the frontend. rustc 1.95.0, release profile, no features.

**Commits** (all on `main`, in order):

| Commit    | Contents                                                                             |
|-----------|--------------------------------------------------------------------------------------|
| `c526b3f` | the `prepare-touch` and `scan` stages, `Workspace::touch`, `scan_only_variant`, synthetic sources |
| `e6f7ab7` | `--control-skip` accepts a stage name                                                 |
| `aee72fd` | selectable perf events, cold-stage calibration, A/A null only when `parse` is selected |
| `8c85f5d` | the two measurement receipts                                                          |
| `e35a71b` | `scan-decompose.py`, `scan-regions.py` and the class receipt                          |
| `6046d17` | `cohort-census.py` and the prediction check                                           |
| `737b528` | `analysis/rel-frontend/README.md`                                                     |

## Status

Complete. Both deliverables are measurement and neither proposes an implemented change.

Vetting notes (parent session, 2026-09-14): the 19 frontend tests and strict Clippy on the
library, the `rel_frontend` test target and `ergodis-tools` were re-run independently and pass.
`c526b3f` adds `libc = "0.2"` to the `ergodis-tools` task crate only, for the `mallopt` call in the
cold stage; the library gains no dependency, so the task contract's no-new-runtime-dependency rule
holds. The ASCII scan-stage total appears as 1,899,306 (bench receipt, seven rounds) and 1,899,194
(the census check's measured input, from the class-decomposition run); they are two runs of the
same stage 0.006 per cent apart, not a discrepancy.

The cold-start boundary, open since the first C1170 measurement report, is closed: preparing a
fresh workspace and faulting in its pages costs 1,536 minor page faults and 1.13 milliseconds per
iteration under the bench limits, against `prepare`'s 2,546 instructions, zero faults and 130
nanoseconds. Almost all of it is kernel time that this host's `perf` does not count, so the stage
is read from its fault count and wall time.

`lexer::scan` is attributed below the symbol by two independent methods. The largest component is
not identifier scanning but punctuation: one single-byte operator or delimiter costs 126
instructions against a short identifier's 101 and a whitespace byte's 13, and punctuation is 48 per
cent of the scanner and 28 per cent of the ASCII parse stage. A punctuation fast path is named as
the candidate for a future task, at an estimated 10 to 18 per cent of that stage. Nothing was
optimized here.

One method assumption was invalidated along the way: the six-event `perf stat` set every previous
frontend receipt used multiplexes at about 83 per cent enabled on this host, which is harmless for
the cohort stages and fatal for a stage retiring thousands of user instructions.

## Deliverable 1 — the `prepare-touch` stage

### What the stage charges

`prepare` allocates a `Workspace` and drops it. `Workspace::new` calls `try_reserve_exact` on the
token, node, frame and module pools, which reserves address space without writing to it, so the
kernel has backed none of those pages when `prepare` finishes and the first-use page faults are
charged to whatever writes first — in practice the first parse. `prepare` is 2,546 instructions and
130 nanoseconds, and that number has never represented the cost of starting from a fresh workspace.

The new stage `prepare-touch` allocates a fresh workspace, writes one value into every 4,096 bytes
of all four pools through the new `Workspace::touch`, and drops it, every iteration. What it charges
is: one `Workspace::new` (the same allocation `prepare` performs), one write per 4 KiB page of the
retained workspace and the kernel's fault handling for each of those pages, and the deallocation.
What it does not charge: scanning, parsing, any source, and any read of the pools — `touch` leaves
every pool's length at zero, so nothing it writes is ever read back. It is also an upper bound on
what a first parse actually faults in, because it touches the whole retained workspace and a parse
touches only the prefix it fills; the realistic figure is derived below.

The workspace under the bench limits (`tokens` and `nodes` 2^17, `depth` 512) retains 6,301,696
bytes: 2,097,152 for tokens, 4,194,304 for nodes, 8,192 for frames and 2,048 for modules.
`touch` writes to 1,539 pages of it.

### Making the memory actually cold

The first implementation was not cold. Page faults did not scale with the iteration count at all:
3,688 for the whole process at 100 iterations and 3,680 at 200. glibc raises its mmap threshold
the first time a large mapped block is freed, after which allocations of that size come from the
heap and the pages stay mapped, so every iteration after the first reused memory the kernel had
already backed. The probe now pins the threshold with `mallopt(M_MMAP_THRESHOLD, 128 KiB)` before
the timed loop of that stage, which also disables the dynamic adjustment. Both pool allocations are
far above that threshold, so each iteration maps anonymous memory the kernel has not backed and
unmaps it at the drop.

Evidence that each iteration is cold, three ways that agree:

1. `perf stat` counts 1,536.0 page faults and 1,536.0 minor faults per iteration, with a standard
   deviation of 0.0 across seven rounds, by two-point differencing (receipt
   `analysis/rel-frontend/performance-v1-prepare-touch-cold.json`).
2. The probe reads its own minor-fault count from `/proc/self/stat` around the timed loop and
   reports it: 3,145,730 faults over 2,048 iterations, which is 1,535.99 per iteration. That is an
   independent counter from an independent source and it agrees to five digits.
3. 1,536 is exactly the token pool's 512 pages plus the node pool's 1,024 pages. The frame and
   module pools are 8,192 and 2,048 bytes, below the mmap threshold, so they live in the heap and
   are already mapped — which is why 1,539 pages are written but only 1,536 fault.

Evidence that the writes are not eliminated: `Workspace::touch` is an out-of-line symbol in the
measured binary whose body is a store loop — `movups %xmm0,(%rdx)` followed by `add $0x1000,%rdx`
and a compare — one 16-byte store per 4 KiB, for each pool. Dead-code elimination would also have
removed the 1,536 faults per iteration, which are measured.

### Cost

Seven rounds, CPU 5, retained `ergodis-tools-c526b3f`, event set `instructions,cycles,branches,
page-faults,minor-faults` (receipt `performance-v1-prepare-touch-cold.json`).

| Quantity per iteration | `prepare` | `prepare-touch` |
|---|---|---|
| Minor page faults      | 0.0 ± 0.0        | 1,536.0 ± 0.0      |
| Instructions (user)    | 2,553.9 ± 11.1   | 15,703.6 ± 2.9     |
| Branches (user)        | 487.5            | 3,606.6            |
| Cycles (user)          | 712.6            | 739,819            |
| Wall, p50              | 130 ns           | 1,127,431 ns       |

Normalized: 1,127,431 nanoseconds over 6,301,696 retained bytes is **0.179 nanoseconds per
workspace byte**, or 733 nanoseconds per touched page and 734 nanoseconds per faulted page. In
instructions it is 0.0025 per workspace byte, 10.2 per touched page.

Against the other stages, on the ASCII cohort with the byte scanner: one `parse` iteration is
3,304,078 instructions and 171,018 nanoseconds, one `scan` iteration 1,899,306 instructions and
97,352 nanoseconds. So `prepare-touch` is **8,673 times `prepare` and 6.6 times one full ASCII
parse of a 43 KB source in wall time, while being 0.48 per cent of that parse in user
instructions**. Cold-start cost is almost entirely kernel-side.

That is the methodological point the stage exists to make. Every previous frontend receipt decides
on instruction counts, and on this host `perf_event_paranoid` is 2, so perf counts user-mode events
only. A stage whose cost is kernel page-fault handling is therefore nearly invisible in the metric
the lane has been using. `prepare-touch` is read from its fault count and its wall time, and the
receipt's method field now says so.

### What a real first parse pays

The full-workspace figure is an upper bound. The ASCII cohort fills 15,489 tokens (247,824 bytes,
61 pages) and 12,288 nodes (393,216 bytes, 96 pages), so a first parse on a fresh workspace faults
in about 157 pages, not 1,536. At the measured 734 nanoseconds per faulted page that is about
**115 microseconds, or two thirds of one 171-microsecond ASCII parse iteration, added to the first
parse after every fresh or resized workspace**. A server that parses one 43 KB source per fresh
workspace pays about 1.67 parses; one that reuses a workspace across 100 sources pays 1.007 parses
each. The cost is real, it is bounded by the pages a parse actually fills rather than by the
reservation, and it is charged once per workspace, not once per parse.

### A/B against the retained control, and a toolchain confound

The retained control `ergodis-tools-5e6345f` predates both new stages and cannot run either, so
`bench.py` gained `--control-skip`, and the control was measured on the operations it does have:
`prepare`, `parse` and the A/A nulls, in the same interleaved seven-round protocol
(`performance-v1-prepare-touch-scan.json`). Every A/A null instruction ratio is within 0.2 per cent
of unity with an interval containing 1.0, so the protocol is sound.

The shared build toolchain moved during this task: the control binary carries `rustc version
1.93.1` in its `.comment` section and the candidate `1.95.0`, because `nix shell nixpkgs#rustc`
now resolves to 1.95.0. The candidate-over-control instruction ratios therefore mix the compiler
change with the keyword-lookup change that is also between those two revisions. Comparing them
against the same ratios measured yesterday with a matched compiler isolates the compiler's
contribution:

| Operation                        | Keyword report, rustc 1.93.1 both arms | Today, candidate at 1.95.0 | Compiler shift |
|----------------------------------|----------------------------------------|----------------------------|----------------|
| ascii/parse/byte                 | 0.9980 [0.9957, 1.0004]                | 1.0031 [0.9953, 1.0110]    | +0.5 %         |
| ascii/parse/scalar               | 0.9803 [0.9790, 0.9816]                | 0.9964 [0.9934, 0.9993]    | +1.6 %         |
| malformed-early/parse/byte       | 0.9960 [0.9936, 0.9985]                | 1.0100 [1.0073, 1.0128]    | +1.4 %         |
| prepare                          | 1.0037 [0.9905, 1.0171]                | 0.9979 [0.9897, 1.0062]    | −0.6 %         |

rustc 1.95.0 costs the scanner about 1.4 per cent of its instructions relative to 1.93.1 on the
scan-only cohort, and about 0.5 per cent of the whole ASCII parse stage. That is the same order as
the code effects this lane has been measuring, so **the next A/B in this lane needs a control
retained with the current toolchain**; `ergodis-tools-5e6345f` is no longer toolchain-matched.
No conclusion in this report rests on a candidate-over-control ratio.

## Deliverable 2 — attribution of `lexer::scan`

### The scan boundary itself

`Workspace::scan_only_variant` and the driver's `scan` stage run UTF-8 validation and the scanner
without the parser, over the same frozen cohorts. Seven rounds, byte scanner, receipt
`analysis/rel-frontend/performance-v1-prepare-touch-scan.json`:

| Cohort          | Bytes  | Tokens | `scan` instructions | `parse` instructions | Scan as a share of parse | Scan instructions per byte | Per token |
|-----------------|-------:|-------:|--------------------:|---------------------:|-------------------------:|---------------------------:|----------:|
| ascii           | 43,008 | 15,489 |           1,899,306 |            3,304,078 |                   57.5 % |                      44.16 |     122.6 |
| unicode         | 61,888 | 15,617 |           8,023,689 |            9,437,451 |                   85.0 % |                     129.65 |     513.8 |
| comment-string  | 65,610 |  4,609 |           1,200,897 |            1,621,618 |                   74.1 % |                      18.30 |     260.6 |
| malformed-early | 42,956 | 15,463 |           1,895,145 |            1,896,345 |                   99.9 % |                      44.12 |     122.6 |
| malformed-late  | 42,935 | 15,469 |           1,896,792 |            3,301,359 |                   57.5 % |                      44.18 |     122.6 |

The malformed-early row is the check that the new stage measures what it claims: that cohort fails
on its first item, so its parse stage is already scan-only, and the two now agree to 0.06 per cent
without being the same code path. The earlier C1170 reports inferred the scanner's cost from that
cohort; it is now measured directly on every cohort.

Symbol shares of the scan stage on the ASCII cohort (`perf record -e instructions:u -F 4000`, 512
definitions, 4,000 iterations, pinned to CPU 7): `lexer::scan` 92.74 per cent, `lexer::keyword`
6.05 per cent, `core::str::converts::from_utf8` 1.11 per cent. Nothing else reaches 0.3 per cent,
so a share of the `scan` symbol converts to a share of the ASCII parse stage by multiplying by
0.533.

### Method (a): `perf annotate` by address range

`lexer::scan` compiles to about 2,200 instructions per monomorphization. The byte-scan copy was cut
into named address ranges by reading the disassembly, and the ranges are applied by the committed
`analysis/rel-frontend/scan-regions.py`. The named ranges were then checked rather than trusted:
each synthetic single-class source was profiled the same way, and a class must light up only the
ranges it can reach. It does — the whitespace source puts 100 per cent of its samples in the loop
head and the byte-class dispatch, the identifier source 38.6 per cent in the identifier
continuation loop and nothing outside the identifier ranges, the punctuation source 42.0 per cent
in the compound-spelling ladder, the string source 47.0 per cent in the string body.

Grouped, as a share of the `scan` symbol on the ASCII cohort:

| Group                                                    | Share of `scan` | Of the scan stage | Of the parse stage |
|----------------------------------------------------------|----------------:|------------------:|-------------------:|
| Identifier scanning (guard, entry, continuation loop, slice, keyword call, its token store) | 29.28 % | 27.2 % | 15.6 % |
| Operator dispatch (compound ladder, jump table, kind arms) | 21.25 % | 19.7 % | 11.3 % |
| Shared per-byte dispatch (loop head, byte-class table)     | 17.35 % | 16.1 % |  9.3 % |
| Token store, non-identifier                                | 11.78 % | 10.9 % |  6.3 % |
| Classification ladder run by every non-identifier byte     | 12.54 % | 11.6 % |  6.7 % |
| Number scanning                                            |  7.59 % |  7.0 % |  4.0 % |
| Everything else                                            |  0.21 % |  0.2 % |  0.1 % |

Two cross-checks fall out of this table. The token store appears at two sites, the identifier one
inside the identifier group and the other here; together they are 20.42 per cent of the symbol,
which is 23.2 instructions per token stored — a 16-byte token written as five stores behind a
capacity check. And the loop head plus byte-class dispatch is 13 instructions per pass, measured
independently by the pure-whitespace source at 13.45 instructions per byte; the ASCII cohort enters
that region once per token start and once per whitespace byte, 15,488 + 7,872 = 23,360 times, so it
should cost 303,680 instructions and the profile puts 17.35 per cent of 1,761,111 there, which is
305,553. Those agree to 0.6 per cent.

Skid was watched for. The instruction right after the `call` to `keyword` carries 3.51 per cent of
the symbol's samples while the `call` itself carries 0.16, which is return skid of exactly the kind
that misled the previous attribution; both are inside the identifier group above, so the grouping
does not depend on which of the two the sample landed on. The same applies at the loop back-edge,
where the `cmp`/`jb` pair and the following `movsbq` are in one group.

### Method (b): single-class synthetic sources

`ergodis-tools rel-frontend-bench --stage scan --synthetic CLASS --synthetic-unit N` builds a
source of one repeated token class at a chosen token length and a fixed total of 43,008 bytes, the
ASCII cohort's length. `analysis/rel-frontend/scan-decompose.py` measures each under `perf stat`
with the same two-point differencing, five rounds, pinned, with a three-event set that does not
multiplex (receipt `analysis/rel-frontend/performance-v1-scan-classes.json`). Two units of one
class at equal total length separate the per-token from the per-byte coefficient.

| Class                       | Instructions per token | Per body byte | Measured from                      |
|-----------------------------|-----------------------:|--------------:|------------------------------------|
| Punctuation (one byte)      |                 126.45 |             — | 43,008 `+`                         |
| Compound operator (`<=`)    |                 107.89 |             — | 21,504 `<=`                        |
| Number                      |                 106.00 |          8.45 | 3-digit and 15-digit units         |
| String                      |                  88.00 |         19.45 | 5-byte and 13-byte contents        |
| Identifier, up to 7 bytes   |                  66.25 |         11.70 | 3-letter and 7-letter names        |
| Identifier, 8 bytes or more |                  31.23 |         11.70 | 15-letter names                    |
| Whitespace                  |                      — |         13.45 | 43,008 spaces                      |

The identifier row splits at eight bytes because that is where the keyword lookup stops comparing:
a spelling longer than seven bytes is a name after one length test, and that is worth 35
instructions per identifier. It is the first direct measurement of what the keyword lookup costs,
and it agrees with the symbol share — `keyword` is 6.05 per cent of the ASCII scan stage, 114,901
instructions over 6,912 identifiers, 16.6 each averaged over a cohort whose names are mostly one to
three bytes.

Synthetic sources decompose; they make no claim about the cohorts. The claim about the cohorts is
the census. `analysis/rel-frontend/cohort-census.py` re-implements the scanner's token boundaries
over the dumped ASCII cohort source, asserting that its token count matches the scanner's 15,489
and that its class byte counts sum to 43,008, and predicts the scan stage from the counts and the
coefficients alone:

| Class                    | Tokens | Bytes  | Predicted instructions | Share of the scan stage | Of the parse stage |
|--------------------------|-------:|-------:|-----------------------:|------------------------:|-------------------:|
| Punctuation              |  7,232 |  7,232 |                914,454 |                  48.2 % |             27.7 % |
| Identifier               |  6,912 | 25,091 |                721,077 |                  38.0 % |             21.9 % |
| Whitespace               |      — |  7,872 |                105,866 |                   5.6 % |              3.2 % |
| Number                   |    832 |  1,469 |                100,604 |                   5.3 % |              3.0 % |
| Compound operator        |    512 |  1,344 |                 55,241 |                   2.9 % |              1.7 % |
| String                   |      0 |      0 |                      0 |                       — |                  — |
| **Predicted total**      | 15,488 | 43,008 |          **1,897,242** |                         |                    |
| **Measured scan stage**  |        |        |          **1,899,194** |                         |                    |

The prediction is 0.10 per cent below the measurement. It is out of sample with respect to the
source — the coefficients come from synthetic text and are applied to a cohort of real Rel-shaped
definitions — and it accounts for the whole scanner rather than for its hot symbols only.

### The two methods reconciled

Method (b) gives class shares directly from counters; method (a) gives them only by deconvolving
the ASCII region profile over the six per-class region profiles, which is what
`scan-regions.py` does when handed all seven annotations. The two:

| Class                | Method (b), counters | Method (a), profile deconvolution |
|----------------------|---------------------:|----------------------------------:|
| Identifier           |               38.0 % |                            43.5 % |
| Punctuation          |               48.2 % |                            19.9 % |
| Compound operator    |                2.9 % |                            25.3 % |
| Punctuation family   |           **51.1 %** |                        **45.2 %** |
| Number               |                5.3 % |                             7.3 % |
| Whitespace           |                5.6 % |                             5.3 % |
| String               |                    — |                            −1.3 % |

They agree on whitespace to within 0.3 points, on number to within 2 points, on the identifier
share to within 5.5 points and on the punctuation family to within 6 points. They do not agree on
the split of that family, and cannot: the punctuation and compound-operator profiles run the same
regions — the classification ladder, the compound ladder and the same token store — so the basis is
collinear there and the least-squares split between those two columns is not identified. The
counter method has no such problem because it measures the two sources separately. Where the
methods are both identified they agree, and the negative string weight (−1.3 points on a 100-point
profile) sizes the fit's noise.

The residual disagreement on identifier and punctuation has a known cause: the synthetic
identifier profile used 7-letter names while the cohort's are mostly one to three bytes, so its
region mix within the identifier class is not the cohort's, and the synthetic punctuation source is
all `+`, which fails all eight compound spellings, while the cohort's operator mix exits the ladder
at different points. The deconvolution inherits that; the counter coefficients do not, because they
are applied through the cohort's own census.

### Which sub-component would justify an optimization candidate

Punctuation. One single-byte operator or delimiter costs 126 instructions, twice a short
identifier's 101 and nine times a whitespace byte's 13, and the ASCII cohort has more punctuation
tokens (7,232) than identifiers (6,912). Both methods put the punctuation family near half of the
scanner, which is between a quarter and 30 per cent of the whole ASCII parse stage.

The reason is structural and visible in the source. The byte-dispatch fast path in
`src/rel_frontend/lexer.rs` handles exactly two classes, whitespace and identifiers. Every other
byte falls through to the shared scalar logic and re-runs, in order: `character()`,
`c.is_whitespace()`, `starts_with("//")`, `starts_with("/*")`, `starts_with("raw\"")`, the quote
tests, `start(c)`, the digit test, then a linear scan of eight compound spellings, and only then the
`match c` that assigns the kind. The profile prices that ladder at 12.54 per cent of the symbol
before the compound scan, and the compound scan itself at another 9.61 per cent.

Fermi estimate for a punctuation fast path — a `PUNCT` bit in the existing 128-entry class table, a
byte-to-`Kind` table, and a first-byte-indexed compound table replacing the linear scan. From
method (a): it removes the classification ladder (12.54) and most of the compound ladder (say 8 of
9.61) and part of the jump table and kind arms (say 4 of 11.64), which is 24.5 per cent of the
`scan` symbol, 22.7 per cent of the scan stage, **13.1 per cent of the ASCII parse stage**. From
method (b): a table-dispatched punctuation token would cost roughly the 13-instruction byte
dispatch, two table loads, a compound check and the 23-instruction token store, call it 46 against
126, saving 80 per token over 7,232 tokens plus about 58 over 512 compound tokens, which is 608,000
instructions, 32 per cent of the scan stage, **18.4 per cent of the parse stage**. The two
estimates bracket the answer: **10 to 18 per cent of the ASCII parse stage, centred near 14**. On
the Unicode cohort the same change buys much less, since 85 per cent of that cohort's parse stage is
scanning but its cost is dominated by the non-ASCII decode paths the table cannot serve.

Nothing was implemented here. Two smaller items found while reading the same code are recorded as
next steps rather than taken: for an ASCII byte, `c.is_whitespace()` and `start(c)` on the
fall-through path are provably redundant, because the class table has already answered both
questions, and they are 4.16 and about 2 per cent of the symbol.

## Gates and replay

All gates pass. Run from `~/src/ergodis-private`.

| Gate | Command | Outcome |
|---|---|---|
| Frontend tests | `nix shell nixpkgs#rustc nixpkgs#cargo -c cargo test -p ergodis-private --test rel_frontend -j 8` | 19 passed, 0 failed |
| Clippy, library and test target | `nix shell nixpkgs#rustc nixpkgs#cargo nixpkgs#clippy -c cargo clippy -p ergodis-private --lib --test rel_frontend -j 8 -- -D warnings` | no diagnostics |
| Clippy, tools binary | `nix shell nixpkgs#rustc nixpkgs#cargo nixpkgs#clippy -c cargo clippy -p ergodis-tools --bins -j 8 -- -D warnings` | no diagnostics |
| Formatting | `nix shell nixpkgs#rustfmt -c rustfmt --check --edition 2021 src/rel_frontend/mod.rs src/rel_frontend/parser.rs tasks/tools/src/rel_frontend_bench.rs` | one pre-existing diff at `parser.rs:634`, present in the file at `HEAD` before this work and not touched |
| Native/WASM parity replay | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json` | 151 cases, 335,671 canonical bytes, byte-equal, canonical SHA-256 `5f707d3737b32071e0bebfca304ff1a5e2902fa0152937ddada60bd5aa194cc8` unchanged |

The parity receipt was regenerated because `Workspace::touch` and `scan_only_variant` changed the
recorded source hashes of `src/rel_frontend/mod.rs` and `src/rel_frontend/parser.rs`. The canonical
output hash is identical, which is the statement that neither addition changed what the frontend
accepts or produces. The three allocation regressions inside `tests/rel_frontend.rs` still assert
zero allocations and still pass; `touch` writes only into capacity that `Workspace::new` already
reserved and never grows a pool.

Measurement replay, in order:

```sh
../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools
python3 analysis/rel-frontend/bench.py --binary "$CANDIDATE" --control "$CONTROL" \
    --control-skip prepare-touch,scan --representation-change "<reason>" \
    --rounds 7 --cpu 5 --stages scan,parse,prepare-touch \
    --out analysis/rel-frontend/performance-v1-prepare-touch-scan.json
python3 analysis/rel-frontend/bench.py --binary "$CANDIDATE" --rounds 7 --cpu 5 \
    --cohorts ascii --stages prepare-touch \
    --events instructions,cycles,branches,page-faults,minor-faults \
    --out analysis/rel-frontend/performance-v1-prepare-touch-cold.json
python3 analysis/rel-frontend/scan-decompose.py --binary "$CANDIDATE" --rounds 5 --cpu 5 \
    --out analysis/rel-frontend/performance-v1-scan-classes.json
"$CANDIDATE" rel-frontend-bench --cohort ascii --stage scan --repeat 1 --dump-source ascii.txt
python3 analysis/rel-frontend/cohort-census.py ascii.txt \
    --classes analysis/rel-frontend/performance-v1-scan-classes.json --measured 1899194
```

`$CONTROL` is the retained `ergodis-tools-5e6345f`; the `--representation-change` reason is that
the control predates the reserved-word change that renumbered the custom-operator kinds, and the
driver still requires equal token counts, equal node counts and identical failures. The profile
commands are in the docstring of `analysis/rel-frontend/scan-regions.py`.

## Instruction profile

`perf record -e instructions:u -F 4000`, ASCII cohort, byte scanner, 512 definitions, pinned to
CPU 7, binary `ergodis-tools-c526b3f`. Two profiles were taken: the parse stage at 2,000 iterations
for comparability with the earlier reports, and the scan stage at 4,000 iterations, which runs
nothing but the scanner.

| Symbol                                     | Parse stage | Scan stage | Keyword report, parse stage |
|--------------------------------------------|-------------|------------|-----------------------------|
| `rel_frontend::lexer::scan`                | 51.96 %     | 92.74 %    | 52.39 %                     |
| `rel_frontend::parser::Parser::expression` | 39.29 %     | —          | 39.79 %                     |
| `rel_frontend::lexer::keyword`             |  4.84 %     |  6.05 %    |  3.36 %                     |
| `rel_frontend::parser::Parser::item`       |  2.03 %     | —          |  1.93 %                     |
| `rel_frontend::parser::Parser::node`       |  0.88 %     | —          |  1.53 %                     |
| `core::str::converts::from_utf8`           |  0.46 %     |  1.11 %    |  0.63 %                     |

The parse-stage column reproduces yesterday's profile of the same source at a different compiler
version to within half a point on the two large symbols. `lexer::keyword` moved by 1.5 points,
which is the same direction and about the same size as the compiler shift the A/B measured on the
scan-only cohort. The scan-stage column is what makes the symbol-to-stage conversion in the
attribution above exact rather than assumed: the scanner's three symbols are the whole scan stage.

Two absolute figures the scan boundary now yields directly, which the earlier reports could only
infer:

- The parser is `parse` minus `scan` = 1,404,772 instructions per ASCII iteration, 32.7 per source
  byte, 42.5 per cent of the parse stage. The Pratt-loop report estimated 30.3 per byte from the
  profile; the measured value is 32.7.
- UTF-8 validation is 1.11 per cent of the scan stage, 21,081 instructions for 43,008 bytes, 0.49
  per byte. It is not a candidate.

## Disposition

Both deliverables are measurement, and neither produced or proposed an implemented change. The
`prepare-touch` stage, the `scan` stage, the synthetic decomposition sources, `Workspace::touch`
and `Workspace::scan_only_variant` are kept: they are instrumentation, they are not on the parse
path, and the A/A nulls and the malformed-early control show they do not perturb what was already
being measured.

The attribution names one optimization candidate for a future task — a punctuation fast path in the
byte-dispatch scanner — at an estimated 10 to 18 per cent of the ASCII parse stage, and two smaller
redundancy removals at about 3 per cent between them. None was implemented, as the task required.

The cold-start measurement changes what the lane should believe about `prepare`. The stage that has
been reported at 2,546 instructions and 130 nanoseconds since the first receipt does not represent
starting from a fresh workspace, and starting from a fresh workspace costs 1.13 milliseconds under
the bench limits, which is 6.6 ASCII parses. Under the library's own `Limits::default` — 2^18
tokens and 2^19 nodes, 20,981,760 retained bytes, 5,123 pages — the same arithmetic gives about
3.8 milliseconds. That is a product-shaped fact, not a benchmark artifact: a frontend that prepares
a default workspace per request pays several milliseconds of kernel time before it scans a byte,
while a 43 KB source only ever touches 157 of those pages.

## Mystery ledger

1. **Settled.** `lexer::scan` at 52 per cent of the ASCII parse stage was unattributed below the
   symbol; that was the open item carried from the keyword-lookup report. It is now attributed by
   two independent methods that agree where both are identified, and the class model predicts the
   cohort's whole scan cost to 0.10 per cent. Punctuation dispatch, not identifier scanning, is the
   largest component.
2. **Settled.** `prepare` could not represent first-use cost, open since the first C1170
   measurement report. The cost is 1,536 minor faults and 1.13 milliseconds per fresh workspace,
   about 115 microseconds for the pages a 43 KB parse actually fills, and it is invisible to the
   instruction metric because the host counts user events only.
3. **Settled, and it invalidates a method assumption.** The six-event set every previous frontend
   receipt used multiplexes at about 83 per cent enabled on this host. That is immaterial for
   operations retiring millions of instructions — the A/A nulls stay within 0.2 per cent — and
   fatal for one retiring thousands: `prepare-touch` measured 12,629 ± 3,754 instructions under the
   six events and 15,703.6 ± 2.9 under five. Earlier receipts are unaffected in their conclusions,
   but no future small-operation measurement should use the default set.
4. **Open.** Whether the class decomposition's 0.10 per cent agreement is exact or the sum of
   compensating errors between punctuation and identifier. The profile deconvolution bounds any
   compensation at about 6 points on the punctuation family and 5.5 on identifiers, but it cannot
   separate punctuation from compound operators because those two run the same regions. The
   evidence gap is an out-of-sample cohort: predicting the comment-string cohort would test the
   model against different classes, and that needs a `comment` synthetic class, which does not
   exist. Owner: whoever takes the punctuation fast path, since they need the baseline anyway.
5. **Open.** A minor fault on this host costs about 734 nanoseconds, roughly 2,200 cycles at
   3 GHz, for a 4 KiB anonymous page. Zeroing 4 KiB at a plausible 10 GB/s is about 400
   nanoseconds of that, leaving about 330 per fault for entry, allocation, page-table update and
   return. If that split is right, backing the pools with 2 MiB pages would cut 1,536 faults to
   three and remove the per-fault half, taking cold start from 1.13 milliseconds to roughly 0.6.
   Transparent huge pages are set to `madvise` on this host, so a plain anonymous mapping does not
   get them and the question is untested. The evidence gap is one A/B of the same stage with
   `madvise(MADV_HUGEPAGE)` on the pools.
6. **Open, provenance.** `~/.cache/ergodis/bin/MANIFEST.tsv` records the control
   `ergodis-tools-5e6345f` as `dirty`, while the keyword-lookup report describes it as built from a
   tree with no foreign uncommitted files. The retain script's dirty flag is repository-wide and
   includes untracked files, so the two statements can both be true of different moments, but the
   manifest row is the durable record and it says `dirty`. Nothing in this report rests on that
   control.
7. **Not a mystery, stated for the record.** The toolchain moved from rustc 1.93.1 to 1.95.0 under
   the shared target directory during this task, worth about 1.4 per cent of the scanner's
   instructions and 0.5 per cent of the ASCII parse stage. It is fully explained and it is recorded
   here because it silently confounds any A/B against a control retained before today.

## Remaining next steps

1. **Punctuation fast path in the byte-dispatch scanner.** A `PUNCT` bit in the existing 128-entry
   class table, a byte-to-`Kind` table for the single-byte operators and delimiters, and a
   first-byte-indexed replacement for the linear scan of eight compound spellings. Estimated 10 to
   18 per cent of the ASCII parse stage. This needs a control retained with the current toolchain
   before it starts.
2. **Remove the two redundant re-tests on the fall-through path.** For an ASCII byte that reached
   the shared scalar logic in the byte-dispatch variant, `c.is_whitespace()` and `start(c)` are
   provably false — the class table's whitespace and identifier-start bits are exactly those
   predicates over ASCII — and the digit test is likewise answerable from the continuation bit.
   They are 4.16 and about 2 per cent of the `scan` symbol, so about 3 per cent of the parse stage
   for a few lines. It is small enough to fold into the punctuation fast path rather than spend a
   separate A/B on.
3. **Size the workspace to the source.** `Limits::default` reserves 21 MB whatever the input, and
   the cold-start measurement prices that at about 3.8 milliseconds of first-touch. A 43 KB source
   fills 157 pages. Deriving the token and node reservations from the source length, or touching
   lazily, is a larger design question than a performance tweak and should be raised before it is
   built.
4. **The token store is the second candidate.** It is 20.4 per cent of the `scan` symbol, 23.2
   instructions per token, a 16-byte record written as five stores behind a capacity check. Whether
   assembling the token in registers and storing it once is faster is a question for a measured
   A/B, not an assumption.
5. **Retain a control with the current toolchain** before any further A/B in this lane, and record
   its rustc version in the report as well as the manifest.
6. The syntax and admission items from the keyword-lookup report are unchanged: caret entity
   references, string interpolation, reference Unicode boundary conformance, then the first
   semantic admission checks.

No backend or evaluator was adopted in this work and nothing was published.
