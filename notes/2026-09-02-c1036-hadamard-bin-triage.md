# C1036 — triage of the remaining `ergodis-private/src/bin` binaries

**Date**: 2026-09-02
**Lane**: `complete-ports`
**Scope**: read-only triage. No file under `ergodis-private/` was modified by this pass; the
report is the only deliverable.

## Method

`ls ergodis-private/src/bin` lists 103 files at `HEAD` (`d381623f1`). For each one:

- the sector was read off the file name and the `ergodis_private::<module>` imports it makes,
  since almost every bin is a thin driver over a same-named tier-1 library module;
- the purpose line is that driver's function, taken from its `#[command(about = …)]` or `//!`
  doc comment where one exists, and otherwise from the library modules it drives (most of these
  files carry no top doc comment at all — see "Gap" below);
- references were collected with a bounded per-bin fixed-string search over `notes`,
  `ergodis-private/{evidence,docs,performance,scripts,tests}` restricted to
  `*.md *.json *.jsonl *.tsv *.sh *.rs`, keeping at most six hits;
- the bucket is LIVE / BANKED / DEAD as defined in
  `notes/2026-09-02-ergodis-private-crate-consolidation-proposal.md`, decided against the C1016
  section of `notes/handoffs/2026-07-17-complete-ports-paper.md` (the live frontier is the g41
  q18 shell, the q29 lift, the deficit-tablebase join, the blind evolve controls, and the sealed
  g133/g91/g53 proof replays) and `notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`.

Where LIVE and BANKED were genuinely close the row is marked LIVE, and the reason says so.

## Bucket counts

| Bucket | Count |
|--------|-------|
| LIVE   | 55    |
| BANKED | 38    |
| DEAD   | 10    |
| Total  | 103   |

LIVE is deliberately the large bucket: the instruction is to mark a row LIVE whenever LIVE and
BANKED are close, and 12 of the 55 are lane-neutral tools that carry committed replay commands but
are not Hadamard-2092 sectors at all. The Hadamard-2092 crate itself takes the 43 LIVE bins in the
tree below; the other 12 (six C985/CSS drivers, five campaign and routing tools, and
`c80_hall_rematch`) go to `tasks/tools` or a separate C985 crate.

## Bins whose replay command is committed in evidence or a report note

These are the parity runs C1036 owes, because a written `cargo run --bin <name> …` line at
`HEAD` must keep working (or be rewritten in the same commit that renames the bin):

| Bin | Where the replay command is written |
|-----|--------------------------------------|
| `alignment_root_corpus` | `ergodis-private/docs/CAMPAIGNS.md`, `evidence/alignment-root-sized-routing-README.md`, `evidence/alignment-root-cost-routing-README.md` |
| `c80_hall_rematch` | `notes/2026-08-30-c80-hall-rematching-attack.md` |
| `c985_extension_field_elimination_bench` | `notes/2026-08-31-c1030-ergodis-audit-rootcause.md` |
| `certdist` | `ergodis-private/evidence/certdist/scripts/run-{headtohead,regen,resume,verify}.sh` |
| `certiis` | `notes/2026-08-31-ergodis-target-portfolio.md`, `notes/2026-08-31-c1030-ergodis-audit-certificates-io.md` (six occurrences across notes) |
| `css_bp_osd_spike` | `notes/2026-09-01-c985-qdist-lp1768-bounds.md` |
| `qdist_to_ergodis` | `notes/2026-09-01-c985-qdist-lp714-exact-distance.md`, `notes/2026-09-01-c985-qdist-lp1768-bounds.md`, `notes/2026-09-02-c985-lp1768-cross-direction-equivalence.md` |
| `routing_policy_audit` | `ergodis-private/docs/CAMPAIGNS.md`, `evidence/alignment-root-cost-routing-README.md` |
| `semantic_affine_census` | `notes/2026-08-30-ergodis-semantic-mining-engine-adr.md` |
| `semantic_rank_census` | `ergodis-private/evidence/semantic-rank-census-v1.json` |
| `target_strategy_audit` | `ergodis-private/docs/CAMPAIGNS.md`, three `evidence/*-README.md` files |

Three `--bin` names that still appear in committed notes no longer exist in the tree
(`g53_q7_repair`, `g53_sparse_q4_join`, `g53_joint_q29_scout`); those replay lines are already
historical and need a commit pin rather than a parity run.

