# C983 observational minimization: SOTA comparison

**Date:** 2026-08-27
**Lane:** `complete-ports`
**Full-text sources read:** 1. Two further papers were read selectively, and
three maintained implementations were inspected at pinned revisions. This is
an algorithm/implementation comparison, not a literature-wide priority claim.

## Bottom line

Ergodis now belongs in the same practical performance class as a strong
specialized DFA minimizer on the deterministic finite subcase we can compare
exactly. After repairing the refinement pathologies and selecting dense or
sparse pending storage by exact footprint, it is 1.61x faster than MATA's
current C++ Hopcroft/Valmari-style implementation on a 131,072-state unary
chain and 3.30x faster on the four-generator random family. It uses 13--16x
less cold peak RSS on those controls. This is a strong result because ergodis
additionally emits a compact
split transcript and verifies it before returning, whereas MATA returns only
the minimized automaton.

This does **not** yet establish that ergodis is the universally fastest
minimizer.  A new native-functor comparison makes that boundary concrete: Boa
is 2.48x faster on the four-generator random family, while ergodis is 1.81x
faster on the unary chain and 1.76x faster on the 256-output cyclic family.
Boa returns partition IDs; ergodis additionally constructs quotient
transitions, emits a split transcript, and independently verifies it.  The
defensible comparison therefore has three different frontiers:

| Frontier | Best relevant algorithm/tool found | Relation to ergodis |
|---|---|---|
| Deterministic finite machines | Hopcroft/Valmari--Lehtinen style refinement; MATA `minimize_hopcroft` | Closest direct speed comparison, but MATA has only Boolean final-state observations and no typed sorts or proof transcript |
| General labelled transition systems, including internal actions | Groote--Jansen 2025, `O(m log n)`; the default kernel in mCRL2 202607 | Strictly broader operational semantics than the current deterministic ergodis kernel, but not a direct performance comparator |
| Generic system types | Jacobs--Wißmann/Boa 2023 for computable Set functors, `O(k m log n)` in the usual bounded-outdegree instances | Closest generic executable comparator; wins the random control but loses the chain and native-output controls, and returns a narrower partition-ID product with no contextual witness/proof contract |

The immediate theoretical position is therefore: ergodis is a specialized,
many-sorted, output-initialized strong-bisimulation/DFA refinement kernel with
extra proof and witness infrastructure. Its implementation now uses the
refinable-partition operation needed by the classical `O(m log n)` line. Its
dense pending bitmap has exact constant-time operations; its sparse flat
Patricia directory takes at most 64 branch decisions per operation. A polished
theorem-facing proof remains to be extracted from the implementation argument.

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
| Unary chain | 14.643 ms | 23.502 ms | 1.61x |
| Random, four generators | 61.321 ms | 202.485 ms | 3.30x |

These final numbers include the edge-sparse typed scheduler. Relative to the
earlier dense-pending checkpoint, the random family improves while the unary
chain gives back some constant factor for the more general candidate index.
Both still include transcript emission and independent replay; the table is
retained as the conservative classical-specialization control.

Peak RSS was measured separately with `/usr/bin/time -v` around one cold
process. It includes each executable's input and runtime footprint and is less
stable than the interleaved time result, so it is evidence of scale rather
than a precise allocator decomposition.

| Family, `n=131,072` | Ergodis RSS | MATA RSS | Ratio |
|---|---:|---:|---:|
| Unary chain | 13.0 MiB | 211.0 MiB | 16.2x smaller |
| Random, four generators | 20.9 MiB | 275.3 MiB | 13.2x smaller |

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

Two later hostile controls closed less visible variants of the same problem.
First, fixed SplitMix hashing with linear probing admitted a realizable
64-transition family whose live `(block,generator)` keys all had the same home
slot, giving quadratic probe and backshift work. The sparse directory is now a
flat preallocated binary Patricia trie: 8-byte leaf keys, 16-byte `repr(C)`
branches, no hot-loop allocation or recursion, and at most 64 branch decisions
per operation. Classical endomaps instead select a smaller dense pending
bitmap by exact backing-pool footprint, with one dispatch before the
monomorphized refinement loop.

Second, `QuotientOnly` still called the old synchronous reference refiner even
after split-transcript mode had moved to the small-half kernel. The SOTA driver
exposed that route on the 131,072-state chain. Quotient-only now constructs and
independently replays the same linear transcript internally, then discards it
before returning; a 16,384-state long-chain regression guards the policy. The
quadratic signature refiner remains only where the explicitly bounded
exhaustive-pair audit preserves its legacy refinement-round metric.

