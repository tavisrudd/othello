# C968 -- sparse-shadow reconstruction and canonicalization

**Lane:** clebsch

**Status:** active at three external source gates; Paper-I and Paper-IV canonicalization, reconstruction, independent replay, hot-layout, golden-output, and nauty gates green; Papers II, III, and V remain gated; standalone Rust tool; no manuscript or Lean edits

## Goal

Turn the five-paper reconstruction-profile calculus into an exact,
proof-carrying tool. Given one of the supported sparse shadows, reconstruct the
declared carrier, compute a deterministic canonical form under the declared
equivalence action, recover its automorphism/stabilizer data, and report the
precise residual ambiguity: projective orbit, orientation involution,
homogeneous fibre, or marking torsor.

This is not a claim that one generic functor covers all five papers. Each input
adapter owns its carrier, admissibility predicate, action, reconstruction map,
and ambiguity type. The shared engine owns canonicalization, certificates,
verification, deterministic serialization, and performance instrumentation.

## Rust project boundary

- Start directly in Rust; do not build a disposable Python prototype.
- Create a new top-level `sparse-shadow/` directory as an independent Cargo
  workspace with a committed `Cargo.lock` and an MSRV/toolchain policy.
- Begin with a library crate for typed instances, actions, reconstruction,
  canonicalization, and certificates, plus a thin `clap` CLI crate.
- Use focused crates where they remove infrastructure rather than mathematics:
  `serde`/`serde_json` for versioned artifacts, `thiserror` for library errors,
  `clap` for the CLI, `indexmap` and `fixedbitset` for deterministic sparse
  structures, `rayon` only behind deterministic parallel search, `blake3` for
  artifact identities, and `tracing` for diagnostics. Use `proptest` for
  invariance/corruption tests and `criterion` for benchmarks.
- Add `petgraph` only if its graph storage/traversal materially simplifies an
  adapter. Implement and test the declared individualization/refinement and
  group-action logic explicitly; do not hide correctness behind an opaque
  canonical-labeling FFI.
- Add an exact finite-field crate such as `ark-ff` only when a frozen adapter
  genuinely requires extension-field arithmetic; keep projective/group logic
  generic over the smallest exact field interface that the fixtures need.
- Audit dependency licenses, maintenance, feature flags, and reproducibility
  before freezing the initial manifest. Avoid network services and untracked
  generated state.

## Repository performance and Tiger-style rules

Before designing any hot representation or running a benchmark, read and apply
the repository's [Queens/Othello performance playbook](../queens-othello-perf-playbook.md).
Use the [performance methodology and war stories](../perf-methodology-warstories.md)
to select counters and avoid measurement confounds, and consult the existing
[Rust engine performance notes](../../rust/NOTES.md) for the repository's
measured successes and rejected optimizations. These are mandatory engineering
inputs to C968, not merely background analogies.

In particular:

- Mark the canonicalization search loop and every per-branch structure as hot.
  Apply the playbook's Tiger-style contract: plain fixed-size data, contiguous
  arenas, index-based references, explicit representation, range-sized integer
  fields, and compile-time size/alignment assertions. Keep cold metadata,
  strings, owned graphs, errors, and certificate serialization out of hot
  records.
- Perform no allocation, deallocation, syscall, environment lookup, logging,
  formatting, hashing setup, lock acquisition, or atomic counter update in the
  hot loop. Preallocate bounded arenas when the instance schema supplies a safe
  bound; otherwise make growth an explicit cold-path event with measured and
  reported limits.
- Resolve run-constant modes once at startup. Prefer const-generic
  monomorphization when instrumentation or algorithm choice would otherwise add
  a branch inside refinement or search; do not read `env::var` per node.
- Parallelize only after the sequential search and certificate surface are
  correct and profiled. Give workers private scratch/arenas and deterministic
  merge order; do not introduce shared hot-path atomics or contention merely
  for counters. `rayon` is optional and must earn its place on end-to-end runs.