## Bins invoked by name from a script or a test

None. `ergodis-private/scripts/*.sh` and `scripts/*.py` contain no `cargo run`, no `--bin`, and
no `target/release/<bin>` path; `benchmark_projective_grid_parallel.sh` takes its executable as
`$1` (C1035 already repointed it at `ergodis-tools`). The three integration tests
(`tests/proof_synthesis_allocations.rs`, `tests/g41_pair_workspace_allocations.rs`,
`tests/hadamard_2092_allocations.rs`) import library modules — `ergodis_private::g41_quotient_filter_proof`,
`::g53_sparse_q4_proof`, `::g91_defect_obstruction`, `::g53_search` — and never spawn a binary.
So no rename breaks a script or a test; the only rename hazard is the committed replay lines above.

## Triage table

Sorted by sector, then name. "Refs" lists the referencing notes and evidence files (blank means
no `.md`/`.json`/`.tsv`/`.sh` file in the searched trees names the bin).

### Sector: evolve / semantic / banked controls

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `alignment_root_corpus` | Generate an exact per-root alignment cost corpus (its own `about`) | `docs/CAMPAIGNS.md`; two `evidence/alignment-root-*-README.md`; `notes/2026-09-01-c985-fables-review.md` | LIVE | committed `--bin` replay in a campaign doc and two evidence bundles |
| `banked_rule_evolve_adapter` | Emit the exhaustive rule-ablation corpus for the ten sealed proof systems | — | LIVE | supplies the evolve backfill the handoff names as a standing control |
| `banked_rule_evolve_audit` | Audit that evolve retains a perfect plan on each rule-ablation corpus | `notes/2026-09-01-c985-fables-review.md` | LIVE | the audit half of the same standing control |
| `banked_semantic_evolve_adapter` | Emit the fourteen theorem-specific semantic residual corpora | — | LIVE | backfill control for all fourteen banked reductions |
| `banked_semantic_evolve_audit` | Audit evolve recovery on those fourteen corpora | `notes/2026-09-01-c985-fables-review.md` | LIVE | same control, audit half |
| `blind_raw_holdout_harness` | Theorem-agnostic train/holdout harness over expanded scalar observations (`//!`) | `notes/2026-08-31-c1031-…-visualization-goal.md`; `notes/2026-09-01-c985-fables-review.md`; `notes/2026-09-02-c1035-…-workspace-split.md` | LIVE | the blind evolve control named in the handoff frontier; also on C1035's clippy backlog |
| `project_reachable_feature_support` | Generic existential projection of an exact labelled feature domain (`//!`) | — | BANKED | generic projection helper whose result is inside the feature-DAG report; nothing replays it |
| `proof_synthesis_perf` | Counter harness for the g133/g41/g53 proof-synthesis rule kernels | — | LIVE | produces the derive/replay instruction and cycle numbers quoted for every sealed proof |
| `raw_feature_evolve_adapter` | Present opaque paired scalars plus pairwise differences to evolve | — | LIVE | the stricter blind (pre-residual) control; its successor gate is still open |
| `routing_policy_audit` | Learn a conservative routing policy from matched evolution audits (its own `about`) | `docs/CAMPAIGNS.md`; `evidence/alignment-root-cost-routing-README.md`; `notes/2026-09-01-c985-fables-review.md` | LIVE | committed `--bin` replay in a campaign doc and an evidence bundle |
| `semantic_affine_census` | Census of affine semantic plans over a `nine_set` TSV | `notes/2026-08-31-c1030-round2-core-remainder.md`; `notes/2026-08-30-ergodis-semantic-census-perf-evidence.json`; `notes/2026-08-30-ergodis-semantic-mining-engine-adr.md`; `notes/2026-08-27-c985-…-optimization-paper.md` | LIVE | committed replay plus a committed perf-evidence JSON |
| `semantic_rank_census` | Allocation-free semantic rank kernel census for counter isolation | `evidence/semantic-rank-census-v1.json`; `notes/2026-08-31-c1030-round2-bins-tests-checkers.md`; `notes/2026-08-30-c1018-ergodis-hunt-log.md` | LIVE | committed evidence JSON carries its replay |
| `target_strategy_audit` | Matched exact audit of evolution target strategies (its own `about`) | `docs/CAMPAIGNS.md`; three `evidence/*-README.md`; `notes/2026-09-01-c985-fables-review.md` | LIVE | four committed `--bin` replay lines |

