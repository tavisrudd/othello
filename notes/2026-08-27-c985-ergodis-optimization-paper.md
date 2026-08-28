# C985 Ergodis exact algebraic optimization paper

**Lane:** `complete-ports`

**Status:** IN PROGRESS; COMPILER/BOA PERFORMANCE WINDOW

**Date:** 2026-08-27

## Objective

Develop a follow-on paper presenting ergodis as a structure-aware compiler and
exact solver for finite algebraic optimization.  The paper should combine the
C980 contextual-state and Pareto theorems with the cross-domain evidence from
C983, while keeping exact recovery as the deepest motivating application
rather than the definition of the tool.

## Primary audience

The primary audience is constraint programming and exact combinatorial
optimization: global constraints, decision diagrams, decomposition, dynamic
programming, solver compilation, and mathematical preprocessing.  Secondary
audiences are computational discrete optimization and operations research,
weighted automata and algebraic dynamic programming, and coding/storage
optimization.

## Proposed theorem and algorithm spine

1. define contextual observation and the typed quotient compiled by ergodis;
2. prove exact finite-state composition for the admitted algebraic interfaces;
3. develop the finite ordered-monoid and fixed-dimensional Pareto theorem,
   including the universal multiplicity cap `1+k(R-1)`;
4. compile exact nondominated frontiers with one retained witness per frontier
   point;
5. distinguish fixed-dimensional additive resources from per-helper capacity
   and packing states;
6. use one common witness-preserving kernel for recovery and the two genuine
   noncoding exemplars admitted by C983; and
7. separate gains from mathematical quotienting, algorithm design, and
   low-level implementation through explicit ablations.

## Evidence gate

The paper is not admitted on the strength of recovery benchmarks alone.  C983
must establish that the same quotient-and-compose kernel gives material exact
state reduction on at least two noncoding models without hiding
problem-specific solvers behind a common interface.

The evaluation should compare:

- one exact ergodis Pareto compilation;
- repeated scalar ergodis solves over representative weight vectors;
- CP-SAT or MILP given both direct and equivalently preprocessed models;
- the strongest natural specialized control for each exemplar; and
- cold construction, solve, witness-replay, memory, and frontier-size costs.

Claims must distinguish mathematical state reduction from Rust performance
engineering.  A negative C983 outcome should narrow or stop this paper rather
than manufacture breadth.

## Scope limits

The initial theorem concerns a fixed number of bounded additive resources.
Per-helper capacities, growing resource dimension, cross-helper network
coding, continuous optimization, approximation, and unrestricted side
constraints require larger interfaces or downstream solvers and are not
silently covered by the Pareto theorem.

## Inputs

- `notes/2026-08-27-c980-higher-rank-contextual-minimality.md`
- `notes/2026-08-27-c980-structural-compression-hostile-proof-literature-audit.md`
- `notes/2026-08-27-c983-ergodis-cross-domain-potential.md`
- `ergodis/`

## 2026-08-28 compiler/Boa performance window

The first implementation window follows C987's application crossover.  Its
fixed order is:

1. reduce generic compiler peak memory without adding allocation or recursion
   to refinement hot loops;
2. separate source-adapter construction from the already-fast generic
   minimizer and retain exact before/after construction/RSS evidence;
3. rerun the pinned native Boa comparison after every accepted compiler slice;
4. use `perf` counters/profiles to select any remaining low-level work rather
   than speculating about SIMD; and
5. retain only changes that preserve quotient, transcript, witness-sidecar,
   and independent-oracle parity.

C987's starting hierarchy medians are 2.061 s raw construction plus 26.144 ms
generic compilation, 38,332 KiB full compile peak RSS, and 22,500 KiB raw-only
peak RSS.  The scaled quotient is 2.34x faster than raw random queries after a
3.96-million-query break-even, but the default recovery path remains unchanged.

## Compiler result, 2026-08-28

The accepted implementation slices are `f14a85699`, `2c57c14bc`,
`9967959de`, and `4c5ebffd3`.  Together they:

- canonicalize the final partition in its owned state array;
- select a sort-local or state-local target-generator directory by fan-in;
- bypass state-sized recanonicalization and transcript reconstruction when the
  initial observation partition is already stable;
