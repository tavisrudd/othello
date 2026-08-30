# ADR: Ergodis semantic mining engine

**Date:** 2026-08-30
**Status:** accepted for private incubation

## Decision

Move the repeated Python search-to-theorem workflow into an optional private
Ergodis layer driven by declarative **semantic mining recipes**.  Python remains
the fast hypothesis laboratory.  Stable operations migrate to allocation-free,
streaming Rust kernels; every promoted result carries an independent replay
artifact.  Nothing problem-specific enters the public Ergodis core until at
least two domains use the same abstraction.

The engine does not claim to prove discovered lemmas.  It produces a compact
lemma packet:

```text
domain and exact label predicate
semantic feature and symmetry declarations
pure/extremal strata with support counts
minimal orbit or parametric representatives
fitted exact identities
nearest counterexamples and ablations
finite implication/replay certificate
remaining source-language proof obligations
```

## Why

The current manual loop is effective but repetitive:

1. stream a finite certificate table;
2. invent a semantic representation;
3. compute exact features and find a separator;
4. quotient the exceptional rows by symmetry;
5. fit a finite-field formula;
6. recognize a classical action or structural family;
7. restate the finite result as a lemma and identify its proof gap.

The C973 control compressed 2,106 extremal witness pairs to one additive-plane
two-point switch, one divided-power translation orbit, and semilinear
equivariance.  A second pass found that all 6,890 split `e_3` locators are
within four replacements of an affine plane.  The exact ambient census has
4,686,825 nine-sets; precisely 2,106 have maximum affine-plane overlap four,
and all 2,106 are nine-caps.  None satisfies the `e_3` Hankel label.  An
automated engine should surface the candidate lemma

> a split nonic with `g2=g3=0` contains five points in an affine `F3`-plane

without requiring a human to hand-write three successive Python probes.

The next geometric canonicalization pass sharpens this further.  All 2,106
overlap-four sets are nine-caps, and `AGL(3,3)` is transitive on them: its order
is 303,264, the orbit has size 2,106, and the stabilizer has order 144.  This is
**not** yet a one-case Hankel proof.  Arbitrary `F3`-affine maps do not preserve
GF(27) multiplication or the fixed label `g2=g3=0`.  Even the relevant
`AGammaL(1,27)` action moves the `e_3` syndrome under translations.  The fixed
label stabilizer `GammaL(1,27)` has orbit size 78 on a cap, leaving 27 cap
orbits.  A sound canonicalizer must either prove label preservation or carry
the transformed label and quotient `(object,label)` pairs.

## Plan algebra

The plan language has exactly three transform verbs:

```text
match          attach exact semantic matches/features to streamed objects
reduce         aggregate, extremize, ablate, filter, or retain bounded cores
canonicalize   quotient retained objects by actions or exact parameterizations
```

`verify` is a mandatory gate around a plan, not a fourth transform.  Sources
and sinks are execution plumbing.  Domain words such as `affine_plane`,
`carry_state`, or `hall_deficit` name typed match adapters, not engine ops.

The C973 plan can therefore read:

```text
source split_nine_sets
match affine_subspace(rank=2, metric=max_overlap) as plane
reduce histogram(plane.overlap), minima(label=g2_g3_zero)
canonicalize under [translation, scaling, frobenius]
canonicalize fit divided_power_orbit(parameter=z4)
canonicalize near_misses under AGL(3,3)
verify replay_hankel, action_preservation, source_hash
sink lemma_packet, bounded_exceptions
```

The ops compose as a typed dataflow.  `match` may fan out bounded feature
columns but may not serialize.  `reduce` must declare its memory bound and
retention policy.  `canonicalize` runs only on a reducer's bounded retained
set unless explicitly supplied a streamed orbit partition.  This prevents an
innocent plan from materializing the full search corpus.
Every `canonicalize under action` op must declare whether the action preserves
the label, transports it through an exact action adapter, or is diagnostic
only.  The verifier rejects a proof packet built from a diagnostic quotient.

## Recipe model

A recipe has six sections which compile to that three-op algebra:

```text
source      streamed records and fixed-width semantic IDs
label       exact target predicate(s), never a learned surrogate
features    rank, incidence, orbit, support, polynomial, or strategy features
actions     declared generators with exact preservation checks
reducers    histograms, minima, cores, quotients, and parametric fits
gates       replay, negative controls, purity, completeness, and stop rules
```