### Sector: g133

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g133_cycle_mod11_proof` | Synthesize and verify the sealed `-2 q3 - q9 (mod 11)` cycle-identity proof | — | LIVE | sealed-proof replay the handoff still relies on for the 42-cell exclusion |
| `g133_evolve_adapter` | Export q6 cell-shape features (adapter v3/v4) to evolve | `notes/2026-08-31-c1031-…-visualization-goal.md`; `notes/2026-09-01-c985-fables-review.md` | LIVE | supplies the `base_sumset_pairs != hole_covered_pairs` gap identity bound into the sealed transcript |
| `g133_exact_q2_proof` | Synthesize and verify the sealed exact q2 exclusion of 352,512 roots | five `notes/2026-08-31-c1030-*` audit notes | LIVE | sealed `ExactComputational` proof replay |
| `g133_exact_shift_proof` | Synthesize and verify the sealed exact q6 extractor v2 proof | — | LIVE | sealed proof replay for the 6,739,200 survivors and 8,985,600 exclusions |

### Sector: g41 joint / quotient

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g41_joint_digit_cache` | Build and load the sealed 47.6 MB joint digit-witness cache | — | LIVE | the cache the deficit-tablebase/fine-lift join loads; the join is the named open frontier |
| `g41_joint_digit_witnesses` | Compile the common quotient witness for each of the 768 roots | — | LIVE | the common-witness compiler behind the 768-root reduction, still the join's input |
| `g41_joint_multiplicity` | Count digit multiplicity above the joint quotient roots | — | BANKED | its multiplicity audit is a number in the C1016 report; nothing replays it |
| `g41_quotient_filter_proof` | Synthesize and verify the sealed g41 exact q0–q9 filter proof | `tests/proof_synthesis_allocations.rs` (library module); four `notes/2026-08-31-c1030-*`; `notes/2026-08-31-c1031-…-data-model.md` | LIVE | sealed `ExactComputational` proof replay; its module also carries an allocation test |
| `multiplier_z18_projection` | Print the Z/18 multiplier projection for a carrier/generator pair | — | LIVE | shared `hadamard_2092` projection driver every sector's derivation quotes |

