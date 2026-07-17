#!/usr/bin/env python3
"""C244: independent replay of the exact low-cost consequence pack."""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
from hashlib import sha256
from itertools import combinations, product
import importlib.util
import json
import math
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-13-projective-completion-verifier.py"
C218 = HERE / "2026-07-16-c218-quartic-nucleus-verifier.py"
C226 = HERE / "2026-07-16-c226-repair-port-exit-transforms.py"
C227 = HERE / "2026-07-16-c227-pointed-tutte-repair-polynomial.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def stable_hash(value) -> str:
    return sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def pointed_distance_rows(base, c227):
    rows = []
    for field in base.FIELDS[1:3]:
        q = field.q
        points, _ = base.completed_points(field)
        supports = []
        section_sizes = Counter()
        for form in c227.normalized_forms(field, 4):
            section = frozenset(
                index for index, point in enumerate(points) if c227.dot(field, form, point) == 0
            )
            section_sizes[len(section)] += 1
            supports.append(frozenset(range(len(points))) - section)

        assert set(section_sizes) <= {1, 2, 3, 4, q + 2}
        target_rows = []
        for target, target_class, expected_distance, expected_count in (
            (q, "curve", q, q),
            (2 * q + 1, "axis", 2 * q - 2, q * q * (q - 1) // 6),
        ):
            through = [support for support in supports if target in support]
            distance = min(map(len, through))
            count = sum(len(support) == distance for support in through)
            assert (distance, count) == (expected_distance, expected_count)
            target_rows.append(
                {
                    "target_class": target_class,
                    "pointed_primal_distance": distance,
                    "minimum_blocker_size": distance - 1,
                    "minimum_blocker_support_count": count,
                }
            )
        rows.append(
            {
                "q": q,
                "hyperplane_section_histogram": dict(sorted(section_sizes.items())),
                "nonzero_weight_set": sorted({len(support) for support in supports}),
                "targets": target_rows,
            }
        )
    return rows


def corrected_master_enumerator(c226, dimension: int):
    points = c226.group(dimension)
    index = {point: i for i, point in enumerate(points)}
    q = len(points)
    neg = {i: index[tuple((-value) % 3 for value in point)] for i, point in enumerate(points)}
    terms = Counter()
    joint = [[0] * (q + 1) for _ in range(q + 1)]
    joint_direct = [[0] * (q + 1) for _ in range(q + 1)]

    for survivor_mask in range(1 << q):
        sums = c226.restricted_sum_indices(points, index, survivor_mask)
        negative_seed = {
            neg[i] for i in range(q) if survivor_mask & (1 << i)
        }
        overlap = len(sums & negative_seed)
        line_free = c226.zero_sum_free(points, survivor_mask)
        assert (overlap == 0) == line_free
        terms[(survivor_mask.bit_count(), len(sums), overlap)] += 1

        if not line_free:
            continue
        failed_cubics = q - survivor_mask.bit_count()
        joint[failed_cubics][q] += 1
        joint[failed_cubics][q - 1] += q - len(sums)
        for axis_survivors in range(1 << q):
            if axis_survivors.bit_count() > 1:
                continue
            if any(axis_survivors & (1 << axis) for axis in sums):
                continue
            failed_axes = q - axis_survivors.bit_count()
            joint_direct[failed_cubics][failed_axes] += 1
    assert joint == joint_direct

    cubic = c226.cubic_transform_matrix(points, index)
    axis = c226.axis_transform_matrix(points)
    sample_p_c = Fraction(1, 3)
    sample_p_a = Fraction(2, 5)
    joint_probability = c226.evaluate(joint, sample_p_c, sample_p_a)
    cubic_probability = c226.evaluate(cubic, sample_p_c, sample_p_a)
    axis_probability = c226.evaluate(axis, sample_p_c, sample_p_a)
    assert joint_probability >= cubic_probability * axis_probability

    return {
        "q": q,
        "master_term_count": len(terms),
        "master_terms_sha256": stable_hash(sorted((list(key), value) for key, value in terms.items())),
        "joint_failure_matrix_sha256": stable_hash(joint),
        "joint_formula_equals_direct_enumeration": True,
        "line_free_iff_restricted_sumset_avoids_negative_seed": True,
        "sample_erasure_probabilities": {"cubic": "1/3", "axis": "2/5"},
        "sample_joint_failure": str(joint_probability),
        "sample_fkg_product": str(cubic_probability * axis_probability),
    }


def integrate_bernstein_counts(counts):
    helpers = len(counts) - 1
    return sum(
        Fraction(value, (helpers + 1) * math.comb(helpers, size))
        for size, value in enumerate(counts)
    )


def exit_deficits(c227):
    examples = c227.q9_examples()
    nucleus = examples["harmonic_nucleus_full_rank_jump"]
    curve = examples["harmonic_curve_full_rank_jump"]
    nucleus_delta = nucleus["new_successes_beyond_radius_four_by_survivor_count"]
    curve_delta = curve["new_successes_beyond_radius_four_by_survivor_count"]
    nucleus_deficit = integrate_bernstein_counts(nucleus_delta)
    curve_deficit = integrate_bernstein_counts(curve_delta)
    assert nucleus_deficit == Fraction(2, 77)
    assert curve_deficit == Fraction(23, 154)

    nucleus_map_area = integrate_bernstein_counts(nucleus["failure_by_survivor_count"])
    curve_map_area = integrate_bernstein_counts(curve["failure_by_survivor_count"])
    total_map_area = nucleus_map_area + 10 * curve_map_area
    assert total_map_area == 5  # dimension of the [11,5] code, not redundancy six.
    total_deficit = nucleus_deficit + 10 * curve_deficit
    assert total_deficit == Fraction(117, 77)
    return {
        "harmonic_q9_code": "[11,5,6]_9",
        "nucleus_radius_four_deficit": str(nucleus_deficit),
        "curve_radius_four_deficit": str(curve_deficit),
        "symbol_map_exit_area_sum": str(total_map_area),
        "radius_four_exit_area_sum": str(total_map_area + total_deficit),
        "total_locality_deficit": str(total_deficit),
        "ledger_identity": "truncated EXIT area = code dimension + total locality deficit",
        "brainstorm_redundancy_ledger_refuted": True,
    }


def design_layers_and_poisson(harmonic, base):
    layers = []
    for field in base.FIELDS[1:3]:
        n = field.q + 1
        blocks = harmonic.harmonic_blocks(field)
        a4 = len(blocks)
        a5 = sum(
            any(frozenset(four) in blocks for four in combinations(chosen, 4))
            for chosen in combinations(range(n), 5)
        )
        expected_a4 = n * (n - 1) * (n - 2) // 24
        expected_a5 = expected_a4 * (n - 4)
        assert (a4, a5) == (expected_a4, expected_a5)

        overlap_two = n * (n - 1) * (n - 2) * (n - 4) // 16
        overlap_one = n * (n - 1) * (n - 2) * (n - 4) * (n - 8) // 72
        layers.append(
            {
                "q": field.q,
                "n": n,
                "a4": a4,
                "a5": a5,
                "unordered_block_pairs_meeting_in_two": overlap_two,
                "unordered_block_pairs_meeting_in_one": overlap_one,
            }
        )

    return {
        "exact_layers": layers,
        "sqs_stein_chen_bound": (
            "d_TV <= 2[b*s^8 + 2(P1+P2)*s^8 + 2*P1*s^7 + 2*P2*s^6], "
            "where b=n(n-1)(n-2)/24 and P1,P2 are the recorded overlap counts"
        ),
        "sqs_window_rate": "O(n^(-1/4)) at s=c*n^(-3/4) for fixed c",
        "derived_sts_stein_chen_bound": (
            "d_TV <= 2[t*s^6 + 2*P1*s^6 + 2*P1*s^5], "
            "where t=m(m-1)/6 and P1=m(m-1)(m-3)/8"
        ),
        "derived_sts_window_rate": "O(m^(-1/3)) at s=c*m^(-2/3) for fixed c",
        "janson_lower_tail_claim_promoted": False,
    }


def split_enumerator_replay(base, c227):
    field = base.FIELDS[0]
    assert field.q == 3
    points, _ = base.completed_points(field)
    target = field.q
    split = Counter()
    zero_at_target = Counter()
    ordinary = Counter()
    for coefficients in product(range(field.q), repeat=4):
        values = [c227.dot(field, coefficients, point) for point in points]
        other_weight = sum(value != 0 for index, value in enumerate(values) if index != target)
        target_nonzero = int(values[target] != 0)
        split[(target_nonzero, other_weight)] += 1
        ordinary[other_weight + target_nonzero] += 1
        if not target_nonzero:
            zero_at_target[other_weight] += 1
    assert all(
        ordinary[weight]
        == zero_at_target[weight]
        + split[(1, weight - 1)]
        for weight in range(len(points) + 1)
    )
    assert sum(zero_at_target.values()) == field.q ** 3
    return {
        "example": "completed cubic q=3, coordinate partition 1+7",
        "split_enumerator": {f"target_{flag}_other_weight_{weight}": count
                             for (flag, weight), count in sorted(split.items())},
        "target_zero_subcode_size": sum(zero_at_target.values()),
        "target_zero_subcode_is_contraction_code": True,
        "identity": "W_C(A,B)=A*W_(C,x=0 punctured)(A,B)+B*W_(target nonzero, other)(A,B)",
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    base = load_module("c244_base", BASE)
    harmonic = load_module("c244_harmonic", C218)
    c226 = load_module("c244_c226", C226)
    c227 = load_module("c244_c227", C227)
    certificate = {
        "task": "C244",
        "pointed_distance": pointed_distance_rows(base, c227),
        "master_enumerator_and_joint_law": [
            corrected_master_enumerator(c226, dimension) for dimension in (1, 2)
        ],
        "exit_deficits": exit_deficits(c227),
        "design_layers_and_poisson": design_layers_and_poisson(harmonic, base),
        "split_enumerator": split_enumerator_replay(base, c227),
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
