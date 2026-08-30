# C985 Ergodis aligned-attachment compiler

**Lane:** `complete-ports`

**Date:** 2026-08-30

## Decision

C880's unresolved exact attachment value `15 <= g(8) <= 17` is a strong
Ergodis application target.  Its apparent context space—every known two-graph
and every pair of attachments—has an exact cut quotient.  The quotient turns
the problem into 127 bounded bipartiteness tests and supports native
counterexample-guided search, streamed SAT, and lazy MIP from one semantics.

No value of `g(8)` is claimed in this checkpoint.  The published 17-query
witness replays, while the 16-query exclusion is still a solver obligation.

## Exact reduction

Let `e` be the known graph and `x,y` two normalized attachments.  Put

\[
 f=e+\delta x,\qquad z=x+y.
\]

On a triple `T`, the alignment answer for `x` says that the three edges of
`f|T` are all equal.  If `z|T` is constant, the two attachments give the same
answer.  Otherwise `T` has a singleton on one side of the cut of `z` and two
points on the other.  The answers differ exactly when the two cut edges from
the singleton have equal `f`-colour.

Thus a selected triple imposes an inequality between two vertices of a graph
whose vertices are the cut edges.  A family fails on the cut precisely when
this constraint graph is bipartite; a 2-colouring supplies the exact failing
context.  It separates the cut precisely when the graph is non-bipartite.
This is a global cut-edge graph: the constraints do not decompose into
independent vertex links because one cut edge belongs to both endpoint stars.

This proves the context quotient:

\[
 (e,x,y)\longmapsto
 \bigl(z,\;f|_{z^{-1}(0)\times z^{-1}(1)}\bigr).
\]

At eight points the complete streamed context family has

\[
 \sum_{s=1}^7 {7\choose s}2^{s(8-s)}=4,244,480
\]

clauses over only 56 query variables.  The generated at-most-16 SAT model has
952 variables and 4,270,072 clauses. It
is written directly to persistent cache; the clause corpus is never buffered
in RAM or written to `/tmp`.

There is a second, much smaller exact formulation.  A graph is non-bipartite
iff it contains an Eulerian subgraph with an odd number of edges: one direction
selects an odd cycle; in the other, an Eulerian subgraph decomposes into cycles,
and odd total size forces an odd one.  For every cut, select witness triples,
require witness-to-query implication, even degree at every cut edge, and odd
total witness size. Tseitin XOR chains plus a monotone sequential cardinality
counter compile the at-most-16 decision to 20,457 variables and only 67,324
clauses. Non-bipartiteness also forces at least three selected crossing triples
on every cut; explicit unary threshold propagation strengthens the model
without changing its solutions. A 22,034-variable parity-native form retains
each Euler condition as one XOR constraint instead of expanding it.

## Implemented trust boundary

- `src/alignment.rs` compiles cut-edge incidences once and verifies a selected
  family with fixed 16-entry colour and queue arrays.
- The native counterexample-guided DFS is iterative, uses a pre-sized flat
  duplicate table, computes fixed-stack disjoint-clause and incidence-capacity
  lower bounds, and allocates nothing in the search loop.
- `examples/alignment_attachment_cnf.rs` streams the complete reduced CNF.
- `examples/alignment_attachment_compact_cnf.rs` streams the Eulerian/XOR CNF.
- `examples/alignment_attachment_orbits.rs` independently computes exact
  stabilizer-orbit representatives without recursion.
- `python/c880_alignment_gurobi.py` is a thin backend: every incumbent is
  replayed by exact cut bipartiteness, violated contexts are closed under the
  `S_3 x S_5` stabilizer of the fixed first triple, and C880's already-proved
  `g(8) >= 15` bound is imported explicitly.

The quotient matches the original four-triple alignment definition for all
1,024 query families at five points.  It independently re-proves `g(5)=9`,
accepts the committed 17-query `g(8)` witness, and rejects a one-query deletion
from that witness.  Strict all-target/all-feature clippy passes.

