# C985 post-C1000 theorem-kernel mining

**Lane:** `complete-ports`  
**Status:** first implementation tranche landed; continuing campaign integration.

## Decision

The post-C1000 reports contain a reusable algebraic front end, not merely a
collection of domain fixtures. The highest-value imports are the smallest
exact mechanisms that recur across several reports:

1. modular independence of consecutive matrix powers;
2. scalar local graph obstructions;
3. exact integer extraction from quadratic counting inequalities;
4. product character sums with bad-prime detection; and
5. bounded-memory candidate evolution and evidence streaming.

These are public-core shapes. Arc, matching, Gram-shadow, projective, and
task-specific feature extractors remain private adapters.

## Mined inventory

| Source | Reusable theorem/computation shape | Prior Ergodis fit | Decision |
|---|---|---|---|
| C1001/C1007/C1009/C1010 | component-sensitive bounds reduce to exact integer windows for `q(a-q) >= b` | callers used Python/root arithmetic | landed as overflow-safe `concave_quadratic_window` |
| C1005/C1008/C1012 | one matrix/relation generates a known finite algebra when `I,A,...` have full declared dimension | no exact integer-matrix power certificate | landed compact modular nonzero-minor compile/replay kernel |
| C1002/C1008 | wedge deficit is twice the induced-`P3` count; zero exactly for cluster graphs | pattern recognition stayed in research scripts | landed allocation-free packed-graph census |
| C1013/C1014 | quadratic-character census, product twists, squarefree preflight, bad-prime routing | single polynomial and linear twist already fit | landed nonmaterialized product census and exact `gcd(f,f')` degree |
| C1008/C1009/C1011 | controller proposes and audits finite predicates | CLI evolution retained/transported too much and synthesized Boolean leaves did not type-check | landed streaming evolution API, bulk daemon evaluation, Boolean VM constants, synthesis regression |
| C1011 | adaptive/nonadaptive query design over a finite incidence system | ceiling could show ambiguity but could not construct query strategies | landed flat adaptive/nonadaptive compilers, verifiers, and pair-query lower bound |
| C1005/C1012 | coherent closure and fusion-primitivity | spectral sufficient condition was covered; Hadamard/common-neighbour closure was not | landed exact transpose/intersection-count coherent refinement |
| C1013/C1014 | higher characters, Jacobi sums, cyclotomic cosets, curve-supported sums | quadratic characters only | landed exact higher-character, coset, Jacobi, and cyclotomic censuses; curve support remains |
| C1015 | Hamilton-pair parity, exact-cover sums, and shared-two-label closure | row evaluation could stratify by a key but could not form permutation-invariant parent states | landed bounded multiset compilation; retain typed linear-constraint closure as the next kernel |

## Landed tranche

Commit `a34496bed` adds:

- `modular_power`: a compact pivot-coordinate certificate. Replaying the
  selected minor proves independence modulo a prime and therefore over the
  rationals for an integral matrix. Algebra containment and the ambient
  dimension remain explicit external hypotheses.
- `graph_obstruction`: a packed, allocation-free census computing edges,
  triangles, induced three-vertex paths, cluster-graph status, and the
  odd-component parity consequence.
- `theorem_search::evolve_implications_streaming`: long campaigns retain only
  the current generation, structural archive, and best sound candidate while
  handing every exact trial to a caller-owned sink.

Commit `39f5c3a6f` adds:

- `quadratic_window`: exact nonnegative integer roots without floating point;
- general product-polynomial quadratic-character census without materializing
  the product;
- exact reduced-polynomial repeated-factor degree via `gcd(f,f')`;
- a zero-allocation regression for the product census;
- typed Boolean constants, repairing decision-tree synthesis;
- one-request candidate batches whose full records stream to bounded,
  create-only campaign evidence while only a compact top set returns;
- optional feature-generator name/version/digest provenance; and
- process-qualified monotone request identifiers.

All additions are outside the solve loop. Existing search workers gain no
branch, allocation, controller state, or communication path. The product
character census is allocation-free after setup and has an explicit allocator
regression.

The next tranche adds `coherent_closure`, the highest-ranked remaining kernel.
It compiles the coarsest ordered-pair coloring closed under diagonal
distinction, transpose, and every two-step intersection count, and replays the
complete deterministic result. Its presized flat `(color,color)` pool and
explicit 16-byte signature records avoid one allocation per ordered pair. A
five-cycle control reaches rank three by both the new coherent route and the
modular-power route.

The following query-design tranche takes arbitrary binary hypothesis masks,
constructs and replays nonadaptive separating families and flat adaptive trees,
and never recurses. For pair-membership queries it imports the component
theorem that a separating selected-edge graph has at most one isolate and no
two-vertex component. An iterative connected-triple exact cover attains the
resulting lower bound when possible. On the frozen private C1011 incidence,
the generic engine independently returns the exact known values: 14
nonadaptive queries and adaptive depth 11. The private control is isolated in
`ergodis-private/controls/query-design-c1011`; no projective or task vocabulary
enters the public module.

