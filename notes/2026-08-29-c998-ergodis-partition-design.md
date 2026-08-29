# C998 — ergodis public/private partition design

**Lane**: `complete-ports`
**Date**: 2026-08-29
**Status**: design complete — no code moved, no git state changed, no push

Design of the five-tier public/private split of the Rust crate at
`papers/complete-repair-ports/ergodis/` for AGPL-3.0 + commercial dual licensing.
Sources inspected: `src/` (33 modules, 3 bins), `examples/` (18 + `data/`),
`benches/` (9 Rust + 4 third-party harness files), `tests/` (4 + fixtures),
`python/` (48 scripts + `recovery_algorithms/`), `evidence/` (65 artifacts),
`scripts/` (45 shell drivers), `docs/` (3 SVG), and the four top-level Markdown docs.

---

## 1. Verdict and tier assignment

### Verdict

**The split is clean at the module level and dirty only at the harness level.**
Every `crate::` reference in `src/*.rs` was enumerated; the module dependency DAG
already flows in the required direction. There is **not one edge from an intended-public
module into an intended-private module**. The only private module that a public module
would need is `ordered_resource`, and the fix is to call it public — it is a
domain-neutral finite ordered-monoid algebra with no storage semantics in it.

The genuinely load-bearing finding for the AGPL story: **`observational.rs` has zero
`crate::` references.** The 8,622-line observational minimizer — the kernel whose speed
is compared against MATA and Boa — depends on nothing else in the crate. It does not use
`packed_ternary`, `bitset`, `arena`, `orbit`, `matrix`, or `field`. Its performance comes
from its own adaptive dense/sparse inverse construction and edge-bounded small-half
worklist. So the answer to the brief's explicit risk question is: **the observational
compiler's speed advantage does not sit in any private tier, and the public crate can
reproduce the MATA/Boa comparison end to end with nothing held back.** AGPL pressure is
real for the automata/verification use case.

Four things block a mechanical split, all outside `src/`:

1. `src/lib.rs` re-exports all 33 modules in one flat block and must be re-cut per tier.
2. `applications.rs` (2,040 lines) mixes storage front ends (Azure/Ceph/GPU, tier 4) with
   the QC-LDPC trapping-set kernel (`QcLdpcCode`, `QcSearchResult`, `QcTrappingSetAnswer`,
   tier 3) in one file.
3. Three harness files reach across the line: `tests/contextual_allocations.rs` into
   `semantic_symmetry`, `tests/python_parity.rs` into `scheduler` and the GF(27) modules,
   and `src/bin/ergodis.rs` into `scheduler`.
4. `projective.rs`, `balanced.rs`, `defect.rs` and their satellites are **cap/arc-lane
   research code that fits no commercial tier at all** — GF(27) complete-arc search, not
   coding or storage. They are parked in tier 5 below only because the brief demands a
   five-way assignment; the real recommendation is to spin them out of the crate.

### Tier table

Tier keys: **P** = public `ergodis` (AGPL-3.0) · **S** = private `ergodis-symmetry` ·
**Q** = private `ergodis-qec` · **T** = private `ergodis-storage` · **B** = private
`ergodis-bench`.

#### `src/` modules

