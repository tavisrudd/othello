#!/usr/bin/env python3
"""Deterministic finite replay for the C350 mirror-locus quotient."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from collections import Counter
from itertools import combinations
from pathlib import Path


STEM = "2026-07-19-c350-full-mirror-locus-quotient-count"
SCHEMA = "c350-mirror-quotient-v1"
ROOT = Path(__file__).resolve().parent
C333_PATH = ROOT / "2026-07-18-c333-all-odd-q-mirror-locus.py"


def load_c333():
    spec = importlib.util.spec_from_file_location("c333_mirror_locus", C333_PATH)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C333 = load_c333()
FiniteField = C333.FiniteField

Centre = tuple[int, int]
CentreOrbit = tuple[Centre, Centre]
Configuration = tuple[CentreOrbit, CentreOrbit]


def tau_centre(field: FiniteField, delta: int, centre: Centre) -> Centre:
    r, c = centre
    return field.mul(delta, c), field.div(r, delta)


def negate_centre(field: FiniteField, centre: Centre) -> Centre:
    return field.neg(centre[0]), field.neg(centre[1])


def canonical_centre_orbit(field: FiniteField, delta: int, centre: Centre) -> CentreOrbit:
    mate = tau_centre(field, delta, centre)
    assert mate != centre
    return tuple(sorted((centre, mate)))  # type: ignore[return-value]


def centre_orbits(field: FiniteField, delta: int) -> list[CentreOrbit]:
    answer: set[CentreOrbit] = set()
    four_delta = field.mul(field.constant(4), delta)
    for r in range(field.q):
        for c in range(field.q):
            if r == field.mul(delta, c):
                continue
            u = field.add(r, field.mul(delta, c))
            discriminant = field.sub(field.mul(u, u), four_delta)
            if field.character(discriminant) != -1:
                continue
            assert field.mul(r, c) != field.constant(1)
            answer.add(canonical_centre_orbit(field, delta, (r, c)))
    return sorted(answer)


def orbit_uv(field: FiniteField, delta: int, orbit: CentreOrbit) -> tuple[int, int]:
    r, c = orbit[0]
    u = field.add(r, field.mul(delta, c))
    v = field.sub(r, field.mul(delta, c))
    return u, field.mul(v, v)


def orbit_sheet(field: FiniteField, orbit: CentreOrbit) -> str:
    r, c = orbit[0]
    determinant = field.sub(field.mul(r, c), field.constant(1))
    sign = field.character(determinant)
    assert sign in (-1, 1)
    return "+" if sign == 1 else "-"


def configuration_sheet(field: FiniteField, configuration: Configuration) -> str:
    return "".join(sorted(orbit_sheet(field, orbit) for orbit in configuration))


def determinant3(field: FiniteField, points: tuple[Centre, Centre, Centre]) -> int:
    (r0, c0), (r1, c1), (r2, c2) = points
    first = field.mul(r0, field.sub(c1, c2))
    second = field.mul(r1, field.sub(c2, c0))
    third = field.mul(r2, field.sub(c0, c1))
    return field.add(field.add(first, second), third)


def legal(field: FiniteField, configuration: Configuration) -> bool:
    centres = tuple(centre for orbit in configuration for centre in orbit)
    if len({r for r, _ in centres}) != 4 or len({c for _, c in centres}) != 4:
        return False
    return all(determinant3(field, triple) != 0 for triple in combinations(centres, 3))


def negate_orbit(field: FiniteField, delta: int, orbit: CentreOrbit) -> CentreOrbit:
    return canonical_centre_orbit(field, delta, negate_centre(field, orbit[0]))


def negate_configuration(field: FiniteField, delta: int, configuration: Configuration) -> Configuration:
    return tuple(sorted(negate_orbit(field, delta, orbit) for orbit in configuration))  # type: ignore[return-value]


def canonical_configuration(field: FiniteField, delta: int, configuration: Configuration) -> Configuration:
    return min(configuration, negate_configuration(field, delta, configuration))


def generated_order(field: FiniteField, configuration: Configuration) -> int:
    centres = [centre for orbit in configuration for centre in orbit]
    return C333.group_order(field, [C333.sigma(field, centre) for centre in centres])


def elliptic_rows(field: FiniteField) -> list[dict[str, int]]:
    one = field.constant(1)
    four = field.constant(4)
    sixteen = field.constant(16)
    rows = []
    for delta in range(field.q):
        if field.character(delta) != -1 or field.character(field.sub(delta, four)) != 1:
            continue
        character_sum = 0
        direct_square_minus_one_count = 0
        for b in range(field.q):
            one_plus_delta_b = field.add(one, field.mul(delta, b))
            quadratic = field.sub(field.mul(one_plus_delta_b, one_plus_delta_b), field.mul(four, delta))
            cubic = field.mul(field.sub(b, one), quadratic)
            character_sum += field.character(cubic)
            if field.character(quadratic) == -1 and field.character(field.sub(b, one)) == -1:
                direct_square_minus_one_count += 1
        delta_squared = field.mul(delta, delta)
        numerator_base = field.add(field.add(delta_squared, field.mul(field.constant(14), delta)), one)
        numerator = field.mul(sixteen, field.mul(field.mul(numerator_base, numerator_base), numerator_base))
        delta_minus_one = field.sub(delta, one)
        denominator = field.mul(delta, field.pow(delta_minus_one, 4))
        j_invariant = field.div(numerator, denominator)
        curve_points = field.q + 1 + character_sum
        row = {
            "delta": delta,
            "character_sum": character_sum,
            "curve_points": curve_points,
            "j_invariant": j_invariant,
        }
        if field.character(field.constant(-1)) == 1:
            assert direct_square_minus_one_count == curve_points // 4
            row["square_minus_one_slice_count"] = direct_square_minus_one_count
        rows.append(row)
    return rows


def check_field(p: int, degree: int, classify_groups: bool) -> dict[str, object]:
    field = FiniteField(p, degree)
    delta = next(value for value in range(field.q) if field.character(value) == -1)
    orbits = centre_orbits(field, delta)
    epsilon = field.character(field.constant(-1))
    expected_orbits = (field.q * field.q - 1) // 4
    assert len(orbits) == expected_orbits
    assert len({orbit_uv(field, delta, orbit) for orbit in orbits}) == len(orbits)

    sheet_counts = Counter(orbit_sheet(field, orbit) for orbit in orbits)
    assert sheet_counts["+"] == (field.q + 1) * (field.q - 2 + epsilon) // 8
    assert sheet_counts["-"] == (field.q + 1) * (field.q - epsilon) // 8

    all_configurations = [tuple(pair) for pair in combinations(orbits, 2)]
    legal_configurations = [configuration for configuration in all_configurations if legal(field, configuration)]
    incompatibility_degrees = Counter()
    for first, second in all_configurations:
        if not legal(field, (first, second)):
            incompatibility_degrees[first] += 1
            incompatibility_degrees[second] += 1
    expected_legal = (field.q * field.q - 1) * (field.q - 3) ** 2 // 32
    assert len(legal_configurations) == expected_legal
    expected_illegal = (field.q * field.q - 1) * (3 * field.q - 7) // 16
    assert len(all_configurations) - len(legal_configurations) == expected_illegal
    quotient = {canonical_configuration(field, delta, configuration) for configuration in legal_configurations}
    fixed = [
        configuration
        for configuration in legal_configurations
        if negate_configuration(field, delta, configuration) == configuration
    ]
    expected_fixed = (field.q - 3) * (field.q - epsilon) // 8
    assert len(fixed) == expected_fixed
    fixed_types = Counter()
    for configuration in fixed:
        if negate_orbit(field, delta, configuration[0]) == configuration[1]:
            fixed_types["orbits_swapped"] += 1
        else:
            assert all(negate_orbit(field, delta, orbit) == orbit for orbit in configuration)
            fixed_types["both_orbits_fixed"] += 1
    assert len(quotient) == (len(legal_configurations) + len(fixed)) // 2

    result: dict[str, object] = {
        "p": p,
        "degree": degree,
        "q": field.q,
        "modulus": list(field.modulus),
        "delta": delta,
        "epsilon": epsilon,
        "centre_orbits": len(orbits),
        "centre_orbit_sheets": dict(sorted(sheet_counts.items())),
        "raw_pairs": len(all_configurations),
        "incompatibility_degree_histogram": {
            str(degree_value): count
            for degree_value, count in sorted(Counter(incompatibility_degrees.values()).items())
        },
        "legal_configurations": len(legal_configurations),
        "legal_sheets": dict(sorted(Counter(configuration_sheet(field, c) for c in legal_configurations).items())),
        "enhanced_residual_stabilizer": len(fixed),
        "enhanced_stabilizer_types": dict(sorted(fixed_types.items())),
        "projective_classes": len(quotient),
        "class_sheets": dict(sorted(Counter(configuration_sheet(field, c) for c in quotient).items())),
        "elliptic_family": elliptic_rows(field),
    }
    if classify_groups:
        order_sheet_pairs = [
            (generated_order(field, configuration), configuration_sheet(field, configuration))
            for configuration in quotient
        ]
        orders = Counter(order for order, _ in order_sheet_pairs)
        result["generated_group_orders"] = {str(order): count for order, count in sorted(orders.items())}
        result["generated_group_orders_by_sheet"] = {
            f"{order}:{sheet}": count
            for (order, sheet), count in sorted(Counter(order_sheet_pairs).items())
        }
        result["full_pgl_classes"] = orders[field.q * (field.q * field.q - 1)]
        result["full_psl_classes"] = orders[field.q * (field.q * field.q - 1) // 2]
    return result


def payload() -> dict[str, object]:
    fields = [(5, 1, True), (7, 1, True), (3, 2, True), (11, 1, True), (13, 1, True)]
    return {
        "schema": SCHEMA,
        "conventions": {
            "mirror": "tau(t)=delta/t with the least encoded nonsquare delta",
            "burned_orbit": "{infinity,0}",
            "centre_orbit_coordinate": "(u,z)=(r+delta*c,(r-delta*c)^2)",
            "effective_residual_action": "(u1,z1;u2,z2) -> (-u1,z1;-u2,z2)",
            "group_order_scope": "exact for every listed field",
        },
        "fields": [check_field(p, degree, classify) for p, degree, classify in fields],
    }


def serialized() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.write == arguments.check:
        parser.error("choose exactly one of --write or --check")
    output = ROOT / f"{STEM}.json"
    data = serialized()
    if arguments.write:
        output.write_bytes(data)
        print(f"wrote {output} ({len(data)} bytes, sha256 {hashlib.sha256(data).hexdigest()})")
        return 0
    with tempfile.TemporaryDirectory(prefix="c350-check-") as directory:
        regenerated = Path(directory) / output.name
        regenerated.write_bytes(data)
        assert output.read_bytes() == regenerated.read_bytes()
    print(f"checked {output} ({len(data)} bytes, sha256 {hashlib.sha256(data).hexdigest()})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
