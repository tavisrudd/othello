#!/usr/bin/env python3
"""Deterministic finite/numerical probes for C240."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations
import importlib.util
import json
import math
from pathlib import Path
import random
import sys


HERE = Path(__file__).resolve().parent
C227_JSON = HERE / "2026-07-16-c227-pointed-tutte-repair-polynomial.json"
C236 = HERE / "2026-07-16-c236-flagship-closure-comparison.py"
C218 = HERE / "2026-07-16-c218-quartic-nucleus-verifier.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def binary_vector_rank(vectors: list[int] | tuple[int, ...]) -> int:
    basis: dict[int, int] = {}
    for vector in vectors:
        value = vector
        while value:
            pivot = value.bit_length() - 1
            if pivot in basis:
                value ^= basis[pivot]
            else:
                basis[pivot] = value
                break
    return len(basis)


def binary_rank_table(columns: tuple[int, ...]) -> list[int]:
    return [
        binary_vector_rank([columns[index] for index in range(len(columns)) if mask >> index & 1])
        for mask in range(1 << len(columns))
    ]


def pointed_profile(columns: tuple[int, ...], target: int) -> list[int]:
    helpers = columns[:target] + columns[target + 1 :]
    answer = [0] * (len(helpers) + 1)
    for mask in range(1 << len(helpers)):
        vectors = [helpers[index] for index in range(len(helpers)) if mask >> index & 1]
        if binary_vector_rank(vectors + [columns[target]]) == binary_vector_rank(vectors):
            answer[mask.bit_count()] += 1
    return answer


def shape(profile: list[int]) -> dict[str, object]:
    n = len(profile) - 1
    lc_failures = []
    ulc_failures = []
    for index in range(1, n):
        if profile[index] ** 2 < profile[index - 1] * profile[index + 1]:
            lc_failures.append(index)
        left = (
            profile[index] ** 2
            * math.comb(n, index - 1)
            * math.comb(n, index + 1)
        )
        right = (
            profile[index - 1]
            * profile[index + 1]
            * math.comb(n, index) ** 2
        )
        if left < right:
            ulc_failures.append({"index": index, "left": left, "right": right})
    return {
        "log_concave": not lc_failures,
        "lc_failure_indices": lc_failures,
        "ultra_log_concave": not ulc_failures,
        "ulc_failures": ulc_failures,
    }


def profile_probe() -> dict[str, object]:
    source = json.loads(C227_JSON.read_text())
    committed = {
        "uniform": source["uniform_example"]["success_by_survivor_count"],
        **{
            name: value["success_by_survivor_count"]
            for name, value in source["q9_examples"].items()
        },
    }
    committed_results = {
        name: {"profile": profile, **shape(profile)} for name, profile in committed.items()
    }

    # Simple rank-five binary representation; target is the third listed column (10).
    ulc_columns = (13, 30, 10, 27, 23, 31, 7)
    ulc_target = 2
    assert len(set(ulc_columns)) == len(ulc_columns)
    assert binary_vector_rank(ulc_columns[:ulc_target] + ulc_columns[ulc_target + 1 :]) == 5
    counterexample_profile = pointed_profile(ulc_columns, ulc_target)
    counterexample_shape = shape(counterexample_profile)
    assert counterexample_shape["log_concave"]
    assert not counterexample_shape["ultra_log_concave"]

    rng = random.Random(240)
    sampled_pointed_matroids = 0
    sampled_lc_counterexample = None
    for _ in range(2_000):
        dimension = rng.randrange(2, 7)
        low = max(4, dimension + 1)
        high = min(10, 2**dimension - 1)
        if low > high:
            continue
        size = rng.randrange(low, high + 1)
        columns = tuple(rng.sample(range(1, 2**dimension), size))
        for target in range(size):
            remainder = columns[:target] + columns[target + 1 :]
            if binary_vector_rank(remainder) < binary_vector_rank(columns):
                continue
            sampled_pointed_matroids += 1
            profile = pointed_profile(columns, target)
            result = shape(profile)
            if not result["log_concave"]:
                sampled_lc_counterexample = {
                    "columns": columns,
                    "target": target,
                    "profile": profile,
                    **result,
                }
                break
        if sampled_lc_counterexample is not None:
            break

    return {
        "committed_profiles": committed_results,
        "ulc_counterexample": {
            "field": "GF(2)",
            "binary_columns": ulc_columns,
            "target_index": ulc_target,
            "target_column": ulc_columns[ulc_target],
            "profile": counterexample_profile,
            **counterexample_shape,
        },
        "random_sample": {
            "seed": 240,
            "matrix_draws": 2_000,
            "pointed_noncoloop_cases": sampled_pointed_matroids,
            "lc_counterexample": sampled_lc_counterexample,
        },
    }


def qary_entropy(value: float, alphabet: int) -> float:
    if value <= 0:
        return 0.0
    if value >= 1 - 1 / alphabet:
        return 1.0
    return (
        value * math.log(alphabet - 1, alphabet)
        - value * math.log(value, alphabet)
        - (1 - value) * math.log(1 - value, alphabet)
    )


def inverse_qary_entropy(value: float, alphabet: int) -> float:
    low, high = 0.0, 1 - 1 / alphabet
    for _ in range(100):
        middle = (low + high) / 2
        if qary_entropy(middle, alphabet) < value:
            low = middle
        else:
            high = middle
    return (low + high) / 2


def lrc_gv_rate(delta: float, alphabet: int, locality: int) -> float:
    objective = math.inf
    # Deterministic dense grid is ample for the six-decimal comparison recorded here.
    for index in range(1, 200_001):
        value = index / 200_000
        b_value = (
            (1 + (alphabet - 1) * value) ** (locality + 1)
            + (alphabet - 1) * (1 - value) ** (locality + 1)
        ) / alphabet
        candidate = (
            math.log(b_value, alphabet) / (locality + 1)
            - delta * math.log(value, alphabet)
        )
        objective = min(objective, candidate)
    return locality / (locality + 1) - objective


def lrc_probe() -> dict[str, object]:
    q = 9
    inner_length, inner_dimension, inner_distance = 11, 5, 6
    locality = 4
    outer_alphabet = q**inner_dimension
    rows = []
    for outer_rate_tenths in range(1, 10):
        outer_rate = outer_rate_tenths / 10
        concatenated_rate = inner_dimension / inner_length * outer_rate
        concatenated_delta = (
            inner_distance
            / inner_length
            * inverse_qary_entropy(1 - outer_rate, outer_alphabet)
        )
        baseline_rate = lrc_gv_rate(concatenated_delta, q, locality)
        rows.append(
            {
                "outer_rate": outer_rate,
                "concatenated_rate": concatenated_rate,
                "concatenated_relative_distance_lower_bound": concatenated_delta,
                "qary_lrc_gv_rate_lower_bound_at_same_delta": baseline_rate,
                "rate_gap": baseline_rate - concatenated_rate,
            }
        )
    assert all(row["rate_gap"] > 0.18 for row in rows)
    return {
        "inner_code": "[11,5,6]_9 quartic-nucleus code",
        "locality": locality,
        "outer_alphabet": outer_alphabet,
        "inner_rate_cap": inner_dimension / inner_length,
        "plain_locality_zero_distance_cap": locality / (locality + 1),
        "zero_distance_rate_gap": locality / (locality + 1) - inner_dimension / inner_length,
        "rows": rows,
    }


def circuits_from_rank(rank_table: list[int], size: int) -> list[int]:
    result = []
    for mask in range(1, 1 << size):
        cardinality = mask.bit_count()
        if rank_table[mask] == cardinality:
            continue
        if all(
            rank_table[mask ^ (1 << index)] == cardinality - 1
            for index in range(size)
            if mask >> index & 1
        ):
            result.append(mask)
    return result


def peeling_property(rank_table: list[int], size: int, radius: int) -> tuple[bool, dict | None]:
    small_circuits = [
        circuit
        for circuit in circuits_from_rank(rank_table, size)
        if circuit.bit_count() <= radius + 1
    ]
    for seed in range(1 << size):
        active = seed
        while True:
            additions = 0
            for circuit in small_circuits:
                missing = circuit & ~active
                if missing and missing & (missing - 1) == 0:
                    additions |= missing
            if not additions:
                break
            active |= additions
        full = seed
        seed_rank = rank_table[seed]
        for index in range(size):
            if not seed >> index & 1 and rank_table[seed | (1 << index)] == seed_rank:
                full |= 1 << index
        if active != full:
            return False, {"seed_mask": seed, "horn_mask": active, "full_closure_mask": full}
    return True, None


def deletion_rank_table(rank_table: list[int], size: int, element: int) -> list[int]:
    masks = [mask for mask in range(1 << size) if not mask >> element & 1]
    return [rank_table[mask] for mask in masks]


def dual_rank_table(rank_table: list[int], size: int) -> list[int]:
    ground = (1 << size) - 1
    total_rank = rank_table[ground]
    return [
        mask.bit_count() + rank_table[ground ^ mask] - total_rank
        for mask in range(1 << size)
    ]


def glue_binary_representations(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    shifted_right = tuple((value & 1) | ((value >> 1) << 3) for value in right[1:])
    return left[1:] + shifted_right


def peeling_probe() -> dict[str, object]:
    witnesses = {}
    specifications = {
        2: {
            "deletion_columns": (1, 2, 3, 4, 5),
            "dual_columns": (1, 2, 3, 4, 5, 6, 7),
            "sum_left": (1, 2, 3),
            "sum_right": (1, 2, 3),
        },
        3: {
            "deletion_columns": (1, 2, 3, 4, 8, 13),
            "dual_columns": (1, 2, 3, 4, 5, 6, 7, 8, 9),
            "sum_left": (1, 2, 3),
            "sum_right": (1, 2, 4, 7),
        },
    }
    for radius, data in specifications.items():
        deletion_columns = data["deletion_columns"]
        deletion_table = binary_rank_table(deletion_columns)
        assert peeling_property(deletion_table, len(deletion_columns), radius)[0]
        deleted_table = deletion_rank_table(deletion_table, len(deletion_columns), 0)
        deleted_result = peeling_property(deleted_table, len(deletion_columns) - 1, radius)
        assert not deleted_result[0]

        dual_columns = data["dual_columns"]
        primal_table = binary_rank_table(dual_columns)
        assert peeling_property(primal_table, len(dual_columns), radius)[0]
        dual_result = peeling_property(
            dual_rank_table(primal_table, len(dual_columns)), len(dual_columns), radius
        )
        assert not dual_result[0]

        left, right = data["sum_left"], data["sum_right"]
        assert peeling_property(binary_rank_table(left), len(left), radius)[0]
        assert peeling_property(binary_rank_table(right), len(right), radius)[0]
        glued = glue_binary_representations(left, right)
        sum_result = peeling_property(binary_rank_table(glued), len(glued), radius)
        assert not sum_result[0]

        witnesses[str(radius)] = {
            "deletion": {
                "parent_columns": deletion_columns,
                "deleted_index": 0,
                "minor_columns": deletion_columns[1:],
                "minor_failure": deleted_result[1],
            },
            "duality": {
                "primal_columns": dual_columns,
                "primal_rank": primal_table[-1],
                "dual_failure": dual_result[1],
            },
            "two_sum": {
                "left_columns_with_glue_first": left,
                "right_columns_with_glue_first": right,
                "sum_columns": glued,
                "sum_failure": sum_result[1],
            },
        }
    return {
        "field": "GF(2)",
        "conclusion": "P_r fails deletion-, duality-, and 2-sum closure at r=2 and r=3",
        "witnesses": witnesses,
    }


def cubic_flat_masks(c236, base, field) -> tuple[list[int], list[tuple[int, ...]]]:
    q = field.q
    points, _ = base.completed_points(field)
    circuits = c236.cubic_small_circuits(base, field, points)
    offset = q + 1
    axis_all = (1 << (q + 1)) - 1
    completions = []
    for circuit in circuits:
        if sum(index < offset for index in circuit) != 3:
            continue
        curve_mask = sum(1 << index for index in circuit if index < offset)
        axis_index = next(index - offset for index in circuit if index >= offset)
        completions.append((curve_mask, 1 << axis_index))
    result = []
    for curve_mask in range(1 << (q + 1)):
        required_axis = 0
        forbidden_axis = 0
        for triple, axis_bit in completions:
            intersection = (curve_mask & triple).bit_count()
            if intersection == 3:
                required_axis |= axis_bit
            elif intersection == 2:
                forbidden_axis |= axis_bit
        if required_axis & forbidden_axis:
            continue
        for axis_mask in (0, axis_all, *(1 << index for index in range(q + 1))):
            if required_axis & ~axis_mask or forbidden_axis & axis_mask:
                continue
            result.append(curve_mask | (axis_mask << offset))
    return sorted(set(result)), points


def mobius_to_top(flats: list[int], ground: int) -> dict[int, int]:
    answer = {ground: 1}
    for flat in sorted((value for value in flats if value != ground), key=int.bit_count, reverse=True):
        answer[flat] = -sum(
            value for larger, value in answer.items() if flat != larger and flat & ~larger == 0
        )
    return answer


def cubic_cascade(field, c236, base) -> dict[str, object]:
    flats, points = cubic_flat_masks(c236, base, field)
    size = len(points)
    ground = (1 << size) - 1
    mobius = mobius_to_top(flats, ground)
    formula_counts = [
        sum(value * math.comb(flat.bit_count(), cardinality) for flat, value in mobius.items())
        for cardinality in range(size + 1)
    ]

    hyperplanes = []
    for flat in flats:
        selected = [points[index] for index in range(size) if flat >> index & 1]
        if base.rank(field, selected) == 3:
            hyperplanes.append(flat)
    failures = bytearray(1 << size)
    for hyperplane in hyperplanes:
        subset = hyperplane
        while True:
            failures[subset] = 1
            if subset == 0:
                break
            subset = (subset - 1) & hyperplane
    direct_counts = [math.comb(size, cardinality) for cardinality in range(size + 1)]
    for mask, failure in enumerate(failures):
        if failure:
            direct_counts[mask.bit_count()] -= 1
    assert formula_counts == direct_counts
    return {
        "q": field.q,
        "point_count": size,
        "flat_count": len(flats),
        "hyperplane_count": len(hyperplanes),
        "mobius_fixed_size_spanning_counts": formula_counts,
        "direct_hyperplane_union_spanning_counts": direct_counts,
    }


def affine_closure(field, seed: frozenset[int]) -> frozenset[int]:
    if not seed:
        return seed
    origin = next(iter(seed))
    differences = [field.sub(value, origin) for value in seed]
    linear = {0}
    for difference in differences:
        linear |= {field.add(value, scalar) for value in tuple(linear) for scalar in (difference, field.add(difference, difference))}
    return frozenset(field.add(origin, value) for value in linear)


def zero_sum_closure(field, seed: frozenset[int]) -> frozenset[int]:
    active = set(seed)
    while True:
        additions = {
            field.neg(field.add(left, right))
            for left, right in combinations(sorted(active), 2)
        }
        if additions <= active:
            return frozenset(active)
        active |= additions


def cascade_probe() -> dict[str, object]:
    c236 = load_module("c240_c236", C236)
    harmonic = load_module("c240_c218", C218)
    base = c236.load_module("c240_cubic_base", c236.BASE)
    harmonic_base = harmonic.load_base()
    cubic = [cubic_cascade(field, c236, base) for field in base.FIELDS[:2]]

    affine_checks = {}
    for field in harmonic_base.FIELDS[1:]:
        if field.q == 9:
            seeds = (frozenset(index for index in range(field.q) if mask >> index & 1) for mask in range(1 << field.q))
            scope = "all subsets"
        else:
            seeds = (
                frozenset(seed)
                for cardinality in range(4)
                for seed in combinations(range(field.q), cardinality)
            )
            scope = "all subsets of size at most three"
        count = 0
        for seed in seeds:
            assert zero_sum_closure(field, seed) == affine_closure(field, seed)
            count += 1
        affine_checks[str(field.q)] = {"scope": scope, "seed_count": count}

    q27 = harmonic_base.FIELDS[2]
    plane = frozenset(range(9))
    assert affine_closure(q27, plane) == plane
    escape_triple = (0, 1, 3)
    escape = harmonic.triple_completion(q27, escape_triple)
    assert escape == 23 and escape not in plane
    return {
        "cubic": cubic,
        "bernoulli_formula": "sum_{F flat} mu(F,E) (1-p)^(|E|-|F|)",
        "harmonic_zero_sum_affine_checks": affine_checks,
        "harmonic_full_rule_escape": {
            "q": 27,
            "proper_affine_plane": sorted(plane),
            "triple": escape_triple,
            "harmonic_completion": escape,
            "conclusion": "the full harmonic-block cascade is not confined to affine closure",
        },
    }


def xor_cost(columns: tuple[int, ...], target: int) -> int:
    answer = math.inf
    for mask in range(1 << len(columns)):
        value = 0
        for index, column in enumerate(columns):
            if mask >> index & 1:
                value ^= column
        if value == target:
            answer = min(answer, mask.bit_count())
    return answer


def width_two_probe() -> dict[str, object]:
    # Left and right spans meet in W=<1,2>. No ground element is shared.
    left = (4, 5, 6)
    right = (8, 9, 10)
    interface = (0, 1, 2, 3)
    checks = 0
    radius_checks = 0
    for left_mask in range(1 << len(left)):
        active_left = tuple(left[index] for index in range(len(left)) if left_mask >> index & 1)
        for right_mask in range(1 << len(right)):
            active_right = tuple(right[index] for index in range(len(right)) if right_mask >> index & 1)
            active = active_left + active_right
            for target in left + right:
                direct = xor_cost(active, target)
                if target in left:
                    convolution = min(
                        xor_cost(active_left, target ^ boundary) + xor_cost(active_right, boundary)
                        for boundary in interface
                    )
                else:
                    convolution = min(
                        xor_cost(active_right, target ^ boundary) + xor_cost(active_left, boundary)
                        for boundary in interface
                    )
                assert direct == convolution
                checks += 1
                for radius in range(5):
                    assert (direct <= radius) == (convolution <= radius)
                    radius_checks += 1
    return {
        "field": "GF(2)",
        "left_columns": left,
        "right_columns": right,
        "interface_vectors": interface,
        "active_set_target_checks": checks,
        "radius_threshold_checks": radius_checks,
        "conclusion": "pointwise boundary-vector support costs exactly convolve for one-step closure",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=Path(__file__).with_suffix(".json"))
    args = parser.parse_args()
    result = {
        "task": "C240",
        "pointed_profile_shape": profile_probe(),
        "fixed_alphabet_lrc": lrc_probe(),
        "peeling_classification": peeling_probe(),
        "cascade_replay": cascade_probe(),
        "width_two_boundary": width_two_probe(),
    }
    args.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({
        "task": result["task"],
        "profile_random_cases": result["pointed_profile_shape"]["random_sample"]["pointed_noncoloop_cases"],
        "profile_lc_counterexample": result["pointed_profile_shape"]["random_sample"]["lc_counterexample"],
        "peeling_conclusion": result["peeling_classification"]["conclusion"],
        "cubic_q": [item["q"] for item in result["cascade_replay"]["cubic"]],
        "width_two_checks": result["width_two_boundary"]["active_set_target_checks"],
    }, indent=2))


if __name__ == "__main__":
    main()
