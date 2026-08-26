#!/usr/bin/env python3
"""Independent and theorem-level tests for the recovery algorithms."""

from __future__ import annotations

import json
import unittest
from itertools import combinations, product
from pathlib import Path

from recovery_algorithms.costs import (
    INF,
    compose_cost_table,
    compose_cost_table_with_witnesses,
    compose_prescribed_costs_via_spans,
    cost_contractions,
    direct_composite_map,
    exact_confinement_cost,
    exact_confinement_cost_auto,
    exact_confinement_cost_syndrome_dp,
    hierarchical_helper_loads,
    iterated_envelope,
    outer_block_cost_table,
    prescribed_coset_costs,
    prescribed_coset_witness,
    prescribed_coset_costs_direct,
    prescribed_coset_costs_row_dp,
    prescribed_coset_subspace_costs,
    simplify_projective_columns,
    simplify_dominated_blocks,
    sharp_composition_envelope,
    target_normalized_composition,
    target_normalized_composition_with_witness,
    translated_cost_table,
    verify_composition_witness,
    verify_leaf_witness,
)
from recovery_algorithms.balanced import (
    q27_balanced_transversal_oracle,
    q27_balanced_carrier_affine_rank,
    q27_carrier_from_high_cells,
    q27_high_fiber_from_carrier,
    q27_reconstruct_carrier_from_fibers,
    q27_search_high_fiber_candidates,
    q27_unmarked_pair_local_ranks,
)
from recovery_algorithms.design import (
    all_invertible_matrices,
    coefficient_presentation_spectrum,
    cooperative_helper_cost,
    relative_profile,
    relative_weights,
)
from recovery_algorithms.defect import (
    gf27_q27_t54_centered_spectra,
    gf27_q27_t54_histogram_pairs,
    convex_shell_histograms,
)
from recovery_algorithms.finite import (
    LinearMap,
    all_matrices,
    binary_rank_masks,
    column_block,
    extension_multiplication_matrix,
    flatten,
    mat_add,
    mat_mul,
    matrix_rank,
    nullspace_basis,
    row_support_size,
    shape,
    zero_matrix,
)
from recovery_algorithms.incidence import (
    OrbitOption,
    TernaryAffineObstruction,
    TernaryAffineProblem,
    add_packed_ternary,
    binomial_basis_coefficients,
    bounded_threshold_coefficients,
    compile_ternary_affine_constraints,
    evaluate_binomial_polynomial,
    pack_ternary,
    signed_incidence_profile,
    signed_incidence_profile_masks,
    ternary_orbit_syndrome_search,
    unpack_ternary,
)
from recovery_algorithms.geometry import TernaryExtensionField, ternary_projective_plane
from recovery_algorithms.reliability import (
    all_rank_reliability_polynomials,
    evaluate_polynomial,
    maximum_recoverable_rank,
    projective_reliability_direct,
    projective_reliability_polynomial,
    projective_threshold,
)
from recovery_algorithms.service import (
    build_service_lp,
    inclusion_minimal,
    zero_extend_service_lp,
)
from recovery_algorithms.transfers import (
    collision_correction,
    delete_to_clique_free_core,
    feature_separator,
    maximum_distinct_repairs,
    replacement_graph_components,
)
from recovery_algorithms.storage import (
    earliest_repair_times,
    linear_materialization_plans,
    linear_materialization_supports,
    materialized_replacement_families,
    maximum_parallel_repairs,
    maximum_weighted_parallel_repairs,
    minimum_round_repair_schedule,
    recovery_families_from_dual,
    scalar_recovery_sets_from_dual,
    scalar_recovery_equations_from_dual,
)


