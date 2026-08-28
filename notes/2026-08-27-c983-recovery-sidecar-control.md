# C983 recovery control and common provenance sidecar

**Lane**: `complete-ports`  
**Date**: 2026-08-27  
**Disposition**: three-exemplar architecture gate accepted; C983 remains open  
**Scope**: private Rust/Python research artifact; no manuscript, mirror, export,
push, deposit, novelty, or performance claim

## Verdict

Recovery now passes through the same finite observational compiler and
independent verifier as the bounded tropical-WTA and determinized
resource-batch fixtures.  All three adapters also use one common cold replay
sidecar: an exact-presentation fingerprint, adapter/law ID, concrete start and
generator trace, concrete terminal state and observation, and a root in a flat
domain-neutral provenance DAG.

This passes C983's three-exemplar architecture gate.  It does not close C983.
The recovery control uses a finite request-projection schema, not hierarchical
outer-block composition; compile/query economics and specialized controls are
still unmeasured; the fingerprint is deterministic but noncryptographic; and a
fresh independent implementation review remains open.

## Recovery control

The raw carrier is all 16 binary `2 x 2` demand matrices for the triangle gauge

```text
G = [1 0 1]
    [0 1 1].
```

The primitive observation is the exact minimum union-support cost returned by
the existing `GeneratedSpanTable` recovery kernel.  The two total generators
retain request column 0 or request column 1.  They generate the complete stated
query schema: joint recovery, either singleton request, and the zero request.
States are enumerated before quotienting; transitions are raw demand
projections, not desired quotient transitions or response signatures.

Exact results:

| quantity | value |
|---|---:|
| raw demands | 16 |
| terminal-cost fibres | 3 |
| contextual classes | 5 |
| class sizes | `6,3,3,3,1` |
| strict refinement rounds | 1 |
| pairwise separators / stored generator steps | `96 / 27` |
| dense quotient bytes | 184 |
| certificate bytes | 2,412 |
| provenance-arena bytes | 1,212 |
| concrete replay-record/path bytes | 2,944 |

The same-cost states `1` and `2` are separated by retaining request column 0,
so the result is not terminal-output deduplication.  Exhaustive checks compare
every raw state under every generated projection behavior against a fresh
`GeneratedSpanTable` query and quotient replay.

For every terminal demand the adapter retains a concrete support, solves for a
binary coefficient matrix, and replays

```text
G_support * coefficients = demand.
```

It derives support from the nonzero coefficient rows, recomputes cost, and
checks the three helper loads.  The independent Python oracle separately
enumerates helper subsets and coefficients and agrees on costs, supports,
coefficients, and loads.

## The witness boundary that survived red team

Observational equivalence preserves requested values, not arbitrary witnesses.
The two rank-one demands with state IDs `3` and `12` have the same complete
projection-response signature and therefore the same quotient class, but their
valid singleton supports are helper 0 and helper 1 respectively.  Replaying
state 3's equation against state 12 is rejected.

The sidecar therefore never answers a concrete query from a class
representative's witness.  It replays the generator word from the original
concrete state, checks concrete/quotient commutation at every step, and selects
the provenance root attached to the concrete terminal state.  Witness
transport between class members would require a separate verified lift that is
not present here.

## Common sidecar contract

The observational hot state remains unchanged.  The cold sidecar supplies:

- a stable 128-bit fingerprint of exact sorts, observations, typed generators,
  and transition tables;
- an explicit adapter/law ID and infinity convention;
- flat 32-byte replay records with concrete start, path range, terminal,
  observation, and provenance root;
- a flat append-only DAG with 32-byte nodes, `u32` payload words, and `u32`
  child IDs; and
- a structural verifier for contiguous ranges, child-before-parent order,
  profile/adapter binding, well-typed concrete paths, concrete/quotient
  commutation, terminal observations, and missing-witness rules.

The generic layer proves structure and value binding.  Each adapter still owns
the semantic replay law for its payload:

- WTA tree structure and exact tropical valuation/run;
- ordered resource assignments, capacities, terminal loads, and makespan; and
- recovery coefficients, support, cost, and helper loads.

This is deliberate.  A universal payload interpretation would erase the
domain semantics that make a witness valid.

Exact exhaustive sidecar payload sizes are:

| adapter | DAG nodes/payload/children | replay records/paths | total sidecar |
|---|---:|---:|---:|
| WTA | `1,248 / 312 / 104` | 416 | 2,080 |
| resources | `6,976 / 6,768 / 0` | 9,240 | 22,984 |
| recovery | `512 / 700 / 0` | 2,944 | 4,156 |