The first feature vocabulary should be deliberately small:

- finite-set family overlap and hitting profiles;
- prime-field affine-subspace and cap recognition;
- exact rank/block ablation;
- finite group orbit closure and stabilizers;
- finite-field monomial/polynomial interpolation;
- Hall matchings and deficient sets;
- labelled scalar histograms and Pareto fronts.

Candidate generation searches compositions of these typed features to a
bounded depth.  Scoring is lexicographic: exact label purity, domain coverage,
description length, orbit/parameter compression, proof-language relevance,
then computational cost.  Statistical correlation is useful only for ranking;
it cannot pass a theorem gate.

## Execution architecture

1. **Source adapter.** Parse or generate records outside the search loop and
   compile them to fixed-width IDs, bit masks, or sparse sorted arrays.
2. **Feature kernels.** Run zero-allocation Rust loops over caller-sized
   workspaces.  Dense universes up to 64 points use machine-word masks and
   `popcnt`; larger sparse/dense cases choose compressed sorted sets or bitmaps
   by measured density.
3. **Streaming reducers.** Keep bounded histograms, extrema, sketches, and
   representative IDs.  Large witnesses stream directly to create-only files.
4. **Exceptional-state queue.** Only pure, near-pure, rigid, or surprising
   states enter a bounded side queue for orbit closure and verbose analysis.
5. **Symbolic fitter.** Exact finite-field interpolation and action matching
   run off the hot path.  It must emit all aliases and identifiability defects.
6. **Independent verifier.** Re-read the source and proposed packet without
   sharing the mining reducer.  Reject source drift by hash.

## Theorem assembly and composition

`match/reduce/canonicalize` produces typed theorem fragments, not final prose.
A downstream **theorem composer** stores them in an AND/OR hypergraph.  Each
fragment declares:

```text
domain and parameter sorts
universally/existentially quantified variables
hypotheses and conclusion in normalized predicate IR
observable and action contracts
dependencies and source provenance
status: candidate | finite-certified | proved
proof/certificate verifier
```

Hyperedges are a deliberately finite rule vocabulary:

```text
direct implication     specialization        exact transport
exhaustive case split  induction/descent     quotient-and-lift
bound arithmetic       witness substitution
```

The composer runs two bounded searches.  Backward chaining from a requested
target exposes the smallest missing obligations.  Forward saturation from
proved fragments finds cheap derived theorems and reusable interfaces.  It
scores plans by unresolved proof debt, number and generality of covered goals,
dependency stability, description length, and estimated verification cost.
Textual similarity is only a retrieval hint; it never discharges a premise.

Composition is typed and proof-status preserving.  A finite certificate cannot
be promoted to a theorem by composing it with proved facts.  Domain,
quantifier, and action/observable compatibility are explicit gates.  Every
successful hyperedge emits a composite certificate listing exact premise IDs,
substitutions, case coverage, transports, and remaining obligations.  The
independent verifier rebuilds this DAG without trusting the planner.

The same exceptional-state loop guides theorem search.  If composition stalls,
the unresolved predicate becomes a new mining label; Ergodis generates
positive/negative finite instances, searches semantic separators, and returns
candidate fragments to the graph.  This closes the loop:

```text
target theorem
  -> missing typed obligation
  -> match / reduce / canonicalize campaign
  -> finite-certified lemma packet
  -> source-language proof
  -> proved fragment
  -> larger theorem composition
```

Three current examples define the required generality:

- **PRS:** additive-plane switch identity + divided-power translation +
  semilinear transport compose the extremal packet; cap classification plus a
  paired cap/syndrome exclusion would yield the five-coplanar lemma; that lemma
  joins the switch margin to replace the GF(27) census structurally.
- **C80:** local charge-transport packets + Hall saturation + opponent
  completeness + strict descent/termination compose a global P strategy.
- **C896:** certified local carry transitions + base cases + a
  most-significant-digit induction compose the uniform socle theorem.

`semantic_theorems.rs` lands only the proof-safety status and composition
contracts.  Predicate IR and graph storage remain private design work until
these three examples force a common minimal interface.

## Lean kernel boundary

