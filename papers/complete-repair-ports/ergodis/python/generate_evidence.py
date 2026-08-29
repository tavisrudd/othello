#!/usr/bin/env python3
"""Generate or check the canonical computational evidence bundle."""

from __future__ import annotations

import argparse
import hashlib
import json
from itertools import combinations
from pathlib import Path

from recovery_algorithms.balanced import q27_balanced_transversal_oracle
from recovery_algorithms.costs import (
    compose_cost_table,
    compose_cost_table_with_witnesses,
    compose_prescribed_costs_via_spans,
    cost_contractions,
    direct_composite_map,
    exact_confinement_cost,
    exact_confinement_cost_auto,
    exact_confinement_cost_syndrome_dp,
    hierarchical_helper_loads,
    prescribed_coset_costs,
    prescribed_coset_costs_direct,
    prescribed_coset_subspace_costs,
    simplify_projective_columns,
    target_normalized_composition_with_witness,
    translated_cost_table,
    verify_composition_witness,
    verify_leaf_witness,
)
from recovery_algorithms.defect import (
    convex_shell_histograms,
    gf27_q27_t54_centered_spectra,
    gf27_q27_t54_histogram_pairs,
)
from recovery_algorithms.design import (
    coefficient_presentation_spectrum,
    cooperative_helper_cost,
    relative_weights,
)
from recovery_algorithms.finite import (
    LinearMap,
    all_matrices,
    extension_multiplication_matrix,
    mat_add,
    mat_mul,
    nullspace_basis,
    zero_matrix,
)
from recovery_algorithms.incidence import (
    OrbitOption,
    bounded_threshold_coefficients,
    evaluate_binomial_polynomial,
    signed_incidence_profile,
    ternary_orbit_syndrome_search,
)
from recovery_algorithms.reliability import (
    maximum_recoverable_rank,
    projective_reliability_direct,
    projective_reliability_polynomial,
    projective_size,
    projective_threshold,
)
from recovery_algorithms.service import build_service_lp, zero_extend_service_lp
from recovery_algorithms.storage import (
    earliest_repair_times,
    linear_materialization_plans,
    linear_materialization_supports,
    materialized_replacement_families,
    maximum_parallel_repairs,
    maximum_weighted_parallel_repairs,
    minimum_round_repair_schedule,
    scalar_recovery_equations_from_dual,
    scalar_recovery_sets_from_dual,
)
from recovery_algorithms.transfers import (
    collision_correction,
    delete_to_clique_free_core,
    feature_separator,
    maximum_distinct_repairs,
    replacement_graph_components,
)

