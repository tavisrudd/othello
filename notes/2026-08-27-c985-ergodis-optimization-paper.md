# C985 Ergodis exact algebraic optimization paper

**Lane:** `complete-ports`

**Status:** IN PROGRESS; COMPILER/BOA PERFORMANCE WINDOW

**Date:** 2026-08-27

## Live work plan, 2026-08-30

This is the authoritative checklist for the current C985 campaign; update it
as each coherent tranche lands.

Evidence references in this memo must be durable: identify the tracked patch
or Git commit that reproduces a comparison.  Never cite a local cached
executable (including anything under `~/.cache`) as a retained control; those
files are disposable and may be deleted at any time.

1. **Done — reusable theorem kernels.** Mine post-C1000 reports and import only
   cross-domain kernels with exact replay boundaries. Current inventory and
   validation: `2026-08-30-c985-post-c1000-ergodis-kernel-mining.md`.
2. **In progress — core performance-contract remediation.** Close allocation,
   iterative traversal, Tiger layout, CSS publication/worker ownership, and
   one-/parallel-mode measurement gaps under C1017. CSS contention-free
   controller fan-out, separate pulse/no-pulse kernels, exact coalescence
   controls, and commit-pinned counter/RSS A/B are complete and accepted;
   the clean miss costs 0.50% cycles/candidate and 0.82% wall while removing
   2.20% of instructions. CSS workspaces/results are now preallocated in
   exclusive 16x coarse lanes before enumeration; the one-lane-per-thread
   imbalance and direct-slice codegen controls are rejected. Current next slice
   now has a test-only cross-thread allocator gate around the actual compact
   and wide Rayon partition loops; allocator, reallocator, and deallocator
   counts are all zero on every participating worker, while production builds
   contain no observer. The measured clean-miss codegen pathology is also
   repaired: representing each fixed-capacity frame stack as `Box<[Frame]>`
   instead of `Vec<Frame>` removes unused capacity metadata while preserving
   contiguous indexing. On the exact-work BB360 clean miss it removes 3.14%
   of instructions and 1.80% of cycles (`t=10.15`); BB288 improves 2.40% in
   1T cycles and 3.88% in 12T cycles/candidate. The audited CSS root/frame/
   result records, alignment frame, sparse selector term, and observational
   separator node now have explicit representations and compile-time size and
   alignment contracts; same-work A/B is instruction-neutral in 1T and 12T.
   The first executable private registry now covers eleven principal public
   kernels across allocation, layout, correctness, single-/parallel counters,
   and contention; it verifies every referenced source/evidence path and fails
   closed rather than omitting weak rows. Its shared test-only allocator now
   measures real worker-local regions without entering production builds. The
   compact/wide CSS Rayon partitions and iterative QC trapping/stopping DFS
   both report exactly zero allocation, reallocation, and deallocation; QC has
   no frame record to pad because its state is scalar plus presized contiguous
   slices. The iterative orbit-product loop now passes the same real-loop gate
   on a fully exhausted correlated-residue instance, including dead-memo
   insertion; its option, family, residue, dead-memo, and traversal records all
   have exact compile-time layout assertions. Generic root execution now gates
   the callback region itself in serial and Rayon modes and records zero events
   on every participating thread. The executor owns no concrete worker/output
   layout; those remain kernel contracts, while its `RootOrdinal` layout is
   exact. The census now also registers Hall matching/deficiency extraction
   and exact integer-moment enumeration. Their actual iterative regions both
   pass the shared zero-event allocator gate; each uses fixed typed arrays
   rather than a heap-grown frame stack. Existing executable gates and exact
   layout contracts now also register character-sum census, dense/sparse
   successive selection, the campaign plan VM, and verified semantic-symmetry
   anchor evaluation. Current next slice is closing the remaining substantive
   ordered-front and ZDD allocation/growth failures rather than mistaking an
   incomplete registry for compliance.
   Sparse scheduling has begun its substantive repair: because a layer's new
   witness nodes cannot yet have descendants, the solver now compacts exactly
   the nodes referenced by the Pareto-retained frontier before publishing the
   layer. This removes 2.04% of instructions on a 688,212-state case and 2.40%
   on a 4,144,127-state case at identical transition counts and checksum, with
   effectively unchanged RSS. Cycles were noisy on the shared host and no
   cycle-speedup claim is made. A side-predecessor representation that cut
   instructions further but raised RSS about 22% was measured and rejected.
   The sparse scheduler now owns a reusable two-front workspace and an
   epoch-stamped eight-byte bucket directory. Its additive load fingerprint
   replaces a full hash per transition with one addition while retaining exact
   full-vector collision checks. Warm sequential and Rayon solve layers record
   zero allocation, reallocation, and deallocation under a measurement-ID
   allocator gate that is robust to concurrent tests. Seven paired rounds on
   the 688,212-state fixture improve cycles 1.431x (`t=10.30`), instructions
   1.051x, wall time 1.425x (`t=9.08`), and RSS 1.242x; three paired rounds on
   the 4,144,127-state fixture improve cycles 1.164x (`t=6.93`), instructions
   1.025x, wall time 1.171x (`t=7.52`), and RSS 1.350x, with identical exact
   work, checksum, and witness. Sparse Pareto parallelism is result-stable
   through 12 threads but time-neutral because serial expansion dominates, so
   no parallel speedup is claimed. The frozen ordered-resource evaluator now
   precomputes reachable-local transition indices and exact last-consumer
   release edges, then best-fit assigns reusable payload/span slabs from warm
   capacity hints. Both the witness payload and its eight-byte `FrontSpan`
   metadata therefore scale with peak live sorts rather than total reachable
   classes, and the guarded warm DAG loop performs zero allocation,
   reallocation, or deallocation; only returned-front boxing remains outside
   the solve region. Nine alternating same-core rounds on a 16,384-class DAG
   improve cycles 1.464x (`t=14.92`), instructions 1.422x, branch misses
   2.830x, and wall time 1.495x (`t=16.13`) at identical checksum and peak-live
   work. On a 131,072-class control the final candidate is 1.459x faster and
   uses 11,836 KiB versus 11,552 KiB baseline RSS, closing the earlier 9% span
   metadata regression to 2.5%.
   The ZDD closure now has bounded iterative machines for union, join,
   upward-closure avoidance, and minimalization; counting, reliability DP,
   and test enumeration are iterative as well. Frame capacities are the exact
   application variable count rather than the global 256-variable format
   limit, all hot records have asserted layouts, and a 256-level regression
   exercises the hard bound. The actual 12-level Ceph closure loop records
   zero allocation, reallocation, and deallocation after setup. Node/link
   arenas and the fixed unique table never grow in an operation; an
   underestimated cold hint aborts without allocation and restarts through an
   outlined geometric retry. Post-closure reliability analysis has a separate
   cold phase boundary: if it needs derived nodes beyond the solve arena, it
   grows and rebuilds outside the guarded closure, then restarts its iterative
   DP. Seven paired final runs preserve exact operations, nodes, checksum, and
   supports. The 256-support fixture improves cycles 1.036x (`t=2.42`) and
   wall 1.039x (`t=2.01`) while removing 1.053x branches and 1.432x branch
   misses. On the deeper 4,096-support fixture the point estimates improve
   cycles 1.038x and wall 1.032x, but timing is noisy (`t=0.58/0.47`); branches
   and branch misses fall 1.055x and 1.060x. Eleven isolated deep RSS pairs
   measure 2,260 KiB baseline versus 2,616 KiB candidate: a 356 KiB text and
   workspace cost, material proportionally but small in absolute terms. The
   durable implementation and recorded measurements are in commit `aec3b4abe`.
   The sparse scheduler's parallel gate is now resolved by a negative
   crossover result rather than a forced speedup. Its 688,212-state and
   4,144,127-state controls show no material 1-to-12-worker gain because serial
   state expansion and directory construction dominate. The public parallel
   compatibility APIs therefore select the allocation-free serial sparse
   specialization, while adaptive dense scheduling retains its separate
   parallel kernels. This deletes all sparse worker writes and false-sharing
   edges. Seven standard old/new pairs are neutral to slightly favourable at
   both 1T and the 12T API; three large pairs have a noisy 2--3% candidate point
   cost (`t=-0.84/-1.17`) with identical work, instructions, branches, and
   output. The durable implementation and recorded measurements are in commit
   `f71e32422`. The private
   observational refiner itself has no public parallel kernel: its split and
   multiway engines mutate one exact quotient/worklist in dependency order and
   create no worker-written state. Those two registry cells are therefore
   correctly not applicable rather than unsupported passes. The private
   binary linear-code kernel now has a retained exact algorithmic control as
   well. On a deterministic full-rank binary `20 x 384` presentation, reflected
   Gray updates and binary-subset recomputation both scan all 1,048,575
   nonzero words and return minimum weight 149. Nine rotated 20-scan pairs give
   recompute/Gray ratios of 13.542x cycles, 4.760x instructions, 11.989x
   branches, and 13.462x wall, with exact candidate and answer parity. The
   durable benchmark and recorded measurements are in commit `514d43040`.
   The alignment controller now has its missing full-search counter control as
   well. Seven rotated budget-12 pairs traverse the identical 309,777-state
   rooted DFS with zero notifications; idle/baseline is 1.000965x cycles,
   1.000274x instructions, and 1.004963x counter-enabled time (`t=0.95`). This
   supports no measurable control-plane overhead at the complete search
   boundary. The durable benchmark and result are in commit `6a4468b10`. The
   private registry now records 61 pass, 7 open, and 34 not-applicable cells. Current
   generic root executor now has a direct-loop control too. Nine rotated pairs
   over 105,906,176 lightweight root-rounds give generic/direct ratios of
   0.999616x cycles, 0.956716x instructions, and 0.998684x wall, with exact
   checksum and work parity; a 423,624,704-round heavier callback control is
   also cycle/wall neutral. The durable benchmark and result are in commit
   `f3596c37d`. The private registry now
   records 62 pass, 6 open, and 34 not-applicable cells. Current next slice:
   the Hall kernel now has a non-straw-man adjacency-list control using the
   same iterative augmenting-path algorithm. On 512,000 deterministic
   saturated `48 x 48` graphs per arm, the production bitmap is 1.090x lower
   in cycles at 25% edge density despite more instructions, because branch and
   cache misses fall 1.764x and 64.4x. At 5% density adjacency lists are 1.065x
   faster, identifying a genuine representation crossover and a later hybrid
   API opportunity. The durable benchmark and result are in commit
   `5e5707ba5`. The private registry
   now records 63 pass, 5 open, and 34 not-applicable cells. The next two
   theorem kernels now have retained exact controls as well. On 1,000 solves
   of the degree-12 C1000-derived spectrum instance, convex moment envelopes
   preserve all 68 solutions and the exact checksum while beating flat
   iterative nondecreasing enumeration by 472.620x cycles (`t=2611.87`),
   384.695x instructions, and 477.223x wall (`t=960.83`). On 65,521,000 exact
   field points, a precompiled finite-difference character recurrence preserves
   the Horner census checksum while improving cycles 3.502x (`t=380.69`),
   instructions 1.117x, and wall 3.479x (`t=307.39`). Median RSS is neutral in
   both controls. The durable benchmarks and results are in commit
   `f34b15b5f`. The
   private registry now records 65 pass, 3 open, and 34 not-applicable cells.
   The selector representation crossover is now retained too. Across 500,000
   complete selections per arm, sparse terms beat the dense tensor by 33.931x
   cycles at 1.024% density, while the dense tensor beats sparse terms by
   1.521x cycles at 100% density. Both extremes preserve the exact assignment,
   five partial tests per solve, work, and checksum; nine rotated pairs have
   `t=1801.52` and `t=174.45`. The durable benchmark and result are in commit
   `ae20d1f38`. The private
   registry now records 66 pass, 2 open, and 34 not-applicable cells. Current
   plan-VM gate is also closed with a concrete optimization. Moving the
   optional tracing decision outside the opcode loop and monomorphizing traced
   and untraced execution improves the ordinary evaluator by 1.153x cycles
   (`t=21.17`), 1.177x instructions, and 1.150x wall (`t=21.99`) across
   65,536,000 exact row evaluations. A branchless handwritten equivalent is
   still 16.87x cheaper in cycles, leaving fused superinstructions as a
   measured successor rather than hiding interpreter overhead. The durable
   benchmark and result are in commit `10e8e1ec5`. The private
   registry now records 67 pass, 1 open, and 34 not-applicable cells. Current
   semantic-symmetry gate is now closed too. On a verified 64-coordinate
   support model with four invariant 16-cycles, one scan per certified orbit
   replaces one scan per coordinate while preserving the exact minimizer,
   work count, and checksum. Across nine rotated million-solve pairs,
   all-anchors/orbit-cover is 14.288x cycles (`t=486.69`), 16.747x
   instructions, and 14.288x wall (`t=491.99`), close to the theorem's ideal
   16x reduction after fixed costs. The durable benchmark and result are in
   commit `50333cc19`. The private
   registry now records 68 pass, zero open, and 34 not-applicable cells.
   Current next slice: run the strict end-to-end registry audit, then use the
   measured 16.87x plan-VM fusion gap to select the next C985 optimization.
   The strict audit passes at 68 pass, zero open, and 34 not-applicable cells.
   The first general VM fusion slice is now landed: after validation, both
   operand orders of each field/constant comparison compile from three source
   opcodes to one 16-byte superinstruction, while the unfused bytecode remains
   available for source-granular traces. Across nine rotated 65,536,000-row
   pairs this adds a further 1.806x cycles (`t=12.96`), 1.648x instructions,
   and 1.789x wall (`t=13.66`) improvement at exact outcome parity. The
   branchless handwritten residual is 10.51x cycles, so the next measured
   optimization frontier is Boolean/arithmetic fusion or a bounded native-code
   plan adapter, not more interpreter micro-tuning. The durable implementation
   and result are in commit `165c0d2a1`.
   Application translation is now measured against the exact public-source
   snapshot in the standalone mirror: its `ergodis/src` tree matches monorepo
   commit `056acfcf` (2026-08-27). The first same-harness counter sweep exposed
   a 2% QC-LDPC regression. Bisecting every intervening `applications.rs`
   revision showed that the iterative-DFS safety conversion let ThinLTO inline
   the general DFS into `search_trapping_set`, expanding the function from
   6,371 to 8,127 bytes even when the degree-two theorem returns before search.
   Marking only the iterative engine `inline(never)` restores a 6,476-byte
   theorem entry point and preserves the allocation-free, nonrecursive DFS.
   Against the pre-fix current build, fifteen quiet-core pairs improve the
   degree-two application path 1.046x cycles and 1.042x wall
   (`t=17.45/17.00`); nine pairs on an instance that actually enters DFS improve
   1.106x cycles and wall (`t=10.84/11.00`) at identical work and checksum.

   The final mirror comparison links both revisions to the byte-identical old
   benchmark harness and preserves work, states, and checksums on all eight
   README workloads. Corrected seven-round fresh-process measurements remain
   startup-dominated and establish no suite delta: old/current is 0.972x cold
   (`t=-1.21`) and 1.011x for eight-solve warm batches (`t=0.66`). Nine-pair
   long-loop counters on a quiet physical core expose the kernel delta:
   old/current is 1.012x cycles (`t=4.05`) and 1.011x wall (`t=3.72`) across 72
   pairs. Vector node span improves 1.047x wall, GPU checkpoint 1.050x, repair
   DAG 1.010x, and QC-LDPC 1.003x; Ceph, Azure, and Hamming-outer are neutral.
   The represented tower has a small 0.994x wall point loss, about six
   microseconds per thousand solves, with no instruction/work change. No
   material application regression remains. A sweep using today's enlarged
   benchmark dispatcher had shown a false 2--3% suite loss; holding the harness
   byte-identical removes benchmark-only parser growth from the application
   result. The durable mirror comparison is commit `8a29e2417`; the QC
   outlining correction is commit `cc52ab0a7`. Full
   all-target/all-feature tests and strict clippy pass. Current next slice:
   continue the measured plan-VM Boolean/arithmetic fusion frontier or select a
   theorem kernel with an immediate application adapter.
   The next VM slice removes a hidden fixed cost rather than adding another
   domain opcode. The compiler already proves stack discipline and owns both
   private opcode streams, so the evaluator now stores its 64 fixed slots as
   `MaybeUninit<i64>` and initializes exactly the slots reached by the plan;
   it no longer clears 512 bytes for every row. Exhaustive opcode-shape tests
   compare traced and fused-untraced evaluation, reach the validated maximum
   stack depth, and preserve checked-arithmetic failures. Across fifteen
   rotated pairs of 98,304,000 exact row evaluations, the candidate removes
   13.96% of instructions and 15.91% of branches at identical work and
   checksum. Host frequency changes bifurcate cycle timing, so the retained
   claim is deliberately conservative: every pair is at least 1.170x faster
   in wall time and the median is 1.187x; no geometric-mean timing claim is
   used. The remaining branchless-direct residual is 8.852x cycles and 8.838x
   wall (`t=725.10/668.92`), down from 10.51x. The durable implementation and
   recorded controls are in commit `56276678b`.
   Current next slice: profile that residual by opcode mix, then choose a
   bounded Boolean/arithmetic superinstruction family only if it generalizes
   beyond the synthetic residual; otherwise move to the first application
   adapter for an already-landed theorem kernel.
   The residual profile attributes 94.02% of sampled cycles to the evaluator;
   comparison fusion has reduced the representative eleven-op source program
   to three comparison leaves and two Boolean connectives. A general exact
   response compiler now recognizes every pure predicate over at most six
   field/constant comparison occurrences, evaluates its Boolean circuit once
   over all 64 assignments at compile time, and stores the result as one
   `u64` truth table. Runtime evaluation forms the six-bit-or-smaller leaf
   assignment and performs one table lookup: there is no operand stack,
   connective dispatch, allocation, or benchmark-specific expression match.
   Larger predicates and mixed arithmetic retain the ordinary evaluator.
   Source bytecode remains intact for granular traces.

   Against commit `56276678b`, with both binaries rebuilt by Rust 1.93.1,
   fifteen rotated 131,072,000-row pairs improve cycles 1.634x (`t=79.14`),
   instructions 1.798x, branches 2.095x, and wall 1.667x (`t=70.69`) at exact
   work/checksum parity. The direct-code residual is now 5.595x cycles and
   5.603x wall (`t=169.59/132.10`). Exhaustive three-leaf values, every
   comparison and operand order, Boolean connectives, constant predicates,
   the six-leaf boundary, seven-leaf fallback, tracing, and the existing
   allocation gate all pass. The durable implementation and recorded controls
   are in commit `7ac28c4ac`. Current next
   slice: stop interpreter-only tuning and select an existing theorem kernel
   whose first real application adapter can turn a kernel win into an
   end-to-end application win.