Lean 4 exposes the required in-process authority.  A Lean-side bridge can
construct a `Declaration` and submit it through `Lean.addDecl`; the underlying
kernel environment operation type-checks the declaration and returns a new
immutable environment or an exception.  Declarations containing metavariables
or free variables are rejected.  Ergodis must never use unchecked declaration
insertion or a kernel-skip option.

The kernel is a checker, not the theorem-search engine.  The division of labor
is:

```text
Ergodis                 normalized goals, mining, theorem DAG, proof plan
Lean elaborator/meta    names, implicit arguments, tactics, proof-term construction
Lean kernel             final declaration type checking and environment extension
```

Use two integration modes:

1. **Stable baseline.** Emit a compact certificate/theorem-DAG artifact and a
   generated Lean module.  The repository's guarded build checks it through
   the ordinary trusted path.  This is the reproducibility and release gate.
2. **Campaign bridge.** A persistent Lean executable imports the target
   environment once, accepts length-delimited batches over a Unix socket,
   constructs/checks declarations in process, and returns bounded structured
   results.  This amortizes startup and imports during rapid theorem assembly.

The bridge protocol should include environment/module hashes, fragment IDs,
normalized statements, certificate references, requested declaration names,
and resource limits.  Replies contain only status, declaration/type hashes,
used-axiom summaries, compact diagnostics, and timings; verbose elaborator
traces stream to per-run files on explicit request.  Each socket path remains
run-isolated as in the search control plane.

Do not bind the Rust miner directly to Lean's exported runtime/C symbols.  The
exported kernel entry exists, but Lean runtime object ownership and internal
ABI details are a brittle cross-language boundary.  A small version-pinned
Lean bridge gives typed ownership, imports, exception handling, and an easy
fallback to generated modules.

The bounded Rust prior-art and licensing audit is
`notes/2026-08-30-ergodis-rust-theorem-infrastructure-audit.md`.  No dependency
was added.  MM0, egglog, Ascent, Salsa, RustSAT, Differential Dataflow, and
Verus are separated into design-only, optional-spike, or deferred categories;
every future adoption requires an exact SPDX/transitive/MSRV/native-code intake.

For reflected finite certificates, prefer a small Lean checker plus a proved
soundness theorem.  Ergodis supplies data; evaluation proves the checker's
Boolean proposition; composition uses the soundness theorem.  For symbolic
steps, emit explicit proof terms or tactic-generated terms and let the kernel
check the resulting declaration.  Every composed theorem records the exact
Lean declaration dependencies, so a later environment change invalidates the
right DAG nodes rather than the entire campaign.

## Python and Lean bindings

Both clients share one versioned Ergodis protocol.  The protocol—not PyO3,
Lean FFI, JSON, or a particular daemon—is the semantic authority.  Requests
carry a schema version, run/socket identity, request ID, environment and source
hashes, resource budget, and one typed operation.  Large arrays and evidence
are referenced by immutable file/hash or mapped fixed-width buffers rather
than copied into messages.

The topology is deliberately asymmetric:

```text
Python client  -> Ergodis daemon -> candidate packets / streamed evidence
Lean client    -> Ergodis daemon -> candidate lemmas / missing obligations
Ergodis        -> Lean bridge    -> checked declarations / diagnostics
```

Python and Lean may request mining and composition, but neither binding can
mark a fragment proved.  Only the Lean bridge/kernel path can return that
status.

### Python

Start with a stdlib client over the framed Unix-socket protocol.  It is easy to
iterate, keeps the Rust core independent of CPython, and supports remote or
long-lived campaigns.  The ergonomic API should expose sessions, recipes,
bounded iterators over exceptional states, explicit evidence sinks, steering,
and cancellation.  It must not materialize full result streams by default.

After the protocol stabilizes, spike an optional PyO3/maturin extension for
in-process small/medium calls and buffer-protocol views.  Release the GIL around
Rust computation; accept caller-owned contiguous buffers; never call Python
from search hot loops.  Keep the socket client as the reference and fallback,
and test byte-for-byte agreement between transports.  PyO3 and maturin are
dual MIT/Apache-2.0 upstream, but still require the normal exact-version and
transitive intake before adoption.

### Lean

Start with a small Lean client speaking the same framed protocol to the Rust
daemon.  It submits normalized theorem interfaces, finite domains, exact
labels, and unresolved proof obligations, then receives untrusted lemma
packets.  A separate Lean-side kernel bridge checks completed declarations.
This keeps Lean runtime ownership out of Rust and amortizes imports in both
directions.