- Napkin the available leverage first, profile the actual workload, and change
  one variable at a time. Keep or reject an optimization using interleaved A/B
  runs and appropriate node-independent counters as well as end-to-end time;
  do not promote a microbenchmark win without a representative canonicalization
  workload.
- Record instructive negatives and never claim a performance floor or that a
  target is unreachable. Report the measured bottleneck and remaining levers.

## Source boundary and adapters

Freeze exact locators before implementation. Each adapter must identify which
numbered Clebsch paper supplies its theorem and must consume frozen exported
fixtures rather than scrape LaTeX or private working notes. The first schema
pass must cover the five distinct reconstruction profiles at the level needed
to express:

1. the sparse observed shadow and its labels/weights/signs;
2. its admissibility and equivalence group;
3. the recovered carrier and reconstruction map;
4. the exact fibre or torsor remaining after reconstruction;
5. calibrated odd data that kill an orientation `C2`, when present; and
6. a collision or lower-bound witness for every claimed minimality boundary.

Implement adapters incrementally. A paper whose export surface is not yet
stable remains a schema fixture with an explicit gate; it is not re-derived or
silently normalized by the tool.

## Algorithmic deliverables

1. Define a versioned, typed interchange schema with canonical ordering,
   explicit field/action metadata, and rejection of unknown or inconsistent
   normalization data.
2. Implement a deterministic individualization/refinement core using typed
   incidence, color, weight, sign, and relation invariants. Record every
   refinement and branch decision needed to replay the winning canonical leaf.
3. Compute canonical representatives, explicit input-to-canonical witnesses,
   automorphism generators, and stabilizer/orbit data. Verify all returned
   permutations or semilinear/projective actions against the original object.
4. Run the paper-specific reconstruction map and emit the recovered carrier,
   ambiguity object, and round-trip shadow. Separate canonical equivalence from
   exact oriented/marked return.
5. Emit compact certificates for equivalence, inequivalence by a separating
   invariant or exhausted search tree, reconstruction, and claimed minimal
   collisions. Provide an independent verifier that does not trust cached
   refinement state or hashes.
6. Build small exhaustive reference instances and brute-force orbits for each
   adapter. Property-test relabeling invariance, idempotence, round trips,
   automorphism closure, and rejection of corrupted certificates.
7. Benchmark node counts, refinement depth, memory, certificate size, and wall
   time against the brute-force references and, where formats permit, a named
   established canonical-labeling baseline. Report measurements separately
   from proved bounds.
8. Provide CLI commands for `validate`, `canonicalize`, `equivalent`,
   `reconstruct`, and `verify-certificate`, with stable JSON input/output and
   nonzero failure exits.

## Acceptance gate

- `cargo test --workspace --all-features` and the repository's appropriate
  Cargo quality gates pass from a clean checkout of `sparse-shadow/`.
- For every enabled adapter, canonical identities agree exactly iff the inputs
  are equivalent under the adapter's declared action on exhaustive small
  fixtures and frozen theorem examples.
- Reconstruction round-trips to the declared shadow, and the output explicitly
  distinguishes exact return from a residual orbit, involution, fibre, or
  torsor.
- Automorphism/stabilizer outputs are verified actions, not just orders; all
  certificates replay independently and deliberate corruption is rejected.
- Outputs and artifact hashes are deterministic across repeated runs and
  supported thread counts.
- Hot structs have compile-time size/alignment guards; representative profiles
  show no allocation, environment lookup, syscall, lock, or shared atomic in the
  refinement/search loop. Any exception requires a measured design review in
  the task report.
- Benchmarks identify fixture versions, toolchain, hardware, baseline, and
  whether each bound is proved or merely measured; optimization decisions use
  interleaved end-to-end A/B evidence rather than microbenchmarks alone.
- No universal graph-isomorphism, asymptotic, optimality, novelty, or manuscript
  claim is made without a separate proof or audit. Existing paper sources and
  Lean companions remain untouched.

## First action