3. **In progress — C1018 campaign-friction tranche.** Land deterministic CSS
   prefix shards first so multi-hour radii survive session boundaries and can
   be distributed without changing the proof obligation. The public API and
   CLI now expose a thread-count-independent modulo partition, evidence records
   distinguish partial shards from global results, and the README states the
   `large-css,parallel` release feature contract. A checked-in validation
   command now compiles default, `parallel`, `large-css`, and combined builds,
   then replays the compact/wide shard-union regression; all four combinations
   and the full 341-test all-feature library suite pass. Large-CSS v1 artifacts
   now load across the 12-to-13-word
   internal support-width change, including the retained C1018 artifact, and BB
   generation is idempotent only when the existing bytes match. Reusable
   foundations now include table-backed runtime GF(p^h) arithmetic through
   order 256, static and runtime right-null-space APIs, allocation-free generic
   PG(d,q) rank/unrank, and bitmap-backed seeded generator closure that scans
   only reachable points. The private C1018 PRS driver now consumes the shared
   field and projective index, deleting its duplicate irreducibility, table,
   and PG indexing implementations; its q=8,r=3 census still returns the exact
   9/63/1 weight histogram. The closure engine now also offers a reusable
   pre-sized BFS workspace whose monomorphized callbacks reuse campaign-owned
   label/debt arrays as discovery state; the C1018 orbit census has migrated to
   it and remains byte-for-byte stable on the q=8,r=3 result shape. Next:
   counter/profile a larger orbit-closure wave.
   Keep tactical plane completion in
   `ergodis-private`; do not specialize the public core for C1018.
   The smaller linear-code gap is also closed: a compiled binary row-space
   enumerator uses one-row Gray-code updates plus packed POPCNT, has a measured
   zero-allocation scan gate, and replaces the C1018 transversal driver's
   materialized `2^k` span when computing minimum nonzero check weight. The
   create-only `binary_linear_distance` evidence CLI makes this a first-class
   public mode rather than only a library primitive.  Its next exact backend is
   now implemented: ranks at least 24 compile disjoint systematic information
   sets (with an 8 MiB packed-basis cap), and a conservative candidate model
   selects fixed-weight Brouwer--Zimmermann only at a predicted 8x advantage.
   Gosper masks update the running word by their XOR delta and replace the
   power-of-two division by a trailing-zero shift, so the hot loop is
   iterative, pre-sized, and allocation-free.  Deterministic ranks 4--10 agree
   with Gray enumeration; a rank-24 doubled-identity gate closes at weight two
   after 48 candidates; and both auto and explicit paths retain witnesses.
   Hardware dispatch is outside the loop and selects POPCNT/AVX2/BMI kernels.
   On the deterministic rank-24, length-72 fixture, BZ checks 38,850 candidates
   per solve versus Gray's 16,777,215.  Seven CPU-2 interleaved counter rounds
   over ten solves put optimized-Gray/BZ at 66.500x wall (`t=111.13`), 73.603x
   cycles (`t=122.42`), 163.152x instructions, and 139.899x branches in BZ's
   favour, with the same minimum 15.  BZ incurs 3.90x as many branch misses,
   but only about 50,349 across ten solves.  The rank-20 control does not pay
   for the larger compiler path; versus retained commit `c97892222`, seven
   paired 100-solve rounds put baseline/candidate at 1.276x wall (`t=6.73`),
   1.287x cycles (`t=7.42`), 1.210x instructions, and 1.286x branches.  Branch
   misses are statistically unresolved (0.990x, `t=-1.94`).  An earlier
   popcount-only dispatch changed Gray code generation and failed that gate; it
   was rejected before the full AVX2/BMI target restored and improved the
   control.  The implementation, benchmark fixture, and tests are commit
   `0c86ef654`; the retained measurements are the tracked summary above.
   The random CSS upper-bound backend now adds pre-sized OSD-2 combinations.
   On a diagnostic BB756 run at target 36, OSD-2 found an independently replayed
   weight-36 logical support in 0.621 s after 1,406 completed trials; the same
   seed/order-1 control exhausted 100,000 trials in 21.656 s without a hit.
   This is diagnostic application evidence, not yet a multiround performance
   claim or a replacement for BP reliability ordering.
   The private tactical-completion spike has started in
   `ergodis-private::tactical_completion`: it validates integral 2-design
   parameters `(v,k,lambda,p)`, derives replication/block counts, generates the
   level-2 residual-conjugacy representatives iteratively. The adapter check
   against the pre-existing untracked plane/hyperoval driver passes, but that
   foreign campaign file remains unstaged for its owner. Orbit-matrix equations and the iterative completion
   stack remain private follow-on work; neither is being guessed into public
   core from a single campaign.