Only if socket overhead becomes material should we add a direct Lean/Rust FFI
transport.  Lean's FFI supports exported and external symbols, but its
reference-counted `lean_object` ownership rules make a direct binding much
more delicate than a process protocol.  FFI must therefore be a replaceable
transport with identical protocol conformance tests, never the sole route to
replay or release.

### First binding acceptance test

Run the GF(27) affine recipe three ways—Rust CLI, Python socket client, Lean
socket client—and require identical request hashes, histograms, cap orbit,
diagnostic label contract, and lemma packet.  Then send the packet through the
Lean bridge and verify that the diagnostic `AGL(3,3)` quotient is rejected as
a proof edge while the divided-power translation identity is accepted after
its exact action proof is supplied.

Search threads check only the existing cheap steering flag.  Mining reducers
receive batched snapshots outside the solver hot path.  Serialization, JSON,
formula formatting, and orbit narrative never execute in worker loops.

`semantic_sets.rs` is the first Rust kernel: it profiles maximum overlap with a
precompiled mask family and iteratively enumerates fixed-cardinality subsets.
Both steady-state loops allocate nothing and use no recursion.
`semantic-affine-census` is the first end-to-end `match/reduce/canonicalize`
adapter.  In under one second including the release-build check on the current
host, it streams all 4,686,825 masks through the overlap reducer, recognizes
the minimum stratum as caps, and closes its affine orbit.  The hot census loop
allocates nothing; only precomputation and the pre-sized orbit set allocate.
With the frozen labelled-locator TSV attached, the same run performs the full
three-op plan: `match` profiles all 6,890 weighted labelled locators, `reduce`
finds the 2,106-object ambient minimum, and `canonicalize` proves that minimum
is one cap orbit.  Their intersection is exactly zero.

The first counter baseline was compute-bound: about 0.1764 s, 872.8 M cycles,
and 3.919 G instructions for the 4,686,825-object census on the pinned
performance core.  Two exact structural reductions now remove most of that
work.  The 39 affine planes are 13 parallel classes of three planes.  Each
class partitions `AG(3,3)`, so for a fixed nine-set its third overlap is
`9-a-b`; the compiled profiler retains two masks per class and performs 26
instead of 39 population counts.  Gosper mask successors then replace the
nine-index mask reconstruction with constant-work, allocation-free subset
enumeration.

The profiler selects its hardware kernel once at construction.  On x86-64
with POPCNT and SSE4.1, scalar population counts feed four parallel classes at
a time into packed unsigned maxima.  There is no per-object feature check and
the exact generic kernel remains the fallback.  Seven-run counter A/Bs on CPU
2 reduce end-to-end time from 176.37 to 57.38 ms (3.074x), cycles from 872.8 M
to 272.8 M (-68.7%), and instructions from 3.919 B to 1.319 B (-66.4%).  The
At that stage the result is 81.7 million ambient objects/s, 58.2 cycles and 281.4 instructions
per object.  The complete histogram, extremal count, cap/orbit claims, and
historical representative remain unchanged.

Orbit closure also replaces the generic randomized `HashSet` with a bounded
Fibonacci-hashed mask table sized once from the certified extremal count.  Its
insert path allocates nothing.  Against the already optimized build this cuts
a further 30.8 million instructions (2.3%) and 8.4 million cycles (3.1%)
end-to-end.  A denser 32 KiB table lost that gain to collision branches; the
measured 64 KiB table is retained.  Marking the generic Gosper visitor
for cross-crate inlining fuses successor generation with the census callback.
Before generator closure, the seven-run end-to-end result is 52.55 ms, 251.2 million cycles, and
1.229 billion instructions: 3.356x faster than the frozen baseline with 71.2%
fewer cycles and 68.7% fewer instructions.  Throughput is 89.2 million objects
per second at 53.6 cycles and 262.2 instructions per object.