- reuse the compiler's by-construction inverse index for immediate transcript
  replay, while the public verifier continues to rebuild and audit its index;
- index the validated flat transition table directly during inverse-CSR
  construction; and
- force-inline only the measured compact dense-pending and sparse-scheduling
  operations.  Force-inlining the large split routine regressed cycles and was
  rejected.

There is no allocation in a refinement iteration or binary split.  State,
member, position, mark, touched-block, pending, queue, and transcript storage is
capacity-planned before the loop.  The implementation remains iterative, with
no recursion proportional to states, classes, generators, or evidence size.

An eleven-round alternating old/new run on CPU 2 compares the C987 compiler at
`ac54ce112` with the final C985 compiler:

| family | C987 median | C985 median | speedup |
|---|---:|---:|---:|
| chain, 131072 states, 1 generator | 11.169 ms | 9.152 ms | 1.220x |
| random, 131072 states, 4 generators | 62.457 ms | 46.816 ms | 1.334x |
| 256 stable colors, 131072 states, 4 generators | 4.708 ms | 3.737 ms | 1.260x |

Hardware-counter A/B isolates the final inverse/scheduler work from frequency
drift.  Relative to the saved pre-inline compiler, random-family compilation
falls from 582.3 M to 478.5 M retired instructions (1.217x) and from 254.3 M to
222.9 M cycles (1.141x).  `perf` moved inverse-index construction from 28.4% of
cycles before direct indexing to 8.9%; the remaining profile is dominated by
partition refinement (46.3%), exact transcript replay (13.6%), and scheduling
new small splitter blocks (11.8%).

Seven hierarchy RSS rounds give a 31,748 KiB full median and 22,484 KiB
raw-build median.  Against C987's 38,332/22,500 KiB, total peak RSS is 20.2%
lower and compiler-added peak memory is approximately 15,832 -> 9,264 KiB,
or 41.5% lower.  The range across the seven final full runs is only
31,716--31,768 KiB.

The raw evidence remains outside tmpfs under `/home/tavis/.cache/ergodis-sota`:

- `c985-old-final-ab.tsv`, SHA-256
  `27ccf2889508e46f9a8ccd23247fa23b834a77d0e9f84706320b874b5ab5d309`;
- `c985-boa-streamlined.tsv`, SHA-256
  `9d571f38c8f4d727861f075c254ca12859211a7f33de07c1bc41ee94f161b38e`;
- `c985-hierarchy-memory-final.tsv`, SHA-256
  `68932c319e33670ba8573640a9e390ce4d867f0b9961a2021583fd14f40e0287`.

All 144 library tests, five observational integration tests, the allocation
regression, CLI tests, Python parity, doc tests, formatting, and strict
all-target/all-feature clippy pass.  A toolchain switch left incompatible
artifacts in the repository-local Cargo target during one lint invocation; the
clean cache-backed target passed and no destructive clean was applied to the
shared workspace.

## Native SOTA comparison and algorithmic reading

The pinned Boa revision `54a556448169a83a369e039b5fa3ba27323ccfde` is the
strongest directly comparable generic native implementation in this window.
Its timing patch encloses `partref_nlogn` only.  Ergodis' boundary includes
quotient construction and immediate exact split-transcript replay.  Eleven
alternating rounds give:

| family | Ergodis | Boa | winner |
|---|---:|---:|---:|
| chain | 12.210 ms | 26.653 ms | Ergodis, 2.183x |
| random | 47.937 ms | 25.688 ms | Boa, 1.866x |
| colors | 3.786 ms | 8.446 ms | Ergodis, 2.231x |

The older MATA adapter measurements are 70 ms chain, 300 ms random, 140 ms
colors, and 2.01 s stable.  Even without rerunning that coarser process-level
boundary, final Ergodis is about 5.7x, 6.3x, and 37x faster on the first three
families; the previously measured stable case is roughly three orders of
magnitude faster.  MATA remains a highly optimized C++ automata library, but
its natural automaton construction/reduction boundary is less general and is
not an evidence-producing typed contextual compiler.