| File | LOC | Tier | Reason |
| :--- | ---: | :--- | :--- |
| `lib.rs` | 129 | P | Crate root; the flat re-export block must be re-cut per tier (see §2). |
| `observational.rs` | 8,622 | P | The kernel. Observational minimization, certificate-policy ladder, streaming separator format, layered/DAG audit. Zero intra-crate deps. |
| `contextual.rs` | 2,463 | P | Contextual quotients and rank-bounded outer tests; brief names contextual minimization as kernel. Deps: composition, confinement, field, matrix — all public. |
| `composition.rs` | 1,662 | P | Composition minimization and tower witnesses; kernel per brief. Deps: arena, field, matrix. |
| `confinement.rs` | 670 | P | Rank-one transfer certification; published manuscript math. Deps public. |
| `transfer.rs` | 765 | P | Binary recovery-data compilation over characteristic two; published manuscript math. |
| `span.rs` | 270 | P | Generated-span closure; published manuscript math. |
| `selector.rs` | 705 | P | Finite-field selector specialization; published manuscript math. |
| `sat.rs` | 579 | P | Structured-CNF theorem certificates. Self-contained; supplies the SAT-domain toy examples. |
| `provenance.rs` | 471 | P | Provenance sidecar and replay — named explicitly in tier 1. |
| `interface.rs` | 387 | P | `FiniteInterfaceAdapter` / `FiniteInterfaceWitness` — the domain-adapter seam every private tier plugs into. |
| `ordered_resource.rs` | 1,704 | P | Finite ordered-monoid / Pareto algebra. **Forced public**: public `interface.rs` depends on it. Domain-neutral; nothing storage-specific inside. |
| `family_response.rs` | 259 | P | Compact response dictionaries over exact minima; domain-neutral compression layer on top of `observational`. |
| `automata.rs` | 265 | P | `ExplicitMataDfa` adapter — required for the MATA/Boa comparison that carries the AGPL pressure. |
| `matrix.rs` | 262 | P | Dense field matrix; used by public and private tiers alike. |
| `field.rs` | 231 | P | `FiniteField` trait, sealed. Foundation for everything. |
| `arena.rs` | 62 | P | Replayable arena witness storage; internal to composition/confinement/span. |
| `bitset.rs` | 62 | P | Bit container; only consumer is `incidence`. Trivially public. |
| `witness.rs` | 61 | P | Witness records for `span`. |
| `group_action.rs` | 1,293 | S | Orbit compilation for finite permutation actions; GF(2) general-linear RREF canonical form. Named in tier 2. Deps: `observational` (public) only — clean. |
| `semantic_symmetry.rs` | 1,069 | S | Certified support-orbit covers, anchored subproblems, and the private `write_anchored_lp` MILP emitter (`semantic_symmetry.rs:474`). Named in tier 2. Deps: `group_action`. |
| `orbit.rs` | 1,336 | S | Ternary orbit-syndrome search and meet-in-the-middle — an orbit engine and canonical-form path. |
| `packed_ternary.rs` | 135 | S | Packed ternary SWAR representation; named in tier 2. Only consumer is `orbit`. |
| `orbit_compile.rs` | 708 | S | Ternary/integer affine constraint compilation; calls `crate::ternary_orbit_syndrome_meet_in_middle`. Orbit-quotiented model emission. |
| `css_distance.rs` | 1,097 | Q | Exact bounded CSS-distance search over connected supports — the CSS/stabilizer front end named in tier 3. Deps: `matrix` (public) only. |
| `applications.rs` | 2,040 | T + Q | **Cannot split cleanly as a file.** Azure LRC, Ceph XOR, GPU-checkpoint, repair DAG → T. `QcLdpcCode` / `QcSearchResult` / `QcTrappingSetAnswer` → Q. See §1 flag 2. |
| `scheduler.rs` | 2,383 | T | Weighted parallel-repair scheduling, capacity cuts, positive-grading certificates. Storage-domain. Zero intra-crate deps — moves cleanly. |
| `zdd.rs` | 1,128 | T | Crate-private ZDD engine; sole consumer is `applications` (the Ceph support-family closure). Moves with it. |
| `incidence.rs` | 69 | Q | Signed incidence profile — trapping/stopping-set predicate shape. **Dead code, no callers** (confirmed in the LDPC note, §2.4). Delete or revive inside tier 3. |
| `projective.rs` | 259 | B* | GF(27) projective-plane geometry. Cap/arc lane, not coding or storage. See §1 flag 4. |
| `balanced.rs` | 3,444 | B* | "Normalized exact front end for the Gf27 balanced q=27 branch" — projective shear/homothety normalization. Cap/arc lane. Not balanced-product qLDPC codes. |
| `defect.rs` | 1,218 | B* | "Exact arithmetic pruning for the open q=27, \|D\|=54 defect-19 branch." Cap/arc lane. |

`B*` marks the cap/arc holding pen: assigned to tier 5 only to satisfy the exactly-one-tier
requirement. Recommendation is a sixth destination — spin out as `ergodis-arcs` or return
the code to the cap lane's own tree.

#### `src/bin/`

| File | LOC | Tier | Reason |
| :--- | ---: | :--- | :--- |
| `ergodis.rs` | 1,587 | P (split) | Public CLI. Its `composition` / `confinement` / `transfer` subcommands stay; the `schedule` subcommand reaches into `scheduler` (tier 4) and must be feature-gated out. |
| `css_distance_native.rs` | 185 | Q | Drives `CompiledCssDistance`; the C997 native distance front end. |
| `bench_kernels.rs` | 1,251 | B | Touches `balanced`, `composition`, `confinement`, `projective`, `scheduler`, `transfer` — a cross-tier evidence driver by construction. |

#### `examples/`

| File | Tier | Reason |
| :--- | :--- | :--- |
| `mata_official_dfa.rs` | P | The official-MATA-corpus DFA minimization demo. Load-bearing for AGPL pressure. |
| `mata_weighted_trace.rs` | P | Weighted-trace variant of the same comparison. |
| `library_composition.rs` | P | Toy composition example — one per domain. |
| `fork_join_cost_regular.rs` | P | Toy observational example over a fork-join cost structure. |
| `layered_dag_driver.rs` | P | Demonstrates the layered/DAG audit certificate — the format the public crate must show. |
| `resource_interface.rs` | P | Demonstrates `FiniteInterfaceAdapter` + `ordered_resource`; the extension-point tutorial. |
| `cnf_theorem_or_kissat.rs` | P | SAT-domain toy; shows the CNF certificate against an external solver. |
| `vlsat_clique_certificate.rs` | P | SAT-domain toy certificate. |
| `vlsat_coloring_certificate.rs` | P | SAT-domain toy certificate. |
| `gl_rref_ab.rs` | S | Calls `compile_binary_gl_rref` and `compile_permutation_orbits_with_deferred_verification`. |
| `gl_consuming_ab.rs` | S | GL-path A/B driver. |
| `observational_sota_driver.rs` | B | Exists to produce the SOTA-comparison evidence sweep, not to teach the API. |
| `observational_hierarchy_driver.rs` | B | Produces `c987-observational-hierarchy*.tsv`. |
| `envelope6_ab.rs` | B | Contextual rank-envelope A/B evidence producer. |
| `selector_ab.rs` | B | Dense/sparse selector A/B evidence producer. |
| `gf27_balanced_dfs.rs` | B* | Cap/arc lane. |
| `gf27_balanced_probe.rs` | B* | Cap/arc lane. |
| `gf27_prefix_probe.rs` | B* | Cap/arc lane. |
| `data/compose.json`, `compose-gf4.json`, `f4-scalar-separation.json`, `transfer-subspace.json`, `transfer-tower.json`, `vector-repair.json` | P | Inputs to the public CLI's "Start here" walkthrough. |
| `data/azure-repair-batch.json`, `ceph-repair.json`, `gpu-checkpoint-recovery.json`, `repair-dag.json`, `schedule.json` | T | Storage-application inputs. |
| `data/qc-ldpc-search.json` | Q | QC-LDPC trapping-set input. |