The compact at-most-17 SAT control is satisfiable in 0.20 seconds. A separate
CryptoMiniSat control consumes the native XOR form in 2.8 seconds including
generation and process startup. Its 17 selected query variables replay as
separating in the independent Rust verifier. Neither control proves the
16-query exclusion.

## Performance lesson

The first native search filled a 128 MiB duplicate table; merely enumerating
odd-cycle completions repeated too many supersets.  The corrected search asks
for a bipartite colouring of the whole cut-edge graph and branches on the
resulting violated context clause.  This is both more general and exact.

The generic backend should not be asked to rediscover known mathematics.
Importing the proved lower bound reduces the live optimization to cardinality
15 or 16.  Orbit-closing each lazy constraint exposes symmetry that a backend
cannot see in an initially empty lazy model.  Closing under all 40,320 point
permutations was measured and rejected: after fixing the first triple, only its
720-element stabilizer is a model symmetry, and the larger callback cost
dominated the node reduction.

The expanded colouring CNF was stopped after 25 minutes without a result.  It
reached 1.78 GiB maximum RSS.  The compact solver stays near 64 MiB RSS on the
same decision.  A compact Gurobi model is also mathematically valid, but the
installed restricted license rejects its roughly 5,000 witness variables; that
is a license boundary, not a model failure.

The first compact CNF used 16 interchangeable witness slots for the at-most-16
constraint.  That introduced a `16!` backend symmetry: after 4.5 minutes its
incomplete proof stream had reached 326 MiB.  Replacing slots by the exact
sequential counter makes the satisfiable control roughly two orders of
magnitude faster and removes 22,400 clauses.  The slot proof was stopped and
retained with an explicit `.slot-incomplete` name; it is not evidence.

The proof layout imports the proved lower bound directly into the same
sequential counter and splits cardinalities 15 and 16. After the first triple
is fixed, its `S_3 x S_5` stabilizer has exactly three orbits on a second
triple, classified by intersection size 2, 1, or 0. The stabilizers of those
pairs give 9, 12, and 7 third-triple orbits respectively, hence 28 cases per
weight. An in-tree exhaustive `S_8` checker verifies those representatives,
the stabilizer orders `48/24/72`, and complete coverage.

This split did not yet close a case: twelve proof-producing Kissat workers ran
for about fifteen minutes, while twelve native workers each exhausted a
`2^24`-slot, 128 MiB duplicate table in about four minutes on the earliest
cases. All associated streams are explicitly incomplete and are not evidence.
A fourth orbit split would have 559 cases per weight and did not make one
diagnostic parity-native subcase immediate. The current Gurobi diagnostic
therefore changes its lazy symmetry closure from a 720-cut callback storm to a
tunable bounded pulse.

The native continuation now imports the same symmetry inside the search rather
than only between workers. For a caller-supplied fixed root, it precomputes the
full setwise point stabilizer and hashes each partial family by its least group
image. The group table is built before search; the iterative DFS canonicalizer
uses fixed storage and allocates nothing in the hot loop. The mode is opt-in,
so existing small and symmetry-free paths pay no cost. On the exact `n=6`,
budget-11 exclusion, the 36-element stabilizer reduces `50,349 -> 3,558`
visited states. Twenty-one interleaved rounds give a 5.7845x geometric
wall-time ratio (5.8799x median, paired log-ratio `t=55.493`). Perf counters
fall from 1.049 billion to 105.7 million instructions and from 508.1 million
to 57.0 million cycles.

The target-shaped `n=8`, fixed-root `[0,1,2]`, budget-10 exclusion has a
72-element stabilizer and reduces `302,471 -> 8,759` states. Three interleaved
diagnostic rounds give a 30.18x geometric wall-time ratio (31.66x median,
paired log-ratio `t=69.663`); one counter pair reduces 63.64 billion to 2.082
billion instructions, 28.18 billion to 0.925 billion cycles, and 397,975 to
18,260 cache misses. A 60-second budget-16 probe of this rooted case timed out
without a result and is not evidence. The reduction nevertheless removes the
largest known repeat-work factor before another proof-producing run.