PYTHON_ROOT = Path(__file__).resolve().parent
ROOT = PYTHON_ROOT.parent
RESULTS = ROOT / "evidence" / "results.json"
CHECKSUMS = ROOT / "SHA256SUMS"
HASHED_PATHS = (
    "BENCHMARKS.md",
    "Cargo.lock",
    "Cargo.toml",
    "README.md",
    "benches/balanced_frontend.rs",
    "benches/balanced_parallel.rs",
    "benches/contextual_state.rs",
    "benches/defect_augmentation.rs",
    "benches/parallel_kernels.rs",
    "benches/scheduler_locality.rs",
    "docs/benchmark-highlights.svg",
    "docs/parallel-scaling.svg",
    "docs/pipeline.svg",
    "evidence/benchmarks.json",
    "evidence/c985-c997-parity-binary-slack-symbreak.jsonl",
    "evidence/c985-c997-parity-cascaded-symbreak.jsonl",
    "evidence/c985-c997-parity-root-cuts-symbreak.jsonl",
    "evidence/c985-c997-optimal-support-orbits.json",
    "evidence/c985-c997-native-distance.jsonl",
    "evidence/c985-c997-native-cached-distance.jsonl",
    "evidence/c985-c997-native-parallel-distance.jsonl",
    "evidence/c985-c997-certify-scale-v3-t1.jsonl",
    "evidence/c985-c997-certify-scale-v3-t2.jsonl",
    "evidence/c985-c997-certify-scale-v3-t4.jsonl",
    "evidence/c985-c997-certify-scale-v3-t8.jsonl",
    "evidence/c985-c997-direct24-scale-v3-t1.jsonl",
    "evidence/c985-c997-direct24-scale-v3-t2.jsonl",
    "evidence/c985-c997-direct24-scale-v3-t4.jsonl",
    "evidence/c985-c997-direct24-scale-v3-t8.jsonl",
    "evidence/c985-c997-native-input.json",
    "evidence/c997-gurobi-13.0.2-global-seed1.jsonl",
    "evidence/c997-gurobi-13.0.2-per-logical-seed1.jsonl",
    "evidence/c997-gurobi-13.0.2-symbreak-seed1.jsonl",
    "evidence/c997-gurobi-13.0.2-symbreak-threads2-seed1.jsonl",
    "evidence/contextual-state-ab.json",
    "evidence/results.json",
    "examples/data/azure-repair-batch.json",
    "examples/data/ceph-repair.json",
    "examples/data/compose-gf4.json",
    "examples/data/compose.json",
    "examples/data/f4-scalar-separation.json",
    "examples/data/gpu-checkpoint-recovery.json",
    "examples/data/qc-ldpc-search.json",
    "examples/data/repair-dag.json",
    "examples/data/schedule.json",
    "examples/data/transfer-subspace.json",
    "examples/data/transfer-tower.json",
    "examples/data/vector-repair.json",
    "examples/gf27_balanced_dfs.rs",
    "examples/gf27_balanced_probe.rs",
    "examples/gf27_prefix_probe.rs",
    "proptest-regressions/scheduler.txt",
    "python/README.md",
    "python/analyze_c997_support_orbits.py",
    "python/benchmark_algorithms.py",
    "python/benchmark_python.py",
    "python/check_c997_parity_ab.py",
    "python/check_c997_native.py",
    "python/check_c997_gurobi.py",
    "python/generate_evidence.py",
    "python/generate_fixtures.py",
    "python/export_c997_native.py",
    "python/gf27_defect_cpsat.py",
    "python/run_c997_gurobi.py",
    "python/recovery_algorithms/__init__.py",
    "python/recovery_algorithms/balanced.py",
    "python/recovery_algorithms/costs.py",
    "python/recovery_algorithms/defect.py",
    "python/recovery_algorithms/design.py",
    "python/recovery_algorithms/finite.py",
    "python/recovery_algorithms/geometry.py",
    "python/recovery_algorithms/incidence.py",
    "python/recovery_algorithms/reliability.py",
    "python/recovery_algorithms/service.py",
    "python/recovery_algorithms/storage.py",
    "python/recovery_algorithms/transfers.py",
    "python/run_benchmarks.py",
    "python/summarize_contextual_ab.py",
    "python/test_algorithms.py",
    "python/verify_baseline_encodings.py",
    "src/applications.rs",
    "src/arena.rs",
    "src/balanced.rs",
    "src/bin/bench_kernels.rs",
    "src/bin/css_distance_native.rs",
    "src/bin/ergodis.rs",
    "src/bitset.rs",
    "src/composition.rs",
    "src/confinement.rs",
    "src/contextual.rs",
    "src/css_distance.rs",
    "src/defect.rs",
    "src/field.rs",
    "src/incidence.rs",
    "src/lib.rs",
    "src/matrix.rs",
    "src/orbit.rs",
    "src/orbit_compile.rs",
    "src/packed_ternary.rs",
    "src/projective.rs",
    "src/scheduler.rs",
    "src/span.rs",
    "src/transfer.rs",
    "src/witness.rs",
    "src/zdd.rs",
    "scripts/contextual-ab.sh",
    "scripts/contextual-memory-ab.sh",
    "tests/cli.rs",
    "tests/fixtures/python_span_cases.json",
    "tests/contextual_allocations.rs",
    "tests/python_parity.rs",
)


def _cyclic_map(n: int) -> LinearMap:
    columns = ((1, 0), (0, 1), (1, 1))
    return LinearMap(
        2,
        tuple(tuple(columns[j % 3][i] for j in range(n)) for i in range(2)),
    )