Canonicalization now closes the orbit iteratively under four affine
generators: one basis translation, two coordinate swaps, and one transvection.
Conjugation supplies the other basis translations.  The generated orbit has
all 2,106 extremal caps, so this smaller subgroup already certifies AGL
transitivity; the full group order is the classical
`27(27-1)(27-3)(27-9)=303264`.  This replaces 303,264 full-group transforms by
8,424 generator edges.  The final 11-run result is 43.72 ms, 206.1 million
cycles, and 1.022 billion instructions: 4.034x faster than baseline with 76.4%
fewer cycles and 73.9% fewer instructions, or 107.2 million objects/s at 44.0
cycles per object.  The iterative queue is pre-sized, allocation-free while
closing edges, and has no recursion or stack-growth limit.

The host also exposes AVX2 and AVX-512F/DQ/BW/VL/VPOPCNTDQ.  Rust 1.87 can
detect those features but its AVX-512 target attributes and intrinsics remain
unstable, so two stable runtime-gated assembly probes were measured rather
than assumed beneficial.  A direct VPOPCNT/store/reduce kernel took about
89.5 ms; a VPOPCNT/compress/packed-max kernel took about 107.2 ms, both versus
43--44 ms for the SSE4.1/POPCNT build.  For this short 26-count reduction,
ZMM setup, lane rearrangement, and reduction dominate.  Both AVX-512 probes
were rejected; the feature is available, but it is not the fastest kernel.
An AVX2/POPCNT packed-max variant likewise took 103.2 ms and 504.6 million
cycles because population counts remain scalar and mixed-width reduction adds
work.  The retained SSE4.1 path is therefore the winner against both wider
instruction-set families on this exact workload.

## Python's continuing role

Python is not removed.  It remains the place to create a new feature in
minutes, inspect ten representative rows, and decide whether the idea deserves
engineering.  Promotion requires:

1. exact agreement on a frozen positive and hostile-negative corpus;
2. a stable typed interface used by two recipes or one demonstrably expensive
   campaign;
3. a Rust kernel with pre-sized storage and no hot-loop allocation;
4. a separate replay path;
5. measured end-to-end value, not merely a faster microbenchmark.

This preserves rapid mathematical iteration while preventing Python scripts
from becoming the permanent execution architecture.

## Near-term implementation order

1. Finish the mask-family profiler with a streamed binary/JSONL recipe adapter
   and exact ambient-versus-labelled histograms.
2. Port affine-subspace enumeration and cap recognition, using fixed arrays for
   small prime-field dimensions.
3. Add orbit closure from declared generators and emit one representative plus
   stabilizer/transporter certificates, with exact label-action typing.
4. Port exact parametric fitting and match fitted coefficient rows against a
   catalogue of classical actions (divided powers, Frobenius, torus, affine).
5. Join feature outputs into a bounded separator search and exceptional-state
   ledger.
6. Apply the same recipe API to C80 Hall-deficit packets and C896 carry-state
   rank cores before considering a public API.

## Rejected alternatives

- **Rewrite every exploratory probe in Rust immediately:** too slow for
  mathematical iteration and likely to fossilize bad abstractions.
- **Keep disconnected Python scripts:** fast locally, but repeats parsing,
  field arithmetic, orbit logic, certificates, and failure modes.
- **Use a generic ML feature learner first:** it obscures exact purity and
  source-language proof obligations.  Learned ranking can be added after the
  exact semantic vocabulary exists.
- **Put the miner in public Ergodis now:** premature; the private adapters still
  contain research-process and domain-specific concepts.

## Acceptance gates

- Reproduce the C973 affine-overlap and semilinear-core artifacts exactly.
- Recover the known divided-power translation identity from the recipe output.
- Find the 2,106 ambient nine-caps as the unique overlap-four stratum and show
  zero intersection with the `e_3` label.
- Reject `AGL(3,3)` as a proof quotient for the fixed Hankel label; accept it
  only as diagnostic geometry until a paired syndrome action is supplied.
- Run one C80 and one C896 recipe without adding either problem's vocabulary to
  the kernel layer.
- Demonstrate zero allocations in measured Rust feature hot loops and bounded
  memory under streamed evidence.

Vibe: the architecture is now clear and grounded in three different
certificate modalities; the risk is overbuilding the recipe language before
two more real campaigns force its minimal shape.

Replay the landed ambient census with:

```bash
cargo run --release --manifest-path ergodis-private/Cargo.toml \
  --bin semantic_affine_census -- \
  --labelled-tsv notes/reed-solomon-tasks/c973-gf27-switch-probe/out/e3-ninesets.tsv \
  --output /path/to/create-new.json
```