4. **Pending — robustness and negative-claim assurance.** Complete malformed-
   input, feature-matrix, exact replay/parity, zero-allocation, bounded-memory,
   and deterministic parallel evidence gates.  The proposed assurance ADR
   `2026-08-31-ergodis-correctness-assurance-adr.md` is adopted here as a
   prioritization input, not verbatim current-tree ground truth: its largest
   stated symmetry gap has since been closed by the verified CSS anchor
   transversal described in item 8, and runtime `SmallField`, null-space, and
   generic projective/orbit APIs have also landed.  The remaining high-value
   assurance order is: (a) a checked shard-coverage ledger keyed by input,
   binary/schema, shard count/index, and completion status, with refusal to
   promote an incomplete or mixed union; this is now landed in v5 native
   evidence plus `css_distance_shard_ledger`.  The ledger binds exact input and
   executable BLAKE3 digests, optional compiled-artifact digest, selected
   kernel, radius, completed rounds, result consistency, per-round candidate
   fingerprints, and each source-record digest.  C1030 finding 21 later found
   that the wide sharded frontier was incumbent-dependent across multiple
   anchors, so presence of all shard indices was not by itself a general cover
   proof.  Commit `8d71c3b51` makes the prefix bound shard-independent while
   retaining a shard-local incumbent only after the positional partition.  A
   post-fix three-way BB288 radius-2 replay again aggregates exactly 30
   candidates and a complete no-witness conclusion.  The earlier BB288 result
   was also in the benign witness-free regime, so its frontier never diverged;
   the result survives, while the former generic coverage wording did not.
   missing, duplicate, mixed-identity, interrupted, and malformed-witness
   controls fail closed.  Items (b)--(d) have also landed: a planted weight-two
   logical witness is recovered from every position of a verified eight-cycle;
   every computed all-ones kernel-parity functional is replayed directly
   against all packed columns during cold compilation; and 64 deterministic
   small random instances agree with brute force across compact/wide,
   serial/parallel, and three-way shard-union searches.  That differential test
   exposed an overflow-check foot-gun in the optional parity-adjusted completion
   lower bound at `(budget, adjustment) = (0, 1)`.  Release wrapping had only
   made the bound loose (extra work, never an invalid prune), but checked builds
   panicked.  The accepted repair spells out `wrapping_sub` with the one-sided
   proof.  Saturating subtraction, algebraically moving the adjustment, and a
   terminal early branch were correct but rejected after regressions of roughly
   5--6%, 1.15% instructions, and 5% respectively.  Seven commit-pinned
   interleaved counter pairs for the accepted form show instruction ratios of
   0.999998x at 1T and 1.000029x at 12T versus the prior release code; timing
   moved noisily in opposite directions, so the hot implementation is accepted
   as operationally neutral.  The accepted fix and recorded comparison are in
   commit `c97892222`.  Next is (e), a measured
   campaign release profile with overflow checks rather than silently assuming
   its cost, followed by targeted pruning-predicate mutation controls.
   Premise certificates and independent statement-level re-derivations are the
   near-term architecture.  SAT/PB/VIPR proof pipelines are reserved for
   flagship frozen claims where their encoding is independently justified;
   proof logging inside the allocation-free CSS loop and full functional
   verification of the optimized Rust producer remain deferred.  Any future
   certificate schema should preserve a path to compositional leaf-coverage or
   VeriPB-style checking without imposing that cost on ordinary solves.
   C1028's order-four chain-ring instrument test adds a separate API-assurance
   boundary.  It reproduced the published `Z4` and `F2[u]/(u^2)` cells and then
   demonstrated why equal cardinality is not an algebra identity: interpreting
   either ring's byte encoding as `GF(4)` gives confident wrong row-module,
   membership, projective, and distance answers.  The public implementations
   are field-typed, but their byte-valued boundary cannot detect provenance, so
   their documentation now states explicitly that `SmallField::new(2, 2)` is
   only `GF(4)`.  Do not generalize Gaussian elimination by weakening the
   `FiniteField` bound.  A real reusable ring tranche must instead introduce an
   explicit algebra descriptor and unit/nonzero split, then Howell/Smith module
   forms, unimodular Hjelmslev indexing with neighbour structure, a table-driven
   weight functional, and module-word enumeration.  Test `Z4` and
   `F2[u]/(u^2)` together so same-order substitution cannot pass.  Keep the
   C1028 driver and ring-specific research in `ergodis-private`; only the
   algebra-neutral interfaces and independently verified kernels qualify for
   public core.
5. **In progress — typed plan/theorem authoring language.** Commit `824a947a8`
   lands the first complete vertical slice for scalar steering plans.  A
   bounded textual parser accepts ordinary infix arithmetic, comparisons and
   Boolean connectives plus `abs`, `min`, `max`, and `select`; it lowers through
   the existing `ExpressionPlanSpec` typed AST and the existing VM compiler,
   not a parallel evaluator.  Canonical formatting has parse/format/parse
   identity, and equivalent expression JSON and text produce byte-identical
   serialized lowered plans.  Input bytes, tokens, names, AST nodes, and depth
   are bounded.  `ergodisctl try` and `apply` now sniff bounded text or JSON;
   JSON/JSONL remain the protocol, persistence, bulk-batch, and diagnostic
   representations.  Full all-feature tests, strict all-target/all-feature
   clippy, formatting, and documentation pass, and no solve-loop code changed.
   Next extend the same lexer, names, scalar expressions, scopes, canonical
   formatter, and provenance syntax to `match / reduce / canonicalize` recipes
   and injected theorem fragments.  Do not create a second mini-language.  The
   accepted algebra and constraints remain
   `2026-08-30-ergodis-semantic-mining-engine-adr.md`.
6. **In progress — daemon-owned evolve.** Retain bounded streamed evidence,
   lineage/outcome deduplication, and exact cascades; next add durable replay,
   selection, and cross-campaign learning without entering solve workers.
7. **Done for current tranche — SOTA audit.** The primary-source comparison and
   priority order are in
   `2026-08-30-c985-ergodis-evolve-sota-literature-audit.md`; refresh it when a
   new evolution mechanism changes the comparison.