Profiling the actual budget-16 worker assigned 85.6% of cycles to rebuilding
and checking cut graphs. Monotonicity now carries a two-word unresolved-cut
mask down the iterative DFS: once a partial family separates a cut, no
extension revisits it. This adds a statistically clear 1.1457x on the `n=6`
control (`t=5.554`) and a smaller, inconclusive 1.0221x on the rooted `n=8`
control (`t=1.338`). The representation is still fixed-size and allocation-free.

The larger local win is a compiled crossing-triple mask for each cut. Selected
edge insertion now ignores non-crossing triples before the bitmap BFS, and
failed-colouring clause construction iterates only the structurally possible
triple bits instead of scanning all 56 variables. Against the already
symmetry-quotiented and residualized build, 21 interleaved rooted `n=8` rounds
give another 1.7462x geometrically (1.7818x median, paired log-ratio
`t=38.219`). Five-round counters reduce cycles `910.5M -> 521.7M`, branches
`412.0M -> 291.2M`, and branch misses `19.62M -> 6.01M`; instructions fall
only `2.063B -> 1.940B`, so most of the gain is better independent work and
branch behaviour. Relative to the pre-symmetry worker, the completed rooted
`n=8` control is about 52.7x faster.

The next profile assigned 31.1% of hard-worker cycles to reconstructing every
group image from all selected triples. The DFS now retains one pre-sized image
accumulator per symmetry and depth: a child performs one OR per symmetry and
canonicalization becomes a flat minimum scan. Thirty-one interleaved rounds
add 1.0769x geometrically (1.0860x median, paired log-ratio `t=6.798`), with
cycles `521.3M -> 481.1M` and instructions `1.940B -> 1.880B`. This lifts the
cumulative completed rooted `n=8` control to about 56.7x over the original
worker, without allocation in the DFS loop.

Same-colour clause reconstruction is now a factored meet-in-the-middle lookup.
For each cut, separate low-half and high-half tables are joined through a
low-vertex/high-colouring incidence factor; the hot path uses about ten indexed
ORs rather than up to 48 triple-pair tests. At eight points the exact pool is
226,368 words (1,810,944 bytes), 18.75x smaller than the 4,244,480-word full
colouring table. Thirty-one interleaved rounds add 1.2007x geometrically
(1.2072x median, paired log-ratio `t=15.495`). Five-round counters reduce
instructions `1.880B -> 1.209B`, cycles `481.9M -> 425.8M`, and branches
`275.9M -> 224.7M`; the lookup trades for more cache misses, but peak RSS rises
only `34,256 -> 36,112` KiB. The cumulative completed rooted `n=8` speedup is
now about 68.1x.

A parity-DSU replacement for the 16-vertex bitmap BFS was also measured and
rejected. Its dependent find/union chains made the same exact control 1.674x
slower across 21 rounds (old/new geometric ratio `0.5971`, `t=-56.292`). The
bitmap kernel remains the admitted implementation.

A `1/256`-scaled feasible dual packing of the residual context hitting set is
mathematically valid but also rejected from the runtime. It changes no prune on
the rooted control (`8,759` states both ways) and is 25.5% slower across 21
interleaved rounds (old/new geometric ratio `0.7965`, `t=-22.534`). The useful
artifact from that pass is retained: an exhaustive five-point test computes the
true minimum extension distance for every partial family and verifies that all
admitted packing/incidence lower bounds never exceed it.

The duplicate table now has an opt-in exact combinatorial key. For a fixed
root, a partial family is encoded by its cardinality layer and colex rank among
subsets of the nonfixed triples. The weight-15 three-triple roots need only 39
bits, so one open-addressing slot uses five bytes rather than eight; no
fingerprint or collision risk is introduced. Exhaustive five-point keys are
injective, wide and compact searches have identical metrics, and the compact
insertion loop allocates nothing. At `2^22` slots, seen storage falls
`32 -> 20` MiB and process RSS `36,680 -> 24,420` KiB. Twenty-one interleaved
rounds under the memory-loaded orbit sweep give a 1.0360x geometric speedup
(`t=2.075`). At `2^27`, the exact table is 640 MiB instead of 1 GiB, making the
next failed-orbit retry materially cheaper.