#### `benches/`

| File | Tier | Reason |
| :--- | :--- | :--- |
| `observational_compiler.rs` | P | The public crate must be able to substantiate its own speed claim without a private crate. |
| `ordered_resource.rs` | P | Public module, public bench. |
| `mata_observational_driver.cc` | P | Third-party MATA driver — a reproducer, not a corpus. Keep public. |
| `mata_official_dfa_driver.cc` | P | Same. |
| `boa_observational_fixture.py` | P | Boa comparison fixture. |
| `boa-kernel-timing.patch` | P | Instruments Boa for a like-for-like timing comparison; without it the comparison is unreproducible. |
| `gl_probe.rs` | S | GL-path probe bench. |
| `scheduler_locality.rs` | T | Scheduler + balanced; storage-domain locality bench. |
| `contextual_state.rs` | B | Cross-tier (confinement, contextual, projective, transfer); evidence producer. |
| `parallel_kernels.rs` | B | Composition + scheduler; cross-tier evidence producer. |
| `disable_composition_reduction.patch` | B | Control-arm patch for the evidence sweep. |
| `balanced_frontend.rs`, `balanced_parallel.rs`, `defect_augmentation.rs` | B* | Cap/arc lane. |

**Deliberate deviation from the brief.** The brief assigns "Gurobi/MATA comparison scripts"
wholesale to tier 5. That would make requirement 1 unsatisfiable — a public crate that
claims to beat MATA and Boa but ships no way to check it invites exactly the credibility
attack that kills AGPL leverage. The split adopted here is **drivers public, sweeps
private**: the C++ MATA drivers, the Boa fixture, and the Boa timing patch go public so a
third party can reproduce one headline comparison; the 45 shell sweep scripts and the 65
evidence artifacts stay private.

#### `tests/`

| File | Tier | Reason |
| :--- | :--- | :--- |
| `observational_compiler.rs` | P | Observational + provenance; the public kernel's own test. |
| `cli.rs` | P | Public CLI test (transfer path). |
| `fixtures/observational_compilation.json`, `fixtures/python_span_cases.json` | P | Public-module fixtures. |
| `contextual_allocations.rs` | **P (split)** | Public modules plus `semantic_symmetry` (tier 2). The symmetry assertions move to `ergodis-symmetry`; the allocation assertions stay. |
| `python_parity.rs` | **P (split)** | Composition/confinement/contextual/transfer parity stays public; `scheduler` parity moves to tier 4; `balanced`/`projective` parity moves with the cap-lane spinout. |

#### `python/`

| File(s) | Tier | Reason |
| :--- | :--- | :--- |
| `recovery_algorithms/{finite,costs,transfers,design}.py` | P | The differential oracle for the public modules; the parity gate is a public credibility asset. |
| `recovery_algorithms/{storage,service,reliability}.py` | T | Storage application oracle. |
| `recovery_algorithms/{balanced,defect,geometry,incidence}.py` | B* | Cap/arc lane oracle. |
| `generate_fixtures.py`, `check_observational_fixtures.py`, `test_algorithms.py` | P | Fixture generation and oracle tests for public modules. |
| `README.md` | P (redact) | Indexes all 48 scripts; must be re-cut to the public subset. |
| `run_c997_gurobi.py`, `check_c997_gurobi.py`, `check_c997_native.py`, `check_c997_parity_ab.py`, `export_c997_native.py`, `analyze_c997_support_orbits.py` | Q | C997 harness — Gurobi runs, native export, support-orbit analysis. |
| `gf27_defect_cpsat.py` | B* | Cap/arc lane CP-SAT control. |
| `run_application_readme_ab.py`, `check_application_readme_ab.py`, `run_application_long_controls.py`, `check_application_long_controls.py` | T | Azure/Ceph/GPU application A/B and long-control drivers. |
| `verify_baseline_encodings.py` | T | Verifies the storage baseline encodings used in the application comparison. |
| `run_mata_official_ab.py`, `check_mata_official_ab.py` | B | MATA corpus sweep (the *driver* is public in `benches/`; the sweep is not). |
| `benchmark_algorithms.py`, `benchmark_python.py`, `run_benchmarks.py`, `head_to_head_original_rust_benchmarks.py`, `rerun_original_rust_benchmarks.py`, `check_original_rust_head_to_head.py`, `check_original_rust_rerun.py` | B | Benchmark harness. |
| `build_satcomp24_manifest.py`, `fetch_satcomp24_suite.py`, `run_satcomp24_portfolio.py`, `check_satcomp24_portfolio.py` | B | SAT-Comp 2024 corpus fetch and portfolio sweep. |
| `build_vlsat2_full_manifest.py`, `build_vlsat2_prefix_manifest.py`, `fetch_vlsat2_prefix.py`, `run_vlsat2_coverage.py`, `run_vlsat2_prefix.py`, `check_vlsat2_coverage.py`, `check_vlsat2_prefix.py`, `run_vlsat_sample.py`, `check_vlsat_sample.py` | B | VLSAT2 corpus tooling. |
| `run_z3_weighted_suite.py`, `check_z3_weighted_suite.py`, `z3_weighted_trace.py` | B | Z3 weighted-trace comparison suite. |
| `check_envelope6_ab.py`, `check_gl_consuming_ab.py`, `check_gl_rref_ab.py`, `check_selector_ab.py`, `check_rank_envelope_gl_probe.py`, `summarize_contextual_ab.py`, `summarize_rank_envelope_gl_probe.py` | B | A/B checkers; the GL ones additionally read tier-2 output formats. |
| `generate_evidence.py` | **B (split)** | Generates evidence for every domain including C997 — the single Python file that must be cut, not moved. |

