# C1079 promotion, private-IP, and QEC inventory

**Lane:** `ergodis`. This is a technical classification, not a source move,
publication decision, legal conclusion, or IP allocation.

## Evidence boundary

Inspected revisions are core `6cc96680c0c3` and private `74b7ca9243b1`
(2026-09-06). The private workspace declares `publish = false` and a local-path
dependency on core with `control-plane` and `parallel`
(`ergodis-private/Cargo.toml:7-23`), confirming the one-way technical
dependency. Core `AGENTS.md` documents filtered public snapshots, but no public
snapshot was inspected, so publication status of individual QEC assets is not
established. Paths are not evidence of ownership, inventorship, disclosure, or
licence.

No WASM marker was found by the bounded search in the two inspected `src/` and
`docs/` trees. This is a scoped negative only; use the separate WASM audit for
prototype location and host constraints.

## Retain/promote/adapt/private matrix

| Private asset | Current core overlap | Classification | Concrete bounded seam |
|---|---|---|---|
| `src/proof_synthesis.rs:16-83, 220-262, 291-321, 386-480`: bounded relation discovery, registered extractors, Horn replay | Core has candidate evolution and a diagnostic archive (`src/theorem_search.rs:1-15, 614-760`), but no inspected sealed extractor/Horn interface. | **Adapt a core contract; retain private theorem registries.** | Consider a core validator/replay interface only if it carries extractor/module identity, parameter binding, validation evidence, and scope. Do not copy C1016 rule arrays or treat corpus soundness as proof authority. |
| `src/semantic_plan.rs:1-65, 132-260`: typed match/reduce/canonicalize recipes | Core already owns bounded `PlanSpec`/VM campaign plans and scopes (`src/control/mod.rs:150-360`). | **Adapt, do not duplicate.** | Test whether recipes lower into core candidate/provenance records; retain private recipe vocabulary and adapters. Any recipe ABI belongs to the extension-runtime decision. |
| `src/feature_synthesis.rs:1-98, 152-260`: affine/symmetric obstruction generation | Core has typed hash-consed terms, raw/conflict expansion, cost/degree bounds, snapshots, and predicate quotienting (`src/feature_dag.rs:1-145, 190-260`). | **Promote reusable proposal/scoping workflow into core; do not duplicate the DAG.** | Extract one domain-neutral `FeatureProposer` contract over a core presentation/DAG: bounded proposal emission, declared origin, optional scope, evaluation cost, and replayable proposal identity. Rebase private affine/symmetric generators onto it; retain C1016 target data and theorem labels privately. |
| `src/raw_feature_evolve.rs`; `banked_semantic_evolve.rs:1-39,78-241`; `banked_rule_evolve.rs:1-9,78-187` | Core has batches, evolution evidence, plan evaluation, and diagnostic archive (`src/control/evolution.rs:1-118`; `src/theorem_search.rs:614-760`). | **Promote generic expansion/refinement workflow; retain C1016 data and fixtures.** | `raw_feature_evolve.rs:1-8,86-105` is genuinely domain-neutral paired-scalar plus pairwise-difference expansion, though currently embedded in the C1016 corpus writer. Move that expansion behind the same core `FeatureProposer` contract. Retain banked residuals/rules/labels and all C1016 outputs privately. |
| `tasks/hadamard-2092/src/evolve/theorem_gap.rs:1-12,42-50,604-639`: direct-model counterexamples | Core `SoundTheoremArchive` records soundness, dominance, and capacity admissions (`src/theorem_search.rs:623-760`). | **Adapt generic refutation artifacts; private planted family.** | Add a generic counterexample/validator hook only if core archive lacks one. Preserve direct model, literals, and corpus as private regression fixtures. This is CEGAR-shaped evidence, not general admission proof. |
| C1016 q29/quotient mechanisms, e.g. `src/q29_even_moment_proof.rs:1-14,51-52` | No inspected core Hadamard/PAF implementation. | **Private theorem implementations, parameters, heuristics, fixtures, witnesses.** | Later promote only a domain-neutral quotient/compiler evaluation interface, after objective and validation model are chosen. Do not expose q29/q174/carrier policy. |
| C985→C1016 typed-witness memo, `notes/2026-08-31-c985-c1016-zero-cost-witness-handoff.md:1-43,90-125` | Core has hot-loop policy but no inspected reusable `ValidatedRegistry` type. | **Performance-gated core pattern, not approved migration.** | A validated-runtime-program witness can be a core contract only with cross-domain need. The memo reports it slower for static adapters; require representative A/B before promotion. |
| Campaign/socket machinery | Core owns `Manifest`, request/response, bounded ledger, campaign state, creation, and proposal daemon (`src/control/mod.rs:171-360`), plus evolution identity/evidence (`src/control/evolution.rs:1-118`). | **Already core.** | Do not duplicate it privately. Extend it only after C1079 specifies mode, theorem/parameter lineage, validation scope, module identity, and disclosure/use records. |

