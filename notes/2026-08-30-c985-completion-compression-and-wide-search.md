# C985 completion compression and wide-search optimization

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Outcome

Ergodis now compiles large CSS completion filters from exact bounded-multiplicity
syndrome types, abandons saturated optional filters before enumerating them,
chooses the Bloom hash count from the actual load, and executes the wide
syndrome-packing lower bound as target-specialized vector code.  The search
changes remain iterative and allocation-free in the candidate loop.

On clean, exclusive-host measurements, relative to the last retained binaries:

| workload | control | current | ratio | paired statistic |
| --- | ---: | ---: | ---: | ---: |
| BB756 cold compile | 1.541400 s | 0.458666 s | 3.361x | `t=111.98`, `n=10` |
| R2Elite01 cold compile | 14.815750 s | 0.031118 s | 476.1x | `t=231.23`, `n=3` |
| BB288 warm radius-14 search | 56.776797 ms | 42.248477 ms | 1.344x | `t=24.74`, 10 paired 10-round batches |
| BB756 warm radius-22 search | 40.173958 s | 27.510653 s | 1.460x | `t=12.29`, `n=5` |
| R2Elite02 Z exact search | 77.180608 s | 55.559994 s | 1.389x | `t=42.23`, `n=3` |

R2Elite01 peak RSS for cold compilation fell from 36,944 to 22,520 KiB,
1.64x lower.  BB756 search RSS remains about 24 MiB.  The R2Elite02 current
binary uses about 0.7 MiB more RSS than its control, consistent with the larger
target-specialized text, while retaining roughly 39 MiB total RSS.

These are same-host, alternating A/B results taken after the user reported the
machine exclusively available.  Earlier shared-host probes remain diagnostic
only.

## Exact reductions

### Bounded multiplicity quotient

For completion arity `k`, no subset consumes more than `k` columns of one
projected syndrome type.  The compiler therefore sorts projected column keys,
retains one unique-key array, and caps each type's multiplicity at three or
four before enumerating the corresponding filter.  This preserves every
possible subset XOR through the retained arity exactly while replacing
syntactic columns by their observable type and required multiplicity.

The implementation projects each input column once, pre-sizes the work arrays,
uses iterative loops, and performs no allocation inside a combination loop.
An exhaustive repeated-type test compares exact one/two tables and triple/four
Bloom inclusion against brute subset XORs.

### Saturated filters

A triple filter whose enumeration exceeds 100 million keys is replaced by a
universal filter.  This cannot create a false negative: it only declines an
optional rejection.  For R2Elite01 the former 557-million-key insertion would
put three hashes into a fixed `2^27`-bit table at a load where the false-positive
probability is effectively one.  Omitting the work is therefore both exact and
practically lossless.

At lower high loads, the compiler chooses one Bloom hash when the table has
fewer than three bits per inserted item.  One hash then has both lower expected
false-positive probability and lower insertion/query cost than three hashes.
The artifact flags byte records this mode without changing the payload format;
old artifacts continue to mean three hashes.  A round-trip test checks the new
flag and exact search replay.

## Wide lower-bound theorem and implementation

If every kernel word has even weight, a completion must have a fixed parity.
For budget `b` and required parity `p`, the largest admissible lower bound is

\[
 b-((b\mathbin{\mathsf{xor}}p)\mathbin{\&}1).
\]

The degree and disjoint-neighborhood packing bounds can compare directly with
this value.  Packing now exits as soon as its monotone count exceeds it rather
than completing the greedy scan and parity-rounding afterward.

Within the packing scan, conflict masks only delete syndrome bits.  A single
forward word pass is therefore exact; rescanning the already-empty word prefix
after each selected check was redundant.  The selected check is contained in
its own conflict mask, so the separate clear of that bit was redundant too.

Two target-specialization pathologies were then visible in disassembly:

1. the 74%-hot completion bound was out of line and compiled without hardware
   `popcnt`, expanding six popcounts into SWAR sequences;
2. the 70%-hot residual packing helper was out of line and updated six-word
   masks in baseline-width chunks rather than inside the AVX2 kernel.

Forcing both compact helpers into the multiversioned search kernel removed
those misses.  Finally, greedy packing is admitted only when the cheap degree
bound lies within six of the parity-compatible cutoff.  Skipping an optional
lower bound can add nodes but cannot lose a valid solution or make an invalid
prune.  Margins two and four were rejected: two slowed BB288 after adding 35%
more candidates; four added 8.7% BB756 candidates for neutral time.  Margin six
adds only 177,198 BB756 candidates out of 7.565 billion and gives a clean
1.048x slice (`t=5.16`, ten pairs).

## Counter evidence

The combined BB756 warm-search change, from `5639c5525` to `b5583dab6`, has
the following clean one-pair counters:

| counter | control | current | change |
| --- | ---: | ---: | ---: |
| instructions | 5,302,028,918,065 | 2,417,974,456,750 | -54.4% |
| cycles | 1,900,266,274,096 | 1,326,784,495,971 | -30.2% |
| branches | 537,057,908,610 | 359,908,556,052 | -33.0% |
| branch misses | 18,905,663,093 | 19,577,667,350 | +3.6% |
| cache references | 11,802,097,394 | 11,714,811,506 | -0.7% |
| cache misses | 14,437,330 | 13,540,113 | -6.2% |

The modest branch-miss increase is outweighed by removing 2.88 trillion
instructions.  Peak memory is not the limiting resource; this remains an
instruction- and dependency-bound search.

## Application impact

BB288 retains exactly 2,121,448 candidates and 1,656,674 syndrome-bound
prunes.  BB756 changes from 7,564,783,829 to 7,564,961,027 candidates because
of packing admission, with the same no-word-through-radius-22 result.
R2Elite02 changes from 11,646,272,316 to 11,643,908,554 candidates and returns
the same exact distance 16.  Thus the work improves both earlier small and
large applications rather than only the new compilation benchmark.

## Validation and provenance

Every landed slice passed:

- `cargo clippy --all-targets --all-features -- -D warnings`;
- the full `cargo test --all-features` suite;
- exhaustive/differential small-instance checks already in the CSS backend;
- source-bound artifact replay;
- exact candidate/result comparison on the benchmark controls.

Heavy commands ran under `choom -n 1000`; build products and raw measurements
live under `/home/tavis/.cache/ergodis`, not tmpfs.  Clean A/B records are in
`/home/tavis/.cache/ergodis/c985-clean-ab`.

Landed commits, in order:

- `3dd09b795` bounded-multiplicity completion keys;
- `4819bd18a` saturated triple-filter cutoff;
- `5639c5525` adaptive Bloom hash count;
- `0a9a84393` monotone parity-aware packing;
- `cbff76ace` hardware-popcount specialization;
- `ba0fdf9b7` vectorized packing specialization;
- `b5583dab6` measured packing admission.

## Remaining performance frontier

No equally obvious hardware miss remains.  The dominant operation is now the
actual conflict-mask packing itself.  The next credible implementation target
is incremental sparse syndrome weight for low-column-degree codes: carry the
weight in each iterative frame and update it from precomputed check indices,
avoiding six or more popcounts per candidate.  It needs a dense fallback,
small-path neutrality, artifact reconstruction rather than duplication, and a
measured admission rule before landing.

