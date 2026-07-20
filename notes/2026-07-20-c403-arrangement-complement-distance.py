#!/usr/bin/env python3
"""Exact C403 certificate for rank-three arrangement-complement codes.

The primary path derives Coxeter line spectra from weighted second-adjoint
depth ledgers.  The independent path enumerates points and lines of PG(2, 11)
for pinned arrangements, reconstructs every code weight directly, and checks
an infinite two-pencil formula on a grid of finite-field samples.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, defaultdict
from itertools import combinations
from pathlib import Path
from typing import Iterable


STEM = "2026-07-20-c403-arrangement-complement-distance"
ROOT = Path(__file__).resolve().parent
DEFAULT_OUTPUT = ROOT / f"{STEM}.json"


def normalize(vector: Iterable[int], prime: int) -> tuple[int, int, int]:
    values = tuple(value % prime for value in vector)
    for value in values:
        if value:
            inverse = pow(value, -1, prime)
            return tuple((entry * inverse) % prime for entry in values)  # type: ignore[return-value]
    raise ValueError("zero vector has no projective normalization")


def cross(
    left: tuple[int, int, int], right: tuple[int, int, int], prime: int
) -> tuple[int, int, int]:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        prime,
    )


def incident(
    line: tuple[int, int, int], point: tuple[int, int, int], prime: int
) -> bool:
    return sum(left * right for left, right in zip(line, point)) % prime == 0


def determinant(rows: tuple[tuple[int, int, int], ...], prime: int) -> int:
    if len(rows) != 3:
        raise ValueError("determinant expects exactly three rows")
    a, b, c = rows
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % prime


def matrix_vector(
    matrix: tuple[tuple[int, int, int], ...], vector: tuple[int, int, int], prime: int
) -> tuple[int, int, int]:
    return tuple(
        sum(row[index] * vector[index] for index in range(3)) % prime for row in matrix
    )  # type: ignore[return-value]


def matrix_product(
    left: tuple[tuple[int, int, int], ...],
    right: tuple[tuple[int, int, int], ...],
    prime: int,
) -> tuple[tuple[int, int, int], ...]:
    columns = tuple(zip(*right))
    return tuple(
        tuple(sum(row[index] * column[index] for index in range(3)) % prime for column in columns)
        for row in left
    )


def normalize_projective_matrix(
    matrix: tuple[tuple[int, int, int], ...], prime: int
) -> tuple[tuple[int, int, int], ...]:
    for row in matrix:
        for entry in row:
            if entry % prime:
                inverse = pow(entry % prime, -1, prime)
                return tuple(
                    tuple(value * inverse % prime for value in current) for current in matrix
                )
    raise ValueError("zero matrix has no projective normalization")


def reflection_matrix(
    root: tuple[int, int, int], prime: int
) -> tuple[tuple[int, int, int], ...]:
    length = sum(value * value for value in root) % prime
    matrix = tuple(
        tuple(
            (length * (1 if row == column else 0) - 2 * root[row] * root[column]) % prime
            for column in range(3)
        )
        for row in range(3)
    )
    if determinant(matrix, prime) == 0:
        raise AssertionError("degenerate reflection matrix")
    return normalize_projective_matrix(matrix, prime)


def projective_objects(prime: int) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        [(1, first, second) for first in range(prime) for second in range(prime)]
        + [(0, 1, first) for first in range(prime)]
        + [(0, 0, 1)]
    )


def arrangement(
    rows: Iterable[tuple[int, int, int]], prime: int
) -> tuple[tuple[int, int, int], ...]:
    result = tuple(sorted({normalize(row, prime) for row in rows}))
    if not any(determinant(triple, prime) for triple in combinations(result, 3)):
        raise AssertionError("arrangement is not essential of rank three")
    return result


def intersection_blocks(
    lines: tuple[tuple[int, int, int], ...], prime: int
) -> dict[tuple[int, int, int], tuple[int, ...]]:
    blocks: dict[tuple[int, int, int], set[int]] = defaultdict(set)
    for first, second in combinations(range(len(lines)), 2):
        point = cross(lines[first], lines[second], prime)
        blocks[point].update((first, second))
    return {point: tuple(sorted(indices)) for point, indices in blocks.items()}


def is_connected_matroid(
    lines: tuple[tuple[int, int, int], ...], prime: int
) -> bool:
    circuits: list[tuple[int, ...]] = []
    for triple in combinations(range(len(lines)), 3):
        if determinant(tuple(lines[index] for index in triple), prime) == 0:
            circuits.append(triple)
    for quadruple in combinations(range(len(lines)), 4):
        if all(
            determinant(tuple(lines[index] for index in triple), prime) != 0
            for triple in combinations(quadruple, 3)
        ):
            circuits.append(quadruple)
    adjacency = {index: set() for index in range(len(lines))}
    for circuit in circuits:
        for first, second in combinations(circuit, 2):
            adjacency[first].add(second)
            adjacency[second].add(first)
    reached = {0}
    frontier = [0]
    while frontier:
        current = frontier.pop()
        for neighbor in adjacency[current] - reached:
            reached.add(neighbor)
            frontier.append(neighbor)
    return len(reached) == len(lines)


def modular_singular_points(
    lines: tuple[tuple[int, int, int], ...],
    blocks: dict[tuple[int, int, int], tuple[int, ...]],
    prime: int,
) -> list[dict[str, object]]:
    line_set = set(lines)
    result: list[dict[str, object]] = []
    for point, indices in sorted(blocks.items()):
        if all(other == point or cross(point, other, prime) in line_set for other in blocks):
            result.append({"point": list(point), "multiplicity": len(indices)})
    return result


def polynomial_add(
    left: tuple[int, int, int], right: tuple[int, int, int]
) -> tuple[int, int, int]:
    return tuple(a + b for a, b in zip(left, right))  # type: ignore[return-value]


def polynomial_subtract(
    left: tuple[int, int, int], right: tuple[int, int, int]
) -> tuple[int, int, int]:
    return tuple(a - b for a, b in zip(left, right))  # type: ignore[return-value]


def polynomial_value(coefficients: tuple[int, int, int], value: int) -> int:
    return coefficients[0] + coefficients[1] * value + coefficients[2] * value * value


def polynomial_text(coefficients: tuple[int, int, int]) -> str:
    c0, c1, c2 = coefficients
    pieces: list[str] = []
    for coefficient, monomial in ((c2, "q^2"), (c1, "q"), (c0, "")):
        if not coefficient:
            continue
        magnitude = abs(coefficient)
        body = monomial if magnitude == 1 and monomial else f"{magnitude}{monomial}"
        if not monomial:
            body = str(magnitude)
        if not pieces:
            pieces.append(body if coefficient > 0 else f"-{body}")
        else:
            pieces.append((" + " if coefficient > 0 else " - ") + body)
    return "".join(pieces) if pieces else "0"


COXETER_LEDGERS = {
    "A3": {
        "mirrors": 6,
        "strata": (
            {"multiplicity": 2, "points": 3, "special_degree": 2},
            {"multiplicity": 3, "points": 4, "special_degree": 0},
        ),
        "special_delta_counts": {2: 3},
        "sample_q": 11,
    },
    "B3": {
        "mirrors": 9,
        "strata": (
            {"multiplicity": 2, "points": 6, "special_degree": 4},
            {"multiplicity": 3, "points": 4, "special_degree": 3},
            {"multiplicity": 4, "points": 3, "special_degree": 0},
        ),
        "special_delta_counts": {3: 16},
        "sample_q": 11,
    },
    "H3": {
        "mirrors": 15,
        "strata": (
            {"multiplicity": 2, "points": 15, "special_degree": 10},
            {"multiplicity": 3, "points": 10, "special_degree": 9},
            {"multiplicity": 5, "points": 6, "special_degree": 5},
        ),
        "special_delta_counts": {3: 40, 5: 66},
        "sample_q": 19,
    },
}


EXPECTED_COXETER_POLYNOMIALS = {
    "A3": {0: (9, -6, 1), 1: (-9, 3, 0), 2: (-5, 4, 0)},
    "B3": {
        0: (35, -12, 1),
        1: (-30, 6, 0),
        2: (-20, 4, 0),
        3: (7, 3, 0),
    },
    "H3": {
        0: (209, -30, 1),
        1: (-165, 15, 0),
        2: (-110, 10, 0),
        3: (40, 0, 0),
        4: (-54, 6, 0),
        5: (66, 0, 0),
    },
}


COXETER_ROOTS = {
    "A3": tuple(
        [(1, sign, 0) for sign in (-1, 1)]
        + [(1, 0, sign) for sign in (-1, 1)]
        + [(0, 1, sign) for sign in (-1, 1)]
    ),
}
COXETER_ROOTS["B3"] = (
    (1, 0, 0),
    (0, 1, 0),
    (0, 0, 1),
) + COXETER_ROOTS["A3"]


def h3_roots(tau: int) -> tuple[tuple[int, int, int], ...]:
    tau_minus_one = tau - 1
    return tuple(
        [(1, 0, 0), (0, 1, 0), (0, 0, 1)]
        + [
            cyclic
            for left_sign in (-1, 1)
            for right_sign in (-1, 1)
            for cyclic in (
                (1, left_sign * tau, right_sign * tau_minus_one),
                (left_sign * tau, right_sign * tau_minus_one, 1),
                (right_sign * tau_minus_one, 1, left_sign * tau),
            )
        ]
    )


COXETER_ROOTS["H3"] = h3_roots(4)


def burnside_orbit_count(name: str, field_order: int) -> dict[str, object]:
    epsilon_3 = int((field_order - 1) % 3 == 0)
    if name in ("A3", "B3"):
        epsilon_4 = int((field_order - 1) % 4 == 0)
        numerator = (
            field_order * field_order
            + 10 * field_order
            + 33
            + 16 * epsilon_3
            + 12 * epsilon_4
        )
        denominator = 24
        formula = "(q^2+10q+33+16 epsilon_3+12 epsilon_4)/24"
        indicators = {"epsilon_3": epsilon_3, "epsilon_4": epsilon_4}
    elif name == "H3":
        epsilon_5 = int((field_order - 1) % 5 == 0)
        numerator = (
            field_order * field_order
            + 16 * field_order
            + 75
            + 40 * epsilon_3
            + 48 * epsilon_5
        )
        denominator = 60
        formula = "(q^2+16q+75+40 epsilon_3+48 epsilon_5)/60"
        indicators = {"epsilon_3": epsilon_3, "epsilon_5": epsilon_5}
    else:
        raise ValueError(f"unknown Coxeter type: {name}")
    if numerator % denominator:
        raise AssertionError(f"{name}: Burnside orbit formula is not integral")
    return {
        "formula": formula,
        "root_of_unity_indicators": indicators,
        "orbit_count": numerator // denominator,
    }


def exact_quotient(numerator: int, denominator: int, label: str) -> int:
    if numerator % denominator:
        raise AssertionError(f"nonintegral {label}: {numerator}/{denominator}")
    return numerator // denominator


def depth_labelled_orbit_law(name: str, field_order: int) -> dict[str, object]:
    epsilon_3 = int((field_order - 1) % 3 == 0)
    if name == "A3":
        epsilon_4 = int((field_order - 1) % 4 == 0)
        orbit_counts = {
            "0": exact_quotient(field_order * field_order - 1, 24, "A3 depth zero"),
            "1": exact_quotient(field_order - 3 + 2 * epsilon_4, 4, "A3 depth one"),
            "2": exact_quotient(field_order + 7 + 4 * epsilon_3, 6, "A3 depth two"),
            "mirror": 1,
        }
        fixed_ledger = {
            "0": 6 * field_order - 10,
            "1": 3 * field_order - 9 + 12 * epsilon_4,
            "2": 33 + 16 * epsilon_3,
            "mirror": 18,
        }
    elif name == "B3":
        epsilon_4 = int((field_order - 1) % 4 == 0)
        orbit_counts = {
            "0": exact_quotient(
                (field_order - 5) * (field_order - 7), 24, "B3 depth zero"
            ),
            "1": exact_quotient(field_order - 5, 2, "B3 depth one"),
            "2": exact_quotient(field_order - 5 + 4 * epsilon_3, 6, "B3 depth two"),
            "3": exact_quotient(field_order + 5 + 2 * epsilon_4, 4, "B3 depth three"),
            "mirror": 2,
        }
        fixed_ledger = {
            "0": 0,
            "1": 6 * field_order - 30,
            "2": 16 * epsilon_3,
            "3": 3 * field_order + 23 + 12 * epsilon_4,
            "mirror": 39,
        }
    elif name == "H3":
        epsilon_5 = int((field_order - 1) % 5 == 0)
        orbit_counts = {
            "0": exact_quotient(
                (field_order - 11) * (field_order - 19), 60, "H3 depth zero"
            ),
            "1": exact_quotient(field_order - 11, 2, "H3 depth one"),
            "2": exact_quotient(field_order - 11 + 4 * epsilon_3, 6, "H3 depth two"),
            "3": 2,
            "4": exact_quotient(field_order - 9 + 8 * epsilon_5, 10, "H3 depth four"),
            "5": 3,
            "mirror": 1,
        }
        fixed_ledger = {
            "0": 0,
            "1": 15 * (field_order - 11),
            "2": 40 * epsilon_3,
            "3": 80,
            "4": 48 * epsilon_5,
            "5": 114,
            "mirror": 45,
        }
    else:
        raise ValueError(f"unknown Coxeter type: {name}")
    return {
        "orbit_counts": {key: value for key, value in orbit_counts.items() if value},
        "aggregate_nonidentity_fixed_incidence": {
            key: value for key, value in fixed_ledger.items() if value
        },
    }


def projective_matrix_order(
    matrix: tuple[tuple[int, int, int], ...], prime: int
) -> int:
    identity = normalize_projective_matrix(((1, 0, 0), (0, 1, 0), (0, 0, 1)), prime)
    power = identity
    for order in range(1, 61):
        power = normalize_projective_matrix(matrix_product(power, matrix, prime), prime)
        if power == identity:
            return order
    raise AssertionError("projective matrix order exceeds Coxeter group order")


def coxeter_orbit_certificate(
    name: str,
    prime: int,
    roots: tuple[tuple[int, int, int], ...] | None = None,
) -> dict[str, object]:
    roots = COXETER_ROOTS[name] if roots is None else roots
    lines = arrangement(roots, prime)
    line_set = set(lines)
    blocks = intersection_blocks(lines, prime)
    weights = {point: len(indices) - 1 for point, indices in blocks.items()}
    generators = tuple(reflection_matrix(root, prime) for root in roots)
    identity = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    group = {normalize_projective_matrix(identity, prime)}
    frontier = list(group)
    while frontier:
        current = frontier.pop()
        for generator in generators:
            product = normalize_projective_matrix(
                matrix_product(current, generator, prime), prime
            )
            if product not in group:
                group.add(product)
                frontier.append(product)
    for matrix in group:
        if {
            normalize(matrix_vector(matrix, line, prime), prime) for line in lines
        } != line_set:
            raise AssertionError(f"{name}: generated matrix does not preserve the arrangement")

    universe = projective_objects(prime)
    depth_by_line = {
        line: sum(weight for point, weight in weights.items() if incident(line, point, prime))
        for line in universe
    }
    remaining = set(universe)
    orbit_rows: list[dict[str, object]] = []
    while remaining:
        seed = min(remaining)
        orbit = {
            normalize(matrix_vector(matrix, seed, prime), prime) for matrix in group
        }
        remaining -= orbit
        depths = {depth_by_line[line] for line in orbit}
        mirror_flags = {line in line_set for line in orbit}
        if len(depths) != 1 or len(mirror_flags) != 1:
            raise AssertionError(f"{name}: orbit does not have constant weighted depth/type")
        orbit_rows.append(
            {
                "representative": list(seed),
                "size": len(orbit),
                "weighted_depth": next(iter(depths)),
                "mirror": next(iter(mirror_flags)),
            }
        )
    orbit_rows.sort(
        key=lambda row: (
            bool(row["mirror"]), int(row["weighted_depth"]), int(row["size"]), row["representative"]
        )
    )
    nonmirror_depth_counts: Counter[int] = Counter()
    for row in orbit_rows:
        if not row["mirror"]:
            nonmirror_depth_counts[int(row["weighted_depth"])] += int(row["size"])
    expected = {
        depth: polynomial_value(coefficients, prime)
        for depth, coefficients in EXPECTED_COXETER_POLYNOMIALS[name].items()
        if polynomial_value(coefficients, prime) > 0
    }
    if nonmirror_depth_counts != Counter(expected):
        raise AssertionError(f"{name}: orbit sum does not recover the weighted depth spectrum")
    burnside = burnside_orbit_count(name, prime)
    if len(orbit_rows) != burnside["orbit_count"]:
        raise AssertionError(f"{name}: direct orbits disagree with Burnside formula")
    observed_orbits_by_depth: Counter[str] = Counter(
        "mirror" if row["mirror"] else str(row["weighted_depth"]) for row in orbit_rows
    )
    depth_law = depth_labelled_orbit_law(name, prime)
    if observed_orbits_by_depth != Counter(depth_law["orbit_counts"]):
        raise AssertionError(f"{name}: depth-labelled orbit law failed")
    element_order_counts = Counter(projective_matrix_order(matrix, prime) for matrix in group)
    expected_element_orders = (
        Counter({1: 1, 2: 9, 3: 8, 4: 6})
        if name in ("A3", "B3")
        else Counter({1: 1, 2: 15, 3: 20, 5: 24})
    )
    if element_order_counts != expected_element_orders:
        raise AssertionError(f"{name}: unexpected projective group element orders")
    fixed_depth_incidence: Counter[str] = Counter()
    for matrix in group:
        if projective_matrix_order(matrix, prime) == 1:
            continue
        for line in universe:
            image = normalize(matrix_vector(matrix, line, prime), prime)
            if image == line:
                label = "mirror" if line in line_set else str(depth_by_line[line])
                fixed_depth_incidence[label] += 1
    if fixed_depth_incidence != Counter(depth_law["aggregate_nonidentity_fixed_incidence"]):
        raise AssertionError(f"{name}: fixed-depth incidence ledger failed")
    return {
        "q": prime,
        "projective_reflection_group_order": len(group),
        "projective_line_count": prime * prime + prime + 1,
        "orbit_count": len(orbit_rows),
        "burnside_orbit_count": burnside,
        "depth_labelled_orbit_law": depth_law,
        "projective_group_element_order_counts": {
            str(order): count for order, count in sorted(element_order_counts.items())
        },
        "observed_orbit_counts_by_depth": dict(sorted(observed_orbits_by_depth.items())),
        "observed_nonidentity_fixed_incidence_by_depth": dict(
            sorted(fixed_depth_incidence.items())
        ),
        "orbits": orbit_rows,
        "nonmirror_depth_counts_from_orbits": {
            str(depth): count for depth, count in sorted(nonmirror_depth_counts.items())
        },
    }


def derive_coxeter_spectrum(name: str) -> dict[str, object]:
    ledger = COXETER_LEDGERS[name]
    mirrors = int(ledger["mirrors"])
    spectrum: dict[int, tuple[int, int, int]] = defaultdict(lambda: (0, 0, 0))
    for row in ledger["strata"]:  # type: ignore[union-attr]
        multiplicity = int(row["multiplicity"])
        points = int(row["points"])
        special_degree = int(row["special_degree"])
        ordinary = (points * (1 - multiplicity - special_degree), points, 0)
        delta = multiplicity - 1
        spectrum[delta] = polynomial_add(spectrum[delta], ordinary)
    for delta, count in ledger["special_delta_counts"].items():  # type: ignore[union-attr]
        spectrum[int(delta)] = polynomial_add(spectrum[int(delta)], (int(count), 0, 0))
    nonmirror_total = (1 - mirrors, 1, 1)
    used = (0, 0, 0)
    for coefficients in spectrum.values():
        used = polynomial_add(used, coefficients)
    spectrum[0] = polynomial_subtract(nonmirror_total, used)
    spectrum = dict(sorted(spectrum.items()))
    if spectrum != EXPECTED_COXETER_POLYNOMIALS[name]:
        raise AssertionError(f"unexpected {name} spectrum: {spectrum}")

    sample_q = int(ledger["sample_q"])
    sample = {delta: polynomial_value(coefficients, sample_q) for delta, coefficients in spectrum.items()}
    if any(count < 0 for count in sample.values()):
        raise AssertionError(f"negative stable sample count for {name}")
    if sum(sample.values()) + mirrors != sample_q * sample_q + sample_q + 1:
        raise AssertionError(f"line total failed for {name}")

    singular_weight = sum(
        int(row["points"]) * (int(row["multiplicity"]) - 1)  # type: ignore[index]
        for row in ledger["strata"]  # type: ignore[union-attr]
    )
    length_polynomial = (1 - mirrors + singular_weight, 1 - mirrors, 1)
    max_delta = max(delta for delta, count in sample.items() if count)
    max_section = sample_q + 1 - mirrors + max_delta
    length = polynomial_value(length_polynomial, sample_q)
    return {
        "mirrors": mirrors,
        "singular_strata": list(ledger["strata"]),
        "special_external_line_counts": {
            str(delta): count for delta, count in sorted(ledger["special_delta_counts"].items())  # type: ignore[union-attr]
        },
        "delta_count_polynomials": {
            str(delta): {
                "coefficients_low_to_high": list(coefficients),
                "text": polynomial_text(coefficients),
            }
            for delta, coefficients in spectrum.items()
        },
        "length_polynomial": {
            "coefficients_low_to_high": list(length_polynomial),
            "text": polynomial_text(length_polynomial),
        },
        "sample": {
            "q": sample_q,
            "delta_counts": {str(delta): count for delta, count in sample.items()},
            "length": length,
            "max_delta": max_delta,
            "max_line_intersection": max_section,
            "minimum_distance": length - max_section,
        },
    }


def analyze_arrangement(
    name: str, lines: tuple[tuple[int, int, int], ...], prime: int
) -> dict[str, object]:
    universe = projective_objects(prime)
    blocks = intersection_blocks(lines, prime)
    weights = {point: len(indices) - 1 for point, indices in blocks.items()}
    complement = tuple(
        point for point in universe if not any(incident(line, point, prime) for line in lines)
    )
    complement_set = set(complement)
    if not any(determinant(triple, prime) for triple in combinations(complement, 3)):
        raise AssertionError(f"{name}: complement columns do not have rank three")

    delta_counts: Counter[int] = Counter()
    adjoint_depth_counts: Counter[int] = Counter()
    contraction_class_counts: Counter[int] = Counter()
    section_counts: Counter[int] = Counter()
    section_by_line: dict[tuple[int, int, int], int] = {}
    weight_counts: Counter[int] = Counter({0: 1})
    line_set = set(lines)
    for line in universe:
        direct_section = sum(point in complement_set and incident(line, point, prime) for point in universe)
        section_by_line[line] = direct_section
        section_counts[direct_section] += 1
        adjoint_depth = sum(
            weight for point, weight in weights.items() if incident(line, point, prime)
        )
        adjoint_depth_counts[adjoint_depth] += 1
        if line in line_set:
            if direct_section != 0:
                raise AssertionError(f"{name}: mirror meets complement")
            if adjoint_depth != len(lines) - 1:
                raise AssertionError(f"{name}: mirror has unexpected second-adjoint depth")
        else:
            delta = adjoint_depth
            predicted = prime + 1 - len(lines) + delta
            if predicted != direct_section:
                raise AssertionError(f"{name}: independent section replay failed")
            delta_counts[delta] += 1
            parallel_classes = len({cross(line, arrangement_line, prime) for arrangement_line in lines})
            if parallel_classes != len(lines) - delta:
                raise AssertionError(f"{name}: contraction-profile replay failed")
            contraction_class_counts[parallel_classes] += 1
        weight_counts[len(complement) - direct_section] += prime - 1
    if sum(weight_counts.values()) != prime**3:
        raise AssertionError(f"{name}: weight enumerator total is not q^3")

    sum_weights = sum(weights.values())
    projective_constant = 1 - len(lines) + sum_weights
    direct_length = prime * prime + (1 - len(lines)) * prime + projective_constant
    if direct_length != len(complement):
        raise AssertionError(f"{name}: characteristic point count failed")
    discriminant = (len(lines) - 1) ** 2 - 4 * projective_constant
    roots: list[int] | None = None
    if discriminant >= 0:
        square = int(discriminant**0.5)
        while (square + 1) ** 2 <= discriminant:
            square += 1
        while square**2 > discriminant:
            square -= 1
        if square * square == discriminant and (len(lines) - 1 - square) % 2 == 0:
            roots = sorted(
                [(len(lines) - 1 - square) // 2, (len(lines) - 1 + square) // 2]
            )

    max_section = max(section_counts)
    contraction_weight_counts: Counter[int] = Counter({0: 1, len(complement): (prime - 1) * len(lines)})
    for parallel_classes, count in contraction_class_counts.items():
        contraction_weight_counts[len(complement) - prime - 1 + parallel_classes] += (
            (prime - 1) * count
        )
    if contraction_weight_counts != weight_counts:
        raise AssertionError(f"{name}: contraction profile does not replay the weight enumerator")
    punctured_adjoint_depth_counts = adjoint_depth_counts.copy()
    punctured_adjoint_depth_counts[len(lines) - 1] -= len(lines)
    if not punctured_adjoint_depth_counts[len(lines) - 1]:
        del punctured_adjoint_depth_counts[len(lines) - 1]
    if punctured_adjoint_depth_counts != delta_counts:
        raise AssertionError(f"{name}: punctured weighted second-adjoint profile failed")
    singular_points = tuple(weights)
    weighted_collinear_triples = sum(
        weights[first] * weights[second] * weights[third]
        for first, second, third in combinations(singular_points, 3)
        if determinant((first, second, third), prime) == 0
    )
    weighted_mirror_triples = 0
    for line in lines:
        points_on_line = tuple(point for point in singular_points if incident(line, point, prime))
        weighted_mirror_triples += sum(
            weights[first] * weights[second] * weights[third]
            for first, second, third in combinations(points_on_line, 3)
        )
    weighted_external_triples = weighted_collinear_triples - weighted_mirror_triples
    weight_power_sums = {
        power: sum(weight**power for weight in weights.values()) for power in (1, 2, 3)
    }
    full_depth_power_moments = {
        power: sum(count * depth**power for depth, count in adjoint_depth_counts.items())
        for power in (1, 2, 3)
    }
    expected_depth_power_moments = {
        1: (prime + 1) * weight_power_sums[1],
        2: prime * weight_power_sums[2] + weight_power_sums[1] ** 2,
        3: (
            (prime - 2) * weight_power_sums[3]
            + 3 * weight_power_sums[1] * weight_power_sums[2]
            + 6 * weighted_collinear_triples
        ),
    }
    if full_depth_power_moments != expected_depth_power_moments:
        raise AssertionError(f"{name}: weighted second-adjoint moment identity failed")
    punctured_depth_power_moments = {
        power: sum(count * depth**power for depth, count in punctured_adjoint_depth_counts.items())
        for power in (1, 2, 3)
    }
    central_adjoint_depth_counts: Counter[int] = Counter(
        {
            depth: (prime - 1) * count
            for depth, count in adjoint_depth_counts.items()
        }
    )
    central_adjoint_depth_counts[sum(weights.values())] += 1
    if sum(central_adjoint_depth_counts.values()) != prime**3:
        raise AssertionError(f"{name}: central weighted second-adjoint point count failed")
    adjoint_weight_counts: Counter[int] = Counter(
        {0: 1, len(complement): (prime - 1) * len(lines)}
    )
    for depth, count in punctured_adjoint_depth_counts.items():
        adjoint_weight_counts[
            len(complement) - prime - 1 + len(lines) - depth
        ] += (prime - 1) * count
    if adjoint_weight_counts != weight_counts:
        raise AssertionError(f"{name}: weighted second-adjoint enumerator replay failed")
    dual_weight_three = (prime - 1) * sum(
        count * (section * (section - 1) * (section - 2) // 6)
        for section, count in section_counts.items()
    )
    repair_pair_distribution: Counter[int] = Counter()
    disjoint_availability_distribution: Counter[int] = Counter()
    for point in complement:
        repair_pairs = 0
        disjoint_availability = 0
        for line, section in section_by_line.items():
            if not incident(line, point, prime):
                continue
            other_points = section - 1
            repair_pairs += other_points * (other_points - 1) // 2
            disjoint_availability += other_points // 2
        repair_pair_distribution[repair_pairs] += 1
        disjoint_availability_distribution[disjoint_availability] += 1
    triple_supports = dual_weight_three // (prime - 1)
    if sum(count * repair_pairs for repair_pairs, count in repair_pair_distribution.items()) != 3 * triple_supports:
        raise AssertionError(f"{name}: locality repair-pair incidence count failed")
    flat_multiplicities = Counter(len(indices) for indices in blocks.values())
    max_multiplicity = max(flat_multiplicities)
    intrinsic_lower_bound = (
        len(complement) - prime - 1 + (len(lines) + max_multiplicity - 1) // max_multiplicity
    )
    intrinsic_upper_bound = None
    if prime + 1 > max_multiplicity:
        intrinsic_upper_bound = len(complement) - prime + len(lines) - max_multiplicity
    minimum_distance = len(complement) - max_section
    if minimum_distance < intrinsic_lower_bound:
        raise AssertionError(f"{name}: intrinsic lower bound failed")
    if intrinsic_upper_bound is not None and minimum_distance > intrinsic_upper_bound:
        raise AssertionError(f"{name}: intrinsic upper bound failed")
    return {
        "name": name,
        "field_order": prime,
        "lines": [list(line) for line in lines],
        "line_count": len(lines),
        "intersection_blocks": [list(indices) for indices in sorted(blocks.values())],
        "flat_multiplicity_counts": {
            str(multiplicity): count for multiplicity, count in sorted(flat_multiplicities.items())
        },
        "projective_characteristic_polynomial": {
            "coefficients_low_to_high": [projective_constant, 1 - len(lines), 1],
            "integer_roots": roots,
        },
        "complement_length": len(complement),
        "dimension": 3,
        "external_delta_counts": {
            str(delta): count for delta, count in sorted(delta_counts.items())
        },
        "weighted_second_adjoint": {
            "hyperplane_count": len(blocks),
            "total_multiplicity_weight": sum(weights.values()),
            "projective_depth_counts_before_puncture": {
                str(depth): count for depth, count in sorted(adjoint_depth_counts.items())
            },
            "central_finite_field_depth_counts_coboundary_side": {
                str(depth): count
                for depth, count in sorted(central_adjoint_depth_counts.items())
            },
            "mirror_puncture": {"depth": len(lines) - 1, "count": len(lines)},
            "projective_depth_counts_after_puncture": {
                str(depth): count
                for depth, count in sorted(punctured_adjoint_depth_counts.items())
            },
            "moment_signature": {
                "singular_weight_power_sums": {
                    str(power): value for power, value in weight_power_sums.items()
                },
                "projective_depth_power_moments": {
                    str(power): value for power, value in full_depth_power_moments.items()
                },
                "punctured_depth_power_moments": {
                    str(power): value for power, value in punctured_depth_power_moments.items()
                },
                "weighted_collinear_singular_triples": weighted_collinear_triples,
                "weighted_triples_on_mirrors": weighted_mirror_triples,
                "weighted_triples_on_external_lines": weighted_external_triples,
            },
        },
        "ambient_one_point_contraction_profile": {
            str(parallel_classes): count
            for parallel_classes, count in sorted(contraction_class_counts.items())
        },
        "line_intersection_counts": {
            str(section): count for section, count in sorted(section_counts.items())
        },
        "max_line_intersection": max_section,
        "minimum_distance": minimum_distance,
        "intrinsic_multiplicity_bounds": {
            "maximum_singular_multiplicity": max_multiplicity,
            "lower": intrinsic_lower_bound,
            "upper": intrinsic_upper_bound,
        },
        "generalized_hamming_weights": [minimum_distance, len(complement) - 1, len(complement)],
        "weight_enumerator": {
            str(weight): count for weight, count in sorted(weight_counts.items())
        },
        "dual_weight_three_codewords": dual_weight_three,
        "locality_two_profile": {
            "repair_pair_count_distribution": {
                str(repair_pairs): count
                for repair_pairs, count in sorted(repair_pair_distribution.items())
            },
            "maximum_disjoint_availability_distribution": {
                str(availability): count
                for availability, count in sorted(disjoint_availability_distribution.items())
            },
            "minimum_repair_pairs": min(repair_pair_distribution),
            "minimum_disjoint_availability": min(disjoint_availability_distribution),
        },
        "connected_matroid": is_connected_matroid(lines, prime),
        "modular_singular_points": modular_singular_points(lines, blocks, prime),
    }


def two_pencil_arrangement(
    r: int, s: int, prime: int
) -> tuple[tuple[int, int, int], ...]:
    """Return r P-only lines, s Q-only lines, and their shared line."""
    if not (2 <= r < prime and 2 <= s < prime):
        raise ValueError("two-pencil samples require 2 <= r,s < q")
    return arrangement(
        [(0, 0, 1)]
        + [(0, 1, slope) for slope in range(r)]
        + [(1, 0, slope) for slope in range(s)],
        prime,
    )


def certify_two_pencil_samples(prime: int) -> dict[str, object]:
    samples: dict[str, object] = {}
    for r, s in ((2, 2), (3, 2), (4, 2), (4, 3), (5, 4)):
        result = analyze_arrangement(
            f"two_pencil_r{r}_s{s}_q{prime}", two_pencil_arrangement(r, s, prime), prime
        )
        expected_length = (prime - r) * (prime - s)
        expected_distance = expected_length - prime + min(r, s)
        expected_characteristic = [r * s, -(r + s), 1]
        if result["complement_length"] != expected_length:
            raise AssertionError("two-pencil length formula failed")
        if result["minimum_distance"] != expected_distance:
            raise AssertionError("two-pencil distance formula failed")
        if (
            result["projective_characteristic_polynomial"]["coefficients_low_to_high"]
            != expected_characteristic
        ):
            raise AssertionError("two-pencil characteristic formula failed")
        if result["intrinsic_multiplicity_bounds"]["upper"] != expected_distance:
            raise AssertionError("two-pencil family did not saturate the multiplicity upper bound")
        samples[f"r{r}_s{s}"] = {
            "line_count": r + s + 1,
            "projective_characteristic_coefficients_low_to_high": expected_characteristic,
            "central_characteristic_factorization": f"(t-1)(t-{r})(t-{s})",
            "complement_length": expected_length,
            "maximum_external_delta": max(
                map(int, result["external_delta_counts"])  # type: ignore[arg-type]
            ),
            "minimum_distance": expected_distance,
            "multiplicity_upper_bound": result["intrinsic_multiplicity_bounds"]["upper"],
        }
    return {
        "parameters": "r,s >= 2; q > max(r,s)",
        "line_count": "N=r+s+1",
        "central_characteristic_polynomial": "(t-1)(t-r)(t-s)",
        "free_exponents": "(1,r,s) by the rank-three supersolvable theorem",
        "complement_length": "(q-r)(q-s)",
        "maximum_external_delta": "max(r,s)",
        "minimum_distance": "(q-r)(q-s)-q+min(r,s)",
        "samples_over_q": prime,
        "samples": samples,
    }


def build_certificate() -> dict[str, object]:
    prime = 11
    a3 = arrangement(
        (
            (1, 0, 0),
            (0, 1, 0),
            (0, 0, 1),
            (1, -1, 0),
            (1, 0, -1),
            (0, 1, -1),
        ),
        prime,
    )
    b3 = arrangement(
        (
            (1, 0, 0),
            (0, 1, 0),
            (0, 0, 1),
            (1, 1, 0),
            (1, -1, 0),
            (1, 0, 1),
            (1, 0, -1),
            (0, 1, 1),
            (0, 1, -1),
        ),
        prime,
    )
    free_dual_pencil = arrangement(
        (
            (0, 0, 1),
            (0, 1, 0),
            (0, 1, 1),
            (0, 1, 2),
            (1, 0, 0),
            (1, 0, 1),
        ),
        prime,
    )
    uniform_low = arrangement(
        (
            (0, 1, 1),
            (1, 3, 4),
            (1, 4, 10),
            (1, 5, 7),
            (1, 6, 5),
            (1, 6, 9),
        ),
        prime,
    )
    uniform_high = arrangement(
        (
            (1, 0, 0),
            (1, 1, 3),
            (1, 3, 7),
            (1, 5, 1),
            (1, 6, 8),
            (1, 8, 1),
        ),
        prime,
    )
    two_pencil_balanced_collinear = two_pencil_arrangement(3, 3, prime)
    two_pencil_balanced_generic = arrangement(
        [(0, 0, 1)]
        + [(0, 1, slope) for slope in (0, 1, 2)]
        + [(1, 0, slope) for slope in (0, 1, 3)],
        prime,
    )

    fixtures = {
        "A3_q11": analyze_arrangement("A3_q11", a3, prime),
        "B3_q11": analyze_arrangement("B3_q11", b3, prime),
        "free_dual_pencil_q11": analyze_arrangement(
            "free_dual_pencil_q11", free_dual_pencil, prime
        ),
        "uniform_low_q11": analyze_arrangement("uniform_low_q11", uniform_low, prime),
        "uniform_high_q11": analyze_arrangement("uniform_high_q11", uniform_high, prime),
        "two_pencil_balanced_collinear_q11": analyze_arrangement(
            "two_pencil_balanced_collinear_q11", two_pencil_balanced_collinear, prime
        ),
        "two_pencil_balanced_generic_q11": analyze_arrangement(
            "two_pencil_balanced_generic_q11", two_pencil_balanced_generic, prime
        ),
    }
    coxeter = {name: derive_coxeter_spectrum(name) for name in ("A3", "B3", "H3")}

    for name in ("A3", "B3"):
        direct = fixtures[f"{name}_q11"]["external_delta_counts"]
        derived = coxeter[name]["sample"]["delta_counts"]  # type: ignore[index]
        if direct != derived:
            raise AssertionError(f"{name}: flag-ledger and direct spectra disagree")

    a3_fixture = fixtures["A3_q11"]
    free_fixture = fixtures["free_dual_pencil_q11"]
    if (
        a3_fixture["projective_characteristic_polynomial"]
        != free_fixture["projective_characteristic_polynomial"]
    ):
        raise AssertionError("A3 and free dual-pencil characteristic polynomials differ")
    if a3_fixture["minimum_distance"] == free_fixture["minimum_distance"]:
        raise AssertionError("ordinary-characteristic counterexample did not separate distance")
    if not free_fixture["connected_matroid"] or not free_fixture["modular_singular_points"]:
        raise AssertionError("free dual-pencil fixture failed its irreducible supersolvable checks")
    if free_fixture["intrinsic_multiplicity_bounds"]["upper"] != free_fixture["minimum_distance"]:
        raise AssertionError("free dual-pencil fixture did not saturate the intrinsic upper bound")

    low = fixtures["uniform_low_q11"]
    high = fixtures["uniform_high_q11"]
    if low["intersection_blocks"] != high["intersection_blocks"]:
        raise AssertionError("uniform fixtures do not have the same full intersection lattice")
    if low["minimum_distance"] == high["minimum_distance"]:
        raise AssertionError("same-lattice counterexample did not separate distance")

    balanced_collinear = fixtures["two_pencil_balanced_collinear_q11"]
    balanced_generic = fixtures["two_pencil_balanced_generic_q11"]
    if balanced_collinear["intersection_blocks"] != balanced_generic["intersection_blocks"]:
        raise AssertionError("balanced two-pencil fixtures do not have the same full lattice")
    if balanced_collinear["minimum_distance"] != balanced_generic["minimum_distance"]:
        raise AssertionError("balanced two-pencil structural distance formula disagrees")
    if balanced_collinear["external_delta_counts"] == balanced_generic["external_delta_counts"]:
        raise AssertionError("balanced two-pencil enumerator counterexample did not separate")

    return {
        "schema": "c403-arrangement-complement-distance-v2",
        "field_convention": "normalized triples for points and dual lines of PG(2,p)",
        "weighted_second_adjoint_theorem": {
            "rank_three_identification": (
                "the second-adjoint hyperplane indexed by a singular point X consists "
                "of projective test lines containing X"
            ),
            "flat_weight": "w(X)=m(X)-1",
            "depth_identity": "depth(L)=delta_A(L) for every nonmirror line L",
            "mirror_puncture": "N projective points, each of weighted depth N-1",
            "enumerator_replay": (
                "W(z)=1+(q-1)N z^n+(q-1) sum_delta a_delta "
                "z^(n-q-1+N-delta)"
            ),
        },
        "coxeter_external_flag_ledgers": coxeter,
        "coxeter_projective_orbit_compression_q11": {
            name: coxeter_orbit_certificate(name, prime) for name in ("A3", "B3", "H3")
        },
        "coxeter_orbit_law_branch_replays": {
            "A3_q13_all_roots_split": coxeter_orbit_certificate("A3", 13),
            "H3_q19_cubic_split_fifth_roots_nonsplit": coxeter_orbit_certificate(
                "H3", 19, h3_roots(5)
            ),
        },
        "coxeter_conic_phase_full_weight_lines": {
            name: {
                "q": q,
                "all_conic_external_lines": q * (q - 1) // 2,
                "coxeter_mirrors": int(COXETER_LEDGERS[name]["mirrors"]),
                "additional_parent_forgetting_lines": q * (q - 1) // 2
                - int(COXETER_LEDGERS[name]["mirrors"]),
            }
            for name, q in (("A3", 5), ("B3", 7), ("H3", 11))
        },
        "two_pencil_supersolvable_family": certify_two_pencil_samples(prime),
        "fixtures": fixtures,
        "comparisons": {
            "ordinary_characteristic_failure": {
                "pair": ["A3_q11", "free_dual_pencil_q11"],
                "common_projective_characteristic_polynomial": [6, -5, 1],
                "distances": [
                    a3_fixture["minimum_distance"],
                    free_fixture["minimum_distance"],
                ],
                "different_intersection_lattices": True,
            },
            "full_intersection_lattice_failure": {
                "pair": ["uniform_low_q11", "uniform_high_q11"],
                "common_projective_characteristic_polynomial": [10, -5, 1],
                "common_lattice": "rank-three uniform matroid U(3,6)",
                "distances": [low["minimum_distance"], high["minimum_distance"]],
                "max_external_delta": [
                    max(map(int, low["external_delta_counts"])),  # type: ignore[arg-type]
                    max(map(int, high["external_delta_counts"])),  # type: ignore[arg-type]
                ],
            },
            "same_lattice_same_distance_full_enumerator_failure": {
                "pair": [
                    "two_pencil_balanced_collinear_q11",
                    "two_pencil_balanced_generic_q11",
                ],
                "common_lattice": (
                    "two multiplicity-four pencil points, nine double points, and seven lines"
                ),
                "common_free_exponents": [1, 3, 3],
                "common_length": balanced_collinear["complement_length"],
                "common_distance": balanced_collinear["minimum_distance"],
                "different_external_delta_counts": [
                    balanced_collinear["external_delta_counts"],
                    balanced_generic["external_delta_counts"],
                ],
            },
        },
        "trusted_boundary": {
            "primary": (
                "weighted second-adjoint depth ledger, external singular-line ledger, "
                "and exact integer polynomial algebra"
            ),
            "independent_replay": "direct point/line incidence enumeration in PG(2,11)",
            "not_certified": [
                "the general supersolvable-implies-free theorem",
                "the C339 characteristic-zero H3 special-line ledger",
                "the published general k-adjoint decomposition theorem over arbitrary fields",
                "any claim beyond the proved symbolic formulas and pinned finite-field samples",
            ],
        },
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="compare regeneration with tracked JSON")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    payload = canonical_bytes(build_certificate())
    digest = hashlib.sha256(payload).hexdigest()
    if args.check:
        tracked = args.output.read_bytes()
        if tracked != payload:
            raise SystemExit(f"stale certificate: {args.output}")
        print(f"OK {args.output.name} {len(payload)} bytes sha256={digest}")
        return
    args.output.write_bytes(payload)
    print(f"WROTE {args.output} {len(payload)} bytes sha256={digest}")


if __name__ == "__main__":
    main()
