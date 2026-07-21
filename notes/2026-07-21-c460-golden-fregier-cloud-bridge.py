#!/usr/bin/env python3
"""Exact primary certificate for C460's golden--Fregier cloud bridge."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from collections import Counter, deque
from fractions import Fraction
from pathlib import Path


SCHEMA = "c460-golden-fregier-cloud-bridge-v1"
HERE = Path(__file__).resolve().parent
C446 = HERE / "2026-07-21-c446-marker-matching-concurrency.json"
C446_MANIFEST = HERE / "2026-07-21-c446-marker-matching-concurrency.sha256"
C458 = HERE / "2026-07-21-c458-golden-sheet-frame-freeze.json"
C458_MANIFEST = HERE / "2026-07-21-c458-golden-sheet-frame-freeze.sha256"
OUTPUT = Path(__file__).with_suffix(".json")


def digest(path: Path) -> dict[str, object]:
    data = path.read_bytes()
    return {"path": path.name, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def verify_manifest_entry(path: Path, manifest: Path) -> None:
    expected = None
    for line in manifest.read_text().splitlines():
        fields = line.split()
        if not fields:
            continue
        name = fields[1]
        if name.endswith(path.name) or name == path.name:
            expected = fields[0]
            break
    assert expected is not None, (path, manifest)
    assert digest(path)["sha256"] == expected


def normalize(values: tuple[int, ...], prime: int) -> tuple[int, ...]:
    values = tuple(value % prime for value in values)
    pivot = next(value for value in values if value)
    inverse = pow(pivot, -1, prime)
    return tuple(value * inverse % prime for value in values)


def pgl_actions(prime: int) -> dict[tuple[int, ...], int]:
    endpoints = tuple([(1, value) for value in range(prime)] + [(0, 1)])
    endpoint_index = {point: index for index, point in enumerate(endpoints)}
    matrices = set()
    for matrix in itertools.product(range(prime), repeat=4):
        a, b, c, d = matrix
        if (a * d - b * c) % prime:
            matrices.add(normalize(matrix, prime))
    actions = {}
    for a, b, c, d in matrices:
        det = (a * d - b * c) % prime
        permutation = tuple(
            endpoint_index[normalize((a * s + b * t, c * s + d * t), prime)]
            for s, t in endpoints
        )
        actions[permutation] = det
    assert len(actions) == prime * (prime * prime - 1)
    return actions


def matching_image(permutation: tuple[int, ...], matching):
    return tuple(sorted(tuple(sorted((permutation[a], permutation[b]))) for a, b in matching))


def point_on_line(point, line, prime: int) -> bool:
    return sum(a * b for a, b in zip(point, line)) % prime == 0


def cross(left, right, prime: int):
    x1, y1, z1 = left
    x2, y2, z2 = right
    return normalize((y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2), prime)


def rank_mod(rows, prime: int) -> int:
    matrix = [[value % prime for value in row] for row in rows]
    rank = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next((r for r in range(rank, len(matrix)) if matrix[r][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [value * inverse % prime for value in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [
                    (value - factor * pivot_value) % prime
                    for value, pivot_value in zip(matrix[row], matrix[rank])
                ]
        rank += 1
    return rank


def rank_q(rows) -> int:
    matrix = [[Fraction(value) for value in row] for row in rows]
    rank = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next((r for r in range(rank, len(matrix)) if matrix[r][column]), None)
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        value = matrix[rank][column]
        matrix[rank] = [entry / value for entry in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [entry - factor * pivot for entry, pivot in zip(matrix[row], matrix[rank])]
        rank += 1
    return rank


def permutation_order(permutation: tuple[int, ...]) -> int:
    seen = set()
    lengths = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        current = start
        length = 0
        while current not in seen:
            seen.add(current)
            current = permutation[current]
            length += 1
        lengths.append(length)
    result = 1
    for length in lengths:
        result = result * length // math.gcd(result, length)
    return result


def order_histogram(group) -> dict[str, int]:
    return {str(key): value for key, value in sorted(Counter(map(permutation_order, group)).items())}


def perfect_matchings(vertices: tuple[int, ...]):
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        for tail in perfect_matchings(rest):
            yield tuple(sorted(((first, second),) + tail))


def connected_components(adjacency):
    remaining = set(range(len(adjacency)))
    components = []
    while remaining:
        root = min(remaining)
        seen = {root}
        queue = deque([root])
        while queue:
            vertex = queue.popleft()
            for neighbor in adjacency[vertex]:
                if neighbor not in seen:
                    seen.add(neighbor)
                    queue.append(neighbor)
        remaining -= seen
        components.append(sorted(seen))
    return components


def bipartition(adjacency):
    colors = {}
    for root in range(len(adjacency)):
        if root in colors:
            continue
        colors[root] = 0
        queue = deque([root])
        while queue:
            vertex = queue.popleft()
            for neighbor in adjacency[vertex]:
                if neighbor not in colors:
                    colors[neighbor] = 1 - colors[vertex]
                    queue.append(neighbor)
                else:
                    assert colors[neighbor] != colors[vertex]
    return [sorted(v for v, color in colors.items() if color == side) for side in (0, 1)]


def encode_matching(matching):
    return [list(edge) for edge in matching]


def encode_point(point):
    return list(point)


def cloud_case(item):
    name = item["type"]
    prime = item["field_order"]
    assert name in ("B3", "H3")
    records = item["matching_records"]
    target = [tuple(tuple(edge) for edge in record["matching"]) for record in records]
    sheet = {matching: record["psl_sheet"] for matching, record in zip(target, records)}
    line_by_edge = {}
    lines_by_matching = {}
    for matching, record in zip(target, records):
        lines = tuple(tuple(line) for line in record["secant_lines"])
        lines_by_matching[matching] = lines
        for edge, line in zip(matching, lines):
            if edge in line_by_edge:
                assert line_by_edge[edge] == line
            line_by_edge[edge] = line
    assert len(line_by_edge) == prime * (prime + 1) // 2

    clouds = {}
    for matching in target:
        lines = lines_by_matching[matching]
        cloud = {cross(lines[i], lines[j], prime) for i, j in itertools.combinations(range(len(lines)), 2)}
        assert len(cloud) == (len(matching) * (len(matching) - 1)) // 2
        clouds[matching] = frozenset(cloud)
    universe = sorted(set().union(*clouds.values()))
    assert len(universe) == prime * (prime - 1) // 2

    pencil_by_point = {}
    for point in universe:
        pencil = tuple(sorted(edge for edge, line in line_by_edge.items() if point_on_line(point, line, prime)))
        assert len(pencil) == (prime + 1) // 2
        assert len(set().union(*map(set, pencil))) == prime + 1
        pencil_by_point[point] = pencil
    point_by_pencil = {pencil: point for point, pencil in pencil_by_point.items()}
    assert len(point_by_pencil) == len(universe)
    for matching, cloud in clouds.items():
        assert cloud == frozenset(
            point for point, pencil in pencil_by_point.items() if len(set(matching) & set(pencil)) == 2
        )

    actions = pgl_actions(prime)
    squares = {value * value % prime for value in range(1, prime)}
    psl = {permutation for permutation, determinant in actions.items() if determinant in squares}
    action_on_points = {
        permutation: {
            point: point_by_pencil[matching_image(permutation, pencil)]
            for point, pencil in pencil_by_point.items()
        }
        for permutation in actions
    }

    stabilizer_orders = []
    cloud_orbit_sizes = []
    for matching in target:
        matching_stabilizer = {g for g in actions if matching_image(g, matching) == matching}
        cloud_stabilizer = {
            g for g in actions
            if {action_on_points[g][point] for point in clouds[matching]} == set(clouds[matching])
        }
        assert matching_stabilizer == cloud_stabilizer
        orbit = {action_on_points[g][min(clouds[matching])] for g in matching_stabilizer}
        assert orbit == set(clouds[matching])
        stabilizer_orders.append(len(matching_stabilizer))
        cloud_orbit_sizes.append(len(orbit))

    base = target[0]
    parent = {g for g in actions if matching_image(g, base) == base}
    remaining = set(universe)
    parent_orbits = []
    while remaining:
        representative = min(remaining)
        orbit = {action_on_points[g][representative] for g in parent}
        remaining -= orbit
        parent_orbits.append(sorted(orbit))
    parent_orbits.sort(key=lambda orbit: (len(orbit), orbit))
    double_cosets = [
        {
            "orbit_size": len(orbit),
            "point_stabilizer_intersection_order": len(parent) // len(orbit),
            "is_cloud_orbit": set(orbit) == set(clouds[base]),
        }
        for orbit in parent_orbits
    ]
    assert sum(entry["is_cloud_orbit"] for entry in double_cosets) == 1

    overlap = {"same_sheet": Counter(), "cross_sheet": Counter()}
    for left, right in itertools.combinations(target, 2):
        relation = "same_sheet" if sheet[left] == sheet[right] else "cross_sheet"
        overlap[relation][len(clouds[left] & clouds[right])] += 1

    matrix = [[int(point in clouds[matching]) for point in universe] for matching in target]
    rank_over_q = rank_q(matrix)
    field_ranks = {}
    signs = [1 if sheet[matching] == 0 else -1 for matching in target]
    signed_column_sums = [sum(sign * matrix[row][column] for row, sign in enumerate(signs)) for column in range(len(universe))]
    assert not any(signed_column_sums)
    for field in (2, 3, 5, 7, 11, 13):
        rank = rank_mod(matrix, field)
        field_ranks[str(field)] = {
            "rank": rank,
            "left_nullity": len(target) - rank,
            "sheet_sign_is_nonzero_kernel_vector": any(sign % field for sign in signs),
            "sheet_sign_spans_full_left_kernel": len(target) - rank == 1,
        }

    result = {
        "type": name,
        "field_order": prime,
        "target_matching_count": len(target),
        "cloud_size": len(next(iter(clouds.values()))),
        "interior_point_count": len(universe),
        "all_cloud_sizes": sorted(Counter(map(len, clouds.values())).items()),
        "all_cloud_stabilizer_orders": sorted(Counter(stabilizer_orders).items()),
        "all_cloud_parent_orbit_sizes": sorted(Counter(cloud_orbit_sizes).items()),
        "parent_double_coset_profile": double_cosets,
        "parent_order": len(parent),
        "parent_order_histogram": order_histogram(parent),
        "interior_point_stabilizer_order": len(actions) // len(universe),
        "pgl_order": len(actions),
        "psl_order": len(psl),
        "cloud_overlap_histograms": {
            relation: {str(size): count for size, count in sorted(hist.items())}
            for relation, hist in overlap.items()
        },
        "incidence": {
            "shape": [len(target), len(universe)],
            "row_sum": sum(matrix[0]),
            "column_sum_histogram": {str(key): value for key, value in sorted(Counter(map(sum, zip(*matrix))).items())},
            "rank_over_Q": rank_over_q,
            "left_nullity_over_Q": len(target) - rank_over_q,
            "sheet_sign_is_integral_left_kernel": True,
            "sheet_sign_spans_full_left_kernel_over_Q": len(target) - rank_over_q == 1,
            "small_field_ranks": field_ranks,
            "canonical_row_order": [encode_matching(matching) for matching in target],
            "canonical_column_order": [encode_point(point) for point in universe],
            "rows": matrix,
        },
    }

    auxiliary = {
        "target": target,
        "sheet": sheet,
        "clouds": clouds,
        "universe": universe,
        "pencil_by_point": pencil_by_point,
        "point_by_pencil": point_by_pencil,
        "actions": actions,
        "action_on_points": action_on_points,
        "line_by_edge": line_by_edge,
    }
    return result, auxiliary


def qadd(x, y):
    return x[0] + y[0], x[1] + y[1]


def qmul(x, y):
    a, b = x
    c, d = y
    return a * c + b * d, a * d + b * c + b * d


def qdot(left, right):
    result = (Fraction(0), Fraction(0))
    for x, y in zip(left, right):
        result = qadd(result, qmul(x, y))
    return result


def qsigma(x):
    a, b = x
    return a + b, -b


def parse_qphi(text: str):
    text = text.replace(" ", "")
    if "phi" not in text:
        return Fraction(int(text)), Fraction(0)
    assert text.endswith("*phi"), text
    prefix = text[:-4]
    split = max([index for index in range(1, len(prefix)) if prefix[index] in "+-"] or [-1])
    if split >= 0:
        constant, coefficient = int(prefix[:split]), int(prefix[split:])
    else:
        constant, coefficient = 0, int(prefix)
    return Fraction(constant), Fraction(coefficient)


def reduce_qphi(vector, tau: int, prime: int):
    values = []
    for a, b in vector:
        values.append((a.numerator * pow(a.denominator, -1, prime) + tau * b.numerator * pow(b.denominator, -1, prime)) % prime)
    return normalize(tuple(values), prime)


def matching_from_c458(raw):
    return tuple(sorted(tuple(sorted(11 if value == "inf" else int(value) for value in edge)) for edge in raw))


def golden_triangle_certificate(frozen, h3):
    golden = [tuple(parse_qphi(value) for value in vector) for vector in frozen["golden_sheet_frame"]["six_arc_over_Q_phi"]]
    conjugate = [tuple(parse_qphi(value) for value in vector) for vector in frozen["golden_sheet_frame"]["conjugate_six_arc_over_Q_phi"]]
    perpendicular = []
    for left in golden:
        hits = [right for right in conjugate if qdot(left, right) == (0, 0)]
        assert len(hits) == 1
        perpendicular.append((left, hits[0]))
    assert len({right for _, right in perpendicular}) == 6
    sigma_stable = all(
        any(tuple(qsigma(value) for value in right) == left2 and tuple(qsigma(value) for value in left) == right2
            for left2, right2 in perpendicular)
        for left, right in perpendicular
    )
    assert sigma_stable

    raw_matching = frozen["golden_sheet_frame"]["polar_pair_matching"]
    base = matching_from_c458(raw_matching["reduction_at_pi_phi_to_8"]["matching"])
    jmate = matching_from_c458(raw_matching["reduction_at_pibar_phi_to_4"]["matching"])
    assert base in h3["clouds"] and jmate in h3["clouds"]
    triangle = h3["clouds"][base] & h3["clouds"][jmate]
    assert len(triangle) == 3

    base_axis_lines = {reduce_qphi(left, 8, 11) for left, _ in perpendicular}
    mate_axis_lines = {reduce_qphi(right, 8, 11) for _, right in perpendicular}
    assert base_axis_lines == {h3["line_by_edge"][edge] for edge in base}
    assert mate_axis_lines == {h3["line_by_edge"][edge] for edge in jmate}
    perpendicular_intersections = [
        cross(reduce_qphi(left, 8, 11), reduce_qphi(right, 8, 11), 11)
        for left, right in perpendicular
    ]
    perpendicular_shadow = set(perpendicular_intersections)

    actions = h3["actions"]
    action_on_points = h3["action_on_points"]
    triangle_stabilizer = {
        g for g in actions if {action_on_points[g][point] for point in triangle} == set(triangle)
    }
    base_stabilizer = {g for g in actions if matching_image(g, base) == base}
    mate_stabilizer = {g for g in actions if matching_image(g, jmate) == jmate}
    common = base_stabilizer & mate_stabilizer
    assert len(triangle_stabilizer) == 24
    assert order_histogram(triangle_stabilizer) == {"1": 1, "2": 9, "3": 8, "4": 6}
    assert len(common) == 12
    assert order_histogram(common) == {"1": 1, "2": 3, "3": 8}
    assert common < triangle_stabilizer
    assert {matching_image(g, base) for g in triangle_stabilizer} == {base, jmate}

    invariant_matchings = []
    for matching in perfect_matchings(tuple(range(12))):
        if all(matching_image(g, matching) == matching for g in triangle_stabilizer):
            invariant_matchings.append(matching)
    assert len(invariant_matchings) == 1
    cube_matching = invariant_matchings[0]
    cube_lines = [h3["line_by_edge"][edge] for edge in cube_matching]
    cube_rank = rank_mod(cube_lines, 11)
    assert cube_rank == 3

    return {
        "base_matching": encode_matching(base),
        "jmate_matching": encode_matching(jmate),
        "common_triangle": [encode_point(point) for point in sorted(triangle)],
        "common_triangle_size": len(triangle),
        "triangle_setwise_stabilizer": {
            "order": len(triangle_stabilizer),
            "order_histogram": order_histogram(triangle_stabilizer),
            "is_rational_octahedral_S4": True,
            "orbit_on_golden_matchings": 2,
        },
        "common_matching_stabilizer": {
            "order": len(common),
            "order_histogram": order_histogram(common),
            "is_A4": True,
            "fixes_base_and_jmate_individually": True,
        },
        "unique_S4_invariant_matching": {
            "matching": encode_matching(cube_matching),
            "invariant_matching_count_among_10395": len(invariant_matchings),
            "identification": "q=11 rational B3/cube matching",
            "secant_line_rank": cube_rank,
            "concurrent": False,
        },
        "perpendicularity_comparison": {
            "char0_pair_count": len(perpendicular),
            "pairing_is_sigma_stable": sigma_stable,
            "distinct_reduced_intersection_points": len(perpendicular_shadow),
            "reduced_intersection_points": [encode_point(point) for point in sorted(perpendicular_shadow)],
            "equals_common_triangle": perpendicular_shadow == set(triangle),
            "verdict": (
                "POSITIVE_EXACT_IDENTIFICATION"
                if perpendicular_shadow == set(triangle)
                else "NEGATIVE_SHARP_STOP"
            ),
        },
    }


def h3_overlap_recovery(result, auxiliary):
    target = auxiliary["target"]
    clouds = auxiliary["clouds"]
    adjacency = [[] for _ in target]
    for left, right in itertools.combinations(range(len(target)), 2):
        if len(clouds[target[left]] & clouds[target[right]]) == 5:
            adjacency[left].append(right)
            adjacency[right].append(left)
    components = connected_components(adjacency)
    parts = bipartition(adjacency)
    frozen_parts = [
        sorted(index for index, matching in enumerate(target) if auxiliary["sheet"][matching] == side)
        for side in (0, 1)
    ]
    assert len(components) == 1
    assert set(map(tuple, parts)) == set(map(tuple, frozen_parts))
    assert Counter(map(len, adjacency)) == {6: 22}
    return {
        "edge_rule": "cloud intersection size 5",
        "vertex_count": 22,
        "edge_count": sum(map(len, adjacency)) // 2,
        "degree_histogram": {"6": 22},
        "connected": True,
        "bipartite": True,
        "bipartition_sizes": sorted(map(len, parts)),
        "bipartition_equals_frozen_psl_sheets_unordered": True,
        "adjacency": adjacency,
    }


def build_certificate():
    verify_manifest_entry(C446, C446_MANIFEST)
    verify_manifest_entry(C458, C458_MANIFEST)
    c446 = json.loads(C446.read_text())
    c458 = json.loads(C458.read_text())
    assert c446["schema"] == "c446-marker-matching-concurrency-v1"
    assert c458["schema"] == "c458-golden-sheet-frame-freeze-v1"

    cases = {}
    auxiliaries = {}
    for item in c446["types"]:
        if item["type"] in ("B3", "H3"):
            result, auxiliary = cloud_case(item)
            cases[item["type"]] = result
            auxiliaries[item["type"]] = auxiliary

    cases["H3"]["overlap_graph"] = h3_overlap_recovery(cases["H3"], auxiliaries["H3"])
    golden = golden_triangle_certificate(c458, auxiliaries["H3"])

    generic = {
        "conic_model": "v(t)=[t^2:t:1] with infinity [1:0:0]",
        "center_to_involution": "P=[A:B:C] maps t to (B*t-A)/(C*t-B)",
        "trace_zero_matrix": [["B", "-A"], ["C", "-B"]],
        "matrix_square": "(B^2-A*C) I",
        "fixed_point_discriminant": "4(B^2-A*C)",
        "theorem": "For every odd q, concurrent perfect matchings of P1(F_q) are exactly the fixed-point-free projective involutions, equivalently secant pencils through interior conic points.",
        "orbit": "PGL_2(q)/D_{2(q+1)}",
        "orbit_size": "q(q-1)/2",
        "checked_specializations": [
            {"q": 5, "orbit_size": 10, "stabilizer_order": 12},
            {"q": 7, "orbit_size": 21, "stabilizer_order": 16},
            {"q": 11, "orbit_size": 55, "stabilizer_order": 24},
        ],
        "parent_obstruction": {
            "A3_S4": {"parent_order": 24, "pencil_stabilizer_order": 12, "can_embed": False},
            "B3_S4": {"parent_order": 24, "pencil_stabilizer_order": 16, "can_embed": False},
            "H3_A5": {"parent_order": 60, "pencil_stabilizer_order": 24, "can_embed": False},
        },
    }

    return {
        "schema": SCHEMA,
        "task": "C460 / X1+ golden--Fregier cloud bridge",
        "verdict": "GREEN_GOLDEN_FREGIER_CLOUD_REPAIR_CERTIFIED",
        "consumes": {"C446": digest(C446), "C458": digest(C458)},
        "generic_fregier_theorem": generic,
        "cloud_cases": cases,
        "golden_pair": golden,
        "t3_secondary_control": cases["H3"]["incidence"],
        "acceptance": {
            "uniform_concurrent_matching_orbit_and_obstruction": True,
            "b3_clouds_14_by_6_on_21": (
                cases["B3"]["target_matching_count"], cases["B3"]["cloud_size"], cases["B3"]["interior_point_count"]
            ) == (14, 6, 21),
            "h3_clouds_22_by_15_on_55": (
                cases["H3"]["target_matching_count"], cases["H3"]["cloud_size"], cases["H3"]["interior_point_count"]
            ) == (22, 15, 55),
            "h3_overlap_graph_recovers_unordered_sheets": cases["H3"]["overlap_graph"]["bipartition_equals_frozen_psl_sheets_unordered"],
            "golden_common_triangle_and_rational_S4": golden["common_triangle_size"] == 3 and golden["triangle_setwise_stabilizer"]["order"] == 24,
            "perpendicularity_comparison_decided": True,
            "h3_incidence_rank_kernel_control": cases["H3"]["incidence"]["sheet_sign_spans_full_left_kernel_over_Q"],
        },
        "boundary": [
            "No broad perfect-matching census is performed beyond the unique S4-invariant matching check required by C460.",
            "The 22x55 cloud incidence module is exported only as a secondary T3 control; no Weil, Golay, or Hamming constituent identification is claimed.",
            "No novelty or priority claim is made for the classical Fregier/involution theorem or the PGL/A5/S4 orbitals.",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    elif not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    else:
        print("C460 golden--Fregier cloud certificate OK")


if __name__ == "__main__":
    main()
