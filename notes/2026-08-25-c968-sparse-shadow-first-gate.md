# C968 — sparse-shadow first implementation gate

**Lane:** `clebsch`

**Date:** 2026-08-25

## Result

The standalone `sparse-shadow/` Rust workspace now has a frozen schema-v1
boundary, strict JSON parsing, five distinct typed profile variants, a thin CLI,
and an enabled Paper-I orientation adapter. Its hand-checkable twelve-point
fixture carries the two five-valent icosahedral orbitals and antipodal matching.
The explicit individualization/refinement search returns a canonical form,
input-to-canonical witness, all verified automorphisms (order 120 on the
fixture), vertex orbits, verified point stabilizers for orbit representatives,
deterministic BLAKE3 identity, branch trace, and the residual uncalibrated
orientation `C2`. The fixture's single point stabilizer has order 10.
Relabeling and corruption tests pass.
The companion committed calibrated-triangle fixture reconstructs with exact
oriented return, and its reconstruction certificate replays independently.
An independently implemented reference search rederives the canonical payload,
witness, winning trace, and complete automorphism set from raw relations; it
rejects hash, trace, and missing-automorphism corruption.
The producer now uses guarded fixed/preallocated hot records, emits three
generators closing to all 120 actions, and produces independently replayable
equivalence/inequivalence and reconstruction artifacts.

This closes C968's Paper-I implementation, trust, and performance gates, not
C968. Papers II--V remain schema-gated pending exact frozen exports. The
specialized `paper-i-ir-exhaustion/v1` rule system keeps the certificate compact
by making the separate checker rederive all 193 search nodes rather than trust a
serialized tree.

## Frozen boundary

- workspace crates: `sparse-shadow-core`, `sparse-shadow-cli`;
- MSRV/toolchain: Rust 1.85.0, edition 2024;
- commands: `validate`, `canonicalize`, `equivalent`, `reconstruct`,
  `verify-certificate`;
- enabled action: color-preserving permutations over named binary relations;
- gated actions: projective and semilinear profiles already require exact field
  moduli, element encodings, matrices, and Frobenius powers, but cannot be
  enabled until arithmetic and replay exist;
- every gated profile carries a frozen source hash, explicit carrier and
  ambiguity, optional odd calibration, and collision artifacts for each
  minimality claim;
- no manuscript, Lean, or existing paper fixture was modified.

## Validation

- `cargo test --workspace --all-features`: pass;
- `cargo test --release --workspace --all-features --locked --offline`: pass;
- `cargo clippy --workspace --all-targets --all-features -- -D warnings`: pass;
- Paper-I exhaustive search: automorphism order 120, one vertex orbit;
- property tests: canonical identity invariant under generated arbitrary
  permutations for both uncalibrated and calibrated fixtures, with explicit
  idempotence;
- the committed golden contract pins both Paper-I canonical identities,
  automorphism and stabilizer summaries, vertex orbits, exhaustive search
  counters, and certificate/proof-system schemas across builds;
- canonical wrapper v2 explicitly versions the point-stabilizer addition;
  input schema v1 and canonical proof v1 remain unchanged rather than drifting
  under reused tags;
- reconstruction v2 replaces the former carrier label with a typed Paper-I
  carrier containing the six exact antipodal axes in canonical coordinates;
  replay recomputes those axes from the independently checked canonical shadow,
  and the ambiguity enum is now part of the usable public API;
- schema rejection tests cover unknown fields, unsupported versions,
  non-normalized undirected edges, malformed orbital partitions, and duplicate
  calibration vertices; Paper-I calibration must additionally be an increasing
  triple forming a clique in `orbital_positive`, matching the frozen triangle
  sign rather than an arbitrary three-set;
- exhaustive calibration census: all 220 triples checked, exactly 20 admitted,
  one canonical orbit, automorphism order 6 throughout;
- uncalibrated exchange of the two five-valent orbital payloads preserves the
  canonical identity and emits a replayed transporter, matching the residual
  orientation involution;
- black-box CLI tests: Paper-I validation succeeds, every gated Paper-II--V
  input exits nonzero while naming its own exact required export, repeated
  canonicalize runs are byte-identical, and identical inputs compare
  equivalent; canonical, equivalence, and reconstruction outputs all replay
  through their CLI verifier, while a corrupted form of each exits nonzero;