def operation_counts() -> list[dict[str, int]]:
    rows = []
    for n in (4, 8, 16, 32, 64):
        phi = _cyclic_map(n)
        compact = prescribed_coset_subspace_costs(phi)
        dynamic = compact.expand(2)
        simplified = simplify_projective_columns(phi)
        rows.append(
            {
                "coordinates": n,
                "projective_classes": simplified.domain_dim,
                "generated_spans": len(compact.generated_spans),
                "closure_transitions": compact.transitions,
                "direct_lifts": 2 ** (2 * n),
                "dp_transitions": dynamic.transitions,
                "reachable_labels": len(dynamic.costs),
            }
        )
    return rows


def scalar_noncomposition() -> dict[str, object]:
    a, b = (1, 0), (0, 1)
    fd_basis = (a + b, b + (1, 1))
    rows = []
    for name, phi_data in (
        ("I1", ((1, 1, 0), (0, 0, 1))),
        ("I2", ((1, 1, 1), (0, 0, 1))),
    ):
        full_phi = LinearMap(2, phi_data)
        helper_phi = LinearMap(2, tuple(row[1:] for row in phi_data))
        lam = prescribed_coset_costs(full_phi, 1)
        mu = translated_cost_table(
            prescribed_coset_costs(helper_phi, 1),
            tuple((row[0],) for row in phi_data),
        )
        result = exact_confinement_cost(fd_basis, 2, lam, mu, 0, 2)
        rows.append(
            {
                "code": name,
                "persistent_scalar": mu.get(((0,), (0,))) + 2,
                "exact_cost": result.cost,
                "winning_sector": result.sector,
            }
        )
    return {"field": 2, "codes": rows}


def syndrome_trellis_comparison() -> dict[str, object]:
    constraint = ((1,) * 8,)
    fd_basis = nullspace_basis(constraint, 2)
    lam = prescribed_coset_costs(LinearMap(2, ((1, 1),)), 2)
    mu = translated_cost_table(lam, ((1, 1),))
    enumerated = exact_confinement_cost(fd_basis, 8, lam, mu, 0, 2)
    blocks = tuple(((1,),) for _ in range(8))
    trellis = exact_confinement_cost_syndrome_dp(blocks, lam, mu, 0, 2)
    automatic = exact_confinement_cost_auto(fd_basis, 8, lam, mu, 0, 2)
    if (trellis.cost, trellis.sector) != (enumerated.cost, enumerated.sector):
        raise AssertionError("syndrome trellis disagrees with functional-dual enumeration")
    return {
        "field": 2,
        "blocks": 8,
        "demand_dimension": 2,
        "functional_dual_dimension": len(fd_basis),
        "exact_cost": trellis.cost,
        "winning_sector": trellis.sector,
        "functional_maps_enumerated": enumerated.transitions,
        "trellis_transitions": trellis.transitions,
        "automatic_method": automatic.method,
        "generator_candidate_bound": automatic.generator_candidate_bound,
        "syndrome_transition_bound": automatic.syndrome_transition_bound,
    }


def gf4_composition() -> dict[str, object]:
    one = extension_multiplication_matrix((1, 0), (1, 1, 1), 2)
    omega = extension_multiplication_matrix((0, 1), (1, 1, 1), 2)
    inner_phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
    dynamic = compose_cost_table((one, omega), prescribed_coset_costs(inner_phi, 2))
    span_dynamic = compose_prescribed_costs_via_spans((one, omega), inner_phi, 2)
    direct = prescribed_coset_costs_direct(
        direct_composite_map((one, omega), inner_phi), 2
    )
    if dynamic.costs != direct.costs or span_dynamic.costs != direct.costs:
        raise AssertionError("GF(4) composition cross-check failed")
    return {
        "base_field": 2,
        "extension_degree": 2,
        "demand_dimension": 2,
        "labels_checked": len(dynamic.costs),
        "dp_transitions": dynamic.transitions,
        "compose_first_span_transitions": span_dynamic.transitions,
        "direct_lifts": direct.transitions,
    }