## Evolve/control consequences

The new batch operation is the bridge from the current external
`ergodisctl evolve` loop to daemon-owned evolution:

- one generation can be evaluated under one request and one ledger event;
- full trial records go directly to a bounded JSONL file;
- only the top compact scorecards need cross the socket;
- feature-generator provenance binds offline derived fields to an identity,
  version, and digest; and
- a fitted predicate remains diagnostic only because the daemon still reports
  `proof_authority: false`.

The next systems slice moved mutation ownership into one low-priority daemon
job using this batch/evidence boundary. It exposes start/status/cancel, shares
the frozen batch immutably, publishes progress through one isolated 64-byte
atomic record, and joins only on completion. It does not run in a search worker
or add a search-path poll. Durable population/archive checkpoint-resume and
successive-halving scorecards remain open.

The C1015 Hamilton-gap diagnostic exposed a separate representation ceiling:
its useful assertion is about the sum of seven residual matchings belonging to
one exact cover, whereas the campaign VM saw only individual matching rows.
The new `multiset` compiler canonicalizes arbitrarily ordered children by
parent key and produces checked counts, sums, minima, and maxima under explicit
row/group/cell bounds. `FeatureBatch::aggregate_uniform_groups` turns those
summaries into ordinary dense parent rows; labels must agree within each
group, every parent has unit weight, and the parent key is retained only as
the evidence row identifier—not exposed as a learnable feature. This prevents
the trivial key-memorization failure mode.

The optional daemon now exposes `group-compile`, and `ergodisctl group-compile`
streams the compiled parent campaign to a create-only run-relative JSONL file.
The unchanged allocation-free VM, tree synthesizer, batch evaluator, and
evolution worker can consume that file in a follow-on campaign. A synthetic
seven-child regression recovers an exact sum threshold from 21 child rows;
another round-trip regression writes, reloads, and verifies the parent data.
No group operation enters a solve worker or a per-candidate cross-row loop.

## Highest-EV remaining kernels

1. **Typed linear-constraint closure.** Compile small incidence/interpolation
   identities and propagate equality, parity, and pencil-membership closure.
   C1015 is a strong private fixture; public semantics should be generic
   finite-module constraints.
2. **Compact coherent transcripts.** The deterministic final-color replay is
   exact, but large public certificates should stream refinement splits or
   intersection tables rather than duplicate all compiler work.
3. **General exact query optimization.** The pair-query triple-factor case is
   theorem-optimal and the generic constructors always emit exact replayable
   strategies, but arbitrary-mask minimum nonadaptive selection and
   minimum-depth adaptive trees remain bounded exact-search backends.

The higher multiplicative-character layer is now landed. It compiles a
primitive-root class table for any order dividing `p-1`, emits exact
root-of-unity coefficient witnesses for polynomial and Jacobi sums, supports
input-coset-restricted censuses, and returns the complete cyclotomic-number
matrix. The table uses one, two, or four bytes per field element according to
the character order rather than retaining full discrete logs. At order two
its coefficient difference is regression-checked against
the pre-existing packed quadratic-character implementation. This makes the
classical quadratic path a specialization while preserving its denser one-bit
representation and faster dedicated tally loop.

The first finite-polynomial slice is also landed. Exact reduction modulo
`x^p-x` produces the canonical degree-below-`p` polynomial function, and a
presized forward-difference state enumerates the whole field using modular
additions only. The recurrence is iterative, rewinds without allocation, and
feeds the existing quadratic and higher-character censuses. On the degree-14,
`p=65,537` Criterion control it reduces the quadratic census from 2.4463 ms to
684.71 us (`3.573x`) with identical output. Squarefree factor-degree profiles
and general polynomial remainder arithmetic remain open.

## Acceptance and non-goals

- A bounded perfect classifier is never pruning authority.
- Domain field names and presentation hashes are not theorem semantics.
- No C identifier, private research vocabulary, or task fixture enters public
  Ergodis.
- The compiler may allocate; every admitted solve kernel still needs a
  presized, iterative, allocation-free execution boundary.
- Large evidence is streamed and explicitly truncated at a predeclared bound;
  no file-sized payload is retained in memory.

## Validation

At Rust 1.87.0, both landed commits passed `cargo test --all-features` and
strict all-target/all-feature Clippy. The new product census passes the real
allocator-counting harness with zero allocations. No solve hot loop or hot
record changed, so a solver counter A/B was not triggered by this tranche.

The bounded-multiset tranche additionally passes all 324 library tests and all
all-feature/all-target integration and benchmark-style test targets at Rust
1.87.0. Strict all-target Clippy passes with `control-plane` alone. That check
also found and repaired the feature declaration: `control-plane` now enables
its direct optional `libc` dependency instead of compiling only when the
unrelated `parallel` feature happened to enable it.