The core is therefore already the right owner for generic campaign, evolution,
feature-DAG, diagnostic archive, and socket services. Private code supplies
domain adapters, proof kernels, corpora, and task knowledge. Core already has
a bounded source frontend: `PlanDocument` accepts expression or bytecode and
lowers trees to `PlanSpec` (`src/control/vm.rs:335-500`), while
`src/control/text.rs:4,49-50` parses the text frontend. Missing extension
pieces are a general industry-package loader, package/module resolution and
compatibility, native-kernel imports/capabilities, and a generalized
source-language/IR boundary beyond the current plan language.

The existing `Manifest` binds run ID, nonce, socket, code commit,
presentation hash, and feature generator (`src/control/mod.rs:171-184`), while
the private extractor binds identity/version/parameter digest/source commitment
(`ergodis-private/src/proof_synthesis.rs:220-262`). No inspected record joins
these into the full C1079 module/source/compiler/candidate/parameter/validation
lineage. That is a requirement gap, not a correctness finding.

### Concrete generic feature extraction

The prior promotion survey identifies relational evolution grammar,
counterexample-driven frozen presentation transitions, contextual scopes with
provenance, and downstream-aware existential projection with a Pareto frontier
as the relevant typed scope/projection work (promotion survey, section 2,
items 1, 2, 4, 5). Current sources supply three generic producers: paired
scalar/pairwise-difference expansion (`raw_feature_evolve.rs:1-8,86-105`),
permutation invariants (`symmetric_feature_evolve.rs:1-12`), and cyclic
quotient/sparse-scope discovery (`cyclic_residual_features.rs:1-27,250-332`).

One sufficient promotion target is a core `FeatureProposer` contract, not a
second term DAG. It takes an immutable core presentation/DAG and bounded budget,
returns typed terms plus optional contextual scope/projection, origin,
evaluation-cost bound, and deterministic replay identity, and has no pruning
authority until a separate validator admits it. This makes reusable generation
and scoping core-owned while leaving theorem labels, target domains, parameter
recipes, and selection policies as industry/private payloads.

## QEC technical asset map

| Area | Core assets | Private assets | Technical boundary observation |
|---|---|---|---|
| CSS distance and algebra | `src/css_distance.rs:1-36`; CSS action compilation/verification in `src/lib.rs:33,135-138`; cold CSS adapters in `src/bin/css_automorphism_adapter.rs:1-15` and `css_isomorphism_adapter.rs:1-12`. | `src/css_codes.rs:1-3`, `src/gf2_linalg.rs:1-3`, `tasks/gem-hunt/src/transversal_css.rs:1-19`, `level_census.rs:1-6`. | Core already has substantial exact CSS machinery. Private transversal/level-census drivers may package with QEC, but API overlap needs an import inventory first. |
| BP/OSD and decoder input | `src/bp_osd.rs:1-11` provides candidate vectors and certified syndrome upper bounds. | `src/detector_error_model.rs:1-30` parses a constrained flattened Stim DEM; `tasks/tools/src/decoder_baseline_bench.rs:1-16` consumes it. | DEM parsing, Stim boundary, and benchmark configuration are QEC-specific payload candidates. |
| TigerBlossom | No Tiger implementation found in inspected core. | `src/tiger_blossom.rs:1-75`, `tiger_blossom_graph.rs`, `tiger_blossom_sparse.rs`. | Strong specialized QEC-kernel candidate: its semantics include detector boundaries, syndromes, observable parity, and decoder certificates. It needs a future host-kernel contract; core must not depend on it. |
| Dynamic QEC composition | No directly corresponding inspected core module. | `src/syndrome_window.rs`, `space_axis_window.rs`, `window_exactness.rs`, `sparse_composition.rs`, `surface_predecoder.rs`; `open_problem.rs:56,728-731` identifies QEC shapes. | Retain QEC adapters/prototypes as package payloads. Promote a clearly domain-neutral retained-composition contract when identified, with the core performance gate; a second domain is not a prerequisite for core ownership. |
| Benchmarks/evidence | Core owns its `evidence/` export path per `ergodis/AGENTS.md`; specific public status uninspected. | `tasks/tools/src/tiger_blossom_bench.rs`, `certified_predecoder_bench.rs`, `soft_output_bench.rs`, `css_bp_osd_spike.rs`. | Models, generated data, reports, and configuration need explicit package manifests; no transfer follows from location. |