#### `evidence/`, `scripts/`, `docs/`, root

| Path | Tier | Reason |
| :--- | :--- | :--- |
| `evidence/` — all 65 artifacts | B | Corpus of measured results; the brief's tier 5. Two subsets carry an additional embargo: `c997-gurobi-*.jsonl` and `c985-c997-*` (Q, see §4), and `c985-application-*` (T). |
| `scripts/` — all 45 shell drivers | B | Every one is an evidence sweep or evidence checker. Two need public counterparts: `mata-official-ab.sh` and `observational-boa-ab.sh` become minimal public reproducers. |
| `docs/pipeline.svg` | P | Architecture diagram; **re-render required** — must not depict scheduler/application/QEC boxes. |
| `docs/benchmark-highlights.svg` | B | Renders the Azure/Ceph/LRC headline numbers. Text grep found no matches, so the numbers are likely paths — treat as leaking until visually inspected. |
| `docs/parallel-scaling.svg` | P (verify) | Parallel-kernel scaling; safe if it plots only observational/composition. Verify which kernels it plots. |
| `README.md` (353 lines) | P (redact) | Three leaking lines, see §5. |
| `OPTIMIZATION.md` (451 lines) | P | The manuscript's optimization-language companion; the math is already published. One Gurobi mention at line 356 is a scope disclaimer ("not a general replacement for OR-Tools, MiniZinc, Gurobi, CPLEX, SCIP"), not private content — keep it. |
| `BENCHMARKS.md` (899 lines) | **B (re-cut)** | 32 leaking lines across whole sections. Not redactable — a new public BENCHMARKS.md must be written from the public subset. |
| `AGENTS.md` (37 lines) | **Never public** | Reads "This is private C962 code-and-mathematics work. Do not export, synchronize, publish, or commit it without explicit user authorization," and points at `../../../AGENTS.md` and the perf playbook. Replace with a fresh public `CONTRIBUTING.md`. |
| `LICENSE` | P | AGPL-3.0. |
| `Cargo.toml` | P (rewrite) | Currently `publish = false` and `exclude = ["A?ENTS.md", "evidence/", "proptest-regressions/"]` — the `A?ENTS.md` glob is an obfuscation that stops working the moment the tree is re-cut. |
| `Cargo.lock`, `SHA256SUMS`, `proptest-regressions/`, `.cargo/` | per tier | Regenerate per crate; `SHA256SUMS` currently covers evidence artifacts that do not ship. |

---

## 2. Dependency-graph check

Method: every `crate::<module>` reference in every `src/*.rs` was enumerated, and every
`ergodis::` reference in every example, bench, test, and bin.

### Module DAG (`src/`), tier-annotated

```
P  field ← matrix ← {composition, confinement, contextual, transfer, span, css_distance(Q), applications(T)}
P  arena ← {composition, confinement, span}
P  bitset ← incidence(Q)
P  witness ← span
P  observational ← {automata, family_response, ordered_resource, provenance, interface,
                    group_action(S)}
P  ordered_resource ← interface
P  composition ← {confinement, contextual, transfer}
P  confinement ← contextual
S  group_action ← semantic_symmetry
S  packed_ternary ← orbit ← orbit_compile
T  scheduler ← applications ;  zdd ← applications
B* projective ← {balanced, defect}
```

### Public → private edges in `src/`: **none**

Confirmed by exhaustive enumeration. The three edges that cross the tier boundary all
point the correct way:

| Edge | Direction | Status |
| :--- | :--- | :--- |
| `group_action` (S) → `observational` (P) | private → public | Correct. This is the primary seam (§3). |
| `semantic_symmetry` (S) → `group_action` (S) | within tier 2 | Fine. |
| `applications` (T) → `field`, `matrix` (P) | private → public | Correct. |
| `css_distance` (Q) → `matrix` (P) | private → public | Correct. |
| `orbit_compile` (S) → `orbit` (S) | within tier 2 | Fine (it imports `ternary_orbit_syndrome_meet_in_middle` through the crate root, so the root re-export must survive the move inside tier 2). |
| `incidence` (Q) → `bitset` (P) | private → public | Correct. |

### Violations, all outside `src/*.rs`

