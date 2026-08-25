# C968 -- sparse-shadow reconstruction and canonicalization

**Lane:** clebsch

**Status:** queued; standalone Rust tool; no manuscript or Lean edits

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
- Benchmarks identify fixture versions, toolchain, hardware, baseline, and
  whether each bound is proved or merely measured.
- No universal graph-isomorphism, asymptotic, optimality, novelty, or manuscript
  claim is made without a separate proof or audit. Existing paper sources and
  Lean companions remain untouched.

## First action

Create `sparse-shadow/` with Cargo, freeze the minimal workspace/crate layout and
dependency audit, then write the typed schema plus one hand-checkable Paper-I
fixture. Do not optimize or add all five adapters until canonicalization and
independent certificate replay agree on that first fixture.