def proportional_block_compression() -> dict[str, int]:
    inner_phi = LinearMap(3, ((1, 0), (0, 1)))
    inner = prescribed_coset_costs(inner_phi, 1)
    blocks = (
        ((1, 0), (0, 1)),
        ((2, 0), (0, 2)),
        ((0, 1), (1, 0)),
        ((0, 0), (0, 0)),
    )
    simplified = compose_cost_table(blocks, inner)
    unsimplified = compose_cost_table(blocks, inner, simplify_blocks=False)
    direct = prescribed_coset_costs_direct(
        direct_composite_map(blocks, inner_phi), 1
    )
    if simplified.costs != unsimplified.costs or simplified.costs != direct.costs:
        raise AssertionError("proportional-block compression changed the cost table")
    return {
        "field": 3,
        "outer_blocks": len(blocks),
        "effective_projective_blocks": 2,
        "compressed_transitions": simplified.transitions,
        "uncompressed_transitions": unsimplified.transitions,
        "direct_lifts": direct.transitions,
    }


def contraction_dominance() -> dict[str, int]:
    inner_phi = LinearMap(2, ((1, 0), (0, 1)))
    inner = prescribed_coset_costs(inner_phi, 1)
    blocks = (
        ((1, 0), (0, 1)),
        ((0, 1), (1, 0)),
        ((1, 0), (0, 0)),
    )
    simplified = compose_cost_table(blocks, inner, search_dominance=True)
    unsimplified = compose_cost_table(blocks, inner, simplify_blocks=False)
    direct = prescribed_coset_costs_direct(
        direct_composite_map(blocks, inner_phi), 1
    )
    if simplified.costs != unsimplified.costs or simplified.costs != direct.costs:
        raise AssertionError("contraction dominance changed the cost table")
    return {
        "field": 2,
        "linear_cost_contractions": len(cost_contractions(inner)),
        "outer_blocks": len(blocks),
        "retained_blocks": 1,
        "compressed_transitions": simplified.transitions,
        "uncompressed_transitions": unsimplified.transitions,
        "direct_lifts": direct.transitions,
    }


def presentation_search() -> dict[str, object]:
    result = coefficient_presentation_spectrum(
        (), ((1, 0, 0), (0, 1, 1)), 2
    )
    return {
        "field": 2,
        "helper_length": 3,
        "quotient_dimension": 2,
        "relative_weights": result.relative_weights,
        "identifications_checked": result.candidates,
        "distance_counts": result.distance_counts,
        "best_distance": result.best_distance,
        "best_thresholds": tuple(x + result.best_distance for x in result.relative_weights),
        "best_identification_count": len(result.best_identifications),
    }


def best_target_census() -> dict[str, object]:
    checked = 0
    presentations = 0
    for dimension, length in ((2, 5), (3, 5)):
        identity = tuple(
            tuple(int(i == j) for j in range(dimension))
            for i in range(dimension)
        )
        for tail in all_matrices(dimension, length - dimension, 2):
            presentations += 1
            basis = tuple(identity[i] + tail[i] for i in range(dimension))
            weights = relative_weights(basis, (), 2)
            for e in range(1, dimension + 1):
                best = min(
                    cooperative_helper_cost(basis, targets, 2)
                    for targets in combinations(range(length), e)
                )
                if best != weights[e - 1] - e:
                    raise AssertionError("best-target GHW identity failed")
                checked += 1
    return {
        "field": 2,
        "length": 5,
        "systematic_presentations": presentations,
        "code_rank_cases": checked,
    }