## Hardware profile and next scaling move

On the final implementation at 1,048,576 states and four generators, three
interleaved process runs give median internal times of 1.762 s for ergodis and
2.554 s for MATA, a 1.45x compiler advantage. Three non-multiplexed
`perf stat` repetitions give the following process counters; they
wrap the whole driver process and therefore include deterministic input
construction for both implementations:

| Counter | Ergodis | MATA |
|---|---:|---:|
| Instructions | 5.511 B | 10.215 B |
| Cycles | 8.122 B | 13.841 B |
| Branches | 1.152 B | 1.878 B |
| Branch misses | 18.219 M | 12.103 M |

Ergodis now retires 46% fewer instructions and 41% fewer cycles, although its
irregular exact-proof bookkeeping incurs more branch misses. An earlier
sampled checkpoint attributed about 15% of cycles to inverse sorting and 16%
to independent transcript verification; that profile selected the following
adaptive construction change.

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

The final compiler first tests a rich initial observation partition for
congruence in one forward pass. If stable, it bypasses inverse construction and
no-op splitter traversal. At `n=131,072`, four generators, and `k=256`, seven
interleaved rounds give 4.712 ms for ergodis and 54.146 ms for the pinned MATA
encoding, an 11.5x product-level speedup. Ergodis returns 256 native classes and
an empty verified transcript; MATA returns 257 classes including its encoding
sink.

The harness also contains a strictly Boolean `stable` control: all states are
accepting, cyclic-shift generators make every state reachable, and the
quotient has one state. Totality into a one-class target makes congruence
immediate, so ergodis omits the sole initial splitter and allocates no inverse
or pending arena.

| `stable` scale | Edges | Ergodis | MATA | speedup | cold RSS ratio |
|---|---:|---:|---:|---:|---:|
| 131,072 states / 64 generators | 8.39 M | 1.240 ms | 678.128 ms | 547x | 30.3x smaller |
| 65,536 states / 128 generators | 8.39 M | 0.589 ms | 648.201 ms | 1,100x | 31.9x smaller |

The second row's cold RSS is 35,416 versus 1,129,368 KiB. These are genuine
algorithmic early-termination advantages on a scoped stable family, not a
claim that all DFA minimization is 547--1,100x faster. Input construction is
outside both internal timing windows; process RSS includes the inputs.

The retained `scripts/observational-sota-ab.sh` driver runs alternating
process-level rounds for `chain`, `random`, `colors`, and `stable`, pins both
binaries to the same CPU, and emits raw TSV.

The final seven-round output is retained as
`ergodis/evidence/c983-observational-mata.tsv`, SHA-256
`2f720ba8c47f71ead086eba7c638477384ae90a6024fced4e618c2d16402c72d`.
Its header, 56 measurements, class/split counts, and eight exact medians replay
with:

```text
papers/complete-repair-ports/ergodis/scripts/check-c983-observational-mata-evidence.sh
```

Exact source/build/replay boundary (run the final three commands from the
ergodis crate root; the measured ergodis source commit is `2b0a09d64`):

```text
git clone https://github.com/VeriFIT/mata.git /path/to/mata
git -C /path/to/mata checkout e8c9310e389b1e62ece7080956550f70ceeed777
cmake -S /path/to/mata -B /path/to/mata-build -DCMAKE_BUILD_TYPE=Release
cmake --build /path/to/mata-build --parallel 1
g++ -O3 -DNDEBUG -std=c++20 \
  -I/path/to/mata/include -I/path/to/mata/3rdparty/simlib/include \
  benches/mata_observational_driver.cc /path/to/mata-build/src/libmata.a \
  -lpthread -o /path/to/mata-observational-driver
env CARGO_TARGET_DIR=target-codex-193 nix develop --command \
  cargo build --release --example observational_sota_driver
scripts/observational-sota-ab.sh \
  target-codex-193/release/examples/observational_sota_driver \
  /path/to/mata-observational-driver 7 1 2
```

This family is useful precisely because it exposes a representational
difference: a native finite observation partition can finish at initialization,
whereas a Boolean-acceptance-only API must encode and rediscover it through
transitions.  It must be labelled a native-output/product comparison, not
evidence that ergodis has a universally faster Boolean-DFA minimizer.

## Generic Boa executable comparison