These are fixture-audit exports, not compressed production artifacts.  The WTA
export deliberately duplicates shared subtrees, and the resource export stores
every exhaustive query witness.  No storage or runtime advantage is claimed.

## Sharpening: a matroid-rank response corollary

The triangle fixture exposes a broader exact recovery family.  If the helper
dictionary contains one unit-cost representative of every projective line in
`F_q^k`, the minimum helper union needed for a demand matrix `D` is exactly
`rank(D)`: a basis of the demand column space gives the upper bound and every
helper contributes at most one dimension for the lower bound.

If admissible contexts retain request subsets `S`, the complete observational
response is

```text
S -> rank(D_S).
```

Thus the contextual quotient is equality of the representable matroid rank
function on the request columns.  For two binary requests in dimension two,
the realizable triples

```text
(rank(D), rank(D_{0}), rank(D_{1}))
```

give exactly the five compiled classes.  Finite matroid/polymatroid rank
responses are therefore a classical recovery corollary of the more general
observation-relative compiler, and a promising bridge to multi-request
network coding and submodular interface summaries.  This is a derived family,
not a claim that matroid rank equivalence is new.

## Validation

Accepted from the Ergodis crate directory:

```text
nix develop -c cargo fmt --all --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-features
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#python3 --command python3 python/check_observational_fixtures.py
```

Hostile coverage includes malformed and ill-typed presentations, altered
quotient observations/transitions, false or missing separators, out-of-range
separator paths, cyclic/forward provenance edges, stale presentation
fingerprints, wrong adapter IDs, altered replay generators/observations,
missing finite witnesses, and the incompatible-equivalent-recovery-witness
case.  The existing Python parity corpus continues to check recovery costs,
witnesses, and helper loads independently.

## EJ / TT / red-team / VB closeout

**EJ.** The cheap extra value is the exact matroid-rank response
interpretation: the 16-state fixture is not merely a smoke test but the first
member of a projective-complete multi-request family.  Concrete terminal roots
are reusable across many traces, so witness retention need not scale one root
per query even when trace records do.

**TT.** The right invariant is the whole admitted rank function, not rank of the
joint request alone.  The compiler rediscovers the five realizable rank triples
without being told matroid theory.  The next mathematically honest extension is
not more projection examples; it is ordinary/target labelled `CostTable`
carriers under actual hierarchical composition, with depth encoded by sorts.

**Red team.** The carrier is raw, the observation primitive, the context family
closed and explicit, and the recovery oracle independent.  Representative
witness substitution fails on a concrete regression.  Remaining weaknesses:
the request-projection schema is narrower than the paper's outer contexts;
sidecar payload semantics are adapter-tested rather than described by a
versioned public schema registry; the fingerprint is not cryptographic; and no
reuse economics have been measured.

**VB.** GREEN for the shared three-domain deterministic architecture and
concrete witness-soundness boundary.  AMBER for C983 overall: the architecture
is now real, but actual hierarchical recovery composition and measured
economics still decide whether it is a useful application framework rather
than only a correct reference compiler.

## Mystery Ledger

### Settled

- Recovery can use the unchanged generic minimizer/verifier without importing
  quotient classes or response signatures into the raw carrier.
- One common flat sidecar can bind exact presentations and concrete traces
  across all three domains while leaving semantic replay domain-specific.
- Value-equivalent recovery states can have incompatible witnesses; concrete
  terminal binding is necessary.
- The five recovery classes are exactly the five realizable two-request
  representable-matroid rank responses.
- The three-exemplar architecture gate is passed.

### Open

- Route ordinary/target labelled recovery tables through actual hierarchical
  composition rather than request projections.
- Define a versioned semantic payload registry if sidecars become a public
  interchange format.
- Decide whether a cryptographic artifact digest is needed beyond deterministic
  in-process fingerprinting.
- Compact WTA DAG sharing, resource query traces, and pairwise separators only
  after exact replay remains unchanged.
- Measure compile time, peak RSS, query throughput, reuse break-even, and best
  specialized controls on larger recovery/WTA/resource fixtures.
- Obtain a fresh independent cold implementation review.

### Deferred

- potential/Pareto, relational/Kleisli, controlled-game, tensor, and learned
  realization backends remain outside this deterministic gate.

### Dead route

- class-representative witnesses for concrete value-equivalent states;
- prequotiented recovery response vectors masquerading as a raw carrier; and
- claiming the projection control covers hierarchical outer composition.