### Sector: g41 q174

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g41_q174_degree_fibre` | Enumerate q174 degree fibres | — | BANKED | intermediate fibre census folded into the q174 joint tables |
| `g41_q174_energy_theorem` | Prove the q174 zero-energy lower bound for exact G41/q18 interfaces (its own `about`) | — | LIVE | the q174 energy theorem the q18 shell argument stands on |
| `g41_q174_evolve` | Discovery-only q174 evolution for the C1016/G41 source family (its own `about`) | — | BANKED | self-declared discovery-only; its retained leads are in the report |
| `g41_q174_fibre_structure` | Describe the structure of the q174 joint fibres | — | BANKED | descriptive census superseded by the grouped join |
| `g41_q174_flip_corpus` | Build the row-261 complementation (flip) corpus | `notes/2026-09-02-c1034-…-consolidation.md` (as a clippy-failing file only) | BANKED | corpus stage; the flip result is banked in the q29 lift theorem |
| `g41_q174_flip_proof` | Replay the flip-invariance proof of the q174 defects | — | LIVE | the complementation-preserves-defects step that halves the q29 block specs |
| `g41_q174_full_q87_join` | Exact full q174/q87 join | `notes/2026-09-01-c985-fables-review.md` | LIVE | the joint-order join feeding the current q29 lift |
| `g41_q174_joint` | Drive the q174 joint interface tables | `notes/2026-09-01-c985-fables-review.md` | LIVE | the shared entry point every other q174 bin builds on |
| `g41_q174_joint_join` | Grouped exact q174 join against the q58 tablebase and Gram masks | `notes/2026-09-01-c985-fables-review.md` | LIVE | the grouped-join stage of the same live path |
| `g41_q174_partition_corpus` | Build the q174 partition corpus for evolve | — | BANKED | corpus stage, result in the report table |
| `g41_q174_q87_energy_bound_probe` | Probe energy bounds on the q174/q87 interaction | — | BANKED | fast probe superseded by the exact energy theorem |
| `g41_q174_q87_interactions` | Enumerate q174/q87 interaction terms | — | BANKED | enumeration folded into the full q87 join |
| `g41_q174_q87_replay` | Directly replay a q174/q87 join positive | — | LIVE | the direct replay every positive of the live join must pass |
| `g41_q174_q87_scope_corpus` | Build the scoped q87 corpus for feature synthesis | — | BANKED | corpus stage |
| `g41_q174_q87_scope_evolve` | Evolve scoped predicates on that corpus | — | BANKED | discovery-only; retained leads are in the report |
| `g41_q174_source_feasibility` | Test feasibility of q174 source profiles | — | BANKED | feasibility pass consumed by the joint tables |
| `g41_q174_source_projection_batch` | Batch the q174 source projections into the q29 caches | — | BANKED | superseded projection stage; the caches it filled are committed |
| `g41_q174_source_projection_index` | Index those source projections | — | DEAD | coordinate-projection indexing stage, superseded by the batch driver and unreferenced |
| `g41_q174_target_fibre_replay` | Replay a q174 target fibre directly | — | LIVE | direct-replay oracle for the target fibres the live join consumes |
| `g41_q174_target_fibres` | Compile the q174 target fibres from the grouped join and Gram masks | — | LIVE | produces the fibres the q29 lift joins against |

### Sector: g41 q29

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g41_q29_aggregate_pair_graph` | Aggregate the q29 pair graph over the digit-witness cache | — | BANKED | aggregate counts are a report table; the signature census replaced it |
| `g41_q29_block_spec_census` | Census the q29 four-block specs against the exact tablebase | `notes/2026-09-02-c1034-…-consolidation.md` (clippy-failing file only) | LIVE | block specs are exactly what the `D_s` coordinate halves; current frontier |
| `g41_q29_degree_obstruction_corpus` | Build a degree-obstruction corpus for symmetric feature evolve | — | BANKED | corpus stage, banked lead |
| `g41_q29_direct_lift_work_model` | Model the work of the direct q29 lift | — | LIVE | the runtime model gating the fine-lift join launch decision |
| `g41_q29_direct_reset_bench` | Micro-bench the tablebase direct reset | — | DEAD | superseded micro-benchmark, unreferenced, no counter claim depends on it |
| `g41_q29_matched_pair_cache` | Build the matched pair cache shared by the q29 joins | — | LIVE | the cache the deficit-tablebase join reads |
| `g41_q29_multiset_corpus` | Build a q29 multiset corpus for evolve | — | BANKED | corpus stage |
| `g41_q29_pair_target_cache_audit` | Audit the pair-target cache against the exact tablebase | — | LIVE | integrity audit of a cache the live join still loads (LIVE on the unsure rule) |
| `g41_q29_pair_target_corpus` | Build the pair-target corpus for raw feature evolve | — | BANKED | corpus stage |
| `g41_q29_pair_target_cycle_proof` | Replay the pair-target mask-cycle proof | — | LIVE | proof replay for the cycle identity the q29 lift uses |
| `g41_q29_profile_campaign` | Drive the q29 profile descent campaign over shards and caches | — | LIVE | the campaign driver for the open q29 lift |
| `g41_q29_profile_hit_interface` | Enumerate the raw common-quotient digit interfaces of a hit | — | BANKED | the 1,984,512-interface agreement is banked; the sealed cache replaced the enumeration |
| `g41_q29_profile_hit_lift` | Lift a profile hit through the exact tablebase and evolve features | — | LIVE | the fine-lift step named in the open frontier |
| `g41_q29_profile_hit_membership` | Test membership of a hit in the exact tablebase | — | BANKED | membership check absorbed into the lift driver |
| `g41_q29_profile_hit_replay` | Directly replay a profile hit | — | LIVE | direct replay every positive of the live campaign must pass |
| `g41_q29_profile_multiset` | Census profile multisets over the digit-witness cache | — | BANKED | census result is a report number |
| `g41_q29_profile_participation` | Measure shard participation per profile | — | BANKED | shard-era diagnostic |
| `g41_q29_profile_shard` | Run one shard of the profile search | — | DEAD | superseded shard stage; the exact tablebase replaced sharded search |
| `g41_q29_q58_behavior_edge_census` | Census q29/q58 behavior edges | `notes/2026-09-02-c1035-…-workspace-split.md` (clippy-failing file only) | BANKED | q58 behavior census banked; the primitive q58 join was rejected on performance |
| `g41_q29_signature_census` | Census q29 signatures over the aggregate pair graph | — | BANKED | signature counts are a report table |
| `g41_q29_signature_class_corpus` | Build the signature-class corpus | — | BANKED | corpus stage |
| `g41_q29_source_pair_graph` | Build the q29 source pair graph | — | BANKED | superseded by the matched pair cache |
| `g41_q29_target_cache_participation` | Measure target-cache participation per shard | `notes/2026-09-02-c1035-…-workspace-split.md` (clippy-failing file only) | BANKED | shard-era diagnostic |

