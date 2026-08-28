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
from about 23.4 ms to 21.8 ms (1.07x).  Source-state and cache-resident
block-ID bitmap variants for rejecting singleton predecessors earlier were
neutral or slightly slower over fifteen and twenty-one interleaved pairs,
respectively, and were removed rather than retaining extra state.  Final
nonmultiplexed
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

## Exact transformation-monoid reduction

Commit `693d00037` extends the refinement basis from syntactic neutralities to
typed length-two composition.  If an original generator satisfies

```text
g = h ; k
```

pointwise, with both `h` and `k` already retained and well typed, then every
partition congruent for `h` and `k` is congruent for `g`.  The compiler can
therefore omit `g` from signatures and the inverse relation without changing
the coarsest observational quotient.  Greedy retention makes every omission
an acyclic word over the retained basis, so induction recovers congruence for
the full supplied generator family.  Original quotient transitions and the
public full-alphabet verifier remain unchanged.

The exact detector compares concrete compositions and never trusts hashes.
It runs outside refinement and allocates no hot-loop state.  Once five
independent generators from a source sort survive, detection stops for later
generators from that source: the width-four packed backend can no longer be
recovered.  This bounds work on wide irreducible alphabets while retaining all
composition reductions relevant to adaptive admission.  The permanent typed
test now also eliminates a cyclic shift expressed as a retained composition
and agrees with the independent worklist quotient.

Follow-on commit `f7f241a0a` passes the already proved refinement directory
from adaptive admission into the selected compiler instead of deriving it a
second time.  Public verification continues to rebuild independently.  The
final six-family table below includes this reuse optimization.

Commit `5574ad92a` adds a second exact monoid corollary for endomorphism powers.
If a supplied generator is `f^k` for retained `f`, congruence for `f` implies
congruence for that generator.  The detector is bounded at exponent 32.  A
representative-state orbit is only a cheap trigger; acceptance requires exact
equality of the complete transition table.  Once triggered, all powers are
built together by 32 sequential passes and every matching supplied generator
is marked, reducing the former repeated transition chasing by roughly an
order of magnitude.  Scratch allocation is lazy and remains outside the
refinement loop.  A raw high-arity sort reduced to one generator may use the
multiway backend, while a genuinely unary raw sort retains the faster binary
chain policy.

Commit `2ed766799` removes the checked public-transition call from full
quotient emission.  It indexes the already validated generator slice directly
by the source-local class representative.  This retains full-alphabet output
while reducing the now-prominent emission cost; validation and independent
artifact replay are unchanged.  The final table includes this fast path.

Commit `714dea4ca` adds the discrete-quotient corollary: when both endpoint
sorts have one quotient class per state, canonicalization is the affine map
from the concrete sort interval to the class interval.  Equal intervals permit
a bulk copy of the complete generator transition slice; unequal intervals need
only the fixed offset.  This removes all representative and target-class
lookups on discrete sorts without weakening the general collapsed-sort path.

The same window rejected four plausible micro-optimizations after interleaved
gates: replacing the LIFO `VecDeque` by `Vec`, a separate block-length sidecar,
unchecked open-address-table indexing, and a discrete branch that still mapped
targets through the class array.  Each was neutral or slower and is absent from
the retained code.  No unsafe optimization survived.

On the 131,072-state composed-16 control, eleven paired internal rounds give
200.055 ms without composition elimination and 22.665 ms with it, an 8.83x
speedup.  The retained proof has the same 16,204 multiway records as the
four-generator basis.  The observed crossover is already positive at five
supplied contexts; irreducible random controls at widths 5, 8, and 16 showed
about one percent or less overhead/noise.

Final eleven-round CPU-2 medians against pinned Boa are:

| deferred family | Ergodis | Boa | Ergodis advantage |
|---|---:|---:|---:|
| chain-1 | 7.579 ms | 27.192 ms | 3.588x |
| irreducible random-4 | 15.011 ms | 25.152 ms | 1.676x |
| duplicate-context-16 | 17.796 ms | 65.295 ms | 3.669x |
| composed-context-16 | 18.033 ms | 57.902 ms | 3.211x |
| power-context-32 | 14.511 ms | 45.792 ms | 3.155x |
| stable colors-4/256 | 2.664 ms | 8.282 ms | 3.109x |

The composed family is a controlled transformation-monoid application shape,
not a claim about the redundancy distribution of arbitrary inputs.  It shows
that theorem-derived context bases can change backend admissibility and yield
an order-of-magnitude internal improvement that generic alphabet refinement
does not discover.