8. **In progress — solver-SOTA imports and application translation.** Integrate
   the ranked, gated import survey in
   `2026-08-31-c1027-solver-sota-import-survey.md` without turning Ergodis into
   a generic solver or weakening its certificate product. The current public
   application gate is the official OR-Library RCSP family. Its first K=1
   instance exposed zero-resource cycles; exact zero-resource shortest closure
   now supplies positive-resource macro-transitions, and the class-local
   objective returns cost 131 with an independently replayed four-arc witness.
   The generic reverse Pareto evaluator scans 500,354 transitions in about
   1.9 ms, while an expanded-state Dijkstra reaches the same certified result
   in about 9 us. The resulting indexed forward backend is now implemented:
   its worker-owned binary heap, distances, predecessors, and replay arena are
   presized; the guarded search loop allocates nothing; and an independent
   verifier replays every generator and the terminal output cost. On `rcsp1`,
   a long warm run takes 4.72 us per solve versus 1.21 ms for reverse Pareto,
   a 256.6x gain. Seven counter pairs put forward/direct at 3.12x cycles,
   2.94x instructions, and 4.03x branches; the direct control's long-run wall
   time is about 2.23 us.
   All twelve official K=1 instances return the same cost and replayed path as
   the direct solver. Across those instances the quotient has no state
   compression and 10,000-solve forward/direct wall-time ratios range from
   1.34x to 7.42x;
   thus this remains an honest negative application gate, but a successful
   reusable algorithm-selection import. Next use counters to price the
   remaining gap and retain the example as a documented boundary/control, not
   as an Ergodis application-speed claim. The durable implementation and suite
   result are in commit `ff963f318`.

   After that gate, import C1027's highest measured or cheapest exact items in
   this order: (a) CSS option-count histograms and an order-independence proof
   before MRV branching; (b) multi-order greedy packing, which is sound by
   construction; (c) a verified static incumbent support for shards before
   any dynamic fan-out; and (d) BP-OSD logical-class breadth before a deeper
   ISD mechanism. Then price Brouwer--Zimmermann only for the small-code
   `linear_code` regime, orbit-verified anchors, and capacitated Hall/min-cut
   certificates. Canonical augmentation, a bounded syndrome transposition
   cache, and bit-sliced extension-field elimination remain measurement-gated.
   Explicit non-imports are full CDCL, generic MIP/CP backends for certificate
   kernels, treewidth/ZDD search on expander-like instances, block Wiedemann at
   current dimensions, and Hopcroft--Karp in the nanosecond-scale Hall loop.

   Current-tree reconciliation changes that order slightly. Static and dynamic
   incumbent fan-out are already present as worker-local relaxed mailboxes plus
   controller fan-out, with the guarded 4,096-candidate pulse; C1027's item
   2.1.2 is therefore an audit/documentation item, not new implementation. The
   first isolated experiment was the sound-by-construction second greedy
   packing order, measured against the checked-in BB288 input. At radius 16,
   forward-plus-reverse greedy removes 22.3% of candidates but regresses warm
   wall time by about 10%; reverse alone adds 6.4% candidates and is about 11%
   slower. Both variants are therefore rejected and the production loop is
   unchanged. A conflict-degree-sorted single order remains a distinct cold-
   compile experiment rather than justification for paying twice per bound.
   The subsequent full-MRV probe falsified C1027's tentative canonicity
   argument: on BB288 at radius 16 it visits 4,021 zero-syndrome supports where
   the production order visits 4,115, despite both returning no nontrivial
   witness. The coordinate-forbidden state is therefore not invariant under a
   dynamically changing check order. MRV is theorem-blocked until a richer
   canonical state or a disjoint decomposition is proved; the experimental
   code was reverted rather than allowing a plausible partial exhaustion into
   core.

   Orbit-verified anchors are now implemented as the first positive C1027
   import. A reusable flat permutation action is range/bijection checked by the
   existing orbit compiler. The CSS verifier independently checks preservation
   of `rowspan(H)` and `rowspan(H)+rowspan(L)`, then requires exactly one input
   anchor per computed coordinate orbit; it does not assume free or uniform
   orbits. `css_distance_native` accepts optional `coordinate_generators` and
   records whether anchors remain trusted input or are a verified transversal.
   On the checked-in BB288 presentation, the two bivariate translation
   generators verify exactly two uniform 144-point orbits represented by
   anchors 0 and 144. Thus the 144x anchor reduction in that application is now
   checked rather than asserted, with no change to the solve hot loop. The
   verifier and recorded application result are in commit `f26f076a8`.

   C1027's four missing general APIs are also now reconciled as already landed:
   runtime small prime-power fields, binary/runtime null spaces, generic
   `PG(d,q)` rank/unrank, and seeded allocation-free generator closure. Their
   survey entries remain useful provenance, but no duplicate implementation is
   planned.

   The upper-bound gate is now positive, with an important correction to the
   survey's model.  The Rust systematic-kernel OSD trial already evaluates the
   logical syndromes of every induced kernel basis row and admitted pair, so it
   is intrinsically broad over nonzero logical classes rather than fixed to one
   sampled class as the external BP-OSD driver was.  On BB756, order-2/window-96
   finds an independently replayed weight-34 logical support after 75,944
   completed trials in 9.295 seconds on 12 workers, reproducing the published
   upper bound; a 500,000-trial target-32 run takes 84.736 seconds without a hit
   and is only a heuristic miss.  This does not
   yet improve the mathematical bound, but it decisively justifies extracting
   the binary-local implementation into reusable upper-bound machinery.  The
   first extraction tranche also adds independent witness replay and an opt-in
   best-effort mode, and replaces the per-trial shared counter/winner mutex by
   worker-local outcomes with cold deterministic reduction.  The run-constant
   choice dispatches to separate const-generic loops; the real repeated trial
   loop records zero allocations, reallocations, and deallocations.  Seven
   interleaved no-hit counter pairs preserve exact requested/completed work and
   result: baseline/candidate is 1.02683x instructions at both 1T and 12T,
   1.01516x cycles at 1T (`t=11.60`), and 1.03928x cycles at 12T (`t=1.91`,
   noisy).  Five wall/RSS pairs give 1.02002x at 1T (`t=6.51`, 2,328/2,344 KiB
   median RSS) and 1.01365x at 12T (`t=2.09`, 2,580/2,724 KiB).  Thus the
   contention removal is accepted.  The implementation, durable evidence
   schema, and recorded comparisons are in commit `ff987c3b3`.

   The reusable public extraction is now commit `648b8e7e3`.  It compiles
   packed physical constraints and logical observations once, exposes
   presized worker workspaces, performs allocation-free systematic-kernel
   order-1/order-2 trials, replays returned supports, and keeps parallel
   scheduling outside the core so workers share no mutable search state.  The
   CLI independently replays a support against the original sparse input.
   Best-effort now exhausts every assigned trial; the former shared stop bit
   could silently truncate that mode when another worker hit the target.
   Small free-dimension problems agree with an independent exhaustive oracle
   across 384 generated cases, and a measurement-ID gate observes two actual
   worker threads with zero allocation, reallocation, or deallocation.

   The first cross-crate build failed the performance gate: moving the formerly
   local worker behind a non-inlined public function added 11.7% instructions
   on identical BB756 no-hit work.  Commit `9abc56b0c` restores a flat
   slice/`usize` trial specification and marks the public entry points for
   cross-crate specialization.  Seven interleaved commit-pinned counter pairs
   against parent `ab69132af` now preserve exact work and null result.  At 1T,
   baseline/candidate is 1.036665x instructions, 1.066248x branches, and
   1.102489x cycles (`t=2.38`, noisy cycles).  At 12T it is 1.036667x
   instructions (`t=47330.98`), 1.066293x branches (`t=88954.28`), and
   1.052232x cycles (`t=19.69`).  Branch misses are effectively neutral at 1T
   and 0.17% worse at 12T.  This closes the extraction without hurting the
   existing application path.

   Revised next order after reconciling both 2026-08-31 inputs: (1) compare BP reliability
   ordering against random systematic OSD on identical class/trial budgets;
   add a Stern/Dumer collision stage only if that profile says elimination is
   no longer dominant; (2) land the negative-claim assurance floor above,
   starting with the shard ledger and parity-functional premise check because
   they protect every expensive lower-bound run without touching the hot loop;
   (3) implement Brouwer--Zimmermann only in `linear_code`, with a rank/rate
   crossover and Gray enumeration retained as the small-rank control; this is
   now landed in `0c86ef654`; (4) reject the proposed CSS subtree transposition
   cache before profiling: `(syndrome, budget)` is only sufficient for the pure
   completion bounds, not for the remaining search.  Branch options also depend
   on support and forbidden coordinates, while terminal acceptance depends on
   the logical observation.  A regression constructs equal-syndrome,
   equal-budget states with different option sets and a common zero-syndrome
   completion that is trivial from one state and nontrivial from the other.
   Full-state keys erase the hoped-for compression because canonical search
   already generates each support once.  A histogram of syndrome multiplicity
   therefore cannot justify subtree memoization; only memoization of a proven
   pure bound predicate remains sound, and its probe must beat the existing
   packed arithmetic/filter lookup before implementation; (5) add
   capacity-scaled Hall only when a real client accepts the corresponding
   min-cut/deficiency certificate; and (6) profile extension-field elimination
   before a bit-sliced `GF(2^e)` backend.  Look-ahead cubing remains behind the
   already-landed incumbent fan-out because the measured shard imbalance caps
   its upside near 1.6x.  Canonical augmentation remains private until its
   canonical-parent theorem is proved.  A conflict-degree-sorted *single*
   packing order is the only surviving cheap packing variant, but it is behind
   the assurance and upper-bound work because both tested two-order variants
   lost.  Full CDCL, generic MIP/CP replacement of certificate kernels,
   expander-unfriendly treewidth/ZDD methods, block Wiedemann at current sizes,
   and Hopcroft--Karp in the tiny in-loop Hall regime remain explicit
   non-imports.

   Step (6) is now closed as a measured negative for the motivating PRS
   client.  A source-attributed one-thread profile of the complete
   `q=64,r=5` census (17,043,521 projective points, 10,059 sampled cycle
   events) assigns no sample at the 0.01% reporting threshold to the
   Hankel/RREF source region.  Projective point rank/unrank accounts for
   23.76% of cycles, while the four runtime-field table/index source lines
   account for 20.62%; the latter cost is in repeated orbit matrix--vector
   action, not elimination.  C1030 finding 20 showed that commit `9305f95e6`'s
   private fixture was already `[I|R]`, so neither reducer performed
   elimination and the original equivalence/timing claim is withdrawn.
   Commits `8b7dc358f` and `2b2b3e39d` replace it with a guaranteed-full-rank
   non-RREF fixture, assert that both reducers actually mutate it, and bind the
   seed into every record.  The corrected 256-matrix-per-degree equivalence
   gate passes for degrees 3--8.  Seven seed-rotated `GF(64)` counter pairs
   reverse the isolated result: table/binary is 1.009912x cycles (`t=7.47`),
   1.010642x wall (`t=2.59`), 1.081415x instructions, and 1.528112x branches at
   `4 x 5`; at `8 x 9` it is 1.054166x cycles (`t=23.44`), 1.055951x wall
   (`t=10.50`), 1.133774x instructions, and 1.707273x branches.  Thus the
   specialized characteristic-two reducer wins in isolation.  It remains
   rejected for the motivating PRS application only because the independent
   end-to-end profile assigns elimination no sample at the 0.01% threshold;
   the old argument that its isolated upper bound also lost is invalid.  The
   next measured C1018 frontier remains orbit action plus projective
   rank/unrank.

   That next frontier is now resolved with a deliberately split admission
   result.  Commit `e3d03395a` adds the reusable opt-in core only:
   `BinarySmallField<H>` validates `GF(2^H)` once and removes the runtime radix
   multiply from table lookup, while `BinaryProjectiveIndex<H>` replaces
   base-`2^H` rank/unrank division with shifts and masks.  Degrees 3--8 agree
   with the generic field tables and projective index, malformed field/order
   pairings fail closed, the hot rank/unrank loop records zero allocator
   events, and the 8-byte arithmetic view plus 40-byte read-only index have
   asserted layouts.  Seven rotated `PG(4,64)` microkernel pairs, each with ten
   million unrank/three-action/three-rank rounds, put generic/specialized at
   1.156668x wall (`t=25.72`), 1.149073x cycles (`t=113.27`), 1.186957x
   instructions, and 1.222742x branches with identical nonzero checksums.

   The full application does **not** inherit that win.  The exact prototype is
   retained as `ergodis-private/c985-binary-prs-adapter.patch` in the same
   commit; it is not applied to the client.  On seven rotated one-thread
   `q=64,r=5` census pairs, generic/specialized is 0.954067x wall
   (`t=-24.36`) and 0.945398x cycles (`t=-46.56`) despite the specialized arm
   having generic/specialized instruction and branch ratios of
   1.184843x and 1.275831x.  Every arm
   produces the same normalized result digest.  Worse, the generic-trait
   adapter needed to host both arms changes default code generation: versus
   retained commit `6fec8e9fa`, old/refactored-generic is 0.969355x cycles
   (`t=-4.14`) and 0.957078x instructions.  The adapter refactor is therefore
   rejected and the C1018 source restored byte-for-byte.  Existing clients
   cannot regress; the public specialization is available only to a caller
   whose own end-to-end gate wins.  The next PRS optimization must reduce the
   orbit/hash critical path or compile a fused validated action without
   perturbing the generic worker, not merely delete arithmetic instructions.
9. **Done — bounded parametric certificate verifier.** C1029 demonstrated a
   genuine reach gap rather than a faster version of an existing kernel:
   Ergodis had no
   usable path for exact identities in `Z[t]`, finite congruence coverings, and
   their composition with a hash-bound residual witness layer.  Its private
   Erdős--Straus instrument certifies `2 <= n <= 10^8` with 540 exact families
   and 685 residual witnesses; an independent checker rejects ten targeted
   corruptions.  The reusable trust boundary is now commit `d0cf99bad`: a flat,
   iterative polynomial-expression DAG evaluates exact identities in `Z[t]`
   over `BigInt`; every family binds an exact `modulus*t + residue` class,
   coefficientwise half-line positivity is checked at its threshold, and a
   finite congruence cover is verified in
   `O(M + sum_family M / m_family)` marks rather than an `O(MF)` cross-product.
   SHA-256 and BLAKE3 payloads stream through a fixed 64 KiB buffer, and an
   explicit topological composition DAG requires exactly one typed leaf for
   every declared family and payload.  Aggregate limits cover polynomial
   nodes, coefficient slots, coefficient bits, algebra work, cover marks, and
   total payload bytes, so individually bounded objects cannot combine into an
   unbounded-memory certificate.  Malformed composition is rejected before
   bulk payload I/O.  The generator-backed Python differential fixture uses a
   coefficient above `i64`; exact acceptance, a broad fail-closed
   mutation/resource corpus, the full all-feature test suite, strict
   all-target/all-feature clippy, formatting, and public documentation all
   pass.

   The verifier intentionally assigns no authority to a domain-specific
   residual or scaling rule: it verifies the declared algebra, cover, payload
   binding, and composition shape only.  Feed this through the planned typed
   plan/theorem AST so text and protocol encodings lower to the same verifier.
   Generator heuristics, prime sieves, factorization policy, and the C1029
   family catalogue remain in `ergodis-private`.  The first public positivity
   rule is deliberately coefficientwise non-negativity plus a checked
   threshold; richer half-line positivity requires a separately certified
   root/Sturm kernel.  Later, discharge composition lemmas such as scaling in
   Lean rather than silently trusting prose.  This is the first
   characteristic-zero, infinite-family
   certificate product and a stepping stone toward theorem composition; it is
   not a request to put a generic sieve or CAS in the solve core.