### Sector: g41 q87

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g41_q87_behavior_edge_census` | Census q87 behavior edges over the matched pair cache | `notes/2026-09-02-c1035-…-workspace-split.md` (clippy-failing file only) | BANKED | behavior census banked in the report |
| `g41_q87_behavior_evolve_corpus` | Build the q87 behavior corpus for evolve | — | BANKED | corpus stage |
| `g41_q87_behavior_profile_census` | Census q87 behavior profiles | — | BANKED | census result is a report table |
| `g41_q87_energy` | Compute q87 block energies | — | LIVE | energy source for the live q174/q87 join |
| `g41_q87_energy_handoff_bench` | Bench the q87 energy handoff path | — | DEAD | superseded micro-benchmark, unreferenced |
| `g41_q87_evolve_corpus` | Build a q87 energy corpus for evolve | — | BANKED | corpus stage |
| `g41_q87_exact_energy` | Compute exact q87 energies | — | LIVE | the exact energy the q174/q87 join and reachability need |
| `g41_q87_reachability_corpus` | Build the q87 reachability corpus | — | BANKED | corpus stage |
| `g41_q87_spec_behavior_census` | Census spec behavior against the exact tablebase | — | BANKED | census result is a report table |

### Sector: g53

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g53_mod14_scout` | Scout the mod-14 reduction | — | DEAD | superseded scalar-modulus scout; the sparse q4 fibre replaced all of them |
| `g53_mod28_scout` | Scout the mod-28 reduction | — | DEAD | same |
| `g53_mod343_scout` | Scout the 7-adic mod-343 lift | four `notes/2026-08-31-c1030-*` and the C985 review | BANKED | recorded as a fast-falsified control (all 2,496 roots lift mod 343); nothing replays it |
| `g53_mod49_high_scout` | Scout high mod-49 seeds | `notes/2026-08-31-c1030-round2-reduction-math.md` and three more | BANKED | the mod-49 seed bank is a retained rejected control |
| `g53_search` | Run the g53 v2 two-phase quotient-shell search | `tests/proof_synthesis_allocations.rs` (library module); six `notes/2026-08-31-*` | LIVE | the retained discovery campaign driver with the seed-replay protocol |
| `g53_sparse_q4_oracle` | Independent full base-five/hash oracle for the exact q4 fibre | `notes/2026-08-31-c1030-round2-reduction-math.md`; `-round2-freehunt.md`; `notes/2026-08-31-ergodis-correctness-assurance-adr.md` | LIVE | the independent oracle the sealed q4 proof is checked against |
| `g53_sparse_q4_proof` | Synthesize and verify the sealed sparse-defect q4 exclusion proof | `tests/proof_synthesis_allocations.rs` (library module); five `notes/2026-08-31-*` | LIVE | sealed proof replay closing the g53 multiplier shard |

### Sector: g91

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `g91_defect_obstruction` | Synthesize and verify the sealed g91 q0 defect-obstruction proof | `tests/proof_synthesis_allocations.rs` (library module) | LIVE | sealed proof replay; `13 n27 + 15 n29 = 34` kills the whole g91 shard |

### Sector: hall / hadamard

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `c80_hall_rematch` | C80 consumed-label Hall rematching instances and admission triage (its own `about`) | `notes/2026-08-30-c80-hall-rematching-attack.md`; three `notes/2026-08-31-c1030-*`; `notes/2026-08-30-c1018-ergodis-hunt-log.md` | LIVE | committed `--bin` replay, and `HEAD` is the C80 Hall deficit evidence commit |
| `lp333_orbit_lock` | Replay the LP-333 orbit lock | `notes/2026-08-31-c1030-round2-bins-tests-checkers.md` | BANKED | one-shot replay whose result is in the audit note; nothing re-runs it |