Replay the external table with the existing pinned-Boa command.  The internal
harness archives the committed Ergodis source into a cache-backed temporary
tree, applies the tracked one-line baseline patch, builds it in a persistent
cache target, and alternates that binary with the supplied final release
binary:

```sh
scripts/observational-composition-ab.sh "$ERGODIS_BIN" 11 2 \
  "$ERGODIS_BENCH_CACHE" > evidence/c985-composition-internal.tsv
scripts/check-observational-backend-evidence.sh
```

Hashes:

- final six-family table: `688e54923d97be2d16a50e1d3cfef010e50a3fa48333b888d80850f2a6d00b12`;
- internal composition A/B: `228112aa3a48fac1e7db83c01713a7925cce5e4d624b67316ffaea240829bc01`;
- benchmark script: `2c1ce8200d565fa87eceea2d786d60ad6fb0ef7fa6a9e80e0ea7ac0e71931222`;
- checker: `500ec0398ca0fc9a745e14e4c6587f82794f808c792c74fdbc639f00447e3bdf`;
- fixture generator: `9016bf311489ae6324fc20e78817e6f928d47a6388725361bf5053a3ea085991`;
- internal A/B script: `1fa9c584f8928676ad6253d81327681be1c7014f5021075d6a177b34f699dd8e`;
- exact baseline patch: `35c249c0c11b61604a3a1694c1ebe7ecabb61d46c9185848fe62a640fb5d01ca`.

## Binary theorem basis and replay reuse

Commits `0b37eb364` and `0c34db882` extend the same exact generator-basis
theorem to the binary split backend.  Split records retain original generator
IDs, but inverse edges, target-generator scheduling, dense pending slots, the
Patricia capacity, and the queue capacity are built only for the retained
basis.  The permanent 4,096-state typed regression presents twenty generators
with five exact independent transformations and checks that the prepared
inverse contains `5 * 4096`, rather than `20 * 4096`, source edges.  It also
replays the resulting split artifact through the public full-alphabet
verifier.

Immediate compilation previously discarded that basis inverse and rebuilt the
full inverse alphabet solely to replay the split proof.  This was unnecessary:
the generic verifier has already checked every original quotient edge for
typing, totality, observation constancy, and congruence, while each proof
record names a retained generator whose inverse was constructed from the
validated presentation.  Immediate replay now reuses that basis inverse.
Standalone `verify_compilation` remains the independent trust boundary and
still rebuilds and audits the full alphabet.

Seven paired CPU-2 rounds on the deterministic 131,072-state, 32-generator
duplicate-context family compare committed baseline `0b37eb364` with
`0c34db882`.  Each process performs two immediate split-transcript compiles.
Median time falls from 126.526 ms to 64.467 ms, a 1.963x speedup; median peak
RSS falls from 83,476 KiB to 49,712 KiB, a 40.45% reduction.  The evidence is
host-specific wall/RSS data, not an asymptotic claim.  The full 149-test suite,
doc tests, and all-target clippy gate pass, including independent public replay
and corruption tests.

Exact replay from the repository root, after building the two named commits'
`observational_sota_driver` release examples into cache-backed target
directories, is:

```sh
ERGODIS_ROUNDS=7 \
  papers/complete-repair-ports/ergodis/scripts/observational-basis-replay-ab.sh \
  "$BASELINE_DRIVER" "$BASIS_REPLAY_DRIVER" \
  > papers/complete-repair-ports/ergodis/evidence/c985-basis-replay-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-observational-basis-replay-evidence.sh
```

Bundle hashes and byte counts:

- A/B script: `79145ea3905a30008615b785cc3541af97204a217670f16c7e64102b728fcce1`, 887 bytes;
- checker: `582a75c54a0c99f8aa9529dfe9fdead18dcde51d9a326747eee4082b131a318d`, 1,111 bytes;
- TSV: `717a256260f4c0bc611a904effd4e1065bc8cc4fc2845ed886ee331f5232a317`, 447 bytes.

A compact derivation plan for reconstructing eliminated generator tables was
also profiled and rejected.  On the same wide case it added 2.8% instructions
and 6.0% cycles, with no stable composed-family gain.  No part of that
experiment remains.  The architectural successor is an explicit compressed
artifact policy whose consumers understand provenance; adding metadata to the
ordinary full-table compile path is the wrong scaling boundary.