## QEC carve-out readiness: technical only

A plausible package nucleus is the DEM parser, TigerBlossom graph/sparse kernel,
syndrome/window/predecoder/soft-output adapters, QEC parameters, fixtures,
benchmark generators/data, and private evidence. It would consume core
matrix/GF(2), exact CSS verification where applicable, feature/plan evaluation,
candidate lifecycle, and control services. The direct Cargo dependency above is
compatible with this direction, but independent build/deployment is unproven:
no module ABI, package manifest, separate build, loader, generalized
source-to-IR extension compiler, or WASM variant was found here. Core's current
PlanDocument compiler is already present; it is not an industry package loader.

Before treating QEC as independently versionable, gate it with: (1) a
QEC-private-to-core import inventory, (2) a core-only build with no dependency
on or asset leakage from the **private QEC package** (the existing generic CSS
core remains in core), (3) an asset/dependency manifest including evidence and fixtures, (4) a
versioned kernel/IR capability boundary, and (5) replay of representative exact
CSS and decoder cases across that boundary. These are technical gates only;
disclosure, permitted reuse, confidentiality, and industry allocation remain
separate decision records and may require IP/legal review.

## Narrow synthesis recommendation

Avoid a wholesale private-evolve move. The core already contains general
campaign, evolution, feature-DAG, archive, and socket machinery. The bounded
next seam is the single `FeatureProposer`/validator contract described above,
reconciling core workflow ownership with private sealed extraction and exact
replay. Keep C1016 and QEC knowledge private during that review and use their
artifacts as acceptance controls, not source to move.

## Bounded whole-workspace ownership map

This is a filename/module-list review, not a universal audit. It supplements
the 2026-09-02 promotion survey, whose candidate list is partly stale: the
current core now exports `arithmetic`, `binary_margin_lift`, `predicate_cover`,
`mask_cycle_proof`, and `semantic_theorems` (`ergodis/src/lib.rs:10-61`), while
private still declares predecessor/parallel modules including
`binary_margin_lift`, `bitset_sumset`, `two_adic_autocorrelation`, `z2k_subgroup`,
`predicate_cover`, and `semantic_theorems`
(`ergodis-private/src/lib.rs:18-220`). That is evidence for consolidation
review, not proof that every pair has identical APIs or semantics.