| # | Violation | Minimal fix |
| :--- | :--- | :--- |
| 1 | `src/lib.rs` re-exports all 33 modules including `group_action`, `semantic_symmetry`, `orbit`, `orbit_compile`, `applications`, `scheduler`, `css_distance` from one flat block (lines 6–129). | Delete the private module declarations and their `pub use` groups; each private crate declares `pub use ergodis::{…}` for what it re-exposes. Purely mechanical, ~60 lines. |
| 2 | `applications.rs` mixes tier 4 and tier 3 in one file; `lib.rs:38-47` re-exports `QcLdpcCode`, `QcSearchResult`, `QcTrappingSetAnswer` alongside the Azure/Ceph/GPU types. | Type relocation: cut the QC-LDPC section out of `applications.rs` into `ergodis-qec/src/qc_ldpc.rs`. No shared state — the QC types do not reference `CephXorLayer` or `AzureLrcBatchAnswer`. |
| 3 | `tests/contextual_allocations.rs` (public modules) also asserts on `semantic_symmetry`. | Split the file: the symmetry assertions become `ergodis-symmetry/tests/contextual_allocations.rs`. |
| 4 | `tests/python_parity.rs` spans public modules, `scheduler` (T), and `balanced`/`projective` (cap lane). | Three-way split along the same lines. The public half keeps the composition/confinement/contextual/transfer oracle parity, which is the half worth publishing. |
| 5 | `src/bin/ergodis.rs` `schedule` subcommand calls `maximum_parallel_repairs` / `WeightedRepairProblem` (T). | Feature flag: `#[cfg(feature = "scheduler")]` on the subcommand, with the feature defined only in `ergodis-storage`'s workspace build. Alternative — move the subcommand into an `ergodis-storage` binary. Prefer the flag: the CLI's `--help` then documents a clean commercial upsell surface. |
| 6 | `benches/parallel_kernels.rs`, `benches/scheduler_locality.rs`, `benches/contextual_state.rs`, `src/bin/bench_kernels.rs` all span tiers. | All four are already assigned to tier 5 / tier 4; no refactor, they simply do not ship in the public crate. |
| 7 | `python/generate_evidence.py` generates C997 (Q) and application (T) evidence in one script. | Cut into `generate_evidence.py` (public fixtures) plus per-tier generators. This is the only Python file requiring surgery rather than relocation. |
| 8 | `docs/pipeline.svg` and `docs/benchmark-highlights.svg` depict the whole pipeline including private stages. | Re-render `pipeline.svg` from the public module set; `benchmark-highlights.svg` does not ship. |

### Consequence

The refactor is a **file-move plus eight small surgeries**, not an architecture change.
That is a materially better starting position than the brief assumed, and it is worth
saying plainly: the crate was written with a domain-adapter boundary
(`interface.rs`) and a self-contained kernel, and that discipline is what makes the
commercial split possible now.

---

## 3. Trait seams

Three seams already exist and two must be created. The governing principle, which the
prior-art note independently endorses: **publish the certificate formats and the
verifiers; hold the compilers that produce them fast.** The untrusted-producer /
verified-checker architecture is established prior art (VeriPB note §4.3), so publishing
the verifier gives away no patentable ground while making the public crate genuinely
useful and independently checkable.

### 3.1 Existing seams — keep, no change

**`FiniteInterfaceAdapter` / `FiniteInterfaceWitness`** (`interface.rs:24`, `:36`).
The domain-adapter boundary. Tier 3 (CSS/stabilizer presentations) and tier 4 (storage
layouts) each implement these to inject a domain into the public kernel. This is the
single best seam in the crate and needs nothing done to it.

**`FiniteOrderedMonoid`** (`ordered_resource.rs:10`). Tier 4 schedulers implement this to
supply their cost algebra to the public Pareto machinery.

**`FiniteField`** (`field.rs:21`) — sealed, deliberately closed. Leave sealed.

**`CertificatePolicy`** (`observational.rs`). Public enum; private tiers *select* policies,
they do not extend it. Keep as an enum.

### 3.2 Seam to create: `SymmetryProvider` (tier 2 → public)

Relocate from `group_action.rs` into a new public `ergodis::symmetry` module:

- the trait `FinitePermutationAction` (`group_action.rs:7`) — the input contract;
- the data types `OrbitPartition`, `OrbitStorage` (`:529`, `:538`) — the certificate format;
- the verifier `verify_permutation_orbits` (`:841`) and `verify_binary_gl_rref` (`:419`);
- `quotient_presentation_by_orbits` (`:620`) — the consumer that applies a partition to a
  presentation, which is what the public kernel needs.

Keep private in `ergodis-symmetry`:

- `compile_permutation_orbits` and its deferred-verification variant (`:757`, `:767`);
- `BinaryGlProbeAction` (`:95`) and `compile_binary_gl_rref` (`:350`) — the GF(2)
  general-linear RREF canonical-form engine, where the recomputed-representative trick
  gives a one-bit-per-point certificate;
- `orbit.rs`, `packed_ternary.rs`, `orbit_compile.rs` in their entirety.

New public trait:

```rust
pub trait SymmetryProvider {
    fn orbits(&self, action: &dyn FinitePermutationAction)
        -> Result<OrbitPartition, OrbitCompileError>;
}
```

The public crate ships one implementation — a straightforward orbit-closure walk, correct
and slow — so `ergodis` alone is complete. `ergodis-symmetry` ships the fast
implementations. A user can always verify either one's output with the public verifier.
This is the AGPL-leverage shape: correctness free, speed commercial.

### 3.3 Seam to create: `OrbitCover` (tier 2 → public)

Same treatment for `semantic_symmetry.rs`. Public: `NonemptySupportOrbitCover`,
`SemanticModelFingerprint`, `verify_nonempty_support_orbit_cover`,
`verify_explicit_binary_support_invariance`. Private: `compile_nonempty_support_orbit_cover`,
`compile_verified_explicit_binary_support`, `AnchoredSupportSubproblem`,
`AnchoredBinarySupportOptimum`.

The fingerprint/adapter binding is worth publishing specifically: it is what makes a
certificate refuse to validate against a mismatched presentation, and it costs nothing
competitively while being the thing a skeptical reviewer will look for.

### 3.4 Seam to create: `ModelEmitter` (tiers 2 and 3 → public)

Today the MILP emitter is a private free function, `write_anchored_lp`
(`semantic_symmetry.rs:474`), taking a tier-2 type. That cannot be the seam. Introduce a
neutral intermediate representation in the public crate:

