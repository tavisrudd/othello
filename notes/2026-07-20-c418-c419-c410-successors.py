#!/usr/bin/env python3
"""C418 named seven-point balanced-trade gate over F_7."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from itertools import combinations, product
from pathlib import Path

Q = 7
Vector = tuple[int, int, int]
OUT = Path(__file__).with_suffix(".json")


def canonical(value: object) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def digest(value: object) -> str:
    return hashlib.sha256(canonical(value).encode()).hexdigest()


def normalize(v: Vector) -> Vector:
    for x in v:
        if x % Q:
            z = pow(x, -1, Q)
            return tuple((z * y) % Q for y in v)  # type: ignore[return-value]
    raise ValueError("zero projective vector")


def objects() -> tuple[Vector, ...]:
    return tuple(sorted({normalize(v) for v in product(range(Q), repeat=3) if any(v)}))


def dot(a: Vector, b: Vector) -> int:
    return sum(x * y for x, y in zip(a, b)) % Q


def cross(a: Vector, b: Vector) -> Vector:
    return normalize(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        )
    )


def determinant(a: Vector, b: Vector, c: Vector) -> int:
    return dot(a, cross(b, c))


def rank_mod(rows: list[list[int]]) -> int:
    if not rows:
        return 0
    a = [[x % Q for x in row] for row in rows]
    rank = 0
    for col in range(len(a[0])):
        pivot = next((i for i in range(rank, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        inv = pow(a[rank][col], -1, Q)
        a[rank] = [(inv * x) % Q for x in a[rank]]
        for i in range(len(a)):
            if i != rank and a[i][col]:
                z = a[i][col]
                a[i] = [(x - z * y) % Q for x, y in zip(a[i], a[rank])]
        rank += 1
    return rank


def pretest(parts: tuple[tuple[tuple[int, ...], ...], ...], ground_size: int) -> dict[str, object]:
    centered_parts: list[list[list[int]]] = []
    for part in parts:
        inv = pow(len(part), -1, Q)
        centroid = [
            sum(int(j in block) for block in part) * inv % Q for j in range(ground_size)
        ]
        centered_parts.append(
            [
                [(int(j in block) - centroid[j]) % Q for j in range(ground_size)]
                for block in part
            ]
        )
    rows = [row for part in centered_parts for row in part]
    restriction_ranks = [rank_mod(part) for part in centered_parts]
    feature_rank = rank_mod(rows)
    moment = [
        [sum(row[i] * row[j] for row in rows) % Q for j in range(ground_size)]
        for i in range(ground_size)
    ]
    moment_rank = rank_mod(moment)
    radical_dimension = feature_rank - moment_rank
    restriction_full = all(
        rank == len(part) - 1 for rank, part in zip(restriction_ranks, parts)
    )
    radical_one = radical_dimension == 1
    return {
        "part_sizes": [len(part) for part in parts],
        "restriction_ranks": restriction_ranks,
        "zero_sum_hyperplane_dimensions": [len(part) - 1 for part in parts],
        "restriction_full": restriction_full,
        "centered_feature_rank": feature_rank,
        "second_moment_rank": moment_rank,
        "second_moment_radical_dimension": radical_dimension,
        "radical_one_dimensional": radical_one,
        "radical_separates_parts": False,
        "rigidity_pretest_passes": restriction_full and radical_one,
        "eligible_defect_quotient_dimension": radical_dimension if radical_dimension else feature_rank,
    }


def plane() -> tuple[
    tuple[Vector, ...], tuple[Vector, ...], tuple[int, ...], tuple[tuple[int, ...], ...]
]:
    points = objects()
    lines = objects()
    line_masks = tuple(
        sum(1 << i for i, point in enumerate(points) if dot(line, point) == 0)
        for line in lines
    )
    point_lines = tuple(
        tuple(i for i, mask in enumerate(line_masks) if mask & (1 << point))
        for point in range(len(points))
    )
    return points, lines, line_masks, point_lines


def intersection_blocks(lines: tuple[Vector, ...]) -> dict[Vector, tuple[int, ...]]:
    blocks: dict[Vector, set[int]] = defaultdict(set)
    for i, j in combinations(range(len(lines)), 2):
        point = cross(lines[i], lines[j])
        blocks[point].update((i, j))
    return {point: tuple(sorted(indices)) for point, indices in sorted(blocks.items())}


def characteristic(lines: tuple[Vector, ...]) -> tuple[int, int, int, int]:
    singular_sum = sum(len(block) - 1 for block in intersection_blocks(lines).values())
    return (len(lines) - 1 - singular_sum, singular_sum, -len(lines), 1)


def weighted_depth(lines: tuple[Vector, ...]) -> dict[str, object]:
    singular = intersection_blocks(lines)
    adjoint = tuple(singular)
    weights = tuple(len(singular[p]) - 1 for p in adjoint)
    blocks = intersection_blocks(adjoint)
    incident = [set() for _ in adjoint]
    for point, indices in blocks.items():
        for index in indices:
            incident[index].add(point)
    coeffs: dict[int, list[int]] = {
        0: [1, 1 - len(adjoint), 1 - len(adjoint) + sum(len(v) - 1 for v in blocks.values())]
    }
    for i, weight in enumerate(weights):
        coeffs.setdefault(weight, [0, 0, 0])
        coeffs[weight][1] += 1
        coeffs[weight][2] += 1 - len(incident[i])
    correction = Counter()
    for indices in blocks.values():
        depth = sum(weights[i] for i in indices)
        correction[depth] += 1
        coeffs.setdefault(depth, [0, 0, 0])
        coeffs[depth][2] += 1
    direct = Counter(
        sum(weight for line, weight in zip(adjoint, weights) if dot(line, point) == 0)
        for point in objects()
    )
    evaluated = Counter(
        {depth: Q * Q * poly[0] + Q * poly[1] + poly[2] for depth, poly in coeffs.items()}
    )
    if direct != evaluated:
        raise AssertionError("universal depth polynomial does not evaluate at F_7")
    return {
        "adjoint_line_count": len(adjoint),
        "indexed_copy_count": sum(weights),
        "projective_depth_count_polynomials_q2_q_1": {
            str(depth): poly for depth, poly in sorted(coeffs.items()) if any(poly)
        },
        "cross_incidence_correction_by_depth": {
            str(depth): count for depth, count in sorted(correction.items())
        },
    }


def profiles(
    mask: int, line_masks: tuple[int, ...], point_lines: tuple[tuple[int, ...], ...]
) -> dict[str, object]:
    sizes = tuple((mask & line).bit_count() for line in line_masks)
    coordinate = []
    syndrome = []
    for point, incident in enumerate(point_lines):
        if mask & (1 << point):
            coordinate.append(
                (
                    sum((sizes[line] - 1) * (sizes[line] - 2) // 2 for line in incident),
                    sum((sizes[line] - 1) // 2 for line in incident),
                )
            )
        else:
            syndrome.append(sum(sizes[line] * (sizes[line] - 1) // 2 for line in incident))
    return {
        "line_section_histogram": [list(item) for item in sorted(Counter(sizes).items())],
        "coordinate_repair_availability": [list(item) for item in sorted(coordinate)],
        "excluded_syndrome_multiplicities": sorted(syndrome),
        "excluded_syndrome_histogram": [
            list(item) for item in sorted(Counter(syndrome).items())
        ],
        "punctured_dual_weight_two_counts": sorted((Q - 1) * r for r, _ in coordinate),
    }


def arrangement_record(
    mask: int,
    points: tuple[Vector, ...],
    lines: tuple[Vector, ...],
    line_masks: tuple[int, ...],
    point_lines: tuple[tuple[int, ...], ...],
) -> dict[str, object]:
    arrangement = tuple(lines[i] for i, line in enumerate(line_masks) if not line & mask)
    u = {
        "characteristic_polynomial_ascending": list(characteristic(arrangement)),
        "weighted_adjoint": weighted_depth(arrangement),
    }
    p = profiles(mask, line_masks, point_lines)
    complement = {
        i
        for i in range(len(points))
        if all(dot(points[i], line) != 0 for line in arrangement)
    }
    common_points = [
        list(point) for point in points if all(dot(point, line) == 0 for line in arrangement)
    ]
    point_indices = [i for i in range(len(points)) if mask & (1 << i)]
    spanning = any(
        determinant(points[i], points[j], points[k])
        for i, j, k in combinations(point_indices, 3)
    )
    return {
        "mask": mask,
        "points": [list(points[i]) for i in point_indices],
        "U": u,
        "P": p,
        "U_digest": digest(u),
        "P_digest": digest(
            {
                "coordinate": p["coordinate_repair_availability"],
                "syndrome": p["excluded_syndrome_multiplicities"],
                "puncture": p["punctured_dual_weight_two_counts"],
            }
        ),
        "checks": {
            "simple_size_seven": len(point_indices) == 7,
            "spanning": spanning,
            "external_closure_recovers_complement": complement == set(point_indices),
            "essential_arrangement": not common_points,
            "arrangement_line_count": len(arrangement),
        },
    }


def extension_family(
    base: tuple[Vector, ...],
    points: tuple[Vector, ...],
    lines: tuple[Vector, ...],
    line_masks: tuple[int, ...],
    point_lines: tuple[tuple[int, ...], ...],
) -> list[dict[str, object]]:
    index = {point: i for i, point in enumerate(points)}
    base_mask = sum(1 << index[point] for point in base)
    return [
        arrangement_record(
            base_mask | (1 << added), points, lines, line_masks, point_lines
        )
        for added in range(len(points))
        if not base_mask & (1 << added)
    ]


def fibre_summary(records: list[dict[str, object]]) -> dict[str, object]:
    fibres: dict[str, list[dict[str, object]]] = defaultdict(list)
    for record in records:
        fibres[record["U_digest"]].append(record)
    separating = [
        fibre for _, fibre in sorted(fibres.items()) if len({r["P_digest"] for r in fibre}) > 1
    ]
    return {
        "candidate_count": len(records),
        "U_fibre_count": len(fibres),
        "largest_U_fibre": max(map(len, fibres.values())),
        "pointed_separating_U_fibres": len(separating),
    }


def first_separator(records: list[dict[str, object]]) -> tuple[dict[str, object], dict[str, object]]:
    fibres: dict[str, list[dict[str, object]]] = defaultdict(list)
    for record in records:
        fibres[record["U_digest"]].append(record)
    for _, fibre in sorted(fibres.items()):
        ordered = sorted(fibre, key=lambda r: r["mask"])
        for left, right in combinations(ordered, 2):
            if left["P_digest"] != right["P_digest"]:
                return left, right
    raise AssertionError("no pointed separator")


def first_cross_separator(
    left_records: list[dict[str, object]], right_records: list[dict[str, object]]
) -> tuple[dict[str, object], dict[str, object]]:
    left_fibres: dict[str, list[dict[str, object]]] = defaultdict(list)
    right_fibres: dict[str, list[dict[str, object]]] = defaultdict(list)
    for record in left_records:
        left_fibres[record["U_digest"]].append(record)
    for record in right_records:
        right_fibres[record["U_digest"]].append(record)
    for key in sorted(set(left_fibres) & set(right_fibres)):
        for left in sorted(left_fibres[key], key=lambda r: r["mask"]):
            for right in sorted(right_fibres[key], key=lambda r: r["mask"]):
                if left["P_digest"] != right["P_digest"]:
                    return left, right
    raise AssertionError("no cross-leg pointed separator")


def histogram_difference(left: list[int], right: list[int]) -> dict[str, object]:
    difference = Counter(left)
    difference.subtract(right)
    coefficients = {
        degree: count for degree, count in sorted(difference.items()) if count
    }
    return {
        "coefficients_ascending": {
            str(degree): count for degree, count in coefficients.items()
        },
        "raw_moments_0_through_3": [
            sum(count * degree**moment for degree, count in coefficients.items())
            for moment in range(4)
        ],
    }


def triple_degree_sequence(
    record: dict[str, object], points: tuple[Vector, ...], line_masks: tuple[int, ...]
) -> list[int]:
    mask = record["mask"]
    indices = [i for i in range(len(points)) if mask & (1 << i)]
    triples = [
        {i for i in indices if line & (1 << i)}
        for line in line_masks
        if (mask & line).bit_count() == 3
    ]
    return sorted(sum(i in triple for triple in triples) for i in indices)


def base_depth_formula_holds(
    record: dict[str, object],
    points: tuple[Vector, ...],
    lines: tuple[Vector, ...],
    line_masks: tuple[int, ...],
) -> bool:
    mask = record["mask"]
    arrangement = tuple(lines[i] for i, line in enumerate(line_masks) if not line & mask)
    singular = intersection_blocks(arrangement)
    adjoint = tuple(singular)
    weights = tuple(len(singular[p]) - 1 for p in adjoint)
    count = len(arrangement)
    for line, line_mask in zip(lines, line_masks):
        section = (mask & line_mask).bit_count()
        depth = sum(weight for point, weight in zip(adjoint, weights) if dot(line, point) == 0)
        expected = count - 1 if section == 0 else count - Q - 1 + section
        if depth != expected:
            return False
    return True


def all_point_secant_loads(
    record: dict[str, object],
    line_masks: tuple[int, ...],
    point_lines: tuple[tuple[int, ...], ...],
) -> list[int]:
    mask = record["mask"]
    sizes = [(mask & line).bit_count() for line in line_masks]
    return [
        sum(sizes[line] * (sizes[line] - 1) // 2 for line in incident)
        for incident in point_lines
    ]


def weighted_distinct_secant_concurrence(
    record: dict[str, object],
    line_masks: tuple[int, ...],
    point_lines: tuple[tuple[int, ...], ...],
) -> int:
    mask = record["mask"]
    pair_multiplicities = [
        (mask & line).bit_count() * ((mask & line).bit_count() - 1) // 2
        for line in line_masks
    ]
    return sum(
        sum(
            pair_multiplicities[a] * pair_multiplicities[b] * pair_multiplicities[c]
            for a, b, c in combinations(incident, 3)
        )
        for incident in point_lines
    )


def build_certificate() -> dict[str, object]:
    points, lines, line_masks, point_lines = plane()
    pasch_plus = ((0, 1, 2), (0, 3, 4), (1, 3, 5), (2, 4, 5))
    pasch_minus = ((0, 1, 3), (0, 2, 4), (1, 2, 5), (3, 4, 5))
    endpoint_plus = ((0, 1, 4), (2, 3, 5))
    endpoint_minus = ((0, 2, 4), (1, 3, 5))
    incidence_plus = ((0, 2), (1, 3))
    incidence_minus = ((0, 3), (1, 2))
    pretests = {
        "pasch": pretest((pasch_plus, pasch_minus), 6),
        "four_endpoint": pretest((endpoint_plus, endpoint_minus), 6),
        "common_core_pasch": pretest(
            (
                tuple(tuple(block) + (6,) for block in pasch_plus),
                tuple(tuple(block) + (6,) for block in pasch_minus),
            ),
            7,
        ),
        "incidence_2_switch": pretest((incidence_plus, incidence_minus), 4),
    }
    frame_lines = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
    pasch_base = tuple(
        cross(frame_lines[i], frame_lines[j]) for i, j in combinations(range(4), 2)
    )
    disjoint_base = (
        (1, 0, 0),
        (1, 1, 0),
        (1, 2, 0),
        (1, 3, 1),
        (1, 4, 1),
        (1, 5, 1),
    )
    shared_base = (
        (1, 0, 0),
        (1, 1, 0),
        (1, 2, 0),
        (1, 0, 1),
        (1, 0, 2),
        (1, 1, 2),
    )
    pasch_records = extension_family(
        pasch_base, points, lines, line_masks, point_lines
    )
    endpoint_records = extension_family(
        disjoint_base, points, lines, line_masks, point_lines
    )
    shared_records = extension_family(
        shared_base, points, lines, line_masks, point_lines
    )
    combined = endpoint_records + shared_records
    left, right = first_cross_separator(endpoint_records, shared_records)
    if left["U"] != right["U"] or left["P_digest"] == right["P_digest"]:
        raise AssertionError("invalid separator")
    if not all(left["checks"].values()) or not all(right["checks"].values()):
        raise AssertionError("witness fails a realizability check")
    left_repairs = [item[0] for item in left["P"]["coordinate_repair_availability"]]
    right_repairs = [item[0] for item in right["P"]["coordinate_repair_availability"]]
    repair_difference = histogram_difference(left_repairs, right_repairs)
    syndrome_difference = histogram_difference(
        left["P"]["excluded_syndrome_multiplicities"],
        right["P"]["excluded_syndrome_multiplicities"],
    )
    if repair_difference["raw_moments_0_through_3"][:3] != [0, 0, -2]:
        raise AssertionError("unexpected repair closeout moments")
    if syndrome_difference["raw_moments_0_through_3"][:3] != [0, 0, 2]:
        raise AssertionError("unexpected syndrome closeout moments")
    left_loads = all_point_secant_loads(left, line_masks, point_lines)
    right_loads = all_point_secant_loads(right, line_masks, point_lines)
    load_difference = histogram_difference(left_loads, right_loads)
    if load_difference["raw_moments_0_through_3"] != [0, 0, 0, -12]:
        raise AssertionError("unexpected all-point secant-load moments")
    for record, loads in ((left, left_loads), (right, right_loads)):
        inside = sorted(load for point, load in enumerate(loads) if record["mask"] & (1 << point))
        outside = sorted(
            load for point, load in enumerate(loads) if not record["mask"] & (1 << point)
        )
        if inside != sorted(
            6 + repair for repair, _ in record["P"]["coordinate_repair_availability"]
        ):
            raise AssertionError("inside secant-load identity fails")
        if outside != record["P"]["excluded_syndrome_multiplicities"]:
            raise AssertionError("outside secant-load identity fails")
    left_concurrence = weighted_distinct_secant_concurrence(left, line_masks, point_lines)
    right_concurrence = weighted_distinct_secant_concurrence(right, line_masks, point_lines)
    if (left_concurrence, right_concurrence) != (166, 168):
        raise AssertionError("unexpected weighted secant concurrence")
    return {
        "schema": "c418-named-balanced-trades-v1",
        "field": 7,
        "pretests": pretests,
        "structural_filters": {
            "common_core_pasch": {
                "status": "projectively_unrealizable",
                "reason": (
                    "two distinct common-core block-lines would contain both the core "
                    "and their Pasch intersection point"
                ),
            }
        },
        "family_scans_before_stop": {
            "pasch_plus_one_point": fibre_summary(pasch_records),
            "four_endpoint_disjoint_secants_plus_one_point": fibre_summary(endpoint_records),
            "c408_common_named_seventh_point": fibre_summary(combined),
        },
        "stop": {
            "reason": "first exact seven-point pointed separator found",
            "eight_point_gate_opened": False,
            "incidence_2_switch_generated": False,
        },
        "kernel_witness": {
            "integer_coefficients": [1, -1],
            "primitive": True,
            "same_U": True,
            "different_P": True,
            "left": left,
            "right": right,
        },
        "ej_tt_closeout": {
            "base_field_adjoint_depth_formula": (
                "D(L)=N-1 for external L; D(L)=N-q-1+|B intersect L| otherwise"
            ),
            "base_field_depth_formula_verified": {
                "left": base_depth_formula_holds(left, points, lines, line_masks),
                "right": base_depth_formula_holds(right, points, lines, line_masks),
            },
            "triple_secant_degree_sequences": {
                "left": triple_degree_sequence(left, points, line_masks),
                "right": triple_degree_sequence(right, points, line_masks),
            },
            "repair_histogram_difference_left_minus_right": repair_difference,
            "repair_polynomial_factorization": "-x(x-1)^2",
            "syndrome_histogram_difference_left_minus_right": syndrome_difference,
            "syndrome_polynomial_factorization": "x^2(x-1)^2(x^2+x-1)",
            "settled": [
                "base-field adjoint depth equality follows from the common line-section histogram",
                "repair, puncture, and syndrome separation first survives quadratically",
                "the quadratic separator is invariant under translating the pointed scalar gauge",
            ],
            "open_mystery": (
                "a conceptual local bijection explaining equality of every universal Q-coefficient "
                "beyond the certified cross-incidence ledger is not yet known"
            ),
            "tt_opportunities": [
                {
                    "opportunity": "minimal pointed quadratic completion",
                    "content": (
                        "the first missing repair and syndrome moments are quadratic, so adjoining "
                        "that pointed tensor is the cheapest invariant that separates the witness"
                    ),
                    "status": "free consequence recorded; no new task required",
                },
                {
                    "opportunity": "localize the unexplained universal equality",
                    "content": (
                        "the base-field depth and cross-incidence terms follow from the section "
                        "histogram; only the universal Q-coefficient matching still lacks a hand bijection"
                    ),
                    "status": "open mystery",
                },
                {
                    "opportunity": "C419 calibration candidate",
                    "content": (
                        "the shared-base extension scan also contains a same-leg U collision with "
                        "different P, suggesting an immediate fixed-incidence-moduli calibration"
                    ),
                    "status": "incidental lead logged; outside C418 stop rule",
                },
            ],
        },
        "ej2_closeout": {
            "all_point_secant_load_definition": (
                "lambda_B(X)=sum_{L through X} binom(|B intersect L|,2)"
            ),
            "inside_outside_identity": {
                "inside": "lambda_B(P)=6+R(P) for P in B",
                "outside": "lambda_B(Q)=mu(Q) for Q outside B",
                "verified_on_both_witnesses": True,
            },
            "all_point_histogram_difference_left_minus_right": load_difference,
            "all_point_polynomial_factorization": (
                "-x^2(x-1)^3(x^4+x^3+x^2-1)"
            ),
            "interpretation": (
                "the inside and outside quadratic defects cancel; forgetting the boundary restores "
                "exact strength two with first global survival cubic"
            ),
            "opportunity": (
                "lambda_B is a natural unpointed cubic separator outside U, while its inside/outside "
                "split is the minimal pointed quadratic completion"
            ),
        },
        "ej3_reusable_mechanism": {
            "notation": [
                "s_L=|B intersect L|",
                "m_L=binom(s_L,2)",
                "lambda_B(X)=sum_{L through X}m_L",
            ],
            "factorial_moment_identities": {
                "order_1": "sum_X binom(lambda_X,1)=(q+1)sum_L m_L",
                "order_2": (
                    "sum_X binom(lambda_X,2)=(q+1)sum_L binom(m_L,2)"
                    "+sum_{L<M}m_L m_M"
                ),
                "order_3": (
                    "sum_X binom(lambda_X,3)=(q+1)sum_L binom(m_L,3)"
                    "+sum_{L!=M}binom(m_L,2)m_M+C3(B)"
                ),
                "C3_definition": (
                    "C3(B)=sum_X sum_{distinct L1<L2<L3 through X}m_L1 m_L2 m_L3"
                ),
            },
            "consequence": (
                "equal line-section histograms force lambda moments through degree two; "
                "the raw cubic difference is 6 times the C3 difference"
            ),
            "witness_C3": {"left": left_concurrence, "right": right_concurrence},
            "witness_raw_cubic_check": 6 * (left_concurrence - right_concurrence),
            "reusable_proof_mechanism": (
                "classify selected pair-items by whether their supporting secants use one, two, "
                "or three distinct lines; only the three-line class asks for concurrency geometry"
            ),
        },
    }


def payload(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", action="store_true")
    group.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = payload(build_certificate())
    if args.write:
        OUT.write_bytes(data)
    elif not OUT.exists() or OUT.read_bytes() != data:
        raise SystemExit(f"stale or missing certificate: {OUT}")
    print(
        canonical(
            {
                "status": "ok",
                "certificate": str(OUT),
                "sha256": hashlib.sha256(data).hexdigest(),
            }
        )
    )


if __name__ == "__main__":
    main()