Commit `83aa94863` obtains the first such compression without a new schema or
runtime provenance.  Generator records already address immutable quotient
transition slices, so exact duplicate concrete generators now share the prior
generator's slice.  The full verifier still checks every original generator
against the addressed quotient table.  On the same 32-generator control this
stores five tables instead of 32, an 84.4% reduction in transition payload.
Seven paired CPU-2 rounds against `0c34db882` give a neutral-to-positive time
ratio (61.490 ms versus 60.910 ms, 1.010x) and reduce median peak RSS from
49,636 KiB to 34,884 KiB, or 29.72%.  The evidence uses the existing A/B
script; its historical `basis_replay` candidate label denotes the shared-slice
binary in this second TSV.

```sh
ERGODIS_ROUNDS=7 \
  papers/complete-repair-ports/ergodis/scripts/observational-basis-replay-ab.sh \
  "$REPLAY_REUSE_DRIVER" "$SHARED_SLICE_DRIVER" \
  > papers/complete-repair-ports/ergodis/evidence/c985-shared-slices-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-observational-shared-slices-evidence.sh
```

- shared-slice checker: `0a1629c5f9db589aa318afd7f79c158779faa6c038bbce016327f01554777658`, 1,078 bytes;
- shared-slice TSV: `3954f12cf8f6b4de3f4fb6f5efe48d3132aa770f4f06f5bc3ebf805483703039`, 440 bytes.

## Wide adaptive multiway frontier

Commit `6f0dfa9dc` removes the adaptive policy's artificial width-four ceiling.
Four is the packed-signature fast-path width, not a semantic or algorithmic
limit: the same allocation-free dirty-block engine already has an exact hashed
signature path for wider alphabets.  Genuinely unary raw presentations still
select the binary chain backend, and callers may still request an explicit
split transcript.  All other two-output wide presentations may now select
multiway refinement after exact generator-basis reduction.

Seven paired deferred CPU-2 rounds compare `83aa94863` with `6f0dfa9dc`.
Random-32 falls from 502.956 ms to 111.130 ms (4.526x) and median peak RSS from
90,360 to 45,260 KiB (49.91%).  Random-128 at 65,536 states falls from 968.062
ms to 184.324 ms (5.252x) and RSS from 169,148 to 72,784 KiB (56.97%).  Both
families are deterministic; these measurements establish the policy crossover
on the stated controls, not universal dominance for every wide presentation.

```sh
ERGODIS_ROUNDS=7 \
  papers/complete-repair-ports/ergodis/scripts/observational-wide-adaptive-ab.sh \
  "$BASELINE_DRIVER" "$WIDE_DRIVER" \
  > papers/complete-repair-ports/ergodis/evidence/c985-wide-adaptive-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-observational-wide-adaptive-evidence.sh
```

- wide A/B script: `685758524804938c3496dddfca32baea7111b070497651faa99ddc11796e6ade`, 1,038 bytes;
- wide checker: `38ea9225b2b6d6cd66260435d7e2cc6031a646baaf88bfeb4c9873f4cfacbbdb`, 1,101 bytes;
- wide TSV: `6eaf24d90ba8e93770513b4736ed41b0547dfdd868ac5d42438fa5964bbfc8df`, 1,057 bytes.

Commit `795590ce1` then stores each retained generator's validated transition
start beside the basis ID.  Wide signature hashing and collision checks index
those starts directly, eliminating a generator-record load and source-offset
reconstruction for every signature component.  Seven paired rounds against
`6f0dfa9dc` improve random-32 from 111.379 to 99.330 ms (1.121x) and
random-128 from 184.453 to 167.147 ms (1.104x), with median RSS within 0.5%.
The directory is pre-sized during basis construction and adds no hot-loop
allocation.

```sh
papers/complete-repair-ports/ergodis/scripts/check-observational-wide-directory-evidence.sh
```

- directory checker: `2b5b93f50f957e9bd2e9bfe34877759c03f1340ef77e75aefe980dbb0db4a645`, 819 bytes;
- directory TSV: `40ac0f020227b74b45542bd5fa235c6e0f416810800cc511cfea035093e69fed`, 1,045 bytes.