### Sector: order 6

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `order6_crt_residual_perf` | Counter harness for the order-6 CRT residual kernel | — | DEAD | superseded perf harness; no committed counter claim cites it |
| `order6_margin_evolve` | Evolve order-6 margins under the q29 launch gate | — | LIVE | the phase-one gate for the open q29 lift |
| `order6_q29_exact_repair` | Exact order-6 repair of a q29 margin state | — | LIVE | the exact repair step on the live q29 path |
| `order6_word_bound` | Bound order-6 quotient words | — | BANKED | the bound is a report number; nothing replays it |

### Sector: other / lane-neutral tools

These are C985 and CSS-distance operator tools rather than C1016 sectors. They belong in
`tasks/tools` (`ergodis-tools`) or a C985 task crate, not in `tasks/hadamard-2092`; the proposal
already lists `certdist`, `certiis`, and `campaign_rpc` under tier-2 tools.

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `binary_orbit_quadratic_bench` | Micro-bench the two-adic autocorrelation binary orbit kernel | — | DEAD | unreferenced micro-benchmark |
| `c985_binary_projective_bench` | C985 diagnostic for `GF(2^h)` projective action and rank/unrank (`//!`) | `notes/2026-08-31-c1030-round2-bins-tests-checkers.md` | BANKED | its measurement is inside the C985 report; nothing replays it |
| `c985_extension_field_elimination_bench` | C985 diagnostic isolating table-backed characteristic-two row reduction (`//!`) | `notes/2026-08-31-c1030-round2-bins-tests-checkers.md`; `notes/2026-08-31-c1030-ergodis-audit-rootcause.md` | LIVE | a committed `--bin` replay line names it |
| `c985_structured_set_ab` | A/B two structured-set representations | — | DEAD | unreferenced A/B probe |
| `campaign_rpc` | Private campaign RPC helper | `notes/2026-08-31-c1031-…-visualization-goal.md`; `notes/2026-09-01-c1033-…-jupyter-sage-duckdb.md`; the consolidation proposal | LIVE | the RPC surface the visualization and notebook lanes call; proposal pegs it to tier-2 tools |
| `certdist` | Certified exact minimum-distance service prototype (its own `about`) | four `evidence/certdist/scripts/run-*.sh`; `notes/2026-08-31-ergodis-target-portfolio.md`; `notes/2026-08-31-c1030-…-freehunt-pass2.md` | LIVE | a committed evidence bundle of four replay scripts drives it by name |
| `certiis` | Explainable infeasibility for assignment problems (its own `about`) | six notes incl. `notes/2026-08-31-ergodis-correctness-assurance-adr.md`, `notes/2026-09-02-c1035-…-workspace-split.md` | LIVE | six committed `--bin` replay lines |
| `css_bp_osd_spike` | Private BP+OSD CSS logical-witness application spike (its own `about`) | `notes/2026-09-01-c985-qdist-lp1768-bounds.md`; `notes/2026-09-01-c985-fables-review.md`; `notes/2026-09-02-c1035-…-workspace-split.md` | LIVE | committed `--bin` replay in the LP-1768 bounds note |
| `qdist_to_ergodis` | Convert an external QDistSAT matrix stem into a checked Ergodis CSS input (`//!`) | three `notes/2026-09-0*-c985-qdist-*` and the cross-direction equivalence note | LIVE | three committed replay lines; it is the input path for the LP-714/LP-1768 bundles |
| `z2k_subgroup_bench` | Micro-bench the `Z/2^k` subgroup kernel | — | DEAD | unreferenced micro-benchmark |

### Sector: q18

| Bin | Purpose | Refs | Bucket | Reason |
|-----|---------|------|--------|--------|
| `q18_basin_escape` | Search for escapes from the q18 residual basin | — | BANKED | the residual-8/24 basin results are report numbers; the exact shell replaced the search |
| `q18_energy_corpus` | Build the exact q18 energy corpus and gate | — | LIVE | the corpus the exact q18 shell is certified against |
| `q18_local_repair` | Full-delta `3+2` tablebase repair of the retained residual-32 root | — | LIVE | this is the exact q18 shell itself, the first item of the open unrestricted bridge |
| `q18_q29_binary_bridge` | Join q18 margins to the q29 residual root via the binary margin lift | — | LIVE | the unrestricted bridge named as the open frontier |
| `q18_unassumed_evolve` | Evolve unassumed q18 predicates | — | LIVE | the multiplier-unassumed control on the bridge; still the live discovery surface there |

