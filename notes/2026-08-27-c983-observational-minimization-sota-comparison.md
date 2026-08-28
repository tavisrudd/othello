# C983 observational minimization: SOTA comparison

**Date:** 2026-08-27
**Lane:** `complete-ports`
**Full-text sources read:** 1. Two further papers were read selectively, and
three maintained implementations were inspected at pinned revisions. This is
an algorithm/implementation comparison, not a literature-wide priority claim.

## Bottom line

Ergodis now belongs in the same practical performance class as a strong
specialized DFA minimizer on the deterministic finite subcase we can compare
exactly. After repairing one quadratic block-splitting pathology, it is about
2x faster than MATA's current C++ Hopcroft/Valmari-style implementation at
131,072 states on both a unary distinguishing chain and a four-generator
deterministic random family. It also uses about 12--17x less peak RSS in these
runs. This is a strong result because ergodis additionally emits a compact
split transcript and verifies it before returning, whereas MATA returns only
the minimized automaton.

This does **not** yet establish that ergodis is the universally fastest
minimizer. The defensible comparison has three different frontiers:

| Frontier | Best relevant algorithm/tool found | Relation to ergodis |
|---|---|---|
| Deterministic finite machines | Hopcroft/Valmari--Lehtinen style refinement; MATA `minimize_hopcroft` | Closest direct speed comparison, but MATA has only Boolean final-state observations and no typed sorts or proof transcript |
| General labelled transition systems, including internal actions | Groote--Jansen 2025, `O(m log n)`; the default kernel in mCRL2 202607 | Strictly broader operational semantics than the current deterministic ergodis kernel, but not a direct performance comparator |
| Generic system types | Jacobs--Wißmann/Boa 2023 for computable Set functors, `O(k m log n)` in the usual bounded-outdegree instances | Closest architectural comparator for cross-domain adapters; broader genericity, but no contextual witness/proof contract like ergodis |

The immediate theoretical position is therefore: ergodis is a specialized,
many-sorted, output-initialized strong-bisimulation/DFA refinement kernel with
extra proof and witness infrastructure. Its implementation now uses the
refinable-partition operation needed by the classical `O(m log n)` line, but a
formal complexity proof for the exact typed scheduler and its remaining dense
pending representation is still owed.

## What the current SOTA is

### Published general LTS algorithm

Groote and Jansen's CONCUR 2025 state-based algorithm is the newest published
implementation result found for the broader branching-bisimulation problem.
It runs in `O(m log n)`, avoids partitioning the transition set, and uses a
four-way state-block split to isolate new bottom states. Their matched-style
benchmarks report that it is usually faster and smaller than the previous
best JGKW implementation, with up to roughly 4x time and 40% memory reductions
on their suite. The implementation is in mCRL2; at revision
`0fc9c22820894f8d769c15174795ab0542f1ad4d` and release 202607.0,
`lts_eq_bisim` dispatches to `bisimulation_reduce_gj`.

For ergodis' current deterministic, total, no-internal-action kernel, this
algorithm is broader than necessary. Its important lesson is architectural:
keep blocks as contiguous slices, preserve the largest part's identity, and
touch only the smaller parts.

### Specialized deterministic implementation

MATA is a maintained C++20 automata library whose 2024 report benchmarks the
library broadly against AutomataLib, Awali, Brics, FAdo, Vata, and others.
Its current `minimize_hopcroft` implementation is based on refinable state and
transition partitions and cites Valmari--Lehtinen's partial-DFA algorithm.
The implementation stores block members contiguously, records every element's
position, and moves marked elements to the partition boundary in constant
time. Revision tested:
`e8c9310e389b1e62ece7080956550f70ceeed777`.

MATA is the fairest direct implementation comparator found because it exposes
a library-level deterministic minimizer rather than requiring file conversion
through a model-checking tool. Its semantics are narrower: one state sort,
Boolean accepting output, and no evidence artifact.

### Generic cross-domain implementation