Commit `cc32d374c` changes the remaining wide signature kernel from
state-major to generator-major traversal for dirty refiners of at least 64
states.  One preallocated state-sized hash array carries the independent hash
accumulators; every generator transition slice is therefore read with local
spatial locality, while exact collision equality remains unchanged.  Smaller
refiners retain the scalar path, and neither path allocates in the refinement
loop.  Seven paired rounds against `795590ce1` improve random-32 from 102.429
to 83.339 ms (1.229x) and random-128 from 170.881 to 130.754 ms (1.307x).
Median RSS rises by 2.22% and 0.97%, respectively, for the reusable hash
workspace.

The TSV reuses the tracked wide A/B generator and directory checker:

```sh
papers/complete-repair-ports/ergodis/scripts/check-observational-wide-directory-evidence.sh \
  papers/complete-repair-ports/ergodis/evidence/c985-wide-batched-final.tsv
```

- batched-signature TSV: `089844910ea65dab4f648c5acfd598dd8676d482ecccb45420a180a194a919d3`, 1,042 bytes.

A focused seven-round CPU-2 comparison against Boa revision
`54a556448169a83a369e039b5fa3ba27323ccfde` closes the width-128 SOTA loop.
On the deterministic 65,536-state, 128-generator, two-output random family,
Ergodis adaptive-deferred returns the same 65,536 quotient classes while
retaining its replayable transcript.  Its median is 130.393 ms versus Boa's
136.850 ms, making Ergodis 1.050x faster on this control.  The first alternating
round is cold for both tools and does not affect the median.

```sh
ERGODIS_ROUNDS=7 \
  papers/complete-repair-ports/ergodis/scripts/observational-wide-boa-ab.sh \
  "$ERGODIS_DRIVER" "$PINNED_BOA_SOURCE" "$RANDOM_128_FIXTURE" \
  > papers/complete-repair-ports/ergodis/evidence/c985-wide-boa-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-observational-wide-boa-evidence.sh
```

- wide Boa A/B script: `7175f902e9ad1011e73a10f339b148457a78a681cb24fc0b65151057bb02f8ca`, 1,436 bytes;
- wide Boa checker: `fa2c3bbfbc6766aa85072d71e4b216e2fee22875b8fcf88da64468a81f456de3`, 750 bytes;
- wide Boa TSV: `789d66d185874837bd17efe9025ff5209c77056e9ee683428220043f2137cf4a`, 462 bytes.

## Portfolio-theorem transfer

The performance work now feeds a broader exact compositional engine rather
than ending at observational minimization.  The finite tower-synthesis
corollary from C980 is executable through three quotient operations:

- commit `57623e09d` adds shortest typed generator-word synthesis;
- commit `cabf4e675` adds minimum-cost synthesis for nonnegative generator
  costs using a preallocated indexed heap; and
- commit `bc063825d` adds exact preperiod/cycle analysis for an indefinitely
  repeated type-preserving layer.

Commit `aa7b39423` implements the generator-alphabet case of C980's
family-restricted contextual quotients.  It constructs an exact restricted
presentation and retains the map to original generator IDs, so synthesized
words remain replayable.  Commit `337b35e98` extends this to arbitrary regular
context-word policies by taking the typed product with a finite deterministic
recognizer and masking observations outside its accepting states.  The product
keeps original generator IDs and exact minimization can merge equivalent
recognizer-control states.  Minima-defined application families may still
require the coarser response-vector quotient described in C980.

Commit `fbdca7185` removes recursive pivot selection from the rank-bounded
recovery-context cache.  RREF pivot sets are now walked lexicographically in
fixed preallocated storage, eliminating stack-depth dependence while retaining
the radius-bounded exact enumeration.

Commit `c11ce2cc3` applies the rank-stratified theorem one step further: exact
full-row-rank coefficient maps are rank-tested once and stored contiguously for
reuse across every outer subspace.  Cache admission is bounded to 8 MiB per
instance; inadmissible strata use the prior exact on-the-fly path.  Seven paired
CPU-2 rounds on the binary rank-2 cold build-and-query benchmark reduce the
median from 21,327 ns to 11,391 ns (1.872x).  The candidate count remains 255.
Median process peak RSS is 10,784 versus 11,916 KiB; at this small workload the
1,132 KiB process-level increase is much larger than the 30-byte coefficient
payload and includes separate benchmark-binary/runtime variation.

```sh
ERGODIS_ROUNDS=7 \
  papers/complete-repair-ports/ergodis/scripts/contextual-rank-map-ab.sh \
  "$BASELINE_BENCH" "$FULL_RANK_CACHE_BENCH" \
  > papers/complete-repair-ports/ergodis/evidence/c985-full-rank-map-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-contextual-rank-map-evidence.sh
```