The full 28-case weight-15 third-orbit diagnostic has now run at `2^26` wide
slots with twelve concurrent workers. Exactly two rooted cases close:
`[0,1,2]` and `[0,1,6]`; the other 26 terminate only because the exact table is
full. Per-case wall times range from 204.67 to 839.06 seconds (median 674.33)
and peak RSS is 528,080 KiB. The `[0,1,2]` case takes 310.37 seconds alone but
467.44 seconds in the 12-way sweep, quantifying the random-table contention.
These are deterministic diagnostic exclusions, not independently replayable
UNSAT certificates, and they do not raise the proved lower bound.

The first compact `2^27` retry targets failed root `[0,1,11]`. It also exhausts
exact capacity after 1,232.68 seconds at 659,164 KiB peak RSS. The loaded run is
not a speed comparison, but it confirms that five-byte keys make 134,217,728
exact slots practical while a second doubling still does not close this case.
Further syntactic-table growth is therefore abandoned in favour of the
semantic closure quotient below.

The next theorem-derived state reduction is sharper than mask compression. For
each cut, retain either an absorbing separated flag or the parity-labelled
connected-component closure of the current bipartite constraint graph. At a
fixed selected cardinality, two families with the same 127-component closure
tuple have the same closure-extending moves and exact optimal continuation
value. A syntactic re-addition can distinguish traces when a triple belongs to
only one representative, but it changes no closure in either and is strictly
dominated; thus the claim is optimization equivalence, not literal trace
congruence. Exhaustive five-point grouping by cardinality and closure signature
confirms equal exact completion distance in every class. The signature writer
uses caller storage and allocates nothing. The 26 capacity failures show that
testing this semantic closure is preferable to enlarging syntactic mask tables
again.

The first exact census substantially lowers that admission estimate. At five
points, cardinality plus closure reduces only `1,024 -> 1,015` states; the
per-cardinality counts are `1,10,45,120,210,252,210,120,45,1,1`, so all nine
merges occur at the nearly complete cardinality-nine layer. The quotient is
correct but not yet a scaling win. Before building an interner, the next gate
is a streamed collision census over a bounded prefix of real eight-point
search states. Low collision density would redirect effort to aggregate rank
bounds and proof production instead.

Three further hot-path alternatives are rejected. Incidence-maximizing ties
between equally short branch clauses increase the rooted control from 8,759 to
10,262 states. Packing the two cut-edge IDs into one `u16` is neutral on both
search (ratio `0.988`, `t=-0.842`) and fractional separation (`0.990`,
`t=-1.532`). Greedy bipartite-component flips reduce shallow duplicates but
leave the budget-12 closure at exactly 324,456 states while adding about 40%
wall time under the active sweep. The admitted rules remain shortest-context
branching and the two-byte pair representation.

Three equal 300-second pulse controls retain the known 17-query incumbent but
leave the certified lower bound at 15. One context times 16 rotating orbit
images visits 179,851 nodes; four contexts times four images visits 273,890;
and sixteen contexts with identity only visits 262,384. The `4 x 4` shape is
the best throughput point, but no integer-incumbent-only pulse changes the
bound. This identifies the backend pathology: lazy constraints arrive too late
to strengthen the fractional relaxation.

The missing exact user-cut oracle is now implemented in Rust. Fractional
separation on one cut is weighted MaxCut on a rook graph with at most 16
vertices. Complement symmetry fixes one colour, and Gray-code enumeration
updates only the six edges incident to the flipped cut-edge vertex. The kernel
returns a caller-sized batch of the lightest distinct-cut inequalities, uses
fixed stack storage, and allocates nothing. Exhaustive five-point colourings
agree exactly. On the quiet 8-point control, branchless sign-bit accumulation
reduces a complete 127-cut pass from 34.77 ms to 8.14 ms, a 4.27x speedup. A
three-round, 100-pass counter run is stable to 0.13% and gives 236.1 million
instructions, 40.39 million cycles, about 1,200 branch misses, and 178 cache
misses per complete pass. The next backend step is to expose this batched
separator at fractional MIP nodes or consume it in the native LP lower bound.