```rust
pub trait ModelEmitter {
    fn emit_integer_program(&self, ir: &IntegerProgram, sink: &mut dyn Write) -> Result<(), EmitError>;
    fn emit_weighted_cnf(&self, ir: &WeightedCnf, sink: &mut dyn Write) -> Result<(), EmitError>;
}
```

Public ships a plain LP-format writer and a WCNF writer plus the existing structured-CNF
certificate path in `sat.rs` — a working but unaccelerated route to any external solver.
`ergodis-symmetry` implements the orbit-quotiented emitter (the same model with
orbit-representative constraints, which is the half no solver's presolve can do for
itself — the C997 gate measured CBC finding a group of order 2 against the 72 available).
`ergodis-qec` supplies the Gurobi and MaxSAT runners behind a `SolverBackend` trait.

### 3.5 Seam to convert: `WeightedSchedulerBackend` enum → trait (tier 4)

`scheduler.rs:32` defines `pub enum WeightedSchedulerBackend { SparsePareto, DenseLattice }`.
An exhaustive public enum cannot be extended by a private crate and pins the public API to
whatever backends exist today. Convert to a `RepairBackend` trait before the split; the two
existing variants become the two shipped implementations. `SelectorBackend`
(`selector.rs:119`) has the same shape but is lower priority — `selector.rs` stays public
in full, so nothing external needs to extend it yet.

---

## 4. What the public crate must demonstrate alone

### Must work, standalone, with no private crate present

1. **Observational minimization end to end**: `compile_observational`,
   `compile_observational_with_policy`, `compile_observational_with_deferred_verification`,
   `verify_compilation`, and the full certificate-policy ladder.
2. **The streaming certificate formats**, which are the strongest publishable artifact:
   `stream_exhaustive_separators`, `write_exhaustive_separator_stream`,
   `verify_exhaustive_separator_stream` (the framed `ERGSEP01` format with a
   zero-tagged terminal footer so an interrupted stream has no valid footer), plus the
   layered and DAG audits (`compile_layered_frozen_chain_audited`,
   `verify_frozen_layered_audit`, `verify_frozen_layered_dag_audit`) with their
   reverse-stratum constant-residency checking.
3. **The MATA/Boa comparison, reproducible by a third party**: `ExplicitMataDfa`, the two
   MATA examples, the two C++ drivers, the Boa fixture, and the Boa timing patch. This is
   the AGPL pressure point and it must not be crippled. Confirmed safe: `observational.rs`
   has no private dependency.
4. **Provenance sidecar and replay**: `ProvenanceArena`, `ReplaySidecar`, witness lift back
   to source through `lift_class_witnesses`.
5. **The published manuscript math**: composition towers, confinement and rank-one transfer
   certification, generated-span closure, selector specialization. These are already in a
   public paper; holding the code back buys nothing and costs credibility.
6. **The public CLI** minus the `schedule` subcommand, with its `examples/data/` walkthrough.
7. **Python oracle parity** for every public module — the differential-oracle gate is a
   credibility asset, not a liability.
8. **The extension tutorial**: `resource_interface.rs` showing `FiniteInterfaceAdapter`,
   plus a reference `SymmetryProvider` implementation, so the seams are visibly real rather
   than vestigial hooks.

### Evidence: publishable now

- Observational compiler versus MATA on the official corpus, and versus Boa
  (`BENCHMARKS.md` "Official MATA-corpus minimization", lines 274–301).
- The contextual-state A/B (lines 196–273) — public modules only.
- Separator-stream memory residency and layered-audit replay cost.
- VLSAT2 and SAT-Comp 2024 certificate results from `sat.rs`.
- Parallel scaling of the observational and composition kernels.

### Evidence: held

- **Storage applications** — Ceph XOR 33.71x, Azure LRC 160.45x, the Hamming-outer LRC
  657.88x, GPU-checkpoint, and every memory row in `BENCHMARKS.md` lines 59–195. These are
  the tier-4 commercial demonstration.
- **C997 quantum results** — the gross-code 13.1x node and 22.9x wall-clock reduction, the
  4.19x symmetry-step figure, the CBC-presolve group-order-2 finding, the passant-code
  6.5x. Held *until the paper*, then published as paper numbers with a replay bundle but
  without the tier-2/tier-3 source. Note the C997 gate's own qualification: the 4.19x
  symmetry step alone sits under the 5x bar, and the result is on CBC — re-measure on
  Gurobi or SCIP before any external claim.
- **GF(27) maximal-point and balanced-branch engines** (lines 704–899) — cap/arc lane,
  publishable on that lane's own schedule, not here.
- The 65-artifact evidence corpus and the 45 sweep scripts as a bundle.

---

## 5. Disclosure sequence

### Step 1 — Provisional-patent decision (**gate; blocks everything after it**)

Depends on `notes/2026-08-29-c998-patent-landscape.md`, being written in parallel.

What is already known from `notes/2026-08-29-ergodis-certificate-prior-art-veripb.md`:
every individual component is anticipated. The minimality certificate is stated verbatim
as the baseline in Kupferman–Lavee–Sickert (ATVA 2021), and the all-pairs separating-sequence
extraction is Smetsers–Moerman–Jansen (LATA 2016), shipping today as public API in
AutomataLib/LearnLib. The orbit cover and witness lift are covered by the pseudo-Boolean
stack. Only the *integrated pipeline* is unoccupied, and the note's own recommendation is
that a system-and-format claim over a combination of two well-published techniques is cheap
to design around.

The decision must be made **before** any public push, because a push destroys absolute
novelty in EP/CN immediately and starts the 12-month US grace clock. If the answer is no
filing, the sequence collapses to paper → push and moves faster.

### Step 2 — Paper