## Proposed subcommand tree for `tasks/hadamard-2092` (LIVE rows only)

One binary, `hadamard`, grouped by sector. The lane-neutral tools above are excluded; they go to
`tasks/tools`, and the C985 CSS-distance drivers (`certdist`, `qdist_to_ergodis`,
`css_bp_osd_spike`, `c985_extension_field_elimination_bench`) want their own C985 task crate
rather than this one.

```
hadamard g41 quotient-proof            # g41_quotient_filter_proof
hadamard g41 digit-cache               # g41_joint_digit_cache
hadamard g41 digit-witnesses           # g41_joint_digit_witnesses
hadamard g41 z18-projection            # multiplier_z18_projection

hadamard g41 q174 joint                # g41_q174_joint
hadamard g41 q174 joint-join           # g41_q174_joint_join
hadamard g41 q174 full-q87-join        # g41_q174_full_q87_join
hadamard g41 q174 energy-theorem       # g41_q174_energy_theorem
hadamard g41 q174 flip-proof           # g41_q174_flip_proof
hadamard g41 q174 target-fibres        # g41_q174_target_fibres
hadamard g41 q174 target-fibre-replay  # g41_q174_target_fibre_replay
hadamard g41 q174 q87-replay           # g41_q174_q87_replay

hadamard g41 q29 block-specs           # g41_q29_block_spec_census
hadamard g41 q29 matched-pair-cache    # g41_q29_matched_pair_cache
hadamard g41 q29 cache-audit           # g41_q29_pair_target_cache_audit
hadamard g41 q29 cycle-proof           # g41_q29_pair_target_cycle_proof
hadamard g41 q29 campaign              # g41_q29_profile_campaign
hadamard g41 q29 hit-lift              # g41_q29_profile_hit_lift
hadamard g41 q29 hit-replay            # g41_q29_profile_hit_replay
hadamard g41 q29 work-model            # g41_q29_direct_lift_work_model

hadamard g41 q87 energy                # g41_q87_energy
hadamard g41 q87 exact-energy          # g41_q87_exact_energy

hadamard g53 search                    # g53_search
hadamard g53 q4-proof                  # g53_sparse_q4_proof
hadamard g53 q4-oracle                 # g53_sparse_q4_oracle

hadamard g91 defect-proof              # g91_defect_obstruction

hadamard g133 q2-proof                 # g133_exact_q2_proof
hadamard g133 shift-proof              # g133_exact_shift_proof
hadamard g133 cycle-mod11-proof        # g133_cycle_mod11_proof
hadamard g133 evolve-adapter           # g133_evolve_adapter

hadamard q18 energy-corpus             # q18_energy_corpus
hadamard q18 local-repair              # q18_local_repair
hadamard q18 q29-bridge                # q18_q29_binary_bridge
hadamard q18 unassumed-evolve          # q18_unassumed_evolve

hadamard order6 margin-evolve          # order6_margin_evolve
hadamard order6 q29-repair             # order6_q29_exact_repair

hadamard evolve banked-rules {emit,audit}      # banked_rule_evolve_{adapter,audit}
hadamard evolve banked-semantics {emit,audit}  # banked_semantic_evolve_{adapter,audit}
hadamard evolve raw-features                   # raw_feature_evolve_adapter
hadamard evolve blind-holdout                  # blind_raw_holdout_harness

hadamard proof perf                    # proof_synthesis_perf
```

The campaign and routing tools (`alignment_root_corpus`, `routing_policy_audit`,
`target_strategy_audit`, `semantic_affine_census`, `semantic_rank_census`, `c80_hall_rematch`,
`campaign_rpc`, `certiis`) are LIVE but not Hadamard-2092 sectors; they carry committed replay
lines and belong in `tasks/tools` alongside `hall-certify`. Renaming any of them requires editing
the replay lines listed above in the same commit.

## Gap worth fixing during the move

Only ten of the 103 files carry a `//!` doc comment and only six carry a `#[command(about = …)]`.
The purposes in the table above are therefore reconstructed from the file name plus the library
modules each driver imports, and a handful may be off in emphasis. Turning each retained bin into
a subcommand forces a one-line `about` string, which is the cheapest available fix; the ones this
pass was least sure of are `g41_q174_source_feasibility`, `g41_q174_q87_interactions`,
`g41_q29_profile_participation`, and `order6_word_bound`, all triaged BANKED.