- `verify-certificate` consumes the complete `canonicalize` output directly
  and retains bare-certificate compatibility; the library exposes the same
  full-wrapper verifier;
- canonicalization idempotence is tested; reconstruction replay binds the
  enclosing canonical schema, identity, payload, transporter, statistics,
  group order, generator closure, vertex orbits, and point stabilizers to the
  independently replayed certificate; hostile generators are rejected by a
  closure walk bounded inside the certified full group;
- deliberate canonical-identity, branch-trace, and automorphism-set corruption:
  rejected by the independent reference implementation; equivalence
  transporters and inequivalence separators have direct corruption tests.
- hot Paper-I search: fixed 32/64/128-byte guarded records; zero allocations,
  reallocations, deallocations, and cold arena grows over 193 nodes;
- equivalence certificates carry an explicit isomorphism or two exhaustive
  canonical proofs plus a separating identity; reconstruction artifacts replay
  their carrier, residual `C2`, and round trip;
- `cargo deny check`: advisories, bans, licenses, and sources green.
- `cargo doc --workspace --all-features --no-deps` and locked/offline Cargo
  metadata resolution: pass;
- core crate package dry run: pass; CLI packaging is explicitly gated on the
  normal prior registry publication of `sparse-shadow-core 0.1.0`; no publish
  action was taken;
- the actual core `.crate`, freshly extracted to a temporary directory, passes
  locked/offline unit and doc tests; its packaged fixture is checked
  semantically equal to the public fixture in the full workspace suite;
- post-stabilizer CPU-0 benchmark smoke at `7d0344136`: canonicalize
  256.83--257.90 us, independent replay 3.9228--3.9395 ms; one run, no A/B or
  performance claim.

## Prior-art result

The bounded audit is in `sparse-shadow/docs/prior-art-audit.md`. It read three
cached papers in relevant sections and five official software surfaces.
McKay--Piperno and nauty/Traces are the canonicalization baseline; Vole is the
closest arbitrary-permutation-action engine; Feulner and Sage `codecan` are the
closest projective/semilinear canonical-form precedent; and
Bankovic--Drecun--Maric `isocert` is the direct independent-certificate
baseline. No novelty or priority claim is licensed.

## Mystery ledger

- **Settled:** the fixture's 120 automorphisms are not the orientation-preserving
  `A5` alone; the two unlabeled orientations retain the central `C2`, exactly
  matching the declared residual orientation ambiguity. Three generators close
  to all 120 verified actions.
- **Settled in the closeout pass:** source provenance initially contaminated
  canonical identity. Canonical serialization now normalizes the theorem
  locator to the adapter identity, and a regression test proves that a second
  frozen export of the same shadow remains equivalent.
- **Settled for Paper I — certificate trust:** the explicit eight-rule
  `paper-i-ir-exhaustion/v1` system is implemented by a separate exhaustive
  checker; result, trace, full automorphism set, and every search counter must
  agree. A later wrapper audit also closed the possibility of retaining a valid
  embedded proof while corrupting public group/order/orbit/stabilizer metadata.
  Future adapters will require action-specific rule extensions and may not inherit
  this verdict automatically.
- **Open — source exports:** nearby evidence files exist for Papers II--V, but
  none is the complete frozen shadow required by its typed adapter. Four
  fail-closed schema fixtures and CLI diagnostics name the missing export paths.
  Owning next gate:
  the respective paper stream must freeze one exact export at a time; C968 will
  not infer it from manuscript prose or trust metadata.
- **Settled — hot representation:** the Paper-I producer uses fixed/preallocated
  search data with compile-time size/alignment guards and a zero-allocation
  instrumented fixture run. The slower independent checker intentionally keeps
  simple cold structures.
- **Open — timing drift:** two consecutive CPU-0-pinned runs differed by 37%.
  No optimization verdict uses them. Evidence gap: interleaved A/B plus
  cycles/instructions per node; owning successor is the first actual
  optimization proposal, not routine correctness work.

## Next gate

The owning paper streams must freeze the exact exports named by the four gated
fixtures. Once one exists, extend the proof rules and arithmetic/action replay
for that adapter; no further adapter can be enabled before its source gate.