Boa is the strongest missed comparator for the proposed expansion of ergodis.
It minimizes coalgebras for arbitrary computable Set functors using a generic
dirty-state/signature algorithm. Users can compose built-in functors or add a
small Rust implementation of the functor action. It makes
`O(m log n)` functor-action calls and typically takes `O(k m log n)` time,
trading an extra outdegree factor for much lower auxiliary memory and greater
generality. Its paper reports large wins over CoPaR/DCPR and its then-current
mCRL2 strong-bisimulation implementation. Current repository head inspected:
`54a556448169a83a369e039b5fa3ba27323ccfde`.

Boa validates that a generic, cross-domain minimization compiler can be fast
and memory-lean. Ergodis' differentiators are elsewhere: mathematically
derived contextual interfaces, many-sorted typed generators, canonical
quotients, replayable split evidence, explicit separating contexts, and
concrete witness lifting. Boa is therefore both prior art and a useful
stepping stone, not a reason to abandon the path.

## Direct benchmark

### Method

- CPU: AMD Ryzen AI 9 HX 370; both executables pinned to logical CPU 2.
- Ergodis: Nix Rust release build from the current C983 worktree.
- MATA: GCC 14.3 `-O3 -DNDEBUG`, C++20, revision above.
- Each timing is internal library time after input construction.
- Seven process-level rounds were interleaved A/B; order alternated each
  round. The table reports the median of per-operation times.
- `chain`: one generator `i -> min(i+1,n-1)`; only the last state has output 1.
- `random-4`: generator zero is the same chain, ensuring every state is
  reachable and coaccessible for MATA's trimmed-DFA precondition; three more
  generators use the same deterministic xorshift sequence in both drivers.
- Both families minimize to 131,072 classes.
- Ergodis uses `SplitTranscript`, builds the quotient, retains 131,070 split
  records, and runs its independent verifier before returning. MATA builds
  its minimized automaton without a proof transcript.
- The retained drivers are
  `ergodis/examples/observational_sota_driver.rs` and
  `ergodis/benches/mata_observational_driver.cc`; the latter records the exact
  MATA revision against which it was compiled.

| Family, `n=131,072` | Ergodis median | MATA median | Ergodis speedup |
|---|---:|---:|---:|
| Unary chain | 10.031 ms | 21.071 ms | 2.10x |
| Random, four generators | 100.720 ms | 205.127 ms | 2.04x |

Peak RSS was measured separately with `/usr/bin/time -v` around one cold
process. It includes each executable's input and runtime footprint and is less
stable than the interleaved time result, so it is evidence of scale rather
than a precise allocator decomposition.

| Family, `n=131,072` | Ergodis RSS | MATA RSS | Ratio |
|---|---:|---:|---:|
| Unary chain | 12.604 MB | 213.936 MB | 17.0x smaller |
| Random, four generators | 23.740 MB | 279.988 MB | 11.8x smaller |

The likely memory explanation is visible in the sources: ergodis uses flat
`u32` pools, compact bitmaps, and fixed-width records; MATA uses `size_t`
partition metadata and a `vector<vector<size_t>>` incoming-transition index,
which pays per-state allocation and container overhead. This is an inference
from the inspected implementations, not a measured byte attribution.

## Pathology found and repaired

The first comparison exposed a false small-half implementation. Although the
worklist chose the smaller splitter, `split_marked_block` scanned the entire
source block to partition marked from unmarked states. Repeated singleton
splits on the chain therefore took quadratic work. At 131,072 states the cold
run took 3.834 s.

The repair adds one flat `u32` member-position array and one flat per-block
marked-count array. After the inverse image is completely enumerated, each
marked source is swapped exactly once to the end of its current contiguous
block. The splitter range remains immutable during enumeration, avoiding a
self-split corruption hazard. The same cold case now takes 14.126 ms, a
271x reduction, while preserving:

- no allocation in the refinement loop;
- contiguous `u32` state/member/position pools;
- fixed-width `repr(C)` work and transcript records;
- iterative execution with no scaling-sensitive recursion; and
- exact transcript and quotient parity on the bounded cyclic and typed corpus.