Create `sparse-shadow/` with Cargo, freeze the minimal workspace/crate layout and
dependency audit, then write the typed schema plus one hand-checkable Paper-I
fixture. Do not optimize or add all five adapters until canonicalization and
independent certificate replay agree on that first fixture.

## 2026-08-25 first-gate state

The workspace, dependency audit, schema-v1 profile variants, CLI, Paper-I
icosahedral-orbital fixture, explicit canonicalizer, reconstruction ambiguity,
and separately implemented raw-input reference replay are implemented and
green. The checker independently rederives the canonical payload, witness,
winning trace, and complete automorphism set and rejects corruption. See
`../2026-08-25-c968-sparse-shadow-first-gate.md` and
`../../sparse-shadow/docs/prior-art-audit.md`.

The Paper-I proof system is frozen in
`../../sparse-shadow/docs/certificate-rules-v1.md`: its separate checker
rederives the complete search and requires exact result, trace, automorphism,
and counter agreement. Bankovic--Drecun--Maric `isocert` remains the general
trust comparator. Papers II--V remain schema-gated.

The gated schemas are not generic placeholders: each owns its frozen source
hash, observed shadow shape, declared permutation or projective-semilinear
action (including exact field normalization), recovered carrier, ambiguity,
odd calibration, and minimality-collision artifacts. Enabling remains forbidden
until an exact paper-owned export and independent arithmetic replay exist.

The Paper-I hot search now has compile-time 32/64/128-byte layout guards, a
preallocated equality arena, and an instrumented zero-allocation result across
its exact 193-node fixture search. Equivalence/inequivalence and reconstruction
certificates have independent replay and corruption tests. A committed
calibrated-triangle fixture proves the exact-oriented-return branch, while
black-box CLI tests cover success, fail-closed export diagnostics, equivalence,
and byte-deterministic canonical output; all four gated adapters are checked
against their own exact required-export paths. All three certificate forms now
have end-to-end CLI production, replay, and corruption-rejection coverage.
Canonical output feeds directly into `verify-certificate` without manual JSON
extraction, with bare-certificate input retained for compatibility.
Reconstruction replay binds the full public canonical wrapper—including group
order, generator closure, vertex orbits, and point stabilizers—to its
independently checked inner proof; the closure walk cannot leave the certified
finite group.
Canonicalization idempotence is explicit, and generated arbitrary permutations
now exercise invariance for both calibrated and uncalibrated fixtures instead
of the earlier cyclic-only sample. Strict schema tests cover unknown fields,
versions, edge normalization, partitions, and calibration distinctness. The
calibration gate also requires an increasing `orbital_positive` clique, matching
the frozen C905 triangle-sign boundary rather than accepting an arbitrary
three-set. The exhaustive 220-triple census admits exactly 20 triangles, all
with one exact canonical payload and automorphism order 6; each has a replayed
transporter to a fixed representative, so the orbit conclusion does not rest on
hash equality. Uncalibrated exchange of the two
orbital payloads is explicitly equivalent with a replayed transporter, matching
the frozen residual orientation involution. Equivalent transporters and
inequivalence separators have direct corruption coverage. The committed
Paper-I golden contract fixes canonical
identities, group/stabilizer summaries, vertex orbits, search counters, and
proof-system identifiers across builds. The performance record is
`../../sparse-shadow/docs/performance-paper-i.md`; its wall-time drift licenses
no optimization claim. A current post-stabilizer CPU-pinned smoke run is
recorded separately and likewise licenses no speedup claim; documentation and
locked/offline resolution gates are green, as is the full optimized
locked/offline test suite.

The point-stabilizer surface is explicitly versioned as canonical wrapper v2.
The input interchange and unchanged eight-rule certificate correctly remain at
v1; no expanded artifact is emitted under the earlier canonical wrapper tag.
Reconstruction v2 likewise replaces the old carrier label with a typed Paper-I
carrier: its six antipodal axes are emitted in canonical coordinates and
recomputed during replay. The previously private ambiguity enum is exported as
part of the public artifact API.