10. **In progress — C1030 tactical correctness and root-cause safeguards.**
   Treat the independently vetted register in
   `2026-08-31-c1030-ergodis-audit-rootcause.md` as the authoritative defect
   input, including its round-2 findings 20--33, while retaining its warning
   that a single audit pass produces leads, not results.  The execution order
   is fixed:

   1. finish and commit the reusable binary-kernel/OSD extraction already in
      flight, but admit it only with kernel-owned input/layout bounds, an
      independent exhaustive small-model oracle, independent sparse witness
      replay, deterministic worker-local reduction, and allocation gates that
      observe actual worker threads rather than only the caller;
   2. repair every confirmed SEV1/SEV2 item tactically: fail closed on unchecked
      `certdist` witnesses and toolchain mismatch; make the load-bearing
      `certiis` schema strict and reproducible; correct rank-deficient matrix
      containment; correct and restore-through-error the g53 same-block repair
      join; make the private source/evidence chain commit-addressable without
      absorbing unrelated working-tree ownership; widen/check the square-sum
      kernel; retain all relevant fibre representatives in the q29 scout; and
      make certificate creation atomic/create-only with surfaced directory
      errors; then fix the round-2 checks/claims that can pass vacuously,
      starting with the extension-field control, wide-shard cover, null-witness
      reductions, evolve beam ordering, certificate headline fields, and replay
      scripts;
   3. revisit the register by root cause rather than file.  Add narrow
      capability-owned safeguards now—shared allocation instrumentation that
      propagates measurement identity to workers, checked representation
      constructors with adjacent bounds, strict evidence schemas and
      create-only writers, typed error distinctions, and structurally
      independent small-model/differential verifiers.  Record the larger
      capability-layer and verifier-independence choices as ADRs, but do not
      reorganize the private crate or rewrite all sealed proofs in this tranche;
   4. require formatting, strict all-target/all-feature clippy, full public and
      affected-private tests, malformed-input/corruption tests, and durable Git
      SHAs for each coherent commit.  Benchmark only changes that reach a hot
      loop, with exact-work one-thread and parallel counter A/B.

   Architectural direction: campaign modules may consume shared capability
   kernels, but must not own copied trust primitives.  Preconditions travel
   with constructors/representations; `debug_assert!` is never the sole guard
   for certificate soundness or memory safety; “verified” must state whether it
   means replay, independent recomputation, or proof checking.  A later broad
   capability-layer refactor is gated on the tactical fixes and ADR, not mixed
   into them.

   Treat C1016's “Public-core enhancement ledger” as a recurring evolve input,
   not as campaign authority.  Its three current reusable requests are a
   relational evolution grammar, provenance-bound counterexample-guided
   presentation transitions, and typed set-theorem templates with canonical
   semantics plus independent witness reconstruction.  They enter core only as
   general contracts; C1016-specific quotient fields, targets, and conclusions
   remain private.

## Gurobi boundary and semantic-symmetry spike, 2026-08-29

The product boundary is now explicit in
[`2026-08-29-c985-ergodis-gurobi-boundary-and-semantic-symmetry-spike.md`](2026-08-29-c985-ergodis-gurobi-boundary-and-semantic-symmetry-spike.md).
Ergodis does not attempt to reproduce a generic mixed-integer optimizer.  It
compiles source-level algebra and contextual structure into a smaller certified
model, delegates generic search to Gurobi, SCIP, Kissat, or the native exact
backend, and independently lifts and checks the returned witness.  A proposed
reduction is durable Ergodis territory only when it requires information that
is absent from the emitted coefficient matrix or constraint graph.

C997 supplies the first measured semantic-symmetry case.  On the Gross code,
the conventional per-logical encoding retains only an order-2 matrix symmetry
from the source translation group of order 72.  The class-independent global
re-encoding restores the action; one anchored solve per coordinate orbit then
gives the reported CBC reductions.  Those measurements remain C997/CBC
evidence, not Ergodis or Gurobi evidence, and the SCIP/Gurobi rerun remains the
external-claim gate.

The first Rust spike adds `semantic_symmetry.rs`.  It compiles any
`FinitePermutationAction` into a `NonemptySupportOrbitCover`, exposes one flat
eight-byte `AnchoredSupportSubproblem` per coordinate orbit without allocating
during iteration, maps every coordinate to its covering anchor, and replays the
existing permutation-orbit certificate independently.  The Gross action shape
`Z_12 x Z_6` on two 72-coordinate blocks compiles 144 possible first-support
anchors to exactly `[0, 72]`.

The API intentionally certifies only the generic orbit-cover obligation.  It
does not assert that an opaque domain feasible family or objective is invariant
under the supplied action.  The next spike must introduce a concrete small
binary domain adapter that checks those obligations and rejects corrupted
invariance evidence before any LP/MPS emitter or Gross CSS adapter is admitted.
This keeps backend adapters free of mathematical soundness assumptions.

The immediate follow-on implements that small consumed adapter.
`ExplicitBinarySupportProblem` uses canonical flat `(u64 support, u64 cost)`
records and rejects empty, out-of-range, and duplicate supports.  Compilation
first verifies the coordinate permutations and then checks that every
generator maps every feasible support to a present support of identical cost.
The resulting owned artifact independently replays both obligations, rejects
changed actions, missing images, changed costs, and nonpermutations, and gives
equal direct and anchored exact minima.  Its anchored evaluation performs zero
allocations under the counting allocator.  The adapter is an exhaustive
small-model trust oracle, not a scaling representation; deterministic binary
linear-model emission and result replay are next.

The next external-boundary slice streams a deterministic one-hot LP for every
certified anchor and replays flat 48-byte backend result claims.  Artifact
identity binds both the canonical source model and orbit cover.  Replay checks
model identity, canonical anchor, candidate provenance, support, cost,
feasibility, and exact local optimality; complete replay rejects missing or
duplicate anchor results and returns the independently recomputed global
optimum.  LP writing and both replay paths allocate nothing after construction.
This remains a bounded enumerative oracle, and its 128-bit stable fingerprint
is non-cryptographic.  No Gurobi, SCIP, or HiGHS executable is installed on the
machine, so deterministic golden LP text is established but actual backend
parser compatibility is not yet measured.  A compact parity/relative-code
schema with row-space invariance certificates is the next scaling gate.

Validation passes under the repository Nix toolchain: `cargo fmt --check`,
Clippy over all targets and features with warnings denied, all-feature Rust
tests (204 library tests plus every integration suite), and the independent
Python fixture parity check.

## Four-hour direct-envelope compiler plan, 2026-08-28

The next implementation slice targets source construction rather than another
generic-refinement micro-optimization.  The current hierarchy path spends about
2.06 seconds and 22.5 MiB constructing 328,704 raw states before a minimizer
that needs only tens of milliseconds.  The intended compiler will construct
rank-stratified full-span envelopes and their restriction edges directly,
consume transient strata as soon as their successors are fixed, and emit the
same canonical quotient without retaining the raw presentation.

Acceptance requires:

1. exact quotient, transition, observation, and witness parity with the current
   raw-presentation path on exhaustive small controls and the scaled hierarchy;
2. a versioned frozen artifact whose loader checks schema, dimensions, hashes,
   range invariants, congruence, and witness provenance before serving queries;
3. pre-sized contiguous pools, no allocation in construction/refinement hot
   loops, and no recursion proportional to ranks, states, contexts, or evidence;
4. line-buffered or directly written large evidence rather than an in-memory
   transcript;
5. interleaved cold time and peak-RSS measurements, retained artifact size,
   random and sequential query cost, and a recomputed compile/query crossover;
6. a target of at least 10x less cold compiler work or a comparably decisive
   memory/crossover improvement, with a clean negative recorded if direct
   construction cannot reach that gate; and
7. profile-led optimization after exactness passes, followed by the highest-EV
   remaining application or theorem slice for any unused goal window.

The generic compiler remains the differential oracle and fallback.  GL/orbit
compression is admitted only if profiling shows probe hashing or storage still
dominates after direct construction.  C995 results may alter the final
follow-on choice, but not this acceptance boundary.

## Direct layered compiler result, 2026-08-28

Commits `a5c64abd9` and `e41a83b60` implement the general acyclic case of the
contextual quotient theorem.  A layered typed system no longer needs a raw
`FinitePresentation` or generic partition refinement: reverse induction
interns each flat signature

\[
  (\operatorname{obs}(x),[g_1x],\ldots,[g_kx])
\]

after the target strata are fixed.  Exact collision-checked open addressing
assigns canonical classes in concrete-state order.  Signature, lookup, and
class buffers are pre-sized; there is no per-state allocation, recursion, or
raw transition table.  The resulting `CompiledObservation` is compatible with
the generic compiler's canonical class numbering on the independent layered
control and passes the existing verifier.

The hierarchy adapter additionally proves and exhaustively checks two closed
forms against the production composition oracle.  After the first layer every
profile is either `[0,o,c,0]` or `[0,o,0,o]`; its local state ID and all three
successors are arithmetic functions of `(o,c)`.  This explains the stable
`b(b+1)` stratum size.  Reverse signatures then give class counts `b`, `2b`,
`2b`, `2b`, and `b+1`, explaining the previously empirical total `8b+1`.
Neither profiles nor transition maps are constructed on the direct path.

`FrozenObservation::into_frozen` consumes the verified result and retains raw
state-to-class lookup only for nominated entry sorts.  Quotient transitions,
outputs, global concrete representative IDs, and metrics remain available.
For the depth-4, `b=256` hierarchy this keeps all 65,536 entry states and 2,049
classes in 300,312 payload bytes, versus 1,352,944 bytes for the full direct
artifact and 4,469,760 bytes for the former raw evaluator.

Nine CPU-2 paired rounds, with generic/direct process order alternated, compare
the optimized raw-presentation plus split-transcript compiler against direct
layered compilation plus freezing.  The geometric time ratio is 14.262x and
the median paired ratio is 14.622x (paired log-ratio `t=184.43`).  Peak RSS is
5.295x lower geometrically and 5.290x lower by the median paired ratio
(`t=366.58`).  The older 2.061-second raw construction is not used as the A
side: theorem-specializing the scalar hierarchy transition already reduced
that construction to roughly 40--45 ms, so the recorded comparison is against
the corrected optimized baseline.

```sh
ERGODIS_ROUNDS=9 ERGODIS_CPU=2 \
  papers/complete-repair-ports/ergodis/scripts/layered-hierarchy-ab.sh \
  "${CARGO_TARGET_DIR:-target}/release/examples/observational_hierarchy_driver" \
  > papers/complete-repair-ports/ergodis/evidence/c985-layered-hierarchy-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-layered-hierarchy-evidence.sh
```