class PrescribedCosetTests(unittest.TestCase):
    def test_dynamic_program_matches_all_lifts(self) -> None:
        checked = 0
        for k, n, t in ((1, 4, 2), (2, 3, 1), (2, 3, 2)):
            for data in all_matrices(k, n, 2):
                phi = LinearMap(2, data)
                dynamic = prescribed_coset_costs(phi, t)
                row_dynamic = prescribed_coset_costs_row_dp(phi, t)
                direct = prescribed_coset_costs_direct(phi, t)
                self.assertEqual(dynamic.costs, direct.costs)
                self.assertEqual(dynamic.costs, row_dynamic.costs)
                checked += 1
        self.assertEqual(checked, 16 + 64 + 64)

    def test_composition_matches_direct_composite(self) -> None:
        inner_phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
        inner = prescribed_coset_costs(inner_phi, 2)
        outer_blocks = (
            ((1, 0), (0, 1)),
            ((0, 1), (1, 1)),
        )
        composed = compose_cost_table(outer_blocks, inner)
        direct_phi = direct_composite_map(outer_blocks, inner_phi)
        direct = prescribed_coset_costs_direct(direct_phi, 2)
        self.assertEqual(composed.costs, direct.costs)
        span_composed = compose_prescribed_costs_via_spans(
            outer_blocks, inner_phi, 2
        )
        self.assertEqual(span_composed.costs, direct.costs)
        self.assertLess(span_composed.transitions, composed.transitions)

    def test_genuine_gf4_multiplication_blocks(self) -> None:
        # In basis (1,w), w^2=w+1, these are multiplication by 1 and w.
        one = extension_multiplication_matrix((1, 0), (1, 1, 1), 2)
        omega = extension_multiplication_matrix((0, 1), (1, 1, 1), 2)
        self.assertEqual(one, ((1, 0), (0, 1)))
        self.assertEqual(omega, ((0, 1), (1, 1)))
        inner_phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
        dynamic = compose_cost_table((one, omega), prescribed_coset_costs(inner_phi, 1))
        direct = prescribed_coset_costs_direct(
            direct_composite_map((one, omega), inner_phi), 1
        )
        self.assertEqual(dynamic.costs, direct.costs)

    def test_gf9_multiplication_blocks(self) -> None:
        omega = extension_multiplication_matrix((0, 1), (1, 0, 1), 3)
        self.assertEqual(omega, ((0, 2), (1, 0)))
        self.assertEqual(mat_mul(omega, omega, 3), ((2, 0), (0, 2)))

    def test_associativity(self) -> None:
        inner_phi = LinearMap(2, ((1, 1),))
        inner = prescribed_coset_costs(inner_phi, 2)
        middle = (((1,),), ((1,),))
        outer = (((1,),), ((1,),))
        left = compose_cost_table(outer, compose_cost_table(middle, inner))
        flattened = tuple(
            mat_mul(outer_block, middle_block, 2)
            for outer_block in outer
            for middle_block in middle
        )
        right = compose_cost_table(flattened, inner)
        self.assertEqual(left.costs, right.costs)

    def test_proportional_outer_blocks_are_redundant(self) -> None:
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
        self.assertEqual(simplified.costs, unsimplified.costs)
        self.assertEqual(simplified.costs, direct.costs)
        self.assertLess(simplified.transitions, unsimplified.transitions)

    def test_cost_contraction_block_dominance(self) -> None:
        inner_phi = LinearMap(2, ((1, 0), (0, 1)))
        inner = prescribed_coset_costs(inner_phi, 1)
        identity = ((1, 0), (0, 1))
        swap = ((0, 1), (1, 0))
        projection = ((1, 0), (0, 0))
        contractions = cost_contractions(inner)
        self.assertIn(swap, contractions)
        self.assertIn(projection, contractions)
        blocks = (identity, swap, projection)
        self.assertEqual(simplify_dominated_blocks(blocks, inner), (identity,))
        simplified = compose_cost_table(blocks, inner, search_dominance=True)
        unsimplified = compose_cost_table(blocks, inner, simplify_blocks=False)
        direct = prescribed_coset_costs_direct(
            direct_composite_map(blocks, inner_phi), 1
        )
        self.assertEqual(simplified.costs, unsimplified.costs)
        self.assertEqual(simplified.costs, direct.costs)
        self.assertLess(simplified.transitions, unsimplified.transitions)

    def test_sharp_envelope_and_iteration(self) -> None:
        inner_phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
        inner = prescribed_coset_costs(inner_phi, 1)
        outer_blocks = (((1, 0),), ((0, 1),), ((1, 1),))
        composed, outer, delta, radius = sharp_composition_envelope(outer_blocks, inner)
        identity_outer = outer_block_cost_table(
            (((1, 0), (0, 1)),), 1, 2
        )
        self.assertEqual(identity_outer.get(((1,), (1,))), 1)
        for key, value in composed.costs.items():
            if any(key):
                outer_value = outer.costs[key]
                self.assertLessEqual(delta * outer_value, value)
                self.assertLessEqual(value, radius * outer_value)
        self.assertEqual(iterated_envelope(((2, 3), (1, 4), (2, 2))), (4, 24))

    def test_dp_operation_advantage(self) -> None:
        phi = LinearMap(2, ((1,) * 8, (0, 1, 0, 1, 1, 0, 1, 0)))
        dynamic = prescribed_coset_costs(phi, 2)
        direct = prescribed_coset_costs_direct(phi, 2)
        self.assertEqual(dynamic.costs, direct.costs)
        self.assertLess(dynamic.transitions, direct.transitions // 20)

    def test_projective_column_simplification(self) -> None:
        phi = LinearMap(
            3,
            (
                (0, 1, 2, 0, 1, 2, 1),
                (0, 0, 0, 1, 1, 2, 2),
            ),
        )
        simplified = simplify_projective_columns(phi)
        self.assertEqual(simplified.data, ((1, 0, 1, 1), (0, 1, 1, 2)))
        compressed = prescribed_coset_costs(phi, 1)
        uncompressed = prescribed_coset_costs_row_dp(
            phi, 1, simplify_columns=False
        )
        direct = prescribed_coset_costs_direct(phi, 1)
        self.assertEqual(compressed.costs, uncompressed.costs)
        self.assertEqual(compressed.costs, direct.costs)
        self.assertLess(compressed.transitions, uncompressed.transitions)

    def test_cost_depends_only_on_target_image_subspace(self) -> None:
        phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
        compact = prescribed_coset_subspace_costs(phi)
        first = ((1, 0), (1, 1))
        same_image = ((1, 1), (0, 1))
        self.assertEqual(compact.get(first), compact.get(same_image))
        self.assertEqual(compact.get(first), prescribed_coset_costs(phi, 2).get(first))

    def test_ternary_dynamic_program_matches_all_lifts(self) -> None:
        for data in all_matrices(1, 3, 3):
            phi = LinearMap(3, data)
            self.assertEqual(
                prescribed_coset_costs(phi, 2).costs,
                prescribed_coset_costs_direct(phi, 2).costs,
            )


class TargetAndConfinementTests(unittest.TestCase):
    def test_prescribed_coset_witnesses_replay_exhaustively(self) -> None:
        checked = 0
        for data in all_matrices(2, 3, 2):
            phi = LinearMap(2, data)
            table = prescribed_coset_costs(phi, 2)
            for target in all_matrices(2, 2, 2):
                witness = prescribed_coset_witness(phi, target)
                self.assertEqual(witness is not None, table.get(target) < INF)
                if witness is None:
                    continue
                self.assertEqual(witness, table.witness_for(target))
                self.assertEqual(mat_mul(phi.data, witness.lift, 2), target)
                self.assertEqual(row_support_size(witness.lift), witness.cost)
                self.assertEqual(witness.cost, table.get(target))
                self.assertTrue(verify_leaf_witness(phi, witness).valid)
                checked += 1
        self.assertGreater(checked, 0)

    def test_ternary_projective_rescaling_witness(self) -> None:
        phi = LinearMap(3, ((2, 0, 2), (0, 2, 2)))
        target = ((1, 0), (0, 1))
        table = prescribed_coset_costs(phi, 2)
        witness = table.witness_for(target)
        self.assertIsNotNone(witness)
        self.assertEqual(mat_mul(phi.data, witness.lift, 3), target)
        self.assertEqual(row_support_size(witness.lift), table.get(target))

    def test_hierarchical_composition_witness_replays(self) -> None:
        phi = LinearMap(2, ((1, 0, 1), (0, 1, 1)))
        inner = prescribed_coset_costs(phi, 2)
        blocks = (((1, 0), (0, 1)), ((0, 1), (1, 1)))
        witnessed = compose_cost_table_with_witnesses(blocks, inner)
        direct = prescribed_coset_costs_direct(direct_composite_map(blocks, phi), 2)
        self.assertEqual(witnessed.costs, direct.costs)
        for key, cost in witnessed.costs.items():
            label = witnessed.matrix_for(key)
            witness = witnessed.witness_for(label)
            self.assertEqual(witness.cost, cost)
            self.assertEqual(len(witness.children), len(blocks))
            replay = zero_matrix(2, 2)
            for block, local_label, child in zip(
                blocks, witness.local_labels, witness.children
            ):
                self.assertEqual(child.label, local_label)
                self.assertEqual(mat_mul(phi.data, child.lift, 2), local_label)
                replay = mat_add(replay, mat_mul(block, local_label, 2), 2)
            self.assertEqual(replay, label)
            self.assertEqual(sum(child.cost for child in witness.children), cost)
            self.assertTrue(verify_composition_witness(blocks, witness, 2).valid)
            self.assertEqual(
                sum(amount for _, amount in hierarchical_helper_loads(witness)),
                cost,
            )
        nested = compose_cost_table_with_witnesses(
            (((1, 0), (0, 1)),), witnessed
        )
        nested_witness = nested.witness_for(((1, 0), (0, 0)))
        self.assertEqual(len(nested_witness.children), 1)
        self.assertEqual(len(nested_witness.children[0].children), len(blocks))
        self.assertTrue(
            verify_composition_witness((((1, 0), (0, 1)),), nested_witness, 2).valid
        )
        corrupted = type(nested_witness)(
            nested_witness.label,
            nested_witness.cost + 1,
            nested_witness.support,
            nested_witness.lift,
            nested_witness.local_labels,
            nested_witness.children,
        )
        self.assertEqual(
            verify_composition_witness(
                (((1, 0), (0, 1)),), corrupted, 2
            ).errors,
            ("cost",),
        )

    def test_target_normalized_composition_matches_raw_enumeration(self) -> None:
        p = 2
        blocks = (((1,),), ((1,),))
        helper_phi = LinearMap(p, ((1,),))
        helpers = (prescribed_coset_costs(helper_phi, 1),) * 2
        images = (((1,),), ((1,),))
        for prescribed_scalar in range(2):
            prescribed = ((prescribed_scalar,),)
            structured, _ = target_normalized_composition(
                blocks, helpers, images, ((1,),), prescribed
            )
            brute = INF
            for a0, a1, y0, y1 in product(range(2), repeat=4):
                if (a0 + a1) % 2 != 1:
                    continue
                if (a0 + y0 + a1 + y1) % 2 != prescribed_scalar:
                    continue
                brute = min(brute, int(y0 != 0) + int(y1 != 0))
            self.assertEqual(structured, brute)

    def test_target_normalized_witness_replays(self) -> None:
        blocks = (((1,),), ((1,),))
        helpers = (prescribed_coset_costs(LinearMap(2, ((1,),)), 1),) * 2
        images = (((1,),), ((1,),))
        result = target_normalized_composition_with_witness(
            blocks, helpers, images, ((1,),), ((0,),)
        )
        normalization = zero_matrix(1, 1)
        prescribed = zero_matrix(1, 1)
        for block, target_image, local_label, witness in zip(
            blocks,
            result.target_images,
            result.local_labels,
            result.local_witnesses,
        ):
            self.assertEqual(witness.label, local_label)
            normalization = mat_add(
                normalization, mat_mul(block, target_image, 2), 2
            )
            prescribed = mat_add(
                prescribed,
                mat_mul(block, mat_add(target_image, local_label, 2), 2),
                2,
            )
        self.assertEqual(normalization, ((1,),))
        self.assertEqual(prescribed, ((0,),))
        self.assertEqual(sum(witness.cost for witness in result.local_witnesses), result.cost)

    def test_ternary_target_normalized_composition(self) -> None:
        blocks = (((1,),), ((2,),))
        helpers = (prescribed_coset_costs(LinearMap(3, ((1,),)), 1),) * 2
        images = (((1,),), ((1,),))
        for prescribed_scalar in range(3):
            structured, _ = target_normalized_composition(
                blocks, helpers, images, ((1,),), ((prescribed_scalar,),)
            )
            brute = INF
            for a0, a1, y0, y1 in product(range(3), repeat=4):
                if (a0 + 2 * a1) % 3 != 1:
                    continue
                if (a0 + y0 + 2 * (a1 + y1)) % 3 != prescribed_scalar:
                    continue
                brute = min(brute, int(y0 != 0) + int(y1 != 0))
            self.assertEqual(structured, brute)

    def test_dependent_target_image_generators_are_compressed(self) -> None:
        helper = prescribed_coset_costs(LinearMap(2, ((1,),)), 1)
        canonical = target_normalized_composition(
            (((1,),),), (helper,), (((1,),),), ((1,),), ((1,),)
        )
        dependent = target_normalized_composition(
            (((1,),),), (helper,), (((1, 1),),), ((1,),), ((1,),)
        )
        self.assertEqual(canonical[0], dependent[0])
        self.assertEqual(canonical[1], dependent[1])
        self.assertEqual(dependent[1], 4)

    def test_scalar_threshold_noncomposition_example(self) -> None:
        a, b = (1, 0), (0, 1)
        fd_basis = (a + b, b + (1, 1))
        costs = []
        for phi_data in (
            ((1, 1, 0), (0, 0, 1)),
            ((1, 1, 1), (0, 0, 1)),
        ):
            full_phi = LinearMap(2, phi_data)
            helper_phi = LinearMap(2, tuple(row[1:] for row in phi_data))
            lam = prescribed_coset_costs(full_phi, 1)
            helper = prescribed_coset_costs(helper_phi, 1)
            target = tuple((row[0],) for row in phi_data)
            mu = translated_cost_table(helper, target)
            result = exact_confinement_cost(fd_basis, 2, lam, mu, 0, 2)
            costs.append(result.cost)
        self.assertEqual(costs, [1, 2])

    def test_rank_one_restriction_never_increases_union_support(self) -> None:
        for lift in all_matrices(5, 3, 2):
            if not any(any(row) for row in lift):
                continue
            union = row_support_size(lift)
            nonzero_columns = [j for j in range(3) if any(row[j] for row in lift)]
            self.assertTrue(nonzero_columns)
            for j in nonzero_columns:
                restricted = tuple((row[j],) for row in lift)
                self.assertLessEqual(row_support_size(restricted), union)

    def test_syndrome_dp_matches_functional_dual_enumeration(self) -> None:
        full_phi = LinearMap(2, ((1, 1, 0), (0, 0, 1)))
        helper_phi = LinearMap(2, ((1, 0), (0, 1)))
        for demand_dim in (1, 2):
            lam = prescribed_coset_costs(full_phi, demand_dim)
            target = ((1,) * demand_dim, (0,) * demand_dim)
            mu = translated_cost_table(
                prescribed_coset_costs(helper_phi, demand_dim), target
            )
            fd_basis = ((1, 0, 0, 1), (0, 1, 1, 1))
            constraints = nullspace_basis(fd_basis, 2)
            blocks = tuple(column_block(constraints, 2 * h, 2) for h in range(2))
            enumerated = exact_confinement_cost(fd_basis, 2, lam, mu, 0, 2)
            trellis = exact_confinement_cost_syndrome_dp(blocks, lam, mu, 0, 2)
            self.assertEqual(trellis.cost, enumerated.cost)
            self.assertEqual(trellis.sector, enumerated.sector)
            if enumerated.sector == "nonzero":
                self.assertTrue(enumerated.witness_complete)
                self.assertTrue(trellis.witness_complete)
                self.assertEqual(len(enumerated.block_labels), 2)
                self.assertEqual(len(trellis.block_labels), 2)
                for result in (enumerated, trellis):
                    syndrome = zero_matrix(len(constraints), demand_dim)
                    for constraint, label in zip(blocks, result.block_labels):
                        syndrome = mat_add(
                            syndrome, mat_mul(constraint, label, 2), 2
                        )
                    self.assertEqual(syndrome, zero_matrix(len(constraints), demand_dim))
                    self.assertEqual(
                        sum(witness.cost for witness in result.block_witnesses),
                        result.cost,
                    )

    def test_syndrome_dp_exhaustive_small_functional_duals(self) -> None:
        lam = prescribed_coset_costs(LinearMap(2, ((1, 1),)), 1)
        mu = translated_cost_table(lam, ((1,),))
        nonzero = tuple(v for v in product(range(2), repeat=3) if any(v))
        checked = 0
        for dimension in (1, 2):
            for rows in product(nonzero, repeat=dimension):
                if matrix_rank(rows, 2) != dimension:
                    continue
                constraints = nullspace_basis(rows, 2)
                blocks = tuple(column_block(constraints, h, 1) for h in range(3))
                enumerated = exact_confinement_cost(rows, 3, lam, mu, 0, 2)
                trellis = exact_confinement_cost_syndrome_dp(blocks, lam, mu, 0, 2)
                self.assertEqual(trellis.cost, enumerated.cost)
                self.assertEqual(trellis.sector, enumerated.sector)
                checked += 1
        self.assertEqual(checked, 7 + 42)

    def test_syndrome_dp_operation_advantage(self) -> None:
        constraint = ((1,) * 8,)
        fd_basis = nullspace_basis(constraint, 2)
        lam = prescribed_coset_costs(LinearMap(2, ((1, 1),)), 2)
        mu = translated_cost_table(lam, ((1, 1),))
        enumerated = exact_confinement_cost(fd_basis, 8, lam, mu, 0, 2)
        blocks = tuple(((1,),) for _ in range(8))
        trellis = exact_confinement_cost_syndrome_dp(blocks, lam, mu, 0, 2)
        self.assertEqual(trellis.cost, enumerated.cost)
        self.assertLess(trellis.transitions * 50, enumerated.transitions)
        automatic = exact_confinement_cost_auto(fd_basis, 8, lam, mu, 0, 2)
        self.assertEqual(automatic.method, "syndrome")
        self.assertEqual(automatic.result.cost, enumerated.cost)

    def test_redundant_syndrome_rows_are_compressed(self) -> None:
        lam = prescribed_coset_costs(LinearMap(2, ((1, 1),)), 1)
        mu = translated_cost_table(lam, ((1,),))
        minimal = exact_confinement_cost_syndrome_dp(
            (((1,),), ((1,),)), lam, mu, 0, 2
        )
        redundant = exact_confinement_cost_syndrome_dp(
            (((1,), (1,)), ((1,), (1,))), lam, mu, 0, 2
        )
        self.assertEqual((minimal.cost, minimal.sector), (redundant.cost, redundant.sector))
        self.assertEqual(minimal.transitions, redundant.transitions)

    def test_auto_planner_selects_generator_for_small_dual(self) -> None:
        lam = prescribed_coset_costs(LinearMap(2, ((1, 1),)), 1)
        mu = translated_cost_table(lam, ((1,),))
        fd_basis = ((1, 1, 1),)
        automatic = exact_confinement_cost_auto(fd_basis, 3, lam, mu, 0, 2)
        direct = exact_confinement_cost(fd_basis, 3, lam, mu, 0, 2)
        self.assertEqual(automatic.method, "generator")
        self.assertEqual(automatic.result.cost, direct.cost)


class RelativeWeightAndDesignTests(unittest.TestCase):
    def test_incremental_general_linear_enumeration(self) -> None:
        self.assertEqual(sum(1 for _ in all_invertible_matrices(3, 2)), 168)
        self.assertEqual(sum(1 for _ in all_invertible_matrices(2, 3)), 48)

    def test_relative_profile_and_weights(self) -> None:
        d_basis = ((1, 0, 0), (0, 1, 1))
        self.assertEqual(relative_profile(d_basis, (), 2), (0, 1, 1, 2))
        self.assertEqual(relative_weights(d_basis, (), 2), (1, 3))

    def test_coefficient_presentation_search_recovers_separation(self) -> None:
        spectrum = coefficient_presentation_spectrum(
            (), ((1, 0, 0), (0, 1, 1)), 2
        )
        self.assertEqual(spectrum.relative_weights, (1, 3))
        self.assertEqual(sum(count for _, count in spectrum.distance_counts), 6)
        self.assertEqual({distance for distance, _ in spectrum.distance_counts}, {2, 3})
        self.assertEqual(spectrum.best_distance, 3)
        self.assertEqual(
            tuple(weight + spectrum.best_distance for weight in spectrum.relative_weights),
            (4, 6),
        )

    def test_best_target_generalized_weight_identity_exhaustively(self) -> None:
        checked = 0
        for dimension, length in ((2, 5), (3, 5)):
            identity = tuple(
                tuple(int(i == j) for j in range(dimension))
                for i in range(dimension)
            )
            for tail in all_matrices(dimension, length - dimension, 2):
                basis = tuple(identity[i] + tail[i] for i in range(dimension))
                weights = relative_weights(basis, (), 2)
                for e in range(1, dimension + 1):
                    best = min(
                        cooperative_helper_cost(basis, targets, 2)
                        for targets in combinations(range(length), e)
                    )
                    self.assertEqual(best, weights[e - 1] - e)
                    checked += 1
        self.assertEqual(checked, 64 * 2 + 64 * 3)


class ProjectiveReliabilityTests(unittest.TestCase):
    def test_packed_binary_rank_matches_matrix_rank(self) -> None:
        for rows in range(1, 5):
            for packed in product(range(16), repeat=rows):
                unpacked = tuple(
                    tuple(mask >> coordinate & 1 for coordinate in range(4))
                    for mask in packed
                )
                self.assertEqual(binary_rank_masks(packed), matrix_rank(unpacked, 2))

    def test_mobius_formula_matches_subset_enumeration(self) -> None:
        checked = 0
        for q, m in ((2, 2), (2, 3), (2, 4), (3, 2), (3, 3)):
            for t in range(1, m + 1):
                formula = projective_reliability_polynomial(q, m, t)
                direct = projective_reliability_direct(q, m, t)
                self.assertEqual(formula, direct)
                self.assertEqual(evaluate_polynomial(formula, 0), 0)
                self.assertEqual(evaluate_polynomial(formula, 1), 1)
                checked += 1
        self.assertEqual(checked, 14)

    def test_budget_inversion(self) -> None:
        for q, m in ((2, 5), (3, 4), (5, 3)):
            total = (q**m - 1) // (q - 1)
            for budget in range(total + 1):
                rank = maximum_recoverable_rank(q, m, budget)
                if rank:
                    self.assertLessEqual(projective_threshold(q, m, rank), budget)
                if rank < m:
                    self.assertGreater(projective_threshold(q, m, rank + 1), budget)

    def test_shared_all_rank_pass(self) -> None:
        for q, m in ((2, 5), (3, 4), (5, 3)):
            shared = all_rank_reliability_polynomials(q, m)
            self.assertEqual(len(shared), m)
            for t, polynomial in enumerate(shared, start=1):
                self.assertEqual(evaluate_polynomial(polynomial, 0), 0)
                self.assertEqual(evaluate_polynomial(polynomial, 1), 1)
            thresholds = [min(polynomial) for polynomial in shared]
            self.assertEqual(
                thresholds,
                [projective_threshold(q, m, t) for t in range(1, m + 1)],
            )


class ServiceRateTests(unittest.TestCase):
    def test_bitmask_minimal_supports(self) -> None:
        self.assertEqual(
            inclusion_minimal(((1, 40), (40, 1, 1), (1, 2, 40), (3,), (3, 4))),
            ((3,), (1, 40)),
        )

    def test_zero_extension_preserves_small_lp(self) -> None:
        inner = build_service_lp(
            (
                ((0, 2), (1, 2), (0, 1, 2)),
                ((1,), (1, 3)),
            ),
            4,
        )
        self.assertEqual(len(inner.variables), 3)
        extended = zero_extend_service_lp(inner, 40, 12)
        self.assertEqual(len(extended.variables), len(inner.variables))
        self.assertEqual(extended.demand_incidence, inner.demand_incidence)
        self.assertEqual(
            tuple(helper for helper, _ in extended.active_helper_incidence),
            (12, 13, 14),
        )
        self.assertEqual(
            tuple(row for _, row in extended.active_helper_incidence),
            tuple(row for _, row in inner.active_helper_incidence),
        )
        self.assertEqual(
            tuple(row for row in extended.helper_incidence[12:16]),
            inner.helper_incidence,
        )
        self.assertTrue(all(not any(row) for row in extended.helper_incidence[:12]))
        self.assertTrue(all(not any(row) for row in extended.helper_incidence[16:]))


class CrossPaperTransferTests(unittest.TestCase):
    def test_collision_correction_exhaustive_set_systems(self) -> None:
        candidates = tuple(range(3))
        subsets = ((), (0,), (1,), (2,))
        checked = 0
        for obstruction_count in range(4):
            for family in product(subsets, repeat=obstruction_count):
                result = collision_correction(candidates, family)
                forbidden = set().union(*map(set, family)) if family else set()
                self.assertEqual(result.legal_count, len(set(candidates) - forbidden))
                self.assertEqual(
                    result.legal_count + result.obstruction_count,
                    result.candidate_count + result.invisible_count + result.redundancy,
                )
                checked += 1
        self.assertEqual(checked, 1 + 4 + 16 + 64)
        with self.assertRaises(ValueError):
            collision_correction(candidates, ((0, 1),))

    def test_defect_deletion_constructs_structured_core(self) -> None:
        result = delete_to_clique_free_core(
            range(7), ((0, 1, 2), (2, 3), (3, 4, 5), (1, 6))
        )
        survivor_set = set(result.survivors)
        for clique in ((0, 1, 2), (2, 3), (3, 4, 5), (1, 6)):
            self.assertLessEqual(len(survivor_set & set(clique)), 1)
        self.assertLessEqual(len(result.deleted), result.edit_charge)
        self.assertEqual(result.edit_charge, 2 + 1 + 2 + 1)

    def test_simultaneous_repairs_and_hall_certificate(self) -> None:
        complete = maximum_distinct_repairs(
            (("a", "b"), ("b", "c"), ("a", "c"))
        )
        self.assertTrue(complete.complete)
        self.assertEqual(len({right for _, right in complete.assignment}), 3)

        deficient = maximum_distinct_repairs(
            (("a", "b"), ("a", "b"), ("a", "b"), ("c",))
        )
        self.assertFalse(deficient.complete)
        self.assertLess(len(deficient.hall_neighbors), len(deficient.hall_left))
        actual_neighbors = {
            right
            for left in deficient.hall_left
            for right in (("a", "b"), ("a", "b"), ("a", "b"), ("c",))[left]
        }
        self.assertEqual(set(deficient.hall_neighbors), actual_neighbors)

    def test_matching_size_matches_direct_enumeration(self) -> None:
        subsets = ((), (0,), (1,), (0, 1), (1, 2), (0, 2), (0, 1, 2))

        def brute(families: tuple[tuple[int, ...], ...]) -> int:
            best = 0

            def search(index: int, used: set[int], count: int) -> None:
                nonlocal best
                if index == len(families):
                    best = max(best, count)
                    return
                search(index + 1, used, count)
                for candidate in families[index]:
                    if candidate not in used:
                        search(index + 1, used | {candidate}, count + 1)

            search(0, set(), 0)
            return best

        checked = 0
        for families in product(subsets, repeat=3):
            result = maximum_distinct_repairs(families)
            self.assertEqual(len(result.assignment), brute(families))
            checked += 1
        self.assertEqual(checked, len(subsets) ** 3)

    def test_replacement_graph_components(self) -> None:
        states = ({0, 1}, {0, 2}, {1, 2}, {7, 8}, {7, 9})
        components = replacement_graph_components(states)
        self.assertEqual(sorted(map(len, components)), [2, 3])
        for component in components:
            reached = {component[0]}
            while True:
                new = reached | {
                    state
                    for state in component
                    if any(len(state - old) == len(old - state) == 1 for old in reached)
                }
                if new == reached:
                    break
                reached = new
            self.assertEqual(reached, set(component))

    def test_feature_separator_span_and_finite_field_obstructions(self) -> None:
        witness = feature_separator(((1, 0, 0),), ((0, 1, 0),), 3, 2)
        self.assertIsNone(witness.obstruction)
        self.assertEqual(witness.witness[0], 0)
        self.assertEqual(witness.witness[1], 1)

        in_span = feature_separator(((1, 0, 0),), ((1, 0, 0),), 3, 2)
        self.assertEqual(in_span.obstruction, "protected_evaluation_in_forbidden_span")

        # Three nonzero functionals cover F_2^2: x, y, and x+y.
        covered = feature_separator((), ((1, 0), (0, 1), (1, 1)), 2, 2)
        self.assertEqual(covered.obstruction, "finite_field_cover")
        self.assertEqual(covered.candidates_examined, 3)

    def test_feature_separator_matches_direct_form_search(self) -> None:
        evaluations = tuple(product(range(2), repeat=3))
        checked = 0
        for forbidden in combinations(evaluations, 2):
            for protected in combinations(evaluations, 2):
                result = feature_separator(forbidden, protected, 3, 2)
                direct = any(
                    any(form)
                    and all(sum(x * y for x, y in zip(row, form)) % 2 == 0 for row in forbidden)
                    and all(sum(x * y for x, y in zip(row, form)) % 2 != 0 for row in protected)
                    for form in evaluations
                )
                self.assertEqual(result.witness is not None, direct)
                checked += 1
        self.assertEqual(checked, 28 * 28)


class IncidenceSearchTests(unittest.TestCase):
    def test_gf27_threshold_polynomial(self) -> None:
        coefficients = bounded_threshold_coefficients(5, 3)
        self.assertEqual(coefficients, (0, 0, 0, 1, -3, 6))
        self.assertEqual(
            tuple(evaluate_binomial_polynomial(coefficients, value) for value in range(6)),
            (0, 0, 0, 1, 1, 1),
        )

    def test_binomial_interpolation_exhaustive_boolean_tables(self) -> None:
        checked = 0
        for values in product(range(2), repeat=6):
            coefficients = binomial_basis_coefficients(values)
            self.assertEqual(
                tuple(
                    evaluate_binomial_polynomial(coefficients, value)
                    for value in range(len(values))
                ),
                values,
            )
            checked += 1
        self.assertEqual(checked, 64)

    def test_packed_ternary_addition_exhaustively(self) -> None:
        vectors = tuple(product(range(3), repeat=4))
        for left in vectors:
            packed_left = pack_ternary(left)
            self.assertEqual(unpack_ternary(packed_left, 4), left)
            for right in vectors:
                self.assertEqual(
                    unpack_ternary(
                        add_packed_ternary(packed_left, pack_ternary(right), 4), 4
                    ),
                    tuple((x + y) % 3 for x, y in zip(left, right)),
                )
        with self.assertRaises(ValueError):
            pack_ternary((0, 3))
        with self.assertRaises(ValueError):
            unpack_ternary(3, 1)
        with self.assertRaises(ValueError):
            unpack_ternary(1 << 6, 2)

    def test_orbit_syndrome_search_matches_direct_enumeration(self) -> None:
        families = tuple(
            (
                OrbitOption((orbit, 0), (0, 0), (0, 0)),
                OrbitOption((orbit, 1), (1, orbit % 3), (1, 0)),
                OrbitOption((orbit, -1), (2, (-orbit) % 3), (1, 1)),
            )
            for orbit in range(4)
        )
        direct = {
            (
                tuple(sum(option.residue[j] for option in choices) % 3 for j in range(2)),
                tuple(sum(option.totals[j] for option in choices) for j in range(2)),
            )
            for choices in product(*families)
        }
        checked = 0
        for residue in product(range(3), repeat=2):
            for totals in product(range(5), repeat=2):
                result = ternary_orbit_syndrome_search(families, residue, totals)
                self.assertEqual(result.feasible, (residue, totals) in direct)
                if result.feasible:
                    selected = tuple(
                        next(option for option in family if option.label == label)
                        for family, label in zip(families, result.choices)
                    )
                    self.assertEqual(
                        tuple(sum(option.residue[j] for option in selected) % 3 for j in range(2)),
                        residue,
                    )
                    self.assertEqual(
                        tuple(sum(option.totals[j] for option in selected) for j in range(2)),
                        totals,
                    )
                checked += 1
        self.assertEqual(checked, 225)

    def test_ternary_affine_constraint_compilation(self) -> None:
        families = (
            (
                OrbitOption(10, (1, 2, 0, 1), (0,)),
                OrbitOption(11, (2, 1, 0, 2), (1,)),
            ),
            (
                OrbitOption(20, (0, 1, 1, 2), (0,)),
                OrbitOption(21, (1, 0, 1, 0), (1,)),
            ),
        )
        compiled = compile_ternary_affine_constraints(
            families, (2, 2, 1, 1), (1,)
        )
        self.assertIsInstance(compiled, TernaryAffineProblem)
        assert isinstance(compiled, TernaryAffineProblem)
        self.assertEqual((compiled.original_width, compiled.compressed_width), (4, 1))
        answer = ternary_orbit_syndrome_search(
            compiled.option_families,
            compiled.target_residue,
            compiled.target_totals,
        )
        self.assertEqual(answer.choices, (10, 21))

        obstruction = compile_ternary_affine_constraints(
            ((OrbitOption(1, (0, 0, 0)), OrbitOption(2, (1, 2, 0))),),
            (0, 0, 1),
        )
        self.assertIsInstance(obstruction, TernaryAffineObstruction)
        assert isinstance(obstruction, TernaryAffineObstruction)
        self.assertNotEqual(obstruction.nonzero_pairing, 0)
        for option in ((0, 0, 0), (1, 2, 0)):
            self.assertEqual(
                sum(a * b for a, b in zip(obstruction.annihilator, option)) % 3,
                0,
            )

    def test_signed_incidence_constraints(self) -> None:
        rows = ((0, 1), (0, 2), (1, 2, 3), (2, 3))
        good = signed_incidence_profile(rows, (1, -1, -1, 1))
        self.assertTrue(good.support_constraints_hold)
        self.assertEqual(good.signed_sums, (0, 0, -1, 0))
        bad = signed_incidence_profile(rows, (1, 1, 0, -1))
        self.assertEqual(bad.tangent_rows, (1, 3))
        self.assertEqual(bad.same_sign_secants, (0,))

    def test_signed_incidence_bitsets_match_iterable_interface(self) -> None:
        rows = ((0, 1), (0, 2), (1, 2, 3), (2, 3))
        masks = tuple(sum(1 << point for point in row) for row in rows)
        checked = 0
        for signs in product((-1, 0, 1), repeat=4):
            positive = sum(1 << point for point, sign in enumerate(signs) if sign == 1)
            negative = sum(1 << point for point, sign in enumerate(signs) if sign == -1)
            self.assertEqual(
                signed_incidence_profile(rows, signs),
                signed_incidence_profile_masks(masks, positive, negative, 4),
            )
            checked += 1
        self.assertEqual(checked, 81)


class StorageRepairTests(unittest.TestCase):
    def test_dual_words_generate_exact_scalar_recovery_sets(self) -> None:
        repetition_dual = ((1, 1, 0), (1, 0, 1))
        self.assertEqual(
            scalar_recovery_sets_from_dual(repetition_dual, 0, 2),
            ((1,), (2,)),
        )
        self.assertEqual(
            recovery_families_from_dual(repetition_dual, (0, 1, 2), 2),
            {0: ((1,), (2,)), 1: ((0,), (2,)), 2: ((0,), (1,))},
        )
        self.assertEqual(
            scalar_recovery_sets_from_dual(repetition_dual, 0, 2, radius=0),
            (),
        )

    def test_normalized_recovery_coefficients_replay(self) -> None:
        dual = ((1, 2, 0), (1, 0, 2))
        equations = scalar_recovery_equations_from_dual(dual, 0, 3)
        self.assertEqual(
            equations,
            (
                type(equations[0])((1,), (1,)),
                type(equations[0])((2,), (1,)),
            ),
        )
        code_basis = nullspace_basis(dual, 3)
        for codeword in product(range(3), repeat=len(code_basis)):
            word = tuple(
                sum(codeword[i] * code_basis[i][j] for i in range(len(code_basis))) % 3
                for j in range(3)
            )
            for equation in equations:
                recovered = sum(
                    coefficient * word[helper]
                    for helper, coefficient in zip(
                        equation.support, equation.coefficients
                    )
                ) % 3
                self.assertEqual(recovered, word[0])

    def test_capacity_aware_parallel_repair(self) -> None:
        families = (((0,), (1,)), ((0,),), ((1, 2),))
        result = maximum_parallel_repairs(families, {0: 1, 1: 1, 2: 1})
        self.assertEqual(result.repaired_count, 2)
        for helper in (0, 1, 2):
            self.assertLessEqual(
                sum(helper in support for _, support in result.assignment), 1
            )
        self.assertLessEqual(result.repaired_count, result.capacity_cut.repair_upper_bound)

    def test_weighted_download_capacity_is_not_support_capacity(self) -> None:
        weighted = maximum_weighted_parallel_repairs(
            (({0: 2},), ({0: 1},)), {0: 2}
        )
        scalarized = maximum_parallel_repairs((((0,),), ((0,),)), {0: 2})
        self.assertEqual(weighted.repaired_count, 1)
        self.assertEqual(scalarized.repaired_count, 2)
        self.assertEqual(weighted.peak_pareto_states, 2)

        with_alternative = maximum_weighted_parallel_repairs(
            (({0: 2}, {1: 1}), ({0: 1},)), {0: 2, 1: 1}
        )
        self.assertTrue(with_alternative.complete)

    def test_parallel_dp_matches_direct_assignment_search(self) -> None:
        support_pool = ((), ((0,),), ((1,),), ((0, 1),), ((0,), (1,)))

        def brute(families: tuple[tuple[tuple[int, ...], ...], ...]) -> int:
            best = 0

            def search(demand: int, used: tuple[int, int], count: int) -> None:
                nonlocal best
                if demand == len(families):
                    best = max(best, count)
                    return
                search(demand + 1, used, count)
                for support in families[demand]:
                    load = (int(0 in support), int(1 in support))
                    new = (used[0] + load[0], used[1] + load[1])
                    if new[0] <= 1 and new[1] <= 1:
                        search(demand + 1, new, count + 1)

            search(0, (0, 0), 0)
            return best

        checked = 0
        for families in product(support_pool, repeat=3):
            result = maximum_parallel_repairs(families, {0: 1, 1: 1})
            self.assertEqual(result.repaired_count, brute(families))
            self.assertLessEqual(
                result.repaired_count, result.capacity_cut.repair_upper_bound
            )
            checked += 1
        self.assertEqual(checked, 125)

    def test_weighted_parallel_dp_matches_direct_search(self) -> None:
        option_pool = ({}, {0: 1}, {0: 2}, {1: 1}, {0: 1, 1: 1})
        family_pool = (
            (),
            (option_pool[0],),
            (option_pool[1],),
            (option_pool[2],),
            (option_pool[3],),
            (option_pool[1], option_pool[3]),
            (option_pool[2], option_pool[4]),
        )

        def brute(families, capacities) -> int:
            best = 0

            def search(demand, used, count) -> None:
                nonlocal best
                if demand == len(families):
                    best = max(best, count)
                    return
                search(demand + 1, used, count)
                for option in families[demand]:
                    new = tuple(
                        used[i] + option.get(helper, 0)
                        for i, helper in enumerate((0, 1))
                    )
                    if all(new[i] <= capacities[helper] for i, helper in enumerate((0, 1))):
                        search(demand + 1, new, count + 1)

            search(0, (0, 0), 0)
            return best

        checked = 0
        for capacities in ({0: 1, 1: 1}, {0: 2, 1: 1}):
            for families in product(family_pool, repeat=3):
                result = maximum_weighted_parallel_repairs(families, capacities)
                self.assertEqual(result.repaired_count, brute(families, capacities))
                checked += 1
        self.assertEqual(checked, 2 * len(family_pool) ** 3)

    def test_unlimited_fanout_earliest_repair_times(self) -> None:
        closure = earliest_repair_times(
            {2: ((0,),), 3: ((2,),), 4: ((2, 3),), 5: ((6,),)},
            (0, 1),
        )
        self.assertEqual(dict(closure.arrival_times), {0: 0, 1: 0, 2: 1, 3: 2, 4: 3})
        self.assertEqual(closure.unreachable, (5,))
        self.assertEqual(dict(closure.chosen_supports)[4], (2, 3))

    def test_capacity_scheduler_chooses_unlocking_repair(self) -> None:
        schedule = minimum_round_repair_schedule(
            {2: ((0,),), 3: ((0,),), 4: ((2,),)},
            (0, 1),
            {0: 1, 1: 1, 2: 1, 3: 1, 4: 1},
        )
        self.assertTrue(schedule.complete)
        self.assertEqual(len(schedule.rounds), 2)
        self.assertEqual({node for node, _ in schedule.rounds[0]}, {2})
        self.assertEqual({node for node, _ in schedule.rounds[1]}, {3, 4})

    def test_materialized_replacements_charge_choice_and_downloads(self) -> None:
        families, candidate_capacities = materialized_replacement_families(
            (
                {"a": ((0,),), "b": ((1,),)},
                {"a": ((2,),), "c": ((0,),)},
            )
        )
        capacities = candidate_capacities | {
            ("helper", 0): 1,
            ("helper", 1): 1,
            ("helper", 2): 1,
        }
        result = maximum_parallel_repairs(families, capacities)
        self.assertTrue(result.complete)
        chosen_candidates = [
            next(resource for resource in support if resource[0] == "candidate")
            for _, support in result.assignment
        ]
        self.assertEqual(len(set(chosen_candidates)), 2)

    def test_joint_linear_materialization_uses_generated_spans(self) -> None:
        generator = ((1, 0, 1), (0, 1, 1))
        self.assertEqual(
            linear_materialization_supports(generator, ((1,), (1,)), 2),
            ((2,), (0, 1)),
        )
        self.assertEqual(
            linear_materialization_supports(
                generator, ((1, 0), (0, 1)), 2
            ),
            ((0, 1), (0, 2), (1, 2)),
        )
        triangle = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
        fresh_pair = ((1, 1), (1, 2), (1, 3))
        self.assertEqual(
            linear_materialization_supports(triangle, fresh_pair, 5),
            ((0, 1, 2),),
        )

        off_secants = tuple((1, a, b) for a in range(1, 5) for b in range(1, 5))
        checked = 0
        for left, right in combinations(off_secants, 2):
            desired = tuple((left[i], right[i]) for i in range(3))
            if matrix_rank(desired, 5) != 2:
                continue
            carrier_is_empty = all(
                matrix_rank(
                    tuple(
                        desired[i] + (int(i == coordinate),)
                        for i in range(3)
                    ),
                    5,
                )
                == 3
                for coordinate in range(3)
            )
            if not carrier_is_empty:
                continue
            self.assertEqual(
                linear_materialization_supports(triangle, desired, 5),
                ((0, 1, 2),),
            )
            checked += 1
        self.assertGreater(checked, 0)

    def test_materialization_coefficients_replay_exhaustively(self) -> None:
        checked = 0
        for generator in all_matrices(2, 3, 2):
            for desired in all_matrices(2, 2, 2):
                plans = linear_materialization_plans(generator, desired, 2)
                for plan in plans:
                    block = tuple(
                        tuple(row[j] for j in plan.support) for row in generator
                    )
                    replay = (
                        mat_mul(block, plan.coefficients, 2)
                        if plan.support
                        else tuple((0,) * plan.output_width for _ in generator)
                    )
                    self.assertEqual(replay, desired)
                    self.assertEqual(matrix_rank(block, 2), len(plan.support))
                    checked += 1
        self.assertGreater(checked, 0)

    def test_earliest_times_match_synchronous_fixed_point(self) -> None:
        support_pool = ((), ((0,),), ((2,),), ((3,),), ((0, 2),), ((2, 3),))
        checked = 0
        for family2, family3 in product(support_pool, repeat=2):
            recovery = {2: family2, 3: family3}
            result = earliest_repair_times(recovery, (0,))
            direct = {0: 0}
            while True:
                updated = dict(direct)
                for owner, family in recovery.items():
                    ready = [
                        1 + max((direct[helper] for helper in support), default=0)
                        for support in family
                        if all(helper in direct for helper in support)
                    ]
                    if ready:
                        updated[owner] = min(updated.get(owner, 10**9), min(ready))
                if updated == direct:
                    break
                direct = updated
            self.assertEqual(dict(result.arrival_times), direct)
            checked += 1
        self.assertEqual(checked, 36)


class BalancedTransversalTests(unittest.TestCase):
    def test_high_cells_reconstruct_carrier(self) -> None:
        field = TernaryExtensionField(27)
        cells = []
        for x in range(2, 11):
            cells.extend(((x, x), (x, field.multiply(x, x))))
        result = q27_carrier_from_high_cells(cells)
        self.assertTrue(result["consistent"])
        self.assertEqual(result["rank"], 18)
        trace, product_coefficients = result["carrier"]
        self.assertEqual(trace, (0, 1, 1, 0, 0, 0, 0, 0, 0))
        self.assertEqual(product_coefficients, (0, 0, 0, 1, 0, 0, 0, 0, 0))
        self.assertFalse(q27_carrier_from_high_cells(cells + [(2, 0)])["consistent"])

    def test_q27_balanced_carrier_affine_rank(self) -> None:
        unrestricted = q27_balanced_carrier_affine_rank()
        fixed_two = q27_balanced_carrier_affine_rank(0, 0)
        fixed_eighteen = q27_balanced_carrier_affine_rank(1, 0)
        self.assertEqual(
            (unrestricted["affine_rank"], unrestricted["row_pair_options"]),
            (102, 9_126),
        )
        self.assertEqual(
            (fixed_two["affine_rank"], fixed_two["row_pair_options"]),
            (102, 7_550),
        )
        self.assertEqual(
            (fixed_eighteen["affine_rank"], fixed_eighteen["row_pair_options"]),
            (102, 7_550),
        )
        self.assertEqual(set(q27_unmarked_pair_local_ranks()), {6})

    def test_semilinear_mapping_quotient(self) -> None:
        audit = q27_balanced_transversal_oracle()
        self.assertEqual(set(audit["normalized_fibers"]), {2, 18, 23, 26})
        self.assertEqual(set(audit["mappings_per_fiber"].values()), {530})
        self.assertEqual(audit["mapping_count"], 2_120)
        self.assertEqual(audit["distinct_pair_count"], 2_116)
        self.assertEqual(audit["pair_multiplicities"], {1: 2_112, 2: 4})
        self.assertEqual(audit["kappa_two_frobenius_fixed_mappings"], 11)
        self.assertEqual(audit["kappa_two_mapping_orbits"], 184)
        self.assertEqual(audit["full_semilinear_mapping_orbits"], 714)

    def test_two_high_fibers_reconstruct_carrier(self) -> None:
        trace = (4, 7, 11, 3, 18, 9, 22, 6, 1)
        product_coefficients = (8, 2, 15, 20, 5, 17, 12, 24, 10)
        first = q27_high_fiber_from_carrier(trace, product_coefficients, 1)
        second = q27_high_fiber_from_carrier(trace, product_coefficients, 2)
        rebuilt = q27_reconstruct_carrier_from_fibers(1, first, 2, second)
        self.assertEqual(rebuilt, (trace, product_coefficients))
        for value in range(1, 10):
            self.assertEqual(
                q27_high_fiber_from_carrier(*rebuilt, value),
                q27_high_fiber_from_carrier(
                    trace, product_coefficients, value
                ),
            )

        families = [
            [(value, q27_high_fiber_from_carrier(trace, product_coefficients, value))]
            for value in range(1, 10)
        ]
        decoy = list(families[0][0][1])
        decoy[8] = (decoy[8] + 1) % 27
        families[0].insert(0, (1, tuple(decoy)))
        witness = q27_search_high_fiber_candidates(families)
        assert witness is not None
        self.assertEqual(witness["carrier"], (trace, product_coefficients))
        self.assertEqual(witness["seed_slots"], (1, 2))
        self.assertEqual(witness["candidate_indices"][0], 1)


class DefectShellTests(unittest.TestCase):
    def test_sparse_histograms_match_labelled_brute_force(self) -> None:
        actual = set(
            convex_shell_histograms(
                point_count=5,
                degree_sum=12,
                center=2,
                minimum_degree=0,
                maximum_degree=5,
                defect=3,
            )
        )
        expected = set()
        for degrees in product(range(6), repeat=5):
            if sum(degrees) != 12:
                continue
            if sum((degree - 2) * (degree - 3) // 2 for degree in degrees) != 3:
                continue
            expected.add(tuple(degrees.count(degree) for degree in range(6)))
        self.assertEqual(actual, expected)

    def test_gf27_defect_pairs_replay_all_scalar_moments(self) -> None:
        pair_count = 0
        for internal, external in gf27_q27_t54_histogram_pairs():
            self.assertEqual(sum(internal), 279)
            self.assertEqual(sum(degree * count for degree, count in enumerate(internal)), 1_026)
            self.assertEqual(sum(external), 478)
            self.assertEqual(
                sum((degree + 1) * count for degree, count in enumerate(external)),
                486,
            )
            defect = sum(
                (degree - 3) * (degree - 4) // 2 * count
                for degree, count in enumerate(internal)
            ) + sum(
                degree * (degree - 1) // 2 * count
                for degree, count in enumerate(external)
            )
            self.assertEqual(defect, 19)
            pair_count += 1
        self.assertEqual(pair_count, 3_435)

    def test_gf27_centered_spectrum_projection(self) -> None:
        spectra = gf27_q27_t54_centered_spectra()
        self.assertEqual(len(spectra), 1_496)
        supports = []
        for spectrum in spectra:
            self.assertEqual(sum(spectrum), 757)
            self.assertEqual(sum((value - 6) * count for value, count in enumerate(spectrum)), 82)
            self.assertEqual(
                sum((value - 6) ** 2 * count for value, count in enumerate(spectrum)),
                136,
            )
            supports.append(757 - spectrum[6])
        self.assertEqual((min(supports), max(supports)), (79, 136))


class ProjectivePlaneTests(unittest.TestCase):
    def test_ternary_extension_field_tables(self) -> None:
        for order in (9, 27):
            field = TernaryExtensionField(order)
            for value in range(1, order):
                inverse = next(
                    candidate
                    for candidate in range(1, order)
                    if field.multiply(value, candidate) == 1
                )
                self.assertEqual(field.multiply(inverse, value), 1)

    def test_pg2_9_incidence_axioms(self) -> None:
        plane = ternary_projective_plane(9)
        self.assertEqual(len(plane.points), 91)
        self.assertTrue(all(len(points) == 10 for points in plane.on_line))
        self.assertTrue(all(len(lines) == 10 for lines in plane.through_point))
        for first, second in combinations(plane.on_line, 2):
            self.assertEqual(len(set(first).intersection(second)), 1)

    def test_centered_pencil_identity(self) -> None:
        plane = ternary_projective_plane(9)
        maximal = set(range(18))
        selected = set(range(39))
        line_degrees = [
            sum(point in maximal for point in incident_points)
            for incident_points in plane.on_line
        ]
        centered = [
            1 + 3 * (line in selected) - line_degrees[line]
            for line in range(len(plane.on_line))
        ]
        for point, incident_lines in enumerate(plane.through_point):
            selected_degree = sum(line in selected for line in incident_lines)
            self.assertEqual(
                sum(centered[line] for line in incident_lines),
                3 * selected_degree - 9 * (point in maximal) - 8,
            )


class ValidationTests(unittest.TestCase):
    def test_invalid_shapes_and_fields_fail_loudly(self) -> None:
        with self.assertRaises(ValueError):
            LinearMap(4, ((1,),))
        with self.assertRaises(ValueError):
            extension_multiplication_matrix((0, 1), (1, 0, 2), 3)
        inner = prescribed_coset_costs(LinearMap(2, ((1, 1),)), 1)
        with self.assertRaises(ValueError):
            compose_cost_table((((1, 0),),), inner)
        with self.assertRaises(ValueError):
            target_normalized_composition(
                (((1,),),), (inner,), (((1,),),), ((1, 0),), ((0,),)
            )


if __name__ == "__main__":
    unittest.main(verbosity=2)