def reliability_checks() -> dict[str, object]:
    finite_cases = []
    for q, m in ((2, 2), (2, 3), (2, 4), (3, 2), (3, 3)):
        for t in range(1, m + 1):
            formula = projective_reliability_polynomial(q, m, t)
            direct = projective_reliability_direct(q, m, t)
            if formula != direct:
                raise AssertionError(f"reliability mismatch at {(q, m, t)}")
            finite_cases.append(
                {
                    "q": q,
                    "m": m,
                    "t": t,
                    "projective_points": projective_size(m, q),
                    "nonzero_power_terms": len(formula),
                }
            )
    large_examples = []
    for q, m, t in ((2, 8, 1), (2, 8, 4), (3, 6, 3), (5, 5, 2)):
        rank_bound = m - t
        formula_terms_before_collection = (rank_bound + 1) * (rank_bound + 2) // 2
        large_examples.append(
            {
                "q": q,
                "m": m,
                "t": t,
                "projective_points": projective_size(m, q),
                "direct_failure_subsets": 2 ** projective_size(m, q),
                "mobius_terms_before_collection": formula_terms_before_collection,
                "threshold": projective_threshold(q, m, t),
            }
        )
    return {
        "direct_crosschecks": finite_cases,
        "large_operation_comparisons": large_examples,
        "complete_profile_summands": [
            {
                "m": m,
                "shared_exact_span_summands": m * (m + 1) // 2,
                "separate_rank_summands": m * (m + 1) * (m + 2) // 6,
            }
            for m in (8, 16, 32, 64)
        ],
        "budget_inversion_example": {
            "q": 2,
            "m": 8,
            "budget": 240,
            "maximum_rank": maximum_recoverable_rank(2, 8, 240),
        },
    }


def service_reduction() -> dict[str, object]:
    inner = build_service_lp(
        (
            ((0, 2), (1, 2), (0, 1, 2)),
            ((1,), (1, 3)),
        ),
        4,
    )
    blocks = 1000
    extended = zero_extend_service_lp(
        inner, blocks * inner.helper_count, 488 * inner.helper_count
    )
    return {
        "blocks": blocks,
        "global_helper_coordinates": extended.helper_count,
        "inner_helper_coordinates": inner.helper_count,
        "active_helper_constraints": len(inner.active_helper_incidence),
        "stored_helper_rows_after_extension": len(extended.active_helper_incidence),
        "demands": inner.demand_count,
        "flow_variables": len(inner.variables),
        "implicit_zero_helper_rows": (
            extended.helper_count - len(extended.active_helper_incidence)
        ),
    }


def cross_paper_transfers() -> dict[str, object]:
    correction = collision_correction(
        range(12), ((0,), (1,), (1,), (3,), (), (3,), (7,), (), (9,))
    )
    core = delete_to_clique_free_core(
        range(7), ((0, 1, 2), (2, 3), (3, 4, 5), (1, 6))
    )
    repairs = maximum_distinct_repairs(
        (("a", "b"), ("a", "b"), ("a", "b"), ("c",))
    )
    separator = feature_separator(
        ((1, 0, 0),), ((0, 1, 0), (0, 0, 1)), 3, 2
    )
    components = replacement_graph_components(
        ({0, 1}, {0, 2}, {1, 2}, {7, 8}, {7, 9})
    )
    return {
        "collision_identity": {
            "candidates": correction.candidate_count,
            "obstructions": correction.obstruction_count,
            "legal": correction.legal_count,
            "invisible": correction.invisible_count,
            "redundancy": correction.redundancy,
        },
        "defect_core": {
            "items": 7,
            "bad_cliques": 4,
            "deleted": len(core.deleted),
            "edit_charge": core.edit_charge,
            "survivors": len(core.survivors),
        },
        "simultaneous_repair": {
            "demands": 4,
            "matched": len(repairs.assignment),
            "hall_left": len(repairs.hall_left),
            "hall_neighbors": len(repairs.hall_neighbors),
        },
        "feature_separator": {
            "field": 2,
            "coefficient_dimension": 3,
            "nullity": separator.nullity,
            "candidates_examined": separator.candidates_examined,
            "witness": separator.witness,
        },
        "replacement_graph": {
            "configurations": 5,
            "component_sizes": sorted(map(len, components)),
        },
    }