The core crate package dry run is green. Registry release order is explicit:
core 0.1.0 must exist before the CLI package can resolve its versioned path
dependency. No publication was attempted, and the manifest does not hide the
prerequisite. A fresh extraction of the actual core `.crate` passes
locked/offline unit and doc tests; the packaged unit fixture is synchronized
semantically with the public workspace fixture.

The bounded prior-art audit now includes an implementation mapping. It records
McKay--Piperno/nauty/bliss/Vole as canonicalization baselines, Feulner/Vole as
the reason transporters and stabilizers are first-class, and `isocert` as the
proof/checker trust comparator. It also keeps the external-tool benchmark
explicitly deferred until a versioned encoding exists; no novelty claim is
made.

Strict unknown-field rejection now applies uniformly to tagged enums as well as
structs: profiles, actions, base fields, input/reconstruction ambiguities, and
equivalence outcomes. Empty ambiguity variants retain their frozen JSON shape,
and all four gated fixtures have exact value-level round-trip tests.

Canonical wrapper v2 now documents its coordinate bases explicitly. Full-group,
orbit, and point-stabilizer fields act on raw input vertices; canonical shadows
and recovered six-axis carriers use canonical vertices; the transporter is the
declared bridge. Both Paper-I fixtures conjugate every emitted generator across
that bridge and require exact preservation of the canonical shadow.

`fixtures/SHA256SUMS` now freezes the exact bytes of the four fail-closed gates,
the two Paper-I inputs, and the golden contract.

Equivalence verification reports now preserve useful proof output: equivalent
inputs return their shared canonical identity, while inequivalent inputs leave
that singular field empty; both report the exact total number of automorphisms
checked across their two exhaustive proofs.

The Paper-I golden contract now also freezes BLAKE3 digests of exact CLI stdout
for validate, calibrated and uncalibrated canonicalize/reconstruct, and
identical-input equivalence. This converts the former same-build repeatability
check into a cross-build byte-level serialization contract; `blake3` is reused
as a CLI dev dependency and adds no resolved package.

Linux `perf` identified redundant refinement signatures as the dominant cost in
both production canonicalization and independent replay. Discrete partitions
now return immediately after the frozen round increment, and singleton cells
bypass signature computation/bucketing. Two interleaved CPU-0 comparisons
against a separately compiled untouched worktree measured 41.8--43.1% faster
canonicalization and 48.3--48.9% faster replay while preserving exact artifacts,
search counters, verifier independence, and the zero-allocation hot-loop gate.

The backend hierarchy is now explicit: native Rust remains mandatory and
authoritative; an excluded optional crate cross-checks Paper I with bundled
nauty 2.9.3; bliss is reserved as the second backend path. Both engines share
the frozen colored-incidence v1 encoding and backend-comparison v1 artifact.
Nauty assigns raw and native-canonical encodings identical BLAKE3 identities
and independently recovers automorphism orders 120 and 6 for the uncalibrated
and calibrated fixtures, respectively. External results never replace the
native transporter, reconstruction, or replay certificate.

Paper IV's paper-owned `verification/sparse_shadow_export.json` now supplies
all 3003 weighted pairs and three coordinate generators.  C968 independently
checks the source, pair census, action, and full 2,184-element automorphism
group by an exhaustive 3,901-node search and a representation-distinct replay.
It intrinsically recovers six elliptic relations and 78 passant rows, matches
the canonical shadow to the exact symmetric-square GF(13) model, and emits all
183 plane points/lines, the 14-point conic, polarity, binary rank 36, and the
`PGL2(13)` marking torsor.  Canonical, equivalence, reconstruction, corruption,
relabeling, idempotence, zero-allocation hot-loop, golden-output, and nauty
2.9.3 gates are green; see
`../2026-08-25-c968-paper-iv-sparse-shadow-export.md` and
`../../sparse-shadow/docs/performance-paper-iv.md`.  Papers II, III, and V still
require the complete paper-owned export named in their gated fixtures; nearby
evidence JSON and trust manifests remain insufficient.  No unblocked C968
implementation frontier remains until one of those three exports freezes.