The publishable material is the pipeline, not any component. Publish before or with the
push so the public repository has something to point at, and so priority is established by
the paper rather than by a commit date.

### Step 3 — Fresh-history public push (**re-cut, do not prune**)

Current state of `github.com/tavisrudd/ergodis`, from the local checkout at
`/home/tavis/src/ergodis`: **private, 11 commits, 93 tracked files, remote
`git@github.com:tavisrudd/ergodis.git`, HEAD `9ed76b3`.** The tree contains everything —
`src/` in full, `evidence/`, `python/`, `scripts/`, the Azure/Ceph/GPU application code,
and the GF(27) engines. Commit titles alone disclose the shape of the work
("Add optimization guide and contextual kernels", "Export revised compositional manuscript").

**It must be re-cut, not pruned.** History rewriting is not a defence here: the remote
already holds every object, GitHub retains unreferenced objects and serves them by SHA,
and a force-push leaves them reachable. Recommended sequence:

1. Rename the existing private repository to `tavisrudd/ergodis-private` (GitHub redirects
   the old name, so **also** deny the redirect by creating the new repo before anyone
   relies on it — verify the redirect behaviour before the public push).
2. Create a new empty `tavisrudd/ergodis`, public.
3. `git init` a fresh tree from the kernel-only file set, one initial commit. No import,
   no graft, no filter-repo.
4. Keep `ergodis-private` as the monorepo's export target for the four private crates.

The monorepo at `papers/complete-repair-ports/ergodis/` remains authoritative; the public
repository becomes a downstream forward-commit target under the existing
export-and-mirror conventions.

### Step 4 — crates.io

**Checked 2026-08-29: the name `ergodis` is free.**
`curl -A '<ua>' https://crates.io/api/v1/crates/ergodis` returns HTTP 404 with
`{"errors":[{"detail":"crate `ergodis` does not exist"}]}`. (A bare `curl` returns 403 —
crates.io requires a User-Agent; do not read a 403 as "taken".)

Reserve it early with a 0.0.0 placeholder; that is permitted and cheap. Also reserve
`ergodis-symmetry`, `ergodis-qec`, `ergodis-storage`, `ergodis-bench` even though they will
never be published, to stop a squatter. `Cargo.toml` currently has `publish = false` and
`exclude = ["A?ENTS.md", "evidence/", "proptest-regressions/"]`; both must be replaced, and
the `A?ENTS.md` glob deleted rather than carried forward — it is a workaround that silently
stops protecting anything once the tree is re-cut.

### Step 5 — Trademark

Search USPTO (classes 9 and 42) and EUIPO for "ergodis" and near marks. Low cost, do it
after the crates.io reservation but before any marketing page. The word is a coinage, which
is favourable.

### Step 6 — CLA

Required before the *first* external pull request is merged, not after. Dual licensing only
works if the licensor holds or is licensed for all copyright in the public crate; an
un-CLA'd merged contribution is AGPL-only and permanently blocks relicensing that file.
Use a DCO for triviality plus an Apache-ICLA-derived individual CLA, automated through CLA
Assistant. Decide up front whether a corporate CLA is also needed (see open question 5).

### Document disposition

| Document | Disposition | Specific leaks |
| :--- | :--- | :--- |
| `README.md` | Public after three redactions | Line 96 — the `CompiledCssDistance` row in the API table ("exact bounded CSS distance from connected-support elimination") discloses the tier-3 front end by name. Line 306 — Ceph XOR support-family row with the 33.71x figure. Line 308 — published Hamming-outer LRC row, binary `[4095,2718,6;2]`, 657.88x. Also re-cut the "Application examples" section (line 245) and the "Performance highlights" section (line 298). |
| `OPTIMIZATION.md` | Public as is | Only hit is line 356, "not a general replacement for OR-Tools, MiniZinc, Gurobi, CPLEX, SCIP" — a scope disclaimer, keep it. Sections 1–6 are the published manuscript math. |
| `BENCHMARKS.md` | **Re-cut from scratch** | 32 matching lines. Whole sections leak: "Application-example comparisons" (lines 6–195: Ceph at 14–15, 79, 88, 119, 126; Azure LRC at 22–25, 80, 89, 120, 144–145, 157–158, 166–167, 179–180) and "GF(27) maximal-point / balanced-branch" (704–899). Survivors: "Official MATA-corpus minimization" (274–301) and "Contextual-state A/B" (196–273, minus its "Application-specific applicability" subsection at 234). A redaction pass leaves a document that is mostly holes; write a new one. |
| `AGENTS.md` | **Never public** | Its own text forbids export. Delete from the public tree and write a fresh `CONTRIBUTING.md` covering the public validation gate (fmt, clippy, test, oracle parity) without the perf-playbook references or the private-work notice. |
| `docs/pipeline.svg` | Public after re-render | Must not show scheduler, application, or QEC stages. |
| `docs/benchmark-highlights.svg` | Private | Renders the held application numbers. Text grep found nothing, meaning the glyphs are probably outlined paths — inspect visually, do not trust the grep. |
| `docs/parallel-scaling.svg` | Public if it plots only public kernels | Verify which kernels appear before shipping. |
| `SHA256SUMS` | Regenerate | Currently covers evidence artifacts that will not ship. |

---

## 6. Effort and risks

### Effort