def storage_repair_checks() -> dict[str, object]:
    repetition_dual = ((1, 1, 0), (1, 0, 1))
    scalar_sets = scalar_recovery_sets_from_dual(repetition_dual, 0, 2)
    scalar_equations = scalar_recovery_equations_from_dual(
        ((1, 2, 0), (1, 0, 2)), 0, 3
    )
    weighted = maximum_weighted_parallel_repairs(
        (({0: 2},), ({0: 1},)), {0: 2}
    )
    unit = maximum_parallel_repairs((((0,),), ((0,),)), {0: 2})
    closure = earliest_repair_times(
        {2: ((0,),), 3: ((2,),), 4: ((2, 3),), 5: ((6,),)}, (0, 1)
    )
    schedule = minimum_round_repair_schedule(
        {2: ((0,),), 3: ((0,),), 4: ((2,),)},
        (0, 1),
        {0: 1, 1: 1, 2: 1, 3: 1, 4: 1},
    )
    generator = ((1, 0, 1), (0, 1, 1))
    joint_supports = linear_materialization_supports(
        generator, ((1, 0), (0, 1)), 2
    )
    triangle_pair_supports = linear_materialization_supports(
        ((1, 0, 0), (0, 1, 0), (0, 0, 1)),
        ((1, 1), (1, 2), (1, 3)),
        5,
    )
    triangle_pair_plans = linear_materialization_plans(
        ((1, 0, 0), (0, 1, 0), (0, 0, 1)),
        ((1, 1), (1, 2), (1, 3)),
        5,
    )
    replacement_families, candidate_capacities = materialized_replacement_families(
        ({"a": ((0,),), "b": ((1,),)}, {"a": ((2,),), "c": ((0,),)})
    )
    replacement = maximum_parallel_repairs(
        replacement_families,
        candidate_capacities
        | {("helper", 0): 1, ("helper", 1): 1, ("helper", 2): 1},
    )
    return {
        "dual_word_scalar_supports": scalar_sets,
        "normalized_scalar_equations": [
            {
                "support": equation.support,
                "coefficients": equation.coefficients,
            }
            for equation in scalar_equations
        ],
        "weighted_vs_unit_capacity": {
            "weighted_repairs": weighted.repaired_count,
            "unit_support_repairs": unit.repaired_count,
            "weighted_peak_pareto_states": weighted.peak_pareto_states,
        },
        "regenerative_closure": {
            "arrival_times": closure.arrival_times,
            "unreachable": closure.unreachable,
        },
        "minimum_round_schedule": {
            "rounds": schedule.rounds,
            "round_count": len(schedule.rounds),
            "states_examined": schedule.states_examined,
        },
        "joint_materialization": {
            "desired_columns": 2,
            "minimal_supports": joint_supports,
            "empty_carrier_triangle_example": {
                "field": 5,
                "minimal_supports": triangle_pair_supports,
                "exact_joint_access": min(map(len, triangle_pair_supports)),
                "coefficient_plans": [
                    {
                        "support": plan.support,
                        "coefficients": plan.coefficients,
                    }
                    for plan in triangle_pair_plans
                ],
            },
        },
        "materialized_distinct_replacements": {
            "demands": 2,
            "repaired": replacement.repaired_count,
            "complete": replacement.complete,
        },
        "robust_functional_repair_plan_bounds": {
            "residual_eight_s_ge_7": {
                "alternate_pairs": 318,
                "helper_triples_per_pair": 56,
                "plans": 318 * 56,
            },
            "residual_eight_q25": {
                "alternate_pairs": 3,
                "helper_triples_per_pair": 56,
                "plans": 3 * 56,
            },
            "clebsch_residual_six": {
                "alternate_pairs": 4179,
                "helper_triples_per_pair": 20,
                "plans": 4179 * 20,
            },
        },
    }