- A/B script: `736afdd1353a35fd25189d53930e7fb1e13c667a82c6ccfcf9c6526dccfc9375`;
- checker: `8a0a64651a9cae295c8e44e9966478383be26493ba2e2afa008eab11ad18ee51`;
- evidence TSV: `3c60d3284a95dd30ad2e6e338e17ada26468bab8adf5eeacca471571cfa10c4a`.

The final B side uses the consuming chain specialization.  When every
generator targets the adjacent stratum, a concrete class map is released as
soon as its sole predecessor has been compiled; selected entry maps move into
the artifact only after their last semantic use.  The full and consuming
compilers produce exactly equal frozen artifacts on the independent control.
At `b=256` the consuming path compiles and freezes in about 3.6 ms and peaks at
5.6 MiB, versus the earlier direct path's roughly 4.2 ms and 6.4 MiB.

Commit `ec34f2c10` adds an independent reverse-induction verifier against the
domain observation and transition oracles.  The subsequent `ERGLAY01` audit
sidecar closes the persistence boundary without retaining a transcript in
memory.  Its first pass varint-encodes the raw class map; its second pass
streams observations and local target IDs.  Replay retains only the compact
`u32` state-class map plus one stratum's signatures and checks the frozen
artifact fingerprint, entry maps, congruence, minimality, outputs, quotient
transitions, and concrete representative provenance before requiring clean
EOF.  Corrupted magic, semantic records, truncation, and trailing bytes are
negative-tested.

The full `b=256` sidecar is 3,005,633 bytes and the frozen evaluator remains
300,312 bytes.  A CPU-2 write-and-replay control peaks at 6.4 MiB, indistinguishable
at process resolution from compilation alone; representative phase times were
4.2 ms compile, 8.7 ms independently verify and write, and 9.4 ms replay.
The 14.262x compiler A/B excludes this optional durable audit on the direct
side; the evidence timings are reported separately rather than conflated.

`ERGFRZ01` is the deployment artifact paired with that audit.  Its required
loader budgets independently cap sorts, semantic states, retained entry
states, classes, generators, and transitions before allocation.  The loader
rejects noncanonical varints, malformed or noncontiguous ranges, untyped or
unreferenced transitions, out-of-range witnesses, inconsistent metrics,
fingerprint mismatch, and trailing bytes.  Varint serialization reduces the
300,312-byte in-memory evaluator to 117,856 bytes on disk.  The committed
artifact loads in about 0.69 ms and its audit replays in about 9.3 ms without
running either compiler.

```sh
papers/complete-repair-ports/ergodis/scripts/check-layered-audit-evidence.sh
```

- artifact generator: `2c6a68eefa82ff622a11182a3595343d45c47b30a65dc3e2789758842d35331c`;
- artifact checker: `d034d233c39b382eeb7d3ca1c23e9280dc010a69369e4c709af61e87578ab4c9`;
- frozen artifact: `af6d000ec8d205e5250f7d1bfec3543f9c4f1aecfcd80ab0c795061faad9ac50`;
- streamed audit: `742b7e0860d927ff0b4b4521e065b14eecb8bf7885cb7db5367fb3e26e63af50`.

### Frontier-bounded certified compilation

Commit `ecf1296ac` closes the mismatch between the low-memory compiler and the
proof-carrying path.  `ERGLAY02` is emitted during the same reverse-stratum
pass that constructs the frozen quotient.  It records the observation and raw
target IDs returned by each oracle call before the corresponding concrete map
is released.  A preallocated 64 KiB varint block encoder performs no allocation
in the state loop and writes only large sequential blocks.  Quotient
transitions are taken from the already-interned representative signatures, so
each transition oracle is evaluated exactly once per concrete source edge.

Replay reads strata in reverse order and retains bounded linear work arrays for
the current stratum plus the next stratum's concrete class map; its independent
sorting pass is `O(n log n)` rather than the compiler's expected-time hash path.
It deliberately does not
reuse the compiler's hash interner: an independent sort reconstructs signature
groups, canonical representative order, outputs, transitions, entry maps, and
witness provenance.  `ERGFRZ02` also repairs the deployment trust boundary by
binding entry ranges, entry classes, and all metrics in addition to the
quotient tables.  Replay certifies semantics relative to the recorded oracle
transcript; the recorded external SHA-256, not the internal noncryptographic
fingerprint alone, binds committed evidence.  The old `ERGLAY01`/`ERGFRZ01`
files remain historical evidence; the current checker targets version 2.

The scaling result is strongest at depth 64 and `b=256`: 4,276,224 concrete
states compile to 32,769 classes.  Nine interleaved CPU-2 rounds compare a
byte-equal frozen result and equivalent certification obligation, not identical
audit encodings: version 1 writes an explicit class map in a second oracle pass,
whereas version 2 fuses the transcript and reconstructs the map on replay.  The
frontier-one certified pipeline is 1.754x
faster end to end (`t=134.02` on paired log ratios), 4.989x faster in its
compile-and-stream phase, and 3.607x lower in peak RSS (`t=252.27`).  Its
independent sorting replay is 0.665x the old replay speed, an intentional cost
for algorithmic independence; the total still wins.  The audit is 38,984,421
bytes rather than 46,401,954 bytes, a 1.190x reduction.  A representative run
used 6.2 MiB versus 22.8 MiB peak RSS.

```sh
ERGODIS_ROUNDS=9 ERGODIS_CPU=2 \
  papers/complete-repair-ports/ergodis/scripts/layered-certified-ab.sh \
  "${CARGO_TARGET_DIR:-target}/release/examples/observational_hierarchy_driver" \
  > papers/complete-repair-ports/ergodis/evidence/c985-layered-certified-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-layered-certified-evidence.sh
papers/complete-repair-ports/ergodis/scripts/check-layered-audit-evidence.sh
```

- certified A/B script: `010d3742a953efff5b131be999b7e7ff48604d6602980842d50dfcfb82b753b6`;
- certified checker: `e1b2460728da591fc9cb206a71e19e75366749ecce1fcef5a9062c2f3018f616`;
- certified evidence: `00f14ef344dc3f9cc5f3e94f9071fbea072832bb903a45ff0ae2a836cdb45563`;
- artifact checker: `583e97ba47ad1a62006f0ac99cc07b1f5b908ad91173f19859b8349d1e07cc2b`;
- `ERGFRZ02`: `99a93ca87566291ca33e0e7b4bd66e18d32cf95bb7a1a23bb1eda27caf377bd0`;
- `ERGLAY02`: `5295518ae0565b86aff9a54a7cd938032b804accb977fb1105abd61f1d656b7d`.

### Classical results as corollaries, and the actual extension

The acyclic reverse-signature backend is not presented as a new automata
minimizer.  Revuz's linear-time acyclic-DFA minimization and Daciuk et al.'s
incremental minimal-DAFSA construction already establish the classical core;
MATA is the relevant high-performance generic automata implementation.  The
honest general statement is a typed contextual minimal-realization theorem:
for finite carriers `X_s`, observations `o_s`, and deterministic typed
generators `g : s -> t`, equality under every well-typed continuation is the
greatest typed congruence refining observations.  When every concrete state is
an admitted entry (or unreachable quotient classes are trimmed), its quotient
is the unique smallest typed realization up to typed isomorphism.  DFA
Myhill--Nerode, Moore-machine minimization, colored deterministic transition
systems, and acyclic-DAG hash-consing are recovered as special presentations.

Ergodis's additional payload is elsewhere: an optimization theorem derives
the finite observable interface rather than accepting an alphabet/state model
as input; compilation retains concrete optimizing witnesses; and the same
quotient is emitted as a bounded frozen evaluator with independently replayable
evidence.  This statement does **not** subsume unrestricted nondeterministic or
tropical weighted-automata minimization, whose equivalence theory is materially
different.  The current collision-checked open-address interner is exact but
has only an expected-time performance claim; a public fixed hash can be driven
to quadratic probing, so Revuz's worst-case linear bound is not borrowed for
this implementation.

For a general acyclic sort-dependency DAG and reverse topological schedule
`pi`, each concrete class map is live only from compilation of its sort until
the last predecessor in `pi` has consumed it.  Consequently the transient
class-map space is bounded by the maximum weighted live frontier

\[
  \max_i \sum_{s\in L_i} |X_s|,
\]

plus the current stratum's `|X_s|(1+outdeg(s))` signature workspace and the
final quotient.  The chain compiler is the frontier-one corollary.

Commit `e2138e734` implements the arbitrary-DAG form.  It counts distinct
predecessor sorts, releases each concrete target map on its final use, and
reports peak live state-class words, live map count, and signature words.  A
branching control with a skip edge is byte-exact against full compilation and
checks the predicted live frontier.  The chain instantiation is const-specialized:
hardware counters are 81.78 million instructions and 16.02 million cycles,
slightly better than the pre-generalization 82.63 million/16.27 million result,
so generality adds no chain hot-path tax.  The remaining general problem is
schedule selection when the supplied topological order is not fixed; that
connects to pebbling, register allocation, pathwidth/cutwidth, variable
elimination, and tensor-contraction ordering.

Commit `cafb79f0b` extends the fused transcript and independent replay to those
arbitrary forward-edge DAGs as `ERGLAY03`.  The verifier reconstructs distinct
predecessor-sort counts from the transcript, releases maps independently at
last use, and uses sorting rather than the compiler's interner.  Forty-eight
deterministic randomized DAGs plus parallel edges, skip edges, disconnected
components, selected sinks, corruption, and empty strata are differential
controls against full compilation.

A retained three-family benchmark fixes 32 sorts and 32,768 concrete states per
sort while varying only dependency geometry.  It compares the old full-map
certified pipeline against the consuming `ERGLAY03` pipeline over nine
interleaved CPU-2 rounds and requires byte-identical frozen artifacts after
every pair.  The observed structural counters match exactly:

| DAG | peak live class words | live maps | peak signature words | certified time ratio | RSS ratio |
|---|---:|---:|---:|---:|---:|
| chain | 65,536 | 2 | 65,536 | 1.917x | 2.078x |
| distance-4 window | 163,840 | 5 | 163,840 | 1.995x | 1.761x |
| full span | 1,048,576 | 32 | 1,048,576 | 1.905x | 0.932x |

The full-span RSS result is the important negative: when every later map stays
live until sort zero, last-use reclamation cannot reduce map residency, and
the consuming verifier is about 7% heavier at process resolution.  Thus the
frontier counter predicts where memory improves rather than manufacturing a
universal win.  Time still improves because fused evidence removes the second
oracle pass and explicit class-map stream; this is a certified-pipeline and
format result, not an isolated reclamation speedup.

These counters are structural, not a complete byte/RSS model.  They exclude
retained entries and quotient output, hash-interner tables, verifier sort
arrays, directories, and allocator/runtime overhead, and signature and live-map
maxima are reported separately.  They certify the supplied numeric topological
order, not the minimum over all orders.

```sh
ERGODIS_ROUNDS=9 ERGODIS_CPU=2 \
  papers/complete-repair-ports/ergodis/scripts/layered-dag-certified-ab.sh \
  "${CARGO_TARGET_DIR:-target}/release/examples/layered_dag_driver" \
  > papers/complete-repair-ports/ergodis/evidence/c985-layered-dag-certified-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-layered-dag-evidence.sh
```