That boundary is now exercised through a persistent binary sidecar. Each
request sends 448 bytes of fractional query weights; the Rust process returns
up to sixteen `(cut, mask, weight)` records and stays near 2 MiB RSS. At a
100-node pulse, Gurobi adds 31,941 exact user cuts in 2,586 calls during 300
seconds. A corrected same-node schedule adds 31,772 cuts in 2,569 calls. Both
runs retain bound 15 and incumbent 17, visiting 260,318 and 258,665 nodes;
the integer-only `4 x 4` control visits 273,890. Thus the first-order context
inequalities reduce reported Gurobi work slightly (`459.62 -> 423.70`) but do
not improve the certified bound and cost about 5.6% node throughput. This is a
measured negative for C880, not a defect in the separator. The next useful
bound must aggregate contexts into cover/rank inequalities or branch in the
compiled quotient; more lazy/user-cut pulse tuning has low expected value.

One backend trust defect was exposed by asking only the unresolved
cardinality-16 feasibility question. Gurobi 13 installed a presolve heuristic
solution of weight 15 without delivering it through the expected `MIPSOL`
proof boundary; independent exact replay rejected it. The driver now wraps the
callback solve in an outer solve--replay--cut loop. Every escaped incumbent is
checked, all witnessed contextual failures are installed as ordinary
constraints, and the remaining wall-time budget is carried into the restart.
Non-replayed incumbents are reported as null. In a 300-second control this
boundary installed 109 replay constraints, explored 459,437 nodes, and retained
only the honest bound 15 with no replayed cardinality-16 incumbent. The
solver's displayed objective 16 was not accepted.

The universal three-edge crossing floor is now explicit for all 127 cuts. It
is exact as a necessary consequence of an odd cycle, but a 300-second
optimization control remains at incumbent 17 and bound 15 (`253,046` nodes,
`465.85` work), so it is not the missing rank inequality. A tempting stronger
shortcut was rejected in hostile review: although the ambient constraint graph
is a line graph of a complete bipartite graph, the *selected* graph is a
non-induced subgraph and may omit ambient chords, so non-bipartiteness does not
force a selected triangle. Safe strengthening must retain the full
rank-stratified odd-cycle hierarchy.

## Boundary and next gate

- A Gurobi optimum is not an independently replayable proof of the lower
  bound.  A final exact-value claim needs either the complete streamed CNF plus
  a checkable UNSAT proof, or a smaller structural certificate.
- The native verifier is independent of both solver encodings and is the
  acceptance gate for any returned family.
- If `g(8)=17`, the result sharpens only C880's additive attachment constant;
  it does not change the `9/8` leading coefficient.  Its larger value is as a
  non-coding flagship for theorem-derived exact state compilation.
- The same cut-edge-colouring reduction applies to larger attachment blocks;
  the representation must move beyond one `u64` after eight points.

The highest-EV continuation is to finish the 16-query decision, retain a
replayable certificate, and then extract a human lower-bound motif from the
solver's orbit-closed obstruction family.  That would turn the classical link
criterion and C880's mask computations into corollaries of the more general
cut-context theorem.

## Mystery ledger

- **Unsettled:** why the cardinality-16 relaxation stays at bound 15 after
  first-order context cuts and the crossing floor. The evidence gap is a
  genuinely aggregate cover/rank inequality or a complete quotient-branch
  proof; C985 owns it.
- **Partly settled:** native orbit workers repeated symmetry-equivalent partial
  families and rechecked discharged/non-crossing contexts. Setwise-stabilizer
  canonicalization plus monotone residualization and crossing masks removes up
  to about 68.1x wall time on completed controls after incremental group-image
  accumulation and the factored clause lookup. The full weight-15 sweep closes
  only 2/28 cases before `2^26` capacity; the owning successor is the exact
  parity-closure contextual quotient, followed by proof-producing replay.
- **Settled:** a displayed generic-solver incumbent is not automatically a
  certified Ergodis incumbent. The independent outer replay boundary now
  catches callback-delivery gaps and refuses unreplayed objectives.
- **Settled negative:** ambient line-graph chordality does not collapse
  selected odd cycles to triangles; the induced/non-induced distinction blocks
  that shortcut.