- rank-map A/B script: `54a3237eec9c2cacb56f1274b91317631395c1a34ef5b97c05f8dda618f05961`, 991 bytes;
- rank-map checker: `f25a412055b9743199785cc4a034f942ee081b84151009e395ac3ebfdc4ef3ad`, 762 bytes;
- rank-map TSV: `91cf18bdcf19b25dd6c5f01bcbeaee6e154922a1b32f8627974857b00729fe3d`, 417 bytes.

`perf record` on the hoisted kernel attributes 50.29% of sampled cycles to
coefficient-label construction and 14.85% to generic `CostTable` lookup.
Commit `f521272bf` therefore lazily compiles small finite label spaces to a
dense exact cost directory for explicit cached execution.  A `u64` sentinel
keeps `u32::MAX` available as a real cost; equal inner/target table objects
share the directory, admission is capped at 262,144 labels, and
memory-budgeted `Auto` execution retains the prior allocation model.

Seven paired CPU-2 rounds against `c11ce2cc3` improve cold build-and-query from
11,359 ns to 9,321 ns (1.219x), with median peak RSS 10,804 versus 11,680 KiB.
Against the original short-protocol baseline, the combined rank-map and dense
directory changes are 2.288x faster.  The existing rank-map A/B driver produced
the TSV; the dense checker uses a 1.10x time and 1.15x RSS gate.

```sh
papers/complete-repair-ports/ergodis/scripts/check-contextual-dense-cost-evidence.sh
```

- dense-cost checker: `5c005b6cf06d7c116e5147eb14819f87a776c1b0b6bcc0deed9f6583efee4c5b`, 757 bytes;
- dense-cost TSV: `892b58ccaf095d78d6cb637b24ffcab2f36dcf257ac2d9ae60eb302c3f7be6d7`, 410 bytes.

Commit `d46b17ab3` fuses label formation and dense lookup.  When every required
table has an admitted dense directory, the kernel computes the mixed-radix
label index directly and never materializes or rereads `block_data`; the exact
sparse/hash fallback is unchanged.  Seven paired rounds improve 9,308 ns to
5,640 ns (1.650x), with median peak RSS 11,816 versus 11,856 KiB.

Commit `d251f1cc3` then specializes the field-order-two projection and label
kernels to XOR row accumulation.  The branch is constant after monomorphization
and all other fields retain generic finite-field arithmetic.  Seven paired
rounds improve 5,635 ns to 4,542 ns (1.241x), with median peak RSS 10,812 versus
11,804 KiB.  Across the four paired rank-kernel stages, the multiplied median
speedup is 4.67x; full Criterion medians move from 22.053 us to 4.515 us
(4.88x).

```sh
papers/complete-repair-ports/ergodis/scripts/check-contextual-fused-dense-evidence.sh
papers/complete-repair-ports/ergodis/scripts/check-contextual-binary-evidence.sh
```

- fused-dense checker: `533b332518851ef7c07faa1de023470fdd7cf2767ee9afbf4af2fa30ae31d865`, 759 bytes;
- fused-dense TSV: `3c4e5e97b2613901fd9594304fbca7c686e43ce891d8e7665339a4f858c51be6`, 404 bytes;
- binary checker: `2054a4d17a56a7fba5680bf56d1e0e084e217dac72678d4b3dbf2a2e69ae553e`, 757 bytes;
- binary TSV: `4cc0e9194a7ac9c190b76b64034b5acee6a95e7207d31fd9f747527eb076b94c`, 403 bytes.

Commit `e595a7c0d` packs the dense directory into one `u32` allocation: `N`
cost words followed by a `ceil(N/32)`-word presence bitmap.  This represents
missing labels separately from values, retains the complete `u32` cost range,
and reduces admitted payload from 8 bytes per label to asymptotically 4.125.

Commit `20654574b` transfers C947's scalar-demand image theorem into the public
span API.  `CanonicalTargetImage` is an opaque canonical column-space basis
tagged by field and ambient dimension.  Callers can normalize a demand once and
reuse it across exact span queries without repeating transpose and elimination;
coefficient-aware presentations remain untouched.

The complete theorem-to-compiler work order, classical-corollary framing, and
negative boundaries are recorded in
`notes/2026-08-28-c985-ergodis-portfolio-theorem-leverage.md`.