- DAG driver: `de546d490ba2d2c8be2036393dee249dbdad63809eaad7047874685385e831dd`;
- DAG A/B script: `7be696e19d8e77e3a7783ded429697af3b1375779d9409927f95bf52e009021b`;
- DAG checker: `77061cadd68830e279177fc1355559506426740f82e21c2794521836e04292b9`;
- DAG evidence: `a15fab754788456c055e4fb31ca11ef116cecda72e2310aaa9aa633b53f3323a`.

Primary references:

- Dominique Revuz, *Minimisation of acyclic deterministic automata in linear
  time*, Theoretical Computer Science 92 (1992),
  <https://doi.org/10.1016/0304-3975(92)90142-3>;
- Jan Daciuk et al., *Incremental Construction of Minimal Acyclic Finite-State
  Automata*, Computational Linguistics 26 (2000),
  <https://aclanthology.org/J00-1002/>;
- MATA official implementation and paper,
  <https://github.com/VeriFIT/mata> and <https://arxiv.org/abs/2310.10136>.

### Deliberate `ej` / `tt` / red-team checkpoints

1. The first frozen-envelope pass exposed an allocation in repeated context
   canonicalization.  An opaque canonical context now precomputes its exact
   subspace key; the frozen query loop allocates zero times.  Dimension-5 and
   dimension-6 batches measured 360x and 1,124x faster than cached subspace
   scans, respectively.  Treating this as the hierarchy solution was rejected:
   it was only an enabling primitive.
2. The first layered compiler saved memory but was time-neutral because it
   sorted signatures and the adapter binary-searched profile sets.  Reverse
   induction needs neither.  Collision-checked interning removed sorting, and
   the closed profile-family theorem removed lookup entirely.
3. Pre-sizing class outputs to the raw-state upper bound obeyed the allocation
   rule but damaged cold time and cache locality.  The retained design assigns
   scalar class IDs in the zero-allocation state loop, then allocates the exact
   small output/witness arrays once and fills them in a linear post-pass.
4. The apparent `8b+1` pattern is no longer a mystery or an empirical capacity
   hint: it is the sum of the five proved stratum counts above.  The unresolved
   issue is how much of this hierarchy-specific normal-form discovery can be
   automated for other adapters without asking users to hand-supply the state
   coordinate system.
5. A width-1--4 scalar signature comparison removed `memcmp` from the profile
   but raised instructions by about 2.0% and cycles by about 1.7%; it was
   rejected.  The retained vectorized slice comparison is faster.  The profile
   correctly redirected work toward eliminating duplicate oracle probes and
   per-word evidence writes instead.
6. Red-team review found that the version-1 frozen fingerprint omitted entry
   maps and metrics, and that the audited path forfeited consuming compilation.
   Both were correctness/architecture issues, not documentation nits; version
   2 fixes them and adds adversarial regression coverage.

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

The durable implementation and checked-in benchmark/evidence tranche is commit
`cd389f818`; the numerical summary above is retained in this tracked memo.

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
Commit `b7e07f274` exposes the exact retained map-and-directory payload through
`compiled_kernel_payload_bytes`; the binary rank-2 test retains 70 bytes with
distinct inner/target tables and zero bytes on the memory-budgeted direct path.

Commit `20654574b` transfers C947's scalar-demand image theorem into the public
span API.  `CanonicalTargetImage` is an opaque canonical column-space basis
tagged by field and ambient dimension.  Callers can normalize a demand once and
reuse it across exact span queries without repeating transpose and elimination;
coefficient-aware presentations remain untouched.

The complete theorem-to-compiler work order, classical-corollary framing, and
negative boundaries are recorded in
`notes/2026-08-28-c985-ergodis-portfolio-theorem-leverage.md`.

## Generic finite-interface and orbit layer

The August 28 code/test review imported three general C980 consequences rather
than adding recovery-only special cases.

Commit `460b7df53` adds finite ordered commutative resource monoids and
canonical Pareto antichains.  The validator exhaustively certifies every law
used by the theorem, including closure of intermediate products; invalid
budget IDs are errors rather than silent infeasibility.  Commit `d8423090b`
adds compact batch observation interning and a strictly pre-sized reusable
workspace, eliminating allocation and capacity growth from repeated Pareto
choice/composition loops.  Commit `66faadef4` checks every subset and all 256
pairs of subsets of the `2 x 2` resource lattice against an independent brute
definition.
Commit `5713d137f` completes the exact optimizer boundary by retaining a compact
domain witness ID at every Pareto point.  Its pre-sized composition workspace
creates witness-arena nodes only for currently nondominated resource products,
so repeated elimination remains allocation-free in the library hot loop while
still returning a concrete optimizer.
Commit `e627647f8` then separates semantics from provenance at the adapter
boundary: resource-identical fronts share one observation ID even when their
concrete plans differ, while a per-state sidecar retains each plan.  Witness
lifting first verifies the compiled artifact against the originating
presentation, preventing a same-shaped foreign quotient from selecting a
plausible but incorrect witness.

Commit `9b6b1c733` adds the domain-independent finite-interface adapter.  Typed
state counts, observations, and total one-hole contexts compile into the same
`FinitePresentation` used by the evidence-streaming minimizer; quotient
representatives lift through an optional domain witness interface.  The
adapter is deliberately semantic and finite: it does not claim an unbounded
domain has a finite quotient without a supplied bound or theorem.

Commits `493b8c0e8` and `eb9b54a50` add a proof-carrying finite
permutation-action compiler and connect its orbit partition to typed
presentations.  Orbit search is iterative, uses a reusable point-sized queue,
and depends on points times supplied generators rather than group order.
Independent replay validates permutations, spanning edges, closure, and least
representatives.  Presentation compression is admitted only after checking
sort preservation, observation invariance, and context equivariance on every
concrete state.  Standard automaton symmetry reduction and the future
`GL_s(L)` probe quotient are therefore instances of the same checked operation.

The review found and fixed two API-level pathologies before release: an
invalid monoid product could be reused before its range was checked, and an
invalid Pareto budget was silently mapped to `false`.  Higher-rank GF(3) and
GF(4) kernel tests, exhaustive two-state theorem-API tests, corrupted orbit
certificate tests, malformed adapter tests, and the complete small Pareto
lattice now cover the trust boundaries.  The next high-value algorithmic
target is rank-stratified full-span envelope aggregation; the generic orbit
engine should first be instantiated only where profiling shows raw probe
hashing or storage dominates.

The same review found a separate streaming pathology in the exhaustive audit.
Although records were written incrementally, each pair search cloned its full
generator path into every BFS queue entry and rebuilt all search allocations.
Commit `0eae4c062` replaces this with one sparse predecessor arena, visited
index, and reconstructed path buffer reused across the entire stream.  The
stream format and verifier are unchanged; peak scratch now follows the hardest
single separator search rather than accumulating path copies or emitted
evidence.

Seven paired CPU-2 rounds on a 64-state long-chain stream (2,016 separator
records per iteration) compare pre-arena commit `cd1a2d1ff` with `0eae4c062`.
Median time falls from 1,748,284 ns to 373,043 ns, a 4.687x speedup; median
process peak RSS is 11,768 versus 11,600 KiB.  A profiled dense epoch table was
discarded after regressing the one-generator control: the sparse predecessor
arena is the retained representation, and a future dense mode needs a
separately dispatched branching kernel rather than a per-edge mode branch.

```sh
papers/complete-repair-ports/ergodis/scripts/separator-stream-ab.sh \
  "$BASELINE_BENCH" "$ARENA_BENCH" \
  > papers/complete-repair-ports/ergodis/evidence/c985-separator-stream-final.tsv
papers/complete-repair-ports/ergodis/scripts/check-separator-stream-evidence.sh
```

- stream A/B script: `66b6953f773d955aaef9721d8a6f180f8439a15add9446b9a99db9208c2a2433`;
- stream checker: `0a60ffcaadd93cef403b6a58681b0569389295719b397bfe16ce2fc6a72e9574`;
- stream TSV: `bae609f5a2eb7050444874ca58427116e80e77a68fdcdd292d15509b3cb1fd0c`.

Commit `69f3615f4` closes the finite family-response gap left by accepted-word
languages.  It compiles arbitrary minima-defined probe families into exact
response-vector observation IDs using one flat state matrix, a sorted compact
state-index vector, and one copy of each distinct response.  Re-observation
preserves all typed contexts, so subsequent proof-carrying minimization computes
the family-specific contextual quotient.  Empty families, unknown probes, and
shape overflow are rejected; an empty observation alphabet correctly merges
all same-sort states without reserving a sentinel cost.
Consuming `into_reobserved` and response-dictionary handoffs move the state IDs
into the presentation without cloning context transitions or retaining a
second ID vector.  The witnessed Pareto path has the same split.  For batch
witness recovery, `VerifiedParetoWitnesses` replays the artifact once and then
maps every quotient class to its representative front in O(1) without further
allocation or verification passes.

## Objective-parametric quotient evaluation

Commit `d64c55af3` adds a non-coding asynchronous two-branch CostRegular
control.  Its bounded composite DFA deliberately has both continuation-
equivalent and distinguishable histories.  The test exhaustively enumerates
all typed continuations into compact bitmaps and proves that entry classes are
equal exactly when their accepted continuation languages are equal.  For every
entry state, raw DP, quotient DP, and brute-force enumeration produce the same
two-resource Pareto front, and every selected word replays from nonrepresentative
states.  The identical frozen feasibility quotient is also reused under a
second generator-weight assignment without recompilation.

The supported general statement is objective-parametric but acyclic.  Let a
finite typed deterministic forward DAG be quotiented by equality of observation
after every typed continuation.  Give each observation an arbitrary base
Pareto front and each typed generator an arbitrary edge Pareto front over a
finite ordered commutative monoid.  Reverse induction shows that canonical
choice of base fronts and generator-front products is constant on contextual
classes, so evaluation on the frozen quotient equals concrete-state evaluation.
Chain CostRegular, acyclic weighted automata, multiobjective shortest paths on
decision diagrams, and asynchronous products are direct instances.  This does
not establish cyclic least-fixed-point semantics.

The locality boundary is essential.  A cost depending on a hidden concrete
source state is not safe after quotienting: two language-equivalent states may
share the same generator and successor while assigning that transition
different costs.  Such history must first be exposed in the interface state.
Pareto pruning also requires order-compatible monoid composition; otherwise a
dominated prefix can become optimal after extension.

`FrozenParetoPlan` now derives and binds the generator CSR directly from the
verified artifact, permitting many objectives to reuse one topology plan.
`evaluate_frozen_pareto_dag` is the one-shot convenience path.  Evaluation uses
one caller-capacity-checked accumulator: compose and Pareto choice are fused,
witnesses are created only for admitted nondominated products, and class/
generator loops do not grow scratch storage; one final front is allocated per
reachable class.  `FrozenParetoQueryPlan` additionally compiles a packed-bitmap
forward closure from requested classes, selected-output ordering, and exact
reachable last-use buckets once, then reuses that immutable topology across
objective families.  It stores sorted reachable-class slices and each
reachable transition's dense target slot, so repeated evaluation neither scans
full sort ranges nor searches transition targets.  `evaluate_entries` remains
one-shot sugar.  Evaluation skips unreachable quotient classes and drops every
live sort slab at its exact
last use.  The caller-owned Pareto workspace is now the actual accumulator
rather than merely a capacity oracle, removing a redundant 33.8 KiB allocation
at these bounds.  On
the separable control, 96 of 153 classes are reachable and evaluation peaks at
22 classes / 26 Pareto entries.
The all-class convenience result still retains one front per quotient class.