Boa is also executable on the same Moore systems without a semantic encoding:
each state is one `List[observation]{@successor,...}` node.  The official head
remains `54a556448169a83a369e039b5fa3ba27323ccfde` and builds with the current
Nix Rust toolchain.  Its CLI already reports parsing and internal refinement
separately.  The retained `benches/boa-kernel-timing.patch` adds a main-level
timer around `partref_nlogn`, so the measured kernel also includes Boa's final
partition-ID renumbering.  Fixtures are generated by
`benches/boa_observational_fixture.py`; seven process-level rounds were
alternated by `scripts/observational-boa-ab.sh` on logical CPU 2.

| Family, `n=131,072` | Ergodis median | Boa median | Relative result |
|---|---:|---:|---:|
| Unary chain | 10.762 ms | 19.526 ms | Ergodis 1.81x faster |
| Random, four generators | 62.105 ms | 25.016 ms | Boa 2.48x faster |
| 256 native outputs, four shifts | 4.725 ms | 8.295 ms | Ergodis 1.76x faster |

All class counts agree: 131,072 for the first two families and 256 for the
third.  The timing products do not agree, and the relative result is
family-dependent:
ergodis constructs quotient transitions, retains a split transcript, and runs
an independent transcript verifier before returning.  Boa constructs
backreferences, refines, and canonically renumbers partition IDs, but does not
return the minimized transition coalgebra, a proof artifact, separating
contexts, or an independent verification result.  Consequently this is the
fairest generic semantic comparison available, but not evidence that ergodis'
current proof-producing compiler beats the best generic partition-ID engine.

Exact replay from a fresh Boa checkout is:

```text
git clone https://github.com/julesjacobs/boa.git /path/to/boa
git -C /path/to/boa checkout 54a556448169a83a369e039b5fa3ba27323ccfde
scripts/observational-boa-ab.sh \
  target/release/examples/observational_sota_driver /path/to/boa 7 2
```

The script checks the revision, applies the timing patch exactly once, builds
Boa release if needed, generates binary fixtures outside the repository, pins
both executables to the same CPU, and emits raw TSV.  Peak RSS remains
unmeasured for this comparison.  The retained seven-round output is
`notes/2026-08-27-c983-observational-boa-ab.tsv`, SHA-256
`d3b31e0a5998f7a195da44eeb486e7657acbfe976ddcfdf6dff5f3f076d54447`.
Its six group medians, seven-round cardinalities, and class counts replay with:

```text
papers/complete-repair-ports/ergodis/scripts/check-observational-boa-evidence.sh
```

## Why mCRL2 GJ25 is not in the direct executable table

The current mCRL2 head remains
`0fc9c22820894f8d769c15174795ab0542f1ad4d`, release 202607.0, and contains the
published GJ25 dispatch.  It is not a lightweight fourth instance of this
benchmark: GJ25 solves branching bisimulation on LTSs, not deterministic Moore
minimization; the available route is a full model-checking tool build plus AUT
generation, parsing, reduction, and output serialization.  A Moore machine can
be encoded into an LTS, but then both the semantics and state/transition counts
change, and the CLI wall time is not a library-kernel boundary comparable to
the retained Rust and MATA drivers.  Adding it responsibly requires a native
LTS corpus, separate parse/kernel/write timing, and a comparison against the
broader branching-bisimulation product.  It remains valuable external SOTA,
but forcing it into the deterministic table would weaken rather than strengthen
the claim.

## Gaps before a stronger SOTA claim

- Add a native-LTS mCRL2 GJ25 corpus only as a separate broader-semantics table;
  tool parsing and output serialization must be reported separately from the
  reduction kernel.
- Use several reduction ratios, sparse/partial transitions, many labels,
  multiple sorts, and severely imbalanced source/target sorts. The current
  direct corpus intentionally isolates two fully separated deterministic
  cases.
- Measure peak live allocation by stage, not just process RSS.
- Promote the architecture argument for the edge-bounded candidate CSR,
  small-half incidence charging, adaptive dense bitmap, and fixed-width
  Patricia directory into a theorem-facing proof. The `D=262,144, M=64`
  control and former fixed-hash collision family are permanent regressions.
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
   `54a556448169a83a369e039b5fa3ba27323ccfde`; built and benchmarked on the
   native List-functor fixtures described above.
   Repository: <https://github.com/julesjacobs/boa>.

### Coverage limits

Searches screened deterministic automata minimization, strong/branching LTS
bisimulation, and generic coalgebraic minimization. GPU and distributed work
was screened but not used as a direct comparator because the hardware and
product boundary differ. CADP/BCG_MIN and LTSmin were identified as mature
tools but not benchmarked. The comparison does not claim absence of a faster
private, unpublished, GPU, or domain-specific implementation.