def incidence_search_checks() -> dict[str, object]:
    threshold = bounded_threshold_coefficients(5, 3)
    families = tuple(
        (
            OrbitOption(f"{orbit}:zero", (0, 0), (0, 0)),
            OrbitOption(f"{orbit}:positive", (1, orbit % 3), (1, 0)),
            OrbitOption(f"{orbit}:negative", (2, (-orbit) % 3), (1, 1)),
        )
        for orbit in range(4)
    )
    orbit_search = ternary_orbit_syndrome_search(families, (0, 2), (2, 1))
    if not orbit_search.feasible:
        raise AssertionError("known sparse orbit assignment was not recovered")
    profile = signed_incidence_profile(
        ((0, 1), (0, 2), (1, 2, 3), (2, 3)), (1, -1, -1, 1)
    )
    if not profile.support_constraints_hold:
        raise AssertionError("known signed support failed its incidence constraints")
    return {
        "bounded_threshold": {
            "alphabet": list(range(6)),
            "threshold": 3,
            "binomial_coefficients": threshold,
            "evaluations": [
                evaluate_binomial_polynomial(threshold, value) for value in range(6)
            ],
        },
        "ternary_orbit_search": {
            "orbits": len(families),
            "target_residue": (0, 2),
            "target_totals": (2, 1),
            "choices": orbit_search.choices,
            "states_examined": orbit_search.states_examined,
            "bound_prunes": orbit_search.bound_prunes,
            "residue_prunes": orbit_search.residue_prunes,
            "memo_prunes": orbit_search.memo_prunes,
        },
        "signed_incidence": {
            "degrees": profile.degrees,
            "signed_sums": profile.signed_sums,
            "support_constraints_hold": profile.support_constraints_hold,
        },
    }


def hierarchical_witness_checks() -> dict[str, object]:
    phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
    inner = prescribed_coset_costs(phi, 1)
    target = ((1,), (1,))
    leaf = inner.witness_for(target)
    if leaf is None or mat_mul(phi.data, leaf.lift, 2) != target:
        raise AssertionError("prescribed-coset witness replay failed")
    if not verify_leaf_witness(phi, leaf).valid:
        raise AssertionError("independent leaf verifier rejected a valid witness")

    blocks = (((1, 0), (0, 1)), ((0, 1), (1, 1)))
    composite = compose_cost_table_with_witnesses(blocks, inner)
    composite_target = ((1,), (0,))
    hierarchy = composite.witness_for(composite_target)
    if hierarchy is None:
        raise AssertionError("hierarchical witness is unexpectedly absent")
    replay = zero_matrix(2, 1)
    for block, label in zip(blocks, hierarchy.local_labels):
        replay = mat_add(replay, mat_mul(block, label, 2), 2)
    if replay != composite_target or sum(child.cost for child in hierarchy.children) != hierarchy.cost:
        raise AssertionError("hierarchical composition witness replay failed")
    if not verify_composition_witness(blocks, hierarchy, 2).valid:
        raise AssertionError("independent composition verifier rejected a valid witness")
    helper_loads = hierarchical_helper_loads(hierarchy)
    if sum(amount for _, amount in helper_loads) != hierarchy.cost:
        raise AssertionError("hierarchical helper loads disagree with witness cost")

    normalized = target_normalized_composition_with_witness(
        (((1,),), ((1,),)),
        (prescribed_coset_costs(LinearMap(2, ((1,),)), 1),) * 2,
        (((1,),), ((1,),)),
        ((1,),),
        ((0,),),
    )
    if sum(witness.cost for witness in normalized.local_witnesses) != normalized.cost:
        raise AssertionError("target-normalized witness cost failed to replay")
    return {
        "prescribed_coset": {
            "target": target,
            "cost": leaf.cost,
            "support": leaf.support,
            "lift": leaf.lift,
        },
        "hierarchical_composition": {
            "target": composite_target,
            "cost": hierarchy.cost,
            "local_labels": hierarchy.local_labels,
            "child_supports": [child.support for child in hierarchy.children],
            "helper_loads": helper_loads,
        },
        "target_normalized": {
            "cost": normalized.cost,
            "target_images": normalized.target_images,
            "local_labels": normalized.local_labels,
            "child_supports": [
                witness.support for witness in normalized.local_witnesses
            ],
        },
    }