| Step | Estimate | Notes |
| :--- | :--- | :--- |
| Workspace skeleton, `lib.rs` re-cut, module moves, feature flags | 1–2 days | Mechanical; the DAG already permits it. |
| `applications.rs` QC-LDPC extraction | 0.5 day | 2,040-line file, no shared state between the QC and storage halves. |
| Harness splits: `contextual_allocations.rs`, `python_parity.rs`, `bin/ergodis.rs` | 1 day | Three files. |
| Trait seams (`SymmetryProvider`, `OrbitCover` verifier relocation, `ModelEmitter` IR, `RepairBackend`) | **3–5 days** | The real work. Moving the orbit certificate formats into public while keeping compilers private means those formats become a stable public API — get them right once. |
| Reference (slow) public implementations of the two new traits | 1 day | Needed so the public crate is complete rather than hook-shaped. |
| Doc re-cut: new BENCHMARKS.md, README redaction, CONTRIBUTING.md, SVG re-render | 1–2 days | New BENCHMARKS.md dominates. |
| Python oracle split, including `generate_evidence.py` surgery | 1 day | |
| Repo re-cut, CI, crates.io reservation | 1 day | |
| Legal: patent decision, trademark search, CLA setup | calendar weeks, ~1 day of effort | Runs in parallel; step 1 gates the push. |

**Total ≈ 10–13 working days**, with the patent decision on the critical path.

### Risks and decisions

1. **Does the public observational compiler's speed depend on private data structures?
   Decided: no.** `observational.rs` has zero `crate::` references — its dense/sparse
   inverse construction, small-half worklist, and allocation-free refinement are all
   internal. `packed_ternary.rs` (tier 2) is used only by `orbit.rs`; `bitset.rs` only by
   `incidence.rs`. The MATA/Boa comparison is fully public. This was the brief's stated
   worry and it does not materialize.

2. **A future bit-packed GF(2) `Matrix` — recommend public.** `matrix.rs:20` stores one
   byte per field element with `u16` dimensions; the LDPC note calls this the crate-wide
   representational bottleneck (8x memory and ~64x elimination throughput versus M4RI-style
   bitslicing). It is textbook, unpatentable, and holding it private would cripple public
   linear-algebra paths while protecting nothing. The moat is the orbit compiler and the
   re-encoder, not the bit packing.

3. **AGPL leverage is narrow.** It exists exactly where the public crate is the fastest
   free option — today that is automata/DFA minimization for verification tooling. If a
   competitor's use is read-only research, AGPL §13 never triggers. Do not over-model the
   commercial funnel on this one vertical.

4. **Publishing the verifiers publishes the certificate formats** — which the prior-art
   note identifies as the *only* claimable subject matter left ("a concrete framed format
   plus a constant-residency checker is claimable subject matter in a way that a
   mathematical witness is not"). Strict ordering consequence: the filing decision must be
   final before the format is pushed. This is the single hardest sequencing constraint.

5. **`quotient_presentation_by_orbits` sits on the seam.** It consumes a public
   `FinitePresentation` and a public `OrbitPartition` and lives in `group_action.rs`. It
   must move public (the kernel needs it) while its *fast producers* stay private. Getting
   this boundary wrong either strands the public kernel without symmetry reduction or gives
   away the compiler.

6. **Cap/arc-lane removal is a cross-lane action.** `projective.rs`, `balanced.rs`,
   `defect.rs`, their examples, benches, Python oracle files, and the GF(27) BENCHMARKS.md
   sections belong to the cap lane, not `complete-ports`. Removing them from the crate
   needs that lane's agreement, and it is 4,921 lines of `src/` — the second-largest block
   after `observational.rs`.

7. **`ordered_resource.rs` going public is a real concession.** 1,704 lines of finite
   ordered-monoid and Pareto machinery with witnessed fronts, frozen DAG evaluation, and
   query plans. It is forced by `interface.rs`, and it is arguably the most reusable thing
   in the crate after the observational kernel. The alternative — splitting the Pareto
   engine from the monoid contract — costs more than it protects.

8. **C997 numbers are not yet externally defensible.** The gate report's own
   qualifications: the symmetry step alone is 4.19x (under the 5x bar), the measurement is
   on CBC, and on a formulation that preserves the group the presolve finds it unaided.
   Re-measure on Gurobi or SCIP before the numbers appear anywhere public.

9. **The GitHub redirect.** Renaming `tavisrudd/ergodis` leaves a redirect from the old
   path. Verify the exact behaviour before the public push rather than assuming it is
   harmless.

---

## 7. Open questions

1. **Cap/arc-lane code**: do `projective.rs`, `balanced.rs`, `defect.rs`, their three
   examples, three benches, and four Python oracle modules leave the ergodis crate
   entirely (spun out as `ergodis-arcs` or returned to the cap lane), or stay
   private-but-bundled in tier 5? They fit no commercial tier, and it is 4,921 lines.

2. **Bit-packed GF(2) matrix**: public or private, when it is written? Recommendation is
   public, per risk 2 — confirm, because it decides whether tier 1 can ever make an
   LDPC-scale claim of its own.

3. **Which paper anchors step 2** — the pipeline/certificate paper the prior-art note
   points at (VeriPB note §5.2), or the C997 re-encoder paper the quantum-codes gate
   recommends? The disclosure order and what evidence unlocks differ substantially between
   them, and the re-encoder paper additionally needs a Gurobi/SCIP re-measurement first.

4. **Repository strategy**: rename the existing private `tavisrudd/ergodis` to
   `ergodis-private` and create a fresh public repository under the freed name, or archive
   the old one and publish under a different name to avoid the redirect entirely?

5. **CLA scope**: individual CLA only, or individual plus corporate? A corporate CLA is
   needed the first time an employee of a commercial user contributes, and retrofitting one
   after a merged contribution is not possible.