The strongest classical control is retained as a negative.  In this separable
shuffle product, an exact factorized solver evaluates the two branch languages
independently and combines their fronts once.  Nine interleaved rounds run
identity, quotient, and specialized stages in separate CPU-2 processes, each
amortizing 1,000 solves, and give:

- identity quotient / minimized quotient: 4.836x geometric mean, log-ratio
  t = 97.00;
- minimized quotient / exact factorized DP: 1.045x geometric mean, log-ratio
  t = 2.28.

The identity artifact gives every concrete state a distinct observation but
maps those observations back to the same base fronts at evaluation.  It uses
the identical consuming algorithm, retained-entry obligation, objective
tables, and witness operation; the 4.836x ratio isolates contextual
minimization.  The minimized engine has no statistically resolved gap from the
stronger
branch-factorized solver.  The legacy Cartesian DP remains an independent
correctness oracle and is not used for the quotient speedup claim.

```sh
cd papers/complete-repair-ports/ergodis
scripts/bench-shuffle-product-control.sh \
  > evidence/c985-shuffle-product-control.tsv
scripts/check-shuffle-product-control.sh \
  evidence/c985-shuffle-product-control.tsv
```

- benchmark script: `0375db708d1741a21c1be72e653d36c25931625ccf8234ebb2858bbdb6f80ce6`;
- checker: `053cb6d5d8ebc1933994af8903b095b1a9e03f518720542b88e7939e816a3761`;
- evidence TSV: `febbd2a8d610cef37d5bca402a54df91a8dbe944edf5eff050773c63bd995a81`.

The coupled control adds a shared mode selected by each branch's first symbol
and requires the modes to agree at the join.  Unlike the discarded switch-
count monitor, this excludes some branch-word pairs under every interleaving.
An exhaustive small test proves the coupled front differs strictly from the
independent branch product, while raw DP, minimized evaluation, identity
evaluation, brute force, and witness replay agree.

At length five with 12 local DFA states, the identity artifact has 46,656
classes, contextual minimization has 349, and only 101 minimized classes are
reachable from the requested entry.  The consuming frontier peaks at 23
classes / 23 Pareto entries.  Nine interleaved rounds run each of the three
stages in a separate CPU-2 process amortizing 1,000 evaluations and give a
8.136x identity/minimized geometric speedup with log-ratio t = 763.51.  The
generic minimized evaluator is 1.199x faster than the exact mode-conditioned
branch join (generic/specialized ratio 0.834, log-ratio t = -39.23).  The
one-time minimized compile plus entry-plan cost crosses over after 41.82 such
entry evaluations
geometrically.  This synthetic finite-state join-compatibility application is
genuinely coupled and differs from the unconditioned branch product, but it
still factorizes through a two-value shared-mode interface.  The measured
mode-conditioned join is therefore the strongest specialized control.  This is
not yet a public workflow-suite or SOTA claim.

```sh
scripts/bench-coupled-workflow.sh > evidence/c985-coupled-workflow.tsv
scripts/check-coupled-workflow.sh evidence/c985-coupled-workflow.tsv
```

- coupled benchmark: `6fa41ddb0891d3cac2ceb580648059cba4a7b1da42afce25dccb998ee0377f3e`;
- coupled checker: `f85b6afd48267b8de80c610c05c85940dae87916a3246fce7633b4ad8697cc89`;
- coupled evidence: `380f121e5dc4b9721919167117bc9451084889bda9c7ba4884b7c6f4c287e758`.

The benchmark source and evidence are retained in commit `9ed395784`; it was
built with Rust/Cargo 1.93.1 using:

```sh
cargo build --release \
  --manifest-path papers/complete-repair-ports/ergodis/Cargo.toml \
  --example fork_join_cost_regular
```

An isolated `perf stat` pass then showed that generic evaluation executed fewer
instructions than the mode-conditioned solver but lost IPC in repeated small
query-selection setup.  The single-entry path first bypassed four CSR/helper
allocations.  Over 100,000 isolated coupled evaluations, cycles fell from
3,416,356,645 to 3,316,527,686 (1.030x) and instructions from 15,112,029,698 to
14,633,115,635 (1.033x).  The reusable query-plan boundary then moved all
remaining reachability and release scheduling outside the objective loop and
reused the caller's accumulator.  The common single-entry path also moves its
result rather than cloning its witness box, and a shared exact insertion helper
handles zero/singleton fronts without the general scan-plus-retain path.  Both
generic and specialized
controls now reuse prebuilt objective fronts and workspaces, and their stages
run in separate pinned processes with alternating round order.  Mean entry-plan
construction is 7.3 us on the shuffle control and 7.7 us on the coupled
control; warm generic evaluation has no statistically resolved gap from the
exact separator solver on the former and is 19.9% ahead on the latter.  The
initial hardware-counter pass predates this final change and remains diagnostic
rather than a separate paper claim.  A final isolated 100,000-evaluation
coupled pass after the full change measured 2,444,080,562 cycles and
9,102,790,519 instructions for generic evaluation, versus 2,860,736,925 cycles
and 15,372,712,181 instructions for the specialized join: 1.170x fewer cycles
and 1.689x fewer instructions.  This single counter
pass is diagnostic; the alternating nine-round timing above remains the
retained statistical claim.

No pre-existing Ergodis application module currently calls
`FrozenParetoPlan`; outside its defining/export modules, the sole consumer is
the new fork/join control.  Thus these warm-evaluation gains do not silently
relabel an older application benchmark as faster.  Existing applications gain
only after an explicit adapter adopts the frozen/query-plan API; the certified
layered-compiler improvements earlier in this report have the broader immediate
compiler impact.

### Highest-EV continuation order

1. Instantiate the same frozen/query-plan engine on a public workflow,
   MDD/CostRegular, or resource-constrained path suite with its strongest native
   separator-aware baseline.
2. Develop objective-family residual equivalence and a certified minimizer;
   treat classical weighted-automata and semiring factorization as corollaries,
   not novelty claims.
3. Attempt reusable flat front-entry pools only if profiling after steps 1--2
   still shows allocator/locality pressure.  Preserve a separate persistent
   provenance arena and gate the change on whole-portfolio, not single-control,
   performance.

## Mystery ledger

- **Settled -- source of the speedup.**  The original raw/quotient timing mixed
  algorithms and retention obligations.  Identity and minimized artifacts now
  use the same plan, objective tables, reachability pruning, last-use release,
  witness operation, and selected entry.  The retained quotient-only gains are
  4.836x on the shuffle control and 8.136x on the shared-mode control.
- **Settled -- apparent nonfactorization.**  A switch-count monitor constrained
  schedules without changing the attainable additive cost set and was
  discarded.  Shared-mode compatibility changes the front relative to the
  unconditioned product, but the EJ/TT pass exposed its two-value separator.
  The exact mode-conditioned join is now implemented, checked for front and
  witness parity, and measured as the strongest specialized baseline.
- **Settled -- selected-entry residency.**  Structural lifetimes could retain a
  target past its final reachable predecessor.  Release buckets are now derived
  from a packed reachable-class closure compiled once per selected query.  The
  coupled control certifies 101 reachable classes and a 23-class / 23-entry
  peak; repeated objectives no longer rebuild this topology.
- **Open -- objective-family minimality.**  The feasibility/right-language
  quotient is universal over local ordered-monoid interpretations but can be
  finer than the coarsest quotient for one fixed objective family after cost
  collisions and dominance.  The evidence gap is a weighted/Pareto
  Myhill--Nerode theorem and certified minimizer; this is the highest-value
  theoretical successor.
- **Settled -- branded objective interpretations.**  `ValidatedParetoObjective`
  now binds immutable output/edge fronts to the exact frozen plan and ordered
  monoid, checking generator count, output coverage, range, strict order,
  uniqueness, and pairwise antichain canonicality once.  Repeated evaluation
  verifies plan identity and omits those checks from the class/product loops;
  the safe unvalidated API remains.  Equal-cardinality chain/diamond monoids
  supply the hostile order-confusion gate.  Two 20-pair coupled protocols give
  1.0440x (`t=5.6538`) and 1.0281x (`t=5.1170`) warm speedups.
- **Open -- cyclic semantics.**  The theorem and evaluator are acyclic.  No
  least-fixed-point, convergence, or negative-cycle claim is made; a cyclic
  extension needs a separately specified algebra and certificate.
- **Open -- application/SOTA breadth.**  The shared-mode instance is synthetic.
  A public workflow, MDD/CostRegular, RCSP, or configuration benchmark with its
  strongest native separator-aware implementation remains the gate for an
  application-SOTA claim.
- **Open -- unbounded witness and flat-front storage.**  The control packs short
  words into `u32`, and the generic result still allocates one box per reachable
  class.  After the singleton insertion specialization, the final coupled
  profile attributes 78.13% of samples to the query evaluator, 7.22% to
  `_int_free`, 5.72% to AVX-512 `memmove`, 4.23% to `malloc`, and 2.34% to
  `cfree`.  A reusable
  evaluation workspace with per-live-sort flat front-entry pools/ranges, dense
  reachable-class slots, and a separate compact global witness/backpointer
  arena is therefore the next implementation gate.  Provenance nodes should be
  created only for finalized nondominated entries; they cannot share the
  shorter front-slab lifetime because parent witnesses may reference suffixes.
  Acceptance requires exact multi-entry/witness parity, front allocations that
  scale with live sorts rather than reachable classes, witness storage bounded
  separately by finalized provenance nodes, and a retained multiround speedup.
  Current length-five evidence does not exercise the unbounded-witness half of
  this successor.

## 2026-08-29 QDistSAT BB360 exact-distance extension

The official QDistSAT `BB_360_12_?` instance is now certified as
`[[360,12,24]]`; the atomic report and replay boundary are
[`2026-08-29-c985-qdist-bb360-exact-distance.md`](2026-08-29-c985-qdist-bb360-exact-distance.md).
Both CSS directions independently exhaust radius 24 and retain distinct
weight-24 witnesses.  Combined search is 192,001,784,180 candidates in
469.322088944 seconds on 24 pinned hardware threads.  The published radius-20
portfolio completed 0/46 configurations at 7,200 seconds; Ergodis closes that
same two-direction radius in 12.470892325 seconds warm, a conservative
cross-machine lower bound of 577.34x.

The implementation adds a six-word support specialization for 321--384
coordinates.  It does not widen the prior five-word BB288 path: both are
separate const-generic monomorphizations with distinct artifact magic, and the
hot recursion remains iterative and allocation-free.  A post-change BB288
control is 2.69% faster than the retained median rather than slower.  The
importer verifies the two torus generators on physical row space and quotient
observability, and the independent paired checker proves block-swap plus torus
inversion is an exact X/Z isomorphism.

This establishes a specialized exact-quantum-distance result, not a generic
SAT or MIP claim.  The highest-EV scientific successor is an algebraically
prefiltered weight-six code search whose exact stage admits only Pareto
survivors capable of exceeding `k d^2 / n = 19.2`.