| Coarse layer | Current ownership evidence | Recommended ownership | Concrete cleanup/migration value |
|---|---|---|---|
| Generic arithmetic, margin, masks, proof-sidecars | Core has a combined `arithmetic` module and `binary_margin_lift`, plus `mask_cycle_proof`, `predicate_cover`, and `semantic_theorems` (`ergodis/src/lib.rs:10-61, 96-150`). Private retains modules with the same capability names. | **Core-owned reusable machinery.** | Inventory each private caller of the predecessor modules, route it to the core API where semantic parity holds, then retire duplicate private implementations only after scoped differential/replay checks. Highest-value obvious seam: `two_adic_autocorrelation`/`z2k_subgroup`/`bitset_sumset` versus core `arithmetic`; no new public subsystem is needed. |
| Feature discovery, scopes, projection, and candidate ranking | Core: `feature_dag`, `group_aggregation`, `contextual`, `theorem_search`, and `control` (`ergodis/src/lib.rs:25-61, 150-220`). Private: `feature_synthesis`, `raw_feature_evolve`, `symmetric_feature_evolve`, `cyclic_residual_features`, `predicate_cover`, `policy_*`. | **Core-owned workflow and data contracts; private knowledge payloads.** | Land one `FeatureProposer` contract on core DAG/presentation objects, then migrate generic paired, symmetric, relational, contextual-scope, and projection producers incrementally. Keep task target spaces, labels, learned policies, and theorem/parameter recipes private. This corrects the old split that left generic generators private by default. |
| Generic proof/replay and certificates | Core has semantic theorem/provenance/witness surfaces; private has `proof_synthesis`, `generic_certificate`, `incremental_certificate`, and task proof modules. | **Core owns interfaces and generic replay; private owns domain rules and evidence inputs.** | Extract sealed extractor/validator and validation-scope contracts from `proof_synthesis`; preserve C1016 rule registries and proof implementations. This turns current ad-hoc public/private proof boundaries into one-way core contracts without leaking private theorems. |
| Runtime/control/persistence | Core exposes control only behind the feature and owns campaign/RPC objects (`ergodis/src/lib.rs:30-32`; `src/control/mod.rs:171-360`). Private declares `alignment_control` and task adapters, and links core control by path (`ergodis-private/Cargo.toml:17-23`). | **Core-owned runtime workflow; private/industry adapters.** | Consolidate protocol/schema/lifecycle changes in core. Do not create a private rival daemon. Add package/module identity and source/native-IR lineage there; keep adapters and policies outside core. |
| Generic search/kernel structures | Core has `hall`, `composition`, `ordered_resource`, `matrix`, `field`, `linear_code`, `structured_integer_set`, and `repr`-adjacent containers (`ergodis/src/lib.rs:20-60`). Private has `hall_core`, `repr_grammar`, `semantic_sets`, `projected_orbit_min_cost`, `semiring_tree`, and `open_problem`. | **Promote/rebase reusable kernels to core; retain domain adapters.** | Highest-value next reviews are sparse `hall_core` against core `hall`, `repr_grammar` as a core representation-search facility, and `proof_synthesis`/`semantic_sets` after their explicit contracts exist. The 2026-09-02 survey already records zero-allocation evidence for many private modules, but current performance acceptance still applies before any migration. |
| QEC/CSS | Core contains generic/exact CSS distance, algebra, and BP/OSD; private contains detector-model parsing, TigerBlossom, window/predecoder adapters, QEC tools and fixtures. | **Core retains generic CSS/math and runtime services; QEC package retains decoder implementation/parameters/data.** | Preserve a clean direction: QEC may call core but core must not name or require the private decoder. A package boundary can later expose Tiger through a versioned capability contract, without removing generic CSS from core. |
| C1016/Hadamard and other task/domain adapters | Private module list contains `g41*`, `g53*`, `g91*`, `g133*`, `q*`, `hadamard_2092`, task crates, and banked corpora (`ergodis-private/src/lib.rs:45-170`; `tasks/*`). | **Private task/domain knowledge.** | Keep reductions, parameter recipes, tablebases, campaign fixtures, and task binaries private. Migrate only their generic dependencies upward, so private adapters shrink rather than core absorbing research process. |
| Evidence, build artifacts, and contributor tooling | Core guide assigns core `evidence/` and one-way evidence export; private is library-only with tier-2 task crates and shared out-of-tree targets (`ergodis/AGENTS.md`; `ergodis-private/AGENTS.md`). | **Keep provenance-bearing evidence with its producing package; core owns shared schemas/tooling.** | Do not co-mingle task evidence merely to tidy paths. Define shared evidence/lineage schemas in core, with package-specific evidence stores and explicit disclosure views. Build/test/docs strengthen both layers but do not determine whether an algorithm or dataset is generic. |

### Coarse cleanup order

1. Reconcile now-obvious generic duplicates already represented in core
   (`arithmetic` family, margin lift, predicate/proof-sidecar surfaces), using
   an import-and-parity inventory before deletion.
2. Extract the single core `FeatureProposer`/validation contract, so generic
   feature, scope, and projection workflows stop accreting in private modules.
3. Establish proof-validator and runtime-package seams in core; then rebase
   private C1016 and QEC adapters on them without moving their business/research
   knowledge.
4. Separately review sparse Hall, representation grammar, and retained
   composition as high-value generic kernel candidates. They need one clear
   domain-neutral contract and ordinary validation, not a second-domain proof
   of eligibility.
