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
| C1011 | adaptive/nonadaptive query design over a finite incidence system | ceiling can show ambiguity but cannot optimize query cost | next-tier generic query-design compiler/certificate |
| C1005/C1012 | coherent closure and fusion-primitivity | spectral sufficient condition now covered; Hadamard/common-neighbour closure is not | highest-EV remaining theorem kernel |
| C1013/C1014 | higher characters, Jacobi sums, cyclotomic cosets, curve-supported sums | quadratic characters only | high-value algebraic extension after coherent closure |
| C1015 | Hamilton-pair parity and shared-two-label closure | generic incidence/group kernels exist, but no typed linear-constraint closure engine | retain as a private fixture for a future interpolation/closure kernel |

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

## Highest-EV remaining kernels

1. **Coherent closure / fusion compiler.** Start from one or more exact
   integral relation matrices, refine by transpose, Hadamard atoms, and
   multiplication/common-neighbour counts, and emit a replayable partition
   transcript. This generalizes the fixed C1008/C1012 sparse-shadow results
   and complements the spectral sufficient condition already landed.
2. **Finite query-design compiler.** Accept hypothesis-by-query incidence
   masks; certify separating nonadaptive families and adaptive decision trees;
   then add exact optimization for bounded instances. C1011's `22/66` fixture
   is the known-answer gate, but the public API is fault diagnosis and active
   identification.
3. **Higher multiplicative-character layer.** Compile a cyclic log table once,
   support coset-restricted censuses and exact Jacobi sums, and retain
   positive/zero/class counts as witnesses. This directly absorbs the
   C1014 cyclotomic-number work.
4. **Finite polynomial algebra.** Extend the landed derivative/GCD preflight
   to squarefree factor degrees, reduction modulo `x^p-x`, and recurrence
   compilation. This prevents callers from using symbolic systems merely to
   shape a character-sum request.
5. **Typed linear-constraint closure.** Compile small incidence/interpolation
   identities and propagate equality, parity, and pencil-membership closure.
   C1015 is a strong private fixture; public semantics should be generic
   finite-module constraints.

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