The large-chain curve after the repair is 0.104, 0.220, 0.453, 0.862, 1.766,
and 13.997 ms for 1K, 2K, 4K, 8K, 16K, and 128K states respectively. This is
consistent with the intended near-linear behavior on this family; it is not
presented as a proof of the worst-case bound.

## Hardware profile and next scaling move

At 1,048,576 states and four generators, three `perf stat -d` runs gave median
internal times of about 2.10 s for ergodis and 2.61 s for MATA. The counters
were multiplexed at roughly 43%, so their absolute values are directional:

| Counter | Ergodis | MATA |
|---|---:|---:|
| Instructions | 13.27 B | 10.34 B |
| Cycles | 10.26 B | 13.95 B |
| IPC | 1.3 | 0.7 |
| L1D miss rate | 2.9% | 3.2% |
| Page faults | 70,359 | 553,903 |

Ergodis wins through locality and compact representation, not lower
instruction count. A sampled profile of the same ergodis random case attributes
about 47% to compilation/refinement, 16% to independent split-transcript
verification, and 15% to inverse-index sorting. Within refinement,
`bitmap_contains` is the largest inlined leaf. The one-generator chain shifts
more weight to verifier replay and inverse lookup.

The profile-justified adaptive inverse construction is now implemented:

1. use stable counting scatter when the target range is comparable to the
   source range;
2. retain sorted sparse construction when the target range is much larger;
3. reuse one source permutation and one in-place count/cursor array across
   generators; and
4. allocate nothing in the construction inner loops or refinement loop.

Seven interleaved old/new rounds on the 1,048,576-state, four-generator random
case give medians of 2.065 s and 1.760 s for the complete compiler, including
proof emission and independent replay.  This is 14.8% less time, or 1.17x
throughput.  Five non-multiplexed hardware-counter runs show the mechanism:

| Counter | sorted inverse | adaptive scatter | delta |
|---|---:|---:|---:|
| Instructions | 13.149 B | 6.101 B | -53.6% |
| Branches | 2.542 B | 1.275 B | -49.8% |
| Branch misses | 25.599 M | 21.579 M | -15.7% |
| Cycles | 10.020 B | 8.826 B | -11.9% |

Cold peak RSS on the random case is unchanged within noise at about 178.4 MiB.
The one-generator million-state chain is time-neutral and adds about 4 MiB for
the reusable target cursor array. Replacing bitmaps with byte or epoch arrays
is not yet justified: it would expand the large state and the profile does not
identify which bitmap role would repay that memory traffic. SIMD is likewise
not the first move; the remaining cost is indexed partition bookkeeping and
irregular inverse traversal, not a wide arithmetic kernel.

## Native-output reduction control

The retained executable harness also defines a `colors` family to test a
legitimate product-level advantage rather than another Boolean-DFA race.  On
`n` states with `k | n` observations, state `i` has observation `i mod k` and
generator `g` cyclically shifts by `g+1`.  The exact observational quotient has
`k` classes.  Ergodis consumes that Moore output directly.  The MATA driver
uses an equivalent deterministic Boolean-language encoding: state `i` has one
transition labelled `generators + (i mod k)` to a fresh accepting sink.  Thus
its minimized DFA has `k+1` states, with the extra state being the encoding
sink rather than a semantic disagreement.

The checked Rust control at `n=131,072`, four generators, and `k=256` returns
256 classes and an empty split transcript because the supplied observation
partition is already stable.  Two smoke invocations reported 31--40 ms; these
are functional checks, not an interleaved measurement.  The matching MATA
dependency was not present in the current environment, so no
cross-tool timing is claimed.  The new `scripts/observational-sota-ab.sh`
driver runs seven alternating process-level rounds for `chain`, `random`, and
`colors`, pins both binaries to the same CPU, and emits raw TSV for a later
median/RSS analysis.

This family is useful precisely because it exposes a representational
difference: a native finite observation partition can finish at initialization,
whereas a Boolean-acceptance-only API must encode and rediscover it through
transitions.  It must be labelled a native-output/product comparison, not
evidence that ergodis has a universally faster Boolean-DFA minimizer.