def gf27_defect_shell() -> dict[str, object]:
    internal_counts = [
        sum(
            1
            for _ in convex_shell_histograms(
                point_count=279,
                degree_sum=1_026,
                center=3,
                minimum_degree=0,
                maximum_degree=28,
                defect=defect,
            )
        )
        for defect in range(20)
    ]
    external_counts = [
        sum(
            1
            for _ in convex_shell_histograms(
                point_count=478,
                degree_sum=486,
                center=1,
                minimum_degree=1,
                maximum_degree=28,
                defect=defect,
            )
        )
        for defect in range(20)
    ]
    centered_spectra = gf27_q27_t54_centered_spectra()
    centered_supports = [757 - spectrum[6] for spectrum in centered_spectra]
    combined_tails = set()
    for internal, external_from_one in gf27_q27_t54_histogram_pairs():
        external = (0,) + external_from_one
        counts = tuple(internal[degree] + external[degree] for degree in range(10))
        combined_tails.add(
            tuple(sum(counts[degree:]) for degree in range(len(counts)))
        )
    maximum_tails = [
        max(profile[degree] for profile in combined_tails) for degree in range(10)
    ]
    threshold_records = sum(maximum + 2 for maximum in maximum_tails)
    return {
        "field_order": 27,
        "maximal_secants": 54,
        "total_defect": 19,
        "internal_histograms_by_defect": internal_counts,
        "external_histograms_by_defect": external_counts,
        "compatible_histogram_pairs": sum(
            internal_counts[defect] * external_counts[19 - defect]
            for defect in range(20)
        ),
        "distinct_centered_spectra": len(centered_spectra),
        "centered_support_range": [min(centered_supports), max(centered_supports)],
        "distinct_combined_degree_profiles": len(combined_tails),
        "packed_degree_profile_bytes": 32 * len(combined_tails),
        "threshold_bitmap_bytes": 2 * threshold_records * 16 * 8,
    }


def build_results() -> dict[str, object]:
    return {
        "schema": "ergodis-evidence-v4",
        "arithmetic": "exact prime-field and integer arithmetic",
        "deterministic": True,
        "prescribed_coset_operation_counts": operation_counts(),
        "gf4_composition_crosscheck": gf4_composition(),
        "hierarchical_witnesses": hierarchical_witness_checks(),
        "proportional_block_compression": proportional_block_compression(),
        "contraction_dominance": contraction_dominance(),
        "scalar_noncomposition": scalar_noncomposition(),
        "syndrome_trellis_comparison": syndrome_trellis_comparison(),
        "coefficient_presentation_search": presentation_search(),
        "best_target_identity_census": best_target_census(),
        "projective_reliability": reliability_checks(),
        "service_lp_reduction": service_reduction(),
        "cross_paper_transfers": cross_paper_transfers(),
        "incidence_search": incidence_search_checks(),
        "storage_repair": storage_repair_checks(),
        "gf27_q27_t54_defect_shell": gf27_defect_shell(),
        "gf27_q27_balanced_transversal": q27_balanced_transversal_oracle(),
    }


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def checksum_manifest() -> bytes:
    rows = []
    for relative in HASHED_PATHS:
        payload = (ROOT / relative).read_bytes()
        rows.append(f"{hashlib.sha256(payload).hexdigest()}  {relative}\n")
    return "".join(rows).encode()


def write() -> None:
    RESULTS.parent.mkdir(exist_ok=True)
    RESULTS.write_bytes(canonical_bytes(build_results()))
    CHECKSUMS.write_bytes(checksum_manifest())


def check() -> None:
    expected_results = canonical_bytes(build_results())
    if not RESULTS.exists() or RESULTS.read_bytes() != expected_results:
        raise SystemExit(
            "evidence/results.json is stale; run python/generate_evidence.py --write"
        )
    expected_checksums = checksum_manifest()
    if not CHECKSUMS.exists() or CHECKSUMS.read_bytes() != expected_checksums:
        raise SystemExit("SHA256SUMS is stale; run python/generate_evidence.py --write")


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    write() if args.write else check()


if __name__ == "__main__":
    main()