Algorithmically, Ergodis and the classical best-known algorithms occupy the
same `O(m log n)` partition-refinement class for fixed generator alphabets.
This is the complexity established by generic coalgebraic refinement and, for
deterministic automata, matches Hopcroft.  Ergodis generalizes the interface to
typed many-sorted presentations, arbitrary finite observations, quotient
transition emission, and replayable minimality evidence.  Thus classical DFA
minimization is a one-sort Boolean-observation corollary, not the definition of
the algorithm.  This is consistent with the general coalgebraic results in
[Dorsch--Milius--Schroeder--Wissmann](https://arxiv.org/abs/1705.08362) and
their [modular extension](https://arxiv.org/abs/1806.05654), including weighted
and composite transition types.

Boa's random advantage is not from tighter asymptotics.  Its kernel batches a
dirty subset of a block, hashes complete state signatures, and can create many
blocks at once.  The current Ergodis proof backend performs one forced binary
inverse-image split per transcript record; the random fixture therefore emits
131,070 records.  Boa also allocates temporary vectors in its hot refinement
loop and uses unsafe pointer parsing, choices excluded by the Ergodis
performance contract.  Ergodis wins the chain and already-stable regimes
because small-half inverse scheduling and exact stable-partition exits avoid
full-signature work.

## Rejected and next algorithms

An allocation-free flat radix Moore probe used pre-sized state, scratch, and
class arrays plus stack-resident 256-bin histograms.  On the target random
fixture it reached the correct 131,072 singleton classes, but the lone initial
distinguished state required eleven synchronous rounds.  Its 37.05 ms median
was 1.39x faster than proof-inclusive Ergodis but 1.49x slower than Boa before
adding replay.  It is therefore not a sound default replacement.

The next serious backend is a hybrid dirty-block/multiway refiner: retain the
inverse CSR and small-half accounting, but batch all newly dirty states of a
block and assign exact full-signature groups in one operation.  Its workspace
must be flat and pre-sized; signature grouping must resolve collisions exactly;
and evidence should be a replayable multiway refinement record, not 131,070
synthetic binary records.  Dispatch belongs outside the hot loop and should use
measured partition entropy, dirty fraction, and expected split multiplicity.
The binary transcript backend remains the fallback for chains and sparse typed
systems.  This is the plausible route to erase Boa's random advantage; a 10x
Boa win is not supported by current evidence and must not be claimed before the
new certificate/backend is implemented and measured.

The broader paper framing is strengthened rather than pre-empted by this
comparison.  The implementation target is an exact compositional-state
compiler whose classical DFA, weighted-automata, coalgebraic, color-refinement,
and tree-automata instances are corollaries.  The application boundary includes
typed resource and recovery states, witness lifting, streaming separator
evidence, and downstream min-plus/Pareto composition--capabilities neither Boa
nor MATA exposes as a common exact interface.

## Final locality tail

Two final measured slices landed after the first report freeze:

- `8025a00d1` removes a state-sized `pending_counts` array whose values were
  maintained on every queue operation but never read.  At 131,072 states this
  saves 512 KiB and two scattered counter operations per queued item.  Random
  cycles improve by 1.043x and instructions by 1.009x.
- `e3b0bcef5` changes the semantically free work discipline from FIFO to LIFO.
  Recently created small splitter blocks then revisit hot member and block
  metadata.  Eleven-round FIFO/LIFO A/B improves random 66.932 -> 62.358 ms
  (1.073x), chain 13.446 -> 13.093 ms (1.027x), and colors 5.598 -> 5.512 ms
  (1.016x).  The quotient and 131,070-record random transcript are unchanged.

The final alternating Boa run, taken after both locality slices, is the SOTA
result to quote; it supersedes the earlier absolute-time table (frequency state
changed, so only within-run ratios are compared):

| family | Ergodis | Boa | winner |
|---|---:|---:|---:|
| chain | 12.870 ms | 35.604 ms | Ergodis, 2.766x |
| random | 61.730 ms | 40.707 ms | Boa, 1.516x |
| colors | 5.449 ms | 14.161 ms | Ergodis, 2.599x |

The final raw table is `c985-boa-lifo-final.tsv`, SHA-256
`f66a4496952b977055069e385cef5a5249ab37b2890939347a511fa1bcfe0246`;
the FIFO/LIFO A/B is `c985-fifo-lifo.tsv`, SHA-256
`97ea3b6b1132623017d406eb0084eef78da848ea766203ccde1e65af06b4e409`.

## Adaptive dirty-block/multiway backend

Commits `50a84ec9a` and `9ac64bc40` implement the successor backend rather
than leaving it as a design sketch.  The engine retains the typed observation
partition, processes dirty blocks iteratively, groups a dirty suffix plus one
clean representative by the complete outgoing signature, retains the largest
child, and marks predecessors only through smaller children.  It has the usual
small-half `O(m log n)` accounting.  All queues, positions, group tables,
scratch arrays, and transcript storage are pre-sized before refinement; there
is no hot-loop allocation and no scaling recursion.

For sorts of width at most four, the complete signature is packed exactly into
two `u64` words, so hash collisions cannot merge states.  Wider sorts retain a
hashed directory but compare every candidate generator by generator.  Dirty
marking uses a separate combined predecessor CSR because the generator label is
needed for the forward signature but not for the fact that a source state has
become dirty.  A `MultiwayRecord` stores each forced dirty-block split; public
verification independently rebuilds the scheduler and requires identical
events and canonical quotient.  Corruption tests, 128 cyclic and 256 typed
random differential presentations, and the allocation-envelope gate pass.

`AdaptiveTranscript` admits the backend only for at least 4,096 states, two or
fewer observation fibers per nontrivial sort, and two through four outgoing
generators.  Otherwise it retains the binary transcript backend.  The compiled
artifact records the actual selected policy.  The separate
`compile_observational_with_deferred_verification` API constructs the same
proof-carrying artifact once and leaves replay to an explicit trust,
persistence, or process boundary; the default API still replays immediately.

Final eleven-round CPU-2 A/B medians against pinned Boa revision
`54a556448169a83a369e039b5fa3ba27323ccfde` are:

| boundary/family | Ergodis | Boa | ratio |
|---|---:|---:|---:|
| immediate chain | 11.914 ms | 26.856 ms | Ergodis 2.254x |
| immediate random-4 | 35.964 ms | 25.001 ms | Boa 1.438x |
| immediate colors | 3.850 ms | 8.309 ms | Ergodis 2.158x |
| deferred chain | 5.648 ms | 19.586 ms | Ergodis 3.468x |
| deferred random-4 | 16.842 ms | 24.897 ms | Ergodis 1.478x |
| deferred colors | 2.649 ms | 8.240 ms | Ergodis 3.110x |

Median cold peak RSS is 18,556 KiB for the binary immediate transcript,
19,320 KiB for adaptive immediate replay, and 14,956 KiB for adaptive deferred
replay.  Thus the service boundary is 19.4% below the former binary process
peak.  Nonmultiplexed counters give 97.5 M cycles and 162.2 M instructions for
deferred random compilation versus 218.6 M cycles and 365.3 M instructions
when the same artifact is immediately replayed.

The tracked evidence is checked with:

```sh
cd papers/complete-repair-ports/ergodis
scripts/check-observational-backend-evidence.sh
```

Regeneration uses the release `observational_sota_driver`, pinned Boa checkout,
fixed fixture directory, eleven rounds, and CPU 2:

```sh
ERGODIS_CERTIFICATE_POLICY=adaptive scripts/observational-boa-ab.sh \
  "$ERGODIS_BIN" "$BOA_SOURCE" 11 2 "$FIXTURE_DIR" \
  > evidence/c985-backend-immediate.tsv
ERGODIS_CERTIFICATE_POLICY=adaptive-deferred \
  scripts/observational-boa-ab.sh "$ERGODIS_BIN" "$BOA_SOURCE" 11 2 \
  "$FIXTURE_DIR" > evidence/c985-backend-deferred.tsv
```

The exact evidence hashes are:

- benchmark script: `886792e67b4d69d0de3cbadb9464a841fb3febe4cc885f52b2f4495b9bef630c`;
- checker: `fe5c237a53ec84a0f15226456cacb66d805677b83f1971b9ca68198bdbbd4ba7`;
- immediate table: `19aab444cbe6c9466595deb1ad23cc309f8ef5117a73fe39a0c8798f7c1c3341`;
- deferred table: `259d51ad0c5f6258488e86c8187b8087148316ac2e83476784f28b9bc54af482`;
- RSS table: `b7d122a05c5eb07dcba2b80b37feb02cdf0791cd8ac96d12f09123598086895a`.

These experiments establish bounded performance on the three deterministic
131,072-state fixtures; they do not establish a universal ordering over
automata or coalgebra encodings.  Independent checking consists of equality
with the exhaustive reference on the bounded corpora, independent public
certificate replay, corruption rejection, and comparison with Boa's pinned
native result.

## Theorem-driven context elimination and kernel profile

Commit `bc1410739` adds a refinement-only generator basis.  It uses four exact
reductions before constructing the predecessor relation:

1. an identity endocontext is refinement-neutral;
2. a constant context cannot distinguish two source states;
3. pointwise-identical contexts induce the same refinement constraint;
4. a context targeting an observationally singleton sort is neutral.

The singleton sorts are the greatest fixed point among observation-constant
sorts whose outgoing contexts remain in that set.  This is a coinductive
closure, not a syntactic singleton-state test: mutually recursive uniform
sorts are recognized.  If `R` is the retained basis, every omitted generator
is constant on every block stable under `R`; consequently stability under
`R` implies stability under the full generator family.  The emitted artifact
nevertheless includes quotient transitions for every original generator, and
the public verifier checks congruence against the full presentation.  A typed
4,098-state regression combines identity, constant, duplicate, and
coinductively singleton-target cases; the two-generator reduced result equals
the independent worklist result and passes replay.

This reduction is unavailable to Boa's generic encoded-alphabet refiner.  It
also changes backend selection: a presentation with more than four supplied
contexts can remain in the exact packed multiway kernel when its semantic
basis has width at most four.  Preprocessing is iterative, occurs outside the
hot loop, and uses compact sort/generator directories.  Refinement itself
remains allocation-free and nonrecursive.

The pre-change deferred random profile attributed 83.1% of samples to
`minimize_partition_multiway`, 5.8% to combined-inverse construction, and
4.6% to artifact emission.  Source-line profiling identified repeated
generator-record loads and dynamic two-word packing in the signature kernel.
Specializing the exact 0--4 generator signature reduced an interleaved median
from about 23.4 ms to 21.8 ms (1.07x).  A proposed bitmap for rejecting
singleton predecessors earlier was neutral over fifteen interleaved rounds
and was removed rather than retaining extra state.  Final nonmultiplexed
random counters are 93.7 M cycles and 148.3 M instructions, versus 97.5 M and
162.2 M before specialization: 3.9% fewer cycles and 8.6% fewer instructions.

The final eleven-round CPU-2 A/B medians at pinned Boa revision
`54a556448169a83a369e039b5fa3ba27323ccfde` are:

| deferred family | Ergodis | Boa | Ergodis advantage |
|---|---:|---:|---:|
| chain-1 | 8.302 ms | 35.320 ms | 4.254x |
| random-4 | 22.043 ms | 40.060 ms | 1.818x |
| random basis-4 exposed as 16 contexts | 27.431 ms | 86.603 ms | 3.157x |
| stable colors-4/256 | 2.704 ms | 14.010 ms | 5.180x |

Each paired case returns the same quotient size (131,072 except 256 for the
stable-color quotient).  The redundant
case retains the same 16,204 multiway records as random-4; its remaining cost
increase is the unavoidable exact scan needed to validate the larger input
and emit its full quotient alphabet.  These are bounded implementation
results, not a claim that real applications contain a particular redundancy
ratio.  They demonstrate the application-framing point: Ergodis can accept a
richer contextual language without paying for every semantically redundant
context in the refinement kernel.

Regeneration:

```sh
ERGODIS_CERTIFICATE_POLICY=adaptive-deferred \
  scripts/observational-boa-ab.sh "$ERGODIS_BIN" "$BOA_SOURCE" 11 2 \
  "$FIXTURE_DIR" > evidence/c985-theorem-final.tsv
```

Hashes after adding the redundant-context fixture are:

- final raw table: `bab8159d0c7eacce71b1aadae9e8e7dca7cf4f87788982794a93158799859716`;
- benchmark script: `34544e7d5eb05972fdf8511338ad79d44e46b34975c42a48981037a75a538bef`;
- fixture generator: `2f9344fc94db5f8846663adeff9027c41fd857181c7678e8177846591f77dc97`.