## Gaps before a stronger SOTA claim

- Add Boa to the executable harness on its native deterministic functor, and
  add mCRL2 GJ25 on native LTS inputs. Tool/file parsing must be reported
  separately from kernel time.
- Use several reduction ratios, sparse/partial transitions, many labels,
  multiple sorts, and severely imbalanced source/target sorts. The current
  direct corpus intentionally isolates two fully separated deterministic
  cases.
- Measure peak live allocation by stage, not just process RSS.
- Prove the exact typed worklist bound, including the remaining target-dense
  pending scheduler, or replace that scheduler with a fixed-capacity sparse
  directory before claiming edge-linear auxiliary space.
- Compare proof products explicitly. None of the reference implementations
  inspected emits ergodis' replayable split transcript plus contextual witness
  hooks, so quotient-only timing is not the complete product comparison.

## Source audit

1. **Groote and Jansen, “A State-Based O(m log n) Partitioning Algorithm for
   Branching Bisimilarity,” CONCUR 2025.** Read depth: full text, all 16 pages.
   Cached key `10.4230/LIPIcs.CONCUR.2025.18`, SHA-256
   `d160c057a698d1a67b108ad7842ccca857a13618e8ab266cb87699927829de97`.
   Primary open-access paper:
   <https://doi.org/10.4230/LIPIcs.CONCUR.2025.18>.
2. **Jacobs and Wißmann, “Fast Coalgebraic Bisimilarity Minimization,” POPL
   2023.** Read depth: selective full-text sections covering motivation,
   algorithm sketch, complexity comparison, implementation, benchmarks, and
   conclusion; not read cover-to-cover. Cached key `arXiv:2204.12368`, SHA-256
   `18f32e8bc928a77537c24d643a73db645bf0fbeb02fa3006c4bac0b5d727cf57`.
   Primary paper: <https://doi.org/10.1145/3571245>.
3. **Chocholatý et al., “Mata: A Fast and Simple Finite Automata Library,”
   TACAS 2024.** Read depth: selective full-text sections on representation,
   related libraries, and benchmark scope; minimizer behavior was checked in
   source rather than inferred from the paper's broad library benchmarks.
   Cached key `arXiv:2310.10136`, SHA-256
   `dad765136475767496cbca316b9250e46892628e62c13266ee6c6ac3fb29c519`.
   Primary preprint: <https://arxiv.org/abs/2310.10136>.
4. **Valmari, “Simple Bisimilarity Minimization in O(m log n) Time,” 2010.**
   Read depth: abstract/metadata only; the publisher denied PDF retrieval.
   Used only for its stated bound and transition-partition contribution:
   <https://doi.org/10.3233/FI-2010-369>.
5. **mCRL2 source and documentation.** Read depth: targeted implementation and
   dispatch inspection of `liblts_bisim_gj.h`, `lts_algorithm.h`, and
   `lts_equivalence.h`; official revision
   `0fc9c22820894f8d769c15174795ab0542f1ad4d`, release 202607.0.
   Repository: <https://github.com/mCRL2org/mCRL2>.
6. **MATA source.** Read depth: targeted full implementation inspection of
   `RefinablePartition` and `minimize_hopcroft`, plus build and execution of the
   pinned source; official revision
   `e8c9310e389b1e62ece7080956550f70ceeed777`.
   Repository: <https://github.com/VeriFIT/mata>.
7. **Boa source.** Read depth: repository/implementation metadata and paper
   implementation description; current official head
   `54a556448169a83a369e039b5fa3ba27323ccfde`; not benchmarked in this pass.
   Repository: <https://github.com/julesjacobs/boa>.

### Coverage limits

Searches screened deterministic automata minimization, strong/branching LTS
bisimulation, and generic coalgebraic minimization. GPU and distributed work
was screened but not used as a direct comparator because the hardware and
product boundary differ. CADP/BCG_MIN and LTSmin were identified as mature
tools but not benchmarked. The comparison does not claim absence of a faster
private, unpublished, GPU, or domain-specific implementation.
